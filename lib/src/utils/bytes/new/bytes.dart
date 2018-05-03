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
import 'package:core/src/utils/bytes/new/bytes_mixin.dart';
import 'package:core/src/utils/bytes/new/dicom_mixin.dart';
import 'package:core/src/utils/bytes/new/endian._big_mixin.dart';
import 'package:core/src/utils/bytes/new/endian_little_mixin.dart';
import 'package:core/src/system.dart';
import 'package:core/src/vr.dart';

part 'package:core/src/utils/bytes/new/dicom_bytes.dart';
part 'package:core/src/utils/bytes/new/evr.dart';
part 'package:core/src/utils/bytes/new/ivr.dart';
part 'package:core/src/utils/bytes/new/growable.dart';


/// [Bytes] is a class that provides a read-only byte array that supports both
/// [Uint8List] and [ByteData] interfaces.
class Bytes extends ListBase<int> {
  ByteData _bd;

  /// Returns a
  factory Bytes([int length, Endian endian]) =>
      (endian ?? Endian.host == Endian.little)
          ? new LEBytes(length)
          : new BEBytes(length);

  factory Bytes.from(Bytes bytes,
          [int offset = 0, int length, Endian endian]) =>
      (endian ?? Endian.host == Endian.little)
          ? new LEBytes._from(bytes, offset, length)
          : new BEBytes._from(bytes, offset, length);

  factory Bytes.typedDataView(TypedData td,
          [int offset = 0, int length, Endian endian = Endian.little]) =>
      (endian ?? Endian.host == Endian.little)
          ? new LEBytes._tdView(td, offset, length)
          : new BEBytes._tdView(td, offset, length);

  factory Bytes.fromList(List<int> list, [Endian endian = Endian.little]) =>
      (endian ?? Endian.host == Endian.little)
      ? new LEBytes.fromList(list)
      : new BEBytes.fromList(list);

  Bytes._(int length) : _bd = new ByteData(length);

  Bytes._from(Bytes bytes, int start, int length)
      : _bd = bytes._bd.buffer.asByteData(start, length);

  Bytes._fromList(List<int> list)
      : _bd = (list is Uint8List)
            ? list.buffer.asByteData()
            : (new Uint8List.fromList(list)).buffer.asByteData();

  Bytes._tdView(TypedData td, int offset, int lengthInBytes)
      : _bd = td.buffer.asByteData(td.offsetInBytes + offset, lengthInBytes);


  // *** List interface

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

  @override
  int get hashCode {
    var hashCode = 0;
    for (var i = 0; i < _bd.lengthInBytes; i++) hashCode += _bd.getUint8(i) + i;
    return hashCode;
  }

  @override
  int get length => _length;
  int get _length => _bd.lengthInBytes;
  @override
  set length(int length) =>
      throw new UnsupportedError('$runtimeType: length is not modifiable');

  @override
  Bytes sublist(int start, [int end]) =>
      new Bytes._from(this, start, end ?? length);

  /// Returns a view of _this_.
  Bytes view([int offset = 0, int length, Endian endian]) =>
      new Bytes._from(this, offset, length ??= this.length);

  static const int kMinLength = 16;
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

  @deprecated
  static Bytes base64Decode(String s) =>
      new Bytes.typedDataView(base64.decode(s));

  @deprecated
  static Bytes fromBase64(String s) =>
      new Bytes.typedDataView(base64.decode(s));

  @deprecated
  static String base64Encode(Bytes bytes) =>
      base64.encode(bytes._bd.buffer.asUint8List());

  static String toBase64(Bytes bytes) =>
      base64.encode(new Bytes.typedDataView(bytes._bd));

  static String asciiDecode(Bytes bytes, {bool allowInvalid = true}) => ascii
      .decode(new Bytes.typedDataView(bytes._bd), allowInvalid: allowInvalid);

  static Bytes asciiEncode(String s) =>
      new Bytes.typedDataView(ascii.encode(s));

  static String utf8Decode(Bytes bytes, {bool allowMalformed = true}) =>
      utf8.decode(new Bytes.typedDataView(bytes._bd),
          allowMalformed: allowMalformed);

  static Bytes utf8Encode(String s) => new Bytes.typedDataView(ascii.encode(s));

  // [offset] is from bd[0] and must be inRange. [offset] + [length]
  // must be less than bd.lengthInBytes
  static ByteData toByteData(ByteData bd, [int offset = 0, int length]) =>
      bd.buffer.asByteData(offset, length);
}

class LEBytes extends Bytes with BytesMixin, LEBytesMixin {
  static const Endian kEndian = Endian.little;

  /// Returns a
  LEBytes([int length]) : super._(length);

  LEBytes._(int length) : super._(length);

  factory LEBytes.from(LEBytes bytes, [int offset = 0, int length]) =>
      new LEBytes._from(bytes, offset, length);

  LEBytes._from(LEBytes bytes, int start, int length)
      : super._from(bytes, start, length);

  LEBytes.fromList(List<int> list) : super._fromList(list);

  factory LEBytes.typedDataView(TypedData td, [int offset = 0, int length]) =>
      new LEBytes._tdView(td, offset, length);

  LEBytes._tdView(TypedData td, int offset, int lengthInBytes)
      : super._tdView(td, offset, lengthInBytes);

  @override
  Endian get endian => kEndian;
}

class BEBytes extends Bytes with BytesMixin, BEBytesMixin {
  static const Endian kEndian = Endian.big;

  /// Returns a
  BEBytes([int length]) : super._(length);

  BEBytes._(int length) : super._(length);

  factory BEBytes.from(BEBytes bytes, [int offset = 0, int length]) =>
      new BEBytes._from(bytes, offset, length);

  BEBytes._from(BEBytes bytes, int start, int length)
      : super._from(bytes, start, length);

  BEBytes.fromList(List<int> list) : super._fromList(list);

  factory BEBytes.typedDataView(TypedData td, [int offset = 0, int length]) =>
      new BEBytes._tdView(td, offset, length);

  BEBytes._tdView(TypedData td, int offset, int lengthInBytes)
      : super._tdView(td, offset, lengthInBytes);

  @override
  Endian get endian => kEndian;
}
