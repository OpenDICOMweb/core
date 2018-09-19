//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/error/date_time_errors.dart';
import 'package:core/src/error/string_errors.dart';
import 'package:core/src/global.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/values/date_time/primitives/date.dart';
import 'package:core/src/values/date_time/primitives/dcm_date_time.dart';
import 'package:core/src/values/date_time/time.dart';

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
  static const int acrBaseline = kACRBaselineMicroseconds;

  /// The integer number of days since the Unix Epoch Day (1970-01-01),
  /// where positive numbers are after that day, and negative numbers are
  /// before that day.
  final int microseconds;

  /// Creates a [Date].
  factory Date(int y,
      [int m = 0, int d = 0, Issues issues, OnDateError onError]) {
    try {
      final microseconds = dateToEpochMicroseconds(y, m, d);
      return (microseconds == null) ? null : new Date._(microseconds);
    } on FormatException catch (e) {
      return (onError != null)
          ? onError(y, m, d)
          : invalidDate(y, m, d, issues, e);
    }
  }

  /// Creates a [Date].
  Date._(this.microseconds);

  @override
  bool operator ==(Object other) =>
      other is Date && microseconds == other.microseconds;

  bool operator >(Date other) => microseconds > other.microseconds;

  bool operator <(Date other) => !(microseconds > other.microseconds);

  @override
  int get hashCode => microseconds.hashCode;

  /// Returns a new [Date] containing the [Global].[hash] hash
  /// of [microseconds].
  Date get hash => new Date._(hashDateInMicroseconds(microseconds));

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
    return new Date._(dt.microsecondsSinceEpoch);
  }

  /// Returns the day of the [year] of _this_.
  int get dayInYear => epochDay - _epochDayOfCurrentYear;

  /// Returns the [epochDay] of the first day of the [year].
  int get _epochDayOfCurrentYear {
    final firstOfYear = new DateTime(year, 1, 1);
    return firstOfYear.microsecondsSinceEpoch ~/ kMicrosecondsPerDay;
  }

  /// Returns the integer values of the current weekday, where Sunday is day 0.
  int get weekday => weekdayFromEpochDay(epochDay);

  /// Returns a [String] containing the name (in English) of the [day].
  String get weekdayName => weekdayNames[weekday];

  /// Returns true if this occurs after other.
  bool isAfter(Date other) => microseconds > other.microseconds;

  /// Returns true if this occurs before other.
  bool isBefore(Date other) => !isAfter(other);

  //TODO: unit test to verify
  /// Returns a new [Date] whose values is _this_ + other.microseconds;
  Date add(Time other) => new Date._(microseconds + other.uSeconds);

  /// Returns a new [Date] whose values is _this_ + other.microseconds;
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

  /// Returns a new [Date] that is equal to the Epoch Day.
  static Date fromEpochDay(int epochDay) =>
      new Date._(epochDay * kMicrosecondsPerDay);

  // Urgent remove
  static bool isAllBlanks(String s, int start, [int end]) {
    end ??= s.length;
    for (var i = start; i < end; i++)
      if (s.codeUnitAt(i) != kSpace) return false;
    return true;
  }

  /// Returns a [Date] corresponding to [s], if [s] is valid;
  /// otherwise, returns _null_.
  static Date parse(String s,
      {int start = 0,
      int end,
      Issues issues,
      bool isDicom = true,
      OnDateParseError onError}) {
    // Urgent Jim: fix
    if (s == null || s.isEmpty) return null;
    // Urgent Jim: do this in parse of dateTime, time, Integer, Decimal, Uri...
    if (isAllBlanks(s, start, end))
      return global.allowBlankDateTimes
          ? null
          : (onError != null) ? onError(s) : badDateString(s, issues);
    final us = (isDicom)
        ? parseDicomDate(s, start: start, end: end)
        : parseInternetDate(s, start: start, end: end);
    if (us == null) {
      return (onError != null) ? onError(s) : badDateString(s, issues);
    }
    return new Date._(us);
  }

  /// Returns _true_ if [s] is a valid DICOM [Date] [String].
  static bool isValidString(String s,
          {int start = 0, int end, Issues issues}) =>
      isValidDcmDateString(s, start: start, end: end, issues: issues);

  /// Returns a [Issues] object if there are errors or warnings related to [s];
  /// otherwise, returns _null_.
  static Issues issues(String s,
      {int start = 0, int end, int min = 0, int max}) {
    final issues = new Issues('Date: "$s"');
    parseDicomDate(s, issues: issues);
    return issues;
  }

  static int compare(Date a, Date b) {
    if (a == b) return 0;
    if (a > b) return 1;
    return -1;
  }
  //Enhancement:
  // Returns a new Date based on the _fixed_ values of [s].
  // Date fix(s)

  /// Returns a new date [String] that is the hash of the argument.
  static String hashString(String s,
      {Issues issues, OnDateHashStringError onError}) {
    final us = parseDicomDate(s);
    if (us == null) {
      if (onError != null) return onError(s);
      return invalidParseStringToString('Invalid Date String: $s', issues);
    }
    final hd = hashDateInMicroseconds(us);
    return microsecondToDateString(hd);
  }

  static int hashDateInMicroseconds(int us) {
    var hd = global.hash(us);
    hd = hd.abs();
    if (hd > kEpochSpan) hd = hd % kEpochSpan;
    return hd + kMinEpochMicrosecond;
  }

  static int hashEpochDay(int epochDay) {
    var hd = global.hash(epochDay);
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
    final dateInUSecs = parseDicomDate(date);
    if (dateInUSecs == null) return null;
    final offsetFromBaseline = enrollment.microseconds - acrBaseline;
    final normalInUSecs = dateInUSecs - offsetFromBaseline;
    return microsecondToDateString(normalInUSecs);
  }

  /// Returns a [List<String>] of DICOM date (DA) values, where each element in the
  /// [List] is the _normalized_ values of the corresponding element in the argument.
  static Iterable<String> normalizeStrings(
      List<String> sList, Date enrollment) {
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

List<int> dateStringListToMicroseconds(List<String> daList) =>
    daList.map(parseDicomDate);

/// Returns a _normalized_ DICOM date (DA) [String], based on the _original_
/// date [String] and the _enrollment_ date [String}.
String normalizeDcmDateString(String s, String enrollment) {
  final oDay = parseDicomDate(s);
  if (oDay == null) return null;
  final eDay = parseDicomDate(enrollment);
  if (eDay == null) return null;
  return microsecondToDateString(oDay - (eDay - kACRBaselineDay));
}

typedef String OnHashDateStringError(String s);

/// Returns a new date [String] that is the hash of [s], which is a .
String hashDcmDateString(String s,
    {Issues issues, OnHashDateStringError onError}) {
  final us = parseDicomDate(s);
  if (us == null) {
    if (onError != null) return onError(s);
    return badDateString(s, issues);
  }
  return microsecondToDateString(hashDateMicroseconds(us));
}

/// Returns a new [List<String>] of DICOM date (DA) values, where
/// each element in the [List] is the hash of the corresponding
/// element in the argument.
Iterable<String> hashDcmDateDateStringList(List<String> dates) =>
    dates.map(hashDcmDateString);
