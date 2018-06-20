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
  Server.initialize(name: 'time_test', level: Level.info);

  const goodDcmTimes = const <String>[
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

  group('Time Tests', () {
    test('Good Time.parse', () {
      log.debug('Good Times');
      for (var s in goodDcmTimes) {
        log.debug('Time: $s');
        final time = Time.parse(s);
        log
          ..debug('  Time $s: $time')
          ..debug('  Milliseconds: ${time.millisecond}')
          ..debug('  Microseconds: ${time.microsecond}')
          ..debug('  Fraction: ${time.fraction}')
          ..debug('  ms: ${time.f}')
          ..debug('  us: ${time.f}');
        expect(time, isNotNull);
      }
    });

    test('Good Time.parse', () {
      log.debug('Good Times.isValid');
      for (var s in goodDcmTimes) {
        log.debug('Times.isValid: $s');
        final v = Time.isValidString(s);
        log.debug('  Times.isValid $s: $v');
        expect(v, true);
      }
    });

    test('Good Time as Time', () {
      for (var s in goodDcmTimes) {
        log.debug('  Time.parse: $s');
        final time = Time.parse(s);
        log.debug('    Time: $time');
        if (time == null)
          return invalidTimeString(
              'Bad Value{"$s"} in Good Time in Microseconds');
        expect(time, isNotNull);
        log
          ..debug('    Time.parse: "$s": $time')
          ..debug1('    Milliseconds: ${time.inMilliseconds}')
          ..debug1('    Microseconds: ${time.inMicroseconds}');
      }
    });

    test('Good Time to Time', () {
      log.debug('Good Times');
      for (var s in goodDcmTimes) {
        log.debug('  Time: $s');
        final time = Time.parse(s);
        log.debug('    Time: $time');
        if (time == null) {
          final issues = new Issues('Good Time to Time: "$s"');
          Time.parse(s, issues: issues);
          log.debug('    Issues: $issues');
        }
        expect(time, isNotNull);
        log
          ..debug('  Time "$s": $time')
          ..debug('    Hours: ${time.hour}')
          ..debug('    Minutes: ${time.minute}')
          ..debug('    Seconds: ${time.second}')
          ..debug1('    Milliseconds: ${time.millisecond}')
          ..debug1('    Microseconds: ${time.microsecond}')
          ..debug1('    Fraction: ${time.fraction}');
      }
    });
  });

  group('Bad DCM Time tests', () {
    const badDcmTimes = const <String>[
      '241318', // bad hour
      '006132', // bad minute
      '006060', // bad minute and second
      '000060', // bad month and day
      '-00101', // bad character in hour
      'a00101', // bad character in hour
      '0a0101', // bad character in hour
      'ad0101', // bad characters in hour
      '19a101', // bad character in minute
      '190b01', // bad character in minute
      '1901a1', // bad character in second
      '19011a', // bad character in second
      '999999.9', '999999.99', '999999.999',
      '999999.9999', '999999.99999', '999999.999999', //don't format
    ];

    const badDcmTimesInt = const <int>[
      241318, // bad hour
      006132, // bad minute
      131261, // bad second
      006060, // bad minute and second
      000060, // bad month and day
      -00101, // bad character in hour
      2310202705, // bad milliSecond
      23102007053234 //bad microSecond
    ];

    test('Time.parse with Bad Times', () {
      for (var s in badDcmTimes) {
        log.debug('  Time.parse: $s');
        final time = Time.parse(s);
        log.debug('    Time.parse: "$s": time: $time');
        expect(time == null, true);
      }
    });

    test('isValidDcmTime with Bad Times', () {
      for (var s in badDcmTimes) {
        log.debug('  isValidDcmTime: $s');
        final value = Time.isValidString(s);
        expect(value == false, true);
        log.debug('    isValidDcmTime: "$s": isValid: $value');
      }
    });

    test('Time.isValidString with Bad Times', () {
      for (var s in badDcmTimes) {
        log.debug('  Time.isValidString: $s');
        final value = Time.isValidString(s);
        expect(value == false, true);
        log.debug('    Time.isValidString: "$s": isValid: $value');
      }
    });

    test('Bad Times as Time', () {
      log.debug('Bad Times as Time');
      for (var s in badDcmTimes) {
        log.debug('Time: $s');
        final time = Time.parse(s);
        expect(time == null, true);
        log.debug('  Time: $s: $time');
      }
    });

    test('Good and Bad Time for isValidTimeString', () {
      for (var s in goodDcmTimes) {
        expect(Time.isValidString(s), true);
      }
      for (var s in badDcmTimes) {
        expect(Time.isValidString(s), false);
      }
    });

    test('Good and Bad Time for isValid', () {
      for (var s in goodDcmTimes) {
        expect(Time.isValidString(s), true);
      }
      for (var s in badDcmTimes) {
        expect(Time.isValidString(s), false);
      }
    });

    test('Bad Times, throwOnError = true', () {
      global.throwOnError = true;
      log.debug('throwOnError: $throwOnError');
      for (var i in badDcmTimesInt) {
        expect(() => new Time(i), throwsA(const TypeMatcher<DateTimeError>()));
      }

      global.throwOnError = false;
      log.debug('throwOnError: $throwOnError');
      for (var i in badDcmTimesInt) {
        final t = new Time(i);
        expect(t, isNull);
      }
    });

    test('Bad Times, throwOnError = false', () {
      global.throwOnError = false;
      log.debug('throwOnError: $throwOnError');

      for (var i in badDcmTimesInt) {
        expect(new Time(i), isNull);
      }
    });

    test('hashString time', () {
      for (var s in goodDcmTimes) {
        final hs0 = Time.hashString(s);
        log.debug('hs0: $hs0');
        expect(hs0, isNotNull);
      }

      for (var s in badDcmTimes) {
        final hs1 = Time.hashString(s);
        log.debug('hs1:$hs1');
        expect(hs1, isNull);
      }
    });

    test('hashStringList', () {
      final hs0 = Time.hashStringList(goodDcmTimes);
      log.debug('hs0:$hs0');
      expect(hs0, isNotNull);

      final hs1 = Time.hashStringList(badDcmTimes);
      log.debug('hs1:$hs1');
      for (var s in hs1) {
        expect(s, isNull);
      }
    });

    test('now', () {
      final t0 = Time.now;
      final us = t0.inMicroseconds;
      log.info('t0: $t0 us: $us');
    });

    test('==', () {
      for (var s in goodDcmTimes) {
        final t0 = Time.parse(s);
        final t1 = Time.parse(s);
        log
          ..debug('t0.value:${t0.toString()}')
          ..debug('t1.value:${t1.toString()}');
        expect(t0 == t1, true);
      }

      final t2 = Time.parse(goodDcmTimes[0]);
      final t3 = Time.parse(goodDcmTimes[1]);
      log
        ..debug('t2.value:${t2.toString()}')
        ..debug('t3.value:${t3.toString()}');
      expect(t2 == t3, false);
    });

    test('hash', () {
      for (var s in goodDcmTimes) {
        final t0 = Time.parse(s);
        final t1 = Time.parse(s);
        log
          ..debug('t0.hash: ${t0.hash}')
          ..debug('t0.value:${t0.toString()}, t0.hash:${t0.hash}')
          ..debug('t1.value:${t1.toString()}, t1.hash:${t1.hash}');
        expect(t0.hash, equals(t1.hash));
      }
      final t2 = Time.parse(goodDcmTimes[0]);
      final t3 = Time.parse(goodDcmTimes[1]);
      log
        ..debug('t2.value:${t2.toString()}, t2.hash:${t2.hash}')
        ..debug('t3.value:${t3.toString()}, t3.hash:${t3.hash}');

      expect(t2.hash, isNot(t3.hash));
    });

    test('sha256', () {
      for (var s in goodDcmTimes) {
        final t0 = Time.parse(s);
        final t1 = Time.parse(s);
        log
          ..debug('t0: $t0, us: ${t0.microsecond}')
          ..debug('t1: $t1, us: ${t1.microsecond}')
          ..debug('t0.sha256: ${t0.sha256}')
          ..debug('t0.value:${t0.toString()}, t0.sha256:${t0.sha256}')
          ..debug('t1.value:${t1.toString()}, t1.sha256:${t1.sha256}');
        expect(t0.sha256, equals(t1.sha256));
      }
      final t2 = Time.parse(goodDcmTimes[0]);
      final t3 = Time.parse(goodDcmTimes[1]);
      log
        ..debug('t2.value:${t2.toString()}, t2.sha256:${t2.sha256}')
        ..debug('t3.value:${t3.toString()}, t3.sha256:${t3.sha256}');

      expect(t2.sha256, isNot(t3.sha256));
    });

    test('hashCode', () {
      for (var s in goodDcmTimes) {
        final t0 = Time.parse(s);
        final t1 = Time.parse(s);
        log
          ..debug('t0.value:${t0.toString()}, t0.hash:${t0.hashCode}')
          ..debug('t1.value:${t1.toString()}, t1.hash:${t1.hashCode}');

        expect(t0.hashCode, equals(t1.hashCode));
      }

      final t2 = Time.parse(goodDcmTimes[0]);
      final t3 = Time.parse(goodDcmTimes[1]);
      log
        ..debug('t2.value:${t2.toString()}, t2.hash:${t2.hashCode}')
        ..debug('t3.value:${t3.toString()}, t3.hash:${t3.hashCode}');
      expect(t2.hashCode, isNot(t3.hashCode));
    });

    test('>', () {
      for (var h = 1; h < 24; h++) {
        for (var m = 1; m < 60; m++) {
          for (var s = 1; s < 59; s++) {
            final t0 = new Time(h, m, s);
            final t1 = new Time(h, m, s + 1);
            log.debug('t0: $t0, t1: $t1');
            expect(t1 > t0, true);
          }
        }
      }
    });

    test('<', () {
      for (var h = 1; h < 24; h++) {
        for (var m = 1; m < 60; m++) {
          for (var s = 1; s < 59; s++) {
            final t0 = new Time(h, m, s);
            final t1 = new Time(h, m, s + 1);
            log.debug('t0: $t0, t1: $t1');
            expect(t0 < t1, true);
          }
        }
      }
    });

    test('+ Operator', () {
      for (var h = 1; h < 24; h++) {
        for (var m = 1; m < 60; m++) {
          for (var s = 1; s < 59; s++) {
            final t0 = new Time(h, m, s);
            final t1 = new Time(h, m, s + 1);
            final t2 = t0 + t1;
            log.debug('t2.microseconds: ${t2.uSeconds}');
            expect(t2, isNotNull);
          }
        }
      }
    });

    test('- Operator', () {
      for (var h = 1; h < 24; h++) {
        for (var m = 1; m < 60; m++) {
          for (var s = 1; s < 59; s++) {
            final t0 = new Time(h, m, s);
            final t1 = new Time(h, m, s + 1);
            final t2 = t0 - t1;
            log.debug('t2.microseconds: ${t2.uSeconds}');
            expect(t2, isNotNull);
          }
        }
      }
    });

    test('compareTo', () {
      for (var h = 1; h < 24; h++) {
        for (var m = 1; m < 60; m++) {
          for (var s = 1; s < 60; s++) {
            if (s + 1 < 60) {
              final t0 = new Time(h, m, s);
              final t1 = new Time(h, m, s + 1);

              expect(t0.compareTo(t1), -1);
              expect(t1.compareTo(t0), 1);
              expect(t0.compareTo(t0), 0);
              expect(t1.compareTo(t1), 0);
            }
          }
        }
      }
    });
  });
}
