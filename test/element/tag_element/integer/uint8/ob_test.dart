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

void main() {
  Server.initialize(name: 'element/ob_test', level: Level.info);
  final rng = new RNG(1);
  global.throwOnError = false;

  group('OB', () {
    const uInt8MinMax = const [kUint8Min, kUint8Max];
    const uInt8Min = const [kUint8Min];
    const uInt8Max = const [kUint8Max];
    const uInt8MaxPlus = const [kUint8Max + 1];
    const uInt8MinMinus = const [kUint8Min - 1];

    test('OB hasValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        final e0 = new OBtag(PTag.kPrivateInformation, vList0, vList0.length);
        final e1 = new OBtag(PTag.kPrivateInformation, vList0, vList0.length);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
        expect(e1.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList1 = rng.uint8List(2, 3);
        log.debug('$i: vList1: $vList1');
        final e0 =
            new OBtag(PTag.kCoordinateSystemAxisValues, vList1, vList1.length);
        expect(e0.hasValidValues, true);
      }
    });

    test('OB hasValidValues good values', () {
      global.throwOnError = false;
      final e0 = new OBtag(PTag.kPrivateInformation, uInt8Min, uInt8Min.length);
      final e1 = new OBtag(PTag.kPrivateInformation, uInt8Min, uInt8Min.length);
      expect(e0.hasValidValues, true);
      expect(e1.hasValidValues, true);

      final e2 = new OBtag(PTag.kPrivateInformation, uInt8Max, uInt8Max.length);
      final e3 = new OBtag(
          PTag.kCoordinateSystemAxisValues, uInt8Max, uInt8Max.length);
      expect(e2.hasValidValues, true);
      expect(e3.hasValidValues, true);

      global.throwOnError = false;
      final e4 = new OBtag(PTag.kICCProfile, <int>[], 0);
      expect(e4.hasValidValues, true);
      log.debug('e0:$e0');
      expect(e4.values, equals(<int>[]));
    });

    test('OB hasValidValues bad values', () {
      final e0 = new OBtag(
          PTag.kPrivateInformation, uInt8MaxPlus, uInt8MaxPlus.length);
      expect(e0, isNull);

      final e2 = new OBtag(
          PTag.kPrivateInformation, uInt8MinMinus, uInt8MaxPlus.length);
      expect(e2, isNull);

      global.throwOnError = false;
      final e3 = new OBtag(PTag.kPrivateInformation, uInt8Min);
      final uInt16List0 = rng.uint16List(1, 1);
      e3.values = uInt16List0;
      expect(e3.hasValidValues, false);

      global.throwOnError = true;
      expect(() => e3.hasValidValues,
          throwsA(const isInstanceOf<InvalidValuesError>()));

      global.throwOnError = false;
      final e4 = new OBtag(PTag.kICCProfile, null, 0);
      log.debug('e4: $e4');
      expect(e4, isNull);

      global.throwOnError = true;
      expect(() => new OBtag(PTag.kICCProfile, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('OB update random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rng.uint8List(3, 4);
        final e1 = new OBtag(PTag.kPrivateInformation, vList1, vList1.length);
        final vList2 = rng.uint8List(3, 4);
        expect(e1.update(vList2).values, equals(vList2));
      }
    });

    test('OB update', () {
      final e0 = new OBtag(PTag.kPrivateInformation, <int>[], 0);
      expect(e0.update([165, 254]).values, equals([165, 254]));

      final e1 = new OBtag(PTag.kICCProfile, uInt8Min, uInt8Min.length);
      final e2 = new OBtag(PTag.kICCProfile, uInt8Min, uInt8Min.length);
      final e3 = e1.update(uInt8Max);
      final e4 = e2.update(uInt8Max);
      expect(e1.values.first == e4.values.first, false);
      expect(e1 == e4, false);
      expect(e2 == e4, false);
      expect(e3 == e4, true);
    });

    test('OB noValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.uint8List(3, 4);
        final e1 = new OBtag(PTag.kPrivateInformation, vList, vList.length);
        log.debug('e1: ${e1.noValues}');
        expect(e1.noValues.values.isEmpty, true);
      }
    });

    test('OB noValues', () {
      final e0 = new OBtag(PTag.kPrivateInformation, <int>[], 0);
      final OBtag obNoValues = e0.noValues;
      expect(obNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      final e1 = new OBtag(PTag.kPrivateInformation, uInt8Min, uInt8Min.length);
      final obNoValues0 = e1.noValues;
      expect(obNoValues0.values.isEmpty, true);
      log.debug('e1:${e1.noValues}');
    });

    test('OB copy random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.uint8List(3, 4);
        final e2 = new OBtag(PTag.kPrivateInformation, vList, vList.length);
        final OBtag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('OB copy', () {
      final e0 = new OBtag(PTag.kPrivateInformation, <int>[], 0);
      final OBtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      final e2 = new OBtag(PTag.kPrivateInformation, uInt8Min, uInt8Min.length);
      final e3 = e2.copy;
      expect(e2 == e3, true);
      expect(e2.hashCode == e3.hashCode, true);
    });

    test('OB hashCode and == good values random', () {
      global.throwOnError = false;
      final rng = new RNG(1);
      List<int> vList0;

      for (var i = 0; i < 10; i++) {
        vList0 = rng.uint8List(1, 1);
        final e0 = new OBtag(PTag.kICCProfile, vList0, vList0.length);
        final e1 = new OBtag(PTag.kICCProfile, vList0, vList0.length);
        log
          ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
          ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('OB hashCode and == bad values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        final vList1 = rng.uint8List(1, 1);

        final e0 = new OBtag(PTag.kICCProfile, vList0, vList0.length);
        final e2 = new OBtag(PTag.kPrivateInformation, vList1, vList1.length);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rng.uint8List(2, 3);
        final e3 = new OBtag(PTag.kPrivateInformation, vList2, vList2.length);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);
      }
    });

    test('OB hashCode and == good values', () {
      final e0 = new OBtag(PTag.kICCProfile, uInt8Min, uInt8Min.length);
      final e1 = new OBtag(PTag.kICCProfile, uInt8Min, uInt8Min.length);
      log
        ..debug('uInt8Min:$uInt8Min, e0.hash_code:${e0.hashCode}')
        ..debug('uInt8Min:$uInt8Min, e1.hash_code:${e1.hashCode}');
      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);
    });

    test('OB hashCode and == bad values', () {
      final e0 = new OBtag(PTag.kICCProfile, uInt8Min, uInt8Min.length);
      final e2 = new OBtag(PTag.kICCProfile, uInt8Max, uInt8Max.length);
      log.debug('uInt8Max:$uInt8Max , e2.hash_code:${e2.hashCode}');
      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);
    });

    test('OB fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rng.uint8List(1, 1);
        final bytes0 = new Bytes.typedDataView(vList0);
        //       final uInt8ListV11 = uInt8ListV1.buffer.asUint8List();
        final e0 = OBtag.fromBytes(bytes0, PTag.kPrivateInformation, 1);
        expect(e0.hasValidValues, true);
        expect(e0.vfBytes, equals(bytes0));
        expect(e0.values is Uint8List, true);
        expect(e0.values, equals(vList0));

        // Test Base64
//       final base64 = cvt.base64.encode(vList0);
//        final e1 = OBtag.fromBase64(PTag.kPrivateInformation, base64);
//        expect(e0 == e1, true);
//        expect(e1.value, equals(e0.value));

        final vList1 = rng.uint8List(2, 2);
        final bytes1 = new Bytes.typedDataView(vList1);
//        final uInt8ListV12 = uInt8ListV2.buffer.asUint8List();
        final e2 =
            OBtag.fromBytes(bytes1, PTag.kPrivateInformation, vList1.length);
        expect(e2.hasValidValues, true);
      }
    });

    test('OB fromBytes', () {
      final bytes = new Bytes.fromList(uInt8Min);
//      final uInt8ListV11 = uInt8ListV1.buffer.asUint8List();
      final e5 = OBtag.fromBytes(bytes, PTag.kPrivateInformation, 1);
      expect(e5.vfBytes, equals(bytes));
      expect(e5.values is Uint8List, true);
      expect(e5.values, equals(uInt8Min));
    });

    test('OB fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.uint8List(1, 10);
        final bytes0 = DicomBytes.fromAscii(vList.toString());
        final e0 =
            OBtag.fromBytes(bytes0, PTag.kSelectorOBValue, kUndefinedLength);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
      }
    });

    test('OB fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.uint8List(1, 10);
        final bytes0 = DicomBytes.fromAscii(vList.toString());
        final e0 = OBtag.fromBytes(bytes0, PTag.kSelectorFDValue);
        expect(e0, isNull);
        global.throwOnError = true;
        expect(() => OBtag.fromBytes(bytes0, PTag.kSelectorFDValue),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });

    test('OB checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        final e0 = new OBtag(PTag.kPrivateInformation, vList0, vList0.length);
        expect(e0.checkLength(e0.values), true);
      }
    });

    test('OB checkLength', () {
      final e0 =
          new OBtag(PTag.kPrivateInformation, uInt8MinMax, uInt8MinMax.length);
      expect(e0.checkLength(e0.values), true);
    });

    test('OB checkValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        final e0 = new OBtag(PTag.kPrivateInformation, vList0, vList0.length);
        expect(e0.checkValues(e0.values), true);
      }
    });

    test('OB checkValues', () {
      final e0 = new OBtag(PTag.kPrivateInformation, uInt8Min, uInt8Min.length);
      expect(e0.checkValues(e0.values), true);
    });

    test('OB valuesCopy random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        final e0 = new OBtag(PTag.kPrivateInformation, vList0, vList0.length);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('OB valuesCopy', () {
      final e0 = new OBtag(PTag.kPrivateInformation, uInt8Min, uInt8Min.length);
      expect(uInt8Min, equals(e0.valuesCopy));
    });

    test('OB replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        final e0 = new OBtag(PTag.kPrivateInformation, vList0, vList0.length);
        final vList1 = rng.uint8List(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rng.uint8List(1, 1);
      final e1 = new OBtag(PTag.kPrivateInformation, vList1);
      expect(e1.replace(<int>[]), equals(vList1));
      expect(e1.values, equals(<int>[]));

      final e2 = new OBtag(PTag.kPrivateInformation, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(<int>[]));
    });

/*
    test('OB BASE64 random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        final uInt8ListV1 = new Bytes.typedDataView(vList0);
        final uInt8ListV11 = uInt8ListV1.buffer.asUint8List();
        final base64 = cvt.base64.encode(uInt8ListV11);
        final e0 = OBtag.fromBase64(PTag.kPrivateInformation, base64);
        expect(e0.hasValidValues, true);
      }
    });

    test('OB BASE64', () {
      final uInt8ListV1 = new Uint8List.fromList(uInt8Min);
      final uInt8ListV11 = uInt8ListV1.buffer.asUint8List();
      final base64 = cvt.base64.encode(uInt8ListV11);
      final e0 = OBtag.fromBase64(PTag.kPrivateInformation, base64);
      expect(e0.hasValidValues, true);
    });
*/

    test('OB make', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        final e0 = OBtag.fromValues(PTag.kPrivateInformation, vList0);
        expect(e0.hasValidValues, true);
      }
    });

    test('OB fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        final bytes = new Bytes.typedDataView(vList0);
//        final uInt8ListV11 = bytes.buffer.asUint8List();
        log.debug('bytes.length: ${bytes.length}');
        final e0 =
            OBtag.fromBytes(bytes, PTag.kPrivateInformation, bytes.length);
        expect(e0.hasValidValues, true);
        expect(e0.vfBytes, equals(bytes));
        expect(e0.values is Uint8List, true);
        expect(e0.values, equals(bytes));
      }
    });

/*
    test('OB fromB64', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        final bytes = new Bytes.typedDataView(vList0);
//        final uInt8ListV11 = bytes.buffer.asUint8List();
//        final b64 = cvt.base64.encode(uInt8ListV11);
        final e0 = OBtag.fromBase64(PTag.kPrivateInformation, b64);
        expect(e0.hasValidValues, true);
      }
    });
*/

    test('OB checkValue good values', () {
      final vList0 = rng.uint8List(1, 1);
      final e0 = new OBtag(PTag.kPrivateInformation, vList0);
      expect(e0.checkValue(uInt8Max[0]), true);
      expect(e0.checkValue(uInt8Min[0]), true);
    });

    test('OB checkValue bad values', () {
      final vList0 = rng.uint8List(1, 1);
      final e0 = new OBtag(PTag.kPrivateInformation, vList0);
      expect(e0.checkValue(uInt8MaxPlus[0]), false);
      expect(e0.checkValue(uInt8MinMinus[0]), false);
    });

    test('OB view', () {
      final vList0 = rng.uint8List(10, 10);
      final e0 = new OBtag(PTag.kSelectorOBValue, vList0);
      for (var i = 0, j = 0; i < vList0.length; i++, j++) {
        final e1 = e0.view(j, vList0.length - i);
        log.debug('e0: ${e0.values}, e1: ${e1.values}, '
            'vList0.subList(i) : ${vList0.sublist(i)}');
        expect(e1.values, equals(vList0.sublist(i)));
      }
    });
  });

  group('OB Element', () {
    //VM.k1
    const obVM1Tags = const <PTag>[
      PTag.kFileMetaInformationVersion,
      PTag.kPrivateInformation,
      PTag.kCoordinateSystemAxisValues,
      PTag.kBadPixelImage,
      PTag.kICCProfile,
      PTag.kObjectBinaryIdentifierTrial,
      PTag.kObjectDirectoryBinaryIdentifierTrial,
      PTag.kEncapsulatedDocument,
      PTag.kHPGLDocument,
      PTag.kFillPattern,
      PTag.kCertificateOfSigner,
      PTag.kSignature,
      PTag.kCertifiedTimestamp,
      PTag.kMAC,
      PTag.kEncryptedContent,
      PTag.kThreatROIBitmap,
      PTag.kDetectorCalibrationData,
      PTag.kDataSetTrailingPadding
    ];

    //VM.k1_n
    const obVM1_nTags = const <PTag>[
      PTag.kSelectorOBValue,
    ];

    final obowTags = <PTag>[
      PTag.kVariablePixelData,
      PTag.kDarkCurrentCounts,
      PTag.kAirCounts,
      PTag.kAudioSampleData,
      PTag.kCurveData,
      PTag.kChannelMinimumValue,
      PTag.kChannelMaximumValue,
      PTag.kWaveformPaddingValue,
      PTag.kWaveformData,
      PTag.kOverlayData
    ];

    const otherTags = const <PTag>[
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

    test('OB isValidLength', () {
      global.throwOnError = false;
      final vList = rng.uint8List(1, 1);
      for (var tag in obVM1Tags) {
        expect(OB.isValidLength(tag, vList), true);
      }

      for (var tag in obowTags) {
        expect(OB.isValidLength(tag, vList), false);
      }

      expect(OB.isValidLength(PTag.kSelectorOBValue, vList), true);

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OB.isValidLength(tag, vList), false);

        global.throwOnError = true;
        expect(() => OB.isValidLength(tag, vList),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });

    test('OB isValidTag good values', () {
      global.throwOnError = false;
      expect(OB.isValidTag(PTag.kSelectorOBValue), true);
      expect(OB.isValidTag(PTag.kAudioSampleData), true);

      for (var tag in obVM1Tags) {
        expect(OB.isValidTag(tag), true);
      }

      for (var tag in obowTags) {
        final e3 = OB.isValidTag(tag);
        expect(e3, true);
      }
    });

    test('OB isValidTag bad values', () {
      global.throwOnError = false;
      expect(OB.isValidTag(PTag.kSelectorUSValue), false);

      global.throwOnError = true;
      expect(() => OB.isValidTag(PTag.kSelectorUSValue),
          throwsA(const isInstanceOf<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OB.isValidTag(tag), false);

        global.throwOnError = true;
        expect(() => OB.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });

    test('OB isNotValidTag good values', () {
      global.throwOnError = false;
      expect(OB.isValidTag(PTag.kSelectorOBValue), true);
      expect(OB.isValidTag(PTag.kAudioSampleData), true);

      for (var tag in obVM1Tags) expect(OB.isValidTag(tag), true);

      for (var tag in obowTags) {
        final e3 = OB.isValidTag(tag);
        expect(e3, true);
      }
    });

    test('OB isValidTag bad values', () {
      global.throwOnError = false;
      expect(OB.isValidTag(PTag.kSelectorUSValue), false);

      global.throwOnError = true;
      expect(() => OB.isValidTag(PTag.kSelectorUSValue),
          throwsA(const isInstanceOf<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OB.isValidTag(tag), false);

        global.throwOnError = true;
        expect(() => OB.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });

    test('OB isValidVR good values', () {
      global.throwOnError = false;
      expect(OB.isValidVRIndex(kOBIndex), true);

      for (var tag in obVM1Tags) {
        global.throwOnError = false;
        expect(OB.isValidVRIndex(tag.vrIndex), true);
      }

      for (var tag in obowTags) {
        final e3 = OB.isValidVRIndex(tag.vrIndex);
        expect(e3, true);
      }

      for (var tag in obVM1_nTags) {
        global.throwOnError = false;
        expect(OB.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('OB isValidVR bad values', () {
      global.throwOnError = false;
      expect(OB.isValidVRIndex(kAEIndex), false);
      global.throwOnError = true;
      expect(() => OB.isValidVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OB.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => OB.isValidVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });
/*

    test('OB checkVR good values', () {
      global.throwOnError = false;
      expect(OB.checkVRIndex(kOBIndex), kOBIndex);

      for (var tag in obTags0) {
        global.throwOnError = false;
        expect(OB.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }

      for (var tag in obowTags) {
        final e3 = OB.checkVRIndex(tag.vrIndex);
        expect(e3, tag.vrIndex);
      }
    });
    test('OB checkVR bad values', () {
      global.throwOnError = false;
      expect(OB.checkVRIndex(kAEIndex), isNull);
      global.throwOnError = true;
      expect(() => OB.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OB.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => OB.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });
*/

    test('OB isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(OB.isValidVRIndex(kOBIndex), true);

      for (var tag in obVM1Tags) {
        expect(OB.isValidVRIndex(tag.vrIndex), true);
      }

      for (var tag in obowTags) {
        final e3 = OB.isValidVRIndex(tag.vrIndex);
        expect(e3, true);
      }
    });

    test('OB isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(OB.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => OB.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OB.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => OB.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('OB isValidVRCode good values', () {
      global.throwOnError = false;
      expect(OB.isValidVRCode(kOBCode), true);
      for (var tag in obVM1Tags) {
        expect(OB.isValidVRCode(tag.vrCode), true);
      }
    });

    test('OB isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(OB.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => OB.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OB.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => OB.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('OB isValidVFLength good values', () {
      expect(OB.isValidVFLength(OB.kMaxVFLength, kUndefinedLength), true);
      expect(OB.isValidVFLength(0, 0), true);
    });

    test('OB isValidVFLength bad values', () {
      global.throwOnError = false;
      expect(OB.isValidVFLength(OB.kMaxVFLength + 1, kUndefinedLength), false);
      expect(OB.isValidVFLength(-1, 1), false);
    });

    test('OB isValidValue good values', () {
      expect(OB.isValidValue(OB.kMinValue), true);
      expect(OB.isValidValue(OB.kMaxValue), true);
    });

    test('OB isValidValue bad values', () {
      expect(OB.isValidValue(OB.kMinValue - 1), false);
      expect(OB.isValidValue(OB.kMaxValue + 1), false);
    });

    test('OB isValidValues good values', () {
      global.throwOnError = false;
      const uInt8MinMax = const [kUint8Min, kUint8Max];
      const uInt8Min = const [kUint8Min];
      const uInt8Max = const [kUint8Max];

      //VM.k1
      expect(OB.isValidValues(PTag.kICCProfile, uInt8Min), true);
      expect(OB.isValidValues(PTag.kICCProfile, uInt8Max), true);

      //VM.k1_n
      expect(OB.isValidValues(PTag.kSelectorOBValue, uInt8Max), true);
      expect(OB.isValidValues(PTag.kSelectorOBValue, uInt8Max), true);
      expect(OB.isValidValues(PTag.kSelectorOBValue, uInt8MinMax), true);
    });

    test('OB isValidValues bad values', () {
      const uInt8MaxPlus = const [kUint8Max + 1];
      const uInt8MinMinus = const [kUint8Min - 1];

      //VM.k1
      expect(OB.isValidValues(PTag.kICCProfile, uInt8MaxPlus), false);
      expect(OB.isValidValues(PTag.kICCProfile, uInt8MinMinus), false);

      global.throwOnError = true;
      expect(() => OB.isValidValues(PTag.kICCProfile, uInt8MaxPlus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
      expect(() => OB.isValidValues(PTag.kICCProfile, uInt8MinMinus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    /*test('OB toUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        expect(Uint8.fromList(vList0), vList0);
      }
      const uInt8Min = const [kUint8Min];
      const uInt8Max = const [kUint8Max];
      expect(Uint8.fromList(uInt8Min), uInt8Min);
      expect(Uint8.fromList(uInt8Max), uInt8Max);
    });

    test('Uint8Base.fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        final bytes = new Bytes.typedDataView(vList0);
//        final bd = bytes.buffer.asUint8List();
        log
          ..debug('uInt8ListV1 : $bytes')
          ..debug('Uint8Base.fromBytes(bd) ; ${Uint8.fromBytes(bytes)}');
        expect(Uint8.fromBytes(bytes), equals(bytes));
      }
    });

    test('Uint8Base.ListToBytes', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        final uInt8ListV1 = new Bytes.typedDataView(vList0);
        final bd = uInt8ListV1.buffer.asUint8List();
        log
          ..debug('uInt8ListV1 : $uInt8ListV1')
          ..debug('Uint8Base.ListToBytesBytes(int32ListV1) ; '
              '${Uint8.toBytes(uInt8ListV1)}');
        expect(Uint8.toBytes(uInt8ListV1), equals(bd));
      }

      const uInt8Max = const [kUint8Max];
      final uInt8ListV1 = new Uint8List.fromList(uInt8Max);
      final uint8List = uInt8ListV1.buffer.asUint8List();
      expect(Uint8.toBytes(uInt8Max), uint8List);

      const uInt16Max = const [kUint16Max];
      final uInt16List2 = Uint16.fromList(uInt16Max);
      expect(Uint8.toUint8List(uInt16List2), isNull);

      global.throwOnError = true;
      expect(() => Uint8.toBytes(uInt16Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('Uint8Base ListToByteData good values', () {
      global.level = Level.info;
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rng.uint8List(1, 1);
        final bd0 = vList0.buffer.asByteData();
        final lBd0 = Uint8.toByteData(vList0);
        log.debug('lBd0: ${lBd0.buffer.asUint8List()}, bd0: ${bd0.buffer
            .asUint8List()}');
        expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd0.buffer == bd0.buffer, true);

        final lBd1 = Uint8.toByteData(vList0);
        log.debug('lBd3: ${lBd1.buffer.asUint8List()}, '
            'bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd1.buffer == bd0.buffer, true);
      }

      const uint8Max = const [kUint8Max];
      final uint8List = new Uint8List.fromList(uint8Max);
      final bd1 = uint8List.buffer.asByteData();
      final lBd2 = Uint8.toByteData(uint8List);
      log.debug('bd: ${bd1.buffer.asUint8List()}, '
          'lBd2: ${lBd2.buffer.asUint8List()}');
      expect(lBd2.buffer.asUint8List(), equals(bd1.buffer.asUint8List()));
      expect(lBd2.buffer == bd1.buffer, true);
    });

    test('Uint8Base toByteData bad values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rng.uint8List(1, 1);
        final bd0 = vList0.buffer.asByteData();
        final lBd1 = Uint8.toByteData(vList0);
        log.debug('lBd1: ${lBd1.buffer.asUint8List()}, '
            'bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd1.buffer == bd0.buffer, true);

        final uint16List0 = rng.uint16List(1, 1);
        assert(uint16List0 is TypedData);
        final bd1 = uint16List0.buffer.asByteData();
        final lBd2 = Uint16.toByteData(uint16List0);
        log.debug('lBd0: ${lBd2.buffer.asUint8List()}, '
            'bd1: ${bd1.buffer.asUint8List()}');
        expect(lBd2.buffer.asUint8List(), isNot(bd0.buffer.asUint8List()));
        expect(lBd2.buffer == bd0.buffer, false);

        final lBd3 = Uint16.toByteData(uint16List0, asView: false);
        expect(lBd3.buffer == bd1.buffer, false);
        expect(lBd3.buffer.asUint8List() != bd1.buffer.asUint8List(), true);

        final lBd4 = Uint8.toByteData(vList0);
        log.debug('lBd4: ${lBd4.buffer.asUint8List()}, '
            'bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd4.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd4.buffer == bd0.buffer, true);
      }

      global.throwOnError = false;
      const uInt16Max = const <int>[kUint16Max];

      expect(Uint8.toByteData(uInt16Max), isNull);

      global.throwOnError = false;
      const uInt32Max = const <int>[kUint32Max];
      expect(Uint8.toByteData(uInt32Max), isNull);

      global.throwOnError = true;
      expect(() => Uint8.toByteData(uInt16Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('Uint8Base.fromBase64', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(0, i);
        final uInt8ListV1 = new Bytes.typedDataView(vList0);
        final bd = uInt8ListV1.buffer.asUint8List();
        final base64 = cvt.base64.encode(bd);
        log.debug('OB.base64: "$base64"');

        final obList = Uint8.fromBase64(base64);
        log.debug('  OB.decode: $obList');
        expect(obList, equals(vList0));
        expect(obList, equals(uInt8ListV1));
      }
    });

    test('Uint8Base.ListToBase64', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(0, i);
        final uInt8ListV1 = new Bytes.typedDataView(vList0);
        final bd = uInt8ListV1.buffer.asUint8List();
        final s = cvt.base64.encode(bd);
        expect(Uint8.toBase64(vList0), equals(s));
      }
    });

    test('OB encodeDecodeJsonVF', () {
      global.level = Level.info;
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint8List(0, i);
        final uInt8ListV1 = new Bytes.typedDataView(vList0);
        final bd = uInt8ListV1.buffer.asUint8List();

        // Encode
        final base64 = cvt.base64.encode(bd);
        log.debug('OB.base64: "$base64"');
        final s = Uint8.toBase64(vList0);
        log.debug('  OB.json: "$s"');
        expect(s, equals(base64));

        // Decode
        final e0 = Uint8.fromBase64(base64);
        log.debug('OB.base64: $e0');
        final e1 = Uint8.fromBase64(s);
        log.debug('  OB.json: $e1');
        expect(e0, equals(vList0));
        expect(e0, equals(uInt8ListV1));
        expect(e0, equals(e1));
      }
    });

    test('Uint8Base.fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        final bytes = new Bytes.typedDataView(vList0);
//        final bd = uInt8ListV1.buffer.asUint8List();
        log
          ..debug('uInt8ListV1 : $bytes')
          ..debug('Uint8Base.fromBytes(bd) ; ${Uint8.fromBytes(bytes)}');
        expect(Uint8.fromBytes(bytes), equals(vList0));
      }
    });

    test('Uint8Base.fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        final uInt8ListV1 = new Bytes.typedDataView(vList0);
        final byteData = uInt8ListV1.buffer.asByteData();
        log
          ..debug('vList0 : $vList0')
          ..debug('Uint8Base.fromByteData(byteData): '
              '${Uint8.fromByteData(byteData)}');
        expect(Uint8.fromByteData(byteData), equals(vList0));
      }
    });*/
  });
}