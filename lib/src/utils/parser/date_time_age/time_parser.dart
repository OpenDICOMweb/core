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

// Urgent Jim: rewrite
/// Returns the number of microseconds represented by [s].
int parseDcmTime(String s,
    {int start = 0, int end, Issues issues, OnParseError onError}) {
  try {
    //Note: max is 13 because padding should have been removed.
    end ??= s.length;
    if (_isNotValidTimeStringLength(end - start))
      invalidStringLength(s, issues, start, end);
    if (kValidTimeStringLengths.contains(end - start))
      _checkArgs(s, start, end, 2, 13, 'parseDcmTime', issues);
    final us = _parseDcmTime(s, start, end, issues);
    return us;
  } on FormatException {
    return (onError != null) ? onError(s) : null;
  }
}

// TODO: unit test and when working replace parseDcmTime
int parseTime(String s,
    {int start = 0,
    int end,
    Issues issues,
    OnParseError onError,
    bool asInternet = true}) {
  try {
    //Note: max is 13 because padding should have been removed.
    end ??= s.length;
    if (_isNotValidTimeStringLength(end - start))
      invalidStringLength(s, issues, start, end);
    if (kValidTimeStringLengths.contains(end - start))
      _checkArgs(s, start, end, 2, 13, 'parseDcmTime', issues);
    final us = _parseTime(s, start, end, issues, true);
    assert(us != null);
    return us;
  } on FormatException {
    return (onError != null) ? onError(s) : null;
  }
}

/// Returns _true_ if [s] represents a valid DICOM time [String].
bool isValidDcmTimeString(String s, {int start = 0, int end, Issues issues}) =>
    parseDcmTime(s, start: start, end: end, issues: issues) != null;

const List<int> kValidTimeStringLengths = <int>[2, 4, 6, 8];

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
  var us = parseDcmTime(s);
  if (us == null) return null;
  us = hashTimeMicroseconds(us);
  return microsecondsToString(us);
}

// ***** Internal functions

/// Returns the time in microseconds.
int _parseDcmTime(String s, int start, int end, Issues issues) {
  final _end = end ?? s.length;
  int h, m = 0, ss = 0, f = 0;
  //Note: max is 13 because padding should have been removed.
  _checkArgs(s, start, _end, 2, 13, 'parseDcmTime', issues);
  var index = start;
  h = _parseHour(s, index, issues);
  if ((index += 2) < _end) {
    m = _parseMinute(s, index, issues);
    if ((index += 2) < _end) {
      ss = _parseSecond(s, index, issues);
      if ((index += 2) < _end) {
        f = _parseTimeFraction(s, index, issues, _end);
      }
    }
  }
  return timeToMicroseconds(h, m, ss, f ~/ 1000, f % 1000);
}

/// Returns the time in microseconds.
int _parseTime(String s, int start, int end, Issues issues,
    [bool asInternet = true]) {
  const separator = kColon;
  final _end = end ?? s.length;
  int h, m = 0, ss = 0, f = 0;
  //Note: max is 13 because padding should have been removed.
  _checkArgs(s, start, _end, 2, 13, 'parseDcmTime', issues);
  var index = start;
  h = _parseHour(s, index, issues);
  if (asInternet) _parseSeparator(s, index++, issues, separator);
  if ((index += 2) < _end) {
    m = _parseMinute(s, index, issues);
    if (asInternet) _parseSeparator(s, index++, issues, separator);
    if ((index += 2) < _end) {
      ss = _parseSecond(s, index, issues);
      if ((index += 2) < _end) {
        f = _parseTimeFraction(s, index, issues, _end);
      }
    }
  }
  return timeToMicroseconds(h, m, ss, f ~/ 1000, f % 1000);
}

// Urgent Jim: this seems backwards
bool _isNotValidTimeStringLength(int length) =>
    !(kValidTimeStringLengths.contains(length) || (length > 8 && length <= 13));

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
