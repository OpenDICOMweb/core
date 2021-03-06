// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'last_day_of_month', level: Level.info);

  group('epochTest', () {
    test('Test for epochDay', () {
      final startDay = -1;
      final endDay = 1;

      //     int y = 1970;
      for (var i = 1; i <= 24; i++) {
        //      int mp = (i + 9) % 12;
        //      log.debug('m: $i, mp: $mp');
        //      int yp = y - (mp ~/ 10);
        //      log.debug('yp: $yp');
      }
      for (var i = startDay; i <= endDay; i++) {
        final dayZero = dateToEpochDay(1970, 1, 1);
        if (dayZero != 0) throw new DateError('Day Zero error: $dayZero');
        final dayMinusOne = dateToEpochDay(1969, 12, 31);
        if (dayMinusOne != -1) throw new DateError('Day MinusOne error: $dayZero');
        final dayPlusOne = dateToEpochDay(1970, 1, 1);
        if (dayPlusOne != 0) throw new DateError('Day PlusOne error: $dayZero');
      }
      //    log.debug('Success');
    });

    test('Test for weekDayFromDay', () {
      //    log.debug('v: ${(-10 + 5) % 7}');
      //    log.debug('v: ${(-10 + 5) % 7}');
      for (var eDay = -10000; eDay < 10000; eDay++) {
        final wd = weekdayFromEpochDay(eDay);
        //     log.debug('$eDay: weekDay: $wd');
        if (wd < 0 || wd > 6) throw new DateError('bad weekday: $wd');
      }
    });

    test('Test for lastDayOfMonth', () {
      for (var y = 1950; y < 2020; y++) {
        for (var m = 1; m <= 12; m++) {
          final last = lastDayOfMonth(y, m);
          log.debug('$y: $m: last: $last');
          if(isLeapYear(y) && m == 2) {
            expect(last == daysInLeapYearMonth[m], true);
          }else{
            expect(last == daysInCommonYearMonth[m], true);
          }
        }
      }
    });
  });
}

/// An invalid [DateTime] [Error].
class DateError extends Error {
	String msg;

	DateError(this.msg);

	@override
	String toString() => msg;
}

