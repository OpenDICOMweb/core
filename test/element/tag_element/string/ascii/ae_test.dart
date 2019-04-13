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
  Server.initialize(name: 'string/special_test', level: Level.info);
  global.throwOnError = false;

  const goodAEList = <List<String>>[
    <String>['d9E8tO'],
    <String>['mrZeo|^P> -6{t, '],
    <String>['mrZeo|^P> -6{t,'],
    <String>['1wd7'],
    <String>['mrZeo|^P> -6{t,']
  ];

  const badAEList = <List<String>>[
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
    <String>[r'^\?']
  ];

  group('AEtag', () {
    test('AE hasValidValues good values', () {
      for (final s in goodAEList) {
        global.throwOnError = false;
        final e1 = AEtag(PTag.kScheduledStudyLocationAETitle, s);
        expect(e1.hasValidValues, true);
      }

      global.throwOnError = false;
      final e1 = AEtag(PTag.kScheduledStudyLocationAETitle, []);
      expect(e1.hasValidValues, true);
      expect(e1.values, equals(<String>[]));
    });

    test('AE hasValidValues bad values', () {
      for (final s in badAEList) {
        global.throwOnError = false;
        final e1 = AEtag(PTag.kScheduledStudyLocationAETitle, s);
        expect(e1, isNull);

        global.throwOnError = true;
        expect(() => AEtag(PTag.kScheduledStudyLocationAETitle, s),
            throwsA(const TypeMatcher<StringError>()));
      }

      global.throwOnError = false;
      final e2 = AEtag(PTag.kScheduledStudyLocationAETitle, null);
      log.debug('e2: $e2');
      expect(e2.hasValidValues, true);
      expect(e2.values == StringList.kEmptyList, true);
    });

    test('AE hasValidValues random good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 10);
        final e1 = AEtag(PTag.kScheduledStudyLocationAETitle, vList0);
        log.debug('e1:${e1.info}');
        expect(e1.hasValidValues, true);

        log..debug('e1: $e1, values: ${e1.values}')..debug('e1: ${e1.info}');
        expect(e1[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final e2 = AEtag(PTag.kPerformedStationAETitle, vList0);
        expect(e2.hasValidValues, true);

        log..debug('e2: $e2, values: ${e2.values}')..debug('e2: ${e2.info}');
        expect(e2[0], equals(vList0[0]));
      }
    });

    test('AE hasValidValues random bad values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getAEList(3, 4);
        log.debug('$i: vList0: $vList0');
        final ae2 = AEtag(PTag.kPerformedStationAETitle, vList0);
        expect(ae2, isNull);
      }
    });

    test('AE update random', () {
      final e1 = AEtag(PTag.kScheduledStudyLocationAETitle, []);
      expect(e1.update(['325435', '4545']).values, equals(['325435', '4545']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(3, 4);
        final e2 = AEtag(PTag.kScheduledStudyLocationAETitle, vList0);
        final vList1 = rsg.getAEList(3, 4);
        expect(e2.update(vList1).values, equals(vList1));
      }
    });

    test('AE noValues random', () {
      final e1 = AEtag(PTag.kScheduledStudyLocationAETitle, []);
      final AEtag aeNoValues = e1.noValues;
      expect(aeNoValues.values.isEmpty, true);
      log.debug('e1: ${e1.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(3, 4);
        final e1 = AEtag(PTag.kScheduledStudyLocationAETitle, vList0);
        log.debug('e1: $e1');
        expect(aeNoValues.values.isEmpty, true);
        log.debug('e1: ${e1.noValues}');
      }
    });

    test('AE copy random', () {
      final e1 = AEtag(PTag.kScheduledStudyLocationAETitle, []);
      final AEtag e2 = e1.copy;
      expect(e2 == e1, true);
      expect(e2.hashCode == e1.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(3, 4);
        final ae2 = AEtag(PTag.kScheduledStudyLocationAETitle, vList0);
        final AEtag e3 = ae2.copy;
        expect(e3 == ae2, true);
        expect(e3.hashCode == ae2.hashCode, true);
      }
    });

    test('AE hashCode and == good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final e1 = AEtag(PTag.kScheduledStudyLocationAETitle, vList0);
        final e2 = AEtag(PTag.kScheduledStudyLocationAETitle, vList0);
        log
          ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}')
          ..debug('vList0:$vList0, ds1.hash_code:${e2.hashCode}');
        expect(e1.hashCode == e2.hashCode, true);
        expect(e1 == e2, true);
      }
    });

    test('AE hashCode and == bad values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final e1 = AEtag(PTag.kScheduledStudyLocationAETitle, vList0);

        final vList1 = rsg.getAEList(1, 1);
        final ae2 = AEtag(PTag.kPerformedStationAETitle, vList1);
        log.debug('vList1:$vList1 , ae2.hash_code:${ae2.hashCode}');
        expect(e1.hashCode == ae2.hashCode, false);
        expect(e1 == ae2, false);

        final vList2 = rsg.getAEList(2, 3);
        final e3 = AEtag(PTag.kPerformedStationAETitle, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e1.hashCode == e3.hashCode, false);
        expect(e1 == e3, false);
      }
    });

    test('AE valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final e1 = AEtag(PTag.kPerformedStationAETitle, vList0);
        expect(vList0, equals(e1.valuesCopy));
      }
    });

    test('AE isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final e1 = AEtag(PTag.kPerformedStationAETitle, vList0);
        expect(e1.tag.isValidLength(e1), true);
      }
    });

    test('AE checkValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final e1 = AEtag(PTag.kPerformedStationAETitle, vList0);
        expect(e1.checkValues(e1.values), true);
        expect(e1.hasValidValues, true);
      }
    });

    test('AE checkValues bad values random', () {
      final vList0 = rsg.getAEList(1, 1);
      final e1 = AEtag(PTag.kPerformedStationAETitle, vList0);

      for (final s in badAEList) {
        global.throwOnError = false;
        expect(e1.checkValues(s), false);

        global.throwOnError = true;
        expect(
            () => e1.checkValues(s), throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('AE replace random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final e1 = AEtag(PTag.kPerformedStationAETitle, vList0);
        final vList1 = rsg.getAEList(1, 1);
        expect(e1.replace(vList1), equals(vList0));
        log.debug('e1: ${e1.values}');
        expect(e1.values, equals(vList1));
      }

      final vList1 = rsg.getAEList(1, 1);
      final e2 = AEtag(PTag.kPerformedStationAETitle, vList1);
      expect(e2.replace([]), equals(vList1));
      expect(e2.values, equals(<String>[]));

      final ae2 = AEtag(PTag.kPerformedStationAETitle, vList1);
      expect(ae2.replace(null), equals(vList1));
      expect(ae2.values, equals(<String>[]));
    });

    test('AE fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getAEList(1, 1);
        final bytes = Bytes.asciiFromList(vList1);
        log.debug('bytes:$bytes');
        final e2 = AEtag.fromBytes(PTag.kPerformedStationAETitle, bytes);
        log.debug('e2: ${e2.info}');
        expect(e2.hasValidValues, true);
      }
    });

    test('AE fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getAEList(1, 10);
        for (final listS in vList1) {
          final bytes0 = Bytes.ascii(listS);
          //final bytes0 = Bytes();
          final e2 = AEtag.fromBytes(PTag.kSelectorAEValue, bytes0);
          log.debug('e2: ${e2.info}');
          expect(e2.hasValidValues, true);
        }
      }
    });

    test('AE fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getAEList(1, 10);
        for (final listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.ascii(listS);
          //final bytes0 = Bytes();
          final e2 = AEtag.fromBytes(PTag.kSelectorCSValue, bytes0);
          expect(e2, isNull);

          global.throwOnError = true;
          expect(() => AEtag.fromBytes(PTag.kSelectorCSValue, bytes0),
              throwsA(const TypeMatcher<InvalidTagError>()));
        }
      }
    });

    test('AE fromValues good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final e0 = AEtag.fromValues(PTag.kPerformedStationAETitle, vList0);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);

        final e1 =
            AEtag.fromValues(PTag.kScheduledStudyLocationAETitle, <String>[]);
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(<String>[]));
      }
    });

    test('AE fromValues bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(2, 2);
        global.throwOnError = false;
        final e0 = AEtag.fromValues(PTag.kPerformedStationAETitle, vList0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => AEtag.fromValues(PTag.kPerformedStationAETitle, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final e2 =
          AEtag.fromValues(PTag.kScheduledStudyLocationAETitle, <String>[null]);
      log.debug('e2: $e2');
      expect(e2, isNull);

      global.throwOnError = true;
      expect(
          () => AEtag.fromValues(
              PTag.kScheduledStudyLocationAETitle, <String>[null]),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('AE checkLength good values', () {
      final vList0 = rsg.getAEList(1, 1);
      final e1 = AEtag(PTag.kPerformedStationAETitle, vList0);
      for (final s in goodAEList) {
        expect(e1.checkLength(s), true);
      }
      final e2 = AEtag(PTag.kPerformedStationAETitle, vList0);
      expect(e2.checkLength([]), true);
    });

    test('AE checkLength bad values', () {
      final vList0 = rsg.getAEList(1, 1);
      final vList1 = ['325435', '325434'];
      final ae2 = AEtag(PTag.kPerformedStationAETitle, vList0);
      expect(ae2.checkLength(vList1), false);
    });

    test('AE checkValue good values', () {
      final vList0 = rsg.getAEList(1, 1);
      final e1 = AEtag(PTag.kPerformedStationAETitle, vList0);
      for (final s in goodAEList) {
        for (final a in s) {
          expect(e1.checkValue(a), true);
        }
      }
    });

    test('AE checkValue bad values', () {
      final vList0 = rsg.getAEList(1, 1);
      final e1 = AEtag(PTag.kPerformedStationAETitle, vList0);
      for (final s in badAEList) {
        for (final a in s) {
          global.throwOnError = false;
          expect(e1.checkValue(a), false);

          global.throwOnError = true;
          expect(() => e1.checkValue(a),
              throwsA(const TypeMatcher<StringError>()));
        }
      }
    });

    test('AE append', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 4);
        log.debug('vList0: $vList0');
        final e0 = AEtag(PTag.kSelectorAEValue, vList0);
        const vList1 = 'foo';
        final append0 = e0.append(vList1);
        log.debug('append0: $append0');
        expect(append0, isNotNull);

        final append1 = e0.values.append(vList1, e0.maxValueLength);
        log.debug('e0.append: $append1');
        expect(append0, equals(append1));
      }
    });

    test('AE prepend', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 4);
        final e0 = AEtag(PTag.kSelectorAEValue, vList0);
        const vList1 = 'foo';
        final prepend0 = e0.prepend(vList1);
        log.debug('prepend0: $prepend0');
        expect(prepend0, isNotNull);

        final prepend1 = e0.values.prepend(vList1, e0.maxValueLength);
        log.debug('e0.prepend: $prepend1');
        expect(prepend1, equals(prepend1));
      }
    });

    test('AE truncate', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 4, 16);
        final e0 = AEtag(PTag.kSelectorAEValue, vList0);
        final truncate0 = e0.truncate(10);
        log.debug('truncate0: $truncate0');
        expect(truncate0, isNotNull);
      }
    });

    test('AE match', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getAEList(1, i);
        log.debug('vList0:$vList0');
        final e0 = AEtag(PTag.kSelectorAEValue, vList0);
        final match0 = e0.match('.*');
        expect(match0, true);
      }
    });

    test('AE valueFromBytes', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getAEList(1, i);
        final bytes = Bytes.utf8FromList(vList0);
        final e0 = AEtag(PTag.kSelectorAEValue, vList0);
        final vfb0 = e0.valuesFromBytes(bytes);
        expect(vfb0, equals(vList0));
      }
    });

    test('AE check', () {
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getAEList(1, 1);
        final e0 = AEtag(PTag.kNetworkID, vList);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getAEList(1, 10);
        final e0 = AEtag(PTag.kSelectorAEValue, vList1);
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);
        expect(e0[0], equals(vList1[0]));
      }
    });

    test('AE valuesEqual good values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getAEList(1, 1);
        final e0 = AEtag(PTag.kSelectorAEValue, vList);
        final e1 = AEtag(PTag.kSelectorAEValue, vList);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), true);
      }
    });

    test('AE valuesEqual bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getAEList(1, i);
        final vList1 = rsg.getAEList(1, 1);
        final e0 = AEtag(PTag.kSelectorAEValue, vList0);
        final e1 = AEtag(PTag.kSelectorAEValue, vList1);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), false);
      }
    });
  });

  group('AE ', () {
    const badAELengthList = <String>[
      'mrZeo|^P> -6{t,mrZeo|^P> -6{t,mrZeo|^P> -6{td9E8tO'
    ];
    //VM.k1
    const aeVM1Tags = <PTag>[
      PTag.kNetworkID,
      PTag.kPerformedStationAETitle,
      PTag.kRequestingAE,
      PTag.kOriginator,
      PTag.kDestinationAE,
    ];

    //VM.k1_n
    const aeVM1nTags = <PTag>[
      PTag.kRetrieveAETitle,
      PTag.kScheduledStudyLocationAETitle,
      PTag.kScheduledStationAETitle,
      PTag.kSelectorAEValue,
    ];
    const otherTags = <PTag>[
      PTag.kColumnAngulationPatient,
      PTag.kAcquisitionProtocolDescription,
      PTag.kCTDIvol,
      PTag.kCTPositionSequence,
      PTag.kAcquisitionType,
      PTag.kICCProfile,
      PTag.kSelectorSTValue,
      PTag.kDate,
      PTag.kTime
    ];

    final invalidVList = rsg.getAEList(AE.kMaxLength + 1, AE.kMaxLength + 1);

    test('AE isValidTag good values', () {
      global.throwOnError = false;
      expect(AE.isValidTag(PTag.kSelectorAEValue), true);

      for (final tag in aeVM1Tags) {
        final validT0 = AE.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('AE isValidTag bad values', () {
      global.throwOnError = false;
      expect(AE.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => AE.isValidTag(PTag.kSelectorFDValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (final tag in otherTags) {
        global.throwOnError = false;
        final validT0 = AE.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => AE.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('AE isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(AE.isValidVRIndex(kAEIndex), true);

      for (final tag in aeVM1Tags) {
        global.throwOnError = false;
        expect(AE.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('AE isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(AE.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => AE.isValidVRIndex(kCSIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (final tag in otherTags) {
        global.throwOnError = false;
        expect(AE.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => AE.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('AE isValidVRCode good values', () {
      global.throwOnError = false;
      expect(AE.isValidVRCode(kAECode), true);

      for (final tag in aeVM1Tags) {
        expect(AE.isValidVRCode(tag.vrCode), true);
      }
    });

    test('AE isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(AE.isValidVRCode(kSSCode), false);

      global.throwOnError = true;
      expect(() => AE.isValidVRCode(kSSCode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (final tag in otherTags) {
        global.throwOnError = false;
        expect(AE.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => AE.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('AE isValidVFLength good values', () {
      expect(AE.isValidVFLength(AE.kMaxVFLength), true);
      expect(AE.isValidVFLength(0), true);

      expect(AE.isValidVFLength(AE.kMaxVFLength, null, PTag.kSelectorAEValue),
          true);
    });

    test('AE isValidVFLength bad values', () {
      expect(AE.isValidVFLength(AE.kMaxVFLength + 1), false);
      expect(AE.isValidVFLength(-1), false);
    });

    test('AE isValidValueLength good values', () {
      for (final s in goodAEList) {
        for (final a in s) {
          expect(AE.isValidValueLength(a), true);
        }
      }
      expect(AE.isValidValueLength('&t&wSB)~PIA!UIDX'), true);
      expect(AE.isValidValueLength(''), true);
    });

    test('AE isValidValueLength bad values', () {
      global.throwOnError = false;
      for (final s in badAELengthList) {
        expect(AE.isValidValueLength(s), false);
      }

      expect(
          AE.isValidValueLength(
              '&t&wSB)~PIA!UIDX }d!zD2N3 2fz={@^mHL:/"qzD2N3 2fzLzgGEH6bTY&N}JzD2N3 2fz'),
          false);
    });

    test('AE isValidLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getAEList(1, 1);
        for (final tag in aeVM1Tags) {
          expect(AE.isValidLength(tag, vList), true);

          expect(AE.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(AE.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('AE isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getAEList(2, i + 1);
        for (final tag in aeVM1Tags) {
          global.throwOnError = false;
          expect(AE.isValidLength(tag, vList), false);

          expect(AE.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => AE.isValidLength(tag, vList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
      global.throwOnError = false;
      final vList0 = rsg.getAEList(1, 1);
      expect(AE.isValidLength(null, vList0), false);

      expect(AE.isValidLength(PTag.kSelectorAEValue, null), isNull);

      global.throwOnError = true;
      expect(() => AE.isValidLength(null, vList0),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => AE.isValidLength(PTag.kSelectorAEValue, null),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('AE isValidLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getAEList(1, i);
        final validMaxLengthList = invalidVList.sublist(0, AE.kMaxLength);
        for (final tag in aeVM1nTags) {
          log.debug('tag: $tag');
          expect(AE.isValidLength(tag, vList0), true);
          expect(AE.isValidLength(tag, validMaxLengthList), true);
        }
      }
    });

    test('AE isValidValue good values', () {
      for (final s in goodAEList) {
        for (final a in s) {
          expect(AE.isValidValue(a), true);
        }
      }
    });

    test('AE isValidValue bad values', () {
      for (final s in badAEList) {
        for (final a in s) {
          global.throwOnError = false;
          expect(AE.isValidValue(a), false);

          global.throwOnError = true;
          expect(() => AE.isValidValue(a),
              throwsA(const TypeMatcher<StringError>()));
        }
      }
    });

    test('AE isValidValues good values', () {
      global.throwOnError = false;
      for (final s in goodAEList) {
        expect(AE.isValidValues(PTag.kReceivingAE, s), true);
      }
    });

    test('AE isValidValues bad values', () {
      for (final s in badAEList) {
        global.throwOnError = false;
        expect(AE.isValidValues(PTag.kReceivingAE, s), false);

        global.throwOnError = true;
        expect(() => AE.isValidValues(PTag.kReceivingAE, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('AE fromBytes', () {
      //  system.level = Level.info;;
      final vList1 = rsg.getAEList(1, 1);
      final bytes = Bytes.asciiFromList(vList1);
      log.debug('bytes.getAsciiList(): ${bytes.getAsciiList()}, '
          'bytes: $bytes');
      expect(bytes.getAsciiList(), equals(vList1));
    });

    test('AE Bytes.fromAsciiList', () {
      final vList = rsg.getAEList(1, 1);
      final bytes = Bytes.asciiFromList(vList);
      log.debug('Bytes.fromAsciiList(vList1): $bytes');

      if (vList[0].length.isOdd) vList[0] = '${vList[0]} ';
      log.debug('vList1:"$vList"');
      final values = cvt.ascii.encode(vList[0]);
      expect(Bytes.asciiFromList(vList), equals(values));
    });

    test('AE isValidValues good values', () {
      global.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList = rsg.getAEList(1, 1);
        expect(AE.isValidValues(PTag.kReceivingAE, vList), true);
      }

      final vList0 = ['KEZ5HZZZR2'];
      expect(AE.isValidValues(PTag.kReceivingAE, vList0), true);

      for (final s in goodAEList) {
        global.throwOnError = false;
        expect(AE.isValidValues(PTag.kReceivingAE, s), true);
      }
    });

    test('AE isValidValues bad values', () {
      global.throwOnError = false;
      final vList1 = ['a\\4'];
      expect(AE.isValidValues(PTag.kReceivingAE, vList1), false);

      global.throwOnError = true;
      expect(() => AE.isValidValues(PTag.kReceivingAE, vList1),
          throwsA(const TypeMatcher<StringError>()));

      for (final s in badAEList) {
        global.throwOnError = false;
        expect(AE.isValidValues(PTag.kReceivingAE, s), false);

        global.throwOnError = true;
        expect(() => AE.isValidValues(PTag.kReceivingAE, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('AE fromAsciiList', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        global.throwOnError = false;
        final values = cvt.ascii.encode(vList0[0]);
        final tbd0 = Bytes.asciiFromList(vList0);
        final tbd1 = Bytes.asciiFromList(vList0);
        log.debug('tbd0: ${tbd0.buffer.asUint8List()}, '
            'values: $values ,tbd1: ${tbd1.buffer.asUint8List()}');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (final s in goodAEList) {
        for (final a in s) {
          final values = cvt.ascii.encode(a);
          final tbd2 = Bytes.asciiFromList(s);
          final tbd3 = Bytes.asciiFromList(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('AE getAsciiList', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.asciiFromList(vList0);
        final fbd0 = bd0.getAsciiList();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (final s in goodAEList) {
        final bd0 = Bytes.asciiFromList(s);
        final fbd0 = bd0.getAsciiList();
        expect(fbd0, equals(s));
      }
    });

    test('AE fromAsciiList', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.asciiFromList(vList0);
        final bytes0 = Bytes.ascii(vList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (final s in goodAEList) {
        final toB1 = Bytes.asciiFromList(s);
        final bytes1 = Bytes.ascii(s.join('\\'));
        log.debug('toBytes:$toB1, bytes1: $bytes1');
        expect(toB1, equals(bytes1));
      }

      global.throwOnError = false;
      final toB2 = Bytes.asciiFromList(['']);
      expect(toB2, equals(<String>[]));

      final toB3 = Bytes.asciiFromList([]);
      expect(toB3, equals(<String>[]));

      final toB4 = Bytes.asciiFromList(null);
      expect(toB4, null);

/* Now longer throws
      global.throwOnError = true;
      expect(() => Bytes.asciiFromList(null, kMaxShortVF),
          throwsA(const TypeMatcher<GeneralError>()));
*/

    });

    test('AE fromValueField', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final fvf0 = AsciiString.fromValueField(vList0, k8BitMaxLongVF);
        expect(fvf0, equals(vList0));
      }

      for (var i = 1; i < 10; i++) {
        global.throwOnError = false;
        final vList1 = rsg.getAEList(1, i);
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
      final vList2 = rsg.getAEList(1, 1);
      final bytes = Bytes.utf8FromList(vList2);
      final fvf4 = AsciiString.fromValueField(bytes, k8BitMaxLongLength);
      expect(fvf4, equals(vList2));

      final vList3 = rng.uint8List(1, 1);
      final fvf5 = AsciiString.fromValueField(vList3, k8BitMaxLongLength);
      expect(fvf5, equals([cvt.ascii.decode(vList3)]));
    });

    test('AE isValidBytesArgs', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getAEList(1, i);
        final vfBytes = Bytes.utf8FromList(vList0);

        if (vList0.length == 1) {
          for (final tag in aeVM1Tags) {
            final e0 = AE.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else {
          for (final tag in aeVM1nTags) {
            final e0 = AE.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        }
      }
      final vList0 = rsg.getAEList(1, 1);
      final vfBytes = Bytes.utf8FromList(vList0);

      final e1 = AE.isValidBytesArgs(null, vfBytes);
      expect(e1, false);

      final e2 = AE.isValidBytesArgs(PTag.kDate, vfBytes);
      expect(e2, false);

      final e3 = AE.isValidBytesArgs(PTag.kSelectorAEValue, null);
      expect(e3, false);

      global.throwOnError = true;
      expect(() => AE.isValidBytesArgs(null, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => AE.isValidBytesArgs(PTag.kDate, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));
    });
  });
}
