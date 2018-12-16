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

RSG rsg = RSG(seed: 1);
RNG rng = RNG(1);

void main() {
  Server.initialize(name: 'string/lo_test', level: Level.info);
  global.throwOnError = false;

  const goodLOList = <List<String>>[
    <String>['5b9LE'],
    <String>['_hYZI`r[,'],
    <String>['560'],
    <String>[' fr<(Kf_d=wS'],
    <String>['&t&wSB)~P']
  ];

  const badLOList = <List<String>>[
    <String>['\b'], //	Backspace
    <String>['\t '], //horizontal tab (HT)
    <String>['\n'], //linefeed (LF)
    <String>['\f '], // form feed (FF)
    <String>['\r '], //carriage return (CR)
    <String>['\v'], //vertical tab
    <String>[r'\'],
    <String>['B\\S'],
    <String>['1\\9'],
    <String>['a\\4'],
    <String>[r'^`~\\?'],
    <String>[r'^\?'],
  ];

  group('LO Tests', () {
    test('LO hasValidValues good values', () {
      for (var s in goodLOList) {
        global.throwOnError = false;
        final e0 = LOtag(PTag.kReceiveCoilManufacturerName, s);
        expect(e0.hasValidValues, true);
      }

      global.throwOnError = false;
      final e0 = LOtag(PTag.kReceiveCoilManufacturerName, []);
      expect(e0.hasValidValues, true);
      expect(e0.values, equals(<String>[]));
    });

    test('LO hasValidValues bad values', () {
      for (var s in badLOList) {
        global.throwOnError = false;
        final e0 = LOtag(PTag.kReceiveCoilManufacturerName, s);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => LOtag(PTag.kReceiveCoilManufacturerName, s),
            throwsA(const TypeMatcher<StringError>()));
      }

      global.throwOnError = false;
      final e1 = LOtag(PTag.kReceiveCoilManufacturerName, null);
      log.debug('e1: $e1');
      expect(e1.hasValidValues, true);
      expect(e1.values, StringList.kEmptyList);

      global.throwOnError = true;
      expect(() => LOtag(PTag.kReceiveCoilManufacturerName, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('LO hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        final e0 = LOtag(PTag.kReceiveCoilManufacturerName, vList0);
        log.debug('e0:${e0.info}');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: ${e0.info}');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 10);
        final e1 = LOtag(PTag.kReference, vList0);
        log.debug('e1:${e1.info}');
        expect(e1.hasValidValues, true);

        log..debug('e1: $e1, values: ${e1.values}')..debug('e1: ${e1.info}');
        expect(e1[0], equals(vList0[0]));
      }
    });

    test('LO hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getLOList(3, 4);
        log.debug('$i: vList0: $vList0');
        final e2 = LOtag(PTag.kReceiveCoilManufacturerName, vList0);
        expect(e2, isNull);

        global.throwOnError = true;
        expect(() => LOtag(PTag.kReceiveCoilManufacturerName, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('LO update random', () {
      final e0 = LOtag(PTag.kReference, []);
      expect(e0.update(['DN{~44F, 1H}B#86, _3YX80jD2;.>4c']).values,
          equals(['DN{~44F, 1H}B#86, _3YX80jD2;.>4c']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(3, 4);
        final e1 = LOtag(PTag.kReference, vList0);
        final vList1 = rsg.getLOList(3, 4);
        expect(e1.update(vList1).values, equals(vList1));
      }
    });

    test('LO noValues random', () {
      final e0 = LOtag(PTag.kReference, []);
      final LOtag loNoValues = e0.noValues;
      expect(loNoValues.values.isEmpty, true);
      log.debug('as0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(3, 4);
        final e0 = LOtag(PTag.kReference, vList0);
        log.debug('e0: $e0');
        expect(loNoValues.values.isEmpty, true);
        log.debug('as0: ${e0.noValues}');
      }
    });

    test('LO copy random', () {
      final e0 = LOtag(PTag.kReference, []);
      final LOtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(3, 4);
        final e2 = LOtag(PTag.kReference, vList0);
        final LOtag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('LO hashCode and == good values random', () {
      List<String> vList0;
      for (var i = 0; i < 10; i++) {
        vList0 = rsg.getLOList(1, 1);
        final e0 = LOtag(PTag.kReceiveCoilManufacturerName, vList0);
        final e1 = LOtag(PTag.kReceiveCoilManufacturerName, vList0);
        log
          ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
          ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('LO hashCode and == bad values random', () {
      global.throwOnError = false;
      log.debug('LO hashCode and == ');
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        final e0 = LOtag(PTag.kReceiveCoilManufacturerName, vList0);

        final vList1 = rsg.getLOList(1, 1);
        final e2 = LOtag(PTag.kPositionReferenceIndicator, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rsg.getLOList(1, 10);
        final e3 = LOtag(PTag.kReference, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);

        final vList3 = rsg.getLOList(2, 3);
        final e4 = LOtag(PTag.kReceiveCoilManufacturerName, vList3);
        log.debug('vList3:$vList3 , e4.hash_code:${e4.hashCode}');
        expect(e0.hashCode == e4.hashCode, false);
        expect(e0 == e4, false);
      }
    });

    test('LO valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        final e0 = LOtag(PTag.kReceiveCoilManufacturerName, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('LO isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        final e0 = LOtag(PTag.kReceiveCoilManufacturerName, vList0);
        expect(e0.tag.isValidLength(e0), true);
      }
    });

    test('LO checkValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        final e0 = LOtag(PTag.kReceiveCoilManufacturerName, vList0);
        expect(e0.checkValues(e0.values), true);
        expect(e0.hasValidValues, true);
      }
    });

    test('LO checkValues bad values random', () {
      final vList0 = rsg.getLOList(1, 1);
      final e1 = LOtag(PTag.kReceiveCoilManufacturerName, vList0);

      for (var s in badLOList) {
        global.throwOnError = false;
        expect(e1.checkValues(s), false);

        global.throwOnError = true;
        expect(
            () => e1.checkValues(s), throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('LO replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        final e0 = LOtag(PTag.kReceiveCoilManufacturerName, vList0);
        final vList1 = rsg.getLOList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getLOList(1, 1);
      final e1 = LOtag(PTag.kReceiveCoilManufacturerName, vList1);
      expect(e1.replace([]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = LOtag(PTag.kReceiveCoilManufacturerName, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e1.values, equals(<String>[]));
    });

    test('LO blank random', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getLOList(1, 1);
        final e0 = LOtag(PTag.kReceiveCoilManufacturerName, vList1);
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

    test('LO fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getLOList(1, 1);
        final bytes = Bytes.utf8FromList(vList1);
        log.debug('bytes:$bytes');
        final e0 = LOtag.fromBytes(
            PTag.kReceiveCoilManufacturerName, bytes, Charset.utf8);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);
      }
    });

    test('LO fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getLOList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.ascii(listS);
          //final bytes0 = Bytes();
          final e1 =
              LOtag.fromBytes(PTag.kSelectorLOValue, bytes0, Charset.utf8);
          log.debug('e1: ${e1.info}');
          expect(e1.hasValidValues, true);
        }
      }
    });

    test('LO fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getLOList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.ascii(listS);
          //final bytes0 = Bytes();
          final e1 =
              LOtag.fromBytes(PTag.kSelectorCSValue, bytes0, Charset.utf8);
          expect(e1, isNull);

          global.throwOnError = true;
          expect(
              () =>
                  LOtag.fromBytes(PTag.kSelectorCSValue, bytes0, Charset.utf8),
              throwsA(const TypeMatcher<InvalidTagError>()));
        }
      }
    });

    test('LO fromValues good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        final e0 = LOtag.fromValues(PTag.kReceiveCoilManufacturerName, vList0);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);

        final e1 =
            LOtag.fromValues(PTag.kReceiveCoilManufacturerName, <String>[]);
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(<String>[]));
      }
    });

    test('LO fromValues bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(2, 2);
        global.throwOnError = false;
        final e0 = LOtag.fromValues(PTag.kReceiveCoilManufacturerName, vList0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(
            () => LOtag.fromValues(PTag.kReceiveCoilManufacturerName, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final e1 =
          LOtag.fromValues(PTag.kReceiveCoilManufacturerName, <String>[null]);
      log.debug('mak1: $e1');
      expect(e1, isNull);

      global.throwOnError = true;
      expect(
          () => LOtag.fromValues(
              PTag.kReceiveCoilManufacturerName, <String>[null]),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('LO checkLength good values', () {
      final vList0 = rsg.getLOList(1, 1);
      final e0 = LOtag(PTag.kReceiveCoilManufacturerName, vList0);
      for (var s in goodLOList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = LOtag(PTag.kReceiveCoilManufacturerName, vList0);
      expect(e1.checkLength([]), true);

      final vList1 = rsg.getLOList(1, 10);
      final e2 = LOtag(PTag.kReference, vList1);
      for (var s in goodLOList) {
        expect(e2.checkLength(s), true);
      }
    });

    test('LO checkLength bad values', () {
      global.throwOnError = false;
      final vList2 = ['&t&wSB)~P', '02werw#%h'];
      final e3 = LOtag(PTag.kReceiveCoilManufacturerName, vList2);
      expect(e3, isNull);

      global.throwOnError = true;
      expect(() => LOtag(PTag.kReceiveCoilManufacturerName, vList2),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('LO checkValue good values', () {
      final vList0 = rsg.getLOList(1, 1);
      final e0 = LOtag(PTag.kReceiveCoilManufacturerName, vList0);
      for (var s in goodLOList) {
        for (var a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });

    test('LO checkValue bad values', () {
      final vList0 = rsg.getLOList(1, 1);
      final e0 = LOtag(PTag.kReceiveCoilManufacturerName, vList0);

      for (var s in badLOList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(e0.checkValue(a), false);

          global.throwOnError = true;
          expect(() => e0.checkValue(a),
              throwsA(const TypeMatcher<StringError>()));
        }
      }
    });

    test('LO append', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 4);
        final e0 = LOtag(PTag.kSelectorLOValue, vList0);
        const vList1 = 'foo';
        final append0 = e0.append(vList1);
        log.debug('append0: $append0');
        expect(append0, isNotNull);
      }
    });

    test('LO prepend', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 4);
        final e0 = LOtag(PTag.kSelectorLOValue, vList0);
        const vList1 = 'foo';
        final prepend0 = e0.prepend(vList1);
        log.debug('prepend0: $prepend0');
        expect(prepend0, isNotNull);
      }
    });

    test('LO truncate', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 4, 16);
        final e0 = LOtag(PTag.kSelectorLOValue, vList0);
        final truncate0 = e0.truncate(10);
        log.debug('truncate0: $truncate0');
        expect(truncate0, isNotNull);
      }
    });

    test('LO match', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 10);
        final e0 = LOtag(PTag.kSelectorLOValue, vList0);
        final match0 = e0.match(r'.*');
        expect(match0, true);
      }
    });

    test('LO valueFromBytes', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getLOList(1, i);
        final bytes = Bytes.utf8FromList(vList0);
        final e0 = LOtag(PTag.kSelectorLOValue, vList0);
        final vfb0 = e0.valuesFromBytes(bytes);
        expect(vfb0, equals(vList0));
      }
    });

    test('LO check', () {
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getLOList(1, 1);
        final e0 = LOtag(PTag.kCodeMeaning, vList);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList[0]));
      }

      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getLOList(1, i);
        final e0 = LOtag(PTag.kSelectorLOValue, vList1);
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);
        expect(e0[0], equals(vList1[0]));
      }
    });

    test('LO valuesEqual good values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getLOList(1, 1);
        final e0 = LOtag(PTag.kSelectorLOValue, vList);
        final e1 = LOtag(PTag.kSelectorLOValue, vList);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), true);
      }
    });

    test('LO valuesEqual bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getLOList(1, i);
        final vList1 = rsg.getLOList(1, 1);
        final e0 = LOtag(PTag.kSelectorLOValue, vList0);
        final e1 = LOtag(PTag.kSelectorLOValue, vList1);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), false);
      }
    });

    test('LO fromValueField', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        log.debug('vList0: $vList0');
        final fvf0 = AsciiString.fromValueField(vList0, k8BitMaxLongVF);
        expect(fvf0, equals(vList0));
      }

      for (var i = 1; i < 10; i++) {
        global.throwOnError = false;
        final vList1 = rsg.getLOList(1, i);
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
  });

  group('LO', () {
    const badLongString = 'fr<(Kf_dt&wSB)~P_hYZI`r[12Der)*sldfjelr#er@1!`, '
        '{qw{retyt}dddd123qw{retyt}dddd123';
    const badLOLengthList = <String>[
      //    '',
      'fr<(Kf_dt&wSB)~P_hYZI`r[12Der)*sldfjelr#er@1!`, {qw{retyt}dddd123',
      badLongString
    ];

    //VM.k1
    const loVM1Tags = <PTag>[
      PTag.kDataSetSubtype,
      PTag.kManufacturer,
      PTag.kInstitutionName,
      PTag.kExtendedCodeValue,
      PTag.kCodeMeaning,
      PTag.kPrivateCreatorReference,
      PTag.kPatientID,
      PTag.kIssuerOfPatientID,
      PTag.kBranchOfService,
      PTag.kPatientReligiousPreference,
      PTag.kSecondaryCaptureDeviceID,
      PTag.kHardcopyDeviceManufacturer,
      PTag.kApplicationVersion,
    ];

    //VM.k1_n
    const loVM1nTags = <PTag>[
      PTag.kAdmittingDiagnosesDescription,
      PTag.kEventTimerNames,
      PTag.kInsurancePlanIdentification,
      PTag.kMedicalAlerts,
      PTag.kDeidentificationMethod,
      PTag.kRadionuclide,
      PTag.kSecondaryCaptureDeviceSoftwareVersions,
      PTag.kSoftwareVersions,
      PTag.kTypeOfFilters,
      PTag.kTransducerData,
      PTag.kSelectorLOValue,
      PTag.kProductName,
      PTag.kOtherPatientIDs,
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

    final invalidVList = rsg.getLOList(LO.kMaxLength + 1, LO.kMaxLength + 1);

    test('LO isValidTag good values', () {
      global.throwOnError = false;
      expect(LO.isValidTag(PTag.kSelectorLOValue), true);

      for (var tag in loVM1Tags) {
        final validT0 = LO.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('LO isValidTag bad values', () {
      global.throwOnError = false;
      expect(LO.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => LO.isValidTag(PTag.kSelectorFDValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = LO.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => LO.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('LO isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(LO.isValidVRIndex(kLOIndex), true);

      for (var tag in loVM1Tags) {
        global.throwOnError = false;
        expect(LO.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('LO isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(LO.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => LO.isValidVRIndex(kCSIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(LO.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => LO.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('LO isValidVRCode good values', () {
      global.throwOnError = false;
      expect(LO.isValidVRCode(kLOCode), true);

      for (var tag in loVM1Tags) {
        expect(LO.isValidVRCode(tag.vrCode), true);
      }
    });

    test('LO isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(LO.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => LO.isValidVRCode(kAECode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(LO.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => LO.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('LO isValidVFLength good values', () {
      expect(LO.isValidVFLength(LO.kMaxVFLength), true);
      expect(LO.isValidVFLength(0), true);

      expect(LO.isValidVFLength(LO.kMaxVFLength, null, PTag.kSelectorLOValue),
          true);
    });

    test('LO isValidVFLength bad values', () {
      expect(LO.isValidVFLength(LO.kMaxVFLength + 1), false);
      expect(LO.isValidVFLength(-1), false);
    });

    test('LO isValidValueLength good values', () {
      for (var s in goodLOList) {
        for (var a in s) {
          expect(LO.isValidValueLength(a), true);
        }
      }
      expect(
          LO.isValidValueLength(
              '&t&wSB)~PIA!UIDX }d!zD2N3 2fz={@^mHL:/"qmczv9LzgGEH6bTY&N}J'),
          true);
      expect(LO.isValidValueLength('a'), true);
      expect(LO.isValidValueLength(''), true);
    });

    test('LO isValidValueLength bad values', () {
      global.throwOnError = false;
      for (var s in badLOLengthList) {
        expect(LO.isValidValueLength(s), false);
      }

      expect(
          LO.isValidValueLength('&t&wSB)~PIA!UIDX }d!zD2N3 2fz={@^mHL:/"qzD2N3 '
              '2fzLzgGEH6bTY&N}JzD2N3 2fz'),
          false);
    });

    test('LO isValidLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getLOList(1, 1);
        for (var tag in loVM1Tags) {
          expect(LO.isValidLength(tag, vList), true);

          expect(LO.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(LO.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('LO isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getLOList(2, i + 1);
        for (var tag in loVM1Tags) {
          global.throwOnError = false;
          expect(LO.isValidLength(tag, vList), false);

          expect(LO.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => LO.isValidLength(tag, vList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }

      global.throwOnError = false;
      final vList0 = rsg.getLOList(1, 1);
      expect(LO.isValidLength(null, vList0), false);

      expect(LO.isValidLength(PTag.kSelectorLOValue, null), isNull);

      global.throwOnError = true;
      expect(() => LO.isValidLength(null, vList0),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => LO.isValidLength(PTag.kSelectorLOValue, null),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('LO isValidVListLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getLOList(1, i);
        final validMaxLengthList = invalidVList.sublist(0, LO.kMaxLength);
        for (var tag in loVM1nTags) {
          log.debug('tag: $tag');
          expect(LO.isValidLength(tag, vList0), true);
          expect(LO.isValidLength(tag, validMaxLengthList), true);
        }
      }
    });

    test('LO isValidValue good values', () {
      for (var s in goodLOList) {
        for (var a in s) {
          expect(LO.isValidValue(a), true);
        }
      }
    });

    test('LO isValidValue bad values', () {
      for (var s in badLOList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(LO.isValidValue(a), false);

          global.throwOnError = true;
          expect(() => LO.isValidValue(a),
              throwsA(const TypeMatcher<StringError>()));
        }
      }
      expect(LO.isValidValue(null), false);
    });

    test('LO isValidValues good values', () {
      global.throwOnError = false;
      for (var s in goodLOList) {
        expect(LO.isValidValues(PTag.kDataSetSubtype, s), true);
      }
    });

    test('LO isValidValues bad values', () {
      for (var s in badLOList) {
        global.throwOnError = false;
        expect(LO.isValidValues(PTag.kDataSetSubtype, s), false);

        global.throwOnError = true;
        expect(() => LO.isValidValues(PTag.kDataSetSubtype, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('LO fromBytes', () {
//      system.level = Level.info;
      final vList1 = rsg.getLOList(1, 1);
      final bytes = Bytes.utf8FromList(vList1);
      log.debug('LO.fromBytes(bytes):  $bytes');
      expect(bytes.stringListFromUtf8(), equals(vList1));
    });

    test('LO toUint8List', () {
      final vList1 = rsg.getLOList(1, 1);
      log.debug('Bytes.fromUtf8List(vList1): ${Bytes.utf8FromList(vList1)}');

      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = ascii.encode(vList1[0]);
      expect(Bytes.utf8FromList(vList1), equals(values));
    });

    test('LO isValidValues good values', () {
      global.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList = rsg.getLOList(1, 1);
        expect(LO.isValidValues(PTag.kDataSetSubtype, vList), true);
      }

      final vList0 = ['5b9LE'];
      expect(LO.isValidValues(PTag.kDataSetSubtype, vList0), true);

      for (var s in goodLOList) {
        global.throwOnError = false;
        expect(LO.isValidValues(PTag.kDataSetSubtype, s), true);
      }
    });

    test('LO isValidValues bad values', () {
      global.throwOnError = false;
      final vList1 = ['B\\S'];
      expect(LO.isValidValues(PTag.kDataSetSubtype, vList1), false);

      global.throwOnError = true;
      expect(() => LO.isValidValues(PTag.kDataSetSubtype, vList1),
          throwsA(const TypeMatcher<StringError>()));

      for (var s in badLOList) {
        global.throwOnError = false;
        expect(LO.isValidValues(PTag.kDataSetSubtype, s), false);

        global.throwOnError = true;
        expect(() => LO.isValidValues(PTag.kDataSetSubtype, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('LO toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        global.throwOnError = false;
        final values = ascii.encode(vList0[0]);
        final tbd0 = Bytes.utf8FromList(vList0);
        final tbd1 = Bytes.utf8FromList(vList0);
        log.debug('bd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodLOList) {
        for (var a in s) {
          final values = ascii.encode(a);
          final tbd2 = Bytes.utf8FromList(s);
          final tbd3 = Bytes.utf8FromList(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('LO fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.utf8FromList(vList0);
        final fbd0 = bd0.stringListFromUtf8();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (var s in goodLOList) {
        final bd0 = Bytes.utf8FromList(s);
        final fbd0 = bd0.stringListFromUtf8();
        expect(fbd0, equals(s));
      }
    });

    test('LO toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.utf8FromList(vList0, kMaxShortVF);
        final bytes0 = Bytes.ascii(vList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodLOList) {
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

    test('LO fromValueField', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        final fvf0 = Utf8String.fromValueField(vList0, k8BitMaxLongVF);
        expect(fvf0, equals(vList0));
      }

      for (var i = 1; i < 10; i++) {
        global.throwOnError = false;
        final vList1 = rsg.getLOList(1, i);
        final fvf1 = Utf8String.fromValueField(vList1, k8BitMaxLongVF);
        expect(fvf1, equals(vList1));
      }
      final fvf1 = Utf8String.fromValueField(null, k8BitMaxLongLength);
      expect(fvf1, <String>[]);
      expect(fvf1 == kEmptyStringList, true);

      final fvf2 = Utf8String.fromValueField(<String>[], k8BitMaxLongLength);
      expect(fvf2, <String>[]);
      expect(fvf2 == kEmptyStringList, false);
      expect(fvf2.isEmpty, true);

      final fvf3 = Utf8String.fromValueField(<int>[1234], k8BitMaxLongLength);
      expect(fvf3, isNull);

      global.throwOnError = true;
      expect(() => Utf8String.fromValueField(<int>[1234], k8BitMaxLongLength),
          throwsA(const TypeMatcher<InvalidValuesError>()));

      global.throwOnError = false;
      final vList2 = rsg.getLOList(1, 1);
      final bytes = Bytes.utf8FromList(vList2);
      final fvf4 = Utf8String.fromValueField(bytes, k8BitMaxLongLength);
      expect(fvf4, equals(vList2));

      final vList3 = rng.uint8List(1, 1);
      final fvf5 = Utf8String.fromValueField(vList3, k8BitMaxLongLength);
      expect(fvf5, equals([ascii.decode(vList3)]));
    });

    test('LO isValidBytesArgs', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getLOList(1, i);
        final vfBytes = Bytes.utf8FromList(vList0);

        if (vList0.length == 1) {
          for (var tag in loVM1Tags) {
            final e0 = LO.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else {
          for (var tag in loVM1nTags) {
            final e0 = LO.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        }
      }
      final vList0 = rsg.getLOList(1, 1);
      final vfBytes = Bytes.utf8FromList(vList0);

      final e1 = LO.isValidBytesArgs(null, vfBytes);
      expect(e1, false);

      final e2 = LO.isValidBytesArgs(PTag.kDate, vfBytes);
      expect(e2, false);

      final e3 = LO.isValidBytesArgs(PTag.kSelectorLOValue, null);
      expect(e3, false);

      global.throwOnError = true;
      expect(() => LO.isValidBytesArgs(null, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => LO.isValidBytesArgs(PTag.kDate, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));
    });
  });
}
