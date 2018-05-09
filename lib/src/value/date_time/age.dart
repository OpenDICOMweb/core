//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/utils/date_time.dart';
import 'package:core/src/utils/errors.dart';
import 'package:core/src/utils/issues.dart';
import 'package:core/src/utils/parser.dart';
import 'package:core/src/utils/string/decimal.dart';
import 'package:core/src/utils/string/errors.dart';
import 'package:core/src/value/date_time/primitives/age.dart';

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

  static int parseDays(String s,
          {Age onError(String s), bool allowLowercase = false}) =>
      parseAgeString(s, allowLowercase: allowLowercase);

  static Age tryParse(String s, {bool allowLowercase = true}) {
    final days = tryParseString(s);
    return (days == -1) ? null : new Age(days);
  }

  /// Returns the number of days corresponding to [s], which is a
  /// 4 character DICOM age (AS) [String]. [s] must be in the
  /// format: 'dddt', where 'd' is a decimal digit and 't' is an age
  /// token, one of "D", "W", "M", "Y". If [s] is invalid returns -1.
  static int tryParseString(String s, {bool allowLowercase = false}) =>
      tryParseAgeString(s, allowLowercase: allowLowercase);

  static Age parse(String s,
      {Age onError(String s), bool allowLowercase = false}) {
    int days;
    try {
      days = parseAgeString(s, allowLowercase: allowLowercase);
    } on FormatException {
      if (onError != null) return onError(s);
      return badAgeString(s);
    }
    return new Age(days);
  }

  static bool isValid(int nDays) => isValidAge(nDays);

  static bool isValidString(String s, [Issues issues]) {
    if (tryParseAgeString(s) != -1) {
      return true;
    } else {
      if (issues != null) issues.add('Invalid Age String: "$s"');
      return badAgeString(s);
    }
  }

  /// Returns a valid [Age] [String] in highest precision.
  String toHighestPrecision(int count) {
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
