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
  Server.initialize(name: 'element/ow_pixel_data_test', level: Level.info);
  group('OW PixelData Tests', () {
    final pixels0 = new Uint16List(1024);
    for (var i = 0; i < pixels0.length; i++) pixels0[i] = 4095;

    final pixels1 = new Uint16List.fromList(pixels0);
//    final bytes1 = pixels1.buffer.asUint8List();
    final bytes1 = new Bytes.typedDataView(pixels1);

    //Urgent Sharath: why is this being done?
//    final pixels2 = new Uint16List.fromList([1024, 1024]);
//    for (var i = 0; i < pixels2.length; i++) pixels1[i] = 4095;

    //Urgent Sharath: why not like this?
    final pixels2 = new Uint16List.fromList([4095, 4095]);
//    final bytes2 = new Bytes.typedDataView(pixels2);

/* Urgent Sharath: flush if not used
    final pixels3 = new Uint16List.fromList(pixels2);
//    final bytes2 = pixels3.buffer.asUint8List();
    final bytes3 = new Bytes.typedDataView(pixels2);
*/

    test('Create OWtagPixelData', () {
      final ow0 = new OWtagPixelData(pixels0);
      expect(ow0.tag == PTag.kPixelDataOW, true);
      expect(ow0.vrIndex == kOBOWIndex, false);
      expect(ow0.vrIndex == kOWIndex, true);
      expect(ow0.vfBytes is Bytes, true);
      expect(ow0.vfBytes.length == 2048, true);
      expect(ow0.values is Uint16List, true);
      expect(ow0.values.length == 1024, true);
      expect(ow0.length == 1024, true);
      expect(ow0.valuesCopy, equals(ow0.values));
      expect(ow0.typedData is Uint16List, true);

      global.throwOnError = true;

/*
      expect(
          () => new OWtagPixelData(
              PTag.kVariableNextDataGroup, pixels0, pixels0.length),
          throwsA(const TypeMatcher<InvalidTagError>()));

*/
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
      final ow0 = new OWtagPixelData(pixels0);
      final ow1 = new OWtagPixelData(pixels1);
      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);

      final ow2 = new OWtagPixelData(pixels2);
      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);

/*
      final ow3 =
          new OWtagPixelData(PTag.kCoefficientsSDVN, pixels2);
      expect(ow3, isNull);
      final ow4 =
          new OWtagPixelData(PTag.kCoefficientsSDVN, pixels2);
      expect(ow4, isNull);

      expect(ow3.hashCode == ow4.hashCode, true);
      expect(ow3 == ow4, true);
      expect(ow0.hashCode == ow4.hashCode, false);
      expect(ow0 == ow4, false);
*/
    });

    test('Create  OWtagPixelData.fromBytes', () {
      global.doTestElementValidity = true;
      global.throwOnError = false;
      final ow0 = OWtagPixelData.fromBytes(bytes1);

      expect(ow0.tag == PTag.kPixelDataOW, true);
      expect(ow0.vrIndex == kOBOWIndex || ow0.vrIndex == kUNIndex, false);
      expect(ow0.vrIndex == kOWIndex, true);
//      expect(ow0.isEncapsulated == false, true);
      expect(ow0.vfBytes is Bytes, true);
      expect(ow0.vfBytes.length == bytes1.length, true);
      expect(ow0.values is Uint16List, true);
      expect(ow0.values.first == 4095, true);
      expect(ow0.values.length == 1024, true);
      expect(ow0.length == ow0.values.length, true);
      expect(ow0.valuesCopy, equals(ow0.values));

/*
      final ow1 =
          OWtag.fromBytes(bytes1, PTag.kCoefficientsSDDN, bytes1.length);
      expect(ow1.tag == PTag.kCoefficientsSDDN, true);

      global.throwOnError = true;
      expect(
          () => OWtagPixelData.fromBytes(
              bytes1, PTag.kVariableNextDataGroup, bytes1.length),
          throwsA(const TypeMatcher<InvalidTagError>()));
*/

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
      final ow0 = OWtagPixelData.fromBytes(bytes1);
      final ow1 = OWtagPixelData.fromBytes(bytes1);
      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);
    });

    // Urgent: separate PixelDataOW from OW tests
    test('OWtagPixelData.update Test', () {
      global.throwOnError = false;

      final ow0 = new OWtagPixelData(pixels0);
      final ow1 = ow0.update(pixels0);
      expect(ow1 == ow0, true);
    });

    test('getPixelData', () {
      global.throwOnError = false;

      final pd0 = new OWtagPixelData([123, 101]);
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
          ds1.getPixelData, throwsA(const TypeMatcher<InvalidValuesError>()));

      global.throwOnError = false;
      //Missing Pixel Data
/*
      final pd1 = new OWtagPixelData(PTag.kOverlayData, [123, 101]);
      expect(pd1, isNull);
*/

      final ba3 = new UStag(PTag.kBitsAllocated, [16]);
      final ds2 = new TagRootDataset.empty()
//        ..add(pd1)
        ..add(ba3);
      global.throwOnError = true;
      expect(
          ds2.getPixelData, throwsA(const TypeMatcher<PixelDataNotPresent>()));
    });

/*
    test('Create OWtagPixelData.fromBase64', () {
      final base64 = base64.encode(u8Frame);
      final ow0 =
          OWtagPixelData.fromBase64(base64, base64.length);
      final ow1 = OWtagPixelData.fromBase64(
          PTag.kCoefficientsSDVN, base64, base64.length);

      global.throwOnError = true;
      expect(
          () => OWtagPixelData.fromBase64(
              PTag.kVariableNextDataGroup, base64, base64.length),
          throwsA(const TypeMatcher<InvalidVRError>()));

      expect(ow0.tag == true);
      expect(ow1.tag == PTag.kCoefficientsSDVN, true);
      expect(ow0.vrIndex == kOBOWIndex, false);
      expect(ow0.vrIndex == kOWIndex, true);
      expect(ow1.vrIndex == kOWIndex, true);
      expect(ow0.isEncapsulated == false, true);
      expect(ow0.vfBytes is Bytes, true);
      expect(ow0.values is Uint16List, true);
      expect(ow0.length == ow0.values.length, true);
      expect(ow0.vfBytes.length == 139782, true);
      expect(ow0.values.length == 69891, true);
      expect(ow0.length == 69891, true);
      expect(ow0.valuesCopy, equals(ow0.values));
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

      final ow0 = OWtagPixelData.fromValues(pixels0);
      expect(ow0.tag == PTag.kPixelDataOW, true);
      expect(ow0.vrIndex == kOBOWIndex, false);
      expect(ow0.vrIndex == kOWIndex, true);
      expect(ow0.vfBytes is Bytes, true);
      expect(ow0.vfBytes.length == 2048, true);
      expect(ow0.values is Uint16List, true);
      expect(ow0.values.length == 1024, true);
      expect(ow0.length == 1024, true);
      expect(ow0.valuesCopy, equals(ow0.values));
      expect(ow0.typedData is Uint16List, true);

/*
      final ow1 = OWtagPixelData.fromValues(PTag.kCoefficientsSDVN, pixels0);
//      expect(ow1.tag == PTag.kCoefficientsSDVN, true);
//      expect(ow1.vrIndex == kOWIndex, true);
      expect(ow1, isNull);

      global.throwOnError = true;
      expect(() => OWtagPixelData.fromValues(PTag.kSelectorSTValue, pixels0),
          throwsA(const TypeMatcher<InvalidTagError>()));
*/

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

      final ow0 = OWtagPixelData.fromValues(pixels0);
      final ow1 = OWtagPixelData.fromValues(pixels0);
      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);

/*
      final ow2 = OWtagPixelData.fromValues(PTag.kVariablePixelData, pixels0);
      expect(ow2, isNull);

      final ow3 = OWtagPixelData.fromValues(PTag.kCoefficientsSDVN, pixels0);
      expect(ow3, isNull);

      final ow4 = OWtagPixelData.fromValues(PTag.kCoefficientsSDVN, pixels0);
      expect(ow4, isNull);

      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
      expect(ow3.hashCode == ow4.hashCode, true);
      expect(ow3 == ow4, true);
      expect(ow0.hashCode == ow3.hashCode, false);
      expect(ow0 == ow3, false);
*/
    });

    test('create new OWtagPixelData.fromBytes', () {
      final ow0 = OWtagPixelData.fromBytes(u8Frame);

      expect(ow0.tag == PTag.kPixelDataOW, true);

      expect(ow0.vrIndex == kOBOWIndex, false);
      expect(ow0.vrIndex == kOWIndex, true);

//      expect(ow0.isEncapsulated == false, true);
      expect(ow0.vfBytes is Bytes, true);
      expect(ow0.vfBytes.length == 139782, true);
      expect(ow0.values is Uint16List, true);
      expect(ow0.values.length == 69891, true);
      expect(ow0.length == 69891, true);
      expect(ow0.valuesCopy, equals(ow0.values));
      expect(ow0.typedData is Uint16List, true);

      for (var s in u8Frame) {
        expect(ow0.checkValue(s), true);
      }
      expect(ow0.checkValue(kUint16Max), true);
      expect(ow0.checkValue(kUint16Min), true);
      expect(ow0.checkValue(kUint16Max + 1), false);
      expect(ow0.checkValue(kUint16Min - 1), false);

/*
      final ow1 = OWtagPixelData.fromBytes(
          u8Frame, PTag.kCoefficientsSDVN, u8Frame.length);
//      expect(ow1.tag == PTag.kCoefficientsSDVN, true);
//      expect(ow1.vrIndex == kOWIndex, true);
      expect(ow1, isNull);

      global.throwOnError = true;
      expect(
          () => OWtagPixelData.fromBytes(
              u8Frame, PTag.kSelectorSTValue, u8Frame.length),
          throwsA(const TypeMatcher<InvalidTagError>()));
*/
    });

    test('create new OWtagPixelData.fromBytes hashCode and ==', () {
      global.throwOnError = false;
      final ow0 = OWtagPixelData.fromBytes(u8Frame);
      final ow1 = OWtagPixelData.fromBytes(u8Frame);
      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);

/*
      final ow2 = OWtagPixelData.fromBytes(
          u8Frame, PTag.kVariablePixelData, u8Frame.length);
      expect(ow2, isNull);
      final ow3 = OWtagPixelData.fromBytes(
          u8Frame, PTag.kCoefficientsSDVN, u8Frame.length);
      expect(ow3, isNull);
      final ow4 = OWtagPixelData.fromBytes(
          u8Frame, PTag.kCoefficientsSDVN, u8Frame.length);
      expect(ow4, isNull);

      expect(ow3.hashCode == ow4.hashCode, true);
      expect(ow3 == ow4, true);
      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
      expect(ow0.hashCode == ow3.hashCode, false);
      expect(ow0 == ow3, false);
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
          throwsA(const TypeMatcher<InvalidValuesError>()));
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
