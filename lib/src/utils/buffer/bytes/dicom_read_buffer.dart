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

abstract class DicomReadMixin {
  DicomBytes get _buf;
  int get _rIndex;
  int get index;
  int get _wIndex;
  set _rIndex(int index);
  int get _rRemaining;
  bool _rHasRemaining(int n);

  /// Returns the DICOM Tag Code at [offset].
  int getCode(int offset) => _buf.getCode(offset);

  /// Reads the DICOM Tag Code at the current [index]. It does not
  /// move the [index].
  int peekCode() => _buf.getCode(_rIndex);

  /// Reads the DICOM Tag Code at the current [index], and advances
  /// the [index] by four bytes.
  int readCode() {
    assert(_rIndex.isEven && _rHasRemaining(8), '@$_rIndex : $_rRemaining');
    final code = peekCode();
    _rIndex += 4;
    return code;
  }

  /// Read the VR .
  int readVRCode() => _readVRCode();
  int _readVRCode() {
    assert(_rIndex.isEven && _rHasRemaining(4), '@$_rIndex : $_rRemaining');
    final vrCode = _buf.getVRCode(_rIndex);
    _rIndex += 2;
    return vrCode;
  }

  int readVRIndex() => vrIndexFromCode(_readVRCode());

  /// Read an EVR short Value Field Length.
  int readShortVLF() {
    assert(_rIndex.isEven && _rHasRemaining(2), '@$_rIndex : $_rRemaining');
    final vlf = _buf.getShortVLF(_rIndex);
    _rIndex += 2;
    return vlf;
  }


  /// Read a 32-bit Value Field Length field.
  int _readLongVLF() {
    assert(_rIndex.isEven && _rHasRemaining(4), '@$_rIndex : $_rRemaining');
    final vlf = _buf.getUint32(_rIndex);
    _rIndex += 4;
    return vlf;
  }
}

class DicomReadBuffer extends ReadBuffer with DicomReadMixin {
  DicomReadBuffer(Bytes buf, [int offset = 0, int length])
      : super._(buf, offset, length);

  DicomReadBuffer.fromTypedData(TypedData td,
      [int offset = 0, int length, Endian endian])
      : super._fromTypedData(td, offset, length, endian);
}
