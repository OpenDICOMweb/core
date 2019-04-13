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

/// Implicit Little Endian [Bytes] with short (16-bit) Value Field Length.
class IvrBytes extends DicomBytes {
  /// Creates an [IvrBytes] Element of length.
  IvrBytes(int length) : super(length, Endian.little);

  /// Create an [IvrBytes] Element from [Bytes].
  IvrBytes.from(Bytes bytes, int start, int end)
      : super.from(bytes, start, end, Endian.little);

  /// Create an [IvrBytes] Element from a view of [Bytes].
  IvrBytes.view(Bytes bytes,
      [int start = 0, int end, Endian endian = Endian.little])
      : super.internalView(bytes, start, end, endian);

  /// Returns an [IvrBytes] with an empty Value Field.
  factory IvrBytes.empty(
    int code,
    int vfLength,
    int vrCode,
  ) {
    assert(vfLength.isEven);
    return IvrBytes(kHeaderLength + vfLength)
      ..ivrSetHeader(code, vfLength, vrCode);
  }

  /// Creates an [IvrBytes].
  factory IvrBytes.makeFromBytes(
    int code,
    Bytes vfBytes,
    int vrCode,
  ) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    return IvrBytes(kHeaderLength + vfLength)
      ..ivrSetHeader(code, vfLength, vrCode)
      ..setByteData(kVFOffset, vfBytes.bd);
  }

  @override
  bool get isEvr => false;
  @override
  int get vrCode => kUNCode;
  @override
  int get vrIndex => kUNIndex;
  @override
  String get vrId => vrIdFromIndex(vrIndex);
  @override
  int get vfOffset => kVFOffset;
  @override
  int get vfLengthOffset => kVFLengthOffset;

  @override
  int get vfLengthField {
    final vlf = getUint32(kVFLengthOffset);
    assert(checkVFLengthField(vlf, vfLength));
    return vlf;
  }

  /// Returns a _view_ of _this_ containing the bytes from [start] inclusive
  /// to [end] exclusive. If [end] is omitted, the [length] of _this_ is used.
  /// An error occurs if [start] is outside the range 0 .. [length],
  /// or if [end] is outside the range [start] .. [length].
  @override
  IvrBytes sublist([int start = 0, int end]) =>
      IvrBytes.from(this, start, (end ?? length) - start);

  /// The offset of the Value Field Length in an IVR Element.
  static const int kVFLengthOffset = 4;

  /// The offset of the Value Field in an IVR Element
  static const int kVFOffset = 8;

  /// The length of an IVR Element Header.
  static const int kHeaderLength = 8;
}
