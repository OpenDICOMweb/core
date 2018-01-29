// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:async';

import 'package:core/src/logger/date_time_utils.dart' as dtu;
import 'package:core/src/logger/log_level.dart';
import 'package:core/src/logger/logger.dart';

/// A log entry representation used to propagate information from [Logger] to
/// individual Handlers.
class LogRecord {
  final Level level;
  final String message;

  /// Non-string message passed to Logger.
  final Object object;

  /// The name of the Logger where this record is stored.
  final String name;

  /// Time when this record was created.
  final DateTime dt;

  /// Unique sequence number greater than all log records created before it.
  final int index;

  /// Associated error (if any) when recording errors messages.
  final Object error;

  /// Associated stackTrace (if any) when recording errors messages.
  final StackTrace trace;

  /// Zone of the calling code which resulted in this LogRecord.
  final Zone zone;

  LogRecord(this.level, this.message, this.name,
      [this.error, this.trace, this.zone, this.object])
      : dt = new DateTime.now(),
        index = _count++;

  String get date => dtu.date(dt);
  String get time => dtu.time(dt);
  String get dateTime => '$dt';

  String get json => '''{
  "@type": "$runtimeType",
  "Level": "$level",
  "Message": "$message",
  "Name": "$name",
  "Error": "$error",
  "Trace": "$trace",
  "Zone": "$zone",
  "Object": "$object} 
  "Time": "$dt",
  "Index": "$index"
}''';

  String get info => '''
$runtimeType
  Level:   $level
  Message: '$message'
  Name:    $name
  Error:   $error
  Trace:   $trace
  Zone:    $zone
  Object:  $object 
  Time:    '$dt'
  Index:   $index
''';

  @override
  String toString() => '[${level.abbr}] $message';

  /// The index of the last [LogRecord] created.
  static int _count = 0;
}

typedef String RecordFormatter(LogRecord record);

//TODO: create standard set of formatters.
String shortFormatter(LogRecord r) =>
    '[${r.level.abbr}] ${r.message} <${r.name}>';
