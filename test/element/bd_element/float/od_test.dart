// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

import '../bd_test_utils.dart';

void main() {
  Server.initialize(name: 'element/float32_test', level: Level.info);
  final rng = new RNG(1);

  const float64LstCommon0 = const <double>[
    0.1,
    1.2,
    1.11,
    1.15,
    5.111,
    09.2345,
    23.6,
    45.356,
    98.99999,
    323.09,
    101.11111111,
    234543.90890000,
    1.00000000000007,
    -1.345,
    -11.000453,
  ];

  system.throwOnError = false;

  group('OD Tests', () {
    test('OD hasValidValues: good values', () {
      system.throwOnError = false;
      final bd = makeOD(kSelectorODValue, float64LstCommon0);
      final od0 = new ODevr(bd);
      expect(od0.hasValidValues, true);
    });

    test('OD hasValidValues random: good values', () {
//      system.level = Level.debug;
      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(1, 1);
        expect(float64List is Float64List, true);
        expect(float64List.length, 1);
        log.debug('float64List: $float64List');
        final bd = makeOD(kSelectorODValue, float64List);
        longEvrInfo(bd);
        final od0 = ODevr.make(bd, kODIndex);
        log.debug('od0: $od0');
        expect(od0.hasValidValues, true);

        log
          ..debug('od0: $od0, values: ${od0.values}')
          ..debug('od0: ${od0.info}')
          ..debug('float64List: $float64List')
          ..debug('        od0: ${od0.values}');
        expect(od0.values, equals(float64List));
      }
    });

    test('OD hasValidValues: bad values', () {
      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(3, 4);
        log.debug('$i: float64List: $float64List');
        final bd = makeOD(kDoubleFloatPixelData, float64List);
        final flbd = new ODevr(bd);
        final od0 = new FLtag(flbd.tag, flbd.values);
        expect(od0, isNull);
      }
    });
    test('OD [] as values', () {
      final bd = makeOD(kDoubleFloatPixelData, []);
      final od0 = new ODevr(bd);
      expect(od0.hasValidValues, true);
      expect(od0.values, equals(<double>[]));
    });

    // Can't create Evr/Ivr with null values
    // test('OD null as values', () {});

    test('OD hashCode and == random', () {
 //     system.level = Level.debug;
      system.throwOnError = false;
      final rng = new RNG(1);

      List<double> floatList0;
      List<double> floatList1;

      for (var i = 0; i < 10; i++) {
        floatList0 = rng.float64List(1, 1);
        var bd = makeOD(kDoubleFloatPixelData, floatList0);
        final od0 = new ODevr(bd);
        bd = makeOD(kDoubleFloatPixelData, floatList0);
        final od1 = new ODevr(bd);
        log
          ..debug('floatList0:$floatList0, od0.hash_code:${od0.hashCode}')
          ..debug('floatList0:$floatList0, od1.hash_code:${od1.hashCode}');
        expect(od0.hashCode == od1.hashCode, true);
        expect(od0 == od1, true);

        floatList1 = rng.float64List(1, 1);
        final bd1 = makeOD(kSelectorODValue, floatList1);
        final od2 = new ODevr(bd1);
        log.debug('floatList1:$floatList1 , od2.hash_code:${od2.hashCode}');
        expect(od0.hashCode == od2.hashCode, false);
        expect(od0 == od2, false);
      }
    });

    test('OD isValidValues', () {
      system.throwOnError = false;
      for (var i = 0; i <= float64LstCommon0.length - 1; i++) {
        final bd = makeOD(kSelectorODValue, <double>[float64LstCommon0[i]]);
        final of0 = new ODevr(bd);
        expect(
            OD.isValidValues(PTag.kDoubleFloatPixelData, of0.values),
            true);
      }
    });
  });
}
