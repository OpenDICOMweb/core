//  Copyright (c) 2016, 2017, 2018
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
library odw.sdk.utils.bytes;

import 'dart:collection';
import 'dart:convert' as cvt;
import 'dart:io';
import 'dart:typed_data';

import 'package:core/src/system.dart';
import 'package:core/src/utils.dart';

part 'package:core/src/utils/bytes/bytes_mixin.dart';
part 'package:core/src/utils/bytes/growable_bytes.dart';

// ignore_for_file: public_member_api_docs

/// Bytes Package Overview
///
/// - All get_XXX_List methods return fixed length (unmodifiable) Lists.
/// - All asXXX methods return a view of the specified region.

bool ignorePadding = true;

/// [Bytes] is a class that provides a read-only byte array that supports both
/// [Uint8List] and [ByteData] interfaces.
class Bytes extends ListBase<int> with BytesMixin implements Comparable<Bytes> {
  @override
  Uint8List _buf;
  ByteData __bd;
  @override
  Endian endian;

  @override
  ByteData get _bd => __bd ??= _buf.buffer.asByteData(_buf.offsetInBytes);

  ByteData get bd => _bd;


  /// Creates a new [Bytes] containing [length] zero elements.
  /// [length] defaults to [kDefaultLength] and [endian] defaults
  /// to [Endian.host].
  Bytes([int length = kDefaultLength, Endian endian])
      : endian = endian ?? Endian.host,
        _buf = Uint8List(length ?? k1MB);

  Bytes.view(Bytes bytes, [int offset = 0, int length, Endian endian])
      : endian = endian ?? Endian.host,
        _buf = _bytesView(bytes._buf, offset, length ?? bytes.length);

  /// Creates a new [Bytes] from [bytes] containing the specified region
  /// and [endian]ness. [endian] defaults to [Endian.host].
  Bytes.from(Bytes bytes, [int offset = 0, int length, Endian endian])
      : endian = endian ?? Endian.host,
        _buf = _copyBytes(bytes._buf, offset, length ?? bytes.length);

  /// Creates a new [Bytes] from [bd]. [endian] defaults to [Endian.host].
  Bytes.fromByteData(ByteData bd, [Endian endian])
      : endian = endian ?? Endian.host,
        _buf = bd.buffer.asUint8List(bd.offsetInBytes);

  /// Creates a new [Bytes] from a [TypedData] containing the specified
  /// region and [endian]ness.  [endian] defaults to [Endian.host].
  Bytes.typedDataView(TypedData td,
      [int offsetInBytes = 0, int lengthInBytes, Endian endian])
      : endian = endian ?? Endian.host,
        _buf = td.buffer.asUint8List(td.offsetInBytes + offsetInBytes,
            lengthInBytes ?? td.lengthInBytes);

  /// Creates a new [Bytes] from a [List<int>].  [endian] defaults
  /// to [Endian.host]. Any values in [list] that are larger than 8-bits
  /// are truncated.
  Bytes.fromList(List<int> list, [Endian endian])
      : endian = endian ?? Endian.host,
        _buf = (list is Uint8List) ? list : Uint8List.fromList(list);

  // TODO: Either remove fromFile and fromPath or add doAsync

  /// Returns a [Bytes] buffer containing the contents of [File].
  factory Bytes.fromFile(File file,
      {Endian endian = Endian.little, bool doAsync = false}) {
    final Uint8List bList = doAsync ? file.readAsBytes : file.readAsBytesSync();
    return Bytes.typedDataView(bList, 0, bList.length, endian ?? Endian.little);
  }

  /// Returns a [Bytes] buffer containing the contents of the
  /// [File] at [path].
  factory Bytes.fromPath(String path,
          {Endian endian = Endian.little, bool doAsync = false}) =>
      Bytes.fromFile(File(path), endian: endian, doAsync: doAsync);

  /// Returns a [Bytes] containing the Base64 decoding of [s].
  factory Bytes.fromBase64(String s, {bool padToEvenLength = false}) {
    if (s.isEmpty) return kEmptyBytes;
    var bList = cvt.base64.decode(s);
    final bLength = bList.length;
    if (padToEvenLength == true && bLength.isOdd) {
      // Performance: It would be good to ignore this copy
      final nList = Uint8List(bLength + 1);
      for (var i = 0; i < bLength - 1; i++) nList[i] = bList[i];
      nList[bLength] = 0;
      bList = nList;
    }
    return Bytes.typedDataView(bList);
  }

  /// Returns a [Bytes] containing the ASCII encoding of [s].
  factory Bytes.ascii(String s) {
    if (s == null) return nullValueError(s);
    return s.isEmpty ? kEmptyBytes : Bytes.typedDataView(cvt.ascii.encode(s));
  }

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  factory Bytes.utf8(String s) {
    if (s == null) return nullValueError(s);
    if (s.isEmpty) return kEmptyBytes;
    final Uint8List u8List = cvt.utf8.encode(s);
    return Bytes.typedDataView(u8List);
  }

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  factory Bytes.latin(String s) {
    if (s == null) return nullValueError(s);
    if (s.isEmpty) return kEmptyBytes;
    final u8List = cvt.latin1.encode(s);
    return Bytes.typedDataView(u8List);
  }

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  factory Bytes.fromString(String s, Ascii charset) {
    charset ??= utf8;
    if (s == null) return nullValueError(s);
    if (s.isEmpty) return kEmptyBytes;
    return Bytes.typedDataView(charset.encode(s));
  }

  /// Returns a [Bytes] containing ASCII code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as ASCII. The result is returns as [Bytes].
  factory Bytes.asciiFromList(List<String> vList,
          [int maxLength, String separator = '\\']) =>
      Bytes.ascii(_listToString(vList, maxLength, separator));

  /// Returns a [Bytes] containing UTF-8 code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as UTF-8. The result is returns as [Bytes].
  factory Bytes.utf8FromList(List<String> vList,
          [int maxLength, String separator = '\\']) =>
      Bytes.utf8(_listToString(vList, maxLength, separator));

  /// Returns a [Bytes] containing Latin (1 - 9) code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as UTF-8. The result is returns as [Bytes].
  factory Bytes.latinFromList(List<String> vList,
          [int maxLength, String separator = '\\']) =>
      Bytes.latin(_listToString(vList, maxLength, separator));

  /// Returns a [Bytes] containing [charset] code units.
  /// [charset] defaults to UTF8.
  factory Bytes.fromStringList(List<String> vList,
          {Ascii charset, int maxLength, String separator = '\\'}) =>
      Bytes.fromString(
          _listToString(vList, maxLength, separator), charset ?? utf8);

  // *** Comparable interface

  /// Compares _this_ with [other] byte by byte.
  /// Returns a negative integer if _this_ is ordered before other, a
  /// positive integer if _this_ is ordered after other, and zero if
  /// _this_ and other are equal.
  ///
  /// Returns -2 _this_ is a proper prefix of [other], and +2 if [other]
  /// is a proper prefix of _this_.
  @override
  int compareTo(Bytes other) {
    final minLength = (length < other.length) ? length : other.length;
    for (var i = 0; i < minLength; i++) {
      final a = this[i];
      final b = other[i];
      if (a == b) continue;
      return (a < b) ? -1 : 1;
    }
    return (length < other.length) ? -2 : 2;
  }

  // *** List interface

  @override
  int operator [](int i) => _buf[i];
  @override
  void operator []=(int i, int v) => _buf[i] = v;

  @override
  bool operator ==(Object other) =>
      (other is Bytes && ignorePadding && _bytesEqual(this, other)) ||
      __bytesEqual(this, other, ignorePadding);

  @override
  int get hashCode {
    var hashCode = 0;
    for (var i = 0; i < bdLength; i++) hashCode += _buf[i] + i;
    return hashCode;
  }

  static const int kMinLength = 16;
  static const int kDefaultLength = 1024;

  /// The canonical empty (zero length) [Bytes] object.
  static final Bytes kEmptyBytes = Bytes(0);

  static String _listToString(
      List<String> vList, int maxLength, String separator) {
    if (vList == null) return nullValueError();
    final s = stringListToString(vList, separator);
    if (s == null || s.length > (maxLength ?? s.length)) return null;
    return s.isEmpty ? '' : s;
  }
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
    final x = a._buf[i];
    final y = b._buf[i];
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
    if (throwOnError) if (errorCount > 3) throw ArgumentError('Unequal');
    return false;
  }
  return true;
}

bool __bytesMaybeNotEqual(int i, Bytes a, Bytes b, bool ignorePadding) {
  if ((a[i] == 0 && b[i] == 32) || (a[i] == 32 && b[i] == 0)) {
    log.warn('$i ${a[i]} | ${b[i]} Padding char difference');
    return ignorePadding;
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
	  "${String.fromCharCode(x)}" | "${String.fromCharCode(y)}"
	    '    $a')
      '    $b')
      '    ${a.stringFromAscii()}')
      '    ${b.stringFromAscii()}');
''');
}

//TODO: move this to the appropriate place
/// Returns a [ByteData] that is a copy of the specified region of _this_.
Uint8List _copyBytes(Uint8List list, int offset, int length) {
  final _length = length ?? list.lengthInBytes;
  final list1 = Uint8List(_length);
  for (var i = 0, j = offset; i < _length; i++, j++) list1[i] = list[j];
  return list1;
}

//TODO: move this to the appropriate place
/// Returns a [ByteData] that is a copy of the specified region of _this_.
Uint8List _bytesView(Uint8List list, int offset, int end) {
  final _offset = list.offsetInBytes + offset;
  final _length = (end ?? list.lengthInBytes) - _offset;
  return list.buffer.asUint8List(_offset, _length);
}
