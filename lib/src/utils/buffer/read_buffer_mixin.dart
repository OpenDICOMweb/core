//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
/*
import 'dart:typed_data';

import 'package:core/src/utils/bytes.dart';
*/

part of odw.sdk.core.buffer;

// ignore_for_file: public_member_api_docs

abstract class ReadBufferMixin {
  Bytes get _bytes;
  int get _rIndex;
  set _rIndex(int n);

  int get _wIndex;
  set _wIndex(int n);

  ByteData asByteData([int offset, int length]);
  void rError(Object msg);

  // End of Interface

  ByteBuffer get buffer => _bytes.buffer;

  int get readIndex => _rIndex;
  int get writeIndex => _wIndex;

  bool get isWritable => false;
  int get writeRemaining => 0;
  int get writeRemainingMax => 0;

  // *** Reader specific Getters and Methods

  int get length => _bytes.length;

  int get index => _rIndex;
  set index(int v) => _rIndex = v;

  int get remaining => _wIndex - _rIndex;
  int get readRemaining => remaining;
  bool get isReadable => remaining > 0;
  bool get isEmpty => remaining <= 0;
  bool get isNotEmpty => !isEmpty;

  bool hasRemaining(int n) {
    assert(n >= 0);
    return remaining >= 0;
  }

/* Urgent Jim: flush later
  int get _rIndex;
  set _rIndex(int n) {
    if (_rIndex < 0 || _rIndex > _wIndex)
      throw RangeError.range(_rIndex, 0, length);
    _rIndex = n;
  }
*/

  int rSkip(int n) {
    final v = _rIndex + n;
    if (v < 0 || v > _wIndex) throw RangeError.range(v, 0, _wIndex);
    return _rIndex = v;
  }

  int getInt8() => _bytes.getInt8(_rIndex);

  int readInt8() {
    final v = _bytes.getInt8(_rIndex);
    _rIndex++;
    return v;
  }

  int getInt16() => _bytes.getInt16(_rIndex);

  int readInt16() {
    final v = _bytes.getInt16(_rIndex);
    _rIndex += 2;
    return v;
  }

  int getInt32() => _bytes.getInt32(_rIndex);

  int readInt32() {
    final v = _bytes.getInt32(_rIndex);
    _rIndex += 4;
    return v;
  }

  int getInt64() => _bytes.getInt64(_rIndex);

  int readInt64() {
    final v = _bytes.getInt64(_rIndex);
    _rIndex += 8;
    return v;
  }

  int getUint8() => _bytes.getUint8(_rIndex);

  int readUint8() {
    final v = _bytes.getUint8(_rIndex);
    _rIndex++;
    return v;
  }

  int getUint16() => _bytes.getUint16(_rIndex);

  int readUint16() {
    final v = _bytes.getUint16(_rIndex);
    _rIndex += 2;
    return v;
  }

  int getUint32() => _bytes.getUint32(_rIndex);

  int readUint32() {
    final v = _bytes.getUint32(_rIndex);
    _rIndex += 4;
    return v;
  }

  int getUint64() => _bytes.getUint64(_rIndex);

  int readUint64() {
    final v = _bytes.getUint64(_rIndex);
    _rIndex += 8;
    return v;
  }

  double getFloat32() => _bytes.getFloat32(_rIndex);

  double readFloat32() {
    final v = _bytes.getFloat32(_rIndex);
    _rIndex += 4;
    return v;
  }

  double getFloat64() => _bytes.getFloat64(_rIndex);

  double readFloat64() {
    final v = _bytes.getFloat64(_rIndex);
    _rIndex += 8;
    return v;
  }

  String getAscii(int length) =>
      _bytes.getAscii(offset: _rIndex, length: length);

  String readAscii(int length) {
    final s = getAscii(length);
    _rIndex += length;
    return s;
  }

  String getUtf8(int length) => _bytes.getUtf8(offset: _rIndex, length: length);

  String readUtf8(int length) {
    final s = getUtf8(length);
    _rIndex += length;
    return s;
  }

  String readString(int length) => readUtf8(length);

  bool getUint32AndCompare(int target) {
    final delimiter = _bytes.getUint32(_rIndex);
    final v = target == delimiter;
    return v;
  }

  ByteData bdView([int start = 0, int end]) {
    end ??= _rIndex;
    final length = end - start;
    //   final offset = _getOffset(start, length);
    return _bytes.asByteData(start, length);
  }

  Uint8List uint8View([int start = 0, int length]) {
    final offset = _getOffset(start, length);
    return _bytes.asUint8List(offset, length ?? length - offset);
  }

  Uint8List readUint8View(int length) => uint8View(_rIndex, length);

  Int8List readInt8List(int length) {
    final v = _bytes.getInt8List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Int16List readInt16List(int length) {
    final v = _bytes.getInt16List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Int32List readInt32List(int length) {
    final v = _bytes.getInt32List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Int64List readInt64List(int length) {
    final v = _bytes.getInt64List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Uint8List readUint8List(int length) {
    final v = _bytes.getUint8List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Uint16List readUint16List(int length) {
    final v = _bytes.getUint16List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Uint32List readUint32List(int length) {
    final v = _bytes.getUint32List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Uint64List readUint64List(int length) {
    final v = _bytes.getUint64List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Float32List readFloat32List(int length) {
    final v = _bytes.getFloat32List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Float64List readFloat64List(int length) {
    final v = _bytes.getFloat64List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  List<String> readAsciiList(int length) {
    final v = _bytes.getAsciiList(
        offset: _rIndex, length: length, allowInvalid: true);
    _rIndex += length;
    return v;
  }

  List<String> readUtf8List(int length) {
    final v = _bytes.getUtf8List(
        offset: _rIndex, length: length, allowMalformed: true);
    _rIndex += length;
    return v;
  }

  List<String> readStringList(int length) => readUtf8List(length);

  int _getOffset(int start, int length) {
    final offset = _bytes.offset + start;
    assert(offset >= 0 && offset <= length);
    assert(offset + length >= offset && (offset + length) <= length);
    return offset;
  }

  Uint8List get contentsRead =>
      _bytes.buffer.asUint8List(_bytes.offset, _rIndex);
  Uint8List get contentsUnread => _bytes.buffer.asUint8List(_rIndex, _wIndex);

  Uint8List get contentsWritten => _bytes.buffer.asUint8List(_rIndex, _wIndex);

  @override
  String toString() => '$runtimeType: @R$_rIndex @W$_wIndex $_bytes';

  /// The underlying [ByteData]
  ByteData get bd => isClosed ? null : buffer.asByteData();

  /// Returns _true_ if this reader isClosed and it [isNotEmpty].
  bool get hadTrailingBytes {
    if (_isClosed) return isEmpty;
    return false;
  }

  bool _hadTrailingZeros = false;

  bool _isClosed = false;

  /// Returns _true_ if _this_ is no longer writable.
  bool get isClosed => _isClosed != null;

  ByteData close() {
    if (hadTrailingBytes)
      _hadTrailingZeros = _checkAllZeros(_wIndex, _bytes.length);
    final bd = buffer.asByteData(0, _wIndex);
    _isClosed = true;
    return bd;
  }

  bool get hadTrailingZeros => _hadTrailingZeros ?? false;
  ByteData rClose() {
    final view = asByteData(0, _rIndex);
    if (isNotEmpty) {
      rError('End of Data with rIndex($_rIndex) != '
          'length(${view.lengthInBytes})');
      _hadTrailingZeros = _checkAllZeros(_rIndex, _wIndex);
    }
    _isClosed = true;
    return view;
  }

  bool _checkAllZeros(int start, int end) {
    for (var i = start; i < end; i++)
      if (_bytes.getUint8(i) != 0) return false;
    return true;
  }

  void get reset {
    _rIndex = 0;
    _isClosed = false;
    _hadTrailingZeros = false;
  }
}
