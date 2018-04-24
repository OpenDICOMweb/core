//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
library odw.sdk.utils.bytes;

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:core/src/base.dart';
import 'package:core/src/system.dart';
import 'package:core/src/utils.dart';

part 'package:core/src/utils/bytes/dicom_bytes.dart';

const int _k1GB = 1024 * 1024 * 1024;
const int kMinLength = 16;
const int kDefaultLength = 1024;
const int kDefaultLimit = _k1GB;

const Endian kDefaultEndian = Endian.little;

// TODO: unit test
// TODO: Figure out the best way to be closed over [endian] in order to avoid
//       having it as a local variable. It seams like ByteData primitives
//       should be divided into getUintXLittleEndian and getUintXBigEndian

/// [Bytes] is a class that provides a read-only byte array that supports both
/// [Uint8List] and [ByteData] interfaces.
class Bytes extends ListBase<int> {
  ByteData _bd;
  Endian endian;

  /// Returns a
  Bytes([int length, this.endian = Endian.little])
      : _bd = new ByteData(length ?? kDefaultLength);

  Bytes._(int length, Endian endian)
      : endian = endian ?? Endian.host,
        _bd = new ByteData(length ?? kDefaultLength);

  Bytes.from(Bytes bytes, [int offset = 0, int length, Endian endian])
      : endian = endian ?? Endian.host,
        _bd = bytes.asByteData(offset ?? bytes.offset, length ?? bytes.length);

  Bytes._from(Bytes bytes, int start, int length, Endian endian)
      : endian = endian ?? bytes.endian,
        _bd = bytes.asByteData(start, length);

  Bytes.fromList(List<int> list, [Endian endian = Endian.little])
      : endian = endian ?? Endian.little,
        _bd = (list is Uint8List)
            ? list.buffer.asByteData()
            : (new Uint8List.fromList(list)).buffer.asByteData();

  factory Bytes.typedDataView(TypedData td,
          [int offset = 0, int length, Endian endian = Endian.little]) =>
      new Bytes._tdView(td, offset, length, endian ?? Endian.host);

  Bytes._tdView(
      TypedData td, int offset, int lengthInBytes, Endian endian)
      : endian = endian ?? Endian.little,
        _bd = td.buffer.asByteData(td.offsetInBytes + offset, lengthInBytes);

  Bytes.__bd(ByteData bd,
      [int offset = 0, int length, Endian endian = Endian.little])
      : endian = endian ?? Endian.little,
        _bd = _toByteData(bd, offset, length);

  // [offset] is from bd[0] and must be inRange. [offset] + [length]
  // must be less than bd.lengthInBytes
  static ByteData _toByteData(ByteData bd, [int offset = 0, int length]) =>
      bd.buffer.asByteData(offset, length);

  // Returns the absolute offset in the ByteBuffer.
  int _bdOffset(int offset) => _bd.offsetInBytes + offset;

  /// Returns a view of _this_.
  Bytes subbytes([int start = 0, int end]) =>
      new Bytes.__bd(_bd, start, end - start);

  /// Returns a view of _this_.
  Bytes view([int offset = 0, int length, Endian endian]) => new Bytes.__bd(
      _bd, offset, length ??= this.length, endian ??= this.endian);

  /// Returns a view of _this_.
  Bytes toBytes([int offset = 0, int length, Endian endian = Endian.little]) =>
      new Bytes.__bd(_bd, offset, length, endian);

  @override
  int operator [](int i) => _bd.getUint8(i);

  @override
  void operator []=(int i, int v) => _bd.setUint8(i, v);

  @override
  bool operator ==(Object other) {
    if (other is Bytes) {
      final aLen = length;
      if (aLen != other.length) return false;
      for (var i = 0; i < aLen; i++) if (this[i] != other[i]) return false;
      return true;
    }
    return false;
  }

  bool ignorePadding = true;
  bool allowUnequalLengths = false;

  ByteData get bd => _bd;

  int get limit => length;

  // **** Object overrides

  @override
  int get hashCode {
    var hashCode = 0;
    for (var i = 0; i < length; i++) hashCode += _bd.getUint8(i) + i;
    return hashCode;
  }

  // **** TypedData interface.
  int get elementSizeInBytes => 1;
  int get offset => _bd.offsetInBytes;
//  int get offsetInBytes => _bd.offsetInBytes;
//  int get lengthInBytes => _bd.lengthInBytes;
  ByteBuffer get buffer => _bd.buffer;

  String get endianness =>
      (endian == Endian.little) ? 'Endian.little' : 'Endian.big';

  // *** List interface
  @override
  int get length => _length;
  int get _length => _bd.lengthInBytes;
  @override
  set length(int length) =>
      throw new UnsupportedError('$runtimeType: length is not modifiable');

  @override
  Bytes sublist(int start, [int end]) =>
      new Bytes.from(this, start, end ?? length, endian);

  // **** Extensions

  bool _isAligned(int offset, int size) =>
      ((_bd.offsetInBytes + offset) % size) == 0;

  bool isAligned16(int offset) => _isAligned(offset, 2);
  bool isAligned32(int offset) => _isAligned(offset, 4);
  bool isAligned64(int offset) => _isAligned(offset, 8);

  // **** ByteData Getters

  int getInt8(int rIndex) => _bd.getInt8(rIndex);

  int getUint8(int rIndex) => _getUint8(rIndex);
  int _getUint8(int rIndex) => _bd.getUint8(rIndex);

  int getUint16(int rIndex) => _getUint16(rIndex);
  int _getUint16(int rIndex) => _bd.getUint16(rIndex, endian);

  int getInt16(int rIndex) => _bd.getInt16(rIndex, endian);

  int getUint32(int rIndex) => _getUint32(rIndex);
  int _getUint32(int rIndex) => _bd.getUint32(rIndex, endian);

  int getInt32(int rIndex) => _bd.getInt32(rIndex, endian);

  int getUint64(int rIndex) => _bd.getUint64(rIndex, endian);

  int getInt64(int rIndex) => _bd.getInt64(rIndex, endian);

  double getFloat32(int rIndex) => _bd.getFloat32(rIndex, endian);

  double getFloat64(int rIndex) => _bd.getFloat64(rIndex, endian);

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

  // **** String getters

  /// Returns an ASCII [String].
  String getAscii({int offset = 0, int length, bool allowInvalid: true}) {
    length ??= this.length;
    return (length == 0)
        ? ''
        : ascii.decode(asUint8List(offset, length), allowInvalid: allowInvalid);
  }

  /// Returns a UTF-8 [String].
  String getUtf8({int offset = 0, int length, bool allowMalformed: true}) =>
      (length == 0) ? '' : utf8.decode(asUint8List(offset, length));

  /// Returns a UTF-8 [String].
  String getString([int offset = 0, int length]) =>
      getUtf8(offset: offset, length: length ??= this.length);

  // **** TypedData Views

  /// Returns a [ByteData] view of _this_.
  ByteData asByteData([int offset = 0, int length]) =>
      _bd.buffer.asByteData(offset, length ?? _bd.lengthInBytes);

  Int8List asInt8List([int offset = 0, int length]) =>
      _bd.buffer.asInt8List(offset, length ?? _bd.lengthInBytes);

  Int16List asInt16List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes ~/ 2;
    return (isAligned16(offset))
        ? _bd.buffer.asInt16List(_bdOffset(offset), length)
        : getInt16List(offset, length);
  }

  Int32List asInt32List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes ~/ 4;
    return (isAligned32(offset))
        ? _bd.buffer.asInt32List(_bdOffset(offset), length)
        : getInt32List(offset, length);
  }

  Int64List asInt64List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes ~/ 8;
    return (isAligned64(offset))
        ? _bd.buffer.asInt64List(_bdOffset(offset), length)
        : getInt64List(offset, length);
  }

  Uint8List asUint8List([int offset = 0, int length]) =>
      _bd.buffer.asUint8List(_bdOffset(offset), length ?? this.length);

  Uint16List asUint16List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes ~/ 2;
    return (isAligned16(offset))
        ? _bd.buffer.asUint16List(_bdOffset(offset), length)
        : getUint16List(offset, length);
  }

  Uint32List asUint32List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes ~/ 4;
    return (isAligned32(offset))
        ? _bd.buffer.asUint32List(_bdOffset(offset), length)
        : getUint32List(offset, length);
  }

  Uint64List asUint64List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes ~/ 8;
    return (isAligned64(offset))
        ? _bd.buffer.asUint64List(_bdOffset(offset), length)
        : getUint64List(offset, length);
  }

  Float32List asFloat32List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes ~/ 4;
    return (isAligned32(offset))
        ? _bd.buffer.asFloat32List(_bdOffset(offset), length)
        : getFloat32List(offset, length);
  }

  Float64List asFloat64List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes ~/ 8;
    return (isAligned64(offset))
        ? _bd.buffer.asFloat64List(_bdOffset(offset), length)
        : getFloat64List(offset, length);
  }

  List<String> asAsciiList([int offset = 0, int length]) =>
      getAscii(offset: offset, length: length ??= this.length).split('\\');

  List<String> asUtf8List([int offset = 0, int length]) =>
      getUtf8(offset: offset, length: length ??= this.length).split('\\');

  List<String> asStringList([int offset = 0, int length]) =>
      asUtf8List(offset, length);

  // **** ByteData Setters

  void setInt8(int wIndex, int value) => _bd.setInt8(wIndex, value);

  void setUint8(int wIndex, int value) => _setUint8(wIndex, value);
  void _setUint8(int wIndex, int value) => _bd.setUint8(wIndex, value);

  void setInt16(int wIndex, int value) => _bd.setInt16(wIndex, value, endian);

  void setUint16(int wIndex, int value) => _setUint16(wIndex, value);
  void _setUint16(int wIndex, int value) =>
      _bd.setUint16(wIndex, value, endian);

  void setUint32(int wIndex, int value) => _setUint32(wIndex, value);
  void _setUint32(int wIndex, int value) =>
      _bd.setUint32(wIndex, value, endian);

  void setInt32(int wIndex, int value) => _bd.setInt32(wIndex, value, endian);

  void setUint64(int wIndex, int value) => _bd.setUint64(wIndex, value, endian);

  void setInt64(int wIndex, int value) => _bd.setInt64(wIndex, value, endian);

  void setFloat32(int wIndex, double value) =>
      _bd.setFloat32(wIndex, value, endian);

  void setFloat64(int wIndex, double value) =>
      _bd.setFloat64(wIndex, value, endian);

  // **** String Setters

  void setAscii(String s, [int offset = 0, int length]) {
    length ??= s.length;
    final v = (offset == 0 && length == s.length)
        ? s
        : s.substring(offset, offset + length);
    setUint8List(ascii.encode(v), offset, length);
  }

  void setUtf8(String s, [int offset = 0, int length]) {
    length ??= s.length;
    final v = (offset == 0 && length == s.length)
        ? s
        : s.substring(offset, offset + length);
    setUint8List(ascii.encode(v), offset, length);
  }

  void setString(String s, [int offset = 0, int length]) =>
      setUtf8(s, offset, length);

  // **** TypedData List Setters

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

  void setUint8List(Uint8List list, [int offset = 0, int length]) {
    length ??= list.length;
    _checkLength(offset, length, kUint8Size);
    for (var i = offset; i < length ?? list.length; i++)
      _bd.setUint8(i, list[i]);
  }

  void setByteData(ByteData bd, [int offset = 0, int length]) {
    length ??= bd.lengthInBytes;
    _checkLength(offset, length, kUint8Size);
    for (var i = offset; i < length; i++) _bd.setUint8(i, bd.getUint8(i));
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

  int setAsciiList(List<String> sList, [int offset = 0, int length]) {
    final s = _toString(sList, offset, length ??= sList.length);
    setAscii(s, offset, s.length);
    return s.length;
  }

  int setUtf8List(
    List<String> sList, [
    int offset = 0,
    int length,
  ]) {
    final s = _toString(sList, offset, length ??= sList.length);
    setUtf8(s, offset, s.length);
    return s.length;
  }

  bool isInt8(int i) => i > kInt8MinValue && i <= kInt8MaxValue;
  bool isInt16(int i) => i > kInt16MinValue && i <= kInt16MaxValue;
  bool isInt32(int i) => i > kInt32MinValue && i <= kInt32MaxValue;
  bool isInt64(int i) => i > kInt64MinValue && i <= kInt64MaxValue;

  bool isUint8(int i) => i > kUint8MinValue && i <= kUint8MaxValue;
  bool isUint16(int i) => i > kUint16MinValue && i <= kUint16MaxValue;
  bool isUint32(int i) => i > kUint32MinValue && i <= kUint32MaxValue;
  bool isUint64(int i) => i > kUint64MinValue && i <= kUint64MaxValue;

  @override
  String toString() {
    final start = _bd.offsetInBytes;
    final length = _bd.lengthInBytes;
    final end = start + length;
    return '$runtimeType: $endianness $start-$end:$length';
  }

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

  static const int kDefaultLength = 1024;

  /// Returns a new [Bytes] containing the contents of [bd].
  static Bytes fromByteData(ByteData bd, {Endian endian = Endian.little}) =>
      new Bytes.typedDataView(bd, 0, bd.lengthInBytes, endian ?? Endian.little);

  /// Returns a [Bytes] buffer containing the contents of [File].
  // TODO: doAsync
  static Bytes fromFile(File file,
      {Endian endian = Endian.little, bool doAsync = false}) {
    final Uint8List bList = file.readAsBytesSync();
    return new Bytes.typedDataView(
        bList, 0, bList.length, endian ?? Endian.little);
  }

  /// Returns a [Bytes] buffer containing the contents of the
  /// [File] at [path].
  // TODO: add async
  static Bytes fromPath(String path,
          {Endian endian = Endian.little, bool doAsync = false}) =>
      fromFile(new File(path), endian: endian, doAsync: doAsync);

  static final Bytes kEmptyBytes = new Bytes(0);

  static Bytes base64Decode(String s) =>
      new Bytes.typedDataView(base64.decode(s));

  static String base64Encode(Bytes bytes) => base64.encode(bytes.asUint8List());

  static String asciiDecode(Bytes bytes, {bool allowInvalid = true}) =>
      ascii.decode(bytes.asUint8List(), allowInvalid: allowInvalid);

  static Bytes asciiEncode(String s) =>
      new Bytes.typedDataView(ascii.encode(s));

  static String utf8Decode(Bytes bytes, {bool allowMalformed = true}) =>
      utf8.decode(bytes.asUint8List(), allowMalformed: allowMalformed);

  static Bytes utf8Encode(String s) => new Bytes.typedDataView(ascii.encode(s));
}

class GrowableBytes extends Bytes {
  /// The upper bound on the length of this [Bytes]. If [limit]
  /// is _null_ then its length cannot be changed.
  @override
  final int limit;

  /// Returns a new [Bytes] of [length].
  factory GrowableBytes(int length,
          [Endian endian = Endian.little, int limit = kDefaultLimit]) =>
      new GrowableBytes(length, endian, limit);

  /// Returns a new [Bytes] of [length].
  GrowableBytes._(int length, Endian endian, int limit)
      : limit = limit ?? kDefaultLimit,
        super(length, endian);

  /// Returns a new [Bytes] starting at [offset] of [length].
  GrowableBytes.from(GrowableBytes bytes,
      [int offset = 0,
      int length,
      Endian endian = Endian.little,
      this.limit = _k1GB])
      : super.from(bytes, offset, length, endian);

  factory GrowableBytes.typedDataView(TypedData td,
          [int offset = 0,
          int lengthInBytes,
          Endian endian,
          int limit = kDefaultLimit]) =>
      new GrowableBytes._tdView(
          td, offset, lengthInBytes, endian, limit);

  GrowableBytes._tdView(
      TypedData td, int offset, int lengthInBytes, Endian endian, int limit)
      : limit = limit ?? _k1GB,
        super._tdView(td, offset, lengthInBytes, endian);

  set _length(int newLength) {
    if (newLength < _bd.lengthInBytes) return;
    grow(newLength);
  }

  /// Ensures that [_bd] is at least [length] long, and grows
  /// the buf if necessary, preserving existing data.
  bool ensureLength(int length) => (length > this.length) ? grow() : false;

  /// Creates a new buffer at least double the size of the current buffer,
  /// and copies the contents of the current buffer into it.
  ///
  /// If [minLength] is null the new buffer will be twice the size of the
  /// current buffer. If [minLength] is not null, the new buffer will be at
  /// least that size. It will always have at least have double the
  /// capacity of the current buffer.
  bool grow([int minLength]) {
    minLength ??= kMinLength;
    if (minLength <= _bd.lengthInBytes) return false;

    var newLength = _bd.lengthInBytes;
    while (newLength < minLength) newLength *= 2;

    if (newLength >= kDefaultLength) return false;

    final newBD = new ByteData(newLength);
    for (var i = 0; i < _bd.lengthInBytes; i++)
      newBD.setUint8(i, _bd.getUint8(i));
    _bd = newBD;
    return true;
  }

  bool checkAllZeros(int start, int end) {
    for (var i = start; i < end; i++) if (_bd.getUint8(i) != 0) return false;
    return true;
  }

  static int kMaximumLength = kDefaultLimit;
}
