//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/float32_test', level: Level.info);
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

  const ofVM1Tags = const <int>[
    kVectorGridData,
    kFloatingPointValues,
    kUValueData,
    kVValueData,
    kFirstOrderPhaseCorrectionAngle,
    kSpectroscopyData,
    kFloatPixelData,
  ];

  final rng = RNG(1);

  group('OF Tests', () {
    global.throwOnError = false;

    test('OF hasValidValues: good values', () {
      global.throwOnError = false;
      final e0 = OFbytes.fromValues(kSelectorOFValue, doubleList);
      expect(e0.hasValidValues, true);
    });

    test('OF hasValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float32List(1, 10);
        log.debug('vList0: $vList0');
        expect(vList0 is Float32List, true);
        log.debug('i: $i, vList0: $vList0');
        final e0 = OFbytes.fromValues(kFirstOrderPhaseCorrectionAngle, vList0);
        log.debug('of:$e0');
        expect(e0[0], equals(vList0[0]));
        expect(e0.hasValidValues, true);
      }
    });

    test('OF hasValidValues random: good values', () {
      for (var i = 0; i < 100; i++) {
        final vList0 = rng.float32List(2, 10);
        log.debug('i: $i, vList0: $vList0');
        final e0 = OFbytes.fromValues(kFirstOrderPhaseCorrectionAngle, vList0);
        expect(e0.hasValidValues, true);
      }
    });

    test('OF []', () {
      global.throwOnError = false;
      final e0 = OFbytes.fromValues(kVectorGridData, kEmptyFloat32List);
      expect(e0.hasValidValues, true);
      expect(e0.values, equals(<double>[]));

      final e1 = OFbytes.fromValues(kVectorGridData, kEmptyFloat32List);
      expect(e1.hasValidValues, true);
      expect(e1.values.isEmpty, true);
    });

    test('OF hashCode and == random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float32List(1, 1);
        final e0 = OFbytes.fromValues(kVectorGridData, vList0);
        final e1 = OFbytes.fromValues(kVectorGridData, vList0);
        log
          ..debug('vList0:$vList0 , e1.hash_code:${e1.hashCode}')
          ..debug('vList0:$vList0 , e1.hash_code:${e1.hashCode}');
        expect(e1.hashCode == e1.hashCode, true);
        expect(e1 == e1, true);

        final vList1 = rng.float32List(1, 1);
        final e2 = OFbytes.fromValues(kPointCoordinatesData, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rng.float32List(1, 2);
        final e3 = OFbytes.fromValues(kUValueData, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);

        final vList3 = rng.float32List(2, 3);
        final e4 = OFbytes.fromValues(kPointCoordinatesData, vList3);
        log.debug('vList3:$vList3 , e4.hash_code:${e4.hashCode}');
        expect(e1.hashCode == e4.hashCode, false);
        expect(e1 == e4, false);
      }
    });

    test('OF hashCode and ==', () {
      final e0 = OFbytes.fromValues(kVectorGridData, doubleList);
      final e1 = OFbytes.fromValues(kVectorGridData, doubleList);
      log
        ..debug('listFloat32Common0:$doubleList , '
            'e1.hash_code:${e1.hashCode}')
        ..debug('listFloat32Common0:$doubleList , '
            'e1.hash_code:${e1.hashCode}');
      expect(e1.hashCode == e1.hashCode, true);
      expect(e1 == e1, true);

      final e2 = OFbytes.fromValues(kPointCoordinatesData, doubleList);
      log.debug('listFloat32Common0:$doubleList , '
          'e2.hash_code:${e2.hashCode}');
      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);

      final e3 = OFbytes.fromValues(kUValueData, doubleList);
      log.debug('listFloat32Common0:$doubleList , '
          'e3.hash_code:${e3.hashCode}');
      expect(e0.hashCode == e3.hashCode, false);
      expect(e0 == e3, false);

      final e4 = OFbytes.fromValues(e2.code, e2.values);
      log.debug('listFloat32Common0:$doubleList , '
          'e4.hash_code:${e4.hashCode}');
      expect(e1.hashCode == e4.hashCode, false);
      expect(e1 == e4, false);
    });

    test('Create OF.isValidValues', () {
      global.throwOnError = false;
      for (var i = 0; i <= doubleList.length - 1; i++) {
        final e0 = OFbytes.fromValues(kVectorGridData, <double>[doubleList[i]]);
        expect(OF.isValidValues(PTag.kVectorGridData, e0.values), true);
      }
    });
  });

  final rds = ByteRootDataset.empty();

  group('OFbytes', () {
    test('OFbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float32List(1, 1);
        //final float32List0 = Float32List.fromList(vList0);
        //final bytes = float32List0.buffer.asByteData();
        global.throwOnError = false;
        for (var code in ofVM1Tags) {
          final e0 = OFbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('OFbytes from VM.k1_n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float32List(1, 1);
        global.throwOnError = false;
        final e0 = OFbytes.fromValues(kSelectorOFValue, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds, isEvr: true);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('OFbytes', () {
      final vList = <double>[1.0, 1.1, 1.2];
      final e0 = OFbytes.fromValues(kSelectorOFValue, vList);
      expect(e0.bytes is DicomBytes, true);
      expect(e0.vfBytes is Bytes, true);
      expect(e0.hasValidValues, true);
      expect(e0.vfByteData is ByteData, true);
      expect(e0.lengthInBytes == e0.values.length * 4, true);
      expect(e0.isValid, true);
      expect(e0.isEmpty, false);

      final e1 = OFbytes(e0.bytes);
      expect(e1.bytes is DicomBytes, true);
      expect(e1.vfBytes is Bytes, true);
      expect(e1.hasValidValues, true);
      expect(e1.vfByteData is ByteData, true);
      expect(e1.lengthInBytes == e1.values.length * 4, true);
      expect(e1.isValid, true);
      expect(e1.isEmpty, false);
    });
  });
}
