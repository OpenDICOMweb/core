//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:collection';

import 'package:core/src/error.dart';
import 'package:core/src/global.dart';
import 'package:core/src/error/general_errors.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/utils/string/string.dart';

/// A class that is the _values_ of String Elements.
class StringList extends ListBase<String> {
  final List<String> _values;

  factory StringList.from([Iterable<String> vList]) {
    if (throwOnError && vList == null) return badValues(vList);
    if (vList == null || vList.isEmpty) return kEmptyList;
    final v =
        (vList is List<String>) ? vList : vList.toList(growable: false) ;
    return new StringList._(v);
  }

  StringList._(this._values);

  StringList.decode(Bytes bytes) : _values = bytes.getUtf8List();

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
  int get hashCode => global.hasher.nList(values);

  @override
  int get length => _values.length;

  /// [StringList]s are immutable.
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

  // Urgent Sharath unit test
  /// Returns a new [StringList ] where its values are the result of
  /// appending each of the original values with [s]. If the resulting
  /// [String] has length greater than [maxLength], the resulting
  /// values is truncated to [maxLength].
  StringList append(String s, int maxLength) {
    final length = values.length;
    final result = new List<String>(length);
    for (var i = 0; i < length; i++) {
      final s0 = values[i] + s;
      result[i] = (s0.length > maxLength) ? s0.substring(0, maxLength) : s0;
    }
    return new StringList._(result);
  }

  // Urgent Sharath unit test
  /// Returns a new [StringList] where its values are the result of
  /// prepending each of the original values with [s]. If the resulting
  /// [String] has length greater than [maxLength], the resulting
  /// values is truncated to [maxLength].
  StringList prepend(String s, int maxLength) {
    final length = values.length;
    final result = new List<String>(length);
    for (var i = 0; i < length; i++) {
      final s0 = s + values[i];
      result[i] = (s0.length > maxLength) ? s0.substring(0, maxLength) : s0;
    }
    return new StringList._(result);
  }

  // Urgent Sharath unit test
  /// Returns a new [StringList] where its values are the result of
  /// truncating each of the original values with a length greater than
  /// [newLength] to [newLength]. If [newLength] is greater than
  /// [maxLength] _null_ is returned.
  StringList truncate(int newLength, int maxLength) {
    final length = values.length;
    if (newLength > maxLength) return null;
    final result = new List<String>(length);
    for (var i = 0; i < length; i++) {
      final s = values[i];
      result[i] = (s.length > maxLength) ? s.substring(0, maxLength) : s;
    }
    return new StringList._(result);
  }

  // Urgent Sharath unit test
  /// Returns _true_ if each element in [values] matches
  /// the regular expression.
  bool match(String regexp) {
    final regex = new RegExp(regexp);
    for(var i = 0; i < values.length; i++) {
      final v = values[i];
      if (!regex.hasMatch(v)) return false;
    }
    return true;
  }

  // Urgent Jim: Fix
  // Urgent Sharath unit test
  StringList replaceString(String regexp, RegExp replace) {
    final regex = new RegExp(regexp);
    final length = values.length;
    final result = new List<String>(length);
    for(var i = 0; i < length; i++) {
      final v = values[i];
      result[i] = (v.length > length) ? v.substring(0, length) : v;
    }
    return update(result);
  }

  String _replace(RegExp regexp, String source, String result) {

    final match = regexp.firstMatch(source);

  }



  Bytes encode([int separator = kBackslash]) =>
      Bytes.fromUtf8List(values, separator);

  static final StringList kEmptyList = new StringList._(kEmptyStringList);
}

class AsciiList extends StringList {
  factory AsciiList([Iterable<String> vList]) => isAsciiList(vList)
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
    for (var s in sList) {
      for (var c in s.codeUnits) if (c <= 0 || c >= 127) return false;
    }
    return true;
  }
}
