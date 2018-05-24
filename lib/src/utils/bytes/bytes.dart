//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
library odw.sdk.utils.bytes;

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:core/src/system.dart';
import 'package:core/src/utils/bytes/primitives.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/utils/string.dart';
import 'package:core/src/vr.dart';

part 'package:core/src/utils/bytes/bytes_mixin.dart';
part 'package:core/src/utils/bytes/dicom_bytes.dart';
part 'package:core/src/utils/bytes/dicom_mixin.dart';
part 'package:core/src/utils/bytes/evr.dart';
part 'package:core/src/utils/bytes/growable.dart';
part 'package:core/src/utils/bytes/ivr.dart';

/// Bytes Package Overview
///
/// - All get_XXX_List methods return fixed length (unmodifiable) Lists.
/// - All asXXX methods return a view of the specified region.

bool ignorePadding = true;

/// [Bytes] is a class that provides a read-only byte array that supports both
/// [Uint8List] and [ByteData] interfaces.
class Bytes extends ListBase<int> with BytesMixin {
  @override
  ByteData _bd;
  @override
  Endian endian;

  /// Creates a new [Bytes] containing [length] zero elements.
  /// [length] defaults to [kDefaultLength] and [endian] defaults
  /// to [Endian.host].
  Bytes([int length = kDefaultLength, Endian endian])
      : endian = endian ?? Endian.host,
        _bd = new ByteData(length);

  Bytes._(int length, Endian endian)
      : endian = endian ?? Endian.host,
        _bd = new ByteData(length);

  factory Bytes.view(Bytes bytes,
          [int offset = 0, int length, Endian endian]) =>
      new Bytes._view(bytes, offset, length, endian);

  Bytes._view(Bytes bytes, int offset, int end, Endian endian)
      : endian = endian ?? Endian.host,
        _bd = _bdView(bytes._bd, offset, end);

  /// Creates a new [Bytes] from [bytes] containing the specified region
  /// and [endian]ness. [endian] defaults to [Endian.host].
  factory Bytes.from(Bytes bytes,
          [int offset = 0, int length, Endian endian]) =>
      new Bytes._from(bytes, offset, length, endian);

  Bytes._from(Bytes bytes, int offset, int end, Endian endian)
      : endian = endian ?? Endian.host,
        _bd = _copyByteData(bytes._bd, offset, end ?? bytes.length);

  /// Creates a new [Bytes] from [bd]. [endian] defaults to [Endian.host].
  Bytes.fromByteData(ByteData bd, [Endian endian])
      : endian = endian ?? Endian.host,
        _bd = bd;

  /// Creates a new [Bytes] from a [TypedData] containing the specified
  /// region and [endian]ness.  [endian] defaults to [Endian.host].
  factory Bytes.typedDataView(TypedData td,
          [int offsetInBytes = 0, int lengthInBytes, Endian endian]) =>
      new Bytes._tdView(td, offsetInBytes, lengthInBytes, endian);

  Bytes._tdView(
      TypedData td, int offsetInBytes, int lengthInBytes, Endian endian)
      : endian = endian ?? Endian.host,
        _bd = td.buffer.asByteData(td.offsetInBytes + offsetInBytes,
            lengthInBytes ?? td.lengthInBytes);

  /// Creates a new [Bytes] from a [List<int>].  [endian] defaults
  /// to [Endian.host]. Any values in [list] that are larger than 8-bits
  /// are truncated.
  Bytes.fromList(List<int> list, [Endian endian])
      : endian = endian ?? Endian.host,
        _bd = (list is Uint8List)
            ? list.buffer.asByteData()
            : (new Uint8List.fromList(list)).buffer.asByteData();

  // *** List interface

  @override
  int operator [](int i) => _getUint8(i);
  @override
  void operator []=(int i, int v) => _setUint8(i, v);

  @override
  bool operator ==(Object other) => (other is Bytes)
      ? (ignorePadding)
          ? _bytesEqual(this, other)
          : __bytesEqual(this, other, ignorePadding)
      : false;

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
      final x = a._getUint8(i);
      final y = b._getUint8(i);
      if (x != y) return _bytesMaybeNotEqual(i, a, b, ignorePadding);
    }
    return true;
  }

  // Note: optimized to use 2 byte boundary
  bool _uint16Equal(Bytes a, Bytes b, bool ignorePadding) {
    for (var i = 0; i < a.length; i += 2) {
      final x = a._getUint16(i);
      final y = b._getUint16(i);
      if (x != y) return _bytesMaybeNotEqual(i, a, b, ignorePadding);
    }
    return true;
  }

// Note: optimized to use 4 byte boundary
  bool _uint32Equal(Bytes a, Bytes b, bool ignorePadding) {
    for (var i = 0; i < a.length; i += 4) {
      final x = a._getUint32(i);
      final y = b._getUint32(i);
      if (x != y) return _bytesMaybeNotEqual(i, a, b, ignorePadding);
    }
    return true;
  }

  bool _bytesMaybeNotEqual(int i, Bytes a, Bytes b, bool ignorePadding) {
    var errorCount = 0;
    final ok = __bytesMaybeNotEqual(i, a, b, ignorePadding);
    if (!ok) {
      errorCount++;
      if (throwOnError) if (errorCount > 3) throw new ArgumentError('Unequal');
      return false;
    }
    return true;
  }

  bool __bytesMaybeNotEqual(int i, Bytes a, Bytes b, bool ignorePadding) {
    if ((a[i] == 0 && b[i] == 32) || (a[i] == 32 && b[i] == 0)) {
      log.warn('$i ${a[i]} | ${b[i]} Padding char difference');
      return (ignorePadding) ? true : false;
    } else {
      _warnBytes(i, a, b);
      return false;
    }
  }

  void _warnBytes(int i, Bytes a, Bytes b) {
    final x = a[i];
    final y = b[i];
    log.warn('''
$i: $x | $y')
	  ${hex8(x)} | ${hex8(y)}
	  "${new String.fromCharCode(x)}" | "${new String.fromCharCode(y)}"
	    '    $a')
      '    $b')
      '    ${a.getAscii()}')
      '    ${b.getAscii()}');
''');
  }

  @override
  int get hashCode {
    var hashCode = 0;
    for (var i = 0; i < _bdLength; i++) hashCode += _getUint8(i) + i;
    return hashCode;
  }

  // **** Dicom extensions - these should go away when DicomBytes works
  int get code {
    final group = _getUint16(0);
    final elt = _getUint16(2);
    return (group << 16) + elt;
  }

  int get vrCode => _getUint16(4);

  int get vrIndex => vrIndexByCode[vrCode];
  // **** End of DIcom extensions.

  static const int kMinLength = 16;
  static const int kDefaultLength = 1024;

  // TODO: Either remove fromFile and fromPath or add doAsync
  /// Returns a [Bytes] buffer containing the contents of [File].
  static Bytes fromFile(File file,
      {Endian endian = Endian.little, bool doAsync = false}) {
    final Uint8List bList = file.readAsBytesSync();
    return new Bytes.typedDataView(
        bList, 0, bList.length, endian ?? Endian.little);
  }

  /// Returns a [Bytes] buffer containing the contents of the
  /// [File] at [path].
  static Bytes fromPath(String path,
          {Endian endian = Endian.little, bool doAsync = false}) =>
      fromFile(new File(path), endian: endian, doAsync: doAsync);

  /// The canonical empty (zero length) [Bytes] object.
  static final Bytes kEmptyBytes = new Bytes(0);

  /// Returns a [Bytes] containing the Base64 decoding of [s].
  static Bytes fromBase64(String s) =>
      (s.isEmpty) ? kEmptyBytes : new Bytes.typedDataView(base64.decode(s));

  /// Returns a [Bytes] containing the ASCII encoding of [s].
  static Bytes fromAscii(String s) =>
      (s.isEmpty) ? kEmptyBytes : new Bytes.typedDataView(ascii.encode(s));

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  static Bytes fromUtf8(String s) {
    if (s.isEmpty) return kEmptyBytes;
    final Uint8List u8List = utf8.encode(s);
    return new Bytes.typedDataView(u8List);
  }

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  static Bytes fromString(String s, {bool isAscii: false}) {
    if (s.isEmpty) return kEmptyBytes;
    return (isAscii) ? fromAscii(s) : fromUtf8(s);
  }

  /// Returns a [Bytes] containing ASCII code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as ASCII. The result is returns as [Bytes].
  static Bytes fromAsciiList(List<String> vList,
          [int maxLength, String separator = '\\']) =>
      _fromList(vList, maxLength, separator, fromAscii);

  /// Returns a [Bytes] containing UTF-8 code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as UTF-8. The result is returns as [Bytes].
  static Bytes fromUtf8List(List<String> vList,
          [int maxLength, String separator = '\\']) =>
      _fromList(vList, maxLength, separator, fromUtf8);

  static Bytes _fromList(List<String> vList, int maxLength, String separator,
      Bytes encoder(String s)) {
    if (vList == null) return nullValueError();
    final s = stringListToString(vList, separator);
    if (s == null || s.length > (maxLength ?? s.length)) return null;
    return (s.isEmpty) ? kEmptyBytes : encoder(vList.join('\\'));
  }

  /// Returns a [Bytes] containing UTF-8 code units. See [fromUtf8List].
  static Bytes fromStrings(List<String> vList,
          {int maxLength, bool isAscii = false, String separator = '\\'}) =>
      (isAscii)
          ? fromAsciiList(vList, maxLength, separator)
          : fromUtf8List(vList, maxLength, separator);
}

//TODO: move this to the appropriate place
/// Returns a [ByteData] that is a copy of the specified region of _this_.
ByteData _copyByteData(ByteData bd, int offset, int length) {
  final _length = length ?? bd.lengthInBytes;
  final bdNew = new ByteData(_length);
  for (var i = 0, j = offset; i < _length; i++, j++)
    bdNew.setUint8(i, bd.getUint8(j));
  return bdNew;
}

//TODO: move this to the appropriate place
/// Returns a [ByteData] that is a copy of the specified region of _this_.
ByteData _bdView(ByteData bd, int offset, int end) {
  final _offset = bd.offsetInBytes + offset;
  final _length = (end ?? bd.lengthInBytes) - _offset;
  return bd.buffer.asByteData(_offset, _length);
}
