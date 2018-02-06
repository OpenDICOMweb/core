// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

import 'dart:convert';

import 'package:core/server.dart';
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = new RSG(seed: 1);

void main() {
  Server.initialize(name: 'string/string_test', level: Level.info0);
  system.throwOnError = false;

  group('LO Tests', () {
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

    test('LO hasValidValues good values', () {
      for (var s in goodLOList) {
        system.throwOnError = false;
        final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, s);
        expect(lo0.hasValidValues, true);
      }

      system.throwOnError = false;
      final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, []);
      expect(lo0.hasValidValues, true);
      expect(lo0.values, equals(<String>[]));
    });

    test('LO hasValidValues bad values', () {
      for (var s in badLOList) {
        system.throwOnError = false;
        final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, s);
        expect(lo0, isNull);

        system.throwOnError = true;
        expect(() => new LOtag(PTag.kReceiveCoilManufacturerName, s),
            throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
      }

      system.throwOnError = false;
      final lo1 = new LOtag(PTag.kReceiveCoilManufacturerName, null);
      log.debug('lo1: $lo1');
      expect(lo1, isNull);

      system.throwOnError = true;
      expect(() => new LOtag(PTag.kReceiveCoilManufacturerName, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('LO hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);
        log.debug('lo0:${lo0.info}');
        expect(lo0.hasValidValues, true);

        log
          ..debug('lo0: $lo0, values: ${lo0.values}')
          ..debug('lo0: ${lo0.info}');
        expect(lo0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 10);
        final lo1 = new LOtag(PTag.kReference, vList0);
        log.debug('lo1:${lo1.info}');
        expect(lo1.hasValidValues, true);

        log
          ..debug('lo1: $lo1, values: ${lo1.values}')
          ..debug('lo1: ${lo1.info}');
        expect(lo1[0], equals(vList0[0]));
      }
    });

    test('LO hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final vList0 = rsg.getLOList(3, 4);
        log.debug('$i: vList0: $vList0');
        final lo2 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);
        expect(lo2, isNull);

        system.throwOnError = true;
        expect(() => new LOtag(PTag.kReceiveCoilManufacturerName, vList0),
            throwsA(const isInstanceOf<InvalidValuesLengthError>()));
      }
    });

    test('LO update random', () {
      final lo0 = new LOtag(PTag.kReference, []);
      expect(lo0.update(['DN{~44F, 1H}B#86, _3YX80jD2;.>4c']).values,
          equals(['DN{~44F, 1H}B#86, _3YX80jD2;.>4c']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(3, 4);
        final lo1 = new LOtag(PTag.kReference, vList0);
        final vList1 = rsg.getLOList(3, 4);
        expect(lo1.update(vList1).values, equals(vList1));
      }
    });

    test('LO noValues random', () {
      final lo0 = new LOtag(PTag.kReference, []);
      final LOtag loNoValues = lo0.noValues;
      expect(loNoValues.values.isEmpty, true);
      log.debug('as0: ${lo0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(3, 4);
        final lo0 = new LOtag(PTag.kReference, vList0);
        log.debug('lo0: $lo0');
        expect(loNoValues.values.isEmpty, true);
        log.debug('as0: ${lo0.noValues}');
      }
    });

    test('LO copy random', () {
      final lo0 = new LOtag(PTag.kReference, []);
      final LOtag lo1 = lo0.copy;
      expect(lo1 == lo0, true);
      expect(lo1.hashCode == lo0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(3, 4);
        final lo2 = new LOtag(PTag.kReference, vList0);
        final LOtag lo3 = lo2.copy;
        expect(lo3 == lo2, true);
        expect(lo3.hashCode == lo2.hashCode, true);
      }
    });

    test('LO hashCode and == good values random', () {
      List<String> stringList0;
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getLOList(1, 1);
        final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, stringList0);
        final lo1 = new LOtag(PTag.kReceiveCoilManufacturerName, stringList0);
        log
          ..debug('stringList0:$stringList0, lo0.hash_code:${lo0.hashCode}')
          ..debug('stringList0:$stringList0, lo1.hash_code:${lo1.hashCode}');
        expect(lo0.hashCode == lo1.hashCode, true);
        expect(lo0 == lo1, true);
      }
    });

    test('LO hashCode and == bad values random', () {
      system.throwOnError = false;
      List<String> stringList0;
      List<String> stringList1;
      List<String> stringList2;
      List<String> stringList3;

      log.debug('LO hashCode and == ');
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getLOList(1, 1);
        final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, stringList0);

        stringList1 = rsg.getLOList(1, 1);
        final lo2 = new LOtag(PTag.kPositionReferenceIndicator, stringList1);
        log.debug('stringList1:$stringList1 , lo2.hash_code:${lo2.hashCode}');
        expect(lo0.hashCode == lo2.hashCode, false);
        expect(lo0 == lo2, false);

        stringList2 = rsg.getLOList(1, 10);
        final lo3 = new LOtag(PTag.kReference, stringList2);
        log.debug('stringList2:$stringList2 , lo3.hash_code:${lo3.hashCode}');
        expect(lo0.hashCode == lo3.hashCode, false);
        expect(lo0 == lo3, false);

        stringList3 = rsg.getLOList(2, 3);
        final lo4 = new LOtag(PTag.kReceiveCoilManufacturerName, stringList3);
        log.debug('stringList3:$stringList3 , lo4.hash_code:${lo4.hashCode}');
        expect(lo0.hashCode == lo4.hashCode, false);
        expect(lo0 == lo4, false);
      }
    });

    test('LO valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);
        expect(vList0, equals(lo0.valuesCopy));
      }
    });

    test('LO isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);
        expect(lo0.tag.isValidLength(lo0.length), true);
      }
    });

    test('LO isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);
        expect(lo0.tag.isValidValues(lo0.values), true);
        expect(lo0.hasValidValues, true);
      }
    });

    test('LO replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);
        final vList1 = rsg.getLOList(1, 1);
        expect(lo0.replace(vList1), equals(vList0));
        expect(lo0.values, equals(vList1));
      }

      final vList1 = rsg.getLOList(1, 1);
      final lo1 = new LOtag(PTag.kReceiveCoilManufacturerName, vList1);
      expect(lo1.replace([]), equals(vList1));
      expect(lo1.values, equals(<String>[]));

      final lo2 = new LOtag(PTag.kReceiveCoilManufacturerName, vList1);
      expect(lo2.replace(null), equals(vList1));
      expect(lo1.values, equals(<String>[]));
    });

    test('LO blank random', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getLOList(1, 1);
        final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, vList1);
        for (var i = 1; i < 10; i++) {
          final blank = lo0.blank(i);
          log.debug(('blank$i: ${blank.values}'));
          expect(blank.values.length == 1, true);
          expect(blank.value.length == i, true);
          final strSpaceList = <String>[''.padRight(i, ' ')];
          log.debug('strSpaceList: $strSpaceList');
          expect(blank.values, equals(strSpaceList));
        }
      }
    });

    test('LO formBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getLOList(1, 1);
        final bytes = LO.toBytes(vList1);
        log.debug('bytes:$bytes');
        final lo0 =
            new LOtag.fromBytes(PTag.kReceiveCoilManufacturerName, bytes);
        log.debug('lo0: ${lo0.info}');
        expect(lo0.hasValidValues, true);
      }
    });

    test('LO checkLength good values', () {
      final vList0 = rsg.getLOList(1, 1);
      final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);
      for (var s in goodLOList) {
        expect(lo0.checkLength(s), true);
      }
      final lo1 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);
      expect(lo1.checkLength([]), true);

      final vList1 = rsg.getLOList(1, 10);
      final lo2 = new LOtag(PTag.kReference, vList1);
      for (var s in goodLOList) {
        expect(lo2.checkLength(s), true);
      }
    });

    test('LO checkLength bad values', () {
      system.throwOnError = false;
      final vList2 = ['&t&wSB)~P', '02werw#%h'];
      final lo3 = new LOtag(PTag.kReceiveCoilManufacturerName, vList2);
      expect(lo3, isNull);

      system.throwOnError = true;
      expect(() => new LOtag(PTag.kReceiveCoilManufacturerName, vList2),
          throwsA(const isInstanceOf<InvalidValuesLengthError>()));
    });

    test('LO checkValue good values', () {
      final vList0 = rsg.getLOList(1, 1);
      final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);
      for (var s in goodLOList) {
        for (var a in s) {
          expect(lo0.checkValue(a), true);
        }
      }
    });

    test('LO checkValue bad values', () {
      final vList0 = rsg.getLOList(1, 1);
      final lo0 = new LOtag(PTag.kReceiveCoilManufacturerName, vList0);

      for (var s in badLOList) {
        for (var a in s) {
          system.throwOnError = false;
          expect(lo0.checkValue(a), false);

          system.throwOnError = true;
          expect(() => lo0.checkValue(a),
              throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
        }
      }
    });
  });

  group('LO', () {
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

    const badLOLengthList = const <String>[
      '',
      'fr<(Kf_dt&wSB)~P_hYZI`r[12Der)*sldfjelr#er@1!`, {qw{retyt}dddd123'
    ];

    //VM.k1
    const loTags0 = const <PTag>[
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
    const loTags1 = const <PTag>[
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

    test('LO checkVR good values', () {
      system.throwOnError = false;
      expect(LO.checkVRIndex(kLOIndex), kLOIndex);

      for (var tag in loTags0) {
        system.throwOnError = false;
        expect(LO.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('LO checkVR bad values', () {
      system.throwOnError = false;
      expect(
          LO.checkVRIndex(
            kAEIndex,
          ),
          isNull);
      system.throwOnError = true;
      expect(() => LO.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(LO.checkVRIndex(tag.vrIndex), isNull);

        system.throwOnError = true;
        expect(() => LO.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('LO isValidVRIndex good values', () {
      system.throwOnError = false;
      expect(LO.isValidVRIndex(kLOIndex), true);

      for (var tag in loTags0) {
        system.throwOnError = false;
        expect(LO.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('LO isValidVRIndex bad values', () {
      system.throwOnError = false;
      expect(LO.isValidVRIndex(kCSIndex), false);

      system.throwOnError = true;
      expect(() => LO.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(LO.isValidVRIndex(tag.vrIndex), false);

        system.throwOnError = true;
        expect(() => LO.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('LO isValidVRCode good values', () {
      system.throwOnError = false;
      expect(LO.isValidVRCode(kLOCode), true);

      for (var tag in loTags0) {
        expect(LO.isValidVRCode(tag.vrCode), true);
      }
    });

    test('LO isValidVRCode bad values', () {
      system.throwOnError = false;
      expect(LO.isValidVRCode(kAECode), false);

      system.throwOnError = true;
      expect(() => LO.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(LO.isValidVRCode(tag.vrCode), false);

        system.throwOnError = true;
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

    test('LO isNotValidVFLength good values', () {
      expect(LO.isNotValidVFLength(LO.kMaxVFLength), false);
      expect(LO.isNotValidVFLength(0), false);
    });

    test('LO isNotValidVFLength bad values', () {
      expect(LO.isNotValidVFLength(LO.kMaxVFLength + 1), true);
      expect(LO.isNotValidVFLength(-1), true);
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
      for (var s in badLOLengthList) {
        expect(LO.isValidValueLength(s), false);
      }

      expect(
          LO.isValidValueLength(
              '&t&wSB)~PIA!UIDX }d!zD2N3 2fz={@^mHL:/"qzD2N3 2fzLzgGEH6bTY&N}JzD2N3 2fz'),
          false);
      expect(LO.isValidValueLength(''), false);
    });

    test('LO isNotValidValueLength good values', () {
      for (var s in goodLOList) {
        for (var a in s) {
          expect(LO.isNotValidValueLength(a), false);
        }
      }
    });

    test('LO isNotValidValueLength bad values', () {
      for (var s in badLOLengthList) {
        expect(LO.isNotValidValueLength(s), true);
      }

      expect(
          LO.isNotValidValueLength(
              '&t&wSB)~PIA!UIDX }d!zD2N3 2fz={@^mHL:/"qmczv9LzgGEH6bTY&N}J'),
          false);
    });

    test('LO isValidVListLength VM.k1 good values', () {
      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getLOList(1, 1);
        for (var tag in loTags0) {
          expect(LO.isValidVListLength(tag, validMinVList), true);

          expect(
              LO.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              LO.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('LO isValidVListLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rsg.getLOList(2, i + 1);
        for (var tag in loTags0) {
          system.throwOnError = false;
          expect(LO.isValidVListLength(tag, validMinVList), false);

          expect(LO.isValidVListLength(tag, invalidVList), false);

          system.throwOnError = true;
          expect(() => LO.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesLengthError>()));
        }
      }
    });

    test('LO isValidVListLength VM.k1_n good values', () {
      system.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final validMinVList0 = rsg.getLOList(1, i);
        final validMaxLengthList = invalidVList.sublist(0, LO.kMaxLength);
        for (var tag in loTags1) {
          log.debug('tag: $tag');
          expect(LO.isValidVListLength(tag, validMinVList0), true);
          expect(LO.isValidVListLength(tag, validMaxLengthList), true);
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
          system.throwOnError = false;
          expect(LO.isValidValue(a), false);

          system.throwOnError = true;
          expect(() => LO.isValidValue(a),
              throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
        }
      }
    });

    test('LO isValidValues good values', () {
      system.throwOnError = false;
      for (var s in goodLOList) {
        expect(LO.isValidValues(PTag.kDataSetSubtype, s), true);
      }
    });

    test('LO isValidValues bad values', () {
      for (var s in badLOList) {
        system.throwOnError = false;
        expect(LO.isValidValues(PTag.kDataSetSubtype, s), false);

        system.throwOnError = true;
        expect(() => LO.isValidValues(PTag.kDataSetSubtype, s),
            throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
      }
    });

    test('LO fromBytes', () {
//      system.level = Level.debug;
      final vList1 = rsg.getLOList(1, 1);
      final bytes = LO.toBytes(vList1);
      log.debug('LO.fromBytes(bytes): ${LO.fromBytes(bytes)}, bytes: $bytes');
      expect(LO.fromBytes(bytes), equals(vList1));
    });

    test('LO toBytes', () {
      final vList1 = rsg.getLOList(1, 1);
      log.debug('LO.toBytes(vList1): ${LO.toBytes(vList1)}');

      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = ASCII.encode(vList1[0]);
      expect(LO.toBytes(vList1), equals(values));
    });

/*
    test('LO fromBase64', () {
      system.throwOnError = false;
      final vList1 = rsg.getLOList(1, 1);

      final v0 = LO.fromBase64(vList1);
      expect(v0, isNotNull);

      final v1 = LO.fromBase64(['PIA5']);
      expect(v1, isNotNull);

      final v2 = LO.fromBase64(['PIA']);
      expect(v2, isNotNull);
    });

    test('LO toBase64', () {
      //final s = BASE64.encode(testFrame);
      final vList0 = rsg.getLOList(1, 1);
      expect(LO.toBase64(vList0), equals(vList0));

      final vList1 = ['dslkj'];
      //final s0 = ASCII.encode(vList0[0]);
      expect(LO.toBase64(vList1), equals(vList1));
    });
*/

    test('LO checkList good values', () {
      system.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList = rsg.getLOList(1, 1);
        expect(LO.checkList(PTag.kDataSetSubtype, vList), vList);
      }

      final vList0 = ['5b9LE'];
      expect(LO.checkList(PTag.kDataSetSubtype, vList0), vList0);

      for (var s in goodLOList) {
        system.throwOnError = false;
        expect(LO.checkList(PTag.kDataSetSubtype, s), s);
      }
    });

    test('LO checkList bad values', () {
      system.throwOnError = false;
      final vList1 = ['B\\S'];
      expect(LO.checkList(PTag.kDataSetSubtype, vList1), isNull);

      system.throwOnError = true;
      expect(() => LO.checkList(PTag.kDataSetSubtype, vList1),
          throwsA(const isInstanceOf<InvalidCharacterInStringError>()));

      for (var s in badLOList) {
        system.throwOnError = false;
        expect(LO.checkList(PTag.kDataSetSubtype, s), isNull);

        system.throwOnError = true;
        expect(() => LO.checkList(PTag.kDataSetSubtype, s),
            throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
      }
    });
  });

  group('LTtag', () {
    const goodLTList = const <List<String>>[
      const <String>['\t '], //horizontal tab (HT)
      const <String>['\n'], //linefeed (LF)
      const <String>['\f '], // form feed (FF)
      const <String>['\r '], //carriage return (CR)
      const <String>['!mSMXWVy`]/Du'],
      const <String>['`0Y^~x?+]Q91']
    ];
    const badLTList = const <List<String>>[
      const <String>['\b'], //	Backspace
    ];
    test('LT hasValidValues good values', () {
      for (var s in goodLTList) {
        system.throwOnError = false;
        final lt0 = new LTtag(PTag.kAcquisitionProtocolDescription, s);
        expect(lt0.hasValidValues, true);
      }
      system.throwOnError = false;
      final lt0 = new LTtag(PTag.kImageComments, []);
      expect(lt0.hasValidValues, true);
      expect(lt0.values, equals(<String>[]));
    });

    test('LT hasValidValues bad values', () {
      for (var s in badLTList) {
        system.throwOnError = false;
        final lt0 = new LTtag(PTag.kAcquisitionProtocolDescription, s);
        expect(lt0, isNull);

        system.throwOnError = true;
        expect(() => new LTtag(PTag.kAcquisitionProtocolDescription, s),
            throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
      }
    });

    test('LT hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final lt0 = new LTtag(PTag.kAcquisitionProtocolDescription, vList0);
        log.debug('lt0:${lt0.info}');
        expect(lt0.hasValidValues, true);

        log
          ..debug('lt0: $lt0, values: ${lt0.values}')
          ..debug('lt0: ${lt0.info}');
        expect(lt0[0], equals(vList0[0]));
      }
    });

    test('LT hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final vList0 = rsg.getLTList(3, 4);
        log.debug('$i: vList0: $vList0');
        final lt1 = new LTtag(PTag.kAcquisitionProtocolDescription, vList0);
        expect(lt1, isNull);

        system.throwOnError = true;
        expect(() => new LTtag(PTag.kAcquisitionProtocolDescription, vList0),
            throwsA(const isInstanceOf<InvalidValuesLength>()));
      }

      system.throwOnError = false;
      final lt1 = new LTtag(PTag.kImageComments, null);
      log.debug('lt1: $lt1');
      expect(lt1, isNull);

      system.throwOnError = true;
      expect(() => new LTtag(PTag.kAcquisitionProtocolDescription, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('LT update random', () {
      final lt = new LTtag(PTag.kImageComments, []);
      expect(lt.update(['Nm, Bhb/q0Sm']).values, equals(['Nm, Bhb/q0Sm']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final lt1 = new LTtag(PTag.kImageComments, vList0);
        final vList1 = rsg.getLTList(1, 1);
        expect(lt1.update(vList1).values, equals(vList1));
      }
    });

    test('LT noValues random', () {
      final lt0 = new LTtag(PTag.kImageComments, []);
      final LTtag ltNoValues = lt0.noValues;
      expect(ltNoValues.values.isEmpty, true);
      log.debug('as0: ${lt0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final lt0 = new LTtag(PTag.kImageComments, vList0);
        log.debug('lt0: $lt0');
        expect(ltNoValues.values.isEmpty, true);
        log.debug('as0: ${lt0.noValues}');
      }
    });

    test('LT copy random', () {
      final lt0 = new LTtag(PTag.kImageComments, []);
      final LTtag lt1 = lt0.copy;
      expect(lt1 == lt0, true);
      expect(lt1.hashCode == lt0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final lt2 = new LTtag(PTag.kImageComments, vList0);
        final LTtag lt3 = lt2.copy;
        expect(lt3 == lt2, true);
        expect(lt3.hashCode == lt2.hashCode, true);
      }
    });

    test('LT hashCode and == good values random', () {
      List<String> stringList0;
      log.debug('LT hashCode and == ');
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getLTList(1, 1);
        final lt0 = new LTtag(PTag.kImageComments, stringList0);
        final lt1 = new LTtag(PTag.kImageComments, stringList0);
        log
          ..debug('stringList0:$stringList0, lt0.hash_code:${lt0.hashCode}')
          ..debug('stringList0:$stringList0, lt1.hash_code:${lt1.hashCode}');
        expect(lt0.hashCode == lt1.hashCode, true);
        expect(lt0 == lt1, true);
      }
    });

    test('LT hashCode and == bad values random', () {
      system.throwOnError = false;
      List<String> stringList0;
      List<String> stringList1;
      List<String> stringList2;

      log.debug('LT hashCode and == ');
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getLTList(1, 1);
        final lt0 = new LTtag(PTag.kImageComments, stringList0);
        stringList1 = rsg.getLTList(1, 1);
        final lt2 = new LTtag(PTag.kFrameComments, stringList1);
        log.debug('stringList1:$stringList1 , lt2.hash_code:${lt2.hashCode}');
        expect(lt0.hashCode == lt2.hashCode, false);
        expect(lt0 == lt2, false);

        stringList2 = rsg.getLOList(2, 3);
        final lt3 = new LTtag(PTag.kImageComments, stringList2);
        log.debug('stringList2:$stringList2 , lt3.hash_code:${lt3.hashCode}');
        expect(lt0.hashCode == lt3.hashCode, false);
        expect(lt0 == lt3, false);
      }
    });

    test('LT valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final lt0 = new LTtag(PTag.kImageComments, vList0);
        expect(vList0, equals(lt0.valuesCopy));
      }
    });

    test('LT isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final lt0 = new LTtag(PTag.kImageComments, vList0);
        expect(lt0.tag.isValidLength(lt0.length), true);
      }
    });

    test('LT isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final lt0 = new LTtag(PTag.kImageComments, vList0);
        expect(lt0.tag.isValidValues(lt0.values), true);
        expect(lt0.hasValidValues, true);
      }
    });

    test('LT replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final lt0 = new LTtag(PTag.kImageComments, vList0);
        final vList1 = rsg.getLTList(1, 1);
        expect(lt0.replace(vList1), equals(vList0));
        expect(lt0.values, equals(vList1));
      }

      final vList1 = rsg.getLTList(1, 1);
      final lt1 = new LTtag(PTag.kImageComments, vList1);
      expect(lt1.replace([]), equals(vList1));
      expect(lt1.values, equals(<String>[]));

      final lt2 = new LTtag(PTag.kImageComments, vList1);
      expect(lt2.replace(null), equals(vList1));
      expect(lt2.values, equals(<String>[]));
    });

    test('LT blank random', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getLTList(1, 1);
        final lt0 = new LTtag(PTag.kImageComments, vList1);
        for (var i = 1; i < 10; i++) {
          final blank = lt0.blank(i);
          log.debug(('blank$i: ${blank.values}'));
          expect(blank.values.length == 1, true);
          expect(blank.value.length == i, true);
          final strSpaceList = <String>[''.padRight(i, ' ')];
          log.debug('strSpaceList: $strSpaceList');
          expect(blank.values, equals(strSpaceList));
        }
      }
    });

    test('LT formBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getLTList(1, 1);
        log.debug('vList1:$vList1');
        final bytes = LT.toBytes(vList1);
        log.debug('bytes:$bytes');
        final lt0 = new LTtag.fromBytes(PTag.kImageComments, bytes);
        log.debug('lt0: ${lt0.info}');
        expect(lt0.hasValidValues, true);
      }
    });

    test('LT checkLength good values', () {
      final vList0 = rsg.getLTList(1, 1);
      final lt0 = new LTtag(PTag.kImageComments, vList0);
      for (var s in goodLTList) {
        expect(lt0.checkLength(s), true);
      }
      final lt1 = new LTtag(PTag.kImageComments, vList0);
      expect(lt1.checkLength([]), true);

      final vList1 = rsg.getLTList(1, 1);
      log.debug('vList1: $vList1');
      final lt2 = new LTtag(PTag.kExtendedCodeMeaning, vList1);

      for (var s in goodLTList) {
        log.debug('s: "$s"');
        expect(lt2.checkLength(s), true);
      }
    });

    test('LT checkLength bad values', () {
      system.throwOnError = false;
      final vList2 = ['\b', '024Y'];
      final lt3 = new LTtag(PTag.kImageComments, vList2);
      expect(lt3, isNull);
    });

    test('LT checkValue good values', () {
      final vList0 = rsg.getLTList(1, 1);
      final lt0 = new LTtag(PTag.kImageComments, vList0);
      for (var s in goodLTList) {
        for (var a in s) {
          expect(lt0.checkValue(a), true);
        }
      }
    });

    test('LT checkValue bad values', () {
      final vList0 = rsg.getLTList(1, 1);
      final lt0 = new LTtag(PTag.kImageComments, vList0);
      for (var s in badLTList) {
        for (var a in s) {
          system.throwOnError = false;
          expect(lt0.checkValue(a), false);

          system.throwOnError = true;
          expect(() => lt0.checkValue(a),
              throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
        }
      }
    });
  });

  group('LT', () {
    const goodLTList = const <List<String>>[
      const <String>['\t '], //horizontal tab (HT)
      const <String>['\n'], //linefeed (LF)
      const <String>['\f '], // form feed (FF)
      const <String>['\r '], //carriage return (CR)
      const <String>['!mSMXWVy`]/Du'],
      const <String>['`0Y^~x?+]Q91']
    ];
    const badLTList = const <List<String>>[
      const <String>['\b'], //	Backspace
    ];

    //VM.k1
    const ltTags0 = const <PTag>[
      PTag.kIdentifyingComments,
      PTag.kAdditionalPatientHistory,
      PTag.kPatientComments,
      PTag.kMaterialNotes,
      PTag.kCalibrationNotes,
      PTag.kPulserNotes,
      PTag.kReceiverNotes,
      PTag.kPreAmplifierNotes,
      PTag.kProbeDriveNotes,
      PTag.kAcquisitionComments,
      PTag.kDetectorMode,
      PTag.kGridAbsorbingMaterial,
      PTag.kExposureControlModeDescription,
      PTag.kRequestedProcedureComments,
      PTag.kMediaDisposition,
      PTag.kBarcodeValue,
      PTag.kCompensatorDescription,
      PTag.kArbitrary,
      PTag.kTextComments
    ];

    const otherTags = const <PTag>[
      PTag.kColumnAngulationPatient,
      PTag.kInstructionPerformedDateTime,
      PTag.kCTDIvol,
      PTag.kCTPositionSequence,
      PTag.kAcquisitionType,
      PTag.kPerformedStationAETitle,
      PTag.kSelectorSTValue,
      PTag.kDate,
      PTag.kTime
    ];

    final invalidVList = rsg.getDSList(LT.kMaxLength + 1, LT.kMaxLength + 1);

    test('LT checkVR good values', () {
      system.throwOnError = false;
      expect(LT.checkVRIndex(kLTIndex), kLTIndex);

      for (var tag in ltTags0) {
        system.throwOnError = false;
        expect(LT.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('LT checkVR bad values', () {
      system.throwOnError = false;
      expect(
          LT.checkVRIndex(
            kAEIndex,
          ),
          isNull);
      system.throwOnError = true;
      expect(() => LT.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(LT.checkVRIndex(tag.vrIndex), isNull);

        system.throwOnError = true;
        expect(() => LT.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('LT isValidVRIndex good values', () {
      system.throwOnError = false;
      expect(LT.isValidVRIndex(kLTIndex), true);

      for (var tag in ltTags0) {
        system.throwOnError = false;
        expect(LT.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('LT isValidVRIndex bad values', () {
      system.throwOnError = false;
      expect(LT.isValidVRIndex(kCSIndex), false);

      system.throwOnError = true;
      expect(() => LT.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(LT.isValidVRIndex(tag.vrIndex), false);

        system.throwOnError = true;
        expect(() => LT.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('LT isValidVRCode good values', () {
      system.throwOnError = false;
      expect(LT.isValidVRCode(kLTCode), true);

      for (var tag in ltTags0) {
        expect(LT.isValidVRCode(tag.vrCode), true);
      }
    });

    test('LT isValidVRCode bad values', () {
      system.throwOnError = false;
      expect(LT.isValidVRCode(kAECode), false);

      system.throwOnError = true;
      expect(() => LT.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));
      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(LT.isValidVRCode(tag.vrCode), false);

        system.throwOnError = true;
        expect(() => LT.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('LT isValidVFLength good values', () {
      expect(LT.isValidVFLength(LT.kMaxVFLength), true);
      expect(LT.isValidVFLength(0), true);
    });

    test('LT isValidVFLength bad values', () {
      expect(LT.isValidVFLength(LT.kMaxVFLength + 1), false);
      expect(LT.isValidVFLength(-1), false);
    });

    test('LT isNotValidVFLength good values', () {
      expect(LT.isNotValidVFLength(LT.kMaxVFLength), false);
      expect(LT.isNotValidVFLength(0), false);
    });

    test('LT isNotValidVFLength bad values', () {
      expect(LT.isNotValidVFLength(LT.kMaxVFLength + 1), true);
      expect(LT.isNotValidVFLength(-1), true);
    });

    test('LT isValidValueLength good values', () {
      for (var s in goodLTList) {
        for (var a in s) {
          expect(LT.isValidValueLength(a), true);
        }
      }

      expect(LT.isValidValueLength('a'), true);
    });

    // Urgent Sharath: changed to true
    test('LT isValidValueLength bad values', () {
      expect(LT.isValidValueLength(''), true);
    });

    test('LT isNotValidValueLength good values', () {
      for (var s in goodLTList) {
        for (var a in s) {
          expect(LT.isNotValidValueLength(a), false);
        }
      }
    });

    test('LT isNotValidValueLength bad values', () {
      expect(
          LT.isNotValidValueLength(
              '&t&wSB)~PIA!UIDX }d!zD2N3 2fz={@^mHL:/"qmczv9LzgGEH6bTY&N}J'),
          false);
    });

    test('LT isValidVListLength VM.k1 good values', () {
      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getLTList(1, 1);
        for (var tag in ltTags0) {
          expect(LT.isValidVListLength(tag, validMinVList), true);

          expect(
              LT.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              LT.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('LT isValidVListLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rsg.getLTList(2, i + 1);
        for (var tag in ltTags0) {
          system.throwOnError = false;
          expect(LT.isValidVListLength(tag, validMinVList), false);

          expect(LT.isValidVListLength(tag, invalidVList), false);

          system.throwOnError = true;
          expect(() => LT.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesLengthError>()));
        }
      }
    });

    test('LT isValidValue good values', () {
      for (var s in goodLTList) {
        for (var a in s) {
          expect(LT.isValidValue(a), true);
        }
      }

      for (var s in badLTList) {
        for (var a in s) {
          system.throwOnError = false;
          expect(LT.isValidValue(a), false);

          system.throwOnError = true;
          expect(() => LT.isValidValue(a),
              throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
        }
      }
    });

    test('LT isValidValues good values', () {
      system.throwOnError = false;
      for (var s in goodLTList) {
        expect(LT.isValidValues(PTag.kExtendedCodeMeaning, s), true);
      }
      for (var s in badLTList) {
        system.throwOnError = false;
        expect(LT.isValidValues(PTag.kExtendedCodeMeaning, s), false);

        system.throwOnError = true;
        expect(() => LT.isValidValues(PTag.kExtendedCodeMeaning, s),
            throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
      }
    });

    test('LT fromBytes', () {
      //  system.level = Level.debug;;
      final vList1 = rsg.getLTList(1, 1);
      final bytes = LT.toBytes(vList1);
      log.debug('LT.fromBytes(bytes): ${LT.fromBytes(bytes)}, bytes: $bytes');
      expect(LT.fromBytes(bytes), equals(vList1));
    });

    test('LT toBytes', () {
      final vList1 = rsg.getLTList(1, 1);
      log.debug('LT.toBytes(vList1): ${LT.toBytes(vList1)}');
      /* final val = ASCII.encode('s6V&:;s%?Q1g5v');
        expect(LT.toBytes(['s6V&:;s%?Q1g5v']), equals(val));*/
      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = ASCII.encode(vList1[0]);
      expect(LT.toBytes(vList1), equals(values));
    });

/*
    test('LT fromBase64', () {
      final vList1 = rsg.getLTList(1, 1);
      //final values = ASCII.encode(vList1[0]);
      system.throwOnError = false;
      final v0 = LT.fromBase64(vList1);
      expect(v0, isNotNull);

      final v1 = LT.fromBase64(['PIA5']);
      expect(v1, isNotNull);

      final v2 = LT.fromBase64(['PIA']);
      expect(v2, isNotNull);
    });

    test('LT toBase64', () {
      final vList0 = rsg.getLTList(1, 1);
      expect(LT.toBase64(vList0), equals(vList0));

      final vList1 = ['dslkj'];
      //final s0 = ASCII.encode(vList0[0]);
      expect(LT.toBase64(vList1), equals(vList1));
    });
*/

    test('LT checkList good values', () {
      system.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList = rsg.getLTList(1, 1);
        expect(LT.checkList(PTag.kExtendedCodeMeaning, vList), vList);
      }

      final vList0 = ['!mSMXWVy`]/Du'];
      expect(LT.checkList(PTag.kExtendedCodeMeaning, vList0), vList0);

      final vList1 = ['\b'];
      expect(LT.checkList(PTag.kExtendedCodeMeaning, vList1), isNull);

      system.throwOnError = true;
      expect(() => LT.checkList(PTag.kExtendedCodeMeaning, vList1),
          throwsA(const isInstanceOf<InvalidCharacterInStringError>()));

      for (var s in goodLTList) {
        system.throwOnError = false;
        expect(LT.checkList(PTag.kExtendedCodeMeaning, s), s);
      }
      for (var s in badLTList) {
        system.throwOnError = false;
        expect(LT.checkList(PTag.kExtendedCodeMeaning, s), isNull);

        system.throwOnError = true;
        expect(() => LT.checkList(PTag.kExtendedCodeMeaning, s),
            throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
      }
    });
  });

  group('PNtag', () {
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
    test('PN hasValidValues good values', () {
      for (var s in goodPNList) {
        system.throwOnError = false;
        final pn0 = new PNtag(PTag.kRequestingPhysician, s);
        expect(pn0.hasValidValues, true);
      }
      system.throwOnError = false;
      final pn0 = new PNtag(PTag.kOrderEnteredBy, []);
      expect(pn0.hasValidValues, true);
      expect(pn0.values, equals(<String>[]));
    });

    test('PN hasValidValues bad values', () {
      for (var s in badPNList) {
        system.throwOnError = false;
        final pn0 = new PNtag(PTag.kRequestingPhysician, s);
        expect(pn0, isNull);

        system.throwOnError = true;
        expect(() => new PNtag(PTag.kRequestingPhysician, s),
            throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
      }

      system.throwOnError = false;
      final pn1 = new PNtag(PTag.kOrderEnteredBy, null);
      log.debug('pn1: $pn1');
      expect(pn1, isNull);

      system.throwOnError = true;
      expect(() => new PNtag(PTag.kRequestingPhysician, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('PN hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final pn0 = new PNtag(PTag.kRequestingPhysician, vList0);
        log.debug('pn0:${pn0.info}');
        expect(pn0.hasValidValues, true);

        log
          ..debug('pn0: $pn0, values: ${pn0.values}')
          ..debug('pn0: ${pn0.info}');
        expect(pn0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 10);
        final pn1 = new PNtag(PTag.kSelectorPNValue, vList0);
        log.debug('pn1:${pn1.info}');
        expect(pn1.hasValidValues, true);

        log
          ..debug('pn1: $pn1, values: ${pn1.values}')
          ..debug('pn1: ${pn1.info}');
        expect(pn1[0], equals(vList0[0]));
      }
    });

    test('PN hasValidValues bad values random', () {
      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(3, 4);
        log.debug('$i: vList0: $vList0');
        final pn2 = new PNtag(PTag.kRequestingPhysician, vList0);
        expect(pn2, isNull);
      }

      system.throwOnError = true;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(3, 4);
        log.debug('$i: vList0: $vList0');
        expect(() => new PNtag(PTag.kRequestingPhysician, vList0),
            throwsA(const isInstanceOf<InvalidValuesLengthError>()));
      }
    });

    test('PN update random', () {
      final pn0 = new PNtag(PTag.kOrderEnteredBy, []);
      expect(pn0.update(['Pb5HpbS4^, bgPK^re']).values,
          equals(['Pb5HpbS4^, bgPK^re']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final pn1 = new PNtag(PTag.kOrderEnteredBy, vList0);
        final vList1 = rsg.getPNList(3, 4);
        expect(() => pn1.update(vList1).values,
            throwsA(const isInstanceOf<InvalidValuesLengthError>()));
      }
    });

    test('PN noValues random', () {
      final pn0 = new PNtag(PTag.kOrderEnteredBy, []);
      final PNtag pnNoValues = pn0.noValues;
      expect(pnNoValues.values.isEmpty, true);
      log.debug('as0: ${pn0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final pn0 = new PNtag(PTag.kOrderEnteredBy, vList0);
        log.debug('pn0: $pn0');
        expect(pnNoValues.values.isEmpty, true);
        log.debug('pn0: ${pn0.noValues}');
      }
    });

    test('PN copy random', () {
      final pn0 = new PNtag(PTag.kOrderEnteredBy, []);
      final PNtag pn1 = pn0.copy;
      expect(pn1 == pn0, true);
      expect(pn1.hashCode == pn0.hashCode, true);

      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final pn2 = new PNtag(PTag.kOrderEnteredBy, vList0);
        final PNtag pn3 = pn2.copy;
        expect(pn3 == pn2, true);
        expect(pn3.hashCode == pn2.hashCode, true);
      }
    });

    test('PN []', () {
      // empty list and null as values
    });

    test('PN hashCode and == random', () {
      List<String> stringList0;
      List<String> stringList1;
      List<String> stringList2;
      List<String> stringList3;

      log.debug('PN hashCode and == ');
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getPNList(1, 1);
        final pn0 = new PNtag(PTag.kOrderEnteredBy, stringList0);
        final pn1 = new PNtag(PTag.kOrderEnteredBy, stringList0);
        log
          ..debug('stringList0:$stringList0, pn0.hash_code:${pn0.hashCode}')
          ..debug('stringList0:$stringList0, pn1.hash_code:${pn1.hashCode}');
        expect(pn0.hashCode == pn1.hashCode, true);
        expect(pn0 == pn1, true);

        stringList1 = rsg.getPNList(1, 1);
        final pn2 = new PNtag(PTag.kVerifyingObserverName, stringList1);
        log.debug('stringList1:$stringList1 , lo2.hash_code:${pn2.hashCode}');
        expect(pn0.hashCode == pn2.hashCode, false);
        expect(pn0 == pn2, false);

        stringList2 = rsg.getPNList(1, 10);
        final pn3 = new PNtag(PTag.kSelectorPNValue, stringList2);
        log.debug('stringList2:$stringList2 , lo3.hash_code:${pn3.hashCode}');
        expect(pn0.hashCode == pn3.hashCode, false);
        expect(pn0 == pn3, false);

        stringList3 = rsg.getPNList(2, 3);
        final pn4 = new PNtag(PTag.kOrderEnteredBy, stringList3);
        log.debug('stringList3:$stringList3 , pn4.hash_code:${pn4.hashCode}');
        expect(pn0.hashCode == pn4.hashCode, false);
        expect(pn0 == pn4, false);
      }
    });

    test('PN valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final pn0 = new PNtag(PTag.kOrderEnteredBy, vList0);
        expect(vList0, equals(pn0.valuesCopy));
      }
    });

    test('PN isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final pn0 = new PNtag(PTag.kOrderEnteredBy, vList0);
        expect(pn0.tag.isValidLength(pn0.length), true);
      }
    });

    test('PN isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final pn0 = new PNtag(PTag.kOrderEnteredBy, vList0);
        expect(pn0.tag.isValidValues(pn0.values), true);
        expect(pn0.hasValidValues, true);
      }
    });

    test('PN replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        final pn0 = new PNtag(PTag.kOrderEnteredBy, vList0);
        final vList1 = rsg.getPNList(1, 1);
        expect(pn0.replace(vList1), equals(vList0));
        expect(pn0.values, equals(vList1));
      }

      final vList1 = rsg.getPNList(1, 1);
      final pn1 = new PNtag(PTag.kOrderEnteredBy, vList1);
      expect(pn1.replace([]), equals(vList1));
      expect(pn1.values, equals(<String>[]));

      final pn2 = new PNtag(PTag.kOrderEnteredBy, vList1);
      expect(pn2.replace(null), equals(vList1));
      expect(pn2.values, equals(<String>[]));
    });

    test('PN blank random', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getPNList(1, 1);
        final pn0 = new PNtag(PTag.kOrderEnteredBy, vList1);
        for (var i = 1; i < 10; i++) {
          final blank = pn0.blank(i);
          log.debug(('blank$i: ${blank.values}'));
          expect(blank.values.length == 1, true);
          expect(blank.value.length == i, true);
          final strSpaceList = <String>[''.padRight(i, ' ')];
          log.debug('strSpaceList: $strSpaceList');
          expect(blank.values, equals(strSpaceList));
        }
      }
    });

    test('PN formBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getPNList(1, 1);
        final bytes = PN.toBytes(vList1);
        log.debug('bytes:$bytes');
        final pn0 = new PNtag.fromBytes(PTag.kOrderEnteredBy, bytes);
        log.debug('pn0: ${pn0.info}');
        expect(pn0.hasValidValues, true);
      }
    });

    test('PN checkLength good values', () {
      final vList0 = rsg.getPNList(1, 1);
      final pn0 = new PNtag(PTag.kOrderEnteredBy, vList0);
      for (var s in goodPNList) {
        expect(pn0.checkLength(s), true);
      }
      final pn1 = new PNtag(PTag.kOrderEnteredBy, vList0);
      expect(pn1.checkLength([]), true);

      for (var s in goodPNList) {
        final vList1 = rsg.getPNList(1, 10);
        final pn2 = new PNtag(PTag.kPerformingPhysicianName, vList1);
        expect(pn2.checkLength(s), true);
      }
    });

    test('PN checkLength bad values', () {
      final vList2 = ['a^1sd', '02@#'];
      final pn3 = new PNtag(PTag.kOrderEnteredBy, vList2);
      expect(pn3, isNull);
    });

    test('PN checkValue good values', () {
      final vList0 = rsg.getPNList(1, 1);
      final pn0 = new PNtag(PTag.kOrderEnteredBy, vList0);
      for (var s in goodPNList) {
        for (var a in s) {
          expect(pn0.checkValue(a), true);
        }
      }
    });

    test('PN checkValue bad values', () {
      final vList0 = rsg.getPNList(1, 1);
      final pn0 = new PNtag(PTag.kOrderEnteredBy, vList0);
      for (var s in badPNList) {
        for (var a in s) {
          system.throwOnError = false;
          expect(pn0.checkValue(a), false);

          system.throwOnError = true;
          expect(() => pn0.checkValue(a),
              throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
        }
      }
    });
  });

  group('PN', () {
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

    //VM.k1
    const pnTags0 = const <PTag>[
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
    const pnTags1 = const <PTag>[
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

    test('PN checkVR good values', () {
      system.throwOnError = false;
      expect(PN.checkVRIndex(kPNIndex), kPNIndex);

      for (var tag in pnTags0) {
        system.throwOnError = false;
        expect(PN.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('PN checkVR bad values', () {
      system.throwOnError = false;
      expect(
          PN.checkVRIndex(
            kAEIndex,
          ),
          isNull);
      system.throwOnError = true;
      expect(() => PN.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(PN.checkVRIndex(tag.vrIndex), isNull);

        system.throwOnError = true;
        expect(() => PN.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('PN isValidVRIndex good values', () {
      system.throwOnError = false;
      expect(PN.isValidVRIndex(kPNIndex), true);

      for (var tag in pnTags0) {
        system.throwOnError = false;
        expect(PN.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('PN isValidVRIndex bad values', () {
      system.throwOnError = false;
      expect(PN.isValidVRIndex(kCSIndex), false);

      system.throwOnError = true;
      expect(() => PN.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(PN.isValidVRIndex(tag.vrIndex), false);

        system.throwOnError = true;
        expect(() => PN.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('PN isValidVRCode good values', () {
      system.throwOnError = false;
      expect(PN.isValidVRCode(kPNCode), true);

      for (var tag in pnTags0) {
        expect(PN.isValidVRCode(tag.vrCode), true);
      }
    });

    test('PN isValidVRCode bad values', () {
      system.throwOnError = false;
      expect(PN.isValidVRCode(kAECode), false);

      system.throwOnError = true;
      expect(() => PN.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(PN.isValidVRCode(tag.vrCode), false);

        system.throwOnError = true;
        expect(() => PN.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('PN isValidVFLength good values', () {
      expect(PN.isValidVFLength(PN.kMaxVFLength), true);
      expect(PN.isValidVFLength(0), true);
    });

    test('PN isValidVFLength bad values', () {
      expect(PN.isValidVFLength(PN.kMaxVFLength + 1), false);
      expect(PN.isValidVFLength(-1), false);
    });

    test('PN isNotValidVFLength good values', () {
      expect(PN.isNotValidVFLength(PN.kMaxVFLength), false);
      expect(PN.isNotValidVFLength(0), false);
    });

    test('PN isNotValidVFLength bad values', () {
      expect(PN.isNotValidVFLength(PN.kMaxVFLength + 1), true);
      expect(PN.isNotValidVFLength(-1), true);
    });

    test('PN isValidValueLength good values', () {
      for (var s in goodPNList) {
        for (var a in s) {
          expect(PN.isValidValueLength(a), true);
        }
      }
      expect(PN.isValidValueLength('a'), true);
    });

    test('PN isValidValueLength bad values', () {
      expect(PN.isValidValueLength(''), false);
    });

    test('PN isNotValidValueLength', () {
      for (var s in goodPNList) {
        for (var a in s) {
          expect(PN.isNotValidValueLength(a), false);
        }
      }

      expect(PN.isNotValidValueLength(''), true);
    });

    test('PN isValidValue good values', () {
      for (var s in goodPNList) {
        for (var a in s) {
          expect(PN.isValidValue(a), true);
        }
      }
    });

    test('PN isValidValue bad values', () {
      for (var s in badPNList) {
        for (var a in s) {
          system.throwOnError = false;
          expect(PN.isValidValue(a), false);

          system.throwOnError = true;
          expect(() => PN.isValidValue(a),
              throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
        }
      }
    });

    test('PN isValidVListLength VM.k1 good values', () {
      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getPNList(1, 1);
        for (var tag in pnTags0) {
          expect(PN.isValidVListLength(tag, validMinVList), true);

          expect(
              PN.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              PN.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('PN isValidVListLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rsg.getPNList(2, i + 1);
        for (var tag in pnTags0) {
          system.throwOnError = false;
          expect(PN.isValidVListLength(tag, validMinVList), false);

          expect(PN.isValidVListLength(tag, invalidVList), false);

          system.throwOnError = true;
          expect(() => PN.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesLengthError>()));
        }
      }
    });

    test('PN isValidVListLength VM.k1_n good values', () {
      system.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final validMinVList0 = rsg.getPNList(1, i);
        final validMaxLengthList = invalidVList.sublist(0, PN.kMaxLength);
        for (var tag in pnTags1) {
          log.debug('tag: $tag');
          expect(PN.isValidVListLength(tag, validMinVList0), true);
          expect(PN.isValidVListLength(tag, validMaxLengthList), true);
        }
      }
    });

    test('PN isValidValues good values', () {
      system.throwOnError = false;
      for (var s in goodPNList) {
        expect(PN.isValidValues(PTag.kPatientName, s), true);
      }
    });

    test('PN isValidValues bad values', () {
      for (var s in badPNList) {
        system.throwOnError = false;
        expect(PN.isValidValues(PTag.kPatientName, s), false);

        system.throwOnError = true;
        expect(() => PN.isValidValues(PTag.kPatientName, s),
            throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
      }
    });

    test('PN fromBytes', () {
      //  system.level = Level.debug;;
      final vList1 = rsg.getPNList(1, 1);
      final bytes = PN.toBytes(vList1);
      log.debug('PN.fromBytes(bytes): ${PN.fromBytes(bytes)}, bytes: $bytes');
      expect(PN.fromBytes(bytes), equals(vList1));
    });

    test('PN toBytes', () {
      final vList1 = rsg.getPNList(1, 1);
      log.debug('PN.toBytes(vList1): ${PN.toBytes(vList1)}');

      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = ASCII.encode(vList1[0]);
      expect(PN.toBytes(vList1), equals(values));
    });

/*
    test('PN fromBase64', () {
      final vList1 = rsg.getPNList(1, 1);
      //final values = ASCII.encode(vList1[0]);
      system.throwOnError = false;
      final v0 = PN.fromBase64(vList1);
      expect(v0, isNotNull);

      final v1 = PN.fromBase64(['PIA5']);
      expect(v1, isNotNull);

      final v2 = PN.fromBase64(['PIA']);
      expect(v2, isNotNull);
    });

    test('PN toBase64', () {
      final vList0 = rsg.getPNList(1, 1);
      expect(PN.toBase64(vList0), equals(vList0));

      final vList1 = ['dslkj'];
      //final s0 = ASCII.encode(vList0[0]);
      expect(PN.toBase64(vList1), equals(vList1));
    });
*/
  });


  group('SHtag', () {
    const goodSHList = const <List<String>>[
      const <String>['d9E8tO'],
      const <String>['mrZeo|^P> -6{t, '],
      const <String>[')QcFN@1r]&u;~3l'],
      const <String>['1wd7'],
      const <String>['T 2@+nEZKu/J']
    ];

    const badSHList = const <List<String>>[
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
    test('SH hasValidValues good values', () {
      for (var s in goodSHList) {
        system.throwOnError = false;
        final sh0 = new SHtag(PTag.kMultiCoilElementName, s);
        expect(sh0.hasValidValues, true);
      }
      system.throwOnError = false;
      final sh0 = new SHtag(PTag.kSelectorSHValue, []);
      expect(sh0.hasValidValues, true);
      expect(sh0.values, equals(<String>[]));
    });

    test('SH hasValidValues bad values', () {
      for (var s in badSHList) {
        system.throwOnError = false;
        final sh0 = new SHtag(PTag.kMultiCoilElementName, s);
        expect(sh0, isNull);

        system.throwOnError = true;
        expect(() => new SHtag(PTag.kMultiCoilElementName, s),
            throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
      }
      system.throwOnError = false;
      final sh1 = new SHtag(PTag.kSelectorSHValue, null);
      log.debug('sh1: $sh1');
      expect(sh1, isNull);

      system.throwOnError = true;
      expect(() => new SHtag(PTag.kMultiCoilElementName, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('SH hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 1);
        final sh0 = new SHtag(PTag.kMultiCoilElementName, vList0);
        log.debug('sh0:${sh0.info}');
        expect(sh0.hasValidValues, true);

        log
          ..debug('sh0: $sh0, values: ${sh0.values}')
          ..debug('sh0: ${sh0.info}');
        expect(sh0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 10);
        final sh1 = new SHtag(PTag.kSelectorSHValue, vList0);
        log.debug('sh1:${sh1.info}');
        expect(sh1.hasValidValues, true);

        log
          ..debug('sh1: $sh1, values: ${sh1.values}')
          ..debug('sh1: ${sh1.info}');
        expect(sh1[0], equals(vList0[0]));
      }
    });

    test('SH hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final vList0 = rsg.getSHList(3, 4);
        log.debug('$i: vList0: $vList0');
        final sh2 = new SHtag(PTag.kMultiCoilElementName, vList0);
        expect(sh2, isNull);

        system.throwOnError = true;
        expect(() => new SHtag(PTag.kMultiCoilElementName, vList0),
            throwsA(const isInstanceOf<InvalidValuesLengthError>()));
      }
    });

    test('SH update random', () {
      final sh0 = new SHtag(PTag.kSelectorSHValue, []);
      expect(sh0.update(['d^u:96P, azV']).values, equals(['d^u:96P, azV']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(3, 4);
        final sh1 = new SHtag(PTag.kSelectorSHValue, vList0);
        final vList1 = rsg.getSHList(3, 4);
        expect(sh1.update(vList1).values, equals(vList1));
      }
    });

    test('SH noValues random', () {
      final sh0 = new SHtag(PTag.kSelectorSHValue, []);
      final SHtag shNoValues = sh0.noValues;
      expect(shNoValues.values.isEmpty, true);
      log.debug('as0: ${sh0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(3, 4);
        final sh0 = new SHtag(PTag.kSelectorSHValue, vList0);
        log.debug('sh0: $sh0');
        expect(shNoValues.values.isEmpty, true);
        log.debug('sh0: ${sh0.noValues}');
      }
    });

    test('SH copy random', () {
      final sh0 = new SHtag(PTag.kSelectorSHValue, []);
      final SHtag sh1 = sh0.copy;
      expect(sh1 == sh0, true);
      expect(sh1.hashCode == sh0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(3, 4);
        final sh2 = new SHtag(PTag.kSelectorSHValue, vList0);
        final SHtag sh3 = sh2.copy;
        expect(sh3 == sh2, true);
        expect(sh3.hashCode == sh2.hashCode, true);
      }
    });

    test('SH hashCode and == good values random', () {
      List<String> stringList0;
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getSHList(1, 1);
        final sh0 = new SHtag(PTag.kTextureLabel, stringList0);
        final sh1 = new SHtag(PTag.kTextureLabel, stringList0);
        log
          ..debug('stringList0:$stringList0, sh0.hash_code:${sh0.hashCode}')
          ..debug('stringList0:$stringList0, sh1.hash_code:${sh1.hashCode}');
        expect(sh0.hashCode == sh1.hashCode, true);
        expect(sh0 == sh1, true);
      }
    });

    test('SH hashCode and == bad values random', () {
      system.throwOnError = false;
      List<String> stringList0;
      List<String> stringList1;
      List<String> stringList2;
      List<String> stringList3;

      log.debug('SH hashCode and == ');
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getSHList(1, 1);
        final sh0 = new SHtag(PTag.kTextureLabel, stringList0);

        stringList1 = rsg.getSHList(1, 1);
        final sh2 = new SHtag(PTag.kStorageMediaFileSetID, stringList1);
        log.debug('stringList1:$stringList1 , sh2.hash_code:${sh2.hashCode}');
        expect(sh0.hashCode == sh2.hashCode, false);
        expect(sh0 == sh2, false);

        stringList2 = rsg.getSHList(1, 10);
        final sh3 = new SHtag(PTag.kSelectorSHValue, stringList2);
        log.debug('stringList2:$stringList2 , sh3.hash_code:${sh3.hashCode}');
        expect(sh0.hashCode == sh3.hashCode, false);
        expect(sh0 == sh3, false);

        stringList3 = rsg.getSHList(2, 3);
        final sh4 = new SHtag(PTag.kTextureLabel, stringList3);
        log.debug('stringList3:$stringList3 , sh4.hash_code:${sh4.hashCode}');
        expect(sh0.hashCode == sh4.hashCode, false);
        expect(sh0 == sh4, false);
      }
    });

    test('SH valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 1);
        final sh0 = new SHtag(PTag.kTextureLabel, vList0);
        expect(vList0, equals(sh0.valuesCopy));
      }
    });

    test('SH isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 1);
        final sh0 = new SHtag(PTag.kTextureLabel, vList0);
        expect(sh0.tag.isValidLength(sh0.length), true);
      }
    });

    test('SH isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 1);
        final sh0 = new SHtag(PTag.kTextureLabel, vList0);
        expect(sh0.tag.isValidValues(sh0.values), true);
        expect(sh0.hasValidValues, true);
      }
    });

    test('SH replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 1);
        final sh0 = new SHtag(PTag.kTextureLabel, vList0);
        final vList1 = rsg.getSHList(1, 1);
        expect(sh0.replace(vList1), equals(vList0));
        expect(sh0.values, equals(vList1));
      }

      final vList1 = rsg.getSHList(1, 1);
      final sh1 = new SHtag(PTag.kTextureLabel, vList1);
      expect(sh1.replace([]), equals(vList1));
      expect(sh1.values, equals(<String>[]));

      final sh2 = new SHtag(PTag.kTextureLabel, vList1);
      expect(sh2.replace(null), equals(vList1));
      expect(sh2.values, equals(<String>[]));
    });

    test('SH blank random', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getSHList(1, 1);
        final sh0 = new SHtag(PTag.kTextureLabel, vList1);
        for (var i = 1; i < 10; i++) {
          final blank = sh0.blank(i);
          log.debug(('blank$i: ${blank.values}'));
          expect(blank.values.length == 1, true);
          expect(blank.value.length == i, true);
          final strSpaceList = <String>[''.padRight(i, ' ')];
          log.debug('strSpaceList: $strSpaceList');
          expect(blank.values, equals(strSpaceList));
        }
      }
    });

    test('SH formBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getSHList(1, 1);
        final bytes = SH.toBytes(vList1);
        log.debug('bytes:$bytes');
        final sh0 = new SHtag.fromBytes(PTag.kTextureLabel, bytes);
        log.debug('sh0: ${sh0.info}');
        expect(sh0.hasValidValues, true);
      }
    });

    test('SH checkLength good values', () {
      final vList0 = rsg.getSHList(1, 1);
      final sh0 = new SHtag(PTag.kTextureLabel, vList0);
      for (var s in goodSHList) {
        expect(sh0.checkLength(s), true);
      }
      final sh1 = new SHtag(PTag.kTextureLabel, vList0);
      expect(sh1.checkLength([]), true);

      final vList1 = rsg.getSHList(1, 10);
      final sh2 = new SHtag(PTag.kConvolutionKernel, vList1);
      for (var s in goodSHList) {
        expect(sh2.checkLength(s), true);
      }
    });

    test('SH checkLength bad values', () {
      system.throwOnError = false;
      final vList2 = ['a^1sd', '02@#'];
      final sh3 = new SHtag(PTag.kTextureLabel, vList2);
      expect(sh3, isNull);

      system.throwOnError = true;
      expect(() => new SHtag(PTag.kTextureLabel, vList2),
          throwsA(const isInstanceOf<InvalidValuesLengthError>()));
    });

    test('SH checkValue good values', () {
      final vList0 = rsg.getSHList(1, 1);
      final sh0 = new SHtag(PTag.kTextureLabel, vList0);
      for (var s in goodSHList) {
        for (var a in s) {
          expect(sh0.checkValue(a), true);
        }
      }
    });

    test('SH checkValue bad values', () {
      final vList0 = rsg.getSHList(1, 1);
      final sh0 = new SHtag(PTag.kTextureLabel, vList0);
      for (var s in badSHList) {
        for (var a in s) {
          system.throwOnError = false;
          expect(sh0.checkValue(a), false);

          system.throwOnError = true;
          expect(() => sh0.checkValue(a),
              throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
        }
      }
    });
  });

  group('SH', () {
    const goodSHList = const <List<String>>[
      const <String>['d9E8tO'],
      const <String>['mrZeo|^P> -6{t, '],
      const <String>[')QcFN@1r]&u;~3l'],
      const <String>['1wd7'],
      const <String>['T 2@+nEZKu/J']
    ];

    const badSHList = const <List<String>>[
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

    //VM.k1
    const shTags0 = const <PTag>[
      PTag.kImplementationVersionName,
      PTag.kRecognitionCode,
      PTag.kCodeValue,
      PTag.kStationName,
      PTag.kReceiveCoilName,
      PTag.kDetectorID,
      PTag.kPulseSequenceName,
      PTag.kMultiCoilElementName,
      PTag.kRespiratorySignalSourceID,
      PTag.kStudyID,
      PTag.kStackID,
      PTag.kCompressionOriginator,
      PTag.kCompressionDescription,
      PTag.kChannelLabel,
      PTag.kScheduledProcedureStepID,
      PTag.kEnergyWindowName,
      PTag.kOwnerID,
      PTag.kPrintQueueID,
      PTag.kFluenceModeID,
      PTag.kRTPlanLabel,
      PTag.kApplicatorID
    ];

    //VM.k1_n
    const shTags1 = const <PTag>[
      PTag.kReferringPhysicianTelephoneNumbers,
      PTag.kPatientTelephoneNumbers,
      PTag.kConvolutionKernel,
      PTag.kFrameLabelVector,
      PTag.kDisplayWindowLabelVector,
      PTag.kOutputPower,
      PTag.kSelectorSHValue,
      PTag.kAxisUnits,
      PTag.kAxisLabels,
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

    final invalidVList = rsg.getSHList(SH.kMaxLength + 1, SH.kMaxLength + 1);

    test('SH checkVR good values', () {
      system.throwOnError = false;
      expect(SH.checkVRIndex(kSHIndex), kSHIndex);

      for (var tag in shTags0) {
        system.throwOnError = false;
        expect(SH.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('SH checkVR bad values', () {
      system.throwOnError = false;
      expect(
          SH.checkVRIndex(
            kAEIndex,
          ),
          isNull);
      system.throwOnError = true;
      expect(() => SH.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(SH.checkVRIndex(tag.vrIndex), isNull);

        system.throwOnError = true;
        expect(() => SH.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('SH isValidVRIndex good values', () {
      system.throwOnError = false;
      expect(SH.isValidVRIndex(kSHIndex), true);

      for (var tag in shTags0) {
        system.throwOnError = false;
        expect(SH.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('SH isValidVRIndex bad values', () {
      system.throwOnError = false;
      expect(SH.isValidVRIndex(kCSIndex), false);

      system.throwOnError = true;
      expect(() => SH.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(SH.isValidVRIndex(tag.vrIndex), false);

        system.throwOnError = true;
        expect(() => SH.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('SH isValidVRCode good values', () {
      system.throwOnError = false;
      expect(SH.isValidVRCode(kSHCode), true);

      for (var tag in shTags0) {
        expect(SH.isValidVRCode(tag.vrCode), true);
      }
    });

    test('SH isValidVRCode bad values', () {
      system.throwOnError = false;
      expect(SH.isValidVRCode(kAECode), false);

      system.throwOnError = true;
      expect(() => SH.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(SH.isValidVRCode(tag.vrCode), false);

        system.throwOnError = true;
        expect(() => SH.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('SH isValidVFLength good values', () {
      expect(SH.isValidVFLength(SH.kMaxVFLength), true);
      expect(SH.isValidVFLength(0), true);
    });

    test('SH isValidVFLength bad values', () {
      expect(SH.isValidVFLength(SH.kMaxVFLength + 1), false);
      expect(SH.isValidVFLength(-1), false);
    });

    test('SH isNotValidVFLength good values', () {
      expect(SH.isNotValidVFLength(SH.kMaxVFLength), false);
      expect(SH.isNotValidVFLength(0), false);
    });

    test('SH isNotValidVFLength bad values', () {
      expect(SH.isNotValidVFLength(SH.kMaxVFLength + 1), true);
      expect(SH.isNotValidVFLength(-1), true);
    });

    test('SH isValidValueLength good values', () {
      for (var s in goodSHList) {
        for (var a in s) {
          expect(SH.isValidValueLength(a), true);
        }
      }

      expect(SH.isValidValueLength('a'), true);
    });

    test('SH isValidValueLength good values', () {
      expect(SH.isValidValueLength(''), false);
    });

    test('SH isNotValidValueLength good values', () {
      for (var s in goodSHList) {
        for (var a in s) {
          expect(SH.isNotValidValueLength(a), false);
        }
      }
    });

    test('SH isNotValidValueLength bad values', () {
      expect(SH.isNotValidValueLength(''), true);
    });

    test('SH isValidVListLength VM.k1 good values', () {
      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getSHList(1, 1);
        for (var tag in shTags0) {
          expect(SH.isValidVListLength(tag, validMinVList), true);

          expect(
              SH.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              SH.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('SH isValidVListLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rsg.getSHList(2, i + 1);
        for (var tag in shTags0) {
          system.throwOnError = false;
          expect(SH.isValidVListLength(tag, validMinVList), false);

          expect(SH.isValidVListLength(tag, invalidVList), false);

          system.throwOnError = true;
          expect(() => SH.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesLengthError>()));
        }
      }
    });

    test('SH isValidVListLength VM.k1_n good values', () {
      system.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final validMinVList0 = rsg.getSHList(1, i);
        final validMaxLengthList = invalidVList.sublist(0, SH.kMaxLength);
        for (var tag in shTags1) {
          log.debug('tag: $tag');
          expect(SH.isValidVListLength(tag, validMinVList0), true);
          expect(SH.isValidVListLength(tag, validMaxLengthList), true);
        }
      }
    });

    test('SH isValidValue good values', () {
      for (var s in goodSHList) {
        for (var a in s) {
          expect(SH.isValidValue(a), true);
        }
      }
    });

    test('SH isValidValue bad values', () {
      for (var s in badSHList) {
        for (var a in s) {
          system.throwOnError = false;
          expect(SH.isValidValue(a), false);

          system.throwOnError = true;
          expect(() => SH.isValidValue(a),
              throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
        }
      }
    });

    test('SH isValidValues good values', () {
      system.throwOnError = false;
      for (var s in goodSHList) {
        expect(SH.isValidValues(PTag.kStationName, s), true);
      }
    });

    test('SH isValidValues bad values', () {
      system.throwOnError = false;
      for (var s in badSHList) {
        system.throwOnError = false;
        expect(SH.isValidValues(PTag.kStationName, s), false);

        system.throwOnError = true;
        expect(() => SH.isValidValues(PTag.kStationName, s),
            throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
      }
    });

    test('SH fromBytes', () {
      //  system.level = Level.debug;;
      final vList1 = rsg.getSHList(1, 1);
      final bytes = SH.toBytes(vList1);
      log.debug('SH.fromBytes(bytes): ${SH.fromBytes(bytes)}, bytes: $bytes');
      expect(SH.fromBytes(bytes), equals(vList1));
    });

    test('SH toBytes', () {
      final vList1 = rsg.getSHList(1, 1);
      log.debug('SH.toBytes(vList1): ${SH.toBytes(vList1)}');
      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = ASCII.encode(vList1[0]);
      expect(SH.toBytes(vList1), equals(values));
    });

/*
    test('SH fromBase64', () {
      final vList1 = rsg.getSHList(1, 1);
      //final values = ASCII.encode(vList1[0]);
      system.throwOnError = false;
      final v0 = SH.fromBase64(vList1);
      expect(v0, isNotNull);

      final v1 = SH.fromBase64(['PIA5']);
      expect(v1, isNotNull);

      final v2 = SH.fromBase64(['PIA']);
      expect(v2, isNotNull);
    });

    test('SH toBase64', () {
      final vList0 = rsg.getSHList(1, 1);
      expect(SH.toBase64(vList0), equals(vList0));

      final vList1 = ['dslkj'];
      //final s0 = ASCII.encode(vList0[0]);
      expect(SH.toBase64(vList1), equals(vList1));
    });
*/

    test('SH checkList good values', () {
      system.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList = rsg.getSHList(1, 1);
        expect(SH.checkList(PTag.kStationName, vList), vList);
      }

      final vList0 = ['!mSMXWVy`]/Du'];
      expect(SH.checkList(PTag.kStationName, vList0), vList0);

      for (var s in goodSHList) {
        system.throwOnError = false;
        expect(SH.checkList(PTag.kStationName, s), s);
      }
    });

    test('SH checkList bad values', () {
      system.throwOnError = false;
      final vList1 = ['r^`~\\?'];
      expect(SH.checkList(PTag.kStationName, vList1), isNull);

      system.throwOnError = true;
      expect(() => SH.checkList(PTag.kStationName, vList1),
          throwsA(const isInstanceOf<InvalidCharacterInStringError>()));

      for (var s in badSHList) {
        system.throwOnError = false;
        expect(SH.checkList(PTag.kStationName, s), isNull);

        system.throwOnError = true;
        expect(() => SH.checkList(PTag.kStationName, s),
            throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
      }
    });
  });

  group('ST Tests', () {
    const goodSTList = const <List<String>>[
      const <String>['\t '], //horizontal tab (HT)
      const <String>['\n'], //linefeed (LF)
      const <String>['\f '], // form feed (FF)
      const <String>['\r '], //carriage return (CR)
      const <String>['(s!WGR3D:2hhWF|,'],
      const <String>['6g:Q@ A:SnpPLKm:hi|?]zOwIa";n56W']
    ];

    const badSTList = const <List<String>>[
      const <String>['\b'], //	Backspace
    ];

    test('ST hasValidValues good values', () {
      for (var s in goodSTList) {
        system.throwOnError = false;
        final st0 = new STtag(PTag.kMetaboliteMapDescription, s);
        expect(st0.hasValidValues, true);
      }
      system.throwOnError = false;
      final st0 = new STtag(PTag.kCADFileFormat, []);
      expect(st0.hasValidValues, true);
      expect(st0.values, equals(<String>[]));
    });

    test('ST hasValidValues bad values', () {
      for (var s in badSTList) {
        system.throwOnError = false;
        final st0 = new STtag(PTag.kMetaboliteMapDescription, s);
        expect(st0, isNull);

        system.throwOnError = true;
        expect(() => new STtag(PTag.kMetaboliteMapDescription, s),
            throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
      }

      system.throwOnError = false;
      final st1 = new STtag(PTag.kCADFileFormat, null);
      log.debug('st1: $st1');
      expect(st1, isNull);

      system.throwOnError = true;
      expect(() => new STtag(PTag.kMetaboliteMapDescription, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('ST hasValidValues random good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final st0 = new STtag(PTag.kMetaboliteMapDescription, vList0);
        expect(st0.hasValidValues, true);

        log
          ..debug('st0: $st0, values: ${st0.values}')
          ..debug('st0: ${st0.info}');
        expect(st0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final st1 = new STtag(PTag.kCADFileFormat, vList0);
        log.debug('st1:${st1.info}');
        expect(st1.hasValidValues, true);

        log
          ..debug('st1: $st1, values: ${st1.values}')
          ..debug('st1: ${st1.info}');
        expect(st1[0], equals(vList0[0]));
      }
    });

    test('ST hasValidValues random bad values', () {
      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(3, 4);
        log.debug('$i: vList0: $vList0');
        final sh2 = new STtag(PTag.kMetaboliteMapDescription, vList0);
        expect(sh2, isNull);
      }
    });

    test('ST update random', () {
      final st0 = new STtag(PTag.kCADFileFormat, []);
      expect(st0.update(['d^u:96P, azV']).values, equals(['d^u:96P, azV']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final st1 = new STtag(PTag.kCADFileFormat, vList0);
        final vList1 = rsg.getSTList(1, 1);
        expect(st1.update(vList1).values, equals(vList1));
      }
    });

    test('ST noValues random', () {
      final st0 = new STtag(PTag.kCADFileFormat, []);
      final STtag stNoValues = st0.noValues;
      expect(stNoValues.values.isEmpty, true);
      log.debug('st0: ${st0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final st0 = new STtag(PTag.kCADFileFormat, vList0);
        log.debug('st0: $st0');
        expect(stNoValues.values.isEmpty, true);
        log.debug('st0: ${st0.noValues}');
      }
    });

    test('ST copy random', () {
      final st0 = new STtag(PTag.kCADFileFormat, []);
      final STtag st1 = st0.copy;
      expect(st1 == st0, true);
      expect(st1.hashCode == st0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final sh2 = new STtag(PTag.kCADFileFormat, vList0);
        final STtag sh3 = sh2.copy;
        expect(sh3 == sh2, true);
        expect(sh3.hashCode == sh2.hashCode, true);
      }
    });

    test('ST hashCode and == good values random', () {
      List<String> stringList0;
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getSTList(1, 1);
        final st0 = new STtag(PTag.kSelectorSTValue, stringList0);
        final st1 = new STtag(PTag.kSelectorSTValue, stringList0);
        log
          ..debug('stringList0:$stringList0, st0.hash_code:${st0.hashCode}')
          ..debug('stringList0:$stringList0, st1.hash_code:${st1.hashCode}');
        expect(st0.hashCode == st1.hashCode, true);
        expect(st0 == st1, true);
      }
    });

    test('ST hashCode and == bad values random', () {
      List<String> stringList0;
      List<String> stringList1;
      List<String> stringList2;
      List<String> stringList3;
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getSTList(1, 1);
        final st0 = new STtag(PTag.kSelectorSTValue, stringList0);

        stringList1 = rsg.getSTList(1, 1);
        final st2 = new STtag(PTag.kTopicSubject, stringList1);
        log.debug('stringList1:$stringList1 , st2.hash_code:${st2.hashCode}');
        expect(st0.hashCode == st2.hashCode, false);
        expect(st0 == st2, false);

        stringList2 = rsg.getSTList(1, 10);
        final st3 = new STtag(PTag.kComponentManufacturer, stringList2);
        log.debug('stringList2:$stringList2 , st3.hash_code:${st3.hashCode}');
        expect(st0.hashCode == st3.hashCode, false);
        expect(st0 == st3, false);

        stringList3 = rsg.getSTList(2, 3);
        final st4 = new STtag(PTag.kSelectorSTValue, stringList3);
        log.debug('stringList3:$stringList3 , st4.hash_code:${st4.hashCode}');
        expect(st0.hashCode == st4.hashCode, false);
        expect(st0 == st4, false);
      }
    });

    test('ST valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final st0 = new STtag(PTag.kSelectorSTValue, vList0);
        expect(vList0, equals(st0.valuesCopy));
      }
    });

    test('ST isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final st0 = new STtag(PTag.kSelectorSTValue, vList0);
        expect(st0.tag.isValidLength(st0.length), true);
      }
    });

    test('ST isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final st0 = new STtag(PTag.kSelectorSTValue, vList0);

        expect(st0.tag.isValidValues(st0.values), true);
        expect(st0.hasValidValues, true);
      }
    });

    test('ST replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final st0 = new STtag(PTag.kSelectorSTValue, vList0);
        final vList1 = rsg.getSTList(1, 1);
        expect(st0.replace(vList1), equals(vList0));
        expect(st0.values, equals(vList1));
      }

      final vList1 = rsg.getSTList(1, 1);
      final st1 = new STtag(PTag.kSelectorSTValue, vList1);
      expect(st1.replace([]), equals(vList1));
      expect(st1.values, equals(<String>[]));

      final st2 = new STtag(PTag.kSelectorSTValue, vList1);
      expect(st2.replace(null), equals(vList1));
      expect(st2.values, equals(<String>[]));
    });

    test('ST blank random', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getSTList(1, 1);
        final st0 = new STtag(PTag.kSelectorSTValue, vList1);
        for (var i = 1; i < 10; i++) {
          final blank = st0.blank(i);
          log.debug(('blank$i: ${blank.values}'));
          expect(blank.values.length == 1, true);
          expect(blank.value.length == i, true);
          final strSpaceList = <String>[''.padRight(i, ' ')];
          log.debug('strSpaceList: $strSpaceList');
          expect(blank.values, equals(strSpaceList));
        }
      }
    });

    test('ST formBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getSTList(1, 1);
        final bytes = ST.toBytes(vList1);
        log.debug('bytes:$bytes');
        final st0 = new STtag.fromBytes(PTag.kSelectorSTValue, bytes);
        log.debug('st0: ${st0.info}');
        expect(st0.hasValidValues, true);
      }
    });

    test('ST checkLength good values', () {
      final vList0 = rsg.getSTList(1, 1);
      final sh0 = new STtag(PTag.kSelectorSTValue, vList0);
      for (var s in goodSTList) {
        expect(sh0.checkLength(s), true);
      }
      final sh1 = new STtag(PTag.kSelectorSTValue, vList0);
      expect(sh1.checkLength([]), true);

      final vList1 = rsg.getSTList(1, 1);
      final sh2 = new STtag(PTag.kCADFileFormat, vList1);
      for (var s in goodSTList) {
        expect(sh2.checkLength(s), true);
      }
    });

    test('ST checkLength bad values', () {
      final vList2 = ['a^1sd', '02@#'];
      final sh3 = new STtag(PTag.kSelectorSTValue, vList2);
      expect(sh3, isNull);
    });

    test('ST checkValue good values', () {
      final vList0 = rsg.getSTList(1, 1);
      final st0 = new STtag(PTag.kSelectorSTValue, vList0);
      for (var s in goodSTList) {
        for (var a in s) {
          expect(st0.checkValue(a), true);
        }
      }
    });

    test('ST checkValue bad values', () {
      final vList0 = rsg.getSTList(1, 1);
      final st0 = new STtag(PTag.kSelectorSTValue, vList0);
      for (var s in badSTList) {
        for (var a in s) {
          system.throwOnError = false;
          expect(st0.checkValue(a), false);

          system.throwOnError = true;
          expect(() => st0.checkValue(a),
              throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
        }
      }
    });
  });

  group('ST', () {
    const goodSTList = const <List<String>>[
      const <String>['\t '], //horizontal tab (HT)
      const <String>['\n'], //linefeed (LF)
      const <String>['\f '], // form feed (FF)
      const <String>['\r '], //carriage return (CR)
      const <String>['(s!WGR3D:2hhWF|,'],
      const <String>['6g:Q@ A:SnpPLKm:hi|?]zOwIa";n56W']
    ];

    const badSTList = const <List<String>>[
      const <String>['\b'], //	Backspace
    ];

    //VM.k1
    const stTags0 = const <PTag>[
      PTag.kInstitutionAddress,
      PTag.kReferringPhysicianAddress,
      PTag.kCodingSchemeExternalID,
      PTag.kCodingSchemeName,
      PTag.kCodingSchemeResponsibleOrganization,
      PTag.kDerivationDescription,
      PTag.kAnatomicPerspectiveDescriptionTrial,
      PTag.kCADFileFormat,
      PTag.kComponentReferenceSystem,
      PTag.kComponentManufacturingProcedure,
      PTag.kComponentManufacturer,
      PTag.kIndicationDescription,
      PTag.kCouplingTechnique,
      PTag.kCouplingMedium,
      PTag.kScanProcedure,
      PTag.kContributionDescription,
      PTag.kPartialViewDescription,
      PTag.kMaskOperationExplanation,
      PTag.kCommentsOnRadiationDose,
      PTag.kAddressTrial,
      PTag.kSegmentDescription,
      PTag.kSelectorSTValue,
      PTag.kTopicSubject
    ];

    const otherTags = const <PTag>[
      PTag.kColumnAngulationPatient,
      PTag.kAcquisitionProtocolDescription,
      PTag.kCTDIvol,
      PTag.kCTPositionSequence,
      PTag.kAcquisitionType,
      PTag.kPerformedStationAETitle,
      PTag.kStudyID,
      PTag.kDate,
      PTag.kTime
    ];

    final invalidVList = rsg.getSTList(ST.kMaxLength + 1, ST.kMaxLength + 1);

    test('ST checkVR good values', () {
      system.throwOnError = false;
      expect(ST.checkVRIndex(kSTIndex), kSTIndex);

      for (var tag in stTags0) {
        system.throwOnError = false;
        expect(ST.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('ST checkVR bad values', () {
      system.throwOnError = false;
      expect(
          ST.checkVRIndex(
            kAEIndex,
          ),
          isNull);
      system.throwOnError = true;
      expect(() => ST.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(ST.checkVRIndex(tag.vrIndex), isNull);

        system.throwOnError = true;
        expect(() => ST.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('ST isValidVRIndex good values', () {
      system.throwOnError = false;
      expect(ST.isValidVRIndex(kSTIndex), true);

      for (var tag in stTags0) {
        system.throwOnError = false;
        expect(ST.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('ST isValidVRIndex bad values', () {
      system.throwOnError = false;
      expect(ST.isValidVRIndex(kCSIndex), false);

      system.throwOnError = true;
      expect(() => ST.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(ST.isValidVRIndex(tag.vrIndex), false);

        system.throwOnError = true;
        expect(() => ST.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('ST isValidVRCode good values', () {
      system.throwOnError = false;
      expect(ST.isValidVRCode(kSTCode), true);

      for (var tag in stTags0) {
        expect(ST.isValidVRCode(tag.vrCode), true);
      }
    });

    test('ST isValidVRCode bad values', () {
      system.throwOnError = false;
      expect(ST.isValidVRCode(kAECode), false);

      system.throwOnError = true;
      expect(() => ST.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(ST.isValidVRCode(tag.vrCode), false);

        system.throwOnError = true;
        expect(() => ST.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('ST isValidVFLength good values', () {
      expect(ST.isValidVFLength(ST.kMaxVFLength), true);
      expect(ST.isValidVFLength(0), true);
    });

    test('ST isValidVFLength bad values', () {
      expect(ST.isValidVFLength(ST.kMaxVFLength + 1), false);
      expect(ST.isValidVFLength(-1), false);
    });

    test('ST isNotValidVFLength good values', () {
      expect(ST.isNotValidVFLength(ST.kMaxVFLength), false);
      expect(ST.isNotValidVFLength(0), false);
    });

    test('ST isNotValidVFLength bad values', () {
      expect(ST.isNotValidVFLength(ST.kMaxVFLength + 1), true);
      expect(ST.isNotValidVFLength(-1), true);
    });

    test('ST isValidValueLength good values', () {
      for (var s in goodSTList) {
        for (var a in s) {
          expect(ST.isValidValueLength(a), true);
        }
      }

      expect(ST.isValidValueLength('a'), true);
    });

    // Urgent: changed to true
    test('ST isValidValueLength bad values', () {
      expect(ST.isValidValueLength(''), true);
    });

    test('ST isNotValidValueLength good values', () {
      for (var s in goodSTList) {
        for (var a in s) {
          expect(ST.isNotValidValueLength(a), false);
        }
      }
    });

    // Urgent: changed to true
    test('ST isNotValidValueLength bad values', () {
      expect(ST.isNotValidValueLength(''), false);
    });

    test('ST isValidVListLength VM.k1 good values', () {
      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getSTList(1, 1);
        for (var tag in stTags0) {
          expect(ST.isValidVListLength(tag, validMinVList), true);

          expect(
              ST.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              ST.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('ST isValidVListLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rsg.getSTList(2, i + 1);
        for (var tag in stTags0) {
          system.throwOnError = false;
          expect(ST.isValidVListLength(tag, validMinVList), false);

          expect(ST.isValidVListLength(tag, invalidVList), false);

          system.throwOnError = true;
          expect(() => ST.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesLengthError>()));
        }
      }
    });

    test('ST isValidValue good values', () {
      for (var s in goodSTList) {
        for (var a in s) {
          expect(ST.isValidValue(a), true);
        }
      }
    });

    test('ST isValidValue bad values', () {
      for (var s in badSTList) {
        for (var a in s) {
          system.throwOnError = false;
          expect(ST.isValidValue(a), false);

          system.throwOnError = true;
          expect(() => ST.isValidValue(a),
              throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
        }
      }
    });

    test('ST isValidValues good values', () {
      system.throwOnError = false;
      for (var s in goodSTList) {
        expect(ST.isValidValues(PTag.kInstitutionAddress, s), true);
      }
    });

    test('ST isValidValues bad values', () {
      for (var s in badSTList) {
        system.throwOnError = false;
        expect(ST.isValidValues(PTag.kInstitutionAddress, s), false);

        system.throwOnError = true;
        expect(() => ST.isValidValues(PTag.kInstitutionAddress, s),
            throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
      }
    });

    test('ST fromBytes', () {
      //  system.level = Level.debug;;
      final vList1 = rsg.getSTList(1, 1);
      final bytes = ST.toBytes(vList1);
      log.debug('ST.fromBytes(bytes): ${ST.fromBytes(bytes)}, bytes: $bytes');
      expect(ST.fromBytes(bytes), equals(vList1));
    });

    test('ST toBytes', () {
      final vList1 = rsg.getSTList(1, 1);
      log.debug('ST.toBytes(vList1): ${ST.toBytes(vList1)}');
      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = ASCII.encode(vList1[0]);
      expect(ST.toBytes(vList1), equals(values));
    });

/*
    test('ST fromBase64', () {
      final vList1 = rsg.getSTList(1, 1);
      system.throwOnError = false;
      final v0 = ST.fromBase64(vList1);
      expect(v0, isNotNull);

      final v1 = ST.fromBase64(['PIA5']);
      expect(v1, isNotNull);

      final v2 = ST.fromBase64(['PIA']);
      expect(v2, isNotNull);
    });

    test('ST toBase64', () {
      final vList0 = rsg.getSTList(1, 1);
      expect(ST.toBase64(vList0), equals(vList0));

      final vList1 = ['dslkj'];
      expect(ST.toBase64(vList1), equals(vList1));
    });
*/

  });

  group('UCtag', () {
    const goodUCList = const <List<String>>[
      const <String>['2qVmo1AAD'],
      const <String>['erty#4u'],
      const <String>['2qVmo1AAD'],
      const <String>['q.&*k']
    ];
    const badUCList = const <List<String>>[
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
    test('UC hasValidValues good values', () {
      for (var s in goodUCList) {
        system.throwOnError = false;
        final uc0 = new UCtag(PTag.kStrainDescription, s);
        expect(uc0.hasValidValues, true);
      }

      system.throwOnError = false;
      final uc0 = new UCtag(PTag.kGeneticModificationsDescription, []);
      expect(uc0.hasValidValues, true);
      expect(uc0.values, equals(<String>[]));
    });

    test('UC hasValidValues bad values', () {
      for (var s in badUCList) {
        system.throwOnError = false;
        final uc0 = new UCtag(PTag.kStrainDescription, s);
        expect(uc0, isNull);

        system.throwOnError = true;
        expect(() => new UCtag(PTag.kStrainDescription, s),
            throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
      }
      system.throwOnError = false;
      final uc1 = new UCtag(PTag.kGeneticModificationsDescription, null);
      log.debug('uc1: $uc1');
      expect(uc1, isNull);

      system.throwOnError = true;
      expect(() => new UCtag(PTag.kStrainDescription, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('UC hasValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        final uc0 = new UCtag(PTag.kStrainDescription, vList0);
        expect(uc0.hasValidValues, true);

        log
          ..debug('uc0: $uc0, values: ${uc0.values}')
          ..debug('uc0: ${uc0.info}');
        expect(uc0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(3, 4);
        log.debug('$i: vList0: $vList0');

        system.throwOnError = false;
        final uc1 = new UCtag(PTag.kGeneticModificationsDescription, vList0);
        expect(uc1, isNull);
        system.throwOnError = true;
        expect(() => new UCtag(PTag.kGeneticModificationsDescription, vList0),
            throwsA(const isInstanceOf<InvalidValuesLengthError>()));
      }
    });

    test('UC update random', () {
      final uc0 = new UCtag(PTag.kGeneticModificationsDescription, []);
      expect(uc0.update(['d^u:96P, azV']).values, equals(['d^u:96P, azV']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(3, 4);
        system.throwOnError = false;
        final uc1 = new UCtag(PTag.kGeneticModificationsDescription, vList0);
        expect(uc1, isNull);
        final vList1 = rsg.getUCList(3, 4);
//        expect(uc1.update(vList1).values, equals(vList1));
        expect(() => uc1.update(vList1).values,
            throwsA(const isInstanceOf<NoSuchMethodError>()));
        system.throwOnError = true;
        expect(() => new UCtag(PTag.kGeneticModificationsDescription, vList0),
            throwsA(const isInstanceOf<InvalidValuesLengthError>()));
      }
    });

    test('UC noValues random', () {
      final uc0 = new UCtag(PTag.kGeneticModificationsDescription, []);
      final UCtag ucNoValues = uc0.noValues;
      expect(ucNoValues.values.isEmpty, true);
      log.debug('st0: ${uc0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        system.throwOnError = false;
        final uc1 = new UCtag(PTag.kGeneticModificationsDescription, vList0);
        final UCtag ucNoValues1 = uc1.noValues;
        expect(ucNoValues1.values.isEmpty, true);

        final vList1 = rsg.getUCList(2, 4);
        system.throwOnError = false;
        final uc2 = new UCtag(PTag.kGeneticModificationsDescription, vList1);
        expect(uc2, isNull);
        system.throwOnError = true;
        expect(() => new UCtag(PTag.kGeneticModificationsDescription, vList1),
            throwsA(const isInstanceOf<InvalidValuesLengthError>()));
      }
    });

    test('UC copy random', () {
      final uc0 = new UCtag(PTag.kGeneticModificationsDescription, []);
      final UCtag uc1 = uc0.copy;
      expect(uc1 == uc0, true);
      expect(uc1.hashCode == uc0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(3, 4);
        system.throwOnError = false;
        final uc2 = new UCtag(PTag.kGeneticModificationsDescription, vList0);
        expect(uc2, isNull);
        expect(() => uc1.update(vList0).values,
            throwsA(const isInstanceOf<NoSuchMethodError>()));
        expect(
            () => uc2.copy, throwsA(const isInstanceOf<NoSuchMethodError>()));

        system.throwOnError = true;
        expect(() => new UCtag(PTag.kGeneticModificationsDescription, vList0),
            throwsA(const isInstanceOf<InvalidValuesLengthError>()));
      }
    });

    test('UC hashCode and == good values random', () {
      List<String> stringList0;
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getUCList(1, 1);
        final uc0 =
            new UCtag(PTag.kGeneticModificationsDescription, stringList0);
        final uc1 =
            new UCtag(PTag.kGeneticModificationsDescription, stringList0);
        log
          ..debug('stringList0:$stringList0, uc0.hash_code:${uc0.hashCode}')
          ..debug('stringList0:$stringList0, uc1.hash_code:${uc1.hashCode}');
        expect(uc0.hashCode == uc1.hashCode, true);
        expect(uc0 == uc1, true);
      }
    });

    test('UC hashCode and == bad values random', () {
      system.throwOnError = false;
      List<String> stringList0;
      List<String> stringList1;
      List<String> stringList2;

      log.debug('UC hashCode and == ');
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getUCList(1, 1);
        final uc0 =
            new UCtag(PTag.kGeneticModificationsDescription, stringList0);
        final uc1 = stringList1 = rsg.getUCList(1, 1);
        final uc2 = new UCtag(PTag.kStrainDescription, stringList1);
        log.debug('stringList1:$stringList1 , uc2.hash_code:${uc2.hashCode}');
        expect(uc0.hashCode == uc2.hashCode, false);
        expect(uc0 == uc2, false);

        stringList2 = rsg.getUCList(2, 3);
        final uc3 = new UCtag(PTag.kStrainDescription, stringList2);
        log.debug('stringList2:$stringList2 , uc3.hash_code:${uc3.hashCode}');
        expect(uc1.hashCode == uc3.hashCode, false);
        expect(uc1 == uc3, false);
      }
    });

    test('UC valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        final uc0 = new UCtag(PTag.kStrainDescription, vList0);
        expect(vList0, equals(uc0.valuesCopy));
      }
    });

    test('UC isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        final uc0 = new UCtag(PTag.kStrainDescription, vList0);
        expect(uc0.tag.isValidLength(uc0.length), true);
      }
    });

    test('UC isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        final uc0 = new UCtag(PTag.kStrainDescription, vList0);
        expect(uc0.tag.isValidValues(uc0.values), true);
        expect(uc0.hasValidValues, true);
      }
    });

    test('UC replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        final uc0 = new UCtag(PTag.kStrainDescription, vList0);
        final vList1 = rsg.getUCList(1, 1);
        expect(uc0.replace(vList1), equals(vList0));
        expect(uc0.values, equals(vList1));
      }

      final vList1 = rsg.getUCList(1, 1);
      final uc1 = new UCtag(PTag.kStrainDescription, vList1);
      expect(uc1.replace([]), equals(vList1));
      expect(uc1.values, equals(<String>[]));

      final uc2 = new UCtag(PTag.kStrainDescription, vList1);
      expect(uc2.replace(null), equals(vList1));
      expect(uc2.values, equals(<String>[]));
    });

    test('UC blank random', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getUCList(1, 1);
        final uc0 = new UCtag(PTag.kStrainDescription, vList1);
        for (var i = 1; i < 10; i++) {
          final blank = uc0.blank(i);
          log.debug(('blank$i: ${blank.values}'));
          expect(blank.values.length == 1, true);
          expect(blank.value.length == i, true);
          final strSpaceList = <String>[''.padRight(i, ' ')];
          log.debug('strSpaceList: $strSpaceList');
          expect(blank.values, equals(strSpaceList));
        }
      }
    });

    test('UC formBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getUCList(1, 1);
        final bytes = UC.toBytes(vList1);
        log.debug('bytes:$bytes');
        final uc0 = new UCtag.fromBytes(PTag.kStrainDescription, bytes);
        log.debug('uc0: ${uc0.info}');
        expect(uc0.hasValidValues, true);
      }
    });

    test('UC checkLength good values', () {
      final vList0 = rsg.getUCList(1, 1);
      final uc0 = new UCtag(PTag.kStrainDescription, vList0);
      for (var s in goodUCList) {
        expect(uc0.checkLength(s), true);
      }
      final uc1 = new UCtag(PTag.kStrainDescription, vList0);
      expect(uc1.checkLength([]), true);
    });

    test('UC checkLength bad values', () {
      final vList1 = ['a^1sd', '02@#'];
      system.throwOnError = false;
      final uc2 = new UCtag(PTag.kStrainDescription, vList1);
      expect(uc2, isNull);
      expect(() => uc2.checkLength(vList1),
          throwsA(const isInstanceOf<NoSuchMethodError>()));
    });

    test('UC checkValue good values', () {
      final vList0 = rsg.getUCList(1, 1);
      final uc0 = new UCtag(PTag.kStrainDescription, vList0);
      for (var s in goodUCList) {
        for (var a in s) {
          expect(uc0.checkValue(a), true);
        }
      }
    });

    test('UC checkValue bad values', () {
      final vList0 = rsg.getUCList(1, 1);
      final uc0 = new UCtag(PTag.kStrainDescription, vList0);
      for (var s in badUCList) {
        for (var a in s) {
          system.throwOnError = false;
          expect(uc0.checkValue(a), false);

          system.throwOnError = true;
          expect(() => uc0.checkValue(a),
              throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
        }
      }
    });
  });

  group('UC Element', () {
    const goodUCList = const <List<String>>[
      const <String>['2qVmo1AAD'],
      const <String>['erty#4u'],
      const <String>['2qVmo1AAD'],
      const <String>['q.&*k']
    ];
    const badUCList = const <List<String>>[
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

    //VM.k1
    const ucTags0 = const <PTag>[
      PTag.kStrainDescription,
      PTag.kGeneticModificationsDescription,
    ];

    //VM.k1_n
    const ucTags1 = const <PTag>[
      PTag.kSelectorUCValue,
    ];

    const otherTags = const <PTag>[
      PTag.kColumnAngulationPatient,
      PTag.kAcquisitionProtocolDescription,
      PTag.kCTDIvol,
      PTag.kCTPositionSequence,
      PTag.kAcquisitionType,
      PTag.kPerformedStationAETitle,
      PTag.kStudyID,
      PTag.kDate,
      PTag.kTime,
      PTag.kAddressTrial
    ];

    final invalidVList = rsg.getUCList(5000, 5000);

    test('UC checkVR good values', () {
      system.throwOnError = false;
      expect(UC.checkVRIndex(kUCIndex), kUCIndex);

      for (var tag in ucTags0) {
        system.throwOnError = false;
        expect(UC.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('UC checkVR bad values', () {
      system.throwOnError = false;
      expect(
          UC.checkVRIndex(
            kAEIndex,
          ),
          isNull);
      system.throwOnError = true;
      expect(() => UC.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(UC.checkVRIndex(tag.vrIndex), isNull);

        system.throwOnError = true;
        expect(() => UC.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UC isValidVRIndex good values', () {
      system.throwOnError = false;
      expect(UC.isValidVRIndex(kUCIndex), true);

      for (var tag in ucTags0) {
        system.throwOnError = false;
        expect(UC.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('UC isValidVRIndex bad values', () {
      system.throwOnError = false;
      expect(UC.isValidVRIndex(kCSIndex), false);

      system.throwOnError = true;
      expect(() => UC.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(UC.isValidVRIndex(tag.vrIndex), false);

        system.throwOnError = true;
        expect(() => UC.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UC isValidVRCode good values', () {
      system.throwOnError = false;
      expect(UC.isValidVRCode(kUCCode), true);

      for (var tag in ucTags0) {
        expect(UC.isValidVRCode(tag.vrCode), true);
      }
    });

    test('UC isValidVRCode bad values', () {
      system.throwOnError = false;
      expect(UC.isValidVRCode(kAECode), false);

      system.throwOnError = true;
      expect(() => UC.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(UC.isValidVRCode(tag.vrCode), false);

        system.throwOnError = true;
        expect(() => UC.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UC isValidVFLength good values', () {
      expect(UC.isValidVFLength(UC.kMaxVFLength), true);
      expect(UC.isValidVFLength(0), true);
    });

    test('UC isValidVFLength bad values', () {
      expect(UC.isValidVFLength(UC.kMaxVFLength + 1), false);
      expect(UC.isValidVFLength(-1), false);
    });

    test('UC isNotValidVFLength good values', () {
      expect(UC.isNotValidVFLength(UC.kMaxVFLength), false);
      expect(UC.isNotValidVFLength(0), false);
    });

    test('UC isNotValidVFLength bad values', () {
      expect(UC.isNotValidVFLength(UC.kMaxVFLength + 1), true);
      expect(UC.isNotValidVFLength(-1), true);
    });

    test('UC isValidValueLength good values', () {
      for (var s in goodUCList) {
        for (var a in s) {
          expect(UC.isValidValueLength(a), true);
        }
      }

      expect(UC.isValidValueLength('a'), true);
    });

    test('UC isValidValueLength bad values', () {
      expect(UC.isValidValueLength(''), false);
    });

    test('UC isNotValidValueLength good values', () {
      for (var s in goodUCList) {
        for (var a in s) {
          expect(UC.isNotValidValueLength(a), false);
        }
      }
    });

    test('UC isNotValidValueLength bad values', () {
      expect(UC.isNotValidValueLength(''), true);
    });

    test('UC isValidVListLength VM.k1 good values', () {
      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getUCList(1, 1);
        for (var tag in ucTags0) {
          expect(UC.isValidVListLength(tag, validMinVList), true);

          expect(
              UC.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              UC.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('UC isValidVListLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rsg.getUCList(2, i + 1);
        for (var tag in ucTags0) {
          system.throwOnError = false;
          expect(UC.isValidVListLength(tag, validMinVList), false);

          expect(UC.isValidVListLength(tag, invalidVList), false);

          system.throwOnError = true;
          expect(() => UC.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesLengthError>()));
        }
      }
    });

    test('UC isValidVListLength VM.k1_n good values', () {
      system.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final validMinVList0 = rsg.getUCList(1, i);
        for (var tag in ucTags1) {
          log.debug('tag: $tag');
          expect(UC.isValidVListLength(tag, validMinVList0), true);
        }
      }
    });

    test('UC isValidValue good values', () {
      for (var s in goodUCList) {
        for (var a in s) {
          expect(UC.isValidValue(a), true);
        }
      }
    });

    test('UC isValidValue bad values', () {
      for (var s in badUCList) {
        for (var a in s) {
          system.throwOnError = false;
          expect(UC.isValidValue(a), false);

          system.throwOnError = true;
          expect(() => UC.isValidValue(a),
              throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
        }
      }
    });

    test('UC isValidValues good values', () {
      system.throwOnError = false;
      for (var s in goodUCList) {
        expect(UC.isValidValues(PTag.kStrainDescription, s), true);
      }
    });

    test('UC isValidValues bad values', () {
      for (var s in badUCList) {
        system.throwOnError = false;
        expect(UC.isValidValues(PTag.kStrainDescription, s), false);

        system.throwOnError = true;
        expect(() => UC.isValidValues(PTag.kStrainDescription, s),
            throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
      }
    });

    test('UC fromBytes', () {
      //     system.level = Level.debug;
      final vList1 = rsg.getUCList(1, 1);
      final bytes = UC.toBytes(vList1);
      log.debug('UC.fromBytes(bytes): ${UC.fromBytes(bytes)}, bytes: $bytes');
      expect(UC.fromBytes(bytes), equals(vList1));
    });

    test('UC toBytes', () {
      final vList1 = rsg.getUCList(1, 1);
      log.debug('UC.toBytes(vList1): ${UC.toBytes(vList1)}');

      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = ASCII.encode(vList1[0]);
      expect(UC.toBytes(vList1), equals(values));
    });

/*    test('UC fromBase64', () {
      final vList1 = rsg.getUCList(1, 1);
      //final values = ASCII.encode(vList1[0]);
      system.throwOnError = false;
      final v0 = UC.fromBase64(vList1);
      expect(v0, isNotNull);

      final v1 = UC.fromBase64(['PIA5']);
      expect(v1, isNotNull);

      final v2 = UC.fromBase64(['PIA']);
      expect(v2, isNotNull);
    });

    test('UC toBase64', () {
      final vList0 = rsg.getUCList(1, 1);
      expect(UC.toBase64(vList0), equals(vList0));

      final vList1 = ['dslkj'];
      //final s0 = ASCII.encode(vList0[0]);
      expect(UC.toBase64(vList1), equals(vList1));
    });
  */
    test('UC checkList good values', () {
      system.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList = rsg.getUCList(1, 1);
        expect(UC.checkList(PTag.kStrainDescription, vList), vList);
      }

      final vList0 = ['!mSMXWVy`]/Du'];
      expect(UC.checkList(PTag.kStrainDescription, vList0), vList0);

      for (var s in goodUCList) {
        system.throwOnError = false;
        expect(UC.checkList(PTag.kStrainDescription, s), s);
      }
    });

    test('UC checkList bad values', () {
      system.throwOnError = false;
      final vList1 = ['\b'];
      expect(UC.checkList(PTag.kStrainDescription, vList1), isNull);

      system.throwOnError = true;
      expect(() => UC.checkList(PTag.kStrainDescription, vList1),
          throwsA(const isInstanceOf<InvalidCharacterInStringError>()));

      for (var s in badUCList) {
        system.throwOnError = false;
        expect(UC.checkList(PTag.kStrainDescription, s), isNull);

        system.throwOnError = true;
        expect(() => UC.checkList(PTag.kStrainDescription, s),
            throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
      }
    });
  });

  group('UTtag', () {
    const goodUTList = const <List<String>>[
      const <String>['\t '], //horizontal tab (HT)
      const <String>['\n'], //linefeed (LF)
      const <String>['\f '], // form feed (FF)
      const <String>['\r '], //carriage return (CR)
      const <String>['<BJ'],
      const <String>['UOC'],
      const <String>['D\B']
    ];
    const badUTList = const <List<String>>[
      const <String>['\b'], //	Backspace
    ];
    test('UT hasValidValues good values', () {
      for (var s in goodUTList) {
        system.throwOnError = false;
        final ut0 = new UTtag(PTag.kUniversalEntityID, s);
        expect(ut0.hasValidValues, true);
      }

      // empty list
      final ut0 = new UTtag(PTag.kLocalNamespaceEntityID, []);
      expect(ut0.hasValidValues, true);
      expect(ut0.values, equals(<String>[]));
    });

    test('UT hasValidValues bad values', () {
      for (var s in badUTList) {
        system.throwOnError = false;
        final ut0 = new UTtag(PTag.kUniversalEntityID, s);
        expect(ut0, isNull);

        system.throwOnError = true;
        expect(() => new UTtag(PTag.kUniversalEntityID, s),
            throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
      }

      system.throwOnError = false;
      final ut1 = new UTtag(PTag.kLocalNamespaceEntityID, null);
      log.debug('ut1: $ut1');
      expect(ut1, isNull);

      system.throwOnError = true;
      expect(() => new UTtag(PTag.kLocalNamespaceEntityID, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('UT hasValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        final ut0 = new UTtag(PTag.kUniversalEntityID, vList0);
        expect(ut0.hasValidValues, true);

        log
          ..debug('ut0: $ut0, values: ${ut0.values}')
          ..debug('ut0: ${ut0.info}');
        expect(ut0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        log.debug('$i: vList0: $vList0');
        final ut1 = new UTtag(PTag.kUniversalEntityID, vList0);
        expect(ut1.hasValidValues, true);
      }
    });

    test('UT update random', () {
      final ut0 = new UTtag(PTag.kLocalNamespaceEntityID, []);
      expect(ut0.update(['d^u:96P, azV']).values, equals(['d^u:96P, azV']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        final ut1 = new UTtag(PTag.kLocalNamespaceEntityID, vList0);
        final vList1 = rsg.getUTList(1, 1);
        expect(ut1.update(vList1).values, equals(vList1));
      }
    });

    test('UT noValues random', () {
      final ut0 = new UTtag(PTag.kLocalNamespaceEntityID, []);
      final UTtag utNoValues = ut0.noValues;
      expect(utNoValues.values.isEmpty, true);
      log.debug('st0: ${ut0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        final ut0 = new UTtag(PTag.kLocalNamespaceEntityID, vList0);
        log.debug('ut0: $ut0');
        expect(utNoValues.values.isEmpty, true);
        log.debug('ut0: ${ut0.noValues}');
      }
    });

    test('UT copy random', () {
      final ut0 = new UTtag(PTag.kLocalNamespaceEntityID, []);
      final UTtag ut1 = ut0.copy;
      expect(ut1 == ut0, true);
      expect(ut1.hashCode == ut0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        final ut2 = new UTtag(PTag.kLocalNamespaceEntityID, vList0);
        final UTtag ut3 = ut2.copy;
        expect(ut3 == ut2, true);
        expect(ut3.hashCode == ut2.hashCode, true);
      }
    });

    test('UT hashCode and == good values random', () {
      List<String> stringList0;

      log.debug('UT hashCode and == ');
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getUTList(1, 1);
        final ut0 = new UTtag(PTag.kLocalNamespaceEntityID, stringList0);
        final ut1 = new UTtag(PTag.kLocalNamespaceEntityID, stringList0);
        log
          ..debug('stringList0:$stringList0, ut0.hash_code:${ut0.hashCode}')
          ..debug('stringList0:$stringList0, ut1.hash_code:${ut1.hashCode}');
        expect(ut0.hashCode == ut1.hashCode, true);
        expect(ut0 == ut1, true);
      }
    });

    test('UT hashCode and == bad values random', () {
      List<String> stringList0;
      List<String> stringList1;
      List<String> stringList2;

      log.debug('UT hashCode and == ');
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getUTList(1, 1);
        final ut0 = new UTtag(PTag.kLocalNamespaceEntityID, stringList0);

        stringList1 = rsg.getUTList(1, 1);
        final ut2 = new UTtag(PTag.kUniversalEntityID, stringList1);
        log.debug('stringList1:$stringList1 , ut2.hash_code:${ut2.hashCode}');
        expect(ut0.hashCode == ut2.hashCode, false);
        expect(ut0 == ut2, false);

        stringList2 = rsg.getUTList(1, 1);
        final ut3 = new UTtag(PTag.kLocalNamespaceEntityID, stringList2);
        log.debug('stringList2:$stringList2 , ut3.hash_code:${ut3.hashCode}');
        expect(ut0.hashCode == ut3.hashCode, false);
        expect(ut0 == ut3, false);
      }
    });

    test('UT valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        final ut0 = new UTtag(PTag.kUniversalEntityID, vList0);
        expect(vList0, equals(ut0.valuesCopy));
      }
    });

    test('UT isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        final ut0 = new UTtag(PTag.kUniversalEntityID, vList0);
        expect(ut0.tag.isValidLength(ut0.length), true);
      }
    });

    test('UT isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        final ut0 = new UTtag(PTag.kUniversalEntityID, vList0);

        expect(ut0.tag.isValidValues(ut0.values), true);
        expect(ut0.hasValidValues, true);
      }
    });

    test('UT replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        final ut0 = new UTtag(PTag.kUniversalEntityID, vList0);
        final vList1 = rsg.getUTList(1, 1);
        expect(ut0.replace(vList1), equals(vList0));
        expect(ut0.values, equals(vList1));
      }

      final vList1 = rsg.getUTList(1, 1);
      final ut1 = new UTtag(PTag.kUniversalEntityID, vList1);
      expect(ut1.replace([]), equals(vList1));
      expect(ut1.values, equals(<String>[]));

      final ut2 = new UTtag(PTag.kUniversalEntityID, vList1);
      expect(ut2.replace(null), equals(vList1));
      expect(ut2.values, equals(<String>[]));
    });

    test('UT blank random', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getUTList(1, 1);
        final ut0 = new UTtag(PTag.kUniversalEntityID, vList1);
        for (var i = 1; i < 10; i++) {
          final blank = ut0.blank(i);
          log.debug(('blank$i: ${blank.values}'));
          expect(blank.values.length == 1, true);
          expect(blank.value.length == i, true);
          final strSpaceList = <String>[''.padRight(i, ' ')];
          log.debug('strSpaceList: $strSpaceList');
          expect(blank.values, equals(strSpaceList));
        }
      }
    });

    test('UT formBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getUTList(1, 1);
        final bytes = UT.toBytes(vList1);
        log.debug('bytes:$bytes');
        final ut0 = new UTtag.fromBytes(PTag.kUniversalEntityID, bytes);
        log.debug('ut0: ${ut0.info}');
        expect(ut0.hasValidValues, true);
      }
    });

    test('UT checkLength good values', () {
      final vList0 = rsg.getUTList(1, 1);
      final ut0 = new UTtag(PTag.kUniversalEntityID, vList0);
      for (var s in goodUTList) {
        expect(ut0.checkLength(s), true);
      }
      final ut1 = new UTtag(PTag.kUniversalEntityID, vList0);
      expect(ut1.checkLength([]), true);
    });

    test('UT checkLength bad values', () {
      final vList1 = ['a^1sd', '02@#'];
      system.throwOnError = false;
      final ut2 = new UTtag(PTag.kUniversalEntityID, vList1);
      expect(ut2, isNull);

      system.throwOnError = true;
      expect(() => new UTtag(PTag.kUniversalEntityID, vList1),
          throwsA(const isInstanceOf<InvalidValuesLength>()));
    });

    test('UT checkValue good values', () {
      final vList0 = rsg.getUTList(1, 1);
      final ut0 = new UTtag(PTag.kUniversalEntityID, vList0);
      for (var s in goodUTList) {
        for (var a in s) {
          expect(ut0.checkValue(a), true);
        }
      }
    });

    test('UT checkValue bad values', () {
      final vList0 = rsg.getUTList(1, 1);
      final ut0 = new UTtag(PTag.kUniversalEntityID, vList0);
      for (var s in badUTList) {
        for (var a in s) {
          system.throwOnError = false;
          expect(ut0.checkValue(a), false);

          system.throwOnError = true;
          expect(() => ut0.checkValue(a),
              throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
        }
      }
    });
  });

  group('UT', () {
    const goodUTList = const <List<String>>[
      const <String>['\t '], //horizontal tab (HT)
      const <String>['\n'], //linefeed (LF)
      const <String>['\f '], // form feed (FF)
      const <String>['\r '], //carriage return (CR)
      const <String>['<BJ'],
      const <String>['UOC'],
      const <String>['D\B']
    ];
    const badUTList = const <List<String>>[
      const <String>['\b'], //	Backspace
    ];

    //VM.k1
    const utTags0 = const <PTag>[
      PTag.kLabelText,
      PTag.kStrainAdditionalInformation,
      PTag.kLocalNamespaceEntityID,
      PTag.kSpecimenDetailedDescription,
      PTag.kUniversalEntityID,
      PTag.kTextValue,
      PTag.kTrackSetDescription,
      PTag.kSelectorUTValue,
    ];

    const otherTags = const <PTag>[
      PTag.kColumnAngulationPatient,
      PTag.kAcquisitionProtocolDescription,
      PTag.kCTDIvol,
      PTag.kCTPositionSequence,
      PTag.kAcquisitionType,
      PTag.kPerformedStationAETitle,
      PTag.kStudyID,
      PTag.kDate,
      PTag.kTime,
      PTag.kAddressTrial
    ];

    final invalidVList = rsg.getUTList(UT.kMaxLength + 1, UT.kMaxLength + 1);

    test('UT checkVR good values', () {
      system.throwOnError = false;
      expect(UT.checkVRIndex(kUTIndex), kUTIndex);

      for (var tag in utTags0) {
        system.throwOnError = false;
        expect(UT.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('UT checkVR bad values', () {
      system.throwOnError = false;
      expect(
          UT.checkVRIndex(
            kAEIndex,
          ),
          isNull);
      system.throwOnError = true;
      expect(() => UT.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(UT.checkVRIndex(tag.vrIndex), isNull);

        system.throwOnError = true;
        expect(() => UT.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UT isValidVRIndex good values', () {
      system.throwOnError = false;
      expect(UT.isValidVRIndex(kUTIndex), true);

      for (var tag in utTags0) {
        system.throwOnError = false;
        expect(UT.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('UT isValidVRIndex bad values', () {
      system.throwOnError = false;
      expect(UT.isValidVRIndex(kCSIndex), false);

      system.throwOnError = true;
      expect(() => UT.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(UT.isValidVRIndex(tag.vrIndex), false);

        system.throwOnError = true;
        expect(() => UT.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UT isValidVRCode good values', () {
      system.throwOnError = false;
      expect(UT.isValidVRCode(kUTCode), true);

      for (var tag in utTags0) {
        expect(UT.isValidVRCode(tag.vrCode), true);
      }
    });

    test('UT isValidVRCode bad values', () {
      system.throwOnError = false;
      expect(UT.isValidVRCode(kAECode), false);

      system.throwOnError = true;
      expect(() => UT.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(UT.isValidVRCode(tag.vrCode), false);

        system.throwOnError = true;
        expect(() => UT.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UT isValidVFLength good values', () {
      expect(UT.isValidVFLength(UT.kMaxVFLength), true);
      expect(UT.isValidVFLength(0), true);
    });

    test('UT isValidVFLength bad values', () {
      expect(UT.isValidVFLength(UT.kMaxVFLength + 1), false);
      expect(UT.isValidVFLength(-1), false);
    });

    test('UT isValidVListLength VM.k1 good values', () {
      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getUTList(1, 1);
        for (var tag in utTags0) {
          expect(UT.isValidVListLength(tag, validMinVList), true);

          expect(
              UT.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              UT.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('UT isValidVListLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rsg.getUTList(2, i + 1);
        for (var tag in utTags0) {
          system.throwOnError = false;
          expect(UT.isValidVListLength(tag, validMinVList), false);

          expect(UT.isValidVListLength(tag, invalidVList), false);

          system.throwOnError = true;
          expect(() => UT.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesLengthError>()));
        }
      }
    });

    test('UT isValidValue good values', () {
      for (var s in goodUTList) {
        for (var a in s) {
          expect(UT.isValidValue(a), true);
        }
      }
    });

    test('UT isValidValue bad values', () {
      for (var s in badUTList) {
        for (var a in s) {
          system.throwOnError = false;
          expect(UT.isValidValue(a), false);

          system.throwOnError = true;
          expect(() => UT.isValidValue(a),
              throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
        }
      }
    });

    test('UT isValidValues good values', () {
      system.throwOnError = false;
      for (var s in goodUTList) {
        expect(UT.isValidValues(PTag.kUniversalEntityID, s), true);
      }
    });

    test('UT isValidValues bad values', () {
      for (var s in badUTList) {
        system.throwOnError = false;
        expect(UT.isValidValues(PTag.kUniversalEntityID, s), false);

        system.throwOnError = true;
        expect(() => UT.isValidValues(PTag.kUniversalEntityID, s),
            throwsA(const isInstanceOf<InvalidCharacterInStringError>()));
      }
    });

    test('UT fromBytes', () {
      //  system.level = Level.debug;;
      final vList1 = rsg.getUTList(1, 1);
      final bytes = UT.toBytes(vList1);
      log.debug('UT.fromBytes(bytes): ${UT.fromBytes(bytes)}, bytes: $bytes');
      expect(UT.fromBytes(bytes), equals(vList1));
    });

    test('UT toBytes', () {
      final vList1 = rsg.getUTList(1, 1);
      log.debug('UT.toBytes(vList1): ${UT.toBytes(vList1)}');
      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = ASCII.encode(vList1[0]);
      expect(UT.toBytes(vList1), equals(values));
    });

/*    test('UT fromBase64', () {
      final vList1 = rsg.getUTList(1, 1);
      //final values = ASCII.encode(vList1[0]);
      system.throwOnError = false;
      final v0 = UT.fromBase64(vList1);
      expect(v0, isNotNull);

      final v1 = UT.fromBase64(['PIA5']);
      expect(v1, isNotNull);

      final v2 = UT.fromBase64(['PIA']);
      expect(v2, isNotNull);
    });

    test('UT toBase64', () {
      final vList0 = rsg.getUTList(1, 1);
      expect(UT.toBase64(vList0), equals(vList0));

      final vList1 = ['dslkj'];
      //final s0 = ASCII.encode(vList0[0]);
      expect(UT.toBase64(vList1), equals(vList1));
    });*/

  });
}
