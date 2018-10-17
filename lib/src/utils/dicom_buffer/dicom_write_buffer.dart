// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
/*
import 'dart:typed_data';

import 'package:core/src/utils/bytes/constants.dart';

import 'package:core/src/utils/buffer.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/dicom_bytes/dicom_bytes.dart';
*/

part of odw.sdk.core.buffer;

/// A [WriteBuffer] for binary DICOM objects.
class DicomWriteBuffer extends BytesBuffer with WriteBufferMixin {
  @override
  final GrowableDicomBytes _bytes;
  @override
  final int _rIndex;
  @override
  int _wIndex;

  /// Creates an empty [DicomWriteBuffer].
  DicomWriteBuffer(
      [int length = kDefaultLength,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : _rIndex = 0,
        _wIndex = 0,
        _bytes = GrowableDicomBytes(length, endian, limit);

  /// Creates a [DicomWriteBuffer] from a [WriteBuffer].
  DicomWriteBuffer.from(WriteBuffer wb,
      [int offset = 0,
      int length,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : _rIndex = offset,
        _wIndex = offset,
        _bytes =
            GrowableDicomBytes.from(wb._bytes, offset, length, endian, limit);

  /// Creates a [DicomWriteBuffer] from a [GrowableBytes].
  DicomWriteBuffer.fromBytes(this._bytes, this._rIndex, this._wIndex);

  /// Creates a [[DicomWriteBuffer]] that uses a [TypedData] view of [td].
  DicomWriteBuffer.typedDataView(TypedData td,
      [int offset = 0,
      int lengthInBytes,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : _rIndex = offset ?? 0,
        _wIndex = lengthInBytes ?? td.lengthInBytes,
        _bytes = GrowableDicomBytes.typedDataView(td, offset ?? 0,
            lengthInBytes ?? td.lengthInBytes, endian ?? Endian.host, limit);

  /// Write a DICOM Tag Code to _this_.
  void writeCode(int code, [int eLength = 12]) {
    assert(_wIndex.isEven && code != null);
    maybeGrow(eLength);
    _bytes
      ..setUint16(_wIndex, code >> 16)
      ..setUint16(_wIndex + 2, code & 0xFFFF);
    _wIndex += 4;
  }

  /// Peek at next tag - doesn't move the [_wIndex].
  void writeVRCode(int code) {
    assert(_wIndex.isEven && hasRemaining(4), '@$_wIndex : $remaining');
    _bytes.setVRCode(code);
    _wIndex += 2;
  }

  /// Write a DICOM Tag Code to _this_.
  void writeEvrShortHeader(int code, int vrCode, int vlf) {
    assert(_wIndex.isEven);
    maybeGrow(8);
    _bytes.evrSetShortHeader(code, vrCode, vlf);
    _wIndex += 8;
  }

  /// Write a DICOM Tag Code to _this_.
  void writeEvrLongHeader(int code, int vrCode, int vlf) {
    assert(_wIndex.isEven);
    maybeGrow(12);
    _bytes.evrSetLongHeader(code, vrCode, vlf);
    _wIndex += 12;
  }

  /// Write a DICOM Tag Code to _this_.
  void writeIvrHeader(int code, int vrCode, int vlf) {
    assert(_wIndex.isEven);
    maybeGrow(8);
    _bytes.ivrSetHeader(_wIndex, code, vlf);
    _wIndex += 8;
  }
}
