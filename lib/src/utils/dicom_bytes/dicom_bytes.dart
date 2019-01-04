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
import 'package:core/src/vr/vr_base.dart';

import 'package:core/src/utils/dicom_bytes/dicom_bytes_mixin.dart';
import 'package:core/src/utils/dicom_bytes/evr_bytes.dart';
import 'package:core/src/utils/dicom_bytes/ivr_bytes.dart';
import 'package:core/src/utils/dicom_bytes/utils.dart';

/// A abstract subclass of [Bytes] that supports Explicit Value
/// Representations (EVR) and Implicit Value Representations (IVR).
abstract class DicomBytes extends Bytes with DicomBytesMixin {
  /// Creates a [DicomBytes] from [bd].
  DicomBytes(ByteData bd) : super(bd);

  /// Creates a [DicomBytes] of [vfLength].
  static DicomBytes make(int code, int vfLength,
      Endian endian, bool isEvr, int vrCode) {
    DicomBytes bytes;
    if (isEvr) {
      if (isEvrLongVR(vrIndexFromCode(vrCode))) {
        endian == Endian.big
            ? bytes = EvrLongBytesBE(vfLength)
            : bytes = EvrLongBytesLE(vfLength);
      } else {
        endian == Endian.big
            ? bytes = EvrShortBytesBE(vfLength)
            : bytes = EvrShortBytesLE(vfLength);
      }
    } else {
      endian == Endian.big
          ? bytes = IvrBytesBE(vfLength)
          : bytes = IvrBytesLE(vfLength);
    }
    bytes
      ..code = code
      ..vrCode = vrCode
      ..vfLengthField = vfLength;
    print('bytes: $bytes');
    return bytes;
  }

  /// Creates a [DicomBytes] from a copy of [bytes].
  static DicomBytes fromBytes(Bytes bytes, int start, int end, Endian endian,
      {bool isEvr = true}) {
    if (isEvr) {
      if (isEvrLongFromBytes(bytes, start)) {
        return endian == Endian.big
            ? EvrLongBytesBE.from(bytes, start, end)
            : EvrLongBytesLE.from(bytes, start, end);
      } else {
        return endian == Endian.big
            ? EvrShortBytesBE.from(bytes, start, end)
            : EvrShortBytesLE.from(bytes, start, end);
      }
    } else {
      return endian == Endian.big
          ? IvrBytesBE.from(bytes, start, end)
          : IvrBytesLE.from(bytes, start, end);
    }
  }

  /// Creates a [DicomBytes] view of [bytes].
  static Bytes view(Bytes bytes,
      {bool isEvr = true,
      int start = 0,
      int end,
      Endian endian = Endian.little}) {
    if (isEvr) {
      if (isEvrLongFromBytes(bytes, start)) {
        return endian == Endian.big
            ? EvrLongBytesBE.view(bytes, start, end)
            : EvrLongBytesLE.view(bytes, start, end);
      } else {
        return endian == Endian.big
            ? EvrShortBytesBE.view(bytes, start, end)
            : EvrShortBytesLE.view(bytes, start, end);
      }
    } else {
      return endian == Endian.big
          ? IvrBytesBE.view(bytes, start, end)
          : IvrBytesLE.view(bytes, start, end);
    }
  }

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
  /// The [String]s in [vList] are joined into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as ASCII. The result is returns as [Bytes].
  static Bytes fromAsciiList(List<String> vList,
          [String separator = '\\', String padChar = ' ']) =>
      vList.isEmpty
          ? Bytes.kEmptyBytes
          : fromAscii(vList.join(separator), padChar);

  // Issue: remove when Bytes == Uint8List or Uint8List is no longer used in ODW
  /// Returns a [Bytes] containing UTF-8 code units.
  ///
  /// The [String]s in [vList] are joined into a single string using
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
