//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.utils.bytes;


abstract class EvrLEBytes extends DicomLEBytes {
  EvrLEBytes._(int eLength)
      : super._(eLength);

  EvrLEBytes._from(Bytes bytes, int start, int end)
      : super._from(bytes, start, end);

  @override
  ByteData get _bd;

  int get vrCode => _bd.getUint16(_kVROffset);
  int get vrIndex => vrIndexFromCode(vrCode);
  String get vrId => vrIdFromIndex(vrIndex);

  static const _kVROffset = 4;

  @override
  int getVRCode(int offset) => _bd.getUint16(offset);

  @override
  String toString() {
    final vrc = vrCode;
    final vri = vrIndex;
    final vr = vrId;
    return '$runtimeType ${dcm(code)} $vr($vri, ${hex16(vrc)}) '
        'vlf: $vfLengthField vfl: $vfLength $vfBytes)';
  }
}

class EvrShortLEBytes extends EvrLEBytes {
  EvrShortLEBytes(int eLength)
      : super._(eLength);

  EvrShortLEBytes.from(Bytes bytes, int start, int end)
      : super._from(bytes, start, end);

  @override
  int get vfOffset => kVFOffset;
  @override
  int get vfLengthOffset => kVFLengthOffset;

  @override
  int get vfLengthField {
    final vlf = _bd.getUint16(kVFLengthOffset);
    assert(_checkVFLengthField(vlf, vfLength));
    return vlf;
  }

  // ** Primitive Getters
  @override
  int getVLF(int offset) => _bd.getUint16(offset);

/*
  /// Write a short EVR header.
  void evrSetShortHeader(int code, int vrCode, int vlf) {
    print('_bd: $_bd ${_bd.lengthInBytes}');
    _bd
      ..setUint16(0, code >> 16)
      ..setUint16(2, code & 0xFFFF)
      ..setUint16(4, vrCode)
      ..setUint16(6, vlf);
  }
*/

  static const int kVROffset = 4;
  static const int kVFLengthOffset = 6;
  static const int kVFOffset = 8;
  static const int kHeaderLength = kVFOffset;

  static EvrShortLEBytes make(int code, int vrCode, Uint8List vfBytes,
      [Endian endian = Endian.little]) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    final e = new EvrShortLEBytes(kHeaderLength + vfLength)
      ..evrSetShortHeader(code, vrCode, vfLength);
    return e;
  }
}

class EvrLongLEBytes extends EvrLEBytes {
  EvrLongLEBytes(int eLength)
      : super._(eLength);
  EvrLongLEBytes.from(Bytes bytes, int start, int end)
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
  int getVLF(int offset) => _bd.getUint32(offset);

/*
  /// Write a short EVR header.
  void evrSetLongHeader(int code, int vrCode, int vlf) {
    _bd
      ..setUint16(0, code >> 16)
      ..setUint16(2, code & 0xFFFF)
      ..setUint16(4, vrCode)
// This field is ze ro, but GC takes care of  that
//    _setUint16( 6, 0)
      ..setUint32(8, vlf);
  }
*/

  static EvrLongLEBytes make(int code, int vrCode, Uint8List vfBytes,
      [Endian endian = Endian.little]) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    final e = new EvrLongLEBytes(kHeaderLength + vfLength)
      ..evrSetLongHeader(code, vrCode, vfLength);
    return e;
  }

  static const int kVROffset = 4;
  static const int kVFLengthOffset = 8;
  static const int kVFOffset = 12;
  static const int kHeaderLength = kVFOffset;
}
