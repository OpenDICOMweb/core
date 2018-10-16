//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/utils/bytes.dart';

// ignore_for_file: non_constant_identifier_names,
// ignore_for_file: prefer_initializing_formals
// ignore_for_file: public_member_api_docs

abstract class ReadBufferMixin {
  Bytes get buffer;
  int get rIndex;
  set rIndex(int n);

  int get wIndex;
  set wIndex(int n);

  bool _checkAllZeros(int wIndex, int length);
  ByteData asByteData([int offset, int length]);
  void rError(Object msg);

  // End of Interface
  int get readIndex => rIndex;
  int get writeIndex => wIndex;

  bool get isWritable => false;
  int get writeRemaining => 0;
  int get writeRemainingMax => 0;

  // *** Reader specific Getters and Methods

  int get length => buffer.length;

  int get index => rIndex;
  set index(int v) => rIndex = v;

  int get remaining => wIndex - rIndex;
  int get readRemaining => remaining;
  bool get isReadable => remaining > 0;
  bool get isEmpty => remaining <= 0;
  bool get isNotEmpty => !isEmpty;

  bool hasRemaining(int n) {
    assert(n >= 0);
    return remaining >= 0;
  }

/* Urgent Jim: flush later
  int get rIndex;
  set rIndex(int n) {
    if (rIndex < 0 || rIndex > wIndex)
      throw RangeError.range(rIndex, 0, length);
    rIndex = n;
  }
*/

  int rSkip(int n) {
    final v = rIndex + n;
    if (v < 0 || v > wIndex) throw RangeError.range(v, 0, wIndex);
    return rIndex = v;
  }

  int getInt8() => buffer.getInt8(rIndex);

  int readInt8() {
    final v = buffer.getInt8(rIndex);
    rIndex++;
    return v;
  }

  int getInt16() => buffer.getInt16(rIndex);

  int readInt16() {
    final v = buffer.getInt16(rIndex);
    rIndex += 2;
    return v;
  }

  int getInt32() => buffer.getInt32(rIndex);

  int readInt32() {
    final v = buffer.getInt32(rIndex);
    rIndex += 4;
    return v;
  }

  int getInt64() => buffer.getInt64(rIndex);

  int readInt64() {
    final v = buffer.getInt64(rIndex);
    rIndex += 8;
    return v;
  }

  int getUint8() => buffer.getUint8(rIndex);

  int readUint8() {
    final v = buffer.getUint8(rIndex);
    rIndex++;
    return v;
  }

  int getUint16() => buffer.getUint16(rIndex);

  int readUint16() {
    final v = buffer.getUint16(rIndex);
    rIndex += 2;
    return v;
  }

  int getUint32() => buffer.getUint32(rIndex);

  int readUint32() {
    final v = buffer.getUint32(rIndex);
    rIndex += 4;
    return v;
  }

  int getUint64() => buffer.getUint64(rIndex);

  int readUint64() {
    final v = buffer.getUint64(rIndex);
    rIndex += 8;
    return v;
  }

  double getFloat32() => buffer.getFloat32(rIndex);

  double readFloat32() {
    final v = buffer.getFloat32(rIndex);
    rIndex += 4;
    return v;
  }

  double getFloat64() => buffer.getFloat64(rIndex);

  double readFloat64() {
    final v = buffer.getFloat64(rIndex);
    rIndex += 8;
    return v;
  }

  String getAscii(int length) =>
      buffer.getAscii(offset: rIndex, length: length);

  String readAscii(int length) {
    final s = getAscii(length);
    rIndex += length;
    return s;
  }

  String getUtf8(int length) => buffer.getUtf8(offset: rIndex, length: length);

  String readUtf8(int length) {
    final s = getUtf8(length);
    rIndex += length;
    return s;
  }

  String readString(int length) => readUtf8(length);

  bool getUint32AndCompare(int target) {
    final delimiter = buffer.getUint32(rIndex);
    final v = target == delimiter;
    return v;
  }

  ByteData bdView([int start = 0, int end]) {
    end ??= rIndex;
    final length = end - start;
    //   final offset = _getOffset(start, length);
    return buffer.asByteData(start, length);
  }

  Uint8List uint8View([int start = 0, int length]) {
    final offset = _getOffset(start, length);
    return buffer.asUint8List(offset, length ?? length - offset);
  }

  Uint8List readUint8View(int length) => uint8View(rIndex, length);

  Int8List readInt8List(int length) {
    final v = buffer.getInt8List(rIndex, length);
    rIndex += length;
    return v;
  }

  Int16List readInt16List(int length) {
    final v = buffer.getInt16List(rIndex, length);
    rIndex += length;
    return v;
  }

  Int32List readInt32List(int length) {
    final v = buffer.getInt32List(rIndex, length);
    rIndex += length;
    return v;
  }

  Int64List readInt64List(int length) {
    final v = buffer.getInt64List(rIndex, length);
    rIndex += length;
    return v;
  }

  Uint8List readUint8List(int length) {
    final v = buffer.getUint8List(rIndex, length);
    rIndex += length;
    return v;
  }

  Uint16List readUint16List(int length) {
    final v = buffer.getUint16List(rIndex, length);
    rIndex += length;
    return v;
  }

  Uint32List readUint32List(int length) {
    final v = buffer.getUint32List(rIndex, length);
    rIndex += length;
    return v;
  }

  Uint64List readUint64List(int length) {
    final v = buffer.getUint64List(rIndex, length);
    rIndex += length;
    return v;
  }

  Float32List readFloat32List(int length) {
    final v = buffer.getFloat32List(rIndex, length);
    rIndex += length;
    return v;
  }

  Float64List readFloat64List(int length) {
    final v = buffer.getFloat64List(rIndex, length);
    rIndex += length;
    return v;
  }

  List<String> readAsciiList(int length) {
    final v = buffer.getAsciiList(
        offset: rIndex, length: length, allowInvalid: true);
    rIndex += length;
    return v;
  }

  List<String> readUtf8List(int length) {
    final v = buffer.getUtf8List(
        offset: rIndex, length: length, allowMalformed: true);
    rIndex += length;
    return v;
  }

  List<String> readStringList(int length) => readUtf8List(length);

  int _getOffset(int start, int length) {
    final offset = buffer.offset + start;
    assert(offset >= 0 && offset <= length);
    assert(offset + length >= offset && (offset + length) <= length);
    return offset;
  }

  Uint8List get contentsRead =>
      buffer.buffer.asUint8List(buffer.offset, rIndex);
  Uint8List get contentsUnread => buffer.buffer.asUint8List(rIndex, wIndex);

  Uint8List get contentsWritten => buffer.buffer.asUint8List(rIndex, wIndex);

  @override
  String toString() => '$runtimeType: @R$rIndex @W$wIndex $buffer';

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
      _hadTrailingZeros = _checkAllZeros(wIndex, buffer.length);
    final bd = buffer.asByteData(0, wIndex);
    _isClosed = true;
    return bd;
  }

  bool get hadTrailingZeros => _hadTrailingZeros ?? false;
  ByteData rClose() {
    final view = asByteData(0, rIndex);
    if (isNotEmpty) {
      rError('End of Data with rIndex($rIndex) != '
          'length(${view.lengthInBytes})');
      _hadTrailingZeros = _checkAllZeros(rIndex, wIndex);
    }
    _isClosed = true;
    return view;
  }

  void get reset {
    rIndex = 0;
    _isClosed = false;
    _hadTrailingZeros = false;
  }
}
