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
  bool get isEvr;
  ByteData get _bd;
  ByteData get bd;
//  set bd(ByteData bd);
  int get vrCode;
  int get vrIndex;
  String get vrId;
  Endian get endian;
  int get _bdOffset;
  int get _bdLength;
  int get vfOffset;
  int get vfLengthOffset;
  int get vfLengthField;

  int _getInt8(int offset);
  int _getInt16(int offset);
  int _getInt32(int offset);
  int _getInt64(int offset);

  int _getUint8(int offset);
  int _getUint16(int offset);
  int _getUint32(int offset);
  int _getUint64(int offset);

  double _getFloat32(int offset);
  double _getFloat64(int offset);

  int _setInt8(int offset, int value);
  int _setInt16(int offset, int value);
  int _setInt32(int offset, int value);
  int _setInt64(int offset, int value);

  int _setUint8(int offset, int value);
  int _setUint16(int offset, int value);
  int _setUint32(int offset, int value);
  int _setUint64(int offset, int value);

  double _setFloat32(int offset, double value);
  double _setFloat64(int offset, double value);

  int setInt8List(int start, List<int> list, [int offset = 0, int length]);
  int setInt16List(int start, List<int> list, [int offset = 0, int length]);
  int setInt32List(int start, Int32List list, [int offset = 0, int length]);
  int setInt64List(int start, Int64List list, [int offset = 0, int length]);

  int setUint8List(int start, List<int> list, [int offset = 0, int length]);
  int setUint16List(int start, List<int> list, [int offset = 0, int length]);
  int setUint32List(int start, List<int> list, [int offset = 0, int length]);
  int setUint64List(int start, List<int> list, [int offset = 0, int length]);

  int setFloat32List(int start, List<double> list,
      [int offset = 0, int length]);
  int setFloat64List(int start, List<double> list,
      [int offset = 0, int length]);

  String toBDDescriptor(ByteData bd);

  String _maybeGetSubstring(String s, int offset, int length);

  int _absIndex(int offset);

  Bytes asBytes([int offset = 0, int length, Endian endian]);

  // Note: special internal interface for writing padChars
  int _setUint8List(int start, Uint8List list,
      [int offset = 0, int length, int padChar]);

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
  Bytes get vBytes => asBytes(vfOffset, _vflWOPadding(vfOffset));

  /// Returns the last Uint8 element in [vfBytes], if [vfBytes]
  /// is not empty; otherwise, returns _null_.
  int get vfBytesLast {
    final len = eLength;
    return (len == 0) ? null : _getUint8(len - 1);
  }

  /// Returns the Value Field as a Uint8List.
  Uint8List get vfUint8List =>
      _bd.buffer.asUint8List(_bdOffset + vfOffset, vfLength);

  /// Returns the Value Field as a Uint8List _without_ padding.
//  Uint8List get vfUint8ListWOPadding =>
//      _bd.buffer.asUint8List(_bdOffset + vfOffset, _vflWOPadding(vfOffset));

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
  void evrSetShortHeader(int code, int vlf, int vrCode) {
    _setUint16(0, code >> 16);
    _setUint16(2, code & 0xFFFF);
    _setUint16(4, vrCode);
    _setUint16(6, vlf);
  }

  /// Write a short EVR header.
  void evrSetLongHeader(int code, int vlf, int vrCode) {
    _setUint16(0, code >> 16);
    _setUint16(2, code & 0xFFFF);
    _setUint16(4, vrCode);
    // The Uint16 field at offset 6 is already zero.
    _setUint32(8, vlf);
  }

  /// Write a short EVR header.
  void ivrSetHeader(int offset, int code, int vlf) {
    _setUint16(offset, code >> 16);
    _setUint16(2, code & 0xFFFF);
    _setUint32(4, vlf);
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
      for (var j = 0; j < s.length; j++) _setUint8(index, s.codeUnitAt(i));
      if (i != last) {
        _setUint8(index++, kBackslash);
      } else {
        if (index.isOdd && padChar != null) _setUint8(index++, padChar);
      }
    }
    return index;
  }

  /// Writes the elements of the specified [list] to _this_ starting at
  /// [start]. If [pad] is _true_ and the final offset is odd, then a 0 is
  /// written after the other elements have been written.
  int setAsciiList(int start, List<String> list, [int pad = kSpace]) {
    final length = list.length;
    final last = length - 1;
    var k = start;

    for (var i = 0; i < length; i++) {
      final s = list[i];
      for (var j = 0; j < s.length; j++) {
        print('c: ${s.codeUnitAt(j)}');
        _setUint8(k++, s.codeUnitAt(j));
      }
      if (i != last) _setUint8(k++, kBackslash);
    }
    print('pad: $pad');
    if (k.isOdd && pad != null) _setUint8(k++, pad);
    return k - start;
  }

  /// Returns the length in bytes of this Byte Element without padding.
  int _vflWOPadding(int vfOffset) {
    final length = bd.lengthInBytes - vfOffset;
    if (length == 0 || length.isOdd) return length;
    final newLen = length - 1;
    final last = _getUint8(newLen);
    print('last char: $last');
    return (last == kSpace || last == kNull) ? newLen : length;
  }

  // Allows the removal of padding characters.
  String _getAscii(int offset, int length,
          [bool allow = true, int padChar = kSpace]) =>
      ascii.decode(asUint8List(offset, length, padChar), allowInvalid: allow);

  // Allows the removal of padding characters.
  String _getUtf8(int offset, int length,
          [bool allow = true, int padChar = kSpace]) =>
      utf8.decode(asUint8List(offset, length, padChar), allowMalformed: allow);

  // Allows the removal of padding characters.
  Uint8List asUint8List([int offset = 0, int length, int padChar = 0]) {
    assert(padChar == null || padChar == kSpace || padChar == kNull);
    length ??= vfLength;
    final index = _absIndex(vfOffset + offset);
//    final _length = _maybeRemovePadChar(index, length, padChar);
    return _bd.buffer.asUint8List(index, length);
  }

  int _maybeRemovePadChar(int index, int vfLength, [int padChar]) {
    if (padChar != null && vfLength.isEven) {
      final last = index + vfLength - 1;
      final c = _getUint8(last);
      if (c == kSpace || c == kNull) {
        if (c != padChar) log.warn('Expected $padChar but got $c instead');
        return vfLength - 1;
      }
    }
    return vfLength;
  }

  /// Ascii encodes the specified range of [s] and then writes the
  /// code units to _this_ starting at [start]. If [padChar] is not
  /// _null_ and [s].length is odd, then [padChar] is written after
  /// the code units of [s] have been written.
  int setAscii(int start, String s,
      [int offset = 0, int length, int padChar = kSpace]) {
    length ??= s.length;
    final v = _maybeGetSubstring(s, offset, length);
    return _setUint8List(start, ascii.encode(v), offset, length, padChar);
  }

  /// UTF-8 encodes the specified range of [s] and then writes the
  /// code units to _this_ starting at [start]. If [padChar] is not
  /// _null_ and [s].length is odd, then [padChar] is written after
  /// the code units of [s] have been written.
  int setUtf8(int start, String s,
      [int offset = 0, int length, int padChar = kSpace]) {
    length ??= s.length;
    final v = _maybeGetSubstring(s, offset, length);
    return _setUint8List(start, utf8.encode(v), offset, length, padChar);
  }

  /// Writes the elements of the specified region of [list] to
  /// _this_ starting at [start]. If [pad] is _true_ and [length]
  /// is odd, then a 0 is written after the other elements have
  /// been written.
  int __setUint8List(int start, Uint8List list, int offset,
      [int length, int pad]) {
    length ??= list.length;
    final len = _setUint8List(start, list, offset, length);
    if (length.isOdd && pad != null) {
      final index = start + length;
      _setUint8(index, pad);
      return index + 1;
    }
    return len;
  }

  @override
  String toString() {
    final vrc = vrCode;
    final vri = vrIndex;
    final vr = vrId;
    return '$runtimeType ${dcm(code)} $vr($vri, ${hex16(vrc)}) '
        'vlf($vfLengthField) vfl($vfLength) $vfBytes';
  }

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
  Uint8List get vfUint8List => asUint8List(_bdOffset + vfOffset, vfLength);

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
