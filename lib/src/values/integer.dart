//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:math';

import 'package:core/src/error/issues/issues.dart';
import 'package:core/src/global.dart';
import 'package:core/src/utils/parser.dart';

// ignore_for_file: public_member_api_docs

const int k1KB = 1024;
const int k1MB = k1KB * 1024;
const int k1GB = k1MB * 1024;
const int k1TB = k1GB * 1024;

/// The minimum values of a signed 8-bit integer.
const int kInt8Min = -(1 << (8 - 1));

/// The maximum values of a signed 8-bit integer.
const int kInt8Max = (1 << (8 - 1)) - 1;

/// The minimum values of a signed 16-bit integer.
const int kInt16Min = -(1 << (16 - 1));

/// The maximum values of a signed 16-bit integer.
const int kInt16Max = (1 << (16 - 1)) - 1;

/// The minimum values of a signed 32-bit integer.
const int kInt32Min = -(1 << (32 - 1));

/// The maximum values of a signed 32-bit integer.
const int kInt32Max = (1 << (32 - 1)) - 1;

/// The minimum values of an unboxed, signed 32-bit integer.
const int kInt64Min = kDartMinSMInt;

/// The maximum values of an unboxed, signed 32-bit integer.
const int kInt64Max = kDartMaxSMInt;

/// The minimum values of a unsigned 16-bit integer.
const int kUint8Min = 0;

/// The maximum values of a unsigned 16-bit integer.
const int kUint8Max = 0xFF;

/// The minimum values of a unsigned 32-bit integer.
const int kUint16Min = 0;

/// The maximum values of an unsigned 16-bit integer (2^32).
const int kUint16Max = 0xFFFF;

/// The minimum values of a unsigned 32-bit integer.
const int kUint32Min = 0;

/// The maximum values of an unsigned 32-bit integer (2^32).
const int kUint32Max = 0xFFFFFFFF;

/// The minimum values of an unboxed, unsigned 64-bit integer.
const int kUint64Min = 0;

/// The maximum values of an unboxed, unsigned 64-bit integer (2^32).
const int kUint64Max = kDartMaxSMUint;

/// The minimum integer values, in Dart, that can be stored without boxing.
const int kDartMinSMInt = -4611686018427387904;

/// The maximum integer values, in Dart, that can be stored without boxing.
const int kDartMaxSMInt = 4611686018427387903;

/// The maximum unsigned integer values, in Dart, that can be stored
/// without boxing.
const int kDartMaxSMUint = 0x3FFFFFFFFFFFFFFF;

final int kMin63BitInt = -pow(2, 62);
final int kMax63BitInt = pow(2, 62) - 1;

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

List<String> hashIntegerStringList(List<String> sList, {Issues issues}) =>
    sList.map((s) => hashIntegerString(s, issues: issues));
