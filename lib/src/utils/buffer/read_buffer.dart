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

abstract class ReadBufferBase extends BytesBuffer {
  @override
  Bytes get buffer;
  int get rIndex;
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

class ReadBuffer extends ReadBufferBase with ReadBufferMixin {
  @override
  final Bytes buffer;
  @override
  int rIndex;
  @override
  int wIndex;

  ReadBuffer(this.buffer, [int offset = 0, int length])
      : rIndex = offset ?? 0,
        wIndex = length ?? buffer.length;

  ReadBuffer.from(ReadBuffer rb,
      [int offset = 0, int length, Endian endian = Endian.little])
      : buffer = Bytes.from(rb.buffer, offset, length, endian),
        rIndex = offset ?? rb.buffer.offset,
        wIndex = length ?? rb.buffer.length;

  ReadBuffer.fromByteData(ByteData bd,
      [int offset, int length, Endian endian = Endian.little])
      : buffer = Bytes.typedDataView(bd, offset, length, endian),
        rIndex = offset ?? bd.offsetInBytes,
        wIndex = length ?? bd.lengthInBytes;

  ReadBuffer.fromList(List<int> list, [Endian endian])
      : buffer = Bytes.fromList(list, endian ?? Endian.little),
        rIndex = 0,
        wIndex = list.length;

  ReadBuffer.fromTypedData(TypedData td,
      [int offset = 0, int length, Endian endian = Endian.little])
      : buffer = Bytes.typedDataView(td, offset, length, endian),
        rIndex = offset ?? td.offsetInBytes,
        wIndex = length ?? td.lengthInBytes;
}

abstract class LoggingReadBufferMixin {
  int get rIndex;

  /// The current readIndex as a string.
  String get _rrr => 'R@${rIndex.toString().padLeft(5, '0')}';
  String get rrr => _rrr;

  /// The beginning of reading something.
  String get rbb => '> $_rrr';

  /// In the middle of reading something.
  String get rmm => '| $_rrr';

  /// The end of reading something.
  String get ree => '< $_rrr';

  String get pad => ''.padRight('$_rrr'.length);
}

class LoggingReadBuffer extends ReadBuffer with LoggingReadBufferMixin {
  factory LoggingReadBuffer(ByteData bd,
          [int offset = 0, int length, Endian endian = Endian.little]) =>
      LoggingReadBuffer._(
          bd.buffer.asByteData(offset, length), 0, length, endian);

  factory LoggingReadBuffer.fromUint8List(Uint8List bytes,
      [int offset = 0, int length, Endian endian]) {
    final bd = bytes.buffer.asByteData(offset, length);
    return LoggingReadBuffer._(bd, offset, length, endian);
  }

  LoggingReadBuffer._(TypedData td, [int offset = 0, int length, Endian endian])
      : super.fromTypedData(td, offset, length, endian);
}
