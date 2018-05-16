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

import 'utility_test.dart' as utility;

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
        final ae0 = new AEtag(PTag.kScheduledStudyLocationAETitle, s);
        expect(ae0.hasValidValues, true);
      }

      global.throwOnError = false;
      final ae0 = new AEtag(PTag.kScheduledStudyLocationAETitle, []);
      expect(ae0.hasValidValues, true);
      expect(ae0.values, equals(<String>[]));
    });

    test('AE hasValidValues bad values', () {
      for (var s in badAEList) {
        global.throwOnError = false;
        final ae0 = new AEtag(PTag.kScheduledStudyLocationAETitle, s);
        expect(ae0, isNull);

        global.throwOnError = true;
        expect(() => new AEtag(PTag.kScheduledStudyLocationAETitle, s),
            throwsA(const isInstanceOf<StringError>()));
      }

      global.throwOnError = false;
      final ae1 = new AEtag(PTag.kScheduledStudyLocationAETitle, null);
      log.debug('ae1: $ae1');
      expect(ae1, isNull);
    });

    test('AE hasValidValues random good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 10);
        final ae0 = new AEtag(PTag.kScheduledStudyLocationAETitle, vList0);
        log.debug('ae0:${ae0.info}');
        expect(ae0.hasValidValues, true);

        log
          ..debug('ae0: $ae0, values: ${ae0.values}')
          ..debug('ae0: ${ae0.info}');
        expect(ae0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final ae1 = new AEtag(PTag.kPerformedStationAETitle, vList0);
        expect(ae1.hasValidValues, true);

        log
          ..debug('ae1: $ae1, values: ${ae1.values}')
          ..debug('ae1: ${ae1.info}');
        expect(ae1[0], equals(vList0[0]));
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
      final ae0 = new AEtag(PTag.kScheduledStudyLocationAETitle, []);
      expect(ae0.update(['325435', '4545']).values, equals(['325435', '4545']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(3, 4);
        final ae1 = new AEtag(PTag.kScheduledStudyLocationAETitle, vList0);
        final vList1 = rsg.getAEList(3, 4);
        expect(ae1.update(vList1).values, equals(vList1));
      }
    });

    test('AE noValues random', () {
      final ae0 = new AEtag(PTag.kScheduledStudyLocationAETitle, []);
      final AEtag aeNoValues = ae0.noValues;
      expect(aeNoValues.values.isEmpty, true);
      log.debug('ae0: ${ae0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(3, 4);
        final ae0 = new AEtag(PTag.kScheduledStudyLocationAETitle, vList0);
        log.debug('ae0: $ae0');
        expect(aeNoValues.values.isEmpty, true);
        log.debug('ae0: ${ae0.noValues}');
      }
    });

    test('AE copy random', () {
      final ae0 = new AEtag(PTag.kScheduledStudyLocationAETitle, []);
      final AEtag ae1 = ae0.copy;
      expect(ae1 == ae0, true);
      expect(ae1.hashCode == ae0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(3, 4);
        final ae2 = new AEtag(PTag.kScheduledStudyLocationAETitle, vList0);
        final AEtag ae3 = ae2.copy;
        expect(ae3 == ae2, true);
        expect(ae3.hashCode == ae2.hashCode, true);
      }
    });

    test('AE hashCode and == good values random', () {
      List<String> stringList0;
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getAEList(1, 1);
        final ae0 = new AEtag(PTag.kScheduledStudyLocationAETitle, stringList0);
        final ae1 = new AEtag(PTag.kScheduledStudyLocationAETitle, stringList0);
        log
          ..debug('stringList0:$stringList0, ae0.hash_code:${ae0.hashCode}')
          ..debug('stringList0:$stringList0, ds1.hash_code:${ae1.hashCode}');
        expect(ae0.hashCode == ae1.hashCode, true);
        expect(ae0 == ae1, true);
      }
    });

    test('AE hashCode and == bad values random', () {
      List<String> stringList0;
      List<String> stringList1;
      List<String> stringList2;

      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getAEList(1, 1);
        final ae0 = new AEtag(PTag.kScheduledStudyLocationAETitle, stringList0);

        stringList1 = rsg.getAEList(1, 1);
        final ae2 = new AEtag(PTag.kPerformedStationAETitle, stringList1);
        log.debug('stringList1:$stringList1 , ae2.hash_code:${ae2.hashCode}');
        expect(ae0.hashCode == ae2.hashCode, false);
        expect(ae0 == ae2, false);

        stringList2 = rsg.getAEList(2, 3);
        final ae3 = new AEtag(PTag.kPerformedStationAETitle, stringList2);
        log.debug('stringList2:$stringList2 , ae3.hash_code:${ae3.hashCode}');
        expect(ae0.hashCode == ae3.hashCode, false);
        expect(ae0 == ae3, false);
      }
    });

    test('AE valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final ae0 = new AEtag(PTag.kPerformedStationAETitle, vList0);
        expect(vList0, equals(ae0.valuesCopy));
      }
    });

    test('AE isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final ae0 = new AEtag(PTag.kPerformedStationAETitle, vList0);
        expect(ae0.tag.isValidLength(ae0), true);
      }
    });

    test('AE isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final ae0 = new AEtag(PTag.kPerformedStationAETitle, vList0);
        expect(ae0.checkValues(ae0.values), true);
        expect(ae0.hasValidValues, true);
      }
    });

    test('AE replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final ae0 = new AEtag(PTag.kPerformedStationAETitle, vList0);
        final vList1 = rsg.getAEList(1, 1);
        expect(ae0.replace(vList1), equals(vList0));
        expect(ae0.values, equals(vList1));
      }

      final vList1 = rsg.getAEList(1, 1);
      final ae1 = new AEtag(PTag.kPerformedStationAETitle, vList1);
      expect(ae1.replace([]), equals(vList1));
      expect(ae1.values, equals(<String>[]));

      final ae2 = new AEtag(PTag.kPerformedStationAETitle, vList1);
      expect(ae2.replace(null), equals(vList1));
      expect(ae2.values, equals(<String>[]));
    });

    test('AE fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getAEList(1, 1);
        final bytes = Bytes.fromAsciiList(vList1);
        log.debug('bytes:$bytes');
        final ae1 = AEtag.fromBytes(PTag.kPerformedStationAETitle, bytes);
        log.debug('ae1: ${ae1.info}');
        expect(ae1.hasValidValues, true);
      }
    });

    test('AE fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getAEList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          //final bytes0 = new Bytes();
          final ae1 = AEtag.fromBytes(PTag.kSelectorAEValue, bytes0);
          log.debug('ae1: ${ae1.info}');
          expect(ae1.hasValidValues, true);
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
          final ae1 = AEtag.fromBytes(PTag.kSelectorCSValue, bytes0);
          expect(ae1, isNull);

          global.throwOnError = true;
          expect(() => AEtag.fromBytes(PTag.kSelectorCSValue, bytes0),
              throwsA(const isInstanceOf<InvalidTagError>()));
        }
      }
    });

    test('AE make good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        final make0 = AEtag.fromValues(PTag.kPerformedStationAETitle, vList0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);

        final make1 =
            AEtag.fromValues(PTag.kScheduledStudyLocationAETitle, <String>[]);
        expect(make1.hasValidValues, true);
        expect(make1.values, equals(<String>[]));
      }
    });

    test('AE make bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(2, 2);
        global.throwOnError = false;
        final make0 = AEtag.fromValues(PTag.kPerformedStationAETitle, vList0);
        expect(make0, isNull);

        global.throwOnError = true;
        expect(() => AEtag.fromValues(PTag.kPerformedStationAETitle, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final ae1 =
          AEtag.fromValues(PTag.kScheduledStudyLocationAETitle, <String>[null]);
      log.debug('ae1: $ae1');
      expect(ae1, isNull);

      global.throwOnError = true;
      expect(
          () => AEtag
              .fromValues(PTag.kScheduledStudyLocationAETitle, <String>[null]),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('AE checkLength good values', () {
      final vList0 = rsg.getAEList(1, 1);
      final ae0 = new AEtag(PTag.kPerformedStationAETitle, vList0);
      for (var s in goodAEList) {
        expect(ae0.checkLength(s), true);
      }
      final ae1 = new AEtag(PTag.kPerformedStationAETitle, vList0);
      expect(ae1.checkLength([]), true);
    });

    test('AE checkLength bad values', () {
      final vList0 = rsg.getAEList(1, 1);
      final vList1 = ['325435', '325434'];
      final ae2 = new AEtag(PTag.kPerformedStationAETitle, vList0);
      expect(ae2.checkLength(vList1), false);
    });

    test('AE checkValue good values', () {
      final vList0 = rsg.getAEList(1, 1);
      final ae0 = new AEtag(PTag.kPerformedStationAETitle, vList0);
      for (var s in goodAEList) {
        for (var a in s) {
          expect(ae0.checkValue(a), true);
        }
      }
    });

    test('AE checkValue bad values', () {
      final vList0 = rsg.getAEList(1, 1);
      final ae0 = new AEtag(PTag.kPerformedStationAETitle, vList0);
      for (var s in badAEList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(ae0.checkValue(a), false);

          global.throwOnError = true;
          expect(() => ae0.checkValue(a),
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
    const aeTags0 = const <PTag>[
      PTag.kNetworkID,
      PTag.kPerformedStationAETitle,
      PTag.kRequestingAE,
      PTag.kOriginator,
      PTag.kDestinationAE,
    ];

    //VM.k1_n
    const aeTags1 = const <PTag>[
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

      for (var tag in aeTags0) {
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

      for (var tag in aeTags0) {
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

      for (var tag in aeTags0) {
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

    test('AE isNotValidVFLength good values', () {
      expect(AE.isValidVFLength(AE.kMaxVFLength), true);
      expect(AE.isValidVFLength(0), true);
    });

    test('AE isNotValidVFLength bad values', () {
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
      expect(AE.isValidValueLength(''), false);
    });

    test('AE isValidValueLength bad values', () {
      for (var s in badAELengthList) {
        expect(AE.isValidValueLength(s), false);
      }

      expect(
          AE.isValidValueLength('&t&wSB)~PIA!UIDX }d!zD2N3 2fz={@^mHL:'
              '/"qzD2N3 2fzLzgGEH6bTY&N}JzD2N3 2fz'),
          false);
    });

    test('AE isNotValidValueLength good values', () {
      for (var s in goodAEList) {
        for (var a in s) {
          expect(AE.isValidValueLength(a), true);
        }
      }
    });

    test('AE isNotValidValueLength bad values', () {
      for (var s in badAELengthList) {
        expect(AE.isValidValueLength(s), false);
      }

      expect(
          AE.isValidValueLength(
              '&t&wSB)~PIA!UIDX }d!zD2N3 2fz={@^mHL:/"qmczv9LzgGEH6bTY&N}J'),
          false);
    });

    test('AE isValidLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getAEList(1, 1);
        for (var tag in aeTags0) {
          expect(AE.isValidLength(tag, validMinVList), true);

          expect(AE.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(AE.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('AE isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rsg.getAEList(2, i + 1);
        for (var tag in aeTags0) {
          global.throwOnError = false;
          expect(AE.isValidLength(tag, validMinVList), false);

          expect(AE.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => AE.isValidLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('AE isValidLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final validMinVList0 = rsg.getAEList(1, i);
        final validMaxLengthList = invalidVList.sublist(0, AE.kMaxLength);
        for (var tag in aeTags1) {
          log.debug('tag: $tag');
          expect(AE.isValidLength(tag, validMinVList0), true);
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

    test('AE toByteData', () {
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

    test('AE fromByteData', () {
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

    test('AE toBytes', () {
      for (var i = 0; i < 10; i++) {
        final sList0 = rsg.getAEList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.fromAsciiList(sList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(sList0.join('\\'));
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

  const goodCSList = const <List<String>>[
    const <String>['KEZ5HZZZR2'],
    const <String>['LUA '],
    const <String>['DAP3Q'],
    const <String>['GAEGBPO'],
    const <String>['EGM_']
  ];

  const badCSList = const <List<String>>[
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
    const <String>['T 2@+nEZKu/J'],
    const <String>['123.45']
  ];
  group('CStag', () {
    test('CS hasValidValues good values', () {
      for (var s in goodCSList) {
        global.throwOnError = false;
        final cs0 = new CStag(PTag.kLaterality, s);
        expect(cs0.hasValidValues, true);
      }
      global.throwOnError = false;
      final cs0 = new CStag(PTag.kMaskingImage, []);
      expect(cs0.hasValidValues, true);
      expect(cs0.values, equals(<String>[]));
    });

    test('CS hasValidValues bad values', () {
      for (var s in badCSList) {
        global.throwOnError = false;
        final cs0 = new CStag(PTag.kLaterality, s);
        expect(cs0, isNull);

        global.throwOnError = true;
        expect(() => new CStag(PTag.kLaterality, s),
            throwsA(const isInstanceOf<StringError>()));
      }

      global.throwOnError = false;
      final cs1 = new CStag(PTag.kMaskingImage, null);
      log.debug('cs1: $cs1');
      expect(cs1, isNull);

      global.throwOnError = true;
      expect(() => new CStag(PTag.kLaterality, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('CS hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1, 2, 16);
        final cs0 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
        log.debug('cs0:${cs0.info}');
        expect(cs0.hasValidValues, true);

        log
          ..debug('cs0: $cs0, values: ${cs0.values}')
          ..debug('cs0: ${cs0.info}');
        expect(cs0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(2, 2);
        final cs1 = new CStag(PTag.kPatientOrientation, vList0);
        expect(cs1.hasValidValues, true);

        log
          ..debug('cs1: $cs1, values: ${cs1.values}')
          ..debug('cs1: ${cs1.info}');
        expect(cs1[0], equals(vList0[0]));
      }
    });

    test('CS hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getCSList(3, 4);
        log.debug('$i: vList0: $vList0');
        final cs2 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
        expect(cs2, isNull);
      }
    });

    test('CS update random', () {
      final cs0 = new CStag(PTag.kMaskingImage, []);
      expect(cs0.update(['325435', '4545']).values, equals(['325435', '4545']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(3, 4);
        final cs1 = new CStag(PTag.kMaskingImage, vList0);
        final vList1 = rsg.getCSList(3, 4);
        expect(cs1.update(vList1).values, equals(vList1));
      }
    });

    test('CS noValues random', () {
      final cs0 = new CStag(PTag.kMaskingImage, []);
      final CStag csNoValues = cs0.noValues;
      expect(csNoValues.values.isEmpty, true);
      log.debug('cs0: ${cs0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(3, 4);
        final cs0 = new CStag(PTag.kMaskingImage, vList0);
        log.debug('cs0: $cs0');
        expect(csNoValues.values.isEmpty, true);
        log.debug('ae0: ${cs0.noValues}');
      }
    });

    test('CS copy random', () {
      final cs0 = new CStag(PTag.kMaskingImage, []);
      final CStag cs1 = cs0.copy;
      expect(cs1 == cs0, true);
      expect(cs1.hashCode == cs0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(3, 4);
        final cs2 = new CStag(PTag.kMaskingImage, vList0);
        final CStag cs3 = cs2.copy;
        expect(cs3 == cs2, true);
        expect(cs3.hashCode == cs2.hashCode, true);
      }
    });

    test('CS hashCode and == good values random', () {
      List<String> stringList0;
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getCSList(1, 1);
        final cs0 = new CStag(PTag.kLaterality, stringList0);
        final cs1 = new CStag(PTag.kLaterality, stringList0);
        log
          ..debug('stringList0:$stringList0, cs0.hash_code:${cs0.hashCode}')
          ..debug('stringList0:$stringList0, ds1.hash_code:${cs1.hashCode}');
        expect(cs0.hashCode == cs1.hashCode, true);
        expect(cs0 == cs1, true);
      }
    });

    test('CS hashCode and == bad values random', () {
      List<String> stringList0;
      List<String> stringList1;
      List<String> stringList2;
      List<String> stringList3;
      List<String> stringList4;

      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getCSList(1, 1);
        final cs0 = new CStag(PTag.kLaterality, stringList0);

        stringList1 = rsg.getCSList(1, 1);
        final ae2 = new CStag(PTag.kImageLaterality, stringList1);
        log.debug('stringList1:$stringList1 , ae2.hash_code:${ae2.hashCode}');
        expect(cs0.hashCode == ae2.hashCode, false);
        expect(cs0 == ae2, false);

        stringList2 = rsg.getCSList(2, 2);
        final cs3 = new CStag(PTag.kPatientOrientation, stringList2);
        log.debug('stringList2:$stringList2 , cs3.hash_code:${cs3.hashCode}');
        expect(cs0.hashCode == cs3.hashCode, false);
        expect(cs0 == cs3, false);

        stringList3 = rsg.getCSList(4, 4);
        final cs4 = new CStag(PTag.kFrameType, stringList3);
        log.debug('stringList3:$stringList3 , cs4.hash_code:${cs4.hashCode}');
        expect(cs0.hashCode == cs4.hashCode, false);
        expect(cs0 == cs4, false);

        stringList4 = rsg.getCSList(2, 3);
        final cs5 = new CStag(PTag.kLaterality, stringList2);
        log.debug('stringList4:$stringList4 , cs5.hash_code:${cs5.hashCode}');
        expect(cs0.hashCode == cs5.hashCode, false);
        expect(cs0 == cs5, false);
      }
    });

    test('CS valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        final cs0 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
        expect(vList0, equals(cs0.valuesCopy));
      }
    });

    test('CS isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        final cs0 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
        expect(cs0.tag.isValidLength(cs0), true);
      }
    });

    test('CS isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        final cs0 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
        expect(cs0.checkValues(cs0.values), true);
        expect(cs0.hasValidValues, true);
      }
    });

    test('CS replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        final cs0 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
        final vList1 = rsg.getCSList(1, 1);
        expect(cs0.replace(vList1), equals(vList0));
        expect(cs0.values, equals(vList1));
      }

      final vList1 = rsg.getCSList(1, 1);
      final cs1 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList1);
      expect(cs1.replace([]), equals(vList1));
      expect(cs1.values, equals(<String>[]));

      final cs2 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList1);
      expect(cs2.replace(null), equals(vList1));
      expect(cs2.values, equals(<String>[]));
    });

    test('CS formBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getCSList(1, 1);
        final bytes = Bytes.fromAsciiList(vList1);
        log.debug('bytes:$bytes');
        final cs1 = CStag.fromBytes(PTag.kGeometryOfKSpaceTraversal, bytes);
        log.debug('cs1: ${cs1.info}');
        expect(cs1.hasValidValues, true);
      }
    });

    test('CS fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getCSList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          final cs1 = CStag.fromBytes(PTag.kSelectorCSValue, bytes0);
          log.debug('cs1: ${cs1.info}');
          expect(cs1.hasValidValues, true);
        }
      }
    });

    test('CS fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getCSList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.fromAscii(listS);
          final cs1 = CStag.fromBytes(PTag.kSelectorAEValue, bytes0);
          expect(cs1, isNull);

          global.throwOnError = true;
          expect(() => CStag.fromBytes(PTag.kSelectorAEValue, bytes0),
              throwsA(const isInstanceOf<InvalidTagError>()));
        }
      }
    });

    test('CS make good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        final make0 = CStag.fromValues(PTag.kGeometryOfKSpaceTraversal, vList0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);

        final make1 =
            CStag.fromValues(PTag.kGeometryOfKSpaceTraversal, <String>[]);
        expect(make1.hasValidValues, true);
        expect(make1.values, equals(<String>[]));
      }
    });

    test('CS make bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(2, 2);
        global.throwOnError = false;
        final make0 = CStag.fromValues(PTag.kGeometryOfKSpaceTraversal, vList0);
        expect(make0, isNull);

        global.throwOnError = true;
        expect(() => CStag.fromValues(PTag.kGeometryOfKSpaceTraversal, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final make1 =
          CStag.fromValues(PTag.kGeometryOfKSpaceTraversal, <String>[null]);
      log.debug('make1: $make1');
      expect(make1, isNull);

      global.throwOnError = true;
      expect(
          () => CStag
              .fromValues(PTag.kScheduledStudyLocationAETitle, <String>[null]),
          throwsA(const isInstanceOf<InvalidTagError>()));
    });

    test('CS checkLength good values', () {
      final vList0 = rsg.getCSList(1, 1);
      final cs0 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
      for (var s in goodCSList) {
        expect(cs0.checkLength(s), true);
      }
      final cs1 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
      expect(cs1.checkLength([]), true);
    });

    test('CS checkLength bad values', () {
      final vList0 = rsg.getCSList(1, 1);
      final vList1 = ['KEZ5HZZZR2', 'LSDKFJIE34D'];
      final cs2 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
      expect(cs2.checkLength(vList1), false);
    });

    test('CS checkValue good values', () {
      final vList0 = rsg.getCSList(1, 1);
      final cs0 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
      for (var s in goodCSList) {
        for (var a in s) {
          expect(cs0.checkValue(a), true);
        }
      }
    });

    test('CS checkValue bad values', () {
      final vList0 = rsg.getCSList(1, 1);
      final cs0 = new CStag(PTag.kGeometryOfKSpaceTraversal, vList0);
      for (var s in badCSList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(cs0.checkValue(a), false);

          global.throwOnError = true;
          expect(() => cs0.checkValue(a),
              throwsA(const isInstanceOf<StringError>()));
        }
      }
    });
  });

  group('CS', () {
    //VM.k1
    const csTags0 = const <PTag>[
      PTag.kFileSetID,
      PTag.kConversionType,
      PTag.kPresentationIntentType,
      PTag.kMappingResource,
      //PTag.kFileSetDescriptorFileID,//vm.k1_8
      PTag.kFieldOfViewShape,
      PTag.kRadiationSetting,
    ];

    //VM.k2
    const csTags1 = const <PTag>[
      PTag.kPatientOrientation,
      PTag.kReportStatusIDTrial,
      PTag.kSeriesType,
      PTag.kDisplaySetPatientOrientation
    ];

    //VM.k2_n
    const csTags2 = const <PTag>[PTag.kImageType];

    //VM.k4
    const csTags3 = const <PTag>[
      PTag.kFrameType,
    ];

    //VM.k1_n
    const csTags4 = const <PTag>[
      PTag.kModalitiesInStudy,
      PTag.kIndicationType,
      PTag.kScanningSequence,
      PTag.kSequenceVariant,
      PTag.kScanOptions,
      PTag.kGrid,
      PTag.kFilterMaterial,
      PTag.kSelectorCSValue,
    ];

    const otherTags = const <PTag>[
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

      for (var tag in csTags0) {
        final validT0 = CS.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('CS isValidTag bad values', () {
      global.throwOnError = false;
      expect(CS.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => CS.isValidTag(PTag.kSelectorFDValue),
          throwsA(const isInstanceOf<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = CS.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => CS.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });
/*

    test('CS checkVRIndex good values', () {
      global.throwOnError = false;
      expect(CS.checkVRIndex(kCSIndex), kCSIndex);

      for (var tag in csTags0) {
        global.throwOnError = false;
        expect(CS.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('CS checkVRIndex bad values', () {
      global.throwOnError = false;
      expect(
          CS.checkVRIndex(
            kAEIndex,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => CS.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));
      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(CS.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => CS.checkVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('CS checkVRCode good values', () {
      global.throwOnError = false;
      expect(CS.checkVRCode(kCSCode), kCSCode);

      for (var tag in csTags0) {
        global.throwOnError = false;
        expect(CS.checkVRCode(tag.vrCode), tag.vrCode);
      }
    });

    test('CS checkVRCode bad values', () {
      global.throwOnError = false;
      expect(
          CS.checkVRCode(
            kAECode,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => CS.checkVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));
      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(CS.checkVRCode(tag.vrCode), isNull);

        global.throwOnError = true;
        expect(() => CS.checkVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });
*/

    test('CS isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(CS.isValidVRIndex(kCSIndex), true);

      for (var tag in csTags0) {
        global.throwOnError = false;
        expect(CS.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('CS isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(CS.isValidVRIndex(kSSIndex), false);

      global.throwOnError = true;
      expect(() => CS.isValidVRIndex(kSSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(CS.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => CS.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('CS isValidVRCode good values', () {
      global.throwOnError = false;
      expect(CS.isValidVRCode(kCSCode), true);

      for (var tag in csTags0) {
        expect(CS.isValidVRCode(tag.vrCode), true);
      }
    });

    test('CS isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(CS.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => CS.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(CS.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => CS.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('CS sValidVFLength good values', () {
      expect(CS.isValidVFLength(CS.kMaxVFLength), true);
      expect(CS.isValidVFLength(0), true);
    });

    test('CS sValidVFLength bad values', () {
      expect(CS.isValidVFLength(CS.kMaxVFLength + 1), false);
      expect(CS.isValidVFLength(-1), false);
    });

    test('CS isNotValidVFLength good values', () {
      expect(CS.isValidVFLength(CS.kMaxVFLength), true);
      expect(CS.isValidVFLength(0), true);
    });

    test('CS isNotValidVFLength bad values', () {
      expect(CS.isValidVFLength(CS.kMaxVFLength + 1), false);
      expect(CS.isValidVFLength(-1), false);
    });

    test('CS.isValidValueLength', () {
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
          CS.isValidValueLength('&t&wSB)~PIA!UIDX }d!zD2N3 2fz={@^mHL:'
              '/"qzD2N3 2fzLzgGEH6bTY&N}JzD2N3 2fz'),
          false);
    });

    test('CS.isNotValidValueLength', () {
      for (var s in goodCSList) {
        for (var a in s) {
          expect(CS.isValidValueLength(a), true);
        }
      }

      /* for (var s in badAELengthList) {
          expect(CS.isValidValueLength(s), false);
        }*/

      expect(
          CS.isValidValueLength('&t&wSB)~PIA!UIDX }d!zD2N3 2fz={@^mHL:'
              '/"qmczv9LzgGEH6bTY&N}J'),
          false);
    });

    test('CS isValidLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getCSList(1, 1);
        for (var tag in csTags0) {
          expect(CS.isValidLength(tag, validMinVList), true);

          expect(CS.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(CS.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('CS isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rsg.getCSList(2, i + 1);
        for (var tag in csTags0) {
          global.throwOnError = false;
          expect(CS.isValidLength(tag, validMinVList), false);

          expect(CS.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => CS.isValidLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('CS isValidLength VM.k2 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getCSList(2, 2);
        for (var tag in csTags1) {
          expect(CS.isValidLength(tag, validMinVList), true);

          expect(CS.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(CS.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('CS isValidLength VM.k2 bad values', () {
      for (var i = 2; i < 10; i++) {
        final validMinVList = rsg.getCSList(3, i + 1);
        for (var tag in csTags1) {
          global.throwOnError = false;
          expect(CS.isValidLength(tag, validMinVList), false);

          expect(
              CS.isValidLength(tag, invalidVList.take(tag.vmMax + 1)), false);
          expect(
              CS.isValidLength(tag, invalidVList.take(tag.vmMin - 1)), false);

          expect(CS.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => CS.isValidLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('CS isValidLength VM.k2_2n good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getCSList(10, 10);
        final validMaxLengthList = invalidVList.sublist(0, CS.kMaxLength);
        for (var tag in csTags2) {
          expect(CS.isValidLength(tag, validMinVList), true);

          expect(CS.isValidLength(tag, invalidVList.take(tag.vmMax + 3)), true);
          expect(CS.isValidLength(tag, validMaxLengthList), true);
        }
      }
    });

    test('CS isValidLength VM.k2_2n bad values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getCSList(1, 1);
        for (var tag in csTags2) {
          global.throwOnError = false;
          expect(CS.isValidLength(tag, validMinVList), false);

          expect(
              CS.isValidLength(tag, invalidVList.take(tag.vmMax + 2)), false);
          global.throwOnError = true;
          expect(() => CS.isValidLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('CS isValidLength VM.k4 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getCSList(4, 4);
        for (var tag in csTags3) {
          expect(CS.isValidLength(tag, validMinVList), true);

          expect(CS.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(CS.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('CS isValidLength VM.k4 bad values', () {
      for (var i = 4; i < 10; i++) {
        final validMinVList = rsg.getCSList(5, i + 1);
        for (var tag in csTags3) {
          global.throwOnError = false;
          expect(CS.isValidLength(tag, validMinVList), false);

          expect(
              CS.isValidLength(tag, invalidVList.take(tag.vmMax + 1)), false);
          expect(
              CS.isValidLength(tag, invalidVList.take(tag.vmMin - 1)), false);
          expect(CS.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => CS.isValidLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('CS isValidLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final validMinVList0 = rsg.getCSList(1, i);
        final validMaxLengthList = invalidVList.sublist(0, CS.kMaxLength);
        for (var tag in csTags4) {
          log.debug('tag: $tag');
          expect(CS.isValidLength(tag, validMinVList0), true);
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
              throwsA(const isInstanceOf<StringError>()));
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
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('CS fromBytes', () {
      //  system.level = Level.info;;
      final vList1 = rsg.getCSList(1, 1);
      final bytes = Bytes.fromAsciiList(vList1);
      log.debug('bytes.getAsciiList(): ${bytes.getAsciiList()}, bytes: $bytes');
      expect(bytes.getAsciiList(), equals(vList1));
    });

    test('CS Bytes.fromAsciiList', () {
      final vList1 = rsg.getCSList(1, 1);
      log.debug('Bytes.fromAsciiList(vList1): ${Bytes.fromAsciiList(vList1)}');
      final val = cvt.ascii.encode('s6V&:;s%?Q1g5v');
      expect(Bytes.fromAsciiList(['s6V&:;s%?Q1g5v']), equals(val));

      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = cvt.ascii.encode(vList1[0]);
      expect(Bytes.fromAsciiList(vList1), equals(values));
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
          throwsA(const isInstanceOf<StringError>()));
      for (var s in badCSList) {
        global.throwOnError = false;
        expect(CS.isValidValues(PTag.kSCPStatus, s), false);

        global.throwOnError = true;
        expect(() => CS.isValidValues(PTag.kSCPStatus, s),
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('CS toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        global.throwOnError = false;
        final values = cvt.ascii.encode(vList0[0]);
        final tbd0 = Bytes.fromAsciiList(vList0);
        final tbd1 = Bytes.fromAsciiList(vList0);
        log.debug('tbd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodCSList) {
        for (var a in s) {
          final values = cvt.ascii.encode(a);
          final tbd2 = Bytes.fromAsciiList(s);
          final tbd3 = Bytes.fromAsciiList(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('CS fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.fromAsciiList(vList0);
        final fbd0 = bd0.getAsciiList();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (var s in goodCSList) {
        final bd0 = Bytes.fromAsciiList(s);
        final fbd0 = bd0.getAsciiList();
        expect(fbd0, equals(s));
      }
    });

    test('CS toBytes ', () {
      for (var i = 0; i < 10; i++) {
        final sList0 = rsg.getCSList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.fromAsciiList(sList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(sList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodCSList) {
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
        final ui0 = new UItag(PTag.kStudyInstanceUID, s);
        expect(ui0.hasValidValues, true);
      }
      global.throwOnError = false;
      final ui0 = new UItag(PTag.kConcatenationUID, []);
      expect(ui0.hasValidValues, true);
      expect(ui0.values, equals(<String>[]));
    });

    test('UI hasValidValues bad values', () {
      for (var s in badUIList) {
        global.throwOnError = false;
        final ui0 = new UItag(PTag.kStudyInstanceUID, s);
        expect(ui0, isNull);

        global.throwOnError = true;
        expect(() => new UItag(PTag.kStudyInstanceUID, s),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final ui1 = new UItag(PTag.kConcatenationUID, null);
      log.debug('ui1: $ui1');
      expect(ui1, isNull);

      global.throwOnError = true;
      expect(() => new UItag(PTag.kStudyInstanceUID, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('UI hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        final ui0 = new UItag(PTag.kStudyInstanceUID, vList0);
        log.debug('ui0:${ui0.info}');
        expect(ui0.hasValidValues, true);

        log
          ..debug('ui0: $ui0, values: ${ui0.values}')
          ..debug('ui0: ${ui0.info}');
        expect(ui0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 10);
        final ui1 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList0);
        expect(ui1.hasValidValues, true);

        log
          ..debug('ui1: $ui1, values: ${ui1.values}')
          ..debug('ui1: ${ui1.info}');
        expect(ui1[0], equals(vList0[0]));
      }
    });

    test('UI hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(3, 4);
        log.debug('$i: vList0: $vList0');

        global.throwOnError = false;
        final ui2 = new UItag(PTag.kStudyInstanceUID, vList0);
        expect(ui2, isNull);

        global.throwOnError = true;
        expect(() => new UItag(PTag.kStudyInstanceUID, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('UI update random', () {
      global.throwOnError = false;
      final vList0 = rsg.getUIList(3, 4);
      final ui0 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList0);
      expect(utility.testElementUpdate(ui0, vList0), true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(3, 4);
        final ui1 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList0);
        final vList1 = rsg.getUIList(3, 4);
        expect(ui1.update(vList1).values, equals(vList1));
      }

      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getUIList(3, 4);
        final ui1 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList0);
        final vList1 = rsg.getAEList(3, 4);
        expect(ui1.update(vList1), isNull);

        global.throwOnError = true;
        final vList2 = rsg.getUIList(3, 4);
        final ui2 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList2);
        final vList3 = rsg.getAEList(3, 4);
        expect(() => ui2.update(vList3),
            throwsA(const isInstanceOf<String>()));
      }

      global.throwOnError = true;
      final vList2 = rsg.getUIList(3, 4);
      final ui2 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList2);
      final vList3 = ['3.2.840.10008.1.2.0'];
      expect(() => ui2.update(vList3),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('UI noValues random', () {
      final ui0 = new UItag(PTag.kRelatedGeneralSOPClassUID, []);
      final UItag uiNoValues = ui0.noValues;
      expect(uiNoValues.values.isEmpty, true);
      log.debug('ui0: ${ui0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(3, 4);
        final ui0 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList0);
        log.debug('ui0: $ui0');
        expect(uiNoValues.values.isEmpty, true);
        log.debug('ui0: ${ui0.noValues}');
      }
    });

    test('UI copy random', () {
      final ui0 = new UItag(PTag.kRelatedGeneralSOPClassUID, []);
      final UItag ui1 = ui0.copy;
      expect(ui1 == ui0, true);
      expect(ui1.hashCode == ui0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(3, 4);
        final ui2 = new UItag(PTag.kRelatedGeneralSOPClassUID, vList0);
        final UItag ui3 = ui2.copy;
        expect(ui3 == ui2, true);
        expect(ui3.hashCode == ui2.hashCode, true);
      }
    });

    test('UI hashCode and == good values random', () {
      List<String> stringList0;
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getUIList(1, 1);
        final ui0 = new UItag(PTag.kConcatenationUID, stringList0);
        final ui1 = new UItag(PTag.kConcatenationUID, stringList0);
        log
          ..debug('stringList0:$stringList0, ui0.hash_code:${ui0.hashCode}')
          ..debug('stringList0:$stringList0, ui1.hash_code:${ui1.hashCode}');
        expect(ui0.hashCode == ui1.hashCode, true);
        expect(ui0 == ui1, true);
      }
    });

    test('UI hashCode and == bad values random', () {
      global.throwOnError = false;
      List<String> stringList0;
      List<String> stringList1;
      List<String> stringList2;
      List<String> stringList3;

      log.debug('UI hashCode and ==');
      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getUIList(1, 1);
        final ui0 = new UItag(PTag.kConcatenationUID, stringList0);

        stringList1 = rsg.getUIList(1, 1);
        final ui2 = new UItag(PTag.kDimensionOrganizationUID, stringList1);
        log.debug('stringList1:$stringList1 , ui2.hash_code:${ui2.hashCode}');
        expect(ui0.hashCode == ui2.hashCode, false);
        expect(ui0 == ui2, false);

        stringList2 = rsg.getUIList(1, 10);
        final ui3 = new UItag(PTag.kRelatedGeneralSOPClassUID, stringList2);
        log.debug('stringList2:$stringList2 , ui3.hash_code:${ui3.hashCode}');
        expect(ui0.hashCode == ui3.hashCode, false);
        expect(ui0 == ui3, false);

        stringList3 = rsg.getUIList(2, 3);
        final ui4 = new UItag(PTag.kLaterality, stringList3);
        log.debug('stringList3:$stringList3 , ui4.hash_code:${ui4.hashCode}');
        expect(ui0.hashCode == ui4.hashCode, false);
        expect(ui0 == ui4, false);
      }
    });

    test('UI valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        final ui0 = new UItag(PTag.kSOPInstanceUID, vList0);
        expect(vList0, equals(ui0.valuesCopy));
      }
    });

    test('UI isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        final ui0 = new UItag(PTag.kSOPInstanceUID, vList0);
        expect(ui0.tag.isValidLength(ui0), true);
      }
    });

    test('UI isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        final ui0 = new UItag(PTag.kSOPInstanceUID, vList0);
        expect(ui0.checkValues(ui0.values), true);
        expect(ui0.hasValidValues, true);
      }
    });

    test('UI replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        final ui0 = new UItag(PTag.kSOPInstanceUID, vList0);
        final vList1 = rsg.getUIList(1, 1);
        expect(ui0.replace(vList1), equals(vList0));
        expect(ui0.values, equals(vList1));
      }

      final vList1 = rsg.getUIList(1, 1);
      final ui1 = new UItag(PTag.kSOPInstanceUID, vList1);
      expect(ui1.replace([]), equals(vList1));
      expect(ui1.values, equals(<String>[]));

      final ui2 = new UItag(PTag.kSOPInstanceUID, vList1);
      expect(ui2.replace(null), equals(vList1));
      expect(ui2.values, equals(<String>[]));
    });

    test('UI fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getUIList(1, 1);
        final bytes = Bytes.fromAsciiList(vList1);
        log.debug('bytes:$bytes');
        final ui0 = UItag.fromBytes(PTag.kSOPInstanceUID, bytes);
        log.debug('$i: ui0: ${ui0.info}');
        expect(ui0.hasValidValues, true);
      }
    });

    test('UI fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getUIList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          final ui1 = UItag.fromBytes(PTag.kSelectorUIValue, bytes0);
          log.debug('ui1: ${ui1.info}');
          expect(ui1.hasValidValues, true);
        }
      }
    });

    test('UI fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getUIList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.fromAscii(listS);
          final ui1 = UItag.fromBytes(PTag.kSelectorAEValue, bytes0);
          expect(ui1, isNull);

          global.throwOnError = true;
          expect(() => UItag.fromBytes(PTag.kSelectorAEValue, bytes0),
              throwsA(const isInstanceOf<InvalidTagError>()));
        }
      }
    });

    test('UI make good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        final make0 = UItag.fromValues(PTag.kSOPInstanceUID, vList0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);

        final make1 = UItag.fromValues(PTag.kSOPInstanceUID, <String>[]);
        expect(make1.hasValidValues, true);
        expect(make1.values, equals(<String>[]));
      }
    });

    test('UI make bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(2, 2);
        global.throwOnError = false;
        final make0 = UItag.fromValues(PTag.kSOPInstanceUID, vList0);
        expect(make0, isNull);

        global.throwOnError = true;
        expect(() => UItag.fromValues(PTag.kSOPInstanceUID, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final make1 = UItag.fromValues(PTag.kSOPInstanceUID, <String>[null]);
      log.debug('make1: $make1');
      expect(make1, isNull);

      global.throwOnError = true;
      expect(() => UItag.fromValues(PTag.kSOPInstanceUID, <String>[null]),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('UI checkLength good values', () {
      final vList0 = rsg.getUIList(1, 1);
      final ui0 = new UItag(PTag.kSOPInstanceUID, vList0);
      for (var s in goodUIList) {
        expect(ui0.checkLength(s), true);
      }
      final ui1 = new UItag(PTag.kSOPInstanceUID, vList0);
      expect(ui1.checkLength([]), true);
    });

    test('UI checkLength bad values', () {
      final vList0 = rsg.getUIList(1, 1);
      final vList1 = ['1.2.840.10008.5.1.4.34.5', '1.2.840.10008.3.1.2.32.7'];
      final ui2 = new UItag(PTag.kSOPInstanceUID, vList0);
      expect(ui2.checkLength(vList1), false);
    });

    test('UI checkValue good values', () {
      final vList0 = rsg.getUIList(1, 1);
      final ui0 = new UItag(PTag.kSOPInstanceUID, vList0);
      for (var s in goodUIList) {
        for (var a in s) {
          expect(ui0.checkValue(a), true);
        }
      }
    });

    test('UI checkValue bad values', () {
      final vList0 = rsg.getUIList(1, 1);
      final ui0 = new UItag(PTag.kSOPInstanceUID, vList0);
      for (var s in badUIList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(ui0.checkValue(a), false);
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
            throwsA(const isInstanceOf<InvalidUidError>()));
      }

      global.throwOnError = false;
      final parse3 = Uid.parseList(['1.3.5']);
      expect(parse3, equals([null]));

      const s0 =  '1.2.840.10008.5.1.4.34.5.345.22.5467456'
          '.5.1.4.34.5.345.22.5467456.55.45';
      final parse4 = Uid.parseList([s0]);

      expect(parse4, equals([null]));

      global.throwOnError = true;
      expect(() => Uid.parseList(['1.3.5']),
          throwsA(const isInstanceOf<InvalidUidError>()));
    });

    test('UI update random', () {
      global.throwOnError = false;
      final ui0 = new UItag(PTag.kSelectorUIValue, []);
      expect(ui0.update(['1.2.840.10008.5.1.4.34.5']).values,
          equals(['1.2.840.10008.5.1.4.34.5']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUIList(1, 1);
        final ui1 = new UItag(PTag.kSOPInstanceUID, vList0);
        final vList1 = rsg.getUIList(1, 1);
        expect(ui1.update(vList1).values, equals(vList1));
      }
    });
  });

  group('UI', () {
    //VM.k1
    const uiTags0 = const <PTag>[
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
    const uiTags1 = const <PTag>[
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

      for (var tag in uiTags0) {
        final validT0 = UI.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('UI isValidTag bad values', () {
      global.throwOnError = false;
      expect(UI.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => UI.isValidTag(PTag.kSelectorFDValue),
          throwsA(const isInstanceOf<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = UI.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => UI.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidTagError>()));
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
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UI.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => UI.checkVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
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
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UI.checkVRCode(tag.vrCode), isNull);

        global.throwOnError = true;
        expect(() => UI.checkVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });
*/

    test('UI isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(UI.isValidVRIndex(kUIIndex), true);

      for (var tag in uiTags0) {
        global.throwOnError = false;
        expect(UI.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('UI isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(UI.isValidVRIndex(kSSIndex), false);

      global.throwOnError = true;
      expect(() => UI.isValidVRIndex(kSSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UI.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => UI.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UI isValidVRCode good values', () {
      global.throwOnError = false;
      expect(UI.isValidVRCode(kUICode), true);

      for (var tag in uiTags0) {
        expect(UI.isValidVRCode(tag.vrCode), true);
      }
    });

    test('UI isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(UI.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => UI.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));
      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UI.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => UI.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UI isValidVFLength good values', () {
      expect(UI.isValidVFLength(UI.kMaxVFLength), true);
      expect(UI.isValidVFLength(0), true);
    });

    test('UI isValidVFLength bad values', () {
      expect(UI.isValidVFLength(UI.kMaxVFLength + 1), false);
      expect(UI.isValidVFLength(-1), false);
    });

    test('UI isNotValidVFLength good values', () {
      expect(UI.isValidVFLength(UI.kMaxVFLength), true);
      expect(UI.isValidVFLength(0), true);
    });

    test('UI isNotValidVFLength good values', () {
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

    test('UI isNotValidValueLength', () {
      for (var s in goodUIList) {
        for (var a in s) {
          expect(UI.isValidValueLength(a), true);
        }
      }
    });

    test('UI isValidLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getUIList(1, 1);
        for (var tag in uiTags0) {
          expect(UI.isValidLength(tag, validMinVList), true);

          expect(UI.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(UI.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('UI isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rsg.getUIList(2, i + 1);
        for (var tag in uiTags0) {
          global.throwOnError = false;
          expect(UI.isValidLength(tag, validMinVList), false);

          expect(UI.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => UI.isValidLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('UI isValidLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final validMinVList0 = rsg.getUIList(1, i);
        final validMaxLengthList = invalidVList.sublist(0, UI.kMaxLength);
        for (var tag in uiTags1) {
          log.debug('tag: $tag');
          expect(UI.isValidLength(tag, validMinVList0), true);
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
            throwsA(const isInstanceOf<StringError>()));
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
          throwsA(const isInstanceOf<StringError>()));
      global.throwOnError = false;

      for (var i = 0; i <= 10; i++) {
        for (var s in badUIList) {
          global.throwOnError = false;
          expect(UI.isValidValues(PTag.kInstanceCreatorUID, s), false);

          global.throwOnError = true;
          expect(() => UI.isValidValues(PTag.kInstanceCreatorUID, s),
              throwsA(const isInstanceOf<InvalidValuesError>()));
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
        final sList0 = rsg.getUIList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.fromAsciiList(sList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(sList0.join('\\'));
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
          throwsA(const isInstanceOf<GeneralError>()));
    });
  });

  const goodURList = const <List<String>>[
    const <String>['http:/TVc8mR/swk/jvNtF/Uy6'],
    const <String>['iaWlVR'],
    const <String>['http:/l_YB2r8/LQIo9'],
    const <String>['_m3G9go/OkgpQ'],
    const <String>['\b'], //	Backspace
    const <String>['\t '], //horizontal tab (HT)
    const <String>['\n'], //linefeed (LF)
    const <String>['\f '], // form feed (FF)
    const <String>['\r '], //carriage return (CR)
    const <String>['\v'], //vertical tab
  ];

  const badURList = const <List<String>>[
    const <String>[' asdf sdf  ']
  ];
  group('URtag', () {
    test('UR hasValidValues good values', () {
      for (var s in goodURList) {
        global.throwOnError = false;
        final ur0 = new URtag(PTag.kRetrieveURI, s);
        expect(ur0.hasValidValues, true);
      }

      final ur0 = new URtag(PTag.kPixelDataProviderURL, []);
      expect(ur0.hasValidValues, true);
      expect(ur0.values, equals(<String>[]));
    });

    test('UR hasValidValues bad values', () {
      for (var s in badURList) {
        global.throwOnError = false;
        final ur0 = new URtag(PTag.kRetrieveURI, s);
        expect(ur0, isNull);

        global.throwOnError = true;
        expect(() => new URtag(PTag.kRetrieveURI, s),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      global.throwOnError = false;
      expect(new URtag(PTag.kPixelDataProviderURL, null), isNull);

      global.throwOnError = true;
      expect(() => new URtag(PTag.kPixelDataProviderURL, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('UR hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final ur0 = new URtag(PTag.kRetrieveURI, vList0);
        log.debug('ur0:${ur0.info}');
        expect(ur0.hasValidValues, true);

        log
          ..debug('ur0: $ur0, values: ${ur0.values}')
          ..debug('ur0: ${ur0.info}');
        expect(ur0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        log.debug('$i: vList0: $vList0');
        final ui1 = new URtag(PTag.kRetrieveURI, vList0);
        expect(ui1.hasValidValues, true);
      }
    });

    test('UR update random', () {
      global.throwOnError = false;
      final ur0 = new URtag(PTag.kSelectorURValue, []);
      expect(ur0.update(['m3ZXGWA_']).values, equals(['m3ZXGWA_']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final ui1 = new URtag(PTag.kPixelDataProviderURL, vList0);
        final vList1 = rsg.getURList(1, 1);
        expect(ui1.update(vList1).values, equals(vList1));
      }
    });

    test('UR noValues random', () {
      final ur0 = new URtag(PTag.kPixelDataProviderURL, []);
      final URtag urNoValues = ur0.noValues;
      expect(urNoValues.values.isEmpty, true);
      log.debug('ur0: ${ur0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final ur0 = new URtag(PTag.kPixelDataProviderURL, vList0);
        log.debug('ur0: $ur0');
        expect(urNoValues.values.isEmpty, true);
        log.debug('ur0: ${ur0.noValues}');
      }
    });

    test('UR copy random', () {
      final ur0 = new URtag(PTag.kPixelDataProviderURL, []);
      final URtag ur1 = ur0.copy;
      expect(ur1 == ur0, true);
      expect(ur1.hashCode == ur0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final ur2 = new URtag(PTag.kPixelDataProviderURL, vList0);
        final URtag ur3 = ur2.copy;
        expect(ur3 == ur2, true);
        expect(ur3.hashCode == ur2.hashCode, true);
      }
    });

    test('UR hashCode and == good values random', () {
      List<String> stringList0;

      for (var i = 0; i < 10; i++) {
        stringList0 = rsg.getURList(1, 1);
        final ur0 = new URtag(PTag.kRetrieveURL, stringList0);
        final ur1 = new URtag(PTag.kRetrieveURL, stringList0);
        log
          ..debug('stringList0:$stringList0, ur0.hash_code:${ur0.hashCode}')
          ..debug('stringList0:$stringList0, ur1.hash_code:${ur1.hashCode}');
        expect(ur0.hashCode == ur1.hashCode, true);
        expect(ur0 == ur1, true);
      }
    });

    test('UR hashCode and == bad values random', () {
      for (var i = 0; i < 10; i++) {
        final stringList0 = rsg.getURList(2, 2 + i);
        final stringList1 = rsg.getURList(2, 2 + i);
        final stringList2 = rsg.getURList(2, 2 + i);

        global.throwOnError = false;
        final ur0 = new URtag(PTag.kRetrieveURL, stringList0);
        log.debug('stringList0:$stringList0');
        expect(ur0, isNull);
        final ur1 = new URtag(PTag.kPixelDataProviderURL, stringList1);
        expect(ur1, isNull);
        log.debug('stringList1:$stringList1');
        final ur2 = new URtag(PTag.kRetrieveURL, stringList2);
        log.debug('stringList2:$stringList2');
        expect(ur2, isNull);

        global.throwOnError = true;
        expect(() => new URtag(PTag.kRetrieveURL, stringList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
        expect(() => new URtag(PTag.kPixelDataProviderURL, stringList1),
            throwsA(const isInstanceOf<InvalidValuesError>()));
        expect(() => new URtag(PTag.kRetrieveURL, stringList2),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('UR valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final ur0 = new URtag(PTag.kRetrieveURL, vList0);
        expect(vList0, equals(ur0.valuesCopy));
      }
    });

    test('UR isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final ur0 = new URtag(PTag.kRetrieveURL, vList0);
        expect(ur0.tag.isValidLength(ur0), true);
      }
    });

    test('UR isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final ur0 = new URtag(PTag.kRetrieveURL, vList0);
        expect(ur0.checkValues(ur0.values), true);
        expect(ur0.hasValidValues, true);
      }
    });

    test('UR replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final ur0 = new URtag(PTag.kRetrieveURL, vList0);
        final vList1 = rsg.getURList(1, 1);
        expect(ur0.replace(vList1), equals(vList0));
        expect(ur0.values, equals(vList1));
      }

      final vList1 = rsg.getURList(1, 1);
      final ur1 = new URtag(PTag.kRetrieveURL, vList1);
      expect(ur1.replace([]), equals(vList1));
      expect(ur1.values, equals(<String>[]));

      final ur2 = new URtag(PTag.kRetrieveURL, vList1);
      expect(ur2.replace(null), equals(vList1));
      expect(ur2.values, equals(<String>[]));
    });

    test('UR fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getURList(1, 1);
        final bytes = Bytes.fromAsciiList(vList1);
        log.debug('bytes:$bytes');
        final ur0 = URtag.fromBytes(PTag.kRetrieveURL, bytes);
        log.debug('ur0: ${ur0.info}');
        expect(ur0.hasValidValues, true);
      }
    });

    test('UR fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getURList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          final ur1 = URtag.fromBytes(PTag.kSelectorURValue, bytes0);
          log.debug('ur1: ${ur1.info}');
          expect(ur1.hasValidValues, true);
        }
      }
    });

    test('UR fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getURList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.fromAscii(listS);
          final ur1 = URtag.fromBytes(PTag.kSelectorAEValue, bytes0);
          expect(ur1, isNull);

          global.throwOnError = true;
          expect(() => URtag.fromBytes(PTag.kSelectorAEValue, bytes0),
              throwsA(const isInstanceOf<InvalidTagError>()));
        }
      }
    });

    test('UR make good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final make0 = URtag.fromValues(PTag.kRetrieveURL, vList0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);

        final make1 = URtag.fromValues(PTag.kRetrieveURL, <String>[]);
        expect(make1.hasValidValues, true);
        expect(make1.values, equals(<String>[]));
      }
    });

    test('UR make bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(2, 2);
        global.throwOnError = false;
        final make0 = URtag.fromValues(PTag.kRetrieveURL, vList0);
        expect(make0, isNull);

        global.throwOnError = true;
        expect(() => URtag.fromValues(PTag.kRetrieveURL, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final make1 = URtag.fromValues(PTag.kRetrieveURL, <String>[null]);
      log.debug('make1: $make1');
      expect(make1, isNull);

      global.throwOnError = true;
      expect(() => URtag.fromValues(PTag.kRetrieveURL, <String>[null]),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('UR checkLength good values', () {
      final vList0 = rsg.getURList(1, 1);
      final ur0 = new URtag(PTag.kRetrieveURL, vList0);
      for (var s in goodURList) {
        expect(ur0.checkLength(s), true);
      }
      final ur1 = new URtag(PTag.kRetrieveURL, vList0);
      expect(ur1.checkLength([]), true);
    });

    test('UR checkLength bad values', () {
      final vList0 = rsg.getURList(1, 1);
      final vList1 = ['1.2.840.10008.5.1.4.34.5', '1.2.840.10008.3.1.2.32.7'];
      final ur2 = new URtag(PTag.kRetrieveURL, vList0);
      expect(ur2.checkLength(vList1), false);
    });

    test('UR checkValue good values', () {
      final vList0 = rsg.getURList(1, 1);
      final ur0 = new URtag(PTag.kRetrieveURL, vList0);
      for (var s in goodURList) {
        for (var a in s) {
          expect(ur0.checkValue(a), true);
        }
      }
    });

    test('UR checkValue bad values', () {
      final vList0 = rsg.getURList(1, 1);
      final ur0 = new URtag(PTag.kRetrieveURL, vList0);
      for (var s in badURList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(ur0.checkValue(a), false);
        }
      }
    });

    test('UR decodeBinaryTextVF', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getURList(1, 1);
        final bytes = Bytes.fromAsciiList(vList1);
        final dbTxt0 = bytes.getUtf8List();
        log.debug('dbTxt0: $dbTxt0');
        expect(dbTxt0, equals(vList1));

        final dbTxt1 = bytes.getUtf8List();
        log.debug('dbTxt1: $dbTxt1');
        expect(dbTxt1, equals(vList1));
      }
    });
  });

  group('UR', () {
    //VM.k1
    const urTags0 = const <PTag>[
      PTag.kRetrieveURL,
      PTag.kPixelDataProviderURL,
      PTag.kRetrieveURI,
      PTag.kContactURI,
    ];

    //VM.k1_n
    const urTags1 = const <PTag>[PTag.kSelectorURValue];

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

    final invalidVList = rsg.getURList(UR.kMaxLength + 1, UR.kMaxLength + 1);

    test('UR isValidTag good values', () {
      global.throwOnError = false;
      expect(UR.isValidTag(PTag.kSelectorURValue), true);

      for (var tag in urTags0) {
        final validT0 = UR.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('UR isValidTag bad values', () {
      global.throwOnError = false;
      expect(UR.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => UR.isValidTag(PTag.kSelectorFDValue),
          throwsA(const isInstanceOf<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = UR.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => UR.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });
/*

    test('UR checkVRIndex good values', () {
      global.throwOnError = false;
      expect(UR.checkVRIndex(kURIndex), kURIndex);

      for (var tag in urTags0) {
        global.throwOnError = false;
        expect(UR.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('UR checkVRIndex bad values', () {
      global.throwOnError = false;
      expect(
          UR.checkVRIndex(
            kAEIndex,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => UR.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UR.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => UR.checkVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UR checkVRCode good values', () {
      global.throwOnError = false;
      expect(UR.checkVRCode(kURCode), kURCode);

      for (var tag in urTags0) {
        global.throwOnError = false;
        expect(UR.checkVRCode(tag.vrCode), tag.vrCode);
      }
    });

    test('UR checkVRCode bad values', () {
      global.throwOnError = false;
      expect(
          UR.checkVRCode(
            kAECode,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => UR.checkVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UR.checkVRCode(tag.vrCode), isNull);

        global.throwOnError = true;
        expect(() => UR.checkVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });
*/

    test('UR isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(UR.isValidVRIndex(kURIndex), true);

      for (var tag in urTags0) {
        global.throwOnError = false;
        expect(UR.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('UR isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(UR.isValidVRIndex(kSSIndex), false);

      global.throwOnError = true;
      expect(() => UR.isValidVRIndex(kSSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UR.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => UR.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UR isValidVRCode good values', () {
      global.throwOnError = false;
      expect(UR.isValidVRCode(kURCode), true);

      for (var tag in urTags0) {
        expect(UR.isValidVRCode(tag.vrCode), true);
      }
    });

    test('UR isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(UR.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => UR.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UR.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => UR.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UR isValidVFLength good values', () {
      expect(UR.isValidVFLength(UR.kMaxVFLength), true);
      expect(UR.isValidVFLength(0), true);
    });

    test('UR isValidVFLength bad values', () {
      expect(UR.isValidVFLength(UR.kMaxVFLength + 1), false);
      expect(UR.isValidVFLength(-1), false);
    });

    test('UR isNotValidVFLength good values', () {
      expect(UR.isValidVFLength(UR.kMaxVFLength), true);
      expect(UR.isValidVFLength(0), true);
    });

    test('UR isNotValidVFLength bad values', () {
      expect(UR.isValidVFLength(UR.kMaxVFLength + 1), false);
      expect(UR.isValidVFLength(-1), false);
    });

    test('UR isValidValueLength', () {
      for (var s in goodURList) {
        for (var a in s) {
          expect(UR.isValidValueLength(a), true);
        }
      }
    });

    test('UR isNotValidValueLength', () {
      for (var s in goodURList) {
        for (var a in s) {
          expect(UR.isValidValueLength(a), true);
        }
      }
    });

    test('UR isValidLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final validMinVList = rsg.getURList(1, 1);
        for (var tag in urTags0) {
          expect(UR.isValidLength(tag, validMinVList), true);

          expect(UR.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(UR.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('UR isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        for (var tag in urTags0) {
          final invalidValues = rsg.getURList(2, i + 1);
          global.throwOnError = false;

          expect(UR.isValidLength(tag, invalidVList), false);
          expect(UR.isValidLength(tag, invalidValues), false);

          global.throwOnError = true;
          expect(() => UR.isValidLength(tag, invalidVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
          expect(() => UR.isValidLength(tag, invalidValues),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('UR isValidLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final validMinVList0 = rsg.getURList(1, i);
        final validMaxLengthList = invalidVList.sublist(0, UR.kMaxLength);
        for (var tag in urTags1) {
          log.debug('tag: $tag');
          expect(UR.isValidLength(tag, validMinVList0), true);
          expect(UR.isValidLength(tag, validMaxLengthList), true);
        }
      }
    });

    test('UR isValidValue good values', () {
      for (var s in goodURList) {
        for (var a in s) {
          expect(UR.isValidValue(a), true);
        }
      }
    });

    test('UR isValidValue bad values', () {
      for (var s in badURList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(UR.isValidValue(a), false);
        }
      }
    });

    test('UR isValidValues good values', () {
      global.throwOnError = false;
      for (var s in goodURList) {
        expect(UR.isValidValues(PTag.kRetrieveURL, s), true);
      }
    });

    test('UR isValidValues bad values', () {
      global.throwOnError = false;
      for (var s in badURList) {
        global.throwOnError = false;
        expect(UR.isValidValues(PTag.kRetrieveURL, s), false);

        global.throwOnError = true;
        expect(() => UR.isValidValues(PTag.kRetrieveURL, s),
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('UR fromBytes', () {
      //  system.level = Level.info;;
      final vList1 = rsg.getURList(1, 1);
      final bytes = Bytes.fromAsciiList(vList1);
      log.debug('bytes.getAsciiList(): ${bytes.getAsciiList()}, bytes: $bytes');
      expect(bytes.getAsciiList(), equals(vList1));
    });

    test('UR Bytes.fromAsciiList', () {
      final vList1 = rsg.getURList(1, 1);
      log.debug('Bytes.fromAsciiList(vList1): ${Bytes.fromAsciiList(vList1)}');
      final val = cvt.ascii.encode('s6V&:;s%?Q1g5v');
      expect(Bytes.fromAsciiList(['s6V&:;s%?Q1g5v']), equals(val));

      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = cvt.ascii.encode(vList1[0]);
      expect(Bytes.fromAsciiList(vList1), equals(values));
    });

    test('UR parse', () {
      global.throwOnError = false;
      final vList0 = rsg.getISList(1, 1);
      expect(UR.tryParse(vList0[0]), Uri.parse(vList0[0]));

      const vList1 = '123';
      expect(UR.parse(vList1), Uri.parse(vList1));

      const vList2 = '12.34';
      expect(UR.parse(vList2), Uri.parse(vList2));

      const vList3 = 'abc';
      expect(UR.parse(vList3), Uri.parse(vList3));
    });

    test('UR tryParse', () {
      global.throwOnError = false;
      final vList0 = rsg.getISList(1, 1);
      expect(UR.tryParse(vList0[0]), Uri.parse(vList0[0]));

      const vList1 = '123';
      expect(UR.tryParse(vList1), Uri.parse(vList1));

      const vList2 = '12.34';
      expect(UR.tryParse(vList2), Uri.parse(vList2));

      const vList3 = 'abc';
      expect(UR.tryParse(vList3), Uri.parse(vList3));
    });

    test('UR isValidValues good values', () {
      global.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList = rsg.getURList(1, 1);
        expect(UR.isValidValues(PTag.kRetrieveURL, vList), true);
      }

      final vList0 = ['iaWlVR'];
      expect(UR.isValidValues(PTag.kRetrieveURL, vList0), true);

      for (var s in goodURList) {
        global.throwOnError = false;
        expect(UR.isValidValues(PTag.kRetrieveURL, s), true);
      }
    });

    test('UR isValidValues bad values', () {
      global.throwOnError = false;
      final vList1 = [' asdf sdf  '];
      expect(UR.isValidValues(PTag.kRetrieveURL, vList1), false);

      global.throwOnError = true;
      expect(() => UR.isValidValues(PTag.kRetrieveURL, vList1),
          throwsA(const isInstanceOf<StringError>()));
      for (var s in badURList) {
        global.throwOnError = false;
        expect(UR.isValidValues(PTag.kRetrieveURL, s), false);

        global.throwOnError = true;
        expect(() => UR.isValidValues(PTag.kRetrieveURL, s),
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('UR toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        global.throwOnError = false;
        final values = cvt.ascii.encode(vList0[0]);
        final tbd0 = Bytes.fromAsciiList(vList0);
        final tbd1 = Bytes.fromAsciiList(vList0);
        log.debug('tbd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodURList) {
        for (var a in s) {
          final values = cvt.ascii.encode(a);
          final tbd2 = Bytes.fromAsciiList(s);
          final tbd3 = Bytes.fromAsciiList(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('UR fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.fromAsciiList(vList0);
        final fbd0 = bd0.getAsciiList();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (var s in goodURList) {
        final bd0 = Bytes.fromAsciiList(s);
        final fbd0 = bd0.getAsciiList();
        expect(fbd0, equals(s));
      }
    });

    test('UR toBytes', () {
      for (var i = 0; i < 10; i++) {
        final sList0 = rsg.getURList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.fromAsciiList(sList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(sList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodURList) {
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
    });
  });
}
