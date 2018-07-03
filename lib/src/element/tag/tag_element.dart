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
import 'package:core/src/global.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/values.dart';
import 'package:core/src/vr.dart';

/// Tag Mixin Class
///
/// This mixin defines the interface to DICOM Tags, where a Tag is
/// a semantic identifier for an element.
abstract class TagElement<V> {
  /// The DICOM Element Definition. In the _ODW_ _SDK_ this is called a "_Tag_".
  Tag get tag;
  List<V> get values;
  set values(Iterable<V> vList);

  // **** End of Interface

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

//  ETypePredicate get eTypePredicate => throw new UnimplementedError();

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

  static bool _isPrivateCreator(int code) {
    final pCode = code & 0x1FFFF;
    return pCode >= 0x10010 && pCode <= 0x100FF;
  }

  static PC _getPCTagFromBytes(int code, DicomBytes bytes) {
    final token = bytes.vfBytes.getUtf8().trim();
    final tag = PCTag.lookupByToken(code, bytes.vrIndex, token);
    return PCtag.fromBytes(tag, bytes.vfBytes);
  }

  static PC _getPCTag(int code, int vrIndex, List<String> values) {
    if (values == null || values.length > 2) badValues(values);
    final token = (values.isEmpty) ? '' : values[0];
    Tag tag = PCTag.lookupByToken(code, vrIndex, token);
    tag ??= new PCTagUnknown(code, vrIndex, token);
    return new PCtag(tag, StringList.from([token]));
  }

  /// Creates a [TagElement] from [DicomBytes] containing a binary encoded
  /// [Element].
  static Element makeFromBytes(DicomBytes bytes, Dataset ds,
      {bool isEvr}) {
    final code = bytes.code;
    if (_isPrivateCreator(code)) return _getPCTagFromBytes(code, bytes);

    final vrIndex = bytes.vrIndex;
    final tag = lookupTagByCode(code, vrIndex, ds);
    final index = getValidVR(vrIndex, tag.vrIndex);
    return _bytesMakers[index](tag, bytes.vfBytes);
  }

  static final List<Function> _bytesMakers = <Function>[
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

  static Element makeMaybeUndefinedFromBytes(DicomBytes bytes,
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

  static Element makeSQFromBytes(
      Dataset parent, List<Item> items, DicomBytes bytes) {
    final code = bytes.code;
    if (_isPrivateCreator(code)) return badVRIndex(kSQIndex, null, kLOIndex);

    final tag = lookupTagByCode(code, bytes.vrIndex, parent);
    if (tag.vrIndex != kSQIndex)
      log.warn('** Non-Sequence Tag $tag for $bytes');
    return SQtag.fromBytes(parent, items, tag);
  }

  static Element makePixelDataFromBytes(DicomBytes bytes,
      [Dataset ds, TransferSyntax ts]) {
    final index = getPixelDataVR(bytes.code, bytes.vrIndex, ds, ts);
    return _fromBytesPixelDataMakers[index](bytes.vfBytes, ts);
  }

  // Elements that may have undefined lengths.
  static final List<Function> _fromBytesPixelDataMakers = <Function>[
    null,
    OBtagPixelData.fromBytes,
    OWtagPixelData.fromBytes,
    UNtagPixelData.fromBytes
  ];

  /// Returns a new [Element] based on the arguments.
  static Element makeFromValues(
      int code, int vrIndex, List values, Dataset ds) {
    if (_isPrivateCreator(code)) return _getPCTag(code, vrIndex, values);
    final tag = lookupTagByCode(code, vrIndex, ds);
    print('tag: $tag');
    final index = getValidVR(vrIndex, tag.vrIndex);
    print('vrIndex: $index');
    return makeFromTag(tag, values, index);
  }

  /// Return a new [TagElement]. This assumes the caller has handled
  /// Private Elements, etc.
  static Element makeFromTag(Tag tag, Iterable values, int vrIndex,
          [Dataset ds, TransferSyntax ts]) =>
      (tag.code == kPixelData)
          ? makePixelDataFromValues(tag, values, vrIndex, ds, ts)
          : _fromValuesMakers[vrIndex](tag, values);

  static Element makePixelDataFromValues(Tag tag, Iterable values, int vrIndex,
      [Dataset ds, TransferSyntax ts]) {
    final index = getPixelDataVR(tag.code, vrIndex, ds, ts);
    return _fromValuesPixelDataMakers[index](values, ts);
  }

  // Elements that may have undefined lengths.
  static final List<Function> _fromValuesPixelDataMakers = <Function>[
    null,
    OBtagPixelData.fromValues,
    OWtagPixelData.fromValues,
    UNtagPixelData.fromValues
  ];

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

  /// Creates an [SQtag] [Element].
  static SQ makeSequenceFromCode(
      Dataset parent, int code, List<TagItem> items) {
    final tag = lookupTagByCode(code, kSQIndex, parent);
    assert(tag.vrIndex == kSQIndex, 'vrIndex: ${tag.vrIndex}');
    final values = (items == null) ? <TagItem>[] : items;
    return new SQtag(parent, tag, values);
  }

  static SQ makeSequenceFromTag(Dataset parent, Tag tag, List<TagItem> items,
          [int vfLengthField]) =>
      new SQtag(parent, tag, items);
}
