//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:bytes_dicom/bytes_dicom.dart';
import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

import 'test_pixel_data.dart';

final Uint32List emptyOffsets = Uint32List(0);
final Uint8List emptyOffsetsAsBytes = emptyOffsets.buffer.asUint8List();
final Bytes frame = Bytes.fromList(testFrame);
final List<Uint8List> fragments = [emptyOffsetsAsBytes, testFrame];

void main() {
  Server.initialize(name: 'element/vf_fragments_test', level: Level.info);
//  const ts = TransferSyntax.kDefaultForDicomWeb;

  group('VFFragments Tests', () {

    final pixels = List<int>(1024);
    for (var i = 0; i < pixels.length; i++) pixels[i] = 128;

    final pixels1 = <int>[1024, 1024];
    for (var i = 0; i < pixels1.length; i++) pixels1[i] = 128;

/*
    test('Create VFFragments with empty offsets', () {
      final emptyOffsets = Uint32List(0);
      final emptyOffsetsAsBytes = emptyOffsets.buffer.asUint8List();
      final frame1 = Uint8List(0);

      log..debug('frags0:$frags0')..debug('frags0.bulkdata:${frags0.bulkdata}');
      expect(frags0.bulkdata, equals(<int>[]));

      log.debug('frags0.lengthInBytes:${frags0.lengthInBytes}');
      expect(frags0.lengthInBytes == 0, true);

      final ob0 = OBtagPixelData(PTag.kPixelData, frame1,
                                         kUndefinedLength,  ts);
      final ob1 = OBtagPixelData(PTag.kPixelData, frame1,
                                         kUndefinedLength,  ts);

      expect(ob0.tag == PTag.kPixelData, true);
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
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
*/

/*
    test('Create VFFragments with non-empty offsets', () {
      final frags = VFFragments(fragments);
      final ob0 = OBtagPixelData(PTag.kPixelData,
                                         frame, kUndefinedLength, ts);
      final ob1 = OBtagPixelData(PTag.kPixelData,
                                         frame, kUndefinedLength, ts);
      expect(ob0.tag == PTag.kPixelData, true);
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
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
*/

/*
    test('Create  VFFragments.fromBytes', () {
      final ob0 = OBtagPixelData.fromBytes(
          PTag.kPixelData, frame, frame.length, ts);
      final ob1 = OBtagPixelData.fromBytes(
          PTag.kPixelData, frame, frame.length, ts);
      expect(ob0.tag == PTag.kPixelData, true);
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);

//      expect(ob0.offsets == frags.offsets, true);
      expect(ob0.isEncapsulated == true, true);
      expect(ob0.vfBytes is Bytes, true);
      expect(ob0.vfBytes.length == frame.length, true);
      expect(ob0.pixels is Uint8List, true);
 //     expect(ob0.pixels == frags.bulkdata, true);
 //     expect(ob0.pixels.length == frags.bulkdata.length, true);
//      expect(ob0.length == frags.bulkdata.length, true);
      expect(ob0.valuesCopy, equals(ob0.pixels));

      //hash_code : good
      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);
    });
*/


  });
}
