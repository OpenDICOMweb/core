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
  Server.initialize(name: 'string/sh_test', level: Level.info);
  global.throwOnError = false;

  const goodSHList = <List<String>>[
    <String>['d9E8tO'],
    <String>['mrZeo|^P> -6{t, '],
    <String>[')QcFN@1r]&u;~3l'],
    <String>['1wd7'],
    <String>['T 2@+nEZKu/J']
  ];

  const badSHList = <List<String>>[
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

  group('SHtag', () {
    test('SH hasValidValues good values', () {
      for (var s in goodSHList) {
        global.throwOnError = false;
        final e0 = SHtag(PTag.kMultiCoilElementName, s);
        expect(e0.hasValidValues, true);
      }
      global.throwOnError = false;
      final e0 = SHtag(PTag.kSelectorSHValue, []);
      expect(e0.hasValidValues, true);
      expect(e0.values, equals(<String>[]));
    });

    test('SH hasValidValues bad values', () {
      for (var s in badSHList) {
        global.throwOnError = false;
        final e0 = SHtag(PTag.kMultiCoilElementName, s);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => SHtag(PTag.kMultiCoilElementName, s),
            throwsA(const TypeMatcher<StringError>()));
      }
      global.throwOnError = false;
      final e1 = SHtag(PTag.kSelectorSHValue, null);
      expect(e1.hasValidValues, true);
      expect(e1.values, StringList.kEmptyList);

      global.throwOnError = true;
      expect(() => SHtag(PTag.kMultiCoilElementName, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('SH hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 1);
        final e0 = SHtag(PTag.kMultiCoilElementName, vList0);
        log.debug('e0:${e0.info}');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: ${e0.info}');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 10);
        final e1 = SHtag(PTag.kSelectorSHValue, vList0);
        log.debug('e1:${e1.info}');
        expect(e1.hasValidValues, true);

        log..debug('e1: $e1, values: ${e1.values}')..debug('e1: ${e1.info}');
        expect(e1[0], equals(vList0[0]));
      }
    });

    test('SH hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getSHList(3, 4);
        log.debug('$i: vList0: $vList0');
        final e2 = SHtag(PTag.kMultiCoilElementName, vList0);
        expect(e2, isNull);

        global.throwOnError = true;
        expect(() => SHtag(PTag.kMultiCoilElementName, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('SH update random', () {
      final e0 = SHtag(PTag.kSelectorSHValue, []);
      expect(e0.update(['d^u:96P, azV']).values, equals(['d^u:96P, azV']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(3, 4);
        final e1 = SHtag(PTag.kSelectorSHValue, vList0);
        final vList1 = rsg.getSHList(3, 4);
        expect(e1.update(vList1).values, equals(vList1));
      }
    });

    test('SH noValues random', () {
      final e0 = SHtag(PTag.kSelectorSHValue, []);
      final SHtag shNoValues = e0.noValues;
      expect(shNoValues.values.isEmpty, true);
      log.debug('as0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(3, 4);
        final e0 = SHtag(PTag.kSelectorSHValue, vList0);
        log.debug('e0: $e0');
        expect(shNoValues.values.isEmpty, true);
        log.debug('e0: ${e0.noValues}');
      }
    });

    test('SH copy random', () {
      final e0 = SHtag(PTag.kSelectorSHValue, []);
      final SHtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(3, 4);
        final e2 = SHtag(PTag.kSelectorSHValue, vList0);
        final SHtag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('SH hashCode and == good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getSHList(1, 1);
        final e0 = SHtag(PTag.kTextureLabel, vList);
        final e1 = SHtag(PTag.kTextureLabel, vList);
        log
          ..debug('vList:$vList, e0.hash_code:${e0.hashCode}')
          ..debug('vList:$vList, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('SH hashCode and == bad values random', () {
      global.throwOnError = false;
      log.debug('SH hashCode and == ');
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getSHList(1, 1);
        final e0 = SHtag(PTag.kTextureLabel, vList);

        final vList1 = rsg.getSHList(1, 1);
        final e1 = SHtag(PTag.kStorageMediaFileSetID, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, false);
        expect(e0 == e1, false);

        final vList2 = rsg.getSHList(1, 10);
        final e2 = SHtag(PTag.kSelectorSHValue, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList3 = rsg.getSHList(2, 3);
        final e3 = SHtag(PTag.kTextureLabel, vList3);
        log.debug('vList3:$vList3 , e4.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);
      }
    });

    test('SH valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 1);
        final e0 = SHtag(PTag.kTextureLabel, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('SH isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 1);
        final e0 = SHtag(PTag.kTextureLabel, vList0);
        expect(e0.tag.isValidLength(e0), true);
      }
    });

    test('SH isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 1);
        final e0 = SHtag(PTag.kTextureLabel, vList0);
        expect(e0.checkValues(e0.values), true);
        expect(e0.hasValidValues, true);
      }
    });

    test('SH replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 1);
        final e0 = SHtag(PTag.kTextureLabel, vList0);
        final vList1 = rsg.getSHList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getSHList(1, 1);
      final e1 = SHtag(PTag.kTextureLabel, vList1);
      expect(e1.replace([]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = SHtag(PTag.kTextureLabel, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(<String>[]));
    });

    test('SH blank random', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getSHList(1, 1);
        final e0 = SHtag(PTag.kTextureLabel, vList1);
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

    test('SH fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getSHList(1, 1);
        final bytes = Bytes.utf8FromList(vList1);
        log.debug('bytes:$bytes');
        final e0 = SHtag.fromBytes(PTag.kTextureLabel, bytes);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);
      }
    });

    test('SH fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getSHList(1, 1000);
        global.throwOnError = false;
//        for (var listS in vList1) {
        final bytes0 = Bytes.ascii(vList1.join('\\'));
        //final bytes0 = Bytes();
        final e1 = SHtag.fromBytes(PTag.kSelectorSHValue, bytes0);
        log.debug('e1: ${e1.info}');
        expect(e1.hasValidValues, true);
      }
      //}
    });

    test('SH fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getSHList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.ascii(listS);
          //final bytes0 = Bytes();
          final e1 = SHtag.fromBytes(PTag.kSelectorCSValue, bytes0);
          expect(e1, isNull);

          global.throwOnError = true;
          expect(() => SHtag.fromBytes(PTag.kSelectorCSValue, bytes0),
              throwsA(const TypeMatcher<InvalidTagError>()));
        }
      }
    });

    test('SH fromValues good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 1);
        final e0 = SHtag.fromValues(PTag.kTextureLabel, vList0);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);

        final e1 = SHtag.fromValues(PTag.kTextureLabel, <String>[]);
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(<String>[]));
      }
    });

    test('SH fromValues bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(2, 2);
        global.throwOnError = false;
        final e0 = SHtag.fromValues(PTag.kTextureLabel, vList0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => SHtag.fromValues(PTag.kTextureLabel, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final e1 = SHtag.fromValues(PTag.kTextureLabel, <String>[null]);
      log.debug('e1: $e1');
      expect(e1, isNull);

      global.throwOnError = true;
      expect(() => SHtag.fromValues(PTag.kTextureLabel, <String>[null]),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('SH checkLength good values', () {
      final vList0 = rsg.getSHList(1, 1);
      final e0 = SHtag(PTag.kTextureLabel, vList0);
      for (var s in goodSHList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = SHtag(PTag.kTextureLabel, vList0);
      expect(e1.checkLength([]), true);

      final vList1 = rsg.getSHList(1, 10);
      final e2 = SHtag(PTag.kConvolutionKernel, vList1);
      for (var s in goodSHList) {
        expect(e2.checkLength(s), true);
      }
    });

    test('SH checkLength bad values', () {
      global.throwOnError = false;
      final vList2 = ['a^1sd', '02@#'];
      final e3 = SHtag(PTag.kTextureLabel, vList2);
      expect(e3, isNull);

      global.throwOnError = true;
      expect(() => SHtag(PTag.kTextureLabel, vList2),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('SH checkValue good values', () {
      final vList0 = rsg.getSHList(1, 1);
      final e0 = SHtag(PTag.kTextureLabel, vList0);
      for (var s in goodSHList) {
        for (var a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });

    test('SH checkValue bad values', () {
      final vList0 = rsg.getSHList(1, 1);
      final e0 = SHtag(PTag.kTextureLabel, vList0);
      for (var s in badSHList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(e0.checkValue(a), false);

          global.throwOnError = true;
          expect(() => e0.checkValue(a),
              throwsA(const TypeMatcher<StringError>()));
        }
      }
    });

    test('SH append', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 4);
        final e0 = SHtag(PTag.kSelectorSHValue, vList0);
        const vList1 = 'foo';
        final append0 = e0.append(vList1);
        log.debug('append0: $append0');
        expect(append0, isNotNull);
      }
    });

    test('SH prepend', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 4);
        final e0 = SHtag(PTag.kSelectorSHValue, vList0);
        const vList1 = 'foo';
        final prepend0 = e0.prepend(vList1);
        log.debug('prepend0: $prepend0');
        expect(prepend0, isNotNull);
      }
    });

    test('SH match', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 10);
        final e0 = SHtag(PTag.kSelectorSHValue, vList0);
        final match0 = e0.match(r'.*');
        expect(match0, true);
      }

      final vList0 = ['1_">L+uc};j&)g'];
      final e0 = SHtag(PTag.kSelectorSHValue, vList0);
      final match0 = e0.match(r'\w*[_]');
      expect(match0, true);
    });

    test('SH truncate', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 4, 16);
        final e0 = SHtag(PTag.kSelectorSHValue, vList0);
        final truncate0 = e0.truncate(10);
        log.debug('truncate0: $truncate0');
        expect(truncate0, isNotNull);
      }
    });

    test('SH valueFromBytes', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getSHList(1, i);
        final bytes = Bytes.utf8FromList(vList0);
        final e0 = SHtag(PTag.kSelectorSHValue, vList0);
        final vfb0 = e0.valuesFromBytes(bytes);
        expect(vfb0, equals(vList0));
      }
    });

    test('SH check', () {
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getSHList(1, 1);
        final e0 = SHtag(PTag.kStationName, vList);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList[0]));
      }

      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getSHList(1, i);
        final e0 = SHtag(PTag.kSelectorSHValue, vList1);
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);
        expect(e0[0], equals(vList1[0]));
      }
    });

    test('SH valuesEqual good values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getSHList(1, 1);
        final e0 = SHtag(PTag.kSelectorSHValue, vList);
        final e1 = SHtag(PTag.kSelectorSHValue, vList);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), true);
      }
    });

    test('SH valuesEqual bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getSHList(1, i);
        final vList1 = rsg.getSHList(1, 1);
        final e0 = SHtag(PTag.kSelectorSHValue, vList0);
        final e1 = SHtag(PTag.kSelectorSHValue, vList1);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), false);
      }
    });

    test('SH fromValueField', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 1);
        print(vList0);
        final fvf0 = Ascii.fromValueField(vList0, k8BitMaxLongVF);
        expect(fvf0, equals(vList0));
      }

      for (var i = 1; i < 10; i++) {
        global.throwOnError = false;
        final vList1 = rsg.getSHList(1, i);
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

  group('SH', () {
    //VM.k1
    const shVM1Tags = <PTag>[
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
    const shVM1nTags = <PTag>[
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

    final invalidVList = rsg.getSHList(SH.kMaxLength + 1, SH.kMaxLength + 1);

    test('SH isValidTag good values', () {
      global.throwOnError = false;
      expect(SH.isValidTag(PTag.kSelectorSHValue), true);

      for (var tag in shVM1Tags) {
        final validT0 = SH.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('SH isValidTag bad values', () {
      global.throwOnError = false;
      expect(SH.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => SH.isValidTag(PTag.kSelectorFDValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = SH.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => SH.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('SH isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(SH.isValidVRIndex(kSHIndex), true);

      for (var tag in shVM1Tags) {
        global.throwOnError = false;
        expect(SH.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('SH isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(SH.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => SH.isValidVRIndex(kCSIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SH.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => SH.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('SH isValidVRCode good values', () {
      global.throwOnError = false;
      expect(SH.isValidVRCode(kSHCode), true);

      for (var tag in shVM1Tags) {
        expect(SH.isValidVRCode(tag.vrCode), true);
      }
    });

    test('SH isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(SH.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => SH.isValidVRCode(kAECode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SH.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => SH.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('SH isValidVFLength good values', () {
      expect(SH.isValidVFLength(SH.kMaxVFLength), true);
      expect(SH.isValidVFLength(0), true);

      expect(SH.isValidVFLength(SH.kMaxVFLength, null, PTag.kSelectorSHValue),
          true);
    });

    test('SH isValidVFLength bad values', () {
      expect(SH.isValidVFLength(SH.kMaxVFLength + 1), false);
      expect(SH.isValidVFLength(-1), false);
    });

    test('SH isValidValueLength good values', () {
      for (var s in goodSHList) {
        for (var a in s) {
          expect(SH.isValidValueLength(a), true);
        }
      }

      expect(SH.isValidValueLength('a'), true);
      expect(SH.isValidValueLength(''), true);
    });

    test('SH isValidValueLength bad values', () {
      global.throwOnError = false;
      expect(SH.isValidValueLength('d9E8tO.Tyu87Yer#423 {8/rt'), false);
    });

    test('SH isValidLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getSHList(1, 1);
        for (var tag in shVM1Tags) {
          expect(SH.isValidLength(tag, vList), true);

          expect(SH.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(SH.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('SH isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getSHList(2, i + 1);
        for (var tag in shVM1Tags) {
          global.throwOnError = false;
          expect(SH.isValidLength(tag, vList), false);

          expect(SH.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => SH.isValidLength(tag, vList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
      global.throwOnError = false;
      final vList0 = rsg.getSHList(1, 1);
      expect(SH.isValidLength(null, vList0), false);

      expect(SH.isValidLength(PTag.kSelectorSHValue, null), isNull);

      global.throwOnError = true;
      expect(() => SH.isValidLength(null, vList0),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => SH.isValidLength(PTag.kSelectorSHValue, null),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('SH isValidLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getSHList(1, i);
        final validMaxLengthList = invalidVList.sublist(0, SH.kMaxLength);
        for (var tag in shVM1nTags) {
          log.debug('tag: $tag');
          expect(SH.isValidLength(tag, vList), true);
          expect(SH.isValidLength(tag, validMaxLengthList), true);
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
          global.throwOnError = false;
          expect(SH.isValidValue(a), false);

          global.throwOnError = true;
          expect(() => SH.isValidValue(a),
              throwsA(const TypeMatcher<StringError>()));
        }
      }
    });

    test('SH isValidValues good values', () {
      global.throwOnError = false;
      for (var s in goodSHList) {
        expect(SH.isValidValues(PTag.kStationName, s), true);
      }
    });

    test('SH isValidValues bad values', () {
      global.throwOnError = false;
      for (var s in badSHList) {
        global.throwOnError = false;
        expect(SH.isValidValues(PTag.kStationName, s), false);

        global.throwOnError = true;
        expect(() => SH.isValidValues(PTag.kStationName, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('SH toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 1);
        global.throwOnError = false;
        final values = cvt.ascii.encode(vList0[0]);
        final tbd0 = Bytes.utf8FromList(vList0);
        final tbd1 = Bytes.utf8FromList(vList0);
        log.debug('tbd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodSHList) {
        for (var a in s) {
          final values = cvt.ascii.encode(a);
          final tbd2 = Bytes.utf8FromList(s);
          final tbd3 = Bytes.utf8FromList(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('SH fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.utf8FromList(vList0);
        final fbd0 = bd0.stringListFromUtf8();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (var s in goodSHList) {
        final bd0 = Bytes.utf8FromList(s);
        final fbd0 = bd0.stringListFromUtf8();
        expect(fbd0, equals(s));
      }
    });

    test('SH fromBytes', () {
      //  system.level = Level.info;;
      final vList1 = rsg.getSHList(1, 1);
      final bytes = Bytes.utf8FromList(vList1);
      log.debug('SH.fromBytes(bytes):  $bytes');
      expect(bytes.stringListFromUtf8(), equals(vList1));
    });

    test('SH toUint8List', () {
      final vList1 = rsg.getSHList(1, 1);
      log.debug('Bytes.fromUtf8List(vList1): ${Bytes.utf8FromList(vList1)}');
      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = cvt.ascii.encode(vList1[0]);
      expect(Bytes.utf8FromList(vList1), equals(values));
    });

    test('SH isValidValues good values', () {
      global.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList = rsg.getSHList(1, 1);
        expect(SH.isValidValues(PTag.kStationName, vList), true);
      }

      final vList0 = ['!mSMXWVy`]/Du'];
      expect(SH.isValidValues(PTag.kStationName, vList0), true);

      for (var s in goodSHList) {
        global.throwOnError = false;
        expect(SH.isValidValues(PTag.kStationName, s), true);
      }
    });

    test('SH isValidValues bad values', () {
      global.throwOnError = false;
      final vList1 = ['r^`~\\?'];
      expect(SH.isValidValues(PTag.kStationName, vList1), false);

      global.throwOnError = true;
      expect(() => SH.isValidValues(PTag.kStationName, vList1),
          throwsA(const TypeMatcher<StringError>()));

      for (var s in badSHList) {
        global.throwOnError = false;
        expect(SH.isValidValues(PTag.kStationName, s), false);

        global.throwOnError = true;
        expect(() => SH.isValidValues(PTag.kStationName, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('SH toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vsList0 = rsg.getSHList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.utf8FromList(vsList0, kMaxShortVF);
        final bytes0 = Bytes.ascii(vsList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodSHList) {
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

    test('SH isValidBytesArgs', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getSHList(1, i);
        final vfBytes = Bytes.utf8FromList(vList0);

        if (vList0.length == 1) {
          for (var tag in shVM1Tags) {
            final e0 = SH.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else {
          for (var tag in shVM1nTags) {
            final e0 = SH.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        }
      }
      final vList0 = rsg.getSHList(1, 1);
      final vfBytes = Bytes.utf8FromList(vList0);

      final e1 = SH.isValidBytesArgs(null, vfBytes);
      expect(e1, false);

      final e2 = SH.isValidBytesArgs(PTag.kDate, vfBytes);
      expect(e2, false);

      final e3 = SH.isValidBytesArgs(PTag.kSelectorSHValue, null);
      expect(e3, false);

      global.throwOnError = true;
      expect(() => SH.isValidBytesArgs(null, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => SH.isValidBytesArgs(PTag.kDate, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));
    });
  });
}
