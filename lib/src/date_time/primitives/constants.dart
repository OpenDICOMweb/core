// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/integer/integer.dart';

/// The naming convention is that the plural form is a total, and the singular
/// form is a component. For example the minimum microsecond corresponds to
/// the most negative Dart Small Integer + 1.

// **** Unix Epoch Constants

//TODO: before V0.9.0 decide what these values should be.
//const int kDefaultMinYear = -10000 - 1970;
const int kDefaultMinYear = 1970 - 1970;
const int kDefaultMaxYear = 130 + 1970;

const int kInvalidEpochMicroseconds = kDartMinSMInt;

// These are the upper and lower bounds for Epoch microseconds for the system.
// kDartMinSMInt is the error value for Dates and Times.
const int kEpochMicrosecondsErrorValue = kDartMinSMInt;
const int kAbsoluteMinEpochMicroseconds = kDartMinSMInt + 1;
const int kAbsoluteMaxEpochMicroseconds = kDartMaxSMInt;
const int kAbsoluteMinEpochMicrosecondsUTC =
    kAbsoluteMinEpochMicroseconds + kMinTimeZoneMicroseconds;
const int kAbsoluteMaxEpochMicrosecondsUTC =
    kAbsoluteMaxEpochMicroseconds - kMaxTimeZoneMicroseconds;

// **** Date Constants
// These constants are computed in core/bin/min_max_epoch_day.dart
const int kAbsoluteMinEpochDay = -53375995;
const int kAbsoluteMaxEpochDay = 52656527;
const int kEpochDayZero = 0;
const int kEpochDayZeroInMicroseconds = 0;
const List<int> kEpochDateZero = const <int>[1970, 1, 1];
const int kEpochDayZeroWeekday = kThursday;

// The number of days between 0000-03-01 (March 1, 0000) and
// Epoch Day 0 (January 1, 1970). This number is used to calculate
// the Epoch Day upper bound, which is the most positive Dart small
// integer ([SMI]) minus the number of days from 0000-03-01 and
// Epoch Day Zero (1970-01-01).
const int kEpochDayFor00000301 = -719468;

/// The Epoch Day for 1960-01-01.
const int k1960InEpochDays = -3653;
const int k1960InEpochMicroseconds = -3653 * kMicrosecondsPerDay;

/// The American College of Radiology _baseline_ date
/// for de-identifying Dates.
const int kACRBaselineDay = k1960InEpochDays;
const int kACRBaselineMicroseconds = k1960InEpochMicroseconds;

const List<String> weekdayNames = const <String>[
  'Sunday', 'Monday', 'Tuesday', 'Wednesday',
  'Thursday', 'Friday', 'Saturday' // no reformat
];

const int kSunday = 0;
const int kMonday = 1;
const int kTuesday = 2;
const int kWednesday = 3;
const int kThursday = 4;
const int kFriday = 5;
const int kSaturday = 6;

const List<int> daysInCommonYearMonth = const <int>[
  0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 //keep
];

const List<int> daysInLeapYearMonth = const <int>[
  0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 //keep
];

// **** Time Constants
const int kMicrosecondsPerMillisecond = 1000;
const int kMillisecondsPerSecond = 1000;
const int kSecondsPerMinute = 60;
const int kMinutesPerHour = 60;
const int kHoursPerDay = 24;

const int kMicrosecondsPerSecond = kMillisecondsPerSecond * kMicrosecondsPerMillisecond;
const int kMicrosecondsPerMinute = kMillisecondsPerMinute * kMicrosecondsPerMillisecond;
const int kMicrosecondsPerHour = kMillisecondsPerHour * kMicrosecondsPerMillisecond;
const int kMicrosecondsPerDay = kMillisecondsPerDay * kMicrosecondsPerMillisecond;
const int kMicrosecondsPerYear = kMillisecondsPerDay * 365;

const int kMillisecondsPerMinute = kSecondsPerMinute * kMillisecondsPerSecond;
const int kMillisecondsPerHour = kSecondsPerHour * kMillisecondsPerSecond;
const int kMillisecondsPerDay = kSecondsPerDay * kMillisecondsPerSecond;
const int kSecondsPerHour = kMinutesPerHour * kSecondsPerMinute;
const int kSecondsPerDay = kMinutesPerDay * kSecondsPerMinute;
const int kMinutesPerDay = kHoursPerDay * kMinutesPerHour;

// **** Time Zone Constants

/// The minimum time zone hour value.
const int kMinTimeZoneHour = -12;

/// The maximum time zone hour value.
const int kMaxTimeZoneHour = 14;

/// The minimum value for a time zone in minutes.
const int kMinTimeZoneMinutes = kMinTimeZoneHour * 60;

/// The maximum value for a time zone in microseconds.
const int kMaxTimeZoneMinutes = kMaxTimeZoneHour * 60;

/// The minimum value for a time zone in microseconds.
const int kMinTimeZoneMicroseconds = kMinTimeZoneMinutes * kMicrosecondsPerMinute;

/// The maximum value for a time zone in microseconds.
const int kMaxTimeZoneMicroseconds = kMaxTimeZoneMinutes * kMicrosecondsPerMinute;

const int kUSEastTimeZone = -5 * kMinutesPerHour;
const int kUSCentralTimeZone = -6 * kMinutesPerHour;
const int kUSMountainTimeZone = -7 * kMinutesPerHour;
const int kUSPacificTimeZone = -8 * kMinutesPerHour;


const int kDaysInWeek = 7;
