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
  Server.initialize(name: 'element/int32_base_test', level: Level.info);
  final rng = new RNG(1);
  global.throwOnError = false;

  test('Int32Base fromList', () {
    for (var i = 0; i < 10; i++) {
      final int32list0 = rng.int32List(1, 1);
      expect(Int32.fromList(int32list0), int32list0);
    }
    const int32Min = const [kInt32Min];
    const int32Max = const [kInt32Max];
    expect(Int32.fromList(int32Max), int32Max);
    expect(Int32.fromList(int32Min), int32Min);
  });

  test('Int32Base fromUint8List', () {
    for (var i = 0; i < 10; i++) {
      final int32list0 = rng.int32List(1, 1);
      final int32ListV1 = new Int32List.fromList(int32list0);
      final bd = int32ListV1.buffer.asUint8List();
      log
        ..debug('int32ListV1 : $int32ListV1')
        ..debug('Int32.fromUint8List(bd) ; ${Int32.fromUint8List(bd)}');
      expect(Int32.fromUint8List(bd), equals(int32ListV1));
    }
  });

  test('Int32Base toBytes', () {
    global.throwOnError = false;
    for (var i = 0; i < 10; i++) {
      final int32list0 = rng.int32List(1, 1);
      final int32ListV1 = new Int32List.fromList(int32list0);
      final bd = int32ListV1.buffer.asUint8List();
      log
        ..debug('int32ListV1 : $int32ListV1')
        ..debug('Int32.toBytes(int32ListV1) ; ${Int32.toBytes(int32ListV1)}');
      expect(Int32.toBytes(int32ListV1), equals(bd));
    }
    const int32Max = const [kInt32Max];
    final int32List = new Int32List.fromList(int32Max);
    final uaInt8List = int32List.buffer.asUint8List();
    expect(Int32.toBytes(int32Max), uaInt8List);

    const int64Max = const [kInt64Max];
    expect(Int32.toBytes(int64Max), isNull);

    global.throwOnError = true;
    expect(() => Int32.toBytes(int64Max),
        throwsA(const isInstanceOf<InvalidValuesError>()));
  });

  test('Int32Base toByteData good values', () {
    global.level = Level.info;
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final int32list0 = rng.int32List(1, 1);
      final bd0 = int32list0.buffer.asByteData();
      final lBd0 = Int32.toByteData(int32list0);
      log.debug('lBd0: ${lBd0.buffer.asUint8List()}, bd0: ${bd0.buffer
          .asUint8List()}');
      expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd0.buffer == bd0.buffer, true);

      final lBd1 = Int32.toByteData(int32list0, check: false);
      log.debug('lBd3: ${lBd1.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd1.buffer == bd0.buffer, true);
    }

    const int32Max = const [kInt32Max];
    final int32List = new Int32List.fromList(int32Max);
    final bd1 = int32List.buffer.asByteData();
    final lBd2 = Int32.toByteData(int32List);
    log.debug('bd: ${bd1.buffer.asUint8List()}, '
        'lBd2: ${lBd2.buffer.asUint8List()}');
    expect(lBd2.buffer.asUint8List(), equals(bd1.buffer.asUint8List()));
    expect(lBd2.buffer == bd1.buffer, true);
  });

  test('Int32Base toByteData bad values', () {
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final int32list0 = rng.int32List(1, 1);
      final bd0 = int32list0.buffer.asByteData();
      final lBd1 = Int32.toByteData(int32list0, asView: false);
      log.debug('lBd1: ${lBd1.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd1.buffer == bd0.buffer, false);

      final lBd2 = Int32.toByteData(int32list0, asView: false, check: false);
      log.debug('lBd2: ${lBd2.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd2.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd2.buffer == bd0.buffer, false);
    }

    const int32Max = const <int>[kInt32Max + 1];
    expect(Int32.toByteData(int32Max), isNull);

    const int32Min = const [kInt32Min - 1];
    expect(Int32.toByteData(int32Min), isNull);

    global.throwOnError = true;
    expect(() => Int32.toByteData(int32Max),
        throwsA(const isInstanceOf<InvalidValuesError>()));
  });

  test('Int32Base fromBase64', () {
    global.level = Level.info;
    for (var i = 0; i < 10; i++) {
      final intList0 = rng.int32List(0, i);
      final int32List0 = new Int32List.fromList(intList0);
      final uInt8List0 = int32List0.buffer.asUint8List();
      final base64 = cvt.base64.encode(uInt8List0);
      log.debug('Int32.base64: "$base64"');

      final slList = Int32.fromBase64(base64);
      log.debug('  Int32.decode: $slList');
      expect(slList, equals(intList0));
      expect(slList, equals(int32List0));
    }
  });

  test('Int32Base toBase64', () {
    for (var i = 0; i < 10; i++) {
      final int32list0 = rng.int32List(0, i);
      final int32ListV1 = new Int32List.fromList(int32list0);
      final bd = int32ListV1.buffer.asUint8List();
      final base64 = cvt.base64.encode(bd);
      final s = Int32.toBase64(int32list0);
      expect(s, equals(base64));
    }
  });

  test('Int32Base toBase64', () {
    for (var i = 0; i < 10; i++) {
      final int32list0 = rng.int32List(1, 1);
      final int32ListV1 = new Int32List.fromList(int32list0);
      final bd = int32ListV1.buffer.asUint8List();
      final s = cvt.base64.encode(bd);
      expect(Int32.toBase64(int32list0), equals(s));
    }
  });

  test('Int32Base encodeDecodeJsonVF', () {
    global.level = Level.info;
    for (var i = 1; i < 10; i++) {
      final int32list0 = rng.int32List(0, i);
      final int32ListV1 = new Int32List.fromList(int32list0);
      final bd = int32ListV1.buffer.asUint8List();

      // Encode
      final base64 = cvt.base64.encode(bd);
      log.debug('Int32.base64: "$base64"');
      final s = Int32.toBase64(int32list0);
      log.debug('  Int32.json: "$s"');
      expect(s, equals(base64));

      // Decode
      final sl0 = Int32.fromBase64(base64);
      log.debug('Int32.base64: $sl0');
      final sl1 = Int32.fromBase64(s);
      log.debug('  Int32.json: $sl1');
      expect(sl0, equals(int32list0));
      expect(sl0, equals(int32ListV1));
      expect(sl0, equals(sl1));
    }
  });

  test('Int32Base fromUint8List', () {
    for (var i = 0; i < 10; i++) {
      final int32list0 = rng.int32List(1, 1);
      final int32ListV1 = new Int32List.fromList(int32list0);
      final bd = int32ListV1.buffer.asUint8List();
      log
        ..debug('int32ListV1 : $int32ListV1')
        ..debug('Int32.fromUint8List(bd) ; ${Int32.fromUint8List(bd)}');
      expect(Int32.fromUint8List(bd), equals(int32ListV1));
    }
  });

  test('Int32Base fromByteData', () {
    for (var i = 0; i < 10; i++) {
      final int32list0 = rng.int32List(1, 1);
      final int32ListV1 = new Int32List.fromList(int32list0);
      final byteData = int32ListV1.buffer.asByteData();
      log
        ..debug('int32list0 : $int32list0')
        ..debug('Int32.fromByteData(byteData): '
            '${Int32.fromByteData(byteData)}');
      expect(Int32.fromByteData(byteData), equals(int32list0));
    }
  });
}
