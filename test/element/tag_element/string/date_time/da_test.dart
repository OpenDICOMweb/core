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

RSG rsg = new RSG(seed: 1);

void main() {
  // minYear and maxYear can be passed as an argument
  Server.initialize(
      name: 'string/da_test',
      level: Level.info,
      minYear: 0000,
      maxYear: 2100,
      throwOnError: false);
  global.throwOnError = false;

  const goodDAList = const <List<String>>[
    const <String>['19930822'],
    const <String>['19930822'],
    const <String>['19500718'],
    const <String>['00000101'],
    const <String>['19700101'],
    const <String>['20171231'],
    const <String>['19931010'],
    //const <String>['19931010', '20171231'],
  ];

  const badDAList = const <List<String>>[
    const <String>['19501318'], // bad month
    const <String>['20041313'], // bad month
    const <String>['19804312'], //bad month
    const <String>['00000032'], // bad month and day
    const <String>['00000000'], //bad day
    const <String>['19800541'], // bad day
    const <String>['-9700101'], // bad character in year
    const <String>['1b700101'], // bad character in year
    const <String>['1970a101'], // bad character in year
    const <String>['19700b01'], // bad character in year
    const <String>['1970011a'], // bad character in month
    //const <String>['19931010', '20171231'],
  ];

  const badDALengthList = const <List<String>>[
    const <String>['1978123'], // invalid length
    const <String>['197812345'], // invalid length
    const <String>['201'],
    const <String>['2018'],
    const <String>['20156'],
    const <String>['199815'],
    const <String>['12'],
    const <String>['9']
  ];

  group('DA Tests', () {
    test('DA hasValidValues good values', () {
      for (var s in goodDAList) {
        global.throwOnError = false;
        log.debug('DA: "$s"');
        final e0 = new DAtag(PTag.kCreationDate, s);
        expect(e0.hasValidValues, true);
      }

      global.throwOnError = false;
      final e1 = new DAtag(PTag.kCreationDate, []);
      expect(e1.hasValidValues, true);
      expect(e1.values, equals(<String>[]));
    });

    test('DA hasValidValues for bad year, month, and day values', () {
      for (Iterable<String> s in badDAList) {
        global.throwOnError = false;
        final e1 = new DAtag(PTag.kCreationDate, s);
        expect(e1, isNull);

        global.throwOnError = true;
        expect(() => new DAtag(PTag.kCreationDate, s),
            throwsA(const TypeMatcher<StringError>()));
      }

      global.throwOnError = false;
      final e1 = new DAtag(PTag.kCreationDate, null);
      log.debug('e1: $e1');
      expect(e1.hasValidValues, true);
      expect(e1.values, StringList.kEmptyList);

      global.throwOnError = true;
      expect(() => new DAtag(PTag.kCreationDate, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('DA hasValidValues for bad value length', () {
      for (Iterable<String> s in badDALengthList) {
        global.throwOnError = false;
        final e1 = new DAtag(PTag.kCreationDate, s);
        expect(e1, isNull);

        global.throwOnError = true;
        expect(() => new DAtag(PTag.kCreationDate, s),
            throwsA(const TypeMatcher<StringError>()));
      }

      global.throwOnError = false;
      final e1 = new DAtag(PTag.kCreationDate, null);
      log.debug('e1: $e1');
      expect(e1.hasValidValues, true);
      expect(e1.values, StringList.kEmptyList);

      global.throwOnError = true;
      expect(() => new DAtag(PTag.kCreationDate, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('DA hasValidValues good values random', () {
      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        log.debug('vList0: $vList0');
        final e0 = new DAtag(PTag.kCreationDate, vList0);
        expect(e0.hasValidValues, true);
      }
    });

    test('DA hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getDAList(3, 4);
        log.debug('$i: vList0: $vList0');
        final e1 = new DAtag(PTag.kCreationDate, vList0);
        expect(e1, isNull);

        global.throwOnError = true;
        expect(() => new DAtag(PTag.kCreationDate, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('DA update', () {
      global.throwOnError = false;
      final e0 = new DAtag(PTag.kCreationDate, <String>[]);
      expect(e0, <String>[]);

      final e1 = new DAtag(PTag.kCreationDate, ['19930822']);
      final e2 = new DAtag(PTag.kCreationDate, ['19930822']);
      final e3 = e1.update(['20150822']);
      final e4 = e2.update(['20150822']);
      expect(e1.values.first == e4.values.first, false);
      expect(e1 == e4, false);
      expect(e2 == e4, false);
      expect(e3 == e4, true);

      for (var s in goodDAList) {
        final e5 = new DAtag(PTag.kCreationDate, s);
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
        final e0 = new DAtag(PTag.kCreationDate, vList0);
        final vList1 = rsg.getDAList(1, 1);
        expect(e0.update(vList1).values, equals(vList1));
      }
    });

    test('DA noValues', () {
      final e1 = new DAtag(PTag.kCreationDate, ['19930822']);
      final daNoValues1 = e1.noValues;
      expect(daNoValues1.values.isEmpty, true);
      log.debug('daNoValues1:$daNoValues1');

      for (var s in goodDAList) {
        final e1 = new DAtag(PTag.kCreationDate, s);
        final daNoValues1 = e1.noValues;
        expect(daNoValues1.values.isEmpty, true);
      }
    });

    test('DA noValues random ', () {
      final e0 = new DAtag(PTag.kCreationDate, <String>[]);
      final DAtag daNoValues0 = e0.noValues;
      expect(daNoValues0.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        final e0 = new DAtag(PTag.kCreationDate, vList0);
        log.debug('e0: $e0');
        expect(daNoValues0.values.isEmpty, true);
        log.debug('e0: ${e0.noValues}');
      }
    });

    test('DA copy', () {
      final e0 = new DAtag(PTag.kCreationDate, <String>[]);
      final DAtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      final e2 = new DAtag(PTag.kCreationDate, ['19930822']);
      final e3 = e2.copy;
      expect(e2 == e3, true);
      expect(e2.hashCode == e3.hashCode, true);

      for (var s in goodDAList) {
        final e4 = new DAtag(PTag.kCreationDate, s);
        final e5 = e4.copy;
        expect(e4 == e5, true);
        expect(e4.hashCode == e5.hashCode, true);
      }
      expect(utility.testElementCopy(e0), true);
    });

    test('DA copy random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        final e2 = new DAtag(PTag.kCreationDate, vList0);
        final DAtag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('DA hashCode and == good values', () {
      final vList0 = ['19930822'];
      final e0 = new DAtag(PTag.kCreationDate, vList0);
      final e1 = new DAtag(PTag.kCreationDate, vList0);
      log
        ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
        ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);
    });

    test('DA hashCode and == bad values', () {
      final vList0 = ['19930822'];
      final e0 = new DAtag(PTag.kCreationDate, vList0);
      final e2 = new DAtag(PTag.kStructureSetDate, vList0);
      log.debug('vList0:$vList0 , e2.hash_code:${e2.hashCode}');
      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);

      final e3 = new DAtag(PTag.kCalibrationDate, vList0);
      log.debug('vList0:$vList0 , e3.hash_code:${e3.hashCode}');
      expect(e0.hashCode == e3.hashCode, false);
      expect(e0 == e3, false);
    });

    test('DA hashCode and == good values random', () {
      global.throwOnError = false;
      List<String> stringList0;

      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getDAList(1, 1);
        final e0 = new DAtag(PTag.kPatientAge, stringList0);
        final e1 = new DAtag(PTag.kPatientAge, stringList0);
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
        final e0 = new DAtag(PTag.kPatientAge, stringList0);
        stringList1 = rsg.getDAList(2, 3);
        final e3 = new DAtag(PTag.kSelectorDAValue, stringList1);
        log.debug('stringList1:$stringList1 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);
      }
    });

    test('DA valuesCopy ranodm', () {
      for (var s in goodDAList) {
        final e0 = new DAtag(PTag.kCalibrationDate, s);
        expect(s, equals(e0.valuesCopy));
      }

      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        final e1 = new DAtag(PTag.kCreationDate, vList0);
        expect(vList0, equals(e1.valuesCopy));
      }
    });

    test('DA checkLength', () {
      for (var s in goodDAList) {
        final e0 = new DAtag(PTag.kCreationDate, s);
        expect(e0.checkLength(e0.values), true);
      }
    });

    test('DA checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        final e0 = new DAtag(PTag.kCreationDate, vList0);
        expect(e0.checkLength(e0.values), true);
      }
    });

    test('DA isValidValues good values', () {
      global.throwOnError = false;
      for (var s in goodDAList) {
        final e0 = new DAtag(PTag.kCreationDate, s);
        expect(e0.hasValidValues, true);
      }
    });

    test('DA isValidValues bad values', () {
      global.throwOnError = false;
      for (var s in badDAList) {
        global.throwOnError = false;
        final e0 = new DAtag(PTag.kCreationDate, s);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => new DAtag(PTag.kCreationDate, null),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('DA isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        final e0 = new DAtag(PTag.kCreationDate, vList0);
        expect(e0.hasValidValues, true);
      }
    });

    test('DA replace', () {
      global.throwOnError = false;

      final vList0 = ['19991025'];
      final e0 = new DAtag(PTag.kCreationDate, vList0);
      final vList1 = ['19001025'];
      expect(e0.replace(vList1), equals(vList0));
      expect(e0.values, equals(vList1));

      final e1 = new DAtag(PTag.kCreationDate, vList1);
      expect(e1.replace(<String>[]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = new DAtag(PTag.kCreationDate, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(StringList.kEmptyList));
    });

    test('DA replace random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        final e0 = new DAtag(PTag.kCreationDate, vList0);
        final vList1 = rsg.getDAList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getDAList(1, 1);
      final e1 = new DAtag(PTag.kCreationDate, vList1);
      expect(e1.replace(<String>[]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = new DAtag(PTag.kCreationDate, null);
      expect(e2.hasValidValues, true);
      expect(e2.values, StringList.kEmptyList);
    });

    test('DA getAsciiList', () {
      for (var s in goodDAList) {
        //final bytes = encodeStringListValueField(vList1);
        final bytes = Bytes.fromAsciiList(s);
        log.debug('bytes:$bytes');
        final e0 = DAtag.fromBytes(bytes, PTag.kCreationDate);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
      }
    });

    test('DA getAsciiList random', () {
      //    	system.level = Level.info;
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDAList(1, 1);
        final bytes = Bytes.fromAsciiList(vList1);
        log.debug('bytes:$bytes');
        final e0 = DAtag.fromBytes(bytes, PTag.kCreationDate);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
      }
    });

    test('DA fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDAList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          final e1 = DAtag.fromBytes(bytes0, PTag.kSelectorDAValue);
          log.debug('e1: $e1');
          expect(e1.hasValidValues, true);
        }
      }
    });

    test('DA fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDAList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.fromAscii(listS);
          final e1 = DAtag.fromBytes(bytes0, PTag.kSelectorAEValue);
          expect(e1, isNull);

          global.throwOnError = true;
          expect(() => DAtag.fromBytes(bytes0, PTag.kSelectorAEValue),
              throwsA(const TypeMatcher<InvalidTagError>()));
        }
      }
    });

    test('DA checkLength', () {
      global.throwOnError = false;
      final e0 = new DAtag(PTag.kCreationDate, ['19930822']);
      for (var s in goodDAList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = new DAtag(PTag.kCreationDate, ['19930822']);
      expect(e1.checkLength(<String>[]), true);

      final vList0 = ['20171206', '20181206'];
      final e2 = new DAtag(PTag.kPatientSize, vList0);
      expect(e2, isNull);
    });

    test('DA checkLength good values random', () {
      final vList0 = rsg.getDAList(1, 1);
      final e0 = new DAtag(PTag.kCreationDate, vList0);
      for (var s in goodDAList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = new DAtag(PTag.kCreationDate, vList0);
      expect(e1.checkLength(<String>[]), true);
    });

    test('DA checkLength bad values random', () {
      final vList1 = ['19980512', '20170412'];
      final vList0 = rsg.getDAList(1, 1);
      final e2 = new DAtag(PTag.kCreationDate, vList0);
      expect(e2.checkLength(vList1), false);
    });

    test('DA checkValue good values', () {
      final e0 = new DAtag(PTag.kCreationDate, ['19930822']);
      for (var s in goodDAList) {
        for (var a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });

    test('DA checkValue bad values', () {
      final e0 = new DAtag(PTag.kCreationDate, ['19930822']);
      for (var s in badDAList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(e0.checkValue(a), false);
        }
      }
    });

    test('DA checkValue good values random', () {
      global.throwOnError = false;
      final vList0 = rsg.getDAList(1, 1);
      final e0 = new DAtag(PTag.kCreationDate, vList0);
      for (var s in goodDAList) {
        for (var a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });
    test('DA checkValue bad values random', () {
      global.throwOnError = false;
      final vList0 = rsg.getDAList(1, 1);
      final e0 = new DAtag(PTag.kCreationDate, vList0);
      for (var s in badDAList) {
        for (var a in s) {
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
  });

  group('DA Element', () {
    const badDateValuesLengthList = const <List<String>>[
      const <String>['197812345', '1b700101'],
      const <String>['19800541', '1970011a'],
      const <String>['00000032', '19501318'],
    ];

    //VM.k1
    const daVM1Tags = const <PTag>[
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
    const daVM1_nTags = const <PTag>[
      PTag.kCalibrationDate,
      PTag.kDateOfLastCalibration,
      PTag.kSelectorDAValue,
    ];

    const otherTags = const <PTag>[
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

      for (var tag in daVM1Tags) {
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

      for (var tag in otherTags) {
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

      for (var tag in daVM1Tags) {
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

      for (var tag in otherTags) {
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

      for (var tag in daVM1Tags) {
        expect(DA.isValidVRCode(tag.vrCode), true);
      }
    });

    test('DA isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(DA.isValidVRCode(kSSCode), false);

      global.throwOnError = true;
      expect(() => DA.isValidVRCode(kSSCode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
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
      for (var s in goodDAList) {
        for (var a in s) {
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
        for (var tag in daVM1Tags) {
          expect(DA.isValidLength(tag, vList), true);
        }
      }
    });

    test('DA isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getDAList(2, i + 1);
        for (var tag in daVM1Tags) {
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
        for (var tag in daVM1_nTags) {
          log.debug('tag: $tag');
          expect(DA.isValidLength(tag, vList0), true);
        }
      }
    });

    test('DA isValidValue good values', () {
      global.throwOnError = false;
      for (var s in goodDAList) {
        for (var a in s) {
          expect(DA.isValidValue(a), true);
        }
      }
    });

    test('DA isValidValue bad values', () {
      global.throwOnError = false;
      for (var s in badDAList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(DA.isValidValue(a), false);
        }
      }
    });

    test('DA isValidValues good values', () {
      global.throwOnError = false;
      for (var s in goodDAList) {
        expect(DA.isValidValues(PTag.kDate, s), true);
      }
    });

    test('DA isValidValues bad values', () {
      global.throwOnError = false;
      for (var s in badDAList) {
        global.throwOnError = false;
        expect(DA.isValidValues(PTag.kDate, s), false);

        global.throwOnError = true;
        expect(() => DA.isValidValues(PTag.kDate, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('DA isValidValues bad date value length', () {
      global.throwOnError = false;
      for (var s in badDALengthList) {
        global.throwOnError = false;
        expect(DA.isValidValues(PTag.kDate, s), false);

        global.throwOnError = true;
        expect(() => DA.isValidValues(PTag.kDate, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('DA isValidValues bad values length', () {
      global.throwOnError = false;
      for (var s in badDateValuesLengthList) {
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
        for (var tag in daVM1Tags) {
          global.throwOnError = false;
          expect(DA.isValidValues(tag, validList), true);
        }
      }
    });

    test('DA isValidValues VM.k1 bad values length', () {
      for (var i = 1; i < 10; i++) {
        final validList = rsg.getDAList(2, i + 1);
        for (var tag in daVM1Tags) {
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
        for (var tag in daVM1_nTags) {
          global.throwOnError = false;
          expect(DA.isValidValues(tag, validList), true);
        }
      }
    });

    test('DA getAsciiList', () {
      //    	system.level = Level.info;
      for (var s in goodDAList) {
        final bytes = Bytes.fromAsciiList(s);
        log.debug('DA.getAsciiList(bytes): $bytes');
        expect(bytes.getAsciiList(), equals(s));
      }
    });

    test('DA toUint8List good values', () {
      for (var s in goodDAList) {
        log.debug('Bytes.fromAsciiList(s): ${Bytes.fromAsciiList(s)}');

        if (s[0].length.isOdd) s[0] = '${s[0]} ';
        log.debug('s:"$s"');
        final values = cvt.ascii.encode(s[0]);
        expect(Bytes.fromAsciiList(s), equals(values));
      }
    });

    test('DA toUint8List bad values length', () {
      global.throwOnError = false;
      final vList0 = rsg.getDAList(DA.kMaxVFLength + 1, DA.kMaxVFLength + 1);
      expect(vList0.length > DA.kMaxLength, true);
      final bytes = Bytes.fromAsciiList(vList0);
      expect(bytes, isNotNull);
      expect(bytes.length > DA.kMaxVFLength, true);
      expect(DA.isValidBytesArgs(PTag.kSelectorDAValue, bytes), false);

      global.throwOnError = true;
      expect(() => DA.isValidBytesArgs(PTag.kSelectorDAValue, bytes),
                 throwsA(const TypeMatcher<InvalidValueFieldError>()));
    });

    test('DA getAsciiList', () {
      final vList1 = ['19500712'];
      final bytes = Bytes.fromAsciiList(vList1);
      log.debug('DA.getAsciiList(bytes): $bytes');
      expect(bytes.getAsciiList(), equals(vList1));
    });

    test('DA isValidValues good values', () {
      global.throwOnError = false;
      final vList0 = ['19500712'];
      expect(DA.isValidValues(PTag.kDate, vList0), true);

      for (var s in goodDAList) {
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

      for (var s in badDAList) {
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
        final tbd0 = Bytes.fromAsciiList(vList0);
        final tbd1 = Bytes.fromAsciiList(vList0);
        log.debug('bd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodDAList) {
        for (var a in s) {
          final values = cvt.ascii.encode(a);
          final tbd2 = Bytes.fromAsciiList(s);
          final tbd3 = Bytes.fromAsciiList(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('DA fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.fromAsciiList(vList0);
        final fbd0 = bd0.getAsciiList();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (var s in goodDAList) {
        final bd0 = Bytes.fromAsciiList(s);
        final fbd0 = bd0.getAsciiList();
        expect(fbd0, equals(s));
      }
    });

    test('DA toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.fromAsciiList(vList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(vList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodDAList) {
        final toB1 = Bytes.fromAsciiList(s, kMaxShortVF);
        final bytes1 = Bytes.fromAscii(s.join('\\'));
        log.debug('toBytes:$toB1, bytes1: $bytes1');
        expect(toB1, equals(bytes1));
      }

      global.throwOnError = false;
      final toB2 = Bytes.fromAsciiList([''], kMaxShortVF);
      expect(toB2, equals(<String>[]));

      final toB3 = Bytes.fromAsciiList([], kMaxShortVF);
      expect(toB3, equals(<String>[]));

      final toB4 = Bytes.fromAsciiList(null, kMaxShortVF);
      expect(toB4, isNull);

      global.throwOnError = true;
      expect(() => Bytes.fromAsciiList(null, kMaxShortVF),
          throwsA(const TypeMatcher<GeneralError>()));
    });
  });
}
