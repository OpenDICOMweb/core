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
  final rng = RNG(1);
  global.throwOnError = false;

  test('Uint32 fromList', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.uint32List(1, 1);
      expect(Uint32.fromList(vList0), vList0);
    }
    const uInt32Min = [kUint32Min];
    const uInt32Max = [kUint32Max];
    expect(Uint32.fromList(uInt32Min), uInt32Min);
    expect(Uint32.fromList(uInt32Max), uInt32Max);
  });

  test('Uint32 fromBytes', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.uint32List(1, 1);
//        final vList1 = Uint32List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
      final bytes = Bytes.typedDataView(vList0);
      log
        ..debug('vList0 : $vList0')
        ..debug('Uint32.fromBytes(bd) ; ${Uint32.fromBytes(bytes)}');
      expect(Uint32.fromBytes(bytes), equals(vList0));
    }
  });

  test('Uint32 toBytes', () {
    global.throwOnError = false;
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.uint32List(1, 1);
//        final vList1 = Uint32List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
      final bytes = Bytes.typedDataView(vList0);
      log
        ..debug('vList0 : $vList0')
        ..debug('Uint32.toBytes($bytes): '
            '${Uint32.toBytes(bytes)}');
      expect(Uint32.toBytes(vList0), equals(bytes));
    }

    const uInt32Max = [kUint32Max];
    final vList1 = Uint32List.fromList(uInt32Max);
//      final uint32List = vList1.buffer.asUint8List();
    final bytes = Bytes.typedDataView(vList1);
    expect(Uint32.toBytes(uInt32Max), bytes);

    const uint64Max = [kUint64Max];
    expect(Uint32.toBytes(uint64Max), isNull);

    global.throwOnError = true;
    expect(() => Uint32.toBytes(uint64Max),
        throwsA(const TypeMatcher<InvalidValuesError>()));
  });

  test('Uint32 toByteData good values', () {
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final vList0 = rng.uint32List(1, 1);
      final bd0 = vList0.buffer.asByteData();
      final lBd0 = Uint32.toByteData(vList0);
      log.debug('lBd0: ${lBd0.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd0.buffer == bd0.buffer, true);

      final lBd1 = Uint32.toByteData(vList0, check: false);
      log.debug('lBd3: ${lBd1.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd1.buffer == bd0.buffer, true);
    }

    const uInt32Max = [kUint32Max];
    final uint32List = Uint32List.fromList(uInt32Max);
    final bd1 = uint32List.buffer.asByteData();
    final lBd2 = Uint32.toByteData(uint32List);
    log.debug('bd: ${bd1.buffer.asUint8List()}, '
        'lBd2: ${lBd2.buffer.asUint8List()}');
    expect(lBd2.buffer.asUint8List(), equals(bd1.buffer.asUint8List()));
    expect(lBd2.buffer == bd1.buffer, true);
  });

  test('Uint32 toByteData bad values', () {
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final vList0 = rng.uint32List(1, 1);
      final bd0 = vList0.buffer.asByteData();
      final lBd1 = Uint32.toByteData(vList0, asView: false);
      log.debug('lBd1: ${lBd1.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd1.buffer == bd0.buffer, false);

      final lBd2 = Uint32.toByteData(vList0, asView: false, check: false);
      log.debug('lBd2: ${lBd2.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd2.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd2.buffer == bd0.buffer, false);
    }

    global.throwOnError = false;
    const uInt32Max = <int>[kUint32Max + 1];
    expect(Uint32.toByteData(uInt32Max), isNull);

    global.throwOnError = true;
    expect(() => Uint32.toByteData(uInt32Max),
        throwsA(const TypeMatcher<InvalidValuesError>()));
  });

  test('Uint32 fromBase64', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.uint32List(0, i);
//        final vList1 = Uint32List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
//        final base64 = cvt.base64.encode(bd);
      final bytes = Bytes.typedDataView(vList0);
      final base64 = bytes.getBase64();
      log.debug('UL.base64: "$base64"');

      final ulList = Uint32.fromBase64(base64);
      log.debug('  UL.decode: $ulList');
      expect(ulList, equals(vList0));
//        expect(ulList, equals(vList1));
    }
  });

/*
    test('Uint32 toBase64', () {
      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final uint32List0 = rng.uint32List(1, 1);
//        final uint32List1 = Uint32List.fromList(uint32List0);
//        final bd = uint32List1.buffer.asUint8List();
//        final s = cvt.base64.encode(bd);
        final bytes = Bytes.typedDataView(uint32List0);
//        expect(Uint32.toBase64(uint32List0), equals(s));
      }
    });
*/

  test('Uint32 encodeDecodeJsonVF', () {
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.uint32List(0, i);
      final bytes = Bytes.typedDataView(vList0);
      final base64 = bytes.getBase64();
      log.debug('UL.base64: "$base64"');
      final s = Uint32.toBase64(vList0);
      log.debug('  UL.json: "$s"');
      expect(s, equals(base64));

      // Decode
      final e0 = Uint32.fromBase64(base64);
      log.debug('UL.base64: $e0');
      final e1 = Uint32.fromBase64(s);
      log.debug('  UL.json: $e1');
      expect(e0, equals(vList0));
//        expect(e0, equals(vList1));
      expect(e0, equals(e1));
    }
  });

  test('Uint32 fromByteData', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.uint32List(1, 1);
//        final vList1 = Uint32List.fromList(vList0);
//        final byteData = vList1.buffer.asByteData();
      final bytes = Bytes.typedDataView(vList0);
      final bd = bytes.asByteData();
      log
        ..debug('vList0 : $vList0')
        ..debug('Uint32.fromByteData(byteData): '
            '${Uint32.fromByteData(bd)}');
      expect(Uint32.fromByteData(bd), equals(vList0));
    }
  });

  test('Uint32 fromValueField', () {
    for (var i = 1; i <= 10; i++) {
      final vList0 = rng.uint32List(1, i);
      final uint8ListV0 = Uint32List.fromList(vList0);
      final fvf0 = Uint32.fromValueField(uint8ListV0);
      log.debug('fromValueField0: $fvf0');
      expect(fvf0, equals(uint8ListV0));
      expect(fvf0 is Uint32List, true);
      expect(fvf0 is List<int>, true);
      expect(fvf0.isEmpty, false);
      expect(fvf0 is Bytes, false);
      expect(fvf0 is Uint32List, true);
    }

    final fvf1 = Uint32.fromValueField(null);
    expect(fvf1, <Uint32>[]);
    expect(fvf1 == kEmptyUint32List, true);
    expect(fvf1.isEmpty, true);
    expect(fvf1 is Uint32List, true);

    final fvf2 = Uint32.fromValueField(<int>[]);
    expect(fvf2, <Int16>[]);
    expect(fvf2.length == kEmptyIntList.length, true);
    expect(fvf2.isEmpty, true);

    final vList0 = rng.uint32List(1, 1);
    final uint8ListV1 = Uint32List.fromList(vList0);
    final byte0 = Bytes.fromList(uint8ListV1);
    final fvf3 = Uint32.fromValueField(byte0);
    expect(fvf3, isNotNull);
    expect(fvf3 is Bytes, true);

    final uInt8list0 = uint8ListV1.buffer.asUint8List();
    final fvf4 = Uint32.fromValueField(uInt8list0);
    expect(fvf4, isNotNull);

    global.throwOnError = false;
    final fvf5 = Uint32.fromValueField(<String>['foo']);
    expect(fvf5, isNull);

    global.throwOnError = true;
    expect(() => Uint32.fromValueField(<String>['foo']),
        throwsA(const TypeMatcher<InvalidValuesError>()));
  });

  test('Uint32 toUint8List', () {
    global.throwOnError = false;
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.uint32List(1, i);
      final unit8List0 = vList0.buffer.asUint8List();
      final toUnit8L0 = Uint32.toUint8List(vList0);
      log.debug('toUnit8L0: $toUnit8L0');
      expect(toUnit8L0, equals(unit8List0));
    }

    final toUnit8L1 = Uint32.toUint8List([]);
    expect(toUnit8L1, equals(kEmptyInt16List));

    final vList1 = rng.uint32List(1, 1);
    final unit8List1 = vList1.buffer.asUint8List();
    final toUnit8L2 = Uint32.toUint8List(vList1, asView: false);
    log.debug('toUnit8L2: $toUnit8L2');
    expect(toUnit8L2, equals(unit8List1));

    final vList2 = rng.uint64List(1, 1);
    final toUnit8L3 = Uint32.toUint8List(vList2);
    log.debug('toUnit8L3: $toUnit8L3');
    expect(toUnit8L3, isNull);
  });

  test('Uint32 fromUnit8List', () {
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.uint32List(1, i);
      final uint8List0 = vList0.buffer.asUint8List();
      final fromUnit8L0 = Uint32.fromUint8List(uint8List0);
      log.debug('fromUnit8L0: $fromUnit8L0');
      expect(fromUnit8L0, equals(vList0));
    }

    final vList1 = rng.uint32List(0, 0);
    final uint8List1 = vList1.buffer.asUint8List();
    final fromUnit8L1 = Uint32.fromUint8List(uint8List1);
    expect(fromUnit8L1, kEmptyInt16List);
  });

  test('Uint32 getLength', () {
    for (var i = 4; i < 100; i += 4) {
      final vList = rng.uint32List(i, i);
      final getLen0 = Uint32.getLength(vList.length);
      final length = vList.length ~/ Uint32.kSizeInBytes;
      expect(getLen0 == length, true);
    }
  });
}
