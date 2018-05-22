//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  const startYear = 1970 - 3000;
  const endYear = 1970 + 1000;
  Server.initialize(
      name: 'epoch_day_test',
      // These next two values allow this program to run all valid
      // Epoch Days if desired, but it takes a long time.
      minYear: startYear,
      maxYear: endYear,
      level: Level.info);

  // These next two values are used throughout the test
  // They can be changed to make the tests longer or shorter

  final startMicrosecond = dateToEpochMicroseconds(startYear, 1, 1);
  final endMicrosecond = dateToEpochMicroseconds(endYear, 1, 1);

  group('Test Day Part of String', () {
    global.level = Level.info0;

    test('Leap Year Basic Test', () {
      for (var y in goodBasicLeapYears) {
        final a = isLeapYear(y);
        final b = isCommonYear(y);
        log
          ..debug('$y: $a')
          ..debug1('y % 4: ${y % 4}');
        expect(a, true);
        expect(b, false);
      }
      for (var y in goodSpecialLeapYears) {
        final a = isLeapYear(y);
        final b = isCommonYear(y);
        log
          ..debug('$y: $a')
          ..debug1('y % 4: ${y % 4}');
        expect(a, true);
        expect(b, false);
      }
    });

    test('Common Year Test', () {
      for (var y in goodBasicCommonYears) {
        final a = isCommonYear(y);
        final b = isLeapYear(y);
        log
          ..debug('$y: $a')
          ..debug1('y % 4: ${y % 4}');
        expect(a, true);
        expect(b, false);
      }

      for (var y in goodSpecialCommonYears) {
        final a = isCommonYear(y);
        final b = isLeapYear(y);

        log
          ..debug('$y: $a')
          ..debug1('y % 4: ${y % 4}');
        expect(a, true);
        expect(b, false);
      }
    });

    test('isValidDate Test', () {
      for (var date in validDateLists) {
        final x = isValidDate(date[0], date[1], date[2]);
        log.debug('$date: $x');
        expect(x, true);
      }
      for (var date in invalidDateLists) {
        final x = isValidDate(date[0], date[1], date[2]);
        log.debug('$date: $x');
        expect(x, false);
      }
    });

    test('Leap Year Performance Test', () {
//      global.level = Level.info2;
      log.debug('Leap Year Perfermance Test: $startYear - $endYear');
      final watch = new Stopwatch()..start();

      for (var i = startYear; i < endYear; i++) {
        final List<int> date = epochMicrosecondToDate(i * kMicrosecondsPerDay);
        final y = date[0];
        final m = date[1];
        final d = date[2];
        log.debug1('   day: $i,  y: $y, m: $m, d: $d');
        final n = dateToEpochMicroseconds(y, m, d);
        log.debug('  date: $date, i=$i, n=$n, ${i == n}');
        expect(i * kMicrosecondsPerDay == n, true);

        log.debug1('  leap: $y, ${isLeapYear(y)}');
        final last = lastDayOfMonth(y, m);
        log.debug('  last: $m:$last');
        if (isLeapYear(y) && m == 2) {
          log.debug1('   Leap Year: month: $m, day: $d');
          expect(last == 29, true);
        } else {
          expect(last == daysInCommonYearMonth[m], true);
        }
      }
      watch.stop();
      log.debug('    Elapsed: ${watch.elapsed}');
    });

    test('Basic EpochMicroseconds', () {
      log
        ..debug('zeroDay: $kEpochDayZeroInMicroseconds')
        ..debug('zeroDayAsList: $kEpochDateZero');

      // Base tests
      expect(
          weekdayFromEpochDay(
                  kEpochDayZeroInMicroseconds ~/ kMicrosecondsPerDay) ==
              kEpochDayZeroWeekday,
          true);

      // Dates before Epoch Day
      expect(dateToEpochMicroseconds(1969, 12, 31) == -1 * kMicrosecondsPerDay,
          true);
      expect(dateToEpochMicroseconds(1969, 12, 30) == -2 * kMicrosecondsPerDay,
          true);
      expect(dateToEpochMicroseconds(1969, 12, 29) == -3 * kMicrosecondsPerDay,
          true);
      log.debug1(
          '1968-12-31 Epoch Day: ${dateToEpochMicroseconds(1968, 12, 31)}');
      expect(
          dateToEpochMicroseconds(1968, 12, 31) == -366 * kMicrosecondsPerDay,
          true);

      // Dates after Epoch Day
      expect(
          dateToEpochMicroseconds(1970, 1, 2) == 1 * kMicrosecondsPerDay, true);
      expect(
          dateToEpochMicroseconds(1970, 1, 3) == 2 * kMicrosecondsPerDay, true);
      expect(
          dateToEpochMicroseconds(1970, 1, 4) == 3 * kMicrosecondsPerDay, true);
      expect(dateToEpochMicroseconds(1971, 1, 1) == 365 * kMicrosecondsPerDay,
          true);
    });

    test('Epoch Date Basic Test', () {
      log.debug('Epoch Date Basic Test...');
      final watch = new Stopwatch()..start();
      for (var i = kMinYear; i < kMaxYear; i++) {
        final List<int> date = epochMicrosecondToDate(i * kMicrosecondsPerDay);
        final y = date[0];
        final m = date[1];
        final d = date[2];
        final n = dateToEpochMicroseconds(y, m, d);
        // log.debug0('$i, $n, ${i == n}');
        expect(i * kMicrosecondsPerDay == n, true);
        if (isLeapYear(y) && m == 2 && d == 29) {
          final last = lastDayOfMonth(y, m);
          expect(last == 29, true);
          log.debug0('$y-$m-$d');
        }
      }
      watch.stop();
      log.debug('  Elapsed: ${watch.elapsed}');
    });

    test('Epoch Date Performance Test', () {
      log.debug('Epoch Date Performance Test...');
      global.level = Level.info0;
      log.debug1('  startMicrosecond: $startMicrosecond, endMicrosecond: '
          '$endMicrosecond');

      final startMicroseconds = dateToEpochMicroseconds(startYear, 1, 1);
      log.debug1('  Epoch Start Microseconds: $startMicroseconds');
      final endMicroseconds = dateToEpochMicroseconds(endYear, 1, 1);
      log.debug1('  Epoch End Microseconds: $endMicroseconds');

      final watch = new Stopwatch()..start();
      var previousEpochMicroseconds = startMicroseconds - kMicrosecondsPerDay;
      var nextEpochMicroseconds = startMicroseconds + kMicrosecondsPerDay;
      log.debug1('  Previous Epoch Day: $previousEpochMicroseconds');
      final previousDay =
          weekdayFromEpochDay(previousEpochMicroseconds ~/ kMicrosecondsPerDay);
      final nextDay =
          weekdayFromEpochDay(nextEpochMicroseconds ~/ kMicrosecondsPerDay);
      log.debug1('  Previous Week Day: $previousDay');
      expect(0 <= previousDay && previousDay <= 6, true);
      expect(0 <= nextDay && nextDay <= 6, true);

      log.debug('\n******* Starting Loop');
      watch.start();

      for (var y = startYear; y <= endYear; y++) {
        log.debug0('    Year: $startYear: ${watch.elapsed}');
        for (var m = 1; m <= 12; m++) {
          final lastDay = lastDayOfMonth(y, m);
          log.debug1(
              'Year: $y, Month: $m, lastDay: $lastDay, Leap: ${isLeapYear(y)}');
          for (var d = 1; d <= lastDay; d++) {
            final z = dateToEpochMicroseconds(y, m, d);
            log
              ..debug1('Day: $d z: $z')
              ..debug1('Previous US: $previousEpochMicroseconds')
              ..debug1('Next US: $previousEpochMicroseconds');
            expect(previousEpochMicroseconds == z - kMicrosecondsPerDay, true);
            expect(nextEpochMicroseconds == z + kMicrosecondsPerDay, true);
            previousEpochMicroseconds += kMicrosecondsPerDay;
            nextEpochMicroseconds += kMicrosecondsPerDay;

            final List<int> date = epochMicrosecondToDate(z);
            expect(y == date[0], true);
            expect(m == date[1], true);
            expect(d == date[2], true);
          }
        }
      }
      watch.stop();
      log.debug1('  Elaped Time: ${watch.elapsed}');
      final begin = dateToEpochMicroseconds(startYear, 1, 1);
      final end = dateToEpochMicroseconds(endYear, 12, 31);
      log
        ..debug1('  StartYear: $startYear, EndYear: $endYear, Total Years: '
            '${endYear - startYear}')
        ..debug1('  Tested ${-begin + end} dates');
      watch.stop();
      log.debug('  Elapsed: ${watch.elapsed}');
    });

    test('dateUnitTest', () {
      log
        ..info0('dateUnitTest...')
        ..debug('  startYear: $startYear, endYear: $endYear');

      final startMicroseconds = dateToEpochMicroseconds(startYear, 1, 1);
      log.debug('  Epoch Start US: $startMicroseconds');
      final endMicroseconds = dateToEpochMicroseconds(endYear, 1, 1);
      log.debug('  Epoch End US: $endMicroseconds');

      final zeroDay = dateToEpochMicroseconds(1970, 1, 1);
      final wd = weekdayFromEpochDay(zeroDay ~/ kMicrosecondsPerDay);
      expect(wd == kThursday, true);

      final watch = new Stopwatch()..start();
      var previousEpochMicroseconds = startMicroseconds - kMicrosecondsPerDay;
      log.debug('  Previous Epoch Day: $previousEpochMicroseconds');
      assert(previousEpochMicroseconds < 0);
      var previousWeekDay =
          weekdayFromEpochDay(previousEpochMicroseconds ~/ kMicrosecondsPerDay);
      log.debug('  Previous Week Day: $previousWeekDay');
      //assert(0 <= previousWeekDay && previousWeekDay <= 6);

      // log.debug('\n******* Starting Loop');
      watch.start();
      for (var y = startYear; y <= endYear; y++) {
        if (y % 10000 == 0) log.debug0('    Year: $y: ${watch.elapsed}');
        for (var m = 1; m <= 12; m++) {
          final e = lastDayOfMonth(y, m);
          //    log.debug('Month: $m, lastDay: $e');
          for (var d = 1; d <= e; d++) {
            final z = dateToEpochMicroseconds(y, m, d);
            log.debug('Day: $d z: $z');
            assert(previousEpochMicroseconds < z);
            expect(z == previousEpochMicroseconds + kMicrosecondsPerDay, true);

            final List<int> date = epochMicrosecondToDate(z);
            expect(y == date[0], true);
            expect(m == date[1], true);
            expect(d == date[2], true);
            final wd = weekdayFromEpochDay(z ~/ kMicrosecondsPerDay);
            assert(0 <= wd && wd <= 6);
            final nwd = nextWeekday(previousWeekDay);

            log.debug('$wd, $previousWeekDay: $nwd');
            expect(wd == nwd, true);
            expect(previousWeekDay == previousWeekday(wd), true);
            previousEpochMicroseconds = z;
            log.debug1('  previousEDay: $z');
            previousWeekDay = wd;
            log.debug1('  previousWeekDay: $wd');
          }
        }
      }
      watch.stop();
      log.debug('  Elaped Time: ${watch.elapsed}');
      final begin = dateToEpochMicroseconds(startYear, 1, 1);
      final end = dateToEpochMicroseconds(endYear, 12, 31);
      log
        ..debug('  StartYear: $startYear, EndYear: $endYear, Total Years: '
            '${endYear - startYear}')
        ..debug('  Tested ${-begin + end} dates');
      watch.stop();
      log.debug('  Elapsed: ${watch.elapsed}');
    });
    test('weekDayFromEpochDay', () {
      log.debug('weekDayFromEpochDay');
      final watch = new Stopwatch()..start();
      const zeroWeekDay = kThursday;

      for (var i = 0; i < 10000; i++) {
        final day = (zeroWeekDay + i) % 7;
        final wd = weekdayFromEpochDay(i);

        // log.debug('    $i: day: $day, wd: $wd');
        expect(day == wd, true);
      }
      log
        ..debug3('    Elapesd: ${watch.elapsed}')
        ..debug3('  weekDayFromDay: days <= 0');
      for (var i = 0; i > -10000; i--) {
        final wd = weekdayFromEpochDay(i);
        final day = (zeroWeekDay + i) % 7;
        // log.debug('    $i: day: $day, wd: $wd');
        expect(day == wd, true);
      }
      watch.stop();
      log.debug3('    Elapesd: ${watch.elapsed}');
    });

    test('hashDateMicroseconds', () {
      final hdm0 = hashDateMicroseconds(kMicrosecondsPerDay);
      log.debug('hdm0: $hdm0');
      expect(hdm0, isNotNull);

      final hdm1 = hashDateMicroseconds(-09);
      log.debug('hdm1: $hdm1');
      expect(hdm1, isNotNull);

      final hdm2 = hashDateMicroseconds(0);
      log.debug('hdm2: $hdm2');
      expect(hdm2, isNotNull);

      final hdm3 = hashDateMicroseconds(223);
      log.debug('hdm3: $hdm3');
      expect(hdm3, isNotNull);

      final hdm4 = hashDateMicroseconds(1000);
      log.debug('hdm4: $hdm4');
      expect(hdm4, isNotNull);
    });
  });
}

const List<int> goodBasicLeapYears = const [
  1904, -1908, -1912, -1916, -1920, // No reformat
  1904, 1908, 1912, 1916, 1920,
  1924, 1928, 1932, 1936, 1980,
  1984, 1988, 1992, 1996,
];

const List<int> goodSpecialLeapYears = const [
  -400, -800, -1200, -1600, -2400, 2800, // No reformat
  400, 800, 1200, 1600, 2400, 2800
];

const List<int> goodBasicCommonYears = const [
  -1905, -1909, -1913, -1917, -1921, // No reformat
  1905, 1909, 1913, 1917, 1921, // No reformat
  1925, 1929, 1933, 1937, 1981,
  1985, 1989, 1993, 1997, 2001
];

const List<int> goodSpecialCommonYears = const [
  -100, -200, -300, -700, -900, // No reformat
  100, 200, 300, 700, 900,
  1000, 1100, 1300, 1800, 1900,
  2100, 2200, 2300, 2700, 2900
];

const List<List<int>> validDateLists = const <List<int>>[
  const <int>[1970, 1, 1], // No reformat
  const <int>[1970, 12, 31],
  const <int>[1969, 1, 1],
  const <int>[1969, 12, 31],
  const <int>[1971, 1, 1],
  const <int>[1971, 12, 31],

  const <int>[1968, 2, 29],
  const <int>[1964, 2, 29],

  const <int>[0, 1, 1],
  const <int>[0, 2, 29],
  const <int>[1, 2, 28],
  const <int>[-1, 2, 28]
];

const List<List<int>> invalidDateLists = const <List<int>>[
  const <int>[1970, 0, 1], // No reformat
  const <int>[1970, -1, 1],
  const <int>[1970, -2, 1],
  const <int>[1970, 13, 1],
  const <int>[1970, 14, 1],

  const <int>[1970, 1, 0],
  const <int>[1970, 12, -1],
  const <int>[1970, 12, -2],
  const <int>[1970, 1, -3],
  const <int>[1970, 12, 32],
  const <int>[1970, 12, 33],
  const <int>[1970, 12, 34],

  const <int>[1970, 11, 31],
  const <int>[1971, 10, 32],
  const <int>[1971, 9, 31],

  const <int>[0, 2, 30],
  const <int>[1, 2, 29],
  const <int>[-1, 2, 29]
];
