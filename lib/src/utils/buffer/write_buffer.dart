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
  final GrowableBytes _buf;
  @override
  final int _rIndex;
  @override
  int _wIndex;

  factory WriteBuffer(
          [int length = Bytes.kDefaultLength,
          Endian endian,
          int limit = kDefaultLimit]) =>
      WriteBuffer._(length, endian, limit);

  factory WriteBuffer.from(WriteBuffer wb,
          [int offset = 0,
          int length,
          Endian endian = Endian.little,
          int limit = kDefaultLimit]) =>
      WriteBuffer._from(wb, offset, length, endian, limit);

  factory WriteBuffer.typedDataView(TypedData td,
          [int offset = 0,
          int lengthInBytes,
          Endian endian = Endian.little,
          int limit = kDefaultLimit]) =>
      WriteBuffer._tdView(td, offset, lengthInBytes, endian, limit);

  WriteBuffer._(int length, Endian endian, int limit)
      : _rIndex = 0,
        _wIndex = 0,
        _buf = GrowableBytes(length, endian, limit);

  WriteBuffer._from(
      WriteBuffer wb, int offset, int length, Endian endian, int limit)
      : _rIndex = offset,
        _wIndex = offset,
        _buf = GrowableBytes.from(wb._buf, offset, length, endian, limit);

  WriteBuffer._tdView(
      TypedData td, int offset, int lengthInBytes, Endian endian, int limit)
      : _rIndex = offset ?? 0,
        _wIndex = lengthInBytes ?? td.lengthInBytes,
        _buf = GrowableBytes.typedDataView(td, offset ?? 0,
            lengthInBytes ?? td.lengthInBytes, endian ?? Endian.host, limit);

  @override
  set _rIndex(int n) => unsupportedError();

  // **** WriteBuffer specific Getters and Methods

  int get index => _wIndex;
  bool get isEmpty => _wIsEmpty;
  bool get isNotEmpty => _wIsNotEmpty;

  /// Returns the number of bytes left in the current _this_.
  int get remaining => _wRemaining;

  bool hasRemaining(int n) => _wHasRemaining(n);

  ByteData get bd => isClosed ? null : _buf.asByteData();

  ByteData close() {
    final bd = _buf.asByteData(0, _wIndex);
    _isClosed = true;
    return bd;
  }

  bool get isClosed => _isClosed;
  bool _isClosed = false;

  void get reset {
  //  _rIndex = 0;
    _wIndex = 0;
    _isClosed = false;
  }
}
