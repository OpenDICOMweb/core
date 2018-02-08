// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

import 'test_pixel_data.dart';

final Uint8List u8Frame = new Uint8List.fromList(testFrame);
final Uint16List u16Frame = new Uint16List.fromList(testFrame);

void main() {
  Server.initialize(name: 'element/ow_pixel_data_test', level: Level.info);
  group('OW PixelData Tests', () {
    final pixels0 = new Uint16List(1024);
    for (var i = 0; i < pixels0.length; i++) pixels0[i] = 4095;

    final pixels1 = new Uint16List.fromList(pixels0);
    final bytes1 = pixels1.buffer.asUint8List();

    final pixels2 = new Uint16List.fromList([1024, 1024]);
    for (var i = 0; i < pixels2.length; i++) pixels1[i] = 4095;

    final pixels3 = new Uint16List.fromList(pixels2);
    final bytes2 = pixels3.buffer.asUint8List();

    test('Create OWtagPixelData', () {
      final ow0 =
          new OWtagPixelData(PTag.kPixelData, pixels0, pixels0.lengthInBytes);

      system.throwOnError = true;
      expect(
          () => new OWtagPixelData(
              PTag.kVariableNextDataGroup, pixels0, pixels0.lengthInBytes),
          throwsA(const isInstanceOf<InvalidVRError>()));

      expect(ow0.tag == PTag.kPixelData, true);
      expect(ow0.vrIndex == kOBOWIndex, true);
      expect(ow0.isEncapsulated == false, true);
      expect(ow0.vfBytes is Uint8List, true);
      expect(ow0.vfBytes.length == 2048, true);
      expect(ow0.pixels is Uint16List, true);
      expect(ow0.pixels.length == 1024, true);
      expect(ow0.length == 1024, true);
      expect(ow0.valuesCopy, equals(ow0.pixels));
      expect(ow0.typedData is Uint16List, true);

      final s = Sha256.uint16(pixels0);
      expect(ow0.sha256, equals(ow0.update(s)));

      for (var s in u8Frame) {
        expect(ow0.checkValue(s), true);
      }

      expect(ow0.checkValue(kUint16Max), true);
      expect(ow0.checkValue(kUint16Min), true);
      expect(ow0.checkValue(kUint16Max + 1), false);
      expect(ow0.checkValue(kUint16Min - 1), false);
    });

    test('Create OWtagPixelData hashCode and ==', () {
      final ow0 =
          new OWtagPixelData(PTag.kPixelData, pixels0, pixels0.lengthInBytes);
      final ow1 =
          new OWtagPixelData(PTag.kPixelData, pixels1, pixels1.lengthInBytes);
      final ow2 =
          new OWtagPixelData(PTag.kPixelData, pixels2, pixels2.lengthInBytes);

      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);
      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
    });

    test('Create  OWtagPixelData.fromBytes', () {
      final ow0 = new OWtagPixelData.fromBytes(
          PTag.kPixelData, bytes1, bytes1.lengthInBytes);

      system.throwOnError = true;
      expect(
          () => new OWtagPixelData.fromBytes(
              PTag.kVariableNextDataGroup, bytes1, bytes1.lengthInBytes),
          throwsA(const isInstanceOf<InvalidVRError>()));

      expect(ow0.tag == PTag.kPixelData, true);
      expect(ow0.vrIndex == kOBOWIndex || ow0.vrIndex == kUNIndex, true);

      expect(ow0.isEncapsulated == false, true);
      expect(ow0.vfBytes is Uint8List, true);
      expect(ow0.vfBytes.length == bytes1.lengthInBytes, true);
      expect(ow0.pixels is Uint16List, true);
      expect(ow0.pixels.first == 4095, true);
      expect(ow0.pixels.length == 1024, true);
      expect(ow0.length == ow0.pixels.length, true);
      expect(ow0.valuesCopy, equals(ow0.pixels));

      final s = Sha256.uint16(pixels0);
      expect(ow0.sha256, equals(ow0.update(s)));

      for (var s in u8Frame) {
        expect(ow0.checkValue(s), true);
      }

      expect(ow0.checkValue(kUint16Max), true);
      expect(ow0.checkValue(kUint16Min), true);
      expect(ow0.checkValue(kUint16Max + 1), false);
      expect(ow0.checkValue(kUint16Min - 1), false);
    });

    test('Create  OWtagPixelData.fromBytes hashCode and ==', () {
      final ow0 = new OWtagPixelData.fromBytes(
          PTag.kPixelData, bytes1, bytes1.lengthInBytes);
      final ow1 = new OWtagPixelData.fromBytes(
          PTag.kPixelData, bytes1, bytes1.lengthInBytes);
      final ow2 = new OWtagPixelData.fromBytes(
          PTag.kPixelData, bytes2, bytes2.lengthInBytes);

      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);
      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
    });

    test('OWtagPixelData.update Test', () {
      final ow0 = new OWtagPixelData(PTag.kPixelData, pixels0);
      final ow1 = ow0.update(pixels0);
      expect(ow1 == ow0, true);

      final ow2 = new OWtagPixelData.fromBytes(
          PTag.kPixelData, bytes1, bytes1.lengthInBytes);
      final ow3 = ow2.update(pixels1);
      expect(ow3 == ow2, true);
    });

    test('getPixelData', () {
      final pd0 = new OWtagPixelData(PTag.kPixelData, [123, 101], 1);
      final ba0 = new UStag(PTag.kBitsAllocated, [16]);
      final ds = new TagRootDataset()..add(pd0)..add(ba0);
      final pixels = ds.getPixelData();
      log..debug('pixels: $pixels')..debug('pixel.length: ${pixels.length}');
      expect(pixels.length == 2, true);

      system.throwOnError = false;

      final ba1 = new UStag(PTag.kBitsAllocated, []);
      final ba2 = new UStag(PTag.kBitsAllocated, []);
      final ds1 = new TagRootDataset()..add(ba1);
      final pixels1 = ds1.getPixelData();
      expect(pixels1 == null, true);

      system.throwOnError = true;
      ds1.add(ba2);

      //Uint8List pixels2 = ds.getPixelData();
      expect(ds1.getPixelData,
          throwsA(const isInstanceOf<InvalidValuesLengthError>()));

      //Missing Pixel Data
      final pd1 = new OWtagPixelData(PTag.kOverlayData, [123, 101]);
      final ba3 = new UStag(PTag.kBitsAllocated, [16]);
      final ds2 = new TagRootDataset()..add(pd1)..add(ba3);
      expect(
          ds2.getPixelData, throwsA(const isInstanceOf<PixelDataNotPresent>()));
    });

    test('Create OWtagPixelData.fromBase64', () {
      final base64 = BASE64.encode(u8Frame);
      final ow0 =
          new OWtagPixelData.fromBase64(PTag.kPixelData, base64, base64.length);

      system.throwOnError = true;
      expect(
          () => new OWtagPixelData.fromBase64(
              PTag.kVariableNextDataGroup, base64, base64.length),
          throwsA(const isInstanceOf<InvalidVRError>()));

      expect(ow0.tag == PTag.kPixelData, true);
      expect(ow0.vrIndex == kOBOWIndex, true);
      expect(ow0.isEncapsulated == false, true);
      expect(ow0.vfBytes is Uint8List, true);
      expect(ow0.pixels is Uint16List, true);
      expect(ow0.length == ow0.pixels.length, true);
      expect(ow0.vfBytes.length == 139782, true);
      expect(ow0.pixels.length == 69891, true);
      expect(ow0.length == 69891, true);
      expect(ow0.valuesCopy, equals(ow0.pixels));
      expect(ow0.typedData is Uint16List, true);

      for (var s in u8Frame) {
        expect(ow0.checkValue(s), true);
      }

      expect(ow0.checkValue(kUint16Max), true);
      expect(ow0.checkValue(kUint16Min), true);
      expect(ow0.checkValue(kUint16Max + 1), false);
      expect(ow0.checkValue(kUint16Min - 1), false);
    });

    test('Create OWtagPixelData.fromBase64 hashCode and ==', () {
      final base64 = BASE64.encode(u8Frame);
      final ow0 =
          new OWtagPixelData.fromBase64(PTag.kPixelData, base64, base64.length);
      final ow1 =
          new OWtagPixelData.fromBase64(PTag.kPixelData, base64, base64.length);
      final ow2 = new OWtagPixelData.fromBase64(
          PTag.kVariablePixelData, base64, base64.length);

      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);
      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
    });

    test('Create OWtagPixelData.make', () {
      final ow0 = OWtagPixelData.make(PTag.kPixelData, pixels0);

      system.throwOnError = true;
      expect(() => OWtagPixelData.make(PTag.kSelectorSTValue, pixels0),
          throwsA(const isInstanceOf<InvalidVRForTagError>()));

      expect(ow0.tag == PTag.kPixelData, true);
      expect(ow0.vrIndex == kOBOWIndex, true);
      expect(ow0.isEncapsulated == false, true);
      expect(ow0.vfBytes is Uint8List, true);
      expect(ow0.vfBytes.length == 2048, true);
      expect(ow0.pixels is Uint16List, true);
      expect(ow0.pixels.length == 1024, true);
      expect(ow0.length == 1024, true);
      expect(ow0.valuesCopy, equals(ow0.pixels));
      expect(ow0.typedData is Uint16List, true);

      final s = Sha256.uint16(pixels0);
      expect(ow0.sha256, equals(ow0.update(s)));

      for (var s in u8Frame) {
        expect(ow0.checkValue(s), true);
      }
      expect(ow0.checkValue(kUint16Max), true);
      expect(ow0.checkValue(kUint16Min), true);
      expect(ow0.checkValue(kUint16Max + 1), false);
      expect(ow0.checkValue(kUint16Min - 1), false);
    });

    test('Create OWtagPixelData.make hashCode and ==', () {
      final ow0 = OWtagPixelData.make(PTag.kPixelData, pixels0);
      final ow1 = OWtagPixelData.make(PTag.kPixelData, pixels0);
      final ow2 = OWtagPixelData.make(PTag.kVariablePixelData, pixels0);

      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);
      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
    });

    test('create new OWtagPixelData.fromBytes', () {
      final ow0 = new OWtagPixelData.fromBytes(
          PTag.kPixelData, u8Frame, u8Frame.lengthInBytes);

      system.throwOnError = true;
      expect(
          () => new OWtagPixelData.fromBytes(
              PTag.kSelectorSTValue, u8Frame, u8Frame.lengthInBytes),
          throwsA(const isInstanceOf<InvalidVRForTagError>()));

      expect(ow0.tag == PTag.kPixelData, true);
      expect(ow0.vrIndex == kOBOWIndex, true);
      expect(ow0.isEncapsulated == false, true);
      expect(ow0.vfBytes is Uint8List, true);
      expect(ow0.vfBytes.length == 139782, true);
      expect(ow0.pixels is Uint16List, true);
      expect(ow0.pixels.length == 69891, true);
      expect(ow0.length == 69891, true);
      expect(ow0.valuesCopy, equals(ow0.pixels));
      expect(ow0.typedData is Uint16List, true);

      for (var s in u8Frame) {
        expect(ow0.checkValue(s), true);
      }
      expect(ow0.checkValue(kUint16Max), true);
      expect(ow0.checkValue(kUint16Min), true);
      expect(ow0.checkValue(kUint16Max + 1), false);
      expect(ow0.checkValue(kUint16Min - 1), false);
    });

    test('create new OWtagPixelData.fromBytes hashCode and ==', () {
      final ow0 = new OWtagPixelData.fromBytes(
          PTag.kPixelData, u8Frame, u8Frame.lengthInBytes);
      final ow1 = new OWtagPixelData.fromBytes(
          PTag.kPixelData, u8Frame, u8Frame.lengthInBytes);
      final ow2 = new OWtagPixelData.fromBytes(
          PTag.kVariablePixelData, u8Frame, u8Frame.lengthInBytes);

      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);

      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
    });

    test('creat OWtagPixelData.fromB64', () {
      final base64 = BASE64.encode(u8Frame);
      final ow0 =
          OWtagPixelData.fromB64(PTag.kPixelData, base64, base64.length);

      system.throwOnError = true;
      expect(
          () => OWtagPixelData.fromB64(
              PTag.kSelectorSTValue, base64, base64.length),
          throwsA(const isInstanceOf<InvalidVRForTagError>()));

      expect(ow0.tag == PTag.kPixelData, true);
      expect(ow0.vrIndex == kOBOWIndex, true);
      expect(ow0.isEncapsulated == false, true);
      expect(ow0.vfBytes is Uint8List, true);
      expect(ow0.vfBytes.length == 139782, true);
      expect(ow0.pixels is Uint16List, true);
      expect(ow0.pixels.length == 69891, true);
      expect(ow0.length == 69891, true);
      expect(ow0.valuesCopy, equals(ow0.pixels));
      expect(ow0.typedData is Uint16List, true);

      for (var s in u8Frame) {
        expect(ow0.checkValue(s), true);
      }
      expect(ow0.checkValue(kUint16Max), true);
      expect(ow0.checkValue(kUint16Min), true);
      expect(ow0.checkValue(kUint16Max + 1), false);
      expect(ow0.checkValue(kUint16Min - 1), false);
    });

    test('creat OWtagPixelData.fromB64 hashCode and ==', () {
      final base64 = BASE64.encode(u8Frame);
      final ow0 =
          OWtagPixelData.fromB64(PTag.kPixelData, base64, base64.length);

      final ow1 =
          OWtagPixelData.fromB64(PTag.kPixelData, base64, base64.length);

      final ow2 = OWtagPixelData.fromB64(
          PTag.kVariablePixelData, base64, base64.length);

      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);

      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
    });
  });

  group('OWPixelData', () {
    final owTags = <PTag>[
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
      PTag.kVariableCoefficientsSDDN,
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

    final otherTags = <PTag>[
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

    const testFrame0 = const <int>[
      255,
      79,
      255,
      81,
      0,
      41,
      0,
      451,
      6510,
      45600,
    ];

    test('Create OW.isValidTag', () {
      final ow0 = Tag.isValidVR(PTag.kPixelData, OW.kVRIndex);
      expect(ow0, true);

      system.throwOnError = false;
      for (var tag in owTags) {
        final ow1 = OW.isValidTag(tag);
        expect(ow1, true);
      }
      //VR.UN
      final ow2 = OW.isValidTag(PTag.kNoName0);
      expect(ow2, true);

      for (var tag in obowTags) {
        final ow3 = OW.isValidTag(tag);
        expect(ow3, true);
      }

      for (var tag in otherTags) {
        system.throwOnError = false;
        final ow4 = OW.isValidTag(tag);
        expect(ow4, false);

        system.throwOnError = true;
        expect(() => OW.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('Create OW.checkVR', () {
      system.throwOnError = false;
      expect(OW.checkVRIndex(kOWIndex), kOWIndex);
      expect(OW.checkVRIndex(kAEIndex), isNull);

      system.throwOnError = true;
      expect(() => OW.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in owTags) {
        system.throwOnError = false;
        expect(OW.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OW.checkVRIndex(tag.vrIndex), isNull);

        system.throwOnError = true;
        expect(() => OW.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('Create OW.isValidVRIndex', () {
      system.throwOnError = false;
      expect(OW.isValidVRIndex(kOWIndex), true);
      expect(OW.isValidVRIndex(kCSIndex), false);

      system.throwOnError = true;
      expect(() => OW.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in owTags) {
        expect(OW.isValidVRIndex(tag.vrIndex), true);
      }

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OW.isValidVRIndex(tag.vrIndex), false);

        system.throwOnError = true;
        expect(() => OW.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('Create OW.isValidVRCode', () {
      system.throwOnError = false;
      expect(OW.isValidVRCode(kOWCode), true);
      expect(OW.isValidVRCode(kAECode), false);

      system.throwOnError = true;
      expect(() => OW.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in owTags) {
        expect(OW.isValidVRCode(tag.vrCode), true);
        expect(OW.isValidVRIndex(tag.vrIndex), true);
      }

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OW.isValidVRCode(tag.vrCode), false);
        expect(OW.isValidVRIndex(tag.vrIndex), false);

        system.throwOnError = true;
        expect(() => OW.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
        expect(() => OW.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('Create OW.isValidVFLength', () {
      system.throwOnError = false;
      expect(OW.isValidVFLength(OW.kMaxVFLength), true);
      expect(OW.isValidVFLength(OW.kMaxVFLength + 1), false);

      expect(OW.isValidVFLength(0), true);
      expect(OW.isValidVFLength(-1), false);
    });

    test('Create OW.isValidValue', () {
      expect(OW.isValidValue(OW.kMinValue), true);
      expect(OW.isValidValue(OW.kMinValue - 1), false);

      expect(OW.isValidValue(OW.kMaxValue), true);
      expect(OW.isValidValue(OW.kMaxValue + 1), false);
    });

    test('Create OW.isValidValues', () {
      system.throwOnError = false;
      const uInt16Min = const [kUint16Min];
      const uInt16Max = const [kUint16Max];
      const uInt16MaxPlus = const [kUint16Max + 1];
      const uInt16MinMinus = const [kUint16Min - 1];

      expect(OW.isValidValues(PTag.kPixelData, uInt16Min), true);
      expect(OW.isValidValues(PTag.kPixelData, uInt16Max), true);
      expect(OW.isValidValues(PTag.kPixelData, uInt16MaxPlus), false);
      expect(OW.isValidValues(PTag.kPixelData, uInt16MinMinus), false);

      system.throwOnError = true;
      expect(() => OW.isValidValues(PTag.kPixelData, uInt16MaxPlus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
      expect(() => OW.isValidValues(PTag.kPixelData, uInt16MinMinus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('Create Uint16Base.listFromBytes', () {
      expect(Uint16Base.listFromBytes(u8Frame), u8Frame.buffer.asUint16List());

      final frame0 = new Uint8List.fromList(testFrame0);
      expect(Uint16Base.listFromBytes(frame0), frame0.buffer.asUint16List());
    });

    test('Create Uint16Base.listToBytes', () {
      system.throwOnError = false;
      final rng = new RNG(1);

      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(1, 1);
        log.debug('uInt16List0: $uInt16List0');
        expect(Uint16Base.listToBytes(uInt16List0),
            uInt16List0.buffer.asUint8List());
      }

      const uInt8Max = const [kUint8Max];
      const uInt16Max = const [kUint16Max];
      const uInt32Max = const [kUint32Max];

      final ui0 = new Uint16List.fromList(uInt8Max);
      final ui1 = new Uint16List.fromList(uInt16Max);

      expect(Uint16Base.listToBytes(uInt8Max), ui0.buffer.asUint8List());
      expect(Uint16Base.listToBytes(uInt16Max), ui1.buffer.asUint8List());
      expect(Uint16Base.listToBytes(ui1), ui1.buffer.asUint8List());

      expect(Uint16Base.listToBytes(uInt32Max), isNull);

      system.throwOnError = true;
      expect(() => Uint16Base.listToBytes(uInt32Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('Create OW.decodeJsonVF', () {
      //     final testPixels = new Uint16List.fromList([123]);
      final b64Pixels = Uint16Base.listToBase64(u16Frame);
      final v = Uint16Base.listFromBase64(b64Pixels);
      log
        ..debug(' u16Frame: $u16Frame')
        ..debug('b64Pixels: $b64Pixels')
        ..debug(v);
      expect(v, equals(u16Frame));
    });

    test('Create Uint16Base.listToBase64', () {
      //  system.level = Level.debug;;
      final frame0 = [1, 2, 3];
      final bdFrame0 = new Uint16List.fromList(frame0);
      log..debug('frame:$frame0')..debug('bdFrame: $bdFrame0');
      final bdU8 = bdFrame0.buffer.asUint8List();
      final b640 = BASE64.encode(bdU8);
      final b64Pixels0 = Uint16Base.listToBase64(bdFrame0);
      log..debug('  b640: $b640')..debug('frame0: $bdFrame0');
      expect(b64Pixels0, equals(b640));
      final owPixels0 = Uint16Base.listFromBase64(b64Pixels0);
      log.debug('owPixels0: $owPixels0');
      expect(owPixels0, equals(frame0));

      final u16FrameBytes = u16Frame.buffer.asUint8List();
      final b64 = BASE64.encode(u16FrameBytes);
      final b64Pixels = Uint16Base.listToBase64(u16Frame);
      log..debug('  b64: $b64')..debug('frame: $u16Frame');
      expect(b64Pixels, equals(b64));
      final owPixels = Uint16Base.listFromBase64(b64Pixels);
      expect(owPixels, equals(u16Frame));
    });

    test('Create Uint16Base.listFromBytes', () {
      expect(Uint16Base.listFromBytes(u8Frame), u8Frame.buffer.asUint16List());

      final frame0 = new Uint8List.fromList(testFrame0);
      expect(Uint16Base.listFromBytes(frame0), frame0.buffer.asUint16List());
    });

    test('Create Uint16Base.listFromByteData', () {
      expect(Uint16Base.listFromBytes(u8Frame), u8Frame.buffer.asUint16List());
      final frame0 = new Uint8List.fromList(testFrame0);
      final bd = frame0.buffer.asByteData();

      expect(Uint16Base.listFromByteData(bd), frame0.buffer.asUint16List());
    });
  });
}
