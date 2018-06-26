//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/server.dart' hide group;
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = new RSG(seed: 1);
RNG rng = new RNG(1);

void main() {
  Server.initialize(name: 'bd_element/special_test', level: Level.info);

  final rds = new ByteRootDataset.empty();

  group('ATbytes', () {
    //VM.k1
    const atVM1Tags = const <int>[
      kDimensionIndexPointer,
      kFunctionalGroupPointer,
      kSelectorAttribute,
      kAttributeOccurrencePointer,
      kParameterSequencePointer,
      kOverrideParameterPointer,
      kParameterPointer,
    ];

    //VM.k1_n
    const atVM1_nTags = const <int>[
      kOriginalImageIdentification,
      kFrameIncrementPointer,
      kFrameDimensionPointer,
      kCompressionStepPointers,
      kDetailsOfCoefficients,
      kDataBlock,
      kZonalMapLocation,
      kCodeTableLocation,
      kImageDataLocation,
      kSelectorSequencePointer,
      kSelectorATValue,
      kFailureAttributes,
      kOverlayCompressionStepPointers,
      kOverlayCodeTableLocation,
      kCoefficientCodingPointers,
    ];

    test('ATbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        global.throwOnError = false;
        for (var code in atVM1Tags) {
          final e0 = ATbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('ATbytes from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint32List(1, i);
        global.throwOnError = false;
        for (var code in atVM1_nTags) {
          final e0 = ATbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });
  });
}
