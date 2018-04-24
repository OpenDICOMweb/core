//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
library odw.sdk.utils.buffer;

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/src/utils.dart';
import 'package:core/src/utils/buffer/buffer_base.dart';
import 'package:core/src/utils/bytes/bytes.dart';
import 'package:core/src/vr.dart';

part 'package:core/src/utils/buffer/buffer_mixin.dart';
part 'package:core/src/utils/buffer/bytes/buffer.dart';
part 'package:core/src/utils/buffer/bytes/dicom_read_buffer.dart';
part 'package:core/src/utils/buffer/bytes/dicom_write_buffer.dart';
part 'package:core/src/utils/buffer/bytes/read_buffer.dart';
part 'package:core/src/utils/buffer/bytes/read_mixin.dart';
part 'package:core/src/utils/buffer/bytes/write_buffer.dart';
part 'package:core/src/utils/buffer/bytes/write_mixin.dart';

/// The base class for Buffer
abstract class BytesBufferBase implements BufferBase {
  // **** Interface
  /// The underlying [Bytes] for the buffer.
  Bytes get _buf;
  int get _rIndex;
  set _rIndex(int n);
  int get _wIndex;
  set _wIndex(int n) => unsupportedError();

  // **** Internal Primitives
  int get _offset => _buf.offset;
  int get _start => _buf.offset;
  int get _length => _buf.length;

  int get _end => _start + _buf.length;

  int get _rRemaining => _wIndex - _rIndex;
  bool get _isReadable => _rRemaining > 0;
  bool get _rIsEmpty => _rRemaining <= 0;
  bool get _rIsNotEmpty => !_rIsEmpty;
  bool _rHasRemaining(int n) {
    assert(n >= 0);
    return _rRemaining > 0;
  }

  int get _wRemaining => _buf.length - _wIndex;
  bool get _isWritable => _wRemaining > 0;
  bool get _wIsEmpty => _wRemaining <= 0;
  bool get _wIsNotEmpty => !_wIsEmpty;
  int get _wRemainingMax => kDefaultLimit - _wIndex;
  bool _wHasRemaining(int n) {
    assert(n >= 0);
    return _rRemaining > 0;
  }
  // **** End Internal Primitives

  int get readIndex => _rIndex;
  int get writeIndex => _wIndex;
  bool get isNotReadable => !isReadable;
  bool get isNotWritable => !isWritable;

  // ****  External Getters

  /// The underlying [Bytes]
  Bytes get buffer => _buf;

  /// The maximum [length] of _this_.
  int get limit => _buf.limit;

  /// The endianness of _this_.
  Endian get endian => _buf.endian;

  /// The offset of _this_ in the underlying [ByteBuffer].
  int get offset => _offset;

  /// The offset of [buffer] in the underlying [ByteBuffer].
  int get start => _start;

  /// The length of the [buffer].
  int get length => _length;

//  int get lengthInBytes => _buffer.length;
  int get end => _start + _length;

  /// The number of readable bytes in [buffer].
  int get readRemaining => _rRemaining;

  /// Returns _true_ if [readRemaining] >= 0.
  bool get isReadable => _isReadable;

  /// The current number of writable bytes in [buffer].
  int get writeRemaining => _wRemaining;

  /// Returns _true_ if [writeRemaining] >= 0.
  bool get isWritable => _isWritable;

  /// The maximum number of writable bytes in [buffer].
  int get writeRemainingMax => _wRemainingMax;

  /// Returns the number of writeable bytes left in _this_.
  int get wRemaining => _wRemaining;

  // ****  End of External Getters

  bool rHasRemaining(int n) => (_rIndex + n) <= _wIndex;
  bool wHasRemaining(int n) => (_wIndex + n) <= _end;

  /// Returns a _view_ of [buffer] containing the bytes from [start] inclusive
  /// to [end] exclusive. If [end] is omitted, the [length] of _this_ is used.
  /// An error occurs if [start] is outside the range 0 .. [length],
  /// or if [end] is outside the range [start] .. [length].
  /// [length].
  Bytes subbytes([int start = 0, int end]) =>
      new Bytes.from(_buf, start, (end ?? length) - start);

  ByteData toByteData(int offset, int length) =>
      _buf.buffer.asByteData(buffer.offset + offset, length);

  Uint8List toUint8List(int offset, int length) =>
      buffer.buffer.asUint8List(buffer.offset + offset, length);

  /// Return a view of _this_ of [length], starting at [start]. If [length]
  /// is _null_ it defaults to [length].
  Bytes asBytes([int start = 0, int length]) =>
      _buf.toBytes(start, length ?? length);

  ByteData asByteData([int offset, int length]) =>
      _buf.asByteData(offset ?? _rIndex, length ?? _wIndex);

  Uint8List asUint8List([int offset, int length]) =>
      _buf.asUint8List(offset ?? _rIndex, length ?? _wIndex);

  bool _checkAllZeros(int offset, int end) {
    for (var i = offset; i < end; i++) if (_buf.getUint8(i) != 0) return false;
    return true;
  }

  void rWarn(Object msg) => print('** Warning: $msg @$_rIndex');

  void rError(Object msg) => throw new Exception('**** Error: $msg @$_wIndex');

  void wWarn(Object msg) => print('** Warning: $msg @$_rIndex');

  void wError(Object msg) => throw new Exception('**** Error: $msg @$_wIndex');
}
