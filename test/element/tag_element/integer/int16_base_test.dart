//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/uInt32_base_test', level: Level.info);
  final rng = new RNG(1);
  global.throwOnError = false;

  test('Int16Base fromList', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.int16List(1, 1);
      expect(Int16.fromList(vList0), vList0);
    }
    const int16Min = const [kInt16Min];
    const int16Max = const [kInt16Max];
    expect(Int16.fromList(int16Max), int16Max);
    expect(Int16.fromList(int16Min), int16Min);
  });

  test('Int16Base toBytes', () {
    global.throwOnError = false;
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.int16List(1, 1);
      final vList1 = new Int16List.fromList(vList0);
      final bd = vList1.buffer.asUint8List();
      log
        ..debug('vList0 : $vList0')
        ..debug('SS.toBytes(vList0) ; ${Int16.toBytes(vList0)}');
      expect(Int16.toBytes(vList0), equals(bd));
    }

    const int16Max = const [kInt16Max];
    final int16List = new Int16List.fromList(int16Max);
    final uint8List = int16List.buffer.asUint8List();
    expect(Int16.toBytes(int16Max), uint8List);

    const int32Max = const [kInt32Max];
    expect(Int16.toBytes(int32Max), isNull);

    global.throwOnError = true;
    expect(() => Int16.toBytes(int32Max),
        throwsA(const TypeMatcher<InvalidValuesError>()));
  });

  test('Int16Base listToByteData good values', () {
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final vList0 = rng.int16List(1, 1);
      final bd0 = vList0.buffer.asByteData();
      final lBd0 = Int16.toByteData(vList0);
      log.debug('lBd0: ${lBd0.buffer.asUint8List()}, bd0: ${bd0.buffer
          .asUint8List()}');
      expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd0.buffer == bd0.buffer, true);

      final lBd1 = Int16.toByteData(vList0, check: false);
      log.debug('lBd3: ${lBd1.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd1.buffer == bd0.buffer, true);
    }

    const int16Max = const [kInt16Max];
    final int16List = new Int16List.fromList(int16Max);
    final bd1 = int16List.buffer.asByteData();
    final lBd2 = Int16.toByteData(int16List);
    log.debug('bd: ${bd1.buffer.asUint8List()}, '
        'lBd2: ${lBd2.buffer.asUint8List()}');
    expect(lBd2.buffer.asUint8List(), equals(bd1.buffer.asUint8List()));
    expect(lBd2.buffer == bd1.buffer, true);
  });

  test('Int16Base listToByteData bad values', () {
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final vList0 = rng.int16List(1, 1);
      final bd0 = vList0.buffer.asByteData();
      final lBd1 = Int16.toByteData(vList0, asView: false);
      log.debug('lBd1: ${lBd1.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd1.buffer == bd0.buffer, false);

      final int32list0 = rng.int32List(1, 1);
      assert(int32list0 is TypedData);
      //final int32List0 = new Int32List.fromList(int32list0);
      final bd1 = int32list0.buffer.asByteData();
      final lBd2 = Int16.toByteData(int32list0, check: false);
      log.debug('lBd0: ${lBd2.buffer.asUint8List()}, '
          'bd1: ${bd1.buffer.asUint8List()}');
      expect(lBd2.buffer.asUint8List(), isNot(bd0.buffer.asUint8List()));
      expect(lBd2.buffer == bd0.buffer, false);
      final lBd3 = Int16.toByteData(int32list0, asView: false);
      expect(lBd3, isNull);

      final lBd4 = Int16.toByteData(vList0, asView: false, check: false);
      log.debug('lBd4: ${lBd4.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd4.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd4.buffer == bd0.buffer, false);
    }

    const int32Max = const <int>[kInt32Max];
    expect(Int16.toByteData(int32Max), isNull);

    const int32Min = const [kInt32Min];
    expect(Int16.toByteData(int32Min), isNull);

    global.throwOnError = true;
    expect(() => Int16.toByteData(int32Max),
        throwsA(const TypeMatcher<InvalidValuesError>()));
  });

  test('Int16Base decodeJsonVF', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.int16List(0, i);
//        final vList1 = new Int16List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
//        final s = cvt.base64.encode(bd);
      final bytes = new Bytes.typedDataView(vList0);
      final s = bytes.getBase64();
      log.debug('SS.base64: "$s"');

      final ssList = Int16.fromBase64(s);
      log.debug('  SS.decode: $ssList');
      expect(ssList, equals(vList0));
//        expect(ssList, equals(vList1));
    }
  });

  test('Int16Base toBase64', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.int16List(0, i);
//        final vList1 = new Int16List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
      final bytes = new Bytes.typedDataView(vList0);
//        final s = cvt.base64.encode(bd);
      final s = bytes.getBase64();
      expect(Int16.toBase64(vList0), equals(s));
    }
  });

  test('Int16Base to/from Base64', () {
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.int16List(0, i);
//        final vList1 = new Int16List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
      final bytes = new Bytes.typedDataView(vList0);
      // Encode
//        final base64 = cvt.base64.encode(bd);
      final base64 = bytes.getBase64();
      log.debug('Int16Base.base64: "$base64"');
      final s = Int16.toBase64(vList0);
      log.debug('  Int16Base.json: "$s"');
      expect(s, equals(base64));

      // Decode
      final e0 = Int16.fromBase64(base64);
      log.debug('Int16Base.base64: $e0');
      final e1 = Int16.fromBase64(s);
      log.debug('  Int16Base.json: $e1');
      expect(e0, equals(vList0));
//        expect(e0, equals(vList1));
      expect(e0, equals(e1));
    }
  });

  test('Int16Base fromByteData', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.int16List(1, 1);
      final vList1 = new Int16List.fromList(vList0);
      final byteData = vList1.buffer.asByteData();
      log
        ..debug('vList0 : $vList0')
        ..debug('Int16Base.fromByteData(byteData): '
            '${Int16.fromByteData(byteData)}');
      expect(Int16.fromByteData(byteData), equals(vList0));
    }
  });

  test('Int16 fromValueField', () {
    for (var i = 1; i <= 10; i++) {
      final vList0 = rng.int16List(1, i);
      final int16ListV1 = new Int16List.fromList(vList0);
      final fvf0 = Int16.fromValueField(int16ListV1);
      log.debug('fromValueField0: $fvf0');
      expect(fvf0, equals(int16ListV1));
      expect(fvf0 is Int16List, true);
      expect(fvf0 is List<int>, true);
      expect(fvf0.isEmpty, false);
      expect(fvf0 is Bytes, false);
      expect(fvf0 is Uint8List, false);
    }

    final fvf1 = Int16.fromValueField(null);
    expect(fvf1, <Int16>[]);
    expect(fvf1 == kEmptyInt16List, true);
    expect(fvf1.isEmpty, true);
    expect(fvf1 is Int16List, true);

    final fvf2 = Int16.fromValueField(<int>[]);
    expect(fvf2, <Int16>[]);
    expect(fvf2.length == kEmptyIntList.length, true);
    expect(fvf2.isEmpty, true);

    final vList0 = rng.int16List(1, 1);
    final int16ListV1 = new Int16List.fromList(vList0);
    final byte0 = new Bytes.fromList(int16ListV1);
    final fvf3 = Int16.fromValueField(byte0);
    expect(fvf3, isNotNull);
    expect(fvf3 is Bytes, true);

    final uInt8list0 = int16ListV1.buffer.asUint8List();
    final fvf4 = Int16.fromValueField(uInt8list0);
    expect(fvf4, isNotNull);
    expect(fvf4 is Uint8List, true);

    global.throwOnError = false;
    final fvf5 = Int16.fromValueField(<String>['foo']);
    expect(fvf5, isNull);

    global.throwOnError = true;
    expect(() => Int16.fromValueField(<String>['foo']),
        throwsA(const TypeMatcher<InvalidValuesError>()));
  });

  test('Int16 toUint8List', () {
    global.throwOnError = false;
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.int16List(1, i);
      final unit8List0 = vList0.buffer.asUint8List();
      final toUnit8L0 = Int16.toUint8List(vList0);
      log.debug('toUnit8L0: $toUnit8L0');
      expect(toUnit8L0, equals(unit8List0));
    }

    final toUnit8L1 = Int16.toUint8List([]);
    expect(toUnit8L1, equals(kEmptyInt16List));

    final vList1 = rng.int16List(1, 1);
    final unit8List1 = vList1.buffer.asUint8List();
    final toUnit8L2 = Int16.toUint8List(vList1, asView: false);
    log.debug('toUnit8L2: $toUnit8L2');
    expect(toUnit8L2, equals(unit8List1));

    final vList2 = rng.int8List(1, 1);
    final unit8List2 = vList2.buffer.asUint8List();
    final toUnit8L3 = Int16.toUint8List(vList2);
    log.debug('toUnit8L3: $toUnit8L3');
    expect(toUnit8L3, isNot(unit8List2));

    final vList3 = rng.int32List(1, 1);
    final toUnit8L4 = Int16.toUint8List(vList3);
    log.debug('toUnit8L4: $toUnit8L4');
    expect(toUnit8L4, isNull);
  });

  test('Int16 fromUnit8List', () {
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.int16List(1, i);
      final unit8List0 = vList0.buffer.asUint8List();
      final fromUnit8L0 = Int16.fromUint8List(unit8List0);
      log.debug('fromUnit8L0: $fromUnit8L0');
      expect(fromUnit8L0, equals(vList0));
    }

    final vList1 = rng.int16List(0, 0);
    final unit8List1 = vList1.buffer.asUint8List();
    final fromUnit8L1 = Int16.fromUint8List(unit8List1);
    expect(fromUnit8L1, kEmptyInt16List);
  });

  test('Int16Base listFromBytes', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.int16List(1, 1);
      //  final vList1 = new Int16List.fromList(vList0);
      //  final bd = vList1.buffer.asUint8List();
      final bytes = new Bytes.typedDataView(vList0);
      final vList1 = bytes.asInt16List();
      log
        ..debug('vList0 : $vList0')
        ..debug('SS.fromBytes(bd) ; ${bytes.asInt16List()}');
      expect(vList1, equals(vList0));
    }
  });
}
