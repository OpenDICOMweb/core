// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/core.dart';
import 'package:test/test.dart';

Logger log = new Logger('test', Level.debug);

void main() {

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
