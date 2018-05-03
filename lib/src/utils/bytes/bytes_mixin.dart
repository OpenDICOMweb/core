//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.utils.bytes;

class AlignmentError extends Error {
  final ByteData bd;
  final int offsetInBytes;
  final int lengthInBytes;
  final int sizeInBytes;

  AlignmentError(
      this.bd, this.offsetInBytes, this.lengthInBytes, this.sizeInBytes);
}

Null alignmentError(
    ByteData bd, int offsetInBytes, int lengthInBytes, int sizeInBytes) {
  if (throwOnError)
    throw new AlignmentError(bd, offsetInBytes, lengthInBytes, sizeInBytes);
  return null;
}

/// [BytesMixin] is a class that provides a read-only byte array that
/// supports both [Uint8List] and [ByteData] interfaces.
abstract class BytesMixin {
  ByteData get _bd;
  Endian get endian;

  static bool ignorePadding = true;
  static bool allowUnequalLengths = false;

  ByteData get bd => _bd;

  // **** TypedData interface.
  int get elementSizeInBytes => 1;

  int get offset => _bdOffset;
  int get _bdOffset => _bd.offsetInBytes;

  int get length => _bdLength;
  int get _bdLength => _bd.lengthInBytes;
  set length(int length) =>
      throw new UnsupportedError('$runtimeType: length is not modifiable');

  int get limit => _bdLength;

  ByteBuffer get buffer => _bd.buffer;

  String get endianness =>
      (endian == Endian.little) ? 'Endian.little' : 'Endian.big';

  // **** Primitive ByteData Getters

  /// Returns an 8-bit integer values at
  ///     `index = [_bd].offsetInBytes + [offset]`
  /// in the underlying [ByteBuffer].
  /// _Note_: [offset] may be negative.
  int _getInt8(int i) => _bd.getInt8(_absIndex(i));
  int _getInt16(int i) => _bd.getInt16(_absIndex(i), endian);
  int _getInt32(int i) => _bd.getInt32(_absIndex(i), endian);
  int _getInt64(int i) => _bd.getInt64(_absIndex(i), endian);

  Int32x4 _getInt32x4(int index) {
    assert(_bdLength >= index + 16);
    var i = index;
    final w = _getInt32(_absIndex(i));
    final x = _getInt32(_absIndex(i += 4));
    final y = _getInt32(_absIndex(i += 4));
    final z = _getInt32(_absIndex(i += 4));
    return new Int32x4(w, x, y, z);
  }

  int _getUint8(int i) => _bd.getUint8(i);
  int _getUint16(int i) => _bd.getUint16(i, endian);
  int _getUint32(int i) => _bd.getUint32(i, endian);
  int _getUint64(int i) => _bd.getUint64(i, endian);

  double _getFloat32(int i) => _bd.getFloat32(i, endian);
  double _getFloat64(int i) => _bd.getFloat64(i, endian);

  Float32x4 _getFloat32x4(int index) {
    assert(_bdLength >= index + 16);
    var i = index;
    final w = _getFloat32(_absIndex(i));
    final x = _getFloat32(_absIndex(i += 4));
    final y = _getFloat32(_absIndex(i += 4));
    final z = _getFloat32(_absIndex(i += 4));
    return new Float32x4(w, x, y, z);
  }

  Float64x2 _getFloat64x2(int index) {
    assert(_bdLength >= index + 16);
    var i = index;
    final x = _getFloat64(_absIndex(i));
    final y = _getFloat64(_absIndex(i += 8));
    return new Float64x2(x, y);
  }

  // **** Public ByteData Getters

  /// Returns an 8-bit integer values at index [_bd].offsetInBytes + [offset]
  /// in the underlying [ByteBuffer].
  /// _Note_: [offset] may be negative.
  int getInt8(int offset) => _getInt8(offset);
  int getInt16(int offset) => _getInt16(offset);
  int getInt32(int offset) => _getInt32(offset);
  int getInt64(int offset) => _getInt64(offset);
  Int32x4 getInt32x4(int offset) => _getInt32x4(offset);

  int getUint8(int offset) => _getUint8(offset);
  int getUint16(int offset) => _getUint16(offset);
  int getUint32(int offset) => _getUint32(offset);
  int getUint64(int offset) => _getUint64(offset);

  double getFloat32(int offset) => _getFloat32(offset);
  double getFloat64(int offset) => _getFloat64(offset);
  Float32x4 getFloat32x4(int offset) => _getFloat32x4(offset);
  Float64x2 getFloat64x2(int offset) => _getFloat64x2(offset);

  // **** Internal methods for creating copies and views of sub-regions.

  // **** TypedData views

  /// Returns an [ByteData] view of the specified region of _this_.
  ByteData _viewOfBDRegion([int offset = 0, int length]) =>
      _bd.buffer.asByteData(_absIndex(offset), length ??= _bdLength);

  /// Returns a view of the specified region of _this_. [endian] defaults
  /// to the same [endian]ness as _this_.
  Bytes asBytes([int offset = 0, int length, Endian endian]) {
    final bd = _viewOfBDRegion(offset, length);
    return new Bytes.fromByteData(bd, endian ?? this.endian);
  }

  /// Creates an [ByteData] view of the specified region of _this_.
  ByteData asByteData([int offset = 0, int length]) =>
      _viewOfBDRegion(offset, length);

  /// Creates an [Int8List] view of the specified region of _this_.
  Int8List asInt8List([int offset = 0, int length]) =>
      _bd.buffer.asInt8List(_absIndex(offset), length ?? _bdLength);

  /// If [offset] is aligned on an 8-byte boundary, returns a [Int16List]
  /// view of the specified region; otherwise, creates a [Int16List] that
  /// is a copy of the specified region and returns it.
  Int16List asInt16List([int offset = 0, int length]) {
    final index = _absIndex(offset);
    return (_isAligned16(index))
        ? _bd.buffer.asInt16List(index, length ?? _length16(index))
        : getInt16List(offset, length);
  }

  /// If [offset] is aligned on an 8-byte boundary, returns a [Int32List]
  /// view of the specified region; otherwise, creates a [Int32List] that
  /// is a copy of the specified region and returns it.
  Int32List asInt32List([int offset = 0, int length]) {
    final index = _absIndex(offset);
    length ??= _length32(index);
    return (_isAligned32(index))
        ? _bd.buffer.asInt32List(index, length)
        : getInt32List(offset, length);
  }

  /// If [offset] is aligned on an 8-byte boundary, returns a [Int64List]
  /// view of the specified region; otherwise, creates a [Int64List] that
  /// is a copy of the specified region and returns it.
  Int64List asInt64List([int offset = 0, int length]) {
    final index = _absIndex(offset);
    length ??= _length64(index);
    return (_isAligned64(index))
        ? _bd.buffer.asInt64List(index, length)
        : getInt64List(offset, length);
  }

  Uint8List asUint8List([int offset = 0, int length]) =>
      _bd.buffer.asUint8List(_absIndex(offset), length ?? _bdLength);

  /// If [offset] is aligned on an 8-byte boundary, returns a [Uint16List]
  /// view of the specified region; otherwise, creates a [Uint16List] that
  /// is a copy of the specified region and returns it.
  Uint16List asUint16List([int offset = 0, int length]) {
    final index = _absIndex(offset);
    length ??= _length16(index);
    return (_isAligned16(index))
        ? _bd.buffer.asUint16List(index, length)
        : getUint16List(offset, length);
  }

  /// If [offset] is aligned on an 8-byte boundary, returns a [Uint32List]
  /// view of the specified region; otherwise, creates a [Uint32List] that
  /// is a copy of the specified region and returns it.
  Uint32List asUint32List([int offset = 0, int length]) {
    final index = _absIndex(offset);
    length ??= _length32(index);
    return (_isAligned32(index))
        ? _bd.buffer.asUint32List(index, length)
        : getUint32List(offset, length);
  }

  /// If [offset] is aligned on an 8-byte boundary, returns a [Uint64List]
  /// view of the specified region; otherwise, creates a [Uint64List] that
  /// is a copy of the specified region and returns it.
  Uint64List asUint64List([int offset = 0, int length]) {
    final index = _absIndex(offset);
    length ??= _length64(index);
    return (_isAligned64(index))
        ? _bd.buffer.asUint64List(index, length)
        : getUint64List(offset, length);
  }

  // **** TypedData copies

  /// Returns a [ByteData] that iss a copy of the specified region of _this_.
  ByteData _copyBDRegion(int offset, int length) {
    final _length = length ?? _bdLength;
    final bdNew = new ByteData(_length);
    for (var i = 0, j = offset; i < _length; i++, j++)
      bdNew.setUint8(i, bd.getUint8(j));
    return bdNew;
  }

  /// Creates a new [Bytes] from _this_ containing the specified region.
  /// The [endian]ness is the same as _this_.
  Bytes sublist([int start = 0, int end]) {
    final bd = _copyBDRegion(start, (end ??= _bdLength) - start);
    return new Bytes.fromByteData(bd, endian);
  }

  /// Creates an [Int8List] copy of the specified region of _this_.
  Bytes getBytes([int offset = 0, int length, Endian endian]) {
    final bd = _copyBDRegion(offset, length);
    return new Bytes.fromByteData(bd, endian ?? this.endian);
  }

  /// Creates an [Int8List] copy of the specified region of _this_.
  ByteData getByteData([int offset = 0, int length]) =>
      _copyBDRegion(offset, length);

  /// Creates an [Int8List] copy of the specified region of _this_.
  Int8List getInt8List([int offset = 0, int length]) {
    length ??= _bdLength;
    final list = new Int8List(length);
    for (var i = 0, j = offset; i < length; i++, j++) list[i] = _bd.getInt8(j);
    return list;
  }

  /// Creates an [Int16List] copy of the specified region of _this_.
  Int16List getInt16List([int offset = 0, int length])  {
    length ??= _length16(offset);
    final list = new Int16List(length);
    for (var i = 0, j = offset; i < length; i++, j += 2) list[i] = _getInt16(j);
    return list;
  }

  /// Creates an [Int32List] copy of the specified region of _this_.
  Int32List getInt32List([int offset = 0, int length]) {
    length ??= _length32(offset);
    final list = new Int32List(length);
    for (var i = 0, j = offset; i < length; i++, j += 4) list[i] = _getInt32(j);
    return list;
  }

  /// Creates an [Int64List] copy of the specified region of _this_.
  Int64List getInt64List([int offset = 0, int length]) {
    length ??= _length64(offset);
    final list = new Int64List(length);
    for (var i = 0, j = offset; i < length; i++, j += 8) list[i] = _getInt64(j);
    return list;
  }

  // **** Unsigned Integer Lists

  Uint8List getUint8List([int offset = 0, int length]) =>
      new Uint8List.fromList(_bd.buffer.asUint8List(offset, length ?? length));

  /// Creates an [Uint16List] copy of the specified region of _this_.
  Uint16List getUint16List([int offset = 0, int length]) {
    final index = _absIndex(offset);
    return _getUint16List(index, length ?? _length16(index));
  }

  Uint16List _getUint16List(int index, int length) {
    final list = new Uint16List(length);
    for (var i = 0, j = index; i < length; i++, j += 2) list[i] = _getUint16(j);
    return list;
  }

  /// Creates an [Uint32List] copy of the specified region of _this_.
  Uint32List getUint32List([int offset = 0, int length]) {
    final index = _absIndex(offset);
    return _getUint32List(index, length ?? _length32(index));
  }

  Uint32List _getUint32List(int index, int length) {
    final list = new Uint32List(length);
    for (var i = 0, j = index; i < length; i++, j += 4) list[i] = _getUint32(j);
    return list;
  }

  /// Creates an [Uint64List] copy of the specified region of _this_.
  Uint64List getUint64List([int offset = 0, int length]) {
    final index = _absIndex(offset);
    return _getUint64List(index, length ?? _length64(index));
  }

  Uint64List _getUint64List(int index, int length) {
    final list = new Uint64List(length);
    for (var i = 0, j = index; i < length; i++, j += 8) list[i] = _getUint64(j);
    return list;
  }

  // **** Float Lists

  /// Creates an [Float32List] copy of the specified region of _this_.
  Float32List getFloat32List([int offset = 0, int length]) {
//    final index = _bdIndex(offset);
    return _getFloat32List(offset, length ?? _length32(offset));
  }

  /// If [offset] is aligned on an 8-byte boundary, returns a [Float32List]
  /// view of the specified region; otherwise, creates a [Float32List] that
  /// is a copy of the specified region and returns it.
  Float32List asFloat32List([int offset = 0, int length]) {
    final index = _absIndex(offset);
    length ??= _length32(index);
    return (_isAligned32(index))
        ? _bd.buffer.asFloat32List(index, length)
        : _getFloat32List(index, length);
  }

  Float32List _getFloat32List(int index, int length) {
    final list = new Float32List(length);
    for (var i = 0, j = index; i < length; i++, j += 4)
      list[i] = _getFloat32(j);
    return list;
  }

  /// Creates an [Float64List] copy of the specified region of _this_.
  Float64List getFloat64List([int offset = 0, int length]) {
    final index = _absIndex(offset);
    return _getFloat64List(index, length ?? _length64(index));
  }

  /// If [offset] is aligned on an 8-byte boundary, returns a [Float64List]
  /// view of the specified region; otherwise, creates a [Float64List] that
  /// is a copy of the specified region and returns it.
  Float64List asFloat64List([int offset = 0, int length]) {
    final index = _absIndex(offset);
    length ??= _length64(index);
    return (_isAligned64(index))
        ? _bd.buffer.asFloat64List(index, length)
        : _getFloat64List(offset, length);
  }

  //!!!!!!!! ***** why is as different from get
  Float64List _getFloat64List(int index, int length) {
    final list = new Float64List(length);
    for (var i = 0, j = index; i < length; i++, j += 8)
      list[i] = _getFloat64(j);
    return list;
  }

  // **** Strings and List<String>

  String asBase64([int offset = 0, int length]) =>
      base64.encode(asUint8List(offset, length));

  String getAscii({int offset = 0, int length, bool allowInvalid: true}) =>
      _getAscii(offset, length ?? _bdLength, allowInvalid);

  List<String> getAsciiList(
          {int offset = 0, int length, bool allowInvalid: true}) =>
      _getAscii(offset, length, allowInvalid).split('\\');

  String _getAscii(int offset, int length, [bool allow]) =>
      ascii.decode(asUint8List(offset, length), allowInvalid: allow);

  /// Returns a UTF-8 [String].
  String getUtf8({int offset = 0, int length, bool allowMalformed: true}) =>
      _getUtf8(offset, length, allowMalformed);

  List<String> getUtf8List(
          {int offset = 0, int length, bool allowMalformed: true}) =>
      _getUtf8(offset, length, allowMalformed).split('\\');

  String _getUtf8(int offset, int length, [bool allow]) =>
      utf8.decode(asUint8List(offset, length), allowMalformed: allow);

  /// Returns a UTF-8 [String].
  String getString([int offset = 0, int length]) => getUtf8(
      offset: offset, length: length ??= _bdLength, allowMalformed: true);

  List<String> getStringList([int offset = 0, int length]) =>
      getUtf8List(offset: offset, length: length, allowMalformed: true);

  // ********************** Setters ********************************

  // **** Internal ByteData Setters
  // Internal setters take an absolute index [i] into the underlying
  // [ByteBuffer] ([_bd].buffer).  The external interface of this package
  // uses [offset]s relative to the current [ByteData] ([_bd]).

  void _setInt8(int i, int v) => _bd.setInt8(i, v);
  void _setInt16(int i, int v) => _bd.setInt16(i, v, endian);
  void _setInt32(int i, int v) => _bd.setInt32(i, v, endian);
  void _setInt64(int i, int v) => _bd.setInt64(i, v, endian);

  void _setInt32x4(int index, Int32x4 v) {
    var i = index;
    _setInt32(i, v.w);
    _setInt32(i += 4, v.x);
    _setInt32(i += 4, v.y);
    _setInt32(i += 4, v.z);
  }

  void _setUint8(int i, int v) => _bd.setUint8(i, v);
  void _setUint16(int i, int v) => _bd.setUint16(i, v, endian);
  void _setUint32(int i, int v) => _bd.setUint32(i, v, endian);
  void _setUint64(int i, int v) => _bd.setUint64(i, v, endian);

  void _setFloat32(int i, double v) => _bd.setFloat32(i, v, endian);

  void _setFloat64(int i, double v) => _bd.setFloat64(i, v, endian);

  void _setFloat32x4(int index, Float32x4 v) {
    var i = index;
    _setFloat32(i, v.w);
    _setFloat32(i += 4, v.x);
    _setFloat32(i += 4, v.y);
    _setFloat32(i += 4, v.z);
  }

  void _setFloat64x2(int index, Float64x2 v) {
    var i = index;
    _setFloat64(i, v.x);
    _setFloat64(i += 4, v.y);
  }

  // **** External ByteData Setters

  void setInt8(int offset, int value) => _setInt8(_absIndex(offset), value);
  void setInt16(int offset, int value) => _setInt16(_absIndex(offset), value);
  void setInt32(int offset, int value) => _setInt32(_absIndex(offset), value);
  void setInt64(int offset, int value) => _setInt64(_absIndex(offset), value);

  void setInt32x4(int offset, Int32x4 value) {
    var i = _absIndex(offset);
    _setInt32(i, value.w);
    _setInt32(i += 4, value.x);
    _setInt32(i += 4, value.y);
    _setInt32(i += 4, value.z);
  }

  void setUint8(int offset, int value) => _setUint8(_absIndex(offset), value);
  void setUint16(int offset, int value) => _setUint16(_absIndex(offset), value);
  void setUint32(int offset, int value) => _setUint32(_absIndex(offset), value);
  void setUint64(int offset, int value) => _setUint64(_absIndex(offset), value);

  void setFloat32(int offset, double value) =>
      _setFloat32(_absIndex(offset), value);

  void setFloat64(int offset, double value) =>
      _setFloat64(_absIndex(offset), value);

  void setFloat32x4(int offset, Float32x4 value) {
    var i = _absIndex(offset);
    _setFloat32(i, value.w);
    _setFloat32(i += 4, value.x);
    _setFloat32(i += 4, value.y);
    _setFloat32(i += 4, value.z);
  }

  void setFloat64x2(int offset, Float64x2 value) {
    var i = _absIndex(offset);
    _setFloat64(i, value.x);
    _setFloat64(i += 4, value.y);
  }

  // **** String Setters

  /// Ascii encodes the specified range of [s] and then writes the
  /// code units to _this_ starting at [start].
  int setAscii(int start, String s, [int offset = 0, int length]) {
    final v = _maybeGetSubstring(s, offset, length);
    return _setUint8List(start, ascii.encode(v), offset, length);
  }

  /// UTF-8 encodes the specified range of [s] and then writes the
  /// code units to _this_ starting at [start].
  int setUtf8(int start, String s, [int offset = 0, int length]) {
    length ??= s.length;
    final v = _maybeGetSubstring(s, offset, length);
    return _setUint8List(start, utf8.encode(v), offset, length);
  }

  String _maybeGetSubstring(String s, int offset, int length) =>
      (offset == 0 && length == s.length)
          ? s
          : s.substring(offset, offset + length);

  void setString(int start, String s, [int offset = 0, int length]) =>
      setUtf8(start, s, offset, length);

  // **** List Setters

  void setBytes(int start, Bytes bytes, [int offset = 0, int length]) =>
      _setByteData(start, bytes._bd, offset, length);

  void setByteData(int start, ByteData bd, [int offset = 0, int length]) =>
      _setByteData(start, bd, offset, length);

  void _setByteData(int start, ByteData other, int offset, int length) {
    length ?? _bdLength;
    final index = _absIndex(start);
    _checkLength(index, length, kUint8Size);
    for (var i = 0, j = index; i < length; i++, j++)
      _setUint8(j, other.getUint8(i));
  }

  void setInt8List(int start, Int8List list, [int offset = 0, int length]) {
    length ??= list.length;
    final index = _absIndex(start);
    _checkLength(index, length, kInt8Size);
    for (var i = 0, j = index; i < length; i++, j++) _setInt8(j, list[i]);
  }

  void setInt16List(int start, Int16List list, [int offset = 0, int length]) {
    length ??= list.length;
    final index = _absIndex(start);
    _checkLength(index, length, kInt16Size);
    for (var i = 0, j = index; i < length; i++, j += 2) _setInt16(j, list[i]);
  }

  void setInt32List(int start, Int32List list, [int offset = 0, int length]) {
    length ??= list.length;
    final index = _absIndex(start);
    _checkLength(index, length, kFloat64Size);
    for (var i = 0, j = index; i < length; i++, j += 4) _setInt32(j, list[i]);
  }

  void setInt32x4List(int start, Int32x4List list,
      [int offset = 0, int length]) {
    length ??= list.length;
    final index = _absIndex(start);
    _checkLength(index, length, kFloat64Size);
    for (var i = 0, j = index; i < length; i++, j += 16)
      _setInt32x4(j, list[i]);
  }

  void setInt64List(int start, Int64List list, [int offset = 0, int length]) {
    length ??= list.length;
    final index = _absIndex(start);
    _checkLength(index, length, kInt64Size);
    for (var i = 0, j = index; i < length; i++, j += 8) setInt64(j, list[i]);
  }

  int setUint8List(int start, Uint8List list, [int offset = 0, int length]) =>
      _setUint8List(start, list, offset, length);

  int _setUint8List(int start, Uint8List list, [int offset = 0, int length]) {
    length ??= list.length;
    final index = _absIndex(start);
    _checkLength(index, length, kUint8Size);
    for (var i = offset, j = index; i < length; i++, j++) _setUint8(j, list[i]);
    return length;
  }

  void setUint16List(int start, Uint16List list, [int offset = 0, int length]) {
    length ??= list.length;
    final index = _absIndex(start);
    _checkLength(index, length, kUint16Size);
    for (var i = 0, j = index; i < length; i++, j += 2) _setUint16(i, list[i]);
  }

  void setUint32List(int start, Uint32List list, [int offset = 0, int length]) {
    length ??= list.length;
    final index = _absIndex(start);
    _checkLength(index, length, kUint32Size);
    for (var i = 0, j = index; i < length; i++, j += 4) _setUint32(i, list[i]);
  }

  void setUint64List(int start, Uint64List list, [int offset = 0, int length]) {
    length ??= list.length;
    final index = _absIndex(start);
    _checkLength(index, length, kUint64Size);
    for (var i = 0, j = index; i < length; i++, j += 8) _setUint64(i, list[i]);
  }

  void setFloat32List(int start, Float32List list,
      [int offset = 0, int length]) {
    length ??= list.length;
    final index = _absIndex(start);
    _checkLength(index, length, kFloat32Size);
    for (var i = 0, j = index; i < length; i++, j += 4) _setFloat32(i, list[i]);
  }

  void setFloat32x4List(int start, Float32x4List list,
      [int offset = 0, int length]) {
    length ??= list.length;
    final index = _absIndex(start);
    _checkLength(index, length, list.length * 16);
    for (var i = 0, j = index; i < length; i++, j += 16)
      _setFloat32x4(j, list[i]);
  }

  void setFloat64List(int start, Float64List list,
      [int offset = 0, int length]) {
    length ??= list.length;
    final index = _absIndex(start);
    _checkLength(index, length, kFloat64Size);
    for (var i = 0, j = index; i < length; i++, j += 8) _setFloat64(i, list[i]);
  }

  void setFloat64x2List(int start, Float64x2List list,
      [int offset = 0, int length]) {
    length ??= list.length;
    final index = _absIndex(start);
    _checkLength(index, length, kFloat64Size);
    for (var i = 0, j = index; i < length; i++, j += 16)
      _setFloat64x2(j, list[i]);
  }

  // **** String List Setters

  int setAsciiList(int start, List<String> sList,
      [int offset = 0, int length]) {
    final s = _stringListToString(sList, offset, length ??= sList.length);
    setAscii(start, s, offset, s.length);
    return s.length;
  }

  int setUtf8List(int start, List<String> sList, [int offset = 0, int length]) {
    final s = _stringListToString(sList, offset, length ??= sList.length);
    setUtf8(start, s, offset, s.length);
    return s.length;
  }

  // **** Other

  @override
  String toString() => '$runtimeType: $endianness ${toBDDescriptor(_bd)}}';

  String toBDDescriptor(ByteData b) {
    final start = _bdOffset;
    final length = _bdLength;
    final end = start + length;
    return '$start-$end:$length ${asUint8List()}';
  }

  // **** Internals

  /// Checks that _bd[bdOffset, bdLength] >= vLengthInBytes
  void _checkLength(int bdOffset, int vLength, int size) {
    final vLengthInBytes = vLength * size;
    final bdLength = _bdLength - (_bdOffset + bdOffset);
    if (vLengthInBytes > bdLength)
      throw new RangeError('List ($vLengthInBytes bytes) is to large for '
          'Bytes($bdLength bytes');
  }

  String _stringListToString(List<String> sList, int offset, int length) {
    final v = (offset == 0 && length == sList.length)
        ? sList
        : sList.sublist(offset, offset + length);
    return v.join('\\');
  }

  /// Returns the absolute index of [offset] in the underlying [ByteBuffer].
  int _absIndex(int offset) => _bdOffset + offset;
  
  /// Returns the number of 32-bit elements from [index] to
  /// [_bd].lengthInBytes, where [index] is the absolute offset in [_bd].
  int _length16(int index) {
    final _length = _bdLength - index;
    assert((_length % 2) == 0);
    return _length ~/ 2;
  }

  /// Returns the number of 32-bit elements from [index] to
  /// [_bd].lengthInBytes, where [index] is the absolute offset in [_bd].
  int _length32(int index) {
    final _length = _bdLength - index;
    assert((_length % 4) == 0);
    return _length ~/ 4;
  }

  /// Returns the number of 32-bit elements from [index] to
  /// [_bd].lengthInBytes, where [index] is the absolute offset in [_bd].
  int _length64(int index) {
    final _length = _bdLength - index;
    // !Must be 4 on next line because long header is 12 bytes!
    assert((_length % 4) == 0);
    return _length ~/ 8;
  }

  bool _isAligned(int index, int size) => (index % size) == 0;

  // offset is in bytes
  bool _isAligned16(int offset) => _isAligned(offset, 2);
  bool _isAligned32(int offset) => _isAligned(offset, 4);
  bool _isAligned64(int offset) => _isAligned(offset, 8);
}
