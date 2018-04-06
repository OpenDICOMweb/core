// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/utils/bytes/buffer/buffer_base.dart';
import 'package:core/src/utils/bytes/bytes.dart';

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: prefer_initializing_formals

class ReadBuffer extends BufferBase {

  /// The underlying data buffer.
  ///
  /// This is always both a List<E> and a TypedData, which we don't have a type
  /// for here. For example, for a `Uint8Buffer`, this is a `Uint8List`.
  @override
  int rIndex_;
  @override
  int wIndex_;

  ReadBuffer(this._buffer)
      : rIndex_ = 0,
        wIndex_ = _buffer.lengthInBytes;

  ReadBuffer.from(ReadBuffer rb,
      [int offset = 0, int length, Endian endian = Endian.little])
      : rIndex_ = offset,
        wIndex_ = offset + (length ?? rb.lengthInBytes),
        _buffer = new Bytes.from(rb.buffer, offset, length, endian);

  ReadBuffer.fromByteData(ByteData bd, [Endian endian = Endian.little])
      :   rIndex_ = 0,
        wIndex_ = bd.lengthInBytes,
        _buffer = new Bytes.fromTypedData(bd, endian);

  ReadBuffer.fromList(List<int> list, [Endian endian = Endian.little])
      : rIndex_ = 0,
        wIndex_ = list.length,
        _buffer = new Bytes.fromTypedData(new Uint8List.fromList(list), endian);

  ReadBuffer.fromTypedData(TypedData td, [Endian endian = Endian.little])
      : rIndex_ = 0,
        wIndex_ = td.lengthInBytes,
        _buffer = new Bytes.fromTypedData(td, endian);

/* Urgent: Jim todo
  ReadBuffer.fromString(String s, [Endian endian])
      : endian = endian ??= Endian.host,
        rIndex_ = 0,
        wIndex_ = td.lengthInBytes,
        bytes = new Bytes.fromTypedData(td, endian);
*/

  /// Return a new Big Endian[ReadBuffer] containing the unread
  /// portion of _this_.
  ReadBuffer get asBigEndian =>
      new ReadBuffer.from(this, rIndex, wIndex, Endian.big);

  /// Return a new Little Endian[ReadBuffer] containing the unread
  /// portion of _this_.
  ReadBuffer get asLittleEndian =>
      new ReadBuffer.from(this, rIndex, wIndex, Endian.little);

  // **** ReadBuffer specific Getters and Methods

  @override
 Bytes get buffer => _buffer;
  Bytes _buffer;
  int get index => rIndex_;

  int get remaining => rRemaining;

  @override
  bool get isEmpty => isNotReadable;

  bool hasRemaining(int n) => rHasRemaining(n);



  int getInt8() => _buffer.getInt8(rIndex_);

  int readInt8() {
    final v = _buffer.getInt8(rIndex_);
    rIndex_++;
    return v;
  }

  int getInt16() => _buffer.getInt16(rIndex_);

  int readInt16() {
    final v = _buffer.getInt16(rIndex_);
    rIndex_ += 2;
    return v;
  }

  int getInt32() => _buffer.getInt32(rIndex_);

  int readInt32() {
    final v = _buffer.getInt32(rIndex_);
    rIndex_ += 4;
    return v;
  }

  int getInt64() => _buffer.getInt64(rIndex_);

  int readInt64() {
    final v = _buffer.getInt64(rIndex_);
    rIndex_ += 8;
    return v;
  }

  int getUint8() => _buffer.getUint8(rIndex_);

  int readUint8() {
    final v = _buffer.getUint8(rIndex_);
    rIndex_++;
    return v;
  }

  int getUint16() => _buffer.getUint16(rIndex_);

  int readUint16() {
    final v = _buffer.getUint16(rIndex_);
    rIndex_ += 2;
    return v;
  }

  int getUint32() => _buffer.getUint32(rIndex_);

  int readUint32() {
    final v = _buffer.getUint32(rIndex_);
    rIndex_ += 4;
    return v;
  }

  int getUint64() => _buffer.getUint64(rIndex_);

  int readUint64() {
    final v = _buffer.getUint64(rIndex_);
    rIndex_ += 8;
    return v;
  }

  String readAscii(int length) {
    final s = _buffer.getAscii(rIndex_, length);
    rIndex_ += length;
    return s;
  }
  String readUtf8(int length) {
    final s = _buffer.getUtf8(rIndex_, length);
    rIndex_ += length;
    return s;
  }

  String readString(int length) => readUtf8(length);

  /// Peek at next tag - doesn't move the [rIndex_].
  int peekCode() {
    assert(rIndex_.isEven && hasRemaining(4), '@$rIndex_ : $remaining');
    final group = _buffer.getUint16(rIndex_);
    final elt = _buffer.getUint16(rIndex_ + 2);
    return (group << 16) + elt;
  }

  int getCode(int start) => peekCode();

  int readCode() {
    final code = peekCode();
    rIndex_ += 4;
    return code;
  }

  bool getUint32AndCompare(int target) {
    final delimiter = _buffer.getUint32(rIndex_);
    final v = target == delimiter;
    return v;
  }

  ByteData bdView([int start = 0, int end]) {
    end ??= rIndex_;
    final length = end - start;
    //   final offset = _getOffset(start, length);
    return _buffer.asByteData(start, length);
  }

  Uint8List uint8View([int start = 0, int length]) {
    final offset = _getOffset(start, length);
    return _buffer.asUint8List(offset, length ?? lengthInBytes - offset);
  }

  Uint8List readUint8View(int length) => uint8View(rIndex_, length);

  Int8List readInt8List(int length) {
    final v = _buffer.getInt8List(rIndex_, length);
    rIndex_ += length;
    return v;
  }

  Int16List readInt16List(int length) {
    final v = _buffer.getInt16List(rIndex_, length);
    rIndex_ += length;
    return v;
  }

  Int32List readInt32List(int length) {
    final v = _buffer.getInt32List(rIndex_, length);
    rIndex_ += length;
    return v;
  }

  Int64List readInt64List(int length) {
    final v = _buffer.getInt64List(rIndex_, length);
    rIndex_ += length;
    return v;
  }

  Uint8List readUint8List(int length) {
    final v = _buffer.getUint8List(rIndex_, length);
    rIndex_ += length;
    return v;
  }

  Uint16List readUint16List(int length) {
    final v = _buffer.getUint16List(rIndex_, length);
    rIndex_ += length;
    return v;
  }

  Uint32List readUint32List(int length) {
    final v = _buffer.getUint32List(rIndex_, length);
    rIndex_ += length;
    return v;
  }

  Uint64List readUint64List(int length) {
    final v = _buffer.getUint64List(rIndex_, length);
    rIndex_ += length;
    return v;
  }

  Float32List readFloat32List(int length) {
    final v = _buffer.getFloat32List(rIndex_, length);
    rIndex_ += length;
    return v;
  }

  Float64List readFloat64List(int length) {
    final v = _buffer.getFloat64List(rIndex_, length);
    rIndex_ += length;
    return v;
  }

  List<String> readAsciiList(int length) {
    final v = _buffer.asAsciiList(rIndex_, length);
    rIndex_ += length;
    return v;
  }

  List<String> readUtf8List(int length) {
    final v = _buffer.asUtf8List(rIndex_, length);
    rIndex_ += length;
    return v;
  }

  List<String> readStringList(int length) =>
      readUtf8List(length);

  int _getOffset(int start, int length) {
    final offset = _buffer.offsetInBytes + start;
    assert(offset >= 0 && offset <= lengthInBytes);
    assert(offset + length >= offset && (offset + length) <= lengthInBytes);
    return offset;
  }

  ByteData toByteData(int offset, int lengthInBytes) =>
      _buffer.buffer.asByteData(buffer.offsetInBytes + offset, lengthInBytes);

  Uint8List toUint8List(int offset, int lengthInBytes) =>
      buffer.buffer.asUint8List(buffer.offsetInBytes + offset, lengthInBytes);

  void checkRange(int v) {
    final max = lengthInBytes;
    if (v < 0 || v >= max) throw new RangeError.range(v, 0, max);
  }

  bool _isClosed = false;
  bool get isClosed => _isClosed;

  @override
  ByteData get bd => (isClosed) ? null : _buffer.bd;

  /// Returns _true_ if this reader [isClosed] and it [isNotEmpty].
  bool get hadTrailingBytes => (isClosed) ? isNotEmpty : false;
  bool _hadTrailingZeros;
  bool get hadTrailingZeros => _hadTrailingZeros ?? false;

  void get reset {
    rIndex_ = 0;
    wIndex_ = 0;
    _isClosed = false;
    _hadTrailingZeros = false;
  }
}

class LoggingReadBuffer extends ReadBuffer {
  factory LoggingReadBuffer(ByteData bd,
          [int offset = 0, int length, Endian endian = Endian.little]) =>
      new LoggingReadBuffer._(bd.buffer.asByteData(offset, length), endian);

  factory LoggingReadBuffer.fromUint8List(Uint8List bytes,
      [int offset = 0, int length, Endian endian = Endian.little]) {
    final bd = bytes.buffer.asByteData(offset, length);
    return new LoggingReadBuffer._(bd, endian);
  }

  LoggingReadBuffer._(TypedData td, Endian endian)
      : super.fromTypedData(td.buffer.asByteData(), endian);

  /// The current readIndex as a string.
  String get _rrr => 'R@${rIndex_.toString().padLeft(5, '0')}';
  String get rrr => _rrr;

  /// The beginning of reading something.
  String get rbb => '> $_rrr';

  /// In the middle of reading something.
  String get rmm => '| $_rrr';

  /// The end of reading something.
  String get ree => '< $_rrr';

  String get pad => ''.padRight('$_rrr'.length);

  void warn(Object msg) => print('** Warning: $msg $_rrr');

  void error(Object msg) => throw new Exception('**** Error: $msg $_rrr');
}
