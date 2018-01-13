// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';

import 'data.dart';

//TODO: generalize this package to use: uuid_pseudo, uuid_secure, uuid_w_seed

void main() {
  Server.initialize(name: 'uuid_v4_test', level: Level.info);

  group('Version 4 Tests', () {
    test('Check if V4 is consistent using a seed', () {
      final uuid0 = new Uuid.seededPseudo();
      log..debug('uuid0: $uuid0')..debug('data0: $data0');

      expect(uuid0.data.length, equals(16));
      expect(uuid0, equals(uuidD0));
      expect(uuid0, equals(uuidS0));
    });

    test('Test Uuid.fromBytes', () {
      const data0 = const <int>[
        0x10, 0x91, 0x56, 0xbe, 0xc4, 0xfb, 0xc1, 0xea,
        0x71, 0xb4, 0xef, 0xe1, 0x67, 0x1c, 0x58, 0x36 // No Reformat
      ];
      const string0 = '109156be-c4fb-41ea-b1b4-efe1671c5836';

      log.debug('data0: $data0');
      final uuid0 = new Uuid.fromList(data0, coerce: true);

      log..debug('  uuid0: $uuid0')..debug('string0: $string0');
      expect(uuid0.toString(), equals(string0));
    });

    test('Make sure that really fast uuid.v4 doesn\'t produce duplicates', () {
      final list = new List.filled(1000, null).map((something) => new Uuid()).toList();
      final setList = list.toSet();
      log.debug('setList:$setList');
      expect(list.length, equals(setList.length));
    });
  });

  group('[Parse/Unparse Tests]', () {
    test('Parsing a UUID', () {
      // Note: s0 and s1 are different at position 14.
      final s0 = '00112233-4455-6677-8899-aabbccddeeff';
      final s1 = '00112233-4455-4677-8899-aabbccddeeff';
      //           --------------^---------------------

      final uuid = Uuid.parse(s0, onError: (id) => null);
      log..debug('  s0: $s0')..debug('uuid: ${uuid.asString}')..debug('  s1: $s1');
      expect(uuid.toString(), equals(s1));
    });
  });
}
