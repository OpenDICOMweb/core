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

import 'date_time_test_data/date_data.dart';
import 'date_time_test_data/date_time_data.dart';
import 'date_time_test_data/time_data.dart';

void main() {
  Server.initialize(
      name: 'dcm_date_time', minYear: -1000, maxYear: 3000, level: Level.info);

  group('DcmDateTime', () {
    test('Good DcmDateTime', () {
      log.debug('Good DcmDateTime');
      for (var dt in goodDcmDateTimeList) {
        log.debug('date and time:$dt');
        final dateTime = DcmDateTime.parse(dt);
        log.debug('dateTime:$dateTime');
        expect(dateTime, isNotNull);
      }
    });

    test('Bad DcmDateTime', () {
      log.debug('Bad DcmDateTime');
      for (var dt in badDcmDateTimeList) {
        log.debug('dt: $dt');
        final dateTime = DcmDateTime.parse(dt);
        log.debug1(' dt:$dt: $dateTime');
        expect(dateTime == null, true);
      }
    });
  });

  group('isValid', () {
    test('isValid Good DcmDateTime', () {
      global.level = Level.info;

      for (var s in goodDcmDateTimeList) {
        log.debug('s: $s');
        expect(DcmDateTime.isValidString(s), true);
        final dateTime = DcmDateTime.parse(s);
        log
          ..debug('us: ${dateTime.microseconds}')
          ..debug('day: ${dateTime.day}')
          ..debug('dateTime: $dateTime');
        expect(dateTime is DcmDateTime, true);
      }
    });

    test('isValid Bad DcmDateTime', () {
      global.level = Level.info;
      global.throwOnError = false;

      for (var dt in badDcmDateTimeList) {
        log.debug('dt: $dt');
        final dateTime = DcmDateTime.parse(dt);
        expect(dateTime, isNull);
        expect(DcmDateTime.isValidString(dt), false);
      }
    });

    test('issues', () {
      for (var s in goodDcmDateTimeList) {
        final issues = DcmDateTime.issues(s);
        expect(issues.isEmpty, true);
      }
    });

    test('parse', () {
      for (var dt in goodDcmDateTimeList) {
        final dateTime = DcmDateTime.parse(dt);
        log.debug('dateTime: $dateTime');
        expect(dateTime, isNotNull);
        final hash = dateTime.hash;
        log.debug('dateTime.hash: $hash');
        expect(hash, isNotNull);
      }

      for (var dt in badDcmDateTimeList) {
        final dateTime = DcmDateTime.parse(dt);
        expect(dateTime, isNull);
      }
    });

    test('hash', () {
      for (var s in goodDcmDateTimeList) {
        log.debug('s: $s');
        final dt = DcmDateTime.parse(s);
        final h = dt.hash;
        log.debug('dt: $dt, hash $h');
        expect(h, isNotNull);
      }

      global.throwOnError = true;
      for (var s in goodDcmDateTimeList) {
        final dt0 = DcmDateTime.parse(s);
        if (dt0 != null) {
          log
            ..debug('dt0:$dt0')
            ..debug('dt0.values:${dt0.toString()}, dt0.hash:${dt0.hash}');
          final dt1 = DcmDateTime.parse(s);
          log
            ..debug('dt1:$dt1')
            ..debug('date1.values:${dt1.toString()}, dt1.hash:${dt1.hash}');
          expect(dt0.hash, equals(dt1.hash));
        } else {
          return invalidDateString('Invalid Date String: "$s"');
        }
      }

      final dt2 = DcmDateTime.parse(goodDcmDateTimeList[0]);
      final dt3 = DcmDateTime.parse(goodDcmDateTimeList[1]);
      log
        ..debug('dt2.values:${dt2.toString()}, dt2.hash:${dt2.hash}')
        ..debug('dt3.values:${dt3.toString()}, dt3.hash:${dt3.hash}');
      expect(dt2.hash, isNot(dt3.hash));
      return true;
    });

    test('sha256 date_time', () {
      final dt1 = DcmDateTime(1970, 05, 01);

      log.debug('dt1: $dt1');
      final sha0 = dt1.sha256;
      log.debug('sha0: $sha0');
      expect(sha0, isNotNull);

      for (var s in goodDcmDateTimeList) {
        final dt0 = DcmDateTime.parse(s);
        final dt1 = DcmDateTime.parse(s);
        log
          ..debug('dt0.values:${dt0.toString()}')
          ..debug('dt1.values:${dt1.toString()}')
          ..debug('dt0.sha256: ${dt0.sha256}')
          ..debug('dt0.values:${dt0.toString()}, dt0.sha256:${dt0.sha256}')
          ..debug('dt1.values:${dt1.toString()}, dt1.sha256:${dt1.sha256}');
        expect(dt0.sha256, equals(dt0.sha256));
      }
      final dt2 = DcmDateTime.parse(goodDcmDateTimeList[0]);
      final dt3 = DcmDateTime.parse(goodDcmDateTimeList[1]);
      log
        ..debug('dt2.values:${dt2.toString()}, dt2.sha256:${dt2.sha256}')
        ..debug('dt3.values:${dt3.toString()}, dt3.sha256:${dt3.sha256}');

      expect(dt2.sha256, isNot(dt3.sha256));
    });

    test('hashString', () {
      global.throwOnError = false;
      for (var dt in goodDcmDateTimeList) {
        final dateTime0 = DcmDateTime.hashString(dt);
        log.debug('dateTime0: $dateTime0');
        expect(dateTime0, isNotNull);
      }

      for (var dt in badDcmDateTimeList) {
        final dateTime1 = DcmDateTime.hashString(dt);
        expect(dateTime1, isNull);
      }
    });

    test('hashStringList', () {
      global.throwOnError = false;
      final dateTime0 = DcmDateTime.hashStringList(goodDcmDateTimeList);
      log.debug('dateTime0: $dateTime0');
      for (var s in dateTime0) {
        expect(s, isNotNull);
      }

      final dateTime1 = DcmDateTime.hashStringList(badDcmDateTimeList);
      log.debug('dateTime1: $dateTime1');
      for (var s in dateTime1) {
        expect(s, isNull);
      }
    });

    test('==', () {
      for (var s in goodDcmDateTimeList) {
        final dt0 = DcmDateTime.parse(s);
        final dt1 = DcmDateTime.parse(s);
        log
          ..debug('dt0.values:${dt0.toString()}')
          ..debug('dt1.values:${dt1.toString()}');
        expect(dt0 == dt1, true);
      }

      final dt2 = DcmDateTime.parse(goodDcmDateTimeList[0]);
      final dt3 = DcmDateTime.parse(goodDcmDateTimeList[1]);
      log
        ..debug('dt2 =.values:${dt2.toString()}')
        ..debug('dt3.values:${dt3.toString()}');
      expect(dt2 == dt3, false);
    });

    test('>', () {
      for (var y = 1900; y < 2000; y++) {
        for (var m = 1; m < 12; m++) {
          for (var d = 1; d < lastDayOfMonth(y, m); d++) {
            final dt0 = Date(y, m, d);
            final dt1 = Date(y, m, d + 1);
            log.debug('dt0: $dt0, dt1: $dt1');
            expect(dt1 > dt0, true);
          }
        }
      }
    });

    test('<', () {
      for (var y = 1900; y < 2000; y++) {
        for (var m = 1; m < 12; m++) {
          for (var d = 1; d < lastDayOfMonth(y, m); d++) {
            final dt0 = DcmDateTime(y, m, d);
            final dt1 = DcmDateTime(y, m, d + 1);
            log.debug('dt0: $dt0, dt1: $dt1');
            expect(dt0 < dt1, true);
          }
        }
      }
    });

    test('compareTo', () {
      for (var y = 1900; y < 2000; y++) {
        for (var m = 1; m < 12; m++) {
          for (var d = 1; d < lastDayOfMonth(y, m); d++) {
            if (d + 1 < lastDayOfMonth(y, m)) {
              final dt0 = DcmDateTime(y, m, d);
              final dt1 = DcmDateTime(y, m, d + 1);
              expect(dt0.compareTo(dt1), -1);

              expect(dt1.compareTo(dt0), 1);
              expect(dt0.compareTo(dt0), 0);

              final dt2 = DcmDateTime(y, m, d);
              expect(dt0.compareTo(dt2), 0);
            }
          }
        }
      }
    });

    test('DcmDateTime add', () {
      final d0 = dateToEpochMicroseconds(1970, 1, 1);
      log.debug('d0 : $d0');
      expect(d0 == 0, true);

      final dt0 = DcmDateTime.utc(1970, 1, 1);
      log..debug('dt0 :$dt0')..debug(dt0.microseconds);
      expect(dt0.microseconds == 0, true);
      const years = 100;
      for (var i = 1; i < years; i++) {
        final add0 = dt0.add(years: i);
        log.debug('add0.year: $add0');
        expect(add0.year == dt0.year + i, true);
      }

      final dt1 = DcmDateTime.fromMicroseconds(0);
      log..debug('dt1: $dt1')..debug(dt1.microseconds);
      expect(dt0.microseconds == 0, true);

      log.debug('''
  dt0.inet:${dt0.inet}
  microseconds: ${dt0.microseconds}
  year: ${dt0.year}
  month: ${dt0.month}
  day: ${dt0.day}
  hour: ${dt0.hour}
  minute: ${dt0.minute}''');
    });

    test('DcmDateTime add month', () {
      final dt0 = DcmDateTime.utc(1970, 1, 1);
      log..debug('dt0 :$dt0')..debug(dt0.microseconds);
      expect(dt0.microseconds == 0, true);

      const months = 11;
      for (var i = 1; i < months; i++) {
        final add0 = dt0.add(months: i);
        log.debug('add0.month: $add0');
        expect(add0.month == dt0.month + i, true);
      }

      const months0 = 11;
      final add0 = dt0.add(months: months0);
      log.debug(add0.month);
    });

    test('DcmDateTime add day', () {
      final dt0 = DcmDateTime.utc(1970, 1, 1);
      log..debug('dt0 :$dt0')..debug(dt0.microseconds);
      expect(dt0.microseconds == 0, true);

      const days = 29;
      for (var i = 1; i < days; i++) {
        final add0 = dt0.add(days: i);
        log.debug('add0.day: $add0');
        expect(add0.day == dt0.day + i, true);
      }
    });

    test('DcmDateTime add hour', () {
      global.level = Level.info;
      final dt0 = DcmDateTime.utc(1970, 1, 1);
      log..debug('dt0 :$dt0')..debug(dt0.microseconds);
      expect(dt0.microseconds == 0, true);

      log.debug('dt0.hour: ${dt0.hour}');
      const hours = 23;
      for (var i = 1; i < hours; i++) {
        final add0 = dt0.add(hours: i);
        //log.debug('add0.hours: $add0');
        log
          ..debug('add0.hour: ${add0.hour}')
          ..debug('add0.hour: ${(dt0.hour + i) % 24}');
        expect(add0.hour == ((dt0.hour + i) % 24), true);
      }
    });

    test('DcmDateTime add minute', () {
      final dt0 = DcmDateTime.utc(1970, 1, 1);
      log..debug('dt0 :$dt0')..debug(dt0.microseconds);
      expect(dt0.microseconds == 0, true);

      const minutes = 59;
      for (var i = 1; i < minutes; i++) {
        final add0 = dt0.add(minutes: i);
        log.debug('add0.minutes: ${add0.minute}');
        expect(add0.minute == dt0.minute + i, true);
      }
    });

    test('DcmDateTime add second', () {
      final dt0 = DcmDateTime.utc(1970, 1, 1);
      log..debug('dt0 :$dt0')..debug(dt0.microseconds);
      expect(dt0.microseconds == 0, true);

      const seconds = 59;
      for (var i = 1; i < seconds; i++) {
        final add0 = dt0.add(seconds: i);
        log.debug('add0.seconds: ${add0.second}');
        expect(add0.second == dt0.second + i, true);
      }
    });

    test('DcmDateTime subtract year', () {
      final dt0 = DcmDateTime.utc(1970, 1, 1);
      log..debug('dt0 :$dt0')..debug(dt0.microseconds);
      expect(dt0.microseconds == 0, true);

      log.debug('dt0.hour: ${dt0.year}');
      const years = 20;
      for (var i = 1; i < years; i++) {
        final sub0 = dt0.subtract(years: i);
        log.debug('sub0.hours: ${sub0.year}');
        expect(sub0.year == dt0.year - i, true);
      }
    });

    test('DcmDateTime substract month', () {
      final dt0 = DcmDateTime.utc(1970, 1, 1);
      log..debug('dt0 :$dt0')..debug(dt0.microseconds);
      expect(dt0.microseconds == 0, true);

      const months = -1;
      final sub0 = dt0.subtract(months: months);
      log.debug('sub0.month: ${sub0.month}');
      expect(sub0.month == dt0.month - months, true);
    });

    test('DcmDateTime substract day', () {
      final dt0 = DcmDateTime.utc(1970, 1, 1);
      log..debug('dt0 :$dt0')..debug(dt0.microseconds);
      expect(dt0.microseconds == 0, true);

      const days = -1;
      final sub0 = dt0.subtract(days: days);
      log.debug('sub0.day: $sub0');
      expect(sub0.day == dt0.day - days, true);
    });

    test('DcmDateTime fromDateTime', () {
      for (var s0 in goodDcmDateList) {
        final date = Date.parse(s0);
        for (var s1 in goodDcmTimes) {
          final time = Time.parse(s1);
          for (var s2 in kValidDcmTZStrings) {
            final tz = TimeZone.parse(s2);

            final dt0 = DcmDateTime.fromDateTime(date, time, tz);
            log.debug('dt0: $dt0');
            expect(
                dt0.microseconds ==
                    (date.microseconds + time.microsecond + tz.microseconds),
                true);
          }
        }
      }
    });
  });
}
