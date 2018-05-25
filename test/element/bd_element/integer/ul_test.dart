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
  Server.initialize(name: 'bd_element/special_test', level: Level.info);

  final rds = new ByteRootDataset.empty();

  group('ULbytes', () {
    //VM.k1
    const ulVM1Tags = const <int>[
      kMRDRDirectoryRecordOffset,
      kNumberOfReferences,
      kLengthToEnd,
      kTriggerSamplePosition,
      kRegionFlags,
      kPulseRepetitionFrequency,
      kDopplerSampleVolumeXPositionRetired,
      kDopplerSampleVolumeYPositionRetired,
      kTMLinePositionX0Retired,
      kTMLinePositionY0Retired,
      kTMLinePositionX1Retired,
      kTMLinePositionY1Retired,
      kPixelComponentMask,
      kNumberOfTableEntries,
      kSpectroscopyAcquisitionPhaseRows,
      kASLBolusCutoffDelayTime,
      kDataPointRows,
      kDataPointColumns,
      kNumberOfWaveformSamples,
      kNumberOfSurfacePoints,
      kGroup4Length,
      kGroup8Length,
      kGroup10Length,
      kGroup12Length
    ];

    //VM.k3
    const ulVM3Tags = const <int>[
      kGridDimensions,
    ];

    //VM.k1_n
    const ulVM1_nTags = const <int>[
      kSimpleFrameList,
      kReferencedSamplePositions,
      kRationalDenominatorValue,
      kReferencedContentItemIdentifier,
      kHistogramData,
      kSelectorULValue,
    ];

    test('ULbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        global.throwOnError = false;
        for (var code in ulVM1Tags) {
          final e0 = ULbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('ULbytes from VM.k3', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(3, 3);
        global.throwOnError = false;
        for (var code in ulVM3Tags) {
          final e0 = ULbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('ULbytes from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint32List(1, i);
        global.throwOnError = false;
        for(var code in ulVM1_nTags) {
          final e0 = ULbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });
  });
}
