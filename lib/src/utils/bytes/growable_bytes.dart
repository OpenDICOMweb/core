//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/utils/bytes/new_bytes.dart';
import 'package:core/src/utils/bytes/little_endian_mixin.dart';
import 'package:core/src/utils/bytes/big_endian_mixin.dart';

mixin GrowableMixin {
  /// The upper bound on the length of this [Bytes]. If [limit]
  /// is _null_ then its length cannot be changed.
  int get limit;
  ByteData get bd;
  set bd(ByteData v);

  int get length => bd.lengthInBytes;

  set length(int newLength) {
    if (newLength < bd.lengthInBytes) return;
    grow(newLength);
  }

  /// Ensures that [bd] is at least [length] long, and grows
  /// the buf if necessary, preserving existing data.
  bool ensureLength(int length) => _ensureLength(bd, length);

  /// Creates a new buffer of length at least [minLength] in size, or if
  /// [minLength == null, at least double the length of the current buffer;
  /// and then copies the contents of the current buffer into the new buffer.
  /// Finally, the new buffer becomes the buffer for _this_.
  bool grow([int minLength]) {
    final old = bd;
    bd = _grow(old, minLength ??= old.lengthInBytes * 2);
    return bd == old;
  }

  /// If [minLength] is less than or equal to the current length of
  /// [bd] returns [bd]; otherwise, returns a new [ByteData] with a length
  /// of at least [minLength].
  static ByteData _grow(ByteData bd, int minLength) {
    final oldLength = bd.lengthInBytes;
    return (minLength <= oldLength) ? bd : _reallyGrow(bd, minLength);
  }

  /// Returns a new [ByteData] with length at least [minLength].
  static ByteData _reallyGrow(ByteData bd, int minLength) {
    var newLength = minLength;
    do {
      newLength *= 2;
      if (newLength >= Bytes.kDefaultLimit) return null;
    } while (newLength < minLength);
    final newBD = ByteData(newLength);
    for (var i = 0; i < bd.lengthInBytes; i++)
      newBD.setUint8(i, bd.getUint8(i));
    return newBD;
  }

  static bool checkAllZeros(ByteData bd, int start, int end) {
    for (var i = start; i < end; i++) if (bd.getUint8(i) != 0) return false;
    return true;
  }

  /// Ensures that [bd] is at least [minLength] long, and grows
  /// the buf if necessary, preserving existing data.
  static bool _ensureLength(ByteData bd, int minLength) =>
      (minLength > bd.lengthInBytes) ? _reallyGrow(bd, minLength) : false;
}

/// An abstract class that allows [Bytes] to grow in length.
abstract class GrowableBytes extends Bytes with GrowableMixin {
  /// Returns a new [GrowableBytes] created from [bd].
  GrowableBytes(ByteData bd) : super(bd);

  /// Returns a new [GrowableBytes] of [length].
  static GrowableBytes make(
          [int length = Bytes.kDefaultLength,
          Endian endian,
          int limit = Bytes.kDefaultLimit]) =>
      endian == Endian.big
          ? GrowableBytesBE(length, limit)
          : GrowableBytesLE(length, limit);

  /// Returns a new [GrowableBytes] created from [bytes].
  static GrowableBytes from(Bytes bytes,
          [int offset = 0,
          int length,
          Endian endian = Endian.little,
          int limit = Bytes.kDefaultLimit]) =>
      endian == Endian.big
          ? GrowableBytesBE.from(bytes, offset, length ?? bytes.length, limit)
          : GrowableBytesLE.from(bytes, offset, length ?? bytes.length, limit);

  /// Returns a new [GrowableBytes] created from [td].
  static GrowableBytes typedDataView(TypedData td,
          [int offset = 0,
          int length,
          Endian endian = Endian.little,
          int limit = Bytes.kDefaultLimit]) =>
      endian == Endian.big
          ? GrowableBytesBE.typedDataView(td, offset, length, limit)
          : GrowableBytesLE.typedDataView(td, offset, length, limit);
}

/// A class that allows little endian [Bytes] to grow in length.
class GrowableBytesLE extends GrowableBytes
    with LittleEndianMixin {
  /// The upper bound on the length of this [Bytes]. If [limit]
  /// is _null_ then its length cannot be changed.
  @override
  final int limit;

  /// Returns a new little endian [GrowableBytes] of [length].
  GrowableBytesLE([int length, this.limit = Bytes.kDefaultLimit])
      : super(ByteData(length));

  /// Returns a new little endian [GrowableBytes] copied from [bytes].
  GrowableBytesLE.from(Bytes bytes,
      [int offset = 0, int length, this.limit = Bytes.kDefaultLimit])
      : super(bytes.bd.buffer.asByteData(offset, length));

  /// Returns a little endian [GrowableBytes]view of [td].
  GrowableBytesLE.typedDataView(TypedData td,
      [int offset = 0, int lengthInBytes, this.limit = Bytes.kDefaultLimit])
      : super(td.buffer.asByteData(offset, lengthInBytes));
}

/// A class that allows big endian [Bytes] to grow in length.
class GrowableBytesBE extends Bytes
    with BigEndianMixin, GrowableMixin {
  /// The upper bound on the length of this [Bytes]. If [limit]
  /// is _null_ then its length cannot be changed.
  @override
  final int limit;

  /// Returns a new big endian [GrowableBytes] of [length].
  GrowableBytesBE([int length, this.limit = Bytes.kDefaultLimit])
      : super(ByteData(length));

  /// Returns a new big endian [GrowableBytes] copied from [bytes].
  GrowableBytesBE.from(Bytes bytes,
      [int offset = 0, int length, this.limit = Bytes.kDefaultLimit])
      : super(bytes.bd.buffer.asByteData(offset, length));

  /// Returns a big endian [GrowableBytes] view of [td].
  GrowableBytesBE.typedDataView(TypedData td,
      [int offset = 0, int lengthInBytes, this.limit = Bytes.kDefaultLimit])
      : super(td.buffer.asByteData(offset, lengthInBytes));
}
