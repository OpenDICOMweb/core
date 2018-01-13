// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

import '../bd_test_utils.dart';

//Urgent: why is this file so much shorter than fl_test.dart
void main() {
  Server.initialize(name: 'element/float32_test', level: Level.info);
  List<double> float32List;

  final listFloat32Common0 = const <double>[
    1.1,
    1.11,
    1.111,
    1.11111,
    1.1111111111111,
    1.000000003,
    123456789.123456789,
    -0.2,
    -11.11,
  ];

  group('OF Tests', () {
    system.throwOnError = false;

    final rng = new RNG(1);

    test('OF hasValidValues: good values', () {
      system.throwOnError = false;
      final bd = makeOF(kUValueData, listFloat32Common0);
      final of0 = new OFevr(bd);
      expect(of0.hasValidValues, true);
    });

    test('OF hasValidValues random', () {

      for (var i = 0; i < 10; i++) {
        float32List = rng.float32List(1, 10);
        expect(float32List is Float32List, true);
        log.debug('i: $i, float32List: $float32List');
        final bd = makeOF(kFirstOrderPhaseCorrectionAngle, float32List);
        final of0 = new OFevr(bd);
  //      log.debug('of:$of0');
        expect(of0[0], equals(float32List[0]));
        expect(of0.hasValidValues, true);
      }
    });

    test('OF hasValidValues random: good values', () {
      for (var i = 0; i < 100; i++) {
        float32List = rng.float32List(2, 10);
        log.debug('i: $i, float32List: $float32List');
        final bd = makeOF(kFirstOrderPhaseCorrectionAngle, float32List);
        final of0 = new OFevr(bd);
        expect(of0.hasValidValues, true);
      }
    });

    test('OF []', () {
      system.throwOnError = false;
      var bd = makeOF(kVectorGridData, []);
      final of0 = new OFevr(bd);
      expect(of0.hasValidValues, true);
      expect(of0.values, equals(<double>[]));

      bd = makeOF(kVectorGridData, []);
      final of1 = new OFevr(bd);
      expect(of1.hasValidValues, true);
      expect(of1.values.isEmpty, true);
    });

    test('OF hashCode and == random', () {
      List<double> floatList0;
      List<double> floatList1;
      List<double> floatList2;
      List<double> floatList3;

      log.debug('OF hashCode and ==');
      for (var i = 0; i < 10; i++) {
        floatList0 = rng.float32List(1, 1);
        final bd0 = makeOF(kVectorGridData, floatList0);
        final of0 = new OFevr(bd0);
        final of1 = new OFevr(bd0);
        log
          ..debug('floatList0:$floatList0 , of1.hash_code:${of1.hashCode}')
          ..debug('floatList0:$floatList0 , of1.hash_code:${of1.hashCode}');
        expect(of1.hashCode == of1.hashCode, true);
        expect(of1 == of1, true);

        floatList1 = rng.float32List(1, 1);
        final bd2 = makeOF(kPointCoordinatesData, floatList1);
        final of2 = new OFevr(bd2);
        log.debug('floatList1:$floatList1 , of2.hash_code:${of2.hashCode}');
        expect(of0.hashCode == of2.hashCode, false);
        expect(of0 == of2, false);

        floatList2 = rng.float32List(1, 2);
        final bd3 = makeOF(kUValueData, floatList2);
        final of3 = new OFevr(bd3);
        log.debug('floatList2:$floatList2 , of3.hash_code:${of3.hashCode}');
        expect(of0.hashCode == of3.hashCode, false);
        expect(of0 == of3, false);

        floatList3 = rng.float32List(2, 3);
        final bd4 = makeOF(kPointCoordinatesData, floatList3);
        final of4 = new OFevr(bd4);
        log.debug('floatList3:$floatList3 , of4.hash_code:${of4.hashCode}');
        expect(of1.hashCode == of4.hashCode, false);
        expect(of1 == of4, false);
      }
    });

    test('OF hashCode and ==', () {
      log.debug('OF hashCode and ==');

      final bd0 = makeOF(kVectorGridData, listFloat32Common0);
      final of0 = new OFevr(bd0);
      final of1 = new OFevr(bd0);
      log
        ..debug(
            'listFloat32Common0:$listFloat32Common0 , of1.hash_code:${of1.hashCode}')
        ..debug(
            'listFloat32Common0:$listFloat32Common0 , of1.hash_code:${of1.hashCode}');
      expect(of1.hashCode == of1.hashCode, true);
      expect(of1 == of1, true);

      final bd2 = makeOF(kPointCoordinatesData, listFloat32Common0);
      final of2 = new OFevr(bd2);
      log.debug(
          'listFloat32Common0:$listFloat32Common0 , of2.hash_code:${of2.hashCode}');
      expect(of0.hashCode == of2.hashCode, false);
      expect(of0 == of2, false);

      final bd3 = makeOF(kUValueData, listFloat32Common0);
      final of3 = new OFevr(bd3);
      log.debug(
          'listFloat32Common0:$listFloat32Common0 , of3.hash_code:${of3.hashCode}');
      expect(of0.hashCode == of3.hashCode, false);
      expect(of0 == of3, false);

      final of4 = new OFevr(bd2);
      log.debug(
          'listFloat32Common0:$listFloat32Common0 , of4.hash_code:${of4.hashCode}');
      expect(of1.hashCode == of4.hashCode, false);
      expect(of1 == of4, false);
    });

    test('Create OF.isValidValues', () {
      system.throwOnError = false;
      for (var i = 0; i <= listFloat32Common0.length - 1; i++) {
        final bd = makeOF(kVectorGridData, <double>[listFloat32Common0[i]]);
        final of0 = new OFevr(bd);
        expect(OF.isValidValues(PTag.kVectorGridData, of0.values), true);
      }
    });
  });
}
