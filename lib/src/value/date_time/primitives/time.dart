//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//


import 'package:core/src/system.dart';
import 'package:core/src/utils/date_time.dart';
import 'package:core/src/utils/string.dart';
import 'package:core/src/value/date_time.dart';


// ignore_for_file: only_throw_errors
bool isValidTimeMicroseconds(int us) => us >= 0 && us <= kMicrosecondsPerDay;
bool isNotValidTimeMicroseconds(int us) => !isValidTimeMicroseconds(us);

int toTimeMicroseconds(int us) => us % kMicrosecondsPerDay;

/// Returns the microsecond that corresponds to the arguments.
int timeToMicroseconds(int h, [int m = 0, int s = 0, int ms = 0, int us = 0]) =>
    (!isValidTime(h, m, s, ms, us))
        ? invalidTimeError(h, m, s, ms, us)
        : internalTimeInMicroseconds(h, m, s, ms, us);

// *** No Error Checking
int internalTimeInMicroseconds(int h, int m, int s, int ms, int us) =>
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

typedef dynamic TimeToObject(int h, int m, int s, int ms, int us, {bool asDicom});

dynamic microsecondToTime(int time, TimeToObject creator, {bool asDicom = true}) {
  if (isNotValidTimeMicroseconds(time)) return null;
  final h = _hourFromTimeInUS(time);
  final m = _minuteFromTimeInUS(time % kMicrosecondsPerHour);
  final s = _secondFromTimeInUS(time % kMicrosecondsPerMinute);
  final ms = _hourFromTimeInUS(time % kMicrosecondsPerSecond);
  final us = _hourFromTimeInUS(time % kMicrosecondsPerMillisecond);
  return (creator != null)
      ? creator(h, m, s, ms, us, asDicom: asDicom)
      : _timeInUSToList(h, m, s, ms, us);
}

/// Returns a FThash of microsecond ([us]) that is in the
/// range: ```0 <= hash <= [kMicrosecondsPerDay]```.
int hashTimeMicroseconds(int us) => system.hash(us) % kMicrosecondsPerDay;

Iterable<int> hashTimeMicrosecondsList(List<int> daList) =>
    daList.map(hashTimeMicroseconds);

/// Returns a [String] corresponding to the microsecond ([us]). [us] must be
/// in the range 0 <= [us] < [kMicrosecondsPerDay].  If [asDicom] is _true_ the
/// format is 'hhmmss.ffffff'; otherwise the format is ''hh:mm:ss.ffffff'.
/// If [us] [isNotValidTimeMicroseconds] returns _null_.
String microsecondToTimeString(int us, {bool asDicom = true}) =>
    microsecondToTime(toTimeMicroseconds(us), timeToString, asDicom: asDicom);

/// Returns a [String] containing the time. If [asDicom] is _true_ the
/// result has the format "hhmmss.ffffff"; otherwise the format is
/// "hh:mm:ss.ffffff".
String timeToString(int h, int m, int s, int ms, int us, {bool asDicom = true}) {
  final sb = new StringBuffer()..write(digits2(h));
  if (!asDicom) sb.write(':');
  sb.write(digits2(m));
  if (!asDicom) sb.write(':');
  sb..write(digits2(s))..write('.')..write(digits3(ms))..write(digits3(us));
  return sb.toString();
}

// **** Internal Functions ****

List<int> _timeInUSToList(int h, int m, int s, int ms, int us) {
  final time = new List<int>(5);
  time[0] = h;
  time[1] = m;
  time[2] = s;
  time[3] = ms;
  time[4] = us;
  return time;
}

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
