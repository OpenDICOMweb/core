//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/uInt16_base_test', level: Level.info);
  final rng = new RNG(1);
  global.throwOnError = false;

  test('Uint16Base fromList', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.uint16List(1, 1);
      expect(Uint16.fromList(vList0), vList0);
    }
    const uInt16Min = const [kUint16Min];
    const uInt16Max = const [kUint16Max];
    expect(Uint16.fromList(uInt16Min), uInt16Min);
    expect(Uint16.fromList(uInt16Max), uInt16Max);
  });

  test('Uint16Base fromBytes', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.uint16List(1, 1);
//        final vList1 = new Uint16List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
      final bytes = new Bytes.typedDataView(vList0);
      log
        ..debug('vList1 : $vList0')
        ..debug('Uint16.fromBytes(bd) ; ${Uint16.fromBytes(bytes)}');
      expect(Uint16.fromBytes(bytes), equals(vList0));
    }
  });

  test('Uint16Base toBytes', () {
    global.throwOnError = false;
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.uint16List(1, 1);
//        final vList1 = new Uint16List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
      final bytes = new Bytes.typedDataView(vList0);
      log
        ..debug('vList1 : $vList0')
        ..debug('Uint16.toBytes(vList1): '
            '${Uint16.toBytes(vList0)}');
      expect(Uint16.toBytes(vList0), equals(bytes));
    }

    const uint16Max = const [kUint16Max];
    final vList1 = new Uint16List.fromList(uint16Max);
    final uint16List = vList1.buffer.asUint8List();
    expect(Uint16.toBytes(uint16Max), uint16List);

    const uint32Max = const [kUint32Max];
    expect(Uint16.toBytes(uint32Max), isNull);

    global.throwOnError = true;
    expect(() => Uint16.toBytes(uint32Max),
        throwsA(const isInstanceOf<InvalidValuesError>()));
  });

  test('Uint16 toByteData good values', () {
    global.level = Level.info;
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final vList0 = rng.uint16List(1, 1);
      final bd0 = vList0.buffer.asByteData();
      final lBd0 = Uint16.toByteData(vList0);
      log.debug('lBd0: ${lBd0.buffer.asUint8List()}, bd0: ${bd0.buffer
          .asUint8List()}');
      expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd0.buffer == bd0.buffer, true);

      final lBd1 = Uint16.toByteData(vList0, check: false);
      log.debug('lBd3: ${lBd1.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd1.buffer == bd0.buffer, true);
    }

    const uint16Max = const [kUint16Max];
    final uint16List = new Uint16List.fromList(uint16Max);
    final bd1 = uint16List.buffer.asByteData();
    final lBd2 = Uint16.toByteData(uint16List);
    log.debug('bd: ${bd1.buffer.asUint8List()}, '
        'lBd2: ${lBd2.buffer.asUint8List()}');
    expect(lBd2.buffer.asUint8List(), equals(bd1.buffer.asUint8List()));
    expect(lBd2.buffer == bd1.buffer, true);
  });

  test('Uint16Base toByteData bad values', () {
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final vList0 = rng.uint16List(1, 1);
      final bd0 = vList0.buffer.asByteData();
      final lBd1 = Uint16.toByteData(vList0, asView: false);
      log.debug('lBd1: ${lBd1.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd1.buffer == bd0.buffer, false);

      final uint32List0 = rng.uint32List(1, 1);
      assert(uint32List0 is TypedData);
      final bd1 = uint32List0.buffer.asByteData();
      final lBd2 = Uint16.toByteData(uint32List0, check: false);
      log.debug('lBd0: ${lBd2.buffer.asUint8List()}, '
          'bd1: ${bd1.buffer.asUint8List()}');
      expect(lBd2.buffer.asUint8List(), isNot(bd0.buffer.asUint8List()));
      expect(lBd2.buffer == bd0.buffer, false);
      final lBd3 = Uint16.toByteData(uint32List0, asView: false);
      expect(lBd3, isNull);

      final lBd4 = Uint16.toByteData(vList0, asView: false, check: false);
      log.debug('lBd4: ${lBd4.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd4.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd4.buffer == bd0.buffer, false);
    }

    global.throwOnError = false;
    const uint32Max = const <int>[kUint32Max];
    expect(Uint16.toByteData(uint32Max), isNull);

    global.throwOnError = true;
    expect(() => Uint16.toByteData(uint32Max),
        throwsA(const isInstanceOf<InvalidValuesError>()));
  });

  test('Uint16Base fromBytes', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.uint16List(1, 1);
//        final vList1 = new Uint16List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
      final bytes = new Bytes.typedDataView(vList0);
      final base64 = bytes.getBase64();
      log.debug('Uint16.base64: "$base64"');

      final usList = Uint16.fromBytes(bytes);
      log.debug('  Uint16.decode: $usList');
      expect(usList, equals(vList0));
//        expect(usList, equals(vList1));
    }
  });

  test('Uint16Base toBase64', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.uint16List(1, 1);
//        final vList1 = new Uint16List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
//        final s = cvt.base64.encode(bd);
      final bytes = new Bytes.typedDataView(vList0);
      final base64 = bytes.getBase64();
      expect(Uint16.toBase64(vList0), equals(base64));
    }
  });

  test('Uint16Base encodeDecodeJsonVF', () {
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.uint16List(0, i);
//        final vList1 = new Uint16List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
      // Encode
//        final base64 = cvt.base64.encode(bd);
      final bytes0 = new Bytes.typedDataView(vList0);
      final base64 = bytes0.getBase64();
      log.debug('OW.base64: "$base64"');
      final s = Uint16.toBase64(vList0);
      log.debug('  OW.json: "$s"');
      expect(s, equals(base64));

      // Decode
      final e0 = Uint16.fromBase64(base64);
      log.debug('OW.base64: $e0');
      final e1 = Uint16.fromBase64(s);
      log.debug('  OW.json: $e1');
      expect(e0, equals(vList0));
//        expect(e0, equals(vList1));
      expect(e0, equals(e1));
    }
  });

  test('Uint16Base fromByteData', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.uint16List(1, 1);
      final vList1 = new Uint16List.fromList(vList0);
      final byteData = vList1.buffer.asByteData();
      log
        ..debug('vList1 : $vList1')
        ..debug('Uint16.listFromByteData(byteData):'
            ' ${Uint16.fromByteData(byteData)}');
      expect(Uint16.fromByteData(byteData), equals(vList1));
    }
  });

  test('Uint16 listToByteData good values', () {
    global.level = Level.info;
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final vList0 = rng.uint16List(1, 1);
      final bd0 = vList0.buffer.asByteData();
      final lBd0 = Uint16.toByteData(vList0);
      log.debug('lBd0: ${lBd0.buffer.asUint8List()}, bd0: ${bd0.buffer
          .asUint8List()}');
      expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd0.buffer == bd0.buffer, true);

      final lBd1 = Uint16.toByteData(vList0, check: false);
      log.debug('lBd3: ${lBd1.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd1.buffer == bd0.buffer, true);
    }

    const uint16Max = const [kUint16Max];
    final uint16List = new Uint16List.fromList(uint16Max);
    final bd1 = uint16List.buffer.asByteData();
    final lBd2 = Uint16.toByteData(uint16List);
    log.debug('bd: ${bd1.buffer.asUint8List()}, '
        'lBd2: ${lBd2.buffer.asUint8List()}');
    expect(lBd2.buffer.asUint8List(), equals(bd1.buffer.asUint8List()));
    expect(lBd2.buffer == bd1.buffer, true);
  });

  test('Uint16Base listToByteData bad values', () {
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final vList0 = rng.uint16List(1, 1);
      final bd0 = vList0.buffer.asByteData();
      final lBd1 = Uint16.toByteData(vList0, asView: false);
      log.debug('lBd1: ${lBd1.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd1.buffer == bd0.buffer, false);

      final uint32List0 = rng.uint32List(1, 1);
      assert(uint32List0 is TypedData);
      final bd1 = uint32List0.buffer.asByteData();
      final lBd2 = Uint16.toByteData(uint32List0, check: false);
      log.debug('lBd0: ${lBd2.buffer.asUint8List()}, '
          'bd1: ${bd1.buffer.asUint8List()}');
      expect(lBd2.buffer.asUint8List(), isNot(bd0.buffer.asUint8List()));
      expect(lBd2.buffer == bd0.buffer, false);
      final lBd3 = Uint16.toByteData(uint32List0, asView: false);
      expect(lBd3, isNull);

      final lBd4 = Uint16.toByteData(vList0, asView: false, check: false);
      log.debug('lBd4: ${lBd4.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd4.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd4.buffer == bd0.buffer, false);
    }

    global.throwOnError = false;
    const uint32Max = const <int>[kUint32Max];
    expect(Uint16.toByteData(uint32Max), isNull);

    global.throwOnError = true;
    expect(() => Uint16.toByteData(uint32Max),
        throwsA(const isInstanceOf<InvalidValuesError>()));
  });

  test('Uint16Base toUint8List', () {
    global.throwOnError = false;
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.uint16List(1, i);
      final unit8List0 = vList0.buffer.asUint8List();
      final toUnit8L0 = Uint16.toUint8List(vList0);
      log.debug('toUnit8L0: $toUnit8L0');
      expect(toUnit8L0, equals(unit8List0));
    }

    final toUnit8L1 = Uint16.toUint8List([]);
    expect(toUnit8L1, equals(kEmptyInt16List));

    final vList1 = rng.uint16List(1, 1);
    final unit8List1 = vList1.buffer.asUint8List();
    final toUnit8L2 = Uint16.toUint8List(vList1, asView: false);
    log.debug('toUnit8L2: $toUnit8L2');
    expect(toUnit8L2, equals(unit8List1));

    final vList2 = rng.uint32List(1, 1);
    final toUnit8L3 = Uint16.toUint8List(vList2);
    log.debug('toUnit8L3: $toUnit8L3');
    expect(toUnit8L3, isNull);
  });

  test('Uint16Base fromUnit8List', () {
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.uint16List(1, i);
      final uint8List0 = vList0.buffer.asUint8List();
      final fromUnit8L0 = Uint16.fromUint8List(uint8List0);
      log.debug('fromUnit8L0: $fromUnit8L0');
      expect(fromUnit8L0, equals(vList0));
    }

    final vList1 = rng.uint16List(0, 0);
    final uint8List1 = vList1.buffer.asUint8List();
    final fromUnit8L1 = Uint16.fromUint8List(uint8List1);
    expect(fromUnit8L1, kEmptyInt16List);
  });
}
