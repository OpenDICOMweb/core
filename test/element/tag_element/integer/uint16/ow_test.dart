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
  Server.initialize(name: 'element/ow_test', level: Level.debug);
  final rng = new RNG(1);
  global.throwOnError = false;

  const uInt16MinMax = const [kUint16Min, kUint16Max];
  const uInt16Min = const [kUint16Min];
  const uInt16Max = const [kUint16Max];
  const uInt16MaxPlus = const [kUint16Max + 1];
  const uInt16MinMinus = const [kUint16Min - 1];

  group('OWTag', () {
    test('OW hasValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
        final e0 = new OWtag(PTag.kRedPaletteColorLookupTableData, vList0);
        expect(e0.hasValidValues, true);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(2, 3);
        log.debug('$i: vList0: $vList0');
        final e0 = new OWtag(PTag.kRedPaletteColorLookupTableData, vList0);
        expect(e0.hasValidValues, true);
      }
    });

    test('OW hasValidValues good values', () {
      global.throwOnError = false;
      final e0 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16Min);
      final e1 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16Min);
      expect(e0.hasValidValues, true);
      expect(e1.hasValidValues, true);

      final e2 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16Max);
      final e3 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16Max);
      expect(e2.hasValidValues, true);
      expect(e3.hasValidValues, true);

      global.throwOnError = false;
      final e4 = new OWtag(PTag.kRedPaletteColorLookupTableData, []);
      expect(e4.hasValidValues, true);
      log.debug('e4:$e4');
      expect(e4.values, equals(<int>[]));
    });

    test('OW hasValidValues bad values', () {
      final e0 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16MaxPlus);
      expect(e0, isNull);

      final e1 =
          new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16MinMinus);
      expect(e1, isNull);

      final e2 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16MinMax);
      expect(e2.hasValidValues, true);

      global.throwOnError = false;
      final e3 = new OWtag(PTag.kRedPaletteColorLookupTableData, null);
      log.debug('e3: $e3');
      expect(e3, isNull);

      global.throwOnError = true;
      expect(() => new OWtag(PTag.kRedPaletteColorLookupTableData, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('OW update random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(3, 4);
        final e1 = new OWtag(PTag.kGreenPaletteColorLookupTableData, vList0);
        final vList1 = rng.uint16List(3, 4);
        expect(e1.update(vList1).values, equals(vList1));
      }
    });

    test('OW update', () {
      final e0 = new OWtag(PTag.kGreenPaletteColorLookupTableData, []);
      expect(e0.update([63457, 64357]).values, equals([63457, 64357]));

      final e1 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16Min);
      final e2 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16Min);
      final e3 = e1.update(uInt16Max);
      final e4 = e2.update(uInt16Max);
      expect(e1.values.first == e4.values.first, false);
      expect(e1 == e4, false);
      expect(e2 == e4, false);
      expect(e3 == e4, true);
    });

    test('OW noValues random', () {
      final e0 = new OWtag(PTag.kRedPaletteColorLookupTableData, []);
      final OWtag owNoValues = e0.noValues;
      expect(owNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final uint16List = rng.uint16List(3, 4);
        final e1 = new OWtag(PTag.kRedPaletteColorLookupTableData, uint16List);
        log.debug('e1: $e1');
        expect(owNoValues.values.isEmpty, true);
        log.debug('e1: ${e1.noValues}');
      }
    });

    test('OW noValues', () {
      final e0 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16Min);
      final owNoValues = e0.noValues;
      expect(owNoValues.values.isEmpty, true);
      log.debug('e0:${e0.noValues}');
    });

    test('OW copy random', () {
      for (var i = 0; i < 10; i++) {
        final uint16List = rng.uint16List(3, 4);
        final e2 = new OWtag(PTag.kRedPaletteColorLookupTableData, uint16List);
        final OWtag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('OW copy', () {
      final e0 = new OWtag(PTag.kRedPaletteColorLookupTableData, []);
      final OWtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      final e2 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16Max);
      final e3 = e2.copy;
      expect(e2 == e3, true);
      expect(e2.hashCode == e3.hashCode, true);
    });

    test('OW hashCode and == random good values', () {
      global.throwOnError = false;
      final rng = new RNG(1);
      List<int> vList0;

      for (var i = 0; i < 10; i++) {
        vList0 = rng.uint16List(1, 1);
        final e0 = new OWtag(PTag.kRedPaletteColorLookupTableData, vList0);
        final e1 = new OWtag(PTag.kRedPaletteColorLookupTableData, vList0);
        log
          ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
          ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('OW hashCode and == random bad values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList1 = rng.uint16List(1, 1);
        final e0 = new OWtag(PTag.kRedPaletteColorLookupTableData, vList1);

        final e2 = new OWtag(PTag.kGreenPaletteColorLookupTableData, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rng.uint16List(2, 3);
        final e3 = new OWtag(PTag.kRedPaletteColorLookupTableData, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);
      }
    });

    test('OW hashCode and == good values ', () {
      final e0 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16Min);
      final e1 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16Min);

      log
        ..debug('uInt16Min:$uInt16Min, e0.hash_code:${e0.hashCode}')
        ..debug('uInt16Min:$uInt16Min, e1.hash_code:${e1.hashCode}');
      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);
    });

    test('OW hashCode and == bad values ', () {
      final e0 = new OWtag(PTag.kRedPaletteColorLookupTableData, uInt16Min);

      final e2 = new OWtag(PTag.kGreenPaletteColorLookupTableData, uInt16Max);
      log.debug('uInt16Max:$uInt16Max , e2.hash_code:${e2.hashCode}');
      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);
    });

    test('OW checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
        final e0 = new OWtag(PTag.kGreenPaletteColorLookupTableData, vList0);
        expect(e0.checkLength(e0.values), true);
      }
    });

    test('OW checkLength', () {
      final e0 = new OWtag(PTag.kGreenPaletteColorLookupTableData, uInt16Max);
      expect(e0.checkLength(e0.values), true);
    });

    test('OW checkValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
        final e0 = new OWtag(PTag.kGreenPaletteColorLookupTableData, vList0);
        expect(e0.checkValues(e0.values), true);
      }
    });

    test('OW checkValues', () {
      final e0 = new OWtag(PTag.kGreenPaletteColorLookupTableData, uInt16Max);
      expect(e0.checkValues(e0.values), true);
    });

    test('OW valuesCopy random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
        final e0 = new OWtag(PTag.kGreenPaletteColorLookupTableData, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('OW valuesCopy', () {
      final e0 = new OWtag(PTag.kGreenPaletteColorLookupTableData, uInt16Min);
      expect(uInt16Min, equals(e0.valuesCopy));
    });

    test('OW replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
        final e0 = new OWtag(PTag.kGreenPaletteColorLookupTableData, vList0);
        final vList1 = rng.uint16List(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rng.uint16List(1, 1);
      final e1 = new OWtag(PTag.kGreenPaletteColorLookupTableData, vList1);
      expect(e1.replace(<int>[]), equals(vList1));
      expect(e1.values, equals(<int>[]));

      final e2 = new OWtag(PTag.kGreenPaletteColorLookupTableData, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(<int>[]));
    });

    test('OW make', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
        log.debug('vList0: $vList0');
        final e0 = OWtag.fromValues(PTag.kEdgePointIndexList, vList0);
        expect(e0.hasValidValues, true);
      }
    });

    test('OW fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
        final bytes = new Bytes.typedDataView(vList0);
        log.debug(bytes);
        final e0 =
            OWtag.fromBytes(bytes, PTag.kEdgePointIndexList, bytes.length);
        log.debug('$e0');
        e0.values;
        expect(e0.hasValidValues, true);
        expect(e0.values.length == 1, true);
        expect(e0.values, equals(vList0));
        expect(e0.vfBytes, equals(bytes));
        expect(e0.values is Uint16List, true);
        expect(e0.values, equals(vList0));

        final vList1 = rng.uint16List(2, 2);
        final bytes1 = new Bytes.typedDataView(vList1);
        final e1 =
            OWtag.fromBytes(bytes1, PTag.kEdgePointIndexList, bytes1.length);
        expect(e1.hasValidValues, true);
      }
    });

    test('OW fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.uint16List(1, 10);

        final bytes0 = new Bytes.typedDataView(vList);
        final e0 =
            OWtag.fromBytes(bytes0, PTag.kSelectorOWValue, bytes0.length);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
      }
    });

    test('OW fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.uint16List(1, 10);
//        final bytes0 = Bytes.toAscii(vList.toString());
        final bytes0 = new Bytes.typedDataView(vList);
        final e0 = OWtag.fromBytes(bytes0, PTag.kSelectorFDValue);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => OWtag.fromBytes(bytes0, PTag.kSelectorFDValue),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });

    test('OW fromB64', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
//        final vList1 = new Uint16List.fromList(vList0);
//        final uint8List11 = vList1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(vList0);
//        final base64 = cvt.base64.encode(uint8List11);
        final base64 = bytes.getBase64();
        final bytes2 = Bytes.fromBase64(base64);
        final e0 =
            OWtag.fromBytes(bytes2, PTag.kEdgePointIndexList, kUndefinedLength);
        expect(e0.hasValidValues, true);
      }
    });

    test('OW checkValue good values', () {
      final vList0 = rng.uint16List(1, 1);
      final e0 = new OWtag(PTag.kEdgePointIndexList, vList0);

      expect(e0.checkValue(uInt16Max[0]), true);
      expect(e0.checkValue(uInt16Min[0]), true);
    });

    test('OW checkValue bad values', () {
      final vList0 = rng.uint16List(1, 1);
      final e0 = new OWtag(PTag.kEdgePointIndexList, vList0);
      expect(e0.checkValue(uInt16MaxPlus[0]), false);
      expect(e0.checkValue(uInt16MinMinus[0]), false);
    });

    test('OW view', () {
      final vList0 = rng.uint16List(10, 10);
      final e0 = new OWtag(PTag.kSelectorOWValue, vList0);
      for (var i = 0, j = 0; i < vList0.length; i++, j += 2) {
        final e1 = e0.view(j, vList0.length - i);
        log.debug('e0: ${e0.values}, e1: ${e1.values}, '
            'vList0.sublist(i) : ${vList0.sublist(i)}');
        expect(e1.values, equals(vList0.sublist(i)));
      }
    });
  });

  group('OW Element', () {
    //VM.k1
    const owVM1Tags = const <PTag>[
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
    const owVM1_nTags = const <PTag>[
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

    test('OW isValidLength', () {
      global.throwOnError = false;
      final vList = rng.uint16List(1, 1);
      for (var tag in owVM1Tags) {
        expect(OW.isValidLength(tag, vList), true);
      }

      for (var tag in obowTags) {
        expect(OW.isValidLength(tag, vList), false);
      }

      expect(OW.isValidLength(PTag.kSelectorOWValue, vList), true);

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OW.isValidLength(tag, vList), false);

        global.throwOnError = true;
        expect(() => OW.isValidLength(tag, vList),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });

    test('OW isValidTag good values', () {
      global.throwOnError = false;
      expect(OW.isValidTag(PTag.kSelectorOWValue), true);
      expect(OW.isValidTag(PTag.kAudioSampleData), true);
      expect(OW.isValidTag(PTag.kGrayLookupTableData), true);

      for (var tag in owVM1Tags) {
        expect(OW.isValidTag(tag), true);
      }
      for (var tag in obowTags) {
        final e3 = OW.isValidTag(tag);
        expect(e3, true);
      }
    });

    test('OW isValidTag bad values', () {
      global.throwOnError = false;
      expect(OW.isValidTag(PTag.kSelectorAEValue), false);

      global.throwOnError = true;
      expect(() => OW.isValidTag(PTag.kSelectorAEValue),
          throwsA(const isInstanceOf<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OW.isValidTag(tag), false);

        global.throwOnError = true;
        expect(() => OW.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });

    test('OW isValidTag good values', () {
      global.throwOnError = false;
      expect(OW.isValidTag(PTag.kSelectorOWValue), true);
      expect(OW.isValidTag(PTag.kAudioSampleData), true);
      expect(OW.isValidTag(PTag.kGrayLookupTableData), true);

      for (var tag in owVM1Tags) {
        expect(OW.isValidTag(tag), true);
      }
      for (var tag in obowTags) {
        expect(OW.isValidTag(tag), true);
      }
    });

    test('OW isValidTag bad values', () {
      global.throwOnError = false;
      expect(OW.isValidTag(PTag.kSelectorAEValue), false);

      global.throwOnError = true;
      expect(() => OW.isValidTag(PTag.kSelectorAEValue),
          throwsA(const isInstanceOf<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OW.isValidTag(tag), false);

        global.throwOnError = true;
        expect(() => OW.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });

    test('OW isValidVR good values', () {
      global.throwOnError = false;
      expect(OW.isValidVRIndex(kOWIndex), true);

      for (var tag in owVM1Tags) {
        global.throwOnError = false;
        expect(OW.isValidVRIndex(tag.vrIndex), true);
      }
      for (var tag in obowTags) {
        global.throwOnError = false;
        expect(OW.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('OW isValidVR good values', () {
      for (var tag in owVM1_nTags) {
        global.throwOnError = false;
        expect(OW.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('OW isValidVR bad values', () {
      global.throwOnError = false;
      expect(OW.isValidVRIndex(kAEIndex), false);
      global.throwOnError = true;
      expect(() => OW.isValidVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OW.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => OW.isValidVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });
/*

    test('OW checkVR  good values', () {
      global.throwOnError = false;
      expect(OW.checkVRIndex(kOWIndex), kOWIndex);

      for (var tag in owTags0) {
        global.throwOnError = false;
        expect(OW.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }

      for (var tag in obowTags) {
        global.throwOnError = false;
        expect(OW.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('OW checkVR bad values', () {
      global.throwOnError = false;
      expect(OW.checkVRIndex(kAEIndex), isNull);
      global.throwOnError = true;
      expect(() => OW.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OW.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => OW.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });
*/

    test('OW.isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(OW.isValidVRIndex(kOWIndex), true);

      for (var tag in owVM1Tags) {
        global.throwOnError = false;
        expect(OW.isValidVRIndex(tag.vrIndex), true);
      }

      for (var tag in obowTags) {
        global.throwOnError = false;
        expect(OW.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('OW.isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(OW.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => OW.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OW.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => OW.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('OW isValidVRCode good values', () {
      global.throwOnError = false;
      expect(OW.isValidVRCode(kOWCode), true);

      for (var tag in owVM1Tags) {
        expect(OW.isValidVRCode(tag.vrCode), true);
      }
    });

    test('OW isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(OW.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => OW.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OW.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => OW.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('OW isValidVFLength good values', () {
      expect(OW.isValidVFLength(OW.kMaxVFLength, kUndefinedLength), true);
      expect(OW.isValidVFLength(0, 0), true);
    });

    test('OW isValidVFLength bad values', () {
      global.throwOnError = false;
      expect(OW.isValidVFLength(OW.kMaxVFLength + 1, kUndefinedLength), false);
      expect(OW.isValidVFLength(-1, 0), false);
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
      global.throwOnError = false;
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
      global.throwOnError = false;
      const uInt16MaxPlus = const [kUint16Max + 1];
      const uInt16MinMinus = const [kUint16Min - 1];

      expect(OW.isValidValues(PTag.kPixelData, uInt16MaxPlus), false);
      expect(OW.isValidValues(PTag.kBlendingLookupTableData, uInt16MinMinus),
          false);

      global.throwOnError = true;
      expect(
          () => OW.isValidValues(PTag.kBlendingLookupTableData, uInt16MaxPlus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
      expect(
          () => OW.isValidValues(PTag.kBlendingLookupTableData, uInt16MinMinus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    /*test('OW toUint16List', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
        expect(Uint16.fromList(vList0), vList0);
      }
      const uInt16Min = const [kUint16Min];
      const uInt16Max = const [kUint16Max];
      expect(Uint16.fromList(uInt16Min), uInt16Min);
      expect(Uint16.fromList(uInt16Max), uInt16Max);
    });

    test('OW fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
//        final vList1 = new Uint16List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(vList0);
        log
          ..debug('vList1 : $vList0')
          ..debug('Uint16.fromBytes(bd) ; ${Uint16.fromBytes(bytes)}');
        expect(Uint16.fromBytes(bytes), equals(vList0));
      }
    });

    test('OW toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
//        final vList1 = new Uint16List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(vList0);
        log
          ..debug('vList1 : $vList0')
          ..debug('Uint16.toBytes(vList1): '
              '${Uint16.toBytes(vList0)}');
        expect(Uint16.toBytes(vList0), equals(bytes));
      }
    });

    test('OW fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(0, i);
//        final vList1 = new Uint16List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
//        final base64 = cvt.base64.encode(bd);
        final bytes = new Bytes.typedDataView(vList0);
        final base64 = bytes.getBase64();
        log.debug('OW.base64: "$base64"');

        final owList = Uint16.fromBase64(base64);
        log.debug('  OW.decode: $owList');
        expect(owList, equals(vList0));
//        expect(owList, equals(vList1));
      }
    });

    test('OW toBase64', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(0, i);
//        final vList1 = new Uint16List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
//        final s = cvt.base64.encode(bd);
        final bytes = new Bytes.typedDataView(vList0);
        final base64 = bytes.getBase64();
        expect(Uint16.toBase64(vList0), equals(base64));
      }
    });

    test('OW encodeDecodeJsonVF', () {
      global.level = Level.info;
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint16List(0, i);
//        final vList1 = new Uint16List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
        // Encode
//        final base64 = cvt.base64.encode(bd);
        final bytes0 = new Bytes.typedDataView(vList0);
        final base64 = bytes0.getBase64();
        log.debug('OW.base64: "$base64"');
        final s = Uint16.toBase64(vList0);
        log.debug('  OW.json: "$s"');
        expect(s, equals(base64));

        // Decode
        final e0 = Uint16.fromBase64(base64);
        log.debug('OW.base64: $e0');
        final e1 = Uint16.fromBase64(s);
        log.debug('  OW.json: $e1');
        expect(e0, equals(vList0));
//        expect(e0, equals(vList1));
        expect(e0, equals(e1));
      }
    });

    test('OW fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
//        final vList1 = new Uint16List.fromList(vList0);
//        final bd = vList1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(vList0);
        log
          ..debug('vList1 : $vList0')
          ..debug('Uint16.fromBytes(bd) ; ${Uint16.fromBytes(bytes)}');
        expect(Uint16.fromBytes(bytes), equals(vList0));
      }
    });

    test('OW fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
        final vList1 = new Uint16List.fromList(vList0);
        final byteData = vList1.buffer.asByteData();
        log
          ..debug('vList1 : $vList1')
          ..debug('Uint16Base.listFromByteData(byteData): '
              '${Uint16.fromByteData(byteData)}');
        expect(Uint16.fromByteData(byteData), equals(vList1));
      }
    });*/
  });
}
