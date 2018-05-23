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
  Server.initialize(name: 'string/special_test', level: Level.info);
  global.throwOnError = false;

  const goodAEList = const <List<String>>[
    const <String>['d9E8tO'],
    const <String>['mrZeo|^P> -6{t, '],
    const <String>['mrZeo|^P> -6{t,'],
    const <String>['1wd7'],
    const <String>['mrZeo|^P> -6{t,']
  ];

  const badAEList = const <List<String>>[
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
    const <String>[r'^\?']
  ];

  group('AEtag', () {
    test('AE hasValidValues good values', () {
      for (var s in goodAEList) {
        global.throwOnError = false;
        final e1 = new AEtag(PTag.kScheduledStudyLocationAETitle, s);
        expect(e1.hasValidValues, true);
      }

      global.throwOnError = false;
      final e1 = new AEtag(PTag.kScheduledStudyLocationAETitle, []);
      expect(e1.hasValidValues, true);
      expect(e1.values, equals(<String>[]));
    });

    test('AE hasValidValues bad values', () {
      for (var s in badAEList) {
        global.throwOnError = false;
        final e1 = new AEtag(PTag.kScheduledStudyLocationAETitle, s);
        expect(e1, isNull);

        global.throwOnError = true;
        expect(() => new AEtag(PTag.kScheduledStudyLocationAETitle, s),
            throwsA(const isInstanceOf<StringError>()));
      }

      global.throwOnError = false;
      final e2 = new AEtag(PTag.kScheduledStudyLocationAETitle, null);
      log.debug('e2: $e2');
      expect(e2, isNull);
    });

    test('AE hasValidValues random good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 10);
        final e1 = new AEtag(PTag.kScheduledStudyLocationAETitle, vList0);
        log.debug('e1:${e1.info}');
        expect(e1.hasValidValues, true);

        log..debug('e1: $e1, values: ${e1.values}')..debug('e1: ${e1.info}');
        expect(e1[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final e2 = new AEtag(PTag.kPerformedStationAETitle, vList0);
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
        final ae2 = new AEtag(PTag.kPerformedStationAETitle, vList0);
        expect(ae2, isNull);
      }
    });

    test('AE update random', () {
      final e1 = new AEtag(PTag.kScheduledStudyLocationAETitle, []);
      expect(e1.update(['325435', '4545']).values, equals(['325435', '4545']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(3, 4);
        final e2 = new AEtag(PTag.kScheduledStudyLocationAETitle, vList0);
        final vList1 = rsg.getAEList(3, 4);
        expect(e2.update(vList1).values, equals(vList1));
      }
    });

    test('AE noValues random', () {
      final e1 = new AEtag(PTag.kScheduledStudyLocationAETitle, []);
      final AEtag aeNoValues = e1.noValues;
      expect(aeNoValues.values.isEmpty, true);
      log.debug('e1: ${e1.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(3, 4);
        final e1 = new AEtag(PTag.kScheduledStudyLocationAETitle, vList0);
        log.debug('e1: $e1');
        expect(aeNoValues.values.isEmpty, true);
        log.debug('e1: ${e1.noValues}');
      }
    });

    test('AE copy random', () {
      final e1 = new AEtag(PTag.kScheduledStudyLocationAETitle, []);
      final AEtag e2 = e1.copy;
      expect(e2 == e1, true);
      expect(e2.hashCode == e1.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(3, 4);
        final ae2 = new AEtag(PTag.kScheduledStudyLocationAETitle, vList0);
        final AEtag e3 = ae2.copy;
        expect(e3 == ae2, true);
        expect(e3.hashCode == ae2.hashCode, true);
      }
    });

    test('AE hashCode and == good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final e1 = new AEtag(PTag.kScheduledStudyLocationAETitle, vList0);
        final e2 = new AEtag(PTag.kScheduledStudyLocationAETitle, vList0);
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
        final e1 = new AEtag(PTag.kScheduledStudyLocationAETitle, vList0);

        final vList1 = rsg.getAEList(1, 1);
        final ae2 = new AEtag(PTag.kPerformedStationAETitle, vList1);
        log.debug('vList1:$vList1 , ae2.hash_code:${ae2.hashCode}');
        expect(e1.hashCode == ae2.hashCode, false);
        expect(e1 == ae2, false);

        final vList2 = rsg.getAEList(2, 3);
        final e3 = new AEtag(PTag.kPerformedStationAETitle, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e1.hashCode == e3.hashCode, false);
        expect(e1 == e3, false);
      }
    });

    test('AE valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final e1 = new AEtag(PTag.kPerformedStationAETitle, vList0);
        expect(vList0, equals(e1.valuesCopy));
      }
    });

    test('AE isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final e1 = new AEtag(PTag.kPerformedStationAETitle, vList0);
        expect(e1.tag.isValidLength(e1), true);
      }
    });

    test('AE checkValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final e1 = new AEtag(PTag.kPerformedStationAETitle, vList0);
        expect(e1.checkValues(e1.values), true);
        expect(e1.hasValidValues, true);
      }
    });

    test('AE replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final e1 = new AEtag(PTag.kPerformedStationAETitle, vList0);
        final vList1 = rsg.getAEList(1, 1);
        expect(e1.replace(vList1), equals(vList0));
        expect(e1.values, equals(vList1));
      }

      final vList1 = rsg.getAEList(1, 1);
      final e2 = new AEtag(PTag.kPerformedStationAETitle, vList1);
      expect(e2.replace([]), equals(vList1));
      expect(e2.values, equals(<String>[]));

      final ae2 = new AEtag(PTag.kPerformedStationAETitle, vList1);
      expect(ae2.replace(null), equals(vList1));
      expect(ae2.values, equals(<String>[]));
    });

    test('AE fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getAEList(1, 1);
        final bytes = Bytes.fromAsciiList(vList1);
        log.debug('bytes:$bytes');
        final e2 = AEtag.fromBytes(bytes, PTag.kPerformedStationAETitle);
        log.debug('e2: ${e2.info}');
        expect(e2.hasValidValues, true);
      }
    });

    test('AE fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getAEList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          //final bytes0 = new Bytes();
          final e2 = AEtag.fromBytes(bytes0, PTag.kSelectorAEValue);
          log.debug('e2: ${e2.info}');
          expect(e2.hasValidValues, true);
        }
      }
    });

    test('AE fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getAEList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.fromAscii(listS);
          //final bytes0 = new Bytes();
          final e2 = AEtag.fromBytes(bytes0, PTag.kSelectorCSValue);
          expect(e2, isNull);

          global.throwOnError = true;
          expect(() => AEtag.fromBytes(bytes0, PTag.kSelectorCSValue),
              throwsA(const isInstanceOf<InvalidTagError>()));
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
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final e2 =
          AEtag.fromValues(PTag.kScheduledStudyLocationAETitle, <String>[null]);
      log.debug('e2: $e2');
      expect(e2, isNull);

      global.throwOnError = true;
      expect(
          () => AEtag
              .fromValues(PTag.kScheduledStudyLocationAETitle, <String>[null]),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('AE checkLength good values', () {
      final vList0 = rsg.getAEList(1, 1);
      final e1 = new AEtag(PTag.kPerformedStationAETitle, vList0);
      for (var s in goodAEList) {
        expect(e1.checkLength(s), true);
      }
      final e2 = new AEtag(PTag.kPerformedStationAETitle, vList0);
      expect(e2.checkLength([]), true);
    });

    test('AE checkLength bad values', () {
      final vList0 = rsg.getAEList(1, 1);
      final vList1 = ['325435', '325434'];
      final ae2 = new AEtag(PTag.kPerformedStationAETitle, vList0);
      expect(ae2.checkLength(vList1), false);
    });

    test('AE checkValue good values', () {
      final vList0 = rsg.getAEList(1, 1);
      final e1 = new AEtag(PTag.kPerformedStationAETitle, vList0);
      for (var s in goodAEList) {
        for (var a in s) {
          expect(e1.checkValue(a), true);
        }
      }
    });

    test('AE checkValue bad values', () {
      final vList0 = rsg.getAEList(1, 1);
      final e1 = new AEtag(PTag.kPerformedStationAETitle, vList0);
      for (var s in badAEList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(e1.checkValue(a), false);

          global.throwOnError = true;
          expect(() => e1.checkValue(a),
              throwsA(const isInstanceOf<StringError>()));
        }
      }
    });
  });

  group('AE ', () {
    const badAELengthList = const <String>[
      'mrZeo|^P> -6{t,mrZeo|^P> -6{t,mrZeo|^P> -6{td9E8tO'
    ];
    //VM.k1
    const aeVM1Tags = const <PTag>[
      PTag.kNetworkID,
      PTag.kPerformedStationAETitle,
      PTag.kRequestingAE,
      PTag.kOriginator,
      PTag.kDestinationAE,
    ];

    //VM.k1_n
    const aeVM1_nTags = const <PTag>[
      PTag.kRetrieveAETitle,
      PTag.kScheduledStudyLocationAETitle,
      PTag.kScheduledStationAETitle,
      PTag.kSelectorAEValue,
    ];
    const otherTags = const <PTag>[
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

      for (var tag in aeVM1Tags) {
        final validT0 = AE.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('AE isValidTag bad values', () {
      global.throwOnError = false;
      expect(AE.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => AE.isValidTag(PTag.kSelectorFDValue),
          throwsA(const isInstanceOf<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = AE.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => AE.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });
/*

    test('AE checkVRIndex good values', () {
      global.throwOnError = false;
      expect(AE.checkVRIndex(kAEIndex), kAEIndex);

      for (var tag in aeTags0) {
        global.throwOnError = false;
        expect(AE.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('AE checkVRIndex bad values', () {
      global.throwOnError = false;
      expect(
          AE.checkVRIndex(
            kSSIndex,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => AE.checkVRIndex(kSSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(AE.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => AE.checkVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('AE checkVRCode good values', () {
      global.throwOnError = false;
      expect(AE.checkVRCode(kAECode), kAECode);

      for (var tag in aeTags0) {
        global.throwOnError = false;
        expect(AE.checkVRCode(tag.vrCode), tag.vrCode);
      }
    });

    test('AE checkVRIndex bad values', () {
      global.throwOnError = false;
      expect(
          AE.checkVRCode(
            kSSCode,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => AE.checkVRCode(kSSCode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(AE.checkVRCode(tag.vrCode), isNull);

        global.throwOnError = true;
        expect(() => AE.checkVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });
*/

    test('AE isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(AE.isValidVRIndex(kAEIndex), true);

      for (var tag in aeVM1Tags) {
        global.throwOnError = false;
        expect(AE.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('AE isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(AE.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => AE.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(AE.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => AE.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('AE isValidVRCode good values', () {
      global.throwOnError = false;
      expect(AE.isValidVRCode(kAECode), true);

      for (var tag in aeVM1Tags) {
        expect(AE.isValidVRCode(tag.vrCode), true);
      }
    });

    test('AE isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(AE.isValidVRCode(kSSCode), false);

      global.throwOnError = true;
      expect(() => AE.isValidVRCode(kSSCode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(AE.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => AE.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('AE isValidVFLength good values', () {
      expect(AE.isValidVFLength(AE.kMaxVFLength), true);
      expect(AE.isValidVFLength(0), true);
    });

    test('AE isValidVFLength bad values', () {
      expect(AE.isValidVFLength(AE.kMaxVFLength + 1), false);
      expect(AE.isValidVFLength(-1), false);
    });

    test('AE isValidValueLength good values', () {
      for (var s in goodAEList) {
        for (var a in s) {
          expect(AE.isValidValueLength(a), true);
        }
      }
      expect(AE.isValidValueLength('&t&wSB)~PIA!UIDX'), true);
      expect(AE.isValidValueLength(''), true);
    });

    test('AE isValidValueLength bad values', () {
      global.throwOnError = false;
      for (var s in badAELengthList) {
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
        for (var tag in aeVM1Tags) {
          expect(AE.isValidLength(tag, vList), true);

          expect(
              AE.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              AE.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('AE isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getAEList(2, i + 1);
        for (var tag in aeVM1Tags) {
          global.throwOnError = false;
          expect(AE.isValidLength(tag, vList), false);

          expect(AE.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => AE.isValidLength(tag, vList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('AE isValidLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getAEList(1, i);
        final validMaxLengthList = invalidVList.sublist(0, AE.kMaxLength);
        for (var tag in aeVM1_nTags) {
          log.debug('tag: $tag');
          expect(AE.isValidLength(tag, vList0), true);
          expect(AE.isValidLength(tag, validMaxLengthList), true);
        }
      }
    });

    test('AE isValidValue good values', () {
      for (var s in goodAEList) {
        for (var a in s) {
          expect(AE.isValidValue(a), true);
        }
      }
    });

    test('AE isValidValue bad values', () {
      for (var s in badAEList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(AE.isValidValue(a), false);

          global.throwOnError = true;
          expect(() => AE.isValidValue(a),
              throwsA(const isInstanceOf<StringError>()));
        }
      }
    });

    test('AE isValidValues good values', () {
      global.throwOnError = false;
      for (var s in goodAEList) {
        expect(AE.isValidValues(PTag.kReceivingAE, s), true);
      }
    });

    test('AE isValidValues bad values', () {
      for (var s in badAEList) {
        global.throwOnError = false;
        expect(AE.isValidValues(PTag.kReceivingAE, s), false);

        global.throwOnError = true;
        expect(() => AE.isValidValues(PTag.kReceivingAE, s),
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('AE fromBytes', () {
      //  system.level = Level.info;;
      final vList1 = rsg.getAEList(1, 1);
      final bytes = Bytes.fromAsciiList(vList1);
      log.debug('bytes.getAsciiList(): ${bytes.getAsciiList()}, bytes: $bytes');
      expect(bytes.getAsciiList(), equals(vList1));
    });

    test('AE Bytes.fromAsciiList', () {
      final vList = rsg.getAEList(1, 1);
      final bytes = Bytes.fromAsciiList(vList);
      log.debug('Bytes.fromAsciiList(vList1): $bytes');

      if (vList[0].length.isOdd) vList[0] = '${vList[0]} ';
      log.debug('vList1:"$vList"');
      final values = cvt.ascii.encode(vList[0]);
      expect(Bytes.fromAsciiList(vList), equals(values));
    });

    test('AE isValidValues good values', () {
      global.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList = rsg.getAEList(1, 1);
        expect(AE.isValidValues(PTag.kReceivingAE, vList), true);
      }

      final vList0 = ['KEZ5HZZZR2'];
      expect(AE.isValidValues(PTag.kReceivingAE, vList0), true);

      for (var s in goodAEList) {
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
          throwsA(const isInstanceOf<StringError>()));

      for (var s in badAEList) {
        global.throwOnError = false;
        expect(AE.isValidValues(PTag.kReceivingAE, s), false);

        global.throwOnError = true;
        expect(() => AE.isValidValues(PTag.kReceivingAE, s),
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('AE fromAsciiList', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        global.throwOnError = false;
        final values = cvt.ascii.encode(vList0[0]);
        final tbd0 = Bytes.fromAsciiList(vList0);
        final tbd1 = Bytes.fromAsciiList(vList0);
        log.debug('tbd0: ${tbd0.buffer.asUint8List()}, '
            'values: $values ,tbd1: ${tbd1.buffer.asUint8List()}');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodAEList) {
        for (var a in s) {
          final values = cvt.ascii.encode(a);
          final tbd2 = Bytes.fromAsciiList(s);
          final tbd3 = Bytes.fromAsciiList(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('AE getAsciiList', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.fromAsciiList(vList0);
        final fbd0 = bd0.getAsciiList();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (var s in goodAEList) {
        final bd0 = Bytes.fromAsciiList(s);
        final fbd0 = bd0.getAsciiList();
        expect(fbd0, equals(s));
      }
    });

    test('AE fromAsciiList', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.fromAsciiList(vList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(vList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodAEList) {
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
          throwsA(const isInstanceOf<GeneralError>()));
    });
  });
}