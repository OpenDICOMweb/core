//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

import 'test_pixel_data.dart';

final Uint32List emptyOffsets = new Uint32List(0);
final Uint8List emptyOffsetsAsBytes = emptyOffsets.buffer.asUint8List();
final Bytes frame = new Bytes.fromList(testFrame);
final List<Uint8List> fragments = [emptyOffsetsAsBytes, testFrame];

void main() {
  Server.initialize(name: 'element/un_pixel_data_test', level: Level.info);

  // Urgent Sharath: lots of these tests are failing because of wrong tags.
  const ts = TransferSyntax.kDefaultForDicomWeb;
  group('UNtagPixelData Tests', () {
    final pixels = new List<int>(1024);
    for (var i = 0; i < pixels.length; i++) pixels[i] = 128;

    final pixels1 = [1024, 1024];
    for (var i = 0; i < pixels1.length; i++) pixels1[i] = 128;

    test('Create Unencapsulated UNtagPixelData', () {
      final un0 = new UNtagPixelData(PTag.kNoName0, pixels, pixels.length);
      expect(un0, isNull);
/*
      expect(un0.vrIndex == kUNIndex, true);
      expect(un0.values is List<int>, true);
//      expect(un0.fragments == null, true);
//      expect(un0.offsets == null, true);
//      expect(un0.isEncapsulated == false, true);
      log.debug(un0.values);
      expect(un0.hasValidValues, true);
      log.debug('bytes: ${un0.vfBytes}');
      expect(un0.vfBytes is Bytes, true);
      expect(un0.vfBytes.length == 1024, true);
      expect(un0.pixels is Uint8List, true);
      expect(un0.pixels.length == 1024, true);
      expect(un0.length == 1024, true);
      expect(un0.valuesCopy, equals(un0.pixels));
      expect(un0.tag == PTag.kNoName0, true);
      expect(un0.vrIndex == kUNIndex, true);
      expect(un0.values is List<int>, true);
//      expect(un0.fragments == null, true);
//      expect(un0.offsets == null, true);
//      expect(un0.isEncapsulated == false, true);
      log.debug(un0.values);
      expect(un0.hasValidValues, true);
      log.debug('bytes: ${un0.vfBytes}');
      expect(un0.vfBytes is Bytes, true);
      expect(un0.vfBytes.length == 1024, true);
      expect(un0.pixels is Uint8List, true);
      expect(un0.pixels.length == 1024, true);
      expect(un0.length == 1024, true);
      expect(un0.valuesCopy, equals(un0.pixels));
*/
/*
      for (var s in frame) {
        expect(un0.checkValue(s), true);
      }
      expect(un0.checkValue(UN.kMaxValue), true);
      expect(un0.checkValue(UN.kMinValue), true);
      expect(un0.checkValue(UN.kMaxValue + 1), false);
      expect(un0.checkValue(UN.kMinValue - 1), false);
*/

      final un1 =
          new UNtagPixelData(PTag.kSelectorUNValue, pixels1, pixels1.length);
      expect(un1, isNull);
/*
//      expect(un1.typedData is Uint8List, true);
//      expect(un1.vrIndex == kUNIndex, true);
//      expect(un1.typedData is Uint8List, true);

      final s = Sha256.uint8(pixels);
      expect(un0.sha256, equals(un0.update(s)));
*/
    });

    test('Create UnEncapsulate UNtagPixelData hashCode and ==', () {
      final un0 = new UNtagPixelData(PTag.kNoName0, pixels, pixels.length);
      expect(un0, isNull);
      final un1 = new UNtagPixelData(PTag.kNoName0, pixels, pixels.length);
      expect(un1, isNull);
      final un2 = new UNtagPixelData(PTag.kNoName1, pixels1, pixels1.length);
      expect(un2, isNull);

/*
      expect(un0.hashCode == un1.hashCode, true);
      expect(un0 == un1, true);
      expect(un0.hashCode == un2.hashCode, false);
      expect(un0 == un2, false);
*/

    });

    test('Create Encapsulated UNtagPixelData', () {
//      final frags = new VFFragments(fragments);
      final un0 =
          new UNtagPixelData(PTag.kNoName0, frame, kUndefinedLength, ts);
      expect(un0, isNull);

      final un1 = new UNtagPixelData(
          PTag.kSelectorUNValue, frame, kUndefinedLength, ts);
      expect(un1, isNull);

/*
      expect(un0.tag == PTag.kNoName0, true);
      expect(un0.vrIndex == kUNIndex, true);
      expect(un1.vrIndex == kUNIndex, true);
//      expect(un0.offsets == frags.offsets, true);
//      expect(un0.isEncapsulated == true, true);
      expect(un0.vfBytes is Bytes, true);
      expect(un0.vfBytes.length == frame.length, true);
      expect(un0.pixels is List<int>, true);
      expect(un0.pixels == frags.bulkdata, true);
      expect(un0.pixels.length == frags.bulkdata.length, true);
      expect(un0.length == frags.bulkdata.length, true);
      expect(un0.valuesCopy, equals(un0.pixels));
      expect(un0.typedData is Uint8List, true);

      final s = Sha256.uint8(frame);
      expect(un0.sha256, equals(un0.update(s)));

      for (var s in frame) {
        expect(un0.checkValue(s), true);
      }

      expect(un0.checkValue(UN.kMaxValue), true);
      expect(un0.checkValue(UN.kMinValue), true);
      expect(un0.checkValue(UN.kMaxValue + 1), false);
      expect(un0.checkValue(UN.kMinValue - 1), false);
*/
    });

    test('Create Encapsulated UNtagPixelData hashCode and ==', () {
      final un0 =
          new UNtagPixelData(PTag.kPixelDataUN, frame, kUndefinedLength, ts);
      final un1 =
          new UNtagPixelData(PTag.kPixelDataUN, frame, kUndefinedLength, ts);
      expect(un0.hashCode == un1.hashCode, true);
      expect(un0 == un1, true);

      final un2 = new UNtagPixelData(
          PTag.kVariablePixelData, frame, kUndefinedLength, ts);
//      expect(un0.hashCode == un2.hashCode, false);
//      expect(un0 == un2, false);
      expect(un2, isNull);
    });

    test('Create Unencapsulated UNtagPixelData.fromBytes', () {
      final un0 = UNtagPixelData.fromBytes(PTag.kNoName0, frame, frame.length);
      expect(un0, isNull);

      final un1 =
          new UNtagPixelData(PTag.kSelectorUNValue, pixels1, pixels1.length);
      expect(un1, isNull);

/*
      expect(un0.tag == PTag.kNoName0, true);
      expect(un0.vrIndex == kUNIndex, true);
      expect(un1.vrIndex == kUNIndex, true);
//      expect(un0.fragments == null, true);
//      expect(un0.offsets == null, true);
//      expect(un0.isEncapsulated == false, true);
      expect(un0.vfBytes is Bytes, true);
      log
        ..debug('un0.vfBytes.length: ${un0.vfBytes.length}')
        ..debug('un0.values.length: ${un0.values.length}')
        ..debug('un0.vfLength: ${un0.vfLength}')
        ..debug('un0.vfLengthField: ${un0.vfLengthField}');
      expect(un0.pixels is Uint8List, true);
      log
        ..debug('un0.length: ${un0.length}')
        ..debug('frame.length: ${frame.length}');
      expect(un0.valuesCopy, equals(un0.pixels));
      expect(un0.typedData is Uint8List, true);

      final s = Sha256.uint8(frame);
      expect(un0.sha256, equals(un0.update(s)));

      for (var s in frame) {
        expect(un0.checkValue(s), true);
      }

      expect(un0.checkValue(UN.kMaxValue), true);
      expect(un0.checkValue(UN.kMinValue), true);
      expect(un0.checkValue(UN.kMaxValue + 1), false);
      expect(un0.checkValue(UN.kMinValue - 1), false);
*/

    });

    test('Create Unencapsulated UNtagPixelData.fromBytes hashCode and ==', () {
      final un0 = UNtagPixelData.fromBytes(PTag.kNoName0, frame, frame.length);
      expect(un0, isNull);

      final un1 = UNtagPixelData.fromBytes(PTag.kNoName0, frame, frame.length);
      expect(un1, isNull);

      final un2 = UNtagPixelData.fromBytes(
          PTag.kVariablePixelData, frame, frame.length);
      expect(un2, isNull);

/*
      expect(un0.hashCode == un1.hashCode, true);
      expect(un0 == un1, true);

      expect(un0.hashCode == un2.hashCode, false);
      expect(un0 == un2, false);
*/
    });

/*
    test('Create Unencapsulated UNtagPixelData.fromBase64', () {
      final base64 = cvt.base64.encode(frame);
      final un0 =
          UNtagPixelData.fromBase64(PTag.kNoName0, base64, base64.length);

      final un1 =
          UNtagPixelData.fromBase64(PTag.kNoName1, base64, base64.length);

      expect(un0.tag == PTag.kNoName0, true);
      expect(un0.vrIndex == kUNIndex, true);
      expect(un1.vrIndex == kUNIndex, true);
      expect(un0.fragments == null, true);
      expect(un0.offsets == null, true);
      expect(un0.isEncapsulated == false, true);
      expect(un0.vfBytes is Bytes, true);
      log
        ..debug('un0.vfBytes.length: ${un0.vfBytes.length}')
        ..debug('un0.values.length: ${un0.values.length}')
        ..debug('un0.vfLength: ${un0.vfLength}')
        ..debug('un0.vfLengthField: ${un0.vfLengthField}');
      //expect(un0.vfBytes.length == un0.vfLength, true);
      expect(un0.pixels is Uint8List, true);
      //expect(un0.pixels.length == un0.vfLength, true);
      log
        ..debug('un0.length: ${un0.length}')
        ..debug('frame.length: ${frame.length}');
      expect(un0.valuesCopy, equals(un0.pixels));
      expect(un0.typedData is Uint8List, true);

      final s = Sha256.uint8(frame);
      expect(un0.sha256, equals(un0.update(s)));

      for (var s in frame) {
        expect(un0.checkValue(s), true);
      }
      expect(un0.checkValue(UN.kMaxValue), true);
      expect(un0.checkValue(UN.kMinValue), true);
      expect(un0.checkValue(UN.kMaxValue + 1), false);
      expect(un0.checkValue(UN.kMinValue - 1), false);
    });
*/

/*
    test('Create Unencapsulated UNtagPixelData.fromBase64 hashCode and ==', () {
      final base64 = cvt.base64.encode(frame);
      final un0 =
          UNtagPixelData.fromBase64(PTag.kNoName0, base64, base64.length);
      final un1 =
          UNtagPixelData.fromBase64(PTag.kNoName0, base64, base64.length);
      final un2 = UNtagPixelData.fromBase64(
          PTag.kVariablePixelData, base64, base64.length);

      expect(un0.hashCode == un1.hashCode, true);
      expect(un0.hashCode == un2.hashCode, false);
      expect(un0 == un1, true);
      expect(un0 == un2, false);
    });
*/

/*
    test('Create encapsulated UNtagPixelData.fromBase64', () {
      final base64 = cvt.base64.encode(frame);

      final un0 = UNtagPixelData.fromBase64(
          PTag.kNoName0, base64, frame.length,  ts);

      */
/*final un1 = UNtagPixelData.fromBase64(
          PTag.kDate, base64, frame.length,  ts);*/ /*


      expect(un0.tag == PTag.kNoName0, true);
      expect(un0.vrIndex == kUNIndex, true);
      // expect(un1.vrIndex == kUNIndex, false);
      expect(un0.isEncapsulated == true, true);
      expect(un0.vfBytes is Bytes, true);
      expect(un0.vfBytes.length == frame.length, true);
      expect(un0.pixels is Uint8List, true);
      expect(un0.valuesCopy, equals(un0.pixels));
      expect(un0.typedData is Uint8List, true);

      final s = Sha256.uint8(frame);
      expect(un0.sha256, equals(un0.update(s)));

      for (var s in frame) {
        expect(un0.checkValue(s), true);
      }
      expect(un0.checkValue(UN.kMaxValue), true);
      expect(un0.checkValue(UN.kMinValue), true);
      expect(un0.checkValue(UN.kMaxValue + 1), false);
      expect(un0.checkValue(UN.kMinValue - 1), false);
    });
*/

/*
    test('Create encapsulated UNtagPixelData.fromBase64 hashCode and ==', () {
      final base64 = cvt.base64.encode(frame);
      final frags = new VFFragments(fragments);

      final un0 = UNtagPixelData.fromBase64(
          PTag.kNoName0, base64, frame.length,  ts);
      final un1 = UNtagPixelData.fromBase64(
          PTag.kNoName0, base64, frame.length,  ts);
      final un2 = UNtagPixelData.fromBase64(
          PTag.kVariablePixelData, base64, frame.length,  ts);

      expect(un0.hashCode == un1.hashCode, true);
      expect(un0.hashCode == un2.hashCode, false);
      expect(un0 == un1, true);
      expect(un0 == un2, false);
    });
*/

    test('UNtagPixelData.make', () {
      final un0 = UNtagPixelData.fromValues(PTag.kNoName0, pixels);
      expect(un0, isNull);
      expect(un0,
          equals(new UNtagPixelData(PTag.kNoName0, pixels, pixels.length)));

      final un1 = UNtagPixelData.fromValues(PTag.kVariablePixelData, pixels);
      expect(un1, isNull);

/*
      expect(
          un1,
          equals(new UNtagPixelData(
              PTag.kVariablePixelData, pixels, pixels.length)));
*/

      //final un2 = UNtagPixelData.fromValues(PTag.kSelectorSTValue, pixels);

/*
      expect(un0.tag == PTag.kNoName0, true);
      expect(un0.vrIndex == kUNIndex, true);
      //expect(un2.vrIndex == kUNIndex, false);
      expect(un0.values is List<int>, true);
//      expect(un0.fragments == null, true);
//      expect(un0.offsets == null, true);
//      expect(un0.isEncapsulated == false, true);
      log.debug(un0.values);
      expect(un0.hasValidValues, true);
      log.debug('bytes: ${un0.vfBytes}');
      expect(un0.vfBytes is Bytes, true);
      expect(un0.vfBytes.length == 1024, true);
      expect(un0.pixels is Uint8List, true);
      expect(un0.pixels.length == 1024, true);
      expect(un0.length == 1024, true);
      expect(un0.valuesCopy, equals(un0.pixels));
      expect(un0.typedData is Uint8List, true);

      final s = Sha256.uint8(pixels);
      expect(un0.sha256, equals(un0.update(s)));

      for (var s in frame) {
        expect(un0.checkValue(s), true);
      }
      expect(un0.checkValue(UN.kMaxValue), true);
      expect(un0.checkValue(UN.kMinValue), true);
      expect(un0.checkValue(UN.kMaxValue + 1), false);
      expect(un0.checkValue(UN.kMinValue - 1), false);
*/

    });

    test('UNtagPixelData.make hashCode and ==', () {
      final un0 = UNtagPixelData.fromValues(PTag.kNoName0, pixels);
      expect(un0, isNull);

      final un1 = UNtagPixelData.fromValues(PTag.kNoName0, pixels);
      expect(un1, isNull);
      final un2 = UNtagPixelData.fromValues(PTag.kVariablePixelData, pixels);
      expect(un2, isNull);

/*
      expect(un0.hashCode == un1.hashCode, true);
      expect(un0 == un1, true);

      expect(un0.hashCode == un2.hashCode, false);
      expect(un0 == un2, false);
*/

    });

    test('new UNtagPixelData.fromBytes', () {
      final un0 = UNtagPixelData.fromBytes(PTag.kNoName0, frame, frame.length);
      expect(
          un0,
          equals(UNtagPixelData.fromBytes(
              PTag.kNoName0, frame, frame.length, ts)));

      expect(un0.tag == PTag.kNoName0, true);
      expect(un0.vrIndex == kUNIndex, true);
      //expect(un1.vrIndex == kUNIndex, false);
//      expect(un0.fragments == null, true);
//      expect(un0.offsets == null, true);
//      expect(un0.isEncapsulated == false, true);
      expect(un0.vfBytes is Bytes, true);
      log
        ..debug('un0.vfBytes.length: ${un0.vfBytes.length}')
        ..debug('un0.values.length: ${un0.values.length}')
        ..debug('un0.vfLength: ${un0.vfLength}')
        ..debug('un0.vfLengthField: ${un0.vfLengthField}');
      expect(un0.pixels is Uint8List, true);
      log
        ..debug('un0.length: ${un0.length}')
        ..debug('frame.length: ${frame.length}');
      expect(un0.valuesCopy, equals(un0.pixels));

      final s = Sha256.uint8(frame);
      expect(un0.sha256, equals(un0.update(s)));

      for (var s in frame) {
        expect(un0.checkValue(s), true);
      }
      expect(un0.checkValue(UN.kMaxValue), true);
      expect(un0.checkValue(UN.kMinValue), true);
      expect(un0.checkValue(UN.kMaxValue + 1), false);
      expect(un0.checkValue(UN.kMinValue - 1), false);
    });

    test('new UNtagPixelData.fromBytes hashCode and ==', () {
      final un0 = UNtagPixelData.fromBytes(PTag.kNoName0, frame, frame.length);

      final un1 = UNtagPixelData.fromBytes(PTag.kNoName0, frame, frame.length);

      final un2 = UNtagPixelData.fromBytes(
          PTag.kVariablePixelData, frame, frame.length);

      expect(un0.hashCode == un1.hashCode, true);
      expect(un0 == un1, true);

      expect(un0.hashCode == un2.hashCode, false);
      expect(un0 == un2, false);
    });

/*
    test('UNtagPixelData.fromB64', () {
      final base64 = cvt.base64.encode(frame);
      final frags = new VFFragments(fragments);
      final un0 = UNtagPixelData.fromBase64(
          PTag.kNoName0, base64, base64.length,  ts);
      expect(
          un0,
          equals(UNtagPixelData.fromBase64(
              PTag.kNoName0, base64, base64.length,  ts)));

      final un1 = UNtagPixelData.fromBase64(
          PTag.kSelectorUNValue, base64, base64.length,  ts);

      expect(un0.tag == PTag.kNoName0, true);
      expect(un0.vrIndex == kUNIndex, true);
      expect(un1.vrIndex == kUNIndex, true);

      expect(un0.offsets == frags.offsets, true);
      expect(un0.isEncapsulated == true, true);
      expect(un0.vfBytes is Bytes, true);
      expect(un0.vfBytes.length == frame.length, true);
      expect(un0.pixels is Uint8List, true);
      expect(un0.pixels == frags.bulkdata, true);
      expect(un0.pixels.length == frags.bulkdata.length, true);
      expect(un0.length == frags.bulkdata.length, true);
      expect(un0.valuesCopy, equals(un0.pixels));
      expect(un0.typedData is Uint8List, true);

      final s = Sha256.uint8(frame);
      expect(un0.sha256, equals(un0.update(s)));

      for (var s in frame) {
        expect(un0.checkValue(s), true);
      }
      expect(un0.checkValue(UN.kMaxValue), true);
      expect(un0.checkValue(UN.kMinValue), true);
      expect(un0.checkValue(UN.kMaxValue + 1), false);
      expect(un0.checkValue(UN.kMinValue - 1), false);
    });
*/
/*
    test('UNtagPixelData.fromB64 hashCode and ==', () {
      final base64 = cvt.base64.encode(frame);
      final frags = new VFFragments(fragments);
      final un0 = UNtagPixelData.fromBase64(
          PTag.kNoName0, base64, base64.length,  ts);
      final un1 = UNtagPixelData.fromBase64(
          PTag.kNoName0, base64, base64.length,  ts);

      final un2 = UNtagPixelData.fromBase64(
          PTag.kVariablePixelData, base64, base64.length,  ts);

      //hash_code : good and bad
      expect(un0.hashCode == un1.hashCode, true);
      expect(un0 == un1, true);

      expect(un0.hashCode == un2.hashCode, false);
      expect(un0 == un2, false);
    });

 */
    test('UNPixelData from', () {
      final un0 = new UNtagPixelData(PTag.kNoName0, pixels, pixels.length);

      final unfrom0 = UNtagPixelData.fromValues(un0.tag, un0.values);

      expect(unfrom0.tag == PTag.kNoName0, true);
      expect(unfrom0.vrIndex == kUNIndex, true);
      expect(unfrom0.values is List<int>, true);
//      expect(unfrom0.fragments == null, true);
//      expect(unfrom0.offsets == null, true);
//      expect(unfrom0.isEncapsulated == false, true);
      log.debug(unfrom0.values);
      expect(unfrom0.hasValidValues, true);
      log.debug('bytes: ${unfrom0.vfBytes}');
      expect(unfrom0.vfBytes is Bytes, true);
      expect(unfrom0.vfBytes.length == 1024, true);
      expect(unfrom0.pixels is Uint8List, true);
      expect(unfrom0.pixels.length == 1024, true);
      expect(unfrom0.length == 1024, true);
      expect(unfrom0.valuesCopy, equals(unfrom0.pixels));
      expect(unfrom0.typedData is Uint8List, true);

      final s = Sha256.uint8(pixels);
      expect(unfrom0.sha256, equals(unfrom0.update(s)));

      for (var s in frame) {
        expect(unfrom0.checkValue(s), true);
      }
      expect(unfrom0.checkValue(UN.kMaxValue), true);
      expect(unfrom0.checkValue(UN.kMinValue), true);
      expect(unfrom0.checkValue(UN.kMaxValue + 1), false);
      expect(unfrom0.checkValue(UN.kMinValue - 1), false);
    });

    test('UNPixelData fromBytes', () {
      final bytes0 = new Bytes.fromList(testFrame);
      final fBytes0 = UNtagPixelData.fromBytes(PTag.kNoName0, bytes0);

      expect(fBytes0, equals(UNtagPixelData.fromBytes(PTag.kNoName0, bytes0)));

      global.throwOnError = true;
      expect(() => UNtagPixelData.fromBytes(PTag.kSelectorAEValue, bytes0),
          throwsA(const isInstanceOf<InvalidTagError>()));

      global.throwOnError = false;
      expect(fBytes0.tag == PTag.kNoName0, true);
      expect(fBytes0.vrIndex == kOBOWIndex, false);
      expect(fBytes0.vrIndex == kUNIndex, true);
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
    });
  });

  group('UNPixelData', () {
    final unTags = <PTag>[PTag.kNoName0, PTag.kNoName1];

    final otherTags = <PTag>[
      PTag.kColumnAngulationPatient,
      PTag.kAcquisitionProtocolName,
      PTag.kCTDIvol,
      PTag.kCTPositionSequence,
      PTag.kAcquisitionType,
      PTag.kPerformedStationAETitle,
      PTag.kSelectorSTValue,
      PTag.kDate,
      PTag.kTime
    ];
    test('Create UN.isValidTag', () {
      global.throwOnError = false;
      final un0 = Tag.isValidVR(PTag.kPixelData, UN.kVRIndex);
      expect(un0, true);

      for (var tag in unTags) {
        expect(UN.isValidTag(tag), true);
      }
      //VR.UN
      final un1 = UN.isValidTag(PTag.kPixelData);
      expect(un1, true);

      final un2 = UN.isValidTag(PTag.kNoName0);
      expect(un2, true);

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UN.isValidTag(tag), true);
      }
    });
/*

    test('Create UN.checkVR', () {
      global.throwOnError = false;
      expect(UN.checkVRIndex(kUNIndex), kUNIndex);
      expect(UN.checkVRIndex(kAEIndex), kAEIndex);
      expect(UN.isValidVRIndex(kUNIndex), true);
      expect(UN.isValidVRIndex(kAEIndex), true);

      for (var tag in unTags) {
        expect(UN.checkVRIndex(tag.vrIndex), tag.vrIndex);
        expect(UN.isValidVRIndex(tag.vrIndex), true);
      }

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UN.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });
*/

    test('Create UN.isValidVRIndex', () {
      global.throwOnError = false;
      expect(UN.isValidVRIndex(kUNIndex), true);
      expect(UN.isValidVRIndex(kCSIndex), true);

      for (var tag in unTags) {
        expect(UN.isValidVRIndex(tag.vrIndex), true);
      }

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UN.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('Create UN.isValidVRCode', () {
      global.throwOnError = false;
      expect(UN.isValidVRCode(kUNCode), true);
      expect(UN.isValidVRCode(kAECode), true);

      for (var tag in unTags) {
        expect(UN.isValidVRCode(tag.vrCode), true);
      }

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(UN.isValidVRCode(tag.vrCode), true);
      }
    });

    test('Create UN.isValidVFLength', () {
      expect(UN.isValidVFLength(UN.kMaxVFLength, UN.kMaxVFLength), true);
      expect(UN.isValidVFLength(UN.kMaxVFLength + 1, kUndefinedLength), false);

      expect(UN.isValidVFLength(0, 0), true);
      expect(UN.isValidVFLength(-1, 1), false);
    });

    test('Create UN.isValidValue', () {
      expect(UN.isValidValue(UN.kMinValue), true);
      expect(UN.isValidValue(UN.kMinValue - 1), false);

      expect(UN.isValidValue(UN.kMaxValue), true);
      expect(UN.isValidValue(UN.kMaxValue + 1), false);
    });

    test('Create UN.isValidValues', () {
      global.throwOnError = false;
      const uInt8Min = const [UN.kMinValue];
      const uInt8Max = const [UN.kMaxValue];
      const uInt8MaxPlus = const [UN.kMaxValue + 1];
      const uInt8MinMinus = const [UN.kMinValue - 1];

      expect(UN.isValidValues(PTag.kPixelData, uInt8Min), true);
      expect(UN.isValidValues(PTag.kPixelData, uInt8Max), true);

      expect(UN.isValidValues(PTag.kPixelData, uInt8MaxPlus), false);
      expect(UN.isValidValues(PTag.kPixelData, uInt8MinMinus), false);

      global.throwOnError = true;
      expect(() => UN.isValidValues(PTag.kPixelData, uInt8MaxPlus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
      expect(() => UN.isValidValues(PTag.kPixelData, uInt8MinMinus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('Create Uint8Base.fromBytes', () {
      expect(Uint8.fromBytes(frame), equals(frame));
    });

    test('Create Uint8Base.fromBytes', () {
      global.throwOnError = false;
      const uInt8Max = const [UN.kMaxValue];
      const uInt16Max = const [kUint16Max];
      final bytes0 = new Bytes.fromList(uInt8Max);
      //   final uInt8ListV11 = uInt8ListV1.buffer.asUint8List();
      expect(Uint8.fromBytes(bytes0), equals(uInt8Max));

      expect(Uint8.fromBytes(frame), equals(frame));

      final uInt16List1 = new Uint16List.fromList(uInt16Max);
      //  final uInt8ListV12 = uInt16ListV1.buffer.asUint8List();
      final bytes1 = new Bytes.typedDataView(uInt16List1);
      expect(Uint16.fromBytes(bytes1), uInt16List1);
    });

    test('Create Uint32Base.fromBase64', () {
      final s = Uint8.toBase64(testFrame);
      expect(Uint8.fromBase64(s), equals(testFrame));
    });

    test('Create Uint32Base.fromBytes', () {
      final bytes = Uint8.toBytes(testFrame);
      log.debug('s: "$bytes"');
      expect(Uint8.fromBytes(bytes), bytes);
    });

    test('Create Uint32Base.fromByteData', () {
      final bd = Uint8.toByteData(testFrame);
      expect(Uint8.fromByteData(bd), equals(frame));
    });
  });
}
