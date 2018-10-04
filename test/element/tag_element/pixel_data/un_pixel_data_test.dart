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

final Uint32List emptyOffsets = Uint32List(0);
final Uint8List emptyOffsetsAsBytes = emptyOffsets.buffer.asUint8List();
final Bytes frame = Bytes.fromList(testFrame);
final List<Uint8List> fragments = [emptyOffsetsAsBytes, testFrame];

void main() {
  Server.initialize(name: 'element/un_pixel_data_test', level: Level.info);

  const ts = TransferSyntax.kDefaultForDicomWeb;
  group('UNtagPixelData Tests', () {
    final pixels = List<int>(1024);
    for (var i = 0; i < pixels.length; i++) pixels[i] = 128;

    final pixels1 = [1024, 1024];
    for (var i = 0; i < pixels1.length; i++) pixels1[i] = 128;

    test('Create Unencapsulated UNtagPixelData', () {
      final e0 = UNtagPixelData(pixels);

      expect(e0.vrIndex == kUNIndex, true);
      expect(e0.values is List<int>, true);
      log.debug(e0.values);
      expect(e0.hasValidValues, true);
      log.debug('bytes: ${e0.vfBytes}');
      expect(e0.vfBytes is Bytes, true);
      expect(e0.vfBytes.length == 1024, true);
      expect(e0.values is Uint8List, true);
      expect(e0.values.length == 1024, true);
      expect(e0.length == 1024, true);
      expect(e0.valuesCopy, equals(e0.values));
      expect(e0.tag == PTag.kPixelDataUN, true);
      log.debug(e0.values);
      expect(e0.hasValidValues, true);
      log.debug('bytes: ${e0.vfBytes}');

      for (var s in frame) {
        expect(e0.checkValue(s), true);
      }
      expect(e0.checkValue(UN.kMaxValue), true);
      expect(e0.checkValue(UN.kMinValue), true);
      expect(e0.checkValue(UN.kMaxValue + 1), false);
      expect(e0.checkValue(UN.kMinValue - 1), false);

      final e1 = UNtagPixelData(pixels);
      expect(e1, isNotNull);

      expect(e0.typedData is Uint8List, true);
      expect(e0.vrIndex == kUNIndex, true);
      expect(e0.typedData is Uint8List, true);

      final s = Sha256.uint8(pixels);
      expect(e0.sha256, equals(e0.update(s)));
    });

    test('Create UnEncapsulate UNtagPixelData hashCode and ==', () {
      global.throwOnError = false;

      final e0 = UNtagPixelData(pixels);
      final e1 = UNtagPixelData(pixels);
      final e2 = UNtagPixelData(pixels1);

      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);

      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);
    });

    test('Create Encapsulated UNtagPixelData', () {
      final e0 = UNtagPixelData(frame, ts);

      expect(e0.tag == PTag.kPixelDataUN, true);
      expect(e0.vrIndex == kUNIndex, true);
      expect(e0.vfBytes is Bytes, true);
      expect(e0.vfBytes.length == frame.length, true);
      expect(e0.values is List<int>, true);
      expect(e0.valuesCopy, equals(e0.values));
      expect(e0.typedData is Uint8List, true);

      final s = Sha256.uint8(frame);
      expect(e0.sha256, equals(e0.update(s)));

      for (var s in frame) {
        expect(e0.checkValue(s), true);
      }

      expect(e0.checkValue(UN.kMaxValue), true);
      expect(e0.checkValue(UN.kMinValue), true);
      expect(e0.checkValue(UN.kMaxValue + 1), false);
      expect(e0.checkValue(UN.kMinValue - 1), false);

      final e1 = UNtagPixelData([kUint16Max]);
      expect(e1, isNull);

      global.throwOnError = true;
      expect(() => UNtagPixelData([kUint16Max]),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('Create Encapsulated UNtagPixelData hashCode and ==', () {
      global.throwOnError = false;

      final e0 = UNtagPixelData(frame, ts);
      final e1 = UNtagPixelData(frame, ts);
      final e2 = UNtagPixelData(pixels, ts);

      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);

      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);
    });

    test('Create Unencapsulated UNtagPixelData.fromBytes', () {
      global.throwOnError = false;
      final e0 = UNtagPixelData.fromBytes(frame);

      expect(e0.tag == PTag.kPixelDataUN, true);
      expect(e0.vrIndex == kOBOWIndex, false);
      expect(e0.vrIndex == kUNIndex, true);
      final bytes = e0.vfBytes;
      expect(e0.vfBytes is Bytes, true);
      log
        ..debug('ob0.vfBytes.length: ${e0.vfBytes.length}')
        ..debug('ob0.values.length: ${e0.values.length}')
        ..debug('ob0.vfLength: ${e0.vfLength}');
      expect(e0.vfLength == bytes.length, true);
      expect(e0.values is Uint8List, true);
      expect(e0.values.length == e0.vfLength, true);
      log
        ..debug('ob0.length: ${e0.length}')
        ..debug('frame.length: ${frame.length}');
      expect(e0.lengthInBytes == frame.length, true);
      expect(e0.valuesCopy, equals(e0.values));
      expect(e0.typedData is Uint8List, true);

      global.throwOnError = false;
      final ob1 = UNtagPixelData.fromBytes(frame);
      expect(ob1.tag == PTag.kPixelDataUN, true);

      final s = Sha256.uint8(frame);
      expect(e0.sha256, equals(e0.update(s)));

      for (var s in frame) {
        expect(e0.checkValue(s), true);
      }

      expect(e0.checkValue(kUint8Max), true);
      expect(e0.checkValue(kUint8Min), true);
      expect(e0.checkValue(kUint8Max + 1), false);
      expect(e0.checkValue(kUint8Min - 1), false);
    });

    test('Create Unencapsulated UNtagPixelData.fromBytes hashCode and ==', () {
      global.throwOnError = false;
      final frame1 = Bytes.fromList(pixels);
      final e0 = UNtagPixelData.fromBytes(frame);
      final e1 = UNtagPixelData.fromBytes(frame);
      final e2 = UNtagPixelData.fromBytes(frame1);

      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);

      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);
    });

    test('Create Encapsulated UNtagPixelData.fromBytes', () {
//      final frags = VFFragments(fragments);
      final e0 = UNtagPixelData.fromBytes(frame, ts);
      expect(e0.tag == PTag.kPixelDataUN, true);
      expect(e0.vrIndex == kOBOWIndex, false);
      expect(e0.vrIndex == kUNIndex, true);
      expect(e0.vfBytes is Bytes, true);
      expect(e0.vfBytes.length == frame.length, true);
      expect(e0.values is Uint8List, true);
      expect(e0.values.length == 139782, true);
      expect(e0.valuesCopy, equals(e0.values));
      expect(e0.typedData is Uint8List, true);

      for (var s in frame) {
        expect(e0.checkValue(s), true);
      }

      expect(e0.checkValue(kUint8Max), true);
      expect(e0.checkValue(kUint8Min), true);
      expect(e0.checkValue(kUint8Max + 1), false);
      expect(e0.checkValue(kUint8Min - 1), false);
    });

    test('Create Encapsulated UNtagPixelData.fromBytes hashCode and ==', () {
      global.throwOnError = false;
      final e0 = UNtagPixelData.fromBytes(frame, ts);
      final e1 = UNtagPixelData.fromBytes(frame, ts);

      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);

      final e2 = UNtagPixelData.fromBytes(frame, ts);
      expect(e2, equals(e1));
      expect(e2.hashCode == e0.hashCode, true);
      expect(e2 == e0, true);

      final e3 = UNtagPixelData.fromBytes(frame, ts);
      expect(e3 == e2, true);
      expect(e3.hashCode == e0.hashCode, true);

      final frame1 = Bytes.fromList(pixels);
      final e4 = UNtagPixelData.fromBytes(frame1, ts);
      expect(e0 == e4, false);
      expect(e0.hashCode == e4.hashCode, false);
    });

    test('UNtagPixelData.update Test', () {
      global.throwOnError = false;

      final e0 = UNtagPixelData(pixels);
      final e1 = e0.update(pixels);
      expect(e0 == e1, true);

      final e2 = UNtagPixelData(frame, ts);
      final e3 = e2.update(frame);
      expect(e2 == e3, true);
    });

    test('getPixelData', () {
      final pd0 = UNtagPixelData([123, 101]);
      final ba0 = UStag(PTag.kBitsAllocated, [8]);
      final ds = TagRootDataset.empty()..add(pd0)..add(ba0);

      //  ds = RootDatasetTag();
      final pixels = ds.getPixelData();
      log.debug('pixel.length: ${pixels.length}');
      expect(pixels.length == 2, true);

      global.throwOnError = false;
      final ba1 = UStag(PTag.kBitsAllocated, []);
      final ds1 = TagRootDataset.empty()..add(ba1);
      final pixels1 = ds1.getPixelData();
      expect(pixels1 == null, true);

      global.throwOnError = true;
      expect(
          ds1.getPixelData, throwsA(const TypeMatcher<InvalidValuesError>()));

      final ba3 = UStag(PTag.kBitsAllocated, [8]);
      final ds2 = TagRootDataset.empty()..add(ba3);
      expect(
          ds2.getPixelData, throwsA(const TypeMatcher<PixelDataNotPresent>()));
    });

    test('UNtagPixelData fromValues', () {
      final e0 = UNtagPixelData.fromValues(pixels);

      expect(e0.tag == PTag.kNoName0, false);
      expect(e0.tag == PTag.kPixelDataUN, true);
      expect(e0.vrIndex == kUNIndex, true);
      expect(e0.values is List<int>, true);
      log.debug(e0.values);
      expect(e0.hasValidValues, true);
      log.debug('bytes: ${e0.vfBytes}');
      expect(e0.vfBytes is Bytes, true);
      expect(e0.vfBytes.length == 1024, true);
      expect(e0.values is Uint8List, true);
      expect(e0.values.length == 1024, true);
      expect(e0.length == 1024, true);
      expect(e0.valuesCopy, equals(e0.values));
      expect(e0.typedData is Uint8List, true);

      global.throwOnError = false;
      final ob2 = UNtagPixelData.fromValues([kUint16Max]);
      expect(ob2, isNull);

      global.throwOnError = true;
      expect(() => UNtagPixelData.fromValues([kUint16Max]),
          throwsA(const TypeMatcher<InvalidValuesError>()));

      final s = Sha256.uint8(pixels);
      expect(e0.sha256, equals(e0.update(s)));

      for (var s in frame) {
        expect(e0.checkValue(s), true);
      }
      expect(e0.checkValue(UN.kMaxValue), true);
      expect(e0.checkValue(UN.kMinValue), true);
      expect(e0.checkValue(UN.kMaxValue + 1), false);
      expect(e0.checkValue(UN.kMinValue - 1), false);
    });

    test('UNtagPixelData fromValues hashCode and ==', () {
      final e0 = UNtagPixelData.fromValues(pixels);
      final e1 = UNtagPixelData.fromValues(pixels);
      final e2 = UNtagPixelData.fromValues(pixels1);

      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);

      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);
    });

    test('UNtagPixelData.fromBytes', () {
      final e0 = UNtagPixelData.fromBytes(frame);
      expect(e0, equals(UNtagPixelData.fromBytes(frame, ts)));
      expect(e0.tag == PTag.kPixelDataUN, true);
      expect(e0.vrIndex == kOBOWIndex, false);
      expect(e0.vrIndex == kUNIndex, true);
      expect(e0.vfBytes is Bytes, true);
      log
        ..debug('ob0.vfBytes.length: ${e0.vfBytes.length}')
        ..debug('ob0.values.length: ${e0.values.length}')
        ..debug('ob0.vfLength: ${e0.vfLength}');
      expect(e0.vfBytes.length == e0.vfLength, true);
      expect(e0.values is Uint8List, true);
      expect(e0.values.length == e0.vfLength, true);
      log
        ..debug('ob0.length: ${e0.length}')
        ..debug('frame.length: ${frame.length}');
      expect(e0.lengthInBytes == frame.length, true);
      expect(e0.valuesCopy, equals(e0.values));

      final s = Sha256.uint8(frame);
      expect(e0.sha256, equals(e0.update(s)));

      for (var s in frame) {
        expect(e0.checkValue(s), true);
      }
      expect(e0.checkValue(kUint8Max), true);
      expect(e0.checkValue(kUint8Min), true);
      expect(e0.checkValue(kUint8Max + 1), false);
      expect(e0.checkValue(kUint8Min - 1), false);
    });

    test('UNtagPixelData.fromBytes hashCode and ==', () {
      global.throwOnError = false;
      final frame1 = Bytes.fromList(pixels1);
      final e0 = UNtagPixelData.fromBytes(frame);
      final e1 = UNtagPixelData.fromBytes(frame);
      final e2 = UNtagPixelData.fromBytes(frame1);

      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);

      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);
    });

    test('UNPixelData fromValues', () {
      final e0 = UNtagPixelData(pixels);

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

    test('UNtagPixelData isValidArgs', () {
      final e0 = UNtagPixelData.isValidArgs(pixels, ts);
      expect(e0, true);

      final e1 = UNtagPixelData.isValidArgs(null, ts);
      expect(e1, false);
    });

    test('UNtagPixelData isValidBytesArgs', () {
      final vfBytes = Bytes.fromList(pixels);
      final e0 = UNtagPixelData.isValidBytesArgs(vfBytes);
      expect(e0, true);

      final e1 = UNtagPixelData.isValidBytesArgs(null);
      expect(e1, false);
    });

    test('Create Unencapsulated UNtagPixelData.fromPixels', () {
      final e0 = UNtagPixelData.fromPixels(pixels);
      log.debug('tag: ${PTag.kPixelDataUN}');
      expect(e0.vrIndex == kOBOWIndex, false);
      expect(e0.vrIndex == kUNIndex, true);
      expect(e0.values is List<int>, true);
      log.debug(e0.values);
      expect(e0.hasValidValues, true);
      log.debug('bytes: ${e0.vfBytes}');
      expect(e0.vfBytes is Bytes, true);
      expect(e0.vfBytes.length == 1024, true);
      expect(e0.values is Uint8List, true);
      expect(e0.values.length == 1024, true);
      expect(e0.length == 1024, true);
      expect(e0.valuesCopy, equals(e0.values));
      expect(e0.typedData is Uint8List, true);
      expect(e0.tag == PTag.kPixelDataUN, true);

      final s = Sha256.uint8(pixels);
      log.debug('s: $s');
      final e2 = e0.sha256;
      final e3 = e0.update(s);
      expect(e2, equals(e3));

      for (var s in frame) {
        expect(e0.checkValue(s), true);
      }

      expect(e0.checkValue(kUint8Max), true);
      expect(e0.checkValue(kUint8Min), true);
      expect(e0.checkValue(kUint8Max + 1), false);
      expect(e0.checkValue(kUint8Min - 1), false);
    });

    test('Create Unencapsulated UNtagPixelData.fromPixels hashCode and ==', () {
      global.throwOnError = false;

      final e0 = UNtagPixelData.fromPixels(pixels);
      final e1 = UNtagPixelData.fromPixels(pixels);
      final e2 = UNtagPixelData.fromPixels(pixels1);

      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);

      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);
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
      const uInt8Min = [UN.kMinValue];
      const uInt8Max = [UN.kMaxValue];
      const uInt8MaxPlus = [UN.kMaxValue + 1];
      const uInt8MinMinus = [UN.kMinValue - 1];

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

    test('Create Uint8.fromBytes', () {
      expect(Uint8.fromBytes(frame), equals(frame.asUint8List()));
    });

    test('Create Uint8.fromBytes', () {
      global.throwOnError = false;
      const uInt8Max = [UN.kMaxValue];
      const uInt16Max = [kUint16Max];
      final bytes0 = Bytes.fromList(uInt8Max);
      //   final uInt8ListV11 = uInt8ListV1.buffer.asUint8List();
      expect(Uint8.fromBytes(bytes0), equals(uInt8Max));

      expect(Uint8.fromBytes(frame), equals(frame.asUint8List()));

      final uInt16List1 = Uint16List.fromList(uInt16Max);
      //  final uInt8ListV12 = uInt16ListV1.buffer.asUint8List();
      final bytes1 = Bytes.typedDataView(uInt16List1);
      expect(Uint16.fromBytes(bytes1), uInt16List1);
    });

    test('Create Uint32.fromBase64', () {
      final s = Uint8.toBase64(testFrame);
      expect(Uint8.fromBase64(s), equals(testFrame));
    });

    test('Create Uint8.fromBytes', () {
      final bytes = Uint8.toBytes(testFrame);
      log.debug('s: "$bytes"');
      final uint8a = Uint8.fromBytes(bytes);
      final uint8b = bytes.asUint8List();
      expect(uint8a, uint8b);
    });

    test('Create Uint8.fromByteData', () {
      final bd = Uint8.toByteData(testFrame);

      final uint8 = Uint8.fromByteData(bd);
      print('L1: ${uint8.length}');
      expect(uint8, equals(frame.asUint8List()));
    });
  });
}
