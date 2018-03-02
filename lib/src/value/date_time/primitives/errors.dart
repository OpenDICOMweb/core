// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:core/src/system/system.dart';
import 'package:core/src/utils/issues.dart';

typedef int OnAgeError(String s);

class InvalidAgeError extends Error {
  final int days;

  InvalidAgeError(this.days);

  @override
  String toString() => _msg(days);

  static String _msg(int days) => 'InvalidAgeError: $days is an invalid'
      ' number of days for Age';
}

Null invalidAgeError(int age) {
  final msg = InvalidAgeError._msg(age);
  log.error(msg);
  if (throwOnError) throw new InvalidAgeError(age);
  return null;
}

/// An invalid [DateTime] [Error].
class InvalidDateError extends Error {
  int y, m, d;
  Exception error;

  InvalidDateError(this.y, this.m, this.d, this.error);

  @override
  String toString() => _msg(y, m, d, error);

  static String _msg(int y, int m, int d, Exception e) =>
      'InvalidDateError: $e (y = $y, m = $m, d = $d)';
}

Null invalidDateError(int y, int m, int d, [Issues issues, Exception e]) {
  final msg = InvalidDateError._msg(y, m, d, e);
  log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError) throw new InvalidDateError(y, m, d, e);
  return null;
}

/// An invalid [DateTime] [Error].
class InvalidWeekdayError extends Error {
  int weekday;

  InvalidWeekdayError(this.weekday);

  @override
  String toString() => _msg(weekday);

  static String _msg(int weekday) => 'InvalidWeekdayError: $weekday';
}

Null invalidWeekdayError(int weekday) {
  log.error(InvalidWeekdayError._msg(weekday));
  if (throwOnError) throw new InvalidWeekdayError(weekday);
  return null;
}

/// An invalid [DateTime] [Error].
class InvalidEpochDayError extends Error {
  int microseconds;

  InvalidEpochDayError(this.microseconds);

  @override
  String toString() => _msg(microseconds);

  static String _msg(int epochDay) => 'InvalidEpochDayError: $epochDay';
}

Null invalidEpochDayError(int microseconds) {
  log.error(InvalidEpochDayError._msg(microseconds));
  if (throwOnError) throw new InvalidEpochDayError(microseconds);
  return null;
}

/// An invalid [DateTime] [Error].
class InvalidTimeError extends Error {
  int h, m, s, ms, us;
  Exception error;

  InvalidTimeError(this.h,
      [this.m = 0, this.s = 0, this.ms = 0, this.us = 0, this.error]);

  @override
  String toString() => _msg(h, m, s, ms, us, error);

  static String _msg(int h,
          [int m = 0, int s = 0, int ms = 0, int us = 0, Exception error]) =>
      'InvalidTimeError: h = $h, m = $m, s = $s, ms = $ms, us = $us\n  $error';
}

Null invalidTimeError(int h,
    [int m = 0,
    int s = 0,
    int ms = 0,
    int us = 0,
    Issues issues,
    Exception error]) {
  final msg = InvalidTimeError._msg(h, m, s, ms, us, error);
  log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError) throw new InvalidTimeError(h, m, s, ms, us, error);
  return null;
}

/// An invalid [DateTime] [Error].
class InvalidTimeMicrosecondsError extends Error {
  int us;

  InvalidTimeMicrosecondsError(this.us);

  @override
  String toString() => _msg(us);

  static String _msg(int us) => 'invalidTimeMicrosecondsError: us = $us';
}

Null invalidTimeMicrosecondsError(int us) {
  log.error(InvalidTimeMicrosecondsError._msg(us));
  if (throwOnError) throw new InvalidTimeMicrosecondsError(us);
  return null;
}
