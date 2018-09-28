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

void main() {
  Server.initialize(name: 'element/ob_test', level: Level.info);
  final rng = RNG(1);
  global.throwOnError = false;

  group('OB', () {
    const uInt8MinMax = [kUint8Min, kUint8Max];
    const uInt8Min = [kUint8Min];
    const uInt8Max = [kUint8Max];
    const uInt8MaxPlus = [kUint8Max + 1];
    const uInt8MinMinus = [kUint8Min - 1];

    test('OB hasValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        final e0 = OBtag(PTag.kPrivateInformation, vList0);
        final e1 = OBtag(PTag.kPrivateInformation, vList0);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.hasValidValues, true);
        expect(e1.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList1 = rng.uint8List(2, 3);
        log.debug('$i: vList1: $vList1');
        final e0 = OBtag(PTag.kCoordinateSystemAxisValues, vList1);
        expect(e0.hasValidValues, true);
      }
    });

    test('OB hasValidValues good values', () {
      global.throwOnError = false;
      final e0 = OBtag(PTag.kPrivateInformation, uInt8Min);
      final e1 = OBtag(PTag.kPrivateInformation, uInt8Min);
      expect(e0.hasValidValues, true);
      expect(e1.hasValidValues, true);

      final e2 = OBtag(PTag.kPrivateInformation, uInt8Max);
      final e3 = OBtag(PTag.kCoordinateSystemAxisValues, uInt8Max);
      expect(e2.hasValidValues, true);
      expect(e3.hasValidValues, true);

      global.throwOnError = false;
      final e4 = OBtag(PTag.kICCProfile, <int>[]);
      expect(e4.hasValidValues, true);
      log.debug('e0:$e0');
      expect(e4.values, equals(<int>[]));
    });

    test('OB hasValidValues bad values', () {
      final e0 = OBtag(PTag.kPrivateInformation, uInt8MaxPlus);
      expect(e0, isNull);

      final e2 = OBtag(PTag.kPrivateInformation, uInt8MinMinus);
      expect(e2, isNull);

      global.throwOnError = false;
      final e3 = OBtag(PTag.kPrivateInformation, uInt8Min);
      final uInt16List0 = rng.uint16List(1, 1);
      e3.values = uInt16List0;
      expect(e3.hasValidValues, false);

      global.throwOnError = true;
      expect(() => e3.hasValidValues,
          throwsA(const TypeMatcher<InvalidValuesError>()));

      global.throwOnError = false;
      final e4 = OBtag(PTag.kICCProfile, null);
      log.debug('e4: $e4');
      expect(e4.hasValidValues, true);
      expect(e4.values, kEmptyUint8List);

      global.throwOnError = true;
      final e5 = OBtag(PTag.kICCProfile, null);
      log.debug('e5: $e5');
      expect(e5.hasValidValues, true);
      expect(e5.values, kEmptyUint8List);
    });

    test('OB update random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rng.uint8List(3, 4);
        final e1 = OBtag(PTag.kPrivateInformation, vList1);
        final vList2 = rng.uint8List(3, 4);
        expect(e1.update(vList2).values, equals(vList2));
      }
    });

    test('OB update', () {
      final e0 = OBtag(PTag.kPrivateInformation, <int>[]);
      expect(e0.update([165, 254]).values, equals([165, 254]));

      final e1 = OBtag(PTag.kICCProfile, uInt8Min);
      final e2 = OBtag(PTag.kICCProfile, uInt8Min);
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
        final e1 = OBtag(PTag.kPrivateInformation, vList);
        log.debug('e1: ${e1.noValues}');
        expect(e1.noValues.values.isEmpty, true);
      }
    });

    test('OB noValues', () {
      final e0 = OBtag(PTag.kPrivateInformation, <int>[]);
      final OBtag obNoValues = e0.noValues;
      expect(obNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      final e1 = OBtag(PTag.kPrivateInformation, uInt8Min);
      final obNoValues0 = e1.noValues;
      expect(obNoValues0.values.isEmpty, true);
      log.debug('e1:${e1.noValues}');
    });

    test('OB copy random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.uint8List(3, 4);
        final e2 = OBtag(PTag.kPrivateInformation, vList);
        final OBtag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('OB copy', () {
      final e0 = OBtag(PTag.kPrivateInformation, <int>[]);
      final OBtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      final e2 = OBtag(PTag.kPrivateInformation, uInt8Min);
      final e3 = e2.copy;
      expect(e2 == e3, true);
      expect(e2.hashCode == e3.hashCode, true);
    });

    test('OB hashCode and == good values random', () {
      global.throwOnError = false;
      final rng = RNG(1);
      List<int> vList0;

      for (var i = 0; i < 10; i++) {
        vList0 = rng.uint8List(1, 1);
        final e0 = OBtag(PTag.kICCProfile, vList0);
        final e1 = OBtag(PTag.kICCProfile, vList0);
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

        final e0 = OBtag(PTag.kICCProfile, vList0);
        final e2 = OBtag(PTag.kPrivateInformation, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rng.uint8List(2, 3);
        final e3 = OBtag(PTag.kPrivateInformation, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);
      }
    });

    test('OB hashCode and == good values', () {
      final e0 = OBtag(PTag.kICCProfile, uInt8Min);
      final e1 = OBtag(PTag.kICCProfile, uInt8Min);
      log
        ..debug('uInt8Min:$uInt8Min, e0.hash_code:${e0.hashCode}')
        ..debug('uInt8Min:$uInt8Min, e1.hash_code:${e1.hashCode}');
      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);
    });

    test('OB hashCode and == bad values', () {
      final e0 = OBtag(PTag.kICCProfile, uInt8Min);
      final e2 = OBtag(PTag.kICCProfile, uInt8Max);
      log.debug('uInt8Max:$uInt8Max , e2.hash_code:${e2.hashCode}');
      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);
    });

    test('OB fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rng.uint8List(1, 1);
        final bytes0 = Bytes.typedDataView(vList0);
        //       final uInt8ListV11 = uInt8ListV1.buffer.asUint8List();
        final e0 = OBtag.fromBytes(PTag.kPrivateInformation, bytes0);
        expect(e0.hasValidValues, true);
        expect(e0.vfBytes, equals(bytes0));
        expect(e0.values is Uint8List, true);
        expect(e0.values, equals(vList0));

        final vList1 = rng.uint8List(2, 2);
        final bytes1 = Bytes.typedDataView(vList1);
//        final uInt8ListV12 = uInt8ListV2.buffer.asUint8List();
        final e2 = OBtag.fromBytes(PTag.kPrivateInformation, bytes1);
        expect(e2.hasValidValues, true);
      }
    });

    test('OB fromBytes', () {
      final bytes = Bytes.fromList(uInt8Min);
//      final uInt8ListV11 = uInt8ListV1.buffer.asUint8List();
      final e5 = OBtag.fromBytes(PTag.kPrivateInformation, bytes);
      expect(e5.vfBytes, equals(bytes));
      expect(e5.values is Uint8List, true);
      expect(e5.values, equals(uInt8Min));
    });

    test('OB fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.uint8List(1, 10);
        final bytes0 = DicomBytes.fromAscii(vList.toString());
        final e0 = OBtag.fromBytes(PTag.kSelectorOBValue, bytes0);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
      }
    });

    test('OB fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.uint8List(1, 10);
        final bytes0 = DicomBytes.fromAscii(vList.toString());
        final e0 = OBtag.fromBytes(PTag.kSelectorFDValue, bytes0);
        expect(e0, isNull);
        global.throwOnError = true;
        expect(() => OBtag.fromBytes(PTag.kSelectorFDValue, bytes0),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('OB checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        final e0 = OBtag(PTag.kPrivateInformation, vList0);
        expect(e0.checkLength(e0.values), true);
      }
    });

    test('OB checkLength', () {
      final e0 = OBtag(PTag.kPrivateInformation, uInt8MinMax);
      expect(e0.checkLength(e0.values), true);
    });

    test('OB checkValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        final e0 = OBtag(PTag.kPrivateInformation, vList0);
        expect(e0.checkValues(e0.values), true);
      }
    });

    test('OB checkValues', () {
      final e0 = OBtag(PTag.kPrivateInformation, uInt8Min);
      expect(e0.checkValues(e0.values), true);
    });

    test('OB valuesCopy random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        final e0 = OBtag(PTag.kPrivateInformation, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('OB valuesCopy', () {
      final e0 = OBtag(PTag.kPrivateInformation, uInt8Min);
      expect(uInt8Min, equals(e0.valuesCopy));
    });

    test('OB replace random', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        final e0 = OBtag(PTag.kPrivateInformation, vList0);
        final vList1 = rng.uint8List(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rng.uint8List(1, 1);
      final e1 = OBtag(PTag.kPrivateInformation, vList1);
      expect(e1.replace(<int>[]), equals(vList1));
      expect(e1.values, equals(<int>[]));

      final e2 = OBtag(PTag.kPrivateInformation, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(<int>[]));
    });

    test('OB BASE64 random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        final bytes0 = Bytes.typedDataView(vList0);
        final base64 = bytes0.getBase64();
        final bytes1 = Bytes.fromBase64(base64);
        final e0 = OBtag.fromBytes(PTag.kPrivateInformation, bytes1);
        expect(e0.hasValidValues, true);
      }
    });

    test('OB BASE64', () {
      final vList1 = Int16List.fromList(uInt8Min);
      final uInt8List1 = vList1.buffer.asUint8List();
      final bytes0 = Bytes.typedDataView(uInt8List1);

      final s = bytes0.getBase64();
      //  final bytes = cvt.base64.decode(base64);
      final bytes1 = Bytes.fromBase64(s);
      final e0 = OBtag.fromBytes(PTag.kPrivateInformation, bytes1);
      expect(e0.hasValidValues, true);
    });

    test('OB fromValues good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint8List(1, 1);
        final e0 = OBtag.fromValues(PTag.kPrivateInformation, vList0);
        expect(e0.hasValidValues, true);
      }
    });

    test('OB checkValue good values', () {
      final vList0 = rng.uint8List(1, 1);
      final e0 = OBtag(PTag.kPrivateInformation, vList0);
      expect(e0.checkValue(uInt8Max[0]), true);
      expect(e0.checkValue(uInt8Min[0]), true);
    });

    test('OB checkValue bad values', () {
      final vList0 = rng.uint8List(1, 1);
      final e0 = OBtag(PTag.kPrivateInformation, vList0);
      expect(e0.checkValue(uInt8MaxPlus[0]), false);
      expect(e0.checkValue(uInt8MinMinus[0]), false);
    });

    test('OB view', () {
      final vList0 = rng.uint8List(10, 10);
      final e0 = OBtag(PTag.kSelectorOBValue, vList0);
      for (var i = 0, j = 0; i < vList0.length; i++, j++) {
        final e1 = e0.view(j, vList0.length - i);
        log.debug('e0: ${e0.values}, e1: ${e1.values}, '
            'vList0.subList(i) : ${vList0.sublist(i)}');
        expect(e1.values, equals(vList0.sublist(i)));
      }
    });

    test('OB equal', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.uint8List(1, i);
        final bytesA =  Bytes.typedDataView(vList);
        final uInt8List0 = bytesA.buffer.asUint8List();
        final bytesB =  Bytes.typedDataView(vList);
        final uInt8List1 = bytesB.buffer.asUint8List();

        final vList0 = rng.uint8List(2, 2);
        final bytesC =  Bytes.typedDataView(vList0);
        final uInt8List2 = bytesC.buffer.asUint8List();

        final equal0 = Uint8.equal(uInt8List0, uInt8List1);
        expect(equal0, true);

        final equal1 = Uint8.equal(uInt8List1, uInt8List2);
        expect(equal1, false);
      }
    });

    test('OB check', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.uint8List(1, 1);
        final e0 = OBtag(PTag.kPrivateInformation, vList);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList[0]));
      }

      for (var i = 1; i < 10; i++) {
        final vList1 = rng.uint8List(1, i);
        final e0 = OBtag(PTag.kSelectorOBValue, vList1);
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);
        expect(e0[0], equals(vList1[0]));
      }
    });

    test('OB valuesEqual good values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.uint8List(1, i);
        final e0 = OBtag(PTag.kSelectorOBValue, vList);
        final e1 = OBtag(PTag.kSelectorOBValue, vList);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), true);
      }
    });

    test('OB valuesEqual bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint8List(1, i);
        final vList1 = rng.uint8List(1, 1);
        final e0 = OBtag(PTag.kSelectorOBValue, vList0);
        final e1 = OBtag(PTag.kSelectorOBValue, vList1);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), false);
      }
    });

  });

  group('OB Element', () {
    //VM.k1
    const obVM1Tags = <PTag>[
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
    const obVM1nTags = <PTag>[
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

    const otherTags = <PTag>[
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
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('OB isValidTag good values', () {
      global.throwOnError = false;
      expect(OB.isValidTag(PTag.kSelectorOBValue), true);
      expect(OB.isValidTag(PTag.kAudioSampleData), true);

      for (var tag in obVM1Tags) {
        expect(OB.isValidTag(tag), true);
      }

      for (var tag in obVM1nTags) {
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
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OB.isValidTag(tag), false);

        global.throwOnError = true;
        expect(() => OB.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('OB isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(OB.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => OB.isValidVRIndex(kCSIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OB.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => OB.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
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
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OB.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => OB.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('OB isValidVFLength good values', () {
      expect(OB.isValidVFLength(OB.kMaxVFLength), true);
      expect(OB.isValidVFLength(0), true);

      expect(OB.isValidVFLength(OB.kMaxVFLength, null, PTag.kSelectorOBValue),
          true);
    });

    test('OB isValidVFLength bad values', () {
      global.throwOnError = false;
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
      global.throwOnError = false;
      const uInt8MinMax = [kUint8Min, kUint8Max];
      const uInt8Min = [kUint8Min];
      const uInt8Max = [kUint8Max];

      //VM.k1
      expect(OB.isValidValues(PTag.kICCProfile, uInt8Min), true);
      expect(OB.isValidValues(PTag.kICCProfile, uInt8Max), true);

      //VM.k1_n
      expect(OB.isValidValues(PTag.kSelectorOBValue, uInt8Max), true);
      expect(OB.isValidValues(PTag.kSelectorOBValue, uInt8Max), true);
      expect(OB.isValidValues(PTag.kSelectorOBValue, uInt8MinMax), true);
    });

    test('OB isValidValues bad values', () {
      const uInt8MaxPlus = [kUint8Max + 1];
      const uInt8MinMinus = [kUint8Min - 1];

      //VM.k1
      expect(OB.isValidValues(PTag.kICCProfile, uInt8MaxPlus), false);
      expect(OB.isValidValues(PTag.kICCProfile, uInt8MinMinus), false);

      global.throwOnError = true;
      expect(() => OB.isValidValues(PTag.kICCProfile, uInt8MaxPlus),
          throwsA(const TypeMatcher<InvalidValuesError>()));

      global.throwOnError = false;
      expect(OB.isValidValues(PTag.kICCProfile, null), false);
    });

    test('OB isValidBytesArgs', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint8List(1, i);
        final vfBytes = Bytes.typedDataView(vList0);

        if (vList0.length == 1) {
          for (var tag in obVM1Tags) {
            final e0 = OB.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else {
          for (var tag in obVM1nTags) {
            final e0 = OB.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        }
      }
      final vList0 = rng.uint8List(1, 1);
      final vfBytes = Bytes.typedDataView(vList0);

      final e1 = OB.isValidBytesArgs(null, vfBytes);
      expect(e1, false);

      final e2 = OB.isValidBytesArgs(PTag.kDate, vfBytes);
      expect(e2, false);

      final e3 = OB.isValidBytesArgs(PTag.kSelectorOBValue, null);
      expect(e3, false);

      global.throwOnError = true;
      expect(() => OB.isValidBytesArgs(null, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => OB.isValidBytesArgs(PTag.kDate, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));
    });
  });
}
