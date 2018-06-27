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

// Urgent Sharath: if next line has been done delete this and next.
// Urgent Sharath: all integer test should be changed to match this.
void main() {
  Server.initialize(name: 'element/int16_test', level: Level.info);
  final rng = new RNG(1);
  global.throwOnError = false;

  group('SSTag', () {
    const int16VMinMax = const [kInt16Min, kInt16Max];
    const int16Min = const [kInt16Min];
    const int16MinMinus = const [kInt16Min - 1];
    const int16Max = const [kInt16Max];
    const int16MaxPlus = const [kInt16Max + 1];

    test('SS hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.int16List(1, 1);
        final e0 = new SStag(PTag.kTagAngleSecondAxis, vList);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList1 = rng.int16List(2, 2);
        final e0 = new SStag(
            PTag.kCenterOfCircularExposureControlSensingRegion, vList1);
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList1[0]));
      }
    });

    test('SS hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        final vList2 = rng.int16List(3, 4);
        log.debug('$i: vList2: $vList2');
        final e0 = new SStag(PTag.kTagAngleSecondAxis, vList2);
        expect(e0, isNull);
      }
    });

    test('SS hasValidValues good values', () {
      global.throwOnError = false;
      final e0 = new SStag(PTag.kTagAngleSecondAxis, int16Min);
      final e1 = new SStag(PTag.kTIDOffset, int16Min);
      expect(e0.hasValidValues, true);
      expect(e1.hasValidValues, true);

      final e2 = new SStag(PTag.kTagAngleSecondAxis, int16Max);
      final e3 = new SStag(PTag.kTIDOffset, int16Max);
      expect(e2.hasValidValues, true);
      expect(e3.hasValidValues, true);

      global.throwOnError = false;
      final e4 = new SStag(PTag.kSelectorSSValue, []);
      expect(e4.hasValidValues, true);
      expect(e4.values, equals(<int>[]));
    });

    test('SS hasvalidValues bad values', () {
      final e0 = new SStag(PTag.kTagAngleSecondAxis, int16MaxPlus);
      expect(e0, isNull);

      final e1 = new SStag(PTag.kTagAngleSecondAxis, int16MinMinus);
      expect(e1, isNull);

      final e2 = new SStag(PTag.kTagAngleSecondAxis, int16VMinMax);
      expect(e2, isNull);

      final e3 = new SStag(PTag.kTagAngleSecondAxis, [rng.nextInt32]);
      expect(e3, isNull);

      global.throwOnError = false;
      final e4 = new SStag(PTag.kOCTZOffsetCorrection, int16Min);
      final int32List0 = rng.int32List(1, 1);
      e4.values = int32List0;
      expect(e4.hasValidValues, false);

      global.throwOnError = true;
      expect(() => e4.hasValidValues,
          throwsA(const TypeMatcher<InvalidValuesError>()));

      global.throwOnError = false;
      final e5 = new SStag(PTag.kSelectorSSValue, null);
      log.debug('e5: $e5');
      expect(e5.hasValidValues, true);
      expect(e5.values, kEmptyUint16List);

      global.throwOnError = true;
      final e6 = new SStag(PTag.kSelectorSSValue, null);
      log.debug('e6: $e6');
      expect(e6.hasValidValues, true);
      expect(e6.values, kEmptyUint16List);
    });

    test('SS update random', () {
      for (var i = 0; i < 10; i++) {
        final int16List = rng.int16List(3, 4);
        final e1 = new SStag(PTag.kSelectorSSValue, int16List);
        final vList1 = rng.int16List(3, 4);
        expect(e1.update(vList1).values, equals(vList1));
      }
    });

    test('SS update', () {
      final e0 = new SStag(PTag.kSelectorSSValue, []);
      expect(e0.update([20154, 25410]).values, equals([20154, 25410]));

      final e1 = new SStag(PTag.kTagAngleSecondAxis, int16Min);
      final e2 = new SStag(PTag.kTagAngleSecondAxis, int16Min);
      final e3 = e1.update(int16Max);
      final e4 = e2.update(int16Max);
      expect(e1.values.first == e3.values.first, false);
      expect(e1 == e3, false);
      expect(e2 == e3, false);
      expect(e3 == e4, true);
    });

    test('SS noValues random', () {
      for (var i = 0; i < 10; i++) {
        final int16List = rng.int16List(3, 4);
        final e1 = new SStag(PTag.kSelectorSSValue, int16List);
        log.debug('e1: ${e1.noValues}');
        expect(e1.noValues.values.isEmpty, true);
      }
    });

    test('SS noValues', () {
      final e0 = new SStag(PTag.kSelectorSSValue, []);
      final SStag ssNoValues = e0.noValues;
      expect(ssNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      final e1 = new SStag(PTag.kTagAngleSecondAxis, int16Min);
      final ssNoValues0 = e1.noValues;
      expect(ssNoValues0.values.isEmpty, true);
      log.debug('e1:${e1.noValues}');
    });

    test('SS copy random', () {
      for (var i = 0; i < 10; i++) {
        final int16List = rng.int16List(3, 4);
        final e2 = new SStag(PTag.kSelectorSSValue, int16List);
        final SStag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('SS copy', () {
      final e0 = new SStag(PTag.kSelectorSSValue, []);
      final SStag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      final e3 = new SStag(PTag.kTagAngleSecondAxis, int16Min);
      final e4 = e3.copy;
      expect(e3 == e4, true);
      expect(e3.hashCode == e4.hashCode, true);
    });

    test('SS hashCode and == good values random', () {
      global.throwOnError = true;
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int16List(1, 1);
        final e0 = new SStag(PTag.kTIDOffset, vList0);
        final e1 = new SStag(PTag.kTIDOffset, vList0);
        log
          ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
          ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('SS hasCode and == bad values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int16List(1, 1);
        final vList1 = rng.int16List(1, 1);

        final e0 = new SStag(PTag.kTIDOffset, vList0);
        final e2 = new SStag(PTag.kSelectorSSValue, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rng.int16List(2, 2);
        final e3 = new SStag(PTag.kSelectorSSValue, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);

        final vList3 = rng.int16List(1, 8);
        final e4 = new SStag(PTag.kSelectorSSValue, vList3);
        log.debug('vList3:$vList3 , e4.hash_code:${e4.hashCode}');
        expect(e0.hashCode == e4.hashCode, false);
        expect(e0 == e4, false);

        final vList4 = rng.int16List(2, 3);
        final e5 = new SStag(PTag.kSelectorSSValue, vList4);
        log.debug('vList4:$vList4 , e5.hash_code:${e5.hashCode}');
        expect(e0.hashCode == e5.hashCode, false);
        expect(e0 == e5, false);
      }
    });

    test('SS hashCode and == good values values ', () {
      final e0 = new SStag(PTag.kTIDOffset, int16Min);
      final e1 = new SStag(PTag.kTIDOffset, int16Min);
      log
        ..debug('int16Min:$int16Min, e0.hash_code:${e0.hashCode}')
        ..debug('int16Min:$int16Min, e1.hash_code:${e1.hashCode}');
      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);
    });

    test('SS hashCode and == bad values values ', () {
      final e0 = new SStag(PTag.kTIDOffset, int16Min);
      final e2 = new SStag(PTag.kOCTZOffsetCorrection, int16Max);
      log.debug('int16Max:$int16Max , e2.hash_code:${e2.hashCode}');
      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);
    });

    test('SS fromBytes good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int16List(1, 1);
        final bytes0 = new Bytes.typedDataView(vList0);
        log.debug('bytes0: $bytes0');
        //       final uInt8List1 = vList.buffer.asUint8List();
        final e0 = SStag.fromBytes(PTag.kTagAngleSecondAxis, bytes0);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
        expect(e0.vfBytes, equals(bytes0));
        expect(e0.values is Int16List, true);
        expect(e0.values, equals(vList0));
      }
    });

    test('SS fromBytes bad values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rng.int16List(2, 2);
        final bytes0 = Int16.toBytes(vList);
        final e1 = SStag.fromBytes(PTag.kTagAngleSecondAxis, bytes0);
        expect(e1, isNull);
      }
    });

    test('SS fromBytes good values ', () {
      final vList1 = new Int16List.fromList(int16Min);
      final bytes1 = new Bytes.typedDataView(vList1);
      final e0 = SStag.fromBytes(PTag.kTagAngleSecondAxis, bytes1);
      expect(e0.hasValidValues, true);
      expect(e0.vfBytes, equals(bytes1.asUint8List()));
      expect(e0.values is Int16List, true);
      expect(e0.values, equals(vList1));
    });

    test('SS fromBytes bad values ', () {
      final vList2 = new Int16List.fromList([rng.nextInt32]);
      //  final uInt8List2 = vList2.buffer.asUint8List();
      final bytes2 = new Bytes.typedDataView(vList2);
      log.debug('vList2 : $vList2, bytes2: $bytes2');
      final ss7 = SStag.fromBytes(PTag.kTagAngleSecondAxis, bytes2);
      expect(ss7.hasValidValues, true);
    });

    test('SS fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int16List(1, 10);
        //    final bytes0 = DicomBytes.toAscii(vList0.toString());
        final bytes0 = new Bytes.typedDataView(vList0);
        final e0 = SStag.fromBytes(PTag.kSelectorSSValue, bytes0);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
      }
    });

    test('SS fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;

        final vList = rng.int16List(1, 10);

        final bytes0 = new Bytes.typedDataView(vList);
        final e0 = SStag.fromBytes(PTag.kSelectorFDValue, bytes0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => SStag.fromBytes(PTag.kSelectorFDValue, bytes0),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('SS checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final int16List = rng.int16List(1, 10);
        final e0 = new SStag(PTag.kSelectorSSValue, int16List);
        expect(e0.checkLength(e0.values), true);
      }
    });

    test('SS checkLength ', () {
      final e0 = new SStag(PTag.kTagAngleSecondAxis, int16Min);
      expect(e0.checkLength(e0.values), true);
    });

    test('SS checkValues random', () {
      for (var i = 0; i < 10; i++) {
        final int16List = rng.int16List(1, 10);
        final e0 = new SStag(PTag.kSelectorSSValue, int16List);
        expect(e0.checkValues(e0.values), true);
      }
    });

    test('SS checkValues', () {
      global.throwOnError = false;
      final e0 = new SStag(PTag.kTagAngleSecondAxis, int16Min);
      expect(e0.checkValues(e0.values), true);

      final e1 = new SStag(PTag.kTagAngleSecondAxis, [rng.nextInt32]);
      expect(e1, isNull);
    });

    test('SS valuesCopy random', () {
      for (var i = 0; i < 10; i++) {
        final int16List = rng.int16List(1, 10);
        final e0 = new SStag(PTag.kSelectorSSValue, int16List);
        expect(int16List, equals(e0.valuesCopy));
      }
    });

    test('SS valuesCopy', () {
      final e0 = new SStag(PTag.kTagAngleSecondAxis, int16Min);
      expect(int16Min, equals(e0.valuesCopy));
    });

    test('SS replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int16List(1, 1);
        final e0 = new SStag(PTag.kSelectorSSValue, vList0);
        final vList1 = rng.int16List(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rng.int16List(1, 1);
      final e1 = new SStag(PTag.kSelectorSSValue, vList1);
      expect(e1.replace([]), equals(vList1));
      expect(e1.values, equals(<int>[]));

      final e2 = new SStag(PTag.kSelectorSSValue, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(<int>[]));
    });

    test('SS BASE64 random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int16List(1, 1);
        //   final vList1 = new Int16List.fromList(vList0);
        final bytes0 = new Bytes.typedDataView(vList0);
        final base64 = bytes0.getBase64();
        final bytes1 = Bytes.fromBase64(base64);
        final e0 = SStag.fromBytes(PTag.kTagAngleSecondAxis, bytes1);
        expect(e0.hasValidValues, true);
      }
    });

    test('SS BASE64 ', () {
      final vList1 = new Int16List.fromList(int16Min);
      final uInt8List1 = vList1.buffer.asUint8List();
      final bytes0 = new Bytes.typedDataView(uInt8List1);

      final s = bytes0.getBase64();
      //  final bytes = cvt.base64.decode(base64);
      final bytes1 = Bytes.fromBase64(s);
      final e0 = SStag.fromBytes(PTag.kTagAngleSecondAxis, bytes1);
      expect(e0.hasValidValues, true);

      final vList2 = new Int16List.fromList([rng.nextInt32]);
//      final vList3 = vList2.buffer.asUint8List();
      final bytes = new Bytes.typedDataView(vList2);
      final base64 = bytes.getBase64();
      final bytes2 = Bytes.fromBase64(base64);
      final e1 = SStag.fromBytes(PTag.kTagAngleSecondAxis, bytes2);
      expect(e1.hasValidValues, true);
    });

    test('SS fromValues good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int16List(1, 1);
        final make0 = SStag.fromValues(PTag.kTagAngleSecondAxis, vList0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);

        final make1 = SStag.fromValues(PTag.kTagAngleSecondAxis, <int>[]);
        expect(make1.hasValidValues, true);
        expect(make1.values, equals(<int>[]));
      }
    });

    test('SS fromValues bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int16List(2, 2);
        global.throwOnError = false;
        final make0 = SStag.fromValues(PTag.kTagAngleSecondAxis, vList0);
        expect(make0, isNull);

        global.throwOnError = true;
        expect(() => SStag.fromValues(PTag.kTagAngleSecondAxis, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('SS fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.int16List(1, 1);
        //    final vList1 = new Int16List.fromList(vList0);
        //    final uInt8List1 = vList1.buffer.asUint8List();
        final bytes = Int16.toBytes(vList);
        final e0 = SStag.fromBytes(PTag.kTagAngleSecondAxis, bytes);
        expect(e0.hasValidValues, true);
        expect(e0.vfBytes, equals(bytes));
        expect(e0.values is Int16List, true);
        expect(e0.values, equals(vList));
      }
    });

    test('SS fromB64', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.int16List(1, 1);
        //  final vList1 = new Int16List.fromList(vList0);
//        final uInt8List0 = vList.buffer.asUint8List();
        final bytes0 = new Bytes.typedDataView(vList);
        final base64 = bytes0.getBase64();
        final bytes1 = Bytes.fromBase64(base64);
        final e0 = SStag.fromBytes(PTag.kTagAngleSecondAxis, bytes1);
        expect(e0.hasValidValues, true);
      }
    });

    test('SS checkValue good values', () {
      final vList0 = rng.int16List(1, 1);
      final e0 = new SStag(PTag.kTagAngleSecondAxis, vList0);

      expect(e0.checkValue(int16Max[0]), true);
      expect(e0.checkValue(int16Min[0]), true);
    });

    test('SS checkValue bad values', () {
      final vList0 = rng.int16List(1, 1);
      final e0 = new SStag(PTag.kTagAngleSecondAxis, vList0);
      expect(e0.checkValue(int16MaxPlus[0]), false);
      expect(e0.checkValue(int16MinMinus[0]), false);
    });

    test('SS view', () {
      final vList0 = rng.int16List(10, 10);
      final e0 = new SStag(PTag.kSelectorSSValue, vList0);
      for (var i = 0, j = 0; i < vList0.length; i++, j += 2) {
        final e1 = e0.view(j, vList0.length - i);
        log.debug('e0: ${e0.values}, e1: ${e1.values}, vList0.sublist(i) : '
            '${vList0.sublist(i)}');
        expect(e1.values, equals(vList0.sublist(i)));
      }
    });
  });

  group('SS Element', () {
    //VM.k1
    const ssVM1Tags = const <PTag>[
      PTag.kTagAngleSecondAxis,
      PTag.kExposureControlSensingRegionLeftVerticalEdge,
      PTag.kExposureControlSensingRegionRightVerticalEdge,
      PTag.kExposureControlSensingRegionUpperHorizontalEdge,
      PTag.kExposureControlSensingRegionLowerHorizontalEdge,
      PTag.kPixelIntensityRelationshipSign,
      PTag.kTIDOffset,
      PTag.kOCTZOffsetCorrection,
    ];

    //VM.k2
    const ssVM2Tags = const <PTag>[
      PTag.kOverlayOrigin,
      PTag.kAbstractPriorValue,
      PTag.kVisualAcuityModifiers,
      PTag.kCenterOfCircularExposureControlSensingRegion
    ];

    //VM.k1_n
    const ssVM1_nTags = const <PTag>[PTag.kSelectorSSValue];

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

    final invalidVList = rng.int16List(SS.kMaxLength + 1, SS.kMaxLength + 1);

    test('SS isValidLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final validMinVList = rng.int16List(1, 1);
        log.debug('SS.kMaxLength: ${SS.kMaxLength}');
        for (var tag in ssVM1Tags) {
          expect(SS.isValidLength(tag, validMinVList), true);

          expect(SS.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(SS.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('SS isValidLength VM.k1 bad values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rng.int16List(2, i + 2);
        log.debug('SS.kMaxLength: ${SS.kMaxLength}');
        for (var tag in ssVM1Tags) {
          global.throwOnError = false;
          expect(SS.isValidLength(tag, validMinVList), false);
          expect(SS.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => SS.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
          expect(() => SS.isValidLength(tag, validMinVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
      global.throwOnError = false;
      expect(SS.isValidLength(PTag.kTIDOffset, null), isNull);

      global.throwOnError = true;
      expect(() => SS.isValidLength(PTag.kTIDOffset, null),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('SS isValidLength VM.k2 good values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rng.int16List(2, 2);
        global.throwOnError = false;
        log.debug('SS.kMaxLength: ${SS.kMaxLength}');
        for (var tag in ssVM2Tags) {
          expect(SS.isValidLength(tag, validMinVList), true);

          expect(SS.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(SS.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('SS isValidLength VM.k2 bad values', () {
      for (var i = 2; i < 10; i++) {
        final validMinVList = rng.int16List(3, i + 1);
        for (var tag in ssVM2Tags) {
          global.throwOnError = false;
          expect(SS.isValidLength(tag, validMinVList), false);
          expect(SS.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => SS.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
          expect(() => SS.isValidLength(tag, validMinVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('SS isValidLength VM.k1_n good values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rng.int16List(1, i);
        for (var tag in ssVM1_nTags) {
          expect(SS.isValidLength(tag, validMinVList), true);
          expect(SS.isValidLength(tag, invalidVList.sublist(0, SS.kMaxLength)),
              true);
        }
      }
    });

    test('SS isValidTag good values', () {
      global.throwOnError = false;
      expect(SS.isValidTag(PTag.kSelectorSSValue), true);
      expect(SS.isValidTag(PTag.kZeroVelocityPixelValue), true);
      expect(SS.isValidTag(PTag.kGrayLookupTableData), true);

      for (var tag in ssVM1Tags) {
        expect(SS.isValidTag(tag), true);
      }
    });

    test('SS isValidTag bad values', () {
      global.throwOnError = false;
      expect(SS.isValidTag(PTag.kSelectorUSValue), false);

      global.throwOnError = true;
      expect(() => SS.isValidTag(PTag.kSelectorUSValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SS.isValidTag(tag), false);

        global.throwOnError = true;
        expect(() => SS.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('SS isNotValidTag good values', () {
      global.throwOnError = false;
      expect(SS.isValidTag(PTag.kSelectorSSValue), true);
      expect(SS.isValidTag(PTag.kZeroVelocityPixelValue), true);
      expect(SS.isValidTag(PTag.kGrayLookupTableData), true);

      for (var tag in ssVM1Tags) {
        expect(SS.isValidTag(tag), true);
      }
    });

    test('SS isValidTag bad values', () {
      global.throwOnError = false;
      expect(SS.isValidTag(PTag.kSelectorUSValue), false);

      global.throwOnError = true;
      expect(() => !SS.isValidTag(PTag.kSelectorUSValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SS.isValidTag(tag), false);

        global.throwOnError = true;
        expect(() => SS.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('SS isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(SS.isValidVRIndex(kSSIndex), true);

      for (var tag in ssVM1Tags) {
        global.throwOnError = false;
        expect(SS.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('SS isValidVRIndex bad values', () {
      expect(SS.isValidVRIndex(kCSIndex), false);
      global.throwOnError = true;
      expect(() => SS.isValidVRIndex(kCSIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));
      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SS.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => SS.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('SS isValidVRCode good values', () {
      global.throwOnError = false;
      expect(SS.isValidVRCode(kSSCode), true);
      for (var tag in ssVM1Tags) {
        expect(SS.isValidVRCode(tag.vrCode), true);
      }
    });
    test('SS isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(SS.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => SS.isValidVRCode(kAECode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SS.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => SS.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('SS isValidVFLength good values', () {
      expect(SS.isValidVFLength(SS.kMaxVFLength), true);
      expect(SS.isValidVFLength(0), true);

      expect(SS.isValidVFLength(SS.kMaxVFLength, null, PTag.kSelectorSSValue),
          true);
    });

    test('SS isValidVFLength bad values', () {
      global.throwOnError = false;
      expect(SS.isValidVFLength(SS.kMaxVFLength + 1), false);
      expect(SS.isValidVFLength(-1), false);
    });

    test('SS isValidValue good values', () {
      expect(SS.isValidValue(SS.kMinValue), true);
      expect(SS.isValidValue(SS.kMaxValue), true);
    });

    test('SS isValidValue bad values', () {
      expect(SS.isValidValue(SS.kMinValue - 1), false);
      expect(SS.isValidValue(SS.kMaxValue + 1), false);
    });

    test('SS isValidValues good values', () {
      global.throwOnError = false;
      const int16MinMax = const [kInt16Min, kInt16Max];
      const int16Min = const [kInt16Min];
      const int16Max = const [kInt16Max];

      // VM.k1
      expect(SS.isValidValues(PTag.kTagAngleSecondAxis, int16Min), true);
      expect(SS.isValidValues(PTag.kTagAngleSecondAxis, int16Max), true);

      // VM.k2
      expect(SS.isValidValues(PTag.kVisualAcuityModifiers, int16MinMax), true);

      // VM.k1_n
      expect(SS.isValidValues(PTag.kSelectorSSValue, int16Min), true);
      expect(SS.isValidValues(PTag.kSelectorSSValue, int16Max), true);
      expect(SS.isValidValues(PTag.kSelectorSSValue, int16MinMax), true);
    });

    test('SS isValidValues bad values', () {
      global.throwOnError = false;
      const int16MaxPlus = const [kInt16Max + 1];
      const int16MinMinus = const [kInt16Min - 1];

      // VM.k1
      expect(SS.isValidValues(PTag.kTagAngleSecondAxis, int16MaxPlus), false);
      expect(SS.isValidValues(PTag.kTagAngleSecondAxis, int16MinMinus), false);

      // VM.k2
      expect(
          SS.isValidValues(PTag.kVisualAcuityModifiers, int16MaxPlus), false);

      global.throwOnError = true;
      expect(() => SS.isValidValues(PTag.kTagAngleSecondAxis, int16MaxPlus),
          throwsA(const TypeMatcher<InvalidValuesError>()));
      expect(() => SS.isValidValues(PTag.kTagAngleSecondAxis, int16MinMinus),
          throwsA(const TypeMatcher<InvalidValuesError>()));

      global.throwOnError = false;
      expect(SS.isValidValues(PTag.kTagAngleSecondAxis, null), false);
    });

    test('SS isValidValues bad values length', () {
      global.throwOnError = false;
      const int16MinMax = const [kInt16Min, kInt16Max];
      const int16MinMaxPlus = const [kInt16Min, kInt16Max, kInt8Min];
      const int16Min = const [kInt16Min];
      const int16Max = const [kInt16Max];

      // VM.k1
      expect(SS.isValidValues(PTag.kTagAngleSecondAxis, int16MinMax), false);

      // VM.k2
      expect(SS.isValidValues(PTag.kVisualAcuityModifiers, int16Min), false);
      expect(SS.isValidValues(PTag.kVisualAcuityModifiers, int16Max), false);
      expect(SS.isValidValues(PTag.kVisualAcuityModifiers, int16MinMaxPlus),
          false);

      global.throwOnError = true;
      expect(() => SS.isValidValues(PTag.kTagAngleSecondAxis, int16MinMax),
          throwsA(const TypeMatcher<InvalidValuesError>()));
      expect(() => SS.isValidValues(PTag.kVisualAcuityModifiers, int16Max),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('Int16Base listFromBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int16List(1, 1);
        //  final vList1 = new Int16List.fromList(vList0);
        //  final bd = vList1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(vList0);
        final vList1 = bytes.asInt16List();
        log
          ..debug('vList0 : $vList0')
          ..debug('SS.fromBytes(bd) ; ${bytes.asInt16List()}');
        expect(vList1, equals(vList0));
      }
      /*const int16Max = const [kInt16Max];
      final vList1 = new Int16List.fromList(int16Max);
      final bd = vList1.buffer.asUint8List();
      expect(SS.fromBytes(bd), equals(int16Max));

      const int32Max = const [kInt32Max];
      final vList2 = new Int16List.fromList(int32Max);
      final bd0 = vList2.buffer.asUint8List();
      expect(SS.fromBytes(bd0), isNull);*/
    });

    test('SS fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int16List(1, 1);
        //    final vList1 = new Int16List.fromList(vList0);
        //    final bd = vList1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(vList0);
        final vList1 = bytes.asInt16List();
        log..debug('vList0: $vList0')..debug('     bytes: ; $vList1');
        expect(vList1, equals(vList0));
      }
    });
  });
}
