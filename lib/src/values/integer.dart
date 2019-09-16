//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/error/issues/issues.dart';
import 'package:core/src/global.dart';
import 'package:core/src/utils/parser.dart';

/// Return [value], if it satisfies [min] <= [value] <= [max];
/// otherwise, throws a [RangeError].
int checkRange(int value, int min, int max, {bool throwOnError = false}) {
  if (value < min || value > max) {
    return throwOnError
        ? throw RangeError('$value is not in range $min to $max')
        : null;
  }
  return value;
}

/// Returns _true_ if [s] is a valid unsigned integer [String].
bool isValidUintString(String s,
        [int start = 0,
        int end,
        Issues issues,
        int minLength = 0,
        int maxLength = 20]) =>
    tryParseUint(s,
        start: start,
        end: end,
        issues: issues,
        minLength: minLength,
        maxLength: maxLength) !=
    null;

/// Returns _true_ if [s] is a valid signed integer [String].
bool isValidIntString(String s,
        [int start = 0,
        int end,
        Issues issues,
        int minLength = 1,
        int maxLength = 20]) =>
    tryParseInt(s, start, end, issues, minLength, maxLength) != null;

/// The smallest integer contained in an IS Element
const int kMinIntegerStringValue = -0x7FFFFFFF;

/// The largest integer contained in an IS Element
const int kMaxIntegerStringValue = 999999999999;

/// The smallest hash of a DICOM IS Element values
const int kMinIntegerStringHashValue = -99999999999;

/// The largest hash of a DICOM IS Element values
// _Note_: the hash is a signed int, so this values is different from
// maxIntegerStringValue
const int kMaxIntegerStringHashValue = 99999999999;

/// Returns the hash of a DICOM IS Element values
String hashIntegerString(String s, {Issues issues}) {
  final i = tryParseInt(s);
  if (i == null || i < kMinIntegerStringValue || i > kMaxIntegerStringValue)
    return parseError('Invalid Integer String: $s', issues);
  final sign = (i.isOdd) ? -1 : 1;
  final hash = sign * Global.rng.nextInt(kMaxIntegerStringHashValue);
  return hash.toString();
}

/// Returns a [List<String>] containing the [hashIntegerString] of [sList].
List<String> hashIntegerStringList(List<String> sList, {Issues issues}) =>
    sList.map((s) => hashIntegerString(s, issues: issues));
