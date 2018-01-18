// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';

const List<List<int>> kWeekdayDiffTable = const <List<int>>[
  // -    Sun Mon Tue Wed Thu Fri Sat
  /*Sun*/ const [0, 6, 5, 4, 3, 2, 1],
  /*Mon*/ const [1, 0, 6, 5, 4, 3, 2],
  /*Tue*/ const [2, 1, 0, 6, 5, 4, 3],
  /*Wed*/ const [3, 2, 1, 0, 6, 5, 4],
  /*Thu*/ const [4, 3, 2, 1, 0, 6, 5],
  /*Fri*/ const [5, 4, 3, 2, 1, 0, 6],
  /*Sat*/ const [6, 5, 4, 3, 2, 1, 0]
];

void main() {
  Server.initialize(
      name: 'epoch_day_test', minYear: kMinYearLimit, maxYear: kMaxYearLimit, level: Level.info);

  // These next two values are used throughout the test
  // They can be changed to make the tests longer or shorter
  const startYear = -10000 + 1970;
  const endYear = 10000 - 1970;

  group('Weekday Test', () {
    test('Epoch Date Performance Test', () {
      log
        ..info0('Epoch Date Performance Test...')
        ..debug1('  startYear: $startYear, endYear: $endYear');

      final eStart = dateToEpochDay(startYear, 1, 1);
      log.debug1('  Epoch Start Day: $eStart');
      final eEnd = dateToEpochDay(endYear, 1, 1);
      log.debug1('  Epoch End Day: $eEnd');

      var previousEpochDay = eStart - 1;
      var nextEpochDay = eStart + 1;
      log
        ..debug('  Previous Epoch Day: $previousEpochDay')
        ..debug('  Next Epoch Day: $nextEpochDay');
      var previousDay = weekdayFromEpochDay(previousEpochDay);
      var nextDay = weekdayFromEpochDay(nextEpochDay);
      log..debug('  Previous Week Day: $previousDay')..debug('  Next Week Day: $nextDay');
      expect(0 <= previousDay && previousDay <= 6, true);
      expect(0 <= nextDay && nextDay <= 6, true);

      log.debug('\n******* Starting Loop: ');

      for (var y = startYear; y <= endYear; y++) {
        log.debug0('    Year: $startYear');
        for (var m = 1; m <= 12; m++) {
          final lastDay = lastDayOfMonth(y, m);
          log.debug2('Year: $y, Month: $m, lastDay: $lastDay, Leap: ${isLeapYear(y)}');
          for (var d = 1; d <= lastDay; d++) {
            log.debug3('$y-$m-$d');
            // Epoch Day
            final z = dateToEpochDay(y, m, d);
            log.debug3('''
  Previous Epoch Day: $previousEpochDay');
           Epoch Day: $z');
      Next Epoch Day: $nextEpochDay''');
            expect(previousEpochDay == z - 1, true);
            expect(nextEpochDay == z + 1, true);

            final List<int> date = epochDayToDate(z);
            expect(y == date[0], true);
            expect(m == date[1], true);
            expect(d == date[2], true);

            // Weekday
            final weekday = weekdayFromEpochDay(z);
            previousDay = weekdayFromEpochDay(previousEpochDay);
            nextDay = weekdayFromEpochDay(nextEpochDay);
            log.debug3('''
    Previous weekday: $previousDay
             weekday: $weekday
        Next weekday: $nextDay''');
            var diff = weekdayDifference(weekday, previousDay);
            log.debug3('       Previous Diff: $diff');
            expect(diff == 1, true);
            diff = weekdayDifference(nextDay, weekday);
            log.debug3('            Next Diff: $diff');
            expect(diff == 1, true);

            expect(weekday == nextWeekday(previousDay), true);
            expect(previousDay == previousWeekday(weekday), true);
            expect(nextDay == nextWeekday(weekday), true);
            previousEpochDay++;
            nextEpochDay++;
          }
        }
      }
      final begin = dateToEpochDay(startYear, 1, 1);
      final end = dateToEpochDay(endYear, 12, 31);
      log.debug1('  StartYear: $startYear, EndYear: $endYear, Total Years: '
          '${endYear - startYear}\n  Tested ${-begin + end} dates');
    });

    test('weekday Difference', () {
      for (var x = 0; x < 7; x++) {
        for (var y = 0; y < 7; ++y) {
          final row = kWeekdayDiffTable[x];
          final ex = row[y];
          log.debug('x: $x, y: $y, expect: $ex');
          final v = weekdayDifference(x, y);
          log.debug('  v: $v');
          expect(v == ex, true);
        }
      }
    });

    test('previousWeekday', () {
      for (var day = 0; day < 7; day++) {
        final pwd = previousWeekday(day);
        log.debug('pwd: $pwd');
        if (day < 0 || day > 6) {
          expect(pwd, null);
        } else {
          log.debug('day: $day');
          expect(pwd, day - 1 == -1 ? 6 : day - 1);
        }
      }
    });

    test('nextWeekday', () {
      for (var day = 0; day < 7; day++) {
        final pwd = nextWeekday(day);
        log.debug('pwd: $pwd');
        if (day < 0 || day > 6) {
          expect(pwd, null);
        } else {
          log.debug('day: $day');
          expect(pwd, day + 1 == 7 ? 0 : day + 1);
        }
      }
    });
  });
}
