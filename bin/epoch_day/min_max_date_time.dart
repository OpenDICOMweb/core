//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:math';

import 'package:core/server.dart';

final int min63BitInt = -pow(2, 62);
final int max63BitInt = pow(2, 62) - 1;

void main() {
  Server.initialize(name: 'bin/date_time', level: Level.info0);

  assert(min63BitInt == kDartMinSMInt, true);
	assert(max63BitInt == kDartMaxSMInt, true);
	print('        min 63-bit Int: $min63BitInt');
	print('        max 63-bit Int:  $max63BitInt');
	print('        min dart smInt: $kDartMinSMInt');
	print('        max dart smint:  $kDartMaxSMInt');
  print('Min Epoch Microseconds: $kDartMinSMInt');
  print('Max Epoch Microseconds:  $kDartMaxSMInt');

	print('---------');
  const kMinTimeZoneMinute = -12 * 60;
  const kMaxTimeZoneMinute = 14 * 60;
	const kMinTimeZoneMicroseconds = kMinTimeZoneMinutes * kMicrosecondsPerMinute;
	const kMaxTimeZoneMicroseconds = kMaxTimeZoneMinutes * kMicrosecondsPerMinute;
	assert(kMinTimeZoneMinute * kMicrosecondsPerMinute == kMinTimeZoneMicroseconds, true);
	assert(kMaxTimeZoneMinute * kMicrosecondsPerMinute == kMaxTimeZoneMicroseconds, true);
  print('   microseconds per minute: $kMicrosecondsPerMinute');
  print('             min TZ Minute: $kMinTimeZoneMinute');
  print('             max TZ Minute:  $kMaxTimeZoneMinute');
  print('Min Time Zone Microseconds: $kMinTimeZoneMicroseconds');
  print('Max Time Zone Microseconds: $kMaxTimeZoneMicroseconds');

  print('---------');
 /* const minEpochMicrosecondUTC =
      kDartMinSMInt - kMinTimeZoneMicroseconds;*/
  const maxEpochMicrosecondUTC =
      kDartMaxSMInt - kMaxTimeZoneMicroseconds;
	print('    Min Epoch Microseconds: $kAbsoluteMinEpochMicroseconds');
	print('    Max Epoch Microseconds:  $kAbsoluteMaxEpochMicroseconds');
  print('Min Epoch Microseconds UTC: $kAbsoluteMinEpochMicrosecondsUTC');
  print('Max Epoch microseconds UTC:  $kAbsoluteMaxEpochMicrosecondsUTC');

	const minDiff = kAbsoluteMinEpochMicrosecondsUTC - kAbsoluteMinEpochMicroseconds;
	print('minDiff: $minDiff $kMinTimeZoneMicroseconds');
	const maxDiff = kAbsoluteMaxEpochMicroseconds - kAbsoluteMaxEpochMicrosecondsUTC;
	print('maxDiff: +$maxDiff +$kMaxTimeZoneMicroseconds');
	assert(kAbsoluteMinEpochMicrosecondsUTC - kAbsoluteMinEpochMicroseconds ==
  kMinTimeZoneMicroseconds);
	assert(kAbsoluteMaxEpochMicroseconds - kAbsoluteMaxEpochMicrosecondsUTC ==
  kMaxTimeZoneMicroseconds);
	assert(kMinTimeZoneMicroseconds == minDiff, true);
	assert(kMaxTimeZoneMicroseconds == maxDiff, true);

	print('---------');
	const minEpochDayLimit = kAbsoluteMinEpochMicroseconds ~/ kMicrosecondsPerDay;
	const maxEpochDayLimit = kAbsoluteMaxEpochMicroseconds ~/ kMicrosecondsPerDay;
	const minEpochUTCDayLimit = kAbsoluteMinEpochMicrosecondsUTC ~/kMicrosecondsPerDay;
	const maxEpochUTCDayLimit = maxEpochMicrosecondUTC~/kMicrosecondsPerDay;
	print('             us per day: $kMicrosecondsPerDay');
  print('      kMinEpochDayLimit: $kAbsoluteMinEpochDay');
  print('      kMaxEpochDayLimit: $kAbsoluteMaxEpochDay');
  print('Min Epoch UTC Day Limit: $minEpochUTCDayLimit');
  print('Max Epoch UTC Day Limit: $maxEpochUTCDayLimit');

//  print('Min Epoch Day UTC: $minEpochDayUTC');
//  print('Max Epoch Day UTC: $maxEpochDayUTC');


 // List<int> minDate = internalEpochDayToDate(minEpochDays);
 // List<int> maxDate = internalEpochDayToDate(maxEpochDays);

  final minDate = microsecondToDateString(kMinEpochMicrosecond);
  final maxDate = microsecondToDateString(kMaxEpochMicrosecond);
  print('min Epoch date: $minDate');
  print('max Epoch date: $maxDate');

  const epochMicrosecondFor00000301 =
		  kEpochDayFor00000301 * kMicrosecondsPerDay;
  print('  Epoch us for 0000-03-01: $epochMicrosecondFor00000301');
  print('Epoch days for 0000-03-01: $kEpochDayFor00000301');
  assert((epochMicrosecondFor00000301 ~/ kMicrosecondsPerDay) ==
         kEpochDayFor00000301);
  final zeroDayAD = dateToEpochDay(0, 3, 1);
  final zeroMicrosecondUTC = zeroDayAD * kMicrosecondsPerDay;
  print('zeroAD: $zeroDayAD');
  final zeroADDate = microsecondToDateString(zeroMicrosecondUTC);

	final acrBaseline = dateToEpochMicroseconds(1960, 1, 1);
  print('acrBaselineDate: $acrBaseline');

  final out = '''
                 Min dart SMIint: $kDartMinSMInt
                 Max dart SMIint:  $kDartMaxSMInt
 Min Epoch microseconds with TZM: $kMinEpochMicrosecond
 Max Epoch microseconds with TZM:  $kMaxEpochMicrosecond
            Min Time Zone Minute: $kMinTimeZoneMinute
            Max Time Zone Minute: $kMaxTimeZoneMinute
                   Min TZM in us: $kMinTimeZoneMicroseconds
                   Max TZM in us:  $kMaxTimeZoneMicroseconds
      Min Epoch microseconds UTC: $kAbsoluteMinEpochMicrosecondsUTC
      Max Epoch microseconds UTC:  $maxEpochMicrosecondUTC
             Min Epoch Day Limit: $minEpochDayLimit
             Max Epoch Day Limit:  $maxEpochDayLimit
               Min Epoch Day UTC: $minEpochUTCDayLimit
               Max Epoch Day UTC:  $maxEpochUTCDayLimit
                  Min Epoch date: $minDate
                  Max Epoch date:  $maxDate
                  
         Epoch us for 0000-03-01: $epochMicrosecondFor00000301
       Epoch days for 0000-03-01: $kEpochDayFor00000301
                     Zero Day AD: $zeroDayAD
             Zero Microsecond AD: $zeroMicrosecondUTC                     
                    Zero AD Date: "$zeroADDate"
               ACR Baseline Date: $acrBaseline
  ''';
  print(out);
}
