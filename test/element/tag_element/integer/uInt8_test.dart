// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/uInt8_test', level: Level.info);
  final rng = new RNG(1);

  group('OB', () {
    const uInt8MinMax = const [kUint8Min, kUint8Max];
    const uInt8Min = const [kUint8Min];
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
          new OBtag(PTag.kPrivateInformation, uInt8Min, uInt8Min.length);
      final ob1 =
          new OBtag(PTag.kPrivateInformation, uInt8Min, uInt8Min.length);
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
      final ob3 = new OBtag(PTag.kPrivateInformation, uInt8Min);
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

      final ob1 = new OBtag(PTag.kICCProfile, uInt8Min, uInt8Min.length);
      final ob2 = new OBtag(PTag.kICCProfile, uInt8Min, uInt8Min.length);
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
          new OBtag(PTag.kPrivateInformation, uInt8Min, uInt8Min.length);
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
          new OBtag(PTag.kPrivateInformation, uInt8Min, uInt8Min.length);
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
      final ob0 = new OBtag(PTag.kICCProfile, uInt8Min, uInt8Min.length);
      final ob1 = new OBtag(PTag.kICCProfile, uInt8Min, uInt8Min.length);
      log
        ..debug('uInt8Min:$uInt8Min, ob0.hash_code:${ob0.hashCode}')
        ..debug('uInt8Min:$uInt8Min, ob1.hash_code:${ob1.hashCode}');
      expect(ob0.hashCode == ob1.hashCode, true);
      expect(ob0 == ob1, true);
    });

    test('OB hashCode and == bad values', () {
      final ob0 = new OBtag(PTag.kICCProfile, uInt8Min, uInt8Min.length);
      final ob2 = new OBtag(PTag.kICCProfile, uInt8Max, uInt8Max.length);
      log.debug('uInt8Max:$uInt8Max , ob2.hash_code:${ob2.hashCode}');
      expect(ob0.hashCode == ob2.hashCode, false);
      expect(ob0 == ob2, false);
    });

    test('OB fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final uInt8List0 = rng.uint8List(1, 1);
        final uInt8ListV1 = new Uint8List.fromList(uInt8List0);
        final uInt8ListV11 = uInt8ListV1.buffer.asUint8List();
        final ob0 =
            new OBtag.fromBytes(PTag.kPrivateInformation, uInt8ListV11, 10);
        expect(ob0.hasValidValues, true);
        expect(ob0.vfBytes, equals(uInt8ListV11));
        expect(ob0.values is Uint8List, true);
        expect(ob0.values, equals(uInt8ListV1));

        // Test Base64
        final base64 = BASE64.encode(uInt8List0);
        final ob1 = new OBtag.fromBase64(PTag.kPrivateInformation, base64, 10);
        expect(ob0 == ob1, true);
        expect(ob1.value, equals(ob0.value));

        final uInt8List1 = rng.uint8List(2, 2);
        final uInt8ListV2 = new Uint8List.fromList(uInt8List1);
        final uInt8ListV12 = uInt8ListV2.buffer.asUint8List();
        final ob2 =
            new OBtag.fromBytes(PTag.kPrivateInformation, uInt8ListV12, 10);
        expect(ob2.hasValidValues, true);
      }
    });

    test('OB fromBytes', () {
      final uInt8ListV1 = new Uint8List.fromList(uInt8Min);
      final uInt8ListV11 = uInt8ListV1.buffer.asUint8List();
      final ob5 =
          new OBtag.fromBytes(PTag.kPrivateInformation, uInt8ListV11, 10);
      expect(ob5.vfBytes, equals(uInt8ListV11));
      expect(ob5.values is Uint8List, true);
      expect(ob5.values, equals(uInt8ListV1));
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
          new OBtag(PTag.kPrivateInformation, uInt8Min, uInt8Min.length);
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
          new OBtag(PTag.kPrivateInformation, uInt8Min, uInt8Min.length);
      expect(uInt8Min, equals(ob0.valuesCopy));
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

    test('OB BASE64 random', () {
      for (var i = 0; i < 10; i++) {
        final uInt8list0 = rng.uint8List(1, 1);
        final uInt8ListV1 = new Uint8List.fromList(uInt8list0);
        final uInt8ListV11 = uInt8ListV1.buffer.asUint8List();
        final base64 = BASE64.encode(uInt8ListV11);
        final ob0 = new OBtag.fromBase64(PTag.kPrivateInformation, base64, 10);
        expect(ob0.hasValidValues, true);
      }
    });

    test('OB BASE64', () {
      final uInt8ListV1 = new Uint8List.fromList(uInt8Min);
      final uInt8ListV11 = uInt8ListV1.buffer.asUint8List();
      final base64 = BASE64.encode(uInt8ListV11);
      final ob0 = new OBtag.fromBase64(PTag.kPrivateInformation, base64, 10);
      expect(ob0.hasValidValues, true);
    });

    test('OB make', () {
      for (var i = 0; i < 10; i++) {
        final uInt8list0 = rng.uint8List(1, 1);
        final ob0 = OBtag.make(PTag.kPrivateInformation, uInt8list0);
        expect(ob0.hasValidValues, true);
      }
    });

    test('OB fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uInt8list0 = rng.uint8List(1, 1);
        final uInt8ListV1 = new Uint8List.fromList(uInt8list0);
        final uInt8ListV11 = uInt8ListV1.buffer.asUint8List();
        final ob0 = new OBtag.fromBytes(
            PTag.kPrivateInformation, uInt8ListV11, uInt8ListV1.lengthInBytes);
        expect(ob0.hasValidValues, true);
        expect(ob0.vfBytes, equals(uInt8ListV1));
        expect(ob0.values is Uint8List, true);
        expect(ob0.values, equals(uInt8ListV1));
      }
    });

    test('OB fromB64', () {
      for (var i = 0; i < 10; i++) {
        final uInt8list0 = rng.uint8List(1, 1);
        final uInt8ListV1 = new Uint8List.fromList(uInt8list0);
        final uInt8ListV11 = uInt8ListV1.buffer.asUint8List();
        final base64 = BASE64.encode(uInt8ListV11);
        final ob0 = OBtag.fromB64(PTag.kPrivateInformation, base64, 10);
        expect(ob0.hasValidValues, true);
      }
    });

    test('OB.checkValue good values', () {
      final uInt8list0 = rng.uint8List(1, 1);
      final ob0 = new OBtag(PTag.kPrivateInformation, uInt8list0);
      expect(ob0.checkValue(uInt8Max[0]), true);
      expect(ob0.checkValue(uInt8Min[0]), true);
    });

    test('OB.checkValue bad values', () {
      final uInt8list0 = rng.uint8List(1, 1);
      final ob0 = new OBtag(PTag.kPrivateInformation, uInt8list0);
      expect(ob0.checkValue(uInt8MaxPlus[0]), false);
      expect(ob0.checkValue(uInt8MinMinus[0]), false);
    });

    test('OB.view', () {
      final uInt8list0 = rng.uint8List(10, 10);
      final ob0 = new OBtag(PTag.kSelectorOBValue, uInt8list0);
      for (var i = 0, j = 0; i < uInt8list0.length; i++, j++) {
        final ob1 = ob0.view(j, uInt8list0.length - i);
        log.debug(
            'ob0: ${ob0.values}, ob1: ${ob1.values}, uInt8list0.sublist(i) : ${uInt8list0.sublist(i)}');
        expect(ob1.values, equals(uInt8list0.sublist(i)));
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

    test('OB.isValidVListLength', () {
      system.throwOnError = false;
      expect(OB.isValidVListLength(OB.kMaxLength), true);
      expect(OB.isValidVListLength(0), true);
    });

    test('OB.isValidVR good values', () {
      system.throwOnError = false;
      expect(OB.isValidVRIndex(kOBIndex), true);

      for (var tag in obTags0) {
        system.throwOnError = false;
        expect(OB.isValidVRIndex(tag.vrIndex), true);
      }

      for (var tag in obTags1) {
        system.throwOnError = false;
        expect(OB.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('OB.isValidVR bad values', () {
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

    test('OB.checkVR good values', () {
      system.throwOnError = false;
      expect(OB.checkVRIndex(kOBIndex), kOBIndex);

      for (var tag in obTags0) {
        system.throwOnError = false;
        expect(OB.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });
    test('OB.checkVR bad values', () {
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

    test('OB.isValidVRIndex good values', () {
      system.throwOnError = false;
      expect(OB.isValidVRIndex(kOBIndex), true);

      for (var tag in obTags0) {
        expect(OB.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('OB.isValidVRIndex bad values', () {
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

    test('OB.isValidVRCode good values', () {
      system.throwOnError = false;
      expect(OB.isValidVRCode(kOBCode), true);
      for (var tag in obTags0) {
        expect(OB.isValidVRCode(tag.vrCode), true);
      }
    });

    test('OB.isValidVRCode bad values', () {
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

    test('OB.isValidVFLength good values', () {
      expect(OB.isValidVFLength(OB.kMaxVFLength), true);
      expect(OB.isValidVFLength(0), true);
    });

    test('OB.isValidVFLength bad values', () {
      expect(OB.isValidVFLength(OB.kMaxVFLength + 1), false);
      expect(OB.isValidVFLength(-1), false);
    });

    test('OB.isValidValue good values', () {
      expect(OB.isValidValue(OB.kMinValue), true);
      expect(OB.isValidValue(OB.kMaxValue), true);
    });

    test('OB.isValidValue bad values', () {
      expect(OB.isValidValue(OB.kMinValue - 1), false);
      expect(OB.isValidValue(OB.kMaxValue + 1), false);
    });

    test('OB.isValidValues good values', () {
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

    test('OB.isValidValues bad values', () {
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

    test('OB.toUint8List', () {
      for (var i = 0; i < 10; i++) {
        final uInt8list0 = rng.uint8List(1, 1);
        expect(Uint8Base.toUint8List(uInt8list0), uInt8list0);
      }
      const uInt8Min = const [kUint8Min];
      const uInt8Max = const [kUint8Max];
      expect(Uint8Base.toUint8List(uInt8Min), uInt8Min);
      expect(Uint8Base.toUint8List(uInt8Max), uInt8Max);
    });

    test('Uint8Base.listFromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uInt8list0 = rng.uint8List(1, 1);
        final uInt8ListV1 = new Uint8List.fromList(uInt8list0);
        final bd = uInt8ListV1.buffer.asUint8List();
        log
          ..debug('uInt8ListV1 : $uInt8ListV1')
          ..debug(
              'Uint8Base.listFromBytes(bd) ; ${Uint8Base.listFromBytes(bd)}');
        expect(Uint8Base.listFromBytes(bd), equals(uInt8ListV1));
      }
    });

    test('Uint8Base.listToBytesBytes', () {
      system.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final uInt8list0 = rng.uint8List(1, 1);
        final uInt8ListV1 = new Uint8List.fromList(uInt8list0);
        final bd = uInt8ListV1.buffer.asUint8List();
        log
          ..debug('uInt8ListV1 : $uInt8ListV1')
          ..debug('Uint8Base.listToBytesBytes(int32ListV1) ; '
              '${Uint8Base.listToBytes(uInt8ListV1)}');
        expect(Uint8Base.listToBytes(uInt8ListV1), equals(bd));
      }

      const uInt8Max = const [kUint8Max];
      final uInt8ListV1 = new Uint8List.fromList(uInt8Max);
      final uint8List = uInt8ListV1.buffer.asUint8List();
      expect(Uint8Base.listToBytes(uInt8Max), uint8List);

      const uInt16Max = const [kUint16Max];
      expect(Uint8Base.listToBytes(uInt16Max), isNull);

      system.throwOnError = true;
      expect(() => Uint8Base.listToBytes(uInt16Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('Uint8Base.listFromBase64', () {
      for (var i = 0; i < 10; i++) {
        final uInt8list0 = rng.uint8List(0, i);
        final uInt8ListV1 = new Uint8List.fromList(uInt8list0);
        final bd = uInt8ListV1.buffer.asUint8List();
        final base64 = BASE64.encode(bd);
        log.debug('OB.base64: "$base64"');

        final obList = Uint8Base.listFromBase64(base64);
        log.debug('  OB.decode: $obList');
        expect(obList, equals(uInt8list0));
        expect(obList, equals(uInt8ListV1));
      }
    });

    test('Uint8Base.listToBase64', () {
      for (var i = 0; i < 10; i++) {
        final uInt8list0 = rng.uint8List(0, i);
        final uInt8ListV1 = new Uint8List.fromList(uInt8list0);
        final bd = uInt8ListV1.buffer.asUint8List();
        final s = BASE64.encode(bd);
        expect(Uint8Base.listToBase64(uInt8list0), equals(s));
      }
    });

    test('OB.encodeDecodeJsonVF', () {
      system.level = Level.info;
      for (var i = 1; i < 10; i++) {
        final uInt8list0 = rng.uint8List(0, i);
        final uInt8ListV1 = new Uint8List.fromList(uInt8list0);
        final bd = uInt8ListV1.buffer.asUint8List();

        // Encode
        final base64 = BASE64.encode(bd);
        log.debug('OB.base64: "$base64"');
        final s = Uint8Base.listToBase64(uInt8list0);
        log.debug('  OB.json: "$s"');
        expect(s, equals(base64));

        // Decode
        final ob0 = Uint8Base.listFromBase64(base64);
        log.debug('OB.base64: $ob0');
        final ob1 = Uint8Base.listFromBase64(s);
        log.debug('  OB.json: $ob1');
        expect(ob0, equals(uInt8list0));
        expect(ob0, equals(uInt8ListV1));
        expect(ob0, equals(ob1));
      }
    });

    test('Uint8Base.listFromBytes', () {
      for (var i = 0; i < 10; i++) {
        final uInt8list0 = rng.uint8List(1, 1);
        final uInt8ListV1 = new Uint8List.fromList(uInt8list0);
        final bd = uInt8ListV1.buffer.asUint8List();
        log
          ..debug('uInt8ListV1 : $uInt8ListV1')
          ..debug(
              'Uint8Base.listFromBytes(bd) ; ${Uint8Base.listFromBytes(bd)}');
        expect(Uint8Base.listFromBytes(bd), equals(uInt8ListV1));
      }
    });

    test('Uint8Base.listFromByteData', () {
      for (var i = 0; i < 10; i++) {
        final uInt8list0 = rng.uint8List(1, 1);
        final uInt8ListV1 = new Uint8List.fromList(uInt8list0);
        final byteData = uInt8ListV1.buffer.asByteData();
        log
          ..debug('uInt8list0 : $uInt8list0')
          ..debug(
              'Uint8Base.listFromByteData(byteData) ; ${Uint8Base.listFromByteData(byteData)}');
        expect(Uint8Base.listFromByteData(byteData), equals(uInt8list0));
      }
    });
  });
}
