// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/core.dart';

void main() {
  //TODO: fix or remove
  //hierarchicalLoggerTest();
  // ServerLogger system = new ServerLogger();
  //print('System: $system');
  final log = new Logger('server_test')
    ..info
    ..error('shout level')
    ..severe('severe level')
    ..error('error level')
    ..warn('warning level')
    ..config('config level')
    ..info0('info0 level')
    ..debug('debug level')
    ..debug0('debug0 level')
    ..debug1('debug1 level')
    ..debug2('debug2 level')
    ..debug2('debug3 level');
//    ..fatal('die *******');
  print(log);
}

const String defaultDateTimeFormat = 'yyyy.mm.dd HH:mm:ss.SSS';

void hierarchicalLoggerTest() {
  //TODO: improve this test
  print('Root.Level: ${Logger.root.level}');
  Logger.root.level = Level.config;
  print('Root.Level: ${Logger.root.level}');
  final log = new Logger('test')
    ..error('error level')
    ..warn('warning level')
    ..config('config level')
    ..info0('info0 level')
    ..debug('debug level')
    ..debug0('debug0 level')
    ..debug1('debug1 level')
    ..debug2('debug2 level')
    ..debug3('debug3 level')
    ..fatal('die *******');
  print(log);
}
