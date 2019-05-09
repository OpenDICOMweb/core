// Copyright (c) 2016, 2017, 2018, 2019 Open DICOMweb Project.
// All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

mixin LittleEndianMixin {
  Uint8List get buf;
  ByteData get bd;

 // static const Endian endian = Endian.little;

  String get endianness =>  'LE';

  // **** Public Getters

  /// Returns an 8-bit integer values at `index = [buf].offsetInBytes + [i]`
  /// in the underlying [Uint8List]. _Note_: [i] may be negative.
  int getInt8(int i) => buf[i];

  int getInt16(int i) => bd.getInt16(i, Endian.little);
  int getInt32(int i) => bd.getInt32(i, Endian.little);
  int getInt64(int i) => bd.getInt64(i, Endian.little);

  Int32x4 getInt32x4(int offset) {
    _checkRange(offset, 16);
    var i = offset;
    final w = bd.getInt32(i, Endian.little);
    final x = bd.getInt32(i += 4, Endian.little);
    final y = bd.getInt32(i += 4, Endian.little);
    final z = bd.getInt32(i += 4, Endian.little);
    return Int32x4(w, x, y, z);
  }


  /// Returns an 8-bit unsigned integer values at
  ///     `index = [buf].offsetInBytes + [i]`
  /// in the underlying [Uint8List].
  /// _Note_: [i] may be negative.
  int getUint8(int i) => buf[i];
  int getUint16(int i) => bd.getUint16(i, Endian.little);
  int getUint32(int i) => bd.getUint32(i, Endian.little);
  int getUint64(int i) => bd.getUint64(i, Endian.little);

  double getFloat32(int i) => bd.getFloat32(i, Endian.little);

  Float32x4 getFloat32x4(int index) {
    _checkRange(index, 16);
    var i = index;
    final w = bd.getFloat32(i, Endian.little);
    final x = bd.getFloat32(i += 4, Endian.little);
    final y = bd.getFloat32(i += 4, Endian.little);
    final z = bd.getFloat32(i += 4, Endian.little);
    return Float32x4(w, x, y, z);
  }

  double getFloat64(int i) => bd.getFloat64(i, Endian.little);

  Float64x2 getFloat64x2(int index) {
    _checkRange(index, 16);
    var i = index;
    final x = bd.getFloat64(i, Endian.little);
    final y = bd.getFloat64(i += 8, Endian.little);
    return Float64x2(x, y);
  }

  void _checkRange(int offset, int sizeInBytes) =>
      __checkRange(offset, sizeInBytes, buf);
}

mixin BigEndianMixin {
  Uint8List get buf;
  ByteData get bd;

  // static const Endian endian = Endian.big;

  String get endianness =>  'LE';

  // **** Public Getters

  /// Returns an 8-bit integer values at `index = [buf].offsetInBytes + [i]`
  /// in the underlying [Uint8List]. _Note_: [i] may be negative.
  int getInt8(int i) => buf[i];

  int getInt16(int i) => bd.getInt16(i, Endian.big);
  int getInt32(int i) => bd.getInt32(i, Endian.big);
  int getInt64(int i) => bd.getInt64(i, Endian.big);

  Int32x4 getInt32x4(int offset) {
    _checkRange(offset, 16);
    var i = offset;
    final w = bd.getInt32(i, Endian.big);
    final x = bd.getInt32(i += 4, Endian.big);
    final y = bd.getInt32(i += 4, Endian.big);
    final z = bd.getInt32(i += 4, Endian.big);
    return Int32x4(w, x, y, z);
  }


  /// Returns an 8-bit unsigned integer values at
  ///     `index = [buf].offsetInBytes + [i]`
  /// in the underlying [Uint8List].
  /// _Note_: [i] may be negative.
  int getUint8(int i) => buf[i];
  int getUint16(int i) => bd.getUint16(i, Endian.big);
  int getUint32(int i) => bd.getUint32(i, Endian.big);
  int getUint64(int i) => bd.getUint64(i, Endian.big);

  double getFloat32(int i) => bd.getFloat32(i, Endian.big);

  Float32x4 getFloat32x4(int index) {
    _checkRange(index, 16);
    var i = index;
    final w = bd.getFloat32(i, Endian.big);
    final x = bd.getFloat32(i += 4, Endian.big);
    final y = bd.getFloat32(i += 4, Endian.big);
    final z = bd.getFloat32(i += 4, Endian.big);
    return Float32x4(w, x, y, z);
  }

  double getFloat64(int i) => bd.getFloat64(i, Endian.big);

  Float64x2 getFloat64x2(int index) {
    _checkRange(index, 16);
    var i = index;
    final x = bd.getFloat64(i, Endian.big);
    final y = bd.getFloat64(i += 8, Endian.big);
    return Float64x2(x, y);
  }

  void _checkRange(int offset, int sizeInBytes) =>
      __checkRange(offset, sizeInBytes, buf);
}

void __checkRange(int offset, int sizeInBytes, Uint8List buf) {
  final length = offset + sizeInBytes;
  if (length > buf.length)
    throw RangeError('$length is larger then bytes remaining $buf.length');
}
