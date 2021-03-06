// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/date_time/primitives/constants.dart';
import 'package:core/src/date_time/primitives/date_time.dart';
import 'package:core/src/date_time/primitives/errors.dart';
import 'package:core/src/date_time/primitives/time.dart';
import 'package:core/src/issues.dart';
import 'package:core/src/parser/parse_errors.dart';
import 'package:core/src/parser/parser.dart';
import 'package:core/src/string/string.dart';

typedef Time OnTimeError(int h, int m, int s, int ms, int us);
typedef Time OnTimeParseError(String s);
typedef String OnTimeHashStringError(String s);

//Enhancement: should implement Comparable, add, subtract
/// A span of time. Similar to [Duration], but handles DICOM time (TM) values.
class Time implements Comparable<Time>{
  static const Time midnight = const Time._(0);
  static const Time zero = midnight;
  static const Time kMidnight = const Time._(0);

  /// Internally [Time] is stored in microseconds.
  final int microseconds;


  /// Creates a new Time object.
  factory Time(int h,
      [int m = 0,
      int s = 0,
      int ms = 0,
      int us = 0,
      ParseIssues issues,
      OnTimeError onError]) {
    try {
      final uSecs = timeToMicroseconds(h, m, s, ms, us);
      return (uSecs == null) ? null : new Time._(uSecs);
    } on FormatException catch (e) {
      //Urgent Jim
      return invalidTimeError(h, m, s, ms, us, e);
    }
  }
  //Internal constructor - hidden when exported:
  factory Time.fromMicroseconds(int uSecs) {
    if (uSecs > kMicrosecondsPerDay)
      return invalidTimeMicrosecondsError(uSecs);
    return new Time._(uSecs);
  }

  const Time._(this.microseconds);

  /// Returns `true` if this [Time] is the same as [other].
  @override
  bool operator ==(Object other) =>
      (other is Time) ? microseconds == other.microseconds : false;

  //TODO: unit test
  bool operator >(Time other) => microseconds > other.microseconds;

  //TODO: unit test
  bool operator <(Time other) => !(microseconds > other.microseconds);

  //TODO: unit test to verify
  /// Returns `true` if this Duration is the same object as [other].
  Time operator +(Time other) =>
      new Time._(microseconds + other.microseconds);

  //TODO: unit test to verify
  /// Returns `true` if this Duration is the same object as [other].
  Time operator -(Time other) =>
     new Time._(microseconds - other.microseconds);

  @override
  int get hashCode => microseconds.hashCode;

  //TODO: unit test
  /// Returns a new [Time] containing the [hash] of _this_.
  Time get hash => new Time._(hashTimeMicroseconds(microseconds));

  //TODO: unit test
  /// Returns a new [Time] containing the SHA-256 hash of [microseconds].
  Time get sha256 => new Time._(sha256Microseconds(microseconds));

  /// Returns the total number of _microseconds_ in _this_.
  int get inMicroseconds => microseconds;

  /// Returns the total number of _milliseconds_ in _this_.
  int get inMilliseconds => microseconds ~/ kMicrosecondsPerMillisecond;

  /// Returns the total number of _seconds_ in _this_.
  int get inSeconds => microseconds ~/ kMicrosecondsPerSecond;

  /// Returns the total number of _minutes_ in _this_.
  int get inMinutes => microseconds ~/ kMicrosecondsPerMinute;

  /// Returns the total number of _hours_ in _this_.
  int get inHours => microseconds ~/ kMicrosecondsPerHour;

  /// Returns the [hour] as an integer.
  int get hour => inHours;

  /// Returns the [minute] as an integer.
  int get minute =>
      (microseconds - (inHours * kMicrosecondsPerHour)) ~/ kMicrosecondsPerMinute;

  /// Returns the [second] as an integer.
  int get second =>
      (microseconds - (inMinutes * kMicrosecondsPerMinute)) ~/ kMicrosecondsPerSecond;

  /// Returns the [millisecond] as an integer.
  int get millisecond =>
      (microseconds - (inSeconds * kMicrosecondsPerSecond)) ~/
      kMicrosecondsPerMillisecond;

  /// Returns the [microsecond] as an integer.
  int get microsecond => microseconds - (inMilliseconds * kMicrosecondsPerMillisecond);

  /// Returns the [fraction] of second as an integer.
  int get fraction => microseconds - (inSeconds * kMicrosecondsPerSecond);

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

  Time get now {
    final dt = new DateTime.now();
    return new Time(dt.hour, dt.minute, dt.second, dt.millisecond, dt.millisecond);
  }

  /// Returns _this_ as a [String] in DICOM time (TM) format.
  String get dcm => microsecondToTimeString(microseconds, asDicom: true);

  /// Returns _this_ as a [String] in Internet \[RFC3339\] _full-time_ format.
  String get inet => microsecondToTimeString(microseconds, asDicom: false);

  /// Returns _this_ as a [Duration].
  Duration get asDuration => new Duration(microseconds: microseconds);

  @override
  int compareTo(Time other) => compare(this, other);

  @override
  String toString() => inet;

  /// Returns _true_ if [s] is a valid DICOM [Time] [String].
  static bool isValidString(String s, {int start = 0, int end}) =>
      isValidDcmTimeString(s, start: start, end: end);

  // Enhancement: all parse functions should take an onError argument.
  // Issue: are start, end, min, and max needed.
  /// Returns a [Time] corresponding to [s], if [s] is valid; otherwise, returns _null_.
  static Time parse(String s,
      {int start = 0, int end, ParseIssues issues, OnTimeParseError onError}) {
    final us = parseDcmTime(s, start: start, end: end);
    if (us == null)
      return (onError != null) ? onError(s) : invalidTimeString(s, issues);
    return new Time._(us);
  }

  /// Returns a [ParseIssues] object if there are errors or warnings related to [s];
  /// otherwise, returns _null_.
  static ParseIssues issues(
    String s, {
    int start = 0,
    int end,
  }) {
    final issues = new ParseIssues('Time', s);
    parseDcmTime(s, issues: issues);
    return issues;
  }

  static int compare(Time a, Time b) {
	  if (a == b)
	    return 0;
	  if (a > b)
	    return  1;
	  return -1;
  }


  /// Returns a new time [String] that is the hash of [s], which
  /// must be a [String] in DICOM Time (TM) format.
  static String hashString(String s) =>
		  hashDcmTimeString(s);


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
