//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/utils/parser.dart';
import 'package:core/server.dart';

void main() {
  Server.initialize(name: 'bin/date_time', level: Level.debug);

  log.debug('Test Dates');
  const s = '230718.1234';
  final dt = parseDcmDateTime(s);
  log.debug('  Time "$s": $dt');

  goodDcmDates();
  badDcmDates();

  goodDcmTimes();
  badDcmTimes();

  parseFractionTest();
}

void parseFractionTest() {
  const goodFractions = <String>[
    '.0', '.1', '.90', '.101', '.9091', '.10987', '.123456',
    '.987654', '.000000', '.000001', '.100000', '.999999',
    '.012345', '.199990' // Don't reformat.
  ];

  log.debug('Good Fractions');
  for (final s in goodFractions) {
    final f = parseFraction(s);
    log.debug('    $s: $f');
  }
}

void goodDcmDates() {
  const goodDcmDateList = ['19500718', '00000101', '19700101'];

  log.debug('Good Dates');
  for (final s in goodDcmDateList) {
    final d = Date.parse(s);
    log.debug('  Date $s: $d');
  }
}

void badDcmDates() {
  const badDcmDateList = <String>[
    '19501318', // bad month
    '19501032', // bad day
    '00000032', // bad month and day
    '00000000', // bad month and day
    '-9700101', // bad character in year
    '1b700101', // bad character in year
    '19c00101', // bad character in year
    '197d0101', // bad character in year
    '1970a101', // bad character in month
    '19700b01', // bad character in month
    '197001a1', // bad character in day
    '1970011a', // bad character in day
  ];

  log.debug('Bad Dates');
  for (final s in badDcmDateList) {
    final d = Date.parse(s);
    log.debug('  Date: $s: $d');
  }
}

void goodDcmTimes() {
  const goodDcmDateTimeList = <String>[
    '1950',
    '195007',
    '19500718',
    '1950071823',
    '195007182307',
    '19500718230718',
    '19500718000000',
    '19500718190101',
    '19500718235959',
    '19500718010101.1',
    '19500718010101.11',
    '19500718010101.111',
    '19500718010101.1111',
    '19500718010101.11111',
    '19500718010101.111111',
    '19500718000000.0',
    '19500718000000.00',
    '19500718000000.000',
    '19500718000000.0000',
    '19500718000000.00000',
    '19500718000000.000000',
    '1950',
    '195007',
    '19500718',
    '1950071800',
    '195007180011',
    '19500718001122',
    '19500718001122.111111',
    '19500718001122.1',
    '19500718001122.11',
    '19500718001122.111',
    '19500718001122.1111',
    '19500718001122.111111',
  ];

  log.debug('Good DcmDateTimes');
  for (final s in goodDcmDateTimeList) {
    log.debug('DateTime: $s');
    final dt = DcmDateTime.parse(s);
    log
      ..debug('   DateTime $s: $dt')
      ..debug('       Year $s: ${dt.year}')
      ..debug('      Month $s: ${dt.m}')
      ..debug('        Day $s: ${dt.d}')
      ..debug('       Hour $s: ${dt.d}')
      ..debug('     Minute $s: ${dt.d}')
      ..debug('    Seconde $s: ${dt.d}')
      ..debug('  Milliseconds: ${dt.millisecond}')
      ..debug('  Microseconds: ${dt.microsecond}')
      ..debug('  Fraction: ${dt.fraction}')
      ..debug('  ms: ${dt.ms}')
      ..debug('  us: ${dt.us}');
  }
}

void badDcmTimes() {
  const badDcmTimeList = <String>[
    '241318', // bad hour
    '006132', // bad minute
    '006161', // bad minute and second
    '000000', // bad month and day
    '-00101', // bad character in hour
    'a00101', // bad character in hour
    '0a0101', // bad character in hour
    'ad0101', // bad characters in hour
    '19a101', // bad character in minute
    '190b01', // bad character in minute
    '1901a1', // bad character in second
    '19011a', // bad character in second
    '999999.9',
    '999999.99',
    '999999.999',
    '999999.9999',
    '999999.99999',
    '999999.999999',
  ];

  log.debug('Bad Times');
  for (final s in badDcmTimeList) {
    final t = Time.parse(s);
    log.debug('  Time: $s: $t');
  }
}
