// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:math' as math;

import 'package:core/server.dart';
import 'package:core/src/date_time/data/date_data.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(
      name: 'date_test',
      minYear: kMinYearLimit,
      maxYear: kMaxYearLimit,
      level: Level.info);
  //Good dates
  const goodDcmDateList = const <String>['19500718', '00000101', '19700101'];

  //Bad dates

  group('Date Tests', () {
    test('Good Dates', () {
      log.debug('Good Dates');
      for (var s in goodDcmDateList) {
        log.debug('Good Dates: s("$s")');
        final d = Date.parse(s);
        log.debug('Good Dates: s("$s"), date($d)');
        expect(d, isNotNull);
        log.debug('  Date $s: $d');
      }
    });

    test('Bad Dates', () {
      log.debug1('Bad Dates');
      for (var s in badDcmDateList) {
        final d = Date.parse(s);
        expect(d == null, true);
        log.debug1('  Date: $s: $d');
      }
    });
  });

  group('isValidDateString', () {
    test('isValidDateString Good and Bad dates', () {
      for (var s in goodDcmDateList) {
        expect(Date.isValidString(s), true);
      }
      for (var s in badDcmDateList) {
        expect(Date.isValidString(s), false);
      }
    });
  });

  group('isValid', () {
    test('isValid Good and Bad dates', () {
      for (var s in goodDcmDateList) {
        final date = Date.parse(s);
        expect(date, isNotNull);
      }

      system.throwOnError = false;
      for (var s in badDcmDateList) {
        final date = Date.parse(s);
        expect(date, isNull);
      }

      system.throwOnError = true;
      for (var s in badDcmDateList) {
        log.debug('Bad date: $s');
        expect(
            () => Date.parse(s), throwsA(const isInstanceOf<InvalidDateStringError>()));
      }
    });

    test('issues', () {
      for (var s in goodDcmDateList) {
        expect(Date.isValidString(s), true);
        final issues = new ParseIssues('Date', s);
        Date.parse(s, issues: issues);
        expect(issues.isEmpty, true);
      }

      for (var s in badDcmDateList) {
        system.throwOnError = false;
        expect(Date.isValidString(s), false);
        final issues = new ParseIssues('Date', s);
        Date.parse(s, issues: issues);
        expect(issues.isEmpty, false);
      }
    });

    test('add and subtract', () {
      for (var y = 1990; y < 2000; y++) {
        for (var m = 1; m < 12; m++) {
          for (var d = 1; d < lastDayOfMonth(y, m); d++) {
            final date0 = new Date(y, m, d);

            final time0 = Time.parse('235959');
            final dateTime0 = date0.add(time0);
            log.debug('dateTime: $dateTime0');

            final dateTime1 = date0.difference(time0);
            log.debug('dateTime: $dateTime1');
          }
        }
      }
      /*final s = '19500718';
      final dt = Date.parse(s);
      log.debug(dt);
      // Enhancement
      DcmDateTime ddt1 = dt.add(new Time(hours: 4, minutes: 20, seconds: 56));
      log.debug(ddt1.hour);
      log.debug(ddt1.minute);
      log.debug(ddt1.second);

      DcmDateTime ddt2 =
          dt.subtract(new Time(hours: 2, minutes: 5, seconds: 26));
      log.debug(ddt2.hour);
      log.debug(ddt2.minute);
      log.debug(ddt2.second);*/
    });

    test('hash Date (throwOnError = false)', () {
      system.throwOnError = false;

      final date = new Date(1980, 05, 01);
      log.debug('date: $date');
      final hash0 = date.hash;
      log.debug('hash0: $hash0');

      final date0 = new Date(1980, 05, 41); //bad day
      expect(date0, isNull);

      final date1 = new Date(1980, 43, 12); //bad month
      expect(date1, isNull);

      final date2 = new Date(system.maxYear + 1, 05, 01); //bad year
      expect(date2, isNull);

      final date3 = new Date(system.minYear - 1, 05, 01); //bad year
      expect(date3, isNull);

      system.throwOnError = true;

      expect(() => new Date(system.maxYear + 1, 05, 01),
          throwsA(const isInstanceOf<InvalidDateError>())); //bad year

      expect(() => new Date(system.minYear - 1, 05, 01),
          throwsA(const isInstanceOf<InvalidDateError>())); //bad year

      expect(() => new Date(2004, 10, 32),
          throwsA(const isInstanceOf<InvalidDateError>())); //bad day

      expect(() => new Date(2004, 13, 13),
          throwsA(const isInstanceOf<InvalidDateError>())); //bad month
    });

    test('hashString Date', () {
      system.throwOnError = false;
      for (var s in goodDcmDateList) {
        log.info0('s: "$s"');
        final hs0 = Date.hashString(s);
        log.debug('hs0: $hs0');
        expect(hs0, isNotNull);
      }

      for (var s in badDcmDateList) {
        final hs1 = Date.hashString(s);
        log.debug('hs1: $hs1');
        expect(hs1, isNull);
      }
    });

    test('hashStringList', () {
      system.throwOnError = false;
      final hs0 = Date.hashStringList(goodDcmDateList);
      log.debug('hsl0: $hs0');
      expect(hs0, isNotNull);

      final hs1 = Date.hashStringList(badDcmDateList);
      log.debug('hs1: $hs1');
      for (var s in hs1) {
        expect(s, isNull);
      }
    });

    test('normalizD', () {
      //Date original0 = new Date(2004, 10, 10);
      final enrollment0 = new Date(1992, 12, 12);
      final normDate0 = enrollment0.normalize(enrollment0);
      log.debug('normDate0: $normDate0');

      final enrollment1 = new Date(2012, 1, 12);
      final normDate1 = enrollment1.normalize(enrollment1);
      log.debug('normDate0: $normDate1');

      system.throwOnError = false;
      final enrollment2 = new Date(2004, 10, 32); //bad day
      expect(enrollment2, isNull);

      final enrollment3 = new Date(2004, 13, 13); //bad month
      expect(enrollment3, isNull);

      system.throwOnError = true;
      expect(() => new Date(2004, 10, 32),
          throwsA(const isInstanceOf<InvalidDateError>())); //bad day

      expect(() => new Date(2004, 13, 13),
          throwsA(const isInstanceOf<InvalidDateError>())); //bad month

      /*Date enrollment1 = new Date(1992, 12, 12);
      Date normDate1 = original1.normalize(original1, enrollment1);
      log.debug('normDate0: $normDate1');*/
    });

    test('normalizeString', () {
      var date = Date.parse('19821010');
      final ns0 = Date.normalizeString('19931010', date);
      expect(ns0, isNotNull);
      log.debug('ns0:$ns0');

      date = Date.parse('19821010');
      final ns1 = Date.normalizeString('19931510', date);
      log.debug('ns1:$ns1');
      expect(ns1, isNull);

      date = Date.parse('19821010');
      final ns2 = Date.normalizeString('19931144', date);
      log.debug('ns2:$ns2');
      expect(ns2, isNull);

      date = Date.parse('19821010');
      final ns3 = Date.normalizeString('-1991510', date);
      log.debug('ns3:$ns3');
      expect(ns3, isNull);

      date = Date.parse('19821010');
      final ns4 = Date.normalizeString('199a1144', date);
      log.debug('ns4: $ns4');
      expect(ns4, isNull);

      date = Date.parse('19821010');
      final ns5 = Date.normalizeString('197001a1', date);
      log.debug('ns5: $ns5');
      expect(ns5, isNull);

      date = Date.parse('19821010');
      final ns6 = Date.normalizeString('1970011a', date);
      log.debug('ns6: $ns6');
      expect(ns6, isNull);

      system.throwOnError = false;

      date = Date.parse('19821910');
      expect(date, isNull);
      final ns7 = Date.normalizeString('19931010', date);
      log.debug('ns7:$ns7');
      expect(ns7, isNull);

      date = Date.parse('19961135');
      expect(date == null, true);
      final ns8 = Date.normalizeString('19931010', date);
      log.debug('ns8:$ns8');
      expect(ns8, isNull);

      date = Date.parse('199a1115');
      expect(date, isNull);
      final ns9 = Date.normalizeString('19931010', date);
      log.debug('ns9: $ns9');
      expect(ns9, isNull);

      date = Date.parse('-19931115');
      expect(date, isNull);
      final ns10 = Date.normalizeString('19931010', date);
      log.debug('ns10: $ns10');
      expect(ns10, isNull);

      date = Date.parse('19700b01');
      expect(date, isNull);
      final ns11 = Date.normalizeString('19931010', date);
      log.debug('ns11: $ns11');
      expect(ns11, isNull);

      date = Date.parse('1970011a');
      expect(date, isNull);
      final ns12 = Date.normalizeString('19931010', date);
      log.debug('ns12: $ns12');
      expect(ns12, isNull);

      date = Date.parse('19701310');
      expect(date, isNull);
      final ns13 = Date.normalizeString('19931510', date);
      log.debug('ns13: $ns13');
      expect(ns13, isNull);
    });

    test('noramalizeStrings', () {
      var date = Date.parse('19921010');
      final nss0 = Date.normalizeStrings(goodDcmDateList, date);
      log.debug('nss0:$nss0');

      final dList1 = ['20041033'];
      date = Date.parse('19921010');
      final nss1 = Date.normalizeStrings(dList1, date);
      log.debug('nss1:$nss1');
      expect(nss1, isNull);

      final dList2 = ['20042319'];
      date = Date.parse('19921010');
      final nss2 = Date.normalizeStrings(dList2, date);
      log.debug('nss2:$nss2');
      expect(nss2, isNull);

      final dList3 = ['20041010'];
      date = Date.parse('19922310');
      final nss3 = Date.normalizeStrings(dList3, date);
      log.debug('nss3:$nss3');
      expect(nss3, isNull);

      //system.throwOnError = true;
      final dList4 = ['20041033'];
      date = Date.parse('19921010');
      final nss4 = Date.normalizeStrings(dList4, date);
      log.debug('nss4:$nss4');
      expect(nss4, isNull);

      final dList5 = ['20042319'];
      date = Date.parse('19921010');
      final nss5 = Date.normalizeStrings(dList5, date);
      log.debug('nss5:$nss5');
      expect(nss5, isNull);

      final dList6 = ['20041010'];
      date = Date.parse('19922310');
      final nss6 = Date.normalizeStrings(dList6, date);
      log.debug('nss6:$nss6');
      expect(nss6, isNull);

      date = Date.parse('19922310');
      final nss7 = Date.normalizeStrings(badDcmDateList, date);
      log.debug('nss7:$nss7');
      expect(nss7, isNull);
    });
  });

  test('weekDayName', () {
    final List date = epochDayToDate(0);
    print(date);
    //for(var s in goodDcmDateList){
    final date0 = Date.parse(goodDcmDateList[0]);
    log..debug('${date0.weekday}')..debug('${date0.weekdayName}')..debug('date0: $date0');
    final weekDayName0 = date0.weekdayName; //check once
    log.debug('weekDayName0: $weekDayName0');
    //}
  });

  test('Hash Random Dates', () {
    final rng = new math.Random();

    for (var i = 0; i < 1000; i++) {
      final eDay = (rng.nextDouble() * 1000).toInt();
      final date0 = new Date.fromEpochDay(eDay);
      log.debug('date: $date0');
      final hash0 = date0.hash;
      log.debug('hash0: $hash0');
    }
  });

  test('Hash Dates', () {
    final date1 = new Date(1960, 05, 01);
    log.debug('date: $date1');
    final hash1 = date1.hash;
    log..debug('hash1: $hash1')..debug('hash0: $hash1');
  });

  test('==', () {
    for (var s in goodDcmDateList) {
      final date0 = Date.parse(s);
      final date1 = Date.parse(s);
      log
        ..debug('date0.value:${date0.toString()}')
        ..debug('date1.value:${date1.toString()}');
      expect(date0 == date1, true);
    }

    final date2 = Date.parse(goodDcmDateList[0]);
    final date3 = Date.parse(goodDcmDateList[1]);
    log
      ..debug('date2.value:${date2.toString()}')
      ..debug('date3.value:${date3.toString()}');
    expect(date2 == date3, false);
  });

  test('hash', () {
    system.throwOnError = true;
    for (var s in goodDcmDateList) {
      final date0 = Date.parse(s);
      if (date0 != null) {
        log
          ..debug('date0:$date0')
          ..debug('date0.value:${date0.toString()}, date0.hash:${date0.hash}');
        final date1 = Date.parse(s);
        log
          ..debug('date1:$date1')
          ..debug('date1.value:${date1.toString()}, date1.hash:${date1.hash}');
        expect(date0.hash, equals(date1.hash));
      } else {
        return invalidDateString('Invalid Date String: "$s"');
      }
    }

    final date2 = Date.parse(goodDcmDateList[0]);
    final date3 = Date.parse(goodDcmDateList[1]);
    log
      ..debug('date2.value:${date2.toString()}, date2.hash:${date2.hash}')
      ..debug('date3.value:${date3.toString()}, date3.hash:${date3.hash}');
    expect(date2.hash, isNot(date3.hash));
  });

  test('hashCode', () {
    for (var s in goodDcmDateList) {
      final date0 = Date.parse(s);
      final date1 = Date.parse(s);
      log..debug('date0.value:${date0.toString(
				  )}, date0.hashCode:${date0.hashCode}')..debug('date1.value:${date1.toString(
				  )}, date1.hashCode:${date1.hashCode}');
      expect(date0.hashCode, equals(date1.hashCode));
    }
    final date2 = Date.parse(goodDcmDateList[0]);
    final date3 = Date.parse(goodDcmDateList[1]);
    log
      ..debug('date2.value:${date2.toString()}, date2.hash:${date2.hashCode}')
      ..debug('date3.value:${date3.toString()}, date3.hash:${date3.hashCode}');
    expect(date2.hashCode, isNot(date3.hashCode));
  });

  test('>', () {
    for (var y = 1800; y < 2000; y++) {
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
    for (var y = 1800; y < 2000; y++) {
      for (var m = 1; m < 12; m++) {
        for (var d = 1; d < lastDayOfMonth(y, m); d++) {
          final dt0 = new Date(y, m, d);
          final dt1 = new Date(y, m, d + 1);
          log.debug('dt0: $dt0, dt1: $dt1');
          expect(dt0 < dt1, true);
        }
      }
    }
  });

  test('isAfter', () {
    for (var y = 1800; y < 2000; y++) {
      for (var m = 1; m < 12; m++) {
        for (var d = 1; d < lastDayOfMonth(y, m); d++) {
          final dt0 = new Date(y, m, d);
          final dt1 = new Date(y, m, d + 1);
          log.debug('dt0: $dt0, dt1: $dt1');
          expect(dt1.isAfter(dt0), true);
        }
      }
    }
  });

  test('isBefore', () {
    for (var y = 1800; y < 2000; y++) {
      for (var m = 1; m < 12; m++) {
        for (var d = 1; d < lastDayOfMonth(y, m); d++) {
          final dt0 = new Date(y, m, d);
          final dt1 = new Date(y, m, d + 1);
          log.debug('dt0: $dt0, dt1: $dt1');
          expect(dt0.isBefore(dt1), true);
        }
      }
    }
  });
}
