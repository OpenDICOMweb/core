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
          new OWtagPixelData(PTag.kPixelData, pixels0, pixels0.length);
      final ow1 = new OWtagPixelData(
          PTag.kCoefficientsSDVN, pixels0, pixels0.lengthInBytes);

      system.throwOnError = true;
      expect(
          () => new OWtagPixelData(
              PTag.kVariableNextDataGroup, pixels0, pixels0.lengthInBytes),
          throwsA(const isInstanceOf<InvalidVRError>()));

      expect(ow0.tag == PTag.kPixelData, true);
      expect(ow1.tag == PTag.kCoefficientsSDVN, true);
      expect(ow0.vrIndex == kOBOWIndex, false);
      expect(ow0.vrIndex == kOWIndex, true);
      expect(ow1.vrIndex == kOWIndex, true);
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
      final ow3 = new OWtagPixelData(
          PTag.kCoefficientsSDVN, pixels2, pixels2.lengthInBytes);
      final ow4 = new OWtagPixelData(
          PTag.kCoefficientsSDVN, pixels2, pixels2.lengthInBytes);

      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);
      expect(ow3.hashCode == ow4.hashCode, true);
      expect(ow3 == ow4, true);

      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
      expect(ow0.hashCode == ow4.hashCode, false);
      expect(ow0 == ow4, false);
    });

    test('Create  OWtagPixelData.fromBytes', () {
      final ow0 = OWtagPixelData.fromBytes(
          PTag.kPixelData, bytes1, bytes1.lengthInBytes);
      final ow1 = OWtag.fromBytes(
          PTag.kCoefficientsSDDN, bytes1, bytes1.lengthInBytes);

      print('bytes1: ${bytes1.lengthInBytes}');
      print('ow0.vfBytes.length: ${ow0.vfBytes.lengthInBytes}');
      system.throwOnError = true;
      expect(
          () => OWtagPixelData.fromBytes(
              PTag.kVariableNextDataGroup, bytes1, bytes1.lengthInBytes),
          throwsA(const isInstanceOf<InvalidVRError>()));

      expect(ow0.tag == PTag.kPixelData, true);
      expect(ow1.tag == PTag.kCoefficientsSDDN, true);
      expect(ow0.vrIndex == kOBOWIndex || ow0.vrIndex == kUNIndex, false);
      expect(ow0.vrIndex == kOWIndex, true);
      expect(ow0.isEncapsulated == false, true);
      expect(ow0.vfBytes is Uint8List, true);
      expect(ow0.vfBytes.length == bytes1.lengthInBytes, true);
      expect(ow0.pixels is Uint16List, true);
      print('first: ${ow0.pixels.first}');
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
      final ow0 = OWtagPixelData.fromBytes(
          PTag.kPixelData, bytes1, bytes1.lengthInBytes);
      final ow1 = OWtagPixelData.fromBytes(
          PTag.kPixelData, bytes1, bytes1.lengthInBytes);
      final ow2 = OWtagPixelData.fromBytes(
          PTag.kPixelData, bytes2, bytes2.lengthInBytes);
      final ow3 = OWtagPixelData.fromBytes(
          PTag.kCoefficientsSDHN, bytes2, bytes2.lengthInBytes);
      final ow4 = OWtagPixelData.fromBytes(
          PTag.kCoefficientsSDHN, bytes2, bytes2.lengthInBytes);

      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);
      expect(ow3.hashCode == ow4.hashCode, true);
      expect(ow3 == ow4, true);

      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
      expect(ow0.hashCode == ow3.hashCode, false);
      expect(ow0 == ow3, false);
    });

    test('OWtagPixelData.update Test', () {
      final ow0 = new OWtagPixelData(PTag.kPixelData, pixels0);
      final ow1 = ow0.update(pixels0);
      expect(ow1 == ow0, true);

      final ow2 = new OWtagPixelData(PTag.kCoefficientsSDHN, pixels0);
      final ow3 = ow2.update(pixels0);
      expect(ow3 == ow2, true);

      final ow4 = OWtagPixelData.fromBytes(
          PTag.kPixelData, bytes1, bytes1.lengthInBytes);
      final ow5 = ow4.update(pixels1);
      expect(ow5 == ow4, true);

      final ow6 = OWtagPixelData.fromBytes(
          PTag.kCoefficientsSDHN, bytes1, bytes1.lengthInBytes);
      final ow7 = ow6.update(pixels1);
      expect(ow7 == ow6, true);
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
          OWtagPixelData.fromBase64(PTag.kPixelData, base64, base64.length);
      final ow1 = OWtagPixelData.fromBase64(
          PTag.kCoefficientsSDVN, base64, base64.length);

      system.throwOnError = true;
      expect(
          () => OWtagPixelData.fromBase64(
              PTag.kVariableNextDataGroup, base64, base64.length),
          throwsA(const isInstanceOf<InvalidVRError>()));

      expect(ow0.tag == PTag.kPixelData, true);
      expect(ow1.tag == PTag.kCoefficientsSDVN, true);
      expect(ow0.vrIndex == kOBOWIndex, false);
      expect(ow0.vrIndex == kOWIndex, true);
      expect(ow1.vrIndex == kOWIndex, true);
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
          OWtagPixelData.fromBase64(PTag.kPixelData, base64, base64.length);
      final ow1 =
          OWtagPixelData.fromBase64(PTag.kPixelData, base64, base64.length);
      final ow2 = OWtagPixelData.fromBase64(
          PTag.kVariablePixelData, base64, base64.length);
      final ow3 = OWtagPixelData.fromBase64(
          PTag.kCoefficientsSDVN, base64, base64.length);
      final ow4 = OWtagPixelData.fromBase64(
          PTag.kCoefficientsSDVN, base64, base64.length);

      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);
      expect(ow3.hashCode == ow4.hashCode, true);
      expect(ow3 == ow4, true);

      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
      expect(ow0.hashCode == ow4.hashCode, false);
      expect(ow0 == ow4, false);
    });

    test('Create OWtagPixelData.make', () {
      final ow0 = OWtagPixelData.make(PTag.kPixelData, pixels0);
      final ow1 = OWtagPixelData.make(PTag.kCoefficientsSDVN, pixels0);

      system.throwOnError = true;
      expect(() => OWtagPixelData.make(PTag.kSelectorSTValue, pixels0),
          throwsA(const isInstanceOf<InvalidVRForTagError>()));

      expect(ow0.tag == PTag.kPixelData, true);
      expect(ow1.tag == PTag.kCoefficientsSDVN, true);
      expect(ow0.vrIndex == kOBOWIndex, false);
      expect(ow0.vrIndex == kOWIndex, true);
      expect(ow1.vrIndex == kOWIndex, true);
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
      final ow3 = OWtagPixelData.make(PTag.kCoefficientsSDVN, pixels0);
      final ow4 = OWtagPixelData.make(PTag.kCoefficientsSDVN, pixels0);

      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);
      expect(ow3.hashCode == ow4.hashCode, true);
      expect(ow3 == ow4, true);

      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
      expect(ow0.hashCode == ow3.hashCode, false);
      expect(ow0 == ow3, false);
    });

    test('create new OWtagPixelData.fromBytes', () {
      final ow0 = OWtagPixelData.fromBytes(
          PTag.kPixelData, u8Frame, u8Frame.lengthInBytes);
      final ow1 = OWtagPixelData.fromBytes(
          PTag.kCoefficientsSDVN, u8Frame, u8Frame.lengthInBytes);

      system.throwOnError = true;
      expect(
          () => OWtagPixelData.fromBytes(
              PTag.kSelectorSTValue, u8Frame, u8Frame.lengthInBytes),
          throwsA(const isInstanceOf<InvalidVRForTagError>()));

      expect(ow0.tag == PTag.kPixelData, true);
      expect(ow1.tag == PTag.kCoefficientsSDVN, true);
      expect(ow0.vrIndex == kOBOWIndex, false);
      expect(ow0.vrIndex == kOWIndex, true);
      expect(ow1.vrIndex == kOWIndex, true);
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
      final ow0 = OWtagPixelData.fromBytes(
          PTag.kPixelData, u8Frame, u8Frame.lengthInBytes);
      final ow1 = OWtagPixelData.fromBytes(
          PTag.kPixelData, u8Frame, u8Frame.lengthInBytes);
      final ow2 = OWtagPixelData.fromBytes(
          PTag.kVariablePixelData, u8Frame, u8Frame.lengthInBytes);
      final ow3 = OWtagPixelData.fromBytes(
          PTag.kCoefficientsSDVN, u8Frame, u8Frame.lengthInBytes);
      final ow4 = OWtagPixelData.fromBytes(
          PTag.kCoefficientsSDVN, u8Frame, u8Frame.lengthInBytes);

      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);
      expect(ow3.hashCode == ow4.hashCode, true);
      expect(ow3 == ow4, true);

      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
      expect(ow0.hashCode == ow3.hashCode, false);
      expect(ow0 == ow3, false);
    });

    test('creat OWtagPixelData.fromBase64', () {
      final base64 = BASE64.encode(u8Frame);
      final ow0 =
          OWtagPixelData.fromBase64(PTag.kPixelData, base64, base64.length);
      final ow1 = OWtagPixelData.fromBase64(
          PTag.kCoefficientsSDVN, base64, base64.length);

      system.throwOnError = true;
      expect(
          () => OWtagPixelData.fromBase64(
              PTag.kSelectorSTValue, base64, base64.length),
          throwsA(const isInstanceOf<InvalidVRForTagError>()));

      expect(ow0.tag == PTag.kPixelData, true);
      expect(ow1.tag == PTag.kCoefficientsSDVN, true);
      expect(ow0.vrIndex == kOBOWIndex, false);
      expect(ow0.vrIndex == kOWIndex, true);
      expect(ow1.vrIndex == kOWIndex, true);
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

    test('creat OWtagPixelData.fromBase64 hashCode and ==', () {
      final base64 = BASE64.encode(u8Frame);
      final ow0 =
          OWtagPixelData.fromBase64(PTag.kPixelData, base64, base64.length);

      final ow1 =
          OWtagPixelData.fromBase64(PTag.kPixelData, base64, base64.length);

      final ow2 = OWtagPixelData.fromBase64(
          PTag.kVariablePixelData, base64, base64.length);
      final ow3 = OWtagPixelData.fromBase64(
          PTag.kCoefficientsSDVN, base64, base64.length);
      final ow4 = OWtagPixelData.fromBase64(
          PTag.kCoefficientsSDVN, base64, base64.length);

      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);
      expect(ow3.hashCode == ow4.hashCode, true);
      expect(ow3 == ow4, true);

      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
      expect(ow0.hashCode == ow3.hashCode, false);
      expect(ow0 == ow3, false);
    });
  });

  group('OWPixelData', () {

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
    test('Create Uint16Base.listFromBytes', () {
      expect(Uint16Base.fromBytes(u8Frame), u8Frame.buffer.asUint16List());

      final frame0 = new Uint8List.fromList(testFrame0);
      expect(Uint16Base.fromBytes(frame0), frame0.buffer.asUint16List());
    });

    test('Create Uint16Base.listToBytes', () {
      system.throwOnError = false;
      final rng = new RNG(1);

      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(1, 1);
        log.debug('uInt16List0: $uInt16List0');
        expect(Uint16Base.toBytes(uInt16List0),
            uInt16List0.buffer.asUint8List());
      }

      const uInt8Max = const [kUint8Max];
      const uInt16Max = const [kUint16Max];
      const uInt32Max = const [kUint32Max];

      final ui0 = new Uint16List.fromList(uInt8Max);
      final ui1 = new Uint16List.fromList(uInt16Max);

      expect(Uint16Base.toBytes(uInt8Max), ui0.buffer.asUint8List());
      expect(Uint16Base.toBytes(uInt16Max), ui1.buffer.asUint8List());
      expect(Uint16Base.toBytes(ui1), ui1.buffer.asUint8List());

      expect(Uint16Base.toBytes(uInt32Max), isNull);

      system.throwOnError = true;
      expect(() => Uint16Base.toBytes(uInt32Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('Create OW.decodeJsonVF', () {
      //     final testPixels = new Uint16List.fromList([123]);
      final b64Pixels = Uint16Base.toBase64(u16Frame);
      final v = Uint16Base.fromBase64(b64Pixels);
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
      final b64Pixels0 = Uint16Base.toBase64(bdFrame0);
      log..debug('  b640: $b640')..debug('frame0: $bdFrame0');
      expect(b64Pixels0, equals(b640));
      final owPixels0 = Uint16Base.fromBase64(b64Pixels0);
      log.debug('owPixels0: $owPixels0');
      expect(owPixels0, equals(frame0));

      final u16FrameBytes = u16Frame.buffer.asUint8List();
      final b64 = BASE64.encode(u16FrameBytes);
      final b64Pixels = Uint16Base.toBase64(u16Frame);
      log..debug('  b64: $b64')..debug('frame: $u16Frame');
      expect(b64Pixels, equals(b64));
      final owPixels = Uint16Base.fromBase64(b64Pixels);
      expect(owPixels, equals(u16Frame));
    });

    test('Create Uint16Base.listFromBytes', () {
      expect(Uint16Base.fromBytes(u8Frame), u8Frame.buffer.asUint16List());

      final frame0 = new Uint8List.fromList(testFrame0);
      expect(Uint16Base.fromBytes(frame0), frame0.buffer.asUint16List());
    });

    test('Create Uint16Base.listFromByteData', () {
      expect(Uint16Base.fromBytes(u8Frame), u8Frame.buffer.asUint16List());
      final frame0 = new Uint8List.fromList(testFrame0);
      final bd = frame0.buffer.asByteData();

      expect(Uint16Base.fromByteData(bd), frame0.buffer.asUint16List());
    });
  });
}
