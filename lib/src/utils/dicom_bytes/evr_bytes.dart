//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.utils.dicom_bytes;

// ignore_for_file: public_member_api_docs

class EvrDicomBytes extends DicomBytes {
  factory EvrDicomBytes.from(Bytes bytes, int start, int vrIndex, int end) {
    if (isEvrShortVRIndex(vrIndex)) {
      return EvrShortBytes.from(bytes, start, end);
    } else if (isEvrLongVR(vrIndex)) {
      return EvrLongBytes.from(bytes, start, end);
    } else {
      return badVRIndex(vrIndex, null, null, null);
    }
  }

  EvrDicomBytes._(int eLength, Endian endian) : super._(eLength, endian);

  EvrDicomBytes._from(Bytes bytes, int start, int end, Endian endian)
      : super.from(bytes, start, end, endian ?? Endian.host);

  factory EvrDicomBytes.view(
      Bytes bytes, int start, int vrIndex, int end, Endian endian) {
    if (isEvrShortVRIndex(vrIndex)) {
      return EvrShortBytes.view(bytes, start, end, endian);
    } else if (isEvrLongVR(vrIndex)) {
      return EvrLongBytes.view(bytes, start, end, endian);
    } else {
      return badVRIndex(vrIndex, null, null, null);
    }
  }

  EvrDicomBytes._view(Bytes bytes, int offset, int length, Endian endian)
      : super._view(bytes, offset, length, endian);

  @override
  bool get isEvr => true;
  @override
  int get vrCode => getVRCode(kVROffset);
  @override
  int get vrIndex => vrIndexFromCode(vrCode);
  @override
  String get vrId => vrIdFromIndex(vrIndex);
  VR get vr => vrByIndex[vrIndex];

  static const int kVROffset = 4;
}

class EvrShortBytes extends EvrDicomBytes {
  EvrShortBytes(int eLength, [Endian endian]) : super._(eLength, endian);

  EvrShortBytes.from(Bytes bytes, [int start = 0, int end, Endian endian])
      : super._from(bytes, start, end, endian);

  EvrShortBytes.view(Bytes bytes, [int start = 0, int end, Endian endian])
      : super._view(bytes, start, end, endian);

  /// Returns an [EvrShortBytes] with an empty Value Field.
  factory EvrShortBytes.empty(int code, int vfLength, int vrCode,
      [Endian endian]) {
    final e = EvrShortBytes(kHeaderLength + vfLength, endian)
      ..evrSetShortHeader(code, vfLength, vrCode);
    return e;
  }

  factory EvrShortBytes.makeFromBytes(int code, Bytes vfBytes, int vrCode,
      [Endian endian = Endian.little]) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    final e = EvrShortBytes(kHeaderLength + vfLength, endian)
      ..evrSetShortHeader(code, vfLength, vrCode)
      ..setByteData(kVFOffset, vfBytes.bd);
    return e;
  }

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

  /// Returns a _view_ of _this_ containing the bytes from [start] inclusive
  /// to [end] exclusive. If [end] is omitted, the [length] of _this_ is used.
  /// An error occurs if [start] is outside the range 0 .. [length],
  /// or if [end] is outside the range [start] .. [length].
  @override
  EvrShortBytes sublist([int start = 0, int end]) =>
      EvrShortBytes.from(this, start, (end ?? length) - start, endian);

  static const int kVFLengthOffset = 6;
  static const int kVFOffset = 8;
  static const int kHeaderLength = kVFOffset;
}

class EvrLongBytes extends EvrDicomBytes {
  EvrLongBytes(int eLength, [Endian endian]) : super._(eLength, endian);

  EvrLongBytes.from(Bytes bytes, [int start = 0, int end, Endian endian])
      : super._from(bytes, start, end, endian);

  EvrLongBytes.view(Bytes bytes, [int start = 0, int end, Endian endian])
      : super._view(bytes, start, end, endian);

  /// Returns an [EvrLongBytes] with an empty Value Field.
  factory EvrLongBytes.empty(int code, int vfLength, int vrCode,
      [Endian endian]) {
    //assert(vfLength.isEven);
    final e = EvrLongBytes(kHeaderLength + vfLength, endian)
      ..evrSetLongHeader(code, vfLength, vrCode);
    return e;
  }

  /// Creates an [EvrLongBytes].
  factory EvrLongBytes.fromBytes(int code, Bytes vfBytes, int vrCode,
      [Endian endian]) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    final e = EvrLongBytes(kHeaderLength + vfLength, endian)
      ..evrSetLongHeader(code, vfLength, vrCode)
      ..setByteData(kVFOffset, vfBytes.bd);
    return e;
  }

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

  /// Returns a _view_ of _this_ containing the bytes from [start] inclusive
  /// to [end] exclusive. If [end] is omitted, the [length] of _this_ is used.
  /// An error occurs if [start] is outside the range 0 .. [length],
  /// or if [end] is outside the range [start] .. [length].
  @override
  EvrLongBytes sublist([int start = 0, int end]) =>
      EvrLongBytes.from(this, start, (end ?? length) - start, endian);

  static const int kVFLengthOffset = 8;
  static const int kVFOffset = 12;
  static const int kHeaderLength = kVFOffset;
}
