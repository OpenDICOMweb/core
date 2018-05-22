//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.utils.bytes;

class IvrBytes extends DicomBytes {
  IvrBytes(int eLength) : super._(eLength, Endian.little);

  IvrBytes.from(Bytes bytes, int start, int end)
      : super._from(bytes, start, end, Endian.little);

  @override
  bool get isEvr => false;
  @override
  int get vrCode => _bd.getUint16(kVROffset, Endian.little);
  @override
  int get vrIndex => vrIndexFromCode(vrCode);
  @override
  String get vrId => vrIdFromIndex(vrIndex);

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

  static const int kVROffset = 4;
  static const int kVFLengthOffset = 4;
  static const int kVFOffset = 8;
  static const int kHeaderLength = 8;

  static IvrBytes makeEmpty(
    int code,
    int vfLength,
    int vrCode,
  ) {
    assert(vfLength.isEven);
    final e = new IvrBytes(kHeaderLength + vfLength)
      ..ivrSetHeader(code, vfLength, vrCode);
    print('e: $e');
    return e;
  }

  static IvrBytes makeFromBytes(
    int code,
    Bytes vfBytes,
    int vrCode,
  ) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    final e = new IvrBytes(kHeaderLength + vfLength)
      ..ivrSetHeader(code, vfLength, vrCode)
      ..setByteData(kVFOffset, vfBytes._bd);
    print('e: $e');
    return e;
  }
}