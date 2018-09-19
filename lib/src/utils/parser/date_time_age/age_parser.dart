//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.core.parser;

/*
const String kAgeTokens = 'DWMY';

const int kDaysInWeek =7;
const int kDaysInMonth =30;
const int kDaysInYear = 365;
const int kMaxCount = 999;
const int kMaxDayAge = kMaxCount;
const int kMaxWeekAge = kMaxCount * kDaysInWeek;
const int kMaxMonthAge = kMaxCount * kDaysInMonth;
const int global.maxYearAge = kMaxCount * kDaysInYear;

*/

/// Returns the number of days corresponding to [s], which is a 4 character
/// DICOM age (AS) [String]. [s] must be in the format: 'dddt', where 'd' is a decimal
/// digit and 't' is an age token, one of "D", "W", "M", "Y".
int parseAgeString(String s,
    {int onError(String s), bool allowLowercase = false}) {
  if (s == null || s.length != 4)
    return _onError(s, onError, 'Invalid age String');

  final token = (allowLowercase) ? s[3].toUpperCase() : s[3];
  if (!kAgeTokens.contains(token))
    return _onError(s, onError, 'Invalid age Token');

  final n = tryParseAgeString(s);
  if (n < 0) _onError(s.substring(0, 3), onError, 'Invalid age number');
  return n;
}

int _onError(String s, int onError(String s), String errorMsg) =>
    (onError != null) ? onError(s) : badAgeParse('$errorMsg: "$s"');

/// Returns the number of days corresponding to [s], which is a
/// 4 character DICOM age (AS) [String]. [s] must be in the
/// format: 'dddt', where 'd' is a decimal digit and 't' is an age
/// token, one of "D", "W", "M", "Y". If [s] is invalid returns -1.
int tryParseAgeString(String s, {bool allowLowercase = false}) {
  if (s == null || s.length != 4) return -1;

  final token = (allowLowercase) ? s[3].toUpperCase() : s[3];
  if (!kAgeTokens.contains(token)) return -1;

  final n = int.tryParse(s.substring(0, 3));
  if (n == null || n < 0 || (n == 0 && token != 'D')) return -1;
  switch (token) {
    case 'D':
      return n;
    case 'W':
      return n * kDaysInWeek;
    case 'M':
      return n * kAgeDaysInMonth;
    case 'Y':
      return n * kAgeDaysInYear;
    default:
      return -1;
  }
}

/// Returns _true_ if [s] is a valid [Age] [String].
bool isValidAgeString(String s) => tryParseAgeString(s) == -1 ? false : true;

/// Returns a random age between 0 days and 999 years, if [s] is valid;
/// otherwise, returns _null_.
String hashAgeString(String s) {
  global.level = Level.debug;
  final days = parseAgeString(s);
  if (days == null || days == -1) return null;
  final hash = hashAgeInDays(days);
  return ageToString(hash);
}

/// Returns a list of hash codes corresponding to [vList].
Iterable<String> hashAgeStringList(List<String> vList) =>
    vList.map(hashAgeString);
