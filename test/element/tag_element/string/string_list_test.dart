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
import 'package:test_tools/tools.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'string_list_test.dart', level: Level.info);
  final rsg = new RSG();

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

  test('textListToBytes', () {
    for (var i = 0; i < 10; i++) {
      final vList = rsg.getAEList(1, 1);
      final bytes = Bytes.fromAsciiList(vList);
      final bytes0 = textListToBytes(vList);
      log.debug('bytes0: $bytes0');
      expect(bytes0 == bytes, true);
    }

    global.throwOnError = false;
    final bytes1 = textListToBytes([]);
    expect(bytes1, kEmptyBytes);

    final bytes2 = textListToBytes(['']);
    expect(bytes2, kEmptyBytes);

    final bytes3 = textListToBytes([null]);
    expect(bytes3, isNull);

    final bytes4 = textListToBytes(['abc', 'foo']);
    expect(bytes4, isNull);

    global.throwOnError = true;
    expect(() => textListToBytes([null]),
        throwsA(const isInstanceOf<GeneralError>()));

    expect(() => textListToBytes(['abc', 'foo']),
        throwsA(const isInstanceOf<InvalidValuesError>()));
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
    expect(bytes1, kEmptyBytes);

    final bytes2 = textListToUint8List([''], kMaxShortVF);
    expect(bytes2, kEmptyBytes);

    final bytes3 = textListToUint8List([null], kMaxShortVF);
    expect(bytes3, isNull);

    final bytes4 = textListToUint8List(['abc', 'foo'], kMaxShortVF);
    expect(bytes4, isNull);

    global.throwOnError = true;
    expect(() => textListToUint8List([null], kMaxShortVF),
        throwsA(const isInstanceOf<GeneralError>()));

    expect(() => textListToUint8List(['abc', 'foo'], kMaxShortVF),
        throwsA(const isInstanceOf<InvalidValuesError>()));
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

  group('StringList', () {
    test('StringList.from', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getLTList(1, i);
        final sfrom0 = new StringList.from(vList0);
        log.debug('sfrom0: $sfrom0');
        expect(sfrom0, equals(vList0));
      }

      final sfrom1 = new StringList.from();
      expect(sfrom1, kEmptyStringList);

      final sfrom2 = new StringList.from([]);
      expect(sfrom2, kEmptyStringList);
    });

    test('hashCode and ==', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getLTList(1, i);
        final sfrom0 = new StringList.from(vList0);
        final sfrom1 = new StringList.from(vList0);
        final sfrom2 = new StringList.from();
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
        final bytes0 = Bytes.fromAsciiList(vList0);
        final sfrom0 = new StringList.from(vList0);

        expect(sfrom0.length, equals(vList0.length));
        expect(sfrom0.lengthInBytes, equals(bytes0.length));
      }
    });
  });
}