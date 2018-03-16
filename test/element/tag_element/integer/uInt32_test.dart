// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:convert' as cvt;
import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/uInt32_test', level: Level.info);
  final rng = new RNG(1);

  const uInt32MinMax = const [kUint16Min, kUint16Max];
  const uInt32Max = const [kUint32Max];
  const uInt32MaxPlus = const [kUint32Max + 1];
  const uInt32Min = const [kUint32Min];
  const uInt32MinMinus = const [kUint32Min - 1];

  group('UL', () {
    test('UL hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(1, 1);
        final ul0 = new ULtag(PTag.kPixelComponentMask, uInt32List0);
        log.debug('ul0: ${ul0.info}');
        expect(ul0.hasValidValues, true);

        log
          ..debug('ul0: $ul0, values: ${ul0.values}')
          ..debug('ul0: ${ul0.info}');
        expect(ul0[0], equals(uInt32List0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(3, 3);
        final ul0 = new ULtag(PTag.kGridDimensions, uInt32List0);
        log.debug('ul0: ${ul0.info}');
        expect(ul0.hasValidValues, true);

        log
          ..debug('ul0: $ul0, values: ${ul0.values}')
          ..debug('ul0: ${ul0.info}');
        expect(ul0[0], equals(uInt32List0[0]));
      }
    });

    test('UL hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(2, 3);
        log.debug('$i: uInt32List0: $uInt32List0');
        final ul0 = new ULtag(PTag.kPixelComponentMask, uInt32List0);
        expect(ul0, isNull);
      }
    });

    test('UL hasValidValues good values', () {
      system.throwOnError = false;
      final ul0 = new ULtag(PTag.kPixelComponentMask, uInt32Max);
      final ul1 = new ULtag(PTag.kPixelComponentMask, uInt32Max);
      expect(ul0.hasValidValues, true);
      expect(ul1.hasValidValues, true);

      final ul2 = new ULtag(PTag.kPixelComponentMask, uInt32Max);
      final ul3 = new ULtag(PTag.kPixelComponentMask, uInt32Max);
      expect(ul2.hasValidValues, true);
      expect(ul3.hasValidValues, true);

      system.throwOnError = false;
      final ul4 = new ULtag(PTag.kDataPointColumns, []);
      expect(ul4.hasValidValues, true);
      log.debug('ul4:${ul4.info}');
      expect(ul4.values, equals(<int>[]));
    });

    test('UL hasValidValues bad values', () {
      final ul0 = new ULtag(PTag.kPixelComponentMask, uInt32MaxPlus);
      expect(ul0, isNull);

      final ul1 = new ULtag(PTag.kPixelComponentMask, uInt32MinMinus);
      expect(ul1, isNull);

      final ul2 = new ULtag(PTag.kPixelComponentMask, uInt32MinMax);
      expect(ul2, isNull);

      final ul3 = new ULtag(PTag.kPixelComponentMask, uInt32Max);
      final uInt64List0 = rng.uint64List(1, 1);
      ul3.values = uInt64List0;
      expect(ul3.hasValidValues, false);

      system.throwOnError = true;
      expect(() => ul3.hasValidValues,
          throwsA(const isInstanceOf<InvalidValuesError>()));

      system.throwOnError = false;
      final ul4 = new ULtag(PTag.kDataPointColumns, null);
      log.debug('ul4: $ul4');
      expect(ul4, isNull);

      system.throwOnError = true;
      expect(() => new ULtag(PTag.kDataPointColumns, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('UL update random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(3, 4);
        final ul1 = new ULtag(PTag.kSimpleFrameList, uInt32List0);
        final uInt32List1 = rng.uint32List(3, 4);
        expect(ul1.update(uInt32List1).values, equals(uInt32List1));
      }
    });

    test('UL update', () {
      final ul0 = new ULtag(PTag.kPixelComponentMask, uInt32Min);
      final ul1 = new ULtag(PTag.kPixelComponentMask, uInt32Min);
      final ul2 = ul0.update(uInt32Max);
      final ul3 = ul1.update(uInt32Max);
      expect(ul0.values.first == ul3.values.first, false);
      expect(ul0 == ul3, false);
      expect(ul1 == ul3, false);
      expect(ul2 == ul3, true);

      final ul4 = new ULtag(PTag.kDataPointColumns, []);
      expect(ul4.update([76345748]).values, equals([76345748]));
    });

    test('UL noValues random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List = rng.uint32List(3, 4);
        final ul1 = new ULtag(PTag.kSimpleFrameList, uInt32List);
        log.debug('ul1: ${ul1.noValues}');
        expect(ul1.noValues.values.isEmpty, true);
      }
    });

    test('UL noValues', () {
      final ul0 = new ULtag(PTag.kDataPointColumns, []);
      final ULtag ulNoValues = ul0.noValues;
      expect(ulNoValues.values.isEmpty, true);
      log.debug('ul0: ${ul0.noValues}');

      final ul1 = new ULtag(PTag.kDataPointColumns, uInt32Max);
      final ulNoValues0 = ul1.noValues;
      expect(ulNoValues0.values.isEmpty, true);
      log.debug('ul1:${ul1.noValues}');
    });

    test('UL copy random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List = rng.uint32List(3, 4);
        final ul2 = new ULtag(PTag.kSimpleFrameList, uInt32List);
        final ULtag ul3 = ul2.copy;
        expect(ul3 == ul2, true);
        expect(ul3.hashCode == ul2.hashCode, true);
      }
    });

    test('UL copy', () {
      final ul0 = new ULtag(PTag.kDataPointColumns, []);
      final ULtag ul1 = ul0.copy;
      expect(ul1 == ul0, true);
      expect(ul1.hashCode == ul0.hashCode, true);

      final ul2 = new ULtag(PTag.kDataPointColumns, uInt32Max);
      final ul3 = ul2.copy;
      expect(ul2 == ul3, true);
      expect(ul2.hashCode == ul3.hashCode, true);
    });

    test('UL hashCode and == good values random', () {
      system.throwOnError = false;
      final rng = new RNG(1);
      List<int> uInt32List0;

      for (var i = 0; i < 10; i++) {
        uInt32List0 = rng.uint32List(1, 1);
        final ul0 = new ULtag(PTag.kDataPointColumns, uInt32List0);
        final ul1 = new ULtag(PTag.kDataPointColumns, uInt32List0);
        log
          ..debug('uInt32List0:$uInt32List0, ul0.hash_code:${ul0.hashCode}')
          ..debug('uInt32List0:$uInt32List0, ul1.hash_code:${ul1.hashCode}');
        expect(ul0.hashCode == ul1.hashCode, true);
        expect(ul0 == ul1, true);
      }
    });
    test('UL hashCode and == bad values random', () {
      system.throwOnError = false;
      List<int> uInt32List0;
      List<int> uInt32List1;
      List<int> uInt32List2;
      List<int> uInt32List3;
      List<int> uInt32List4;

      for (var i = 0; i < 10; i++) {
        uInt32List0 = rng.uint32List(1, 1);
        final ul0 = new ULtag(PTag.kDataPointColumns, uInt32List0);
        uInt32List1 = rng.uint32List(1, 1);
        final ul2 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32List1);
        log.debug('uInt32List1:$uInt32List1 , ul2.hash_code:${ul2.hashCode}');
        expect(ul0.hashCode == ul2.hashCode, false);
        expect(ul0 == ul2, false);

        uInt32List2 = rng.uint32List(3, 3);
        final ul3 = new ULtag(PTag.kGridDimensions, uInt32List2);
        log.debug('uInt32List2:$uInt32List2 , ul3.hash_code:${ul3.hashCode}');
        expect(ul0.hashCode == ul3.hashCode, false);
        expect(ul0 == ul3, false);

        uInt32List3 = rng.uint32List(1, 9);
        final ul4 = new ULtag(PTag.kReferencedSamplePositions, uInt32List3);
        log.debug('uInt32List3:$uInt32List3 , us4.hash_code:${ul4.hashCode}');
        expect(ul0.hashCode == ul4.hashCode, false);
        expect(ul0 == ul4, false);

        uInt32List4 = rng.uint32List(2, 3);
        final ul5 = new ULtag(PTag.kDataPointColumns, uInt32List4);
        log.debug('uInt32List4:$uInt32List4 , ul5.hash_code:${ul5.hashCode}');
        expect(ul0.hashCode == ul5.hashCode, false);
        expect(ul0 == ul5, false);
      }
    });

    test('UL hashCode and == good values', () {
      final ul0 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32Max);
      final ul1 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32Max);

      log
        ..debug('uInt32Max:$uInt32Max, ul0.hash_code:${ul0.hashCode}')
        ..debug('uInt32Max:$uInt32Max, ul1.hash_code:${ul1.hashCode}');
      expect(ul0.hashCode == ul1.hashCode, true);
      expect(ul0 == ul1, true);
    });

    test('UL hashCode and == bad values', () {
      final ul0 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32Max);

      final ul2 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32Min);
      log.debug('uInt32Min:$uInt32Min , ul2.hash_code:${ul2.hashCode}');
      expect(ul0.hashCode == ul2.hashCode, false);
      expect(ul0 == ul2, false);
    });

    test('UL fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32List0);
        final uInt8ListV11 = uInt32ListV1.buffer.asUint8List();
        final ul0 =
            ULtag.fromUint8List(PTag.kNumberOfWaveformSamples, uInt8ListV11);
        expect(ul0.hasValidValues, true);
        expect(ul0.vfBytes, equals(uInt8ListV11));
        expect(ul0.values is Uint32List, true);
        expect(ul0.values, equals(uInt32ListV1));

        // Test Base64
        final base64 = cvt.base64.encode(uInt8ListV11);
        final ul1 = ULtag.fromBase64(PTag.kNumberOfWaveformSamples, base64);
        expect(ul0 == ul1, true);
        expect(ul0.value, equals(ul1.value));

        final uInt32List1 = rng.uint32List(2, 2);
        final uInt32ListV2 = new Uint32List.fromList(uInt32List1);
        final uInt8ListV12 = uInt32ListV2.buffer.asUint8List();
        final ul2 =
            ULtag.fromUint8List(PTag.kNumberOfWaveformSamples, uInt8ListV12);
        expect(ul2.hasValidValues, false);
      }
    });

    test('UL fromBytes', () {
      final uInt32ListV1 = new Uint32List.fromList(uInt32Max);
      final uInt8ListV11 = uInt32ListV1.buffer.asUint8List();
      final ul5 = ULtag.fromUint8List(PTag.kNumberOfWaveformSamples, uInt8ListV11);
      expect(ul5.hasValidValues, true);
      expect(ul5.vfBytes, equals(uInt8ListV11));
      expect(ul5.values is Uint32List, true);
      expect(ul5.values, equals(uInt32ListV1));
    });

    test('UL checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(1, 1);
        final ul0 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32List0);
        expect(ul0.checkLength(ul0.values), true);
      }
    });

    test('UL checkLength', () {
      final ul0 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32Max);
      expect(ul0.checkLength(ul0.values), true);
    });

    test('UL checkValues random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(1, 1);
        final ul0 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32List0);
        expect(ul0.checkValues(ul0.values), true);
      }
    });

    test('UL checkValues', () {
      final ul0 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32Max);
      expect(ul0.checkValues(ul0.values), true);
    });

    test('UL valuesCopy random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(1, 1);
        final ul0 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32List0);
        expect(uInt32List0, equals(ul0.valuesCopy));
      }
    });

    test('UL valuesCopy', () {
      final ul0 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32Max);
      expect(uInt32Max, equals(ul0.valuesCopy));
    });

    test('UL replace random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(1, 1);
        final ul0 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32List0);
        final uInt32List1 = rng.uint32List(1, 1);
        expect(ul0.replace(uInt32List1), equals(uInt32List0));
        expect(ul0.values, equals(uInt32List1));
      }

      final uInt32List1 = rng.uint32List(1, 1);
      final ul1 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32List1);
      expect(ul1.replace(<int>[]), equals(uInt32List1));
      expect(ul1.values, equals(<int>[]));

      final ul2 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32List1);
      expect(ul2.replace(null), equals(uInt32List1));
      expect(ul2.values, equals(<int>[]));
    });

    test('UL BASE64 random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final uInt32ListV11 = uInt32ListV1.buffer.asUint8List();
        final base64 = cvt.base64.encode(uInt32ListV11);
        final ul0 = ULtag.fromBase64(PTag.kNumberOfWaveformSamples, base64);
        expect(ul0.hasValidValues, true);
      }
    });

    test('UL BASE64', () {
      final uInt32ListV1 = new Uint32List.fromList(uInt32Max);
      final uInt32ListV11 = uInt32ListV1.buffer.asUint8List();
      final base64 = cvt.base64.encode(uInt32ListV11);
      final ul0 = ULtag.fromBase64(PTag.kNumberOfWaveformSamples, base64);
      expect(ul0.hasValidValues, true);
    });

    test('UL make good values', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final make0 = ULtag.make(PTag.kNumberOfWaveformSamples, uInt32list0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);

        final make1 = ULtag.make(PTag.kNumberOfWaveformSamples, <int>[]);
        expect(make1.hasValidValues, true);
        expect(make1.values, equals(<int>[]));
      }
    });

    test('UL make bad values', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(2, 2);
        system.throwOnError = false;
        final make0 = ULtag.make(PTag.kNumberOfWaveformSamples, uInt32list0);
        expect(make0, isNull);

        system.throwOnError = true;
        expect(() => ULtag.make(PTag.kNumberOfWaveformSamples, uInt32list0),
            throwsA(const isInstanceOf<InvalidValuesLengthError>()));
      }
    });

    test('UL fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final uInt32ListV11 = uInt32ListV1.buffer.asUint8List();
        final ul0 =
            ULtag.fromUint8List(PTag.kNumberOfWaveformSamples, uInt32ListV11);
        expect(ul0.hasValidValues, true);
        expect(ul0.vfBytes, equals(uInt32ListV11));
        expect(ul0.values is Uint32List, true);
        expect(ul0.values, equals(uInt32ListV1));
      }
    });

    test('UL fromB64', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final uInt32ListV11 = uInt32ListV1.buffer.asUint8List();
        final base64 = cvt.base64.encode(uInt32ListV11);
        final ul0 = ULtag.fromBase64(PTag.kNumberOfWaveformSamples, base64);
        expect(ul0.hasValidValues, true);
      }
    });

    test('UL checkValue good values', () {
      final uInt32list0 = rng.uint32List(1, 1);
      final ul0 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32list0);

      expect(ul0.checkValue(uInt32Max[0]), true);
      expect(ul0.checkValue(uInt32Min[0]), true);
    });

    test('UL checkValue good values', () {
      final uInt32list0 = rng.uint32List(1, 1);
      final ul0 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32list0);
      expect(ul0.checkValue(uInt32MaxPlus[0]), false);
      expect(ul0.checkValue(uInt32MinMinus[0]), false);
    });

    test('UL view', () {
      system.throwOnError = false;
      final uInt32list0 = rng.uint32List(10, 10);
      final ul0 = new ULtag(PTag.kSelectorULValue, uInt32list0);
      for (var i = 0, j = 0; i < uInt32list0.length; i++, j += 4) {
        final ul1 = ul0.view(j, uInt32list0.length - i);
        log.debug('ul0: ${ul0.values}, ul1: ${ul1.values}, '
            'uInt32list0.sublist(i) : ${uInt32list0.sublist(i)}');
        expect(ul1.values, equals(uInt32list0.sublist(i)));
      }
    });
  });

  group('UL Element', () {
    //VM.k1
    const ulTags0 = const <PTag>[
      PTag.kMRDRDirectoryRecordOffset,
      PTag.kNumberOfReferences,
      PTag.kLengthToEnd,
      PTag.kTriggerSamplePosition,
      PTag.kRegionFlags,
      PTag.kPulseRepetitionFrequency,
      PTag.kDopplerSampleVolumeXPositionRetired,
      PTag.kDopplerSampleVolumeYPositionRetired,
      PTag.kTMLinePositionX0Retired,
      PTag.kTMLinePositionY0Retired,
      PTag.kTMLinePositionX1Retired,
      PTag.kTMLinePositionY1Retired,
      PTag.kPixelComponentMask,
      PTag.kNumberOfTableEntries,
      PTag.kSpectroscopyAcquisitionPhaseRows,
      PTag.kASLBolusCutoffDelayTime,
      PTag.kDataPointRows,
      PTag.kDataPointColumns,
      PTag.kNumberOfWaveformSamples,
      PTag.kNumberOfSurfacePoints,
      PTag.kGroup4Length,
      PTag.kGroup8Length,
      PTag.kGroup10Length,
      PTag.kGroup12Length
    ];

    //VM.k3
    const ulTags1 = const <PTag>[
      PTag.kGridDimensions,
    ];

    //VM.k1_n
    const ulTags2 = const <PTag>[
      PTag.kSimpleFrameList,
      PTag.kReferencedSamplePositions,
      PTag.kRationalDenominatorValue,
      PTag.kReferencedContentItemIdentifier,
      PTag.kHistogramData,
      PTag.kSelectorULValue,
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

    final invalidVList = rng.uint32List(UL.kMaxLength + 1, UL.kMaxLength + 1);

    test('UL isValidVListLength VM.k1 good values', () {
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final validMinVList = rng.uint32List(1, 1);
        for (var tag in ulTags0) {
          expect(UL.isValidVListLength(tag, validMinVList), true);
          expect(
              SS.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              SS.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('UL isValidVListLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        system.throwOnError = false;
        final validMinVList = rng.uint32List(2, i + 1);
        for (var tag in ulTags0) {
          system.throwOnError = false;
          expect(UL.isValidVListLength(tag, validMinVList), false);
          expect(UL.isValidVListLength(tag, invalidVList), false);

          system.throwOnError = true;
          expect(() => UL.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesLengthError>()));
          expect(() => UL.isValidVListLength(tag, invalidVList),
              throwsA(const isInstanceOf<InvalidValuesLengthError>()));
        }
      }
    });

    test('UL isValidVListLength VM.k3 good values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rng.uint32List(3, 3);
        for (var tag in ulTags1) {
          expect(UL.isValidVListLength(tag, validMinVList), true);
          expect(
              SS.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              SS.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('UL isValidVListLength VM.k3 bad values', () {
      for (var i = 3; i < 10; i++) {
        final validMinVList = rng.uint32List(4, i + 1);
        for (var tag in ulTags1) {
          system.throwOnError = false;
          expect(UL.isValidVListLength(tag, validMinVList), false);
          expect(UL.isValidVListLength(tag, invalidVList), false);

          system.throwOnError = true;
          expect(() => UL.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesLengthError>()));
          expect(() => UL.isValidVListLength(tag, invalidVList),
              throwsA(const isInstanceOf<InvalidValuesLengthError>()));
        }
      }
    });

    test('UL isValidVListLength VM.k1_n good values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rng.uint32List(1, i);
        for (var tag in ulTags2) {
          expect(UL.isValidVListLength(tag, validMinVList), true);

          expect(
              UL.isValidVListLength(
                  tag, invalidVList.sublist(0, UL.kMaxLength)),
              true);
        }
      }
    });

    test('UL isValidTag good values', () {
      system.throwOnError = false;
      expect(UL.isValidTag(PTag.kSelectorULValue), true);

      for (var tag in ulTags0) {
        expect(UL.isValidTag(tag), true);
      }
    });

    test('UL isValidTag bad values', () {
      system.throwOnError = false;
      expect(UL.isValidTag(PTag.kSelectorUSValue), false);

      system.throwOnError = true;
      expect(() => UL.isValidTag(PTag.kSelectorUSValue),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(UL.isValidTag(tag), false);

        system.throwOnError = true;
        expect(() => UL.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UL isNotValidTag good values', () {
      system.throwOnError = false;
      expect(UL.isNotValidTag(PTag.kSelectorULValue), false);

      for (var tag in ulTags0) {
        expect(UL.isNotValidTag(tag), false);
      }
    });

    test('UL isNotValidTag bad values', () {
      system.throwOnError = false;
      expect(UL.isNotValidTag(PTag.kSelectorUSValue), true);

      system.throwOnError = true;
      expect(() => UL.isNotValidTag(PTag.kSelectorUSValue),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(UL.isNotValidTag(tag), true);

        system.throwOnError = true;
        expect(() => UL.isNotValidTag(tag),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UL isValidVR good values', () {
      system.throwOnError = false;
      expect(UL.isValidVRIndex(kULIndex), true);

      for (var tag in ulTags0) {
        system.throwOnError = false;
        expect(UL.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('UL isValidVR bad values', () {
      expect(UL.isValidVRIndex(kAEIndex), false);
      system.throwOnError = true;
      expect(() => UL.isValidVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(UL.isValidVRIndex(tag.vrIndex), false);

        system.throwOnError = true;
        expect(() => UL.isValidVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UL checkVR good values', () {
      system.throwOnError = false;
      expect(UL.checkVRIndex(kULIndex), kULIndex);

      for (var tag in ulTags0) {
        system.throwOnError = false;
        expect(UL.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('UL checkVR bad values', () {
      expect(UL.checkVRIndex(kAEIndex), isNull);
      system.throwOnError = true;
      expect(() => UL.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));
      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(UL.checkVRIndex(tag.vrIndex), isNull);

        system.throwOnError = true;
        expect(() => UL.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UL isValidVRIndex good values', () {
      system.throwOnError = false;
      expect(UL.isValidVRIndex(kULIndex), true);

      for (var tag in ulTags0) {
        system.throwOnError = false;
        expect(UL.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('UL isValidVRIndex bad values', () {
      expect(UL.isValidVRIndex(kCSIndex), false);

      system.throwOnError = true;
      expect(() => UL.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(UL.isValidVRIndex(tag.vrIndex), false);

        system.throwOnError = true;
        expect(() => UL.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UL isValidVRCode good values', () {
      system.throwOnError = false;
      expect(UL.isValidVRCode(kULCode), true);

      for (var tag in ulTags0) {
        expect(UL.isValidVRCode(tag.vrCode), true);
      }
    });

    test('UL isValidVRCode good values', () {
      expect(UL.isValidVRCode(kAECode), false);

      system.throwOnError = true;
      expect(() => UL.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));
      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(UL.isValidVRCode(tag.vrCode), false);

        system.throwOnError = true;
        expect(() => UL.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UL isValidVFLength good values', () {
      expect(UL.isValidVFLength(UL.kMaxVFLength), true);
      expect(UL.isValidVFLength(0), true);
    });

    test('UL isValidVFLength bad values', () {
      expect(UL.isValidVFLength(UL.kMaxVFLength + 1), false);
      expect(UL.isValidVFLength(-1), false);
    });

    test('UL isValidValue good values', () {
      expect(UL.isValidValue(UL.kMinValue), true);
      expect(UL.isValidValue(UL.kMaxValue), true);
    });

    test('UL isValidValue bad values', () {
      expect(UL.isValidValue(UL.kMinValue - 1), false);
      expect(UL.isValidValue(UL.kMaxValue + 1), false);
    });

    test('UL isValidValues good values', () {
      system.throwOnError = false;
      const uInt32MinMax = const [kUint32Min, kUint32Max, kUint16Max];
      const uInt32Min = const [kUint32Min];
      const uInt32Max = const [kUint32Max];

      //VM.k1
      expect(UL.isValidValues(PTag.kLengthToEnd, uInt32Min), true);
      expect(UL.isValidValues(PTag.kLengthToEnd, uInt32Max), true);

      //VM.k3
      expect(UL.isValidValues(PTag.kGridDimensions, uInt32MinMax), true);

      //VM.k1_n
      expect(UL.isValidValues(PTag.kSelectorULValue, uInt32MinMax), true);
      expect(UL.isValidValues(PTag.kSelectorULValue, uInt32Max), true);
      expect(UL.isValidValues(PTag.kSelectorULValue, uInt32Min), true);
    });

    test('UL isValidValues bad values', () {
      system.throwOnError = false;
      const uInt32MaxPlus = const [kUint32Max + 1];
      const uInt32MinMinus = const [kUint32Min - 1];

      //VM.k1
      expect(UL.isValidValues(PTag.kLengthToEnd, uInt32MaxPlus), false);
      expect(UL.isValidValues(PTag.kLengthToEnd, uInt32MinMinus), false);

      //VM.k3
      expect(UL.isValidValues(PTag.kGridDimensions, uInt32MaxPlus), false);

      system.throwOnError = true;
      expect(() => UL.isValidValues(PTag.kLengthToEnd, uInt32MaxPlus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
      expect(() => UL.isValidValues(PTag.kLengthToEnd, uInt32MinMinus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('UL isValidValues bad values length', () {
      system.throwOnError = false;
      const uInt32MinMax = const [kUint32Min, kUint32Max, kUint16Max];
      const uInt32MinMaxPlus = const [
        kUint32Min,
        kUint32Max,
        kUint16Max,
        kUint16Min
      ];

      const uInt32Min = const [kUint32Min];
      const uInt32Max = const [kUint32Max];

      //VM.k1
      expect(UL.isValidValues(PTag.kLengthToEnd, uInt32MinMax), false);

      //VM.k3
      expect(UL.isValidValues(PTag.kGridDimensions, uInt32Min), false);
      expect(UL.isValidValues(PTag.kGridDimensions, uInt32Max), false);
      expect(UL.isValidValues(PTag.kGridDimensions, uInt32MinMaxPlus), false);

      system.throwOnError = true;
      expect(() => UL.isValidValues(PTag.kLengthToEnd, uInt32MinMax),
          throwsA(const isInstanceOf<InvalidValuesLengthError>()));
      expect(() => UL.isValidValues(PTag.kGridDimensions, uInt32Min),
          throwsA(const isInstanceOf<InvalidValuesLengthError>()));
      expect(() => UL.isValidValues(PTag.kGridDimensions, uInt32MinMaxPlus),
          throwsA(const isInstanceOf<InvalidValuesLengthError>()));
    });

    test('UL fromList', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        expect(Uint32.fromList(uInt32list0), uInt32list0);
      }
      const uInt32Min = const [kUint32Min];
      const uInt32Max = const [kUint32Max];
      expect(Uint32.fromList(uInt32Min), uInt32Min);
      expect(Uint32.fromList(uInt32Max), uInt32Max);
    });

    test('UL fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final bd = uInt32ListV1.buffer.asUint8List();
        log
          ..debug('uInt32ListV1 : $uInt32ListV1')
          ..debug('Uint32Base.fromUint8List(bd) ; ${Uint32.fromUint8List(bd)}');
        expect(Uint32.fromUint8List(bd), equals(uInt32ListV1));
      }
    });

    test('UL toBytes', () {
      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final bd = uInt32ListV1.buffer.asUint8List();
        log
          ..debug('uInt32ListV1 : $uInt32ListV1')
          ..debug('Uint32Base.toBytes(uInt32ListV1): '
              '${Uint32.toBytes(uInt32ListV1)}');
        expect(Uint32.toBytes(uInt32ListV1), equals(bd));
      }

      const uInt32Max = const [kUint32Max];
      final uInt32ListV1 = new Uint32List.fromList(uInt32Max);
      final uInt32List = uInt32ListV1.buffer.asUint8List();
      expect(Uint32.toBytes(uInt32Max), uInt32List);

      const uInt64Max = const [kUint64Max];
      expect(Uint32.toBytes(uInt64Max).isEmpty, true);

      system.throwOnError = true;
      expect(() => Uint32.toBytes(uInt64Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('Uint32Base toByteData good values', () {
//      system.level = Level.debug;
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final uInt32list0 = rng.uint32List(1, 1);
        final bd0 = uInt32list0.buffer.asByteData();
        final lBd0 = Uint32.toByteData(uInt32list0);
        log.debug('lBd0: ${lBd0.buffer.asUint8List()}, bd0: ${bd0.buffer
            .asUint8List()}');
        expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd0.buffer == bd0.buffer, true);

        final lBd1 = Uint32.toByteData(uInt32list0, check: false);
        log.debug('lBd3: ${lBd1.buffer.asUint8List()}, '
            'bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd1.buffer == bd0.buffer, true);
      }

      const uint32Max = const [kUint32Max];
      final uint32List = new Uint32List.fromList(uint32Max);
      final bd1 = uint32List.buffer.asByteData();
      final lBd2 = Uint32.toByteData(uint32List);
      log.debug('bd: ${bd1.buffer.asUint8List()}, '
          'lBd2: ${lBd2.buffer.asUint8List()}');
      expect(lBd2.buffer.asUint8List(), equals(bd1.buffer.asUint8List()));
      expect(lBd2.buffer == bd1.buffer, true);
    });

    test('Uint32Base toByteData bad values', () {
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final uInt32list0 = rng.uint32List(1, 1);
        final bd0 = uInt32list0.buffer.asByteData();
        final lBd1 = Uint32.toByteData(uInt32list0, asView: false);
        log.debug('lBd1: ${lBd1.buffer.asUint8List()}, '
            'bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd1.buffer == bd0.buffer, false);

        final lBd2 =
            Uint32.toByteData(uInt32list0, asView: false, check: false);
        log.debug('lBd2: ${lBd2.buffer.asUint8List()}, '
            'bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd2.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd2.buffer == bd0.buffer, false);
      }

      system.throwOnError = false;
      final uInt32Max = const <int>[kUint32Max + 1];
      expect(Uint32.toByteData(uInt32Max), isNull);

      system.throwOnError = true;
      expect(() => Uint32.toByteData(uInt32Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('UL fromBase64', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(0, i);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final bd = uInt32ListV1.buffer.asUint8List();
        final base64 = cvt.base64.encode(bd);
        log.debug('UL.base64: "$base64"');

        final ulList = Uint32.fromBase64(base64);
        log.debug('  UL.decode: $ulList');
        expect(ulList, equals(uInt32list0));
        expect(ulList, equals(uInt32ListV1));
      }
    });

    test('UL toBase64', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(0, i);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final bd = uInt32ListV1.buffer.asUint8List();
        final s = cvt.base64.encode(bd);
        expect(Uint32.toBase64(uInt32list0), equals(s));
      }
    });

    test('UL encodeDecodeJsonVF', () {
//      system.level = Level.info;
      for (var i = 1; i < 10; i++) {
        final uInt32list0 = rng.uint32List(0, i);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final bd = uInt32ListV1.buffer.asUint8List();

        // Encode
        final base64 = cvt.base64.encode(bd);
        log.debug('UL.base64: "$base64"');
        final s = Uint32.toBase64(uInt32list0);
        log.debug('  UL.json: "$s"');
        expect(s, equals(base64));

        // Decode
        final ul0 = Uint32.fromBase64(base64);
        log.debug('UL.base64: $ul0');
        final ul1 = Uint32.fromBase64(s);
        log.debug('  UL.json: $ul1');
        expect(ul0, equals(uInt32list0));
        expect(ul0, equals(uInt32ListV1));
        expect(ul0, equals(ul1));
      }
    });

    test('UL fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final bd = uInt32ListV1.buffer.asUint8List();
        log
          ..debug('uInt32ListV1 : $uInt32ListV1')
          ..debug('Uint32Base.fromUint8List(bd) ; ${Uint32.fromUint8List(bd)}');
        expect(Uint32.fromUint8List(bd), equals(uInt32ListV1));
      }
    });

    test('UL fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final byteData = uInt32ListV1.buffer.asByteData();
        log
          ..debug('uInt32ListV1 : $uInt32ListV1')
          ..debug('Uint32Base.fromByteData(byteData): '
              '${Uint32.fromByteData(byteData)}');
        expect(Uint32.fromByteData(byteData), equals(uInt32ListV1));
      }
    });
  });

  group('AT', () {
    test('AT hasValidValues good values random', () {
      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(1, 1);
        final at0 = new ATtag(PTag.kOriginalImageIdentification, uInt32List0);
        log.debug('at0: ${at0.info}');
        expect(at0.hasValidValues, true);

        log
          ..debug('at0: $at0, values: ${at0.values}')
          ..debug('at0: ${at0.info}');
        expect(at0[0], equals(uInt32List0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(1, 10);
        final at0 = new ATtag(PTag.kSelectorATValue, uInt32List0);
        log.debug('at0: ${at0.info}');
        expect(at0.hasValidValues, true);

        log
          ..debug('at0: $at0, values: ${at0.values}')
          ..debug('at0: ${at0.info}');
        expect(at0[0], equals(uInt32List0[0]));
      }
    });

    test('AT hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(2, 3);
        log.debug('$i: uInt32List0: $uInt32List0');
        final at0 = new ATtag(PTag.kDimensionIndexPointer, uInt32List0);
        expect(at0, isNull);
      }
    });

    test('AT hasValidValues good values', () {
      system.throwOnError = false;
      final at0 = new ATtag(PTag.kDimensionIndexPointer, uInt32Max);
      final at1 = new ATtag(PTag.kDimensionIndexPointer, uInt32Max);
      expect(at0.hasValidValues, true);
      expect(at1.hasValidValues, true);

      final at2 = new ATtag(PTag.kDimensionIndexPointer, uInt32Max);
      final at3 = new ATtag(PTag.kDimensionIndexPointer, uInt32Max);
      expect(at2.hasValidValues, true);
      expect(at3.hasValidValues, true);

      system.throwOnError = false;
      final at4 = new ATtag(PTag.kFunctionalGroupPointer, []);
      expect(at4.hasValidValues, true);
      log.debug('at4:${at4.info}');
      expect(at4.values, equals(<int>[]));
    });

    test('AT hasValidValues bad values', () {
      final at0 = new ATtag(PTag.kDimensionIndexPointer, uInt32MaxPlus);
      expect(at0, isNull);

      final at1 = new ATtag(PTag.kDimensionIndexPointer, uInt32MinMinus);
      expect(at1, isNull);

      final at2 = new ATtag(PTag.kDimensionIndexPointer, uInt32MinMax);
      expect(at2, isNull);

      final at3 = new ATtag(PTag.kDimensionIndexPointer, uInt32Max);
      final uInt64List0 = rng.uint64List(1, 1);
      at3.values = uInt64List0;
      expect(at3.hasValidValues, false);

      system.throwOnError = true;
      expect(() => at3.hasValidValues,
          throwsA(const isInstanceOf<InvalidValuesError>()));

      system.throwOnError = false;
      final at4 = new ATtag(PTag.kFunctionalGroupPointer, null);
      log.debug('at4: $at4');
      expect(at4, isNull);

      system.throwOnError = true;
      expect(() => new ATtag(PTag.kFunctionalGroupPointer, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('AT update random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(3, 4);
        final at1 = new ATtag(PTag.kSelectorATValue, uInt32List0);
        final uInt32List1 = rng.uint32List(3, 4);
        expect(at1.update(uInt32List1).values, equals(uInt32List1));
      }
    });

    test('AT update', () {
      final at0 = new ATtag(PTag.kSelectorATValue, uInt32Min);
      final at1 = new ATtag(PTag.kSelectorATValue, uInt32Min);
      final at2 = at0.update(uInt32Max);
      final at3 = at1.update(uInt32Max);
      expect(at0.values.first == at3.values.first, false);
      expect(at0 == at3, false);
      expect(at1 == at3, false);
      expect(at2 == at3, true);

      final at4 = new ATtag(PTag.kSelectorATValue, []);
      expect(at4.update([76345748, 64357898]).values,
          equals([76345748, 64357898]));
    });

    test('AT noValues random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List = rng.uint32List(3, 4);
        final at1 = new ATtag(PTag.kSelectorATValue, uInt32List);
        log.debug('at1: ${at1.noValues}');
        expect(at1.noValues.values.isEmpty, true);
      }
    });

    test('AT noValues', () {
      final at0 = new ATtag(PTag.kSelectorATValue, []);
      final ATtag atNoValues = at0.noValues;
      expect(atNoValues.values.isEmpty, true);
      log.debug('at0: ${at0.noValues}');

      final at1 = new ATtag(PTag.kFunctionalGroupPointer, uInt32Max);
      final atNoValues0 = at1.noValues;
      expect(atNoValues0.values.isEmpty, true);
      log.debug('at1:${at1.noValues}');
    });

    test('AT copy random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List = rng.uint32List(3, 4);
        final at2 = new ATtag(PTag.kSelectorATValue, uInt32List);
        final ATtag at3 = at2.copy;
        expect(at3 == at2, true);
        expect(at3.hashCode == at2.hashCode, true);
      }
    });

    test('AT copy', () {
      final at0 = new ATtag(PTag.kFunctionalGroupPointer, []);
      final ATtag at1 = at0.copy;
      expect(at1 == at0, true);
      expect(at1.hashCode == at0.hashCode, true);

      final at2 = new ATtag(PTag.kFunctionalGroupPointer, uInt32Max);
      final at3 = at2.copy;
      expect(at2 == at3, true);
      expect(at2.hashCode == at3.hashCode, true);
    });

    test('AT hashCode and == random good values', () {
      system.throwOnError = false;
      final rng = new RNG(1);
      List<int> uInt32List0;

      for (var i = 0; i < 10; i++) {
        uInt32List0 = rng.uint32List(1, 1);
        final at0 = new ATtag(PTag.kFunctionalGroupPointer, uInt32List0);
        final at1 = new ATtag(PTag.kFunctionalGroupPointer, uInt32List0);
        log
          ..debug('uInt32List0:$uInt32List0, at0.hash_code:${at0.hashCode}')
          ..debug('uInt32List0:$uInt32List0, at1.hash_code:${at1.hashCode}');
        expect(at0.hashCode == at1.hashCode, true);
        expect(at0 == at1, true);
      }
    });

    test('AT hashCode and == random bad values', () {
      system.throwOnError = false;
      final rng = new RNG(1);

      List<int> uInt32List0;
      List<int> uInt32List1;
      List<int> uInt32List2;
      List<int> uInt32List3;

      for (var i = 0; i < 10; i++) {
        uInt32List0 = rng.uint32List(1, 1);
        final at0 = new ATtag(PTag.kFunctionalGroupPointer, uInt32List0);
        uInt32List1 = rng.uint32List(1, 1);
        final at2 = new ATtag(PTag.kDimensionIndexPointer, uInt32List1);
        log.debug('uInt32List1:$uInt32List1 , at2.hash_code:${at2.hashCode}');
        expect(at0.hashCode == at2.hashCode, false);
        expect(at0 == at2, false);

        uInt32List2 = rng.uint32List(1, 9);
        final at3 = new ATtag(PTag.kOriginalImageIdentification, uInt32List2);
        log.debug('uInt32List2:$uInt32List2 , at3.hash_code:${at3.hashCode}');
        expect(at0.hashCode == at3.hashCode, false);
        expect(at0 == at3, false);

        uInt32List3 = rng.uint32List(2, 3);
        final at4 = new ATtag(PTag.kFunctionalGroupPointer, uInt32List3);
        log.debug('uInt32List3:$uInt32List3 , at4.hash_code:${at4.hashCode}');
        expect(at0.hashCode == at4.hashCode, false);
        expect(at0 == at4, false);
      }
    });

    test('AT hashCode and == good values', () {
      final at0 = new ATtag(PTag.kOriginalImageIdentification, uInt32Max);
      final at1 = new ATtag(PTag.kOriginalImageIdentification, uInt32Max);

      log
        ..debug('uInt32Max:$uInt32Max, at0.hash_code:${at0.hashCode}')
        ..debug('uInt32Max:$uInt32Max, at1.hash_code:${at1.hashCode}');
      expect(at0.hashCode == at1.hashCode, true);
      expect(at0 == at1, true);
    });

    test('AT hashCode and == bad values', () {
      final at0 = new ATtag(PTag.kOriginalImageIdentification, uInt32Max);

      final at2 = new ATtag(PTag.kOriginalImageIdentification, uInt32Min);
      log.debug('uInt32Min:$uInt32Min , at2.hash_code:${at2.hashCode}');
      expect(at0.hashCode == at2.hashCode, false);
      expect(at0 == at2, false);
    });

    test('AT fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32List0);
        final uInt8ListV11 = uInt32ListV1.buffer.asUint8List();
        final at0 =
            ATtag.fromUint8List(PTag.kOriginalImageIdentification, uInt8ListV11);
        expect(at0.hasValidValues, true);
        expect(at0.vfBytes, equals(uInt8ListV11));
        expect(at0.values is Uint32List, true);
        expect(at0.values, equals(uInt32ListV1));

        // Test Base64
        final base64 = cvt.base64.encode(uInt8ListV11);
        final at1 = ATtag.fromBase64(PTag.kOriginalImageIdentification, base64);
        expect(at0 == at1, true);
        expect(at0.value, equals(at1.value));

        final uInt32List1 = rng.uint32List(2, 2);
        final uInt32ListV2 = new Uint32List.fromList(uInt32List1);
        final uInt8ListV12 = uInt32ListV2.buffer.asUint8List();
        final at2 = ATtag.fromUint8List(PTag.kSelectorAttribute, uInt8ListV12);
        expect(at2.hasValidValues, false);
      }
    });

    test('AT fromBytes', () {
      final uInt32ListV1 = new Uint32List.fromList(uInt32Max);
      final uInt8ListV11 = uInt32ListV1.buffer.asUint8List();
      final at0 =
          ATtag.fromUint8List(PTag.kOriginalImageIdentification, uInt8ListV11);
      expect(at0.hasValidValues, true);
      expect(at0.vfBytes, equals(uInt8ListV11));
      expect(at0.values is Uint32List, true);
      expect(at0.values, equals(uInt32ListV1));
    });

    test('AT checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(1, 1);
        final at0 = new ATtag(PTag.kFunctionalGroupPointer, uInt32List0);
        expect(at0.checkLength(at0.values), true);
      }
    });

    test('AT checkLength', () {
      final at0 = new ATtag(PTag.kFunctionalGroupPointer, uInt32Max);
      expect(at0.checkLength(at0.values), true);
    });

    test('AT checkValues random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(1, 1);
        final at0 = new ATtag(PTag.kFunctionalGroupPointer, uInt32List0);
        expect(at0.checkValues(at0.values), true);
      }
    });

    test('AT checkValues', () {
      final at0 = new ATtag(PTag.kFunctionalGroupPointer, uInt32Max);
      expect(at0.checkValues(at0.values), true);
    });

    test('AT valuesCopy random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(1, 1);
        final at0 = new ATtag(PTag.kFunctionalGroupPointer, uInt32List0);
        expect(uInt32List0, equals(at0.valuesCopy));
      }
    });

    test('AT valuesCopy', () {
      final at0 = new ATtag(PTag.kFunctionalGroupPointer, uInt32Max);
      expect(uInt32Max, equals(at0.valuesCopy));
    });

    test('AT replace random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(1, 1);
        final at0 = new ATtag(PTag.kFunctionalGroupPointer, uInt32List0);
        final uInt32List1 = rng.uint32List(1, 1);
        expect(at0.replace(uInt32List1), equals(uInt32List0));
        expect(at0.values, equals(uInt32List1));
      }

      final uInt32List1 = rng.uint32List(1, 1);
      final at1 = new ATtag(PTag.kFunctionalGroupPointer, uInt32List1);
      expect(at1.replace(<int>[]), equals(uInt32List1));
      expect(at1.values, equals(<int>[]));

      final at2 = new ATtag(PTag.kFunctionalGroupPointer, uInt32List1);
      expect(at2.replace(null), equals(uInt32List1));
      expect(at2.values, equals(<int>[]));
    });

    test('AT BASE64 random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final uInt32ListV11 = uInt32ListV1.buffer.asUint8List();
        final base64 = cvt.base64.encode(uInt32ListV11);
        final at0 = ATtag.fromBase64(PTag.kFunctionalGroupPointer, base64);
        expect(at0.hasValidValues, true);
      }
    });

    test('AT BASE64', () {
      final uInt32ListV1 = new Uint32List.fromList(uInt32Max);
      final uInt32ListV11 = uInt32ListV1.buffer.asUint8List();
      final base64 = cvt.base64.encode(uInt32ListV11);
      final at0 = ATtag.fromBase64(PTag.kFunctionalGroupPointer, base64);
      expect(at0.hasValidValues, true);
    });

    test('XintYYBase random', () {
      for (var i = 0; i < 10; i++) {
        final uInt8List0 = rng.uint8List(1, 1);
        final uInt8ListV3 = new Uint8List.fromList(uInt8List0);
        final v0 = Uint8.fromUint8List(uInt8ListV3);
        log.debug('v0: $v0');
        expect(v0, isNotNull);

        final uInt16List0 = rng.uint16List(1, 1);
        final uInt16ListV0 = new Uint16List.fromList(uInt16List0);
        final uInt8ListV1 = uInt16ListV0.buffer.asUint8List();
        final v1 = Uint16.fromUint8List(uInt8ListV1);
        log.debug('v1: $v1');
        expect(v1, isNotNull);

        final uInt32List0 = rng.uint32List(1, 1);
        final uInt32ListV0 = new Uint32List.fromList(uInt32List0);
        final uInt8ListV0 = uInt32ListV0.buffer.asUint8List();
        final v2 = Uint32.fromUint8List(uInt8ListV0);
        log.debug('v2: $v2');
        expect(v2, isNotNull);

        final uInt64List0 = rng.uint64List(1, 1);
        final uInt64ListV0 = new Uint64List.fromList(uInt64List0);
        final uInt8ListV2 = uInt64ListV0.buffer.asUint8List();
        final v3 = Uint64.fromUint8List(uInt8ListV2);
        log.debug('v3: $v3');
        expect(v3, isNotNull);
      }
    });

    test('AT view', () {
      final uInt32list0 = rng.uint32List(10, 10);
      final at0 = new ATtag(PTag.kSelectorATValue, uInt32list0);
      for (var i = 0, j = 0; i < uInt32list0.length; i++, j += 4) {
        final at1 = at0.view(j, uInt32list0.length - i);
        log.debug('at0: ${at0.values}, at1: ${at1.values}, '
            'uInt32list0.sublist(i) : ${uInt32list0.sublist(i)}');
        expect(at1.values, equals(uInt32list0.sublist(i)));
      }
    });
  });

  group('AT Element', () {
    //VM.k1
    const atTags0 = const <PTag>[
      PTag.kDimensionIndexPointer,
      PTag.kFunctionalGroupPointer,
      PTag.kSelectorAttribute,
      PTag.kAttributeOccurrencePointer,
      PTag.kParameterSequencePointer,
      PTag.kOverrideParameterPointer,
      PTag.kParameterPointer,
    ];

    //VM.k1_n
    const atTags1 = const <PTag>[
      PTag.kOriginalImageIdentification,
      PTag.kFrameIncrementPointer,
      PTag.kFrameDimensionPointer,
      PTag.kCompressionStepPointers,
      PTag.kDetailsOfCoefficients,
      PTag.kDataBlock,
      PTag.kZonalMapLocation,
      PTag.kCodeTableLocation,
      PTag.kImageDataLocation,
      PTag.kSelectorSequencePointer,
      PTag.kSelectorATValue,
      PTag.kFailureAttributes,
      PTag.kOverlayCompressionStepPointers,
      PTag.kOverlayCodeTableLocation,
      PTag.kCoefficientCodingPointers,
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

    final invalidVList = rng.uint32List(AT.kMaxLength + 1, AT.kMaxLength + 1);

    test('AT isValidVListLength VM.k1 good values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rng.uint32List(1, 1);
        system.throwOnError = false;
        for (var tag in atTags0) {
          expect(AT.isValidVListLength(tag, validMinVList), true);
          expect(
              AT.isValidVListLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              AT.isValidVListLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('AT isValidVListLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rng.uint32List(2, i + 1);
        for (var tag in atTags0) {
          system.throwOnError = false;
          expect(AT.isValidVListLength(tag, validMinVList), false);
          expect(AT.isValidVListLength(tag, invalidVList), false);

          system.throwOnError = true;
          expect(() => AT.isValidVListLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesLengthError>()));
          expect(() => AT.isValidVListLength(tag, invalidVList),
              throwsA(const isInstanceOf<InvalidValuesLengthError>()));
        }
      }
    });

    test('AT isValidVListLength VM.k1_n good values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rng.uint32List(1, i);
        system.throwOnError = false;
        for (var tag in atTags1) {
          expect(AT.isValidVListLength(tag, validMinVList), true);

          expect(
              AT.isValidVListLength(
                  tag, invalidVList.sublist(0, AT.kMaxLength)),
              true);
        }
      }
    });

    test('AT isValidTag good values', () {
      system.throwOnError = false;
      expect(AT.isValidTag(PTag.kSelectorATValue), true);

      for (var tag in atTags0) {
        expect(AT.isValidTag(tag), true);
      }
    });

    test('AT isValidTag bad values', () {
      system.throwOnError = false;
      expect(AT.isValidTag(PTag.kSelectorUSValue), false);

      system.throwOnError = true;
      expect(() => AT.isValidTag(PTag.kSelectorUSValue),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(AT.isValidTag(tag), false);

        system.throwOnError = true;
        expect(() => AT.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('AT isNotValidTag good values', () {
      system.throwOnError = false;
      expect(AT.isNotValidTag(PTag.kSelectorATValue), false);

      for (var tag in atTags0) {
        expect(AT.isNotValidTag(tag), false);
      }
    });

    test('AT isNotValidTag bad values', () {
      system.throwOnError = false;
      expect(AT.isNotValidTag(PTag.kSelectorUSValue), true);

      system.throwOnError = true;
      expect(() => AT.isNotValidTag(PTag.kSelectorUSValue),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(AT.isNotValidTag(tag), true);

        system.throwOnError = true;
        expect(() => AT.isNotValidTag(tag),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('AT isValidVR good values', () {
      system.throwOnError = false;
      expect(AT.isValidVRIndex(kATIndex), true);

      for (var tag in atTags0) {
        system.throwOnError = false;
        expect(AT.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('AT isValidVR bad values', () {
      system.throwOnError = false;
      expect(AT.isValidVRIndex(kAEIndex), false);
      system.throwOnError = true;
      expect(() => AT.isValidVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(AT.isValidVRIndex(tag.vrIndex), false);

        system.throwOnError = true;
        expect(() => AT.isValidVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('AT checkVR good values', () {
      system.throwOnError = false;
      expect(AT.checkVRIndex(kATIndex), kATIndex);

      for (var tag in atTags0) {
        system.throwOnError = false;
        expect(AT.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('AT checkVR bad values', () {
      system.throwOnError = false;
      expect(AT.checkVRIndex(kAEIndex), isNull);
      system.throwOnError = true;
      expect(() => AT.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(AT.checkVRIndex(tag.vrIndex), isNull);

        system.throwOnError = true;
        expect(() => AT.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('AT isValidVRIndex good values', () {
      system.throwOnError = false;
      expect(AT.isValidVRIndex(kATIndex), true);

      for (var tag in atTags0) {
        expect(AT.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('AT isValidVRIndex bad values', () {
      system.throwOnError = false;
      expect(AT.isValidVRIndex(kCSIndex), false);

      system.throwOnError = true;
      expect(() => AT.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(AT.isValidVRIndex(tag.vrIndex), false);

        system.throwOnError = true;
        expect(() => AT.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('AT isValidVRCode good values', () {
      system.throwOnError = false;
      expect(AT.isValidVRCode(kATCode), true);

      for (var tag in atTags0) {
        expect(AT.isValidVRCode(tag.vrCode), true);
      }
    });

    test('AT isValidVRCode bad values', () {
      system.throwOnError = false;
      expect(AT.isValidVRCode(kAECode), false);

      system.throwOnError = true;
      expect(() => AT.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(AT.isValidVRCode(tag.vrCode), false);

        system.throwOnError = true;
        expect(() => AT.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('AT isValidVFLength good values', () {
      expect(AT.isValidVFLength(AT.kMaxVFLength), true);
      expect(AT.isValidVFLength(0), true);
    });

    test('AT isValidVFLength bad values', () {
      expect(AT.isValidVFLength(AT.kMaxVFLength + 1), false);
      expect(AT.isValidVFLength(0), true);
    });

    test('AT isValidValue good values', () {
      expect(AT.isValidValue(AT.kMinValue), true);
      expect(AT.isValidValue(AT.kMaxValue), true);
    });

    test('AT isValidValue bad values', () {
      expect(AT.isValidValue(AT.kMinValue - 1), false);
      expect(AT.isValidValue(AT.kMaxValue + 1), false);
    });

    test('AT isValidValues good values values', () {
      system.throwOnError = false;
      const uInt32MinMax = const [kUint32Min, kUint32Max, kUint16Max];
      const uInt32Min = const [kUint32Min];
      const uInt32Max = const [kUint32Max];

      //VM.k1
      expect(AT.isValidValues(PTag.kSelectorAttribute, uInt32Min), true);
      expect(AT.isValidValues(PTag.kSelectorAttribute, uInt32Max), true);

      //VM.k1_n
      expect(AT.isValidValues(PTag.kSelectorATValue, uInt32MinMax), true);
      expect(AT.isValidValues(PTag.kSelectorATValue, uInt32Max), true);
      expect(AT.isValidValues(PTag.kSelectorATValue, uInt32Min), true);
    });

    test('AT isValidValues bad values values', () {
      system.throwOnError = false;
      const uInt32MaxPlus = const [kUint32Max + 1];
      const uInt32MinMinus = const [kUint32Min - 1];

      //VM.k1
      expect(AT.isValidValues(PTag.kSelectorAttribute, uInt32MaxPlus), false);
      expect(AT.isValidValues(PTag.kSelectorAttribute, uInt32MinMinus), false);

      system.throwOnError = true;
      expect(() => AT.isValidValues(PTag.kSelectorAttribute, uInt32MaxPlus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
      expect(() => AT.isValidValues(PTag.kSelectorAttribute, uInt32MinMinus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('AT isValidValues bad values length', () {
      system.throwOnError = false;
      const uInt32MinMax = const [
        kUint32Min,
        kUint32Max,
      ];

      //VM.k1
      expect(AT.isValidValues(PTag.kSelectorAttribute, uInt32MinMax), false);

      system.throwOnError = true;
      expect(() => AT.isValidValues(PTag.kSelectorAttribute, uInt32MinMax),
          throwsA(const isInstanceOf<InvalidValuesLengthError>()));
    });

    test('AT fromList', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        expect(Uint32.fromList(uInt32list0), uInt32list0);
      }
      const uInt32Min = const [kUint32Min];
      const uInt32Max = const [kUint32Max];
      expect(Uint32.fromList(uInt32Min), uInt32Min);
      expect(Uint32.fromList(uInt32Max), uInt32Max);
    });

    test('AT fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final bd = uInt32ListV1.buffer.asUint8List();
        log
          ..debug('uInt32ListV1 : $uInt32ListV1')
          ..debug('Uint32Base.fromUint8List(bd) ; ${Uint32.fromUint8List(bd)}');
        expect(Uint32.fromUint8List(bd), equals(uInt32ListV1));
      }
    });

    test('AT toBytes', () {
      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final bd = uInt32ListV1.buffer.asUint8List();
        log
          ..debug('uInt32ListV1 : $uInt32ListV1')
          ..debug('Uint32Base.toBytes(uInt32ListV1): '
              '${Uint32.toBytes(uInt32ListV1)}');
        expect(Uint32.toBytes(uInt32ListV1), equals(bd));
      }

      const uInt32Max = const [kUint32Max];
      final uInt32ListV1 = new Uint32List.fromList(uInt32Max);
      final uInt32List = uInt32ListV1.buffer.asUint8List();
      expect(Uint32.toBytes(uInt32Max), uInt32List);

      const uInt64Max = const [kUint64Max];
      expect(Uint32.toBytes(uInt64Max).isEmpty, true);

      system.throwOnError = true;
      expect(() => Uint32.toBytes(uInt64Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('AT fromBase64', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final bd = uInt32ListV1.buffer.asUint8List();
        final s = cvt.base64.encode(bd);
        expect(Uint32.fromBase64(s), equals(uInt32ListV1));
      }
    });

    test('AT toBase64', () {
      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final bd = uInt32ListV1.buffer.asUint8List();
        final s = cvt.base64.encode(bd);
        expect(Uint32.toBase64(uInt32list0), equals(s));
      }
    });

    test('AT fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final bd = uInt32ListV1.buffer.asUint8List();
        log
          ..debug('uInt32ListV1 : $uInt32ListV1')
          ..debug('Uint32Base.fromUint8List(bd) ; ${Uint32.fromUint8List(bd)}');
        expect(Uint32.fromUint8List(bd), equals(uInt32ListV1));
      }
    });

    test('AT fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final byteData = uInt32ListV1.buffer.asByteData();
        log
          ..debug('uInt32ListV1 : $uInt32ListV1')
          ..debug('Uint32Base.fromByteData(byteData): '
              '${Uint32.fromByteData(byteData)}');
        expect(Uint32.fromByteData(byteData), equals(uInt32ListV1));
      }
    });
  });

  group('OL', () {
    test('OL hasValidValues random', () {
      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(1, 1);
        final ol0 = new OLtag(PTag.kLongPrimitivePointIndexList, uInt32List0);
        log.debug('ol0: ${ol0.info}');
        expect(ol0.hasValidValues, true);

        log
          ..debug('ol0: $ol0, values: ${ol0.values}')
          ..debug('ol0: ${ol0.info}');
        expect(ol0[0], equals(uInt32List0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(1, 10);
        final ol0 = new OLtag(PTag.kSelectorOLValue, uInt32List0);
        log.debug('ol0: ${ol0.info}');
        expect(ol0.hasValidValues, true);

        log
          ..debug('ol0: $ol0, values: ${ol0.values}')
          ..debug('ol0: ${ol0.info}');
        expect(ol0[0], equals(uInt32List0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(2, 3);
        log.debug('$i: uInt32List0: $uInt32List0');
        final ol0 = new OLtag(PTag.kLongPrimitivePointIndexList, uInt32List0);
        expect(ol0.hasValidValues, true);
      }
    });

    test('OL hasValidValues good values', () {
      system.throwOnError = false;
      final ol0 = new OLtag(PTag.kLongPrimitivePointIndexList, uInt32Max);
      final ol1 = new OLtag(PTag.kLongPrimitivePointIndexList, uInt32Max);
      expect(ol0.hasValidValues, true);
      expect(ol1.hasValidValues, true);

      final ol2 = new OLtag(PTag.kLongPrimitivePointIndexList, uInt32Max);
      final ol3 = new OLtag(PTag.kLongPrimitivePointIndexList, uInt32Max);
      expect(ol2.hasValidValues, true);
      expect(ol3.hasValidValues, true);

      system.throwOnError = false;
      final ol4 = new OLtag(PTag.kLongVertexPointIndexList, []);
      expect(ol4.hasValidValues, true);
      log.debug('ol4:${ol4.info}');
      expect(ol4.values, equals(<int>[]));
    });

    test('OL hasValidValues bad values', () {
      final ol0 = new OLtag(PTag.kLongPrimitivePointIndexList, uInt32MaxPlus);
      expect(ol0, isNull);

      final ol1 = new OLtag(PTag.kLongPrimitivePointIndexList, uInt32MinMinus);
      expect(ol1, isNull);

      final ol2 = new OLtag(PTag.kLongPrimitivePointIndexList, uInt32MinMax);
      expect(ol2.hasValidValues, true);

      system.throwOnError = false;
      final ol3 = new OLtag(PTag.kLongPrimitivePointIndexList, uInt32Max);
      final uInt64List0 = rng.uint64List(1, 1);
      ol3.values = uInt64List0;
      expect(ol3.hasValidValues, false);

      system.throwOnError = true;
      expect(() => ol3.hasValidValues,
          throwsA(const isInstanceOf<InvalidValuesError>()));

      system.throwOnError = false;
      final ol4 = new OLtag(PTag.kLongVertexPointIndexList, null);
      log.debug('ol4: $ol4');
      expect(ol4, isNull);

      system.throwOnError = true;
      expect(() => new OLtag(PTag.kLongVertexPointIndexList, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('OL update random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(3, 4);
        final ol1 = new OLtag(PTag.kTrackPointIndexList, uInt32List0);
        final uInt32List1 = rng.uint32List(3, 4);
        expect(ol1.update(uInt32List1).values, equals(uInt32List1));
      }
    });

    test('OL update', () {
      final ol0 = new OLtag(PTag.kLongVertexPointIndexList, uInt32Min);
      final ol1 = new OLtag(PTag.kLongVertexPointIndexList, uInt32Min);
      final ol2 = ol0.update(uInt32Max);
      final ol3 = ol1.update(uInt32Max);
      expect(ol0.values.first == ol3.values.first, false);
      expect(ol0 == ol3, false);
      expect(ol1 == ol3, false);
      expect(ol2 == ol3, true);

      final ol4 = new OLtag(PTag.kTrackPointIndexList, []);
      expect(ol4.update([76345748, 64357898]).values,
          equals([76345748, 64357898]));
    });

    test('OL noValues random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List = rng.uint32List(3, 4);
        final ol1 = new OLtag(PTag.kLongVertexPointIndexList, uInt32List);
        log.debug('ol1: ${ol1.noValues}');
        expect(ol1.noValues.values.isEmpty, true);
      }
    });

    test('OL noValues', () {
      final ol0 = new OLtag(PTag.kLongVertexPointIndexList, []);
      final OLtag olNoValues = ol0.noValues;
      expect(olNoValues.values.isEmpty, true);
      log.debug('ol0: ${ol0.noValues}');

      final ol1 = new OLtag(PTag.kLongVertexPointIndexList, uInt32Max);
      final olNoValues0 = ol1.noValues;
      expect(olNoValues0.values.isEmpty, true);
      log.debug('ol1:${ol1.noValues}');
    });

    test('OL copy random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List = rng.uint32List(3, 4);
        final ol2 = new OLtag(PTag.kLongVertexPointIndexList, uInt32List);
        final OLtag ol3 = ol2.copy;
        expect(ol3 == ol2, true);
        expect(ol3.hashCode == ol2.hashCode, true);
      }
    });

    test('OL copy', () {
      final ol0 = new OLtag(PTag.kLongVertexPointIndexList, []);
      final OLtag ol1 = ol0.copy;
      expect(ol1 == ol0, true);
      expect(ol1.hashCode == ol0.hashCode, true);

      final ol2 = new OLtag(PTag.kLongVertexPointIndexList, uInt32Max);
      final ol3 = ol2.copy;
      expect(ol2 == ol3, true);
      expect(ol2.hashCode == ol3.hashCode, true);
    });

    test('OL hashCode and == good values random', () {
      system.throwOnError = false;
      final rng = new RNG(1);

      List<int> uInt32List0;
      for (var i = 0; i < 10; i++) {
        uInt32List0 = rng.uint32List(1, 1);
        final ol0 = new OLtag(PTag.kLongVertexPointIndexList, uInt32List0);
        final ol1 = new OLtag(PTag.kLongVertexPointIndexList, uInt32List0);
        log
          ..debug('uInt32List0:$uInt32List0, ol0.hash_code:${ol0.hashCode}')
          ..debug('uInt32List0:$uInt32List0, ol1.hash_code:${ol1.hashCode}');
        expect(ol0.hashCode == ol1.hashCode, true);
        expect(ol0 == ol1, true);
      }
    });

    test('OL hashCode and == random bad values', () {
      system.throwOnError = false;
      List<int> uInt32List0;
      List<int> uInt32List1;
      List<int> uInt32List2;

      for (var i = 0; i < 10; i++) {
        uInt32List0 = rng.uint32List(1, 1);
        final ol0 = new OLtag(PTag.kLongVertexPointIndexList, uInt32List0);

        uInt32List1 = rng.uint32List(1, 1);
        final ol2 = new OLtag(PTag.kLongVertexPointIndexList, uInt32List1);
        log.debug('uInt32List1:$uInt32List1 , ol2.hash_code:${ol2.hashCode}');
        expect(ol0.hashCode == ol2.hashCode, false);
        expect(ol0 == ol2, false);

        uInt32List2 = rng.uint32List(2, 3);
        final ol3 = new OLtag(PTag.kFunctionalGroupPointer, uInt32List2);
        log.debug('uInt32List2:$uInt32List2 , ol3.hash_code:${ol3.hashCode}');
        expect(ol0.hashCode == ol3.hashCode, false);
        expect(ol0 == ol3, false);
      }
    });

    test('OL hashCode and == good values', () {
      final ol0 = new OLtag(PTag.kLongVertexPointIndexList, uInt32Max);
      final ol1 = new OLtag(PTag.kLongVertexPointIndexList, uInt32Max);

      log
        ..debug('uInt32Max:$uInt32Max, ol0.hash_code:${ol0.hashCode}')
        ..debug('uInt32Max:$uInt32Max, ol1.hash_code:${ol1.hashCode}');
      expect(ol0.hashCode == ol1.hashCode, true);
      expect(ol0 == ol1, true);
    });

    test('OL hashCode and == bad values', () {
      final ol0 = new OLtag(PTag.kLongVertexPointIndexList, uInt32Max);

      final ol2 = new OLtag(PTag.kLongVertexPointIndexList, uInt32Min);
      log.debug('uInt32Min:$uInt32Min , ol2.hash_code:${ol2.hashCode}');
      expect(ol0.hashCode == ol2.hashCode, false);
      expect(ol0 == ol2, false);
    });

    test('OL fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32List0);
        final uInt8ListV11 = uInt32ListV1.buffer.asUint8List();
        final ol0 =
            OLtag.fromUint8List(PTag.kLongVertexPointIndexList, uInt8ListV11);
        expect(ol0.hasValidValues, true);
        expect(ol0.vfBytes, equals(uInt8ListV11));
        expect(ol0.values is Uint32List, true);
        expect(ol0.values, equals(uInt32ListV1));

        // Test Base64
        final base64 = cvt.base64.encode(uInt8ListV11);
        final ol1 = OLtag.fromBase64(PTag.kLongVertexPointIndexList, base64);
        expect(ol0 == ol1, true);
        expect(ol0.value, equals(ol1.value));

        final uInt32List1 = rng.uint32List(2, 2);
        final uInt32ListV2 = new Uint32List.fromList(uInt32List1);
        final uInt8ListV12 = uInt32ListV2.buffer.asUint8List();
        final ol2 =
            OLtag.fromUint8List(PTag.kLongVertexPointIndexList, uInt8ListV12);
        expect(ol2.hasValidValues, true);
      }
    });

    test('OL fromBytes', () {
      final uInt32ListV1 = new Uint32List.fromList(uInt32Max);
      final uInt8ListV11 = uInt32ListV1.buffer.asUint8List();
      final ol0 = OLtag.fromUint8List(PTag.kLongVertexPointIndexList, uInt8ListV11);
      expect(ol0.hasValidValues, true);
      expect(ol0.vfBytes, equals(uInt8ListV11));
      expect(ol0.values is Uint32List, true);
      expect(ol0.values, equals(uInt32ListV1));
    });

    test('OL checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(1, 1);
        final ol0 = new OLtag(PTag.kLongVertexPointIndexList, uInt32List0);
        expect(ol0.checkLength(ol0.values), true);
      }
    });

    test('OL checkLength', () {
      final ol0 = new OLtag(PTag.kLongVertexPointIndexList, uInt32Max);
      expect(ol0.checkLength(ol0.values), true);
    });

    test('OL checkValues random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(1, 1);
        final ol0 = new OLtag(PTag.kLongVertexPointIndexList, uInt32List0);
        expect(ol0.checkValues(ol0.values), true);
      }
    });

    test('OL checkValues', () {
      final ol0 = new OLtag(PTag.kLongVertexPointIndexList, uInt32Max);
      expect(ol0.checkValues(ol0.values), true);
    });

    test('OL valuesCopy random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(1, 1);
        final ol0 = new OLtag(PTag.kLongVertexPointIndexList, uInt32List0);
        expect(uInt32List0, equals(ol0.valuesCopy));
      }
    });

    test('OL valuesCopy', () {
      final ol0 = new OLtag(PTag.kLongVertexPointIndexList, uInt32Max);
      expect(uInt32Max, equals(ol0.valuesCopy));
    });

    test('OL replace random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32List0 = rng.uint32List(1, 1);
        final ol0 = new OLtag(PTag.kLongVertexPointIndexList, uInt32List0);
        final uInt32List1 = rng.uint32List(1, 1);
        expect(ol0.replace(uInt32List1), equals(uInt32List0));
        expect(ol0.values, equals(uInt32List1));
      }

      final uInt32List1 = rng.uint32List(1, 1);
      final ol1 = new OLtag(PTag.kLongVertexPointIndexList, uInt32List1);
      expect(ol1.replace(<int>[]), equals(uInt32List1));
      expect(ol1.values, equals(<int>[]));

      final ol2 = new OLtag(PTag.kLongVertexPointIndexList, uInt32List1);
      expect(ol2.replace(null), equals(uInt32List1));
      expect(ol2.values, equals(<int>[]));
    });

    test('OL BASE64 random', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final uInt32ListV11 = uInt32ListV1.buffer.asUint8List();
        final base64 = cvt.base64.encode(uInt32ListV11);
        final ol0 = OLtag.fromBase64(PTag.kLongVertexPointIndexList, base64);
        expect(ol0.hasValidValues, true);
      }
    });

    test('OL BASE64', () {
      final uInt32ListV1 = new Uint32List.fromList(uInt32Max);
      final uInt32ListV11 = uInt32ListV1.buffer.asUint8List();
      final base64 = cvt.base64.encode(uInt32ListV11);
      final ol0 = OLtag.fromBase64(PTag.kLongVertexPointIndexList, base64);
      expect(ol0.hasValidValues, true);
    });

    test('OL make', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final ol0 = OLtag.make(PTag.kLongVertexPointIndexList, uInt32list0);
        expect(ol0.hasValidValues, true);
      }
    });

    test('OL fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final uInt32ListV11 = uInt32ListV1.buffer.asUint8List();
        final ol0 =
            OLtag.fromUint8List(PTag.kLongVertexPointIndexList, uInt32ListV11);
        expect(ol0.hasValidValues, true);
        expect(ol0.vfBytes, equals(uInt32ListV11));
        expect(ol0.values is Uint32List, true);
        expect(ol0.values, equals(uInt32ListV1));
      }
    });

    test('OL fromB64', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final uInt32ListV11 = uInt32ListV1.buffer.asUint8List();
        final base64 = cvt.base64.encode(uInt32ListV11);
        final ol0 = OLtag.fromBase64(PTag.kLongVertexPointIndexList, base64);
        expect(ol0.hasValidValues, true);
      }
    });

    test('OL checkValue good values', () {
      final uInt32list0 = rng.uint32List(1, 1);
      final ol0 = new OLtag(PTag.kLongVertexPointIndexList, uInt32list0);

      expect(ol0.checkValue(uInt32Max[0]), true);
      expect(ol0.checkValue(uInt32Min[0]), true);
    });

    test('OL checkValue bad values', () {
      final uInt32list0 = rng.uint32List(1, 1);
      final ol0 = new OLtag(PTag.kLongVertexPointIndexList, uInt32list0);

      expect(ol0.checkValue(uInt32MaxPlus[0]), false);
      expect(ol0.checkValue(uInt32MinMinus[0]), false);
    });

    test('OL view', () {
      final uInt32list0 = rng.uint32List(10, 10);
      final ol0 = new OLtag(PTag.kSelectorOLValue, uInt32list0);
      for (var i = 0, j = 0; i < uInt32list0.length; i++, j += 4) {
        final ol1 = ol0.view(j, uInt32list0.length - i);
        log.debug('ol0: ${ol0.values}, ol1: ${ol1.values}, '
            'uInt32list0.sublist(i) : ${uInt32list0.sublist(i)}');
        expect(ol1.values, equals(uInt32list0.sublist(i)));
      }
    });
  });

  group('OL Element', () {
    //VM.k1
    const olTags0 = const <PTag>[
      PTag.kLongPrimitivePointIndexList,
      PTag.kLongTrianglePointIndexList,
      PTag.kLongEdgePointIndexList,
      PTag.kLongVertexPointIndexList,
      PTag.kTrackPointIndexList,
    ];

    //VM.k1_n
    const olTags1 = const <PTag>[PTag.kSelectorOLValue];

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

    test('OL isValidVFLength', () {
      system.throwOnError = false;
      expect(OL.isValidVFLength(OL.kMaxLength), true);
      expect(OL.isValidVFLength(0), true);
    });

    test('OL isValidTag good values', () {
      system.throwOnError = false;
      expect(OL.isValidTag(PTag.kSelectorOLValue), true);

      for (var tag in olTags0) {
        expect(OL.isValidTag(tag), true);
      }
    });

    test('OL isValidTag bad values', () {
      system.throwOnError = false;
      expect(OL.isValidTag(PTag.kSelectorUSValue), false);

      system.throwOnError = true;
      expect(() => OL.isValidTag(PTag.kSelectorUSValue),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OL.isValidTag(tag), false);

        system.throwOnError = true;
        expect(() => OL.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('OL isNotValidTag good values', () {
      system.throwOnError = false;
      expect(OL.isNotValidTag(PTag.kSelectorOLValue), false);

      for (var tag in olTags0) {
        expect(OL.isNotValidTag(tag), false);
      }
    });

    test('OL isNotValidTag bad values', () {
      system.throwOnError = false;
      expect(OL.isNotValidTag(PTag.kSelectorUSValue), true);

      system.throwOnError = true;
      expect(() => OL.isNotValidTag(PTag.kSelectorUSValue),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OL.isNotValidTag(tag), true);

        system.throwOnError = true;
        expect(() => OL.isNotValidTag(tag),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('OL isValidVR good values', () {
      system.throwOnError = false;
      expect(OL.isValidVRIndex(kOLIndex), true);

      for (var tag in olTags0) {
        system.throwOnError = false;
        expect(OL.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('OL isValidVR  good values', () {
      system.throwOnError = false;
      expect(OL.isValidVRIndex(kOLIndex), true);

      for (var tag in olTags1) {
        system.throwOnError = false;
        expect(OL.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('OL isValidVR good values', () {
      system.throwOnError = false;
      expect(OL.isValidVRIndex(kAEIndex), false);
      system.throwOnError = true;
      expect(() => OL.isValidVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OL.isValidVRIndex(tag.vrIndex), false);

        system.throwOnError = true;
        expect(() => OL.isValidVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('OL checkVR good values', () {
      system.throwOnError = false;
      expect(OL.checkVRIndex(kOLIndex), kOLIndex);

      for (var tag in olTags0) {
        system.throwOnError = false;
        expect(OL.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('OL checkVR bad values', () {
      system.throwOnError = false;
      expect(OL.checkVRIndex(kAEIndex), isNull);
      system.throwOnError = true;
      expect(() => OL.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OL.checkVRIndex(tag.vrIndex), isNull);

        system.throwOnError = true;
        expect(() => OL.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('OL isValidVRIndex good values', () {
      system.throwOnError = false;
      expect(OL.isValidVRIndex(kOLIndex), true);

      for (var tag in olTags0) {
        system.throwOnError = false;
        expect(OL.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('OL isValidVRIndex bad values', () {
      system.throwOnError = false;
      expect(OL.isValidVRIndex(kCSIndex), false);

      system.throwOnError = true;
      expect(() => OL.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OL.isValidVRIndex(tag.vrIndex), false);

        system.throwOnError = true;
        expect(() => OL.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('OL isValidVRCode good values', () {
      system.throwOnError = false;
      expect(OL.isValidVRCode(kOLCode), true);

      for (var tag in olTags0) {
        expect(OL.isValidVRCode(tag.vrCode), true);
      }
    });

    test('OL isValidVRCode bad values', () {
      system.throwOnError = false;
      expect(OL.isValidVRCode(kAECode), false);

      system.throwOnError = true;
      expect(() => OL.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OL.isValidVRCode(tag.vrCode), false);

        system.throwOnError = true;
        expect(() => OL.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('OL isValidVFLength good values', () {
      expect(OL.isValidVFLength(OL.kMaxVFLength), true);
      expect(OL.isValidVFLength(0), true);
    });

    test('OL isValidVFLength bad values', () {
      expect(OL.isValidVFLength(OL.kMaxVFLength + 1), false);
      expect(OL.isValidVFLength(-1), false);
    });

    test('OL isValidValue good values', () {
      expect(OL.isValidValue(OL.kMinValue), true);
      expect(OL.isValidValue(OL.kMaxValue), true);
    });

    test('OL isValidValue bad values', () {
      expect(OL.isValidValue(OL.kMinValue - 1), false);
      expect(OL.isValidValue(OL.kMaxValue + 1), false);
    });

    test('OL isValidValues good values', () {
      system.throwOnError = false;
      const uInt32MinMax = const [kUint32Min, kUint32Max, kUint16Max];
      const uInt32Min = const [kUint32Min];
      const uInt32Max = const [kUint32Max];

      //VM.k1
      expect(OL.isValidValues(PTag.kTrackPointIndexList, uInt32Min), true);
      expect(OL.isValidValues(PTag.kTrackPointIndexList, uInt32Max), true);

      //VM.k1_n
      expect(OL.isValidValues(PTag.kSelectorOLValue, uInt32MinMax), true);
      expect(OL.isValidValues(PTag.kSelectorOLValue, uInt32Max), true);
      expect(OL.isValidValues(PTag.kSelectorOLValue, uInt32Min), true);
    });

    test('OL isValidValues bad values', () {
      system.throwOnError = false;
      const uInt32MaxPlus = const [kUint32Max + 1];
      const uInt32MinMinus = const [kUint32Min - 1];

      //VM.k1
      expect(OL.isValidValues(PTag.kTrackPointIndexList, uInt32MaxPlus), false);
      expect(
          OL.isValidValues(PTag.kTrackPointIndexList, uInt32MinMinus), false);

      system.throwOnError = true;
      expect(() => OL.isValidValues(PTag.kTrackPointIndexList, uInt32MaxPlus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
      expect(() => OL.isValidValues(PTag.kTrackPointIndexList, uInt32MinMinus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('OL fromList', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        expect(Uint32.fromList(uInt32list0), uInt32list0);
      }
      const uInt32Min = const [kUint32Min];
      const uInt32Max = const [kUint32Max];
      expect(Uint32.fromList(uInt32Min), uInt32Min);
      expect(Uint32.fromList(uInt32Max), uInt32Max);
    });

    test('OL fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final bd = uInt32ListV1.buffer.asUint8List();
        log
          ..debug('uInt32ListV1 : $uInt32ListV1')
          ..debug('Uint32Base.fromUint8List(bd) ; ${Uint32.fromUint8List(bd)}');
        expect(Uint32.fromUint8List(bd), equals(uInt32ListV1));
      }
    });

    test('OL toBytes', () {
      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final bd = uInt32ListV1.buffer.asUint8List();
        log
          ..debug('uInt32ListV1 : $uInt32ListV1')
          ..debug('Uint32Base.toBytes(uInt32ListV1): '
              '${Uint32.toBytes(uInt32ListV1)}');
        expect(Uint32.toBytes(uInt32ListV1), equals(bd));
      }

      const uInt32Max = const [kUint32Max];
      final uInt32ListV1 = new Uint32List.fromList(uInt32Max);
      final uInt32List = uInt32ListV1.buffer.asUint8List();
      expect(Uint32.toBytes(uInt32Max), uInt32List);

      const uInt64Max = const [kUint64Max];
      expect(Uint32.toBytes(uInt64Max).isEmpty, true);

      system.throwOnError = true;
      expect(() => Uint32.toBytes(uInt64Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('OL fromBase64', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(0, i);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final bd = uInt32ListV1.buffer.asUint8List();
        final base64 = cvt.base64.encode(bd);
        log.debug('OL.base64: "$base64"');

        final olList = Uint32.fromBase64(base64);
        log.debug('  OL.decode: $olList');
        expect(olList, equals(uInt32list0));
        expect(olList, equals(uInt32ListV1));
      }
    });

    test('OL toBase64', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(0, i);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final bd = uInt32ListV1.buffer.asUint8List();
        final s = cvt.base64.encode(bd);
        expect(Uint32.toBase64(uInt32list0), equals(s));
      }
    });

    test('OL encodeDecodeJsonVF', () {
//      system.level = Level.info;
      for (var i = 1; i < 10; i++) {
        final uInt32list0 = rng.uint32List(0, i);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final bd = uInt32ListV1.buffer.asUint8List();

        // Encode
        final base64 = cvt.base64.encode(bd);
        log.debug('OL.base64: "$base64"');
        final s = Uint32.toBase64(uInt32list0);
        log.debug('  OL.json: "$s"');
        expect(s, equals(base64));

        // Decode
        final ol0 = Uint32.fromBase64(base64);
        log.debug('OL.base64: $ol0');
        final ol1 = Uint32.fromBase64(s);
        log.debug('  OL.json: $ol1');
        expect(ol0, equals(uInt32list0));
        expect(ol0, equals(uInt32ListV1));
        expect(ol0, equals(ol1));
      }
    });

    test('OL fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final bd = uInt32ListV1.buffer.asUint8List();
        log
          ..debug('uInt32ListV1 : $uInt32ListV1')
          ..debug('Uint32Base.fromUint8List(bd) ; ${Uint32.fromUint8List(bd)}');
        expect(Uint32.fromUint8List(bd), equals(uInt32ListV1));
      }
    });

    test('OL fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final uInt32list0 = rng.uint32List(1, 1);
        final uInt32ListV1 = new Uint32List.fromList(uInt32list0);
        final byteData = uInt32ListV1.buffer.asByteData();
        log
          ..debug('uInt32ListV1 : $uInt32ListV1')
          ..debug('Uint32Base.fromByteData(byteData): '
              '${Uint32.fromByteData(byteData)}');
        expect(Uint32.fromByteData(byteData), equals(uInt32ListV1));
      }
    });
  });
}
