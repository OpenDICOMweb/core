// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

import 'test_pixel_data.dart';

final Uint8List frame = new Uint8List.fromList(testFrame);

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

    test('Create OW', () {
      final ow0 =
          new OWtagPixelData(PTag.kPixelData, pixels0, pixels0.lengthInBytes);
      final ow1 =
          new OWtagPixelData(PTag.kPixelData, pixels1, pixels1.lengthInBytes);
      final ow2 =
          new OWtagPixelData(PTag.kPixelData, pixels2, pixels2.lengthInBytes);
      expect(ow0.tag == PTag.kPixelData, true);
      expect(ow0.vrIndex == kOBOWIndex, true);
      expect(ow0.isEncapsulated == false, true);
      expect(ow0.vfBytes is Uint8List, true);
      expect(ow0.vfBytes.length == 2048, true);
      expect(ow0.pixels is Uint16List, true);
      expect(ow0.pixels.length == 1024, true);
      expect(ow0.length == 1024, true);
      expect(ow0.valuesCopy, equals(ow0.pixels));

      //hash_code
      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);
      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
    });

    test('Create  OW.fromBytes', () {
      final ow0 = new OWtagPixelData.fromBytes(
          PTag.kPixelData, bytes1, bytes1.lengthInBytes);
      final ow1 = new OWtagPixelData.fromBytes(
          PTag.kPixelData, bytes1, bytes1.lengthInBytes);
      final ow2 = new OWtagPixelData.fromBytes(
          PTag.kPixelData, bytes2, bytes2.lengthInBytes);
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

      //hash_code
      expect(ow0.hashCode == ow1.hashCode, true);
      expect(ow0 == ow1, true);
      expect(ow0.hashCode == ow2.hashCode, false);
      expect(ow0 == ow2, false);
    });

    test('OW.update Test', () {
      final ow0 = new OWtag(PTag.kPixelData, pixels0);
      final ow1 = ow0.update(pixels0);
      expect(ow1 == ow0, true);

      final ow2 =
          new OWtag.fromBytes(PTag.kPixelData, bytes1, bytes1.lengthInBytes);
      final ow3 = ow2.update(pixels1);
      expect(ow3 == ow2, true);
    });

    test('getPixelData', () {
      final pd0 = new OWtagPixelData(PTag.kPixelData, [123, 101], 1);
      final ba0 = new UStag(PTag.kBitsAllocated, [16]);
      final ds = new TagRootDataset()..add(pd0)..add(ba0);
      final pixels = ds.getPixelData();
      log..debug('pixels: $pixels\npixel.length: ${pixels.length}');
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
      final pd1 = new OWtag(PTag.kOverlayData, [123, 101]);
      final ba3 = new UStag(PTag.kBitsAllocated, [16]);
      final ds2 = new TagRootDataset()..add(pd1)..add(ba3);
      expect(
          ds2.getPixelData, throwsA(const isInstanceOf<PixelDataNotPresent>()));

      //bad Pixel Data
      system.throwOnError = false;
      final ss0 = new SStag(PTag.kPixelData, [124]);
      log.debug('ss0: $ss0');
      expect(ss0, isNull);
      final ba4 = new UStag(PTag.kBitsAllocated, [16]);
      log.debug('ba4: $ba4');
      final ds3 = new TagRootDataset()..add(ba4);

      system.throwOnError = true;
      expect(
          ds3.getPixelData, throwsA(const isInstanceOf<PixelDataNotPresent>()));
    });
  });
}
