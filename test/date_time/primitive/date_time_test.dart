// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Binayak Behera <binayak.b@mwebware.com> -
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = new RSG(seed: 1);

void main() {
  Server.initialize(
      name: 'date_time_test', minYear: -1000, maxYear: 3000, level: Level.info);

  test('kMinEpochMicrosecond', () {
    log
      ..debug('minYear: ${system.minYear}')
      ..debug('maxYear: ${system.maxYear}')
      ..debug('kMinEpochMicrosecond: $kMinEpochMicrosecond')
      ..debug('kMaxEpochMicrosecond: $kMaxEpochMicrosecond');
    expect(isValidYear(system.minYear), true);
    expect(isValidYear(system.maxYear), true);
    expect(isValidDateMicroseconds(kMinEpochMicrosecond), true);
    expect(isValidDateMicroseconds(kMaxEpochMicrosecond), true);
  });
  test('dcmDateTimeInMicroseconds', () {
    final dcmDTM0 = dcmDateTimeInMicroseconds(1998, 02, 12, 12, 15, 40, 12, 45);
    log.debug('dcmDTM0: $dcmDTM0');

    final dcmDTM1 =
        dcmDateTimeInMicroseconds(2015, 11, 12, 05, 29, 24, 48, 456);
    log.debug('dcmDTM1: $dcmDTM1');

    final dcmDTM2 =
        dcmDateTimeInMicroseconds(system.minYear, 11, 12, 05, 29, 24, 48, 456);
    log.debug('dcmDTM2: $dcmDTM2');

    final dcmDTM3 =
        dcmDateTimeInMicroseconds(system.maxYear, 11, 12, 05, 29, 24, 48, 456);
    log.debug('dcmDTM3: $dcmDTM3');

    // bad year
    var dcmDTMInvalid = dcmDateTimeInMicroseconds(
        system.minYear - 1, 11, 12, 22, 29, 24, 48, 456);
    expect(dcmDTMInvalid, isNull);

    // bad year
    dcmDTMInvalid = dcmDateTimeInMicroseconds(
        system.maxYear + 1, 1, 12, 22, 29, 24, 48, 456);
    expect(dcmDTMInvalid, isNull);

    // bad month
    dcmDTMInvalid =
        dcmDateTimeInMicroseconds(2017, 13, 12, 22, 29, 24, 48, 456);
    expect(dcmDTMInvalid, isNull);

    // bad day
    dcmDTMInvalid = dcmDateTimeInMicroseconds(2017, 1, 32, 22, 29, 24, 48, 456);
    expect(dcmDTMInvalid, isNull);

    // bad hour
    dcmDTMInvalid = dcmDateTimeInMicroseconds(2017, 1, 2, 25, 29, 24, 48, 456);
    expect(dcmDTMInvalid, isNull);

    // bad minutes
    dcmDTMInvalid = dcmDateTimeInMicroseconds(2017, 1, 2, 23, 65, 24, 48, 456);
    expect(dcmDTMInvalid, isNull);

    // bad seconds
    dcmDTMInvalid = dcmDateTimeInMicroseconds(2017, 1, 2, 25, 29, 61, 48, 456);
    expect(dcmDTMInvalid, isNull);

    // bad milliseconds
    dcmDTMInvalid =
        dcmDateTimeInMicroseconds(2017, 1, 2, 25, 29, 24, 1000, 456);
    expect(dcmDTMInvalid, isNull);

    // bad microseconds
    dcmDTMInvalid = dcmDateTimeInMicroseconds(2017, 1, 2, 25, 29, 24, 48, 1000);
    expect(dcmDTMInvalid, isNull);

    system.throwOnError = true;
    expect(() => dcmDateTimeInMicroseconds(1978, 13, 12, 05, 29, 24, 48, 456),
        throwsA(equals(const isInstanceOf<InvalidDateError>())));

    expect(
        () => dcmDateTimeInMicroseconds(
            system.minYear - 1, 11, 12, 05, 29, 24, 48, 456),
        throwsA(equals(const isInstanceOf<InvalidDateError>())));

    expect(
        () => dcmDateTimeInMicroseconds(
            system.maxYear + 1, 10, 12, 05, 29, 24, 48, 456),
        throwsA(equals(const isInstanceOf<InvalidDateError>())));

    expect(() => dcmDateTimeInMicroseconds(1978, 12, 12, 25, 29, 24, 48, 456),
        throwsA(equals(const isInstanceOf<InvalidTimeError>())));
  });

  test('isValidDateTime', () {
    var validDateTime0 = isValidDateTime(1998, 11, 15, 23, 10, 45, 05, 10);
    expect(validDateTime0, true);

    validDateTime0 =
        isValidDateTime(system.minYear, 11, 15, 23, 10, 45, 05, 10);
    expect(validDateTime0, true);

    validDateTime0 =
        isValidDateTime(system.maxYear, 11, 15, 23, 10, 45, 05, 10);
    expect(validDateTime0, true);

    final validDateTime1 =
        isValidDateTime(1998, 13, 15, 23, 10, 45, 05, 10); //bad month
    expect(validDateTime1, false);

    final validDateTime2 =
        isValidDateTime(1998, 11, 32, 23, 10, 45, 05, 10); //bad day
    expect(validDateTime2, false);

    final validDateTime3 =
        isValidDateTime(1998, 11, 21, 24, 10, 45, 05, 10); //bad hour
    expect(validDateTime3, false);

    final validDateTime4 =
        isValidDateTime(1998, 11, 21, 22, 61, 45, 05, 10); //bad min
    expect(validDateTime4, false);

    final validDateTime5 =
        isValidDateTime(1998, 11, 21, 22, 34, 65, 05, 10); //bad sec
    expect(validDateTime5, false);

    final validDateTime6 =
        isValidDateTime(1998, 11, 21, 22, 34, 39, 1000, 10); //bad ms
    expect(validDateTime6, false);

    final validDateTime7 =
        isValidDateTime(1998, 11, 21, 22, 34, 39, 78, 10001); //bad us
    expect(validDateTime7, false);
  });

  test('hashDateTimeMicroseconds', () {
    final hdtm0 = hashDateTimeMicroseconds(kMicrosecondsPerDay + 1);
    log.debug('hdtm0: $hdtm0');
    expect(hdtm0, isNotNull);

    final hdtm1 = hashDateTimeMicroseconds(0);
    log.debug('hdtm1: $hdtm1');
    expect(hdtm1, isNotNull);

    final hdtm2 = hashDateTimeMicroseconds(4535);
    log.debug('hdtm2: $hdtm2');
    expect(hdtm2, isNotNull);

    final hdtm3 = hashDateTimeMicroseconds(-4535);
    log.debug('hdtm3: $hdtm3');
    expect(hdtm3, isNotNull);
  });

  test('dateTimeToString', () {
    final dt0 = dateTimeToString(1998, 11, 15, 23, 10, 45, 05, 10);
    log.debug(dt0);
    expect(dt0, '19981115231045.005010');

    final dt1 = dateTimeToString(1998, 11, 15, 23, 10, 45, 0, 0);
    log.debug(dt1);
    expect(dt1, '19981115231045.000000');

    final dt2 =
        dateTimeToString(1998, 11, 15, 23, 10, 45, 05, 10, asDicom: false);
    log.debug(dt2);
    expect(dt2, '1998-11-15T23:10:45.005010');
  });

  test('dateTimeMicrosecondsToString', () {
    log
      ..debug('minYear: ${system.minYear} maxYear: ${system.maxYear}')
      ..debug(
          'isValidMicrosecond: ${isValidDateTimeMicroseconds(19790512011556789)}');
    final dtm0 = microsecondToDateTimeString(19790512011556789, asDicom: false);
    log.debug('dtm0: $dtm0');

    final dtm1 = microsecondToDateTimeString(19790512011556789);
    log.debug('dtm1: $dtm1');

    expect(dtm0, isNot(dtm1));
  });

  test('inetDateTime', () {
    for (var y = 1996; y < 2000; y++) {
      for (var m = 1; m < 12; m++) {
        for (var d = 1; d < lastDayOfMonth(y, m); d++) {
          for (var h = 1; h < 24; h++) {
            for (var mm = 1; mm < 60; mm++) {
              final s = 10;
              final ms = 600;
              final us = 600;
              final dt0 = inetDateTime(y, m, d, h, mm, s, ms, us);
              final mx = digits2(m);
              final dx = digits2(d);
              final hx = digits2(h);
              final mmx = digits2(mm);

              log.debug('dt0: $dt0, $y$mx$dx$hx$mmx$s.$ms$us');
              expect(dt0 == '$y$mx$dx$hx$mmx$s.$ms$us', true);
            }
          }
        }
      }
    }

    final dt0 = inetDateTime(1998, 11, 15, 23, 10, 45, 05, 10);
    log.debug(dt0);
    expect(dt0, '19981115231045.005010');

    final dt1 = inetDateTime(1998, 11, 15, 23, 10, 45, 0, 0);
    log.debug(dt1);
    expect(dt1, '19981115231045');

    final dt2 = inetDateTime(1998, 11, 15, 23, 10, 45, 05, 10, asDicom: false);
    log.debug(dt2);
    expect(dt2, '1998-11-15T23:10:45.005010');
  });

  test('dtToDateString', () {
    for (var y = 1996; y < 2000; y++) {
      for (var m = 01; m < 12; m++) {
        for (var d = 01; d < lastDayOfMonth(y, m); d++) {
          final dt0 = new DateTime(y, m, d);
          final yx = digits4(dt0.year);
          final mx = digits2(dt0.month);
          final dx = digits2(dt0.day);
          expect(dtToDateString(dt0), '$yx-$mx-$dx');
        }
      }
    }

    final dt0 = new DateTime(1998, 10, 15);
    expect(dtToDateString(dt0), '1998-10-15');
  });

  test('dtToTimeString', () {
    for (var y = 1999; y < 2000; y++) {
      for (var h = 1; h < 24; h++) {
        for (var m = 1; m < 60; m++) {
          for (var s = 1; s < 59; s++) {
            final ms = 600;
            final us = 600;
            final dt0 = new DateTime(y, h, m, s, ms, us);
            //final yx = digits4(dt0.year);
            final hx = digits2(dt0.hour);
            final mx = digits2(dt0.minute);
            final sx = digits2(dt0.second);
            //final msx = digits3(dt0.millisecond);
            //final usx = digits3(dt0.microsecond);
            log.debug('dt0: $dt0, $hx$mx$sx');
            expect(dtToTimeString(dt0), '$hx$mx$sx');
            expect(dtToTimeString(dt0, asDicom: false), '$hx:$mx:$sx');
          }
        }
      }
    }

    final dt0 = new DateTime(1998, 10, 15, 09, 45, 58);
    expect(dtToTimeString(dt0), '094558');

    final dt1 = new DateTime(1998, 10, 15, 09, 45, 58);
    expect(dtToTimeString(dt1, hasFraction: true, asDicom: true), '094558.000000');

    final dt2 = new DateTime(1998, 10, 15, 09, 45, 58);
    expect(dtToTimeString(dt2, hasFraction: true, asDicom: false), '09:45:58.000000');

    final dt3 = new DateTime(1998, 10, 15, 09, 45, 58);
    expect(dtToTimeString(dt3, asDicom: false), '09:45:58');
  });

  test('dtToDateTimeString', () {
    for (var y = 1999; y < 2000; y++) {
      for (var m = 1; m < 12; m++) {
        for (var d = 1; d < lastDayOfMonth(y, m); d++) {
          for (var h = 1; h < 24; h++) {
            for (var mm = 1; mm < 60; mm++) {
              final s = 10;
              final ms = 600;
              final us = 600;
              final dt0 = new DateTime(y, m, d, h, mm, s, ms, us);
              final mx = digits2(m);
              final dx = digits2(d);
              final hx = digits2(h);
              final mmx = digits2(mm);

              log.debug('dt0: $dt0, $y$mx$dx$hx$mmx$s.$ms$us');
              expect(dtToDateTimeString(dt0), '$y-$mx-$dx\T$hx$mmx$s');
            }
          }
        }
      }
    }
  });
}
