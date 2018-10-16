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

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: prefer_initializing_formals
// ignore_for_file: public_member_api_docs

abstract class DicomWriteBufferMixin {
  DicomGrowableBytes get buffer;
  int get wIndex;
  set wIndex(int index);
  int get remaining;
  bool get isEmpty;
  bool get isNotEmpty;
  bool hasRemaining(int n);
  bool maybeGrow(int remaining);
  // **** ReadBuffer specific Getters and Methods

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
