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

//TODO: redo doc

bool isValidDcmDateTimeString(String s,
    {int start = 0, int end, Issues issues}) =>
    (s.isEmpty)
        ? true
        : parseDcmDateTime(s, start: start, end: end, issues: issues) == null
        ? false
        : true;

/// Returns the date/time in microseconds or _null_ if [s] is not valid.
int parseDcmDateTime(String s,
    {int start = 0, int end, Issues issues, int onError(String s)}) {
  try {
    int date, time = 0, tz = 0, index = start;
    end ??= s.length;
    _checkArgs(s, start, end, 4, 26, 'parseDcmDateTime', issues);
    final dateEnd = (end < 8) ? end : 8;
    date = _parsePartialDcmDate(s, index, dateEnd, issues);
    assert(date != null);
    if ((index += 8) < end) {
      final timeEnd = (end < 21) ? end : 21;
      time = _parseDcmTime(s, index, timeEnd, issues);
      assert(time != null);
      if (end > 21) tz = _parseDcmTimeZone(s, 21, end, issues);
      assert(tz != null);
    }
    return date + time + tz;
  } on FormatException catch (e) {
    if (onError != null) return onError(s.substring(start, end));
    return badTimeZoneString(e.message);
  }
}

// **** Internal Functions

int _parsePartialDcmDate(String s, int start, int end, Issues issues) {
  int y, m = 1, d = 1, index = start;
  y = _parseYear(s, index, issues);
  if ((index += 4) < end) {
    m = _parseMonth(s, index, issues);
    if ((index += 2) < end) {
      d = _parseDay(y, m, s, index, issues);
    }
  }
  // y, m, and d are all valid at this point
  final us = dateToEpochMicroseconds(y, m, d);
  assert(us != null);
  return us;
}
