//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.core.parser;

// ignore_for_file: public_member_api_docs


/// Parses a time. If [s] contains a ':', it is parsed as an Internet
/// time; otherwise, as a DICOM time. If successful, returns the time in
/// microseconds, which is always a non-negative integer; otherwise, _null_.
int parseTime(String s, {int start = 0, int end, Issues issues}) =>
    (s.contains(':'))
        ? parseInternetDate(s, start: start, end: end, issues: issues)
        : parseDicomDate(s, start: start, end: end, issues: issues);

/// Parses a time in DICOM format. If successful, returns the time in
/// microseconds, which is always a non-negative integer; otherwise, _null_.
int parseDicomTime(String t,
    {int start = 0, int end, Issues issues, int onError(String s)}) {
  assert(t != null && start != null);
  return _parseTime(t, start, end ?? t.length, 2, 13, issues);
}

/// Parses a time in DICOM format. If successful, returns the time in
/// microseconds, which is always a non-negative integer; otherwise, _null_.
int parseInternetTime(String t,
    {int start = 0, int end, Issues issues, int onError(String s)}) {
  assert(t != null && start != null);
  return _parseTime(t, start, end ?? t.length, 2, 15, issues, kColon);
}

// ***** Internal functions

/// Returns a valid Epoch Day in microseconds or _null_.
int _parseTime(String s, int start, int end, int min, int max, Issues issues,
    [int separator]) {
  assert(s != null && start != null && end != null);
  try {
    _checkArgs(s, start, end, min, max, 'Parse Time', issues);
    return __parseTime(s, start, end, issues, separator);
  } on FormatException {
    // ignore: avoid_returning_null
    if (allowBlankDates && (s.trim().isEmpty)) return null;
    return throwOnError ? badDateString(s.substring(start, end), issues) : null;
  }
}

/// Returns the time in microseconds.
int __parseTime(String t, int start, int end, Issues issues, [int separator]) {
  var m = 0, s = 0, f = 0;
  var index = start;
  final h = _parseHour(t, index, issues);
  if ((index += 2) < end) {
    if (separator != null) _parseSeparator(t, index++, issues, separator);
    m = _parseMinute(t, index, issues);
    if ((index += 2) < end) {
      if (separator != null) _parseSeparator(t, index++, issues, separator);
      s = _parseSecond(t, index, issues);
      if ((index += 2) < end) {
        f = _parseTimeFraction(t, index, issues, end);
      }
    }
  }
  return timeToMicroseconds(h, m, s, f ~/ 1000, f % 1000);
}

/// Returns a valid hour or _null_.  The hour must be 2 characters.
int _parseHour(String s, int start, Issues issues) =>
    _parse2Digits(s, start, issues, 0, 23);

/// Returns a valid minute or _null_.  The minute must be 2 characters.
int _parseMinute(String s, int start, Issues issues) =>
    _parse2Digits(s, start, issues, 0, 59);

// TODO: doesn't handle leap seconds
/// Returns a valid second or _null_.  The second must be 2 characters.
int _parseSecond(String s, int start, Issues issues) =>
    _parse2Digits(s, start, issues, 0, 59);

int _parseTimeFraction(String s, int start, Issues issues, int end) {
  assert(end != null);
  final f = _parseFraction(s, start, issues, end);
  final us = _fractionToUSeconds(f, issues);
  return _checkRange(us, 0, 999999, issues);
}

int _fractionToUSeconds(int fraction, Issues issues) {
  var f = fraction;
  if (f < 10) return f *= 100000;
  if (f < 100) return f *= 10000;
  if (f < 1000) return f *= 1000;
  if (f < 10000) return f *= 100;
  if (f < 100000) return f *= 10;
  if (f < 1000000) return f;
  return badTimeString('Fraction too large', issues);
}
