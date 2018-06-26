//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:math' hide log;

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'time_zone_test', level: Level.info);

  group('Time Zone Tests', () {
    test('checkTimeZone', () {
      var m = 1 * (13 * 60) + 45;
      var us = 1 * (13 * 60) + 45 * kMicrosecondsPerMinute;
      log.debug('test 1, 13, 45: value: $m');

      m = -1 * (12 * 60) + 00;
      us = m * kMicrosecondsPerMinute;
      expect(timeZoneToMicroseconds(-1, 12, 00) == us, true);

      m = -1 * (12 * 60) + 00;
      us = m * kMicrosecondsPerMinute;
      expect(timeZoneToMicroseconds(-1, -12, 00) == us, true);

      m = -1 * (15 * 60) + 00;
      us = m * kMicrosecondsPerMinute;

      expect(timeZoneToMicroseconds(1, 15, 00) == us, false);
      expect(timeZoneToMicroseconds(2, 12, 00), isNull);
      expect(timeZoneToMicroseconds(1, 15, 00), isNull);
      expect(timeZoneToMicroseconds(1, 13, 61), isNull);
      expect(timeZoneToMicroseconds(1, 13, 15), isNull);
      expect(timeZoneToMicroseconds(1, 13, 45), isNull);
    });

    test('timeZoneHash', () {
      for (var j = 0; j < 1000; j++) {
        for (var hour = kMinTimeZoneHour; hour < kMaxTimeZoneHour; hour++) {
          if (isNotValidTimeZoneHour(hour)) invalidTimeZoneError(hour.sign, hour, 0);

          final sign = (hour.sign.isNegative) ? -1 : 1;

          log.debug('j: $j, i: $hour, sign: $sign');
          var us = timeZoneToMicroseconds(sign, hour, 00);
          log.debug('j: $j, i: $hour, sign: $sign, us: $us');
          var answerShouldBe = kValidTZMicroseconds.contains(us);
          var answer = isValidTimeZoneMicroseconds(us);
          expect(answer == answerShouldBe, true);
          if (answerShouldBe) {
            final hash = hashTimeZoneMicroseconds(us);
            final answerShouldBe = kValidTZMicroseconds.contains(us);
            final answer = isValidTimeZoneMicroseconds(hash);
            expect(answerShouldBe == answer, true);
          }

          log.debug('j: $j, i: $hour, sign: $sign');
          us = timeZoneToMicroseconds(sign, hour, 30);
          log.debug('j: $j, i: $hour, sign: $sign, tzm: $us');
          answerShouldBe = kValidTZMicroseconds.contains(us);
          answer = isValidTimeZoneMicroseconds(us);
          expect(answer == answerShouldBe, true);
          if (answerShouldBe) {
            final hash = hashTimeZoneMicroseconds(us);
            final answerShouldBe = kValidTZMicroseconds.contains(hash);
            final answer = isValidTimeZoneMicroseconds(hash);
            expect(answerShouldBe == answer, true);
          }

          log.debug('j: $j, i: $hour, sign: $sign');
          us = timeZoneToMicroseconds(sign, hour, 45);
          log.debug('j: $j, i: $hour, sign: $sign, tzm: $us');
          answer = isValidTimeZoneMicroseconds(us);
          answerShouldBe = kValidTZMicroseconds.contains(us);
          expect(answer == answerShouldBe, true);
          if (answerShouldBe) {
            final hash = hashTimeZoneMicroseconds(us);
            final answerShouldBe = kValidTZMicroseconds.contains(us);
            final answer = isValidTimeZoneMicroseconds(hash);
            expect(answerShouldBe == answer, true);
          }
        }
      }
    });

    test('timeZoneMicrosecondToString', () {
      global.throwOnError = false;
      final tzms0 = timeZoneMicrosecondsToString(kMicrosecondsPerDay);
      log.debug('tzms0: $tzms0');
      expect(tzms0, isNull);

      final tzms1 = timeZoneMicrosecondsToString(12323454675);
      log.debug('tzms1: $tzms1');
      expect(tzms1, isNull);

      for (var i = kMinTimeZoneHour; i <= kMaxTimeZoneHour; i++) {
        final sign = (i.sign.isNegative) ? -1 : 1;

        if (i > -12 && i < 14) {
          log.debug('i: $i, sign: $sign, h: $i m: 00');
          if (isValidTimeZone(sign, i, 00)) {
            final us = timeZoneToMicroseconds(sign, i, 00);
            log.debug('  us: $us');
            final s = timeZoneMicrosecondsToString(us);
            log.debug('  s: $s');
            expect(s, isNotNull);
          } else {
            final us = timeZoneToMicroseconds(sign, i, 00);
            log.debug('  us: $us');
            expect(us, isNull);
          }

          log.debug('i: $i, sign: $sign, h: $i m: 15');
          if (isValidTimeZone(sign, i, 15)) {
            final us = timeZoneToMicroseconds(sign, i, 15);
            log.debug('  us: $us');
            final s = timeZoneMicrosecondsToString(us);
            log.debug('  s: $s');
            expect(s, isNotNull);
          } else {
            final us = timeZoneToMicroseconds(sign, i, 15);
            log.debug('  us: $us');
            expect(us, isNull);
          }

          log.debug('i: $i, sign: $sign, h: $i m: 30');
          if (isValidTimeZone(sign, i, 30)) {
            final us = timeZoneToMicroseconds(sign, i, 30);
            log.debug('  us: $us');
            final s = timeZoneMicrosecondsToString(us);
            log.debug('  s: $s');
            expect(s, isNotNull);
          } else {
            final us = timeZoneToMicroseconds(sign, i, 30);
            log.debug('  us: $us');
            expect(us, isNull);
          }

          log.debug('i: $i, sign: $sign, h: $i m: 45');
          if (isValidTimeZone(sign, i, 45)) {
            final us = timeZoneToMicroseconds(sign, i, 45);
            log.debug('  us: $us');
            final s = timeZoneMicrosecondsToString(us);
            log.debug('  s: $s');
            expect(s, isNotNull);
          } else {
            final us = timeZoneToMicroseconds(sign, i, 45);
            log.debug('  us: $us');
            expect(us, isNull);
          }
        }
      }
      final tzms2 = timeZoneMicrosecondsToString(0);
      log.debug('tzms2: $tzms2');
      expect(tzms2, isNotNull);

      final tzms3 = timeZoneMicrosecondsToString(kMicrosecondsPerDay, asDicom: false);
      log.debug('tzms3: $tzms3');
      expect(tzms3, isNull);

      final tzms4 = timeZoneMicrosecondsToString(-kMicrosecondsPerDay, asDicom: false);
      log.debug('tzms4: $tzms4');
      expect(tzms4, isNull);
    });

    test('timeZoneToString', () {
      global.throwOnError = false;
      for (var h = kMinTimeZoneHour; h < kMaxTimeZoneHour; h++) {
        final sign = (h.sign.isNegative) ? -1 : 1;

        if (h >= -12 && h <= 14) {
          for (var m = 0; m < 60; m++) {
            log.debug('sign: $sign, h: $h, m: $m, ');
            if (isValidTimeZone(sign, h, m)) {
              final tzs0 = timeZoneToString(sign, h, m);
              log.debug('  tzs0: $tzs0');
              expect(tzs0, isNotNull);
            } else {
              global.throwOnError = true;
              expect(() => timeZoneToString(sign, h, m),
                  throwsA(equals(const TypeMatcher<InvalidTimeZoneError>())));

              global.throwOnError = false;
              final tzs2 = timeZoneToString(sign, h, m);
              log.debug('  tzs2: $tzs2');
              expect(tzs2, isNull);
            }
          }
        }
      }
      final tzs5 = timeZoneToString(-1, 0, 0, asDicom: false);
      log.debug('tzs5: $tzs5');
      expect(tzs5, 'Z');

      final tzs6 = timeZoneToString(-1, 0, 0);
      log.debug('tzs6: $tzs6');
      expect(tzs6, '+0000');
    });

    test('timeZoneToMinutes', () {
      global.throwOnError = false;
      for (var h = kMinTimeZoneHour; h < kMaxTimeZoneHour; h++) {
        final sign = (h.sign.isNegative) ? -1 : 1;

        if (h >= -12 && h <= 14) {
          for (var m = 0; m < 60; m++) {
            log.debug('sign: $sign, h: $h, m: $m, ');
            if (isValidTimeZone(sign, h, m)) {
              final tzm0 = timeZoneToMinutes(sign, h, m);
              log.debug('  tzm0: $tzm0');
              expect(tzm0, isNotNull);
            } else {
              global.throwOnError = true;
              expect(() => timeZoneToMinutes(sign, h, m),
                  throwsA(equals(const TypeMatcher<InvalidTimeZoneError>())));

              global.throwOnError = false;
              final tzm1 = timeZoneToMinutes(sign, h, m);
              log.debug('  tzm1: $tzm1');
              expect(tzm1, isNull);
            }
          }
        }
      }
    });

    test('timeZoneHour', () {
      global.throwOnError = false;
      for (var h = kMinTimeZoneHour; h < kMaxTimeZoneHour; h++) {
        final sign = (h.sign.isNegative) ? -1 : 1;

        if (h >= -12 && h <= 14) {
          for (var m = 0; m < 60; m++) {
            log.debug('sign: $sign, h: $h, m: $m, ');
            if (isValidTimeZone(sign, h, m)) {
              final us0 = timeZoneToMicroseconds(sign, h, m);
              log.debug('  us0: $us0');
              if (us0 != null) {
                final tzh0 = timeZoneHour(us0);
                log.debug('tzh0: $tzh0');
                expect(tzh0, isNotNull);
              }
            } else {
              final us1 = timeZoneToMicroseconds(sign, h, m);
              if (us1 != null) {
                final tzh1 = timeZoneHour(us1);
                log.debug('  tzh1: $tzh1');
                expect(tzh1, isNull);
              }
            }
          }
        }
      }
    });

    test('timeZoneMinute', () {
      global.throwOnError = false;
      for (var h = kMinTimeZoneHour; h < kMaxTimeZoneHour; h++) {
        final sign = (h.sign.isNegative) ? -1 : 1;

        if (h >= -12 && h <= 14) {
          for (var m = 0; m < 60; m++) {
            log.debug('sign: $sign, h: $h, m: $m, ');
            if (isValidTimeZone(sign, h, m)) {
              final us0 = timeZoneToMicroseconds(sign, h, m);
              log.debug('  us0: $us0');
              if (us0 != null) {
                final tzm0 = timeZoneMinute(us0);
                log.debug('tzm0: $tzm0');
                expect(tzm0, isNotNull);
              }
            } else {
              final us1 = timeZoneToMicroseconds(sign, h, m);
              if (us1 != null) {
                final tzm1 = timeZoneMinute(us1);
                log.debug('  tzm1: $tzm1');
                expect(tzm1, isNull);
              }
            }
          }
        }
      }
    });

    test('getDcmTimeZoneStringHashIndex', () {
	    for (var i = 1; i < kTZLength; i++) {
	    	final tz = kValidDcmTZStrings[i];
		    final htz = dcmTZStringHash(tz);
		    log.debug('$i TZ: $tz TZHash: $htz');
		    final hIndex = kValidDcmTZStrings.indexOf(htz);
		    expect(hIndex != -1, true);
		    expect(tz != htz, true);
	    }
    });

    test('getDcmTimeZoneStringHashIndex-Random', () {
    	const iterations = 1000;
    	final rng = new Random(0);

	    for (var i = 1; i < iterations; i++) {
	    	final index = rng.nextInt(kTZLength - 1);
		    final tz = kValidDcmTZStrings[index];
		    final htz = dcmTZStringHash(tz);
		    log.debug('$i index: $index TZHash: $htz');
		    final hIndex = kValidDcmTZStrings.indexOf(htz);
		    expect(hIndex != -1, true);
		    expect(tz != htz, true);
	    }
    });

    test('getInetTimeZoneStringHashIndex', () {
	    for (var i = 1; i < kTZLength; i++) {
		    final tz = kValidInetTZStrings[i];
		    final htz = inetTZStringHash(tz);
		    log.debug('$i TZ: $tz TZHash: $htz');
		    final hIndex = kValidInetTZStrings.indexOf(htz);
		    expect(hIndex != -1, true);
		    expect(tz != htz, true);
	    }
    });

    test('getInetTimeZoneStringHashIndex-Random', () {
	    const iterations = 1000;
	    final rng = new Random(0);

	    for (var i = 1; i < iterations; i++) {
		    final index = rng.nextInt(kTZLength - 1);
		    final tz = kValidInetTZStrings[index];
		    final htz = inetTZStringHash(tz);
		    log.debug('$i index: $index TZHash: $htz');
		    final hIndex = kValidInetTZStrings.indexOf(htz);
		    expect(hIndex != -1, true);
		    expect(tz != htz, true);
	    }
    });

    test('getRandomTimeZoneIndex', () {
      for (var i = 1; i <= kValidTZMicroseconds.length; i++) {
        final rtzIndex0 = getRandomTimeZoneIndex();
        log.debug('kValidTZMicroseconds :${kValidTZMicroseconds[rtzIndex0]}');
        expect((0 <= rtzIndex0 && rtzIndex0 <= kValidTZMicroseconds.length), true);
      }
    });

    test('isValidTimeZoneMinutes', () {
      global.throwOnError = false;
      for (var h = kMinTimeZoneHour; h < kMaxTimeZoneHour; h++) {
        final sign = (h.sign.isNegative) ? -1 : 1;

        if (h >= -12 && h <= 14) {
          for (var m = 0; m < 60; m++) {
            log.debug('sign: $sign, h: $h, m: $m, ');
            if (isValidTimeZone(sign, h, m)) {
              final us0 = timeZoneToMicroseconds(sign, h, m);
              log.debug('  us0: $us0');
              if (us0 != null) {
                final vtzm0 = isValidTimeZoneMinutes(us0);
                log.debug(vtzm0);
              }
            } else {
              final us1 = timeZoneToMicroseconds(sign, h, m);
              if (us1 != null) {
                final tzm1 = isValidTimeZoneMinutes(us1);
                log.debug('  tzm1: $tzm1');
                expect(tzm1, isNull);
              }
            }
          }
        }
      }
    });
  });
}
