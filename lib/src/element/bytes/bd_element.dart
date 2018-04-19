//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:convert' as cvt;

import 'package:core/src/base.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/element/bytes/evr.dart';
import 'package:core/src/element/bytes/ivr.dart';
import 'package:core/src/utils/bytes.dart';

typedef Element DecodeBinaryVF(Bytes bytes, int vrIndex);

typedef Element BDElementMaker(int code, int vrIndex, Bytes bytes);

// TODO: move documentation from EVR/IVR
abstract class BDElement<V> extends Element<V> {
  static Element make(int code, int vrIndex, Bytes bytes,
          {bool isEvr = true}) =>
      (isEvr)
          ? EvrElement.makeFromBytes(code, bytes, vrIndex)
          : IvrElement.makeFromBytes(code, bytes, vrIndex);

  // **** Start Interface ****

  /// The [Bytes] containing this Element.
  Bytes get bytes;

  /// Returns _true_ if this Element is encoded as Explicit VR Little Endian;
  /// otherwise, it is encoded as Implicit VR Little Endian, which is retired.
  bool get isEvr;
  int get vfLengthOffset;
  int get vfOffset;
  Bytes get vfBytesWithPadding;

  // **** End Interface ****
}

const int _codeOffset = 0;
const int _groupOffset = 0;
const int _eltOffset = 2;

abstract class Common {
  Bytes get bytes;
  bool get isLengthAlwaysValid;
  int get minValues;
  int get maxValues;
  int get columns;
  int get vfOffset;
  int get vfLengthField;
  int get valuesLength;
  int get vrIndex;

  // End Interface

  bool isEqual(BDElement a, BDElement b) {
    if (a.bytes.lengthInBytes != b.bytes.lengthInBytes) return false;

    final offset0 = a.bytes.offsetInBytes;
    final offset1 = b.bytes.offsetInBytes;
    final length = a.lengthInBytes;
    for (var i = offset0, j = offset1; i < length; i++, j++)
      if (a.bytes.getUint8(i) != b.bytes.getUint8(j)) return false;
    return true;
  }

  /// Returns the Tag Code from [Bytes].
  int get code {
    final group = bytes.getUint16(_codeOffset);
    final elt = bytes.getUint16(_codeOffset + 2);
    final v = (group << 16) + elt;
    return v;
  }

  int get group => bytes.getUint16(_groupOffset);
  int get elt => bytes.getUint16(_eltOffset);

  /// Returns the length in bytes of _this_ Element.
  int get eLength => bytes.lengthInBytes;

  /// Returns the actual length in bytes after removing any padding chars.
  // Floats always have a valid (defined length) vfLengthField.
  int get vfLength {
    final vfo = vfOffset;
    final len = bytes.lengthInBytes - vfo;
//    final vlf = vfLengthField;
//    if (vlf != kUndefinedLength && len != vlf)
//      print('${dcm(code)} $vrIndex len: $len, vlf: $vlf : ${len / vlf}');
    //  assert(vlf == kUndefinedLength || len == vlf, 'len: $len, vlf: $vlf');
    return len;
  }

  bool get hasValidLength {
    if (isLengthAlwaysValid) return true;
    return (valuesLength == 0) ||
        (valuesLength >= minValues &&
            (valuesLength <= maxValues) &&
            (valuesLength % columns == 0));
  }

  //TODO: add correct index
//  int get deIdIndex => unimplementedError();
  int get ieIndex => 0;
  bool get allowInvalid => true;
  bool get allowMalformed => true;

  bool get hasValidValues => true;

  Bytes get vfBytesWithPadding => (bytes.lengthInBytes == vfOffset)
      ? kEmptyBytes
      : bytes.toBytes(bytes.offsetInBytes + vfOffset, vfLength);

  /// Returns a [Bytes] containing the Value Field of _this_.
  Bytes get vfBytes => (bytes.lengthInBytes == vfOffset)
      ? kEmptyBytes
      : bytes.toBytes(bytes.offsetInBytes + vfOffset, vfLength);
}
// **** EVR Float Elements (FL, FD, OD, OF)

const _float32SizeInBytes = 4;

abstract class BDFloat32Mixin {
  int get vfLengthField;

  int get valuesLength => _getValuesLength(vfLengthField, _float32SizeInBytes);

  Float update([Iterable<double> vList]) => unsupportedError();
}

// **** EVR Long Float Elements (OD, OF)

const _float64SizeInBytes = 8;

abstract class BDFloat64Mixin {
  int get vfLengthField;

  int get valuesLength => _getValuesLength(vfLengthField, _float64SizeInBytes);

  Float update([Iterable<double> vList]) => unsupportedError();
}

abstract class IntMixin {

  IntBase update([Iterable<int> vList]) => unsupportedError();
}

// **** 8-bit Integer Elements (OB, UN)

const int _int8SizeInBytes = 1;

abstract class Int8Mixin {
  int get vfLengthField;

  int get valuesLength => _getValuesLength(vfLengthField, _int8SizeInBytes);
}

// **** 16-bit Integer Elements (SS, US, OW)

const _int16SizeInBytes = 2;

abstract class Int16Mixin {
  int get vfLengthField;

  int get valuesLength => _getValuesLength(vfLengthField, _int16SizeInBytes);
}

// **** 32-bit integer Elements (AT, SL, UL, GL)

const _int32SizeInBytes = 4;

abstract class Int32Mixin {
  int get vfLengthField;

  int get valuesLength => _getValuesLength(vfLengthField, _int32SizeInBytes);
}

abstract class ByteStringMixin {
  // **** Interface
  Bytes get bytes;
  int get eLength;
  int get vfOffset;
  int get vfLengthField;
  // **** End interface

  /// Returns the actual length in bytes after removing any padding chars.
  // Floats always have a valid (defined length) vfLengthField.
  int get vfLength {
    final vf0 = vfOffset;
    final lib = bytes.lengthInBytes;
    final length = lib - vf0;
    assert(length >= 0);
    return length;
  }

  int get valuesLength {
    if (vfLength == 0) return 0;
    var count = 1;
    for (var i = vfOffset; i < eLength; i++)
      if (bytes.getUint8(i) == kBackslash) count++;
    return count;
  }

  StringBase update([Iterable<String> vList]) => unsupportedError();
}

/// A Mixin for [String] [Element]s that may only have ASCII values.
abstract class AsciiMixin {
  Bytes get vfBytes;
  bool get allowInvalid;
  int get valuesLength;

  Iterable<String> get values {
    if (valuesLength == 0) return <String>[];
    final s = cvt.ascii.decode(vfBytes, allowInvalid: allowInvalid);
    return s.split('\\');
  }
}

/// A Mixin for [String] [Element]s that may have UTF-8 values.
abstract class Utf8Mixin {
  Bytes get vfBytes;
  bool get allowMalformed;
  int get valuesLength;

  Iterable<String> get values {
    if (valuesLength == 0) return <String>[];
    final s = cvt.utf8.decode(vfBytes, allowMalformed: allowMalformed);
    return s.split('\\');
  }
}

abstract class TextMixin {
  Bytes get vfBytes;
  bool get allowMalformed;

  String get value => cvt.utf8.decode(vfBytes, allowMalformed: allowMalformed);
}

int _getValuesLength(int vfLengthField, int sizeInBytes) {
  final vflf = vfLengthField;
  final length = vflf ~/ sizeInBytes;
  assert(vflf >= 0 && vflf.isEven, 'vfLengthField: $vflf');
  assert(vflf % sizeInBytes == 0, 'vflf: $vflf sizeInBytes $sizeInBytes');
  return length;
}
