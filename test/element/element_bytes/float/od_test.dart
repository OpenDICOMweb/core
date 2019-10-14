//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:bytes_dicom/bytes_dicom.dart';
import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/float32_test', level: Level.info);
  final rng = RNG(1);
  const type = BytesElementType.leLongEvr;

  const doubleList = <double>[
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

  //VM.k1
  const odVM1Tags = <int>[
    kSelectorODValue,
    kDoubleFloatPixelData,
  ];

  final rds = ByteRootDataset.empty();
  global.throwOnError = false;

  group('OD Tests', () {
    test('OD hasValidValues: good values', () {
      global.throwOnError = false;
      final e0 = ODbytes.fromValues(kSelectorODValue, doubleList, type);
      expect(e0.hasValidValues, true);
    });

    test('OD hasValidValues random: good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        expect(vList0 is Float64List, true);
        expect(vList0.length, 1);
        log.debug('$i: vList0: $vList0');
        final e0 = ODbytes.fromValues(kSelectorODValue, vList0, type);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);

        log
          ..debug('bytes: $e0')
          ..debug('e0: $e0, values: ${e0.values}')
          ..debug('e0: $e0')
          ..debug('vList0: $vList0')
          ..debug('        e0: ${e0.values}')
          ..debug('        vfBytes: ${e0.vfBytes}');
        expect(e0.values, equals(vList0));
      }
    });

    test('OD hasValidValues: bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(3, 4);
        log.debug('$i: vList0: $vList0');
        final e0 = ODbytes.fromValues(kDoubleFloatPixelData, vList0, type);
        final e1 = FLtag(e0.tag, e0.values);
        expect(e1, isNull);
      }
    });
    test('OD [] as values', () {
      final e0 = ODbytes.fromValues(kDoubleFloatPixelData, [], type);
      expect(e0.hasValidValues, true);
      expect(e0.values, equals(<double>[]));
    });

    // Can't create Evr/Ivr with null values
    // test('OD null as values', () {});

    test('OD hashCode and == random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final e0 = ODbytes.fromValues(kDoubleFloatPixelData, vList0, type);
        final e1 = ODbytes.fromValues(kDoubleFloatPixelData, vList0, type);
        log
          ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
          ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);

        final vList1 = rng.float64List(1, 1);
        final e2 = ODbytes.fromValues(kSelectorODValue, vList1, type);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);
      }
    });

    test('OD isValidValues', () {
      global.throwOnError = false;
      for (var i = 0; i <= doubleList.length - 1; i++) {
        final e0 =
            ODbytes.fromValues(kSelectorODValue, <double>[doubleList[i]], type);
        expect(OD.isValidValues(PTag.kDoubleFloatPixelData, e0.values), true);
      }
    });

    test('ODbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        global.throwOnError = false;
        for (final code in odVM1Tags) {
          final e0 = ODbytes.fromValues(code, vList0, type);
          log.debug('e0: $e0');
          final e1 = ElementBytes.fromBytes(e0.be, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);

          expect(e1.hasValidValues, true);
          expect(e1 == e0, true);
          expect(e1.vfBytes == e0.vfBytes, true);

          expect(e0.code == e0.be.code, true);
          expect(e0.length == e0.be.length, true);
          expect(e0.vrCode == e0.be.vrCode, true);
          expect(e0.vrIndex == e0.be.vrIndex, true);
          expect(e0.vfLengthOffset == e0.be.vfLengthOffset, true);
          expect(e0.vfLengthField == e0.be.vfLengthField, true);
          expect(e0.vfLength == e0.be.vfLength, true);
          expect(e0.vfOffset == e0.be.vfOffset, true);
          expect(e0.vfBytes == e0.be.vfBytes, true);
          expect(e0.vfBytesLast == e0.be.vfBytesLast, true);
        }
      }
    });

    test('ODbytes', () {
      final vList = <double>[1, 1.1, 1.2];
      final e0 = ODbytes.fromValues(kSelectorODValue, vList, type);
      expect(e0.be is BytesDicom, true);
      expect(e0.vfBytes is Bytes, true);
      expect(e0.hasValidValues, true);
      expect(e0.vfByteData is ByteData, true);
      expect(e0.lengthInBytes == e0.values.length * 8, true);
      expect(e0.isValid, true);
      expect(e0.isEmpty, false);

      final e1 = ODbytes(e0.be);
      expect(e1.be is BytesDicom, true);
      expect(e1.vfBytes is Bytes, true);
      expect(e1.hasValidValues, true);
      expect(e1.vfByteData is ByteData, true);
      expect(e1.lengthInBytes == e1.values.length * 8, true);
      expect(e1.isValid, true);
      expect(e1.isEmpty, false);
    });
  });
}