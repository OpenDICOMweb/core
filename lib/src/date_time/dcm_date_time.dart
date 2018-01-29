// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

import 'package:core/src/date_time/primitives/constants.dart';
import 'package:core/src/date_time/primitives/date.dart';
import 'package:core/src/date_time/primitives/dcm_date_time.dart';
import 'package:core/src/date_time/primitives/time.dart';
import 'package:core/src/date_time/time.dart';
import 'package:core/src/issues.dart';
import 'package:core/src/parser/parse_errors.dart';
import 'package:core/src/parser/parser.dart';
import 'package:core/src/string/number.dart';
import 'package:core/src/system/system.dart';

import 'date.dart';
import 'time.dart';
import 'time_zone.dart';

//TODO: should implement Comparable, add, subtract

typedef DcmDateTime OnDcmDateTimeError(
    int y, int m, int d, int h, int mm, int s, int ms, int us);
typedef DcmDateTime OnDcmDateTimeParseError(String s);
typedef String OnDcmDateTimeHashStringError(String s);

class DcmDateTime implements Comparable<DcmDateTime> {
  static const int kMinLength = 4;
  static const int kMaxLength = 26;

  static final DateTime start = new DateTime.now();
  static final String localTimeZoneName = start.timeZoneName;

  /// The local time zone offset in minutes.
  static final int localTZMinute = start.timeZoneOffset.inMinutes;

  /// The local time zone offset in microseconds.
  static final int localTZMicrosecond = start.timeZoneOffset.inMilliseconds;

  /// The local [TimeZone].
  static final TimeZone localTimeZone = new TimeZone.fromMicroseconds(localTZMinute);

  final int microseconds;

  //Urgent: Jim
  /// Creates a new [DcmDateTime] in the local time zone based on the arguments.
  factory DcmDateTime(int y,
      [int m = 0,
      int d = 0,
      int h = 0,
      int mm = 0,
      int s = 0,
      int ms = 0,
      int us = 0,
      int tzh = 0,
      int tzm = 0,
      ParseIssues issues,
      OnDcmDateTimeError onError]) {
    try {
      final date = dateToEpochMicroseconds(y, m, d);
      if (date == null) return null;
      final time = timeToMicroseconds(h, mm, s, ms, us);
      if (time == null) return null;
      if (date == null || time == null)
        return (onError != null)
            ? onError(y, m, d, h, mm, s, ms, us)
            : invalidDcmDateTimeError(y, m, d, h, mm, s, ms, us);
      return new DcmDateTime._(date + time + localTZMicrosecond);
    } on FormatException catch (e) {
      //Urgent Jim
      return invalidDcmDateTimeError(y, m, d, h, mm, s, ms, us, e);
    }
  }

  /// Creates a new [DcmDateTime] in UTC based on the arguments.
  factory DcmDateTime.utc(int y,
      [int m = 0, int d = 0, int h = 0, int mm = 0, int s = 0, int ms = 0, int us = 0]) {
    final day = dateToEpochMicroseconds(y, m, d);
    if (day == null) return null;
    final time = timeToMicroseconds(h, mm, s, ms, us);
    if (time == null) return null;
    return new DcmDateTime._(day + time);
  }

  //Note: This method relies on the fact that invalid Dates or Times cannot be created.
  /// Returns a [DcmDateTime] corresponding to [Date], [Time], and [TimeZone].
  /// If [TimeZone] is not provided, it defaults to the local time zone.
  DcmDateTime.fromDateTime(Date date, Time time, [TimeZone tz])
      : microseconds = date.microseconds + time.microsecond + tz.microseconds;

  /// Returns a [DcmDateTime] corresponding to a Dart [DateTime].
  factory DcmDateTime.fromDart(DateTime dt) {
    final eDay = dateToEpochMicroseconds(dt.year, dt.month, dt.day);
    if (eDay == null) return null;
    final us =
        timeToMicroseconds(dt.hour, dt.minute, dt.second, dt.millisecond, dt.microsecond);
    if (us == null) return null;
    final tzMicroseconds = dt.timeZoneOffset.inMicroseconds;
    return new DcmDateTime._(eDay + us + tzMicroseconds);
  }

  /// Internal constructor
  ///
  /// _Note_: All arguments MUST be valid.
  DcmDateTime._(this.microseconds);

  //TODO: unit test
  @override
  bool operator ==(Object other) =>
      other is DcmDateTime && microseconds == other.microseconds;

  //TODO: unit test
  bool operator >(DcmDateTime other) => microseconds > other.microseconds;

  //TODO: unit test
  bool operator <(DcmDateTime other) => !(microseconds > other.microseconds);

  @override
  int get hashCode => microseconds.hashCode;

  /// Returns a new [DateTime] containing the [System.hash] of _this_.
  DcmDateTime get hash => new DcmDateTime._(hashTimeMicroseconds(microseconds));

  //TODO: unit test
  /// Returns a new [DateTime] containing the SHA-256 hash of [microseconds].
  DcmDateTime get sha256 => new DcmDateTime._(sha256Microseconds(microseconds));

  int get epochDay => microseconds ~/ kMicrosecondsPerDay;

  int get timeInMicroseconds => microseconds % kMicrosecondsPerDay;

  /// Returns the [DcmDateTime] of _this_.
  TimeZone get timeZone => new TimeZone.fromMicroseconds(microseconds);

  @override
  int compareTo(DcmDateTime other) => compare(this, other);

  /// Returns the integer value of the _year_ component of _this_.
  int get year => epochDayToDate(epochDay)[0];

  /// Returns the integer value of the _month_ component of _this_.
  int get month => epochDayToDate(epochDay)[1];

  /// Returns the integer value of the _day_ component of _this_.
  int get day => epochDayToDate(epochDay)[2];

  /// Returns the integer value of the _hour_ component of _this_.
  int get hour => microseconds ~/ kMicrosecondsPerHour;

  /// Returns the integer value of the _minute_ component of _this_.
  int get minute => microseconds ~/ kMicrosecondsPerMinute;

  /// Returns the integer value of the _second_ component of _this_.
  int get second => microseconds ~/ kMicrosecondsPerSecond;

  /// Returns the integer value of the _millisecond_ component of _this_.
  int get millisecond => microseconds ~/ kMicrosecondsPerMillisecond;

  /// Returns the integer value of the _microsecond_ component of _this_.
  int get microsecond => microseconds % kMillisecondsPerDay;

  /// Returns the integer value of the _fraction_ of second component of _this_.
  int get fraction => microseconds % kMicrosecondsPerSecond;

  /// Returns the [year] as a 4 digit [String].
  String get y => digits4(year);

  /// Returns the [month] as a 2 digit [String].
  String get m => digits2(month);

  /// Returns the [day] as a 2 digit [String].
  String get d => digits2(day);

  /// Returns the [hour] as a 2 digit [String].
  String get h => digits2(hour);

  /// Returns the [minute] as a 2 digit [String].
  String get mm => digits2(minute);

  /// Returns the [second] as a 2 digit [String].
  String get s => digits2(second);

  /// Returns the [millisecond] as a 3 digit [String].
  String get ms => digits3(millisecond);

  /// Returns the [microsecond] as a 3 digit [String].
  String get us => digits3(microsecond);

  /// Returns the [fraction] as a 6 digit [String].
  String get f => digits6(millisecond * 1000 + microsecond);

  /// Returns the [DcmDateTime] in DICOM date (DA) [String] format.
  String get dcm => (fraction == 0) ? '$y$m$d$h$mm$s' : '$y$m$d$h$m$s.$f';

  /// Returns _this_ as a [String] in Internet \[RFC3339\] _date-time_ format.
  String get inet => (fraction == 0) ? '$y-$m-${d}T$h:$mm:$s' : '$y-$m-${d}T$h:$m:$s.$f';

  /// Returns the [DcmDateTime] in ISO date [String] format.
  @override
  String toString() => (fraction == 0) ? '$h:$m:$s' : '$h:$m:$s.$f';

  /// Returns the current [DcmDateTime].
  static DcmDateTime get now => new DcmDateTime.fromDart(new DateTime.now());

  /// Returns _true_ if [s] is a valid DICOM [DcmDateTime] [String] (DT).
  static bool isValidString(String s, {int start = 0, int end, Issues issues}) =>
      isValidDcmDateTimeString(s, start: start, end: end, issues: issues);

  /// Returns a DICOM [DcmDateTime], if [s] is a valid DT [String];
  static DcmDateTime parse(String s,
      {int start = 0, int end, ParseIssues issues, OnDcmDateTimeParseError onError}) {
    final dt = parseDcmDateTime(s, start: start, end: end);
    if (dt == null)
      return (onError != null) ? onError(s) : invalidDcmDateTimeString(s, issues);
    return new DcmDateTime._(dt);
  }

  /// Returns a [ParseIssues] object if there are errors or warnings related to [s];
  /// otherwise, returns _null_.
  static ParseIssues issues(String s, {int start = 0, int end}) {
    final issues = new ParseIssues('DcmDateTime', s);
    parseDcmDateTime(s, start: start, end: end, issues: issues);
    return issues;
  }

  static int compare(DcmDateTime a, DcmDateTime b) {
    if (a == b) return 0;
    if (a > b) return 1;
    return -1;
  }

  /// Returns a new DICOM date/time (DT) [String] that is the hash of the argument.
  static String hashString(String dateTime) {
    final dt = DcmDateTime.parse(dateTime);
    if (dt == null) return null;
    final h = dt.hash;
    return h.dcm;
  }

  /// Returns a new [List<String>] of DICOM date/time (DT) values, where each element
  /// in the [List] is the hash of the corresponding element in the argument.
  static List<String> hashStringList(List<String> dateTimes) {
    final dtList = new List<String>(dateTimes.length);
    // for (String s in dateTimes) dtList.add(hashString(s));
    for (var i = 0; i < dateTimes.length; i++) {
      final nDate = hashString(dateTimes[i]);
      dtList[i] = nDate;
    }
    return dtList;
  }
}

/// An invalid [DateTime] [Error].
class InvalidDcmDateTimeError extends Error {
  int y, m, d, h, mm, s, ms, us;
  Exception error;

  InvalidDcmDateTimeError(this.y,
      [this.m = 1,
      this.d = 1,
      this.h = 0,
      this.mm = 0,
      this.s = 0,
      this.ms = 0,
      this.us = 0,
      this.error]);

  @override
  String toString() => _msg(y, m, d, h, mm, s, ms, us, error);

  static String _msg(int y,
          [int m = 1,
          int d = 1,
          int h = 0,
          int mm = 0,
          int s = 0,
          int ms = 0,
          int us = 0,
          Exception error]) =>
      'invalidDcmDateTimeError: y: $y, m: $m, d: $d, '
      'h: $h, m: $m, s: $s, ms: $ms, us: $us'
      '\n  $error';
}

/// TODO
Null invalidDcmDateTimeError(int y,
    [int m,
    int d,
    int h,
    int mm = 0,
    int s = 0,
    int ms = 0,
    int us = 0,
    Exception error]) {
  log.error(InvalidDcmDateTimeError._msg(y, m, d, h, mm, s, ms, us, error));
  if (throwOnError) throw new InvalidDcmDateTimeError(y, d, m, h, mm, s, ms, us, error);
  return null;
}
