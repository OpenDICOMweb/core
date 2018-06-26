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

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/int32_base_test', level: Level.info);
  final rng = new RNG(1);
  global.throwOnError = false;

  test('Int32Base fromList', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.int32List(1, 1);
      expect(Int32.fromList(vList0), vList0);
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
      final vList0 = rng.int32List(1, 1);
      final int32ListV1 = new Int32List.fromList(vList0);
      final bd = int32ListV1.buffer.asUint8List();
      log
        ..debug('int32ListV1 : $int32ListV1')
        ..debug('SL.toBytes(int32ListV1) ; ${Int32.toBytes(int32ListV1)}');
      expect(Int32.toBytes(int32ListV1), equals(bd));
    }
    const int32Max = const [kInt32Max];
    final vList1 = new Int32List.fromList(int32Max);
    final uaInt8List = vList1.buffer.asUint8List();
    expect(Int32.toBytes(int32Max), uaInt8List);

    const int64Max = const [kInt64Max];
    expect(Int32.toBytes(int64Max), isNull);

    global.throwOnError = true;
    expect(() => Int32.toBytes(int64Max),
        throwsA(const TypeMatcher<InvalidValuesError>()));
  });

  test('Int32Base toByteData good values', () {
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final vList0 = rng.int32List(1, 1);
      final bd0 = vList0.buffer.asByteData();
      final lBd0 = Int32.toByteData(vList0);
      log.debug('lBd0: ${lBd0.buffer.asUint8List()}, bd0: ${bd0.buffer
          .asUint8List()}');
      expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd0.buffer == bd0.buffer, true);

      final lBd1 = Int32.toByteData(vList0, check: false);
      log.debug('lBd3: ${lBd1.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd1.buffer == bd0.buffer, true);
    }

    const int32Max = const [kInt32Max];
    final vList1 = new Int32List.fromList(int32Max);
    final bd1 = vList1.buffer.asByteData();
    final lBd2 = Int32.toByteData(vList1);
    log.debug('bd: ${bd1.buffer.asUint8List()}, '
        'lBd2: ${lBd2.buffer.asUint8List()}');
    expect(lBd2.buffer.asUint8List(), equals(bd1.buffer.asUint8List()));
    expect(lBd2.buffer == bd1.buffer, true);
  });

  test('Int32Base toByteData bad values', () {
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final vList0 = rng.int32List(1, 1);
      final bd0 = vList0.buffer.asByteData();
      final lBd1 = Int32.toByteData(vList0, asView: false);
      log.debug('lBd1: ${lBd1.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd1.buffer == bd0.buffer, false);

      final lBd2 = Int32.toByteData(vList0, asView: false, check: false);
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
        throwsA(const TypeMatcher<InvalidValuesError>()));
  });

  test('Int32Base fromBase64', () {
    for (var i = 0; i < 10; i++) {
      final intList0 = rng.int32List(0, i);
      final vList0 = new Int32List.fromList(intList0);
      final uInt8List0 = vList0.buffer.asUint8List();
      final base64 = cvt.base64.encode(uInt8List0);
      log.debug('SL.base64: "$base64"');

      final slList = Int32.fromBase64(base64);
      log.debug('  SL.decode: $slList');
      expect(slList, equals(intList0));
      expect(slList, equals(vList0));
    }
  });

  test('Int32Base toBase64', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.int32List(0, i);
      final int32ListV1 = new Int32List.fromList(vList0);
      final bd = int32ListV1.buffer.asUint8List();
      final base64 = cvt.base64.encode(bd);
      final s = Int32.toBase64(vList0);
      expect(s, equals(base64));
    }
  });

  test('Int32Base toBase64', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.int32List(1, 1);
      final int32ListV1 = new Int32List.fromList(vList0);
      final bd = int32ListV1.buffer.asUint8List();
      final s = cvt.base64.encode(bd);
      expect(Int32.toBase64(vList0), equals(s));
    }
  });

  test('Int32Base encodeDecodeJsonVF', () {
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.int32List(0, i);
      final int32ListV1 = new Int32List.fromList(vList0);
      final bd = int32ListV1.buffer.asUint8List();

      // Encode
      final base64 = cvt.base64.encode(bd);
      log.debug('SL.base64: "$base64"');
      final s = Int32.toBase64(vList0);
      log.debug('  SL.json: "$s"');
      expect(s, equals(base64));

      // Decode
      final e0 = Int32.fromBase64(base64);
      log.debug('SL.base64: $e0');
      final e1 = Int32.fromBase64(s);
      log.debug('  SL.json: $e1');
      expect(e0, equals(vList0));
      expect(e0, equals(int32ListV1));
      expect(e0, equals(e1));
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

  test('Int32 fromValueField', () {
    for (var i = 1; i <= 10; i++) {
      final vList0 = rng.int32List(1, i);
      final int32ListV1 = new Int32List.fromList(vList0);
      final fvf0 = Int32.fromValueField(int32ListV1);
      log.debug('fromValueField0: $fvf0');
      expect(fvf0, equals(int32ListV1));
      expect(fvf0 is Int32List, true);
      expect(fvf0 is List<int>, true);
      expect(fvf0.isEmpty, false);
      expect(fvf0 is Bytes, false);
    }

    final fvf1 = Int32.fromValueField(null);
    expect(fvf1, <Int32>[]);
    expect(fvf1 == kEmptyInt32List, true);
    expect(fvf1.isEmpty, true);
    expect(fvf1 is Int32List, true);

    final fvf2 = Int32.fromValueField(<int>[]);
    expect(fvf2, <Int32>[]);
    expect(fvf2.length == kEmptyIntList.length, true);
    expect(fvf2.isEmpty, true);

    final vList0 = rng.int32List(1, 1);
    final int32ListV1 = new Int32List.fromList(vList0);
    final byte0 = new Bytes.fromList(int32ListV1);
    final fvf3 = Int32.fromValueField(byte0);
    expect(fvf3, isNotNull);
    expect(fvf3 is Bytes, true);

    final uInt8list0 = int32ListV1.buffer.asUint8List();
    final fvf4 = Int16.fromValueField(uInt8list0);
    expect(fvf4, isNotNull);
    expect(fvf4 is Uint8List, true);

    global.throwOnError = false;
    final fvf5 = Int32.fromValueField(<String>['foo']);
    expect(fvf5, isNull);

    global.throwOnError = true;
    expect(() => Int32.fromValueField(<String>['foo']),
        throwsA(const TypeMatcher<InvalidValuesError>()));
  });

  test('Int32 toUint8List', () {
    global.throwOnError = false;
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.int32List(1, i);
      final unit8List0 = vList0.buffer.asUint8List();
      final toUnit8L0 = Int32.toUint8List(vList0);
      log.debug('toUnit8L0: $toUnit8L0');
      expect(toUnit8L0, equals(unit8List0));
    }

    final toUnit8L1 = Int32.toUint8List([]);
    expect(toUnit8L1, equals(kEmptyInt32List));

    final vList1 = rng.int32List(1, 1);
    final unit8List1 = vList1.buffer.asUint8List();
    final toUnit8L2 = Int32.toUint8List(vList1, asView: false);
    log.debug('toUnit8L2: $toUnit8L2');
    expect(toUnit8L2, equals(unit8List1));

    final vList2 = rng.int8List(1, 1);
    final unit8List2 = vList2.buffer.asUint8List();
    final toUnit8L3 = Int32.toUint8List(vList2);
    log.debug('toUnit8L3: $toUnit8L3');
    expect(toUnit8L3, isNot(unit8List2));

    final vList3 = rng.int64List(1, 1);
    final toUnit8L4 = Int32.toUint8List(vList3);
    log.debug('toUnit8L4: $toUnit8L4');
    expect(toUnit8L4, isNull);
  });
}
