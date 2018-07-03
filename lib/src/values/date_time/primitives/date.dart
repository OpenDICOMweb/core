//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//


import 'package:core/src/global.dart';
import 'package:core/src/utils/date_time.dart';
import 'package:core/src/utils/string.dart';
import 'package:core/src/error/date_time_errors.dart';

/// A set of functions for handling dates in terms of
/// [Unix Epoch](https://en.wikipedia.org/wiki/Unix_time) days,
/// where day 0 of the Unix Epoch is 1970-01-01 (y=1970, m = 1, d = 1).
///
/// The algorithms for [dateToEpochDay] and [epochDayToDate] come from
/// http://howardhinnant.github.io/date_algorithms.html

final int kMinYear = global.minYear;
final int kMaxYear = global.maxYear;
final int kMinYearInMicroseconds =
    dateToEpochDay(kMinYear, 1, 1) * kMicrosecondsPerDay;
final int kMaxYearInMicroseconds =
    dateToEpochDay(kMaxYear, 1, 1) * kMicrosecondsPerDay;

/// The minimum Unix Epoch day for this [Global].
final int kMinEpochDay = _dateToEpochDay(kMinYear, 1, 1);

/// The maximum Unix Epoch day for this [Global].
final int kMaxEpochDay = _dateToEpochDay(kMaxYear, 12, 31);

/// The minimum Unix Epoch day for this [Global].
final int kMinEpochMicrosecond = kMinEpochDay * kMicrosecondsPerDay;

/// The maximum Unix Epoch day for this [Global].
final int kMaxEpochMicrosecond = ((kMaxEpochDay + 1) * kMicrosecondsPerDay) - 1;

/// The total number of Epoch microseconds valid for this [Global].
final int kEpochSpan = kMaxEpochMicrosecond - kMinEpochMicrosecond;

bool isValidEpochMicroseconds(int us) => _isValidEpochMicrosecond(us);
bool isNotValidEpochMicroseconds(int us) => _isNotValidEpochMicrosecond(us);

bool isValidEpochDay(int day) => day >= kMinEpochDay && day <= kMaxEpochDay;
bool isNotValidEpochDay(int day) => !isValidEpochDay(day);

/// Returns a valid DateTime microsecond. if [us] is out of range it is
/// clamped to the lower or upper bound for the Epoch.
int toValidEpochMicrosecond(int us) {
  if (us < kMinEpochMicrosecond) return kMinEpochMicrosecond;
  if (us > kMaxEpochMicrosecond) return kMaxEpochMicrosecond;
  return us;
}

/// Returns a valid DateTime microsecond. if [day] is out of range it is
/// clamped to the lower or upper bound for the Epoch.
int toValidEpochDay(int day) {
  if (day < kMinEpochDay) return kMinEpochDay;
  if (day > kMaxEpochDay) return kMaxEpochDay;
  return day;
}

bool isValidDateMicroseconds(int us) => isValidEpochMicroseconds(us);
bool isNotValidDateMicroseconds(int us) => !isValidDateMicroseconds(us);

//Flush if not used by V0.9.0
/// Returns a valid Date in [us]. if [us] is out of range it is
/// clamped to the lower or upper bound for the Epoch.
int toDateMicroseconds(int us) {
  if (us < kMinEpochMicrosecond) return kMinEpochMicrosecond;
  if (us > kMaxEpochMicrosecond) return kMaxEpochMicrosecond;
  return us;
}

/// Returns the Unix Epoch day. Negative values indicate days prior to day 0.
// Preconditions:
//     y-m-d represents a date in the (Gregorian) calendar
//     m is in [1, 12]
//     d is in [1, lastDayOfMonth(y, m)]
//     y is "approximately" in [min()/366, max()/366]
//     Exact range of validity is:
//         [epochFromDays(Int64.min), epochFromDays(Int64.max - 719468)]
//
// The following abbreviations are used in the following code:
//   - ny: normalized year to March 1
//   - era: a 400 year period
//   - yoe: year of ero
//   - doy: day of year
//   - doe: day of Epoch
//   - eDay: epoch day
//   - nm: normalized month number - March is 1
int dateToEpochDay(int y, int m, int d) => (_isValidDate(y, m, d))
    ? _dateToEpochDay(y, m, d)
    : invalidDate(y, m, d);

// This should only be called when y, m, and d are already validated.
int _dateToEpochDay(int y, int m, int d) {
  final ny = (m <= 2) ? y - 1 : y;
  final era = (ny >= 0 ? ny : ny - 399) ~/ 400;
  // [0, 399]
  final yoe = ny - (era * 400);
  // [0, 365]
  final doy = ((153 * (m + ((m > 2) ? -3 : 9))) + 2) ~/ 5 + (d - 1);
  // [0, 146096]
  final doe = (yoe * 365) + (yoe ~/ 4) - (yoe ~/ 100) + doy;
  return (era * 146097) + doe - 719468;
}

int dateToEpochMicroseconds(int y, int m, int d) => (_isValidDate(y, m, d))
    ? _dateToEpochMicroseconds(y, m, d)
    : badDate(y, m, d);

int _dateToEpochMicroseconds(int y, int m, int d) {
  final day = _dateToEpochDay(y, m, d);
  return (isValidEpochDay(day))
      ? day * kMicrosecondsPerDay
      : invalidDate(y, m, d);
}

bool isValidYearInMicroseconds(int us) =>
    us >= kMinYearInMicroseconds && us <= kMaxYearInMicroseconds;

int toValidYearInMicroseconds(int us) =>
    (us.isNegative) ? us % kMinYearInMicroseconds : us % kMaxYearInMicroseconds;

/// Returns _true_ if [y], [m], and [d] correspond to a valid Gregorian date.
bool isValidDate(int y, int m, int d) => _isValidDate(y, m, d);
bool isNotValidDate(int y, int m, int d) => !_isValidDate(y, m, d);

/// Returns _true_ if
/// ```[year] >= kMinYear && [year] <= [kMaxYear]```.
bool isValidYear(int year) => _isValidYear(year);

bool _isValidYear(int y) => _inRange(y, kMinYear, kMaxYear);

//TODO: remove if only used in tests
/// Returns [day] if valid; otherwise, calls [invalidEpochDay].
int checkEpochDay(int day) =>
    _isValidEpochDay(day) ? day : badEpochDay(day);

typedef dynamic DateToObject(int y, int m, int d, {bool asDicom});

Object epochMicrosecondToDate(int us,
        {DateToObject creator, bool asDicom = true}) =>
    _epochMicrosecondToDate(us, creator: creator, asDicom: asDicom);

Object _epochMicrosecondToDate(int us,
    {DateToObject creator, bool asDicom = true}) {
  if (_isNotValidEpochMicrosecond(us)) return null;
  final epochDay = us ~/ kMicrosecondsPerDay;
  return _epochDayToDate(epochDay, creator: creator, asDicom: asDicom);
}

/// Returns
/// [Gregorian Calendar](https://en.wikipedia.org/wiki/Gregorian_calendar)
/// year/month/day as a [list<int>] of length 3.
///
/// Preconditions:
///     z is number of days since 1970-01-01 and is in the range:
///         [epochFromDays(Int64.min), epochFromDays(Int64.max - 719468)]
dynamic epochDayToDate(int epochDay,
        {DateToObject creator, bool asDicom = true}) =>
    (_isValidEpochDay(epochDay))
        ? _epochDayToDate(epochDay, creator: creator, asDicom: asDicom)
        : null;

const int zeroCEDay = -719468;
const int daysInEra = 146097;

dynamic _epochDayToDate(int epochDay,
    {DateToObject creator, bool asDicom = true}) {
  if (isNotValidEpochDay(epochDay)) return invalidEpochDay(epochDay);
  final z = epochDay + 719468;
  final era = ((z >= 0) ? z : z - 146096) ~/ 146097;
  final doe = z - (era * 146097);
  final yoe = _yearOfEra(doe);
  final nYear = yoe + (era * 400);
  final doy = doe - ((365 * yoe) + (yoe ~/ 4) - (yoe ~/ 100)); // [0, 365]
  final nm = ((5 * doy) + 2) ~/ 153; // [0, 11]
  final d = doy - (((153 * nm) + 2) ~/ 5) + 1; // [1, 31]
  final m = nm + ((nm < 10) ? 3 : -9); // [1, 12]
  final y = (m <= 2) ? nYear + 1 : nYear;
  return (creator == null)
      ? _epochDayToList(y, m, d)
      : creator(y, m, d, asDicom: asDicom);
}

/// Returns the yearOfEra in number of days since Era Zero Day. The returned
/// values is in the range: `0 <= yearOfEra <= 399`.
int _yearOfEra(int doe) =>
    ((doe - (doe ~/ 1460)) + (doe ~/ 36524) - (doe ~/ 146096)) ~/ 365;

/// Returns _true_ if [y] is a leap year.
bool isLeapYear(int y) => _isLeapYear(y);

// Common years are computed as follows:
// If (year is not divisible by 4) then (it is a common year)
// else if (year is divisible by 100) then (it is a common year)
// else if (year is not divisible by 400) then (it is a common year)
// else (it is a leap year)
bool _isLeapYear(int y) => y % 4 == 0 && (y % 100 != 0 || y % 400 == 0);

/// Returns _true_ if [y] is a common year.
bool isCommonYear(int y) => !_isLeapYear(y);

/// Returns the [int] values of the last day in month [m] in year [y].
int lastDayOfMonth(int y, int m) =>
    (m != 2 || !isLeapYear(y)) ? daysInCommonYearMonth[m] : 29;

/// Returns an [int] between 0 and 6, with 0 corresponding to Sunday.
int weekdayFromEpochDay(int z) =>
    (z >= -4) ? (z + 4).remainder(7) : (z + 5).remainder(7) + 6;

typedef int OnWeekdayError(int x, [int y]);

/// Returns the number of days between weekday [x] and weekday [y].
/// Both [x] and [y] must be integers in the range 0 - 6.
int weekdayDifference(int x, int y, [OnWeekdayError onError]) {
  if (x < 0 || x > 6 && y < 0 || y > 6)
    return (onError == null) ? throw new Error() : onError(x, y);
  final n = (x >= y) ? x - y : (x + 7) - y;
  return n;
}

/// Returns the number of the  weekday _after_ [weekday].
/// Note: Always returns a number between 0 and 6.
int nextWeekday(int weekday, [OnWeekdayError onError]) {
  if (weekday < 0 || weekday > 6)
    return (onError == null) ? throw new Error() : onError(weekday);
  return (weekday < 6) ? weekday + 1 : 0;
}

/// Returns the number of the weekday _before_ [weekday].
/// Note: Always returns a number between 0 and 6.
int previousWeekday(int weekday, [OnWeekdayError onError]) {
  if (weekday < 0 || weekday > 6)
    return (onError == null) ? throw new Error() : onError(weekday);
  return weekday > 0 ? weekday - 1 : 6;
}

/// Returns a new Epoch microsecond that is a hash of [us].
int hashDateMicroseconds(int us, [int onError(int n)]) {
  // Note: Dart [int]s can be larger than 63 bits. This check makes
  // sure it is a Dart SMI (small integer).
  if (us < kMinEpochMicrosecond || us > kMaxEpochMicrosecond)
    return (onError == null) ? throw new Error() : onError(us);
  var v = us;
  do {
    v = global.hash(v);
  } while ((v <= kMicrosecondsPerDay));
  return (v.isNegative)
      ? v % kMinYearInMicroseconds
      : v % kMaxYearInMicroseconds;
}

/// Returns a new Epoch microsecond that is a hash of [epochDay].
int hash(int epochDay, [int onError(int n)]) {
  final v = global.hash(epochDay);
  return (v < 0) ? v % kMinEpochDay : v % kMaxEpochDay;
}

Iterable<int> hashDateMicrosecondsList(Iterable<int> daList) =>
    daList.map(hashDateMicroseconds);

//TODO: flush at V0.9.0 if not used
bool dateListsEqual(List<int> date0, List<int> date1) =>
    date0.length == 3 &&
    date1.length == 3 &&
    date0[0] == date1[0] &&
    date0[1] == date1[1] &&
    date0[2] == date1[2];

//TODO: flush at V0.9.0 if not used or move to test
/// Returns a [String] corresponding to [epochDay]. If [asDicom] is _true_
/// the format is 'yyyyddmm'; otherwise the format is 'yyyy-mm-dd'.
String epochDayToDateString(int epochDay, {bool asDicom = true}) =>
    (isValidEpochDay(epochDay))
        ? epochDayToDate(epochDay, creator: dateToString, asDicom: asDicom)
        : null;

/// Returns a [String] in the format yyyymmdd.
String microsecondToDateString(int us, {bool asDicom = true}) {
  if (isNotValidEpochMicroseconds(us)) return null;
  final epochDay = us ~/ kMicrosecondsPerDay;
  return epochDayToDate(epochDay, creator: dateToString, asDicom: asDicom);
}

String epochDayToString(int epochDay, {bool asDicom = false}) =>
    epochDayToDate(epochDay, creator: _dateToString, asDicom: asDicom);

/// Returns a [String] containing the date. If [asDicom] is _true_ the
/// result has the format "yyyymmdd"; otherwise the format is "yyyy-mm-dd".
String dateToString(int y, int m, int d, {bool asDicom = true}) =>
    (isNotValidDate(y, m, d)) ? null : _dateToString(y, m, d, asDicom: asDicom);

// Assumes y, m, and d are valid
String _dateToString(int y, int m, int d, {bool asDicom = false}) {
  final yy = digits4(y);
  final mm = digits2(m);
  final dd = digits2(d);
  return (asDicom) ? '$yy$mm$dd' : '$yy-$mm-$dd';
}

// **** Internal Functions ****

bool _inRange(int v, int min, int max) => v != null && v >= min && v <= max;

bool _isValidEpochDay(int eDay) =>
    eDay != null && eDay >= kMinEpochDay && eDay <= kMaxEpochDay;

bool _isValidEpochMicrosecond(int us) =>
    us != null && (us >= kMinEpochMicrosecond) && (us <= kMaxEpochMicrosecond);

bool _isNotValidEpochMicrosecond(int us) => !_isValidEpochMicrosecond(us);

bool _isValidMonth(int m) => _inRange(m, 1, 12);

bool _isValidDate(int y, int m, int d) {
  if (!_isValidYear(y) || !_isValidMonth(m)) return false;
  final lastDay =
      (m != 2) ? daysInCommonYearMonth[m] : (_isLeapYear(y)) ? 29 : 28;
  return _inRange(d, 1, lastDay);
}

List<int> _epochDayToList(int y, int m, int d) {
  final date = new List<int>(3);
  date[0] = y;
  date[1] = m;
  date[2] = d;
  return date;
}
