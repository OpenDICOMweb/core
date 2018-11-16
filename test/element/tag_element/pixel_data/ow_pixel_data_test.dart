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

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

import 'test_pixel_data.dart';

final Bytes u8Frame = Bytes.fromList(testFrame);
final Bytes u16Frame = Bytes.fromList(testFrame);

void main() {
  Server.initialize(name: 'element/ow_pixel_data_test', level: Level.info);

  const ts = TransferSyntax.kDefaultForDicomWeb;
  group('OW PixelData Tests', () {
    final pixels0 = Uint16List(1024);
    for (var i = 0; i < pixels0.length; i++) pixels0[i] = 4095;

    final pixels1 = Uint16List.fromList(pixels0);
    final bytes1 = Bytes.typedDataView(pixels1);

    final pixels2 = Uint16List.fromList([4095, 4095]);
//    final bytes2 = Bytes.typedDataView(pixels2);

    test('Create OWtagPixelData', () {
      final ow0 = OWtagPixelData(pixels0);
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

      final ow1 = OWtagPixelData([kUint32Max]);
      expect(ow1, isNull);

      global.throwOnError = true;
      expect(() => OWtagPixelData([kUint32Max]),
          throwsA(const TypeMatcher<InvalidValuesError>()));

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
      final ow0 = OWtagPixelData(pixels0);
      final ow1 = OWtagPixelData(pixels1);
      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);

      final ow2 = OWtagPixelData(pixels2);
      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
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

    test('OWtagPixelData.update Test', () {
      global.throwOnError = false;

      final ow0 = OWtagPixelData(pixels0);
      final ow1 = ow0.update(pixels0);
      expect(ow1 == ow0, true);
    });

    test('getPixelData', () {
      global.throwOnError = false;

      final pd0 = OWtagPixelData([123, 101]);
      final ba0 = UStag(PTag.kBitsAllocated, [16]);
      final ds = TagRootDataset.empty()..add(pd0)..add(ba0);
      final pixels = ds.pixelData;
      log..debug('pixels: $pixels')..debug('pixel.length: ${pixels.length}');
      expect(pixels.length == 2, true);

      final ba1 = UStag(PTag.kBitsAllocated, []);
      final ds1 = TagRootDataset.empty()..add(ba1);
      final pixels1 = ds1.pixelData;
      expect(pixels1 == null, true);

      global.throwOnError = true;
      expect(() => ds1.pixelData,
          throwsA(const TypeMatcher<PixelDataNotPresent>()));

      global.throwOnError = false;

      final ba3 = UStag(PTag.kBitsAllocated, [16]);
      final ds2 = TagRootDataset.empty()..add(ba3);
      global.throwOnError = true;
      expect(() => ds2.pixelData,
          throwsA(const TypeMatcher<PixelDataNotPresent>()));
    });

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

      final ow1 = OWtagPixelData.fromValues([kUint32Max]);
      expect(ow1, isNull);

      global.throwOnError = true;
      expect(() => OWtagPixelData.fromValues([kUint32Max]),
          throwsA(const TypeMatcher<InvalidValuesError>()));

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
      final ow2 = OWtagPixelData.fromValues([kUint16Max]);

      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);

      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
    });

    test('create OWtagPixelData.fromBytes', () {
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
    });

    test('create OWtagPixelData.fromBytes hashCode and ==', () {
      global.throwOnError = false;
      final frame1 = Bytes.fromList(pixels1);
      final ow0 = OWtagPixelData.fromBytes(u8Frame);
      final ow1 = OWtagPixelData.fromBytes(u8Frame);
      final ow2 = OWtagPixelData.fromBytes(u8Frame);
      final ow3 = OWtagPixelData.fromBytes(frame1);

      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);

      expect(ow0.hashCode == ow2.hashCode, true);
      expect(ow0 == ow2, true);

      expect(ow0.hashCode == ow3.hashCode, false);
      expect(ow0 == ow3, false);

      expect(ow1.hashCode == ow3.hashCode, false);
      expect(ow1 == ow3, false);
    });

    test('OWtagPixelData isValidArgs', () {
      final e0 = OWPixelData.isValidArgs(pixels1, pixels1.lengthInBytes, ts);
      expect(e0, true);

      final e1 = OWPixelData.isValidArgs(null, 0, ts);
      expect(e1, false);
    });

    test('OWtagPixelData isValidBytesArgs', () {
      final vfBytes = Bytes.fromList(pixels1);
      final e0 = OWPixelData.isValidBytesArgs(vfBytes, vfBytes.length);
      expect(e0, true);

      final e1 = OWPixelData.isValidBytesArgs(null, 0);
      expect(e1, false);
    });

    test('Create OWtagPixelData.fromPixels', () {
      final e0 = OWtagPixelData(pixels0);
      log.debug('tag: ${PTag.kPixelDataOW}');
      expect(e0.vrIndex == kOBOWIndex, false);
      expect(e0.vrIndex == kOWIndex, true);
      expect(e0.values is List<int>, true);
      log.debug(e0.values);
      expect(e0.hasValidValues, true);
      log.debug('bytes: ${e0.vfBytes}');
      expect(e0.vfBytes is Bytes, true);
      expect(e0.vfBytes.length == 2048, true);
      expect(e0.values is Uint16List, true);
      expect(e0.values.length == 1024, true);
      expect(e0.length == 1024, true);
      expect(e0.valuesCopy, equals(e0.values));
      expect(e0.typedData is Uint16List, true);
      expect(e0.tag == PTag.kPixelDataOW, true);

      final s = Sha256.uint16(pixels0);
      log.debug('s: $s');
      final e2 = e0.sha256;
      final e3 = e0.update(s);
      expect(e2, equals(e3));

      for (var s in u8Frame) {
        expect(e0.checkValue(s), true);
      }

      expect(e0.checkValue(kUint16Max), true);
      expect(e0.checkValue(kUint16Min), true);
      expect(e0.checkValue(kUint16Max + 1), false);
      expect(e0.checkValue(kUint16Min - 1), false);
    });

    test('Create OWtagPixelData.fromPixels hashCode and ==', () {
      global.throwOnError = false;

      final e0 = OWtagPixelData(pixels0);
      final e1 = OWtagPixelData(pixels0);
      final e2 = OWtagPixelData(pixels2);

      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);

      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);
    });
  });

  group('OWPixelData', () {
    const testFrame0 = <int>[
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

      final frame0 = Bytes.fromList(testFrame0);
      expect(Uint16.fromBytes(frame0), frame0.buffer.asUint16List());
    });

    test('Create Uint16Base.listToBytes', () {
      global.throwOnError = false;
      final rng = RNG(1);

      for (var i = 0; i < 10; i++) {
        final uInt16List0 = rng.uint16List(1, 1);
        log.debug('uInt16List0: $uInt16List0');
        expect(Uint16.toBytes(uInt16List0), uInt16List0.buffer.asUint8List());
      }

      const uInt8Max = [kUint8Max];
      const uInt16Max = [kUint16Max];
      const uInt32Max = [kUint32Max];

      final ui0 = Uint16List.fromList(uInt8Max);
      final ui1 = Uint16List.fromList(uInt16Max);

      expect(Uint16.toBytes(uInt8Max), ui0.buffer.asUint8List());
      expect(Uint16.toBytes(uInt16Max), ui1.buffer.asUint8List());
      expect(Uint16.toBytes(ui1), ui1.buffer.asUint8List());

      expect(Uint16.toBytes(uInt32Max), isNull);

      global.throwOnError = true;
      expect(() => Uint16.toBytes(uInt32Max),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('Create OW.decodeJsonVF', () {
      //     final testPixels = Uint16List.fromList([123]);
      final b64Pixels = Uint16.toBase64(u16Frame);
      final v = Uint16.fromBase64(b64Pixels);
      log
        ..debug(' u16Frame: $u16Frame')
        ..debug('b64Pixels: $b64Pixels')
        ..debug(v);
      expect(v, equals(u16Frame.asUint8List()));
    });

    test('Create Uint16Base.listToBase64', () {
      final baseFrame = [1, 2, 3];
      final frame0 = Uint16List.fromList(baseFrame);
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

      final frame0 = Bytes.fromList(testFrame0);
      expect(Uint16.fromBytes(frame0), frame0.buffer.asUint16List());
    });

    test('Create Uint16Base.listFromByteData', () {
      expect(Uint16.fromBytes(u8Frame), u8Frame.buffer.asUint16List());
      final frame0 = Uint8List.fromList(testFrame0);
      final bd = frame0.buffer.asByteData();

      expect(Uint16.fromByteData(bd), frame0.buffer.asUint16List());
    });
  });
}
