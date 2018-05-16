//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:convert' as cvt;
import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/uInt8_base_test', level: Level.info);
  final rng = new RNG(1);
  global.throwOnError = false;

  test('Uint8Base toUint8List', () {
    for (var i = 0; i < 10; i++) {
      final uInt8List0 = rng.uint8List(1, 1);
      expect(Uint8.fromList(uInt8List0), uInt8List0);
    }
    const uInt8Min = const [kUint8Min];
    const uInt8Max = const [kUint8Max];
    expect(Uint8.fromList(uInt8Min), uInt8Min);
    expect(Uint8.fromList(uInt8Max), uInt8Max);
  });

  test('Uint8Base fromBytes', () {
    for (var i = 0; i < 10; i++) {
      final uInt8List0 = rng.uint8List(1, 1);
      final bytes = new Bytes.typedDataView(uInt8List0);
//        final bd = bytes.buffer.asUint8List();
      log
        ..debug('uInt8ListV1 : $bytes')
        ..debug('Uint8Base.fromBytes(bd) ; ${Uint8.fromBytes(bytes)}');
      expect(Uint8.fromBytes(bytes), equals(bytes));
    }
  });

  test('Uint8Base ListToBytes', () {
    global.throwOnError = false;
    for (var i = 0; i < 10; i++) {
      final uInt8List0 = rng.uint8List(1, 1);
      final uInt8ListV1 = new Bytes.typedDataView(uInt8List0);
      final bd = uInt8ListV1.buffer.asUint8List();
      log
        ..debug('uInt8ListV1 : $uInt8ListV1')
        ..debug('Uint8Base.ListToBytesBytes(int32ListV1) ; '
            '${Uint8.toBytes(uInt8ListV1)}');
      expect(Uint8.toBytes(uInt8ListV1), equals(bd));
    }

    const uInt8Max = const [kUint8Max];
    final uInt8ListV1 = new Uint8List.fromList(uInt8Max);
    final uint8List = uInt8ListV1.buffer.asUint8List();
    expect(Uint8.toBytes(uInt8Max), uint8List);

    const uInt16Max = const [kUint16Max];
    final uInt16List2 = Uint16.fromList(uInt16Max);
    expect(Uint8.toUint8List(uInt16List2), isNull);

    global.throwOnError = true;
    expect(() => Uint8.toBytes(uInt16Max),
        throwsA(const isInstanceOf<InvalidValuesError>()));
  });

  test('Uint8Base ListToByteData good values', () {
    global.level = Level.info;
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final uInt8List0 = rng.uint8List(1, 1);
      final bd0 = uInt8List0.buffer.asByteData();
      final lBd0 = Uint8.toByteData(uInt8List0);
      log.debug('lBd0: ${lBd0.buffer.asUint8List()}, bd0: ${bd0.buffer
            .asUint8List()}');
      expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd0.buffer == bd0.buffer, true);

      final lBd1 = Uint8.toByteData(uInt8List0);
      log.debug('lBd3: ${lBd1.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd1.buffer == bd0.buffer, true);
    }

    const uint8Max = const [kUint8Max];
    final uint8List = new Uint8List.fromList(uint8Max);
    final bd1 = uint8List.buffer.asByteData();
    final lBd2 = Uint8.toByteData(uint8List);
    log.debug('bd: ${bd1.buffer.asUint8List()}, '
        'lBd2: ${lBd2.buffer.asUint8List()}');
    expect(lBd2.buffer.asUint8List(), equals(bd1.buffer.asUint8List()));
    expect(lBd2.buffer == bd1.buffer, true);
  });

  test('Uint8Base toByteData bad values', () {
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final uInt8List0 = rng.uint8List(1, 1);
      final bd0 = uInt8List0.buffer.asByteData();
      final lBd1 = Uint8.toByteData(uInt8List0);
      log.debug('lBd1: ${lBd1.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd1.buffer == bd0.buffer, true);

      final uint16List0 = rng.uint16List(1, 1);
      assert(uint16List0 is TypedData);
      final bd1 = uint16List0.buffer.asByteData();
      final lBd2 = Uint16.toByteData(uint16List0);
      log.debug('lBd0: ${lBd2.buffer.asUint8List()}, '
          'bd1: ${bd1.buffer.asUint8List()}');
      expect(lBd2.buffer.asUint8List(), isNot(bd0.buffer.asUint8List()));
      expect(lBd2.buffer == bd0.buffer, false);

      final lBd3 = Uint16.toByteData(uint16List0, asView: false);
      expect(lBd3.buffer == bd1.buffer, false);
      expect(lBd3.buffer.asUint8List() != bd1.buffer.asUint8List(), true);

      final lBd4 = Uint8.toByteData(uInt8List0);
      log.debug('lBd4: ${lBd4.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd4.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd4.buffer == bd0.buffer, true);
    }

    global.throwOnError = false;
    const uInt16Max = const <int>[kUint16Max];

    expect(Uint8.toByteData(uInt16Max), isNull);

    global.throwOnError = false;
    const uInt32Max = const <int>[kUint32Max];
    expect(Uint8.toByteData(uInt32Max), isNull);

    global.throwOnError = true;
    expect(() => Uint8.toByteData(uInt16Max),
        throwsA(const isInstanceOf<InvalidValuesError>()));
  });

  test('Uint8Base fromBase64', () {
    for (var i = 0; i < 10; i++) {
      final uInt8List0 = rng.uint8List(0, i);
      final uInt8ListV1 = new Bytes.typedDataView(uInt8List0);
      final bd = uInt8ListV1.buffer.asUint8List();
      final base64 = cvt.base64.encode(bd);
      log.debug('OB.base64: "$base64"');

      final obList = Uint8.fromBase64(base64);
      log.debug('  OB.decode: $obList');
      expect(obList, equals(uInt8List0));
      expect(obList, equals(uInt8ListV1));
    }
  });

  test('Uint8Base ListToBase64', () {
    for (var i = 0; i < 10; i++) {
      final uInt8List0 = rng.uint8List(0, i);
      final uInt8ListV1 = new Bytes.typedDataView(uInt8List0);
      final bd = uInt8ListV1.buffer.asUint8List();
      final s = cvt.base64.encode(bd);
      expect(Uint8.toBase64(uInt8List0), equals(s));
    }
  });

  test('Uint8Base encodeDecodeJsonVF', () {
    global.level = Level.info;
    for (var i = 1; i < 10; i++) {
      final uInt8List0 = rng.uint8List(0, i);
      final uInt8ListV1 = new Bytes.typedDataView(uInt8List0);
      final bd = uInt8ListV1.buffer.asUint8List();

      // Encode
      final base64 = cvt.base64.encode(bd);
      log.debug('OB.base64: "$base64"');
      final s = Uint8.toBase64(uInt8List0);
      log.debug('  OB.json: "$s"');
      expect(s, equals(base64));

      // Decode
      final ob0 = Uint8.fromBase64(base64);
      log.debug('OB.base64: $ob0');
      final ob1 = Uint8.fromBase64(s);
      log.debug('  OB.json: $ob1');
      expect(ob0, equals(uInt8List0));
      expect(ob0, equals(uInt8ListV1));
      expect(ob0, equals(ob1));
    }
  });

  test('Uint8Base fromBytes', () {
    for (var i = 0; i < 10; i++) {
      final uInt8List0 = rng.uint8List(1, 1);
      final bytes = new Bytes.typedDataView(uInt8List0);
//        final bd = uInt8ListV1.buffer.asUint8List();
      log
        ..debug('uInt8ListV1 : $bytes')
        ..debug('Uint8Base.fromBytes(bd) ; ${Uint8.fromBytes(bytes)}');
      expect(Uint8.fromBytes(bytes), equals(uInt8List0));
    }
  });

  test('Uint8Base fromByteData', () {
    for (var i = 0; i < 10; i++) {
      final uInt8List0 = rng.uint8List(1, 1);
      final uInt8ListV1 = new Bytes.typedDataView(uInt8List0);
      final byteData = uInt8ListV1.buffer.asByteData();
      log
        ..debug('uInt8List0 : $uInt8List0')
        ..debug('Uint8Base.fromByteData(byteData): '
            '${Uint8.fromByteData(byteData)}');
      expect(Uint8.fromByteData(byteData), equals(uInt8List0));
    }
  });
}
