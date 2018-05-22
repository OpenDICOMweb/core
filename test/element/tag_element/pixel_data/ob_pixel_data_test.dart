//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

// Urgent Sharath: all integer test should be changed to match this.

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/server.dart';
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
      final ob0 = new OBtagPixelData(PTag.kPixelDataOB, pixels, pixels.length);
      log.debug('tag: ${PTag.kPixelDataOB}');
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
      expect(ob0.values is List<int>, true);
//      expect(ob0.fragments == null, true);
//      expect(ob0.offsets == null, true);
//      expect(ob0.isEncapsulated == false, true);
      log.debug(ob0.values);
      expect(ob0.hasValidValues, true);
      log.debug('bytes: ${ob0.vfBytes}');
      expect(ob0.vfBytes is Bytes, true);
      expect(ob0.vfBytes.length == 1024, true);
      expect(ob0.pixels is Uint8List, true);
      expect(ob0.pixels.length == 1024, true);
      expect(ob0.length == 1024, true);
      expect(ob0.valuesCopy, equals(ob0.pixels));
      expect(ob0.typedData is Uint8List, true);
      expect(ob0.tag == PTag.kPixelDataOB, true);

      final ob1 =
          new OBtagPixelData(PTag.kPrivateInformation, pixels, pixels.length);
//      expect(ob1.tag == PTag.kPrivateInformation, true);
      expect(ob1, isNull);

      global.throwOnError = true;
      expect(
          () => new OBtagPixelData(
              PTag.kVariableNextDataGroup, pixels1, pixels1.length),
          throwsA(const isInstanceOf<InvalidTagError>()));

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

      final ob0 = new OBtagPixelData(PTag.kPixelDataOB, pixels, pixels.length);
      final ob1 = new OBtagPixelData(PTag.kPixelDataOB, pixels, pixels.length);
      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);

      final ob2 =
          new OBtagPixelData(PTag.kPrivateInformation, pixels1, pixels1.length);
      expect(ob2, isNull);
      final ob3 =
          new OBtagPixelData(PTag.kPrivateInformation, pixels1, pixels1.length);
      expect(ob3, isNull);

/*
      expect(ob2.hashCode == ob3.hashCode, true);
      expect(ob2 == ob3, true);

      expect(ob0.hashCode == ob2.hashCode, false);
      expect(ob0 == ob2, false);
*/
    });

    test('Create Encapsulated OBtagPixelData', () {
      //     final frags = new VFFragments(fragments);
      final ob0 =
          new OBtagPixelData(PTag.kPixelDataOB, frame, kUndefinedLength, ts);
      expect(ob0.tag == PTag.kPixelDataOB, true);
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
      //      expect(ob0.offsets == frags.offsets, true);
//      expect(ob0.isEncapsulated == true, true);
      expect(ob0.vfBytes is Bytes, true);
      expect(ob0.vfBytes.length == frame.length, true);
      expect(ob0.pixels is List<int>, true);
//      expect(ob0.pixels == frags.bulkdata, true);
//      expect(ob0.pixels.length == frags.bulkdata.length, true);
//      expect(ob0.length == frags.bulkdata.length, true);
      expect(ob0.valuesCopy, equals(ob0.pixels));
      expect(ob0.typedData is Uint8List, true);

      final ob1 = new OBtagPixelData(
          PTag.kPrivateInformation, frame, kUndefinedLength, ts);
      expect(ob1, isNull);
      //   expect(ob1.tag == PTag.kPrivateInformation, true);
      //   expect(ob1.vrIndex == kOBIndex, true);

      global.throwOnError = true;
      expect(
          () => new OBtagPixelData(
              PTag.kVariableNextDataGroup, frame, kUndefinedLength, ts),
          throwsA(const isInstanceOf<InvalidTagError>()));

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

    test('Create Encapsulated OBtagPixelData hashCode and ==', () {
      global.throwOnError = false;

      final ob0 =
          new OBtagPixelData(PTag.kPixelDataOB, frame, kUndefinedLength, ts);
      final ob1 =
          new OBtagPixelData(PTag.kPixelDataOB, frame, kUndefinedLength, ts);

      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);

      final ob2 = new OBtagPixelData(
          PTag.kVariablePixelData, frame, kUndefinedLength, ts);
      expect(ob2, isNull);

      final ob3 = new OBtagPixelData(
          PTag.kPrivateInformation, frame, kUndefinedLength, ts);
      expect(ob3, isNull);

      final ob4 = new OBtagPixelData(
          PTag.kPrivateInformation, frame, kUndefinedLength, ts);
      expect(ob4, isNull);
/*
      expect(ob3.hashCode == ob4.hashCode, true);
      expect(ob3 == ob4, true);

      expect(ob0.hashCode == ob2.hashCode, false);
      expect(ob0 == ob2, false);

      expect(ob0.hashCode == ob3.hashCode, false);
      expect(ob0 == ob2, false);
*/
    });

    test('Create Unencapsulated OBtagPixelData.fromBytes', () {
      global.throwOnError = true;
      final ob0 =
          OBtagPixelData.fromBytes(PTag.kPixelDataOB, frame, frame.length);

      expect(ob0.tag == PTag.kPixelDataOB, true);
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
//      expect(ob0.fragments == null, true);
//      expect(ob0.offsets == null, true);
//      expect(ob0.isEncapsulated == false, true);
      expect(ob0.vfBytes is Bytes, true);
      log
        ..debug('ob0.vfBytes.length: ${ob0.vfBytes.length}')
        ..debug('ob0.values.length: ${ob0.values.length}')
        ..debug('ob0.vfLength: ${ob0.vfLength}')
        ..debug('ob0.vfLengthField: ${ob0.vfLengthField}');
      expect(ob0.vfBytes.length == ob0.vfLength, true);
      expect(ob0.pixels is Uint8List, true);
      expect(ob0.pixels.length == ob0.vfLength, true);
      log
        ..debug('ob0.length: ${ob0.length}')
        ..debug('frame.length: ${frame.length}');
      expect(ob0.lengthInBytes == frame.length, true);
      expect(ob0.valuesCopy, equals(ob0.pixels));
      expect(ob0.typedData is Uint8List, true);

      global.throwOnError = false;
      final ob1 = OBtagPixelData.fromBytes(
          PTag.kPrivateInformation, frame, frame.length);
      expect(ob1, isNull);
//      expect(ob1.tag == PTag.kPrivateInformation, true);

      global.throwOnError = true;
      expect(
          () => new OBtagPixelData(
              PTag.kVariableNextDataGroup, pixels1, pixels1.length),
          throwsA(const isInstanceOf<InvalidTagError>()));

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

      final ob0 =
          OBtagPixelData.fromBytes(PTag.kPixelDataOB, frame, frame.length);
      final ob1 =
          OBtagPixelData.fromBytes(PTag.kPixelDataOB, frame, frame.length);
      final ob2 = OBtagPixelData.fromBytes(
          PTag.kVariablePixelData, frame, frame.length);
      final ob3 = OBtagPixelData.fromBytes(
          PTag.kPrivateInformation, frame, frame.length);
      final ob4 = OBtagPixelData.fromBytes(
          PTag.kPrivateInformation, frame, frame.length);

      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);

      expect(ob3.hashCode == ob4.hashCode, true);
      expect(ob3 == ob4, true);

      expect(ob0.hashCode == ob2.hashCode, false);
      expect(ob0 == ob2, false);

      expect(ob0.hashCode == ob3.hashCode, false);
      expect(ob0 == ob2, false);
    });

    test('Create Encapsulated OBtagPixelData.fromBytes', () {
//      final frags = new VFFragments(fragments);
      final ob0 =
          OBtagPixelData.fromBytes(PTag.kPixelDataOB, frame, frame.length, ts);
      expect(ob0.tag == PTag.kPixelDataOB, true);
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
//      expect(ob0.offsets == frags.offsets, true);
//      expect(ob0.isEncapsulated == true, true);
      expect(ob0.vfBytes is Bytes, true);
      expect(ob0.vfBytes.length == frame.length, true);
      expect(ob0.pixels is Uint8List, true);
//      expect(ob0.pixels == frags.bulkdata, true);
//      expect(ob0.pixels.length == frags.bulkdata.length, true);
//      expect(ob0.length == frags.bulkdata.length, true);
      expect(ob0.valuesCopy, equals(ob0.pixels));
      expect(ob0.typedData is Uint8List, true);

      for (var s in frame) {
        expect(ob0.checkValue(s), true);
      }

      expect(ob0.checkValue(kUint8Max), true);
      expect(ob0.checkValue(kUint8Min), true);
      expect(ob0.checkValue(kUint8Max + 1), false);
      expect(ob0.checkValue(kUint8Min - 1), false);

      final ob1 = OBtagPixelData.fromBytes(
          PTag.kPrivateInformation, frame, frame.length, ts);
      expect(ob1, isNull);
//      expect(ob1.tag == PTag.kPrivateInformation, true);
//      expect(ob1.vrIndex == kOBIndex, true);

      global.throwOnError = true;
      expect(
          () => OBtagPixelData.fromBytes(
              PTag.kVariableNextDataGroup, frame, frame.length, ts),
          throwsA(const isInstanceOf<InvalidTagError>()));
    });

    test('Create Encapsulated OBtagPixelData.fromBytes hashCode and ==', () {
      global.throwOnError = false;
      final ob0 =
          OBtagPixelData.fromBytes(PTag.kPixelDataOB, frame, frame.length, ts);
      final ob1 =
          OBtagPixelData.fromBytes(PTag.kPixelDataOB, frame, frame.length, ts);
      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);

      final ob2 = OBtagPixelData.fromBytes(
          PTag.kVariablePixelData, frame, frame.length, ts);
      expect(ob2, isNull);
      final ob3 = OBtagPixelData.fromBytes(
          PTag.kFileMetaInformationVersion, frame, frame.length, ts);
      expect(ob3, isNull);
/*
      expect(ob0.hashCode == ob2.hashCode, false);
      expect(ob0 == ob2, false);

      expect(ob0.hashCode == ob3.hashCode, false);
      expect(ob0 == ob3, false);
*/
    });

    test('OBtagPixelData.update Test', () {
      global.throwOnError = false;

      final ob0 = new OBtagPixelData(PTag.kPixelDataOB, pixels, pixels.length);
      final ob1 = ob0.update(pixels);
      expect(ob0 == ob1, true);

      final ob2 =
          new OBtagPixelData(PTag.kPixelDataOB, frame, kUndefinedLength, ts);
      final ob3 = ob2.update(frame);
      expect(ob2 == ob3, true);

      final ob4 = OBtagPixelData.fromBytes(
          PTag.kFileMetaInformationVersion, frame, frame.length);
      // final ob5 = ob4.update(testFrame);
      //  expect(ob4 == ob5, true);
      expect(ob4, isNull);

      final ob6 = OBtagPixelData.fromBytes(
          PTag.kPrivateInformation, frame, frame.length, ts);
//      final ob7 = ob6.update(testFrame);
//      expect(ob6 == ob7, true);
      expect(ob6, isNull);

/*      final base64 = cvt.base64.encode(frame);
      final ob8 =
          OBtagPixelData.fromBase64(PTag.kPixelDataOB, base64, base64.length);
      final ob9 = ob8.update(testFrame);
      expect(ob8 == ob9, true);

      final ob10 = OBtagPixelData.fromBase64(
          PTag.kPrivateInformation, base64, frame.length,  ts);
      final ob11 = ob10.update(testFrame);
      expect(ob10 == ob11, true);
 */
    });

    test('getPixelData', () {
      final pd0 = new OBtagPixelData(PTag.kPixelDataOB, [123, 101], 3);
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
      //Urgent: what is this testing?
      final ba2 = new UStag(PTag.kBitsAllocated, []);
      ds1.add(ba2);
      //Uint8List pixels2 = ds.getPixelData();
      expect(
          ds1.getPixelData, throwsA(const isInstanceOf<InvalidValuesError>()));

      //Missing Pixel Data
//      final pd1 = new OBtagPixelData(PTag.kOverlayData, [123, 101], 3);
      final ba3 = new UStag(PTag.kBitsAllocated, [8]);
      final ds2 = new TagRootDataset.empty()
        //..add(pd1)
        ..add(ba3);
      expect(
          ds2.getPixelData, throwsA(const isInstanceOf<PixelDataNotPresent>()));
    });
/*
    test('Create Unencapsulated OBtagPixelData.fromBase64', () {

      final base64 = cvt.base64.encode(frame);
      final ob0 =
          OBtagPixelData.fromBase64(PTag.kPixelDataOB, base64, base64.length);
      final ob1 = OBtagPixelData.fromBase64(
          PTag.kPrivateInformation, base64, base64.length);

      global.throwOnError = true;
      expect(
          () => OBtagPixelData.fromBase64(
              PTag.kVariableNextDataGroup, base64, base64.length),
          throwsA(const isInstanceOf<InvalidVRError>()));


      expect(ob0.tag == PTag.kPixelDataOB, true);
      expect(ob1.tag == PTag.kPrivateInformation, true);
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
      expect(ob1.vrIndex == kOBIndex, true);
      expect(ob0.fragments == null, true);
      expect(ob0.offsets == null, true);
      expect(ob0.isEncapsulated == false, true);
      expect(ob0.vfBytes is Bytes, true);
      log
        ..debug('ob0.vfBytes.length: ${ob0.vfBytes.length}')
        ..debug('ob0.values.length: ${ob0.values.length}')
        ..debug('ob0.vfLength: ${ob0.vfLength}')
        ..debug('ob0.vfLengthField: ${ob0.vfLengthField}');
      expect(ob0.vfBytes.length == ob0.vfLength, true);
      expect(ob0.pixels is Uint8List, true);
      expect(ob0.pixels.length == ob0.vfLength, true);
      log
        ..debug('ob0.length: ${ob0.length}')
        ..debug('frame.length: ${frame.length}');
      expect(ob0.lengthInBytes == frame.length, true);
      expect(ob0.valuesCopy, equals(ob0.pixels));
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
    });
*/
/*
    test('Create Unencapsulated OBtagPixelData.fromBase64 hashCode and ==', () {
      final base64 = cvt.base64.encode(frame);
      final ob0 =
          OBtagPixelData.fromBase64(PTag.kPixelDataOB, base64, base64.length);
      final ob1 =
          OBtagPixelData.fromBase64(PTag.kPixelDataOB, base64, base64.length);
      final ob2 = OBtagPixelData.fromBase64(
          PTag.kVariablePixelData, base64, base64.length);
      final ob3 = OBtagPixelData.fromBase64(
          PTag.kPrivateInformation, base64, base64.length);
      final ob4 = OBtagPixelData.fromBase64(
          PTag.kPrivateInformation, base64, base64.length);

      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);

      expect(ob3.hashCode == ob4.hashCode, true);
      expect(ob3 == ob4, true);

      expect(ob0.hashCode == ob2.hashCode, false);
      expect(ob0 == ob2, false);

      expect(ob0.hashCode == ob3.hashCode, false);
      expect(ob0 == ob3, false);
    });


    test('Create encapsulated OBtagPixelData.fromBase64', () {
      final base64 = cvt.base64.encode(frame);
      final frags = new VFFragments(fragments);

      final ob0 = OBtagPixelData.fromBase64(
          PTag.kPixelDataOB, base64, frame.length,  ts);

      final ob1 = OBtagPixelData.fromBase64(
          PTag.kPrivateInformation, base64, frame.length,  ts);

      global.throwOnError = true;
      expect(
          () => OBtagPixelData.fromBase64(PTag.kVariableNextDataGroup, base64,
              frame.length,  ts),
          throwsA(const isInstanceOf<InvalidVRError>()));

      expect(ob0.tag == PTag.kPixelDataOB, true);
      expect(ob1.tag == PTag.kPrivateInformation, true);
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
      expect(ob1.vrIndex == kOBIndex, true);
      expect(ob0.offsets == frags.offsets, true);
      expect(ob0.isEncapsulated == true, true);
      expect(ob0.vfBytes is Bytes, true);
      expect(ob0.vfBytes.length == frame.length, true);
      expect(ob0.pixels is Uint8List, true);
      expect(ob0.pixels == frags.bulkdata, true);
      expect(ob0.pixels.length == frags.bulkdata.length, true);
      expect(ob0.length == frags.bulkdata.length, true);
      expect(ob0.valuesCopy, equals(ob0.pixels));
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
    });
*/
/*
    test('Create encapsulated OBtagPixelData.fromBase64 hashCode and ==', () {
      final base64 = cvt.base64.encode(frame);
      final frags = new VFFragments(fragments);

      final ob0 = OBtagPixelData.fromBase64(
          PTag.kPixelDataOB, base64, frame.length,  ts);
      final ob1 = OBtagPixelData.fromBase64(
          PTag.kPixelDataOB, base64, frame.length,  ts);
      final ob2 = OBtagPixelData.fromBase64(
          PTag.kVariablePixelData, base64, frame.length,  ts);
      final ob3 = OBtagPixelData.fromBase64(
          PTag.kPrivateInformation, base64, frame.length,  ts);
      final ob4 = OBtagPixelData.fromBase64(
          PTag.kPrivateInformation, base64, frame.length,  ts);

      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);

      expect(ob3.hashCode == ob4.hashCode, true);
      expect(ob0 == ob1, true);

      expect(ob0.hashCode == ob2.hashCode, false);
      expect(ob0 == ob2, false);

      expect(ob0.hashCode == ob3.hashCode, false);
      expect(ob0 == ob3, false);
    });
*/
    test('OBtagPixelData.fromValues', () {
      final ob0 = OBtagPixelData.fromValues(PTag.kPixelDataOB, pixels);
      expect(ob0, isNotNull);
      expect(ob0,
          equals(new OBtagPixelData(PTag.kPixelDataOB, pixels, pixels.length)));

      final ob1 = OBtagPixelData.fromValues(PTag.kPixelDataOB, pixels);
      expect(ob1,
          equals(new OBtagPixelData(PTag.kPixelDataOB, pixels, pixels.length)));

      expect(ob0.tag == PTag.kPixelDataOB, true);
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
      expect(ob0.values is List<int>, true);
//      expect(ob0.fragments == null, true);
//      expect(ob0.offsets == null, true);
//      expect(ob0.isEncapsulated == false, true);
      log.debug(ob0.values);
      expect(ob0.hasValidValues, true);
      log.debug('bytes: ${ob0.vfBytes}');
      expect(ob0.vfBytes is Bytes, true);
      expect(ob0.vfBytes.length == 1024, true);
      expect(ob0.pixels is Uint8List, true);
      expect(ob0.pixels.length == 1024, true);
      expect(ob0.length == 1024, true);
      expect(ob0.valuesCopy, equals(ob0.pixels));
      expect(ob0.typedData is Uint8List, true);

      global.throwOnError = false;
      final ob2 = OBtagPixelData.fromValues(PTag.kVariablePixelData, pixels);
      expect(ob2, isNull);
/*
      expect(
          ob2,
          equals(new OBtagPixelData(
              PTag.kVariablePixelData, pixels, pixels.length)));
*/

      global.throwOnError = true;
      expect(() => OBtagPixelData.fromValues(PTag.kSelectorSTValue, pixels),
          throwsA(const isInstanceOf<InvalidTagError>()));

      global.throwOnError = false;
      final ob3 = OBtagPixelData.fromValues(PTag.kPrivateInformation, pixels);
    //  expect(ob3.tag == PTag.kPrivateInformation, true);
    //  expect(ob3.vrIndex == kOBIndex, true);
      expect(ob3, isNull);

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
      final ob0 = OBtagPixelData.fromValues(PTag.kPixelDataOB, pixels);
      final ob1 = OBtagPixelData.fromValues(PTag.kPixelDataOB, pixels);
      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);

      global.throwOnError = false;
      final ob2 = OBtagPixelData.fromValues(PTag.kVariablePixelData, pixels);
      expect(ob2, isNull);
      final ob3 = OBtagPixelData.fromValues(PTag.kPrivateInformation, pixels);
      expect(ob3, isNull);
      final ob4 = OBtagPixelData.fromValues(PTag.kPrivateInformation, pixels);
      expect(ob4, isNull);
/*
      expect(ob3.hashCode == ob4.hashCode, true);
      expect(ob3 == ob4, true);

      expect(ob0.hashCode == ob2.hashCode, false);
      expect(ob0 == ob2, false);

      expect(ob0.hashCode == ob3.hashCode, false);
      expect(ob0 == ob3, false);
*/

    });

    test('OBtagPixelData.fromBytes', () {
      final ob0 =
          OBtagPixelData.fromBytes(PTag.kPixelDataOB, frame, frame.length);
      expect(
          ob0,
          equals(OBtagPixelData.fromBytes(
              PTag.kPixelDataOB, frame, frame.length, ts)));
      expect(ob0.tag == PTag.kPixelDataOB, true);
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
//      expect(ob0.fragments == null, true);
//      expect(ob0.offsets == null, true);
//      expect(ob0.isEncapsulated == false, true);
      expect(ob0.vfBytes is Bytes, true);
      log
        ..debug('ob0.vfBytes.length: ${ob0.vfBytes.length}')
        ..debug('ob0.values.length: ${ob0.values.length}')
        ..debug('ob0.vfLength: ${ob0.vfLength}')
        ..debug('ob0.vfLengthField: ${ob0.vfLengthField}');
      expect(ob0.vfBytes.length == ob0.vfLength, true);
      expect(ob0.pixels is Uint8List, true);
      expect(ob0.pixels.length == ob0.vfLength, true);
      log
        ..debug('ob0.length: ${ob0.length}')
        ..debug('frame.length: ${frame.length}');
      expect(ob0.lengthInBytes == frame.length, true);
      expect(ob0.valuesCopy, equals(ob0.pixels));

      global.throwOnError = false;
      final ob1 = OBtagPixelData.fromBytes(
          PTag.kPrivateInformation, frame, frame.length);
//      expect(ob1.tag == PTag.kPrivateInformation, true);
//      expect(ob1.vrIndex == kOBIndex, true);
      expect(ob1, isNull);

      global.throwOnError = true;
      expect(
          () => OBtagPixelData.fromBytes(
              PTag.kSelectorSTValue, frame, frame.length),
          throwsA(const isInstanceOf<InvalidTagError>()));


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
      final ob0 =
          OBtagPixelData.fromBytes(PTag.kPixelDataOB, frame, frame.length);

      final ob1 =
          OBtagPixelData.fromBytes(PTag.kPixelDataOB, frame, frame.length);
      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);


      final ob2 = OBtagPixelData.fromBytes(
          PTag.kVariablePixelData, frame, frame.length);
expect(ob2, isNull);

      final ob3 = OBtagPixelData.fromBytes(
          PTag.kPrivateInformation, frame, frame.length);
      expect(ob3, isNull);

      final ob4 = OBtagPixelData.fromBytes(
          PTag.kPrivateInformation, frame, frame.length);
      expect(ob4, isNull);

/*
      expect(ob3.hashCode == ob4.hashCode, true);
      expect(ob3 == ob4, true);

      expect(ob0.hashCode == ob2.hashCode, false);
      expect(ob0 == ob2, false);

      expect(ob0.hashCode == ob4.hashCode, false);
      expect(ob0 == ob4, false);
*/

    });

/*
    test('OBtagPixelData.fromB64', () {
      final base64 = cvt.base64.encode(frame);
      final frags = new VFFragments(fragments);
      final ob0 = OBtagPixelData.fromBase64(
          PTag.kPixelDataOB, base64, base64.length,  ts);
      final ob1 = OBtagPixelData.fromBase64(
          PTag.kPrivateInformation, base64, base64.length,  ts);
      expect(
          ob0,
          equals(OBtagPixelData.fromBase64(
              PTag.kPixelDataOB, base64, base64.length,  ts)));

      global.throwOnError = true;
      expect(
          () => OBtagPixelData.fromBase64(
              PTag.kSelectorSTValue, base64, base64.length,  ts),
          throwsA(const isInstanceOf<InvalidTagError>()));

      expect(ob0.tag == PTag.kPixelDataOB, true);
      expect(ob1.tag == PTag.kPrivateInformation, true);
      expect(ob0.vrIndex == kOBOWIndex, false);
      expect(ob0.vrIndex == kOBIndex, true);
      expect(ob1.vrIndex == kOBIndex, true);
      expect(ob0.offsets == frags.offsets, true);
      expect(ob0.isEncapsulated == true, true);
      expect(ob0.vfBytes is Bytes, true);
      expect(ob0.vfBytes.length == frame.length, true);
      expect(ob0.pixels is Uint8List, true);
      expect(ob0.pixels == frags.bulkdata, true);
      expect(ob0.pixels.length == frags.bulkdata.length, true);
      expect(ob0.length == frags.bulkdata.length, true);
      expect(ob0.valuesCopy, equals(ob0.pixels));
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
    });
*/

/*
    test('OBtagPixelData.fromBase64 hashCode and ==', () {
      final base64 = cvt.base64.encode(frame);
      final frags = new VFFragments(fragments);
      final ob0 = OBtagPixelData.fromBase64(
          PTag.kPixelDataOB, base64, base64.length,  ts);
      final ob1 = OBtagPixelData.fromBase64(
          PTag.kPixelDataOB, base64, base64.length,  ts);
      final ob2 = OBtagPixelData.fromBase64(
          PTag.kVariablePixelData, base64, base64.length,  ts);
      final ob3 = OBtagPixelData.fromBase64(
          PTag.kVariablePixelData, base64, base64.length,  ts);
      final ob4 = OBtagPixelData.fromBase64(
          PTag.kVariablePixelData, base64, base64.length,  ts);

      //hash_code : good and bad
      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);

      expect(ob3.hashCode == ob4.hashCode, true);
      expect(ob3 == ob4, true);

      expect(ob0.hashCode == ob2.hashCode, false);
      expect(ob0 == ob2, false);

      expect(ob0.hashCode == ob4.hashCode, false);
      expect(ob0 == ob4, false);
    });
*/

    test('OBPixelData from', () {
      final ob0 =
          new OBtagPixelData(PTag.kPrivateInformation, pixels, pixels.length);
      expect(ob0, isNull);

/*      final obfrom0 = OBtagPixelData.fromValues(ob0.tag, ob0.values);

      expect(obfrom0.tag == PTag.kPrivateInformation, true);
      expect(obfrom0.vrIndex == kOBOWIndex, false);
      expect(obfrom0.vrIndex == kOBIndex, true);
      expect(obfrom0.values is List<int>, true);
//      expect(obfrom0.fragments == null, true);
//      expect(obfrom0.offsets == null, true);
//      expect(obfrom0.isEncapsulated == false, true);
      log.debug(obfrom0.values);
      expect(obfrom0.hasValidValues, true);
      log.debug('bytes: ${obfrom0.vfBytes}');
      expect(obfrom0.vfBytes is Bytes, true);
      expect(obfrom0.vfBytes.length == 1024, true);
      expect(obfrom0.pixels is Uint8List, true);
      expect(obfrom0.pixels.length == 1024, true);
      expect(obfrom0.length == 1024, true);
      expect(obfrom0.valuesCopy, equals(obfrom0.pixels));
      expect(obfrom0.typedData is Uint8List, true);

      final s = Sha256.uint8(pixels);
      expect(obfrom0.sha256, equals(obfrom0.update(s)));

      for (var s in frame) {
        expect(obfrom0.checkValue(s), true);
      }

      expect(obfrom0.checkValue(kUint8Max), true);
      expect(obfrom0.checkValue(kUint8Min), true);
      expect(obfrom0.checkValue(kUint8Max + 1), false);
      expect(obfrom0.checkValue(kUint8Min - 1), false);*/
    });

    test('OBPixelData fromBytes', () {
      final bytes0 = new Bytes.fromList(testFrame);
      final fBytes0 =
          OBtagPixelData.fromBytes(PTag.kPrivateInformation, bytes0);
      expect(fBytes0, isNull);

/*
      expect(fBytes0,
          equals(OBtagPixelData.fromBytes(PTag.kPrivateInformation, bytes0)));

      global.throwOnError = true;
      expect(() => OBtagPixelData.fromBytes(PTag.kSelectorAEValue, bytes0),
          throwsA(const isInstanceOf<InvalidTagError>()));

      global.throwOnError = false;
      expect(fBytes0.tag == PTag.kPrivateInformation, true);
      expect(fBytes0.vrIndex == kOBOWIndex, false);
      expect(fBytes0.vrIndex == kOBIndex, true);
      expect(fBytes0.values is List<int>, true);
//      expect(fBytes0.fragments == null, true);
//      expect(fBytes0.offsets == null, true);
//      expect(fBytes0.isEncapsulated == false, true);
      log.debug(fBytes0.values);
      expect(fBytes0.hasValidValues, true);
      log.debug('bytes: ${fBytes0.vfBytes}');
      expect(fBytes0.vfBytes is Bytes, true);
      expect(fBytes0.vfBytes.length == 139782, true);
      expect(fBytes0.pixels is Uint8List, true);
      expect(fBytes0.pixels.length == 139782, true);
      expect(fBytes0.length == 139782, true);
      expect(fBytes0.valuesCopy, equals(fBytes0.pixels));
      expect(fBytes0.typedData is Uint8List, true);

      expect(fBytes0.checkValue(kUint8Max), true);
      expect(fBytes0.checkValue(kUint8Min), true);
      expect(fBytes0.checkValue(kUint8Max + 1), false);
      expect(fBytes0.checkValue(kUint8Min - 1), false);
*/

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
          throwsA(const isInstanceOf<InvalidValuesError>()));
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
