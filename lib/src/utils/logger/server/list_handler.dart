//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/utils/logger/log_record.dart';
import 'package:core/src/utils/logger/server/handler_base.dart';

// ignore_for_file: public_member_api_docs

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

  ListHandler(this.name, {bool doPrint = true}) : super(doPrint: doPrint);

  @override
  LogRecord call(LogRecord r, {bool flush}) {
    logEntries.add(r);
    if (doPrint) print(r.info);
    return r;
  }

  @override
  String toString() {
  	final sb = StringBuffer('ListHandler: $name\n');
    for(final v in logEntries) sb.write('  $v\n');
    return sb.toString();
  }
}
