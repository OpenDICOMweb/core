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

void main() {
  Server.initialize(name: 'time_zone_test', level: Level.info);

  const List inValidTimeZoneStrings = <String>[
    '-1230',
    '-1140',
    '-1030',
    '-80930',
    '-0945',
    '-0A45',
    '+010F',
    '+3200',
    '+0310',
    '+03308',
    '+0',
    '+30',
    '+500',
    '+1445',
    '+1430'
  ];

  const inValidInternetTimeZoneStrings = <String>[
    '-12:30',
    '-11:40',
    '-10:30',
    '-80:930',
    '-09:45',
    '-0A:45',
    '+01:0F',
    '+32:00',
    '+03:10',
    '+03:308',
    '+0',
    '+3:0',
    '+50:0',
    '+14:45',
    '+14:30'
  ];

  const List validTimeZones = <List>[
    // [ index, hour, minute, microsecond, token ]
    <Object>[-1, -12, 0, -43200000000, 'Y'],
    <Object>[-1, -11, 0, -39600000000, 'X'],
    <Object>[-1, -10, 0, -36000000000, 'W'],
    <Object>[-1, -9, 30, -34200000000, 'V'],
    <Object>[-1, -9, 0, -32400000000, 'V'],
    <Object>[-1, -8, 0, -28800000000, 'U'],
    <Object>[-1, -7, 0, -25200000000, 'T'],
    <Object>[-1, -6, 0, -21600000000, 'S'],
    <Object>[-1, -5, 0, -18000000000, 'R'],
    <Object>[-1, -4, 0, -14400000000, 'Q'],
    <Object>[-1, -3, 30, -12600000000, 'P'],
    <Object>[-1, -3, 0, -10800000000, 'P'],
    <Object>[-1, -2, 0, -7200000000, 'O'],
    <Object>[-1, -1, 0, -3600000000, 'N'],
    <Object>[1, 0, 0, 0, 'Z'],
    <Object>[1, 1, 0, 3600000000, 'A'],
    <Object>[1, 2, 0, 7200000000, 'B'],
    <Object>[1, 3, 0, 10800000000, 'C'],
    <Object>[1, 3, 30, 12600000000, 'C'],
    <Object>[1, 4, 0, 14400000000, 'D'],
    <Object>[1, 4, 30, 16200000000, 'D'],
    <Object>[1, 5, 0, 18000000000, 'E'],
    <Object>[1, 5, 30, 19800000000, 'E'],
    <Object>[1, 5, 45, 20700000000, 'E'],
    <Object>[1, 6, 0, 21600000000, 'F'],
    <Object>[1, 6, 30, 23400000000, 'F'],
    <Object>[1, 7, 0, 25200000000, 'G'],
    <Object>[1, 8, 0, 28800000000, 'H'],
    <Object>[1, 8, 30, 30600000000, 'H'],
    <Object>[1, 8, 45, 31500000000, 'H'],
    <Object>[1, 9, 0, 32400000000, 'I'],
    <Object>[1, 9, 30, 34200000000, 'I'],
    <Object>[1, 10, 0, 36000000000, 'K'],
    <Object>[1, 10, 30, 37800000000, 'K'],
    <Object>[1, 11, 0, 39600000000, 'L'],
    <Object>[1, 12, 0, 43200000000, 'M'],
    <Object>[1, 12, 45, 45900000000, 'M'],
    <Object>[1, 13, 0, 46800000000, 'M'],
    <Object>[1, 14, 0, 50400000000, 'M']
  ];

  const List invalidTimeZones = <List<int>>[
    <int>[-1, -13, 00],
    <int>[-1, -12, 30],
    <int>[-1, -11, 45],
    <int>[-1, -10, 30],
    <int>[-1, -9, 130],
    <int>[-1, -9, 10],
    <int>[-1, -8, 1],
    <int>[-1, -7, -10],
    <int>[1, 1, 10],
    <int>[1, 2, 30],
    <int>[1, 3, -30],
    <int>[1, 3, 130],
    <int>[1, 14, 45],
    <int>[1, 15, 00],
  ];

  group('Test for TimeZone', () {
    test('isValidString', () {
      for (final s in kValidDcmTZStrings) {
        final tz = TimeZone.isValidString(s);
        expect(tz, true);
      }

      for (final s in inValidTimeZoneStrings) {
        final tz = TimeZone.isValidString(s);
        expect(tz, false);
      }
    });

    test('TimeZone', () {
      for (final i in validTimeZones) {
        final tz = TimeZone(i[0], i[1], i[2]);
        expect(tz, isNotNull);
      }

      for (final i in invalidTimeZones) {
        global.throwOnError = false;
        log.debug('throwOnError: $throwOnError');
        final tz = TimeZone(i[0], i[1], i[2]);
        expect(tz, isNull);

        global.throwOnError = true;
        log.debug('throwOnError: $throwOnError');
        expect(() => TimeZone(i[0], i[1], i[2]),
            throwsA(equals(const TypeMatcher<InvalidTimeZoneError>())));
      }
    });

    test('parse', () {
      for (final s in kValidDcmTZStrings) {
        final tz = TimeZone.parse(s);
        expect(tz, isNotNull);
      }

      for (final s in inValidTimeZoneStrings) {
        global.throwOnError = false;
        log.debug('throwOnError: $throwOnError');
        final tz = TimeZone.parse(s);
        expect(tz, isNull);

        global.throwOnError = true;
        log.debug('throwOnError: $throwOnError');
        expect(() => TimeZone.parse(s),
            throwsA(equals(const TypeMatcher<StringError>())));
      }
    });

    test('dcm', () {
      for (var i = 1; i < validTimeZones.length; i++) {
        final tz0 = TimeZone(
            validTimeZones[i][0], validTimeZones[i][1], validTimeZones[i][2]);
        log.debug('tz0.dcm:${tz0.dcm}, h: ${tz0.h},${tz0.m}');
        expect(tz0.dcm, isNotNull);
      }
    });

    test('hash', () {
      for (var i = 1; i < validTimeZones.length; i++) {
        final tz0 = TimeZone(
            validTimeZones[i][0], validTimeZones[i][1], validTimeZones[i][2]);
        log.debug('tz0: $tz0');
        final hash0 = tz0.hash;
        log.debug('hash0: $hash0');
        expect(hash0, isNotNull);
      }
    });

    test('issue', () {
      for (final s in kValidDcmTZStrings) {
        final issues = TimeZone.issues(s, start: 0);
        expect(issues.isEmpty, true);
      }

      for (final s in inValidTimeZoneStrings) {
        global.throwOnError = false;
        log..debug('s: $s')..debug('throwOnError: $throwOnError');
        final issues = TimeZone.issues(s, start: 0);
        log.debug('issues: "$issues"');
        expect(issues.isEmpty, false);

        global.throwOnError = true;
        log.debug('throwOnError: $throwOnError');
        expect(() => TimeZone.issues(s, start: 0),
            throwsA(equals(const TypeMatcher<StringError>())));
      }
    });

    test('inet', () {
      for (var i = 0; i < kValidDcmTZStrings.length; i++) {
        final tz0 = TimeZone.parse(kValidDcmTZStrings[i]);
        log.debug('tz0.inet:${tz0.inet}, h: ${tz0.h},m: ${tz0.m}');
        expect(tz0.inet, kValidInetTZStrings[i]);
      }

      for (var i = 1; i < validTimeZones.length; i++) {
        final tz0 = TimeZone(
            validTimeZones[i][0], validTimeZones[i][1], validTimeZones[i][2]);
        log.debug('tz0.inet:${tz0.inet}, h: ${tz0.h},m: ${tz0.m}');
        expect(tz0.inet, kValidInetTZStrings[i]);
      }
    });

    test('timeZoneToMicroseconds', () {
      for (final i in validTimeZones) {
        final tz = timeZoneToMicroseconds(i[0], i[1], i[2]);
        expect(tz, isNotNull);
      }

      for (final i in invalidTimeZones) {
        global.throwOnError = false;
        log.debug('throwOnError: $throwOnError');
        final tz = timeZoneToMicroseconds(i[0], i[1], i[2]);
        expect(tz, isNull);

        global.throwOnError = true;
        log.debug('throwOnError: $throwOnError');
        expect(() => timeZoneToMicroseconds(i[0], i[1], i[2]),
            throwsA(equals(const TypeMatcher<InvalidTimeZoneError>())));
      }
    });

    test('hashString', () {
      for (final s in kValidDcmTZStrings) {
        final hs0 = TimeZone.hashString(s);
        log.debug('hs0: $hs0');
        expect(hs0, isNotNull);
      }

      for (final s in inValidTimeZoneStrings) {
        global.throwOnError = false;
        log.debug('throwOnError: $throwOnError');
        final hs0 = TimeZone.hashString(s);
        log.debug('hs0: $hs0');
        expect(hs0, isNull);

        global.throwOnError = true;
        log.debug('throwOnError: $throwOnError');
        expect(TimeZone.hashString(s), isNull);
      }
    });

    test('==', () {
      for (final s in kValidDcmTZStrings) {
        final t0 = TimeZone.parse(s);
        final t1 = TimeZone.parse(s);
        log
          ..debug('t0.values:${t0.toString()}')
          ..debug('t1.values:${t1.toString()}');
        expect(t0 == t1, true);
      }

      final t2 = TimeZone.parse(kValidDcmTZStrings[0]);
      final t3 = TimeZone.parse(kValidDcmTZStrings[1]);
      log
        ..debug('t2.values:${t2.toString()}')
        ..debug('t3.values:${t3.toString()}');
      expect(t2 == t3, false);
    });

    test('hash', () {
      for (final s in kValidDcmTZStrings) {
        log.debug('TZ: $s');
        final t0 = TimeZone.parse(s);
        final t1 = TimeZone.parse(s);
        log
          ..debug('t0.values:${t0.toString()}, t0.hash:${t0.hash}')
          ..debug('t1.values:${t1.toString()}, t1.hash:${t1.hash}');
        expect(t0.hash, equals(t1.hash));
      }
      final t2 = TimeZone.parse(kValidDcmTZStrings[0]);
      final t3 = TimeZone.parse(kValidDcmTZStrings[1]);
      log
        ..debug('t2.values:${t2.toString()}, t2.hash:${t2.hash}')
        ..debug('t3.values:${t3.toString()}, t3.hash:${t3.hash}');

      expect(t2.hash, isNot(t3.hash));
    }); //, skip:'InvalidTimeZoneStringError');

    test('hashCode', () {
      for (final s in kValidDcmTZStrings) {
        final t0 = TimeZone.parse(s);
        final t1 = TimeZone.parse(s);
        log
          ..debug('t0.values:${t0.toString()}, t0.hash:${t0.hashCode}')
          ..debug('t1.values:${t1.toString()}, t1.hash:${t1.hashCode}');

        expect(t0.hashCode, equals(t1.hashCode));
      }

      final t2 = TimeZone.parse(kValidDcmTZStrings[0]);
      final t3 = TimeZone.parse(kValidDcmTZStrings[1]);
      log
        ..debug('t2.values:${t2.toString()}, t2.hash:${t2.hashCode}')
        ..debug('t3.values:${t3.toString()}, t3.hash:${t3.hashCode}');
      expect(t2.hashCode, isNot(t3.hashCode));
    });

    test('microsecondsToTimeZone', () {
      for (var h = kMinTimeZoneHour; h < kMaxTimeZoneHour; h++) {
        final sign = (h.sign.isNegative) ? -1 : 1;

        if (h >= -12 && h <= 14) {
          for (var m = 0; m < 60; m++) {
            global.throwOnError = false;
            if (isValidTimeZone(sign, h, m)) {
              final us0 = timeZoneToMicroseconds(sign, h, m);
              final tzus = TimeZone.microsecondsToTimeZone(us0);
              log.debug('us0: $us0, tzus: ${tzus.toString()}');

              expect(kValidInetTZStrings.contains(tzus.toString()), true);
            }
          }
        }
      }
    });

    test('>', () {
      for (var i = 0; i < kValidInetTZStrings.length; i++) {
        if (i + 1 < kValidInetTZStrings.length) {
          final tz1 = TimeZone.parseInternet(kValidInetTZStrings[i]);
          final tz2 = TimeZone.parseInternet(kValidInetTZStrings[i + 1]);

          expect(tz2 > tz1, true);
        }
      }
    });

    test('<', () {
      for (var i = 0; i < kValidInetTZStrings.length; i++) {
        if (i + 1 < kValidInetTZStrings.length) {
          final tz1 = TimeZone.parseInternet(kValidInetTZStrings[i]);
          final tz2 = TimeZone.parseInternet(kValidInetTZStrings[i + 1]);

          expect(tz1 < tz2, true);
        }
      }
    });

    test('compareTo', () {
      for (var i = 0; i < kValidInetTZStrings.length; i++) {
        if (i + 1 < kValidInetTZStrings.length) {
          final tz1 = TimeZone.parseInternet(kValidInetTZStrings[i]);
          final tz2 = TimeZone.parseInternet(kValidInetTZStrings[i + 1]);

          expect(tz1.compareTo(tz2) == -1, true); // tz1 < tz2
          expect(tz2.compareTo(tz1) == 1, true); // tz2 > tz1
          expect(tz1.compareTo(tz1) == 0, true); // tz1 == tz1
        }
      }
    });

    test('parseDicom', () {
      for (var i = 0; i < kValidDcmTZStrings.length; i++) {
        final tz0 = TimeZone.parseDicom(kValidDcmTZStrings[i]);
        expect(tz0, isNotNull);
      }

      for (final invalid in inValidTimeZoneStrings) {
        global.throwOnError = false;
        final tz1 = TimeZone.parseDicom(invalid);
        expect(tz1, isNull);

        global.throwOnError = true;
        expect(() => TimeZone.parseDicom(invalid),
            throwsA(equals(const TypeMatcher<StringError>())));
      }
    });

    test('isValidDcmString', () {
      for (final s in kValidDcmTZStrings) {
        final tz = TimeZone.isValidDcmString(s);
        expect(tz, true);
      }

      for (final s in inValidTimeZoneStrings) {
        final tz = TimeZone.isValidDcmString(s);
        expect(tz, false);
      }
    });

    test('isValidInternetString', () {
      for (final s in kValidInetTZStrings) {
        final tz = TimeZone.isValidInternetString(s);
        expect(tz, true);
      }

      for (final s in inValidInternetTimeZoneStrings) {
        final tz = TimeZone.isValidInternetString(s);
        expect(tz, false);
      }
    });

    test('isValidInternetTimeZoneString', () {
      for (final s in kValidInetTZStrings) {
        final tz = isValidInternetTimeZoneString(s);
        expect(tz, true);
      }

      for (final s in inValidInternetTimeZoneStrings) {
        final tz = isValidInternetTimeZoneString(s);
        expect(tz, false);
      }
    });

    test('isValidTimeZoneString', () {
      for (final s in kValidDcmTZStrings) {
        final tz = isValidTimeZoneString(s);
        expect(tz, true);
      }

      for (final s in kValidInetTZStrings) {
        final tz = isValidTimeZoneString(s, asDicom: false);
        expect(tz, true);
      }

      for (final s in inValidInternetTimeZoneStrings) {
        final tz = isValidTimeZoneString(s);
        expect(tz, false);
      }

      for (final s in inValidInternetTimeZoneStrings) {
        final tz = isValidTimeZoneString(s, asDicom: false);
        expect(tz, false);
      }
    });

    test('isValidDcmTimeZoneString', () {
      for (final s in kValidDcmTZStrings) {
        final tz = isValidDcmTimeZoneString(s);
        expect(tz, true);
      }

      for (final s in inValidInternetTimeZoneStrings) {
        final tz = isValidDcmTimeZoneString(s);
        expect(tz, false);
      }
    });

    test('parseInternetTimeZone', () {
      var i = 0;
      for (final s in kValidInetTZStrings) {
        final tz = parseInternetTimeZone(s);
        expect(tz, equals(kValidTZMicroseconds[i]));
        i++;
      }

      for (final s in inValidInternetTimeZoneStrings) {
        global.throwOnError = false;
        final tz = parseInternetTimeZone(s);
        expect(tz, isNull);

        global.throwOnError = true;
        expect(() => parseInternetTimeZone(s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('parseDcmTimeZone', () {
      var i = 0;
      for (final s in kValidDcmTZStrings) {
        final tz = parseDcmTimeZone(s);
        expect(tz, equals(kValidTZMicroseconds[i]));
        i++;
      }

      for (final s in inValidInternetTimeZoneStrings) {
        global.throwOnError = false;
        final tz = parseDcmTimeZone(s);
        expect(tz, null);

        global.throwOnError = true;
        expect(() => parseDcmTimeZone(s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });
  });
}
