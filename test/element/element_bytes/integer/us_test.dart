//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:bytes_dicom/bytes_dicom.dart';
import 'package:core/server.dart' hide group;
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = RSG(seed: 1);
RNG rng = RNG(1);

void main() {
  Server.initialize(name: 'element_bytes/special_test', level: Level.info);
  const type = BytesElementType.leShortEvr;
  final rds = ByteRootDataset.empty();

  group('USbytes', () {
    //VM.k1
    const usVM1Tags = <int>[
      kFileSetConsistencyFlag,
      kDataSetType,
      kPrivateGroupReference,
      kWarningReason,
      kFailureReason,
      kPregnancyStatus,
      kNumberOfElements,
      kPreferredPlaybackSequencing,
      kContrastBolusAgentNumber,
      kReconstructionIndex,
      kLightPathFilterPassThroughWavelength,
      kStimuliRetestingQuantity,
      kImageDimensions,
      kPlanarConfiguration,
      kRows,
      kColumns,
      kPlanes,
      kBitsGrouped,
    ];

    //VM.k2
    const usVM2Tags = <int>[
      kSynchronizationChannel,
      kLightPathFilterPassBand,
      kImagePathFilterPassBand,
      kTopLeftHandCornerOfLocalizerArea,
      kBottomRightHandCornerOfLocalizerArea,
      kDisplayedAreaTopLeftHandCornerTrial,
      kDisplayedAreaBottomRightHandCornerTrial,
      kRelativeTime
    ];

    //VM.k3
    const usVM3Tags = <int>[
      kSubjectRelativePositionInImage,
      kShutterPresentationColorCIELabValue,
      kAlphaPaletteColorLookupTableDescriptor,
      kBlendingLookupTableDescriptor,
      kWaveformDisplayBackgroundCIELabValue,
      kChannelRecommendedDisplayCIELabValue,
      kRecommendedAbsentPixelCIELabValue,
      kRecommendedDisplayCIELabValue,
      kGraphicLayerRecommendedDisplayRGBValue,
      kTextColorCIELabValue,
      kShadowColorCIELabValue,
      kPatternOnColorCIELabValue,
      kPatternOffColorCIELabValue,
      kGraphicLayerRecommendedDisplayCIELabValue,
      kEmptyImageBoxCIELabValue,
      kEscapeTriplet,
      kRunLengthTriplet
    ];

    //VM.k1_n
    const usVM1nTags = <int>[
      kAcquisitionIndex,
      kPerimeterTable,
      kPredictorConstants,
      kFrameNumbersOfInterest,
      kMaskPointers,
      kRWavePointer,
      kMaskFrameNumbers,
      kReferencedFrameNumbers,
      kDetectorVector,
      kPhaseVector,
      kRotationVector,
      kRRIntervalVector,
      kTimeSlotVector,
      kSliceVector,
      kAngularViewVector,
      kSelectorUSValue
    ];
    test('USbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
        global.throwOnError = false;
        for (final code in usVM1Tags) {
          final e0 = USbytes.fromValues(code, vList0, type);
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

    test('USbytes from VM.k1 bad values length', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint16List(2, i + 1);
        global.throwOnError = false;
        for (final code in usVM1Tags) {
          final e0 = USbytes.fromValues(code, vList0, type);
          log.debug('e0: $e0');
          final e1 = ElementBytes.fromBytes(e0.be, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, false);
        }
      }
    });

    test('USbytes from VM.k2', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(2, 2);
        global.throwOnError = false;
        for (final code in usVM2Tags) {
          final e0 = USbytes.fromValues(code, vList0, type);
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

    test('USbytes from VM.k2 bad values length', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint16List(3, i + 2);
        global.throwOnError = false;
        for (final code in usVM1Tags) {
          final e0 = USbytes.fromValues(code, vList0, type);
          log.debug('e0: $e0');
          final e1 = ElementBytes.fromBytes(e0.be, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, false);
        }
      }
    });

    test('USbytes from VM.k3', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(3, 3);
        global.throwOnError = false;
        for (final code in usVM3Tags) {
          final e0 = USbytes.fromValues(code, vList0, type);
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

    test('USbytes from VM.k3 bad values length', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint16List(4, i + 3);
        global.throwOnError = false;
        for (final code in usVM1Tags) {
          final e0 = USbytes.fromValues(code, vList0, type);
          log.debug('e0: $e0');
          final e1 = ElementBytes.fromBytes(e0.be, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, false);
        }
      }
    });

    test('USbytes from VM.k4', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(4, 4);
        global.throwOnError = false;
        final e0 = USbytes.fromValues(kAcquisitionMatrix, vList0, type);
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
    });

    test('USbytes from VM.k4 bad values length', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint16List(5, i + 4);
        global.throwOnError = false;
        for (final code in usVM1Tags) {
          final e0 = USbytes.fromValues(code, vList0, type);
          log.debug('e0: $e0');
          final e1 = ElementBytes.fromBytes(e0.be, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, false);
        }
      }
    });

    test('USbytes from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint16List(1, i);
        global.throwOnError = false;
        for (final code in usVM1nTags) {
          final e0 = USbytes.fromValues(code, vList0, type);
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
  });
}