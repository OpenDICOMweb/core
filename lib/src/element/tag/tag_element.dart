// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/dataset.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/element/tag/float.dart';
import 'package:core/src/element/tag/integer.dart';
import 'package:core/src/element/tag/pixel_data.dart';
import 'package:core/src/element/tag/sequence.dart';
import 'package:core/src/element/tag/string.dart';
import 'package:core/src/element/tag/tag_mixin_base.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/string.dart';
import 'package:core/src/value/uid.dart';
import 'package:core/src/vr.dart';

typedef Element TagElementMaker(Tag tag, Iterable vList, [int vfLengthField]);
typedef TagElement MakeFrom(Element e);
typedef TagElement MakeFromByteData(ByteData bd);
typedef Element Makefrom(Element e);
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

  // Urgent Jim: make sure private tags are not unknown
  static Element make(Tag oldTag, Iterable values, int vrIndex,
          [int vfLengthField]) {
     assert(oldTag.vrIndex == vrIndex || vrIndex == kUNIndex,
     'Tag VR: ${oldTag.vrIndex}, vrIndex, $vrIndex');
     final newTag = Tag.lookupByCode(oldTag.code);
     if (oldTag != newTag) print('changed from $oldTag to $newTag');
    return _tagMakers[vrIndex](oldTag, values);
  }

  static Element from(Element e, int vrIndex, [int vfLengthField]) =>
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

  static Element tagElementFrom(Element e, int vrIndex, [TransferSyntax ts]) {
//    print('fromBD vrIndex: $vrIndex');
    if (vrIndex > 30) return invalidVRIndex(vrIndex, null, null);
    if (e is PixelData)
      return _bdePixelMakers[vrIndex](e, ts);
    return _bdeMakers[vrIndex](e);
  }

  static const List<MakeFromPixelDataBDE> _bdePixelMakers =
  const <MakeFromPixelDataBDE>[
    _vrIndexPixelDataError,
    OBtagPixelData.from,
    OWtagPixelData.from,
    UNtagPixelData.from
    ];

  static Null _vrIndexPixelDataError(Element e, [TransferSyntax ts]) =>
      invalidElementIndex(0);

  static const List<Makefrom> _bdeMakers = const <Makefrom>[
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

  static Element maybeUndefinedFrom(Element e, int vrIndex) {
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

  static Element pixelDataFrom(Element e, TransferSyntax ts, int vrIndex) {
    assert(vrIndex == e.vrIndex);
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
