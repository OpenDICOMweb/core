//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.utils.bytes;

class IvrLEBytes extends DicomLEBytes {
  IvrLEBytes(int eLength) : super._(eLength);

  IvrLEBytes.from(Bytes bytes, int start, int end)
      : super._from(bytes, start, end);

  @override
  int get vfOffset => kVFOffset;
  @override
  int get vfLengthOffset => kVFLengthOffset;

  @override
  int get vfLengthField {
    final vlf = _bd.getUint32(kVFLengthOffset);
    assert(_checkVFLengthField(vlf, vfLength));
    return vlf;
  }

  @override
  int getVRCode(int offset) => unsupportedError();
  @override
  int getVLF(int offset) => _bd.getUint32(offset);

  /// Write a short EVR header.
  @override void ivrSetHeader(int code, int vrCode, int vlf) {
    _bd
      ..setUint16(0, code >> 16)
      ..setUint16(2, code & 0xFFFF)
      ..setUint32(6, vlf);
  }

  static const int kVFLengthOffset = 4;
  static const int kVFOffset = 8;
  static const int kHeaderLength = 8;

  static IvrLEBytes make(int code, int vrCode, Uint8List vfBytes,
      [Endian endian = Endian.little]) {
    var vfLength = vfBytes.length;
    if (vfLength.isOdd) vfLength++;
    final e = new IvrLEBytes(kHeaderLength + vfLength)
      ..ivrSetHeader(code, vrCode, vfLength);

    print('    code: ${dcm(e.code)}');
    print('vfLength: ${e.vfLength}');
    print(' vfBytes: ${e.vfBytes}');
    return e;
  }
}
