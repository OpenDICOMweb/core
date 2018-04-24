//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.utils.buffer;

// ignore_for_file: non_constant_identifier_names

abstract class BufferMixin {
  Bytes get bytes;
  int get rIndex_;
  set rIndex_(int n);
  int get wIndex_;
  set wIndex_(int n);
  bool get isEmpty;

  ByteData get bd => bytes.bd;

  Endian get endian => bytes.endian;

  int get offsetInBytes => bytes.offset;
  int get start => bytes.offset;
  int get length => bytes.length;
//  int get lengthInBytes => bytes.length;
  int get end => start + length;

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

  Bytes asBytes([int offset = 0, int length]) =>
    //final offset = _getOffset(offset, length);
     bytes.toBytes(offset, length ?? length);


  ByteData asByteData([int offset = 0, int length]) =>
  //  final offset = _getOffset(offset, length);
     bytes.asByteData(offset, length ?? length);

  Uint8List asUint8List([int offset = 0, int length]) =>
      bytes.asUint8List(offset, length ?? length);

  bool checkAllZeros(int offset, int end) {
    for (var i = offset; i < end; i++) if (bytes.getUint8(i) != 0) return false;
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
      bytes.buffer.asUint8List(bytes.offset, rIndex_);
  Uint8List get contentsUnread => bytes.buffer.asUint8List(rIndex_, wIndex_);

  // *** wIndex
  int get wIndex => wIndex_;
  set wIndex(int n) {
    if (wIndex_ <= rIndex_ || wIndex_ > bytes.length)
      throw new RangeError.range(wIndex_, rIndex_, bytes.length);
    wIndex_ = n;
  }

  /// Moves the [wIndex] forward/backward. Returns the new [wIndex].
  int wSkip(int n) {
    final v = wIndex_ + n;
    if (v <= rIndex_ || v >= bytes.length)
      throw new RangeError.range(v, 0, bytes.length);
    return wIndex_ = v;
  }

  Uint8List get contentsWritten => bytes.buffer.asUint8List(rIndex_, wIndex);
}
