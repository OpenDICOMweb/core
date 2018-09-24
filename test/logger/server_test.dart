//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

const String defaultDateTimeFormat = 'yyyy.mm.dd HH:mm:ss.SSS';

void main() {
  Server.initialize(name: 'logger/server_test', level: Level.info);

  //TODO: make sure this is testing hierarchical logger
  test('Non-Hierarchical Logger Test', () {
    final log0 = Logger('server_test')
      ..info('info level')
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

    expect(() => log0.fatal('die *******'),
        throwsA(const TypeMatcher<FatalError>()));

    log0.debug(log0);
  });

  test('Hierarchical Logger Test', () {
    final log0 = Logger('server_test')
      ..debug('Root.Level: ${Logger.root.level}');
    Logger.root.level = Level.config;
    log0.debug('Root.Level: ${Logger.root.level}');

    final log1 = Logger('test')
      ..error('error level')
      ..warn('warning level')
      ..config('config level')
      ..info0('info0 level')
      ..debug('debug level')
      ..debug0('debug0 level')
      ..debug1('debug1 level')
      ..debug2('debug2 level')
      ..debug3('debug3 level');

    expect(() => log1.fatal('die *******'),
        throwsA(const TypeMatcher<FatalError>()));

    log1.debug(log1);
  });
}
