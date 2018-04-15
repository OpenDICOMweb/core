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
  Server.initialize(
      name: 'dcm_date_time', minYear: -1000, maxYear: 3000, level: Level.info);

  const goodDcmDateTimeList = const <String>[
    '19500718105630',
    '00000101010101',
    '19700101000000',
    '20161229000000',
    '19991025235959',
    '20170223122334.111111',
    '20170223122334.111111+1100',
    '20170223122334.111111-1000',
    '20170223122334.111111+0930',
    '20120228105630', // leap year
    '20080229105630', // leap year
    '20160229105630', // leap year
    '20200125105630', // leap year
    '20240229105630', // leap year
  ];

  const badDcmDateTimeList = const <String>[
    '19501318',
    '19501318105630', //bad months
    '19501032105630', // bad day
    '00000000000000', // bad month and day
    '19501032105660', // bad day and second
    '00000032240212', // bad month and day and hour
    '20161229006100', // bad minute
    '-9700101226a22', // bad character in year minute
    '1b7001012a1045', // bad character in year and hour
    '19c001012210a2', // bad character in year and sec
    '197d0101105630', // bad character in year
    '1970a101105630', // bad character in month
    '19700b01105630', // bad character in month
    '197001a1105630', // bad character in day
    '1970011a105630', // bad character in day
    '20120230105630', // bad day in leap year
    '20160231105630', // bad day in leap year
    '20130229105630', // bad day in year
    '20230229105630', // bad day in year
    '20210229105630', // bad day in year
    '20170223122334.111111+0', // bad timezone
    '20170223122334.111111+01', // bad timezone
    '20170223122334.111111+013', // bad timezone
    '20170223122334.111111+1545', // bad timezone
    '20170223122334.111111-1015', // bad timezone
    '20170223122334.111111+0960', // bad timezone
    '20170223122334.111111*0945', // bad timezone: special character
  ];
  group('DcmDateTime', () {
    test('Good DcmDateTime', () {
      //DcmDateTime d=new DcmDateTime(1505,12,4);
      log.debug('Good DcmDateTime');
      for (var dt in goodDcmDateTimeList) {
        log.debug('date and time:$dt');
        final datetime = DcmDateTime.parse(dt);
        expect(datetime, isNotNull);
      }
    });
    test('Bad DcmDateTime', () {
      //DcmDateTime datetim=DcmDateTime.parse(dt);

      log.debug('Bad DcmDateTime');
      //final dts = DcmDateTime.parse('20170223122334.111111');
      for (var dt in badDcmDateTimeList) {
        log.debug('dt: $dt');
        final dateTime = DcmDateTime.parse(dt);
        log.debug1(' dt:$dt: $dateTime');
        expect(dateTime == null, true);
      }
    });
  });

  group('isValid', () {
    test('isValid Good and Bad DcmDateTime', () {
      for (var dt in goodDcmDateTimeList) {
        final dateTime = DcmDateTime.parse(dt);
        log.debug('dateTime: $dateTime');
        expect(dateTime is DcmDateTime, true);
        expect(DcmDateTime.isValidString(dt), true);
      }

      for (var dt in badDcmDateTimeList) {
        log.debug('dt: $dt');
        final dateTime = DcmDateTime.parse(dt);
        expect(dateTime, isNull);
        expect(DcmDateTime.isValidString(dt), false);
      }
    });

    test('issues', () {
      //     var dt = new DcmDateTime(2016, 05, 15, 04, 22, 14);
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
//      system.level = Level.info;
      for (var s in goodDcmDateTimeList) {
        log.debug('s: $s');
        final dt = DcmDateTime.parse(s);
        final h = dt.hash;
        log.debug('dt: $dt, hash $h');
        expect(h, isNotNull);
      }

      system.throwOnError = true;
      for (var s in goodDcmDateTimeList) {
        final dt0 = DcmDateTime.parse(s);
        if (dt0 != null) {
          log
            ..debug('dt0:$dt0')
            ..debug('dt0.value:${dt0.toString()}, dt0.hash:${dt0.hash}');
          final dt1 = DcmDateTime.parse(s);
          log
            ..debug('dt1:$dt1')
            ..debug('date1.value:${dt1.toString()}, dt1.hash:${dt1.hash}');
          expect(dt0.hash, equals(dt1.hash));
        } else {
          return invalidDateString('Invalid Date String: "$s"');
        }
      }

      final dt2 = DcmDateTime.parse(goodDcmDateTimeList[0]);
      final dt3 = DcmDateTime.parse(goodDcmDateTimeList[1]);
      log
        ..debug('dt2.value:${dt2.toString()}, dt2.hash:${dt2.hash}')
        ..debug('dt3.value:${dt3.toString()}, dt3.hash:${dt3.hash}');
      expect(dt2.hash, isNot(dt3.hash));
    });

    test('sha256 date_time', () {
      final dt1 = new DcmDateTime(1970, 05, 01);

      log.debug('dt1: $dt1');
      final sha0 = dt1.sha256;
      log.debug('sha0: $sha0');
      expect(sha0, isNotNull);

      for (var s in goodDcmDateTimeList) {
        final dt0 = DcmDateTime.parse(s);
        final dt1 = DcmDateTime.parse(s);
        log
          ..debug('dt0.value:${dt0.toString()}')
          ..debug('dt1.value:${dt1.toString()}')
          ..debug('dt0.sha256: ${dt0.sha256}')
          ..debug('dt0.value:${dt0.toString()}, dt0.sha256:${dt0.sha256}')
          ..debug('dt1.value:${dt1.toString()}, dt1.sha256:${dt1.sha256}');
        expect(dt0.sha256, equals(dt0.sha256));
      }
      final dt2 = DcmDateTime.parse(goodDcmDateTimeList[0]);
      final dt3 = DcmDateTime.parse(goodDcmDateTimeList[1]);
      log
        ..debug('dt2.value:${dt2.toString()}, dt2.sha256:${dt2.sha256}')
        ..debug('dt3.value:${dt3.toString()}, dt3.sha256:${dt3.sha256}');

      expect(dt2.sha256, isNot(dt3.sha256));
    });

    test('hashString', () {
      system.throwOnError = false;
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
      system.throwOnError = false;
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
          ..debug('dt0.value:${dt0.toString()}')
          ..debug('dt1.value:${dt1.toString()}');
        expect(dt0 == dt1, true);
      }

      final dt2 = DcmDateTime.parse(goodDcmDateTimeList[0]);
      final dt3 = DcmDateTime.parse(goodDcmDateTimeList[1]);
      log
        ..debug('dt2 =.value:${dt2.toString()}')
        ..debug('dt3.value:${dt3.toString()}');
      expect(dt2 == dt3, false);
    });

    test('>', () {
      for (var y = 1900; y < 2000; y++) {
        for (var m = 1; m < 12; m++) {
          for (var d = 1; d < lastDayOfMonth(y, m); d++) {
            final dt0 = new Date(y, m, d);
            final dt1 = new Date(y, m, d + 1);
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
            final dt0 = new DcmDateTime(y, m, d);
            final dt1 = new DcmDateTime(y, m, d + 1);
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
              final dt0 = new DcmDateTime(y, m, d);
              final dt1 = new DcmDateTime(y, m, d + 1);
              expect(dt0.compareTo(dt1), -1);

              expect(dt1.compareTo(dt0), 1);
              expect(dt0.compareTo(dt0), 0);

              final dt2 = new DcmDateTime(y, m, d);
              expect(dt0.compareTo(dt2), 0);
            }
          }
        }
      }
    });
  });
}
