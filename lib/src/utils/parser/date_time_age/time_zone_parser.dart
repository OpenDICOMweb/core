//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.core.parser;

//TODO: redo doc

/// DICOM Time Zone parsing, etc.

/// Returns a valid Time Zone Offset in microseconds.
/// A negative values is before UTC.
int parseTimeZone(String s,
        {int start = 0,
        int end,
        Issues issues,
        OnParseError onError,
        bool asDicom = true}) =>
    asDicom
        ? parseDcmTimeZone(s,
            start: start, end: end, issues: issues, onError: onError)
        : parseInternetTimeZone(s,
            start: start, end: end, issues: issues, onError: onError);

/// Returns the microseconds that correspond to [s],
/// which must be in DICOM format.
///
/// The [String] must have the format [-+]hhmm, where 'hh' is a
/// valid time zone hour and 'mm' is a valid time zone minute values,
/// i.e. 0, 30, or 45. A negative values is before UTC.
int parseDcmTimeZone(String s,
    {int start = 0, int end, Issues issues, int onError(String s)}) {
  end ??= s.length;
  try {
    return _parseDcmTimeZone(s, start, end, issues);
  } on FormatException catch (e) {
    if (onError != null) return onError(s.substring(start, end));
    return badTimeZoneString(e.message, issues);
  }
}

int _parseDcmTimeZone(String s, int start, int end, Issues issues) {
  final v = (start == 0) ? s : s.substring(start, end);
  _checkRange(v.length, 5, 5, issues);
  if (v.length != 5)
    return parseError('Invalid Time Zone length: (${v.length})"$v"', issues);
  final index = kValidDcmTZStrings.indexOf(v);
  if (index == -1) return parseError('Invalid Time Zone: "$v"', issues);
  return kValidTZMicroseconds[index];
}

/// Returns the microseconds that correspond to [s],
/// which must be in Internet format.
///
/// The [String] must have the format [-+]hhmm, where 'hh' is a
/// valid time zone hour and 'mm' is a valid time zone minute values,
/// i.e. 0, 30, or 45. A negative values is before UTC.
int parseInternetTimeZone(String s,
    {int start = 0, int end, Issues issues, OnParseError onError}) {
  end ??= s.length;
  final v = (start == 0) ? s : s.substring(start, end);
  final index = kValidInetTZStrings.indexOf(v);
  return (index == -1)
      ? badTimeZoneString(v, issues)
      : kValidTZMicroseconds[index];
}

/// Returns _true_ if [s] is a valid time zone [String].
bool isValidTimeZoneString(String s,
        {int start = 0, int end, bool asDicom = true}) =>
    asDicom
        ? isValidDcmTimeZoneString(s, start: start, end: end)
        : isValidInternetTimeZoneString(s, start: start, end: end);

/// Returns _true_ if [s] is a valid DICOM time zone [String].
bool isValidDcmTimeZoneString(String s, {int start = 0, int end}) {
  end ??= s.length;
  final v = (start == 0) ? s : s.substring(start, end);
  return kValidDcmTZStrings.contains(v);
}

/// Returns _true_ if [s] is a valid Internet time zone [String].
bool isValidInternetTimeZoneString(String s, {int start = 0, int end}) {
  end ??= s.length;
  final v = (start == 0) ? s : s.substring(start, end);
  return kValidInetTZStrings.contains(v);
}
