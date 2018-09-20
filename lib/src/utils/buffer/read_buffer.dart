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
  Bytes get _buf;
  @override
  int get _rIndex;
  @override
  int get _wIndex;

  // **** ReadBuffer specific Getters and Methods

  int get index => _rIndex;
  bool get isEmpty => _rIsEmpty;
  bool get isNotEmpty => !_rIsEmpty;
  int get remaining => _rRemaining;
  bool hasRemaining(int n) => _rHasRemaining(n);

  /// Return a new Big Endian[ReadBuffer] containing the unread
  /// portion of _this_.
  ReadBuffer get asBigEndian =>
      ReadBuffer.from(this, _rIndex, _wIndex, Endian.big);

  /// Return a new Little Endian[ReadBuffer] containing the unread
  /// portion of _this_.
  ReadBuffer get asLittleEndian =>
      ReadBuffer.from(this, _rIndex, _wIndex, Endian.little);

  /// The underlying [ByteData]
  ByteData get bd => isClosed ? null : _buf.asByteData();

  /// Returns _true_ if this reader isClosed and it [isNotEmpty].
  bool get hadTrailingBytes => _isClosed ? _rIsEmpty : false;
  bool _hadTrailingZeros = false;

  bool _isClosed = false;

  /// Returns _true_ if _this_ is no longer writable.
  bool get isClosed => _isClosed == null ? false : true;

  ByteData close() {
    if (hadTrailingBytes)
      _hadTrailingZeros = _checkAllZeros(_wIndex, _buf.length);
    final bd = _buf.asByteData(0, _wIndex);
    _isClosed = true;
    return bd;
  }

  bool get hadTrailingZeros => _hadTrailingZeros ?? false;
  ByteData rClose() {
    final view = asByteData(0, _rIndex);
    if (_rIsNotEmpty) {
      rError('End of Data with _rIndex($_rIndex) != '
          'length(${view.lengthInBytes})');
      _hadTrailingZeros = _checkAllZeros(_rIndex, _wIndex);
    }
    _isClosed = true;
    return view;
  }

  void get reset {
    _rIndex = 0;
    _isClosed = false;
    _hadTrailingZeros = false;
  }
}

class ReadBuffer extends ReadBufferBase with ReadBufferMixin {
  @override
  final Bytes _buf;
  @override
  int _rIndex;
  @override
  int _wIndex;

  ReadBuffer(this._buf, [int offset = 0, int length])
      : _rIndex = offset ?? 0,
        _wIndex = length ?? _buf.length;

  ReadBuffer._(this._buf, int offset, int length)
      : _rIndex = offset ?? 0,
        _wIndex = length ?? _buf.length;

  ReadBuffer._from(ReadBuffer rb, int offset, int length, Endian endian)
      : _buf = Bytes.from(rb._buf, offset, length, endian),
        _rIndex = offset ?? rb._buf.offset,
        _wIndex = length ?? rb._buf.length;

  factory ReadBuffer.from(ReadBuffer rb,
          [int offset = 0, int length, Endian endian]) =>
      ReadBuffer._from(rb, offset, length, endian);

  ReadBuffer.fromByteData(ByteData bd, [int offset, int length, Endian endian])
      : _buf = Bytes.typedDataView(bd, offset, length, endian),
        _rIndex = offset ?? bd.offsetInBytes,
        _wIndex = length ?? bd.lengthInBytes;

  ReadBuffer.fromList(List<int> list, [Endian endian])
      : _buf = Bytes.fromList(list, endian ?? Endian.little),
        _rIndex = 0,
        _wIndex = list.length;

  ReadBuffer._fromTypedData(TypedData td, int offset, int length, Endian endian)
      : _buf = Bytes.typedDataView(td, offset, length, endian),
        _rIndex = offset ?? td.offsetInBytes,
        _wIndex = length ?? td.lengthInBytes;

  factory ReadBuffer.fromTypedData(TypedData td,
          [int offset = 0, int length, Endian endian]) =>
      ReadBuffer._fromTypedData(td, offset, length, endian);
}

abstract class LoggingReadBufferMixin {
  int get _rIndex;

  /// The current readIndex as a string.
  String get _rrr => 'R@${_rIndex.toString().padLeft(5, '0')}';
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
      : super._fromTypedData(td, offset, length, endian);
}
