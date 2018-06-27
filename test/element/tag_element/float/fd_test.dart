//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/float64_test', level: Level.info);
  final rng = new RNG(1);
  global.throwOnError = false;

  List<double> invalidVList;

  setUp(() {
    // Using float32List because only length matters
    invalidVList = rng.float32List(FL.kMaxLength + 1, FL.kMaxLength + 1);
  });

  tearDown(() {
    // remove garbage!
    invalidVList = [];
  });

  const float64GoodList = const <double>[
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

  global.throwOnError = false;

  group('FDtags', () {
    test('FD hasValidValues good values', () {
      global.throwOnError = false;
      final e0 = new FDtag(PTag.kSelectorFDValue, float64GoodList);
      expect(e0.hasValidValues, true);

      // empty list and null as values
      final e1 = new FDtag(PTag.kSelectorFDValue, []);
      expect(e1.hasValidValues, true);
      expect(e1.values, equals(<double>[]));
    });

    test('FD hasValidValues bad values', () {
      final e1 = new FDtag(PTag.kSelectorFDValue, null);
      log.debug('e1: $e1');
      expect(e1, isNull);
      //expect(e1.values.isEmpty, true);

      global.throwOnError = true;
      expect(() => new FDtag(PTag.kSelectorFDValue, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('FD hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final e0 = new FDtag(PTag.kOverallTemplateSpatialTolerance, vList0);
        log.debug('e0:$e0');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList1 = rng.float64List(2, 2);
        final e0 = new FDtag(PTag.kRecommendedRotationPoint, vList1);
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList1[0]));
      }
    });

    test('FD hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rng.float64List(3, 4);
        log.debug('$i: vList0: $vList0');
        final e0 = new FDtag(PTag.kRecommendedRotationPoint, vList0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => new FDtag(PTag.kRecommendedRotationPoint, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
        expect(e0, isNull);
      }
    });

    test('FD update random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(3, 4);
        final e1 = new FDtag(PTag.kSelectorFDValue, vList0);
        final vList1 = rng.float64List(3, 4);
        expect(e1.update(vList1).values, equals(vList1));
      }
    });

    test('FD update', () {
      final e0 = new FDtag(PTag.kSelectorFDValue, []);
      expect(e0.update([1.0, 2.0]).values, equals([1.0, 2.0]));

      final e1 = new FDtag(PTag.kSelectorFDValue, float64GoodList);
      expect(e1.update(float64GoodList).values, equals(float64GoodList));

      const floatUpdateValues = const <double>[
        546543.674, 6754764.45887, 54698.52, 787354.734768 // No reformat
      ];
      for (var i = 1; i <= floatUpdateValues.length - 1; i++) {
        final fdValues = floatUpdateValues.take(i).toList();
        final e2 = new FDtag(
            PTag.kSelectorFDValue, new Float64List.fromList(fdValues));
        expect(
            e2.update(
                new Float64List.fromList(floatUpdateValues.take(i).toList())),
            equals(
                new Float64List.fromList(floatUpdateValues.take(i).toList())));

        expect(e2.update(floatUpdateValues.take(i).toList()).values,
            equals(floatUpdateValues.take(i).toList()));
      }
    });

    test('FD noValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float64List(3, 4);
        final e0 = new FDtag(PTag.kSelectorFDValue, vList);
        log.debug('e0: ${e0.noValues}');
        expect(e0.noValues.values.isEmpty, true);
      }
    });

    test('FD noValues', () {
      global.throwOnError = false;
      final e0 = new FDtag(PTag.kOverallTemplateSpatialTolerance, []);
      final FDtag fdNoValues = e0.noValues;
      expect(fdNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      final e1 =
          new FDtag(PTag.kOverallTemplateSpatialTolerance, float64GoodList);
      log.debug('e1: $e1');
      expect(fdNoValues.values.isEmpty, true);
      expect(e1, isNull);
    });

    test('FD copy random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float64List(3, 4);
        final e0 = new FDtag(PTag.kSelectorFDValue, vList);
        final FDtag e1 = e0.copy;
        expect(e1 == e0, true);
        expect(e1.hashCode == e0.hashCode, true);
      }
    });

    test('FD copy', () {
      final e0 = new FDtag(PTag.kSelectorFDValue, []);
      final FDtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      final e2 = new FDtag(PTag.kSelectorFDValue, float64GoodList);
      final FDtag e3 = e2.copy;
      expect(e3 == e2, true);
      expect(e3.hashCode == e2.hashCode, true);
    });

    test('FD hashCode and == good values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rng.float64List(1, 1);
        final e0 = new FDtag(PTag.kOverallTemplateSpatialTolerance, vList);
        final e1 = new FDtag(PTag.kOverallTemplateSpatialTolerance, vList);
        log
          ..debug('vList:$vList, e0.hash_code:${e0.hashCode}')
          ..debug('vList:$vList, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('FD hashCode and == bad values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final e0 = new FDtag(PTag.kOverallTemplateSpatialTolerance, vList0);
        final e1 = new FDtag(PTag.kOverallTemplateSpatialTolerance, vList0);

        final vList1 = rng.float64List(1, 1);
        final e2 = new FDtag(PTag.kCineRelativeToRealTime, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rng.float64List(2, 2);
        final e3 = new FDtag(PTag.kTwoDMatingPoint, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);

        final vList3 = rng.float64List(3, 3);
        final e4 = new FDtag(PTag.kGridResolution, vList3);
        log.debug('vList3:$vList3 , e4.hash_code:${e4.hashCode}');
        expect(e0.hashCode == e4.hashCode, false);
        expect(e0 == e4, false);

        final vList4 = rng.float64List(4, 4);
        final e5 = new FDtag(PTag.kBoundingRectangle, vList4);
        log.debug('vList4:$vList4 , e5.hash_code:${e5.hashCode}');
        expect(e0.hashCode == e5.hashCode, false);
        expect(e0 == e5, false);

        final vList5 = rng.float64List(6, 6);
        final e6 = new FDtag(PTag.kImageOrientationVolume, vList5);
        log.debug('vList5:$vList5 , e6.hash_code:${e6.hashCode}');
        expect(e1.hashCode == e6.hashCode, false);
        expect(e1 == e6, false);

        final vList6 = rng.float64List(9, 9);
        final e7 = new FDtag(PTag.kThreeDMatingAxes, vList6);
        log.debug('vList6:$vList6 , e7.hash_code:${e7.hashCode}');
        expect(e1.hashCode == e7.hashCode, false);
        expect(e1 == e7, false);

        final vList7 = rng.float64List(2, 3);
        final e8 = new FDtag(PTag.kCineRelativeToRealTime, vList7);
        log.debug('vList7:$vList7 , e8.hash_code:${e8.hashCode}');
        expect(e1.hashCode == e8.hashCode, false);
        expect(e1 == e8, false);
      }
    });

    test('FD hashCode and == good values', () {
      global.throwOnError = false;
      final e0 = new FDtag(
          PTag.kOverallTemplateSpatialTolerance, float64GoodList.take(1));
      final e1 = new FDtag(
          PTag.kOverallTemplateSpatialTolerance, float64GoodList.take(1));
      log
        ..debug('float64LstCommon0:$float64GoodList, e0.hash_code:${e0
            .hashCode}')
        ..debug('float64LstCommon0:$float64GoodList, e1.hash_code:${e1
            .hashCode}');
      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);
    });

    test('FD hashCode and == bad values', () {
      global.throwOnError = false;
      final e0 = new FDtag(
          PTag.kOverallTemplateSpatialTolerance, float64GoodList.take(1));
      final e2 =
          new FDtag(PTag.kCineRelativeToRealTime, float64GoodList.take(1));
      log.debug('float64LstCommon0:$float64GoodList , '
          'e2.hash_code:${e2.hashCode}');
      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);

      final e3 = new FDtag(PTag.kTwoDMatingPoint, float64GoodList.take(2));
      log.debug('float64LstCommon0:$float64GoodList, '
          'e3.hash_code:${e3.hashCode}');
      expect(e0.hashCode == e3.hashCode, false);
      expect(e0 == e3, false);

      final e4 = new FDtag(PTag.kGridResolution, float64GoodList.take(3));
      log.debug('float64LstCommon0:$float64GoodList, '
          'e4.hash_code:${e4.hashCode}');
      expect(e0.hashCode == e4.hashCode, false);
      expect(e0 == e4, false);

      final e5 = new FDtag(PTag.kBoundingRectangle, float64GoodList.take(4));
      log.debug('float64LstCommon0:$float64GoodList, '
          'e5.hash_code:${e5.hashCode}');
      expect(e0.hashCode == e5.hashCode, false);
      expect(e0 == e5, false);

      final e6 =
          new FDtag(PTag.kImageOrientationVolume, float64GoodList.take(6));
      log.debug('float64LstCommon0:$float64GoodList, '
          'e6.hash_code:${e6.hashCode}');
      expect(e0.hashCode == e6.hashCode, false);
      expect(e0 == e6, false);

      final e7 = new FDtag(PTag.kThreeDMatingAxes, float64GoodList.take(9));
      log.debug('float64LstCommon0:$float64GoodList, '
          'e7.hash_code:${e7.hashCode}');
      expect(e0.hashCode == e7.hashCode, false);
      expect(e0 == e7, false);

      final e8 = new FDtag(PTag.kSelectorFDValue, float64GoodList);
      log.debug('float64LstCommon0:$float64GoodList, '
          'e8.hash_code:${e8.hashCode}');
      expect(e0.hashCode == e8.hashCode, false);
      expect(e0 == e8, false);
    });

    test('FD replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final e0 = new FDtag(PTag.kOverallTemplateSpatialTolerance, vList0);
        final vList1 = rng.float64List(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rng.float64List(1, 1);
      final e1 = new FDtag(PTag.kOverallTemplateSpatialTolerance, vList1);
      expect(e1.replace(<double>[]), equals(vList1));
      expect(e1.values, equals(<double>[]));

      final e2 = new FDtag(PTag.kOverallTemplateSpatialTolerance, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(<double>[]));
    });

    test('FD fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final bytes0 = new Bytes.typedDataView(vList0);
        final e0 =
            FDtag.fromBytes(PTag.kOverallTemplateSpatialTolerance, bytes0);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);

        final vList1 = rng.float64List(2, 2);
        final bytes1 = new Bytes.typedDataView(vList1);
        final e1 =
            FDtag.fromBytes(PTag.kOverallTemplateSpatialTolerance, bytes1);
        log.debug('e1: $e1');
        expect(e1, isNull);
      }
    });

    test('FD fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final bytes0 = new Bytes.typedDataView(vList0);
        final e0 = FDtag.fromBytes(PTag.kSelectorFDValue, bytes0);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
      }
    });

    test('FD fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.float64List(1, 10);
        final bytes = new Bytes.typedDataView(vList);
        final e0 = FDtag.fromBytes(PTag.kSelectorSSValue, bytes);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => FDtag.fromBytes(PTag.kSelectorSSValue, bytes),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('FD fromValues good values', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float64List(1, 1);
        final e0 =
            FDtag.fromValues(PTag.kOverallTemplateSpatialTolerance, vList);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);

        final e1 =
            FDtag.fromValues(PTag.kOverallTemplateSpatialTolerance, <double>[]);
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(<double>[]));
      }
    });

    test('FD fromValues bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float64List(2, 2);
        global.throwOnError = false;
        final e0 =
            FDtag.fromValues(PTag.kOverallTemplateSpatialTolerance, vList);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(
            () =>
                FDtag.fromValues(PTag.kOverallTemplateSpatialTolerance, vList),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('FD fromBase64', () {
      final s = Float64.toBase64(<double>[78678.11]);
      final bytes = Bytes.fromBase64(s);
      final e0 = FDtag.fromBytes(PTag.kOverallTemplateSpatialTolerance, bytes);
      expect(e0.hasValidValues, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final bytes0 = new Bytes.typedDataView(vList0);
        final base64 = bytes0.getBase64();
        final bytes1 = Bytes.fromBase64(base64);
        final e1 =
            FDtag.fromBytes(PTag.kOverallTemplateSpatialTolerance, bytes1);
        expect(e1.hasValidValues, true);

        final vList1 = bytes1.getFloat64List();
        final e2 =
            FDtag.fromValues(PTag.kOverallTemplateSpatialTolerance, vList1);
        expect(e2.hasValidValues, true);
      }
    });

    test('Create Elements from floating values(FD)', () {
      const vList = const <double>[2047.99, 2437.437, 764.53];
      final e0 =
          new FDtag(PTag.kSelectorFDValue, new Float64List.fromList(vList));
      expect(e0.values.first.toStringAsPrecision(1),
          equals((2047.99).toStringAsPrecision(1)));
    });

    test('FD checkLength good values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.float64List(1, i);
        final e0 = new FDtag(PTag.kSelectorFDValue, vList);
        expect(e0.checkLength(e0.values), true);
      }
    });

    test('FD checkLength bad values', () {
      global.throwOnError = false;
      final e0 = new FDtag(PTag.kTubeAngle, float64GoodList);
      expect(e0, isNull);

      global.throwOnError = true;
      expect(() => new FDtag(PTag.kTubeAngle, float64GoodList),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('FD checkValues', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.float64List(1, i);
        final e0 = new FDtag(PTag.kSelectorFDValue, vList);
        expect(e0.checkValues(e0.values), true);
      }
    });
  });

  group('FD Element', () {
    //VM.k1
    const fdVM1Tags = const <PTag>[
      PTag.kEventTimeOffset,
      PTag.kReferencePixelPhysicalValueX,
      PTag.kReferencePixelPhysicalValueY,
      PTag.kPhysicalDeltaX,
      PTag.kPhysicalDeltaY,
      PTag.kTubeAngle,
    ];

    //VM.k2
    const fdVM2Tags = const <PTag>[
      PTag.kTimeRange,
      PTag.kReconstructionFieldOfView,
      PTag.kReconstructionPixelSpacing,
      PTag.kRecommendedRotationPoint,
      PTag.kTwoDMatingPoint,
      PTag.kRangeOfFreedom,
      PTag.kTwoDImplantTemplateGroupMemberMatchingPoint,
    ];

    //VM.k3
    const fdVM3Tags = const <PTag>[
      PTag.kDiffusionGradientOrientation,
      PTag.kVelocityEncodingDirection,
      PTag.kSlabOrientation,
      PTag.kMidSlabPosition,
      PTag.kASLSlabOrientation,
      PTag.kDataCollectionCenterPatient,
      PTag.kGridResolution,
    ];

    //VM.k4
    const fdVM4Tags = const <PTag>[
      PTag.kBoundingRectangle,
      PTag.kTwoDMatingAxes,
      PTag.kTwoDLineCoordinates,
      PTag.kDisplayEnvironmentSpatialPosition,
      PTag.kDoubleExposureFieldDelta,
      PTag.kTwoDImplantTemplateGroupMemberMatchingAxes,
    ];
    //VM.k6
    const fdVM6Tags = const <PTag>[PTag.kImageOrientationVolume];

    //VM.k9
    const fdVM9Tags = const <PTag>[
      PTag.kViewOrientationModifier,
      PTag.kThreeDMatingAxes,
      PTag.kThreeDImplantTemplateGroupMemberMatchingAxes,
    ];

    //VM.k1_n
    const fdVM1_nTags = const <PTag>[
      PTag.kRealWorldValueLUTData,
      PTag.kSelectorFDValue,
      PTag.kInversionTimes,
      PTag.kDepthsOfFocus,
    ];

    const otherTags = const <PTag>[
      PTag.kNumberOfIterations,
      PTag.kAcquisitionProtocolName,
      PTag.kAcquisitionContextDescription,
      PTag.kCTPositionSequence,
      PTag.kAcquisitionType,
      PTag.kPerformedStationAETitle,
      PTag.kSelectorSTValue,
      PTag.kDate,
      PTag.kTime
    ];

    test('FD isValidTag good values', () {
      global.throwOnError = false;
      expect(FD.isValidTag(PTag.kSelectorFDValue), true);

      for (var tag in fdVM1Tags) {
        final validT0 = FD.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('FD isValidTag bad values', () {
      global.throwOnError = false;
      expect(FD.isValidTag(PTag.kSelectorFLValue), false);
      global.throwOnError = true;
      expect(() => FD.isValidTag(PTag.kSelectorFLValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = FD.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => FD.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('FD isValidVR good values', () {
      global.throwOnError = false;
      expect(FD.isValidVR(kFDIndex), true);

      for (var s in fdVM1Tags) {
        global.throwOnError = false;
        expect(FD.isValidVR(s.vrIndex), true);
      }
    });

    test('FD isValidVR bad values', () {
      global.throwOnError = false;
      expect(FD.isValidVR(kAEIndex), false);

      global.throwOnError = true;
      expect(() => FD.isValidVR(kAEIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var otherTag in otherTags) {
        global.throwOnError = false;
        expect(FD.isValidVR(otherTag.vrIndex), false);

        global.throwOnError = true;
        expect(() => FD.isValidVR(otherTag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('FD isValidLength VM.k1 good values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rng.float32List(1, 1);
        global.throwOnError = false;
        for (var tag in fdVM1Tags) {
          expect(FD.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FD isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rng.float32List(2, i + 1);
        for (var tag in fdVM1Tags) {
          global.throwOnError = false;
          expect(FD.isValidLength(tag, validMinVList), false);
          expect(FD.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => FD.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
      global.throwOnError = false;
      final vList0 = rng.float32List(1, 1);
      expect(FD.isValidLength(null, vList0), false);

      expect(FD.isValidLength(PTag.kEventTimeOffset, null), isNull);

      global.throwOnError = true;
      expect(() => FD.isValidLength(null, vList0),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => FD.isValidLength(PTag.kEventTimeOffset, null),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('FD isValidLength VM.k2 good values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rng.float32List(2, 2);
        global.throwOnError = false;
        for (var tag in fdVM2Tags) {
          expect(FD.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FD isValidLength VM.k2 bad values', () {
      for (var i = 2; i < 10; i++) {
        final validMinVList = rng.float32List(3, i + 1);
        for (var tag in fdVM2Tags) {
          global.throwOnError = false;
          expect(FD.isValidLength(tag, validMinVList), false);
          expect(FD.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => FD.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('FD isValidLength VM.k3 good values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rng.float32List(3, 3);
        global.throwOnError = false;
        for (var tag in fdVM3Tags) {
          expect(FD.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FD isValidLength VM.k3 bad values', () {
      for (var i = 3; i < 10; i++) {
        final validMinVList = rng.float32List(4, i + 1);
        for (var tag in fdVM3Tags) {
          global.throwOnError = false;
          expect(FD.isValidLength(tag, validMinVList), false);
          expect(FD.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => FD.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('FD isValidLength VM.k4 good values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rng.float32List(4, 4);
        global.throwOnError = false;
        for (var tag in fdVM4Tags) {
          expect(FD.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FD isValidLength VM.k4 bad values', () {
      for (var i = 4; i < 10; i++) {
        final validMinVList = rng.float32List(5, i + 1);
        for (var tag in fdVM4Tags) {
          global.throwOnError = false;
          expect(FD.isValidLength(tag, validMinVList), false);
          expect(FD.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => FD.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('FD isValidLength VM.k6 good values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rng.float32List(6, 6);
        global.throwOnError = false;
        for (var tag in fdVM6Tags) {
          expect(FD.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FD isValidLength VM.k6 bad values', () {
      for (var i = 6; i < 10; i++) {
        final validMinVList = rng.float32List(7, i + 1);
        global.throwOnError = false;
        for (var tag in fdVM6Tags) {
          expect(FD.isValidLength(tag, validMinVList), false);
          expect(FD.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => FD.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('FD isValidLength VM.k9 good values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rng.float32List(9, 9);
        global.throwOnError = false;
        for (var tag in fdVM9Tags) {
          expect(FD.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FD isValidLength VM.k9 bad values', () {
      for (var i = 9; i < 20; i++) {
        final validMinVList = rng.float32List(10, i + 1);
        for (var tag in fdVM9Tags) {
          global.throwOnError = false;
          expect(FD.isValidLength(tag, validMinVList), false);
          expect(FD.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => FD.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('FD isValidLength VM.k1_n good values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rng.float32List(1, i);
        global.throwOnError = false;
        for (var tag in fdVM1_nTags) {
          expect(FD.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FD isValidVR good values', () {
      global.throwOnError = false;
      expect(FD.isValidVR(kFDIndex), true);

      for (var tag in fdVM1Tags) {
        global.throwOnError = false;
        expect(FD.isValidVR(tag.vrIndex), true);
      }
    });

    test('FD isValidVR bad values', () {
      global.throwOnError = false;
      expect(FD.isValidVR(kATIndex), false);

      global.throwOnError = true;
      expect(() => FD.isValidVR(kATIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(FD.isValidVR(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => FD.isValidVR(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('FD isValidVRCode good values', () {
      global.throwOnError = false;
      expect(FD.isValidVRCode(kFDCode), true);

      for (var tag in fdVM1Tags) {
        global.throwOnError = false;
        expect(FD.isValidVRCode(tag.vrCode), true);
      }
    });

    test('FD isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(FD.isValidVRCode(kATCode), false);

      global.throwOnError = true;
      expect(() => FD.isValidVRCode(kATCode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(FD.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => FD.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('FD isValidVFLength good values', () {
      expect(FD.isValidVFLength(FD.kMaxVFLength), true);
      expect(FD.isValidVFLength(0), true);

      expect(FD.isValidVFLength(FD.kMaxVFLength, null, PTag.kSelectorFDValue),
          true);
    });

    test('FD isValidVFLength bad values', () {
      expect(FD.isValidVFLength(FD.kMaxVFLength + 1), false);
      expect(FD.isValidVFLength(-1), false);
    });

    test('FD isValidValues good values', () {
      global.throwOnError = false;
      //VM.k1
      for (var i = 0; i <= float64GoodList.length - 1; i++) {
        expect(
            FD.isValidValues(
                PTag.kEffectiveEchoTime, <double>[float64GoodList[i]]),
            true);
      }

      //VM.k2
      expect(
          FD.isValidValues(
              PTag.kReconstructionFieldOfView, float64GoodList.take(2)),
          true);

      //VM.k3
      expect(FD.isValidValues(PTag.kGridResolution, float64GoodList.take(3)),
          true);

      //VM.k4
      expect(FD.isValidValues(PTag.kBoundingRectangle, float64GoodList.take(4)),
          true);

      //VM.k6
      expect(
          FD.isValidValues(
              PTag.kImageOrientationVolume, float64GoodList.take(6)),
          true);

      //VM.k9
      expect(FD.isValidValues(PTag.kThreeDMatingAxes, float64GoodList.take(9)),
          true);

      //VM.k1_n
      expect(FD.isValidValues(PTag.kSelectorFDValue, float64GoodList), true);
    });

    test('FD isValidValues bad values length', () {
      global.throwOnError = false;
      expect(FD.isValidValues(PTag.kEffectiveEchoTime, float64GoodList), false);

      global.throwOnError = true;
      expect(() => FD.isValidValues(PTag.kEffectiveEchoTime, float64GoodList),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('Float64Mixin.fromList', () {
      expect(Float64.fromList(float64GoodList), equals(float64GoodList));

      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        expect(Float64.fromList(vList0), vList0);
      }
    });

    test('Float64Mixin.fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final float = new Float64List.fromList(vList0);
        final bd = float.buffer.asUint8List();
        expect(Float64.fromUint8List(bd), equals(vList0));
      }
      final float0 = new Float64List.fromList(<double>[]);
      final bd0 = float0.buffer.asUint8List();
      expect(Float64.fromUint8List(bd0), equals(<double>[]));
    });

    test('FD toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final float64List0 = new Float64List.fromList(vList0);
        final uInt8List0 = float64List0.buffer.asUint8List();
        final base64 = Float64.toBytes(float64List0);
        expect(base64, equals(uInt8List0));
      }
    });

    test('Create Float64Mixin.toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final float64List0 = new Float64List.fromList(vList0);
        final bd = float64List0.buffer.asByteData();
        final lBd0 = Float64.toByteData(float64List0);
        log.debug('lBd0: ${lBd0.buffer.asUint8List()}, '
            'bd: ${bd.buffer.asUint8List()}');
        expect(lBd0.buffer.asUint8List(), equals(bd.buffer.asUint8List()));
        expect(lBd0.buffer == bd.buffer, true);

        final lBd1 = Float64.toByteData(float64List0, asView: false);
        log.debug('lBd1: ${lBd1.buffer.asUint8List()}, '
            'bd: ${bd.buffer.asUint8List()}');
        expect(lBd1.buffer.asUint8List(), equals(bd.buffer.asUint8List()));
        expect(lBd1.buffer == bd.buffer, false);
      }
    });

    test('Float64Mixin.fromBase64', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(0, i);
        final uInt8List0 = vList0.buffer.asUint8List();
        final s = base64.encode(uInt8List0);
        log.debug('FD.base64: "$s"');

        final vList1 = Float64.fromBase64(s);
        log.debug('  FD.decode: $vList1');
        expect(vList1, equals(vList0));
      }
    });

    test('Float64Mixin.toBase64', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(0, i);
        final bytes = new Bytes.typedDataView(vList0);
        final a = bytes.getBase64();
        final b = Float64.toBase64(vList0);
        expect(b, equals(a));
      }
    });

    test('Float64Mixin encodeDecodeJsonVF', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.float64List(1, i);
        final uInt8List0 = vList0.buffer.asUint8List();

        // Encode
        final s0 = base64.encode(uInt8List0);
        log.debug('FD.base64: "$s0"');
        final s1 = Float64.toBase64(vList0);
        log.debug('Float64.toBase64: "$s1"');
        expect(s1, equals(s0));

        // Decode
        final vList2 = Float64.fromBase64(s0);
        log.debug('FD.vList3: $vList2');
        final vList3 = Float64.fromBase64(s1);
        log.debug('FD.vList4: $vList3');
        expect(vList2, equals(vList0));
        expect(vList3, equals(vList0));
      }
    });

    test('Float64Mixin.fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final float64List0 = new Float64List.fromList(vList0);
        final bd = float64List0.buffer.asUint8List();
        expect(Float64.fromUint8List(bd), equals(vList0));
      }
      final float0 = new Float64List.fromList(<double>[]);
      final bd0 = float0.buffer.asUint8List();
      expect(Float64.fromUint8List(bd0), equals(<double>[]));
    });

    test('FD fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float64List(1, 1);
        final float = new Float64List.fromList(vList);
        final byteData0 = float.buffer.asByteData();
        expect(Float64.fromByteData(byteData0), equals(vList));
      }
      final float0 = new Float64List.fromList(<double>[]);
      final bd0 = float0.buffer.asByteData();
      expect(Float64.fromByteData(bd0), equals(<double>[]));
    });
  });
}
