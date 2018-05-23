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
  Server.initialize(name: 'element/ul_test', level: Level.debug);
  final rng = new RNG(1);

  const uInt32MinMax = const [kUint32Min, kUint32Max];
  const uInt32Max = const [kUint32Max];
  const uInt32MaxPlus = const [kUint32Max + 1];
  const uInt32Min = const [kUint32Min];
  const uInt32MinMinus = const [kUint32Min - 1];

  group('UL', () {
    test('UL hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final e0 = new ULtag(PTag.kPixelComponentMask, vList0);
        log.debug('e0: e0');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: e0');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(3, 3);
        final e0 = new ULtag(PTag.kGridDimensions, vList0);
        log.debug('e0: e0');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: e0');
        expect(e0[0], equals(vList0[0]));
      }
    });

    test('UL hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(2, 3);
        log.debug('$i: vList0: $vList0');
        final e0 = new ULtag(PTag.kPixelComponentMask, vList0);
        expect(e0, isNull);
      }
    });

    test('UL hasValidValues good values', () {
      global.throwOnError = false;
      final e0 = new ULtag(PTag.kPixelComponentMask, uInt32Max);
      final e1 = new ULtag(PTag.kPixelComponentMask, uInt32Max);
      expect(e0.hasValidValues, true);
      expect(e1.hasValidValues, true);

      final e2 = new ULtag(PTag.kPixelComponentMask, uInt32Max);
      final e3 = new ULtag(PTag.kPixelComponentMask, uInt32Max);
      expect(e2.hasValidValues, true);
      expect(e3.hasValidValues, true);

      global.throwOnError = false;
      final e4 = new ULtag(PTag.kDataPointColumns, []);
      expect(e4.hasValidValues, true);
      log.debug('e4:e4');
      expect(e4.values, equals(<int>[]));
    });

    test('UL hasValidValues bad values', () {
      final e0 = new ULtag(PTag.kPixelComponentMask, uInt32MaxPlus);
      expect(e0, isNull);

      final e1 = new ULtag(PTag.kPixelComponentMask, uInt32MinMinus);
      expect(e1, isNull);

      final e2 = new ULtag(PTag.kPixelComponentMask, uInt32MinMax);
      expect(e2, isNull);

      final e3 = new ULtag(PTag.kPixelComponentMask, uInt32Max);
      final uint64List0 = rng.uint64List(1, 1);
      e3.values = uint64List0;
      expect(e3.hasValidValues, false);

      global.throwOnError = true;
      expect(() => e3.hasValidValues,
          throwsA(const isInstanceOf<InvalidValuesError>()));

      global.throwOnError = false;
      final e4 = new ULtag(PTag.kDataPointColumns, null);
      log.debug('e4: $e4');
      expect(e4, isNull);

      global.throwOnError = true;
      expect(() => new ULtag(PTag.kDataPointColumns, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('UL update random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(3, 4);
        final e1 = new ULtag(PTag.kSimpleFrameList, vList0);
        final vList1 = rng.uint32List(3, 4);
        expect(e1.update(vList1).values, equals(vList1));
      }
    });

    test('UL update', () {
      final e0 = new ULtag(PTag.kPixelComponentMask, uInt32Min);
      final e1 = new ULtag(PTag.kPixelComponentMask, uInt32Min);
      final e2 = e0.update(uInt32Max);
      final e3 = e1.update(uInt32Max);
      expect(e0.values.first == e3.values.first, false);
      expect(e0 == e3, false);
      expect(e1 == e3, false);
      expect(e2 == e3, true);

      final e4 = new ULtag(PTag.kDataPointColumns, []);
      expect(e4.update([76345748]).values, equals([76345748]));
    });

    test('UL noValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.uint32List(3, 4);
        final e1 = new ULtag(PTag.kSimpleFrameList, vList);
        log.debug('e1: ${e1.noValues}');
        expect(e1.noValues.values.isEmpty, true);
      }
    });

    test('UL noValues', () {
      final e0 = new ULtag(PTag.kDataPointColumns, []);
      final ULtag ulNoValues = e0.noValues;
      expect(ulNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      final e1 = new ULtag(PTag.kDataPointColumns, uInt32Max);
      final ulNoValues0 = e1.noValues;
      expect(ulNoValues0.values.isEmpty, true);
      log.debug('e1:${e1.noValues}');
    });

    test('UL copy random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.uint32List(3, 4);
        final e2 = new ULtag(PTag.kSimpleFrameList, vList);
        final ULtag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('UL copy', () {
      final e0 = new ULtag(PTag.kDataPointColumns, []);
      final ULtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      final e2 = new ULtag(PTag.kDataPointColumns, uInt32Max);
      final e3 = e2.copy;
      expect(e2 == e3, true);
      expect(e2.hashCode == e3.hashCode, true);
    });

    test('UL hashCode and == good values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final e0 = new ULtag(PTag.kDataPointColumns, vList0);
        final e1 = new ULtag(PTag.kDataPointColumns, vList0);
        log
          ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
          ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });
    test('UL hashCode and == bad values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final e0 = new ULtag(PTag.kDataPointColumns, vList0);
        final vList1 = rng.uint32List(1, 1);
        final e2 = new ULtag(PTag.kNumberOfWaveformSamples, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rng.uint32List(3, 3);
        final e3 = new ULtag(PTag.kGridDimensions, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);

        final vList3 = rng.uint32List(1, 9);
        final e4 = new ULtag(PTag.kReferencedSamplePositions, vList3);
        log.debug('vList3:$vList3 , us4.hash_code:${e4.hashCode}');
        expect(e0.hashCode == e4.hashCode, false);
        expect(e0 == e4, false);

        final vList4 = rng.uint32List(2, 3);
        final e5 = new ULtag(PTag.kDataPointColumns, vList4);
        log.debug('vList4:$vList4 , e5.hash_code:${e5.hashCode}');
        expect(e0.hashCode == e5.hashCode, false);
        expect(e0 == e5, false);
      }
    });

    test('UL hashCode and == good values', () {
      final e0 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32Max);
      final e1 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32Max);

      log
        ..debug('uInt32Max:$uInt32Max, e0.hash_code:${e0.hashCode}')
        ..debug('uInt32Max:$uInt32Max, e1.hash_code:${e1.hashCode}');
      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);
    });

    test('UL hashCode and == bad values', () {
      final e0 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32Max);

      final e2 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32Min);
      log.debug('uInt32Min:$uInt32Min , e2.hash_code:${e2.hashCode}');
      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);
    });

    test('UL fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final bytes0 = new Bytes.typedDataView(vList0);
        final e0 = ULtag.fromBytes(bytes0, PTag.kNumberOfWaveformSamples);
        expect(e0.hasValidValues, true);
        expect(e0.vfBytes, equals(bytes0));
        expect(e0.values is Uint32List, true);
        expect(e0.values, equals(vList0));

        // Test Base6
        final s0 = bytes0.getBase64();
        final bytes1 = Bytes.fromBase64(s0);
        final e1 = ULtag.fromBytes(bytes1, PTag.kNumberOfWaveformSamples);
        expect(e0 == e1, true);
        expect(e0.value, equals(e1.value));

        final vList2 = rng.uint32List(2, 2);
        final bytes2 = new Bytes.typedDataView(vList2);
        final e2 = ULtag.fromBytes(bytes2, PTag.kNumberOfWaveformSamples);
        expect(e2, isNull);
      }
    });

    test('UL fromBytes', () {
      final vList = new Uint32List.fromList(uInt32Max);
      final bytes = new Bytes.typedDataView(vList);
      final e5 = ULtag.fromBytes(bytes, PTag.kNumberOfWaveformSamples);
      expect(e5.hasValidValues, true);
      expect(e5.vfBytes, equals(bytes));
      expect(e5.values is Uint32List, true);
      expect(e5.values, equals(vList));
    });

    test('UL fromBytes good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rng.uint32List(1, 10);
        final bytes0 = new Bytes.typedDataView(vList);
        final e0 = ULtag.fromBytes(bytes0, PTag.kSelectorULValue);
        log.debug('e0: e0');
        expect(e0.hasValidValues, true);
      }
    });

    test('UL fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.uint32List(1, 10);
        final bytes0 = Bytes.fromAscii(vList.toString());
        final e0 = ULtag.fromBytes(bytes0, PTag.kSelectorFDValue);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => ULtag.fromBytes(bytes0, PTag.kSelectorFDValue),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });

    test('UL checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.uint32List(1, 1);
        final e0 = new ULtag(PTag.kNumberOfWaveformSamples, vList);
        expect(e0.checkLength(e0.values), true);
      }
    });

    test('UL checkLength', () {
      final e0 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32Max);
      expect(e0.checkLength(e0.values), true);
    });

    test('UL checkValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final e0 = new ULtag(PTag.kNumberOfWaveformSamples, vList0);
        expect(e0.checkValues(e0.values), true);
      }
    });

    test('UL checkValues', () {
      final e0 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32Max);
      expect(e0.checkValues(e0.values), true);
    });

    test('UL valuesCopy random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final e0 = new ULtag(PTag.kNumberOfWaveformSamples, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('UL valuesCopy', () {
      final e0 = new ULtag(PTag.kNumberOfWaveformSamples, uInt32Max);
      expect(uInt32Max, equals(e0.valuesCopy));
    });

    test('UL replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final bytes = new Bytes.typedDataView(vList0);
        final e0 = ULtag.fromBytes(bytes, PTag.kNumberOfWaveformSamples);
        final vList1 = rng.uint32List(1, 1);
        final e0a = e0.replace(vList1);
        expect(e0.replace(vList1), equals(vList1));
        expect(e0.values, equals(vList1));
      }

      final vList2 = rng.uint32List(1, 1);
      final e1 = new ULtag(PTag.kNumberOfWaveformSamples, vList2);
      expect(e1.replace(<int>[]), equals(vList2));
      expect(e1.values, equals(<int>[]));

      final e2 = new ULtag(PTag.kNumberOfWaveformSamples, vList2);
      expect(e2.replace(null), equals(vList2));
      expect(e2.values, equals(<int>[]));
    });

    test('UL BASE64 random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.uint32List(1, 1);
        final bytes0 = new Bytes.typedDataView(vList);
        final s = bytes0.getBase64();
        final bytes1 = Bytes.fromBase64(s);
        final e0 = ULtag.fromBytes(bytes1, PTag.kNumberOfWaveformSamples);
        expect(e0.hasValidValues, true);
      }
    });

    test('UL BASE64', () {
      final vList = new Uint32List.fromList(uInt32Max);
      final bytes = new Bytes.typedDataView(vList);
      final s = bytes.getBase64();
      final bytes1 = Bytes.fromBase64(s);
      final e0 = ULtag.fromBytes(bytes, PTag.kNumberOfWaveformSamples);
      expect(e0.hasValidValues, true);
    });

    test('UL make good values', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.uint32List(1, 1);
        final e0 = ULtag.fromValues(PTag.kNumberOfWaveformSamples, vList);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);

        final e1 = ULtag.fromValues(PTag.kNumberOfWaveformSamples, <int>[]);
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(<int>[]));
      }
    });

    test('UL make bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(2, 2);
        global.throwOnError = false;
        final make0 = ULtag.fromValues(PTag.kNumberOfWaveformSamples, vList0);
        expect(make0, isNull);

        global.throwOnError = true;
        expect(() => ULtag.fromValues(PTag.kNumberOfWaveformSamples, vList0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('UL fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
//        final vList1 = new Uint32List.fromList(vList0);
//        final vList11 = vList1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(vList0);
        final e0 = ULtag.fromBytes(bytes, PTag.kNumberOfWaveformSamples);
        expect(e0.hasValidValues, true);
        expect(e0.vfBytes, equals(bytes));
        expect(e0.values is Uint32List, true);
        expect(e0.values, equals(vList0));
      }
    });

    test('UL fromB64', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
//        final vList1 = new Uint32List.fromList(vList0);
//        final vList11 = vList1.buffer.asUint8List();
        //       final base64 = cvt.base64.encode(vList11);
        final bytes = new Bytes.typedDataView(vList0);
        final e0 = ULtag.fromBytes(bytes, PTag.kNumberOfWaveformSamples);
        expect(e0.hasValidValues, true);
      }
    });

    test('UL checkValue good values', () {
      final vList0 = rng.uint32List(1, 1);
      final e0 = new ULtag(PTag.kNumberOfWaveformSamples, vList0);

      expect(e0.checkValue(uInt32Max[0]), true);
      expect(e0.checkValue(uInt32Min[0]), true);
    });

    test('UL checkValue good values', () {
      final vList0 = rng.uint32List(1, 1);
      final e0 = new ULtag(PTag.kNumberOfWaveformSamples, vList0);
      expect(e0.checkValue(uInt32MaxPlus[0]), false);
      expect(e0.checkValue(uInt32MinMinus[0]), false);
    });

    test('UL view', () {
      final vList = rng.uint32List(10, 10);
      final e0 = new ULtag(PTag.kSelectorULValue, vList);
      for (var i = 0, j = 0; i < vList.length; i++, j += 4) {
        final e1 = e0.view(j, vList.length - i);
        log.debug('ol0: ${e0.values}, ol1: ${e1.values}, '
            'vList0.sublist(i) : ${vList.sublist(i)}');
        expect(e1.values, equals(vList.sublist(i)));
      }

      final bytes = new Bytes.typedDataView(vList);
      final e2 = ULtag.fromBytes(bytes, PTag.kSelectorULValue);
      for (var i = 0, j = 0; i < vList.length; i++, j += 4) {
        final e3 = e2.view(j, vList.length - i);
        log.debug('e: ${e0.values}, at1: ${e3.values}, '
            'vList.sublist(i) : ${vList.sublist(i)}');
        expect(e3.values, equals(vList.sublist(i)));
      }
    });
  });

  group('UL Element', () {
    //VM.k1
    const ulVM1Tags = const <PTag>[
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
    const ulVM3Tags = const <PTag>[
      PTag.kGridDimensions,
    ];

    //VM.k1_n
    const ulVM1_nTags = const <PTag>[
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

    test('UL isValidLength VM.k1 good values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.uint32List(1, 1);
        for (var tag in ulVM1Tags) {
          expect(UL.isValidLength(tag, vList), true);
          expect(UL.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(UL.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('UL isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.uint32List(2, i + 1);
        for (var tag in ulVM1Tags) {
          global.throwOnError = false;
          expect(UL.isValidLength(tag, vList), false);
          expect(UL.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => UL.isValidLength(tag, vList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
          expect(() => UL.isValidLength(tag, invalidVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('UL isValidLength VM.k3 good values', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList = rng.uint32List(3, 3);
        for (var tag in ulVM3Tags) {
          expect(UL.isValidLength(tag, vList), true);
          expect(SS.isValidLength(tag, invalidVList.take(tag.vmMax)), false);
          expect(SS.isValidLength(tag, invalidVList.take(tag.vmMin)), false);
        }
      }
    });

    test('UL isValidLength VM.k3 bad values', () {
      for (var i = 3; i < 10; i++) {
        final vList = rng.uint32List(4, i + 1);
        for (var tag in ulVM3Tags) {
          global.throwOnError = false;
          expect(UL.isValidLength(tag, vList), false);
          expect(UL.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => UL.isValidLength(tag, vList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
          expect(() => UL.isValidLength(tag, invalidVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('UL isValidLength VM.k1_n good values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.uint32List(1, i);
        for (var tag in ulVM1_nTags) {
          expect(UL.isValidLength(tag, vList), true);

          expect(UL.isValidLength(tag, invalidVList.sublist(0, UL.kMaxLength)),
              true);
        }
      }
    });

    test('UL isValidTag good values', () {
      global.throwOnError = false;
      expect(UL.isValidTag(PTag.kSelectorULValue), true);

      for (var tag in ulVM1Tags) {
        expect(UL.isValidTag(tag), true);
      }
    });

    test('UL isValidTag bad values', () {
      global.throwOnError = false;
      expect(UL.isValidTag(PTag.kSelectorUSValue), false);

      global.throwOnError = true;
      expect(() => UL.isValidTag(PTag.kSelectorUSValue),
          throwsA(const isInstanceOf<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UL.isValidTag(tag), false);

        global.throwOnError = true;
        expect(() => UL.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });

    test('UL isValidTag good values', () {
      global.throwOnError = false;
      expect(UL.isValidTag(PTag.kSelectorULValue), true);

      for (var tag in ulVM1Tags) {
        expect(UL.isValidTag(tag), true);
      }
    });

    test('UL isValidTag bad values', () {
      global.throwOnError = false;
      expect(UL.isValidTag(PTag.kSelectorUSValue), false);

      global.throwOnError = true;
      expect(() => UL.isValidTag(PTag.kSelectorUSValue),
          throwsA(const isInstanceOf<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UL.isValidTag(tag), false);

        global.throwOnError = true;
        expect(() => UL.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });

    test('UL isValidVR good values', () {
      global.throwOnError = false;
      expect(UL.isValidVRIndex(kULIndex), true);

      for (var tag in ulVM1Tags) {
        global.throwOnError = false;
        expect(UL.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('UL isValidVR bad values', () {
      expect(UL.isValidVRIndex(kAEIndex), false);
      global.throwOnError = true;
      expect(() => UL.isValidVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UL.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => UL.isValidVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });
/*

    test('UL checkVR good values', () {
      global.throwOnError = false;
      expect(UL.checkVRIndex(kULIndex), kULIndex);

      for (var tag in ulTags0) {
        global.throwOnError = false;
        expect(UL.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('UL checkVR bad values', () {
      expect(UL.checkVRIndex(kAEIndex), isNull);
      global.throwOnError = true;
      expect(() => UL.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));
      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UL.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => UL.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });
*/

    test('UL isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(UL.isValidVRIndex(kULIndex), true);

      for (var tag in ulVM1Tags) {
        global.throwOnError = false;
        expect(UL.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('UL isValidVRIndex bad values', () {
      expect(UL.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => UL.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UL.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => UL.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UL isValidVRCode good values', () {
      global.throwOnError = false;
      expect(UL.isValidVRCode(kULCode), true);

      for (var tag in ulVM1Tags) {
        expect(UL.isValidVRCode(tag.vrCode), true);
      }
    });

    test('UL isValidVRCode good values', () {
      expect(UL.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => UL.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));
      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UL.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => UL.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('UL isValidVFLength good values', () {
      expect(UL.isValidVFLength(UL.kMaxVFLength), true);
      expect(UL.isValidVFLength(0), true);
    });

    test('UL isValidVFLength bad values', () {
      global.throwOnError = false;
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
      global.throwOnError = false;
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
      global.throwOnError = false;
      const uInt32MaxPlus = const [kUint32Max + 1];
      const uInt32MinMinus = const [kUint32Min - 1];

      //VM.k1
      expect(UL.isValidValues(PTag.kLengthToEnd, uInt32MaxPlus), false);
      expect(UL.isValidValues(PTag.kLengthToEnd, uInt32MinMinus), false);

      //VM.k3
      expect(UL.isValidValues(PTag.kGridDimensions, uInt32MaxPlus), false);

      global.throwOnError = true;
      expect(() => UL.isValidValues(PTag.kLengthToEnd, uInt32MaxPlus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
      expect(() => UL.isValidValues(PTag.kLengthToEnd, uInt32MinMinus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('UL isValidValues bad values length', () {
      global.throwOnError = false;
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

      global.throwOnError = true;
      expect(() => UL.isValidValues(PTag.kLengthToEnd, uInt32MinMax),
          throwsA(const isInstanceOf<InvalidValuesError>()));
      expect(() => UL.isValidValues(PTag.kGridDimensions, uInt32Min),
          throwsA(const isInstanceOf<InvalidValuesError>()));
      expect(() => UL.isValidValues(PTag.kGridDimensions, uInt32MinMaxPlus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    /*test('UL fromList', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        expect(Uint32.fromList(vList0), vList0);
      }
      const uInt32Min = const [kUint32Min];
      const uInt32Max = const [kUint32Max];
      expect(Uint32.fromList(uInt32Min), uInt32Min);
      expect(Uint32.fromList(uInt32Max), uInt32Max);
    });

    test('UL fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
//        final vList1 = new Uint32List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(vList0);
        log
          ..debug('vList0 : $vList0')
          ..debug('Uint32Base.fromBytes(bd) ; ${Uint32.fromBytes(bytes)}');
        expect(Uint32.fromBytes(bytes), equals(vList0));
      }
    });

    test('UL toBytes', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
//        final vList1 = new Uint32List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(vList0);
        log
          ..debug('vList0 : $vList0')
          ..debug('Uint32.toBytes($bytes): '
              '${Uint32.toBytes(bytes)}');
        expect(Uint32.toBytes(vList0), equals(bytes));
      }

      const uInt32Max = const [kUint32Max];
      final vList1 = new Uint32List.fromList(uInt32Max);
//      final uint32List = vList1.buffer.asUint8List();
      final bytes = new Bytes.typedDataView(vList1);
      expect(Uint32.toBytes(uInt32Max), bytes);

      const uint64Max = const [kUint64Max];
      expect(Uint32.toBytes(uint64Max), isNull);

      global.throwOnError = true;
      expect(() => Uint32.toBytes(uint64Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('Uint32Base toByteData good values', () {
      global.level = Level.info;
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rng.uint32List(1, 1);
        final bd0 = vList0.buffer.asByteData();
        final lBd0 = Uint32.toByteData(vList0);
        log.debug('lBd0: ${lBd0.buffer.asUint8List()}, bd0: ${bd0.buffer
            .asUint8List()}');
        expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd0.buffer == bd0.buffer, true);

        final lBd1 = Uint32.toByteData(vList0, check: false);
        log.debug('lBd3: ${lBd1.buffer.asUint8List()}, '
            'bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd1.buffer == bd0.buffer, true);
      }

      const uInt32Max = const [kUint32Max];
      final uint32List = new Uint32List.fromList(uInt32Max);
      final bd1 = uint32List.buffer.asByteData();
      final lBd2 = Uint32.toByteData(uint32List);
      log.debug('bd: ${bd1.buffer.asUint8List()}, '
          'lBd2: ${lBd2.buffer.asUint8List()}');
      expect(lBd2.buffer.asUint8List(), equals(bd1.buffer.asUint8List()));
      expect(lBd2.buffer == bd1.buffer, true);
    });

    test('Uint32Base toByteData bad values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rng.uint32List(1, 1);
        final bd0 = vList0.buffer.asByteData();
        final lBd1 = Uint32.toByteData(vList0, asView: false);
        log.debug('lBd1: ${lBd1.buffer.asUint8List()}, '
            'bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd1.buffer == bd0.buffer, false);

        final lBd2 =
            Uint32.toByteData(vList0, asView: false, check: false);
        log.debug('lBd2: ${lBd2.buffer.asUint8List()}, '
            'bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd2.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd2.buffer == bd0.buffer, false);
      }

      global.throwOnError = false;
      const uInt32Max = const <int>[kUint32Max + 1];
      expect(Uint32.toByteData(uInt32Max), isNull);

      global.throwOnError = true;
      expect(() => Uint32.toByteData(uInt32Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('UL fromBase64', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(0, i);
//        final vList1 = new Uint32List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
//        final base64 = cvt.base64.encode(bd);
        final bytes = new Bytes.typedDataView(vList0);
        final base64 = bytes.getBase64();
        log.debug('UL.base64: "$base64"');

        final ulList = Uint32.fromBase64(base64);
        log.debug('  UL.decode: $ulList');
        expect(ulList, equals(vList0));
//        expect(ulList, equals(vList1));
      }
    });

    test('UL toBase64', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(0, i);
//        final vList1 = new Uint32List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
//        final s = cvt.base64.encode(bd);
        final bytes = new Bytes.typedDataView(vList0);
        final base64 = bytes.getBase64();
        expect(Uint32.toBase64(vList0), equals(base64));
      }
    });

    test('UL encodeDecodeJsonVF', () {
      global.level = Level.info;
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint32List(0, i);
//        final vList1 = new Uint32List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
        // Encode
//       final base64 = cvt.base64.encode(bd);
        final bytes = new Bytes.typedDataView(vList0);
        final base64 = bytes.getBase64();
        log.debug('UL.base64: "$base64"');
        final s = Uint32.toBase64(vList0);
        log.debug('  UL.json: "$s"');
        expect(s, equals(base64));

        // Decode
        final e0 = Uint32.fromBase64(base64);
        log.debug('UL.base64: $e0');
        final e1 = Uint32.fromBase64(s);
        log.debug('  UL.json: $e1');
        expect(e0, equals(vList0));
//        expect(e0, equals(vList1));
        expect(e0, equals(e1));
      }
    });

    test('UL fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
//        final vList1 = new Uint32List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(vList0);
        log
          ..debug('vList0 : $vList0')
          ..debug('Uint32Base.fromBytes(bd) ; ${Uint32.fromBytes(bytes)}');
        expect(Uint32.fromBytes(bytes), equals(vList0));
      }
    });

    test('UL fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
//        final vList1 = new Uint32List.fromList(vList0);
//        final byteData = vList1.buffer.asByteData();
        final bytes = new Bytes.typedDataView(vList0);
        final bd = bytes.asByteData();
        log
          ..debug('vList0 : $vList0')
          ..debug('Uint32Base.fromByteData(byteData): '
              '${Uint32.fromByteData(bd)}');
        expect(Uint32.fromByteData(bd), equals(vList0));
      }
    });*/
  });
}
