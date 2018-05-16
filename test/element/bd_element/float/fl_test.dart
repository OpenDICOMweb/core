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
  Server.initialize(name: 'element/float32_test', level: Level.debug);
  final rng = new RNG(1);

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

  final float32List = new Float32List.fromList(doubleList);

  global.throwOnError = false;

  // group('FL Tests', () {
  test('FL hasValidValues: good values', () {
    global.throwOnError = false;
    log.debug('vList: $float32List');
    final fl0 = FLbytes.fromValues(kVectorAccuracy, doubleList);
    expect(fl0.hasValidValues, true);
  });

  test('FL hasValidValues random: good values', () {
    for (var i = 0; i < 10; i++) {
      final vList = rng.float32List(1, 10);
      expect(vList is Float32List, true);
      print('vList: $vList');
      final fl0 = FLbytes.fromValues(kSelectorFDValue, vList);
      print('fl0: ${fl0.vfBytes}');
      print('fl0: ${fl0.values}');
      expect(fl0[0], equals(vList[0]));
      expect(fl0.hasValidValues, true);

      log
        ..debug('fl0: $fl0, values: ${fl0.values}')
        ..debug('fl0: $fl0')
        ..debug('float32List: $vList')
        ..debug('        fl0: ${fl0.values}');
      expect(fl0.values, equals(vList));
    }
  });

  test('FL hasValidValues: good values', () {
    for (var i = 0; i < 10; i++) {
      final float32List0 = rng.float32List(2, 2);
      final fl0 = FLbytes.fromValues(kCornealVertexLocation, float32List0);
      log..debug('$i: fl0: $fl0, values: ${fl0.values}')..debug('fl0: $fl0');
      final fl1 = new FLtag(fl0.tag, fl0.values);
      log
        ..debug('$i: fl0: $fl1, values: ${fl1.values}')
        ..debug('fl0: ${fl1.info}');
      expect(fl1.hasValidValues, true);

      expect(fl1[0], equals(float32List0[0]));
    }
  });

  test('FL hasValidValues: bad values', () {
    for (var i = 0; i < 10; i++) {
      final floatList0 = rng.float32List(3, 4);
      log.debug('$i: float32List: $floatList0');
      final flbd = FLbytes.fromValues(kCornealVertexLocation, floatList0);
      final fl0 = new FLtag(flbd.tag, flbd.values);
      expect(fl0, isNull);
    }
  });

  test('FL [] as values', () {
    final fl0 = FLbytes.fromValues(kTableOfParameterValues, []);
    expect(fl0.hasValidValues, true);
    expect(fl0.values, equals(<double>[]));
  });

  // Can't create Evr/Ivr with null values
  // test('FL null as values', () {});

  test('FL hashCode and == random', () {
    global.throwOnError = false;
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
      final fl0 = FLbytes.fromValues(kAbsoluteChannelDisplayScale, floatList0);

      //bd = FLbytes.fromValues(kAbsoluteChannelDisplayScale, floatList0);
      final fl1 = FLbytes.fromValues(kAbsoluteChannelDisplayScale, floatList0);
      log
        ..debug('floatList0:$floatList0, fl0.hash_code:${fl0.hashCode}')
        ..debug('floatList0:$floatList0, fl1.hash_code:${fl1.hashCode}');
      expect(fl0.hashCode == fl1.hashCode, true);
      expect(fl0 == fl1, true);

      floatList1 = rng.float32List(1, 1);
      final fl2 =
          FLbytes.fromValues(kRecommendedDisplayFrameRateInFloat, floatList1);
      log.debug('floatList1:$floatList1 , fl2.hash_code:${fl2.hashCode}');
      expect(fl0.hashCode == fl2.hashCode, false);
      expect(fl0 == fl2, false);

      floatList2 = rng.float32List(2, 2);
      final fl3 = FLbytes.fromValues(kCornealVertexLocation, floatList2);

      log.debug('floatList2:$floatList2 , fl3.hash_code:${fl3.hashCode}');
      expect(fl0.hashCode == fl3.hashCode, false);
      expect(fl0 == fl3, false);

      floatList3 = rng.float32List(3, 3);
      final fl4 = FLbytes.fromValues(kCornealPointLocation, floatList3);
      log.debug('floatList3:$floatList3 , fl4.hash_code:${fl4.hashCode}');
      expect(fl0.hashCode == fl4.hashCode, false);
      expect(fl0 == fl4, false);

      floatList4 = rng.float32List(6, 6);
      final fl5 = FLbytes.fromValues(kPointsBoundingBoxCoordinates, floatList4);

      log.debug('floatList4:$floatList4 , fl5.hash_code:${fl5.hashCode}');
      expect(fl0.hashCode == fl5.hashCode, false);
      expect(fl0 == fl5, false);

      floatList5 = rng.float32List(2, 3);
      final fl6 =
          FLbytes.fromValues(kFractionalChannelDisplayScale, floatList5);
      log.debug('floatList5:$floatList5 , fl6.hash_code:${fl6.hashCode}');
      expect(fl1.hashCode == fl6.hashCode, false);
      expect(fl1 == fl6, false);
    }
  });

  test('Create FL.isValidValues', () {
    global.throwOnError = false;
    for (var i = 0; i <= doubleList.length - 1; i++) {
      final fl0 =
          FLbytes.fromValues(kExaminedBodyThickness, <double>[doubleList[i]]);
      log.debug('fl0: $fl0');
      expect(FL.isValidValues(PTag.kExaminedBodyThickness, fl0.values), true);
    }
  });
  // });
}
