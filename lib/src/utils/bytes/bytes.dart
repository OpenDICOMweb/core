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
import 'package:core/src/utils/bytes/bytes_mixin.dart';
import 'package:core/src/utils/bytes/little_endian_mixin.dart';
import 'package:core/src/utils/bytes/big_endian_mixin.dart';

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
  ByteData _bd;

  Bytes(this.bd);

  Endian get endian => unimplementedError();
  @override
  String get endianness => unimplementedError();

  @override
  int getInt16(int offset) => unimplementedError();
  @override
  int getInt32(int offset) => unimplementedError();
  @override
  int getInt64(int offset) => unimplementedError();
  @override
  int getUint16(int offset) => unimplementedError();
  @override
  int getUint32(int offset) => unimplementedError();
  @override
  int getUint64(int offset) => unimplementedError();

  @override
  double getFloat32(int offset) => unimplementedError();
  @override
  double getFloat64(int offset) => unimplementedError();

  @override
  void setInt16(int offset, int value) => unimplementedError();
  @override
  void setInt32(int offset, int value) => unimplementedError();
  @override
  void setInt64(int offset, int value) => unimplementedError();

  @override
  void setUint16(int offset, int value) => unimplementedError();
  @override
  void setUint32(int offset, int value) => unimplementedError();
  @override
  void setUint64(int offset, int value) => unimplementedError();

  @override
  void setFloat32(int offset, double value) => unimplementedError();
  @override
  void setFloat64(int offset, double value) => unimplementedError();

  /// Returns an [ByteData] view of the specified region of _this_.
  ByteData _viewOfBDRegion([int offset = 0, int length]) {
    length ??= this.length - offset;
    return bd.buffer.asByteData(_absIndex(offset), length);
  }

  /// Returns a view of the specified region of _this_.
  Bytes asBytes([int offset = 0, int length]) {
    final bd = _viewOfBDRegion(offset, length);
    return Bytes(bd);
  }

  /// Creates an [ByteData] view of the specified region of _this_.
  ByteData asByteData([int offset = 0, int length]) =>
      _viewOfBDRegion(offset, (length ??= length) - offset);

  /// Creates a new [Bytes] containing [length] zero elements.
  /// [length] defaults to [kDefaultLength] and [endian] defaults
  /// to [Endian.host].
  static Bytes make(
          [int length = kDefaultLength, Endian endian = Endian.little]) =>
      endian == Endian.big ? BytesBE(length) : BytesLE(length);

  /// Creates a new [Bytes] from [bytes] containing the specified region
  /// and [endian]ness. [endian] defaults to [Endian.host].
  static Bytes from(Bytes bytes, [int offset = 0, int length, Endian endian]) {
    final bd = _copyByteData(bytes.bd, offset, length ?? bytes.length);
    return endian == Endian.big
        ? BytesBE.fromByteData(bd)
        : BytesLE.fromByteData(bd);
  }

  static Bytes view(Bytes bytes,
          [int offset = 0, int length, Endian endian = Endian.little]) =>
      endian == Endian.big
          ? BytesBE.view(bytes, offset, length)
          : BytesLE.view(bytes, offset, length);

  /// Creates a new [Bytes] from [bd]. [endian] defaults to [Endian.host].
  static Bytes fromByteData(ByteData bd, [Endian endian]) =>
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

  // TODO Unit test
  static ByteData copyByteData(Bytes bytes, [int start = 0, int end]) {
    final bd = bytes.bd;
    end ??= bd.lengthInBytes;
    final offset = bd.offsetInBytes + start;
    final length = end - start;
    final newBD = ByteData(length);
    for (var i = 0; i < length; i++) newBD.setUint8(i, bd.getUint8(offset + i));
    return newBD;
  }

  static ByteData viewByteData(Bytes bytes, [int start = 0, int end]) =>
      bytes.bd.buffer.asByteData(bytes.offset + start, end ?? bytes.length);

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
    charset ??= Charset.utf8;
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
          _listToString(vList, maxLength, separator), charset ?? Charset.utf8);

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

  int getUint8(int offset) => bd.getUint8(offset);
  @override
  void setUint8(int offset, int value) => bd.setUint8(offset, value);

  /// Returns an 8-bit integer values at [offset].
  int getInt8(int offset) => bd.getInt8(offset);
  @override
  void setInt8(int offset, int value) => bd.setInt8(offset, value);

  // **** Internal methods

  /// Returns the absolute index of [offset] in the underlying [ByteBuffer].
  int _absIndex(int offset) => bd.offsetInBytes + offset;

  // **** TypedData copies

  /// Returns a [ByteData] that iss a copy of the specified region of _this_.
  ByteData _copyBDRegion(int offset, int length) {
    final _length = length ?? length;
    final bdNew = ByteData(_length);
    for (var i = 0, j = offset; i < _length; i++, j++)
      bdNew.setUint8(i, bd.getUint8(j));
    return bdNew;
  }

  /// Creates a new [Bytes] from _this_ containing the specified region.
  @override
  Bytes sublist([int start = 0, int end]) {
    final bd = _copyBDRegion(start, (end ??= length) - start);
    return Bytes.fromByteData(bd, Endian.little);
  }

  /// Creates an [Int8List] copy of the specified region of _this_.
  Bytes getBytes([int offset = 0, int length]) {
    final bd = _copyBDRegion(offset, length);
    return Bytes.fromByteData(bd, Endian.little);
  }

  /// Creates an [Int8List] copy of the specified region of _this_.
  ByteData getByteData([int offset = 0, int length]) =>
      _copyBDRegion(offset, length);

  /// Creates an [Int8List] copy of the specified region of _this_.
  Int8List getInt8List([int offset = 0, int length]) {
    length ??= this.length;
    final list = Int8List(length);
    for (var i = 0, j = offset; i < length; i++, j++) list[i] = bd.getInt8(j);
    return list;
  }

  /// Creates an [Int8List] view of the specified region of _this_.
  Int8List asInt8List([int offset = 0, int length]) {
    length ??= this.length - offset;
    return bd.buffer.asInt8List(_absIndex(offset), length);
  }

  // **** Unsigned Integer Lists

  Uint8List getUint8List([int offset = 0, int length]) {
    length ??= this.length;
    final list = Uint8List(length);
    for (var i = 0, j = offset; i < length; i++, j++) list[i] = bd.getInt8(j);
    return list;
  }

  // Allows the removal of padding characters.
  Uint8List asUint8List([int offset = 0, int length]) {
    length ??= length;
    final index = _absIndex(offset);
    return bd.buffer.asUint8List(index, length);
  }

  // **** Get Strings and List<String>

  /// Returns a [String] containing a _Base64_ encoding of the specified
  /// region of _this_.
  String getBase64([int offset = 0, int length]) {
    final bList = asUint8List(offset, length);
    return bList.isEmpty ? '' : cvt.base64.encode(bList);
  }

  // Allows the removal of padding characters.
  Uint8List _asUint8ListFromString([int offset = 0, int length]) {
    length ??= length;
    if (length <= offset) return kEmptyUint8List;
    final index = _absIndex(offset);
    final lastIndex = length - 1;
    final _length = _maybeRemoveNull(lastIndex, length);
    if (length == 0) return kEmptyUint8List;
    return bd.buffer.asUint8List(index, _length);
  }

  int _maybeRemoveNull(int lastIndex, int vfLength) =>
      (getUint8(lastIndex) == kNull) ? lastIndex : vfLength;

  /// Returns a [String] containing a _ASCII_ decoding of the specified
  /// region of _this_. Also allows the removal of a padding character.
  String stringFromAscii(
      {int offset = 0, int length, bool allowInvalid = true}) {
    final v = _asUint8ListFromString(offset, length ?? length);
    return v.isEmpty ? '' : cvt.ascii.decode(v, allowInvalid: allowInvalid);
//    final last = s.length - 1;
//    final c = s.codeUnitAt(last);
    // TODO: kNull should never get here but it does. Fix
//    return (c == kNull) ? s.substring(0, last) : s;
  }

  /// Returns a [List<String>]. This is done by first decoding
  /// the specified region as _ASCII_, and then _split_ing the
  /// resulting [String] using the [separator]. Also allows the
  /// removal of a padding character.
  List<String> stringListFromAscii(
      {int offset = 0,
      int length,
      bool allowInvalid = true,
      String separator = '\\'}) {
    final s = stringFromAscii(
        offset: offset, length: length, allowInvalid: allowInvalid);
    return (s.isEmpty) ? kEmptyStringList : s.split(separator);
  }

  /// Returns a [String] containing a _UTF-8_ decoding of the specified region.
  /// Also, allows the removal of padding characters.
  String stringFromUtf8(
      {int offset = 0, int length, bool allowInvalid = true}) {
    final v = _asUint8ListFromString(offset, length ?? length);
    return v.isEmpty ? '' : cvt.utf8.decode(v, allowMalformed: allowInvalid);
  }

  /// Returns a [List<String>]. This is done by first decoding
  /// the specified region as _UTF-8_, and then _split_ing the
  /// resulting [String] using the [separator].
  List<String> stringListFromUtf8(
      {int offset = 0,
      int length,
      bool allowInvalid = true,
      String separator = '\\'}) {
    final s = stringFromUtf8(
        offset: offset, length: length, allowInvalid: allowInvalid);
    return (s.isEmpty) ? kEmptyStringList : s.split(separator);
  }

  String stringFromLatin(
      {int offset = 0, int length, bool allowInvalid = true}) {
    final v = _asUint8ListFromString(offset, length ?? length);
    return v.isEmpty ? '' : cvt.latin1.decode(v, allowInvalid: allowInvalid);
  }

  /// Returns a [List<String>]. This is done by first decoding
  /// the specified region as _UTF-8_, and then _split_ing the
  /// resulting [String] using the [separator].
  List<String> stringListFromLatin(
      {int offset = 0,
      int length,
      bool allowInvalid = true,
      String separator = '\\'}) {
    final s = stringFromLatin(
        offset: offset, length: length, allowInvalid: allowInvalid);
    return (s.isEmpty) ? kEmptyStringList : s.split(separator);
  }

  /// Returns a [String] containing a _UTF-8_ decoding of the specified region.
  String getString(Charset charset,
      {int offset = 0,
      int length,
      bool allowInvalid = true,
      String separator = '\\'}) {
    final v = _asUint8ListFromString(offset, length ?? length);
    return v.isEmpty ? '' : charset.decode(v, allowInvalid: true);
  }

  /// Returns a [List<String>]. This is done by first decoding
  /// the specified region as _UTF-8_, and then _split_ing the
  /// resulting [String] using the [separator].
  List<String> getStringList(Charset charset,
      {int offset = 0,
      int length,
      bool allowInvalid = true,
      String separator = '\\'}) {
    final s = getString(charset,
        offset: offset,
        length: length,
        allowInvalid: allowInvalid,
        separator: separator);
    return (s.isEmpty) ? kEmptyStringList : s.split(separator);
  }

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
  static final Bytes kEmptyBytes = Bytes(ByteData(0));
}

/// [BytesLE] is a class that provides a read-only Little Endian byte array
/// that supports both [Uint8List] and [ByteData] interfaces.
class BytesLE extends Bytes
    with LittleEndianMixin
    implements Comparable<Bytes> {
  /// Creates a new [Bytes] containing [length] zero elements.
  /// [length] defaults to [Bytes.kDefaultLength].
  BytesLE([int length = Bytes.kDefaultLength]) : super(ByteData(length));

  BytesLE.view(Bytes bytes, [int offset = 0, int length])
      : super(_bdView(bytes.bd, offset, length ?? bytes.length));

  /// Creates a new [Bytes] from [bytes] containing the specified region.
  BytesLE.from(Bytes bytes, [int offset = 0, int length])
      : super(_copyByteData(bytes.bd, offset, length ?? bytes.length));

  /// Creates a new [Bytes] from [bd].
  BytesLE.fromByteData(ByteData bd) : super(bd);

  /// Creates a new [Bytes] from a [TypedData] containing the specified
  /// region and [endian]ness.
  BytesLE.typedDataView(TypedData td,
      [int offsetInBytes = 0, int lengthInBytes])
      : super(td.buffer.asByteData(td.offsetInBytes + offsetInBytes,
            lengthInBytes ?? td.lengthInBytes));

  /// Creates a new [Bytes] from a [List<int>]. Any values in [list]
  /// that are larger than 8-bits are truncated.
  BytesLE.fromList(List<int> list)
      : super(list is Uint8List
            ? list.buffer.asByteData()
            : Uint8List.fromList(list).buffer.asByteData());

  // TODO: Either remove fromFile and fromPath or add doAsync

  /// Returns a [Bytes] buffer containing the contents of [File].
  static BytesLE fromFile(File file, {bool doAsync = false}) {
    final Uint8List bList = doAsync ? file.readAsBytes : file.readAsBytesSync();
    return BytesLE.typedDataView(bList, 0, bList.length);
  }

  /// Returns a [Bytes] buffer containing the contents of the
  /// [File] at [path].
  static BytesLE fromPath(String path, {bool doAsync = false}) =>
      fromFile(File(path), doAsync: doAsync);

  /// Returns a [Bytes] containing the Base64 decoding of [s].
  static BytesLE fromBase64(String s, {bool padToEvenLength = false}) {
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

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  static BytesLE fromString(String s, [Charset charset = Charset.utf8]) {
    if (s == null) return nullValueError(s);
    if (s.isEmpty) return kEmptyBytes;
    return BytesLE.typedDataView(charset.encode(s));
  }

  /// Returns a [Bytes] containing the ASCII encoding of [s].
  static BytesLE ascii(String s) => fromString(s, Charset.ascii);

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  static BytesLE utf8(String s) => BytesLE.fromString(s, Charset.utf8);

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  static BytesLE latin(String s) => BytesLE.fromString(s, Charset.latin1);

  /// Returns a [Bytes] containing [charset] code units.
  /// [charset] defaults to UTF8.
  static BytesLE fromStringList(List<String> vList,
          [Charset charset, int maxLength, String separator = '\\']) =>
      BytesLE.fromString(
          _listToString(vList, maxLength, separator), charset ?? utf8);

  /// Returns a [Bytes] containing ASCII code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as ASCII. The result is returns as [Bytes].
  static BytesLE asciiFromList(List<String> vList,
          [int maxLength, String separator = '\\']) =>
      fromStringList(vList, Charset.ascii, maxLength, separator);

  /// Returns a [Bytes] containing UTF-8 code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as UTF-8. The result is returns as [Bytes].
  static BytesLE utf8FromList(List<String> vList,
          [int maxLength, String separator = '\\']) =>
      BytesLE.utf8(_listToString(vList, maxLength, separator));

  /// Returns a [Bytes] containing Latin (1 - 9) code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as UTF-8. The result is returns as [Bytes].
  static BytesLE latinFromList(List<String> vList,
          [int maxLength, String separator = '\\']) =>
      BytesLE.latin(_listToString(vList, maxLength, separator));
}

/// [BytesBE] is a class that provides a read-only Little Endian byte array
/// that supports both [Uint8List] and [ByteData] interfaces.
class BytesBE extends Bytes with BigEndianMixin implements Comparable<Bytes> {
  /// Creates a new [Bytes] containing [length] zero elements.
  /// [length] defaults to [Bytes.kDefaultLength].
  BytesBE([int length = Bytes.kDefaultLength]) : super(ByteData(length));

  /// Creates a new [Bytes] containing [length] zero elements.
  /// [length] defaults to [Bytes.kDefaultLength].
//  BytesBE._(int length) : super.internal(ByteData(length));

  BytesBE.view(Bytes bytes, [int offset = 0, int length])
      : super(_bdView(bytes.bd, offset, length ?? bytes.length));

  /// Creates a new [Bytes] from [bytes] containing the specified region.
  BytesBE.from(Bytes bytes, [int offset = 0, int length])
      : super(_copyByteData(bytes.bd, offset, length ?? bytes.length));

  /// Creates a new [Bytes] from [bd].
  BytesBE.fromByteData(ByteData bd) : super(bd);

  /// Creates a new [Bytes] from a [TypedData] containing the specified
  /// region and [endian]ness.
  BytesBE.typedDataView(TypedData td,
      [int offsetInBytes = 0, int lengthInBytes])
      : super(td.buffer.asByteData(td.offsetInBytes + offsetInBytes,
            lengthInBytes ?? td.lengthInBytes));

  /// Creates a new [Bytes] from a [List<int>]. Any values in [list]
  /// that are larger than 8-bits are truncated.
  BytesBE.fromList(List<int> list)
      : super(list is Uint8List
            ? list.buffer.asByteData()
            : Uint8List.fromList(list).buffer.asByteData());

  // TODO: Either remove fromFile and fromPath or add doAsync

  /// Returns a [Bytes] buffer containing the contents of [File].
  static BytesBE fromFile(File file, {bool doAsync = false}) {
    final Uint8List bList = doAsync ? file.readAsBytes : file.readAsBytesSync();
    return BytesBE.typedDataView(bList, 0, bList.length);
  }

  /// Returns a [Bytes] buffer containing the contents of the
  /// [File] at [path].
  static BytesBE fromPath(String path, {bool doAsync = false}) =>
      fromFile(File(path), doAsync: doAsync);

  /// Returns a [Bytes] containing the Base64 decoding of [s].
  static BytesBE fromBase64(String s, {bool padToEvenLength = false}) {
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

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  static BytesBE fromString(String s, [Charset charset = Charset.utf8]) {
    if (s == null) return nullValueError(s);
    if (s.isEmpty) return kEmptyBytes;
    return BytesBE.typedDataView(charset.encode(s));
  }

  /// Returns a [Bytes] containing the ASCII encoding of [s].
  static BytesBE ascii(String s) => BytesBE.fromString(s, Charset.ascii);

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  static BytesBE utf8(String s) => BytesBE.fromString(s, Charset.utf8);

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  static BytesBE latin(String s) => BytesBE.fromString(s, Charset.latin1);

  /// Returns a [Bytes] containing [charset] code units.
  /// [charset] defaults to UTF8.
  static BytesBE fromStringList(List<String> vList,
          [Charset charset, int maxLength, String separator = '\\']) =>
      BytesBE.fromString(
          _listToString(vList, maxLength, separator), charset ?? utf8);

  /// Returns a [Bytes] containing ASCII code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as ASCII. The result is returns as [Bytes].
  static BytesBE asciiFromList(List<String> vList,
          [int maxLength, String separator = '\\']) =>
      fromStringList(vList, Charset.ascii, maxLength, separator);

  /// Returns a [Bytes] containing UTF-8 code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as UTF-8. The result is returns as [Bytes].
  static BytesBE utf8FromList(List<String> vList,
          [int maxLength, String separator = '\\']) =>
      fromStringList(vList, Charset.utf8, maxLength, separator);

  /// Returns a [Bytes] containing Latin (1 - 9) code units.
  ///
  /// The [String]s in [vList] are [join]ed into a single string using
  /// using [separator] (which defaults to '\') to separate them, and
  /// then they are encoded as UTF-8. The result is returns as [Bytes].
  static BytesBE latinFromList(List<String> vList,
          [int maxLength, String separator = '\\']) =>
      fromStringList(vList, Charset.latin1, maxLength, separator);
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
  if ((len0 % 8) == 0) {
    return _uint64Equal(a, b, ignorePadding);
  } else if ((len0 % 4) == 0) {
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
    final x = a.bd.getUint16(i, Endian.big);
    final y = b.bd.getUint16(i, Endian.big);
    if (x != y) return _bytesMaybeNotEqual(i, a, b, ignorePadding);
  }
  return true;
}

// Note: optimized to use 4 byte boundary
bool _uint32Equal(Bytes a, Bytes b, bool ignorePadding) {
  for (var i = 0; i < a.length; i += 4) {
    final x = a.bd.getUint32(i, Endian.big);
    final y = b.bd.getUint32(i, Endian.big);
    if (x != y) return _bytesMaybeNotEqual(i, a, b, ignorePadding);
  }
  return true;
}

// Note: optimized to use 8 byte boundary
bool _uint64Equal(Bytes a, Bytes b, bool ignorePadding) {
  for (var i = 0; i < a.length; i += 8) {
    final x = a.bd.getUint64(i, Endian.big);
    final y = b.bd.getUint64(i, Endian.big);
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
