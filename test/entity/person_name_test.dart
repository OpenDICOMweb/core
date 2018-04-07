// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

import 'package:core/server.dart';
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
      final personName = new PersonName.fromString(strValid);
      log.debug(personName.toString());
      expect(PersonName.isValidString(strValid), true);

      final listNames = strValid.split('=');
      expect(PersonName.isValidList(listNames), true);
    });

    test('test for == in PersonName', () {
      final pn1 = new PersonName.fromString(strValid);
      final pn2 = new PersonName.fromString(strValid);
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

    test('test for isValidList', () {
      for (var name in namesList1) {
        expect(Name.isValidList(name.split('^')), true);
      }
    });

    test('test for == in Name', () {
      final name = new Name.fromString(namesList1[0]);
      final name1 = new Name.fromString(namesList1[0]);
      final name2 = new Name.fromString(namesList1[1]);
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

      log.debug(n5.components);
      expect(n1, null);
      expect(n2, null);
      expect(n3, null);
      expect(n4, null);
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
}
