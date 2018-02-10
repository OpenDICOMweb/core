// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/mixin/undefined_length_mixin.dart';
import 'package:core/src/element/crypto.dart';
import 'package:core/src/element/errors.dart';
import 'package:core/src/empty_list.dart';
import 'package:core/src/errors.dart';
import 'package:core/src/issues.dart';
import 'package:core/src/tag/constants.dart';
import 'package:core/src/tag/tag_lib.dart';
import 'package:core/src/vr/vr.dart';

abstract class IntBase extends Element<int> {
  @override
  Iterable<int> get values;

  @override
  set values(Iterable<int> vList) => unsupportedError('IntBase.values');

  bool get isBinary => true;

  @override
  int get padChar => unsupportedError('IntBase does not have a padChar');

  /// Returns a copy of [values]
  @override
  Iterable<int> get valuesCopy => new List.from(values, growable: false);

  /// The _canonical_ empty [values] value for Floating Point Elements.
  @override
  List<int> emptyList = kEmptyList;
  static const List<int> kEmptyList = const <int>[];

  @override
  IntBase get noValues => update(kEmptyList);

  @override
  ByteData get vfByteData => typedData.buffer
      .asByteData(typedData.offsetInBytes, typedData.lengthInBytes);

  @override
  Uint8List get vfBytes => _asUint8List(typedData);

  /// Returns a [view] of this [Element] with [values] replaced by [TypedData].
  IntBase view([int start = 0, int length]);

  static bool _isValidValue(int v, Issues issues, int min, int max) {
    if (v < min || v > max) {
      if (issues != null) {
        if (v < min) issues.add('Invalid Value($v) under minimum($min)');
        if (v < min) issues.add('Invalid Value($v) over maximum($max)');
      }
      return false;
    }
    return true;
  }

  static bool _isValidValues(Tag tag, Iterable<int> vList, Issues issues,
      int minVLength, int maxVLength, int maxVFListLength) {
    if (!Element.isValidVListLength(tag, vList, issues, maxVFListLength))
      return false;
    var result = true;
    for (var v in vList)
      result = _isValidValue(v, issues, minVLength, maxVLength);
    if (result == false) {
      invalidValuesError(vList, issues: issues);
      return false;
    }
    return result;
  }
}

abstract class Int8Base extends IntBase {
  @override
  int get sizeInBytes => kSizeInBytes;
  int get minValue => kMinValue;
  int get maxValue => kMaxValue;

  @override
  Int8List get typedData => fromList(values);

  @override
  Int8Base get sha256 => update(Sha256.int16(typedData));

  @override
  bool checkValue(int v, {Issues issues, bool allowInvalid = false}) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  /// Returns a  an Uint8List View of [values].
  @override
  Int8Base view([int start = 0, int length]) => update(
      typedData.buffer.asInt8List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 1;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = -(1 << (kSizeInBits - 1));
  static const int kMaxValue = (1 << (kSizeInBits - 1)) - 1;

  /// Returns a [BASE64] [String] created from [vList];
  static String toBase64(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      BASE64.encode(toBytes(vList, asView: asView, check: check));

  /// Returns a [Int8List] created from [vList];
  static Int8List toBytes(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final td = fromList(vList, asView: asView, check: check);
    return td?.buffer?.asInt8List(td.offsetInBytes, td.lengthInBytes);
  }

  /// Returns a [ByteData] created from [vList];
  static ByteData toByteData(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      _asByteData(fromList(vList, asView: asView, check: check));

  /// Returns a [Int8List] with the same length as [vList]. If
  /// [vList] is a [Int8List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No value checking
  /// is done.
  ///
  /// If [vList] is not a [Int8List], then if [vList] has valid values,
  /// a new [Int8List] is created and the values of [vList] are copied
  /// into it and returned; otherwise, [invalidValuesError] is called.
  static Int8List fromList(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    assert(vList != null);
    if (vList.isEmpty) return kEmptyInt8List;
    if (vList is Int8List)
      return (asView) ? vList : new Int8List.fromList(vList);
    if (check) {
      final td = new Int8List(vList.length);
      return _copyList(vList, td, kMinValue, kMaxValue);
    }
    return new Int8List.fromList(vList);
  }

  static Int8List toInt8List(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      _toInt8List(vList, asView: asView, check: check);

  static Int8List _toInt8List(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    assert(vList != null);
    if (vList is Int8List) return vList;
    if ((check && _isNotValidList(vList, kMinValue, kMaxValue)))
      return invalidValuesError(vList);
    return new Int8List.fromList(vList);
  }

  /// Returns a [Int8List] from a [BASE64] [String].
  static Int8List fromBase64(String s,
          {bool asView = true, bool check = true}) =>
      (s.isEmpty) ? kEmptyInt8List : fromBytes(BASE64.decode(s));

  /// Returns a [Int8List] from a [Uint8List].
  static Int8List fromBytes(Uint8List bytes,
          {bool asView = true, bool check = true}) =>
      _fromTypedData(bytes, asView: asView, check: check);

  /// Returns a [Int8List] from a [ByteData].
  static Int8List fromByteData(ByteData bd,
          {bool asView = true, bool check = true}) =>
      _fromTypedData(bd, asView: asView);

  /// Returns a [Int8List] from a [Uint8List] or a [ByteData].
  static Int8List _fromTypedData(TypedData td,
      {bool asView = true, bool check = true}) {
    assert(td != null);
    if (td.lengthInBytes == 0) return IntBase.kEmptyList;
    final length = td.lengthInBytes;
    final asInt8List = td.buffer.asInt8List(td.offsetInBytes, length);
    return (asView) ? asInt8List : new Int8List.fromList(asInt8List);
  }
}

abstract class Int16Base extends IntBase {
  @override
  int get sizeInBytes => kSizeInBytes;
  int get minValue => kMinValue;
  int get maxValue => kMaxValue;

  @override
  Int16List get typedData => fromList(values);

  @override
  Int16Base get sha256 => update(Sha256.int16(typedData));

  @override
  bool checkValue(int v, {Issues issues, bool allowInvalid = false}) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  /// Returns a  an Uint8List View of [values].
  @override
  Int16Base view([int start = 0, int length]) => update(
      typedData.buffer.asInt16List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 2;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = -(1 << (kSizeInBits - 1));
  static const int kMaxValue = (1 << (kSizeInBits - 1)) - 1;

  /// Returns a [BASE64] [String] created from [vList];
  static String toBase64(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      BASE64.encode(toBytes(vList, asView: asView, check: check));

  /// Returns a [Int16List] created from [vList];
  static Uint8List toBytes(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final td = fromList(vList, asView: asView, check: check);
    return _asUint8List(td);
  }

  /// Returns a [ByteData] created from [vList];
  static ByteData toByteData(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      _asByteData(fromList(vList, asView: asView, check: check));

  /// Returns a [Int16List] with the same length as [vList]. If
  /// [vList] is a [Int16List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No value checking
  /// is done.
  ///
  /// If [vList] is not a [Int16List], then if [vList] has valid values,
  /// a new [Int16List] is created and the values of [vList] are copied
  /// into it and returned; otherwise, [invalidValuesError] is called.
  static Int16List fromList(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    assert(vList != null);
    if (vList.isEmpty) return kEmptyInt16List;
    if (vList is Int16List)
      return (asView) ? vList : new Int16List.fromList(vList);
    if (check) {
      final td = new Int16List(vList.length);
      return _copyList(vList, td, kMinValue, kMaxValue);
    }
    return new Int16List.fromList(vList);
  }

  /// Returns a [Int16List] from a [BASE64] [String].
  static Int16List fromBase64(String s,
          {bool asView = true, bool check = true}) =>
      (s.isEmpty) ? kEmptyInt16List : fromBytes(BASE64.decode(s));

  /// Returns a [Int16List] from a [Uint8List].
  static Int16List fromBytes(Uint8List bytes, {bool asView = true}) =>
      _fromByteData(_asByteData(bytes), asView: asView);

  /// Returns a [Int16List] from a [ByteData].
  static Int16List fromByteData(ByteData bd, {bool asView = true}) =>
      _fromByteData(bd, asView: asView);

  /// /// Returns a [Int16List] from a [ByteData].
  static Int16List _fromByteData(ByteData bd, {bool asView = true}) {
    assert(bd != null);
    if (bd.lengthInBytes == 0) return kEmptyInt16List;
    assert((bd.lengthInBytes % kSizeInBytes) == 0, 'lib: ${bd.lengthInBytes}');
    final length = bd.lengthInBytes ~/ kSizeInBytes;

    if (_isNotAligned(bd)) {
      final vList = new Int16List(length);
      for (var i = 0, oib = 0; i < length; i++, oib += kSizeInBytes)
        vList[i] = bd.getInt16(oib, Endian.little);
      // Returning a new list
      return vList;
    }
    final i16List = bd.buffer.asInt16List(bd.offsetInBytes, length);
    return (asView) ? i16List : new Int16List.fromList(i16List);
  }

  static bool _isNotAligned(TypedData vList) =>
      (vList.offsetInBytes % kSizeInBytes) != 0;
}

/// Signed Short [Element].
abstract class SS extends Int16Base {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get sizeInBytes => kSizeInBytes;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  int get maxLength => kMaxLength;

//  static const VR kVR = VR.kSS;
  static const int kVRIndex = kSSIndex;
  static const int kVRCode = kSSCode;
  static const String kVRKeyword = 'SS';
  static const String kVRName = 'Signed Short';
  static const int kSizeInBytes = 2;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kVFLSize = 2;
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = -(1 << (kSizeInBits - 1));
  static const int kMaxValue = (1 << (kSizeInBits - 1)) - 1;

  static bool isValidArgs(Tag tag, Iterable<int> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<int> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex || vrIndex == kUSSSIndex || vrIndex == kUSSSOWIndex)
      return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    final vrIndex = vrIndexFromCodeMap[vrCode];
    if (isValidVRIndex(vrIndex)) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl, [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(vfl, min, max, kSizeInBytes);

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      IntBase._isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

abstract class Int32Base extends IntBase {
  @override
  int get sizeInBytes => kSizeInBytes;
  int get minValue => kMinValue;
  int get maxValue => kMaxValue;

  @override
  Int32List get typedData =>
      (values is Int32List) ? values : new Int32List.fromList(values);

  @override
  Int32Base get sha256 => update(Sha256.int32(typedData));

  @override
  bool checkValue(int v, {Issues issues, bool allowInvalid = false}) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  /// Returns an Int32List View of [values].
  @override
  SL view([int start = 0, int length]) => update(
      typedData.buffer.asInt32List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = -(1 << (kSizeInBits - 1));
  static const int kMaxValue = (1 << (kSizeInBits - 1)) - 1;

  /// Returns a [BASE64] [String] created from [vList];
  static String toBase64(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      BASE64.encode(toBytes(vList, check: check));

  /// Returns a [Int32List] created from [vList];
  static Uint8List toBytes(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final td = fromList(vList, asView: asView, check: check);
    return _asUint8List(td);
  }

  /// Returns a [ByteData] created from [vList];
  static ByteData toByteData(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      _asByteData(fromList(vList, asView: asView, check: check));

  /// Returns a [Int32List] with the same length as [vList]. If
  /// [vList] is a [Int32List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No value checking
  /// is done.
  ///
  /// If [vList] is not a [Int32List], then if [vList] has valid values,
  /// a new [Int32List] is created and the values of [vList] are copied
  /// into it and returned; otherwise, [invalidValuesError] is called.
  static Int32List fromList(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    assert(vList != null);
    if (vList.isEmpty) return kEmptyInt32List;
    if (vList is Int32List)
      return (asView) ? vList : new Int32List.fromList(vList);
    if (check) {
      final td = new Int32List(vList.length);
      return _copyList(vList, td, kMinValue, kMaxValue);
    }
    return new Int32List.fromList(vList);
  }

  /// Returns a [Int32List] from a [BASE64] [String].
  static Int32List fromBase64(String s, {bool asView = true}) =>
      (s.isEmpty) ? kEmptyInt32List : fromBytes(BASE64.decode(s));

  /// Returns a [Int32List] from a [Uint8List].
  static Int32List fromBytes(Uint8List bytes, {bool asView = true}) =>
      _fromByteData(_asByteData(bytes), asView: asView);

  /// Returns a [Int32List] from a [ByteData].
  static Int32List fromByteData(ByteData bd, {bool asView = true}) =>
      _fromByteData(bd, asView: true);

  /// /// Returns a [Int32List] from a [ByteData].
  static Int32List _fromByteData(ByteData bd, {bool asView = true}) {
    assert(bd != null && bd.lengthInBytes >= 0);
    if (bd.lengthInBytes == 0) return kEmptyInt32List;
    assert((bd.lengthInBytes % kSizeInBytes) == 0, 'lib: ${bd.lengthInBytes}');
    final length = bd.lengthInBytes ~/ kSizeInBytes;

    if (_isNotAligned(bd)) {
      final nList = new Int32List(length);
      for (var i = 0, oib = 0; i < length; i++, oib += kSizeInBytes)
        nList[i] = bd.getInt32(oib, Endian.little);
      return nList;
    }
    final i32List = bd.buffer.asInt32List(bd.offsetInBytes, length);
    return (asView) ? i32List : new Int32List.fromList(i32List);
  }

  static bool _isNotAligned(TypedData vList) =>
      (vList.offsetInBytes % kSizeInBytes) != 0;
}

/// Signed Long ([SL]) [Element].
abstract class SL extends Int32Base {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get sizeInBytes => kSizeInBytes;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  int get maxLength => kMaxLength;

//  static const VR kVR = VR.kSL;
  static const int kVRIndex = kSLIndex;
  static const int kVRCode = kSLCode;
  static const String kVRKeyword = 'SL';
  static const String kVRName = 'Signed Long';
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = -(1 << (kSizeInBits - 1));
  static const int kMaxValue = (1 << (kSizeInBits - 1)) - 1;

  static bool isValidArgs(Tag tag, Iterable<int> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<int> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    final vrIndex = vrIndexFromCodeMap[vrCode];
    if (isValidVRIndex(vrIndex)) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl, [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(vfl, min, max, kSizeInBytes);

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      IntBase._isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

/// An abstract class for 64-bit integers.
abstract class Int64Base extends IntBase {
  @override
  int get sizeInBytes => kSizeInBytes;
  int get minValue => kMinValue;
  int get maxValue => kMaxValue;

  @override
  Int64List get typedData => fromList(values);

  @override
  IntBase get sha256 => update(Sha256.int64(values));

  /// Returns a [Int64List.view] of [values].
  @override
  Int64Base view([int start = 0, int length]) {
    if (!checkLength(values)) return invalidValuesLengthError(tag, values);
    return update(
        typedData.buffer.asInt64List(start, _toLength(length, values.length)));
  }

  static const int kSizeInBytes = 8;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  /// Returns a [BASE64] [String] created from [vList];
  static String toBase64(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      BASE64.encode(toBytes(vList));

  /// Returns a [Uint8List] created from [vList];
  static Uint8List toBytes(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      _asUint8List(fromList(vList, asView: asView, check: check));

  /// Returns a [ByteData] created from [vList];
  static ByteData toByteData(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      _asByteData(fromList(vList, asView: asView, check: check));

  /// Returns a [Int64List] with the same length as [vList]. If
  /// [vList] is a [Int64List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No value checking
  /// is done.
  ///
  /// If [vList] is not a [Int64List], then if [vList] has valid values,
  /// a new [Int64List] is created and the values of [vList] are copied
  /// into it and returned; otherwise, [invalidValuesError] is called.
  static Int64List fromList(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    assert(vList != null);
    if (vList.isEmpty) return kEmptyInt64List;
    if (vList is Int64List)
      return (asView) ? vList : new Int64List.fromList(vList);
    if (check) {
      final td = new Int64List(vList.length);
      return _copyList(vList, td, kMinValue, kMaxValue);
    }
    return new Int64List.fromList(vList);
  }

  /// Returns a [Int64List] from a [BASE64] [String].
  static Int64List fromBase64(String s, {bool asView = true}) =>
      (s.isEmpty) ? kEmptyInt64List : fromBytes(BASE64.decode(s));

  /// Returns a [Int64List] from a [Uint8List].
  static Int64List fromBytes(Uint8List bytes, {bool asView = true}) =>
      _fromByteData(
          bytes.buffer.asByteData(bytes.offsetInBytes, bytes.lengthInBytes));

  /// Returns a [Int64List] from a [ByteData].
  static Int64List fromByteData(ByteData bd, {bool asView = true}) =>
      _fromByteData(bd);

  /// /// Returns a [Int64List] from a [ByteData].
  static Int64List _fromByteData(ByteData bd, {bool asView = true}) {
    assert(bd != null && bd.lengthInBytes >= 0);
    if (bd.lengthInBytes == 0) return kEmptyInt64List;
    assert((bd.lengthInBytes % kSizeInBytes) == 0, 'lib: ${bd.lengthInBytes}');
    final length = bd.lengthInBytes ~/ kSizeInBytes;

    if (_isNotAligned(bd)) {
      final nList = new Int64List(length);
      for (var i = 0, oib = 0; i < length; i++, oib += kSizeInBytes)
        nList[i] = bd.getInt64(oib, Endian.little);
      return nList;
    }
    final f64List = bd.buffer.asInt64List(bd.offsetInBytes, length);
    return (asView) ? f64List : new Int64List.fromList(f64List);
  }

  static bool _isNotAligned(TypedData vList) =>
      (vList.offsetInBytes % kSizeInBytes) != 0;
}

abstract class Uint8Base extends IntBase {
  @override
  int get sizeInBytes => kSizeInBytes;
  int get minValue => kMinValue;
  int get maxValue => kMaxValue;

  @override
  Uint8List get typedData => fromList(values);

  @override
  Uint8Base get sha256 => update(Sha256.uint8(typedData));

  @override
  bool checkValue(int v, {Issues issues, bool allowInvalid = false}) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  /// Returns a  an Uint8List View of [values].
  @override
  Uint8Base view([int start = 0, int length]) => update(
      typedData.buffer.asUint8List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 1;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;
  // These are here because OB and UN are both long value fields
  static const int kMaxVFLength = kMax8BitLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  /// Returns a [BASE64] [String] created from [vList];
  static String toBase64(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      BASE64.encode(toBytes(vList, asView: asView, check: check));

  /// Returns a [Uint8List] created from [vList];
  static Uint8List toBytes(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      _asUint8List(fromList(vList, asView: asView, check: check));

  /// Returns a [ByteData] created from [vList];
  static ByteData toByteData(List<int> vList,
          {bool asView = true, bool check = true}) =>
      _asByteData(fromList(vList, asView: asView, check: check));

  /// Returns a [Uint8List] with the same length as [vList]. If
  /// [vList] is a [Uint8List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No value checking
  /// is done.
  ///
  /// If [vList] is not a [Uint8List], then if [vList] has valid values,
  /// a new [Uint8List] is created and the values of [vList] are copied
  /// into it and returned; otherwise, [invalidValuesError] is called.
  static Uint8List fromList(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    assert(vList != null);
    if (vList.isEmpty) return kEmptyUint8List;
    if (vList is Uint8List)
      return (asView == true) ? vList : new Uint8List.fromList(vList);
    if (check) {
      final td = new Uint8List(vList.length);
      return _copyList(vList, td, kMinValue, kMaxValue);
    }
    return new Uint8List.fromList(vList);
  }

  /// Returns a [Uint8List] from a [BASE64] [String].
  static Uint8List fromBase64(String s,
          {bool asView = true, bool check = true}) =>
      (s.isEmpty) ? kEmptyUint8List : fromBytes(BASE64.decode(s));

  /// Returns a [Uint8List] from a [Uint8List].
  ///
  /// _Note_: This method is a no-op. It just returns [bytes].
  /// It is here for uniformity.
  static Uint8List fromBytes(Uint8List bytes,
          {bool asView = true, bool check = true}) =>
      bytes;

  /// Returns a [Uint8List] from a [TypedData].
  static Uint8List fromByteData(ByteData bd,
      {bool asView = true, bool check = true}) {
    assert(bd != null);
    if (bd.lengthInBytes == 0) return IntBase.kEmptyList;
    final asUint8List = _asUint8List(bd);
    return (asView) ? asUint8List : new Uint8List.fromList(asUint8List);
  }
}

/// Other Byte [Element].
abstract class OB extends Uint8Base with UndefinedLengthMixin {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get vflSize => 4;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  int get maxLength => kMaxLength;
  @override
  bool get isLengthAlwaysValid => true;
  @override
  int get padChar => 0;

//  static const VR kVR = VR.kOB;
  static const int kVRIndex = kOBIndex;
  static const int kVRCode = kOBCode;
  static const String kVRKeyword = 'OB';
  static const String kVRName = 'Other Byte';
  static const int kSizeInBytes = 1;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMax8BitLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  static bool isValidArgs(Tag tag, Iterable<int> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag, [Issues issues]) {
    if (_isValidVRIndex(tag.vrIndex)) return true;
    invalidTagError(tag, OB, issues);
    return false;
  }

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (_isValidVRIndex(vrIndex)) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool _isValidVRIndex(int vrIndex) =>
      vrIndex == kOBIndex || vrIndex == kOBOWIndex;

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    final vrIndex = vrIndexFromCodeMap[vrCode];
    if (isValidVRIndex(vrIndex)) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

  static bool isValidVListLength(int vfl) => true;

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      IntBase._isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

/// Unknown (UN) [Element].
abstract class UN extends Uint8Base with UndefinedLengthMixin {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get vflSize => 4;
  @override
  int get maxVFLength => kMaxShortVF;
  @override
  int get maxLength => kMaxLength;
  @override
  bool get isLengthAlwaysValid => true;
  @override
  int get padChar => 0;

//  static const VR kVR = VR.kUN;
  static const int kVRIndex = kUNIndex;
  static const int kVRCode = kUNCode;
  static const String kVRKeyword = 'UN';
  static const String kVRName = 'Unknown';
  static const int kSizeInBytes = 1;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMax8BitLongVF;
  static const int kMaxLength = kMaxLongVF;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  static bool isValidArgs(Tag tag, Iterable<int> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) => true;

  static bool isValidVRCode(int vrCode, [Issues issues]) => true;

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : invalidVRIndex(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

  static bool isValidVListLength(int vfl) => true;

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  // UN values are always true, since the read VR is unknown
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      IntBase._isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

abstract class Uint16Base extends IntBase {
  @override
  int get sizeInBytes => kSizeInBytes;
  int get minValue => kMinValue;
  int get maxValue => kMaxValue;

  @override
  Uint16List get typedData => fromList(values);

  @override
  Uint16Base get sha256 => update(Sha256.uint16(typedData));

  @override
  bool checkValue(int v, {Issues issues, bool allowInvalid = false}) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  /// Returns a  an Uint8List View of [values].
  @override
  Uint16Base view([int start = 0, int length]) => update(
      typedData.buffer.asUint16List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 2;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  /// Returns a [BASE64] [String] created from [vList];
  static String toBase64(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      BASE64.encode(toBytes(vList, asView: asView, check: check));

  /// Returns a [Uint8List] created from [vList]. If [vList]
  static Uint8List toBytes(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      _asUint8List(fromList(vList, asView: asView, check: check));

  /// Returns a [ByteData] view of from [vList].
  static ByteData toByteData(List<int> vList,
          {bool asView = true, bool check = true}) =>
      _asByteData(fromList(vList, asView: asView, check: check));

  /// Returns a [Uint16List] with the same length as [vList]. If
  /// [vList] is a [Uint16List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No value checking
  /// is done.
  ///
  /// If [vList] is not a [Uint16List], then if [vList] has valid values,
  /// a new [Uint16List] is created and the values of [vList] are copied
  /// into it and returned; otherwise, [invalidValuesError] is called.
  static Uint16List fromList(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    assert(vList != null);
    if (vList.isEmpty) return kEmptyUint16List;
    if (vList is Uint16List)
      return (asView) ? vList : new Uint16List.fromList(vList);
    if (check) {
      final td = new Uint16List(vList.length);
      return _copyList(vList, td, kMinValue, kMaxValue);
    }
    return new Uint16List.fromList(vList);
  }

  /// Returns a [Uint16List] from a [BASE64] [String].
  static Uint16List fromBase64(String s,
          {bool asView = true, bool check = true}) =>
      (s.isEmpty) ? kEmptyUint16List : fromBytes(BASE64.decode(s));

  /// Returns a [Uint16List] from a [Uint8List].
  static Uint16List fromBytes(Uint8List bytes, {bool asView = true}) =>
      _fromByteData(_asByteData(bytes), asView: asView);

  /// Returns a [Uint16List] from a [ByteData].
  static Uint16List fromByteData(ByteData bd, {bool asView = true}) =>
      _fromByteData(bd, asView: asView);

  /// Returns a [Uint16List] from a [ByteData]. If [bd] is aligned
  /// on a 2-byte boundary, then a _view_ of [bd] is returned;
  /// otherwise, a new Uint16List is returned.
  // _Note_ Assumes that [bd] is [Endian.little].
  static Uint16List _fromByteData(ByteData bd, {bool asView = true}) {
    assert(bd != null);
    if (bd.lengthInBytes == 0) return kEmptyUint16List;
    assert((bd.lengthInBytes % kSizeInBytes) == 0, 'lib: ${bd.lengthInBytes}');
    final length = bd.lengthInBytes ~/ kSizeInBytes;

    if (_isNotAligned(bd)) {
      final vList = new Uint16List(length);
      for (var i = 0, oib = 0; i < length; i++, oib += kSizeInBytes)
        vList[i] = bd.getUint16(oib, Endian.little);
      // Returning a new list
      return vList;
    }
    final u16List = bd.buffer.asUint16List(bd.offsetInBytes, length);
    return (asView) ? u16List : new Uint16List.fromList(u16List);
  }

  static bool _isNotAligned(TypedData vList) =>
      (vList.offsetInBytes % kSizeInBytes) != 0;
}

/// Other Byte [Element].
abstract class US extends Uint16Base {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get maxVFLength => kMaxShortVF;
  @override
  int get maxLength => kMaxLength;

//  static const VR kVR = VR.kUS;
  static const int kVRIndex = kUSIndex;
  static const int kVRCode = kUSCode;
  static const String kVRKeyword = 'US';
  static const String kVRName = 'Unsigned Short';
  static const int kSizeInBytes = 2;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  static bool isValidArgs(Tag tag, Iterable<int> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<int> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex || vrIndex == kUSSSIndex || vrIndex == kUSSSOWIndex)
      return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    final vrIndex = vrIndexFromCodeMap[vrCode];
    if (isValidVRIndex(vrIndex)) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl, [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(vfl, min, max, kSizeInBytes);

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      IntBase._isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

/// Unknown (OW) [Element].
abstract class OW extends Uint16Base with UndefinedLengthMixin {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get vflSize => 4;
  @override
  int get maxLength => kMaxLength;
  @override
  int get maxVFLength => kMaxLongVF;

  @override
  bool get isLengthAlwaysValid => true;

  static const int kVRIndex = kOWIndex;
  static const int kVRCode = kOWCode;
  static const String kVRKeyword = 'OW';
  static const String kVRName = 'Other Word';
  static const int kSizeInBytes = 2;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMax16BitLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  static bool isValidArgs(Tag tag, Iterable<int> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kOWIndex ||
        vrIndex == kOBOWIndex ||
        vrIndex == kUSSSOWIndex ||
        vrIndex == kUNIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    final vrIndex = vrIndexFromCodeMap[vrCode];
    if (isValidVRIndex(vrIndex)) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

  static bool isValidVListLength(int vfl) => true;

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      IntBase._isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

abstract class Uint32Base extends IntBase {
  @override
  int get sizeInBytes => kSizeInBytes;
  int get minValue => kMinValue;
  int get maxValue => kMaxValue;

  @override
  Uint32List get typedData => fromList(values);

  @override
  Uint32Base get sha256 => update(Sha256.uint32(typedData));

  @override
  bool checkValue(int v, {Issues issues, bool allowInvalid = false}) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  /// Returns a  an Uint8List View of [values].
  @override
  Uint32Base view([int start = 0, int length]) => update(
      typedData.buffer.asUint32List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  /// Returns a [BASE64] [String] created from [vList];
  static String toBase64(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      BASE64.encode(toBytes(vList, asView: asView, check: check));

  /// Returns a [Uint8List] created from [vList];
  static Uint8List toBytes(Iterable<int> vList,
      {bool asView = true, bool check = true}) =>
    _asUint8List(fromList(vList, asView: asView, check: check));


  /// Returns a [ByteData] created from [vList];
  static ByteData toByteData(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      _asByteData(fromList(vList, asView: asView, check: check));

  /// Returns a [Uint32List] with the same length as [vList]. If
  /// [vList] is a [Uint32List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No value checking
  /// is done.
  ///
  /// If [vList] is not a [Uint32List], then if [vList] has valid values,
  /// a new [Uint32List] is created and the values of [vList] are copied
  /// into it and returned; otherwise, [invalidValuesError] is called.
  static Uint32List fromList(Iterable<int> vList,
                             {bool asView = true, bool check = true}) {
    assert(vList != null);
    if (vList.isEmpty) return kEmptyUint32List;
    if (vList is Uint32List)
      return (asView) ? vList : new Uint32List.fromList(vList);
    if (check) {
      final td = new Uint32List(vList.length);
      return _copyList(vList, td, kMinValue, kMaxValue);
    }
    return new Uint32List.fromList(vList);
  }


  /// Returns a [Uint32List] from a [BASE64] [String].
  static Uint32List fromBase64(String s, {bool asView = true}) =>
      (s.isEmpty) ? kEmptyUint32List : fromBytes(BASE64.decode(s));

  /// Returns a [Uint32List] from a [Uint8List].
  static Uint32List fromBytes(Uint8List bytes, {bool asView = true}) =>
      _fromByteData(_asByteData(bytes), asView: asView);

  /// Returns a [Uint32List] from a [ByteData].
  static Uint32List fromByteData(ByteData bd, {bool asView = true}) =>
      _fromByteData(bd, asView: asView);

  /// /// Returns a [Uint32List] from a [ByteData].
  static Uint32List _fromByteData(ByteData bd, {bool asView = true}) {
    assert(bd != null && bd.lengthInBytes >= 0);
    if (bd.lengthInBytes == 0) return kEmptyUint32List;
    assert((bd.lengthInBytes % kSizeInBytes) == 0, 'lib: ${bd.lengthInBytes}');
    final length = bd.lengthInBytes ~/ kSizeInBytes;

    if (_isNotAligned(bd)) {
      final nList = new Uint32List(length);
      for (var i = 0, oib = 0; i < length; i++, oib += kSizeInBytes)
        nList[i] = bd.getInt32(oib, Endian.little);
      return nList;
    }
    final u32List = bd.buffer.asUint32List(bd.offsetInBytes, length);
    return (asView) ? u32List : new Uint32List.fromList(u32List);
  }

  static bool _isNotAligned(TypedData vList) =>
      (vList.offsetInBytes % kSizeInBytes) != 0;
}

/// Attribute Tag [Element].
abstract class AT extends Uint32Base {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get maxVFLength => kMaxShortVF;
  @override
  int get maxLength => kMaxLength;

//  static const VR kVR = VR.kAT;
  static const int kVRIndex = kATIndex;
  static const int kVRCode = kATCode;
  static const String kVRKeyword = 'AT';
  static const String kVRName = 'Attribute Tag';
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  static bool isValidArgs(Tag tag, Iterable<int> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<int> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    final vrIndex = vrIndexFromCodeMap[vrCode];
    if (isValidVRIndex(vrIndex)) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl, [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(vfl, min, max, kSizeInBytes);

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      IntBase._isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

/// Other Long [Element].
///
/// VFLength and Values length are always valid.
abstract class OL extends Uint32Base {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get vflSize => 4;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  int get maxLength => kMaxLength;
  @override
  bool get isLengthAlwaysValid => true;

//  static const VR kVR = VR.kOL;
  static const int kVRIndex = kOLIndex;
  static const int kVRCode = kOLCode;
  static const String kVRKeyword = 'OL';
  static const String kVRName = 'Other Long';
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMax32BitLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  static bool isValidArgs(Tag tag, Iterable<int> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    final vrIndex = vrIndexFromCodeMap[vrCode];
    if (isValidVRIndex(vrIndex)) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

  static bool isValidVListLength(int vfl) => true;

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      IntBase._isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

/// Unsigned Long [Element].
abstract class UL extends Uint32Base {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get maxVFLength => kMaxShortVF;
  @override
  int get maxLength => kMaxLength;

//  static const VR kVR = VR.kUL;
  static const int kVRIndex = kULIndex;
  static const int kVRCode = kULCode;
  static const String kVRKeyword = 'UL';
  static const String kVRName = 'Unsigned Long';
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  static bool isValidArgs(Tag tag, Iterable<int> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<int> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    final vrIndex = vrIndexFromCodeMap[vrCode];
    if (isValidVRIndex(vrIndex)) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl, [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(vfl, min, max, kSizeInBytes);

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      IntBase._isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

/// Group Length [Element] is a subtype of [UL]. It always has a tag
/// of the form (gggg,0000).
abstract class GL extends UL {
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRKeyword;

  static const String kVRKeyword = 'GL';
  static const String kVRName = 'Group Length';
}

/// An abstract class for 64-bit unsigned integers.
abstract class Uint64Base extends IntBase {
  @override
  int get sizeInBytes => kSizeInBytes;
  int get minValue => kMinValue;
  int get maxValue => kMaxValue;

  @override
  Uint64List get typedData => fromList(values);

  @override
  IntBase get sha256 => update(Sha256.int64(values));

  /// Returns a [Uint64List.view] of [values].
  @override
  Uint64Base view([int start = 0, int length]) {
    if (!checkLength(values)) return invalidValuesLengthError(tag, values);
    return update(
        typedData.buffer.asUint64List(start, _toLength(length, values.length)));
  }

  static const int kSizeInBytes = 8;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  /// Returns a [BASE64] [String] created from [vList];
  static String toBase64(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      BASE64.encode(toBytes(vList));

  /// Returns a [Uint8List] created from [vList];
  static Uint8List toBytes(Iterable<int> vList,
      {bool asView = true, bool check = true}) =>
      _asUint8List(fromList(vList, asView: asView, check: check));

  /// Returns a [ByteData] created from [vList];
  static ByteData toByteData(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      _asByteData(fromList(vList, asView: asView, check: check));

  /// Returns a [Uint64List] with the same length as [vList]. If
  /// [vList] is a [Uint64List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No value checking
  /// is done.
  ///
  /// If [vList] is not a [Uint64List], then if [vList] has valid values,
  /// a new [Uint64List] is created and the values of [vList] are copied
  /// into it and returned; otherwise, [invalidValuesError] is called.
  static Uint64List fromList(Iterable<int> vList,
                             {bool asView = true, bool check = true}) {
    assert(vList != null);
    if (vList.isEmpty) return kEmptyUint64List;
    if (vList is Uint64List)
      return (asView) ? vList : new Uint64List.fromList(vList);
    if (check) {
      final td = new Uint64List(vList.length);
      return _copyList(vList, td, kMinValue, kMaxValue);
    }
    return new Uint64List.fromList(vList);
  }

  /// Returns a [Uint64List] from a [BASE64] [String].
  static Uint64List fromBase64(String s, {bool asView = true}) =>
      (s.isEmpty) ? kEmptyUint64List : fromBytes(BASE64.decode(s));

  /// Returns a [Uint64List] from a [Uint8List].
  static Uint64List fromBytes(Uint8List bytes, {bool asView = true}) =>
      _fromByteData(_asByteData(bytes), asView: asView);

  /// Returns a [Uint64List] from a [ByteData].
  static Uint64List fromByteData(ByteData bd, {bool asView = true}) =>
      _fromByteData(bd);

  /// /// Returns a [Uint64List] from a [ByteData].
  static Uint64List _fromByteData(ByteData bd, {bool asView = true}) {
    assert(bd != null && bd.lengthInBytes >= 0);
    if (bd.lengthInBytes == 0) return kEmptyUint64List;
    assert((bd.lengthInBytes % kSizeInBytes) == 0, 'lib: ${bd.lengthInBytes}');
    final length = bd.lengthInBytes ~/ kSizeInBytes;

    if (_isNotAligned(bd)) {
      final nList = new Uint64List(length);
      for (var i = 0, oib = 0; i < length; i++, oib += kSizeInBytes)
        nList[i] = bd.getUint64(oib, Endian.little);
      return nList;
    }
    final f64List = bd.buffer.asUint64List(bd.offsetInBytes, length);
    return (asView) ? f64List : new Uint64List.fromList(f64List);
  }

  static bool _isNotAligned(TypedData vList) =>
      (vList.offsetInBytes % kSizeInBytes) != 0;
}

int _toLength(int length, int vLength) =>
    (length == null || length > vLength) ? vLength : length;

bool _inRange(int v, int min, int max) => v >= min && v <= max;

bool _notInRange(int v, int min, int max) => !_inRange(v, min, max);

bool _isValidVFLength(int vfl, int minBytes, int maxBytes, int sizeInBytes) =>
    _inRange(vfl, minBytes, maxBytes) && (vfl % sizeInBytes == 0);

bool _isValidList(Iterable<int> vList, int minValue, int maxValue) {
  for (var v in vList) if (_notInRange(v, minValue, maxValue)) return false;
  return true;
}

bool _isNotValidList(Iterable<int> vList, int minValue, int maxValue) =>
    !_isValidList(vList, minValue, maxValue);

Uint8List _asUint8List(TypedData td) {
  if (td == null) return null;
  if (td.lengthInBytes == 0) return kEmptyUint8List;
  return td.buffer.asUint8List(td.offsetInBytes, td.lengthInBytes);
}

/// Returns a [ByteData] created from [td];
ByteData _asByteData(TypedData td) {
  if (td == null) return null;
  if (td.lengthInBytes == 0) return kEmptyByteData;
  return td.buffer.asByteData(td.offsetInBytes, td.lengthInBytes);
}

List<int> _copyList(List<int> vList, List<int> td, int min, int max) {
  assert(td is TypedData);
  assert(vList.length == td.length);
  for (var i = 0; i < vList.length; i++) {
    final v = vList[i];
    if (v < min || v > max)
      // Enhancement: this could truncate or clamp the value if desired
      return invalidValuesError(vList);
    td[i] = v;
  }
  return td;
}
