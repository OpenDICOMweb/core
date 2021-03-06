// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/logger/log_record.dart';
import 'package:core/src/logger/server/handler_base.dart';

class LogList {
  String name;
  List<String> log = <String>[];

  LogList(this.name);

  int get length => log.length;

  void add(String entry) {
    log.add(entry);
  }
}

class ListHandler extends HandlerBase {
  final List<LogRecord>logEntries = <LogRecord>[];
  final String name;

  ListHandler(this.name, {bool doPrint: true}) : super(doPrint: doPrint);

  @override
  LogRecord call(LogRecord record, {bool flush}) {
    logEntries.add(record);
    if (doPrint) print(record.info);
    return record;
  }

  @override
  String toString() {
  	final sb = new StringBuffer('ListHandler: $name\n');
    for(var v in logEntries) sb.write('  $v\n');
    return sb.toString();
  }
}
