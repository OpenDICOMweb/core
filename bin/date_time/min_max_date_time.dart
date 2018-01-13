// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:math';

import 'package:core/server.dart';

final int min63BitInt = -pow(2, 62);
final int max63BitInt = pow(2, 62) - 1;
const int dartMinSMInt = -4611686018427387904;
const int dartMaxSMInt = 4611686018427387903;

void main() {
  Server.initialize(name: 'bin/date_time', level: Level.info0);

  print('min 63-bit Int: $min63BitInt');
  print('max 63-bit Int: $max63BitInt');
  print('min dart smInt: $dartMinSMInt');
  print('max dart smint: $dartMaxSMInt');

  print('us per day: $kMicrosecondsPerDay');
  const minDays = dartMinSMInt ~/ kMicrosecondsPerDay;
  const maxDays = dartMaxSMInt ~/ kMicrosecondsPerDay;

  print('Min days: $minDays');
  print('Max days: $maxDays');

  print('Min years: ${minDays ~/ 366}');
  print('Max years: ${maxDays ~/ 366}');

  final minDate = new Date.fromEpochDay(minDays);
  final maxDate = new Date.fromEpochDay(maxDays);
  print('min date: $minDate');
  print('max date: $maxDate');
}
