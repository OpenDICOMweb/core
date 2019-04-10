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

bool testElementCopy(Element e0) {
  final e1 = e0.copy;

  log.debug('e0: $e0, e1: $e1');
  if (e0 == e1) return true;
  return false;
}

bool testElementUpdate(Element e0, List values) {
  final e2 = e0.update(values);
  log.debug('e0: ${e0.info}\n     e2: ${e2.info}');
  return e2.values == values;
}

void main() {
  Server.initialize(name: 'String/utility.dart', level: Level.info);
  final rng = RNG(1);

  test('bytesToAttributeTags random', () {
    for (var i = 0; i < 10; i++) {
      final uInt64List0 = rng.uint64List(1, 1);
      final uInt64ListV0 = Uint64List.fromList(uInt64List0);
      final uInt8ListV0 = uInt64ListV0.buffer.asUint8List();
      final bta0 = bytesToAttributeTags(uInt8ListV0);
      log.debug('bta0: $bta0');
      expect(bta0, isNotNull);

      final uInt32List0 = rng.uint32List(1, 1);
      final uInt32ListV0 = Uint32List.fromList(uInt32List0);
      final uInt8ListV1 = uInt32ListV0.buffer.asUint8List();
      final bta1 = bytesToAttributeTags(uInt8ListV1);
      log.debug('bta1: $bta1');
      expect(bta1, isNotNull);

      final uInt16List0 = rng.uint16List(1, 1);
      final uInt16ListV0 = Uint32List.fromList(uInt16List0);
      final uInt8ListV2 = uInt16ListV0.buffer.asUint8List();
      final bta2 = bytesToAttributeTags(uInt8ListV2);
      log.debug('bta2: $bta2');
      expect(bta2, isNotNull);

      final uInt8List0 = rng.uint8List(1, 1);
      final uInt8ListV3 = Uint8List.fromList(uInt8List0);
      final bta3 = bytesToAttributeTags(uInt8ListV3);
      log.debug('bta3: $bta3');
      expect(bta3, isNull);
    }
  });

  test('bytesToAttributeTags', () {
    const uInt64Max = [kUint64Max];
    final uInt64ListV0 = Uint64List.fromList(uInt64Max);
    final uInt8ListV0 = uInt64ListV0.buffer.asUint8List();
    final bta0 = bytesToAttributeTags(uInt8ListV0);
    log.debug('bta0: $bta0');
    expect(bta0, isNotNull);

    const uInt32Max = [kUint32Max];
    final uInt32ListV1 = Uint32List.fromList(uInt32Max);
    final uInt8ListV11 = uInt32ListV1.buffer.asUint8List();
    final bta1 = bytesToAttributeTags(uInt8ListV11);
    log.debug('bta1: $bta1');
    expect(bta1, isNotNull);

    const uInt16Max = [kUint16Max];
    final uInt16ListV0 = Uint32List.fromList(uInt16Max);
    final uInt8ListV2 = uInt16ListV0.buffer.asUint8List();
    final bta2 = bytesToAttributeTags(uInt8ListV2);
    log.debug('bta2: $bta2');
    expect(bta2, isNotNull);

    final uIint8ListV2 = Uint8List.fromList([kUint8Max]);
    final bta3 = bytesToAttributeTags(uIint8ListV2);
    log.debug('bta3: $bta3');
    expect(bta3, isNull);
  });

  test('Uint8.equal random', () {
    for (var i = 0; i < 10; i++) {
      final uInt64List0 = rng.uint64List(1, 1);
      final uInt64ListV0 = Uint64List.fromList(uInt64List0);
      final uInt8ListV0 = uInt64ListV0.buffer.asUint8List();

      final uInt64ListV1 = Uint64List.fromList(uInt64List0);
      final uInt8ListV1 = uInt64ListV1.buffer.asUint8List();

      final be0 = Uint8.equal(uInt8ListV0, uInt8ListV1);
      log.debug('be0: $be0');
      expect(be0, true);

      final uInt32List0 = rng.uint32List(1, 1);
      final uInt32ListV0 = Uint32List.fromList(uInt32List0);
      final uInt8ListV2 = uInt32ListV0.buffer.asUint8List();

      final uInt32ListV1 = Uint32List.fromList(uInt32List0);
      final uInt8ListV3 = uInt32ListV1.buffer.asUint8List();

      final be1 = Uint8.equal(uInt8ListV2, uInt8ListV3);
      log.debug('be1: $be1');
      expect(be1, true);

      final be2 = Uint8.equal(uInt8ListV0, uInt8ListV3);
      log.debug('be2: $be2');
      expect(be2, false);

      final be3 = Uint8.equal(uInt8ListV0, uInt8ListV2);
      log.debug('be3: $be3');
      expect(be3, false);

      final uInt16List0 = rng.uint16List(1, 1);
      final uInt16ListV0 = Uint16List.fromList(uInt16List0);
      final uInt8ListV4 = uInt16ListV0.buffer.asUint8List();

      final uInt16ListV1 = Uint16List.fromList(uInt32List0);
      final uInt8ListV5 = uInt16ListV1.buffer.asUint8List();

      final be4 = Uint8.equal(uInt8ListV4, uInt8ListV5);
      log.debug('be4: $be4');
      expect(be4, false);

      final be5 = Uint8.equal(uInt8ListV4, uInt8ListV0);
      log.debug('be5: $be5');
      expect(be5, false);

      final be6 = Uint8.equal(uInt8ListV4, uInt8ListV1);
      log.debug('be6: $be6');
      expect(be6, false);

      final be7 = Uint8.equal(uInt8ListV4, uInt8ListV2);
      log.debug('be7: $be7');
      expect(be7, false);

      final uInt8List0 = rng.uint8List(1, 1);
      final uInt8ListV6 = Uint8List.fromList(uInt8List0);

      final be8 = Uint8.equal(uInt8ListV0, uInt8ListV6);
      log.debug('be8: $be8');
      expect(be8, false);
    }
  });

  test('Uint8.equal', () {
    final uInt8List0 = Uint8List.fromList([10, 20]);
    final uInt8ListV0 = uInt8List0.buffer.asUint8List();

    final uInt8List1 = Uint8List.fromList([10, 20]);
    final uInt8ListV1 = uInt8List1.buffer.asUint8List();

    final uInt8List2 = Uint8List.fromList([10, 20, 89]);
    final uInt8ListV2 = uInt8List2.buffer.asUint8List();

    final be0 = Uint8.equal(uInt8ListV0, uInt8ListV1);
    log.debug('be0: $be0');
    expect(be0, true);

    final be1 = Uint8.equal(uInt8ListV0, uInt8ListV2);
    log.debug('be1: $be1');
    expect(be1, false);
  });

  test('parse_integer', () {
    const goodIntegerStrings = <String>[
      '+8',
      ' +8',
      '+8 ',
      ' +8 ',
      '-8',
      ' -8',
      '-8 ',
      ' -8 ',
      '-6',
      '560',
      '0',
      '-67',
    ];

    for (final s in goodIntegerStrings) {
      final n = int.parse(s);
      log.debug('s: "$s" n: $n');
      expect(n, isNotNull);
    }
  });

  test('parse_decimal', () {
    const goodDecimalStrings = <String>[
      '567',
      ' 567',
      '567 ',
      ' 567 ',
      '-6.60',
      '-6.60 ',
      ' -6.60 ',
      ' -6.60 ',
      '+6.60',
      '+6.60 ',
      ' +6.60 ',
      ' +6.60 ',
      '0.7591109678',
      '-6.1e-1',
      ' -6.1e-1',
      '-6.1e-1 ',
      ' -6.1e-1 ',
      '+6.1e+1',
      ' +6.1e+1',
      '+6.1e+1 ',
      ' +6.1e+1 ',
      '+1.5e-1',
      ' +1.5e-1',
      '+1.5e-1 ',
      ' +1.5e-1 '
    ];

    for (final s in goodDecimalStrings) {
      final n = double.parse(s);
      log.debug('s: "$s" n: $n');
      expect(s, isNotNull);
    }
  });
}
