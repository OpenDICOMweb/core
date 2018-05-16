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

import 'package:core/src/element/base.dart';
import 'package:core/src/utils/bytes/buffer/buffer_base.dart';
import 'package:core/src/utils/bytes/bytes.dart';

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: prefer_initializing_formals

class WriteBuffer extends BufferBase {
  @override
  final GrowableBytes buffer;
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
        buffer = new GrowableBytes(length, endian, limit);

  WriteBuffer.from(WriteBuffer wb,
      [int offset = 0,
      int length,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : rIndex_ = offset,
        wIndex_ = offset,
        buffer =
            new GrowableBytes.from(wb.buffer, offset, length, endian, limit);

  WriteBuffer.fromByteData(ByteData bd,
      [Endian endian = Endian.little, int limit = kDefaultLimit])
      : rIndex_ = 0,
        wIndex_ = bd.lengthInBytes,
        buffer = new GrowableBytes.fromTypedData(bd, endian, limit);

  WriteBuffer.fromUint8List(Uint8List uint8List,
      [Endian endian = Endian.little, int limit = kDefaultLimit])
      : rIndex_ = 0,
        wIndex_ = uint8List.lengthInBytes,
        buffer = new GrowableBytes.fromTypedData(uint8List, endian, limit);

  WriteBuffer._(int length, Endian endian, int limit)
      : rIndex_ = 0,
        wIndex_ = 0,
        buffer = new GrowableBytes(length, endian, limit);

  WriteBuffer._fromTD(TypedData td, Endian endian, int limit)
      : rIndex_ = 0,
        wIndex_ = td.lengthInBytes,
        buffer = new GrowableBytes.fromTypedData(td, endian, limit);

  // **** WriteBuffer specific Getters and Methods

  @override
  ByteData get bd => (isClosed) ? null : buffer.asByteData();

  int get index => wIndex_;
  @override
  Endian get endian => buffer.endian;
  int get limit => buffer.limit;

  /// Returns the number of bytes left in the current _this_.
  int get remaining => wRemaining;

  @override
  bool get isEmpty => isNotWritable;

  bool hasRemaining(int n) => wHasRemaining(n);

  @override
  bool wHasRemaining(int n) => (wIndex_ + n) <= buffer.lengthInBytes;

  void write(Bytes bList, [int offset = 0, int length]) {
    length ??= bList.length;
    ensureRemaining(length + 1);
    for (var i = offset, j = wIndex_; i < length; i++, j++)
      buffer.setUint8(j, bList[i]);
    wIndex_ += length;
  }

  void setInt8(int n) => buffer.setInt8(wIndex_, n);

  void writeInt8(int n) {
    assert(n >= -128 && n <= 127, 'Value out of range: $n');
    _maybeGrow(1);
    buffer.setInt8(wIndex_, n);
    wIndex_++;
  }

  void setInt16(int n) => buffer.setInt16(wIndex_, n);

  /// Writes a 16-bit unsigned integer (Uint16) value to _this_.
  void writeInt16(int value) {
    assert(
        value >= -0x7FFF && value <= 0x7FFF - 1, 'Value out of range: $value');
    _maybeGrow(2);
    buffer.setInt16(wIndex_, value);
    wIndex_ += 2;
  }

  void setInt32(int n) => buffer.setInt32(wIndex_, n);

  /// Writes a 32-bit unsigned integer (Uint32) value to _this_.
  void writeInt32(int value) {
    assert(value >= -0x7FFFFFFF && value <= 0x7FFFFFFF - 1,
        'Value out if range: $value');
    _maybeGrow(4);
    buffer.setInt32(wIndex_, value);
    wIndex_ += 4;
  }

  void setInt64(int n) => buffer.setInt64(wIndex_, n);

  /// Writes a 64-bit unsigned integer (Uint32) value to _this_.
  void writeInt64(int value) {
    assert(value >= -0x7FFFFFFFFFFFFFFF && value <= 0x7FFFFFFFFFFFFFFF - 1,
        'Value out of range: $value');
    _maybeGrow(8);
    buffer.setInt64(wIndex_, value);
    wIndex_ += 8;
  }

  void setUint8(int n) => buffer.setUint8(wIndex_, n);

  /// Writes a byte (Uint8) value to _this_.
  void writeUint8(int value) {
    assert(value >= 0 && value <= 255, 'Value out of range: $value');
    _maybeGrow(1);
    buffer.setUint8(wIndex_, value);
    wIndex_++;
  }

  void setUint16(int n) => buffer.setUint16(wIndex_, n);

  /// Writes a 16-bit unsigned integer (Uint16) value to _this_.
  void writeUint16(int value) {
    assert(value >= 0 && value <= 0xFFFF, 'Value out of range: $value');
    _maybeGrow(2);
    buffer.setUint16(wIndex_, value);
    wIndex_ += 2;
  }

  void setUint32(int n) => buffer.setUint32(wIndex_, n);

  /// Writes a 32-bit unsigned integer (Uint32) value to _this_.
  void writeUint32(int value) {
    assert(value >= 0 && value <= 0xFFFFFFFF, 'Value out if range: $value');
    _maybeGrow(4);
    buffer.setUint32(wIndex_, value);
    wIndex_ += 4;
  }

  void setUint64(int n) => buffer.setUint64(wIndex_, n);

  /// Writes a 64-bit unsigned integer (Uint32) value to _this_.
  void writeUint64(int value) {
      assert(value >= 0 &&
             value <= 0xFFFFFFFFFFFFFFFF, 'Value out of range: $value');
    _maybeGrow(8);
    buffer.setUint64(wIndex_, value);
    wIndex_ += 8;
  }

  void writeAscii(String s) => writeUint8List(cvt.ascii.encode(s));

  void writeUtf8(String s) => writeUint8List(cvt.utf8.encode(s));

  void writeString(String s) => writeUtf8(s);

  /// Writes [length] zeros to _this_.
  bool writeZeros(int length) {
    _maybeGrow(length);
    for (var i = 0, j = wIndex_; i < length; i++, j++) buffer[j] = 0;
    wIndex_ += length;
    return true;
  }

  // Urgent Jim: move to system
  bool allowInvalidTagCode = true;
  /// Write a DICOM Tag Code to _this_.
  void writeCode(int code) {
    if (!allowInvalidTagCode) {
      assert(code >= 0x00020000 && code <= kSequenceDelimitationItem,
      'Value out of range: $code (${dcm(code)})');
    }
    assert(wIndex_.isEven);
    _maybeGrow(4);
    buffer
      ..setUint16(wIndex_, code >> 16)
      ..setUint16(wIndex_ + 2, code & 0xFFFF);
    wIndex_ += 4;
  }

  void writeInt8List(Int8List list) {
    buffer.setInt8List(list, wIndex_, list.length);
    wIndex_ += list.length;
  }

  void writeInt16List(Int16List list) {
    buffer.setInt16List(list, wIndex_, list.length);
    wIndex_ += (list.length * 2);
  }

  void writeInt32List(Int32List list) {
    buffer.setInt32List(list, wIndex_, list.length);
    wIndex_ += (list.length * 4);
  }

  void writeInt64List(Int64List list) {
    buffer.setInt64List(list, wIndex_, list.length);
    wIndex_ += (list.length * 8);
  }

  void writeUint8List(Uint8List bList) {
    if (bList.lengthInBytes == 0) return;
    writeByteData(bList.buffer.asByteData(bList.offsetInBytes, bList.length));
  }

  void writeByteData(ByteData bd) {
    final length = bd.lengthInBytes;
    if (length == 0) return;
    ensureRemaining(length);
    buffer.setByteData(bd.buffer.asByteData(), wIndex_, length);
    wIndex_ += length;
  }

  void writeUint16List(Uint16List list) {
    buffer.setUint16List(list, wIndex_, list.length);
    wIndex_ += (list.length * 2);
  }

  void writeUint32List(Uint32List list) {
    buffer.setUint32List(list, wIndex_, list.length);
    wIndex_ += (list.length * 4);
  }

  void writeUint64List(Uint64List list) {
    buffer.setUint64List(list, wIndex_, list.length);
    wIndex_ += (list.length * 8);
  }

  void writeFloat32List(Float32List list) {
    buffer.setFloat32List(list, wIndex_, list.length);
    wIndex_ += (list.length * 4);
  }

  void writeFloat64List(Float64List list) {
    buffer.setFloat64List(list, wIndex_, list.length);
    wIndex_ += (list.length * 8);
  }

  void writeAsciiList(List<String> list) =>
      wIndex_ += buffer.setAsciiList(list, wIndex_, list.length);

  void writeUtf8List(List<String> list) =>
      wIndex_ += buffer.setUtf8List(list, wIndex_, list.length);

  void writeStringList(List<String> list) => writeUtf8List(list);

  /// Ensures that [buffer] has at least [remaining] writable bytes.
  /// The [buffer] is grows if necessary, and copies existing bytes into
  /// the new [buffer].
  bool ensureRemaining(int remaining) => ensureCapacity(wIndex_ + remaining);

  // Urgent: move to write and read_write_buf
  /// Ensures that [buffer] is at least [capacity] long, and grows
  /// the buf if necessary, preserving existing data.
  bool ensureCapacity(int capacity) =>
      (capacity > lengthInBytes) ? grow(capacity) : false;

  bool grow([int capacity]) => buffer.grow(capacity);

  /// Grow the buf if the _wIndex_ is at, or beyond, the end of the current buf.
  bool _maybeGrow([int size = 1]) =>
      (wIndex_ + size < lengthInBytes) ? false : grow(wIndex_ + size);

  bool _isClosed = false;

  /// Returns _true_ if _this_ is no longer writable.
  bool get isClosed => (_isClosed == null) ? false : true;

  ByteData close() {
    if (hadTrailingBytes)
      _hadTrailingZeros = buffer.checkAllZeros(wIndex_, buffer.lengthInBytes);
    final bd = buffer.asByteData(0, wIndex_);
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
      error('End of Data with rIndex_($rIndex) != '
          'length(${view.lengthInBytes})');
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

  void warn(Object msg) => print('** Warning(@$wIndex_): $msg');

  void error(Object msg) => throw new Exception('**** Error(@$wIndex_): $msg');
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

  @override
  void warn(Object msg) => print('** Warning: $msg $_www');

  @override
  void error(Object msg) => throw new Exception('**** Error: $msg $_www');
}
