// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset/errors.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/integer/integer.dart';
import 'package:core/src/element/base/integer/pixel_data.dart';
import 'package:core/src/element/base/mixin/tag_mixin_base.dart';
import 'package:core/src/element/base/string.dart';
import 'package:core/src/element/errors.dart';
import 'package:core/src/element/tag/export.dart';
import 'package:core/src/string/ascii.dart';
import 'package:core/src/tag/export.dart';
import 'package:core/src/uid/well_known/transfer_syntax.dart';
import 'package:core/src/vr/vr.dart';

typedef Element TagElementMaker(Tag tag, Iterable vList, [int vfLengthField]);
typedef TagElement MakeFrom(Element e);
typedef TagElement MakeFromByteData(ByteData bd);
typedef Element MakeFromBDE(Element e);
typedef IntBase MakeFromPixelDataBDE(IntBase e, [TransferSyntax ts]);

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
  //Fix when fast_tag is ready
  int get index => tag.code;
  int get code => tag.code;
  String get keyword => tag.keyword;
  String get name => tag.name;

  // VR related Getters
  @override
  int get vrCode => tag.vrCode;

  // **** VM Related Getters
  @override
  VM get vm => tag.vm;
  @override
  int get vmMin => tag.vm.min;
  @override
  int get vmMax => tag.vm.max;
  @override
  int get vmColumns => tag.vm.columns;

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

  static Element make(Tag tag, Iterable values, int vrIndex,
          [int vfLengthField]) {
     assert(tag.vrIndex == vrIndex || vrIndex == kUNIndex,
     'Tag VR: ${tag.vrIndex}, vrIndex, $vrIndex');
     print('vrIndex: ${vrIdFromIndex(vrIndex)}');
    return _tagMakers[vrIndex](tag, values);
  }

  static Element from(Element e, int vrIndex) =>
  // TODO: make work with vfLengthField
    //  make(e.tag, e.values, vrIndex ?? e.vrIndex, e.vfLengthField);
  make(e.tag, e.values, vrIndex ?? e.vrIndex);

  static final _tagMakers = <Function>[
    SQtag.make,
    // Maybe Undefined Lengths
    OBtag.make, OWtag.make, UNtag.make, // No reformat

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

  static Element makeMaybeUndefinedLength(
      Tag tag, Iterable values, int vfLengthField, int vrIndex) {
    switch (vrIndex) {
      case kOBIndex:
        return OBtagPixelData.fromBytes(tag, values, vfLengthField);
      case kUNIndex:
        return UNtagPixelData.fromBytes(tag, values, vfLengthField);
      case kOWIndex:
        return OWtagPixelData.fromBytes(tag, values, vfLengthField);
      case kSQIndex:
        return OWtagPixelData.fromBytes(tag, values, vfLengthField);
      default:
        return invalidVRIndex(vrIndex, null, null);
    }
  }

/*
  static Element fromEB(EBytes eb, [int vrIndex]) => _eByteMakers[vrIndex](eb);


  static final List<MakeFromEBytes> _eByteMakers = <MakeFromEBytes>[
    _sqError,
    // Maybe Undefined Lengths
    OBtag.fromEBytes, OWtag.fromEBytes, UNtag.fromEBytes, // No reformat

    // EVR Long
    ODtag.fromEBytes, OFtag.fromEBytes, OLtag.fromEBytes,
    UCtag.fromEBytes, URtag.fromEBytes, UTtag.fromEBytes,

    // EVR Short
    AEtag.fromEBytes, AStag.fromEBytes, ATtag.fromEBytes,
    CStag.fromEBytes, DAtag.fromEBytes, DStag.fromEBytes,
    DTtag.fromEBytes, FDtag.fromEBytes, FLtag.fromEBytes,
    IStag.fromEBytes, LOtag.fromEBytes, LTtag.fromEBytes,
    PNtag.fromEBytes, SHtag.fromEBytes, SLtag.fromEBytes,
    SStag.fromEBytes, STtag.fromEBytes, TMtag.fromEBytes,
    UItag.fromEBytes, ULtag.fromEBytes, UStag.fromEBytes,
  ];
*/

//  static Null _sqError(EBytes eb) => invalidElementIndex(0);

  static Element fromBDE(Element bd, int vrIndex, [TransferSyntax ts]) {
//    print('fromBD vrIndex: $vrIndex');
    if (vrIndex > 30) return invalidVRIndex(vrIndex, null, null);
    if (bd is PixelData)
      return _bdePixelMakers[vrIndex](bd, ts);
    return _bdeMakers[vrIndex](bd);
  }

  static const List<MakeFromPixelDataBDE> _bdePixelMakers =
  const <MakeFromPixelDataBDE>[
    _vrIndexPixelDataError,
    OBtagPixelData.fromBDE,
    OWtagPixelData.fromBDE,
    UNtagPixelData.fromBDE
    ];

  static Null _vrIndexPixelDataError(Element bd, [TransferSyntax ts]) =>
      invalidElementIndex(0);

  static const List<MakeFromBDE> _bdeMakers = const <MakeFromBDE>[
    _vrIndexError,
    // Maybe Undefined Lengths
    OBtag.fromBDE, OWtag.fromBDE, UNtag.fromBDE, // No reformat

    // EVR Long
    ODtag.fromBDE, OFtag.fromBDE, OLtag.fromBDE,
    UCtag.fromBDE, URtag.fromBDE, UTtag.fromBDE,

    // EVR Short
    AEtag.fromBDE, AStag.fromBDE, ATtag.fromBDE,
    CStag.fromBDE, DAtag.fromBDE, DStag.fromBDE,
    DTtag.fromBDE, FDtag.fromBDE, FLtag.fromBDE,
    IStag.fromBDE, LOtag.fromBDE, LTtag.fromBDE,
    PNtag.fromBDE, SHtag.fromBDE, SLtag.fromBDE,
    SStag.fromBDE, STtag.fromBDE, TMtag.fromBDE,
    UItag.fromBDE, ULtag.fromBDE, UStag.fromBDE,
  ];

  static Null _vrIndexError(Element bd) => invalidElementIndex(0);

  static Element maybeUndefinedFromBDE(Element e, int vrIndex) {
    assert(vrIndex == e.vrIndex);
    switch (vrIndex) {
      case kOBIndex:
        return OBtag.fromBDE(e);
      case kUNIndex:
        return UNtag.fromBDE(e);
      case kOWIndex:
        return OWtag.fromBDE(e);
      default:
        return invalidVRIndex(vrIndex, null, null);
    }
  }

  static Element pixelDataFromBDE(Element e, TransferSyntax ts, int vrIndex) {
    assert(vrIndex == e.vrIndex);
    if (e.tag != PTag.kPixelData)
      return invalidKey(e.tag, 'Invalid Tag Code for PixelData');
    switch (vrIndex) {
      case kOBIndex:
        return OBtagPixelData.fromBDE(e, ts);
      case kUNIndex:
        return UNtagPixelData.fromBDE(e, ts);
      case kOWIndex:
        return OWtagPixelData.fromBDE(e, ts);
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
