//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/server.dart';

/*  Flush? parseYear has been removed
void main() {
  Server.initialize(name: 'bin/date', level: Level.info0);
  log.debug('Test Dates');
  var s = "230718.1234";
  int t = parseDcmTime(s);
  log.debug('  Time "$s": $t');

  parseGoodYears();

  goodDcmDates();
  badDcmDates();

  goodDcmTimes();
  badDcmTimes();
}
*/

/* Flush? parseYear has been removed
void parseGoodYears() {
  List<int> nList = [0000, 1950, 2000, 0009, 0099, 0999, 9999];
  List<String> sList = ["0000", "1950", "2000", "0009", "0099", "0999", "9999"];

  log.debug('Good Years');
  for (int i = 0; i < sList.length; i++) {
    var s = sList[i];
    var v = nList[i];
    log.debug('$v: "$s"');
    int y = parseYear(s);
    assert(y == v);
    log.debug('    $s: $y');
  }
}
*/

/*  Flush? parseYear has been removed
// What can be wrong with a bad year?
// 1. Invalid length
// 2. Invalid Character
void parseBadYears() {
  List<String> sList = ["0", "1950", "2000", "0009", "0099", "0999", "9999"];

  log.debug('Good Years');
  for (int i = 0; i < sList.length; i++) {
    var s = sList[i];
    log.debug('Year: "$s"');
    int y = parseYear(s);
    assert(y == null);
    int v = parseYear(s);
    assert(y == v);
    log.debug('    $s: $y');
  }
}
*/

/*  Flush? parseYear has been removed
void testFraction() {
  List<String> goodFractions = <String>[
    ".0", ".1", ".90", ".101", ".9091", ".10987", ".123456",
    ".987654", ".000000", ".000001", ".100000", ".999999",
    ".012345", ".199990" // Don't reformat.
  ];

  log.debug('Good Fractions');
  for (String s in goodFractions) {
    int f = parseTimeFraction(s);
    log.debug('    $s: $f');
  }
}
*/

void goodDcmDates() {
  const goodDcmDateList = const <String>['19500718', '00000101', '19700101'];

  log.debug('Good Dates');
  for (var s in goodDcmDateList) {
    final d = Date.parse(s);
    log.debug('  Date $s: $d');
  }
}

void badDcmDates() {
  const badDcmDateList = const <String>[
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
  for (var s in badDcmDateList) {
    final d = Date.parse(s);
    log.debug('  Date: $s: $d');
  }
}

void goodDcmTimes() {
  const goodDcmTimeList = const <String>[
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

  log.debug('Bad Dates');
  for (var s in goodDcmTimeList) {
    final time = Time.parse(s);
    log.debug('  Time: "$s": $time');
  }
}

const List<String> badDcmTimeList = const <String>[
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

void badDcmTimes() {
  log.debug('Bad Dates');
  for (var s in badDcmTimeList) {
    final t = Time.parse(s);
    log.debug('  Date: $s: $t');
  }
}
