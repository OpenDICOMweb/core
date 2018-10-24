//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
/*
import 'dart:convert';
import 'dart:typed_data';

import 'package:core/src/utils/bytes.dart';
*/

part of odw.sdk.core.buffer;

// ignore_for_file: public_member_api_docs

abstract class WriteBufferMixin {
  // **** Interface
  /// The underlying [Bytes] for the buffer.
  GrowableBytes get bytes;

  // **** End of Interface

  int get readIndex => _rIndex;
  int get _rIndex;
  set _rIndex(int n) => _rIndex = n;

  // *** wIndex

  int get writeIndex => _wIndex;
  int get _wIndex;
  set _wIndex(int n) {
    if (_wIndex <= _rIndex || _wIndex > bytes.length)
      throw RangeError.range(_wIndex, _rIndex, bytes.length);
    _wIndex = n;
  }

  ByteBuffer get buffer => bytes.buffer;

  int get limit => bytes.limit;

  ByteData asByteData([int offset, int length]) =>
      bytes.buffer.asByteData(offset, length);


  // **** WriteBuffer specific Getters and Methods

  int get length => bytes.length;

  int get writeRemaining => bytes.length - _wIndex;
  int get remaining => writeRemaining;
  int get writeRemainingMax => limit - _wIndex;
  bool get isWritable => remaining > 0;
  bool get isEmpty => remaining <= 0;
  bool get isNotEmpty => !isEmpty;
  int get remainingMax => kDefaultLimit - _wIndex;

  bool get isReadable => _wIndex > 0;
  int get readRemaining => _wIndex - _rIndex;

  bool hasRemaining(int n) {
    assert(n >= 0);
    return remaining >= 0;
  }

  /// Moves the [_wIndex] forward/backward. Returns the new [_wIndex].
  int wSkip(int n) {
    final v = _wIndex + n;
    if (v <= _rIndex || v >= bytes.length)
      throw RangeError.range(v, 0, bytes.length);
    return _wIndex = v;
  }

  void write(Bytes bList, [int offset = 0, int length]) {
    length ??= bList.length;
    ensureRemaining(length + 1);
    for (var i = offset, j = _wIndex; i < length; i++, j++)
      bytes.setUint8(j, bList[i]);
    _wIndex += length;
  }

  void setInt8(int n) => bytes.setInt8(_wIndex, n);

  void writeInt8(int n) {
    assert(n >= -128 && n <= 127, 'Value out of range: $n');
    maybeGrow(1024);
    bytes.setInt8(_wIndex, n);
    _wIndex++;
  }

  void setInt16(int n) => bytes.setInt16(_wIndex, n);

  /// Writes a 16-bit unsigned integer (Uint16) values to _this_.
  void writeInt16(int value) {
    assert(
        value >= -0x7FFF && value <= 0x7FFF - 1, 'Value out of range: $value');
    maybeGrow(2);
    bytes.setInt16(_wIndex, value);
    _wIndex += 2;
  }

  void setInt32(int n) => bytes.setInt32(_wIndex, n);

  /// Writes a 32-bit unsigned integer (Uint32) values to _this_.
  void writeInt32(int value) {
    assert(value >= -0x7FFFFFFF && value <= 0x7FFFFFFF - 1,
        'Value out if range: $value');
    maybeGrow(4);
    bytes.setInt32(_wIndex, value);
    _wIndex += 4;
  }

  void setInt64(int n) => bytes.setInt64(_wIndex, n);

  /// Writes a 64-bit unsigned integer (Uint32) values to _this_.
  void writeInt64(int value) {
    assert(value >= -0x7FFFFFFFFFFFFFFF && value <= 0x7FFFFFFFFFFFFFFF - 1,
        'Value out of range: $value');
    maybeGrow(8);
    bytes.setInt64(_wIndex, value);
    _wIndex += 8;
  }

  void setUint8(int n) => bytes.setUint8(_wIndex, n);

  /// Writes a byte (Uint8) values to _this_.
  void writeUint8(int value) {
    assert(value >= 0 && value <= 255, 'Value out of range: $value');
    maybeGrow(1);
    bytes.setUint8(_wIndex, value);
    _wIndex++;
  }

  void setUint16(int n) => bytes.setUint16(_wIndex, n);

  /// Writes a 16-bit unsigned integer (Uint16) values to _this_.
  void writeUint16(int value) {
    assert(value >= 0 && value <= 0xFFFF, 'Value out of range: $value');
    maybeGrow(2);
    bytes.setUint16(_wIndex, value);
    _wIndex += 2;
  }

  void setUint32(int n) => bytes.setUint32(_wIndex, n);

  /// Writes a 32-bit unsigned integer (Uint32) values to _this_.
  void writeUint32(int value) {
    assert(value >= 0 && value <= 0xFFFFFFFF, 'Value out if range: $value');
    maybeGrow(4);
    bytes.setUint32(_wIndex, value);
    _wIndex += 4;
  }

  void setUint64(int n) => bytes.setUint64(_wIndex, n);

  /// Writes a 64-bit unsigned integer (Uint32) values to _this_.
  void writeUint64(int value) {
    assert(value >= 0 && value <= 0xFFFFFFFFFFFFFFFF,
        'Value out of range: $value');
    maybeGrow(8);
    bytes.setUint64(_wIndex, value);
    _wIndex += 8;
  }

  // **** String writing methods
  void writeAscii(String s, [int offset = 0, int length]) =>
      writeUint8List(ascii.encode(s), offset, length);

  void writeUtf8(String s, [int offset = 0, int length]) =>
      _writeUtf8(s, offset, length);

  void _writeUtf8(String s, [int offset = 0, int length]) {
    final _s = (offset == 0 && length == null)
        ? s
        : s.substring(offset, offset + length);
    return writeUint8List(utf8.encode(_s));
  }

  void writeString(String s, [int offset = 0, int length]) =>
      _writeUtf8(s, offset, length);

  /// Writes [length] zeros to _this_.
  bool writeZeros(int length) {
    maybeGrow(length);
    for (var i = 0, j = _wIndex; i < length; i++, j++) bytes[j] = 0;
    _wIndex += length;
    return true;
  }

  // **** List writing methods

  void writeInt8List(Int8List list, [int offset = 0, int length]) {
    bytes.setInt8List(_wIndex, list, offset, length);
    _wIndex += list.length;
  }

  void writeInt16List(Int16List list, [int offset = 0, int length]) {
    bytes.setInt16List(_wIndex, list, offset, length);
    _wIndex += list.length * 2;
  }

  void writeInt32List(Int32List list, [int offset = 0, int length]) {
    bytes.setInt32List(_wIndex, list, offset, length);
    _wIndex += list.length * 4;
  }

  void writeInt64List(Int64List list, [int offset = 0, int length]) {
    bytes.setInt64List(_wIndex, list, offset, length);
    _wIndex += list.length * 8;
  }

  void writeUint8List(Uint8List bList, [int offset = 0, int length]) {
    if (bList.lengthInBytes == 0) return;
    writeByteData(bList.buffer.asByteData(bList.offsetInBytes, bList.length));
  }

  void writeByteData(ByteData bd, [int offset = 0, int length]) {
    final length = bd.lengthInBytes;
    if (length == 0) return;
    ensureRemaining(length);
    bytes.setByteData(_wIndex, bd, offset, length);
    _wIndex += length;
  }

  void writeUint16List(Uint16List list, [int offset = 0, int length]) {
    bytes.setUint16List(_wIndex, list, offset, length);
    _wIndex += list.length * 2;
  }

  void writeUint32List(Uint32List list, [int offset = 0, int length]) {
    bytes.setUint32List(_wIndex, list, offset, length);
    _wIndex += list.length * 4;
  }

  void writeUint64List(Uint64List list, [int offset = 0, int length]) {
    bytes.setUint64List(_wIndex, list, offset, length);
    _wIndex += list.length * 8;
  }

  void writeFloat32List(Float32List list, [int offset = 0, int length]) {
    bytes.setFloat32List(_wIndex, list, offset, length);
    _wIndex += list.length * 4;
  }

  void writeFloat64List(Float64List list, [int offset = 0, int length]) {
    bytes.setFloat64List(_wIndex, list, offset, length);
    _wIndex += list.length * 8;
  }

  void writeAsciiList(List<String> list, [int offset = 0, int length]) =>
      _wIndex += bytes.setAsciiList(_wIndex, list, offset, length);

  void writeUtf8List(List<String> list, [int offset = 0, int length]) =>
      _wIndex += bytes.setUtf8List(_wIndex, list, offset, length);

  void writeStringList(List<String> list) => writeUtf8List(list);

  /// Ensures that [bytes] has at least [remaining] writable _bytes.
  /// The [bytes] is grows if necessary, and copies existing _bytes into
  /// the new [bytes].
  bool ensureRemaining(int remaining) => _ensureRemaining(remaining);
  bool _ensureRemaining(int remaining) => _ensureCapacity(_wIndex + remaining);

  /// Ensures that [bytes] is at least [capacity] long, and grows
  /// the buf if necessary, preserving existing data.
  bool ensureCapacity(int capacity) => _ensureCapacity(capacity);

  bool _ensureCapacity(int capacity) {
    if (capacity > length) return bytes.grow(capacity);
    return false;
  }

  /// Grow the buf if the _wIndex is at, or beyond, the end of the current buf.
  bool maybeGrow(int size) {
    if (_wIndex + size < length) return false;
    return bytes.grow(_wIndex + size);
  }

  @override
  String toString() => '$runtimeType($length)[$_wIndex] maxLength: $limit';

  void warn(Object msg) => print('** Warning(@$_wIndex): $msg');

  void error(Object msg) => throw Exception('**** Error(@$_wIndex): $msg');
  // Internal methods

  ByteData get bd => isClosed ? null : bytes.asByteData();

  ByteData close() {
    final bd = bytes.asByteData(0, _wIndex);
    _isClosed = true;
    return bd;
  }

  bool get isClosed => _isClosed;
  bool _isClosed = false;

  void get reset {
    //  _rIndex = 0;
    _wIndex = 0;
    _isClosed = false;
  }
}

abstract class LoggingWriteBufferMixin {
  int get _wIndex;

  /// The current readIndex as a string.
  String get _www => 'W@${_wIndex.toString().padLeft(5, '0')}';
  String get www => _www;

  /// The beginning of reading something.
  String get wbb => '> $_www';

  /// In the middle of reading something.
  String get wmm => '| $_www';

  /// The end of reading something.
  String get wee => '< $_www';

  String get pad => ''.padRight('$_www'.length);

  void warn(Object msg) => print('** Warning: $msg $_www');

  void error(Object msg) => throw Exception('**** Error: $msg $_www');
}
