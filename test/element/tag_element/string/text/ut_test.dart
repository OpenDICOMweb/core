//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:convert';

import 'package:core/server.dart';
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = new RSG(seed: 1);

void main() {
  Server.initialize(name: 'string/ut_test', level: Level.info);
  global.throwOnError = false;

  const goodUTList = const <List<String>>[
    const <String>['\t '], //horizontal tab (HT)
    const <String>['\n'], //linefeed (LF)
    const <String>['\f '], // form feed (FF)
    const <String>['\r '], //carriage return (CR)
    const <String>['<BJ'],
    const <String>['UOC'],
    const <String>['D\B']
  ];
  const badUTList = const <List<String>>[
    const <String>['\b'], //	Backspace
  ];

  group('UTtag', () {
    test('UT hasValidValues good values', () {
      for (var s in goodUTList) {
        global.throwOnError = false;
        final e0 = new UTtag(PTag.kUniversalEntityID, s);
        expect(e0.hasValidValues, true);
      }

      // empty list
      final e0 = new UTtag(PTag.kLocalNamespaceEntityID, []);
      expect(e0.hasValidValues, true);
      expect(e0.values, equals(<String>[]));
    });

    test('UT hasValidValues bad values', () {
      for (var s in badUTList) {
        global.throwOnError = false;
        final e0 = new UTtag(PTag.kUniversalEntityID, s);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => new UTtag(PTag.kUniversalEntityID, s),
            throwsA(const isInstanceOf<StringError>()));
      }

      global.throwOnError = false;
      final e1 = new UTtag(PTag.kLocalNamespaceEntityID, null);
      expect(e1.hasValidValues, true);
      expect(e1.values, StringList.kEmptyList);

      global.throwOnError = true;
      expect(() => new UTtag(PTag.kLocalNamespaceEntityID, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('UT hasValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        final e0 = new UTtag(PTag.kUniversalEntityID, vList0);
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: ${e0.info}');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        log.debug('$i: vList0: $vList0');
        final e1 = new UTtag(PTag.kUniversalEntityID, vList0);
        expect(e1.hasValidValues, true);
      }
    });

    test('UT update random', () {
      final e0 = new UTtag(PTag.kLocalNamespaceEntityID, []);
      expect(e0.update(['d^u:96P, azV']).values, equals(['d^u:96P, azV']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        final e1 = new UTtag(PTag.kLocalNamespaceEntityID, vList0);
        final vList1 = rsg.getUTList(1, 1);
        expect(e1.update(vList1).values, equals(vList1));
      }
    });

    test('UT noValues random', () {
      final e0 = new UTtag(PTag.kLocalNamespaceEntityID, []);
      final UTtag utNoValues = e0.noValues;
      expect(utNoValues.values.isEmpty, true);
      log.debug('st0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        final e0 = new UTtag(PTag.kLocalNamespaceEntityID, vList0);
        log.debug('e0: $e0');
        expect(utNoValues.values.isEmpty, true);
        log.debug('e0: ${e0.noValues}');
      }
    });

    test('UT copy random', () {
      final e0 = new UTtag(PTag.kLocalNamespaceEntityID, []);
      final UTtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        final e2 = new UTtag(PTag.kLocalNamespaceEntityID, vList0);
        final UTtag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('UT hashCode and == good values random', () {
      List<String> vList0;

      log.debug('UT hashCode and == ');
      for (var i = 0; i < 10; i++) {
        vList0 = rsg.getUTList(1, 1);
        final e0 = new UTtag(PTag.kLocalNamespaceEntityID, vList0);
        final e1 = new UTtag(PTag.kLocalNamespaceEntityID, vList0);
        log
          ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
          ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('UT hashCode and == bad values random', () {
      log.debug('UT hashCode and == ');
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        final e0 = new UTtag(PTag.kLocalNamespaceEntityID, vList0);

        final vList1 = rsg.getUTList(1, 1);
        final e2 = new UTtag(PTag.kUniversalEntityID, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rsg.getUTList(1, 1);
        final e3 = new UTtag(PTag.kLocalNamespaceEntityID, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);
      }
    });

    test('UT valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        final e0 = new UTtag(PTag.kUniversalEntityID, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('UT isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        final e0 = new UTtag(PTag.kUniversalEntityID, vList0);
        expect(e0.tag.isValidLength(e0), true);
      }
    });

    test('UT isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        final e0 = new UTtag(PTag.kUniversalEntityID, vList0);

        expect(e0.checkValues(e0.values), true);
        expect(e0.hasValidValues, true);
      }
    });

    test('UT replace random', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        final e0 = new UTtag(PTag.kUniversalEntityID, vList0);
        final vList1 = rsg.getUTList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getUTList(1, 1);
      final e1 = new UTtag(PTag.kUniversalEntityID, vList1);
      expect(e1.replace([]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = new UTtag(PTag.kUniversalEntityID, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(<String>[]));
    });

    test('UT blank random', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getUTList(1, 1);
        final e0 = new UTtag(PTag.kUniversalEntityID, vList1);
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

    test('UT fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getUTList(1, 1);
        final bytes = Bytes.fromUtf8List(vList1);
        log.debug('bytes:$bytes');
        final e0 = UTtag.fromBytes(bytes, PTag.kUniversalEntityID);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);
      }
    });

    test('UT fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getUTList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          //final bytes0 = new Bytes();
          final e1 = UTtag.fromBytes(bytes0, PTag.kSelectorUTValue);
          log.debug('e1: ${e1.info}');
          expect(e1.hasValidValues, true);
        }
      }
    });

    test('UT fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getUTList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.fromAscii(listS);
          //final bytes0 = new Bytes();
          final e1 = UTtag.fromBytes(bytes0, PTag.kSelectorCSValue);
          expect(e1, isNull);

          global.throwOnError = true;
          expect(() => UTtag.fromBytes(bytes0, PTag.kSelectorCSValue),
              throwsA(const isInstanceOf<InvalidTagError>()));
        }
      }
    });

    test('UT fromValues good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        final e0 = UTtag.fromValues(PTag.kUniversalEntityID, vList0);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);

        final e1 = UTtag.fromValues(PTag.kUniversalEntityID, <String>[]);
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(<String>[]));
      }
    });

    test('UT fromValues bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(2, 2);
        global.throwOnError = false;
        final e0 = UTtag.fromValues(PTag.kUniversalEntityID, vList0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => UTtag.fromValues(PTag.kUniversalEntityID, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final e1 = UTtag.fromValues(PTag.kUniversalEntityID, <String>[null]);
      log.debug('mak1: $e1');
      expect(e1, isNull);

      global.throwOnError = true;
      expect(() => UTtag.fromValues(PTag.kUniversalEntityID, <String>[null]),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('UT checkLength good values', () {
      final vList0 = rsg.getUTList(1, 1);
      final e0 = new UTtag(PTag.kUniversalEntityID, vList0);
      for (var s in goodUTList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = new UTtag(PTag.kUniversalEntityID, vList0);
      expect(e1.checkLength([]), true);
    });

    test('UT checkLength bad values', () {
      final vList1 = ['a^1sd', '02@#'];
      global.throwOnError = false;
      final e2 = new UTtag(PTag.kUniversalEntityID, vList1);
      expect(e2, isNull);

      global.throwOnError = true;
      expect(() => new UTtag(PTag.kUniversalEntityID, vList1),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('UT checkValue good values', () {
      final vList0 = rsg.getUTList(1, 1);
      final e0 = new UTtag(PTag.kUniversalEntityID, vList0);
      for (var s in goodUTList) {
        for (var a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });

    test('UT checkValue bad values', () {
      final vList0 = rsg.getUTList(1, 1);
      final e0 = new UTtag(PTag.kUniversalEntityID, vList0);
      for (var s in badUTList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(e0.checkValue(a), false);

          global.throwOnError = true;
          expect(() => e0.checkValue(a),
              throwsA(const isInstanceOf<StringError>()));
        }
      }
    });

    /* test('UT decodeBinaryTextVF', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getUTList(1, 1);
        final bytes = Bytes.fromUtf8List(vList1);
        final dbTxt0 = bytes.getUtf8List();
        log.debug('dbTxt0: $dbTxt0');
        expect(dbTxt0, equals(vList1));

        final dbTxt1 = bytes.getUtf8List();
        log.debug('dbTxt1: $dbTxt1');
        expect(dbTxt1, equals(vList1));
      }
    });*/

    test('UT text from bytes', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getUTList(1, 1);
        final s0 = vList1[0];
        final bytes = Bytes.fromUtf8(s0);
        final s1 = bytes.getUtf8();
        log.debug('s1: $s1');
        expect(s1, equals(s0));

        final s2 = bytes.getUtf8();
        log.debug('s2: $s2');
        expect(s2, equals(s1));
      }
    });
  });

  group('UT', () {
    //VM.k1
    const utVM1Tags = const <PTag>[
      PTag.kLabelText,
      PTag.kStrainAdditionalInformation,
      PTag.kLocalNamespaceEntityID,
      PTag.kSpecimenDetailedDescription,
      PTag.kUniversalEntityID,
      PTag.kTextValue,
      PTag.kTrackSetDescription,
      PTag.kSelectorUTValue,
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

    final invalidVList = rsg.getUTList(UT.kMaxLength + 1, UT.kMaxLength + 1);

    test('UT isValidTag good values', () {
      global.throwOnError = false;
      expect(UT.isValidTag(PTag.kSelectorUTValue), true);

      for (var tag in utVM1Tags) {
        final validT0 = UT.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('UT isValidTag bad values', () {
      global.throwOnError = false;
      expect(UT.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => UT.isValidTag(PTag.kSelectorFDValue),
          throwsA(const isInstanceOf<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = UT.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => UT.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });
/*

    test('UT checkVRIndex good values', () {
      global.throwOnError = false;
      expect(UT.checkVRIndex(kUTIndex), kUTIndex);

      for (var tag in utTags0) {
        global.throwOnError = false;
        expect(UT.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('UT checkVRIndex bad values', () {
      global.throwOnError = false;
      expect(
          UT.checkVRIndex(
            kAEIndex,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => UT.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UT.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => UT.checkVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UT checkVRCode good values', () {
      global.throwOnError = false;
      expect(UT.checkVRCode(kUTCode), kUTCode);

      for (var tag in utTags0) {
        global.throwOnError = false;
        expect(UT.checkVRCode(tag.vrCode), tag.vrCode);
      }
    });

    test('UT checkVRCode bad values', () {
      global.throwOnError = false;
      expect(
          UT.checkVRCode(
            kAECode,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => UT.checkVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UT.checkVRCode(tag.vrCode), isNull);

        global.throwOnError = true;
        expect(() => UT.checkVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });
*/

    test('UT isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(UT.isValidVRIndex(kUTIndex), true);

      for (var tag in utVM1Tags) {
        global.throwOnError = false;
        expect(UT.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('UT isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(UT.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => UT.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UT.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => UT.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UT isValidVRCode good values', () {
      global.throwOnError = false;
      expect(UT.isValidVRCode(kUTCode), true);

      for (var tag in utVM1Tags) {
        expect(UT.isValidVRCode(tag.vrCode), true);
      }
    });

    test('UT isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(UT.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => UT.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UT.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => UT.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UT isValidVFLength good values', () {
      expect(UT.isValidVFLength(UT.kMaxVFLength), true);
      expect(UT.isValidVFLength(0), true);

      expect(UT.isValidVFLength(UT.kMaxVFLength, null, PTag.kSelectorUTValue),
          true);
    });

    test('UT isValidVFLength bad values', () {
      expect(UT.isValidVFLength(UT.kMaxVFLength + 1), false);
      expect(UT.isValidVFLength(-1), false);

      expect(UT.isValidVFLength(UT.kMaxVFLength, null, PTag.kSelectorLOValue),
          false);
    });

    test('UT isValidLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getUTList(1, 1);
        for (var tag in utVM1Tags) {
          expect(UT.isValidLength(tag, vList), true);

          expect(UT.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(UT.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('UT isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getUTList(2, i + 1);
        for (var tag in utVM1Tags) {
          global.throwOnError = false;
          expect(UT.isValidLength(tag, vList), false);

          expect(UT.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => UT.isValidLength(tag, vList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }

      global.throwOnError = false;
      final vList0 = rsg.getLOList(1, 1);
      expect(UT.isValidLength(null, vList0), false);

      expect(UT.isValidLength(PTag.kSelectorUTValue, null), isNull);

      global.throwOnError = true;
      expect(() => UT.isValidLength(null, vList0),
          throwsA(const isInstanceOf<InvalidTagError>()));

      expect(() => UT.isValidLength(PTag.kSelectorUTValue, null),
          throwsA(const isInstanceOf<GeneralError>()));
    });

    test('UT isValidValue good values', () {
      for (var s in goodUTList) {
        for (var a in s) {
          expect(UT.isValidValue(a), true);
        }
      }
    });

    test('UT isValidValue bad values', () {
      for (var s in badUTList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(UT.isValidValue(a), false);

          global.throwOnError = true;
          expect(() => UT.isValidValue(a),
              throwsA(const isInstanceOf<StringError>()));
        }
      }
    });

    test('UT isValidValues good values', () {
      global.throwOnError = false;
      for (var s in goodUTList) {
        expect(UT.isValidValues(PTag.kUniversalEntityID, s), true);
      }
    });

    test('UT isValidValues bad values', () {
      for (var s in badUTList) {
        global.throwOnError = false;
        expect(UT.isValidValues(PTag.kUniversalEntityID, s), false);

        global.throwOnError = true;
        expect(() => UT.isValidValues(PTag.kUniversalEntityID, s),
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    /* test('UT toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        global.throwOnError = false;
        final values = cvt.ascii.encode(vList0[0]);
        final tbd0 = Bytes.fromUtf8List(vList0);
        final tbd1 = Bytes.fromUtf8List(vList0);
        log.debug('tbd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodUTList) {
        for (var a in s) {
          final values = cvt.ascii.encode(a);
          final tbd2 = Bytes.fromUtf8List(s);
          final tbd3 = Bytes.fromUtf8List(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('UT fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.fromUtf8List(vList0);
        final fbd0 = bd0.getUtf8List();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (var s in goodUTList) {
        final bd0 = Bytes.fromUtf8List(s);
        final fbd0 = bd0.getUtf8List();
        expect(fbd0, equals(s));
      }
    });

    test('UT fromBytes', () {
      //  system.level = Level.info;;
      final vList1 = rsg.getUTList(1, 1);
      final bytes = Bytes.fromUtf8List(vList1);
      log.debug('UT.fromBytes(bytes):  $bytes');
      expect(bytes.getUtf8List(), equals(vList1));
    });

    test('UT toUint8List', () {
      final vList1 = rsg.getUTList(1, 1);
      log.debug('Bytes.fromUtf8List(vList1): ${Bytes.fromUtf8List(vList1)}');
      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = cvt.ascii.encode(vList1[0]);
      expect(Bytes.fromUtf8List(vList1), equals(values));
    });

    test('UT toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        global.throwOnError = false;
        final toB0 = Bytes.fromUtf8List(vList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(vList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodUTList) {
        final toB1 = Bytes.fromUtf8List(s, kMaxShortVF);
        final bytes1 = Bytes.fromAscii(s.join('\\'));
        log.debug('toBytes:$toB1, bytes1: $bytes1');
        expect(toB1, equals(bytes1));
      }

      final toB2 = Bytes.fromUtf8List([''], kMaxShortVF);
      expect(toB2, equals(<String>[]));

      final toB3 = Bytes.fromUtf8List([], kMaxShortVF);
      expect(toB3, equals(<String>[]));
      */ /*system.throwOnError = false;
      final toB2 = Bytes.fromUtf8List([null], kMaxShortVF);
      expect(toB2, isNull);

      system.throwOnError = true;
      expect(() => Bytes.fromUtf8List(null, kMaxShortVF),
          throwsA(const isInstanceOf<GeneralError>()));*/ /*
    });*/

    test('UT toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        global.throwOnError = false;
        final values = ascii.encode(vList0[0]);
        final tbd0 = Bytes.fromUtf8List(vList0);
        final tbd1 = Bytes.fromUtf8List(vList0);
        log.debug('tbd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodUTList) {
        for (var a in s) {
          final values = ascii.encode(a);
          final tbd2 = Bytes.fromUtf8List(s);
          final tbd3 = Bytes.fromUtf8List(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('UT fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        global.throwOnError = false;
        final s0 = vList0[0];
        final bd0 = Bytes.fromUtf8(s0);
        final s1 = bd0.getUtf8();
        log.debug('fbd0: $s1, vList0: $vList0');
        expect(s1, equals(s0));
      }
      for (var sList in goodUTList) {
        final s0 = sList[0];
        final bytes = Bytes.fromUtf8(s0);
        final s1 = bytes.getUtf8();
        expect(s1, equals(s0));
      }
    });

    test('UT fromBytes', () {
      final vList = rsg.getUTList(1, 1);
      final s = vList[0];
      final bytes = Bytes.fromUtf8(s);
      log.debug('UT.fromBytes(bytes):  $bytes');
      expect(bytes.getUtf8(), equals(s));
    });

    test('UT toUint8List', () {
      final vList1 = rsg.getUTList(1, 1);
      log.debug('Bytes.fromUtf8List(vList1): ${Bytes.fromUtf8List(vList1)}');
      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = ascii.encode(vList1[0]);
      expect(Bytes.fromUtf8List(vList1), equals(values));
    });

    test('UT toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        global.throwOnError = false;
        final toB0 = Bytes.fromUtf8List(vList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(vList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodUTList) {
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
      final toB2 = Bytes.fromUtf8List([null], kMaxShortVF);
      expect(toB2, isNull);

      global.throwOnError = true;
      expect(() => Bytes.fromUtf8List(null, kMaxShortVF),
          throwsA(const isInstanceOf<GeneralError>()));*/
    });
  });
}
