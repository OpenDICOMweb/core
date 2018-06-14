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

RSG rsg = new RSG(seed: 1);

void main() {
  Server.initialize(name: 'string/pn_test', level: Level.info);
  global.throwOnError = false;

  const goodPNList = const <List<String>>[
    const <String>['Adams^John Robert Quincy^^Rev.^B.A. M.Div.'],
    const <String>['a^1sd^'],
    const <String>['VXDq^rQJO'],
    const <String>['xm^29sZw^2LOyl^WIg1MuyG']
  ];
  const badPNList = const <List<String>>[
    const <String>['\b'], //	Backspace
    const <String>['\t '], //horizontal tab (HT)
    const <String>['\n'], //linefeed (LF)
    const <String>['\f '], // form feed (FF)
    const <String>['\r '], //carriage return (CR)
    const <String>['\v'], //vertical tab
  ];
  group('PNtag', () {
    test('PN hasValidValues good values', () {
      for (var s in goodPNList) {
        global.throwOnError = false;
        final e0 = new PNtag(PTag.kRequestingPhysician, s);
        expect(e0.hasValidValues, true);
      }
      global.throwOnError = false;
      final e0 = new PNtag(PTag.kOrderEnteredBy, []);
      expect(e0.hasValidValues, true);
      expect(e0.values, equals(<String>[]));
    });

    test('PN hasValidValues bad values', () {
      for (var s in badPNList) {
        global.throwOnError = false;
        final e0 = new PNtag(PTag.kRequestingPhysician, s);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => new PNtag(PTag.kRequestingPhysician, s),
            throwsA(const isInstanceOf<StringError>()));
      }

      global.throwOnError = false;
      final e1 = new PNtag(PTag.kOrderEnteredBy, null);
      log.debug('e1: $e1');
      expect(e1.hasValidValues, true);
      expect(e1.values, StringList.kEmptyList);

      global.throwOnError = true;
      expect(() => new PNtag(PTag.kRequestingPhysician, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('PN hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final e0 = new PNtag(PTag.kRequestingPhysician, vList0);
        log.debug('e0:${e0.info}');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: ${e0.info}');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 10);
        final e1 = new PNtag(PTag.kSelectorPNValue, vList0);
        log.debug('e1:${e1.info}');
        expect(e1.hasValidValues, true);

        log..debug('e1: $e1, values: ${e1.values}')..debug('e1: ${e1.info}');
        expect(e1[0], equals(vList0[0]));
      }
    });

    test('PN hasValidValues bad values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(3, 4);
        log.debug('$i: vList0: $vList0');
        final e2 = new PNtag(PTag.kRequestingPhysician, vList0);
        expect(e2, isNull);
      }

      global.throwOnError = true;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(3, 4);
        log.debug('$i: vList0: $vList0');
        expect(() => new PNtag(PTag.kRequestingPhysician, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('PN update random', () {
      final e0 = new PNtag(PTag.kOrderEnteredBy, []);
      expect(e0.update(['Pb5HpbS4^, bgPK^re']).values,
          equals(['Pb5HpbS4^, bgPK^re']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final e1 = new PNtag(PTag.kOrderEnteredBy, vList0);
        final vList1 = rsg.getPNList(3, 4);
        expect(() => e1.update(vList1).values,
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('PN noValues random', () {
      final e0 = new PNtag(PTag.kOrderEnteredBy, []);
      final PNtag pnNoValues = e0.noValues;
      expect(pnNoValues.values.isEmpty, true);
      log.debug('as0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final e0 = new PNtag(PTag.kOrderEnteredBy, vList0);
        log.debug('e0: $e0');
        expect(pnNoValues.values.isEmpty, true);
        log.debug('e0: ${e0.noValues}');
      }
    });

    test('PN copy random', () {
      final e0 = new PNtag(PTag.kOrderEnteredBy, []);
      final PNtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final e2 = new PNtag(PTag.kOrderEnteredBy, vList0);
        final PNtag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('PN []', () {
      // empty list and null as values
    });

    test('PN hashCode and == random', () {
      log.debug('PN hashCode and == ');
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final e0 = new PNtag(PTag.kOrderEnteredBy, vList0);
        final e1 = new PNtag(PTag.kOrderEnteredBy, vList0);
        log
          ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
          ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);

        final vList1 = rsg.getPNList(1, 1);
        final e2 = new PNtag(PTag.kVerifyingObserverName, vList1);
        log.debug('vList1:$vList1 , lo2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rsg.getPNList(1, 10);
        final e3 = new PNtag(PTag.kSelectorPNValue, vList2);
        log.debug('vList2:$vList2 , lo3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);

        final vList3 = rsg.getPNList(2, 3);
        final e4 = new PNtag(PTag.kOrderEnteredBy, vList3);
        log.debug('vList3:$vList3 , e4.hash_code:${e4.hashCode}');
        expect(e0.hashCode == e4.hashCode, false);
        expect(e0 == e4, false);
      }
    });

    test('PN valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final e0 = new PNtag(PTag.kOrderEnteredBy, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('PN isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final e0 = new PNtag(PTag.kOrderEnteredBy, vList0);
        expect(e0.tag.isValidLength(e0), true);
      }
    });

    test('PN isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final e0 = new PNtag(PTag.kOrderEnteredBy, vList0);
        expect(e0.checkValues(e0.values), true);
        expect(e0.hasValidValues, true);
      }
    });

    test('PN replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final e0 = new PNtag(PTag.kOrderEnteredBy, vList0);
        final vList1 = rsg.getPNList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getPNList(1, 1);
      final e1 = new PNtag(PTag.kOrderEnteredBy, vList1);
      expect(e1.replace([]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = new PNtag(PTag.kOrderEnteredBy, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(<String>[]));
    });

    test('PN blank random', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getPNList(1, 1);
        final e0 = new PNtag(PTag.kOrderEnteredBy, vList1);
        for (var i = 1; i < 10; i++) {
          final blank = e0.blank(i);
          log.debug(('blank$i: ${blank.values}'));
          expect(blank.values.length == 1, true);
          expect(blank.value.length == i, true);
          final strSpaceList = <String>[''.padRight(i, ' ')];
          log.debug('strSpaceList: $strSpaceList');
          expect(blank.values, equals(strSpaceList));
        }
      }
    });

    test('PN fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getPNList(1, 1);
        final bytes = Bytes.fromUtf8List(vList1);
        log.debug('bytes:$bytes');
        final e0 = PNtag.fromBytes(bytes, PTag.kOrderEnteredBy);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);
      }
    });

    test('PN fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getPNList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          //final bytes0 = new Bytes();
          final e1 = PNtag.fromBytes(bytes0, PTag.kSelectorPNValue);
          log.debug('e1: ${e1.info}');
          expect(e1.hasValidValues, true);
        }
      }
    });

    test('PN fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getPNList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.fromAscii(listS);
          //final bytes0 = new Bytes();
          final e1 = PNtag.fromBytes(bytes0, PTag.kSelectorCSValue);
          expect(e1, isNull);

          global.throwOnError = true;
          expect(() => PNtag.fromBytes(bytes0, PTag.kSelectorCSValue),
              throwsA(const isInstanceOf<InvalidTagError>()));
        }
      }
    });

    test('PN fromValues good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final e0 = PNtag.fromValues(PTag.kOrderEnteredBy, vList0);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);

        final e1 = PNtag.fromValues(PTag.kOrderEnteredBy, <String>[]);
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(<String>[]));
      }
    });

    test('PN fromValues bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(2, 2);
        global.throwOnError = false;
        final e0 = PNtag.fromValues(PTag.kOrderEnteredBy, vList0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => PNtag.fromValues(PTag.kOrderEnteredBy, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final e1 = PNtag.fromValues(PTag.kOrderEnteredBy, <String>[null]);
      log.debug('e1: $e1');
      expect(e1, isNull);

      global.throwOnError = true;
      expect(() => PNtag.fromValues(PTag.kOrderEnteredBy, <String>[null]),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('PN checkLength good values', () {
      final vList0 = rsg.getPNList(1, 1);
      final e0 = new PNtag(PTag.kOrderEnteredBy, vList0);
      for (var s in goodPNList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = new PNtag(PTag.kOrderEnteredBy, vList0);
      expect(e1.checkLength([]), true);

      for (var s in goodPNList) {
        final vList1 = rsg.getPNList(1, 10);
        final e2 = new PNtag(PTag.kPerformingPhysicianName, vList1);
        expect(e2.checkLength(s), true);
      }
    });

    test('PN checkLength bad values', () {
      global.throwOnError = false;
      final vList2 = ['a^1sd', '02@#'];
      final e3 = new PNtag(PTag.kOrderEnteredBy, vList2);
      expect(e3, isNull);
    });

    test('PN checkValue good values', () {
      final vList0 = rsg.getPNList(1, 1);
      final e0 = new PNtag(PTag.kOrderEnteredBy, vList0);
      for (var s in goodPNList) {
        for (var a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });

    test('PN checkValue bad values', () {
      final vList0 = rsg.getPNList(1, 1);
      final e0 = new PNtag(PTag.kOrderEnteredBy, vList0);
      for (var s in badPNList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(e0.checkValue(a), false);

          global.throwOnError = true;
          expect(() => e0.checkValue(a),
              throwsA(const isInstanceOf<StringError>()));
        }
      }
    });
  });

  group('PN', () {
    //VM.k1
    const pnVM1Tags = const <PTag>[
      PTag.kReferringPhysicianName,
      PTag.kPatientBirthName,
      PTag.kPatientMotherBirthName,
      PTag.kResponsiblePerson,
      PTag.kEvaluatorName,
      PTag.kScheduledPerformingPhysicianName,
      PTag.kOrderEnteredBy,
      PTag.kVerifyingObserverName,
      PTag.kPersonName,
      PTag.kCurrentObserverTrial,
      PTag.kVerbalSourceTrial,
      PTag.kROIInterpreter,
      PTag.kReviewerName,
      PTag.kInterpretationRecorder,
      PTag.kInterpretationTranscriber,
      PTag.kDistributionName,
      PTag.kPatientName,
    ];

    //VM.k1_n
    const pnVM1_nTags = const <PTag>[
      PTag.kPerformingPhysicianName,
      PTag.kNameOfPhysiciansReadingStudy,
      PTag.kOperatorsName,
      PTag.kOtherPatientNames,
      PTag.kSelectorPNValue,
      PTag.kNamesOfIntendedRecipientsOfResults,
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
      PTag.kTime
    ];

    final invalidVList = rsg.getPNList(PN.kMaxLength + 1, PN.kMaxLength + 1);

    test('PN isValidTag good values', () {
      global.throwOnError = false;
      expect(PN.isValidTag(PTag.kSelectorPNValue), true);

      for (var tag in pnVM1Tags) {
        final validT0 = PN.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('PN isValidTag bad values', () {
      global.throwOnError = false;
      expect(PN.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => PN.isValidTag(PTag.kSelectorFDValue),
          throwsA(const isInstanceOf<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = PN.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => PN.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });

    /*test('PN checkVRIndex good values', () {
      global.throwOnError = false;
      expect(PN.checkVRIndex(kPNIndex), kPNIndex);

      for (var tag in pnTags0) {
        global.throwOnError = false;
        expect(PN.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('PN checkVRIndex bad values', () {
      global.throwOnError = false;
      expect(
          PN.checkVRIndex(
            kAEIndex,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => PN.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(PN.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => PN.checkVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('PN checkVRCode good values', () {
      global.throwOnError = false;
      expect(PN.checkVRCode(kPNCode), kPNCode);

      for (var tag in pnTags0) {
        global.throwOnError = false;
        expect(PN.checkVRCode(tag.vrCode), tag.vrCode);
      }
    });

    test('PN checkVRCode bad values', () {
      global.throwOnError = false;
      expect(
          PN.checkVRCode(
            kAECode,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => PN.checkVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(PN.checkVRCode(tag.vrCode), isNull);

        global.throwOnError = true;
        expect(() => PN.checkVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });*/

    test('PN isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(PN.isValidVRIndex(kPNIndex), true);

      for (var tag in pnVM1Tags) {
        global.throwOnError = false;
        expect(PN.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('PN isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(PN.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => PN.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(PN.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => PN.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('PN isValidVRCode good values', () {
      global.throwOnError = false;
      expect(PN.isValidVRCode(kPNCode), true);

      for (var tag in pnVM1Tags) {
        expect(PN.isValidVRCode(tag.vrCode), true);
      }
    });

    test('PN isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(PN.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => PN.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(PN.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => PN.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('PN isValidVFLength good values', () {
      expect(PN.isValidVFLength(PN.kMaxVFLength), true);
      expect(PN.isValidVFLength(0), true);

      expect(PN.isValidVFLength(PN.kMaxVFLength, null, PTag.kSelectorPNValue),
          true);
    });

    test('PN isValidVFLength bad values', () {
      expect(PN.isValidVFLength(PN.kMaxVFLength + 1), false);
      expect(PN.isValidVFLength(-1), false);

      expect(PN.isValidVFLength(PN.kMaxVFLength, null, PTag.kSelectorSTValue),
          false);
    });

    test('PN isValidValueLength values', () {
      for (var s in goodPNList) {
        for (var a in s) {
          expect(PN.isValidValueLength(a), true);
        }
      }
      expect(PN.isValidValueLength('a'), true);
      expect(PN.isValidValueLength(''), true);
    });

    test('PN isValidValue values', () {
      for (var s in goodPNList) {
        for (var a in s) {
          expect(PN.isValidValue(a), true);
        }
      }
    });

    test('PN isValidValue bad values', () {
      for (var s in badPNList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(PN.isValidValue(a), false);

          global.throwOnError = true;
          expect(() => PN.isValidValue(a),
              throwsA(const isInstanceOf<StringError>()));
        }
      }
    });

    test('PN isValidLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getPNList(1, 1);
        for (var tag in pnVM1Tags) {
          expect(PN.isValidLength(tag, vList), true);

          expect(PN.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(PN.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('PN isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getPNList(2, i + 1);
        for (var tag in pnVM1Tags) {
          global.throwOnError = false;
          expect(PN.isValidLength(tag, vList), false);

          expect(PN.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => PN.isValidLength(tag, vList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }

      global.throwOnError = false;
      final vList0 = rsg.getPNList(1, 1);
      expect(PN.isValidLength(null, vList0), false);

      expect(PN.isValidLength(PTag.kSelectorPNValue, null), isNull);

      global.throwOnError = true;
      expect(() => PN.isValidLength(null, vList0),
          throwsA(const isInstanceOf<InvalidTagError>()));

      expect(() => PN.isValidLength(PTag.kSelectorLOValue, null),
          throwsA(const isInstanceOf<GeneralError>()));
    });

    test('PN isValidLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getPNList(1, i);
        final validMaxLengthList = invalidVList.sublist(0, PN.kMaxLength);
        for (var tag in pnVM1_nTags) {
          log.debug('tag: $tag');
          expect(PN.isValidLength(tag, vList0), true);
          expect(PN.isValidLength(tag, validMaxLengthList), true);
        }
      }
    });

    test('PN isValidValues good values', () {
      global.throwOnError = false;
      for (var s in goodPNList) {
        expect(PN.isValidValues(PTag.kPatientName, s), true);
      }
    });

    test('PN isValidValues bad values', () {
      for (var s in badPNList) {
        global.throwOnError = false;
        expect(PN.isValidValues(PTag.kPatientName, s), false);

        global.throwOnError = true;
        expect(() => PN.isValidValues(PTag.kPatientName, s),
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('PN toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        global.throwOnError = false;
        final values = cvt.ascii.encode(vList0[0]);
        final tbd0 = Bytes.fromUtf8List(vList0);
        final tbd1 = Bytes.fromUtf8List(vList0);
        log.debug('tbd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodPNList) {
        for (var a in s) {
          final values = cvt.ascii.encode(a);
          final tbd2 = Bytes.fromUtf8List(s);
          final tbd3 = Bytes.fromUtf8List(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('PN fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.fromUtf8List(vList0);
        final fbd0 = bd0.getUtf8List();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (var s in goodPNList) {
        final bd0 = Bytes.fromUtf8List(s);
        final fbd0 = bd0.getUtf8List();
        expect(fbd0, equals(s));
      }
    });

    test('PN fromBytes', () {
      //  system.level = Level.info;;
      final vList1 = rsg.getPNList(1, 1);
      final bytes = Bytes.fromUtf8List(vList1);
      log.debug('PN.fromBytes(bytes):  $bytes');
      expect(bytes.getUtf8List(), equals(vList1));
    });

    test('PN toUint8List', () {
      final vList1 = rsg.getPNList(1, 1);
      log.debug('Bytes.fromUtf8List(vList1): ${Bytes.fromUtf8List(vList1)}');

      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = cvt.ascii.encode(vList1[0]);
      expect(Bytes.fromUtf8List(vList1), equals(values));
    });

    test('PN toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vsList0 = rsg.getPNList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.fromUtf8List(vsList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(vsList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodPNList) {
        final toB1 = Bytes.fromUtf8List(s, kMaxShortVF);
        final bytes1 = Bytes.fromAscii(s.join('\\'));
        log.debug('toBytes:$toB1, bytes1: $bytes1');
        expect(toB1, equals(bytes1));
      }

      global.throwOnError = false;
      final toB2 = Bytes.fromUtf8List([''], kMaxShortVF);
      expect(toB2, equals(<String>[]));

      final toB3 = Bytes.fromUtf8List([], kMaxShortVF);
      expect(toB3, equals(<String>[]));

      final toB4 = Bytes.fromUtf8List(null, kMaxShortVF);
      expect(toB4, isNull);

      global.throwOnError = true;
      expect(() => Bytes.fromUtf8List(null, kMaxShortVF),
          throwsA(const isInstanceOf<GeneralError>()));
    });
  });
}
