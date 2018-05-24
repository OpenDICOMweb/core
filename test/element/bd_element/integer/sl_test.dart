//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/server.dart';
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = new RSG(seed: 1);
RNG rng = new RNG(1);

void main() {
  Server.initialize(name: 'bd_element/sl_test', level: Level.info);

  final rds = new ByteRootDataset.empty();

  group('SLbytes', () {
    const slVM1Tags = const <int>[
      kReferencePixelX0,
      kReferencePixelY0,
      kDopplerSampleVolumeXPosition,
      kDopplerSampleVolumeYPosition,
      kTMLinePositionX0,
      kTMLinePositionY0,
      kTMLinePositionX1,
      kTMLinePositionY1,
      kColumnPositionInTotalImagePixelMatrix,
      kRowPositionInTotalImagePixelMatrix,
    ];

    const slVM2Tags = const <int>[
      kDisplayedAreaTopLeftHandCorner,
      kDisplayedAreaBottomRightHandCorner,
    ];

    const slVM1_nTag = const <int>[
      kRationalNumeratorValue,
      kSelectorSLValue,
    ];

    const slVM2_2nTags = const <int>[kPixelCoordinatesSetTrial];

    test('SLbytes from VM.k1 good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int32List(1, 1);
        global.throwOnError = false;
        for (var code in slVM1Tags) {
          final e0 = SLbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('SLbytes from VM.k1 bad values length', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.int32List(2, i + 1);
        global.throwOnError = false;
        for (var code in slVM1Tags) {
          final e0 = SLbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, false);
        }
      }
    });

    test('SLbytes from VM.k2 good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int32List(2, 2);
        global.throwOnError = false;
        for (var code in slVM2Tags) {
          final e0 = SLbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('SLbytes from VM.k2 bad values length', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int32List(3, 3 + i);
        global.throwOnError = false;
        for (var code in slVM2Tags) {
          final e0 = SLbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, false);
        }
      }
    });

    test('SLbytes from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.int32List(1, i);
        global.throwOnError = false;
        for (var code in slVM1_nTag) {
          final e0 = SLbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('SLbytes from VM.k2_2n good values', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.int32List(2, 2);
        global.throwOnError = false;
        for (var code in slVM2_2nTags) {
          final e0 = SLbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('SLbytes from VM.k2_2n bad values length', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.int32List(1, 1);
        global.throwOnError = false;
        for (var code in slVM2_2nTags) {
          final e0 = SLbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, false);
        }
      }
    });
  });
}
