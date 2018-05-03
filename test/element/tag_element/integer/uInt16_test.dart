//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/uint16_test', level: Level.info);
  final rng = new RNG(1);

  const uint16MinMax = const [kUint16Min, kUint16Max];
  const uint16Min = const [kUint16Min];
  const uint16Max = const [kUint16Max];
  const uint16MaxPlus = const [kUint16Max + 1];
  const uint16MinMinus = const [kUint16Min - 1];

  group('US', () {
    test('US hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
        final us0 = new UStag(PTag.kContrastFrameAveraging, uint16List0);
        expect(us0.hasValidValues, true);
        log.debug('us0: ${us0.info}');
        expect(us0.hasValidValues, true);

        log
          ..debug('us0: $us0, values: ${us0.values}')
          ..debug('us0: ${us0.info}');
        expect(us0[0], equals(uint16List0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(2, 2);
        final us0 =
            new UStag(PTag.kTopLeftHandCornerOfLocalizerArea, uint16List0);
        expect(us0.hasValidValues, true);
        log.debug('us0: ${us0.info}');
        expect(us0.hasValidValues, true);

        log
          ..debug('us0: $us0, values: ${us0.values}')
          ..debug('us0: ${us0.info}');
        expect(us0[0], equals(uint16List0[0]));
      }
    });

    test('US hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(2, 3);
        log.debug('$i: uint16List0: $uint16List0');
        final us0 = new UStag(PTag.kRepresentativeFrameNumber, uint16List0);
        expect(us0, isNull);
      }
    });

    test('US hasValidValues good values', () {
      system.throwOnError = false;
      final us0 = new UStag(PTag.kRepresentativeFrameNumber, uint16Min);
      final us1 = new UStag(PTag.kRepresentativeFrameNumber, uint16Min);
      expect(us0.hasValidValues, true);
      expect(us1.hasValidValues, true);

      final us2 = new UStag(PTag.kRepresentativeFrameNumber, uint16Max);
      final us3 = new UStag(PTag.kRepresentativeFrameNumber, uint16Max);
      expect(us2.hasValidValues, true);
      expect(us3.hasValidValues, true);

      system.throwOnError = false;
      final us4 = new UStag(PTag.kRepresentativeFrameNumber, []);
      expect(us4.hasValidValues, true);
      log.debug('us4:${us4.info}');
      expect(us4.values, equals(<int>[]));
    });

    test('US hasValidValues bad values', () {
      final us0 = new UStag(PTag.kRepresentativeFrameNumber, uint16MaxPlus);
      expect(us0, isNull);

      final us1 = new UStag(PTag.kRepresentativeFrameNumber, uint16MinMinus);
      expect(us1, isNull);

      final us2 = new UStag(PTag.kRepresentativeFrameNumber, uint16MinMax);
      expect(us2, isNull);

      system.throwOnError = false;
      final us3 = new UStag(PTag.kRepresentativeFrameNumber, uint16Max);
      final uint32List0 = rng.uint32List(1, 1);
      us3.values = uint32List0;
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
        final uint16List0 = rng.uint16List(3, 4);
        final us1 = new UStag(PTag.kAcquisitionIndex, uint16List0);
        final uint16List1 = rng.uint16List(3, 4);
        expect(us1.update(uint16List1).values, equals(uint16List1));
      }
    });

    test('US update', () {
      final us0 = new UStag(PTag.kSelectorUSValue, []);
      expect(us0.update([63457, 64357]).values, equals([63457, 64357]));

      final us1 = new UStag(PTag.kFrameNumbersOfInterest, uint16Min);
      final us2 = new UStag(PTag.kFrameNumbersOfInterest, uint16Min);
      final us3 = us1.update(uint16Max);
      final us4 = us2.update(uint16Max);
      expect(us1.values.first == us4.values.first, false);
      expect(us1 == us4, false);
      expect(us1 == us4, false);
      expect(us3 == us4, true);
    });

    test('US noValues random', () {
      for (var i = 0; i < 10; i++) {
        final uint16List = rng.uint16List(3, 4);
        final us1 = new UStag(PTag.kFrameNumbersOfInterest, uint16List);
        log.debug('us1: ${us1.noValues}');
        expect(us1.noValues.values.isEmpty, true);
      }
    });

    test('US noValues', () {
      final us0 = new UStag(PTag.kFrameNumbersOfInterest, []);
      final UStag usNoValues = us0.noValues;
      expect(usNoValues.values.isEmpty, true);
      log.debug('us0: ${us0.noValues}');

      final us1 = new UStag(PTag.kRepresentativeFrameNumber, uint16Min);
      final usNoValues0 = us1.noValues;
      expect(usNoValues0.values.isEmpty, true);
      log.debug('us1:${us1.noValues}');
    });

    test('US copy random', () {
      for (var i = 0; i < 10; i++) {
        final uint16List = rng.uint16List(3, 4);
        final us2 = new UStag(PTag.kSelectorUSValue, uint16List);
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

      final us2 = new UStag(PTag.kRepresentativeFrameNumber, uint16Max);
      final us3 = us2.copy;
      expect(us2 == us3, true);
      expect(us2.hashCode == us3.hashCode, true);
    });

    test('US hashCode and == good values random', () {
      system.throwOnError = false;
      final rng = new RNG(1);
      List<int> uint16List0;

      for (var i = 0; i < 10; i++) {
        uint16List0 = rng.uint16List(1, 1);
        final us0 = new UStag(PTag.kLargestMonochromePixelValue, uint16List0);
        final us1 = new UStag(PTag.kLargestMonochromePixelValue, uint16List0);
        log
          ..debug('uint16List0:$uint16List0, us0.hash_code:${us0.hashCode}')
          ..debug('uint16List0:$uint16List0, us1.hash_code:${us1.hashCode}');
        expect(us0.hashCode == us1.hashCode, true);
        expect(us0 == us1, true);
      }
    });
    test('US hashCode and == bad values random', () {
      system.throwOnError = false;
      List<int> uint16List0;
      List<int> uint16List1;
      List<int> uint16List2;
      List<int> uint16List3;
      List<int> uint16List4;
      List<int> uint16List5;

      for (var i = 0; i < 10; i++) {
        uint16List0 = rng.uint16List(1, 1);
        uint16List1 = rng.uint16List(1, 1);
        final us0 = new UStag(PTag.kLargestMonochromePixelValue, uint16List0);

        final us2 = new UStag(PTag.kRepresentativeFrameNumber, uint16List1);
        log.debug('uint16List1:$uint16List1 , us2.hash_code:${us2.hashCode}');
        expect(us0.hashCode == us2.hashCode, false);
        expect(us0 == us2, false);

        uint16List2 = rng.uint16List(2, 2);
        final us3 =
            new UStag(PTag.kTopLeftHandCornerOfLocalizerArea, uint16List2);
        log.debug('uint16List2:$uint16List2 , us3.hash_code:${us3.hashCode}');
        expect(us0.hashCode == us3.hashCode, false);
        expect(us0 == us3, false);

        uint16List3 = rng.uint16List(3, 3);
        final us4 = new UStag(PTag.kRecommendedDisplayCIELabValue, uint16List3);
        log.debug('uint16List2:$uint16List2 , us4.hash_code:${us4.hashCode}');
        expect(us0.hashCode == us4.hashCode, false);
        expect(us0 == us4, false);

        uint16List4 = rng.uint16List(4, 4);
        final us5 = new UStag(PTag.kAcquisitionMatrix, uint16List4);
        log.debug('uint1uint16List46List2:$uint16List4 , us5.hash_code:${us5
                .hashCode}');
        expect(us0.hashCode == us5.hashCode, false);
        expect(us0 == us5, false);

        uint16List5 = rng.uint16List(2, 3);
        final us6 = new UStag(PTag.kRepresentativeFrameNumber, uint16List5);
        log.debug('uint16List5:$uint16List5 , us6.hash_code:${us6.hashCode}');
        expect(us0.hashCode == us6.hashCode, false);
        expect(us0 == us6, false);
      }
    });

    test('US hashCode and == good values', () {
      final us0 = new UStag(PTag.kRepresentativeFrameNumber, uint16Min);
      final us1 = new UStag(PTag.kRepresentativeFrameNumber, uint16Min);

      log
        ..debug('uint16Min:$uint16Min, us0.hash_code:${us0.hashCode}')
        ..debug('uint16Min:$uint16Min, us1.hash_code:${us1.hashCode}');
      expect(us0.hashCode == us1.hashCode, true);
      expect(us0 == us1, true);
    });

    test('US hashCode and == bad values', () {
      final us0 = new UStag(PTag.kRepresentativeFrameNumber, uint16Min);
      final us2 = new UStag(PTag.kRepresentativeFrameNumber, uint16Max);
      log.debug('uint16Max:$uint16Max , ob2.hash_code:${us2.hashCode}');
      expect(us0.hashCode == us2.hashCode, false);
      expect(us0 == us2, false);
    });

    test('US fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
//        final uint16List1 = new Uint16List.fromList(uint16List0);
//        final uint8List11 = uint16List1.buffer.asUint8List();
        final bytes0 = new Bytes.typedDataView(uint16List0);
        final us0 = UStag.fromBytes(PTag.kRepresentativeFrameNumber, bytes0);
        print(us0);
        expect(us0.hasValidValues, true);
        expect(us0.vfBytes, equals(bytes0));
        expect(us0.values is Uint16List, true);
        expect(us0.values, equals(bytes0.asUint16List()));

        // Test Base64
        final base64 = bytes0.asBase64();
        final usList = Bytes.fromBase64(base64);
        final us1 = UStag.fromBytes(PTag.kRepresentativeFrameNumber, usList);
        expect(us0 == us1, true);
        expect(us1.value, equals(us0.value));

        final uint16List1 = rng.uint16List(2, 2);
//        final uint16List2 = new Uint16List.fromList(uint16List1);
//       final uint8List12 = uint16List2.buffer.asUint8List();
        final bytes1 = new Bytes.typedDataView(uint16List1);
        final us2 = UStag.fromBytes(PTag.kRepresentativeFrameNumber, bytes1);
        expect(us2.hasValidValues, false);
      }
    });

    test('US fromBytes', () {
      final uint16List1 = new Uint16List.fromList(uint16Min);
      //     final uint8List11 = uint16List1.buffer.asUint8List();
      final bytes0 = new Bytes.typedDataView(uint16List1);
      final us5 = UStag.fromBytes(PTag.kRepresentativeFrameNumber, bytes0);
      expect(us5.hasValidValues, true);
      expect(us5.vfBytes, equals(bytes0));
      expect(us5.values is Uint16List, true);
      expect(us5.values, equals(uint16List1));
    });

    test('UC fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final intList0 = rng.uint16List(1, 10);
        final bytes0 = Bytes.asciiEncode(intList0.toString());
        final uc0 = UCtag.fromBytes(PTag.kSelectorUCValue, bytes0);
        log.debug('uc0: ${uc0.info}');
        expect(uc0.hasValidValues, true);
      }
    });

    test('UC fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final intList0 = rng.uint16List(1, 10);
        final bytes0 = Bytes.asciiEncode(intList0.toString());
        final uc0 = UCtag.fromBytes(PTag.kSelectorFDValue, bytes0);
        expect(uc0, isNull);

        system.throwOnError = true;
        expect(() => UCtag.fromBytes(PTag.kSelectorFDValue, bytes0),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('US checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
        final us0 = new UStag(PTag.kRepresentativeFrameNumber, uint16List0);
        expect(us0.checkLength(us0.values), true);
      }
    });

    test('US checkLength', () {
      final us0 = new UStag(PTag.kRepresentativeFrameNumber, uint16Max);
      expect(us0.checkLength(us0.values), true);
    });

    test('US checkValues random', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
        final us0 = new UStag(PTag.kRepresentativeFrameNumber, uint16List0);
        expect(us0.checkValues(us0.values), true);
      }
    });

    test('US checkValues ', () {
      final us0 = new UStag(PTag.kRepresentativeFrameNumber, uint16Max);
      expect(us0.checkValues(us0.values), true);
    });

    test('US valuesCopy random', () {
      //valuesCopy
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
        final us0 = new UStag(PTag.kRepresentativeFrameNumber, uint16List0);
        expect(uint16List0, equals(us0.valuesCopy));
      }
    });

    test('US valuesCopy', () {
      final us0 = new UStag(PTag.kRepresentativeFrameNumber, uint16Min);
      expect(uint16Min, equals(us0.valuesCopy));
    });

    test('US replace random', () {
      final uint16List0 = rng.uint16List(1, 1);
      final us0 = new UStag(PTag.kRepresentativeFrameNumber, uint16List0);
      final uint16List1 = rng.uint16List(1, 1);
      expect(us0.replace(uint16List1), equals(uint16List0));
    });

/*
    test('US BASE64 random', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
        final uint16List1 = new Uint16List.fromList(uint16List0);
        final uint16List11 = uint16List1.buffer.asUint8List();
        final base64 = cvt.base64.encode(uint16List11);
        final us0 = UStag.fromBytes(PTag.kRepresentativeFrameNumber, base64);
        expect(us0.hasValidValues, true);
      }
    });

    test('US BASE64', () {
      final uint16List1 = new Uint16List.fromList(uint16Min);
      final uint16List11 = uint16List1.buffer.asUint8List();
      final base64 = cvt.base64.encode(uint16List11);
      final us0 = UStag.fromBytes(PTag.kRepresentativeFrameNumber, base64);
      expect(us0.hasValidValues, true);
    });
*/

    test('US make good values', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
        final make0 =
            UStag.fromValues(PTag.kRepresentativeFrameNumber, uint16List0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);

        final make1 =
            UStag.fromValues(PTag.kRepresentativeFrameNumber, <int>[]);
        expect(make1.hasValidValues, true);
        expect(make1.values, equals(<int>[]));
      }
    });

    test('US make bad values', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(2, 2);
        system.throwOnError = false;
        final make0 =
            UStag.fromValues(PTag.kRepresentativeFrameNumber, uint16List0);
        expect(make0, isNull);

        system.throwOnError = true;
        expect(
            () =>
                UStag.fromValues(PTag.kRepresentativeFrameNumber, uint16List0),
            throwsA(const isInstanceOf<InvalidValuesLengthError>()));
      }
    });

    test('US fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
//        final uint16List1 = new Uint16List.fromList(uint16List0);
//        final uint8List1 = uint16List1.buffer.asUint8List();
        final bytes0 = new Bytes.typedDataView(uint16List0);
        final us0 = UStag.fromBytes(PTag.kRepresentativeFrameNumber, bytes0);
        print(us0);
        expect(us0.hasValidValues, true);
        expect(us0.vfBytes, equals(bytes0));
        expect(us0.values is Uint16List, true);
        expect(us0.values, equals(uint16List0));
      }
    });
/*

    test('US fromB64', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
        final uint16List1 = new Uint16List.fromList(uint16List0);
        final uint8List11 = uint16List1.buffer.asUint8List();
        final base64 = cvt.base64.encode(uint8List11);
        final us0 = UStag.fromBytes(PTag.kRepresentativeFrameNumber, base64);
        expect(us0.hasValidValues, true);
      }
    });
*/

    test('US checkValue good values', () {
      final uint16List0 = rng.uint16List(1, 1);
      final us0 = new UStag(PTag.kRepresentativeFrameNumber, uint16List0);

      expect(us0.checkValue(uint16Max[0]), true);
      expect(us0.checkValue(uint16Min[0]), true);
    });

    test('US checkValue bad values', () {
      final uint16List0 = rng.uint16List(1, 1);
      final us0 = new UStag(PTag.kRepresentativeFrameNumber, uint16List0);

      expect(us0.checkValue(uint16MaxPlus[0]), false);
      expect(us0.checkValue(uint16MinMinus[0]), false);
    });

    test('US view', () {
      final uint16List0 = rng.uint16List(10, 10);
      final us0 = new UStag(PTag.kSelectorUSValue, uint16List0);
      for (var i = 0, j = 0; i < uint16List0.length; i++, j += 2) {
        final us1 = us0.view(j, uint16List0.length - i);
        log.debug('us0: ${us0.values}, us1: ${us1.values}, '
            'uint16List0.sublist(i) : ${uint16List0.sublist(i)}');
        expect(us1.values, equals(uint16List0.sublist(i)));
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

    test('US isValidTag good values', () {
      system.throwOnError = false;
      expect(US.isValidTag(PTag.kSelectorUSValue), true);
      expect(US.isValidTag(PTag.kZeroVelocityPixelValue), true);
      expect(US.isValidTag(PTag.kGrayLookupTableData), true);

      for (var tag in usTags0) {
        expect(US.isValidTag(tag), true);
      }
    });

    test('US isValidTag bad values', () {
      system.throwOnError = false;
      expect(US.isValidTag(PTag.kSelectorAEValue), false);

      system.throwOnError = true;
      expect(() => US.isValidTag(PTag.kSelectorAEValue),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(US.isValidTag(tag), false);

        system.throwOnError = true;
        expect(() => US.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('US isNotValidTag good values', () {
      system.throwOnError = false;
      expect(US.isNotValidTag(PTag.kSelectorUSValue), false);
      expect(US.isNotValidTag(PTag.kZeroVelocityPixelValue), false);
      expect(US.isNotValidTag(PTag.kGrayLookupTableData), false);

      for (var tag in usTags0) {
        expect(US.isNotValidTag(tag), false);
      }
    });

    test('US isNotValidTag bad values', () {
      system.throwOnError = false;
      expect(US.isNotValidTag(PTag.kSelectorAEValue), true);

      system.throwOnError = true;
      expect(() => US.isNotValidTag(PTag.kSelectorAEValue),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(US.isNotValidTag(tag), true);

        system.throwOnError = true;
        expect(() => US.isNotValidTag(tag),
            throwsA(const isInstanceOf<InvalidVRError>()));
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
      expect(() => US.isValidVRIndex(kAEIndex),
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
      const uint16MinMax = const [kUint16Min, kUint16Max];
      const uint16MinMaxPlus0 = const [kUint16Min, kUint16Max, kUint8Min];
      const uint16MinMaxPlus1 = const [
        kUint16Min,
        kUint16Max,
        kUint8Min,
        kUint8Max
      ];
      const uint16Min = const [kUint16Min];
      const uint16Max = const [kUint16Max];

      //VM.k1
      expect(US.isValidValues(PTag.kWarningReason, uint16Min), true);
      expect(US.isValidValues(PTag.kWarningReason, uint16Max), true);

      //VM.k2
      expect(
          US.isValidValues(PTag.kLightPathFilterPassBand, uint16MinMax), true);

      //VM.k3
      expect(US.isValidValues(PTag.kTextColorCIELabValue, uint16MinMaxPlus0),
          true);

      //VM.k4
      expect(
          US.isValidValues(PTag.kAcquisitionMatrix, uint16MinMaxPlus1), true);

      //VM.k1_n
      expect(US.isValidValues(PTag.kSelectorUSValue, uint16Min), true);
      expect(US.isValidValues(PTag.kSelectorUSValue, uint16Max), true);
      expect(US.isValidValues(PTag.kSelectorUSValue, uint16MinMax), true);
      expect(US.isValidValues(PTag.kSelectorUSValue, uint16MinMaxPlus0), true);
    });

    test('US isValidValues bad values', () {
      system.throwOnError = false;
      const uint16MaxPlus = const [kUint16Max + 1];
      const uint16MinMinus = const [kUint16Min - 1];

      //VM.k1
      expect(US.isValidValues(PTag.kWarningReason, uint16MaxPlus), false);
      expect(US.isValidValues(PTag.kWarningReason, uint16MinMinus), false);

      //VM.k2
      expect(US.isValidValues(PTag.kLightPathFilterPassBand, uint16MaxPlus),
          false);

      //VM.k3
      expect(
          US.isValidValues(PTag.kTextColorCIELabValue, uint16MaxPlus), false);

      //VM.k4
      expect(US.isValidValues(PTag.kAcquisitionMatrix, uint16MinMinus), false);

      system.throwOnError = true;
      expect(() => US.isValidValues(PTag.kWarningReason, uint16MaxPlus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
      expect(() => US.isValidValues(PTag.kWarningReason, uint16MinMinus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('US isValidValues bad values length', () {
      system.throwOnError = false;

      const uint16MinMax = const [kUint16Min, kUint16Max];
      const uint16MinMaxPlus0 = const [kUint16Min, kUint16Max, kUint8Min];
      const uint16MinMaxPlus1 = const [
        kUint16Min,
        kUint16Max,
        kUint8Min,
        kUint8Max
      ];
      const uint16Min = const [kUint16Min];
      const uint16Max = const [kUint16Max];

      //VM.k1
      expect(US.isValidValues(PTag.kWarningReason, uint16MinMax), false);

      //VM.k2

      expect(US.isValidValues(PTag.kLightPathFilterPassBand, uint16Min), false);
      expect(US.isValidValues(PTag.kLightPathFilterPassBand, uint16Max), false);
      expect(US.isValidValues(PTag.kLightPathFilterPassBand, uint16MinMaxPlus0),
          false);

      //VM.k3
      expect(US.isValidValues(PTag.kTextColorCIELabValue, uint16Min), false);
      expect(US.isValidValues(PTag.kTextColorCIELabValue, uint16Max), false);
      expect(US.isValidValues(PTag.kTextColorCIELabValue, uint16MinMaxPlus1),
          false);

      //VM.k4
      expect(US.isValidValues(PTag.kAcquisitionMatrix, uint16Min), false);
      expect(US.isValidValues(PTag.kAcquisitionMatrix, uint16Max), false);
      expect(
          US.isValidValues(PTag.kAcquisitionMatrix, uint16MinMaxPlus0), false);

      system.throwOnError = true;
      expect(() => US.isValidValues(PTag.kWarningReason, uint16MinMax),
          throwsA(const isInstanceOf<InvalidValuesLengthError>()));
      expect(() => US.isValidValues(PTag.kLightPathFilterPassBand, uint16Min),
          throwsA(const isInstanceOf<InvalidValuesLengthError>()));
      expect(() => US.isValidValues(PTag.kTextColorCIELabValue, uint16Min),
          throwsA(const isInstanceOf<InvalidValuesLengthError>()));
      expect(() => US.isValidValues(PTag.kAcquisitionMatrix, uint16Max),
          throwsA(const isInstanceOf<InvalidValuesLengthError>()));
    });

    test('US toUint16List', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
        expect(Uint16.fromList(uint16List0), uint16List0);
      }
      const uint16Min = const [kUint16Min];
      const uint16Max = const [kUint16Max];
      expect(Uint16.fromList(uint16Min), uint16Min);
      expect(Uint16.fromList(uint16Max), uint16Max);
    });

    test('US fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
        //       final uint16List1 = new Uint16List.fromList(uint16List0);
        //       final bd = uint16List1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(uint16List0);
        log
          ..debug('uint16List1 : $uint16List0')
          ..debug('Uint16Base.listFromBytes(bd) ; ${Uint16.fromBytes(bytes)}');
        expect(Uint16.fromBytes(bytes), equals(uint16List0));
      }
    });

    test('US toBytes', () {
      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
        final uint16List1 = new Uint16List.fromList(uint16List0);
        final bd = uint16List1.buffer.asUint8List();
        log
          ..debug('uint16List1 : $uint16List1')
          ..debug('Uint16Base.listToBytes(uint16List1) ; '
              '${Uint16.toBytes(uint16List1)}');
        expect(Uint16.toBytes(uint16List1), equals(bd));
      }

      const uint16Max = const [kUint16Max];
      final uint16List1 = new Uint16List.fromList(uint16Max);
      final uint16List = uint16List1.buffer.asUint8List();
      expect(Uint16.toBytes(uint16Max), uint16List);

      const uint32Max = const [kUint32Max];
      expect(Uint16.toBytes(uint32Max), isNull);

      system.throwOnError = true;
      expect(() => Uint16.toBytes(uint32Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('Uint16Base listToByteData good values', () {
      system.level = Level.info;
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final uint16List0 = rng.uint16List(1, 1);
        final bd0 = uint16List0.buffer.asByteData();
        final lBd0 = Uint16.toByteData(uint16List0);
        log.debug('lBd0: ${lBd0.buffer.asUint8List()}, bd0: ${bd0.buffer
            .asUint8List()}');
        expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd0.buffer == bd0.buffer, true);

        final lBd1 = Uint16.toByteData(uint16List0, check: false);
        log.debug('lBd3: ${lBd1.buffer.asUint8List()}, '
            'bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd1.buffer == bd0.buffer, true);
      }

      const uint16Max = const [kUint16Max];
      final uint16List = new Uint16List.fromList(uint16Max);
      final bd1 = uint16List.buffer.asByteData();
      final lBd2 = Uint16.toByteData(uint16List);
      log.debug('bd: ${bd1.buffer.asUint8List()}, '
          'lBd2: ${lBd2.buffer.asUint8List()}');
      expect(lBd2.buffer.asUint8List(), equals(bd1.buffer.asUint8List()));
      expect(lBd2.buffer == bd1.buffer, true);
    });

    test('Uint16Base listToByteData bad values', () {
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final uint16List0 = rng.uint16List(1, 1);
        final bd0 = uint16List0.buffer.asByteData();
        final lBd1 = Uint16.toByteData(uint16List0, asView: false);
        log.debug('lBd1: ${lBd1.buffer.asUint8List()}, '
            'bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd1.buffer == bd0.buffer, false);

        final uint32List0 = rng.uint32List(1, 1);
        assert(uint32List0 is TypedData);
        final bd1 = uint32List0.buffer.asByteData();
        final lBd2 = Uint16.toByteData(uint32List0, check: false);
        log.debug('lBd0: ${lBd2.buffer.asUint8List()}, '
            'bd1: ${bd1.buffer.asUint8List()}');
        expect(lBd2.buffer.asUint8List(), isNot(bd0.buffer.asUint8List()));
        expect(lBd2.buffer == bd0.buffer, false);
        final lBd3 = Uint16.toByteData(uint32List0, asView: false);
        expect(lBd3, isNull);

        final lBd4 =
            Uint16.toByteData(uint16List0, asView: false, check: false);
        log.debug('lBd4: ${lBd4.buffer.asUint8List()}, '
            'bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd4.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd4.buffer == bd0.buffer, false);
      }

      system.throwOnError = false;
      const uint32Max = const <int>[kUint32Max];
      expect(Uint16.toByteData(uint32Max), isNull);

      system.throwOnError = true;
      expect(() => Uint16.toByteData(uint32Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('US fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
//        final uint16List1 = new Uint16List.fromList(uint16List0);
//        final bd = uint16List1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(uint16List0);
        final base64 = bytes.asBase64();
        log.debug('US.base64: "$base64"');

        final usList = Uint16.fromBytes(bytes);
        log.debug('  US.decode: $usList');
        expect(usList, equals(uint16List0));
//        expect(usList, equals(uint16List1));
      }
    });

    test('US toBase64', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
//        final uint16List1 = new Uint16List.fromList(uint16List0);
//        final bd = uint16List1.buffer.asUint8List();
//        final s = cvt.base64.encode(bd);
        final bytes = new Bytes.typedDataView(uint16List0);
        final base64 = bytes.asBase64();
        expect(Uint16.toBase64(uint16List0), equals(base64));
      }
    });

    test('US encodeDecodeJsonVF', () {
      system.level = Level.info;
      for (var i = 1; i < 10; i++) {
        final uint16List0 = rng.uint16List(0, i);
//        final uint16List1 = new Uint16List.fromList(uint16List0);
//        final bd = uint16List1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(uint16List0);

        // Encode
//        final base64 = cvt.base64.encode(bytes);
        final base64 = bytes.asBase64();
        log.debug('US.base64: "$base64"');
        final s = Uint16.toBase64(uint16List0);
        log.debug('  US.json: "$s"');
        expect(s, equals(base64));

        // Decode
        final us0 = Uint16.fromBase64(base64);
        log.debug('US.base64: $us0');
        final us1 = Uint16.fromBase64(s);
        log.debug('  US.json: $us1');
        expect(us0, equals(uint16List0));
//        expect(us0, equals(uint16List1));
        expect(us0, equals(us1));
      }
    });

    test('US fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
        //       final uint16List1 = new Uint16List.fromList(uint16List0);
//        final bd = uint16List1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(uint16List0);
        log
          ..debug('uint16List1 : $uint16List0')
          ..debug('Uint16.fromBytes(bd) ; ${Uint16.fromBytes(bytes)}');
        expect(Uint16.fromBytes(bytes), equals(uint16List0));
      }
    });

    test('US fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
        final uint16List1 = new Uint16List.fromList(uint16List0);
        final byteData = uint16List1.buffer.asByteData();
        log
          ..debug('uint16List1 : $uint16List1')
          ..debug('Uint16Base.listFromByteData(byteData):'
              ' ${Uint16.fromByteData(byteData)}');
        expect(Uint16.fromByteData(byteData), equals(uint16List1));
      }
    });
  });

  group('OWTag', () {
    test('OW hasValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
        final ow0 =
            new OWtag(PTag.kRedPaletteColorLookupTableData, uint16List0);
        expect(ow0.hasValidValues, true);
        log.debug('ow0: ${ow0.info}');
        expect(ow0.hasValidValues, true);

        log
          ..debug('ow0: $ow0, values: ${ow0.values}')
          ..debug('ow0: ${ow0.info}');
        expect(ow0[0], equals(uint16List0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(2, 3);
        log.debug('$i: uint16List0: $uint16List0');
        final ow0 =
            new OWtag(PTag.kRedPaletteColorLookupTableData, uint16List0);
        expect(ow0.hasValidValues, true);
      }
    });

    test('OW hasValidValues good values', () {
      system.throwOnError = false;
      final ow0 = new OWtag(PTag.kRedPaletteColorLookupTableData, uint16Min);
      final ow1 = new OWtag(PTag.kRedPaletteColorLookupTableData, uint16Min);
      expect(ow0.hasValidValues, true);
      expect(ow1.hasValidValues, true);

      final ow2 = new OWtag(PTag.kRedPaletteColorLookupTableData, uint16Max);
      final ow3 = new OWtag(PTag.kRedPaletteColorLookupTableData, uint16Max);
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
          new OWtag(PTag.kRedPaletteColorLookupTableData, uint16MaxPlus);
      expect(ow0, isNull);

      final ow1 =
          new OWtag(PTag.kRedPaletteColorLookupTableData, uint16MinMinus);
      expect(ow1, isNull);

      final ow2 = new OWtag(PTag.kRedPaletteColorLookupTableData, uint16MinMax);
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
        final uint16List0 = rng.uint16List(3, 4);
        final ow1 =
            new OWtag(PTag.kGreenPaletteColorLookupTableData, uint16List0);
        final uint16List1 = rng.uint16List(3, 4);
        expect(ow1.update(uint16List1).values, equals(uint16List1));
      }
    });

    test('OW update', () {
      final ow0 = new OWtag(PTag.kGreenPaletteColorLookupTableData, []);
      expect(ow0.update([63457, 64357]).values, equals([63457, 64357]));

      final ow1 = new OWtag(PTag.kRedPaletteColorLookupTableData, uint16Min);
      final ow2 = new OWtag(PTag.kRedPaletteColorLookupTableData, uint16Min);
      final ow3 = ow1.update(uint16Max);
      final ow4 = ow2.update(uint16Max);
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
        final uint16List = rng.uint16List(3, 4);
        final ow1 = new OWtag(PTag.kRedPaletteColorLookupTableData, uint16List);
        log.debug('ow1: $ow1');
        expect(owNoValues.values.isEmpty, true);
        log.debug('ow1: ${ow1.noValues}');
      }
    });

    test('OW noValues', () {
      final ow0 = new OWtag(PTag.kRedPaletteColorLookupTableData, uint16Min);
      final owNoValues = ow0.noValues;
      expect(owNoValues.values.isEmpty, true);
      log.debug('ow0:${ow0.noValues}');
    });

    test('OW copy random', () {
      for (var i = 0; i < 10; i++) {
        final uint16List = rng.uint16List(3, 4);
        final ow2 = new OWtag(PTag.kRedPaletteColorLookupTableData, uint16List);
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

      final ow2 = new OWtag(PTag.kRedPaletteColorLookupTableData, uint16Max);
      final ow3 = ow2.copy;
      expect(ow2 == ow3, true);
      expect(ow2.hashCode == ow3.hashCode, true);
    });

    test('OW hashCode and == random good values', () {
      system.throwOnError = false;
      final rng = new RNG(1);
      List<int> uint16List0;

      for (var i = 0; i < 10; i++) {
        uint16List0 = rng.uint16List(1, 1);
        final ow0 =
            new OWtag(PTag.kRedPaletteColorLookupTableData, uint16List0);
        final ow1 =
            new OWtag(PTag.kRedPaletteColorLookupTableData, uint16List0);
        log
          ..debug('uint16List0:$uint16List0, ow0.hash_code:${ow0.hashCode}')
          ..debug('uint16List0:$uint16List0, ow1.hash_code:${ow1.hashCode}');
        expect(ow0.hashCode == ow1.hashCode, true);
        expect(ow0 == ow1, true);
      }
    });

    test('OW hashCode and == random bad values', () {
      system.throwOnError = false;
      List<int> uint16List0;
      List<int> uint16List1;
      List<int> uint16List2;
      for (var i = 0; i < 10; i++) {
        uint16List1 = rng.uint16List(1, 1);
        final ow0 =
            new OWtag(PTag.kRedPaletteColorLookupTableData, uint16List0);

        final ow2 =
            new OWtag(PTag.kGreenPaletteColorLookupTableData, uint16List1);
        log.debug('uint16List1:$uint16List1 , ow2.hash_code:${ow2.hashCode}');
        expect(ow0.hashCode == ow2.hashCode, false);
        expect(ow0 == ow2, false);

        uint16List2 = rng.uint16List(2, 3);
        final ow3 =
            new OWtag(PTag.kRedPaletteColorLookupTableData, uint16List2);
        log.debug('uint16List2:$uint16List2 , ow3.hash_code:${ow3.hashCode}');
        expect(ow0.hashCode == ow3.hashCode, false);
        expect(ow0 == ow3, false);
      }
    });

    test('OW hashCode and == good values ', () {
      final ow0 = new OWtag(PTag.kRedPaletteColorLookupTableData, uint16Min);
      final ow1 = new OWtag(PTag.kRedPaletteColorLookupTableData, uint16Min);

      log
        ..debug('uint16Min:$uint16Min, ow0.hash_code:${ow0.hashCode}')
        ..debug('uint16Min:$uint16Min, ow1.hash_code:${ow1.hashCode}');
      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);
    });

    test('OW hashCode and == bad values ', () {
      final ow0 = new OWtag(PTag.kRedPaletteColorLookupTableData, uint16Min);

      final ow2 = new OWtag(PTag.kGreenPaletteColorLookupTableData, uint16Max);
      log.debug('uint16Max:$uint16Max , ow2.hash_code:${ow2.hashCode}');
      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
    });

    test('OW checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
        final ow0 =
            new OWtag(PTag.kGreenPaletteColorLookupTableData, uint16List0);
        expect(ow0.checkLength(ow0.values), true);
      }
    });

    test('OW checkLength', () {
      final ow0 = new OWtag(PTag.kGreenPaletteColorLookupTableData, uint16Max);
      expect(ow0.checkLength(ow0.values), true);
    });

    test('OW checkValues random', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
        final ow0 =
            new OWtag(PTag.kGreenPaletteColorLookupTableData, uint16List0);
        expect(ow0.checkValues(ow0.values), true);
      }
    });

    test('OW checkValues', () {
      final ow0 = new OWtag(PTag.kGreenPaletteColorLookupTableData, uint16Max);
      expect(ow0.checkValues(ow0.values), true);
    });

    test('OW valuesCopy random', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
        final ow0 =
            new OWtag(PTag.kGreenPaletteColorLookupTableData, uint16List0);
        expect(uint16List0, equals(ow0.valuesCopy));
      }
    });

    test('OW valuesCopy', () {
      final ow0 = new OWtag(PTag.kGreenPaletteColorLookupTableData, uint16Min);
      expect(uint16Min, equals(ow0.valuesCopy));
    });

    test('OW replace random', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
        final ow0 =
            new OWtag(PTag.kGreenPaletteColorLookupTableData, uint16List0);
        final uint16List1 = rng.uint16List(1, 1);
        expect(ow0.replace(uint16List1), equals(uint16List0));
        expect(ow0.values, equals(uint16List1));
      }

      final uint16List1 = rng.uint16List(1, 1);
      final ow1 =
          new OWtag(PTag.kGreenPaletteColorLookupTableData, uint16List1);
      expect(ow1.replace(<int>[]), equals(uint16List1));
      expect(ow1.values, equals(<int>[]));

      final ow2 =
          new OWtag(PTag.kGreenPaletteColorLookupTableData, uint16List1);
      expect(ow2.replace(null), equals(uint16List1));
      expect(ow2.values, equals(<int>[]));
    });

    test('OW make', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
        final ow0 = OWtag.fromValues(PTag.kEdgePointIndexList, uint16List0);
        expect(ow0.hasValidValues, true);
      }
    });

    test('OW fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
//        final uint16List1 = new Uint16List.fromList(uint16List0);
//        final uint8List1 = uint16List1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(uint16List0);
        final ow0 =
            OWtag.fromBytes(PTag.kEdgePointIndexList, bytes, bytes.length);
        expect(ow0.hasValidValues, true);
        expect(ow0.vfBytes, equals(bytes));
        expect(ow0.values is Uint16List, true);
        expect(ow0.values, equals(uint16List0));

        final uint16List1 = rng.uint16List(2, 2);
//       final uint16List2 = new Uint16List.fromList(uint16List1);
//        final uint8List2 = uint16List2.buffer.asUint8List();
        final bytes1 = new Bytes.typedDataView(uint16List1);
        final ow1 =
            OWtag.fromBytes(PTag.kEdgePointIndexList, bytes1, bytes1.length);
        expect(ow1.hasValidValues, true);
      }
    });

    test('OW fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final intList0 = rng.uint16List(1, 10);
        final bytes0 = Bytes.asciiEncode(intList0.toString());
        final ow0 = OWtag.fromBytes(PTag.kSelectorOWValue, bytes0);
        log.debug('ow0: ${ow0.info}');
        expect(ow0.hasValidValues, true);
      }
    });

    test('OW fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final intList0 = rng.uint16List(1, 10);
        final bytes0 = Bytes.asciiEncode(intList0.toString());
        final ow0 = OWtag.fromBytes(PTag.kSelectorFDValue, bytes0);
        expect(ow0, isNull);

        system.throwOnError = true;
        expect(() => OWtag.fromBytes(PTag.kSelectorFDValue, bytes0),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('OW fromB64', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
//        final uint16List1 = new Uint16List.fromList(uint16List0);
//        final uint8List11 = uint16List1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(uint16List0);
//        final base64 = cvt.base64.encode(uint8List11);
        final base64 = bytes.asBase64();
        final bytes2 = Bytes.fromBase64(base64);
        final ow0 = OWtag.fromBytes(PTag.kEdgePointIndexList, bytes2);
        expect(ow0.hasValidValues, true);
      }
    });

    test('OW checkValue good values', () {
      final uint16List0 = rng.uint16List(1, 1);
      final ow0 = new OWtag(PTag.kEdgePointIndexList, uint16List0);

      expect(ow0.checkValue(uint16Max[0]), true);
      expect(ow0.checkValue(uint16Min[0]), true);
    });

    test('OW checkValue bad values', () {
      final uint16List0 = rng.uint16List(1, 1);
      final ow0 = new OWtag(PTag.kEdgePointIndexList, uint16List0);
      expect(ow0.checkValue(uint16MaxPlus[0]), false);
      expect(ow0.checkValue(uint16MinMinus[0]), false);
    });

    test('OW view', () {
      final uint16List0 = rng.uint16List(10, 10);
      final ow0 = new OWtag(PTag.kSelectorOWValue, uint16List0);
      for (var i = 0, j = 0; i < uint16List0.length; i++, j += 2) {
        final ow1 = ow0.view(j, uint16List0.length - i);
        log.debug('ow0: ${ow0.values}, ow1: ${ow1.values}, '
            'uint16List0.sublist(i) : ${uint16List0.sublist(i)}');
        expect(ow1.values, equals(uint16List0.sublist(i)));
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

    final obowTags = <PTag>[
      PTag.kVariablePixelData,
      PTag.kDarkCurrentCounts,
      PTag.kAirCounts,
      PTag.kAudioSampleData,
      PTag.kCurveData,
      PTag.kChannelMinimumValue,
      PTag.kChannelMaximumValue,
      PTag.kWaveformPaddingValue,
      PTag.kWaveformData,
      PTag.kOverlayData
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

    test('OW isValidTag good values', () {
      system.throwOnError = false;
      expect(OW.isValidTag(PTag.kSelectorOWValue), true);
      expect(OW.isValidTag(PTag.kAudioSampleData), true);
      expect(OW.isValidTag(PTag.kGrayLookupTableData), true);

      for (var tag in owTags0) {
        expect(OW.isValidTag(tag), true);
      }
      for (var tag in obowTags) {
        final ow3 = OW.isValidTag(tag);
        expect(ow3, true);
      }
    });

    test('OW isValidTag bad values', () {
      system.throwOnError = false;
      expect(OW.isValidTag(PTag.kSelectorAEValue), false);

      system.throwOnError = true;
      expect(() => OW.isValidTag(PTag.kSelectorAEValue),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OW.isValidTag(tag), false);

        system.throwOnError = true;
        expect(() => OW.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('OW isNotValidTag good values', () {
      system.throwOnError = false;
      expect(OW.isNotValidTag(PTag.kSelectorOWValue), false);
      expect(OW.isNotValidTag(PTag.kAudioSampleData), false);
      expect(OW.isNotValidTag(PTag.kGrayLookupTableData), false);

      for (var tag in owTags0) {
        expect(OW.isNotValidTag(tag), false);
      }
      for (var tag in obowTags) {
        expect(OW.isNotValidTag(tag), false);
      }
    });

    test('OW isNotValidTag bad values', () {
      system.throwOnError = false;
      expect(OW.isNotValidTag(PTag.kSelectorAEValue), true);

      system.throwOnError = true;
      expect(() => OW.isNotValidTag(PTag.kSelectorAEValue),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OW.isNotValidTag(tag), true);

        system.throwOnError = true;
        expect(() => OW.isNotValidTag(tag),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('OW isValidVR good values', () {
      system.throwOnError = false;
      expect(OW.isValidVRIndex(kOWIndex), true);

      for (var tag in owTags0) {
        system.throwOnError = false;
        expect(OW.isValidVRIndex(tag.vrIndex), true);
      }
      for (var tag in obowTags) {
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

      for (var tag in obowTags) {
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

      for (var tag in obowTags) {
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
      const uint16MinMax = const [kUint16Min, kUint16Max];
      const uint16Min = const [kUint16Min];
      const uint16Max = const [kUint16Max];

      //VM.k1
      expect(OW.isValidValues(PTag.kPixelData, uint16Min), true);
      expect(OW.isValidValues(PTag.kBlendingLookupTableData, uint16Max), true);

      //VM.k1_n
      expect(OW.isValidValues(PTag.kSelectorOWValue, uint16Min), true);
      expect(OW.isValidValues(PTag.kSelectorOWValue, uint16Max), true);
      expect(OW.isValidValues(PTag.kSelectorOWValue, uint16MinMax), true);
    });

    test('OW isValidValues bad values', () {
      system.throwOnError = false;
      const uint16MaxPlus = const [kUint16Max + 1];
      const uint16MinMinus = const [kUint16Min - 1];

      expect(OW.isValidValues(PTag.kPixelData, uint16MaxPlus), false);
      expect(OW.isValidValues(PTag.kBlendingLookupTableData, uint16MinMinus),
          false);

      system.throwOnError = true;
      expect(
          () => OW.isValidValues(PTag.kBlendingLookupTableData, uint16MaxPlus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
      expect(
          () => OW.isValidValues(PTag.kBlendingLookupTableData, uint16MinMinus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('OW toUint16List', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
        expect(Uint16.fromList(uint16List0), uint16List0);
      }
      const uint16Min = const [kUint16Min];
      const uint16Max = const [kUint16Max];
      expect(Uint16.fromList(uint16Min), uint16Min);
      expect(Uint16.fromList(uint16Max), uint16Max);
    });

    test('OW fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
//        final uint16List1 = new Uint16List.fromList(uint16List0);
//        final bd = uint16List1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(uint16List0);
        log
          ..debug('uint16List1 : $uint16List0')
          ..debug('Uint16.fromBytes(bd) ; ${Uint16.fromBytes(bytes)}');
        expect(Uint16.fromBytes(bytes), equals(uint16List0));
      }
    });

    test('OW toBytes', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
//        final uint16List1 = new Uint16List.fromList(uint16List0);
//        final bd = uint16List1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(uint16List0);
        log
          ..debug('uint16List1 : $uint16List0')
          ..debug('Uint16.toBytes(uint16List1): '
              '${Uint16.toBytes(uint16List0)}');
        expect(Uint16.toBytes(uint16List0), equals(bytes));
      }
    });

    test('OW fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(0, i);
//        final uint16List1 = new Uint16List.fromList(uint16List0);
//        final bd = uint16List1.buffer.asUint8List();
//        final base64 = cvt.base64.encode(bd);
        final bytes = new Bytes.typedDataView(uint16List0);
        final base64 = bytes.asBase64();
        log.debug('OW.base64: "$base64"');

        final owList = Uint16.fromBase64(base64);
        log.debug('  OW.decode: $owList');
        expect(owList, equals(uint16List0));
//        expect(owList, equals(uint16List1));
      }
    });

    test('OW toBase64', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(0, i);
//        final uint16List1 = new Uint16List.fromList(uint16List0);
//        final bd = uint16List1.buffer.asUint8List();
//        final s = cvt.base64.encode(bd);
        final bytes = new Bytes.typedDataView(uint16List0);
        final base64 = bytes.asBase64();
        expect(Uint16.toBase64(uint16List0), equals(base64));
      }
    });

    test('OW encodeDecodeJsonVF', () {
      system.level = Level.info;
      for (var i = 1; i < 10; i++) {
        final uint16List0 = rng.uint16List(0, i);
//        final uint16List1 = new Uint16List.fromList(uint16List0);
//        final bd = uint16List1.buffer.asUint8List();
        // Encode
//        final base64 = cvt.base64.encode(bd);
        final bytes0 = new Bytes.typedDataView(uint16List0);
        final base64 = bytes0.asBase64();
        log.debug('OW.base64: "$base64"');
        final s = Uint16.toBase64(uint16List0);
        log.debug('  OW.json: "$s"');
        expect(s, equals(base64));

        // Decode
        final ow0 = Uint16.fromBase64(base64);
        log.debug('OW.base64: $ow0');
        final ow1 = Uint16.fromBase64(s);
        log.debug('  OW.json: $ow1');
        expect(ow0, equals(uint16List0));
//        expect(ow0, equals(uint16List1));
        expect(ow0, equals(ow1));
      }
    });

    test('OW fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
//        final uint16List1 = new Uint16List.fromList(uint16List0);
//        final bd = uint16List1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(uint16List0);
        log
          ..debug('uint16List1 : $uint16List0')
          ..debug('Uint16.fromBytes(bd) ; ${Uint16.fromBytes(bytes)}');
        expect(Uint16.fromBytes(bytes), equals(uint16List0));
      }
    });

    test('OW fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final uint16List0 = rng.uint16List(1, 1);
        final uint16List1 = new Uint16List.fromList(uint16List0);
        final byteData = uint16List1.buffer.asByteData();
        log
          ..debug('uint16List1 : $uint16List1')
          ..debug('Uint16Base.listFromByteData(byteData): '
              '${Uint16.fromByteData(byteData)}');
        expect(Uint16.fromByteData(byteData), equals(uint16List1));
      }
    });
  });
}
