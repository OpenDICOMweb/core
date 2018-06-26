//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

import 'test_pixel_data.dart';

final Uint32List emptyOffsets = new Uint32List(0);
final Uint8List emptyOffsetsAsBytes = emptyOffsets.buffer.asUint8List();
final Bytes frame = new Bytes.fromList(testFrame);
final List<Uint8List> fragments = [emptyOffsetsAsBytes, testFrame];

void main() {
  Server.initialize(name: 'element/un_pixel_data_test', level: Level.info);

  const ts = TransferSyntax.kDefaultForDicomWeb;
  group('UNtagPixelData Tests', () {
    final pixels = new List<int>(1024);
    for (var i = 0; i < pixels.length; i++) pixels[i] = 128;

    final pixels1 = [1024, 1024];
    for (var i = 0; i < pixels1.length; i++) pixels1[i] = 128;

    test('Create Unencapsulated UNtagPixelData', () {
      
/*
      final e0 = new UNtagPixelData(PTag.kNoName0, pixels);
      expect(e0, isNull);
*/

      final e1 = new UNtagPixelData(pixels);

      expect(e1.vrIndex == kUNIndex, true);
      expect(e1.values is List<int>, true);
//      expect(un1.fragments == null, true);
//      expect(un1.offsets == null, true);
//      expect(un1.isEncapsulated == false, true);
      log.debug(e1.values);
      expect(e1.hasValidValues, true);
      log.debug('bytes: ${e1.vfBytes}');
      expect(e1.vfBytes is Bytes, true);
      expect(e1.vfBytes.length == 1024, true);
      expect(e1.values is Uint8List, true);
      expect(e1.values.length == 1024, true);
      expect(e1.length == 1024, true);
      expect(e1.valuesCopy, equals(e1.values));
      expect(e1.tag == PTag.kPixelDataUN, true);
      log.debug(e1.values);
      expect(e1.hasValidValues, true);
      log.debug('bytes: ${e1.vfBytes}');

      for (var s in frame) {
        expect(e1.checkValue(s), true);
      }
      expect(e1.checkValue(UN.kMaxValue), true);
      expect(e1.checkValue(UN.kMinValue), true);
      expect(e1.checkValue(UN.kMaxValue + 1), false);
      expect(e1.checkValue(UN.kMinValue - 1), false);

/*
      final un2 =
          new UNtagPixelData(PTag.kSelectorUNValue, pixels1);
      expect(un2, isNull);
*/

      expect(e1.typedData is Uint8List, true);
      expect(e1.vrIndex == kUNIndex, true);
      expect(e1.typedData is Uint8List, true);

      final s = Sha256.uint8(pixels);
      expect(e1.sha256, equals(e1.update(s)));
    });

    test('Create UnEncapsulate UNtagPixelData hashCode and ==', () {
/*
      final e0 = new UNtagPixelData(PTag.kNoName0, pixels);
      expect(e0, isNull);
      final e1 = new UNtagPixelData(PTag.kNoName0, pixels);
      expect(e1, isNull);
      final e2 = new UNtagPixelData(PTag.kNoName1, pixels1);
      expect(e2, isNull);
*/

      final e3 = new UNtagPixelData(pixels);
      final e4 = new UNtagPixelData(pixels);
      final e5 = new UNtagPixelData(pixels1);

      expect(e3.hashCode == e4.hashCode, true);
      expect(e3 == e4, true);
      expect(e4.hashCode == e5.hashCode, false);
      expect(e4 == e5, false);
    });

    test('Create Encapsulated UNtagPixelData', () {
/*
//      final frags = new VFFragments(fragments);
      final e0 = new UNtagPixelData(PTag.kNoName0, frame, kUndefinedLength, ts);
      expect(e0, isNull);

      final e1 = new UNtagPixelData(
          PTag.kSelectorUNValue, frame, kUndefinedLength, ts);
      expect(e1, isNull);
*/

      final e2 =
          new UNtagPixelData(frame,  ts);

      expect(e2.tag == PTag.kPixelDataUN, true);
      expect(e2.vrIndex == kUNIndex, true);
//      expect(un3.offsets == frags.offsets, true);
//      expect(un3.isEncapsulated == true, true);
      expect(e2.vfBytes is Bytes, true);
      expect(e2.vfBytes.length == frame.length, true);
      expect(e2.values is List<int>, true);
      //expect(un3.values == frags.bulkdata, true);
      //expect(un3.values.length == frags.bulkdata.length, true);
      //expect(un3.length == frags.bulkdata.length, true);
      expect(e2.valuesCopy, equals(e2.values));
      expect(e2.typedData is Uint8List, true);

      final s = Sha256.uint8(frame);
      expect(e2.sha256, equals(e2.update(s)));

      for (var s in frame) {
        expect(e2.checkValue(s), true);
      }

      expect(e2.checkValue(UN.kMaxValue), true);
      expect(e2.checkValue(UN.kMinValue), true);
      expect(e2.checkValue(UN.kMaxValue + 1), false);
      expect(e2.checkValue(UN.kMinValue - 1), false);
    });

    test('Create Encapsulated UNtagPixelData hashCode and ==', () {
      final e0 =
          new UNtagPixelData(frame,  ts);
      final e1 =
          new UNtagPixelData(frame,  ts);
      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);

/*
      final e2 = new UNtagPixelData(
          PTag.kVariablePixelData, frame,  ts);
//      expect(un0.hashCode == un2.hashCode, false);
//      expect(un0 == un2, false);
      expect(e2, isNull);
*/

    });

    test('Create Unencapsulated UNtagPixelData.fromBytes', () {
/*
      final e0 = UNtagPixelData.fromBytes(frame, PTag.kNoName0, frame.length);
      expect(e0, isNull);

      final e1 =
          new UNtagPixelData(PTag.kSelectorUNValue, pixels1);
      expect(e1, isNull);

      final e2 =
          UNtagPixelData.fromBytes(frame, PTag.kPixelDataUN, frame.length);

      expect(e2.tag == PTag.kPixelDataUN, true);
      expect(e2.vrIndex == kUNIndex, true);
//      expect(un3.fragments == null, true);
//      expect(un3.offsets == null, true);
//      expect(un3.isEncapsulated == false, true);
      expect(e2.vfBytes is Bytes, true);
      log
        ..debug('e2.vfBytes.length: ${e2.vfBytes.length}')
        ..debug('e2.values.length: ${e2.values.length}')
        ..debug('e2.vfLength: ${e2.vfLength}')
        ..debug('e2.vfLengthField: ${e2.vfLengthField}');
      expect(e2.values is Uint8List, true);
      log
        ..debug('e2.length: ${e2.length}')
        ..debug('frame.length: ${frame.length}');
      expect(e2.valuesCopy, equals(e2.values));
      expect(e2.typedData is Uint8List, true);

      final s = Sha256.uint8(frame);
      expect(e2.sha256, equals(e2.update(s)));

      for (var s in frame) {
        expect(e2.checkValue(s), true);
      }

      expect(e2.checkValue(UN.kMaxValue), true);
      expect(e2.checkValue(UN.kMinValue), true);
      expect(e2.checkValue(UN.kMaxValue + 1), false);
      expect(e2.checkValue(UN.kMinValue - 1), false);
*/

    });

    test('Create Unencapsulated UNtagPixelData.fromBytes hashCode and ==', () {
/*
      final e0 = UNtagPixelData.fromBytes(frame, PTag.kNoName0, frame.length);
      expect(e0, isNull);

      final e1 = UNtagPixelData.fromBytes(frame, PTag.kVariablePixelData);
      expect(e1, isNull);

*/
      final e2 =
          UNtagPixelData.fromBytes(frame);
      final e3 =
          UNtagPixelData.fromBytes(frame);
//      final e4 = UNtagPixelData.fromBytes(frame, PTag.kNoName0, frame.length);

      expect(e2.hashCode == e3.hashCode, true);
      expect(e2 == e3, true);

/*
      expect(e2.hashCode == e4.hashCode, false);
      expect(e2 == e4, false);
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
      expect(un0.values is Uint8List, true);
      //expect(un0.values.length == un0.vfLength, true);
      log
        ..debug('un0.length: ${un0.length}')
        ..debug('frame.length: ${frame.length}');
      expect(un0.valuesCopy, equals(un0.values));
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
      expect(un0.values is Uint8List, true);
      expect(un0.valuesCopy, equals(un0.values));
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

    test('UNtagPixelData fromValues', () {
/*
      final e0 = UNtagPixelData.fromValues(PTag.kNoName0, pixels);
      expect(e0, isNull);
      expect(
          e0, equals(new UNtagPixelData(PTag.kNoName0, pixels)));

      final e1 = UNtagPixelData.fromValues(PTag.kVariablePixelData, pixels);
      expect(e1, isNull);
*/

      final e2 = UNtagPixelData.fromValues(pixels);

      expect(e2.tag == PTag.kNoName0, false);
      expect(e2.tag == PTag.kPixelDataUN, true);
      expect(e2.vrIndex == kUNIndex, true);
      expect(e2.values is List<int>, true);
//      expect(un3.fragments == null, true);
//      expect(un3.offsets == null, true);
//      expect(un3.isEncapsulated == false, true);
      log.debug(e2.values);
      expect(e2.hasValidValues, true);
      log.debug('bytes: ${e2.vfBytes}');
      expect(e2.vfBytes is Bytes, true);
      expect(e2.vfBytes.length == 1024, true);
      expect(e2.values is Uint8List, true);
      expect(e2.values.length == 1024, true);
      expect(e2.length == 1024, true);
      expect(e2.valuesCopy, equals(e2.values));
      expect(e2.typedData is Uint8List, true);

      final s = Sha256.uint8(pixels);
      expect(e2.sha256, equals(e2.update(s)));

      for (var s in frame) {
        expect(e2.checkValue(s), true);
      }
      expect(e2.checkValue(UN.kMaxValue), true);
      expect(e2.checkValue(UN.kMinValue), true);
      expect(e2.checkValue(UN.kMaxValue + 1), false);
      expect(e2.checkValue(UN.kMinValue - 1), false);
    });

    test('UNtagPixelData fromValues hashCode and ==', () {
/*
      final e0 = UNtagPixelData.fromValues(PTag.kNoName0, pixels);
      expect(e0, isNull);

      final e1 = UNtagPixelData.fromValues(PTag.kNoName0, pixels);
      expect(e1, isNull);
      final e2 = UNtagPixelData.fromValues(PTag.kVariablePixelData, pixels);
      expect(e2, isNull);
*/

      final e3 = UNtagPixelData.fromValues(pixels);
      final e4 = UNtagPixelData.fromValues(pixels);

      expect(e3.hashCode == e4.hashCode, true);
      expect(e3 == e4, true);

/*
      expect(e3.hashCode == e2.hashCode, false);
      expect(e3 == e2, false);
*/

    });

    test('new UNtagPixelData.fromBytes', () {
/*
      final e0 = UNtagPixelData.fromBytes(frame, PTag.kNoName0, frame.length);
      expect(e0, isNull);
*/

      final e1 =
          UNtagPixelData.fromBytes(frame);

      expect(e1.tag == PTag.kPixelDataUN, true);
      expect(e1.vrIndex == kUNIndex, true);
//      expect(un1.fragments == null, true);
//      expect(un1.offsets == null, true);
//      expect(un1.isEncapsulated == false, true);
      expect(e1.vfBytes is Bytes, true);
      log
        ..debug('un1.vfBytes.length: ${e1.vfBytes.length}')
        ..debug('un1.values.length: ${e1.values.length}')
        ..debug('un1.vfLength: ${e1.vfLength}');
      expect(e1.values is Uint8List, true);
      log
        ..debug('un1.length: ${e1.length}')
        ..debug('frame.length: ${frame.length}');
      expect(e1.valuesCopy, equals(e1.values));

      final s = Sha256.uint8(frame);
      expect(e1.sha256, equals(e1.update(s)));

      for (var s in frame) {
        expect(e1.checkValue(s), true);
      }
      expect(e1.checkValue(UN.kMaxValue), true);
      expect(e1.checkValue(UN.kMinValue), true);
      expect(e1.checkValue(UN.kMaxValue + 1), false);
      expect(e1.checkValue(UN.kMinValue - 1), false);
    });

    test('new UNtagPixelData.fromBytes hashCode and ==', () {
//      final e0 = UNtagPixelData.fromBytes(frame, PTag.kNoName0, frame.length);

      final e1 =
          UNtagPixelData.fromBytes(frame);
      final e2 =
          UNtagPixelData.fromBytes(frame);

      expect(e1.hashCode == e2.hashCode, true);
      expect(e1 == e2, true);

/*
      expect(e1.hashCode == e0.hashCode, false);
      expect(e1 == e0, false);
*/

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
      expect(un0.values is Uint8List, true);
      expect(un0.values == frags.bulkdata, true);
      expect(un0.values.length == frags.bulkdata.length, true);
      expect(un0.length == frags.bulkdata.length, true);
      expect(un0.valuesCopy, equals(un0.values));
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
    test('UNPixelData fromValues', () {
      final e0 = new UNtagPixelData(pixels);

      final e1 = UNtagPixelData.fromValues(e0.values);

      expect(e1.tag == PTag.kPixelDataUN, true);
      expect(e1.vrIndex == kUNIndex, true);
      expect(e1.values is List<int>, true);
//      expect(unfrom0.fragments == null, true);
//      expect(unfrom0.offsets == null, true);
//      expect(unfrom0.isEncapsulated == false, true);
      log.debug(e1.values);
      expect(e1.hasValidValues, true);
      log.debug('bytes: ${e1.vfBytes}');
      expect(e1.vfBytes is Bytes, true);
      expect(e1.vfBytes.length == 1024, true);
      expect(e1.values is Uint8List, true);
      expect(e1.values.length == 1024, true);
      expect(e1.length == 1024, true);
      expect(e1.valuesCopy, equals(e1.values));
      expect(e1.typedData is Uint8List, true);

      final s = Sha256.uint8(pixels);
      expect(e1.sha256, equals(e1.update(s)));

      for (var s in frame) {
        expect(e1.checkValue(s), true);
      }
      expect(e1.checkValue(UN.kMaxValue), true);
      expect(e1.checkValue(UN.kMinValue), true);
      expect(e1.checkValue(UN.kMaxValue + 1), false);
      expect(e1.checkValue(UN.kMinValue - 1), false);
    });

    test('UNPixelData fromBytes', () {
      global.throwOnError = false;
/*
      final bytes0 = new Bytes.fromList(testFrame);
      final e0 = UNtagPixelData.fromBytes(bytes0, PTag.kNoName0);
      expect(e0, isNull);

      final e1 = UNtagPixelData.fromBytes(bytes0, PTag.kPixelDataUN);

      expect(e1.tag == PTag.kPixelDataUN, true);
      expect(e1.vrIndex == kOBOWIndex, false);
      expect(e1.vrIndex == kUNIndex, true);
      expect(e1.values is List<int>, true);
//      expect(e1.fragments == null, true);
//      expect(e1.offsets == null, true);
//      expect(e1.isEncapsulated == false, true);
      log.debug(e1.values);
      expect(e1.hasValidValues, true);
      log.debug('bytes: ${e1.vfBytes}');
      expect(e1.vfBytes is Bytes, true);
      expect(e1.vfBytes.length == 139782, true);
      expect(e1.values is Uint8List, true);
      expect(e1.values.length == 139782, true);
      expect(e1.length == 139782, true);
      expect(e1.valuesCopy, equals(e1.values));
      expect(e1.typedData is Uint8List, true);

      expect(e1.checkValue(kUint8Max), true);
      expect(e1.checkValue(kUint8Min), true);
      expect(e1.checkValue(kUint8Max + 1), false);
      expect(e1.checkValue(kUint8Min - 1), false);
*/
      global.throwOnError = true;
/*
      expect(() => UNtagPixelData.fromBytes(bytes0, PTag.kSelectorAEValue),
          throwsA(const TypeMatcher<InvalidTagError>()));
*/
      
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
      expect(UN.isValidVFLength(UN.kMaxVFLength), true);
      expect(UN.isValidVFLength(UN.kMaxVFLength + 1), false);

      expect(UN.isValidVFLength(0), true);
      expect(UN.isValidVFLength(-1), false);
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
          throwsA(const TypeMatcher<InvalidValuesError>()));
      expect(() => UN.isValidValues(PTag.kPixelData, uInt8MinMinus),
          throwsA(const TypeMatcher<InvalidValuesError>()));
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
