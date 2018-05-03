//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:convert' as cvt;
import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

import 'test_pixel_data.dart';

final Bytes u8Frame = new Bytes.fromList(testFrame);
final Bytes u16Frame = new Bytes.fromList(testFrame);

// Urgent Sharath: Talk to Jim about base64 tests to decide if they are needed.
void main() {
  Server.initialize(name: 'element/ow_pixel_data_test', level: Level.info);
  group('OW PixelData Tests', () {
    final pixels0 = new Uint16List(1024);
    for (var i = 0; i < pixels0.length; i++) pixels0[i] = 4095;

    final pixels1 = new Uint16List.fromList(pixels0);
//    final bytes1 = pixels1.buffer.asUint8List();
    final bytes1 = new Bytes.typedDataView(pixels1);

    final pixels2 = new Uint16List.fromList([1024, 1024]);
    for (var i = 0; i < pixels2.length; i++) pixels1[i] = 4095;
    final bytes2 = new Bytes.typedDataView(pixels2);

/* Urgent Sharath: flush if not used
    final pixels3 = new Uint16List.fromList(pixels2);
//    final bytes2 = pixels3.buffer.asUint8List();
    final bytes3 = new Bytes.typedDataView(pixels2);
*/

    test('Create OWtagPixelData', () {
      final ow0 = new OWtagPixelData(PTag.kPixelData, pixels0, pixels0.length);
      final ow1 = new OWtagPixelData(
          PTag.kCoefficientsSDVN, pixels0, pixels0.length);

      system.throwOnError = true;
      expect(
          () => new OWtagPixelData(
              PTag.kVariableNextDataGroup, pixels0, pixels0.length),
          throwsA(const isInstanceOf<InvalidVRError>()));

      expect(ow0.tag == PTag.kPixelData, true);
      expect(ow1.tag == PTag.kCoefficientsSDVN, true);
      expect(ow0.vrIndex == kOBOWIndex, false);
      expect(ow0.vrIndex == kOWIndex, true);
      expect(ow1.vrIndex == kOWIndex, true);
      expect(ow0.isEncapsulated == false, true);
      expect(ow0.vfBytes is Bytes, true);
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
          new OWtagPixelData(PTag.kPixelData, pixels0, pixels0.length);
      final ow1 =
          new OWtagPixelData(PTag.kPixelData, pixels1, pixels1.length);
      final ow2 =
          new OWtagPixelData(PTag.kPixelData, pixels2, pixels2.length);
      final ow3 = new OWtagPixelData(
          PTag.kCoefficientsSDVN, pixels2, pixels2.length);
      final ow4 = new OWtagPixelData(
          PTag.kCoefficientsSDVN, pixels2, pixels2.length);

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
          PTag.kPixelData, bytes1, bytes1.length);
      final ow1 = OWtag.fromBytes(
          PTag.kCoefficientsSDDN, bytes1, bytes1.length);

      print('bytes1: ${bytes1.length}');
      print('ow0.vfBytes.length: ${ow0.vfBytes.length}');
      system.throwOnError = true;
      expect(
          () => OWtagPixelData.fromBytes(
              PTag.kVariableNextDataGroup, bytes1, bytes1.length),
          throwsA(const isInstanceOf<InvalidVRError>()));

      expect(ow0.tag == PTag.kPixelData, true);
      expect(ow1.tag == PTag.kCoefficientsSDDN, true);
      expect(ow0.vrIndex == kOBOWIndex || ow0.vrIndex == kUNIndex, false);
      expect(ow0.vrIndex == kOWIndex, true);
      expect(ow0.isEncapsulated == false, true);
      expect(ow0.vfBytes is Bytes, true);
      expect(ow0.vfBytes.length == bytes1.length, true);
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
          PTag.kPixelData, bytes1, bytes1.length);
      final ow1 = OWtagPixelData.fromBytes(
          PTag.kPixelData, bytes1, bytes1.length);
      final ow2 = OWtagPixelData.fromBytes(
          PTag.kPixelData, bytes2, bytes2.length);
      final ow3 = OWtagPixelData.fromBytes(
          PTag.kCoefficientsSDHN, bytes2, bytes2.length);
      final ow4 = OWtagPixelData.fromBytes(
          PTag.kCoefficientsSDHN, bytes2, bytes2.length);

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
          PTag.kPixelData, bytes1, bytes1.length);
      final ow5 = ow4.update(pixels1);
      expect(ow5 == ow4, true);

      final ow6 = OWtagPixelData.fromBytes(
          PTag.kCoefficientsSDHN, bytes1, bytes1.length);
      final ow7 = ow6.update(pixels1);
      expect(ow7 == ow6, true);
    });

    test('getPixelData', () {
      final pd0 = new OWtagPixelData(PTag.kPixelData, [123, 101], 1);
      final ba0 = new UStag(PTag.kBitsAllocated, [16]);
      final ds = new TagRootDataset.empty()..add(pd0)..add(ba0);
      final pixels = ds.getPixelData();
      log..debug('pixels: $pixels')..debug('pixel.length: ${pixels.length}');
      expect(pixels.length == 2, true);

      system.throwOnError = false;

      final ba1 = new UStag(PTag.kBitsAllocated, []);
      final ba2 = new UStag(PTag.kBitsAllocated, []);
      final ds1 = new TagRootDataset.empty()..add(ba1);
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
      final ds2 = new TagRootDataset.empty()..add(pd1)..add(ba3);
      expect(
          ds2.getPixelData, throwsA(const isInstanceOf<PixelDataNotPresent>()));
    });

/*
    test('Create OWtagPixelData.fromBase64', () {
      final base64 = cvt.base64.encode(u8Frame);
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
      expect(ow0.vfBytes is Bytes, true);
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
*/

/*
    test('Create OWtagPixelData.fromBase64 hashCode and ==', () {
      final base64 = cvt.base64.encode(u8Frame);
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
*/

    test('Create OWtagPixelData.make', () {
      final ow0 = OWtagPixelData.fromValues(PTag.kPixelData, pixels0);
      final ow1 = OWtagPixelData.fromValues(PTag.kCoefficientsSDVN, pixels0);

      system.throwOnError = true;
      expect(() => OWtagPixelData.fromValues(PTag.kSelectorSTValue, pixels0),
          throwsA(const isInstanceOf<InvalidVRForTagError>()));

      expect(ow0.tag == PTag.kPixelData, true);
      expect(ow1.tag == PTag.kCoefficientsSDVN, true);
      expect(ow0.vrIndex == kOBOWIndex, false);
      expect(ow0.vrIndex == kOWIndex, true);
      expect(ow1.vrIndex == kOWIndex, true);
      expect(ow0.isEncapsulated == false, true);
      expect(ow0.vfBytes is Bytes, true);
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
      final ow0 = OWtagPixelData.fromValues(PTag.kPixelData, pixels0);
      final ow1 = OWtagPixelData.fromValues(PTag.kPixelData, pixels0);
      final ow2 = OWtagPixelData.fromValues(PTag.kVariablePixelData, pixels0);
      final ow3 = OWtagPixelData.fromValues(PTag.kCoefficientsSDVN, pixels0);
      final ow4 = OWtagPixelData.fromValues(PTag.kCoefficientsSDVN, pixels0);

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
          PTag.kPixelData, u8Frame, u8Frame.length);
      final ow1 = OWtagPixelData.fromBytes(
          PTag.kCoefficientsSDVN, u8Frame, u8Frame.length);

      system.throwOnError = true;
      expect(
          () => OWtagPixelData.fromBytes(
              PTag.kSelectorSTValue, u8Frame, u8Frame.length),
          throwsA(const isInstanceOf<InvalidVRForTagError>()));

      expect(ow0.tag == PTag.kPixelData, true);
      expect(ow1.tag == PTag.kCoefficientsSDVN, true);
      expect(ow0.vrIndex == kOBOWIndex, false);
      expect(ow0.vrIndex == kOWIndex, true);
      expect(ow1.vrIndex == kOWIndex, true);
      expect(ow0.isEncapsulated == false, true);
      expect(ow0.vfBytes is Bytes, true);
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
          PTag.kPixelData, u8Frame, u8Frame.length);
      final ow1 = OWtagPixelData.fromBytes(
          PTag.kPixelData, u8Frame, u8Frame.length);
      final ow2 = OWtagPixelData.fromBytes(
          PTag.kVariablePixelData, u8Frame, u8Frame.length);
      final ow3 = OWtagPixelData.fromBytes(
          PTag.kCoefficientsSDVN, u8Frame, u8Frame.length);
      final ow4 = OWtagPixelData.fromBytes(
          PTag.kCoefficientsSDVN, u8Frame, u8Frame.length);

      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);
      expect(ow3.hashCode == ow4.hashCode, true);
      expect(ow3 == ow4, true);

      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
      expect(ow0.hashCode == ow3.hashCode, false);
      expect(ow0 == ow3, false);
    });

/*
    test('creat OWtagPixelData.fromBase64', () {
      final base64 = cvt.base64.encode(u8Frame);
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
      expect(ow0.vfBytes is Bytes, true);
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
*/

/*
    test('creat OWtagPixelData.fromBase64 hashCode and ==', () {
      final base64 = cvt.base64.encode(u8Frame);
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
*/

    test('OWPixelData from', () {
      final ow0 = new OWtagPixelData(
          PTag.kCoefficientsSDVN, pixels0, pixels0.length);
      final owfrom0 = OWtagPixelData.fromValues(ow0.tag, ow0.values);

      expect(owfrom0.tag == PTag.kCoefficientsSDVN, true);
      expect(owfrom0.vrIndex == kOBOWIndex, false);
      expect(owfrom0.vrIndex == kOWIndex, true);
      expect(owfrom0.isEncapsulated == false, true);
      expect(owfrom0.vfBytes is Bytes, true);
      expect(owfrom0.vfBytes.length == 2048, true);
      expect(owfrom0.pixels is Uint16List, true);
      expect(owfrom0.pixels.length == 1024, true);
      expect(owfrom0.length == 1024, true);
      expect(owfrom0.valuesCopy, equals(owfrom0.pixels));
      expect(owfrom0.typedData is Uint16List, true);

      final s = Sha256.uint16(pixels0);
      expect(owfrom0.sha256, equals(owfrom0.update(s)));

      for (var s in u8Frame) {
        expect(owfrom0.checkValue(s), true);
      }

      expect(owfrom0.checkValue(kUint16Max), true);
      expect(owfrom0.checkValue(kUint16Min), true);
      expect(owfrom0.checkValue(kUint16Max + 1), false);
      expect(owfrom0.checkValue(kUint16Min - 1), false);
    });

    test('OWPixelData fromBytes', () {
      final bytes0 = new Bytes.fromList(testFrame);
      final fBytes0 = OWtagPixelData.fromBytes(PTag.kCoefficientsSDVN, bytes0);

      expect(fBytes0,
          equals(OWtagPixelData.fromBytes(PTag.kCoefficientsSDVN, bytes0)));

      system.throwOnError = true;
      expect(() => OBtagPixelData.fromBytes(PTag.kSelectorAEValue, bytes0),
          throwsA(const isInstanceOf<InvalidVRForTagError>()));

      expect(fBytes0.tag == PTag.kCoefficientsSDVN, true);
      expect(fBytes0.vrIndex == kOBOWIndex, false);
      expect(fBytes0.vrIndex == kOWIndex, true);
      expect(fBytes0.isEncapsulated == false, true);
      expect(fBytes0.vfBytes is Bytes, true);
      expect(fBytes0.vfBytes.length == 139782, true);
      expect(fBytes0.pixels is Uint16List, true);
      expect(fBytes0.pixels.length == 69891, true);
      expect(fBytes0.length == 69891, true);
      expect(fBytes0.valuesCopy, equals(fBytes0.pixels));
      expect(fBytes0.typedData is Uint16List, true);

      expect(fBytes0.checkValue(kUint16Max), true);
      expect(fBytes0.checkValue(kUint16Min), true);
      expect(fBytes0.checkValue(kUint16Max + 1), false);
      expect(fBytes0.checkValue(kUint16Min - 1), false);
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
      expect(Uint16.fromBytes(u8Frame), u8Frame.buffer.asUint16List());

      final frame0 = new Bytes.fromList(testFrame0);
      expect(Uint16.fromBytes(frame0), frame0.buffer.asUint16List());
    });

    test('Create Uint16Base.listToBytes', () {
      system.throwOnError = false;
      final rng = new RNG(1);

      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(1, 1);
        log.debug('uInt16List0: $uInt16List0');
        expect(Uint16.toBytes(uInt16List0), uInt16List0.buffer.asUint8List());
      }

      const uInt8Max = const [kUint8Max];
      const uInt16Max = const [kUint16Max];
      const uInt32Max = const [kUint32Max];

      final ui0 = new Uint16List.fromList(uInt8Max);
      final ui1 = new Uint16List.fromList(uInt16Max);

      expect(Uint16.toBytes(uInt8Max), ui0.buffer.asUint8List());
      expect(Uint16.toBytes(uInt16Max), ui1.buffer.asUint8List());
      expect(Uint16.toBytes(ui1), ui1.buffer.asUint8List());

      expect(Uint16.toBytes(uInt32Max), isNull);

      system.throwOnError = true;
      expect(() => Uint16.toBytes(uInt32Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('Create OW.decodeJsonVF', () {
      //     final testPixels = new Uint16List.fromList([123]);
      final b64Pixels = Uint16.toBase64(u16Frame);
      final v = Uint16.fromBase64(b64Pixels);
      log
        ..debug(' u16Frame: $u16Frame')
        ..debug('b64Pixels: $b64Pixels')
        ..debug(v);
      expect(v, equals(u16Frame));
    });

    test('Create Uint16Base.listToBase64', () {
      //  system.level = Level.info;;
      final frame0 = [1, 2, 3];
      final bdFrame0 = new Uint16List.fromList(frame0);
      log..debug('frame:$frame0')..debug('bdFrame: $bdFrame0');
      final bdU8 = bdFrame0.buffer.asUint8List();
      final b640 = cvt.base64.encode(bdU8);
      final b64Pixels0 = Uint16.toBase64(bdFrame0);
      log..debug('  b640: $b640')..debug('frame0: $bdFrame0');
      expect(b64Pixels0, equals(b640));
      final owPixels0 = Uint16.fromBase64(b64Pixels0);
      log.debug('owPixels0: $owPixels0');
      expect(owPixels0, equals(frame0));

      final u16FrameBytes = u16Frame.buffer.asUint8List();
      final b64 = cvt.base64.encode(u16FrameBytes);
      final b64Pixels = Uint16.toBase64(u16Frame);
      log..debug('  b64: $b64')..debug('frame: $u16Frame');
      expect(b64Pixels, equals(b64));
      final owPixels = Uint16.fromBase64(b64Pixels);
      expect(owPixels, equals(u16Frame));
    });

    test('Create Uint16Base.listFromBytes', () {
      expect(Uint16.fromBytes(u8Frame), u8Frame.buffer.asUint16List());

      final frame0 = new Bytes.fromList(testFrame0);
      expect(Uint16.fromBytes(frame0), frame0.buffer.asUint16List());
    });

    test('Create Uint16Base.listFromByteData', () {
      expect(Uint16.fromBytes(u8Frame), u8Frame.buffer.asUint16List());
      final frame0 = new Uint8List.fromList(testFrame0);
      final bd = frame0.buffer.asByteData();

      expect(Uint16.fromByteData(bd), frame0.buffer.asUint16List());
    });
  });
}
