//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/error/date_time_errors.dart';
import 'package:core/src/error/issues.dart';
import 'package:core/src/global.dart';
import 'package:core/src/utils/date_time.dart';
import 'package:core/src/values/date_time/primitives/time.dart';

/// Returns the total number of minutes from UTC.
int timeZoneToMicroseconds(int sign, int h, int m) {
  final us = (sign * ((h.abs() * 60) + m)) * kMicrosecondsPerMinute;
  return (isValidTimeZoneMicroseconds(us))
      ? us
      : invalidTimeZoneError(sign, h, m);
}

/// _Deprecated_: Use [timeZoneToMicroseconds] instead.
@deprecated
int timeZoneInMinutes(int sign, int h, int m) {
  final us = (sign * ((h.abs() * 60) + m)) * kMicrosecondsPerMinute;
  return (isValidTimeZoneMicroseconds(us))
      ? us ~/ kMicrosecondsPerMinute
      : invalidTimeZoneError(sign, h, m);
}

/// Returns the total number of minutes from UTC.
int timeZoneToMinutes(int sign, int h, int m) {
  final us = timeZoneToMicroseconds(sign, h, m);
  return (isValidTimeZoneMicroseconds(us))
      ? us ~/ kMicrosecondsPerMinute
      : invalidTimeZoneError(sign, h, m);
}

/// Returns the time zone hour component of [us].
int timeZoneHour(int us) => us ~/ kMicrosecondsPerMinute;

/// Returns the time zone minute component of [us].
int timeZoneMinute(int us) =>
    (us % kMicrosecondsPerMinute) ~/ kMicrosecondsPerSecond;

const List<int> kValidTZMicroseconds = const <int>[
  -43200000000, -39600000000, -36000000000, -34200000000, -32400000000,
  -28800000000, -25200000000, -21600000000, -18000000000, -14400000000,
  -12600000000, -10800000000, -7200000000, -3600000000,
  0, // No reformat
  3600000000, 7200000000, 10800000000, 12600000000, 14400000000,
  16200000000, 18000000000, 19800000000, 20700000000, 21600000000,
  23400000000, 25200000000, 28800000000, 30600000000, 31500000000,
  32400000000, 34200000000, 36000000000, 37800000000, 39600000000,
  43200000000, 45900000000, 46800000000, 50400000000
];

int tzMicrosecondsToIndex(int us) => kValidTZMicroseconds.indexOf(us);
int tzIndexToMicroseconds(int index) => kValidTZMicroseconds[index];

const List<int> kValidDcmTZHours = const <int>[
  -12, -11, -10, -09, -09, -08, -07,
  -06, -05, -04, -03, -03, -02, -01,
  00,
  01, 02, 03, 03, 04, 04, 05,
  05, 05, 06, 06, 07, 08, 08,
  08, 09, 09, 10, 10, 11, 12,
  12, 13, 14 // No reformat
];

int tzIndexToHours(int index) => kValidDcmTZHours[index];

const List<int> kValidDcmTZMinutes = const <int>[
  00, 00, 00, 30, 00, 00, 00,
  00, 00, 00, 30, 00, 00, 00,
  00,
  00, 00, 00, 30, 00, 30, 00,
  30, 45, 00, 30, 00, 00, 30,
  45, 00, 30, 00, 30, 00, 00,
  45, 00, 00 // No reformat
];

int tzIndexToMinutes(int index) => kValidDcmTZMinutes[index];

const List<int> kValidDcmTZInMinutes = const <int>[
  -720, -660, -600, -510, -540, -480, -420,
  -360, -300, -240, -150, -180, -120,  -60,
  0,
   60, 120, 180, 210, 240, 270, 300,
  330, 345, 360, 390, 420, 480, 510,
  525, 540, 570, 600, 630, 660, 720,
  765, 780, 840 // No reformat
];

int tzIndexToTZMinutes(int index) => kValidDcmTZInMinutes[index];
int tzMinutesToIndex(int tzm) => kValidDcmTZInMinutes.indexOf(tzm);


/// Returns _true_ if [us] is a valid time zone.
bool isValidTimeZoneMicroseconds(int us) => kValidTZMicroseconds.contains(us);

/// Returns _true_ if the arguments correspond to a valid Time Zone.
///
/// _Note_: [h] may be positive or negative.
/// It is converted to an absolute values.
bool isValidTimeZone(int sign, int h, int m) {
  final us = timeZoneToMicroseconds(sign, h, m);
  return isValidTimeZoneMicroseconds(us);
}

bool isValidTimeZoneHour(int h) => (h < -12 || h > 14);
bool isNotValidTimeZoneHour(int h) => !isValidTimeZoneHour(h);

/// Returns _true_ if [m] is a valid time zone microsecond.
bool isValidTimeZoneMinutes(int m) =>
    isValidTimeMicroseconds(m * kMicrosecondsPerMinute);

/// Returns a [String] corresponding to the microsecond ([us]).
/// If [asDicom] is _true_ the format is '[+/-]hhmm';
/// otherwise the format is '[+/-]hh:mm' or 'Z' if UTC.
String timeZoneMicrosecondsToString(int us, {bool asDicom = true}) {
  final index = kValidTZMicroseconds.indexOf(us);
  if (index == -1) return invalidTimeZoneMicrosecondsError(us);
  return (asDicom) ? kValidDcmTZStrings[index] : kValidInetTZStrings[index];
}

/// Returns a [String] corresponding to the [sign], [hour], and [minute]..
/// If [asDicom] is _true_ the format is '[+/-]hhmm';
/// otherwise the format is '[+/-]hh:mm' or 'Z' if UTC.
String timeZoneToString(int sign, int hour, int minute, {bool asDicom = true}) {
  final us = timeZoneToMicroseconds(sign, hour, minute);
  return timeZoneMicrosecondsToString(us, asDicom: asDicom);
}

/// Returns a hash of Time Zone Hour, where the Time Zone Minutes values
/// is always zero, and the hash of the hour values is in the range:
/// ```[kMinTimeZoneHour] <= hash <= [kMaxTimeZoneHour]```.
int hashTimeZoneMicroseconds(int us) {
  if (!isValidTimeZoneMicroseconds(us)) return badTimeMicroseconds(us);
  final h = global.hash(us) % (kTZLength - 1);
  return kValidTZMicroseconds[h];
}

//Note: It is important that kValidDcmTimeZoneStrings and
// kValidInetTimeZoneStrings have the same length.
final int kTZLength = kValidDcmTZStrings.length;

int tzIndexHash(int index) {
  var hIndex = global.hash(index) % (kTZLength - 1);
  if (hIndex == index) hIndex = (hIndex - kTZLength).abs();
  if (hIndex == -1) log.error('Invalid TZ Hash Index: $hIndex');
  return hIndex;
}

const List<String> kValidDcmTZStrings = const <String>[
  '-1200', '-1100', '-1000', '-0930', '-0900', '-0800', '-0700',
  '-0600', '-0500', '-0400', '-0330', '-0300', '-0200', '-0100',
  '+0000',
  '+0100', '+0200', '+0300', '+0330', '+0400', '+0430', '+0500',
  '+0530', '+0545', '+0600', '+0630', '+0700', '+0800', '+0830',
  '+0845', '+0900', '+0930', '+1000', '+1030', '+1100', '+1200',
  '+1245', '+1300', '+1400' // No reformat
];

bool isValidDcmTZString(String s) => kValidDcmTZStrings.contains(s);
int dcmTZStringToIndex(String s) => kValidDcmTZStrings.indexOf(s);
String tzIndexToDcmString(int index) => kValidDcmTZStrings[index];

String dcmTZStringHash(String tz) {
  final index = dcmTZStringToIndex(tz);
  if (index == -1) return null;
  final hIndex = tzIndexHash(index);
  return kValidDcmTZStrings[hIndex];
}

const List<String> kValidInetTZStrings = const <String>[
  '-12:00', '-11:00', '-10:00', '-09:30', '-09:00', '-08:00', '-07:00',
  '-06:00', '-05:00', '-04:00', '-03:30', '-03:00', '-02:00', '-01:00',
  'Z',
  '+01:00', '+02:00', '+03:00', '+03:30', '+04:00', '+04:30', '+05:00',
  '+05:30', '+05:45', '+06:00', '+06:30', '+07:00', '+08:00', '+08:30',
  '+08:45', '+09:00', '+09:30', '+10:00', '+10:30', '+11:00', '+12:00',
  '+12:45', '+13:00', '+14:00' // No reformat
];

bool isValidInetTZString(String s) => kValidInetTZStrings.contains(s);
int inetTZStringToIndex(String s) => kValidInetTZStrings.indexOf(s);
String tzIndexToInetString(int index) => kValidInetTZStrings[index];

String inetTZStringHash(String tz) {
  final index = inetTZStringToIndex(tz);
  if (index == -1) return null;
  final hIndex = tzIndexHash(index);
  return kValidInetTZStrings[hIndex];
}

/// An invalid [DateTime] [Error].
class InvalidTimeZoneError extends Error {
  int sign, h, m;
  Error error;

  InvalidTimeZoneError(this.sign, this.h, this.m, [this.error]);

  @override
  String toString() => _msg(sign, h, m, error);

  static String _msg(int sign, int h, int m, Error error) =>
      'InvalidTimeZoneError: sign: $sign, h: $h, m: $m\n  $error';
}

Null invalidTimeZoneError(int sign, int h, int m,
    [Issues issues, Error error]) {
  final msg = InvalidTimeZoneError._msg(sign, h, m, error);
  log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError) throw new InvalidTimeZoneError(sign, h, m, error);
  return null;
}

/// An invalid time zone minutes [Error].
@deprecated
class InvalidTimeZoneMinutesError extends Error {
  int minutes;

  InvalidTimeZoneMinutesError(this.minutes);

  @override
  String toString() => _msg(minutes);

  static String _msg(int us) => 'InvalidTimeZoneMinutesError: us = $us';
}

@deprecated
Null invalidTimeZoneMinutesError(int us) {
  log.error(InvalidTimeZoneMinutesError._msg(us));
  if (throwOnError) throw new InvalidTimeZoneMinutesError(us);
  return null;
}

/// Return a new hashed (but valid) time zone string in the specified format.
/// The default format is DICOM.
String hashTZString(String s, {int start = 0, int end, bool asDicom = true}) =>
    (asDicom) ? dcmTZStringHash(s) : inetTZStringHash(s);

int getRandomTimeZoneIndex() =>
    Global.rng.nextInt(kValidTZMicroseconds.length - 1);

/// Return a new random (but valid) time zone string in the specified format.
/// The default format is DICOM.
String randomDcmTimeZoneString(String s,
    {int start = 0, int end, bool asDicom = true}) {
  final index = kValidDcmTZStrings.indexOf(s);
  if (index == -1) return null;
  final rIndex = getRandomTimeZoneIndex();
  return (asDicom) ? kValidDcmTZStrings[rIndex] : kValidInetTZStrings[rIndex];
}

/// An invalid [DateTime] [Error].
class InvalidTimeZoneMicrosecondError extends Error {
  int microsecond;

  InvalidTimeZoneMicrosecondError(this.microsecond);

  @override
  String toString() => _msg(microsecond);

  static String _msg(int us) => 'InvalidTimeZoneMicrosecondsError: us = $us';
}

Null invalidTimeZoneMicrosecondsError(int us) {
  log.error(InvalidTimeZoneMicrosecondError._msg(us));
  if (throwOnError) throw new InvalidTimeZoneMicrosecondError(us);
  return null;
}
