//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.utils.dicom_bytes;

// ignore_for_file: public_member_api_docs

/// A growable [DicomBytes].
class GrowableDicomBytes extends GrowableBytes with DicomWriterMixin {
  /// Creates a growable [DicomBytes].
  GrowableDicomBytes([int length, Endian endian, int limit = kDefaultLimit])
      : super(length, endian, limit);

  /// Returns a new [Bytes] of [length].
  GrowableDicomBytes._(int length, Endian endian, int limit)
      : super(length, endian, limit);

  /// Creates a growable [DicomBytes] from [bytes].
  factory GrowableDicomBytes.from(Bytes bytes,
          [int offset = 0,
          int length,
          Endian endian,
          int limit = kDefaultLimit]) =>
      GrowableDicomBytes._from(bytes, offset, length, endian, limit);

  GrowableDicomBytes._from(Bytes bytes, int offset, int length, Endian endian,
      [int limit = kDefaultLimit])
      : super.from(bytes, offset, length, endian, limit);

  /// Creates a growable [DicomBytes] from a view of [td].
  GrowableDicomBytes.typedDataView(TypedData td,
      [int offset = 0, int lengthInBytes, Endian endian, int limit = k1GB])
      : super.typedDataView(td, offset, lengthInBytes, endian, limit);
}

abstract class DicomWriterMixin {
  ByteData _bd;
// **** End of Interface

  /// Returns the Tag Code from [Bytes].
  void setCode(int code) {
    _bd..setUint16(0, code >> 16)..setUint16(2, code & 0xFFFF);
  }

  void setVRCode(int vrCode) {
    _bd..setUint8(4, vrCode >> 8)..setUint8(5, vrCode & 0xFF);
  }

  void setShortVLF(int vlf) => _bd.setUint16(6, vlf);
  void setLongVLF(int vlf) => _bd.setUint32(8, vlf);

  /// Write a short EVR header.
  void evrSetShortHeader(int code, int vrCode, int vlf) {
    _bd
      ..setUint16(0, code >> 16)
      ..setUint16(2, code & 0xFFFF)
      ..setUint16(4, vrCode)
      ..setUint16(6, vlf);
  }

  /// Write a short EVR header.
  void evrSetLongHeader(int code, int vrCode, int vlf) {
    _bd
      ..setUint16(0, code >> 16)
      ..setUint16(2, code & 0xFFFF)
      ..setUint16(4, vrCode)
      ..setUint16(6, 0)
      ..setUint32(8, vlf);
  }

  /// Write a short EVR header.
  void ivrSetHeader(int offset, int code, int vlf) {
    _bd
      ..setUint16(offset, code >> 16)
      ..setUint16(2, code & 0xFFFF)
      ..setUint32(4, vlf);
  }
}
