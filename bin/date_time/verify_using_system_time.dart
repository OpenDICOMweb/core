// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';

void main() {
  Server.initialize();

  final dt0 = new DateTime(1999, 03, 14, 01, 59, 00);
  print('dt0: $dt0');
  final dt1 = new DateTime(1999, 03, 14, 02, 00, 00);
  print('dt1: $dt1');
  final dt2 = new DateTime(1999, 03, 14, 02, 01, 00);
  print('dt2: $dt2');
  for (var h = 1; h < 24; h++) {
    for (var m = 0; m < 60; m++) {
      final dt3 = new DateTime(1999, 03, 14, h, m, 00);
      print('$dt3');
    }
  }
  print('dt2: $dt2');
//  checkSystemTime0();
//  checkSystemTime2();
}

void checkSystemTime0() {
  final dt = new DateTime.now();
  print('dt: $dt');
  final sysUSecs = dt.microsecondsSinceEpoch;
  print('sysUSecs:       $sysUSecs');

  final odwUSecs = dcmDateTimeInMicroseconds(dt.year, dt.month, dt.day, dt.hour,
      dt.minute, dt.second, dt.millisecond, dt.microsecond);
  print('odwUSecs:       $odwUSecs');

  final odwDateInUsecs = dateToEpochMicroseconds(dt.year, dt.month, dt.day);
  print('odwDateInUsecs: $odwDateInUsecs');

  final systemEpochDay = sysUSecs ~/ kMicrosecondsPerDay;
  print('systemEpochDay: $systemEpochDay');

  final odwEpochDay = dateToEpochDay(dt.year, dt.month, dt.day);
  print('odwEpochDay:    $odwEpochDay');

  final maxTimeInUS = 24 * 60 * 60 * 1000000;
  print('maxTimeinUS:    $maxTimeInUS');
  print('us/day:         $kMicrosecondsPerDay');

  final odwTimeInUsecs = timeToMicroseconds(
      dt.hour, dt.minute, dt.second, dt.millisecond, dt.microsecond);
  print('odwTimeInUsecs: $odwTimeInUsecs');

  final datePlusTime = odwDateInUsecs + odwTimeInUsecs;
  print('datePlusTime:   $datePlusTime');
}

void checkSystemTime1() {
  for (var y = 1999; y < 2000; y++) {
    for (var m = 1; m <= 12; m++) {
      for (var d = 1; d <= lastDayOfMonth(y, m); d++) {
        for (var h = 0; h < 24; h++) {
          for (var mm = 0; mm < 60; mm++) {
            for (var s = 0; s < 60; s++) {
              for (var ms = 0; ms <= 999; ms++) {
                for (var us = 0; us <= 999; us++) {
                  final dt = new DateTime(y, m, d, h, mm, s, ms, us);
                  final dt0 = dt.toString();
                  final dt1 = time(y, m, d, h, mm, s, ms, us);
                  //        log.debug('dt0: $dt0\ndt1: $dt1');
                  if (dt0 != dt1) print('>  $dt0\n   $dt1');
                  assert(dt0 == dt1);
                }
              }
            }
          }
        }
        print('    day: $m');
      }
      print('  month: $m');
    }
    print('year: $y');
  }
}

void checkSystemTime2() {
  for (var y = 1999; y < 2000; y++) {
    for (var m = 1; m <= 12; m++) {
      for (var d = 1; d <= lastDayOfMonth(y, m); d++) {
        for (var h = 0; h < 24; h++) {
          for (var mm = 0; mm < 60; mm++) {
            for (var s = 0; s < 60; s++) {
              final dt = new DateTime(y, m, d, h, mm, s, 0, 0);
              final dt0 = dt.toString();
              final dt1 = time(y, m, d, h, mm, s, 0, 0);
              //        log.debug('dt0: $dt0\ndt1: $dt1');
              if (dt0 != dt1) print('>  $dt0\n   $dt1');
              assert(dt0 == dt1);
            }
          }
        }
        print('    day: $m');
      }
      print('  month: $m');
    }
    print('year: $y');
  }
}

String time(int y, int m, int d, int h, int mm, int s, int ms, int us) {
  final yx = digits4(y);
  final mx = digits2(m);
  final dx = digits2(d);
  final hx = digits2(h);
  final mmx = digits2(mm);
  final sx = digits2(s);
  final msx = digits3(ms);

  if (us == 0) return '$yx-$mx-$dx $hx:$mmx:$sx.$msx';

  final usx = digits3(us);
  return '$yx-$mx-$dx $hx:$mmx:$sx.$msx$usx';
}
