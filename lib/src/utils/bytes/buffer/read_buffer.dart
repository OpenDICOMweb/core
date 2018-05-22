//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/src/element/bytes/dicom_bytes.dart';
import 'package:core/src/utils/bytes/buffer/buffer_base.dart';
import 'package:core/src/utils/bytes/bytes.dart';

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: prefer_initializing_formals

class ReadBuffer extends Buffer {

  ReadBuffer(Bytes buffer) : super(buffer, 0, buffer.length);

  ReadBuffer.from(ReadBuffer rb,
      [int offset, int length, Endian endian])
      : super.from(rb, offset, length, endian);

  ReadBuffer.fromByteData(ByteData bd, [int offset = 0, int length, Endian
  endian])
      :   super.fromByteData(bd, offset,
                                 length ?? bd.lengthInBytes, endian ??
                                                              Endian.host);

  ReadBuffer.fromList(List<int> list,
                      [int offset, int length, Endian endian])
      : super.fromList(list, offset, length, endian);

  ReadBuffer.fromTypedData(TypedData td, [int offset, int length, Endian endian])
      : super.fromTypedData(td, offset, length, endian);

/* Urgent: Jim todo
  ReadBuffer.fromString(String s, [Endian endian])
      : endian = endian ??= Endian.host,
        rIndex_ = 0,
        wIndex_ = td.lengthInBytes,
        bytes = new Bytes.fromTypedData(td, endian);
*/

  // **** ReadBuffer specific Getters and Methods

 // Bytes _buffer;
  int get index => rIndex;

  int get remaining => rRemaining;

  bool get isEmpty => isNotReadable;

  bool hasRemaining(int n) => rHasRemaining(n);

}

class DicomReadBuffer<V> extends ReadBuffer {
  bool _isClosed = false;
  bool get isClosed => _isClosed;

  DicomReadBuffer(DicomBytes buffer) : super(buffer);

  DicomReadBuffer.from(DicomReadBuffer rb,
                       [int offset, int length, Endian endian = Endian.little])
    super.from(rb, length, endian);

  @override
  ByteData get bd => (isClosed) ? null : buffer.bd;



  /// Returns _true_ if this reader [isClosed] and it [isNotEmpty].
  bool get hadTrailingBytes => (isClosed) ? isNotEmpty : false;
  bool _hadTrailingZeros;
  bool get hadTrailingZeros => _hadTrailingZeros ?? false;
  void get reset {
    buffer.rReset;
    _isClosed = false;
    _hadTrailingZeros = false;
  }
  /// Peek at next tag - doesn't move the [rIndex].
  int peekCode() => buffer.getCode(rIndex);

  int getCode(int start) => peekCode();

  int readCode() {
    final code = peekCode();
    rIndex += 4;
    return code;
  }

  /// Peek at next tag - doesn't move the [rIndex].
  int readVRCode() {
    assert(rIndex.isEven && hasRemaining(4), '@$rIndex : $remaining');
    final vr = buffer.getVRCode(rIndex);
    rIndex += 2;
    return vr;
  }


}
class LoggingReadBuffer extends ReadBuffer {
  factory LoggingReadBuffer(ByteData bd,
          [int offset = 0, int length, Endian endian = Endian.little]) =>
      new LoggingReadBuffer._(bd.buffer.asByteData(offset, length), endian);

  factory LoggingReadBuffer.fromUint8List(Uint8List bytes,
      [int offset = 0, int length, Endian endian = Endian.little]) {
    final bd = bytes.buffer.asByteData(offset, length);
    return new LoggingReadBuffer._(bd, endian);
  }

  LoggingReadBuffer._(TypedData td, Endian endian)
      : super.fromTypedData(td.buffer.asByteData(), endian);

  /// The current readIndex as a string.
  String get _rrr => 'R@${rIndex_.toString().padLeft(5, '0')}';
  String get rrr => _rrr;

  /// The beginning of reading something.
  String get rbb => '> $_rrr';

  /// In the middle of reading something.
  String get rmm => '| $_rrr';

  /// The end of reading something.
  String get ree => '< $_rrr';

  String get pad => ''.padRight('$_rrr'.length);

  void warn(Object msg) => print('** Warning: $msg $_rrr');

  void error(Object msg) => throw new Exception('**** Error: $msg $_rrr');
}
