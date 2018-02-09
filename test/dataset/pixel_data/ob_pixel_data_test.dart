// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

import 'test_pixel_data.dart';

final Uint32List emptyOffsets = new Uint32List(0);
final Uint8List emptyOffsetsAsBytes = emptyOffsets.buffer.asUint8List();
final Uint8List frame = new Uint8List.fromList(testFrame);
final List<Uint8List> fragments = [emptyOffsetsAsBytes, testFrame];

void main() {
  Server.initialize(name: 'element/ob_pixel_data_test', level: Level.info);

  final ts = TransferSyntax.kDefaultForDicomWeb;
  group('OBtagPixelData Tests', () {
    final pixels = new List<int>(1024);
    for (var i = 0; i < pixels.length; i++) pixels[i] = 128;

    final pixels1 = [1024, 1024];
    for (var i = 0; i < pixels1.length; i++) pixels1[i] = 128;

    test('Create Unencapsulated OBtagPixelData', () {
      final ob0 = new OBtagPixelData(PTag.kPixelData, pixels, pixels.length);
      final ob1 = new OBtagPixelData(PTag.kPixelData, pixels, pixels.length);
      final ob2 = new OBtagPixelData(PTag.kPixelData, pixels1, pixels.length);
      expect(ob0.tag == PTag.kPixelData, true);

      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
      expect(ob0.values is List<int>, true);
      expect(ob0.fragments == null, true);
      expect(ob0.offsets == null, true);
      expect(ob0.isEncapsulated == false, true);
      log.debug(ob0.values);
      expect(ob0.hasValidValues, true);
      log.debug('bytes: ${ob0.vfBytes}');
      expect(ob0.vfBytes is Uint8List, true);
      expect(ob0.vfBytes.length == 1024, true);
      expect(ob0.pixels is Uint8List, true);
      expect(ob0.pixels.length == 1024, true);
      expect(ob0.length == 1024, true);
      expect(ob0.valuesCopy, equals(ob0.pixels));

      //hash_code
      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);
      expect(ob0.hashCode == ob2.hashCode, false);
      expect(ob0 == ob2, false);
    });

    test('Create Encapsulated OBtagPixelData', () {
      final frags = new VFFragments(fragments);
      final ob0 = new OBtagPixelData(
          PTag.kPixelData, frame, kUndefinedLength, ts, frags);
      final ob1 = new OBtagPixelData(
          PTag.kPixelData, frame, kUndefinedLength, ts, frags);
      expect(ob0.tag == PTag.kPixelData, true);
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
      expect(ob0.fragments == frags, true);
      expect(ob0.offsets == frags.offsets, true);
      expect(ob0.isEncapsulated == true, true);
      expect(ob0.vfBytes is Uint8List, true);
      expect(ob0.vfBytes.length == frame.length, true);
      expect(ob0.pixels is List<int>, true);
      expect(ob0.pixels == frags.bulkdata, true);
      expect(ob0.pixels.length == frags.bulkdata.length, true);
      expect(ob0.length == frags.bulkdata.length, true);
      expect(ob0.valuesCopy, equals(ob0.pixels));

      //hash_code : good
      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);
    });

    test('Create Unencapsulated OBtagPixelData.fromBytes', () {
      final ob0 = new OBtagPixelData.fromBytes(
          PTag.kPixelData, frame, frame.lengthInBytes);
      final ob1 = new OBtagPixelData.fromBytes(
          PTag.kPixelData, frame, frame.lengthInBytes);
      expect(ob0.tag == PTag.kPixelData, true);
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
      expect(ob0.fragments == null, true);
      expect(ob0.offsets == null, true);
      expect(ob0.isEncapsulated == false, true);
      expect(ob0.vfBytes is Uint8List, true);
      expect(ob0.vfBytes.length == ob0.vfLengthField, true);
      expect(ob0.pixels is Uint8List, true);
      expect(ob0.pixels.length == ob0.vfLengthField, true);
      expect(ob0.length == frame.lengthInBytes, true);
      expect(ob0.valuesCopy, equals(ob0.pixels));

      //hash_code
      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);
    });

    test('Create Encapsulated OBtagPixelData.fromBytes', () {
      final frags = new VFFragments(fragments);
      final ob0 = new OBtagPixelData.fromBytes(
          PTag.kPixelData, frame, frame.lengthInBytes, ts, frags);
      final ob1 = new OBtagPixelData.fromBytes(
          PTag.kPixelData, frame, frame.lengthInBytes, ts, frags);
      expect(ob0.tag == PTag.kPixelData, true);
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
      expect(ob0.fragments == frags, true);
      expect(ob0.offsets == frags.offsets, true);
      expect(ob0.isEncapsulated == true, true);
      expect(ob0.vfBytes is Uint8List, true);
      expect(ob0.vfBytes.length == frame.lengthInBytes, true);
      expect(ob0.pixels is Uint8List, true);
      expect(ob0.pixels == frags.bulkdata, true);
      expect(ob0.pixels.length == frags.bulkdata.length, true);
      expect(ob0.length == frags.bulkdata.length, true);
      expect(ob0.valuesCopy, equals(ob0.pixels));

      //hash_code : good
      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);
    });

    test('OBtagPixelData.update Test', () {
      final ob0 = new OBtagPixelData(PTag.kPixelData, pixels, pixels.length);
      final ob1 = ob0.update(pixels);
      expect(ob0 == ob1, true);

      final frags = new VFFragments(fragments);
      final ob2 = new OBtagPixelData(
          PTag.kPixelData, frame, kUndefinedLength, ts, frags);
      final ob3 = ob2.update(frame);
      expect(ob2 == ob3, true);

      final ob4 = new OBtagPixelData.fromBytes(
          PTag.kPixelData, frame, frame.lengthInBytes);
      final ob5 = ob4.update(testFrame);
      expect(ob4 == ob5, true);

      final ob6 = new OBtagPixelData.fromBytes(
          PTag.kPixelData, frame, frame.lengthInBytes, ts, frags);
      final ob7 = ob6.update(testFrame);
      expect(ob6 == ob7, true);
    });

    test('getPixelData', () {
      final pd0 = new OBtagPixelData(PTag.kPixelData, [123, 101], 3);
      final ba0 = new UStag(PTag.kBitsAllocated, [8]);
      final ds = new TagRootDataset()..add(pd0)..add(ba0);

      //  ds = new RootDatasetTag();
      final pixels = ds.getPixelData();
      log.debug('pixel.length: ${pixels.length}');
      expect(pixels.length == 2, true);

      system.throwOnError = false;
      final ba1 = new UStag(PTag.kBitsAllocated, []);
      final ds1 = new TagRootDataset()..add(ba1);
      final pixels1 = ds1.getPixelData();
      expect(pixels1 == null, true);

      system.throwOnError = true;
      final ba2 = new UStag(PTag.kBitsAllocated, []);
      ds1.add(ba2);
      //Uint8List pixels2 = ds.getPixelData();
      expect(ds1.getPixelData,
          throwsA(const isInstanceOf<InvalidValuesLengthError>()));

      //Missing Pixel Data
      final pd1 = new OBtagPixelData(PTag.kOverlayData, [123, 101], 3);
      final ba3 = new UStag(PTag.kBitsAllocated, [8]);
      final ds2 = new TagRootDataset()..add(pd1)..add(ba3);
      expect(
          ds2.getPixelData, throwsA(const isInstanceOf<PixelDataNotPresent>()));

      //bad Pixel Data
      system.throwOnError = false;
      final ss0 = new SStag(PTag.kPixelData, [124]);
      expect(ss0, isNull);
      final ba4 = new UStag(PTag.kBitsAllocated, [8]);
      final ds3 = new TagRootDataset()..add(ba4);

      system.throwOnError = true;
      expect(
          ds3.getPixelData, throwsA(const isInstanceOf<PixelDataNotPresent>()));
    });
  });
}
