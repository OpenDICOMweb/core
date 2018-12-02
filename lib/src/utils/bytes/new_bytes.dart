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
import 'package:core/src/utils/character/charset.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/utils/string/string_lists.dart';
import 'package:core/src/utils/bytes/little_endian_mixin.dart';
import 'package:core/src/utils/bytes/big_endian_mixin.dart';
import 'package:core/src/utils/bytes/bytes_mixin.dart';

// ignore_for_file: public_member_api_docs

/// Bytes Package Overview
///
/// - All get_XXX_List methods return fixed length (unmodifiable) Lists.
/// - All asXXX methods return a view of the specified region.

bool ignorePadding = true;

/// [Bytes] is a class that provides a read-only byte array that supports both
/// [Uint8List] and [ByteData] interfaces.
abstract class Bytes extends ListBase<int>
    with ByteDataMixin
    implements Comparable<Bytes> {
  @override
  ByteData bd;
  Endian get endian;
  @override
  String get endianness;

  /// Creates a new [Bytes] containing [length] zero elements.
  /// [length] defaults to [kDefaultLength] and [endian] defaults
  /// to [Endian.host].
  factory Bytes([int length = kDefaultLength, Endian endian = Endian.little]) {
    endian ??= Endian.host;
    return endian == Endian.big ? BytesBE(length) : BytesLE(length);
  }

  Bytes.internal(this.bd);

  factory Bytes.view(Bytes bytes, [int offset = 0, int length, Endian endian]) {
    endian = endian ?? bytes.endian;
    return endian == Endian.big
        ? BytesBE.view(bytes, offset, length)
        : BytesLE.view(bytes, offset, length);
  }

  /// Creates a new [Bytes] from [bytes] containing the specified region
  /// and [endian]ness. [endian] defaults to [Endian.host].
  factory Bytes.from(Bytes bytes, [int offset = 0, int length, Endian endian]) {
    final bd = _copyByteData(bytes.bd, offset, length ?? bytes.length);
    return endian == Endian.big
        ? BytesBE.fromByteData(bd)
        : BytesLE.fromByteData(bd);
  }

  /// Creates a new [Bytes] from [bd]. [endian] defaults to [Endian.host].
  factory Bytes.fromByteData(ByteData bd, [Endian endian]) =>
      endian == Endian.big
          ? BytesBE.fromByteData(bd)
          : BytesLE.fromByteData(bd);

  /// Creates a new [Bytes] from a [TypedData] containing the specified
  /// region and [endian]ness.  [endian] defaults to [Endian.host].
  static Bytes typedDataView(TypedData td,
      [int offsetInBytes = 0, int lengthInBytes, Endian endian]) {
    final bd = td.buffer.asByteData(
        td.offsetInBytes + offsetInBytes, lengthInBytes ?? td.lengthInBytes);
    return endian == Endian.big
        ? BytesBE.fromByteData(bd)
        : BytesLE.fromByteData(bd);
  }

  /// Creates a new [Bytes] from a [List<int>].  [endian] defaults
  /// to [Endian.host]. Any values in [list] that are larger than 8-bits
  /// are truncated.
  static Bytes fromList(List<int> list, [Endian endian]) {
    final bd = (list is Uint8List)
        ? list.buffer.asByteData()
        : Uint8List.fromList(list).buffer.asByteData();
    return endian == Endian.big
        ? BytesBE.fromByteData(bd)
        : BytesLE.fromByteData(bd);
  }

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
  factory Bytes.fromString(String s, Charset charset) {
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
          {Charset charset, int maxLength, String separator = '\\'}) =>
      Bytes.fromString(
          _listToString(vList, maxLength, separator), charset ?? utf8);

  // **** TypedData interface.
  int get elementSizeInBytes => 1;

  int get offset => bd.offsetInBytes;

  int get limit => length;

  ByteBuffer get buffer => bd.buffer;

  // *** List interface

  @override
  int operator [](int i) => bd.getUint8(i);
  @override
  void operator []=(int i, int v) => bd.setUint8(i, v);

  @override
  bool operator ==(Object other) =>
      (other is Bytes && ignorePadding && _bytesEqual(this, other)) ||
      __bytesEqual(this, other, ignorePadding);

  @override
  int get hashCode {
    var hashCode = 0;
    for (var i = 0; i < length; i++) hashCode += getUint8(i) + i;
    return hashCode;
  }

  @override
  int get length => bd.lengthInBytes;
  @override
  set length(int length) =>
      throw UnsupportedError('$runtimeType: length is not modifiable');
  @override
  int getUint8(int offset) => bd.getUint8(offset);
  @override
  void setUint8(int offset, int value) => bd.setUint8(offset, value);

  /// Returns an 8-bit integer values at [offset].
  @override
  int getInt8(int offset) => bd.getInt8(offset);
  @override
  void setInt8(int offset, int value) => bd.setInt8(offset, value);

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

  static const int kMinLength = 16;
  static const int kDefaultLength = 1024;
  static const int kDefaultLimit = k1GB;

  /// The canonical empty (zero length) [Bytes] object.
  static final Bytes kEmptyBytes = Bytes(0);
}

/// [BytesLE] is a class that provides a read-only Little Endian byte array
/// that supports both [Uint8List] and [ByteData] interfaces.
class BytesLE extends Bytes
    with LittleEndianMixin
    implements Comparable<Bytes> {
  /// Creates a new [Bytes] containing [length] zero elements.
  /// [length] defaults to [Bytes.kDefaultLength].
  BytesLE([int length = Bytes.kDefaultLength])
      : super.internal(ByteData(length));

  BytesLE.view(Bytes bytes, [int offset = 0, int length])
      : super.internal(_bdView(bytes.bd, offset, length ?? bytes.length));

  /// Creates a new [Bytes] from [bytes] containing the specified region.
  BytesLE.from(Bytes bytes, [int offset = 0, int length])
      : super.internal(_copyByteData(bytes.bd, offset, length ?? bytes.length));

  /// Creates a new [Bytes] from [bd].
  BytesLE.fromByteData(ByteData bd) : super.internal(bd);

  /// Creates a new [Bytes] from a [TypedData] containing the specified
  /// region and [endian]ness.
  BytesLE.typedDataView(TypedData td,
      [int offsetInBytes = 0, int lengthInBytes])
      : super.internal(td.buffer.asByteData(td.offsetInBytes + offsetInBytes,
            lengthInBytes ?? td.lengthInBytes));

  /// Creates a new [Bytes] from a [List<int>]. Any values in [list]
  /// that are larger than 8-bits are truncated.
  BytesLE.fromList(List<int> list)
      : super.internal(list is Uint8List
            ? list.buffer.asByteData()
            : Uint8List.fromList(list).buffer.asByteData());

  // TODO: Either remove fromFile and fromPath or add doAsync

  /// Returns a [Bytes] buffer containing the contents of [File].
  factory BytesLE.fromFile(File file, {bool doAsync = false}) {
    final Uint8List bList = doAsync ? file.readAsBytes : file.readAsBytesSync();
    return BytesLE.typedDataView(bList, 0, bList.length);
  }

  /// Returns a [Bytes] buffer containing the contents of the
  /// [File] at [path].
  factory BytesLE.fromPath(String path, {bool doAsync = false}) =>
      BytesLE.fromFile(File(path), doAsync: doAsync);

  /// Returns a [Bytes] containing the Base64 decoding of [s].
  factory BytesLE.fromBase64(String s, {bool padToEvenLength = false}) {
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
    return BytesLE.typedDataView(bList);
  }

  /// Returns a [Bytes] containing the ASCII encoding of [s].
  factory BytesLE.ascii(String s) {
    if (s == null) return nullValueError(s);
    return s.isEmpty ? kEmptyBytes : BytesLE.typedDataView(cvt.ascii.encode(s));
  }

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  factory BytesLE.utf8(String s) {
    if (s == null) return nullValueError(s);
    if (s.isEmpty) return kEmptyBytes;
    final Uint8List u8List = cvt.utf8.encode(s);
    return BytesLE.typedDataView(u8List);
  }

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  factory BytesLE.latin(String s) {
    if (s == null) return nullValueError(s);
    if (s.isEmpty) return kEmptyBytes;
    final u8List = cvt.latin1.encode(s);
    return BytesLE.typedDataView(u8List);
  }

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  factory BytesLE.fromString(String s, Charset charset) {
    charset ??= utf8;
    if (s == null) return nullValueError(s);
    if (s.isEmpty) return kEmptyBytes;
    return BytesLE.typedDataView(charset.encode(s));
  }

  /// Returns a [Bytes] containing ASCII code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as ASCII. The result is returns as [Bytes].
  factory BytesLE.asciiFromList(List<String> vList,
          [int maxLength, String separator = '\\']) =>
      BytesLE.ascii(_listToString(vList, maxLength, separator));

  /// Returns a [Bytes] containing UTF-8 code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as UTF-8. The result is returns as [Bytes].
  factory BytesLE.utf8FromList(List<String> vList,
          [int maxLength, String separator = '\\']) =>
      BytesLE.utf8(_listToString(vList, maxLength, separator));

  /// Returns a [Bytes] containing Latin (1 - 9) code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as UTF-8. The result is returns as [Bytes].
  factory BytesLE.latinFromList(List<String> vList,
          [int maxLength, String separator = '\\']) =>
      BytesLE.latin(_listToString(vList, maxLength, separator));

  /// Returns a [Bytes] containing [charset] code units.
  /// [charset] defaults to UTF8.
  factory BytesLE.fromStringList(List<String> vList,
          {Charset charset, int maxLength, String separator = '\\'}) =>
      BytesLE.fromString(
          _listToString(vList, maxLength, separator), charset ?? utf8);

  /// The canonical empty (zero length) [Bytes] object.
  static final BytesLE kEmptyBytes = BytesLE(0);
}

/// [BytesBE] is a class that provides a read-only Little Endian byte array
/// that supports both [Uint8List] and [ByteData] interfaces.
class BytesBE extends Bytes with BigEndianMixin implements Comparable<Bytes> {
  /// Creates a new [Bytes] containing [length] zero elements.
  /// [length] defaults to [Bytes.kDefaultLength].
  BytesBE([int length = Bytes.kDefaultLength])
      : super.internal(ByteData(length));

  /// Creates a new [Bytes] containing [length] zero elements.
  /// [length] defaults to [Bytes.kDefaultLength].
//  BytesBE._(int length) : super.internal(ByteData(length));

  BytesBE.view(Bytes bytes, [int offset = 0, int length])
      : super.internal(_bdView(bytes.bd, offset, length ?? bytes.length));

  /// Creates a new [Bytes] from [bytes] containing the specified region.
  BytesBE.from(Bytes bytes, [int offset = 0, int length])
      : super.internal(_copyByteData(bytes.bd, offset, length ?? bytes.length));

  /// Creates a new [Bytes] from [bd].
  BytesBE.fromByteData(ByteData bd) : super.internal(bd);

  /// Creates a new [Bytes] from a [TypedData] containing the specified
  /// region and [endian]ness.
  BytesBE.typedDataView(TypedData td,
      [int offsetInBytes = 0, int lengthInBytes])
      : super.internal(td.buffer.asByteData(td.offsetInBytes + offsetInBytes,
            lengthInBytes ?? td.lengthInBytes));

  /// Creates a new [Bytes] from a [List<int>]. Any values in [list]
  /// that are larger than 8-bits are truncated.
  BytesBE.fromList(List<int> list)
      : super.internal(list is Uint8List
            ? list.buffer.asByteData()
            : Uint8List.fromList(list).buffer.asByteData());

  // TODO: Either remove fromFile and fromPath or add doAsync

  /// Returns a [Bytes] buffer containing the contents of [File].
  factory BytesBE.fromFile(File file, {bool doAsync = false}) {
    final Uint8List bList = doAsync ? file.readAsBytes : file.readAsBytesSync();
    return BytesBE.typedDataView(bList, 0, bList.length);
  }

  /// Returns a [Bytes] buffer containing the contents of the
  /// [File] at [path].
  factory BytesBE.fromPath(String path, {bool doAsync = false}) =>
      BytesBE.fromFile(File(path), doAsync: doAsync);

  /// Returns a [Bytes] containing the Base64 decoding of [s].
  factory BytesBE.fromBase64(String s, {bool padToEvenLength = false}) {
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
    return BytesBE.typedDataView(bList);
  }

  /// Returns a [Bytes] containing the ASCII encoding of [s].
  factory BytesBE.ascii(String s) {
    if (s == null) return nullValueError(s);
    return s.isEmpty ? kEmptyBytes : BytesBE.typedDataView(cvt.ascii.encode(s));
  }

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  factory BytesBE.utf8(String s) {
    if (s == null) return nullValueError(s);
    if (s.isEmpty) return kEmptyBytes;
    final Uint8List u8List = cvt.utf8.encode(s);
    return BytesBE.typedDataView(u8List);
  }

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  factory BytesBE.latin(String s) {
    if (s == null) return nullValueError(s);
    if (s.isEmpty) return kEmptyBytes;
    final u8List = cvt.latin1.encode(s);
    return BytesBE.typedDataView(u8List);
  }

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  factory BytesBE.fromString(String s, Charset charset) {
    charset ??= utf8;
    if (s == null) return nullValueError(s);
    if (s.isEmpty) return kEmptyBytes;
    return BytesBE.typedDataView(charset.encode(s));
  }

  /// Returns a [Bytes] containing ASCII code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as ASCII. The result is returns as [Bytes].
  factory BytesBE.asciiFromList(List<String> vList,
          [int maxLength, String separator = '\\']) =>
      BytesBE.ascii(_listToString(vList, maxLength, separator));

  /// Returns a [Bytes] containing UTF-8 code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as UTF-8. The result is returns as [Bytes].
  factory BytesBE.utf8FromList(List<String> vList,
          [int maxLength, String separator = '\\']) =>
      BytesBE.utf8(_listToString(vList, maxLength, separator));

  /// Returns a [Bytes] containing Latin (1 - 9) code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as UTF-8. The result is returns as [Bytes].
  factory BytesBE.latinFromList(List<String> vList,
          [int maxLength, String separator = '\\']) =>
      BytesBE.latin(_listToString(vList, maxLength, separator));

  /// Returns a [Bytes] containing [charset] code units.
  /// [charset] defaults to UTF8.
  factory BytesBE.fromStringList(List<String> vList,
          {Charset charset, int maxLength, String separator = '\\'}) =>
      BytesBE.fromString(
          _listToString(vList, maxLength, separator), charset ?? utf8);

  /// The canonical empty (zero length) [Bytes] object.
  static final BytesBE kEmptyBytes = BytesBE(0);
}

String _listToString(List<String> vList, int maxLength, String separator) {
  if (vList == null) return nullValueError();
  final s = stringListToString(vList, separator);
  if (s == null || s.length > (maxLength ?? s.length)) return null;
  return s.isEmpty ? '' : s;
}

//TODO: move this to the appropriate place
/// Returns a [ByteData] that is a copy of the specified region of _this_.
ByteData _copyByteData(ByteData bd, int offset, int length) {
  final _length = length ?? bd.lengthInBytes;
  final bdNew = ByteData(_length);
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
    final x = a.getUint8(i);
    final y = b.getUint8(i);
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
