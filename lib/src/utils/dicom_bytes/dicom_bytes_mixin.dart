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
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/character/ascii.dart';
import 'package:core/src/utils/dicom.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/vr/vr_base.dart';

// ignore_for_file: public_member_api_docs

mixin DicomBytesMixin {
  ByteData get bd;
  bool get isEvr;
  int get vfLengthOffset;
  int get vfLengthField;
  set vfLengthField(int length);
  int get vfOffset;

  int getUint16(int offset);
  int getUint8(int offset);
  int getUint32(int offset);

  void setUint8(int offset, int value);
  void setUint16(int offset, int value);
  void setUint32(int offset, int value);

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

  Bytes asBytes([int offset = 0, int length]);

  // **** End of Interface

  int get code {
    final group = getUint16(0);
    final elt = getUint16(2);
    return (group << 16) + elt;
  }

  set code(int v) {
    setUint16(0, v >> 16);
    setUint16(2, v & 0xFFFF);
  }

  /// The Element Group Field
  int get group => getUint16(_kGroupOffset);

  /// The Element _element_ Field.
  int get elt => getUint16(_kEltOffset);

  Tag get tag => Tag.lookup(code);

  //  int get vrCode => bd.getUint8(4) << 8 + bd.getUint8(5) & 0xFF;

  int get vrCode => (getUint8(kVROffset) << 8) + getUint8(kVROffset + 1);

  set vrCode(int v) {
    print('vr: ${hex8(v >> 8)},${hex8(v & 0xFF)}');
    setUint8(kVROffset, v >> 8);
    setUint8(kVROffset + 1, v & 0xFF);
  }

  int get vrIndex => vrIndexFromCode(vrCode);

  String get vrId => vrIdByIndex[vrIndex];

  /// Returns the length in bytes of _this_ Element.
  int get eLength => bd.lengthInBytes;

  /// Returns _true_ if [vfLengthField] equals [kUndefinedLength].
  bool get hasUndefinedLength => vfLengthField == kUndefinedLength;

  /// Returns the actual length of the Value Field.
  int get vfLength => bd.lengthInBytes - vfOffset;

  /// Returns the Value Field bytes.
  Bytes get vfBytes => asBytes(vfOffset, vfLength);

  /// Returns the last Uint8 element in [vfBytes], if [vfBytes]
  /// is not empty; otherwise, returns _null_.
  int get vfBytesLast {
    final len = eLength;
    return (len == 0) ? null : getUint8(len - 1);
  }

  /// Returns the Value Field as a Uint8List.
  Uint8List get vfUint8List =>
      bd.buffer.asUint8List(bd.offsetInBytes + vfOffset, vfLength);

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

  // Allows the removal of padding characters.
  Uint8List asUint8List([int offset = 0, int length, int padChar = 0]) {
    assert(padChar == null || padChar == kSpace || padChar == kNull);
    length ??= eLength;
    return (length == 0)
        ? kEmptyUint8List
        : bd.buffer.asUint8List(bd.offsetInBytes + offset, length - offset);
  }

  /// Checks the Value Field length.
  bool checkVFLengthField(int vfLengthField, int vfLength) {
    if (vfLengthField != vfLength && vfLengthField != kUndefinedLength) {
      log.warn('** vfLengthField($vfLengthField) != vfLength($vfLength)');
      if (vfLengthField == vfLength + 1) {
        log.warn('** vfLengthField: Odd length field: $vfLength');
        return true;
      }
      return false;
    }
    return true;
  }

  static const int _kGroupOffset = 0;
  static const int _kEltOffset = 0;
}
