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
        final ss0 = new SStag(PTag.kTagAngleSecondAxis, vList);
        log.debug('ss0: $ss0');
        expect(ss0.hasValidValues, true);

        log
          ..debug('ss0: $ss0, values: ${ss0.values}')
          ..debug('ss0: $ss0');
        expect(ss0[0], equals(vList[0]));
      }

      for (var i = 0; i < 10; i++) {
        final int16list1 = rng.int16List(2, 2);
        final ss0 = new SStag(
            PTag.kCenterOfCircularExposureControlSensingRegion, int16list1);
        expect(ss0.hasValidValues, true);

        log
          ..debug('ss0: $ss0, values: ${ss0.values}')
          ..debug('ss0: $ss0');
        expect(ss0[0], equals(int16list1[0]));
      }
    });

    test('SS hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        final int16List2 = rng.int16List(3, 4);
        log.debug('$i: int16List2: $int16List2');
        final ss0 = new SStag(PTag.kTagAngleSecondAxis, int16List2);
        expect(ss0, isNull);
      }
    });

    test('SS hasValidValues good values', () {
      global.throwOnError = false;
      final ss0 = new SStag(PTag.kTagAngleSecondAxis, int16Min);
      final ss1 = new SStag(PTag.kTIDOffset, int16Min);
      expect(ss0.hasValidValues, true);
      expect(ss1.hasValidValues, true);

      final ss2 = new SStag(PTag.kTagAngleSecondAxis, int16Max);
      final ss3 = new SStag(PTag.kTIDOffset, int16Max);
      expect(ss2.hasValidValues, true);
      expect(ss3.hasValidValues, true);

      global.throwOnError = false;
      final ss4 = new SStag(PTag.kSelectorSSValue, []);
      expect(ss4.hasValidValues, true);
      expect(ss4.values, equals(<int>[]));
    });

    test('SS hasvalidValues bad values', () {
      final ss0 = new SStag(PTag.kTagAngleSecondAxis, int16MaxPlus);
      expect(ss0, isNull);

      final ss1 = new SStag(PTag.kTagAngleSecondAxis, int16MinMinus);
      expect(ss1, isNull);

      final ss2 = new SStag(PTag.kTagAngleSecondAxis, int16VMinMax);
      expect(ss2, isNull);

      final ss3 = new SStag(PTag.kTagAngleSecondAxis, [rng.nextInt32]);
      expect(ss3, isNull);

      global.throwOnError = false;
      final ss4 = new SStag(PTag.kOCTZOffsetCorrection, int16Min);
      final int32List0 = rng.int32List(1, 1);
      ss4.values = int32List0;
      expect(ss4.hasValidValues, false);

      global.throwOnError = true;
      expect(() => ss4.hasValidValues,
          throwsA(const isInstanceOf<InvalidValuesError>()));

      global.throwOnError = false;
      final ss5 = new SStag(PTag.kSelectorSSValue, null);
      log.debug('ss5: $ss5');
      expect(ss5, isNull);

      global.throwOnError = true;
      expect(() => new SStag(PTag.kSelectorSSValue, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('SS update random', () {
      for (var i = 0; i < 10; i++) {
        final int16List = rng.int16List(3, 4);
        final ss1 = new SStag(PTag.kSelectorSSValue, int16List);
        final int16List1 = rng.int16List(3, 4);
        expect(ss1.update(int16List1).values, equals(int16List1));
      }
    });

    test('SS update', () {
      final ss0 = new SStag(PTag.kSelectorSSValue, []);
      expect(ss0.update([20154, 25410]).values, equals([20154, 25410]));

      final ss1 = new SStag(PTag.kTagAngleSecondAxis, int16Min);
      final ss2 = new SStag(PTag.kTagAngleSecondAxis, int16Min);
      final ss3 = ss1.update(int16Max);
      final ss4 = ss2.update(int16Max);
      expect(ss1.values.first == ss3.values.first, false);
      expect(ss1 == ss3, false);
      expect(ss2 == ss3, false);
      expect(ss3 == ss4, true);
    });

    test('SS noValues random', () {
      for (var i = 0; i < 10; i++) {
        final int16List = rng.int16List(3, 4);
        final ss1 = new SStag(PTag.kSelectorSSValue, int16List);
        log.debug('ss1: ${ss1.noValues}');
        expect(ss1.noValues.values.isEmpty, true);
      }
    });

    test('SS noValues', () {
      final ss0 = new SStag(PTag.kSelectorSSValue, []);
      final SStag ssNoValues = ss0.noValues;
      expect(ssNoValues.values.isEmpty, true);
      log.debug('ss0: ${ss0.noValues}');

      final ss1 = new SStag(PTag.kTagAngleSecondAxis, int16Min);
      final ssNoValues0 = ss1.noValues;
      expect(ssNoValues0.values.isEmpty, true);
      log.debug('ss1:${ss1.noValues}');
    });

    test('SS copy random', () {
      for (var i = 0; i < 10; i++) {
        final int16List = rng.int16List(3, 4);
        final ss2 = new SStag(PTag.kSelectorSSValue, int16List);
        final SStag ss3 = ss2.copy;
        expect(ss3 == ss2, true);
        expect(ss3.hashCode == ss2.hashCode, true);
      }
    });

    test('SS copy', () {
      final ss0 = new SStag(PTag.kSelectorSSValue, []);
      final SStag ss1 = ss0.copy;
      expect(ss1 == ss0, true);
      expect(ss1.hashCode == ss0.hashCode, true);

      final ss3 = new SStag(PTag.kTagAngleSecondAxis, int16Min);
      final ss4 = ss3.copy;
      expect(ss3 == ss4, true);
      expect(ss3.hashCode == ss4.hashCode, true);
    });

    test('SS hashCode and == good values random', () {
      global.throwOnError = true;
      final rng = new RNG(1);
      List<int> int16list0;

      for (var i = 0; i < 10; i++) {
        int16list0 = rng.int16List(1, 1);
        final ss0 = new SStag(PTag.kTIDOffset, int16list0);
        final ss1 = new SStag(PTag.kTIDOffset, int16list0);
        log
          ..debug('int16list0:$int16list0, ss0.hash_code:${ss0.hashCode}')
          ..debug('int16list0:$int16list0, ss1.hash_code:${ss1.hashCode}');
        expect(ss0.hashCode == ss1.hashCode, true);
        expect(ss0 == ss1, true);
      }
    });

    test('SS hasCode and == bad values random', () {
      List<int> int16list0;
      List<int> int16list1;
      List<int> int16list2;
      List<int> int16list3;
      List<int> int16list4;

      for (var i = 0; i < 10; i++) {
        int16list0 = rng.int16List(1, 1);
        int16list1 = rng.int16List(1, 1);

        final ss0 = new SStag(PTag.kTIDOffset, int16list0);
        final ss2 = new SStag(PTag.kSelectorSSValue, int16list1);
        log.debug('int16list1:$int16list1 , ss2.hash_code:${ss2.hashCode}');
        expect(ss0.hashCode == ss2.hashCode, false);
        expect(ss0 == ss2, false);

        int16list2 = rng.int16List(2, 2);
        final ss3 = new SStag(PTag.kSelectorSSValue, int16list2);
        log.debug('int16list2:$int16list2 , ss3.hash_code:${ss3.hashCode}');
        expect(ss0.hashCode == ss3.hashCode, false);
        expect(ss0 == ss3, false);

        int16list3 = rng.int16List(1, 8);
        final ss4 = new SStag(PTag.kSelectorSSValue, int16list3);
        log.debug('int16list3:$int16list3 , ss4.hash_code:${ss4.hashCode}');
        expect(ss0.hashCode == ss4.hashCode, false);
        expect(ss0 == ss4, false);

        int16list4 = rng.int16List(2, 3);
        final ss5 = new SStag(PTag.kSelectorSSValue, int16list4);
        log.debug('int16list4:$int16list4 , ss5.hash_code:${ss5.hashCode}');
        expect(ss0.hashCode == ss5.hashCode, false);
        expect(ss0 == ss5, false);
      }
    });

    test('SS hashCode and == good values values ', () {
      final ss0 = new SStag(PTag.kTIDOffset, int16Min);
      final ss1 = new SStag(PTag.kTIDOffset, int16Min);
      log
        ..debug('int16Min:$int16Min, ss0.hash_code:${ss0.hashCode}')
        ..debug('int16Min:$int16Min, ss1.hash_code:${ss1.hashCode}');
      expect(ss0.hashCode == ss1.hashCode, true);
      expect(ss0 == ss1, true);
    });

    test('SS hashCode and == bad values values ', () {
      final ss0 = new SStag(PTag.kTIDOffset, int16Min);
      final ss2 = new SStag(PTag.kOCTZOffsetCorrection, int16Max);
      log.debug('int16Max:$int16Max , ss2.hash_code:${ss2.hashCode}');
      expect(ss0.hashCode == ss2.hashCode, false);
      expect(ss0 == ss2, false);
    });

    test('SS fromBytes good values random', () {
      for (var i = 0; i < 10; i++) {
        final intList0 = rng.int16List(1, 1);
        final bytes0 = new Bytes.typedDataView(intList0);
        log.debug('bytes0: $bytes0');
        //       final uInt8List1 = vList.buffer.asUint8List();
        final ss0 = SStag.fromBytes(PTag.kTagAngleSecondAxis, bytes0);
        log.debug('ss0: $ss0');
        expect(ss0.hasValidValues, true);
        expect(ss0.vfBytes, equals(bytes0));
        expect(ss0.values is Int16List, true);
        expect(ss0.values, equals(intList0));
      }
    });

    test('SS fromBytes bad values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rng.int16List(2, 2);
        final bytes0 = Int16.toBytes(vList);
        final ss1 = SStag.fromBytes(PTag.kTagAngleSecondAxis, bytes0);
       expect(ss1, isNull);
      }
    });

    test('SS fromUint8List good values ', () {
      final int16List1 = new Int16List.fromList(int16Min);
      final bytes1 = new Bytes.typedDataView(int16List1);
      final ss0 = SStag.fromBytes(PTag.kTagAngleSecondAxis, bytes1);
      expect(ss0.hasValidValues, true);
      expect(ss0.vfBytes, equals(bytes1.asUint8List()));
      expect(ss0.values is Int16List, true);
      expect(ss0.values, equals(int16List1));
    });

    test('SS fromUint8List bad values ', () {
      final int16List2 = new Int16List.fromList([rng.nextInt32]);
    //  final uInt8List2 = int16List2.buffer.asUint8List();
      final bytes2 = new Bytes.typedDataView(int16List2);
      log.debug('int16List2 : $int16List2, bytes2: $bytes2');
      final ss7 = SStag.fromBytes(PTag.kTagAngleSecondAxis, bytes2);
      expect(ss7.hasValidValues, true);
    });

    test('SS fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final intList0 = rng.int16List(1, 10);
    //    final bytes0 = DicomBytes.toAscii(intList0.toString());
        final bytes0 = new Bytes.typedDataView(intList0);
        final ss0 = SStag.fromBytes(PTag.kSelectorSSValue, bytes0);
        log.debug('ss0: $ss0');
        expect(ss0.hasValidValues, true);
      }
    });

    test('SS fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;

        final vList = rng.int16List(1, 10);
        // Urgent Sharath: why was this converting to String first?
        // DicomBytes.toAscii does padding
        // final bytes0 = DicomBytes.toAscii(intList0.toString());
        final bytes0 = new Bytes.typedDataView(vList);
        final ss0 = SStag.fromBytes(PTag.kSelectorFDValue, bytes0);
        expect(ss0, isNull);

        global.throwOnError = true;
        expect(() => SStag.fromBytes(PTag.kSelectorFDValue, bytes0),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });

    test('SS checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final int16List = rng.int16List(1, 10);
        final ss0 = new SStag(PTag.kSelectorSSValue, int16List);
        expect(ss0.checkLength(ss0.values), true);
      }
    });

    test('SS checkLength ', () {
      final ss0 = new SStag(PTag.kTagAngleSecondAxis, int16Min);
      expect(ss0.checkLength(ss0.values), true);
    });

    test('SS checkValues random', () {
      for (var i = 0; i < 10; i++) {
        final int16List = rng.int16List(1, 10);
        final ss0 = new SStag(PTag.kSelectorSSValue, int16List);
        expect(ss0.checkValues(ss0.values), true);
      }
    });

    test('SS checkValues', () {
      global.throwOnError = false;
      final ss0 = new SStag(PTag.kTagAngleSecondAxis, int16Min);
      expect(ss0.checkValues(ss0.values), true);

      final ss1 = new SStag(PTag.kTagAngleSecondAxis, [rng.nextInt32]);
      expect(ss1, isNull);
    });

    test('SS valuesCopy random', () {
      for (var i = 0; i < 10; i++) {
        final int16List = rng.int16List(1, 10);
        final ss0 = new SStag(PTag.kSelectorSSValue, int16List);
        expect(int16List, equals(ss0.valuesCopy));
      }
    });

    test('SS valuesCopy', () {
      final ss0 = new SStag(PTag.kTagAngleSecondAxis, int16Min);
      expect(int16Min, equals(ss0.valuesCopy));
    });

    test('SS replace random', () {
      for (var i = 0; i < 10; i++) {
        final int16list0 = rng.int16List(1, 1);
        final ss0 = new SStag(PTag.kSelectorSSValue, int16list0);
        final int16list1 = rng.int16List(1, 1);
        expect(ss0.replace(int16list1), equals(int16list0));
        expect(ss0.values, equals(int16list1));
      }

      final int16list1 = rng.int16List(1, 1);
      final ss1 = new SStag(PTag.kSelectorSSValue, int16list1);
      expect(ss1.replace([]), equals(int16list1));
      expect(ss1.values, equals(<int>[]));

      final ss2 = new SStag(PTag.kSelectorSSValue, int16list1);
      expect(ss2.replace(null), equals(int16list1));
      expect(ss2.values, equals(<int>[]));
    });

    test('SS BASE64 random', () {
      for (var i = 0; i < 10; i++) {
        final int16list0 = rng.int16List(1, 1);
     //   final int16List1 = new Int16List.fromList(int16list0);
        final bytes0 = new Bytes.typedDataView(int16list0);
        final base64 = bytes0.getBase64();
        final bytes1 = Bytes.fromBase64(base64);
        final ss0 = SStag.fromBytes(PTag.kTagAngleSecondAxis, bytes1);
        expect(ss0.hasValidValues, true);
      }
    });

    test('SS BASE64 ', () {
      final int16List1 = new Int16List.fromList(int16Min);
      final uInt8List1 = int16List1.buffer.asUint8List();
      final bytes0 = new Bytes.typedDataView(uInt8List1);

      final s = bytes0.getBase64();
   //  final bytes = cvt.base64.decode(base64);
      final bytes1 = Bytes.fromBase64(s);
      final ss0 = SStag.fromBytes(PTag.kTagAngleSecondAxis, bytes1);
      expect(ss0.hasValidValues, true);

      final int16List2 = new Int16List.fromList([rng.nextInt32]);
//      final int16List3 = int16List2.buffer.asUint8List();
      final bytes = new Bytes.typedDataView(int16List2);
      final base64 = bytes.getBase64();
      final bytes2 = Bytes.fromBase64(base64);
      final ss1 = SStag.fromBytes(PTag.kTagAngleSecondAxis, bytes2);
      expect(ss1.hasValidValues, true);
    });

    test('SS make good values', () {
      for (var i = 0; i < 10; i++) {
        final int16list0 = rng.int16List(1, 1);
        final make0 = SStag.fromValues(PTag.kTagAngleSecondAxis, int16list0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);

        final make1 = SStag.fromValues(PTag.kTagAngleSecondAxis, <int>[]);
        expect(make1.hasValidValues, true);
        expect(make1.values, equals(<int>[]));
      }
    });

    test('SS make bad values', () {
      for (var i = 0; i < 10; i++) {
        final int16list0 = rng.int16List(2, 2);
        global.throwOnError = false;
        final make0 = SStag.fromValues(PTag.kTagAngleSecondAxis, int16list0);
        expect(make0, isNull);

        global.throwOnError = true;
        expect(() => SStag.fromValues(PTag.kTagAngleSecondAxis, int16list0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('SS fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.int16List(1, 1);
    //    final int16List1 = new Int16List.fromList(int16list0);
    //    final uInt8List1 = int16List1.buffer.asUint8List();
        final bytes = Int16.toBytes(vList);
        final ss0 = SStag.fromBytes(PTag.kTagAngleSecondAxis, bytes);
        expect(ss0.hasValidValues, true);
        expect(ss0.vfBytes, equals(bytes));
        expect(ss0.values is Int16List, true);
        expect(ss0.values, equals(vList));
      }
    });

    test('SS fromB64', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.int16List(1, 1);
      //  final int16List1 = new Int16List.fromList(int16list0);
//        final uInt8List0 = vList.buffer.asUint8List();
        final bytes0 = new Bytes.typedDataView(vList);
        final base64 = bytes0.getBase64();
        final bytes1 = Bytes.fromBase64(base64);
        final ss0 = SStag.fromBytes(PTag.kTagAngleSecondAxis, bytes1);
        expect(ss0.hasValidValues, true);
      }
    });

    test('SS checkValue good values', () {
      final int16list0 = rng.int16List(1, 1);
      final ss0 = new SStag(PTag.kTagAngleSecondAxis, int16list0);

      expect(ss0.checkValue(int16Max[0]), true);
      expect(ss0.checkValue(int16Min[0]), true);
    });

    test('SS checkValue bad values', () {
      final int16list0 = rng.int16List(1, 1);
      final ss0 = new SStag(PTag.kTagAngleSecondAxis, int16list0);
      expect(ss0.checkValue(int16MaxPlus[0]), false);
      expect(ss0.checkValue(int16MinMinus[0]), false);
    });

    test('SS view', () {
      final int16list0 = rng.int16List(10, 10);
      final ss0 = new SStag(PTag.kSelectorSSValue, int16list0);
      for (var i = 0, j = 0; i < int16list0.length; i++, j += 2) {
        final ss1 = ss0.view(j, int16list0.length - i);
        log.debug(
            'ss0: ${ss0.values}, ss1: ${ss1.values}, int16list0.sublist(i) : '
            '${int16list0.sublist(i)}');
        expect(ss1.values, equals(int16list0.sublist(i)));
      }
    });
  });

  group('SS Element', () {
    //VM.k1
    const ssTags0 = const <PTag>[
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
    const ssTags1 = const <PTag>[
      PTag.kOverlayOrigin,
      PTag.kAbstractPriorValue,
      PTag.kVisualAcuityModifiers,
      PTag.kCenterOfCircularExposureControlSensingRegion
    ];

    //VM.k1_n
    const ssTags2 = const <PTag>[PTag.kSelectorSSValue];

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
        for (var tag in ssTags0) {
          expect(SS.isValidLength(tag, validMinVList), true);

          expect(
              SS.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              SS.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('SS isValidLength VM.k1 bad values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rng.int16List(2, i + 2);
        log.debug('SS.kMaxLength: ${SS.kMaxLength}');
        for (var tag in ssTags0) {
          global.throwOnError = false;
          expect(SS.isValidLength(tag, validMinVList), false);
          expect(SS.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => SS.isValidLength(tag, invalidVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
          expect(() => SS.isValidLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('SS isValidLength VM.k2 good values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rng.int16List(2, 2);
        global.throwOnError = false;
        log.debug('SS.kMaxLength: ${SS.kMaxLength}');
        for (var tag in ssTags1) {
          expect(SS.isValidLength(tag, validMinVList), true);

          expect(
              SS.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(
              SS.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('SS isValidLength VM.k2 bad values', () {
      for (var i = 2; i < 10; i++) {
        final validMinVList = rng.int16List(3, i + 1);
        for (var tag in ssTags1) {
          global.throwOnError = false;
          expect(SS.isValidLength(tag, validMinVList), false);
          expect(SS.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => SS.isValidLength(tag, invalidVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
          expect(() => SS.isValidLength(tag, validMinVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('SS isValidLength VM.k1_n good values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList = rng.int16List(1, i);
        for (var tag in ssTags2) {
          expect(SS.isValidLength(tag, validMinVList), true);
          expect(
              SS.isValidLength(
                  tag, invalidVList.sublist(0, SS.kMaxLength)),
              true);
        }
      }
    });

    test('SS isValidTag good values', () {
      global.throwOnError = false;
      expect(SS.isValidTag(PTag.kSelectorSSValue), true);
      expect(SS.isValidTag(PTag.kZeroVelocityPixelValue), true);
      expect(SS.isValidTag(PTag.kGrayLookupTableData), true);

      for (var tag in ssTags0) {
        expect(SS.isValidTag(tag), true);
      }
    });

    test('SS isValidTag bad values', () {
      global.throwOnError = false;
      expect(SS.isValidTag(PTag.kSelectorUSValue), false);

      global.throwOnError = true;
      expect(() => SS.isValidTag(PTag.kSelectorUSValue),
          throwsA(const isInstanceOf<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SS.isValidTag(tag), false);

        global.throwOnError = true;
        expect(() => SS.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });

    test('SS isNotValidTag good values', () {
      global.throwOnError = false;
      expect(SS.isValidTag(PTag.kSelectorSSValue), true);
      expect(SS.isValidTag(PTag.kZeroVelocityPixelValue), true);
      expect(SS.isValidTag(PTag.kGrayLookupTableData), true);

      for (var tag in ssTags0) {
        expect(SS.isValidTag(tag), true);
      }
    });

    test('SS isValidTag bad values', () {
      global.throwOnError = false;
      expect(SS.isValidTag(PTag.kSelectorUSValue), false);

      global.throwOnError = true;
      expect(() => !SS.isValidTag(PTag.kSelectorUSValue),
          throwsA(const isInstanceOf<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SS.isValidTag(tag), false);

        global.throwOnError = true;
        expect(() => SS.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });

    test('SS isValidVR good values', () {
      global.throwOnError = false;
      expect(SS.isValidVRIndex(kSSIndex), true);
      for (var tag in ssTags0) {
        global.throwOnError = false;
        expect(SS.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('SS isValidVR bad values', () {
      global.throwOnError = false;
      expect(SS.isValidVRIndex(kAEIndex), false);
      global.throwOnError = true;
      expect(() => SS.isValidVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SS.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => SS.isValidVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });
/*

    test('SS checkVRIndex good values', () {
      global.throwOnError = false;
      expect(SS.checkVRIndex(kSSIndex), kSSIndex);

      for (var tag in ssTags0) {
        global.throwOnError = false;
        expect(SS.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('SS checkVRIndex bad values', () {
      global.throwOnError = false;
      expect(SS.checkVRIndex(kAEIndex), isNull);
      global.throwOnError = true;
      expect(() => SS.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SS.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => SS.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });
*/

    test('SS isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(SS.isValidVRIndex(kSSIndex), true);

      for (var tag in ssTags0) {
        global.throwOnError = false;
        expect(SS.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('SS isValidVRIndex bad values', () {
      expect(SS.isValidVRIndex(kCSIndex), false);
      global.throwOnError = true;
      expect(() => SS.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));
      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SS.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => SS.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('SS isValidVRCode good values', () {
      global.throwOnError = false;
      expect(SS.isValidVRCode(kSSCode), true);
      for (var tag in ssTags0) {
        expect(SS.isValidVRCode(tag.vrCode), true);
      }
    });
    test('SS isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(SS.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => SS.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SS.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => SS.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('SS isValidVFLength good values', () {
      expect(SS.isValidVFLength(SS.kMaxVFLength), true);
      expect(SS.isValidVFLength(0), true);
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
          throwsA(const isInstanceOf<InvalidValuesError>()));
      expect(() => SS.isValidValues(PTag.kTagAngleSecondAxis, int16MinMinus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
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
          throwsA(const isInstanceOf<InvalidValuesError>()));
      expect(() => SS.isValidValues(PTag.kVisualAcuityModifiers, int16Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('Int16Base.fromList', () {
      for (var i = 0; i < 10; i++) {
        final int16list0 = rng.int16List(1, 1);
        expect(Int16.fromList(int16list0), int16list0);
      }
      const int16Min = const [kInt16Min];
      const int16Max = const [kInt16Max];
      expect(Int16.fromList(int16Max), int16Max);
      expect(Int16.fromList(int16Min), int16Min);
    });

    test('Int16Base.listFromBytes', () {
      for (var i = 0; i < 10; i++) {
        final int16list0 = rng.int16List(1, 1);
      //  final int16List1 = new Int16List.fromList(int16list0);
      //  final bd = int16List1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(int16list0);
        final int16List1 = bytes.asInt16List();
        log
          ..debug('int16list0 : $int16list0')
          ..debug('SS.fromBytes(bd) ; ${bytes.asInt16List()}');
        expect(int16List1, equals(int16list0));
      }
      /*const int16Max = const [kInt16Max];
      final int16List1 = new Int16List.fromList(int16Max);
      final bd = int16List1.buffer.asUint8List();
      expect(SS.fromBytes(bd), equals(int16Max));

      const int32Max = const [kInt32Max];
      final int16List2 = new Int16List.fromList(int32Max);
      final bd0 = int16List2.buffer.asUint8List();
      expect(SS.fromBytes(bd0), isNull);*/
    });

    test('SS toBytes', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final int16list0 = rng.int16List(1, 1);
        final int16List1 = new Int16List.fromList(int16list0);
        final bd = int16List1.buffer.asUint8List();
        log
          ..debug('int16list0 : $int16list0')
          ..debug('SS.toBytes(int16list0) ; ${Int16.toBytes(int16list0)}');
        expect(Int16.toBytes(int16list0), equals(bd));
      }

      const int16Max = const [kInt16Max];
      final int16List = new Int16List.fromList(int16Max);
      final uint8List = int16List.buffer.asUint8List();
      expect(Int16.toBytes(int16Max), uint8List);

      const int32Max = const [kInt32Max];
      expect(Int16.toBytes(int32Max), isNull);

      global.throwOnError = true;
      expect(() => Int16.toBytes(int32Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('Int16Base listToByteData good values', () {
      global.level = Level.info;
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final int16list0 = rng.int16List(1, 1);
        final bd0 = int16list0.buffer.asByteData();
        final lBd0 = Int16.toByteData(int16list0);
        log.debug('lBd0: ${lBd0.buffer.asUint8List()}, bd0: ${bd0.buffer
                .asUint8List()}');
        expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd0.buffer == bd0.buffer, true);

        final lBd1 = Int16.toByteData(int16list0, check: false);
        log.debug('lBd3: ${lBd1.buffer.asUint8List()}, '
            'bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd1.buffer == bd0.buffer, true);
      }

      const int16Max = const [kInt16Max];
      final int16List = new Int16List.fromList(int16Max);
      final bd1 = int16List.buffer.asByteData();
      final lBd2 = Int16.toByteData(int16List);
      log.debug('bd: ${bd1.buffer.asUint8List()}, '
          'lBd2: ${lBd2.buffer.asUint8List()}');
      expect(lBd2.buffer.asUint8List(), equals(bd1.buffer.asUint8List()));
      expect(lBd2.buffer == bd1.buffer, true);
    });

    test('Int16Base listToByteData bad values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final int16list0 = rng.int16List(1, 1);
        final bd0 = int16list0.buffer.asByteData();
        final lBd1 = Int16.toByteData(int16list0, asView: false);
        log.debug('lBd1: ${lBd1.buffer.asUint8List()}, '
            'bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd1.buffer == bd0.buffer, false);

        final int32list0 = rng.int32List(1, 1);
        assert(int32list0 is TypedData);
        //final int32List0 = new Int32List.fromList(int32list0);
        final bd1 = int32list0.buffer.asByteData();
        final lBd2 = Int16.toByteData(int32list0, check: false);
        log.debug('lBd0: ${lBd2.buffer.asUint8List()}, '
            'bd1: ${bd1.buffer.asUint8List()}');
        expect(lBd2.buffer.asUint8List(), isNot(bd0.buffer.asUint8List()));
        expect(lBd2.buffer == bd0.buffer, false);
        final lBd3 = Int16.toByteData(int32list0, asView: false);
        expect(lBd3, isNull);

        final lBd4 = Int16.toByteData(int16list0, asView: false, check: false);
        log.debug('lBd4: ${lBd4.buffer.asUint8List()}, '
            'bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd4.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd4.buffer == bd0.buffer, false);
      }

      const int32Max = const <int>[kInt32Max];
      expect(Int16.toByteData(int32Max), isNull);

      const int32Min = const [kInt32Min];
      expect(Int16.toByteData(int32Min), isNull);

      global.throwOnError = true;
      expect(() => Int16.toByteData(int32Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('SS decodeJsonVF', () {
      for (var i = 0; i < 10; i++) {
        final int16list0 = rng.int16List(0, i);
//        final int16List1 = new Int16List.fromList(int16list0);
//        final bd = int16List1.buffer.asUint8List();
//        final s = cvt.base64.encode(bd);
        final bytes = new Bytes.typedDataView(int16list0);
        final s = bytes.getBase64();
        log.debug('SS.base64: "$s"');

        final ssList = Int16.fromBase64(s);
        log.debug('  SS.decode: $ssList');
        expect(ssList, equals(int16list0));
//        expect(ssList, equals(int16List1));
      }
    });

    test('SS toBase64', () {
      for (var i = 0; i < 10; i++) {
        final int16list0 = rng.int16List(0, i);
//        final int16List1 = new Int16List.fromList(int16list0);
//        final bd = int16List1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(int16list0);
//        final s = cvt.base64.encode(bd);
        final s = bytes.getBase64();
        expect(Int16.toBase64(int16list0), equals(s));
      }
    });

    test('SS to/from Base64', () {
      global.level = Level.info;
      for (var i = 1; i < 10; i++) {
        final int16list0 = rng.int16List(0, i);
//        final int16List1 = new Int16List.fromList(int16list0);
//        final bd = int16List1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(int16list0);
        // Encode
//        final base64 = cvt.base64.encode(bd);
        final base64 = bytes.getBase64();
        log.debug('Int16Base.base64: "$base64"');
        final s = Int16.toBase64(int16list0);
        log.debug('  Int16Base.json: "$s"');
        expect(s, equals(base64));

        // Decode
        final ss0 = Int16.fromBase64(base64);
        log.debug('Int16Base.base64: $ss0');
        final ss1 = Int16.fromBase64(s);
        log.debug('  Int16Base.json: $ss1');
        expect(ss0, equals(int16list0));
//        expect(ss0, equals(int16List1));
        expect(ss0, equals(ss1));
      }
    });

    test('SS fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final int16list0 = rng.int16List(1, 1);
    //    final int16List1 = new Int16List.fromList(int16list0);
    //    final bd = int16List1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(int16list0);
        final int16List1 = bytes.asInt16List();
        log
          ..debug('int16list0: $int16list0')
          ..debug('     bytes: ; $int16List1');
        expect(int16List1, equals(int16list0));
      }
    });

    test('SS fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final int16list0 = rng.int16List(1, 1);
        final int16List1 = new Int16List.fromList(int16list0);
        final byteData = int16List1.buffer.asByteData();
        log
          ..debug('int16list0 : $int16list0')
          ..debug('Int16Base.fromByteData(byteData): '
              '${Int16.fromByteData(byteData)}');
        expect(Int16.fromByteData(byteData), equals(int16list0));
      }
    });

    test('Int16 fromValueField', () {
      for (var i = 1; i <= 10; i++) {
        final int16List0 = rng.int16List(1, i);
        final int16ListV1 = new Int16List.fromList(int16List0);
        final fvf0 = Int16.fromValueField(int16ListV1);
        log.debug('fromValueField0: $fvf0');
        expect(fvf0, equals(int16ListV1));
        expect(fvf0 is Int16List, true);
        expect(fvf0 is List<int>, true);
        expect(fvf0.isEmpty, false);
        expect(fvf0 is Bytes, false);
        expect(fvf0 is Uint8List, false);
      }

      final fvf1 = Int16.fromValueField(null);
      expect(fvf1, <Int16>[]);
      expect(fvf1 == kEmptyInt16List, true);
      expect(fvf1.isEmpty, true);
      expect(fvf1 is Int16List, true);

      final fvf2 = Int16.fromValueField(<int>[]);
      expect(fvf2, <Int16>[]);
      expect(fvf2.length == kEmptyIntList.length, true);
      expect(fvf2.isEmpty, true);

      final int16List0 = rng.int16List(1, 1);
      final int16ListV1 = new Int16List.fromList(int16List0);
      final byte0 = new Bytes.fromList(int16ListV1) ;
      final fvf3 = Int16.fromValueField(byte0);
      expect(fvf3, isNotNull);
      expect(fvf3 is Bytes, true);

      final uInt8list0 = int16ListV1.buffer.asUint8List();
      final fvf4 = Int16.fromValueField(uInt8list0);
      expect(fvf4, isNotNull);
      expect(fvf4 is Uint8List, true);

      global.throwOnError = false;
      final fvf5 = Int16.fromValueField(<String>['foo']);
      expect(fvf5, isNull);

      global.throwOnError = true;
      expect(() => Int16.fromValueField(<String>['foo']),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });
  });
}