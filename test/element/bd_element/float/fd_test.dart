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

final RNG rng = new RNG(1);

void main() {
  Server.initialize(name: 'element/float32_test', level: Level.debug);

  const doubleList = const <double>[
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


  final rds = new ByteRootDataset.empty();
  global.throwOnError = false;

  group('FD Tests', () {
    test('FD hasValidValues: good values', () {
      global.throwOnError = false;
      final fd0 = FDbytes.fromValues(kInversionTimes, doubleList);
      print('code: ${dcm(fd0.code)}');
      print('vrCode: ${hex16(fd0.vrCode)}');
      print('vfLength: ${fd0.vfLength}');
      print('values: ${fd0.values}');
      expect(fd0.hasValidValues, true);
    });

    test('FD hasValidValues random: good values', () {
      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(1, 1);
        log.debug('float64List: $float64List');
        expect(float64List is Float64List, true);
        final fd0 = FDbytes.fromValues(kDiffusionBValue, float64List);
        log.debug('fd0: $fd0');
        expect(fd0.hasValidValues, true);

        log
          ..debug('fd0: $fd0, values: ${fd0.values}')
          ..debug('fd0: $fd0')
          ..debug('float64List: $float64List')
          ..debug('        fd0: ${fd0.values}');
        expect(fd0.values, equals(float64List));
      }
    });

    test('FD hasValidValues: good values', () {
      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(2, 2);
        print(float64List);
        final fd0 = FDbytes.fromValues(kReconstructionFieldOfView, float64List);
        print('vrCode: ${hex16(fd0.bytes.vrCode)}');
        print('fd0.values: ${fd0.values}');
        expect(fd0.hasValidValues, true);
        expect(fd0.values, equals(float64List));
        log..debug('fd0: $fd0, values: ${fd0.values}')..debug('fd0: $fd0');
        final fd1 = new FDtag(fd0.tag, fd0.values);
        log
          ..debug('fd1: $fd1, values: ${fd1.values}')
          ..debug('fd1: ${fd1.info}');
        expect(fd1.hasValidValues, true);
        expect(fd1.values, equals(float64List));
      }
    });

    test('FD hasValidValues: bad values', () {
      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(3, 4);
        log.debug('$i: float64List: $float64List');
        final fd0 = FDbytes.fromValues(kTagThickness, float64List);
        log.debug('fd0.values: ${fd0.values}');
        expect(fd0.hasValidValues, false);
        expect(fd0.values, equals(float64List));
      }
    });

    test('FD [] as values', () {
      final fd0 = FDbytes.fromValues(kTagThickness, []);
      expect(fd0.hasValidValues, true);
      expect(fd0.values, equals(<double>[]));
    });

    // Can't create Evr/Ivr with null values
    // test('FD null as values', () {});

    test('FD hashCode and == random', () {
      global.throwOnError = false;
      final rng = new RNG(1);

      List<double> floatList0;
      List<double> floatList1;
      List<double> floatList2;
      List<double> floatList3;
      List<double> floatList4;
      List<double> floatList5;

      log.debug('FD hashCode and ==');
      for (var i = 0; i < 10; i++) {
        floatList0 = rng.float64List(1, 1);
        final fd0 = FDbytes.fromValues(kTagThickness, floatList0);
        final fd1 = FDbytes.fromValues(kTagThickness, floatList0);
        log
          ..debug('floatList0:$floatList0, fd0.hash_code:${fd0.hashCode}')
          ..debug('floatList0:$floatList0, fd1.hash_code:${fd1.hashCode}');
        expect(fd0.hashCode == fd1.hashCode, true);
        expect(fd0 == fd1, true);

        floatList1 = rng.float64List(1, 1);
        final fd2 = FDbytes.fromValues(kTablePosition, floatList1);
        log.debug('floatList1:$floatList1 , fd2.hash_code:${fd2.hashCode}');
        expect(fd0.hashCode == fd2.hashCode, false);
        expect(fd0 == fd2, false);

        floatList2 = rng.float64List(2, 2);
        final fd3 = FDbytes.fromValues(kRecommendedRotationPoint, floatList2);
        log.debug('floatList2:$floatList2 , fd3.hash_code:${fd3.hashCode}');
        expect(fd0.hashCode == fd3.hashCode, false);
        expect(fd0 == fd3, false);

        floatList3 = rng.float64List(3, 3);
        final fd4 = FDbytes.fromValues(kThreeDDegreeOfFreedomAxis, floatList3);
        log.debug('floatList3:$floatList3 , fd4.hash_code:${fd4.hashCode}');
        expect(fd0.hashCode == fd4.hashCode, false);
        expect(fd0 == fd4, false);

        floatList4 = rng.float64List(6, 6);
        final fd5 = FDbytes.fromValues(kImageOrientationVolume, floatList4);
        log.debug('floatList4:$floatList4 , fd5.hash_code:${fd5.hashCode}');
        expect(fd0.hashCode == fd5.hashCode, false);
        expect(fd0 == fd5, false);

        floatList5 = rng.float64List(2, 3);
        final fd6 = FDbytes.fromValues(kTagThickness, floatList5);
        log.debug('floatList5:$floatList5 , fd6.hash_code:${fd6.hashCode}');
        expect(fd1.hashCode == fd6.hashCode, false);
        expect(fd1 == fd6, false);
      }
    });

    test('FD isValidValues', () {
      global.throwOnError = false;
      for (var i = 0; i <= doubleList.length - 1; i++) {
        final fd0 = FDbytes.fromValues(kTagThickness, <double>[doubleList[i]]);
        expect(
            FD.isValidValues(PTag.kOverallTemplateSpatialTolerance, fd0.values),
            true);
      }
    });

    test('FDbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float64List(1, 1);
        global.throwOnError = false;
        final e0 =
            FDbytes.fromValues(kOverallTemplateSpatialTolerance, floatList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('FDbytes from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final floatList0 = rng.float64List(1, i);
        global.throwOnError = false;
        final e0 = FDbytes.fromValues(kSelectorFDValue, floatList0);
/*
        final s = fd1.toString();
        log.debug('e0: $e0');
//        final bd0 = new Bytes.typedDataView(floatList0);

        final e0 = Lobytes.fromValuesngEvr(fd1.code, fd1.vrIndex, bd0);
        final e1= ByteElement.makeFromCode(rds, fd1.code, bd1);
        log.debug('e0:$e0');
*/
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });
}
