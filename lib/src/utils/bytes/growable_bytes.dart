//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/src/utils/bytes/bytes.dart';
import 'package:core/src/utils/bytes/constants.dart';

// ignore_for_file: public_member_api_docs

mixin GrowableMixin {
  /// The upper bound on the length of this [Bytes]. If [limit]
  /// is _null_ then its length cannot be changed.
  int get limit;
  Uint8List get buf;
  bool grow(int newLength);

  int get length => buf.length;

  set length(int newLength) {
    if (newLength < buf.lengthInBytes) return;
    grow(newLength);
  }

  /// Ensures that [buf] is at least [length] long, and grows
  /// the buf if necessary, preserving existing data.
  bool ensureLength(int length) => _ensureLength(buf, length);

  /// Ensures that [list] is at least [minLength] long, and grows
  /// the buf if necessary, preserving existing data.
  static bool _ensureLength(Uint8List list, int minLength) =>
      (minLength > list.lengthInBytes) ? _reallyGrow(list, minLength) : false;
}

class GrowableBytes extends Bytes with GrowableMixin {
  /// The upper bound on the length of this [Bytes]. If [limit]
  /// is _null_ then its length cannot be changed.
  @override
  final int limit;

  /// Returns a new [Bytes] of [length].
  GrowableBytes(
      [int length, Endian endian = Endian.little, this.limit = kDefaultLimit])
      : super(length, endian);

  /// Returns a new [Bytes] of [length].
  GrowableBytes._(int length, Endian endian, this.limit)
      : super(length, endian);

  GrowableBytes.from(Bytes bytes,
      [int offset = 0, int length, Endian endian, this.limit = k1GB])
      : super.from(bytes, offset, length, endian);

  GrowableBytes.typedDataView(TypedData td,
      [int offset = 0,
      int lengthInBytes,
      Endian endian = Endian.little,
      int limit])
      : limit = limit ?? k1GB,
        super.typedDataView(td, offset, lengthInBytes, endian);

  /// Creates a new buffer of length at least [minLength] in size, or if
  /// [minLength == null, at least double the length of the current buffer;
  /// and then copies the contents of the current buffer into the new buffer.
  /// Finally, the new buffer becomes the buffer for _this_.
  @override
  bool grow([int minLength]) {
    final old = buf;
    buf = _grow(old, minLength ??= old.lengthInBytes * 2);
    return buf == old;
  }

  static const int k1GB = 1024 * 1024;
  static const int kMaximumLength = k1GB;
}

/// If [minLength] is less than or equal to the current length of
/// [bd] returns [bd]; otherwise, returns a new [ByteData] with a length
/// of at least [minLength].
Uint8List _grow(Uint8List bd, int minLength) {
  final oldLength = bd.lengthInBytes;
  return (minLength <= oldLength) ? bd : _reallyGrow(bd, minLength);
}

/// Returns a new [ByteData] with length at least [minLength].
Uint8List _reallyGrow(Uint8List bd, int minLength) {
  var newLength = minLength;
  do {
    newLength *= 2;
    if (newLength >= kDefaultLimit) return null;
  } while (newLength < minLength);
  final newBD = Uint8List(newLength);
  for (var i = 0; i < bd.lengthInBytes; i++) newBD[i] = bd[i];
  return newBD;
}

bool checkAllZeros(ByteData bd, int start, int end) {
  for (var i = start; i < end; i++) if (bd.getUint8(i) != 0) return false;
  return true;
}
