//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/error/date_time_errors.dart';
import 'package:core/src/global.dart';
import 'package:core/src/utils/date_time.dart';
import 'package:core/src/utils/hash/sha256.dart' as sha256;
import 'package:core/src/utils/string.dart';
import 'package:core/src/values/date_time.dart';
import 'package:core/src/values/date_time/primitives/time.dart';

// ignore_for_file: public_member_api_docs

/// The minimum Unix Epoch day for this [Global].
final int kMinDcmDateTimeMicroseconds = global.minYear * kMicrosecondsPerDay;

/// The maximum Unix Epoch day for this [Global].
final int kMaxDcmDateTimeMicroseconds = global.maxYear * kMicrosecondsPerDay;

/// The total number of Epoch days valid for this [Global].
final int kDcmDateTimeSpan =
    kMaxDcmDateTimeMicroseconds - kMinDcmDateTimeMicroseconds;

bool isValidDateTimeMicroseconds(int us) => isValidEpochMicroseconds(us);
bool isNotValidDateTimeMicroseconds(int us) => !isValidEpochMicroseconds(us);

/// Returns
int dcmDateTimeInMicroseconds(
    int y, int m, int d, int h, int mm, int s, int ms, int us) {
  final day = (isValidDate(y, m, d))
      ? dateToEpochMicroseconds(y, m, d)
      : badDate(y, m, d);
  final time = (isValidTime(h, mm, s, ms, us))
      ? timeInMicroseconds(h, mm, s, ms, us)
      : badTime(h, m, d, ms, us);
  // ignore: avoid_returning_null
  if (day == null || time == null) return null;
  return day + time;
}

bool isValidDateTime(int y,
        [int m, int d, int h, int mm = 0, int s = 0, int ms = 0, int us = 0]) =>
    isValidDate(y, m, d) && isValidTime(h, mm, s, ms, us);

/// The [Type] of a function that takes a year, month, and date
/// and converts it to some object, e.g. a Date.
typedef DcmDateTimeToObject = Object Function(
    int y, int m, int d, int h, int mm, int s, int ms, int us);

/// Returns a hash of microsecond ([us]) that is in the
/// range: ```0 <= hash <= [kMicrosecondsPerDay]```.
int hashDateTimeMicroseconds(int us) => global.hash(us);

Iterable<int> hashDateTimeMicrosecondsList(List<int> daList) =>
    daList.map(hashDateTimeMicroseconds);

/// Returns a new Epoch microsecond that is a hash of [us].
int hashMicroseconds(int us, [int onError(int n)]) =>
    _hashMicroseconds(us, global.hash, onError);

/// Returns a new Epoch microsecond that is a SHA256 hash of [us].
int sha256Microseconds(int us, [int onError(int n)]) =>
    _hashMicroseconds(us, sha256.int64Bit, onError);

/// Returns a new Epoch microsecond that is a hash of [us].
///
/// _Note_: Dart [int]s can be larger than 63 bits. This check
/// makes sure that result is is a Dart SMI (small integer).
//TODO: when Dart 2.0 has 64 bit integers change this to use 64
// instead of 63 bits.
int _hashMicroseconds(int us, int hash(int v), [int onError(int n)]) {
  if (us < kMinYearInMicroseconds || us > kMaxYearInMicroseconds)
    return (onError == null) ? throw Error() : onError(us);
  var v = us;
  do {
    v = hash(v);
  } while (v <= kMicrosecondsPerDay);
  return (v.isNegative)
      ? v % kMinYearInMicroseconds
      : v % kMaxYearInMicroseconds;
}

String microsecondToDateTimeString(int epochMicrosecond,
    {bool asDicom = true}) {
  final epochDay = epochMicrosecond ~/ kMicrosecondsPerDay;
  final eDate = EpochDate.fromDay(epochDay);
  final time = microsecondToTime(epochMicrosecond % kMicrosecondsPerDay);
  // TODO: add real time zone
  final dt = dateTimeString(eDate.year, eDate.month, eDate.day, time.hour,
      time.minute, time.second, time.millisecond, time.microsecond,
      asDicom: asDicom);
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
  final dtSep = global.dateTimeSeparator;
  return asDicom
      ? '$yx$mx$dx$hx$mmx$sx$fx'
      : '$yx-$mx-$dx$dtSep$hx:$mmx:$sx$fx';
}

String inetDateTimeString(
        int y, int m, int d, int h, int mm, int s, int ms, int us,
        {bool truncate = false}) =>
    dateTimeString(y, m, d, h, mm, s, ms, us,
        asDicom: false, truncate: truncate);

String dicomDateTimeString(
        int y, int m, int d, int h, int mm, int s, int ms, int us,
        {bool truncate = false}) =>
    dateTimeString(y, m, d, h, mm, s, ms, us,
        asDicom: true, truncate: truncate);
