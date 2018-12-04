//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/utils/bytes/new_bytes.dart';
import 'package:core/src/utils/bytes/growable_bytes.dart';
import 'package:core/src/utils/dicom_bytes/dicom_bytes.dart';

// ignore_for_file: public_member_api_docs

/// A growable [DicomBytes].
abstract class DicomGrowableBytes extends Bytes
    with GrowableMixin, DicomWriterMixin {
  /// Creates a growable [DicomBytes].
  factory DicomGrowableBytes(
          [int length = Bytes.kDefaultLength,
          Endian endian = Endian.little,
          int limit = Bytes.kDefaultLimit]) =>
      endian == Endian.big
          ? DicomGrowableBytesBE(length, limit)
          : DicomGrowableBytesLE(length, limit);

  /// Creates a growable [DicomBytes] from [bytes].
  factory DicomGrowableBytes.from(Bytes bytes,
          [int offset = 0,
          int length,
          Endian endian = Endian.little,
          int limit = Bytes.kDefaultLimit]) =>
      endian == Endian.big
          ? DicomGrowableBytesBE.from(bytes, offset, length, limit)
          : DicomGrowableBytesLE.from(bytes, offset, length, limit);

  /// Creates a growable [DicomBytes] from a view of [td].
  factory DicomGrowableBytes.typedDataView(TypedData td,
          [int offset = 0,
          int length,
          Endian endian = Endian.little,
          int limit = Bytes.kDefaultLimit]) =>
      endian == Endian.big
          ? DicomGrowableBytesBE.typedDataView(td, offset, length, limit)
          : DicomGrowableBytesLE.typedDataView(td, offset, length, limit);


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

class DicomGrowableBytesLE extends BytesLE
    with GrowableMixin, DicomWriterMixin {
  /// The upper bound on the length of this [Bytes]. If [limit]
  /// is _null_ then its length cannot be changed.
  @override
  final int limit;

  /// Returns a new little endian [GrowableBytes] of [length].
  DicomGrowableBytesLE([int length, this.limit = Bytes.kDefaultLimit])
      : super(length);

  /// Returns a new little endian [GrowableBytes] copied from [bytes].
  DicomGrowableBytesLE.from(Bytes bytes,
      [int offset = 0, int length, this.limit = Bytes.kDefaultLimit])
      : super.from(bytes, offset, length);

  /// Returns a little endian [GrowableBytes]view of [td].
  DicomGrowableBytesLE.typedDataView(TypedData td,
      [int offset = 0, int lengthInBytes, this.limit = Bytes.kDefaultLimit])
      : super.typedDataView(td, offset, lengthInBytes);
}

class DicomGrowableBytesBE extends BytesBE
    with GrowableMixin, DicomWriterMixin {
  /// The upper bound on the length of this [Bytes]. If [limit]
  /// is _null_ then its length cannot be changed.
  @override
  final int limit;

  /// Returns a new little endian [GrowableBytes] of [length].
  DicomGrowableBytesBE([int length, this.limit = Bytes.kDefaultLimit])
      : super(length);

  /// Returns a new little endian [GrowableBytes] copied from [bytes].
  DicomGrowableBytesBE.from(Bytes bytes,
      [int offset = 0, int length, this.limit = Bytes.kDefaultLimit])
      : super.from(bytes, offset, length);

  /// Returns a little endian [GrowableBytes]view of [td].
  DicomGrowableBytesBE.typedDataView(TypedData td,
      [int offset = 0, int lengthInBytes, this.limit = Bytes.kDefaultLimit])
      : super.typedDataView(td, offset, lengthInBytes);
}
