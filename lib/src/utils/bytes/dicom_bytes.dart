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

  DicomBytes.from(Bytes bytes, int start, int end, Endian endian)
      : super._from(bytes, start, end, endian);


  @override
  int _setUint8List(int start, Uint8List list,
                    [int offset = 0, int length, int padChar]) {
    var _length = super._setUint8List(start, list, offset, length);
    if (padChar != null && length.isOdd) {
      _bd.setUint8(start + _length, padChar);
      _length++;
    }
    return length;
  }

  @override
  String toString() =>
      '$runtimeType(${_bd.lengthInBytes}) ${dcm(code)} ${hex16(vrCode)} '
          '$vfLengthField(${hex32(vfLengthField)}) $vfBytes';

  /// Returns a [Bytes] containing the ASCII encoding of [s].
  /// If [s].length is odd, [padChar] is appended to [s] before
  /// encoding it.
  static Bytes fromAscii(String s, [String padChar = ' ']) =>
      Bytes.fromAscii(_maybePad(s, padChar));

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  static Bytes fromUtf8(String s, [String padChar = ' ']) =>
      Bytes.fromUtf8(_maybePad(s, padChar));

  static String _maybePad(String s, String p) => s.length.isOdd ? '$s$p' : s;

  /// Returns a [Bytes] containing ASCII code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as ASCII. The result is returns as [Bytes].
  static Bytes fromAsciiList(List<String> vList,
          [String separator = '\\', String padChar = ' ']) =>
      vList.isEmpty ? kEmptyBytes : fromAscii(vList.join(separator), padChar);

  /// Returns a [Bytes] containing UTF-8 code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as ASCII. The result is returns as [Bytes].
  static Bytes fromUtf8List(List<String> vList,
          [String separator = '\\']) =>
      (vList.isEmpty) ? kEmptyBytes : fromUtf8(vList.join('\\'));

  /// Returns a [Bytes] containing UTF-8 code units. See [fromUtf8List].
  static Bytes fromStringList(List<String> vList, [String separator = '\\']) =>
      (vList.isEmpty) ? kEmptyBytes : fromUtf8(vList.join('\\'));

  /// Returns a [ByteData] that is a copy of the specified region of _this_.
  static ByteData copyBDRegion(ByteData bd, int offset, int length) {
    final _length = length ?? bd.lengthInBytes;
    final _nLength = _length.isOdd ? _length + 1 : length;
    final bdNew = new ByteData(_nLength);
    for (var i = 0, j = offset; i < _length; i++, j++)
      bdNew.setUint8(i, bd.getUint8(j));
    return bdNew;
  }
}

class DicomGrowableBytes extends GrowableBytes with DicomWriterMixin {
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
