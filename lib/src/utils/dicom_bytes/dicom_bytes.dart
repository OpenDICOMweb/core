//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
library odw.sdk.utils.dicom_bytes;

import 'dart:typed_data';

import 'package:core/src/global.dart';
import 'package:core/src/system.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/dicom.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/utils/string.dart';
import 'package:core/src/vr.dart';
import 'package:core/src/utils/dicom_bytes/dicom_bytes_mixin.dart';

part 'package:core/src/utils/dicom_bytes/evr_bytes.dart';
part 'package:core/src/utils/dicom_bytes/ivr_bytes.dart';

/// A abstract subclass of [Bytes] that supports Explicit Value
/// Representations (EVR) and Implicit Value Representations (IVR).
abstract class DicomBytes extends Bytes with DicomBytesMixin {
  /// Creates a [DicomBytes] view of [bytes].
  factory DicomBytes.view(Bytes bytes, int vrIndex,
          {bool isEvr = true, int offset = 0, int end, Endian endian}) =>
      (!isEvr)
          ? IvrBytes.view(bytes, offset, end, endian)
          : (vrIndex >= 0 && vrIndex <= kVREvrLongIndexMax)
              ? EvrLongBytes.view(bytes, offset, end, endian)
              : EvrShortBytes.view(bytes, offset, end, endian);

  DicomBytes._(int length, Endian endian) : super(length, endian);

  /// Creates a [DicomBytes] from a copy of [bytes].
  DicomBytes.from(Bytes bytes, int start, int end, Endian endian)
      : super.from(bytes, start, end, endian);

  DicomBytes._view(Bytes bytes, [int offset = 0, int end, Endian endian])
      : super.view(bytes, offset, end, endian);

  /// Creates a new [Bytes] from a [TypedData] containing the specified
  /// region and [endian]ness.  [endian] defaults to [Endian.host].
  DicomBytes.typedDataView(TypedData td,
      [int offsetInBytes = 0, int lengthInBytes, Endian endian])
      : super.typedDataView(td, offsetInBytes, lengthInBytes, endian);

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

/// A growable [DicomBytes].
class GrowableDicomBytes extends GrowableBytes with DicomWriterMixin {
  /// Creates a growable [DicomBytes].
  GrowableDicomBytes([int length, Endian endian, int limit = kDefaultLimit])
      : super(length, endian, limit);

  /// Returns a new [Bytes] of [length].
  GrowableDicomBytes._(int length, Endian endian, int limit)
      : super(length, endian, limit);

  /// Creates a growable [DicomBytes] from [bytes].
  factory GrowableDicomBytes.from(Bytes bytes,
          [int offset = 0,
          int length,
          Endian endian,
          int limit = kDefaultLimit]) =>
      GrowableDicomBytes._from(bytes, offset, length, endian, limit);

  GrowableDicomBytes._from(Bytes bytes, int offset, int length, Endian endian,
      [int limit = kDefaultLimit])
      : super.from(bytes, offset, length, endian, limit);

  /// Creates a growable [DicomBytes] from a view of [td].
  GrowableDicomBytes.typedDataView(TypedData td,
          [int offset = 0,
          int lengthInBytes,
          Endian endian,
          int limit = k1GB])
      : super.typedDataView(td, offset, lengthInBytes, endian, limit);
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
