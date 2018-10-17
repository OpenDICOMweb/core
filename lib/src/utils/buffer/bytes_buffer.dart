//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
library odw.sdk.core.buffer;

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/dicom_bytes.dart';

import 'package:core/src/vr.dart';

part 'read_buffer.dart';
part 'read_buffer_mixin.dart';
part 'write_buffer.dart';
part 'write_buffer_mixin.dart';

part 'package:core/src/utils/dicom_buffer/dicom_read_buffer.dart';
part 'package:core/src/utils/dicom_buffer/dicom_write_buffer.dart';

/// The base class for Buffer
abstract class BytesBuffer {
  /// The underlying [Bytes] for the buffer.
  Bytes get _bytes;
  int get _rIndex;
  set _rIndex(int n);
  int get _wIndex;

  // **** Internal Primitives
  int get _offset => _bytes.offset;
  int get _start => _bytes.offset;
  int get _length => _bytes.length;

  int get _end => _start + _bytes.length;

  // **** End Internal Primitives

  /// The underlying [Bytes] for the buffer.
  Bytes get bytes => _bytes;
  /// The read index into the underlying bytes.
  int get readIndex => _rIndex;

  /// Pseudonym for [readIndex].
  int get rIndex => _rIndex;

  /// Pseudonym for set [readIndex].
  set rIndex(int n) => _rIndex = n;

  /// The write index into the underlying bytes.
  int get writeIndex => _rIndex;

  /// Pseudonym for [writeIndex].
  int get wIndex => _wIndex;

  /// Returns _true_ if the _this_ is not readable.
  bool get isNotReadable => !isReadable;

  /// Returns _true_ if the _this_ is not writable.
  bool get isNotWritable => !isWritable;

  // ****  External Getters

  /// The maximum [length] of _this_.
  int get limit => _bytes.limit;

  /// The endianness of _this_.
  Endian get endian => _bytes.endian;

  /// The offset of _this_ in the underlying [ByteBuffer].
  int get offset => _offset;

  /// The offset of [bytes] in the underlying [ByteBuffer].
  int get start => _start;

  /// The length of the [bytes].
  int get length => _length;

  /// The index of the _end_ of _this_. _Note_: [end] is not a legal index.
  int get end => _start + _length;

  /// The number of readable bytes in [bytes].
  int get readRemaining;

  /// Returns _true_ if [readRemaining] >= 0.
  bool get isReadable;

  /// The current number of writable bytes in [bytes].
  int get writeRemaining;

  /// Returns _true_ if [writeRemaining] >= 0.
  bool get isWritable;

  /// The maximum number of writable bytes in [bytes].
  int get writeRemainingMax;

  /// Returns the number of writeable bytes left in _this_.
//  int get wRemaining => _wRemaining;

  // ****  End of External Getters

  /// Returns _true_ if _this_ has [n] readable bytes.
  bool rHasRemaining(int n) => (readIndex + n) <= writeIndex;

  /// Returns _true_ if _this_ has [n] writable bytes.
  bool wHasRemaining(int n) => (writeIndex + n) <= _end;

  /// Returns a _view_ of [bytes] containing the bytes from [start] inclusive
  /// to [end] exclusive. If [end] is omitted, the [length] of _this_ is used.
  /// An error occurs if [start] is outside the range 0 .. [length],
  /// or if [end] is outside the range [start] .. [length].
  /// [length].
  Bytes sublist([int start = 0, int end]) =>
      Bytes.from(_bytes, start, (end ?? length) - start);

  /// Return a view of _this_ of [length], starting at [start]. If [length]
  /// is _null_ it defaults to [length].
  Bytes view([int start = 0, int length]) =>
      _bytes.asBytes(start, length ?? length);

  /// Return a [ByteData] view of _this_ of [length], starting at [start].
  /// If [length] is _null_ it defaults to [length].
  ByteData asByteData([int start, int length]) =>
      _bytes.asByteData(start ?? readIndex, length ?? writeIndex);

  /// Return a [Uint8List] view of _this_ of [length], starting at [start].
  /// If [length] is _null_ it defaults to [length].
  Uint8List asUint8List([int start, int length]) =>
      _bytes.asUint8List(start ?? readIndex, length ?? writeIndex);

  /// Prints a warning message when reading.
  void rWarn(Object msg) => print('** Warning: $msg @$readIndex');

  /// Prints a Error message when reading.
  void rError(Object msg) => throw Exception('**** Error: $msg @$writeIndex');

  /// Prints a warning message when writing.
  void wWarn(Object msg) => print('** Warning: $msg @$readIndex');

  /// Prints a Error message when writing.
  void wError(Object msg) => throw Exception('**** Error: $msg @$writeIndex');
}
