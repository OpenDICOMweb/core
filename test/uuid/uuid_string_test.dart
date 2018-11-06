//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

import 'data.dart';

const String uuidV1 = '23d57c30-afe7-11e4-ab7d-12e3f512a338';
const String uuidV4 = '09bb1d8c-4965-4788-94f7-31b151eaba4e';

const List<int> uuidList = <int>[
  149, 236, 195, 128, 175, 233, 17, 228, // No reformat
  155, 108, 117, 27, 102, 221, 84, 30
];

final Uint8List uuidBytes = Uint8List.fromList(uuidList);

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
      '23d57c30-afe7-11e4-ab7-d12e3f512a338',
      '6ba7b810-9dad-11d4-80-b400c04fd430c8',
      '8f534d57-0s95-4a3c-8796-8be3b34440bc',
      '7eeau2ad-c74e-43fe-9720-db0e09797518',
      '-9a466e3-691d-4e05-bd11-1f3b224106d0',
      '28abd21#-b80c-4799-8c28-c57b7e9f2d3b',
      'c1d06122-ed09-44bg-a060-8d309d7e7f26',
      'db0411da-efcd-4340-9772-669m1d2611ed',
      '847e3de3-4a5b-49e6-8)f8-a8f0f02ac601',
      'bc795f32-ea62-4@eb-bf30-171e7e1c65e1',
      '50_42c83-aefd-4003-be7b-2a9f3426b903',
      '4826a68c-f0f6-4fa4-a302-9a38bd0df93l',
      'd820ee98-eo66-45d4-824d-41abbe47a206'
    ];
    final badUuidListLength0 = <String>[
      '09bb1d8c-4965-4788-94f7-31b1eaba4e',
      '6ba7b810-9dad-41d1-80b4-00c04fd430',
      '23d57c30afe741e4ab7d1-3f512a338',
      '6ba7b810-9dad41d48-0b400c04fd430c8'
    ];
    // The data in this test is in data.dart
    test('Uuid Test with seed', () {
      final uuid0 = Uuid.seededPseudo();
      log..debug('seed: ${Uuid.seed}')..debug('Uuid: $uuid0');
      expect(uuid0.asString, equals(s0));

      final uuid1 = Uuid.seededPseudo();
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
      var uuid = Uuid.fromList(uuidList);
      log.debug('uuidList uuid: $uuid');
      expect(Uuid.isValidString(uuid.asString), true);

      //accepts valid Uint8List
      uuid = Uuid.fromList(uuidBytes);
      expect(Uuid.isValidString(uuid.asString), true);
      expect(uuid.data == uuidBytes, true);

      //denies if invalid
      expect(Uuid.isValidString('foo', 4), false);

      //fixes issue #1 (character casing correct at col 19)
      expect(Uuid.isValidString('97a90793-4898-4abe-b255-e8dc6967ed40'), true);

      for (var uuid in goodUuidList0) {
        global.throwOnError = false;
        final uuid0 = Uuid.isValidString(uuid);
        expect(uuid0, true);
      }

      for (var uuid in badUuidList0) {
        global.throwOnError = false;
        final uuid0 = Uuid.isValidString(uuid);
        expect(uuid0, false);
      }
    });

    test('isValid', () {
      final uuid0 = Uuid();
      expect(uuid0.isValid, true);

      final uuid1 = Uuid.pseudo();
      expect(uuid1.isValid, true);

      final uuid2 = Uuid.seededPseudo();
      expect(uuid2.isValid, true);

      for (var uuid in goodUuidList0) {
        final uuid3 = Uuid.parse(uuid);
        expect(uuid3.isValid, true);
      }

      for (var uuid in badUuidList0) {
        global.throwOnError = false;
        final uuid4 = Uuid.parse(uuid);
        expect(uuid4, isNull);

        global.throwOnError = true;
        expect(
            () => Uuid.parse(uuid), throwsA(const TypeMatcher<StringError>()));
      }

      for (var uuid in badUuidListLength0) {
        global.throwOnError = false;
        final uuid5 = Uuid.parse(uuid);
        expect(uuid5, isNull);

        global.throwOnError = true;
        expect(
            () => Uuid.parse(uuid), throwsA(const TypeMatcher<StringError>()));
      }
    });
    test('parse', () {
      const uuidString0 = '6ba7b810-9dad-41d1-80b4-00c04fd430c8';
      final uuid0 = Uuid.parse(uuidString0);
      expect(uuid0.asString, equals(uuidString0));

      for (var uuid in goodUuidList0) {
        global.throwOnError = false;
        final uuid1 = Uuid.parse(uuid);
        expect(uuid1.asString, equals(uuid));
      }

      for (var uuid in badUuidList0) {
        global.throwOnError = false;
        final uuid2 = Uuid.parse(uuid);
        expect(uuid2, isNull);

        global.throwOnError = true;
        expect(
            () => Uuid.parse(uuid), throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('isNotValidString', () {
      const uuid0 = '6ba7b810-9dad-41d1-80b4-00c04fd430';
      const uuid1 = '6ba7b810-9dad-41d1-80b4-00c04fd430c8';
      const uuid2 = '6ba7b810-9dad-11d4-80b4-00c04fd430c8';

      expect(Uuid.isNotValidString(uuid0), true);
      expect(Uuid.isNotValidString(uuid0, 1), true);

      expect(Uuid.isNotValidString(uuid1, 4), false);
      expect(Uuid.isNotValidString(uuid2, 1), false);
      expect(Uuid.isNotValidString(uuid1), false);
    });

    test('isValidData', () {
      const uuidList = <int>[
        149, 236, 195, 128, 175, 233, 17, 228, // No reformat
        155, 108, 117, 27, 102, 221, 84, 30
      ];
      final uInt8List = Uint8List.fromList(uuidList);
      //final bytes = uInt8List.buffer.asUint8List();
      log.debug('uInt8List: $uInt8List');
      expect(Uuid.isValidData(uInt8List, 1), true);
      expect(Uuid.isValidData(uInt8List, 3), false);

      expect(Uuid.isValidData(uInt8List, 5), false);

      expect(Uuid.isValidData(uInt8List), true);

      expect(() => Uuid.isValidData(uInt8List, 6),
          throwsA(const TypeMatcher<UuidError>()));
    });

    test(' == and hashCode ', () {
      const uuidV1 = '6ba7b810-9dad-41d4-80b4-00c04fd430c8';
      const uuidV2 = '6ba7b810-9dad-41d4-80b4-00c04fd430c8';
      const uuidV3 = '6ba7b810-9dad-4788-80b4-00c04fd430c8';
      final uuid0 = Uuid.parse(uuidV1);
      final uuid1 = Uuid.parse(uuidV2);
      final uuid2 = Uuid.parse(uuidV3);

      expect(uuid0 == uuid1, true);
      expect(uuid0 == uuid2, false);
      log.debug('uuid0: $uuid0, uuid1: $uuid1');
      //expect(uuid0.data.hashCode, equals(uuid1.data.hashCode));
      expect(uuid0.asHex, equals(uuidV1.replaceAll('-', '')));
      expect(uuid0.variant, equals(UuidVariant.rfc4122));
    });

    test('toUid', () {
      final bytes = Uint8List.fromList(uuidList);
      final toUid0 = Uuid.toUid(bytes);
      log.debug('toUid0: $toUid0');
      expect(toUid0 == '2.25.121603237333826379183460680347508878182', true);

      for (var i = 0; i < 10; i++) {
        final uuidList1 = <int>[];
        for (var j = 0; j < 16; j++) {
          final random = RNG();
          final e = random.nextUint8;
          uuidList1.add(e);
        }
        log.debug(uuidList1);

        final bytes1 = Uint8List.fromList(uuidList1);
        final toUid1 = Uuid.toUid(bytes1);
        log.debug('toUid1: $toUid1');

        final v = bytes1.buffer.asUint32List();
        final sb = StringBuffer('2.25.1');
        for (var i = 0; i < v.length; i++) sb.write(v[i].toString());
        final s = sb.toString();
        log.debug('s: $s');

        expect(toUid1 == s, true);
        expect(toUid1, isNotNull);
      }

      final uuid0 = Uuid();
      expect(uuid0.asUid, isNotNull);
      expect(uuid0.asDecimal, isNotNull);
    });

    test('setGenerator', () {
      final generator0 = Uuid.setGenerator(GeneratorType.pseudo);
      expect(generator0, true);

      final generator1 = Uuid.setGenerator(GeneratorType.secure);
      expect(generator1, true);

      final generator2 = Uuid.setGenerator(GeneratorType.seededPseudo);
      expect(generator2, true);
    });
  });
}
