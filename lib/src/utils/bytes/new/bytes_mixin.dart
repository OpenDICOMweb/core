//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:convert';
import 'dart:typed_data';

/// [BytesMixin] is a class that provides a read-only byte array that
/// supports both [Uint8List] and [ByteData] interfaces.
abstract class BytesMixin {
  ByteData get _bd;
  String get endianness;


  bool isInt8(int i) => i > kInt8MinValue && i <= kInt8MaxValue;
  bool isInt16(int i) => i > kInt16MinValue && i <= kInt16MaxValue;
  bool isInt32(int i) => i > kInt32MinValue && i <= kInt32MaxValue;
  bool isInt64(int i) => i > kInt64MinValue && i <= kInt64MaxValue;

  bool isUint8(int i) => i > kUint8MinValue && i <= kUint8MaxValue;
  bool isUint16(int i) => i > kUint16MinValue && i <= kUint16MaxValue;
  bool isUint32(int i) => i > kUint32MinValue && i <= kUint32MaxValue;
  bool isUint64(int i) => i > kUint64MinValue && i <= kUint64MaxValue;

  // **** ByteData Getters

  int getInt8(int rIndex) => _bd.getInt8(rIndex);
  int getUint8(int rIndex) => _bd.getUint8(rIndex);

  int getInt16(int rIndex) ;
  int getInt32(int rIndex);
  int getInt64(int rIndex);

  int getUint16(int rIndex);
  int getUint32(int rIndex);
  int getUint64(int rIndex);

  double getFloat32(int rIndex);
  double getFloat64(int rIndex);

  // **** ByteData Setters

  void setInt8(int wIndex, int value) => _bd.setInt8(wIndex, value);
  void setInt16(int wIndex, int value);
  void setInt32(int wIndex, int value);
  void setInt64(int wIndex, int value);

  void setUint8(int wIndex, int value) => _bd.setUint8(wIndex, value);
  void setUint16(int wIndex, int value);
  void setUint32(int wIndex, int value);
  void setUint64(int wIndex, int value);

  void setFloat32(int wIndex, double value);
  void setFloat64(int wIndex, double value);

  static bool ignorePadding = true;
  static bool allowUnequalLengths = false;

  ByteData get bd => _bd;

  // **** Object overrides

  // **** TypedData interface.
  int get elementSizeInBytes => 1;
  int get offset => _bd.offsetInBytes;
//  int get offsetInBytes => _bd.offsetInBytes;
//  int get lengthInBytes => _bd.lengthInBytes;
  ByteBuffer get buffer => _bd.buffer;

  // **** Extensions

  bool _isAligned(int offset, int size) =>
      ((_bd.offsetInBytes + offset) % size) == 0;

  bool isAligned16(int offset) => _isAligned(offset, 2);
  bool isAligned32(int offset) => _isAligned(offset, 4);
  bool isAligned64(int offset) => _isAligned(offset, 8);

  // **** TypedData List Getters

  Int8List getInt8List([int offset = 0, int length]) =>
      new Int8List.fromList(_bd.buffer.asInt8List(offset, length ?? length));

  /// Returns an [Int16List] that is copied from _this_ starting a [offset]
  /// with [length].
  Int16List getInt16List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes ~/ Int16List.bytesPerElement;
    final list = new Int16List(length);
    for (var i = 0, j = offset; i < length; i++, j += 2) list[i] = getInt16(j);
    return list;
  }

  Int32List getInt32List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes ~/ Int32List.bytesPerElement;
    final list = new Int32List(length);
    for (var i = 0, j = offset; i < length; i++, j += 4) list[i] = getInt32(j);
    return list;
  }

  Int64List getInt64List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes ~/ Int64List.bytesPerElement;
    final list = new Int64List(length);
    for (var i = 0, j = offset; i < length; i++, j += 8) list[i] = getInt64(j);
    return list;
  }

  // **** Unsigned Integer List
  Uint8List getUint8List([int offset = 0, int length]) =>
      new Uint8List.fromList(_bd.buffer.asUint8List(offset, length ?? length));

  Uint16List getUint16List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes ~/ Uint16List.bytesPerElement;
    final list = new Uint16List(length);
    for (var i = 0, j = offset; i < length; i++, j += 2) list[i] = getUint16(j);
    return list;
  }

  Uint32List getUint32List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes ~/ Uint32List.bytesPerElement;
    final list = new Uint32List(length);
    for (var i = 0, j = offset; i < length; i++, j += 4) list[i] = getUint32(j);
    return list;
  }

  Uint64List getUint64List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes ~/ Uint64List.bytesPerElement;
    final list = new Uint64List(length);
    for (var i = 0, j = offset; i < length; i++, j += 8) list[i] = getUint64(j);
    return list;
  }

  // **** Float Lists

  Float32List getFloat32List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes;
    final list = new Float32List(length);
    for (var i = 0, j = offset; i < length; i++, j += 4)
      list[i] = getFloat32(j);
    return list;
  }

  Float64List getFloat64List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes;
    final list = new Float64List(length);
    for (var i = 0, j = offset; i < length; i++, j += 8)
      list[i] = getFloat64(j);
    return list;
  }

  // **** TypedData Views

  /// Returns a [ByteData] view of _this_.
  ByteData asByteData([int offset = 0, int length]) {
    final start = _bd.offsetInBytes + offset;
    return _bd.buffer.asByteData(start, length ?? _bd.lengthInBytes);
  }

  Int8List asInt8List([int offset = 0, int length]) {
    final start = _bd.offsetInBytes + offset;
    return _bd.buffer.asInt8List(start, length ?? _bd.lengthInBytes);
  }

  Int16List asInt16List([int offset = 0, int length]) {
    final start = _bd.offsetInBytes + offset;
    length ??= _bd.lengthInBytes ~/ 2;
    return (isAligned16(start))
           ? _bd.buffer.asInt16List(start, length)
           : getInt16List(start, length);
  }

  Int32List asInt32List([int offset = 0, int length]) {
    final start = _bd.offsetInBytes + offset;
    length ??= _bd.lengthInBytes ~/ 4;
    return (isAligned32(start))
           ? _bd.buffer.asInt32List(start, length)
           : getInt32List(start, length);
  }

  Int64List asInt64List([int offset = 0, int length]) {
    final start = _bd.offsetInBytes + offset;
    length ??= _bd.lengthInBytes ~/ 8;
    return (isAligned64(start))
           ? _bd.buffer.asInt64List(start, length)
           : getInt64List(start, length);
  }

  Uint8List asUint8List([int offset = 0, int length]) {
    final start = _bd.offsetInBytes + offset;
    return _bd.buffer.asUint8List(start, length ?? _bd.lengthInBytes);
  }

  Uint16List asUint16List([int offset = 0, int length]) {
    final start = _bd.offsetInBytes + offset;
    length ??= _bd.lengthInBytes ~/ 2;
    return (isAligned16(start))
           ? _bd.buffer.asUint16List(start, length)
           : getUint16List(start, length);
  }

  Uint32List asUint32List([int offset = 0, int length]) {
    final start = _bd.offsetInBytes + offset;
    length ??= _bd.lengthInBytes ~/ 4;
    return (isAligned32(start))
           ? _bd.buffer.asUint32List(start, length)
           : getUint32List(start, length);
  }

  Uint64List asUint64List([int offset = 0, int length]) {
    final start = _bd.offsetInBytes + offset;
    length ??= _bd.lengthInBytes ~/ 8;
    return (isAligned64(start))
           ? _bd.buffer.asUint64List(start, length)
           : getUint64List(start, length);
  }

  Float32List asFloat32List([int offset = 0, int length]) {
    final start = _bd.offsetInBytes + offset;
    length ??= _bd.lengthInBytes ~/ 4;
    return (isAligned32(start))
           ? _bd.buffer.asFloat32List(start, length)
           : getFloat32List(start, length);
  }

  Float64List asFloat64List([int offset = 0, int length]) {
    final start = _bd.offsetInBytes + offset;
    length ??= _bd.lengthInBytes ~/ 8;
    return (isAligned64(start))
           ? _bd.buffer.asFloat64List(start, length)
           : getFloat64List(start, length);
  }

  // **** String getters

  String getAscii({int offset = 0, int length, bool allowInvalid: true}) =>
      _getAscii(offset, length ?? _bd.lengthInBytes, allowInvalid);

  List<String> getAsciiList(
      {int offset = 0, int length, bool allowInvalid: true}) =>
      _getAscii(offset, length, allowInvalid).split('\\');

  String _getAscii(int offset, int length, bool allowInvalid) =>
      ascii.decode(asUint8List(offset, length), allowInvalid: allowInvalid);

  /// Returns a UTF-8 [String].
  String getUtf8({int offset = 0, int length, bool allowMalformed: true}) =>
      _getUtf8(offset, length ?? _bd.lengthInBytes, allowMalformed);

  List<String> getUtf8List(
      {int offset = 0, int length, bool allowMalformed: true}) =>
      _getUtf8(offset, length ??_bd.lengthInBytes, allowMalformed).split('\\');

  String _getUtf8(int offset, int length, bool allowMalformed) =>
      utf8.decode(asUint8List(offset, length), allowMalformed: allowMalformed);

  /// Returns a UTF-8 [String].
  String getString([int offset = 0, int length]) => getUtf8(
      offset: offset,
      length: length ??= _bd.lengthInBytes,
      allowMalformed: true);

  List<String> getStringList([int offset = 0, int length]) =>
      getUtf8List(offset: offset, length: length, allowMalformed: true);


  // **** String Setters

  void setAscii(int offset, String s, [int start = 0, int length]) {
    length ??= s.length;
    final v = (start == 0 && length == s.length)
              ? s
              : s.substring(start, offset + length);
    setUint8List(offset, ascii.encode(v), start, length);
  }

  void setUtf8(int offset, String s, [int start = 0, int length]) {
    length ??= s.length;
    final v = (start == 0 && length == s.length)
              ? s
              : s.substring(start, start + length);
    setUint8List(offset, ascii.encode(v), start, length);
  }

  void setString(int offset, String s, [int start = 0, int length]) =>
      setUtf8(offset, s, start, length);

  // **** TypedData List Setters

/*
  void setBytes(int offset, Bytes bytes, [int start = 0, int length]) =>
    setBytesData(this,)
    length ??= bytes.length;
    _checkLength(offset, length, kUint8Size);
    for (var i = offset; i < length ?? bytes.length; i++)
      _bd.setUint8(offset + i, bytes[i]);
  }
*/

  void setByteData(ByteData bd, [int offset = 0, int length]) {
    length ??= bd.lengthInBytes;
    _checkLength(offset, length, kUint8Size);
    for (var i = offset; i < length; i++) _bd.setUint8(i, bd.getUint8(i));
  }



  void setInt8List(Int8List list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kInt8Size);
    for (var i = offset; i < length ?? list.length; i++)
      _bd.setInt8(i, list[i]);
  }

  void setInt16List(Int16List list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kInt16Size);
    for (var i = offset; i < length ?? list.length; i++)
      _bd.setInt16(i, list[i]);
  }

  void setInt32List(Int32List list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kInt32Size);
    for (var i = offset; i < length ?? list.length; i++)
      _bd.setInt32(i, list[i]);
  }

  void setInt64List(Int64List list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kInt64Size);
    for (var i = offset; i < length ?? list.length; i++)
      _bd.setInt64(i, list[i]);
  }

  void setUint8List(int offset, Uint8List list, [int start = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kUint8Size);
    for (var i = 0, j = offset; i < length ?? list.length; i++, j++)
      _bd.setUint8(j, list[i]);
  }


  void setUint16List(Uint16List list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kUint16Size);
    for (var i = offset; i < length ?? list.length; i++)
      _bd.setUint16(i, list[i]);
  }

  void setUint32List(Uint32List list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kUint32Size);
    for (var i = offset; i < length ?? list.length; i++)
      _bd.setUint32(i, list[i]);
  }

  void setUint64List(Uint64List list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kUint64Size);
    for (var i = offset; i < length ?? list.length; i++)
      _bd.setUint64(i, list[i]);
  }

  void setFloat32List(Float32List list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kFloat32Size);
    for (var i = offset; i < length ?? list.length; i++)
      _bd.setFloat32(i, list[i]);
  }

  void setFloat64List(Float64List list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kFloat64Size);
    for (var i = offset; i < length ?? list.length; i++)
      _bd.setFloat64(i, list[i]);
  }

  void _checkLength(int offset, int length, int size) {
    final lLength = length * size;
    final bLength = _bd.lengthInBytes - (_bd.offsetInBytes + offset);
    if (length > bLength)
      throw new RangeError('List ($lLength bytes) is to large for '
                               'Bytes($bLength bytes');
  }

  // **** String Setters

  String _toString(List<String> sList, int offset, int length) {
    final v = (offset == 0 && length == sList.length)
              ? sList
              : sList.sublist(offset, offset + length);
    return v.join('\\');
  }

  int setAsciiList(int offset, List<String> sList,
                   [int start = 0, int length]) {
    final s = _toString(sList, start, length ??= sList.length);
    setAscii(offset, s, start, s.length);
    return s.length;
  }

  int setUtf8List(int offset, List<String> sList, [int start = 0, int length]) {
    final s = _toString(sList, start, length ??= sList.length);
    setUtf8(offset, s, start, s.length);
    return s.length;
  }

  static const int kMinLength = 16;
  static const int kDefaultLength = 1024;

  static const int kInt8Size = 1;
  static const int kInt16Size = 2;
  static const int kInt32Size = 4;
  static const int kInt64Size = 8;

  static const int kUint8Size = 1;
  static const int kUint16Size = 2;
  static const int kUint32Size = 4;
  static const int kUint64Size = 8;

  static const int kFloat32Size = 4;
  static const int kFloat64Size = 8;

  static const int kInt8MinValue = -0x7F - 1;
  static const int kInt16MinValue = -0x7FFF - 1;
  static const int kInt32MinValue = -0x7FFFFFFF - 1;
  static const int kInt64MinValue = -0x7FFFFFFFFFFFFFFF - 1;

  static const int kUint8MinValue = 0;
  static const int kUint16MinValue = 0;
  static const int kUint32MinValue = 0;
  static const int kUint64MinValue = 0;

  static const int kInt8MaxValue = 0x7F;
  static const int kInt16MaxValue = 0x7FFF;
  static const int kInt32MaxValue = 0x7FFFFFFF;
  static const int kInt64MaxValue = 0x7FFFFFFFFFFFFFFF;

  static const int kUint8MaxValue = 0xFF;
  static const int kUint16MaxValue = 0xFFFF;
  static const int kUint32MaxValue = 0xFFFFFFFF;
  static const int kUint64MaxValue = 0xFFFFFFFFFFFFFFFF;

  @override
  String toString() {
    final start = _bd.offsetInBytes;
    final length = _bd.lengthInBytes;
    final end = start + length;
    return '$runtimeType: $endianness $start-$end:$length';
  }
}
