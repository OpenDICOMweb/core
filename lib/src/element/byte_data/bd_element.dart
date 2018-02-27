// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/src/bytes/bytes.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/float.dart';
import 'package:core/src/element/base/integer/integer.dart';
import 'package:core/src/element/base/string.dart';
import 'package:core/src/element/byte_data/evr.dart';
import 'package:core/src/element/byte_data/ivr.dart';
import 'package:core/src/element/errors.dart';
import 'package:core/src/empty_list.dart';
import 'package:core/src/errors.dart';
import 'package:core/src/string/ascii.dart';
import 'package:core/src/string/hexadecimal.dart';
import 'package:core/src/system/system.dart';
import 'package:core/src/tag/constants.dart';

typedef Element DecodeBinaryVF(ByteData bd, int vrIndex);

typedef BDElement BDElementMaker(int code, int vrIndex, ByteData bd);

// TODO: move documentation from EVR/IVR
abstract class BDElement<V> extends Element<V> {
  static BDElement make(int code, int vrIndex, ByteData bd,
          {bool isEvr = true}) =>
      (isEvr)
          ? EvrElement.make(code, vrIndex, bd)
          : IvrElement.make(code, vrIndex, bd);

  // **** Start Interface ****

  /// The [ByteData] containing this Element.
  ByteData get bd;
  /// Returns _true_ if this Element is encoded as Explicit VR Little Endian;
  /// otherwise, it is encoded as Implicit VR Little Endian, which is retired.
  bool get isEvr;
  int get vfLengthOffset;
  int get vfOffset;
  Uint8List get vfBytesWithPadding;
  ByteData get vfByteDataWithPadding;

  // **** End Interface ****
}

const int _codeOffset = 0;
const int _groupOffset = 0;
const int _eltOffset = 2;

abstract class Common {
  ByteData get bd;
  bool get isLengthAlwaysValid;
  int get minValues;
  int get maxValues;
  int get columns;
  int get vfOffset;
  int get vfLengthField;
  int get valuesLength;
  int get vrIndex;

  bool isEqual(BDElement a, BDElement other) {
      if (bd.lengthInBytes != other.bd.lengthInBytes) return false;

      final offset0 = bd.offsetInBytes;
      final offset1 = other.bd.offsetInBytes;
      final length = bd.lengthInBytes;
      for (var i = offset0, j = offset1; i < length; i++, j++)
        if (bd.getUint8(i) != other.bd.getUint8(j)) return false;
      return true;
  }

  /// Returns the Tag Code from [ByteData].
  int get code {
    final group = bd.getUint16(_codeOffset, Endian.little);
    final elt = bd.getUint16(_codeOffset + 2, Endian.little);
    final v = (group << 16) + elt;
    return v;
  }

  int get group => bd.getUint16(_groupOffset, Endian.little);
  int get elt => bd.getUint16(_eltOffset, Endian.little);

  /// Returns the length in bytes of _this_ Element.
  int get eLength => bd.lengthInBytes;

  /// Returns the actual length in bytes after removing any padding chars.
  // Floats always have a valid (defined length) vfLengthField.
  int get vfLength {
    final vfo = vfOffset;
    final len = bd.lengthInBytes - vfo;
//    print('vfo: $vfo, len:$len');
    final vfl = vfLengthField;
//    print('vfl: $vfl, ${vfl.toRadixString(16)}');
    assert(vfl == kUndefinedLength || len == vfl);
    return len;
  }

  bool get hasValidLength {
    if (isLengthAlwaysValid) return true;
// Put print in to see how often it is called
// print('length: $valuesLength, minValues: $minValues, maxValues: $maxValues');
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

  Uint8List get vfBytesWithPadding => (bd.lengthInBytes == vfOffset)
      ? kEmptyUint8List
      : bd.buffer.asUint8List(bd.offsetInBytes + vfOffset, vfLength);

  Uint8List get vfBytes => (bd.lengthInBytes == vfOffset)
      ? kEmptyUint8List
      : bd.buffer.asUint8List(bd.offsetInBytes + vfOffset, vfLength);

  ByteData get vfByteDataWithPadding => (bd.lengthInBytes == vfOffset)
      ? kEmptyByteData
      : bd.buffer.asByteData(bd.offsetInBytes + vfOffset, vfLength);

  ByteData get vfByteData => (bd.lengthInBytes == vfOffset)
      ? kEmptyByteData
      : bd.buffer.asByteData(bd.offsetInBytes + vfOffset, vfLength);
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
  ByteData get bd;
  int get vfOffset;

  IntBase update([Iterable<int> vList]) => unsupportedError();
}

// **** 8-bit Integer Elements (OB, UN)

const int _int8SizeInBytes = 1;

abstract class Int8Mixin {
  int get vfLength;
  int get vfLengthField;

  int get valuesLength => _getValuesLength(vfLength, _int8SizeInBytes);
}

// **** 16-bit Integer Elements (SS, US, OW)

const _int16SizeInBytes = 2;

abstract class Int16Mixin {
  // **** Interface
  ByteData get bd;
  int get vfLength;
  // **** End interface

  int get valuesLength => _getValuesLength(vfLength, _int16SizeInBytes);
}

// **** 32-bit integer Elements (AT, SL, UL, GL)

const _int32SizeInBytes = 4;

abstract class Int32Mixin {
  // **** Interface
  ByteData get bd;
  int get vfLengthField;

  int get valuesLength => _getValuesLength(vfLengthField, _int32SizeInBytes);
}

abstract class BDStringMixin {
  // **** Interface
  ByteData get bd;
  int get eLength;
  int get padChar;
  int get vfOffset;
  int get vfLengthField;
  // **** End interface

  /// Returns the actual length in bytes after removing any padding chars.
  // Floats always have a valid (defined length) vfLengthField.
  int get vfLength {
    final vf0 = vfOffset;
    final lib = bd.lengthInBytes;
    final length = lib - vf0;
    assert(length >= 0);
    return length;
  }

  int get valuesLength {
    if (vfLength == 0) return 0;
    var count = 1;
    for (var i = vfOffset; i < eLength; i++)
      if (bd.getUint8(i) == kBackslash) count++;
    return count;
  }

  StringBase update([Iterable<String> vList]) => unsupportedError();
}

/// A Mixin for [String] [Element]s that may only have ASCII values.
abstract class AsciiMixin {
  Uint8List get vfBytes;
  bool get allowInvalid;
  int get valuesLength;

  Iterable<String> get values {
    if (valuesLength == 0) return <String>[];
    final s = ASCII.decode(vfBytes, allowInvalid: allowInvalid);
    return s.split('\\');
  }
}

/// A Mixin for [String] [Element]s that may have UTF-8 values.
abstract class Utf8Mixin {
  ByteData get bd;
  Uint8List get vfBytes;
  bool get allowMalformed;
  int get valuesLength;

  Iterable<String> get values {
    if (valuesLength == 0) return <String>[];
    final s = UTF8.decode(vfBytes, allowMalformed: allowMalformed);
    return s.split('\\');
  }
}

abstract class TextMixin {
  ByteData get bd;
  int get vfOffset;
  Uint8List get vfBytes;
  bool get allowMalformed;

  int get valuesLength => 1;

  Iterable<String> get values {
    if (valuesLength == 0) return <String>[];
    return [UTF8.decode(vfBytes, allowMalformed: allowMalformed)];
  }
}

bool ensureExactLength = true;

/// Returns _true_ if all bytes in [bytes0] and [bytes1] are the same.
/// _Note_: This assumes the [ByteData] is aligned on a 2 byte boundary.
bool bytesEqual(Bytes bytes0, Bytes bytes1) =>
    byteDataEqual(bytes0.asByteData(), bytes0.asByteData());

/// Returns _true_ if all bytes in [bd0] and [bd1] are the same.
/// _Note_: This assumes the [ByteData] is aligned on a 2 byte boundary.
bool byteDataEqual(ByteData bd0, ByteData bd1, {bool doFast = false}) {
  final b0Length = bd0.lengthInBytes;
  final b1Length = bd1.lengthInBytes;
  if (b0Length.isEven && b1Length.isEven && b0Length == b1Length)
    return (doFast && (b0Length % 4) == 0)
        ? bytesEqualFast(bd0, bd1)
        : bytesEqualSlow(bd0, bd1);
  log.error('Invalid Length: b0($b0Length) b1($b1Length)');
  return false;
}

/// Returns _true_ if all bytes in [bytes0] and [bytes1] are the same.
/// _Note_: This assumes the [ByteData] is aligned on a 2 byte boundary.
bool uint8ListEqual(Uint8List bytes0, Uint8List bytes1) {
  final bd0 =
  bytes0.buffer.asByteData(bytes0.offsetInBytes, bytes0.lengthInBytes);
  final bd1 =
  bytes1.buffer.asByteData(bytes1.offsetInBytes, bytes1.lengthInBytes);
  return byteDataEqual(bd0, bd1);
}

bool bytesEqualSlow(ByteData bd0, ByteData bd1) {
  var ok = true;
  for (var i = 0; i < bd0.lengthInBytes; i++) {
    final a = bd0.getUint8(i);
    final b = bd1.getUint8(i);
    if (a != b) {
      ok = false;
      if ((a == 0 && b == 32) || (a == 32 && b == 0)) {
        log.warn('$i $a | $b Padding char difference');
      } else {
        log.warn('''
$i: $a | $b')
	  ${hex8(a)} | ${hex8(b)}
	  "${new String.fromCharCode(a)}" | "${new String.fromCharCode(b)}"
''');
      }
    }
  }
  return ok;
}

// Note: optimized to use 4 byte boundary
bool bytesEqualFast(ByteData bd0, ByteData bd1) {
  var ok = true;
  for (var i = 0; i < bd0.lengthInBytes; i += 4) {
    final a = bd0.getUint32(i);
    final b = bd1.getUint32(i);
    if (a != b) {
      log.warn('''
$i: $a | $b')
	  ${hex32(a)} | ${hex32(b)}
''');
      _toBytes(i, bd0, bd1);
      ok = false;
    }
  }
  return ok;
}

void _toBytes(int i, ByteData bd0, ByteData bd1) {
  final bytes0 = bd0.buffer.asUint8List(i, 8);
  log.warn('    $bytes0');
  final bytes1 = bd1.buffer.asUint8List(i, 8);
  log.warn('    $bytes1');
  final s0 = ASCII.decode(bytes0, allowInvalid: true);
  log.warn('    $s0');
  final s1 = ASCII.decode(bytes1, allowInvalid: true);
  log.warn('    $s1');
}

/// Returns _true_ if all bytes in [bd0] and [bd1] are the same.
/// _Note_: This assumes the [ByteData] is aligned on a 2 byte boundary.
bool bdEqual(ByteData bd0, ByteData bd1) => byteDataEqual(bd0, bd1);



int getLength(Uint8List vfBytes, int unitSize) {
  if (ensureExactLength && ((vfBytes.length % unitSize) != 0))
    return invalidVFLength(vfBytes.length, unitSize);
  return vfBytes.lengthInBytes ~/ unitSize;
}

int _getValuesLength(int vfLengthField, int sizeInBytes) {
  final length = vfLengthField ~/ sizeInBytes;
  assert(vfLengthField >= 0 &&
      vfLengthField.isEven &&
      (vfLengthField % sizeInBytes == 0));
  return length;
}

//TODO: This should be done in convert
bool checkPadding(ByteData bd, [int padChar = kSpace]) {
  final lastIndex = bd.lengthInBytes - 1;
  final char = bd.getUint8(lastIndex);
  if ((char == kNull || char == kSpace) && char != padChar)
    log.warn('Invalid PadChar: $char should be $padChar');
  return true;
}

//TODO: This should be done in convert
ByteData removePadding(ByteData bd, int vfOffset, [int padChar = kSpace]) {
  if (bd.lengthInBytes == vfOffset) return bd;
  assert(bd.lengthInBytes.isEven);
  final lastIndex = bd.lengthInBytes - 1;
  final char = bd.getUint8(lastIndex);
  if (char == kNull || char == kSpace) {
    log.debug3('Removing Padding: $char');
    return bd.buffer.asByteData(bd.offsetInBytes, bd.lengthInBytes - 1);
  }
  return bd;
}