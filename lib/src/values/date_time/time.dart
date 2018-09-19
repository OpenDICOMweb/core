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
import 'package:core/src/utils.dart';
import 'package:core/src/utils/date_time.dart';
import 'package:core/src/values/date_time/primitives/dcm_date_time.dart';
import 'package:core/src/values/date_time/primitives/time.dart';

// ignore_for_file: public_member_api_docs

typedef Time OnTimeError(int h, int m, int s, int ms, int us, Exception error);
typedef Time OnTimeParseError(String s);
typedef String OnTimeHashStringError(String s);

//Enhancement: should implement Comparable, add, subtract
/// A span of time. Similar to [Duration], but handles DICOM time (TM) values.
class Time implements Comparable<Time> {
  static const Time kMidnight = const Time.fromMicroseconds(0);
  static const Time zero = kMidnight;
  static const Time midnight = kMidnight;

  /// Internally [Time] is stored in microseconds.
  final int uSeconds;

  /// Creates a new Time object.
  factory Time(int h,
      [int m = 0,
      int s = 0,
      int ms = 0,
      int us = 0,
      Issues issues,
      OnTimeError onError]) {
    try {
      final uSecs = timeToMicroseconds(h, m, s, ms, us);
      return (uSecs == null) ? null : new Time.fromMicroseconds(uSecs);
    } on FormatException catch (e) {
      return (onError != null)
          ? onError(h, m, s, ms, us, e)
          : badTime(h, m, s, ms, us, issues, e);
    }
  }

  const Time.fromMicroseconds(int us) : uSeconds = us % kMicrosecondsPerDay;

  /// Returns `true` if this [Time] is the same as [other].
  @override
  bool operator ==(Object other) =>
      (other is Time) ? uSeconds == other.uSeconds : false;

  bool operator >(Time other) => uSeconds > other.uSeconds;

  bool operator <(Time other) => !(uSeconds > other.uSeconds);

  /// Returns `true` if this Duration is the same object as [other].
  Time operator +(Time other) =>
      new Time.fromMicroseconds(uSeconds + other.uSeconds);

  /// Returns `true` if this Duration is the same object as [other].
  Time operator -(Time other) =>
      new Time.fromMicroseconds(uSeconds - other.uSeconds);

  @override
  int get hashCode => uSeconds.hashCode;

  /// Returns a new [Time] containing the [hash] of _this_.
  Time get hash => new Time.fromMicroseconds(hashTimeMicroseconds(uSeconds));

  /// Returns a new [Time] containing the SHA-256 hash of [uSeconds].
  Time get sha256 => new Time.fromMicroseconds(sha256Microseconds(uSeconds));

  /// Returns the total number of _microseconds_ in _this_.
  int get inMicroseconds => uSeconds;

  /// Returns the total number of _milliseconds_ in _this_.
  int get inMilliseconds => uSeconds ~/ kMicrosecondsPerMillisecond;

  /// Returns the total number of _seconds_ in _this_.
  int get inSeconds => uSeconds ~/ kMicrosecondsPerSecond;

  /// Returns the total number of _minutes_ in _this_.
  int get inMinutes => uSeconds ~/ kMicrosecondsPerMinute;

  /// Returns the total number of _hours_ in _this_.
  int get inHours => uSeconds ~/ kMicrosecondsPerHour;

  /// Returns the [hour] as an integer.
  int get hour => inHours;

  /// Returns the [minute] as an integer.
  int get minute =>
      (uSeconds - (inHours * kMicrosecondsPerHour)) ~/ kMicrosecondsPerMinute;

  /// Returns the [second] as an integer.
  int get second =>
      (uSeconds - (inMinutes * kMicrosecondsPerMinute)) ~/
      kMicrosecondsPerSecond;

  /// Returns the [millisecond] as an integer.
  int get millisecond =>
      (uSeconds - (inSeconds * kMicrosecondsPerSecond)) ~/
      kMicrosecondsPerMillisecond;

  /// Returns the [microsecond] as an integer.
  int get microsecond =>
      uSeconds - (inMilliseconds * kMicrosecondsPerMillisecond);

  /// Returns the [fraction] of second as an integer.
  int get fraction => uSeconds - (inSeconds * kMicrosecondsPerSecond);

  /// Returns the [hour] as a 2 digit [String].
  String get h => digits2(hour);

  /// Returns the [minute] as a 2 digit [String].
  String get m => digits2(minute);

  /// Returns the [second] as a 2 digit [String].
  String get s => digits2(second);

  /// Returns the [millisecond] as a 3 digit [String].
  String get ms => digits3(millisecond);

  /// Returns the [microsecond] as a 3 digit [String].
  String get us => digits3(microsecond);

  /// Returns the [fraction] as a 6 digit [String].
  String get f => digits6(millisecond * 1000 + microsecond);

  /// Returns _this_ as a [String] in DICOM time (TM) format.
  String get dcm => microsecondToTimeString(uSeconds, asDicom: true);

  /// Returns _this_ as a [String] in Internet \[RFC3339\] _full-time_ format.
  String get inet => microsecondToTimeString(uSeconds, asDicom: false);

  /// Returns _this_ as a [Duration].
  Duration get asDuration => new Duration(microseconds: uSeconds);

  @override
  int compareTo(Time other) => compare(this, other);

  /// Returns a [String] containing the time. If [asDicom] is _true_ the
  /// result has the format "hhmmss.ffffff"; otherwise the format is
  /// "hh:mm:ss.ffffff".
  String timeToString({bool asDicom = true}) {
    final sb = new StringBuffer()..write(digits2(hour));
    if (!asDicom) sb.write(':');
    sb.write(digits2(minute));
    if (!asDicom) sb.write(':');
    sb
      ..write(digits2(second))
      ..write('.')
      ..write(digits3(millisecond))
      ..write(digits3(microsecond));
    return sb.toString();
  }

  @override
  String toString() => inet;

  /// Returns the current [Time].
  static Time get now {
    final dt = new DateTime.now();
    return new Time.fromMicroseconds(
        dt.microsecondsSinceEpoch + dt.timeZoneOffset.inMicroseconds);
  }

  /// Returns _true_ if [s] is a valid DICOM [Time] [String].
  static bool isValidString(String s,
          {int start = 0, int end, Issues issues}) =>
      isValidDcmTimeString(s, start: start, end: end, issues: issues);

  /// Returns a [Time] corresponding to [s], if [s] is valid;
  /// otherwise, returns _null_.
  static Time parse(String s,
      {int start = 0, int end, Issues issues, OnTimeParseError onError}) {
    final us = parseDcmTime(s, start: start, end: end);
    if (us == null)
      return (onError != null) ? onError(s) : badTimeString(s, issues);
    return new Time.fromMicroseconds(us);
  }

  /// Returns a [Issues] object if there are errors
  /// or warnings related to [s]; otherwise, returns _null_.
  static Issues issues(
    String s, {
    int start = 0,
    int end,
  }) {
    final issues = new Issues('Time: "$s"');
    parseDcmTime(s, issues: issues);
    return issues;
  }

  static int compare(Time a, Time b) {
    if (a == b) return 0;
    if (a > b) return 1;
    return -1;
  }

  /// Returns a new time [String] that is the hash of [s], which
  /// must be a [String] in DICOM Time (TM) format.
  static String hashString(String s) => hashDcmTimeString(s);

  /// Returns a new [List<String>] of DICOM time (DT) values, where each element
  /// in the [List] is the hash of the corresponding element in the argument.
  static List<String> hashStringList(List<String> times) {
    final tList = new List<String>(times.length);
    //for (String s in times) tList.add(hashString(s));
    for (var i = 0; i < times.length; i++) {
      final nTime = hashString(times[i]);
      tList[i] = nTime;
    }
    return tList;
  }
}
