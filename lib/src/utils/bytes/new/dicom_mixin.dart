//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/base.dart';
import 'package:core/src/utils/bytes/new/bytes.dart';

abstract class DicomMixin {
  ByteData get _bd;
//  set bd(ByteData bd);
  int get vfOffset;
  int get vfLengthOffset;
  int get vfLengthField;
  int getVRCode(int offset);
  int getVLF(int offset);
  Bytes view([int offset = 0, int length, Endian endian]);

  // **** End of Interface

  int get code {
    final group = _bd.getUint16(0);
    final elt = _bd.getUint16(2);
    return (group << 16) + elt;
  }

  /// The Element Group Field
  int get group => _bd.getUint16(kGroupOffset);

  /// The Element _element_ Field.
  int get elt => _bd.getUint16(kEltOffset);

  /// Returns the length in bytes of _this_ Element.
  int get eLength => _bd.lengthInBytes;

  /// Returns _true_ if [vfLengthField] equals [kUndefinedLength].
  bool get hasUndefinedLength => vfLengthField == kUndefinedLength;

  /// Returns the actual length of the Value Field.
  int get vfLength => _bd.lengthInBytes - vfOffset;

  /// Returns the Value Field bytes.
  Bytes get vfBytes => view(vfOffset, vfLengthField);

  /// Returns the Value Field bytes _without_ padding.
  Bytes get vfBytesWOPadding => view(vfOffset, _vflWOPadding(vfOffset));

  /// Returns the Value Field as a Uint8List.
  Uint8List get vfUint8List =>
      _bd.buffer.asUint8List(_bd.offsetInBytes + vfOffset, vfLength);

  /// Returns the Value Field as a Uint8List _without_ padding.
  Uint8List get vfUint8ListWOPadding => _bd.buffer
      .asUint8List(_bd.offsetInBytes + vfOffset, _vflWOPadding(vfOffset));

  // ** Primitive Getters

  int getCode(int offset) {
    final group = _bd.getUint16(offset);
    final elt = _bd.getUint16(offset + 2);
    return (group << 16) + elt;
  }

  int getShortVLF(int offset) => _bd.getUint16(offset);
  int getLongVLF(int offset) => _bd.getUint32(offset);

  // **** Primitive Setters

  /// Returns the Tag Code from [Bytes].
  void setCode(int code) {
    _bd..setUint16(0, code >> 16)..setUint16(2, code & 0xFFFF);
  }

  void setVRCode(int vrCode) => _bd.setUint16(4, vrCode);
  void setShortVLF(int vlf) => _bd.setUint16(6, vlf);
  void setLongVLF(int vlf) => _bd.setUint32(8, vlf);

  /// Write a short EVR header.
  void evrSetShortHeader(int code, int vrCode, int vlf) {
    _bd
      ..setUint16(0, code >> 16)
      ..setUint16(2, code & 0xFFFF)
      ..setUint16(4, vrCode)
      ..setUint16(6, vlf);
  }

  /// Write a short EVR header.
  void evrSetLongHeader(int code, int vrCode, int vlf) {
    _bd
      ..setUint16(0, code >> 16)
      ..setUint16(2, code & 0xFFFF)
      ..setUint16(4, vrCode)
// This field is zero, but GC takes care of  that
//    _setUint16( 6, 0)
      ..setUint32(8, vlf);
  }

  /// Write a short EVR header.
  void ivrSetHeader(int offset, int code, int vlf) {
    _bd
      ..setUint16(offset, code >> 16)
      ..setUint16(2, code & 0xFFFF)
      ..setUint32(4, vlf);
  }

  /// Returns the length in bytes of this Byte Element without padding.
  int _vflWOPadding(int vfOffset) {
    final length = _bd.lengthInBytes - vfOffset;
    if (length == 0 || length.isOdd) return length;
    final newLen = length - 1;
    final last = _bd.getUint8(newLen);
    return (last == kSpace || last == kNull) ? newLen : length;
  }

  @override
  String toString() =>
      '$runtimeType ${dcm(code)} vlf: $vfLengthField vfl: $vfLength $vfBytes)';

  static const int kGroupOffset = 0;
  static const int kEltOffset = 0;
}

abstract class DicomWriteMixin {
  ByteData get _bd;
//  set bd(ByteData bd);
  Endian get endian;
  int get vfOffset;
  int get vfLengthOffset;
  int get vfLengthField;
  int getVRCode(int offset);
  int getShortVLF(int offset);
  int getLongVLF(int offset);
  Bytes view([int offset = 0, int length, Endian endian]);

// **** End of Interface

}


