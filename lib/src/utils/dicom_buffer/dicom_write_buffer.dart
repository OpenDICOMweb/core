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

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: prefer_initializing_formals
// ignore_for_file: public_member_api_docs
// ignore_for_file: overridden_fields

class DicomWriteBuffer extends WriteBuffer {
  @override
  final DicomGrowableBytes buffer;
  @override
  final int rIndex;
  @override
  int wIndex;

  DicomWriteBuffer(
      [int length = kDefaultLength,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : rIndex = 0,
        wIndex = 0,
        buffer = DicomGrowableBytes(length, endian, limit);

  DicomWriteBuffer.from(WriteBuffer wb,
      [int offset = 0,
      int length,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : rIndex = offset,
        wIndex = offset,
        buffer =
            DicomGrowableBytes.from(wb.buffer, offset, length, endian, limit);

  DicomWriteBuffer.typedDataView(TypedData td,
      [int offset = 0,
      int lengthInBytes,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : rIndex = offset ?? 0,
        wIndex = lengthInBytes ?? td.lengthInBytes,
        buffer = DicomGrowableBytes.typedDataView(td, offset ?? 0,
            lengthInBytes ?? td.lengthInBytes, endian ?? Endian.host, limit);

  /// Write a DICOM Tag Code to _this_.
  void writeCode(int code, [int eLength = 12]) {
    assert(wIndex.isEven && code != null);
    maybeGrow(eLength);
    buffer..setUint16(wIndex, code >> 16)..setUint16(wIndex + 2, code & 0xFFFF);
    wIndex += 4;
  }

  /// Peek at next tag - doesn't move the [wIndex].
  void writeVRCode(int code) {
    assert(wIndex.isEven && hasRemaining(4), '@$wIndex : $remaining');
    buffer.setVRCode(code);
    wIndex += 2;
  }

  /// Write a DICOM Tag Code to _this_.
  void writeEvrShortHeader(int code, int vrCode, int vlf) {
    assert(wIndex.isEven);
    maybeGrow(8);
    buffer.evrSetShortHeader(code, vrCode, vlf);
    wIndex += 8;
  }

  /// Write a DICOM Tag Code to _this_.
  void writeEvrLongHeader(int code, int vrCode, int vlf) {
    assert(wIndex.isEven);
    maybeGrow(12);
    buffer.evrSetLongHeader(code, vrCode, vlf);
    wIndex += 12;
  }

  /// Write a DICOM Tag Code to _this_.
  void writeIvrHeader(int code, int vrCode, int vlf) {
    assert(wIndex.isEven);
    maybeGrow(8);
    buffer.ivrSetHeader(wIndex, code, vlf);
    wIndex += 8;
  }
}
