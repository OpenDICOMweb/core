// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/utils/dicom_bytes/dicom_bytes.dart';
import 'package:core/src/vr.dart';

// ignore_for_file: public_member_api_docs

abstract class DicomReadBufferMixin {
  DicomBytes get buffer;
  int get index;
  set index(int index);
  int get remaining;
  bool hasRemaining(int n);

  /// Returns the DICOM Tag Code at [offset].
  int getCode(int offset) =>
      (buffer.getUint16(offset) << 16) + buffer.getUint16(offset + 2);

  /// Reads the DICOM Tag Code at the current [index]. It does not
  /// move the [index].
  int peekCode() => getCode(index);

  /// Reads the DICOM Tag Code at the current [index], and advances
  /// the [index] by four bytes.
  int readCode() {
    assert(index.isEven && hasRemaining(8), '@$index : $remaining');
    final code = peekCode();
    index += 4;
    return code;
  }

  int readVRCode() => _readVRCode();

  /// Read the VR .
  int _readVRCode() {
    assert(index.isEven && hasRemaining(4), '@$index : $remaining');
    final vrCode = (buffer.getUint8(index) << 8) + buffer.getUint8(index + 1);
    index += 2;
    return vrCode;
  }

  int readVRIndex() => vrIndexFromCode(_readVRCode());

  /// Read an EVR short Value Field Length.
  int readShortVLF() {
    assert(index.isEven && hasRemaining(2), '@$index : $remaining');
    final vlf = buffer.getUint16(index);
    index += 2;
    return vlf;
  }
}
