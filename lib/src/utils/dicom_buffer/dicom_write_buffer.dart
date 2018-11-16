// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.core.buffer;

/// A [WriteBuffer] for binary DICOM objects.
class DicomWriteBuffer extends WriteBuffer {
  /// Creates an empty [DicomWriteBuffer].
  DicomWriteBuffer(
      [int length = kDefaultLength,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : super(length, endian, limit);

  /// Creates a [DicomWriteBuffer] from a [WriteBuffer].
  DicomWriteBuffer.from(WriteBuffer wb,
      [int offset = 0,
      int length,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : super.from(wb, offset, length, endian, limit);

  /// Creates a [DicomWriteBuffer] from a [GrowableBytes].
  DicomWriteBuffer.fromBytes(GrowableBytes bytes, int rIndex, int wIndex)
      : super.fromBytes(bytes, rIndex, wIndex);

  /// Creates a [[DicomWriteBuffer]] that uses a [TypedData] view of [td].
  DicomWriteBuffer.typedDataView(TypedData td,
      [int offset = 0,
      int lengthInBytes,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : super.typedDataView(td, offset, lengthInBytes, endian, limit);

  /// Write a DICOM Tag Code to _this_.
  void writeCode(int code, [int eLength = 12]) {
    assert(_wIndex.isEven && code != null);
    maybeGrow(eLength);
    bytes
      ..setUint16(_wIndex, code >> 16)
      ..setUint16(_wIndex + 2, code & 0xFFFF);
    _wIndex += 4;
  }

  /// Peek at next tag - doesn't move the [_wIndex].
  void writeVRCode(int vrCode) {
    assert(_wIndex.isEven && hasRemaining(4), '@$_wIndex : $remaining');
    bytes..setUint8(4, vrCode >> 8)..setUint8(5, vrCode & 0xFF);
    _wIndex += 2;
  }

  /// Write a DICOM Tag Code to _this_.
  void writeEvrShortHeader(int code, int vrCode, int vlf) {
    assert(_wIndex.isEven);
    maybeGrow(8 + vlf);
    bytes
      ..setUint16(0, code >> 16)
      ..setUint16(2, code & 0xFFFF)
      ..setUint8(4, vrCode >> 8)
      ..setUint8(5, vrCode & 0xFF)
      ..setUint16(6, vlf);
    _wIndex += 8;
  }

  /// Write a DICOM Tag Code to _this_.
  void writeEvrLongHeader(int code, int vrCode, int vlf,
      {bool isUndefinedLength = false}) {
    assert(_wIndex.isEven);
    maybeGrow(12 + vlf);
    bytes
      ..setUint16(0, code >> 16)
      ..setUint16(2, code & 0xFFFF)
      ..setUint8(4, vrCode >> 8)
      ..setUint8(5, vrCode & 0xFF)
      ..setUint16(6, 0)
      ..setUint32(8, isUndefinedLength ? kUndefinedLength : vlf);
    _wIndex += 12;
  }

  /// Write a DICOM Tag Code to _this_.
  void writeIvrHeader(int code, int vrCode, int vlf) {
    assert(_wIndex.isEven);
    maybeGrow(8 + vlf);
    bytes
      ..setUint16(0, code >> 16)
      ..setUint16(2, code & 0xFFFF)
      ..setUint32(4, vlf);
    _wIndex += 8;
  }
}
