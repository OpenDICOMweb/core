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
int parseDate(String s,
        {int start = 0, int end, Issues issues, int onError(String s)}) =>
    (s.contains('-'))
        ? parseInternetDate(s,
            start: start, end: end, issues: issues, onError: onError)
        : parseDicomDate(s,
            start: start, end: end, issues: issues, onError: onError);

/// Parses a date in DICOM format.
/// Returns the Epoch Day in microseconds, which is negative if before
/// Epoch Day Zero, if [s] is valid; otherwise, returns
/// [kInvalidEpochMicroseconds].
int parseDicomDate(String s,
    {int start = 0, int end, Issues issues, int onError(String s)}) {
  assert(s != null && start != null);
  return _parseDate(s, start, end, 8, 8, issues, onError);
}

/// Returns the Epoch Day in microseconds, which is negative if before
/// Epoch Day Zero, if [s] is valid; otherwise, returns
/// [kInvalidEpochMicroseconds].
int parseInternetDate(String s,
    {int start = 0, int end, Issues issues, int onError(String s)}) {
  assert(s != null && start != null);
  return _parseDate(s, start, end, 10, 10, issues, onError, kDash);
}

/// Returns true is [s] contains a valid DICOM date.
// Note: checkArgs is done by [parseDcmDate].
bool isValidDcmDateString(String s, {int start = 0, int end, Issues issues}) =>
    parseDate(s, start: start, end: end, issues: issues) == null ? false : true;

// **** Internal below this line
// **** These functions do not do error checking, it was done above.

/// Returns a valid Epoch Day in microseconds or _null_.
int _parseDate(String s, int start, int end, int min, int max, Issues issues,
    [int onError(String s), int separator]) {
  assert(s != null && start != null);
  const _fName = '_parseDate';
  try {
    _checkArgs(s, start, end, min, max, _fName, issues);
    return __parseDate(s, start, issues, onError, separator);
  } on FormatException {
    return (onError != null)
        ? onError(s)
        : (throwOnError)
            ? invalidDateString(s.substring(start, end), issues)
            : null;
  }
}

/// Returns a valid Epoch Day in microseconds or _null_.
int __parseDate(String s, int start, Issues issues,
    [int onError(String s), int separator]) {
  var index = start;
  final y = _parseYear(s, index, issues);
  index += 4;
  if (separator != null) _parseSeparator(s, index++, issues, separator);
  final m = _parseMonth(s, index, issues);
  index += 2;
  if (separator != null) _parseSeparator(s, index++, issues, separator);
  final d = _parseDay(y, m, s, index, issues);
  if (y == null || m == null || d == null)
    return (onError != null)
        ? onError(s)
        : invalidDateString('Invalid Date: "${s.substring(start, start + 8)}');
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
