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

mixin IvrMixin {
  int get vfLength;
  int getUint32(int offset);
  bool checkVFLengthField(int vlf, int vfLength);
  // **** End of Interface

  // int get kHeaderLength => kVFOffset;
  bool get isEvr => false;

  int get vrCode => kUNCode;

  int get vrIndex => kUNIndex;

  String get vrId => 'UN';

  int get vfOffset => kVFOffset;

  int get vfLengthOffset => kVFLengthOffset;

  int get vfLengthField {
    final vlf = getUint32(kVFLengthOffset);
    assert(checkVFLengthField(vlf, vfLength));
    return vlf;
  }

  /// The offset of the Value Field Length field.
  static const int kVFLengthOffset = 4;

  /// The offset of the Value Field field.
  static const int kVFOffset = 8;

  /// The length of IVR header field.
  static const int kHeaderLength = 8;
}

/// A class implementing IVR big endian DicomBytes.
class IvrBytesBE extends DicomBytes
    with BigEndianMixin, IvrMixin implements Comparable<Bytes> {
  /// Creates a IVR big Endian DicomBytes containing all zeros.
  IvrBytesBE(int vfLength) : super(ByteData(IvrMixin.kHeaderLength + vfLength));

  /// Creates a IVR big Endian DicomBytes from [bytes].
  IvrBytesBE.from(Bytes bytes, int start, int end)
      : super(Bytes.copyByteData(bytes, start, end));

  /// Creates a IVR big Endian DicomBytes view of [bytes].
  IvrBytesBE.view(Bytes bytes, [int start = 0, int end])
      : super(Bytes.viewByteData(bytes, start, end));

  /// Returns an [IvrBytesBE] with an empty Value Field.
  factory IvrBytesBE.empty(int code, int vfLength, int vrCode) {
    assert(vfLength.isEven);
    return IvrBytesBE(IvrMixin.kHeaderLength + vfLength)
      ..ivrSetHeader(code, vfLength, vrCode);
  }

  /// Creates an [IvrBytesBE].
  factory IvrBytesBE.makeFromBytes(int code, Bytes vfBytes, int vrCode) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    return IvrBytesBE(IvrMixin.kHeaderLength + vfLength)
      ..ivrSetHeader(code, vfLength, vrCode)
      ..setByteData(IvrMixin.kVFOffset, vfBytes.bd);
  }

  /// Returns a _view_ of _this_ containing the bytes from [start] inclusive
  /// to [end] exclusive. If [end] is omitted, the [length] of _this_ is used.
  /// An error occurs if [start] is outside the range 0 .. [length],
  /// or if [end] is outside the range [start] .. [length].
  @override
  Bytes sublist([int start = 0, int end]) =>
      IvrBytesBE.from(this, start, (end ?? length) - start);
}

/// A class implementing IVR little endian DicomBytes.
class IvrBytesLE extends  DicomBytes
    with LittleEndianMixin, IvrMixin implements Comparable<Bytes> {
  /// Creates a IVR little Endian DicomBytes containing all zeros.
  IvrBytesLE(int vfLength) : super(ByteData(IvrMixin.kHeaderLength + vfLength));

  /// Creates a IVR little Endian DicomBytes from [bytes].
  IvrBytesLE.from(Bytes bytes, int start, int end)
      : super(Bytes.copyByteData(bytes, start, end));

  /// Creates a IVR little Endian DicomBytes view of [bytes].
  IvrBytesLE.view(Bytes bytes, [int start = 0, int end])
      : super(Bytes.viewByteData(bytes, start, end));

  /// Returns an [IvrBytesLE] with an empty Value Field.
  factory IvrBytesLE.empty(int code, int vfLength, int vrCode) {
    assert(vfLength.isEven);
    return IvrBytesLE(IvrMixin.kHeaderLength + vfLength)
      ..ivrSetHeader(code, vfLength, vrCode);
  }

  /// Creates an [IvrBytesLE].
  factory IvrBytesLE.makeFromBytes(int code, Bytes vfBytes, int vrCode) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    return IvrBytesLE(IvrMixin.kHeaderLength + vfLength)
      ..ivrSetHeader(code, vfLength, vrCode)
      ..setByteData(IvrMixin.kVFOffset, vfBytes.bd);
  }

  /// Returns a _view_ of _this_ containing the bytes from [start] inclusive
  /// to [end] exclusive. If [end] is omitted, the [length] of _this_ is used.
  /// An error occurs if [start] is outside the range 0 .. [length],
  /// or if [end] is outside the range [start] .. [length].
  @override
  Bytes sublist([int start = 0, int end]) =>
      IvrBytesLE.from(this, start, (end ?? length) - start);
}
