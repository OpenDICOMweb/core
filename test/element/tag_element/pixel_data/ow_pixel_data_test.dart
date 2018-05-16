//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

import 'test_pixel_data.dart';

final Bytes u8Frame = new Bytes.fromList(testFrame);
final Bytes u16Frame = new Bytes.fromList(testFrame);

// Urgent Sharath: Talk to Jim about base64 tests to decide if they are needed.
void main() {
  Server.initialize(name: 'element/ow_pixel_data_test', level: Level.debug);
  group('OW PixelData Tests', () {
    final pixels0 = new Uint16List(1024);
    for (var i = 0; i < pixels0.length; i++) pixels0[i] = 4095;

    final pixels1 = new Uint16List.fromList(pixels0);
//    final bytes1 = pixels1.buffer.asUint8List();
    final bytes1 = new Bytes.typedDataView(pixels1);

    //Urgent: why is this being done?
//    final pixels2 = new Uint16List.fromList([1024, 1024]);
//    for (var i = 0; i < pixels2.length; i++) pixels1[i] = 4095;

    //Urgent: why not like this?
    final pixels2 = new Uint16List.fromList([4095, 4095]);
    final bytes2 = new Bytes.typedDataView(pixels2);

/* Urgent Sharath: flush if not used
    final pixels3 = new Uint16List.fromList(pixels2);
//    final bytes2 = pixels3.buffer.asUint8List();
    final bytes3 = new Bytes.typedDataView(pixels2);
*/

    test('Create OWtagPixelData', () {
      final ow0 =
          new OWtagPixelData(PTag.kPixelDataOW, pixels0, pixels0.length);
      expect(ow0.tag == PTag.kPixelDataOW, true);
      expect(ow0.vrIndex == kOBOWIndex, false);
      expect(ow0.vrIndex == kOWIndex, true);
      expect(ow0.vfBytes is Bytes, true);
      expect(ow0.vfBytes.length == 2048, true);
      expect(ow0.pixels is Uint16List, true);
      expect(ow0.pixels.length == 1024, true);
      expect(ow0.length == 1024, true);
      expect(ow0.valuesCopy, equals(ow0.pixels));
      expect(ow0.typedData is Uint16List, true);

      final ow1 =
          new OWtagPixelData(PTag.kCoefficientsSDVN, pixels0, pixels0.length);
//      expect(ow1.tag == PTag.kCoefficientsSDVN, true);
//      expect(ow1.vrIndex == kOWIndex, true);
      expect(ow1, isNull);

      global.throwOnError = true;
      expect(
          () => new OWtagPixelData(
              PTag.kVariableNextDataGroup, pixels0, pixels0.length),
          throwsA(const isInstanceOf<InvalidTagError>()));

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
      global.throwOnError = false;
      final ow0 =
          new OWtagPixelData(PTag.kPixelDataOW, pixels0, pixels0.length);
      final ow1 =
          new OWtagPixelData(PTag.kPixelDataOW, pixels1, pixels1.length);
      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);

      final ow2 =
          new OWtagPixelData(PTag.kPixelDataOW, pixels2, pixels2.length);
      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);

      final ow3 =
          new OWtagPixelData(PTag.kCoefficientsSDVN, pixels2, pixels2.length);
      expect(ow3, isNull);
      final ow4 =
          new OWtagPixelData(PTag.kCoefficientsSDVN, pixels2, pixels2.length);
      expect(ow4, isNull);

/*
      expect(ow3.hashCode == ow4.hashCode, true);
      expect(ow3 == ow4, true);
      expect(ow0.hashCode == ow4.hashCode, false);
      expect(ow0 == ow4, false);
*/
    });

    test('Create  OWtagPixelData.fromBytes', () {
      global.doTestElementValidity = true;
      global.throwOnError = false;
      final ow0 =
          OWtagPixelData.fromBytes(PTag.kPixelDataOW, bytes1, bytes1.length);

      expect(ow0.tag == PTag.kPixelDataOW, true);
      expect(ow0.vrIndex == kOBOWIndex || ow0.vrIndex == kUNIndex, false);
      expect(ow0.vrIndex == kOWIndex, true);
//      expect(ow0.isEncapsulated == false, true);
      expect(ow0.vfBytes is Bytes, true);
      expect(ow0.vfBytes.length == bytes1.length, true);
      expect(ow0.pixels is Uint16List, true);
      print('first: ${ow0.pixels.first}');
      expect(ow0.pixels.first == 4095, true);
      expect(ow0.pixels.length == 1024, true);
      expect(ow0.length == ow0.pixels.length, true);
      expect(ow0.valuesCopy, equals(ow0.pixels));

      final ow1 =
          OWtag.fromBytes(PTag.kCoefficientsSDDN, bytes1, bytes1.length);
      expect(ow1.tag == PTag.kCoefficientsSDDN, true);

      print('bytes1: ${bytes1.length}');
      print('ow0.vfBytes.length: ${ow0.vfBytes.length}');

      global.throwOnError = true;
      expect(
          () => OWtagPixelData.fromBytes(
              PTag.kVariableNextDataGroup, bytes1, bytes1.length),
          throwsA(const isInstanceOf<InvalidTagError>()));

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
      global.throwOnError = false;
      final ow0 =
          OWtagPixelData.fromBytes(PTag.kPixelDataOW, bytes1, bytes1.length);
      final ow1 =
          OWtagPixelData.fromBytes(PTag.kPixelDataOW, bytes1, bytes1.length);
      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);

      final ow2 =
          OWtagPixelData.fromBytes(PTag.kPixelDataOW, bytes2, bytes2.length);
      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);

      final ow3 = OWtagPixelData.fromBytes(
          PTag.kCoefficientsSDHN, bytes2, bytes2.length);
 //     expect(ow3.hashCode == ow4.hashCode, true);
 //     expect(ow3 == ow4, true);
      expect(ow3, isNull);
      final ow4 = OWtagPixelData.fromBytes(
          PTag.kCoefficientsSDHN, bytes2, bytes2.length);

//      expect(ow0.hashCode == ow3.hashCode, false);
//      expect(ow0 == ow3, false);
      expect(ow4, isNull);

    });

    // Urgent: separate PixelDataOW from OW tests
    test('OWtagPixelData.update Test', () {
      global.throwOnError = false;

      final ow0 = new OWtagPixelData(PTag.kPixelDataOW, pixels0);
      final ow1 = ow0.update(pixels0);
      expect(ow1 == ow0, true);

      final ow2 = new OWtagPixelData(PTag.kCoefficientsSDHN, pixels0);
      expect(ow2, isNull);
//      final ow3 = ow2.update(pixels0);
//      expect(ow3 == ow2, true);
//      expect(ow3, isNull);

      final ow4 =
          OWtagPixelData.fromBytes(PTag.kPixelDataOW, bytes1, bytes1.length);
      final ow5 = ow4.update(pixels1);
      expect(ow5 == ow4, true);

      final ow6 = OWtagPixelData.fromBytes(
          PTag.kCoefficientsSDHN, bytes1, bytes1.length);
      expect(ow6, isNull);
//      final ow7 = ow6.update(pixels1);
//      expect(ow7 == ow6, true);
    });

    test('getPixelData', () {
      global.throwOnError = false;

      final pd0 = new OWtagPixelData(PTag.kPixelDataOW, [123, 101], 1);
      final ba0 = new UStag(PTag.kBitsAllocated, [16]);
      final ds = new TagRootDataset.empty()..add(pd0)..add(ba0);
      final pixels = ds.getPixelData();
      log..debug('pixels: $pixels')..debug('pixel.length: ${pixels.length}');
      expect(pixels.length == 2, true);

      final ba1 = new UStag(PTag.kBitsAllocated, []);
      final ba2 = new UStag(PTag.kBitsAllocated, []);
      final ds1 = new TagRootDataset.empty()..add(ba1);
      final pixels1 = ds1.getPixelData();
      expect(pixels1 == null, true);

      global.throwOnError = true;
      ds1.add(ba2);

      //Uint8List pixels2 = ds.getPixelData();
      expect(
          ds1.getPixelData, throwsA(const isInstanceOf<InvalidValuesError>()));

      global.throwOnError = false;
      //Missing Pixel Data
      final pd1 = new OWtagPixelData(PTag.kOverlayData, [123, 101]);
      expect(pd1, isNull);
      final ba3 = new UStag(PTag.kBitsAllocated, [16]);
      final ds2 = new TagRootDataset.empty();
//        ..add(pd1)
      ds2.add(ba3);
      global.throwOnError = true;
      expect(
          ds2.getPixelData, throwsA(const isInstanceOf<PixelDataNotPresent>()));
    });

/*
    test('Create OWtagPixelData.fromBase64', () {
      final base64 = base64.encode(u8Frame);
      final ow0 =
          OWtagPixelData.fromBase64(PTag.kPixelDataOW, base64, base64.length);
      final ow1 = OWtagPixelData.fromBase64(
          PTag.kCoefficientsSDVN, base64, base64.length);

      system.throwOnError = true;
      expect(
          () => OWtagPixelData.fromBase64(
              PTag.kVariableNextDataGroup, base64, base64.length),
          throwsA(const isInstanceOf<InvalidVRError>()));

      expect(ow0.tag == PTag.kPixelDataOW, true);
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
      final base64 = base64.encode(u8Frame);
      final ow0 =
          OWtagPixelData.fromBase64(PTag.kPixelDataOW, base64, base64.length);
      final ow1 =
          OWtagPixelData.fromBase64(PTag.kPixelDataOW, base64, base64.length);
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

    test('Create OWtagPixelData.fromValues', () {
      global.throwOnError = false;

      final ow0 = OWtagPixelData.fromValues(PTag.kPixelDataOW, pixels0);
      expect(ow0.tag == PTag.kPixelDataOW, true);
      expect(ow0.vrIndex == kOBOWIndex, false);
      expect(ow0.vrIndex == kOWIndex, true);
      expect(ow0.vfBytes is Bytes, true);
      expect(ow0.vfBytes.length == 2048, true);
      expect(ow0.pixels is Uint16List, true);
      expect(ow0.pixels.length == 1024, true);
      expect(ow0.length == 1024, true);
      expect(ow0.valuesCopy, equals(ow0.pixels));
      expect(ow0.typedData is Uint16List, true);

      final ow1 = OWtagPixelData.fromValues(PTag.kCoefficientsSDVN, pixels0);
//      expect(ow1.tag == PTag.kCoefficientsSDVN, true);
//      expect(ow1.vrIndex == kOWIndex, true);
      expect(ow1, isNull);

      global.throwOnError = true;
      expect(() => OWtagPixelData.fromValues(PTag.kSelectorSTValue, pixels0),
          throwsA(const isInstanceOf<InvalidTagError>()));


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

    test('Create OWtagPixelData.fromValues hashCode and ==', () {
      global.throwOnError = false;

      final ow0 = OWtagPixelData.fromValues(PTag.kPixelDataOW, pixels0);
      final ow1 = OWtagPixelData.fromValues(PTag.kPixelDataOW, pixels0);
      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);
      final ow2 = OWtagPixelData.fromValues(PTag.kVariablePixelData, pixels0);
      expect(ow2, isNull);

      final ow3 = OWtagPixelData.fromValues(PTag.kCoefficientsSDVN, pixels0);
      expect(ow3, isNull);

      final ow4 = OWtagPixelData.fromValues(PTag.kCoefficientsSDVN, pixels0);
      expect(ow4, isNull);

/*
      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
      expect(ow3.hashCode == ow4.hashCode, true);
      expect(ow3 == ow4, true);
      expect(ow0.hashCode == ow3.hashCode, false);
      expect(ow0 == ow3, false);
*/

    });

    test('create new OWtagPixelData.fromBytes', () {
      final ow0 =
          OWtagPixelData.fromBytes(PTag.kPixelDataOW, u8Frame, u8Frame.length);

      expect(ow0.tag == PTag.kPixelDataOW, true);

      expect(ow0.vrIndex == kOBOWIndex, false);
      expect(ow0.vrIndex == kOWIndex, true);

//      expect(ow0.isEncapsulated == false, true);
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

      final ow1 = OWtagPixelData.fromBytes(
          PTag.kCoefficientsSDVN, u8Frame, u8Frame.length);
//      expect(ow1.tag == PTag.kCoefficientsSDVN, true);
//      expect(ow1.vrIndex == kOWIndex, true);
      expect(ow1, isNull);

      global.throwOnError = true;
      expect(
          () => OWtagPixelData.fromBytes(
              PTag.kSelectorSTValue, u8Frame, u8Frame.length),
          throwsA(const isInstanceOf<InvalidTagError>()));

    });

    test('create new OWtagPixelData.fromBytes hashCode and ==', () {
      global.throwOnError = false;
      final ow0 =
          OWtagPixelData.fromBytes(PTag.kPixelDataOW, u8Frame, u8Frame.length);
      final ow1 =
          OWtagPixelData.fromBytes(PTag.kPixelDataOW, u8Frame, u8Frame.length);
      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);

      final ow2 = OWtagPixelData.fromBytes(
          PTag.kVariablePixelData, u8Frame, u8Frame.length);
      expect(ow2, isNull);
      final ow3 = OWtagPixelData.fromBytes(
          PTag.kCoefficientsSDVN, u8Frame, u8Frame.length);
      expect(ow3, isNull);
      final ow4 = OWtagPixelData.fromBytes(
          PTag.kCoefficientsSDVN, u8Frame, u8Frame.length);
      expect(ow4, isNull);


/*
      expect(ow3.hashCode == ow4.hashCode, true);
      expect(ow3 == ow4, true);
      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
      expect(ow0.hashCode == ow3.hashCode, false);
      expect(ow0 == ow3, false);
*/

    });

/*
    test('creat OWtagPixelData.fromBase64', () {
      final base64 = base64.encode(u8Frame);
      final ow0 =
          OWtagPixelData.fromBase64(PTag.kPixelDataOW, base64, base64.length);
      final ow1 = OWtagPixelData.fromBase64(
          PTag.kCoefficientsSDVN, base64, base64.length);

      system.throwOnError = true;
      expect(
          () => OWtagPixelData.fromBase64(
              PTag.kSelectorSTValue, base64, base64.length),
          throwsA(const isInstanceOf<InvalidTagError>()));

      expect(ow0.tag == PTag.kPixelDataOW, true);
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
      final base64 = base64.encode(u8Frame);
      final ow0 =
          OWtagPixelData.fromBase64(PTag.kPixelDataOW, base64, base64.length);

      final ow1 =
          OWtagPixelData.fromBase64(PTag.kPixelDataOW, base64, base64.length);

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
      final ow0 =
          new OWtagPixelData(PTag.kCoefficientsSDVN, pixels0, pixels0.length);
      expect(ow0, isNull);
/*
      final owfrom0 = OWtagPixelData.fromValues(ow0.tag, ow0.values);


      expect(owfrom0.tag == PTag.kCoefficientsSDVN, true);
      expect(owfrom0.vrIndex == kOBOWIndex, false);
      expect(owfrom0.vrIndex == kOWIndex, true);
//      expect(owfrom0.isEncapsulated == false, true);
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
*/

    });

    test('OWPixelData fromBytes', () {
      global.throwOnError = false;
      final bytes0 = new Bytes.fromList(testFrame);
      final fBytes0 = OWtagPixelData.fromBytes(PTag.kCoefficientsSDVN, bytes0);

    //  expect(fBytes0,
    //      equals(OWtagPixelData.fromBytes(PTag.kCoefficientsSDVN, bytes0)));
      expect(fBytes0, isNull);

      global.throwOnError = true;
      expect(() => OBtagPixelData.fromBytes(PTag.kSelectorAEValue, bytes0),
          throwsA(const isInstanceOf<InvalidTagError>()));


/* Urgent Sharath: fix
      expect(fBytes0.tag == PTag.kCoefficientsSDVN, true);
      expect(fBytes0.vrIndex == kOBOWIndex, false);
      expect(fBytes0.vrIndex == kOWIndex, true);
//      expect(fBytes0.isEncapsulated == false, true);
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
*/

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
      global.throwOnError = false;
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

      global.throwOnError = true;
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
      final baseFrame = [1, 2, 3];
      final frame0 = new Uint16List.fromList(baseFrame);
      log..debug('frame:$baseFrame')..debug('bdFrame: $frame0');
      final bdU8a = frame0.buffer.asUint8List();
      final s0 = base64.encode(bdU8a);
      final s1 = Uint16.toBase64(frame0);
      log..debug('  s0: $s0')..debug('frame0: $frame0');
      expect(s1, equals(s0));
      final frame1 = Uint16.fromBase64(s1);
      log.debug('owPixels0: $frame1');
      expect(frame1, equals(baseFrame));

      final bdU8b = frame1.buffer.asUint8List();
      final s2 = base64.encode(bdU8b);
      final s3 = Uint16.toBase64(frame1);
      log..debug('  b64: $s2')..debug('frame: $frame1');
      expect(s3, equals(s2));
      final frame2 = Uint16.fromBase64(s3);
      expect(frame2, equals(frame1));
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
