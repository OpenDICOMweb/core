// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:core/src/date_time/primitives/constants.dart';
import 'package:core/src/date_time/primitives/date.dart';
import 'package:core/src/date_time/primitives/errors.dart';
import 'package:core/src/date_time/primitives/time.dart';
import 'package:core/src/hash/sha256.dart' as sha256;
import 'package:core/src/string/number.dart';
import 'package:core/src/system/system.dart';

/// The minimum Unix Epoch day for this [System].
final int kMinDcmDateTimeMicroseconds = system.minYear * kMicrosecondsPerDay;

/// The maximum Unix Epoch day for this [System].
final int kMaxDcmDateTimeMicroseconds = system.maxYear * kMicrosecondsPerDay;

/// The total number of Epoch days valid for this [System].
final int kDcmDateTimeSpan = kMaxDcmDateTimeMicroseconds - kMinDcmDateTimeMicroseconds;

bool isValidDateTimeMicroseconds(int us) => isValidEpochMicroseconds(us);
bool isNotValidDateTimeMicroseconds(int us) => !isValidEpochMicroseconds(us);

/// Returns
int dcmDateTimeInMicroseconds(int y, int m, int d, int h, int mm, int s, int ms, int us) {
  final day = (isValidDate(y, m, d))
      ? dateToEpochMicroseconds(y, m, d)
      : invalidDateError(y, m, d);
  final time = (isValidTime(h, mm, s, ms, us))
      ? internalTimeInMicroseconds(h, mm, s, ms, us)
      : invalidTimeError(y, m, d);
  // ignore: avoid_returning_null
  if (day == null || time == null) return null;
  return day + time;
}

bool isValidDateTime(int y,
        [int m, int d, int h, int mm = 0, int s = 0, int ms = 0, int us = 0]) =>
    isValidDate(y, m, d) && isValidTime(h, mm, s, ms, us);

/// The [Type] of a function that takes a year, month, and date
/// and converts it to some object, e.g. a Date.
typedef dynamic DcmDateTimeToObject(
    int y, int m, int d, int h, int mm, int s, int ms, int us);

/* Flush if not used by V0.9.0
dynamic microsecondToDateTime(int us, DcmDateTimeToObject creator) {
  int y, m, d, h, mm, s, ms, us;

  dynamic getDate(int yy, int mm, int dd, {bool asDicom = true}) {
    y = yy;
    m = mm;
    d = dd;
    return true;
  }


  dynamic getTime(int hh, int mmmm, int ss, int msms, int usus, {bool asDicom = true}) {
    h = hh;
    mm = mmmm;
    s = ss;
    ms = msms;
    us = usus;
    return true;
  }

  int epochDay = us ~/ kMicrosecondsPerDay;
  int time = us % kMicrosecondsPerDay;
  String tz = timeZoneToString()
  epochDayToDate(epochDay, getDate);

  microsecondsToTime(time, getTime);
  return (creator != null)
      ? creator(y, m, d, h, mm, s, ms, us)
      : _dateTimeToList(y, m, d, h, mm, s, ms, us);
}

List<int> _dateTimeToList(
    int y, int m, int d, int h, int mm, int s, int ms, int us) {
  var dt = new List<int>(5);
  dt[0] = y;
  dt[1] = m;
  dt[2] = d;
  dt[3] = h;
  dt[4] = mm;
  dt[5] = s;
  dt[6] = ms;
  dt[7] = us;
  return dt;
}

*/

/// Returns a hash of microsecond ([us]) that is in the
/// range: ```0 <= hash <= [kMicrosecondsPerDay]```.
int hashDateTimeMicroseconds(int us) => system.hash(us);

Iterable<int> hashDateTimeMicrosecondsList(List<int> daList) =>
    daList.map(hashDateTimeMicroseconds);

/// Returns a new Epoch microsecond that is a hash of [us].
int hashMicroseconds(int us, [int onError(int n)]) =>
    _hashMicroseconds(us, system.hash, onError);

/// Returns a new Epoch microsecond that is a SHA256 hash of [us].
int sha256Microseconds(int us, [int onError(int n)]) =>
    _hashMicroseconds(us, sha256.int63, onError);

/// Returns a new Epoch microsecond that is a hash of [us].
///
/// _Note_: Dart [int]s can be larger than 63 bits. This check
/// makes sure that result is is a Dart SMI (small integer).
//TODO: when Dart 2.0 has 64 bit integers change this to use 64 instead of 63 bits.
int _hashMicroseconds(int us, int hash(int v), [int onError(int n)]) {
  if (us < kMinYearInMicroseconds || us > kMaxYearInMicroseconds)
    return (onError == null) ? throw new Error() : onError(us);
  var v = us;
  do {
    v = hash(v);
  } while ((v <= kMicrosecondsPerDay));
  return (v.isNegative) ? v % kMinYearInMicroseconds : v % kMaxYearInMicroseconds;
}

String microsecondToDateTimeString(int dtus, {bool asDicom = true}) {
  int y, m, d, h, mm, s, ms, us;

  dynamic getDate(int yy, int mm, int dd, {bool asDicom = true}) {
    y = yy;
    m = mm;
    d = dd;
    return true;
  }

  dynamic getTime(int hh, int mmmm, int ss, int msms, int usus, {bool asDicom = true}) {
    h = hh;
    mm = mmmm;
    s = ss;
    ms = msms;
    us = usus;
    return true;
  }

  final epochDay = dtus ~/ kMicrosecondsPerDay;
  epochDayToDate(epochDay, creator: getDate, asDicom: asDicom);
  final time = dtus % kMicrosecondsPerDay;
  microsecondToTime(time, getTime, asDicom: asDicom);
  //Urgent: add real time zone
  final dt = dateTimeToString(y, m, d, h, mm, s, ms, us, asDicom: asDicom);
  return '$dt+0000';
}

//TODO: decide if needed at V0.9.0
String dateTimeToString(int y, int m, int d, int h, int mm, int s, int ms, int us,
    {bool asDicom = true, bool truncate = false}) {
  final yx = digits4(y);
  final mx = digits2(m);
  final dx = digits2(d);
  final hx = digits2(h);
  final mmx = digits2(mm);
  final sx = digits2(s);
  final f = (truncate && us == 0 && ms == 0) ? '' : '.${digits3(ms)}${digits3(us)}';
  return asDicom ? '$yx$mx$dx$hx$mmx$sx$f' : '$yx-$mx-$dx\T$hx:$mmx:$sx$f';
}

String inetDateTime(int y, int m, int d, int h, int mm, int s, int ms, int us,
    {bool asDicom = true}) {
  final yx = digits4(y);
  final mx = digits2(m);
  final dx = digits2(d);
  final hx = digits2(h);
  final mmx = digits2(mm);
  final sx = digits2(s);
  final f = (us == 0 && ms == 0) ? '' : '.${digits3(ms)}${digits3(us)}';
  return asDicom ? '$yx$mx$dx$hx$mmx$sx$f' : '$yx-$mx-$dx\T$hx:$mmx:$sx$f';
}

///Returns a human-readable string for the current local time in Internet format.
String dtToDateString(DateTime dt) {
  final dt = new DateTime.now();
  final y = digits4(dt.year);
  final m = digits2(dt.month);
  final d = digits2(dt.day);
  return '$y-$m-$d';
}

///Returns a human-readable string for the current local time in Internet format.
String dtToTimeString(DateTime dt, {bool asDicom = true, bool hasFraction = false}) {
  final dt = new DateTime.now();
  final h = digits2(dt.hour);
  final min = digits2(dt.minute);
  final sec = digits2(dt.second);
  final ms = digits3(dt.millisecond);
  final us = digits3(dt.microsecond);
  if (hasFraction) {
    return (asDicom) ? '$h$min$sec.$ms$us' : '$h:$min:$sec.$ms$us';
  } else {
    return (asDicom) ? '$h$min$sec' : '$h:$min:$sec';
  }
}

///Returns a human-readable string for the current local time in Internet format.
String dtToDateTimeString(DateTime dt, {bool hasFraction = false}) =>
    '${dtToDateString(dt)}T${dtToTimeString(dt)}';
