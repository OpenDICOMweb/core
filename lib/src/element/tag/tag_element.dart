//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/src/base.dart';
import 'package:core/src/dataset.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/element/tag.dart';
import 'package:core/src/element/tag/integer.dart';
import 'package:core/src/element/tag/pixel_data.dart';
import 'package:core/src/element/tag/sequence.dart';
import 'package:core/src/element/tag/string.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/string.dart';
import 'package:core/src/value/uid.dart';
import 'package:core/src/vr.dart';

typedef Element _MakeFromElement(Element e);
typedef Element _MakeFromBytes(Tag tag, Bytes bytes, [int vfLengthField]);

typedef Element _MakePixelFromDataElement(IntBase e, [TransferSyntax ts]);
typedef Element _MakePixelDataFromBytes(Tag tag, Bytes bytes,
    [int vfLengthField, VFFragments fragments, TransferSyntax ts]);

/// Tag Mixin Class
///
/// This mixin defines the interface to DICOM Tags, where a Tag is
/// a semantic identifier for an element.
abstract class TagElement<V> implements TagMixinBase<int, V> {
  // **** Tag Identifiers
  @override
  Tag get tag;
  @override
  int get key => tag.code;
/*

  //Fix when fast_tag is ready
  int get index => tag.code;
  int get code => tag.code;
  String get keyword => tag.keyword;
  String get name => tag.name;
*/

/*
  // VR related Getters
  @override
  int get vrCode => tag.vrCode;

  // **** VM Related Getters
  @override
  //VM get vm => tag.vm;
  @override
  int get vmMin => tag.vm.min;
  @override
  int get vmMax => tag.vm.max;
  @override
  int get vmColumns => tag.vm.columns;
*/

  // **** Value Field related Getters ****

  @override
  EType get eType => tag.type;
  @override
  int get eTypeIndex => tag.type.index;
  // TODO: fix
  @override
  ETypePredicate get eTypePredicate => throw new UnimplementedError();

  // TODO: fix to IE.patient.index
  @override
  IEType get ieType => IEType.kInstance;

  @override
  int get ieIndex => ieType.index;

  @override
  String get ieLevel => ieType.level;

  //TODO: fix
  @override
  int get deIdIndex => 0;

  //TODO: fix
//  @override
//	DeIdMethod get deIdMethod => tag.deIdMethod;

  /// Returns true if _this_ is a Data Element defined by the DICOM Standard.
  @override
  bool get isPublic => tag.isPublic;
  @override
  bool get isPrivate => tag.isPrivate;

  @override
  bool get isRetired => tag.isRetired;

  /// Creates an a [TagElement] from a [Bytes] containing a binary encoded
  /// [Element].
  static Element makeFromBytes(
      Dataset ds, int code, Bytes eBytes, int vrIndex, int vfOffset,
      [int vfLengthField]) {
    final vf = eBytes.toBytes(
        eBytes.offset + vfOffset, eBytes.length - vfOffset);
    final tag = lookupTagByCode(ds, code, vrIndex);
    return _fromBytesMakers[vrIndex](tag, vf, vfLengthField);
  }

  /// Returns a new [Element] based on the arguments.
  ///
  /// _Note_: The will create Private Creator ([PC]) [Element]s, but
  ///         not Private Data [Element]s.
  static Element makeFromCode(
      Dataset ds, int code, Iterable values, int vrIndex,
      [int vfLengthField]) {
    assert(vrIndex != kSQIndex);
    final tag = lookupTagByCode(ds, code, vrIndex);
    final tagVRIndex = tag.vrIndex;

    return (code == kPixelData)
        ? makePixelDataFromTag(ds, tag, values, tagVRIndex, vfLengthField)
        : _fromTagMakers[tagVRIndex](tag, values, vfLengthField);
  }

  /// Creates an [SQtag] [Element].
  static SQ makeSequenceFromCode(
      Dataset parent, int code,
      [List<TagItem> items, int vfLengthField, Bytes bytes]) {
    final tag = lookupTagByCode(parent, code, kSQIndex);
    assert(tag.vrIndex == kSQIndex);
    final values = (items == null)  ? <TagItem>[] : items;
    return new SQtag(parent, tag, values, vfLengthField, bytes);
  }

  static SQ makeSequenceFromTag(Dataset parent, Tag tag, List<TagItem> items,
          [int vfLengthField, Bytes bytes]) =>
      new SQtag(parent, tag, items, vfLengthField, bytes);

  static Element makeFromElement(Dataset ds, Element e,
          [int vrIndex, int vfLengthField]) =>
      makeFromCode(ds, e.code, e.values, vrIndex ?? e.vrIndex,
          vfLengthField ?? e.vfLengthField);

  /// Return a new [TagElement]. This assumes the caller has handled
  /// Private Elements, etc.
  static Element makeFromTag(Tag tag, Iterable values, int vrIndex,
          [int vfLengthField]) =>
      _fromTagMakers[vrIndex](tag, values, vfLengthField);

  static Element makeMaybeUndefinedLength(
      Tag tag, Iterable values, int vfLengthField, int vrIndex) {
    switch (vrIndex) {
      case kOBIndex:
        return OBtagPixelData.fromUint8List(tag, values, vfLengthField);
      case kUNIndex:
        return UNtagPixelData.fromUint8List(tag, values, vfLengthField);
      case kOWIndex:
        return OWtagPixelData.fromUint8List(tag, values, vfLengthField);
      case kSQIndex:
        return OWtagPixelData.fromUint8List(tag, values, vfLengthField);
      default:
        return invalidVRIndex(vrIndex, null, null);
    }
  }

/*
  /// Insert a DICOM media type header in the first 8 or 12
  /// bytes depending on the VR of the Element.
  ByteData getDcmBytes(int vfLength) {
    final bd = new ByteData(tag.dcmHeaderLength + vfLength)
      ..setUint32(0, code)
      ..setUint16(4, vrCode);
    if (tag.hasShortVF) {
      bd.setUint16(6, bd.lengthInBytes);
    } else {
      bd.setUint16(8, bd.lengthInBytes);
    }
    return bd;
  }
*/

  static final _fromTagMakers = <Function>[
    // SQtag.make
    __vrIndexError,
    // Maybe Undefined Lengths
    OBtag.make, OWtag.make, UNtag.make, // No reformat
    //  __vrIndexError, __vrIndexError, __vrIndexError,
    // EVR Long
    ODtag.make, OFtag.make, OLtag.make,
    UCtag.make, URtag.make, UTtag.make,

    // EVR Short
    AEtag.make, AStag.make, ATtag.make,
    CStag.make, DAtag.make, DStag.make,
    DTtag.make, FDtag.make, FLtag.make,
    IStag.make, LOtag.make, LTtag.make,
    PNtag.make, SHtag.make, SLtag.make,
    SStag.make, STtag.make, TMtag.make,
    UItag.make, ULtag.make, UStag.make,
  ];

  static final List<_MakeFromBytes> _fromBytesMakers = <_MakeFromBytes>[
    __vrIndexError,
    // Maybe Undefined Lengths
    OBtag.fromBytes, OWtag.fromBytes, UNtag.fromBytes, // No reformat

    // EVR Long
    ODtag.fromBytes, OFtag.fromBytes, OLtag.fromBytes,
    UCtag.fromBytes, URtag.fromBytes, UTtag.fromBytes,

    // EVR Short
    AEtag.fromBytes, AStag.fromBytes, ATtag.fromBytes,
    CStag.fromBytes, DAtag.fromBytes, DStag.fromBytes,
    DTtag.fromBytes, FDtag.fromBytes, FLtag.fromBytes,
    IStag.fromBytes, LOtag.fromBytes, LTtag.fromBytes,
    PNtag.fromBytes, SHtag.fromBytes, SLtag.fromBytes,
    SStag.fromBytes, STtag.fromBytes, TMtag.fromBytes,
    UItag.fromBytes, ULtag.fromBytes, UStag.fromBytes,
  ];

  static Null __vrIndexError(Tag tag, Bytes eb, [int vfLengthField]) =>
      invalidElementIndex(0);

  static Element makePixelDataFromCode(
      Dataset ds, int code, Bytes vfBytes, int vrIndex,
      [int vfLengthField, TransferSyntax ts, VFFragments fragments]) {
    assert(vrIndex >= kOBIndex && vrIndex <= kUNIndex && vrIndex != kSQIndex);
    final tag = lookupTagByCode(ds, code, vrIndex);
    final tagVRIndex = tag.vrIndex;
    return _tagPixelDataMakers[tagVRIndex](
        tag, vfBytes, vfLengthField, fragments, ts);
  }
/*

  // Note: this uses [vfBytes] not [eBytes].
  static Element makePixelDataFromBytes(
      Dataset ds, int code, Bytes vfBytes, int vrIndex,
      [int vfLengthField, TransferSyntax ts, VFFragments fragments]) {
    assert(vrIndex >= kOBIndex && vrIndex <= kUNIndex);
    final tag = _lookupTagByCode(ds, code, vfBytes, vrIndex);
    return _tagPixelDataMakers[vrIndex](
        tag, vfBytes, vfLengthField, fragments, ts);
  }
*/

  static Element makePixelDataFromTag(
      Dataset ds, Tag tag, Bytes vfBytes, int vrIndex,
      [int vfLengthField, TransferSyntax ts, VFFragments fragments]) {
    assert(vrIndex >= kOBIndex && vrIndex <= kUNIndex);
    return _tagPixelDataMakers[vrIndex](
        tag, vfBytes, vfLengthField, fragments, ts);
  }

  static const List<_MakePixelDataFromBytes> _tagPixelDataMakers =
      const <_MakePixelDataFromBytes>[
    _vrIndexPixelDataFromError,
    OBtagPixelData.fromBytes,
    OWtagPixelData.fromBytes,
    UNtagPixelData.fromBytes
  ];

  static Null _vrIndexPixelDataFromError(Tag tag, Bytes bytes,
          [int vfLengthField, VFFragments fragments, TransferSyntax ts]) =>
      invalidElementIndex(0);

  static const List<_MakePixelFromDataElement> _bdePixelMakers =
      const <_MakePixelFromDataElement>[
    _vrIndexPixelDataError,
    OBtagPixelData.from,
    OWtagPixelData.from,
    UNtagPixelData.from
  ];

  static Null _vrIndexPixelDataError(Element e, [TransferSyntax ts]) =>
      invalidElementIndex(0);

  static const List<_MakeFromElement> _bdeMakers = const <_MakeFromElement>[
    _vrIndexError,
    // Maybe Undefined Lengths
    OBtag.from, OWtag.from, UNtag.from, // No reformat

    // EVR Long
    ODtag.from, OFtag.from, OLtag.from,
    UCtag.from, URtag.from, UTtag.from,

    // EVR Short
    AEtag.from, AStag.from, ATtag.from,
    CStag.from, DAtag.from, DStag.from,
    DTtag.from, FDtag.from, FLtag.from,
    IStag.from, LOtag.from, LTtag.from,
    PNtag.from, SHtag.from, SLtag.from,
    SStag.from, STtag.from, TMtag.from,
    UItag.from, ULtag.from, UStag.from,
  ];

  static Null _vrIndexError(Element bd) => invalidElementIndex(0);

  static Element maybeUndefinedFrom(Dataset ds, Element e, int vrIndex) {
    assert(vrIndex == e.vrIndex);
    switch (vrIndex) {
      case kOBIndex:
        return OBtag.from(e);
      case kUNIndex:
        return UNtag.from(e);
      case kOWIndex:
        return OWtag.from(e);
      default:
        return invalidVRIndex(vrIndex, null, null);
    }
  }

  static Element pixelDataFrom(Dataset ds, Element e,
      [TransferSyntax ts, int vrIndex]) {
    //assert(vrIndex == e.vrIndex);
    if (e.tag != PTag.kPixelData)
      return invalidKey(e.tag, 'Invalid Tag Code for PixelData');
    switch (vrIndex) {
      case kOBIndex:
        return OBtagPixelData.from(e, ts);
      case kUNIndex:
        return UNtagPixelData.from(e, ts);
      case kOWIndex:
        return OWtagPixelData.from(e, ts);
      default:
        return invalidVRIndex(vrIndex, null, null);
    }
  }
}

abstract class TagStringMixin {
  // **** Interface
  ByteData get bd;
  int get eLength;
  int get padChar;
  int get vfOffset;
  int get vfLengthField;
  StringBase update([Iterable<String> vList]);

  // **** End interface

  /// Returns the actual length in bytes after removing any padding chars.
  // Floats always have a valid (defined length) vfLengthField.
  int get vfLength {
    final vf0 = vfOffset;
    final lib = bd.lengthInBytes;
    final length = lib - vf0;
    assert(length >= 0);
    return length;
  }

  int get valuesLength {
    if (vfLength == 0) return 0;
    var count = 1;
    for (var i = vfOffset; i < eLength; i++)
      if (bd.getUint8(i) == kBackslash) count++;
    return count;
  }
}
