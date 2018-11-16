//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/dataset.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/element/tag.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/values.dart';
import 'package:core/src/vr.dart';

// ignore_for_file: public_member_api_docs

/// Tag Mixin Class
///
/// This mixin defines the interface to DICOM Tags, where a Tag is
/// a semantic identifier for an element.
mixin TagElement<V> {
  V operator [](int index);

  /// The DICOM Element Definition. In the _ODW_ _SDK_ this is called a "_Tag_".
  Tag get tag;
//  List<V> get values;

  /// The length of values;
  int get length;

  List<V> get emptyList;

  bool get hasValidValues;

  Uint8List get bulkdata;

  // **** End of Interface

  int get code => tag.code;

// TODO: ETypePredicate get eTypePredicate => throw  UnimplementedError();

  IEType get ieType => IEType.kInstance;

  int get ieIndex => ieType.index;

  String get ieLevel => ieType.level;

  int get deIdIndex => 0;

  /// Returns true if _this_ is a Data Element defined by the DICOM Standard.
  bool get isPublic => tag.isPublic;
  bool get isPrivate => tag.isPrivate;
  bool get isRetired => tag.isRetired;

  static bool _isPrivateCreator(int code) {
    final pCode = code & 0x1FFFF;
    return pCode >= 0x10010 && pCode <= 0x100FF;
  }

  static PC _getPCTagFromBytes(int code, DicomBytes bytes) {
    final token = bytes.vfBytes.stringFromUtf8().trim();
    final tag = PCTag.lookupByToken(code, bytes.vrIndex, token);
    return PCtag.fromBytes(tag, bytes.vfBytes);
  }

  static PC _getPCTag(int code, int vrIndex, List<String> values) {
    if (values == null || values.length > 2) badValues(values);
    final token = (values.isEmpty) ? '' : values[0];
    // Issue: should this be forcing kLOIndex
    Tag tag = PCTag.lookupByToken(code, kLOIndex, token);
    // Issue: should this be forcing kLOIndex
    tag ??= PCTagUnknown(code, kLOIndex, token);
    return PCtag(tag, StringList.from([token]));
  }

  /// Creates a [TagElement] from [DicomBytes] containing a binary encoded
  /// [Element].
  static Element fromBytes(DicomBytes bytes, Dataset ds, {bool isEvr}) {
    final code = bytes.code;
    if (_isPrivateCreator(code)) return _getPCTagFromBytes(code, bytes);

    final vrIndex = bytes.vrIndex;
    final tag = lookupTagByCode(code, vrIndex, ds);
    final index = getValidVR(vrIndex, tag.vrIndex);
    final charset = ds == null ? utf8 : ds.charset;
    return (index == kSQIndex)
        ? SQtag.fromBytes(ds, <ByteItem>[], bytes)
        : _bytesMakers[index](tag, bytes.vfBytes, charset);
  }

  static final List<Function> _bytesMakers = <Function>[
    UNtag.fromBytes, // No reformat
    SQtag.fromBytes,
    // Maybe Undefined Lengths
    OBtag.fromBytes, OWtag.fromBytes,

    // EVR Long
    ODtag.fromBytes, OFtag.fromBytes, OLtag.fromBytes,
    UCtag.fromBytes, URtag.fromBytes, UTtag.fromBytes,

    // EVR Short
    AEtag.fromBytes, AStag.fromBytes, CStag.fromBytes,
    DAtag.fromBytes, DStag.fromBytes, DTtag.fromBytes,
    IStag.fromBytes, LOtag.fromBytes, LTtag.fromBytes,
    PNtag.fromBytes, SHtag.fromBytes, STtag.fromBytes,
    TMtag.fromBytes, UItag.fromBytes,

    ATtag.fromBytes, FDtag.fromBytes, FLtag.fromBytes,
    SLtag.fromBytes, SStag.fromBytes, ULtag.fromBytes,
    UStag.fromBytes,
  ];

  static Element maybeUndefinedFromBytes(DicomBytes bytes,
      [Dataset ds, TransferSyntax ts]) {
    final code = bytes.code;
    // Note: This shouldn't happen, but it does.
    if (_isPrivateCreator(code)) return _getPCTagFromBytes(code, bytes);

    final vrIndex = bytes.vrIndex;
    assert(vrIndex >= 0 && vrIndex < 4);
    final tag = lookupTagByCode(code, vrIndex, ds);
    final index = getValidVR(vrIndex, tag.vrIndex);
    return _undefinedBytesMakers[index](bytes, ds, ts);
  }

  // Elements that may have undefined lengths.
  static final List<Function> _undefinedBytesMakers = <Function>[
    SQtag.fromBytes, // stop reformat
    OBtag.fromBytes, OWtag.fromBytes, UNtag.fromBytes
  ];

  /// Returns a  [Element] based on the arguments.
  static Element fromValues(int code, int vrIndex, List values, Dataset ds,
      [Charset charset = utf8Charset]) {
    if (_isPrivateCreator(code)) return _getPCTag(code, vrIndex, values);
    final tag = lookupTagByCode(code, vrIndex, ds);
    final index = getValidVR(vrIndex, tag.vrIndex);
    return fromTag(tag, values, index);
  }

  /// Return a  [TagElement]. This assumes the caller has handled
  /// Private Elements, etc.
  static Element fromTag(Tag tag, Iterable values, int vrIndex,
          [Dataset ds, TransferSyntax ts]) =>
      (tag.code == kPixelData)
          ? _pixelDataFromValues(tag, values, vrIndex, ds, ts)
          : _fromValuesMakers[vrIndex](tag, values);

  static Element _pixelDataFromValues(Tag tag, Iterable values, int vrIndex,
      [Dataset ds, TransferSyntax ts]) {
    final index = getPixelDataVR(tag.code, vrIndex, ds, ts);
    return _fromValuesPixelDataMakers[index](values, ts);
  }

  // Elements that may have undefined lengths.
  static final List<Function> _fromValuesPixelDataMakers = <Function>[
    UNtagPixelData.fromValues,
    null,
    OBtagPixelData.fromValues,
    OWtagPixelData.fromValues
  ];

  static final _fromValuesMakers = <Function>[
    UNtag.fromValues,
    // SQtag.make
    SQtag.fromValues,
    // Maybe Undefined Lengths
    OBtag.fromValues, OWtag.fromValues, // No reformat
    //  __vrIndexError, __vrIndexError, __vrIndexError,
    // EVR Long
    ODtag.fromValues, OFtag.fromValues, OLtag.fromValues,

    UCtag.fromValues, URtag.fromValues, UTtag.fromValues,

    // EVR Short
    AEtag.fromValues, AStag.fromValues, CStag.fromValues,
    DAtag.fromValues, DStag.fromValues, DTtag.fromValues,
    IStag.fromValues, LOtag.fromValues, LTtag.fromValues,
    PNtag.fromValues, SHtag.fromValues, STtag.fromValues,
    TMtag.fromValues, UItag.fromValues,

    ATtag.fromValues, FDtag.fromValues, FLtag.fromValues,
    SLtag.fromValues, SStag.fromValues, ULtag.fromValues,
    UStag.fromValues,
  ];

  /// Creates an [SQtag] [Element].
  static SQ sqFromCode(
      Dataset parent, int code, List<TagItem> items) {
    final tag = lookupTagByCode(code, kSQIndex, parent);
    assert(tag.vrIndex == kSQIndex, 'vrIndex: ${tag.vrIndex}');
    final values = (items == null) ? <TagItem>[] : items;
    return SQtag(parent, tag, values);
  }

  static SQ sqFromTag(Dataset parent, Tag tag, List<TagItem> items,
          [int vfLengthField]) =>
      SQtag(parent, tag, items);
}
