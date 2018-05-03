//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.utils.bytes;

abstract class DicomBytes extends Bytes with DicomMixin {
  DicomBytes._(int length, Endian endian) : super._(length, endian);

  DicomBytes._from(Bytes bytes, int start, int end, Endian endian)
      : super._from(bytes, start, end, endian);

  @override
  String _getAscii(int offset, int length,
          [bool allow = true, int padChar = kSpace]) =>
      ascii.decode(asUint8List(offset, length, padChar), allowInvalid: allow);

  @override
  String _getUtf8(int offset, int length,
          [bool allow = true, int padChar = kSpace]) =>
      utf8.decode(asUint8List(offset, length), allowMalformed: allow);

  @override
  @override
  Uint8List asUint8List([int offset = 0, int length, int padChar]) {
    assert(padChar == null || padChar == kSpace || padChar == kNull);
    final index = _absIndex(offset);
    final _length = _maybeRemovePadChar(index, length, padChar);
    return _bd.buffer.asUint8List(index, _length);
  }

  int _maybeRemovePadChar(int index, int length, [int padChar]) {
    if (padChar != null && length.isEven) {
      final last = index + length - 1;
      final c = _getUint8(last);
      if (c == kSpace || c == kNull) {
        if (c != padChar) log.warn('Expected $padChar but got $c instead');
        return length - 1;
      }
    }
    return length;
  }

  /// Ascii encodes the specified range of [s] and then writes the
  /// code units to _this_ starting at [start]. If [padChar] is not
  /// _null_ and [s].length is odd, then [padChar] is written after
  /// the code units of [s] have been written.
  @override
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
  @override
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
  @override
  int setUint8List(int start, Uint8List list,
          [int offset = 0, int length, bool pad = false]) =>
      _setUint8List(start, list, offset, length, (pad) ? 0 : null);

  @override
  int _setUint8List(int start, Uint8List list,
      [int offset = 0, int length, int padChar]) {
    var _length = super._setUint8List(start, list, offset, length);
    if (padChar != null && length.isOdd) {
      _bd.setUint8(_length, padChar);
      _length++;
    }
    return length;
  }
}

class DicomGrowableBytes extends GrowableBytes with DicomWriteMixin {
  /// Returns a new [Bytes] of [length].
  DicomGrowableBytes([int length, Endian endian, int limit = kDefaultLimit])
      : super._(length, endian, limit);

  /// Returns a new [Bytes] of [length].
  DicomGrowableBytes._(int length, Endian endian, int limit)
      : super._(length, endian, limit);

  factory DicomGrowableBytes.from(Bytes bytes,
          [int offset = 0,
          int length,
          Endian endian,
          int limit = kDefaultLimit]) =>
      new DicomGrowableBytes._from(bytes, offset, length, endian, limit);

  DicomGrowableBytes._from(Bytes bytes, int offset, int length, Endian endian,
      [int limit = kDefaultLimit])
      : super._from(bytes, offset, length, endian, limit);

  factory DicomGrowableBytes.typedDataView(TypedData td,
          [int offset = 0,
          int lengthInBytes,
          Endian endian,
          int limit = _k1GB]) =>
      new DicomGrowableBytes._tdView(
          td, offset, lengthInBytes ?? td.lengthInBytes, endian, limit);

  DicomGrowableBytes._tdView(
      TypedData td, int offset, int lengthInBytes, Endian endian, int limit)
      : super._tdView(td, offset, lengthInBytes, endian, limit);
}

/// Checks the Value Field length.
bool _checkVFLengthField(int vfLengthField, int vfLength) {
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
