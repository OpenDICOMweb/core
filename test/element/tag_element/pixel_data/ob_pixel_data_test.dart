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

final Uint32List emptyOffsets = new Uint32List(0);
final Uint8List emptyOffsetsAsBytes = emptyOffsets.buffer.asUint8List();
final Bytes frame = new Bytes.fromList(testFrame);
//final List<Uint8List> fragments = [emptyOffsetsAsBytes, testFrame];

void main() {
  Server.initialize(name: 'element/ob_pixel_data_test', level: Level.info);

  const ts = TransferSyntax.kDefaultForDicomWeb;
  group('OBtagPixelData Tests', () {
    final pixels = new List<int>(1024);
    for (var i = 0; i < pixels.length; i++) pixels[i] = 128;

    final pixels1 = [1024, 1024];
    for (var i = 0; i < pixels1.length; i++) pixels1[i] = 128;

    test('Create Unencapsulated OBtagPixelData', () {
      final ob0 = new OBtagPixelData.fromPixels(pixels);
      log.debug('tag: ${PTag.kPixelDataOB}');
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
      expect(ob0.values is List<int>, true);
      log.debug(ob0.values);
      expect(ob0.hasValidValues, true);
      log.debug('bytes: ${ob0.vfBytes}');
      expect(ob0.vfBytes is Bytes, true);
      expect(ob0.vfBytes.length == 1024, true);
      expect(ob0.values is Uint8List, true);
      expect(ob0.values.length == 1024, true);
      expect(ob0.length == 1024, true);
      expect(ob0.valuesCopy, equals(ob0.values));
      expect(ob0.typedData is Uint8List, true);
      expect(ob0.tag == PTag.kPixelDataOB, true);

      final ob1 = new OBtagPixelData([kUint16Max]);
      expect(ob1, isNull);

      global.throwOnError = true;
      expect(() => new OBtagPixelData([kUint16Max]),
          throwsA(const TypeMatcher<InvalidValuesError>()));

      final s = Sha256.uint8(pixels);
      log.debug('s: $s');
      final ob2 = ob0.sha256;
      final ob3 = ob0.update(s);
      expect(ob2, equals(ob3));

      for (var s in frame) {
        expect(ob0.checkValue(s), true);
      }

      expect(ob0.checkValue(kUint8Max), true);
      expect(ob0.checkValue(kUint8Min), true);
      expect(ob0.checkValue(kUint8Max + 1), false);
      expect(ob0.checkValue(kUint8Min - 1), false);
    });

    test('Create UnEncapsulate OBtagPixelData hashCode and ==', () {
      global.throwOnError = false;

      final ob0 = new OBtagPixelData(pixels);
      final ob1 = new OBtagPixelData(pixels);
      final ob2 = new OBtagPixelData(pixels1);

      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);

      expect(ob0.hashCode == ob2.hashCode, false);
      expect(ob0 == ob2, false);
    });

    test('Create Encapsulated OBtagPixelData', () {
      //     final frags = new VFFragments(fragments);
      final ob0 = new OBtagPixelData(frame, ts);
      expect(ob0.tag == PTag.kPixelDataOB, true);
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
      //expect(ob0.isEncapsulated == true, true);
      expect(ob0.vfBytes is Bytes, true);
      expect(ob0.vfBytes.length == frame.length, true);
      expect(ob0.values is List<int>, true);
      expect(ob0.valuesCopy, equals(ob0.values));
      expect(ob0.typedData is Uint8List, true);

      final s = Sha256.uint8(frame);
      expect(ob0.sha256, equals(ob0.update(s)));

      for (var s in frame) {
        expect(ob0.checkValue(s), true);
      }

      expect(ob0.checkValue(kUint8Max), true);
      expect(ob0.checkValue(kUint8Min), true);
      expect(ob0.checkValue(kUint8Max + 1), false);
      expect(ob0.checkValue(kUint8Min - 1), false);

      final ob1 = new OBtagPixelData([kUint16Max]);
      expect(ob1, isNull);

      global.throwOnError = true;
      expect(() => new OBtagPixelData([kUint16Max]),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('Create Encapsulated OBtagPixelData hashCode and ==', () {
      global.throwOnError = false;

      final ob0 = new OBtagPixelData(frame, ts);
      final ob1 = new OBtagPixelData(frame, ts);
      final ob2 = new OBtagPixelData(pixels, ts);

      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);

      expect(ob0.hashCode == ob2.hashCode, false);
      expect(ob0 == ob2, false);
    });

    test('Create Unencapsulated OBtagPixelData.fromBytes', () {
      global.throwOnError = false;
      final ob0 = OBtagPixelData.fromBytes(frame);

      expect(ob0.tag == PTag.kPixelDataOB, true);
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
//      expect(ob0.offsets == null, true);
//      expect(ob0.isEncapsulated == false, true);
      final bytes = ob0.vfBytes;
      expect(ob0.vfBytes is Bytes, true);
      log
        ..debug('ob0.vfBytes.length: ${ob0.vfBytes.length}')
        ..debug('ob0.values.length: ${ob0.values.length}')
        ..debug('ob0.vfLength: ${ob0.vfLength}');
      expect(ob0.vfLength == bytes.length, true);
      expect(ob0.values is Uint8List, true);
      expect(ob0.values.length == ob0.vfLength, true);
      log
        ..debug('ob0.length: ${ob0.length}')
        ..debug('frame.length: ${frame.length}');
      expect(ob0.lengthInBytes == frame.length, true);
      expect(ob0.valuesCopy, equals(ob0.values));
      expect(ob0.typedData is Uint8List, true);

      global.throwOnError = false;
      final ob1 = OBtagPixelData.fromBytes(frame);
      expect(ob1.tag == PTag.kPixelDataOB, true);

      final s = Sha256.uint8(frame);
      expect(ob0.sha256, equals(ob0.update(s)));

      for (var s in frame) {
        expect(ob0.checkValue(s), true);
      }

      expect(ob0.checkValue(kUint8Max), true);
      expect(ob0.checkValue(kUint8Min), true);
      expect(ob0.checkValue(kUint8Max + 1), false);
      expect(ob0.checkValue(kUint8Min - 1), false);
    });

    test('Create Unencapsulated OBtagPixelData.fromBytes hashCode and ==', () {
      global.throwOnError = false;
      final frame1 = new Bytes.fromList(pixels);
      final ob0 = OBtagPixelData.fromBytes(frame);
      final ob1 = OBtagPixelData.fromBytes(frame);
      final ob2 = OBtagPixelData.fromBytes(frame1);

      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);

      expect(ob0.hashCode == ob2.hashCode, false);
      expect(ob0 == ob2, false);
    });

    test('Create Encapsulated OBtagPixelData.fromBytes', () {
//      final frags = new VFFragments(fragments);
      final ob0 = OBtagPixelData.fromBytes(frame, ts);
      expect(ob0.tag == PTag.kPixelDataOB, true);
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
//      expect(ob0.offsets == frags.offsets, true);
//      expect(ob0.isEncapsulated == true, true);
      expect(ob0.vfBytes is Bytes, true);
      expect(ob0.vfBytes.length == frame.length, true);
      expect(ob0.values is Uint8List, true);
      expect(ob0.values.length == 139782, true);
      expect(ob0.valuesCopy, equals(ob0.values));
      expect(ob0.typedData is Uint8List, true);

      for (var s in frame) {
        expect(ob0.checkValue(s), true);
      }

      expect(ob0.checkValue(kUint8Max), true);
      expect(ob0.checkValue(kUint8Min), true);
      expect(ob0.checkValue(kUint8Max + 1), false);
      expect(ob0.checkValue(kUint8Min - 1), false);
    });

    test('Create Encapsulated OBtagPixelData.fromBytes hashCode and ==', () {
      global.throwOnError = false;
      final ob0 = OBtagPixelData.fromBytes(frame, ts);
      final ob1 = OBtagPixelData.fromBytes(frame, ts);

      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);

      final ob2 = OBtagPixelData.fromBytes(frame, ts);
      expect(ob2, equals(ob1));
      expect(ob2.hashCode == ob0.hashCode, true);
      expect(ob2 == ob0, true);

      final ob3 = OBtagPixelData.fromBytes(frame, ts);
      expect(ob3 == ob2, true);
      expect(ob3.hashCode == ob0.hashCode, true);

      final frame1 = new Bytes.fromList(pixels);
      final ob4 = OBtagPixelData.fromBytes(frame1, ts);
      expect(ob0 == ob4, false);
      expect(ob0.hashCode == ob4.hashCode, false);
    });

    test('OBtagPixelData.update Test', () {
      global.throwOnError = false;

      final ob0 = new OBtagPixelData(pixels);
      final ob1 = ob0.update(pixels);
      expect(ob0 == ob1, true);

      final ob2 = new OBtagPixelData(frame, ts);
      final ob3 = ob2.update(frame);
      expect(ob2 == ob3, true);
    });

    test('getPixelData', () {
      final pd0 = new OBtagPixelData([123, 101]);
      final ba0 = new UStag(PTag.kBitsAllocated, [8]);
      final ds = new TagRootDataset.empty()..add(pd0)..add(ba0);

      //  ds = new RootDatasetTag();
      final pixels = ds.getPixelData();
      log.debug('pixel.length: ${pixels.length}');
      expect(pixels.length == 2, true);

      global.throwOnError = false;
      final ba1 = new UStag(PTag.kBitsAllocated, []);
      final ds1 = new TagRootDataset.empty()..add(ba1);
      final pixels1 = ds1.getPixelData();
      expect(pixels1 == null, true);

      global.throwOnError = true;
      expect(
          ds1.getPixelData, throwsA(const TypeMatcher<InvalidValuesError>()));

      final ba3 = new UStag(PTag.kBitsAllocated, [8]);
      final ds2 = new TagRootDataset.empty()..add(ba3);
      expect(
          ds2.getPixelData, throwsA(const TypeMatcher<PixelDataNotPresent>()));
    });

    test('OBtagPixelData.fromValues', () {
      final ob0 = OBtagPixelData.fromValues(pixels);
      expect(ob0, isNotNull);
      expect(ob0, equals(new OBtagPixelData(pixels)));

      final ob1 = OBtagPixelData.fromValues(pixels);
      expect(ob1, equals(new OBtagPixelData(pixels)));

      expect(ob0.tag == PTag.kPixelDataOB, true);
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
      expect(ob0.values is List<int>, true);
//      expect(ob0.offsets == null, true);
//      expect(ob0.isEncapsulated == false, true);
      log.debug(ob0.values);
      expect(ob0.hasValidValues, true);
      log.debug('bytes: ${ob0.vfBytes}');
      expect(ob0.vfBytes is Bytes, true);
      expect(ob0.vfBytes.length == 1024, true);
      expect(ob0.values is Uint8List, true);
      expect(ob0.values.length == 1024, true);
      expect(ob0.length == 1024, true);
      expect(ob0.valuesCopy, equals(ob0.values));
      expect(ob0.typedData is Uint8List, true);

      global.throwOnError = false;
      final ob2 = OBtagPixelData.fromValues([kUint16Max]);
      expect(ob2, isNull);

      global.throwOnError = true;
      expect(() => OBtagPixelData.fromValues([kUint16Max]),
          throwsA(const TypeMatcher<InvalidValuesError>()));

      final s = Sha256.uint8(pixels);
      expect(ob0.sha256, equals(ob0.update(s)));

      for (var s in frame) {
        expect(ob0.checkValue(s), true);
      }
      expect(ob0.checkValue(kUint8Max), true);
      expect(ob0.checkValue(kUint8Min), true);
      expect(ob0.checkValue(kUint8Max + 1), false);
      expect(ob0.checkValue(kUint8Min - 1), false);
    });

    test('OBtagPixelData.fromValues hashCode and ==', () {
      final ob0 = OBtagPixelData.fromValues(pixels);
      final ob1 = OBtagPixelData.fromValues(pixels);
      final ob2 = OBtagPixelData.fromValues(pixels1);

      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);

      expect(ob0.hashCode == ob2.hashCode, false);
      expect(ob0 == ob2, false);
    });

    test('OBtagPixelData.fromBytes', () {
      final ob0 = OBtagPixelData.fromBytes(frame);
      expect(ob0, equals(OBtagPixelData.fromBytes(frame, ts)));
      expect(ob0.tag == PTag.kPixelDataOB, true);
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
//      expect(ob0.offsets == null, true);
//      expect(ob0.isEncapsulated == false, true);
      expect(ob0.vfBytes is Bytes, true);
      log
        ..debug('ob0.vfBytes.length: ${ob0.vfBytes.length}')
        ..debug('ob0.values.length: ${ob0.values.length}')
        ..debug('ob0.vfLength: ${ob0.vfLength}');
      expect(ob0.vfBytes.length == ob0.vfLength, true);
      expect(ob0.values is Uint8List, true);
      expect(ob0.values.length == ob0.vfLength, true);
      log
        ..debug('ob0.length: ${ob0.length}')
        ..debug('frame.length: ${frame.length}');
      expect(ob0.lengthInBytes == frame.length, true);
      expect(ob0.valuesCopy, equals(ob0.values));

      final s = Sha256.uint8(frame);
      expect(ob0.sha256, equals(ob0.update(s)));

      for (var s in frame) {
        expect(ob0.checkValue(s), true);
      }
      expect(ob0.checkValue(kUint8Max), true);
      expect(ob0.checkValue(kUint8Min), true);
      expect(ob0.checkValue(kUint8Max + 1), false);
      expect(ob0.checkValue(kUint8Min - 1), false);
    });

    test('OBtagPixelData.fromBytes hashCode and ==', () {
      global.throwOnError = false;
      final frame1 = new Bytes.fromList(pixels1);
      final ob0 = OBtagPixelData.fromBytes(frame);
      final ob1 = OBtagPixelData.fromBytes(frame);
      final ob2 = OBtagPixelData.fromBytes(frame1);

      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);

      expect(ob0.hashCode == ob2.hashCode, false);
      expect(ob0 == ob2, false);
    });

    test('OBtagPixelData isValidArgs', () {
      final e0 = OBtagPixelData.isValidArgs(pixels, ts);
      expect(e0, true);

      final e1 = OBtagPixelData.isValidArgs(null, ts);
      expect(e1, false);
    });

    test('OBtagPixelData isValidBytesArgs', () {
      final vfBytes = new Bytes.fromList(pixels);
      final e0 = OBtagPixelData.isValidBytesArgs(vfBytes);
      expect(e0, true);

      final e1 = OBtagPixelData.isValidBytesArgs(null);
      expect(e1, false);
    });
  });

  group('OBPixelData', () {
    test('Create Uint8Base.fromBytes', () {
      expect(Uint8.toBytes(frame), equals(frame));
    });

    test('Create Uint32Base.listToBytes', () {
      global.throwOnError = false;
      const uInt8Max = const [kUint8Max];
      const uInt16Max = const [kUint16Max];

      expect(Uint8.toBytes(testFrame), equals(testFrame));
      expect(Uint8.toBytes(uInt8Max), equals(uInt8Max));
      expect(Uint8.toBytes(uInt16Max), isNull);

      global.throwOnError = true;
      expect(() => Uint8.toBytes(uInt16Max),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('Create Uint8Base.fromBase64', () {
      final s = base64.encode(testFrame);
      expect(Uint8.fromBase64(s), equals(testFrame));
    });

    test('Create Uint8Base.listToBase64', () {
      final s = base64.encode(testFrame);
      log.debug('s: $s');
      expect(Uint8.toBase64(testFrame), s);
    });

    test('Create Uint8Base.fromByteData', () {
      final bd = frame.asByteData();
      expect(Uint8.fromByteData(bd), equals(frame));
    });
  });
}
