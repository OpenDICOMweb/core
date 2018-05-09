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

  @override
  bool get isEvr => true;
  @override
  int get vrCode => _bd.getUint16(kVROffset, endian);
  @override
  int get vrIndex => vrIndexFromCode(vrCode);
  @override
  String get vrId => vrIdFromIndex(vrIndex);

  static const int kVROffset = 4;
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

  static const int kVFLengthOffset = 6;
  static const int kVFOffset = 8;
  static const int kHeaderLength = kVFOffset;

  static EvrShortBytes makeEmpty(int code, int vfLength, int vrCode,
      [Endian endian]) {
    assert(vfLength.isEven);
    final e = new EvrShortBytes(kHeaderLength + vfLength, endian)
      ..evrSetShortHeader(code, vrCode, vfLength);
    print('e: $e');
    return e;
  }

  static EvrShortBytes makeFromBytes(int code, Bytes vfBytes, int vrCode,
      [Endian endian = Endian.little]) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    final e = new EvrShortBytes(kHeaderLength + vfLength, endian)
      ..evrSetShortHeader(code, vfLength, vrCode)
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

  static const int kVROffset = 4;
  static const int kVFLengthOffset = 8;
  static const int kVFOffset = 12;
  static const int kHeaderLength = kVFOffset;

  static EvrLongBytes makeEmpty(int code, int vfLength, int vrCode,
      [Endian endian]) {
    assert(vfLength.isEven);
    final e = new EvrLongBytes(kHeaderLength + vfLength, endian)
      ..evrSetLongHeader(code, vfLength, vrCode);
    print('e: $e');
    return e;
  }

  static EvrLongBytes makeFromBytes(int code, Bytes vfBytes, int vrCode,
      [Endian endian]) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    final e = new EvrLongBytes(kHeaderLength + vfLength, endian)
      ..evrSetLongHeader(code, vfLength, vrCode)
      ..setByteData(kVFOffset, vfBytes._bd);
    print('e: $e');
    return e;
  }
}
