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
  final rng = RNG(1);
  global.throwOnError = false;
  global.doTestElementValidity = false;

  List<double> invalidVList;

  setUp(() {
    invalidVList = rng.float32List(FL.kMaxLength + 1, FL.kMaxLength + 1);
  });

  tearDown(() {
    // remove garbage!
    invalidVList = [];
  });

  const goodFloatList = <double>[
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

  final goodFloat32List = Float32List.fromList(goodFloatList);

  group('FLtag', () {
    test('FL hasValidValues good values', () {
      global.throwOnError = false;
      final e0 = FLtag(PTag.kVectorAccuracy, goodFloat32List);
      expect(e0.hasValidValues, true);

      // empty list and null as values
      final e1 = FLtag(PTag.kTableOfParameterValues, []);
      expect(e1.hasValidValues, true);
      expect(e1.values, equals(<double>[]));
    });

    test('FL hasValidValues bad values', () {
      global.throwOnError = false;
      global.doTestElementValidity = true;
      final e0 = FLtag(PTag.kTableOfParameterValues, null);
      log.debug('e0 : $e0 ');
      expect(e0, isNull);

      global.throwOnError = true;
      expect(() => FLtag(PTag.kTableOfParameterValues, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('FL hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        expect(vList is Float32List, true);
        final e0 = FLtag(PTag.kAbsoluteChannelDisplayScale, vList);
        expect(e0.hasValidValues, true);

        log
          ..debug('e0 : $e0 , values: ${e0.values}')
          ..debug('e0 : $e0')
          ..debug('float32List: $vList ')
          ..debug('        e0 : ${e0.values}');
        expect(e0.values, equals(vList));
      }

      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(2, 2);
        final e0 = FLtag(PTag.kCornealVertexLocation, vList);
        expect(e0.hasValidValues, true);

        log..debug('e0 : $e0 , values: ${e0.values}')..debug('e0 : $e0');
        expect(e0[0], equals(vList[0]));
      }
    });
  });

  group('FL bad values', () {
    test('FL hasValidValues bad values random', () {
      global.doTestElementValidity = true;
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(3, 4);
        log.debug('$i: float32List: $vList ');
        final e0 = FLtag(PTag.kCornealVertexLocation, vList);
        expect(e0, isNull);
      }

      global.throwOnError = true;
      final vList = rng.float32List(3, 4);
      expect(() => FLtag(PTag.kCornealVertexLocation, vList),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('FL update random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(3, 4);
        final e1 = FLtag(PTag.kTableOfParameterValues, vList);
        final float32List1 = rng.float32List(3, 4);
        expect(e1.update(float32List1).values, equals(float32List1));
      }
    });

    test('FL update', () {
      final e0 = FLtag(PTag.kTableOfParameterValues, []);
      expect(e0.update([1.0, 2.0]).values, equals([1.0, 2.0]));

      final e1 = FLtag(PTag.kTableOfParameterValues, goodFloat32List);
      expect(e1.update(goodFloat32List).values, equals(goodFloat32List));

      const floatUpdateValues = <double>[
        546543.674, 6754764.45887, 54698.52, 787354.734768 // No reformat
      ];

      final float32UpdateValues = Float32List.fromList(floatUpdateValues);

      for (var i = 1; i <= float32UpdateValues.length - 1; i++) {
        final fl2 = FLtag(PTag.kSelectorFLValue,
            Float32List.fromList(float32UpdateValues.take(i).toList()));

        expect(
            fl2.update(
                Float32List.fromList(float32UpdateValues.take(i).toList())),
            equals(Float32List.fromList(float32UpdateValues.take(i).toList())));

        expect(fl2.update(float32UpdateValues.take(i).toList()).values,
            equals(float32UpdateValues.take(i).toList()));
      }
      final fl2 = FLtag(PTag.kSelectorFLValue,
          Float32List.fromList(float32UpdateValues.take(1).toList()));
      expect([fl2.values.elementAt(0)],
          equals(Float32List.fromList(float32UpdateValues.take(1).toList())));
      log.debug(fl2.view());
    });

    test('FL noValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(3, 4);
        final e0 = FLtag(PTag.kTableOfParameterValues, vList);
        log.debug('e0 : ${e0.noValues}');
        expect(e0.noValues.values.isEmpty, true);
      }
    });

    test('FL noValues', () {
      final e0 = FLtag(PTag.kTableOfParameterValues, []);
      final FLtag flNoValues = e0.noValues;
      expect(flNoValues.values.isEmpty, true);
      log.debug('e0 : ${e0.noValues}');

      final e1 = FLtag(PTag.kTableOfParameterValues, goodFloat32List);
      log.debug('e1: $e1');
      expect(flNoValues.values.isEmpty, true);
      log.debug('e0 : ${e0.noValues}');
    });

    test('FL copy random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(3, 4);
        final e0 = FLtag(PTag.kTableOfParameterValues, vList);
        final FLtag e1 = e0.copy;
        expect(e1 == e0, true);
        expect(e1.hashCode == e0.hashCode, true);
      }
    });

    test('FL copy', () {
      final e0 = FLtag(PTag.kTableOfParameterValues, []);
      final FLtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      final fl2 = FLtag(PTag.kTableOfParameterValues, goodFloat32List);
      final FLtag fl3 = fl2.copy;
      expect(fl3 == fl2, true);
      expect(fl3.hashCode == fl2.hashCode, true);
    });

    test('FL hashCode and == good values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final e0 = FLtag(PTag.kAbsoluteChannelDisplayScale, vList);
        final e1 = FLtag(PTag.kAbsoluteChannelDisplayScale, vList);
        log
          ..debug('vList:$vList, e0 .hash_code:${e0.hashCode}')
          ..debug('vList:$vList, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('FL hashCode and == bad values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final e0 = FLtag(PTag.kAbsoluteChannelDisplayScale, vList);
        final e1 = FLtag(PTag.kAbsoluteChannelDisplayScale, vList);

        final vList1 = rng.float32List(1, 1);
        final fl2 = FLtag(PTag.kRecommendedDisplayFrameRateInFloat, vList1);
        log.debug('vList1:$vList1 , fl2.hash_code:${fl2.hashCode}');
        expect(e0.hashCode == fl2.hashCode, false);
        expect(e0 == fl2, false);

        final vLIst2 = rng.float32List(2, 2);
        final fl3 = FLtag(PTag.kCornealVertexLocation, vLIst2);
        log.debug('floatList2:$vLIst2 , fl3.hash_code:${fl3.hashCode}');
        expect(e0.hashCode == fl3.hashCode, false);
        expect(e0 == fl3, false);

        final vList3 = rng.float32List(3, 3);
        final fl4 = FLtag(PTag.kCornealPointLocation, vList3);
        log.debug('floatList3:$vList3 , fl4.hash_code:${fl4.hashCode}');
        expect(e0.hashCode == fl4.hashCode, false);
        expect(e0 == fl4, false);

        final vList4 = rng.float32List(6, 6);
        final fl5 = FLtag(PTag.kPointsBoundingBoxCoordinates, vList4);
        log.debug('floatList4:$vList4 , fl5.hash_code:${fl5.hashCode}');
        expect(e0.hashCode == fl5.hashCode, false);
        expect(e0 == fl5, false);

        final vList5 = rng.float32List(2, 3);
        final fl6 = FLtag(PTag.kFractionalChannelDisplayScale, vList5);
        log.debug('floatList5:$vList5 , fl6.hash_code:${fl6.hashCode}');
        expect(e1.hashCode == fl6.hashCode, false);
        expect(e1 == fl6, false);
      }
    });

    test('FL hashCode and == good values ', () {
      global.throwOnError = false;
      final e0 =
          FLtag(PTag.kAbsoluteChannelDisplayScale, goodFloat32List.take(1));
      final e1 =
          FLtag(PTag.kAbsoluteChannelDisplayScale, goodFloat32List.take(1));
      log
        ..debug(
            'listFloat32Common0:$goodFloat32List, e0 .hash_code:${e0.hashCode}')
        ..debug(
            'listFloat32Common0:$goodFloat32List, e1.hash_code:${e1.hashCode}');
      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);
    });

    test('FL hashCode and == bad values ', () {
      global.throwOnError = false;
      final e0 =
          FLtag(PTag.kAbsoluteChannelDisplayScale, goodFloat32List.take(1));

      final fl2 = FLtag(
          PTag.kRecommendedDisplayFrameRateInFloat, goodFloat32List.take(1));
      log.debug('listFloat32Common0:$goodFloat32List , '
          'fl2.hash_code:${fl2.hashCode}');
      expect(e0.hashCode == fl2.hashCode, false);
      expect(e0 == fl2, false);

      final fl3 = FLtag(PTag.kCornealVertexLocation, goodFloat32List.take(2));
      log.debug('listFloat32Common0:$goodFloat32List , '
          'fl3.hash_code:${fl3.hashCode}');
      expect(e0.hashCode == fl3.hashCode, false);
      expect(e0 == fl3, false);

      final fl4 = FLtag(PTag.kCornealPointLocation, goodFloat32List.take(3));
      log.debug('listFloat32Common0:$goodFloat32List , '
          'fl4.hash_code:${fl4.hashCode}');
      expect(e0.hashCode == fl4.hashCode, false);
      expect(e0 == fl4, false);

      final fl5 =
          FLtag(PTag.kPointsBoundingBoxCoordinates, goodFloat32List.take(6));
      log.debug('listFloat32Common0:$goodFloat32List , '
          'fl5.hash_code:${fl5.hashCode}');
      expect(e0.hashCode == fl5.hashCode, false);
      expect(e0 == fl5, false);

      final fl6 = FLtag(PTag.kSelectorFLValue, goodFloat32List);
      log.debug('listFloat32Common0:$goodFloat32List , '
          'fl6.hash_code:${fl6.hashCode}');
      expect(e0.hashCode == fl6.hashCode, false);
      expect(e0 == fl6, false);
    });

    test('FL replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final e0 = FLtag(PTag.kAbsoluteChannelDisplayScale, vList);
        final vList1 = rng.float32List(1, 1);
        expect(e0.replace(vList1), equals(vList));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rng.float32List(1, 1);
      final e1 = FLtag(PTag.kAbsoluteChannelDisplayScale, vList1);
      expect(e1.replace(<double>[]), equals(vList1));
      expect(e1.values, equals(<double>[]));

      final fl2 = FLtag(PTag.kAbsoluteChannelDisplayScale, vList1);
      expect(fl2.replace(null), equals(vList1));
      expect(fl2.values, equals(<double>[]));
    });

    test('FL fromUint8List good values', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final bytes = Bytes.typedDataView(vList);
        final e0 = FLtag.fromBytes(PTag.kAbsoluteChannelDisplayScale, bytes);
        log.debug('e0 : ${e0.info}');
        expect(e0.hasValidValues, true);
      }
    });

    test('FL fromUint8List bad values', () {
      global.doTestElementValidity = false;
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(3, 3);
        final bytes = Bytes.typedDataView(vList);
        final e1 = FLtag.fromBytes(PTag.kAbsoluteChannelDisplayScale, bytes);
        log.debug('e1: $e1');
        expect(e1.hasValidValues, false);
      }
    });

    test('FL fromBytes good values', () {
      global.doTestElementValidity = true;
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 10);
        final bytes = Bytes.typedDataView(vList);
        final e0 = FLtag.fromBytes(PTag.kSelectorFLValue, bytes);
        log.debug('e0 : ${e0.info}');
        expect(e0.hasValidValues, true);
      }
    });

    test('FL fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.float32List(1, 10);
        final bytes = Bytes.typedDataView(vList);
        final e0 = FLtag.fromBytes(PTag.kSelectorSSValue, bytes);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => FLtag.fromBytes(PTag.kSelectorSSValue, bytes),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('FL fromValues', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final e = FLtag.fromValues(PTag.kAbsoluteChannelDisplayScale, vList);
        log.debug('e: $e');
        expect(e.hasValidValues, true);

        final make1 =
            FLtag.fromValues(PTag.kAbsoluteChannelDisplayScale, <double>[]);
        expect(make1.hasValidValues, true);
        expect(make1.values, equals(<double>[]));
      }
    });

    test('FL bad fromValues', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(2, 2);
        global.throwOnError = false;
        final e = FLtag.fromValues(PTag.kAbsoluteChannelDisplayScale, vList);
        expect(e, isNull);

        global.throwOnError = true;
        expect(() => FLtag.fromValues(PTag.kAbsoluteChannelDisplayScale, vList),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('Create Elements from floating values(FL)', () {
      const f32Values = <double>[2047.99, 2437.437, 764.53];

      final e0 = FLtag(PTag.kRecommendedDisplayFrameRateInFloat,
          Float32List.fromList(f32Values.take(1).toList()));
      expect(e0.values.first.toStringAsPrecision(1),
          equals(2047.99.toStringAsPrecision(1)));
    });
  });

  group('FL Element', () {
    //VM.k1
    const flVM1Tags = <PTag>[
      PTag.kRecommendedDisplayFrameRateInFloat,
      PTag.kExaminedBodyThickness,
      PTag.kDisplayedZValue,
      PTag.kCalciumScoringMassFactorPatient,
      PTag.kEnergyWeightingFactor,
      PTag.kDistanceSourceToIsocenter,
      PTag.kDistanceObjectToTableTop,
      PTag.kBeamAngle,
      PTag.kTableXPositionToIsocenter,
    ];

    //VM.k2
    const flVM2Tags = <PTag>[
      PTag.kLocalizingCursorPosition,
      PTag.kPixelDataAreaOriginRelativeToFOV,
      PTag.kObjectPixelSpacingInCenterOfBeam,
      PTag.kPositionOfIsocenterProjection,
      PTag.kAnatomicStructureReferencePoint,
      PTag.kRegisteredLocalizerTopLeftHandCorner,
      PTag.kMaskSubPixelShift,
      PTag.kCornealVertexLocation,
      PTag.kMaximumCornealCurvatureLocation,
      PTag.kBoundingBoxTopLeftHandCorner
    ];

    //VM.k3
    const flVM3Tags = <PTag>[
      PTag.kCalculatedTargetPosition,
      PTag.kCalciumScoringMassFactorDevice,
      PTag.kPointPositionAccuracy,
      PTag.kAxisOfRotation,
      PTag.kCenterOfRotation,
      PTag.kControlPointOrientation,
      PTag.kThreatROIBase,
      PTag.kThreatROIExtents,
      PTag.kCenterOfMass,
    ];

    //VM.k6
    const flVM6Tags = <PTag>[
      PTag.kPointsBoundingBoxCoordinates,
    ];

    //VM.k1_n
    const flVM1_nTags = <PTag>[
      PTag.kTableOfParameterValues,
      PTag.kRWaveTimeVector,
      PTag.kFilterBeamPathLengthMinimum,
      PTag.kFilterBeamPathLengthMaximum,
      PTag.kVectorAccuracy,
      PTag.kSelectorFLValue,
      PTag.kScanSpotMetersetsDelivered,
      PTag.kIsocenterToCompensatorDistances,
      PTag.kScanSpotMetersetWeights,
    ];

    //VM.6_n
    const flVM1_6Tags = <PTag>[PTag.kBoundingPolygon];

    const nonFLTags = <PTag>[
      PTag.kNumberOfIterations,
      PTag.kAcquisitionProtocolName,
      PTag.kCTDIvol,
      PTag.kCTPositionSequence,
      PTag.kAcquisitionType,
      PTag.kPerformedStationAETitle,
      PTag.kSelectorSTValue,
      PTag.kDate,
      PTag.kTime
    ];

    test('FL isValidTag good values', () {
      global.throwOnError = false;
      expect(FL.isValidTag(PTag.kSelectorFLValue), true);

      for (var tag in flVM1Tags) {
        final validT0 = FL.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('FL isValidTag bad values', () {
      global.throwOnError = false;
      expect(FL.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => FL.isValidTag(PTag.kSelectorFDValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in nonFLTags) {
        global.throwOnError = false;
        final validT0 = FL.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => FL.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('FL isValidVR good values', () {
      global.throwOnError = false;
      expect(FL.isValidVR(kFLIndex), true);

      for (var s in flVM1Tags) {
        global.throwOnError = false;
        expect(FL.isValidVR(s.vrIndex), true);
      }
    });

    test('FL isValidVR bad values', () {
      global.throwOnError = false;
      expect(FL.isValidVR(kAEIndex), false);

      global.throwOnError = true;
      expect(() => FL.isValidVR(kAEIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var s in nonFLTags) {
        global.throwOnError = false;
        expect(FL.isValidVR(s.vrIndex), false);

        global.throwOnError = true;
        expect(() => FL.isValidVR(s.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('FL isValidLength VM.k1 good values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rng.float32List(1, 1);
        global.throwOnError = false;
        for (var tag in flVM1Tags) {
          expect(FL.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FL isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rng.float32List(2, i + 1);
        for (var tag in flVM1Tags) {
          global.throwOnError = false;
          expect(FL.isValidLength(tag, validMinVList), false);
          expect(FL.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => FL.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));

          expect(() => FL.isValidLength(tag, validMinVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
      global.throwOnError = false;
      final vList0 = rng.float32List(1, 1);
      expect(FL.isValidLength(null, vList0), false);

      expect(FL.isValidLength(PTag.kDisplayedZValue, null), isNull);

      global.throwOnError = true;
      expect(() => FL.isValidLength(null, vList0),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => FL.isValidLength(PTag.kDisplayedZValue, null),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('FL isValidLength VM.k2 good values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rng.float32List(2, 2);
        global.throwOnError = false;
        for (var tag in flVM2Tags) {
          expect(FL.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FL isValidLength VM.k2 bad values', () {
      for (var i = 2; i < 10; i++) {
        final validMinVList = rng.float32List(3, i + 1);
        for (var tag in flVM2Tags) {
          global.throwOnError = false;
          expect(FL.isValidLength(tag, validMinVList), false);
          expect(FL.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => FL.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));

          expect(() => FL.isValidLength(tag, validMinVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('FL isValidLength VM.k3 good values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rng.float32List(3, 3);
        global.throwOnError = false;
        for (var tag in flVM3Tags) {
          expect(FL.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FL isValidLength VM.k3 bad values', () {
      for (var i = 3; i < 10; i++) {
        final validMinVList = rng.float32List(4, i + 1);
        for (var tag in flVM3Tags) {
          global.throwOnError = false;
          expect(FL.isValidLength(tag, validMinVList), false);
          expect(FL.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => FL.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));

          expect(() => FL.isValidLength(tag, validMinVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('FL isValidLength VM.k6 good values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rng.float32List(6, 6);
        global.throwOnError = false;
        for (var tag in flVM6Tags) {
          expect(FL.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FL isValidLength VM.k6 bad values', () {
      for (var i = 6; i < 10; i++) {
        final validMinVList = rng.float32List(7, i + 1);
        for (var tag in flVM6Tags) {
          global.throwOnError = false;
          expect(FL.isValidLength(tag, validMinVList), false);
          expect(FL.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => FL.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));

          expect(() => FL.isValidLength(tag, validMinVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('FL isValidLength VM.k1_n good values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rng.float32List(1, i);
        global.throwOnError = false;
        for (var tag in flVM1_nTags) {
          expect(FL.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FL isValidLength VM.k6_n good values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rng.float32List(6, 10);
        global.throwOnError = false;
        for (var tag in flVM1_6Tags) {
          expect(FL.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FL isValidLength VM.k6_n bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rng.float32List(1, 5);
        for (var tag in flVM1_6Tags) {
          global.throwOnError = false;
          expect(FL.isValidLength(tag, validMinVList), false);
          expect(FL.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => FL.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));

          expect(() => FL.isValidLength(tag, validMinVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('FL isValidVFLength good values', () {
      global.throwOnError = false;
      expect(FL.isValidVFLength(FL.kMaxVFLength), true);
      expect(FL.isValidVFLength(0), true);

      expect(FL.isValidVFLength(FL.kMaxVFLength, null, PTag.kSelectorFLValue),
          true);
    });

    test('FL isValidVFLength bad values', () {
      global.doTestElementValidity = false;
      global.throwOnError = false;
      expect(FL.isValidVFLength(FL.kMaxVFLength + 1), false);
      expect(FL.isValidVFLength(-1), false);
    });

    test('FL isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(FL.isValidVR(kFLIndex), true);

      for (var tag in flVM1Tags) {
        global.throwOnError = false;
        expect(FL.isValidVR(tag.vrIndex), true);
      }
    });

    test('FL isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(FL.isValidVR(kATIndex), false);

      global.throwOnError = true;
      expect(() => FL.isValidVR(kATIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in nonFLTags) {
        global.throwOnError = false;
        expect(FL.isValidVR(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => FL.isValidVR(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('FL isValidVRCode good values', () {
      global.throwOnError = false;
      expect(FL.isValidVRCode(kFLCode), true);

      for (var tag in flVM1Tags) {
        global.throwOnError = false;
        expect(FL.isValidVRCode(tag.vrCode), true);
      }
    });

    test('FL isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(FL.isValidVRCode(kATCode), false);

      global.throwOnError = true;
      expect(() => FL.isValidVRCode(kATCode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in nonFLTags) {
        global.throwOnError = false;
        expect(FL.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => FL.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('FL isValidVFLength good values', () {
      expect(FL.isValidVFLength(FL.kMaxVFLength), true);
      expect(FL.isValidVFLength(0), true);
    });

    test('FL isValidVFLength bad values', () {
      expect(FL.isValidVFLength(FL.kMaxVFLength + 1), false);
      expect(FL.isValidVFLength(-1), false);
    });

    test('FL isValidValues good values', () {
      //VM.k1
      global.throwOnError = false;
      for (var i = 0; i <= goodFloat32List.length - 1; i++) {
        expect(
            FL.isValidValues(
                PTag.kExaminedBodyThickness, <double>[goodFloat32List[i]]),
            true);
      }

      //VM.k2
      expect(
          FL.isValidValues(
              PTag.kLocalizingCursorPosition, goodFloat32List.take(2)),
          true);

      //VM.k3
      expect(
          FL.isValidValues(
              PTag.kCalculatedTargetPosition, goodFloat32List.take(3)),
          true);

      //VM.k6
      expect(
          FL.isValidValues(
              PTag.kPointsBoundingBoxCoordinates, goodFloat32List.take(6)),
          true);

      //VM.k1_n
      expect(FL.isValidValues(PTag.kSelectorFLValue, goodFloat32List), true);
    });

    test('FL isValidValues bad values length', () {
      global.doTestElementValidity = true;
      global.throwOnError = false;
      expect(FL.isValidValues(PTag.kExaminedBodyThickness, goodFloat32List),
          false);

      expect(FL.isValidValues(null, goodFloat32List), false);

      global.throwOnError = true;
      expect(
          () => FL.isValidValues(PTag.kExaminedBodyThickness, goodFloat32List),
          throwsA(const TypeMatcher<InvalidValuesError>()));

      expect(() => FL.isValidValues(null, goodFloat32List),
          throwsA(const TypeMatcher<InvalidTagError>()));
    });
  });
}
