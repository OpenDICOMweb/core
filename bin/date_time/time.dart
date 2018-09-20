//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/server.dart';

void main() {
  Server.initialize(name: 'bin/test_time', level: Level.info0);

  log.debug('Good parseDcmTime');
  const s = '24, 10, 20';
  log.debug('  parseDcmTime: $s');
  final us = parseDcmTime(s);
  log.debug('    parseDcmTime: $us');
}

const List<String> goodDcmTimeList = <String>[
  '230718',
  '000000',
  '190101',
  '235959',
  '010101.1',
  '010101.11',
  '010101.111',
  '010101.1111',
  '010101.11111',
  '010101.111111',
  '000000.0',
  '000000.00',
  '000000.000',
  '000000.0000',
  '000000.00000',
  '000000.000000',
  '00',
  '0000',
  '000000',
  '000000.1',
  '000000.111111',
  '01',
  '0101',
  '010101',
  '010101.1',
  '010101.111111',
  '10',
  '1010',
  '101010',
  '101010.1',
  '101010.111111',
  '22',
  '2222',
  '222222',
  '222222.1',
  '222222.111111',
  '23',
  '2323',
  '232323',
  '232323.1',
  '232323.111111',
  '23',
  '2359',
  '235959',
  '235959.1',
  '235959.111111',
];

/*
    test('Good parseDcmTime', () {
      log.debug('Good isValidDcmTime');
      for (String s in goodDcmTimeList) {
        log.debug('  isValidDcmTime: $s');
        bool v = isValidDcmTime(s);
        log.debug('    isValidDcmTime: "$s", $v');
        expect(v, true);
      }
    });

    test('Good getDcmTimeIssues', () {
      for (String s in goodDcmTimeList) {
        log.debug('  getDcmTimeIssues: $s');
        var issues = new Issues('getDcmTimeIssues', s);
        getDcmTimeIssues(s, issues);
        log.debug('    getDcmTimeIssues: "$s", issues: $issues');
        expect(issues.isEmpty, true);
      }
    });

    test('Good Time.parse', () {
      log.debug('Good Times');
      for (String s in goodDcmTimeList) {
        log.debug('Time: $s');
        Time t = Time.parse(s);
        log.debug('  Time $s: $t');
        log.debug('  Milliseconds: ${t.millisecond}');
        log.debug('  Microseconds: ${t.microsecond}');
        log.debug('  Fraction: ${t.fraction}');
        log.debug('  ms: ${t.f}');
        log.debug('  us: ${t.f}');
      }
    });
  });

    });
*/
const List<String> goodFractions = <String>[
  '.0',
  '.1',
  '.90',
  '.101',
  '.9091',
  '.10987',
  '.123456',
  '.987654',
  '.000000',
  '.000001',
  '.100000',
  '.999999',
  '.012345',
  '.199990', // Don't reformat.
  '.9',
  '.99',
  '.999',
  '.9999',
  '.99999',
  '.999999',
];
