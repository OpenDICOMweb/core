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
//  List<double> float32List;

  const listFloat32Common0 = const <double>[
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

  system.throwOnError = false;
  group('FL Tests', () {
    test('FL hasValidValues: good values', () {
      system.throwOnError = false;
      final bd = makeFL(kVectorAccuracy, listFloat32Common0);
      final fl0 = new FLevr(bd);
      expect(fl0.hasValidValues, true);
    });

    test('FL hasValidValues random: good values', () {
//      system.level = Level.info;
      for (var i = 0; i < 10; i++) {
        final float32List = rng.float32List(1, 10);
        expect(float32List is Float32List, true);
        final bd = makeFL(kSelectorFDValue, float32List);
        final fl0 = new FLevr(bd);
        expect(fl0[0], equals(float32List[0]));
        expect(fl0.hasValidValues, true);

        log
          ..debug('fl0: $fl0, values: ${fl0.values}')
          ..debug('fl0: ${fl0.info}')
          ..debug('float32List: $float32List')
          ..debug('        fl0: ${fl0.values}');
        expect(fl0.values, equals(float32List));
      }
    });

    test('FL hasValidValues: good values', () {
//      system.level = Level.info;
      for (var i = 0; i < 10; i++) {
        final float32List = rng.float32List(2, 2);
        final bd = makeFL(kCornealVertexLocation, float32List);
        final flbd = new FLevr(bd);
        log
          ..debug('$i: fl0: $flbd, values: ${flbd.values}')
          ..debug('fl0: ${flbd.info}');
        final fl0 = new FLtag(flbd.tag, flbd.values);
        log
          ..debug('$i: fl0: $fl0, values: ${fl0.values}')
          ..debug('fl0: ${fl0.info}');
        expect(fl0.hasValidValues, true);

        expect(fl0[0], equals(float32List[0]));
      }
    });

    test('FL hasValidValues: bad values', () {
      for (var i = 0; i < 10; i++) {
        final float32List = rng.float32List(3, 4);
        log.debug('$i: float32List: $float32List');
        final bd = makeFL(kCornealVertexLocation, float32List);
        final flbd = new FLevr(bd);
        final fl0 = new FLtag(flbd.tag, flbd.values);
        expect(fl0, isNull);
      }
    });

    test('FL [] as values', () {
      final bd = makeFL(kTableOfParameterValues, []);
      final fl0 = new FLevr(bd);
      expect(fl0.hasValidValues, true);
      expect(fl0.values, equals(<double>[]));
    });

    // Can't create Evr/Ivr with null values
    // test('FL null as values', () {});

    test('FL hashCode and == random', () {
      system.throwOnError = false;
      final rng = new RNG(1);

      List<double> floatList0;
      List<double> floatList1;
      List<double> floatList2;
      List<double> floatList3;
      List<double> floatList4;
      List<double> floatList5;

      log.debug('FL hashCode and ==');
      for (var i = 0; i < 10; i++) {
        floatList0 = rng.float32List(1, 1);
        final bd = makeFL(kAbsoluteChannelDisplayScale, floatList0);
        final fl0 = new FLevr(bd);
        //bd = makeFL(kAbsoluteChannelDisplayScale, floatList0);
        final fl1 = new FLevr(bd);
        log
          ..debug('floatList0:$floatList0, fl0.hash_code:${fl0.hashCode}')
          ..debug('floatList0:$floatList0, fl1.hash_code:${fl1.hashCode}');
        expect(fl0.hashCode == fl1.hashCode, true);
        expect(fl0 == fl1, true);

        floatList1 = rng.float32List(1, 1);
        final bd1 = makeFL(kRecommendedDisplayFrameRateInFloat, floatList1);
        final fl2 = new FLevr(bd1);
        log.debug('floatList1:$floatList1 , fl2.hash_code:${fl2.hashCode}');
        expect(fl0.hashCode == fl2.hashCode, false);
        expect(fl0 == fl2, false);

        floatList2 = rng.float32List(2, 2);
        final bd2 = makeFL(kCornealVertexLocation, floatList2);

        final fl3 = new FLevr(bd2);
        log.debug('floatList2:$floatList2 , fl3.hash_code:${fl3.hashCode}');
        expect(fl0.hashCode == fl3.hashCode, false);
        expect(fl0 == fl3, false);

        floatList3 = rng.float32List(3, 3);
        final bd3 = makeFL(kCornealPointLocation, floatList3);
        final fl4 = new FLevr(bd3);
        log.debug('floatList3:$floatList3 , fl4.hash_code:${fl4.hashCode}');
        expect(fl0.hashCode == fl4.hashCode, false);
        expect(fl0 == fl4, false);

        floatList4 = rng.float32List(6, 6);
        final bd4 = makeFL(kPointsBoundingBoxCoordinates, floatList4);
        final fl5 = new FLevr(bd4);
        log.debug('floatList4:$floatList4 , fl5.hash_code:${fl5.hashCode}');
        expect(fl0.hashCode == fl5.hashCode, false);
        expect(fl0 == fl5, false);

        floatList5 = rng.float32List(2, 3);
        final bd5 = makeFL(kFractionalChannelDisplayScale, floatList5);
        final fl6 = new FLevr(bd5);
        log.debug('floatList5:$floatList5 , fl6.hash_code:${fl6.hashCode}');
        expect(fl1.hashCode == fl6.hashCode, false);
        expect(fl1 == fl6, false);
      }
    });

    test('Create FL.isValidValues', () {
      system.throwOnError = false;
      for (var i = 0; i <= listFloat32Common0.length - 1; i++) {
        final bd =
            makeFL(kExaminedBodyThickness, <double>[listFloat32Common0[i]]);
        final fl2 = new FLevr(bd);
        expect(FL.isValidValues(PTag.kExaminedBodyThickness, fl2), true);
      }
    });
  });
}
