//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:base/base.dart';
import 'package:core/src/global.dart';
import 'package:core/src/values/date_time.dart';
import 'package:core/src/utils.dart';

// ignore_for_file: only_throw_errors
// ignore_for_file: public_member_api_docs

/// Returns the hour part of microseconds ([us]).
int microsecondsToHour(int us) => us ~/ kMicrosecondsPerHour;

/// Returns the minute part of microseconds ([us]).
int microsecondToMinute(int us) =>
    (us - (microsecondsToHour(us) * kMicrosecondsPerHour)) ~/
        kMicrosecondsPerMinute;

/// Returns the second part of microseconds ([us]).
int microsecondsToSecond(int us) =>
    (us - (microsecondToMinute(us) * kMicrosecondsPerMinute)) ~/
        kMicrosecondsPerSecond;

/// Returns the millisecond part of microseconds ([us]).
int microsecondsToMillisecond(int us) =>
    (us - (microsecondsToSecond(us) * kMicrosecondsPerSecond)) ~/
        kMicrosecondsPerMillisecond;

/// Returns the microsecond part of microseconds ([us]).
int microsecondsToMicrosecond(int us) =>
    us - (microsecondsToMillisecond(us) * kMicrosecondsPerMillisecond);

/// Returns the fraction part of microseconds ([us]).
int microsecondsToFraction(int us) =>
    us - (microsecondsToSecond(us) * kMicrosecondsPerSecond);

// Unit test
String microsecondsToString(int us) {
  final h = microsecondsToHour(us);
  final m = microsecondToMinute(us);
  final s = microsecondsToSecond(us);
  final f = microsecondsToFraction(us);
  return '${digits2(h)}${digits2(m)}${digits2(s)}.${digits6(f)}';
}

/// Returns a new time [String] that is the hash of the [s] argument.
String hashDcmTimeString(String s) {
  var us = parseDicomTime(s);
  if (us == null) return null;
  us = hashTimeMicroseconds(us);
  return microsecondsToString(us);
}

bool isValidTimeMicroseconds(int us) => us >= 0 && us <= kMicrosecondsPerDay;
bool isNotValidTimeMicroseconds(int us) => !isValidTimeMicroseconds(us);

int toTimeMicroseconds(int us) => us % kMicrosecondsPerDay;

/// Returns the microsecond that corresponds to the arguments.
int timeToMicroseconds(int h, [int m = 0, int s = 0, int ms = 0, int us = 0]) =>
    (!isValidTime(h, m, s, ms, us))
        ? badTime(h, m, s, ms, us)
        : timeInMicroseconds(h, m, s, ms, us);

// *** No Error Checking
int timeInMicroseconds(int h, int m, int s, int ms, int us) =>
    kMicrosecondsPerHour * h +
    kMicrosecondsPerMinute * m +
    kMicrosecondsPerSecond * s +
    kMicrosecondsPerMillisecond * ms +
    us;

bool isValidTime(int h, [int m = 0, int s = 0, int ms = 0, int us = 0]) =>
    _isValidHour(h) &&
    _isValidMinute(m) &&
    _isValidSec(s) &&
    _isValidMSec(ms) &&
    _isValidUSec(us);

bool isValidHour(int h) => _isValidHour(h);

bool isValidMinute(int m) => _isValidMinute(m);

bool isValidSecond(int s) => _isValidSec(s);

bool isValidMillisecond(int ms) => _isValidMSec(ms);

bool isValidMicrosecond(int us) => _isValidUSec(us);

bool isValidSecondFraction(int f) => _inRange(f, 0, 999999);

int hourFromMicrosecond(int us) =>
    _inRange(us, 0, kMicrosecondsPerDay) ? _hourFromTimeInUS(us) : null;

int minuteFromMicrosecond(int us) =>
    _inRange(us, 0, kMicrosecondsPerDay) ? _minuteFromTimeInUS(us) : null;

int secondFromMicrosecond(int us) =>
    _inRange(us, 0, kMicrosecondsPerDay) ? _secondFromTimeInUS(us) : null;

int millisecondFromMicrosecond(int us) =>
    _inRange(us, 0, kMicrosecondsPerDay) ? _millisecondFromTimeInUS(us) : null;

int microsecondFromMicrosecond(int us) =>
    _inRange(us, 0, kMicrosecondsPerDay) ? _microsecondFromTimeInUS(us) : null;

int fractionFromMicrosecond(int us) =>
    _inRange(us, 0, kMicrosecondsPerDay) ? _fractionFromTimeInUS(us) : null;

typedef TimeToObject = Object Function(int h, int m, int s, int ms, int us,
    {bool asDicom});

Time microsecondToTime(int timeInUS) {
  if (isNotValidTimeMicroseconds(timeInUS)) return null;
  final h = _hourFromTimeInUS(timeInUS);
  final m = _minuteFromTimeInUS(timeInUS % kMicrosecondsPerHour);
  final s = _secondFromTimeInUS(timeInUS % kMicrosecondsPerMinute);
  final ms = _millisecondFromTimeInUS(timeInUS % kMicrosecondsPerSecond);
  final us = _microsecondFromTimeInUS(timeInUS % kMicrosecondsPerMillisecond);
  return Time(h, m, s, ms, us);
}

/// Returns a FThash of microsecond ([us]) that is in the
/// range: ```0 <= hash <= [kMicrosecondsPerDay]```.
int hashTimeMicroseconds(int us) => global.hash(us) % kMicrosecondsPerDay;

Iterable<int> hashTimeMicrosecondsList(List<int> daList) =>
    daList.map(hashTimeMicroseconds);

/// Returns a [String] corresponding to the microsecond ([us]). [us] must be
/// in the range 0 <= [us] < [kMicrosecondsPerDay].  If [asDicom] is _true_ the
/// format is 'hhmmss.ffffff'; otherwise the format is ''hh:mm:ss.ffffff'.
/// If [us] [isNotValidTimeMicroseconds] returns _null_.
String microsecondToTimeString(int us, {bool asDicom = true}) =>
    microsecondToTime(us % kMicrosecondsPerDay).timeToString(asDicom: asDicom);

// **** Internal Functions ****

bool _inRange(int v, int min, int max) => v != null && v >= min && v <= max;

bool _isValidHour(int h) => _inRange(h, 0, 23);

bool _isValidMinute(int h) => _inRange(h, 0, 59);

//TODO: add leap seconds
// Note: this doesn't handle leap seconds
bool _isValidSec(int h) => _inRange(h, 0, 59);

bool _isValidMSec(int h) => _inRange(h, 0, 999);

bool _isValidUSec(int h) => _inRange(h, 0, 999);

int _hourFromTimeInUS(int us) => us ~/ kMicrosecondsPerHour;

int _minuteFromTimeInUS(int us) => us ~/ kMicrosecondsPerMinute;

int _secondFromTimeInUS(int us) => us ~/ kMicrosecondsPerSecond;

int _millisecondFromTimeInUS(int us) => us ~/ kMicrosecondsPerMillisecond;

int _microsecondFromTimeInUS(int us) => us % kMicrosecondsPerHour;

int _fractionFromTimeInUS(int us) => us % kMicrosecondsPerSecond;
