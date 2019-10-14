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

import 'package:bytes_dicom/bytes_dicom.dart';
import 'package:base/base.dart';
import 'package:core/src/dataset.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/error.dart';
import 'package:core/src/values/vf_fragments.dart';
import 'package:core/src/global.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/values.dart';

part 'float.dart';
part 'integer.dart';
part 'pixel_data.dart';
part 'sequence.dart';
part 'string.dart';

// ignore_for_file: public_member_api_docs

typedef DecodeBinaryVF = Element Function(BytesDicom bytes, int vrIndex);

typedef BDElementMaker = Element Function(
    int code, int vrIndex, BytesDicom bytes);

mixin ElementBytes<V> {
  V operator [](int index);

  BytesElement get be;

  bool get hasValidValues;

  // **** End of Interface

  // **** Getters and Setters special to ByteElement

  /// The Tag Code of _this_.
  int get code => be.code;

  /// The length of _this_ [ElementBytes]
  int get length => be.length;

  bool get isEvr => be.isEvr;

  int get vrCode => be.vrCode;

  int get vrIndex => be.vrIndex;

  int get vfLengthOffset => be.vfLengthOffset;

  int get vfLengthField => be.vfLengthField;

  int get vfLength => be.vfLength;

  int get vfOffset => be.vfOffset;

  Bytes get vfBytes => be.vfBytes;

  int get vfBytesLast => be.vfBytesLast;

  Uint8List get bulkdata => unsupportedError();

  @override
  String toString() => '(${be.length}) $be';

  // **** Getters and Setters special to ByteElement

  static bool _isPrivateCreator(int code) {
    final pCode = code & 0x1FFFF;
    return pCode >= 0x10010 && pCode <= 0x100FF;
  }

  static Element fromBytes(BytesElement bytes, Dataset ds, {bool isEvr}) {
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

  static Element makeMaybeUndefinedFromBytes(BytesElement bytes,
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
  static Element fromValues(
      int code, int vrIndex, Iterable vList, BytesElementType type,
      {Dataset ds}) {
    if (_isPrivateCreator(code)) return PCbytes.fromValues(code, vList, type);
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

/*
// Urgent remove when _makeStringElement is working
BytesElement _makeShortHeader<V>(
    int code, Iterable<V> vList, int vrCode, bool isEvr, int eSize,
    {bool isLE = true}) {
  final vfl = vList.length * eSize;
  return isEvr
      ? isLE
          ? BytesLELongEvr.header(code, vfl, vrCode)
          : BytesBELongEvr.header(code, vfl, vrCode)
      : BytesIvr.header(code, vfl, vrCode);
}


// Urgent remove when _makeStringElement is working
BytesElement _makeShortElement<V>(
    int code, Bytes vfBytes, int vrCode, bool isEvr, int eSize,
    {bool isLE = true}) {
  final tag = Tag.lookupByCode(code);
  if (tag.vrCode != vrCode) return null;
  return isEvr
      ? isLE
          ? BytesLELongEvr.element(code, vfBytes, vrCode)
          : BytesBELongEvr.element(code, vfBytes, vrCode)
      : BytesIvr.element(code, vfBytes, vrCode);
}


// Urgent remove when _makeStringElement is working
BytesElement _makeShortStringHeader(
    int code, List<String> sList, int vrCode, bool isEvr,
    {bool isLE = true}) {
  final tag = Tag.lookupByCode(code);
  if (tag.vrCode != vrCode) return null;
  final vfl = stringListLength(sList, pad: true);
  return isEvr
      ? isLE
          ? BytesLELongEvr.header(code, vrCode, vfl)
          : BytesBELongEvr.header(code, vrCode, vfl)
      : BytesIvr.header(code, vrCode, vfl);
}
*/

BytesElement _makeShortElt(
    int code, Bytes vfBytes, int vrCode, BytesElementType type, int maxLength) {
  assert(vfBytes.length <= maxLength);
  final tag = Tag.lookupByCode(code);
  if (tag.vrCode != vrCode) throw ArgumentError('Invalid VR $vrCode');

  switch (type) {
    case BytesElementType.leShortEvr:
      return BytesLEShortEvr.element(code, vrCode, vfBytes);
    case BytesElementType.beShortEvr:
      return BytesBEShortEvr.element(code, vrCode, vfBytes);
    case BytesElementType.leIvr:
      return BytesIvr.element(code, vfBytes);
    default:
      throw ArgumentError('Unknown BytesElementType $type');
  }
}

BytesElement _makeLongElt(
    int code, Bytes vfBytes, int vrCode, BytesElementType type, int maxLength) {
  assert(vfBytes.length <= maxLength);
  final tag = Tag.lookupByCode(code);
  if (tag.vrCode != vrCode) throw ArgumentError('Invalid VR $vrCode');
  switch (type) {
    case BytesElementType.leLongEvr:
      return BytesLELongEvr.element(code, vrCode, vfBytes);
    case BytesElementType.beLongEvr:
      return BytesBELongEvr.element(code, vrCode, vfBytes);
    case BytesElementType.leIvr:
      return BytesIvr.element(code, vfBytes);
    default:
      throw ArgumentError('Unknown BytesElementType $type');
  }
}

/*
// Urgent remove when _makeStringElement is working
BytesElement _makeLongHeader(
    int code, List vList, int vrCode, bool isEvr, int eSize,
    {bool isLE = true}) {
  final vfl = vList.length * eSize;
  return isEvr
      ? isLE
          ? BytesLELongEvr.header(code, vrCode, vfl)
          : BytesBELongEvr.header(code, vrCode, vfl)
      : BytesIvr.header(code, vrCode, vfl);
}

// Urgent remove when _makeStringElement is working
BytesElement _makeLongStringHeader(
    int code, List<String> sList, int vrCode, bool isEvr,
    {bool isLE = true}) {
  final vfl = stringListLength(sList, pad: true);
  return isEvr
      ? isLE
          ? BytesLELongEvr.header(code, vrCode, vfl)
          : BytesBELongEvr.header(code, vrCode, vfl)
      : BytesIvr.header(code, vrCode, vfl);
}
*/
