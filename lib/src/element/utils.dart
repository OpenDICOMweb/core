//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:collection';
import 'dart:convert' as cvt;
import 'dart:typed_data';

import 'package:core/src/utils/primitives.dart';

//TODO: maybe move base64Encode/decode & toDcmString
/// Returns a Base64 [String] encoded from the [Uint8List] of [bytes].
String base64Encode(Uint8List bytes) => cvt.base64.encode(bytes);

/// Returns a [Uint8List] decoded from the [String] [s].
Uint8List base64Decode(String s) => cvt.base64.decode(s);

/// _Deprecated_: use [dcmString].
String toDcmString(List<String> list) => '"${list.join("\\")}"';

/// Returns a DICOM encoded [List<String>].
String dcmString(List<String> list) => '"${list.join("\\")}"';

/// Returns a [List<String>] from the DICOM encoded [String] [s].
List<String> fromDcmString(String s, [String padChar = ' ']) {
  final last = s.length - 1;
  final char = s.codeUnitAt(last);
  final x = (char == kSpace || char == kNull) ? s.substring(0, last) : s;
  return x.split('\\');
}

/// [min]: The minimum number of values.
/// [max]: The maximum number of values. If -1 then max length of Value
/// Field; otherwise, must be greater than or equal to [min].
/// [width]: The [width] of the matrix of values. If [width == 0 then singleton;
///     otherwise must be greater than 0;
bool isValidLongLength(
    int length, int min, int max, int width, int elementSize) {
  // These are the most common cases.
  if (length == 0 || (length == 1 && width == 0)) return true;
  final realMax = (max == -1) ? kMaxLongVF ~/ elementSize : max;
  return (length == 0) ||
      (length % width == 0 && min <= length && length <= realMax);
}

// min: The smallest number of values greater than zero
// max: the
bool isValidShortLength(
    int length, int min, int max, int width, int elementSize) {
  // These are the most common cases.
  if (length == 0 || (length == 1 && width == 0)) return true;
  final realMax = (max == -1) ? kMaxShortVF ~/ elementSize : max;
  return (length > 0) &&
      (length % width == 0 && min <= length && length <= realMax);
}

/*
Uint32List getOffsetsFromFragments(List<Uint8List> fragments) =>
    (fragments.length > 0) ? getUint32List(fragments[0]) : null;

/// Returns a [Uint8List] that combines the pixel data in [fragments].
/// Note: The pixel data is contained in fragments 1 - n. Fragment 0
/// contains the Basic Offset Table.
Uint8List getPixelsFromFragments(List<Uint8List> fragments) {
  int pixelsLength = 0;
  for (int j = 1; j < fragments.length; j++) {
    pixelsLength += fragments[j].lengthInBytes;
  }
  var pixels = new Uint8List(pixelsLength);
  var i = 0;
  for (int j = 1; j < fragments.length; j++) {
    if (fragments[j].length > 0) {
      Uint8List chunk = fragments[j];
      for (int k = 0; k < chunk.length; k++, i++) pixels[i] = chunk[k];
    }
  }
  return pixels;
}
*/

bool isAligned(int offsetInBytes, int sizeInBytes) =>
    offsetInBytes % sizeInBytes == 0;

final Uint32List emptyOffsets = new Uint32List(0);
List<int> getUint32List(Uint8List vf, [int offsetInBytes, int length]) {
  offsetInBytes ??= vf.offsetInBytes;
 length ??= vf.lengthInBytes ~/ 4;
  if (vf.isEmpty) return emptyOffsets;
  final oib = vf.offsetInBytes + offsetInBytes;
  // _log.debug('oib($oib), length($length), isAligned(${_isAligned(oib, 4)})');
  if (isAligned(oib, 4)) {
    return vf.buffer.asUint32List(oib, length);
  } else {
    return new UnalignedUint32List(vf, offsetInBytes, length);
  }
}

/// An unaligned Uint32List.  [bd] must be aligned on a 16-bit boundary.
class UnalignedUint32List extends ListBase<int> {
  ByteData bd;

  factory UnalignedUint32List(Uint8List vf, int offsetInBytes, int length) {
  	final startIB = vf.offsetInBytes + offsetInBytes;
    assert(vf != null, 'bytes == null');
    assert(isAligned(vf.offsetInBytes, 2), 'Not aligned on 16-bit boundary');
    final bd0 = vf.buffer.asByteData(startIB, length * 4);
    return new UnalignedUint32List._(bd0);
  }

  UnalignedUint32List._(this.bd);

  @override
  int operator [](int i) => _getUint32(i);

  @override
  void operator []=(int i, int v) => _unsupported();

  @override
  int get length => bd.lengthInBytes ~/ 4;

  @override
  set length(int v) => _unsupported();

  void _unsupported() =>
      throw new UnsupportedError('Unmodifiable UnassignedUint32List');

  int _getUint16(int offset) => bd.getUint16(offset, Endian.little);

  int _getUint32(int i) {
    final offset = i * 4;
    final left = _getUint16(offset) << 16;
    final right = _getUint16(offset + 2);
    return left + right;
  }

  /// Returns an aligned copy of this unaligned list
  Uint32List get copy {
	  final v = new Uint32List(length);
    for (var i = 0; i < length; i++) v[i] = _getUint32(i);
    return v;
  }
}

/// Reads a Uint8List containing Tag codes as (group, element) pairs,
/// each of which must be read as a Uint16 values.
Uint32List bytesToAttributeTags(Uint8List bytes) {
  if ((bytes.lengthInBytes % 4) != 0) return null;
  final shorts = bytes.buffer.asUint16List();
  final list = new Uint32List(shorts.length ~/ 2);
  for (var i = 0; i < list.length; i += 2) {
    list[i] = (shorts[i] << 16) + shorts[i + 1];
  }
  return list;
}
