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

Logger log = new Logger('test', Level.info);

void main() {
  Server.initialize(name: 'logger/logger_test', level: Level.info);

  group('Logger Tests', () {
    test('Simple test', () {
      log
        ..warn('This is debug msg 0')
        ..debug('This is debug msg 1', 1)
        ..debug('This is debug msg 2', 1)
        ..debug('This is debug msg 3', -1)
        ..debug('This is debug msg 4', -1)
        ..debug('This is debug msg 5');
    });

    test('UP/DOWN test', () {
      log
        ..debug('This is debug msg 0')
        ..down
        ..debug('This is debug msg 1')
        ..down
        ..debug('This is debug msg 2')
        ..down
        ..debug('This is debug msg 3')
        ..up
        ..debug('This is debug msg 4')
        ..up
        ..debug('This is debug msg 5')
        ..up;
    });
  });
}
