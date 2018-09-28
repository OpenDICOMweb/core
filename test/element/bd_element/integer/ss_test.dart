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

RSG rsg = RSG(seed: 1);
RNG rng = RNG(1);

void main() {
  Server.initialize(name: 'bd_element/special_test', level: Level.info);

  final rds = ByteRootDataset.empty();

  group('SSbytes', () {
    //VM.k1
    const ssVM1Tags = <int>[
      kTagAngleSecondAxis,
      kExposureControlSensingRegionLeftVerticalEdge,
      kExposureControlSensingRegionRightVerticalEdge,
      kExposureControlSensingRegionUpperHorizontalEdge,
      kExposureControlSensingRegionLowerHorizontalEdge,
      kPixelIntensityRelationshipSign,
      kTIDOffset,
      kOCTZOffsetCorrection,
    ];

    //VM.k2
    const ssVM2Tags = <int>[
      kOverlayOrigin,
      kAbstractPriorValue,
      kVisualAcuityModifiers,
      kCenterOfCircularExposureControlSensingRegion
    ];

    //VM.k1_n
    const ssVM1nTags = <int>[kSelectorSSValue];

    test('SSbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int16List(1, 1);
        global.throwOnError = false;
        for (var code in ssVM1Tags) {
          final e0 = SSbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('SSbytes from VM.k2', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int16List(2, 2);
        global.throwOnError = false;
        for (var code in ssVM2Tags) {
          final e0 = SSbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('SSbytes from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.int16List(1, i);
        global.throwOnError = false;
        for (var code in ssVM1nTags) {
          final e0 = SSbytes.fromValues(code, vList0);
          log.debug('e0: $e0');

          final e1 = ByteElement.makeFromBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });
  });
}
