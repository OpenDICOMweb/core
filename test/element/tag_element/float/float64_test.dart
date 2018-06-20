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

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/float64_test', level: Level.info);
  final rng = new RNG(1);

  List<double> invalidVList;

  setUp(() {
    invalidVList = rng.float64List(FL.kMaxLength + 1, FL.kMaxLength + 1);
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
      final fd0 = new FDtag(PTag.kSelectorFDValue, float64GoodList);
      expect(fd0.hasValidValues, true);

      // empty list and null as values
      final fd1 = new FDtag(PTag.kSelectorFDValue, []);
      expect(fd1.hasValidValues, true);
      expect(fd1.values, equals(<double>[]));
    });

    test('FD hasValidValues bad values', () {
      final fd1 = new FDtag(PTag.kSelectorFDValue, null);
      log.debug('fd1: $fd1');
      expect(fd1, isNull);
      //expect(fd1.values.isEmpty, true);

      global.throwOnError = true;
      expect(() => new FDtag(PTag.kSelectorFDValue, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('FD hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(1, 1);
        final fd0 =
            new FDtag(PTag.kOverallTemplateSpatialTolerance, float64List);
        log.debug('fd0:$fd0');
        expect(fd0.hasValidValues, true);

        log..debug('fd0: $fd0, values: ${fd0.values}')..debug('fd0: $fd0');
        expect(fd0[0], equals(float64List[0]));
      }

      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(2, 2);
        final fd0 = new FDtag(PTag.kRecommendedRotationPoint, float64List);
        expect(fd0.hasValidValues, true);

        log..debug('fd0: $fd0, values: ${fd0.values}')..debug('fd0: $fd0');
        expect(fd0[0], equals(float64List[0]));
      }
    });

    test('FD hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final float64List = rng.float64List(3, 4);
        log.debug('$i: float64List: $float64List');
        final fd0 = new FDtag(PTag.kRecommendedRotationPoint, float64List);
        expect(fd0, isNull);

        global.throwOnError = true;
        expect(() => new FDtag(PTag.kRecommendedRotationPoint, float64List),
            throwsA(const TypeMatcher<InvalidValuesError>()));
        expect(fd0, isNull);
      }
    });

    test('FD update random', () {
      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(3, 4);
        final fd1 = new FDtag(PTag.kSelectorFDValue, float64List);
        final float64List1 = rng.float64List(3, 4);
        expect(fd1.update(float64List1).values, equals(float64List1));
      }
    });

    test('FD update', () {
      final fd0 = new FDtag(PTag.kSelectorFDValue, []);
      expect(fd0.update([1.0, 2.0]).values, equals([1.0, 2.0]));

      final fd1 = new FDtag(PTag.kSelectorFDValue, float64GoodList);
      expect(fd1.update(float64GoodList).values, equals(float64GoodList));

      const floatUpdateValues = const <double>[
        546543.674, 6754764.45887, 54698.52, 787354.734768 // No reformat
      ];
      for (var i = 1; i <= floatUpdateValues.length - 1; i++) {
        final fdValues = floatUpdateValues.take(i).toList();
        final fd2 = new FDtag(
            PTag.kSelectorFDValue, new Float64List.fromList(fdValues));
        expect(
            fd2.update(
                new Float64List.fromList(floatUpdateValues.take(i).toList())),
            equals(
                new Float64List.fromList(floatUpdateValues.take(i).toList())));

        expect(fd2.update(floatUpdateValues.take(i).toList()).values,
            equals(floatUpdateValues.take(i).toList()));
      }
    });

    test('FD noValues random', () {
      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(3, 4);
        final fd0 = new FDtag(PTag.kSelectorFDValue, float64List);
        log.debug('fd0: ${fd0.noValues}');
        expect(fd0.noValues.values.isEmpty, true);
      }
    });

    test('FD noValues', () {
      global.throwOnError = false;
      final fd0 = new FDtag(PTag.kOverallTemplateSpatialTolerance, []);
      final FDtag fdNoValues = fd0.noValues;
      expect(fdNoValues.values.isEmpty, true);
      log.debug('fd0: ${fd0.noValues}');

      final fd1 =
          new FDtag(PTag.kOverallTemplateSpatialTolerance, float64GoodList);
      log.debug('fd1: $fd1');
      expect(fdNoValues.values.isEmpty, true);
      expect(fd1, isNull);
    });

    test('FD copy random', () {
      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(3, 4);
        final fd0 = new FDtag(PTag.kSelectorFDValue, float64List);
        final FDtag fd1 = fd0.copy;
        expect(fd1 == fd0, true);
        expect(fd1.hashCode == fd0.hashCode, true);
      }
    });

    test('FD copy', () {
      final fd0 = new FDtag(PTag.kSelectorFDValue, []);
      final FDtag fd1 = fd0.copy;
      expect(fd1 == fd0, true);
      expect(fd1.hashCode == fd0.hashCode, true);

      final fd2 = new FDtag(PTag.kSelectorFDValue, float64GoodList);
      final FDtag fd3 = fd2.copy;
      expect(fd3 == fd2, true);
      expect(fd3.hashCode == fd2.hashCode, true);
    });

    test('FD hashCode and == good values random', () {
      global.throwOnError = false;
      final rng = new RNG(1);

      List<double> floatList0;
/*
      List<double> floatList1;
      List<double> floatList2;
      List<double> floatList3;
      List<double> floatList4;
      List<double> floatList5;
      List<double> floatList6;
      List<double> floatList7;
*/

      for (var i = 0; i < 10; i++) {
        floatList0 = rng.float64List(1, 1);
        final fd0 =
            new FDtag(PTag.kOverallTemplateSpatialTolerance, floatList0);
        final fd1 =
            new FDtag(PTag.kOverallTemplateSpatialTolerance, floatList0);
        log
          ..debug('floatList0:$floatList0, fd0.hash_code:${fd0.hashCode}')
          ..debug('floatList0:$floatList0, fd1.hash_code:${fd1.hashCode}');
        expect(fd0.hashCode == fd1.hashCode, true);
        expect(fd0 == fd1, true);
      }
    });

    test('FD hashCode and == bad values random', () {
      global.throwOnError = false;
      final rng = new RNG(1);

      List<double> floatList0;
      List<double> floatList1;
      List<double> floatList2;
      List<double> floatList3;
      List<double> floatList4;
      List<double> floatList5;
      List<double> floatList6;
      List<double> floatList7;

      for (var i = 0; i < 10; i++) {
        floatList0 = rng.float64List(1, 1);
        final fd0 =
            new FDtag(PTag.kOverallTemplateSpatialTolerance, floatList0);
        final fd1 =
            new FDtag(PTag.kOverallTemplateSpatialTolerance, floatList0);

        floatList1 = rng.float64List(1, 1);
        final fd2 = new FDtag(PTag.kCineRelativeToRealTime, floatList1);
        log.debug('floatList1:$floatList1 , fd2.hash_code:${fd2.hashCode}');
        expect(fd0.hashCode == fd2.hashCode, false);
        expect(fd0 == fd2, false);

        floatList2 = rng.float64List(2, 2);
        final fd3 = new FDtag(PTag.kTwoDMatingPoint, floatList2);
        log.debug('floatList2:$floatList2 , fd3.hash_code:${fd3.hashCode}');
        expect(fd0.hashCode == fd3.hashCode, false);
        expect(fd0 == fd3, false);

        floatList3 = rng.float64List(3, 3);
        final fd4 = new FDtag(PTag.kGridResolution, floatList3);
        log.debug('floatList3:$floatList3 , fd4.hash_code:${fd4.hashCode}');
        expect(fd0.hashCode == fd4.hashCode, false);
        expect(fd0 == fd4, false);

        floatList4 = rng.float64List(4, 4);
        final fd5 = new FDtag(PTag.kBoundingRectangle, floatList4);
        log.debug('floatList4:$floatList4 , fd5.hash_code:${fd5.hashCode}');
        expect(fd0.hashCode == fd5.hashCode, false);
        expect(fd0 == fd5, false);

        floatList5 = rng.float64List(6, 6);
        final fd6 = new FDtag(PTag.kImageOrientationVolume, floatList5);
        log.debug('floatList5:$floatList5 , fd6.hash_code:${fd6.hashCode}');
        expect(fd1.hashCode == fd6.hashCode, false);
        expect(fd1 == fd6, false);

        floatList6 = rng.float64List(9, 9);
        final fd7 = new FDtag(PTag.kThreeDMatingAxes, floatList6);
        log.debug('floatList6:$floatList6 , fd7.hash_code:${fd7.hashCode}');
        expect(fd1.hashCode == fd7.hashCode, false);
        expect(fd1 == fd7, false);

        floatList7 = rng.float64List(2, 3);
        final fd8 = new FDtag(PTag.kCineRelativeToRealTime, floatList7);
        log.debug('floatList7:$floatList7 , fd8.hash_code:${fd8.hashCode}');
        expect(fd1.hashCode == fd8.hashCode, false);
        expect(fd1 == fd8, false);
      }
    });

    test('FD hashCode and == good values', () {
      global.throwOnError = false;
      final fd0 = new FDtag(
          PTag.kOverallTemplateSpatialTolerance, float64GoodList.take(1));
      final fd1 = new FDtag(
          PTag.kOverallTemplateSpatialTolerance, float64GoodList.take(1));
      log
        ..debug('float64LstCommon0:$float64GoodList, fd0.hash_code:${fd0
              .hashCode}')
        ..debug('float64LstCommon0:$float64GoodList, fd1.hash_code:${fd1
              .hashCode}');
      expect(fd0.hashCode == fd1.hashCode, true);
      expect(fd0 == fd1, true);
    });

    test('FD hashCode and == bad values', () {
      global.throwOnError = false;
      final fd0 = new FDtag(
          PTag.kOverallTemplateSpatialTolerance, float64GoodList.take(1));
      final fd2 =
          new FDtag(PTag.kCineRelativeToRealTime, float64GoodList.take(1));
      log.debug('float64LstCommon0:$float64GoodList , '
          'fd2.hash_code:${fd2.hashCode}');
      expect(fd0.hashCode == fd2.hashCode, false);
      expect(fd0 == fd2, false);

      final fd3 = new FDtag(PTag.kTwoDMatingPoint, float64GoodList.take(2));
      log.debug('float64LstCommon0:$float64GoodList, '
          'fd3.hash_code:${fd3.hashCode}');
      expect(fd0.hashCode == fd3.hashCode, false);
      expect(fd0 == fd3, false);

      final fd4 = new FDtag(PTag.kGridResolution, float64GoodList.take(3));
      log.debug('float64LstCommon0:$float64GoodList, '
          'fd4.hash_code:${fd4.hashCode}');
      expect(fd0.hashCode == fd4.hashCode, false);
      expect(fd0 == fd4, false);

      final fd5 = new FDtag(PTag.kBoundingRectangle, float64GoodList.take(4));
      log.debug('float64LstCommon0:$float64GoodList, '
          'fd5.hash_code:${fd5.hashCode}');
      expect(fd0.hashCode == fd5.hashCode, false);
      expect(fd0 == fd5, false);

      final fd6 =
          new FDtag(PTag.kImageOrientationVolume, float64GoodList.take(6));
      log.debug('float64LstCommon0:$float64GoodList, '
          'fd6.hash_code:${fd6.hashCode}');
      expect(fd0.hashCode == fd6.hashCode, false);
      expect(fd0 == fd6, false);

      final fd7 = new FDtag(PTag.kThreeDMatingAxes, float64GoodList.take(9));
      log.debug('float64LstCommon0:$float64GoodList, '
          'fd7.hash_code:${fd7.hashCode}');
      expect(fd0.hashCode == fd7.hashCode, false);
      expect(fd0 == fd7, false);

      final fd8 = new FDtag(PTag.kSelectorFDValue, float64GoodList);
      log.debug('float64LstCommon0:$float64GoodList, '
          'fd8.hash_code:${fd8.hashCode}');
      expect(fd0.hashCode == fd8.hashCode, false);
      expect(fd0 == fd8, false);
    });

    test('FD replace random', () {
      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float64List(1, 1);
        final fd0 =
            new FDtag(PTag.kOverallTemplateSpatialTolerance, floatList0);
        final floatList1 = rng.float64List(1, 1);
        expect(fd0.replace(floatList1), equals(floatList0));
        expect(fd0.values, equals(floatList1));
      }

      final floatList1 = rng.float64List(1, 1);
      final fd1 = new FDtag(PTag.kOverallTemplateSpatialTolerance, floatList1);
      expect(fd1.replace(<double>[]), equals(floatList1));
      expect(fd1.values, equals(<double>[]));

      final fd2 = new FDtag(PTag.kOverallTemplateSpatialTolerance, floatList1);
      expect(fd2.replace(null), equals(floatList1));
      expect(fd2.values, equals(<double>[]));
    });

    test('FD fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final bytes0 = new Bytes.typedDataView(vList0);
        final e0 =
            FDtag.fromBytes(bytes0, PTag.kOverallTemplateSpatialTolerance);
        log.debug('fd0: $e0');
        expect(e0.hasValidValues, true);

        final vList1 = rng.float64List(2, 2);
        final bytes1 = new Bytes.typedDataView(vList1);
        final e1 =
            FDtag.fromBytes(bytes1, PTag.kOverallTemplateSpatialTolerance);
        log.debug('fd1: $e1');
        expect(e1, isNull);
      }
    });

    test('FD fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final floatList = rng.float64List(1, 1);
        final bytes0 = new Bytes.typedDataView(floatList);
        final fd0 = FDtag.fromBytes(bytes0, PTag.kSelectorFDValue);
        log.debug('fd0: $fd0');
        expect(fd0.hasValidValues, true);
      }
    });

    test('FD fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final float64List = rng.float64List(1, 10);
        final bytes = new Bytes.typedDataView(float64List);
        final fd0 = FDtag.fromBytes(bytes, PTag.kSelectorSSValue);
        expect(fd0, isNull);

        global.throwOnError = true;
        expect(() => FDtag.fromBytes(bytes, PTag.kSelectorSSValue),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('FD make good values', () {
      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float64List(1, 1);
        final make0 =
            FDtag.fromValues(PTag.kOverallTemplateSpatialTolerance, floatList0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);

        final make1 =
            FDtag.fromValues(PTag.kOverallTemplateSpatialTolerance, <double>[]);
        expect(make1.hasValidValues, true);
        expect(make1.values, equals(<double>[]));
      }
    });

    test('FD make bad values', () {
      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float64List(2, 2);
        global.throwOnError = false;
        final make0 =
            FDtag.fromValues(PTag.kOverallTemplateSpatialTolerance, floatList0);
        expect(make0, isNull);

        global.throwOnError = true;
        expect(
            () => FDtag.fromValues(
                PTag.kOverallTemplateSpatialTolerance, floatList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('FD fromBase64', () {
      final s = Float64.toBase64(<double>[78678.11]);
      final bytes = Bytes.fromBase64(s);
      final e0 = FDtag.fromBytes(bytes, PTag.kOverallTemplateSpatialTolerance);
      expect(e0.hasValidValues, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final bytes0 = new Bytes.typedDataView(vList0);
        final base64 = bytes0.getBase64();
        final bytes1 = Bytes.fromBase64(base64);
        final e1 =
            FDtag.fromBytes(bytes1, PTag.kOverallTemplateSpatialTolerance);
        expect(e1.hasValidValues, true);

        final vList1 = bytes1.getFloat64List();
        final e2 =
            FDtag.fromValues(PTag.kOverallTemplateSpatialTolerance, vList1);
        expect(e2.hasValidValues, true);
      }
    });

    test('Create Elements from floating values(FD)', () {
      const vList = const <double>[2047.99, 2437.437, 764.53];
      final fd0 =
          new FDtag(PTag.kSelectorFDValue, new Float64List.fromList(vList));
      expect(fd0.values.first.toStringAsPrecision(1),
          equals((2047.99).toStringAsPrecision(1)));
    });

    test('FD checkLength good values', () {
      for (var i = 1; i < 10; i++) {
        final floatList0 = rng.float64List(1, i);
        final fd0 = new FDtag(PTag.kSelectorFDValue, floatList0);
        expect(fd0.checkLength(fd0.values), true);
      }
    });

    test('FD checkLength bad values', () {
      global.throwOnError = false;
      final fd0 = new FDtag(PTag.kTubeAngle, float64GoodList);
      expect(fd0, isNull);

      global.throwOnError = true;
      expect(() => new FDtag(PTag.kTubeAngle, float64GoodList),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('FD checkValues', () {
      for (var i = 1; i < 10; i++) {
        final floatList0 = rng.float64List(1, i);
        final fd0 = new FDtag(PTag.kSelectorFDValue, floatList0);
        expect(fd0.checkValues(fd0.values), true);
      }
    });
  });

  group('FD Element', () {
    //VM.k1
    const fdTags0 = const <PTag>[
      PTag.kEventTimeOffset,
      PTag.kReferencePixelPhysicalValueX,
      PTag.kReferencePixelPhysicalValueY,
      PTag.kPhysicalDeltaX,
      PTag.kPhysicalDeltaY,
      PTag.kTubeAngle,
    ];

    //VM.k2
    const fdTags1 = const <PTag>[
      PTag.kTimeRange,
      PTag.kReconstructionFieldOfView,
      PTag.kReconstructionPixelSpacing,
      PTag.kRecommendedRotationPoint,
      PTag.kTwoDMatingPoint,
      PTag.kRangeOfFreedom,
      PTag.kTwoDImplantTemplateGroupMemberMatchingPoint,
    ];

    //VM.k3
    const fdTags2 = const <PTag>[
      PTag.kDiffusionGradientOrientation,
      PTag.kVelocityEncodingDirection,
      PTag.kSlabOrientation,
      PTag.kMidSlabPosition,
      PTag.kASLSlabOrientation,
      PTag.kDataCollectionCenterPatient,
      PTag.kGridResolution,
    ];

    //VM.k4
    const fdTags3 = const <PTag>[
      PTag.kBoundingRectangle,
      PTag.kTwoDMatingAxes,
      PTag.kTwoDLineCoordinates,
      PTag.kDisplayEnvironmentSpatialPosition,
      PTag.kDoubleExposureFieldDelta,
      PTag.kTwoDImplantTemplateGroupMemberMatchingAxes,
    ];
    //VM.k6
    const fdTags4 = const <PTag>[PTag.kImageOrientationVolume];

    //VM.k9
    const fdTags5 = const <PTag>[
      PTag.kViewOrientationModifier,
      PTag.kThreeDMatingAxes,
      PTag.kThreeDImplantTemplateGroupMemberMatchingAxes,
    ];

    //VM.k1_n
    const fdTags6 = const <PTag>[
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

  // Urgent: moved to setUp above - also shouldn't this be rng.float64List?
  // final invalidVList = rng.float32List(FD.kMaxLength + 1, FD.kMaxLength + 1);

    test('FD isValidTag good values', () {
      global.throwOnError = false;
      expect(FD.isValidTag(PTag.kSelectorFDValue), true);

      for (var tag in fdTags0) {
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

      for (var s in fdTags0) {
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
        for (var tag in fdTags0) {
          expect(FD.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FD isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rng.float32List(2, i + 1);
        for (var tag in fdTags0) {
          global.throwOnError = false;
          expect(FD.isValidLength(tag, validMinVList), false);
          expect(FD.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => FD.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('FD isValidLength VM.k2 good values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rng.float32List(2, 2);
        global.throwOnError = false;
        for (var tag in fdTags1) {
          expect(FD.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FD isValidLength VM.k2 bad values', () {
      for (var i = 2; i < 10; i++) {
        final validMinVList = rng.float32List(3, i + 1);
        for (var tag in fdTags1) {
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
        for (var tag in fdTags2) {
          expect(FD.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FD isValidLength VM.k3 bad values', () {
      for (var i = 3; i < 10; i++) {
        final validMinVList = rng.float32List(4, i + 1);
        for (var tag in fdTags2) {
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
        for (var tag in fdTags3) {
          expect(FD.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FD isValidLength VM.k4 bad values', () {
      for (var i = 4; i < 10; i++) {
        final validMinVList = rng.float32List(5, i + 1);
        for (var tag in fdTags3) {
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
        for (var tag in fdTags4) {
          expect(FD.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FD isValidLength VM.k6 bad values', () {
      for (var i = 6; i < 10; i++) {
        final validMinVList = rng.float32List(7, i + 1);
        global.throwOnError = false;
        for (var tag in fdTags4) {
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
        for (var tag in fdTags5) {
          expect(FD.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FD isValidLength VM.k9 bad values', () {
      for (var i = 9; i < 20; i++) {
        final validMinVList = rng.float32List(10, i + 1);
        for (var tag in fdTags5) {
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
        for (var tag in fdTags6) {
          expect(FD.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('FD isValidVR good values', () {
      global.throwOnError = false;
      expect(FD.isValidVR(kFDIndex), true);

      for (var tag in fdTags0) {
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

      for (var tag in fdTags0) {
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

/*
    test('FD checkVRIndex good values', () {
      global.throwOnError = false;
      expect(FD.checkVRIndex(kFDIndex), kFDIndex);

      for (var tag in fdTags0) {
        global.throwOnError = false;
        expect(FD.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('FD checkVRIndex bad values', () {
      global.throwOnError = false;
      expect(
          FD.checkVRIndex(
            kAEIndex,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => FD.checkVRIndex(kAEIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(FD.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => FD.checkVRIndex(kAEIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('FD checkVRIndex good values', () {
      global.throwOnError = false;
      expect(FD.checkVRIndex(kFDIndex), equals(kFDIndex));

      for (var tag in fdTags0) {
        global.throwOnError = false;
        expect(FD.checkVRIndex(tag.vrIndex), equals(tag.vrIndex));
      }
    });

    test('FD checkVRIndex bad values', () {
      global.throwOnError = false;
      expect(FD.checkVRIndex(kATIndex), isNull);

      global.throwOnError = true;
      expect(() => FD.checkVRIndex(kATIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(FD.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => FD.checkVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('FD checkVRCode good values', () {
      global.throwOnError = false;
      expect(FD.checkVRCode(kFDCode), equals(kFDCode));

      for (var tag in fdTags0) {
        global.throwOnError = false;
        expect(FD.checkVRCode(tag.vrCode), equals(tag.vrCode));
      }
    });

    test('FD checkVRCode bad values', () {
      global.throwOnError = false;
      expect(FD.checkVRCode(kATCode), isNull);

      global.throwOnError = true;
      expect(() => FD.checkVRCode(kATCode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(FD.checkVRCode(tag.vrCode), isNull);

        global.throwOnError = true;
        expect(() => FD.checkVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });
*/

    test('FD isValidVFLength good values', () {
      expect(FD.isValidVFLength(FD.kMaxVFLength), true);
      expect(FD.isValidVFLength(0), true);
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
        final floatList0 = rng.float64List(1, 1);
        expect(Float64.fromList(floatList0), floatList0);
      }
    });

    test('Float64Mixin.fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float64List(1, 1);
        final float = new Float64List.fromList(floatList0);
        final bd = float.buffer.asUint8List();
        expect(Float64.fromUint8List(bd), equals(floatList0));
      }
      final float0 = new Float64List.fromList(<double>[]);
      final bd0 = float0.buffer.asUint8List();
      expect(Float64.fromUint8List(bd0), equals(<double>[]));
    });

    test('FD toBytes', () {
      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float64List(1, 1);
        final float64List0 = new Float64List.fromList(floatList0);
        final uInt8List0 = float64List0.buffer.asUint8List();
        final base64 = Float64.toBytes(float64List0);
        expect(base64, equals(uInt8List0));
      }
    });

    test('Create Float64Mixin.toByteData', () {
      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float64List(1, 1);
        final float64List0 = new Float64List.fromList(floatList0);
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
        final floatList0 = rng.float64List(1, 1);
        final float64List0 = new Float64List.fromList(floatList0);
        final bd = float64List0.buffer.asUint8List();
        expect(Float64.fromUint8List(bd), equals(floatList0));
      }
      final float0 = new Float64List.fromList(<double>[]);
      final bd0 = float0.buffer.asUint8List();
      expect(Float64.fromUint8List(bd0), equals(<double>[]));
    });

    test('FD fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float64List(1, 1);
        final float = new Float64List.fromList(floatList0);
        final byteData0 = float.buffer.asByteData();
        expect(Float64.fromByteData(byteData0), equals(floatList0));
      }
      final float0 = new Float64List.fromList(<double>[]);
      final bd0 = float0.buffer.asByteData();
      expect(Float64.fromByteData(bd0), equals(<double>[]));
    });
  });

  group('ODtags', () {
    test('OD hasValidValues good values', () {
      const float64LstCommon0 = const <double>[1.0];
      global.throwOnError = false;

      final od0 = new ODtag(PTag.kSelectorODValue, float64LstCommon0);
      expect(od0.hasValidValues, true);

      // empty list and null as values
      global.throwOnError = false;
      final od1 = new ODtag(PTag.kSelectorODValue, []);
      expect(od1.hasValidValues, true);
      expect(od1.values, equals(<double>[]));
    });

    test('OD hasValidValues bad values', () {
      final od1 = new ODtag(PTag.kSelectorODValue, null);
      log.debug('od1: $od1');
      expect(od1, isNull);

      global.throwOnError = true;
      expect(() => new ODtag(PTag.kSelectorODValue, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('OD hasValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(1, 1);
        final od0 = new ODtag(PTag.kSelectorODValue, float64List);
        log.debug('od0:$od0');
        expect(od0.hasValidValues, true);

        log..debug('od0: $od0, values: ${od0.values}')..debug('od0: $od0');
        expect(od0[0], equals(float64List[0]));
      }

      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(2, 4);
        log.debug('$i: float64List: $float64List');
        final od0 = new ODtag(PTag.kDoubleFloatPixelData, float64List);
        expect(od0.hasValidValues, true);
      }
    });

    test('OD update random', () {
      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(3, 4);
        final od0 = new ODtag(PTag.kSelectorODValue, float64List);
        final float64List1 = rng.float64List(3, 4);
        expect(od0.update(float64List1).values, equals(float64List1));
      }
    });

    test('OD update', () {
      final od0 = new ODtag(PTag.kSelectorODValue, []);
      expect(od0.update([1.0, 2.0]).values, equals([1.0, 2.0]));

      final od1 = new ODtag(PTag.kSelectorODValue, float64GoodList);
      expect(od1.update(float64GoodList).values, equals(float64GoodList));

      const floatUpdateValues = const <double>[
        546543.674, 6754764.45887, 54698.52, 787354.734768 // No reformat
      ];
      for (var i = 1; i <= floatUpdateValues.length - 1; i++) {
        final odValues = floatUpdateValues.take(i).toList();
        final od2 = new ODtag(
            PTag.kSelectorODValue, new Float64List.fromList(odValues));
        expect(
            od2.update(
                new Float64List.fromList(floatUpdateValues.take(i).toList())),
            equals(
                new Float64List.fromList(floatUpdateValues.take(i).toList())));

        expect(od2.update(floatUpdateValues.take(1).toList()).values,
            equals(floatUpdateValues.take(1).toList()));
      }
      final od3 = new ODtag(PTag.lookupByCode(0x00720073),
          new Float64List.fromList(floatUpdateValues));
      expect(od3.update(new Float64List.fromList(floatUpdateValues)),
          equals(new Float64List.fromList(floatUpdateValues)));
    });

    test('OD noValues random', () {
      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(3, 4);
        final od1 = new ODtag(PTag.kSelectorODValue, float64List);
        log.debug('od1: ${od1.noValues}');
        expect(od1.noValues.values.isEmpty, true);
      }
    });

    test('OD noValues', () {
      final od0 = new ODtag(PTag.kSelectorODValue, []);
      final ODtag odNoValues = od0.noValues;
      expect(odNoValues.values.isEmpty, true);
      log.debug('od0: ${od0.noValues}');

      final od1 = new ODtag(PTag.kSelectorODValue, float64GoodList);
      log.debug('od1: $od1');
      expect(odNoValues.values.isEmpty, true);
      log.debug('od1: ${od1.noValues}');
    });

    test('OD copy random', () {
      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(3, 4);
        final od2 = new ODtag(PTag.kDoubleFloatPixelData, float64List);
        final ODtag od3 = od2.copy;
        expect(od3 == od2, true);
        expect(od3.hashCode == od2.hashCode, true);
      }
    });

    test('OD copy', () {
      final od0 = new ODtag(PTag.kSelectorODValue, []);
      final ODtag od1 = od0.copy;
      expect(od1 == od0, true);
      expect(od1.hashCode == od0.hashCode, true);

      final od2 = new ODtag(PTag.kDoubleFloatPixelData, float64GoodList);
      final ODtag od3 = od2.copy;
      expect(od3 == od2, true);
      expect(od3.hashCode == od2.hashCode, true);
    });

    test('OD hashCode and == good values random', () {
      final rng = new RNG(1);
      List<double> floatList0;

      log.debug('OD hashCode and ==');
      for (var i = 0; i < 10; i++) {
        floatList0 = rng.float64List(1, 1);
        final od0 = new ODtag(PTag.kSelectorODValue, floatList0);
        final od1 = new ODtag(PTag.kSelectorODValue, floatList0);
        log
          ..debug('floatList0:$floatList0, od0.hash_code:${od0.hashCode}')
          ..debug('floatList0:$floatList0, od1.hash_code:${od1.hashCode}');
        expect(od0.hashCode == od1.hashCode, true);
        expect(od0 == od1, true);
      }
    });

    test('OD hashCode and == bad values random', () {
      final rng = new RNG(1);

      List<double> floatList0;
      List<double> floatList1;
      List<double> floatList2;

      for (var i = 0; i < 10; i++) {
        floatList0 = rng.float64List(1, 1);
        final od0 = new ODtag(PTag.kSelectorODValue, floatList0);

        floatList1 = rng.float64List(1, 1);
        final od2 = new ODtag(PTag.kDoubleFloatPixelData, floatList1);
        log.debug('floatList1:$floatList1 , od2.hash_code:${od2.hashCode}');
        expect(od0.hashCode == od2.hashCode, false);
        expect(od0 == od2, false);

        floatList2 = rng.float64List(2, 3);
        final od3 = new ODtag(PTag.kDoubleFloatPixelData, floatList2);
        log.debug('floatList2:$floatList2 , od3.hash_code:${od3.hashCode}');
        expect(od0.hashCode == od3.hashCode, false);
        expect(od0 == od3, false);
      }
    });

    test('OD hashCode and == good values', () {
      final od0 = new ODtag(PTag.kSelectorODValue, float64GoodList.take(1));
      final od1 = new ODtag(PTag.kSelectorODValue, float64GoodList.take(1));
      log
        ..debug('floatList0:$float64GoodList, od0.hash_code:${od0
          .hashCode}')
        ..debug('floatList0:$float64GoodList, od1.hash_code:${od1.hashCode}');
      expect(od0.hashCode == od1.hashCode, true);
      expect(od0 == od1, true);
    });

    test('OD hashCode and == bad values', () {
      final od0 = new ODtag(PTag.kSelectorODValue, float64GoodList.take(1));

      final od1 =
          new ODtag(PTag.kDoubleFloatPixelData, float64GoodList.take(1));
      log.debug('float64LstCommon0:$float64GoodList , '
          'od1.hash_code:${od1.hashCode}');
      expect(od0.hashCode == od1.hashCode, false);
      expect(od0 == od1, false);
    });

    test('OD replace random', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float64List(1, 1);
        final od0 = new ODtag(PTag.kSelectorODValue, floatList0);
        final floatList1 = rng.float64List(1, 1);
        expect(od0.replace(floatList1), equals(floatList0));
        expect(od0.values, equals(floatList1));
      }

      final floatList1 = rng.float64List(1, 1);
      final od1 = new ODtag(PTag.kSelectorODValue, floatList1);
      expect(od1.replace(<double>[]), equals(floatList1));
      expect(od1.values, equals(<double>[]));

      final od2 = new ODtag(PTag.kSelectorODValue, floatList1);
      expect(od2.replace(null), equals(floatList1));
      expect(od2.values, equals(<double>[]));
    });

    test('OD fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final bytes0 = new Bytes.typedDataView(vList0);
        final od0 = ODtag.fromBytes(bytes0, PTag.kSelectorODValue);
        log.debug('od0: $od0');
        expect(od0.hasValidValues, true);

        final vList1 = rng.float64List(2, 2);
        final bytes1 = new Bytes.typedDataView(vList1);
        final od1 = ODtag.fromBytes(bytes1, PTag.kSelectorODValue);
        log.debug('od1 $od1');
        expect(od1.hasValidValues, true);
      }
    });

    test('OD fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float64List(1, 1);
        final bytes = new Bytes.typedDataView(vList);
        final od0 = ODtag.fromBytes(bytes, PTag.kSelectorODValue);
        log.debug('od0: $od0');
        expect(od0.hasValidValues, true);
      }
    });

    test('OD fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.float64List(1, 10);
        final bytes = new Bytes.typedDataView(vList);
        final od0 = ODtag.fromBytes(bytes, PTag.kSelectorSSValue);
        expect(od0, isNull);

        global.throwOnError = true;
        expect(() => ODtag.fromBytes(bytes, PTag.kSelectorSSValue),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('OD make good values', () {
      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float64List(1, 1);
        final make0 = ODtag.fromValues(PTag.kSelectorODValue, floatList0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);

        final make1 = ODtag.fromValues(PTag.kSelectorODValue, <double>[]);
        expect(make1.hasValidValues, true);
        expect(make1.values, equals(<double>[]));
      }
    });

    test('ODtag.fromBase64', () {
      global.throwOnError = false;
      final s0 = Float64.toBase64(<double>[78678.11, 12345.678]);
      log.debug('b64: $s0');
      final bytes0 = Bytes.fromBase64(s0);
      final od0 = ODtag.fromBytes(bytes0, PTag.kSelectorODValue);
      log.debug('od0: $od0');
      expect(od0.hasValidValues, true);

      for (var i = 0; i < 10; i++) {
        final vList1 = rng.float64List(1, 1);
        final s1 = Float64.toBase64(vList1);
        final bytes1 = Bytes.fromBase64(s1);
        final od1 = ODtag.fromBytes(bytes1, PTag.kSelectorODValue);
        expect(od1.hasValidValues, true);
      }
    });

    test('Create Elements from floating values(OD)', () {
      const f64Values = const <double>[2047.99, 2437.437, 764.53];

      final od0 =
          new ODtag(PTag.kSelectorODValue, new Float64List.fromList(f64Values));
      expect(od0.values.first.toStringAsPrecision(1),
          equals((2047.99).toStringAsPrecision(1)));
    });

    test('OD checkLength good values', () {
      for (var i = 1; i < 10; i++) {
        final floatList0 = rng.float64List(1, i);
        final od0 = new ODtag(PTag.kSelectorODValue, floatList0);
        expect(od0.checkLength(od0.values), true);
      }
    });

    test('OD checkValues', () {
      for (var i = 1; i < 10; i++) {
        final floatList0 = rng.float64List(1, i);
        final od0 = new ODtag(PTag.kSelectorODValue, floatList0);
        expect(od0.checkValues(od0.values), true);
      }
    });
  });

  group('OD Element', () {
    const odTags = const <PTag>[
      PTag.kSelectorODValue,
      PTag.kDoubleFloatPixelData,
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

    test('OD isValidTag good values', () {
      global.throwOnError = false;
      expect(OD.isValidTag(PTag.kSelectorODValue), true);

      for (var tag in odTags) {
        final validT0 = OD.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('OD isValidTag bad values', () {
      global.throwOnError = false;
      expect(OD.isValidTag(PTag.kSelectorFLValue), false);
      global.throwOnError = true;
      expect(() => OD.isValidTag(PTag.kSelectorFLValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = OD.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => OD.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('OD isValidVR good values', () {
      global.throwOnError = false;
      expect(OD.isValidVR(kODIndex), true);

      for (var s in odTags) {
        global.throwOnError = false;
        expect(OD.isValidVR(s.vrIndex), true);
      }
    });

    test('OD isValidVR bad values', () {
      global.throwOnError = false;
      expect(OD.isValidVR(kAEIndex), false);

      global.throwOnError = true;
      expect(() => OD.isValidVR(kAEIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var s in otherTags) {
        global.throwOnError = false;
        expect(OD.isValidVR(s.vrIndex), false);

        global.throwOnError = true;
        expect(() => OD.isValidVR(s.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('OD.isValidVFLength good values', () {
      global.throwOnError = false;
      expect(OD.isValidVFLength(OD.kMaxVFLength), true);
      expect(OD.isValidVFLength(0), true);
    });

    test('OD.isValidVFLength bad values', () {
      global.throwOnError = false;
      expect(OD.isValidVFLength(OD.kMaxVFLength + 1), false);
      expect(OD.isValidVFLength(-1), false);
    });

    test('OD.isValidVR good values', () {
      global.throwOnError = false;
      expect(OD.isValidVR(kODIndex), true);

      for (var tag in odTags) {
        global.throwOnError = false;
        expect(OD.isValidVR(tag.vrIndex), true);
      }
    });

    test('OD.isValidVR bad values', () {
      global.throwOnError = false;
      expect(OD.isValidVR(kATIndex), false);

      global.throwOnError = true;
      expect(() => OD.isValidVR(kATIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OD.isValidVR(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => OD.isValidVR(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('OD.isValidVRCode good values', () {
      global.throwOnError = false;
      expect(OD.isValidVRCode(kODCode), true);

      for (var tag in odTags) {
        global.throwOnError = false;
        expect(OD.isValidVRCode(tag.vrCode), true);
      }
    });

    test('OD.isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(OD.isValidVRCode(kATCode), false);

      global.throwOnError = true;
      expect(() => OD.isValidVRCode(kATCode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OD.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => OD.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

/*
    test('OD checkVR good values', () {
      global.throwOnError = false;
      expect(OD.checkVRIndex(kODIndex), kODIndex);

      for (var tag in odTags) {
        global.throwOnError = false;
        expect(OD.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('OD checkVR bad values', () {
      global.throwOnError = false;
      expect(
          OD.checkVRIndex(
            kAEIndex,
          ),
          isNull);
      global.throwOnError = true;
      expect(() => OD.checkVRIndex(kAEIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OD.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => OD.checkVRIndex(kAEIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('OD checkVRIndex good values', () {
      global.throwOnError = false;
      expect(OD.checkVRIndex(kODIndex), equals(kODIndex));

      for (var tag in odTags) {
        global.throwOnError = false;
        expect(OD.checkVRIndex(tag.vrIndex), equals(tag.vrIndex));
      }
    });

    test('OD checkVRIndex bad values', () {
      global.throwOnError = false;
      expect(OD.checkVRIndex(kATIndex), isNull);

      global.throwOnError = true;
      expect(() => OD.checkVRIndex(kATIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OD.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => OD.checkVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('OD checkVRCode good values', () {
      global.throwOnError = false;
      expect(OD.checkVRCode(kODCode), equals(kODCode));

      for (var tag in odTags) {
        global.throwOnError = false;
        expect(OD.checkVRCode(tag.vrCode), equals(tag.vrCode));
      }
    });

    test('OD checkVRCode bad values', () {
      global.throwOnError = false;
      expect(OD.checkVRCode(kATCode), isNull);

      global.throwOnError = true;
      expect(() => OD.checkVRCode(kATCode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OD.checkVRCode(tag.vrCode), isNull);

        global.throwOnError = true;
        expect(() => OD.checkVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });
*/

    test('OD isValidVFLength good values', () {
      expect(OD.isValidVFLength(OD.kMaxVFLength), true);
      expect(OD.isValidVFLength(0), true);
    });

    test('OD isValidVFLength bad values', () {
      expect(OD.isValidVFLength(OD.kMaxVFLength + 1), false);
      expect(OD.isValidVFLength(-1), false);
    });

    test('OD.isValidValues', () {
      global.throwOnError = false;
      for (var i = 0; i <= float64GoodList.length - 1; i++) {
        expect(
            OD.isValidValues(
                PTag.kSelectorODValue, <double>[float64GoodList[i]]),
            true);
      }
    });

    test('Flaot64Base.fromList', () {
      expect(Float64.fromList(float64GoodList), float64GoodList);

      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float64List(1, 1);
        expect(Float64.fromList(floatList0), floatList0);
      }
    });

    test('Float64Mixin.fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final bList0 = vList0.buffer.asUint8List();
        expect(Float64.fromUint8List(bList0), equals(vList0));
      }
      final vList1 = new Float64List.fromList(<double>[]);
      final bList1 = vList1.buffer.asUint8List();
      expect(Float64.fromUint8List(bList1), equals(<double>[]));
    });

    test('Create Float64Mixin.toBytes', () {
      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float64List(1, 1);
        final float64List0 = new Float64List.fromList(floatList0);
        final uInt8List0 = float64List0.buffer.asUint8List();
        //final base64 = cvt.base64.encode(uInt8List0);
        final base64 = Float64.toBytes(float64List0);
        expect(base64, equals(uInt8List0));
      }
    });

    test('OD.decode/encode binaryVF', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        expect(vList0.lengthInBytes.isEven, true);
        expect(vList0.length == 1, true);

        final bList0 = vList0.buffer.asUint8List();
        final s0 = base64.encode(bList0);
        final bList1 = base64.decode(s0);
        expect(bList1, equals(bList0));

        final bList2 = Float64.toUint8List(vList0);
        expect(bList2, equals(bList1));

        final vList1 = Float64.fromUint8List(bList1);
        expect(vList1, equals(vList0));

        final vList2 = Float64.fromUint8List(bList2);
        expect(vList2, equals(vList0));
        expect(vList2, equals(vList1));
      }
    });

    test('OD.fromBase64', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(0, i);
        final bList0 = vList0.buffer.asUint8List();
        final s0 = base64.encode(bList0);
        expect(Float64.fromBase64(s0), vList0);
      }
    });

    test('OD.fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float64List(0, i);
        final float64List0 = new Float64List.fromList(floatList0);
        expect(floatList0.lengthInBytes.isEven, true);
        final bd = float64List0.buffer.asUint8List();
        expect(Float64.fromUint8List(bd), equals(floatList0));
      }
      final float0 = new Float64List.fromList(<double>[]);
      final bd0 = float0.buffer.asUint8List();
      expect(Float64.fromUint8List(bd0), equals(<double>[]));
    });

    test('OD.fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float64List(1, 1);
        final float = new Float64List.fromList(floatList0);
        final byteData0 = float.buffer.asByteData();
        expect(Float64.fromByteData(byteData0), equals(floatList0));
      }
      final float0 = new Float64List.fromList(<double>[]);
      final bd0 = float0.buffer.asByteData();
      expect(Float64.fromByteData(bd0), equals(<double>[]));
    });
  });
}
