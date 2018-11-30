//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/dicom_bytes/dicom_bytes_mixin.dart';
import 'package:core/src/vr.dart';

mixin EvrMixin {
  Map<int, VR> get vrByIndex;
  int getVRCode(int offset);
  int vrIndexFromCode(int vrCode);
  String vrIdFromIndex(int vrIndex);

  // **** End of Interface

  bool get isEvr => true;

  int get vrCode => getVRCode(kVROffset);

  int get vrIndex => vrIndexFromCode(vrCode);

  String get vrId => vrIdFromIndex(vrIndex);

  VR get vr => vrByIndex[vrIndex];

  int get kVROffset => 4;
}

mixin EvrShortMixin {
  int get vfLength;
  int getUint16(int vfLengthOffset);
  bool checkVFLengthField(int vlf, int vfLength);
  // **** End of Interface

  int get vfOffset => kVFOffset;

  int get vfLengthOffset => kVFLengthOffset;

  int get vfLengthField {
    final vlf = getUint16(kVFLengthOffset);
    assert(checkVFLengthField(vlf, vfLength));
    return vlf;
  }

  /// The offset of the Value Field Length field.
  static const int kVFLengthOffset = 6;

  /// The offset of the Value Field field.
  static const int kVFOffset = 8;

  /// The length of a short EVR header.
  static const int kHeaderLength = kVFOffset;
}

/// A class implementing short EVR little endian DicomBytes.
class EvrShortLE extends BytesLE with DicomBytesMixin, EvrMixin, EvrShortMixin {
  /// Creates an empty short EVR little endian DicomBytes with [length].
  EvrShortLE(int length) : super(length);

  /// Creates a short EVR little endian DicomBytes from [bytes].
  EvrShortLE.from(Bytes bytes, [int start = 0, int end])
      : super.from(bytes, start, end);

  /// Creates a short EVR little endian DicomBytes view of [bytes].
  EvrShortLE.view(Bytes bytes, [int start = 0, int end])
      : super.view(bytes, start, end);

  /// Creates a short EVR little endian DicomBytes with a Value Field
  /// containing all zeros.
  factory EvrShortLE.empty(int code, int vfLength, int vrCode) {
    final e = EvrShortLE(
      EvrShortMixin.kHeaderLength + vfLength,
    )..evrSetShortHeader(code, vfLength, vrCode);
    return e;
  }

  /// Returns a new short EVR DicomBytes.
  factory EvrShortLE.fromBytes(int code, Bytes vfBytes, int vrCode) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    final e = EvrShortLE(
      EvrShortMixin.kHeaderLength + vfLength,
    )
      ..evrSetShortHeader(code, vfLength, vrCode)
      ..setByteData(EvrShortMixin.kVFOffset, vfBytes.bd);
    return e;
  }

  /// Returns a _view_ of _this_ containing the bytes from [start] inclusive
  /// to [end] exclusive. If [end] is omitted, the [length] of _this_ is used.
  /// An error occurs if [start] is outside the range 0 .. [length],
  /// or if [end] is outside the range [start] .. [length].
  @override
  EvrShortLE sublist([int start = 0, int end]) =>
      EvrShortLE.from(this, start, (end ?? length) - start);
}

/// A class implementing short EVR big endian DicomBytes.
class EvrShortBE extends BytesLE with DicomBytesMixin, EvrMixin, EvrShortMixin {
  /// Creates an empty short EVR big endian DicomBytes with [length].
  EvrShortBE(int length) : super(length);

  /// Creates a short EVR big endian DicomBytes from [bytes].
  EvrShortBE.from(Bytes bytes, [int start = 0, int end])
      : super.from(bytes, start, end);

  /// Creates a short EVR big endian DicomBytes view of [bytes].
  EvrShortBE.view(Bytes bytes, [int start = 0, int end])
      : super.view(bytes, start, end);

  /// Creates a short EVR DicomBytes with an empty (all zeros) Value Field.
  factory EvrShortBE.empty(int code, int vfLength, int vrCode) {
    final e = EvrShortBE(
      EvrShortMixin.kHeaderLength + vfLength,
    )..evrSetShortHeader(code, vfLength, vrCode);
    return e;
  }

  /// Creates a short EVR DicomBytes.
  factory EvrShortBE.fromBytes(int code, Bytes vfBytes, int vrCode) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    final e = EvrShortBE(
      EvrShortMixin.kHeaderLength + vfLength,
    )
      ..evrSetShortHeader(code, vfLength, vrCode)
      ..setByteData(EvrShortMixin.kVFOffset, vfBytes.bd);
    return e;
  }

  /// Returns a _view_ of _this_ containing the bytes from [start] inclusive
  /// to [end] exclusive. If [end] is omitted, the [length] of _this_ is used.
  /// An error occurs if [start] is outside the range 0 .. [length],
  /// or if [end] is outside the range [start] .. [length].
  @override
  EvrShortBE sublist([int start = 0, int end]) =>
      EvrShortBE.from(this, start, (end ?? length) - start);
}

mixin EvrLongMixin {
  int get vfLength;
  int getUint32(int kVFLengthOffset);
  bool checkVFLengthField(int vlf, int vfLength);
  // **** End of Interface

  int get vfOffset => kVFOffset;

  int get vfLengthOffset => kVFLengthOffset;

  int get vfLengthField {
    final vlf = getUint32(kVFLengthOffset);
    assert(checkVFLengthField(vlf, vfLength));
    return vlf;
  }

  /// The offset of the Value Field Length field.
  static const int kVFLengthOffset = 8;

  /// The offset of the Value Field field.
  static const int kVFOffset = 12;

  /// The length of the long EVR header field.
  static const int kHeaderLength = kVFOffset;
}

/// A class implementing long EVR big endian DicomBytes.
class EvrLongBE extends BytesBE with DicomBytesMixin, EvrMixin, EvrLongMixin {
  /// Creates a long EVR big endian DicomBytes of [length] containing all zeros.
  EvrLongBE(int length) : super(length);

  /// Creates a long EVR big endian DicomBytes.
  EvrLongBE.from(Bytes bytes, [int start = 0, int end])
      : super.from(bytes, start, end);

  /// Creates a long EVR big endian DicomBytes view of [bytes].
  EvrLongBE.view(Bytes bytes, [int start = 0, int end])
      : super.view(bytes, start, end);

  /// Creates a long EVR big endian DicomBytes with an empty Value Field.
  factory EvrLongBE.empty(int code, int vfLength, int vrCode) {
    //assert(vfLength.isEven);
    final e = EvrLongBE(EvrLongMixin.kHeaderLength + vfLength)
      ..evrSetLongHeader(code, vfLength, vrCode);
    return e;
  }

  /// Creates a long EVR big endian DicomBytes.
  factory EvrLongBE.fromBytes(int code, Bytes vfBytes, int vrCode) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    final e = EvrLongBE(EvrLongMixin.kHeaderLength + vfLength)
      ..evrSetLongHeader(code, vfLength, vrCode)
      ..setByteData(EvrLongMixin.kVFOffset, vfBytes.bd);
    return e;
  }

  /// Returns a _view_ of _this_ containing the bytes from [start] inclusive
  /// to [end] exclusive. If [end] is omitted, the [length] of _this_ is used.
  /// An error occurs if [start] is outside the range 0 .. [length],
  /// or if [end] is outside the range [start] .. [length].
  @override
  EvrLongBE sublist([int start = 0, int end]) =>
      EvrLongBE.from(this, start, (end ?? length) - start);
}
