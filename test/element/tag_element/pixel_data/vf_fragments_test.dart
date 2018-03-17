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
  Server.initialize(name: 'element/vf_fragments_test', level: Level.info);
  final ts = TransferSyntax.kDefaultForDicomWeb;

  group('VFFragments Tests', () {

    final pixels = new List<int>(1024);
    for (var i = 0; i < pixels.length; i++) pixels[i] = 128;

    final pixels1 = <int>[1024, 1024];
    for (var i = 0; i < pixels1.length; i++) pixels1[i] = 128;

    test('Create VFFragments with empty offsets', () {
      final emptyOffsets = new Uint32List(0);
      final emptyOffsetsAsBytes = emptyOffsets.buffer.asUint8List();
      final frame1 = new Uint8List(0);
      final fragments0 = [emptyOffsetsAsBytes];
      final frags0 = new VFFragments(fragments0);
      log..debug('frags0:$frags0')..debug('frags0.bulkdata:${frags0.bulkdata}');
      expect(frags0.bulkdata, equals(<int>[]));

      log.debug('frags0.lengthInBytes:${frags0.lengthInBytes}');
      expect(frags0.lengthInBytes == 0, true);

      final ob0 = new OBtagPixelData(PTag.kPixelData, frame1,
                                         kUndefinedLength, frags0, ts);
      final ob1 = new OBtagPixelData(PTag.kPixelData, frame1,
                                         kUndefinedLength, frags0, ts);

      expect(ob0.tag == PTag.kPixelData, true);
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
      expect(ob0.fragments == frags0, true);
      expect(ob0.offsets == frags0.offsets, true);
      expect(ob0.isEncapsulated == true, true);
      expect(ob0.vfBytes is Bytes, true);
      expect(ob0.vfBytes.length == frame1.length, true);
      expect(ob0.pixels is List<int>, true);
      expect(ob0.pixels == frags0.bulkdata, true);
      expect(ob0.pixels.length == frags0.bulkdata.length, true);
      expect(ob0.length == frags0.bulkdata.length, true);
      expect(ob0.valuesCopy, equals(ob0.pixels));

      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);
    });

    test('Create VFFragments with non-empty offsets', () {
      final frags = new VFFragments(fragments);
      final ob0 = new OBtagPixelData(PTag.kPixelData,
                                         frame, kUndefinedLength,frags, ts);
      final ob1 = new OBtagPixelData(PTag.kPixelData,
                                         frame, kUndefinedLength,frags, ts);
      expect(ob0.tag == PTag.kPixelData, true);
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
      expect(ob0.fragments == frags, true);
      expect(ob0.offsets == frags.offsets, true);
      expect(ob0.isEncapsulated == true, true);
      expect(ob0.vfBytes is Bytes, true);
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

    test('Create  VFFragments.fromBytes', () {
      final frags = new VFFragments(fragments);
      final ob0 = OBtagPixelData.fromUint8List(
          PTag.kPixelData, frame, frame.lengthInBytes,frags, ts);
      final ob1 = OBtagPixelData.fromUint8List(
          PTag.kPixelData, frame, frame.lengthInBytes,frags, ts);
      expect(ob0.tag == PTag.kPixelData, true);
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
      expect(ob0.fragments == frags, true);
      expect(ob0.offsets == frags.offsets, true);
      expect(ob0.isEncapsulated == true, true);
      expect(ob0.vfBytes is Bytes, true);
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

    test('VFFragments.update Test', () {});
  });
}
