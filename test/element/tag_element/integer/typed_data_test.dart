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
  Server.initialize(name: 'element/typed_data_utils_test', level: Level.debug);
  final rng = new RNG(1);

  test('Uint32Base.fromList', () {
    //  global.level = Level.info;;
    for (var i = 1; i <= 10; i++) {
      final uInt32List0 = rng.uint32List(1, i);
      final s0 = Uint32.fromList(uInt32List0);
      log.debug('s0 : $s0, uInt32List0 : $uInt32List0');
      expect(s0, equals(uInt32List0));
    }
    const uInt32Min = const [kUint32Min];
    const uInt32Max = const [kUint32Max];
    const uInt64Max = const [kUint64Max];

    final s1 = Uint32.fromList(uInt32Min);
    expect(s1, equals(uInt32Min));

    final s2 = Uint32.fromList(uInt32Max);
    expect(s2, equals(uInt32Max));

    final s3 = Uint32.fromList(uInt64Max, check: false);
    expect(s3 is Uint32List, true);

    final s4 = Uint32.fromList(uInt64Max, check: true);
    expect(s4 is Uint32List, false);
  });

  test('Uint32Base.toBytes', () {
    //  global.level = Level.info;;
    for (var i = 1; i <= 10; i++) {
      final uInt32List0 = rng.uint32List(1, i);
      log.debug('uInt32List0 : $uInt32List0');
      final s0 = Uint32.toUint8List(uInt32List0);
      //expect(s0, equals(s0.buffer.asUint8List()));
      expect(s0 is Uint8List, true);
      final result0 = s0.buffer.asUint16List();
      log.debug('s0: $s0, result0: $result0');
      final uInt32List1 = Uint32.fromUint8List(s0);
      expect(uInt32List1, equals(uInt32List0));

      final s1 = Uint32.toBytes(uInt32List0);
      //expect(s0, equals(s0.buffer.asUint8List()));
      expect(s0 is Uint8List, true);
      final result1 = s0.buffer.asUint16List();
      log.debug('s0: $s0, result0: $result1');
      final uInt32List2 = Uint32.fromBytes(s1);
      expect(uInt32List2, equals(uInt32List0));
    }
  });

  test('Uint32Base.fromBytes', () {
    //  global.level = Level.info;;
    for (var i = 1; i <= 10; i++) {
      final uInt32List0 = rng.uint32List(1, i);
      final uInt32ListV1 = new Uint32List.fromList(uInt32List0);
      final bytes = uInt32ListV1.buffer.asUint8List();
      final s0 = Uint32.fromUint8List(bytes);
      log.debug('s0 : $s0');
      expect(s0, equals(s0.buffer.asUint32List()));
      expect(s0 is Uint32List, true);
    }
  });

  test('AT.fromByteData', () {
    //  global.level = Level.info;;
    final uInt32List0 = rng.uint32List(1, 1);
    final byteData = uInt32List0.buffer.asByteData();
    final u32 = Uint32.fromByteData(byteData);
    log.debug('s0 : $u32, $byteData');
    expect(u32 is Uint32List, true);
  });

  test('AT.toByteData', () {
    //  global.level = Level.info;;
    for (var i = 1; i <= 10; i++) {
      final uInt32List0 = rng.uint32List(1, i);
      final s0 = Uint32.toByteData(uInt32List0);
      log.debug(s0);
      expect(s0 is ByteData, true);
    }
  });

  test('AT.fromBase64', () {
    //  global.level = Level.info;;
    for (var i = 1; i <= 10; i++) {
      final uInt32List0 = rng.uint32List(1, i);
      final uInt32ListV1 = new Uint32List.fromList(uInt32List0);
      final uInt8List = uInt32ListV1.buffer.asUint8List();
      final s = cvt.base64.encode(uInt8List);
      final s0 = Uint32.fromBase64(s);
      log.debug('s0 : $s0, s : $s');
      expect(s0 is Uint32List, true);
    }
  });
  test('AT.toBase64', () {
    //  global.level = Level.info;;
    for (var i = 1; i <= 10; i++) {
      final uInt32List0 = rng.uint32List(1, i);
      final uInt32ListV1 = new Uint32List.fromList(uInt32List0);
      final bd = uInt32ListV1.buffer.asUint8List();
      final base64 = cvt.base64.encode(bd);
      final s0 = Uint32.toBase64(uInt32List0);
      log.debug('s0 : $s0, base64 : $base64');
      //expect(s0, equals(base64));
      expect(s0 is String, true);
    }
  });
}
