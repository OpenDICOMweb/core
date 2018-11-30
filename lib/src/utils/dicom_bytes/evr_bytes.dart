//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/global.dart';
import 'package:core/src/system.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/dicom.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/utils/string.dart';
import 'package:core/src/vr.dart';
import 'package:core/src/utils/dicom_bytes/dicom_bytes_mixin.dart';

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
  bool _checkVFLengthField(int vlf, int vfLength);
  // **** End of Interface

  int get kVFLengthOffset => 6;
  int get kVFOffset => 8;
  int get kHeaderLength => kVFOffset;

  int get vfOffset => kVFOffset;

  int get vfLengthOffset => kVFLengthOffset;

  int get vfLengthField {
    final vlf = getUint16(kVFLengthOffset);
    assert(_checkVFLengthField(vlf, vfLength));
    return vlf;
  }
}

class EvrShortLE extends BytesLE
    with DicomBytesMixin, EvrMixin, EvrShortMixin {
  EvrShortLE(int eLength) : super(eLength);

  EvrShortLE.from(Bytes bytes, [int start = 0, int end])
      : super.from(bytes, start, end);

  EvrShortLE.view(Bytes bytes, [int start = 0, int end])
      : super.view(bytes, start, end);

  // Urgent: rename .empty
  factory EvrShortLE.makeEmpty(int code, int vfLength, int vrCode,
     ) {
    final e = EvrShortLE(kHeaderLength + vfLength, )
      ..evrSetShortHeader(code, vfLength, vrCode);
    return e;
  }

  factory EvrShortLE.makeFromBytes(int code, Bytes vfBytes, int vrCode) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    final e = EvrShortLE(kHeaderLength + vfLength, )
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
  EvrShortLE sublist([int start = 0, int end]) =>
      EvrShortLE.from(this, start, (end ?? length) - start);
}

class EvrShortBE extends BytesLE
    with DicomBytesMixin, EvrMixin, EvrShortMixin {
  EvrShortBE(int eLength) : super(eLength);

  EvrShortBE.from(Bytes bytes, [int start = 0, int end])
      : super.from(bytes, start, end);

  EvrShortBE.view(Bytes bytes, [int start = 0, int end])
      : super.view(bytes, start, end);

  // Urgent: rename .empty
  factory EvrShortBE.makeEmpty(int code, int vfLength, int vrCode,
      ) {
    final e = EvrShortBE(kHeaderLength + vfLength, )
      ..evrSetShortHeader(code, vfLength, vrCode);
    return e;
  }

  factory EvrShortBE.makeFromBytes(int code, Bytes vfBytes, int vrCode) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    final e = EvrShortBE(kHeaderLength + vfLength, )
      ..evrSetShortHeader(code, vfLength, vrCode)
      ..setByteData(kVFOffset, vfBytes.bd);
    return e;
  }

/*
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
*/

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
  bool _checkVFLengthField(int vlf, int vfLength);
  // **** End of Interface
  int get kVFLengthOffset => 8;
  int get kVFOffset => 12;
  int get kHeaderLength => kVFOffset;

  int get vfOffset => kVFOffset;

  int get vfLengthOffset => kVFLengthOffset;

  int get vfLengthField {
    final vlf = getUint32(kVFLengthOffset);
    assert(_checkVFLengthField(vlf, vfLength));
    return vlf;
  }
}

class EvrLongBE extends BytesBE with DicomBytesMixin, EvrMixin, EvrLongMixin  {
  EvrLongBE(int eLength) : super(eLength);

  EvrLongBE.from(Bytes bytes, [int start = 0, int end])
      : super.from(bytes, start, end);

  EvrLongBE.view(Bytes bytes, [int start = 0, int end])
      : super.view(bytes, start, end);

  // Urgent: rename .empty
  factory EvrLongBE.makeEmpty(int code, int vfLength, int vrCode,
      ) {
    //assert(vfLength.isEven);
    final e = EvrLongBE(kHeaderLength + vfLength)
      ..evrSetLongHeader(code, vfLength, vrCode);
    return e;
  }

  // Urgent: rename .fromBytes
  factory EvrLongBE.makeFromBytes(int code, Bytes vfBytes, int vrCode) {
    final vfLength = vfBytes.length;
    assert(vfLength.isEven);
    final e = EvrLongBE(kHeaderLength + vfLength)
      ..evrSetLongHeader(code, vfLength, vrCode)
      ..setByteData(kVFOffset, vfBytes.bd);
    return e;
  }
/*

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
*/

  /// Returns a _view_ of _this_ containing the bytes from [start] inclusive
  /// to [end] exclusive. If [end] is omitted, the [length] of _this_ is used.
  /// An error occurs if [start] is outside the range 0 .. [length],
  /// or if [end] is outside the range [start] .. [length].
  @override
  EvrLongBE sublist([int start = 0, int end]) =>
      EvrLongBE.from(this, start, (end ?? length) - start);
}
