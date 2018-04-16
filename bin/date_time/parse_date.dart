//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/server.dart';

void main(List<String> args) {
  Server.initialize(name: 'bin/test_time', level: Level.debug0);
  testPrintIssues();
  print('------\n');
//  testOneYearIssues();
  print('------\n');
//  testYearLengthOnlyIssues();
  print('------\n');
//  testYearLengthAndCharIssues();
  print('------\n');
//  testGoodMonthLengthAndCharIssues();
  print('------\n');
  testBadMonthLengthAndCharIssues();
  print('------\n');
  testGoodDateIssues();
  print('------\n');
  testBadDateIssues();
  print('------\n');
}

void testPrintIssues() {
  final issues = new Issues('testPrintIssues')
    ..add('first issue')
    ..add('second issue')
    ..add('third issue')
    ..add('fourth issue');
  if (issues.isNotEmpty)
    log.debug('  ${issues.info}');
}

/*  Flush? parseYear has been removed
void testOneYearIssues() {
  String year = '0bc';
  var issues = new Issues('Date', year);
  try {
    parseYear(year, 0, issues);
    log.error('Bad year '$year' did not generate an error');
  } catch(e) {
    log.debug('test passed: $year is invalid year');
  }
  if (issues.isNotEmpty) log.debug('  ${issues.info}');
}
*/

/*  Flush? parseYear has been removed
void testYearLengthOnlyIssues() {
  List<String> numbers = <String>['0', '01', '012', '012345'];
  log.debug('testYearLengthOnlyIssues:');
  for (int i = 0; i < numbers.length; i++) {
    var year = numbers[i];
    log.debug('  year: $year');
    var issues = new Issues('Date', year);
    try {
      parseYear(year, 0, issues);
      log.error('Bad year '$year' did not generate an error');
    } catch(e) {
      log.debug('test passed: $year is invalid year');
    }
    if (issues.isNotEmpty) log.debug('  ${issues.info}');
  }
}
*/

/*  Flush or Fix: parseYear has been removed
void testYearLengthAndCharIssues() {
  List<String> numbers = <String>['a', 'ab', 'abc', 'abcd', 'abced'];
  log.debug('testYearLengthOnlyIssues:');
  for (int i = 0; i < numbers.length; i++) {
    var year = numbers[i];
    log.debug('  year: $year');
    var issues = new Issues('Date', year);
    try {
      parseYear(year, 0, issues);
      log.error('Bad year '$year' did not generate an error');
    } catch(e) {
      log.debug('test passed: $year has invalid length');
    }
    if (issues.isNotEmpty) log.debug('  ${issues.info}');
  }
}
*/

/*  Flush or Fix: parseYear has been removed
void testGoodMonthLengthAndCharIssues() {
  List<String> numbers = <String>['01', '02', '12'];
  log.debug('testGoodMonthLengthAndCharIssues:');
  for (int i = 0; i < numbers.length; i++) {
    var year = numbers[i];
    log.debug('  year: $year');
    var issues = new Issues('Date', year);
    try {
      parseYear(year, 0, issues);
    } catch(e) {
      log.error(e);
    }
    if (issues.isNotEmpty) log.debug('  ${issues.info}');
  }
}
*/

void testBadMonthLengthAndCharIssues() {
  final numbers = <String>['0', '023', 'a', 'ab', 'abc'];
  log.debug('testBadMonthLengthAndCharIssues:');
  for (var i = 0; i < numbers.length; i++) {
    final year = numbers[i];
    log.debug('  year: $year');
    final issues = new Issues('Date Year: $year');
    if (issues.isNotEmpty)
      log.debug('  ${issues.info}');
  }
}

void testGoodDateIssues() {
  const dates = const <String>['10500718', '19000101', '20001212'];
  log.debug('testGoodDateIssues:');
  for (var i = 0; i < dates.length; i++) {
    final date = dates[i];
    log.debug('  date: $date');
    final issues = new Issues('Date: $date');
    if (issues.isNotEmpty)
      log.debug('  ${issues.info}');
  }
}

void testBadDateIssues() {
  const dates = const <String>[
    '1950071', '190001010', //bad length
    '2a0b1212', '1900Z1010', // good length bad char
    '2a0b121', '1900Z10100' // bad length and bad char
  ];

  log.debug('testBadDateIssues:');
  for (var i = 0; i < dates.length; i++) {
    final date = dates[i];
    log.debug('  date: $date');
    final issues = new Issues('Date: $date');
    if (issues.isNotEmpty)
      log.debug('  ${issues.info}');
  }
}
