//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:convert';
import 'dart:typed_data';

import 'package:core/src/global.dart';
import 'package:core/src/utils/character/ascii.dart';
import 'package:core/src/utils/character/dicom.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/error/string_errors.dart';
import 'package:core/src/utils/string/hexadecimal.dart';

// ignore_for_file: public_member_api_docs

bool isAllBlanks(String s, int start, int end) {
  for (var i = start; i < s.length; i++)
    if (s.codeUnitAt(i) != kSpace) return false;
  return true;
}

// **** This file contains low-level [String] functions

/// Returns a [String] containing [count] _space_ (' ') characters.
String spaces(int count) => ''.padRight(count);

/// _Deprecated_: Uses [spaces] instead.
@deprecated
String blanks(int n) => spaces(n);

/// Returns an [Iterable] of [s], where [s] is split at the
/// separator and then each component of the [Iterable] has
/// the specified whitespace trimmed.
Iterable<String> splitTrim(String s, String separator, [End trim]) =>
    s.split(separator).map((s) => trimWhitespace(s, trim));

String removeNullPadding(String s) {
  final lastIndex = s.length - 1;
  return (s.codeUnitAt(lastIndex) == kNull) ? s.substring(0, lastIndex) : s;
}

/// The type of whitespace trimming.
enum Trim { leading, trailing, both, none }

String trim(String s, Trim trim) {
  if (s == null || s.isEmpty || trim == Trim.none) return s;
  switch (trim) {
    case Trim.trailing:
      return s.trimRight();
    case Trim.both:
      return s.trim();
    case Trim.leading:
      return s.trimLeft();
    default:
      throw 'Trim error; $trim';
  }
}

/// Specifies whether padding is allowed on the left-end, right-end,
/// or both-ends.
enum End { left, right, both }

/// Returns a [String] with the specified whitespace (see [String.trim])
/// removed. If [end] is not specified, it defaults to [End.right].
String trimWhitespace(String s, [End end]) {
  end ??= End.right;
  if (end == End.right) return s.trimRight();
  if (end == End.both) return s.trim();
  if (end == End.left) return s.trimLeft();
  return s;
}

Uint8List stringToUint8List(String s, {bool isAscii = false}) {
  if (s == null) return null;
  if (s.isEmpty) return kEmptyUint8List;
  return (isAscii || global.useAscii) ? ascii.encode(s) : utf8.encode(s);
}

ByteData stringToByteData(String s, {bool isAscii = false}) {
  if (s == null) return null;
  final bList = stringToUint8List(s, isAscii: isAscii);
  return bList.buffer.asByteData();
}

bool isDcmString(String s, int max,
    {bool allowLeading = true, bool allowBlank = true}) {
  final len = (s.length < max) ? s.length : max;
  return isFilteredString(s, 0, len, isDcmStringChar,
      allowLeadingSpaces: allowLeading,
      allowTrailingSpaces: true,
      allowBlank: allowBlank);
}

bool isNotDcmString(String s, int max, {bool allowLeading = true}) =>
    !isDcmString(s, max, allowLeading: allowLeading);

bool isDcmText(String s, int max) {
  final len = (s.length < max) ? s.length : max;
  return isFilteredString(s, 0, len, isDcmTextChar,
      allowLeadingSpaces: false, allowTrailingSpaces: true);
}

bool isNotDcmText(String s, int max) => !isDcmText(s, max);

// Improvement: Handle escape sequences
bool isFilteredString(String s, int min, int max, bool filter(int c),
    {bool allowLeadingSpaces = false,
    bool allowTrailingSpaces = false,
    bool allowBlank = true}) {
  if (s.isEmpty) return true;
  if (s.length < min || s.length > max) return false;

  var i = 0;
  if (allowLeadingSpaces)
    for (; i < s.length; i++) if (s.codeUnitAt(i) != kSpace) break;

  if (i >= s.length) return allowBlank;

  for (var j = 0; j < s.length; j++) {
    if (!filter(s.codeUnitAt(j))) {
      invalidCharacterInString(s, j);
      return false;
    }
  }
  return true;
}

bool isNotFilteredString(String s, int min, int max, bool filter(int c),
        {bool allowLeading = false,
        bool allowTrailing = false,
        bool allowBlank = true}) =>
    !isFilteredString(s, min, max, filter,
        allowLeadingSpaces: allowLeading, allowTrailingSpaces: allowTrailing);

//TODO: before V0.9.0 decide if these are needed or useful

// Auxiliary used for debugging
@deprecated
String toAscii(ByteData bd, [int start = 0, int end, int position]) {
  end ??= bd.lengthInBytes;
  String vChar(int c) =>
      (c > kSpace) && (c < kDelete) ? '_${String.fromCharCode(c)}' : '__';
  final bytes = bd.buffer.asUint8List(start, end);
  if (start >= end) return '';
  var pos = position ?? start;
  if (pos >= end) pos = end;
  final sb = StringBuffer();
  for (var i = start; i < pos; i++) sb.write(' ${vChar(bytes[i])}');
  sb.write('|${vChar(bytes[pos])}|');
  for (var i = pos + 1; i < end; i++) sb.write(' ${vChar(bytes[i])}');
  return sb.toString();
}

/// Returns a hexadecimal [String] corresponding to [bd].
// Auxiliary used for debugging
@deprecated
String bdToHex(ByteData bd, [int start = 0, int end, int position]) {
  end ??= bd.lengthInBytes;
  final bytes = bd.buffer.asUint8List(start, end);
  var pos = position ?? start;
  if (start >= end) return '';
  if (pos >= end) pos = end;
  final sb = StringBuffer();
  for (var i = start; i < pos; i++) sb.write(' ${hex8(bytes[i])}');
  sb.write('|${hex8(bytes[pos])}|');
  for (var i = pos + 1; i < end; i++) sb.write(' ${hex8(bytes[i])}');
  return sb.toString();
}
