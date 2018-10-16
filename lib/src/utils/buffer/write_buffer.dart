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
// ignore_for_file: prefer_initializing_formals
// ignore_for_file: public_member_api_docs

class WriteBuffer extends BytesBuffer with WriteBufferMixin {
  @override
  final GrowableBytes buffer;
  @override
  final int rIndex;
  @override
  int wIndex;

  WriteBuffer(
      [int length = kDefaultLength,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : rIndex = 0,
        wIndex = 0,
        buffer = GrowableBytes(length, endian, limit);

  WriteBuffer.fromBytes(this.buffer, this.rIndex, this.wIndex);

  WriteBuffer.from(WriteBuffer wb,
      [int offset = 0,
      int length,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : rIndex = offset,
        wIndex = offset,
        buffer = GrowableBytes.from(wb.buffer, offset, length, endian, limit);

  WriteBuffer.typedDataView(TypedData td,
      [int offset = 0,
      int lengthInBytes,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : rIndex = offset ?? 0,
        wIndex = lengthInBytes ?? td.lengthInBytes,
        buffer = GrowableBytes.typedDataView(td, offset ?? 0,
            lengthInBytes ?? td.lengthInBytes, endian ?? Endian.host, limit);
}
