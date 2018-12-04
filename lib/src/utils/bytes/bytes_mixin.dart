//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:convert' as cvt;
import 'dart:typed_data';

import 'package:core/src/utils/bytes/new_bytes.dart';
import 'package:core/src/utils/bytes/constants.dart';
import 'package:core/src/global.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/system.dart';

/// [BytesMixin] is a class that provides a read-only byte array that
/// supports both [Uint8List] and [ByteData] interfaces.
mixin BytesMixin {
  ByteData get bd;
  int get length;
  String get endianness;

  int getInt16(int offset);
  int getInt32(int offset);
  int getInt64(int offset);

  int getUint16(int offset);
  int getUint32(int offset);
  int getUint64(int offset);

  double getFloat32(int offset);
  double getFloat64(int offset);

  // **** End of Interface
  // **** Extensions ****

  Int32x4 getInt32x4(int offset) {
    assert(length >= offset + 16);
    var i = offset;
    final w = getInt32(i);
    final x = getInt32(i += 4);
    final y = getInt32(i += 4);
    final z = getInt32(i += 4);
    return Int32x4(w, x, y, z);
  }

  Float32x4 getFloat32x4(int offset) {
    assert(length >= offset + 16);
    var i = offset;
    final w = getFloat32(i);
    final x = getFloat32(i += 4);
    final y = getFloat32(i += 4);
    final z = getFloat32(i += 4);
    return Float32x4(w, x, y, z);
  }

  Float64x2 getFloat64x2(int offset) {
    assert(length >= offset + 16);
    var i = offset;
    final x = getFloat64(i);
    final y = getFloat64(i += 8);
    return Float64x2(x, y);
  }

  // **** Internal methods

  bool _isAligned(int offset, int size) => (offset % size) == 0;

  // offset is in bytes
  bool _isAligned16(int offset) => _isAligned(offset, 2);
  bool _isAligned32(int offset) => _isAligned(offset, 4);
  bool _isAligned64(int offset) => _isAligned(offset, 8);

  /// Returns the absolute index of [offset] in the underlying [ByteBuffer].
  int _absIndex(int offset) => bd.offsetInBytes + offset;

  // **** TypedData views

  /// If [offset] is aligned on an 8-byte boundary, returns a [Int16List]
  /// view of the specified region; otherwise, creates a [Int16List] that
  /// is a copy of the specified region and returns it.
  Int16List asInt16List([int offset = 0, int length]) {
    final index = _absIndex(offset);
    length ??= _length16(offset);
    return (_isAligned16(index))
        ? bd.buffer.asInt16List(index, length)
        : getInt16List(offset, length);
  }

  /// Returns the number of 32-bit elements from [offset] to
  /// [bd].lengthInBytes, where [offset] is the absolute offset in [bd].
  int _length16(int offset) {
    final len = length - offset;
    return (len % 2 != 0) ? -1 : len ~/ 2;
  }

  /// Creates an [Int16List] copy of the specified region of _this_.
  Int16List getInt16List([int offset = 0, int length]) {
    length ??= _length16(offset);
    final list = Int16List(length);
    for (var i = 0, j = offset; i < length; i++, j += 2) list[i] = getInt16(j);
    return list;
  }


  /// Returns the number of 32-bit elements from [offset] to
  /// [bd].lengthInBytes, where [offset] is the absolute offset in [bd].
  int _length32(int offset) {
    final len = length - offset;
    return (len % 4 != 0) ? -1 : len ~/ 4;
  }

  /// If [offset] is aligned on an 8-byte boundary, returns a [Int32List]
  /// view of the specified region; otherwise, creates a [Int32List] that
  /// is a copy of the specified region and returns it.
  Int32List asInt32List([int offset = 0, int length]) {
    final index = _absIndex(offset);
    length ??= _length32(offset);
    return (_isAligned32(index))
        ? bd.buffer.asInt32List(index, length)
        : getInt32List(offset, length);
  }

  /// Creates an [Int32List] copy of the specified region of _this_.
  Int32List getInt32List([int offset = 0, int length]) {
    length ??= _length32(offset);
    final list = Int32List(length);
    for (var i = 0, j = offset; i < length; i++, j += 4) list[i] = getInt32(j);
    return list;
  }

  /// Returns the number of 32-bit elements from [offset] to
  /// [bd].lengthInBytes, where [offset] is the absolute offset in [bd].
  int _length64(int offset) {
    final len = length - offset;
    return (len % 8 != 0) ? -1 : len ~/ 8;
  }

  /// Creates an [Int64List] copy of the specified region of _this_.
  Int64List getInt64List([int offset = 0, int length]) {
    length ??= _length64(offset);
    final list = Int64List(length);
    for (var i = 0, j = offset; i < length; i++, j += 8) list[i] = getInt64(j);
    return list;
  }

  /// If [offset] is aligned on an 8-byte boundary, returns a [Int64List]
  /// view of the specified region; otherwise, creates a [Int64List] that
  /// is a copy of the specified region and returns it.
  Int64List asInt64List([int offset = 0, int length]) {
    final index = _absIndex(offset);
    length ??= _length64(offset);
    return (_isAligned64(index))
        ? bd.buffer.asInt64List(index, length)
        : getInt64List(offset, length);
  }


  /// If [offset] is aligned on an 8-byte boundary, returns a [Uint16List]
  /// view of the specified region; otherwise, creates a [Uint16List] that
  /// is a copy of the specified region and returns it.
  Uint16List asUint16List([int offset = 0, int length]) {
    length ??= _length16(offset);
    final index = _absIndex(offset);
    return (_isAligned16(index))
        ? bd.buffer.asUint16List(index, length)
        : getUint16List(offset, length);
  }

  /// Creates an [Uint16List] copy of the specified region of _this_.
  Uint16List getUint16List([int offset = 0, int length]) {
    length ??= _length16(offset);
    final list = Uint16List(length);
    for (var i = 0, j = offset; i < length; i++, j += 2) list[i] = getUint16(j);
    return list;
  }

  /// Creates an [Uint32List] copy of the specified region of _this_.
  Uint32List getUint32List([int offset = 0, int length]) {
    length ??= _length32(offset);
    final list = Uint32List(length);
    for (var i = 0, j = offset; i < length; i++, j += 4) list[i] = getUint32(j);
    return list;
  }

  /// Creates an [Uint64List] copy of the specified region of _this_.
  Uint64List getUint64List([int offset = 0, int length]) {
    length ??= _length64(offset);
    final list = Uint64List(length);
    for (var i = 0, j = offset; i < length; i++, j += 8) list[i] = getUint64(j);
    return list;
  }

  /// If [offset] is aligned on an 8-byte boundary, returns a [Uint32List]
  /// view of the specified region; otherwise, creates a [Uint32List] that
  /// is a copy of the specified region and returns it.
  Uint32List asUint32List([int offset = 0, int length]) {
    length ??= _length32(offset);
    if (length < 0) return null;
    final index = _absIndex(offset);
    return (_isAligned32(index))
        ? bd.buffer.asUint32List(index, length)
        : getUint32List(offset, length);
  }


  // **** Float Lists

  /// Creates an [Float32List] copy of the specified region of _this_.
  Float32List getFloat32List([int offset = 0, int length]) {
    length ??= _length32(offset);
    final list = Float32List(length);
    for (var i = 0, j = offset; i < length; i++, j += 4)
      list[i] = getFloat32(j);
    return list;
  }

  /// If [offset] is aligned on an 8-byte boundary, returns a [Uint64List]
  /// view of the specified region; otherwise, creates a [Uint64List] that
  /// is a copy of the specified region and returns it.
  Uint64List asUint64List([int offset = 0, int length]) {
    length ??= _length64(offset);
    final index = _absIndex(offset);
    return (_isAligned64(index))
        ? bd.buffer.asUint64List(index, length)
        : getUint64List(offset, length);
  }

  /// If [offset] is aligned on an 8-byte boundary, returns a [Float32List]
  /// view of the specified region; otherwise, creates a [Float32List] that
  /// is a copy of the specified region and returns it.
  Float32List asFloat32List([int offset = 0, int length]) {
    length ??= _length32(offset);
    final index = _absIndex(offset);
    return (_isAligned32(index))
        ? bd.buffer.asFloat32List(index, length)
        : getFloat32List(offset, length);
  }

  /// Creates an [Float64List] copy of the specified region of _this_.
  Float64List getFloat64List([int offset = 0, int length]) {
    length ??= _length64(offset);
    final list = Float64List(length);
    for (var i = 0, j = offset; i < length; i++, j += 8)
      list[i] = getFloat64(j);
    return list;
  }

  /// If [offset] is aligned on an 8-byte boundary, returns a [Float64List]
  /// view of the specified region; otherwise, creates a [Float64List] that
  /// is a copy of the specified region and returns it.
  Float64List asFloat64List([int offset = 0, int length]) {
    final index = _absIndex(offset);
    length ??= _length64(offset);
    return (_isAligned64(index))
        ? bd.buffer.asFloat64List(index, length)
        : getFloat64List(offset, length);
  }





  // ********************** Setters ********************************

  // **** Internal ByteData Setters
  // Internal setters take an absolute index [i] into the underlying
  // [ByteBuffer] ([_bd].buffer).  The external interface of this package
  // uses [offset]s relative to the current [ByteData] ([_bd]).

  void _setInt8(int i, int v) => bd.setInt8(i, v);
  void _setInt16(int i, int v) => bd.setInt16(i, v, Endian.little);
  void _setInt32(int i, int v) => bd.setInt32(i, v, Endian.little);
  void _setInt64(int i, int v) => bd.setInt64(i, v, Endian.little);

  void _setInt32x4(int offset, Int32x4 v) {
    var i = offset;
    _setInt32(i, v.w);
    _setInt32(i += 4, v.x);
    _setInt32(i += 4, v.y);
    _setInt32(i += 4, v.z);
  }

  void _setUint8(int i, int v) => bd.setUint8(i, v);
  void _setUint16(int i, int v) => bd.setUint16(i, v, Endian.little);
  void _setUint32(int i, int v) => bd.setUint32(i, v, Endian.little);
  void _setUint64(int i, int v) => bd.setUint64(i, v, Endian.little);

  void _setFloat32(int i, double v) => bd.setFloat32(i, v, Endian.little);

  void _setFloat64(int i, double v) => bd.setFloat64(i, v, Endian.little);

  void _setFloat32x4(int offset, Float32x4 v) {
    var i = offset;
    _setFloat32(i, v.w);
    _setFloat32(i += 4, v.x);
    _setFloat32(i += 4, v.y);
    _setFloat32(i += 4, v.z);
  }

  void _setFloat64x2(int offset, Float64x2 v) {
    var i = offset;
    _setFloat64(i, v.x);
    _setFloat64(i += 4, v.y);
  }

  // **** External ByteData Setters

  void setInt8(int offset, int value) => _setInt8(offset, value);
  void setInt16(int offset, int value) => _setInt16(offset, value);
  void setInt32(int offset, int value) => _setInt32(offset, value);
  void setInt64(int offset, int value) => _setInt64(offset, value);

  void setInt32x4(int offset, Int32x4 value) {
    var i = offset;
    _setInt32(i, value.w);
    _setInt32(i += 4, value.x);
    _setInt32(i += 4, value.y);
    _setInt32(i += 4, value.z);
  }

  void setUint8(int offset, int value) => _setUint8(offset, value);
  void setUint16(int offset, int value) => _setUint16(offset, value);
  void setUint32(int offset, int value) => _setUint32(offset, value);
  void setUint64(int offset, int value) => _setUint64(offset, value);

  void setFloat32(int offset, double value) => _setFloat32(offset, value);

  void setFloat64(int offset, double value) => _setFloat64(offset, value);

  void setFloat32x4(int offset, Float32x4 value) {
    var i = offset;
    _setFloat32(i, value.w);
    _setFloat32(i += 4, value.x);
    _setFloat32(i += 4, value.y);
    _setFloat32(i += 4, value.z);
  }

  void setFloat64x2(int offset, Float64x2 value) {
    var i = offset;
    _setFloat64(i, value.x);
    _setFloat64(i += 4, value.y);
  }

  // **** String Setters

  /// Ascii encodes the specified range of [s] and then writes the
  /// code units to _this_ starting at [start]. If [padChar] is not
  /// _null_ and [s].length is odd, then [padChar] is written after
  /// the code units of [s] have been written.
  int setAscii(int start, String s,
      [int offset = 0, int length, int padChar = kSpace]) {
    length ??= s.length;
    final v = _maybeGetSubstring(s, offset, length);
    return __setUint8List(start, cvt.ascii.encode(v), offset, length, padChar);
  }

  /// Writes the elements of the specified region of [list] to
  /// _this_ starting at [start]. If [pad] is _true_ and [length]
  /// is odd, then a 0 is written after the other elements have
  /// been written.
  int __setUint8List(int start, Uint8List list, int offset,
      [int length, int pad]) {
    length ??= list.length;
    final len = _setUint8List(start, list, offset, length);
    if (length.isOdd && pad != null) {
      final index = start + length;
      _setUint8(index, pad);
      return index + 1;
    }
    return len;
  }

  void setString(int start, String s, [int offset = 0, int length]) =>
      setUtf8(start, s, offset, length);

  // **** List Setters

  void setBytes(int start, Bytes bytes, [int offset = 0, int length]) =>
      _setByteData(start, bytes.bd, offset, length);

  void setByteData(int start, ByteData bd, [int offset = 0, int length]) =>
      _setByteData(start, bd, offset, length);

  void _setByteData(int start, ByteData other, int offset, int length) {
    assert(_checkLength(offset, length, kUint8Size));
    for (var i = offset, j = start; i < length; i++, j++)
      _setUint8(j, other.getUint8(i));
  }

  /// Returns the number of bytes set.
  int setInt8List(int start, List<int> list, [int offset = 0, int length]) {
    length ??= list.length;
    assert(_checkLength(offset, length, kInt8Size));
    for (var i = offset, j = start; i < length; i++, j++) _setInt8(j, list[i]);
    return length;
  }

  int setInt16List(int start, List<int> list, [int offset = 0, int length]) {
    length ??= list.length;
    assert(_checkLength(offset, length, kInt16Size));
    for (var i = offset, j = start; i < length; i++, j += 2)
      _setInt16(j, list[i]);
    return length * 2;
  }

  int setInt32List(int start, List<int> list, [int offset = 0, int length]) {
    length ??= list.length;
    assert(_checkLength(offset, length, kInt32Size));
    for (var i = offset, j = start; i < length; i++, j += 4)
      _setInt32(j, list[i]);
    return length * 4;
  }

  int setInt32x4List(int start, Int32x4List list,
      [int offset = 0, int length]) {
    length ??= list.length;
    assert(_checkLength(offset, length, kInt32Size * 4));
    for (var i = offset, j = start; i < length; i++, j += 16)
      _setInt32x4(j, list[i]);
    return length * 16;
  }

  int setInt64List(int start, List<int> list, [int offset = 0, int length]) {
    length ??= list.length;
    assert(_checkLength(offset, length, kInt64Size));
    for (var i = offset, j = start; i < length; i++, j += 8)
      setInt64(j, list[i]);
    return length * 6;
  }

  int setUint8List(int start, List<int> list, [int offset = 0, int length]) =>
      _setUint8List(start, list, offset, length);

  int _setUint8List(int start, Uint8List list,
      [int offset = 0, int length, int padChar]) {
    length ??= list.length;
    assert(_checkLength(offset, length, kUint8Size));
    for (var i = offset, j = start; i < length; i++, j++) _setUint8(j, list[i]);
    return length;
  }

  int setUint16List(int start, List<int> list, [int offset = 0, int length]) =>
      _setUint16List(start, list, offset, length);

  int _setUint16List(int start, List<int> list, [int offset = 0, int length]) {
    length ??= list.length;
    assert(_checkLength(offset, length, kUint16Size));
    for (var i = offset, j = start; i < length; i++, j += 2)
      _setUint16(j, list[i]);
    return length * 2;
  }

  int setUint32List(int start, List<int> list, [int offset = 0, int length]) =>
      _setUint32List(start, list, offset, length);

  int _setUint32List(int start, List<int> list, [int offset = 0, int length]) {
    length ??= list.length;
    assert(_checkLength(offset, length, kUint32Size));
    for (var i = offset, j = start; i < length; i++, j += 4)
      _setUint32(j, list[i]);
    return length * 4;
  }

  int setUint64List(int start, List<int> list, [int offset = 0, int length]) =>
      _setUint64List(start, list, offset, length);

  int _setUint64List(int start, List<int> list, [int offset = 0, int length]) {
    length ??= list.length;
    assert(_checkLength(offset, length, kUint64Size));
    for (var i = offset, j = start; i < length; i++, j += 8)
      _setUint64(j, list[i]);
    return length * 8;
  }

  int setFloat32List(int start, List<double> list,
          [int offset = 0, int length]) =>
      _setFloat32List(start, list, offset, length);

  int _setFloat32List(int start, List<double> list,
      [int offset = 0, int length]) {
    length ??= list.length;
    assert(_checkLength(offset, length, kFloat32Size));
    for (var i = offset, j = start; i < length; i++, j += 4)
      _setFloat32(j, list[i]);
    return length * 4;
  }

  int setFloat32x4List(int start, List<Float32x4> list,
      [int offset = 0, int length]) {
    final l = list is Float32x4List ? list : Float32x4List.fromList(list);
    return _setFloat32x4List(start, l, offset, length);
  }

  int _setFloat32x4List(int start, Float32x4List list,
      [int offset = 0, int length]) {
    length ??= list.length;
    assert(_checkLength(offset, length, list.length * 16));
    for (var i = offset, j = start; i < length; i++, j += 16)
      _setFloat32x4(j, list[i]);
    return length * 16;
  }

  int setFloat64List(int start, List<double> list,
          [int offset = 0, int length]) =>
      _setFloat64List(start, list, offset, length);

  int _setFloat64List(int start, List<double> list,
      [int offset = 0, int length]) {
    length ??= list.length;
    assert(_checkLength(offset, length, kFloat64Size));
    for (var i = offset, j = start; i < length; i++, j += 8)
      _setFloat64(j, list[i]);
    return length * 8;
  }

  int setFloat64x2List(int start, List<Float64x2> list,
      [int offset = 0, int length]) {
    final l = list is Float64x2List ? list : Float64x2List.fromList(list);
    return _setFloat64x2List(start, l, offset, length);
  }

  int _setFloat64x2List(int start, Float64x2List list,
      [int offset = 0, int length]) {
    length ??= list.length;
    assert(_checkLength(offset, length, kFloat64Size));
    for (var i = offset, j = start; i < length; i++, j += 16)
      _setFloat64x2(j, list[i]);
    return length * 16;
  }

  // **** String List Setters

  /// Writes the elements of the specified [sList] to _this_ starting at
  /// [start]. If [pad] is _true_ and the final offset is odd, then a 0 is
  /// written after the other elements have been written.
  int setAsciiList(int start, List<String> sList,
      [int offset = 0, int length, String separator = '', int pad = kSpace]) {
    if (sList.isEmpty) return 0;
    length ??= sList.length;
    final last = length - 1;
    var k = start;

    for (var i = 0; i < length; i++) {
      final s = sList[i];
      for (var j = 0; j < s.length; j++) _setUint8(k++, s.codeUnitAt(j));
      if (i != last) _setUint8(k++, kBackslash);
    }
    if (k.isOdd && pad != null) _setUint8(k++, pad);
    return k - start;
  }

  /// UTF-8 encodes the specified range of [s] and then writes the
  /// code units to _this_ starting at [start]. If [padChar] is not
  /// _null_ and [s].length is odd, then [padChar] is written after
  /// the code units of [s] have been written.
  int setUtf8(int start, String s,
      [int offset = 0, int length, int padChar = kSpace]) {
    length ??= s.length;
    final v = _maybeGetSubstring(s, offset, length);
    return _setUint8List(start, cvt.utf8.encode(v), offset, length, padChar);
  }

  String _maybeGetSubstring(String s, int offset, int length) =>
      (offset == 0 && length == s.length)
          ? s
          : s.substring(offset, offset + length);

  int setUtf8List(int start, List<String> sList,
      [int offset = 0, int length, String separator = '']) {
    if (sList.isEmpty) return 0;
    final s = _stringListToString(sList, offset, length ??= sList.length);
    setUtf8(start, s, offset, s.length);
    return s.length;
  }

  String _stringListToString(List<String> sList, int offset, int length) {
    final v = (offset == 0 && length == sList.length)
        ? sList
        : sList.sublist(offset, offset + length);
    return v.join('\\');
  }

  // **** Other

  @override
  String toString() => '$endianness $runtimeType: ${toBDDescriptor(bd)}';



  String toBDDescriptor(ByteData bd) {
    final start = bd.offsetInBytes;
    final length = bd.lengthInBytes;
    final _length =
        (length > truncateBytesLength) ? truncateBytesLength : length;
    final end = start + length;
    final sb = StringBuffer('$start-$end:$length');
    // TODO: fix for truncated values print [x, y, z, ...]
    if (showByteValues) sb.writeln('${bd.buffer.asUint8List(start, _length)}');
    return '$sb';
  }

  /// If _true_ [toBDDescriptor] will include the values of individual bytes.
  static bool showByteValues = false;

  /// The length at which ByteData values will be truncated.
  static  int truncateBytesLength = 16;

  // **** Internals

  /// Checks that _bd[bdOffset, length] >= vLengthInBytes
  bool _checkLength(int bdOffset, int vLength, int size) {
    final vLengthInBytes = vLength * size;
    final bdLength = bd.lengthInBytes - (bd.offsetInBytes + bdOffset);
    if (vLengthInBytes > bdLength) {
      throw RangeError('List ($vLengthInBytes bytes) is to large for '
          'Bytes($bdLength bytes');
    }
    return true;
  }
}

/// A class used to throw ByteData alignment errors.
class AlignmentError extends Error {
  /// ByteData
  final ByteData bd;
  /// The start index in [bd].
  final int start;
  /// The length of [bd].
  final int length;
  /// The size of the alignment that caused this error.
  final int sizeInBytes;

  /// Thrown when a ByteData alignment error occurs.
  AlignmentError(
      this.bd, this.start, this.length, this.sizeInBytes);
}

/// A function that throws an [AlignmentError] if [throwOnError] is _true_;
/// otherwise, returns _null_.
// ignore: prefer_void_to_null
Null alignmentError(
    ByteData bd, int offsetInBytes, int lengthInBytes, int sizeInBytes) {
  if (throwOnError)
    throw AlignmentError(bd, offsetInBytes, lengthInBytes, sizeInBytes);
  return null;
}
