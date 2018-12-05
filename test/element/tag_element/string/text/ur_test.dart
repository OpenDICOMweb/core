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
  Server.initialize(name: 'string/ur_test', level: Level.info);
  global.throwOnError = false;

  const goodURList = <List<String>>[
    <String>['http:/TVc8mR/swk/jvNtF/Uy6'],
    <String>['iaWlVR'],
    <String>['http:/l_YB2r8/LQIo9'],
    <String>['_m3G9go/OkgpQ'],
    <String>['\b'], //	Backspace
    <String>['\t '], //horizontal tab (HT)
    <String>['\n'], //linefeed (LF)
    <String>['\f '], // form feed (FF)
    <String>['\r '], //carriage return (CR)
    <String>['\v'], //vertical tab
  ];

  const badURList = <List<String>>[
    <String>[' asdf sdf  ']
  ];

  group('URtag', () {
    test('UR hasValidValues good values', () {
      for (var s in goodURList) {
        global.throwOnError = false;
        final e0 = URtag(PTag.kRetrieveURI, s);
        expect(e0.hasValidValues, true);
      }

      final e0 = URtag(PTag.kPixelDataProviderURL, []);
      expect(e0.hasValidValues, true);
      expect(e0.values, equals(<String>[]));
    });

    test('UR hasValidValues bad values', () {
      for (var s in badURList) {
        global.throwOnError = false;
        final e0 = URtag(PTag.kRetrieveURI, s);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => URtag(PTag.kRetrieveURI, s),
            throwsA(const TypeMatcher<StringError>()));
      }

      global.throwOnError = false;
      final e1 = URtag(PTag.kPixelDataProviderURL, null);
      expect(e1.hasValidValues, true);
      expect(e1.values, StringList.kEmptyList);

      global.throwOnError = true;
      expect(() => URtag(PTag.kPixelDataProviderURL, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('UR hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final e0 = URtag(PTag.kRetrieveURI, vList0);
        log.debug('e0:${e0.info}');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: ${e0.info}');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        log.debug('$i: vList0: $vList0');
        final ui1 = URtag(PTag.kRetrieveURI, vList0);
        expect(ui1.hasValidValues, true);
      }
    });

    test('UR update random', () {
      global.throwOnError = false;
      final e0 = URtag(PTag.kSelectorURValue, []);
      expect(e0.update(['m3ZXGWA_']).values, equals(['m3ZXGWA_']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final ui1 = URtag(PTag.kPixelDataProviderURL, vList0);
        final vList1 = rsg.getURList(1, 1);
        expect(ui1.update(vList1).values, equals(vList1));
      }
    });

    test('UR noValues random', () {
      final e0 = URtag(PTag.kPixelDataProviderURL, []);
      final URtag urNoValues = e0.noValues;
      expect(urNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final e0 = URtag(PTag.kPixelDataProviderURL, vList0);
        log.debug('e0: $e0');
        expect(urNoValues.values.isEmpty, true);
        log.debug('e0: ${e0.noValues}');
      }
    });

    test('UR copy random', () {
      final e0 = URtag(PTag.kPixelDataProviderURL, []);
      final URtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final e2 = URtag(PTag.kPixelDataProviderURL, vList0);
        final URtag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('UR hashCode and == good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final e0 = URtag(PTag.kRetrieveURL, vList0);
        final e1 = URtag(PTag.kRetrieveURL, vList0);
        log
          ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
          ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('UR hashCode and == bad values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(2, 2 + i);
        final vList1 = rsg.getURList(2, 2 + i);
        final vList2 = rsg.getURList(2, 2 + i);

        global.throwOnError = false;
        final e0 = URtag(PTag.kRetrieveURL, vList0);
        log.debug('vList0:$vList0');
        expect(e0, isNull);
        final e1 = URtag(PTag.kPixelDataProviderURL, vList1);
        expect(e1, isNull);
        log.debug('vList1:$vList1');
        final e2 = URtag(PTag.kRetrieveURL, vList2);
        log.debug('vList2:$vList2');
        expect(e2, isNull);

        global.throwOnError = true;
        expect(() => URtag(PTag.kRetrieveURL, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
        expect(() => URtag(PTag.kPixelDataProviderURL, vList1),
            throwsA(const TypeMatcher<InvalidValuesError>()));
        expect(() => URtag(PTag.kRetrieveURL, vList2),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('UR valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final e0 = URtag(PTag.kRetrieveURL, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('UR isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final e0 = URtag(PTag.kRetrieveURL, vList0);
        expect(e0.tag.isValidLength(e0), true);
      }
    });

    test('UR checkValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final e0 = URtag(PTag.kRetrieveURL, vList0);
        expect(e0.checkValues(e0.values), true);
        expect(e0.hasValidValues, true);
      }
    });

    test('UR checkValues bad values random', () {
      final vList0 = rsg.getURList(1, 1);
      final e1 = URtag(PTag.kRetrieveURL, vList0);

      for (var s in badURList) {
        global.throwOnError = false;
        expect(e1.checkValues(s), false);

        global.throwOnError = true;
        expect(
            () => e1.checkValues(s), throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('UR replace random', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final e0 = URtag(PTag.kRetrieveURL, vList0);
        final vList1 = rsg.getURList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getURList(1, 1);
      final e1 = URtag(PTag.kRetrieveURL, vList1);
      expect(e1.replace([]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = URtag(PTag.kRetrieveURL, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(<String>[]));
    });

    test('UR fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getURList(1, 1);
        final bytes = Bytes.asciiFromList(vList1);
        log.debug('bytes:$bytes');
        final e0 = URtag.fromBytes(PTag.kRetrieveURL, bytes);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);
      }
    });

    test('UR fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getURList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.ascii(listS);
          final e1 = URtag.fromBytes(PTag.kSelectorURValue, bytes0);
          log.debug('e1: ${e1.info}');
          expect(e1.hasValidValues, true);
        }
      }
    });

    test('UR fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getURList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.ascii(listS);
          final e1 = URtag.fromBytes(PTag.kSelectorAEValue, bytes0);
          expect(e1, isNull);

          global.throwOnError = true;
          expect(() => URtag.fromBytes(PTag.kSelectorAEValue, bytes0),
              throwsA(const TypeMatcher<InvalidTagError>()));
        }
      }
    });

    test('UR fromValues good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final e0 = URtag.fromValues(PTag.kRetrieveURL, vList0);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);

        final e1 = URtag.fromValues(PTag.kRetrieveURL, <String>[]);
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(<String>[]));
      }
    });

    test('UR fromValues bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(2, 2);
        global.throwOnError = false;
        final e0 = URtag.fromValues(PTag.kRetrieveURL, vList0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => URtag.fromValues(PTag.kRetrieveURL, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final e1 = URtag.fromValues(PTag.kRetrieveURL, <String>[null]);
      log.debug('e1: $e1');
      expect(e1, isNull);

      global.throwOnError = true;
      expect(() => URtag.fromValues(PTag.kRetrieveURL, <String>[null]),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('UR checkLength good values', () {
      final vList0 = rsg.getURList(1, 1);
      final e0 = URtag(PTag.kRetrieveURL, vList0);
      for (var s in goodURList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = URtag(PTag.kRetrieveURL, vList0);
      expect(e1.checkLength([]), true);
    });

    test('UR checkLength bad values', () {
      final vList0 = rsg.getURList(1, 1);
      final vList1 = ['1.2.840.10008.5.1.4.34.5', '1.2.840.10008.3.1.2.32.7'];
      final e2 = URtag(PTag.kRetrieveURL, vList0);
      expect(e2.checkLength(vList1), false);
    });

    test('UR checkValue good values', () {
      final vList0 = rsg.getURList(1, 1);
      final e0 = URtag(PTag.kRetrieveURL, vList0);
      for (var s in goodURList) {
        for (var a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });

    test('UR checkValue bad values', () {
      final vList0 = rsg.getURList(1, 1);
      final e0 = URtag(PTag.kRetrieveURL, vList0);
      for (var s in badURList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(e0.checkValue(a), false);
        }
      }
    });

    test('UR decodeBinaryTextVF', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getURList(1, 1);
        final bytes = Bytes.asciiFromList(vList1);
        final dbTxt0 = bytes.stringListFromUtf8();
        log.debug('dbTxt0: $dbTxt0');
        expect(dbTxt0, equals(vList1));

        final dbTxt1 = bytes.stringListFromUtf8();
        log.debug('dbTxt1: $dbTxt1');
        expect(dbTxt1, equals(vList1));
      }
    });

    test('UR append', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final e0 = URtag(PTag.kSelectorURValue, vList0);
        const vList1 = 'foo';
        final append0 = e0.append(vList1);
        log.debug('append0: $append0');
        expect(append0, isNotNull);
      }
    });

    test('UR prepend', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final e0 = URtag(PTag.kSelectorURValue, vList0);
        const vList1 = 'foo';
        final prepend0 = e0.prepend(vList1);
        log.debug('prepend0: $prepend0');
        expect(prepend0, isNotNull);
      }
    });

    test('UR truncate', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1, 16);
        final e0 = URtag(PTag.kSelectorURValue, vList0);
        final truncate0 = e0.truncate(10);
        log.debug('truncate0: $truncate0');
        expect(truncate0, isNotNull);
      }
    });

    test('UR match', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, i);
        final e0 = URtag(PTag.kSelectorURValue, vList0);
        final match0 = e0.match(r'(\w+)');
        expect(match0, true);
      }
    });

    test('UR valueFromBytes', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getURList(1, i);
        final bytes = Bytes.utf8FromList(vList0);
        final e0 = URtag(PTag.kSelectorURValue, vList0);
        final vfb0 = e0.valuesFromBytes(bytes);
        expect(vfb0, equals(vList0));
      }
    });

    test('UR check', () {
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getURList(1, 1);
        final e0 = URtag(PTag.kRetrieveURI, vList);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList[0]));
      }

      for (var i = 1; i < 10; i++) {
        final vList1 = rsg.getURList(1, i);
        final e0 = URtag(PTag.kSelectorURValue, vList1);
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);
        expect(e0[0], equals(vList1[0]));
      }
    });

    test('UR valuesEqual good values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getURList(1, 1);
        final e0 = URtag(PTag.kSelectorURValue, vList);
        final e1 = URtag(PTag.kSelectorURValue, vList);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), true);
      }
    });

    test('UR valuesEqual bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getURList(1, i);
        final vList1 = rsg.getURList(1, 1);
        final e0 = URtag(PTag.kSelectorURValue, vList0);
        final e1 = URtag(PTag.kSelectorURValue, vList1);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), false);
      }
    });

    test('UR fromValueField', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        log.debug('vList0: $vList0');
        final fvf0 = Ascii.fromValueField(vList0, k8BitMaxLongVF);
        expect(fvf0, equals(vList0));
      }

      for (var i = 1; i < 10; i++) {
        global.throwOnError = false;
        final vList1 = rsg.getURList(1, i);
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

  group('UR', () {
    //VM.k1
    const urVM1Tags = <PTag>[
      PTag.kRetrieveURL,
      PTag.kPixelDataProviderURL,
      PTag.kRetrieveURI,
      PTag.kContactURI,
    ];

    //VM.k1_n
    const urVM1nTags = <PTag>[PTag.kSelectorURValue];

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

    final invalidVList = rsg.getURList(UR.kMaxLength + 1, UR.kMaxLength + 1);

    test('UR isValidTag good values', () {
      global.throwOnError = false;
      expect(UR.isValidTag(PTag.kSelectorURValue), true);

      for (var tag in urVM1Tags) {
        final validT0 = UR.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('UR isValidTag bad values', () {
      global.throwOnError = false;
      expect(UR.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => UR.isValidTag(PTag.kSelectorFDValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = UR.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => UR.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('UR isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(UR.isValidVRIndex(kURIndex), true);

      for (var tag in urVM1Tags) {
        global.throwOnError = false;
        expect(UR.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('UR isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(UR.isValidVRIndex(kSSIndex), false);

      global.throwOnError = true;
      expect(() => UR.isValidVRIndex(kSSIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UR.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => UR.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('UR isValidVRCode good values', () {
      global.throwOnError = false;
      expect(UR.isValidVRCode(kURCode), true);

      for (var tag in urVM1Tags) {
        expect(UR.isValidVRCode(tag.vrCode), true);
      }
    });

    test('UR isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(UR.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => UR.isValidVRCode(kAECode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UR.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => UR.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('UR isValidVFLength good values', () {
      expect(UR.isValidVFLength(UR.kMaxVFLength), true);
      expect(UR.isValidVFLength(0), true);

      expect(UR.isValidVFLength(UR.kMaxVFLength, null, PTag.kSelectorURValue),
          true);
    });

    test('UR isValidVFLength bad values', () {
      expect(UR.isValidVFLength(UR.kMaxVFLength + 1), false);
      expect(UR.isValidVFLength(-1), false);

      expect(UR.isValidVFLength(UR.kMaxVFLength, null, PTag.kSelectorDSValue),
          false);
    });

    test('UR isValidValueLength', () {
      for (var s in goodURList) {
        for (var a in s) {
          expect(UR.isValidValueLength(a), true);
        }
      }
    });

    test('UR isValidLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getURList(1, 1);
        for (var tag in urVM1Tags) {
          expect(UR.isValidLength(tag, vList), true);

          expect(UR.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(UR.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('UR isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        for (var tag in urVM1Tags) {
          final invalidValues = rsg.getURList(2, i + 1);
          global.throwOnError = false;

          expect(UR.isValidLength(tag, invalidVList), false);
          expect(UR.isValidLength(tag, invalidValues), false);

          global.throwOnError = true;
          expect(() => UR.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
          expect(() => UR.isValidLength(tag, invalidValues),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
      global.throwOnError = false;
      final vList0 = rsg.getURList(1, 1);
      expect(UR.isValidLength(null, vList0), false);

      expect(UR.isValidLength(PTag.kSelectorURValue, null), isNull);

      global.throwOnError = true;
      expect(() => UR.isValidLength(null, vList0),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => UR.isValidLength(PTag.kSelectorURValue, null),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('UR isValidLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getURList(1, i);
        final validMaxLengthList = invalidVList.sublist(0, UR.kMaxLength);
        for (var tag in urVM1nTags) {
          log.debug('tag: $tag');
          expect(UR.isValidLength(tag, vList0), true);
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
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('UR fromBytes', () {
      //  system.level = Level.info;;
      final vList1 = rsg.getURList(1, 1);
      final bytes = Bytes.asciiFromList(vList1);
      log.debug('bytes.stringListFromAsciiList(): '
          '${bytes.stringListFromAscii()}, bytes: $bytes');
      expect(bytes.stringListFromAscii(), equals(vList1));
    });

    test('UR Bytes.fromAsciiList', () {
      final vList1 = rsg.getURList(1, 1);
      log.debug('Bytes.fromAsciiList(vList1): ${Bytes.asciiFromList(vList1)}');
      final val = ascii.encode('s6V&:;s%?Q1g5v');
      expect(Bytes.asciiFromList(['s6V&:;s%?Q1g5v']), equals(val));

      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = ascii.encode(vList1[0]);
      expect(Bytes.asciiFromList(vList1), equals(values));
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
          throwsA(const TypeMatcher<StringError>()));
      for (var s in badURList) {
        global.throwOnError = false;
        expect(UR.isValidValues(PTag.kRetrieveURL, s), false);

        global.throwOnError = true;
        expect(() => UR.isValidValues(PTag.kRetrieveURL, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('UR toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        global.throwOnError = false;
        final values = ascii.encode(vList0[0]);
        final tbd0 = Bytes.asciiFromList(vList0);
        final tbd1 = Bytes.asciiFromList(vList0);
        log.debug('tbd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodURList) {
        for (var a in s) {
          final values = ascii.encode(a);
          final tbd2 = Bytes.asciiFromList(s);
          final tbd3 = Bytes.asciiFromList(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('UR fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.asciiFromList(vList0);
        final fbd0 = bd0.stringListFromAscii();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (var s in goodURList) {
        final bd0 = Bytes.asciiFromList(s);
        final fbd0 = bd0.stringListFromAscii();
        expect(fbd0, equals(s));
      }
    });

    test('UR toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.asciiFromList(vList0, kMaxShortVF);
        final bytes0 = Bytes.ascii(vList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodURList) {
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
    });

    test('UR isValidBytesArgs', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getURList(1, i);
        final vfBytes = Bytes.utf8FromList(vList0);

        if (vList0.length == 1) {
          for (var tag in urVM1Tags) {
            final e0 = UR.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else {
          for (var tag in urVM1Tags) {
            final e0 = UR.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        }
      }
      final vList0 = rsg.getURList(1, 1);
      final vfBytes = Bytes.utf8FromList(vList0);

      final e1 = UR.isValidBytesArgs(null, vfBytes);
      expect(e1, false);

      final e2 = UR.isValidBytesArgs(PTag.kDate, vfBytes);
      expect(e2, false);

      final e3 = UR.isValidBytesArgs(PTag.kSelectorURValue, null);
      expect(e3, false);

      global.throwOnError = true;
      expect(() => UR.isValidBytesArgs(null, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => UR.isValidBytesArgs(PTag.kDate, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));
    });
  });
}
