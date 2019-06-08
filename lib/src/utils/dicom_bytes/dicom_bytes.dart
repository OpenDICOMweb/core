//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/utils/character/charset.dart';
import 'package:core/src/global.dart';
import 'package:core/src/system.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/dicom.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/utils/string.dart';
import 'package:core/src/utils/dicom_bytes/dicom_bytes_mixin.dart';
import 'package:core/src/utils/dicom_bytes/evr_bytes.dart';
import 'package:core/src/utils/dicom_bytes/ivr_bytes.dart';
import 'package:core/src/vr.dart';

/// A abstract subclass of [Bytes] that supports Explicit Value
/// Representations (EVR) and Implicit Value Representations (IVR).
abstract class DicomBytes extends Bytes with DicomBytesMixin {
  /// Creates an empty [DicomBytes].
  DicomBytes(int length, Endian endian) : super(length, endian);

  /// Creates a [DicomBytes] view of [bytes].
  factory DicomBytes.view(Bytes bytes, int vrIndex,
          {bool isEvr = true,
          int offset = 0,
          int end,
          Endian endian = Endian.little}) =>
      (!isEvr)
          ? IvrBytes.view(bytes, offset, end, endian)
          : (isEvrLongVR(vrIndex))
              ? EvrLongBytes.view(bytes, offset, end, endian)
              : EvrShortBytes.view(bytes, offset, end, endian);

  /// Creates a [DicomBytes] from a copy of [bytes].
  DicomBytes.from(Bytes bytes, int start, int end, Endian endian)
      : super.from(bytes, start, end, endian);

  /// __For internal use only__
  DicomBytes.internalView(Bytes bytes,
      [int offset = 0, int end, Endian endian = Endian.little])
      : super.view(bytes, offset, end, endian);

  /// Creates a new [Bytes] from a [TypedData] containing the specified
  /// region and [endian]ness.  [endian] defaults to [Endian.little].
  DicomBytes.typedDataView(TypedData td,
      [int offsetInBytes = 0, int lengthInBytes, Endian endian = Endian.little])
      : super.typedDataView(td, offsetInBytes, lengthInBytes, endian);

  /// Returns a [Bytes] containing the ASCII encoding of [s].
  factory DicomBytes.ascii(String s) {
    if (s == null) return null;
    return s.isEmpty ? kEmptyBytes : DicomBytes.typedDataView(cvt.ascii.encode(s));
  }

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  factory DicomBytes.utf8(String s) {
    if (s == null) return null;
    if (s.isEmpty) return kEmptyBytes;
    final Uint8List u8List = cvt.utf8.encode(s);
    return DicomBytes.typedDataView(u8List);
  }

  /// Returns [Bytes] containing the Latin character set encoding of [s];
  factory DicomBytes.latin(String s) {
    if (s == null) return null;
    if (s.isEmpty) return kEmptyBytes;
    final u8List = cvt.latin1.encode(s);
    return DicomBytes.typedDataView(u8List);
  }


  /// Returns a [Bytes] containing ASCII code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as ASCII, and returned as [Bytes].
  factory DicomBytes.asciiFromList(List<String> vList, [String separator = '\\']) =>
      DicomBytes.ascii(_listToString(vList, separator));

  /// Returns a [Bytes] containing UTF-8 code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as UTF-8 and returned as [Bytes].
  factory DicomBytes.utf8FromList(List<String> vList, [String separator = '\\']) =>
      DicomBytes.utf8(_listToString(vList, separator));

  /// Returns a [Bytes] containing Latin (1 - 9) code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as UTF-8, and returned as [Bytes].
  factory DicomBytes.latinFromList(List<String> vList, [String separator = '\\']) =>
      DicomBytes.latin(_listToString(vList, separator));

  /// Returns a [Bytes] containing [charset] code units.
  /// [charset] defaults to UTF8.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as UTF-8, and returned as [Bytes].
  factory DicomBytes.fromStringList(List<String> vList,
      {Ascii charset, String separator = '\\'}) =>
      DicomBytes.fromString(_listToString(vList, separator), charset ?? utf8);

  // TODO maxLength if for DICOM Value Field
  String _listToString(List<String> vList, String separator) {
    if (vList == null) return null;
    if (vList.isEmpty) return '';
    return vList.length == 1 ? vList[0] : vList.join(separator);
  }

  @override
  bool operator ==(Object other) =>
      (other is Bytes && ignorePadding && _bytesEqual(this, other)) ||
          __bytesEqual(this, other, ignorePadding);

  bool ignorePadding = true;

  @override
  String toString() {
    final vlf = vfLengthField;
    return '$runtimeType ${dcm(code)} $vrId($vrIndex, ${hex16(vrCode)}) '
        'vlf($vlf, ${hex32(vlf)}) vfl($vfLength) ${super.toString()}';
  }

  /// Returns [Bytes] containing the [charset] encoding of [s];
  static Bytes fromString(String s, [Charset charset = utf8]) {
    if (s == null) return null;
    if (s.isEmpty) return kEmptyBytes;
    return Bytes.typedDataView(charset.encode(s));
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
  static Bytes fromStringList(List<String> vList, {String separator = '\\'}) =>
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
bool checkVFLengthField(int vfLengthField, int vfLength) {
  if (vfLengthField != vfLength && vfLengthField != kUndefinedLength) {
//    log.warn('** vfLengthField($vfLengthField) != vfLength($vfLength)');
    if (vfLengthField == vfLength + 1) {
      log.debug('** vfLengthField: Odd length field: $vfLength');
      return true;
    }
    return false;
  }
  return true;
}

bool _bytesEqual(Bytes a, Bytes b) {
  final aLen = a.length;
  if (aLen != b.length) return false;
  for (var i = 0; i < aLen; i++) if (a[i] != b[i]) return false;
  return true;
}

// TODO: test performance of _uint16Equal and _uint32Equal
bool __bytesEqual(Bytes a, Bytes b, bool ignorePadding) {
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
bool _uint8Equal(Bytes a, Bytes b, bool ignorePadding) {
  for (var i = 0; i < a.length; i += 1) {
    final x = a.buf[i];
    final y = b.buf[i];
    if (x != y) return _bytesMaybeNotEqual(i, a, b, ignorePadding);
  }
  return true;
}

// Note: optimized to use 2 byte boundary
bool _uint16Equal(Bytes a, Bytes b, bool ignorePadding) {
  for (var i = 0; i < a.length; i += 2) {
    final x = a.getUint16(i);
    final y = b.getUint16(i);
    if (x != y) return _bytesMaybeNotEqual(i, a, b, ignorePadding);
  }
  return true;
}

// Note: optimized to use 4 byte boundary
bool _uint32Equal(Bytes a, Bytes b, bool ignorePadding) {
  for (var i = 0; i < a.length; i += 4) {
    final x = a.getUint32(i);
    final y = b.getUint32(i);
    if (x != y) return _bytesMaybeNotEqual(i, a, b, ignorePadding);
  }
  return true;
}

bool _bytesMaybeNotEqual(int i, Bytes a, Bytes b, bool ignorePadding) {
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
      '    ${a.stringFromAscii()}')
      '    ${b.stringFromAscii()}');
''');
}
