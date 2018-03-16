// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

// TODO: defer loading of convert
// TODO: Unit Test
// TODO: Document
// TODO: Decide if Growable should be Merged with Bytes
// TODO: Create primitive version using only ByteBuffer
// TODO: Decide whether Bytes should extend List

// TODO: Figure out the best way to be closed over [endian] in order to avoid
//       having it as a local variable. It seams like ByteData primitives
//       should be divided into getUintXLittleEndian and getUintXBigEndian

/// [Bytes] is a class that provides a read-only byte array that supports both
/// [Uint8List] and [ByteData] interfaces.
class Bytes extends ListBase<int> implements TypedData {
  ByteData _bd;

  /// Creates a new [Bytes]. If [length] is not specified it defaults
  /// to [kDefaultLength]. If [endian] is not specified it defaults to
  /// [Endian.little].
  factory Bytes(int length, [Endian endian = Endian.little]) =>
      (endian == Endian.little)
          ? new BytesLittleEndian(length)
          : new BytesBigEndian(length);

  Bytes._(int length) : _bd = new ByteData(length);

  Bytes._fromBD(this._bd);

  /// Creates a new [Bytes] from [bytes] of [length], starting at the current
  /// [bytes].[offset] plus [offset]. If [length]
  /// is not specified it defaults to [length] of [bytes] minus [offset].
  /// if [offset] is not specified it defaults to 0. if of the
  /// to [kDefaultLength]. The new Bytes has the same [Endian]ness as [bytes].
  Bytes.from(Bytes bytes, int offset, int length)
      : _bd = bytes.asByteData(offset, length ?? bytes.lengthInBytes);

  Bytes.fromList(List<int> list)
      : _bd = (list is Uint8List)
            ? list.buffer.asByteData()
            : (new Uint8List.fromList(list)).buffer.asByteData();

  Bytes.view(Bytes bytes, int offset, int length)
      : _bd = bytes.asByteData(offset, length ?? bytes.lengthInBytes);

  factory Bytes.typedDataView(TypedData td,
          {int offset = 0, int length, Endian endian = Endian.little}) =>
      (endian == Endian.little)
          ? new BytesLittleEndian.typedDataView(td, offset, length)
          : new BytesBigEndian.typedDataView(td, offset, length);

  @override
  int operator [](int i) => _bd.getUint8(i);

  @override
  void operator []=(int i, int v) => _bd.setUint8(i, v);

  @override
  bool operator ==(Object other) {
    if (other is Bytes) {
      if (_bd.lengthInBytes != other._bd.lengthInBytes) return false;
      for (var i = 0; i < length; i++)
        if (_bd.getUint8(i) != other._bd.getUint8(i)) return false;
      return true;
    }
    return false;
  }

  //Returns the underlying [ByteBuffer] for _this_.
  ByteData get bd => _bd;

  Endian get endian => Endian.host;

  // Returns the absolute offset in the ByteBuffer.
  int _bdOffset([int offset = 0]) => _bd.offsetInBytes + offset;

  // Returns the absolute offset in the ByteBuffer.
  int _bdLength([int length]) => _bd.offsetInBytes + (length ?? 0);

  Uint8List _toUint8List([int offset, int length]) {
    offset ??= _bd.offsetInBytes;
    length ??= _bd.lengthInBytes;
    return _bd.buffer.asUint8List(offset, length);
  }

  // **** Object overrides

  /// Return the [hashCode] of the underlying [ByteData].
  @override
  int get hashCode => _bd.hashCode;

  // **** TypedData interface.

  @override
  int get elementSizeInBytes => 1;
  @override
  int get offsetInBytes => _bd.offsetInBytes;
  @override
  int get lengthInBytes => _bd.lengthInBytes;
  @override
  ByteBuffer get buffer => _bd.buffer;

  // *** List interface

  @override
  int get length => _bd.lengthInBytes;
  @override
  set length(int length) =>
      throw new UnsupportedError('$runtimeType: length is not modifiable');

  // **** Extensions

  bool _isAligned(int offset, int size) =>
      ((_bd.offsetInBytes + offset) % size) == 0;

  bool isAligned16(int offset) => _isAligned(offset, 2);
  bool isAligned32(int offset) => _isAligned(offset, 4);
  bool isAligned64(int offset) => _isAligned(offset, 8);

  /// The [offsetInBytes] of the underlying [ByteData].
  int get offset => _bd.offsetInBytes;

  // **** ByteData Getters

  int getInt8(int rIndex) => _bd.getInt8(rIndex);

  int getUint8(int rIndex) => _bd.getUint8(rIndex);

  int getUint16(int rIndex) => _bd.getUint16(rIndex, endian);

  int getInt16(int rIndex) => _bd.getInt16(rIndex, endian);

  int getUint32(int rIndex) => _bd.getUint32(rIndex, endian);

  int getInt32(int rIndex) => _bd.getInt32(rIndex, endian);

  int getUint64(int rIndex) => _bd.getUint64(rIndex, endian);

  int getInt64(int rIndex) => _bd.getInt64(rIndex, endian);

  double getFloat32(int rIndex) => _bd.getFloat32(rIndex, endian);

  double getFloat64(int rIndex) => _bd.getFloat64(rIndex, endian);

  // **** TypedData List Getters

  Int8List getInt8List([int offset = 0, int length]) =>
      new Int8List.fromList(_bd.buffer.asInt8List(offset, length ?? length));

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

  //TODO: does this align optimization improve performance
  Float64List getFloat64List([int offset = 0, int length]) {
    length ??= _bd.lengthInBytes;
    final list = new Float64List(length);
    for (var i = 0, j = offset; i < length; i++, j += 8)
      list[i] = getFloat64(j);
    return list;
  }

  // **** String getters
  // TODO: decide if these should be included
  String getAscii([int offset = 0, int length]) =>
      ascii.decode(asUint8List(offset, length ?? lengthInBytes));

  String getUtf8([int offset = 0, int length]) =>
      utf8.decode(asUint8List(offset, length ?? lengthInBytes));

/*
  String getString({int offset, int length, bool useAscii = false}) =>
      decodeString(_toUint8List(
          offset ?? _bd.offsetInBytes, length ?? _bd.lengthInBytes));
*/

  /// The various methods that are named _as_... return a _view_ of the
  /// underlying [ByteData] buffer.

  /// Returns a view of _this_.
  Bytes asBytes([int offset = 0, int length]) =>
      new Bytes.view(this, _bdOffset(offset), length ?? lengthInBytes);

  ByteData asByteData([int offset = 0, int length]) =>
      _bd.buffer.asByteData(_bdOffset(offset), length ?? _bd.lengthInBytes);

  Int8List asInt8List([int offset = 0, int length]) =>
      _bd.buffer.asInt8List(_bdOffset(offset), length ?? _bd.lengthInBytes);

  Int16List asInt16List([int offset = 0, int length]) => (isAligned16(offset))
      ? _bd.buffer
          .asInt16List(_bdOffset(offset), length ?? (_bd.lengthInBytes ~/ 2))
      : getInt16List(offset, length);

  Int32List asInt32List([int offset = 0, int length]) => (isAligned32(offset))
      ? _bd.buffer
          .asInt32List(_bdOffset(offset), length ?? (_bd.lengthInBytes ~/ 4))
      : getInt32List(offset, length);

  Int64List asInt64List([int offset = 0, int length]) => (isAligned64(offset))
      ? _bd.buffer
          .asInt64List(_bdOffset(offset), length ?? (_bd.lengthInBytes ~/ 8))
      : getInt64List(offset, length);

  Uint8List asUint8List([int offset = 0, int length]) =>
      _bd.buffer.asUint8List(_bdOffset(offset), length ?? _bd.lengthInBytes);

  Uint16List asUint16List([int offset = 0, int length]) => (isAligned16(offset))
      ? _bd.buffer
          .asUint16List(_bdOffset(offset), length ?? (_bd.lengthInBytes ~/ 2))
      : getUint16List(offset, length);

  Uint32List asUint32List([int offset = 0, int length]) => (isAligned32(offset))
      ? _bd.buffer
          .asUint32List(_bdOffset(offset), length ?? (_bd.lengthInBytes ~/ 4))
      : getUint32List(offset, length);

  Uint64List asUint64List([int offset = 0, int length]) => (isAligned64(offset))
      ? _bd.buffer
          .asUint64List(_bdOffset(offset), length ?? (_bd.lengthInBytes ~/ 8))
      : getUint64List(offset, length);

  Float32List asFloat32List([int offset = 0, int length]) =>
      (isAligned32(offset))
          ? _bd.buffer.asFloat32List(
              _bdOffset(offset), length ?? (_bd.lengthInBytes ~/ 4))
          : getFloat32List(offset, length);

  Float64List asFloat64List([int offset = 0, int length]) =>
      (isAligned64(offset))
          ? _bd.buffer.asFloat64List(
              _bdOffset(offset), length ?? (_bd.lengthInBytes ~/ 8))
          : getFloat64List(offset, length);

  List<String> asAsciiList([int offset = 0, int length]) =>
      getAscii(offset, length).split('\\');

  List<String> asUtf8List([int offset = 0, int length]) =>
      getUtf8(offset, length).split('\\');

/*
  List<String> asStringList([int offset = 0, int length]) =>
      (defaultToAscii)
          ? asAsciiList(offset, length)
          : asUtf8List(offset, length);
*/

  // **** ByteData Setters

  void setInt8(int wIndex, int value) => _bd.setInt8(wIndex, value);

  void setUint8(int wIndex, int value) => _bd.setUint8(wIndex, value);

  void setUint16(int wIndex, int value) => _bd.setUint16(wIndex, value, endian);

  void setInt16(int wIndex, int value) => _bd.setInt16(wIndex, value, endian);

  void setUint32(int wIndex, int value) => _bd.setUint32(wIndex, value, endian);

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

  /// The minimum [length] of any [Bytes] object.

  /// The default [length] of a [Bytes] created without an explicit length.
  static const int kDefaultLength = 1024;

  /// The default maximum [length] of any [Bytes] object.
  static const int kDefaultLimit = k1GB;

  /// The default [Endian]ness of a [Bytes] object.
  static const Endian kDefaultEndian = Endian.little;

  static final Bytes kEmptyBytes = new Bytes(0);

  static Bytes fromStrings(List<String> sList,
      {bool asAscii = false, Endian endian = Endian.little}) {
    final s = sList.join('\\');
    final Uint8List bytes = (asAscii) ? ascii.encode(s) : utf8.encode(s);
    return (endian == Endian.little)
        ? new BytesLittleEndian.typedDataView(bytes)
        : new BytesBigEndian.typedDataView(bytes);
  }

  static Bytes fromBase64(String s, [Endian endian = Endian.little]) {
    final bytes = base64.decode(s);
    return (endian == Endian.little)
        ? new BytesLittleEndian.typedDataView(bytes)
        : new BytesBigEndian.typedDataView(bytes);
  }
}

class BytesLittleEndian extends Bytes {
  BytesLittleEndian([int length = Bytes.kDefaultLength]) : super._(length);

  BytesLittleEndian.from(Bytes bytes, [int offset = 0, int length])
      : super.from(bytes, offset, length);

  BytesLittleEndian.fromList(List<int> list) : super.fromList(list);

  BytesLittleEndian.view(Bytes bytes, [int offset = 0, int length])
      : super.view(bytes, offset, length);

  BytesLittleEndian.typedDataView(TypedData td, [int offset = 0, int length])
      : super._fromBD(td.buffer.asByteData(offset, length ?? td.lengthInBytes));

  @override
  BytesLittleEndian sublist(int start, [int end]) =>
      new BytesLittleEndian.from(this, start, end ?? length);

  @override
  Endian get endian => Endian.little;
}

class BytesBigEndian extends Bytes {
  BytesBigEndian([int length = Bytes.kDefaultLength]) : super._(length);

  BytesBigEndian.from(Bytes bytes, [int offset = 0, int length])
      : super.from(bytes, offset, length);

  BytesBigEndian.fromList(List<int> list) : super.fromList(list);

  BytesBigEndian.view(Bytes bytes, [int offset = 0, int length])
      : super.view(bytes, offset, length);

  BytesBigEndian.typedDataView(TypedData td, [int offset = 0, int length])
      : super._fromBD(td.buffer.asByteData(offset, length ?? td.lengthInBytes));
  @override
  BytesLittleEndian sublist(int start, [int end]) =>
      new BytesLittleEndian.from(this, start, end ?? length);

  @override
  Endian get endian => Endian.big;
}

class GrowableBytes extends Bytes {
  /// Returns a new [Bytes] of [length].
  factory GrowableBytes(int length, [Endian endian = Endian.little]) =>
      (endian == Endian.little)
          ? new GrowableBytesLittleEndian(length)
          : new GrowableBytesBigEndian(length);

  GrowableBytes._(int length) : super._(length);

  GrowableBytes._fromBD(ByteData bd) : super._fromBD(bd);

  factory GrowableBytes.typedDataView(TypedData td,
          {int limit = k1GB, Endian endian = Endian.little}) =>
      (endian == Endian.little)
          ? new GrowableBytesLittleEndian.typedDataView(td, limit)
          : new GrowableBytesBigEndian.typedDataView(td, limit);

  /// The upper bound on the length of this [Bytes]. If [limit]
  /// is _null_ then its length cannot be changed.
  int get limit => kDefaultLimit;

  @override
  set length(int newLength) => (newLength < _bd.lengthInBytes)
      ? _bd.buffer.asByteData(_bd.offsetInBytes, newLength)
      : grow(newLength);

  /// Ensures that [bd] is at least [length] long, and grows
  /// the buf if necessary, preserving existing data.
  bool ensureLength(int length) =>
      (length > _bd.lengthInBytes) ? grow(limit) : false;

  /// If [minLength] is greater than the current length of the buffer,
  /// then a new buffer at least double the size of the current buffer is
  /// created, and the contents of the current buffer are copied into it.
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

    if (_isMaxCapacityExceeded(newLength, limit)) return false;

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

  static const int kMinLength = 1024;
  static const int kDefaultLimit = k1GB;
}

class GrowableBytesLittleEndian extends GrowableBytes {
  GrowableBytesLittleEndian([int length = Bytes.kDefaultLength])
      : super._(length);

  GrowableBytesLittleEndian.typedDataView(TypedData td,
      [int offset = 0, int length])
      : super._fromBD(td.buffer.asByteData(offset, length));

  @override
  BytesLittleEndian sublist(int start, [int end]) =>
      new BytesLittleEndian.from(this, start, end ?? length);

  @override
  Endian get endian => Endian.little;
}

class GrowableBytesBigEndian extends GrowableBytes {
  GrowableBytesBigEndian([int length = Bytes.kDefaultLength]) : super._(length);

  GrowableBytesBigEndian.typedDataView(TypedData td,
      [int offset = 0, int length])
      : super._fromBD(td.buffer.asByteData(offset, length));

  @override
  Endian get endian => Endian.big;
}

// ***  Internals

bool _isMaxCapacityExceeded(int length, int maxLength) => length >= maxLength;

const int k1GB = 1024 * 1024 * 1024;
