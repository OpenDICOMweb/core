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

  const doubleList = <double>[
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

  //VM.k1
  const flVM1Tags = <int>[
    kRecommendedDisplayFrameRateInFloat,
    kExaminedBodyThickness,
    kDisplayedZValue,
    kCalciumScoringMassFactorPatient,
    kEnergyWeightingFactor,
    kDistanceSourceToIsocenter,
    kDistanceObjectToTableTop,
    kBeamAngle,
    kTableXPositionToIsocenter,
  ];

  //VM.k2
  const flVM2Tags = <int>[
    kLocalizingCursorPosition,
    kPixelDataAreaOriginRelativeToFOV,
    kObjectPixelSpacingInCenterOfBeam,
    kPositionOfIsocenterProjection,
    kAnatomicStructureReferencePoint,
    kRegisteredLocalizerTopLeftHandCorner,
    kMaskSubPixelShift,
    kCornealVertexLocation,
    kMaximumCornealCurvatureLocation,
    kBoundingBoxTopLeftHandCorner
  ];

  //VM.k3
  const flVM3Tags = <int>[
    kCalculatedTargetPosition,
    kCalciumScoringMassFactorDevice,
    kPointPositionAccuracy,
    kAxisOfRotation,
    kCenterOfRotation,
    kControlPointOrientation,
    kThreatROIBase,
    kThreatROIExtents,
    kCenterOfMass,
  ];

  //VM.k6
  const flVM6Tags = <int>[
    kPointsBoundingBoxCoordinates,
  ];

  //VM.6_n
  const flVM16Tags = <int>[kBoundingPolygon];

  //VM.k1_n
  const flVM1nTags = <int>[
    kTableOfParameterValues,
    kRWaveTimeVector,
    kFilterBeamPathLengthMinimum,
    kFilterBeamPathLengthMaximum,
    kVectorAccuracy,
    kSelectorFLValue,
    kScanSpotMetersetsDelivered,
    kIsocenterToCompensatorDistances,
    kScanSpotMetersetWeights,
  ];

  final float32List = Float32List.fromList(doubleList);

  final rds = ByteRootDataset.empty();
  global.throwOnError = false;

  // group('FL Tests', () {
  test('FL hasValidValues: good values', () {
    global.throwOnError = false;
    log.debug('vList: $float32List');
    final e0 = FLbytes.fromValues(kVectorAccuracy, doubleList);
    expect(e0.hasValidValues, true);
  });

  test('FL hasValidValues random: good values', () {
    for (var i = 0; i < 10; i++) {
      final vList = rng.float32List(1, 10);
      expect(vList is Float32List, true);
      final e0 = FLbytes.fromValues(kSelectorFDValue, vList);
      expect(e0[0], equals(vList[0]));
      expect(e0.hasValidValues, true);

      log
        ..debug('e0: $e0, values: ${e0.values}')
        ..debug('e0: $e0')
        ..debug('float32List: $vList')
        ..debug('        e0: ${e0.values}');
      expect(e0.values, equals(vList));
    }
  });

  test('FL hasValidValues: good values', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.float32List(2, 2);
      final e0 = FLbytes.fromValues(kCornealVertexLocation, vList0);
      log..debug('$i: e0: $e0, values: ${e0.values}')..debug('e0: $e0');
      final e1 = FLtag(e0.tag, e0.values);
      log..debug('$i: e0: $e1, values: ${e1.values}')..debug('e0: ${e1.info}');
      expect(e1.hasValidValues, true);

      expect(e1[0], equals(vList0[0]));
    }
  });

  test('FL hasValidValues: bad values', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.float32List(3, 4);
      log.debug('$i: float32List: $vList0');
      final flbd = FLbytes.fromValues(kCornealVertexLocation, vList0);
      final e0 = FLtag(flbd.tag, flbd.values);
      expect(e0, isNull);
    }
  });

  test('FL [] as values', () {
    final e0 = FLbytes.fromValues(kTableOfParameterValues, []);
    expect(e0.hasValidValues, true);
    expect(e0.values, equals(<double>[]));
  });

  // Can't create Evr/Ivr with null values
  // test('FL null as values', () {});

  test('FL hashCode and == random', () {
    global.throwOnError = false;
    log.debug('FL hashCode and ==');
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.float32List(1, 1);
      final e0 = FLbytes.fromValues(kAbsoluteChannelDisplayScale, vList0);

      //bd = FLbytes.fromValues(kAbsoluteChannelDisplayScale, vList0);
      final e1 = FLbytes.fromValues(kAbsoluteChannelDisplayScale, vList0);
      log
        ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
        ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);

      final vList1 = rng.float32List(1, 1);
      final e2 =
          FLbytes.fromValues(kRecommendedDisplayFrameRateInFloat, vList1);
      log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);

      final vList2 = rng.float32List(2, 2);
      final e3 = FLbytes.fromValues(kCornealVertexLocation, vList2);

      log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
      expect(e0.hashCode == e3.hashCode, false);
      expect(e0 == e3, false);

      final vList3 = rng.float32List(3, 3);
      final e4 = FLbytes.fromValues(kCornealPointLocation, vList3);
      log.debug('vList3:$vList3 , e4.hash_code:${e4.hashCode}');
      expect(e0.hashCode == e4.hashCode, false);
      expect(e0 == e4, false);

      final vList4 = rng.float32List(6, 6);
      final e5 = FLbytes.fromValues(kPointsBoundingBoxCoordinates, vList4);

      log.debug('vList4:$vList4 , e5.hash_code:${e5.hashCode}');
      expect(e0.hashCode == e5.hashCode, false);
      expect(e0 == e5, false);

      final vList5 = rng.float32List(2, 3);
      final e6 = FLbytes.fromValues(kFractionalChannelDisplayScale, vList5);
      log.debug('vList5:$vList5 , e6.hash_code:${e6.hashCode}');
      expect(e1.hashCode == e6.hashCode, false);
      expect(e1 == e6, false);
    }
  });

  test('Create FL.isValidValues', () {
    global.throwOnError = false;
    for (var i = 0; i <= doubleList.length - 1; i++) {
      final e0 =
          FLbytes.fromValues(kExaminedBodyThickness, <double>[doubleList[i]]);
      log.debug('e0: $e0');
      expect(FL.isValidValues(PTag.kExaminedBodyThickness, e0.values), true);
    }
  });

  test('FLbytes from VM.k1', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.float64List(1, 1);
      global.throwOnError = false;
      for (final code in flVM1Tags) {
        final e0 = FLbytes.fromValues(code, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.fromBytes(e0.bytes, rds, isEvr: true);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);

        expect(e1.hasValidValues, true);
        expect(e1 == e0, true);
        expect(e1.vfBytes == e0.vfBytes, true);

        expect(e0.code == e0.bytes.code, true);
        expect(e0.eLength == e0.bytes.eLength, true);
        expect(e0.vrCode == e0.bytes.vrCode, true);
        expect(e0.vrIndex == e0.bytes.vrIndex, true);
        expect(e0.vfLengthOffset == e0.bytes.vfLengthOffset, true);
        expect(e0.vfLengthField == e0.bytes.vfLengthField, true);
        expect(e0.vfLength == e0.bytes.vfLength, true);
        expect(e0.vfOffset == e0.bytes.vfOffset, true);
        expect(e0.vfBytes == e0.bytes.vfBytes, true);
        expect(e0.vfBytesLast == e0.bytes.vfBytesLast, true);
      }
    }
  });

  test('FLbytes from VM.k2', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.float64List(2, 2);
      global.throwOnError = false;
      for (final code in flVM2Tags) {
        final e0 = FLbytes.fromValues(code, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.fromBytes(e0.bytes, rds, isEvr: true);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);

        expect(e1.hasValidValues, true);
        expect(e1 == e0, true);
        expect(e1.vfBytes == e0.vfBytes, true);

        expect(e0.code == e0.bytes.code, true);
        expect(e0.eLength == e0.bytes.eLength, true);
        expect(e0.vrCode == e0.bytes.vrCode, true);
        expect(e0.vrIndex == e0.bytes.vrIndex, true);
        expect(e0.vfLengthOffset == e0.bytes.vfLengthOffset, true);
        expect(e0.vfLengthField == e0.bytes.vfLengthField, true);
        expect(e0.vfLength == e0.bytes.vfLength, true);
        expect(e0.vfOffset == e0.bytes.vfOffset, true);
        expect(e0.vfBytes == e0.bytes.vfBytes, true);
        expect(e0.vfBytesLast == e0.bytes.vfBytesLast, true);
      }
    }
  });

  test('FLbytes from VM.k3', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.float64List(3, 3);
      global.throwOnError = false;
      for (final code in flVM3Tags) {
        final e0 = FLbytes.fromValues(code, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.fromBytes(e0.bytes, rds, isEvr: true);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);

        expect(e1.hasValidValues, true);
        expect(e1 == e0, true);
        expect(e1.vfBytes == e0.vfBytes, true);

        expect(e0.code == e0.bytes.code, true);
        expect(e0.eLength == e0.bytes.eLength, true);
        expect(e0.vrCode == e0.bytes.vrCode, true);
        expect(e0.vrIndex == e0.bytes.vrIndex, true);
        expect(e0.vfLengthOffset == e0.bytes.vfLengthOffset, true);
        expect(e0.vfLengthField == e0.bytes.vfLengthField, true);
        expect(e0.vfLength == e0.bytes.vfLength, true);
        expect(e0.vfOffset == e0.bytes.vfOffset, true);
        expect(e0.vfBytes == e0.bytes.vfBytes, true);
        expect(e0.vfBytesLast == e0.bytes.vfBytesLast, true);
      }
    }
  });

  test('FLbytes from VM.k6', () {
    for (var i = 0; i < 10; i++) {
      final vList0 = rng.float64List(6, 6);
      global.throwOnError = false;
      for (final code in flVM6Tags) {
        final e0 = FLbytes.fromValues(code, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.fromBytes(e0.bytes, rds, isEvr: true);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);

        expect(e1.hasValidValues, true);
        expect(e1 == e0, true);
        expect(e1.vfBytes == e0.vfBytes, true);

        expect(e0.code == e0.bytes.code, true);
        expect(e0.eLength == e0.bytes.eLength, true);
        expect(e0.vrCode == e0.bytes.vrCode, true);
        expect(e0.vrIndex == e0.bytes.vrIndex, true);
        expect(e0.vfLengthOffset == e0.bytes.vfLengthOffset, true);
        expect(e0.vfLengthField == e0.bytes.vfLengthField, true);
        expect(e0.vfLength == e0.bytes.vfLength, true);
        expect(e0.vfOffset == e0.bytes.vfOffset, true);
        expect(e0.vfBytes == e0.bytes.vfBytes, true);
        expect(e0.vfBytesLast == e0.bytes.vfBytesLast, true);
      }
    }
  });

  test('FLbytes from VM.k1_n', () {
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.float64List(1, i);
      global.throwOnError = false;
      for (final code in flVM1nTags) {
        final e0 = FLbytes.fromValues(code, vList0);
        final e1 = ByteElement.fromBytes(e0.bytes, rds, isEvr: true);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);

        expect(e1.hasValidValues, true);
        expect(e1 == e0, true);
        expect(e1.vfBytes == e0.vfBytes, true);

        expect(e0.code == e0.bytes.code, true);
        expect(e0.eLength == e0.bytes.eLength, true);
        expect(e0.vrCode == e0.bytes.vrCode, true);
        expect(e0.vrIndex == e0.bytes.vrIndex, true);
        expect(e0.vfLengthOffset == e0.bytes.vfLengthOffset, true);
        expect(e0.vfLengthField == e0.bytes.vfLengthField, true);
        expect(e0.vfLength == e0.bytes.vfLength, true);
        expect(e0.vfOffset == e0.bytes.vfOffset, true);
        expect(e0.vfBytes == e0.bytes.vfBytes, true);
        expect(e0.vfBytesLast == e0.bytes.vfBytesLast, true);
      }
    }
  });

  test('FLbytes from VM.k1_n6', () {
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.float64List(6, 6);
      global.throwOnError = false;
      for (final code in flVM16Tags) {
        final e0 = FLbytes.fromValues(code, vList0);
        final e1 = ByteElement.fromBytes(e0.bytes, rds, isEvr: true);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);

        expect(e1.hasValidValues, true);
        expect(e1 == e0, true);
        expect(e1.vfBytes == e0.vfBytes, true);

        expect(e0.code == e0.bytes.code, true);
        expect(e0.eLength == e0.bytes.eLength, true);
        expect(e0.vrCode == e0.bytes.vrCode, true);
        expect(e0.vrIndex == e0.bytes.vrIndex, true);
        expect(e0.vfLengthOffset == e0.bytes.vfLengthOffset, true);
        expect(e0.vfLengthField == e0.bytes.vfLengthField, true);
        expect(e0.vfLength == e0.bytes.vfLength, true);
        expect(e0.vfOffset == e0.bytes.vfOffset, true);
        expect(e0.vfBytes == e0.bytes.vfBytes, true);
        expect(e0.vfBytesLast == e0.bytes.vfBytesLast, true);
      }
    }
  });

  test('FLbytes from VM.k1_n', () {
    for (var i = 1; i < 10; i++) {
      final vList0 = rng.float64List(1, i);
      global.throwOnError = false;
      for (final code in flVM1nTags) {
        final e0 = FLbytes.fromValues(code, vList0);
        final e1 = ByteElement.fromBytes(e0.bytes, rds, isEvr: true);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);

        expect(e1.hasValidValues, true);
        expect(e1 == e0, true);
        expect(e1.vfBytes == e0.vfBytes, true);

        expect(e0.code == e0.bytes.code, true);
        expect(e0.eLength == e0.bytes.eLength, true);
        expect(e0.vrCode == e0.bytes.vrCode, true);
        expect(e0.vrIndex == e0.bytes.vrIndex, true);
        expect(e0.vfLengthOffset == e0.bytes.vfLengthOffset, true);
        expect(e0.vfLengthField == e0.bytes.vfLengthField, true);
        expect(e0.vfLength == e0.bytes.vfLength, true);
        expect(e0.vfOffset == e0.bytes.vfOffset, true);
        expect(e0.vfBytes == e0.bytes.vfBytes, true);
        expect(e0.vfBytesLast == e0.bytes.vfBytesLast, true);
      }
    }
  });

  test('FLbytes', () {
    final vList = <double>[1, 1.1, 1.2];
    final e0 = FLbytes.fromValues(kSelectorFLValue, vList);
    expect(e0.bytes is BytesDicom, true);
    expect(e0.vfBytes is Bytes, true);
    expect(e0.hasValidValues, true);
    expect(e0.vfByteData is ByteData, true);
    expect(e0.lengthInBytes == e0.values.length * 4, true);
    expect(e0.isValid, true);
    expect(e0.isEmpty, false);

    final e1 = FLbytes(e0.bytes);
    expect(e1.bytes is BytesDicom, true);
    expect(e1.vfBytes is Bytes, true);
    expect(e1.hasValidValues, true);
    expect(e1.vfByteData is ByteData, true);
    expect(e1.lengthInBytes == e1.values.length * 4, true);
    expect(e1.isValid, true);
    expect(e1.isEmpty, false);
  });
}
