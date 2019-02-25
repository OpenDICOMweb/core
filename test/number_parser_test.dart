//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'number_parse_test.dart', level: Level.info);

  final rng = RNG();

  test('parseUint', () {
    final list0 = rng.uint8List(1, 10);
    for (final v in list0) {
      final pu0 = parseUint(v.toString());
      log.debug('v: $v pu0: $pu0');
      expect(pu0 == v, true);
      expect(pu0, equals(v));
    }

    final list1 = rng.uint16List(1, 10);
    for (final a in list1) {
      final pu0 = parseUint(a.toString());
      log.debug('pu0: $pu0');
      expect(pu0 == a, true);
      expect(pu0, equals(a));
    }

    final badList = ['foo', '47.11', 'ba#2%_90b'];
    for (final a in badList) {
      global.throwOnError = false;
      final pu1 = parseUint(a);
      log.debug('pu1: $pu1');
      expect(pu1, isNull);

      global.throwOnError = true;
      expect(() => parseUint(a), throwsA(const TypeMatcher<FormatException>()));
    }
  });

  test('parseInt', () {
    final list0 = rng.int8List(1, 10);
    for (final v in list0) {
      final pI0 = parseInt(v.toString());
      log.debug('v: $v pI0: $pI0');
      expect(pI0, equals(v));
    }

    final list1 = rng.int16List(1, 10);
    for (final a in list1) {
      final pI0 = parseInt(a.toString());
      log.debug('pI0: $pI0');
      expect(pI0, equals(a));
    }

    final badList = ['foo', '47.11', 'ba#2%_90b'];
    for (final a in badList) {
      global.throwOnError = false;
      final pu1 = parseInt(a);
      log.debug('pu1: $pu1');
      expect(pu1, isNull);
    }
    expect(() => parseInt(''), throwsA(const TypeMatcher<FormatException>()));
  });

  test('parseUnitRadix', () {
    final list0 = rng.uint8List(1, 10);
    for (final a in list0) {
      final pur0 = parseRadix(a.toString());
      log.debug('pur0: $pur0');
      expect(pur0, isNotNull);
    }
  });

  test('isValidUintString', () {
    final list0 = rng.uint8List(1, 10);
    for (final a in list0) {
      final validUS0 = isValidUintString(a.toString());
      log.debug('validUS0: $validUS0');
      expect(validUS0, true);
    }

    final list1 = rng.uint16List(1, 10);
    for (final a in list1) {
      final validUS1 = isValidUintString(a.toString());
      log.debug('validUS1: $validUS1');
      expect(validUS1, true);
    }

    global.throwOnError = false;
    final validUS2 = isValidUintString('foo');
    log.debug('validUS2: $validUS2');
    expect(validUS2, false);

    global.throwOnError = true;
    expect(() => isValidUintString('foo'),
        throwsA(const TypeMatcher<FormatException>()));
  });

  test('isValidIntString', () {
    final list0 = rng.int8List(1, 10);
    for (final a in list0) {
      final pI0 = isValidIntString(a.toString());
      log.debug('pI0: $pI0');
      expect(pI0, true);
    }

    final list1 = rng.int16List(1, 10);
    for (final a in list1) {
      final pI0 = isValidIntString(a.toString());
      log.debug('pI0: $pI0');
      expect(pI0, true);
    }
    expect(() => isValidIntString(''),
        throwsA(const TypeMatcher<FormatException>()));
  });

  test('tryParseRadix', () {
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.uint8List(1, i);
      for (final s in vList0) {
        final radix = tryParseRadix(s.toString());
        log.debug('tryParseRadix:$radix');
        expect(radix, isNotNull);
      }
    }
    const vList1 = '125';
    final radix0 = tryParseRadix(vList1);
    expect(radix0 == 293, true);
  });

  test('parseBinary', () {
    final vList0 = ['01', '10', '100', '001', '1000', '0101'];
    for (final s in vList0) {
      final binary0 = parseBinary(s);
      log.debug('parseBinary: $binary0');
      expect(binary0, isNotNull);
    }

    final vList1 = ['23', '12', '1234'];
    for (final s in vList1) {
      global.throwOnError = false;
      final binary1 = parseBinary(s);
      log.debug('parseBinary: $binary1');
      expect(binary1, isNull);

      global.throwOnError = true;
      expect(
          () => parseBinary(s), throwsA(const TypeMatcher<FormatException>()));
    }
  });

  test('tryParseBinary', () {
    final vList0 = ['01', '10', '100', '001', '1000', '0101'];
    for (final s in vList0) {
      final binary0 = tryParseBinary(s);
      log.debug('parseBinary: $binary0');
      expect(binary0, isNotNull);
    }
    final vList1 = ['23', '12', '1234'];
    for (final s in vList1) {
      global.throwOnError = false;
      final binary1 = tryParseBinary(s);
      log.debug('parseBinary: $binary1');
      expect(binary1, isNull);

      global.throwOnError = true;
      expect(() => tryParseBinary(s),
          throwsA(const TypeMatcher<FormatException>()));
    }
  });

  test('parseHex', () {
    final vList0 = [
      '01A',
      '10B',
      '100AB',
      '001C',
      '1000AB',
      'AB',
      '0123456789ABCDEF'
    ];
    for (final s in vList0) {
      final hexaDecimal = parseHex(s);
      log.debug('parseHex: $hexaDecimal');
      expect(hexaDecimal, isNotNull);
    }
  });

  test('tryParseHex', () {
    final vList0 = [
      '01A',
      '10B',
      '100AB',
      '001C',
      '1000AB',
      'AB',
      '0123456789ABCDEF'
    ];
    for (final s in vList0) {
      final hexaDecimal = tryParseHex(s);
      log.debug('tryParseHex: $hexaDecimal');
      expect(hexaDecimal, isNotNull);
    }
  });

  test('parseFloat', () {
    final vList0 = ['12', '34.33', '.34', '98.098'];
    for (final s in vList0) {
      final float = parseFloat(s);
      log.debug('parseFloat: $float');
      expect(float, equals(double.parse(s)));
    }

    final vList1 = ['12a', '3a4.33', 'foo', '98.0@!8'];
    for (final s in vList1) {
      final float = parseFloat(s);
      log.debug('parseFloat: $float');
      expect(float, isNull);
    }

    expect(() => parseFloat(''), throwsA(const TypeMatcher<FormatException>()));

    expect(() => parseFloat(vList0[0], 5),
        throwsA(const TypeMatcher<FormatException>()));
  });

  test('parseFraction', () {
    final vList0 = ['.9', '.303', '.34', '.980', '.980005'];
    for (final s in vList0) {
      final fraction = parseFraction(s);
      log.debug('parseFraction: $fraction');
      expect(fraction.toString(), equals(s.substring(1)));
    }
  });

  test('parseBase2 good values', () {
    final vList0 = ['10', '1', '101', '111', '1001', '1010', '1111'];
    for (final s in vList0) {
      final parse0 = parseBase2(s, 0, null, s.length, s, null);
      final radix = parse0.toRadixString(10);
      log..debug('parse0: $parse0')..debug('parse0.toRadixString(10): $radix');
      expect(parse0.toString(), equals(radix));
      expect(s, equals(parse0.toRadixString(2)));
    }
  });

  test('parseBase2 bad values', () {
    final vList = ['23', '12', '1234'];
    for (final s in vList) {
      global.throwOnError = false;
      final parse0 = parseBase2(s, 0, null, s.length, s, null);
      log.debug('parse0: $parse0');
      expect(parse0, isNull);

      global.throwOnError = true;
      expect(() => parseBase2(s, 0, null, s.length, s, null),
          throwsA(const TypeMatcher<FormatException>()));
    }
  });

  test('parseBase8 good values', () {
    final vList0 = ['10', '1', '101', '111', '1001', '1010', '44', '37'];
    for (final s in vList0) {
      final parse0 = parseBase8(s, 0, null, s.length, s, null);
      final radix = parse0.toRadixString(10);
      log..debug('parse0: $parse0')..debug('parse0.toRadixString(10): $radix');
      expect(parse0.toString(), equals(radix));
    }
  });

  test('parseBase8 bad values', () {
    final vList0 = ['89', '79', '108', '1082'];
    for (final s in vList0) {
      global.throwOnError = false;
      final parse0 = parseBase8(s, 0, null, s.length, s, null);
      log.debug('parse0: $parse0');
      expect(parse0, isNull);

      global.throwOnError = true;
      expect(() => parseBase8(s, 0, null, s.length, s, null),
          throwsA(const TypeMatcher<FormatException>()));
    }
  });

  test('parseBase10 good values', () {
    final vList0 = ['10', '111', '1001', '1010', '44', '37', '3883'];
    for (final s in vList0) {
      final parse0 = parseBase10(s, 0, null, s.length, s, null);
      final radix = parse0.toRadixString(10);
      log..debug('parse0: $parse0')..debug('parse0.toRadixString(10): $radix');
      expect(parse0.toString(), equals(radix));
    }
  });

  test('parseBase10 bad values', () {
    final vList0 = ['-89', '-79', '-55', '-1082'];
    for (final s in vList0) {
      global.throwOnError = false;
      final parse0 = parseBase10(s, 0, null, s.length, s, null);
      log.debug('parse0: $parse0');
      expect(parse0, isNull);

      global.throwOnError = true;
      expect(() => parseBase10(s, 0, null, s.length, s, null),
          throwsA(const TypeMatcher<FormatException>()));
    }
  });

  test('parseBase16 good values', () {
    final vList0 = ['10', '111', '100A', '1010', '44', '37C', '3883', 'A', 'B'];
    for (final s in vList0) {
      final parse0 = parseBase16(s, 0, null, s.length, s, null);
      final radix = parse0.toRadixString(10);
      log..debug('parse0: $parse0')..debug('parse0.toRadixString(10): $radix');
      expect(parse0.toString(), equals(radix));
    }
  });
}
