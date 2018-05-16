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
  Server.initialize(name: 'string/st_test', level: Level.info);
  global.throwOnError = false;

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
  
  group('ST Tests', () {
    test('ST hasValidValues good values', () {
      for (var s in goodSTList) {
        global.throwOnError = false;
        final e0 = new STtag(PTag.kMetaboliteMapDescription, s);
        expect(e0.hasValidValues, true);
      }
      global.throwOnError = false;
      final e0 = new STtag(PTag.kCADFileFormat, []);
      expect(e0.hasValidValues, true);
      expect(e0.values, equals(<String>[]));
    });

    test('ST hasValidValues bad values', () {
      for (var s in badSTList) {
        global.throwOnError = false;
        final e0 = new STtag(PTag.kMetaboliteMapDescription, s);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => new STtag(PTag.kMetaboliteMapDescription, s),
            throwsA(const isInstanceOf<StringError>()));
      }

      global.throwOnError = false;
      final e1 = new STtag(PTag.kCADFileFormat, null);
      log.debug('e1: $e1');
      expect(e1, isNull);

      global.throwOnError = true;
      expect(() => new STtag(PTag.kMetaboliteMapDescription, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('ST hasValidValues random good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final e0 = new STtag(PTag.kMetaboliteMapDescription, vList0);
        expect(e0.hasValidValues, true);

        log
          ..debug('e0: $e0, values: ${e0.values}')
          ..debug('e0: ${e0.info}');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final e1 = new STtag(PTag.kCADFileFormat, vList0);
        log.debug('e1:${e1.info}');
        expect(e1.hasValidValues, true);

        log
          ..debug('e1: $e1, values: ${e1.values}')
          ..debug('e1: ${e1.info}');
        expect(e1[0], equals(vList0[0]));
      }
    });

    test('ST hasValidValues random bad values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(3, 4);
        log.debug('$i: vList0: $vList0');
        final sh2 = new STtag(PTag.kMetaboliteMapDescription, vList0);
        expect(sh2, isNull);
      }
    });

    test('ST update random', () {
      final e0 = new STtag(PTag.kCADFileFormat, []);
      expect(e0.update(['d^u:96P, azV']).values, equals(['d^u:96P, azV']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final e1 = new STtag(PTag.kCADFileFormat, vList0);
        final vList1 = rsg.getSTList(1, 1);
        expect(e1.update(vList1).values, equals(vList1));
      }
    });

    test('ST noValues random', () {
      final e0 = new STtag(PTag.kCADFileFormat, []);
      final STtag stNoValues = e0.noValues;
      expect(stNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final e0 = new STtag(PTag.kCADFileFormat, vList0);
        log.debug('e0: $e0');
        expect(stNoValues.values.isEmpty, true);
        log.debug('e0: ${e0.noValues}');
      }
    });

    test('ST copy random', () {
      final e0 = new STtag(PTag.kCADFileFormat, []);
      final STtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final sh2 = new STtag(PTag.kCADFileFormat, vList0);
        final STtag sh3 = sh2.copy;
        expect(sh3 == sh2, true);
        expect(sh3.hashCode == sh2.hashCode, true);
      }
    });

    test('ST hashCode and == good values random', () {
      List<String> vList0;
      for (var i = 0; i < 10; i++) {
        vList0 = rsg.getSTList(1, 1);
        final e0 = new STtag(PTag.kSelectorSTValue, vList0);
        final e1 = new STtag(PTag.kSelectorSTValue, vList0);
        log
          ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
          ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('ST hashCode and == bad values random', () {
 
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final e0 = new STtag(PTag.kSelectorSTValue, vList0);

        final vList1 = rsg.getSTList(1, 1);
        final e2 = new STtag(PTag.kTopicSubject, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rsg.getSTList(1, 10);
        final e3 = new STtag(PTag.kComponentManufacturer, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);

        final vList3 = rsg.getSTList(2, 3);
        final e4 = new STtag(PTag.kSelectorSTValue, vList3);
        log.debug('vList3:$vList3 , e4.hash_code:${e4.hashCode}');
        expect(e0.hashCode == e4.hashCode, false);
        expect(e0 == e4, false);
      }
    });

    test('ST valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final e0 = new STtag(PTag.kSelectorSTValue, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('ST isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final e0 = new STtag(PTag.kSelectorSTValue, vList0);
        expect(e0.tag.isValidLength(e0), true);
      }
    });

    test('ST isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final e0 = new STtag(PTag.kSelectorSTValue, vList0);

        expect(e0.checkValues(e0.values), true);
        expect(e0.hasValidValues, true);
      }
    });

    test('ST replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final e0 = new STtag(PTag.kSelectorSTValue, vList0);
        final vList1 = rsg.getSTList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getSTList(1, 1);
      final e1 = new STtag(PTag.kSelectorSTValue, vList1);
      expect(e1.replace([]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = new STtag(PTag.kSelectorSTValue, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(<String>[]));
    });

    test('ST blank random', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getSTList(1, 1);
        final e0 = new STtag(PTag.kSelectorSTValue, vList1);
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

    test('ST fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getSTList(1, 1);
        final bytes = Bytes.fromUtf8List(vList1);
        log.debug('bytes:$bytes');
        final e0 = STtag.fromBytes(PTag.kSelectorSTValue, bytes);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);
      }
    });

    test('ST fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getSTList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          //final bytes0 = new Bytes();
          final e1 = STtag.fromBytes(PTag.kSelectorSTValue, bytes0);
          log.debug('e1: ${e1.info}');
          expect(e1.hasValidValues, true);
        }
      }
    });

    test('ST fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getSTList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.fromAscii(listS);
          //final bytes0 = new Bytes();
          final e1 = STtag.fromBytes(PTag.kSelectorCSValue, bytes0);
          expect(e1, isNull);

          global.throwOnError = true;
          expect(() => STtag.fromBytes(PTag.kSelectorCSValue, bytes0),
              throwsA(const isInstanceOf<InvalidTagError>()));
        }
      }
    });

    test('ST fromValues good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final e0 = STtag.fromValues(PTag.kSelectorSTValue, vList0);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);

        final e1 = STtag.fromValues(PTag.kSelectorSTValue, <String>[]);
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(<String>[]));
      }
    });

    test('ST fromValues bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(2, 2);
        global.throwOnError = false;
        final e0 = STtag.fromValues(PTag.kSelectorSTValue, vList0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => STtag.fromValues(PTag.kSelectorSTValue, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final e1 = STtag.fromValues(PTag.kSelectorSTValue, <String>[null]);
      log.debug('mak1: $e1');
      expect(e1, isNull);

      global.throwOnError = true;
      expect(() => STtag.fromValues(PTag.kSelectorSTValue, <String>[null]),
          throwsA(const isInstanceOf<InvalidValuesError>()));
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
      global.throwOnError = false;
      final vList2 = ['a^1sd', '02@#'];
      final sh3 = new STtag(PTag.kSelectorSTValue, vList2);
      expect(sh3, isNull);
    });

    test('ST checkValue good values', () {
      final vList0 = rsg.getSTList(1, 1);
      final e0 = new STtag(PTag.kSelectorSTValue, vList0);
      for (var s in goodSTList) {
        for (var a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });

    test('ST checkValue bad values', () {
      final vList0 = rsg.getSTList(1, 1);
      final e0 = new STtag(PTag.kSelectorSTValue, vList0);
      for (var s in badSTList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(e0.checkValue(a), false);

          global.throwOnError = true;
          expect(() => e0.checkValue(a),
              throwsA(const isInstanceOf<StringError>()));
        }
      }
    });

    test('ST decodeBinaryTextVF', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getSTList(1, 1);
        final bytes = Bytes.fromUtf8List(vList1);
        final dbTxt0 = bytes.getUtf8List();
        log.debug('dbTxt0: $dbTxt0');
        expect(dbTxt0, equals(vList1));

        final dbTxt1 = bytes.getUtf8List();
        log.debug('dbTxt1: $dbTxt1');
        expect(dbTxt1, equals(vList1));
      }
    });
  });

  group('ST', () {
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

    test('ST isValidTag good values', () {
      global.throwOnError = false;
      expect(ST.isValidTag(PTag.kSelectorSTValue), true);

      for (var tag in stTags0) {
        final validT0 = ST.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('ST isValidTag bad values', () {
      global.throwOnError = false;
      expect(ST.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => ST.isValidTag(PTag.kSelectorFDValue),
          throwsA(const isInstanceOf<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = ST.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => ST.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });
/*
    test('ST checkVRIndex good values', () {
      global.throwOnError = false;
      expect(ST.checkVRIndex(kSTIndex), kSTIndex);

      for (var tag in stTags0) {
        global.throwOnError = false;
        expect(ST.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('ST checkVRIndex bad values', () {
      global.throwOnError = false;
      expect(
          ST.checkVRIndex(
            kAEIndex,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => ST.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(ST.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => ST.checkVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('ST checkVRCode good values', () {
      global.throwOnError = false;
      expect(ST.checkVRCode(kSTCode), kSTCode);

      for (var tag in stTags0) {
        global.throwOnError = false;
        expect(ST.checkVRCode(tag.vrCode), tag.vrCode);
      }
    });

    test('ST checkVRCode bad values', () {
      global.throwOnError = false;
      expect(
          ST.checkVRCode(
            kAECode,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => ST.checkVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(ST.checkVRCode(tag.vrCode), isNull);

        global.throwOnError = true;
        expect(() => ST.checkVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });
 */
    test('ST isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(ST.isValidVRIndex(kSTIndex), true);

      for (var tag in stTags0) {
        global.throwOnError = false;
        expect(ST.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('ST isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(ST.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => ST.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(ST.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => ST.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('ST isValidVRCode good values', () {
      global.throwOnError = false;
      expect(ST.isValidVRCode(kSTCode), true);

      for (var tag in stTags0) {
        expect(ST.isValidVRCode(tag.vrCode), true);
      }
    });

    test('ST isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(ST.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => ST.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(ST.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
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

    test('ST isNotValidValueLength bad values', () {
      expect(ST.isNotValidValueLength(''), false);
    });

    test('ST isValidVListLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getSTList(1, 1);
        for (var tag in stTags0) {
          expect(ST.isValidVListLength(tag, vList), true);

          expect(
              ST.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              ST.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('ST isValidVListLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getSTList(2, i + 1);
        for (var tag in stTags0) {
          global.throwOnError = false;
          expect(ST.isValidVListLength(tag, vList), false);

          expect(ST.isValidVListLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => ST.isValidVListLength(tag, vList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
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
          global.throwOnError = false;
          expect(ST.isValidValue(a), false);

          global.throwOnError = true;
          expect(() => ST.isValidValue(a),
              throwsA(const isInstanceOf<StringError>()));
        }
      }
    });

    test('ST isValidValues good values', () {
      global.throwOnError = false;
      for (var s in goodSTList) {
        expect(ST.isValidValues(PTag.kInstitutionAddress, s), true);
      }
    });

    test('ST isValidValues bad values', () {
      for (var s in badSTList) {
        global.throwOnError = false;
        expect(ST.isValidValues(PTag.kInstitutionAddress, s), false);

        global.throwOnError = true;
        expect(() => ST.isValidValues(PTag.kInstitutionAddress, s),
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('ST toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        global.throwOnError = false;
        final values = cvt.ascii.encode(vList0[0]);
        final tbd0 = Bytes.fromUtf8List(vList0);
        final tbd1 = Bytes.fromUtf8List(vList0);
        log.debug('tbd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodSTList) {
        for (var a in s) {
          final values = cvt.ascii.encode(a);
          final tbd2 = Bytes.fromUtf8List(s);
          final tbd3 = Bytes.fromUtf8List(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('ST fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.fromUtf8List(vList0);
        final fbd0 = bd0.getUtf8List();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (var s in goodSTList) {
        final bd0 = Bytes.fromUtf8List(s);
        final fbd0 = bd0.getUtf8List();
        expect(fbd0, equals(s));
      }
    });

    test('ST fromBytes', () {
      //  system.level = Level.info;;
      final vList1 = rsg.getSTList(1, 1);
      final bytes = Bytes.fromUtf8List(vList1);
      log.debug('ST.fromBytes(bytes):  $bytes');
      expect(bytes.getUtf8List(), equals(vList1));
    });

    test('ST toUint8List', () {
      final vList1 = rsg.getSTList(1, 1);
      log.debug('Bytes.fromUtf8List(vList1): ${Bytes.fromUtf8List(vList1)}');
      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = cvt.ascii.encode(vList1[0]);
      expect(Bytes.fromUtf8List(vList1), equals(values));
    });

    test('ST toBytes', () {
      for (var i = 0; i < 10; i++) {
        final sLie0 = rsg.getSTList(1, 1);
        global.throwOnError = false;
        final toB0 = Bytes.fromUtf8List(sLie0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(sLie0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodSTList) {
        final toB1 = Bytes.fromUtf8List(s, kMaxShortVF);
        final bytes1 = Bytes.fromAscii(s.join('\\'));
        log.debug('toBytes:$toB1, bytes1: $bytes1');
        expect(toB1, equals(bytes1));
      }

      final toB2 = Bytes.fromUtf8List([''], kMaxShortVF);
      expect(toB2, equals(<String>[]));

      final toB3 = Bytes.fromUtf8List([], kMaxShortVF);
      expect(toB3, equals(<String>[]));

      /*system.throwOnError = false;
      final toB2 = Bytes.fromUtf8List(null, kMaxShortVF);
      expect(toB2, isNull);

      system.throwOnError = true;
      expect(() => Bytes.fromUtf8List(null, kMaxShortVF),
          throwsA(const isInstanceOf<GeneralError>()));*/
    });
  });
}
