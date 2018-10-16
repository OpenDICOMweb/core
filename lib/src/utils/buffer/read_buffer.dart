//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/utils/bytes.dart';

import 'bytes_buffer.dart';
import 'read_buffer_mixin.dart';

/// The base class for readable [BytesBuffer]s.
abstract class ReadBufferBase extends BytesBuffer {
  /// The [Bytes] that _this_ reads from.
  @override
  Bytes get bytes;
  /// The current read index.
  int get rIndex;
  /// The current write index.
  int get wIndex;

  // **** ReadBuffer specific Getters and Methods

  /// Return a new Big Endian[ReadBuffer] containing the unread
  /// portion of _this_.
  ReadBuffer get asBigEndian =>
      ReadBuffer.from(this, rIndex, wIndex, Endian.big);

  /// Return a new Little Endian[ReadBuffer] containing the unread
  /// portion of _this_.
  ReadBuffer get asLittleEndian =>
      ReadBuffer.from(this, rIndex, wIndex, Endian.little);
}

/// A read only buffer.
///
///
class ReadBuffer extends ReadBufferBase with ReadBufferMixin {
  @override
  final Bytes bytes;
  @override
  int rIndex;
  @override
  int wIndex;

  /// Creates a [ReadBuffer] of [length] starting at [offset] in [bytes].
  ReadBuffer(this.bytes, [int offset = 0, int length])
      : rIndex = offset ?? 0,
        wIndex = length ?? bytes.length;

  /// Creates a [ReadBuffer] from another [ReadBuffer].
  ReadBuffer.from(ReadBuffer rb,
      [int offset = 0, int length, Endian endian = Endian.little])
      : bytes = Bytes.from(rb.bytes, offset, length, endian),
        rIndex = offset ?? rb.bytes.offset,
        wIndex = length ?? rb.bytes.length;

  /// Creates a [ReadBuffer] from a [ByteData].
  ReadBuffer.fromByteData(ByteData bd,
      [int offset, int length, Endian endian = Endian.little])
      : bytes = Bytes.typedDataView(bd, offset, length, endian),
        rIndex = offset ?? bd.offsetInBytes,
        wIndex = length ?? bd.lengthInBytes;

  /// Creates a [ReadBuffer] from an [List<int>].
  ReadBuffer.fromList(List<int> list, [Endian endian])
      : bytes = Bytes.fromList(list, endian ?? Endian.little),
        rIndex = 0,
        wIndex = list.length;

  /// Creates a [ReadBuffer] from a view of [td].
  ReadBuffer.typedDataView(TypedData td,
      [int offset = 0, int length, Endian endian = Endian.little])
      : bytes = Bytes.typedDataView(td, offset, length, endian),
        rIndex = offset ?? td.offsetInBytes,
        wIndex = length ?? td.lengthInBytes;
}

/// A mixin used for logging [ReadBuffer] methods.
abstract class LoggingReadBufferMixin {
  /// The read index into the underlying [Bytes].
  int get rIndex;

  String get _rrr => 'R@${rIndex.toString().padLeft(5, '0')}';

  /// The current readIndex as a string.
  String get rrr => _rrr;

  /// The beginning of reading something.
  String get rbb => '> $_rrr';

  /// In the middle of reading something.
  String get rmm => '| $_rrr';

  /// The end of reading something.
  String get ree => '< $_rrr';

  /// Right pads [rrr] with spaces.
  String get pad => ''.padRight('$_rrr'.length);
}

/// A [ReadBuffer] that logs calls to methods.
class LoggingReadBuffer extends ReadBuffer with LoggingReadBufferMixin {
  /// Creates a [LoggingReadBuffer] from [ByteData].
  factory LoggingReadBuffer(ByteData bd,
          [int offset = 0, int length, Endian endian = Endian.little]) =>
      LoggingReadBuffer._(
          bd.buffer.asByteData(offset, length), 0, length, endian);

  /// Creates a [LoggingReadBuffer] from a [Uint8List].
  factory LoggingReadBuffer.fromUint8List(Uint8List bytes,
      [int offset = 0, int length, Endian endian]) {
    final bd = bytes.buffer.asByteData(offset, length);
    return LoggingReadBuffer._(bd, offset, length, endian);
  }

  LoggingReadBuffer._(TypedData td, [int offset = 0, int length, Endian endian])
      : super.typedDataView(td, offset, length, endian);
}
