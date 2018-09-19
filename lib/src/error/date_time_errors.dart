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

// ignore_for_file: public_member_api_docs

typedef int OnAgeError(String s);

class DateTimeError extends Error {
  final String message;

  DateTimeError(this.message);

  @override
  String toString() => message;
}

Null _doError(String msg, [Issues issues]) {
  log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError) throw new DateTimeError(msg);
  return null;
}

/// An invalid age error. Returns null;
Null badAge(int age, [Issues issues]) {
  final msg = 'InvalidAgeError: $age is an invalid number of days for Age';
  return _doError(msg, issues);
}

/// An invalid age error. Returns false;
bool invalidAge(int age) {
  badAge(age);
  return false;
}

/// An invalid date error. Returns null;
Null badDate(int y, int m, int d, [Issues issues, Exception e]) {
  final msg = 'InvalidDateError: $e (y = $y, m = $m, d = $d)';
  return _doError(msg);
}

/// An invalid date error. Returns false;
bool invalidDate(int y, int m, int d, [Issues issues, Exception e]) {
  badDate(y, m, d, issues, e);
  return false;
}

/// An invalid weekday error. Returns null;
Null badWeekday(int weekday) {
  final msg = 'InvalidWeekdayError: $weekday';
  return _doError(msg);
}

/// An invalid weekday error. Returns false;
bool invalidWeekday(int weekday) {
  badWeekday(weekday);
  return false;
}

/// An invalid epoch day error. Returns null;
Null badEpochDay(int microseconds) {
  final msg = 'InvalidEpochDayError: $microseconds';
  return _doError(msg);
}

/// An invalid epoch day error. Returns false;
bool invalidEpochDay(int microseconds) {
  badEpochDay(microseconds);
  return false;
}

/// An invalid Time error. Returns null.
Null badTime(int h,
    [int m = 0,
    int s = 0,
    int ms = 0,
    int us = 0,
    Issues issues,
    Exception error]) {
  final msg =
      'InvalidTimeError: h = $h, m = $m, s = $s, ms = $ms, us = $us\n  $error';
  return _doError(msg);
}

bool invalidTime(int h,
    [int m = 0,
    int s = 0,
    int ms = 0,
    int us = 0,
    Issues issues,
    Exception error]) {
  badTime(h, m, s, ms, us, issues);
  return false;
}

/// An invalid time in microseconds error. Returns null.
Null badTimeMicroseconds(int us) {
  final msg = 'invalidTimeMicrosecondsError: us = $us';
  _doError(msg);
  return null;
}

/// An invalid time in microseconds error. Returns null.
bool invalidTimeMicroseconds(int us) {
  badTimeMicroseconds(us);
  return false;
}
