//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:convert' as cvt;

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

import '../utility_test.dart' as utility;

RSG rsg = RSG(seed: 1);

void main() {
  // minYear and maxYear can be passed as an argument
  Server.initialize(
      name: 'string/da_test',
      level: Level.info,
      minYear: 0000,
      maxYear: 2100,
      throwOnError: false);
  global.throwOnError = false;

  const goodDAList = <List<String>>[
    <String>['19930822'],
    <String>['19930822'],
    <String>['19500718'],
    <String>['00000101'],
    <String>['19700101'],
    <String>['20171231'],
    <String>['19931010'],
    //<String>['19931010', '20171231'],
  ];

  const badDAList = <List<String>>[
    <String>['19501318'], // bad month
    <String>['20041313'], // bad month
    <String>['19804312'], //bad month
    <String>['00000032'], // bad month and day
    <String>['00000000'], //bad day
    <String>['19800541'], // bad day
    <String>['-9700101'], // bad character in year
    <String>['1b700101'], // bad character in year
    <String>['1970a101'], // bad character in year
    <String>['19700b01'], // bad character in year
    <String>['1970011a'], // bad character in month
    //<String>['19931010', '20171231'],
  ];

  const badDALengthList = <List<String>>[
    <String>['1978123'], // invalid length
    <String>['197812345'], // invalid length
    <String>['201'],
    <String>['2018'],
    <String>['20156'],
    <String>['199815'],
    <String>['12'],
    <String>['9']
  ];

  group('DA Tests', () {
    test('DA hasValidValues good values', () {
      for (final s in goodDAList) {
        global.throwOnError = false;
        log.debug('DA: "$s"');
        final e0 = DAtag(PTag.kCreationDate, s);
        expect(e0.hasValidValues, true);
      }

      global.throwOnError = false;
      final e1 = DAtag(PTag.kCreationDate, []);
      expect(e1.hasValidValues, true);
      expect(e1.values, equals(<String>[]));
    });

    test('DA hasValidValues for bad year, month, and day values', () {
      for (final s in badDAList) {
        global.throwOnError = false;
        final e1 = DAtag(PTag.kCreationDate, s);
        expect(e1, isNull);

        global.throwOnError = true;
        expect(() => DAtag(PTag.kCreationDate, s),
            throwsA(const TypeMatcher<StringError>()));
      }

      global.throwOnError = false;
      final e1 = DAtag(PTag.kCreationDate, null);
      log.debug('e1: $e1');
      expect(e1.hasValidValues, true);
      expect(e1.values, StringList.kEmptyList);

      global.throwOnError = true;
      expect(() => DAtag(PTag.kCreationDate, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('DA hasValidValues for bad values length', () {
      for (final s in badDALengthList) {
        global.throwOnError = false;
        final e1 = DAtag(PTag.kCreationDate, s);
        expect(e1, isNull);

        global.throwOnError = true;
        expect(() => DAtag(PTag.kCreationDate, s),
            throwsA(const TypeMatcher<StringError>()));
      }

      global.throwOnError = false;
      final e1 = DAtag(PTag.kCreationDate, null);
      log.debug('e1: $e1');
      expect(e1.hasValidValues, true);
      expect(e1.values, StringList.kEmptyList);

      global.throwOnError = true;
      expect(() => DAtag(PTag.kCreationDate, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('DA hasValidValues good values random', () {
      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        log.debug('vList0: $vList0');
        final e0 = DAtag(PTag.kCreationDate, vList0);
        expect(e0.hasValidValues, true);
      }
    });

    test('DA hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getDAList(3, 4);
        log.debug('$i: vList0: $vList0');
        final e1 = DAtag(PTag.kCreationDate, vList0);
        expect(e1, isNull);

        global.throwOnError = true;
        expect(() => DAtag(PTag.kCreationDate, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('DA update', () {
      global.throwOnError = false;
      final e0 = DAtag(PTag.kCreationDate, <String>[]);
      expect(e0, <String>[]);

      final e1 = DAtag(PTag.kCreationDate, ['19930822']);
      final e2 = DAtag(PTag.kCreationDate, ['19930822']);
      final e3 = e1.update(['20150822']);
      final e4 = e2.update(['20150822']);
      expect(e1.values.first == e4.values.first, false);
      expect(e1 == e4, false);
      expect(e2 == e4, false);
      expect(e3 == e4, true);

      for (final s in goodDAList) {
        final e5 = DAtag(PTag.kCreationDate, s);
        final e6 = e5.update(['20150817']);
        final e7 = e5.update(['20150817']);
        expect(e5.values.first == e6.values.first, false);
        expect(e5 == e6, false);
        expect(e6 == e7, true);
      }
      expect(utility.testElementUpdate(e1, <String>['19930822']), true);
    });

    test('DA update random', () {
      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        final e0 = DAtag(PTag.kCreationDate, vList0);
        final vList1 = rsg.getDAList(1, 1);
        expect(e0.update(vList1).values, equals(vList1));
      }
    });

    test('DA noValues', () {
      final e1 = DAtag(PTag.kCreationDate, ['19930822']);
      final daNoValues1 = e1.noValues;
      expect(daNoValues1.values.isEmpty, true);
      log.debug('daNoValues1:$daNoValues1');

      for (final s in goodDAList) {
        final e1 = DAtag(PTag.kCreationDate, s);
        final daNoValues1 = e1.noValues;
        expect(daNoValues1.values.isEmpty, true);
      }
    });

    test('DA noValues random ', () {
      final e0 = DAtag(PTag.kCreationDate, <String>[]);
      final DAtag daNoValues0 = e0.noValues;
      expect(daNoValues0.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        final e0 = DAtag(PTag.kCreationDate, vList0);
        log.debug('e0: $e0');
        expect(daNoValues0.values.isEmpty, true);
        log.debug('e0: ${e0.noValues}');
      }
    });

    test('DA copy', () {
      final e0 = DAtag(PTag.kCreationDate, <String>[]);
      final DAtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      final e2 = DAtag(PTag.kCreationDate, ['19930822']);
      final e3 = e2.copy;
      expect(e2 == e3, true);
      expect(e2.hashCode == e3.hashCode, true);

      for (final s in goodDAList) {
        final e4 = DAtag(PTag.kCreationDate, s);
        final e5 = e4.copy;
        expect(e4 == e5, true);
        expect(e4.hashCode == e5.hashCode, true);
      }
      expect(utility.testElementCopy(e0), true);
    });

    test('DA copy random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        final e2 = DAtag(PTag.kCreationDate, vList0);
        final DAtag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('DA hashCode and == good values', () {
      final vList0 = ['19930822'];
      final e0 = DAtag(PTag.kCreationDate, vList0);
      final e1 = DAtag(PTag.kCreationDate, vList0);
      log
        ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
        ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);
    });

    test('DA hashCode and == bad values', () {
      final vList0 = ['19930822'];
      final e0 = DAtag(PTag.kCreationDate, vList0);
      final e2 = DAtag(PTag.kStructureSetDate, vList0);
      log.debug('vList0:$vList0 , e2.hash_code:${e2.hashCode}');
      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);

      final e3 = DAtag(PTag.kCalibrationDate, vList0);
      log.debug('vList0:$vList0 , e3.hash_code:${e3.hashCode}');
      expect(e0.hashCode == e3.hashCode, false);
      expect(e0 == e3, false);
    });

    test('DA hashCode and == good values random', () {
      global.throwOnError = false;
      List<String> stringList0;

      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getDAList(1, 1);
        final e0 = DAtag(PTag.kPatientAge, stringList0);
        final e1 = DAtag(PTag.kPatientAge, stringList0);
        log
          ..debug('stringList0:$stringList0, e0.hash_code:${e0.hashCode}')
          ..debug('stringList0:$stringList0, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('DA hashCode and == bad values random', () {
      global.throwOnError = false;
      List<String> stringList0;
      List<String> stringList1;

      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getDAList(1, 1);
        final e0 = DAtag(PTag.kPatientAge, stringList0);
        stringList1 = rsg.getDAList(2, 3);
        final e3 = DAtag(PTag.kSelectorDAValue, stringList1);
        log.debug('stringList1:$stringList1 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);
      }
    });

    test('DA valuesCopy ranodm', () {
      for (final s in goodDAList) {
        final e0 = DAtag(PTag.kCalibrationDate, s);
        expect(s, equals(e0.valuesCopy));
      }

      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        final e1 = DAtag(PTag.kCreationDate, vList0);
        expect(vList0, equals(e1.valuesCopy));
      }
    });

    test('DA checkLength', () {
      for (final s in goodDAList) {
        final e0 = DAtag(PTag.kCreationDate, s);
        expect(e0.checkLength(e0.values), true);
      }
    });

    test('DA checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        final e0 = DAtag(PTag.kCreationDate, vList0);
        expect(e0.checkLength(e0.values), true);
      }
    });

    test('DA isValidValues good values', () {
      global.throwOnError = false;
      for (final s in goodDAList) {
        final e0 = DAtag(PTag.kCreationDate, s);
        expect(e0.hasValidValues, true);
      }
    });

    test('DA isValidValues bad values', () {
      global.throwOnError = false;
      for (final s in badDAList) {
        global.throwOnError = false;
        final e0 = DAtag(PTag.kCreationDate, s);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => DAtag(PTag.kCreationDate, null),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('DA isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        final e0 = DAtag(PTag.kCreationDate, vList0);
        expect(e0.hasValidValues, true);
      }
    });

    test('DA replace', () {
      global.throwOnError = false;

      final vList0 = ['19991025'];
      final e0 = DAtag(PTag.kCreationDate, vList0);
      final vList1 = ['19001025'];
      expect(e0.replace(vList1), equals(vList0));
      expect(e0.values, equals(vList1));

      final e1 = DAtag(PTag.kCreationDate, vList1);
      expect(e1.replace(<String>[]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = DAtag(PTag.kCreationDate, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(StringList.kEmptyList));
    });

    test('DA replace random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        final e0 = DAtag(PTag.kCreationDate, vList0);
        final vList1 = rsg.getDAList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getDAList(1, 1);
      final e1 = DAtag(PTag.kCreationDate, vList1);
      expect(e1.replace(<String>[]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = DAtag(PTag.kCreationDate, null);
      expect(e2.hasValidValues, true);
      expect(e2.values, StringList.kEmptyList);
    });

    test('DA getAsciiList', () {
      for (final s in goodDAList) {
        //final bytes = encodeStringListValueField(vList1);
        final bytes = Bytes.asciiFromList(s);
        log.debug('bytes:$bytes');
        final e0 = DAtag.fromBytes(PTag.kCreationDate, bytes);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
      }
    });

    test('DA getAsciiList random', () {
      //    	system.level = Level.info;
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDAList(1, 1);
        final bytes = Bytes.asciiFromList(vList1);
        log.debug('bytes:$bytes');
        final e0 = DAtag.fromBytes(PTag.kCreationDate, bytes);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
      }
    });

    test('DA fromValueField', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        log.debug('vList0: $vList0');
        final fvf0 = AsciiString.fromValueField(vList0, k8BitMaxLongVF);
        expect(fvf0, equals(vList0));
      }

      for (var i = 1; i < 10; i++) {
        global.throwOnError = false;
        final vList1 = rsg.getDAList(1, i);
        final fvf1 = AsciiString.fromValueField(vList1, k8BitMaxLongVF);
        expect(fvf1, equals(vList1));
      }
      global.throwOnError = false;
      final fvf1 = AsciiString.fromValueField(null, k8BitMaxLongLength);
      expect(fvf1, <String>[]);
      expect(fvf1 == kEmptyStringList, true);

      final fvf2 = AsciiString.fromValueField(<String>[], k8BitMaxLongLength);
      expect(fvf2, <String>[]);
      expect(fvf2 == kEmptyStringList, false);
      expect(fvf2.isEmpty, true);

      final fvf3 = AsciiString.fromValueField(<int>[1234], k8BitMaxLongLength);
      expect(fvf3, isNull);

      global.throwOnError = true;
      expect(() => AsciiString.fromValueField(<int>[1234], k8BitMaxLongLength),
          throwsA(const TypeMatcher<InvalidValuesError>()));

      global.throwOnError = false;
      final vList2 = rsg.getCSList(1, 1);
      final bytes = Bytes.utf8FromList(vList2);
      final fvf4 = AsciiString.fromValueField(bytes, k8BitMaxLongLength);
      expect(fvf4, equals(vList2));
    });

    test('DA fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDAList(1, 10);
        for (final listS in vList1) {
          final bytes0 = Bytes.ascii(listS);
          final e1 = DAtag.fromBytes(PTag.kSelectorDAValue, bytes0);
          log.debug('e1: $e1');
          expect(e1.hasValidValues, true);
        }
      }
    });

    test('DA fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDAList(1, 10);
        for (final listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.ascii(listS);
          final e1 = DAtag.fromBytes(PTag.kSelectorAEValue, bytes0);
          expect(e1, isNull);

          global.throwOnError = true;
          expect(() => DAtag.fromBytes(PTag.kSelectorAEValue, bytes0),
              throwsA(const TypeMatcher<InvalidTagError>()));
        }
      }
    });

    test('DA checkLength', () {
      global.throwOnError = false;
      final e0 = DAtag(PTag.kCreationDate, ['19930822']);
      for (final s in goodDAList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = DAtag(PTag.kCreationDate, ['19930822']);
      expect(e1.checkLength(<String>[]), true);

      final vList0 = ['20171206', '20181206'];
      final e2 = DAtag(PTag.kPatientSize, vList0);
      expect(e2, isNull);
    });

    test('DA checkLength good values random', () {
      final vList0 = rsg.getDAList(1, 1);
      final e0 = DAtag(PTag.kCreationDate, vList0);
      for (final s in goodDAList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = DAtag(PTag.kCreationDate, vList0);
      expect(e1.checkLength(<String>[]), true);
    });

    test('DA checkLength bad values random', () {
      final vList1 = ['19980512', '20170412'];
      final vList0 = rsg.getDAList(1, 1);
      final e2 = DAtag(PTag.kCreationDate, vList0);
      expect(e2.checkLength(vList1), false);
    });

    test('DA checkValue good values', () {
      final e0 = DAtag(PTag.kCreationDate, ['19930822']);
      for (final s in goodDAList) {
        for (final a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });

    test('DA checkValue bad values', () {
      final e0 = DAtag(PTag.kCreationDate, ['19930822']);
      for (final s in badDAList) {
        for (final a in s) {
          global.throwOnError = false;
          expect(e0.checkValue(a), false);
        }
      }
    });

    test('DA checkValue good values random', () {
      global.throwOnError = false;
      final vList0 = rsg.getDAList(1, 1);
      final e0 = DAtag(PTag.kCreationDate, vList0);
      for (final s in goodDAList) {
        for (final a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });
    test('DA checkValue bad values random', () {
      global.throwOnError = false;
      final vList0 = rsg.getDAList(1, 1);
      final e0 = DAtag(PTag.kCreationDate, vList0);
      for (final s in badDAList) {
        for (final a in s) {
          global.throwOnError = false;
          expect(e0.checkValue(a), false);
        }
      }
    });

    test('DA make good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        final make0 = DAtag.fromValues(PTag.kDate, vList0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);

        final make1 = DAtag.fromValues(PTag.kDate, <String>[]);
        expect(make1.hasValidValues, true);
        expect(make1.values, equals(<String>[]));
      }
    });

    test('DA make bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(2, 2);
        global.throwOnError = false;
        final make0 = DAtag.fromValues(PTag.kDate, vList0);
        expect(make0, isNull);

        global.throwOnError = true;
        expect(() => DAtag.fromValues(PTag.kDate, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final make1 = DAtag.fromValues(PTag.kDate, <String>[null]);
      log.debug('mak1: $make1');
      expect(make1, isNull);

      global.throwOnError = true;
      expect(() => DAtag.fromValues(PTag.kDate, <String>[null]),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('increment', () {
      for (var i = 0; i <= 10; i++) {
        final vList = rsg.getDAList(1, 1);
        final e0 = DAtag(PTag.kDate, vList);
        final increment0 = e0.increment();
        log.debug('increment0: $increment0');
        expect(increment0.hasValidValues, true);
      }
    });

    test('difference', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getDAList(1, 1);
        final e0 = DAtag(PTag.kDate, vList);
        final date = Date(2018, 06, 29);
        final difference0 = e0.difference(date);
        log.debug('difference0: $difference0');
        expect(difference0.hasValidValues, true);
      }
    });

    test('DA append ', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getDAList(1, i);
        final e0 = DAtag(PTag.kSelectorDAValue, vList0);
        const vList1 = '20181212';
        final append0 = e0.append(vList1);
        log.debug('append0: $append0');
        expect(append0, isNotNull);

        final append1 = e0.values.append(vList1, e0.maxValueLength);
        log.debug('e0.append: $append1');
        expect(append0, equals(append1));
      }
    });

    test('DA prepend ', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getDAList(1, i);
        final e0 = DAtag(PTag.kSelectorDAValue, vList0);
        const vList1 = '20181212';
        final prepend0 = e0.prepend(vList1);
        log.debug('prepend0: $prepend0');
        expect(prepend0, isNotNull);

        final prepend1 = e0.values.prepend(vList1, e0.maxValueLength);
        log.debug('e0.prepend: $prepend1');
        expect(prepend0, equals(prepend1));
      }
    });

    test('DA truncate ', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getDAList(1, i);
        final e0 = DAtag(PTag.kSelectorDAValue, vList0);
        final truncate0 = e0.truncate(4);
        log.debug('truncate0: $truncate0');
        expect(truncate0, isNotNull);
      }
    });

    test('DA match', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getDAList(1, i);
        log.debug('vList0:$vList0');
        final e0 = DAtag(PTag.kSelectorDAValue, vList0);
        const regX = r'\w*[0-9]';
        final match0 = e0.match(regX);
        expect(match0, true);
      }
    });

    test('DA check', () {
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getDAList(1, 1);
        final e0 = DAtag(PTag.kSeriesDate, vList);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList[0]));
      }

      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getDAList(1, i);
        final e0 = DAtag(PTag.kSelectorDAValue, vList1);
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);
        expect(e0[0], equals(vList1[0]));
      }
    });

    test('DA valuesEqual good values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getDAList(1, 1);
        final e0 = DAtag(PTag.kSelectorDAValue, vList);
        final e1 = DAtag(PTag.kSelectorDAValue, vList);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), true);
      }
    });

    test('DA valuesEqual bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getDAList(1, i);
        final vList1 = rsg.getDAList(1, 1);
        final e0 = DAtag(PTag.kSelectorDAValue, vList0);
        final e1 = DAtag(PTag.kSelectorDAValue, vList1);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), false);
      }
    });
  });

  group('DA Element', () {
    const badDateValuesLengthList = <List<String>>[
      <String>['197812345', '1b700101'],
      <String>['19800541', '1970011a'],
      <String>['00000032', '19501318'],
    ];

    //VM.k1
    const daVM1Tags = <PTag>[
      PTag.kStudyDate,
      PTag.kSeriesDate,
      PTag.kAcquisitionDate,
      PTag.kContentDate,
      PTag.kOverlayDate,
      PTag.kCurveDate,
      PTag.kPatientBirthDate,
      PTag.kDateOfSecondaryCapture,
      PTag.kModifiedImageDate,
      PTag.kStudyVerifiedDate,
      PTag.kStudyReadDate,
      PTag.kScheduledStudyStartDate,
      PTag.kScheduledStudyStopDate,
    ];

    //VM.k1_n
    const daVM1nTags = <PTag>[
      PTag.kCalibrationDate,
      PTag.kDateOfLastCalibration,
      PTag.kSelectorDAValue,
    ];

    const otherTags = <PTag>[
      PTag.kColumnAngulationPatient,
      PTag.kAcquisitionProtocolDescription,
      PTag.kCTDIvol,
      PTag.kCTPositionSequence,
      PTag.kAcquisitionType,
      PTag.kICCProfile,
      PTag.kSelectorSTValue,
      PTag.kDateTime,
      PTag.kTime
    ];

    final invalidList = rsg.getDAList(DA.kMaxVFLength + 1, DA.kMaxVFLength + 1);

    test('DA isValidTag good values', () {
      global.throwOnError = false;
      expect(DA.isValidTag(PTag.kSelectorDAValue), true);

      for (final tag in daVM1Tags) {
        final validT0 = DA.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('DA isValidTag bad values', () {
      global.throwOnError = false;
      expect(DA.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => DA.isValidTag(PTag.kSelectorFDValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (final tag in otherTags) {
        global.throwOnError = false;
        final validT0 = DA.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => DA.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('DA isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(DA.isValidVRIndex(kDAIndex), true);

      for (final tag in daVM1Tags) {
        global.throwOnError = false;
        expect(DA.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('DA isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(DA.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => DA.isValidVRIndex(kCSIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (final tag in otherTags) {
        global.throwOnError = false;
        expect(DA.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => DA.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('DA isValidVRCode good values', () {
      global.throwOnError = false;
      expect(DA.isValidVRCode(kDACode), true);

      for (final tag in daVM1Tags) {
        expect(DA.isValidVRCode(tag.vrCode), true);
      }
    });

    test('DA isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(DA.isValidVRCode(kSSCode), false);

      global.throwOnError = true;
      expect(() => DA.isValidVRCode(kSSCode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (final tag in otherTags) {
        global.throwOnError = false;
        expect(DA.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => DA.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('DA isValidVFLength good values', () {
      expect(DA.isValidVFLength(DA.kMaxVFLength), true);
      expect(DA.isValidVFLength(0), true);
    });

    test('DA isValidVFLength bad values', () {
      expect(DA.isValidVFLength(DA.kMaxVFLength + 1), false);
      expect(DA.isValidVFLength(-1), false);
    });

    test('DA isValidValueLength good values', () {
      global.throwOnError = false;
      for (final s in goodDAList) {
        for (final a in s) {
          expect(DA.isValidValueLength(a), true);
        }
      }

      expect(DA.isValidValueLength('19941212'), true);
    });

    test('DA isValidValueLength bad values', () {
      expect(DA.isValidValueLength('1994121256'), false);
    });

    test('DA isValidLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getDAList(1, 1);
        for (final tag in daVM1Tags) {
          expect(DA.isValidLength(tag, vList), true);
        }
      }
    });

    test('DA isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getDAList(2, i + 1);
        for (final tag in daVM1Tags) {
          global.throwOnError = false;
          expect(DA.isValidLength(tag, vList), false);

          global.throwOnError = true;
          expect(() => DA.isValidLength(tag, vList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
      global.throwOnError = false;
      final vList0 = rsg.getDAList(1, 1);
      expect(DA.isValidLength(null, vList0), false);

      expect(DA.isValidLength(PTag.kSelectorDAValue, null), isNull);

      global.throwOnError = true;
      expect(() => DA.isValidLength(null, vList0),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => DA.isValidLength(PTag.kSelectorDAValue, null),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('DA isValidLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getDAList(1, i);
        for (final tag in daVM1nTags) {
          log.debug('tag: $tag');
          expect(DA.isValidLength(tag, vList0), true);
        }
      }
    });

    test('DA isValidValue good values', () {
      global.throwOnError = false;
      for (final s in goodDAList) {
        for (final a in s) {
          expect(DA.isValidValue(a), true);
        }
      }
    });

    test('DA isValidValue bad values', () {
      global.throwOnError = false;
      for (final s in badDAList) {
        for (final a in s) {
          global.throwOnError = false;
          expect(DA.isValidValue(a), false);
        }
      }
    });

    test('DA isValidValues good values', () {
      global.throwOnError = false;
      for (final s in goodDAList) {
        expect(DA.isValidValues(PTag.kDate, s), true);
      }
    });

    test('DA isValidValues bad values', () {
      global.throwOnError = false;
      for (final s in badDAList) {
        global.throwOnError = false;
        expect(DA.isValidValues(PTag.kDate, s), false);

        global.throwOnError = true;
        expect(() => DA.isValidValues(PTag.kDate, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('DA isValidValues bad date values length', () {
      global.throwOnError = false;
      for (final s in badDALengthList) {
        global.throwOnError = false;
        expect(DA.isValidValues(PTag.kDate, s), false);

        global.throwOnError = true;
        expect(() => DA.isValidValues(PTag.kDate, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('DA isValidValues bad values length', () {
      global.throwOnError = false;
      for (final s in badDateValuesLengthList) {
        global.throwOnError = false;
        expect(DA.isValidValues(PTag.kDate, s), false);

        global.throwOnError = true;
        expect(() => DA.isValidValues(PTag.kDate, s),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('DA isValidValues VM.k1 good values length', () {
      for (var i = 0; i < 10; i++) {
        final validList = rsg.getDAList(1, 1);
        for (final tag in daVM1Tags) {
          global.throwOnError = false;
          expect(DA.isValidValues(tag, validList), true);
        }
      }
    });

    test('DA isValidValues VM.k1 bad values length', () {
      for (var i = 1; i < 10; i++) {
        final validList = rsg.getDAList(2, i + 1);
        for (final tag in daVM1Tags) {
          global.throwOnError = false;
          expect(DA.isValidValues(tag, validList), false);
          expect(DA.isValidValues(tag, invalidList), false);

          global.throwOnError = true;
          expect(() => DA.isValidValues(tag, validList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
          expect(() => DA.isValidValues(tag, invalidList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('DA isValidValues VM.k1_n length', () {
      for (var i = 1; i < 10; i++) {
        final validList = rsg.getDAList(1, i);
        for (final tag in daVM1nTags) {
          global.throwOnError = false;
          expect(DA.isValidValues(tag, validList), true);
        }
      }
    });

    test('DA getAsciiList', () {
      //    	system.level = Level.info;
      for (final s in goodDAList) {
        final bytes = Bytes.asciiFromList(s);
        log.debug('DA.getAsciiList(bytes): $bytes');
        expect(bytes.stringListFromAscii(), equals(s));
      }
    });

    test('DA toUint8List good values', () {
      for (final s in goodDAList) {
        log.debug('Bytes.fromAsciiList(s): ${Bytes.asciiFromList(s)}');

        if (s[0].length.isOdd) s[0] = '${s[0]} ';
        log.debug('s:"$s"');
        final values = cvt.ascii.encode(s[0]);
        expect(Bytes.asciiFromList(s), equals(values));
      }
    });

    test('DA toUint8List bad values length', () {
      global.throwOnError = false;
      final vList0 = rsg.getDAList(DA.kMaxVFLength + 1, DA.kMaxVFLength + 1);
      expect(vList0.length > DA.kMaxLength, true);
      final bytes = Bytes.asciiFromList(vList0);
      expect(bytes, isNotNull);
      expect(bytes.length > DA.kMaxVFLength, true);
      expect(DA.isValidBytesArgs(PTag.kSelectorDAValue, bytes), false);

      global.throwOnError = true;
      expect(() => DA.isValidBytesArgs(PTag.kSelectorDAValue, bytes),
          throwsA(const TypeMatcher<InvalidValueFieldError>()));
    });

    test('DA getAsciiList', () {
      final vList1 = ['19500712'];
      final bytes = Bytes.asciiFromList(vList1);
      log.debug('DA.getAsciiList(bytes): $bytes');
      expect(bytes.stringListFromAscii(), equals(vList1));
    });

    test('DA isValidValues good values', () {
      global.throwOnError = false;
      final vList0 = ['19500712'];
      expect(DA.isValidValues(PTag.kDate, vList0), true);

      for (final s in goodDAList) {
        global.throwOnError = false;
        expect(DA.isValidValues(PTag.kDate, s), true);
      }
    });

    test('DA isValidValues bad values', () {
      global.throwOnError = false;
      final vList1 = ['19503318'];
      expect(DA.isValidValues(PTag.kDate, vList1), false);

      global.throwOnError = true;
      expect(() => DA.isValidValues(PTag.kDate, vList1),
          throwsA(const TypeMatcher<StringError>()));

      for (final s in badDAList) {
        global.throwOnError = false;
        expect(DA.isValidValues(PTag.kDate, s), false);

        global.throwOnError = true;
        expect(() => DA.isValidValues(PTag.kDate, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('DA isValidValues random', () {
      global.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        expect(DA.isValidValues(PTag.kDate, vList0), true);
      }
    });

    test('DA toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        global.throwOnError = false;
        final values = cvt.ascii.encode(vList0[0]);
        final tbd0 = Bytes.asciiFromList(vList0);
        final tbd1 = Bytes.asciiFromList(vList0);
        log.debug('bd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (final s in goodDAList) {
        for (final a in s) {
          final values = cvt.ascii.encode(a);
          final tbd2 = Bytes.asciiFromList(s);
          final tbd3 = Bytes.asciiFromList(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('DA fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.asciiFromList(vList0);
        final fbd0 = bd0.stringListFromAscii();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (final s in goodDAList) {
        final bd0 = Bytes.asciiFromList(s);
        final fbd0 = bd0.stringListFromAscii();
        expect(fbd0, equals(s));
      }
    });

    test('DA toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.asciiFromList(vList0, kMaxShortVF);
        final bytes0 = Bytes.ascii(vList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (final s in goodDAList) {
        final toB1 = Bytes.asciiFromList(s, kMaxShortVF);
        final bytes1 = Bytes.ascii(s.join('\\'));
        log.debug('toBytes:$toB1, bytes1: $bytes1');
        expect(toB1, equals(bytes1));
      }

      global.throwOnError = false;
      final toB2 = Bytes.asciiFromList([''], kMaxShortVF);
      expect(toB2, equals(<String>[]));

      final toB3 = Bytes.asciiFromList([], kMaxShortVF);
      expect(toB3, equals(<String>[]));

      final toB4 = Bytes.asciiFromList(null, kMaxShortVF);
      expect(toB4, isNull);

      global.throwOnError = true;
      expect(() => Bytes.asciiFromList(null, kMaxShortVF),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('DA isValidBytesArgs', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getDAList(1, i);
        final vfBytes = Bytes.utf8FromList(vList0);

        if (vList0.length == 1) {
          for (final tag in daVM1Tags) {
            final e0 = DA.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else {
          for (final tag in daVM1nTags) {
            final e0 = DA.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        }
      }
      final vList0 = rsg.getDAList(1, 1);
      final vfBytes = Bytes.utf8FromList(vList0);

      final e1 = DA.isValidBytesArgs(null, vfBytes);
      expect(e1, false);

      final e2 = DA.isValidBytesArgs(PTag.kTime, vfBytes);
      expect(e2, false);

      final e3 = DA.isValidBytesArgs(PTag.kSelectorDAValue, null);
      expect(e3, false);

      global.throwOnError = true;
      expect(() => DA.isValidBytesArgs(null, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => DA.isValidBytesArgs(PTag.kTime, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));
    });
  });
}
