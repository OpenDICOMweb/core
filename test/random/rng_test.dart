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
  Server.initialize(name: 'rng/float_test', level: Level.info);

  group('getLength tests of RNG', () {
    final rng = new RNG(0);
    const count = 10;
    const minMin = 3;
    const maxMin = 31;
    const minMax = 32;
    const maxMax = 255;

    test('getLength test', () {
      for (var i = 0; i < count; i++) {
        final l0 = rng.getLength(minMin, maxMin);
        log.debug('min: $minMin <= $l0 <= max: $maxMin');
        expect(l0, inInclusiveRange(minMin, maxMin));

        final l1 = rng.getLength(minMax, maxMax);
        log.debug('min: $minMax <= $l0 <= max: $maxMax');
        expect(l1, inInclusiveRange(minMax, maxMax));

        final l2 = rng.getLength(minMin, maxMax);
        log.debug('min: $minMin <= $l0 <= max: $maxMax');
        expect(l2, inInclusiveRange(minMin, maxMax));
      }
    });

    //Urgent: test range of lengths
    //Urgent: test range of values
    test('IntList Test', () {
      for (var i = 0; i < count; i++) {
        final list = rng.intList(-20, 60, minMin, maxMin);
        log.debug('IntList: (${list.length})$list');
        expect(list is List<int>, true);
        expect(list.length, inInclusiveRange(minMin, maxMin));
        for (var i in list) expect(i, inInclusiveRange(-20, 60));
      }
    });
  });

  group('Integer tests of Random Number Generator(RNG)', () {
    final rng = new RNG(0);
    const minMin = 3;
    const maxMin = 31;
    const minMax = 32;
    const maxMax = 255;
    final minLength = rng.nextUint(minMin, maxMin);
    final maxLength =
        rng.nextUint(minLength, minLength + rng.nextUint(minMax, maxMax));
    log.debug('minLength($minLength), maxLength($maxLength)');

    //TODO: test range of values
    test('IntList Test', () {
      final list = rng.intList(-20, 60, minLength, maxLength);
      log.debug('IntList: (${list.length})$list');
      expect(list is List<int>, true);
      expect(list.length, inInclusiveRange(minLength, maxLength));
      for (var i in list) expect(i, inInclusiveRange(-20, 60));
    });

    test('Int8List Test', () {
      final list = rng.int8List(minLength, maxLength);
      log.debug('Int8List: (${list.length})$list');
      expect(list.length, inInclusiveRange(minLength, maxLength));
      expect(list is Int8List, true);
    });

    test('Int16List Test', () {
      final list = rng.int16List(minLength, maxLength);
      log.debug('Int16List: (${list.length})$list');
      expect(list.length, inInclusiveRange(minLength, maxLength));
      expect(list is Int16List, true);
    });

    test('Int32List Test', () {
      final list = rng.int32List(minLength, maxLength);
      log.debug('Int32List: (${list.length})$list');
      expect(list.length, inInclusiveRange(minLength, maxLength));
      expect(list is Int32List, true);
    });

    test('Int64List Test', () {
      final list = rng.int64List(minLength, maxLength);
      log.debug('Int64List: (${list.length})$list');
      expect(list.length, inInclusiveRange(minLength, maxLength));
      expect(list is Int64List, true);
    });

    test('Uint8List Test', () {
      final list = rng.uint8List(minLength, maxLength);
      log.debug('Uint8List: (${list.length})$list');
      expect(list.length, inInclusiveRange(minLength, maxLength));
      expect(list is Uint8List, true);
    });

    test('Uint16List Test', () {
      final list = rng.uint16List(minLength, maxLength);
      log.debug('Uint16List: (${list.length})$list');
      expect(list.length, inInclusiveRange(minLength, maxLength));
      expect(list is Uint16List, true);
    });

    test('Uint32List Test', () {
      final list = rng.uint32List(minLength, maxLength);
      log.debug('Uint32List: (${list.length})$list');
      expect(list.length, inInclusiveRange(minLength, maxLength));
      expect(list is Uint32List, true);
    });

    test('Uint64List Test', () {
      final list = rng.uint64List(minLength, maxLength);
      log.debug('Uint64List: (${list.length})$list');
      expect(list.length, inInclusiveRange(minLength, maxLength));
      expect(list is Uint64List, true);
    });
  });

  group('Random floating Point numbers tests of ', () {
    final rng = new RNG(0);
    const count = 10;

    test('nextDouble Test', () {
      for (var i = 0; i < count; i++) {
        final nd = rng.nextDouble;
        log.debug('double: $nd');
        expect(nd is double, true);
        expect(nd >= 0 || nd <= 1, true);
      }
    });

    test('nextFloat Test', () {
      for (var i = 0; i < count; i++) {
        final nf = rng.nextFloat;
        log.debug('nextFloat: $nf');
        expect(nf is double, true);
        expect(nf.abs() > 1, true);
      }
    });

    test('nextFloat32 Test', () {
      final floatBox = new Float32List(1);

      for (var i = 0; i < count; i++) {
        final nf32 = rng.nextFloat32;
        log.debug('nextFloat32: $nf32');
        floatBox[0] = nf32;
        log.debug('floatBox: ${floatBox[0]}');

        expect(nf32 is double, true);
        expect(floatBox[0] is double, true);
        expect(nf32 == floatBox[0], true);
        expect(nf32 >= 0 || nf32 <= 1, true);
      }
    });
  });

  group('Random Floating point lists test', () {
    final rng = new RNG(0);
    const count = 10;

    test('listOfDouble Test', () {
      for (var i = 0; i < count; i++) {
        final list = rng.listOfDouble(1, 32);
        log.debug('Float32List: (${list.length})$list');
        expect(list is List<double>, true);
        expect(list.length, inInclusiveRange(1, 32));
      }
    });

    test('List<Float32> Test', () {
      for (var i = 0; i < count; i++) {
        final list0 = rng.listOfFloat32(1, 32);
        log.debug('Float32List: (${list0.length})$list0');
        expect(list0 is List<double>, true);
        expect(list0.length, inInclusiveRange(1, 32));

        final list1 = new Float32List.fromList(list0);
        expect(list0.length == list1.length, true);
        for (var i = 0; i < list0.length; i++) {
          expect(list0[i] == list1[i], true);
        }
      }
    });

    test('Float32List Test', () {
      for (var i = 0; i < count; i++) {
        final list = rng.float32List(1, 32);
        log.debug('Float32List: (${list.length})$list');
        expect(list is Float32List, true);
        expect(list.length, inInclusiveRange(1, 32));
      }
    });

    test('Float64List Test', () {
      for (var i = 0; i < count; i++) {
        final list = rng.float64List(1, 32);
        log.debug('Float32List: (${list.length})$list');
        expect(list is Float64List, true);
        expect(list.length, inInclusiveRange(1, 32));
      }
    });
  });
}
