//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/server.dart';

//final int min64BitInt = -pow(2, 63);
//final int kMax64BitInt = pow(2, 63) - 1;
const int kMin64BitInt = 0x8000000000000000;
const int kMax64BitInt = 0x7FFFFFFFFFFFFFFF;

void main() {
  Server.initialize(name: 'bin/date_time', level: Level.info0);

  print('min 64-bit Int: $kMin64BitInt');
  print('max 64-bit Int: $kMax64BitInt');
//  print('min dart smInt: $dartMinSMInt');
//  print('max dart smint: $dartMaxSMInt');

  print('us per day: $kMicrosecondsPerDay');
  const minDays = kMin64BitInt ~/ kMicrosecondsPerDay;
  const maxDays = kMax64BitInt ~/ kMicrosecondsPerDay;

  print('Min days: $minDays');
  print('Max days: $maxDays');

  print('Min years: ${minDays ~/ 366}');
  print('Max years: ${maxDays ~/ 366}');

  final minDate = Date.fromEpochDay(minDays);
  final maxDate = Date.fromEpochDay(maxDays);
  print('min date: $minDate');
  print('max date: $maxDate');
}
