//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:base/base.dart';
import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

void main() {
  // These next two values are used throughout the test
  // They can be changed to make the tests longer or shorter
  // Note: startYear and endYear must be initialized before
  // calling Server.initialize
  const startYear = 1970 - 10000;
  const endYear = 1970 + 10000;

  Server.initialize(
      name: 'epoch_day_test',
      // These next two values allow this program to run all valid
      // Epoch Days if desired, but it takes a long time.
      minYear: startYear,
      maxYear: endYear,
      level: Level.info);

  final startEpochDay = dateToEpochDay(startYear, 1, 1);
  final endEpochDay = dateToEpochDay(endYear, 12, 31);

  group('Test Day Part of String', () {
    test('Leap Year Basic Test', () {
      for (final y in goodBasicLeapYears) {
        final a = isLeapYear(y);
        final b = isCommonYear(y);
        log
          ..debug('$y: $a')
          ..debug1('y % 4: ${y % 4}');
        expect(a, true);
        expect(b, false);
      }
      for (final y in goodSpecialLeapYears) {
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
      for (final y in goodBasicCommonYears) {
        final a = isCommonYear(y);
        final b = isLeapYear(y);
        log
          ..debug('$y: $a')
          ..debug1('y % 4: ${y % 4}');
        expect(a, true);
        expect(b, false);
      }

      for (final y in goodSpecialCommonYears) {
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
      for (final date in validDateLists) {
        log.debug('$date');
        final x = isValidDate(date[0], date[1], date[2]);
        log.debug('$date: $x');
        expect(x, true);
      }
      for (final date in invalidDateLists) {
        final x = isValidDate(date[0], date[1], date[2]);
        log.debug('$date: $x');
        expect(x, false);
      }
    });

    test('Leap Year Performance Test', () {
      log.debug('Leap Year Perfermance Test: $startYear - $endYear');
      final watch = Stopwatch()..start();

      for (var i = startEpochDay; i < endEpochDay; i++) {
        final date = EpochDate.fromDay(i);
        final y = date.year;
        final m = date.month;
        final d = date.day;
        log.debug1('   day: $i,  y: $y, m: $m, d: $d');

        final n = dateToEpochDay(y, m, d);
        log.debug('  date: $date, i=$i, n=$n, ${i == n}');
        expect(i == n, true);

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

    test('Basic EpochDay', () {
      log
        ..debug('zeroDay: $kEpochDayZero')
        ..debug('zeroDayAsList: ${EpochDate.kZero}');

      // Base tests
      expect(kEpochDayZero == 0, true);
      expect(EpochDate.fromDay(0), equals(EpochDate.kZero));
    });

    test('dateToEpochDay', () {
      expect(dateToEpochDay(1970, 1, 1) == 0, true);

      // Dates before Epoch Day
      expect(dateToEpochDay(1969, 12, 31) == -1, true);
      expect(dateToEpochDay(1969, 12, 30) == -2, true);
      expect(dateToEpochDay(1969, 12, 29) == -3, true);
      log.debug1('1968-12-31 Epoch Day: ${dateToEpochDay(1968, 12, 31)}');
      expect(dateToEpochDay(1968, 12, 31) == -366, true);

      // Dates after Epoch Day
      expect(dateToEpochDay(1970, 1, 2) == 1, true);
      expect(dateToEpochDay(1970, 1, 3) == 2, true);
      expect(dateToEpochDay(1970, 1, 4) == 3, true);
      expect(dateToEpochDay(1971, 1, 1) == 365, true);
    });

    test('dateListsEqual', () {
      const zeroDate = <int>[1970, 1, 1];
      log.debug('zeroDayAsList: $zeroDate');
      final date = EpochDate.fromDay(0);
      expect(date.year == 1970, true);
      expect(date.month == 1, true);
      expect(date.day == 1, true);
    });

    test('weekdayFromEpochDay', () {
      expect(weekdayFromEpochDay(kEpochDayZero) == kEpochDayZeroWeekday, true);

      // Weekdays from Epoch Day
      expect(weekdayFromEpochDay(-364) == kEpochDayZeroWeekday, true);
      expect(weekdayFromEpochDay(364) == kEpochDayZeroWeekday, true);

      // Weekdays from date
      expect(
          weekdayFromEpochDay(dateToEpochDay(1970, 1, 1)) == kThursday, true);
      expect(
          weekdayFromEpochDay(dateToEpochDay(1969, 1, 1)) == kWednesday, true);
      expect(weekdayFromEpochDay(dateToEpochDay(1971, 1, 1)) == kFriday, true);
    });

    test('Epoch Date Basic Test', () {
      log.debug('Epoch Date Basic Test...');
      final watch = Stopwatch()..start();
      final minDay = dateToEpochDay(1970 - 10, 1, 1);
      final maxDay = dateToEpochDay(1970 + 10, 12, 31);
      log..debug('minDay: $minDay')..debug('maxDay: $maxDay');

      for (var i = minDay; i < maxDay; i++) {
        final eDate = EpochDate.fromDay(i);
        log.debug('\neDate: $eDate');
        final y = eDate.year;
        final m = eDate.month;
        final d = eDate.day;
        log..debug('  $y-$m-$d')..debug('i: $i');
        final n = dateToEpochDay(y, m, d);
        // log.debug('$i, $n, ${i == n}');
        log.debug('n: $n');
        expect(i == n, true);
        final s = eDate.asString();
        log.debug('s: $s');

        final date = Date.parse(s);
        final eDay = date.epochDay;
        log.debug('e: $eDay');
        expect(i == eDay, true);
        expect(n == eDay, true);
        if (isLeapYear(y) && m == 2 && d == 29) {
          final last = lastDayOfMonth(y, m);
          expect(last == 29, true);
          log.debug('$y-$m-$d');
        }
      }
      watch.stop();
      log.debug('  Elapsed: ${watch.elapsed}');
    });

    test('Epoch Date Performance Test', () {
      log
        ..debug('Epoch Date Performance Test...')
        ..debug1('  startYear: $startYear, endYear: $endYear');

      final eStart = dateToEpochDay(startYear, 1, 1);
      log.debug1('  Epoch Start Day: $eStart');
      final eEnd = dateToEpochDay(endYear, 1, 1);
      log.debug1('  Epoch End Day: $eEnd');

      final watch = Stopwatch()..start();
      var previousEpochDay = eStart - 1;
      var nextEpochDay = eStart + 1;
      log.debug1('  Previous Epoch Day: $previousEpochDay');
      final previousDay = weekdayFromEpochDay(previousEpochDay);
      final nextDay = weekdayFromEpochDay(nextEpochDay);
      log.debug1('  Previous Week Day: $previousDay');
      expect(0 <= previousDay && previousDay <= 6, true);
      expect(0 <= nextDay && nextDay <= 6, true);

      log.debug('\n******* Starting Loop');
      watch.start();

      for (var y = startYear; y <= endYear; y++) {
        log.debug('    Year: $startYear: ${watch.elapsed}');
        for (var m = 1; m <= 12; m++) {
          final lastDay = lastDayOfMonth(y, m);
          log.debug1(
              'Year: $y, Month: $m, lastDay: $lastDay, Leap: ${isLeapYear(y)}');
          for (var d = 1; d <= lastDay; d++) {
            final z = dateToEpochDay(y, m, d);
            log.debug1('Day: $d z: $z');
            expect(previousEpochDay == z - 1, true);
            expect(nextEpochDay == z + 1, true);
            previousEpochDay++;
            nextEpochDay++;

            final date = EpochDate.fromDay(z);
            expect(y == date.year, true);
            expect(m == date.month, true);
            expect(d == date.day, true);
          }
        }
      }
      watch.stop();
      log.debug1('  Elaped Time: ${watch.elapsed}');
      final begin = dateToEpochDay(startYear, 1, 1);
      final end = dateToEpochDay(endYear, 12, 31);
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

      final eStart = dateToEpochDay(startYear, 1, 1);
      log.debug('  Epoch Start Day: $eStart');
      final eEnd = dateToEpochDay(endYear, 1, 1);
      log.debug('  Epoch End Day: $eEnd');

      final zeroDay = dateToEpochDay(1970, 1, 1);
      final wd = weekdayFromEpochDay(zeroDay);
      expect(wd == kThursday, true);

      final watch = Stopwatch()..start();
      var previousEpochDay = eStart - 1;
      //assert(previousEpochDay < 0);
      log.debug('  Previous Epoch Day: $previousEpochDay');
      var previousWeekDay = weekdayFromEpochDay(previousEpochDay);
      log.debug('  Previous Week Day: $previousWeekDay');
      //assert(0 <= previousWeekDay && previousWeekDay <= 6);

      // log.debug('\n******* Starting Loop');
      watch.start();
      for (var y = startYear; y <= endYear; y++) {
        if (y % 10000 == 0) log.debug('    Year: $y: ${watch.elapsed}');
        for (var m = 1; m <= 12; m++) {
          final e = lastDayOfMonth(y, m);
          //    log.debug('Month: $m, lastDay: $e');
          for (var d = 1; d <= e; d++) {
            final z = dateToEpochDay(y, m, d);
            log.debug('Day: $d z: $z');
            assert(previousEpochDay < z);
            expect(z == previousEpochDay + 1, true);

            final date = EpochDate.fromDay(z);
            expect(y == date.year, true);
            expect(m == date.month, true);
            expect(d == date.day, true);
            final wd = weekdayFromEpochDay(z);
            assert(0 <= wd && wd <= 6);
            final nwd = nextWeekday(previousWeekDay);

            log.debug('$wd, $previousWeekDay: $nwd');
            expect(wd == nwd, true);
            expect(previousWeekDay == previousWeekday(wd), true);
            previousEpochDay = z;
            log.debug1('  previousEDay: $z');
            previousWeekDay = wd;
            log.debug1('  previousWeekDay: $wd');
          }
        }
      }
      watch.stop();
      log.debug('  Elaped Time: ${watch.elapsed}');
      final begin = dateToEpochDay(startYear, 1, 1);
      final end = dateToEpochDay(endYear, 12, 31);
      log
        ..debug('  StartYear: $startYear, EndYear: $endYear, Total Years: '
            '${endYear - startYear}')
        ..debug('  Tested ${-begin + end} dates');
      watch.stop();
      log.debug('  Elapsed: ${watch.elapsed}');
    });
    test('weekDayFromEpochDay', () {
      log.debug('weekDayFromEpochDay');
      final watch = Stopwatch();
      const zeroWeekDay = kThursday;
      watch.start();
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

    test('dateToEpochMicroseconds', () {
      for (var y = global.minYear; y <= global.maxYear; y++) {
        for (var m = 1; m <= 12; m++) {
          final dtem0 = dateToEpochMicroseconds(y, m, 01);
          log.debug('dtem0: $dtem0');
          expect(dtem0, isNotNull);
        }
      }

      // bad year
      var dtemInvalid = dateToEpochMicroseconds(global.minYear - 1, 1, 12);
      expect(dtemInvalid, isNull);

      // bad year
      dtemInvalid = dateToEpochMicroseconds(global.maxYear + 1, 12, 12);
      expect(dtemInvalid, isNull);

      // bad month
      dtemInvalid = dateToEpochMicroseconds(1978, 13, 12);
      expect(dtemInvalid, isNull);

      // bad day
      dtemInvalid = dateToEpochMicroseconds(1985, 10, 32);
      expect(dtemInvalid, isNull);

      global.throwOnError = true;
      // bad year
      expect(() => dateToEpochMicroseconds(global.minYear - 1, 13, 12),
          throwsA(equals(const TypeMatcher<DateTimeError>())));

      // bad year
      expect(() => dateToEpochMicroseconds(global.maxYear + 1, 13, 12),
          throwsA(equals(const TypeMatcher<DateTimeError>())));

      // bad month
      expect(() => dateToEpochMicroseconds(1970, 13, 12),
          throwsA(equals(const TypeMatcher<DateTimeError>())));

      // bad day
      expect(() => dateToEpochMicroseconds(1970, 08, 34),
          throwsA(equals(const TypeMatcher<DateTimeError>())));
    });

    test('checkEpochDay', () {
      final ced0 = checkEpochDay(kMinEpochDay);
      log.debug('ced0:$ced0');
      expect(ced0, isNotNull);

      final ced1 = checkEpochDay(kMaxEpochDay);
      log.debug('ced1:$ced1');
      expect(ced1, isNotNull);

      global.throwOnError = false;
      final ced2 = checkEpochDay(kMaxEpochDay + 1);
      expect(ced2, isNull);

      final ced3 = checkEpochDay(kMinEpochDay - 1);
      expect(ced3, isNull);

      global.throwOnError = true;
      expect(() => checkEpochDay(kMaxEpochDay + 1),
          throwsA(equals(const TypeMatcher<DateTimeError>())));

      expect(() => checkEpochDay(kMinEpochDay - 1),
          throwsA(equals(const TypeMatcher<DateTimeError>())));
    });

    test('epochMicrosecondsToDate', () {
      final EpochDate emd0 = epochMicrosecondToDate(kMinEpochMicrosecond);
      log.debug('emd0: "$emd0"');
      expect(emd0, isNotNull);

      final EpochDate emd1 = epochMicrosecondToDate(kMaxEpochMicrosecond);
      log.debug('emd1: "$emd1"');
      expect(emd1, isNotNull);

      final badMin = kMinEpochMicrosecond - 1;
      final EpochDate emd2 = epochMicrosecondToDate(badMin);
      log.debug('emd2: "$emd2"');
      expect(emd2, isNull);

      final badMax = kMaxEpochMicrosecond + 1;
      final EpochDate emd3 = epochMicrosecondToDate(badMax);
      log.debug('emd3: "$emd3"');
      expect(emd3, isNull);
    });

    test('hashEpochDay', () {
      final hed0 = hashDateMicroseconds(kAbsoluteMaxEpochDay + 1);
      log.debug('hed0: $hed0');
    });

    test('epochDayAsString', () {
      global.throwOnError = false;

      final eds0 = epochDayToDateString(45858);
      log.debug('eds0:$eds0');
      expect(eds0, isNotNull);

      final eds1 = epochDayToDateString(201458, asDicom: false);
      log.debug('eds1:$eds1');
      expect(eds1, isNotNull);

      final eds2 = epochDayToDateString(startEpochDay);
      log.debug('eds2:$eds2');
      expect(eds2, isNotNull);

      final eds3 = epochDayToDateString(endEpochDay);
      log.debug('eds3:$eds3');
      expect(eds3, isNotNull);

      final eds4 = epochDayToDateString(kMinEpochDay);
      log.debug('eds4:$eds4');
      expect(eds4, isNotNull);

      final eds5 = epochDayToDateString(kMaxEpochDay);
      log.debug('eds5:$eds5');
      expect(eds5, isNotNull);

      final eds6 = epochDayToDateString(45858334);
      log.debug('eds6:$eds6');
      expect(eds6, isNull);

      final eds7 = epochDayToDateString(kMinEpochDay - 1);
      log.debug('eds7:$eds7');
      expect(eds7, isNull);

      final eds8 = epochDayToDateString(kMaxEpochDay + 1);
      log.debug('eds8:$eds8');
      expect(eds8, isNull);
    });

    test('dateAsString', () {
      final dt0 = const EpochDate(1998, 11, 15).asString(asDicom: true);
      log.debug('dt0: $dt0');
      expect(dt0, '19981115');

      final dt1 = dateToString(2000, 05, 24);
      log.debug('dt1: $dt1');
      expect(dt1, '20000524');

      final dt2 = dateToString(1998, 11, 15, asDicom: false);
      log.debug('dt2: $dt2');
      expect(dt2, '1998-11-15');

      final dt3 = dateToString(198, 11, 15, asDicom: false);
      log.debug('dt3: $dt3');
      expect(dt3, '0198-11-15');

      final dt4 = dateToString(18, 11, 15, asDicom: false);
      log.debug('dt4: $dt4');
      expect(dt4, '0018-11-15');

      final dt5 = dateToString(1, 11, 15, asDicom: false);
      log.debug('dt5: $dt5');
      expect(dt5, '0001-11-15');

      final dt6 = dateToString(0, 11, 15, asDicom: false);
      log.debug('dt6: $dt6');
      expect(dt6, '0000-11-15');
    });
  });
}

const List<int> goodBasicLeapYears = [
  1904, -1908, -1912, -1916, -1920, // No reformat
  1904, 1908, 1912, 1916, 1920,
  1924, 1928, 1932, 1936, 1980,
  1984, 1988, 1992, 1996,
];

const List<int> goodSpecialLeapYears = [
  -400, -800, -1200, -1600, -2400, 2800, // No reformat
  400, 800, 1200, 1600, 2400, 2800
];

const List<int> goodBasicCommonYears = [
  -1905, -1909, -1913, -1917, -1921, // No reformat
  1905, 1909, 1913, 1917, 1921, // No reformat
  1925, 1929, 1933, 1937, 1981,
  1985, 1989, 1993, 1997, 2001
];

const List<int> goodSpecialCommonYears = [
  -100, -200, -300, -700, -900, // No reformat
  100, 200, 300, 700, 900,
  1000, 1100, 1300, 1800, 1900,
  2100, 2200, 2300, 2700, 2900
];

const List<List<int>> validDateLists = <List<int>>[
  <int>[1970, 1, 1], // No reformat
  <int>[1970, 12, 31],
  <int>[1969, 1, 1],
  <int>[1969, 12, 31],
  <int>[1971, 1, 1],
  <int>[1971, 12, 31],

  <int>[1968, 2, 29],
  <int>[1964, 2, 29],

  <int>[0, 1, 1],
  <int>[0, 2, 29],
  <int>[1, 2, 28],
  <int>[-1, 2, 28]
];

const List<List<int>> invalidDateLists = <List<int>>[
  <int>[1970, 0, 1], // No reformat
  <int>[1970, -1, 1],
  <int>[1970, -2, 1],
  <int>[1970, 13, 1],
  <int>[1970, 14, 1],

  <int>[1970, 1, 0],
  <int>[1970, 12, -1],
  <int>[1970, 12, -2],
  <int>[1970, 1, -3],
  <int>[1970, 12, 32],
  <int>[1970, 12, 33],
  <int>[1970, 12, 34],

  <int>[1970, 11, 31],
  <int>[1971, 10, 32],
  <int>[1971, 9, 31],

  <int>[0, 2, 30],
  <int>[1, 2, 29],
  <int>[-1, 2, 29]
];
