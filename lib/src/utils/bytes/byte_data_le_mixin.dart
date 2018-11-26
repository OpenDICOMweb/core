//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

// ignore_for_file: public_member_api_docs

// Move to global
bool showByteValues = false;
int truncateBytesLength = 16;

/// [BytesMixin] is a class that provides a read-only byte array that
/// supports both [Uint8List] and [ByteData] interfaces.
mixin ByteDataLEMixin {
  ByteData get bd;

  Endian get endian => Endian.little;

  String get endianness => 'LE';

  /// Returns an 8-bit integer values at [offset].
  int getInt16(int offset) => bd.getInt16(offset, Endian.little);
  int getInt32(int offset) => bd.getInt32(offset, Endian.little);
  int getInt64(int offset) => bd.getInt64(offset, Endian.little);

  int getUint16(int offset) => bd.getUint16(offset, Endian.little);
  int getUint32(int offset) => bd.getUint32(offset, Endian.little);
  int getUint64(int offset) => bd.getUint64(offset, Endian.little);

  double getFloat32(int offset) => bd.getFloat32(offset, Endian.little);
  double getFloat64(int offset) => bd.getFloat64(offset, Endian.little);

  void setInt16(int offset, int value) =>
      bd.setInt16(offset, value, Endian.little);
  void setInt32(int offset, int value) =>
      bd.setInt32(offset, value, Endian.little);
  void setInt64(int offset, int value) =>
      bd.setInt64(offset, value, Endian.little);

  void setUint16(int offset, int value) =>
      bd.setUint16(offset, value, Endian.little);
  void setUint32(int offset, int value) =>
      bd.setUint32(offset, value, Endian.little);
  void setUint64(int offset, int value) =>
      bd.setUint64(offset, value, Endian.little);

  void setFloat32(int offset, double value) =>
      bd.setFloat32(offset, value, Endian.little);
  void setFloat64(int offset, double value) =>
      bd.setFloat64(offset, value, Endian.little);
}
