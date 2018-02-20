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

  final float64LstCommon0 = const <double>[
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

  group('FD Tests', () {
    test('FD hasValidValues: good values', () {
      system.throwOnError = false;
      final bd = makeFD(kInversionTimes, float64LstCommon0);
      final fd0 = new FDevr(bd);
      expect(fd0.hasValidValues, true);
    });

    test('FD hasValidValues random: good values', () {
      system.level = Level.info;
      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(1, 1);
        expect(float64List is Float64List, true);
        final bd = makeFD(kDiffusionBValue, float64List);
        final fd0 = new FDevr(bd);
        expect(fd0.hasValidValues, true);

        log
          ..debug('fd0: $fd0, values: ${fd0.values}')
          ..debug('fd0: ${fd0.info}')
          ..debug('float64List: $float64List')
          ..debug('        fd0: ${fd0.values}');
        expect(fd0.values, equals(float64List));
      }
    });

    test('FD hasValidValues: good values', () {
      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(2, 2);
        final bd = makeFD(kReconstructionFieldOfView, float64List);
        final fdbd = new FDevr(bd);
        final fd0 = new FDtag(fdbd.tag, fdbd.values);
        expect(fd0.hasValidValues, true);

        log
          ..debug('fd0: $fd0, values: ${fd0.values}')
          ..debug('fd0: ${fd0.info}');
        expect(fd0[0], equals(float64List[0]));
      }
    });

    test('FD hasValidValues: bad values', () {
      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(3, 4);
        log.debug('$i: float64List: $float64List');
        final bd = makeFD(kTagThickness, float64List);
        final flbd = new FDevr(bd);
        final fd0 = new FLtag(flbd.tag, flbd.values);
        expect(fd0, isNull);
      }
    });

    test('FD [] as values', () {
      final bd = makeFD(kTagThickness, []);
      final fd0 = new FDevr(bd);
      expect(fd0.hasValidValues, true);
      expect(fd0.values, equals(<double>[]));
    });

    // Can't create Evr/Ivr with null values
    // test('FD null as values', () {});

    test('FD hashCode and == random', () {
      system.throwOnError = false;
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
        final bd0 = makeFD(kTagThickness, floatList0);
        final fd0 = new FDevr(bd0);
        final bd1 = makeFD(kTagThickness, floatList0);
        final fd1 = new FDevr(bd1);
        log
          ..debug('floatList0:$floatList0, fd0.hash_code:${fd0.hashCode}')
          ..debug('floatList0:$floatList0, fd1.hash_code:${fd1.hashCode}');
        expect(fd0.hashCode == fd1.hashCode, true);
        expect(fd0 == fd1, true);

         floatList1 = rng.float64List(1, 1);
        final bd2 = makeFD(kTablePosition, floatList1);
        final fd2 = new FDevr(bd2);
        log.debug('floatList1:$floatList1 , fd2.hash_code:${fd2.hashCode}');
        expect(fd0.hashCode == fd2.hashCode, false);
        expect(fd0 == fd2, false);

        floatList2 = rng.float64List(2, 2);
        final bd3 = makeFD(kRecommendedRotationPoint, floatList2);

        final fd3 = new FDevr(bd3);
        log.debug('floatList2:$floatList2 , fd3.hash_code:${fd3.hashCode}');
        expect(fd0.hashCode == fd3.hashCode, false);
        expect(fd0 == fd3, false);

        floatList3 = rng.float64List(3, 3);
        final bd4 = makeFD(kThreeDDegreeOfFreedomAxis, floatList3);
        final fd4 = new FDevr(bd4);
        log.debug('floatList3:$floatList3 , fd4.hash_code:${fd4.hashCode}');
        expect(fd0.hashCode == fd4.hashCode, false);
        expect(fd0 == fd4, false);

        floatList4 = rng.float64List(6, 6);
        final bd5 = makeFD(kImageOrientationVolume, floatList4);
        final fd5 = new FDevr(bd5);
        log.debug('floatList4:$floatList4 , fd5.hash_code:${fd5.hashCode}');
        expect(fd0.hashCode == fd5.hashCode, false);
        expect(fd0 == fd5, false);

        floatList5 = rng.float64List(2, 3);
        final bd6 = makeFD(kTagThickness, floatList5);
        final fd6 = new FDevr(bd6);
        log.debug('floatList5:$floatList5 , fd6.hash_code:${fd6.hashCode}');
        expect(fd1.hashCode == fd6.hashCode, false);
        expect(fd1 == fd6, false);
      }
    });

    test('FD isValidValues', () {
      system.throwOnError = false;
      for (var i = 0; i <= float64LstCommon0.length - 1; i++) {
        final bd = makeFD(kTagThickness, <double>[float64LstCommon0[i]]);
        final fd0 = new FDevr(bd);
        expect(
            FD.isValidValues(PTag.kOverallTemplateSpatialTolerance, fd0.values),
            true);
      }
    });
  });
}
