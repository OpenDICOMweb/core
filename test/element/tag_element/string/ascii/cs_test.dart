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
RNG rng = RNG(1);

void main() {
  Server.initialize(name: 'string/cs_test', level: Level.info);
  global.throwOnError = false;

  const goodCSList = <List<String>>[
    <String>['KEZ5HZZZR2'],
    <String>['LUA '],
    <String>['DAP3Q'],
    <String>['GAEGBPO'],
    <String>['EGM_']
  ];

  const badCSList = <List<String>>[
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
    <String>['T 2@+nEZKu/J'],
    <String>['123.45']
  ];
  group('CStag', () {
    test('CS hasValidValues good values', () {
      for (var s in goodCSList) {
        global.throwOnError = false;
        final e0 = CStag(PTag.kLaterality, s);
        expect(e0.hasValidValues, true);
      }
      global.throwOnError = false;
      final e0 = CStag(PTag.kMaskingImage, []);
      expect(e0.hasValidValues, true);
      expect(e0.values, equals(<String>[]));
    });

    test('CS hasValidValues bad values', () {
      for (var s in badCSList) {
        global.throwOnError = false;
        final e0 = CStag(PTag.kLaterality, s);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => CStag(PTag.kLaterality, s),
            throwsA(const TypeMatcher<StringError>()));
      }

      global.throwOnError = false;
      final e1 = CStag(PTag.kMaskingImage, null);
      log.debug('e1: $e1');
      expect(e1, StringList.kEmptyList);

      global.throwOnError = true;
      expect(() => CStag(PTag.kLaterality, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('CS hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1, 2, 16);
        final e0 = CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
        log.debug('e0:${e0.info}');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: ${e0.info}');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(2, 2);
        final e1 = CStag(PTag.kPatientOrientation, vList0);
        expect(e1.hasValidValues, true);

        log..debug('e1: $e1, values: ${e1.values}')..debug('e1: ${e1.info}');
        expect(e1[0], equals(vList0[0]));
      }
    });

    test('CS hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getCSList(3, 4);
        log.debug('$i: vList0: $vList0');
        final e2 = CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
        expect(e2, isNull);
      }
    });

    test('CS update random', () {
      final e0 = CStag(PTag.kMaskingImage, []);
      expect(e0.update(['325435', '4545']).values, equals(['325435', '4545']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(3, 4);
        final e1 = CStag(PTag.kMaskingImage, vList0);
        final vList1 = rsg.getCSList(3, 4);
        expect(e1.update(vList1).values, equals(vList1));
      }
    });

    test('CS noValues random', () {
      final e0 = CStag(PTag.kMaskingImage, []);
      final CStag csNoValues = e0.noValues;
      expect(csNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(3, 4);
        final e0 = CStag(PTag.kMaskingImage, vList0);
        log.debug('e0: $e0');
        expect(csNoValues.values.isEmpty, true);
        log.debug('ae0: ${e0.noValues}');
      }
    });

    test('CS copy random', () {
      final e0 = CStag(PTag.kMaskingImage, []);
      final CStag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(3, 4);
        final e2 = CStag(PTag.kMaskingImage, vList0);
        final CStag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('CS hashCode and == good values random', () {
      List<String> vList0;
      for (var i = 0; i < 10; i++) {
        vList0 = rsg.getCSList(1, 1);
        final e0 = CStag(PTag.kLaterality, vList0);
        final e1 = CStag(PTag.kLaterality, vList0);
        log
          ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
          ..debug('vList0:$vList0, ds1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('CS hashCode and == bad values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        final e0 = CStag(PTag.kLaterality, vList0);

        final vList1 = rsg.getCSList(1, 1);
        final ae2 = CStag(PTag.kImageLaterality, vList1);
        log.debug('vList1:$vList1 , ae2.hash_code:${ae2.hashCode}');
        expect(e0.hashCode == ae2.hashCode, false);
        expect(e0 == ae2, false);

        final vList2 = rsg.getCSList(2, 2);
        final e3 = CStag(PTag.kPatientOrientation, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);

        final vList3 = rsg.getCSList(4, 4);
        final e4 = CStag(PTag.kFrameType, vList3);
        log.debug('vList3:$vList3 , e4.hash_code:${e4.hashCode}');
        expect(e0.hashCode == e4.hashCode, false);
        expect(e0 == e4, false);

        final vList4 = rsg.getCSList(2, 3);
        final e5 = CStag(PTag.kLaterality, vList4);
        log.debug('vList4:$vList4 , e5.hash_code:${e5.hashCode}');
        expect(e0.hashCode == e5.hashCode, false);
        expect(e0 == e5, false);
      }
    });

    test('CS valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        final e0 = CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('CS isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        final e0 = CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
        expect(e0.tag.isValidLength(e0), true);
      }
    });

    test('CS checkValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        final e0 = CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
        expect(e0.checkValues(e0.values), true);
        expect(e0.hasValidValues, true);
      }
    });

    test('CS checkValues bad values random', () {
      final vList0 = rsg.getCSList(1, 1);
      final e1 = CStag(PTag.kGeometryOfKSpaceTraversal, vList0);

      for (var s in badCSList) {
        global.throwOnError = false;
        expect(e1.checkValues(s), false);

        global.throwOnError = true;
        expect(
            () => e1.checkValues(s), throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('CS replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        final e0 = CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
        final vList1 = rsg.getCSList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getCSList(1, 1);
      final e1 = CStag(PTag.kGeometryOfKSpaceTraversal, vList1);
      expect(e1.replace([]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = CStag(PTag.kGeometryOfKSpaceTraversal, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(<String>[]));
    });

    test('CS formBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getCSList(1, 1);
        final bytes = Bytes.asciiFromList(vList1);
        log.debug('bytes:$bytes');
        final e1 = CStag.fromBytes(PTag.kGeometryOfKSpaceTraversal, bytes);
        log.debug('e1: ${e1.info}');
        expect(e1.hasValidValues, true);
      }
    });

    test('CS fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getCSList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.ascii(listS);
          final e1 = CStag.fromBytes(PTag.kSelectorCSValue, bytes0);
          log.debug('e1: ${e1.info}');
          expect(e1.hasValidValues, true);
        }
      }
    });

    test('CS fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getCSList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.ascii(listS);
          final e1 = CStag.fromBytes(PTag.kSelectorAEValue, bytes0);
          expect(e1, isNull);

          global.throwOnError = true;
          expect(() => CStag.fromBytes(PTag.kSelectorAEValue, bytes0),
              throwsA(const TypeMatcher<InvalidTagError>()));
        }
      }
    });

    test('CS fromValues good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        final e0 = CStag.fromValues(PTag.kGeometryOfKSpaceTraversal, vList0);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);

        final e1 =
            CStag.fromValues(PTag.kGeometryOfKSpaceTraversal, <String>[]);
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(<String>[]));
      }
    });

    test('CS fromValues bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(2, 2);
        global.throwOnError = false;
        final e0 = CStag.fromValues(PTag.kGeometryOfKSpaceTraversal, vList0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => CStag.fromValues(PTag.kGeometryOfKSpaceTraversal, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final e1 =
          CStag.fromValues(PTag.kGeometryOfKSpaceTraversal, <String>[null]);
      log.debug('e1: $e1');
      expect(e1, isNull);

      global.throwOnError = true;
      expect(
          () => CStag.fromValues(
              PTag.kScheduledStudyLocationAETitle, <String>[null]),
          throwsA(const TypeMatcher<InvalidTagError>()));
    });

    test('CS checkLength good values', () {
      final vList0 = rsg.getCSList(1, 1);
      final e0 = CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
      for (var s in goodCSList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
      expect(e1.checkLength([]), true);
    });

    test('CS checkLength bad values', () {
      final vList0 = rsg.getCSList(1, 1);
      final vList1 = ['KEZ5HZZZR2', 'LSDKFJIE34D'];
      final e2 = CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
      expect(e2.checkLength(vList1), false);
    });

    test('CS checkValue good values', () {
      final vList0 = rsg.getCSList(1, 1);
      final e0 = CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
      for (var s in goodCSList) {
        for (var a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });

    test('CS checkValue bad values', () {
      final vList0 = rsg.getCSList(1, 1);
      final e0 = CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
      for (var s in badCSList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(e0.checkValue(a), false);

          global.throwOnError = true;
          expect(() => e0.checkValue(a),
              throwsA(const TypeMatcher<StringError>()));
        }
      }
    });

    test('CS append', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 4);
        final e0 = CStag(PTag.kSelectorCSValue, vList0);
        const vList1 = 'FOO';
        final append0 = e0.append(vList1);
        log.debug('append0: $append0');
        expect(append0, isNotNull);
      }
    });

    test('CS prepend', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 4);
        final e0 = CStag(PTag.kSelectorCSValue, vList0);
        const vList1 = 'FOO';
        final prepend0 = e0.prepend(vList1);
        log.debug('prepend0: $prepend0');
        expect(prepend0, isNotNull);
      }
    });

    test('CS truncate', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 4, 16);
        final e0 = CStag(PTag.kSelectorCSValue, vList0);
        final truncate0 = e0.truncate(10);
        log.debug('truncate0: $truncate0');
        expect(truncate0, isNotNull);
      }
    });

    test('CS match', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getCSList(1, i, 16);
        log.debug('vList0: $vList0');
        final e0 = CStag(PTag.kSelectorCSValue, vList0);
        const regX = r'\w*[A-Z_0-9\s]';
        final match0 = e0.match(regX);
        expect(match0, true);
      }
    });

    test('CS valueFromBytes', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getCSList(1, i);
        final bytes = Bytes.utf8FromList(vList0);
        final e0 = CStag(PTag.kSelectorCSValue, vList0);
        final vfb0 = e0.valuesFromBytes(bytes);
        expect(vfb0, equals(vList0));
      }
    });

    test('CS check', () {
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getCSList(1, 1);
        final e0 = CStag(PTag.kMappingResource, vList);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList[0]));
      }

      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getCSList(2, 2);
        final e0 = CStag(PTag.kSeriesType, vList1);
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);
        expect(e0[0], equals(vList1[0]));
      }
    });

    test('CS valuesEqual good values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getCSList(1, 1);
        final e0 = CStag(PTag.kSelectorCSValue, vList);
        final e1 = CStag(PTag.kSelectorCSValue, vList);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), true);
      }
    });

    test('CS valuesEqual bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getCSList(1, i);
        final vList1 = rsg.getCSList(1, 1);
        final e0 = CStag(PTag.kSelectorCSValue, vList0);
        final e1 = CStag(PTag.kSelectorCSValue, vList1);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), false);
      }
    });
  });

  group('CS', () {
    //VM.k1
    const csVM1Tags = <PTag>[
      PTag.kFileSetID,
      PTag.kConversionType,
      PTag.kPresentationIntentType,
      PTag.kMappingResource,
      //PTag.kFileSetDescriptorFileID,//vm.k1_8
      PTag.kFieldOfViewShape,
      PTag.kRadiationSetting,
    ];

    //VM.k2
    const csVM2Tags = <PTag>[
      PTag.kPatientOrientation,
      PTag.kReportStatusIDTrial,
      PTag.kSeriesType,
      PTag.kDisplaySetPatientOrientation
    ];

    //VM.k2_n
    const csVM2nTags = <PTag>[PTag.kImageType];

    //VM.k4
    const csVM4Tags = <PTag>[
      PTag.kFrameType,
    ];

    //VM.k1_n
    const csVM1nTags = <PTag>[
      PTag.kModalitiesInStudy,
      PTag.kIndicationType,
      PTag.kScanningSequence,
      PTag.kSequenceVariant,
      PTag.kScanOptions,
      PTag.kGrid,
      PTag.kFilterMaterial,
      PTag.kSelectorCSValue,
    ];

    const otherTags = <PTag>[
      PTag.kColumnAngulationPatient,
      PTag.kAcquisitionProtocolDescription,
      PTag.kCTDIvol,
      PTag.kCTPositionSequence,
      PTag.kPatientAge,
      PTag.kPerformedStationAETitle,
      PTag.kSelectorSTValue,
      PTag.kDate,
      PTag.kTime
    ];

    final invalidVList = rsg.getCSList(CS.kMaxLength + 1, CS.kMaxLength + 1);

    test('CS isValidTag good values', () {
      global.throwOnError = false;
      expect(CS.isValidTag(PTag.kSelectorCSValue), true);

      for (var tag in csVM1Tags) {
        final validT0 = CS.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('CS isValidTag bad values', () {
      global.throwOnError = false;
      expect(CS.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => CS.isValidTag(PTag.kSelectorFDValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = CS.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => CS.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('CS isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(CS.isValidVRIndex(kCSIndex), true);

      for (var tag in csVM1Tags) {
        global.throwOnError = false;
        expect(CS.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('CS isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(CS.isValidVRIndex(kSSIndex), false);

      global.throwOnError = true;
      expect(() => CS.isValidVRIndex(kSSIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(CS.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => CS.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('CS isValidVRCode good values', () {
      global.throwOnError = false;
      expect(CS.isValidVRCode(kCSCode), true);

      for (var tag in csVM1Tags) {
        expect(CS.isValidVRCode(tag.vrCode), true);
      }
    });

    test('CS isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(CS.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => CS.isValidVRCode(kAECode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(CS.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => CS.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('CS sValidVFLength good values', () {
      expect(CS.isValidVFLength(CS.kMaxVFLength), true);
      expect(CS.isValidVFLength(0), true);

      expect(CS.isValidVFLength(CS.kMaxVFLength, null, PTag.kSelectorCSValue),
          true);
    });

    test('CS sValidVFLength bad values', () {
      expect(CS.isValidVFLength(CS.kMaxVFLength + 1), false);
      expect(CS.isValidVFLength(-1), false);
    });

    test('CS.isValidValueLength', () {
      global.throwOnError = false;
      for (var s in goodCSList) {
        for (var a in s) {
          expect(CS.isValidValueLength(a), true);
        }
      }

      /* for (var s in badAELengthList) {
          expect(CS.isValidValueLength(s), false);
        }*/

      expect(CS.isValidValueLength('&t&wSB)~PIA!UIDX'), true);

      expect(
          CS.isValidValueLength(
              '&t&wSB)~PIA!UIDX }d!zD2N3 2fz={@^mHL:/"qzD2N3 2fzLzgGEH6bTY&N}JzD2N3 2fz'),
          false);
    });

    test('CS isValidVListLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getCSList(1, 1);
        for (var tag in csVM1Tags) {
          expect(CS.isValidLength(tag, vList), true);

          expect(CS.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(CS.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('CS isValidVListLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getCSList(2, i + 1);
        for (var tag in csVM1Tags) {
          global.throwOnError = false;
          expect(CS.isValidLength(tag, vList), false);

          expect(CS.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => CS.isValidLength(tag, vList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
      global.throwOnError = false;
      final vList0 = rsg.getCSList(1, 1);
      expect(CS.isValidLength(null, vList0), false);

      expect(CS.isValidLength(PTag.kSelectorUCValue, null), isNull);

      global.throwOnError = true;
      expect(() => CS.isValidLength(null, vList0),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => CS.isValidLength(PTag.kSelectorUCValue, null),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('CS isValidVListLength VM.k2 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getCSList(2, 2);
        for (var tag in csVM2Tags) {
          expect(CS.isValidLength(tag, vList), true);

          expect(CS.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(CS.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('CS isValidVListLength VM.k2 bad values', () {
      for (var i = 2; i < 10; i++) {
        final vList = rsg.getCSList(3, i + 1);
        for (var tag in csVM2Tags) {
          global.throwOnError = false;
          expect(CS.isValidLength(tag, vList), false);

          expect(
              CS.isValidLength(tag, invalidVList.take(tag.vmMax + 1)), false);
          expect(
              CS.isValidLength(tag, invalidVList.take(tag.vmMin - 1)), false);

          expect(CS.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => CS.isValidLength(tag, vList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('CS isValidVListLength VM.k2_2n good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getCSList(10, 10);
        final validMaxLengthList = invalidVList.sublist(0, CS.kMaxLength);
        for (var tag in csVM2nTags) {
          expect(CS.isValidLength(tag, vList), true);
          expect(CS.isValidLength(tag, validMaxLengthList), true);
        }
      }
    });

    test('CS isValidVListLength VM.k2_2n bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getCSList(1, 1);
        for (var tag in csVM2nTags) {
          global.throwOnError = false;
          expect(CS.isValidLength(tag, vList), false);

          expect(
              CS.isValidLength(tag, invalidVList.take(tag.vmMax + 2)), false);
          global.throwOnError = true;
          expect(() => CS.isValidLength(tag, vList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('CS isValidVListLength VM.k4 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getCSList(4, 4);
        for (var tag in csVM4Tags) {
          expect(CS.isValidLength(tag, vList), true);

          expect(CS.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(CS.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('CS isValidVListLength VM.k4 bad values', () {
      for (var i = 4; i < 10; i++) {
        final vList = rsg.getCSList(5, i + 1);
        for (var tag in csVM4Tags) {
          global.throwOnError = false;
          expect(CS.isValidLength(tag, vList), false);

          expect(
              CS.isValidLength(tag, invalidVList.take(tag.vmMax + 1)), false);
          expect(
              CS.isValidLength(tag, invalidVList.take(tag.vmMin - 1)), false);
          expect(CS.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => CS.isValidLength(tag, vList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
      global.throwOnError = false;
      final vList0 = rsg.getCSList(1, 1);
      expect(CS.isValidLength(null, vList0), false);

      expect(CS.isValidLength(PTag.kSelectorCSValue, null), isNull);

      global.throwOnError = true;
      expect(() => CS.isValidLength(null, vList0),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => CS.isValidLength(PTag.kSelectorCSValue, null),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('CS isValidVListLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getCSList(1, i);
        final validMaxLengthList = invalidVList.sublist(0, CS.kMaxLength);
        for (var tag in csVM1nTags) {
          log.debug('tag: $tag');
          expect(CS.isValidLength(tag, vList0), true);
          expect(CS.isValidLength(tag, validMaxLengthList), true);
        }
      }
    });

    test('CS isValidValue good values', () {
      for (var s in goodCSList) {
        for (var a in s) {
          expect(CS.isValidValue(a), true);
        }
      }
    });

    test('CS isValidValue bad values', () {
      for (var s in badCSList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(CS.isValidValue(a), false);

          global.throwOnError = true;
          expect(() => CS.isValidValue(a),
              throwsA(const TypeMatcher<StringError>()));
        }
      }
    });

    test('CS isValidValues good values', () {
      global.throwOnError = false;
      for (var s in goodCSList) {
        expect(CS.isValidValues(PTag.kSCPStatus, s), true);
      }
    });

    test('CS isValidValues bad values', () {
      for (var s in badCSList) {
        global.throwOnError = false;
        expect(CS.isValidValues(PTag.kSCPStatus, s), false);

        global.throwOnError = true;
        expect(() => CS.isValidValues(PTag.kSCPStatus, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('CS fromBytes', () {
      //  system.level = Level.info;;
      final vList1 = rsg.getCSList(1, 1);
      final bytes = Bytes.asciiFromList(vList1);
      log.debug('bytes.getAsciiList(): ${bytes.stringListFromAscii()}, '
          'bytes: $bytes');
      expect(bytes.stringListFromAscii(), equals(vList1));
    });

    test('CS Bytes.fromAsciiList', () {
      final vList1 = rsg.getCSList(1, 1);
      log.debug('Bytes.fromAsciiList(vList1): ${Bytes.asciiFromList(vList1)}');
      final val = cvt.ascii.encode('s6V&:;s%?Q1g5v');
      expect(Bytes.asciiFromList(['s6V&:;s%?Q1g5v']), equals(val));

      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = cvt.ascii.encode(vList1[0]);
      expect(Bytes.asciiFromList(vList1), equals(values));
    });

    test('CS fromValueField', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        log.debug('vList0: $vList0');
        final fvf0 = Ascii.fromValueField(vList0, k8BitMaxLongVF);
        expect(fvf0, equals(vList0));
      }

      for (var i = 1; i < 10; i++) {
        global.throwOnError = false;
        final vList1 = rsg.getCSList(1, i);
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

      final vList3 = rng.uint8List(1, 1);
      final fvf5 = Ascii.fromValueField(vList3, k8BitMaxLongLength);
      expect(fvf5, equals([cvt.ascii.decode(vList3)]));
    });

    test('CS isValidValues good values', () {
      global.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList = rsg.getCSList(1, 1);
        expect(CS.isValidValues(PTag.kSCPStatus, vList), true);
      }

      final vList0 = ['KEZ5HZZZR2'];
      expect(CS.isValidValues(PTag.kSCPStatus, vList0), true);

      for (var s in goodCSList) {
        global.throwOnError = false;
        expect(CS.isValidValues(PTag.kSCPStatus, s), true);
      }
    });

    test('CS isValidValues bad values', () {
      global.throwOnError = false;
      final vList1 = ['\r'];
      expect(CS.isValidValues(PTag.kSCPStatus, vList1), false);

      global.throwOnError = true;
      expect(() => CS.isValidValues(PTag.kSCPStatus, vList1),
          throwsA(const TypeMatcher<StringError>()));
      for (var s in badCSList) {
        global.throwOnError = false;
        expect(CS.isValidValues(PTag.kSCPStatus, s), false);

        global.throwOnError = true;
        expect(() => CS.isValidValues(PTag.kSCPStatus, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('CS toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        global.throwOnError = false;
        final values = cvt.ascii.encode(vList0[0]);
        final tbd0 = Bytes.asciiFromList(vList0);
        final tbd1 = Bytes.asciiFromList(vList0);
        log.debug('tbd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodCSList) {
        for (var a in s) {
          final values = cvt.ascii.encode(a);
          final tbd2 = Bytes.asciiFromList(s);
          final tbd3 = Bytes.asciiFromList(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('CS fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.asciiFromList(vList0);
        final fbd0 = bd0.stringListFromAscii();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (var s in goodCSList) {
        final bd0 = Bytes.asciiFromList(s);
        final fbd0 = bd0.stringListFromAscii();
        expect(fbd0, equals(s));
      }
    });

    test('CS toBytes ', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.asciiFromList(vList0, kMaxShortVF);
        final bytes0 = Bytes.ascii(vList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodCSList) {
        final toB1 = Bytes.asciiFromList(s, kMaxShortVF);
        final bytes1 = Bytes.ascii(s.join('\\'));
        log.debug('toBytes:$toB1, bytes1: $bytes1');
        expect(toB1, equals(bytes1));
      }

      global.throwOnError = false;
      final toB2 = Bytes.asciiFromList([''], kMaxShortVF);
      expect(toB2, equals(<String>[]));

      final toB3 = Bytes.asciiFromList([], kMaxShortVF);
      expect(toB3, equals(<String>[]));

      final toB4 = Bytes.asciiFromList(null, kMaxShortVF);
      expect(toB4, isNull);

      global.throwOnError = true;
      expect(() => Bytes.asciiFromList(null, kMaxShortVF),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('CS isValidBytesArgs', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getCSList(1, i);
        final vfBytes = Bytes.utf8FromList(vList0);

        if (vList0.length == 1) {
          for (var tag in csVM1Tags) {
            final e0 = CS.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else if (vList0.length == 2) {
          for (var tag in csVM2Tags) {
            final e0 = CS.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else if (vList0.length == 4) {
          for (var tag in csVM4Tags) {
            final e0 = CS.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else {
          for (var tag in csVM1nTags) {
            final e0 = CS.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        }
      }
      final vList0 = rsg.getCSList(1, 1);
      final vfBytes = Bytes.utf8FromList(vList0);

      final e1 = CS.isValidBytesArgs(null, vfBytes);
      expect(e1, false);

      final e2 = CS.isValidBytesArgs(PTag.kDate, vfBytes);
      expect(e2, false);

      final e3 = CS.isValidBytesArgs(PTag.kSelectorCSValue, null);
      expect(e3, false);

      global.throwOnError = true;
      expect(() => CS.isValidBytesArgs(null, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => CS.isValidBytesArgs(PTag.kDate, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));
    });
  });
}
