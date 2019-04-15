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

import 'package:core/src/utils/bytes/bytes.dart';
import 'package:core/src/utils/bytes/constants.dart';
import 'package:core/src/utils/character/charset.dart';

/// [BytesMixin] is a class that provides a read-only byte array that
/// supports both [Uint8List] and [ByteData] interfaces.
mixin BytesMixin {
  // **** End of Interface
  Uint8List get buf;
  ByteData get bd;
  Endian get endian;

  // *** List interface

  int operator [](int i);

  void operator []=(int i, int v);

  @override
  bool operator ==(Object other) {
    if (other is Bytes) {
      final len = buf.length;
      if (len != other.buf.length) return false;
      for (var i = 0; i < len; i++) if (this[i] != other[i]) return false;
      return true;
    }
    return false;
  }

  @override
  int get hashCode {
    var hashCode = 0;
    for (var i = 0; i < buf.length; i++) hashCode += buf[i] + i;
    return hashCode;
  }

  // *** Comparable interface

  /// Compares _this_ with [other] byte by byte.
  /// Returns a negative integer if _this_ is ordered before other, a
  /// positive integer if _this_ is ordered after other, and zero if
  /// _this_ and other are equal.
  ///
  /// Returns -2 _this_ is a proper prefix of [other], and +2 if [other]
  /// is a proper prefix of _this_.
  int compareTo(Bytes other) {
    final minLength = (length < other.length) ? length : other.length;
    for (var i = 0; i < minLength; i++) {
      final a = this[i];
      final b = other[i];
      if (a == b) continue;
      return (a < b) ? -1 : 1;
    }
    return (length < other.length) ? -2 : 2;
  }

  // **** TypedData interface.
  int get elementSizeInBytes => 1;

  ByteBuffer get buffer => buf.buffer;

  int get offset => buf.offsetInBytes;

  int get length => buf.length;
  set length(int length) =>
      throw UnsupportedError('$runtimeType: length is not modifiable');

  String get endianness => (endian == Endian.little) ? 'LE' : 'BE';

  // **** Public Getters

  /// Returns an 8-bit integer values at `index = [buf].offsetInBytes + [i]`
  /// in the underlying [Uint8List]. _Note_: [i] may be negative.
  int getInt8(int i) => buf[i];

  int getInt16(int i) => bd.getInt16(i, endian);
  int getInt32(int i) => bd.getInt32(i, endian);
  int getInt64(int i) => bd.getInt64(i, endian);

  Int32x4 getInt32x4(int offset) {
    _checkRange(offset, 16);
    var i = offset;
    final w = bd.getInt32(i, endian);
    final x = bd.getInt32(i += 4, endian);
    final y = bd.getInt32(i += 4, endian);
    final z = bd.getInt32(i += 4, endian);
    return Int32x4(w, x, y, z);
  }

  Int32x4List getInt32x4List(int offset, int length) {
    if (length % 4 != 0) throw ArgumentError();
    final result = Int32x4List(length);
    for (var i = 0, off = offset; i < length; i++, off += 16) {
      final v = getInt32x4(off);
      result[i] = v;
    }
    return result;
  }

  /// Returns an 8-bit unsigned integer values at
  ///     `index = [buf].offsetInBytes + [i]`
  /// in the underlying [Uint8List].
  /// _Note_: [i] may be negative.
  int getUint8(int i) => buf[i];
  int getUint16(int i) => bd.getUint16(i, endian);
  int getUint32(int i) => bd.getUint32(i, endian);
  int getUint64(int i) => bd.getUint64(i, endian);

  double getFloat32(int i) => bd.getFloat32(i, endian);

  Float32x4 getFloat32x4(int index) {
    _checkRange(index, 16);
    var i = index;
    final w = bd.getFloat32(i, endian);
    final x = bd.getFloat32(i += 4, endian);
    final y = bd.getFloat32(i += 4, endian);
    final z = bd.getFloat32(i += 4, endian);
    return Float32x4(w, x, y, z);
  }

  double getFloat64(int i) => bd.getFloat64(i, endian);

  Float64x2 getFloat64x2(int index) {
    _checkRange(index, 16);
    var i = index;
    final x = bd.getFloat64(i, endian);
    final y = bd.getFloat64(i += 8, endian);
    return Float64x2(x, y);
  }

  // **** Internal methods for creating copies and views of sub-regions.

  /// Returns the number of 32-bit elements from [offset] to
  /// [buf].lengthInBytes, where [offset] is the absolute offset in [buf].
  int _length16(int offset) {
    final len = buf.length - offset;
    if (len % 2 != 0) return -1;
    return len ~/ 2;
  }

  /// Returns the number of 32-bit elements from [offset] to
  /// [buf].lengthInBytes, where [offset] is the absolute offset in [buf].
  int _length32(int offset) {
    final len = buf.length - offset;
    if (len % 4 != 0) return -1;
    return len ~/ 4;
  }

  /// Returns the number of 32-bit elements from [offset] to
  /// [buf].lengthInBytes, where [offset] is the absolute offset in [buf].
  int _length64(int offset) {
    final len = buf.length - offset;
    if (len % 8 != 0) return -1;
    return len ~/ 8;
  }

  bool _isAligned(int index, int size) => (index % size) == 0;

  // offset is in bytes
  bool _isAligned16(int offset) => _isAligned(offset, 2);
  bool _isAligned32(int offset) => _isAligned(offset, 4);
  bool _isAligned64(int offset) => _isAligned(offset, 8);

  // **** as...

  /// Returns a view of the specified region of _this_. [endian] defaults
  /// to the same [endian]ness as _this_.
  Bytes asBytes([int offset = 0, int length, Endian endian = Endian.little]) =>
      Bytes.typedDataView(
          buf, offset, length ?? buf.length, endian ?? this.endian);

  /// Creates an [ByteData] view of the specified region of _this_.
  /// [offset] and [length] are in bytes.
  ByteData asByteData([int offset = 0, int length]) {
    length ??= buf.length - offset;
    return buf.buffer.asByteData(_absIndex(offset), length);
  }

  // **** asXList where X is: Int8, Int16, Int32, Int64, Uint8,
  // **** Uint16, Uint32, Uint64, Float32, Float64

  /// Creates an [Int8List] view of the specified region of _this_.
  Int8List asInt8List([int offset = 0, int length]) {
    length ??= buf.length - offset;
    return buf.buffer.asInt8List(_absIndex(offset), length);
  }

  /// If [offset] is aligned on an 8-byte boundary, returns a [Int16List]
  /// view of the specified region; otherwise, creates a [Int16List] that
  /// is a copy of the specified region and returns it.
  Int16List asInt16List([int offset = 0, int length]) {
    final index = _absIndex(offset);
    length ??= _length16(offset);
    return (_isAligned16(index))
        ? buf.buffer.asInt16List(index, length)
        : getInt16List(offset, length);
  }

  /// If [offset] is aligned on an 8-byte boundary, returns a [Int32List]
  /// view of the specified region; otherwise, creates a [Int32List] that
  /// is a copy of the specified region and returns it.
  Int32List asInt32List([int offset = 0, int length]) {
    final index = _absIndex(offset);
    length ??= _length32(offset);
    return (_isAligned32(index))
        ? buf.buffer.asInt32List(index, length)
        : getInt32List(offset, length);
  }

  /// If [offset] is aligned on an 8-byte boundary, returns a [Int64List]
  /// view of the specified region; otherwise, creates a [Int64List] that
  /// is a copy of the specified region and returns it.
  Int64List asInt64List([int offset = 0, int length]) {
    final index = _absIndex(offset);
    length ??= _length64(offset);
    return (_isAligned64(index))
        ? buf.buffer.asInt64List(index, length)
        : getInt64List(offset, length);
  }

  Uint8List asUint8List([int offset = 0, int length]) {
    length ??= buf.length;
    final index = _absIndex(offset);
    return buf.buffer.asUint8List(index, length);
  }

  /// If [offset] is aligned on an 8-byte boundary, returns a [Uint16List]
  /// view of the specified region; otherwise, creates a [Uint16List] that
  /// is a copy of the specified region and returns it.
  Uint16List asUint16List([int offset = 0, int length]) {
    length ??= _length16(offset);
    final index = _absIndex(offset);
    return (_isAligned16(index))
        ? buf.buffer.asUint16List(index, length)
        : getUint16List(offset, length);
  }

  /// If [offset] is aligned on an 8-byte boundary, returns a [Uint32List]
  /// view of the specified region; otherwise, creates a [Uint32List] that
  /// is a copy of the specified region and returns it.
  Uint32List asUint32List([int offset = 0, int length]) {
    length ??= _length32(offset);
    if (length < 0) return null;
    final index = _absIndex(offset);
    return (_isAligned32(index))
        ? buf.buffer.asUint32List(index, length)
        : getUint32List(offset, length);
  }

  /// If [offset] is aligned on an 8-byte boundary, returns a [Uint64List]
  /// view of the specified region; otherwise, creates a [Uint64List] that
  /// is a copy of the specified region and returns it.
  Uint64List asUint64List([int offset = 0, int length]) {
    length ??= _length64(offset);
    final index = _absIndex(offset);
    return (_isAligned64(index))
        ? buf.buffer.asUint64List(index, length)
        : getUint64List(offset, length);
  }

  /// If [offset] is aligned on an 8-byte boundary, returns a [Float32List]
  /// view of the specified region; otherwise, creates a [Float32List] that
  /// is a copy of the specified region and returns it.
  Float32List asFloat32List([int offset = 0, int length]) {
    length ??= _length32(offset);
    final index = _absIndex(offset);
    return (_isAligned32(index))
        ? buf.buffer.asFloat32List(index, length)
        : getFloat32List(offset, length);
  }

  /// If [offset] is aligned on an 8-byte boundary, returns a [Float64List]
  /// view of the specified region; otherwise, creates a [Float64List] that
  /// is a copy of the specified region and returns it.
  Float64List asFloat64List([int offset = 0, int length]) {
    final index = _absIndex(offset);
    length ??= _length64(offset);
    return (_isAligned64(index))
        ? buf.buffer.asFloat64List(index, length)
        : getFloat64List(offset, length);
  }

  // **** TypedData copies

  /// Creates a new [Bytes] from _this_ containing the specified region.
  /// The [endian]ness is the same as _this_.
  Bytes sublist([int start = 0, int end]) =>
      Bytes.fromUint8List(buf.sublist(start, end ?? buf.length));

  /// Creates an [Int8List] copy of the specified region of _this_.
  ByteData getByteData([int offset = 0, int length]) =>
      getUint8List(offset, length).buffer.asByteData();

  /// Creates an [Int8List] copy of the specified region of _this_.
  Int8List getInt8List([int start = 0, int length]) =>
      buf.buffer.asInt8List(offset, length ?? buf.length).sublist(start);

  /// Creates an [Int16List] copy of the specified region of _this_.
  Int16List getInt16List([int offset = 0, int length]) {
    length ??= _length16(offset);
    final list = Int16List(length);
    for (var i = 0, j = offset; i < length; i++, j += 2)
      list[i] = bd.getInt16(j, endian);
    return list;
  }

  /// Creates an [Int32List] copy of the specified region of _this_.
  Int32List getInt32List([int offset = 0, int length]) {
    length ??= _length32(offset);
    final list = Int32List(length);
    for (var i = 0, j = offset; i < length; i++, j += 4)
      list[i] = bd.getInt32(j, endian);
    return list;
  }

  /// Creates an [Int64List] copy of the specified region of _this_.
  Int64List getInt64List([int offset = 0, int length]) {
    length ??= _length64(offset);
    final list = Int64List(length);
    for (var i = 0, j = offset; i < length; i++, j += 8)
      list[i] = bd.getInt64(j, endian);
    return list;
  }

  // **** Unsigned Integer Lists

  Uint8List getUint8List([int start = 0, int length]) =>
      buf.sublist(start, (length ??= buf.length) + start);

  /// Creates an [Uint16List] copy of the specified region of _this_.
  Uint16List getUint16List([int offset = 0, int length]) {
    length ??= _length16(offset);
    final list = Uint16List(length);
    for (var i = 0, j = offset; i < length; i++, j += 2)
      list[i] = bd.getUint16(j, endian);
    return list;
  }

  /// Creates an [Uint32List] copy of the specified region of _this_.
  Uint32List getUint32List([int offset = 0, int length]) {
    length ??= _length32(offset);
    final list = Uint32List(length);
    for (var i = 0, j = offset; i < length; i++, j += 4)
      list[i] = bd.getUint32(j, endian);
    return list;
  }

  /// Creates an [Uint64List] copy of the specified region of _this_.
  Uint64List getUint64List([int offset = 0, int length]) {
    length ??= _length64(offset);
    final list = Uint64List(length);
    for (var i = 0, j = offset; i < length; i++, j += 8)
      list[i] = bd.getUint64(j, endian);
    return list;
  }

  // **** Float Lists

  /// Creates an [Float32List] copy of the specified region of _this_.
  Float32List getFloat32List([int offset = 0, int length]) {
    length ??= _length32(offset);
    final list = Float32List(length);
    for (var i = 0, j = offset; i < length; i++, j += 4)
      list[i] = bd.getFloat32(j, endian);
    return list;
  }

  /// Creates an [Float64List] copy of the specified region of _this_.
  Float64List getFloat64List([int offset = 0, int length]) {
    length ??= _length64(offset);
    final list = Float64List(length);
    for (var i = 0, j = offset; i < length; i++, j += 8)
      list[i] = bd.getFloat64(j, endian);
    return list;
  }

  // **** Get Strings and List<String>

  /// Returns a [String] containing a _Base64_ encoding of the specified
  /// region of _this_.
  String getBase64([int offset = 0, int length]) {
    final bList = asUint8List(offset, length);
    return bList.isEmpty ? '' : cvt.base64.encode(bList);
  }

  Uint8List _asUint8ListForString(int offset, int length) {
    final index = _absIndex(offset);
    assert(index >= 0);
    if (length > buf.length) throw ArgumentError('Invalid Offset: $offset');
    return buf.buffer.asUint8List(index, length);
  }

  /// Returns a [String] containing a _UTF-8_ decoding of the specified region.
  String getString(
      {int offset = 0,
      int length,
      bool allowInvalid = true,
      Charset charset = utf8}) {
    final list = asUint8List(offset, length ?? buf.length);
    return list.isEmpty ? '' : charset.decode(list, allowInvalid: true);
  }

  /// Returns a [List<String>]. This is done by first decoding
  /// the specified region as _UTF-8_, and then _split_ing the
  /// resulting [String] using the [separator].
  List<String> getStringList(
      {int offset = 0,
      int length,
      bool allowInvalid = true,
      String separator = '\\',
      Charset charset = utf8}) {
    final s = getString(
        offset: offset,
        length: length,
        allowInvalid: allowInvalid,
        charset: charset);
    return (s.isEmpty) ? <String>[] : s.split(separator);
  }

  // Urgent decide if these should be here. I don't think so. Use DicomBytes
  // instead.

  // TODO: rewrite in terms of getString
  /// Returns a [String] containing a _ASCII_ decoding of the specified
  /// region of _this_.
  String getAscii({int offset = 0, int length, bool allowInvalid = true}) {
    final list = asUint8List(offset, length ?? buf.length);
    return list.isEmpty ? '' : cvt.ascii.decode(list, allowInvalid: true);
  }

  // TODO: rewrite in terms of getStringList
  /// Returns a [List<String>]. This is done by first decoding
  /// the specified region as _ASCII_, and then _split_ing the
  /// resulting [String] using the [separator].
  List<String> getAsciiList(
      {int offset = 0,
      int length,
      bool allowInvalid = true,
      String separator = '\\'}) {
    final s =
        getAscii(offset: offset, length: length, allowInvalid: allowInvalid);
    return (s.isEmpty) ? <String>[] : s.split(separator);
  }

  // TODO: rewrite in terms of getString
  /// Returns a [String] containing a _UTF-8_ decoding of the specified region.
  String getUtf8({int offset = 0, int length, bool allowInvalid = true}) {
    final v = asUint8List(offset, length ?? buf.length);
    return v.isEmpty ? '' : cvt.utf8.decode(v, allowMalformed: allowInvalid);
  }

  /// Returns a [List<String>]. This is done by first decoding
  /// the specified region as _UTF-8_, and then _split_ing the
  /// resulting [String] using the [separator].
  // TODO: rewrite in terms of getStringList
  List<String> getUtf8List(
      {int offset = 0,
      int length,
      bool allowInvalid = true,
      String separator = '\\'}) {
    final s =
        getUtf8(offset: offset, length: length, allowInvalid: allowInvalid);
    return (s.isEmpty) ? <String>[] : s.split(separator);
  }

  // TODO: rewrite in terms of getString
  String getLatin({int offset = 0, int length, bool allowInvalid = true}) {
    final v = _asUint8ListForString(offset, length ?? buf.length);
    return v.isEmpty ? '' : cvt.latin1.decode(v, allowInvalid: allowInvalid);
  }

  /// Returns a [List<String>]. This is done by first decoding
  /// the specified region as _UTF-8_, and then _split_ing the
  /// resulting [String] using the [separator].
  // TODO: rewrite in terms of getStringList
  List<String> getLatinList(
      {int offset = 0,
      int length,
      bool allowInvalid = true,
      String separator = '\\'}) {
    final s =
        getLatin(offset: offset, length: length, allowInvalid: allowInvalid);
    return (s.isEmpty) ? <String>[] : s.split(separator);
  }

  // ********************** Setters ********************************

  // Internal setters take an absolute index [i] into the underlying
  // [ByteBuffer] ([buf].buffer).  The external interface of this package
  // uses [offset]s relative to the current [buf.offsetInBytes].

  // **** Int8 set methods

  void setInt8(int i, int v) => buf[i] = v;

  /// Returns the number of bytes set.
  int setInt8List(int start, List<int> list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kInt8Size);
    for (var i = offset, j = start; i < length; i++, j++) buf[j] = list[i];
    return length;
  }

  void setInt16(int i, int v) => bd.setInt16(i, v, endian);

  int setInt16List(int start, List<int> list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kInt16Size);
    for (var i = offset, j = start; i < length; i++, j += 2)
      bd.setInt16(j, list[i], endian);
    return length * 2;
  }

  void setInt32(int i, int v) => bd.setInt32(i, v, endian);

  int setInt32List(int start, List<int> list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kInt32Size);
    for (var i = offset, j = start; i < length; i++, j += 4)
      bd.setInt32(j, list[i], endian);
    return length * 4;
  }

  void setInt32x4(int offset, Int32x4 value) {
    var i = offset;
    bd
      ..setInt32(i, value.w, endian)
      ..setInt32(i += 4, value.x, endian)
      ..setInt32(i += 4, value.y, endian)
      ..setInt32(i += 4, value.z, endian);
  }

  void setInt64(int i, int v) => bd.setInt64(i, v, endian);

  int setInt64List(int start, List<int> list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kInt64Size);
    for (var i = offset, j = start; i < length; i++, j += 8)
      bd.setInt64(j, list[i], endian);
    return length * 6;
  }

  int setInt32x4List(int start, Int32x4List list,
      [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kInt32Size * 4);
    for (var i = offset, j = start; i < length; i++, j += 16)
      setInt32x4(j, list[i]);
    return length * 16;
  }

  // **** Uint set methods

  void setUint8(int i, int v) => buf[i] = v;

  int setUint8List(int start, List<int> list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkRange(offset, length);
    for (var i = start, j = offset; i < length; i++, j++) buf[i] = list[j];
    return length;
  }

  void setUint16(int i, int v) => bd.setUint16(i, v, endian);

  int setUint16List(int start, List<int> list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kUint16Size);
    for (var i = offset, j = start; i < length; i++, j += 2)
      bd.setUint16(j, list[i], endian);
    return length * 2;
  }

  void setUint32(int i, int v) => bd.setUint32(i, v, endian);

  int setUint32List(int start, List<int> list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kUint32Size);
    for (var i = offset, j = start; i < length; i++, j += 4)
      bd.setUint32(j, list[i], endian);
    return length * 4;
  }

  void setUint64(int i, int v) => bd.setUint64(i, v, endian);

  int setUint64List(int start, List<int> list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kUint64Size);
    for (var i = offset, j = start; i < length; i++, j += 8)
      bd.setUint64(j, list[i], endian);
    return length * 8;
  }

  // Float32 set methods

  void setFloat32(int i, double v) => bd.setFloat32(i, v, endian);

  int setFloat32List(int start, List<double> list,
      [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kFloat32Size);
    for (var i = offset, j = start; i < length; i++, j += 4)
      bd.setFloat32(j, list[i], endian);
    return length * 4;
  }

  void setFloat32x4(int index, Float32x4 v) {
    var i = index;
    bd
      ..setFloat32(i, v.w, endian)
      ..setFloat32(i += 4, v.x, endian)
      ..setFloat32(i += 4, v.y, endian)
      ..setFloat32(i += 4, v.z, endian);
  }

  int setFloat32x4List(int start, Float32x4List list,
      [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, list.length * 16);
    for (var i = offset, j = start; i < length; i++, j += 16)
      setFloat32x4(j, list[i]);
    return length * 16;
  }

  void setFloat64(int i, double v) => bd.setFloat64(i, v, endian);

  int setFloat64List(int start, List<double> list,
      [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kFloat64Size);
    for (var i = offset, j = start; i < length; i++, j += 8)
      bd.setFloat64(j, list[i], endian);
    return length * 8;
  }

  void setFloat64x2(int index, Float64x2 v) {
    var i = index;
    bd..setFloat64(i, v.x, endian)..setFloat64(i += 4, v.y, endian);
  }

  int setFloat64x2List(int start, Float64x2List list,
      [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kFloat64Size);
    for (var i = offset, j = start; i < length; i++, j += 16)
      setFloat64x2(j, list[i]);
    return length * 16;
  }

  // **** String Setters

  void setString(int start, String s, [int offset = 0, int length]) =>
      setUtf8(start, s);

  // **** List Setters

  /// Copies [length] bytes from other starting at offset into _this_
  /// starting at [start]. [length] defaults [bytes].length.
  void setBytes(int start, Bytes bytes, [int offset = 0, int length]) {
    length ?? bytes.length;
    _checkRange(offset, length);
    for (var i = start, j = offset; i < length; i++, j++) buf[i] = bytes[j];
  }

  void setByteData(int start, ByteData bd, [int offset = 0, int length]) =>
      setUint8List(start, bd.buffer.asUint8List(), offset, length);

  // **** String List Setters
// Urgent: Move this to DicomBytesMixin
  // Urgent: move up next to primitives
  // TODO: unit test
  /// UTF-8 encodes the specified range of [s] and then writes the
  /// code units to _this_ starting at [start]. Returns the offset
  /// of the last byte + 1.
  int setAscii(int start, String s) => setUint8List(start, cvt.ascii.encode(s));

  /// Writes the ASCII [String]s in [sList] to _this_ starting at [start].
  /// Returns the number of bytes written.
  int setAsciiList(int start, List<String> sList) =>
      setAscii(start, sList.join('\\'));

  // TODO: unit test
  /// UTF-8 encodes the specified range of [s] and then writes the
  /// code units to _this_ starting at [start]. Returns the offset
  /// of the last byte + 1.
  int setLatin(int start, String s) =>
      setUint8List(start, cvt.latin1.encode(s));

  /// Writes the LATIN [String]s in [sList] to _this_ starting at [start].
  /// Returns the number of bytes written.
  /// _Note_: All latin character sets are encoded as single 8-bit bytes.
  int setLatinList(int start, List<String> sList) =>
      setAscii(start, sList.join('\\'));

  // TODO: unit test
  /// UTF-8 encodes the specified range of [s] and then writes the
  /// code units to _this_ starting at [start]. Returns the offset
  /// of the last byte + 1.
  int setUtf8(int start, String s) => setUint8List(start, cvt.utf8.encode(s));

  /// Converts the [String]s in [sList] into a [Uint8List].
  /// Then copies the bytes into _this_ starting at [start].
  /// Returns the number of bytes written.
  int setUtf8List(int start, List<String> sList) =>
      setUtf8(start, sList.join('\\'));

  // **** Other

  @override
  String toString() => '$endianness $runtimeType: ${info(buf)}';

  /// Controls whether [info] display the values in [buf].
  bool showByteValues = false;

  /// The number of bytes that should be display by [info].
  int truncateBytesLength = 16;

  /// Returns a [String] containing info about _this_.
  String info(Uint8List buf) {
    final start = offset;
    final length = buf.length;
    final _length =
        (length > truncateBytesLength) ? truncateBytesLength : length;
    final end = start + length;
    final sb = StringBuffer('$start-$end:$length');
    // TODO: fix for truncated values print [x, y, z, ...]
    if (showByteValues) sb.writeln('${buf.buffer.asUint8List(start, _length)}');
    return '$sb';
  }

  // **** Internals

  /// Returns the absolute index of [offset] in the underlying [ByteBuffer].
  int _absIndex(int offset) => buf.offsetInBytes + offset;

  void _checkRange(int offset, int sizeInBytes) {
    final length = offset + sizeInBytes;
    if (length > buf.length)
      throw RangeError('$length is larger then bytes remaining $buf.length');
  }

  /// Checks that buf[bufOffset, buf.length] >= vLengthInBytes.
  /// [start] is the offset in [buf]. [length] is the number of elements.
  /// Size is the number of bytes in each element.
  bool _checkLength(int start, int vLength, int size) {
    final vLengthInBytes = vLength * size;
    final limit = buf.length - (buf.offsetInBytes + start);
    if (vLengthInBytes > limit) {
      throw RangeError('List ($vLengthInBytes bytes) is too large for '
          'Bytes($limit bytes');
    }
    return true;
  }
}

/// Returns a [Uint8List] that is a copy of the specified region of [list].
Uint8List copyUint8List(Uint8List list, int offset, int length) {
  final len = length ?? list.length;
  final copy = Uint8List(len);
  for (var i = 0, j = offset; i < len; i++, j++) copy[i] = list[j];
  return copy;
}
