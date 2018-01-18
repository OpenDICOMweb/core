// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

bool testElementCopy(Element e0) {
  final e1 = e0.copy;

  log.debug('e0: $e0, e1: $e1');
  if (e0 == e1) return true;
  return false;
}

bool testElementUpdate(Element e0, List values) {
  final e2 = e0.update(values);
  log.debug('e0: ${e0.info}, e2: ${e2.info}');
  if (e2.values == values) return true;
  return false;
}

void main() {
  Server.initialize(name: 'String/utility.dart', level: Level.info);
  final rng = new RNG(1);

  test('bytesToAttributeTags random', () {
    for (var i = 0; i < 10; i++) {
      final uInt64List0 = rng.uint64List(1, 1);
      final uInt64ListV0 = new Uint64List.fromList(uInt64List0);
      final uInt8ListV0 = uInt64ListV0.buffer.asUint8List();
      final bta0 = bytesToAttributeTags(uInt8ListV0);
      log.debug('bta0: $bta0');
      expect(bta0, isNotNull);

      final uInt32List0 = rng.uint32List(1, 1);
      final uInt32ListV0 = new Uint32List.fromList(uInt32List0);
      final uInt8ListV1 = uInt32ListV0.buffer.asUint8List();
      final bta1 = bytesToAttributeTags(uInt8ListV1);
      log.debug('bta1: $bta1');
      expect(bta1, isNotNull);

      final uInt16List0 = rng.uint16List(1, 1);
      final uInt16ListV0 = new Uint32List.fromList(uInt16List0);
      final uInt8ListV2 = uInt16ListV0.buffer.asUint8List();
      final bta2 = bytesToAttributeTags(uInt8ListV2);
      log.debug('bta2: $bta2');
      expect(bta2, isNotNull);

      final uInt8List0 = rng.uint8List(1, 1);
      final uInt8ListV3 = new Uint8List.fromList(uInt8List0);
      final bta3 = bytesToAttributeTags(uInt8ListV3);
      log.debug('bta3: $bta3');
      expect(bta3, isNull);
    }
  });

  test('bytesToAttributeTags', () {
    const uInt64Max = const [kUint64Max];
    final uInt64ListV0 = new Uint64List.fromList(uInt64Max);
    final uInt8ListV0 = uInt64ListV0.buffer.asUint8List();
    final bta0 = bytesToAttributeTags(uInt8ListV0);
    log.debug('bta0: $bta0');
    expect(bta0, isNotNull);

    const uInt32Max = const [kUint32Max];
    final uInt32ListV1 = new Uint32List.fromList(uInt32Max);
    final uInt8ListV11 = uInt32ListV1.buffer.asUint8List();
    final bta1 = bytesToAttributeTags(uInt8ListV11);
    log.debug('bta1: $bta1');
    expect(bta1, isNotNull);

    const uInt16Max = const [kUint16Max];
    final uInt16ListV0 = new Uint32List.fromList(uInt16Max);
    final uInt8ListV2 = uInt16ListV0.buffer.asUint8List();
    final bta2 = bytesToAttributeTags(uInt8ListV2);
    log.debug('bta2: $bta2');
    expect(bta2, isNotNull);

    final uIint8ListV2 = new Uint8List.fromList([kUint8Max]);
    final bta3 = bytesToAttributeTags(uIint8ListV2);
    log.debug('bta3: $bta3');
    expect(bta3, isNull);
  });

  test('bytesEqual random', () {
    for (var i = 0; i < 10; i++) {
      final uInt64List0 = rng.uint64List(1, 1);
      final uInt64ListV0 = new Uint64List.fromList(uInt64List0);
      final uInt8ListV0 = uInt64ListV0.buffer.asUint8List();

      final uInt64ListV1 = new Uint64List.fromList(uInt64List0);
      final uInt8ListV1 = uInt64ListV1.buffer.asUint8List();

      final be0 = bytesEqual(uInt8ListV0, uInt8ListV1);
      log.debug('be0: $be0');
      expect(be0, true);

      final uInt32List0 = rng.uint32List(1, 1);
      final uInt32ListV0 = new Uint32List.fromList(uInt32List0);
      final uInt8ListV2 = uInt32ListV0.buffer.asUint8List();

      final uInt32ListV1 = new Uint32List.fromList(uInt32List0);
      final uInt8ListV3 = uInt32ListV1.buffer.asUint8List();

      final be1 = bytesEqual(uInt8ListV2, uInt8ListV3);
      log.debug('be1: $be1');
      expect(be1, true);

      final be2 = bytesEqual(uInt8ListV0, uInt8ListV3);
      log.debug('be2: $be2');
      expect(be2, false);

      final be3 = bytesEqual(uInt8ListV0, uInt8ListV2);
      log.debug('be3: $be3');
      expect(be3, false);

      final uInt16List0 = rng.uint16List(1, 1);
      final uInt16ListV0 = new Uint16List.fromList(uInt16List0);
      final uInt8ListV4 = uInt16ListV0.buffer.asUint8List();

      final uInt16ListV1 = new Uint16List.fromList(uInt32List0);
      final uInt8ListV5 = uInt16ListV1.buffer.asUint8List();

      final be4 = bytesEqual(uInt8ListV4, uInt8ListV5);
      log.debug('be4: $be4');
      expect(be4, false);

      final be5 = bytesEqual(uInt8ListV4, uInt8ListV0);
      log.debug('be5: $be5');
      expect(be5, false);

      final be6 = bytesEqual(uInt8ListV4, uInt8ListV1);
      log.debug('be6: $be6');
      expect(be6, false);

      final be7 = bytesEqual(uInt8ListV4, uInt8ListV2);
      log.debug('be7: $be7');
      expect(be7, false);

      final uInt8List0 = rng.uint8List(1, 1);
      final uInt8ListV6 = new Uint8List.fromList(uInt8List0);

      final be8 = bytesEqual(uInt8ListV0, uInt8ListV6);
      log.debug('be8: $be8');
      expect(be8, false);
    }
  });

  test('bytesEqual', () {
    final uInt8List0 = new Uint8List.fromList([10, 20]);
    final uInt8ListV0 = uInt8List0.buffer.asUint8List();

    final uInt8List1 = new Uint8List.fromList([10, 20]);
    final uInt8ListV1 = uInt8List1.buffer.asUint8List();

    final uInt8List2 = new Uint8List.fromList([10, 20, 89]);
    final uInt8ListV2 = uInt8List2.buffer.asUint8List();

    final be0 = bytesEqual(uInt8ListV0, uInt8ListV1);
    log.debug('be0: $be0');
    expect(be0, true);

    final be1 = bytesEqual(uInt8ListV0, uInt8ListV2);
    log.debug('be1: $be1');
    expect(be1, false);
  });
}
