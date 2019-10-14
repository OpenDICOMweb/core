//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:collection';
import 'dart:typed_data';

import 'package:base/base.dart';

// ignore_for_file: public_member_api_docs

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

bool isAligned(int offsetInBytes, int sizeInBytes) =>
    offsetInBytes % sizeInBytes == 0;

final Uint32List emptyOffsets = Uint32List(0);

List<int> getUint32List(Uint8List vf, [int offsetInBytes, int length]) {
  offsetInBytes ??= vf.offsetInBytes;
  length ??= vf.lengthInBytes ~/ 4;
  if (vf.isEmpty) return emptyOffsets;
  final oib = vf.offsetInBytes + offsetInBytes;
  // _log.debug('oib($oib), length($length), isAligned(${_isAligned(oib, 4)})');
  if (isAligned(oib, 4)) {
    return vf.buffer.asUint32List(oib, length);
  } else {
    return UnalignedUint32List(vf, offsetInBytes, length);
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
    return UnalignedUint32List._(bd0);
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
      throw UnsupportedError('Unmodifiable UnassignedUint32List');

  int _getUint16(int offset) => bd.getUint16(offset, Endian.little);

  int _getUint32(int i) {
    final offset = i * 4;
    final left = _getUint16(offset) << 16;
    final right = _getUint16(offset + 2);
    return left + right;
  }

  /// Returns an aligned copy of this unaligned list
  Uint32List get copy {
    final v = Uint32List(length);
    for (var i = 0; i < length; i++) v[i] = _getUint32(i);
    return v;
  }
}

/// Reads a Uint8List containing Tag codes as (group, element) pairs,
/// each of which must be read as a Uint16 values.
Uint32List bytesToAttributeTags(Uint8List bytes) {
  if ((bytes.lengthInBytes % 4) != 0) return null;
  final shorts = bytes.buffer.asUint16List();
  final list = Uint32List(shorts.length ~/ 2);
  for (var i = 0; i < list.length; i += 2) {
    list[i] = (shorts[i] << 16) + shorts[i + 1];
  }
  return list;
}
