//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/error.dart';
import 'package:core/src/system.dart';
import 'package:core/src/utils/date_time.dart';
import 'package:core/src/utils/parser.dart';
import 'package:core/src/utils/string.dart';
import 'package:core/src/values/date_time/primitives/date.dart';
import 'package:core/src/values/date_time/primitives/dcm_date_time.dart';
import 'package:core/src/values/date_time/primitives/time.dart';

import 'date.dart';
import 'time.dart';
import 'time_zone.dart';

//TODO: should implement Comparable, add, subtract

/// The [Type] of [DcmDateTime] error handlers.
typedef DcmDateTime OnDcmDateTimeError(
    int y, int m, int d, int h, int mm, int s, int ms, int us);

/// The [Type] of [DcmDateTime] parsing error handlers.
typedef DcmDateTime OnDcmDateTimeParseError(String s);

/// The [Type] of [DcmDateTime] hashing error handlers.
typedef String OnDcmDateTimeHashStringError(String s);

/// DICOM Date/Time.
class DcmDateTime implements Comparable<DcmDateTime> {
  /// The [DcmDateTime] in microseconds.
  final int microseconds;

  /// Creates a new [DcmDateTime] in the local time zone based on the arguments.
  factory DcmDateTime(int y,
      [int m = 0,
      int d = 0,
      int h = 0,
      int mm = 0,
      int s = 0,
      int ms = 0,
      int us = 0,
// Urgent Jim Fix time zone not handled correctly
      int tzh = 0,
      int tzm = 0,
      Issues issues,
      OnDcmDateTimeError onError]) {
    try {
      final date = dateToEpochMicroseconds(y, m, d);
      final time = timeToMicroseconds(h, mm, s, ms, us);
      if (date == null || time == null)
        return (onError != null)
            ? onError(y, m, d, h, mm, s, ms, us)
            : invalidDcmDateTimeError(
                y, m, d, h, mm, s, ms, us, tzh, tzm, issues);
      return new DcmDateTime._(date + time + TimeZone.localInMicroseconds);
    } on FormatException catch (e) {
      return invalidDcmDateTimeError(
          y, m, d, h, mm, s, ms, us, tzh, tzm, issues, e);
    }
  }

  /// Creates a new [DcmDateTime] in UTC based on the arguments.
  factory DcmDateTime.utc(int y,
      [int m = 0,
      int d = 0,
      int h = 0,
      int mm = 0,
      int s = 0,
      int ms = 0,
      int us = 0]) {
    final day = dateToEpochMicroseconds(y, m, d);
    if (day == null) return null;
    final time = timeToMicroseconds(h, mm, s, ms, us);
    if (time == null) return null;
    return new DcmDateTime._(day + time);
  }

  /// Returns a [DcmDateTime] corresponding to [Date], [Time], and [TimeZone].
  /// If [TimeZone] is not provided, it defaults to the local time zone.
  //Note: Invalid Dates or Times cannot be created.
  DcmDateTime.fromDateTime(Date date, Time time, [TimeZone tz])
      : microseconds = date.microseconds + time.microsecond + tz.microseconds;

  /// Returns a [DcmDateTime] corresponding to a Dart [DateTime].
  factory DcmDateTime.fromDart(DateTime dt) {
    final eDay = dateToEpochMicroseconds(dt.year, dt.month, dt.day);
    if (eDay == null) return null;
    final us = timeToMicroseconds(
        dt.hour, dt.minute, dt.second, dt.millisecond, dt.microsecond);
    if (us == null) return null;
    final tzMicroseconds = dt.timeZoneOffset.inMicroseconds;
    return new DcmDateTime._(eDay + us + tzMicroseconds);
  }


  factory DcmDateTime.fromMicroseconds(int us) => new DcmDateTime._(us);
  /// Internal constructor
  ///
  /// _Note_: All arguments MUST be valid.
  DcmDateTime._(this.microseconds);

  @override
  bool operator ==(Object other) =>
      other is DcmDateTime && microseconds == other.microseconds;

  bool operator >(DcmDateTime other) => microseconds > other.microseconds;

  bool operator <(DcmDateTime other) => !(microseconds > other.microseconds);

  @override
  int get hashCode => microseconds.hashCode;

  /// Returns a new [DateTime] containing the [Global.hash] of _this_.
  DcmDateTime get hash => new DcmDateTime._(hashTimeMicroseconds(microseconds));

  /// Returns a new [DateTime] containing the SHA-256 hash of [microseconds].
  DcmDateTime get sha256 => new DcmDateTime._(sha256Microseconds(microseconds));

  int get epochDay => microseconds ~/ kMicrosecondsPerDay;

  int get timeInMicroseconds => microseconds % kMicrosecondsPerDay;

  /// Returns the [DcmDateTime] of _this_.
  TimeZone get timeZone => new TimeZone.fromMicroseconds(microseconds);

  @override
  int compareTo(DcmDateTime other) => compare(this, other);

  /// Returns the integer values of the _year_ component of _this_.
  int get year => epochDayToDate(epochDay)[0];

  /// Returns the integer values of the _month_ component of _this_.
  int get month => epochDayToDate(epochDay)[1];

  /// Returns the integer values of the _day_ component of _this_.
  int get day => epochDayToDate(epochDay)[2];

  /// Returns the integer values of the _hour_ component of _this_.
  int get hour => (microseconds ~/ kMicrosecondsPerHour) % 24;

  /// Returns the integer values of the _minute_ component of _this_.
  int get minute => (microseconds ~/ kMicrosecondsPerMinute) % 60;

  /// Returns the integer values of the _second_ component of _this_.
  int get second => (microseconds ~/ kMicrosecondsPerSecond) % 60;

  /// Returns the integer values of the _millisecond_ component of _this_.
  int get millisecond => (microseconds ~/ kMillisecondsPerDay) %  1000;

  /// Returns the integer values of the _microsecond_ component of _this_.
  int get microsecond => (microseconds ~/ kMicrosecondsPerDay) % 1000;

  /// Returns the integer values of the _fraction_ of second component of _this_.
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
  String get inet =>
      (fraction == 0) ? '$y-$m-$d\T$h:$mm:$s' : '$y-$m-${d}T$h:$mm:$s.$f';

  ///
  Date toDate() => new Date(year, month, day);

  static final Duration zeroDuration = new Duration();

  // TODO Jim Fix: if m >= 12 returns null
  // TODO Jim Doc
  /// See Dart Doc for [DateTime].[add].
  DcmDateTime add({int years, int months, int days, int hours,
      int minutes, int seconds, int milliseconds, int microseconds,
      Duration  duration}) {
    final y = (years == null) ? year : year + years;
    final m = (months == null) ? month : month + months;
    final d = (days == null) ? day : day + days;
    final h = (hours == null) ? hour : hour + hours;
    final mm = (minutes == null) ? minute : minute + minutes;
    final s = (seconds == null) ? second : second + seconds;
    final ms = (milliseconds == null) ? millisecond : millisecond + milliseconds;
    final us = (microseconds == null) ? microsecond : microsecond + microseconds;
    final dt = dcmDateTimeInMicroseconds(y, m, d, h, mm, s, ms, us);
    final dur = (duration == null) ? zeroDuration : duration;
    return new DcmDateTime._(dt + dur.inMicroseconds);
  }

  // TODO Jim Fix: if m >= 12 returns null
  // TODO Jim Doc
  DcmDateTime subtract({int years, int months, int days, int hours,
    int minutes, int seconds, int milliseconds, int microseconds,
    Duration  duration}) {
    final y = (years == null) ? year : year - years;
    final m = (months == null) ? month : month - months;
    final d = (days == null) ? day : day - days;
    final h = (hours == null) ? hour : hour - hours;
    final mm = (minutes == null) ? minute : minute - minutes;
    final s = (seconds == null) ? second : second - seconds;
    final ms = (milliseconds == null) ? millisecond : millisecond - milliseconds;
    final us = (microseconds == null) ? microsecond : microsecond - microseconds;
    final dt = dcmDateTimeInMicroseconds(y, m, d, h, mm, s, ms, us);
    final dur = (duration == null) ? zeroDuration : duration;
    return new DcmDateTime._(dt - dur.inMicroseconds);
  }

/* TODO: add if needed when with is no longer a keyword.
  DcmDateTime with({int years, int months, int days,
  int hours, int minutes, int seconds, int milliseconds, int microseconds,
  bool  isUtc}) {

  }
*/

  /// Returns the [DcmDateTime] in ISO date [String] format.
  @override
  String toString() => inet;

  /// Returns the current [DcmDateTime].
  static DcmDateTime get now => new DcmDateTime.fromDart(new DateTime.now());

  /// The minimum length of a [DcmDateTime] [String].
  static const int kMinLength = 4;

  /// The maximum length of a [DcmDateTime] [String].
  static const int kMaxLength = 26;

  /// The [DateTime] that this package was started.
//  static final DateTime start = new DateTime.now();

  /// The local [TimeZone].
  static final TimeZone localTimeZone =
      new TimeZone.fromMicroseconds(TimeZone.localInMicroseconds);

  /// The Time Zone where this package is running.
  static final String localTimeZoneName = TimeZone.localName;

  /// The local time zone offset in minutes.
  static final int localTZHour = TimeZone.local.hour;

  /// The local time zone offset in minutes.
  static final int localTZMinute = TimeZone.local.minute;


  /// Returns _true_ if [s] is a valid DICOM [DcmDateTime] [String] (DT).
  static bool isValidString(String s,
          {int start = 0, int end, Issues issues}) =>
      isValidDcmDateTimeString(s, start: start, end: end, issues: issues);

  /// Returns a DICOM [DcmDateTime], if [s] is a valid DT [String];
  static DcmDateTime parse(String s,
      {int start = 0,
      int end,
      Issues issues,
      OnDcmDateTimeParseError onError}) {
    final dt = parseDcmDateTime(s, start: start, end: end);
    if (dt == null)
      return (onError != null)
          ? onError(s)
          : badDateTimeString(s, issues);
    return new DcmDateTime._(dt);
  }

  /// Returns a [Issues] object if there are errors
  /// or warnings related to [s]; otherwise, returns _null_.
  static Issues issues(String s, {int start = 0, int end}) {
    final issues = new Issues('DcmDateTime: "$s"');
    parseDcmDateTime(s, start: start, end: end, issues: issues);
    return issues;
  }

  static int compare(DcmDateTime a, DcmDateTime b) {
    if (a == b) return 0;
    if (a > b) return 1;
    return -1;
  }

  /// Returns a new DICOM date/time (DT) [String] that is
  /// the hash of [dateTime].
  static String hashString(String dateTime) {
    final dt = DcmDateTime.parse(dateTime);
    if (dt == null) return null;
    final h = dt.hash;
    return h.dcm;
  }

  /// Returns a new [List<String>] of DICOM date/time (DT) values,
  /// where each element in the [List] is the hash of the corresponding
  /// element in the argument.
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
  int y, m, d, h, mm, s, ms, us, tzh, tzm;
  Exception error;

  /// Constructor
  InvalidDcmDateTimeError(this.y,
      [this.m = 1,
      this.d = 1,
      this.h = 0,
      this.mm = 0,
      this.s = 0,
      this.ms = 0,
      this.us = 0,
      this.tzh = 0,
      this.tzm = 0,
      this.error]);

  @override
  String toString() => _msg(y, m, d, h, mm, s, ms, us, tzh, tzm, error);

  static String _msg(int y,
          [int m = 1,
          int d = 1,
          int h = 0,
          int mm = 0,
          int s = 0,
          int ms = 0,
          int us = 0,
          int tzh = 0,
          int tzm = 0,
          Exception error]) => '''
InvalidDcmDateTimeError: $error
    y: $y, m: $m, d: $d, 
    h: $h, m: $m, s: $s, ms: $ms, us: $us
    tzh: $tzh, tzm: $tzm                        
'''  ;
}

/// The error handler for invalid [DcmDateTime]s.
Null invalidDcmDateTimeError(int y,
    [int m,
    int d,
    int h,
    int mm = 0,
    int s = 0,
    int ms = 0,
    int us = 0,
    int tzh = 0,
    int tzm = 0,
    Issues issues,
    Exception error]) {
  final msg = InvalidDcmDateTimeError._msg(y, m, d, h, mm, s, ms, us, tzh, tzm);
  log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError)
    throw new InvalidDcmDateTimeError(y, d, m, h, mm, s, ms, us, tzh, tzm);
  return null;
}
