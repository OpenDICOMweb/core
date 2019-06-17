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

import 'package:bytes_dicom/bytes_dicom.dart';
import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/int64_base_test', level: Level.info);
  final rng = RNG(1);
  global.throwOnError = false;

  test('Int64Base fromList', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.int64List(1, 1);
      expect(Int64.fromList(vList0), vList0);
    }
    const int64Min = [kInt64Min];
    const int64Max = [kInt64Max];
    expect(Int64.fromList(int64Max), int64Max);
    expect(Int64.fromList(int64Min), int64Min);
  });

  test('Int64Base fromUint8List', () {
    for (var i = 0; i < 10; i++) {
      final int64list0 = rng.int64List(1, 1);
      final int64ListV1 = Int64List.fromList(int64list0);
      final bd = int64ListV1.buffer.asUint8List();
      log
        ..debug('int64ListV1 : $int64ListV1')
        ..debug('Int64.fromUint8List(bd) ; ${Int64.fromUint8List(bd)}');
      expect(Int64.fromUint8List(bd), equals(int64ListV1));
    }
  });

  test('Int64Base toBytes', () {
    global.throwOnError = false;
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.int64List(1, 1);
      final int64ListV1 = Int64List.fromList(vList0);
      final bd = int64ListV1.buffer.asUint8List();
      log
        ..debug('int64ListV1 : $int64ListV1')
        ..debug('SL.toBytes(int64ListV1) ; ${Int64.toBytes(int64ListV1)}');
      expect(Int64.toBytes(int64ListV1), equals(bd));
    }
    const int64Max = [kInt64Max];
    final vList1 = Int64List.fromList(int64Max);
    final uaInt8List = vList1.buffer.asUint8List();
    expect(Int64.toBytes(int64Max), uaInt8List);
  });

  test('Int64Base toByteData good values', () {
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final vList0 = rng.int64List(1, 1);
      final bd0 = vList0.buffer.asByteData();
      final lBd0 = Int64.toByteData(vList0);
      log.debug('lBd0: ${lBd0.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd0.buffer == bd0.buffer, true);

      final lBd1 = Int64.toByteData(vList0, check: false);
      log.debug('lBd3: ${lBd1.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd1.buffer == bd0.buffer, true);
    }

    const int64Max = [kInt64Max];
    final vList1 = Int64List.fromList(int64Max);
    final bd1 = vList1.buffer.asByteData();
    final lBd2 = Int64.toByteData(vList1);
    log.debug('bd: ${bd1.buffer.asUint8List()}, '
        'lBd2: ${lBd2.buffer.asUint8List()}');
    expect(lBd2.buffer.asUint8List(), equals(bd1.buffer.asUint8List()));
    expect(lBd2.buffer == bd1.buffer, true);
  });

  test('Int64Base toByteData bad values', () {
    for (var i = 0; i < 10; i++) {
      global.throwOnError = false;
      final vList0 = rng.int64List(1, 1);
      final bd0 = vList0.buffer.asByteData();
      final lBd1 = Int64.toByteData(vList0, asView: false);
      log.debug('lBd1: ${lBd1.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd1.buffer == bd0.buffer, false);

      final lBd2 = Int64.toByteData(vList0, asView: false, check: false);
      log.debug('lBd2: ${lBd2.buffer.asUint8List()}, '
          'bd0: ${bd0.buffer.asUint8List()}');
      expect(lBd2.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
      expect(lBd2.buffer == bd0.buffer, false);
    }
  });

  test('Int64Base fromBase64', () {
    for (var i = 0; i < 10; i++) {
      final intList0 = rng.int64List(0, i);
      final vList0 = Int64List.fromList(intList0);
      final uInt8List0 = vList0.buffer.asUint8List();
      final base64 = cvt.base64.encode(uInt8List0);
      log.debug('SL.base64: "$base64"');

      final slList = Int64.fromBase64(base64);
      log.debug('  SL.decode: $slList');
      expect(slList, equals(intList0));
      expect(slList, equals(vList0));
    }
  });

  test('Int64Base toBase64', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.int64List(0, i);
      final int64ListV1 = Int64List.fromList(vList0);
      final bd = int64ListV1.buffer.asUint8List();
      final base64 = cvt.base64.encode(bd);
      final s = Int64.toBase64(vList0);
      expect(s, equals(base64));
    }
  });

  test('Int64Base toBase64', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.int64List(1, 1);
      final int64ListV1 = Int64List.fromList(vList0);
      final bd = int64ListV1.buffer.asUint8List();
      final s = cvt.base64.encode(bd);
      expect(Int64.toBase64(vList0), equals(s));
    }
  });

  test('Int64Base encodeDecodeJsonVF', () {
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.int64List(0, i);
      final int64ListV1 = Int64List.fromList(vList0);
      final bd = int64ListV1.buffer.asUint8List();

      // Encode
      final base64 = cvt.base64.encode(bd);
      log.debug('SL.base64: "$base64"');
      final s = Int64.toBase64(vList0);
      log.debug('  SL.json: "$s"');
      expect(s, equals(base64));

      // Decode
      final e0 = Int64.fromBase64(base64);
      log.debug('SL.base64: $e0');
      final e1 = Int64.fromBase64(s);
      log.debug('  SL.json: $e1');
      expect(e0, equals(vList0));
      expect(e0, equals(int64ListV1));
      expect(e0, equals(e1));
    }
  });

  test('Int64Base fromByteData', () {
    for (var i = 0; i < 10; i++) {
      final int64list0 = rng.int64List(1, 1);
      final int64ListV1 = Int64List.fromList(int64list0);
      final byteData = int64ListV1.buffer.asByteData();
      log
        ..debug('int64list0 : $int64list0')
        ..debug('Int64.fromByteData(byteData): '
            '${Int64.fromByteData(byteData)}');
      expect(Int64.fromByteData(byteData), equals(int64list0));
    }
  });

  test('Int64 fromValueField', () {
    for (var i = 1; i <= 10; i++) {
      final vList0 = rng.int64List(1, i);
      final int64ListV1 = Int64List.fromList(vList0);
      final fvf0 = Int64.fromValueField(int64ListV1);
      log.debug('fromValueField0: $fvf0');
      expect(fvf0, equals(int64ListV1));
      expect(fvf0 is Int64List, true);
      expect(fvf0 is List<int>, true);
      expect(fvf0.isEmpty, false);
      expect(fvf0 is Bytes, false);
    }

    final fvf1 = Int64.fromValueField(null);
    expect(fvf1, <Int64>[]);
    expect(fvf1 == kEmptyInt64List, true);
    expect(fvf1.isEmpty, true);
    expect(fvf1 is Int64List, true);

    final fvf2 = Int64.fromValueField(<int>[]);
    expect(fvf2, <Int64>[]);
    expect(fvf2.length == kEmptyIntList.length, true);
    expect(fvf2.isEmpty, true);

    final vList0 = rng.int64List(1, 1);
    final int64ListV1 = Int64List.fromList(vList0);
    final byte0 = Bytes.fromList(int64ListV1);
    final fvf3 = Int64.fromValueField(byte0);
    expect(fvf3, isNotNull);
    expect(fvf3 is Bytes, true);

    final uInt8list0 = int64ListV1.buffer.asUint8List();
    final fvf4 = Int16.fromValueField(uInt8list0);
    expect(fvf4, isNotNull);
    expect(fvf4 is Uint8List, true);

    global.throwOnError = false;
    final fvf5 = Int64.fromValueField(<String>['foo']);
    expect(fvf5, isNull);

    global.throwOnError = true;
    expect(() => Int64.fromValueField(<String>['foo']),
        throwsA(const TypeMatcher<InvalidValuesError>()));
  });

  test('Int64 toUint8List', () {
    global.throwOnError = false;
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.int64List(1, i);
      final unit8List0 = vList0.buffer.asUint8List();
      final toUnit8L0 = Int64.toUint8List(vList0);
      log.debug('toUnit8L0: $toUnit8L0');
      expect(toUnit8L0, equals(unit8List0));
    }

    final toUnit8L1 = Int64.toUint8List([]);
    expect(toUnit8L1, equals(kEmptyInt64List));

    final vList1 = rng.int64List(1, 1);
    final unit8List1 = vList1.buffer.asUint8List();
    final toUnit8L2 = Int64.toUint8List(vList1, asView: false);
    log.debug('toUnit8L2: $toUnit8L2');
    expect(toUnit8L2, equals(unit8List1));

    final vList2 = rng.int8List(1, 1);
    final unit8List2 = vList2.buffer.asUint8List();
    final toUnit8L3 = Int64.toUint8List(vList2);
    log.debug('toUnit8L3: $toUnit8L3');
    expect(toUnit8L3, isNot(unit8List2));
  });

  test('Int64Base getLength', () {
    for (var i = 8; i < 100; i += 8) {
      final vList = rng.int64List(i, i);
      final getLen0 = Int64.getLength(vList.length);
      final length = vList.length ~/ Int64.kSizeInBytes;
      expect(getLen0 == length, true);
    }
  });
}
