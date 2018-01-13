// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

import 'data.dart';

const String uuidV1 = '23d57c30-afe7-11e4-ab7d-12e3f512a338';
const String uuidV4 = '09bb1d8c-4965-4788-94f7-31b151eaba4e';

const List<int> uuidList = const <int>[
  149, 236, 195, 128, 175, 233, 17, 228, // No reformat
  155, 108, 117, 27, 102, 221, 84, 30
];

final Uint8List uuidBytes = new Uint8List.fromList(uuidList);

void main() {
  Server.initialize(name: 'uuid_string_test', level: Level.info0);
  group('Uuid Tests', () {
    // The data in this test is in data.dart
    test('Uuid Test with seed', () {
      log.debug('seed: ${Uuid.seed}');
      final uuid0 = new Uuid.seededPseudo();
      log.debug('Uuid: $uuid0');
      expect(uuid0.asString, equals(s0));

      final uuid1 = new Uuid.seededPseudo();
      log.debug('Uuid: $uuid1');
      expect(uuid1.asString, equals(s1));
    });

    test('Uuid Strings', () {
      expect(Uuid.isValidString(uuidV1, 1), true);

      // accepts implicit valid uuid v1
      expect(Uuid.isValidString(uuidV1), true);

      //accepts explicit valid uuid v4
      expect(Uuid.isValidString(uuidV4, 4), true);

      //accepts implicit valid uuid v4
      expect(Uuid.isValidString(uuidV4), true);

      //denies if wrong version
      expect(Uuid.isValidString(uuidV1, 4), false);

      log..debug(uuidList)..debug(uuidBytes);
      expect(uuidList != uuidBytes, true);

      //accepts valid List
      var uuid = new Uuid.fromList(uuidList);
      log.debug('uuidList uuid: $uuid');
      expect(Uuid.isValidString(uuid.asString), true);

      //accepts valid Uint8List
      uuid = new Uuid.fromList(uuidBytes);
      expect(Uuid.isValidString(uuid.asString), true);
      expect(uuid.data == uuidBytes, true);

      //denies if invalid
      expect(Uuid.isValidString('foo', 4), false);

      //fixes issue #1 (character casing correct at col 19)
      expect(Uuid.isValidString('97a90793-4898-4abe-b255-e8dc6967ed40'), true);
    });

    /*test("UUid", (){
      Uuid uuid0 = new Uuid('6ba7b810-9dad-41d1-80b4-00c04fd430c8');
      log.debug(uuid0.bytes);
      log.debug(uuid0.isValid);//check once
    });
    test("parse", () {
      String uuid0 = "6ba7b810-9dad-41d1-80b4-00c04fd430c8";
      Uuid uuid2 = Uuid.parse(uuid0);
      Uuid uuid3 = new Uuid('6ba7b810-9dad-41d1-80b4-00c04fd430c8');
      log.debug('Uuid.parse: ${uuid2}, uuid0: $uuid0');
      log.debug('uuid2.bytes: ${uuid2.bytes}, uuid3.bytes: ${uuid3.bytes}');
    });
    test("isNotValidString", (){

      String uuid0 = "6ba7b810-9dad-41d1-80b4-00c04fd430";
      String uuid1 = "6ba7b810-9dad-41d1-80b4-00c04fd430c8";
      String uuid2 = "6ba7b810-9dad-11d4-80b4-00c04fd430c8";

      expect(Uuid.isNotValidString(uuid0), true);
      expect(Uuid.isNotValidString(uuid0, 1), true);

      expect(Uuid.isNotValidString(uuid1, 4), false);
      expect(Uuid.isNotValidString(uuid2, 1), false);
      expect(Uuid.isNotValidString(uuid1), false);

    });
    test("isValidData", (){
      const List<int> uuidList = const <int>[
        149, 236, 195, 128, 175, 233, 17, 228, // No reformat
        155, 108, 117, 27, 102, 221, 84, 30
      ];
      //log.debug(Uuid.isValidData(uuidList, 1));
      //expect(Uuid.isValidData(uuidList, 1),true);
      log.debug(Uuid.initialize(seed: 16));
    });

    test(" == and hashCode ", (){
      String uuidV1 = "6ba7b810-9dad-11d4-80b4-00c04fd430c8";
      String uuidV2 = "6ba7b810-9dad-11d4-80b4-00c04fd430c8";
      String uuidV4 = "6ba7b810-9dad-41d4-80b4-00c04fd430c8";
      Uuid uuid0 = new Uuid(uuidV1);
      Uuid uuid1 = new Uuid(uuidV2);
      Uuid uuid2 = new Uuid(uuidV4);

      expect(uuid0, equals(uuid1));
      expect(uuid0, isNot(uuid2));

      expect(uuid0.bytes, equals(uuid1.bytes));
      expect(uuid0.bytes, isNot(uuid2.bytes));

      //hashCode
      //expect(uuid0.hashCode, equals(uuid1.hashCode));
      log.debug(uuid0.isSecure);
      //expect(uuid0.asHex, equals(uuidV1.replaceAll("-", "")));
      expect(uuid0.variant,equals(UuidVariant.rfc4122));

    });*/
  });
}
