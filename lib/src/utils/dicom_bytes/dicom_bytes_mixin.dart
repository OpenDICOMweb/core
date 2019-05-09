//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:convert' as cvt;
import 'dart:typed_data';

import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/dicom_bytes.dart';
import 'package:core/src/utils/character/ascii.dart';
import 'package:core/src/utils/character/charset.dart';
import 'package:core/src/utils/dicom.dart';
import 'package:core/src/utils/primitives.dart';

mixin DicomBytesMixin {
  Uint8List get buf;
  bool get isEvr;
  int get vrCode;
  int get vrIndex;
  String get vrId;
  Endian get endian;
  int get offset;
  int get vfOffset;
  int get vfLengthOffset;
  int get vfLengthField;
  int get length;

  int getUint8(int offset);
  int getUint16(int offset);
  int getUint32(int offset);
  int getUint64(int offset);

  void setUint8(int offset, int value);
  void setUint16(int offset, int value);
  void setUint32(int offset, int value);
  void setUint64(int offset, int value);

  int setInt8List(int start, List<int> list, [int offset = 0, int length]);
  int setInt16List(int start, List<int> list, [int offset = 0, int length]);
  int setInt32List(int start, List<int> list, [int offset = 0, int length]);
  int setInt64List(int start, List<int> list, [int offset = 0, int length]);

  int setUint16List(int start, List<int> list, [int offset = 0, int length]);
  int setUint32List(int start, List<int> list, [int offset = 0, int length]);
  int setUint64List(int start, List<int> list, [int offset = 0, int length]);

  int setFloat32List(int start, List<double> list,
      [int offset = 0, int length]);
  int setFloat64List(int start, List<double> list,
      [int offset = 0, int length]);

  Bytes asBytes([int offset = 0, int length, Endian endian = Endian.little]);

  // **** End of Interface

  Uint8List _removePadding(Uint8List list) {
    if (list.isEmpty) return list;
    final lastIndex = list.length - 1;
    final c = list[lastIndex];
    return (c == kSpace || c == kNull)
        ? list.buffer.asUint8List(list.offsetInBytes, lastIndex)
        : list;
  }

  String _getString(int offset, int length, bool allowInvalid, bool noPadding,
      Charset charset) {
    var list = asUint8List(offset, length ?? buf.length);
    list = noPadding ? _removePadding(list) : list;
    return list.isEmpty ? '' : charset.decode(list, allowInvalid: true);
  }

  /// Returns a [String] containing a _UTF-8_ decoding of the specified region.
  String getString(
          {int offset = 0,
          int length,
          bool allowInvalid = true,
          Charset charset = utf8,
          bool noPadding = false}) =>
      _getString(
          offset, length ?? buf.length, allowInvalid, noPadding, charset);

  /// Returns a [List<String>]. This is done by first decoding
  /// the specified region as _UTF-8_, and then _split_ing the
  /// resulting [String] using the [separator].
  List<String> getStringList(
      {int offset = 0,
      int length,
      bool allowInvalid = true,
      String separator = '\\',
      Charset charset}) {
    final s = getString(
        offset: offset,
        length: length,
        allowInvalid: allowInvalid,
        charset: charset);
    return (s.isEmpty) ? kEmptyStringList : s.split(separator);
  }

  /// Returns a [String] containing a _ASCII_ decoding of the specified
  /// region of _this_. Also allows the removal of a padding character.
  String getAscii(
          {int offset = 0,
          int length,
          bool allowInvalid = true,
          bool noPadding = false}) =>
      _getString(offset, length, allowInvalid, noPadding, ascii);

  /// Returns a [List<String>]. This is done by first decoding
  /// the specified region as _ASCII_, and then _split_ing the
  /// resulting [String] using the [separator]. Also allows the
  /// removal of a padding character.
  List<String> getAsciiList(
      {int offset = 0,
      int length,
      bool allowInvalid = true,
      String separator = '\\',
      bool noPadding = false}) {
    final s = getAscii(
        offset: offset,
        length: length,
        allowInvalid: allowInvalid,
        noPadding: noPadding);
    return (s.isEmpty) ? kEmptyStringList : s.split(separator);
  }

  /// Returns a [String] containing a _UTF-8_ decoding of the specified region.
  /// Also, allows the removal of padding characters.
  String getUtf8(
          {int offset = 0,
          int length,
          bool allowInvalid = true,
          bool noPadding = false}) =>
      _getString(offset, length, allowInvalid, noPadding, utf8);

  /// Returns a [List<String>]. This is done by first decoding
  /// the specified region as _UTF-8_, and then _split_ing the
  /// resulting [String] using the [separator].
  List<String> getUtf8List(
      {int offset = 0,
      int length,
      bool allowInvalid = true,
      String separator = '\\'}) {
    final s =
        getUtf8(offset: offset, length: length, allowInvalid: allowInvalid);
    return (s.isEmpty) ? kEmptyStringList : s.split(separator);
  }

  /// Decoding the bytes in the specified region as _Latin1_ to _latin9_
  /// characters and returns them as a [String]. Also, allows
  /// the removal of padding characters.
  String getLatin(
          {int offset = 0,
          int length,
          bool allowInvalid = true,
          bool noPadding = false}) =>
      _getString(offset, length, allowInvalid, noPadding, latin1);

  /// Returns a [List<String>]. This is done by first decoding
  /// the specified region as _UTF-8_, and then _split_ing the
  /// resulting [String] using the [separator].
  List<String> getLatinList(
      {int offset = 0,
      int length,
      bool allowInvalid = true,
      String separator = '\\'}) {
    final s =
        getLatin(offset: offset, length: length, allowInvalid: allowInvalid);
    return (s.isEmpty) ? kEmptyStringList : s.split(separator);
  }

  /// If _true_ padding characters will not be included in the equality test.
  bool ignorePadding = true;

  @override
  bool operator ==(Object other) =>
      (other is Bytes) && _bytesEqual(this, other, ignorePadding);

  int get code => getCode(0);

  /// The Element Group Field
  int get group => getUint16(_kGroupOffset);

  /// The Element _element_ Field.
  int get elt => getUint16(_kEltOffset);

  Tag get tag => Tag.lookup(code);

  /// Returns the length in bytes of _this_ Element.
  int get eLength => buf.length;

  /// Returns _true_ if [vfLengthField] equals [kUndefinedLength].
  bool get hasUndefinedLength => vfLengthField == kUndefinedLength;

  /// Returns the actual length of the Value Field.
  int get vfLength => buf.length - vfOffset;

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
      buf.buffer.asUint8List(offset + vfOffset, vfLength);

  /// Gets the DICOM Tag Code at [offset].
  int getCode(int offset) {
    //print('get code ${hex(code)} $code');
    final group = getUint16(offset);
    //   print('group ${hex16(group)}');
    final elt = getUint16(offset + 2);
    //   print('elt ${hex16(elt)}');
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
    // Note: The Uint16 field at offset 6 is already zero.
    setUint32(8, vlf);
  }

  /// Write a short EVR header.
  void ivrSetHeader(int offset, int code, int vlf) {
    setUint16(offset, code >> 16);
    setUint16(2, code & 0xFFFF);
    setUint32(4, vlf);
  }

  // **** String Setters

  /// Ascii encodes the specified range of [s] and then writes the
  /// code units to _this_ starting at [start]. If [padChar] is not
  /// _null_ and [s].length is odd, then [padChar] is written after
  /// the code units of [s] have been written.
  int setAscii(int start, String s,
          [int offset = 0, int length, int padChar = kSpace]) =>
      setUint8List(start, cvt.utf8.encode(s), 0, null, padChar);

  // TODO: unit test
  /// UTF-8 encodes the specified range of [s] and then writes the
  /// code units to _this_ starting at [start]. Returns the offset
  /// of the last byte + 1.
  int setUtf8(int start, String s,
          [int offset = 0, int length, int padChar = kSpace]) =>
      setUint8List(
          start, cvt.utf8.encode(s), offset, length ?? s.length, padChar);

  /// Converts the [String]s in [sList] into a [Uint8List].
  /// Then copies the bytes into _this_ starting at
  /// [start]. If [padChar] is not _null_ and the offset of the last
  /// byte written is odd, then [padChar] is written to _this_.
  /// Returns the number of bytes written.
  int setUtf8List(int start, List<String> sList, [int padChar]) =>
      setUtf8(start, sList.join('\\'), padChar);

  /// Moves bytes from [list] to _this_. If [list].[length] is odd adds [pad]
  /// as last byte. Returns the number of bytes written.
  int setUint8List(int start, List<int> list,
      [int offset = 0, int length, int pad = kSpace]) {
    length ??= list.length;
    for (var i = offset, j = start; i < length; i++, j++) buf[j] = list[i];
    if (length.isOdd && pad != null) {
      setUint8(length + start, pad);
//      print('setUint8List: ${length + start}');
      return length + 1;
    }
    return length;
  }

  // **** String List Setters

  /// Writes the ASCII [String]s in [sList] to _this_ starting at
  /// [start]. If [padChar] is not _null_ and the final offset is odd,
  /// then [padChar] is written after the other elements have been written.
  /// Returns the number of bytes written.
  int setAsciiList(int start, List<String> sList,
      [int padChar = kSpace]) =>
      _setLatinList(start, sList, padChar, 127);

  /// Writes the LATIN [String]s in [sList] to _this_ starting at
  /// [start]. If [padChar] is not _null_ and the final offset is odd,
  /// then [padChar] is written after the other elements have been written.
  /// Returns the number of bytes written.
  /// _Note_: All latin character sets are encoded as single 8-bit bytes.
  int setLatinList(int start, List<String> sList, [int padChar = kSpace]) =>
      _setLatinList(start, sList, padChar, 255);

  /// Copy [String]s from [sList] into _this_ separated by backslash.
  /// If [padChar] is not equal to _null_ and last character position
  /// is odd, then add [padChar] at end.
  // Note: this only works for ascii or latin
  int _setLatinList(
    int start,
    List<String> sList,
    int padChar,
    int limit,
  ) {
    assert(padChar == kSpace || padChar == kNull);
    if (sList.isEmpty) return 0;
    final last = sList.length - 1;
    var k = start;

    for (var i = 0; i < sList.length; i++) {
      final s = sList[i];
      for (var j = 0; j < s.length; j++) {
        final c = s.codeUnitAt(j);
        if (c > limit)
          throw ArgumentError('Character code $c is out of range $limit');
        setUint8(k++, s.codeUnitAt(j));
      }
      if (i != last) setUint8(k++, kBackslash);
    }
    if (k.isOdd && padChar != null) setUint8(k++, padChar);
    return k - start;
  }

  // Urgent: are these really needed??
  void writeInt8VF(List<int> vList) => setInt8List(vfOffset, vList);
  void writeInt16VF(List<int> vList) => setInt16List(vfOffset, vList);
  void writeInt32VF(List<int> vList) => setInt32List(vfOffset, vList);
  void writeInt64VF(List<int> vList) => setInt64List(vfOffset, vList);

  void writeUint8VF(List<int> vList) =>
      setUint8List(vfOffset, vList, 0, vList.length, kNull);
  void writeUint16VF(List<int> vList) => setUint16List(vfOffset, vList);
  void writeUint32VF(List<int> vList) => setUint32List(vfOffset, vList);
  void writeUint64VF(List<int> vList) => setUint64List(vfOffset, vList);

  void writeFloat32VF(List<double> vList) => setFloat32List(vfOffset, vList);
  void writeFloat64VF(List<double> vList) => setFloat64List(vfOffset, vList);

  void writeAsciiVF(List<String> vList, [int pad = kSpace]) =>
      setAsciiList(vfOffset, vList, pad);
  void writeUtf8VF(List<String> vList, [int pad = kSpace]) =>
      setUtf8List(vfOffset, vList, pad);
  void writeTextVF(List<String> vList, [int pad = kSpace]) =>
      setUtf8(vfOffset, vList[0], pad);

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
// Urgent remove above if not needed

  // Allows the removal of padding characters.
  Uint8List asUint8List([int offset = 0, int length, int padChar = 0]) {
    assert(padChar == null || padChar == kSpace || padChar == kNull);
    length ??= eLength;
    return (length == 0)
        ? kEmptyUint8List
        : buf.buffer.asUint8List(buf.offsetInBytes + offset, length - offset);
  }

  static const int _kGroupOffset = 0;
  static const int _kEltOffset = 0;
}

// TODO: test performance of _uint16Equal and _uint32Equal
bool _bytesEqual(DicomBytes a, DicomBytes b, bool ignorePadding) {
  final len0 = a.length;
  final len1 = b.length;
  if (len0 != len1) return false;
  if ((len0 % 4) == 0) {
    return _uint32Equal(a, b, ignorePadding);
  } else if ((len0 % 2) == 0) {
    return _uint16Equal(a, b, ignorePadding);
  } else {
    return _uint8Equal(a, b, ignorePadding);
  }
}

// Note: optimized to use 4 byte boundary
bool _uint8Equal(DicomBytes a, DicomBytes b, bool ignorePadding) {
  for (var i = 0; i < a.length; i += 1) {
    final x = a.buf[i];
    final y = b.buf[i];
    if (x != y) return _bytesMaybeNotEqual(i, a, b, ignorePadding);
  }
  return true;
}

// Note: optimized to use 2 byte boundary
bool _uint16Equal(DicomBytes a, DicomBytes b, bool ignorePadding) {
  for (var i = 0; i < a.length; i += 2) {
    final x = a.getUint16(i);
    final y = b.getUint16(i);
    if (x != y) return _bytesMaybeNotEqual(i, a, b, ignorePadding);
  }
  return true;
}

// Note: optimized to use 4 byte boundary
bool _uint32Equal(DicomBytes a, DicomBytes b, bool ignorePadding) {
  for (var i = 0; i < a.length; i += 4) {
    final x = a.getUint32(i);
    final y = b.getUint32(i);
    if (x != y) return _bytesMaybeNotEqual(i, a, b, ignorePadding);
  }
  return true;
}

bool _bytesMaybeNotEqual(
    int i, DicomBytes a, DicomBytes b, bool ignorePadding) {
  var errorCount = 0;
  final ok = __bytesMaybeNotEqual(i, a, b, ignorePadding);
  if (!ok) {
    errorCount++;
    if (errorCount > 3) throw ArgumentError('Unequal');
    return false;
  }
  return true;
}

bool __bytesMaybeNotEqual(int i, Bytes a, Bytes b, bool ignorePadding) {
  if ((a[i] == 0 && b[i] == 32) || (a[i] == 32 && b[i] == 0)) {
    //  log.warn('$i ${a[i]} | ${b[i]} Padding char difference');
    return ignorePadding;
  } else {
    _warnBytes(i, a, b);
    return false;
  }
}

void _warnBytes(int i, Bytes a, Bytes b) {
  final x = a[i];
  final y = b[i];
  print('''
$i: $x | $y')
	  "${String.fromCharCode(x)}" | "${String.fromCharCode(y)}"
	    '    $a')
      '    $b')
      '    ${a.getAscii()}')
      '    ${b.getAscii()}');
''');
}
