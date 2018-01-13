// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/date_time/primitives/age.dart';
import 'package:core/src/date_time/primitives/constants.dart';
import 'package:core/src/errors.dart';
import 'package:core/src/parser/parse_errors.dart';
import 'package:core/src/parser/parser.dart';
import 'package:core/src/string/string.dart';

//TODO: convert age string to duration
// TODO: before V0.9.0 document

bool _inRange(int v, int min, int max) => v != null && v >= min && v <= max;
bool _inAgeRange(int v) => _inRange(v, kMinAge, kMaxAge);
bool _inDayRange(int v) => _inRange(v, kMinAge, kMaxAge);
bool _inWeekRange(int v) => _inRange(v, 1, kMaxAgeWeeksInDays);
bool _inMonthRange(int v) => _inRange(v, 1, kMaxAgeMonthsInDays);
bool _inYearRange(int v) => _inRange(v, 1, kMaxAgeYearsInDays);

enum AgeToken { D, W, M, Y }

class Age {
  /// The number of days in this [Age].
  /// The range is [kMinAge] <= [nDays] <= [kMaxAge].
  final int nDays;

  factory Age(int nDays) => _inAgeRange(nDays) ? new Age._(nDays) : null;

  Age._(this.nDays);

  // Age._(this.count, this.token);
  @override
  bool operator ==(Object other) => other is Age && nDays == other.nDays;

  int get inDays => (_inDayRange(nDays)) ? nDays : -1;
  int get inWeeks => (_inWeekRange(nDays)) ? nDays ~/ kDaysInWeek : -1;
  int get inMonths => (_inMonthRange(nDays)) ? nDays ~/ kAgeDaysInMonth : -1;
  int get inYears => (_inYearRange(nDays)) ? nDays ~/ kAgeDaysInYear : -1;

  String get days => '${digits3(inDays)}D';
  String get weeks => '${digits3(inWeeks)}W';
  String get months => '${digits3(inMonths)}M';
  String get years => '${digits3(inYears)}Y';

  String get tokens => kAgeTokens;

  @override
  int get hashCode => nDays.hashCode;

  Age get acr => Age.parse('089Y');

  Age get sha256 => new Age(sha256AgeInDays(nDays));
  
  Age get hash => new Age(hashAgeInDays(nDays));

  String get hashString => ageToString(hashAgeInDays(nDays));

  /// Returns a valid [Age] [String] in highest precision.
  String get highest => toHighestPrecision(nDays);

  /// Returns a valid [Age] [String] in highest precision.
  String get normal => toNormalizedString(nDays);

  /// Returns a valid [Age] [String] in lowest precision.
  String get lowest => toLowestPrecision(nDays);

  /// Returns the Age as a [String] with the highest precision,
  /// i.e. the smallest possible units.  If the
  @override
  String toString() => normal;

  static int tryParseDays(String s, {bool allowLowercase = false}) =>
      tryParseAgeString(s, allowLowercase: allowLowercase);

  static int parseDays(String s, {Age onError(String s), bool allowLowercase = false}) =>
      parseAgeString(s, allowLowercase: allowLowercase);

  static Age tryParse(String s, {bool allowLowercase = true}) {
    final days = tryParseString(s);
    return (days == -1) ? null : new Age(days);
  }

  /// Returns the number of days corresponding to [s], which is a
  /// 4 character DICOM age (AS) [String]. [s] must be in the
  /// format: 'dddt', where 'd' is a decimal digit and 't' is an age
  /// token, one of "D", "W", "M", "Y". If [s] is invalid returns -1.
  static int tryParseString(String s, {bool allowLowercase = false}) {
    if (s == null || s.length != 4) return -1;

    final token = (allowLowercase) ? s[3].toUpperCase() : s[3];
    if (!kAgeTokens.contains(token)) return -1;

    //TODO: change to tryParse when available in Dart 2.0
    final n = int.parse(s.substring(0, 3), onError: (s) => -1);
    print('n: $n, d: "$token"');
    if (n == null || n < 0 || (n == 0 && token != 'D')) return -1;
    switch (token) {
      case 'D':
        return n;
      case 'W':
        return n * kDaysInWeek;
      case 'M':
        return n * kAgeDaysInMonth;
      case 'Y':
        return n * kAgeDaysInYear;
      default:
        return -1;
    }
  }

  static Age parse(String s, {Age onError(String s), bool allowLowercase = false}) {
    int days;
    try {
      days = parseAgeString(s, allowLowercase: allowLowercase);
    } on FormatException {
      if (onError != null) return onError(s);
      invalidAgeString(s);
      return null;
    }
    return new Age(days);
  }

  static bool isValid(int nDays) => isValidAge(nDays);

  static bool isValidString(String s) {
    if (tryParseAgeString(s) != -1) {
      return true;
    } else {
      invalidAgeString(s);
      return false;
    }
  }

  /// Returns a valid [Age] [String] in highest precision.
  String toHighestPrecision(int count) {
  //  if (!_inYearRange(count)) throw new InternalError('Invalid number of days: $count');
    if (_inDayRange(count)) return days;
    if (_inWeekRange(count)) return weeks;
    if (_inMonthRange(count)) return months;
    if (_inYearRange(count)) return years;
    return throw new InternalError('Invalid number of days: $count');
  }

  /// Returns a valid [Age] [String] in highest precision.
  String toNormalizedString(int count) {
    if (count > 365 && (count % 365 == 0)) return years;
    if (count > 30 && (count % 30 == 0)) return months;
    if (count > 7 && (count % 7 == 0)) return weeks;
    return days;
  }

  /// Returns a valid [Age] [String] in lowest precision.
  String toLowestPrecision(int count) {
    if (count > 365 && (count % 365 == 0)) return years;
    if (count > 30 && (count % 30 == 0)) return months;
    if (count > 7 && (count % 7 == 0)) return weeks;
    return toString();
  }
}
