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

void main() {
  Server.initialize(name: 'string/st_test', level: Level.info);
  global.throwOnError = false;

  const goodSTList = <List<String>>[
    <String>['\t '], //horizontal tab (HT)
    <String>['\n'], //linefeed (LF)
    <String>['\f '], // form feed (FF)
    <String>['\r '], //carriage return (CR)
    <String>['(s!WGR3D:2hhWF|,'],
    <String>['6g:Q@ A:SnpPLKm:hi|?]zOwIa";n56W']
  ];

  const badSTList = <List<String>>[
    <String>['\b'], //	Backspace
  ];

  group('ST Tests', () {
    test('ST hasValidValues good values', () {
      for (var s in goodSTList) {
        global.throwOnError = false;
        final e0 = STtag(PTag.kMetaboliteMapDescription, s);
        expect(e0.hasValidValues, true);
      }
      global.throwOnError = false;
      final e0 = STtag(PTag.kCADFileFormat, []);
      expect(e0.hasValidValues, true);
      expect(e0.values, equals(<String>[]));
    });

    test('ST hasValidValues bad values', () {
      for (var s in badSTList) {
        global.throwOnError = false;
        final e0 = STtag(PTag.kMetaboliteMapDescription, s);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => STtag(PTag.kMetaboliteMapDescription, s),
            throwsA(const TypeMatcher<StringError>()));
      }

      global.throwOnError = false;
      final e1 = STtag(PTag.kCADFileFormat, null);
      log.debug('e1: $e1');
      expect(e1.hasValidValues, true);
      expect(e1.values, StringList.kEmptyList);

      global.throwOnError = true;
      expect(() => STtag(PTag.kMetaboliteMapDescription, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('ST hasValidValues random good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final e0 = STtag(PTag.kMetaboliteMapDescription, vList0);
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: ${e0.info}');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final e1 = STtag(PTag.kCADFileFormat, vList0);
        log.debug('e1:${e1.info}');
        expect(e1.hasValidValues, true);

        log..debug('e1: $e1, values: ${e1.values}')..debug('e1: ${e1.info}');
        expect(e1[0], equals(vList0[0]));
      }
    });

    test('ST hasValidValues random bad values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(3, 4);
        log.debug('$i: vList0: $vList0');
        final sh2 = STtag(PTag.kMetaboliteMapDescription, vList0);
        expect(sh2, isNull);
      }
    });

    test('ST update random', () {
      final e0 = STtag(PTag.kCADFileFormat, []);
      expect(e0.update(['d^u:96P, azV']).values, equals(['d^u:96P, azV']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final e1 = STtag(PTag.kCADFileFormat, vList0);
        final vList1 = rsg.getSTList(1, 1);
        expect(e1.update(vList1).values, equals(vList1));
      }
    });

    test('ST noValues random', () {
      final e0 = STtag(PTag.kCADFileFormat, []);
      final STtag stNoValues = e0.noValues;
      expect(stNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final e0 = STtag(PTag.kCADFileFormat, vList0);
        log.debug('e0: $e0');
        expect(stNoValues.values.isEmpty, true);
        log.debug('e0: ${e0.noValues}');
      }
    });

    test('ST copy random', () {
      final e0 = STtag(PTag.kCADFileFormat, []);
      final STtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final sh2 = STtag(PTag.kCADFileFormat, vList0);
        final STtag sh3 = sh2.copy;
        expect(sh3 == sh2, true);
        expect(sh3.hashCode == sh2.hashCode, true);
      }
    });

    test('ST hashCode and == good values random', () {
      List<String> vList0;
      for (var i = 0; i < 10; i++) {
        vList0 = rsg.getSTList(1, 1);
        final e0 = STtag(PTag.kSelectorSTValue, vList0);
        final e1 = STtag(PTag.kSelectorSTValue, vList0);
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
        final e0 = STtag(PTag.kSelectorSTValue, vList0);

        final vList1 = rsg.getSTList(1, 1);
        final e2 = STtag(PTag.kTopicSubject, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rsg.getSTList(1, 10);
        final e3 = STtag(PTag.kComponentManufacturer, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);

        final vList3 = rsg.getSTList(2, 3);
        final e4 = STtag(PTag.kSelectorSTValue, vList3);
        log.debug('vList3:$vList3 , e4.hash_code:${e4.hashCode}');
        expect(e0.hashCode == e4.hashCode, false);
        expect(e0 == e4, false);
      }
    });

    test('ST valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final e0 = STtag(PTag.kSelectorSTValue, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('ST isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final e0 = STtag(PTag.kSelectorSTValue, vList0);
        expect(e0.tag.isValidLength(e0), true);
      }
    });

    test('ST isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final e0 = STtag(PTag.kSelectorSTValue, vList0);

        expect(e0.checkValues(e0.values), true);
        expect(e0.hasValidValues, true);
      }
    });

    test('ST replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final e0 = STtag(PTag.kSelectorSTValue, vList0);
        final vList1 = rsg.getSTList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getSTList(1, 1);
      final e1 = STtag(PTag.kSelectorSTValue, vList1);
      expect(e1.replace([]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = STtag(PTag.kSelectorSTValue, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(<String>[]));
    });

    test('ST blank random', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getSTList(1, 1);
        final e0 = STtag(PTag.kSelectorSTValue, vList1);
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
          //final bytes0 = Bytes();
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
          //final bytes0 = Bytes();
          final e1 = STtag.fromBytes(PTag.kSelectorCSValue, bytes0);
          expect(e1, isNull);

          global.throwOnError = true;
          expect(() => STtag.fromBytes(PTag.kSelectorCSValue, bytes0),
              throwsA(const TypeMatcher<InvalidTagError>()));
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
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final e1 = STtag.fromValues(PTag.kSelectorSTValue, <String>[null]);
      log.debug('mak1: $e1');
      expect(e1, isNull);

      global.throwOnError = true;
      expect(() => STtag.fromValues(PTag.kSelectorSTValue, <String>[null]),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('ST checkLength good values', () {
      final vList0 = rsg.getSTList(1, 1);
      final sh0 = STtag(PTag.kSelectorSTValue, vList0);
      for (var s in goodSTList) {
        expect(sh0.checkLength(s), true);
      }
      final sh1 = STtag(PTag.kSelectorSTValue, vList0);
      expect(sh1.checkLength([]), true);

      final vList1 = rsg.getSTList(1, 1);
      final sh2 = STtag(PTag.kCADFileFormat, vList1);
      for (var s in goodSTList) {
        expect(sh2.checkLength(s), true);
      }
    });

    test('ST checkLength bad values', () {
      global.throwOnError = false;
      final vList2 = ['a^1sd', '02@#'];
      final sh3 = STtag(PTag.kSelectorSTValue, vList2);
      expect(sh3, isNull);
    });

    test('ST checkValue good values', () {
      final vList0 = rsg.getSTList(1, 1);
      final e0 = STtag(PTag.kSelectorSTValue, vList0);
      for (var s in goodSTList) {
        for (var a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });

    test('ST checkValue bad values', () {
      final vList0 = rsg.getSTList(1, 1);
      final e0 = STtag(PTag.kSelectorSTValue, vList0);
      for (var s in badSTList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(e0.checkValue(a), false);

          global.throwOnError = true;
          expect(() => e0.checkValue(a),
              throwsA(const TypeMatcher<StringError>()));
        }
      }
    });

    test('ST fromUtf8', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getSTList(1, 1);
        final s0 = vList[0];
        final bytes = Bytes.fromUtf8(s0);
        final s1 = bytes.getUtf8();
        log.debug('s1: $s1');
        expect(s1, equals(s0));

        final s2 = bytes.getUtf8();
        log.debug('s2: $s2');
        expect(s2, equals(s1));
      }
    });

    test('ST append', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final e0 = STtag(PTag.kSelectorSTValue, vList0);
        const vList1 = 'foo';
        final append0 = e0.append(vList1);
        log.debug('append0: $append0');
        expect(append0, isNotNull);
      }
    });

    test('ST prepend', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final e0 = STtag(PTag.kSelectorSTValue, vList0);
        const vList1 = 'foo';
        final prepend0 = e0.prepend(vList1);
        log.debug('prepend0: $prepend0');
        expect(prepend0, isNotNull);
      }
    });

    test('ST truncate', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1, 16);
        final e0 = STtag(PTag.kSelectorSTValue, vList0);
        final truncate0 = e0.truncate(10);
        log.debug('truncate0: $truncate0');
        expect(truncate0, isNotNull);
      }
    });

    test('ST match', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final e0 = STtag(PTag.kSelectorSTValue, vList0);
        final match0 = e0.match(r'.*');
        expect(match0, true);
      }
    });

    test('ST valueFromBytes', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final bytes = Bytes.fromUtf8List(vList0);
        final e0 = STtag(PTag.kSelectorSTValue, vList0);
        final vfb0 = e0.valuesFromBytes(bytes);
        expect(vfb0, equals(vList0));
      }
    });
  });

  group('ST', () {
    //VM.k1
    const stVM1Tags = <PTag>[
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

    const otherTags = <PTag>[
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

      for (var tag in stVM1Tags) {
        final validT0 = ST.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('ST isValidTag bad values', () {
      global.throwOnError = false;
      expect(ST.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => ST.isValidTag(PTag.kSelectorFDValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = ST.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => ST.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('ST isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(ST.isValidVRIndex(kSTIndex), true);

      for (var tag in stVM1Tags) {
        global.throwOnError = false;
        expect(ST.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('ST isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(ST.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => ST.isValidVRIndex(kCSIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(ST.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => ST.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('ST isValidVRCode good values', () {
      global.throwOnError = false;
      expect(ST.isValidVRCode(kSTCode), true);

      for (var tag in stVM1Tags) {
        expect(ST.isValidVRCode(tag.vrCode), true);
      }
    });

    test('ST isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(ST.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => ST.isValidVRCode(kAECode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(ST.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => ST.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('ST isValidVFLength good values', () {
      expect(ST.isValidVFLength(ST.kMaxVFLength), true);
      expect(ST.isValidVFLength(0), true);
    });

    test('ST isValidVFLength bad values', () {
      expect(ST.isValidVFLength(ST.kMaxVFLength + 1), false);
      expect(ST.isValidVFLength(-1), false);

      expect(ST.isValidVFLength(ST.kMaxVFLength, null, PTag.kSelectorISValue),
          false);
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

    test('ST isValidLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getSTList(1, 1);
        for (var tag in stVM1Tags) {
          expect(ST.isValidLength(tag, vList), true);

          expect(ST.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(ST.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('ST isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getSTList(2, i + 1);
        for (var tag in stVM1Tags) {
          global.throwOnError = false;
          expect(ST.isValidLength(tag, vList), false);

          expect(ST.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => ST.isValidLength(tag, vList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
      global.throwOnError = false;
      final vList0 = rsg.getSTList(1, 1);
      expect(ST.isValidLength(null, vList0), false);

      expect(ST.isValidLength(PTag.kSelectorSTValue, null), isNull);

      global.throwOnError = true;
      expect(() => ST.isValidLength(null, vList0),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => ST.isValidLength(PTag.kSelectorSTValue, null),
          throwsA(const TypeMatcher<GeneralError>()));
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
              throwsA(const TypeMatcher<StringError>()));
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
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('ST toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        global.throwOnError = false;
        final values = ascii.encode(vList0[0]);
        final tbd0 = Bytes.fromUtf8List(vList0);
        final tbd1 = Bytes.fromUtf8List(vList0);
        log.debug('tbd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodSTList) {
        for (var a in s) {
          final values = ascii.encode(a);
          final tbd2 = Bytes.fromUtf8List(s);
          final tbd3 = Bytes.fromUtf8List(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('ST fromBytes', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final s0 = vList0[0];
        final bytes = Bytes.fromUtf8(s0);
        final s1 = bytes.getUtf8();
        log.debug('s1: $s1, s0: $s0');
        expect(s1, equals(s0));
      }
      for (var vList1 in goodSTList) {
        final s0 = vList1[0];
        final bytes = Bytes.fromUtf8(s0);
        final s1 = bytes.getUtf8();
        expect(s1, equals(s0));
      }
    });

    test('ST fromBytes', () {
      final vList = rsg.getSTList(1, 1);
      final s0 = vList[0];
      final bytes = Bytes.fromUtf8(s0);
      log.debug('ST.fromBytes(bytes):  $bytes');
      expect(bytes.getUtf8(), equals(s0));
    });

    test('ST fromUtf8', () {
      final vList = rsg.getSTList(1, 1);
      final s0 = vList[0];
      log
        ..debug('Bytes.fromUtf8List(vList1): ${Bytes.fromUtf8(s0)}')
//      if (s0.length.isOdd) s0 = '$s0 ';
        ..debug('s0:"$s0"');
      final bytes = utf8.encode(vList[0]);
      expect(Bytes.fromUtf8(s0), equals(bytes));
    });

    test('ST toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        global.throwOnError = false;
        final toB0 = Bytes.fromUtf8List(vList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(vList0.join('\\'));
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

      /*global.throwOnError = false;
      final toB2 = Bytes.fromUtf8List(null, kMaxShortVF);
      expect(toB2, isNull);

      global.throwOnError = true;
      expect(() => Bytes.fromUtf8List(null, kMaxShortVF),
          throwsA(const TypeMatcher<GeneralError>()));*/
    });

    test('ST isValidBytesArgs', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        final vfBytes = Bytes.fromUtf8List(vList0);

        for (var tag in stVM1Tags) {
          final e0 = ST.isValidBytesArgs(tag, vfBytes);
          expect(e0, true);
        }
      }
      final vList0 = rsg.getSTList(1, 1);
      final vfBytes = Bytes.fromUtf8List(vList0);

      final e1 = ST.isValidBytesArgs(null, vfBytes);
      expect(e1, false);

      final e2 = ST.isValidBytesArgs(PTag.kDate, vfBytes);
      expect(e2, false);

      final e3 = ST.isValidBytesArgs(PTag.kSelectorSTValue, null);
      expect(e3, false);

      global.throwOnError = true;
      expect(() => ST.isValidBytesArgs(null, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => ST.isValidBytesArgs(PTag.kDate, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));
    });
  });
}
