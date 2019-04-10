//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

// TODO: add tests for all three errors in core/src/uid/uid_errors.dart.

void main() {
  Server.initialize(name: 'uid_test', level: Level.info);
  uidTest();
}

const List<String> goodUids = <String>[
  '1.2.840.10008.1.2',
  '1.2.840.10008.1.2.0',
  '1.2.840.10008.0.1.2',
  '1.2.840.10008.1.2.4.64',
  '1.2.840.10008.1.2.1',
  '1.2.840.10008.1.2.1.99',
  '1.2.840.10008.1.2.4.81',
  '1.2.840.10008.1.2.4.91',
  '1.23.9.99.0.345.3242.12.345.35'
];

const List<String> badUids = <String>[
  '1.2.3', // Invalid Length : length less than 6
  '3.2.840.10008.1.2.0', // '3.': not valid root
  '1.02.840.10008.1.2', // '.02': '0' can only be followed by '.'
  '1.2.840.10008.0.1.2.', // '.2.': uid can't end with dot
  '.2.840.10008.0.1.2', // '.2.': uid can't start with dot
  '1.).840.10008.0.*.2.', // Special characters
  '1.2.840.10008.1.2.-4.64', // '-': uid can't have a negative number
  // Invalid Length : length greater than 64
  '1.4.1.2.840.10008.1.2.4.64.1.2.840.10008.1.2.4.64.1.2.840.10008.1.2.4.64',
  '0.0.000.00000.0.0.00',
  '1.2.a840.1b0008.1.2.4.64', // Uid can't have letters
  '1.2.840.10a08.0.1.2' // letters can't be used
];

// well known Uids
const List<String> wkUids = <String>[
  '1.2.840.10008.1.2',
  '1.2.840.10008.1.2.1',
  '1.2.840.10008.1.2.1.99',
  '1.2.840.10008.1.2.4.81',
  '1.2.840.10008.1.2.4.91',
  '1.2.840.10008.1.2.4.94'
];

void uidTest() {
  group('Uid Tests', () {
    test('Well Known UIDs', () {
      var uid = Uid.parse('1.2.840.10008.1.2');
      expect(uid == TransferSyntax.kImplicitVRLittleEndian, true);
      expect(uid.asString, equals('1.2.840.10008.1.2'));
      uid = Uid.parse('1.2.840.10008.1.2.1');
      expect(uid == TransferSyntax.kExplicitVRLittleEndian, true);
      expect(uid.asString, equals(wkUids[1]));

      uid = Uid.parse(wkUids[2]);
      expect(uid == TransferSyntax.kDeflatedExplicitVRLittleEndian, true);
      expect(uid.asString, equals(wkUids[2]));

      uid = Uid.parse(wkUids[3]);
      expect(uid == TransferSyntax.kJpegLSLossyImageCompression, true);
      expect(uid.asString, equals(wkUids[3]));

      uid = Uid.parse(wkUids[4]);
      expect(uid == TransferSyntax.kJpeg2000ImageCompression, true);
      expect(uid.asString, equals(wkUids[4]));

      uid = Uid.parse(wkUids[5]);
      expect(uid == TransferSyntax.kJPIPReferenced, true);
      expect(uid.asString, equals(wkUids[5]));
    });

    test('Good UIDs', () {
      for (final s in goodUids) {
        final uid = Uid.parse(s);
        expect(uid, isNotNull);
        expect(uid is Uid, true);
        expect(uid.asString, equals(s));
      }
    });

    test('Bad String to UID should fail', () {
      // Bad letter 'Z'
      const s0 = '1.2.8z0.10008.1.2';
      var uid = Uid.parse(s0, onError: (s) => null);
      log.debug('uid: $uid');
      expect(uid == null, true);
      const s1 = '4.2.840.10008.1.2';
      uid = Uid.parse(s1, onError: (s) => null);
      log.debug('uid: $uid');
      expect(uid == null, true);
    });

    test('Bad UIDs', () {
      for (final s in badUids) {
        expect(Uid.isValidString(s), false);
        final uid = Uid.parse(s, onError: (s) => null);
        expect(uid, isNull);
        expect(uid is Uid, false);
      }
    });

    test('String to TransferSyntax', () {
      Uid uid = TransferSyntax.lookup('1.2.840.10008.1.2');
      expect(uid == TransferSyntax.kImplicitVRLittleEndian, true);
      uid = TransferSyntax.lookup('1.2.840.10008.1.2.1');
      expect(uid == TransferSyntax.kExplicitVRLittleEndian, true);
    });

    test('Generate Uid', () {
      for (final s in goodUids) {
        final uid0 = Uid(s); // checks 's' as valid Uid
        log.debug('uid0:$uid0');
        expect(uid0.value, equals(s));
      }
      final uid1 = Uid(); // generates Uid
      log.debug('uid1:$uid1');
      expect(uid1, isNotNull);
    });

    test('bad uid string test', () {
      for (final s in badUids) {
        final uid0 = Uid(s); // checks 's' as valid Uid
        expect(uid0, isNull);
      }
    });
  });
}
