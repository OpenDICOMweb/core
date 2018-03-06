// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:core/src/system/system.dart';
import 'package:core/src/utils/date_time.dart';
import 'package:core/src/utils/hash/sha256.dart' as sha256;
import 'package:core/src/utils/string.dart';
import 'package:core/src/value/date_time.dart';
import 'package:core/src/value/date_time/primitives/errors.dart';
import 'package:core/src/value/date_time/primitives/time.dart';

/// The minimum Unix Epoch day for this [System].
final int kMinDcmDateTimeMicroseconds = kMinYear * kMicrosecondsPerDay;

/// The maximum Unix Epoch day for this [System].
final int kMaxDcmDateTimeMicroseconds = kMaxYear * kMicrosecondsPerDay;

/// The total number of Epoch days valid for this [System].
final int kDcmDateTimeSpan =
    kMaxDcmDateTimeMicroseconds - kMinDcmDateTimeMicroseconds;

bool isValidDateTimeMicroseconds(int us) => isValidEpochMicroseconds(us);
bool isNotValidDateTimeMicroseconds(int us) => !isValidEpochMicroseconds(us);

/// Returns
int dcmDateTimeInMicroseconds(
    int y, int m, int d, int h, int mm, int s, int ms, int us) {
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
  return (v.isNegative)
      ? v % kMinYearInMicroseconds
      : v % kMaxYearInMicroseconds;
}

String microsecondToDateTimeString(int epochMicrosecond,
    {bool asDicom = true}) {
  int y, m, d, h, mm, s, ms, us;

  dynamic getDate(int yy, int mm, int dd, {bool asDicom = true}) {
    y = yy;
    m = mm;
    d = dd;
    return true;
  }

  dynamic getTime(int hh, int mmmm, int ss, int msms, int usus,
      {bool asDicom = true}) {
    h = hh;
    mm = mmmm;
    s = ss;
    ms = msms;
    us = usus;
    return true;
  }

  final epochDay = epochMicrosecond ~/ kMicrosecondsPerDay;
  epochDayToDate(epochDay, creator: getDate, asDicom: asDicom);
  final time = epochMicrosecond % kMicrosecondsPerDay;
  microsecondToTime(time, getTime, asDicom: asDicom);
  // TODO: add real time zone
  final dt = dateTimeString(y, m, d, h, mm, s, ms, us, asDicom: asDicom);
  return '$dt+0000';
}

//TODO: decide if needed at V0.9.0
String dateTimeString(int y, int m, int d, int h, int mm, int s, int ms, int us,
    {bool asDicom = true, bool truncate = false}) {
  final yx = digits4(y);
  final mx = digits2(m);
  final dx = digits2(d);
  final hx = digits2(h);
  final mmx = digits2(mm);
  final sx = digits2(s);
  final fx =
      (truncate && us == 0 && ms == 0) ? '' : '.${digits3(ms)}${digits3(us)}';
  final dtSep = system.dateTimeSeparator;
  return asDicom
      ? '$yx$mx$dx$hx$mmx$sx$fx'
      : '$yx-$mx-$dx$dtSep$hx:$mmx:$sx$fx';
}

String inetDateTimeString(
        int y, int m, int d, int h, int mm, int s, int ms, int us,
        {bool truncate: false}) =>
    dateTimeString(y, m, d, h, mm, s, ms, us,
        asDicom: false, truncate: truncate);

String dicomDateTimeString(
        int y, int m, int d, int h, int mm, int s, int ms, int us,
        {bool truncate: false}) =>
    dateTimeString(y, m, d, h, mm, s, ms, us,
        asDicom: true, truncate: truncate);
