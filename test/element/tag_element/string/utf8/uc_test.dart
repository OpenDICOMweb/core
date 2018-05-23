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
  Server.initialize(name: 'string/uc_test', level: Level.info);
  global.throwOnError = false;

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

  group('UCtag', () {
    test('UC hasValidValues good values', () {
      for (var s in goodUCList) {
        global.throwOnError = false;
        final e0 = new UCtag(PTag.kStrainDescription, s);
        expect(e0.hasValidValues, true);
      }

      global.throwOnError = false;
      final e0 = new UCtag(PTag.kGeneticModificationsDescription, []);
      expect(e0.hasValidValues, true);
      expect(e0.values, equals(<String>[]));
    });

    test('UC hasValidValues bad values', () {
      for (var s in badUCList) {
        global.throwOnError = false;
        final e0 = new UCtag(PTag.kStrainDescription, s);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => new UCtag(PTag.kStrainDescription, s),
            throwsA(const isInstanceOf<StringError>()));
      }
      global.throwOnError = false;
      final e1 = new UCtag(PTag.kGeneticModificationsDescription, null);
      log.debug('e1: $e1');
      expect(e1, isNull);

      global.throwOnError = true;
      expect(() => new UCtag(PTag.kStrainDescription, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('UC hasValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        final e0 = new UCtag(PTag.kStrainDescription, vList0);
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: ${e0.info}');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(3, 4);
        log.debug('$i: vList0: $vList0');

        global.throwOnError = false;
        final e1 = new UCtag(PTag.kGeneticModificationsDescription, vList0);
        expect(e1, isNull);
        global.throwOnError = true;
        expect(() => new UCtag(PTag.kGeneticModificationsDescription, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('UC update random', () {
      final e0 = new UCtag(PTag.kGeneticModificationsDescription, []);
      expect(e0.update(['d^u:96P, azV']).values, equals(['d^u:96P, azV']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(3, 4);
        global.throwOnError = false;
        final e1 = new UCtag(PTag.kGeneticModificationsDescription, vList0);
        expect(e1, isNull);
        final vList1 = rsg.getUCList(3, 4);
//        expect(e1.update(vList1).values, equals(vList1));
        expect(() => e1.update(vList1).values,
            throwsA(const isInstanceOf<NoSuchMethodError>()));
        global.throwOnError = true;
        expect(() => new UCtag(PTag.kGeneticModificationsDescription, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('UC noValues random', () {
      final e0 = new UCtag(PTag.kGeneticModificationsDescription, []);
      final UCtag ucNoValues = e0.noValues;
      expect(ucNoValues.values.isEmpty, true);
      log.debug('st0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        global.throwOnError = false;
        final e1 = new UCtag(PTag.kGeneticModificationsDescription, vList0);
        final UCtag ucNoValues1 = e1.noValues;
        expect(ucNoValues1.values.isEmpty, true);

        final vList1 = rsg.getUCList(2, 4);
        global.throwOnError = false;
        final e2 = new UCtag(PTag.kGeneticModificationsDescription, vList1);
        expect(e2, isNull);
        global.throwOnError = true;
        expect(() => new UCtag(PTag.kGeneticModificationsDescription, vList1),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('UC copy random', () {
      final e0 = new UCtag(PTag.kGeneticModificationsDescription, []);
      final UCtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(3, 4);
        global.throwOnError = false;
        final e2 = new UCtag(PTag.kGeneticModificationsDescription, vList0);
        expect(e2, isNull);
        expect(() => e1.update(vList0).values,
            throwsA(const isInstanceOf<NoSuchMethodError>()));
        expect(() => e2.copy, throwsA(const isInstanceOf<NoSuchMethodError>()));

        global.throwOnError = true;
        expect(() => new UCtag(PTag.kGeneticModificationsDescription, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('UC hashCode and == good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        final e0 = new UCtag(PTag.kGeneticModificationsDescription, vList0);
        final e1 = new UCtag(PTag.kGeneticModificationsDescription, vList0);
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
        final e0 = new UCtag(PTag.kGeneticModificationsDescription, vList0);
        final vList1 = rsg.getUCList(1, 1);
        final e1 = new UCtag(PTag.kStrainDescription, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, false);
        expect(e0 == e1, false);

        final vList2 = rsg.getUCList(2, 3);
        final e2 = new UCtag(PTag.kStrainDescription, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);
      }
    });

    test('UC valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        final e0 = new UCtag(PTag.kStrainDescription, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('UC isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        final e0 = new UCtag(PTag.kStrainDescription, vList0);
        expect(e0.tag.isValidLength(e0), true);
      }
    });

    test('UC isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        final e0 = new UCtag(PTag.kStrainDescription, vList0);
        expect(e0.checkValues(e0.values), true);
        expect(e0.hasValidValues, true);
      }
    });

    test('UC replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 1);
        final e0 = new UCtag(PTag.kStrainDescription, vList0);
        final vList1 = rsg.getUCList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getUCList(1, 1);
      final e1 = new UCtag(PTag.kStrainDescription, vList1);
      expect(e1.replace([]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = new UCtag(PTag.kStrainDescription, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(<String>[]));
    });

    test('UC blank random', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getUCList(1, 1);
        final e0 = new UCtag(PTag.kStrainDescription, vList1);
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

    test('UC fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getUCList(1, 1);
        final bytes = Bytes.fromUtf8List(vList1);
        log.debug('bytes:$bytes');
        final e0 = UCtag.fromBytes(bytes, PTag.kStrainDescription);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);
      }
    });

    test('UC fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getUCList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          //final bytes0 = new Bytes();
          final e1 = UCtag.fromBytes(bytes0, PTag.kSelectorUCValue);
          log.debug('e1: ${e1.info}');
          expect(e1.hasValidValues, true);
        }
      }
    });

    test('UC fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getUCList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.fromAscii(listS);
          //final bytes0 = new Bytes();
          final e1 = UCtag.fromBytes(bytes0, PTag.kSelectorCSValue);
          expect(e1, isNull);

          global.throwOnError = true;
          expect(() => UCtag.fromBytes(bytes0, PTag.kSelectorCSValue),
              throwsA(const isInstanceOf<InvalidTagError>()));
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
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final e1 = UCtag.fromValues(PTag.kStrainDescription, <String>[null]);
      log.debug('mak1: $e1');
      expect(e1, isNull);

      global.throwOnError = true;
      expect(() => UCtag.fromValues(PTag.kStrainDescription, <String>[null]),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('UC checkLength good values', () {
      final vList0 = rsg.getUCList(1, 1);
      final e0 = new UCtag(PTag.kStrainDescription, vList0);
      for (var s in goodUCList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = new UCtag(PTag.kStrainDescription, vList0);
      expect(e1.checkLength([]), true);
    });

    test('UC checkLength bad values', () {
      final vList1 = ['a^1sd', '02@#'];
      global.throwOnError = false;
      final e2 = new UCtag(PTag.kStrainDescription, vList1);
      expect(e2, isNull);
      expect(() => e2.checkLength(vList1),
          throwsA(const isInstanceOf<NoSuchMethodError>()));
    });

    test('UC checkValue good values', () {
      final vList0 = rsg.getUCList(1, 1);
      final e0 = new UCtag(PTag.kStrainDescription, vList0);
      for (var s in goodUCList) {
        for (var a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });

    test('UC checkValue bad values', () {
      final vList0 = rsg.getUCList(1, 1);
      final e0 = new UCtag(PTag.kStrainDescription, vList0);
      for (var s in badUCList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(e0.checkValue(a), false);

          global.throwOnError = true;
          expect(() => e0.checkValue(a),
              throwsA(const isInstanceOf<StringError>()));
        }
      }
    });
  });

  group('UC', () {
    //VM.k1
    const ucVM1Tags = const <PTag>[
      PTag.kStrainDescription,
      PTag.kGeneticModificationsDescription,
    ];

    //VM.k1_n
    const ucVM1_nTags = const <PTag>[
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

    test('UC isValidTag good values', () {
      global.throwOnError = false;
      expect(UC.isValidTag(PTag.kSelectorUCValue), true);

      for (var tag in ucVM1Tags) {
        final validT0 = UC.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('UC isValidTag bad values', () {
      global.throwOnError = false;
      expect(UC.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => UC.isValidTag(PTag.kSelectorFDValue),
          throwsA(const isInstanceOf<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = UC.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => UC.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });

    /*test('UC checkVRIndex good values', () {
      global.throwOnError = false;
      expect(UC.checkVRIndex(kUCIndex), kUCIndex);

      for (var tag in ucTags0) {
        global.throwOnError = false;
        expect(UC.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('UC checkVRIndex bad values', () {
      global.throwOnError = false;
      expect(
          UC.checkVRIndex(
            kAEIndex,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => UC.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UC.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => UC.checkVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UC checkVRIndex good values', () {
      global.throwOnError = false;
      expect(UC.checkVRCode(kUCCode), kUCCode);

      for (var tag in ucTags0) {
        global.throwOnError = false;
        expect(UC.checkVRCode(tag.vrCode), tag.vrCode);
      }
    });

    test('UC checkVRCode bad values', () {
      global.throwOnError = false;
      expect(
          UC.checkVRCode(
            kAECode,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => UC.checkVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UC.checkVRCode(tag.vrCode), isNull);

        global.throwOnError = true;
        expect(() => UC.checkVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });*/

    test('UC isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(UC.isValidVRIndex(kUCIndex), true);

      for (var tag in ucVM1Tags) {
        global.throwOnError = false;
        expect(UC.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('UC isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(UC.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => UC.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UC.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => UC.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UC isValidVRCode good values', () {
      global.throwOnError = false;
      expect(UC.isValidVRCode(kUCCode), true);

      for (var tag in ucVM1Tags) {
        expect(UC.isValidVRCode(tag.vrCode), true);
      }
    });

    test('UC isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(UC.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => UC.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UC.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
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

    test('UC isValidValueLength good values', () {
      for (var s in goodUCList) {
        for (var a in s) {
          expect(UC.isValidValueLength(a), true);
        }
      }

      expect(UC.isValidValueLength('a'), true);
    });

    test('UC isValidValueLength bad values', () {
      expect(UC.isValidValueLength(''), true);
    });

    test('UC isValidLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getUCList(1, 1);
        for (var tag in ucVM1Tags) {
          expect(UC.isValidLength(tag, vList), true);

          expect(UC.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(UC.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('UC isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getUCList(2, i + 1);
        for (var tag in ucVM1Tags) {
          global.throwOnError = false;
          expect(UC.isValidLength(tag, vList), false);

          expect(UC.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => UC.isValidLength(tag, vList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('UC isValidLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getUCList(1, i);
        for (var tag in ucVM1_nTags) {
          log.debug('tag: $tag');
          expect(UC.isValidLength(tag, vList0), true);
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
          global.throwOnError = false;
          expect(UC.isValidValue(a), false);

          global.throwOnError = true;
          expect(() => UC.isValidValue(a),
              throwsA(const isInstanceOf<StringError>()));
        }
      }
    });

    test('UC isValidValues good values', () {
      global.throwOnError = false;
      for (var s in goodUCList) {
        expect(UC.isValidValues(PTag.kStrainDescription, s), true);
      }
    });

    test('UC isValidValues bad values', () {
      for (var s in badUCList) {
        global.throwOnError = false;
        expect(UC.isValidValues(PTag.kStrainDescription, s), false);

        global.throwOnError = true;
        expect(() => UC.isValidValues(PTag.kStrainDescription, s),
            throwsA(const isInstanceOf<StringError>()));
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
      for (var s in goodUCList) {
        for (var a in s) {
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
      for (var s in goodUCList) {
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

      for (var s in goodUCList) {
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
          throwsA(const isInstanceOf<StringError>()));

      for (var s in badUCList) {
        global.throwOnError = false;
        expect(UC.isValidValues(PTag.kStrainDescription, s), false);

        global.throwOnError = true;
        expect(() => UC.isValidValues(PTag.kStrainDescription, s),
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('UC toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUCList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.fromUtf8List(vList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(vList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodUCList) {
        final toB1 = Bytes.fromUtf8List(s, kMaxShortVF);
        final bytes1 = Bytes.fromAscii(s.join('\\'));
        log.debug('toBytes:$toB1, bytes1: $bytes1');
        expect(toB1, equals(bytes1));
      }

      global.throwOnError = false;
      final toB2 = Bytes.fromUtf8List([''], kMaxShortVF);
      expect(toB2, equals(<String>[]));

      final toB3 = Bytes.fromUtf8List([], kMaxShortVF);
      expect(toB3, equals(<String>[]));

      final toB4 = Bytes.fromUtf8List(null, kMaxShortVF);
      expect(toB4, isNull);

      global.throwOnError = true;
      expect(() => Bytes.fromUtf8List(null, kMaxShortVF),
          throwsA(const isInstanceOf<GeneralError>()));
    });
  });
}