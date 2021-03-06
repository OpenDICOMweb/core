// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/float64_test', level: Level.info);
  final rng = new RNG(1);

  final float64LstCommon0 = const <double>[
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

  system.throwOnError = false;

  group('FDtags', () {
    test('FD hasValidValues good values', () {
      final fd0 = new FDtag(PTag.kSelectorFDValue, float64LstCommon0);
      expect(fd0.hasValidValues, true);

      // empty list and null as values
      system.throwOnError = false;
      final fd1 = new FDtag(PTag.kSelectorFDValue, []);
      expect(fd1.hasValidValues, true);
      expect(fd1.values, equals(<double>[]));
    });

    test('FD hasValidValues bad values', () {
      final fd1 = new FDtag(PTag.kSelectorFDValue, null);
      log.debug('fd1: $fd1');
      expect(fd1, isNull);
      //expect(fd1.values.isEmpty, true);

      system.throwOnError = true;
      expect(() => new FDtag(PTag.kSelectorFDValue, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('FD hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(1, 1);
        final fd0 =
            new FDtag(PTag.kOverallTemplateSpatialTolerance, float64List);
        log.debug('fd0:${fd0.info}');
        expect(fd0.hasValidValues, true);

        log
          ..debug('fd0: $fd0, values: ${fd0.values}')
          ..debug('fd0: ${fd0.info}');
        expect(fd0[0], equals(float64List[0]));
      }

      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(2, 2);
        final fd0 = new FDtag(PTag.kRecommendedRotationPoint, float64List);
        expect(fd0.hasValidValues, true);

        log
          ..debug('fd0: $fd0, values: ${fd0.values}')
          ..debug('fd0: ${fd0.info}');
        expect(fd0[0], equals(float64List[0]));
      }
    });

    test('FD hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final float64List = rng.float64List(3, 4);
        log.debug('$i: float64List: $float64List');
        final fd0 = new FDtag(PTag.kRecommendedRotationPoint, float64List);
        expect(fd0, isNull);

        system.throwOnError = true;
        expect(() => new FDtag(PTag.kRecommendedRotationPoint, float64List),
            throwsA(const isInstanceOf<InvalidValuesLengthError>()));
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

      final fd1 = new FDtag(PTag.kSelectorFDValue, float64LstCommon0);
      expect(fd1.update(float64LstCommon0).values, equals(float64LstCommon0));
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
      system.throwOnError = false;
      final fd0 = new FDtag(PTag.kOverallTemplateSpatialTolerance, []);
      final FDtag fdNoValues = fd0.noValues;
      expect(fdNoValues.values.isEmpty, true);
      log.debug('fd0: ${fd0.noValues}');

      final fd1 =
          new FDtag(PTag.kOverallTemplateSpatialTolerance, float64LstCommon0);
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

      final fd2 = new FDtag(PTag.kSelectorFDValue, float64LstCommon0);
      final FDtag fd3 = fd2.copy;
      expect(fd3 == fd2, true);
      expect(fd3.hashCode == fd2.hashCode, true);
    });

    test('FD hashCode and == good values random', () {
      system.throwOnError = false;
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
      system.throwOnError = false;
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
      system.throwOnError = false;
      final fd0 = new FDtag(
          PTag.kOverallTemplateSpatialTolerance, float64LstCommon0.take(1));
      final fd1 = new FDtag(
          PTag.kOverallTemplateSpatialTolerance, float64LstCommon0.take(1));
      log
        ..debug('float64LstCommon0:$float64LstCommon0, fd0.hash_code:${fd0
              .hashCode}')
        ..debug('float64LstCommon0:$float64LstCommon0, fd1.hash_code:${fd1
              .hashCode}');
      expect(fd0.hashCode == fd1.hashCode, true);
      expect(fd0 == fd1, true);
    });

    test('FD hashCode and == bad values', () {
      system.throwOnError = false;
      final fd0 = new FDtag(
          PTag.kOverallTemplateSpatialTolerance, float64LstCommon0.take(1));
      final fd2 =
          new FDtag(PTag.kCineRelativeToRealTime, float64LstCommon0.take(1));
      log.debug(
          'float64LstCommon0:$float64LstCommon0 , fd2.hash_code:${fd2.hashCode}');
      expect(fd0.hashCode == fd2.hashCode, false);
      expect(fd0 == fd2, false);

      final fd3 = new FDtag(PTag.kTwoDMatingPoint, float64LstCommon0.take(2));
      log.debug(
          'float64LstCommon0:$float64LstCommon0 , fd3.hash_code:${fd3.hashCode}');
      expect(fd0.hashCode == fd3.hashCode, false);
      expect(fd0 == fd3, false);

      final fd4 = new FDtag(PTag.kGridResolution, float64LstCommon0.take(3));
      log.debug(
          'float64LstCommon0:$float64LstCommon0 , fd4.hash_code:${fd4.hashCode}');
      expect(fd0.hashCode == fd4.hashCode, false);
      expect(fd0 == fd4, false);

      final fd5 = new FDtag(PTag.kBoundingRectangle, float64LstCommon0.take(4));
      log.debug(
          'float64LstCommon0:$float64LstCommon0 , fd5.hash_code:${fd5.hashCode}');
      expect(fd0.hashCode == fd5.hashCode, false);
      expect(fd0 == fd5, false);

      final fd6 =
          new FDtag(PTag.kImageOrientationVolume, float64LstCommon0.take(6));
      log.debug(
          'float64LstCommon0:$float64LstCommon0 , fd6.hash_code:${fd6.hashCode}');
      expect(fd0.hashCode == fd6.hashCode, false);
      expect(fd0 == fd6, false);

      final fd7 = new FDtag(PTag.kThreeDMatingAxes, float64LstCommon0.take(9));
      log.debug(
          'float64LstCommon0:$float64LstCommon0 , fd7.hash_code:${fd7.hashCode}');
      expect(fd0.hashCode == fd7.hashCode, false);
      expect(fd0 == fd7, false);

      final fd8 = new FDtag(PTag.kSelectorFDValue, float64LstCommon0);
      log.debug(
          'float64LstCommon0:$float64LstCommon0 , fd8.hash_code:${fd8.hashCode}');
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
        final floatList0 = rng.float64List(1, 1);
        final float = new Float64List.fromList(floatList0);
        final bytes = float.buffer.asUint8List();
        final fd0 =
            FDtag.fromBytes(PTag.kOverallTemplateSpatialTolerance, bytes);
        log.debug('fd0: ${fd0.info}');
        expect(fd0.hasValidValues, true);

        final floatList1 = rng.float64List(2, 2);
        final float0 = new Float64List.fromList(floatList1);
        final bytes0 = float0.buffer.asUint8List();
        final fd1 =
            FDtag.fromBytes(PTag.kOverallTemplateSpatialTolerance, bytes0);
        log.debug('fd1: ${fd1.info}');
        expect(fd1.hasValidValues, false);
      }
    });

    test('FD fromBase64', () {
      final fString = Float64Base.listToBase64(<double>[78678.11]);
      final fd0 =
          FDtag.fromBase64(PTag.kOverallTemplateSpatialTolerance, fString);
      expect(fd0.hasValidValues, true);

      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float64List(1, 1);
        final float64List0 = new Float64List.fromList(floatList0);
        final uInt8List0 = float64List0.buffer.asUint8List();
        final base64 = BASE64.encode(uInt8List0);
        final fd1 =
            FDtag.fromBase64(PTag.kOverallTemplateSpatialTolerance, base64);
        expect(fd1.hasValidValues, true);
      }
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

      final invalidVList =
          rng.float32List(FD.kMaxLength + 1, FD.kMaxLength + 1);

      test('FD isValidVR good values', () {
        system.throwOnError = false;
        expect(FD.isValidVRIndex(kFDIndex), true);

        for (var s in fdTags0) {
          system.throwOnError = false;
          expect(FD.isValidVRIndex(s.vrIndex), true);
        }
      });

      test('FD isValidVR bad values', () {
        system.throwOnError = false;
        expect(FD.isValidVRIndex(kAEIndex), false);

        system.throwOnError = true;
        expect(() => FD.isValidVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var otherTag in otherTags) {
          system.throwOnError = false;
          expect(FD.isValidVRIndex(otherTag.vrIndex), false);

          system.throwOnError = true;
          expect(() => FD.isValidVRIndex(otherTag.vrIndex),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('FD isValidLength VM.k1 good values', () {
        for (var i = 0; i < 10; i++) {
          final validMinVList = rng.float32List(1, 1);
          system.throwOnError = false;
          for (var tag in fdTags0) {
            expect(FD.isValidLength(tag, validMinVList), true);
          }
        }
      });

      test('FD isValidLength VM.k1 bad values', () {
        for (var i = 1; i < 10; i++) {
          final validMinVList = rng.float32List(2, i + 1);
          system.throwOnError = false;
          for (var tag in fdTags0) {
            expect(FD.isValidLength(tag, validMinVList), false);
          }
        }
      });

      test('FD isValidLength VM.k2 good values', () {
        for (var i = 0; i < 10; i++) {
          final validMinVList = rng.float32List(2, 2);
          system.throwOnError = false;
          for (var tag in fdTags1) {
            expect(FD.isValidLength(tag, validMinVList), true);
          }
        }
      });

      test('FD isValidLength VM.k2 bad values', () {
        for (var i = 2; i < 10; i++) {
          final validMinVList = rng.float32List(3, i + 1);
          system.throwOnError = false;
          for (var tag in fdTags1) {
            expect(FD.isValidLength(tag, validMinVList), false);
          }
        }
      });

      test('FD isValidLength VM.k3 good values', () {
        for (var i = 0; i < 10; i++) {
          final validMinVList = rng.float32List(3, 3);
          system.throwOnError = false;
          for (var tag in fdTags2) {
            expect(FD.isValidLength(tag, validMinVList), true);
          }
        }
      });

      test('FD isValidLength VM.k3 bad values', () {
        for (var i = 3; i < 10; i++) {
          final validMinVList = rng.float32List(4, i + 1);
          system.throwOnError = false;
          for (var tag in fdTags2) {
            expect(FD.isValidLength(tag, validMinVList), false);
          }
        }
      });

      test('FD isValidLength VM.k4 good values', () {
        for (var i = 0; i < 10; i++) {
          final validMinVList = rng.float32List(4, 4);
          system.throwOnError = false;
          for (var tag in fdTags3) {
            expect(FD.isValidLength(tag, validMinVList), true);
          }
        }
      });

      test('FD isValidLength VM.k4 bad values', () {
        for (var i = 4; i < 10; i++) {
          final validMinVList = rng.float32List(5, i + 1);
          system.throwOnError = false;
          for (var tag in fdTags3) {
            expect(FD.isValidLength(tag, validMinVList), false);
          }
        }
      });

      test('FD isValidLength VM.k6 good values', () {
        for (var i = 0; i < 10; i++) {
          final validMinVList = rng.float32List(6, 6);
          system.throwOnError = false;
          for (var tag in fdTags4) {
            expect(FD.isValidLength(tag, validMinVList), true);
          }
        }
      });

      test('FD isValidLength VM.k6 bad values', () {
        for (var i = 6; i < 10; i++) {
          final validMinVList = rng.float32List(7, i + 1);
          system.throwOnError = false;
          for (var tag in fdTags4) {
            expect(FD.isValidLength(tag, validMinVList), false);
          }
        }
      });

      test('FD isValidLength VM.k9 good values', () {
        for (var i = 0; i < 10; i++) {
          final validMinVList = rng.float32List(9, 9);
          system.throwOnError = false;
          for (var tag in fdTags5) {
            expect(FD.isValidLength(tag, validMinVList), true);
          }
        }
      });

      test('FD isValidLength VM.k9 bad values', () {
        for (var i = 9; i < 20; i++) {
          final validMinVList = rng.float32List(10, i + 1);
          system.throwOnError = false;
          for (var tag in fdTags5) {
            expect(FD.isValidLength(tag, validMinVList), false);
          }
        }
      });

      test('FD isValidLength VM.k1_n good values', () {
        for (var i = 1; i < 10; i++) {
          final validMinVList = rng.float32List(1, i);
          system.throwOnError = false;
          for (var tag in fdTags6) {
            expect(FD.isValidLength(tag, validMinVList), true);
          }
        }
      });

      test('FD isValidLength bad values', () {
        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(FD.isValidLength(tag, invalidVList), false);

          system.throwOnError = true;
          expect(() => FD.isValidLength(tag, invalidVList),
              throwsA(const isInstanceOf<InvalidValuesLengthError>()));
        }
      });

      test('FD isValidVRIndex good values', () {
        system.throwOnError = false;
        expect(FD.isValidVRIndex(kFDIndex), true);

        for (var tag in fdTags0) {
          system.throwOnError = false;
          expect(FD.isValidVRIndex(tag.vrIndex), true);
        }
      });

      test('FD isValidVRIndex bad values', () {
        system.throwOnError = false;
        expect(FD.isValidVRIndex(kATIndex), false);

        system.throwOnError = true;
        expect(() => FD.isValidVRIndex(kATIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(FD.isValidVRIndex(tag.vrIndex), false);

          system.throwOnError = true;
          expect(() => FD.isValidVRIndex(tag.vrIndex),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('FD isValidVRCode good values', () {
        system.throwOnError = false;
        expect(FD.isValidVRCode(kFDCode), true);

        for (var tag in fdTags0) {
          system.throwOnError = false;
          expect(FD.isValidVRCode(tag.vrCode), true);
        }
      });

      test('FD isValidVRCode bad values', () {
        system.throwOnError = false;
        expect(FD.isValidVRCode(kATCode), false);

        system.throwOnError = true;
        expect(() => FD.isValidVRCode(kATCode),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(FD.isValidVRCode(tag.vrCode), false);

          system.throwOnError = true;
          expect(() => FD.isValidVRCode(tag.vrCode),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('FD checkVRIndex good values', () {
        system.throwOnError = false;
        expect(FD.checkVRIndex(kFDIndex), kFDIndex);

        for (var tag in fdTags0) {
          system.throwOnError = false;
          expect(FD.checkVRIndex(tag.vrIndex), tag.vrIndex);
        }
      });

      test('FD checkVRIndex bad values', () {
        system.throwOnError = false;
        expect(
            FD.checkVRIndex(
              kAEIndex,
            ),
            isNull);
        system.throwOnError = true;
        expect(() => FD.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(FD.checkVRIndex(tag.vrIndex), isNull);

          system.throwOnError = true;
          expect(() => FD.checkVRIndex(kAEIndex),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('FD checkVRIndex good values', () {
        system.throwOnError = false;
        expect(FD.checkVRIndex(kFDIndex), equals(kFDIndex));

        for (var tag in fdTags0) {
          system.throwOnError = false;
          expect(FD.checkVRIndex(tag.vrIndex), equals(tag.vrIndex));
        }
      });

      test('FD checkVRIndex bad values', () {
        system.throwOnError = false;
        expect(FD.checkVRIndex(kATIndex), isNull);

        system.throwOnError = true;
        expect(() => FD.checkVRIndex(kATIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(FD.checkVRIndex(tag.vrIndex), isNull);

          system.throwOnError = true;
          expect(() => FD.checkVRIndex(tag.vrIndex),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('FD checkVRCode good values', () {
        system.throwOnError = false;
        expect(FD.checkVRCode(kFDCode), equals(kFDCode));

        for (var tag in fdTags0) {
          system.throwOnError = false;
          expect(FD.checkVRCode(tag.vrCode), equals(tag.vrCode));
        }
      });

      test('FD checkVRCode bad values', () {
        system.throwOnError = false;
        expect(FD.checkVRCode(kATCode), isNull);

        system.throwOnError = true;
        expect(() => FD.checkVRCode(kATCode),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(FD.checkVRCode(tag.vrCode), isNull);

          system.throwOnError = true;
          expect(() => FD.checkVRCode(tag.vrCode),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('FD isValidVFLength good values', () {
        expect(FD.isValidVFLength(FD.kMaxVFLength), true);
        expect(FD.isValidVFLength(0), true);
      });

      test('FD isValidVFLength bad values', () {
        expect(FD.isValidVFLength(FD.kMaxVFLength + 1), false);
        expect(FD.isValidVFLength(-1), false);
      });

      test('FD isValidValues good values', () {
        system.throwOnError = false;
        //VM.k1
        for (var i = 0; i <= float64LstCommon0.length - 1; i++) {
          expect(
              FD.isValidValues(
                  PTag.kEffectiveEchoTime, <double>[float64LstCommon0[i]]),
              true);
        }

        //VM.k2
        expect(
            FD.isValidValues(
                PTag.kReconstructionFieldOfView, float64LstCommon0.take(2)),
            true);

        //VM.k3
        expect(
            FD.isValidValues(PTag.kGridResolution, float64LstCommon0.take(3)),
            true);

        //VM.k4
        expect(
            FD.isValidValues(
                PTag.kBoundingRectangle, float64LstCommon0.take(4)),
            true);

        //VM.k6
        expect(
            FD.isValidValues(
                PTag.kImageOrientationVolume, float64LstCommon0.take(6)),
            true);

        //VM.k9
        expect(
            FD.isValidValues(PTag.kThreeDMatingAxes, float64LstCommon0.take(9)),
            true);

        //VM.k1_n
        expect(
            FD.isValidValues(PTag.kSelectorFDValue, float64LstCommon0), true);
      });

      test('FD isValidValues bad values length', () {
        system.throwOnError = false;
        expect(FD.isValidValues(PTag.kEffectiveEchoTime, float64LstCommon0),
            false);

        system.throwOnError = true;
        expect(
            () => FD.isValidValues(PTag.kEffectiveEchoTime, float64LstCommon0),
            throwsA(const isInstanceOf<InvalidValuesLengthError>()));
      });

      test('Float64Base.toFloat64List', () {
        expect(Float64Base.toFloat64List(float64LstCommon0), float64LstCommon0);

        for (var i = 0; i < 10; i++) {
          final floatList0 = rng.float64List(1, 1);
          expect(Float64Base.toFloat64List(floatList0), floatList0);
        }
      });

      test('Float64Base.listFromBytes', () {
        for (var i = 0; i < 10; i++) {
          final floatList0 = rng.float64List(1, 1);
          final float = new Float64List.fromList(floatList0);
          final bd = float.buffer.asUint8List();
          expect(Float64Base.listFromBytes(bd), equals(floatList0));
        }
        final float0 = new Float64List.fromList(<double>[]);
        final bd0 = float0.buffer.asUint8List();
        expect(Float64Base.listFromBytes(bd0), equals(<double>[]));
      });

      test('FD toBytes', () {
        for (var i = 0; i < 10; i++) {
          final floatList0 = rng.float64List(1, 1);
          final float64List0 = new Float64List.fromList(floatList0);
          final uInt8List0 = float64List0.buffer.asUint8List();
          //final base64 = BASE64.encode(uInt8List0);
          final base64 = Float64Base.listToBytes(float64List0);
          expect(base64, equals(uInt8List0));
        }
      });

      test('Float64Base.listFromBase64', () {
        system.level = Level.info;
        for (var i = 0; i < 10; i++) {
          final floatList0 = rng.float64List(0, i);
          final float64List0 = new Float64List.fromList(floatList0);
          final uInt8List0 = float64List0.buffer.asUint8List();
          final base64 = BASE64.encode(uInt8List0);
          log.debug('FD.base64: "$base64"');

          final fdList = Float64Base.listFromBase64(base64);
          log.debug('  FD.decode: $fdList');
          expect(fdList, equals(floatList0));
          expect(fdList, equals(float64List0));
        }
      });

      test('Float64Base.listToBase64', () {
        for (var i = 0; i < 10; i++) {
          final floatList0 = rng.float64List(0, i);
          final float64List0 = new Float64List.fromList(floatList0);
          final uInt8List0 = float64List0.buffer.asUint8List();
          final base64 = BASE64.encode(uInt8List0);
          final fd0 = Float64Base.listToBase64(floatList0);
          expect(fd0, equals(base64));
        }
      });

      test('Float64Base encodeDecodeJsonVF', () {
        system.level = Level.info;
        for (var i = 1; i < 10; i++) {
          final floatList0 = rng.float64List(1, i);
          final float64List0 = new Float64List.fromList(floatList0);
          final uInt8List0 = float64List0.buffer.asUint8List();

          // Encode
          final base64 = BASE64.encode(uInt8List0);
          log.debug('FD.base64: "$base64"');
          final s = Float64Base.listToBase64(floatList0);
          log.debug('  FD.json: "$s"');
          expect(s, equals(base64));

          // Decode
          final fd0 = Float64Base.listFromBase64(base64);
          log.debug('FD.base64: $fd0');
          final fd1 = Float64Base.listFromBase64(s);
          log.debug('  FD.json: $fd1');
          expect(fd0, equals(floatList0));
          expect(fd0, equals(float64List0));
          expect(fd0, equals(fd1));
        }
      });

      test('Float64Base.listFromBytes', () {
        for (var i = 0; i < 10; i++) {
          final floatList0 = rng.float64List(1, 1);
          final float64List0 = new Float64List.fromList(floatList0);
          final bd = float64List0.buffer.asUint8List();
          expect(Float64Base.listFromBytes(bd), equals(floatList0));
        }
        final float0 = new Float64List.fromList(<double>[]);
        final bd0 = float0.buffer.asUint8List();
        expect(Float64Base.listFromBytes(bd0), equals(<double>[]));
      });

      test('FD fromByteData', () {
        for (var i = 0; i < 10; i++) {
          final floatList0 = rng.float64List(1, 1);
          final float = new Float64List.fromList(floatList0);
          final byteData0 = float.buffer.asByteData();
          expect(Float64Base.listFromByteData(byteData0), equals(floatList0));
        }
        final float0 = new Float64List.fromList(<double>[]);
        final bd0 = float0.buffer.asByteData();
        expect(Float64Base.listFromByteData(bd0), equals(<double>[]));
      });
    });
  });

  group('ODtags', () {
    test('OD hasValidValues good values', () {
      final float64LstCommon0 = const <double>[1.0];
      system.throwOnError = false;

      final od0 = new ODtag(PTag.kSelectorODValue, float64LstCommon0);
      expect(od0.hasValidValues, true);

      // empty list and null as values
      system.throwOnError = false;
      final od1 = new ODtag(PTag.kSelectorODValue, []);
      expect(od1.hasValidValues, true);
      expect(od1.values, equals(<double>[]));
    });

    test('OD hasValidValues bad values', () {
      final od1 = new ODtag(PTag.kSelectorODValue, null);
      log.debug('od1: $od1');
      expect(od1, isNull);

      system.throwOnError = true;
      expect(() => new ODtag(PTag.kSelectorODValue, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('OD hasValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(1, 1);
        final od0 = new ODtag(PTag.kSelectorODValue, float64List);
        log.debug('od0:${od0.info}');
        expect(od0.hasValidValues, true);

        log
          ..debug('od0: $od0, values: ${od0.values}')
          ..debug('od0: ${od0.info}');
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

      final od1 = new ODtag(PTag.kSelectorODValue, float64LstCommon0);
      expect(od1.update(float64LstCommon0).values, equals(float64LstCommon0));
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

      final od1 = new ODtag(PTag.kSelectorODValue, float64LstCommon0);
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

      final od2 = new ODtag(PTag.kDoubleFloatPixelData, float64LstCommon0);
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
      final od0 = new ODtag(PTag.kSelectorODValue, float64LstCommon0.take(1));
      final od1 = new ODtag(PTag.kSelectorODValue, float64LstCommon0.take(1));
      log
        ..debug('floatList0:$float64LstCommon0, od0.hash_code:${od0
          .hashCode}')
        ..debug('floatList0:$float64LstCommon0, od1.hash_code:${od1.hashCode}');
      expect(od0.hashCode == od1.hashCode, true);
      expect(od0 == od1, true);
    });

    test('OD hashCode and == bad values', () {
      final od0 = new ODtag(PTag.kSelectorODValue, float64LstCommon0.take(1));

      final od1 =
          new ODtag(PTag.kDoubleFloatPixelData, float64LstCommon0.take(1));
      log.debug(
          'float64LstCommon0:$float64LstCommon0 , od1.hash_code:${od1.hashCode}');
      expect(od0.hashCode == od1.hashCode, false);
      expect(od0 == od1, false);
    });

    test('OD replace random', () {
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
      system.level = Level.info;
      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float64List(1, 1);
        final float = new Float64List.fromList(floatList0);
        final bytes = float.buffer.asUint8List();
        final od0 = ODtag.fromBytes(PTag.kSelectorODValue, bytes);
        log.debug('od0: $od0');
        expect(od0.hasValidValues, true);

        final floatList1 = rng.float64List(2, 2);
        final float0 = new Float64List.fromList(floatList1);
        final bytes0 = float0.buffer.asUint8List();
        final od1 = ODtag.fromBytes(PTag.kSelectorODValue, bytes0);
        log.debug('od1 ${od1.info}');
        expect(od1.hasValidValues, true);
      }
    });

    test('FDtag.fromBase64', () {
      system.throwOnError = false;
      final base640 = Float64Base.listToBase64(<double>[78678.11, 12345.678]);
      log.debug('b64: $base640');
      final od0 = FDtag.fromBase64(PTag.kSelectorFDValue, base640);
      log.debug('od0: $od0');
      expect(od0.hasValidValues, true);

      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float64List(1, 1);
        final float64List0 = new Float64List.fromList(floatList0);
        final base641 = Float64Base.listToBase64(float64List0);
        final od1 = FDtag.fromBase64(PTag.kSelectorFDValue, base641);
        expect(od1.hasValidValues, true);
      }
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

      test('OD isValidVR good values', () {
        system.throwOnError = false;
        expect(OD.isValidVRIndex(kODIndex), true);

        for (var s in odTags) {
          system.throwOnError = false;
          expect(OD.isValidVRIndex(s.vrIndex), true);
        }
      });

      test('OD isValidVR bad values', () {
        system.throwOnError = false;
        expect(OD.isValidVRIndex(kAEIndex), false);

        system.throwOnError = true;
        expect(() => OD.isValidVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var s in otherTags) {
          system.throwOnError = false;
          expect(OD.isValidVRIndex(s.vrIndex), false);

          system.throwOnError = true;
          expect(() => OD.isValidVRIndex(s.vrIndex),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('OD.isValidVFLength good values', () {
        system.throwOnError = false;
        expect(OD.isValidVFLength(OD.kMaxLength), true);
        expect(OD.isValidVFLength(0), true);
      });

      test('OD.isValidVFLength bad values', () {
        system.throwOnError = false;
        expect(OD.isValidVFLength(OD.kMaxVFLength + 1), false);
        expect(OD.isValidVFLength(-1), false);
      });

      test('OD.isValidVRIndex good values', () {
        system.throwOnError = false;
        expect(OD.isValidVRIndex(kODIndex), true);

        for (var tag in odTags) {
          system.throwOnError = false;
          expect(OD.isValidVRIndex(tag.vrIndex), true);
        }
      });

      test('OD.isValidVRIndex bad values', () {
        system.throwOnError = false;
        expect(OD.isValidVRIndex(kATIndex), false);

        system.throwOnError = true;
        expect(() => OD.isValidVRIndex(kATIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(OD.isValidVRIndex(tag.vrIndex), false);

          system.throwOnError = true;
          expect(() => OD.isValidVRIndex(tag.vrIndex),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('OD.isValidVRCode good values', () {
        system.throwOnError = false;
        expect(OD.isValidVRCode(kODCode), true);

        for (var tag in odTags) {
          system.throwOnError = false;
          expect(OD.isValidVRCode(tag.vrCode), true);
        }
      });

      test('OD.isValidVRCode bad values', () {
        system.throwOnError = false;
        expect(OD.isValidVRCode(kATCode), false);

        system.throwOnError = true;
        expect(() => OD.isValidVRCode(kATCode),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(OD.isValidVRCode(tag.vrCode), false);

          system.throwOnError = true;
          expect(() => OD.isValidVRCode(tag.vrCode),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('OD checkVR good values', () {
        system.throwOnError = false;
        expect(OD.checkVRIndex(kODIndex), kODIndex);

        for (var tag in odTags) {
          system.throwOnError = false;
          expect(OD.checkVRIndex(tag.vrIndex), tag.vrIndex);
        }
      });

      test('OD checkVR bad values', () {
        system.throwOnError = false;
        expect(
            OD.checkVRIndex(
              kAEIndex,
            ),
            isNull);
        system.throwOnError = true;
        expect(() => OD.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(OD.checkVRIndex(tag.vrIndex), isNull);

          system.throwOnError = true;
          expect(() => OD.checkVRIndex(kAEIndex),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('OD checkVRIndex good values', () {
        system.throwOnError = false;
        expect(OD.checkVRIndex(kODIndex), equals(kODIndex));

        for (var tag in odTags) {
          system.throwOnError = false;
          expect(OD.checkVRIndex(tag.vrIndex), equals(tag.vrIndex));
        }
      });

      test('OD checkVRIndex bad values', () {
        system.throwOnError = false;
        expect(OD.checkVRIndex(kATIndex), isNull);

        system.throwOnError = true;
        expect(() => OD.checkVRIndex(kATIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(OD.checkVRIndex(tag.vrIndex), isNull);

          system.throwOnError = true;
          expect(() => OD.checkVRIndex(tag.vrIndex),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('OD checkVRCode good values', () {
        system.throwOnError = false;
        expect(OD.checkVRCode(kODCode), equals(kODCode));

        for (var tag in odTags) {
          system.throwOnError = false;
          expect(OD.checkVRCode(tag.vrCode), equals(tag.vrCode));
        }
      });

      test('OD checkVRCode bad values', () {
        system.throwOnError = false;
        expect(OD.checkVRCode(kATCode), isNull);

        system.throwOnError = true;
        expect(() => OD.checkVRCode(kATCode),
            throwsA(const isInstanceOf<InvalidVRError>()));

        for (var tag in otherTags) {
          system.throwOnError = false;
          expect(OD.checkVRCode(tag.vrCode), isNull);

          system.throwOnError = true;
          expect(() => OD.checkVRCode(tag.vrCode),
              throwsA(const isInstanceOf<InvalidVRError>()));
        }
      });

      test('OD isValidVFLength good values', () {
        expect(OD.isValidVFLength(OD.kMaxVFLength), true);
        expect(OD.isValidVFLength(0), true);
      });

      test('OD isValidVFLength bad values', () {
        expect(OD.isValidVFLength(OD.kMaxVFLength + 1), false);
        expect(OD.isValidVFLength(-1), false);
      });

      test('OD.isValidValues', () {
        system.throwOnError = false;
        for (var i = 0; i <= float64LstCommon0.length - 1; i++) {
          expect(
              OD.isValidValues(
                  PTag.kSelectorODValue, <double>[float64LstCommon0[i]]),
              true);
        }
      });

      test('Flaot64Base.toFloat64List', () {
        expect(Float64Base.toFloat64List(float64LstCommon0), float64LstCommon0);

        for (var i = 0; i < 10; i++) {
          final floatList0 = rng.float64List(1, 1);
          expect(Float64Base.toFloat64List(floatList0), floatList0);
        }
      });

      test('Float64Base.fromBytes', () {
        for (var i = 0; i < 10; i++) {
          final floatList0 = rng.float64List(1, 1);
          final float = new Float64List.fromList(floatList0);
          final bd = float.buffer.asUint8List();
          expect(Float64Base.listFromBytes(bd), equals(floatList0));
        }
        final float0 = new Float64List.fromList(<double>[]);
        final bd0 = float0.buffer.asUint8List();
        expect(Float64Base.listFromBytes(bd0), equals(<double>[]));
      });

      test('Create Float64Base.listToBytes', () {
        for (var i = 0; i < 10; i++) {
          final floatList0 = rng.float64List(1, 1);
          final float64List0 = new Float64List.fromList(floatList0);
          final uInt8List0 = float64List0.buffer.asUint8List();
          //final base64 = BASE64.encode(uInt8List0);
          final base64 = Float64Base.listToBytes(float64List0);
          expect(base64, equals(uInt8List0));
        }
      });

      test('OD.decodeEncodeBinaryVF', () {
        for (var i = 0; i < 10; i++) {
          final floatList0 = rng.float64List(1, 1);
          final float64List0 = new Float64List.fromList(floatList0);
          expect(floatList0.lengthInBytes.isEven, true);
          final uInt8List0 = float64List0.buffer.asUint8List();
          final base64 = BASE64.encode(uInt8List0);
          final uInt8List1 = BASE64.decode(base64);
          final uInt8List2 = Float64Base.listToBytes(floatList0);
          expect(uInt8List0, equals(uInt8List1));
          expect(uInt8List0, equals(uInt8List1));
          expect(uInt8List0, equals(uInt8List2));

          final dList = Float64Base.listFromBytes(uInt8List2);
          expect(dList, equals(floatList0));
          expect(dList, equals(float64List0));
        }
      });

      test('OD.fromBase64', () {
        for (var i = 0; i < 10; i++) {
          final floatList0 = rng.float64List(0, i);
          final float64List0 = new Float64List.fromList(floatList0);
          final uInt8List0 = float64List0.buffer.asUint8List();
          final base64 = BASE64.encode(uInt8List0);
          expect(Float64Base.listFromBase64(base64), floatList0);
          expect(Float64Base.listFromBase64(base64), float64List0);
        }
      });

      test('OD.fromBytes', () {
        for (var i = 0; i < 10; i++) {
          final floatList0 = rng.float64List(0, i);
          final float64List0 = new Float64List.fromList(floatList0);
          expect(floatList0.lengthInBytes.isEven, true);
          final bd = float64List0.buffer.asUint8List();
          expect(Float64Base.listFromBytes(bd), equals(floatList0));
        }
        final float0 = new Float64List.fromList(<double>[]);
        final bd0 = float0.buffer.asUint8List();
        expect(Float64Base.listFromBytes(bd0), equals(<double>[]));
      });

      test('OD.fromByteData', () {
        for (var i = 0; i < 10; i++) {
          final floatList0 = rng.float64List(1, 1);
          final float = new Float64List.fromList(floatList0);
          final byteData0 = float.buffer.asByteData();
          expect(Float64Base.listFromByteData(byteData0), equals(floatList0));
        }
        final float0 = new Float64List.fromList(<double>[]);
        final bd0 = float0.buffer.asByteData();
        expect(Float64Base.listFromByteData(bd0), equals(<double>[]));
      });
    });
  });
}
