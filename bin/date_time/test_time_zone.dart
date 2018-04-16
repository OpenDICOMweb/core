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
  Server.initialize(name: 'bin/test_time_zone', level: Level.info0);

  for (var i = 0; i < goodTimeZones.length; i++) {
    final s = goodTimeZones[i];
    final tz = TimeZone.parse(s);
    log
      ..debug('Good parseTimeZone: "$s"')
      ..debug('  tzm: $tz, ${goodTimeZonesValues[i]}');
    final valid = TimeZone.isValidString(s);
    log.debug('  isValid: $valid');
    final issues = new Issues('parseTimeZone: "$s"');
    TimeZone.parse(s, issues: issues);
    log.debug('  Issues: "$issues"');
  }

  for (var i = 0; i < badTimeZones.length; i++) {
    final s = badTimeZones[i];
    final tz = TimeZone.parse(s);
    log..debug('Bad parseTimeZone: "g$s"')
    ..debug('  tzm: $tz');
    final valid = TimeZone.isValidString(s);
    log.debug('  isValid: $valid, valid==$valid');
    final issues = new Issues('parseTimeZone: "$s"');
    TimeZone.parse(s, issues: issues);
    log.debug('  Issues: "$issues"');
  }
  // timeZoneTest();
}

const List<String> goodTimeZones = const <String>[
  '+0000', '+0100', '-0100', '+0130', '-0145', '-1200', '+1400' // no fmt
];

const List<int> goodTimeZonesValues = const <int>[
  0, 60, -60, 90, -105, -12 * 60, 14 * 60 // no fmt
];

const List<String> badTimeZones = const <String>[
  '-0000', // not valid UTC
  '-1300', // hour out of range
  '+1500', // hour out of range
  '-a000', // bad char
  '-0b00', // bad char
  '-00C0', // bad char
  '-000*', // bad char
  '*0a00', // bad char
  '+0131', // bad minute
  '-0115' // bad minute
];

void timeZoneTest() {
  group('DCM Time Zone tests', () {
    test('Good parseTimeZone', () {
      for (var s in goodTimeZones) {
        final tz = TimeZone.parse(s);
        log.debug('Good parseTimeZone: "$s", tzm: $tz');
        expect(tz, isNotNull);
        expect(TimeZone.isValidString(s), true);
        final issues = new Issues('parseTimeZone: "$s"');
        TimeZone.parse(s, issues: issues);
        log.debug('Issues: $issues');
        expect(issues, equals(''));
      }
    });
  });
}
