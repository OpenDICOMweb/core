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
  Server.initialize(name: 'element/us_test', level: Level.info);
  final rng = RNG(1);
  global.throwOnError = false;

  group('US', () {
    const uInt16MinMax = [kUint16Min, kUint16Max];
    const uInt16Min = [kUint16Min];
    const uInt16Max = [kUint16Max];
    const uInt16MaxPlus = [kUint16Max + 1];
    const uInt16MinMinus = [kUint16Min - 1];

    test('US hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
        final e0 = UStag(PTag.kContrastFrameAveraging, vList0);
        expect(e0.hasValidValues, true);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(2, 2);
        final e0 = UStag(PTag.kTopLeftHandCornerOfLocalizerArea, vList0);
        expect(e0.hasValidValues, true);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList0[0]));
      }
    });

    test('US hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(2, 3);
        log.debug('$i: vList0: $vList0');
        final e0 = UStag(PTag.kRepresentativeFrameNumber, vList0);
        expect(e0, isNull);
      }
    });

    test('US hasValidValues good values', () {
      global.throwOnError = false;
      final e0 = UStag(PTag.kRepresentativeFrameNumber, uInt16Min);
      final e1 = UStag(PTag.kRepresentativeFrameNumber, uInt16Min);
      expect(e0.hasValidValues, true);
      expect(e1.hasValidValues, true);

      final e2 = UStag(PTag.kRepresentativeFrameNumber, uInt16Max);
      final e3 = UStag(PTag.kRepresentativeFrameNumber, uInt16Max);
      expect(e2.hasValidValues, true);
      expect(e3.hasValidValues, true);

      global.throwOnError = false;
      final e4 = UStag(PTag.kRepresentativeFrameNumber, []);
      expect(e4.hasValidValues, true);
      log.debug('e4:$e4');
      expect(e4.values, equals(<int>[]));
    });

    test('US hasValidValues bad values', () {
      final e0 = UStag(PTag.kRepresentativeFrameNumber, uInt16MaxPlus);
      expect(e0, isNull);

      final e1 = UStag(PTag.kRepresentativeFrameNumber, uInt16MinMinus);
      expect(e1, isNull);

      final e2 = UStag(PTag.kRepresentativeFrameNumber, uInt16MinMax);
      expect(e2, isNull);

      global.throwOnError = false;
      final e3 = UStag(PTag.kRepresentativeFrameNumber, uInt16Max);
      final uint32List0 = rng.uint32List(1, 1);
      e3.values = uint32List0;
      expect(e3.hasValidValues, false);

      global.throwOnError = true;
      expect(() => e3.hasValidValues,
          throwsA(const TypeMatcher<InvalidValuesError>()));

      global.throwOnError = false;
      final e4 = UStag(PTag.kRepresentativeFrameNumber, null);
      log.debug('e4: $e4');
      expect(e4, <int>[]);
      expect(e4.hasValidValues, true);
      expect(e4.values, kEmptyUint16List);
    });

    test('US update random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(3, 4);
        final e1 = UStag(PTag.kAcquisitionIndex, vList0);
        final vList1 = rng.uint16List(3, 4);
        expect(e1.update(vList1).values, equals(vList1));
      }
    });

    test('US update', () {
      final e0 = UStag(PTag.kSelectorUSValue, []);
      expect(e0.update([63457, 64357]).values, equals([63457, 64357]));

      final e1 = UStag(PTag.kFrameNumbersOfInterest, uInt16Min);
      final e2 = UStag(PTag.kFrameNumbersOfInterest, uInt16Min);
      final e3 = e1.update(uInt16Max);
      final e4 = e2.update(uInt16Max);
      expect(e1.values.first == e4.values.first, false);
      expect(e1 == e4, false);
      expect(e1 == e4, false);
      expect(e3 == e4, true);
    });

    test('US noValues random', () {
      for (var i = 0; i < 10; i++) {
        final uint16List = rng.uint16List(3, 4);
        final e1 = UStag(PTag.kFrameNumbersOfInterest, uint16List);
        log.debug('e1: ${e1.noValues}');
        expect(e1.noValues.values.isEmpty, true);
      }
    });

    test('US noValues', () {
      final e0 = UStag(PTag.kFrameNumbersOfInterest, []);
      final UStag usNoValues = e0.noValues;
      expect(usNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      final e1 = UStag(PTag.kRepresentativeFrameNumber, uInt16Min);
      final usNoValues0 = e1.noValues;
      expect(usNoValues0.values.isEmpty, true);
      log.debug('e1:${e1.noValues}');
    });

    test('US copy random', () {
      for (var i = 0; i < 10; i++) {
        final uint16List = rng.uint16List(3, 4);
        final e2 = UStag(PTag.kSelectorUSValue, uint16List);
        final UStag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('US copy', () {
      final e0 = UStag(PTag.kRepresentativeFrameNumber, []);
      final UStag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      final e2 = UStag(PTag.kRepresentativeFrameNumber, uInt16Max);
      final e3 = e2.copy;
      expect(e2 == e3, true);
      expect(e2.hashCode == e3.hashCode, true);
    });

    test('US hashCode and == good values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
        final e0 = UStag(PTag.kLargestMonochromePixelValue, vList0);
        final e1 = UStag(PTag.kLargestMonochromePixelValue, vList0);
        log
          ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
          ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('US hashCode and == bad values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
        final vList1 = rng.uint16List(1, 1);
        final e0 = UStag(PTag.kLargestMonochromePixelValue, vList0);

        final e2 = UStag(PTag.kRepresentativeFrameNumber, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rng.uint16List(2, 2);
        final e3 = UStag(PTag.kTopLeftHandCornerOfLocalizerArea, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);

        final vList3 = rng.uint16List(3, 3);
        final e4 = UStag(PTag.kRecommendedDisplayCIELabValue, vList3);
        log.debug('vList2:$vList2 , e4.hash_code:${e4.hashCode}');
        expect(e0.hashCode == e4.hashCode, false);
        expect(e0 == e4, false);

        final vList4 = rng.uint16List(4, 4);
        final e5 = UStag(PTag.kAcquisitionMatrix, vList4);
        log.debug('uint1vList46List2:$vList4 , e5.hash_code:${e5.hashCode}');
        expect(e0.hashCode == e5.hashCode, false);
        expect(e0 == e5, false);

        final vList5 = rng.uint16List(2, 3);
        final e6 = UStag(PTag.kRepresentativeFrameNumber, vList5);
        log.debug('vList5:$vList5 , e6.hash_code:${e6.hashCode}');
        expect(e0.hashCode == e6.hashCode, false);
        expect(e0 == e6, false);
      }
    });

    test('US hashCode and == good values', () {
      final e0 = UStag(PTag.kRepresentativeFrameNumber, uInt16Min);
      final e1 = UStag(PTag.kRepresentativeFrameNumber, uInt16Min);

      log
        ..debug('uInt16Min:$uInt16Min, e0.hash_code:${e0.hashCode}')
        ..debug('uInt16Min:$uInt16Min, e1.hash_code:${e1.hashCode}');
      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);
    });

    test('US hashCode and == bad values', () {
      final e0 = UStag(PTag.kRepresentativeFrameNumber, uInt16Min);
      final e2 = UStag(PTag.kRepresentativeFrameNumber, uInt16Max);
      log.debug('uInt16Max:$uInt16Max , ob2.hash_code:${e2.hashCode}');
      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);
    });

    test('US fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
        final bytes0 = Bytes.typedDataView(vList0);
        final e0 = UStag.fromBytes(PTag.kRepresentativeFrameNumber, bytes0);
        expect(e0.hasValidValues, true);
        expect(e0.vfBytes, equals(bytes0));
        expect(e0.values is Uint16List, true);
        expect(e0.values, equals(bytes0.asUint16List()));

        // Test Base64
        final bytes1 = Bytes.typedDataView(vList0);
        final e1 = UStag.fromBytes(PTag.kRepresentativeFrameNumber, bytes1);
        expect(e0 == e1, true);
        expect(e1.value, equals(e0.value));

        global.throwOnError = false;
        final vList2 = rng.uint16List(2, 2);
        final bytes2 = Bytes.typedDataView(vList2);
        final e2 = UStag.fromBytes(PTag.kRepresentativeFrameNumber, bytes2);
        log.debug('e2: $e2');
        expect(e2, isNull);
      }
    });

    test('US fromBytes', () {
      final vList1 = Uint16List.fromList(uInt16Min);
      //     final uint8List11 = vList1.buffer.asUint8List();
      final bytes0 = Bytes.typedDataView(vList1);
      final e0 = UStag.fromBytes(PTag.kRepresentativeFrameNumber, bytes0);
      expect(e0.hasValidValues, true);
      expect(e0.vfBytes, equals(bytes0));
      expect(e0.values is Uint16List, true);
      expect(e0.values, equals(vList1));
    });

    test('US fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.uint16List(1, 10);
        final bytes0 = Bytes.typedDataView(vList);
        final e0 = UStag.fromBytes(PTag.kSelectorUSValue, bytes0);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
      }
    });

    test('US checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
        final e0 = UStag(PTag.kRepresentativeFrameNumber, vList0);
        expect(e0.checkLength(e0.values), true);
      }
    });

    test('US checkLength', () {
      final e0 = UStag(PTag.kRepresentativeFrameNumber, uInt16Max);
      expect(e0.checkLength(e0.values), true);
    });

    test('US checkValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
        final e0 = UStag(PTag.kRepresentativeFrameNumber, vList0);
        expect(e0.checkValues(e0.values), true);
      }
    });

    test('US checkValues ', () {
      final e0 = UStag(PTag.kRepresentativeFrameNumber, uInt16Max);
      expect(e0.checkValues(e0.values), true);
    });

    test('US valuesCopy random', () {
      //valuesCopy
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
        final e0 = UStag(PTag.kRepresentativeFrameNumber, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('US valuesCopy', () {
      final e0 = UStag(PTag.kRepresentativeFrameNumber, uInt16Min);
      expect(uInt16Min, equals(e0.valuesCopy));
    });

    test('US replace random', () {
      final vList0 = rng.uint16List(1, 1);
      final e0 = UStag(PTag.kRepresentativeFrameNumber, vList0);
      final vList1 = rng.uint16List(1, 1);
      expect(e0.replace(vList1), equals(vList0));
    });

    test('US BASE64 random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
        final bytes0 = Bytes.typedDataView(vList0);
        final base64 = bytes0.getBase64();
        final bytes1 = Bytes.fromBase64(base64);
        final e0 = UStag.fromBytes(PTag.kRepresentativeFrameNumber, bytes1);
        expect(e0.hasValidValues, true);
      }
    });

    test('US BASE64 ', () {
      final vList1 = Int16List.fromList(uInt16Min);
      final uInt8List1 = vList1.buffer.asUint8List();
      final bytes0 = Bytes.typedDataView(uInt8List1);

      final s = bytes0.getBase64();
      final bytes1 = Bytes.fromBase64(s);
      final e0 = UStag.fromBytes(PTag.kRepresentativeFrameNumber, bytes1);
      expect(e0.hasValidValues, true);
    });

    test('US fromValues good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
        final e0 = UStag.fromValues(PTag.kRepresentativeFrameNumber, vList0);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);

        final e1 = UStag.fromValues(PTag.kRepresentativeFrameNumber, <int>[]);
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(<int>[]));
      }
    });

    test('US fromValues bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(2, 2);
        global.throwOnError = false;
        final e0 = UStag.fromValues(PTag.kRepresentativeFrameNumber, vList0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => UStag.fromValues(PTag.kRepresentativeFrameNumber, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('US checkValue good values', () {
      final vList0 = rng.uint16List(1, 1);
      final e0 = UStag(PTag.kRepresentativeFrameNumber, vList0);

      expect(e0.checkValue(uInt16Max[0]), true);
      expect(e0.checkValue(uInt16Min[0]), true);
    });

    test('US checkValue bad values', () {
      final vList0 = rng.uint16List(1, 1);
      final e0 = UStag(PTag.kRepresentativeFrameNumber, vList0);

      expect(e0.checkValue(uInt16MaxPlus[0]), false);
      expect(e0.checkValue(uInt16MinMinus[0]), false);
    });

    test('US view', () {
      final vList0 = rng.uint16List(10, 10);
      final e0 = UStag(PTag.kSelectorUSValue, vList0);
      for (var i = 0, j = 0; i < vList0.length; i++, j += 2) {
        final e1 = e0.view(j, vList0.length - i);
        log.debug('e0: ${e0.values}, e1: ${e1.values}, '
            'vList0.sublist(i) : ${vList0.sublist(i)}');
        expect(e1.values, equals(vList0.sublist(i)));
      }
    });

    test('US equal', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.uint16List(1, i);
        final bytesA = Bytes.typedDataView(vList);
        final bytesB = Bytes.typedDataView(vList);

        final vList0 = rng.uint16List(2, 2);
        final bytesC = Bytes.typedDataView(vList0);

        final e0 = UStag.fromBytes(PTag.kSelectorUSValue, bytesA);
        final equal0 = e0.equal(bytesA, bytesB);
        expect(equal0, true);

        final equal1 = e0.equal(bytesA, bytesC);
        expect(equal1, false);
      }
    });

    test('US check', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.uint16List(1, 1);
        final e0 = UStag(PTag.kRepresentativeFrameNumber, vList);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList1 = rng.uint16List(2, 2);
        final e0 = UStag(PTag.kRelativeTime, vList1);
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);
        expect(e0[0], equals(vList1[0]));
      }
    });

    test('US valuesEqual good values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.uint16List(1, i);
        final e0 = UStag(PTag.kSelectorUSValue, vList);
        final e1 = UStag(PTag.kSelectorUSValue, vList);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), true);
      }
    });

    test('US valuesEqual bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint16List(1, i);
        final vList1 = rng.uint16List(1, 1);
        final e0 = UStag(PTag.kSelectorUSValue, vList0);
        final e1 = UStag(PTag.kSelectorUSValue, vList1);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), false);
      }
    });
  });

  group('US Element', () {
    //VM.k1
    const usVM1Tags = <PTag>[
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
    const usVM2Tags = <PTag>[
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
    const usVM3Tags = <PTag>[
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
    const usVM4Tags = <PTag>[PTag.kAcquisitionMatrix];

    //VM.k1_n
    const usVM1nTags = <PTag>[
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

    const otherTags = <PTag>[
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

    test('US isValidLength VM.k1 good values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.uint16List(1, 1);
        for (var tag in usVM1Tags) {
          expect(US.isValidLength(tag, vList), true);
          expect(US.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(US.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('US isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final invalidMinVList = rng.uint16List(2, i + 1);
        for (var tag in usVM1Tags) {
          global.throwOnError = false;
          expect(US.isValidLength(tag, invalidMinVList), false);
          expect(US.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => US.isValidLength(tag, invalidMinVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
          expect(() => US.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
      global.throwOnError = false;
      expect(US.isValidLength(PTag.kFileSetConsistencyFlag, null), isNull);

      global.throwOnError = true;
      expect(() => US.isValidLength(PTag.kFileSetConsistencyFlag, null),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('US isValidLength VM.k2 good values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.uint16List(2, 2);
        for (var tag in usVM2Tags) {
          expect(US.isValidLength(tag, vList), true);

          expect(US.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(US.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('US isValidLength VM.k2 bad values', () {
      for (var i = 2; i < 10; i++) {
        final invalidMinVList = rng.uint16List(3, i + 1);
        for (var tag in usVM2Tags) {
          global.throwOnError = false;
          expect(US.isValidLength(tag, invalidMinVList), false);
          expect(US.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => US.isValidLength(tag, invalidMinVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
          expect(() => US.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('US isValidLength VM.k3 good values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.uint16List(3, 3);
        for (var tag in usVM3Tags) {
          expect(US.isValidLength(tag, vList), true);

          expect(US.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(US.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('US isValidLength VM.k3 bad values', () {
      for (var i = 3; i < 10; i++) {
        final invalidMinVList = rng.uint16List(4, i + 1);
        for (var tag in usVM3Tags) {
          global.throwOnError = false;
          expect(US.isValidLength(tag, invalidMinVList), false);
          expect(US.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => US.isValidLength(tag, invalidMinVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
          expect(() => US.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('US isValidLength VM.k4 good values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.uint16List(4, 4);
        for (var tag in usVM4Tags) {
          expect(US.isValidLength(tag, vList), true);

          expect(US.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(US.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('US isValidLength VM.k4 bad values', () {
      for (var i = 4; i < 10; i++) {
        final invalidMinVList = rng.uint16List(5, i + 1);
        for (var tag in usVM4Tags) {
          global.throwOnError = false;
          expect(US.isValidLength(tag, invalidMinVList), false);
          expect(US.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => US.isValidLength(tag, invalidMinVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
          expect(() => US.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('US isValidLength VM.k1_n good values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.uint16List(1, i);
        for (var tag in usVM1nTags) {
          expect(US.isValidLength(tag, vList), true);

          expect(US.isValidLength(tag, invalidVList.sublist(0, US.kMaxLength)),
              true);

          expect(US.isValidLength(tag, invalidVList.sublist(0, US.kMaxLength)),
              true);
        }
      }
    });

    test('US isValidTag good values', () {
      global.throwOnError = false;
      expect(US.isValidTag(PTag.kSelectorUSValue), true);
      expect(US.isValidTag(PTag.kZeroVelocityPixelValue), true);
      expect(US.isValidTag(PTag.kGrayLookupTableData), true);

      for (var tag in usVM1Tags) {
        expect(US.isValidTag(tag), true);
      }
    });

    test('US isValidTag bad values', () {
      global.throwOnError = false;
      expect(US.isValidTag(PTag.kSelectorAEValue), false);

      global.throwOnError = true;
      expect(() => US.isValidTag(PTag.kSelectorAEValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(US.isValidTag(tag), false);

        global.throwOnError = true;
        expect(() => US.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('US isValidTag good values', () {
      global.throwOnError = false;
      expect(US.isValidTag(PTag.kSelectorUSValue), true);
      expect(US.isValidTag(PTag.kZeroVelocityPixelValue), true);
      expect(US.isValidTag(PTag.kGrayLookupTableData), true);

      for (var tag in usVM1Tags) {
        expect(US.isValidTag(tag), true);
      }
    });

    test('US isValidTag bad values', () {
      global.throwOnError = false;
      expect(US.isValidTag(PTag.kSelectorAEValue), false);

      global.throwOnError = true;
      expect(() => US.isValidTag(PTag.kSelectorAEValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(US.isValidTag(tag), false);

        global.throwOnError = true;
        expect(() => US.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('US isValidVRIndex VM.k1 good values', () {
      global.throwOnError = false;
      expect(US.isValidVRIndex(kUSIndex), true);

      for (var tag in usVM1Tags) {
        global.throwOnError = false;
        expect(US.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('US isValidVRIndex VM.k1_n good values', () {
      for (var tag in usVM1Tags) {
        global.throwOnError = false;
        expect(US.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('US isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(US.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => US.isValidVRIndex(kCSIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(US.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => US.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('US isValidVRCode VM.k1 good values', () {
      global.throwOnError = false;
      expect(US.isValidVRCode(kUSCode), true);
      for (var tag in usVM1Tags) {
        expect(US.isValidVRCode(tag.vrCode), true);
      }
    });

    test('US isValidVRCode VM.k1_n good values', () {
      global.throwOnError = false;
      for (var tag in usVM1Tags) {
        expect(US.isValidVRCode(tag.vrCode), true);
      }
    });

    test('US isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(US.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => US.isValidVRCode(kAECode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(US.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => US.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('US isValidVFLength good values', () {
      expect(US.isValidVFLength(US.kMaxVFLength), true);
      expect(US.isValidVFLength(0), true);

      expect(US.isValidVFLength(US.kMaxVFLength, null, PTag.kSelectorUSValue),
          true);
    });

    test('US isValidVFLength bad values', () {
      global.throwOnError = false;
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
      global.throwOnError = false;
      const uInt16MinMax = [kUint16Min, kUint16Max];
      const uInt16MinMaxPle0 = [kUint16Min, kUint16Max, kUint8Min];
      const uInt16MinMaxPle1 = [kUint16Min, kUint16Max, kUint8Min, kUint8Max];
      const uInt16Min = [kUint16Min];
      const uInt16Max = [kUint16Max];

      //VM.k1
      expect(US.isValidValues(PTag.kWarningReason, uInt16Min), true);
      expect(US.isValidValues(PTag.kWarningReason, uInt16Max), true);

      //VM.k2
      expect(
          US.isValidValues(PTag.kLightPathFilterPassBand, uInt16MinMax), true);

      //VM.k3
      expect(
          US.isValidValues(PTag.kTextColorCIELabValue, uInt16MinMaxPle0), true);

      //VM.k4
      expect(US.isValidValues(PTag.kAcquisitionMatrix, uInt16MinMaxPle1), true);

      //VM.k1_n
      expect(US.isValidValues(PTag.kSelectorUSValue, uInt16Min), true);
      expect(US.isValidValues(PTag.kSelectorUSValue, uInt16Max), true);
      expect(US.isValidValues(PTag.kSelectorUSValue, uInt16MinMax), true);
      expect(US.isValidValues(PTag.kSelectorUSValue, uInt16MinMaxPle0), true);
    });

    test('US isValidValues bad values', () {
      global.throwOnError = false;
      const uInt16MaxPlus = [kUint16Max + 1];
      const uInt16MinMinus = [kUint16Min - 1];

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

      global.throwOnError = true;
      expect(() => US.isValidValues(PTag.kWarningReason, uInt16MaxPlus),
          throwsA(const TypeMatcher<InvalidValuesError>()));
      expect(() => US.isValidValues(PTag.kWarningReason, uInt16MinMinus),
          throwsA(const TypeMatcher<InvalidValuesError>()));

      global.throwOnError = false;
      expect(US.isValidValues(PTag.kWarningReason, null), false);
    });

    test('US isValidValues bad values length', () {
      global.throwOnError = false;

      const uInt16MinMax = [kUint16Min, kUint16Max];
      const uInt16MinMaxPle0 = [kUint16Min, kUint16Max, kUint8Min];
      const uInt16MinMaxPle1 = [kUint16Min, kUint16Max, kUint8Min, kUint8Max];
      const uInt16Min = [kUint16Min];
      const uInt16Max = [kUint16Max];

      //VM.k1
      expect(US.isValidValues(PTag.kWarningReason, uInt16MinMax), false);

      //VM.k2

      expect(US.isValidValues(PTag.kLightPathFilterPassBand, uInt16Min), false);
      expect(US.isValidValues(PTag.kLightPathFilterPassBand, uInt16Max), false);
      expect(US.isValidValues(PTag.kLightPathFilterPassBand, uInt16MinMaxPle0),
          false);

      //VM.k3
      expect(US.isValidValues(PTag.kTextColorCIELabValue, uInt16Min), false);
      expect(US.isValidValues(PTag.kTextColorCIELabValue, uInt16Max), false);
      expect(US.isValidValues(PTag.kTextColorCIELabValue, uInt16MinMaxPle1),
          false);

      //VM.k4
      expect(US.isValidValues(PTag.kAcquisitionMatrix, uInt16Min), false);
      expect(US.isValidValues(PTag.kAcquisitionMatrix, uInt16Max), false);
      expect(
          US.isValidValues(PTag.kAcquisitionMatrix, uInt16MinMaxPle0), false);

      global.throwOnError = true;
      expect(() => US.isValidValues(PTag.kWarningReason, uInt16MinMax),
          throwsA(const TypeMatcher<InvalidValuesError>()));
      expect(() => US.isValidValues(PTag.kLightPathFilterPassBand, uInt16Min),
          throwsA(const TypeMatcher<InvalidValuesError>()));
      expect(() => US.isValidValues(PTag.kTextColorCIELabValue, uInt16Min),
          throwsA(const TypeMatcher<InvalidValuesError>()));
      expect(() => US.isValidValues(PTag.kAcquisitionMatrix, uInt16Max),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('US isValidBytesArgs', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint16List(1, i);
        final vfBytes = Bytes.typedDataView(vList0);

        if (vList0.length == 1) {
          for (var tag in usVM1Tags) {
            final e0 = US.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else if (vList0.length == 2) {
          for (var tag in usVM2Tags) {
            final e0 = US.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else if (vList0.length == 3) {
          for (var tag in usVM3Tags) {
            final e0 = US.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else if (vList0.length == 4) {
          for (var tag in usVM4Tags) {
            final e0 = US.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else {
          for (var tag in usVM1nTags) {
            final e0 = US.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        }
      }
      final vList0 = rng.uint16List(1, 1);
      final vfBytes = Bytes.typedDataView(vList0);

      final e1 = US.isValidBytesArgs(null, vfBytes);
      expect(e1, false);

      final e2 = US.isValidBytesArgs(PTag.kDate, vfBytes);
      expect(e2, false);

      final e3 = US.isValidBytesArgs(PTag.kSelectorUSValue, null);
      expect(e3, false);

      global.throwOnError = true;
      expect(() => US.isValidBytesArgs(null, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => US.isValidBytesArgs(PTag.kDate, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));
    });
  });
}
