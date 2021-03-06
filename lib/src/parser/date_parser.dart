// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
part of odw.sdk.core.parser;

int parseDate(String s,
        {int start = 0, int end, Issues issues, OnParseError onError}) =>
    (s.contains('-'))
        ? parseInternetDate(s, start: start, end: end, issues: issues, onError: onError)
        : parseDcmDate(s, start: start, end: end, issues: issues, onError: onError);

/// Returns the Epoch Day in microseconds, which is negative if before
/// Epoch Day Zero, if [s] is valid; otherwise, returns [kInvalidEpochMicroseconds].
int parseDcmDate(String s,
    {int start = 0, int end, Issues issues, int onError(String s)}) {
  try {
    end ??= s.length;
    if (end != start + 8) {
      if (issues != null)
        issues.add('Date String "$s" has invalid length($end) it should be 8');
      // ignore: avoid_returning_null
      return null;
    }
    _checkArgs(s, start, end, 8, 8, 'parseDcmDate', issues);
    final eDayUS = _parseDate(s, start, issues);
    if (eDayUS == null) return (onError != null) ? onError(s) : null;
    return eDayUS;
  } on FormatException {
    return (onError != null) ? onError(s) : null;
  }
}

/// Returns the Epoch Day in microseconds.
int parseInternetDate(String s,
    {int start = 0, int end, Issues issues, int onError(String s)}) {
  try {
    end ??= s.length;
    if (s.length == 1 && s.codeUnitAt(0) == kZ || s.codeUnitAt(0) == kz) return 0;
    _checkArgs(s, start, end, 10, 10, 'parseInternetDate', issues);
    final v = s.replaceAll('-', '');
    final eDayUS = _parseDate(v, start, issues);
    if (eDayUS == null) return (onError != null) ? onError(s) : null;
    return eDayUS;
  } on FormatException {
    return (onError != null)
        ? onError(s)
        : invalidDateString('Bad Internet Date: "$s"');
  }
}

/// Returns true is [s] contains a valid DICOM date.
// Note: checkArgs is done by [parseDcmDate].
bool isValidDcmDateString(String s, {int start = 0, int end}) =>
    (parseDcmDate(s, start: start, end: end) == null) ? false : true;

List<int> dateStringListToMicroseconds(List<String> daList) => daList.map(parseDcmDate);

/// Returns a _normalized_ DICOM date (DA) [String], based on the _original_
/// date [String] and the _enrollment_ date [String}.
String normalizeDcmDateString(String s, String enrollment) {
  final oDay = parseDcmDate(s);
  if (oDay == null) return null;
  final eDay = parseDcmDate(enrollment);
  if (eDay == null) return null;
  return microsecondToDateString(oDay - (eDay - kACRBaselineDay));
}

typedef String OnHashDateStringError(String s);

/// Returns a new date [String] that is the hash of [s], which is a .
String hashDcmDateString(String s, {Issues issues, OnHashDateStringError onError}) {
  final us = parseDcmDate(s);
  if (us == null) {
    if (onError != null) return onError(s);
    return invalidDateString(s, issues);
  }
  return microsecondToDateString(hashDateMicroseconds(us));
}

/// Returns a new [List<String>] of DICOM date (DA) values, where
/// each element in the [List] is the hash of the corresponding
/// element in the argument.
Iterable<String> hashDcmDateDateStringList(List<String> dates) =>
    dates.map(hashDcmDateString);

// **** Internal below this line
// **** These functions do not do error checking, it was done above.

/// Returns a valid year or _null_.  The year must be 4 characters.
int _parseYear(String s, int start, Issues issues) =>
    _parse4Digits(s, start, issues, system.minYear, system.maxYear, 'year');

/// Returns a valid month or _null_.  The month must be 2 characters.
int _parseMonth(String s, int start, Issues issues) =>
    _parse2Digits(s, start, issues, 1, 12, 'month');

/// Returns a valid day or _null_.  The day must be 2 characters.
int _parseDay(int y, int m, String s, int start, Issues issues) {
  assert(y != null && m != null && s != null && start != null);
  final max = daysInLeapYearMonth[m];
  final d = _parse2Digits(s, start, issues, 1, max, 'day');
  return (m != 2) ? d : _checkDigitRange(d, 1, lastDayOfMonth(y, m), 'day', issues);
}

/// Returns a valid Epoch Day in microseconds or _null_.
int _parseDate(String s, int start, Issues issues) {
  assert(s != null && start != null);
  final y = _parse4Digits(s, start, issues, system.minYear, system.maxYear, 'year');
  assert(y != null);
  final m = _parse2Digits(s, start + 4, issues, 1, 12, 'month');
  assert(m != null);
  final max = daysInLeapYearMonth[m];
  var d = _parse2Digits(s, start + 6, issues, 1, max, 'day');
  assert(d != null);
  d = (m != 2) ? d : _checkDigitRange(d, 1, lastDayOfMonth(y, m), 'day', issues);
  assert(d != null);
  return dateToEpochMicroseconds(y, m, d);
}
