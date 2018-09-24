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
  Server.initialize(name: 'element/int32_test', level: Level.info);
  final rng = RNG(1);
  global.throwOnError = false;

  group('SLTag', () {
    const int32VMinMax = [kInt32Min, kInt32Max];
    const int32Max = [kInt32Max];
    const int32MaxPlus = [kInt32Max + 1];
    const int32Min = [kInt32Min];
    const int32MinMinus = [kInt32Min - 1];

    test('SL hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int32List(1, 1);
        final e0 = SLtag(PTag.kReferencePixelX0, vList0);
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList1 = rng.int32List(2, 2);
        final e0 = SLtag(PTag.kDisplayedAreaTopLeftHandCorner, vList1);
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList1[0]));
      }
    });

    test('SL hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.int32List(3, 4);
        log.debug('$i: vList2: $vList');
        final e0 = SLtag(PTag.kReferencePixelX0, vList);
        expect(e0, isNull);
      }
    });

    test('SL hasValidValues good values ', () {
      global.throwOnError = false;
      final e0 = SLtag(PTag.kReferencePixelX0, int32Max);
      final e1 = SLtag(PTag.kReferencePixelX0, int32Max);
      expect(e0.hasValidValues, true);
      expect(e1.hasValidValues, true);

      final e2 = SLtag(PTag.kReferencePixelX0, int32Max);
      expect(e2.hasValidValues, true);

      global.throwOnError = false;
      final e3 = SLtag(PTag.kReferencePixelX0, []);
      expect(e3.hasValidValues, true);
      expect(e3.values, equals(<int>[]));
    });

    test('SL hasValidValues bad values ', () {
      final e0 = SLtag(PTag.kReferencePixelX0, int32MaxPlus);
      expect(e0, isNull);

      final e1 = SLtag(PTag.kReferencePixelX0, int32MinMinus);
      expect(e1, isNull);

      final e2 = SLtag(PTag.kReferencePixelX0, int32VMinMax);
      expect(e2, isNull);

      final e3 = SLtag(PTag.kReferencePixelX0, int32Min);
      final int64List0 = rng.int64List(1, 1);
      e3.values = int64List0;
      expect(e3.hasValidValues, false);

      global.throwOnError = true;
      expect(() => e3.hasValidValues,
          throwsA(const TypeMatcher<InvalidValuesError>()));

      global.throwOnError = false;
      final e4 = SLtag(PTag.kReferencePixelX0, null);
      log.debug('e4: $e4');
      expect(e4, isNull);

      global.throwOnError = true;
      expect(() => SLtag(PTag.kReferencePixelX0, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('SL update random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.int32List(3, 4);
        final e1 = SLtag(PTag.kSelectorSLValue, vList);
        final vList1 = rng.int32List(3, 4);
        expect(e1.update(vList1).values, equals(vList1));
      }
    });

    test('SL update ', () {
      final e0 = SLtag(PTag.kReferencePixelX0, []);
      expect(e0.update([76345748]).values, equals([76345748]));

      final e1 = SLtag(PTag.kReferencePixelX0, int32Min);
      final e2 = SLtag(PTag.kReferencePixelX0, int32Min);
      final e3 = e1.update(int32Max);
      final e4 = e2.update(int32Max);
      expect(e1.values.first == e4.values.first, false);
      expect(e1 == e4, false);
      expect(e2 == e3, false);
      expect(e4 == e4, true);
    });

    test('SL noValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.int32List(1, 1);
        final e1 = SLtag(PTag.kReferencePixelX0, vList);
        log.debug('e1: ${e1.noValues}');
        expect(e1.noValues.values.isEmpty, true);
      }
    });

    test('SL noValues ', () {
      final e0 = SLtag(PTag.kReferencePixelX0, []);
      final SLtag slNoValues = e0.noValues;
      expect(slNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      final e1 = SLtag(PTag.kReferencePixelX0, int32Min);
      final slNoValues0 = e1.noValues;
      expect(slNoValues0.values.isEmpty, true);
      log.debug('e1:${e1.noValues}');
    });

    test('SL copy random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.int32List(3, 4);
        final e2 = SLtag(PTag.kSelectorSLValue, vList);
        final SLtag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('SL copy ', () {
      final e0 = SLtag(PTag.kReferencePixelX0, []);
      final SLtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      final e3 = SLtag(PTag.kSelectorSLValue, int32VMinMax);
      final e4 = e3.copy;
      expect(e3 == e4, true);
      expect(e3.hashCode == e4.hashCode, true);
    });

    test('SL hashCode and == good values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int32List(1, 1);
        final e0 = SLtag(PTag.kReferencePixelX0, vList0);
        final e1 = SLtag(PTag.kReferencePixelX0, vList0);
        log
          ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
          ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('SL hashCode and == bad values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int32List(1, 1);
        final vList1 = rng.int32List(1, 1);
        final e0 = SLtag(PTag.kReferencePixelX0, vList0);
        final e2 = SLtag(PTag.kReferencePixelY0, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rng.int32List(2, 2);
        final e3 = SLtag(PTag.kDisplayedAreaBottomRightHandCorner, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);

        final vList3 = rng.int32List(2, 6);
        final e4 = SLtag(PTag.kPixelCoordinatesSetTrial, vList3);
        log.debug('vList3:$vList3 , e4.hash_code:${e4.hashCode}');
        expect(e0.hashCode == e4.hashCode, false);
        expect(e0 == e4, false);

        final vList4 = rng.int32List(1, 8);
        final e5 = SLtag(PTag.kSelectorSLValue, vList4);
        log.debug('vList4:$vList4 , e5.hash_code:${e5.hashCode}');
        expect(e0.hashCode == e5.hashCode, false);
        expect(e0 == e5, false);

        final vList5 = rng.int32List(2, 3);
        final e6 = SLtag(PTag.kReferencePixelX0, vList5);
        log.debug('vList5:$vList5 , e6.hash_code:${e6.hashCode}');
        expect(e0.hashCode == e6.hashCode, false);
        expect(e0 == e6, false);
      }
    });

    test('SL hashCode and ==  good values', () {
      final e0 = SLtag(PTag.kReferencePixelX0, int32Min);
      final e1 = SLtag(PTag.kReferencePixelX0, int32Min);
      log
        ..debug('int32Min:$int32Min, e0.hash_code:${e0.hashCode}')
        ..debug('int32Min:$int32Min, e1.hash_code:${e1.hashCode}');
      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);
    });

    test('SL hashCode and ==  bad values', () {
      final e0 = SLtag(PTag.kReferencePixelX0, int32Min);
      final e2 = SLtag(PTag.kReferencePixelY0, int32Max);
      log.debug('int32Max:$int32Max , e2.hash_code:${e2.hashCode}');
      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);
    });

    test('SL fromBytes good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int32List(1, 1);
//        final int32ListV1 = Int32List.fromList(vList0);
//        final uInt8ListV1 = int32ListV1.buffer.asUint8List();
        final bytes = Bytes.typedDataView(vList0);
        final e0 = SLtag.fromBytes(PTag.kReferencePixelX0, bytes);
        expect(e0.hasValidValues, true);
        expect(e0.values, equals(vList0));
        expect(e0.vfBytes, equals(bytes));
        expect(e0.values is Int32List, true);
        expect(e0.values, equals(vList0));
      }
    });

    test('SL fromBytes bad random values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int32List(2, 10);
        final bytes = Bytes.typedDataView(vList0);
//        final uInt8ListV2 = int32ListV2.buffer.asUint8List();
        final e1 = SLtag.fromBytes(PTag.kReferencePixelX0, bytes);
        expect(e1, isNull);
      }
    });

    test('SL fromBytes good values ', () {
      final int32ListV1 = Int32List.fromList(int32Max);
      //     final uInt8ListV1 = int32ListV1.buffer.asUint8List();
      final bytes = Bytes.typedDataView(int32ListV1);
      final e0 = SLtag.fromBytes(PTag.kReferencePixelX0, bytes);
      expect(e0.hasValidValues, true);
      expect(e0.vfBytes, equals(bytes));
      expect(e0.values is Int32List, true);
      expect(e0.values, equals(int32ListV1));
    });

    test('SL fromBytes bad values ', () {
      final vList2 = Int32List.fromList([rng.nextInt64]);
      //  final uInt8List2 = vList2.buffer.asUint8List();
      final bytes2 = Bytes.typedDataView(vList2);
      log.debug('vList2 : $vList2, bytes2: $bytes2');
      final sl7 = SLtag.fromBytes(PTag.kReferencePixelX0, bytes2);
      expect(sl7.hasValidValues, true);
    });

    test('SL fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rng.int32List(1, 10);
        final bytes0 = Bytes.typedDataView(vList0);
        log.debug('bytes0: $bytes0');
        final e0 = SLtag.fromBytes(PTag.kSelectorSLValue, bytes0);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
      }
    });

    test('SL fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final intList0 = rng.int32List(1, 10);

        final bytes0 = Bytes.typedDataView(intList0);
        final e0 = SLtag.fromBytes(PTag.kSelectorFDValue, bytes0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => SLtag.fromBytes(PTag.kSelectorFDValue, bytes0),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('SL checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.int32List(1, 10);
        final e0 = SLtag(PTag.kRationalNumeratorValue, vList);
        expect(e0.checkLength(e0.values), true);
      }
    });

    test('SL checkLength ', () {
      final e0 = SLtag(PTag.kRationalNumeratorValue, int32Min);
      expect(e0.checkLength(e0.values), true);
    });

    test('SL checkValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.int32List(1, 10);
        final e0 = SLtag(PTag.kRationalNumeratorValue, vList);
        expect(e0.checkValues(e0.values), true);
      }
    });

    test('SL checkValues ', () {
      global.throwOnError = false;
      final e0 = SLtag(PTag.kRationalNumeratorValue, int32Min);
      expect(e0.checkValues(e0.values), true);

      final e1 = SLtag(PTag.kRationalNumeratorValue, [rng.nextInt64]);
      expect(e1, isNull);
    });

    test('SL valuesCopy random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.int32List(1, 10);
        final e0 = SLtag(PTag.kRationalNumeratorValue, vList);
        expect(vList, equals(e0.valuesCopy));
      }
    });

    test('SL vlauesCopy', () {
      final e0 = SLtag(PTag.kRationalNumeratorValue, int32Max);
      expect(int32Max, equals(e0.valuesCopy));
    });

    test('SL replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int32List(1, 10);
        final e0 = SLtag(PTag.kRationalNumeratorValue, vList0);
        final vList1 = rng.int32List(1, 10);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rng.int32List(1, 10);
      final e1 = SLtag(PTag.kRationalNumeratorValue, vList1);
      expect(e1.replace(<int>[]), equals(vList1));
      expect(e1.values, equals(<int>[]));

      final e2 = SLtag(PTag.kRationalNumeratorValue, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(<int>[]));
    });

    test('SL BASE64 random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int32List(1, 1);
        final bytes0 = Bytes.typedDataView(vList0);
//        final uInt8ListV1 = int32ListV1.buffer.asUint8List();
//        final base64 = cvt.base64.encode(uInt8ListV1);
        final base64 = bytes0.getBase64();
        final bytes1 = Bytes.fromBase64(base64);
        final e0 = SLtag.fromBytes(PTag.kRationalNumeratorValue, bytes1);
        expect(e0.hasValidValues, true);
      }
    });

    test('SL BASE64 ', () {
      final vList0 = Int32List.fromList(int32Max);
      final bytes0 = Bytes.typedDataView(vList0);
      //     final uInt8ListV1 = int32ListV1.buffer.asUint8List();
//      final base64 = cvt.base64.encode(uInt8ListV1);
      final base64 = bytes0.getBase64();
      final bytes1 = Bytes.fromBase64(base64);
      final e0 = SLtag.fromBytes(PTag.kRationalNumeratorValue, bytes1);
      expect(e0.hasValidValues, true);
    });

    test('SL fromValues good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int32List(1, 1);
        final e0 = SLtag.fromValues(PTag.kReferencePixelX0, vList0);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);

        final e1 = SLtag.fromValues(PTag.kReferencePixelX0, <int>[]);
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(<int>[]));
      }
    });

    test('SL fromValues bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int32List(2, 2);
        global.throwOnError = false;
        final make0 = SLtag.fromValues(PTag.kReferencePixelX0, vList0);
        expect(make0, isNull);

        global.throwOnError = true;
        expect(() => SLtag.fromValues(PTag.kReferencePixelX0, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('SL checkValue good values', () {
      final vList0 = rng.int32List(1, 1);
      final e0 = SLtag(PTag.kReferencePixelX0, vList0);

      expect(e0.checkValue(int32Max[0]), true);
      expect(e0.checkValue(int32Min[0]), true);
    });

    test('SL checkValue bad values', () {
      final vList0 = rng.int32List(1, 1);
      final e0 = SLtag(PTag.kReferencePixelX0, vList0);
      expect(e0.checkValue(int32MaxPlus[0]), false);
      expect(e0.checkValue(int32MinMinus[0]), false);
    });

    test('SL view', () {
      final vList0 = rng.int32List(10, 10);
      final e0 = SLtag(PTag.kSelectorSLValue, vList0);
      for (var i = 0, j = 0; i < vList0.length; i++, j += 4) {
        final e1 = e0.view(j, vList0.length - i);
        log.debug('e0: ${e0.values}, e1: ${e1.values}, '
            'vList0.sublist(i) : ${vList0.sublist(i)}');
        expect(e1.values, equals(vList0.sublist(i)));
      }
    });
  });

  group('SL Element', () {
    //VM.k1
    const slVM1Tags = <PTag>[
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
    const slVM2Tags = <PTag>[
      PTag.kDisplayedAreaTopLeftHandCorner,
      PTag.kDisplayedAreaBottomRightHandCorner,
    ];

    //VM.k1_n
    const slVM1_nTags = <PTag>[
      PTag.kRationalNumeratorValue,
      PTag.kSelectorSLValue,
    ];

    //VM.k2_2n
    const slVM2_2nTags = <PTag>[PTag.kPixelCoordinatesSetTrial];

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

    final invalidVList = rng.int32List(SL.kMaxLength + 1, SL.kMaxLength + 1);

    test('SL isValidLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final validMinVList0 = rng.int32List(1, 1);
        final validMaxLengthList = invalidVList.sublist(0, SL.kMaxLength);

        for (var tag in slVM1Tags) {
          log.debug('tag: $tag');
          expect(SL.isValidLength(tag, validMinVList0), true);

          expect(
              SL.isValidLength(tag, validMaxLengthList.take(tag.vmMax)), true);
          expect(
              SL.isValidLength(tag, validMaxLengthList.take(tag.vmMin)), true);
        }
      }
    });

    test('SL isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final validMinVList0 = rng.int32List(2, i + 1);

        for (var tag in slVM1Tags) {
          global.throwOnError = false;
          log.debug('tag: $tag');
          expect(SL.isValidLength(tag, validMinVList0), false);
          expect(SL.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => SL.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
          expect(() => SL.isValidLength(tag, validMinVList0),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
      global.throwOnError = false;
      expect(
          SL.isValidLength(PTag.kDopplerSampleVolumeXPosition, null), isNull);

      global.throwOnError = true;
      expect(() => SL.isValidLength(PTag.kDopplerSampleVolumeXPosition, null),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('SL isValidLength VM.k2 good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final validMinVList0 = rng.int32List(2, 2);
        final validMaxLengthList = invalidVList.sublist(0, SL.kMaxLength);

        for (var tag in slVM2Tags) {
          log.debug('tag: $tag');
          expect(SL.isValidLength(tag, validMinVList0), true);

          expect(
              SL.isValidLength(tag, validMaxLengthList.take(tag.vmMax)), true);
          expect(
              SL.isValidLength(tag, validMaxLengthList.take(tag.vmMin)), true);
        }
      }
    });

    test('SL isValidLength VM.k2 bad values', () {
      for (var i = 2; i < 10; i++) {
        final validMinVList0 = rng.int32List(3, i + 1);

        for (var tag in slVM2Tags) {
          log.debug('tag: $tag');
          global.throwOnError = false;
          expect(SL.isValidLength(tag, validMinVList0), false);
          expect(SL.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => SL.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
          expect(() => SL.isValidLength(tag, validMinVList0),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('SL isValidLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final validMinVList0 = rng.int32List(1, i);
        final validMaxLengthList = invalidVList.sublist(0, SL.kMaxLength);
        for (var tag in slVM1_nTags) {
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
        for (var tag in slVM2_2nTags) {
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
        for (var tag in slVM2_2nTags) {
          log.debug('tag: $tag');
          global.throwOnError = false;
          expect(SL.isValidLength(tag, validMinVList0), false);
          expect(SL.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => SL.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
          expect(() => SL.isValidLength(tag, validMinVList0),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('SL isValidTag good values', () {
      global.throwOnError = false;
      expect(SL.isValidTag(PTag.kSelectorSLValue), true);

      for (var tag in slVM1Tags) {
        expect(SL.isValidTag(tag), true);
      }
    });

    test('SL isValidTag bad values', () {
      global.throwOnError = false;
      expect(SL.isValidTag(PTag.kSelectorUSValue), false);

      global.throwOnError = true;
      expect(() => SL.isValidTag(PTag.kSelectorUSValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SL.isValidTag(tag), false);

        global.throwOnError = true;
        expect(() => SL.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('SL isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(SL.isValidVRIndex(kSLIndex), true);
      for (var tag in slVM1Tags) {
        expect(SL.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('SL isValidVRIndex bad values', () {
      expect(SL.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => SL.isValidVRIndex(kCSIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));
      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SL.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => SL.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('SL isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(SL.isValidVRCode(kSLCode), true);
      expect(SL.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => SL.isValidVRCode(kAECode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in slVM1Tags) {
        expect(SL.isValidVRCode(tag.vrCode), true);
      }

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(SL.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => SL.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('SL isValidVFLength good values', () {
      log.debug('max % 4: ${kMaxShortVF % 4}');
      expect(SL.isValidVFLength(SL.kMaxVFLength), true);
      expect(SL.isValidVFLength(0), true);

      expect(SL.isValidVFLength(SL.kMaxVFLength, null, PTag.kSelectorSLValue),
          true);
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
      const int32MinMax = [kInt32Min, kInt32Max];
      const int32Min = [kInt32Min];
      const int32Max = [kInt32Max];

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
      const int32MaxPlus = [kInt32Max + 1];
      const int32MinMinus = [kInt32Min - 1];

      //VM.k1
      expect(SL.isValidValues(PTag.kReferencePixelX0, int32MaxPlus), false);
      expect(SL.isValidValues(PTag.kReferencePixelX0, int32MinMinus), false);

      // VM.k2
      expect(
          SL.isValidValues(PTag.kDisplayedAreaTopLeftHandCorner, int32MinMinus),
          false);

      global.throwOnError = true;
      expect(() => SL.isValidValues(PTag.kReferencePixelX0, int32MaxPlus),
          throwsA(const TypeMatcher<InvalidValuesError>()));
      expect(() => SL.isValidValues(PTag.kReferencePixelX0, int32MinMinus),
          throwsA(const TypeMatcher<InvalidValuesError>()));

      global.throwOnError = false;
      expect(SL.isValidValues(PTag.kReferencePixelX0, null), false);
    });

    test('SL isValidValues bad values length', () {
      global.throwOnError = false;
      const int32MinMax = [kInt32Min, kInt32Max];
      const int32MinMaxPlus = [kInt32Min, kInt32Max, kInt8Min, kInt16Min];
      const int32Min = [kInt32Min];
      const int32Max = [kInt32Max];

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
          throwsA(const TypeMatcher<InvalidValuesError>()));
      expect(
          () =>
              SL.isValidValues(PTag.kDisplayedAreaTopLeftHandCorner, int32Max),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('SL isValidBytesArgs', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.int32List(1, i);
        final vfBytes = Bytes.typedDataView(vList0);

        if (vList0.length == 1) {
          for (var tag in slVM1Tags) {
            final e0 = SL.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else if (vList0.length == 2) {
          for (var tag in slVM2Tags) {
            final e0 = SL.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else {
          for (var tag in slVM1_nTags) {
            final e0 = SL.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        }
      }
      final vList0 = rng.int32List(1, 1);
      final vfBytes = Bytes.typedDataView(vList0);

      final e1 = SL.isValidBytesArgs(null, vfBytes);
      expect(e1, false);

      final e2 = SL.isValidBytesArgs(PTag.kDate, vfBytes);
      expect(e2, false);

      final e3 = SL.isValidBytesArgs(PTag.kSelectorSLValue, null);
      expect(e3, false);

      global.throwOnError = true;
      expect(() => SL.isValidBytesArgs(null, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => SL.isValidBytesArgs(PTag.kDate, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));
    });
  });
}
