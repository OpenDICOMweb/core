// Copyright (c) 2016, 2017 Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/core.dart';
/// Returns the date in Internet format.
String _date(DateTime dt) => dtToDateString(dt);

/// Returns the time in Internet format.
String _time(DateTime dt) => dtToTimeString(dt);

/// Returns the date/time in Internet format.
String _dateTime(DateTime dt) => dtToDateTimeString(dt);


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

  LogFile.json({String prefix: 'log', this.mode: LogMode.delete, this.timeFmt: TimeFmt.date})
      : path = _getPath(prefix, timeFmt, LogType.json);

  LogFile.text({String prefix: 'log', this.mode: LogMode.delete, this.timeFmt: TimeFmt.date})
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
        fName = '$prefix\_${_date(dt)}';
        break;
      case TimeFmt.time:
        fName = '$prefix\_${_time(dt)}';
        break;
      case TimeFmt.dateTime:
        fName = '$prefix\_${_dateTime(dt)}';
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
