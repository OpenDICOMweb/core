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
import 'package:core/src/utils/buffer.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/dicom_bytes.dart';
import 'package:core/src/vr.dart';
*/

part of odw.sdk.core.buffer;

// ignore_for_file: public_member_api_docs

/// A [BytesBuffer] for reading DicomBytes from [Bytes].
/// EVR and IVR are taken care of by the underlying [Bytes].
class DicomReadBuffer extends ReadBufferBase with ReadBufferMixin {
  /// The [Bytes] being read.
  ///
  /// _Note_: This MUST NOT be a [DicomBytes].
  @override
  final Bytes _bytes;
  @override
  int _rIndex;
  @override
  int _wIndex;

  /// Constructor
  DicomReadBuffer(this._bytes, [int offset = 0, int length])
      : _rIndex = offset ?? 0,
        _wIndex = length ?? _bytes.length;

  /// Returns the DICOM Tag Code at [offset].
  int getCode(int offset) =>
      (_bytes.getUint16(offset) << 16) + _bytes.getUint16(offset + 2);

  /// Reads the DICOM Tag Code at the current [_rIndex]. It does not
  /// move the [_rIndex].
  int peekCode() => getCode(_rIndex);

  /// Reads the DICOM Tag Code at the current [_rIndex], and advances
  /// the [_rIndex] by four _bytes.
  int readCode() {
    assert(_rIndex.isEven && hasRemaining(8), '@$_rIndex : $remaining');
    final code = peekCode();
    _rIndex += 4;
    return code;
  }

  int readVRCode() => _readVRCode();

  /// Read the VR .
  int _readVRCode() {
    assert(_rIndex.isEven && hasRemaining(4), '@$_rIndex : $remaining');
    final vrCode =
        (_bytes.getUint8(_rIndex) << 8) + _bytes.getUint8(_rIndex + 1);
    _rIndex += 2;
    return vrCode;
  }

  int readVRIndex() => vrIndexFromCode(_readVRCode());

  /// Read a short Value Field Length.
  int readShortVLF() {
    assert(_rIndex.isEven && hasRemaining(2), '@$_rIndex : $remaining');
    final vlf = _bytes.getUint16(_rIndex);
    _rIndex += 2;
    return vlf;
  }
}
