//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/utils/logger/date_time_utils.dart';

// ignore_for_file: public_member_api_docs

enum LogMode { append, delete }

enum LogType { text, json, map }

enum TimeFmt { none, date, time, dateTime }

const List<LogType> defaultLogFileTypes = const [LogType.text, LogType.json];

/// LogFileName format = name '_' suffix '.' ext
class LogFile {
  String path;
  LogMode mode;
  TimeFmt timeFmt;
  LogType type;

  LogFile(
      {String prefix: 'log',
      this.mode: LogMode.delete,
      this.timeFmt: TimeFmt.dateTime,
      this.type: LogType.text})
      : path = _getPath(prefix, timeFmt, type);

  LogFile.json(
      {String prefix: 'log',
      this.mode: LogMode.delete,
      this.timeFmt: TimeFmt.date})
      : path = _getPath(prefix, timeFmt, LogType.json);

  LogFile.text(
      {String prefix: 'log',
      this.mode: LogMode.delete,
      this.timeFmt: TimeFmt.date})
      : path = _getPath(prefix, timeFmt, LogType.text);

  String get info => '''
$runtimeType: '$path',
  Mode: $mode
  Type: $type
  ''';
  @override
  String toString() => 'LogFile: $path';

  static String _getPath(String prefix, TimeFmt fmt, LogType type) {
    String fName;
    final dt = new DateTime.now();
    switch (fmt) {
      case TimeFmt.none:
        fName = prefix;
        break;
      case TimeFmt.date:
        fName = '$prefix\_${date(dt)}';
        break;
      case TimeFmt.time:
        fName = '$prefix\_${time(dt)}';
        break;
      case TimeFmt.dateTime:
        fName = '$prefix\_${dateTime(dt)}';
        break;
      default:
        throw new ArgumentError('$fmt');
    }

    switch (type) {
      case LogType.text:
        fName = '$fName.log';
        break;
      case LogType.json:
        fName = '$fName.json';
        break;
      default:
        throw new ArgumentError('Invalid type: $type');
    }
    return fName;
  }
}

class LogCache {
  int uploadCount = 50;
  final LogFile name = new LogFile(prefix: 'logFileCache');
}
