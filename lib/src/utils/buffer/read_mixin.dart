//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.utils.buffer;

// ignore_for_file: non_constant_identifier_names,
// ignore_for_file: prefer_initializing_formals

abstract class ReadBufferMixin {
  Bytes get _buf;
  int get _rIndex;
  set _rIndex(int n);
  int get _wIndex;
  int get _length;
  bool get _rIsEmpty;
  bool get _rIsNotEmpty;
  bool _checkAllZeros(int wIndex, int length);
  ByteData asByteData([int offset, int length]);
  void rError(Object msg);

  // *** Reader specific Getters and Methods

  int get rIndex => _rIndex;
  set rIndex(int n) {
    if (_rIndex < 0 || _rIndex > _wIndex)
      throw new RangeError.range(rIndex, 0, _length);
    _rIndex = n;
  }

  int rSkip(int n) {
    final v = _rIndex + n;
    if (v < 0 || v > _wIndex) throw new RangeError.range(v, 0, _wIndex);
    return _rIndex = v;
  }

  int getInt8() => _buf.getInt8(_rIndex);

  int readInt8() {
    final v = _buf.getInt8(_rIndex);
    _rIndex++;
    return v;
  }

  int getInt16() => _buf.getInt16(_rIndex);

  int readInt16() {
    final v = _buf.getInt16(_rIndex);
    _rIndex += 2;
    return v;
  }

  int getInt32() => _buf.getInt32(_rIndex);

  int readInt32() {
    final v = _buf.getInt32(_rIndex);
    _rIndex += 4;
    return v;
  }

  int getInt64() => _buf.getInt64(_rIndex);

  int readInt64() {
    final v = _buf.getInt64(_rIndex);
    _rIndex += 8;
    return v;
  }

  int getUint8() => _buf.getUint8(_rIndex);

  int readUint8() {
    final v = _buf.getUint8(_rIndex);
    _rIndex++;
    return v;
  }

  int getUint16() => _buf.getUint16(_rIndex);

  int readUint16() {
    final v = _buf.getUint16(_rIndex);
    _rIndex += 2;
    return v;
  }

  int getUint32() => _buf.getUint32(_rIndex);

  int readUint32() {
    final v = _buf.getUint32(_rIndex);
    _rIndex += 4;
    return v;
  }

  int getUint64() => _buf.getUint64(_rIndex);

  int readUint64() {
    final v = _buf.getUint64(_rIndex);
    _rIndex += 8;
    return v;
  }

  String getAscii(int length) => _buf.getAscii(offset: _rIndex, length: length);

  String readAscii(int length) {
    final s = getAscii(length);
    _rIndex += length;
    return s;
  }

  String getUtf8(int length) => _buf.getUtf8(offset: _rIndex, length: length);

  String readUtf8(int length) {
    final s = getUtf8(length);
    _rIndex += length;
    return s;
  }

  String readString(int length) => readUtf8(length);

  bool getUint32AndCompare(int target) {
    final delimiter = _buf.getUint32(_rIndex);
    final v = target == delimiter;
    return v;
  }

  ByteData bdView([int start = 0, int end]) {
    end ??= _rIndex;
    final length = end - start;
    //   final offset = _getOffset(start, length);
    return _buf.asByteData(start, length);
  }

  Uint8List uint8View([int start = 0, int length]) {
    final offset = _getOffset(start, length);
    return _buf.asUint8List(offset, length ?? length - offset);
  }

  Uint8List readUint8View(int length) => uint8View(_rIndex, length);

  Int8List readInt8List(int length) {
    final v = _buf.getInt8List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Int16List readInt16List(int length) {
    final v = _buf.getInt16List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Int32List readInt32List(int length) {
    final v = _buf.getInt32List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Int64List readInt64List(int length) {
    final v = _buf.getInt64List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Uint8List readUint8List(int length) {
    final v = _buf.getUint8List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Uint16List readUint16List(int length) {
    final v = _buf.getUint16List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Uint32List readUint32List(int length) {
    final v = _buf.getUint32List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Uint64List readUint64List(int length) {
    final v = _buf.getUint64List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Float32List readFloat32List(int length) {
    final v = _buf.getFloat32List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  Float64List readFloat64List(int length) {
    final v = _buf.getFloat64List(_rIndex, length);
    _rIndex += length;
    return v;
  }

  List<String> readAsciiList(int length) {
    final v =
        _buf.getAsciiList(offset: _rIndex, length: length, allowInvalid: true);
    _rIndex += length;
    return v;
  }

  List<String> readUtf8List(int length) {
    final v =
        _buf.getUtf8List(offset: _rIndex, length: length, allowMalformed: true);
    _rIndex += length;
    return v;
  }

  List<String> readStringList(int length) => readUtf8List(length);

  int _getOffset(int start, int length) {
    final offset = _buf.offset + start;
    assert(offset >= 0 && offset <= length);
    assert(offset + length >= offset && (offset + length) <= length);
    return offset;
  }

  Uint8List get contentsRead => _buf.buffer.asUint8List(_buf.offset, _rIndex);
  Uint8List get contentsUnread => _buf.buffer.asUint8List(_rIndex, _wIndex);

  Uint8List get contentsWritten => _buf.buffer.asUint8List(_rIndex, _wIndex);

  @override
  String toString() => '$runtimeType: @R$_rIndex @W$_wIndex $_buf';

  void _checkRange(int v) {
    final max = _wIndex;
    if (v < 0 || v >= max) throw new RangeError.range(v, 0, max);
  }
}
