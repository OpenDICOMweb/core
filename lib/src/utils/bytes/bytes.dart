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
import 'package:core/src/utils/bytes/bytes_mixin.dart';
import 'package:core/src/utils/character/charset.dart';

// ignore_for_file: public_member_api_docs

/// Bytes Package Overview
///
/// - All get_XXX_List methods return fixed length (unmodifiable) Lists.
/// - All asXXX methods return a view of the specified region.

/// [Bytes] is a class that provides a read-only byte array that supports both
/// [Uint8List] and [ByteData] interfaces.
class Bytes extends ListBase<int> with BytesMixin implements Comparable<Bytes> {
  @override
  Uint8List buf;
  ByteData _bd;
  @override
  Endian endian;

  @override
  ByteData get bd => _bd ??= buf.buffer.asByteData(buf.offsetInBytes);

  /// Creates a new [Bytes] containing [length] zero elements.
  /// [length] defaults to [kDefaultLength] and [endian] defaults
  /// to [Endian.little].
  Bytes([int length = kDefaultLength, Endian endian = Endian.little])
      : endian = endian ?? Endian.little,
        buf = Uint8List(length ?? k1MB);

  Bytes.view(Bytes bytes,
      [int offset = 0, int length, Endian endian = Endian.little])
      : endian = endian ?? Endian.little,
        buf = _bytesView(bytes.buf, offset, length ?? bytes.length);

  /// Creates a new [Bytes] from [bytes] containing the specified region
  /// and [endian]ness. [endian] defaults to [Endian.little].
  Bytes.from(Bytes bytes,
      [int offset = 0, int length, Endian endian = Endian.little])
      : endian = endian ?? Endian.little,
        buf = copyUint8List(bytes.buf, offset, length ?? bytes.length);

  /// Creates a new [Bytes] from [bd]. [endian] defaults to [Endian.little].
  Bytes.fromByteData(ByteData bd, [Endian endian = Endian.little])
      : endian = endian ?? Endian.little,
        buf = bd.buffer.asUint8List(bd.offsetInBytes);

  /// Creates a new [Bytes] from [list]. [endian] defaults to [Endian.little].
  Bytes.fromUint8List(Uint8List list,
      [int offset = 0, int length, Endian endian = Endian.little])
      : endian = endian ?? Endian.little,
        buf = copyUint8List(list, offset, length);

  /// Creates a new [Bytes] from a [TypedData] containing the specified
  /// region and [endian]ness.  [endian] defaults to [Endian.little].
  Bytes.typedDataView(TypedData td,
      [int offsetInBytes = 0, int lengthInBytes, Endian endian = Endian.little])
      : endian = endian ?? Endian.little,
        buf = td.buffer.asUint8List(td.offsetInBytes + offsetInBytes,
            lengthInBytes ?? td.lengthInBytes);

  /// Creates a new [Bytes] from a [List<int>].  [endian] defaults
  /// to [Endian.little]. Any values in [list] that are larger than 8-bits
  /// are truncated.
  Bytes.fromList(List<int> list, [Endian endian = Endian.little])
      : endian = endian ?? Endian.little,
        buf = (list is Uint8List) ? list : Uint8List.fromList(list);

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
    if (s == null) return null;
    return s.isEmpty ? kEmptyBytes : Bytes.typedDataView(cvt.ascii.encode(s));
  }

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  factory Bytes.utf8(String s) {
    if (s == null) return null;
    if (s.isEmpty) return kEmptyBytes;
    final Uint8List u8List = cvt.utf8.encode(s);
    return Bytes.typedDataView(u8List);
  }

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  factory Bytes.latin(String s) {
    if (s == null) return null;
    if (s.isEmpty) return kEmptyBytes;
    final u8List = cvt.latin1.encode(s);
    return Bytes.typedDataView(u8List);
  }

  /// Returns [Bytes] containing the UTF-8 encoding of [s];
  factory Bytes.fromString(String s, Ascii charset) {
    charset ??= utf8;
    if (s == null) return null;
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


  static const int kMinLength = 16;
  static const int kDefaultLength = 1024;

  /// The canonical empty (zero length) [Bytes] object.
  static final Bytes kEmptyBytes = Bytes(0);
}

//TODO: move this to the appropriate place
/// Returns a [ByteData] that is a copy of the specified region of _this_.
Uint8List _bytesView(Uint8List list, int offset, int end) {
  final _offset = list.offsetInBytes + offset;
  final _length = (end ?? list.lengthInBytes) - _offset;
  return list.buffer.asUint8List(_offset, _length);
}

String _listToString(List<String> vList, int maxLength, String separator) {
  if (vList == null) return null;
  if (vList.isEmpty) return '';
  final s = vList.length == 1 ? vList[0] : vList.join(separator);
  if (s == null || s.length > (maxLength ?? s.length)) return null;
  return s.isEmpty ? '' : s;
}
