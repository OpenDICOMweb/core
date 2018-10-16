// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/utils/buffer.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/dicom_bytes/dicom_bytes.dart';

/// A [WriteBuffer] for binary DICOM objects.
class DicomWriteBuffer extends BytesBuffer with WriteBufferMixin {
  @override
  final GrowableDicomBytes bytes;
  @override
  final int rIndex;
  @override
  int wIndex;

  /// Creates an empty [DicomWriteBuffer].
  DicomWriteBuffer(
      [int length = kDefaultLength,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : rIndex = 0,
        wIndex = 0,
        bytes = GrowableDicomBytes(length, endian, limit);

  /// Creates a [DicomWriteBuffer] from a [WriteBuffer].
  DicomWriteBuffer.from(WriteBuffer wb,
      [int offset = 0,
      int length,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : rIndex = offset,
        wIndex = offset,
        bytes =
            GrowableDicomBytes.from(wb.bytes, offset, length, endian, limit);

  /// Creates a [DicomWriteBuffer] from a [GrowableBytes].
  DicomWriteBuffer.fromBytes(this.bytes, this.rIndex, this.wIndex);

  /// Creates a [[DicomWriteBuffer]] that uses a [TypedData] view of [td].
  DicomWriteBuffer.typedDataView(TypedData td,
      [int offset = 0,
      int lengthInBytes,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : rIndex = offset ?? 0,
        wIndex = lengthInBytes ?? td.lengthInBytes,
        bytes = GrowableDicomBytes.typedDataView(td, offset ?? 0,
            lengthInBytes ?? td.lengthInBytes, endian ?? Endian.host, limit);

  /// Write a DICOM Tag Code to _this_.
  void writeCode(int code, [int eLength = 12]) {
    assert(wIndex.isEven && code != null);
    maybeGrow(eLength);
    bytes..setUint16(wIndex, code >> 16)..setUint16(wIndex + 2, code & 0xFFFF);
    wIndex += 4;
  }

  /// Peek at next tag - doesn't move the [wIndex].
  void writeVRCode(int code) {
    assert(wIndex.isEven && hasRemaining(4), '@$wIndex : $remaining');
    bytes.setVRCode(code);
    wIndex += 2;
  }

  /// Write a DICOM Tag Code to _this_.
  void writeEvrShortHeader(int code, int vrCode, int vlf) {
    assert(wIndex.isEven);
    maybeGrow(8);
    bytes.evrSetShortHeader(code, vrCode, vlf);
    wIndex += 8;
  }

  /// Write a DICOM Tag Code to _this_.
  void writeEvrLongHeader(int code, int vrCode, int vlf) {
    assert(wIndex.isEven);
    maybeGrow(12);
    bytes.evrSetLongHeader(code, vrCode, vlf);
    wIndex += 12;
  }

  /// Write a DICOM Tag Code to _this_.
  void writeIvrHeader(int code, int vrCode, int vlf) {
    assert(wIndex.isEven);
    maybeGrow(8);
    bytes.ivrSetHeader(wIndex, code, vlf);
    wIndex += 8;
  }
}
