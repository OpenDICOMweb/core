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
import 'package:test_tools/tools.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'string_list_test.dart', level: Level.info);
  final rsg = RSG();

  test('stringListToString', () {
    for (var i = 1; i < 10; i++) {
      final vList0 = rsg.getAEList(1, i);
      final slts0 = stringListToString(vList0);
      log.debug('slts0: $slts0');
      expect(slts0, equals(vList0.join('\\')));
    }
    for (var i = 0; i < 10; i++) {
      final vList01 = rsg.getAEList(1, 1);
      final slts1 = stringListToString(vList01);
      log.debug('slts1: $slts1');
      expect(slts1, equals(vList01[0]));
    }

    final slts2 = stringListToString(null);
    expect(slts2, isNull);

    final slts3 = stringListToString([]);
    expect(slts3, equals(''));
  });

  test('stringListToUint8List', () {
    for (var i = 1; i < 10; i++) {
      final vList0 = rsg.getSTList(1, i);
      final uint8List0 = stringToUint8List(vList0.join('\\'));
      final sltu0 = stringListToUint8List(vList0, maxLength: kMaxShortVF);
      log.debug('sltu0: $sltu0');
      expect(sltu0, equals(uint8List0));
    }

    global.throwOnError = false;
    final sltu1 = stringListToUint8List(null);
    expect(sltu1, isNull);
  });

  test('stringListToByteData', () {
    for (var i = 1; i < 10; i++) {
      final vList0 = rsg.getSTList(1, i);
      final uInt8List0 = stringToUint8List(vList0.join('\\'));
      final byteData0 = uInt8List0.buffer.asByteData();
      final sltb0 = stringListToByteData(vList0, maxLength: kMaxShortVF);
      log.debug('sltb0: $sltb0');
      expect(sltb0.toString(), equals(byteData0.toString()));
    }

    final sltb1 = stringListToByteData(null);
    expect(sltb1, isNull);
  });

  test('BytesDicom.fromTextList', () {
    for (var i = 0; i < 10; i++) {
      final vList = rsg.getAEList(1, 1);
      final bytes = BytesDicom.fromAsciiList(vList);
      final bytes0 = Bytes.fromAscii(vList.join('\\'));
      log.debug('bytes0: $bytes0');
      expect(bytes0 == bytes, true);
    }

    global.throwOnError = false;
    final bytes1 = BytesDicom.fromTextList([]);
    expect(bytes1, kEmptyBytes);

    final bytes2 = BytesDicom.fromTextList(['']);
    expect(bytes2, kEmptyBytes);

    final bytes3 = BytesDicom.fromTextList([null]);
    expect(bytes3, isNull);

    final bytes4 = BytesDicom.fromTextList(['abc', 'foo']);
    expect(bytes4, isNull);

    global.throwOnError = true;
    expect(() => BytesDicom.fromTextList([null]),
        throwsA(const TypeMatcher<GeneralError>()));

    expect(() => BytesDicom.fromTextList(['abc', 'foo']),
        throwsA(const TypeMatcher<InvalidValuesError>()));
  });

  test('textListToUint8List', () {
    for (var i = 0; i < 10; i++) {
      final vList = rsg.getAEList(1, 1);
      final uInt8List = cvt.ascii.encode(vList.join('\\'));
      final uInt8List0 = textListToUint8List(vList, kMaxShortVF);
      log.debug('uInt8List0: $uInt8List0, uInt8List: $uInt8List');
      expect(uInt8List0, equals(uInt8List));
    }

    global.throwOnError = false;
    final bytes1 = textListToUint8List([], kMaxShortVF);
    expect(bytes1, kEmptyUint8List);

    final bytes2 = textListToUint8List([''], kMaxShortVF);
    expect(bytes2, kEmptyUint8List);

    final bytes3 = textListToUint8List([null], kMaxShortVF);
    expect(bytes3, isNull);

    final bytes4 = textListToUint8List(['abc', 'foo'], kMaxShortVF);
    expect(bytes4, isNull);

    global.throwOnError = true;
    expect(() => textListToUint8List([null], kMaxShortVF),
        throwsA(const TypeMatcher<GeneralError>()));

    expect(() => textListToUint8List(['abc', 'foo'], kMaxShortVF),
        throwsA(const TypeMatcher<InvalidValuesError>()));
  });

  test('textListFromTypedData', () {
    for (var i = 0; i < 10; i++) {
      final vList = rsg.getAEList(1, 1);
      final uInt8List = cvt.ascii.encode(vList.join('\\'));
      final uInt8List0 =
          textListFromTypedData(uInt8List, maxLength: kMaxShortVF);
      log.debug('uInt8List0: $uInt8List0, uInt8List: $uInt8List');
      expect(uInt8List0, equals(vList));
    }

    final uInt8List1 = textListFromTypedData(null, maxLength: kMaxShortVF);
    expect(uInt8List1, isNull);
  });

  test('typedDataToString', () {
    for (var i = 0; i < 10; i++) {
      final vList = rsg.getAEList(1, 1);
      final uInt8List = cvt.ascii.encode(vList.join('\\'));
      final string0 = typedDataToString(uInt8List);
      log.debug('string0: $string0');
      expect(string0, equals(vList[0]));
    }
  });

  test('stringListFromTypedData', () {
    for (var i = 0; i < 10; i++) {
      final vList = rsg.getAEList(1, 1);
      final td = cvt.ascii.encode(vList.join('\\'));
      final slft0 = stringListFromTypedData(td, kMaxShortVF);
      log.debug('slft0: $slft0');
      expect(slft0, equals(vList));
    }
    final vList = <String>[];
    final td = cvt.ascii.encode(vList.join('\\'));
    final slft1 = stringListFromTypedData(td, kMaxShortVF);
    expect(slft1, kEmptyStringList);
  });

  test('stringToByteData', () {
    for (var i = 1; i < 10; i++) {
      final vList = rsg.getAEList(1, i);
      final uint8List0 = cvt.ascii.encode(vList.join('\\'));
      final sBytesData0 = stringToByteData(vList.join('\\'));

      expect(uint8List0, equals(sBytesData0.buffer.asUint8List()));
      expect(
          uint8List0.lengthInBytes == sBytesData0.buffer.lengthInBytes, true);
      expect(
          uint8List0.length == sBytesData0.buffer.asUint8List().length, true);
      expect(sBytesData0.elementSizeInBytes == uint8List0.elementSizeInBytes,
          true);
      expect(sBytesData0.offsetInBytes == uint8List0.offsetInBytes, true);
    }
    final sBytesData1 = stringToByteData(null);
    expect(sBytesData1, isNull);

    const vList = '';
    final sBytesData2 = stringToByteData(vList);
    expect(sBytesData2.buffer.asUint8List().isEmpty == vList.isEmpty, true);
  });

  group('StringList', () {
    const replaceFirst = <List<String>>[
      <String>['urz6L3pw', r'[a-zA-Z]+', '***', '***6L3pw'],
      <String>['15v1a', r'[a-zA-Z]+', '***', '15***1a'],
      <String>['ZP-1_', r'[a-zA-Z]+', '***', '***-1_'],
      <String>['L+uc};j&)ghGLU0', r'[a-zA-Z]+', '***', '*'],
      <String>['}.3x>1Xcor](/v', r'[a-zA-Z]+', '***', '}'],
      <String>['+vqoC3OYm5', r'[a-zA-Z]+', '***', '+***3OYm5'],
      <String>['12345', r'[a-zA-Z]+', '***', '12345']
    ];

    const replaceAll = <List<String>>[
      <String>['urz6L3pw', r'[a-zA-Z]+', '***', '***6***3***'],
      <String>['15v1a', r'[a-zA-Z]+', '***', '15***1***'],
      <String>['ZP-1_', r'[a-zA-Z]+', '***', '***-1_'],
      <String>['L+uc};j&)ghGLU0', r'[a-zA-Z]+', '***', '*'],
      <String>['}.3x>1Xcor](/v', r'[a-zA-Z]+', '***', '}'],
      <String>['+vqoC3OYm5', r'[a-zA-Z]+', '***', '+***3***5'],
      <String>['12345', r'[a-zA-Z]+', '***', '12345']
    ];

    test('StringList.from', () {
      global.throwOnError = false;

      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getLTList(1, i);
        final sfrom0 = StringList.from(vList0);
        log.debug('sfrom0: $sfrom0');
        expect(sfrom0, equals(vList0));
      }

      final sfrom1 = StringList.from();
      expect(sfrom1, kEmptyStringList);

      final sfrom2 = StringList.from([]);
      expect(sfrom2, kEmptyStringList);
    });

    test('hashCode and ==', () {
      global.throwOnError = false;

      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getLTList(1, i);
        final sfrom0 = StringList.from(vList0);
        final sfrom1 = StringList.from(vList0);
        final sfrom2 = StringList.from();
        log.debug('sfrom0: $sfrom0');
        expect(sfrom0, equals(vList0));

        expect(sfrom0.hashCode, equals(sfrom1.hashCode));
        expect(sfrom0 == sfrom1, true);

        expect(sfrom0.hashCode, isNot(sfrom2.hashCode));
        expect(sfrom0 == sfrom2, false);
      }
    });

    test('others', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getLTList(1, i);
        final bytes0 = BytesDicom.fromAsciiList(vList0);
        final sfrom0 = StringList.from(vList0);

        expect(sfrom0.length, equals(vList0.length));
        expect(sfrom0.lengthInBytes, equals(bytes0.length));
      }
    });

    test('replaceFirst', () {
      for (final s in replaceFirst) {
        final s0 = StringList.from([s[0]]);
        final regexFrom = RegExp(s[1]);
        final rf0 = s0.replaceFirst(regexFrom, s[2], 10);
        expect(rf0, equals([s[3]]));
      }
    });

    test('replaceAll', () {
      for (final s in replaceAll) {
        final s0 = StringList.from([s[0]]);
        final regexFrom = RegExp(s[1]);
        final rf0 = s0.replaceAll(regexFrom, s[2], 15);
        expect(rf0, equals([s[3]]));
      }
    });
  });
}
