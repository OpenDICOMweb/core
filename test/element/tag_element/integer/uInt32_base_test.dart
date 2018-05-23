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

  test('Uint32Base fromList', () {
    for (var i = 0; i < 10; i++) {
      final uint32List0 = rng.uint32List(1, 1);
      expect(Uint32.fromList(uint32List0), uint32List0);
    }
    const uint32Min = const [kUint32Min];
    const uint32Max = const [kUint32Max];
    expect(Uint32.fromList(uint32Min), uint32Min);
    expect(Uint32.fromList(uint32Max), uint32Max);
  });

  test('Uint32Base fromBytes', () {
    for (var i = 0; i < 10; i++) {
      final uint32List0 = rng.uint32List(1, 1);
//        final uint32List1 = new Uint32List.fromList(uint32List0);
//        final bd = uint32List1.buffer.asUint8List();
      final bytes = new Bytes.typedDataView(uint32List0);
      log
        ..debug('uint32List1 : $uint32List0')
        ..debug('Uint32Base.fromBytes(bd) ; ${Uint32.fromBytes(bytes)}');
      expect(Uint32.fromBytes(bytes), equals(uint32List0));
    }
  });

  test('Uint32Base toBytes', () {
    global.throwOnError = false;
    for (var i = 0; i < 10; i++) {
      final uint32List0 = rng.uint32List(1, 1);
//        final uint32List1 = new Uint32List.fromList(uint32List0);
//        final bd = uint32List1.buffer.asUint8List();
      final bytes = new Bytes.typedDataView(uint32List0);
      log
        ..debug('uint32List0 : $uint32List0')
        ..debug('Uint32.toBytes(uint32List0): '
            '${Uint32.toBytes(uint32List0)}');
      expect(Uint32.toBytes(uint32List0), equals(bytes));
    }

    const uint32Max = const [kUint32Max];
    final uint32List1 = new Uint32List.fromList(uint32Max);
    final uint32List = uint32List1.buffer.asUint8List();
    expect(Uint32.toBytes(uint32Max), uint32List);

    const uint64Max = const [kUint64Max];
    expect(Uint32.toBytes(uint64Max), isNull);

    global.throwOnError = true;
    expect(() => Uint32.toBytes(uint64Max),
        throwsA(const isInstanceOf<InvalidValuesError>()));
  });

  test('Uint32Base fromBase64', () {
    for (var i = 0; i < 10; i++) {
      final uint32List0 = rng.uint32List(1, 1);
//        final uint32List1 = new Uint32List.fromList(uint32List0);
//        final bd = uint32List1.buffer.asUint8List();
      final bytes = new Bytes.typedDataView(uint32List0);
      final s = cvt.base64.encode(bytes);
      expect(Uint32.fromBase64(s), equals(uint32List0));
    }
  });

/*
    test('Uint32Base toBase64', () {
      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final uint32List0 = rng.uint32List(1, 1);
//        final uint32List1 = new Uint32List.fromList(uint32List0);
//        final bd = uint32List1.buffer.asUint8List();
//        final s = cvt.base64.encode(bd);
        final bytes = new Bytes.typedDataView(uint32List0);
//        expect(Uint32.toBase64(uint32List0), equals(s));
      }
    });
*/

  test('Uint32Base fromBytes', () {
    for (var i = 0; i < 10; i++) {
      final uint32List0 = rng.uint32List(1, 1);
//        final uint32List1 = new Uint32List.fromList(uint32List0);
//        final bd = uint32List1.buffer.asUint8List();
      final bytes = new Bytes.typedDataView(uint32List0);
      log
        ..debug('uint32List0 : $uint32List0')
        ..debug('Uint32Base.fromBytes(bd) ; ${Uint32.fromBytes(bytes)}');
      expect(Uint32.fromBytes(bytes), equals(uint32List0));
    }
  });

  test('Uint32Base fromByteData', () {
    for (var i = 0; i < 10; i++) {
      final uint32List0 = rng.uint32List(1, 1);
//        final uint32List1 = new Uint32List.fromList(uint32List0);
//        final byteData = uint32List1.buffer.asByteData();
      final bytes = new Bytes.typedDataView(uint32List0);
      final bd = bytes.asByteData();
      log
        ..debug('uint32List0 : $uint32List0')
        ..debug('Uint32Base.fromByteData(byteData): '
            '${Uint32.fromByteData(bd)}');
      expect(Uint32.fromByteData(bd), equals(uint32List0));
    }
  });
}
