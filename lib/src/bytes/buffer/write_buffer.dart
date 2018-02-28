// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/src/bytes/buffer/buffer_base.dart';
import 'package:core/src/bytes/bytes.dart';


// ignore_for_file: non_constant_identifier_names
// ignore_for_file: prefer_initializing_formals

class WriteBuffer extends BufferBase {
  @override
  final GrowableBytes bytes;
  @override
  int rIndex_;
  @override
  int wIndex_;

  WriteBuffer(
      [int length = kDefaultLength,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : rIndex_ = 0,
        wIndex_ = 0,
        bytes = new GrowableBytes(length, endian, limit);

  WriteBuffer.from(WriteBuffer wb,
      [int offset = 0,
      int length,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : rIndex_ = offset,
        wIndex_ = offset,
        bytes = new GrowableBytes.from(wb.bytes, offset, length, endian, limit);

  WriteBuffer.fromByteData(ByteData bd,
      [Endian endian = Endian.little, int limit = kDefaultLimit])
      : rIndex_ = 0,
        wIndex_ = bd.lengthInBytes,
        bytes = new GrowableBytes.fromTypedData(bd, endian, limit);

  WriteBuffer.fromUint8List(Uint8List uint8List,
      [Endian endian = Endian.little, int limit = kDefaultLimit])
      : rIndex_ = 0,
        wIndex_ = uint8List.lengthInBytes,
        bytes = new GrowableBytes.fromTypedData(uint8List, endian, limit);

  WriteBuffer._(int length, Endian endian, int limit)
      : rIndex_ = 0,
        wIndex_ = 0,
        bytes = new GrowableBytes(length, endian, limit);

  WriteBuffer._fromTD(TypedData td, Endian endian, int limit)
      : rIndex_ = 0,
        wIndex_ = td.lengthInBytes,
        bytes = new GrowableBytes.fromTypedData(td, endian, limit);

  // **** WriteBuffer specific Getters and Methods

  @override
  ByteData get bd => (isClosed) ? null : bytes.bd;

  int get index => wIndex_;
  @override
  Endian get endian => bytes.endian;
  int get limit => bytes.limit;

  /// Returns the number of bytes left in the current _this_.
  int get remaining => wRemaining;

  @override
  bool get isEmpty => isNotWritable;

  bool hasRemaining(int n) => wHasRemaining(n);

  @override
  bool wHasRemaining(int n) => (wIndex_ + n) <= bytes.lengthInBytes;

  void setInt8(int n) => bytes.setInt8(wIndex_, n);

  void writeInt8(int n) {
    assert(n >= -128 && n <= 127, 'Value out of range: $n');
    _maybeGrow(1);
    bytes.setInt8(wIndex_, n);
    wIndex_++;
  }

  void setInt16(int n) => bytes.setInt16(wIndex_, n);

  /// Writes a 16-bit unsigned integer (Uint16) value to _this_.
  void writeInt16(int value) {
    assert(
    value >= -0x7FFF && value <= 0x7FFF - 1, 'Value out of range: $value');
    _maybeGrow(2);
    bytes.setInt16(wIndex_, value);
    wIndex_ += 2;
  }

  void setInt32(int n) => bytes.setInt32(wIndex_, n);

  /// Writes a 32-bit unsigned integer (Uint32) value to _this_.
  void writeInt32(int value) {
    assert(value >= -0x7FFFFFFF && value <= 0x7FFFFFFF - 1,
    'Value out if range: $value');
    _maybeGrow(4);
    bytes.setInt32(wIndex_, value);
    wIndex_ += 4;
  }

  void setInt64(int n) => bytes.setInt64(wIndex_, n);

  /// Writes a 64-bit unsigned integer (Uint32) value to _this_.
  void writeInt64(int value) {
    assert(value >= -0x7FFFFFFFFFFFFFFF && value <= 0x7FFFFFFFFFFFFFFF - 1,
    'Value out of range: $value');
    _maybeGrow(8);
    bytes.setInt64(wIndex_, value);
    wIndex_ += 8;
  }

  void setUint8(int n) => bytes.setUint8(wIndex_, n);

  /// Writes a byte (Uint8) value to _this_.
  void writeUint8(int value) {
    assert(value >= 0 && value <= 255, 'Value out of range: $value');
    _maybeGrow(1);
    bytes.setUint8(wIndex_, value);
    wIndex_++;
  }

  void setUint16(int n) => bytes.setUint16(wIndex_, n);

  /// Writes a 16-bit unsigned integer (Uint16) value to _this_.
  void writeUint16(int value) {
    assert(value >= 0 && value <= 0xFFFF, 'Value out of range: $value');
    _maybeGrow(2);
    bytes.setUint16(wIndex_, value);
    wIndex_ += 2;
  }

  void setUint32(int n) => bytes.setUint32(wIndex_, n);

  /// Writes a 32-bit unsigned integer (Uint32) value to _this_.
  void writeUint32(int value) {
    assert(value >= 0 && value <= 0xFFFFFFFF, 'Value out if range: $value');
    _maybeGrow(4);
    bytes.setUint32(wIndex_, value);
    wIndex_ += 4;
  }

  void setUint64(int n) => bytes.setUint64(wIndex_, n);

  /// Writes a 64-bit unsigned integer (Uint32) value to _this_.
  void writeUint64(int value) {
    assert(value >= 0 && value <= 0xFFFFFFFFFFFFFFFF,
    'Value out of range: $value');
    _maybeGrow(8);
    bytes.setUint64(wIndex_, value);
    wIndex_ += 8;
  }

  void writeAscii(String s) => writeUint8List(ASCII.encode(s));

  void writeUtf8(String s) => writeUint8List(UTF8.encode(s));

  /// Writes [bytes] to _this_.
  void writeUint8List(Uint8List bytes) => write(bytes);

  /// Writes [bd] to _this_.
  void writeByteData(ByteData bd) => write(bd);

  /// Writes [td] to _this_.
  void write(TypedData td) {
    final offset = td.offsetInBytes;
    final length = td.lengthInBytes;
    final uint8List = (td is Uint8List) ? td : td.buffer.asUint8List(offset, length);
    _maybeGrow(length);
    for (var i = 0, j = wIndex_; i < length; i++, j++)
      bytes[j] = uint8List[i];
    wIndex_ += length;
  }

  /// Writes [length] zeros to _this_.
  bool writeZeros(int length) {
    _maybeGrow(length);
    for (var i = 0, j = wIndex_; i < length; i++, j++) bytes[j] = 0;
    wIndex_ += length;
    return true;
  }

  /// Write a DICOM Tag Code to _this_.
  void writeCode(int code) {
    const kItem = 0xfffee000;
    assert(code >= 0 && code < kItem, 'Value out of range: $code');
    assert(wIndex_.isEven && wHasRemaining(4));
    _maybeGrow(4);
    bytes
      ..setUint16(wIndex_, code >> 16)
      ..setUint16(wIndex_ + 2, code & 0xFFFF);
    wIndex_ += 4;
  }

  /// Ensures that [bytes] has at least [remaining] writable bytes.
  /// The [bytes] is grows if necessary, and copies existing bytes into
  /// the new [bytes].
  bool ensureRemaining(int remaining) => ensureCapacity(wIndex_ + remaining);

  //Urgent: move to write and read)_write_buf
  /// Ensures that [bytes] is at least [capacity] long, and grows
  /// the buf if necessary, preserving existing data.
  bool ensureCapacity(int capacity) =>
      (capacity > lengthInBytes) ? grow() : false;

  bool grow([int capacity]) => bytes.grow(capacity);

  /// Grow the buf if the _wIndex_ is at, or beyond, the end of the current buf.
  bool _maybeGrow([int size = 1]) =>
      (wIndex_ + size < lengthInBytes) ? false : grow(wIndex_ + size);

  bool  _isClosed = false;
  /// Returns _true_ if _this_ is no longer writable.
  bool get isClosed => (_isClosed == null) ? false : true;

  ByteData close() {
    if (hadTrailingBytes)
      _hadTrailingZeros = bytes.checkAllZeros(wIndex_, bytes.lengthInBytes);
    final bd = bytes.asByteData(0, wIndex_);
    _isClosed = true;
    return bd;
  }

  /// Returns _true_ if this reader [isClosed] and it [isNotEmpty].
  bool get hadTrailingBytes => (_isClosed) ? isNotEmpty : false;
  bool _hadTrailingZeros = false;

  bool get hadTrailingZeros => _hadTrailingZeros ?? false;
  ByteData rClose() {
    final view = asByteData(0, rIndex_);
    if (isNotEmpty) {
      //  warn('End of Data with rIndex_($rIndex) != length(${view.lengthInBytes})');
      _hadTrailingZeros = checkAllZeros(rIndex_, wIndex_);
    }
    _isClosed = true;
    return view;
  }

  void get reset {
    rIndex_ = 0;
    wIndex_ = 0;
    _isClosed = false;
    _hadTrailingZeros = false;
  }

  @override
  String toString() => '$runtimeType($length)[$wIndex_] maxLength: $limit';

  // Internal methods

  static const int kDefaultLength = 4096;
}

const int _k1GB = 1024 * 1024 * 1024;

class LoggingWriteBuffer extends WriteBuffer {
  LoggingWriteBuffer(
      [int length = kDefaultLength,
      Endian endian = Endian.little,
      int limit = _k1GB])
      : super._(length, endian, limit);

  factory LoggingWriteBuffer.fromByteData(ByteData bd,
          [Endian endian = Endian.little, int limit = kDefaultLimit]) =>
      new LoggingWriteBuffer.fromTypedData(bd, endian, limit);

  factory LoggingWriteBuffer.fromBytes(Uint8List td,
          [Endian endian = Endian.little, int limit = kDefaultLimit]) =>
      new LoggingWriteBuffer.fromTypedData(td, endian, limit);

  LoggingWriteBuffer.fromTypedData(TypedData td, Endian endian, int limit)
      : super._fromTD(td, endian, limit);

  /// The current readIndex as a string.
  String get _www => 'W@${wIndex.toString().padLeft(5, '0')}';
  String get www => _www;

  /// The beginning of reading something.
  String get wbb => '> $_www';

  /// In the middle of reading something.
  String get wmm => '| $_www';

  /// The end of reading something.
  String get wee => '< $_www';

  String get pad => ''.padRight('$_www'.length);

  void warn(Object msg) => print('** Warning: $msg $_www');

  void error(Object msg) => throw new Exception('**** Error: $msg $_www');

}