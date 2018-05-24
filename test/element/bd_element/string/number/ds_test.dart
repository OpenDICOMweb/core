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

  group('DSbytes', () {
    global.throwOnError = false;

    //VM.k1
    const dsVM1Tags = const <int>[
      kPatientSize,
      kPatientWeight,
      kOuterDiameter,
      kInnerDiameter,
      kDVHMinimumDose,
      kDVHMaximumDose,
      kROIVolume,
      kROIPhysicalPropertyValue,
      kMeasuredDoseValue,
      kSpecifiedTreatmentTime,
      kDeliveredMeterset,
      kEndMeterset
    ];

    //VM.k2
    const dsVM2Tags = const <int>[
      kImagerPixelSpacing,
      kNominalScannedPixelSpacing,
      kDetectorBinning,
      kDetectorElementPhysicalSize,
      kDetectorElementSpacing,
      kFieldOfViewOrigin,
      kPixelSpacing,
      kZoomCenter,
      kPresentationPixelSpacing,
      kImagePlanePixelSpacing
    ];

    //VM.k2_2n
    const dsVM2_2nTags = const <int>[kDVHData];

    //VM.k3
    const dsVM3Tags = const <int>[
      kImageTranslationVector,
      kImagePosition,
      kImagePositionPatient,
      kXRayImageReceptorTranslation,
      kNormalizationPoint,
      kDVHNormalizationPoint,
      kDoseReferencePointCoordinates,
      kIsocenterPosition
    ];

    //VM.k3_3n
    const dsVM3_3nTags = const <int>[kLeafPositionBoundaries, kContourData];

    //VM.k4
    const dsVM4Tags = const <int>[
      kDoubleExposureFieldDeltaTrial,
      kDiaphragmPosition
    ];

    //VM.k6
    const dsVM6Tags = const <int>[
      kPRCSToRCSOrientation,
      kImageTransformationMatrix,
      kImageOrientation,
      kImageOrientationPatient,
      kImageOrientationSlide
    ];

    //VM.k1_n
    const dsVM1_nTags = const <int>[
      kMaterialThickness,
      kMaterialIsolationDiameter,
      kCoordinateSystemTransformTranslationMatrix,
      kDACGainPoints,
      kDACTimePoints,
      kEnergyWindowTotalWidth,
      kContrastFlowRate,
      kFrameTimeVector,
      kTableVerticalIncrement,
      kRotationOffset,
      kFocalSpots,
      kPositionerPrimaryAngleIncrement,
      kPositionerSecondaryAngleIncrement,
      kFramePrimaryAngleVector,
    ];

    test('DSbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        var vList = rsg.getDSList(1, 1);
        vList = [vList[0].trim()];
        for (var code in dsVM1Tags) {
          final e0 = DSbytes.fromValues(code, vList);
          log.debug('ds0:$e0');
          expect(e0.hasValidValues, true);

          log.debug('e0:$e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e1.hasValidValues, true);
        }
      }
    });

    test('DSbytes from VM.k2', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(2, 2);
        for (var code in dsVM2Tags) {
          final e0 = DSbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e1.hasValidValues, true);
        }
      }
    });

    test('DSbytes from VM.k2 bad length', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getDSList(3, 3);
        for (var code in dsVM2Tags) {
          final e0 = DSbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e1.hasValidValues, false);
        }
      }
    });

    test('DSbytes from VM.k3', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(3, 3);
        for (var code in dsVM3Tags) {
          final e0 = DSbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e1.hasValidValues, true);
        }
      }
    });

    test('DSbytes from VM.k3 bad length', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(4, 4);
        for (var code in dsVM3Tags) {
          final e0 = DSbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e1.hasValidValues, false);
        }
      }
    });

    test('DSbytes from VM.k4', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(4, 4);
        for (var code in dsVM4Tags) {
          final e0 = DSbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('DSbytes from VM.k4 bad length', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(5, 5);
        for (var code in dsVM4Tags) {
          final e0 = DSbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, false);
        }
      }
    });

    test('DSbytes from VM.k6', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(6, 6);
        for (var code in dsVM6Tags) {
          final e0 = DSbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('DSbytes from VM.k6 bad length', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(7, 7);
        for (var code in dsVM6Tags) {
          final e0 = DSbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, false);
        }
      }
    });

    test('DSbytes from VM.k1_n', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getDSList(1, i);
        for (var code in dsVM1_nTags) {
          final e0 = DSbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('DSbytes from VM.k1_2', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList = rsg.getDSList(1, 2);
        final e0 = DSbytes.fromValues(kDetectorActiveDimensions, vList);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('DSbytes from VM.k2_2n', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(10, 10);
        for (var code in dsVM2_2nTags) {
          final e0 = DSbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('DSbytes from VM.k3_3n', () {
      global.throwOnError = false;

      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getDSList(9, 9);
        for (var code in dsVM3_3nTags) {
          final e0 = DSbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });
  });
}
