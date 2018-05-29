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
  Server.initialize(name: 'element/float32_test', level: Level.info);

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
      final e0 = FDbytes.fromValues(kInversionTimes, doubleList);
      expect(e0.hasValidValues, true);
    });

    test('FD hasValidValues random: good values', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float64List(1, 1);
        log.debug('vList: $vList');
        expect(vList is Float64List, true);
        final e0 = FDbytes.fromValues(kDiffusionBValue, vList);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);

        log
          ..debug('e0: $e0, values: ${e0.values}')
          ..debug('e0: $e0')
          ..debug('vList: $vList')
          ..debug('        e0: ${e0.values}');
        expect(e0.values, equals(vList));
      }
    });

    test('FD hasValidValues: good values', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float64List(2, 2);
        final e0 = FDbytes.fromValues(kReconstructionFieldOfView, vList);
        expect(e0.hasValidValues, true);
        expect(e0.values, equals(vList));
        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        final e1 = new FDtag(e0.tag, e0.values);
        log..debug('e1: $e1, values: ${e1.values}')..debug('e1: ${e1.info}');
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(vList));
      }
    });

    test('FD hasValidValues: bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float64List(3, 4);
        log.debug('$i: vList: $vList');
        final e0 = FDbytes.fromValues(kTagThickness, vList);
        log.debug('e0.values: ${e0.values}');
        expect(e0.hasValidValues, false);
        expect(e0.values, equals(vList));
      }
    });

    test('FD [] as values', () {
      final e0 = FDbytes.fromValues(kTagThickness, []);
      expect(e0.hasValidValues, true);
      expect(e0.values, equals(<double>[]));
    });

    // Can't create Evr/Ivr with null values
    // test('FD null as values', () {});

    test('FD hashCode and == random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final e0 = FDbytes.fromValues(kTagThickness, vList0);
        final e1 = FDbytes.fromValues(kTagThickness, vList0);
        log
          ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
          ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);

        final vList1 = rng.float64List(1, 1);
        final e2 = FDbytes.fromValues(kExposureTimeInms, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rng.float64List(2, 2);
        final e3 = FDbytes.fromValues(kRecommendedRotationPoint, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);

        final vList3 = rng.float64List(3, 3);
        final e4 = FDbytes.fromValues(kThreeDDegreeOfFreedomAxis, vList3);
        log.debug('vList3:$vList3 , e4.hash_code:${e4.hashCode}');
        expect(e0.hashCode == e4.hashCode, false);
        expect(e0 == e4, false);

        final vList4 = rng.float64List(6, 6);
        final e5 = FDbytes.fromValues(kImageOrientationVolume, vList4);
        log.debug('vList4:$vList4 , e5.hash_code:${e5.hashCode}');
        expect(e0.hashCode == e5.hashCode, false);
        expect(e0 == e5, false);

        final vList5 = rng.float64List(2, 3);
        final e6 = FDbytes.fromValues(kTagThickness, vList5);
        log.debug('vList5:$vList5 , e6.hash_code:${e6.hashCode}');
        expect(e1.hashCode == e6.hashCode, false);
        expect(e1 == e6, false);
      }
    });

    test('FD isValidValues', () {
      global.throwOnError = false;
      for (var i = 0; i <= doubleList.length - 1; i++) {
        final e0 = FDbytes.fromValues(kTagThickness, <double>[doubleList[i]]);
        expect(
            FD.isValidValues(PTag.kOverallTemplateSpatialTolerance, e0.values),
            true);
      }
    });

    test('FDbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        global.throwOnError = false;
        final e0 = FDbytes.fromValues(kOverallTemplateSpatialTolerance, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('FDbytes from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.float64List(1, i);
        global.throwOnError = false;
        final e0 = FDbytes.fromValues(kSelectorFDValue, vList0);
/*
        final s = e1.toString();
        log.debug('e0: $e0');
//        final bd0 = new Bytes.typedDataView(vList0);

        final e0 = Lobytes.fromValuesngEvr(e1.code, e1.vrIndex, bd0);
        final e1= ByteElement.makeFromCode(rds, e1.code, bd1);
        log.debug('e0:$e0');
*/
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });
}
