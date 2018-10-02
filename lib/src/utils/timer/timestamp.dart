//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/utils/hash.dart';

// ignore_for_file: public_member_api_docs

/// A [Timestamp] with an optional [msg].
class Timestamp {
  final DateTime dt;
  final String msg;

  Timestamp([this.msg = '']) : dt = DateTime.now();

  /// Creates a new local Timestamp from a [DateTime],
  /// along with an optional message
  Timestamp.fromDateTime(this.dt, [this.msg = '']);

  @override
  bool operator ==(Object other) =>
      (other is Timestamp) && (dt == other.dt) && (msg == other.msg);

  @override
  int get hashCode => Hash64.k2(dt, msg);

  DateTime get value => dt;

  /// Returns a String with the full [DateTime] followed by the [msg].
  String get full => '${dt.toString()}: $msg';

  /// Returns the date component in internet format
  String get date => '${dt.day}-${dt.month}-${dt.year}';

  /// Returns the date component in internet format
  String get time => '${dt.hour}:${dt.minute}:${dt.second}.${dt.millisecond}';

  /// Returns a formatted String of the time component
  /// without fractional seconds.
  String get second => '${dt.hour}:${dt.minute}:${dt.second}';

  /// Return the fraction part of the second.
  String get fraction => '$millisecond$microsecond';

  /// Returns a formatted String of the time component including milliseconds.
  String get millisecond =>
      '${dt.hour}:${dt.minute}:${dt.second}.${dt.millisecond}';

  /// Returns a formatted String of the time component including microseconds.
  String get microsecond =>
      '${dt.hour}:${dt.minute}:${dt.second}.'
          '${dt.millisecond},${dt.microsecond}';

  /// Returns the name of the Time Zone for _this_.
  String get tzName => dt.timeZoneName;

  /// Returns the Time Zone offset as a [String].
  String get tzOffset => dt.timeZoneOffset.toString();

  /// Returns the DataTime in local time.
  DateTime get asLocal => dt.toLocal();

  /// Returns true if [DateTime] is in the local Time Zone.
  bool get isLocal => !dt.isUtc;

  /// Returns the DateTime in UTC.
  DateTime get asUtc => dt.toUtc();

  /// Returns true if [DateTime] is in UTC.
  bool get isUtc => dt.isUtc;

  /// Returns the [Timestamp] message in milliseconds
  String get inSeconds => '$second: $msg';

  /// Returns the [Timestamp] message in milliseconds
  String get inMilliseconds => '$millisecond: $msg';

  /// Returns the [Timestamp] message in microseconds
  String get inMicroseconds => '$microsecond: $msg';

  /// Returns the [String] for _this_.
  @override
  String toString() => '$second: $msg';

  // ignore: prefer_constructors_over_static_methods
  static Timestamp get now => Timestamp();
}
