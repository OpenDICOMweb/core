//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:convert';
import 'dart:typed_data';

import 'package:bytes_dicom/bytes_dicom.dart';
import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/uInt8_base_test', level: Level.info);
  final rng = RNG(1);
  global.throwOnError = false;

  test('Uint8 toUint8List', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.uint8List(1, 1);
      expect(Uint8.fromList(vList0), vList0);
    }
    const uInt8Min = [kUint8Min];
    const uInt8Max = [kUint8Max];
    expect(Uint8.fromList(uInt8Min), uInt8Min);
    expect(Uint8.fromList(uInt8Max), uInt8Max);

    const uInt64Max = [kUint64Max];
    final from0 = Uint8.fromList(uInt64Max, check: false);
    expect(from0, equals(uInt8Max));
    expect(from0 is Uint8List, true);

    final from1 = Uint8.fromList(uInt64Max, check: true);
    expect(from1, isNull);
    expect(from1 is Uint8List, false);

    final from2 = Uint8.fromList(null);
    expect(from2 == kEmptyUint8List, true);

    final from3 = Uint8.fromList([]);
    expect(from3.isEmpty, true);
    expect(from3 == kEmptyUint8List, true);

    global.throwOnError = true;
    expect(() => Uint8.fromList(uInt64Max),
        throwsA(const TypeMatcher<InvalidValuesError>()));
  });

  test('Uint8 ListToBytes', () {
    global.throwOnError = false;
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.uint8List(1, 1);
      final uInt8ListV1 = Bytes.typedDataView(vList0);
      final bd = uInt8ListV1.buffer.asUint8List();
      log
        ..debug('uInt8ListV1 : $uInt8ListV1')
        ..debug('Uint8.ListToBytesBytes(int32ListV1) ; '
            '${Uint8.toBytes(uInt8ListV1)}');
      expect(Uint8.toBytes(uInt8ListV1), equals(bd));
    }

    const uInt8Max = [kUint8Max];
    final uInt8ListV1 = Uint8List.fromList(uInt8Max);
    final uint8List = uInt8ListV1.buffer.asUint8List();
    expect(Uint8.toBytes(uInt8Max), uint8List);

    const uInt16Max = [kUint16Max];
    final uInt16List2 = Uint16.fromList(uInt16Max);
    expect(Uint8.toUint8List(uInt16List2), isNull);

    expect(Uint8.toUint8List(null), kEmptyUint8List);

    global.throwOnError = true;
    expect(() => Uint8.toBytes(uInt16Max),
        throwsA(const TypeMatcher<InvalidValuesError>()));
  });

  test('Uint8 ListToByteData good values', () {
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final vList0 = rng.uint8List(1, 1);
      final bd0 = vList0.buffer.asByteData();
      final lBd0 = Uint8.toByteData(vList0);
      log.debug('lBd0: ${lBd0.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd0.buffer == bd0.buffer, true);

      final lBd1 = Uint8.toByteData(vList0);
      log.debug('lBd3: ${lBd1.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd1.buffer == bd0.buffer, true);
    }

    const uint8Max = [kUint8Max];
    final uint8List = Uint8List.fromList(uint8Max);
    final bd1 = uint8List.buffer.asByteData();
    final lBd2 = Uint8.toByteData(uint8List);
    log.debug('bd: ${bd1.buffer.asUint8List()}, '
        'lBd2: ${lBd2.buffer.asUint8List()}');
    expect(lBd2.buffer.asUint8List(), equals(bd1.buffer.asUint8List()));
    expect(lBd2.buffer == bd1.buffer, true);
  });

  test('Uint8 toByteData bad values', () {
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final vList0 = rng.uint8List(1, 1);
      final bd0 = vList0.buffer.asByteData();
      final lBd1 = Uint8.toByteData(vList0);
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

      final lBd4 = Uint8.toByteData(vList0);
      log.debug('lBd4: ${lBd4.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd4.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd4.buffer == bd0.buffer, true);
    }

    global.throwOnError = false;
    const uInt16Max = <int>[kUint16Max];

    expect(Uint8.toByteData(uInt16Max), isNull);

    global.throwOnError = false;
    const uInt32Max = <int>[kUint32Max];
    expect(Uint8.toByteData(uInt32Max), isNull);

    global.throwOnError = true;
    expect(() => Uint8.toByteData(uInt16Max),
        throwsA(const TypeMatcher<InvalidValuesError>()));
  });

  test('Uint8 fromBase64', () {
    global.level = Level.info;
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.uint8List(0, i);
      final bytes0 = Bytes.typedDataView(vList0);
      expect(bytes0.asUint8List(), equals(vList0));
      log.debug('bytes: $bytes0', 1);
      final b64 = bytes0.getBase64();
      log.debug('  b64: "$b64"');

      final bytes1 = Bytes.fromBase64(b64);
      log.debug('  bytes1: $bytes1', -1);
      expect(bytes1, equals(bytes0));
    }
  });

  test('Uint8 ListToBase64', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.uint8List(0, i);
      final uInt8ListV1 = Bytes.typedDataView(vList0);
      final bd = uInt8ListV1.buffer.asUint8List();
      final s = base64.encode(bd);
      expect(Uint8.toBase64(vList0), equals(s));
    }
  });

  test('Uint8 encodeDecodeJsonVF', () {
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.uint8List(0, i);
      final bytes = Bytes.typedDataView(vList0);
      final uint8List0 = bytes.asUint8List();

      // Encode
      final b64 = base64.encode(uint8List0);
      log.debug('OB.base64: "$b64"');
      final s = Uint8.toBase64(vList0);
      log.debug('  OB.json: "$s"');
      expect(s, equals(b64));

      // Decode
      final uint8List1 = Uint8.fromBase64(b64);
      log.debug('OB.base64: $uint8List1');
      final uint8List2 = Uint8.fromBase64(s);
      log.debug('  OB.json: $uint8List2');
      expect(uint8List1, equals(vList0));
      expect(uint8List1, equals(uint8List0));
      expect(uint8List1, equals(uint8List2));
    }
  });

  test('Uint8 fromBytes', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.uint8List(1, 1);
      final bytes = Bytes.typedDataView(vList0);
//        final bd = uInt8ListV1.buffer.asUint8List();
      log
        ..debug('uInt8ListV1 : $bytes')
        ..debug('Uint8.fromBytes(bd) ; ${Uint8.fromBytes(bytes)}');
      expect(Uint8.fromBytes(bytes), equals(vList0));
    }
  });

  test('Uint8 fromByteData', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.uint8List(1, 1);
      final uInt8ListV1 = Bytes.typedDataView(vList0);
      final byteData = uInt8ListV1.buffer.asByteData();
      log
        ..debug('vList0 : $vList0')
        ..debug('Uint8.fromByteData(byteData): '
            '${Uint8.fromByteData(byteData)}');
      expect(Uint8.fromByteData(byteData), equals(vList0));
    }
  });

  test('Uint8 fromValueField', () {
    for (var i = 1; i <= 10; i++) {
      final vList0 = rng.uint8List(1, i);
      final uint8ListV0 = Uint8List.fromList(vList0);
      final fvf0 = Uint8.fromValueField(uint8ListV0);
      log.debug('fromValueField0: $fvf0');
      expect(fvf0, equals(uint8ListV0));
      expect(fvf0 is Uint8List, true);
      expect(fvf0 is List<int>, true);
      expect(fvf0.isEmpty, false);
      expect(fvf0 is Bytes, false);
      expect(fvf0 is Uint8List, true);
    }

    final fvf1 = Uint8.fromValueField(null);
    expect(fvf1, <Uint8>[]);
    expect(fvf1 == kEmptyUint8List, true);
    expect(fvf1.isEmpty, true);
    expect(fvf1 is Uint8List, true);

    final fvf2 = Uint8.fromValueField(<int>[]);
    expect(fvf2, <Int16>[]);
    expect(fvf2.length == kEmptyIntList.length, true);
    expect(fvf2.isEmpty, true);

    final vList0 = rng.uint8List(1, 1);
    final uint8ListV1 = Uint8List.fromList(vList0);
    final byte0 = Bytes.fromList(uint8ListV1);
    final fvf3 = Uint8.fromValueField(byte0);
    expect(fvf3, isNotNull);
    expect(fvf3 is Bytes, true);

    final uInt8list0 = uint8ListV1.buffer.asUint8List();
    final fvf4 = Uint8.fromValueField(uInt8list0);
    expect(fvf4, isNotNull);
    expect(fvf4 is Uint8List, true);

    global.throwOnError = false;
    final fvf5 = Uint8.fromValueField(<String>['foo']);
    expect(fvf5, isNull);

    global.throwOnError = true;
    expect(() => Uint8.fromValueField(<String>['foo']),
        throwsA(const TypeMatcher<InvalidValuesError>()));
  });

  test('Uint8 toUint8List', () {
    global.throwOnError = false;
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.uint8List(1, i);
      final unit8List0 = vList0.buffer.asUint8List();
      final toUnit8L0 = Uint8.toUint8List(vList0);
      log.debug('toUnit8L0: $toUnit8L0');
      expect(toUnit8L0, equals(unit8List0));
    }

    final toUnit8L1 = Uint8.toUint8List([]);
    expect(toUnit8L1, equals(kEmptyInt16List));

    final vList1 = rng.uint8List(1, 1);
    final unit8List1 = vList1.buffer.asUint8List();
    final toUnit8L2 = Uint8.toUint8List(vList1, asView: false);
    log.debug('toUnit8L2: $toUnit8L2');
    expect(toUnit8L2, equals(unit8List1));

    final vList2 = rng.uint16List(1, 1);
    final toUnit8L3 = Uint8.toUint8List(vList2);
    log.debug('toUnit8L3: $toUnit8L3');
    expect(toUnit8L3, isNull);
  });

  test('Uint8 fromUnit8List', () {
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.uint8List(1, i);
      final fromUnit8L0 = Uint8.fromUint8List(vList0);
      log.debug('fromUnit8L0: $fromUnit8L0');
      expect(fromUnit8L0, equals(vList0));
    }

    final vList1 = rng.uint8List(0, 0);
    final fromUnit8L1 = Uint8.fromUint8List(vList1);
    expect(fromUnit8L1, kEmptyInt16List);
  });

  test('Uint8 getLength', () {
    for (var i = 2; i < 50; i += 2) {
      final vList = rng.uint8List(i, i);
      final getLen0 = Uint8.getLength(vList.length);
      final length = vList.length ~/ Uint8.kSizeInBytes;
      expect(getLen0 == length, true);
    }
  });
}
