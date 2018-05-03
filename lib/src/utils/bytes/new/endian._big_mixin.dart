//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

abstract class BEBytesMixin {
  ByteData get _bd;

  Endian get endian => Endian.big;

  String get endianness => 'Endian.big';

// **** Little Endian ByteData Getters

  int getInt16(int rIndex) => _bd.getInt16(rIndex, Endian.big);
  int getInt32(int rIndex) => _bd.getInt32(rIndex, Endian.big);
  int getInt64(int rIndex) => _bd.getInt64(rIndex, Endian.big);

  int getUint16(int rIndex) => _bd.getUint16(rIndex, Endian.big);
  int getUint32(int rIndex) => _bd.getUint32(rIndex, Endian.big);
  int getUint64(int rIndex) => _bd.getUint64(rIndex, Endian.big);

  double getFloat32(int rIndex) => _bd.getFloat32(rIndex, Endian.big);
  double getFloat64(int rIndex) => _bd.getFloat64(rIndex, Endian.big);

// **** Little Endian ByteData Setters

  void setInt16(int wIndex, int value) =>
      _bd.setInt16(wIndex, value, Endian.big);
  void setInt32(int wIndex, int value) =>
      _bd.setInt32(wIndex, value, Endian.big);
  void setInt64(int wIndex, int value) =>
      _bd.setInt64(wIndex, value, Endian.big);

  void setUint16(int wIndex, int value) =>
      _bd.setUint16(wIndex, value, Endian.big);
  void setUint32(int wIndex, int value) =>
      _bd.setUint32(wIndex, value, Endian.big);
  void setUint64(int wIndex, int value) =>
      _bd.setUint64(wIndex, value, Endian.big);

  void setFloat32(int wIndex, double value) =>
      _bd.setFloat32(wIndex, value, Endian.big);

  void setFloat64(int wIndex, double value) =>
      _bd.setFloat64(wIndex, value, Endian.big);

  static const Endian kEndian = Endian.big;
}
