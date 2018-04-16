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
  Server.initialize(name: 'uid2_test', level: Level.info);

  const goodUids = const <String>[
    '0.20.3000',
    '1.20.3000',
    '2.20.3000',
    '0.3.0.812345',
    '1.2.840.10008.1.2.4.58',
    '1.2.840.10008.1.2.4.61'
  ];

  group('Good Uids Test', () {
    test('Good UID', () {
      for (var s in goodUids) {
        final v = Uid.isValidString(s);
        log.debug('$v: $s');
        expect(Uid.isValidString(s), true);
      }
    });
  });

  const badUids = const <String>[
    // Bad root
    '3.20.3000',
    // Bad root
    '4.A0.3000',
    // '.0' must be followed by '.'
    '2.01.3000',
    // Invalid char 'g
    '0.A0.0.abcdeg',
    // Invalid char '_'
    '2.C0.-bcdef',
    // Can't end in '.'
    '1.B0.abcde.',
    // length too short
    '1.25',
    // Length too long
    '1.25.111111111111111111111111111111111111111111111111111111111111111111111'
  ];

  group('Bad Uids Test', () {
    test('Bad UID', () {
      for (var s in badUids) {
        log.debug('"$s":');
        final v = Uid.isValidString(s);
        log.debug('"$s": $v');
        expect(Uid.isValidString(s), false);
      }
    });
  });
}
