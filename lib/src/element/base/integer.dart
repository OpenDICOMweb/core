// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/src/dicom.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/mixin/undefined_length_mixin.dart';
import 'package:core/src/element/crypto.dart';
import 'package:core/src/element/errors.dart';
import 'package:core/src/empty_list.dart';
import 'package:core/src/errors.dart';
import 'package:core/src/issues.dart';
import 'package:core/src/vr/vr.dart';
import 'package:core/src/tag/tag_lib.dart';

int _toLength(int length, int vLength) =>
    (length == null || length > vLength) ? vLength : length;

bool _inRange(int v, int min, int max) => v >= min && v <= max;

bool _notInRange(int v, int min, int max) => !_inRange(v, min, max);

bool _isValidVFLength(int vfl, int minBytes, int maxBytes, int sizeInBytes) =>
    _inRange(vfl, minBytes, maxBytes) && (vfl % sizeInBytes == 0);

bool _isValidList(Iterable<int> vList, int minValue, int maxValue) {
  if (vList is TypedData) return true;
  for (var v in vList) if (_notInRange(v, minValue, maxValue)) return false;
  return true;
}

bool _isNotValidList(Iterable<int> vList, int minValue, int maxValue) =>
    !_isValidList(vList, minValue, maxValue);

/* Flush when working
bool _isValidVListLength(Tag tag, int length, Issues issues, int maxLength) {
  final min = (tag == null) ? 0 : tag.vmMin;
  final max =
      (tag == null) ? maxLength : (tag.vmMax == -1) ? maxLength : tag.vmMax;
  assert((min >= 0) && (max >= 1) && (max <= maxLength));
  return _inRange(length, min, max);
}

Iterable<int> _coerceNumListToInt(Iterable<num> vList) {
  if (vList is Iterable<int>) return _checkListInt(vList);
  return _coerceList(vList);
}

/// Returns a valid [Iterable<int>] or [invalidListInteger].
Iterable<int> _checkListInt(Iterable<int> vList) {
  for (var i = 0; i < vList.length; i++)
    if (vList.elementAt(i) is! int) return _coerceList(vList);
  return vList;
}

Iterable<int> _coerceList(Iterable<num> iter) {
  final dList = new Int64List(iter.length);
  for (var i = 0; i < iter.length; i++) {
    final v = iter.elementAt(i);
    dList[i] = (v is int) ? v : _coerce(v);
  }
  return dList;
}

int _coerce(num v) => (v is num) ? v.toInt() : throw new TypeError();
*/

abstract class IntBase extends Element<int> {
  @override
  Iterable<int> get values;

  @override
  set values(Iterable<int> vList) => unsupportedError('IntBase.values');

  bool get isBinary => true;

  @override
  int get vfLength => values.length * sizeInBytes;

  @override
  int get padChar => unsupportedError('IntBase does not have a padChar');

  /// Returns a copy of [values]
  @override
  Iterable<int> get valuesCopy => new List.from(values, growable: false);

  /// The _canonical_ empty [values] value for Floating Point Elements.
  @override
  Iterable<int> emptyList = const <int>[];

  @override
  ByteData get vfByteData => typedData.buffer.asByteData();

  @override
  Uint8List get vfBytes => typedData.buffer.asUint8List();

  @override
  IntBase get noValues => update(kEmptyIntList);

  /// Returns a [view] of this [Element] with [values] replaced by [TypedData].
  IntBase view([int start = 0, int length]);

  @override
  IntBase update([Iterable<int> vList = kEmptyIntList]);

  @override
  IntBase updateF(Iterable<int> f(Iterable<int> vList));

  @override
  Iterable<int> replace([Iterable<int> vList = kEmptyIntList]) =>
      _replace(vList ?? kEmptyIntList);

  @override
  Iterable<int> replaceF(Iterable<int> f(Iterable<int> vList)) =>
      _replace(f(values) ?? kEmptyIntList);

  // This is a space & speed optimization - rather than [super.replace].
  Iterable<int> _replace(Iterable<int> vList) {
    //  final v = (vList is! Iterable<int>) ? vList.toIntList(vList) : vList;
    final old = values;
    values = vList;
    return old;
  }

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

  static bool _isValidValues(Tag tag, Iterable<int> vList, Issues issues, int minVLength,
      int maxVLength, int maxVFListLength) {
    if (!Element.isValidVListLength(tag, vList, issues, maxVFListLength)) return false;
    var result = true;
    for (var v in vList) result = _isValidValue(v, issues, minVLength, maxVLength);
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
  Int8List get typedData => _toInt8List(values);

  @override
  Int8Base get sha256 => update(Sha256.int16(typedData));

  @override
  bool checkValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  /// Returns a  an Uint8List View of [values].
  @override
  Int8Base view([int start = 0, int length]) =>
      update(typedData.buffer.asInt8List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 1;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = -(1 << (kSizeInBits - 1));
  static const int kMaxValue = (1 << (kSizeInBits - 1)) - 1;

  /// Returns a [BASE64] [String] created from [vList];
  static String listToBase64(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      BASE64.encode(listToBytes(vList, asView: asView, check: check));

  /// Returns a [Int8List] created from [vList];
  static Uint8List listToBytes(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final td = _toInt8List(vList, asView: asView, check: check);
    return td?.buffer?.asUint8List(td.offsetInBytes, td.lengthInBytes);
  }

  /// Returns a [ByteData] created from [vList];
  static ByteData listToByteData(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final td = _toInt8List(vList, check: check);
    return td?.buffer?.asByteData(td.offsetInBytes, td.lengthInBytes);
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
  static Int8List listFromBase64(String s, {bool asView = true, bool check = true}) {
    //TODO: convert to one line when Base6.decode is Uint8List.
    final Uint8List bytes = BASE64.decode(s);
    return listFromBytes(bytes);
  }

  /// Returns a [Int8List] from a [Uint8List].
  static Int8List listFromBytes(Uint8List bytes, {bool asView = true}) =>
      _listFromByteData(bytes.buffer.asByteData(), asView: asView);

  /// Returns a [Int8List] from a [ByteData].
  static Int8List listFromByteData(ByteData bd, {bool asView = true}) =>
      _listFromByteData(bd, asView: asView);

  /// /// Returns a [Int8List] from a [ByteData].
  static Int8List _listFromByteData(ByteData bd, {bool asView = true}) {
    assert(bd != null && bd.lengthInBytes >= 0);
    if (bd.lengthInBytes == 0) return kEmptyInt8List;
    assert((bd.lengthInBytes % kSizeInBytes) == 0, 'lib: ${bd.lengthInBytes}');
    final length = bd.lengthInBytes ~/ kSizeInBytes;
    final i16List = bd.buffer.asInt8List(bd.offsetInBytes, length);
    return (asView) ? i16List : new Int8List.fromList(i16List);
  }
}

abstract class Int16Base extends IntBase {
  @override
  int get sizeInBytes => kSizeInBytes;
  int get minValue => kMinValue;
  int get maxValue => kMaxValue;

  @override
  Int16List get typedData => _toInt16List(values);

  @override
  Int16Base get sha256 => update(Sha256.int16(typedData));

  @override
  bool checkValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  /// Returns a  an Uint8List View of [values].
  @override
  Int16Base view([int start = 0, int length]) =>
      update(typedData.buffer.asInt16List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 2;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = -(1 << (kSizeInBits - 1));
  static const int kMaxValue = (1 << (kSizeInBits - 1)) - 1;

  /// Returns a [BASE64] [String] created from [vList];
  static String listToBase64(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      BASE64.encode(listToBytes(vList, asView: asView, check: check));

  /// Returns a [Int16List] created from [vList];
  static Uint8List listToBytes(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final td = _toInt16List(vList, asView: asView, check: check);
    return td?.buffer?.asUint8List(td.offsetInBytes, td.lengthInBytes);
  }

  /// Returns a [ByteData] created from [vList];
  static ByteData listToByteData(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final td = _toInt16List(vList, check: check);
    return td?.buffer?.asByteData(td.offsetInBytes, td.lengthInBytes);
  }

  static Int16List toInt16List(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      _toInt16List(vList, asView: asView, check: check);

  static Int16List _toInt16List(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    assert(vList != null);
    if (vList is Int16List) return vList;
    if ((check && _isNotValidList(vList, kMinValue, kMaxValue)))
      return invalidValuesError(vList);
    return new Int16List.fromList(vList);
  }

  /// Returns a [Int16List] from a [BASE64] [String].
  static Int16List listFromBase64(String s, {bool asView = true, bool check = true}) {
    //TODO: convert to one line when Base6.decode is Uint8List.
    final Uint8List bytes = BASE64.decode(s);
    return listFromBytes(bytes);
  }

  /// Returns a [Int16List] from a [Uint8List].
  static Int16List listFromBytes(Uint8List bytes, {bool asView = true}) =>
      _listFromByteData(bytes.buffer.asByteData(), asView: asView);

  /// Returns a [Int16List] from a [ByteData].
  static Int16List listFromByteData(ByteData bd, {bool asView = true}) =>
      _listFromByteData(bd, asView: asView);

  /// /// Returns a [Int16List] from a [ByteData].
  static Int16List _listFromByteData(ByteData bd, {bool asView = true}) {
    assert(bd != null && bd.lengthInBytes >= 0);
    if (bd.lengthInBytes == 0) return kEmptyInt16List;
    assert((bd.lengthInBytes % kSizeInBytes) == 0, 'lib: ${bd.lengthInBytes}');
    final length = bd.lengthInBytes ~/ kSizeInBytes;
    final i16List = bd.buffer.asInt16List(bd.offsetInBytes, length);
    return (asView) ? i16List : new Int16List.fromList(i16List);
  }
}

/// Signed Short [Element].
abstract class SS extends Int16Base {
//  @override
  //Urgent Jim Fix
  //VR get vr => vrFromIndex(kVRIndex);
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
      (isValidVRIndex(tag.vrIndex) && vList != null && isValidValues(tag, vList));

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  //TODO: unit test for all isValidVListLength methods when fast tag is available
  static bool isValidVListLength(Tag tag, Iterable<int> vList, [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex || vrIndex == kUSSSIndex || vrIndex == kUSSSOWIndex)
      return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    final vrIndex = vrIndexFromCodeMap[vrCode];
    if (vrIndex == kVRIndex || vrIndex == kUSSSIndex || vrIndex == kUSSSOWIndex)
      return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl, [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(vfl, min, max, kSizeInBytes);

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      IntBase._isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
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
  bool checkValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  /// Returns an Int32List View of [values].
  @override
  SL view([int start = 0, int length]) =>
      update(typedData.buffer.asInt32List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = -(1 << (kSizeInBits - 1));
  static const int kMaxValue = (1 << (kSizeInBits - 1)) - 1;

  /// Returns a [BASE64] [String] created from [vList];
  static String listToBase64(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      BASE64.encode(listToBytes(vList, check: check));

  /// Returns a [Int32List] created from [vList];
  static Uint8List listToBytes(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final td = _toInt32List(vList, asView: asView, check: check);
    return td?.buffer?.asUint8List(td.offsetInBytes, td.lengthInBytes);
  }

  /// Returns a [ByteData] created from [vList];
  static ByteData listToByteData(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final td = _toInt32List(vList, check: check);
    return td?.buffer?.asByteData(td.offsetInBytes, td.lengthInBytes);
  }

  static Int32List toInt32List(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      _toInt32List(vList, asView: asView, check: check);

  static Int32List _toInt32List(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    assert(vList != null);
    if (vList is Int32List) return vList;
    if ((check && _isNotValidList(vList, kMinValue, kMaxValue)))
      return invalidValuesError(vList);
    return new Int32List.fromList(vList);
  }

  /// Returns a [Int32List] from a [BASE64] [String].
  static Int32List listFromBase64(String s, {bool asView = true}) {
    //TODO: convert to one line when Base6.decode is Uint8List.
    final Uint8List bytes = BASE64.decode(s);
    return listFromBytes(bytes);
  }

  /// Returns a [Int32List] from a [Uint8List].
  static Int32List listFromBytes(Uint8List bytes, {bool asView = true}) =>
      _listFromByteData(bytes.buffer.asByteData(), asView: true);

  /// Returns a [Int32List] from a [ByteData].
  static Int32List listFromByteData(ByteData bd, {bool asView = true}) =>
      _listFromByteData(bd, asView: true);

  /// /// Returns a [Int32List] from a [ByteData].
  static Int32List _listFromByteData(ByteData bd, {bool asView = true}) {
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

  static bool _isNotAligned(TypedData vList) =>(vList.offsetInBytes % kSizeInBytes) != 0;
}

/// Signed Long ([SL]) [Element].
abstract class SL extends Int32Base {
//  @override
  //Urgent Jim Fix
  //VR get vr => vrFromIndex(kVRIndex);
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
      (isValidVRIndex(tag.vrIndex) && vList != null && isValidValues(tag, vList));

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<int> vList, [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl, [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(vfl, min, max, kSizeInBytes);

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      IntBase._isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

/// An abstract class for 64-bit integers.
abstract class Int64Base extends IntBase {
  @override
  int get sizeInBytes => kSizeInBytes;
  int get minValue => kMinValue;
  int get maxValue => kMaxValue;

  @override
  Int64List get typedData => _toInt64List(values);

  @override
  IntBase get sha256 => update(Sha256.int64(values));

  /// Returns a [Int64List.view] of [values].
  @override
  Int64Base view([int start = 0, int length]) {
    if (!checkLength(values)) return invalidValuesLengthError(tag, values);
    return update(typedData.buffer.asInt64List(start, _toLength(length, values.length)));
  }

  static const int kSizeInBytes = 8;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  /// Returns a [BASE64] [String] created from [vList];
  static String listToBase64(Iterable<int> vList,
                             {bool asView = true, bool check = true}) =>
      BASE64.encode(listToBytes(vList));

  /// Returns a [Uint8List] created from [vList];
  static Uint8List listToBytes(Iterable<int> vList,
                               {bool asView = true, bool check = true}) {
    final td = _toInt64List(vList);
    return td?.buffer?.asUint8List(td.offsetInBytes, td.lengthInBytes);
  }

  /// Returns a [ByteData] created from [vList];
  static ByteData listToByteData(Iterable<int> vList,
                                 {bool asView = true, bool check = true}) {
    final td = _toInt64List(vList);
    return td?.buffer?.asByteData(td.offsetInBytes, td.lengthInBytes);
  }

  static Int64List toInt64List(Iterable<int> vList,
                                 {bool asView = true, bool check = true}) =>
      _toInt64List(vList);

  static Int64List _toInt64List(Iterable<int> vList,
                                  {bool asView = true, bool check = true}) {
    assert(vList != null);
    if (vList is Int64List) return vList;
    if ((check && _isNotValidList(vList, kMinValue, kMaxValue)))
      return invalidValuesError(vList);
    return new Int64List.fromList(vList);
  }

  /// Returns a [Int64List] from a [BASE64] [String].
  static Int64List listFromBase64(String s, {bool asView = true}) {
    if (s.isEmpty) return kEmptyInt64List;
    // TODO: cleanup when the type of Base64.decode is Uint8List.
    final Uint8List bytes = BASE64.decode(s);
    return listFromBytes(bytes);
  }

  /// Returns a [Int64List] from a [Uint8List].
  static Int64List listFromBytes(Uint8List bytes, {bool asView = true}) =>
      _listFromByteData(bytes.buffer.asByteData());

  /// Returns a [Int64List] from a [ByteData].
  static Int64List listFromByteData(ByteData bd, {bool asView = true}) =>
      _listFromByteData(bd);

  /// /// Returns a [Int64List] from a [ByteData].
  static Int64List _listFromByteData(ByteData bd, {bool asView = true}) {
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

  static bool _isNotAligned(TypedData vList) => (vList.offsetInBytes % kSizeInBytes) != 0;
}

abstract class Uint8Base extends IntBase {
  @override
  int get sizeInBytes => kSizeInBytes;
  int get minValue => kMinValue;
  int get maxValue => kMaxValue;

  @override
  Uint8List get typedData => _toUint8List(values);

  @override
  Uint8Base get sha256 => update(Sha256.uint8(typedData));

  @override
  bool checkValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  /// Returns a  an Uint8List View of [values].
  @override
  Uint8Base view([int start = 0, int length]) =>
      update(typedData.buffer.asUint8List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 1;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;
  static const int kMaxVFLength = kMax8BitLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  /// Returns a [BASE64] [String] created from [vList];
  static String listToBase64(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      BASE64.encode(listToBytes(vList, asView: asView, check: check));

  /// Returns a [Uint8List] created from [vList];
  static Uint8List listToBytes(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final td = toUint8List(vList, asView: asView, check: check);
    return td?.buffer?.asUint8List(td.offsetInBytes, td.lengthInBytes);
  }

  /// Returns a [ByteData] created from [vList];
  static ByteData listToByteData(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final td = toUint8List(vList, asView: asView, check: check);
    return td?.buffer?.asByteData(td.offsetInBytes, td.lengthInBytes);
  }

  static Uint8List toUint8List(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      _toUint8List(vList, asView: asView, check: check);

  static Uint8List _toUint8List(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    assert(vList != null);
    if (vList is Uint8List) return vList;
    if ((check && _isNotValidList(vList, kMinValue, kMaxValue)))
      return invalidValuesError(vList);
    return new Uint8List.fromList(vList);
  }

  /// Returns a [Uint8List] from a [BASE64] [String].
  static Uint8List listFromBase64(String s, {bool asView = true, bool check = true}) {
    final Uint8List bytes = BASE64.decode(s);
    return listFromBytes(bytes);
  }

  /// Returns a [Uint8List] from a [Uint8List].
  static Uint8List listFromBytes(Uint8List bytes,
          {bool asView = true, bool check = true}) =>
      _listFromTypedData(bytes, asView: asView, check: check);

  /// Returns a [Uint8List] from a [ByteData].
  static Uint8List listFromByteData(ByteData bd,
          {bool asView = true, bool check = true}) =>
      _listFromTypedData(bd, asView: asView, check: check);

  /// /// Returns a [Uint8List] from a [TypedData].
  static Uint8List _listFromTypedData(TypedData td,
      {bool asView = true, bool check = true}) {
    assert(td != null && td is TypedData);
    assert((td.lengthInBytes % kSizeInBytes) == 0);
    final length = td.lengthInBytes ~/ kSizeInBytes;
    final asUint8List = td.buffer.asUint8List(td.offsetInBytes, length);
    return (asView) ? asUint8List : new Uint8List.fromList(asUint8List);
  }
}

/// Other Byte [Element].
abstract class OB extends Uint8Base with UndefinedLengthMixin {
//  @override
//  VR get vr => kVR;
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
      (isValidVRIndex(tag.vrIndex) && vList != null && isValidValues(tag, vList));

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kOBIndex || vrIndex == kOBOWIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode || vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

  static bool isValidVListLength(int vfl) => true;

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      IntBase._isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

/// Unknown (UN) [Element].
abstract class UN extends Uint8Base with UndefinedLengthMixin {
//  @override
//  VR get vr => kVR;
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
      (isValidVRIndex(tag.vrIndex) && vList != null && isValidValues(tag, vList));

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int index, [Issues issues]) => true;

  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      vrIndexFromCode(vrCode) != null;

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

  static bool isValidVListLength(int vfl) => true;

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      IntBase._isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

abstract class Uint16Base extends IntBase {
  @override
  int get sizeInBytes => kSizeInBytes;
  int get minValue => kMinValue;
  int get maxValue => kMaxValue;

  @override
  Uint16List get typedData => _toUint16List(values);

  @override
  Uint16Base get sha256 => update(Sha256.uint16(typedData));

  @override
  bool checkValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  /// Returns a  an Uint8List View of [values].
  @override
  Uint16Base view([int start = 0, int length]) =>
      update(typedData.buffer.asUint16List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 2;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  /// Returns a [BASE64] [String] created from [vList];
  static String listToBase64(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      BASE64.encode(listToBytes(vList, asView: asView, check: check));

  /// Returns a [Uint8List] created from [vList];
  static Uint8List listToBytes(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final td = _toUint16List(vList, asView: asView, check: check);
    return td?.buffer?.asUint8List(td.offsetInBytes, td.lengthInBytes);
  }

  /// Returns a [ByteData] created from [vList];
  static ByteData listToByteData(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final td = _toUint16List(vList, asView: asView, check: check);
    return td?.buffer?.asByteData(td.offsetInBytes, td.lengthInBytes);
  }

  static Uint16List toUint16List(Iterable<int> vList, {bool asView = true}) =>
      _toUint16List(vList);

  static Uint16List _toUint16List(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    assert(vList != null);
    if (vList is Uint16List) return vList;
    if ((check && _isNotValidList(vList, kMinValue, kMaxValue)))
      return invalidValuesError(vList);
    return new Uint16List.fromList(vList);
  }

  /// Returns a [Uint16List] from a [BASE64] [String].
  static Uint16List listFromBase64(String s, {bool asView = true, bool check = true}) {
    final Uint8List bytes = BASE64.decode(s);
    return listFromBytes(bytes);
  }

  /// Returns a [Uint16List] from a [Uint8List].
  static Uint16List listFromBytes(Uint8List bytes, {bool asView = true}) =>
      _listFromByteData(bytes.buffer.asByteData(), asView: asView);

  /// Returns a [Uint16List] from a [ByteData].
  static Uint16List listFromByteData(ByteData bd, {bool asView = true}) =>
      _listFromByteData(bd, asView: asView);

  /// /// Returns a [Uint16List] from a [ByteData].
  static Uint16List _listFromByteData(ByteData bd, {bool asView = true}) {
    assert(bd != null && bd.lengthInBytes >= 0);
    if (bd.lengthInBytes == 0) return kEmptyUint16List;
    assert((bd.lengthInBytes % kSizeInBytes) == 0, 'lib: ${bd.lengthInBytes}');
    final length = bd.lengthInBytes ~/ kSizeInBytes;

    if (_isNotAligned(bd)) {
      final nList = new Uint16List(length);
      for (var i = 0, oib = 0; i < length; i++, oib += kSizeInBytes)
        nList[i] = bd.getInt16(oib, Endian.little);
      return nList;
    }
    final u16List = bd.buffer.asUint16List(bd.offsetInBytes, length);
    return (asView) ? u16List : new Uint16List.fromList(u16List);
  }

  static bool _isNotAligned(TypedData vList) => (vList.offsetInBytes % kSizeInBytes) != 0;
}

/// Other Byte [Element].
abstract class US extends Uint16Base {
//  @override
  //Urgent Jim Fix
  //VR get vr => vrFromIndex(kVRIndex);
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
      (isValidVRIndex(tag.vrIndex) && vList != null && isValidValues(tag, vList));

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<int> vList, [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex || vrIndex == kUSSSIndex || vrIndex == kUSSSOWIndex)
      return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    final vrIndex = vrIndexFromCodeMap[vrCode];
    if (vrIndex == kVRIndex || vrIndex == kUSSSIndex || vrIndex == kUSSSIndex)
      return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl, [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(vfl, min, max, kSizeInBytes);

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      IntBase._isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

/// Unknown (OW) [Element].
abstract class OW extends Uint16Base with UndefinedLengthMixin {
//  @override
//  VR get vr => kVR;
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
  int get maxVFLength => kMaxLongVF;
  @override
  int get maxLength => kMaxLength;
  @override
  bool get isLengthAlwaysValid => true;

//  static const VR kVR = VR.kOW;
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
      (isValidVRIndex(tag.vrIndex) && vList != null && isValidValues(tag, vList));

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kOWIndex || vrIndex == kOBOWIndex || vrIndex == kUSSSOWIndex)
      return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    final vrIndex = vrIndexFromCodeMap[vrCode];
    if (vrIndex == kVRIndex || vrIndex == kOBOWIndex || vrIndex == kUSSSOWIndex)
      return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

  static bool isValidVListLength(int vfl) => true;

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      IntBase._isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

abstract class Uint32Base extends IntBase {
  @override
  int get sizeInBytes => kSizeInBytes;
  int get minValue => kMinValue;
  int get maxValue => kMaxValue;

  @override
  Uint32List get typedData => _toUint32List(values);

  @override
  Uint32Base get sha256 => update(Sha256.uint32(typedData));

  @override
  bool checkValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  /// Returns a  an Uint8List View of [values].
  @override
  Uint32Base view([int start = 0, int length]) =>
      update(typedData.buffer.asUint32List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  /// Returns a [BASE64] [String] created from [vList];
  static String listToBase64(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      BASE64.encode(listToBytes(vList, asView: asView, check: check));

  /// Returns a [Uint8List] created from [vList];
  static Uint8List listToBytes(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final td = _toUint32List(vList, asView: asView, check: check);
    return td?.buffer?.asUint8List(td.offsetInBytes, td.lengthInBytes);
  }

  /// Returns a [ByteData] created from [vList];
  static ByteData listToByteData(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final td = _toUint32List(vList, asView: asView, check: check);
    return td?.buffer?.asByteData(td.offsetInBytes, td.lengthInBytes);
  }

  static Uint32List toUint32List(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      _toUint32List(vList, asView: asView, check: check);

  static Uint32List _toUint32List(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    assert(vList != null);
    if (vList is Uint32List) return vList;
    if ((check && _isNotValidList(vList, kMinValue, kMaxValue)))
      return invalidValuesError(vList);
    return new Uint32List.fromList(vList);
  }

  /// Returns a [Uint32List] from a [BASE64] [String].
  static Uint32List listFromBase64(String s, {bool asView = true}) {
    final Uint8List bytes = BASE64.decode(s);
    return listFromBytes(bytes);
  }

  /// Returns a [Uint32List] from a [Uint8List].
  static Uint32List listFromBytes(Uint8List bytes, {bool asView = true}) =>
      _listFromByteData(bytes.buffer.asByteData(), asView: asView);

  /// Returns a [Uint32List] from a [ByteData].
  static Uint32List listFromByteData(ByteData bd, {bool asView = true}) =>
      _listFromByteData(bd, asView: asView);

  /// /// Returns a [Uint32List] from a [ByteData].
  static Uint32List _listFromByteData(ByteData bd, {bool asView = true}) {
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

  static bool _isNotAligned(TypedData vList) => (vList.offsetInBytes % kSizeInBytes) != 0;
}

/// Attribute Tag [Element].
abstract class AT extends Uint32Base {
//  @override
  //Urgent Jim Fix
  //VR get vr => vrFromIndex(kVRIndex);
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
      (isValidVRIndex(tag.vrIndex) && vList != null && isValidValues(tag, vList));

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<int> vList, [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl, [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(vfl, min, max, kSizeInBytes);

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      IntBase._isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

/// Other Long [Element].
///
/// VFLength and Values length are always valid.
abstract class OL extends Uint32Base {
//  @override
  //Urgent Jim Fix
  //VR get vr => vrFromIndex(kVRIndex);
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
      (isValidVRIndex(tag.vrIndex) && vList != null && isValidValues(tag, vList));

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

  static bool isValidVListLength(int vfl) => true;

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      IntBase._isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
}

/// Unsigned Long [Element].
abstract class UL extends Uint32Base {
//  @override
//  VR get vr => kVR;
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
      (isValidVRIndex(tag.vrIndex) && vList != null && isValidValues(tag, vList));

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<int> vList, [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static bool isValidVFLength(int vfl, [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(vfl, min, max, kSizeInBytes);

  static bool isValidValue(int v, [Issues issues]) =>
      IntBase._isValidValue(v, issues, kMinValue, kMaxValue);

  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      IntBase._isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);
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
  Uint64List get typedData => _toUint64List(values);

  @override
  IntBase get sha256 => update(Sha256.int64(values));

  /// Returns a [Uint64List.view] of [values].
  @override
  Uint64Base view([int start = 0, int length]) {
    if (!checkLength(values)) return invalidValuesLengthError(tag, values);
    return update(typedData.buffer.asUint64List(start, _toLength(length, values.length)));
  }

  static const int kSizeInBytes = 8;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  /// Returns a [BASE64] [String] created from [vList];
  static String listToBase64(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      BASE64.encode(listToBytes(vList));

  /// Returns a [Uint8List] created from [vList];
  static Uint8List listToBytes(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final td = _toUint64List(vList);
    return td?.buffer?.asUint8List(td.offsetInBytes, td.lengthInBytes);
  }

  /// Returns a [ByteData] created from [vList];
  static ByteData listToByteData(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final td = _toUint64List(vList);
    return td?.buffer?.asByteData(td.offsetInBytes, td.lengthInBytes);
  }

  static Uint64List toUint64List(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      _toUint64List(vList);

  static Uint64List _toUint64List(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    assert(vList != null);
    if (vList is Uint64List) return vList;
    if ((check && _isNotValidList(vList, kMinValue, kMaxValue)))
      return invalidValuesError(vList);
    return new Uint64List.fromList(vList);
  }

  /// Returns a [Uint64List] from a [BASE64] [String].
  static Uint64List listFromBase64(String s, {bool asView = true}) {
    if (s.isEmpty) return kEmptyUint64List;
    // TODO: cleanup when the type of Base64.decode is Uint8List.
    final Uint8List bytes = BASE64.decode(s);
    return listFromBytes(bytes);
  }

  /// Returns a [Uint64List] from a [Uint8List].
  static Uint64List listFromBytes(Uint8List bytes, {bool asView = true}) =>
      _listFromByteData(bytes.buffer.asByteData());

  /// Returns a [Uint64List] from a [ByteData].
  static Uint64List listFromByteData(ByteData bd, {bool asView = true}) =>
      _listFromByteData(bd);

  /// /// Returns a [Uint64List] from a [ByteData].
  static Uint64List _listFromByteData(ByteData bd, {bool asView = true}) {
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

  static bool _isNotAligned(TypedData vList) => (vList.offsetInBytes % kSizeInBytes) != 0;
}
