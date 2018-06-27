//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:convert';

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = new RSG(seed: 1);

void main() {
  // minYear and maxYear can be passed as an argument
  Server.initialize(
      name: 'string/as_test',
      level: Level.info,
      minYear: 0000,
      maxYear: 2100,
      throwOnError: false);
  global.throwOnError = false;

  const goodASList = const <List<String>>[
    // Note: 000D is valid, but others (000M...) are not.
    const <String>['000D'],
    const <String>['024Y'],
    const <String>['998Y'],
    const <String>['999Y'],
    const <String>['021D'],
    const <String>['120D'],
    const <String>['999D'],
    const <String>['005W'],
    const <String>['010W'],
    const <String>['999W'],
    const <String>['001M'],
    const <String>['011M'],
    const <String>['999M'],
  ];

  const badASList = const <List<String>>[
    const <String>[''],
    const <String>['000Y'],
    const <String>['000W'],
    const <String>['000M'],
    const <String>['1'],
    const <String>['A'],
    const <String>['1y'],
    const <String>['24Y'],
    const <String>['024A'],
    const <String>['024y'],
    const <String>['034d'],
    const <String>['023w'],
    const <String>['003m'],
    const <String>['1234'],
    const <String>['abcd'],
    const <String>['12ym'],
    const <String>['012Y7'],
    const <String>['012YU7'],
  ];

  group('ASTag', () {
    test('AS hasValidValues Element good values', () {
      for (var s in goodASList) {
        global.throwOnError = false;
        final e0 = new AStag(PTag.kPatientAge, s);
        log.debug('e0 $e0');
        expect(e0.hasValidValues, true);
      }
    });

    test('AS hasValidValues Element bad values', () {
      for (var s in badASList) {
        global.throwOnError = false;
        final e1 = new AStag(PTag.kPatientAge, s);
        expect(e1, isNull);

        global.throwOnError = true;
        expect(() => new AStag(PTag.kPatientAge, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('AS hasValidValues random good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        final e0 = new AStag(PTag.kPatientAge, vList0);
        log.debug('e0:$e0');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList();
        if (int.parse(vList0[0].substring(0, 3)) != 0) {
          log.debug('$i: vList0: $vList0');
          final e1 = new AStag(PTag.kPatientAge, vList0);
          expect(e1.hasValidValues, true);
        }
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1, 1, 50);
        final e0 = new AStag(PTag.kPatientAge, vList0);
        log.debug('e0:$e0');
        expect(e0.hasValidValues, true);
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(2, 5, 1, 99);
        final e0 = new AStag(PTag.kSelectorASValue, vList0);
        expect(e0, isNotNull);
        expect(e0.hasValidValues, true);
      }
    });

    test('AS hasValidValues random bad values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1, 1, 1000);
        final e0 = new AStag(PTag.kPatientAge, vList0);
        expect(e0, isNull);
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(2, 5, 1, 99);
        log.debug('vList0: $vList0');
        final e0 = new AStag(PTag.kPatientAge, vList0);
        log.debug('e0: $e0');
        expect(e0, isNull);
      }
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getASList(2, 5, 1, 1000);
        final e0 = new AStag(PTag.kSelectorASValue, vList0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => new AStag(PTag.kSelectorASValue, vList0),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('AS invalidLength random', () {
      //  system.level = Level.info;2;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(2, 5);
        global.throwOnError = false;
        expect(AS.isValidValues(PTag.kPatientAge, vList0), false);
        final e0 = new AStag(PTag.kPatientAge, vList0);
        log.debug('e0: $e0');
        expect(e0 == null, true);

        expect(new AStag(PTag.kPatientAge, vList0), isNull);
        global.throwOnError = true;
        expect(() => new AStag(PTag.kPatientAge, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('AS update random', () {
      //update
      global.throwOnError = false;
      final e0 = new AStag(PTag.kPatientAge, []);
      expect(e0.update(['778D']).values, equals(['778D']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList();
        log.debug('vList0: $vList0');

        final e1 = new AStag(PTag.kPatientAge, vList0);
        final vList1 = rsg.getASList(1, 1);
        log.debug('vList1: $vList1');
        expect(e1.update(vList1).values, equals(vList1));
      }
    });

    test('AS noValues random', () {
      //noValues
      final e0 = new AStag(PTag.kPatientAge, []);
      final AStag asNoValues = e0.noValues;
      expect(asNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        final e0 = new AStag(PTag.kPatientAge, vList0);
        log.debug('e0: $e0');
        expect(asNoValues.values.isEmpty, true);
        log.debug('e0: ${e0.noValues}');
      }
    });

    test('AS copy random', () {
      global.throwOnError = false;
      final e0 = new AStag(PTag.kPatientAge, []);
      final AStag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        final e2 = new AStag(PTag.kPatientAge, vList0);
        final AStag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('AS []', () {
      global.throwOnError = false;
      final e0 = new AStag(PTag.kPatientAge, []);
      expect(e0.hasValidValues, true);
      expect(e0.values, equals(<String>[]));

      final e1 = new AStag(PTag.kPatientAge);
      log.debug('e1: $e1');
      expect(e1.hasValidValues, true);
      expect(e1.values.isEmpty, true);
    });

    test('AS null', () {
      final e2 = new AStag(PTag.kPatientAge, null);
      expect(e2.isEmpty, true);
      expect(e2.values == kEmptyStringList, true);

      global.throwOnError = true;
      expect(() => new AStag(PTag.kPatientAge, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('AS hashCode and == good values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getASList(1, 1);
        final e0 = new AStag(PTag.kPatientAge, vList);
        final e1 = new AStag(PTag.kPatientAge, vList);
        log
          ..debug('vList:$vList, e0.hash_code:${e0.hashCode}')
          ..debug('vList:$vList, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('AS hashCode and == bad values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        final e0 = new AStag(PTag.kPatientAge, vList0);

        final vList1 = rsg.getASList(2, 3);
        final e3 = new AStag(PTag.kPatientAge, vList1);
        log.debug('vList1:$vList1 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);
      }
    });

    test('AS valuesCopy ranodm', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        log.debug('vList0: $vList0');
        final e0 = new AStag(PTag.kPatientAge, vList0);
        log.debug('e0: $e0');
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('AS checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        final e0 = new AStag(PTag.kPatientAge, vList0);
        expect(e0.checkLength(e0.values), true);
      }
    });

    test('AS nDays random', () {
      final vList1 = rsg.getASList(1, 1);
      final e1 = new AStag(PTag.kPatientAge, vList1);

      final vList2 = rsg.getASList(1, 1);
      log.debug('vList1: $vList1 vList2: $vList2');
      final e3 = new AStag(PTag.kPatientAge, vList2);
      log
        ..debug('e1: $e1 e3: $e3')
        ..debug('e1.hashCode: ${e1.hashCode} e3.hashCode: ${e3.hashCode}')
        ..debug('e1.nDays : ${e1.age.nDays } e3.nDays : ${e3.age.nDays }')
        ..debug('e1.nDays : ${e1.age.nDays } e3.nDays : ${e3.age.nDays }');
      expect(e1 == e3, false);
      expect(e1.hashCode == e3.hashCode, false);
    });

    test('AS isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        log.debug('vList0: $vList0');
        final e0 = new AStag(PTag.kPatientAge, vList0);
        expect(e0.hasValidValues, true);
      }
    });

    test('AS replace random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        final e0 = new AStag(PTag.kPatientAge, vList0);
        final vList1 = rsg.getASList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getASList(1, 1);
      log.debug('vList1: $vList1');
      final e1 = new AStag(PTag.kPatientAge, vList1);
      log.debug('e1: $e1');
      expect(e1.replace(<String>[]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = new AStag(PTag.kPatientAge, null);
      expect(e2, <String>[]);
      expect(e2, kEmptyStringList);
    });

    test('AS toUint8List random', () {
      //     system.level = Level.info;
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getASList(1, 1);
        //final bytes = encodeStringListValueField(vList1);
        log.debug('vList1: $vList1');
        final bytes = Bytes.fromAsciiList(vList1);
        log.debug('bytes:$bytes');
        final e0 = AStag.fromBytes(PTag.kPatientAge, bytes);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
      }
    });

    test('AS fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getASList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          final e1 = AStag.fromBytes(PTag.kSelectorASValue, bytes0);
          log.debug('e1: $e1');
          expect(e1.hasValidValues, true);
        }
      }
    });

    test('AS fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getASList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.fromAscii(listS);
          final e1 = AStag.fromBytes(PTag.kSelectorAEValue, bytes0);
          expect(e1, isNull);

          global.throwOnError = true;
          expect(() => AStag.fromBytes(PTag.kSelectorAEValue, bytes0),
              throwsA(const TypeMatcher<InvalidTagError>()));
        }
      }
    });

    test('AS checkLength good values', () {
      final vList0 = rsg.getASList(1, 1);
      final e0 = new AStag(PTag.kPatientAge, vList0);
      for (var s in goodASList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = new AStag(PTag.kPatientAge, vList0);
      expect(e1.checkLength(<String>[]), true);
    });

    test('AS checkLength bad values', () {
      final vList1 = ['000D', '024Y'];
      final vList0 = rsg.getASList(1, 1);
      final e2 = new AStag(PTag.kPatientAge, vList0);
      expect(e2.checkLength(vList1), false);
    });

    test('AS checkValue good values', () {
      final vList0 = rsg.getASList(1, 1);
      final e0 = new AStag(PTag.kPatientAge, vList0);
      for (var s in goodASList) {
        for (var a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });

    test('AS checkValue bad values', () {
      final vList0 = rsg.getASList(1, 1);
      final e0 = new AStag(PTag.kPatientAge, vList0);
      for (var s in badASList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(e0.checkValue(a), false);

          global.throwOnError = true;
          expect(() => e0.checkValue(a),
              throwsA(const TypeMatcher<StringError>()));
        }
      }
    });

    test('AS make good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        final make0 = AStag.fromValues(PTag.kPatientAge, vList0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);

        final make1 = AStag.fromValues(PTag.kPatientAge, <String>[]);
        expect(make1.hasValidValues, true);
        expect(make1.values, equals(<String>[]));
      }
    });

    test('AS make bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(2, 2);
        global.throwOnError = false;
        final e0 = AStag.fromValues(PTag.kPatientAge, vList0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => AStag.fromValues(PTag.kPatientAge, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final make1 = AStag.fromValues(PTag.kPatientAge, <String>[null]);
      log.debug('mak1: $make1');
      expect(make1, isNull);

      global.throwOnError = true;
      expect(() => AStag.fromValues(PTag.kPatientAge, <String>[null]),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });
  });

  group('AS Element', () {
    const badAgeLengthList = const <String>[
      //'',
      '1',
      'A',
      '1y',
      '24Y',
      '012Y7',
      '012YU7'
    ];

    //VM.k1
    const asVM1Tags = const <PTag>[PTag.kPatientAge];

    //VM.k1_n
    const asVM1_nTags = const <PTag>[PTag.kSelectorASValue];

    const otherTags = const <PTag>[
      PTag.kColumnAngulationPatient,
      PTag.kAcquisitionProtocolName,
      PTag.kCTDIvol,
      PTag.kCTPositionSequence,
      PTag.kAcquisitionType,
      PTag.kPerformedStationAETitle,
      PTag.kSelectorSTValue,
      PTag.kDate,
      PTag.kTime
    ];

    final invalidList = rsg.getASList(AS.kMaxVFLength + 1, AS.kMaxVFLength + 1);

    test('AS isValidTag good values', () {
      global.throwOnError = false;
      expect(AS.isValidTag(PTag.kSelectorASValue), true);

      for (var tag in asVM1Tags) {
        final validT0 = AS.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('AS isValidTag bad values', () {
      global.throwOnError = false;
      expect(AS.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => AS.isValidTag(PTag.kSelectorFDValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = AS.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => AS.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });
/*
    test('AS checkVRIndex good values', () {
      global.throwOnError = false;
      expect(AS.checkVRIndex(kASIndex), kASIndex);

      for (var tag in asTags0) {
        global.throwOnError = false;
        expect(AS.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('AS checkVRIndex bad values', () {
      global.throwOnError = false;
      expect(
          AS.checkVRIndex(
            kAEIndex,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => AS.checkVRIndex(kAEIndex),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(AS.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => AS.checkVRIndex(kAEIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('AS checkVRCode good values', () {
      global.throwOnError = false;
      expect(AS.checkVRCode(kASCode), kASCode);

      for (var tag in asTags0) {
        global.throwOnError = false;
        expect(AS.checkVRCode(tag.vrCode), tag.vrCode);
      }
    });

    test('AS checkVRCode bad values', () {
      global.throwOnError = false;
      expect(
          AS.checkVRCode(
            kAECode,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => AS.checkVRCode(kAECode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(AS.checkVRCode(tag.vrCode), isNull);

        global.throwOnError = true;
        expect(() => AS.checkVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

 */
    test('AS isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(AS.isValidVRIndex(kASIndex), true);

      for (var tag in asVM1Tags) {
        expect(AS.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('AS ValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(AS.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => AS.isValidVRIndex(kCSIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(AS.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => AS.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('AS isValidVRCode good values', () {
      global.throwOnError = false;
      expect(AS.isValidVRCode(kASCode), true);

      for (var tag in asVM1Tags) {
        expect(AS.isValidVRCode(tag.vrCode), true);
      }
    });

    test('AS isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(AS.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => AS.isValidVRCode(kAECode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(AS.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => AS.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('AS isValidVFLength good values', () {
      expect(AS.isValidVFLength(AS.kMaxVFLength), true);
      expect(AS.isValidVFLength(0), true);
    });

    test('AS isValidVFLength bad values', () {
      expect(AS.isValidVFLength(AS.kMaxVFLength), true);
      expect(AS.isValidVFLength(-1), false);
    });

    test('AS isValidValueLength good values', () {
      for (var i = 0; i < 10; i++) {
        for (var s in goodASList) {
          for (var a in s) {
            expect(AS.isValidValueLength(a), true);
          }
        }
      }
      expect(AS.isValidValueLength('001M'), true);
    });

    test('AS isValidValueLength bad values', () {
      global.throwOnError = false;
      for (var s in badAgeLengthList) {
        expect(AS.isValidValueLength(s), false);
      }
      expect(AS.isValidValueLength('00M'), false);
    });

    test('AS isValidLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getASList(1, 1);
        for (var tag in asVM1Tags) {
          expect(AS.isValidLength(tag, vList), true);
        }
      }
    });

    test('AS isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getASList(2, i + 1);
        for (var tag in asVM1Tags) {
          global.throwOnError = false;
          expect(AS.isValidLength(tag, vList), false);

          global.throwOnError = true;
          expect(() => AS.isValidLength(tag, vList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
      global.throwOnError = false;
      final vList0 = rsg.getASList(1, 1);
      expect(AS.isValidLength(null, vList0), false);

      expect(AS.isValidLength(PTag.kSelectorASValue, null), isNull);

      global.throwOnError = true;
      expect(() => AS.isValidLength(null, vList0),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => AS.isValidLength(PTag.kSelectorASValue, null),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('AS isValidLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getASList(1, i);
        for (var tag in asVM1_nTags) {
          log.debug('tag: $tag');
          expect(AS.isValidLength(tag, vList0), true);
        }
      }
    });

    test('AS isValidValue good values', () {
      for (var s in goodASList) {
        for (var a in s) {
          expect(AS.isValidValue(a), true);
        }
      }
    });

    test('AS isValidValue bad values', () {
      for (var s in badASList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(AS.isValidValue(a), false);

          global.throwOnError = true;
          expect(() => AS.isValidValue(a),
              throwsA(const TypeMatcher<StringError>()));
        }
      }
    });

    test('AS isValidValues good values', () {
      global.throwOnError = false;
      for (var s in goodASList) {
        expect(AS.isValidValues(PTag.kPatientAge, s), true);
      }
    });

    test('AS isValidValues bad values', () {
      global.throwOnError = false;
      for (var s in badASList) {
        global.throwOnError = false;
        expect(AS.isValidValues(PTag.kPatientAge, s), false);

        global.throwOnError = true;
        expect(() => AS.isValidValues(PTag.kPatientAge, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('AS isValidValues bad values length', () {
      global.throwOnError = false;
      final vList0 = rsg.getASList(3, 3);
      expect(AS.isValidValues(PTag.kPatientAge, vList0), false);

      global.throwOnError = true;
      expect(() => AS.isValidValues(PTag.kPatientAge, vList0),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('AS isValidValues VM.k1 good values length', () {
      for (var i = 0; i < 10; i++) {
        final validList = rsg.getASList(1, 1);
        for (var tag in asVM1Tags) {
          expect(AS.isValidValues(tag, validList), true);
        }
      }
    });

    test('AS isValidValues VM.k1 bad values length', () {
      for (var i = 1; i < 10; i++) {
        final validList = rsg.getASList(2, i + 1);
        for (var tag in asVM1Tags) {
          global.throwOnError = false;
          expect(AS.isValidValues(tag, validList), false);
          expect(AS.isValidValues(tag, invalidList), false);

          global.throwOnError = true;
          expect(() => AS.isValidValues(tag, validList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
          expect(() => AS.isValidValues(tag, invalidList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('AS isValidValues VM.k1_n Length', () {
      for (var i = 1; i < 10; i++) {
        final validList = rsg.getASList(1, i);
        for (var tag in asVM1_nTags) {
          global.throwOnError = false;
          expect(AS.isValidValues(tag, validList), true);
        }
      }
    });

    test('AS getAsciiList values', () {
      final vList0 = rsg.getASList(1, 1);
      final bytes = Bytes.fromAsciiList(vList0);
      log.debug('AS.getAsciiList(bytes): $bytes');
      expect(bytes.getAsciiList(), equals(vList0));
    });

    test('AS toUint8List good values', () {
      final vList1 = rsg.getASList(1, 1);
      log.debug('Bytes.fromAsciiList(vList1): ${Bytes.fromAsciiList(vList1)}');
      final values = ascii.encode(vList1[0]);
      expect(Bytes.fromAsciiList(vList1), equals(values));
    });

    test('AS toUint8List bad values length', () {
      global.throwOnError = false;
      final vList0 = rsg.getASList(AS.kMaxVFLength + 1, AS.kMaxVFLength + 1);
      expect(vList0.length > AS.kMaxLength, true);
      final bytes = Bytes.fromAsciiList(vList0);
      expect(bytes, isNotNull);
      expect(bytes.length > AS.kMaxVFLength, true);
      expect(AS.isValidBytesArgs(PTag.kSelectorASValue, bytes), false);
      
      global.throwOnError = true;
      expect(() => AS.isValidBytesArgs(PTag.kSelectorASValue, bytes),
          throwsA(const TypeMatcher<InvalidValueFieldError>()));
    });

    test('AS getAsciiList values', () {
      final vList1 = ['001M'];
      final bytes = Bytes.fromAsciiList(vList1);
      log.debug('AS.getAsciiList(bytes): $bytes');
      expect(bytes.getAsciiList(), equals(vList1));
    });

    test('AS isValidValues good values', () {
      global.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        expect(AS.isValidValues(PTag.kPatientAge, vList0), true);
      }
      final vList1 = ['024Y'];
      expect(AS.isValidValues(PTag.kPatientAge, vList1), true);

      for (var s in goodASList) {
        global.throwOnError = false;
        expect(AS.isValidValues(PTag.kPatientAge, s), true);
      }
    });

    test('AS isValidValues bad values', () {
      global.throwOnError = false;
      final vList2 = ['012Y7'];
      expect(AS.isValidValues(PTag.kPatientAge, vList2), false);

      global.throwOnError = true;
      expect(() => AS.isValidValues(PTag.kPatientAge, vList2),
          throwsA(const TypeMatcher<StringError>()));

      for (var s in badASList) {
        global.throwOnError = false;
        expect(AS.isValidValues(PTag.kPatientAge, s), false);

        global.throwOnError = true;
        expect(() => AS.isValidValues(PTag.kPatientAge, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('AS isValidValues bad values length', () {
      global.throwOnError = false;
      expect(AS.isValidValues(PTag.kPatientAge, badAgeLengthList), false);

      global.throwOnError = true;
      expect(() => AS.isValidValues(PTag.kPatientAge, badAgeLengthList),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('AS toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        global.throwOnError = false;
        final values = ascii.encode(vList0[0]);
        final tbd0 = Bytes.fromAsciiList(vList0);
        final tbd1 = Bytes.fromAsciiList(vList0);
        log.debug('bd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodASList) {
        for (var a in s) {
          final values = ascii.encode(a);
          final tbd2 = Bytes.fromAsciiList(s);
          final tbd3 = Bytes.fromAsciiList(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('AS fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.fromAsciiList(vList0);
        final fbd0 = bd0.getAsciiList();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (var s in goodASList) {
        final bd0 = Bytes.fromAsciiList(s);
        final fbd0 = bd0.getAsciiList();
        expect(fbd0, equals(s));
      }
    });

    test('AS toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.fromAsciiList(vList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(vList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodASList) {
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
