//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:convert' as cvt;
import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/uInt8_test', level: Level.info);
  final rng = new RNG(1);

  group('OB', () {
    const uInt8MinMax = const [kUint8Min, kUint8Max];
    const uint8Min = const [kUint8Min];
    const uInt8Max = const [kUint8Max];
    const uInt8MaxPlus = const [kUint8Max + 1];
    const uInt8MinMinus = const [kUint8Min - 1];

    test('OB hasValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final uInt8List0 = rng.uint8List(1, 1);
        final ob0 =
            new OBtag(PTag.kPrivateInformation, uInt8List0, uInt8List0.length);
        final ob1 =
            new OBtag(PTag.kPrivateInformation, uInt8List0, uInt8List0.length);
        log.debug('ob0: ${ob0.info}');
        expect(ob0.hasValidValues, true);
        expect(ob1.hasValidValues, true);

        log
          ..debug('ob0: $ob0, values: ${ob0.values}')
          ..debug('ob0: ${ob0.info}');
        expect(ob0[0], equals(uInt8List0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final uInt8List1 = rng.uint8List(2, 3);
        log.debug('$i: uInt8List1: $uInt8List1');
        final ob0 = new OBtag(
            PTag.kCoordinateSystemAxisValues, uInt8List1, uInt8List1.length);
        expect(ob0.hasValidValues, true);
      }
    });

    test('OB hasValidValues good values', () {
      system.throwOnError = false;
      final ob0 =
          new OBtag(PTag.kPrivateInformation, uint8Min, uint8Min.length);
      final ob1 =
          new OBtag(PTag.kPrivateInformation, uint8Min, uint8Min.length);
      expect(ob0.hasValidValues, true);
      expect(ob1.hasValidValues, true);

      final ob2 =
          new OBtag(PTag.kPrivateInformation, uInt8Max, uInt8Max.length);
      final ob3 = new OBtag(
          PTag.kCoordinateSystemAxisValues, uInt8Max, uInt8Max.length);
      expect(ob2.hasValidValues, true);
      expect(ob3.hasValidValues, true);

      system.throwOnError = false;
      final ob4 = new OBtag(PTag.kICCProfile, <int>[], 0);
      expect(ob4.hasValidValues, true);
      log.debug('ob0:${ob0.info}');
      expect(ob4.values, equals(<int>[]));
    });

    test('OB hasValidValues bad values', () {
      final ob0 = new OBtag(
          PTag.kPrivateInformation, uInt8MaxPlus, uInt8MaxPlus.length);
      expect(ob0, isNull);

      final ob2 = new OBtag(
          PTag.kPrivateInformation, uInt8MinMinus, uInt8MaxPlus.length);
      expect(ob2, isNull);

      system.throwOnError = false;
      final ob3 = new OBtag(PTag.kPrivateInformation, uint8Min);
      final uInt16List0 = rng.uint16List(1, 1);
      ob3.values = uInt16List0;
      expect(ob3.hasValidValues, false);

      system.throwOnError = true;
      expect(() => ob3.hasValidValues,
          throwsA(const isInstanceOf<InvalidValuesError>()));

      system.throwOnError = false;
      final ob4 = new OBtag(PTag.kICCProfile, null, 0);
      log.debug('ob4: $ob4');
      expect(ob4, isNull);

      system.throwOnError = true;
      expect(() => new OBtag(PTag.kICCProfile, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('OB update random', () {
      for (var i = 0; i < 10; i++) {
        final uInt8List1 = rng.uint8List(3, 4);
        final ob1 =
            new OBtag(PTag.kPrivateInformation, uInt8List1, uInt8List1.length);
        final uInt8List2 = rng.uint8List(3, 4);
        expect(ob1.update(uInt8List2).values, equals(uInt8List2));
      }
    });

    test('OB update', () {
      final ob0 = new OBtag(PTag.kPrivateInformation, <int>[], 0);
      expect(ob0.update([165, 254]).values, equals([165, 254]));

      final ob1 = new OBtag(PTag.kICCProfile, uint8Min, uint8Min.length);
      final ob2 = new OBtag(PTag.kICCProfile, uint8Min, uint8Min.length);
      final ob3 = ob1.update(uInt8Max);
      final ob4 = ob2.update(uInt8Max);
      expect(ob1.values.first == ob4.values.first, false);
      expect(ob1 == ob4, false);
      expect(ob2 == ob4, false);
      expect(ob3 == ob4, true);
    });

    test('OB noValues random', () {
      for (var i = 0; i < 10; i++) {
        final uInt8List = rng.uint8List(3, 4);
        final ob1 =
            new OBtag(PTag.kPrivateInformation, uInt8List, uInt8List.length);
        log.debug('ob1: ${ob1.noValues}');
        expect(ob1.noValues.values.isEmpty, true);
      }
    });

    test('OB noValues', () {
      final ob0 = new OBtag(PTag.kPrivateInformation, <int>[], 0);
      final OBtag obNoValues = ob0.noValues;
      expect(obNoValues.values.isEmpty, true);
      log.debug('ob0: ${ob0.noValues}');

      final ob1 =
          new OBtag(PTag.kPrivateInformation, uint8Min, uint8Min.length);
      final obNoValues0 = ob1.noValues;
      expect(obNoValues0.values.isEmpty, true);
      log.debug('ob1:${ob1.noValues}');
    });

    test('OB copy random', () {
      for (var i = 0; i < 10; i++) {
        final uInt8List = rng.uint8List(3, 4);
        final ob2 =
            new OBtag(PTag.kPrivateInformation, uInt8List, uInt8List.length);
        final OBtag ob3 = ob2.copy;
        expect(ob3 == ob2, true);
        expect(ob3.hashCode == ob2.hashCode, true);
      }
    });

    test('OB copy', () {
      final ob0 = new OBtag(PTag.kPrivateInformation, <int>[], 0);
      final OBtag ob1 = ob0.copy;
      expect(ob1 == ob0, true);
      expect(ob1.hashCode == ob0.hashCode, true);

      final ob2 =
          new OBtag(PTag.kPrivateInformation, uint8Min, uint8Min.length);
      final ob3 = ob2.copy;
      expect(ob2 == ob3, true);
      expect(ob2.hashCode == ob3.hashCode, true);
    });

    test('OB hashCode and == good values random', () {
      system.throwOnError = false;
      final rng = new RNG(1);
      List<int> uInt8List0;

      for (var i = 0; i < 10; i++) {
        uInt8List0 = rng.uint8List(1, 1);
        final ob0 = new OBtag(PTag.kICCProfile, uInt8List0, uInt8List0.length);
        final ob1 = new OBtag(PTag.kICCProfile, uInt8List0, uInt8List0.length);
        log
          ..debug('uInt8List0:$uInt8List0, ob0.hash_code:${ob0.hashCode}')
          ..debug('uInt8List0:$uInt8List0, ob1.hash_code:${ob1.hashCode}');
        expect(ob0.hashCode == ob1.hashCode, true);
        expect(ob0 == ob1, true);
      }
    });

    test('OB hashCode and == bad values random', () {
      List<int> uInt8List0;
      List<int> uInt8List1;
      List<int> uInt8List2;

      for (var i = 0; i < 10; i++) {
        uInt8List0 = rng.uint8List(1, 1);
        uInt8List1 = rng.uint8List(1, 1);

        final ob0 = new OBtag(PTag.kICCProfile, uInt8List0, uInt8List0.length);
        final ob2 =
            new OBtag(PTag.kPrivateInformation, uInt8List1, uInt8List1.length);
        log.debug('uInt8List1:$uInt8List1 , ob2.hash_code:${ob2.hashCode}');
        expect(ob0.hashCode == ob2.hashCode, false);
        expect(ob0 == ob2, false);

        uInt8List2 = rng.uint8List(2, 3);
        final ob3 =
            new OBtag(PTag.kPrivateInformation, uInt8List2, uInt8List2.length);
        log.debug('uInt8List2:$uInt8List2 , ob3.hash_code:${ob3.hashCode}');
        expect(ob0.hashCode == ob3.hashCode, false);
        expect(ob0 == ob3, false);
      }
    });

    test('OB hashCode and == good values', () {
      final ob0 = new OBtag(PTag.kICCProfile, uint8Min, uint8Min.length);
      final ob1 = new OBtag(PTag.kICCProfile, uint8Min, uint8Min.length);
      log
        ..debug('uInt8Min:$uint8Min, ob0.hash_code:${ob0.hashCode}')
        ..debug('uInt8Min:$uint8Min, ob1.hash_code:${ob1.hashCode}');
      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);
    });

    test('OB hashCode and == bad values', () {
      final ob0 = new OBtag(PTag.kICCProfile, uint8Min, uint8Min.length);
      final ob2 = new OBtag(PTag.kICCProfile, uInt8Max, uInt8Max.length);
      log.debug('uInt8Max:$uInt8Max , ob2.hash_code:${ob2.hashCode}');
      expect(ob0.hashCode == ob2.hashCode, false);
      expect(ob0 == ob2, false);
    });

    test('OB fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final uInt8List0 = rng.uint8List(1, 1);
        final bytes0 = new Bytes.typedDataView(uInt8List0);
 //       final uInt8ListV11 = uInt8ListV1.buffer.asUint8List();
        final ob0 = OBtag.fromBytes(PTag.kPrivateInformation, bytes0, 10);
        expect(ob0.hasValidValues, true);
        expect(ob0.vfBytes, equals(bytes0));
        expect(ob0.values is Uint8List, true);
        expect(ob0.values, equals(uInt8List0));

        // Test Base64
//       final base64 = cvt.base64.encode(uInt8List0);
//        final ob1 = OBtag.fromBase64(PTag.kPrivateInformation, base64);
//        expect(ob0 == ob1, true);
//        expect(ob1.value, equals(ob0.value));

        final uInt8List1 = rng.uint8List(2, 2);
        final bytes1 = new Bytes.typedDataView(uInt8List1);
//        final uInt8ListV12 = uInt8ListV2.buffer.asUint8List();
        final ob2 = OBtag.fromBytes(PTag.kPrivateInformation, bytes1, 10);
        expect(ob2.hasValidValues, true);
      }
    });

    test('OB fromBytes', () {
      final bytes = new Bytes.fromList(uint8Min);
//      final uInt8ListV11 = uInt8ListV1.buffer.asUint8List();
      final ob5 = OBtag.fromBytes(PTag.kPrivateInformation, bytes, 10);
      expect(ob5.vfBytes, equals(bytes));
      expect(ob5.values is Uint8List, true);
      expect(ob5.values, equals(uint8Min));
    });

    test('OB fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final intList0 = rng.uint8List(1, 10);
        final bytes0 = DicomBytes.toAscii(intList0.toString());
        final ob0 = OBtag.fromBytes(PTag.kSelectorOBValue, bytes0);
        log.debug('ob0: ${ob0.info}');
        expect(ob0.hasValidValues, true);
      }
    });

    test('OB fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final intList0 = rng.uint8List(1, 10);
        final bytes0 = DicomBytes.toAscii(intList0.toString());
        final ob0 = OBtag.fromBytes(PTag.kSelectorFDValue, bytes0);
        expect(ob0, isNull);
        system.throwOnError = true;
        expect(() => OBtag.fromBytes(PTag.kSelectorFDValue, bytes0),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });

    test('OB checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final uInt8List0 = rng.uint8List(1, 1);
        final ob0 =
            new OBtag(PTag.kPrivateInformation, uInt8List0, uInt8List0.length);
        expect(ob0.checkLength(ob0.values), true);
      }
    });

    test('OB checkLength', () {
      final ob0 =
          new OBtag(PTag.kPrivateInformation, uInt8MinMax, uInt8MinMax.length);
      expect(ob0.checkLength(ob0.values), true);
    });

    test('OB checkValues random', () {
      for (var i = 0; i < 10; i++) {
        final uInt8List0 = rng.uint8List(1, 1);
        final ob0 =
            new OBtag(PTag.kPrivateInformation, uInt8List0, uInt8List0.length);
        expect(ob0.checkValues(ob0.values), true);
      }
    });

    test('OB checkValues', () {
      final ob0 =
          new OBtag(PTag.kPrivateInformation, uint8Min, uint8Min.length);
      expect(ob0.checkValues(ob0.values), true);
    });

    test('OB valuesCopy random', () {
      for (var i = 0; i < 10; i++) {
        final uInt8List0 = rng.uint8List(1, 1);
        final ob0 =
            new OBtag(PTag.kPrivateInformation, uInt8List0, uInt8List0.length);
        expect(uInt8List0, equals(ob0.valuesCopy));
      }
    });

    test('OB valuesCopy', () {
      final ob0 =
          new OBtag(PTag.kPrivateInformation, uint8Min, uint8Min.length);
      expect(uint8Min, equals(ob0.valuesCopy));
    });

    test('OB replace random', () {
      for (var i = 0; i < 10; i++) {
        final uInt8List0 = rng.uint8List(1, 1);
        final ob0 =
            new OBtag(PTag.kPrivateInformation, uInt8List0, uInt8List0.length);
        final uInt8List1 = rng.uint8List(1, 1);
        expect(ob0.replace(uInt8List1), equals(uInt8List0));
        expect(ob0.values, equals(uInt8List1));
      }

      final uInt8List1 = rng.uint8List(1, 1);
      final ob1 = new OBtag(PTag.kPrivateInformation, uInt8List1);
      expect(ob1.replace(<int>[]), equals(uInt8List1));
      expect(ob1.values, equals(<int>[]));

      final ob2 = new OBtag(PTag.kPrivateInformation, uInt8List1);
      expect(ob2.replace(null), equals(uInt8List1));
      expect(ob2.values, equals(<int>[]));
    });

/*
    test('OB BASE64 random', () {
      for (var i = 0; i < 10; i++) {
        final uInt8List0 = rng.uint8List(1, 1);
        final uInt8ListV1 = new Bytes.typedDataView(uInt8List0);
        final uInt8ListV11 = uInt8ListV1.buffer.asUint8List();
        final base64 = cvt.base64.encode(uInt8ListV11);
        final ob0 = OBtag.fromBase64(PTag.kPrivateInformation, base64);
        expect(ob0.hasValidValues, true);
      }
    });

    test('OB BASE64', () {
      final uInt8ListV1 = new Uint8List.fromList(uInt8Min);
      final uInt8ListV11 = uInt8ListV1.buffer.asUint8List();
      final base64 = cvt.base64.encode(uInt8ListV11);
      final ob0 = OBtag.fromBase64(PTag.kPrivateInformation, base64);
      expect(ob0.hasValidValues, true);
    });
*/

    test('OB make', () {
      for (var i = 0; i < 10; i++) {
        final uInt8List0 = rng.uint8List(1, 1);
        final ob0 = OBtag.fromValues(PTag.kPrivateInformation, uInt8List0);
        expect(ob0.hasValidValues, true);
      }
    });

    test('OB fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uInt8List0 = rng.uint8List(1, 1);
        final bytes = new Bytes.typedDataView(uInt8List0);
//        final uInt8ListV11 = bytes.buffer.asUint8List();
        log.debug('bytes.length: ${bytes.length}');
        final ob0 = OBtag.fromBytes(
            PTag.kPrivateInformation, bytes, bytes.length);
        expect(ob0.hasValidValues, true);
        expect(ob0.vfBytes, equals(bytes));
        expect(ob0.values is Uint8List, true);
        expect(ob0.values, equals(bytes));
      }
    });

/*
    test('OB fromB64', () {
      for (var i = 0; i < 10; i++) {
        final uInt8List0 = rng.uint8List(1, 1);
        final bytes = new Bytes.typedDataView(uInt8List0);
//        final uInt8ListV11 = bytes.buffer.asUint8List();
//        final b64 = cvt.base64.encode(uInt8ListV11);
        final ob0 = OBtag.fromBase64(PTag.kPrivateInformation, b64);
        expect(ob0.hasValidValues, true);
      }
    });
*/

    test('OB checkValue good values', () {
      final uInt8List0 = rng.uint8List(1, 1);
      final ob0 = new OBtag(PTag.kPrivateInformation, uInt8List0);
      expect(ob0.checkValue(uInt8Max[0]), true);
      expect(ob0.checkValue(uint8Min[0]), true);
    });

    test('OB checkValue bad values', () {
      final uInt8List0 = rng.uint8List(1, 1);
      final ob0 = new OBtag(PTag.kPrivateInformation, uInt8List0);
      expect(ob0.checkValue(uInt8MaxPlus[0]), false);
      expect(ob0.checkValue(uInt8MinMinus[0]), false);
    });

    test('OB view', () {
      final uInt8List0 = rng.uint8List(10, 10);
      final ob0 = new OBtag(PTag.kSelectorOBValue, uInt8List0);
      for (var i = 0, j = 0; i < uInt8List0.length; i++, j++) {
        final ob1 = ob0.view(j, uInt8List0.length - i);
        log.debug('ob0: ${ob0.values}, ob1: ${ob1.values}, '
            'uInt8List0.subList(i) : ${uInt8List0.sublist(i)}');
        expect(ob1.values, equals(uInt8List0.sublist(i)));
      }
    });
  });

  group('OB Element', () {
    //VM.k1
    const obTags0 = const <PTag>[
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
    const obTags1 = const <PTag>[
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

    test('OB isValidVListLength', () {
      system.throwOnError = false;
      // Urgent Sharath: please fix
 //     expect(OB.isValidVListLength(PTag.kPixelData, OB.kMaxLength), true);
 //     expect(OB.isValidVListLength(0), true);
    });

    test('OB isValidTag good values', () {
      system.throwOnError = false;
      expect(OB.isValidTag(PTag.kSelectorOBValue), true);
      expect(OB.isValidTag(PTag.kAudioSampleData), true);

      for (var tag in obTags0) {
        expect(OB.isValidTag(tag), true);
      }

      for (var tag in obowTags) {
        final ob3 = OB.isValidTag(tag);
        expect(ob3, true);
      }
    });

    test('OB isValidTag bad values', () {
      system.throwOnError = false;
      expect(OB.isValidTag(PTag.kSelectorUSValue), false);

      system.throwOnError = true;
      expect(() => OB.isValidTag(PTag.kSelectorUSValue),
          throwsA(const isInstanceOf<InvalidTagError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OB.isValidTag(tag), false);

        system.throwOnError = true;
        expect(() => OB.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });

    test('OB isNotValidTag good values', () {
      system.throwOnError = false;
      expect(OB.isNotValidTag(PTag.kSelectorOBValue), false);
      expect(OB.isNotValidTag(PTag.kAudioSampleData), false);

      for (var tag in obTags0) {
        expect(OB.isNotValidTag(tag), false);
      }
      for (var tag in obowTags) {
        final ob3 = OB.isNotValidTag(tag);
        expect(ob3, false);
      }
    });

    test('OB isNotValidTag bad values', () {
      system.throwOnError = false;
      expect(OB.isNotValidTag(PTag.kSelectorUSValue), true);

      system.throwOnError = true;
      expect(() => OB.isNotValidTag(PTag.kSelectorUSValue),
          throwsA(const isInstanceOf<InvalidTagError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OB.isNotValidTag(tag), true);

        system.throwOnError = true;
        expect(() => OB.isNotValidTag(tag),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });

    test('OB isValidVR good values', () {
      system.throwOnError = false;
      expect(OB.isValidVRIndex(kOBIndex), true);

      for (var tag in obTags0) {
        system.throwOnError = false;
        expect(OB.isValidVRIndex(tag.vrIndex), true);
      }

      for (var tag in obowTags) {
        final ob3 = OB.isValidVRIndex(tag.vrIndex);
        expect(ob3, true);
      }

      for (var tag in obTags1) {
        system.throwOnError = false;
        expect(OB.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('OB isValidVR bad values', () {
      system.throwOnError = false;
      expect(OB.isValidVRIndex(kAEIndex), false);
      system.throwOnError = true;
      expect(() => OB.isValidVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OB.isValidVRIndex(tag.vrIndex), false);

        system.throwOnError = true;
        expect(() => OB.isValidVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('OB checkVR good values', () {
      system.throwOnError = false;
      expect(OB.checkVRIndex(kOBIndex), kOBIndex);

      for (var tag in obTags0) {
        system.throwOnError = false;
        expect(OB.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }

      for (var tag in obowTags) {
        final ob3 = OB.checkVRIndex(tag.vrIndex);
        expect(ob3, tag.vrIndex);
      }
    });
    test('OB checkVR bad values', () {
      system.throwOnError = false;
      expect(OB.checkVRIndex(kAEIndex), isNull);
      system.throwOnError = true;
      expect(() => OB.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OB.checkVRIndex(tag.vrIndex), isNull);

        system.throwOnError = true;
        expect(() => OB.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('OB isValidVRIndex good values', () {
      system.throwOnError = false;
      expect(OB.isValidVRIndex(kOBIndex), true);

      for (var tag in obTags0) {
        expect(OB.isValidVRIndex(tag.vrIndex), true);
      }

      for (var tag in obowTags) {
        final ob3 = OB.isValidVRIndex(tag.vrIndex);
        expect(ob3, true);
      }
    });

    test('OB isValidVRIndex bad values', () {
      system.throwOnError = false;
      expect(OB.isValidVRIndex(kCSIndex), false);

      system.throwOnError = true;
      expect(() => OB.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OB.isValidVRIndex(tag.vrIndex), false);

        system.throwOnError = true;
        expect(() => OB.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('OB isValidVRCode good values', () {
      system.throwOnError = false;
      expect(OB.isValidVRCode(kOBCode), true);
      for (var tag in obTags0) {
        expect(OB.isValidVRCode(tag.vrCode), true);
      }
    });

    test('OB isValidVRCode bad values', () {
      system.throwOnError = false;
      expect(OB.isValidVRCode(kAECode), false);

      system.throwOnError = true;
      expect(() => OB.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OB.isValidVRCode(tag.vrCode), false);

        system.throwOnError = true;
        expect(() => OB.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('OB isValidVFLength good values', () {
      expect(OB.isValidVFLength(OB.kMaxVFLength, kUndefinedLength), true);
      expect(OB.isValidVFLength(0), true);
    });

    test('OB isValidVFLength bad values', () {
      system.throwOnError = false;
      expect(OB.isValidVFLength(OB.kMaxVFLength + 1), false);
      expect(OB.isValidVFLength(-1), false);
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
      system.throwOnError = false;
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

      system.throwOnError = true;
      expect(() => OB.isValidValues(PTag.kICCProfile, uInt8MaxPlus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
      expect(() => OB.isValidValues(PTag.kICCProfile, uInt8MinMinus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('OB toUint8List', () {
      for (var i = 0; i < 10; i++) {
        final uInt8List0 = rng.uint8List(1, 1);
        expect(Uint8.fromList(uInt8List0), uInt8List0);
      }
      const uInt8Min = const [kUint8Min];
      const uInt8Max = const [kUint8Max];
      expect(Uint8.fromList(uInt8Min), uInt8Min);
      expect(Uint8.fromList(uInt8Max), uInt8Max);
    });

    test('Uint8Base.fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uInt8List0 = rng.uint8List(1, 1);
        final bytes = new Bytes.typedDataView(uInt8List0);
//        final bd = bytes.buffer.asUint8List();
        log
          ..debug('uInt8ListV1 : $bytes')
          ..debug('Uint8Base.fromBytes(bd) ; ${Uint8.fromBytes(bytes)}');
        expect(Uint8.fromBytes(bytes), equals(bytes));
      }
    });

    test('Uint8Base.ListToBytes', () {
      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final uInt8List0 = rng.uint8List(1, 1);
        final uInt8ListV1 = new Bytes.typedDataView(uInt8List0);
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

      system.throwOnError = true;
      expect(() => Uint8.toBytes(uInt16Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('Uint8Base ListToByteData good values', () {
      system.level = Level.info;
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final uInt8List0 = rng.uint8List(1, 1);
        final bd0 = uInt8List0.buffer.asByteData();
        final lBd0 = Uint8.toByteData(uInt8List0);
        log.debug('lBd0: ${lBd0.buffer.asUint8List()}, bd0: ${bd0.buffer
            .asUint8List()}');
        expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd0.buffer == bd0.buffer, true);

        final lBd1 = Uint8.toByteData(uInt8List0);
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
        system.throwOnError = false;
        final uInt8List0 = rng.uint8List(1, 1);
        final bd0 = uInt8List0.buffer.asByteData();
        final lBd1 = Uint8.toByteData(uInt8List0);
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

        final lBd4 = Uint8.toByteData(uInt8List0);
        log.debug('lBd4: ${lBd4.buffer.asUint8List()}, '
            'bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd4.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd4.buffer == bd0.buffer, true);
      }

      system.throwOnError = false;
      const uInt16Max = const <int>[kUint16Max];

      expect(Uint8.toByteData(uInt16Max), isNull);

      system.throwOnError = false;
      const uInt32Max = const <int>[kUint32Max];
      expect(Uint8.toByteData(uInt32Max), isNull);

      system.throwOnError = true;
      expect(() => Uint8.toByteData(uInt16Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('Uint8Base.fromBase64', () {
      for (var i = 0; i < 10; i++) {
        final uInt8List0 = rng.uint8List(0, i);
        final uInt8ListV1 = new Bytes.typedDataView(uInt8List0);
        final bd = uInt8ListV1.buffer.asUint8List();
        final base64 = cvt.base64.encode(bd);
        log.debug('OB.base64: "$base64"');

        final obList = Uint8.fromBase64(base64);
        log.debug('  OB.decode: $obList');
        expect(obList, equals(uInt8List0));
        expect(obList, equals(uInt8ListV1));
      }
    });

    test('Uint8Base.ListToBase64', () {
      for (var i = 0; i < 10; i++) {
        final uInt8List0 = rng.uint8List(0, i);
        final uInt8ListV1 = new Bytes.typedDataView(uInt8List0);
        final bd = uInt8ListV1.buffer.asUint8List();
        final s = cvt.base64.encode(bd);
        expect(Uint8.toBase64(uInt8List0), equals(s));
      }
    });

    test('OB encodeDecodeJsonVF', () {
      system.level = Level.info;
      for (var i = 1; i < 10; i++) {
        final uInt8List0 = rng.uint8List(0, i);
        final uInt8ListV1 = new Bytes.typedDataView(uInt8List0);
        final bd = uInt8ListV1.buffer.asUint8List();

        // Encode
        final base64 = cvt.base64.encode(bd);
        log.debug('OB.base64: "$base64"');
        final s = Uint8.toBase64(uInt8List0);
        log.debug('  OB.json: "$s"');
        expect(s, equals(base64));

        // Decode
        final ob0 = Uint8.fromBase64(base64);
        log.debug('OB.base64: $ob0');
        final ob1 = Uint8.fromBase64(s);
        log.debug('  OB.json: $ob1');
        expect(ob0, equals(uInt8List0));
        expect(ob0, equals(uInt8ListV1));
        expect(ob0, equals(ob1));
      }
    });

    test('Uint8Base.fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uInt8List0 = rng.uint8List(1, 1);
        final bytes = new Bytes.typedDataView(uInt8List0);
//        final bd = uInt8ListV1.buffer.asUint8List();
        log
          ..debug('uInt8ListV1 : $bytes')
          ..debug('Uint8Base.fromBytes(bd) ; ${Uint8.fromBytes(bytes)}');
        expect(Uint8.fromBytes(bytes), equals(uInt8List0));
      }
    });

    test('Uint8Base.fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final uInt8List0 = rng.uint8List(1, 1);
        final uInt8ListV1 = new Bytes.typedDataView(uInt8List0);
        final byteData = uInt8ListV1.buffer.asByteData();
        log
          ..debug('uInt8List0 : $uInt8List0')
          ..debug('Uint8Base.fromByteData(byteData): '
              '${Uint8.fromByteData(byteData)}');
        expect(Uint8.fromByteData(byteData), equals(uInt8List0));
      }
    });
  });
}
