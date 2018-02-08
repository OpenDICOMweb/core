// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

import 'test_pixel_data.dart';

final Uint32List emptyOffsets = new Uint32List(0);
final Uint8List emptyOffsetsAsBytes = emptyOffsets.buffer.asUint8List();
final Uint8List frame = new Uint8List.fromList(testFrame);
final List<Uint8List> fragments = [emptyOffsetsAsBytes, testFrame];

void main() {
  Server.initialize(name: 'element/un_pixel_data_test', level: Level.info);

  final ts = TransferSyntax.kDefaultForDicomWeb;
  group('UNtagPixelData Tests', () {
    final pixels = new List<int>(1024);
    for (var i = 0; i < pixels.length; i++) pixels[i] = 128;

    final pixels1 = [1024, 1024];
    for (var i = 0; i < pixels1.length; i++) pixels1[i] = 128;

    test('Create Unencapsulated UNtagPixelData', () {
      final un0 = new UNtagPixelData(PTag.kNoName0, pixels, pixels.length);

      final un1 =
          new UNtagPixelData(PTag.kSelectorUNValue, pixels1, pixels1.length);

      expect(un0.tag == PTag.kNoName0, true);
      expect(un0.vrIndex == kUNIndex, true);
      expect(un1.vrIndex == kUNIndex, true);
      expect(un0.values is List<int>, true);
      expect(un0.fragments == null, true);
      expect(un0.offsets == null, true);
      expect(un0.isEncapsulated == false, true);
      log.debug(un0.values);
      expect(un0.hasValidValues, true);
      log.debug('bytes: ${un0.vfBytes}');
      expect(un0.vfBytes is Uint8List, true);
      expect(un0.vfBytes.length == 1024, true);
      expect(un0.pixels is Uint8List, true);
      expect(un0.pixels.length == 1024, true);
      expect(un0.length == 1024, true);
      expect(un0.valuesCopy, equals(un0.pixels));
      expect(un1.typedData is Uint8List, true);

      final s = Sha256.uint8(pixels);
      expect(un0.sha256, equals(un0.update(s)));

      for (var s in frame) {
        expect(un0.checkValue(s), true);
      }
      expect(un0.checkValue(UN.kMaxValue), true);
      expect(un0.checkValue(UN.kMinValue), true);
      expect(un0.checkValue(UN.kMaxValue + 1), false);
      expect(un0.checkValue(UN.kMinValue - 1), false);
    });

    test('Create UnEncapsulate UNtagPixelData hashCode and ==', () {
      final un0 = new UNtagPixelData(PTag.kNoName0, pixels, pixels.length);
      final un1 = new UNtagPixelData(PTag.kNoName0, pixels, pixels.length);
      final un2 = new UNtagPixelData(PTag.kNoName1, pixels1, pixels1.length);

      expect(un0.hashCode == un1.hashCode, true);
      expect(un0 == un1, true);
      expect(un0.hashCode == un2.hashCode, false);
      expect(un0 == un2, false);
    });

    test('Create Encapsulated UNtagPixelData', () {
      final frags = new VFFragments(fragments);
      final un0 =
          new UNtagPixelData(PTag.kNoName0, frame, kUndefinedLength, ts, frags);

      final un1 = new UNtagPixelData(
          PTag.kSelectorUNValue, frame, kUndefinedLength, ts, frags);

      expect(un0.tag == PTag.kNoName0, true);
      expect(un0.vrIndex == kUNIndex, true);
      expect(un1.vrIndex == kUNIndex, true);
      expect(un0.fragments == frags, true);
      expect(un0.offsets == frags.offsets, true);
      expect(un0.isEncapsulated == true, true);
      expect(un0.vfBytes is Uint8List, true);
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
    });

    test('Create Encapsulated UNtagPixelData hashCode and ==', () {
      final frags = new VFFragments(fragments);
      final un0 = new UNtagPixelData(
          PTag.kPixelData, frame, kUndefinedLength, ts, frags);
      final un1 = new UNtagPixelData(
          PTag.kPixelData, frame, kUndefinedLength, ts, frags);
      final un2 = new UNtagPixelData(
          PTag.kVariablePixelData, frame, kUndefinedLength, ts, frags);

      expect(un0.hashCode == un1.hashCode, true);
      expect(un0 == un1, true);

      expect(un0.hashCode == un2.hashCode, false);
      expect(un0 == un2, false);
    });

    test('Create Unencapsulated UNtagPixelData.fromBytes', () {
      final un0 = new UNtagPixelData.fromBytes(
          PTag.kNoName0, frame, frame.lengthInBytes);

      final un1 =
          new UNtagPixelData(PTag.kSelectorUNValue, pixels1, pixels1.length);

      expect(un0.tag == PTag.kNoName0, true);
      expect(un0.vrIndex == kUNIndex, true);
      expect(un1.vrIndex == kUNIndex, true);
      expect(un0.fragments == null, true);
      expect(un0.offsets == null, true);
      expect(un0.isEncapsulated == false, true);
      expect(un0.vfBytes is Uint8List, true);
      log
        ..debug('un0.vfBytes.length: ${un0.vfBytes.length}')
        ..debug('un0.values.length: ${un0.values.length}')
        ..debug('un0.vfLength: ${un0.vfLength}')
        ..debug('un0.vfLengthField: ${un0.vfLengthField}');
      expect(un0.pixels is Uint8List, true);
      log
        ..debug('un0.length: ${un0.length}')
        ..debug('frame.lengthInBytes: ${frame.lengthInBytes}');
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

    test('Create Unencapsulated UNtagPixelData.fromBytes hashCode and ==', () {
      final un0 = new UNtagPixelData.fromBytes(
          PTag.kNoName0, frame, frame.lengthInBytes);
      final un1 = new UNtagPixelData.fromBytes(
          PTag.kNoName0, frame, frame.lengthInBytes);
      final un2 = new UNtagPixelData.fromBytes(
          PTag.kVariablePixelData, frame, frame.lengthInBytes);

      expect(un0.hashCode == un1.hashCode, true);
      expect(un0 == un1, true);

      expect(un0.hashCode == un2.hashCode, false);
      expect(un0 == un2, false);
    });

    test('Create Unencapsulated UNtagPixelData.fromBase64', () {
      final base64 = BASE64.encode(frame);
      final un0 =
          new UNtagPixelData.fromBase64(PTag.kNoName0, base64, base64.length);

      final un1 =
          new UNtagPixelData.fromBase64(PTag.kNoName1, base64, base64.length);

      expect(un0.tag == PTag.kNoName0, true);
      expect(un0.vrIndex == kUNIndex, true);
      expect(un1.vrIndex == kUNIndex, true);
      expect(un0.fragments == null, true);
      expect(un0.offsets == null, true);
      expect(un0.isEncapsulated == false, true);
      expect(un0.vfBytes is Uint8List, true);
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
        ..debug('frame.lengthInBytes: ${frame.lengthInBytes}');
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

    test('Create Unencapsulated UNtagPixelData.fromBase64 hashCode and ==', () {
      final base64 = BASE64.encode(frame);
      final un0 =
          new UNtagPixelData.fromBase64(PTag.kNoName0, base64, base64.length);
      final un1 =
          new UNtagPixelData.fromBase64(PTag.kNoName0, base64, base64.length);
      final un2 = new UNtagPixelData.fromBase64(
          PTag.kVariablePixelData, base64, base64.length);

      expect(un0.hashCode == un1.hashCode, true);
      expect(un0.hashCode == un2.hashCode, false);
      expect(un0 == un1, true);
      expect(un0 == un2, false);
    });

    test('Create encapsulated UNtagPixelData.fromBase64', () {
      final base64 = BASE64.encode(frame);
      final frags = new VFFragments(fragments);

      final un0 = new UNtagPixelData.fromBase64(
          PTag.kNoName0, base64, frame.lengthInBytes, ts, frags);

      /*final un1 = new UNtagPixelData.fromBase64(
          PTag.kDate, base64, frame.lengthInBytes, ts, frags);*/

      expect(un0.tag == PTag.kNoName0, true);
      expect(un0.vrIndex == kUNIndex, true);
      // expect(un1.vrIndex == kUNIndex, false);
      expect(un0.fragments == frags, true);
      expect(un0.offsets == frags.offsets, true);
      expect(un0.isEncapsulated == true, true);
      expect(un0.vfBytes is Uint8List, true);
      expect(un0.vfBytes.length == frame.lengthInBytes, true);
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

    test('Create encapsulated UNtagPixelData.fromBase64 hashCode and ==', () {
      final base64 = BASE64.encode(frame);
      final frags = new VFFragments(fragments);

      final un0 = new UNtagPixelData.fromBase64(
          PTag.kNoName0, base64, frame.lengthInBytes, ts, frags);
      final un1 = new UNtagPixelData.fromBase64(
          PTag.kNoName0, base64, frame.lengthInBytes, ts, frags);
      final un2 = new UNtagPixelData.fromBase64(
          PTag.kVariablePixelData, base64, frame.lengthInBytes, ts, frags);

      expect(un0.hashCode == un1.hashCode, true);
      expect(un0.hashCode == un2.hashCode, false);
      expect(un0 == un1, true);
      expect(un0 == un2, false);
    });

    test('UNtagPixelData.make', () {
      final un0 = UNtagPixelData.make(PTag.kNoName0, pixels);
      expect(un0, isNotNull);
      expect(un0,
          equals(new UNtagPixelData(PTag.kNoName0, pixels, pixels.length)));

      final un1 = UNtagPixelData.make(PTag.kVariablePixelData, pixels);
      expect(
          un1,
          equals(new UNtagPixelData(
              PTag.kVariablePixelData, pixels, pixels.length)));

      //final un2 = UNtagPixelData.make(PTag.kSelectorSTValue, pixels);

      expect(un0.tag == PTag.kNoName0, true);
      expect(un0.vrIndex == kUNIndex, true);
      //expect(un2.vrIndex == kUNIndex, false);
      expect(un0.values is List<int>, true);
      expect(un0.fragments == null, true);
      expect(un0.offsets == null, true);
      expect(un0.isEncapsulated == false, true);
      log.debug(un0.values);
      expect(un0.hasValidValues, true);
      log.debug('bytes: ${un0.vfBytes}');
      expect(un0.vfBytes is Uint8List, true);
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
    });

    test('UNtagPixelData.make hashCode and ==', () {
      final un0 = UNtagPixelData.make(PTag.kNoName0, pixels);
      final un1 = UNtagPixelData.make(PTag.kNoName0, pixels);
      final un2 = UNtagPixelData.make(PTag.kVariablePixelData, pixels);

      expect(un0.hashCode == un1.hashCode, true);
      expect(un0 == un1, true);

      expect(un0.hashCode == un2.hashCode, false);
      expect(un0 == un2, false);
    });

    test('new UNtagPixelData.fromBytes', () {
      final frags = new VFFragments(fragments);
      final un0 = new UNtagPixelData.fromBytes(
          PTag.kNoName0, frame, frame.lengthInBytes);
      expect(
          un0,
          equals(new UNtagPixelData.fromBytes(
              PTag.kNoName0, frame, frame.lengthInBytes, ts, frags)));

      expect(un0.tag == PTag.kNoName0, true);
      expect(un0.vrIndex == kUNIndex, true);
      //expect(un1.vrIndex == kUNIndex, false);
      expect(un0.fragments == null, true);
      expect(un0.offsets == null, true);
      expect(un0.isEncapsulated == false, true);
      expect(un0.vfBytes is Uint8List, true);
      log
        ..debug('un0.vfBytes.length: ${un0.vfBytes.length}')
        ..debug('un0.values.length: ${un0.values.length}')
        ..debug('un0.vfLength: ${un0.vfLength}')
        ..debug('un0.vfLengthField: ${un0.vfLengthField}');
      expect(un0.pixels is Uint8List, true);
      log
        ..debug('un0.length: ${un0.length}')
        ..debug('frame.lengthInBytes: ${frame.lengthInBytes}');
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
      final un0 = new UNtagPixelData.fromBytes(
          PTag.kNoName0, frame, frame.lengthInBytes);

      final un1 = new UNtagPixelData.fromBytes(
          PTag.kNoName0, frame, frame.lengthInBytes);

      final un2 = new UNtagPixelData.fromBytes(
          PTag.kVariablePixelData, frame, frame.lengthInBytes);

      expect(un0.hashCode == un1.hashCode, true);
      expect(un0 == un1, true);

      expect(un0.hashCode == un2.hashCode, false);
      expect(un0 == un2, false);
    });

    test('UNtagPixelData.fromB64', () {
      final base64 = BASE64.encode(frame);
      final frags = new VFFragments(fragments);
      final un0 = UNtagPixelData.fromB64(
          PTag.kNoName0, base64, base64.length, ts, frags);
      expect(
          un0,
          equals(UNtagPixelData.fromB64(
              PTag.kNoName0, base64, base64.length, ts, frags)));

      final un1 = UNtagPixelData.fromB64(
          PTag.kSelectorUNValue, base64, base64.length, ts, frags);

      expect(un0.tag == PTag.kNoName0, true);
      expect(un0.vrIndex == kUNIndex, true);
      expect(un1.vrIndex == kUNIndex, true);
      expect(un0.fragments == frags, true);
      expect(un0.offsets == frags.offsets, true);
      expect(un0.isEncapsulated == true, true);
      expect(un0.vfBytes is Uint8List, true);
      expect(un0.vfBytes.length == frame.lengthInBytes, true);
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

    test('UNtagPixelData.fromB64 hashCode and ==', () {
      final base64 = BASE64.encode(frame);
      final frags = new VFFragments(fragments);
      final un0 = UNtagPixelData.fromB64(
          PTag.kNoName0, base64, base64.length, ts, frags);
      final un1 = UNtagPixelData.fromB64(
          PTag.kNoName0, base64, base64.length, ts, frags);

      final un2 = UNtagPixelData.fromB64(
          PTag.kVariablePixelData, base64, base64.length, ts, frags);

      //hash_code : good and bad
      expect(un0.hashCode == un1.hashCode, true);
      expect(un0 == un1, true);

      expect(un0.hashCode == un2.hashCode, false);
      expect(un0 == un2, false);
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
      system.throwOnError = false;
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
        system.throwOnError = false;
        expect(UN.isValidTag(tag), true);
      }
    });

    test('Create UN.checkVR', () {
      system.throwOnError = false;
      expect(UN.checkVRIndex(kUNIndex), kUNIndex);
      expect(UN.checkVRIndex(kAEIndex), kAEIndex);
      expect(UN.isValidVRIndex(kUNIndex), true);
      expect(UN.isValidVRIndex(kAEIndex), true);

      for (var tag in unTags) {
        expect(UN.checkVRIndex(tag.vrIndex), tag.vrIndex);
        expect(UN.isValidVRIndex(tag.vrIndex), true);
      }

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(UN.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('Create UN.isValidVRIndex', () {
      system.throwOnError = false;
      expect(UN.isValidVRIndex(kUNIndex), true);
      expect(UN.isValidVRIndex(kCSIndex), true);

      for (var tag in unTags) {
        expect(UN.isValidVRIndex(tag.vrIndex), true);
      }

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(UN.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('Create UN.isValidVRCode', () {
      system.throwOnError = false;
      expect(UN.isValidVRCode(kUNCode), true);
      expect(UN.isValidVRCode(kAECode), true);

      for (var tag in unTags) {
        expect(UN.isValidVRCode(tag.vrCode), true);
      }

      for (var tag in otherTags) {
        system.throwOnError = false;
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
      system.throwOnError = false;
      const uInt8Min = const [UN.kMinValue];
      const uInt8Max = const [UN.kMaxValue];
      const uInt8MaxPlus = const [UN.kMaxValue + 1];
      const uInt8MinMinus = const [UN.kMinValue - 1];


      expect(UN.isValidValues(PTag.kPixelData, uInt8Min), true);
      expect(UN.isValidValues(PTag.kPixelData, uInt8Max), true);

      expect(UN.isValidValues(PTag.kPixelData, uInt8MaxPlus), false);
      expect(UN.isValidValues(PTag.kPixelData, uInt8MinMinus), false);

      system.throwOnError = true;
      expect(() => UN.isValidValues(PTag.kPixelData, uInt8MaxPlus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
      expect(() => UN.isValidValues(PTag.kPixelData, uInt8MinMinus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('Create Uint8Base.listFromBytes', () {
      expect(Uint8Base.listFromBytes(frame), equals(frame));
    });

    test('Create Uint8Base.listFromBytes', () {
      system.throwOnError = false;
      const uInt8Max = const [UN.kMaxValue];
      const uInt16Max = const [kUint16Max];
      final uInt8ListV1 = new Uint8List.fromList(uInt8Max);
      final uInt8ListV11 = uInt8ListV1.buffer.asUint8List();
      expect(Uint8Base.listFromBytes(uInt8ListV11), equals(uInt8Max));

      expect(Uint8Base.listFromBytes(frame), equals(frame));

      final uInt16ListV1 = new Uint16List.fromList(uInt16Max);
      final uInt8ListV12 = uInt16ListV1.buffer.asUint8List();
      expect(Uint8Base.listFromBytes(uInt8ListV12), uInt8ListV12);
    });

    test('Create Uint32Base.listFromBase64', () {
      final s = Uint8Base.listToBase64(testFrame);
      expect(Uint8Base.listFromBase64(s), equals(testFrame));
    });

    test('Create Uint32Base.listFromBytes', () {
      final bytes = Uint8Base.listToBytes(testFrame);
      log.debug('s: "$bytes"');
      expect(Uint8Base.listFromBytes(bytes), bytes);
    });

    test('Create Uint32Base.listFromByteData', () {
      final bd = Uint8Base.listToByteData(testFrame);
      expect(Uint8Base.listFromByteData(bd), equals(frame));
    });
  });
}
