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

RSG rsg = new RSG(seed: 1);

void main() {
  Server.initialize(name: 'string/ur_test', level: Level.info);
  global.throwOnError = false;

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
        final e0 = new URtag(PTag.kRetrieveURI, s);
        expect(e0.hasValidValues, true);
      }

      final e0 = new URtag(PTag.kPixelDataProviderURL, []);
      expect(e0.hasValidValues, true);
      expect(e0.values, equals(<String>[]));
    });

    test('UR hasValidValues bad values', () {
      for (var s in badURList) {
        global.throwOnError = false;
        final e0 = new URtag(PTag.kRetrieveURI, s);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => new URtag(PTag.kRetrieveURI, s),
            throwsA(const TypeMatcher<StringError>()));
      }

      global.throwOnError = false;
      final e1 = new URtag(PTag.kPixelDataProviderURL, null);
      expect(e1.hasValidValues, true);
      expect(e1.values, StringList.kEmptyList);

      global.throwOnError = true;
      expect(() => new URtag(PTag.kPixelDataProviderURL, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('UR hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final e0 = new URtag(PTag.kRetrieveURI, vList0);
        log.debug('e0:${e0.info}');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: ${e0.info}');
        expect(e0[0], equals(vList0[0]));
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
      final e0 = new URtag(PTag.kSelectorURValue, []);
      expect(e0.update(['m3ZXGWA_']).values, equals(['m3ZXGWA_']));

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final ui1 = new URtag(PTag.kPixelDataProviderURL, vList0);
        final vList1 = rsg.getURList(1, 1);
        expect(ui1.update(vList1).values, equals(vList1));
      }
    });

    test('UR noValues random', () {
      final e0 = new URtag(PTag.kPixelDataProviderURL, []);
      final URtag urNoValues = e0.noValues;
      expect(urNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final e0 = new URtag(PTag.kPixelDataProviderURL, vList0);
        log.debug('e0: $e0');
        expect(urNoValues.values.isEmpty, true);
        log.debug('e0: ${e0.noValues}');
      }
    });

    test('UR copy random', () {
      final e0 = new URtag(PTag.kPixelDataProviderURL, []);
      final URtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final e2 = new URtag(PTag.kPixelDataProviderURL, vList0);
        final URtag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('UR hashCode and == good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final e0 = new URtag(PTag.kRetrieveURL, vList0);
        final e1 = new URtag(PTag.kRetrieveURL, vList0);
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
        final e0 = new URtag(PTag.kRetrieveURL, vList0);
        log.debug('vList0:$vList0');
        expect(e0, isNull);
        final e1 = new URtag(PTag.kPixelDataProviderURL, vList1);
        expect(e1, isNull);
        log.debug('vList1:$vList1');
        final e2 = new URtag(PTag.kRetrieveURL, vList2);
        log.debug('vList2:$vList2');
        expect(e2, isNull);

        global.throwOnError = true;
        expect(() => new URtag(PTag.kRetrieveURL, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
        expect(() => new URtag(PTag.kPixelDataProviderURL, vList1),
            throwsA(const TypeMatcher<InvalidValuesError>()));
        expect(() => new URtag(PTag.kRetrieveURL, vList2),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('UR valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final e0 = new URtag(PTag.kRetrieveURL, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('UR isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final e0 = new URtag(PTag.kRetrieveURL, vList0);
        expect(e0.tag.isValidLength(e0), true);
      }
    });

    test('UR isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final e0 = new URtag(PTag.kRetrieveURL, vList0);
        expect(e0.checkValues(e0.values), true);
        expect(e0.hasValidValues, true);
      }
    });

    test('UR replace random', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getURList(1, 1);
        final e0 = new URtag(PTag.kRetrieveURL, vList0);
        final vList1 = rsg.getURList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getURList(1, 1);
      final e1 = new URtag(PTag.kRetrieveURL, vList1);
      expect(e1.replace([]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = new URtag(PTag.kRetrieveURL, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(<String>[]));
    });

    test('UR fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getURList(1, 1);
        final bytes = Bytes.fromAsciiList(vList1);
        log.debug('bytes:$bytes');
        final e0 = URtag.fromBytes(bytes, PTag.kRetrieveURL);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);
      }
    });

    test('UR fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getURList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          final e1 = URtag.fromBytes(bytes0, PTag.kSelectorURValue);
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
          final bytes0 = Bytes.fromAscii(listS);
          final e1 = URtag.fromBytes(bytes0, PTag.kSelectorAEValue);
          expect(e1, isNull);

          global.throwOnError = true;
          expect(() => URtag.fromBytes(bytes0, PTag.kSelectorAEValue),
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
      final e0 = new URtag(PTag.kRetrieveURL, vList0);
      for (var s in goodURList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = new URtag(PTag.kRetrieveURL, vList0);
      expect(e1.checkLength([]), true);
    });

    test('UR checkLength bad values', () {
      final vList0 = rsg.getURList(1, 1);
      final vList1 = ['1.2.840.10008.5.1.4.34.5', '1.2.840.10008.3.1.2.32.7'];
      final e2 = new URtag(PTag.kRetrieveURL, vList0);
      expect(e2.checkLength(vList1), false);
    });

    test('UR checkValue good values', () {
      final vList0 = rsg.getURList(1, 1);
      final e0 = new URtag(PTag.kRetrieveURL, vList0);
      for (var s in goodURList) {
        for (var a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });

    test('UR checkValue bad values', () {
      final vList0 = rsg.getURList(1, 1);
      final e0 = new URtag(PTag.kRetrieveURL, vList0);
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
    const urVM1Tags = const <PTag>[
      PTag.kRetrieveURL,
      PTag.kPixelDataProviderURL,
      PTag.kRetrieveURI,
      PTag.kContactURI,
    ];

    //VM.k1_n
    const urVM1_nTags = const <PTag>[PTag.kSelectorURValue];

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
        for (var tag in urVM1_nTags) {
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
      final bytes = Bytes.fromAsciiList(vList1);
      log.debug('bytes.getAsciiList(): ${bytes.getAsciiList()}, bytes: $bytes');
      expect(bytes.getAsciiList(), equals(vList1));
    });

    test('UR Bytes.fromAsciiList', () {
      final vList1 = rsg.getURList(1, 1);
      log.debug('Bytes.fromAsciiList(vList1): ${Bytes.fromAsciiList(vList1)}');
      final val = ascii.encode('s6V&:;s%?Q1g5v');
      expect(Bytes.fromAsciiList(['s6V&:;s%?Q1g5v']), equals(val));

      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = ascii.encode(vList1[0]);
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
        final tbd0 = Bytes.fromAsciiList(vList0);
        final tbd1 = Bytes.fromAsciiList(vList0);
        log.debug('tbd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodURList) {
        for (var a in s) {
          final values = ascii.encode(a);
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
        final vList0 = rsg.getURList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.fromAsciiList(vList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(vList0.join('\\'));
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
