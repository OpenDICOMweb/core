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

// ignore_for_file: non_constant_identifier_names,
// ignore_for_file: prefer_initializing_formals

abstract class BufferBase {
  Bytes get buffer;
  int get rIndex_;
  set rIndex_(int position);
  int get wIndex_;
  set wIndex_(int position);
  bool get isEmpty;

  // **** End of Interface

  ByteData get bd;

  Endian get endian => buffer.endian;

  int get offsetInBytes => buffer.offsetInBytes;
  int get start => buffer.offsetInBytes;
  int get length => buffer.length;
  int get lengthInBytes => buffer.lengthInBytes;
  int get end => start + lengthInBytes;

  int get rRemaining => wIndex_ - rIndex_;

  /// Returns the number of writeable bytes left in _this_.
  int get wRemaining => end - wIndex_;

  bool get isReadable => rRemaining > 0;
  bool get isNotReadable => !isReadable;
  bool get isWritable => wRemaining > 0;
  bool get isNotWritable => !isWritable;

  bool get isNotEmpty => !isEmpty;

  bool rHasRemaining(int n) => (rIndex_ + n) <= wIndex_;
  bool wHasRemaining(int n) => (wIndex_ + n) <= end;

  /// Returns a _view_ of [buffer] containing the bytes from [start] inclusive
  /// to [end] exclusive. If [end] is omitted, the [length] of _this_ is used.
  /// An error occurs if [start] is outside the range 0 .. [length],
  /// or if [end] is outside the range [start] .. [length].
  /// [lengthInBytes].
  Bytes subbytes([int start = 0, int end]) =>
      new Bytes.view(buffer, start, (end ?? length) -  start);

  /// Return a view of _this_ of [length], starting at [start]. If [length]
  /// is _null_ it defaults to [lengthInBytes].
  Bytes asBytes([int start = 0, int length]) =>
      buffer.toBytes(start, length ?? lengthInBytes);


  ByteData asByteData([int offset, int length]) =>
      buffer.asByteData(offset ?? rIndex_, length ?? wIndex_);

  Uint8List asUint8List([int offset, int length]) =>
      buffer.asUint8List(offset ?? rIndex_, length ?? wIndex_);

  bool checkAllZeros(int offset, int end) {
    for (var i = offset; i < end; i++) if (buffer.getUint8(i) != 0) return false;
    return true;
  }

  // *** Reader specific Getters and Methods

  int get rIndex => rIndex_;
  set rIndex(int n) {
    if (rIndex_ < 0 || rIndex_ > wIndex_)
      throw new RangeError.range(rIndex, 0, wIndex_);
    rIndex_ = n;
  }

  int rSkip(int n) {
    final v = rIndex_ + n;
    if (v < 0 || v > wIndex_) throw new RangeError.range(v, 0, wIndex_);
    return rIndex_ = v;
  }

  Uint8List get contentsRead =>
      buffer.buffer.asUint8List(buffer.offsetInBytes, rIndex_);
  Uint8List get contentsUnread => buffer.buffer.asUint8List(rIndex_, wIndex_);

  // *** wIndex
  int get wIndex => wIndex_;
  set wIndex(int n) {
    if (wIndex_ <= rIndex_ || wIndex_ > buffer.lengthInBytes)
      throw new RangeError.range(wIndex_, rIndex_, buffer.lengthInBytes);
    wIndex_ = n;
  }

  /// Moves the [wIndex] forward/backward. Returns the new [wIndex].
  int wSkip(int n) {
    final v = wIndex_ + n;
    if (v <= rIndex_ || v >= buffer.lengthInBytes)
      throw new RangeError.range(v, 0, buffer.lengthInBytes);
    return wIndex_ = v;
  }

  Uint8List get contentsWritten => buffer.buffer.asUint8List(rIndex_, wIndex);

  @override
  String toString() => '$runtimeType: @R$rIndex @W$wIndex $buffer';
}
