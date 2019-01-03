//  Copyright (c) 208, 2017, 2018,
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
  Server.initialize(name: 'element/Int8_base_test', level: Level.info);
  final rng = RNG(1);
  global.throwOnError = false;

  test('Int8Base fromList', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.int8List(1, 1);
      expect(Int8.fromList(vList0), vList0);
    }
    const int8Min = [kInt8Min];
    const int8Max = [kInt8Max];
    expect(Int8.fromList(int8Max), int8Max);
    expect(Int8.fromList(int8Min), int8Min);

    const int64Max = [kInt64Max];
    final from1 = Int8.fromList(int64Max, check: true);
    expect(from1, isNull);
    expect(from1 is Int8List, false);

    final from2 = Int8.fromList(null);
    expect(from2 == kEmptyInt8List, true);

    final from3 = Int8.fromList([]);
    expect(from3.isEmpty, true);
    expect(from3 == kEmptyInt8List, true);

    global.throwOnError = true;
    expect(() => Int8.fromList(int64Max),
        throwsA(const TypeMatcher<InvalidValuesError>()));
  });

  test('Int8Base toBytes', () {
    global.throwOnError = false;
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.int8List(1, 1);
      final vList1 = Int8List.fromList(vList0);
      final bd = vList1.buffer.asUint8List();
      log
        ..debug('vList0 : $vList0')
        ..debug('SS.toBytes(vList0) ; ${Int8.toBytes(vList0)}');
      expect(Int8.toBytes(vList0), equals(bd));
    }

    const int8Max = [kInt8Max];
    final int8List = Int8List.fromList(int8Max);
    final uint8List = int8List.buffer.asUint8List();
    expect(Int8.toBytes(int8Max), uint8List);

    const int32Max = [kInt32Max];
    expect(Int8.toBytes(int32Max), isNull);

    global.throwOnError = true;
    expect(() => Int8.toBytes(int32Max),
        throwsA(const TypeMatcher<InvalidValuesError>()));
  });

  test('Int8Base listToByteData good values', () {
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final vList0 = rng.int8List(1, 1);
      final bd0 = vList0.buffer.asByteData();
      final lBd0 = Int8.toByteData(vList0);
      log.debug('lBd0: ${lBd0.buffer.asUint8List()}, bd0: '
          '${bd0.buffer.asUint8List()}');
      expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd0.buffer == bd0.buffer, true);

      final lBd1 = Int8.toByteData(vList0, check: false);
      log.debug('lBd3: ${lBd1.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd1.buffer == bd0.buffer, true);
    }

    const int8Max = [kInt8Max];
    final int8List = Int8List.fromList(int8Max);
    final bd1 = int8List.buffer.asByteData();
    final lBd2 = Int8.toByteData(int8List);
    log.debug('bd: ${bd1.buffer.asUint8List()}, '
        'lBd2: ${lBd2.buffer.asUint8List()}');
    expect(lBd2.buffer.asUint8List(), equals(bd1.buffer.asUint8List()));
    expect(lBd2.buffer == bd1.buffer, true);
  });

  test('Int8Base listToByteData bad values', () {
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final vList0 = rng.int8List(1, 1);
      final bd0 = vList0.buffer.asByteData();
      final lBd1 = Int8.toByteData(vList0, asView: false);
      log.debug('lBd1: ${lBd1.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd1.buffer == bd0.buffer, false);

      final int32list0 = rng.int32List(1, 1);
      assert(int32list0 is TypedData);
      //final int32List0 = Int32List.fromList(int32list0);
      final bd1 = int32list0.buffer.asByteData();
      final lBd2 = Int8.toByteData(int32list0, check: false);
      log.debug('lBd0: ${lBd2.buffer.asUint8List()}, '
          'bd1: ${bd1.buffer.asUint8List()}');
      expect(lBd2.buffer.asUint8List(), isNot(bd0.buffer.asUint8List()));
      expect(lBd2.buffer == bd0.buffer, false);
      final lBd3 = Int8.toByteData(int32list0, asView: false);
      expect(lBd3, isNull);

      final lBd4 = Int8.toByteData(vList0, asView: false, check: false);
      log.debug('lBd4: ${lBd4.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd4.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd4.buffer == bd0.buffer, false);
    }

    const int32Max = <int>[kInt32Max];
    expect(Int8.toByteData(int32Max), isNull);

    const int32Min = [kInt32Min];
    expect(Int8.toByteData(int32Min), isNull);

    global.throwOnError = true;
    expect(() => Int8.toByteData(int32Max),
        throwsA(const TypeMatcher<InvalidValuesError>()));
  });

  test('Int8Base decodeJsonVF', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.int8List(0, i);
      final bytes = Bytes.typedDataView(vList0);
      final s = bytes.getBase64();
      log.debug('SS.base64: "$s"');

      final ssList = Int8.fromBase64(s);
      log.debug('  SS.decode: $ssList');
      expect(ssList, equals(vList0));
    }

    final fromBase0 = Int8.fromBase64('');
    expect(fromBase0.isEmpty, true);
    expect(fromBase0 == kEmptyInt8List, true);
  });

  test('Int8Base toBase64', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.int8List(0, i);
      final bytes = Bytes.typedDataView(vList0);
      final s = bytes.getBase64();
      expect(Int8.toBase64(vList0), equals(s));
    }
  });

  test('Int8Base to/from Base64', () {
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.int8List(0, i);
      final bytes = Bytes.typedDataView(vList0);
      // Encode
      final base64 = bytes.getBase64();
      log.debug('Int8Base.base64: "$base64"');
      final s = Int8.toBase64(vList0);
      log.debug('  Int8Base.json: "$s"');
      expect(s, equals(base64));

      // Decode
      final e0 = Int8.fromBase64(base64);
      log.debug('Int8Base.base64: $e0');
      final e1 = Int8.fromBase64(s);
      log.debug('  Int8Base.json: $e1');
      expect(e0, equals(vList0));
      expect(e0, equals(e1));
    }
  });

  test('Int8Base fromByteData', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.int8List(1, 1);
      final vList1 = Int8List.fromList(vList0);
      final byteData = vList1.buffer.asByteData();
      log
        ..debug('vList0 : $vList0')
        ..debug('Int8Base.fromByteData(byteData): '
            '${Int8.fromByteData(byteData)}');
      expect(Int8.fromByteData(byteData), equals(vList0));
    }
  });

  test('Int8 fromValueField', () {
    for (var i = 1; i <= 10; i++) {
      final vList0 = rng.int8List(1, i);
      final int8ListV1 = Int8List.fromList(vList0);
      final fvf0 = Int8.fromValueField(int8ListV1);
      log.debug('fromValueField0: $fvf0');
      expect(fvf0, equals(int8ListV1));
      expect(fvf0 is Int8List, true);
      expect(fvf0 is List<int>, true);
      expect(fvf0.isEmpty, false);
      expect(fvf0 is Bytes, false);
      expect(fvf0 is Uint8List, false);
    }

    final fvf1 = Int8.fromValueField(null);
    expect(fvf1, <Int8>[]);
    expect(fvf1 == kEmptyInt8List, true);
    expect(fvf1.isEmpty, true);
    expect(fvf1 is Int8List, true);

    final fvf2 = Int8.fromValueField(<int>[]);
    expect(fvf2, <Int8>[]);
    expect(fvf2.length == kEmptyIntList.length, true);
    expect(fvf2.isEmpty, true);

    final vList0 = rng.int8List(1, 1);
    final int8ListV1 = Int8List.fromList(vList0);
    final byte0 = Bytes.fromList(int8ListV1);
    final fvf3 = Int8.fromValueField(byte0);
    expect(fvf3, isNotNull);
    expect(fvf3 is Bytes, true);

    final uInt8list0 = int8ListV1.buffer.asUint8List();
    final fvf4 = Int8.fromValueField(uInt8list0);
    expect(fvf4, isNotNull);
    expect(fvf4 is Uint8List, true);

    global.throwOnError = false;
    final fvf5 = Int8.fromValueField(<String>['foo']);
    expect(fvf5, isNull);

    global.throwOnError = true;
    expect(() => Int8.fromValueField(<String>['foo']),
        throwsA(const TypeMatcher<InvalidValuesError>()));
  });

  test('Int8 toUint8List', () {
    global.throwOnError = false;
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.int8List(1, i);
      final unit8List0 = vList0.buffer.asUint8List();
      final toUnit8L0 = Int8.toUint8List(vList0);
      log.debug('toUnit8L0: $toUnit8L0');
      expect(toUnit8L0, equals(unit8List0));
    }

    final toUnit8L1 = Int8.toUint8List([]);
    expect(toUnit8L1, equals(kEmptyInt8List));

    final vList1 = rng.int8List(1, 1);
    final unit8List1 = vList1.buffer.asUint8List();
    final toUnit8L2 = Int8.toUint8List(vList1, asView: false);
    log.debug('toUnit8L2: $toUnit8L2');
    expect(toUnit8L2, equals(unit8List1));

    final vList3 = rng.int32List(1, 1);
    final toUnit8L4 = Int8.toUint8List(vList3);
    log.debug('toUnit8L4: $toUnit8L4');
    expect(toUnit8L4, isNull);
  });

  test('Int8 fromUnit8List', () {
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.int8List(1, i);
      final unit8List0 = vList0.buffer.asUint8List();
      final fromUnit8L0 = Int8.fromUint8List(unit8List0);
      log.debug('fromUnit8L0: $fromUnit8L0');
      expect(fromUnit8L0, equals(vList0));
    }
  });

  test('Int8Base listFromBytes', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.int8List(1, 1);
      final bytes = Bytes.typedDataView(vList0);
      final vList1 = bytes.asInt8List();
      log
        ..debug('vList0 : $vList0')
        ..debug('SS.fromBytes(bd) ; ${bytes.asInt8List()}');
      expect(vList1, equals(vList0));
    }
  });

  test('Int8Base getLength', () {
    for (var i = 2; i < 50; i += 2) {
      final vList = rng.int8List(i, i);
      final getLen0 = Int8.getLength(vList.length);
      final length = vList.length ~/ Int8.kSizeInBytes;
      expect(getLen0 == length, true);
    }
  });

  test('toInt8List', () {
    for (var i = 1; i < 10; i++) {
      global.throwOnError = false;
      final vList0 = rng.int8List(1, i);
      final int8List0 = Int8.toInt8List(vList0);
      log.debug('int8List0: $int8List0');
      expect(vList0 is Int8List, true);
      expect(int8List0 == vList0, true);

      final vList1 = rng.int16List(1, i);
      final int8List1 = Int8.toInt8List(vList1);
      expect(vList1 is Int8List, false);
      expect(int8List1, isNull);

      global.throwOnError = true;
      expect(() => Int8.toInt8List(vList1),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    }
  });
}
