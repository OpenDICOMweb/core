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
import 'write_buffer_mixin.dart';

/// A writable [ByteBuffer].
class WriteBuffer extends BytesBuffer with WriteBufferMixin {
  @override
  final GrowableBytes bytes;
  @override
  final int rIndex;
  @override
  int wIndex;

  /// Creates an empty WriteBuffer.
  WriteBuffer(
      [int length = kDefaultLength,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : rIndex = 0,
        wIndex = 0,
        bytes = GrowableBytes(length, endian, limit);

  /// Creates a [WriteBuffer] from another [WriteBuffer].
  WriteBuffer.from(WriteBuffer wb,
      [int offset = 0,
      int length,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : rIndex = offset,
        wIndex = offset,
        bytes = GrowableBytes.from(wb.bytes, offset, length, endian, limit);

  /// Creates a WriteBuffer from a [GrowableBytes].
  WriteBuffer.fromBytes(this.bytes, this.rIndex, this.wIndex);

  /// Creates a [WriteBuffer] that uses a [TypedData] view of [td].
  WriteBuffer.typedDataView(TypedData td,
      [int offset = 0,
      int lengthInBytes,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : rIndex = offset ?? 0,
        wIndex = lengthInBytes ?? td.lengthInBytes,
        bytes = GrowableBytes.typedDataView(td, offset ?? 0,
            lengthInBytes ?? td.lengthInBytes, endian ?? Endian.host, limit);
}
