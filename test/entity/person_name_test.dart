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
import 'package:test_tools/tools.dart' as rsg;

void main() {
  Server.initialize(name: 'person_name.test', level: Level.info);

  //noOfgroups=3, noOfomponents=5, componentLength=8
  final strValid = rsg.generateDcmPersonName(3, 5, 6);
  //noOfgroups=3, noOfomponents=5, componentLength=8
  final strValid1 = rsg.generateDcmPersonName(3, 5, 15);

  group('person_name', () {
    test('test for isValidString and isValidList', () {
      final personName = PersonName.fromString(strValid);
      log.debug(personName.toString());
      expect(PersonName.isValidString(strValid), true);

      final listNames = strValid.split('=');
      expect(PersonName.isValidList(listNames), true);
    });

    test('test for == in PersonName', () {
      final pn1 = PersonName.fromString(strValid);
      final pn2 = PersonName.fromString(strValid);
      log.debug(pn1.hashCode);
      expect(pn1 == pn2, true);
      expect(pn1, equals(pn2));
    });

    test('test for parse', () {
      //noOfgroups=3, noOfomponents=5, componentLength=8
      final strInValid = rsg.generateDcmPersonName(4, 5, 8);

      final pn = PersonName.parse(strValid);
      log
        ..debug('alphabetic: ${pn.alphabetic}')
        ..debug('phonetic: ${pn.phonetic}')
        ..debug('ideographic: ${pn.ideographic}');

      final pn1 = PersonName.parse(strInValid);
      final pn2 = PersonName.parse('');
      final pn3 = PersonName.parse(null);
      expect(pn1, null);
      expect(pn2, null);
      expect(pn3, null);
    });
  });

  group('Name', () {
    final namesList1 = strValid.split('=');
    final namesList2 = strValid1.split('=');

    final strInValid = rsg.generateDcmPersonName(4, 5, 8);
    test('test for isValidList', () {
      for (var name in namesList1) {
        expect(Name.isValidList(name.split('^')), true);
      }

      final isValid0 = Name.isValidList(null);
      expect(isValid0, false);

      final isValid1 = Name.isValidList([]);
      expect(isValid1, false);

      final isValid2 = Name.isValidList([strInValid]);
      expect(isValid2, false);
    });

    test('test for == in Name', () {
      final name = Name.fromString(namesList1[0]);
      final name1 = Name.fromString(namesList1[0]);
      final name2 = Name.fromString(namesList1[1]);
      expect(name == name1, true);
      expect(name == name2, false);
    });

    test('test for isvalidString', () {
      expect(Name.isValidString(namesList1[0]), true);
    });

    test('test for parse in Name', () {
      final n1 = Name.parse(namesList2[1]);
      final n2 = Name.parse(null);
      final n3 = Name.parse('');
      final n4 = Name.parse(namesList2[0]);
      final n5 = Name.parse(namesList1[0]);

      final fromString0 = Name.fromString(namesList1[0]);
      log.debug(n5.components);
      expect(n1, null);
      expect(n2, null);
      expect(n3, null);
      expect(n4, null);
      expect(n5, equals(fromString0));
    });

    test('test for isValidComponentGroup', () {
      final strValid0 = rsg.generateDcmPersonName(2, 2, 2);
      final n1 = Name.isValidComponentGroup(strValid0);
      expect(n1, true);

      final strValid1 = rsg.generateDcmPersonName(3, 4, 5);
      final n2 = Name.isValidComponentGroup(strValid1);
      expect(n2, false);

      final strValid2 = rsg.generateDcmPersonName(0, 0, 0);
      final n3 = Name.isValidComponentGroup(strValid2);
      expect(n3, false);

      final n4 = Name.isValidComponentGroup(null);
      expect(n4, false);

      final n5 = Name.isValidComponentGroup('');
      expect(n5, false);
    });
  });
  group('sex', () {
    test('sexType', () {
      const genderList = ['M', 'F', 'O', 'T'];

      final sex0 = Sex.parse(genderList[0]);
      log.debug('sex0: $sex0');
      expect(sex0.name == 'Male', true);
      expect(sex0.isMale, true);
      expect(Sex.male == sex0, true);
      expect(Sex.maleType == 1, true);
      expect(sex0.abbreviation == genderList[0], true);

      final sex1 = Sex.parse(genderList[1]);
      log.debug('sex1: $sex1');
      expect(sex1.name == 'Female', true);
      expect(sex1.isFemale, true);
      expect(Sex.femaleType == 0, true);
      expect(Sex.female == sex1, true);
      expect(sex1.abbreviation == genderList[1], true);

      final sex2 = Sex.parse(genderList[2]);
      log.debug('sex2: $sex2');
      expect(sex2.name == 'Other', true);
      expect(sex2.isMale, false);
      expect(!sex2.isFemale, false);
      expect(Sex.otherType == 2, true);
      expect(Sex.other == sex2, true);
      expect(sex2.abbreviation == genderList[2], true);

      final sex3 = Sex.parse('');
      expect(sex3, isNull);

      global.throwOnError = true;
      expect(() => Sex.parse(genderList[3]),
          throwsA('Invalid Sex(${genderList[3]})'));
    });
  });
}
