//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.utils.bytes;

abstract class EvrBytes extends DicomBytes {
  EvrBytes._(int eLength, Endian endian) : super._(eLength, endian);

  EvrBytes._from(Bytes bytes, int start, int end, Endian endian)
      : super._from(bytes, start, end, endian ?? Endian.host);

  int get vrCode => _bd.getUint16(_kVROffset, endian);
  int get vrIndex => vrIndexFromCode(vrCode);
  String get vrId => vrIdFromIndex(vrIndex);

  static const _kVROffset = 4;

  @override
  String toString() {
    final vrc = vrCode;
    final vri = vrIndex;
    final vr = vrId;
    return '$runtimeType ${dcm(code)} $vr($vri, ${hex16(vrc)}) '
        'vlf($vfLengthField) vfl($vfLength) ${toBDDescriptor(_bd)})';
  }

/*
  @override
  String toString() =>
      '$runtimeType ${dcm(code)} ${hex16(vrCode)} $vfLengthField $vfLength';
*/

}

class EvrShortBytes extends EvrBytes {
  EvrShortBytes(int eLength, [Endian endian]) : super._(eLength, endian);

  EvrShortBytes.from(Bytes bytes, [int start = 0, int end, Endian endian])
      : super._from(bytes, start, end, endian);

  @override
  int get vfOffset => kVFOffset;
  @override
  int get vfLengthOffset => kVFLengthOffset;

  @override
  int get vfLengthField {
    final vlf = getUint16(kVFLengthOffset);
    assert(_checkVFLengthField(vlf, vfLength));
    return vlf;
  }

  // ** Primitive Getters
  @override
  int getVLF(int offset) => _bd.getUint16(offset, endian);

  static const int kVROffset = 4;
  static const int kVFLengthOffset = 6;
  static const int kVFOffset = 8;
  static const int kHeaderLength = kVFOffset;

  static EvrShortBytes makeEmpty(int code, int vrCode, int vfLength,
      [Endian endian]) {
    assert(vfLength.isEven);
    final e = new EvrShortBytes(kHeaderLength + vfLength, endian)
      ..evrSetShortHeader(code, vrCode, vfLength);
    print('e: $e');
    return e;
  }

  static EvrShortBytes makeFromBytes(int code, int vrCode, Bytes vfBytes,
      [Endian endian = Endian.little]) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    final e = new EvrShortBytes(kHeaderLength + vfLength, endian)
      ..evrSetShortHeader(code, vrCode, vfLength)
      ..setByteData(kVFOffset, vfBytes._bd);
    print('e: $e');
    return e;
  }
}

class EvrLongBytes extends EvrBytes {
  EvrLongBytes(int eLength, [Endian endian]) : super._(eLength, endian);

  EvrLongBytes.from(Bytes bytes, [int start = 0, int end, Endian endian])
      : super._from(bytes, start, end, endian);

  @override
  int get vfOffset => kVFOffset;
  @override
  int get vfLengthOffset => kVFLengthOffset;

  @override
  int get vfLengthField {
    final vlf = getUint32(kVFLengthOffset);
    assert(_checkVFLengthField(vlf, vfLength));
    return vlf;
  }

  @override
  int getVLF(int offset) => _bd.getUint32(offset);

  static const int kVROffset = 4;
  static const int kVFLengthOffset = 8;
  static const int kVFOffset = 12;
  static const int kHeaderLength = kVFOffset;

  static EvrLongBytes makeEmpty(int code, int vrCode, int vfLength,
      [Endian endian]) {
    assert(vfLength.isEven);
    final e = new EvrLongBytes(kHeaderLength + vfLength, endian)
      ..evrSetLongHeader(code, vrCode, vfLength);
    print('e: $e');
    return e;
  }

  static EvrLongBytes makeFromBytes(int code, int vrCode, Bytes vfBytes,
      [Endian endian]) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    final e = new EvrLongBytes(kHeaderLength + vfLength, endian)
      ..evrSetLongHeader(code, vrCode, vfLength)
      ..setByteData(kVFOffset, vfBytes._bd);
    print('e: $e');
    return e;
  }
}
