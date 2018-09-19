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
import 'package:core/src/utils/hash/sha256.dart' as sha256;
import 'package:core/src/utils/string.dart';
import 'package:core/src/error/date_time_errors.dart';

// ignore_for_file: public_member_api_docs

// DICOM Age (AS) constants.

/// The valid tokens for DICOM Age (AS) [String]s.
const String kAgeTokens = 'DWMY';

/// The maximum values of the 3 digits in an [Age] [String].
const int kMaxAgeInteger = 999;

/// The minimum number of nDays an Age (AS) may have.
const int kMinAge = 0;

/// The maximum number of nDays an Age (AS) may have.
const int kMaxAge = kMaxAgeYearsInDays;

/// The maximum Age that can be expressed in days (nnnD).
const int kMaxAgeInDays = kMaxAgeInteger;

/// The maximum Age that can be expressed in weeks (nnnW).
const int kMaxAgeWeeksInDays = kMaxAgeInteger * kDaysInWeek;

const int kAgeDaysInMonth = 30;

/// The maximum Age that can be expressed in months (nnnM).
const int kMaxAgeMonthsInDays = kMaxAgeInteger * kAgeDaysInMonth;

const int kAgeDaysInYear = 365;

/// The maximum Age that can be expressed in years (nnnY).
const int kMaxAgeYearsInDays = kMaxAgeInteger * kAgeDaysInYear;

bool isValidAge(int nDays) => nDays >= kMinAge && nDays <= kMaxAge;

int randomAgeInDays(int nDays) => Global.rng.nextInt(kMaxAgeInDays);

int hashAgeInDays(int nDays) => global.hash(nDays) % kMaxAgeInDays;

int sha256AgeInDays(int nDays) => sha256.int63(nDays) % kMaxAgeInDays;

String sha256AgeAsString(int nDays) => ageToString(sha256AgeInDays(nDays));

/// Returns a [String] corresponding to age in days.
/// The [String] is in the format: 'dddt', where 'd' is a decimal
/// digit and 't' is an age token, one of "D", "W", "M", "Y".
String ageToString(int nDays) {
  if (nDays < 0 || nDays > kMaxAge) return badAge(nDays);

  String s;
  if (nDays >= 0 && nDays <= kMaxAgeInDays) {
    s = '${digits3(nDays)}D';
  } else if (nDays <= kMaxAgeWeeksInDays) {
    s = '${digits3(nDays ~/ kDaysInWeek)}W';
  } else if (nDays <= kMaxAgeMonthsInDays) {
    s = '${digits3(nDays ~/ kAgeDaysInMonth)}M';
  } else if (nDays <= kMaxAgeYearsInDays) {
    s = '${digits3(nDays ~/ kAgeDaysInYear)}Y';
  } else {
    throw new FallThroughError();
  }
  return s;
}

String _daysToString(int nDays, int units, String token) {
  final n = nDays ~/ units;
  return '${n.toString().padLeft(3, '0')}$token';
}

String canonicalAgeString(int nDays) {
  if (nDays < 0 || nDays > kMaxAge) return null;
  if (nDays <= kMaxAgeInDays) return _daysToString(nDays, kMaxAgeInDays, 'D');
  if (nDays <= kMaxAgeWeeksInDays)
    return _daysToString(nDays, kMaxAgeWeeksInDays, 'D');
  if (nDays <= kMaxAgeMonthsInDays)
    return _daysToString(nDays, kMaxAgeMonthsInDays, 'D');
  if (nDays <= kMaxAgeYearsInDays)
    return _daysToString(nDays, kMaxAgeYearsInDays, 'D');
  return null;
}

//Flush if not used by V0.9.0
/// Returns a [String] corresponding to age in days.
/// The [String] is in the format: 'dddt', where 'd' is a decimal
/// digit and 't' is an age token, one of "D", "W", "M", "Y".
String ageInDaysToString(int nDays) {
  String s;
  if (nDays >= 0 && nDays <= kMaxAgeInDays) {
    s = '${digits3(nDays)}D';
  } else if (nDays <= kMaxAgeWeeksInDays) {
    s = '${digits3(nDays ~/ 7)}W';
  } else if (nDays <= kMaxAgeMonthsInDays) {
    s = '${digits3(nDays ~/ 30)}M';
  } else if (nDays <= kMaxAgeYearsInDays) {
    s = '${digits3(nDays ~/ 365)}Y';
  } else {
    return badAge(nDays);
  }
  // log.debug('nDays: $nDays Age String: "$s"');
  return s;
}
