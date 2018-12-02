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
import 'package:core/src/utils/dicom_bytes/evr_bytes.dart';
import 'package:core/src/utils/dicom_bytes/ivr_bytes.dart';

/// A abstract subclass of [Bytes] that supports Explicit Value
/// Representations (EVR) and Implicit Value Representations (IVR).
abstract class DicomBytes extends Bytes with DicomBytesMixin {
  /// Creates a [DicomBytes] view of [bytes].
  Bytes view(Bytes bytes, int vrIndex,
      {bool isEvr = true,
      int offset = 0,
      int end,
      Endian endian = Endian.little}) {
    if (isEvr) {
      if (isEvrLongVR(vrIndex)) {
        return endian == Endian.big
            ? EvrLongBE.view(bytes, offset, end)
            : EvrLongLE.view(bytes, offset, end);
      } else {
        return endian == Endian.big
            ? EvrShortBE.view(bytes, offset, end)
            : EvrShortLE.view(bytes, offset, end);
      }
    } else {
      return endian == Endian.bug
          ? IvrBytesBE.view(bytes, offset, end)
          : IvrBytesBE.view(bytes, offset, end);
    }
  }

  /// Creates a [DicomBytes] from a copy of [bytes].
  factory DicomBytes.from(Bytes bytes, int start, int end, Endian endian) =>
      endian == Endian.big
          ? BytesBE.from(bytes, start, end)
          : BytesLE.from(bytes, start, end);

  factory DicomBytes._view(Bytes bytes,
          [int offset = 0, int end, Endian endian = Endian.little]) =>
      endian == Endian.big
          ? BytesBE.view(bytes, offset, end)
          : BytesLE.view(bytes, offset, end);

  /// Creates a new [Bytes] from a [TypedData] containing the specified
  /// region and [endian]ness.  [endian] defaults to [Endian.host].
  factory DicomBytes.typedDataView(TypedData td,
          [int offset = 0, int length, Endian endian = Endian.little]) =>
      endian == Endian.big
          ? BytesBE.typedDataView(td, offset, length)
          : BytesLE.typedDataView(td, offset, length);

  @override
  String toString() {
    final vlf = vfLengthField;
    return '$runtimeType ${dcm(code)} $vrId($vrIndex, ${hex16(vrCode)}) '
        'vlf($vlf, ${hex32(vlf)}) vfl($vfLength) ${super.toString()}';
  }

  /// Returns a [Bytes] containing the ASCII encoding of [s].
  /// If [s].length is odd, [padChar] is appended to [s] before
  /// encoding it.
  static Bytes fromAscii(String s, [String padChar = ' ']) =>
      Bytes.ascii(_maybePad(s, padChar));

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  static Bytes fromUtf8(String s, [String padChar = ' ']) =>
      Bytes.utf8(_maybePad(s, padChar));

  static String _maybePad(String s, String p) => s.length.isOdd ? '$s$p' : s;

  /// Returns a [Bytes] containing ASCII code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as ASCII. The result is returns as [Bytes].
  static Bytes fromAsciiList(List<String> vList,
          [String separator = '\\', String padChar = ' ']) =>
      vList.isEmpty
          ? Bytes.kEmptyBytes
          : fromAscii(vList.join(separator), padChar);

  /// Returns a [Bytes] containing UTF-8 code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as ASCII. The result is returns as [Bytes].
  static Bytes fromUtf8List(List<String> vList, [String separator = '\\']) =>
      (vList.isEmpty) ? Bytes.kEmptyBytes : fromUtf8(vList.join('\\'));

  /// Returns a [Bytes] containing UTF-8 code units. See [fromUtf8List].
  static Bytes fromStringList(List<String> vList, [String separator = '\\']) =>
      (vList.isEmpty) ? Bytes.kEmptyBytes : fromUtf8(vList.join('\\'));

  /// Returns a [ByteData] that is a copy of the specified region of _this_.
  static ByteData copyBDRegion(ByteData bd, int offset, int length) {
    final _length = length ?? bd.lengthInBytes;
    final _nLength = _length.isOdd ? _length + 1 : length;
    final bdNew = ByteData(_nLength);
    for (var i = 0, j = offset; i < _length; i++, j++)
      bdNew.setUint8(i, bd.getUint8(j));
    return bdNew;
  }
}

/// Checks the Value Field length.
bool isValidVFLengthField(int vfLengthField, int vfLength) {
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
