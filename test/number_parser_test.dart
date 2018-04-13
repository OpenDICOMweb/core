// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'number_parse_test.dart', level: Level.debug);

  final rng = new RNG();

  test('parseUint', () {
    final list0 = rng.uint8List(1, 10);
    for (var v in list0) {
      final pu0 = parseUint(v.toString());
      log.debug('v: $v pu0: $pu0');
      expect(pu0 == v, true);
      expect(pu0, equals(v));
    }

    final list1 = rng.uint16List(1, 10);
    for (var a in list1) {
      final pu0 = parseUint(a.toString());
      log.debug('pu0: $pu0');
      expect(pu0 == a, true);
      expect(pu0, equals(a));
    }

    system.throwOnError = false;
    final pu1 = parseUint('foo');
    log.debug('pu1: $pu1');
    expect(pu1, isNull);
  });

  test('parseInt', () {
    system.level = Level.debug;
    final list0 = rng.int8List(1, 10);
    for (var v in list0) {
      final pI0 = parseInt(v.toString());
      log.debug('v: $v pI0: $pI0');
      expect(pI0, equals(v));
    }

    final list1 = rng.int16List(1, 10);
    for (var a in list1) {
      final pI0 = parseInt(a.toString());
      log.debug('pI0: $pI0');
      expect(pI0, equals(a));
    }
    expect(() => parseInt(''), throwsA(const isInstanceOf<FormatException>()));
  });

  test('parseUnitRadix', () {
    final list0 = rng.uint8List(1, 10);
    for (var a in list0) {
      final pur0 = parseRadix(a.toString());
      log.debug('pur0: $pur0');
      expect(pur0, isNotNull);
    }
  });

  test('isValidUintString', () {
    final list0 = rng.uint8List(1, 10);
    for (var a in list0) {
      final validUS0 = isValidUintString(a.toString());
      log.debug('validUS0: $validUS0');
      expect(validUS0, true);
    }

    final list1 = rng.uint16List(1, 10);
    for (var a in list1) {
      final validUS1 = isValidUintString(a.toString());
      log.debug('validUS1: $validUS1');
      expect(validUS1, true);
    }

    system.throwOnError = false;
    final validUS2 = isValidUintString('foo');
    log.debug('validUS2: $validUS2');
    expect(validUS2, false);
  });

  test('isValidIntString', () {
    final list0 = rng.int8List(1, 10);
    for (var a in list0) {
      final pI0 = isValidIntString(a.toString());
      log.debug('pI0: $pI0');
      expect(pI0, true);
    }

    final list1 = rng.int16List(1, 10);
    for (var a in list1) {
      final pI0 = isValidIntString(a.toString());
      log.debug('pI0: $pI0');
      expect(pI0, true);
    }
    expect(() => isValidIntString(''),
        throwsA(const isInstanceOf<FormatException>()));
  });
}
