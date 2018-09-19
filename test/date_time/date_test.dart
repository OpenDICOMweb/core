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

import '../date_time_test_data/date_data.dart';

void main() {
  Server.initialize(
      name: 'date_test', minYear: 1900, maxYear: 2100, level: Level.info);

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

      global.throwOnError = false;
      for (var s in badDcmDateList) {
        final date = Date.parse(s);
        expect(date, isNull);
      }

      global.throwOnError = true;
      for (var s in badDcmDateList) {
        log.debug('Bad date: $s');
        expect(() => Date.parse(s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('issues', () {
      for (var s in goodDcmDateList) {
        expect(Date.isValidString(s), true);
        final issues = new Issues('Date: "$s"');
        Date.parse(s, issues: issues);
        expect(issues.isEmpty, true);
      }

      for (var s in badDcmDateList) {
        global.throwOnError = false;
        expect(Date.isValidString(s), false);
        final issues = new Issues('Date: "$s"');
        Date.parse(s, issues: issues);
        expect(issues.isEmpty, false);
      }
    });

    test('add and subtract', () {
      for (var y = 1990; y < global.maxYear; y++) {
        for (var m = 1; m < 12; m++) {
          for (var d = 1; d < lastDayOfMonth(y, m); d++) {
            final date0 = new Date(y, m, d);

            final time0 = Time.parse('235959');
            log.debug('$date0 - $time0');
            final dateTime0 = date0.add(time0);
            log.debug('dateTime: $dateTime0');
            expect(
                dateTime0.microseconds == date0.microseconds + time0.uSeconds,
                true);

            final dateTime1 = date0.difference(time0);
            log.debug('dateTime: $dateTime1');
            expect(
                dateTime1.microseconds == date0.microseconds - time0.uSeconds,
                true);
          }
        }
      }

      const s = '19500718';
      final date = Date.parse(s);
      log.debug(date);
      final time = Time.parse('235959');
      final dateTime0 = date.add(time);
      log.debug('dateTime: $dateTime0');
      expect(dateTime0.microseconds == date.microseconds + time.uSeconds, true);

      final time1 = new Time(4, 30, 56);
      final date1 = date.add(time1);
      log.debug(date1);
      expect(date1.microseconds == date.microseconds + time1.uSeconds, true);

      final time2 = new Time(05, 12, 34);
      final date2 = date.difference(time2);
      log.debug(date2);
      expect(date2.microseconds == date.microseconds - time2.uSeconds, true);

    });

    test('hash Date (throwOnError = false)', () {
      global.throwOnError = false;

      final date = new Date(1980, 05, 01);
      log.debug('date: $date');
      final hash0 = date.hash;
      log.debug('hash0: $hash0');

      final date0 = new Date(1980, 05, 41); //bad day
      expect(date0, isNull);

      final date1 = new Date(1980, 43, 12); //bad month
      expect(date1, isNull);

      final date2 = new Date(global.maxYear + 1, 05, 01); //bad year
      expect(date2, isNull);

      final date3 = new Date(global.minYear - 1, 05, 01); //bad year
      expect(date3, isNull);

      global.throwOnError = true;

      expect(() => new Date(global.maxYear + 1, 05, 01),
          throwsA(const TypeMatcher<DateTimeError>())); //bad year

      expect(() => new Date(global.minYear - 1, 05, 01),
          throwsA(const TypeMatcher<DateTimeError>())); //bad year

      expect(() => new Date(2004, 10, 32),
          throwsA(const TypeMatcher<DateTimeError>())); //bad day

      expect(() => new Date(2004, 13, 13),
          throwsA(const TypeMatcher<DateTimeError>())); //bad month
    });

    test('hashString Date', () {
      global.throwOnError = false;
      for (var s in goodDcmDateList) {
        log.debug('s: "$s"');
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
      global.throwOnError = false;
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

      global.throwOnError = false;
      final enrollment2 = new Date(2004, 10, 32); //bad day
      expect(enrollment2, isNull);

      final enrollment3 = new Date(2004, 13, 13); //bad month
      expect(enrollment3, isNull);

      global.throwOnError = true;
      expect(() => new Date(2004, 10, 32),
          throwsA(const TypeMatcher<DateTimeError>())); //bad day

      expect(() => new Date(2004, 13, 13),
          throwsA(const TypeMatcher<DateTimeError>())); //bad month

      /*Date enrollment1 = new Date(1992, 12, 12);
      Date normDate1 = original1.normalize(original1, enrollment1);
      log.debug('normDate0: $normDate1');*/
    });

    test('normalizeString', () {
      global.throwOnError = false;
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

      global.throwOnError = false;

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

      //global.throwOnError = true;
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
    final date = epochDayToEpochDate(0);
    log.debug(date);
    //for(var s in goodDcmDateList){
    final date0 = Date.parse(goodDcmDateList[0]);
    log
      ..debug('${date0.weekday}')
      ..debug('${date0.weekdayName}')
      ..debug('date0: $date0');
    final weekDayName0 = date0.weekdayName;
    log.debug('weekDayName0: $weekDayName0');
    //}
  });

  test('Hash Random Dates', () {
    final rng = new RNG();
    for (var i = 0; i < 1000; i++) {
      final eDay = rng.nextInt(global.minYear, global.maxYear);
      final date0 = Date.fromEpochDay(eDay);
      log.debug('date0: $date0');
      final hash0 = date0.hash;
      log.debug('hash0: $hash0');
      expect(hash0, isNotNull);
    }
  });

  test('Hash Dates', () {
    final date1 = new Date(1969, 12, 31);
    final hash1 = date1.hash;
    log.debug('hash1: $hash1, year: ${hash1.year}, y: ${hash1.y}');
    expect(hash1, isNotNull);
  });

  test('sha256 Dates', () {
    final date1 = new Date(1970, 05, 01);
    log.debug('date1: $date1');
    final sha0 = date1.sha256;
    log.debug('sha0: $sha0');
    expect(sha0, isNotNull);

    for (var s in goodDcmDateList) {
      final date0 = Date.parse(s);
      final date1 = Date.parse(s);
      log
        ..debug('date0: $date0, us: ${date0.toString()}')
        ..debug('date1: $date1, us: ${date1.toString()}')
        ..debug('date0.sha256: ${date0.sha256}')
        ..debug('date1.values:${date1.toString()}, date0.sha256:${date0.sha256}')
        ..debug(
            'date1.values:${date1.toString()}, date1.sha256:${date1.sha256}');
      expect(date0.sha256, equals(date1.sha256));
    }
    final date2 = Date.parse(goodDcmDateList[0]);
    final date3 = Date.parse(goodDcmDateList[1]);
    log
      ..debug('date2.values:${date2.toString()}, date2.sha256:${date2.sha256}')
      ..debug('date3.values:${date3.toString()}, t3.sha256:${date3.sha256}');

    expect(date2.sha256, isNot(date3.sha256));
  });

  test('==', () {
    for (var s in goodDcmDateList) {
      final date0 = Date.parse(s);
      final date1 = Date.parse(s);
      log
        ..debug('date0.values:${date0.toString()}')
        ..debug('date1.values:${date1.toString()}');
      expect(date0 == date1, true);
    }

    final date2 = Date.parse(goodDcmDateList[0]);
    final date3 = Date.parse(goodDcmDateList[1]);
    log
      ..debug('date2.values:${date2.toString()}')
      ..debug('date3.values:${date3.toString()}');
    expect(date2 == date3, false);
  });

  test('hash', () {
    global.throwOnError = true;
    for (var s in goodDcmDateList) {
      final date0 = Date.parse(s);
      if (date0 != null) {
        log
          ..debug('date0:$date0')
          ..debug('date0.values:${date0.toString()}, date0.hash:${date0.hash}');
        final date1 = Date.parse(s);
        log
          ..debug('date1:$date1')
          ..debug('date1.values:${date1.toString()}, date1.hash:${date1.hash}');
        expect(date0.hash, equals(date1.hash));
      } else {
        return invalidDateString('Invalid Date String: "$s"');
      }
    }

    final date2 = Date.parse(goodDcmDateList[0]);
    final date3 = Date.parse(goodDcmDateList[1]);
    log
      ..debug('date2.values:${date2.toString()}, date2.hash:${date2.hash}')
      ..debug('date3.values:${date3.toString()}, date3.hash:${date3.hash}');
    expect(date2.hash, isNot(date3.hash));
    return true;
  });

  test('Hash Dates', () {
    final date1 = new Date(1969, 12, 31);
    log.debug(
        'date: $date1, year:${date1.year}, month: ${date1.month}, '
            'day: ${date1.day}, microseconds: ${date1.microseconds}');
    final hash1 = date1.hash;
    log.debug('hash1: $hash1, year: ${hash1.year}, y: ${hash1.y}');
  });

  test('date hash', () {
    final date = new Date(1980, 05, 01);
    log.debug('date: $date');
    final hash0 = date.hash;
    log.debug('hash0: $hash0');
  });

  test('hashCode', () {
    for (var s in goodDcmDateList) {
      final date0 = Date.parse(s);
      final date1 = Date.parse(s);
      log
        ..debug('date0.values:${date0.toString(
				  )}, date0.hashCode:${date0.hashCode}')
        ..debug('date1.values:${date1.toString(
				  )}, date1.hashCode:${date1.hashCode}');
      expect(date0.hashCode, equals(date1.hashCode));
    }
    final date2 = Date.parse(goodDcmDateList[0]);
    final date3 = Date.parse(goodDcmDateList[1]);
    log
      ..debug('date2.values:${date2.toString()}, date2.hash:${date2.hashCode}')
      ..debug('date3.values:${date3.toString()}, date3.hash:${date3.hashCode}');
    expect(date2.hashCode, isNot(date3.hashCode));
  });

  test('>', () {
    for (var y = global.minYear; y < global.maxYear; y++) {
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
    for (var y = global.minYear; y < global.maxYear; y++) {
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
    for (var y = global.minYear; y < global.maxYear; y++) {
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
    for (var y = global.minYear; y < global.maxYear; y++) {
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

  test('compareTo', () {
    for (var y = global.minYear; y < global.maxYear; y++) {
      for (var m = 1; m < 12; m++) {
        for (var d = 1; d < lastDayOfMonth(y, m); d++) {
          if (d + 1 < lastDayOfMonth(y, m)) {
            final dt0 = new Date(y, m, d);
            final dt1 = new Date(y, m, d + 1);
            expect(dt0.compareTo(dt1), -1);

            expect(dt1.compareTo(dt0), 1);
            expect(dt0.compareTo(dt0), 0);
          }
        }
      }
    }
  });

  test('parseDate', () {
//    global.throwOnError = false;

    const goodDateList = const [
      '19500718',
      '19000101',
      '19700101',
      '19931010',
      '20171231',
      '20171130',
      '20501231',
      '2018-03-05',
      '1998-12-19'
    ];

    for (var date in goodDateList) {
      final pd0 = parseDate(date);
      log.debug('date: $date pd0: $pd0');
      expect(pd0, isNotNull);
    }

    for (var date in badDcmDateList) {
      global.throwOnError = false;
      final pd0 = parseDate(date);
      log.debug('pd0: $pd0');
      expect(pd0, isNull);
    }
  });

  test('hashDcmDateString', () {
    global.throwOnError = false;
    for (var i = 0; i < goodDcmDateList.length; i++) {
      final ns1 = hashDcmDateString(goodDcmDateList[i]);
      log.debug('ns1:$ns1, ${goodDcmDateList[i]}');
      expect(ns1, isNotNull);
    }

    for (var badDate in badDcmDateList) {
      final ns1 = hashDcmDateString(badDate);
      log.debug('ns1:$ns1, $badDate');
      expect(ns1, isNull);
    }
  });

  test('isValidYearInMicroseconds', () {
    global.throwOnError = false;
    final us = dateToEpochDay(1971, 1, 1);
    final vym0 = isValidYearInMicroseconds(us);
    expect(vym0, true);

    final vym1 = isValidYearInMicroseconds(global.minYearInMicroseconds);
    expect(vym1, true);

    final vym2 = isValidYearInMicroseconds(global.maxYearInMicroseconds);
    expect(vym2, true);

    final vym3 = isValidYearInMicroseconds(global.maxYearInMicroseconds + 1);
    expect(vym3, false);

    final vym4 = isValidYearInMicroseconds(global.minYearInMicroseconds - 1);
    expect(vym4, false);
  });
}
