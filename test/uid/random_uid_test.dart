// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.


import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'random_uid_test', level: Level.info);
  group('Random Uid Tests', () {

    test('Seeded Random Tests', (){
      final uid = new Uid.seededPseudo();
      final uid0 = new Uid.seededPseudo();
      log.debug('uid: (${uid.asString.length})"$uid" '
      'uid0: (${uid0.asString.length})"$uid0"');
      expect(uid.asString.indexOf('2.25.') == 0, true);
      expect(uid.asString.length > 30, true);
      expect(uid.asString.length <= 44, true);

      expect(uid == uid0, false);
      expect(uid.hashCode, isNot(uid0.hashCode));

      final uid1 = Uid.generateSeededPseudoUidString();
      expect(uid1.indexOf('2.25.') == 0, true);
      expect(uid1.length > 30, true);
      expect(uid1.length <= 44, true);
    });

    test('Pseudo Random Tests', (){
      final uid = new Uid.pseudo();
      expect(uid.asString.indexOf('2.25.') == 0, true);
      expect(uid.asString.length > 30, true);
      expect(uid.asString.length <= 44, true);

      final uid1 = Uid.generatePseudoUidString();
      expect(uid1.indexOf('2.25.') == 0, true);
      expect(uid1.length > 30, true);
      expect(uid1.length <= 44, true);
    });

    test('Secure Random Tests', () {
      final uid = new Uid.secure();
      expect(uid.asString.indexOf('2.25.') == 0, true);
      expect(uid.asString.length > 30, true);
      expect(uid.asString.length <= 44, true);

      final uid1 = Uid.generateSecureUidString();
      expect(uid1.indexOf('2.25.') == 0, true);
      expect(uid1.length > 30, true);
      expect(uid1.length <= 44, true);
    });

    const goodUids = const <String>[
      '0.20.3000',
      '1.20.3000',
      '2.20.3000',
      '0.3.0.812345',
      '1.2.840.10008.1.2.4.58',
      '1.2.840.10008.1.2.4.61'
    ];

    final badUids = const <String>[
      '',
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
      '1.2.840.10a08.0.1.2'  // letters can't be used
    ];

    test('parseList', () {
      //final abc  = new List<String>();
      final abc = <String>[];

      wellKnownUids.forEach((index, value) {
       abc.add(index);
      });

      final uidParseList = Uid.parseList(abc);
      expect(uidParseList, isNotNull);
    });

    test('randomList', () {
      final uid = new Uid.secure();
      final uidRootType0 = Uid.randomList(uid.asString.length);
      log.debug('uidRootType0 : $uidRootType0');
      expect(uidRootType0, isNotNull);

      //urgent: can we pass null here?
      //final uidRootType1 = Uid.randomList(null);
      //expect(uidRootType1, isNull);
    });

    test('isValidStringList', (){
      final validStringList0 = Uid.isValidStringList(goodUids);
      expect(validStringList0, true);

      final validStringList1 = Uid.isValidStringList(badUids);
      expect(validStringList1, false);

      final validStringList2 = Uid.isValidStringList([]);
      expect(validStringList2, true);

      final validStringList3 = Uid.isValidStringList(null);
      expect(validStringList3, false);
    });

    test('check', () {
      //good
      for(var s in wellKnownUids.keys) {
        final check = Uid.check(s);
        expect(check, isNotNull);
      }
      //bad
      for(var s in badUids){
        final check = Uid.check(s);
        expect(check, isNull);
      }

      final check0 = Uid.check('');
      expect(check0, isNull);

      final check1 = Uid.check(null);
      expect(check1, isNull);
    });

    test('isDicom', () {
      final goodUids = const <String>[
      '1.2.840.10008.1.1' ,
      '1.2.840.10008.1.2',
      '1.2.840.10008.1.2.1',
      '1.2.840.10008.1.2.1.99',
      '1.2.840.10008.1.2.2',
      '1.2.840.10008.1.2.4.50',
      '1.2.840.10008.1.2.4.51',
      '1.2.840.10008.1.2.4.52',
      '1.2.840.10008.1.2.4.53',

      '1.2.840.10008.1.2.4.54',

      '1.2.840.10008.1.2.4.55',

      '1.2.840.10008.1.2.4.56',

      '1.2.840.10008.1.2.4.57',
      '1.2.840.10008.1.2.4.58',
      '1.2.840.10008.1.2.4.59',
      '1.2.840.10008.1.2.4.60',
      '1.2.840.10008.1.2.4.61',

      '1.2.840.10008.1.2.4.62',

      '1.2.840.10008.1.2.4.63',

      '1.2.840.10008.1.2.4.64',

      '1.2.840.10008.1.2.4.65',
      '1.2.840.10008.1.2.4.66',
      '1.2.840.10008.1.2.4.70',

      '1.2.840.10008.1.2.4.80',
      '1.2.840.10008.1.2.4.81',
      '1.2.840.10008.1.2.4.90',

      '1.2.840.10008.1.2.4.91',
      '1.2.840.10008.1.2.4.92',

      '1.2.840.10008.1.2.4.93'
      ];

      for(var s in goodUids) {
        final dicom = Uid.isDicom(Uid.parse(s));
        expect(dicom, true);
      }
      final uid = new Uid.secure();
      final dicom = Uid.isDicom(uid);
      expect(dicom, false);
    });

    test('ramdomString', () {
      final rs0 = Uid.randomString();
      expect(rs0, isNotNull);
    });


  });
}

