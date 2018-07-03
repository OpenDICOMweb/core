//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/server.dart' hide group;
import 'package:core/src/values/date_time/primitives/time.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'time_test', level: Level.info);

  group('Time Tests', () {
    test('Check Time', () {
      const max = kMicrosecondsPerDay;
      log.debug('max: $max');
      var v = 24 * 60 * 60 * 1000 * 1000;
      log.debug('max as v: $v');

      expect(v == kMicrosecondsPerDay, true);
      expect(timeToMicroseconds(23, 59, 59, 999, 999), kMicrosecondsPerDay - 1);

      v = kMicrosecondsPerHour +
          kMicrosecondsPerMinute +
          kMicrosecondsPerSecond;
      expect(timeToMicroseconds(1, 1, 1) == v, true);

      v = kMicrosecondsPerHour +
          kMicrosecondsPerMinute +
          kMicrosecondsPerSecond +
          kMicrosecondsPerMillisecond;
      expect(timeToMicroseconds(1, 1, 1, 1) == v, true);

      v = kMicrosecondsPerHour +
          kMicrosecondsPerMinute +
          kMicrosecondsPerSecond +
          kMicrosecondsPerMillisecond +
          1;
      expect(timeToMicroseconds(1, 1, 1, 1, 1) == v, true);
      expect(timeToMicroseconds(1, 60), isNull);
      expect(timeToMicroseconds(1, -1), isNull);
    });
    // **** Hours

    test('Hours Test', () {
      const m = 0, s = 0, ms = 0, us = 0;
      var h = 0;
      log.debug('hours test');
      for (var i = 0; i < 24; i++) {
        h = i;
        final ex = i * kMicrosecondsPerHour;
        final v = timeToMicroseconds(h, m);
        maybeLog('hours', h, m, s, ms, us, v, ex);
        expect(v == ex, true);
      }

      h = 24;
      expect(timeToMicroseconds(h) == null, true);
      h = 25;
      expect(timeToMicroseconds(h) == null, true);
      h = -1;
      expect(timeToMicroseconds(h) == null, true);
      h = -2;
      expect(timeToMicroseconds(h) == null, true);
    });
    // **** Minutes

    test('Minutes Test', () {
      const h = 0, s = 0, ms = 0, us = 0;
      var m = 0;
      log.debug('Minutes Test');

      for (var i = 0; i < 60; i++) {
        final m = i;
        final v = i * kMicrosecondsPerMinute;
        final ex = timeToMicroseconds(h, m);
        maybeLog('minutes', h, m, s, ms, us, v, ex);
        expect(v == ex, true);
      }

      m = -1;
      expect(timeToMicroseconds(h, m) == null, true);
      m = -1;
      expect(timeToMicroseconds(h, m) == null, true);
      m = 60;
      expect(timeToMicroseconds(h, m) == null, true);
      m = 61;
      expect(timeToMicroseconds(h, m) == null, true);
    });

    test('Seconds Test', () {
      const h = 0, ms = 0, us = 0;
      var m = 0, s = 0;
      log.debug('Seconds Test');

      for (var i = 0; i < 60; i++) {
        s = i;
        final ex = i * kMicrosecondsPerSecond;
        final v = timeToMicroseconds(h, m, s);
        maybeLog('hours', h, m, s, ms, us, v, ex);
        expect(v == ex, true);
      }

      m = -1;
      expect(timeToMicroseconds(h, m, s) == null, true);
      m = -1;
      expect(timeToMicroseconds(h, m, s) == null, true);
      m = 60;
      expect(timeToMicroseconds(h, m, s) == null, true);
      m = 61;
      expect(timeToMicroseconds(h, m, s) == null, true);
    });

    test('Milliseconds Test', () {
      const h = 0, m = 0, s = 0, us = 0;
      var ms = 0;
      log.debug('Milliseconds Test');

      for (var i = 0; i < 1000; i++) {
        ms = i;
        final ex = i * kMicrosecondsPerMillisecond;
        final v = timeToMicroseconds(h, m, s, ms);
        maybeLog('milliseconds', h, m, s, ms, us, v, ex);
        expect(v == ex, true);
      }

      ms = -1;
      expect(timeToMicroseconds(h, m, s, ms) == null, true);
      ms = -2;
      expect(timeToMicroseconds(h, m, s, ms) == null, true);
      ms = 1000;
      expect(timeToMicroseconds(h, m, s, ms) == null, true);
      ms = 1001;
      expect(timeToMicroseconds(h, m, s, ms) == null, true);
    });

    test('Microseconds Test', () {
      const h = 0, m = 0, s = 0, ms = 0;
      var us = 0;
      log.debug('Microseconds Test');

      for (var i = 0; i < 1000; i++) {
        us = i;
        final ex = i;
        final v = timeToMicroseconds(h, m, s, ms, us);
        maybeLog('microseconds', h, m, s, ms, us, v, ex);
        expect(v == ex, true);
      }

      us = -1;
      expect(timeToMicroseconds(h, m, s, ms, us) == null, true);
      us = -2;
      expect(timeToMicroseconds(h, m, s, ms, us) == null, true);
      us = 1000;
      expect(timeToMicroseconds(h, m, s, ms, us) == null, true);
      us = 1001;
      expect(timeToMicroseconds(h, m, s, ms, us) == null, true);
    });

    test('Time and Time Hash', () {
      const x = 3;
      const y = 101;
      log.debug('x: $x, y: $y');
      for (var h = 0; h < 24; h += x) {
        log.debug1('hour: $h');
        for (var m = 0; m < 60; m += x) {
          log.debug2('minute: $m');
          for (var s = 0; s < 60; s += x) {
            log.debug3('second: $s');
            for (var ms = 0; ms < 1000; ms += y) {
              for (var us = 0; us < 1000; us += y) {
                final v = h * kMicrosecondsPerHour +
                    m * kMicrosecondsPerMinute +
                    s * kMicrosecondsPerSecond +
                    ms * kMicrosecondsPerMillisecond +
                    us;
                final usTime = timeToMicroseconds(h, m, s, ms, us);
                expect(v == usTime, true);
                expect(isValidTime(h, m, s, ms, us), true);
                expect(isValidTimeMicroseconds(v), true);

                final hash = hashTimeMicroseconds(usTime);
                expect(isValidTimeMicroseconds(hash), true);
              }
            }
          }
        }
      }
    });

    test('isValidHour', () {
      for (var h = 0; h < 24; h++) {
        final isValid = isValidHour(23);
        log.debug('hour: $h');
        expect(isValid, true);
      }

      const inValidHour = 24;
      final isValid = isValidHour(inValidHour);
      log.debug('inValidHour: $inValidHour');
      expect(isValid, false);
    });

    test('isValidMinute', () {
      for (var m = 0; m < 60; m++) {
        final isValid = isValidMinute(m);
        log.debug('minute :$m');
        expect(isValid, true);
      }

      const inValidMinute = 60;
      final isValid = isValidMinute(inValidMinute);
      log.debug('inValidMinute: $inValidMinute');
      expect(isValid, false);
    });

    test('isValidSecond', () {
      for (var s = 0; s < 60; s++) {
        final isValid = isValidSecond(s);
        log.debug('Second: $s');
        expect(isValid, true);
      }

      const inValidSecond = 60;
      final isValid = isValidSecond(inValidSecond);
      log.debug('inValidSecond: $inValidSecond');
      expect(isValid, false);
    });

    test('isValidMillisecond', () {
      for (var ms = 0; ms < 1000; ms++) {
        final isValid = isValidMillisecond(ms);
        log.debug('Millisecond: $ms');
        expect(isValid, true);
      }

      const inValidMillisecond = 1000;
      final isValid = isValidHour(inValidMillisecond);
      log.debug('inValidMillisecond: $inValidMillisecond');
      expect(isValid, false);
    });

    test('isValidMicrosecond', () {
      for (var us = 0; us < 1000; us++) {
        final isValid = isValidMicrosecond(us);
        log.debug('Microsecond: $us');
        expect(isValid, true);
      }

      const inValidMicrosecond = 1000;
      final isValid = isValidMicrosecond(inValidMicrosecond);
      log.debug('inValidMicrosecond: $inValidMicrosecond');
      expect(isValid, false);
    });

    test('isValidSecondFraction', () {
      for (var sf = 0; sf < 1000000; sf++) {
        final isValid = isValidSecondFraction(sf);
        log.debug('SecondFraction: $sf');
        expect(isValid, true);
      }

      const inValidSecondFraction = 1000000;
      final isValid = isValidSecondFraction(inValidSecondFraction);
      log.debug('inValidSecondFraction: $inValidSecondFraction');
      expect(isValid, false);
    });

    test('hourFromMicrosecond', () {
      final hfm0 = hourFromMicrosecond(kMicrosecondsPerDay);
      log.debug('hfm0: $hfm0');
      expect(hfm0, isNotNull);

      final hfm1 = hourFromMicrosecond(kMicrosecondsPerDay - 1);
      log.debug('hfm1: $hfm1');
      expect(hfm1, isNotNull);

      final hfm2 = hourFromMicrosecond(0);
      log.debug('hfm2: $hfm2');
      expect(hfm2, isNotNull);

      final hfm3 = hourFromMicrosecond(-1);
      expect(hfm3, isNull);

      final hfm4 = hourFromMicrosecond(kMicrosecondsPerDay + 1);
      expect(hfm4, isNull);
    });

    test('minuteFromMicrosecond', () {
      final mfm0 = minuteFromMicrosecond(kMicrosecondsPerDay);
      log.debug('mfm0: $mfm0');
      expect(mfm0, isNotNull);

      final mfm1 = minuteFromMicrosecond(kMicrosecondsPerDay - 1);
      log.debug('mfm1: $mfm1');
      expect(mfm1, isNotNull);

      final mfm2 = minuteFromMicrosecond(0);
      log.debug('mfm2: $mfm2');
      expect(mfm2, isNotNull);

      final mfm3 = minuteFromMicrosecond(kMicrosecondsPerDay + 1);
      expect(mfm3, isNull);

      final mfm4 = minuteFromMicrosecond(-1);
      expect(mfm4, isNull);
    });

    test('secondFromMicrosecond', () {
      final sfm0 = secondFromMicrosecond(kMicrosecondsPerDay);
      log.debug('sfm0: $sfm0');
      expect(sfm0, isNotNull);

      final sfm1 = secondFromMicrosecond(kMicrosecondsPerDay - 1);
      log.debug('sfm1: $sfm1');
      expect(sfm1, isNotNull);

      final sfm2 = secondFromMicrosecond(0);
      log.debug('sfm2: $sfm2');
      expect(sfm2, isNotNull);

      final sfm3 = secondFromMicrosecond(kMicrosecondsPerDay + 1);
      expect(sfm3, isNull);

      final sfm4 = secondFromMicrosecond(-1);
      expect(sfm4, isNull);
    });

    test('millisecondFromMicrosecond', () {
      final msfm0 = millisecondFromMicrosecond(kMicrosecondsPerDay);
      log.debug('msfm0: $msfm0');
      expect(msfm0, isNotNull);

      final msfm1 = millisecondFromMicrosecond(kMicrosecondsPerDay - 1);
      log.debug('msfm1: $msfm1');
      expect(msfm1, isNotNull);

      final msfm2 = millisecondFromMicrosecond(0);
      log.debug('msfm2: $msfm2');
      expect(msfm2, isNotNull);

      final msfm3 = millisecondFromMicrosecond(kMicrosecondsPerDay + 1);
      expect(msfm3, isNull);

      final msfm4 = millisecondFromMicrosecond(-1);
      expect(msfm4, isNull);
    });

    test('microsecondFromMicrosecond', () {
      final usfm0 = microsecondFromMicrosecond(kMicrosecondsPerDay);
      log.debug('usfm0: $usfm0');
      expect(usfm0, isNotNull);

      final usfm1 = microsecondFromMicrosecond(kMicrosecondsPerDay - 1);
      log.debug('usfm1: $usfm1');
      expect(usfm1, isNotNull);

      final usfm2 = microsecondFromMicrosecond(0);
      log.debug('usfm2: $usfm2');
      expect(usfm2, isNotNull);

      final usfm3 = microsecondFromMicrosecond(kMicrosecondsPerDay + 1);
      expect(usfm3, isNull);

      final usfm4 = microsecondFromMicrosecond(-1);
      expect(usfm4, isNull);
    });
    test('fractionFromMicrosecond', () {
      final ffm0 = fractionFromMicrosecond(kMicrosecondsPerDay);
      log.debug('ffm0: $ffm0');
      expect(ffm0, isNotNull);

      final ffm1 = fractionFromMicrosecond(kMicrosecondsPerDay - 1);
      log.debug('ffm1: $ffm1');
      expect(ffm1, isNotNull);

      final ffm2 = fractionFromMicrosecond(0);
      log.debug('ffm2: $ffm2');
      expect(ffm2, isNotNull);

      final ffm3 = fractionFromMicrosecond(kMicrosecondsPerDay + 1);
      expect(ffm3, isNull);

      final ffm4 = fractionFromMicrosecond(-1);
      expect(ffm4, isNull);
    });

    test('finalernalTimeInMicroseconds', () {
      final itm0 = internalTimeInMicroseconds(10, 13, 48, 12, 15);
      log.debug('itm0: $itm0');
      expect(itm0, isNotNull);

      final itm1 = internalTimeInMicroseconds(24, 13, 48, 12, 15);
      log.debug('itm1: $itm1');
      expect(itm1, isNotNull);

      final itm2 = internalTimeInMicroseconds(21, -13, 48, 12, 15);
      log.debug('itm2: $itm2');
      expect(itm2, isNotNull);

      final itm3 = internalTimeInMicroseconds(21, -13, -48, 12, 15);
      log.debug('itm3: $itm3');
      expect(itm3, isNotNull);
    });
    test('timeToString', () {
      final t0 = timeToString(10, 13, 48, 12, 15);
      log.debug('t0;$t0');
      expect(t0, '101348.012015');

      final t1 = timeToString(-10, 13, 48, 12, 15);
      log.debug('t1;$t1');
      expect(t1, '0-101348.012015');

      final t2 = timeToString(11, -13, 48, 12, 15);
      log.debug('t2;$t2');
      expect(t2, '110-1348.012015');

      final t3 = timeToString(11, 13, 48, 0, 0);
      log.debug('t3;$t3');
      expect(t3, '111348.000000');

      final t4 = timeToString(11, 13, 48, 12, 456, asDicom: false);
      log.debug('t4;$t4');
      expect(t4, '11:13:48.012456');

      final t5 = timeToString(12, 13, 48, 0, 0, asDicom: false);
      log.debug('t5;$t5');
      expect(t5, '12:13:48.000000');

      final t6 = timeToString(-11, 13, 48, 670, 34, asDicom: false);
      log.debug('t6;$t6');
      expect(t6, '0-11:13:48.670034');

      final t7 = timeToString(11, 13, -48, 670, 34, asDicom: false);
      log.debug('t7;$t7');
      expect(t7, '11:13:0-48.670034');

      final t8 = timeToString(25, 13, 48, 670, 34, asDicom: false);
      log.debug('t8;$t8');
      expect(t8, '25:13:48.670034');
    });

    test('timeMicrosecondsToString', () {
      final tms0 = microsecondToTimeString(122334);
      log.debug('tms0:$tms0');
      expect(tms0, isNotNull);
      expect(tms0, equals('000000.122334'));

      final tms1 = microsecondToTimeString(201458, asDicom: false);
      log.debug('tms1:$tms1');
      expect(tms1, isNotNull);
      expect(tms1, equals('00:00:00.201458'));

      final tms2 = microsecondToTimeString(kMicrosecondsPerDay);
      log.debug('tms2:$tms2');
      expect(tms2, isNotNull);
      expect(tms2, equals('000000.000000'));

      final tms3 = microsecondToTimeString(kMicrosecondsPerDay + 1);
      log.debug('tms3:$tms3');
      expect(tms3, isNotNull);
      expect(tms3, equals('000000.000001'));
    });
  });
}

void maybeLog(
        String name, int h, int m, int s, int ms, int us, int v, int ex) =>
    log.debug('us per $name: h:$h, m:$m, s: $s, ms: $ms, us: $us, v: $v, ex: '
        '$ex');
