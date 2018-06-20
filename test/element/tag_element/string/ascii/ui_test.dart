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

import '../utility_test.dart' as utility;

RSG rsg = new RSG(seed: 1);

void main() {
  Server.initialize(name: 'string/ui_test', level: Level.info);
  global.throwOnError = false;

  const goodUIList = const <List<String>>[
    const <String>['1.2.840.10008.5.1.4.34.5'],
    const <String>['1.2.840.10008.1.2.4.51'],
    const <String>['1.2.840.10008.5.1.4.1.1.77.1.1'],
    const <String>['1.2.840.10008.5.1.4.1.1.66.4'],
  ];

  const badUIList = const <List<String>>[
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
    const <String>['1.a.840.10008.5.1.4.1.1.66.4'],
  ];
  group('UItag', () {
    test('UI hasValidValues good values', () {
      for (var s in goodUIList) {
        global.throwOnError = false;
        final e0 = new UItag(PTag.kStudyInstanceUID, s);
        expect(e0.hasValidValues, true);
      }
      global.throwOnError = false;
      final e0 = new UItag(PTag.kConcatenationUID, []);
      expect(e0.hasValidValues, true);
      expect(e0.values, equals(<String>[]));
    });

    test('UI hasValidValues bad values', () {
      for (var s in badUIList) {
        global.throwOnError = false;
        final e0 = new UItag(PTag.kStudyInstanceUID, s);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => new UItag(PTag.kStudyInstanceUID, s),
            throwsA(const TypeMatcher<StringError>()));
      }

      global.throwOnError = false;
      final e1 = new UItag(PTag.kConcatenationUID, null);
      log.debug('e1: $e1');
      expect(e1.hasValidValues, true);
      expect(e1.values, StringList.kEmptyList);

      global.throwOnError = true;
      expect(() => new UItag(PTag.kStudyInstanceUID, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('UI hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        final e0 = new UItag(PTag.kStudyInstanceUID, vList0);
        log.debug('e0:${e0.info}');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: ${e0.info}');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 10);
        final e1 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList0);
        expect(e1.hasValidValues, true);

        log..debug('e1: $e1, values: ${e1.values}')..debug('e1: ${e1.info}');
        expect(e1[0], equals(vList0[0]));
      }
    });

    test('UI hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(3, 4);
        log.debug('$i: vList0: $vList0');

        global.throwOnError = false;
        final e2 = new UItag(PTag.kStudyInstanceUID, vList0);
        expect(e2, isNull);

        global.throwOnError = true;
        expect(() => new UItag(PTag.kStudyInstanceUID, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('UI update random', () {
      global.throwOnError = false;
      final vList0 = rsg.getUIList(3, 4);
      final e0 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList0);
      expect(utility.testElementUpdate(e0, vList0), true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(3, 4);
        final e1 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList0);
        final vList1 = rsg.getUIList(3, 4);
        expect(e1.update(vList1).values, equals(vList1));
      }

      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getUIList(3, 4);
        final e1 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList0);
        final vList1 = rsg.getAEList(3, 4);
        expect(e1.update(vList1), isNull);

        global.throwOnError = true;
        final vList2 = rsg.getUIList(3, 4);
        final e2 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList2);
        final vList3 = rsg.getAEList(3, 4);
        expect(() => e2.update(vList3),
            throwsA(const TypeMatcher<StringError>()));
      }

      global.throwOnError = true;
      final vList2 = rsg.getUIList(3, 4);
      final e2 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList2);
      final vList3 = ['3.2.840.10008.1.2.0'];
      expect(() => e2.update(vList3),
          throwsA(const TypeMatcher<StringError>()));
    });

    test('UI noValues random', () {
      final e0 = new UItag(PTag.kRelatedGeneralSOPClassUID, []);
      final UItag uiNoValues = e0.noValues;
      expect(uiNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(3, 4);
        final e0 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList0);
        log.debug('e0: $e0');
        expect(uiNoValues.values.isEmpty, true);
        log.debug('e0: ${e0.noValues}');
      }
    });

    test('UI copy random', () {
      final e0 = new UItag(PTag.kRelatedGeneralSOPClassUID, []);
      final UItag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(3, 4);
        final e2 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList0);
        final UItag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('UI hashCode and == good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        final e0 = new UItag(PTag.kConcatenationUID, vList0);
        final e1 = new UItag(PTag.kConcatenationUID, vList0);
        log
          ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
          ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('UI hashCode and == bad values random', () {
      global.throwOnError = false;
      log.debug('UI hashCode and ==');
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        final e0 = new UItag(PTag.kConcatenationUID, vList0);

        final vList1 = rsg.getUIList(1, 1);
        final e2 = new UItag(PTag.kDimensionOrganizationUID, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rsg.getUIList(1, 10);
        final e3 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);

        final vList3 = rsg.getUIList(2, 3);
        final e4 = new UItag(PTag.kLaterality, vList3);
        log.debug('vList3:$vList3 , e4.hash_code:${e4.hashCode}');
        expect(e0.hashCode == e4.hashCode, false);
        expect(e0 == e4, false);
      }
    });

    test('UI valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        final e0 = new UItag(PTag.kSOPInstanceUID, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('UI isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        final e0 = new UItag(PTag.kSOPInstanceUID, vList0);
        expect(e0.tag.isValidLength(e0), true);
      }
    });

    test('UI isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        final e0 = new UItag(PTag.kSOPInstanceUID, vList0);
        expect(e0.checkValues(e0.values), true);
        expect(e0.hasValidValues, true);
      }
    });

    test('UI replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        final e0 = new UItag(PTag.kSOPInstanceUID, vList0);
        final vList1 = rsg.getUIList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getUIList(1, 1);
      final e1 = new UItag(PTag.kSOPInstanceUID, vList1);
      expect(e1.replace([]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = new UItag(PTag.kSOPInstanceUID, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(<String>[]));
    });

    test('UI fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getUIList(1, 1);
        final bytes = Bytes.fromAsciiList(vList1);
        log.debug('bytes:$bytes');
        final e0 = UItag.fromBytes(bytes, PTag.kSOPInstanceUID);
        log.debug('$i: e0: ${e0.info}');
        expect(e0.hasValidValues, true);
      }
    });

    test('UI fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getUIList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          final e1 = UItag.fromBytes(bytes0, PTag.kSelectorUIValue);
          log.debug('e1: ${e1.info}');
          expect(e1.hasValidValues, true);
        }
      }
    });

    test('UI fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getUIList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.fromAscii(listS);
          final e1 = UItag.fromBytes(bytes0, PTag.kSelectorAEValue);
          expect(e1, isNull);

          global.throwOnError = true;
          expect(() => UItag.fromBytes(bytes0, PTag.kSelectorAEValue),
              throwsA(const TypeMatcher<InvalidTagError>()));
        }
      }
    });

    test('UI fromValues good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        final e0 = UItag.fromValues(PTag.kSOPInstanceUID, vList0);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);

        final e1 = UItag.fromValues(PTag.kSOPInstanceUID, <String>[]);
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(<String>[]));
      }
    });

    test('UI fromValues bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(2, 2);
        global.throwOnError = false;
        final e0 = UItag.fromValues(PTag.kSOPInstanceUID, vList0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => UItag.fromValues(PTag.kSOPInstanceUID, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final e1 = UItag.fromValues(PTag.kSOPInstanceUID, <String>[null]);
      log.debug('e1: $e1');
      expect(e1, isNull);

      global.throwOnError = true;
      expect(() => UItag.fromValues(PTag.kSOPInstanceUID, <String>[null]),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('UI checkLength good values', () {
      final vList0 = rsg.getUIList(1, 1);
      final e0 = new UItag(PTag.kSOPInstanceUID, vList0);
      for (var s in goodUIList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = new UItag(PTag.kSOPInstanceUID, vList0);
      expect(e1.checkLength([]), true);
    });

    test('UI checkLength bad values', () {
      final vList0 = rsg.getUIList(1, 1);
      final vList1 = ['1.2.840.10008.5.1.4.34.5', '1.2.840.10008.3.1.2.32.7'];
      final e2 = new UItag(PTag.kSOPInstanceUID, vList0);
      expect(e2.checkLength(vList1), false);
    });

    test('UI checkValue good values', () {
      final vList0 = rsg.getUIList(1, 1);
      final e0 = new UItag(PTag.kSOPInstanceUID, vList0);
      for (var s in goodUIList) {
        for (var a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });

    test('UI checkValue bad values', () {
      final vList0 = rsg.getUIList(1, 1);
      final e0 = new UItag(PTag.kSOPInstanceUID, vList0);
      for (var s in badUIList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(e0.checkValue(a), false);
        }
      }
    });

    test('UI parse', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        global.throwOnError = false;
        final parse0 = Uid.parseList(vList0);
        expect(parse0.elementAt(0).value, equals(vList0[0]));
      }

      for (var s in goodUIList) {
        final parse1 = (s);
        expect(parse1.elementAt(0), equals(s[0]));
      }

      for (var s in badUIList) {
        global.throwOnError = false;
        final parse2 = Uid.parseList(s);
        expect(parse2, equals([null]));

        global.throwOnError = true;
        expect(() => Uid.parseList(s),
            throwsA(const TypeMatcher<InvalidUidError>()));
      }

      global.throwOnError = false;
      final parse3 = Uid.parseList(['1.3.5']);
      expect(parse3, equals([null]));

      final parse4 = Uid.parseList([
        '1.2.840.10008.5.1.4.34.5.345.22.5467456.5.1.4.34.5.345.22.5467456.55.45'
      ]);
      expect(parse4, equals([null]));

      global.throwOnError = true;
      expect(() => Uid.parseList(['1.3.5']),
          throwsA(const TypeMatcher<InvalidUidError>()));
    });

    test('UI update random', () {
      global.throwOnError = false;
      final e0 = new UItag(PTag.kSelectorUIValue, []);
      expect(e0.update(['1.2.840.10008.5.1.4.34.5']).values,
          equals(['1.2.840.10008.5.1.4.34.5']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        final e1 = new UItag(PTag.kSOPInstanceUID, vList0);
        final vList1 = rsg.getUIList(1, 1);
        expect(e1.update(vList1).values, equals(vList1));
      }
    });
  });

  group('UI', () {
    //VM.k1
    const uiVM1Tags = const <PTag>[
      PTag.kAffectedSOPInstanceUID,
      PTag.kRequestedSOPInstanceUID,
      PTag.kMediaStorageSOPClassUID,
      PTag.kTransferSyntaxUID,
      PTag.kImplementationClassUID,
      PTag.kInstanceCreatorUID,
      PTag.kSOPClassUID,
      PTag.kSOPInstanceUID,
      PTag.kOriginalSpecializedSOPClassUID,
      PTag.kCodingSchemeUID,
      PTag.kStudyInstanceUID,
      PTag.kSeriesInstanceUID,
      PTag.kDimensionOrganizationUID,
      PTag.kSpecimenUID,
    ];

    //VM.k1_n
    const uiVM1_nTags = const <PTag>[
      PTag.kRelatedGeneralSOPClassUID,
      PTag.kFailedSOPInstanceUIDList,
      PTag.kSelectorUIValue
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

    final invalidVList = rsg.getUIList(UI.kMaxLength + 1, UI.kMaxLength + 1);

    test('UI isValidTag good values', () {
      global.throwOnError = false;
      expect(UI.isValidTag(PTag.kSelectorUIValue), true);

      for (var tag in uiVM1Tags) {
        final validT0 = UI.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('UI isValidTag bad values', () {
      global.throwOnError = false;
      expect(UI.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => UI.isValidTag(PTag.kSelectorFDValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = UI.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => UI.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });
/*

    test('UI checkVRIndex good values', () {
      global.throwOnError = false;
      expect(UI.checkVRIndex(kUIIndex), kUIIndex);

      for (var tag in uiTags0) {
        global.throwOnError = false;
        expect(UI.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('UI checkVRIndex bad values', () {
      global.throwOnError = false;
      expect(
          UI.checkVRIndex(
            kAEIndex,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => UI.checkVRIndex(kAEIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UI.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => UI.checkVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('UI checkVRCode good values', () {
      global.throwOnError = false;
      expect(UI.checkVRCode(kUICode), kUICode);

      for (var tag in uiTags0) {
        global.throwOnError = false;
        expect(UI.checkVRCode(tag.vrCode), tag.vrCode);
      }
    });

    test('UI checkVRCode bad values', () {
      global.throwOnError = false;
      expect(
          UI.checkVRCode(
            kAECode,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => UI.checkVRCode(kAECode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UI.checkVRCode(tag.vrCode), isNull);

        global.throwOnError = true;
        expect(() => UI.checkVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });
*/

    test('UI isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(UI.isValidVRIndex(kUIIndex), true);

      for (var tag in uiVM1Tags) {
        global.throwOnError = false;
        expect(UI.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('UI isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(UI.isValidVRIndex(kSSIndex), false);

      global.throwOnError = true;
      expect(() => UI.isValidVRIndex(kSSIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UI.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => UI.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('UI isValidVRCode good values', () {
      global.throwOnError = false;
      expect(UI.isValidVRCode(kUICode), true);

      for (var tag in uiVM1Tags) {
        expect(UI.isValidVRCode(tag.vrCode), true);
      }
    });

    test('UI isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(UI.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => UI.isValidVRCode(kAECode),
          throwsA(const TypeMatcher<InvalidVRError>()));
      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UI.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => UI.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('UI isValidVFLength good values', () {
      expect(UI.isValidVFLength(UI.kMaxVFLength), true);
      expect(UI.isValidVFLength(0), true);

      expect(UI.isValidVFLength(UI.kMaxVFLength, null, PTag.kSelectorUIValue),
          true);
    });

    test('UI isValidVFLength bad values', () {
      expect(UI.isValidVFLength(UI.kMaxVFLength + 1), false);
      expect(UI.isValidVFLength(-1), false);
    });

    test('UI isValidValueLength', () {
      for (var s in goodUIList) {
        for (var a in s) {
          expect(UI.isValidValueLength(a), true);
        }
      }
    });

    test('UI isValidLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getUIList(1, 1);
        for (var tag in uiVM1Tags) {
          expect(UI.isValidLength(tag, vList), true);

          expect(UI.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(UI.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('UI isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getUIList(2, i + 1);
        for (var tag in uiVM1Tags) {
          global.throwOnError = false;
          expect(UI.isValidLength(tag, vList), false);

          expect(UI.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => UI.isValidLength(tag, vList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }

      global.throwOnError = false;
      final vList0 = rsg.getUIList(1, 1);
      expect(UI.isValidLength(null, vList0), false);

      expect(UI.isValidLength(PTag.kSelectorUIValue, null), isNull);

      global.throwOnError = true;
      expect(() => UI.isValidLength(null, vList0),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => UI.isValidLength(PTag.kSelectorUIValue, null),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('UI isValidLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getUIList(1, i);
        final validMaxLengthList = invalidVList.sublist(0, UI.kMaxLength);
        for (var tag in uiVM1_nTags) {
          log.debug('tag: $tag');
          expect(UI.isValidLength(tag, vList0), true);
          expect(UI.isValidLength(tag, validMaxLengthList), true);
        }
      }
    });

    test('UI isValidValue good values', () {
      for (var s in goodUIList) {
        for (var a in s) {
          expect(UI.isValidValue(a), true);
        }
      }
    });

    test('UI isValidValue bad values', () {
      for (var s in badUIList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(UI.isValidValue(a), false);
        }
      }
    });

    test('UI isValidValues good values', () {
      global.throwOnError = false;
      for (var s in goodUIList) {
        expect(UI.isValidValues(PTag.kInstanceCreatorUID, s), true);
      }
    });

    test('UI isValidValues bad values', () {
      for (var s in badUIList) {
        global.throwOnError = false;
        expect(UI.isValidValues(PTag.kInstanceCreatorUID, s), false);

        global.throwOnError = true;
        expect(() => UI.isValidValues(PTag.kInstanceCreatorUID, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('UI fromBytes', () {
      //  system.level = Level.info;;
      final vList1 = rsg.getUIList(1, 1);
      final bytes = Bytes.fromAsciiList(vList1);
      log.debug('bytes.getAsciiList(): ${bytes.getAsciiList()}, bytes: $bytes');
      expect(bytes.getAsciiList(), equals(vList1));
    });

    test('UI Bytes.fromAsciiList', () {
      final vList1 = rsg.getUIList(1, 1);
      log.debug('Bytes.fromAsciiList(vList1): ${Bytes.fromAsciiList(vList1)}');
      final val = cvt.ascii.encode('s6V&:;s%?Q1g5v');
      expect(Bytes.fromAsciiList(['s6V&:;s%?Q1g5v']), equals(val));

      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = cvt.ascii.encode(vList1[0]);
      expect(Bytes.fromAsciiList(vList1), equals(values));
    });

    test('UI isValidValues good values', () {
      global.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList = rsg.getUIList(1, 1);
        expect(UI.isValidValues(PTag.kInstanceCreatorUID, vList), true);
      }

      final vList0 = ['1.2.840.10008.5.1.4.34.5'];
      expect(UI.isValidValues(PTag.kInstanceCreatorUID, vList0), true);

      for (var s in goodUIList) {
        global.throwOnError = false;
        expect(UI.isValidValues(PTag.kInstanceCreatorUID, s), true);
      }
    });

    test('UI isValidValues bad values', () {
      final vList1 = ['1.a.840.10008.5.1.4.1.1.66.4'];
      expect(UI.isValidValues(PTag.kInstanceCreatorUID, vList1), false);

      global.throwOnError = true;
      expect(() => UI.isValidValues(PTag.kInstanceCreatorUID, vList1),
          throwsA(const TypeMatcher<StringError>()));
      global.throwOnError = false;

      for (var i = 0; i <= 10; i++) {
        for (var s in badUIList) {
          global.throwOnError = false;
          expect(UI.isValidValues(PTag.kInstanceCreatorUID, s), false);

          global.throwOnError = true;
          expect(() => UI.isValidValues(PTag.kInstanceCreatorUID, s),
              throwsA(const TypeMatcher<StringError>()));
        }
      }
    });

    test('UI toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        global.throwOnError = false;
        final values = cvt.ascii.encode(vList0[0]);
        final tbd0 = Bytes.fromAsciiList(vList0);
        final tbd1 = Bytes.fromAsciiList(vList0);
        log.debug('tbd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodUIList) {
        for (var a in s) {
          final values = cvt.ascii.encode(a);
          final tbd2 = Bytes.fromAsciiList(s);
          final tbd3 = Bytes.fromAsciiList(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('UI fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.fromAsciiList(vList0);
        final fbd0 = bd0.getAsciiList();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (var s in goodUIList) {
        final bd0 = Bytes.fromAsciiList(s);
        final fbd0 = bd0.getAsciiList();
        expect(fbd0, equals(s));
      }
    });

    test('UI toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.fromAsciiList(vList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(vList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodUIList) {
        final toB1 = Bytes.fromAsciiList(s, kMaxShortVF);
        final bytes1 = Bytes.fromAscii(s.join('\\'));
        log.debug('toBytes:$toB1, bytes1: $bytes1');
        expect(toB1, equals(bytes1));
      }

      global.throwOnError = false;
      final toB2 = Bytes.fromAsciiList([''], kMaxShortVF);
      expect(toB2, equals(<String>[]));

      final toB3 = Bytes.fromAsciiList([], kMaxShortVF);
      expect(toB3, equals(<String>[]));

      final toB4 = Bytes.fromAsciiList(null, kMaxShortVF);
      expect(toB4, isNull);

      global.throwOnError = true;
      expect(() => Bytes.fromAsciiList(null, kMaxShortVF),
          throwsA(const TypeMatcher<GeneralError>()));
    });
  });
}
