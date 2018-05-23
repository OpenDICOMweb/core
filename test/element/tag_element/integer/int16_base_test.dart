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
  Server.initialize(name: 'element/uInt32_base_test', level: Level.info);
  final rng = new RNG(1);
  global.throwOnError = false;

  test('Int16Base fromList', () {
    for (var i = 0; i < 10; i++) {
      final int16list0 = rng.int16List(1, 1);
      expect(Int16.fromList(int16list0), int16list0);
    }
    const int16Min = const [kInt16Min];
    const int16Max = const [kInt16Max];
    expect(Int16.fromList(int16Max), int16Max);
    expect(Int16.fromList(int16Min), int16Min);
  });

  test('Int16Base toBytes', () {
    global.throwOnError = false;
    for (var i = 0; i < 10; i++) {
      final int16list0 = rng.int16List(1, 1);
      final int16List1 = new Int16List.fromList(int16list0);
      final bd = int16List1.buffer.asUint8List();
      log
        ..debug('int16list0 : $int16list0')
        ..debug('Int16Base.toBytes(int16list0) ; ${Int16.toBytes(int16list0)}');
      expect(Int16.toBytes(int16list0), equals(bd));
    }

    const int16Max = const [kInt16Max];
    final int16List = new Int16List.fromList(int16Max);
    final uint8List = int16List.buffer.asUint8List();
    expect(Int16.toBytes(int16Max), uint8List);

    const int32Max = const [kInt32Max];
    expect(Int16.toBytes(int32Max), isNull);

    global.throwOnError = true;
    expect(() => Int16.toBytes(int32Max),
        throwsA(const isInstanceOf<InvalidValuesError>()));
  });

  test('Int16Base listToByteData good values', () {
    global.level = Level.info;
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final int16list0 = rng.int16List(1, 1);
      final bd0 = int16list0.buffer.asByteData();
      final lBd0 = Int16.toByteData(int16list0);
      log.debug('lBd0: ${lBd0.buffer.asUint8List()}, bd0: ${bd0.buffer
          .asUint8List()}');
      expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd0.buffer == bd0.buffer, true);

      final lBd1 = Int16.toByteData(int16list0, check: false);
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
      final int16list0 = rng.int16List(1, 1);
      final bd0 = int16list0.buffer.asByteData();
      final lBd1 = Int16.toByteData(int16list0, asView: false);
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

      final lBd4 = Int16.toByteData(int16list0, asView: false, check: false);
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
        throwsA(const isInstanceOf<InvalidValuesError>()));
  });

  test('Int16Base decodeJsonVF', () {
    for (var i = 0; i < 10; i++) {
      final int16list0 = rng.int16List(0, i);
//        final int16List1 = new Int16List.fromList(int16list0);
//        final bd = int16List1.buffer.asUint8List();
//        final s = cvt.base64.encode(bd);
      final bytes = new Bytes.typedDataView(int16list0);
      final s = bytes.getBase64();
      log.debug('Int16.base64: "$s"');

      final ssList = Int16.fromBase64(s);
      log.debug('  Int16.decode: $ssList');
      expect(ssList, equals(int16list0));
//        expect(ssList, equals(int16List1));
    }
  });

  test('Int16Base toBase64', () {
    for (var i = 0; i < 10; i++) {
      final int16list0 = rng.int16List(0, i);
//        final int16List1 = new Int16List.fromList(int16list0);
//        final bd = int16List1.buffer.asUint8List();
      final bytes = new Bytes.typedDataView(int16list0);
//        final s = cvt.base64.encode(bd);
      final s = bytes.getBase64();
      expect(Int16.toBase64(int16list0), equals(s));
    }
  });

  test('Int16Base to/from Base64', () {
    global.level = Level.info;
    for (var i = 1; i < 10; i++) {
      final int16list0 = rng.int16List(0, i);
//        final int16List1 = new Int16List.fromList(int16list0);
//        final bd = int16List1.buffer.asUint8List();
      final bytes = new Bytes.typedDataView(int16list0);
      // Encode
//        final base64 = cvt.base64.encode(bd);
      final base64 = bytes.getBase64();
      log.debug('Int16.base64: "$base64"');
      final s = Int16.toBase64(int16list0);
      log.debug('  Int16.json: "$s"');
      expect(s, equals(base64));

      // Decode
      final ss0 = Int16.fromBase64(base64);
      log.debug('Int16.base64: $ss0');
      final ss1 = Int16.fromBase64(s);
      log.debug('  Int16.json: $ss1');
      expect(ss0, equals(int16list0));
//        expect(ss0, equals(int16List1));
      expect(ss0, equals(ss1));
    }
  });
  test('Int16Base fromByteData', () {
    for (var i = 0; i < 10; i++) {
      final int16list0 = rng.int16List(1, 1);
      final int16List1 = new Int16List.fromList(int16list0);
      final byteData = int16List1.buffer.asByteData();
      log
        ..debug('int16list0 : $int16list0')
        ..debug('Int16.fromByteData(byteData): '
            '${Int16.fromByteData(byteData)}');
      expect(Int16.fromByteData(byteData), equals(int16list0));
    }
  });
}
