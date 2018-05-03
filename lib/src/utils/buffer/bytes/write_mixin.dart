//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.utils.buffer;

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: prefer_initializing_formals

abstract class WriteBufferMixin {
  // **** Interface
  /// The underlying [Bytes] for the buffer.
  GrowableBytes get _buf;

  int get _rIndex;
  set _rIndex(int n);
  int get _wIndex;
  set _wIndex(int n);

  int get _length;
  int get _wRemaining;
  bool get _wIsEmpty;
  bool get _wIsNotEmpty;

  int get limit;

  ByteData asByteData([int offset, int length]);

  // **** End of Interface

  // **** WriteBuffer specific Getters and Methods

  // *** wIndex
  int get wIndex => _wIndex;
  set wIndex(int n) {
    if (_wIndex <= _rIndex || _wIndex > _buf.length)
      throw new RangeError.range(_wIndex, _rIndex, _buf.length);
    _wIndex = n;
  }

  /// Moves the [wIndex] forward/backward. Returns the new [wIndex].
  int wSkip(int n) {
    final v = _wIndex + n;
    if (v <= _rIndex || v >= _buf.length)
      throw new RangeError.range(v, 0, _buf.length);
    return _wIndex = v;
  }

  bool _wHasRemaining(int n);

  void write(Bytes bList, [int offset = 0, int length]) {
    length ??= bList.length;
    ensureRemaining(length + 1);
    for (var i = offset, j = _wIndex; i < length; i++, j++)
      _buf.setUint8(j, bList[i]);
    _wIndex += length;
  }

  void setInt8(int n) => _buf.setInt8(_wIndex, n);

  void writeInt8(int n) {
    assert(n >= -128 && n <= 127, 'Value out of range: $n');
    _maybeGrow(1);
    _buf.setInt8(_wIndex, n);
    _wIndex++;
  }

  void setInt16(int n) => _buf.setInt16(_wIndex, n);

  /// Writes a 16-bit unsigned integer (Uint16) value to _this_.
  void writeInt16(int value) {
    assert(
        value >= -0x7FFF && value <= 0x7FFF - 1, 'Value out of range: $value');
    _maybeGrow(2);
    _buf.setInt16(_wIndex, value);
    _wIndex += 2;
  }

  void setInt32(int n) => _buf.setInt32(_wIndex, n);

  /// Writes a 32-bit unsigned integer (Uint32) value to _this_.
  void writeInt32(int value) {
    assert(value >= -0x7FFFFFFF && value <= 0x7FFFFFFF - 1,
        'Value out if range: $value');
    _maybeGrow(4);
    _buf.setInt32(_wIndex, value);
    _wIndex += 4;
  }

  void setInt64(int n) => _buf.setInt64(_wIndex, n);

  /// Writes a 64-bit unsigned integer (Uint32) value to _this_.
  void writeInt64(int value) {
    assert(value >= -0x7FFFFFFFFFFFFFFF && value <= 0x7FFFFFFFFFFFFFFF - 1,
        'Value out of range: $value');
    _maybeGrow(8);
    _buf.setInt64(_wIndex, value);
    _wIndex += 8;
  }

  void setUint8(int n) => _buf.setUint8(_wIndex, n);

  /// Writes a byte (Uint8) value to _this_.
  void writeUint8(int value) {
    assert(value >= 0 && value <= 255, 'Value out of range: $value');
    _maybeGrow(1);
    _buf.setUint8(_wIndex, value);
    _wIndex++;
  }

  void setUint16(int n) => _buf.setUint16(_wIndex, n);

  /// Writes a 16-bit unsigned integer (Uint16) value to _this_.
  void writeUint16(int value) {
    assert(value >= 0 && value <= 0xFFFF, 'Value out of range: $value');
    _maybeGrow(2);
    _buf.setUint16(_wIndex, value);
    _wIndex += 2;
  }

  void setUint32(int n) => _buf.setUint32(_wIndex, n);

  /// Writes a 32-bit unsigned integer (Uint32) value to _this_.
  void writeUint32(int value) {
    assert(value >= 0 && value <= 0xFFFFFFFF, 'Value out if range: $value');
    _maybeGrow(4);
    _buf.setUint32(_wIndex, value);
    _wIndex += 4;
  }

  void setUint64(int n) => _buf.setUint64(_wIndex, n);

  /// Writes a 64-bit unsigned integer (Uint32) value to _this_.
  void writeUint64(int value) {
    assert(value >= 0 && value <= 0xFFFFFFFFFFFFFFFF,
        'Value out of range: $value');
    _maybeGrow(8);
    _buf.setUint64(_wIndex, value);
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
    _maybeGrow(length);
    for (var i = 0, j = _wIndex; i < length; i++, j++) _buf[j] = 0;
    _wIndex += length;
    return true;
  }

  // **** List writing methods

  void writeInt8List(Int8List list, [int offset = 0, int length]) {
    _buf.setInt8List(_wIndex, list, offset, length);
    _wIndex += list.length;
  }

  void writeInt16List(Int16List list, [int offset = 0, int length]) {
    _buf.setInt16List(_wIndex, list, offset, length);
    _wIndex += (list.length * 2);
  }

  void writeInt32List(Int32List list, [int offset = 0, int length]) {
    _buf.setInt32List(_wIndex, list, offset, length);
    _wIndex += (list.length * 4);
  }

  void writeInt64List(Int64List list, [int offset = 0, int length]) {
    _buf.setInt64List(_wIndex, list, offset, length);
    _wIndex += (list.length * 8);
  }

  void writeUint8List(Uint8List bList, [int offset = 0, int length]) {
    if (bList.lengthInBytes == 0) return;
    writeByteData(bList.buffer.asByteData(bList.offsetInBytes, bList.length));
  }

  void writeByteData(ByteData bd, [int offset = 0, int length]) {
    final length = bd.lengthInBytes;
    if (length == 0) return;
    ensureRemaining(length);
    _buf.setByteData(_wIndex, bd, offset, length);
    _wIndex += length;
  }

  void writeUint16List(Uint16List list, [int offset = 0, int length]) {
    _buf.setUint16List(_wIndex, list, offset, length);
    _wIndex += (list.length * 2);
  }

  void writeUint32List(Uint32List list, [int offset = 0, int length]) {
    _buf.setUint32List(_wIndex, list, offset, length);
    _wIndex += (list.length * 4);
  }

  void writeUint64List(Uint64List list, [int offset = 0, int length]) {
    _buf.setUint64List(_wIndex, list, offset, length);
    _wIndex += (list.length * 8);
  }

  void writeFloat32List(Float32List list, [int offset = 0, int length]) {
    _buf.setFloat32List(_wIndex, list, offset, length);
    _wIndex += (list.length * 4);
  }

  void writeFloat64List(Float64List list, [int offset = 0, int length]) {
    _buf.setFloat64List(_wIndex, list, offset, length);
    _wIndex += (list.length * 8);
  }

  void writeAsciiList(List<String> list, [int offset = 0, int length]) =>
      _wIndex += _buf.setAsciiList(_wIndex, list, offset, length);

  void writeUtf8List(List<String> list, [int offset = 0, int length]) =>
      _wIndex += _buf.setUtf8List(_wIndex, list, offset, length);

  void writeStringList(List<String> list) => writeUtf8List(list);

  /// Ensures that [_buf] has at least [remaining] writable bytes.
  /// The [_buf] is grows if necessary, and copies existing bytes into
  /// the new [_buf].
  bool ensureRemaining(int remaining) => _ensureRemaining(remaining);
  bool _ensureRemaining(int remaining) => _ensureCapacity(_wIndex + remaining);

  /// Ensures that [_buf] is at least [capacity] long, and grows
  /// the buf if necessary, preserving existing data.
  bool ensureCapacity(int capacity) => _ensureCapacity(capacity);
  bool _ensureCapacity(int capacity) =>
      (capacity > _length) ? _grow(capacity) : false;

  bool _grow([int capacity]) => _buf.grow(capacity);

  /// Grow the buf if the __wIndex is at, or beyond, the end of the current buf.
  bool _maybeGrow([int size = 1]) =>
      (_wIndex + size < _length) ? false : _grow(_wIndex + size);

  @override
  String toString() => '$runtimeType($_length)[$_wIndex] maxLength: $limit';

  void warn(Object msg) => print('** Warning(@$_wIndex): $msg');

  void error(Object msg) => throw new Exception('**** Error(@$_wIndex): $msg');
  // Internal methods

  static const int kDefaultLength = 4096;
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

  void error(Object msg) => throw new Exception('**** Error: $msg $_www');
}
