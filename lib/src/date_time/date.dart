// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

import 'package:core/src/date_time/primitives/constants.dart';
import 'package:core/src/date_time/primitives/date.dart';
import 'package:core/src/date_time/primitives/dcm_date_time.dart';
import 'package:core/src/date_time/primitives/errors.dart';
import 'package:core/src/date_time/time.dart';
import 'package:core/src/issues.dart';
import 'package:core/src/parser/parse_errors.dart';
import 'package:core/src/parser/parser.dart';
import 'package:core/src/string/number.dart';
import 'package:core/src/system/system.dart';

typedef Date OnDateError(int y, int m, int d);
typedef Date OnDateParseError(String s);
typedef String OnDateHashStringError(String s);

/// A DICOM Date.
class Date implements Comparable<Date> {
  static const int minLength = 8;
  static const int maxLength = 8;

  static const List<String> weekdayNames = const <String>[
    'Sunday', 'Monday', 'Tuesday', 'Wednesday',
    'Thursday', 'Friday', 'Saturday' // no reformat
  ];

  /// The American College of Radiology _baseline_ date in microseconds
  /// for de-identifying [Date]s.
  static final int acrBaseline = kACRBaselineMicroseconds;

  /// The integer number of days since the Unix Epoch Day (1970-01-01),
  /// where positive numbers are after that day, and negative numbers are
  /// before that day.
  final int microseconds;

  /// Creates a [Date].
  factory Date(int y,
      [int m = 0, int d = 0, ParseIssues issues, OnDateError onError]) {
    try {
      final microseconds = dateToEpochMicroseconds(y, m, d);
      return (microseconds == null) ? null : new Date._(microseconds);
    } on FormatException catch (e) {
      return invalidDateError(y, m, d, e);
    }
  }

  //Urgent Jim
  //Issue: Internal constructor - should be hidden when exported:
  factory Date.fromEpochDay(int epochDay) =>
      new Date._(epochDay * kMicrosecondsPerDay);

  /// Creates a [Date].
  Date._(this.microseconds);

  @override
  bool operator ==(Object other) =>
      other is Date && microseconds == other.microseconds;

  bool operator >(Date other) => microseconds > other.microseconds;

  bool operator <(Date other) => !(microseconds > other.microseconds);

  @override
  int get hashCode => microseconds.hashCode;

  //Urgent Jim to fix
  //Urgent Sharath: unit test
  /// Returns a new [Date] containing the [System].[hash] hash
  /// of [microseconds].
  Date get hash => new Date._(hashDateInMicroseconds(microseconds));

  //Urgent Jim to fix
  //Urgent Sharath: unit test
  //TODO: unit test
  /// Returns a new [Date] containing the SHA-256 hash of [microseconds].
  Date get sha256 => new Date._(sha256Microseconds(microseconds));

  /// The [epochDay] corresponding to this [Date].
  int get epochDay => microseconds ~/ kMicrosecondsPerDay;

  /// Returns the [year] of this [Date] as an integer.
  int get year => _yearFromEpochDay(epochDay);

  /// Returns the [month] as an integer.
  int get month => _monthFromEpochDay(epochDay);

  /// Returns the [day] as an integer.
  int get day => _dayFromEpochDay(epochDay);

  /// Returns the [year] as a 4 digit [String].
  String get y => digits4(year);

  /// Returns the [month] as a 2 digit [String].
  String get m => digits2(month);

  /// Returns the [day] as a 2 digit [String].
  String get d => digits2(day);

  //Issue: How secure does date hashing have to be?

  /// Returns _this_ as a DICOM date (DA) [String].
  String get dcm => microsecondToDateString(microseconds);

  /// Returns _this_ as a [String] in Internet \[RFC3339\] _full-date_ format.
  String get inet => microsecondToDateString(microseconds, asDicom: false);

  /// Returns the current [Date].
  Date get today {
    final dt = new DateTime.now();
    return new Date(dt.year, dt.month, dt.day);
  }

  /// Returns the integer value of the current weekday, where Sunday is day 0.
  int get weekday => weekdayFromEpochDay(epochDay);

  /// Returns a [String] containing the name (in English) of the [day].
  String get weekdayName => weekdayNames[weekday];

  /// Returns true if this occurs after other.
  bool isAfter(Date other) => microseconds > other.microseconds;

  /// Returns true if this occurs before other.
  bool isBefore(Date other) => !isAfter(other);

  //TODO: unit test to verify
  /// Returns a new [Date] whose value is _this_ + other.microseconds;
  Date add(Time other) => new Date._(microseconds + other.uSeconds);

  /// Returns a new [Date] whose value is _this_ + other.microseconds;
  Date difference(Time other) => new Date._(microseconds - other.uSeconds);

  @override
  int compareTo(Date other) => compare(this, other);

  /// Returns a new _normalized_ date based on the subject's [enrollment] [Date].
  ///
  /// The [original] [Date] is returned as a _Normalized_ [Date],  which is
  /// computed as follows:
  ///     ```normalizedDate = originalDate - (enrollmentDate - acrBaselineDate)```
  /// where
  ///     ```original``` is the original date, i.e. [_epochDay],
  ///     ```enrollment``` is the subjects date of enrollment in a clinical
  ///     study, and ```acrBaseline``` is January 1, 1960.
  Date normalize(Date enrollment) => new Date._(
      microseconds - (enrollment.microseconds - kACRBaselineMicroseconds));

  /// Returns a [Date] [String] in Internet format.
  @override
  String toString() => inet;

  /// Returns a [Date] corresponding to [s], if [s] is valid;
  /// otherwise, returns _null_.
  static Date parse(String s,
      {int start = 0, int end, ParseIssues issues, OnDateParseError onError}) {
    final us = parseDcmDate(s, start: start, end: end);
    if (us == null) {
      return (onError != null) ? onError(s) : invalidDateString(s, issues);
    }
    return new Date._(us);
  }

  /// Returns _true_ if [s] is a valid DICOM [Date] [String].
  static bool isValidString(String s,
          {int start = 0, int end, Issues issues}) =>
      isValidDcmDateString(s, start: start, end: end, issues: issues);

  /// Returns a [ParseIssues] object if there are errors or warnings related to [s];
  /// otherwise, returns _null_.
  static ParseIssues issues(String s,
      {int start = 0, int end, int min = 0, int max}) {
    final issues = new ParseIssues('Date', s);
    parseDcmDate(s, issues: issues);
    return issues;
  }

  static int compare(Date a, Date b) {
    if (a == b) return 0;
    if (a > b) return 1;
    return -1;
  }
  //Enhancement:
  // Returns a new Date based on the _fixed_ value of [s].
  // Date fix(s)

  /// Returns a new date [String] that is the hash of the argument.
  static String hashString(String s,
      {ParseIssues issues, OnDateHashStringError onError}) {
    final us = parseDcmDate(s);
    if (us == null) {
      if (onError != null) return onError(s);
      return invalidParseStringToString('Invalid Date String: $s', issues);
    }
    final hd = hashDateInMicroseconds(us);
    return microsecondToDateString(hd);
  }

  static int hashDateInMicroseconds(int us) {
    var hd = system.hash(us);
    hd = hd.abs();
    if (hd > kEpochSpan) hd = hd % kEpochSpan;
    return hd + kMinEpochMicrosecond;
  }

  static int hashEpochDay(int epochDay) {
    var hd = system.hash(epochDay);
    hd = hd.abs();
    if (hd > kEpochSpan) hd = hd % kEpochSpan;
    return hd + kMinEpochDay;
  }

  static int hashDate(Date date) {
    var hash = hashDateInMicroseconds(date.microseconds);
    hash = hash.abs() % kEpochSpan;
    return hash + kMinEpochDay;
  }

  /// Returns a new [List<String>] of DICOM date (DA) values, where each element
  /// in the [List] is the hash of the corresponding element in the argument.
  static List<String> hashStringList(List<String> dates) {
    final dList = new List<String>(dates.length);
    //for (String s in dates) dList.add(hashString(s));
    for (var i = 0; i < dates.length; i++) {
      final nDate = hashString(dates[i]);
      dList[i] = nDate;
    }
    return dList;
  }

  /// Returns a _normalized_ DICOM date (DA) [String], based on the _original_
  /// date [String] and the _enrollment_ date [String}.
  static String normalizeString(String date, Date enrollment) {
    if (date == null || enrollment == null) return null;
    final dateInUSecs = parseDcmDate(date);
    if (dateInUSecs == null) return null;
    final offsetFromBaseline = enrollment.microseconds - acrBaseline;
    final normalInUSecs = dateInUSecs - offsetFromBaseline;
    return microsecondToDateString(normalInUSecs);
  }

  /// Returns a [List<String>] of DICOM date (DA) values, where each element in the
  /// [List] is the _normalized_ value of the corresponding element in the argument.
  static List<String> normalizeStrings(List<String> sList, Date enrollment) {
    final rList = new List<String>(sList.length);
    for (var i = 0; i < rList.length; i++) {
      final nDate = normalizeString(sList[i], enrollment);
      if (nDate == null) return null;
      rList[i] = nDate;
    }
    return rList;
  }

  // **** internal
  int _yearFromEpochDay(int z) => epochDayToDate(z)[0];
  int _monthFromEpochDay(int z) => epochDayToDate(z)[1];
  int _dayFromEpochDay(int z) => epochDayToDate(z)[2];
}
