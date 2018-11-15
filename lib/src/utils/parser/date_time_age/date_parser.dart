//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.core.parser;

/// Parses a date. If [s] contains a '-', it is parsed as an Internet
/// date; otherwise, as a DICOM date.
/// Returns the Epoch Day in microseconds, which is negative if before
/// Epoch Day Zero, if [s] is valid; otherwise, returns
/// [kInvalidEpochMicroseconds].
int parseDate(String s, {int start = 0, int end, Issues issues}) =>
    (s.contains('-'))
        ? parseInternetDate(s, start: start, end: end, issues: issues)
        : parseDicomDate(s, start: start, end: end, issues: issues);

/// Parses a date in DICOM format.
/// Returns the Epoch Day in microseconds, which is negative if before
/// Epoch Day Zero, if [s] is valid; otherwise, returns
/// [kInvalidEpochMicroseconds].
int parseDicomDate(String s, {int start = 0, int end, Issues issues}) {
  assert(s != null && start != null);
  return _parseDate(s, start, end ?? s.length, 8, 8, issues);
}

/// Returns the Epoch Day in microseconds, which is negative if before
/// Epoch Day Zero, if [s] is valid; otherwise, returns
/// [kInvalidEpochMicroseconds].
int parseInternetDate(String s, {int start = 0, int end, Issues issues}) {
  assert(s != null && start != null);
  return _parseDate(s, start, end ?? s.length, 10, 10, issues, kDash);
}

// **** Internal below this line
// **** These functions do not do error checking, it was done above.

/// Returns a valid Epoch Day in microseconds or _null_.
int _parseDate(String s, int start, int end, int min, int max, Issues issues,
    [int separator]) {
  assert(s != null && start != null && end != null);
  try {
    _checkArgs(s, start, end, min, max, _fName, issues);
    return __parseDate(s, start, end, issues, separator);
  } on FormatException {
    // ignore: avoid_returning_null
    if (allowBlankDates && (s.trim().isEmpty)) return null;
    return throwOnError ? badDateString(s.substring(start, end), issues) : null;
  }
}

/// Returns a valid Epoch Day in microseconds or _null_.
int __parseDate(String s, int start, int end, Issues issues, [int separator]) {
  var m = 1, d = 1;
  var index = start;
  final y = _parseYear(s, index, issues);
  if ((index += 4) < end) {
    if (separator != null) _parseSeparator(s, index++, issues, separator);
    m = _parseMonth(s, index, issues);
    if ((index += 2) < end) {
      if (separator != null) _parseSeparator(s, index++, issues, separator);
      d = _parseDay(y, m, s, index, issues);
      if (y == null || m == null || d == null) {
        return throwOnError
            ? badDateString('Invalid Date: "${s.substring(start, start + 8)}')
            : null;
      }
    }
  }
  return dateToEpochMicroseconds(y, m, d);
}

/// Returns a valid year or _null_.  The year must be 4 characters.
int _parseYear(String s, int start, Issues issues) =>
    _parse4Digits(s, start, issues, global.minYear, global.maxYear);

/// Returns a valid month or _null_.  The month must be 2 characters.
int _parseMonth(String s, int start, Issues issues) =>
    _parse2Digits(s, start, issues, 1, 12);

/// Returns a valid day or _null_.  The day must be 2 characters.
int _parseDay(int y, int m, String s, int start, Issues issues) {
  assert(y != null && m != null && s != null && start != null);
  final max = daysInLeapYearMonth[m];
  final d = _parse2Digits(s, start, issues, 1, max);
  return (m != 2) ? d : _checkDigitRange(d, issues, 1, lastDayOfMonth(y, m));
}
