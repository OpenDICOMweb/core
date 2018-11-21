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

RSG rsg = RSG(seed: 1);

void main() {
  Server.initialize(name: 'string/pn_test', level: Level.info);
  global.throwOnError = false;

  const goodPNList = <List<String>>[
    <String>['Adams^John Robert Quincy^^Rev.^B.A. M.Div.'],
    <String>['a^1sd^'],
    <String>['VXDq^rQJO'],
    <String>['xm^29sZw^2LOyl^WIg1MuyG']
  ];
  const badPNList = <List<String>>[
    <String>['\b'], //	Backspace
    <String>['\t '], //horizontal tab (HT)
    <String>['\n'], //linefeed (LF)
    <String>['\f '], // form feed (FF)
    <String>['\r '], //carriage return (CR)
    <String>['\v'], //vertical tab
  ];
  group('PNtag', () {
    test('PN hasValidValues good values', () {
      for (var s in goodPNList) {
        global.throwOnError = false;
        final e0 = PNtag(PTag.kRequestingPhysician, s);
        expect(e0.hasValidValues, true);
      }
      global.throwOnError = false;
      final e0 = PNtag(PTag.kOrderEnteredBy, []);
      expect(e0.hasValidValues, true);
      expect(e0.values, equals(<String>[]));
    });

    test('PN hasValidValues bad values', () {
      for (var s in badPNList) {
        global.throwOnError = false;
        final e0 = PNtag(PTag.kRequestingPhysician, s);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => PNtag(PTag.kRequestingPhysician, s),
            throwsA(const TypeMatcher<StringError>()));
      }

      global.throwOnError = false;
      final e1 = PNtag(PTag.kOrderEnteredBy, null);
      log.debug('e1: $e1');
      expect(e1.hasValidValues, true);
      expect(e1.values, StringList.kEmptyList);

      global.throwOnError = true;
      expect(() => PNtag(PTag.kRequestingPhysician, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('PN hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final e0 = PNtag(PTag.kRequestingPhysician, vList0);
        log.debug('e0:${e0.info}');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: ${e0.info}');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 10);
        final e1 = PNtag(PTag.kSelectorPNValue, vList0);
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
        final e2 = PNtag(PTag.kRequestingPhysician, vList0);
        expect(e2, isNull);
      }

      global.throwOnError = true;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(3, 4);
        log.debug('$i: vList0: $vList0');
        expect(() => PNtag(PTag.kRequestingPhysician, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('PN update random', () {
      final e0 = PNtag(PTag.kOrderEnteredBy, []);
      expect(e0.update(['Pb5HpbS4^, bgPK^re']).values,
          equals(['Pb5HpbS4^, bgPK^re']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final e1 = PNtag(PTag.kOrderEnteredBy, vList0);
        final vList1 = rsg.getPNList(3, 4);
        expect(() => e1.update(vList1).values,
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('PN noValues random', () {
      final e0 = PNtag(PTag.kOrderEnteredBy, []);
      final PNtag pnNoValues = e0.noValues;
      expect(pnNoValues.values.isEmpty, true);
      log.debug('as0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final e0 = PNtag(PTag.kOrderEnteredBy, vList0);
        log.debug('e0: $e0');
        expect(pnNoValues.values.isEmpty, true);
        log.debug('e0: ${e0.noValues}');
      }
    });

    test('PN copy random', () {
      final e0 = PNtag(PTag.kOrderEnteredBy, []);
      final PNtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final e2 = PNtag(PTag.kOrderEnteredBy, vList0);
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
        final e0 = PNtag(PTag.kOrderEnteredBy, vList0);
        final e1 = PNtag(PTag.kOrderEnteredBy, vList0);
        log
          ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
          ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);

        final vList1 = rsg.getPNList(1, 1);
        final e2 = PNtag(PTag.kVerifyingObserverName, vList1);
        log.debug('vList1:$vList1 , lo2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rsg.getPNList(1, 10);
        final e3 = PNtag(PTag.kSelectorPNValue, vList2);
        log.debug('vList2:$vList2 , lo3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);

        final vList3 = rsg.getPNList(2, 3);
        final e4 = PNtag(PTag.kOrderEnteredBy, vList3);
        log.debug('vList3:$vList3 , e4.hash_code:${e4.hashCode}');
        expect(e0.hashCode == e4.hashCode, false);
        expect(e0 == e4, false);
      }
    });

    test('PN valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final e0 = PNtag(PTag.kOrderEnteredBy, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('PN isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final e0 = PNtag(PTag.kOrderEnteredBy, vList0);
        expect(e0.tag.isValidLength(e0), true);
      }
    });

    test('PN isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final e0 = PNtag(PTag.kOrderEnteredBy, vList0);
        expect(e0.checkValues(e0.values), true);
        expect(e0.hasValidValues, true);
      }
    });

    test('PN replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final e0 = PNtag(PTag.kOrderEnteredBy, vList0);
        final vList1 = rsg.getPNList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getPNList(1, 1);
      final e1 = PNtag(PTag.kOrderEnteredBy, vList1);
      expect(e1.replace([]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = PNtag(PTag.kOrderEnteredBy, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(<String>[]));
    });

    test('PN blank random', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getPNList(1, 1);
        final e0 = PNtag(PTag.kOrderEnteredBy, vList1);
        for (var i = 1; i < 10; i++) {
          final blank = e0.blank(i);
          log.debug('blank$i: ${blank.values}');
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
        final bytes = Bytes.utf8FromList(vList1);
        log.debug('bytes:$bytes');
        final e0 = PNtag.fromBytes(PTag.kOrderEnteredBy, bytes);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);
      }
    });

    test('PN fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getPNList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.ascii(listS);
          //final bytes0 = Bytes();
          final e1 = PNtag.fromBytes(PTag.kSelectorPNValue, bytes0);
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
          final bytes0 = Bytes.ascii(listS);
          //final bytes0 = Bytes();
          final e1 = PNtag.fromBytes(PTag.kSelectorCSValue, bytes0);
          expect(e1, isNull);

          global.throwOnError = true;
          expect(() => PNtag.fromBytes(PTag.kSelectorCSValue, bytes0),
              throwsA(const TypeMatcher<InvalidTagError>()));
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
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final e1 = PNtag.fromValues(PTag.kOrderEnteredBy, <String>[null]);
      log.debug('e1: $e1');
      expect(e1, isNull);

      global.throwOnError = true;
      expect(() => PNtag.fromValues(PTag.kOrderEnteredBy, <String>[null]),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('PN checkLength good values', () {
      final vList0 = rsg.getPNList(1, 1);
      final e0 = PNtag(PTag.kOrderEnteredBy, vList0);
      for (var s in goodPNList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = PNtag(PTag.kOrderEnteredBy, vList0);
      expect(e1.checkLength([]), true);

      for (var s in goodPNList) {
        final vList1 = rsg.getPNList(1, 10);
        final e2 = PNtag(PTag.kPerformingPhysicianName, vList1);
        expect(e2.checkLength(s), true);
      }
    });

    test('PN checkLength bad values', () {
      global.throwOnError = false;
      final vList2 = ['a^1sd', '02@#'];
      final e3 = PNtag(PTag.kOrderEnteredBy, vList2);
      expect(e3, isNull);
    });

    test('PN checkValue good values', () {
      final vList0 = rsg.getPNList(1, 1);
      final e0 = PNtag(PTag.kOrderEnteredBy, vList0);
      for (var s in goodPNList) {
        for (var a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });

    test('PN checkValue bad values', () {
      final vList0 = rsg.getPNList(1, 1);
      final e0 = PNtag(PTag.kOrderEnteredBy, vList0);
      for (var s in badPNList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(e0.checkValue(a), false);

          global.throwOnError = true;
          expect(() => e0.checkValue(a),
              throwsA(const TypeMatcher<StringError>()));
        }
      }
    });

    test('PN append', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 4);
        final e0 = PNtag(PTag.kSelectorPNValue, vList0);
        const vList1 = 'foo';
        final append0 = e0.append(vList1);
        log.debug('append0: $append0');
        expect(append0, isNotNull);
      }
    });

    test('PN prepend', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 4);
        final e0 = PNtag(PTag.kSelectorPNValue, vList0);
        const vList1 = 'foo';
        final prepend0 = e0.prepend(vList1);
        log.debug('prepend0: $prepend0');
        expect(prepend0, isNotNull);
      }
    });

    test('PN truncate', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 4, 16);
        final e0 = PNtag(PTag.kSelectorPNValue, vList0);
        final truncate0 = e0.truncate(10);
        log.debug('truncate0: $truncate0');
        expect(truncate0, isNotNull);
      }
    });

    test('PN match', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 10);
        final e0 = PNtag(PTag.kSelectorPNValue, vList0);
        final match0 = e0.match(r'.*');
        expect(match0, true);
      }

      final vList0 = ['4gBerroDcI'];
      final e0 = PNtag(PTag.kSelectorPNValue, vList0);
      final match0 = e0.match(r'\w*[a-z][A-Z]');
      expect(match0, true);

      final vList1 = ['RI1tpHSEP^G9GyVhSpU1z^KzJGP^VwsO8L^p6eZh_'];
      final e1 = PNtag(PTag.kSelectorPNValue, vList1);
      final match1 = e1.match(r'\w*[a-z_A-Z][0-9]');
      expect(match1, true);
    });

    test('PN valueFromBytes', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getPNList(1, i);
        final bytes = Bytes.utf8FromList(vList0);
        final e0 = PNtag(PTag.kSelectorPNValue, vList0);
        final vfb0 = e0.valuesFromBytes(bytes);
        expect(vfb0, equals(vList0));
      }
    });

    test('PN check', () {
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getPNList(1, 1);
        final e0 = PNtag(PTag.kEvaluatorName, vList);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList[0]));
      }

      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getPNList(1, i);
        final e0 = PNtag(PTag.kSelectorPNValue, vList1);
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);
        expect(e0[0], equals(vList1[0]));
      }
    });

    test('PN valuesEqual good values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getPNList(1, 1);
        final e0 = PNtag(PTag.kSelectorPNValue, vList);
        final e1 = PNtag(PTag.kSelectorPNValue, vList);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), true);
      }
    });

    test('PN valuesEqual bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getPNList(1, i);
        final vList1 = rsg.getPNList(1, 1);
        final e0 = PNtag(PTag.kSelectorPNValue, vList0);
        final e1 = PNtag(PTag.kSelectorPNValue, vList1);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), false);
      }
    });

    test('PN fromValueField', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        log.debug('vList0: $vList0');
        final fvf0 = Ascii.fromValueField(vList0, k8BitMaxLongVF);
        expect(fvf0, equals(vList0));
      }

      for (var i = 1; i < 10; i++) {
        global.throwOnError = false;
        final vList1 = rsg.getPNList(1, i);
        final fvf1 = Ascii.fromValueField(vList1, k8BitMaxLongVF);
        expect(fvf1, equals(vList1));
      }
      global.throwOnError = false;
      final fvf1 = Ascii.fromValueField(null, k8BitMaxLongLength);
      expect(fvf1, <String>[]);
      expect(fvf1 == kEmptyStringList, true);

      final fvf2 = Ascii.fromValueField(<String>[], k8BitMaxLongLength);
      expect(fvf2, <String>[]);
      expect(fvf2 == kEmptyStringList, false);
      expect(fvf2.isEmpty, true);

      final fvf3 = Ascii.fromValueField(<int>[1234], k8BitMaxLongLength);
      expect(fvf3, isNull);

      global.throwOnError = true;
      expect(() => Ascii.fromValueField(<int>[1234], k8BitMaxLongLength),
          throwsA(const TypeMatcher<InvalidValuesError>()));

      global.throwOnError = false;
      final vList2 = rsg.getCSList(1, 1);
      final bytes = Bytes.utf8FromList(vList2);
      final fvf4 = Ascii.fromValueField(bytes, k8BitMaxLongLength);
      expect(fvf4, equals(vList2));
    });
  });

  group('PN', () {
    //VM.k1
    const pnVM1Tags = <PTag>[
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
    const pnVM1nTags = <PTag>[
      PTag.kPerformingPhysicianName,
      PTag.kNameOfPhysiciansReadingStudy,
      PTag.kOperatorsName,
      PTag.kOtherPatientNames,
      PTag.kSelectorPNValue,
      PTag.kNamesOfIntendedRecipientsOfResults,
    ];

    const otherTags = <PTag>[
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
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = PN.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => PN.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

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
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(PN.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => PN.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
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
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(PN.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => PN.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
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
              throwsA(const TypeMatcher<StringError>()));
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
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }

      global.throwOnError = false;
      final vList0 = rsg.getPNList(1, 1);
      expect(PN.isValidLength(null, vList0), false);

      expect(PN.isValidLength(PTag.kSelectorPNValue, null), isNull);

      global.throwOnError = true;
      expect(() => PN.isValidLength(null, vList0),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => PN.isValidLength(PTag.kSelectorLOValue, null),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('PN isValidLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getPNList(1, i);
        final validMaxLengthList = invalidVList.sublist(0, PN.kMaxLength);
        for (var tag in pnVM1nTags) {
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
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('PN toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        global.throwOnError = false;
        final values = cvt.ascii.encode(vList0[0]);
        final tbd0 = Bytes.utf8FromList(vList0);
        final tbd1 = Bytes.utf8FromList(vList0);
        log.debug('tbd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodPNList) {
        for (var a in s) {
          final values = cvt.ascii.encode(a);
          final tbd2 = Bytes.utf8FromList(s);
          final tbd3 = Bytes.utf8FromList(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('PN fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.utf8FromList(vList0);
        final fbd0 = bd0.stringListFromUtf8();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (var s in goodPNList) {
        final bd0 = Bytes.utf8FromList(s);
        final fbd0 = bd0.stringListFromUtf8();
        expect(fbd0, equals(s));
      }
    });

    test('PN fromBytes', () {
      //  system.level = Level.info;;
      final vList1 = rsg.getPNList(1, 1);
      final bytes = Bytes.utf8FromList(vList1);
      log.debug('PN.fromBytes(bytes):  $bytes');
      expect(bytes.stringListFromUtf8(), equals(vList1));
    });

    test('PN toUint8List', () {
      final vList1 = rsg.getPNList(1, 1);
      log.debug('Bytes.fromUtf8List(vList1): ${Bytes.utf8FromList(vList1)}');

      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = cvt.ascii.encode(vList1[0]);
      expect(Bytes.utf8FromList(vList1), equals(values));
    });

    test('PN toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vsList0 = rsg.getPNList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.utf8FromList(vsList0, kMaxShortVF);
        final bytes0 = Bytes.ascii(vsList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodPNList) {
        final toB1 = Bytes.utf8FromList(s, kMaxShortVF);
        final bytes1 = Bytes.ascii(s.join('\\'));
        log.debug('toBytes:$toB1, bytes1: $bytes1');
        expect(toB1, equals(bytes1));
      }

      global.throwOnError = false;
      final toB2 = Bytes.utf8FromList([''], kMaxShortVF);
      expect(toB2, equals(<String>[]));

      final toB3 = Bytes.utf8FromList([], kMaxShortVF);
      expect(toB3, equals(<String>[]));

      final toB4 = Bytes.utf8FromList(null, kMaxShortVF);
      expect(toB4, isNull);

      global.throwOnError = true;
      expect(() => Bytes.utf8FromList(null, kMaxShortVF),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('PN isValidBytesArgs', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getPNList(1, i);
        final vfBytes = Bytes.utf8FromList(vList0);

        if (vList0.length == 1) {
          for (var tag in pnVM1Tags) {
            final e0 = PN.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else {
          for (var tag in pnVM1nTags) {
            final e0 = PN.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        }
      }
      final vList0 = rsg.getPNList(1, 1);
      final vfBytes = Bytes.utf8FromList(vList0);

      final e1 = PN.isValidBytesArgs(null, vfBytes);
      expect(e1, false);

      final e2 = PN.isValidBytesArgs(PTag.kDate, vfBytes);
      expect(e2, false);

      final e3 = PN.isValidBytesArgs(PTag.kSelectorPNValue, null);
      expect(e3, false);

      global.throwOnError = true;
      expect(() => PN.isValidBytesArgs(null, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => PN.isValidBytesArgs(PTag.kDate, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));
    });
  });
}
