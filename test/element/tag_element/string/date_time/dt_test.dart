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
      name: 'string/dt_test',
      level: Level.info,
      minYear: 0000,
      maxYear: 2100,
      throwOnError: false);
  global.throwOnError = false;

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
        final e0 = DTtag.fromBytes(PTag.kDateTime, bytes);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
      }
    });

    test('DT getAsciiList random', () {
      //    	system.level = Level.info;
      //fromBytes
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDTList(1, 1);
        final bytes = Bytes.fromAsciiList(vList1);
        log.debug('bytes:$bytes');
        final e0 = DTtag.fromBytes(PTag.kDateTime, bytes);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
      }
    });

    test('DT fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDTList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          final e1 = DTtag.fromBytes(PTag.kSelectorDTValue, bytes0);
          log.debug('e1: $e1');
          expect(e1.hasValidValues, true);
        }
      }
    });

    test('DT fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getDTList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.fromAscii(listS);
          final e1 = DTtag.fromBytes(PTag.kSelectorAEValue, bytes0);
          expect(e1, isNull);

          global.throwOnError = true;
          expect(() => DTtag.fromBytes(PTag.kSelectorAEValue, bytes0),
              throwsA(const TypeMatcher<InvalidTagError>()));
        }
      }
    });

    test('DT hasValidValues good values', () {
      for (var s in goodDTList) {
        global.throwOnError = false;
        final e0 = new DTtag(PTag.kFrameAcquisitionDateTime, s);
        expect(e0.hasValidValues, true);
      }

      // empty list and null as values
      global.throwOnError = false;
      final e0 = new DTtag(PTag.kDateTime, <String>[]);
      expect(e0.hasValidValues, true);
      expect(e0.values, equals(<String>[]));
    });

    test('DT hasValidValues bad values', () {
      for (var s in badDTList) {
        global.throwOnError = false;
        final e1 = new DTtag(PTag.kFrameAcquisitionDateTime, s);
        expect(e1, isNull);

        global.throwOnError = true;
        expect(() => new DTtag(PTag.kFrameAcquisitionDateTime, s),
            throwsA(const TypeMatcher<StringError>()));

        global.throwOnError = false;
        final e2 = new DTtag(PTag.kDateTime, null);
        expect(e2.isEmpty, true);
        expect(e2.values.isEmpty, true);

        global.throwOnError = true;
        expect(() => new DTtag(PTag.kDateTime, null),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('DT hasValidValues good random', () {
      global.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        log.debug('vList0: $vList0');
        final e0 = new DTtag(PTag.kDateTime, vList0);
        expect(e0.hasValidValues, true);
      }
    });

    test('DT hasValidValues bad random', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getDTList(3, 4);
        log.debug('$i: vList0: $vList0');
        final e1 = new DTtag(PTag.kDateTime, vList0);
        expect(e1, isNull);

        global.throwOnError = true;
        expect(() => new DTtag(PTag.kDateTime, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
        expect(e1, isNull);
      }
    });

    test('DT update', () {
      global.throwOnError = false;
      final e0 = new DTtag(PTag.kDateTime, <String>[]);
      expect(e0.update(['19991025235959']).values, equals(['19991025235959']));

      final e1 = new DTtag(PTag.kDateTime, ['19991025235959']);
      final e2 = new DTtag(PTag.kDateTime, ['19991025235959']);
      final e3 = e1.update(['21231025135959']);
      final e4 = e2.update(['21231025135959']);
      expect(e1 == e4, false);
      expect(e2 == e4, false);
      expect(e3 == e4, true);

      for (var s in goodDTList) {
        final e5 = new DTtag(PTag.kDateTime, s);
        final e6 = e5.update(['19901125235959']);
        final e7 = e5.update(['19901125235959']);
        expect(e5.values.first == e6.values.first, false);
        expect(e5 == e6, false);
        expect(e6 == e7, true);
      }
      expect(utility.testElementUpdate(e1, <String>['19901125235959']), true);
    });

    test('DT update random', () {
      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        final e0 = new DTtag(PTag.kDateTime, vList0);
        final vList1 = rsg.getDTList(1, 1);
        expect(e0.update(vList1).values, equals(vList1));
      }
    });

    test('DT noValues', () {
      final e1 = new DTtag(PTag.kDateTime, ['19991025235959']);
      final dtNoValues1 = e1.noValues;
      expect(dtNoValues1.values.isEmpty, true);
      log.debug('dtNoValues1:$dtNoValues1');

      for (var s in goodDTList) {
        final e1 = new DTtag(PTag.kDateTime, s);
        final dtNoValues1 = e1.noValues;
        expect(dtNoValues1.values.isEmpty, true);
      }
    });

    test('DT noValues random ', () {
      final e0 = new DTtag(PTag.kDateTime, <String>[]);
      final DTtag dtNoValues0 = e0.noValues;
      expect(dtNoValues0.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        final e0 = new DTtag(PTag.kDateTime, vList0);
        log.debug('e0: $e0');
        expect(dtNoValues0.values.isEmpty, true);
        log.debug('e0: ${e0.noValues}');
      }
    });

    test('DT copy', () {
      final e0 = new DTtag(PTag.kDateTime, <String>[]);
      final DTtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      final e2 = new DTtag(PTag.kDateTime, ['19991025235959']);
      final e3 = e2.copy;
      expect(e2 == e3, true);
      expect(e2.hashCode == e3.hashCode, true);

      for (var s in goodDTList) {
        final e4 = new DTtag(PTag.kDateTime, s);
        final e5 = e4.copy;
        expect(e4 == e5, true);
        expect(e4.hashCode == e5.hashCode, true);
      }
      expect(utility.testElementCopy(e0), true);
    });

    test('DT copy random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        final e2 = new DTtag(PTag.kDateTime, vList0);
        final DTtag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('DT hashCode and == good values', () {
      global.throwOnError = false;
      final vList0 = ['19991025235959'];
      final e0 = new DTtag(PTag.kDateTime, vList0);
      final e1 = new DTtag(PTag.kDateTime, vList0);
      log
        ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
        ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);
    });

    test('DT hashCode and == bad values', () {
      global.throwOnError = false;
      final vList0 = ['19991025235959'];
      final e0 = new DTtag(PTag.kDateTime, vList0);
      final e2 = new DTtag(PTag.kTemplateVersion, vList0);
      log.debug('vList0:$vList0 , da2.hash_code:${e2.hashCode}');
      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);
    });

    test('DT hashCode and == good values random', () {
      global.throwOnError = false;
      List<String> stringList0;

      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getDTList(1, 1);
        final e0 = new DTtag(PTag.kDateTime, stringList0);
        final e1 = new DTtag(PTag.kDateTime, stringList0);
        log
          ..debug('stringList0:$stringList0, e0.hash_code:${e0.hashCode}')
          ..debug('stringList0:$stringList0, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('DT hashCode and == bad values random', () {
      global.throwOnError = false;
      List<String> stringList0;
      List<String> stringList1;

      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getDTList(1, 1);
        final e0 = new DTtag(PTag.kDateTime, stringList0);
        stringList1 = rsg.getDTList(2, 3);
        final e3 = new DTtag(PTag.kSelectorDTValue, stringList1);
        log.debug('stringList1:$stringList1 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);
      }
    });

    test('DT valuesCopy ranodm', () {
      for (var s in goodDTList) {
        final e0 = new DTtag(PTag.kDateTime, s);
        expect(s, equals(e0.valuesCopy));
      }

      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        final e1 = new DTtag(PTag.kDateTime, vList0);
        expect(vList0, equals(e1.valuesCopy));
      }
    });

    test('DT isValidLength', () {
      for (var s in goodDTList) {
        final e0 = new DTtag(PTag.kDateTime, s);
        expect(e0.checkLength(e0.values), true);
      }
    });

    test('DT isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        final e0 = new DTtag(PTag.kDateTime, vList0);
        expect(e0.checkLength(e0.values), true);
      }
    });

    test('DT isValidValues ', () {
      for (var s in goodDTList) {
        final e0 = new DTtag(PTag.kDateTime, s);
        expect(e0.checkValues(e0.values), true);
        expect(e0.hasValidValues, true);
      }

      global.throwOnError = true;
      for (var s in badDTList) {
        expect(() => new DTtag(PTag.kDateTime, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('DT isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        final e0 = new DTtag(PTag.kDateTime, vList0);
        expect(e0.checkValues(e0.values), true);
        expect(e0.hasValidValues, true);
      }
    });

    test('DT replace', () {
      global.throwOnError = false;

      final vList0 = ['19991025235959'];
      final e0 = new DTtag(PTag.kDateTime, vList0);
      final vList1 = ['19001025235959'];
      expect(e0.replace(vList1), equals(vList0));
      expect(e0.values, equals(vList1));

      final e1 = new DTtag(PTag.kDateTime, vList1);
      expect(e1.replace(<String>[]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = new DTtag(PTag.kDateTime, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values == StringList.kEmptyList, true);
    });

    test('DT replace random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        final e0 = new DTtag(PTag.kDateTime, vList0);
        final vList1 = rsg.getDTList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getDTList(1, 1);
      final e1 = new DTtag(PTag.kDateTime, vList1);
      expect(e1.replace(<String>[]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = new DTtag(PTag.kDateTime, null);
      expect(e2.isEmpty, true);
      expect(e2.values.isEmpty, true);
    });

    test('DT checkLength good values', () {
      final e0 = new DTtag(PTag.kDateTime, ['19500718105630']);
      for (var s in goodDTList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = new DTtag(PTag.kDateTime, ['19500718105630']);
      expect(e1.checkLength(<String>[]), true);
    });

    test('DT checkLength bad values', () {
      final vList0 = ['19500718105630', '20181206235959'];
      final e2 = new DTtag(PTag.kDateTime, ['19500718105630']);
      expect(e2.checkLength(vList0), false);
    });

    test('DT checkLength random', () {
      final vList0 = rsg.getDTList(1, 1);
      final e0 = new DTtag(PTag.kDateTime, vList0);
      for (var s in goodDTList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = new DTtag(PTag.kDateTime, vList0);
      expect(e1.checkLength(<String>[]), true);
    });

    test('DT checkValue good values', () {
      final e0 = new DTtag(PTag.kDateTime, ['19500718105630']);
      for (var s in goodDTList) {
        for (var a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });

    test('DT checkValue bad values', () {
      final e0 = new DTtag(PTag.kDateTime, ['19500718105630']);
      for (var s in badDTList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(e0.checkValue(a), false);
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
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final make1 = DTtag.fromValues(PTag.kDateTime, <String>[null]);
      log.debug('mak1: $make1');
      expect(make1, isNull);

      global.throwOnError = true;
      expect(() => DTtag.fromValues(PTag.kDateTime, <String>[null]),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });
  });

  group('DT Element', () {
    const badDTLengthList = const <List<String>>[
      const <String>['20170223122334.111111+11000000', '1970011a105630.111111+110000'],
      const <String>['201', '1'],
    ];

    //VM.k1
    const dtVM1Tags = const <PTag>[
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
    const dtVM1_nTags = const <PTag>[PTag.kSelectorDTValue];

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

      for (var tag in dtVM1Tags) {
        final valie0 = DT.isValidTag(tag);
        expect(valie0, true);
      }
    });

    test('DT isValidTag bad values', () {
      global.throwOnError = false;
      expect(DT.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => DT.isValidTag(PTag.kSelectorFDValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final valie0 = DT.isValidTag(tag);
        expect(valie0, false);

        global.throwOnError = true;
        expect(() => DT.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('DT isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(DT.isValidVRIndex(kDTIndex), true);

      for (var tag in dtVM1Tags) {
        global.throwOnError = false;
        expect(DT.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('DT isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(DT.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => DT.isValidVRIndex(kCSIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));
      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(DT.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => DT.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('DT isValidVRCode good values', () {
      global.throwOnError = false;
      expect(DT.isValidVRCode(kDTCode), true);

      for (var tag in dtVM1Tags) {
        expect(DT.isValidVRCode(tag.vrCode), true);
      }
    });

    test('DT isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(DT.isValidVRCode(kSSCode), false);

      global.throwOnError = true;
      expect(() => DT.isValidVRCode(kSSCode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(DT.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => DT.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('DT isValidVFLength good values', () {
      expect(DT.isValidVFLength(DT.kMaxVFLength), true);
      expect(DT.isValidVFLength(0), true);

      expect(DT.isValidVFLength(DT.kMaxVFLength, null, PTag.kSelectorDTValue),
          true);
    });

    test('DT isValidVFLength bad values', () {
      expect(DT.isValidVFLength(DT.kMaxVFLength + 1), false);
      expect(DT.isValidVFLength(-1), false);

      expect(DT.isValidVFLength(DT.kMaxVFLength, null, PTag.kSelectorSTValue),
          false);
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
          global.throwOnError = false;
          expect(DT.isValidValueLength(a), false);
        }
      }
      expect(DT.isValidValueLength('20170223122334.111111+11000000'), false);
    });

    test('DT isValidLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getDTList(1, 1);
        for (var tag in dtVM1Tags) {
          expect(DT.isValidLength(tag, vList), true);
        }
      }
    });

    test('DT isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getDTList(2, i + 1);
        for (var tag in dtVM1Tags) {
          global.throwOnError = false;
          expect(DT.isValidLength(tag, vList), false);

          global.throwOnError = true;
          expect(() => DT.isValidLength(tag, vList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
      global.throwOnError = false;
      final vList0 = rsg.getDTList(1, 1);
      expect(DT.isValidLength(null, vList0), false);

      expect(DT.isValidLength(PTag.kSelectorDTValue, null), isNull);

      global.throwOnError = true;
      expect(() => DT.isValidLength(null, vList0),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => DT.isValidLength(PTag.kSelectorDTValue, null),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('DT isValidLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getDTList(1, i);
        for (var tag in dtVM1_nTags) {
          log.debug('tag: $tag');
          expect(DT.isValidLength(tag, vList0), true);
        }
      }
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
              throwsA(const TypeMatcher<StringError>()));
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
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('DT isValidValues bad values length', () {
      global.throwOnError = false;
      for (var s in badDTLengthList) {
        global.throwOnError = false;
        expect(DT.isValidValues(PTag.kDateTime, s), false);

        global.throwOnError = true;
        expect(() => DT.isValidValues(PTag.kDateTime, s),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('DT isValidValues VM.k1 good values length', () {
      for (var i = 0; i < 10; i++) {
        final validList = rsg.getDTList(1, 1);
        for (var tag in dtVM1Tags) {
          global.throwOnError = false;
          expect(DT.isValidValues(tag, validList), true);
        }
      }
    });

    test('DT isValidValues VM.k1 bad values length', () {
      for (var i = 1; i < 10; i++) {
        final validList = rsg.getDTList(2, i + 1);
        for (var tag in dtVM1Tags) {
          global.throwOnError = false;
          expect(DT.isValidValues(tag, validList), false);
          expect(DT.isValidValues(tag, invalidList), false);

          global.throwOnError = true;
          expect(() => DT.isValidValues(tag, validList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
          expect(() => DT.isValidValues(tag, invalidList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('DT isValidValues VM.k1_n length', () {
      for (var i = 1; i < 10; i++) {
        final validList = rsg.getDTList(1, i);
        for (var tag in dtVM1_nTags) {
          global.throwOnError = false;
          expect(DT.isValidValues(tag, validList), true);
        }
      }
    });

    test('DT isValidValues good values', () {
      global.throwOnError = false;
      final vList0 = ['19500718105630'];
      expect(DT.isValidValues(PTag.kDateTime, vList0), true);

      final vList1 = ['19501318'];
      expect(DT.isValidValues(PTag.kDateTime, vList1), false);

      global.throwOnError = true;
      expect(() => DT.isValidValues(PTag.kDateTime, vList1),
          throwsA(const TypeMatcher<StringError>()));

      for (var s in goodDTList) {
        global.throwOnError = false;
        expect(DT.isValidValues(PTag.kDateTime, s), true);
      }
    });

    test('DT isValidValues random', () {
      global.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        expect(DT.isValidValues(PTag.kDateTime, vList0), true);
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
      expect(vList0.length > DT.kMaxLength, true);
      final bytes = Bytes.fromAsciiList(vList0);
      expect(bytes, isNotNull);
      expect(bytes.length > DT.kMaxVFLength, true);
      expect(DT.isValidBytesArgs(PTag.kSelectorDTValue, bytes), false);

      global.throwOnError = true;
      expect(() => DT.isValidBytesArgs(PTag.kSelectorDTValue, bytes),
                 throwsA(const TypeMatcher<InvalidValueFieldError>()));
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
        final vList0 = rsg.getDTList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.fromAsciiList(vList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(vList0.join('\\'));
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
          throwsA(const TypeMatcher<GeneralError>()));
    });
  });
}
