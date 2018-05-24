//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/float32_test', level: Level.info);
  List<double> float32List;

  const doubleList = const <double>[
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

  final rng = new RNG(1);

  group('OF Tests', () {
    global.throwOnError = false;

    test('OF hasValidValues: good values', () {
      global.throwOnError = false;
      final of0 = OFbytes.fromValues(kSelectorOFValue, doubleList);
      expect(of0.hasValidValues, true);
    });

    test('OF hasValidValues random', () {
      for (var i = 0; i < 10; i++) {
        float32List = rng.float32List(1, 10);
        log.debug('float32List: $float32List');
        expect(float32List is Float32List, true);
        log.debug('i: $i, float32List: $float32List');
        final of0 =
            OFbytes.fromValues(kFirstOrderPhaseCorrectionAngle, float32List);
        log.debug('of:$of0');
        expect(of0[0], equals(float32List[0]));
        expect(of0.hasValidValues, true);
      }
    });

    test('OF hasValidValues random: good values', () {
      for (var i = 0; i < 100; i++) {
        float32List = rng.float32List(2, 10);
        log.debug('i: $i, float32List: $float32List');
        final of0 =
            OFbytes.fromValues(kFirstOrderPhaseCorrectionAngle, float32List);
        expect(of0.hasValidValues, true);
      }
    });

    test('OF []', () {
      global.throwOnError = false;
      final of0 = OFbytes.fromValues(kVectorGridData, kEmptyFloat32List);
      expect(of0.hasValidValues, true);
      expect(of0.values, equals(<double>[]));

      final of1 = OFbytes.fromValues(kVectorGridData, kEmptyFloat32List);
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
        final of0 = OFbytes.fromValues(kVectorGridData, floatList0);
        final of1 = OFbytes.fromValues(kVectorGridData, floatList0);
        log
          ..debug('floatList0:$floatList0 , of1.hash_code:${of1.hashCode}')
          ..debug('floatList0:$floatList0 , of1.hash_code:${of1.hashCode}');
        expect(of1.hashCode == of1.hashCode, true);
        expect(of1 == of1, true);

        floatList1 = rng.float32List(1, 1);
        final of2 = OFbytes.fromValues(kPointCoordinatesData, floatList1);
        log.debug('floatList1:$floatList1 , of2.hash_code:${of2.hashCode}');
        expect(of0.hashCode == of2.hashCode, false);
        expect(of0 == of2, false);

        floatList2 = rng.float32List(1, 2);
        final of3 = OFbytes.fromValues(kUValueData, floatList2);
        log.debug('floatList2:$floatList2 , of3.hash_code:${of3.hashCode}');
        expect(of0.hashCode == of3.hashCode, false);
        expect(of0 == of3, false);

        floatList3 = rng.float32List(2, 3);
        final of4 = OFbytes.fromValues(kPointCoordinatesData, floatList3);
        log.debug('floatList3:$floatList3 , of4.hash_code:${of4.hashCode}');
        expect(of1.hashCode == of4.hashCode, false);
        expect(of1 == of4, false);
      }
    });

    test('OF hashCode and ==', () {
      log.debug('OF hashCode and ==');

      final of0 = OFbytes.fromValues(kVectorGridData, doubleList);
      final of1 = OFbytes.fromValues(kVectorGridData, doubleList);
      log
        ..debug('listFloat32Common0:$doubleList , '
            'of1.hash_code:${of1.hashCode}')
        ..debug('listFloat32Common0:$doubleList , '
            'of1.hash_code:${of1.hashCode}');
      expect(of1.hashCode == of1.hashCode, true);
      expect(of1 == of1, true);

      final of2 = OFbytes.fromValues(kPointCoordinatesData, doubleList);
      log.debug('listFloat32Common0:$doubleList , '
          'of2.hash_code:${of2.hashCode}');
      expect(of0.hashCode == of2.hashCode, false);
      expect(of0 == of2, false);

      final of3 = OFbytes.fromValues(kUValueData, doubleList);
      log.debug('listFloat32Common0:$doubleList , '
          'of3.hash_code:${of3.hashCode}');
      expect(of0.hashCode == of3.hashCode, false);
      expect(of0 == of3, false);

      final of4 = OFbytes.fromValues(of2.code, of2.values);
      log.debug('listFloat32Common0:$doubleList , '
          'of4.hash_code:${of4.hashCode}');
      expect(of1.hashCode == of4.hashCode, false);
      expect(of1 == of4, false);
    });

    test('Create OF.isValidValues', () {
      global.throwOnError = false;
      for (var i = 0; i <= doubleList.length - 1; i++) {
        final of0 =
            OFbytes.fromValues(kVectorGridData, <double>[doubleList[i]]);
        expect(OF.isValidValues(PTag.kVectorGridData, of0.values), true);
      }
    });
  });

  final rds = new ByteRootDataset.empty();

  group('OFbytes', () {
    test('OFbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float32List(1, 1);
        //final float32List0 = new Float32List.fromList(floatList0);
        //final bytes = float32List0.buffer.asByteData();
        global.throwOnError = false;
        final e0 = OFbytes.fromValues(kFloatPixelData, floatList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('OFbytes from VM.k1_n', () {
      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float32List(1, 1);
        global.throwOnError = false;
        final e0 = OFbytes.fromValues(kSelectorOFValue, floatList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });
}
