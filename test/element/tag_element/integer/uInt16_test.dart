// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/uInt16_test', level: Level.info);
  final rng = new RNG(1);

  const uInt16MinMax = const [kUint16Min, kUint16Max];
  const uInt16Min = const [kUint16Min];
  const uInt16Max = const [kUint16Max];
  const uInt16MaxPlus = const [kUint16Max + 1];
  const uInt16MinMinus = const [kUint16Min - 1];

  group('US', () {
    test('US hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(1, 1);
        final us0 = new UStag(PTag.kContrastFrameAveraging, uInt16List0);
        expect(us0.hasValidValues, true);
        log.debug('us0: ${us0.info}');
        expect(us0.hasValidValues, true);

        log
          ..debug('us0: $us0, values: ${us0.values}')
          ..debug('us0: ${us0.info}');
        expect(us0[0], equals(uInt16List0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(2, 2);
        final us0 =
            new UStag(PTag.kTopLeftHandCornerOfLocalizerArea, uInt16List0);
        expect(us0.hasValidValues, true);
        log.debug('us0: ${us0.info}');
        expect(us0.hasValidValues, true);

        log
          ..debug('us0: $us0, values: ${us0.values}')
          ..debug('us0: ${us0.info}');
        expect(us0[0], equals(uInt16List0[0]));
      }
    });

    test('US hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(2, 3);
        log.debug('$i: uInt16List0: $uInt16List0');
        final us0 = new UStag(PTag.kRepresentativeFrameNumber, uInt16List0);
        expect(us0, isNull);
      }
    });

    test('US hasValidValues good values', () {
      system.throwOnError = false;
      final us0 = new UStag(PTag.kRepresentativeFrameNumber, uInt16Min);
      final us1 = new UStag(PTag.kRepresentativeFrameNumber, uInt16Min);
      expect(us0.hasValidValues, true);
      expect(us1.hasValidValues, true);

      final us2 = new UStag(PTag.kRepresentativeFrameNumber, uInt16Max);
      final us3 = new UStag(PTag.kRepresentativeFrameNumber, uInt16Max);
      expect(us2.hasValidValues, true);
      expect(us3.hasValidValues, true);

      system.throwOnError = false;
      final us4 = new UStag(PTag.kRepresentativeFrameNumber, []);
      expect(us4.hasValidValues, true);
      log.debug('us4:${us4.info}');
      expect(us4.values, equals(<int>[]));
    });

    test('US hasValidValues bad values', () {
      final us0 = new UStag(PTag.kRepresentativeFrameNumber, uInt16MaxPlus);
      expect(us0, isNull);

      final us1 = new UStag(PTag.kRepresentativeFrameNumber, uInt16MinMinus);
      expect(us1, isNull);

      final us2 = new UStag(PTag.kRepresentativeFrameNumber, uInt16MinMax);
      expect(us2, isNull);

      system.throwOnError = false;
      final us3 = new UStag(PTag.kRepresentativeFrameNumber, uInt16Max);
      final uInt32List0 = rng.uint32List(1, 1);
      us3.values = uInt32List0;
      expect(us3.hasValidValues, false);

      system.throwOnError = true;
      expect(() => us3.hasValidValues,
          throwsA(const isInstanceOf<InvalidValuesError>()));

      system.throwOnError = false;
      final us4 = new UStag(PTag.kRepresentativeFrameNumber, null);
      log.debug('us4: $us4');
      expect(us4, isNull);

      system.throwOnError = true;
      expect(() => new UStag(PTag.kRepresentativeFrameNumber, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('US update random', () {
      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(3, 4);
        final us1 = new UStag(PTag.kAcquisitionIndex, uInt16List0);
        final uInt16List1 = rng.uint16List(3, 4);
        expect(us1.update(uInt16List1).values, equals(uInt16List1));
      }
    });

    test('US update', () {
      final us0 = new UStag(PTag.kSelectorUSValue, []);
      expect(us0.update([63457, 64357]).values, equals([63457, 64357]));

      final us1 = new UStag(PTag.kFrameNumbersOfInterest, uInt16Min);
      final us2 = new UStag(PTag.kFrameNumbersOfInterest, uInt16Min);
      final us3 = us1.update(uInt16Max);
      final us4 = us2.update(uInt16Max);
      expect(us1.values.first == us4.values.first, false);
      expect(us1 == us4, false);
      expect(us1 == us4, false);
      expect(us3 == us4, true);
    });

    test('US noValues random', () {
      for (var i = 0; i < 10; i++) {
        final uInt16List = rng.uint16List(3, 4);
        final us1 = new UStag(PTag.kFrameNumbersOfInterest, uInt16List);
        log.debug('us1: ${us1.noValues}');
        expect(us1.noValues.values.isEmpty, true);
      }
    });

    test('US noValues', () {
      final us0 = new UStag(PTag.kFrameNumbersOfInterest, []);
      final UStag usNoValues = us0.noValues;
      expect(usNoValues.values.isEmpty, true);
      log.debug('us0: ${us0.noValues}');

      final us1 = new UStag(PTag.kRepresentativeFrameNumber, uInt16Min);
      final usNoValues0 = us1.noValues;
      expect(usNoValues0.values.isEmpty, true);
      log.debug('us1:${us1.noValues}');
    });

    test('US copy random', () {
      for (var i = 0; i < 10; i++) {
        final uInt16List = rng.uint16List(3, 4);
        final us2 = new UStag(PTag.kSelectorUSValue, uInt16List);
        final UStag us3 = us2.copy;
        expect(us3 == us2, true);
        expect(us3.hashCode == us2.hashCode, true);
      }
    });

    test('US copy', () {
      final us0 = new UStag(PTag.kRepresentativeFrameNumber, []);
      final UStag us1 = us0.copy;
      expect(us1 == us0, true);
      expect(us1.hashCode == us0.hashCode, true);

      final us2 = new UStag(PTag.kRepresentativeFrameNumber, uInt16Max);
      final us3 = us2.copy;
      expect(us2 == us3, true);
      expect(us2.hashCode == us3.hashCode, true);
    });

    test('US hashCode and == good values random', () {
      system.throwOnError = false;
      final rng = new RNG(1);
      List<int> uInt16List0;

      for (var i = 0; i < 10; i++) {
        uInt16List0 = rng.uint16List(1, 1);
        final us0 = new UStag(PTag.kLargestMonochromePixelValue, uInt16List0);
        final us1 = new UStag(PTag.kLargestMonochromePixelValue, uInt16List0);
        log
          ..debug('uInt16List0:$uInt16List0, us0.hash_code:${us0.hashCode}')
          ..debug('uInt16List0:$uInt16List0, us1.hash_code:${us1.hashCode}');
        expect(us0.hashCode == us1.hashCode, true);
        expect(us0 == us1, true);
      }
    });
    test('US hashCode and == bad values random', () {
      system.throwOnError = false;
      List<int> uInt16List0;
      List<int> uInt16List1;
      List<int> uInt16List2;
      List<int> uInt16List3;
      List<int> uInt16List4;
      List<int> uInt16List5;

      for (var i = 0; i < 10; i++) {
        uInt16List0 = rng.uint16List(1, 1);
        uInt16List1 = rng.uint16List(1, 1);
        final us0 = new UStag(PTag.kLargestMonochromePixelValue, uInt16List0);

        final us2 = new UStag(PTag.kRepresentativeFrameNumber, uInt16List1);
        log.debug('uInt16List1:$uInt16List1 , us2.hash_code:${us2.hashCode}');
        expect(us0.hashCode == us2.hashCode, false);
        expect(us0 == us2, false);

        uInt16List2 = rng.uint16List(2, 2);
        final us3 =
            new UStag(PTag.kTopLeftHandCornerOfLocalizerArea, uInt16List2);
        log.debug('uInt16List2:$uInt16List2 , us3.hash_code:${us3.hashCode}');
        expect(us0.hashCode == us3.hashCode, false);
        expect(us0 == us3, false);

        uInt16List3 = rng.uint16List(3, 3);
        final us4 = new UStag(PTag.kRecommendedDisplayCIELabValue, uInt16List3);
        log.debug('uInt16List2:$uInt16List2 , us4.hash_code:${us4.hashCode}');
        expect(us0.hashCode == us4.hashCode, false);
        expect(us0 == us4, false);

        uInt16List4 = rng.uint16List(4, 4);
        final us5 = new UStag(PTag.kAcquisitionMatrix, uInt16List4);
        log.debug('uInt1uInt16List46List2:$uInt16List4 , us5.hash_code:${us5
                .hashCode}');
        expect(us0.hashCode == us5.hashCode, false);
        expect(us0 == us5, false);

        uInt16List5 = rng.uint16List(2, 3);
        final us6 = new UStag(PTag.kRepresentativeFrameNumber, uInt16List5);
        log.debug('uInt16List5:$uInt16List5 , us6.hash_code:${us6.hashCode}');
        expect(us0.hashCode == us6.hashCode, false);
        expect(us0 == us6, false);
      }
    });

    test('US hashCode and == good values', () {
      final us0 = new UStag(PTag.kRepresentativeFrameNumber, uInt16Min);
      final us1 = new UStag(PTag.kRepresentativeFrameNumber, uInt16Min);

      log
        ..debug('uInt16Min:$uInt16Min, us0.hash_code:${us0.hashCode}')
        ..debug('uInt16Min:$uInt16Min, us1.hash_code:${us1.hashCode}');
      expect(us0.hashCode == us1.hashCode, true);
      expect(us0 == us1, true);
    });

    test('US hashCode and == bad values', () {
      final us0 = new UStag(PTag.kRepresentativeFrameNumber, uInt16Min);
      final us2 = new UStag(PTag.kRepresentativeFrameNumber, uInt16Max);
      log.debug('uInt16Max:$uInt16Max , ob2.hash_code:${us2.hashCode}');
      expect(us0.hashCode == us2.hashCode, false);
      expect(us0 == us2, false);
    });

    test('US fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(1, 1);
        final uInt16ListV1 = new Uint16List.fromList(uInt16List0);
        final uInt8ListV11 = uInt16ListV1.buffer.asUint8List();
        final us0 =
            new UStag.fromBytes(PTag.kRepresentativeFrameNumber, uInt8ListV11);
        expect(us0.hasValidValues, true);
        expect(us0.vfBytes, equals(uInt8ListV11));
        expect(us0.values is Uint16List, true);
        expect(us0.values, equals(uInt16ListV1));

        // Test Base64
        final base64 = BASE64.encode(uInt8ListV11);
        final us1 =
            new UStag.fromBase64(PTag.kRepresentativeFrameNumber, base64);
        expect(us0 == us1, true);
        expect(us1.value, equals(us0.value));

        final uInt16List1 = rng.uint16List(2, 2);
        final uInt16ListV2 = new Uint16List.fromList(uInt16List1);
        final uInt8ListV12 = uInt16ListV2.buffer.asUint8List();
        final us2 =
            new UStag.fromBytes(PTag.kRepresentativeFrameNumber, uInt8ListV12);
        expect(us2.hasValidValues, false);
      }
    });

    test('US fromBytes', () {
      final uInt16ListV1 = new Uint16List.fromList(uInt16Min);
      final uInt8ListV11 = uInt16ListV1.buffer.asUint8List();
      final us5 =
          new UStag.fromBytes(PTag.kRepresentativeFrameNumber, uInt8ListV11);
      expect(us5.hasValidValues, true);
      expect(us5.vfBytes, equals(uInt8ListV11));
      expect(us5.values is Uint16List, true);
      expect(us5.values, equals(uInt16ListV1));
    });

    test('US checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(1, 1);
        final us0 = new UStag(PTag.kRepresentativeFrameNumber, uInt16List0);
        expect(us0.checkLength(us0.values), true);
      }
    });

    test('US checkLength', () {
      final us0 = new UStag(PTag.kRepresentativeFrameNumber, uInt16Max);
      expect(us0.checkLength(us0.values), true);
    });

    test('US checkValues random', () {
      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(1, 1);
        final us0 = new UStag(PTag.kRepresentativeFrameNumber, uInt16List0);
        expect(us0.checkValues(us0.values), true);
      }
    });

    test('US checkValues ', () {
      final us0 = new UStag(PTag.kRepresentativeFrameNumber, uInt16Max);
      expect(us0.checkValues(us0.values), true);
    });

    test('US valuesCopy random', () {
      //valuesCopy
      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(1, 1);
        final us0 = new UStag(PTag.kRepresentativeFrameNumber, uInt16List0);
        expect(uInt16List0, equals(us0.valuesCopy));
      }
    });

    test('US valuesCopy', () {
      final us0 = new UStag(PTag.kRepresentativeFrameNumber, uInt16Min);
      expect(uInt16Min, equals(us0.valuesCopy));
    });

    test('US replace random', () {
      final uInt16List0 = rng.uint16List(1, 1);
      final us0 = new UStag(PTag.kRepresentativeFrameNumber, uInt16List0);
      final uInt16List1 = rng.uint16List(1, 1);
      expect(us0.replace(uInt16List1), equals(uInt16List0));
    });

    test('US BASE64 random', () {
      for (var i = 0; i < 10; i++) {
        final uInt16list0 = rng.uint16List(1, 1);
        final uInt16ListV1 = new Uint16List.fromList(uInt16list0);
        final uInt16ListV11 = uInt16ListV1.buffer.asUint8List();
        final base64 = BASE64.encode(uInt16ListV11);
        final us0 =
            new UStag.fromBase64(PTag.kRepresentativeFrameNumber, base64);
        expect(us0.hasValidValues, true);
      }
    });

    test('US BASE64', () {
      final uInt16ListV1 = new Uint16List.fromList(uInt16Min);
      final uInt16ListV11 = uInt16ListV1.buffer.asUint8List();
      final base64 = BASE64.encode(uInt16ListV11);
      final us0 = new UStag.fromBase64(PTag.kRepresentativeFrameNumber, base64);
      expect(us0.hasValidValues, true);
    });

    test('US make', () {
      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(1, 1);
        final us0 = UStag.make(PTag.kRepresentativeFrameNumber, uInt16List0);
        expect(us0.hasValidValues, true);
      }
    });

    test('US fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(1, 1);
        final uInt16ListV1 = new Uint16List.fromList(uInt16List0);
        final uInt8ListV1 = uInt16ListV1.buffer.asUint8List();
        final us0 =
            new UStag.fromBytes(PTag.kRepresentativeFrameNumber, uInt8ListV1);
        expect(us0.hasValidValues, true);
        expect(us0.vfBytes, equals(uInt8ListV1));
        expect(us0.values is Uint16List, true);
        expect(us0.values, equals(uInt16ListV1));
      }
    });

    test('US fromB64', () {
      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(1, 1);
        final uInt16ListV1 = new Uint16List.fromList(uInt16List0);
        final uInt8ListV11 = uInt16ListV1.buffer.asUint8List();
        final base64 = BASE64.encode(uInt8ListV11);
        final us0 = UStag.fromB64(PTag.kRepresentativeFrameNumber, base64);
        expect(us0.hasValidValues, true);
      }
    });

    test('US checkValue good values', () {
      final uInt16List0 = rng.uint16List(1, 1);
      final us0 = new UStag(PTag.kRepresentativeFrameNumber, uInt16List0);

      expect(us0.checkValue(uInt16Max[0]), true);
      expect(us0.checkValue(uInt16Min[0]), true);
    });

    test('US checkValue bad values', () {
      final uInt16List0 = rng.uint16List(1, 1);
      final us0 = new UStag(PTag.kRepresentativeFrameNumber, uInt16List0);

      expect(us0.checkValue(uInt16MaxPlus[0]), false);
      expect(us0.checkValue(uInt16MinMinus[0]), false);
    });

    test('US view', () {
      final uInt16List0 = rng.uint16List(10, 10);
      final us0 = new UStag(PTag.kSelectorUSValue, uInt16List0);
      for (var i = 0, j = 0; i < uInt16List0.length; i++, j += 2) {
        final us1 = us0.view(j, uInt16List0.length - i);
        log.debug(
            'us0: ${us0.values}, us1: ${us1.values}, uInt16List0.sublist(i) : ${uInt16List0.sublist(i)}');
        expect(us1.values, equals(uInt16List0.sublist(i)));
      }
    });
  });

  group('US Element', () {
    //VM.k1
    const usTags0 = const <PTag>[
      PTag.kFileSetConsistencyFlag,
      PTag.kRecordInUseFlag,
      PTag.kDataSetType,
      PTag.kPrivateGroupReference,
      PTag.kWarningReason,
      PTag.kFailureReason,
      PTag.kPregnancyStatus,
      PTag.kNumberOfElements,
      PTag.kPreferredPlaybackSequencing,
      PTag.kContrastBolusAgentNumber,
      PTag.kReconstructionIndex,
      PTag.kLightPathFilterPassThroughWavelength,
      PTag.kStimuliRetestingQuantity,
      PTag.kImageDimensions,
      PTag.kPlanarConfiguration,
      PTag.kRows,
      PTag.kColumns,
      PTag.kPlanes,
      PTag.kBitsGrouped,
    ];

    //VM.k2
    const usTags1 = const <PTag>[
      PTag.kSynchronizationChannel,
      PTag.kLightPathFilterPassBand,
      PTag.kImagePathFilterPassBand,
      PTag.kTopLeftHandCornerOfLocalizerArea,
      PTag.kBottomRightHandCornerOfLocalizerArea,
      PTag.kDisplayedAreaTopLeftHandCornerTrial,
      PTag.kDisplayedAreaBottomRightHandCornerTrial,
      PTag.kRelativeTime
    ];

    //VM.k3
    const usTags2 = const <PTag>[
      PTag.kSubjectRelativePositionInImage,
      PTag.kShutterPresentationColorCIELabValue,
      PTag.kAlphaPaletteColorLookupTableDescriptor,
      PTag.kBlendingLookupTableDescriptor,
      PTag.kWaveformDisplayBackgroundCIELabValue,
      PTag.kChannelRecommendedDisplayCIELabValue,
      PTag.kRecommendedAbsentPixelCIELabValue,
      PTag.kRecommendedDisplayCIELabValue,
      PTag.kGraphicLayerRecommendedDisplayRGBValue,
      PTag.kTextColorCIELabValue,
      PTag.kShadowColorCIELabValue,
      PTag.kPatternOnColorCIELabValue,
      PTag.kPatternOffColorCIELabValue,
      PTag.kGraphicLayerRecommendedDisplayCIELabValue,
      PTag.kEmptyImageBoxCIELabValue,
      PTag.kEscapeTriplet,
      PTag.kRunLengthTriplet
    ];

    //VM.k4
    const usTags3 = const <PTag>[PTag.kAcquisitionMatrix];

    //VM.k1_n
    const usTag4 = const <PTag>[
      PTag.kAcquisitionIndex,
      PTag.kPerimeterTable,
      PTag.kPredictorConstants,
      PTag.kFrameNumbersOfInterest,
      PTag.kMaskPointers,
      PTag.kRWavePointer,
      PTag.kMaskFrameNumbers,
      PTag.kReferencedFrameNumbers,
      PTag.kDetectorVector,
      PTag.kPhaseVector,
      PTag.kRotationVector,
      PTag.kRRIntervalVector,
      PTag.kTimeSlotVector,
      PTag.kSliceVector,
      PTag.kAngularViewVector,
      PTag.kSelectorUSValue
    ];

    const otherTags = const <PTag>[
      PTag.kColumnAngulationPatient,
      PTag.kAcquisitionProtocolName,
      PTag.kCTDIvol,
      PTag.kCTPositionSequence,
      PTag.kAcquisitionType,
      PTag.kPerformedStationAETitle,
      PTag.kSelectorSTValue,
      PTag.kDate,
      PTag.kTime
    ];

    final invalidVList = rng.uint16List(US.kMaxLength + 1, US.kMaxLength + 1);

    test('US isValidVListLength VM.k1 good values', () {
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final validMinVList = rng.uint16List(1, 1);
        for (var tag in usTags0) {
          expect(US.isValidVListLength(tag, validMinVList), true);
          expect(
              US.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              US.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('US isValidVListLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rng.uint16List(2, i + 1);
        for (var tag in usTags0) {
          system.throwOnError = false;
          expect(US.isValidVListLength(tag, validMinVList), false);
          expect(US.isValidVListLength(tag, invalidVList), false);

          system.throwOnError = true;
          expect(() => US.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesLengthError>()));
          expect(() => US.isValidVListLength(tag, invalidVList),
              throwsA(const isInstanceOf<InvalidValuesLengthError>()));
        }
      }
    });

    test('US isValidVListLength VM.k2 good values', () {
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final validMinVList = rng.uint16List(2, 2);
        for (var tag in usTags1) {
          expect(US.isValidVListLength(tag, validMinVList), true);

          expect(
              US.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              US.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('US isValidVListLength VM.k2 bad values', () {
      for (var i = 2; i < 10; i++) {
        final validMinVList = rng.uint16List(3, i + 1);
        for (var tag in usTags1) {
          system.throwOnError = false;
          expect(US.isValidVListLength(tag, validMinVList), false);
          expect(US.isValidVListLength(tag, invalidVList), false);

          system.throwOnError = true;
          expect(() => US.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesLengthError>()));
          expect(() => US.isValidVListLength(tag, invalidVList),
              throwsA(const isInstanceOf<InvalidValuesLengthError>()));
        }
      }
    });

    test('US isValidVListLength VM.k3 good values', () {
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final validMinVList = rng.uint16List(3, 3);
        for (var tag in usTags2) {
          expect(US.isValidVListLength(tag, validMinVList), true);

          expect(
              US.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              US.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('US isValidVListLength VM.k3 bad values', () {
      for (var i = 3; i < 10; i++) {
        final validMinVList = rng.uint16List(4, i + 1);
        for (var tag in usTags2) {
          system.throwOnError = false;
          expect(US.isValidVListLength(tag, validMinVList), false);
          expect(US.isValidVListLength(tag, invalidVList), false);

          system.throwOnError = true;
          expect(() => US.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesLengthError>()));
          expect(() => US.isValidVListLength(tag, invalidVList),
              throwsA(const isInstanceOf<InvalidValuesLengthError>()));
        }
      }
    });

    test('US isValidVListLength VM.k4 good values', () {
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final validMinVList = rng.uint16List(4, 4);
        for (var tag in usTags3) {
          expect(US.isValidVListLength(tag, validMinVList), true);

          expect(
              US.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              US.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('US isValidVListLength VM.k4 bad values', () {
      for (var i = 4; i < 10; i++) {
        final validMinVList = rng.uint16List(5, i + 1);
        for (var tag in usTags3) {
          system.throwOnError = false;
          expect(US.isValidVListLength(tag, validMinVList), false);
          expect(US.isValidVListLength(tag, invalidVList), false);

          system.throwOnError = true;
          expect(() => US.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesLengthError>()));
          expect(() => US.isValidVListLength(tag, invalidVList),
              throwsA(const isInstanceOf<InvalidValuesLengthError>()));
        }
      }
    });

    test('US isValidVListLength VM.k1_n good values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rng.uint16List(1, i);
        for (var tag in usTag4) {
          expect(US.isValidVListLength(tag, validMinVList), true);

          expect(
              US.isValidVListLength(
                  tag, invalidVList.sublist(0, US.kMaxLength)),
              true);

          expect(
              US.isValidVListLength(
                  tag, invalidVList.sublist(0, US.kMaxLength)),
              true);
        }
      }
    });

    test('US isValidVR good values', () {
      system.throwOnError = false;
      expect(US.isValidVRIndex(kUSIndex), true);

      for (var tag in usTags0) {
        system.throwOnError = false;
        expect(US.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('US isValidVR bad values', () {
      system.throwOnError = false;
      expect(US.isValidVRIndex(kAEIndex), false);
      system.throwOnError = true;
      expect(() => SL.isValidVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(US.isValidVRIndex(tag.vrIndex), false);

        system.throwOnError = true;
        expect(() => US.isValidVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('US checkVR VM.k1 good values', () {
      system.throwOnError = false;
      expect(US.checkVRIndex(kUSIndex), kUSIndex);

      for (var tag in usTags0) {
        system.throwOnError = false;
        expect(US.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('US checkVR VM.k1_n good values', () {
      for (var tag in usTags0) {
        system.throwOnError = false;
        expect(US.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('US checkVR bad values', () {
      system.throwOnError = false;
      expect(US.checkVRIndex(kAEIndex), isNull);
      system.throwOnError = true;
      expect(() => US.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(US.checkVRIndex(tag.vrIndex), isNull);

        system.throwOnError = true;
        expect(() => US.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('US isValidVRIndex VM.k1 good values', () {
      system.throwOnError = false;
      expect(US.isValidVRIndex(kUSIndex), true);

      for (var tag in usTags0) {
        system.throwOnError = false;
        expect(US.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('US isValidVRIndex VM.k1_n good values', () {
      for (var tag in usTags0) {
        system.throwOnError = false;
        expect(US.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('US isValidVRIndex bad values', () {
      system.throwOnError = false;
      expect(US.isValidVRIndex(kCSIndex), false);

      system.throwOnError = true;
      expect(() => US.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(US.isValidVRIndex(tag.vrIndex), false);

        system.throwOnError = true;
        expect(() => US.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('US isValidVRCode VM.k1 good values', () {
      system.throwOnError = false;
      expect(US.isValidVRCode(kUSCode), true);
      for (var tag in usTags0) {
        expect(US.isValidVRCode(tag.vrCode), true);
      }
    });

    test('US isValidVRCode VM.k1_n good values', () {
      system.throwOnError = false;
      for (var tag in usTags0) {
        expect(US.isValidVRCode(tag.vrCode), true);
      }
    });

    test('US isValidVRCode bad values', () {
      system.throwOnError = false;
      expect(US.isValidVRCode(kAECode), false);

      system.throwOnError = true;
      expect(() => US.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(US.isValidVRCode(tag.vrCode), false);

        system.throwOnError = true;
        expect(() => US.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('US isValidVFLength good values', () {
      expect(US.isValidVFLength(US.kMaxVFLength), true);
      expect(US.isValidVFLength(0), true);
    });

    test('US isValidVFLength bad values', () {
      expect(US.isValidVFLength(US.kMaxVFLength + 1), false);
      expect(US.isValidVFLength(-1), false);
    });

    test('US isValidValue good values', () {
      expect(US.isValidValue(US.kMinValue), true);
      expect(US.isValidValue(US.kMaxValue), true);
    });

    test('US isValidValue bad values', () {
      expect(US.isValidValue(US.kMinValue - 1), false);
      expect(US.isValidValue(US.kMaxValue + 1), false);
    });

    test('US isValidValues good values', () {
      system.throwOnError = false;
      const uInt16MinMax = const [kUint16Min, kUint16Max];
      const uInt16MinMaxPlus0 = const [kUint16Min, kUint16Max, kUint8Min];
      const uInt16MinMaxPlus1 = const [
        kUint16Min,
        kUint16Max,
        kUint8Min,
        kUint8Max
      ];
      const uInt16Min = const [kUint16Min];
      const uInt16Max = const [kUint16Max];

      //VM.k1
      expect(US.isValidValues(PTag.kWarningReason, uInt16Min), true);
      expect(US.isValidValues(PTag.kWarningReason, uInt16Max), true);

      //VM.k2
      expect(
          US.isValidValues(PTag.kLightPathFilterPassBand, uInt16MinMax), true);

      //VM.k3
      expect(US.isValidValues(PTag.kTextColorCIELabValue, uInt16MinMaxPlus0),
          true);

      //VM.k4
      expect(
          US.isValidValues(PTag.kAcquisitionMatrix, uInt16MinMaxPlus1), true);

      //VM.k1_n
      expect(US.isValidValues(PTag.kSelectorUSValue, uInt16Min), true);
      expect(US.isValidValues(PTag.kSelectorUSValue, uInt16Max), true);
      expect(US.isValidValues(PTag.kSelectorUSValue, uInt16MinMax), true);
      expect(US.isValidValues(PTag.kSelectorUSValue, uInt16MinMaxPlus0), true);
    });

    test('US isValidValues bad values', () {
      system.throwOnError = false;
      const uInt16MaxPlus = const [kUint16Max + 1];
      const uInt16MinMinus = const [kUint16Min - 1];

      //VM.k1
      expect(US.isValidValues(PTag.kWarningReason, uInt16MaxPlus), false);
      expect(US.isValidValues(PTag.kWarningReason, uInt16MinMinus), false);

      //VM.k2
      expect(US.isValidValues(PTag.kLightPathFilterPassBand, uInt16MaxPlus),
          false);

      //VM.k3
      expect(
          US.isValidValues(PTag.kTextColorCIELabValue, uInt16MaxPlus), false);

      //VM.k4
      expect(US.isValidValues(PTag.kAcquisitionMatrix, uInt16MinMinus), false);

      system.throwOnError = true;
      expect(() => US.isValidValues(PTag.kWarningReason, uInt16MaxPlus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
      expect(() => US.isValidValues(PTag.kWarningReason, uInt16MinMinus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('US isValidValues bad values length', () {
      system.throwOnError = false;

      const uInt16MinMax = const [kUint16Min, kUint16Max];
      const uInt16MinMaxPlus0 = const [kUint16Min, kUint16Max, kUint8Min];
      const uInt16MinMaxPlus1 = const [
        kUint16Min,
        kUint16Max,
        kUint8Min,
        kUint8Max
      ];
      const uInt16Min = const [kUint16Min];
      const uInt16Max = const [kUint16Max];

      //VM.k1
      expect(US.isValidValues(PTag.kWarningReason, uInt16MinMax), false);

      //VM.k2

      expect(US.isValidValues(PTag.kLightPathFilterPassBand, uInt16Min), false);
      expect(US.isValidValues(PTag.kLightPathFilterPassBand, uInt16Max), false);
      expect(US.isValidValues(PTag.kLightPathFilterPassBand, uInt16MinMaxPlus0),
          false);

      //VM.k3
      expect(US.isValidValues(PTag.kTextColorCIELabValue, uInt16Min), false);
      expect(US.isValidValues(PTag.kTextColorCIELabValue, uInt16Max), false);
      expect(US.isValidValues(PTag.kTextColorCIELabValue, uInt16MinMaxPlus1),
          false);

      //VM.k4
      expect(US.isValidValues(PTag.kAcquisitionMatrix, uInt16Min), false);
      expect(US.isValidValues(PTag.kAcquisitionMatrix, uInt16Max), false);
      expect(
          US.isValidValues(PTag.kAcquisitionMatrix, uInt16MinMaxPlus0), false);

      system.throwOnError = true;
      expect(() => US.isValidValues(PTag.kWarningReason, uInt16MinMax),
          throwsA(const isInstanceOf<InvalidValuesLengthError>()));
      expect(() => US.isValidValues(PTag.kLightPathFilterPassBand, uInt16Min),
          throwsA(const isInstanceOf<InvalidValuesLengthError>()));
      expect(() => US.isValidValues(PTag.kTextColorCIELabValue, uInt16Min),
          throwsA(const isInstanceOf<InvalidValuesLengthError>()));
      expect(() => US.isValidValues(PTag.kAcquisitionMatrix, uInt16Max),
          throwsA(const isInstanceOf<InvalidValuesLengthError>()));
    });

    test('US toUint16List', () {
      for (var i = 0; i < 10; i++) {
        final uInt16list0 = rng.uint16List(1, 1);
        expect(Uint16Base.toUint16List(uInt16list0), uInt16list0);
      }
      const uInt16Min = const [kUint16Min];
      const uInt16Max = const [kUint16Max];
      expect(Uint16Base.toUint16List(uInt16Min), uInt16Min);
      expect(Uint16Base.toUint16List(uInt16Max), uInt16Max);
    });

    test('US fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uInt16list0 = rng.uint16List(1, 1);
        final uInt16ListV1 = new Uint16List.fromList(uInt16list0);
        final bd = uInt16ListV1.buffer.asUint8List();
        log
          ..debug('uInt16ListV1 : $uInt16ListV1')
          ..debug(
              'Uint16Base.listFromBytes(bd) ; ${Uint16Base.listFromBytes(bd)}');
        expect(Uint16Base.listFromBytes(bd), equals(uInt16ListV1));
      }
    });

    test('US toBytes', () {
      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final uInt16list0 = rng.uint16List(1, 1);
        final uInt16ListV1 = new Uint16List.fromList(uInt16list0);
        final bd = uInt16ListV1.buffer.asUint8List();
        log
          ..debug('uInt16ListV1 : $uInt16ListV1')
          ..debug(
              'Uint16Base.listToBytes(uInt16ListV1) ; ${Uint16Base.listToBytes(uInt16ListV1)}');
        expect(Uint16Base.listToBytes(uInt16ListV1), equals(bd));
      }

      const uInt16Max = const [kUint16Max];
      final uInt16ListV1 = new Uint16List.fromList(uInt16Max);
      final uInt16List = uInt16ListV1.buffer.asUint8List();
      expect(Uint16Base.listToBytes(uInt16Max), uInt16List);

      const uInt32Max = const [kUint32Max];
      expect(Uint16Base.listToBytes(uInt32Max), isNull);

      system.throwOnError = true;
      expect(() => Uint16Base.listToBytes(uInt32Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('US fromBase64', () {
      for (var i = 0; i < 10; i++) {
        final uInt16list0 = rng.uint16List(1, 1);
        final uInt16ListV1 = new Uint16List.fromList(uInt16list0);
        final bd = uInt16ListV1.buffer.asUint8List();
        final base64 = BASE64.encode(bd);
        log.debug('US.base64: "$base64"');

        final usList = Uint16Base.listFromBase64(base64);
        log.debug('  US.decode: $usList');
        expect(usList, equals(uInt16list0));
        expect(usList, equals(uInt16ListV1));
      }
    });

    test('US toBase64', () {
      for (var i = 0; i < 10; i++) {
        final uInt16list0 = rng.uint16List(1, 1);
        final uInt16ListV1 = new Uint16List.fromList(uInt16list0);
        final bd = uInt16ListV1.buffer.asUint8List();
        final s = BASE64.encode(bd);
        expect(Uint16Base.listToBase64(uInt16list0), equals(s));
      }
    });

    test('US encodeDecodeJsonVF', () {
      system.level = Level.info;
      for (var i = 1; i < 10; i++) {
        final uInt16list0 = rng.uint16List(0, i);
        final uInt16ListV1 = new Uint16List.fromList(uInt16list0);
        final bd = uInt16ListV1.buffer.asUint8List();

        // Encode
        final base64 = BASE64.encode(bd);
        log.debug('US.base64: "$base64"');
        final s = Uint16Base.listToBase64(uInt16list0);
        log.debug('  US.json: "$s"');
        expect(s, equals(base64));

        // Decode
        final us0 = Uint16Base.listFromBase64(base64);
        log.debug('US.base64: $us0');
        final us1 = Uint16Base.listFromBase64(s);
        log.debug('  US.json: $us1');
        expect(us0, equals(uInt16list0));
        expect(us0, equals(uInt16ListV1));
        expect(us0, equals(us1));
      }
    });

    test('US fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uInt16list0 = rng.uint16List(1, 1);
        final uInt16ListV1 = new Uint16List.fromList(uInt16list0);
        final bd = uInt16ListV1.buffer.asUint8List();
        log
          ..debug('uInt16ListV1 : $uInt16ListV1')
          ..debug(
              'Uint16Base.listFromBytes(bd) ; ${Uint16Base.listFromBytes(bd)}');
        expect(Uint16Base.listFromBytes(bd), equals(uInt16ListV1));
      }
    });

    test('US fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final uInt16list0 = rng.uint16List(1, 1);
        final uInt16ListV1 = new Uint16List.fromList(uInt16list0);
        final byteData = uInt16ListV1.buffer.asByteData();
        log
          ..debug('uInt16ListV1 : $uInt16ListV1')
          ..debug(
              'Uint16Base.listFromByteData(byteData) ; ${Uint16Base.listFromByteData(byteData)}');
        expect(Uint16Base.listFromByteData(byteData), equals(uInt16ListV1));
      }
    });
  });

  group('OWTag', () {
    test('OW hasValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(1, 1);
        final ow0 =
            new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16List0);
        expect(ow0.hasValidValues, true);
        log.debug('ow0: ${ow0.info}');
        expect(ow0.hasValidValues, true);

        log
          ..debug('ow0: $ow0, values: ${ow0.values}')
          ..debug('ow0: ${ow0.info}');
        expect(ow0[0], equals(uInt16List0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(2, 3);
        log.debug('$i: uInt16List0: $uInt16List0');
        final ow0 =
            new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16List0);
        expect(ow0.hasValidValues, true);
      }
    });

    test('OW hasValidValues good values', () {
      system.throwOnError = false;
      final ow0 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16Min);
      final ow1 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16Min);
      expect(ow0.hasValidValues, true);
      expect(ow1.hasValidValues, true);

      final ow2 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16Max);
      final ow3 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16Max);
      expect(ow2.hasValidValues, true);
      expect(ow3.hasValidValues, true);

      system.throwOnError = false;
      final ow4 = new OWtag(PTag.kRedPaletteColorLookupTableData, []);
      expect(ow4.hasValidValues, true);
      log.debug('ow4:${ow4.info}');
      expect(ow4.values, equals(<int>[]));
    });

    test('OW hasValidValues bad values', () {
      final ow0 =
          new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16MaxPlus);
      expect(ow0, isNull);

      final ow1 =
          new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16MinMinus);
      expect(ow1, isNull);

      final ow2 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16MinMax);
      expect(ow2.hasValidValues, true);

      system.throwOnError = false;
      final ow3 = new OWtag(PTag.kRedPaletteColorLookupTableData, null);
      log.debug('ow3: $ow3');
      expect(ow3, isNull);

      system.throwOnError = true;
      expect(() => new OWtag(PTag.kRedPaletteColorLookupTableData, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('OW update random', () {
      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(3, 4);
        final ow1 =
            new OWtag(PTag.kGreenPaletteColorLookupTableData, uInt16List0);
        final uInt16List1 = rng.uint16List(3, 4);
        expect(ow1.update(uInt16List1).values, equals(uInt16List1));
      }
    });

    test('OW update', () {
      final ow0 = new OWtag(PTag.kGreenPaletteColorLookupTableData, []);
      expect(ow0.update([63457, 64357]).values, equals([63457, 64357]));

      final ow1 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16Min);
      final ow2 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16Min);
      final ow3 = ow1.update(uInt16Max);
      final ow4 = ow2.update(uInt16Max);
      expect(ow1.values.first == ow4.values.first, false);
      expect(ow1 == ow4, false);
      expect(ow2 == ow4, false);
      expect(ow3 == ow4, true);
    });

    test('OW noValues random', () {
      final ow0 = new OWtag(PTag.kRedPaletteColorLookupTableData, []);
      final OWtag owNoValues = ow0.noValues;
      expect(owNoValues.values.isEmpty, true);
      log.debug('ow0: ${ow0.noValues}');

      for (var i = 0; i < 10; i++) {
        final uInt16List = rng.uint16List(3, 4);
        final ow1 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16List);
        log.debug('ow1: $ow1');
        expect(owNoValues.values.isEmpty, true);
        log.debug('ow1: ${ow1.noValues}');
      }
    });

    test('OW noValues', () {
      final ow0 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16Min);
      final owNoValues = ow0.noValues;
      expect(owNoValues.values.isEmpty, true);
      log.debug('ow0:${ow0.noValues}');
    });

    test('OW copy random', () {
      for (var i = 0; i < 10; i++) {
        final uInt16List = rng.uint16List(3, 4);
        final ow2 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16List);
        final OWtag ow3 = ow2.copy;
        expect(ow3 == ow2, true);
        expect(ow3.hashCode == ow2.hashCode, true);
      }
    });

    test('OW copy', () {
      final ow0 = new OWtag(PTag.kRedPaletteColorLookupTableData, []);
      final OWtag ow1 = ow0.copy;
      expect(ow1 == ow0, true);
      expect(ow1.hashCode == ow0.hashCode, true);

      final ow2 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16Max);
      final ow3 = ow2.copy;
      expect(ow2 == ow3, true);
      expect(ow2.hashCode == ow3.hashCode, true);
    });

    test('OW hashCode and == random good values', () {
      system.throwOnError = false;
      final rng = new RNG(1);
      List<int> uInt16List0;

      for (var i = 0; i < 10; i++) {
        uInt16List0 = rng.uint16List(1, 1);
        final ow0 =
            new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16List0);
        final ow1 =
            new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16List0);
        log
          ..debug('uInt16List0:$uInt16List0, ow0.hash_code:${ow0.hashCode}')
          ..debug('uInt16List0:$uInt16List0, ow1.hash_code:${ow1.hashCode}');
        expect(ow0.hashCode == ow1.hashCode, true);
        expect(ow0 == ow1, true);
      }
    });

    test('OW hashCode and == random bad values', () {
      system.throwOnError = false;
      List<int> uInt16List0;
      List<int> uInt16List1;
      List<int> uInt16List2;
      for (var i = 0; i < 10; i++) {
        uInt16List1 = rng.uint16List(1, 1);
        final ow0 =
            new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16List0);

        final ow2 =
            new OWtag(PTag.kGreenPaletteColorLookupTableData, uInt16List1);
        log.debug('uInt16List1:$uInt16List1 , ow2.hash_code:${ow2.hashCode}');
        expect(ow0.hashCode == ow2.hashCode, false);
        expect(ow0 == ow2, false);

        uInt16List2 = rng.uint16List(2, 3);
        final ow3 =
            new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16List2);
        log.debug('uInt16List2:$uInt16List2 , ow3.hash_code:${ow3.hashCode}');
        expect(ow0.hashCode == ow3.hashCode, false);
        expect(ow0 == ow3, false);
      }
    });

    test('OW hashCode and == good values ', () {
      final ow0 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16Min);
      final ow1 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16Min);

      log
        ..debug('uInt16Min:$uInt16Min, ow0.hash_code:${ow0.hashCode}')
        ..debug('uInt16Min:$uInt16Min, ow1.hash_code:${ow1.hashCode}');
      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);
    });

    test('OW hashCode and == bad values ', () {
      final ow0 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16Min);

      final ow2 = new OWtag(PTag.kGreenPaletteColorLookupTableData, uInt16Max);
      log.debug('uInt16Max:$uInt16Max , ow2.hash_code:${ow2.hashCode}');
      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
    });

    test('OW checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(1, 1);
        final ow0 =
            new OWtag(PTag.kGreenPaletteColorLookupTableData, uInt16List0);
        expect(ow0.checkLength(ow0.values), true);
      }
    });

    test('OW checkLength', () {
      final ow0 = new OWtag(PTag.kGreenPaletteColorLookupTableData, uInt16Max);
      expect(ow0.checkLength(ow0.values), true);
    });

    test('OW checkValues random', () {
      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(1, 1);
        final ow0 =
            new OWtag(PTag.kGreenPaletteColorLookupTableData, uInt16List0);
        expect(ow0.checkValues(ow0.values), true);
      }
    });

    test('OW checkValues', () {
      final ow0 = new OWtag(PTag.kGreenPaletteColorLookupTableData, uInt16Max);
      expect(ow0.checkValues(ow0.values), true);
    });

    test('OW valuesCopy random', () {
      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(1, 1);
        final ow0 =
            new OWtag(PTag.kGreenPaletteColorLookupTableData, uInt16List0);
        expect(uInt16List0, equals(ow0.valuesCopy));
      }
    });

    test('OW valuesCopy', () {
      final ow0 = new OWtag(PTag.kGreenPaletteColorLookupTableData, uInt16Min);
      expect(uInt16Min, equals(ow0.valuesCopy));
    });

    test('OW replace random', () {
      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(1, 1);
        final ow0 =
            new OWtag(PTag.kGreenPaletteColorLookupTableData, uInt16List0);
        final uInt16List1 = rng.uint16List(1, 1);
        expect(ow0.replace(uInt16List1), equals(uInt16List0));
        expect(ow0.values, equals(uInt16List1));
      }

      final uInt16List1 = rng.uint16List(1, 1);
      final ow1 =
          new OWtag(PTag.kGreenPaletteColorLookupTableData, uInt16List1);
      expect(ow1.replace(<int>[]), equals(uInt16List1));
      expect(ow1.values, equals(<int>[]));

      final ow2 =
          new OWtag(PTag.kGreenPaletteColorLookupTableData, uInt16List1);
      expect(ow2.replace(null), equals(uInt16List1));
      expect(ow2.values, equals(<int>[]));
    });

    test('OW make', () {
      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(1, 1);
        final ow0 = OWtag.make(PTag.kEdgePointIndexList, uInt16List0);
        expect(ow0.hasValidValues, true);
      }
    });

    test('OW fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(1, 1);
        final uInt16ListV1 = new Uint16List.fromList(uInt16List0);
        final uInt8ListV1 = uInt16ListV1.buffer.asUint8List();
        final ow0 = new OWtag.fromBytes(
            PTag.kEdgePointIndexList, uInt8ListV1, uInt8ListV1.lengthInBytes);
        expect(ow0.hasValidValues, true);
        expect(ow0.vfBytes, equals(uInt8ListV1));
        expect(ow0.values is Uint16List, true);
        expect(ow0.values, equals(uInt16ListV1));

        final uInt16List1 = rng.uint16List(2, 2);
        final uInt16ListV2 = new Uint16List.fromList(uInt16List1);
        final uInt8ListV2 = uInt16ListV2.buffer.asUint8List();
        final ow1 = new OWtag.fromBytes(
            PTag.kEdgePointIndexList, uInt8ListV2, uInt8ListV2.lengthInBytes);
        expect(ow1.hasValidValues, true);
      }
    });

    test('OW fromB64', () {
      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(1, 1);
        final uInt16ListV1 = new Uint16List.fromList(uInt16List0);
        final uInt8ListV11 = uInt16ListV1.buffer.asUint8List();
        final base64 = BASE64.encode(uInt8ListV11);
        final ow0 = OWtag.fromB64(PTag.kEdgePointIndexList, base64, 10);
        expect(ow0.hasValidValues, true);
      }
    });

    test('OW checkValue good values', () {
      final uInt16List0 = rng.uint16List(1, 1);
      final ow0 = new OWtag(PTag.kEdgePointIndexList, uInt16List0);

      expect(ow0.checkValue(uInt16Max[0]), true);
      expect(ow0.checkValue(uInt16Min[0]), true);
    });

    test('OW checkValue bad values', () {
      final uInt16List0 = rng.uint16List(1, 1);
      final ow0 = new OWtag(PTag.kEdgePointIndexList, uInt16List0);
      expect(ow0.checkValue(uInt16MaxPlus[0]), false);
      expect(ow0.checkValue(uInt16MinMinus[0]), false);
    });

    test('OW view', () {
      final uInt16List0 = rng.uint16List(10, 10);
      final ow0 = new OWtag(PTag.kSelectorOWValue, uInt16List0);
      for (var i = 0, j = 0; i < uInt16List0.length; i++, j += 2) {
        final ow1 = ow0.view(j, uInt16List0.length - i);
        log.debug(
            'ow0: ${ow0.values}, ow1: ${ow1.values}, uInt16List0.sublist(i) : ${uInt16List0.sublist(i)}');
        expect(ow1.values, equals(uInt16List0.sublist(i)));
      }
    });
  });

  group('OW Element', () {
    //VM.k1
    const owTags0 = const <PTag>[
      PTag.kRedPaletteColorLookupTableData,
      PTag.kGreenPaletteColorLookupTableData,
      PTag.kBluePaletteColorLookupTableData,
      PTag.kAlphaPaletteColorLookupTableData,
      PTag.kLargeRedPaletteColorLookupTableData,
      PTag.kLargeGreenPaletteColorLookupTableData,
      PTag.kLargeBluePaletteColorLookupTableData,
      PTag.kSegmentedRedPaletteColorLookupTableData,
      PTag.kSegmentedGreenPaletteColorLookupTableData,
      PTag.kSegmentedBluePaletteColorLookupTableData,
      PTag.kBlendingLookupTableData,
      PTag.kTrianglePointIndexList,
      PTag.kEdgePointIndexList,
      PTag.kVertexPointIndexList,
      PTag.kPrimitivePointIndexList,
      PTag.kRecommendedDisplayCIELabValueList,
      PTag.kCoefficientsSDVN,
      PTag.kCoefficientsSDHN,
      PTag.kCoefficientsSDDN,
      PTag.kVariableCoefficientsSDVN,
      PTag.kVariableCoefficientsSDHN,
      PTag.kVariableCoefficientsSDDN
    ];

    //VM.k1_n
    const owTags1 = const <PTag>[
      PTag.kSelectorOWValue,
    ];

    const otherTags = const <PTag>[
      PTag.kColumnAngulationPatient,
      PTag.kAcquisitionProtocolName,
      PTag.kCTDIvol,
      PTag.kCTPositionSequence,
      PTag.kAcquisitionType,
      PTag.kPerformedStationAETitle,
      PTag.kSelectorSTValue,
      PTag.kDate,
      PTag.kTime
    ];

    test('OW isValidVListLength', () {
      system.throwOnError = false;
      expect(OW.isValidVListLength(OW.kMaxLength), true);
      expect(OW.isValidVListLength(0), true);
    });

    test('OW isValidVR good values', () {
      system.throwOnError = false;
      expect(OW.isValidVRIndex(kOWIndex), true);

      for (var tag in owTags0) {
        system.throwOnError = false;
        expect(OW.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('OW isValidVR good values', () {
      for (var tag in owTags1) {
        system.throwOnError = false;
        expect(OW.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('OW isValidVR bad values', () {
      system.throwOnError = false;
      expect(OW.isValidVRIndex(kAEIndex), false);
      system.throwOnError = true;
      expect(() => OW.isValidVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OW.isValidVRIndex(tag.vrIndex), false);

        system.throwOnError = true;
        expect(() => OW.isValidVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('OW checkVR  good values', () {
      system.throwOnError = false;
      expect(OW.checkVRIndex(kOWIndex), kOWIndex);

      for (var tag in owTags0) {
        system.throwOnError = false;
        expect(OW.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('OW checkVR bad values', () {
      system.throwOnError = false;
      expect(OW.checkVRIndex(kAEIndex), isNull);
      system.throwOnError = true;
      expect(() => OW.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OW.checkVRIndex(tag.vrIndex), isNull);

        system.throwOnError = true;
        expect(() => OW.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('OW.isValidVRIndex good values', () {
      system.throwOnError = false;
      expect(OW.isValidVRIndex(kOWIndex), true);

      for (var tag in owTags0) {
        system.throwOnError = false;
        expect(OW.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('OW.isValidVRIndex bad values', () {
      system.throwOnError = false;
      expect(OW.isValidVRIndex(kCSIndex), false);

      system.throwOnError = true;
      expect(() => OW.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OW.isValidVRIndex(tag.vrIndex), false);

        system.throwOnError = true;
        expect(() => OW.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('OW isValidVRCode good values', () {
      system.throwOnError = false;
      expect(OW.isValidVRCode(kOWCode), true);

      for (var tag in owTags0) {
        expect(OW.isValidVRCode(tag.vrCode), true);
      }
    });

    test('OW isValidVRCode bad values', () {
      system.throwOnError = false;
      expect(OW.isValidVRCode(kAECode), false);

      system.throwOnError = true;
      expect(() => OW.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OW.isValidVRCode(tag.vrCode), false);

        system.throwOnError = true;
        expect(() => OW.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('OW isValidVFLength good values', () {
      expect(OW.isValidVFLength(OW.kMaxVFLength), true);
      expect(OW.isValidVFLength(0), true);
    });

    test('OW isValidVFLength bad values', () {
      expect(OW.isValidVFLength(OW.kMaxVFLength + 1), false);
      expect(OW.isValidVFLength(-1), false);
    });

    test('OW isValidValue good values', () {
      expect(OW.isValidValue(OW.kMinValue), true);
      expect(OW.isValidValue(OW.kMaxValue), true);
    });

    test('OW isValidValue bad values', () {
      expect(OW.isValidValue(OW.kMinValue - 1), false);
      expect(OW.isValidValue(OW.kMaxValue + 1), false);
    });

    test('OW isValidValues good values', () {
      system.throwOnError = false;
      const uInt16MinMax = const [kUint16Min, kUint16Max];
      const uInt16Min = const [kUint16Min];
      const uInt16Max = const [kUint16Max];

      //VM.k1
      expect(OW.isValidValues(PTag.kPixelData, uInt16Min), true);
      expect(OW.isValidValues(PTag.kBlendingLookupTableData, uInt16Max), true);

      //VM.k1_n
      expect(OW.isValidValues(PTag.kSelectorOWValue, uInt16Min), true);
      expect(OW.isValidValues(PTag.kSelectorOWValue, uInt16Max), true);
      expect(OW.isValidValues(PTag.kSelectorOWValue, uInt16MinMax), true);
    });

    test('OW isValidValues bad values', () {
      system.throwOnError = false;
      const uInt16MaxPlus = const [kUint16Max + 1];
      const uInt16MinMinus = const [kUint16Min - 1];

      expect(OW.isValidValues(PTag.kPixelData, uInt16MaxPlus), false);
      expect(OW.isValidValues(PTag.kBlendingLookupTableData, uInt16MinMinus),
          false);

      system.throwOnError = true;
      expect(
          () => OW.isValidValues(PTag.kBlendingLookupTableData, uInt16MaxPlus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
      expect(
          () => OW.isValidValues(PTag.kBlendingLookupTableData, uInt16MinMinus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('OW toUint16List', () {
      for (var i = 0; i < 10; i++) {
        final uInt16list0 = rng.uint16List(1, 1);
        expect(Uint16Base.toUint16List(uInt16list0), uInt16list0);
      }
      const uInt16Min = const [kUint16Min];
      const uInt16Max = const [kUint16Max];
      expect(Uint16Base.toUint16List(uInt16Min), uInt16Min);
      expect(Uint16Base.toUint16List(uInt16Max), uInt16Max);
    });

    test('OW fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uInt16list0 = rng.uint16List(1, 1);
        final uInt16ListV1 = new Uint16List.fromList(uInt16list0);
        final bd = uInt16ListV1.buffer.asUint8List();
        log
          ..debug('uInt16ListV1 : $uInt16ListV1')
          ..debug(
              'Uint16Base.listFromBytes(bd) ; ${Uint16Base.listFromBytes(bd)}');
        expect(Uint16Base.listFromBytes(bd), equals(uInt16ListV1));
      }
    });

    test('OW toBytes', () {
      for (var i = 0; i < 10; i++) {
        final uInt16list0 = rng.uint16List(1, 1);
        final uInt16ListV1 = new Uint16List.fromList(uInt16list0);
        final bd = uInt16ListV1.buffer.asUint8List();
        log
          ..debug('uInt16ListV1 : $uInt16ListV1')
          ..debug(
              'Uint16Base.listToBytes(uInt16ListV1) ; ${Uint16Base.listToBytes(uInt16ListV1)}');
        expect(Uint16Base.listToBytes(uInt16ListV1), equals(bd));
      }
    });

    test('OW fromBase64', () {
      for (var i = 0; i < 10; i++) {
        final uInt16list0 = rng.uint16List(0, i);
        final uInt16ListV1 = new Uint16List.fromList(uInt16list0);
        final bd = uInt16ListV1.buffer.asUint8List();
        final base64 = BASE64.encode(bd);
        log.debug('OW.base64: "$base64"');

        final owList = Uint16Base.listFromBase64(base64);
        log.debug('  OW.decode: $owList');
        expect(owList, equals(uInt16list0));
        expect(owList, equals(uInt16ListV1));
      }
    });

    test('OW toBase64', () {
      for (var i = 0; i < 10; i++) {
        final uInt16list0 = rng.uint16List(0, i);
        final uInt16ListV1 = new Uint16List.fromList(uInt16list0);
        final bd = uInt16ListV1.buffer.asUint8List();
        final s = BASE64.encode(bd);
        expect(Uint16Base.listToBase64(uInt16list0), equals(s));
      }
    });

    test('OW encodeDecodeJsonVF', () {
      system.level = Level.info;
      for (var i = 1; i < 10; i++) {
        final uInt16list0 = rng.uint16List(0, i);
        final uInt16ListV1 = new Uint16List.fromList(uInt16list0);
        final bd = uInt16ListV1.buffer.asUint8List();

        // Encode
        final base64 = BASE64.encode(bd);
        log.debug('OW.base64: "$base64"');
        final s = Uint16Base.listToBase64(uInt16list0);
        log.debug('  OW.json: "$s"');
        expect(s, equals(base64));

        // Decode
        final ow0 = Uint16Base.listFromBase64(base64);
        log.debug('OW.base64: $ow0');
        final ow1 = Uint16Base.listFromBase64(s);
        log.debug('  OW.json: $ow1');
        expect(ow0, equals(uInt16list0));
        expect(ow0, equals(uInt16ListV1));
        expect(ow0, equals(ow1));
      }
    });

    test('OW fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uInt16list0 = rng.uint16List(1, 1);
        final uInt16ListV1 = new Uint16List.fromList(uInt16list0);
        final bd = uInt16ListV1.buffer.asUint8List();
        log
          ..debug('uInt16ListV1 : $uInt16ListV1')
          ..debug(
              'Uint16Base.listFromBytes(bd) ; ${Uint16Base.listFromBytes(bd)}');
        expect(Uint16Base.listFromBytes(bd), equals(uInt16ListV1));
      }
    });

    test('OW fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final uInt16list0 = rng.uint16List(1, 1);
        final uInt16ListV1 = new Uint16List.fromList(uInt16list0);
        final byteData = uInt16ListV1.buffer.asByteData();
        log
          ..debug('uInt16ListV1 : $uInt16ListV1')
          ..debug(
              'Uint16Base.listFromByteData(byteData) ; ${Uint16Base.listFromByteData(byteData)}');
        expect(Uint16Base.listFromByteData(byteData), equals(uInt16ListV1));
      }
    });
  });
}
