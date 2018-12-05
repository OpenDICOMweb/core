//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/dicom_bytes/dicom_bytes.dart';
import 'package:core/src/vr/vr_base.dart';

mixin EvrMixin {
  int getVRCode(int offset);
  // **** End of Interface

  bool get isEvr => true;

  int get vrCode => getVRCode(kVROffset);

  int get vrIndex => vrIndexFromCode(vrCode);

  String get vrId => vrIdFromIndex(vrIndex);

  int get kVROffset => 4;
}

mixin EvrShortMixin {
  int get vfLength;
  int getUint16(int offset);
  void setUint16(int offset, int length);
  bool checkVFLengthField(int vlf, int vfLength);
  // **** End of Interface

  int get vfOffset => kVFOffset;

  int get vfLengthOffset => kVFLengthOffset;

  int get vfLengthField {
    final vlf = getUint16(kVFLengthOffset);
    assert(checkVFLengthField(vlf, vfLength));
    return vlf;
  }

  set vfLengthField(int length) => setUint16(kVFLengthOffset, length);

  /// The offset of the Value Field Length field.
  static const int kVFLengthOffset = 6;

  /// The offset of the Value Field field.
  static const int kVFOffset = 8;

  /// The length of a short EVR header.
  static const int kHeaderLength = kVFOffset;
}

/// A class implementing short EVR big endian DicomBytes.
class EvrShortBytesBE extends DicomBytes
    with BigEndianMixin, EvrMixin, EvrShortMixin {
  /// Creates an empty short EVR big endian DicomBytes with [length].
  EvrShortBytesBE(int vfLength)
      : super(ByteData(EvrShortMixin.kHeaderLength + vfLength));

  /// Creates a short EVR big endian DicomBytes from [bytes].
  EvrShortBytesBE.from(Bytes bytes, [int start = 0, int end])
      : super(Bytes.copyByteData(bytes, start, end));

  /// Creates a short EVR big endian DicomBytes view of [bytes].
  EvrShortBytesBE.view(Bytes bytes, [int start = 0, int end])
      : super(Bytes.viewByteData(bytes, start, end));

  /// Creates a short EVR DicomBytes with an empty (all zeros) Value Field.
  factory EvrShortBytesBE.empty(int code, int vfLength, int vrCode) {
    final e = EvrShortBytesBE(
      EvrShortMixin.kHeaderLength + vfLength,
    )..evrSetShortHeader(code, vfLength, vrCode);
    return e;
  }

  /// Creates a short EVR DicomBytes.
  factory EvrShortBytesBE.fromBytes(int code, Bytes vfBytes, int vrCode) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    final e = EvrShortBytesBE(
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
  EvrShortBytesBE sublist([int start = 0, int end]) =>
      EvrShortBytesBE.from(this, start, (end ?? length) - start);
}

/// A class implementing short EVR little endian DicomBytes.
class EvrShortBytesLE extends DicomBytes
    with LittleEndianMixin, EvrMixin, EvrShortMixin {
  /// Creates an empty short EVR little endian DicomBytes with [length].
  EvrShortBytesLE(int vfLength)
      : super(ByteData(EvrShortMixin.kHeaderLength + vfLength));

  /// Creates a short EVR little endian DicomBytes from [bytes].
  EvrShortBytesLE.from(Bytes bytes, [int start = 0, int end])
      : super(Bytes.copyByteData(bytes, start, end));

  /// Creates a short EVR little endian DicomBytes view of [bytes].
  EvrShortBytesLE.view(Bytes bytes, [int start = 0, int end])
      : super(Bytes.viewByteData(bytes, start, end));

  /// Creates a short EVR little endian DicomBytes with a Value Field
  /// containing all zeros.
  factory EvrShortBytesLE.empty(int code, int vfLength, int vrCode) {
    final e = EvrShortBytesLE(
      EvrShortMixin.kHeaderLength + vfLength,
    )..evrSetShortHeader(code, vfLength, vrCode);
    return e;
  }

  /// Returns a new short EVR DicomBytes.
  factory EvrShortBytesLE.fromBytes(int code, Bytes vfBytes, int vrCode) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    final e = EvrShortBytesLE(
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
  EvrShortBytesLE sublist([int start = 0, int end]) =>
      EvrShortBytesLE.from(this, start, (end ?? length) - start);
}

mixin EvrLongMixin {
  int get vfLength;
  int getUint32(int offset);
  void setUint32(int offset, int length);
  bool checkVFLengthField(int vlf, int vfLength);
  // **** End of Interface

  int get vfOffset => kVFOffset;

  int get vfLengthOffset => kVFLengthOffset;

  int get vfLengthField {
    final vlf = getUint32(kVFLengthOffset);
    assert(checkVFLengthField(vlf, vfLength));
    return vlf;
  }

  set vfLengthField(int length) => setUint32(kVFLengthOffset, length);

  /// The offset of the Value Field Length field.
  static const int kVFLengthOffset = 8;

  /// The offset of the Value Field field.
  static const int kVFOffset = 12;

  /// The length of the long EVR header field.
  static const int kHeaderLength = kVFOffset;
}

/// A class implementing long EVR big endian DicomBytes.
class EvrLongBytesBE extends DicomBytes
    with BigEndianMixin, EvrMixin, EvrLongMixin
    implements Comparable<Bytes> {
  /// Creates a long EVR big endian DicomBytes of [length] containing all zeros.
  EvrLongBytesBE(int vfLength)
      : super(ByteData(EvrLongMixin.kHeaderLength + vfLength));

  /// Creates a long EVR big endian DicomBytes.
  EvrLongBytesBE.from(Bytes bytes, [int start = 0, int end])
      : super(Bytes.copyByteData(bytes, start, end));

  /// Creates a long EVR big endian DicomBytes view of [bytes].
  EvrLongBytesBE.view(Bytes bytes, [int start = 0, int end])
      : super(Bytes.viewByteData(bytes, start, end));

  /// Creates a long EVR big endian DicomBytes with an empty Value Field.
  factory EvrLongBytesBE.empty(int code, int vfLength, int vrCode) {
    //assert(vfLength.isEven);
    final e = EvrLongBytesBE(EvrLongMixin.kHeaderLength + vfLength)
      ..evrSetLongHeader(code, vfLength, vrCode);
    return e;
  }

  /// Creates a long EVR big endian DicomBytes.
  factory EvrLongBytesBE.fromBytes(int code, Bytes vfBytes, int vrCode) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    final e = EvrLongBytesBE(EvrLongMixin.kHeaderLength + vfLength)
      ..evrSetLongHeader(code, vfLength, vrCode)
      ..setByteData(EvrLongMixin.kVFOffset, vfBytes.bd);
    return e;
  }

  /// Returns a _view_ of _this_ containing the bytes from [start] inclusive
  /// to [end] exclusive. If [end] is omitted, the [length] of _this_ is used.
  /// An error occurs if [start] is outside the range 0 .. [length],
  /// or if [end] is outside the range [start] .. [length].
  @override
  EvrLongBytesBE sublist([int start = 0, int end]) =>
      EvrLongBytesBE.from(this, start, (end ?? length) - start);
}

/// A class implementing long EVR big endian DicomBytes.
class EvrLongBytesLE extends DicomBytes
    with LittleEndianMixin, EvrMixin, EvrLongMixin {
  /// Creates a long EVR big endian DicomBytes of [length] containing all zeros.
  EvrLongBytesLE(int vfLength)
      : super(ByteData(EvrLongMixin.kHeaderLength + vfLength));

  /// Creates a long EVR big endian DicomBytes.
  EvrLongBytesLE.from(Bytes bytes, [int start = 0, int end])
      : super(Bytes.copyByteData(bytes, start, end));

  /// Creates a long EVR big endian DicomBytes view of [bytes].
  EvrLongBytesLE.view(Bytes bytes, [int start = 0, int end])
      : super(Bytes.viewByteData(bytes, start, end));

  /// Creates a long EVR big endian DicomBytes with an empty Value Field.
  factory EvrLongBytesLE.empty(int code, int vfLength, int vrCode) {
    //assert(vfLength.isEven);
    final e = EvrLongBytesLE(EvrLongMixin.kHeaderLength + vfLength)
      ..evrSetLongHeader(code, vfLength, vrCode);
    return e;
  }

  /// Creates a long EVR big endian DicomBytes.
  factory EvrLongBytesLE.fromBytes(int code, Bytes vfBytes, int vrCode) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    final e = EvrLongBytesLE(EvrLongMixin.kHeaderLength + vfLength)
      ..evrSetLongHeader(code, vfLength, vrCode)
      ..setByteData(EvrLongMixin.kVFOffset, vfBytes.bd);
    return e;
  }

  /// Returns a _view_ of _this_ containing the bytes from [start] inclusive
  /// to [end] exclusive. If [end] is omitted, the [length] of _this_ is used.
  /// An error occurs if [start] is outside the range 0 .. [length],
  /// or if [end] is outside the range [start] .. [length].
  @override
  EvrLongBytesLE sublist([int start = 0, int end]) =>
      EvrLongBytesLE.from(this, start, (end ?? length) - start);
}
