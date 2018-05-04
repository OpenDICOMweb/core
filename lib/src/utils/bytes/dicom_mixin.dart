//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.utils.bytes;

abstract class DicomMixin {
  ByteData get _bd;
  ByteData get bd;
//  set bd(ByteData bd);
  Endian get endian;
  int get _bdOffset;
  int get _bdLength;
  int get vfOffset;
  int get vfLengthOffset;
  int get vfLengthField;
  int _getUint8(int offset);
  int _getUint16(int offset);
  int _getUint32(int offset);

  int _setUint8(int offset, int value);
  int _setUint16(int offset, int value);
  int _setUint32(int offset, int value);
  int getVLF(int offset);
  Bytes asBytes([int offset = 0, int length, Endian endian]);

  // **** End of Interface

  int get code {
    final group = _getUint16(0);
    final elt = _getUint16(2);
    return (group << 16) + elt;
  }

  /// The Element Group Field
  int get group => _getUint16(_kGroupOffset);

  /// The Element _element_ Field.
  int get elt => _getUint16(_kEltOffset);

  /// Returns the length in bytes of _this_ Element.
  int get eLength => _bdLength;

  /// Returns _true_ if [vfLengthField] equals [kUndefinedLength].
  bool get hasUndefinedLength => vfLengthField == kUndefinedLength;

  /// Returns the actual length of the Value Field.
  int get vfLength => _bdLength - vfOffset;

  /// Returns the Value Field bytes.
  Bytes get vfBytes => asBytes(vfOffset, vfLength);

  /// Returns the Value Field bytes _without_ padding.
  Bytes get vfBytesWOPadding => asBytes(vfOffset, _vflWOPadding(vfOffset));

  /// Returns the Value Field as a Uint8List.
  Uint8List get vfUint8List =>
      _bd.buffer.asUint8List(_bdOffset + vfOffset, vfLength);

  /// Returns the Value Field as a Uint8List _without_ padding.
  Uint8List get vfUint8ListWOPadding =>
      _bd.buffer.asUint8List(_bdOffset + vfOffset, _vflWOPadding(vfOffset));

  // ** Primitive Getters

  int getCode(int offset) {
    final group = _getUint16(offset);
    final elt = _getUint16(offset + 2);
    return (group << 16) + elt;
  }

  int getVRCode(int offset) => _getUint16(offset);

  int getShortVLF(int offset) => _getUint16(offset);

  int getLongVLF(int offset) => _getUint32(offset);

  // **** Primitive Setters

  /// Returns the Tag Code from [Bytes].
  void setCode(int code) {
    _setUint16(0, code >> 16);
    _setUint16(2, code & 0xFFFF);
  }

  void setVRCode(int vrCode) => _setUint16(4, vrCode);
  void setShortVLF(int vlf) => _setUint16(6, vlf);
  void setLongVLF(int vlf) => _setUint32(8, vlf);

  /// Write a short EVR header.
  void evrSetShortHeader(int code, int vrCode, int vlf) {
    _setUint16(0, code >> 16);
    _setUint16(2, code & 0xFFFF);
    _setUint16(4, vrCode);
    _setUint16(6, vlf);
  }

  /// Write a short EVR header.
  void evrSetLongHeader(int code, int vrCode, int vlf) {
    _setUint16(0, code >> 16);
    _setUint16(2, code & 0xFFFF);
    _setUint16(4, vrCode);
// This field is zero, but GC takes care of  that
//    _setUint16( 6, 0)
    _setUint32(8, vlf);
  }

  /// Write a short EVR header.
  void ivrSetHeader(int offset, int code, int vlf) {
    _setUint16(offset, code >> 16);
    _setUint16(2, code & 0xFFFF);
    _setUint32(4, vlf);
  }

  /// Returns the length in bytes of this Byte Element without padding.
  int _vflWOPadding(int vfOffset) {
    final length = bd.lengthInBytes - vfOffset;
    if (length == 0 || length.isOdd) return length;
    final newLen = length - 1;
    final last = _getUint8(newLen);
    return (last == kSpace || last == kNull) ? newLen : length;
  }

  @override
  String toString() =>
      '$runtimeType ${dcm(code)} vlf: $vfLengthField vfl: $vfLength $vfBytes)';

  static const int _kGroupOffset = 0;
  static const int _kEltOffset = 0;
}

abstract class DicomReaderMixin {
  int get _bdOffset;
  int get _bdLength;
  int get vfOffset;
  int get vfLengthOffset;
  int get vfLengthField;
  int _getUint8(int offset);
  int _getUint16(int offset);
  int _getUint32(int offset);
  int getVLF(int offset);
  Bytes asBytes([int offset = 0, int length, Endian endian]);
  Uint8List asUint8List([int offset = 0, int length]);

  // **** End of Interface

  int get code {
    final group = _getUint16(0);
    final elt = _getUint16(2);
    return (group << 16) + elt;
  }

  /// The Element Group Field
  int get group => _getUint16(_kGroupOffset);

  /// The Element _element_ Field.
  int get elt => _getUint16(_kEltOffset);

  /// Returns the length in bytes of _this_ Element.
  int get eLength => _bdLength;

  /// Returns _true_ if [vfLengthField] equals [kUndefinedLength].
  bool get hasUndefinedLength => vfLengthField == kUndefinedLength;

  /// Returns the actual length of the Value Field.
  int get vfLength => _bdLength - vfOffset;

  /// Returns the Value Field bytes.
  Bytes get vfBytes => asBytes(vfOffset, vfLength);

  /// Returns the Value Field bytes _without_ padding.
  Bytes get vfBytesWOPadding => asBytes(vfOffset, _vflWOPadding(vfOffset));

  /// Returns the Value Field as a Uint8List.
  Uint8List get vfUint8List =>
      asUint8List(_bdOffset + vfOffset, vfLength);

  /// Returns the Value Field as a Uint8List _without_ padding.
  Uint8List get vfUint8ListWOPadding =>
      asUint8List(_bdOffset + vfOffset, _vflWOPadding(vfOffset));

  // ** Primitive Getters

  int getCode(int offset) {
    final group = _getUint16(offset);
    final elt = _getUint16(offset + 2);
    return (group << 16) + elt;
  }

  int getVRCode(int offset) => _getUint16(offset);

  int getShortVLF(int offset) => _getUint16(offset);

  int getLongVLF(int offset) => _getUint32(offset);

  /// Returns the length in bytes of this Byte Element without padding.
  int _vflWOPadding(int vfOffset) {
    final length = _bdLength - vfOffset;
    if (length == 0 || length.isOdd) return length;
    final newLen = length - 1;
    final last = _getUint8(newLen);
    return (last == kSpace || last == kNull) ? newLen : length;
  }

  @override
  String toString() =>
      '$runtimeType ${dcm(code)} vlf: $vfLengthField vfl: $vfLength $vfBytes)';

  static const int _kGroupOffset = 0;
  static const int _kEltOffset = 0;
}

abstract class DicomWriterMixin {
  int _setUint16(int offset, int value);
  int _setUint32(int offset, int value);
// **** End of Interface

  /// Returns the Tag Code from [Bytes].
  void setCode(int code) {
    _setUint16(0, code >> 16);
    _setUint16(2, code & 0xFFFF);
  }

  void setVRCode(int vrCode) => _setUint16(4, vrCode);
  void setShortVLF(int vlf) => _setUint16(6, vlf);
  void setLongVLF(int vlf) => _setUint32(8, vlf);

  /// Write a short EVR header.
  void evrSetShortHeader(int code, int vrCode, int vlf) {
    _setUint16(0, code >> 16);
    _setUint16(2, code & 0xFFFF);
    _setUint16(4, vrCode);
    _setUint16(6, vlf);
  }

  /// Write a short EVR header.
  void evrSetLongHeader(int code, int vrCode, int vlf) {
    _setUint16(0, code >> 16);
    _setUint16(2, code & 0xFFFF);
    _setUint16(4, vrCode);
// This field is zero, but GC takes care of  that
//    _setUint16( 6, 0)
    _setUint32(8, vlf);
  }

  /// Write a short EVR header.
  void ivrSetHeader(int offset, int code, int vlf) {
    _setUint16(offset, code >> 16);
    _setUint16(2, code & 0xFFFF);
    _setUint32(4, vlf);
  }
}
