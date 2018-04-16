//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/server.dart';

// Urgent: make this a unit test
void main() {
  // Year range is -1 million BCE to 1 million CE. Since Epoch 0 is 1970 we shift by that.
  Server.initialize(
      name: 'test_epoch_day',
      // These next two values allow this program to run all valid
      // Epoch Days if desired, but it takes a long time.
      minYear: kMinYearLimit,
      maxYear: kMaxYearLimit,
      level: Level.info0);

  // These values are used by test programs. They can be anything
  // between [minYear] and [maxYear].
  const startYear = -10000 + 1970;
  const endYear = 10000 - 1970;
  final epochStartDay = dateToEpochDay(startYear, 1, 1);
  final epochEndDay = dateToEpochDay(endYear, 1, 1);

  final zeroDay = dateToEpochDay(1970, 1, 1);
  log.debug('zeroDay: $zeroDay');
  const zeroDate = const <int>[1970, 1, 1];
  log.debug('zeroDayAsList: $zeroDate');

  assert(zeroDay == 0, '1970-01-01 is day 0');
  assert(dateListsEqual(epochDayToDate(0), zeroDate), '1970-01-01 is day 0');
  assert(weekdayFromEpochDay(dateToEpochDay(1970, 1, 1)) == 4,
      '1970-01-01 is a Thursday');

  assert(dateToEpochDay(1970, 1, 1) == 0);
  assert(dateToEpochDay(1969, 12, 31) == -1);
  assert(dateToEpochDay(1970, 1, 2) == 1);

  final wd = weekdayFromEpochDay(0);
  assert(wd == 4);

  leapYearTest(startYear, endYear);
  dateBasicTest(startYear, endYear);

  weekDayFromEpochDay(epochStartDay, epochEndDay);

  dateUnitTest(startYear, endYear);
}

void leapYearTest(int startYear, int endYear) {
  log.info0('leapYearTest');
  final watch = new Stopwatch()..start();
  for (var i = startYear; i < endYear; i++) {
    final List<int> date = epochDayToDate(i);
    final y = date[0];
    log.debug(
        'year: $y, isCommonYear: ${isCommonYear(y)}, isLeapYear: ${isLeapYear(y)}'
        'i % 4: ${i % 4}, isLeapYear: ${isLeapYear(i)}');
    final m = date[1];
    final d = date[2];
    final n = dateToEpochDay(y, m, d);
    log.debug('$i, $n, ${i == n}, isLeapYear: ${isLeapYear(y)}');
    if (isLeapYear(y) && m == 2 && d == 29) {
      final last = lastDayOfMonth(y, m);
      assert(last == 29);
      //    log.debug('$y-$m-$d');
    }
    assert(i == n);
  }
  watch.stop();
  log.info0('    Elapsed: ${watch.elapsed}');
}

void dateBasicTest(int startYear, int endYear) {
  log.info0('conversionTest...');
  final watch = new Stopwatch()..start();
  for (var i = startYear; i < endYear; i++) {
    final List<int> date = epochDayToDate(i);
    log.debug('date: $date');
    final y = date[0];
    final m = date[1];
    final d = date[2];
    final n = dateToEpochDay(y, m, d);
    log.debug('$i, $n, ${i == n}, isLeapYear: ${isLeapYear(y)}');
    if (isLeapYear(y) && m == 2 && d == 29) {
      final last = lastDayOfMonth(y, m);
      assert(last == 29);
      log.debug('$y-$m-$d');
    }
    assert(i == n);
  }
  watch.stop();
  log.info0('  Elapsed: ${watch.elapsed}');
}

void dateUnitTest(int startYear, int endYear) {
  log.info0('Date Unit Test...'
      '  startYear: $startYear, endYear: $endYear');

  final eStart = dateToEpochDay(startYear, 1, 1);
  log.info0('  Epoch Start Day: $startYear');

  final zeroDay = dateToEpochDay(1970, 1, 1);
  final wd = weekdayFromEpochDay(zeroDay);
  assert(wd == 4);

  final watch = new Stopwatch()..start();
  var previousEpochDay = eStart - 1;
  assert(previousEpochDay < 0);
//  log.debug('  Previous Epoch Day: $previousEpochDay');
  var previousWeekDay = weekdayFromEpochDay(previousEpochDay);
//  log.debug('  Previous Week Day: $previousWeekDay');
  assert(0 <= previousWeekDay && previousWeekDay <= 6);

  // log.debug('\n******* Starting Loop');
  watch.start();
  for (var y = startYear; y <= endYear; y++) {
    if (y % 10000 == 0) log.info0('    Year: $y: ${watch.elapsed}');
    for (var m = 1; m <= 12; m++) {
      final e = lastDayOfMonth(y, m);
      log.debug('Month: $m, lastDay: $e');
      for (var d = 1; d <= e; d++) {
        final z = dateToEpochDay(y, m, d);
        log.debug('Day: $d z: $z');
        assert(previousEpochDay < z);
        assert(z == previousEpochDay + 1);

        final List<int> date = epochDayToDate(z);
        assert(y == date[0]);
        assert(m == date[1]);
        assert(d == date[2]);
        final wd = weekdayFromEpochDay(z);
        assert(0 <= wd && wd <= 6);
        final nwd = nextWeekday(previousWeekDay);

        assert(wd == nwd, '$wd, $previousWeekDay: $nwd');
        assert(previousWeekDay == previousWeekday(wd));
        previousEpochDay = z;
        log.debug('  previousEDay: $z');
        previousWeekDay = wd;
        log.debug('  previousWeekDay: $wd');
      }
    }
  }
  watch.stop();
  log.info0('  Elaped Time: ${watch.elapsed}');
  final begin = dateToEpochDay(startYear, 1, 1);
  final end = dateToEpochDay(endYear, 12, 31);
  log.info0('  StartYear: $startYear, EndYear: $endYear, Total Years: '
      '${kMaxYear - kMinYear}'
      '  Tested ${-begin + end} dates');
}

void weekDayFromEpochDay(int epochStartDay, int epochEndDay) {
  final watch = new Stopwatch();
  log.info0('weekdayFromEpochDay0\n'
      ' weekDayFromDay: days >= 0');
  const zeroWeekDay = 4;

  watch.start();
  for (var i = epochStartDay; i < epochEndDay; i++) {
    final day = (zeroWeekDay + i) % 7;
    final wd = weekdayFromEpochDay(i);

    //  log.debug('    $i: day: $day, wd: $wd');
    assert(day == wd);
  }
  log.info0('    Elapesd: ${watch.elapsed}\n  weekDayFromDay: days <= 0');
  for (var i = 0; i > -100000; i--) {
    final wd = weekdayFromEpochDay(i);
    final day = (zeroWeekDay + i) % 7;
    //  log.debug('    $i: day: $day, wd: $wd');
    assert(day == wd);
  }
  watch.stop();
  log.info0('    Elapesd: ${watch.elapsed}');
}
