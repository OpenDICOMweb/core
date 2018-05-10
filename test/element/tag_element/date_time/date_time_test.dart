//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:convert' as cvt;

import 'package:core/server.dart';
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

import '../string/utility_test.dart' as utility;

RSG rsg = new RSG(seed: 1);

void main() {
  // minYear and maxYear can be passed as an argument
  Server.initialize(
      name: 'string/date_time_test',
      level: Level.debug,
      minYear: 0000,
      maxYear: 2100,
      throwOnError: false);

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
        final as0 = new AStag(PTag.kPatientAge, s);
        log.debug('as0 $as0');
        expect(as0.hasValidValues, true);
      }
    });

    test('AS hasValidValues Element bad values', () {
      for (var s in badASList) {
        global.throwOnError = false;
        final as1 = new AStag(PTag.kPatientAge, s);
        expect(as1, isNull);

        global.throwOnError = true;
        expect(() => new AStag(PTag.kPatientAge, s),
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('AS hasValidValues random good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        final as0 = new AStag(PTag.kPatientAge, vList0);
        log.debug('as0:${as0.info}');
        expect(as0.hasValidValues, true);

        log
          ..debug('as0: $as0, values: ${as0.values}')
          ..debug('as0: ${as0.info}');
        expect(as0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList();
        if (int.parse(vList0[0].substring(0, 3)) != 0) {
          log.debug('$i: vList0: $vList0');
          final as1 = new AStag(PTag.kPatientAge, vList0);
          expect(as1.hasValidValues, true);
        }
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1, 1, 50);
        final as0 = new AStag(PTag.kPatientAge, vList0);
        log.debug('as0:${as0.info}');
        expect(as0.hasValidValues, true);
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(2, 5, 1, 99);
        final as0 = new AStag(PTag.kSelectorASValue, vList0);
        expect(as0, isNotNull);
        expect(as0.hasValidValues, true);
      }
    });

    test('AS hasValidValues random bad values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1, 1, 1000);
        final as0 = new AStag(PTag.kPatientAge, vList0);
        expect(as0, isNull);
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(2, 5, 1, 99);
        log.debug('vList0: $vList0');
        final as0 = new AStag(PTag.kPatientAge, vList0);
        log.debug('as0: $as0');
        expect(as0, isNull);
      }
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getASList(2, 5, 1, 1000);
        final as0 = new AStag(PTag.kSelectorASValue, vList0);
        expect(as0, isNull);

        global.throwOnError = true;
        expect(() => new AStag(PTag.kSelectorASValue, vList0),
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('AS invalidLength random', () {
      //  system.level = Level.info;2;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(2, 5);
        global.throwOnError = false;
        expect(AS.isValidValues(PTag.kPatientAge, vList0), false);
        final as0 = new AStag(PTag.kPatientAge, vList0);
        log.debug('as0: $as0');
        expect(as0 == null, true);

        expect(new AStag(PTag.kPatientAge, vList0), isNull);
        global.throwOnError = true;
        expect(() => new AStag(PTag.kPatientAge, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('AS update random', () {
      //update
      global.throwOnError = false;
      final as0 = new AStag(PTag.kPatientAge, []);
      expect(as0.update(['778D']).values, equals(['778D']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList();
        log.debug('vList0: $vList0');

        final as1 = new AStag(PTag.kPatientAge, vList0);
        final vList1 = rsg.getASList(1, 1);
        log.debug('vList1: $vList1');
        expect(as1.update(vList1).values, equals(vList1));
      }
    });

    test('AS noValues random', () {
      //noValues
      final as0 = new AStag(PTag.kPatientAge, []);
      final AStag asNoValues = as0.noValues;
      expect(asNoValues.values.isEmpty, true);
      log.debug('as0: ${as0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        final as0 = new AStag(PTag.kPatientAge, vList0);
        log.debug('as0: $as0');
        expect(asNoValues.values.isEmpty, true);
        log.debug('as0: ${as0.noValues}');
      }
    });

    test('AS copy random', () {
      global.throwOnError = false;
      final as0 = new AStag(PTag.kPatientAge, []);
      final AStag as1 = as0.copy;
      expect(as1 == as0, true);
      expect(as1.hashCode == as0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        final as2 = new AStag(PTag.kPatientAge, vList0);
        final AStag as3 = as2.copy;
        expect(as3 == as2, true);
        expect(as3.hashCode == as2.hashCode, true);
      }
    });

    test('AS []', () {
      global.throwOnError = false;
      final as0 = new AStag(PTag.kPatientAge, []);
      expect(as0.hasValidValues, true);
      expect(as0.values, equals(<String>[]));

      final as1 = new AStag(PTag.kPatientAge);
      log.debug('as1: $as1');
      expect(as1.hasValidValues, true);
      expect(as1.values.isEmpty, true);
    });

    test('AS null', () {
      final as2 = new AStag(PTag.kPatientAge, null);
      expect(as2, isNull);

      global.throwOnError = true;
      expect(() => new AStag(PTag.kPatientAge, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('AS hashCode and == good values random', () {
      global.throwOnError = false;
      List<String> stringList0;

      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getASList(1, 1);
        final as0 = new AStag(PTag.kPatientAge, stringList0);
        final as1 = new AStag(PTag.kPatientAge, stringList0);
        log
          ..debug('stringList0:$stringList0, as0.hash_code:${as0.hashCode}')
          ..debug('stringList0:$stringList0, as1.hash_code:${as1.hashCode}');
        expect(as0.hashCode == as1.hashCode, true);
        expect(as0 == as1, true);
      }
    });

    test('AS hashCode and == bad values random', () {
      global.throwOnError = false;
      List<String> stringList0;
      List<String> stringList1;

      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getASList(1, 1);
        final as0 = new AStag(PTag.kPatientAge, stringList0);

        stringList1 = rsg.getASList(2, 3);
        final as3 = new AStag(PTag.kPatientAge, stringList1);
        log.debug('stringList1:$stringList1 , as3.hash_code:${as3.hashCode}');
        expect(as0.hashCode == as3.hashCode, false);
        expect(as0 == as3, false);
      }
    });

    test('AS valuesCopy ranodm', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        log.debug('vList0: $vList0');
        final as0 = new AStag(PTag.kPatientAge, vList0);
        log.debug('as0: $as0');
        expect(vList0, equals(as0.valuesCopy));
      }
    });

    test('AS isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        final as0 = new AStag(PTag.kPatientAge, vList0);
        expect(as0.checkLength(as0.values), true);
      }
    });

    test('AS nDays random', () {
      final vList1 = rsg.getASList(1, 1);
      final as1 = new AStag(PTag.kPatientAge, vList1);

      final vList2 = rsg.getASList(1, 1);
      log.debug('vList1: $vList1 vList2: $vList2');
      final as3 = new AStag(PTag.kPatientAge, vList2);
      log
        ..debug('as1: $as1 as3: $as3')
        ..debug('as1.hashCode: ${as1.hashCode} as3.hashCode: ${as3.hashCode}')
        ..debug('as1.nDays : ${as1.age.nDays } as3.nDays : ${as3.age.nDays }')
        ..debug('as1.nDays : ${as1.age.nDays } as3.nDays : ${as3.age.nDays }');
      expect(as1 == as3, false);
      expect(as1.hashCode == as3.hashCode, false);
    });

    test('AS isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        log.debug('vList0: $vList0');
        final as0 = new AStag(PTag.kPatientAge, vList0);
        expect(as0.hasValidValues, true);
      }
    });

    test('AS replace random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        final as0 = new AStag(PTag.kPatientAge, vList0);
        final vList1 = rsg.getASList(1, 1);
        expect(as0.replace(vList1), equals(vList0));
        expect(as0.values, equals(vList1));
      }

      final vList1 = rsg.getASList(1, 1);
      log.debug('vList1: $vList1');
      final as1 = new AStag(PTag.kPatientAge, vList1);
      log.debug('as1: $as1');
      expect(as1.replace(<String>[]), equals(vList1));
      expect(as1.values, equals(<String>[]));

      final as2 = new AStag(PTag.kPatientAge, null);
      expect(as2, isNull);
    });

    test('AS toUint8List random', () {
      //     system.level = Level.info;
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getASList(1, 1);
        //final bytes = encodeStringListValueField(vList1);
        final bytes = Bytes.fromAsciiList(vList1);
        log.debug('bytes:$bytes');
        final as0 = AStag.fromBytes(PTag.kPatientAge, bytes);
        log.debug('as0: ${as0.info}');
        expect(as0.hasValidValues, true);
      }
    });

    test('AS fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getASList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          final as1 = AStag.fromBytes(PTag.kSelectorASValue, bytes0);
          log.debug('as1: ${as1.info}');
          expect(as1.hasValidValues, true);
        }
      }
    });

    test('AS fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getASList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.fromAscii(listS);
          final as1 = AStag.fromBytes(PTag.kSelectorAEValue, bytes0);
          expect(as1, isNull);

          global.throwOnError = true;
          expect(() => AStag.fromBytes(PTag.kSelectorAEValue, bytes0),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      }
    });

    test('AS checkLength good values', () {
      final vList0 = rsg.getASList(1, 1);
      final as0 = new AStag(PTag.kPatientAge, vList0);
      for (var s in goodASList) {
        expect(as0.checkLength(s), true);
      }
      final as1 = new AStag(PTag.kPatientAge, vList0);
      expect(as1.checkLength(<String>[]), true);
    });

    test('AS checkLength bad values', () {
      final vList1 = ['000D', '024Y'];
      final vList0 = rsg.getASList(1, 1);
      final as2 = new AStag(PTag.kPatientAge, vList0);
      expect(as2.checkLength(vList1), false);
    });

    test('AS checkValue good values', () {
      final vList0 = rsg.getASList(1, 1);
      final as0 = new AStag(PTag.kPatientAge, vList0);
      for (var s in goodASList) {
        for (var a in s) {
          expect(as0.checkValue(a), true);
        }
      }
    });

    test('AS checkValue bad values', () {
      final vList0 = rsg.getASList(1, 1);
      final as0 = new AStag(PTag.kPatientAge, vList0);
      for (var s in badASList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(as0.checkValue(a), false);

          global.throwOnError = true;
          expect(() => as0.checkValue(a),
              throwsA(const isInstanceOf<StringError>()));
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
        final make0 = AStag.fromValues(PTag.kPatientAge, vList0);
        expect(make0, isNull);

        global.throwOnError = true;
        expect(() => AStag.fromValues(PTag.kPatientAge, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final make1 = AStag.fromValues(PTag.kPatientAge, <String>[null]);
      log.debug('mak1: $make1');
      expect(make1, isNull);

      global.throwOnError = true;
      expect(() => AStag.fromValues(PTag.kPatientAge, <String>[null]),
          throwsA(const isInstanceOf<StringError>()));
    });
  });

  group('AS Element', () {
    const badAgeLengthList = const <String>[
      '',
      '1',
      'A',
      '1y',
      '24Y',
      '012Y7',
      '012YU7'
    ];

    //VM.k1
    const asTags0 = const <PTag>[PTag.kPatientAge];

    //VM.k1_n
    const asTags1 = const <PTag>[PTag.kSelectorASValue];

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

      for (var tag in asTags0) {
        final validT0 = AS.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('AS isValidTag bad values', () {
      global.throwOnError = false;
      expect(AS.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => AS.isValidTag(PTag.kSelectorFDValue),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = AS.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => AS.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

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
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(AS.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => AS.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
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
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(AS.checkVRCode(tag.vrCode), isNull);

        global.throwOnError = true;
        expect(() => AS.checkVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('AS isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(AS.isValidVRIndex(kASIndex), true);

      for (var tag in asTags0) {
        expect(AS.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('AS ValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(AS.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => AS.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(AS.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => AS.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('AS isValidVRCode good values', () {
      global.throwOnError = false;
      expect(AS.isValidVRCode(kASCode), true);

      for (var tag in asTags0) {
        expect(AS.isValidVRCode(tag.vrCode), true);
      }
    });

    test('AS isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(AS.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => AS.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(AS.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => AS.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
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

    test('AS isNotValidVFLength good values', () {
      expect(AS.isNotValidVFLength(AS.kMaxVFLength), false);
      expect(AS.isNotValidVFLength(-1), true);
    });

    test('AS isNotValidVFLength bad values', () {
      expect(AS.isNotValidVFLength(AS.kMaxVFLength), false);
      expect(AS.isNotValidVFLength(0), false);
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
      for (var s in badAgeLengthList) {
        expect(AS.isValidValueLength(s), false);
      }
      expect(AS.isValidValueLength('00M'), false);
    });

    test('AS isNotValidValueLength good values', () {
      for (var s in goodASList) {
        for (var a in s) {
          expect(AS.isNotValidValueLength(a), false);
        }
      }
      expect(AS.isNotValidValueLength('001M'), false);
    });

    test('AS isNotValidValueLength bad values', () {
      for (var s in badAgeLengthList) {
        expect(AS.isNotValidValueLength(s), true);
      }
      expect(AS.isNotValidValueLength('00M'), true);
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
              throwsA(const isInstanceOf<StringError>()));
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
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('AS isValidValues bad values length', () {
      global.throwOnError = false;
      final vList0 = rsg.getASList(3, 3);
      expect(AS.isValidValues(PTag.kPatientAge, vList0), false);

      global.throwOnError = true;
      expect(() => AS.isValidValues(PTag.kPatientAge, vList0),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('AS isValidValues VM.k1 good values length', () {
      for (var i = 0; i < 10; i++) {
        final validList = rsg.getASList(1, 1);
        for (var tag in asTags0) {
          expect(AS.isValidValues(tag, validList), true);
        }
      }
    });

    test('AS isValidValues VM.k1 bad values length', () {
      for (var i = 1; i < 10; i++) {
        final validList = rsg.getASList(2, i + 1);
        for (var tag in asTags0) {
          global.throwOnError = false;
          expect(AS.isValidValues(tag, validList), false);
          expect(AS.isValidValues(tag, invalidList), false);

          global.throwOnError = true;
          expect(() => AS.isValidValues(tag, validList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
          expect(() => AS.isValidValues(tag, invalidList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('AS isValidValues VM.k1_n Length', () {
      for (var i = 1; i < 10; i++) {
        final validList = rsg.getASList(1, i);
        for (var tag in asTags1) {
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
      final values = cvt.ascii.encode(vList1[0]);
      expect(Bytes.fromAsciiList(vList1), equals(values));
    });

    test('AS toUint8List bad values length', () {
      global.throwOnError = false;
      final vList0 = rsg.getASList(AS.kMaxVFLength + 1, AS.kMaxVFLength + 1);
      expect(Bytes.fromAsciiList(vList0), isNull);
      global.throwOnError = true;
      expect(() => Bytes.fromAsciiList(vList0),
          throwsA(const isInstanceOf<InvalidValueFieldError>()));
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
        expect(AS.isValidValues(PTag.kPatientAge, vList0), vList0);
      }
      final vList1 = ['024Y'];
      expect(AS.isValidValues(PTag.kPatientAge, vList1), vList1);

      for (var s in goodASList) {
        global.throwOnError = false;
        expect(AS.isValidValues(PTag.kPatientAge, s), s);
      }
    });

    test('AS isValidValues bad values', () {
      global.throwOnError = false;
      final vList2 = ['012Y7'];
      expect(AS.isValidValues(PTag.kPatientAge, vList2), isNull);

      global.throwOnError = true;
      expect(() => AS.isValidValues(PTag.kPatientAge, vList2),
          throwsA(const isInstanceOf<StringError>()));

      for (var s in badASList) {
        global.throwOnError = false;
        expect(AS.isValidValues(PTag.kPatientAge, s), isNull);

        global.throwOnError = true;
        expect(() => AS.isValidValues(PTag.kPatientAge, s),
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('AS isValidValues bad values length', () {
      global.throwOnError = false;
      expect(AS.isValidValues(PTag.kPatientAge, badAgeLengthList), isNull);

      global.throwOnError = true;
      expect(() => AS.isValidValues(PTag.kPatientAge, badAgeLengthList),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('AS toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        global.throwOnError = false;
        final values = cvt.ascii.encode(vList0[0]);
        final tbd0 = Bytes.fromAsciiList(vList0);
        final tbd1 = Bytes.fromAsciiList(vList0);
        log.debug('bd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodASList) {
        for (var a in s) {
          final values = cvt.ascii.encode(a);
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
        final sList0 = rsg.getASList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.fromAsciiList(sList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(sList0.join('\\'));
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
          throwsA(const isInstanceOf<GeneralError>()));
    });
  });

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
        final da0 = new DAtag(PTag.kCreationDate, s);
        expect(da0.hasValidValues, true);
      }

      global.throwOnError = false;
      final da1 = new DAtag(PTag.kCreationDate, []);
      expect(da1.hasValidValues, true);
      expect(da1.values, equals(<String>[]));
    });

    test('DA hasValidValues for bad year, month, and day values', () {
      for (Iterable<String> s in badDAList) {
        global.throwOnError = false;
        final da1 = new DAtag(PTag.kCreationDate, s);
        expect(da1, isNull);

        global.throwOnError = true;
        print('s: $s');
        expect(() => new DAtag(PTag.kCreationDate, s),
            throwsA(const isInstanceOf<StringError>()));
      }

      global.throwOnError = false;
      final da1 = new DAtag(PTag.kCreationDate, null);
      log.debug('da1: $da1');
      expect(da1, isNull);

      global.throwOnError = true;
      expect(() => new DAtag(PTag.kCreationDate, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('DA hasValidValues for bad value length', () {
      for (Iterable<String> s in badDALengthList) {
        global.throwOnError = false;
        final da1 = new DAtag(PTag.kCreationDate, s);
        expect(da1, isNull);

        global.throwOnError = true;
        print('s: $s');
        expect(() => new DAtag(PTag.kCreationDate, s),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final da1 = new DAtag(PTag.kCreationDate, null);
      log.debug('da1: $da1');
      expect(da1, isNull);

      global.throwOnError = true;
      expect(() => new DAtag(PTag.kCreationDate, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('DA hasValidValues good values random', () {
      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        log.debug('vList0: $vList0');
        final da0 = new DAtag(PTag.kCreationDate, vList0);
        expect(da0.hasValidValues, true);
      }
    });

    test('DA hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getDAList(3, 4);
        log.debug('$i: vList0: $vList0');
        final da1 = new DAtag(PTag.kCreationDate, vList0);
        expect(da1, isNull);

        global.throwOnError = true;
        expect(() => new DAtag(PTag.kCreationDate, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('DA update', () {
      global.throwOnError = false;
      final da0 = new DAtag(PTag.kCreationDate, <String>[]);
      expect(da0, <String>[]);

      final da1 = new DAtag(PTag.kCreationDate, ['19930822']);
      final da2 = new DAtag(PTag.kCreationDate, ['19930822']);
      final da3 = da1.update(['20150822']);
      final da4 = da2.update(['20150822']);
      expect(da1.values.first == da4.values.first, false);
      expect(da1 == da4, false);
      expect(da2 == da4, false);
      expect(da3 == da4, true);

      for (var s in goodDAList) {
        final da5 = new DAtag(PTag.kCreationDate, s);
        final da6 = da5.update(['20150817']);
        final da7 = da5.update(['20150817']);
        expect(da5.values.first == da6.values.first, false);
        expect(da5 == da6, false);
        expect(da6 == da7, true);
      }
      expect(utility.testElementUpdate(da1, <String>['19930822']), true);
    });

    test('DA update random', () {
      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        final da0 = new DAtag(PTag.kCreationDate, vList0);
        final vList1 = rsg.getDAList(1, 1);
        expect(da0.update(vList1).values, equals(vList1));
      }
    });

    test('DA noValues', () {
      final da1 = new DAtag(PTag.kCreationDate, ['19930822']);
      final daNoValues1 = da1.noValues;
      expect(daNoValues1.values.isEmpty, true);
      log.debug('daNoValues1:$daNoValues1');

      for (var s in goodDAList) {
        final da1 = new DAtag(PTag.kCreationDate, s);
        final daNoValues1 = da1.noValues;
        expect(daNoValues1.values.isEmpty, true);
      }
    });

    test('DA noValues random ', () {
      final da0 = new DAtag(PTag.kCreationDate, <String>[]);
      final DAtag daNoValues0 = da0.noValues;
      expect(daNoValues0.values.isEmpty, true);
      log.debug('da0: ${da0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        final da0 = new DAtag(PTag.kCreationDate, vList0);
        log.debug('da0: $da0');
        expect(daNoValues0.values.isEmpty, true);
        log.debug('da0: ${da0.noValues}');
      }
    });

    test('DA copy', () {
      final da0 = new DAtag(PTag.kCreationDate, <String>[]);
      final DAtag da1 = da0.copy;
      expect(da1 == da0, true);
      expect(da1.hashCode == da0.hashCode, true);

      final da2 = new DAtag(PTag.kCreationDate, ['19930822']);
      final da3 = da2.copy;
      expect(da2 == da3, true);
      expect(da2.hashCode == da3.hashCode, true);

      for (var s in goodDAList) {
        final da4 = new DAtag(PTag.kCreationDate, s);
        final da5 = da4.copy;
        expect(da4 == da5, true);
        expect(da4.hashCode == da5.hashCode, true);
      }
      expect(utility.testElementCopy(da0), true);
    });

    test('DA copy random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        final da2 = new DAtag(PTag.kCreationDate, vList0);
        final DAtag da3 = da2.copy;
        expect(da3 == da2, true);
        expect(da3.hashCode == da2.hashCode, true);
      }
    });

    test('DA hashCode and == good values', () {
      final vList0 = ['19930822'];
      final da0 = new DAtag(PTag.kCreationDate, vList0);
      final da1 = new DAtag(PTag.kCreationDate, vList0);
      log
        ..debug('vList0:$vList0, da0.hash_code:${da0.hashCode}')
        ..debug('vList0:$vList0, da1.hash_code:${da1.hashCode}');
      expect(da0.hashCode == da1.hashCode, true);
      expect(da0 == da1, true);
    });

    test('DA hashCode and == bad values', () {
      final vList0 = ['19930822'];
      final da0 = new DAtag(PTag.kCreationDate, vList0);
      final da2 = new DAtag(PTag.kStructureSetDate, vList0);
      log.debug('vList0:$vList0 , da2.hash_code:${da2.hashCode}');
      expect(da0.hashCode == da2.hashCode, false);
      expect(da0 == da2, false);

      final da3 = new DAtag(PTag.kCalibrationDate, vList0);
      log.debug('vList0:$vList0 , da3.hash_code:${da3.hashCode}');
      expect(da0.hashCode == da3.hashCode, false);
      expect(da0 == da3, false);
    });

    test('DA hashCode and == good values random', () {
      global.throwOnError = false;
      List<String> stringList0;

      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getDAList(1, 1);
        final da0 = new DAtag(PTag.kPatientAge, stringList0);
        final da1 = new DAtag(PTag.kPatientAge, stringList0);
        log
          ..debug('stringList0:$stringList0, da0.hash_code:${da0.hashCode}')
          ..debug('stringList0:$stringList0, da1.hash_code:${da1.hashCode}');
        expect(da0.hashCode == da1.hashCode, true);
        expect(da0 == da1, true);
      }
    });

    test('DA hashCode and == bad values random', () {
      global.throwOnError = false;
      List<String> stringList0;
      List<String> stringList1;

      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getDAList(1, 1);
        final da0 = new DAtag(PTag.kPatientAge, stringList0);
        stringList1 = rsg.getDAList(2, 3);
        final da3 = new DAtag(PTag.kSelectorDAValue, stringList1);
        log.debug('stringList1:$stringList1 , da3.hash_code:${da3.hashCode}');
        expect(da0.hashCode == da3.hashCode, false);
        expect(da0 == da3, false);
      }
    });

    test('DA valuesCopy ranodm', () {
      for (var s in goodDAList) {
        final da0 = new DAtag(PTag.kCalibrationDate, s);
        expect(s, equals(da0.valuesCopy));
      }

      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        final da1 = new DAtag(PTag.kCreationDate, vList0);
        expect(vList0, equals(da1.valuesCopy));
      }
    });

    test('DA isValidLength', () {
      for (var s in goodDAList) {
        final da0 = new DAtag(PTag.kCreationDate, s);
        expect(da0.checkLength(da0.values), true);
      }
    });

    test('DA isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        final da0 = new DAtag(PTag.kCreationDate, vList0);
        expect(da0.checkLength(da0.values), true);
      }
    });

    test('DA isValidValues good values', () {
      global.throwOnError = false;
      for (var s in goodDAList) {
        final da0 = new DAtag(PTag.kCreationDate, s);
        expect(da0.hasValidValues, true);
      }
    });

    test('DA isValidValues bad values', () {
      global.throwOnError = false;
      for (var s in badDAList) {
        global.throwOnError = false;
        final da0 = new DAtag(PTag.kCreationDate, s);
        expect(da0, isNull);

        global.throwOnError = true;
        expect(() => new DAtag(PTag.kCreationDate, null),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('DA isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        final da0 = new DAtag(PTag.kCreationDate, vList0);
        expect(da0.hasValidValues, true);
      }
    });

    test('DA replace', () {
      final vList0 = ['19991025'];
      final da0 = new DAtag(PTag.kCreationDate, vList0);
      final vList1 = ['19001025'];
      expect(da0.replace(vList1), equals(vList0));
      expect(da0.values, equals(vList1));

      final da1 = new DAtag(PTag.kCreationDate, vList1);
      expect(da1.replace(<String>[]), equals(vList1));
      expect(da1.values, equals(<String>[]));

      final da2 = new DAtag(PTag.kCreationDate, vList1);
      expect(da2.replace(null), equals(vList1));
      expect(da2.values, equals(<String>[]));
    });

    test('DA replace random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        final da0 = new DAtag(PTag.kCreationDate, vList0);
        final vList1 = rsg.getDAList(1, 1);
        expect(da0.replace(vList1), equals(vList0));
        expect(da0.values, equals(vList1));
      }

      final vList1 = rsg.getDAList(1, 1);
      final da1 = new DAtag(PTag.kCreationDate, vList1);
      expect(da1.replace(<String>[]), equals(vList1));
      expect(da1.values, equals(<String>[]));

      final da2 = new DAtag(PTag.kCreationDate, null);
      expect(da2, isNull);
    });

    test('DA getAsciiList', () {
      for (var s in goodDAList) {
        //final bytes = encodeStringListValueField(vList1);
        final bytes = Bytes.fromAsciiList(s);
        log.debug('bytes:$bytes');
        final da0 = DAtag.fromBytes(PTag.kCreationDate, bytes);
        log.debug('da0: ${da0.info}');
        expect(da0.hasValidValues, true);
      }
    });

    test('DA getAsciiList random', () {
      //    	system.level = Level.info;
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDAList(1, 1);
        final bytes = Bytes.fromAsciiList(vList1);
        log.debug('bytes:$bytes');
        final da0 = DAtag.fromBytes(PTag.kCreationDate, bytes);
        log.debug('da0: ${da0.info}');
        expect(da0.hasValidValues, true);
      }
    });

    test('DA fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDAList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          final da1 = DAtag.fromBytes(PTag.kSelectorDAValue, bytes0);
          log.debug('da1: ${da1.info}');
          expect(da1.hasValidValues, true);
        }
      }
    });

    test('DA fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDAList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.fromAscii(listS);
          final da1 = DAtag.fromBytes(PTag.kSelectorAEValue, bytes0);
          expect(da1, isNull);

          global.throwOnError = true;
          expect(() => DAtag.fromBytes(PTag.kSelectorAEValue, bytes0),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      }
    });

    test('DA checkLength', () {
      global.throwOnError = false;
      final da0 = new DAtag(PTag.kCreationDate, ['19930822']);
      for (var s in goodDAList) {
        expect(da0.checkLength(s), true);
      }
      final da1 = new DAtag(PTag.kCreationDate, ['19930822']);
      expect(da1.checkLength(<String>[]), true);

      final vList0 = ['20171206', '20181206'];
      final da2 = new DAtag(PTag.kPatientSize, vList0);
      expect(da2, isNull);
    });

    test('DA checkLength good values random', () {
      final vList0 = rsg.getDAList(1, 1);
      final da0 = new DAtag(PTag.kCreationDate, vList0);
      for (var s in goodDAList) {
        expect(da0.checkLength(s), true);
      }
      final da1 = new DAtag(PTag.kCreationDate, vList0);
      expect(da1.checkLength(<String>[]), true);
    });

    test('DA checkLength bad values random', () {
      final vList1 = ['19980512', '20170412'];
      final vList0 = rsg.getDAList(1, 1);
      final da2 = new DAtag(PTag.kCreationDate, vList0);
      expect(da2.checkLength(vList1), false);
    });

    test('DA checkValue good values', () {
      final da0 = new DAtag(PTag.kCreationDate, ['19930822']);
      for (var s in goodDAList) {
        for (var a in s) {
          expect(da0.checkValue(a), true);
        }
      }
    });

    test('DA checkValue bad values', () {
      final da0 = new DAtag(PTag.kCreationDate, ['19930822']);
      for (var s in badDAList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(da0.checkValue(a), false);
        }
      }
    });

    test('DA checkValue good values random', () {
      global.throwOnError = false;
      final vList0 = rsg.getDAList(1, 1);
      final da0 = new DAtag(PTag.kCreationDate, vList0);
      for (var s in goodDAList) {
        for (var a in s) {
          expect(da0.checkValue(a), true);
        }
      }
    });
    test('DA checkValue bad values random', () {
      global.throwOnError = false;
      final vList0 = rsg.getDAList(1, 1);
      final da0 = new DAtag(PTag.kCreationDate, vList0);
      for (var s in badDAList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(da0.checkValue(a), false);
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
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final make1 = DAtag.fromValues(PTag.kDate, <String>[null]);
      log.debug('mak1: $make1');
      expect(make1, isNull);

      global.throwOnError = true;
      expect(() => DAtag.fromValues(PTag.kDate, <String>[null]),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });
  });

  group('DA Element', () {
    const badDateValuesLengthList = const <List<String>>[
      const <String>['197812345', '1b700101'],
      const <String>['19800541', '1970011a'],
      const <String>['00000032', '19501318'],
    ];

    //VM.k1
    const daTags0 = const <PTag>[
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
    const daTags1 = const <PTag>[
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

      for (var tag in daTags0) {
        final validT0 = DA.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('DA isValidTag bad values', () {
      global.throwOnError = false;
      expect(DA.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => DA.isValidTag(PTag.kSelectorFDValue),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = DA.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => DA.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('DA checkVRIndex good values', () {
      global.throwOnError = false;
      expect(DA.checkVRIndex(kDAIndex), kDAIndex);

      for (var tag in daTags0) {
        global.throwOnError = false;
        expect(DA.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('DA checkVRIndex bad values', () {
      global.throwOnError = false;
      expect(
          DA.checkVRIndex(
            kSSIndex,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => DA.checkVRIndex(kSSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(DA.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => DA.checkVRIndex(kSSIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('DA checkVRCode good values', () {
      global.throwOnError = false;
      expect(DA.checkVRCode(kDACode), kDACode);

      for (var tag in daTags0) {
        global.throwOnError = false;
        expect(DA.checkVRCode(tag.vrCode), tag.vrCode);
      }
    });

    test('DA checkVRCode bad values', () {
      global.throwOnError = false;
      expect(
          DA.checkVRCode(
            kAECode,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => DA.checkVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(DA.checkVRCode(tag.vrCode), isNull);

        global.throwOnError = true;
        expect(() => DA.checkVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('DA isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(DA.isValidVRIndex(kDAIndex), true);

      for (var tag in daTags0) {
        global.throwOnError = false;
        expect(DA.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('DA isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(DA.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => DA.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(DA.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => DA.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('DA isValidVRCode good values', () {
      global.throwOnError = false;
      expect(DA.isValidVRCode(kDACode), true);

      for (var tag in daTags0) {
        expect(DA.isValidVRCode(tag.vrCode), true);
      }
    });

    test('DA isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(DA.isValidVRCode(kSSCode), false);

      global.throwOnError = true;
      expect(() => DA.isValidVRCode(kSSCode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(DA.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => DA.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
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

    test('DA isNotValidVFLength good values', () {
      expect(DA.isNotValidVFLength(DA.kMaxVFLength), false);
      expect(DA.isNotValidVFLength(0), false);
    });

    test('DA isNotValidVFLength bad values', () {
      expect(DA.isNotValidVFLength(DA.kMaxVFLength + 1), true);
      expect(DA.isNotValidVFLength(-1), true);
    });

    test('DA isValidValueLength good values', () {
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

    test('DA isNotValidValueLength', () {
      for (var s in goodDAList) {
        for (var a in s) {
          expect(DA.isNotValidValueLength(a), false);
        }
      }

      expect(DA.isNotValidValueLength('1994121256'), true);
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
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('DA isValidValues bad date value length', () {
      global.throwOnError = false;
      for (var s in badDALengthList) {
        global.throwOnError = false;
        expect(DA.isValidValues(PTag.kDate, s), false);

        global.throwOnError = true;
        expect(() => DA.isValidValues(PTag.kDate, s),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('DA isValidValues bad values length', () {
      global.throwOnError = false;
      for (var s in badDateValuesLengthList) {
        global.throwOnError = false;
        expect(DA.isValidValues(PTag.kDate, s), false);

        global.throwOnError = true;
        expect(() => DA.isValidValues(PTag.kDate, s),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('DA isValidValues VM.k1 good values length', () {
      for (var i = 0; i < 10; i++) {
        final validList = rsg.getDAList(1, 1);
        for (var tag in daTags0) {
          global.throwOnError = false;
          expect(DA.isValidValues(tag, validList), true);
        }
      }
    });

    test('DA isValidValues VM.k1 bad values length', () {
      for (var i = 1; i < 10; i++) {
        final validList = rsg.getDAList(2, i + 1);
        for (var tag in daTags0) {
          global.throwOnError = false;
          expect(DA.isValidValues(tag, validList), false);
          expect(DA.isValidValues(tag, invalidList), false);

          global.throwOnError = true;
          expect(() => DA.isValidValues(tag, validList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
          expect(() => DA.isValidValues(tag, invalidList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('DA isValidValues VM.k1_n length', () {
      for (var i = 1; i < 10; i++) {
        final validList = rsg.getDAList(1, i);
        for (var tag in daTags1) {
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
      expect(Bytes.fromAsciiList(vList0), isNull);
      global.throwOnError = true;
      expect(() => Bytes.fromAsciiList(vList0),
          throwsA(const isInstanceOf<InvalidValueFieldError>()));
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
      expect(DA.isValidValues(PTag.kDate, vList0), vList0);

      for (var s in goodDAList) {
        global.throwOnError = false;
        expect(DA.isValidValues(PTag.kDate, s), s);
      }
    });

    test('DA isValidValues bad values', () {
      global.throwOnError = false;
      final vList1 = ['19503318'];
      expect(DA.isValidValues(PTag.kDate, vList1), isNull);

      global.throwOnError = true;
      expect(() => DA.isValidValues(PTag.kDate, vList1),
          throwsA(const isInstanceOf<StringError>()));

      for (var s in badDAList) {
        global.throwOnError = false;
        expect(DA.isValidValues(PTag.kDate, s), isNull);

        global.throwOnError = true;
        print('s: $s');
        expect(() => DA.isValidValues(PTag.kDate, s),
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('DA isValidValues random', () {
      global.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        expect(DA.isValidValues(PTag.kDate, vList0), vList0);
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
        final sList0 = rsg.getDAList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.fromAsciiList(sList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(sList0.join('\\'));
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
          throwsA(const isInstanceOf<GeneralError>()));
    });
  });

  final goodDTList = <List<String>>[
    <String>['19500718105630'],
    <String>['00000101010101'],
    <String>['19700101000000'],
    <String>['20161229000000'],
    <String>['19991025235959'],
    <String>['20170223122334.111111'],
    <String>['20170223122334.111111+1100'],
    <String>['20170223122334.111111-1000'],
    <String>['20170223122334.111111+0930'],
    <String>['20120228105630'], // leap year
    <String>['20080229105630'], // leap year
    <String>['20160229105630'], // leap year
    <String>['20200125105630'], // leap year
    <String>['20240229105630'] // leap year
  ];

  const badDTList = const <List<String>>[
    const <String>['19501318'],
    const <String>['19501318105630'], //bad months
    const <String>['19501032105630'], // bad day
    const <String>['00000000000000'], // bad month and day
    const <String>['19501032105660'], // bad day and second
    const <String>['00000032240212'], // bad month and day and hour
    const <String>['20161229006100'], // bad minute
    const <String>['-9700101226a22'], // bad character in year minute
    const <String>['1b7001012a1045'], // bad character in year and hour
    const <String>['19c001012210a2'], // bad character in year and sec
    const <String>['197d0101105630'], // bad character in year
    const <String>['1970a101105630'], // bad character in month
    const <String>['19700b01105630'], // bad character in month
    const <String>['197001a1105630'], // bad character in day
    const <String>['1970011a105630'], // bad character in day
    const <String>['20120230105630'], // bad day in leap year
    const <String>['20160231105630'], // bad day in leap year
    const <String>['20130229105630'], // bad day in year
    const <String>['20230229105630'], // bad day in year
    const <String>['20210229105630'], // bad day in year
    const <String>['20170223122334.111111+0'], // bad timezone
    const <String>['20170223122334.111111+01'], // bad timezone
    const <String>['20170223122334.111111+013'], // bad timezone
    const <String>['20170223122334.111111+1545'], // bad timezone
    const <String>['20170223122334.111111-1015'], // bad timezone
    const <String>['20170223122334.111111+0960'], // bad timezone
    const <String>[
      '20170223122334.111111*0945'
    ], // bad timezone: special character
  ];

  group('DT Tests', () {
    test('DT getAsciiList', () {
      //fromBytes
//      system.level = Level.info2;
      for (var s in goodDTList) {
        //final bytes = encodeStringListValueField(vList1);
        final bytes = Bytes.fromAsciiList(s);
        log.debug('bytes:$bytes');
        final dt0 = DTtag.fromBytes(PTag.kDateTime, bytes);
        log.debug('dt0: ${dt0.info}');
        expect(dt0.hasValidValues, true);
      }
    });

    test('DT getAsciiList random', () {
      //    	system.level = Level.info;
      //fromBytes
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDTList(1, 1);
        final bytes = Bytes.fromAsciiList(vList1);
        log.debug('bytes:$bytes');
        final dt0 = DTtag.fromBytes(PTag.kDateTime, bytes);
        log.debug('dt0: ${dt0.info}');
        expect(dt0.hasValidValues, true);
      }
    });

    test('DT fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDTList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          final dt1 = DTtag.fromBytes(PTag.kSelectorDTValue, bytes0);
          log.debug('dt1: ${dt1.info}');
          expect(dt1.hasValidValues, true);
        }
      }
    });

    test('DT fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDTList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.fromAscii(listS);
          final dt1 = DTtag.fromBytes(PTag.kSelectorAEValue, bytes0);
          expect(dt1, isNull);

          global.throwOnError = true;
          expect(() => DTtag.fromBytes(PTag.kSelectorAEValue, bytes0),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      }
    });

    test('DT hasValidValues good values', () {
      for (var s in goodDTList) {
        global.throwOnError = false;
        final dt0 = new DTtag(PTag.kFrameAcquisitionDateTime, s);
        expect(dt0.hasValidValues, true);
      }

      // empty list and null as values
      global.throwOnError = false;
      final dt0 = new DTtag(PTag.kDateTime, <String>[]);
      expect(dt0.hasValidValues, true);
      expect(dt0.values, equals(<String>[]));
    });

    test('DT hasValidValues bad values', () {
      for (var s in badDTList) {
        global.throwOnError = false;
        final dt1 = new DTtag(PTag.kFrameAcquisitionDateTime, s);
        expect(dt1, isNull);

        global.throwOnError = true;
        expect(() => new DTtag(PTag.kFrameAcquisitionDateTime, s),
            throwsA(const isInstanceOf<FormatException>()));

        global.throwOnError = false;
        final dt2 = new DTtag(PTag.kDateTime, null);
        log.debug('dt2: $dt2');
        expect(dt2, isNull);

        global.throwOnError = true;
        expect(() => new DTtag(PTag.kDateTime, null),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('DT hasValidValues good random', () {
      global.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        log.debug('vList0: $vList0');
        final dt0 = new DTtag(PTag.kDateTime, vList0);
        expect(dt0.hasValidValues, true);
      }
    });

    test('DT hasValidValues bad random', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getDTList(3, 4);
        log.debug('$i: vList0: $vList0');
        final dt1 = new DTtag(PTag.kDateTime, vList0);
        expect(dt1, isNull);

        global.throwOnError = true;
        expect(() => new DTtag(PTag.kDateTime, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
        expect(dt1, isNull);
      }
    });

    test('DT update', () {
      global.throwOnError = false;
      final dt0 = new DTtag(PTag.kDateTime, <String>[]);
      expect(dt0.update(['19991025235959']).values, equals(['19991025235959']));

      final dt1 = new DTtag(PTag.kDateTime, ['19991025235959']);
      final dt2 = new DTtag(PTag.kDateTime, ['19991025235959']);
      final dt3 = dt1.update(['21231025135959']);
      final dt4 = dt2.update(['21231025135959']);
      expect(dt1 == dt4, false);
      expect(dt2 == dt4, false);
      expect(dt3 == dt4, true);

      for (var s in goodDTList) {
        final dt5 = new DTtag(PTag.kDateTime, s);
        final dt6 = dt5.update(['19901125235959']);
        final dt7 = dt5.update(['19901125235959']);
        expect(dt5.values.first == dt6.values.first, false);
        expect(dt5 == dt6, false);
        expect(dt6 == dt7, true);
      }
      expect(utility.testElementUpdate(dt1, <String>['19901125235959']), true);
    });

    test('DT update random', () {
      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        final dt0 = new DTtag(PTag.kDateTime, vList0);
        final vList1 = rsg.getDTList(1, 1);
        expect(dt0.update(vList1).values, equals(vList1));
      }
    });

    test('DT noValues', () {
      final dt1 = new DTtag(PTag.kDateTime, ['19991025235959']);
      final dtNoValues1 = dt1.noValues;
      expect(dtNoValues1.values.isEmpty, true);
      log.debug('dtNoValues1:$dtNoValues1');

      for (var s in goodDTList) {
        final dt1 = new DTtag(PTag.kDateTime, s);
        final dtNoValues1 = dt1.noValues;
        expect(dtNoValues1.values.isEmpty, true);
      }
    });

    test('DT noValues random ', () {
      final dt0 = new DTtag(PTag.kDateTime, <String>[]);
      final DTtag dtNoValues0 = dt0.noValues;
      expect(dtNoValues0.values.isEmpty, true);
      log.debug('dt0: ${dt0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        final dt0 = new DTtag(PTag.kDateTime, vList0);
        log.debug('dt0: $dt0');
        expect(dtNoValues0.values.isEmpty, true);
        log.debug('dt0: ${dt0.noValues}');
      }
    });

    test('DT copy', () {
      final dt0 = new DTtag(PTag.kDateTime, <String>[]);
      final DTtag dt1 = dt0.copy;
      expect(dt1 == dt0, true);
      expect(dt1.hashCode == dt0.hashCode, true);

      final dt2 = new DTtag(PTag.kDateTime, ['19991025235959']);
      final dt3 = dt2.copy;
      expect(dt2 == dt3, true);
      expect(dt2.hashCode == dt3.hashCode, true);

      for (var s in goodDTList) {
        final dt4 = new DTtag(PTag.kDateTime, s);
        final dt5 = dt4.copy;
        expect(dt4 == dt5, true);
        expect(dt4.hashCode == dt5.hashCode, true);
      }
      expect(utility.testElementCopy(dt0), true);
    });

    test('DT copy random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        final dt2 = new DTtag(PTag.kDateTime, vList0);
        final DTtag dt3 = dt2.copy;
        expect(dt3 == dt2, true);
        expect(dt3.hashCode == dt2.hashCode, true);
      }
    });

    test('DT hashCode and == good values', () {
      global.throwOnError = false;
      final vList0 = ['19991025235959'];
      final dt0 = new DTtag(PTag.kDateTime, vList0);
      final dt1 = new DTtag(PTag.kDateTime, vList0);
      log
        ..debug('vList0:$vList0, dt0.hash_code:${dt0.hashCode}')
        ..debug('vList0:$vList0, dt1.hash_code:${dt1.hashCode}');
      expect(dt0.hashCode == dt1.hashCode, true);
      expect(dt0 == dt1, true);
    });

    test('DT hashCode and == bad values', () {
      global.throwOnError = false;
      final vList0 = ['19991025235959'];
      final dt0 = new DTtag(PTag.kDateTime, vList0);
      final dt2 = new DTtag(PTag.kTemplateVersion, vList0);
      log.debug('vList0:$vList0 , da2.hash_code:${dt2.hashCode}');
      expect(dt0.hashCode == dt2.hashCode, false);
      expect(dt0 == dt2, false);
    });

    test('DT hashCode and == good values random', () {
      global.throwOnError = false;
      List<String> stringList0;

      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getDTList(1, 1);
        final dt0 = new DTtag(PTag.kDateTime, stringList0);
        final dt1 = new DTtag(PTag.kDateTime, stringList0);
        log
          ..debug('stringList0:$stringList0, dt0.hash_code:${dt0.hashCode}')
          ..debug('stringList0:$stringList0, dt1.hash_code:${dt1.hashCode}');
        expect(dt0.hashCode == dt1.hashCode, true);
        expect(dt0 == dt1, true);
      }
    });

    test('DT hashCode and == bad values random', () {
      global.throwOnError = false;
      List<String> stringList0;
      List<String> stringList1;

      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getDTList(1, 1);
        final dt0 = new DTtag(PTag.kDateTime, stringList0);
        stringList1 = rsg.getDTList(2, 3);
        final dt3 = new DTtag(PTag.kSelectorDTValue, stringList1);
        log.debug('stringList1:$stringList1 , dt3.hash_code:${dt3.hashCode}');
        expect(dt0.hashCode == dt3.hashCode, false);
        expect(dt0 == dt3, false);
      }
    });

    test('DT valuesCopy ranodm', () {
      for (var s in goodDTList) {
        final dt0 = new DTtag(PTag.kDateTime, s);
        expect(s, equals(dt0.valuesCopy));
      }

      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        final dt1 = new DTtag(PTag.kDateTime, vList0);
        expect(vList0, equals(dt1.valuesCopy));
      }
    });

    test('DT isValidLength', () {
      for (var s in goodDTList) {
        final dt0 = new DTtag(PTag.kDateTime, s);
        expect(dt0.checkLength(dt0.values), true);
      }
    });

    test('DT isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        final dt0 = new DTtag(PTag.kDateTime, vList0);
        expect(dt0.checkLength(dt0.values), true);
      }
    });

    test('DT isValidValues ', () {
      for (var s in goodDTList) {
        final dt0 = new DTtag(PTag.kDateTime, s);
        expect(dt0.checkValues(dt0.values), true);
        expect(dt0.hasValidValues, true);
      }

      global.throwOnError = true;
      for (var s in badDTList) {
        expect(() => new DTtag(PTag.kDateTime, s),
            throwsA(const isInstanceOf<FormatException>()));
      }
    });

    test('DT isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        final dt0 = new DTtag(PTag.kDateTime, vList0);
        expect(dt0.checkValues(dt0.values), true);
        expect(dt0.hasValidValues, true);
      }
    });

    test('DT replace', () {
      final vList0 = ['19991025235959'];
      final dt0 = new DTtag(PTag.kDateTime, vList0);
      final vList1 = ['19001025235959'];
      expect(dt0.replace(vList1), equals(vList0));
      expect(dt0.values, equals(vList1));

      final dt1 = new DTtag(PTag.kDateTime, vList1);
      expect(dt1.replace(<String>[]), equals(vList1));
      expect(dt1.values, equals(<String>[]));

      final dt2 = new DTtag(PTag.kDateTime, vList1);
      expect(dt2.replace(null), equals(vList1));
      expect(dt2.values, equals(<String>[]));
    });

    test('DT replace random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        final dt0 = new DTtag(PTag.kDateTime, vList0);
        final vList1 = rsg.getDTList(1, 1);
        expect(dt0.replace(vList1), equals(vList0));
        expect(dt0.values, equals(vList1));
      }

      final vList1 = rsg.getDTList(1, 1);
      final dt1 = new DTtag(PTag.kDateTime, vList1);
      expect(dt1.replace(<String>[]), equals(vList1));
      expect(dt1.values, equals(<String>[]));

      final dt2 = new DTtag(PTag.kDateTime, null);
      expect(dt2, isNull);
    });

    test('DT checkLength good values', () {
      final dt0 = new DTtag(PTag.kDateTime, ['19500718105630']);
      for (var s in goodDTList) {
        expect(dt0.checkLength(s), true);
      }
      final dt1 = new DTtag(PTag.kDateTime, ['19500718105630']);
      expect(dt1.checkLength(<String>[]), true);
    });

    test('DT checkLength bad values', () {
      final vList0 = ['19500718105630', '20181206235959'];
      final dt2 = new DTtag(PTag.kDateTime, ['19500718105630']);
      expect(dt2.checkLength(vList0), false);
    });

    test('DT checkLength random', () {
      final vList0 = rsg.getDTList(1, 1);
      final dt0 = new DTtag(PTag.kDateTime, vList0);
      for (var s in goodDTList) {
        expect(dt0.checkLength(s), true);
      }
      final dt1 = new DTtag(PTag.kDateTime, vList0);
      expect(dt1.checkLength(<String>[]), true);
    });

    test('DT checkValue good values', () {
      final dt0 = new DTtag(PTag.kDateTime, ['19500718105630']);
      for (var s in goodDTList) {
        for (var a in s) {
          expect(dt0.checkValue(a), true);
        }
      }
    });

    test('DT checkValue bad values', () {
      final dt0 = new DTtag(PTag.kDateTime, ['19500718105630']);
      for (var s in badDTList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(dt0.checkValue(a), false);
        }
      }
    });

    test('DT make good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        final make0 = DTtag.fromValues(PTag.kDateTime, vList0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);

        final make1 = DTtag.fromValues(PTag.kDateTime, <String>[]);
        expect(make1.hasValidValues, true);
        expect(make1.values, equals(<String>[]));
      }
    });

    test('DT make bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDTList(2, 2);
        global.throwOnError = false;
        final make0 = DTtag.fromValues(PTag.kDateTime, vList0);
        expect(make0, isNull);

        global.throwOnError = true;
        expect(() => DTtag.fromValues(PTag.kDateTime, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final make1 = DTtag.fromValues(PTag.kDateTime, <String>[null]);
      log.debug('mak1: $make1');
      expect(make1, isNull);

      global.throwOnError = true;
      expect(() => DTtag.fromValues(PTag.kDateTime, <String>[null]),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });
  });

  group('DT Element', () {
    const badDTLengthList = const <List<String>>[
      const <String>['20120230105630', '1970011a105630'],
      const <String>['20120230105630', '1970011a105630'],
      const <String>['20170223122334.111111+01', '19700b01105630']
    ];

    //VM.k1
    const dtTags0 = const <PTag>[
      PTag.kInstanceCoercionDateTime,
      PTag.kContextGroupLocalVersion,
      PTag.kRadiopharmaceuticalStartDateTime,
      PTag.kFrameAcquisitionDateTime,
      PTag.kDecayCorrectionDateTime,
      PTag.kPerformedProcedureStepEndDateTime,
      PTag.kParticipationDateTime,
      PTag.kDateTime,
      PTag.kTemplateVersion,
      PTag.kProductExpirationDateTime,
      PTag.kDigitalSignatureDateTime,
      PTag.kAlarmDecisionTime,
    ];

    //VM.k1_n
    const dtTags1 = const <PTag>[PTag.kSelectorDTValue];

    const otherTags = const <PTag>[
      PTag.kColumnAngulationPatient,
      PTag.kAcquisitionProtocolDescription,
      PTag.kCTDIvol,
      PTag.kCTPositionSequence,
      PTag.kAcquisitionType,
      PTag.kICCProfile,
      PTag.kSelectorSTValue,
      PTag.kDate,
      PTag.kTime
    ];

    final invalidList = rsg.getDTList(DT.kMaxVFLength + 1, DT.kMaxVFLength + 1);

    test('DT isValidTag good values', () {
      global.throwOnError = false;
      expect(DT.isValidTag(PTag.kSelectorDTValue), true);

      for (var tag in dtTags0) {
        final validT0 = DT.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('DT isValidTag bad values', () {
      global.throwOnError = false;
      expect(DT.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => DT.isValidTag(PTag.kSelectorFDValue),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = DT.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => DT.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('DT checkVRIndex good values', () {
      global.throwOnError = false;
      expect(DT.checkVRIndex(kDTIndex), kDTIndex);

      for (var tag in dtTags0) {
        global.throwOnError = false;
        expect(DT.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('DT checkVRIndex bad values', () {
      global.throwOnError = false;
      expect(
          DT.checkVRIndex(
            kSSIndex,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => DT.checkVRIndex(kSSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(DT.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => DT.checkVRIndex(kSSIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('DT checkVRCode good values', () {
      global.throwOnError = false;
      expect(DT.checkVRCode(kDTCode), kDTCode);

      for (var tag in dtTags0) {
        global.throwOnError = false;
        expect(DT.checkVRCode(tag.vrCode), tag.vrCode);
      }
    });

    test('DT checkVRCode bad values', () {
      global.throwOnError = false;
      expect(
          DT.checkVRCode(
            kAECode,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => DT.checkVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(DT.checkVRCode(tag.vrCode), isNull);

        global.throwOnError = true;
        expect(() => DT.checkVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('DT isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(DT.isValidVRIndex(kDTIndex), true);

      for (var tag in dtTags0) {
        global.throwOnError = false;
        expect(DT.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('DT isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(DT.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => DT.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));
      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(DT.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => DT.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('DT isValidVRCode good values', () {
      global.throwOnError = false;
      expect(DT.isValidVRCode(kDTCode), true);

      for (var tag in dtTags0) {
        expect(DT.isValidVRCode(tag.vrCode), true);
      }
    });

    test('DT isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(DT.isValidVRCode(kSSCode), false);

      global.throwOnError = true;
      expect(() => DT.isValidVRCode(kSSCode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(DT.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => DT.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('DT isValidVFLength good values', () {
      expect(DT.isValidVFLength(DT.kMaxVFLength), true);
      expect(DT.isValidVFLength(0), true);
    });

    test('DT isValidVFLength bad values', () {
      expect(DT.isValidVFLength(DT.kMaxVFLength + 1), false);
      expect(DT.isValidVFLength(-1), false);
    });

    test('DT isNotValidVFLength good values', () {
      expect(DT.isNotValidVFLength(DT.kMaxVFLength), false);
      expect(DT.isNotValidVFLength(0), false);
    });

    test('DT isNotValidVFLength bad values', () {
      expect(DT.isNotValidVFLength(DT.kMaxVFLength + 1), true);
      expect(DT.isNotValidVFLength(-1), true);
    });

    test('DT isValidValueLength good values', () {
      for (var s in goodDTList) {
        for (var a in s) {
          expect(DT.isValidValueLength(a), true);
        }
      }

      expect(DT.isValidValueLength('19500718105630'), true);
    });

    test('DT isValidValueLength bad values', () {
      for (var s in badDTLengthList) {
        for (var a in s) {
          expect(DT.isValidValueLength(a), true);
        }
      }
      expect(DT.isValidValueLength('20170223122334.111111+11000000'), false);
    });

    test('DT.isNotValidValueLength', () {
      for (var s in goodDTList) {
        for (var a in s) {
          expect(DT.isNotValidValueLength(a), false);
        }
      }

      expect(DT.isNotValidValueLength('20170223122334.111111+1100000'), true);
    });

    test('DT isValidValue good values', () {
      global.throwOnError = false;
      for (var s in goodDTList) {
        for (var a in s) {
          expect(DT.isValidValue(a), true);
        }
      }
    });

    test('DT isValidValue bad values', () {
      for (var s in badDTList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(DT.isValidValue(a), false);

          global.throwOnError = true;
          expect(() => DT.isValidValue(a),
              throwsA(const isInstanceOf<FormatException>()));
        }
      }
    });

    test('DT isValidValues good values', () {
      global.throwOnError = false;
      for (var s in goodDTList) {
        expect(DT.isValidValues(PTag.kDateTime, s), true);
      }
    });

    test('DT isValidValues bad values', () {
      global.throwOnError = false;
      for (var s in badDTList) {
        global.throwOnError = false;
        expect(DT.isValidValues(PTag.kDateTime, s), false);

        global.throwOnError = true;
        expect(() => DT.isValidValues(PTag.kDateTime, s),
            throwsA(const isInstanceOf<FormatException>()));
      }
    });

    test('DT isValidValues bad values length', () {
      global.throwOnError = false;
      for (var s in badDTLengthList) {
        global.throwOnError = false;
        expect(DT.isValidValues(PTag.kDateTime, s), false);

        global.throwOnError = true;
        expect(() => DT.isValidValues(PTag.kDateTime, s),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('DT isValidValues VM.k1 good values length', () {
      for (var i = 0; i < 10; i++) {
        final validList = rsg.getDTList(1, 1);
        for (var tag in dtTags0) {
          global.throwOnError = false;
          expect(DT.isValidValues(tag, validList), true);
        }
      }
    });

    test('DT isValidValues VM.k1 bad values length', () {
      for (var i = 1; i < 10; i++) {
        final validList = rsg.getDTList(2, i + 1);
        for (var tag in dtTags0) {
          global.throwOnError = false;
          expect(DT.isValidValues(tag, validList), false);
          expect(DT.isValidValues(tag, invalidList), false);

          global.throwOnError = true;
          expect(() => DT.isValidValues(tag, validList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
          expect(() => DT.isValidValues(tag, invalidList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('DT isValidValues VM.k1_n length', () {
      for (var i = 1; i < 10; i++) {
        final validList = rsg.getDTList(1, i);
        for (var tag in dtTags1) {
          global.throwOnError = false;
          expect(DT.isValidValues(tag, validList), true);
        }
      }
    });

    test('DT isValidValues good values', () {
      global.throwOnError = false;
      final vList0 = ['19500718105630'];
      expect(DT.isValidValues(PTag.kDateTime, vList0), vList0);

      final vList1 = ['19501318'];
      expect(DT.isValidValues(PTag.kDateTime, vList1), isNull);

      global.throwOnError = true;
      expect(() => DT.isValidValues(PTag.kDateTime, vList1),
          throwsA(const isInstanceOf<FormatException>()));

      for (var s in goodDTList) {
        global.throwOnError = false;
        expect(DT.isValidValues(PTag.kDateTime, s), s);
      }
    });

    test('DT isValidValues bad values', () {
      global.throwOnError = false;
      for (var s in badDTList) {
        global.throwOnError = false;
        expect(DT.isValidValues(PTag.kDateTime, s), isNull);

        global.throwOnError = true;
        expect(() => DT.isValidValues(PTag.kDateTime, s),
            throwsA(const isInstanceOf<FormatException>()));
      }
    });

    test('DT isValidValues bad values length', () {
      global.throwOnError = false;
      for (var s in badDTLengthList) {
        global.throwOnError = false;
        expect(DT.isValidValues(PTag.kDateTime, s), isNull);

        global.throwOnError = true;
        expect(() => DT.isValidValues(PTag.kDateTime, s),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('DT isValidValues random', () {
      global.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        expect(DT.isValidValues(PTag.kDateTime, vList0), vList0);
      }
    });

    test('DT getAsciiList', () {
      //    	system.level = Level.info;
      for (var s in goodDTList) {
        final bytes = Bytes.fromAsciiList(s);
        log.debug('DT.getAsciiList(bytes): $bytes');
        expect(bytes.getAsciiList(), equals(s));
      }
    });

    test('DT toUint8List', () {
      for (var s in goodDTList) {
        log.debug('Bytes.fromAsciiList(s): ${Bytes.fromAsciiList(s)}');

        if (s[0].length.isOdd) s[0] = '${s[0]} ';
        log.debug('s:"$s"');
        final values = cvt.ascii.encode(s[0]);
        expect(Bytes.fromAsciiList(s), equals(values));
      }
    });

    test('DT toUint8List bad values length', () {
      global.throwOnError = false;
      final vList0 = rsg.getDTList(DT.kMaxVFLength + 1, DT.kMaxVFLength + 1);
      expect(Bytes.fromAsciiList(vList0), isNull);
      global.throwOnError = true;
      expect(() => Bytes.fromAsciiList(vList0),
          throwsA(const isInstanceOf<InvalidValueFieldError>()));
    });

    test('DT getAsciiList', () {
      final vList1 = ['19500718105630'];
      final bytes = Bytes.fromAsciiList(vList1);
      log.debug('DT.getAsciiList(bytes):  $bytes');
      expect(bytes.getAsciiList(), equals(vList1));
    });

    test('DT toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        global.throwOnError = false;
        final values = cvt.ascii.encode(vList0[0]);
        final tbd0 = Bytes.fromAsciiList(vList0);
        final tbd1 = Bytes.fromAsciiList(vList0);
        log.debug('bd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodDTList) {
        for (var a in s) {
          final values = cvt.ascii.encode(a);
          final tbd2 = Bytes.fromAsciiList(s);
          final tbd3 = Bytes.fromAsciiList(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('DT fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.fromAsciiList(vList0);
        final fbd0 = bd0.getAsciiList();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (var s in goodDTList) {
        final bd0 = Bytes.fromAsciiList(s);
        final fbd0 = bd0.getAsciiList();
        expect(fbd0, equals(s));
      }
    });

    test('DT toBytes', () {
      for (var i = 0; i < 10; i++) {
        final sList0 = rsg.getDTList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.fromAsciiList(sList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(sList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodDTList) {
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
          throwsA(const isInstanceOf<GeneralError>()));
    });
  });

  const goodTMList = const <List<String>>[
    const <String>['000000'],
    const <String>['190101'],
    const <String>['235959'],
    const <String>['010101.1'],
    const <String>['010101.11'],
    const <String>['010101.111'],
    const <String>['010101.1111'],
    const <String>['010101.11111'],
    const <String>['010101.111111'],
    const <String>['000000.0'],
    const <String>['000000.00'],
    const <String>['000000.000'],
    const <String>['000000.0000'],
    const <String>['000000.00000'],
    const <String>['000000.000000'],
    const <String>['00'],
    const <String>['0000'],
    const <String>['000000'],
    const <String>['000000.1'],
    const <String>['000000.111111'],
    const <String>['01'],
    const <String>['0101'],
    const <String>['010101'],
    const <String>['010101.1'],
    const <String>['010101.111111'],
    const <String>['10'],
    const <String>['1010'],
    const <String>['101010'],
    const <String>['101010.1'],
    const <String>['101010.111111'],
    const <String>['22'],
    const <String>['2222'],
    const <String>['222222'],
    const <String>['222222.1'],
    const <String>['222222.111111'],
    const <String>['23'],
    const <String>['2323'],
    const <String>['232323'],
    const <String>['232323.1'],
    const <String>['232323.111111'],
    const <String>['23'],
    const <String>['2359'],
    const <String>['235959'],
    const <String>['235959.1'],
    const <String>['235959.111111'],
  ];
  const badTMList = const <List<String>>[
    const <String>['241318'], // bad hour
    const <String>['006132'], // bad minute
    const <String>['006060'], // bad minute and second
    const <String>['000060'], // bad month and day
    const <String>['-00101'], // bad character in hour
    const <String>['a00101'], // bad character in hour
    const <String>['0a0101'], // bad character in hour
    const <String>['ad0101'], // bad characters in hour
    const <String>['19a101'], // bad character in minute
    const <String>['190b01'], // bad character in minute
    const <String>['1901a1'], // bad character in second
    const <String>['19011a'], // bad character in second
  ];

  group('TM Test', () {
    log
      ..debug('kMinEpochMicroseconds: $kMinEpochMicrosecond')
      ..debug('kMaxEpochMicroseconds: $kMaxEpochMicrosecond')
      ..debug('kMicrosecondsPerDay: $kMicrosecondsPerDay');

    test('TM hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 1);
        log.debug('vList0: $vList0');
        final tm0 = new TMtag(PTag.kModifiedImageTime, vList0);
        log.debug('tm0: ${tm0.info}');
        expect(tm0.hasValidValues, true);

        log
          ..debug('tm0: $tm0, values: ${tm0.values}')
          ..debug('tm0: ${tm0.info}');
        expect(tm0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getTMList(1, 5);
        final tm0 = new TMtag(PTag.kCalibrationTime, vList1);
        expect(tm0.hasValidValues, isTrue);

        log
          ..debug('tm0: $tm0, values: ${tm0.values}')
          ..debug('ss0: ${tm0.info}');
        expect(tm0[0], equals(vList1[0]));
      }
    });

    test('TM hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        final vList2 = rsg.getTMList(3, 4);
        log.debug('$i: vList2: $vList2');
        final tm0 = new TMtag(PTag.kSelectorTMValue, vList2);
        expect(tm0.hasValidValues, true);
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 1, 2, 18);
        final tm0 = new TMtag(PTag.kModifiedImageTime, vList0);
        log.debug('vList0: $vList0, tm0:${tm0.info}');
        expect(tm0.hasValidValues, true);
      }

/* TODO: Implement getInvalidXXList()
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getInvalidTMList(3, 4, 2, 18);
        log.debug('invalid TM vList:$vList0');
        final tm0 = new TMtag(PTag.kModifiedImageTime, vList0);
        log.debug('vList0: $vList0');
         expect(tm0, isNull);
      }
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getInvalidTMList(3, 4);
        final tm0 = new TMtag(PTag.kModifiedImageTime, vList0);
        expect(tm0, isNull);
      }
*/
    });

    test('TM hasValidValues good values', () {
      for (var s in goodTMList) {
        global.throwOnError = false;
        final tm0 = new TMtag(PTag.kCalibrationTime, s);
        expect(tm0.hasValidValues, isTrue);
      }

      global.throwOnError = false;
      // empty list and null as values
      final tm0 = new TMtag(PTag.kModifiedImageTime, <String>[]);
      expect(tm0.hasValidValues, true);
      expect(tm0.values, equals(<int>[]));
    });

    test('TM hasValidValues bad values', () {
      for (var s in badTMList) {
        global.throwOnError = false;
        final tm0 = new TMtag(PTag.kCalibrationTime, s);
        expect(tm0, isNull);

        global.throwOnError = true;
        expect(() => new TMtag(PTag.kCalibrationTime, s),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
      global.throwOnError = false;
      final tm1 = new TMtag(PTag.kModifiedImageTime, null);
      log.debug('tm1: $tm1');
      expect(tm1, isNull);
      global.throwOnError = true;
      expect(() => new TMtag(PTag.kModifiedImageTime, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('TM update random', () {
      final tm0 = new TMtag(PTag.kCalibrationTime, <String>[]);
      expect(tm0.values, equals(<String>[]));
      final tm1 = tm0.update(['231318']);
      expect(tm1 == tm0, false);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(3, 4);
        final tm1 = new TMtag(PTag.kCalibrationTime, vList0);
        final vList1 = rsg.getTMList(3, 4);
        expect(tm1.update(vList1).values, equals(vList1));
      }
    });

    test('TM update', () {
      for (var s in goodTMList) {
        final tm0 = new TMtag(PTag.kModifiedImageTime, s);
        final tm1 = new TMtag(PTag.kModifiedImageTime, s);
        final tm2 = tm0.update(['231318']);
        final tm3 = tm1.update(['231318']);
        expect(tm0.values.first == tm2.values.first, false);
        expect(tm0 == tm3, false);
        expect(tm1 == tm3, false);
        expect(tm2 == tm3, true);
      }
    });

    test('TM noValues random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 1);
        final tm1 = new TMtag(PTag.kModifiedImageTime, vList0);
        expect(tm1.noValues.values.isEmpty, true);
      }
    });

    test('TM noValues', () {
      final tm0 = new TMtag(PTag.kModifiedImageTime, <String>[]);
      final TMtag tmNoValues = tm0.noValues;
      expect(tmNoValues.values.isEmpty, true);
      log.debug('tm0: ${tm0.noValues}');

      for (var s in goodTMList) {
        final tm0 = new TMtag(PTag.kModifiedImageTime, s);
        final tmNoValues0 = tm0.noValues;
        expect(tmNoValues0.isEmpty, true);
        log.debug('tm0:${tm0.noValues}');
      }
    });

    test('TM copy random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(3, 4);
        final tm2 = new TMtag(PTag.kSelectorTMValue, vList0);
        final TMtag tm3 = tm2.copy;
        expect(tm3 == tm2, true);
        expect(tm3.hashCode == tm2.hashCode, true);
      }
    });

    test('TM copy Element', () {
      final tm0 = new TMtag(PTag.kModifiedImageTime, <String>[]);
      final TMtag tm1 = tm0.copy;
      expect(tm1 == tm0, true);
      expect(tm1.hashCode == tm0.hashCode, true);

      final tm3 = new TMtag(PTag.kModifiedImageTime, ['151545']);
      final tm4 = tm3.copy;
      expect(tm3 == tm4, true);
      expect(tm3.hashCode == tm4.hashCode, true);
    });

    test('TM hashCode and == good values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 1);
        final tm0 = new TMtag(PTag.kModifiedImageTime, vList0);
        final tm1 = new TMtag(PTag.kModifiedImageTime, vList0);
        log
          ..debug('vList0:$vList0, tm0.hash_code:${tm0.hashCode}')
          ..debug('vList0:$vList0, tm1.hash_code:${tm1.hashCode}');
        expect(tm0.hashCode == tm1.hashCode, true);
        expect(tm0 == tm1, true);
      }
    });

    test('TM hashCode and == bad values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 1);
        final tm0 = new TMtag(PTag.kModifiedImageTime, vList0);
        final vList1 = rsg.getTMList(1, 1);
        final tm2 = new TMtag(PTag.kTimeOfLastDetectorCalibration, vList1);
        log.debug('vList1:$vList1 , tm2.hash_code:${tm2.hashCode}');
        expect(tm0.hashCode == tm2.hashCode, false);
        expect(tm0 == tm2, false);

        final vList2 = rsg.getTMList(2, 3);
        final tm3 = new TMtag(PTag.kModifiedImageTime, vList2);
        log.debug('vList2:$vList2 , tm3.hash_code:${tm3.hashCode}');
        expect(tm0.hashCode == tm3.hashCode, false);
        expect(tm0 == tm3, false);
      }
    });

    test('TM hashCode and == good values', () {
      final vList = ['231121'];
      final ss0 = new TMtag(PTag.kModifiedImageTime, vList);
      final ss1 = new TMtag(PTag.kModifiedImageTime, vList);
      log
        ..debug('vList:$vList, ss0.hash_code:${ss0.hashCode}')
        ..debug('vList:$vList, ss1.hash_code:${ss1.hashCode}');
      expect(ss0.hashCode == ss1.hashCode, true);
      expect(ss0 == ss1, true);
    });

    test('TM hashCode and == bad values', () {
      final vList = ['231121'];
      final ss0 = new TMtag(PTag.kModifiedImageTime, vList);
      final ss2 = new TMtag(PTag.kStudyVerifiedTime, vList);
      log.debug('vList:$vList , ss2.hash_code:${ss2.hashCode}');
      expect(ss0.hashCode == ss2.hashCode, false);
      expect(ss0 == ss2, false);
    });

    test('TM getAsciiList random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getTMList(1, 1);
        final bytes = Bytes.fromAsciiList(vList1);
        final tm0 = TMtag.fromBytes(PTag.kTime, bytes);
        expect(tm0.hasValidValues, true);
      }
    });

    test('TM getAsciiList', () {
      for (var s in goodTMList) {
        //final bytes = encodeStringListValueField(vList1);
        final bytes = Bytes.fromAsciiList(s);
        log.debug('bytes:$bytes');
        final tm0 = TMtag.fromBytes(PTag.kModifiedImageTime, bytes);
        log.debug('tm0: ${tm0.info}');
        expect(tm0.hasValidValues, true);
      }
    });

    test('TM fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getTMList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          final tm1 = TMtag.fromBytes(PTag.kSelectorTMValue, bytes0);
          log.debug('tm1: ${tm1.info}');
          expect(tm1.hasValidValues, true);
        }
      }
    });

    test('TM fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getTMList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.fromAscii(listS);
          final tm1 = TMtag.fromBytes(PTag.kSelectorAEValue, bytes0);
          expect(tm1, isNull);

          global.throwOnError = true;
          expect(() => TMtag.fromBytes(PTag.kSelectorAEValue, bytes0),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      }
    });

    test('TM checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getTMList(1, 10);
        final tm0 = new TMtag(PTag.kCalibrationTime, vList1);
        expect(tm0.checkLength(tm0.values), true);
      }
    });

    test('TM checkLength Element', () {
      for (var s in goodTMList) {
        final tm0 = new TMtag(PTag.kModifiedImageTime, s);
        expect(tm0.checkLength(tm0.values), true);
      }
    });

    test('TM checkValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getTMList(1, 10);
        final tm0 = new TMtag(PTag.kCalibrationTime, vList1);
        expect(tm0.checkValues(tm0.values), true);
      }
    });

    test('TM checkValues Element', () {
      for (var s in goodTMList) {
        final tm0 = new TMtag(PTag.kModifiedImageTime, s);
        expect(tm0.checkValues(tm0.values), true);
      }
    });

    test('TM valuesCopy random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getTMList(1, 10);
        final ss0 = new TMtag(PTag.kCalibrationTime, vList1);
        expect(vList1, equals(ss0.valuesCopy));
      }
    });

    test('TM valuesCopy', () {
      for (var s in goodTMList) {
        final tm0 = new TMtag(PTag.kModifiedImageTime, s);
        expect(s, equals(tm0.valuesCopy));
      }
    });

    test('TM replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 10);
        final tm0 = new TMtag(PTag.kCalibrationTime, vList0);
        final vList1 = rsg.getTMList(1, 1);
        expect(tm0.replace(vList1), equals(vList0));
        expect(tm0.values, equals(vList1));
      }

      final vList1 = rsg.getTMList(1, 10);
      final tm1 = new TMtag(PTag.kCalibrationTime, vList1);
      expect(tm1.replace(<String>[]), equals(vList1));
      expect(tm1.values, equals(<String>[]));

      final tm2 = new TMtag(PTag.kCalibrationTime, vList1);
      expect(tm2.replace(null), equals(vList1));
      expect(tm2.values, equals(<String>[]));
    });

    test('TM checkLength', () {
      global.throwOnError = false;
      final vList0 = rsg.getTMList(1, 1);
      final tm0 = new TMtag(PTag.kCalibrationTime, vList0);
      for (var s in goodTMList) {
        expect(tm0.checkLength(s), true);
      }
      final tm1 = new TMtag(PTag.kCalibrationTime, vList0);
      expect(tm1.checkLength(<String>[]), true);

      final vList1 = ['120450', '053439'];
      final tm2 = new TMtag(PTag.kDateTime, vList1);
      expect(tm2, isNull);
    });

    test('TM checkValue good values', () {
      final vList0 = rsg.getTMList(1, 1);
      final tm0 = new TMtag(PTag.kCalibrationTime, vList0);
      for (var s in goodTMList) {
        for (var a in s) {
          expect(tm0.checkValue(a), true);
        }
      }
    });

    test('TM checkValue bad values', () {
      final vList0 = rsg.getTMList(1, 1);
      final tm0 = new TMtag(PTag.kCalibrationTime, vList0);
      for (var s in badTMList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(tm0.checkValue(a), false);
        }
      }
    });

    test('TM make good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 1);
        final make0 = TMtag.fromValues(PTag.kTime, vList0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);

        final make1 = TMtag.fromValues(PTag.kTime, <String>[]);
        expect(make1.hasValidValues, true);
        expect(make1.values, equals(<String>[]));
      }
    });

    test('TM make bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(2, 2);
        global.throwOnError = false;
        final make0 = TMtag.fromValues(PTag.kTime, vList0);
        expect(make0, isNull);

        global.throwOnError = true;
        expect(() => TMtag.fromValues(PTag.kTime, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final make1 = TMtag.fromValues(PTag.kTime, <String>[null]);
      log.debug('mak1: $make1');
      expect(make1, isNull);

      global.throwOnError = true;
      expect(() => TMtag.fromValues(PTag.kDateTime, <String>[null]),
          throwsA(const isInstanceOf<InvalidVRError>()));
    });
  });

  group('TM Element', () {
    const badTMLengthList = const <List<String>>[
      const <String>['999999.9999', '999999.99999', '999999.999999'],
      const <String>['999999.9', '999999.99', '999999.999']
    ];

    //VM.k1
    const tmTags0 = const <PTag>[
      PTag.kStudyTime,
      PTag.kSeriesTime,
      PTag.kAcquisitionTime,
      PTag.kContentTime,
      PTag.kInterventionDrugStartTime,
      PTag.kTimeOfSecondaryCapture,
      PTag.kContrastBolusStartTime,
      PTag.kRadiopharmaceuticalStopTime,
      PTag.kScheduledStudyStartTime,
      PTag.kScheduledStudyStopTime,
      PTag.kIssueTimeOfImagingServiceRequest,
      PTag.kStructureSetTime,
      PTag.kTreatmentControlPointTime,
      PTag.kSafePositionExitTime,
    ];

    //VM.k1
    const tmTags1 = const <PTag>[
      PTag.kCalibrationTime,
      PTag.kTimeOfLastCalibration,
      PTag.kDateTimeOfLastCalibration,
      PTag.kSelectorTMValue,
    ];

    const otherTags = const <PTag>[
      PTag.kColumnAngulationPatient,
      PTag.kAcquisitionProtocolDescription,
      PTag.kCTDIvol,
      PTag.kCTPositionSequence,
      PTag.kAcquisitionType,
      PTag.kPerformedStationAETitle,
      PTag.kSelectorSTValue,
      PTag.kDate,
      PTag.kDateTime
    ];

    final invalidList = rsg.getTMList(TM.kMaxVFLength + 1, TM.kMaxVFLength + 1);

    test('TM isValidTag good values', () {
      global.throwOnError = false;
      expect(TM.isValidTag(PTag.kSelectorTMValue), true);

      for (var tag in tmTags0) {
        final validT0 = TM.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('TM isValidTag bad values', () {
      global.throwOnError = false;
      expect(TM.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => TM.isValidTag(PTag.kSelectorFDValue),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = TM.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => TM.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });
    test('TM checkVRIndex good values', () {
      global.throwOnError = false;
      expect(TM.checkVRIndex(kTMIndex), kTMIndex);

      for (var tag in tmTags0) {
        global.throwOnError = false;
        expect(TM.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('TM checkVRIndex bad values', () {
      global.throwOnError = false;
      expect(
          TM.checkVRIndex(
            kAEIndex,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => TM.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(TM.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => TM.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('TM checkVRCode good values', () {
      global.throwOnError = false;
      expect(TM.checkVRCode(kTMCode), kTMCode);

      for (var tag in tmTags0) {
        global.throwOnError = false;
        expect(TM.checkVRCode(tag.vrCode), tag.vrCode);
      }
    });

    test('TM checkVRCode bad values', () {
      global.throwOnError = false;
      expect(
          TM.checkVRCode(
            kAECode,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => TM.checkVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(TM.checkVRCode(tag.vrCode), isNull);

        global.throwOnError = true;
        expect(() => TM.checkVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('TM isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(TM.isValidVRIndex(kTMIndex), true);

      for (var tag in tmTags0) {
        global.throwOnError = false;
        expect(TM.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('TM isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(TM.isValidVRIndex(kSSIndex), false);

      global.throwOnError = true;
      expect(() => TM.isValidVRIndex(kSSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(TM.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => TM.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('TM isValidVRCode good values', () {
      global.throwOnError = false;
      expect(TM.isValidVRCode(kTMCode), true);

      for (var tag in tmTags0) {
        expect(TM.isValidVRCode(tag.vrCode), true);
      }
    });

    test('TM isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(TM.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => TM.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(TM.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => TM.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('TM isValidVFLength good values', () {
      expect(TM.isValidVFLength(TM.kMaxVFLength), true);
      expect(TM.isValidVFLength(0), true);
    });

    test('TM isValidVFLength bad values', () {
      expect(TM.isValidVFLength(TM.kMaxVFLength + 1), false);
      expect(TM.isValidVFLength(-1), false);
    });

    test('TM.isNotValidVFLength good values', () {
      expect(TM.isNotValidVFLength(TM.kMaxVFLength), false);
      expect(TM.isNotValidVFLength(0), false);
    });

    test('TM.isNotValidVFLength bad values', () {
      expect(TM.isNotValidVFLength(TM.kMaxVFLength + 1), true);
      expect(TM.isNotValidVFLength(-1), true);
    });

    test('TM isValidValueLength', () {
      for (var s in goodTMList) {
        for (var a in s) {
          expect(TM.isValidValueLength(a), true);
        }
      }

      expect(TM.isValidValueLength('190101'), true);

      expect(TM.isValidValueLength('19010112345657'), false);
    });

    test('TM isNotValidValueLength', () {
      for (var s in goodTMList) {
        for (var a in s) {
          expect(TM.isNotValidValueLength(a), false);
        }
      }

      expect(TM.isValidValueLength('190101'), true);
    });

    test('TM isValidValue good values', () {
      for (var s in goodTMList) {
        for (var a in s) {
          expect(TM.isValidValue(a), true);
        }
      }
    });

    test('TM isValidValue bad values', () {
      for (var s in badTMList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(TM.isValidValue(a), false);
        }
      }
    });

    test('TM isValidValues good values', () {
      global.throwOnError = false;
      for (var s in goodTMList) {
        expect(TM.isValidValues(PTag.kStudyTime, s), true);
      }
    });

    test('TM isValidValues bad values', () {
      global.throwOnError = false;
      for (var s in badTMList) {
        global.throwOnError = false;
        expect(TM.isValidValues(PTag.kStudyTime, s), false);

        global.throwOnError = true;
        expect(() => TM.isValidValues(PTag.kStudyTime, s),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('TM isValidValues bad values length', () {
      global.throwOnError = false;
      for (var s in badTMLengthList) {
        global.throwOnError = false;
        expect(TM.isValidValues(PTag.kStudyTime, s), false);

        global.throwOnError = true;
        expect(() => TM.isValidValues(PTag.kStudyTime, s),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('TM isValidValues VM.k1 good values length', () {
      for (var i = 0; i < 10; i++) {
        final validList = rsg.getTMList(1, 1);
        for (var tag in tmTags0) {
          global.throwOnError = false;
          expect(TM.isValidValues(tag, validList), true);
        }
      }
    });

    test('TM isValidValues VM.k1 bad values length', () {
      for (var i = 1; i < 10; i++) {
        final validList = rsg.getTMList(2, i + 1);
        for (var tag in tmTags0) {
          global.throwOnError = false;
          expect(TM.isValidValues(tag, validList), false);
          expect(TM.isValidValues(tag, invalidList), false);

          global.throwOnError = true;
          expect(() => TM.isValidValues(tag, validList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
          expect(() => TM.isValidValues(tag, invalidList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('TM isValidValues VM.k1_n length', () {
      for (var i = 1; i < 10; i++) {
        final validList = rsg.getTMList(1, i);
        for (var tag in tmTags1) {
          global.throwOnError = false;
          expect(TM.isValidValues(tag, validList), true);
        }
      }
    });

    test('TM getAsciiList', () {
      //    	system.level = Level.info;
      final vList1 = rsg.getTMList(1, 1);
      final bytes = Bytes.fromAsciiList(vList1);
      log.debug('TM.getAsciiList(bytes): $bytes');
      expect(bytes.getAsciiList(), equals(vList1));
    });

    test('TM toUint8List good values', () {
      final vList1 = rsg.getTMList(1, 1);
      log.debug('Bytes.fromAsciiList(vList1): ${Bytes.fromAsciiList(vList1)}');
      final val = cvt.ascii.encode('s6V&:;s%?Q1g5v');
      expect(Bytes.fromAsciiList(['s6V&:;s%?Q1g5v']), equals(val));

      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = cvt.ascii.encode(vList1[0]);
      expect(Bytes.fromAsciiList(vList1), equals(values));
    });

    test('TM toUint8List bad values length', () {
      global.throwOnError = false;
      final vList0 = rsg.getTMList(TM.kMaxVFLength + 1, TM.kMaxVFLength + 1);
      expect(Bytes.fromAsciiList(vList0), isNull);
      global.throwOnError = true;
      expect(() => Bytes.fromAsciiList(vList0),
          throwsA(const isInstanceOf<InvalidValueFieldError>()));
    });

    test('TM getAsciiList', () {
      final vList1 = rsg.getTMList(1, 1);
      final bytes = Bytes.fromAsciiList(vList1);
      log.debug('TM.getAsciiList(bytes): $bytes');
      expect(bytes.getAsciiList(), equals(vList1));
    });

    test('TM isValidValues good values', () {
      global.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList = rsg.getTMList(1, 1);
        expect(TM.isValidValues(PTag.kAcquisitionTime, vList), vList);
      }

      final vList0 = ['235959'];
      expect(TM.isValidValues(PTag.kAcquisitionTime, vList0), vList0);

      for (var s in goodTMList) {
        global.throwOnError = false;
        expect(TM.isValidValues(PTag.kAcquisitionTime, s), s);
      }
    });

    test('TM isValidValues bad values', () {
      global.throwOnError = false;
      final vList1 = ['235960'];
      expect(TM.isValidValues(PTag.kAcquisitionTime, vList1), isNull);

      global.throwOnError = true;
      expect(() => TM.isValidValues(PTag.kAcquisitionTime, vList1),
          throwsA(const isInstanceOf<InvalidValuesError>()));
      for (var s in badTMList) {
        global.throwOnError = false;
        expect(TM.isValidValues(PTag.kAcquisitionTime, s), isNull);

        global.throwOnError = true;
        expect(() => TM.isValidValues(PTag.kAcquisitionTime, s),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });
    test('TM isValidValues bad values length', () {
      for (var s in badTMLengthList) {
        global.throwOnError = false;
        expect(TM.isValidValues(PTag.kAcquisitionTime, s), isNull);

        global.throwOnError = true;
        expect(() => TM.isValidValues(PTag.kAcquisitionTime, s),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('TM toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 1);
        global.throwOnError = false;
        final values = cvt.ascii.encode(vList0[0]);
        final tbd0 = Bytes.fromAsciiList(vList0);
        final tbd1 = Bytes.fromAsciiList(vList0);
        log.debug('bd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodTMList) {
        for (var a in s) {
          final values = cvt.ascii.encode(a);
          final tbd2 = Bytes.fromAsciiList(s);
          final tbd3 = Bytes.fromAsciiList(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('TM fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.fromAsciiList(vList0);
        final fbd0 = bd0.getAsciiList();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (var s in goodTMList) {
        final bd0 = Bytes.fromAsciiList(s);
        final fbd0 = bd0.getAsciiList();
        expect(fbd0, equals(s));
      }
    });

    test('TM toBytes', () {
      for (var i = 0; i < 10; i++) {
        final sList0 = rsg.getTMList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.fromAsciiList(sList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(sList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodTMList) {
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
          throwsA(const isInstanceOf<GeneralError>()));
    });
  });
}
