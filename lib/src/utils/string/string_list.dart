//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:core/src/error.dart';
import 'package:core/src/global.dart';
import 'package:core/src/error/general_errors.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/utils/string/string.dart';

// **** This file contains low-level [String] functions

/// Returns the number of code points, plus separators, plus padding.
int _stringListLength(Iterable<String> sList,
    {String separator = '\\', bool pad = true}) {
  if (sList.isEmpty) return 0;
  var len = sList.fold(0, _combineSLength);
  len += sList.length - 1;
  if (len.isOdd && pad) len++;
  print('String List length: $len');
  return len;
}

int _combineSLength(int v, String s) => v + s.length;

// TODO: unit test
int stringListLength(Iterable<String> sList,
        {String separator = '\\', bool pad = true}) =>
    (sList.isEmpty)
        ? 0
        : _stringListLength(sList, pad: pad);

Iterable<String> uppercase(List<String> vList) =>
    vList.map((s) => s.toUpperCase());

String stringListToString(List<String> sList, [String separator = '\\']) {
  if (sList == null) return null;
  if (sList.isEmpty) return '';
  return (sList.length == 1 ? sList[0] : sList.join('\\'));
}

/// Returns a [Uint8List] encoding of [sList].
Uint8List stringListToUint8List(List<String> sList,
    {int maxLength,
    bool isAscii = false,
    String separator = '\\',
    int padChar}) {
  final s = stringListToString(sList);
  if (s == null || s.length > maxLength) return null;
  return stringToUint8List(s, isAscii: isAscii);
}

/// Returns a [ByteData] encoding of [sList].
/// Returns a [Uint8List] corresponding to a binary Value Field.
ByteData stringListToByteData(List<String> sList,
    {int maxLength, bool isAscii = false, String separator = '\\'}) {
  if (sList == null) return null;
  final bList = stringListToUint8List(sList,
      maxLength: maxLength, isAscii: isAscii, separator: separator);
  return (bList == null) ? null : bList.buffer.asByteData();
}

/// _Deprecated_: Use Bytes.fromStringList instead.
@deprecated
List<String> stringListFromBytes(Bytes bytes, int maxVFLength,
        {bool isAscii = true}) =>
    stringListFromTypedData(bytes.asByteData(), maxVFLength, isAscii: isAscii);

List<String> stringListFromTypedData(TypedData td, int maxLength,
    {bool isAscii = true}) {
  if (td.lengthInBytes == 0) return kEmptyStringList;
  if (td.lengthInBytes > maxLength)
    return badTypedDataLength(td.lengthInBytes, maxLength);
  final s = typedDataToString(td, isAscii: isAscii);
  return s.split('\\');
}

String typedDataToString(TypedData vf, {bool isAscii = false}) {
  final vfBytes = vf.buffer.asUint8List(vf.offsetInBytes, vf.lengthInBytes);
  final allow = global.allowInvalidCharacterEncodings;
  return (isAscii || global.useAscii)
      ? ascii.decode(vfBytes, allowInvalid: allow)
      : utf8.decode(vfBytes, allowMalformed: allow);
}

List<String> textListFromBytes(TypedData vfBytes,
        {int maxLength, bool isAscii = true}) =>
    textListFromTypedData(vfBytes, maxLength: maxLength, isAscii: isAscii);

List<String> textListFromTypedData(TypedData td,
    {int maxLength, bool isAscii = true}) {
  if (td == null) return null;
  if (td.lengthInBytes == 0) return kEmptyStringList;
  if ((td.lengthInBytes > maxLength))
    return badTypedDataLength(td.lengthInBytes, maxLength);
  return <String>[typedDataToString(td, isAscii: isAscii)];
}

/// Returns a [Uint8List] corresponding to a binary Value Field.
Uint8List textListToUint8List(Iterable<String> values, int maxVFLength) {
  if (values.isEmpty) return kEmptyUint8List;
  if (values.length == 1) {
    final s = values.elementAt(0);
    if (s == null) return nullValueError();
    if (s.isEmpty) return kEmptyUint8List;
    return stringToUint8List(s, isAscii: false);
  }
  return badValuesLength(values, 1, 1);
}

/// Returns a [Uint8List] corresponding to a binary Value Field.
Bytes textListToBytes(Iterable<String> values) {
  if (values.isEmpty) return kEmptyBytes;
  if (values.length == 1) {
    final s = values.elementAt(0);
    if (s == null) return nullValueError();
    if (s.isEmpty) return kEmptyBytes;
    return Bytes.fromUtf8(s);
  }
  return badValuesLength(values, 1, 1);
}

class StringList extends ListBase<String> {
  final List<String> values;

  factory StringList.from([Iterable<String> vList]) =>
      (vList is StringList) ? vList : new StringList._(vList);

  StringList._([Iterable<String> vList])
      : values = (vList == null)
            ? kEmptyList
            : (vList is List) ? vList : vList.toList(growable: false);

  StringList.decode(Bytes bytes) : values = bytes.getUtf8List();

  @override
  String operator [](int i) => values[i];
  @override
  void operator []=(int i, String s) => values[i] = s;

  @override
  bool operator ==(Object other) {
    if (other is List<String>) {
      if (length != other.length) return false;
      for (var i = 0; i < length; i++)
        if (this[i] != other[i]) return false;
      return true;
    }
    return false;
  }

  @override
  int get hashCode => global.hasher.nList(values);

  @override
  int get length => values.length;
  @override
  set length(int i) => unsupportedError();

  // Performance: This is very inefficient
  int get lengthInBytes => asBytes.length;

  Bytes get asBytes => Bytes.fromUtf8List(values);

  List<String> get uppercase => values.map((v) => v.toUpperCase());

  List<String> get lowercase => values.map((v) => v.toUpperCase());

  List<String> get trimmed => values.map((v) => v.trim());

  List<String> get leftTrimmed => values.map((v) => v.trim());

  List<String> get rightTrimmed => values.map((v) => v.trim());

  List<String> trim(Trim trim) {
    switch (trim) {
      case Trim.trailing:
        return values.map((v) => v.trimRight());
      case Trim.both:
        return values.map((v) => v.trim());
      case Trim.leading:
        return values.map((v) => v.trimLeft());
      default:
        return values;
    }
  }

  Bytes encode([int separator = kBackslash]) =>
      Bytes.fromUtf8List(values, separator);

  static final StringList kEmptyList = new StringList.from(<String>[]);
}

class AsciiList extends StringList {
 factory AsciiList([Iterable<String> vList]) =>
 isAsciiList(vList)
     ? new StringList.from(vList)
     : badStringList('Invalid AsciiList: $vList');

  AsciiList.decode(Bytes bytes) : super._(bytes.getAsciiList());

  @override
  int get lengthInBytes {
    final vLength = values.length;
    if (vLength == 0) return 0;
    if (vLength == 1) return values.length;

    final len = values.fold<int>(0, (n, s) => n + s.length);
    return len + vLength - 1;
  }

  @override
  Bytes encode([int separator = kBackslash, int pad]) {
    var length = lengthInBytes;
    if (pad != null && length.isOdd) length++;
    final last = length - 1;
    final bytes = new Bytes(length);
    int j;
    for (var s in values) {
      for (var i = 0; i < s.length; i++) {
        final c = s.codeUnitAt(i);
        if (c > kDel) invalidCharacterInString(s, i);
        bytes[j++] = c;
        if (i < last) bytes[j++] = separator;
      }
    }
    if (pad != null && length.isOdd) bytes[j++] = pad;
    return bytes;
  }

  static bool isAsciiList(List<String> sList) {
      for(var s in sList) {
        for (var c in s.codeUnits)
          if (c <= 0 || c >= 127) return false;
      }
        return true;
      }

}
