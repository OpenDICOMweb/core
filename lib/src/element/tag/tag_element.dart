//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/element/tag.dart';
import 'package:core/src/element/tag/integer.dart';
import 'package:core/src/element/tag/sequence.dart';
import 'package:core/src/element/tag/string.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/value/empty_list.dart';
import 'package:core/src/vr_base.dart';

/// Tag Mixin Class
///
/// This mixin defines the interface to DICOM Tags, where a Tag is
/// a semantic identifier for an element.
abstract class TagElement<V> {
  V get value;

  /// The DICOM Element Definition. In the _ODW_ _SDK_ this is called a "_Tag_".
  Tag get tag {
    final pCode = code & 0x1FFFF;
    if (pCode >= 0x10010 && pCode <= 0x100FF) {
      return PCTag.lookupByToken(code, vrIndex, '');
    }
    return Tag.lookupByCode(code, vrIndex, null);
  }

  int get index => tag.index;

  int get code => tag.code;

  String get keyword => tag.keyword;
  String get name => tag.name;


  /// The index ([vrIndex]) of the Value Representation for this Element.
  /// Since this depends on the [tag] lookkup, the [vrIndex] might be
  /// [kUNIndex] for Private [Element]s.
  int get vrIndex {
    final vrIndex = tag.vrIndex;
    if (isSpecialVRIndex(vrIndex)) {
      log.debug('Using kUNIndex for $tag');
      return kUNIndex;
    }
    return vrIndex;
  }


  int get vmMin => tag.vmMin;
  int get vmMax => tag.vmMax;
  int get vmColumns => tag.vmColumns;

  EType get eType => tag.type;
  int get eTypeIndex => tag.type.index;

  ETypePredicate get eTypePredicate => throw new UnimplementedError();

  IEType get ieType => IEType.kInstance;

  int get ieIndex => ieType.index;

  String get ieLevel => ieType.level;

  int get deIdIndex => 0;
//  @override
//  DeIdMethod get deIdMethod => tag.deIdMethod;

  /// Returns true if _this_ is a Data Element defined by the DICOM Standard.
  bool get isPublic => tag.isPublic;
  bool get isPrivate => tag.isPrivate;
  bool get isRetired => tag.isRetired;

  /// Returns a new [Element] based on the arguments.
  ///
  /// _Note_: The will create Private Creator ([PC]) [Element]s, but
  ///         not Private Data [Element]s.
  static Element makeFromCode(
      int code, Iterable values, int vrIndex, Dataset ds,
      [int vfLengthField]) {
    final tag = lookupTagByCode(ds, code, vrIndex);
    final tagVRIndex = tag.vrIndex;
    return _fromValuesMakers[tagVRIndex](tag, values, vfLengthField);
  }

  static Element makeFromBase64(int code, String s, int vrIndex, Dataset ds,
      [int vfLengthField]) {
    final bytes = Bytes.fromBase64(s);
    final tag = lookupTagByCode(ds, code, vrIndex);
    final tagVRIndex = tag.vrIndex;
    return _fromValuesMakers[tagVRIndex](code, bytes, vfLengthField);
  }

  static Element makeFromElement(Dataset ds, Element e,
          [int vrIndex, int vfLengthField]) =>
      makeFromCode(e.code, e.values, vrIndex ?? e.vrIndex, ds,
          vfLengthField ?? e.vfLengthField);

  /// Return a new [TagElement]. This assumes the caller has handled
  /// Private Elements, etc.
  static Element makeFromTag(Tag tag, Iterable values, int vrIndex,
          [int vfLengthField]) =>
      _fromValuesMakers[vrIndex](tag, values, vfLengthField);

  static Element makeMaybeUndefinedLength(
      Tag tag, Iterable values, int vfLengthField, int vrIndex) {
    switch (vrIndex) {
      case kOBIndex:
        return OBtagPixelData.fromValues(tag, values, vfLengthField);
      case kUNIndex:
        return UNtagPixelData.fromValues(tag, values, vfLengthField);
      case kOWIndex:
        return OWtagPixelData.fromValues(tag, values, vfLengthField);
      case kSQIndex:
        return OWtagPixelData.fromValues(tag, values, vfLengthField);
      default:
        return invalidVRIndex(vrIndex, null, null);
    }
  }

  static final _fromValuesMakers = <Function>[
    // SQtag.make
    SQtag.fromValues,
    // Maybe Undefined Lengths
    OBtag.fromValues, OWtag.fromValues, UNtag.fromValues, // No reformat
    //  __vrIndexError, __vrIndexError, __vrIndexError,
    // EVR Long
    ODtag.fromValues, OFtag.fromValues, OLtag.fromValues,
    UCtag.fromValues, URtag.fromValues, UTtag.fromValues,

    // EVR Short
    AEtag.fromValues, AStag.fromValues, ATtag.fromValues,
    CStag.fromValues, DAtag.fromValues, DStag.fromValues,
    DTtag.fromValues, FDtag.fromValues, FLtag.fromValues,
    IStag.fromValues, LOtag.fromValues, LTtag.fromValues,
    PNtag.fromValues, SHtag.fromValues, SLtag.fromValues,
    SStag.fromValues, STtag.fromValues, TMtag.fromValues,
    UItag.fromValues, ULtag.fromValues, UStag.fromValues,
  ];

  /// Creates a [TagElement] from [DicomBytes] containing a binary encoded
  /// [Element].
  static Element makeFromBytes(
      Dataset ds, int code, DicomBytes eBytes, int vrIndex, int vfOffset,
      [int vfLengthField]) {
    final vf = eBytes.view(eBytes.offset + vfOffset, eBytes.length - vfOffset);
    final tag = lookupTagByCode(ds, code, vrIndex);
    return _fromBytesMakers[vrIndex](tag, vf, vfLengthField);
  }

  static final List<Function> _fromBytesMakers = <Function>[
    SQtag.fromBytes,
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

  /// Creates an [SQtag] [Element].
  static SQ makeSequenceFromCode(Dataset parent, int code, List<TagItem> items,
      int vfLengthField, Bytes bytes) {
    final tag = lookupTagByCode(parent, code, kSQIndex);
    assert(tag.vrIndex == kSQIndex, 'vrIndex: ${tag.vrIndex}');
    final values = (items == null) ? <TagItem>[] : items;
    return new SQtag(parent, tag, values, vfLengthField, bytes);
  }

  static SQ makeSequenceFromTag(Dataset parent, Tag tag, List<TagItem> items,
          [int vfLengthField, Bytes bytes]) =>
      new SQtag(parent, tag, items, vfLengthField, bytes);
}
