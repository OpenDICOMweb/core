// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

export 'package:core/src/utils/bytes/buffer/read_buffer.dart';
export 'package:core/src/utils/bytes/buffer/write_buffer.dart';
export 'package:core/src/utils/bytes/bytes.dart';

// TODO: defer loading of convert
// TODO: Unit Test
// TODO: Document
// TODO: Decide if Growable should be Merged with Bytes
// TODO: Create primitive version using only ByteBuffer
// TODO: Decide whether Bytes should extend List

const int _k1GB = 1024 * 1024 * 1024;
const int kMinLength = 16;
const int kDefaultLength = 1024;
const int kDefaultLimit = _k1GB;

const Endianness kDefaultEndian = Endian.little;

bool _isMaxCapacityExceeded(int length, [int maxLength]) {
  maxLength ??= kDefaultLimit;
  return length >= maxLength;
}

// TODO: Figure out the best way to be closed over [endian] in order to avoid
//       having it as a local variable. It seams like ByteData primitives
//       should be divided into getUintXLittleEndian and getUintXBigEndian
/// [Bytes] is a class that provides a read-only byte array that supports both
/// [Uint8List] and [ByteData] interfaces.
class Bytes extends ListBase<int> {
  ByteData _bd;
  final Endian endian;

  /// Returns a
  Bytes([int length = kDefaultLength, this.endian = Endian.little])
      : _bd = new ByteData(length);

  Bytes.from(Bytes bytes,
      [int offset = 0, int length, this.endian = Endian.little])
      : _bd = bytes.asByteData(offset, length ?? bytes.lengthInBytes);

  Bytes.fromList(List<int> list, [this.endian = Endian.little])
      : _bd = _listToByteData(list);

  Bytes.fromTypedData(TypedData td, [this.endian = Endian.little])
      : _bd = td.buffer.asByteData();

  Bytes.view(Bytes bytes,
      [int offset = 0, int length, this.endian = Endian.little])
      : _bd = bytes.asByteData(offset, length ?? bytes.lengthInBytes);

  Bytes.typedDataView(TypedData td,
      [int offset = 0, int length, this.endian = Endian.little])
      : _bd = td.buffer.asByteData(
            td.offsetInBytes + offset, length * td.elementSizeInBytes);

  // Core accessor NOT to be exported?
  ByteData get bd => _bd;

  // **** Object overrides

  @override
  bool operator ==(Object other) {
    if (other is Bytes) {
      if (_bd.lengthInBytes != other._bd.lengthInBytes) return false;
      for (var i = 0; i < length; i++)
        if (_bd.getUint8(i) != other._bd.getUint8(i)) return false;
      return true;
    }
    return false;
  }

  @override
  int get hashCode {
    var hashCode = 0;
    for (var i = 0; i < lengthInBytes; i++) hashCode += _bd.getUint8(i) + i;
    return hashCode;
  }

  // **** TypedData interface.
  int get elementSizeInBytes => 1;
  int get offsetInBytes => _bd.offsetInBytes;
  int get lengthInBytes => _bd.lengthInBytes;
  ByteBuffer get buffer => _bd.buffer;

  // *** List interface

  @override
  int get length => _bd.lengthInBytes;
  @override
  set length(int length) =>
      throw new UnsupportedError('$runtimeType: length is not modifiable');

  @override
  int operator [](int i) => _bd.getUint8(i);

  @override
  void operator []=(int i, int v) => _bd.setUint8(i, v);

  @override
  Bytes sublist(int start, [int end]) =>
      new Bytes.from(this, start, end ?? length, endian);

  // **** Extensions

  bool _isAligned(int offset, int size) =>
      ((_bd.offsetInBytes + offset) % size) == 0;

  bool isAligned16(int offset) => _isAligned(offset, 2);
  bool isAligned32(int offset) => _isAligned(offset, 4);
  bool isAligned64(int offset) => _isAligned(offset, 8);

  // **** ByteData Getters

  int getInt8(int rIndex) => _bd.getInt8(rIndex);

  int getUint8(int rIndex) => _bd.getUint8(rIndex);

  int getUint16(int rIndex) => _bd.getUint16(rIndex, endian);

  int getInt16(int rIndex) => _bd.getInt16(rIndex, endian);

  int getUint32(int rIndex) => _bd.getUint32(rIndex, endian);

  int getInt32(int rIndex) => _bd.getInt32(rIndex, endian);

  int getUint64(int rIndex) => _bd.getUint64(rIndex, endian);

  int getInt64(int rIndex) => _bd.getInt64(rIndex, endian);

  double getFloat32(int rIndex) => _bd.getFloat32(rIndex, endian);

  double getFloat64(int rIndex) => _bd.getFloat64(rIndex, endian);

  // **** TypedData List Getters

  Int8List getInt8List([int offset = 0, int length]) =>
      new Int8List.fromList(_bd.buffer.asInt8List(offset, length ?? length));

  Int16List getInt16List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes ~/ Int16List.bytesPerElement;
    final list = new Int16List(length);
    for (var i = 0, j = offset; i < length; i++, j += 2) list[i] = getInt16(j);
    return list;
  }

  Int32List getInt32List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes ~/ Int32List.bytesPerElement;
    final list = new Int32List(length);
    for (var i = 0, j = offset; i < length; i++, j += 4) list[i] = getInt32(j);
    return list;
  }

  Int64List getInt64List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes ~/ Int64List.bytesPerElement;
    final list = new Int64List(length);
    for (var i = 0, j = offset; i < length; i++, j += 8) list[i] = getInt64(j);
    return list;
  }

  // **** Unsigned Integer List
  Uint8List getUint8List([int offset = 0, int length]) =>
      new Uint8List.fromList(_bd.buffer.asUint8List(offset, length ?? length));

  Uint16List getUint16List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes ~/ Uint16List.bytesPerElement;
    final list = new Uint16List(length);
    for (var i = 0, j = offset; i < length; i++, j += 2) list[i] = getUint16(j);
    return list;
  }

  Uint32List getUint32List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes ~/ Uint32List.bytesPerElement;
    final list = new Uint32List(length);
    for (var i = 0, j = offset; i < length; i++, j += 4) list[i] = getUint32(j);
    return list;
  }

  Uint64List getUint64List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes ~/ Uint64List.bytesPerElement;
    final list = new Uint64List(length);
    for (var i = 0, j = offset; i < length; i++, j += 8) list[i] = getUint64(j);
    return list;
  }

  // **** Float Lists

  Float32List getFloat32List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes;
    final list = new Float32List(length);
    for (var i = 0, j = offset; i < length; i++, j += 4)
      list[i] = getFloat32(j);
    return list;
  }

  //TODO: does this align optimization improve performance
  Float64List getFloat64List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes;
    final list = new Float64List(length);
    for (var i = 0, j = offset; i < length; i++, j += 8)
      list[i] = getFloat64(j);
    return list;
  }

  // **** String getters
  // TODO: decide if these should be included
  String getAscii([int offset = 0, int length]) =>
      ASCII.decode(asUint8List(offset, length ?? lengthInBytes));

  String getUtf8([int offset = 0, int length]) =>
      UTF8.decode(asUint8List(offset, length ?? lengthInBytes));

  // **** TypedData Views

  // Returns the absolute offset in the ByteBuffer.
  int _bdOffset(int offset) => _bd.offsetInBytes + offset;

  // Returns a view of _this_.
  Bytes asBytes([int offset = 0, int length]) =>
      new Bytes.view(this, _bdOffset(offset), length ?? lengthInBytes);

  ByteData asByteData([int offset = 0, int length]) =>
      _bd.buffer.asByteData(_bdOffset(offset), length ?? _bd.lengthInBytes);

  Int8List asInt8List([int offset = 0, int length]) =>
      _bd.buffer.asInt8List(_bdOffset(offset), length ?? _bd.lengthInBytes);

  Int16List asInt16List([int offset = 0, int length]) => (isAligned16(offset))
      ? _bd.buffer
          .asInt16List(_bdOffset(offset), length ?? (_bd.lengthInBytes ~/ 2))
      : getInt16List(offset, length);

  Int32List asInt32List([int offset = 0, int length]) => (isAligned32(offset))
      ? _bd.buffer
          .asInt32List(_bdOffset(offset), length ?? (_bd.lengthInBytes ~/ 4))
      : getInt32List(offset, length);

  Int64List asInt64List([int offset = 0, int length]) => (isAligned64(offset))
      ? _bd.buffer
          .asInt64List(_bdOffset(offset), length ?? (_bd.lengthInBytes ~/ 8))
      : getInt64List(offset, length);

  Uint8List asUint8List([int offset = 0, int length]) =>
      _bd.buffer.asUint8List(_bdOffset(offset), length ?? _bd.lengthInBytes);

  Uint16List asUint16List([int offset = 0, int length]) => (isAligned16(offset))
      ? _bd.buffer
          .asUint16List(_bdOffset(offset), length ?? (_bd.lengthInBytes ~/ 2))
      : getUint16List(offset, length);

  Uint32List asUint32List([int offset = 0, int length]) => (isAligned32(offset))
      ? _bd.buffer
          .asUint32List(_bdOffset(offset), length ?? (_bd.lengthInBytes ~/ 4))
      : getUint32List(offset, length);

  Uint64List asUint64List([int offset = 0, int length]) => (isAligned64(offset))
      ? _bd.buffer
          .asUint64List(_bdOffset(offset), length ?? (_bd.lengthInBytes ~/ 8))
      : getUint64List(offset, length);

  Float32List asFloat32List([int offset = 0, int length]) =>
      (isAligned32(offset))
          ? _bd.buffer.asFloat32List(
              _bdOffset(offset), length ?? (_bd.lengthInBytes ~/ 4))
          : getFloat32List(offset, length);

  Float64List asFloat64List([int offset = 0, int length]) =>
      (isAligned64(offset))
          ? _bd.buffer.asFloat64List(
              _bdOffset(offset), length ?? (_bd.lengthInBytes ~/ 8))
          : getFloat64List(offset, length);

  // **** ByteData Setters

  void setInt8(int wIndex, int value) => _bd.setInt8(wIndex, value);

  void setUint8(int wIndex, int value) => _bd.setUint8(wIndex, value);

  void setUint16(int wIndex, int value) => _bd.setUint16(wIndex, value, endian);

  void setInt16(int wIndex, int value) => _bd.setInt16(wIndex, value, endian);

  void setUint32(int wIndex, int value) => _bd.setUint32(wIndex, value, endian);

  void setInt32(int wIndex, int value) => _bd.setInt32(wIndex, value, endian);

  void setUint64(int wIndex, int value) => _bd.setUint64(wIndex, value, endian);

  void setInt64(int wIndex, int value) => _bd.setInt64(wIndex, value, endian);

  void setFloat32(int wIndex, double value) =>
      _bd.setFloat32(wIndex, value, endian);

  void setFloat64(int wIndex, double value) =>
      _bd.setFloat64(wIndex, value, endian);

  // **** TypedData List Setters

  void setInt8List(Uint8List list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kInt8Size);
    for (var i = offset; i < length ?? list.length; i++)
      _bd.setInt8(i, list[i]);
  }

  void setInt16List(Int16List list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kInt16Size);
    for (var i = offset; i < length ?? list.length; i++)
      _bd.setInt16(i, list[i]);
  }

  void setInt32List(Int32List list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kInt32Size);
    for (var i = offset; i < length ?? list.length; i++)
      _bd.setInt32(i, list[i]);
  }

  void setInt64List(Int64List list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kInt64Size);
    for (var i = offset; i < length ?? list.length; i++)
      _bd.setInt64(i, list[i]);
  }

  void setUint8List(Uint8List list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kUint8Size);
    for (var i = offset; i < length ?? list.length; i++)
      _bd.setUint8(i, list[i]);
  }

  void setUint16List(Uint16List list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kUint16Size);
    for (var i = offset; i < length ?? list.length; i++)
      _bd.setUint16(i, list[i]);
  }

  void setUint32List(Uint32List list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kUint32Size);
    for (var i = offset; i < length ?? list.length; i++)
      _bd.setUint32(i, list[i]);
  }

  void setUint64List(Uint64List list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kUint64Size);
    for (var i = offset; i < length ?? list.length; i++)
      _bd.setUint64(i, list[i]);
  }

  void setFloat32List(Float32List list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kFloat32Size);
    for (var i = offset; i < length ?? list.length; i++)
      _bd.setFloat32(i, list[i]);
  }

  void setFloat64List(Float64List list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kFloat64Size);
    for (var i = offset; i < length ?? list.length; i++)
      _bd.setFloat64(i, list[i]);
  }

  void _checkLength(int offset, int length, int size) {
    final lLength = length * size;
    final bLength = _bd.lengthInBytes - (_bd.offsetInBytes + offset);
    if (length > bLength)
      throw new RangeError('List ($lLength bytes) is to large for '
          'Bytes($bLength bytes');
  }

  // **** String Setters
  // TODO: decide if these should be included
  void setAscii(String s, [int offset = 0, int length]) {
    length ??= s.length;
    final v = (offset == 0 && length == s.length)
        ? s
        : s.substring(offset, offset + length);
    setUint8List(ASCII.encode(v), offset, length);
  }

  void setUtf8(String s, [int offset = 0, int length]) {
    length ??= s.length;
    final v = (offset == 0 && length == s.length)
        ? s
        : s.substring(offset, offset + length);
    setUint8List(ASCII.encode(v), offset, length);
  }

  static const int kInt8Size = 1;
  static const int kInt16Size = 2;
  static const int kInt32Size = 4;
  static const int kInt64Size = 8;

  static const int kUint8Size = 1;
  static const int kUint16Size = 2;
  static const int kUint32Size = 4;
  static const int kUint64Size = 8;

  static const int kFloat32Size = 4;
  static const int kFloat64Size = 8;

  static const int kInt8MinValue = -0x7F - 1;
  static const int kInt16MinValue = -0x7FFF - 1;
  static const int kInt32MinValue = -0x7FFFFFFF - 1;
  static const int kInt64MinValue = -0x7FFFFFFFFFFFFFFF - 1;

  static const int kUint8MinValue = 0;
  static const int kUint16MinValue = 0;
  static const int kUint32MinValue = 0;
  static const int kUint64MinValue = 0;

  static const int kInt8MaxValue = 0x7F;
  static const int kInt16MaxValue = 0x7FFF;
  static const int kInt32MaxValue = 0x7FFFFFFF;
  static const int kInt64MaxValue = 0x7FFFFFFFFFFFFFFF;

  static const int kUint8MaxValue = 0xFF;
  static const int kUint16MaxValue = 0xFFFF;
  static const int kUint32MaxValue = 0xFFFFFFFF;
  static const int kUint64MaxValue = 0xFFFFFFFFFFFFFFFF;

  static const int kDefaultLength = 1024;

  bool isInt8(int i) => i > kInt8MinValue && i <= kInt8MaxValue;
  bool isInt16(int i) => i > kInt16MinValue && i <= kInt16MaxValue;
  bool isInt32(int i) => i > kInt32MinValue && i <= kInt32MaxValue;
  bool isInt64(int i) => i > kInt64MinValue && i <= kInt64MaxValue;

  bool isUint8(int i) => i > kUint8MinValue && i <= kUint8MaxValue;
  bool isUint16(int i) => i > kUint16MinValue && i <= kUint16MaxValue;
  bool isUint32(int i) => i > kUint32MinValue && i <= kUint32MaxValue;
  bool isUint64(int i) => i > kUint64MinValue && i <= kUint64MaxValue;
}

class GrowableBytes extends Bytes {
  /// The upper bound on the length of this [Bytes]. If [limit]
  /// is _null_ then its length cannot be changed.
  final int limit;

  /// Returns a new [Bytes] of [length].
  GrowableBytes(int length,
      [Endian endian = Endian.little, this.limit = kDefaultLimit])
      : super(length, endian);

  /// Returns a new [Bytes] starting at [offset] of [length].
  GrowableBytes.from(GrowableBytes bytes,
      [int offset = 0,
      int length,
      Endian endian = Endian.little,
      this.limit = _k1GB])
      : super.from(bytes, offset, length, endian);

  GrowableBytes.fromTypedData(TypedData td,
      [Endian endian = Endian.little, this.limit = _k1GB])
      : super.fromTypedData(td, endian);

  @override
  set length(int newLength) {
    if (newLength < _bd.lengthInBytes) return;
    grow(newLength);
  }

  /// Ensures that [_bd] is at least [length] long, and grows
  /// the buf if necessary, preserving existing data.
  bool ensureLength(int length) => (length > lengthInBytes) ? grow() : false;

  /// Creates a new buffer at least double the size of the current buffer,
  /// and copies the contents of the current buffer into it.
  ///
  /// If [minLength] is null the new buffer will be twice the size of the
  /// current buffer. If [minLength] is not null, the new buffer will be at
  /// least that size. It will always have at least have double the
  /// capacity of the current buffer.
  bool grow([int minLength]) {
    minLength ??= kMinLength;
    if (minLength <= _bd.lengthInBytes) return false;

    var newLength = _bd.lengthInBytes;
    while (newLength < minLength) newLength *= 2;

    if (_isMaxCapacityExceeded(newLength)) return false;

    final newBD = new ByteData(newLength);
    for (var i = 0; i < _bd.lengthInBytes; i++)
      newBD.setUint8(i, _bd.getUint8(i));
    _bd = newBD;
    return true;
  }

  bool checkAllZeros(int start, int end) {
    for (var i = start; i < end; i++) if (_bd.getUint8(i) != 0) return false;
    return true;
  }

  static int kMaximumLength = kDefaultLimit;
}

// ***  Internals

ByteData _listToByteData(List<int> list) => (list is Uint8List)
    ? list.buffer.asByteData()
    : (new Uint8List.fromList(list)).buffer.asByteData();