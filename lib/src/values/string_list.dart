//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:collection';
import 'dart:typed_data';

import 'package:core/src/error.dart';
import 'package:core/src/global.dart';
import 'package:core/src/error/general_errors.dart';
import 'package:core/src/utils.dart';

// ignore_for_file: public_member_api_docs

/// A class that is the _values_ of String Elements.
class StringList extends ListBase<String> {
  final List<String> _values;

  factory StringList.from([Iterable<String> vList, Trim trimType = Trim.none]) {
    if (throwOnError && vList == null) return badValues(vList);
    if (vList == null || vList.isEmpty) return kEmptyList;
    final vList1 = (vList is List<String>) ? vList : vList.toList();

    if (!doRemoveBlankStrings && !doTrimWhitespace) return StringList._(vList1);

    final vList2 = <String>[];
    for (var i = 0; i < vList1.length; i++) {
      final a = vList1[i];
      if (doRemoveBlankStrings && a.trim().isEmpty) continue;

      vList2.add(doTrimWhitespace ? trimmer(a, trimType) : a);
    }
    if (vList2.isEmpty) return kEmptyList;
    return StringList._(vList2);
  }

  StringList._(this._values);

  StringList.decode(Bytes bytes, [Charset charset]) : 
        _values = bytes.getStringList(charset);

  @override
  String operator [](int i) => _values[i];
  @override
  void operator []=(int i, String s) => _values[i] = s;

  @override
  bool operator ==(Object other) {
    if (other is List<String>) {
      if (length != other.length) return false;
      for (var i = 0; i < length; i++) if (this[i] != other[i]) return false;
      return true;
    }
    return false;
  }

  List<String> get values => _values;

  @override
  int get hashCode => global.hasher.nList(_values);

  @override
  int get length => _values.length;

  /// [StringList]s are immutable.
  @override
  set length(int i) => unsupportedError();

  // Performance: This is very inefficient
  int get lengthInBytes => asBytes.length;

  Bytes get asBytes => Bytes.utf8FromList(_values);

  List<String> get uppercase => _values.map((v) => v.toUpperCase());

  List<String> get lowercase => _values.map((v) => v.toUpperCase());

  List<String> get trimmed => _values.map((v) => v.trim());

  List<String> get leftTrimmed => _values.map((v) => v.trim());

  List<String> get rightTrimmed => _values.map((v) => v.trim());

  List<String> trim(Trim trim) {
    switch (trim) {
      case Trim.trailing:
        return _values.map((v) => v.trimRight());
      case Trim.both:
        return _values.map((v) => v.trim());
      case Trim.none:
        return _values;
      case Trim.leading:
        return _values.map((v) => v.trimLeft());
      default:
        return _values;
    }
  }

  /// Returns a new [StringList ] where its values are the result of
  /// appending each of the original values with [s]. If the resulting
  /// [String] has length greater than [maxLength], the resulting
  /// values is truncated to [maxLength].
  StringList append(String s, int maxLength) {
    final length = _values.length;
    final result = List<String>(length);
    for (var i = 0; i < length; i++) {
      final s0 = _values[i] + s;
      result[i] = (s0.length > maxLength) ? s0.substring(0, maxLength) : s0;
    }
    return StringList._(result);
  }

  /// Returns a new [StringList] where its values are the result of
  /// prepending each of the original values with [s]. If the resulting
  /// [String] has length greater than [maxLength], the resulting
  /// values is truncated to [maxLength].
  StringList prepend(String s, int maxLength) {
    final length = _values.length;
    final result = List<String>(length);
    for (var i = 0; i < length; i++) {
      final s0 = s + _values[i];
      result[i] = (s0.length > maxLength) ? s0.substring(0, maxLength) : s0;
    }
    return StringList._(result);
  }

  /// Returns a new [StringList] where its values are the result of
  /// truncating each of the original values with a length greater than
  /// [newLength] to [newLength]. If [newLength] is greater than
  /// [maxLength] _null_ is returned.
  StringList truncate(int newLength, int maxLength) {
    final length = _values.length;
    if (newLength > maxLength) return null;
    final result = List<String>(length);
    for (var i = 0; i < length; i++) {
      final s = _values[i];
      result[i] = (s.length > maxLength) ? s.substring(0, maxLength) : s;
    }
    return StringList._(result);
  }

  /// Returns _true_ if each element in [values] matches
  /// the regular expression.
  // TODO: Determine if this is the required functionality for ACR
  bool match(String regexp) {
    final regex = RegExp(regexp);
    for (var i = 0; i < _values.length; i++) {
      final v = _values[i];
      if (!regex.hasMatch(v)) return false;
    }
    return true;
  }

  /// Returns a new [StringList] where each value is the result of
  /// replacing the first occurrence of [from], in the original value,
  /// with [to]. If there is no occurrence of [from] in a value, it is
  /// placed in the result without change.
  // TODO: Determine if this is the required functionality for ACR
  StringList replaceFirst(RegExp from, String to, int maxLength,
      [int startIndex = 0]) {
    final length = _values.length;
    final result = List<String>(length);
    for (var i = 0; i < length; i++) {
      final v = _values[i].replaceFirst(from, to, startIndex);
      result[i] = (v.length > maxLength) ? v.substring(0, length) : v;
    }
    return StringList._(result);
  }

  /// Returns a new [StringList] where each _value_ is the result of
  /// replacing all occurrence of [from], in the original _value_,
  /// with [to]. If there is no occurrence of [from] in a _value_, it is
  /// placed in the result without change.
  // TODO: Determine if this is the required functionality for ACR
  StringList replaceAll(RegExp from, String to, int maxLength,
      [int startIndex = 0]) {
    final length = _values.length;
    final result = List<String>(length);
    for (var i = 0; i < length; i++) {
      final v = _values[i].replaceAll(from, to);
      result[i] = (v.length > maxLength) ? v.substring(0, length) : v;
    }
    return StringList._(result);
  }

  Bytes encode([int separator = kBackslash]) =>
      Bytes.utf8FromList(_values, separator);

  static final StringList kEmptyList = StringList._(kEmptyStringList);
}

class AsciiList extends StringList {
  factory AsciiList([Iterable<String> vList]) => isAsciiList(vList)
      ? StringList.from(vList)
      : badStringList('Invalid AsciiList: $vList');

  AsciiList.decode(Bytes bytes) : super._(bytes.stringListFromAscii());

  @override
  int get lengthInBytes {
    final vLength = _values.length;
    if (vLength == 0) return 0;
    if (vLength == 1) return _values.length;

    final len = _values.fold<int>(0, (n, s) => n + s.length);
    return len + vLength - 1;
  }

  @override
  Bytes encode([int separator = kBackslash, int pad]) {
    var length = lengthInBytes;
    if (pad != null && length.isOdd) length++;
    final last = length - 1;
    final bytes = Bytes(ByteData(length));
    int j;
    for (var s in _values) {
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
    for (var s in sList) {
      for (var c in s.codeUnits) if (c <= 0 || c >= 127) return false;
    }
    return true;
  }
}
