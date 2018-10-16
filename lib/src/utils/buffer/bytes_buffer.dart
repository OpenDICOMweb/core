//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
library odw.sdk.utils.buffer;

import 'dart:typed_data';

import 'package:core/src/utils.dart';
import 'package:core/src/utils/buffer/read_buffer_mixin.dart';
import 'package:core/src/utils/buffer/write_buffer_mixin.dart';
import 'package:core/src/utils/bytes.dart';

part 'package:core/src/utils/buffer/read_buffer.dart';
part 'package:core/src/utils/buffer/write_buffer.dart';

// ignore_for_file: public_member_api_docs

/// The base class for Buffer
abstract class BytesBuffer {
  // **** Interface
  /// The underlying [Bytes] for the buffer.
  Bytes get buffer;
//  int get _rIndex;
//  set _rIndex(int n);
//  int get _wIndex;
//  set _wIndex(int n) => unsupportedError();

  // **** Internal Primitives
  int get _offset => buffer.offset;
  int get _start => buffer.offset;
  int get _length => buffer.length;

  int get _end => _start + buffer.length;

  // **** End Internal Primitives

  int get readIndex;
  int get writeIndex;
  bool get isNotReadable => !isReadable;
  bool get isNotWritable => !isWritable;

  // ****  External Getters




  /// The maximum [length] of _this_.
  int get limit => buffer.limit;

  /// The endianness of _this_.
  Endian get endian => buffer.endian;

  /// The offset of _this_ in the underlying [ByteBuffer].
  int get offset => _offset;

  /// The offset of [buffer] in the underlying [ByteBuffer].
  int get start => _start;

  /// The length of the [buffer].
  int get length => _length;

  int get end => _start + _length;

  /// The number of readable bytes in [buffer].
  int get readRemaining;

  /// Returns _true_ if [readRemaining] >= 0.
  bool get isReadable;

  /// The current number of writable bytes in [buffer].
  int get writeRemaining;

  /// Returns _true_ if [writeRemaining] >= 0.
  bool get isWritable;

  /// The maximum number of writable bytes in [buffer].
  int get writeRemainingMax;

  /// Returns the number of writeable bytes left in _this_.
//  int get wRemaining => _wRemaining;

  // ****  End of External Getters

  bool rHasRemaining(int n) => (readIndex + n) <= writeIndex;
  bool wHasRemaining(int n) => (writeIndex + n) <= _end;

  /// Returns a _view_ of [buffer] containing the bytes from [start] inclusive
  /// to [end] exclusive. If [end] is omitted, the [length] of _this_ is used.
  /// An error occurs if [start] is outside the range 0 .. [length],
  /// or if [end] is outside the range [start] .. [length].
  /// [length].
  Bytes sublist([int start = 0, int end]) =>
      Bytes.from(buffer, start, (end ?? length) - start);

  /// Return a view of _this_ of [length], starting at [start]. If [length]
  /// is _null_ it defaults to [length].
  Bytes view([int start = 0, int length]) =>
      buffer.asBytes(start, length ?? length);

  ByteData asByteData([int offset, int length]) =>
      buffer.asByteData(offset ?? readIndex, length ?? writeIndex);

  Uint8List asUint8List([int offset, int length]) =>
      buffer.asUint8List(offset ?? readIndex, length ?? writeIndex);

  void rWarn(Object msg) => print('** Warning: $msg @$readIndex');

  void rError(Object msg) => throw Exception('**** Error: $msg @$writeIndex');

  void wWarn(Object msg) => print('** Warning: $msg @$readIndex');

  void wError(Object msg) => throw Exception('**** Error: $msg @$writeIndex');
}
