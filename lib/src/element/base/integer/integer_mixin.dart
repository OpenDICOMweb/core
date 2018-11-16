//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:convert';
import 'dart:typed_data';

import 'package:core/src/element/base/crypto.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/integer/int_bulkdata_ref.dart';
import 'package:core/src/element/base/integer/integer.dart';
import 'package:core/src/element/base/integer/utils.dart';
import 'package:core/src/element/base/utils.dart';
import 'package:core/src/error/element_errors.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/primitives.dart';

// ignore_for_file: public_member_api_docs

/// A mixin class for 8-bit signed integer [Element]s.
mixin Int8 {
  List<int> get values;
  Element update(TypedData vList);
  // **** End of Interface ****

  int get sizeInBytes => kSizeInBytes;
  int get lengthInBytes => length * sizeInBytes;
  int get length => values.length;
  int get minValue => kMinValue;
  int get maxValue => kMaxValue;

  List<int> get emptyList => kEmptyInt8List;
  Int8List get typedData => fromList(values);
  Uint8List get bulkdata => typedData.buffer.asUint8List();
  Integer get sha256 => update(Sha256.int8(typedData));

  bool checkValue(int v, {Issues issues, bool allowInvalid = false}) =>
      Integer.isValidValue(v, issues, kMinValue, kMaxValue);

  /// Returns a  an Uint8List View of [values].
  Integer view([int start = 0, int length]) => update(
      typedData.buffer.asInt8List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 1;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = -(1 << (kSizeInBits - 1));
  static const int kMaxValue = (1 << (kSizeInBits - 1)) - 1;

  /// Returns the [values] length that corresponds to [vfLength].
  static int getLength(int vfLength) =>
      vfLengthToLength(vfLength, kSizeInBytes);

  /// Returns a [Bytes] created from [vList];
  static Bytes toBytes(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asBytes(bList);
  }

  /// Returns a [Uint8List] created from [vList];
  static Uint8List toUint8List(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asUint8List(bList);
  }

  /// Returns a [ByteData] created from [vList];
  static ByteData toByteData(List<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asByteData(bList);
  }

  /// Returns a [base64] [String] created from [vList];
  static String toBase64(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bytes = toBytes(vList, asView: asView, check: check);
    return (bytes == null) ? null : base64.encode(bytes);
  }

  /// Returns a [Int8List] with the same length as [vList]. If
  /// [vList] is a [Int8List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No values checking
  /// is done.
  ///
  /// If [vList] is not a [Int8List], then if [vList] has valid values,
  /// a new [Int8List] is created and the values of [vList] are copied
  /// into it and returned; otherwise, [badValues] is called.
  static Int8List fromList(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    if (vList == null || vList.isEmpty) return kEmptyInt8List;
    if (vList is Int8List) return asView ? vList : Int8List.fromList(vList);
    if (check) {
      final td = Int8List(vList.length);
      return _copyList(vList, td, kMinValue, kMaxValue);
    }
    return Int8List.fromList(vList);
  }

  static Int8List toInt8List(Iterable<int> vList,
          {bool asView = true, bool check = true}) =>
      _toInt8List(vList, asView: asView, check: check);

  static Int8List _toInt8List(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    assert(vList != null);
    if (vList is Int8List) return vList;
    if (check && _isNotValidList(vList, kMinValue, kMaxValue))
      return badValues(vList);
    return Int8List.fromList(vList);
  }

  /// Returns a [Int8List] from a [base64] [String].
  static Int8List fromBase64(String s,
          {bool asView = true, bool check = true}) =>
      (s.isEmpty) ? kEmptyInt8List : fromUint8List(base64.decode(s));

  /// Returns a [Int8List] from a [Uint8List].
  static Int8List fromUint8List(Uint8List bytes,
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
    if (td.lengthInBytes == 0) return Integer.kEmptyList;
    final length = td.lengthInBytes;
    final asInt8List = td.buffer.asInt8List(td.offsetInBytes, length);
    return asView ? asInt8List : Int8List.fromList(asInt8List);
  }

  static List<int> fromValueField(Iterable vf) {
    if (vf == null) return kEmptyInt8List;
    if (vf is Int8List || vf is List<int> || vf.isEmpty || vf is IntBulkdataRef)
      return vf;
    if (vf is Bytes) return vf.asInt8List();
    if (vf is Uint8List) return fromUint8List(vf);
    return badValues(vf);
  }
}

/// A mixin class for 16-bit signed integer [Element]s.
mixin Int16 {
  List<int> get values;
  Element<int> update([Iterable<int> vList]);
  // **** End of Interface ****

  int get sizeInBytes => kSizeInBytes;
  int get lengthInBytes => length * sizeInBytes;
  int get length => values.length;
  int get minValue => kMinValue;
  int get maxValue => kMaxValue;

  List<int> get emptyList => kEmptyInt16List;
  Int16List get typedData => fromList(values);
  Uint8List get bulkdata => typedData.buffer.asUint8List();
  Integer get sha256 => update(Sha256.int16(typedData));

  bool checkValue(int v, {Issues issues, bool allowInvalid = false}) =>
      Integer.isValidValue(v, issues, kMinValue, kMaxValue);

  /// Returns a  an Uint8List View of [values].
  Integer view([int start = 0, int length]) => update(
      typedData.buffer.asInt16List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 2;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = -(1 << (kSizeInBits - 1));
  static const int kMaxValue = (1 << (kSizeInBits - 1)) - 1;

  static int getLength(int vfLength) =>
      vfLengthToLength(vfLength, kSizeInBytes);

  /// Returns a [Bytes] created from [vList];
  static Bytes toBytes(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asBytes(bList);
  }

  /// Returns a [Uint8List] created from [vList];
  static Uint8List toUint8List(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asUint8List(bList);
  }

  /// Returns a [ByteData] created from [vList];
  static ByteData toByteData(List<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asByteData(bList);
  }

  /// Returns a [base64] [String] created from [vList];
  static String toBase64(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bytes = toBytes(vList, asView: asView, check: check);
    return (bytes == null) ? null : base64.encode(bytes);
  }

  /// Returns a [Int16List] with the same length as [vList]. If
  /// [vList] is a [Int16List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No values checking
  /// is done.
  ///
  /// If [vList] is not a [Int16List], then if [vList] has valid values,
  /// a new [Int16List] is created and the values of [vList] are copied
  /// into it and returned; otherwise, [badValues] is called.
  static Int16List fromList(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    if (vList == null || vList.isEmpty) return kEmptyInt16List;
    if (vList is Int16List) return asView ? vList : Int16List.fromList(vList);
    if (check) {
      final td = Int16List(vList.length);
      final Int16List v = _copyList(vList, td, kMinValue, kMaxValue);
      return v;
    }
    return Int16List.fromList(vList);
  }

  /// Returns a [Int16List] from a [base64] [String].
  static Int16List fromBase64(String s,
          {bool asView = true, bool check = true}) =>
      (s.isEmpty) ? kEmptyInt16List : fromUint8List(base64.decode(s));

  /// Returns a [Int16List] from a [Uint8List].
  static Int16List fromUint8List(Uint8List bytes, {bool asView = true}) =>
      _fromByteData(asByteData(bytes), asView: asView);

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
      final vList = Int16List(length);
      for (var i = 0, oib = 0; i < length; i++, oib += kSizeInBytes)
        vList[i] = bd.getInt16(oib, Endian.little);
      // Returning a new list
      return vList;
    }
    final i16List = bd.buffer.asInt16List(bd.offsetInBytes, length);
    return asView ? i16List : Int16List.fromList(i16List);
  }

  static bool _isNotAligned(TypedData vList) =>
      (vList.offsetInBytes % kSizeInBytes) != 0;

  static List<int> fromValueField(Iterable vf) {
    if (vf == null) return kEmptyInt16List;
    if (vf is Int16List ||
        vf is List<int> ||
        vf.isEmpty ||
        vf is IntBulkdataRef) return vf;
    if (vf is Bytes) return vf.asInt16List();
    if (vf is Uint8List) return fromUint8List(vf);
    return badValues(vf);
  }
}

/// A mixin class for 32-bit signed integer [Element]s.
mixin Int32 {
  List<int> get values;
  Element<int> update([Iterable<int> vList]);
  // **** End of Interface ****

  int get sizeInBytes => kSizeInBytes;
  int get lengthInBytes => length * sizeInBytes;
  int get length => values.length;
  int get minValue => kMinValue;
  int get maxValue => kMaxValue;

  List<int> get emptyList => kEmptyInt16List;
  Int32List get typedData => fromList(values);
  Uint8List get bulkdata => typedData.buffer.asUint8List();
  Integer get sha256 => update(Sha256.int32(typedData));

  bool checkValue(int v, {Issues issues, bool allowInvalid = false}) =>
      Integer.isValidValue(v, issues, kMinValue, kMaxValue);

  /// Returns an Int32List View of [values].
  Integer view([int start = 0, int length]) => update(
      typedData.buffer.asInt32List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = -(1 << (kSizeInBits - 1));
  static const int kMaxValue = (1 << (kSizeInBits - 1)) - 1;

  /// Returns the [values] length that corresponds to [vfLength].
  static int getLength(int vfLength) =>
      vfLengthToLength(vfLength, kSizeInBytes);

  /// Returns a [Bytes] created from [vList];
  static Bytes toBytes(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asBytes(bList);
  }

  /// Returns a [Uint8List] created from [vList];
  static Uint8List toUint8List(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asUint8List(bList);
  }

  /// Returns a [ByteData] created from [vList];
  static ByteData toByteData(List<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asByteData(bList);
  }

  /// Returns a [base64] [String] created from [vList];
  static String toBase64(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bytes = toBytes(vList, asView: asView, check: check);
    return (bytes == null) ? null : base64.encode(bytes);
  }

  /// Returns a [Int32List] with the same length as [vList]. If
  /// [vList] is a [Int32List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No values checking
  /// is done.
  ///
  /// If [vList] is not a [Int32List], then if [vList] has valid values,
  /// a new [Int32List] is created and the values of [vList] are copied
  /// into it and returned; otherwise, [badValues] is called.
  static Int32List fromList(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    if (vList == null || vList.isEmpty) return kEmptyInt32List;
    if (vList is Int32List) return asView ? vList : Int32List.fromList(vList);
    if (check) {
      final td = Int32List(vList.length);
      return _copyList(vList, td, kMinValue, kMaxValue);
    }
    return Int32List.fromList(vList);
  }

  /// Returns a [Int32List] from a [base64] [String].
  static Int32List fromBase64(String s, {bool asView = true}) =>
      (s.isEmpty) ? kEmptyInt32List : fromUint8List(base64.decode(s));

  /// Returns a [Int32List] from a [Uint8List].
  static Int32List fromUint8List(Uint8List bytes, {bool asView = true}) =>
      _fromByteData(asByteData(bytes), asView: asView);

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
      final nList = Int32List(length);
      for (var i = 0, oib = 0; i < length; i++, oib += kSizeInBytes)
        nList[i] = bd.getInt32(oib, Endian.little);
      return nList;
    }
    final i32List = bd.buffer.asInt32List(bd.offsetInBytes, length);
    return asView ? i32List : Int32List.fromList(i32List);
  }

  static bool _isNotAligned(TypedData vList) =>
      (vList.offsetInBytes % kSizeInBytes) != 0;

  static List<int> fromValueField(Iterable vf) {
    if (vf == null) return kEmptyInt32List;
    if (vf is Int32List ||
        vf is List<int> ||
        vf.isEmpty ||
        vf is IntBulkdataRef) return vf;
    if (vf is Bytes) return vf.asInt32List();
    if (vf is Uint8List) return fromUint8List(vf);
    return badValues(vf);
  }
}

/// A mixin class for 64-bit signed integer [Element]s.
mixin Int64 {
  List<int> get values;
  Element<int>  update([Iterable<int> vList]);
  // **** End of Interface ****

  int get sizeInBytes => kSizeInBytes;
  int get lengthInBytes => length * sizeInBytes;
  int get length => values.length;
  int get minValue => kMinValue;
  int get maxValue => kMaxValue;

  List<int> get emptyList => kEmptyInt16List;
  Int64List get typedData => fromList(values);
  Uint8List get bulkdata => typedData.buffer.asUint8List();
  Integer get sha256 => update(Sha256.int64(values));

  /// Returns a [Int64List.view] of [values].
  Integer view([int start = 0, int length]) => update(
      typedData.buffer.asInt64List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 8;
  static const int kSizeInBits = kSizeInBytes * 8;
//  static const int kMinValue = 0;
  static const int kMinValue = -(1 << (kSizeInBits - 1));
//  static const int kMaxValue = (1 << kSizeInBits) - 1;
  static const int kMaxValue = (1 << (kSizeInBits - 1)) - 1;

  /// Returns the [values] length that corresponds to [vfLength].
  static int getLength(int vfLength) =>
      vfLengthToLength(vfLength, kSizeInBytes);

  /// Returns a [Bytes] created from [vList];
  static Bytes toBytes(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asBytes(bList);
  }

  /// Returns a [Uint8List] created from [vList];
  static Uint8List toUint8List(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asUint8List(bList);
  }

  /// Returns a [ByteData] created from [vList];
  static ByteData toByteData(List<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asByteData(bList);
  }

  /// Returns a [base64] [String] created from [vList];
  static String toBase64(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bytes = toBytes(vList, asView: asView, check: check);
    return (bytes == null) ? null : base64.encode(bytes);
  }

  /// Returns a [Int64List] with the same length as [vList]. If
  /// [vList] is a [Int64List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No values checking
  /// is done.
  ///
  /// If [vList] is not a [Int64List], then if [vList] has valid values,
  /// a new [Int64List] is created and the values of [vList] are copied
  /// into it and returned; otherwise, [badValues] is called.
  static Int64List fromList(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    if (vList == null || vList.isEmpty) return kEmptyInt64List;
    if (vList is Int64List) return asView ? vList : Int64List.fromList(vList);
    if (check) {
      final td = Int64List(vList.length);
      return _copyList(vList, td, kMinValue, kMaxValue);
    }
    return Int64List.fromList(vList);
  }

  /// Returns a [Int64List] from a [base64] [String].
  static Int64List fromBase64(String s, {bool asView = true}) =>
      (s.isEmpty) ? kEmptyInt64List : fromUint8List(base64.decode(s));

  /// Returns a [Int64List] from a [Uint8List].
  static Int64List fromUint8List(Uint8List bytes, {bool asView = true}) =>
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
      final nList = Int64List(length);
      for (var i = 0, oib = 0; i < length; i++, oib += kSizeInBytes)
        nList[i] = bd.getInt64(oib, Endian.little);
      return nList;
    }
    final f64List = bd.buffer.asInt64List(bd.offsetInBytes, length);
    return asView ? f64List : Int64List.fromList(f64List);
  }

  static bool _isNotAligned(TypedData vList) =>
      (vList.offsetInBytes % kSizeInBytes) != 0;

  static List<int> fromValueField(Iterable vf) {
    if (vf == null) return kEmptyInt64List;
    if (vf is Int64List ||
        vf is List<int> ||
        vf.isEmpty ||
        vf is IntBulkdataRef) return vf;
    if (vf is Bytes) return vf.asInt64List();
    if (vf is Uint8List) return fromUint8List(vf);
    return badValues(vf);
  }
}

/// A mixin class for 8-bit unsigned integer [Element]s.
mixin Uint8 {
  List<int> get values;
  Element<int> update([Iterable<int> vList]);
  // **** End of Interface ****
  int get sizeInBytes => kSizeInBytes;
  int get lengthInBytes => length * sizeInBytes;
  int get length => values.length;
  int get minValue => kMinValue;
  int get maxValue => kMaxValue;

  List<int> get emptyList => kEmptyInt16List;
  Uint8List get typedData => fromList(values);
  Uint8List get bulkdata => typedData.buffer.asUint8List();
  Integer get sha256 => update(Sha256.uint8(typedData));

  bool checkValue(int v, {Issues issues, bool allowInvalid = false}) =>
      Integer.isValidValue(v, issues, kMinValue, kMaxValue);

  /// Returns a  an Uint8List View of [values].
  Integer view([int start = 0, int length]) => update(
      typedData.buffer.asUint8List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 1;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;
  // These are here because OB and UN are both long values fields
  static const int kMaxVFLength = k8BitMaxLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  //TODO: add equal to other classes
  /// Returns _true_ if all bytes in [a] and [b] are the same.
  /// _Note_: This assumes the [Bytes] is aligned on a 2 byte boundary.
  static bool equal(Uint8List a, Uint8List b) {
    final length = a.length;
    if (length != b.length) return false;
    for (var i = 0; i < length; i++) if (a[i] != b[i]) return false;
    return true;
  }

  /// Returns the [values] length that corresponds to [vfLength].
  static int getLength(int vfLength) =>
      vfLengthToLength(vfLength, kSizeInBytes);

  /// Returns a [Bytes] created from [vList];
  static Bytes toBytes(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asBytes(bList);
  }

  /// Returns a [Uint8List] created from [vList];
  static Uint8List toUint8List(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asUint8List(bList);
  }

  /// Returns a [ByteData] created from [vList];
  static ByteData toByteData(List<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asByteData(bList);
  }

  /// Returns a [base64] [String] created from [vList];
  static String toBase64(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bytes = toBytes(vList, asView: asView, check: check);
    return (bytes == null) ? null : base64.encode(bytes);
  }

  /// Returns a [Uint8List] with the same length as [vList]. If
  /// [vList] is a [Uint8List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No values checking
  /// is done.
  ///
  /// If [vList] is not a [Uint8List], then if [vList] has valid values,
  /// a new [Uint8List] is created and the values of [vList] are copied
  /// into it and returned; otherwise, [badValues] is called.
  static Uint8List fromList(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    if (vList == null || vList.isEmpty) return kEmptyUint8List;
    if (vList is Uint8List)
      return asView == true ? vList : Uint8List.fromList(vList);
    if (check) {
      final td = Uint8List(vList.length);
      return _copyList(vList, td, kMinValue, kMaxValue);
    }
    return Uint8List.fromList(vList);
  }

  /// Returns a [Uint8List] from a [Bytes].
  static Uint8List fromBytes(Bytes bytes,
          {bool asView = true, bool check = true}) =>
      bytes.asUint8List();

  /// Returns a [Uint8List] from a [base64] [String].
  static Uint8List fromBase64(String s,
          {bool asView = true, bool check = true}) =>
      (s.isEmpty) ? kEmptyUint8List : fromUint8List(base64.decode(s));

  /// Returns a [Uint8List] from a [Uint8List].
  ///
  /// _Note_: This method is a no-op. It just returns [bytes].
  /// It is here for uniformity.
  static Uint8List fromUint8List(Uint8List bytes,
          {bool asView = true, bool check = true}) =>
      bytes;

  /// Returns a [Uint8List] from a [TypedData].
  static Uint8List fromByteData(ByteData bd,
      {bool asView = true, bool check = true}) {
    assert(bd != null);
    if (bd.lengthInBytes == 0) return Integer.kEmptyList;
    final bList = asUint8List(bd);
    return asView ? bList : Uint8List.fromList(bList);
  }

  static List<int> fromValueField(Iterable vf) {
    if (vf == null) return kEmptyUint8List;
    if (vf is Uint8List ||
        vf is List<int> ||
        vf.isEmpty ||
        vf is IntBulkdataRef) return vf;
    if (vf is Bytes) return vf.asUint8List();
    return badValues(vf);
  }
}

/// A mixin class for 16-bit unsigned integer [Element]s.
mixin Uint16 {
  List<int> get values;
  Element<int> update([Iterable<int> vList]);
  // **** End of Interface ****

  int get sizeInBytes => kSizeInBytes;
  int get lengthInBytes => length * sizeInBytes;
  int get length => values.length;
  int get minValue => kMinValue;
  int get maxValue => kMaxValue;

  List<int> get emptyList => kEmptyInt16List;
  Uint16List get typedData => fromList(values);
  Uint8List get bulkdata => typedData.buffer.asUint8List();
  Integer get sha256 => update(Sha256.uint16(typedData));

  bool checkValue(int v, {Issues issues, bool allowInvalid = false}) =>
      Integer.isValidValue(v, issues, kMinValue, kMaxValue);

  /// Returns a  an Uint8List View of [values].
  Integer view([int start = 0, int length]) => update(
      typedData.buffer.asUint16List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 2;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  // Note: optimized to use 2 byte boundary
  bool equal(Bytes a, Bytes b) {
    for (var i = 0; i < a.length; i += 2) {
      final x = a.getUint16(i);
      final y = b.getUint16(i);
      if (x != y) return false;
    }
    return true;
  }

  /// Returns the [values] length that corresponds to [vfLength].
  static int getLength(int vfLength) =>
      vfLengthToLength(vfLength, kSizeInBytes);

  /// Returns a [Bytes] created from [vList];
  static Bytes toBytes(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asBytes(bList);
  }

  /// Returns a [Uint8List] created from [vList];
  static Uint8List toUint8List(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asUint8List(bList);
  }

  /// Returns a [ByteData] created from [vList];
  static ByteData toByteData(List<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asByteData(bList);
  }

  /// Returns a [base64] [String] created from [vList];
  static String toBase64(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bytes = toBytes(vList, asView: asView, check: check);
    return (bytes == null) ? null : base64.encode(bytes);
  }

  /// Returns a [Uint16List] with the same length as [vList]. If
  /// [vList] is a [Uint16List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No values checking
  /// is done.
  ///
  /// If [vList] is not a [Uint16List], then if [vList] has valid values,
  /// a new [Uint16List] is created and the values of [vList] are copied
  /// into it and returned; otherwise, [badValues] is called.
  static Uint16List fromList(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    if (vList == null || vList.isEmpty) return kEmptyUint16List;
    if (vList is Uint16List) return asView ? vList : Uint16List.fromList(vList);
    if (check) {
      final td = Uint16List(vList.length);
      return _copyList(vList, td, kMinValue, kMaxValue);
    }
    return Uint16List.fromList(vList);
  }

  /// Returns a [Uint16List] from a [Bytes].
  static Uint16List fromBytes(Bytes bytes,
          {bool asView = true, bool check = true}) =>
      bytes.asUint16List();

  /// Returns a [Uint16List] from a [base64] [String].
  static Uint16List fromBase64(String s,
          {bool asView = true, bool check = true}) =>
      (s.isEmpty) ? kEmptyUint16List : fromUint8List(base64.decode(s));

  /// Returns a [Uint16List] from a [Uint8List].
  static Uint16List fromUint8List(Uint8List bytes, {bool asView = true}) =>
      _fromByteData(asByteData(bytes), asView: asView);

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
      final vList = Uint16List(length);
      for (var i = 0, oib = 0; i < length; i++, oib += kSizeInBytes)
        vList[i] = bd.getUint16(oib, Endian.little);
      // Returning a new list
      return vList;
    }
    final u16List = bd.buffer.asUint16List(bd.offsetInBytes, length);
    return asView ? u16List : Uint16List.fromList(u16List);
  }

  static bool _isNotAligned(TypedData vList) =>
      (vList.offsetInBytes % kSizeInBytes) != 0;

  static List<int> fromValueField(Iterable vf) {
    if (vf == null) return kEmptyUint16List;
    if (vf is Uint16List ||
        vf is List<int> ||
        vf.isEmpty ||
        vf is IntBulkdataRef) return vf;
    if (vf is Bytes) return vf.asUint16List();
    if (vf is Uint8List) return fromUint8List(vf);
    return badValues(vf);
  }
}

/// A mixin class for 32-bit unsigned integer [Element]s.
mixin Uint32 {
  List<int> get values;
  Element<int> update([Iterable<int> vList]);
  // **** End of Interface ****

  int get sizeInBytes => kSizeInBytes;
  int get lengthInBytes => length * sizeInBytes;
  int get length => values.length;
  int get minValue => kMinValue;
  int get maxValue => kMaxValue;

  List<int> get emptyList => kEmptyInt16List;
  Uint32List get typedData => fromList(values);
  Uint8List get bulkdata => typedData.buffer.asUint8List();
  Integer get sha256 => update(Sha256.uint32(typedData));

  bool checkValue(int v, {Issues issues, bool allowInvalid = false}) =>
      Integer.isValidValue(v, issues, kMinValue, kMaxValue);

  /// Returns a  an Uint8List View of [values].
  Integer view([int start = 0, int length]) => update(
      typedData.buffer.asUint32List(start, _toLength(length, values.length)));

  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  bool equal(Bytes a, Bytes b) {
    for (var i = 0; i < a.length; i += 4) {
      final x = a.getUint32(i);
      final y = b.getUint32(i);
      if (x != y) return false;
    }
    return true;
  }

  /// Returns the [values] length that corresponds to [vfLength].
  static int getLength(int vfLength) =>
      vfLengthToLength(vfLength, kSizeInBytes);

  /// Returns a [Bytes] created from [vList];
  static Bytes toBytes(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asBytes(bList);
  }

  /// Returns a [Uint8List] created from [vList];
  static Uint8List toUint8List(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asUint8List(bList);
  }

  /// Returns a [ByteData] created from [vList];
  static ByteData toByteData(List<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asByteData(bList);
  }

  /// Returns a [base64] [String] created from [vList];
  static String toBase64(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bytes = toBytes(vList, asView: asView, check: check);
    return (bytes == null) ? null : base64.encode(bytes);
  }

  /// Returns a [Uint32List] with the same length as [vList]. If
  /// [vList] is a [Uint32List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No values checking
  /// is done.
  ///
  /// If [vList] is not a [Uint32List], then if [vList] has valid values,
  /// a new [Uint32List] is created and the values of [vList] are copied
  /// into it and returned; otherwise, [badValues] is called.
  static Uint32List fromList(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    if (vList == null || vList.isEmpty) return kEmptyUint32List;
    if (vList is Uint32List) return asView ? vList : Uint32List.fromList(vList);
    if (check) {
      final td = Uint32List(vList.length);
      return _copyList(vList, td, kMinValue, kMaxValue);
    }
    return Uint32List.fromList(vList);
  }

  /// Returns a [Uint16List] from a [Bytes].
  static Uint32List fromBytes(Bytes bytes,
          {bool asView = true, bool check = true}) =>
      bytes.asUint32List();

  /// Returns a [Uint32List] from a [base64] [String].
  static Uint32List fromBase64(String s, {bool asView = true}) =>
      (s.isEmpty) ? kEmptyUint32List : fromUint8List(base64.decode(s));

  /// Returns a [Uint32List] from a [Uint8List].
  static Uint32List fromUint8List(Uint8List bytes, {bool asView = true}) =>
      _fromByteData(asByteData(bytes), asView: asView);

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
      final nList = Uint32List(length);
      for (var i = 0, oib = 0; i < length; i++, oib += kSizeInBytes)
        nList[i] = bd.getInt32(oib, Endian.little);
      return nList;
    }
    final u32List = bd.buffer.asUint32List(bd.offsetInBytes, length);
    return asView ? u32List : Uint32List.fromList(u32List);
  }

  static bool _isNotAligned(TypedData vList) =>
      (vList.offsetInBytes % kSizeInBytes) != 0;

  static List<int> fromValueField(Iterable vf) {
    if (vf == null) return kEmptyUint32List;
    if (vf is Uint32List ||
        vf is List<int> ||
        vf.isEmpty ||
        vf is IntBulkdataRef) return vf;
    if (vf is Bytes) return vf.asUint32List();
    if (vf is Uint8List) return fromUint8List(vf);
    return badValues(vf);
  }
}

/// An mixin class for 64-bit unsigned integers.
mixin Uint64 {
  List<int> get values;
  Element<int> update([Iterable<int> vList]);
  // **** End of Interface ****

  int get sizeInBytes => kSizeInBytes;
  int get lengthInBytes => length * sizeInBytes;
  int get length => values.length;
  int get minValue => kMinValue;
  int get maxValue => kMaxValue;

  List<int> get emptyList => kEmptyInt16List;
  Uint64List get typedData => fromList(values);
  Uint8List get bulkdata => typedData.buffer.asUint8List();
  Integer get sha256 => update(Sha256.uint64(values));

  /// Returns a [Uint64List.view] of [values].
  Uint64List view([int start = 0, int length]) =>
      typedData.buffer.asUint64List(start, _toLength(length, values.length));

  static const int kSizeInBytes = 8;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMinValue = 0;
//  static const int kMaxValue = (1 << kSizeInBits) - 1;
  static const int kMaxValue = (1 << (kSizeInBits - 1)) - 1;

  bool equal(Bytes a, Bytes b) {
    for (var i = 0; i < a.length; i += 8) {
      final x = a.getUint64(i);
      final y = b.getUint64(i);
      if (x != y) return false;
    }
    return true;
  }

  /// Returns the [values] length that corresponds to [vfLength].
  static int getLength(int vfLength) =>
      vfLengthToLength(vfLength, kSizeInBytes);

  /// Returns a [Bytes] created from [vList];
  static Bytes toBytes(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asBytes(bList);
  }

  /// Returns a [Uint8List] created from [vList];
  static Uint8List toUint8List(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asUint8List(bList);
  }

  /// Returns a [ByteData] created from [vList];
  static ByteData toByteData(List<int> vList,
      {bool asView = true, bool check = true}) {
    final bList = fromList(vList, asView: asView, check: check);
    return (bList == null) ? null : asByteData(bList);
  }

  /// Returns a [base64] [String] created from [vList];
  static String toBase64(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    final bytes = toBytes(vList, asView: asView, check: check);
    return (bytes == null) ? null : base64.encode(bytes);
  }

  /// Returns a [Uint64List] with the same length as [vList]. If
  /// [vList] is a [Uint64List] and [asView] is _true_, then [vList] is
  /// returned; otherwise, a copy of vList is returned. No values checking
  /// is done.
  ///
  /// If [vList] is not a [Uint64List], then if [vList] has valid values,
  /// a new [Uint64List] is created and the values of [vList] are copied
  /// into it and returned; otherwise, [badValues] is called.
  static Uint64List fromList(Iterable<int> vList,
      {bool asView = true, bool check = true}) {
    if (vList == null || vList.isEmpty) return kEmptyUint64List;
    if (vList is Uint64List) return asView ? vList : Uint64List.fromList(vList);
    if (check) {
      final td = Uint64List(vList.length);
      return _copyList(vList, td, kMinValue, kMaxValue);
    }
    return Uint64List.fromList(vList);
  }

  /// Returns a [Uint64List] from a [Bytes].
  static Uint64List fromBytes(Bytes bytes,
          {bool asView = true, bool check = true}) =>
      bytes.asUint64List();

  /// Returns a [Uint64List] from a [base64] [String].
  static Uint64List fromBase64(String s, {bool asView = true}) =>
      (s.isEmpty) ? kEmptyUint64List : fromUint8List(base64.decode(s));

  /// Returns a [Uint64List] from a [Uint8List].
  static Uint64List fromUint8List(Uint8List bytes, {bool asView = true}) =>
      _fromByteData(asByteData(bytes), asView: asView);

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
      final nList = Uint64List(length);
      for (var i = 0, oib = 0; i < length; i++, oib += kSizeInBytes)
        nList[i] = bd.getUint64(oib, Endian.little);
      return nList;
    }
    final f64List = bd.buffer.asUint64List(bd.offsetInBytes, length);
    return asView ? f64List : Uint64List.fromList(f64List);
  }

  static bool _isNotAligned(TypedData vList) =>
      (vList.offsetInBytes % kSizeInBytes) != 0;

  static List<int> fromValueField(Iterable vf) {
    if (vf == null) return kEmptyUint64List;
    if (vf is Uint64List ||
        vf is Iterable<int> ||
        vf.isEmpty ||
        vf is IntBulkdataRef) return vf;
    if (vf is Bytes) return vf.asUint64List();
    if (vf is Uint8List) return fromUint8List(vf);
    return badValues(vf);
  }
}

int _toLength(int length, int vLength) =>
    (length == null || length > vLength) ? vLength : length;

bool _inRange(int v, int min, int max) => v >= min && v <= max;

bool _notInRange(int v, int min, int max) => !_inRange(v, min, max);

bool _isValidList(Iterable<int> vList, int minValue, int maxValue) {
  for (var v in vList) if (_notInRange(v, minValue, maxValue)) return false;
  return true;
}

bool _isNotValidList(Iterable<int> vList, int minValue, int maxValue) =>
    !_isValidList(vList, minValue, maxValue);

/// Returns a new [List<int>] that contains the elements from [min] to [max].
List<int> _copyList(List<int> vList, List<int> td, int min, int max) {
  assert(td is TypedData);
  assert(vList.length == td.length);
  for (var i = 0; i < vList.length; i++) {
    final v = vList[i];
    if (v < min || v > max) return badValues(vList);
    td[i] = v;
  }
  return td;
}
