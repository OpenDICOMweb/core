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
import 'package:core/src/values/vf_fragments.dart';
import 'package:core/src/global.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/values.dart';
import 'package:core/src/vr.dart';

part 'float.dart';
part 'integer.dart';
part 'integer_mixin.dart';
part 'pixel_data.dart';
part 'sequence.dart';
part 'string.dart';

// ignore_for_file: public_member_api_docs

typedef DecodeBinaryVF = Element Function(DicomBytes bytes, int vrIndex);

typedef BDElementMaker = Element Function(
    int code, int vrIndex, DicomBytes bytes);

mixin ByteElement<V> {
  V operator [](int index);

  DicomBytes get bytes;

  /// The length of values;
  int get length;

  List<V> get emptyList;

  bool get hasValidValues;

  // **** End of Interface

  // **** Getters and Setters special to ByteElement

  /// The Tag Code of _this_.
  int get code => bytes.code;

  /// The length in bytes of this [ByteElement]
  int get eLength => bytes.length;

  bool get isEvr => bytes.isEvr;

  int get vrCode => bytes.vrCode;

  int get vrIndex => bytes.vrIndex;

  int get vfLengthOffset => bytes.vfLengthOffset;

  int get vfLengthField => bytes.vfLengthField;

  int get vfLength => bytes.vfLength;

  int get vfOffset => bytes.vfOffset;

  Bytes get vfBytes => bytes.vfBytes;

  int get vfBytesLast => bytes.vfBytesLast;

  Uint8List get bulkdata => unsupportedError();

  // **** Getters and Setters special to ByteElement

  static bool _isPrivateCreator(int code) {
    final pCode = code & 0x1FFFF;
    return pCode >= 0x10010 && pCode <= 0x100FF;
  }

  static Element fromBytes(DicomBytes bytes, Dataset ds, {bool isEvr}) {
    final code = bytes.code;
    if (_isPrivateCreator(code)) return PCbytes(bytes);
    final vrIndex = isEvr ? bytes.vrIndex : kUNIndex;
    final tag = lookupTagByCode(code, vrIndex, ds);
    final index = getValidVR(vrIndex, tag.vrIndex);
    final charset = (ds == null) ? utf8 : ds.charset;
    return (index == kSQIndex)
        ? SQbytes.fromBytes(ds, <ByteItem>[], bytes)
        : _bytesMakers[index](bytes, charset);
  }

  static final List<Function> _bytesMakers = <Function>[
    UNbytes.fromBytes,
    SQbytes.fromBytes, // stop reformat
    // Maybe Undefined Lengths
    OBbytes.fromBytes, OWbytes.fromBytes,

    // EVR Long
    ODbytes.fromBytes, OFbytes.fromBytes, OLbytes.fromBytes,

    UCbytes.fromBytes, URbytes.fromBytes, UTbytes.fromBytes,

    // EVR Short
    AEbytes.fromBytes, ASbytes.fromBytes, CSbytes.fromBytes,
    DAbytes.fromBytes, DSbytes.fromBytes, DTbytes.fromBytes,
    ISbytes.fromBytes, LObytes.fromBytes, LTbytes.fromBytes,
    PNbytes.fromBytes, SHbytes.fromBytes, STbytes.fromBytes,
    TMbytes.fromBytes, UIbytes.fromBytes,

    ATbytes.fromBytes, FDbytes.fromBytes, FLbytes.fromBytes,
    SLbytes.fromBytes, SSbytes.fromBytes, ULbytes.fromBytes,
    USbytes.fromBytes
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

  /// Returns a new [Element] based on the arguments.
  static Element fromValues(int code, int vrIndex, Iterable vList,
      {bool isEvr = true, Dataset ds}) {
    if (_isPrivateCreator(code))
      return PCbytes.fromValues(code, vList, isEvr: isEvr);
    final tag = lookupTagByCode(code, vrIndex, ds);
    final index = getValidVR(vrIndex, tag.vrIndex);
    return _fromValueMakers[vrIndex](code, vList, index);
  }

  static final List<Function> _fromValueMakers = <Function>[
    UNbytes.fromValues,
    SQbytes.fromValues, // stop reformat
    // Maybe Undefined Lengths
    OBbytes.fromValues, OWbytes.fromValues,

    // EVR Long
    OBbytes.fromValues, OFbytes.fromValues, OLbytes.fromValues,

    UCbytes.fromValues, URbytes.fromValues, UTbytes.fromValues,

    // EVR Short
    AEbytes.fromValues, ASbytes.fromValues, CSbytes.fromValues,
    DAbytes.fromValues, DSbytes.fromValues, DTbytes.fromValues,
    ISbytes.fromValues, LObytes.fromValues, LTbytes.fromValues,
    PNbytes.fromValues, SHbytes.fromValues, STbytes.fromValues,
    TMbytes.fromValues, UIbytes.fromValues,

    ATbytes.fromValues, FDbytes.fromValues, FLbytes.fromValues,
    SLbytes.fromValues, SSbytes.fromValues, ULbytes.fromValues,
    USbytes.fromValues
  ];
}

DicomBytes _makeShort<V>(
    int code, Iterable<V> vList, int vrCode, bool isEvr, int eSize) {
  final vfLength = vList.length * eSize;
  return isEvr
      ? EvrShortBytes.empty(code, vfLength, vrCode)
      : IvrBytes.empty(code, vfLength, vrCode);
}

DicomBytes _makeShortString(
    int code, List<String> sList, int vrCode, bool isEvr) {
  final tag = Tag.lookupByCode(code);
  if (tag.vrCode != vrCode) return null;
  final vlf = stringListLength(sList, pad: true);
  return isEvr
      ? EvrShortBytes.empty(code, vlf, vrCode)
      : IvrBytes.empty(code, vlf, vrCode);
}

DicomBytes _makeLong(int code, List vList, int vrCode, bool isEvr, int eSize) {
  final vfLength = vList.length * eSize;
  return isEvr
      ? EvrLongBytes.empty(code, vfLength, vrCode)
      : IvrBytes.empty(code, vfLength, vrCode);
}

DicomBytes _makeLongString(
    int code, List<String> sList, int vrCode, bool isEvr) {
  final vlf = stringListLength(sList, pad: true);
  return isEvr
      ? EvrLongBytes.empty(code, vlf, vrCode)
      : IvrBytes.empty(code, vlf, vrCode);
}
