//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.utils.bytes;

abstract class GrowableMixin {
  /// The upper bound on the length of this [Bytes]. If [limit]
  /// is _null_ then its length cannot be changed.
  int get limit;
  ByteData get _bd;
  bool grow(int newLength);

  int get length => _bd.lengthInBytes;

  set length(int newLength) {
    if (newLength < _bd.lengthInBytes) return;
    grow(newLength);
  }

  /// Ensures that [_bd] is at least [length] long, and grows
  /// the buf if necessary, preserving existing data.
  bool ensureLength(int length) => _ensureLength(_bd, length);

  static const int kMaximumLength = _k1GB;
}

class GrowableBytes extends Bytes with GrowableMixin {
  /// The upper bound on the length of this [Bytes]. If [limit]
  /// is _null_ then its length cannot be changed.
  @override
  final int limit;

  /// Returns a new [Bytes] of [length].
  GrowableBytes([int length, Endian endian, this.limit = kDefaultLimit])
      : super._(length, endian);

  /// Returns a new [Bytes] of [length].
  GrowableBytes._(int length, Endian endian, this.limit)
      : super._(length, endian);

  factory GrowableBytes.from(Bytes bytes,
          [int offset = 0,
          int length,
          Endian endian,
          int limit = kDefaultLimit]) =>
      new GrowableBytes._from(bytes, offset, length, endian, limit);

  GrowableBytes._from(
      Bytes bytes, int offset, int length, Endian endian, this.limit)
      : super._from(bytes, offset, length, endian);

  factory GrowableBytes.typedDataView(TypedData td,
          [int offset = 0,
          int lengthInBytes,
          Endian endian,
          int limit = _k1GB]) =>
      new GrowableBytes._tdView(
          td, offset, lengthInBytes ?? td.lengthInBytes, endian, limit);

  GrowableBytes._tdView(
      TypedData td, int offset, int lengthInBytes, Endian endian, this.limit)
      : super._tdView(td, offset, lengthInBytes, endian);

  /// Creates a new buffer of length at least [minLength] in size, or if
  /// [minLength == null, at least double the length of the current buffer;
  /// and then copies the contents of the current buffer into the new buffer.
  /// Finally, the new buffer becomes the buffer for _this_.
  bool grow([int minLength]) {
    final old = _bd;
    _bd = _grow(old, minLength ??= old.lengthInBytes * 2);
    return _bd == old;
  }
}

const int _k1GB = 1024 * 1024 * 1024;
const int kDefaultLimit = _k1GB;

/// Ensures that [bd] is at least [minLength] long, and grows
/// the buf if necessary, preserving existing data.
bool _ensureLength(ByteData bd, int minLength) =>
    (minLength > bd.lengthInBytes) ? _reallyGrow(bd, minLength) : false;

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
    if (newLength >= kDefaultLimit) return null;
  } while (newLength < minLength);
  final newBD = new ByteData(newLength);
  for (var i = 0; i < bd.lengthInBytes; i++) newBD.setUint8(i, bd.getUint8(i));
  return newBD;
}

bool checkAllZeros(ByteData bd, int start, int end) {
  for (var i = start; i < end; i++) if (bd.getUint8(i) != 0) return false;
  return true;
}
