//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
library odw.sdk.element.bytes;

import 'dart:typed_data';

import 'package:core/src/dataset.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/element/bytes/vf_fragments.dart';
import 'package:core/src/global.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/values/uid.dart';
import 'package:core/src/vr.dart';

part 'float.dart';
part 'integer.dart';
part 'pixel_data.dart';
part 'sequence.dart';
part 'string.dart';

// ignore_for_file: public_member_api_docs

typedef DecodeBinaryVF = Element Function(DicomBytes bytes, int vrIndex);

typedef BDElementMaker = Element Function(
    int code, int vrIndex, DicomBytes bytes);

abstract class ByteElement<V> {
  DicomBytes get bytes;

  /// The length of values;
  int get length;

  List<V> get values;
  set values(Iterable<V> vList) => unsupportedError();

  List<V> get emptyList;

  bool get hasValidValues;

  V operator [](int index);

  // **** End of Interface

  /// Returns _true_ if _this_ and [other] are the same [ByteElement],
  /// and equal byte for byte.
  @override
  bool operator ==(Object other) =>
      other is ByteElement && bytes == other.bytes;

  @override
  int get hashCode => bytes.hashCode;

  /// The [index] of the [Element] Definition for _this_. It is
  /// used to locate other values in the [Element] Definition.
  int get index => code;

  /// The Tag Code of _this_.
  int get code => bytes.code;

  /// The length in bytes of this [ByteElement]
  int get eLength => bytes.length;

  bool get isEvr => bytes.isEvr;

  bool get isPublic => code.isEven;

  bool get isPrivate => !isPublic;

  int get vrCode => bytes.vrCode;

  int get vrIndex => bytes.vrIndex;

  int get vfLengthOffset => bytes.vfLengthOffset;

  int get vfLengthField => bytes.vfLengthField;

  int get vfLength => bytes.vfLength;

  int get vfOffset => bytes.vfOffset;

  Bytes get vfBytes => bytes.vfBytes;

//  Bytes get vBytes => bytes.vBytes;

  int get vfBytesLast => bytes.vfBytesLast;

  Tag get tag => Tag.lookupByCode(code);
  int get vmMin => tag.vmMin;
  int get vmMax => tag.vmMax;
  int get vmColumns => tag.vmColumns;

  bool get isRetired => tag.isRetired;

  String get keyword => tag.keyword;
  String get name => tag.name;

  static bool _isPrivateCreator(int code) {
    final pCode = code & 0x1FFFF;
    return pCode >= 0x10010 && pCode <= 0x100FF;
  }

  static Element makeFromBytes(DicomBytes bytes, Dataset ds, {bool isEvr}) {
    final code = bytes.code;
    if (_isPrivateCreator(code)) return PCbytes(bytes);
    final vrIndex = isEvr ? bytes.vrIndex : kUNIndex;
    final tag = lookupTagByCode(code, vrIndex, ds);
    final index = getValidVR(vrIndex, tag.vrIndex);
    return _bytesMakers[index](bytes);
  }

  static final List<Function> _bytesMakers = <Function>[
    SQbytes.fromBytes, // stop reformat
    // Maybe Undefined Lengths
    OBbytes.fromBytes, OWbytes.fromBytes, UNbytes.fromBytes,

    // EVR Long
    ODbytes.fromBytes, OFbytes.fromBytes, OLbytes.fromBytes,
    UCbytes.fromBytes, URbytes.fromBytes, UTbytes.fromBytes,

    // EVR Short
    AEbytes.fromBytes, ASbytes.fromBytes, ATbytes.fromBytes,
    CSbytes.fromBytes, DAbytes.fromBytes, DSbytes.fromBytes,
    DTbytes.fromBytes, FDbytes.fromBytes, FLbytes.fromBytes,
    ISbytes.fromBytes, LObytes.fromBytes, LTbytes.fromBytes,
    PNbytes.fromBytes, SHbytes.fromBytes, SLbytes.fromBytes,
    SSbytes.fromBytes, STbytes.fromBytes, TMbytes.fromBytes,
    UIbytes.fromBytes, ULbytes.fromBytes, USbytes.fromBytes
  ];

  static Element makeMaybeUndefinedFromBytes(DicomBytes bytes,
      [Dataset ds, int vfLengthField]) {
    final code = bytes.code;
    // Note: This shouldn't happen, but it does.
    if (_isPrivateCreator(code)) return PCbytes(bytes);

    final vrIndex = bytes.vrIndex;
    assert(vrIndex >= 0 && vrIndex < 4);
    final tag = lookupTagByCode(code, vrIndex, ds);
    final index = getValidVR(vrIndex, tag.vrIndex);
    return _undefinedBytesMakers[index](bytes, ds, vfLengthField);
  }

  // Elements that may have undefined lengths.
  static final List<Function> _undefinedBytesMakers = <Function>[
    SQbytes.fromBytes, // stop reformat
    OBbytes.fromBytes, OWbytes.fromBytes, UNbytes.fromBytes
  ];

  static Element makeSQFromBytes(
      Dataset parent, List<Item> items, DicomBytes bytes) {
    final code = bytes.code;
    if (_isPrivateCreator(code)) return badVRIndex(kSQIndex, null, kLOIndex);

    final tag = lookupTagByCode(code, bytes.vrIndex, parent);
    assert(tag.vrIndex == kSQIndex, 'vrIndex: ${tag.vrIndex}');
    if (tag.vrIndex != kSQIndex)
      log.warn('** Non-Sequence Tag $tag for $bytes');
    return SQbytes.fromBytes(parent, items, bytes);
  }

  static Element makePixelDataFromBytes(DicomBytes bytes,
      [TransferSyntax ts, VFFragments fragments, Dataset ds]) {
    final code = bytes.code;
    final index = getPixelDataVR(code, bytes.vrIndex, ds, ts);
    return _fromBytesPixelDataMakers[index](bytes, ts, fragments);
  }

  // Elements that may have undefined lengths.
  static final List<Function> _fromBytesPixelDataMakers = <Function>[
    null,
    OBbytesPixelData.fromBytes,
    OWbytesPixelData.fromBytes,
    UNbytesPixelData.fromBytes
  ];

  /// Returns a new [Element] based on the arguments.
  static Element makeFromValues(int code, int vrIndex, Iterable vList,
      {bool isEvr = true, Dataset ds}) {
    if (_isPrivateCreator(code))
      return PCbytes.fromValues(code, vList, isEvr: isEvr);
    final tag = lookupTagByCode(code, vrIndex, ds);
    final index = getValidVR(vrIndex, tag.vrIndex);
    return _fromValueMakers[vrIndex](code, vList, index);
  }

  static final List<Function> _fromValueMakers = <Function>[
    SQbytes.fromValues, // stop reformat
    // Maybe Undefined Lengths
    OBbytes.fromValues, OWbytes.fromValues, UNbytes.fromValues,

    // EVR Long
    OBbytes.fromValues, OFbytes.fromValues, OLbytes.fromValues,
    UCbytes.fromValues, URbytes.fromValues, UTbytes.fromValues,

    // EVR Short
    AEbytes.fromValues, ASbytes.fromValues, ATbytes.fromValues,
    CSbytes.fromValues, DAbytes.fromValues, DSbytes.fromValues,
    DTbytes.fromValues, FDbytes.fromValues, FLbytes.fromValues,
    ISbytes.fromValues, LObytes.fromValues, LTbytes.fromValues,
    PNbytes.fromValues, SHbytes.fromValues, SLbytes.fromValues,
    SSbytes.fromValues, STbytes.fromValues, TMbytes.fromValues,
    UIbytes.fromValues, ULbytes.fromValues, USbytes.fromValues,
  ];
}

DicomBytes _makeShort<V>(
    int code, Iterable<V> vList, int vrCode, bool isEvr, int eSize) {
  final vfLength = vList.length * eSize;
  return isEvr
      ? EvrShortBytes.makeEmpty(code, vfLength, vrCode)
      : IvrBytes.makeEmpty(code, vfLength, vrCode);
}

DicomBytes _makeShortString(
    int code, List<String> sList, int vrCode, bool isEvr) {
  final tag = Tag.lookupByCode(code);
  if (tag.vrCode != vrCode) return null;
  final vlf = stringListLength(sList, pad: true);
  return isEvr
      ? EvrShortBytes.makeEmpty(code, vlf, vrCode)
      : IvrBytes.makeEmpty(code, vlf, vrCode);
}

DicomBytes _makeLong(int code, List vList, int vrCode, bool isEvr, int eSize) {
  final vfLength = vList.length * eSize;
  return isEvr
      ? EvrLongBytes.makeEmpty(code, vfLength, vrCode)
      : IvrBytes.makeEmpty(code, vfLength, vrCode);
}

DicomBytes _makeLongString(
    int code, List<String> sList, int vrCode, bool isEvr) {
  final vlf = stringListLength(sList, pad: true);
  return isEvr
      ? EvrLongBytes.makeEmpty(code, vlf, vrCode)
      : IvrBytes.makeEmpty(code, vlf, vrCode);
}
