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
  Server.initialize(name: 'string/lo_test', level: Level.info);
  global.throwOnError = false;

  const goodLOList = const <List<String>>[
    const <String>['5b9LE'],
    const <String>['_hYZI`r[,'],
    const <String>['560'],
    const <String>[' fr<(Kf_d=wS'],
    const <String>['&t&wSB)~P']
  ];
  const badLOList = const <List<String>>[
    const <String>['\b'], //	Backspace
    const <String>['\t '], //horizontal tab (HT)
    const <String>['\n'], //linefeed (LF)
    const <String>['\f '], // form feed (FF)
    const <String>['\r '], //carriage return (CR)
    const <String>['\v'], //vertical tab
    const <String>[r'\'],
    const <String>['B\\S'],
    const <String>['1\\9'],
    const <String>['a\\4'],
    const <String>[r'^`~\\?'],
    const <String>[r'^\?'],
  ];

  group('LO Tests', () {
    test('LO hasValidValues good values', () {
      for (var s in goodLOList) {
        global.throwOnError = false;
        final e0 = new LOtag(PTag.kReceiveCoilManufacturerName, s);
        expect(e0.hasValidValues, true);
      }

      global.throwOnError = false;
      final e0 = new LOtag(PTag.kReceiveCoilManufacturerName, []);
      expect(e0.hasValidValues, true);
      expect(e0.values, equals(<String>[]));
    });

    test('LO hasValidValues bad values', () {
      for (var s in badLOList) {
        global.throwOnError = false;
        final e0 = new LOtag(PTag.kReceiveCoilManufacturerName, s);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => new LOtag(PTag.kReceiveCoilManufacturerName, s),
            throwsA(const isInstanceOf<StringError>()));
      }

      global.throwOnError = false;
      final e1 = new LOtag(PTag.kReceiveCoilManufacturerName, null);
      log.debug('e1: $e1');
      expect(e1, isNull);

      global.throwOnError = true;
      expect(() => new LOtag(PTag.kReceiveCoilManufacturerName, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('LO hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        final e0 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);
        log.debug('e0:${e0.info}');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: ${e0.info}');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 10);
        final e1 = new LOtag(PTag.kReference, vList0);
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
        final e2 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);
        expect(e2, isNull);

        global.throwOnError = true;
        expect(() => new LOtag(PTag.kReceiveCoilManufacturerName, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('LO update random', () {
      final e0 = new LOtag(PTag.kReference, []);
      expect(e0.update(['DN{~44F, 1H}B#86, _3YX80jD2;.>4c']).values,
          equals(['DN{~44F, 1H}B#86, _3YX80jD2;.>4c']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(3, 4);
        final e1 = new LOtag(PTag.kReference, vList0);
        final vList1 = rsg.getLOList(3, 4);
        expect(e1.update(vList1).values, equals(vList1));
      }
    });

    test('LO noValues random', () {
      final e0 = new LOtag(PTag.kReference, []);
      final LOtag loNoValues = e0.noValues;
      expect(loNoValues.values.isEmpty, true);
      log.debug('as0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(3, 4);
        final e0 = new LOtag(PTag.kReference, vList0);
        log.debug('e0: $e0');
        expect(loNoValues.values.isEmpty, true);
        log.debug('as0: ${e0.noValues}');
      }
    });

    test('LO copy random', () {
      final e0 = new LOtag(PTag.kReference, []);
      final LOtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(3, 4);
        final e2 = new LOtag(PTag.kReference, vList0);
        final LOtag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('LO hashCode and == good values random', () {
      List<String> vList0;
      for (var i = 0; i < 10; i++) {
        vList0 = rsg.getLOList(1, 1);
        final e0 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);
        final e1 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);
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
        final e0 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);

        final vList1 = rsg.getLOList(1, 1);
        final e2 = new LOtag(PTag.kPositionReferenceIndicator, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rsg.getLOList(1, 10);
        final e3 = new LOtag(PTag.kReference, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);

        final vList3 = rsg.getLOList(2, 3);
        final e4 = new LOtag(PTag.kReceiveCoilManufacturerName, vList3);
        log.debug('vList3:$vList3 , e4.hash_code:${e4.hashCode}');
        expect(e0.hashCode == e4.hashCode, false);
        expect(e0 == e4, false);
      }
    });

    test('LO valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        final e0 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('LO isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        final e0 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);
        expect(e0.tag.isValidLength(e0), true);
      }
    });

    test('LO isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        final e0 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);
        expect(e0.checkValues(e0.values), true);
        expect(e0.hasValidValues, true);
      }
    });

    test('LO replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        final e0 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);
        final vList1 = rsg.getLOList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getLOList(1, 1);
      final e1 = new LOtag(PTag.kReceiveCoilManufacturerName, vList1);
      expect(e1.replace([]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = new LOtag(PTag.kReceiveCoilManufacturerName, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e1.values, equals(<String>[]));
    });

    test('LO blank random', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getLOList(1, 1);
        final e0 = new LOtag(PTag.kReceiveCoilManufacturerName, vList1);
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

    test('LO fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getLOList(1, 1);
        final bytes = Bytes.fromUtf8List(vList1);
        log.debug('bytes:$bytes');
        final e0 = LOtag.fromBytes(bytes, PTag.kReceiveCoilManufacturerName);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);
      }
    });

    test('LO fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getLOList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          //final bytes0 = new Bytes();
          final e1 = LOtag.fromBytes(bytes0, PTag.kSelectorLOValue);
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
          final bytes0 = Bytes.fromAscii(listS);
          //final bytes0 = new Bytes();
          final e1 = LOtag.fromBytes(bytes0, PTag.kSelectorCSValue);
          expect(e1, isNull);

          global.throwOnError = true;
          expect(() => LOtag.fromBytes(bytes0, PTag.kSelectorCSValue),
              throwsA(const isInstanceOf<InvalidTagError>()));
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
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final e1 =
          LOtag.fromValues(PTag.kReceiveCoilManufacturerName, <String>[null]);
      log.debug('mak1: $e1');
      expect(e1, isNull);

      global.throwOnError = true;
      expect(
          () => LOtag
              .fromValues(PTag.kReceiveCoilManufacturerName, <String>[null]),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('LO checkLength good values', () {
      final vList0 = rsg.getLOList(1, 1);
      final e0 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);
      for (var s in goodLOList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);
      expect(e1.checkLength([]), true);

      final vList1 = rsg.getLOList(1, 10);
      final e2 = new LOtag(PTag.kReference, vList1);
      for (var s in goodLOList) {
        expect(e2.checkLength(s), true);
      }
    });

    test('LO checkLength bad values', () {
      global.throwOnError = false;
      final vList2 = ['&t&wSB)~P', '02werw#%h'];
      final e3 = new LOtag(PTag.kReceiveCoilManufacturerName, vList2);
      expect(e3, isNull);

      global.throwOnError = true;
      expect(() => new LOtag(PTag.kReceiveCoilManufacturerName, vList2),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('LO checkValue good values', () {
      final vList0 = rsg.getLOList(1, 1);
      final e0 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);
      for (var s in goodLOList) {
        for (var a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });

    test('LO checkValue bad values', () {
      final vList0 = rsg.getLOList(1, 1);
      final e0 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);

      for (var s in badLOList) {
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

  group('LO', () {
    const badLongString = 'fr<(Kf_dt&wSB)~P_hYZI`r[12Der)*sldfjelr#er@1!`, '
        '{qw{retyt}dddd123qw{retyt}dddd123';
    const badLOLengthList = const <String>[
      //    '',
      'fr<(Kf_dt&wSB)~P_hYZI`r[12Der)*sldfjelr#er@1!`, {qw{retyt}dddd123',
      badLongString
    ];

    //VM.k1
    const loVM1Tags = const <PTag>[
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
    const loVM1_nTags = const <PTag>[
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
          throwsA(const isInstanceOf<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = LO.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => LO.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });

    /*test('LO checkVRIndex good values', () {
      global.throwOnError = false;
      expect(LO.checkVRIndex(kLOIndex), kLOIndex);

      for (var tag in loTags0) {
        global.throwOnError = false;
        expect(LO.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('LO checkVRIndex bad values', () {
      global.throwOnError = false;
      expect(
          LO.checkVRIndex(
            kAEIndex,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => LO.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(LO.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => LO.checkVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('LO checkVRCode good values', () {
      global.throwOnError = false;
      expect(LO.checkVRCode(kLOCode), kLOCode);

      for (var tag in loTags0) {
        global.throwOnError = false;
        expect(LO.checkVRCode(tag.vrCode), tag.vrCode);
      }
    });

    test('LO checkVRCode bad values', () {
      global.throwOnError = false;
      expect(
          LO.checkVRCode(
            kAECode,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => LO.checkVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(LO.checkVRCode(tag.vrCode), isNull);

        global.throwOnError = true;
        expect(() => LO.checkVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });*/

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
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(LO.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => LO.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
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
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(LO.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => LO.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('LO isValidVFLength good values', () {
      expect(LO.isValidVFLength(LO.kMaxVFLength), true);
      expect(LO.isValidVFLength(0), true);
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
      expect(LO.isValidValueLength(''), true);
    });

    test('LO isValidVListLength VM.k1 good values', () {
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

    test('LO isValidVListLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getLOList(2, i + 1);
        for (var tag in loVM1Tags) {
          global.throwOnError = false;
          expect(LO.isValidLength(tag, vList), false);

          expect(LO.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => LO.isValidLength(tag, vList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('LO isValidVListLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getLOList(1, i);
        final validMaxLengthList = invalidVList.sublist(0, LO.kMaxLength);
        for (var tag in loVM1_nTags) {
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
              throwsA(const isInstanceOf<StringError>()));
        }
      }
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
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('LO fromBytes', () {
//      system.level = Level.info;
      final vList1 = rsg.getLOList(1, 1);
      final bytes = Bytes.fromUtf8List(vList1);
      log.debug('LO.fromBytes(bytes):  $bytes');
      expect(bytes.getUtf8List(), equals(vList1));
    });

    test('LO toUint8List', () {
      final vList1 = rsg.getLOList(1, 1);
      log.debug('Bytes.fromUtf8List(vList1): ${Bytes.fromUtf8List(vList1)}');

      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = cvt.ascii.encode(vList1[0]);
      expect(Bytes.fromUtf8List(vList1), equals(values));
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
          throwsA(const isInstanceOf<StringError>()));

      for (var s in badLOList) {
        global.throwOnError = false;
        expect(LO.isValidValues(PTag.kDataSetSubtype, s), false);

        global.throwOnError = true;
        expect(() => LO.isValidValues(PTag.kDataSetSubtype, s),
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('LO toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        global.throwOnError = false;
        final values = cvt.ascii.encode(vList0[0]);
        final tbd0 = Bytes.fromUtf8List(vList0);
        final tbd1 = Bytes.fromUtf8List(vList0);
        log.debug('bd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodLOList) {
        for (var a in s) {
          final values = cvt.ascii.encode(a);
          final tbd2 = Bytes.fromUtf8List(s);
          final tbd3 = Bytes.fromUtf8List(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('LO fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.fromUtf8List(vList0);
        final fbd0 = bd0.getUtf8List();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (var s in goodLOList) {
        final bd0 = Bytes.fromUtf8List(s);
        final fbd0 = bd0.getUtf8List();
        expect(fbd0, equals(s));
      }
    });

    test('LO toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.fromUtf8List(vList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(vList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodLOList) {
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