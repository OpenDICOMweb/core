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

mixin IvrMixin {
  int get vfLength;
  int getUint32(int offset);
  bool _checkVFLengthField(int vlf, int vfLength);
  // **** End of Interface

  // int get kHeaderLength => kVFOffset;
  bool get isEvr => false;

  int get vrCode => kUNCode;

  int get vrIndex => kUNIndex;

  String get vrId => vrIdFromIndex(vrIndex);

  VR get vr => VR.kUN;

  int get vfOffset => kVFOffset;

  int get vfLengthOffset => kVFLengthOffset;

  int get vfLengthField {
    final vlf = getUint32(kVFLengthOffset);
    assert(_checkVFLengthField(vlf, vfLength));
    return vlf;
  }

  static const int kVFLengthOffset = 4;
  static const int kVFOffset = 8;
  static const int kHeaderLength = 8;
}


class IvrBytesLE extends BytesLE with DicomBytesMixin, IvrMixin {
  IvrBytesLE(int eLength) : super(eLength);

  IvrBytesLE.from(Bytes bytes, int start, int end)
      : super.from(bytes, start, end);

  IvrBytesLE.view(Bytes bytes, [int start = 0, int end])
      : super.view(bytes, start, end);

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
  BytesLE sublist([int start = 0, int end]) =>
      IvrBytesLE.from(this, start, (end ?? length) - start);
}

class IvrBytesBE extends BytesLE with DicomBytesMixin, IvrMixin {
  IvrBytesBE(int eLength) : super(eLength);

  IvrBytesBE.from(Bytes bytes, int start, int end)
      : super.from(bytes, start, end);

  IvrBytesBE.view(Bytes bytes, [int start = 0, int end])
      : super.view(bytes, start, end);

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
  BytesLE sublist([int start = 0, int end]) =>
      IvrBytesBE.from(this, start, (end ?? length) - start);
}
