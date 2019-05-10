//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/dicom_bytes/dicom_bytes.dart';
import 'package:core/src/error.dart';
import 'package:core/src/vr/vr_base.dart';

/// Explicit Little Endian [Bytes].
abstract class EvrBytes extends DicomBytes {
  EvrBytes._(int eLength, Endian endian) : super(eLength, endian);

  /// Creates an [EvrBytes] from [bytes].
  factory EvrBytes.from(Bytes bytes, int start, int vrIndex, int end) {
    if (isEvrShortVRIndex(vrIndex)) {
      return EvrShortBytes.from(bytes, start, end);
    } else if (isEvrLongVR(vrIndex)) {
      return EvrLongBytes.from(bytes, start, end);
    } else {
      return badVRIndex(vrIndex, null, null, null);
    }
  }

  EvrBytes._from(Bytes bytes, int start, int end, Endian endian)
      : super.from(bytes, start, end, endian ?? Endian.little);

  /// Creates an [EvrBytes] from a view of [bytes].
  factory EvrBytes.view(
      Bytes bytes, int start, int vrIndex, int end, Endian endian) {
    if (isEvrShortVRIndex(vrIndex)) {
      return EvrShortBytes.view(bytes, start, end, endian);
    } else if (isEvrLongVR(vrIndex)) {
      return EvrLongBytes.view(bytes, start, end, endian);
    } else {
      return badVRIndex(vrIndex, null, null, null);
    }
  }

  EvrBytes._view(Bytes bytes, int offset, int length, Endian endian)
      : super.internalView(bytes, offset, length, endian);

  @override
  bool get isEvr => true;
  @override
  int get vrCode => getVRCode(kVROffset);
  @override
  int get vrIndex => vrIndexFromCode(vrCode);
  @override
  String get vrId => vrIdFromIndex(vrIndex);

  /// The offset to the Value Field.
  static const int kVROffset = 4;
}

/// Explicit Little Endian Element with short (16-bit) Value Field Length.
class EvrShortBytes extends EvrBytes {
  /// Returns an [EvrShortBytes].
  EvrShortBytes(int eLength, [Endian endian = Endian.little])
      : super._(eLength, endian);

  /// Returns an [EvrShortBytes] created from [bytes].
  EvrShortBytes.from(Bytes bytes,
      [int start = 0, int end, Endian endian = Endian.little])
      : super._from(bytes, start, end, endian);

  /// Returns an [EvrShortBytes] created from a view of [bytes].
  EvrShortBytes.view(Bytes bytes,
      [int start = 0, int end, Endian endian = Endian.little])
      : super._view(bytes, start, end, endian);

  /// Returns an [EvrShortBytes] with an empty Value Field.
  factory EvrShortBytes.empty(int code, int vfLength, int vrCode,
      [Endian endian = Endian.little]) {
    final e = EvrShortBytes(kHeaderLength + vfLength, endian)
      ..evrSetShortHeader(code, vfLength, vrCode);
    return e;
  }

  /// Returns an [EvrShortBytes] created from a view
  /// of a Value Field ([vfBytes]).
  factory EvrShortBytes.fromVFBytes(int code, Bytes vfBytes, int vrCode,
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
    assert(checkVFLengthField(vlf, vfLength));
    return vlf;
  }

/* flush when working
  int get vfLength => buf.length;
*/

  /// Returns a _view_ of _this_ containing the bytes from [start] inclusive
  /// to [end] exclusive. If [end] is omitted, the [length] of _this_ is used.
  /// An error occurs if [start] is outside the range 0 .. [length],
  /// or if [end] is outside the range [start] .. [length].
  @override
  EvrShortBytes sublist([int start = 0, int end]) =>
      EvrShortBytes.from(this, start, (end ?? length) - start, endian);

  /// The Value Field Length field offset.
  static const int kVFLengthOffset = 6;

  /// The Value Field offset.
  static const int kVFOffset = 8;

  /// The header length of an [EvrShortBytes].
  static const int kHeaderLength = kVFOffset;
}

/// Explicit Little Endian [Bytes] with long (32-bit) Value Field Length.
class EvrLongBytes extends EvrBytes {
  /// Creates an [EvrLongBytes] of [length].
  EvrLongBytes(int length, [Endian endian = Endian.little])
      : super._(length, endian);

  /// Creates an [EvrLongBytes] from [Bytes].
  EvrLongBytes.from(Bytes bytes,
      [int start = 0, int end, Endian endian = Endian.little])
      : super._from(bytes, start, end, endian);

  /// Creates an [EvrLongBytes] from a view of [Bytes].
  EvrLongBytes.view(Bytes bytes,
      [int start = 0, int end, Endian endian = Endian.little])
      : super._view(bytes, start, end, endian);

  /// Returns an [EvrLongBytes] with an empty Value Field.
  factory EvrLongBytes.empty(int code, int vfLength, int vrCode,
      [Endian endian = Endian.little]) {
    final e = EvrLongBytes(kHeaderLength + vfLength, endian)
      ..evrSetLongHeader(code, vfLength, vrCode);
    return e;
  }

  /// Creates an [EvrLongBytes].
  factory EvrLongBytes.fromVFBytes(int code, Bytes vfBytes, int vrCode,
      [Endian endian = Endian.little]) {
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
    assert(checkVFLengthField(vlf, vfLength));
    return vlf;
  }

/* flush when working
  int get vfLength {
    return (vfLengthField == kUndefinedLength) ? buf.length - 8 : buf.length;
  }
*/

  /// Returns a _view_ of _this_ containing the bytes from [start] inclusive
  /// to [end] exclusive. If [end] is omitted, the [length] of _this_ is used.
  /// An error occurs if [start] is outside the range 0 .. [length],
  /// or if [end] is outside the range [start] .. [length].
  @override
  EvrLongBytes sublist([int start = 0, int end]) =>
      EvrLongBytes.from(this, start, (end ?? length) - start, endian);

  /// The offset to the Value Field Length field.
  static const int kVFLengthOffset = 8;

  /// The offset to the Value Field.
  static const int kVFOffset = 12;

  /// The header length of an [EvrLongBytes].
  static const int kHeaderLength = kVFOffset;
}
