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
import 'package:core/src/utils/character/ascii.dart';
import 'package:core/src/utils/dicom.dart';
import 'package:core/src/utils/primitives.dart';

// ignore_for_file: public_member_api_docs

abstract class DicomBytesMixin {
  bool get isEvr;
  ByteData get bd;
//  set bd(ByteData bd);
  int get vrCode;
  int get vrIndex;
  String get vrId;
  Endian get endian;
  int get bdOffset;
  int get bdLength;
  int get vfOffset;
  int get vfLengthOffset;
  int get vfLengthField;
  int get length;


  int getUint16(int offset);
  int getUint8(int offset);
  int getUint32(int offset);

  void setUint8(int offset, int value);
  void setUint16(int offset, int value);
  void setUint32(int offset, int value);

  /* Urgent Flush
  int _getInt8(int offset);
  int _getInt16(int offset);
  int _getInt32(int offset);
  int _getInt64(int offset);

  int _getUint64(int offset);

  double _getFloat32(int offset);
  double _getFloat64(int offset);

  int _setInt8(int offset, int value);
  int _setInt16(int offset, int value);
  int _setInt32(int offset, int value);
  int _setInt64(int offset, int value);

  int _setUint64(int offset, int value);

  int _setFloat32(int offset, double value);
  int _setFloat64(int offset, double value);
*/

  int setInt8List(int start, List<int> list, [int offset = 0, int length]);
  int setInt16List(int start, List<int> list, [int offset = 0, int length]);
  int setInt32List(int start, List<int> list, [int offset = 0, int length]);
  int setInt64List(int start, List<int> list, [int offset = 0, int length]);

  int setUint8List(int start, List<int> list, [int offset = 0, int length]);
  int setUint16List(int start, List<int> list, [int offset = 0, int length]);
  int setUint32List(int start, List<int> list, [int offset = 0, int length]);
  int setUint64List(int start, List<int> list, [int offset = 0, int length]);

  int setFloat32List(int start, List<double> list,
      [int offset = 0, int length]);
  int setFloat64List(int start, List<double> list,
      [int offset = 0, int length]);

  int setUtf8(int start, String s,
      [int offset = 0, int length, int padChar = kSpace]);

  int setAsciiList(int start, List<String> list,
      [int offset = 0, int length, String separator = '', int pad = kSpace]);

  String toBDDescriptor(ByteData bd);

//  String _maybeGetSubstring(String s, int offset, int length);

//  int _absIndex(int offset);

  Bytes asBytes([int offset = 0, int length, Endian endian]);

/* Urgent flush
  // Note: special internal interface for writing padChars
  int _setUint8List(int start, Uint8List list,
      [int offset = 0, int length, int padChar]);
*/

  // **** End of Interface

  int get code {
    final group = getUint16(0);
    final elt = getUint16(2);
    return (group << 16) + elt;
  }

  /// The Element Group Field
  int get group => getUint16(_kGroupOffset);

  /// The Element _element_ Field.
  int get elt => getUint16(_kEltOffset);

  /// Returns the length in bytes of _this_ Element.
  int get eLength => bdLength;

  /// Returns _true_ if [vfLengthField] equals [kUndefinedLength].
  bool get hasUndefinedLength => vfLengthField == kUndefinedLength;

  /// Returns the actual length of the Value Field.
  int get vfLength => bdLength - vfOffset;

  /// Returns the Value Field bytes.
  Bytes get vfBytes => asBytes(vfOffset, vfLength);

  /// Returns the Value Field bytes _without_ padding.
//  Bytes get vBytes => asBytes(vfOffset, _vflWOPadding(vfOffset));

  /// Returns the last Uint8 element in [vfBytes], if [vfBytes]
  /// is not empty; otherwise, returns _null_.
  int get vfBytesLast {
    final len = eLength;
    return (len == 0) ? null : getUint8(len - 1);
  }

  /// Returns the Value Field as a Uint8List.
  Uint8List get vfUint8List =>
      bd.buffer.asUint8List(bdOffset + vfOffset, vfLength);

  /// Returns the Value Field as a Uint8List _without_ padding.
//  Uint8List get vfUint8ListWOPadding =>
//      _bd.buffer.asUint8List(_bdOffset + vfOffset, _vflWOPadding(vfOffset));

  // ** Primitive Getters

  int getCode(int offset) {
    final group = getUint16(offset);
    final elt = getUint16(offset + 2);
    return (group << 16) + elt;
  }

  int getVRCode(int offset) => (getUint8(offset) << 8) + getUint8(offset + 1);

  int getShortVLF(int offset) => getUint16(offset);

  int getLongVLF(int offset) => getUint32(offset);

  // **** Primitive Setters

  /// Returns the Tag Code from [Bytes].
  void setCode(int code) {
    setUint16(0, code >> 16);
    setUint16(2, code & 0xFFFF);
  }

  void setVRCode(int vrCode) {
    setUint8(4, vrCode >> 8);
    setUint8(5, vrCode & 0xFF);
  }

  void setShortVLF(int vlf) => setUint16(6, vlf);
  void setLongVLF(int vlf) => setUint32(8, vlf);

  /// Write a short EVR header.
  void evrSetShortHeader(int code, int vlf, int vrCode) {
    setUint16(0, code >> 16);
    setUint16(2, code & 0xFFFF);
    setUint8(4, vrCode >> 8);
    setUint8(5, vrCode & 0xFF);
    setUint16(6, vlf);
  }

  /// Write a short EVR header.
  void evrSetLongHeader(int code, int vlf, int vrCode) {
    setUint16(0, code >> 16);
    setUint16(2, code & 0xFFFF);
    setUint8(4, vrCode >> 8);
    setUint8(5, vrCode & 0xFF);
    // The Uint16 field at offset 6 is already zero.
    setUint32(8, vlf);
  }

  /// Write a short EVR header.
  void ivrSetHeader(int offset, int code, int vlf) {
    setUint16(offset, code >> 16);
    setUint16(2, code & 0xFFFF);
    setUint32(4, vlf);
  }

  void writeInt8VF(List<int> vList) => setInt8List(vfOffset, vList);
  void writeInt16VF(List<int> vList) => setInt16List(vfOffset, vList);
  void writeInt32VF(List<int> vList) => setInt32List(vfOffset, vList);
  void writeInt64VF(List<int> vList) => setInt64List(vfOffset, vList);

  void writeUint8VF(List<int> vList) => setUint8List(vfOffset, vList);
  void writeUint16VF(List<int> vList) => setUint16List(vfOffset, vList);
  void writeUint32VF(List<int> vList) => setUint32List(vfOffset, vList);
  void writeUint64VF(List<int> vList) => setUint64List(vfOffset, vList);

  void writeFloat32VF(List<double> vList) => setFloat32List(vfOffset, vList);
  void writeFloat64VF(List<double> vList) => setFloat64List(vfOffset, vList);

  void writeAsciiVF(List<String> vList, [int pad = kSpace]) =>
      setAsciiList(vfOffset, vList, pad);
  void writeUtf8VF(List<String> vList) => setUtf8(vfOffset, vList.join('\\'));
  void writeTextVF(List<String> vList) => setUtf8(vfOffset, vList[0]);

  int writeAsciiVFFast(int offset, List<String> vList, [int padChar]) {
    var index = offset;
    if (vList.isEmpty) return index;
    final last = vList.length - 1;
    for (var i = 0; i < vList.length; i++) {
      final s = vList[i];
      for (var j = 0; j < s.length; j++) setUint8(index, s.codeUnitAt(i));
      if (i != last) {
        setUint8(index++, kBackslash);
      } else {
        if (index.isOdd && padChar != null) setUint8(index++, padChar);
      }
    }
    return index;
  }

  /// Returns the length in bytes of this Byte Element without padding.
  int _vflWOPadding(int vfOffset) {
    final length = bd.lengthInBytes - vfOffset;
    if (length == 0 || length.isOdd) return length;
    final newLen = length - 1;
    final last = getUint8(newLen);
    return (last == kSpace || last == kNull) ? newLen : length;
  }

  // Allows the removal of padding characters.
  Uint8List asUint8List([int offset = 0, int length, int padChar = 0]) {
    assert(padChar == null || padChar == kSpace || padChar == kNull);
    length ??= eLength;
    return (length == 0)
        ? kEmptyUint8List
        : bd.buffer.asUint8List(bd.offsetInBytes + offset, length - offset);
  }

  static const int _kGroupOffset = 0;
  static const int _kEltOffset = 0;
}

// TODO Jim remove reader and writer methods from DicomMixin
abstract class DicomReaderMixin {
  int get _bdOffset;
  int get _bdLength;
  int get vfOffset;
  int get vfLengthOffset;
  int get vfLengthField;
  int getUint8(int offset);
  int getUint16(int offset);
  int getUint32(int offset);
  int getVLF(int offset);
  Bytes asBytes([int offset = 0, int length, Endian endian]);
  Uint8List asUint8List([int offset = 0, int length]);

  // **** End of Interface

  int get code {
    final group = getUint16(0);
    final elt = getUint16(2);
    return (group << 16) + elt;
  }

  /// The Element Group Field
  int get group => getUint16(_kGroupOffset);

  /// The Element _element_ Field.
  int get elt => getUint16(_kEltOffset);

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
  Uint8List get vfUint8List => asUint8List(_bdOffset + vfOffset, vfLength);

  /// Returns the Value Field as a Uint8List _without_ padding.
  Uint8List get vfUint8ListWOPadding =>
      asUint8List(_bdOffset + vfOffset, _vflWOPadding(vfOffset));

  // ** Primitive Getters

  int getCode(int offset) {
    final group = getUint16(offset);
    final elt = getUint16(offset + 2);
    return (group << 16) + elt;
  }

  int getVRCode(int offset) =>
      (getUint16(offset) << 8) + getUint8(offset + 1);

  int getShortVLF(int offset) => getUint16(offset);

  int getLongVLF(int offset) => getUint32(offset);

  /// Returns the length in bytes of this Byte Element without padding.
  int _vflWOPadding(int vfOffset) {
    final length = _bdLength - vfOffset;
    if (length == 0 || length.isOdd) return length;
    final newLen = length - 1;
    final last = getUint8(newLen);
    return (last == kSpace || last == kNull) ? newLen : length;
  }

  static const int _kGroupOffset = 0;
  static const int _kEltOffset = 0;
}

abstract class DicomWriterMixin {
  void setUint8(int offset, int value);
  void setUint16(int offset, int value);
  void setUint32(int offset, int value);
// **** End of Interface

  /// Returns the Tag Code from [Bytes].
  void setCode(int code) {
    setUint16(0, code >> 16);
    setUint16(2, code & 0xFFFF);
  }

  void setVRCode(int vrCode) {
    setUint8(4, vrCode >> 8);
    setUint8(5, vrCode & 0xFF);
  }

  void setShortVLF(int vlf) => setUint16(6, vlf);
  void setLongVLF(int vlf) => setUint32(8, vlf);

  /// Write a short EVR header.
  void evrSetShortHeader(int code, int vrCode, int vlf) {
    setUint16(0, code >> 16);
    setUint16(2, code & 0xFFFF);
    setUint16(4, vrCode);
    setUint16(6, vlf);
  }

  /// Write a short EVR header.
  void evrSetLongHeader(int code, int vrCode, int vlf) {
    setUint16(0, code >> 16);
    setUint16(2, code & 0xFFFF);
    setUint16(4, vrCode);
    // This field is zero, but GC takes care of  that
    //  setUint16( 6, 0)
    setUint32(8, vlf);
  }

  /// Write a short EVR header.
  void ivrSetHeader(int offset, int code, int vlf) {
    setUint16(offset, code >> 16);
    setUint16(2, code & 0xFFFF);
    setUint32(4, vlf);
  }
}
