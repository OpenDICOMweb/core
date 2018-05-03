//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/dataset/base.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/element/bytes/evr.dart';
import 'package:core/src/element/bytes/ivr.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/value/empty_list.dart';

typedef Element DecodeBinaryVF(Bytes bytes, int vrIndex);

typedef Element BDElementMaker(int code, int vrIndex, Bytes bytes);

// TODO: move documentation from EVR/IVR
abstract class ByteElement<V> extends Element<V> {
  /// The [Bytes] containing this Element.
  DicomBytes get bytes;

  /// Returns _true_ if this Element is encoded as Explicit VR Little Endian;
  /// otherwise, it is encoded as Implicit VR Little Endian, which is retired.
  bool get isEvr;
  @override
  int get code;
  @override
  int get vrCode;
  @override
  int get vrIndex;

  /// Returns the Value Field Length field offset from the beginning of bytes.
  int get vfLengthOffset;

  /// Returns the Value Field offset from the beginning of bytes.
  int get vfOffset;

  @override
  int get vfLength;

  int get valuesLength;

  /// Returns the Value Field [Bytes] without trailing [kSpace] or [kNull]
  /// characters.
//  Bytes get vfBytesWithoutPadding;

  /// The Value Field [Bytes] of this Element without padding character.
  @override
  Bytes get vfBytes;

  /// The Value Field [Bytes] of this Element with padding character.
  Bytes get vfBytesWOPadding;

  // **** End Interface ****

  @override
  Tag get tag => Tag.lookupByCode(code, vrIndex);

  static Element make<V>(Dataset ds, int code, Bytes bytes,
      {bool isEvr = true}) {
    final e = (isEvr)
        ? EvrElement.makeFromCode(ds, code, bytes)
        : IvrElement.makeFromCode(ds, code, bytes);
    return (code >= 0x10010 && code <= 0x100FF) ? new PrivateData(e) : e;
  }
}

class PrivateData extends ByteElement<Object> with MetaElementMixin<Object> {
  @override
  final ByteElement e;

  PrivateData(this.e);

  @override
  DicomBytes get bytes => e.bytes;
  @override
  bool get isEvr => e.isEvr;
  @override
  int get vfLengthOffset => e.vfLengthOffset;
  @override
  int get vfOffset => e.vfOffset;
  @override
  Bytes get vfBytes => e.vfBytes;
  @override
  Bytes get vfBytesWOPadding => e.vfBytesWOPadding;
  @override
  int get valuesLength => e.valuesLength;
  @override
  Iterable get values => e.values;
  @override
  set values(Iterable vList) => e.values = vList;

  static PrivateData make<V>(Dataset ds, int code, Bytes bytes,
      {bool isEvr = true}) {
    assert(bytes.length.isEven);
    final e = ByteElement.make<V>(ds, code, bytes, isEvr: true);
    return new PrivateData(e);
  }
}

/// 16-bit signed integer Elements (SS)
abstract class TagMixin {
  int get code;
  Tag get tag;

  int get index => code;

  int get vmMin => tag.vmMin;
  int get vmMax => tag.vmMax;
  int get vmColumns => tag.vmColumns;
  bool get isPublic => code.isEven;
  bool get isPrivate => !code.isEven;
  bool get isRetired => tag.isRetired;

  String get keyword => tag.keyword;
  String get name => tag.name;

}


/// 16-bit signed integer Elements (SS)
abstract class Int16Mixin {
  int get vfLengthField;
  Bytes get vfBytes;

  int get valuesLength => _fixedSizeLength(vfLengthField, Int16.kSizeInBytes);

  Iterable<int> get values => vfBytes.asInt16List();
}

/// 32-bit signed integer Elements (SL)
abstract class Int32Mixin {
  int get vfLengthField;
  Bytes get vfBytes;

  int get valuesLength => _fixedSizeLength(vfLengthField, Int32.kSizeInBytes);

  Iterable<int> get values => vfBytes.asInt32List();
}

/// 8-bit Integer Elements (OB, UN)
abstract class Uint8Mixin {
  int get vfLengthField;
  Bytes get vfBytes;

  int get valuesLength => _fixedSizeLength(vfLengthField, Uint8.kSizeInBytes);

  Iterable<int> get values => vfBytes.asUint8List();
}


/// 16-bit unsigned integer Elements (US, OW)
abstract class Uint16Mixin {
  int get vfLengthField;
  Bytes get vfBytes;

  int get valuesLength => _fixedSizeLength(vfLengthField, Uint16.kSizeInBytes);

  Iterable<int> get values => vfBytes.asUint16List();
}


/// 32-bit unsigned integer Elements (AT, UL, GL, OL)
abstract class Uint32Mixin {
  int get vfLengthField;
  Bytes get vfBytes;

  int get valuesLength => _fixedSizeLength(vfLengthField, Uint32.kSizeInBytes);

  Iterable<int> get values => vfBytes.asUint32List();
}

/// 32-bit Float Elements (FL, OF)
abstract class Float32Mixin {
  int get vfLengthField;
  Bytes get vfBytes;

  int get valuesLength => _fixedSizeLength(vfLengthField, Float32.kSizeInBytes);

  Float32List get values => vfBytes.asFloat32List();
}

/// Long Float Elements (FD, OD)
abstract class Float64Mixin {
  int get vfLengthField;
  Bytes get vfBytes;
  int get vfOffset;

  int get valuesLength => _fixedSizeLength(vfLengthField, Float64.kSizeInBytes);

  Float64List get values => vfBytes.asFloat64List();
}

int _fixedSizeLength(int vfLengthField, int sizeInBytes) {
  final vlf = vfLengthField;
  final length = vlf ~/ sizeInBytes;
  assert(vlf >= 0 && vlf.isEven, 'vfLengthField: $vlf');
  assert(vlf % sizeInBytes == 0, 'vflf: $vlf sizeInBytes $sizeInBytes');
  return length;
}



/*
/// All [String] Elements
abstract class ByteStringMixin {
  Bytes get vfBytes;

  int get valuesLength {
    if (vfBytes.isEmpty) return 0;
    var count = 1;
    for (var i = 0; i < vfBytes.length; i++)
      if (vfBytes[i] == kBackslash) count++;
    return count;
  }
}
*/

/// [String] [Element]s that only have ASCII values.
abstract class AsciiMixin {
  Bytes get vfBytes;

  int get valuesLength => _stringValuesLength(vfBytes);

  bool allowInvalid = true;

  String get vfString => vfBytes.getAscii(allowInvalid: allowInvalid);

  Iterable<String> get values => vfString.split('\\');
}

/// [String] [Element]s that may have UTF-8 values.
abstract class Utf8Mixin {
  Bytes get vfBytes;

  int get valuesLength => _stringValuesLength(vfBytes);

  bool allowMalformed = true;

  String get vfString => vfBytes.getUtf8(allowMalformed: allowMalformed);

  Iterable<String> get values => vfString.split('\\');
}

/// Text ([String]) [Element]s that may only have 1 UTF-8 value.
abstract class TextMixin {
  Bytes get vfBytes;

  int get valuesLength => 1;

  bool allowMalformed = true;

  String get vfString => vfBytes.getUtf8(allowMalformed: allowMalformed);
  String get value => vfString;
  Iterable<String> get values => [vfString];
}

int _stringValuesLength(Bytes vfBytes) {
  if (vfBytes.isEmpty) return 0;
  var count = 1;
  for (var i = 0; i < vfBytes.length; i++)
    if (vfBytes[i] == kBackslash) count++;
  return count;
}