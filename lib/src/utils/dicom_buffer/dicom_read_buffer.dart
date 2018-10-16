// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/utils/buffer.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/dicom_bytes.dart';
import 'package:core/src/utils/buffer/read_buffer_mixin.dart';
import 'package:core/src/vr.dart';

// ignore_for_file: public_member_api_docs

/// A [BytesBuffer] for reading [DicomBytes] from [Bytes].
/// EVR and IVR are taken care of by the underlying [Bytes].
class DicomReadBuffer extends ReadBufferBase
    with ReadBufferMixin {
  /// The [Bytes] being read.
  ///
  /// _Note_: This MUST NOT be a [DicomBytes].
  @override
  final Bytes bytes;
  @override
  int rIndex;
  @override
  int wIndex;

  /// Constructor
  DicomReadBuffer(this.bytes, [int offset = 0, int length])
      : rIndex = offset ?? 0,
        wIndex = length ?? bytes.length;

  /// Returns the DICOM Tag Code at [offset].
  int getCode(int offset) =>
      (bytes.getUint16(offset) << 16) + bytes.getUint16(offset + 2);

  /// Reads the DICOM Tag Code at the current [rIndex]. It does not
  /// move the [rIndex].
  int peekCode() => getCode(rIndex);

  /// Reads the DICOM Tag Code at the current [rIndex], and advances
  /// the [rIndex] by four bytes.
  int readCode() {
    assert(rIndex.isEven && hasRemaining(8), '@$rIndex : $remaining');
    final code = peekCode();
    rIndex += 4;
    return code;
  }

  int readVRCode() => _readVRCode();

  /// Read the VR .
  int _readVRCode() {
    assert(rIndex.isEven && hasRemaining(4), '@$rIndex : $remaining');
    final vrCode = (bytes.getUint8(rIndex) << 8) + bytes.getUint8(rIndex + 1);
    rIndex += 2;
    return vrCode;
  }

  int readVRIndex() => vrIndexFromCode(_readVRCode());

  /// Read a short Value Field Length.
  int readShortVLF() {
    assert(rIndex.isEven && hasRemaining(2), '@$rIndex : $remaining');
    final vlf = bytes.getUint16(rIndex);
    rIndex += 2;
    return vlf;
  }
}
