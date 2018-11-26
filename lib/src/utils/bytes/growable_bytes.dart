//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/utils/bytes/byte_data_mixin.dart';
import 'package:core/src/utils/bytes/new_bytes.dart';
// ignore_for_file: public_member_api_docs

abstract class GrowableMixin {
  /// The upper bound on the length of this [Bytes]. If [limit]
  /// is _null_ then its length cannot be changed.
  int get limit;
  ByteData get bd;
  bool grow(int newLength);

  int get length => bd.lengthInBytes;

  set length(int newLength) {
    if (newLength < bd.lengthInBytes) return;
    grow(newLength);
  }

  /// Ensures that [bd] is at least [length] long, and grows
  /// the buf if necessary, preserving existing data.
  bool ensureLength(int length) => _ensureLength(bd, length);

  /// Ensures that [bd] is at least [minLength] long, and grows
  /// the buf if necessary, preserving existing data.
  static bool _ensureLength(ByteData bd, int minLength) =>
      (minLength > bd.lengthInBytes) ? _reallyGrow(bd, minLength) : false;

}

class GrowableBytes extends Bytes with ByteDataMixin, GrowableMixin {
  /// The upper bound on the length of this [Bytes]. If [limit]
  /// is _null_ then its length cannot be changed.
  @override
  final int limit;

  /// Returns a new [Bytes] of [length].
  GrowableBytes([int length, Endian endian, this.limit = Bytes.kDefaultLimit])
      : super(length, endian);

  /// Returns a new [Bytes] of [length].
  GrowableBytes._(int length, Endian endian, this.limit)
      : super(length, endian);

  GrowableBytes.from(Bytes bytes,
      [int offset = 0, int length, Endian endian, this.limit = Bytes.kDefaultLimit])
      : super.from(bytes, offset, length, endian);

  GrowableBytes.typedDataView(TypedData td,
          [int offset = 0,
          int lengthInBytes,
          Endian endian,
          int limit])
      : limit = limit ?? Bytes.kDefaultLimit,
        super.typedDataView(td, offset, lengthInBytes, endian);

  /// Creates a new buffer of length at least [minLength] in size, or if
  /// [minLength == null, at least double the length of the current buffer;
  /// and then copies the contents of the current buffer into the new buffer.
  /// Finally, the new buffer becomes the buffer for _this_.
  @override
  bool grow([int minLength]) {
    final old = bd;
    bd = _grow(old, minLength ??= old.lengthInBytes * 2);
    return bd == old;
  }

  static const int kMaximumLength = Bytes.kDefaultLimit;
}

/// If [minLength] is less than or equal to the current length of
/// [bd] returns [bd]; otherwise, returns a new [ByteData] with a length
/// of at least [minLength].
ByteData _grow(ByteData bd, int minLength) {
  final oldLength = bd.lengthInBytes;
  return (minLength <= oldLength) ? bd : _reallyGrow(bd, minLength);
}

/// Returns a new [ByteData] with length at least [minLength].
ByteData _reallyGrow(ByteData bd, int minLength) {
  var newLength = minLength;
  do {
    newLength *= 2;
    if (newLength >= Bytes.kDefaultLimit) return null;
  } while (newLength < minLength);
  final newBD = ByteData(newLength);
  for (var i = 0; i < bd.lengthInBytes; i++) newBD.setUint8(i, bd.getUint8(i));
  return newBD;
}

bool checkAllZeros(ByteData bd, int start, int end) {
  for (var i = start; i < end; i++) if (bd.getUint8(i) != 0) return false;
  return true;
}
