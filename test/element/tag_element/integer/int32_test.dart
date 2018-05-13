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
  Server.initialize(name: 'element/int32_test', level: Level.debug);
  final rng = new RNG(1);

  group('SLTag', () {
    const int32VMinMax = const [kInt32Min, kInt32Max];
    const int32Max = const [kInt32Max];
    const int32MaxPlus = const [kInt32Max + 1];
    const int32Min = const [kInt32Min];
    const int32MinMinus = const [kInt32Min - 1];

    test('SL hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final int32List0 = rng.int32List(1, 1);
        final sl0 = new SLtag(PTag.kReferencePixelX0, int32List0);
        expect(sl0.hasValidValues, true);

        log
          ..debug('sl0: $sl0, values: ${sl0.values}')
          ..debug('sl0: ${sl0.info}');
        expect(sl0[0], equals(int32List0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final int32list1 = rng.int32List(2, 2);
        final sl0 = new SLtag(PTag.kDisplayedAreaTopLeftHandCorner, int32list1);
        expect(sl0.hasValidValues, true);

        log
          ..debug('sl0: $sl0, values: ${sl0.values}')
          ..debug('sl0: ${sl0.info}');
        expect(sl0[0], equals(int32list1[0]));
      }
    });

    test('SL hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        final int32List = rng.int32List(3, 4);
        log.debug('$i: int32List2: $int32List');
        final sl0 = new SLtag(PTag.kReferencePixelX0, int32List);
        expect(sl0, isNull);
      }
    });

    test('SL hasValidValues good values ', () {
      global.throwOnError = false;
      final sl0 = new SLtag(PTag.kReferencePixelX0, int32Max);
      final sl1 = new SLtag(PTag.kReferencePixelX0, int32Max);
      expect(sl0.hasValidValues, true);
      expect(sl1.hasValidValues, true);

      final sl2 = new SLtag(PTag.kReferencePixelX0, int32Max);
      expect(sl2.hasValidValues, true);

      global.throwOnError = false;
      final sl3 = new SLtag(PTag.kReferencePixelX0, []);
      expect(sl3.hasValidValues, true);
      expect(sl3.values, equals(<int>[]));
    });

    test('SL hasValidValues bad values ', () {
      final sl0 = new SLtag(PTag.kReferencePixelX0, int32MaxPlus);
      expect(sl0, isNull);

      final sl1 = new SLtag(PTag.kReferencePixelX0, int32MinMinus);
      expect(sl1, isNull);

      final sl2 = new SLtag(PTag.kReferencePixelX0, int32VMinMax);
      expect(sl2, isNull);

      final sl3 = new SLtag(PTag.kReferencePixelX0, int32Min);
      final int64List0 = rng.int64List(1, 1);
      sl3.values = int64List0;
      expect(sl3.hasValidValues, false);

      global.throwOnError = true;
      expect(() => sl3.hasValidValues,
          throwsA(const isInstanceOf<InvalidValuesError>()));

      global.throwOnError = false;
      final sl4 = new SLtag(PTag.kReferencePixelX0, null);
      log.debug('sl4: $sl4');
      expect(sl4, isNull);

      global.throwOnError = true;
      expect(() => new SLtag(PTag.kReferencePixelX0, null),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('SL update random', () {
      for (var i = 0; i < 10; i++) {
        final int32List = rng.int32List(3, 4);
        final sl1 = new SLtag(PTag.kSelectorSLValue, int32List);
        final int32List1 = rng.int32List(3, 4);
        expect(sl1.update(int32List1).values, equals(int32List1));
      }
    });

    test('SL update ', () {
      final sl0 = new SLtag(PTag.kReferencePixelX0, []);
      expect(sl0.update([76345748]).values, equals([76345748]));

      final sl1 = new SLtag(PTag.kReferencePixelX0, int32Min);
      final sl2 = new SLtag(PTag.kReferencePixelX0, int32Min);
      final sl3 = sl1.update(int32Max);
      final sl4 = sl2.update(int32Max);
      expect(sl1.values.first == sl4.values.first, false);
      expect(sl1 == sl4, false);
      expect(sl2 == sl3, false);
      expect(sl4 == sl4, true);
    });

    test('SL noValues random', () {
      for (var i = 0; i < 10; i++) {
        final int32List = rng.int32List(1, 1);
        final sl1 = new SLtag(PTag.kReferencePixelX0, int32List);
        log.debug('sl1: ${sl1.noValues}');
        expect(sl1.noValues.values.isEmpty, true);
      }
    });

    test('SL noValues ', () {
      final sl0 = new SLtag(PTag.kReferencePixelX0, []);
      final SLtag slNoValues = sl0.noValues;
      expect(slNoValues.values.isEmpty, true);
      log.debug('sl0: ${sl0.noValues}');

      final sl1 = new SLtag(PTag.kReferencePixelX0, int32Min);
      final slNoValues0 = sl1.noValues;
      expect(slNoValues0.values.isEmpty, true);
      log.debug('sl1:${sl1.noValues}');
    });

    test('SL copy random', () {
      for (var i = 0; i < 10; i++) {
        final int32List = rng.int32List(3, 4);
        final sl2 = new SLtag(PTag.kSelectorSLValue, int32List);
        final SLtag sl3 = sl2.copy;
        expect(sl3 == sl2, true);
        expect(sl3.hashCode == sl2.hashCode, true);
      }
    });

    test('SL copy ', () {
      final sl0 = new SLtag(PTag.kReferencePixelX0, []);
      final SLtag sl1 = sl0.copy;
      expect(sl1 == sl0, true);
      expect(sl1.hashCode == sl0.hashCode, true);

      final sl3 = new SLtag(PTag.kSelectorSLValue, int32VMinMax);
      final sl4 = sl3.copy;
      expect(sl3 == sl4, true);
      expect(sl3.hashCode == sl4.hashCode, true);
    });

    test('SL hashCode and == good values random', () {
      global.throwOnError = false;
      final rng = new RNG(1);
      List<int> int32list0;

      for (var i = 0; i < 10; i++) {
        int32list0 = rng.int32List(1, 1);
        final sl0 = new SLtag(PTag.kReferencePixelX0, int32list0);
        final sl1 = new SLtag(PTag.kReferencePixelX0, int32list0);
        log
          ..debug('int32list0:$int32list0, sl0.hash_code:${sl0.hashCode}')
          ..debug('int32list0:$int32list0, sl1.hash_code:${sl1.hashCode}');
        expect(sl0.hashCode == sl1.hashCode, true);
        expect(sl0 == sl1, true);
      }
    });

    test('SL hashCode and == bad values random', () {
      List<int> int32list0;
      List<int> int32list1;
      List<int> int32list2;
      List<int> int32list3;
      List<int> int32List4;
      List<int> int32List5;
      for (var i = 0; i < 10; i++) {
        int32list0 = rng.int32List(1, 1);
        int32list1 = rng.int32List(1, 1);
        final sl0 = new SLtag(PTag.kReferencePixelX0, int32list0);
        final sl2 = new SLtag(PTag.kReferencePixelY0, int32list1);
        log.debug('int32list1:$int32list1 , sl2.hash_code:${sl2.hashCode}');
        expect(sl0.hashCode == sl2.hashCode, false);
        expect(sl0 == sl2, false);

        int32list2 = rng.int32List(2, 2);
        final sl3 =
            new SLtag(PTag.kDisplayedAreaBottomRightHandCorner, int32list2);
        log.debug('int32list2:$int32list2 , sl3.hash_code:${sl3.hashCode}');
        expect(sl0.hashCode == sl3.hashCode, false);
        expect(sl0 == sl3, false);

        int32list3 = rng.int32List(2, 6);
        final sl4 = new SLtag(PTag.kPixelCoordinatesSetTrial, int32list3);
        log.debug('int32list3:$int32list3 , sl4.hash_code:${sl4.hashCode}');
        expect(sl0.hashCode == sl4.hashCode, false);
        expect(sl0 == sl4, false);

        int32List4 = rng.int32List(1, 8);
        final sl5 = new SLtag(PTag.kSelectorSLValue, int32List4);
        log.debug('int32List4:$int32List4 , sl5.hash_code:${sl5.hashCode}');
        expect(sl0.hashCode == sl5.hashCode, false);
        expect(sl0 == sl5, false);

        int32List5 = rng.int32List(2, 3);
        final sl6 = new SLtag(PTag.kReferencePixelX0, int32List5);
        log.debug('int32List5:$int32List5 , sl6.hash_code:${sl6.hashCode}');
        expect(sl0.hashCode == sl6.hashCode, false);
        expect(sl0 == sl6, false);
      }
    });

    test('SL hashCode and ==  good values', () {
      final sl0 = new SLtag(PTag.kReferencePixelX0, int32Min);
      final sl1 = new SLtag(PTag.kReferencePixelX0, int32Min);
      log
        ..debug('int32Min:$int32Min, sl0.hash_code:${sl0.hashCode}')
        ..debug('int32Min:$int32Min, sl1.hash_code:${sl1.hashCode}');
      expect(sl0.hashCode == sl1.hashCode, true);
      expect(sl0 == sl1, true);
    });

    test('SL hashCode and ==  bad values', () {
      final sl0 = new SLtag(PTag.kReferencePixelX0, int32Min);
      final sl2 = new SLtag(PTag.kReferencePixelY0, int32Max);
      log.debug('int32Max:$int32Max , sl2.hash_code:${sl2.hashCode}');
      expect(sl0.hashCode == sl2.hashCode, false);
      expect(sl0 == sl2, false);
    });

    test('SL fromUint8List good values random', () {
      for (var i = 0; i < 10; i++) {
        final int32List0 = rng.int32List(1, 1);
//        final int32ListV1 = new Int32List.fromList(int32list0);
//        final uInt8ListV1 = int32ListV1.buffer.asUint8List();
        final bytes = new Bytes.typedDataView(int32List0);
        final sl0 = SLtag.fromBytes(PTag.kReferencePixelX0, bytes);
        expect(sl0.hasValidValues, true);
        expect(sl0.values, equals(int32List0));
        expect(sl0.vfBytes, equals(bytes));
        expect(sl0.values is Int32List, true);
        expect(sl0.values, equals(int32List0));
      }
    });

    test('SL fromUint8List bad random values', () {
      for (var i = 0; i < 10; i++) {
        final int32List0 = rng.int32List(2, 10);
        final bytes = new Bytes.typedDataView(int32List0);
//        final uInt8ListV2 = int32ListV2.buffer.asUint8List();
        final sl1 = SLtag.fromBytes(PTag.kReferencePixelX0, bytes);
        expect(sl1, isNull);
      }
    });

    test('SL fromUint8List ', () {
      final int32ListV1 = new Int32List.fromList(int32Max);
 //     final uInt8ListV1 = int32ListV1.buffer.asUint8List();
      final bytes = new Bytes.typedDataView(int32ListV1);
      final sl0 = SLtag.fromBytes(PTag.kReferencePixelX0, bytes);
      expect(sl0.hasValidValues, true);
      expect(sl0.vfBytes, equals(bytes));
      expect(sl0.values is Int32List, true);
      expect(sl0.values, equals(int32ListV1));
    });

    test('SL fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final intList0 = rng.int32List(1, 10);
        // Urgent Sharath: what is this test trying to achieve? let's discuss
        //final bytes0 = Bytes.toAscii(intList0.toString());
        final bytes0 = new Bytes.typedDataView(intList0);
        log.debug('bytes0: $bytes0');
        final sl0 = SLtag.fromBytes(PTag.kSelectorSLValue, bytes0);
        log.debug('sl0: $sl0');
        expect(sl0.hasValidValues, true);

      }
    });
/*
    test('SL fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        system.throwOnError = false;
        final intList0 = rng.int32List(1, 10);

        // Urgent Sharath: what is this test trying to achieve? let's discuss
        final bytes0 = DicomBytes.toAscii(intList0.toString());
        final sl0 = SLtag.fromBytes(PTag.kSelectorFDValue, bytes0);
        expect(sl0, isNull);

        system.throwOnError = true;
        expect(() => SLtag.fromBytes(PTag.kSelectorFDValue, bytes0),
            throwsA(const isInstanceOf<InvalidVRError>()));


      }
    });
*/
    test('SL isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final int32List = rng.int32List(1, 10);
        final sl0 = new SLtag(PTag.kRationalNumeratorValue, int32List);
        expect(sl0.checkLength(sl0.values), true);
      }
    });

    test('SL isValidLength ', () {
      final sl0 = new SLtag(PTag.kRationalNumeratorValue, int32Min);
      expect(sl0.checkLength(sl0.values), true);
    });

    test('SL checkValues random', () {
      for (var i = 0; i < 10; i++) {
        final int32List = rng.int32List(1, 10);
        final sl0 = new SLtag(PTag.kRationalNumeratorValue, int32List);
        expect(sl0.checkValues(sl0.values), true);
      }
    });

    test('SL checkValues ', () {
      final sl0 = new SLtag(PTag.kRationalNumeratorValue, int32Min);
      expect(sl0.checkValues(sl0.values), true);
    });

    test('SL valuesCopy random', () {
      for (var i = 0; i < 10; i++) {
        final int32List = rng.int32List(1, 10);
        final sl0 = new SLtag(PTag.kRationalNumeratorValue, int32List);
        expect(int32List, equals(sl0.valuesCopy));
      }
    });

    test('SL vlauesCopy', () {
      final sl0 = new SLtag(PTag.kRationalNumeratorValue, int32Max);
      expect(int32Max, equals(sl0.valuesCopy));
    });

    test('SL replace random', () {
      for (var i = 0; i < 10; i++) {
        final int32List0 = rng.int32List(1, 10);
        final sl0 = new SLtag(PTag.kRationalNumeratorValue, int32List0);
        final int32List1 = rng.int32List(1, 10);
        expect(sl0.replace(int32List1), equals(int32List0));
        expect(sl0.values, equals(int32List1));
      }

      final int32List1 = rng.int32List(1, 10);
      final sl1 = new SLtag(PTag.kRationalNumeratorValue, int32List1);
      expect(sl1.replace(<int>[]), equals(int32List1));
      expect(sl1.values, equals(<int>[]));

      final sl2 = new SLtag(PTag.kRationalNumeratorValue, int32List1);
      expect(sl2.replace(null), equals(int32List1));
      expect(sl2.values, equals(<int>[]));
    });

    test('SL BASE64 random', () {
      for (var i = 0; i < 10; i++) {
        final int32list0 = rng.int32List(1, 1);
        final bytes0 = new Bytes.typedDataView(int32list0);
//        final uInt8ListV1 = int32ListV1.buffer.asUint8List();
//        final base64 = cvt.base64.encode(uInt8ListV1);
        final base64 = bytes0.getBase64();
        final bytes1 = Bytes.fromBase64(base64);
        final sl0 = SLtag.fromBytes(PTag.kRationalNumeratorValue, bytes1);
        expect(sl0.hasValidValues, true);
      }
    });

    test('SL BASE64 ', () {
      final int32list0 = new Int32List.fromList(int32Max);
      final bytes0 = new Bytes.typedDataView(int32list0);
 //     final uInt8ListV1 = int32ListV1.buffer.asUint8List();
//      final base64 = cvt.base64.encode(uInt8ListV1);
      final base64 = bytes0.getBase64();
      final bytes1 = Bytes.fromBase64(base64);
      final sl0 = SLtag.fromBytes(PTag.kRationalNumeratorValue, bytes1);
      expect(sl0.hasValidValues, true);
    });

    test('SL make good values', () {
      for (var i = 0; i < 10; i++) {
        final int32list0 = rng.int32List(1, 1);
        final make0 = SLtag.fromValues(PTag.kReferencePixelX0, int32list0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);

        final make1 = SLtag.fromValues(PTag.kReferencePixelX0, <int>[]);
        expect(make1.hasValidValues, true);
        expect(make1.values, equals(<int>[]));
      }
    });

    test('SL make bad values', () {
      for (var i = 0; i < 10; i++) {
        final int32list0 = rng.int32List(2, 2);
        global.throwOnError = false;
        final make0 = SLtag.fromValues(PTag.kReferencePixelX0, int32list0);
        expect(make0, isNull);

        global.throwOnError = true;
        expect(() => SLtag.fromValues(PTag.kReferencePixelX0, int32list0),
            throwsA(const isInstanceOf<InvalidValuesError>()));
      }
    });

    test('SL fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final int32list0 = rng.int32List(1, 1);
        final bytes = new Bytes.typedDataView(int32list0);
        // Urgent Sharath: Please remove after discussion
//        final uInt8ListV1 = int32ListV1.buffer.asUint8List();
        final sl0 = SLtag.fromBytes(PTag.kReferencePixelX0, bytes);
        expect(sl0.hasValidValues, true);
        expect(sl0.vfBytes, equals(bytes));
        expect(sl0.values is Int32List, true);
        expect(sl0.values, equals(int32list0));
      }
    });

    test('SL fromBase64', () {
      for (var i = 0; i < 10; i++) {
        final int32list0 = rng.int32List(1, 1);
        final bytes0 = new Bytes.typedDataView(int32list0);
//        final int32ListV1 = new Int32List.fromList(int32list0);
//        final uInt8ListV1 = int32ListV1.buffer.asUint8List();
//        final base64 = cvt.base64.encode(uInt8ListV1);
        final base64 = bytes0.getBase64();
        final bytes1 = Bytes.fromBase64(base64);

        final sl0 = SLtag.fromBytes(PTag.kReferencePixelX0, bytes1);
        expect(sl0.hasValidValues, true);
      }
    });

    test('SL checkValue good values', () {
      final int32list0 = rng.int32List(1, 1);
      final sl0 = new SLtag(PTag.kReferencePixelX0, int32list0);

      expect(sl0.checkValue(int32Max[0]), true);
      expect(sl0.checkValue(int32Min[0]), true);
    });

    test('SL checkValue bad values', () {
      final int32list0 = rng.int32List(1, 1);
      final sl0 = new SLtag(PTag.kReferencePixelX0, int32list0);
      expect(sl0.checkValue(int32MaxPlus[0]), false);
      expect(sl0.checkValue(int32MinMinus[0]), false);
    });

    test('SL view', () {
      final int32list0 = rng.int32List(10, 10);
      final sl0 = new SLtag(PTag.kSelectorSLValue, int32list0);
      for (var i = 0, j = 0; i < int32list0.length; i++, j += 4) {
        final sl1 = sl0.view(j, int32list0.length - i);
        log.debug('sl0: ${sl0.values}, sl1: ${sl1.values}, '
            'int32list0.sublist(i) : ${int32list0.sublist(i)}');
        expect(sl1.values, equals(int32list0.sublist(i)));
      }
    });
  });

  group('SL Element', () {
    //VM.k1
    const slTags0 = const <PTag>[
      PTag.kReferencePixelX0,
      PTag.kReferencePixelY0,
      PTag.kDopplerSampleVolumeXPosition,
      PTag.kDopplerSampleVolumeYPosition,
      PTag.kTMLinePositionX0,
      PTag.kTMLinePositionY0,
      PTag.kTMLinePositionX1,
      PTag.kTMLinePositionY1,
      PTag.kColumnPositionInTotalImagePixelMatrix,
      PTag.kRowPositionInTotalImagePixelMatrix,
    ];

    //VM.k2
    const slTags1 = const <PTag>[
      PTag.kDisplayedAreaTopLeftHandCorner,
      PTag.kDisplayedAreaBottomRightHandCorner,
    ];

    //VM.k1_n
    const slTag2 = const <PTag>[
      PTag.kRationalNumeratorValue,
      PTag.kSelectorSLValue,
    ];

    //VM.k2_2n
    const slTags3 = const <PTag>[PTag.kPixelCoordinatesSetTrial];

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

    final invalidVList = rng.int32List(SL.kMaxLength + 1, SL.kMaxLength + 1);

    test('SL isValidLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final validMinVList0 = rng.int32List(1, 1);
        final validMaxLengthList = invalidVList.sublist(0, SL.kMaxLength);

        for (var tag in slTags0) {
          log.debug('tag: $tag');
          expect(SL.isValidLength(tag, validMinVList0), true);

          expect(SL.isValidLength(tag, validMaxLengthList.take(tag.vmMax)),
              true);
          expect(SL.isValidLength(tag, validMaxLengthList.take(tag.vmMin)),
              true);
        }
      }
    });

    test('SL isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList0 = rng.int32List(2, i + 1);

        for (var tag in slTags0) {
          global.throwOnError = false;
          log.debug('tag: $tag');
          expect(SL.isValidLength(tag, validMinVList0), false);
          expect(SL.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => SL.isValidLength(tag, invalidVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
          expect(() => SL.isValidLength(tag, validMinVList0),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('SL isValidLength VM.k2 good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final validMinVList0 = rng.int32List(2, 2);
        final validMaxLengthList = invalidVList.sublist(0, SL.kMaxLength);

        for (var tag in slTags1) {
          log.debug('tag: $tag');
          expect(SL.isValidLength(tag, validMinVList0), true);

          expect(SL.isValidLength(tag, validMaxLengthList.take(tag.vmMax)),
              true);
          expect(SL.isValidLength(tag, validMaxLengthList.take(tag.vmMin)),
              true);
        }
      }
    });

    test('SL isValidLength VM.k2 bad values', () {
      for (var i = 2; i < 10; i++) {
        final validMinVList0 = rng.int32List(3, i + 1);

        for (var tag in slTags1) {
          log.debug('tag: $tag');
          global.throwOnError = false;
          expect(SL.isValidLength(tag, validMinVList0), false);
          expect(SL.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => SL.isValidLength(tag, invalidVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
          expect(() => SL.isValidLength(tag, validMinVList0),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('SL isValidLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final validMinVList0 = rng.int32List(1, i);
        final validMaxLengthList = invalidVList.sublist(0, SL.kMaxLength);
        for (var tag in slTag2) {
          log.debug('tag: $tag');
          expect(SL.isValidLength(tag, validMinVList0), true);
          expect(SL.isValidLength(tag, validMaxLengthList), true);
        }
      }
    });

    test('SL isValidLength VM.k2_2n good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vListGood = rng.int32List(10, 10);
        final vListBad = invalidVList.sublist(0, SL.kMaxLength);
        for (var tag in slTags3) {
          log.debug('tag: $tag');
          global.throwOnError = false;
          expect(SL.isValidLength(tag, vListGood), true);
          expect(SL.isValidLength(tag, vListBad), false);
        }
      }
    });

    test('SL isValidLength VM.k2_2n bad values', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList0 = rng.int32List(1, 1);
        for (var tag in slTags3) {
          log.debug('tag: $tag');
          global.throwOnError = false;
          expect(SL.isValidLength(tag, validMinVList0), false);
          expect(SL.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => SL.isValidLength(tag, invalidVList),
              throwsA(const isInstanceOf<InvalidValuesError>()));
          expect(() => SL.isValidLength(tag, validMinVList0),
              throwsA(const isInstanceOf<InvalidValuesError>()));
        }
      }
    });

    test('SL isValidTag good values', () {
      global.throwOnError = false;
      expect(SL.isValidTag(PTag.kSelectorSLValue), true);

      for (var tag in slTags0) {
        expect(SL.isValidTag(tag), true);
      }
    });

    test('SL isValidTag bad values', () {
      global.throwOnError = false;
      expect(SL.isValidTag(PTag.kSelectorUSValue), false);

      global.throwOnError = true;
      expect(() => SL.isValidTag(PTag.kSelectorUSValue),
          throwsA(const isInstanceOf<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SL.isValidTag(tag), false);

        global.throwOnError = true;
        expect(() => SL.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });

    test('SL isValidTag good values', () {
      global.throwOnError = false;
      expect(SL.isValidTag(PTag.kSelectorSLValue), true);

      for (var tag in slTags0) {
        expect(SL.isValidTag(tag), true);
      }
    });

    test('SL isValidTag bad values', () {
      global.throwOnError = false;
      expect(SL.isValidTag(PTag.kSelectorUSValue), false);

      global.throwOnError = true;
      expect(() => SL.isValidTag(PTag.kSelectorUSValue),
          throwsA(const isInstanceOf<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SL.isValidTag(tag), false);

        global.throwOnError = true;
        expect(() => SL.isValidTag(tag),
            throwsA(const isInstanceOf<InvalidTagError>()));
      }
    });

    test('SL isValidVR good values', () {
      global.throwOnError = false;
      expect(SL.isValidVRIndex(kSLIndex), true);

      for (var tag in slTags0) {
        global.throwOnError = false;
        expect(SL.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('SL isValidVR bad values', () {
      expect(SL.isValidVRIndex(kAEIndex), false);
      global.throwOnError = true;
      expect(() => SL.isValidVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SL.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => SL.isValidVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });
/*

    test('SL checkVR good values', () {
      global.throwOnError = false;
      expect(SL.checkVRIndex(kSLIndex), kSLIndex);

      for (var tag in slTags0) {
        global.throwOnError = false;
        expect(SL.checkVRIndex(tag.vrIndex), tag.vrIndex);
      }
    });

    test('SL checkVR bad values', () {
      expect(SL.checkVRIndex(kAEIndex), isNull);
      global.throwOnError = true;
      expect(() => SL.checkVRIndex(kAEIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SL.checkVRIndex(tag.vrIndex), isNull);

        global.throwOnError = true;
        expect(() => SL.checkVRIndex(kAEIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

*/
    test('SL isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(SL.isValidVRIndex(kSLIndex), true);
      for (var tag in slTags0) {
        expect(SL.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('SL isValidVRIndex bad values', () {
      expect(SL.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => SL.isValidVRIndex(kCSIndex),
          throwsA(const isInstanceOf<InvalidVRError>()));
      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SL.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => SL.isValidVRIndex(tag.vrIndex),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('SL isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(SL.isValidVRCode(kSLCode), true);
      expect(SL.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => SL.isValidVRCode(kAECode),
          throwsA(const isInstanceOf<InvalidVRError>()));

      for (var tag in slTags0) {
        expect(SL.isValidVRCode(tag.vrCode), true);
      }

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SL.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => SL.isValidVRCode(tag.vrCode),
            throwsA(const isInstanceOf<InvalidVRError>()));
      }
    });

    test('SL isValidVFLength good values', () {
      log.debug('max % 4: ${kMaxShortVF % 4}');
      expect(SL.isValidVFLength(SL.kMaxVFLength), true);
      expect(SL.isValidVFLength(0), true);
    });

    test('SL isValidVFLength bad values', () {
      global.throwOnError = false;
      expect(SL.isValidVFLength(SL.kMaxVFLength + 1), false);
      expect(SL.isValidVFLength(-1), false);
    });

    test('SL isValidValue good values', () {
      expect(SL.isValidValue(SL.kMinValue), true);
      expect(SL.isValidValue(SL.kMaxValue), true);
    });

    test('SL isValidValue bad values', () {
      expect(SL.isValidValue(SL.kMinValue - 1), false);
      expect(SL.isValidValue(SL.kMaxValue + 1), false);
    });
    test('SL isValidValues good values', () {
      global.throwOnError = false;
      const int32MinMax = const [kInt32Min, kInt32Max];
      const int32Min = const [kInt32Min];
      const int32Max = const [kInt32Max];

      //VM.k1
      expect(SL.isValidValues(PTag.kReferencePixelX0, int32Min), true);
      expect(SL.isValidValues(PTag.kReferencePixelX0, int32Max), true);

      //VM.k2
      expect(
          SL.isValidValues(PTag.kDisplayedAreaTopLeftHandCorner, int32MinMax),
          true);

      //vm.k1_n
      expect(SL.isValidValues(PTag.kSelectorSLValue, int32Min), true);
      expect(SL.isValidValues(PTag.kSelectorSLValue, int32Max), true);
      expect(SL.isValidValues(PTag.kSelectorSLValue, int32MinMax), true);
    });

    test('SL isValidValues bad values', () {
      global.throwOnError = false;
      const int32MaxPlus = const [kInt32Max + 1];
      const int32MinMinus = const [kInt32Min - 1];

      //VM.k1
      expect(SL.isValidValues(PTag.kReferencePixelX0, int32MaxPlus), false);
      expect(SL.isValidValues(PTag.kReferencePixelX0, int32MinMinus), false);

      // VM.k2
      expect(
          SL.isValidValues(PTag.kDisplayedAreaTopLeftHandCorner, int32MinMinus),
          false);

      global.throwOnError = true;
      expect(() => SL.isValidValues(PTag.kReferencePixelX0, int32MaxPlus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
      expect(() => SL.isValidValues(PTag.kReferencePixelX0, int32MinMinus),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('SL isValidValues bad values length', () {
      global.throwOnError = false;
      const int32MinMax = const [kInt32Min, kInt32Max];
      const int32MinMaxPlus = const [kInt32Min, kInt32Max, kInt8Min, kInt16Min];
      const int32Min = const [kInt32Min];
      const int32Max = const [kInt32Max];

      // VM.k1
      expect(SL.isValidValues(PTag.kReferencePixelX0, int32MinMax), false);

      // VM.k2
      expect(SL.isValidValues(PTag.kDisplayedAreaTopLeftHandCorner, int32Min),
          false);
      expect(SL.isValidValues(PTag.kDisplayedAreaTopLeftHandCorner, int32Max),
          false);
      expect(
          SL.isValidValues(
              PTag.kDisplayedAreaTopLeftHandCorner, int32MinMaxPlus),
          false);

      global.throwOnError = true;
      expect(() => SL.isValidValues(PTag.kReferencePixelX0, int32MinMax),
          throwsA(const isInstanceOf<InvalidValuesError>()));
      expect(
          () =>
              SL.isValidValues(PTag.kDisplayedAreaTopLeftHandCorner, int32Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('SL fromList', () {
      for (var i = 0; i < 10; i++) {
        final int32list0 = rng.int32List(1, 1);
        expect(Int32.fromList(int32list0), int32list0);
      }
      const int32Min = const [kInt32Min];
      const int32Max = const [kInt32Max];
      expect(Int32.fromList(int32Max), int32Max);
      expect(Int32.fromList(int32Min), int32Min);
    });

    test('SL fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final int32list0 = rng.int32List(1, 1);
        final int32ListV1 = new Int32List.fromList(int32list0);
        final bd = int32ListV1.buffer.asUint8List();
        log
          ..debug('int32ListV1 : $int32ListV1')
          ..debug('SL.fromUint8List(bd) ; ${Int32.fromUint8List(bd)}');
        expect(Int32.fromUint8List(bd), equals(int32ListV1));
      }
    });

    test('SL toBytes', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final int32list0 = rng.int32List(1, 1);
        final int32ListV1 = new Int32List.fromList(int32list0);
        final bd = int32ListV1.buffer.asUint8List();
        log
          ..debug('int32ListV1 : $int32ListV1')
          ..debug('SL.toBytes(int32ListV1) ; ${Int32.toBytes(int32ListV1)}');
        expect(Int32.toBytes(int32ListV1), equals(bd));
      }
      const int32Max = const [kInt32Max];
      final int32List = new Int32List.fromList(int32Max);
      final uaInt8List = int32List.buffer.asUint8List();
      expect(Int32.toBytes(int32Max), uaInt8List);

      const int64Max = const [kInt64Max];
      expect(Int32.toBytes(int64Max), isNull);

      global.throwOnError = true;
      expect(() => Int32.toBytes(int64Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('Int32Base toByteData good values', () {
      global.level = Level.info;
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final int32list0 = rng.int32List(1, 1);
        final bd0 = int32list0.buffer.asByteData();
        final lBd0 = Int32.toByteData(int32list0);
        log.debug('lBd0: ${lBd0.buffer.asUint8List()}, bd0: ${bd0.buffer
            .asUint8List()}');
        expect(lBd0.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd0.buffer == bd0.buffer, true);

        final lBd1 = Int32.toByteData(int32list0, check: false);
        log.debug('lBd3: ${lBd1.buffer.asUint8List()}, '
            'bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd1.buffer == bd0.buffer, true);
      }

      const int32Max = const [kInt32Max];
      final int32List = new Int32List.fromList(int32Max);
      final bd1 = int32List.buffer.asByteData();
      final lBd2 = Int32.toByteData(int32List);
      log.debug('bd: ${bd1.buffer.asUint8List()}, '
          'lBd2: ${lBd2.buffer.asUint8List()}');
      expect(lBd2.buffer.asUint8List(), equals(bd1.buffer.asUint8List()));
      expect(lBd2.buffer == bd1.buffer, true);
    });

    test('Int32Base toByteData bad values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final int32list0 = rng.int32List(1, 1);
        final bd0 = int32list0.buffer.asByteData();
        final lBd1 = Int32.toByteData(int32list0, asView: false);
        log.debug('lBd1: ${lBd1.buffer.asUint8List()}, '
            'bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd1.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd1.buffer == bd0.buffer, false);

        final lBd2 = Int32.toByteData(int32list0, asView: false, check: false);
        log.debug('lBd2: ${lBd2.buffer.asUint8List()}, '
            'bd0: ${bd0.buffer.asUint8List()}');
        expect(lBd2.buffer.asUint8List(), equals(bd0.buffer.asUint8List()));
        expect(lBd2.buffer == bd0.buffer, false);
      }

      const int32Max = const <int>[kInt32Max + 1];
      expect(Int32.toByteData(int32Max), isNull);

      const int32Min = const [kInt32Min - 1];
      expect(Int32.toByteData(int32Min), isNull);

      global.throwOnError = true;
      expect(() => Int32.toByteData(int32Max),
          throwsA(const isInstanceOf<InvalidValuesError>()));
    });

    test('SL fromBase64', () {
      global.level = Level.info;
      for (var i = 0; i < 10; i++) {
        final intList0 = rng.int32List(0, i);
        final int32List0 = new Int32List.fromList(intList0);
        final uInt8List0 = int32List0.buffer.asUint8List();
        final base64 = cvt.base64.encode(uInt8List0);
        log.debug('SL.base64: "$base64"');

        final slList = Int32.fromBase64(base64);
        log.debug('  SL.decode: $slList');
        expect(slList, equals(intList0));
        expect(slList, equals(int32List0));
      }
    });

    test('SL toBase64', () {
      for (var i = 0; i < 10; i++) {
        final int32list0 = rng.int32List(0, i);
        final int32ListV1 = new Int32List.fromList(int32list0);
        final bd = int32ListV1.buffer.asUint8List();
        final base64 = cvt.base64.encode(bd);
        final s = Int32.toBase64(int32list0);
        expect(s, equals(base64));
      }
    });

    test('SL toBase64', () {
      for (var i = 0; i < 10; i++) {
        final int32list0 = rng.int32List(1, 1);
        final int32ListV1 = new Int32List.fromList(int32list0);
        final bd = int32ListV1.buffer.asUint8List();
        final s = cvt.base64.encode(bd);
        expect(Int32.toBase64(int32list0), equals(s));
      }
    });

    test('SL encodeDecodeJsonVF', () {
      global.level = Level.info;
      for (var i = 1; i < 10; i++) {
        final int32list0 = rng.int32List(0, i);
        final int32ListV1 = new Int32List.fromList(int32list0);
        final bd = int32ListV1.buffer.asUint8List();

        // Encode
        final base64 = cvt.base64.encode(bd);
        log.debug('SL.base64: "$base64"');
        final s = Int32.toBase64(int32list0);
        log.debug('  SL.json: "$s"');
        expect(s, equals(base64));

        // Decode
        final sl0 = Int32.fromBase64(base64);
        log.debug('SL.base64: $sl0');
        final sl1 = Int32.fromBase64(s);
        log.debug('  SL.json: $sl1');
        expect(sl0, equals(int32list0));
        expect(sl0, equals(int32ListV1));
        expect(sl0, equals(sl1));
      }
    });

    test('SL fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final int32list0 = rng.int32List(1, 1);
        final int32ListV1 = new Int32List.fromList(int32list0);
        final bd = int32ListV1.buffer.asUint8List();
        log
          ..debug('int32ListV1 : $int32ListV1')
          ..debug('SL.fromUint8List(bd) ; ${Int32.fromUint8List(bd)}');
        expect(Int32.fromUint8List(bd), equals(int32ListV1));
      }
    });

    test('SL fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final int32list0 = rng.int32List(1, 1);
        final int32ListV1 = new Int32List.fromList(int32list0);
        final byteData = int32ListV1.buffer.asByteData();
        log
          ..debug('int32list0 : $int32list0')
          ..debug('SL.fromByteData(byteData): '
              '${Int32.fromByteData(byteData)}');
        expect(Int32.fromByteData(byteData), equals(int32list0));
      }
    });
  });
}
