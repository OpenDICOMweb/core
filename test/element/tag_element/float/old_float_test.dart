//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:convert' as cvt;
import 'dart:typed_data';

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/float32_test', level: Level.info);
  final rng = new RNG(1);
  List<double> float32List;
  global.throwOnError = false;

  List<double> invalidVList;

  setUp(() {
    invalidVList = rng.float32List(FL.kMaxLength + 1, FL.kMaxLength + 1);
  });

  tearDown(() {
    // remove garbage!
    invalidVList = [];
  });

  const goodFloatList = const <double>[
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

  final goodFloat32List = new Float32List.fromList(goodFloatList);

  global.throwOnError = false;
  group('FLtag', () {
    test('FL hasValidValues good values', () {
      global.throwOnError = false;
      final fl0 = new FLtag(PTag.kVectorAccuracy, goodFloat32List);
      expect(fl0.hasValidValues, true);

      // empty list and null as values
      final fl1 = new FLtag(PTag.kTableOfParameterValues, []);
      expect(fl1.hasValidValues, true);
      expect(fl1.values, equals(<double>[]));
    });

    test('FL hasValidValues bad values', () {
      global.throwOnError = false;
      final fl0 = new FLtag(PTag.kTableOfParameterValues, null);
      log.debug('fl0: $fl0');
      expect(fl0, isNull);

      global.throwOnError = true;
      expect(() => new FLtag(PTag.kTableOfParameterValues, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('FL hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final float32List = rng.float32List(1, 1);
        expect(float32List is Float32List, true);
        final fl0 = new FLtag(PTag.kAbsoluteChannelDisplayScale, float32List);
        expect(fl0.hasValidValues, true);

        log
          ..debug('fl0: $fl0, values: ${fl0.values}')
          ..debug('fl0: $fl0')
          ..debug('float32List: $float32List')
          ..debug('        fl0: ${fl0.values}');
        expect(fl0.values, equals(float32List));
      }

      for (var i = 0; i < 10; i++) {
        final float32List = rng.float32List(2, 2);
        final fl0 = new FLtag(PTag.kCornealVertexLocation, float32List);
        expect(fl0.hasValidValues, true);

        log
          ..debug('fl0: $fl0, values: ${fl0.values}')
          ..debug('fl0: $fl0');
        expect(fl0[0], equals(float32List[0]));
      }
    });

    test('FL hasValidValues bad values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final float32List = rng.float32List(3, 4);
        log.debug('$i: float32List: $float32List');
        final fl0 = new FLtag(PTag.kCornealVertexLocation, float32List);
        expect(fl0, isNull);
      }

      global.throwOnError = true;
      final float32List = rng.float32List(3, 4);
      expect(() => new FLtag(PTag.kCornealVertexLocation, float32List),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('FL update random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final float32List = rng.float32List(3, 4);
        final fl1 = new FLtag(PTag.kTableOfParameterValues, float32List);
        final float32List1 = rng.float32List(3, 4);
        expect(fl1.update(float32List1).values, equals(float32List1));
      }
    });

    test('FL update', () {
      const floatUpdateValues = const <double>[
        546543.674, 6754764.45887, 54698.52, 787354.734768 // No reformat
      ];

      final float32UpdateValues = new Float32List.fromList(floatUpdateValues);

      final fl0 = new FLtag(PTag.kTableOfParameterValues, []);
      final vList = new Float32List.fromList([1.0, 2.0]);
      expect(fl0.update(vList).values, equals(vList));

      final fl1 = new FLtag(PTag.kTableOfParameterValues, goodFloat32List);
      expect(fl1.update(goodFloat32List).values, equals(goodFloat32List));

      for (var i = 1; i <= float32UpdateValues.length - 1; i++) {
        final fl2 = new FLtag(PTag.kSelectorFLValue,
            new Float32List.fromList(float32UpdateValues.take(i).toList()));

        expect(
            fl2.update(
                new Float32List.fromList(float32UpdateValues.take(i).toList())),
            equals(
                new Float32List.fromList(float32UpdateValues.take(i).toList())));

        expect(fl2.update(float32UpdateValues.take(i).toList()).values,
            equals(float32UpdateValues.take(i).toList()));
      }
      final fl2 = new FLtag(PTag.kSelectorFLValue,
          new Float32List.fromList(float32UpdateValues.take(1).toList()));
      expect([fl2.values.elementAt(0)],
          equals(new Float32List.fromList(float32UpdateValues.take(1).toList())));
      log.debug(fl2.view());
    });

    test('FL noValues random', () {
      for (var i = 0; i < 10; i++) {
        final float32List = rng.float32List(3, 4);
        final fl0 = new FLtag(PTag.kTableOfParameterValues, float32List);
        log.debug('fl0: ${fl0.noValues}');
        expect(fl0.noValues.values.isEmpty, true);
      }
    });

    test('FL noValues', () {
      final fl0 = new FLtag(PTag.kTableOfParameterValues, []);
      final FLtag flNoValues = fl0.noValues;
      expect(flNoValues.values.isEmpty, true);
      log.debug('fl0: ${fl0.noValues}');

      final fl1 = new FLtag(PTag.kTableOfParameterValues, goodFloat32List);
      log.debug('fl1: $fl1');
      expect(flNoValues.values.isEmpty, true);
      log.debug('fl0: ${fl0.noValues}');
    });

    test('FL copy random', () {
      for (var i = 0; i < 10; i++) {
        final float32List = rng.float32List(3, 4);
        final fl0 = new FLtag(PTag.kTableOfParameterValues, float32List);
        final FLtag fl1 = fl0.copy;
        expect(fl1 == fl0, true);
        expect(fl1.hashCode == fl0.hashCode, true);
      }
    });

    test('FL copy', () {
      final fl0 = new FLtag(PTag.kTableOfParameterValues, []);
      final FLtag fl1 = fl0.copy;
      expect(fl1 == fl0, true);
      expect(fl1.hashCode == fl0.hashCode, true);

      final fl2 = new FLtag(PTag.kTableOfParameterValues, goodFloat32List);
      final FLtag fl3 = fl2.copy;
      expect(fl3 == fl2, true);
      expect(fl3.hashCode == fl2.hashCode, true);
    });

    test('FL hashCode and == good values random', () {
      global.throwOnError = false;
      final rng = new RNG(1);
      List<double> vList;

      for (var i = 0; i < 10; i++) {
        vList = rng.float32List(1, 1);
        final fl0 = new FLtag(PTag.kAbsoluteChannelDisplayScale, vList);
        final fl1 = new FLtag(PTag.kAbsoluteChannelDisplayScale, vList);
        log
          ..debug('vList:$vList, fl0.hash_code:${fl0.hashCode}')
          ..debug('vList:$vList, fl1.hash_code:${fl1.hashCode}');
        expect(fl0.hashCode == fl1.hashCode, true);
        expect(fl0 == fl1, true);
      }
    });

    test('FL hashCode and == bad values random', () {
      global.throwOnError = false;
      final rng = new RNG(1);

      List<double> vList;
      List<double> vList1;
      List<double> floatList2;
      List<double> floatList3;
      List<double> floatList4;
      List<double> floatList5;

      for (var i = 0; i < 10; i++) {
        vList = rng.float32List(1, 1);
        final fl0 = new FLtag(PTag.kAbsoluteChannelDisplayScale, vList);
        final fl1 = new FLtag(PTag.kAbsoluteChannelDisplayScale, vList);

        vList1 = rng.float32List(1, 1);
        final fl2 = new FLtag(PTag.kRecommendedDisplayFrameRateInFloat, vList1);
        log.debug('vList1:$vList1 , fl2.hash_code:${fl2.hashCode}');
        expect(fl0.hashCode == fl2.hashCode, false);
        expect(fl0 == fl2, false);

        floatList2 = rng.float32List(2, 2);
        final fl3 = new FLtag(PTag.kCornealVertexLocation, floatList2);
        log.debug('floatList2:$floatList2 , fl3.hash_code:${fl3.hashCode}');
        expect(fl0.hashCode == fl3.hashCode, false);
        expect(fl0 == fl3, false);

        floatList3 = rng.float32List(3, 3);
        final fl4 = new FLtag(PTag.kCornealPointLocation, floatList3);
        log.debug('floatList3:$floatList3 , fl4.hash_code:${fl4.hashCode}');
        expect(fl0.hashCode == fl4.hashCode, false);
        expect(fl0 == fl4, false);

        floatList4 = rng.float32List(6, 6);
        final fl5 = new FLtag(PTag.kPointsBoundingBoxCoordinates, floatList4);
        log.debug('floatList4:$floatList4 , fl5.hash_code:${fl5.hashCode}');
        expect(fl0.hashCode == fl5.hashCode, false);
        expect(fl0 == fl5, false);

        floatList5 = rng.float32List(2, 3);
        final fl6 = new FLtag(PTag.kFractionalChannelDisplayScale, floatList5);
        log.debug('floatList5:$floatList5 , fl6.hash_code:${fl6.hashCode}');
        expect(fl1.hashCode == fl6.hashCode, false);
        expect(fl1 == fl6, false);
      }
    });

    test('FL hashCode and == good values ', () {
      global.throwOnError = false;
      final fl0 =
          new FLtag(PTag.kAbsoluteChannelDisplayScale, goodFloat32List.take(1));
      final fl1 =
          new FLtag(PTag.kAbsoluteChannelDisplayScale, goodFloat32List.take(1));
      log
        ..debug('listFloat32Common0:$goodFloat32List, fl0.hash_code:${fl0
            .hashCode}')
        ..debug('listFloat32Common0:$goodFloat32List, fl1.hash_code:${fl1
            .hashCode}');
      expect(fl0.hashCode == fl1.hashCode, true);
      expect(fl0 == fl1, true);
    });

    test('FL hashCode and == bad values ', () {
      global.throwOnError = false;
      final fl0 =
          new FLtag(PTag.kAbsoluteChannelDisplayScale, goodFloat32List.take(1));

      final fl2 = new FLtag(
          PTag.kRecommendedDisplayFrameRateInFloat, goodFloat32List.take(1));
      log.debug('listFloat32Common0:$goodFloat32List , fl2.hash_code:${fl2
          .hashCode}');
      expect(fl0.hashCode == fl2.hashCode, false);
      expect(fl0 == fl2, false);

      final fl3 =
          new FLtag(PTag.kCornealVertexLocation, goodFloat32List.take(2));
      log.debug('listFloat32Common0:$goodFloat32List , fl3.hash_code:${fl3
          .hashCode}');
      expect(fl0.hashCode == fl3.hashCode, false);
      expect(fl0 == fl3, false);

      final fl4 =
          new FLtag(PTag.kCornealPointLocation, goodFloat32List.take(3));
      log.debug('listFloat32Common0:$goodFloat32List , fl4.hash_code:${fl4
          .hashCode}');
      expect(fl0.hashCode == fl4.hashCode, false);
      expect(fl0 == fl4, false);

      final fl5 = new FLtag(
          PTag.kPointsBoundingBoxCoordinates, goodFloat32List.take(6));
      log.debug('listFloat32Common0:$goodFloat32List , fl5.hash_code:${fl5
          .hashCode}');
      expect(fl0.hashCode == fl5.hashCode, false);
      expect(fl0 == fl5, false);

      final fl6 = new FLtag(PTag.kSelectorFLValue, goodFloat32List);
      log.debug('listFloat32Common0:$goodFloat32List , fl6.hash_code:${fl6
          .hashCode}');
      expect(fl0.hashCode == fl6.hashCode, false);
      expect(fl0 == fl6, false);
    });

    test('FL replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final fl0 = new FLtag(PTag.kAbsoluteChannelDisplayScale, vList);
        final vList1 = rng.float32List(1, 1);
        expect(fl0.replace(vList1), equals(vList));
        expect(fl0.values, equals(vList1));
      }

      final vList1 = rng.float32List(1, 1);
      final fl1 = new FLtag(PTag.kAbsoluteChannelDisplayScale, vList1);
      expect(fl1.replace(<double>[]), equals(vList1));
      expect(fl1.values, equals(<double>[]));

      final fl2 = new FLtag(PTag.kAbsoluteChannelDisplayScale, vList1);
      expect(fl2.replace(null), equals(vList1));
      expect(fl2.values, equals(<double>[]));
    });

    test('FL fromUint8List good values', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final bytes = new Bytes.typedDataView(vList);
        final fl0 = FLtag.fromBytes(bytes, PTag.kAbsoluteChannelDisplayScale);
        log.debug('fl0: $fl0');
        expect(fl0.hasValidValues, true);
      }
    });

    test('FL fromUint8List bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(3, 3);
        final bytes = new Bytes.typedDataView(vList);
        final fl1 = FLtag.fromBytes(bytes, PTag.kAbsoluteChannelDisplayScale);
        log.debug('fl1: $fl1');
//        expect(fl1.hasValidValues, false);
      expect(fl1, isNull);
      }
    });

    test('FL fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 10);
        final bytes = new Bytes.typedDataView(vList);
        final fl0 = FLtag.fromBytes(bytes, PTag.kSelectorFLValue);
        log.debug('fl0: $fl0');
        expect(fl0.hasValidValues, true);
      }
    });

    test('FL fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.float32List(1, 10);
        final bytes = new Bytes.typedDataView(vList);
        final fl0 = FLtag.fromBytes(bytes, PTag.kSelectorSSValue);
        expect(fl0, isNull);

        global.throwOnError = true;
        expect(() => FLtag.fromBytes(bytes, PTag.kSelectorSSValue),
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

/*
    test('FL fromBase64', () {
      final fString = Float32.toBase64(<double>[78678.11]);
      final fl0 = FLtag.fromBase64(PTag.kAbsoluteChannelDisplayScale, fString);
      expect(fl0.hasValidValues, true);

      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final float32List0 = new Float32List.fromList(vList);
        final uInt8List0 = float32List0.buffer.asUint8List();
        final base64 = cvt.base64.encode(uInt8List0);
        final fl1 = FLtag.fromBase64(PTag.kAbsoluteChannelDisplayScale, base64);
        expect(fl1.hasValidValues, true);
      }
    });
*/

    test('Create Elements from floating values(FL)', () {
      const f32Values = const <double>[2047.99, 2437.437, 764.53];

      final fl0 = new FLtag(PTag.kRecommendedDisplayFrameRateInFloat,
          new Float32List.fromList(f32Values.take(1).toList()));
      expect(fl0.values.first.toStringAsPrecision(1),
          equals((2047.99).toStringAsPrecision(1)));
    });

    test('FL checkLength good values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.float32List(1, i);
        final fl0 = new FLtag(PTag.kSelectorFLValue, vList);
        expect(fl0.checkLength(fl0.values), true);
      }
    });

    test('FL checkLength bad values', () {
      global.throwOnError = false;
      final fl0 = new FLtag(PTag.kBeamAngle, goodFloat32List);
      expect(fl0, isNull);

      global.throwOnError = true;
      expect(() => new FLtag(PTag.kBeamAngle, goodFloat32List),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('FL checkValues', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.float32List(1, i);
        final fl0 = new FLtag(PTag.kSelectorFLValue, vList);
        expect(fl0.checkValues(fl0.values), true);
      }
    });
  });

  group('FL Element', () {
    //VM.k1
    const flTags0 = const <PTag>[
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
    const flTags1 = const <PTag>[
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
    const flTags2 = const <PTag>[
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
    const flTags3 = const <PTag>[
      PTag.kPointsBoundingBoxCoordinates,
    ];

    //VM.k1_n
    const flTags4 = const <PTag>[
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
    const flTags5 = const <PTag>[PTag.kBoundingPolygon];

    const otherTags = const <PTag>[
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

      for (var tag in flTags0) {
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

      for (var tag in otherTags) {
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

      for (var s in flTags0) {
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

      for (var s in otherTags) {
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
        for (var tag in flTags0) {
          expect(FL.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FL isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rng.float32List(2, i + 1);
        for (var tag in flTags0) {
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

    test('FL isValidLength VM.k2 good values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rng.float32List(2, 2);
        global.throwOnError = false;
        for (var tag in flTags1) {
          expect(FL.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FL isValidLength VM.k2 bad values', () {
      for (var i = 2; i < 10; i++) {
        final validMinVList = rng.float32List(3, i + 1);
        for (var tag in flTags1) {
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
        for (var tag in flTags2) {
          expect(FL.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FL isValidLength VM.k3 bad values', () {
      for (var i = 3; i < 10; i++) {
        final validMinVList = rng.float32List(4, i + 1);
        for (var tag in flTags2) {
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
        for (var tag in flTags3) {
          expect(FL.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FL isValidLength VM.k6 bad values', () {
      for (var i = 6; i < 10; i++) {
        final validMinVList = rng.float32List(7, i + 1);
        for (var tag in flTags3) {
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
        for (var tag in flTags4) {
          expect(FL.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FL isValidLength VM.k6_n good values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rng.float32List(6, 10);
        global.throwOnError = false;
        for (var tag in flTags5) {
          expect(FL.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FL isValidLength VM.k6_n bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rng.float32List(1, 5);
        for (var tag in flTags5) {
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
    });

    test('FL isValidVFLength bad values', () {
      global.throwOnError = false;
      expect(FL.isValidVFLength(FL.kMaxVFLength + 1), false);
      expect(FL.isValidVFLength(-1), false);
    });

    test('FL isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(FL.isValidVR(kFLIndex), true);

      for (var tag in flTags0) {
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

      for (var tag in otherTags) {
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

      for (var tag in flTags0) {
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

      for (var tag in otherTags) {
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
      global.throwOnError = false;
      expect(FL.isValidValues(PTag.kExaminedBodyThickness, goodFloat32List),
          false);

      global.throwOnError = true;
      expect(
          () => FL.isValidValues(PTag.kExaminedBodyThickness, goodFloat32List),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('FLoat32Base toFloat32', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        expect(Float32.fromList(vList), vList);
      }
    });

    test('Float32Base fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float32List(1, 1);
        final bytes0 = new Bytes.typedDataView(vList0);
        expect(Float32.fromBytes(bytes0), equals(vList0));
      }
      final vList1 = new Float32List.fromList(<double>[]);
      final bytes1 = new Bytes.typedDataView(vList1);
      expect(Float32.fromBytes(bytes1), equals(<double>[]));
    });

    test('Float32Base toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(0, i);
        final float32List0 = new Float32List.fromList(vList);
        final uInt8List0 = float32List0.buffer.asUint8List();
        final bytes = Float32.toBytes(float32List0);
        expect(bytes, equals(uInt8List0));
      }
    });

    test('Float32Base.toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final float32List0 = new Float32List.fromList(vList);
        final bd0 = float32List0.buffer.asByteData();
        final lBd0 = Float32.toByteData(float32List0);
        log.debug('lBd0: ${lBd0.buffer.asUint8List()}, '
            'bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd0.buffer == bd0.buffer, true);

        final lBd1 = Float32.toByteData(float32List0, asView: false);
        log.debug('lBd1: ${lBd1.buffer.asUint8List()}, '
            'bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd1.buffer == bd0.buffer, false);

        final vList1 = rng.float64List(1, 1);
        final float64List0 = new Float64List.fromList(vList1);
        final bd1 = float64List0.buffer.asByteData();
        final lBd2 = Float32.toByteData(float64List0);

        log.debug('lBd2: ${lBd2.buffer.asUint8List()}, '
            'bd1: ${bd1.buffer.asUint8List()}');
        expect(lBd2.buffer.asUint8List(), isNot(bd1.buffer.asUint8List()));
        expect(lBd2.buffer == bd1.buffer, false);
      }
    });

    test('Float32Base decodeJsonVF', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(0, i);
        final float32List0 = new Float32List.fromList(vList);
        final uInt8List0 = float32List0.buffer.asUint8List();
        final base64 = cvt.base64.encode(uInt8List0);
        final fl0 = Float32.fromBase64(base64);
        log
          ..debug('  vList: $vList')
          ..debug('float32List0: $float32List0')
          ..debug('         fl0: $fl0');
        expect(fl0, equals(vList));
        expect(fl0, equals(float32List0));
      }
    });

    test('Float32Base toBase64', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(0, i);
        final float32List0 = new Float32List.fromList(vList);
        final uInt8List0 = float32List0.buffer.asUint8List();
        final base64 = cvt.base64.encode(uInt8List0);
        final s = Float32.toBase64(vList);
        expect(s, equals(base64));
      }
    });

    test('Float32Base encodeDecodeJsonVF', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.float32List(1, i);
        final float32List0 = new Float32List.fromList(vList);
        final uInt8List0 = float32List0.buffer.asUint8List();

        // Encode
        final base64 = cvt.base64.encode(uInt8List0);
        log.debug('FL.base64: "$base64"');
        final s = Float32.toBase64(vList);
        log.debug('  FL.json: "$s"');
        expect(s, equals(base64));

        // Decode
        final fl0 = Float32.fromBase64(base64);
        log.debug('FL.base64: $fl0');
        final fl1 = Float32.fromBase64(s);
        log.debug('  FL.json: $fl1');
        expect(fl0, equals(vList));
        expect(fl0, equals(float32List0));
        expect(fl0, equals(fl1));
      }
    });

    test('Float32Base fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float32List(1, 1);
        final bytes0 = new Bytes.typedDataView(vList0);
        expect(Float32.fromBytes(bytes0), equals(vList0));
      }
      final vList1 = new Float32List.fromList(<double>[]);
      final bytes1 = new Bytes.typedDataView(vList1);
      expect(Float32.fromBytes(bytes1), equals(<double>[]));
    });

    test('Float32Base.fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final float = new Float32List.fromList(vList);
        final byteData0 = float.buffer.asByteData();
        expect(Float32.fromByteData(byteData0), equals(vList));
      }
      final float0 = new Float32List.fromList(<double>[]);
      final bd0 = float0.buffer.asByteData();
      expect(Float32.fromByteData(bd0), equals(<double>[]));
    });

    test('Float32Base fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final byte = new Bytes.typedDataView(vList);
        final fb0 = Float32.fromBytes(byte);
        final float32List0 = byte.asFloat32List();
        log.debug('formBytes: $fb0, Flaot32List: $float32List0');
        expect(fb0, equals(float32List0));
      }
    });

    test('Float32Bae fromValueField', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final fvF0 = Float32.fromValueField(vList);
        expect(fvF0, equals(vList));

        final fvF1 = Float32.fromValueField(null);
        expect(fvF1, equals(<double>[]));

        final fvF2 = Float32.fromValueField(<double>[]);
        expect(fvF2, equals(<double>[]));

        final fvF3 = Float32.fromValueField(<double>[123.54]);
        expect(fvF3, equals(<double>[123.54]));

        final bytes = new Bytes.typedDataView(vList);
        final fvF4 = Float32.fromValueField(bytes);
        expect(fvF4, isNotNull);

        final vList1 = bytes.asUint8List();
        final fvF5 = Float32.fromValueField(vList1);
        final data = Float32.fromBytes(bytes);
        expect(fvF5, equals(data));
      }
      global.throwOnError = false;
      final fvF6 = Float32.fromValueField(<String>['foo']);
      expect(fvF6, isNull);

      global.throwOnError = true;
      expect(() => Float32.fromValueField(<String>['foo']),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });
  });

  group('OFTag', () {
    final rng = new RNG(1);

    test('OF hasValidValues good values', () {
      global.throwOnError = false;
      final of0 = new OFtag(PTag.kUValueData, goodFloat32List);
      expect(of0.hasValidValues, true);

      global.throwOnError = false;
      final of1 = new OFtag(PTag.kVectorGridData, []);
      expect(of1.hasValidValues, true);
      expect(of1.values, equals(<double>[]));

      final of2 = new OFtag(PTag.kVectorGridData);
      expect(of2.hasValidValues, true);
      expect(of2.values.isEmpty, true);
    });

    test('OF hasValidValues bad values', () {
      final of2 = new OFtag(PTag.kVectorGridData, null);
      expect(of2, isNull);

      global.throwOnError = true;
      expect(() => new OFtag(PTag.kVectorGridData, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('OF hasValidValues random', () {
      for (var i = 0; i < 10; i++) {
        float32List = rng.float32List(1, 10);
        log.debug('i: $i, float32List: $float32List');
        final of0 = new OFtag(PTag.kUValueData, float32List);
        log.debug('of:$of0');
        expect(of0[0], equals(float32List[0]));
        expect(of0.hasValidValues, true);
      }

      for (var i = 0; i < 100; i++) {
        float32List = rng.float32List(2, 10);
        log.debug('i: $i, float32List: $float32List');
        final of0 =
            new OFtag(PTag.kFirstOrderPhaseCorrectionAngle, float32List);
        expect(of0.hasValidValues, true);
      }
    });

    test('OF update random', () {
      for (var i = 0; i < 10; i++) {
        float32List = rng.float32List(1, 10);
        final of1 = new OFtag(PTag.kUValueData, float32List);
        final float32List1 = rng.float32List(1, 10);
        expect(of1.update(float32List1).values, equals(float32List1));
      }
    });

    test('OF update', () {
      final of0 = new OFtag(PTag.kVectorGridData, []);
      final floatList = [1.2, 1.3, 1.4];
      final vList = new Float32List.fromList(floatList);
      expect(of0.update(vList).values, equals(vList));

      final of1 = new OFtag(PTag.kUValueData, goodFloat32List);
      expect(of1.update(goodFloat32List).values, equals(goodFloat32List));

      const floatUpdateValues = const <double>[
        546543.674, 6754764.45887, 54698.52, 787354.734768 // No reformat
      ];

      final float32UpdateValues = new Float32List.fromList(floatUpdateValues);
      for (var i = 1; i <= float32UpdateValues.length - 1; i++) {
        final of2 = new OFtag(PTag.kSelectorOFValue,
            new Float32List.fromList(float32UpdateValues.take(i).toList()));

        expect(
            of2.update(
                new Float32List.fromList(float32UpdateValues.take(i).toList())),
            equals(
                new Float32List.fromList(float32UpdateValues.take(i).toList())));

        expect(of2.update(float32UpdateValues.take(i).toList()).values,
            equals(float32UpdateValues.take(i).toList()));
      }
      final of3 = new OFtag(PTag.lookupByCode(kUValueData),
          new Float32List.fromList(float32UpdateValues));
      expect(of3.update(new Float32List.fromList(float32UpdateValues)),
          equals(new Float32List.fromList(float32UpdateValues)));
    });

    test('OF noValues random', () {
      for (var i = 0; i < 10; i++) {
        float32List = rng.float32List(1, 10);
        final of1 = new OFtag(PTag.kUValueData, float32List);
        final ofNoValues = of1.noValues;
        expect(ofNoValues.values.isEmpty, true);
      }
    });

    test('OF noValues ', () {
      final of0 = new OFtag(PTag.kVectorGridData, []);
      final ofNoValues0 = of0.noValues;
      expect(ofNoValues0.values.isEmpty, true);
      log.debug('of0:${of0.noValues}');

      final of1 = new OFtag(PTag.kUValueData, goodFloat32List);
      final ofNoValues1 = of1.noValues;
      expect(ofNoValues1.values.isEmpty, true);
    });

    test('OF copy random', () {
      for (var i = 0; i < 10; i++) {
        float32List = rng.float32List(1, 1);
        final of0 = new OFtag(PTag.kVectorGridData, float32List);
        final OFtag of5 = of0.copy;
        expect(of0 == of5, true);
        expect(of0.hashCode == of5.hashCode, true);
      }
    });

    test('OF copy', () {
      final of0 = new OFtag(PTag.kVectorGridData, goodFloat32List);
      final OFtag of5 = of0.copy;
      expect(of0 == of5, true);
      expect(of0.hashCode == of5.hashCode, true);
    });

    test('OF hashCode and == good values random', () {
      List<double> vList;

      for (var i = 0; i < 10; i++) {
        vList = rng.float32List(1, 1);
        final of0 = new OFtag(PTag.kVectorGridData, vList);
        final of1 = new OFtag(PTag.kVectorGridData, vList);
        log
          ..debug('vList:$vList , of1.hash_code:${of1.hashCode}')
          ..debug('vList:$vList , of1.hash_code:${of1.hashCode}');
        expect(of0.hashCode == of1.hashCode, true);
        expect(of0 == of1, true);
      }
    });

    test('OF hashCode and == bad values random', () {
      List<double> vList;
      List<double> vList1;
      List<double> floatList2;
      List<double> floatList3;

      for (var i = 0; i < 10; i++) {
        vList = rng.float32List(1, 1);
        vList1 = rng.float32List(1, 1);
        final of0 = new OFtag(PTag.kVectorGridData, vList);
        final of2 = new OFtag(PTag.kPointCoordinatesData, vList1);
        log.debug('vList1:$vList1 , of2.hash_code:${of2.hashCode}');
        expect(of0.hashCode == of2.hashCode, false);
        expect(of0 == of2, false);

        floatList2 = rng.float32List(1, 2);
        final of3 = new OFtag(PTag.kUValueData, floatList2);
        log.debug('floatList2:$floatList2 , of3.hash_code:${of3.hashCode}');
        expect(of0.hashCode == of3.hashCode, false);
        expect(of0 == of3, false);

        floatList3 = rng.float32List(2, 3);
        final of4 = new OFtag(PTag.kPointCoordinatesData, floatList3);
        log.debug('floatList3:$floatList3 , of4.hash_code:${of4.hashCode}');
        expect(of2.hashCode == of4.hashCode, false);
        expect(of2 == of4, false);
      }
    });

    test('OF hashCode and == good values', () {
      final of0 = new OFtag(PTag.kVectorGridData, goodFloat32List.take(1));
      final of1 = new OFtag(PTag.kVectorGridData, goodFloat32List.take(1));
      log
        ..debug('listFloat32Common0:$goodFloat32List , of1.hash_code:${of1
            .hashCode}')
        ..debug('listFloat32Common0:$goodFloat32List , of1.hash_code:${of1
            .hashCode}');
      expect(of0.hashCode == of1.hashCode, true);
      expect(of0 == of1, true);
    });

    test('OF hashCode and == bad values', () {
      final of0 = new OFtag(PTag.kVectorGridData, goodFloat32List.take(1));
      final of2 =
          new OFtag(PTag.kPointCoordinatesData, goodFloat32List.take(1));
      log.debug('listFloat32Common0:$goodFloat32List, '
          'of2.hash_code:${of2.hashCode}');
      expect(of0.hashCode == of2.hashCode, false);
      expect(of0 == of2, false);

      final of3 = new OFtag(PTag.kUValueData, goodFloat32List);
      log.debug('listFloat32Common0:$goodFloat32List, '
          'of3.hash_code:${of3.hashCode}');
      expect(of0.hashCode == of3.hashCode, false);
      expect(of0 == of3, false);

      final of4 = new OFtag(PTag.kSelectorOFValue, goodFloat32List);
      log.debug('listFloat32Common0:$goodFloat32List, '
          'of4.hash_code:${of4.hashCode}');
      expect(of0.hashCode == of4.hashCode, false);
      expect(of0 == of4, false);
    });

    test('OF replace random', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final of0 = new OFtag(PTag.kVectorGridData, vList);
        final vList1 = rng.float32List(1, 1);
        expect(of0.replace(vList1), equals(vList));
        expect(of0.values, equals(vList1));
      }

      final vList1 = rng.float32List(1, 1);
      final of1 = new OFtag(PTag.kVectorGridData, vList1);
      expect(of1.replace(<double>[]), equals(vList1));
      expect(of1.values, equals(<double>[]));

      final of2 = new OFtag(PTag.kVectorGridData, vList1);
      expect(of2.replace(null), equals(vList1));
      expect(of2.values, equals(<double>[]));
    });

    test('OF fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float32List(1, 1);
        final bytes0 = new Bytes.typedDataView(vList0);
        final of0 = OFtag.fromBytes(bytes0, PTag.kVectorGridData);
        log.debug('of0: $of0');
        expect(of0.hasValidValues, true);

        final vList1 = rng.float32List(3, 3);
        final bytes1 = new Bytes.typedDataView(vList1);
        final of1 =
            OFtag.fromBytes(bytes1, PTag.kFirstOrderPhaseCorrectionAngle);
        log.debug('of1: $of1');
        expect(of1.hasValidValues, true);
      }
    });

    test('OF fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final bytes = new Bytes.typedDataView(vList);
        final of0 = OFtag.fromBytes(bytes, PTag.kSelectorOFValue);
        log.debug('of0: $of0');
        expect(of0.hasValidValues, true);
      }
    });

    test('OF fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.float32List(1, 10);
        final bytes = new Bytes.typedDataView(vList);
        final of0 = OFtag.fromBytes(bytes, PTag.kSelectorSSValue);
        expect(of0, isNull);

        global.throwOnError = true;
        expect(() => OFtag.fromBytes(bytes, PTag.kSelectorSSValue),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('OF make good values', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final make0 = OFtag.fromValues(PTag.kVectorGridData, vList);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);

        final make1 = OFtag.fromValues(PTag.kVectorGridData, <double>[]);
        expect(make1.hasValidValues, true);
        expect(make1.values, equals(<double>[]));
      }
    });

/*
    test('Float32Base to/FromBase64', () {
      final fString = Float32.toBase64(<double>[78678.11]);
      final of0 = OFtag.fromBase64(PTag.kVectorGridData, fString);
      expect(of0.hasValidValues, true);

      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final float32List0 = new Float32List.fromList(vList);
        final uInt8List0 = float32List0.buffer.asUint8List();
        final base64 = cvt.base64.encode(uInt8List0);
        final of1 = OFtag.fromBase64(PTag.kVectorGridData, base64);
        expect(of1.hasValidValues, true);
      }
    });
*/

    test('OF checkLength random', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.float32List(1, i);
        final of0 = new OFtag(PTag.kSelectorOFValue, vList);
        expect(of0.checkLength(of0.values), true);
      }
    });

    test('OF checkValues', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.float32List(1, i);
        final of0 = new OFtag(PTag.kSelectorOFValue, vList);
        expect(of0.checkValues(of0.values), true);
      }
    });
  });

  group('OF Element', () {
    const ofTags = const <PTag>[
      PTag.kVectorGridData,
      PTag.kFloatingPointValues,
      PTag.kUValueData,
      PTag.kVValueData,
      PTag.kFirstOrderPhaseCorrectionAngle,
      PTag.kSpectroscopyData,
      PTag.kFloatPixelData,
    ];

    const otherTags = const <PTag>[
      PTag.kPlanningLandmarkID,
      PTag.kAcquisitionProtocolName,
      PTag.kCTDIvol,
      PTag.kCTPositionSequence,
      PTag.kAcquisitionType,
      PTag.kPerformedStationAETitle,
      PTag.kSelectorSTValue,
      PTag.kDate,
      PTag.kTime
    ];

    test('OF isValidTag good values', () {
      global.throwOnError = false;
      expect(OF.isValidTag(PTag.kSelectorOFValue), true);

      for (var tag in ofTags) {
        final validT0 = OF.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('OF isValidTag bad values', () {
      global.throwOnError = false;
      expect(OF.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => OF.isValidTag(PTag.kSelectorFDValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = OF.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => OF.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('OF isValidVR good values', () {
      global.throwOnError = false;
      expect(OF.isValidVR(kOFIndex), true);

      for (var s in ofTags) {
        global.throwOnError = false;
        expect(OF.isValidVR(s.vrIndex), true);
      }
    });

    test('OF isValidVR bad values', () {
      global.throwOnError = false;
      expect(OF.isValidVR(kAEIndex), false);

      global.throwOnError = true;
      expect(() => OF.isValidVR(kAEIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var s in otherTags) {
        global.throwOnError = false;
        expect(OF.isValidVR(s.vrIndex), false);

        global.throwOnError = true;
        expect(() => OF.isValidVR(s.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

/* Urgent Sharath: fix or delete
    test('OF isValidLength', () {
      global.throwOnError = false;
      expect(OF.isValidLength(OF.kMaxLength), true);
      expect(OF.isValidLength(0), true);
    });
*/

    test('OF isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(OF.isValidVR(kOFIndex), true);

      for (var tag in ofTags) {
        global.throwOnError = false;
        expect(OF.isValidVR(tag.vrIndex), true);
      }
    });

    test('OF isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(OF.isValidVR(kATIndex), false);

      global.throwOnError = true;
      expect(() => OF.isValidVR(kATIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OF.isValidVR(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => OF.isValidVR(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('OF isValidVRCode good values', () {
      global.throwOnError = false;
      expect(OF.isValidVRCode(kOFCode), true);

      for (var tag in ofTags) {
        global.throwOnError = false;
        expect(OF.isValidVRCode(tag.vrCode), true);
      }
    });

    test('OF isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(OF.isValidVRCode(kATCode), false);

      global.throwOnError = true;
      expect(() => OF.isValidVRCode(kATCode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OF.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => OF.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });
/*

    test('OF checkVR good values', () {
      global.throwOnError = false;
      expect(OF.checkVRIndex(kOFIndex), kOFIndex);

      for (var tag in ofTags) {
        global.throwOnError = false;
        expect(OF.checkVRIndex(tag.vrIndex), OF.kVRIndex);
      }
    });

    test('OF checkVR bad values', () {
      global.throwOnError = false;
      expect(
          OF.checkVRIndex(
            kAEIndex,
            ),
          null);
      global.throwOnError = true;
      expect(() => OF.checkVRIndex(kAEIndex),
                 throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OF.checkVRIndex(tag.vrIndex), null);

        global.throwOnError = true;
        expect(() => OF.checkVRIndex(kAEIndex),
                   throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('OF checkVRIndex good values', () {
      global.throwOnError = false;
      expect(OF.checkVRIndex(kOFIndex), equals(kOFIndex));

      for (var tag in ofTags) {
        global.throwOnError = false;
        expect(OF.checkVRIndex(tag.vrIndex), equals(tag.vrIndex));
      }
    });

    test('OF checkVRIndex bad values', () {
      global.throwOnError = false;
      expect(OF.checkVRIndex(kATIndex), isNull);

      global.throwOnError = true;
      expect(() => OF.checkVRIndex(kATIndex),
                 throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OF.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => OF.checkVRIndex(tag.vrIndex),
                   throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('OF checkVRCode good values', () {
      global.throwOnError = false;
      expect(OF.checkVRCode(kOFCode), equals(kOFCode));

      for (var tag in ofTags) {
        global.throwOnError = false;
        expect(OF.checkVRCode(tag.vrCode), equals(tag.vrCode));
      }
    });

    test('OF checkVRCode bad values', () {
      global.throwOnError = false;
      expect(OF.checkVRCode(kATCode), isNull);

      global.throwOnError = true;
      expect(() => OF.checkVRCode(kATCode),
                 throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OF.checkVRCode(tag.vrCode), isNull);

        global.throwOnError = true;
        expect(() => OF.checkVRCode(tag.vrCode),
                   throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });
*/

    test('OF isValidVFLength good values', () {
      expect(OF.isValidVFLength(OF.kMaxVFLength), true);
      expect(OF.isValidVFLength(0), true);
    });

    test('OF isValidVFLength bad values', () {
      expect(OF.isValidVFLength(OF.kMaxVFLength + 1), false);
      expect(OF.isValidVFLength(-1), false);
    });

/* Urgent Sharath: fix or delete
    test('OF isValidLength', () {
      expect(OF.isValidLength(OF.kMaxLength), true);
    });
*/

    test('OF isValidValues', () {
      global.throwOnError = false;
      //VM.k1
      for (var i = 0; i <= goodFloat32List.length - 1; i++) {
        expect(
            OF.isValidValues(
                PTag.kVectorGridData, <double>[goodFloat32List[i]]),
            true);
      }

      //VM.k1_n
      expect(OF.isValidValues(PTag.kSelectorOFValue, goodFloat32List), true);
    });

    test('Float32Base.fromList', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        expect(Float32.fromList(vList), vList);
      }
    });

    test('Float32Base.fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float32List(1, 1);
        final bytes0 = new Bytes.typedDataView(vList0);
        expect(Float32.fromBytes(bytes0), equals(vList0));
      }
      final vList1 = new Float32List.fromList(<double>[]);
      final bytes1 = new Bytes.typedDataView(vList1);
      expect(Float32.fromBytes(bytes1), equals(<double>[]));
    });

    test('Float32Base.toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final float32List0 = new Float32List.fromList(vList);
        final uInt8List0 = float32List0.buffer.asUint8List();
        //final base64 = cvt.base64.encode(uInt8List0);
        expect(Float32.toBytes(float32List0), equals(uInt8List0));
      }
    });

    test('Float32Base.fromBase64', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(0, i);
        final float32List0 = new Float32List.fromList(vList);
        final uInt8List0 = float32List0.buffer.asUint8List();
        final base64 = cvt.base64.encode(uInt8List0);
        final of0 = Float32.fromBase64(base64);
        log
          ..debug('  vList: $vList')
          ..debug('float32List0: $float32List0')
          ..debug('         of0: $of0');
        expect(of0, equals(vList));
        expect(of0, equals(float32List0));
      }
    });

    test('Float32Base.toBase64', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(0, i);
        final float32List0 = new Float32List.fromList(vList);
        final uInt8List0 = float32List0.buffer.asUint8List();
        final base64 = cvt.base64.encode(uInt8List0);
        final of0 = Float32.toBase64(vList);
        expect(of0, equals(base64));
      }
    });

    test('OF encodeDecodeJsonVF', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.float32List(1, i);
        final float32List0 = new Float32List.fromList(vList);
        final uInt8List0 = float32List0.buffer.asUint8List();

        // Encode
        final base64 = cvt.base64.encode(uInt8List0);
        log.debug('OF.base64: "$base64"');
        final s = Float32.toBase64(vList);
        log.debug('  OF.json: "$s"');
        expect(s, equals(base64));

        // Decode
        final of0 = Float32.fromBase64(base64);
        log.debug('FL.base64: $of0');
        final of1 = Float32.fromBase64(s);
        log.debug('  OF.json: $of1');
        expect(of0, equals(vList));
        expect(of0, equals(float32List0));
        expect(of0, equals(of1));
      }
    });

    test('Float32Base.fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float32List(1, 1);
        final bytes0 = new Bytes.typedDataView(vList0);
        expect(Float32.fromBytes(bytes0), equals(vList0));
      }
      final vList1 = new Float32List.fromList(<double>[]);
      final bytes1 = new Bytes.typedDataView(vList1);
      expect(Float32.fromBytes(bytes1), equals(<double>[]));
    });

    test('Float32Base.fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final float = new Float32List.fromList(vList);
        final byteData0 = float.buffer.asByteData();
        expect(Float32.fromByteData(byteData0), equals(vList));
      }
      final float0 = new Float32List.fromList(<double>[]);
      final bd0 = float0.buffer.asByteData();
      expect(Float32.fromByteData(bd0), equals(<double>[]));
    });
  });
}
