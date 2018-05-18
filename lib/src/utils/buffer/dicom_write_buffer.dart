// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.utils.buffer;

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: prefer_initializing_formals

abstract class DicomWriteBufferMixin  {
  DicomGrowableBytes get _buf;
  int get _wIndex;
  set _wIndex(int index);
  int get _wRemaining;
  bool get _wIsEmpty;
  bool _wHasRemaining(int n);
  bool _maybeGrow(int remaining);
  // **** ReadBuffer specific Getters and Methods

  bool get isEmpty;
  bool get isNotEmpty => !_wIsEmpty;
//  int get remaining => _wRemaining;
//  bool hasRemaining(int n) => _wHasRemaining(n);

  /// Write a DICOM Tag Code to _this_.
  void writeCode(int code, [int eLength = 12]) {
//    _checkCode(code);
    assert(_wIndex.isEven);
    _maybeGrow(eLength);
    _buf..setUint16(_wIndex, code >> 16)..setUint16(_wIndex + 2, code & 0xFFFF);
    _wIndex += 4;
  }

  /// Peek at next tag - doesn't move the [_wIndex].
  void writeVRCode(int code) {
    assert(_wIndex.isEven && _wHasRemaining(4), '@$_wIndex : $_wRemaining');
    _buf.setVRCode(code);
    _wIndex += 2;
  }

  /// Write a DICOM Tag Code to _this_.
  void writeEvrShortHeader(int code, int vrCode, int vlf) {
//    _checkEvrShortHeader(code, vrCode, vlf);
    assert(_wIndex.isEven);
    _maybeGrow(8);
    _buf.evrSetShortHeader(code, vrCode, vlf);
    _wIndex += 8;
  }

  /// Write a DICOM Tag Code to _this_.
  void writeEvrLongHeader(int code, int vrCode, int vlf) {
//    _checkEvrLongHeader(code, vrCode, vlf);
    assert(_wIndex.isEven);
    _maybeGrow(12);
    _buf.evrSetLongHeader(code, vrCode, vlf);
    _wIndex += 12;
  }

  /// Write a DICOM Tag Code to _this_.
  void writeIvrHeader(int code, int vrCode, int vlf) {
//    _checkIvrHeader(code, vrCode, vlf);
    assert(_wIndex.isEven);
    _maybeGrow(8);
    _buf.ivrSetHeader(_wIndex, code, vlf);
    _wIndex += 8;
  }

// Urgent Jim: move to system
bool allowInvalidTagCode = true;

void _checkCode(int code) {
  if (!allowInvalidTagCode) {
    assert(code >= 0x00020000 &&
           code <= kSequenceDelimitationItem, 'Value out of range: $code (${dcm(
        code)})');
  }
}

void _checkVRCode(int vrCode) {

}

void _checkShortVlf(int vlf) {}
void _checkLongVlf(int vlf) {}

void _checkShortHeader(int code, int vrCode, int vlf) {
  _checkCode(code);
  _checkVRCode(vrCode);
  _checkShortVlf(vlf);
}

void _checkLongHeader(int code, int vrCode, int vlf) {
  _checkCode(code);
  _checkVRCode(vrCode);
  _checkLongVlf(vlf);
}

}

class DicomWriteBuffer extends WriteBuffer with DicomWriteBufferMixin {

  DicomWriteBuffer(
      [int length = Bytes.kDefaultLength,
        Endian endian,
        int limit = kDefaultLimit])
      : super._(length, endian, limit);

   DicomWriteBuffer.from(WriteBuffer wb,
                           [int offset = 0,
                             int length,
                             Endian endian = Endian.little,
                             int limit = kDefaultLimit])
      : super._from(wb, offset, length, endian, limit);

   DicomWriteBuffer.typedDataView(TypedData td,
                                    [int offset = 0,
                                      int lengthInBytes,
                                      Endian endian = Endian.little,
                                      int limit = kDefaultLimit])
      : super._tdView(td, offset, lengthInBytes, endian, limit);
}

