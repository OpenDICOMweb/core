//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:convert' as cvt;

import 'package:bytes_dicom/bytes_dicom.dart';
import 'package:core/server.dart' hide group;
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = RSG(seed: 1);

void main() {
  Server.initialize(name: 'string/uc_test', level: Level.info);
  global.throwOnError = false;

  const goodUCList = <List<String>>[
    <String>['2qVmo1AAD'],
    <String>['erty#4u'],
    <String>['2qVmo1AAD'],
    <String>['q.&*k']
  ];
  const badUCList = <List<String>>[
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

  group('UCtag', () {
    test('UC hasValidValues good values', () {
      for (final s in goodUCList) {
        global.throwOnError = false;
        final e0 = UCtag(PTag.kStrainDescription, s);
        expect(e0.hasValidValues, true);
      }

      global.throwOnError = false;
      final e0 = UCtag(PTag.kGeneticModificationsDescription, []);
      expect(e0.hasValidValues, true);
      expect(e0.values, equals(<String>[]));
    });

    test('UC hasValidValues bad values', () {
      for (final s in badUCList) {
        global.throwOnError = false;
        final e0 = UCtag(PTag.kStrainDescription, s);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => UCtag(PTag.kStrainDescription, s),
            throwsA(const TypeMatcher<StringError>()));
      }
      global.throwOnError = false;
      final e1 = UCtag(PTag.kGeneticModificationsDescription, null);
      expect(e1.hasValidValues, true);
      expect(e1.values, StringList.kEmptyList);

      global.throwOnError = true;
      expect(() => UCtag(PTag.kStrainDescription, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('UC hasValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        final e0 = UCtag(PTag.kStrainDescription, vList0);
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: ${e0.info}');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(3, 4);
        log.debug('$i: vList0: $vList0');

        global.throwOnError = false;
        final e1 = UCtag(PTag.kGeneticModificationsDescription, vList0);
        expect(e1, isNull);
        global.throwOnError = true;
        expect(() => UCtag(PTag.kGeneticModificationsDescription, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('UC update random', () {
      final e0 = UCtag(PTag.kGeneticModificationsDescription, []);
      expect(e0.update(['d^u:96P, azV']).values, equals(['d^u:96P, azV']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(3, 4);
        global.throwOnError = false;
        final e1 = UCtag(PTag.kGeneticModificationsDescription, vList0);
        expect(e1, isNull);
        final vList1 = rsg.getUCList(3, 4);
//        expect(e1.update(vList1).values, equals(vList1));
        expect(() => e1.update(vList1).values,
            throwsA(const TypeMatcher<NoSuchMethodError>()));
        global.throwOnError = true;
        expect(() => UCtag(PTag.kGeneticModificationsDescription, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('UC noValues random', () {
      final e0 = UCtag(PTag.kGeneticModificationsDescription, []);
      final UCtag ucNoValues = e0.noValues;
      expect(ucNoValues.values.isEmpty, true);
      log.debug('st0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        global.throwOnError = false;
        final e1 = UCtag(PTag.kGeneticModificationsDescription, vList0);
        final UCtag ucNoValues1 = e1.noValues;
        expect(ucNoValues1.values.isEmpty, true);

        final vList1 = rsg.getUCList(2, 4);
        global.throwOnError = false;
        final e2 = UCtag(PTag.kGeneticModificationsDescription, vList1);
        expect(e2, isNull);
        global.throwOnError = true;
        expect(() => UCtag(PTag.kGeneticModificationsDescription, vList1),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('UC copy random', () {
      final e0 = UCtag(PTag.kGeneticModificationsDescription, []);
      final UCtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(3, 4);
        global.throwOnError = false;
        final e2 = UCtag(PTag.kGeneticModificationsDescription, vList0);
        expect(e2, isNull);
        expect(() => e1.update(vList0).values,
            throwsA(const TypeMatcher<NoSuchMethodError>()));
        expect(() => e2.copy, throwsA(const TypeMatcher<NoSuchMethodError>()));

        global.throwOnError = true;
        expect(() => UCtag(PTag.kGeneticModificationsDescription, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('UC hashCode and == good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        final e0 = UCtag(PTag.kGeneticModificationsDescription, vList0);
        final e1 = UCtag(PTag.kGeneticModificationsDescription, vList0);
        log
          ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
          ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('UC hashCode and == bad values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        final e0 = UCtag(PTag.kGeneticModificationsDescription, vList0);
        final vList1 = rsg.getUCList(1, 1);
        final e1 = UCtag(PTag.kStrainDescription, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, false);
        expect(e0 == e1, false);

        final vList2 = rsg.getUCList(2, 3);
        final e2 = UCtag(PTag.kStrainDescription, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);
      }
    });

    test('UC valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        final e0 = UCtag(PTag.kStrainDescription, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('UC isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        final e0 = UCtag(PTag.kStrainDescription, vList0);
        expect(e0.tag.isValidLength(e0), true);
      }
    });

    test('UC checkValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        final e0 = UCtag(PTag.kStrainDescription, vList0);
        expect(e0.checkValues(e0.values), true);
        expect(e0.hasValidValues, true);
      }
    });

    test('UC checkValues bad values random', () {
      final vList0 = rsg.getUCList(1, 1);
      final e1 = UCtag(PTag.kStrainDescription, vList0);

      for (final s in badUCList) {
        global.throwOnError = false;
        expect(e1.checkValues(s), false);

        global.throwOnError = true;
        expect(
            () => e1.checkValues(s), throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('UC replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        final e0 = UCtag(PTag.kStrainDescription, vList0);
        final vList1 = rsg.getUCList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getUCList(1, 1);
      final e1 = UCtag(PTag.kStrainDescription, vList1);
      expect(e1.replace([]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = UCtag(PTag.kStrainDescription, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(<String>[]));
    });

    test('UC blank random', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getUCList(1, 1);
        final e0 = UCtag(PTag.kStrainDescription, vList1);
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

    test('UC fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getUCList(1, 1);
        final bytes = Bytes.fromUtf8List(vList1);
        log.debug('bytes:$bytes');
        final e0 = UCtag.fromBytes(PTag.kStrainDescription, bytes, utf8);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);
      }
    });

    test('UC fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getUCList(1, 10);
        for (final listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          //final bytes0 = Bytes();
          final e1 = UCtag.fromBytes(PTag.kSelectorUCValue, bytes0, utf8);
          log.debug('e1: ${e1.info}');
          expect(e1.hasValidValues, true);
        }
      }
    });

    test('UC fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getUCList(1, 10);
        for (final listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.fromAscii(listS);
          //final bytes0 = Bytes();
          final e1 = UCtag.fromBytes(PTag.kSelectorCSValue, bytes0, utf8);
          expect(e1, isNull);

          global.throwOnError = true;
          expect(() => UCtag.fromBytes(PTag.kSelectorCSValue, bytes0, utf8),
              throwsA(const TypeMatcher<InvalidTagError>()));
        }
      }
    });

    test('UC fromValues good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        final e0 = UCtag.fromValues(PTag.kStrainDescription, vList0);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);

        final e1 = UCtag.fromValues(PTag.kStrainDescription, <String>[]);
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(<String>[]));
      }
    });

    test('UC fromValues bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(2, 2);
        global.throwOnError = false;
        final e0 = UCtag.fromValues(PTag.kStrainDescription, vList0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => UCtag.fromValues(PTag.kStrainDescription, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final e1 = UCtag.fromValues(PTag.kStrainDescription, <String>[null]);
      log.debug('mak1: $e1');
      expect(e1, isNull);

      global.throwOnError = true;
      expect(() => UCtag.fromValues(PTag.kStrainDescription, <String>[null]),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('UC checkLength good values', () {
      final vList0 = rsg.getUCList(1, 1);
      final e0 = UCtag(PTag.kStrainDescription, vList0);
      for (final s in goodUCList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = UCtag(PTag.kStrainDescription, vList0);
      expect(e1.checkLength([]), true);
    });

    test('UC checkLength bad values', () {
      final vList1 = ['a^1sd', '02@#'];
      global.throwOnError = false;
      final e2 = UCtag(PTag.kStrainDescription, vList1);
      expect(e2, isNull);
      expect(() => e2.checkLength(vList1),
          throwsA(const TypeMatcher<NoSuchMethodError>()));
    });

    test('UC checkValue good values', () {
      final vList0 = rsg.getUCList(1, 1);
      final e0 = UCtag(PTag.kStrainDescription, vList0);
      for (final s in goodUCList) {
        for (final a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });

    test('UC checkValue bad values', () {
      final vList0 = rsg.getUCList(1, 1);
      final e0 = UCtag(PTag.kStrainDescription, vList0);
      for (final s in badUCList) {
        for (final a in s) {
          global.throwOnError = false;
          expect(e0.checkValue(a), false);

          global.throwOnError = true;
          expect(() => e0.checkValue(a),
              throwsA(const TypeMatcher<StringError>()));
        }
      }
    });

    test('UC append', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 4);
        final e0 = UCtag(PTag.kSelectorUCValue, vList0);
        const vList1 = 'foo';
        final append0 = e0.append(vList1);
        log.debug('append0: $append0');
        expect(append0, isNotNull);

        final append1 = e0.values.append(vList1, e0.maxValueLength);
        log.debug('e0.append: $append1');
        expect(append0, equals(append1));
      }
    });

    test('UC prepend', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 4);
        final e0 = UCtag(PTag.kSelectorUCValue, vList0);
        const vList1 = 'foo';
        final prepend0 = e0.prepend(vList1);
        log.debug('prepend0: $prepend0');
        expect(prepend0, isNotNull);

        final prepend1 = e0.values.prepend(vList1, e0.maxValueLength);
        log.debug('e0.prepend: $prepend1');
        expect(prepend0, equals(prepend1));
      }
    });

    test('UC truncate', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 4, 16);
        final e0 = UCtag(PTag.kSelectorUCValue, vList0);
        final truncate0 = e0.truncate(10);
        log.debug('truncate0: $truncate0');
        expect(truncate0, isNotNull);
      }
    });

    test('UC match', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 10);
        final e0 = UCtag(PTag.kSelectorUCValue, vList0);
        final match0 = e0.match(r'.*');
        expect(match0, true);
      }
    });

    test('UC valueFromBytes', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getUCList(1, i);
        final bytes = Bytes.fromUtf8List(vList0);
        final e0 = UCtag(PTag.kSelectorUCValue, vList0);
        final vfb0 = e0.valuesFromBytes(bytes);
        expect(vfb0, equals(vList0));
      }
    });

    test('UC check', () {
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getUCList(1, 1);
        final e0 = UCtag(PTag.kStrainDescription, vList);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList[0]));
      }

      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getUCList(1, i);
        final e0 = UCtag(PTag.kSelectorUCValue, vList1);
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);
        expect(e0[0], equals(vList1[0]));
      }
    });

    test('UC valuesEqual good values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getUCList(1, 1);
        final e0 = UCtag(PTag.kSelectorUCValue, vList);
        final e1 = UCtag(PTag.kSelectorUCValue, vList);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), true);
      }
    });

    test('UC valuesEqual bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getUCList(1, i);
        final vList1 = rsg.getUCList(1, 1);
        final e0 = UCtag(PTag.kSelectorUCValue, vList0);
        final e1 = UCtag(PTag.kSelectorUCValue, vList1);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), false);
      }
    });

    test('UC fromValueField', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        log.debug('vList0: $vList0');
        final fvf0 = AsciiString.fromValueField(vList0, k8BitMaxLongVF);
        expect(fvf0, equals(vList0));
      }

      for (var i = 1; i < 10; i++) {
        global.throwOnError = false;
        final vList1 = rsg.getUCList(1, i);
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
      final bytes = Bytes.fromUtf8List(vList2);
      final fvf4 = AsciiString.fromValueField(bytes, k8BitMaxLongLength);
      expect(fvf4, equals(vList2));
    });
  });

  group('UC', () {
    //VM.k1
    const ucVM1Tags = <PTag>[
      PTag.kStrainDescription,
      PTag.kGeneticModificationsDescription,
    ];

    //VM.k1_n
    const ucVM1nTags = <PTag>[
      PTag.kSelectorUCValue,
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
      PTag.kTime,
      PTag.kAddressTrial
    ];

    final invalidVList = rsg.getUCList(5000, 5000);

    test('UC isValidTag good values', () {
      global.throwOnError = false;
      expect(UC.isValidTag(PTag.kSelectorUCValue), true);

      for (final tag in ucVM1Tags) {
        final validT0 = UC.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('UC isValidTag bad values', () {
      global.throwOnError = false;
      expect(UC.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => UC.isValidTag(PTag.kSelectorFDValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (final tag in otherTags) {
        global.throwOnError = false;
        final validT0 = UC.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => UC.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('UC isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(UC.isValidVRIndex(kUCIndex), true);

      for (final tag in ucVM1Tags) {
        global.throwOnError = false;
        expect(UC.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('UC isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(UC.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => UC.isValidVRIndex(kCSIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (final tag in otherTags) {
        global.throwOnError = false;
        expect(UC.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => UC.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('UC isValidVRCode good values', () {
      global.throwOnError = false;
      expect(UC.isValidVRCode(kUCCode), true);

      for (final tag in ucVM1Tags) {
        expect(UC.isValidVRCode(tag.vrCode), true);
      }
    });

    test('UC isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(UC.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => UC.isValidVRCode(kAECode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (final tag in otherTags) {
        global.throwOnError = false;
        expect(UC.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => UC.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('UC isValidVFLength good values', () {
      expect(UC.isValidVFLength(UC.kMaxVFLength), true);
      expect(UC.isValidVFLength(0), true);

      expect(UC.isValidVFLength(UC.kMaxVFLength, null, PTag.kSelectorUCValue),
          true);
    });

    test('UC isValidVFLength bad values', () {
      expect(UC.isValidVFLength(UC.kMaxVFLength + 1), false);
      expect(UC.isValidVFLength(-1), false);
    });

    test('UC isValidValueLength good values', () {
      for (final s in goodUCList) {
        for (final a in s) {
          expect(UC.isValidValueLength(a), true);
        }
      }

      expect(UC.isValidValueLength('a'), true);
      expect(UC.isValidValueLength(''), true);
    });

    test('UC isValidLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getUCList(1, 1);
        for (final tag in ucVM1Tags) {
          expect(UC.isValidLength(tag, vList), true);

          expect(UC.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(UC.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('UC isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getUCList(2, i + 1);
        for (final tag in ucVM1Tags) {
          global.throwOnError = false;
          expect(UC.isValidLength(tag, vList), false);

          expect(UC.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => UC.isValidLength(tag, vList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
      global.throwOnError = false;
      final vList0 = rsg.getUCList(1, 1);
      expect(UC.isValidLength(null, vList0), false);

      expect(UC.isValidLength(PTag.kSelectorUCValue, null), isNull);

      global.throwOnError = true;
      expect(() => UC.isValidLength(null, vList0),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => UC.isValidLength(PTag.kSelectorUCValue, null),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('UC isValidLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getUCList(1, i);
        for (final tag in ucVM1nTags) {
          log.debug('tag: $tag');
          expect(UC.isValidLength(tag, vList0), true);
        }
      }
    });

    test('UC isValidValue good values', () {
      for (final s in goodUCList) {
        for (final a in s) {
          expect(UC.isValidValue(a), true);
        }
      }
    });

    test('UC isValidValue bad values', () {
      for (final s in badUCList) {
        for (final a in s) {
          global.throwOnError = false;
          expect(UC.isValidValue(a), false);

          global.throwOnError = true;
          expect(() => UC.isValidValue(a),
              throwsA(const TypeMatcher<StringError>()));
        }
      }
    });

    test('UC isValidValues good values', () {
      global.throwOnError = false;
      for (final s in goodUCList) {
        expect(UC.isValidValues(PTag.kStrainDescription, s), true);
      }
    });

    test('UC isValidValues bad values', () {
      for (final s in badUCList) {
        global.throwOnError = false;
        expect(UC.isValidValues(PTag.kStrainDescription, s), false);

        global.throwOnError = true;
        expect(() => UC.isValidValues(PTag.kStrainDescription, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('UC toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        global.throwOnError = false;
        final values = cvt.ascii.encode(vList0[0]);
        final tbd0 = Bytes.fromUtf8List(vList0);
        final tbd1 = Bytes.fromUtf8List(vList0);
        log.debug('tbd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (final s in goodUCList) {
        for (final a in s) {
          final values = cvt.ascii.encode(a);
          final tbd2 = Bytes.fromUtf8List(s);
          final tbd3 = Bytes.fromUtf8List(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('UC fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.fromUtf8List(vList0);
        final fbd0 = bd0.getUtf8List();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (final s in goodUCList) {
        final bd0 = Bytes.fromUtf8List(s);
        final fbd0 = bd0.getUtf8List();
        expect(fbd0, equals(s));
      }
    });

    test('UC fromBytes', () {
      //     system.level = Level.info;
      final vList1 = rsg.getUCList(1, 1);
      final bytes = Bytes.fromUtf8List(vList1);
      log.debug('UC.fromBytes(bytes):  $bytes');
      expect(bytes.getUtf8List(), equals(vList1));
    });

    test('UC toUint8List', () {
      final vList1 = rsg.getUCList(1, 1);
      log.debug('Bytes.fromUtf8List(vList1): ${Bytes.fromUtf8List(vList1)}');

      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = cvt.ascii.encode(vList1[0]);
      expect(Bytes.fromUtf8List(vList1), equals(values));
    });

    test('UC isValidValues good values', () {
      global.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList = rsg.getUCList(1, 1);
        expect(UC.isValidValues(PTag.kStrainDescription, vList), true);
      }

      final vList0 = ['!mSMXWVy`]/Du'];
      expect(UC.isValidValues(PTag.kStrainDescription, vList0), true);

      for (final s in goodUCList) {
        global.throwOnError = false;
        expect(UC.isValidValues(PTag.kStrainDescription, s), true);
      }
    });

    test('UC isValidValues bad values', () {
      global.throwOnError = false;
      final vList1 = ['\b'];
      expect(UC.isValidValues(PTag.kStrainDescription, vList1), false);

      global.throwOnError = true;
      expect(() => UC.isValidValues(PTag.kStrainDescription, vList1),
          throwsA(const TypeMatcher<StringError>()));

      for (final s in badUCList) {
        global.throwOnError = false;
        expect(UC.isValidValues(PTag.kStrainDescription, s), false);

        global.throwOnError = true;
        expect(() => UC.isValidValues(PTag.kStrainDescription, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('UC toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 10);
        global.throwOnError = false;
        final toB0 = BytesDicom.fromUtf8List(vList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(vList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (final s in goodUCList) {
        final toB1 = BytesDicom.fromUtf8List(s, kMaxShortVF);
        final bytes1 = Bytes.fromAscii(s.join('\\'));
        log.debug('toBytes:$toB1, bytes1: $bytes1');
        expect(toB1, equals(bytes1));
      }

      global.throwOnError = false;
      final toB2 = BytesDicom.fromUtf8List([''], kMaxShortVF);
      expect(toB2, equals(<String>[]));

      final toB3 = BytesDicom.fromUtf8List([], kMaxShortVF);
      expect(toB3, equals(<String>[]));

      final toB4 = BytesDicom.fromUtf8List(null, kMaxShortVF);
      expect(toB4, isNull);

      global.throwOnError = true;
      expect(() => BytesDicom.fromUtf8List(null, kMaxShortVF),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('UC isValidBytesArgs', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getUCList(1, i);
        final vfBytes = Bytes.fromUtf8List(vList0);

        if (vList0.length == 1) {
          for (final tag in ucVM1Tags) {
            final e0 = UC.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else {
          for (final tag in ucVM1nTags) {
            final e0 = UC.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        }
      }
      final vList0 = rsg.getUCList(1, 1);
      final vfBytes = Bytes.fromUtf8List(vList0);

      final e1 = UC.isValidBytesArgs(null, vfBytes);
      expect(e1, false);

      final e2 = UC.isValidBytesArgs(PTag.kDate, vfBytes);
      expect(e2, false);

      final e3 = UC.isValidBytesArgs(PTag.kSelectorUCValue, null);
      expect(e3, false);

      global.throwOnError = true;
      expect(() => UC.isValidBytesArgs(null, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => UC.isValidBytesArgs(PTag.kDate, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));
    });
  });
}
