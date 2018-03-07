// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

//import 'package:intl/intl.dart';

import 'package:core/src/utils/logger/date_time_utils.dart';
import 'package:core/src/utils/logger/log_record.dart';
import 'package:core/src/utils/logger/transformer/transformer.dart';

//TODO: should this be a handler or a separate class that is an argument to a handler?
/// Format a log record according to a string pattern
/// Designed be used as follows:
///     LogFormatter format = new LogFormatter(...);
///     format(logRecord);
///
/// The uppercase format tokens (%I, %L, %T) are for internal
/// values generated/managed by the [Formatter]. The lowercase
/// tokens (%e, %m, %n, %x) are for externally supplied values.
class Formatter extends Transformer {
  /// The [level] of _this_.
  static const String level = '%L'; // changed from '%p'

  /// The [message] of _this_.
  static const String message = '%m';

  /// The [name] of _this_.
  static const String name = '%n';

  /// The [time] of _this_.
  static const String time = '%T'; // logger date timestamp.  Format using

  /// Outputs the logger [index], a unique number starting
  /// with 0 and incremented for every new LogRecord
  static const String index = '%I'; // changed from '%s'

  /// Outputs [Exception] name
  static const String exception = '%x'; // logger exception

  /// Default format for a log message that does not contain an exception.
  static const String defaultMessageFormat = '%L [%T]\n  %n: %m';
  static const String simpleMessageFormat = '%L\n%n:\t%m';

  /// Default date time format for log messages
  static const String defaultDateTimeFormat = 'yyyy.mm.dd HH:mm:ss.SSS';

  /// Default format for a log message the contains an exception
  /// This is appended onto the message format if there is an exception
  static const String defaultExceptionFormat = '\n  %e: %x';

  /// Outputs [Exception] [message]
  static const String exceptionMessage = '%e'; // logger exception message

  /// Contains the standard message format string
  final String messageFormat;

  /// Contains the exception format string
  final String exceptionFormat;

  /// Contains the timestamp format string
  final String timestampFormat;

  Formatter(
      {this.messageFormat: defaultMessageFormat,
      this.exceptionFormat: defaultExceptionFormat,
      this.timestampFormat: defaultDateTimeFormat}) {
    print('msg:$messageFormat, excp: $exceptionFormat, tstamp: $timestampFormat');
  }

  /// The regexp pattern
  static const String regexpString =
      '($level|$message|$name|$time|$index|$exception|$exceptionMessage)';
  static final _regexp = new RegExp(regexpString);

  //TODO: rather than build the string while logging the message.  Precompile it.
  /// Transform the [LogRecord] into a formatted string according to the [messageFormat],
  /// [exceptionFormat], and [timestampFormat] pattern.
  @override
  String call(LogRecord record) {
    final formatString = '$messageFormat$exceptionFormat';
    // build the log string and return
    return formatString.replaceAllMapped(_regexp, (match) {
      if (match.groupCount == 1) {
        switch (match.group(0)) {
          case level:
            return record.level.name;
          case message:
            return record.message;
          case name:
            return record.name;
          case time:
            return dateTime(record.dt);
          case index:
            return record.index.toString();
          case exception:
          case exceptionMessage:
            return exception;
        }
      }
      return ''; // empty string
    });
  }

  static final Formatter format = new Formatter();
}
