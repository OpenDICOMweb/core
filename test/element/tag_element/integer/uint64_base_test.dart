//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:bytes_dicom/bytes_dicom.dart';
import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/uInt64_base_test', level: Level.info);
  final rng = RNG(1);
  global.throwOnError = false;

  test('Uint64 fromList', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.uint64List(1, 1);
      expect(Uint64.fromList(vList0), vList0);
    }
    const uInt64Min = [kUint64Min];
    const uInt64Max = [kUint64Max];
    expect(Uint64.fromList(uInt64Min), uInt64Min);
    expect(Uint64.fromList(uInt64Max), uInt64Max);
  });

  test('Uint64 fromBytes', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.uint64List(1, 1);
      final bytes = Bytes.typedDataView(vList0);
      log
        ..debug('vList0 : $vList0')
        ..debug('Uint64.fromBytes(bd) ; ${Uint64.fromBytes(bytes)}');
      expect(Uint64.fromBytes(bytes), equals(vList0));
    }
  });

  test('Uint64 toBytes', () {
    global.throwOnError = false;
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.uint64List(1, 1);
      final bytes = Bytes.typedDataView(vList0);
      log
        ..debug('vList0 : $vList0')
        ..debug('Uint64.toBytes($bytes): '
            '${Uint64.toBytes(bytes)}');
      expect(Uint64.toBytes(vList0), equals(bytes));
    }

    const uInt64Max = [kUint64Max];
    final vList1 = Uint64List.fromList(uInt64Max);
    final bytes = Bytes.typedDataView(vList1);
    expect(Uint64.toBytes(uInt64Max), bytes);
  });

  test('Uint64 toByteData good values', () {
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final vList0 = rng.uint64List(1, 1);
      final bd0 = vList0.buffer.asByteData();
      final lBd0 = Uint64.toByteData(vList0);
      log.debug('lBd0: ${lBd0.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd0.buffer == bd0.buffer, true);

      final lBd1 = Uint64.toByteData(vList0, check: false);
      log.debug('lBd3: ${lBd1.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd1.buffer == bd0.buffer, true);
    }

    const uInt64Max = [kUint64Max];
    final uint64List = Uint64List.fromList(uInt64Max);
    final bd1 = uint64List.buffer.asByteData();
    final lBd2 = Uint64.toByteData(uint64List);
    log.debug('bd: ${bd1.buffer.asUint8List()}, '
        'lBd2: ${lBd2.buffer.asUint8List()}');
    expect(lBd2.buffer.asUint8List(), equals(bd1.buffer.asUint8List()));
    expect(lBd2.buffer == bd1.buffer, true);
  });

  test('Uint64 toByteData bad values', () {
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final vList0 = rng.uint64List(1, 1);
      final bd0 = vList0.buffer.asByteData();
      final lBd1 = Uint64.toByteData(vList0, asView: false);
      log.debug('lBd1: ${lBd1.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd1.buffer == bd0.buffer, false);

      final lBd2 = Uint64.toByteData(vList0, asView: false, check: false);
      log.debug('lBd2: ${lBd2.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd2.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd2.buffer == bd0.buffer, false);
    }

    global.throwOnError = false;
    const uInt64Max = <int>[kUint64Max + 1];
    expect(Uint64.toByteData(uInt64Max), isNull);

    global.throwOnError = true;
    expect(() => Uint64.toByteData(uInt64Max),
        throwsA(const TypeMatcher<InvalidValuesError>()));
  });

  test('Uint64 fromBase64', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.uint64List(0, i);
      final bytes = Bytes.typedDataView(vList0);
      final base64 = bytes.getBase64();
      log.debug('UL.base64: "$base64"');

      final ulList = Uint64.fromBase64(base64);
      log.debug('  UL.decode: $ulList');
      expect(ulList, equals(vList0));
    }
  });

  test('Uint64 encodeDecodeJsonVF', () {
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.uint64List(0, i);
      final bytes = Bytes.typedDataView(vList0);
      final base64 = bytes.getBase64();
      log.debug('UL.base64: "$base64"');
      final s = Uint64.toBase64(vList0);
      log.debug('  UL.json: "$s"');
      expect(s, equals(base64));

      // Decode
      final e0 = Uint64.fromBase64(base64);
      log.debug('UL.base64: $e0');
      final e1 = Uint64.fromBase64(s);
      log.debug('  UL.json: $e1');
      expect(e0, equals(vList0));
//        expect(e0, equals(vList1));
      expect(e0, equals(e1));
    }
  });

  test('Uint64 fromByteData', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.uint64List(1, 1);
//        final vList1 = Uint64List.fromList(vList0);
//        final byteData = vList1.buffer.asByteData();
      final bytes = Bytes.typedDataView(vList0);
      final bd = bytes.asByteData();
      log
        ..debug('vList0 : $vList0')
        ..debug('Uint64.fromByteData(byteData): '
            '${Uint64.fromByteData(bd)}');
      expect(Uint64.fromByteData(bd), equals(vList0));
    }
  });

  test('Uint64 fromValueField', () {
    for (var i = 1; i <= 10; i++) {
      final vList0 = rng.uint64List(1, i);
      final uint8ListV0 = Uint64List.fromList(vList0);
      final fvf0 = Uint64.fromValueField(uint8ListV0);
      log.debug('fromValueField0: $fvf0');
      expect(fvf0, equals(uint8ListV0));
      expect(fvf0 is Uint64List, true);
      expect(fvf0 is List<int>, true);
      expect(fvf0.isEmpty, false);
      expect(fvf0 is Bytes, false);
      expect(fvf0 is Uint64List, true);
    }

    final fvf1 = Uint64.fromValueField(null);
    expect(fvf1, <Uint64>[]);
    expect(fvf1 == kEmptyUint64List, true);
    expect(fvf1.isEmpty, true);
    expect(fvf1 is Uint64List, true);

    final fvf2 = Uint64.fromValueField(<int>[]);
    expect(fvf2, <Int16>[]);
    expect(fvf2.length == kEmptyIntList.length, true);
    expect(fvf2.isEmpty, true);

    final vList0 = rng.uint64List(1, 1);
    final uint8ListV1 = Uint64List.fromList(vList0);
    final byte0 = Bytes.fromList(uint8ListV1);
    final fvf3 = Uint64.fromValueField(byte0);
    expect(fvf3, isNotNull);
    expect(fvf3 is Bytes, true);

    final uInt8list0 = uint8ListV1.buffer.asUint8List();
    final fvf4 = Uint64.fromValueField(uInt8list0);
    expect(fvf4, isNotNull);

    global.throwOnError = false;
    final fvf5 = Uint64.fromValueField(<String>['foo']);
    expect(fvf5, isNull);

    global.throwOnError = true;
    expect(() => Uint64.fromValueField(<String>['foo']),
        throwsA(const TypeMatcher<InvalidValuesError>()));
  });

  test('Uint64 toUint8List', () {
    global.throwOnError = false;
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.uint64List(1, i);
      final unit8List0 = vList0.buffer.asUint8List();
      final toUnit8L0 = Uint64.toUint8List(vList0);
      log.debug('toUnit8L0: $toUnit8L0');
      expect(toUnit8L0, equals(unit8List0));
    }

    final toUnit8L1 = Uint64.toUint8List([]);
    expect(toUnit8L1, equals(kEmptyInt16List));

    final vList1 = rng.uint64List(1, 1);
    final unit8List1 = vList1.buffer.asUint8List();
    final toUnit8L2 = Uint64.toUint8List(vList1, asView: false);
    log.debug('toUnit8L2: $toUnit8L2');
    expect(toUnit8L2, equals(unit8List1));
  });

  test('Uint64 fromUnit8List', () {
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.uint64List(1, i);
      final uint8List0 = vList0.buffer.asUint8List();
      final fromUnit8L0 = Uint64.fromUint8List(uint8List0);
      log.debug('fromUnit8L0: $fromUnit8L0');
      expect(fromUnit8L0, equals(vList0));
    }

    final vList1 = rng.uint64List(0, 0);
    final uint8List1 = vList1.buffer.asUint8List();
    final fromUnit8L1 = Uint64.fromUint8List(uint8List1);
    expect(fromUnit8L1, kEmptyInt16List);
  });

  test('Uint64 getLength', () {
    for (var i = 8; i < 100; i += 8) {
      final vList = rng.uint64List(i, i);
      final getLen0 = Uint64.getLength(vList.length);
      final length = vList.length ~/ Uint64.kSizeInBytes;
      expect(getLen0 == length, true);
    }
  });
}
