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
  Server.initialize(name: 'uuid_string_test', level: Level.info);

  group('Uuid Tests', () {
    final goodUuidList0 = <String>[
      '09bb1d8c-4965-4788-94f7-31b151eaba4e',
      '23d57c30-afe7-41e4-ab7d-12e3f512a338',
      '6ba7b810-9dad-41d1-80b4-00c04fd43034',
      '6ba7b810-9dad-41d4-80b4-00c04fd430c8',
    ];

    final badUuidList0 = <String>[
      '09bb1d8c-4965-4788-94f7-31b1eaba4e',
      '23d57c30-afe7-11e4-ab7-d12e3f512a338',
      '6ba7b810-9dad-41d1-80b4-00c04fd430',
      '6ba7b810-9dad-11d4-80-b400c04fd430c8',
      '23d57c30afe741e4ab7d1-3f512a338',
      '6ba7b810-9dad41d48-0b400c04fd430c8'
    ];
    // The data in this test is in data.dart
    test('Uuid Test with seed', () {
      final uuid0 = new Uuid.seededPseudo();
      log..debug('seed: ${Uuid.seed}')..debug('Uuid: $uuid0');
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

      for (var uuid in goodUuidList0) {
        system.throwOnError = false;
        final uuid0 = Uuid.isValidString(uuid);
        expect(uuid0, true);
      }
    });

    test('isValid', () {
    //  system.level = Level.debug;
      final uuid0 = new Uuid();
      expect(uuid0.isValid, true);

      final uuid1 = new Uuid.pseudo();
      expect(uuid1.isValid, true);

      final uuid2 = new Uuid.seededPseudo();
      expect(uuid2.isValid, true);

      for (var uuid in goodUuidList0) {
        final uuid3 = Uuid.parse(uuid);
        expect(uuid3.isValid, true);
      }

      for (var uuid in badUuidList0) {
        system.throwOnError = false;
        final uuid34 = Uuid.parse(uuid);
        expect(uuid34, isNull);

        system.throwOnError = true;

        expect(() => Uuid.parse(uuid),
            throwsA(const isInstanceOf<InvalidUuidError>()));
      }
    });
    test('parse', () {
      final uuidString0 = '6ba7b810-9dad-41d1-80b4-00c04fd430c8';
      final uuid0 = Uuid.parse(uuidString0);
      expect(uuid0.asString, equals(uuidString0));

      for (var uuid in goodUuidList0) {
        system.throwOnError = false;
        final uuid1 = Uuid.parse(uuid);
        expect(uuid1.asString, equals(uuid));
      }

      for (var uuid in badUuidList0) {
        system.throwOnError = false;
        final uuid2 = Uuid.parse(uuid);
        expect(uuid2, isNull);

        system.throwOnError = true;
        expect(() => Uuid.parse(uuid),
            throwsA(const isInstanceOf<InvalidUuidError>()));
      }
    });

    test('isNotValidString', () {
      final uuid0 = '6ba7b810-9dad-41d1-80b4-00c04fd430';
      final uuid1 = '6ba7b810-9dad-41d1-80b4-00c04fd430c8';
      final uuid2 = '6ba7b810-9dad-11d4-80b4-00c04fd430c8';

      expect(Uuid.isNotValidString(uuid0), true);
      expect(Uuid.isNotValidString(uuid0, 1), true);

      expect(Uuid.isNotValidString(uuid1, 4), false);
      expect(Uuid.isNotValidString(uuid2, 1), false);
      expect(Uuid.isNotValidString(uuid1), false);
    });

    test('isValidData', () {
      const uuidList = const <int>[
        149, 236, 195, 128, 175, 233, 17, 228, // No reformat
        155, 108, 117, 27, 102, 221, 84, 30
      ];
      final uInt8List = new Uint8List.fromList(uuidList);
      //final bytes = uInt8List.buffer.asUint8List();
      log.debug('uInt8List: $uInt8List');
      expect(Uuid.isValidData(uInt8List, 1), true);
      expect(Uuid.isValidData(uInt8List, 3), false);

      expect(Uuid.isValidData(uInt8List, 5), false);

      expect(Uuid.isValidData(uInt8List), true);

      expect(() => Uuid.isValidData(uInt8List, 6),
          throwsA(const isInstanceOf<UuidError>()));
    });

    test(' == and hashCode ', () {
      final uuidV1 = '6ba7b810-9dad-41d4-80b4-00c04fd430c8';
      final uuidV2 = '6ba7b810-9dad-41d4-80b4-00c04fd430c8';
      final uuidV3 = '6ba7b810-9dad-4788-80b4-00c04fd430c8';
      final uuid0 = Uuid.parse(uuidV1);
      final uuid1 = Uuid.parse(uuidV2);
      final uuid2 = Uuid.parse(uuidV3);

      expect(uuid0 == uuid1, true);
      expect(uuid0 == uuid2, false);
      // system.level = Level.debug;
      log.debug('uuid0: $uuid0, uuid1: $uuid1');
      //expect(uuid0.data.hashCode, equals(uuid1.data.hashCode));
      expect(uuid0.asHex, equals(uuidV1.replaceAll('-', '')));
      expect(uuid0.variant, equals(UuidVariant.rfc4122));
    });
  });
}
