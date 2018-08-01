//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/error/date_time_errors.dart';
import 'package:core/src/global.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/utils/date_time.dart';
import 'package:core/src/values/date_time/primitives/time_zone.dart';

typedef TimeZone OnTimeZoneError(int sign, int h, int m);
typedef TimeZone OnTimeZoneParseError(String s);
typedef String OnTimeZoneHashStringError(String s);

//Urgent jfp: make hour minute, name, microseconds, etc Getters
// Urgent jfp: consider makeing tz part of DcmDateTime
/// A Time Zone object. See ISO 8601.
class TimeZone implements Comparable<TimeZone> {
  final int index;

  /// The [hour] relative to UTC of _this_.
  final int hour;

  /// The [minute] relative to UTC of _this_.
  final int minute;

  /// The minutes from UTC, where negative numbers indicate before UTC and
  /// positive numbers indicate after UTC>
  final int microseconds;

  /// A single uppercase character that is an abbreviation ([token])
  /// for the time zone.
  final String token;

  /// Create a new [TimeZone].
  factory TimeZone(int sign, int h, int m,
      {Issues issues, OnTimeZoneError onError}) {
    final us = timeZoneToMicroseconds(sign, h, m);
    if (us != null) return _getTimeZone(us);
    return (onError != null)
        ? onError(sign, h, m)
        : invalidTimeZoneError(sign, h, m, issues);
  }

  /// Create a new [TimeZone] from the Time Zone minutes.
  factory TimeZone.fromMicroseconds(int microseconds) {
    final index = kValidTZMicroseconds[microseconds];
    return (index != null)
        ? kMembers[index]
        : invalidTimeZoneMicrosecondsError(microseconds);
  }

  const TimeZone._(
      this.index, this.hour, this.minute, this.microseconds, this.token);

  @override
  bool operator ==(Object other) =>
      other is TimeZone && microseconds == other.microseconds;

  bool operator >(TimeZone other) => microseconds > other.microseconds;

  bool operator <(TimeZone other) => !(microseconds > other.microseconds);

  /// The sign of the Time Zone, where -1 is before UTC, 0 is UTC,
  /// and +1 is after UTC.
  int get sign => microseconds.sign;

  /// Returns the [hour] as a 2 digit [String].
  String get h => digits2(hour);

  /// Returns the [minute] as a 2 digit [String].
  String get m => digits2(minute);

  /// Returns _this_ as a [String] in DICOM time zone format.
  String get dcm => tzIndexToDcmString(index);

  /// Returns _this_ as a [String] in Internet \[RFC3339\] _time-zone_ format.
  String get inet => tzIndexToInetString(index);

  /// Returns a new [TimeZone] containing the [hash] of _this_.
  TimeZone get hash {
    final hIndex = tzIndexHash(index);
    if (hIndex == -1) throw new Error();
    return kMembers[hIndex];
  }

  /// Returns the [TimeZone] as an [Duration].
  Duration get asDuration => new Duration(microseconds: microseconds);

  @override
  int get hashCode => microseconds;

  @override
  int compareTo(TimeZone other) => compare(this, other);

  @override
  String toString() => inet;

  static const int kMinHour = kMinTimeZoneHour;
  static const int kMaxHour = kMaxTimeZoneHour;
  static const int kMinMinutes = kMinTimeZoneMinutes;
  static const int kMaxMinutes = kMaxTimeZoneMinutes;
  static const int kMinMicroseconds = kMinTimeZoneMicroseconds;
  static const int kMaxMicroseconds = kMaxTimeZoneMicroseconds;

  static final Duration localOffset = Global.kStartTime.timeZoneOffset;

  /// The local Time Zone Offset in microseconds.
  static final int localInMicroseconds =
      Global.kStartTime.timeZoneOffset.inMicroseconds;

  /// The local [TimeZone].
  static final TimeZone local =
      new TimeZone.fromMicroseconds(localInMicroseconds);

  static final int localIndex =
      kValidTZMicroseconds.indexOf(localInMicroseconds);

  static final String localName = Global.kStartTime.timeZoneName;

  static TimeZone microsecondsToTimeZone(int us) {
    final index = kValidTZMicroseconds.indexOf(us);
    return (index == -1) ? badTimeMicroseconds(us) : kMembers[index];
  }

  static TimeZone parse(String s,
      {int start = 0,
      int end,
      bool asDicom = true,
      Issues issues,
      OnParseError onError}) {
    final us = parseTimeZone(s,
        start: start,
        end: end,
        asDicom: asDicom,
        issues: issues,
        onError: onError);
    return _getTimeZone(us);
  }

  static TimeZone parseDicom(String s,
      {int start = 0, int end, Issues issues, OnParseError onError}) {
    final us = parseDcmTimeZone(s,
        start: start, end: end, issues: issues, onError: onError);
    return _getTimeZone(us);
  }

  static TimeZone parseInternet(String s,
      {int start = 0, int end, Issues issues, OnParseError onError}) {
    final us = parseInternetTimeZone(s,
        start: start, end: end, issues: issues, onError: onError);
    return _getTimeZone(us);
  }

  static TimeZone _getTimeZone(int us) {
    final index = kValidTZMicroseconds.indexOf(us);
    return (index == -1)
        ? invalidTimeZoneMicrosecondsError(us)
        : kMembers[index];
  }

  /// Returns _true_ if [s] is a valid time tone [String].
  static bool isValidString(String s,
          {int start = 0, int end, bool asDicom = true}) =>
      isValidTimeZoneString(s, start: start, end: end);

  /// Returns _true_ if [s] is a valid time zone in DICOM format.
  static bool isValidDcmString(String s,
          {int start = 0, int end, bool asDicom = true}) =>
      isValidDcmTZString(s.substring(start, end));

  /// Returns _true_ if [s] is a valid time zone in Internet format.
  static bool isValidInternetString(String s,
          {int start = 0, int end, bool asDicom = true}) =>
      isValidInternetTimeZoneString(s, start: start, end: end);

  /// Returns _true_ if [minutes] is a valid Time Zone.
  static bool isValidMinutes(int minutes) => isValidTimeZoneMinutes(minutes);

  /// Returns a [Issues] object if there are errors
  /// or warnings related to [s]; otherwise, returns _null_.
  static Issues issues(String s, {int start = 0, int end, Issues issues}) {
    issues ??= new Issues('TimeZone: $s');
    end ??= s.length;
    parseDcmTimeZone(s, start: start, end: end, issues: issues);
    return issues;
  }

  static int compare(TimeZone a, TimeZone b) {
    if (a == b) return 0;
    if (a > b) return 1;
    return -1;
  }

  /// Returns a new time zone [String] that is the hash
  /// of the [TimeZone] argument.
  static String hashString(String s, {bool asDicom = true}) =>
      hashTZString(s, asDicom: asDicom);

  static const TimeZone kTZ0 = const TimeZone._(0, -12, 0, -43200000000, 'Y');
  static const TimeZone kTZ1 = const TimeZone._(1, -11, 0, -39600000000, 'X');
  static const TimeZone kTZ2 = const TimeZone._(2, -10, 0, -36000000000, 'W');
  static const TimeZone kTZ3 = const TimeZone._(3, -9, 30, -34200000000, 'V');
  static const TimeZone kTZ4 = const TimeZone._(4, -9, 0, -32400000000, 'V');
  static const TimeZone kTZ5 = const TimeZone._(5, -8, 0, -28800000000, 'U');
  static const TimeZone kTZ6 = const TimeZone._(6, -7, 0, -25200000000, 'T');
  static const TimeZone kTZ7 = const TimeZone._(7, -6, 0, -21600000000, 'S');
  static const TimeZone kTZ8 = const TimeZone._(8, -5, 0, -18000000000, 'R');
  static const TimeZone kTZ9 = const TimeZone._(9, -4, 0, -14400000000, 'Q');
  static const TimeZone kTZ10 = const TimeZone._(10, -3, 30, -12600000000, 'P');
  static const TimeZone kTZ11 = const TimeZone._(11, -3, 0, -10800000000, 'P');
  static const TimeZone kTZ12 = const TimeZone._(12, -2, 0, -7200000000, 'O');
  static const TimeZone kTZ13 = const TimeZone._(13, -1, 0, -3600000000, 'N');
  static const TimeZone kTZ14 = const TimeZone._(14, 0, 0, 0, 'Z');
  static const TimeZone kTZ15 = const TimeZone._(15, 1, 0, 3600000000, 'A');
  static const TimeZone kTZ16 = const TimeZone._(16, 2, 0, 7200000000, 'B');
  static const TimeZone kTZ17 = const TimeZone._(17, 3, 0, 10800000000, 'C');
  static const TimeZone kTZ18 = const TimeZone._(18, 3, 30, 12600000000, 'C');
  static const TimeZone kTZ19 = const TimeZone._(19, 4, 0, 14400000000, 'D');
  static const TimeZone kTZ20 = const TimeZone._(20, 4, 30, 16200000000, 'D');
  static const TimeZone kTZ21 = const TimeZone._(21, 5, 0, 18000000000, 'E');
  static const TimeZone kTZ22 = const TimeZone._(22, 5, 30, 19800000000, 'E');
  static const TimeZone kTZ23 = const TimeZone._(23, 5, 45, 20700000000, 'E');
  static const TimeZone kTZ24 = const TimeZone._(24, 6, 0, 21600000000, 'F');
  static const TimeZone kTZ25 = const TimeZone._(25, 6, 30, 23400000000, 'F');
  static const TimeZone kTZ26 = const TimeZone._(26, 7, 0, 25200000000, 'G');
  static const TimeZone kTZ27 = const TimeZone._(27, 8, 0, 28800000000, 'H');
  static const TimeZone kTZ28 = const TimeZone._(28, 8, 30, 30600000000, 'H');
  static const TimeZone kTZ29 = const TimeZone._(29, 8, 45, 31500000000, 'H');
  static const TimeZone kTZ30 = const TimeZone._(30, 9, 0, 32400000000, 'I');
  static const TimeZone kTZ31 = const TimeZone._(31, 9, 30, 34200000000, 'I');
  static const TimeZone kTZ32 = const TimeZone._(32, 10, 0, 36000000000, 'K');
  static const TimeZone kTZ33 = const TimeZone._(33, 10, 30, 37800000000, 'K');
  static const TimeZone kTZ34 = const TimeZone._(34, 11, 0, 39600000000, 'L');
  static const TimeZone kTZ35 = const TimeZone._(35, 12, 0, 43200000000, 'M');
  static const TimeZone kTZ36 = const TimeZone._(36, 12, 45, 45900000000, 'M');
  static const TimeZone kTZ37 = const TimeZone._(37, 13, 0, 46800000000, 'M');
  static const TimeZone kTZ38 = const TimeZone._(38, 14, 0, 50400000000, 'M');

  static const TimeZone utc = kTZ14;
  static const TimeZone usEast = kTZ8;
  static const TimeZone usCentral = kTZ7;
  static const TimeZone usMountain = kTZ6;
  static const TimeZone usPacific = kTZ5;

  static const List<TimeZone> kMembers = const [
    kTZ0, kTZ1, kTZ2, kTZ3, kTZ4, kTZ5, kTZ6, kTZ7, // No reformat
    kTZ8, kTZ9, kTZ10, kTZ11, kTZ12, kTZ13, kTZ14, kTZ15,
    kTZ16, kTZ17, kTZ18, kTZ19, kTZ20, kTZ21, kTZ22, kTZ23,
    kTZ24, kTZ25, kTZ26, kTZ27, kTZ28, kTZ29, kTZ30, kTZ31,
    kTZ32, kTZ33, kTZ34, kTZ35, kTZ36, kTZ37, kTZ38
  ];
}
