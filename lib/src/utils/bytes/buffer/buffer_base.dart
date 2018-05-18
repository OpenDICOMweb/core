//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/src/utils/bytes/bytes.dart';

// ignore_for_file: non_constant_identifier_names,
// ignore_for_file: prefer_initializing_formals

class Buffer {
  Bytes _buffer;
  int _rIndex;
  int _wIndex;

  Buffer(this._buffer, this._rIndex, this._wIndex);

  Buffer.from(Buffer bb, [int offset, int length, Endian endian])
      : _rIndex = offset ?? bb.rIndex,
        _wIndex = length ?? bb.wIndex,
        _buffer = new Bytes.from(bb.buffer, offset ?? bb.buffer.offset,
            length ?? bb.buffer.length, endian ?? Endian.little);

  Buffer.fromByteData(ByteData bd, [int offset = 0, int length, Endian endian])
      : _rIndex = offset ?? 0,
        _wIndex = length ?? bd.lengthInBytes,
        _buffer = new Bytes.typedDataView(
            bd, offset, length ?? bd.lengthInBytes, endian ?? Endian.little);

  Buffer.fromList(List<int> list, [int offset = 0, int length, Endian endian])
      : _rIndex = 0,
        _wIndex = list.length,
        _buffer = new Bytes.typedDataView(new Uint8List.fromList(list), offset,
            length ?? list.length, endian ?? Endian.host);

  Buffer.fromTypedData(TypedData td,
      [int offset = 0, int length, Endian endian])
      : _rIndex = offset ?? 0,
        _wIndex = length ?? td.lengthInBytes,
        _buffer = new Bytes.typedDataView(
            td, offset, length ?? td.lengthInBytes, endian ?? Endian.little);

  /// The underlying data buffer.
  ///
  /// This is always both a List<E> and a TypedData, which we don't have a type
  /// for here. For example, for a `Uint8Buffer`, this is a `Uint8List`.
//  set _rIndex(int position);

//  set _wIndex(int position);
  bool get rIsEmpty => isNotReadable;

  // **** End of Interface

  Bytes get buffer => _buffer;
  ByteData get bd => _buffer.bd;

  Endian get endian => _buffer.endian;

  int get offsetInBytes => _buffer.offset;
  int get start => _buffer.offset;
  int get length => _buffer.length;
  int get lengthInBytes => _buffer.length;
  int get end => start + lengthInBytes;

  int get rRemaining => _wIndex - _rIndex;

  /// Returns the number of writeable bytes left in _this_.
  int get wRemaining => end - _wIndex;

  bool get isReadable => rRemaining > 0;
  bool get isNotReadable => !isReadable;
  bool get isWritable => wRemaining > 0;
  bool get isNotWritable => !isWritable;

  bool get isEmpty => buffer.isEmpty;
  bool get isNotEmpty => !isEmpty;

  /// Return a new Big Endian[ReadBuffer] containing the unread
  /// portion of _this_.
  Buffer get asBigEndian => new Buffer.from(this, rIndex, wIndex, Endian.big);

  /// Return a new Little Endian[ReadBuffer] containing the unread
  /// portion of _this_.
  Buffer get asLittleEndian =>
      new Buffer.from(this, rIndex, wIndex, Endian.little);

  void get rReset {
    _rIndex = 0;
    _wIndex = _buffer.length;
    _isClosed = false;
    _hadTrailingZeros = false;
  }

  bool rHasRemaining(int n) => (_rIndex + n) <= _wIndex;
  bool wHasRemaining(int n) => (_wIndex + n) <= end;

  /// Returns a _view_ of [buffer] containing the bytes from [start] inclusive
  /// to [end] exclusive. If [end] is omitted, the [length] of _this_ is used.
  /// An error occurs if [start] is outside the range 0 .. [length],
  /// or if [end] is outside the range [start] .. [length].
  /// [lengthInBytes].
  Bytes subbytes([int start = 0, int end]) =>
      new Bytes.from(_buffer, start, (end ?? length) - start);

  ByteData toByteData(int offset, int lengthInBytes) =>
      _buffer.buffer.asByteData(buffer.offset + offset, lengthInBytes);

  Uint8List toUint8List(int offset, int lengthInBytes) =>
      buffer.buffer.asUint8List(buffer.offset + offset, lengthInBytes);

  /// Return a view of _this_ of [length], starting at [start]. If [length]
  /// is _null_ it defaults to [lengthInBytes].
  Bytes asBytes([int start = 0, int length]) =>
      _buffer.asBytes(start, length ?? lengthInBytes);

  ByteData asByteData([int offset, int length]) =>
      _buffer.asByteData(offset ?? _rIndex, length ?? _wIndex);

  Uint8List asUint8List([int offset, int length]) =>
      _buffer.asUint8List(offset ?? _rIndex, length ?? _wIndex);

  bool checkAllZeros(int offset, int end) {
    for (var i = offset; i < end; i++)
      if (_buffer.getUint8(i) != 0) return false;
    return true;
  }

  // *** Reader specific Getters and Methods

  int get rIndex => _rIndex;
  set rIndex(int n) {
    if (_rIndex < 0 || _rIndex > _wIndex)
      throw new RangeError.range(rIndex, 0, _wIndex);
    _rIndex = n;
  }

  int rSkip(int n) {
    final v = _rIndex + n;
    if (v < 0 || v > _wIndex) throw new RangeError.range(v, 0, _wIndex);
    return _rIndex = v;
  }

  int getInt8() => _buffer.getInt8(_rIndex);

  int readInt8() {
    final v = _buffer.getInt8(_rIndex);
    _rIndex++;
    return v;
  }

  int getInt16() => _buffer.getInt16(_rIndex);

  int readInt16() {
    final v = _buffer.getInt16(_rIndex);
    _rIndex += 2;
    return v;
  }

  int getInt32() => _buffer.getInt32(_rIndex);

  int readInt32() {
    final v = _buffer.getInt32(_rIndex);
    _rIndex += 4;
    return v;
  }

  int getInt64() => _buffer.getInt64(_rIndex);

  int readInt64() {
    final v = _buffer.getInt64(_rIndex);
    _rIndex += 8;
    return v;
  }

  int getUint8() => _buffer.getUint8(_rIndex);

  int readUint8() {
    final v = _buffer.getUint8(_rIndex);
    _rIndex++;
    return v;
  }

  int getUint16() => _buffer.getUint16(_rIndex);

  int readUint16() {
    final v = _buffer.getUint16(_rIndex);
    _rIndex += 2;
    return v;
  }

  int getUint32() => _buffer.getUint32(_rIndex);

  int readUint32() {
    final v = _buffer.getUint32(_rIndex);
    _rIndex += 4;
    return v;
  }

  int getUint64() => _buffer.getUint64(_rIndex);

  int readUint64() {
    final v = _buffer.getUint64(_rIndex);
    _rIndex += 8;
    return v;
  }

  String readAscii(int length) {
    final s = _buffer.getAscii(offset: _rIndex, length: length);
    _rIndex += length;
    return s;
  }

  String readUtf8(int length) {
    final s = _buffer.getUtf8(offset: _rIndex, length: length);
    _rIndex += length;
    return s;
  }

  String readString(int length) => readUtf8(length);

  bool getUint32AndCompare(int target) {
    final delimiter = _buffer.getUint32(_rIndex);
    final v = target == delimiter;
    return v;
  }

  ByteData bdView([int start = 0, int end]) {
    end ??= _rIndex;
    final length = end - start;
    //   final offset = _getOffset(start, length);
    return _buffer.asByteData(start, length);
  }

  Uint8List uint8View([int start = 0, int length]) {
    final offset = _getOffset(start, length);
    return _buffer.asUint8List(offset, length ?? lengthInBytes - offset);
  }

  Uint8List readUint8View(int length) => uint8View(_rIndex, length);

  Int8List readInt8List(int length) {
    final v = _buffer.getInt8List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Int16List readInt16List(int length) {
    final v = _buffer.getInt16List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Int32List readInt32List(int length) {
    final v = _buffer.getInt32List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Int64List readInt64List(int length) {
    final v = _buffer.getInt64List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Uint8List readUint8List(int length) {
    final v = _buffer.getUint8List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Uint16List readUint16List(int length) {
    final v = _buffer.getUint16List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Uint32List readUint32List(int length) {
    final v = _buffer.getUint32List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Uint64List readUint64List(int length) {
    final v = _buffer.getUint64List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Float32List readFloat32List(int length) {
    final v = _buffer.getFloat32List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Float64List readFloat64List(int length) {
    final v = _buffer.getFloat64List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  List<String> readAsciiList(int length) {
    final v = _buffer.getAsciiList(offset: _rIndex, length: length);
    _rIndex += length;
    return v;
  }

  List<String> readUtf8List(int length) {
    final v = _buffer.getUtf8List(offset: _rIndex, length: length);
    _rIndex += length;
    return v;
  }

  List<String> readStringList(int length) => readUtf8List(length);

  int _getOffset(int start, int length) {
    final offset = _buffer.offset + start;
    assert(offset >= 0 && offset <= lengthInBytes);
    assert(offset + length >= offset && (offset + length) <= lengthInBytes);
    return offset;
  }

  Uint8List get contentsRead =>
      _buffer.buffer.asUint8List(_buffer.offset, _rIndex);
  Uint8List get contentsUnread => _buffer.buffer.asUint8List(_rIndex, _wIndex);

  // *** wIndex
  int get wIndex => _wIndex;
  set wIndex(int n) {
    if (_wIndex <= _rIndex || _wIndex > _buffer.length)
      throw new RangeError.range(_wIndex, _rIndex, _buffer.length);
    _wIndex = n;
  }

  /// Moves the [wIndex] forward/backward. Returns the new [wIndex].
  int wSkip(int n) {
    final v = _wIndex + n;
    if (v <= _rIndex || v >= _buffer.length)
      throw new RangeError.range(v, 0, _buffer.length);
    return _wIndex = v;
  }

  Uint8List get contentsWritten => _buffer.buffer.asUint8List(_rIndex, wIndex);

  @override
  String toString() => '$runtimeType: @R$rIndex @W$wIndex $buffer';

  void _checkRange(int v) {
    final max = lengthInBytes;
    if (v < 0 || v >= max) throw new RangeError.range(v, 0, max);
  }
}
