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

import 'package:core/src/base.dart';
import 'package:core/src/dataset/base.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/element/bytes/evr.dart';
import 'package:core/src/element/bytes/ivr.dart';
import 'package:core/src/utils/bytes.dart';

typedef Element DecodeBinaryVF(Bytes bytes, int vrIndex);

typedef Element BDElementMaker(int code, int vrIndex, Bytes bytes);

// TODO: move documentation from EVR/IVR
abstract class ByteElement<V> extends Element<V> {
  /// The [Bytes] containing this Element.
  Bytes get bytes;

  /// Returns _true_ if this Element is encoded as Explicit VR Little Endian;
  /// otherwise, it is encoded as Implicit VR Little Endian, which is retired.
  bool get isEvr;

  /// Returns the Value Field Length field offset from the beginning of bytes.
 // int get vfLengthOffset;

  /// Returns the Value Field offset from the beginning of bytes.
 // int get vfOffset;

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
  Bytes get vfBytesWithPadding;

  // **** End Interface ****

  static Element make<V>(Dataset ds, int code, int vrIndex, Bytes bytes,
      {bool isEvr = true}) {
    final tag = lookupTagByCode(ds, code, vrIndex);
    final tagVRIndex = tag.vrIndex;
    final e = (isEvr)
        ? EvrElement.makeFromCode(ds, code, bytes, tagVRIndex)
        : IvrElement.makeFromCode(ds, code, bytes, tagVRIndex);
    return (code >= 0x10010 && code <= 0x100FF) ? new PrivateData(e) : e;
  }
}

class PrivateData extends ByteElement<Object> with MetaElementMixin<Object> {
  @override
  final ByteElement e;

  PrivateData(this.e);

  @override
  Bytes get bytes => e.bytes;
  @override
  bool get isEvr => e.isEvr;
//  @override
//  int get vfLengthOffset => e.vfLengthOffset;
//  @override
//  int get vfOffset => e.vfOffset;
//  @override
//  Bytes get vfBytes => e.vfBytes;
  @override
  Bytes get vfBytesWithPadding => e.vfBytesWithPadding;
  @override
  int get valuesLength => e.valuesLength;
  @override
  Iterable get values => e.values;
  @override
  set values(Iterable vList) => e.values = vList;

  static PrivateData make<V>(Dataset ds, int code, int vrIndex, Bytes bytes,
      {bool isEvr = true}) {
    assert(vrIndex != null && bytes.length.isEven);
    final e = ByteElement.make<V>(ds, code, vrIndex, bytes, isEvr: true);
    return new PrivateData(e);
  }
}

/// 32-bit Float Elements (FL, OF)
abstract class Float32Mixin {
  int get vfLengthField;
  Bytes get vfBytes;

  int get valuesLength => _getValuesLength(vfLengthField, _float32SizeInBytes);

  Float32List get values => vfBytes.asFloat32List();

  static const _float32SizeInBytes = 4;
}

/// Long Float Elements (FD, OD)
abstract class Float64Mixin {
  int get vfLengthField;
  Bytes get vfBytes;

  int get valuesLength => _getValuesLength(vfLengthField, _float64SizeInBytes);

  Float64List get values => vfBytes.asFloat64List();

  static const _float64SizeInBytes = 8;
}

/// 8-bit Integer Elements (OB, UN)
abstract class Uint8Mixin {
  int get vfLengthField;
  Bytes get vfBytes;

  int get valuesLength => _getValuesLength(vfLengthField, _int8SizeInBytes);

  Iterable<int> get values => vfBytes.asUint8List();

  static const int _int8SizeInBytes = 1;
}

/// **** 16-bit signed integer Elements (SS)
abstract class Int16Mixin {
  int get vfLengthField;
  Bytes get vfBytes;

  int get valuesLength => _getValuesLength(vfLengthField, _int16SizeInBytes);

  Iterable<int> get values => vfBytes.asInt16List();

  static const _int16SizeInBytes = 2;
}

/// 16-bit unsigned integer Elements (US, OW)
abstract class Uint16Mixin {
  int get vfLengthField;
  Bytes get vfBytes;

  int get valuesLength => _getValuesLength(vfLengthField, _int16SizeInBytes);

  Iterable<int> get values => vfBytes.asUint16List();

  static const _int16SizeInBytes = 2;
}

/// 32-bit signed integer Elements (SL)
abstract class Int32Mixin {
  int get vfLengthField;
  Bytes get vfBytes;

  int get valuesLength => _getValuesLength(vfLengthField, _int32SizeInBytes);

  Iterable<int> get values => vfBytes.asInt32List();

  static const _int32SizeInBytes = 4;
}

/// 32-bit unsigned integer Elements (AT, UL, GL, OL)
abstract class Uint32Mixin {
  int get vfLengthField;
  Bytes get vfBytes;

  int get valuesLength => _getValuesLength(vfLengthField, _int32SizeInBytes);

  Iterable<int> get values => vfBytes.asUint32List();

  static const _int32SizeInBytes = 4;
}

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

/// [String] [Element]s that only have ASCII values.
abstract class AsciiMixin {
  Bytes get vfBytes;

  bool  allowInvalid = true;

  String get vfString => vfBytes.getAscii(allowInvalid: allowInvalid);

  Iterable<String> get values => vfString.split('\\');
}

/// [String] [Element]s that may have UTF-8 values.
abstract class Utf8Mixin {
  Bytes get vfBytes;

  bool  allowMalformed = true;

  String get vfString => vfBytes.getUtf8(allowMalformed: allowMalformed);

  Iterable<String> get values => vfString.split('\\');
}

/// Text ([String]) [Element]s that may only have 1 UTF-8 value.
abstract class TextMixin {
  Bytes get vfBytes;

  bool allowMalformed = true;

  String get vfString => utf8.decode(vfBytes, allowMalformed: allowMalformed);
  String get value => vfString;
  Iterable<String> get values => [vfString];

}

int _getValuesLength(int vfLengthField, int sizeInBytes) {
  final vlf = vfLengthField;
  final length = vlf ~/ sizeInBytes;
  assert(vlf >= 0 && vlf.isEven, 'vfLengthField: $vlf');
  assert(vlf % sizeInBytes == 0, 'vflf: $vlf sizeInBytes $sizeInBytes');
  return length;
}
