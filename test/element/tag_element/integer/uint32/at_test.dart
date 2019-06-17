//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:bytes_dicom/bytes_dicom.dart';
import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/at_test', level: Level.info);
  final rng = RNG(1);
  global.throwOnError = false;

  group('AT', () {
    const uInt32MinMax = [kUint32Min, kUint32Max];
    const uInt32Max = [kUint32Max];
    const uInt32MaxPlus = [kUint32Max + 1];
    const uInt32Min = [kUint32Min];
    const uInt32MinMinus = [kUint32Min - 1];

    test('AT hasValidValues good values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final e0 = ATtag(PTag.kOriginalImageIdentification, vList0);
        log.debug('e0: e0');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: e0');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 10);
        final e0 = ATtag(PTag.kSelectorATValue, vList0);
        log.debug('e0: e0');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: e0');
        expect(e0[0], equals(vList0[0]));
      }
    });

    test('AT hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(2, 3);
        log.debug('$i: vList0: $vList0');
        final e0 = ATtag(PTag.kDimensionIndexPointer, vList0);
        expect(e0, isNull);
      }
    });

    test('AT hasValidValues good values', () {
      global.throwOnError = false;
      final e0 = ATtag(PTag.kDimensionIndexPointer, uInt32Max);
      final e1 = ATtag(PTag.kDimensionIndexPointer, uInt32Max);
      expect(e0.hasValidValues, true);
      expect(e1.hasValidValues, true);

      final e2 = ATtag(PTag.kDimensionIndexPointer, uInt32Max);
      final e3 = ATtag(PTag.kDimensionIndexPointer, uInt32Max);
      expect(e2.hasValidValues, true);
      expect(e3.hasValidValues, true);

      global.throwOnError = false;
      final e4 = ATtag(PTag.kFunctionalGroupPointer, []);
      expect(e4.hasValidValues, true);
      log.debug('e4:e4');
      expect(e4.values, equals(<int>[]));
    });

    test('AT hasValidValues bad values', () {
      final e0 = ATtag(PTag.kDimensionIndexPointer, uInt32MaxPlus);
      expect(e0, isNull);

      final e1 = ATtag(PTag.kDimensionIndexPointer, uInt32MinMinus);
      expect(e1, isNull);

      final e2 = ATtag(PTag.kDimensionIndexPointer, uInt32MinMax);
      expect(e2, isNull);

      final e3 = ATtag(PTag.kDimensionIndexPointer, uInt32Max);
      final uInt64List0 = rng.uint64List(1, 1);
      e3.values = uInt64List0;
      expect(e3.hasValidValues, false);

      global.throwOnError = true;
      expect(() => e3.hasValidValues,
          throwsA(const TypeMatcher<InvalidValuesError>()));

      global.throwOnError = false;
      final e4 = ATtag(PTag.kFunctionalGroupPointer, null);
      log.debug('e4: $e4');
      //expect(e4, isNull);
      expect(e4.values, kEmptyUint32List);

      /* global.throwOnError = true;
      expect(() => ATtag(PTag.kFunctionalGroupPointer, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));*/
    });

    test('AT update random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(3, 4);
        final bytes = Bytes.typedDataView(vList0);
        final e1 = ATtag(PTag.kSelectorATValue, bytes);
        final vList1 = rng.uint32List(3, 4);

        expect(e1.update(vList1).values, equals(vList1));
      }
    });

    test('AT update', () {
      final e0 = ATtag(PTag.kSelectorATValue, uInt32Min);
      final e1 = ATtag(PTag.kSelectorATValue, uInt32Min);
      final e2 = e0.update(uInt32Max);
      final e3 = e1.update(uInt32Max);
      expect(e0.values.first == e3.values.first, false);
      expect(e0 == e3, false);
      expect(e1 == e3, false);
      expect(e2 == e3, true);

      final e4 = ATtag(PTag.kSelectorATValue, []);
      expect(
          e4.update([76345748, 64357898]).values, equals([76345748, 64357898]));
    });

    test('AT noValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.uint32List(3, 4);
        final e1 = ATtag(PTag.kSelectorATValue, vList);
        log.debug('e1: ${e1.noValues}');
        expect(e1.noValues.values.isEmpty, true);
      }
    });

    test('AT noValues', () {
      final e0 = ATtag(PTag.kSelectorATValue, []);
      final ATtag atNoValues = e0.noValues;
      expect(atNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      final e1 = ATtag(PTag.kFunctionalGroupPointer, uInt32Max);
      final atNoValues0 = e1.noValues;
      expect(atNoValues0.values.isEmpty, true);
      log.debug('e1:${e1.noValues}');
    });

    test('AT copy random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.uint32List(3, 4);
        final e2 = ATtag(PTag.kSelectorATValue, vList);
        final ATtag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('AT copy', () {
      final e0 = ATtag(PTag.kFunctionalGroupPointer, []);
      final ATtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      final e2 = ATtag(PTag.kFunctionalGroupPointer, uInt32Max);
      final e3 = e2.copy;
      expect(e2 == e3, true);
      expect(e2.hashCode == e3.hashCode, true);
    });

    test('AT hashCode and == random good values', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final e0 = ATtag(PTag.kFunctionalGroupPointer, vList0);
        final e1 = ATtag(PTag.kFunctionalGroupPointer, vList0);
        log
          ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
          ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('AT hashCode and == random bad values', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final e0 = ATtag(PTag.kFunctionalGroupPointer, vList0);
        final vList1 = rng.uint32List(1, 1);
        final e2 = ATtag(PTag.kDimensionIndexPointer, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rng.uint32List(1, 9);
        final e3 = ATtag(PTag.kOriginalImageIdentification, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);

        final vList3 = rng.uint32List(2, 3);
        final e4 = ATtag(PTag.kFunctionalGroupPointer, vList3);
        log.debug('vList3:$vList3 , e4.hash_code:${e4.hashCode}');
        expect(e0.hashCode == e4.hashCode, false);
        expect(e0 == e4, false);
      }
    });

    test('AT hashCode and == good values', () {
      final e0 = ATtag(PTag.kOriginalImageIdentification, uInt32Max);
      final e1 = ATtag(PTag.kOriginalImageIdentification, uInt32Max);

      log
        ..debug('uInt32Max:$uInt32Max, e0.hash_code:${e0.hashCode}')
        ..debug('uInt32Max:$uInt32Max, e1.hash_code:${e1.hashCode}');
      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);
    });

    test('AT hashCode and == bad values', () {
      final e0 = ATtag(PTag.kOriginalImageIdentification, uInt32Max);

      final e2 = ATtag(PTag.kOriginalImageIdentification, uInt32Min);
      log.debug('uInt32Min:$uInt32Min , e2.hash_code:${e2.hashCode}');
      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);
    });

    test('AT fromBytes good random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final bytes = Bytes.typedDataView(vList0);
        final e0 = ATtag.fromBytes(PTag.kOriginalImageIdentification, bytes);
        expect(e0.hasValidValues, true);
        expect(e0.vfBytes, equals(bytes));
        expect(e0.values is Uint32List, true);
        expect(e0.values, equals(vList0));

        final vList2 = rng.uint32List(2, 2);
        final bytes2 = Bytes.typedDataView(vList2);
        final e2 = ATtag.fromBytes(PTag.kSelectorAttribute, bytes2);
        expect(e2, isNull);
      }
    });

    test('AT fromBytes bad values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rng.uint32List(2, 2);
        final bytes0 = Uint32.toBytes(vList);
        final e1 = ATtag.fromBytes(PTag.kFunctionalGroupPointer, bytes0);
        expect(e1, isNull);
      }
    });

    test('AT fromBytes good values', () {
      final vList = Uint32List.fromList(uInt32Max);
      final bytes = Bytes.typedDataView(vList);
      final e0 = ATtag.fromBytes(PTag.kOriginalImageIdentification, bytes);
      expect(e0.hasValidValues, true);
      expect(e0.vfBytes, equals(bytes));
      expect(e0.values is Uint32List, true);
      expect(e0.values, equals(vList));
    });

    test('AT fromBytes bad values ', () {
      final vList2 = Uint32List.fromList([rng.nextInt64]);
      //  final uInt8List2 = vList2.buffer.asUint8List();
      final bytes2 = Bytes.typedDataView(vList2);
      log.debug('vList2 : $vList2, bytes2: $bytes2');
      final at0 = ATtag.fromBytes(PTag.kOriginalImageIdentification, bytes2);
      expect(at0.hasValidValues, true);
    });

    test('AT fromBytes good values', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList = rng.uint32List(1, 10);
        final bytes = Bytes.typedDataView(vList);
        final e0 = ATtag.fromBytes(PTag.kSelectorATValue, bytes);
        log.debug('e0: e0');
        expect(e0.hasValidValues, true);
      }
    });

    test('AT fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.uint32List(1, 10);
        final bytes = Bytes.typedDataView(vList);
        final e = ATtag.fromBytes(PTag.kSelectorFDValue, bytes);
        expect(e, isNull);

        global.throwOnError = true;
        expect(() => ATtag.fromBytes(PTag.kSelectorFDValue, bytes),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('AT checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final e0 = ATtag(PTag.kFunctionalGroupPointer, vList0);
        expect(e0.checkLength(e0.values), true);
      }

      final vList0 = rng.uint32List(2, 2);
      final e0 = ATtag(PTag.kFunctionalGroupPointer);
      expect(e0.checkLength(vList0), false);
    });

    test('AT checkLength', () {
      final e0 = ATtag(PTag.kFunctionalGroupPointer, uInt32Max);
      expect(e0.checkLength(e0.values), true);
    });

    test('AT checkValues random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final e0 = ATtag(PTag.kFunctionalGroupPointer, vList0);
        expect(e0.checkValues(e0.values), true);
      }

      final vList0 = rng.int64List(1, 1);
      final e0 = ATtag(PTag.kFunctionalGroupPointer);
      expect(e0.checkValues(vList0), false);

      global.throwOnError = true;
      expect(() => e0.checkValues(vList0),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('AT checkValues', () {
      global.throwOnError = false;
      final e0 = ATtag(PTag.kFunctionalGroupPointer, uInt32Max);
      expect(e0.checkValues(e0.values), true);

      expect(e0.checkValues([kUint64Max]), false);

      global.throwOnError = true;
      expect(() => e0.checkValues([kUint64Max]),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('AT valuesCopy random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final e0 = ATtag(PTag.kFunctionalGroupPointer, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('AT valuesCopy', () {
      final e0 = ATtag(PTag.kFunctionalGroupPointer, uInt32Max);
      expect(uInt32Max, equals(e0.valuesCopy));
    });

    test('AT replace random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final bytes = Bytes.typedDataView(vList0);
        final e0 = ATtag.fromBytes(PTag.kFunctionalGroupPointer, bytes);
        final e1 = ATtag.fromBytes(PTag.kFunctionalGroupPointer, bytes);
        final vList1 = rng.uint32List(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
        expect(e1.replace(vList1), equals(vList0));
        expect(e1.values, equals(vList1));
      }

      final vList2 = rng.uint32List(1, 1);
      final e1 = ATtag(PTag.kFunctionalGroupPointer, vList2);
      expect(e1.replace(<int>[]), equals(vList2));
      expect(e1.values, equals(<int>[]));

      final e2 = ATtag(PTag.kFunctionalGroupPointer, vList2);
      expect(e2.replace(null), equals(vList2));
      expect(e2.values, equals(<int>[]));
    });

    test('AT BASE64 random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final bytes0 = Bytes.typedDataView(vList0);
        final base64 = bytes0.getBase64();
        final bytes1 = Bytes.fromBase64(base64);
        final e0 = ATtag.fromBytes(PTag.kFunctionalGroupPointer, bytes1);
        expect(e0.hasValidValues, true);
      }
    });

    test('AT BASE64', () {
      final vList1 = Uint32List.fromList(uInt32Max);
      final uInt8List1 = vList1.buffer.asUint8List();
      final bytes0 = Bytes.typedDataView(uInt8List1);

      final s = bytes0.getBase64();
      final bytes1 = Bytes.fromBase64(s);
      final e0 = ATtag.fromBytes(PTag.kFunctionalGroupPointer, bytes1);
      expect(e0.hasValidValues, true);
    });

    test('XintYYBase random', () {
      for (var i = 0; i < 10; i++) {
        final uInt8List0 = rng.uint8List(1, 1);
        //       final uint8List3 = Uint8List.fromList(uint8List0);
        final bytes = Bytes.typedDataView(uInt8List0);
        final v0 = Uint8.fromBytes(bytes);
        log.debug('v0: $v0');
        expect(v0, isNotNull);

        final uInt16List0 = rng.uint16List(1, 1);
//        final uint16List0 = Uint16List.fromList(uint16List0);
//        final uint8List1 = uint16List0.buffer.asUint8List();
        final bytes1 = Bytes.typedDataView(uInt16List0);
        final v1 = Uint16.fromBytes(bytes1);
        log.debug('v1: $v1');
        expect(v1, isNotNull);

        final vList0 = rng.uint32List(1, 1);
//        final vList0 = Uint32List.fromList(vList0);
//        final uint8List0 = vList0.buffer.asUint8List();
        final bytes2 = Bytes.typedDataView(vList0);
        final v2 = Uint32.fromBytes(bytes2);
        log.debug('v2: $v2');
        expect(v2, isNotNull);

        final uInt64List0 = rng.uint64List(1, 1);
//        final uint64List0 = Uint64List.fromList(uint64List0);
//        final uint8List2 = uint64List0.buffer.asUint8List();
        final bytes3 = Bytes.typedDataView(uInt64List0);
        final v3 = Uint64.fromBytes(bytes3);
        log.debug('v3: $v3');
        expect(v3, isNotNull);
      }
    });

    test('AT fromValues good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final e0 = ATtag.fromValues(PTag.kFunctionalGroupPointer, vList0);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);

        final e1 = ATtag.fromValues(PTag.kFunctionalGroupPointer, <int>[]);
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(<int>[]));
      }
    });

    test('AT fromValues bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(2, 2);
        global.throwOnError = false;
        final e0 = ATtag.fromValues(PTag.kFunctionalGroupPointer, vList0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => ATtag.fromValues(PTag.kFunctionalGroupPointer, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('AT checkValue good values', () {
      final vList0 = rng.uint32List(1, 1);
      final e0 = ATtag(PTag.kFunctionalGroupPointer, vList0);

      expect(e0.checkValue(uInt32Max[0]), true);
      expect(e0.checkValue(uInt32Min[0]), true);
    });

    test('AT checkValue bad values', () {
      final vList0 = rng.uint32List(1, 1);
      final e0 = ATtag(PTag.kFunctionalGroupPointer, vList0);
      expect(e0.checkValue(uInt32MaxPlus[0]), false);
      expect(e0.checkValue(uInt32MinMinus[0]), false);
    });

    test('AT view', () {
      final vList = rng.uint32List(10, 10);
      final e0 = ATtag(PTag.kSelectorATValue, vList);
      for (var i = 0, j = 0; i < vList.length; i++, j += 4) {
        final e1 = e0.view(j, vList.length - i);
        log.debug('e: ${e0.values}, e1: ${e1.values}, '
            'vList.sublist(i) : ${vList.sublist(i)}');
        expect(e1.values, equals(vList.sublist(i)));
      }

      final bytes = Bytes.typedDataView(vList);
      final e2 = ATtag.fromBytes(PTag.kSelectorATValue, bytes);
      for (var i = 0, j = 0; i < vList.length; i++, j += 4) {
        final e3 = e2.view(j, vList.length - i);
        log.debug('e: ${e0.values}, e1: ${e3.values}, '
            'vList.sublist(i) : ${vList.sublist(i)}');
        expect(e3.values, equals(vList.sublist(i)));
      }
    });

    test('AT equal', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.uint32List(1, i);
        final bytesA = Bytes.typedDataView(vList);
        final bytesB = Bytes.typedDataView(vList);

        final vList0 = rng.uint32List(2, 2);
        final bytesC = Bytes.typedDataView(vList0);

        final e0 = ATtag.fromBytes(PTag.kOriginalImageIdentification, bytesA);
        final equal0 = e0.equal(bytesA, bytesB);
        expect(equal0, true);

        final equal1 = e0.equal(bytesA, bytesC);
        expect(equal1, false);
      }
    });

    test('AT check', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.uint32List(1, 1);
        final e0 = ATtag(PTag.kFunctionalGroupPointer, vList);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList[0]));
      }

      for (var i = 1; i < 10; i++) {
        final vList1 = rng.uint32List(1, i);
        final e0 = ATtag(PTag.kSelectorATValue, vList1);
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);
        expect(e0[0], equals(vList1[0]));
      }
    });

    test('AT valuesEqual good values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.uint32List(1, i);
        final e0 = ATtag(PTag.kSelectorATValue, vList);
        final e1 = ATtag(PTag.kSelectorATValue, vList);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), true);
      }
    });

    test('AT valuesEqual bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint32List(1, i);
        final vList1 = rng.uint32List(1, 1);
        final e0 = ATtag(PTag.kSelectorATValue, vList0);
        final e1 = ATtag(PTag.kSelectorATValue, vList1);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), false);
      }
    });

    test('AT bulkdata and typedData', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.uint32List(1, i);
        final uint8List0 = vList.buffer.asUint8List();
        final e0 = ATtag(PTag.kSelectorATValue, vList);
        expect(e0.hasValidValues, true);

        log.debug('e0.bulkdata: ${e0.bulkdata}, e0.typedData: ${e0.typedData}');
        expect(e0.bulkdata, equals(uint8List0));
        expect(e0.bulkdata, equals(e0.typedData.buffer.asUint8List()));
        expect(e0.typedData, equals(vList));
      }
    });
  });

  group('AT Element', () {
    //VM.k1
    const atVM1Tags = <PTag>[
      PTag.kDimensionIndexPointer,
      PTag.kFunctionalGroupPointer,
      PTag.kSelectorAttribute,
      PTag.kAttributeOccurrencePointer,
      PTag.kParameterSequencePointer,
      PTag.kOverrideParameterPointer,
      PTag.kParameterPointer,
    ];

    //VM.k1_n
    const atVM1nTags = <PTag>[
      PTag.kOriginalImageIdentification,
      PTag.kFrameIncrementPointer,
      PTag.kFrameDimensionPointer,
      PTag.kCompressionStepPointers,
      PTag.kDetailsOfCoefficients,
      PTag.kDataBlock,
      PTag.kZonalMapLocation,
      PTag.kCodeTableLocation,
      PTag.kImageDataLocation,
      PTag.kSelectorSequencePointer,
      PTag.kSelectorATValue,
      PTag.kFailureAttributes,
      PTag.kOverlayCompressionStepPointers,
      PTag.kOverlayCodeTableLocation,
      PTag.kCoefficientCodingPointers,
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

    final invalidVList = rng.uint32List(AT.kMaxLength + 1, AT.kMaxLength + 1);

    test('AT isValidLength VM.k1 good values', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.uint32List(1, 1);
        global.throwOnError = false;
        for (final tag in atVM1Tags) {
          expect(AT.isValidLength(tag, vList), true);
          expect(AT.isValidLength(tag, invalidVList.take(tag.vmMax)), true);
          expect(AT.isValidLength(tag, invalidVList.take(tag.vmMin)), true);
        }
      }
    });

    test('AT isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final invalidMinVList = rng.uint32List(2, i + 1);
        for (final tag in atVM1Tags) {
          global.throwOnError = false;
          expect(AT.isValidLength(tag, invalidMinVList), false);
          expect(AT.isValidLength(tag, invalidVList), false);

          global.throwOnError = true;
          expect(() => AT.isValidLength(tag, invalidMinVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
          expect(() => AT.isValidLength(tag, invalidVList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
      global.throwOnError = false;
      final vList0 = rng.uint32List(1, 1);
      expect(AT.isValidLength(null, vList0), false);

      expect(AT.isValidLength(PTag.kRegionFlags, null), isNull);

      global.throwOnError = true;
      expect(() => AT.isValidLength(null, vList0),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => AT.isValidLength(PTag.kSelectorAttribute, null),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('AT isValidLength VM.k1_n good values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.uint32List(1, i);
        global.throwOnError = false;
        for (final tag in atVM1nTags) {
          expect(AT.isValidLength(tag, vList), true);

          expect(AT.isValidLength(tag, invalidVList.sublist(0, AT.kMaxLength)),
              true);
        }
      }
    });

    test('AT isValidTag good values', () {
      global.throwOnError = false;
      expect(AT.isValidTag(PTag.kSelectorATValue), true);

      for (final tag in atVM1Tags) {
        expect(AT.isValidTag(tag), true);
      }
    });

    test('AT isValidTag bad values', () {
      global.throwOnError = false;
      expect(AT.isValidTag(PTag.kSelectorUSValue), false);

      global.throwOnError = true;
      expect(() => AT.isValidTag(PTag.kSelectorUSValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (final tag in otherTags) {
        global.throwOnError = false;
        expect(AT.isValidTag(tag), false);

        global.throwOnError = true;
        expect(() => AT.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('AT isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(AT.isValidVRIndex(kATIndex), true);

      for (final tag in atVM1Tags) {
        expect(AT.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('AT isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(AT.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => AT.isValidVRIndex(kCSIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (final tag in otherTags) {
        global.throwOnError = false;
        expect(AT.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => AT.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('AT isValidVRCode good values', () {
      global.throwOnError = false;
      expect(AT.isValidVRCode(kATCode), true);

      for (final tag in atVM1Tags) {
        expect(AT.isValidVRCode(tag.vrCode), true);
      }
    });

    test('AT isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(AT.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => AT.isValidVRCode(kAECode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (final tag in otherTags) {
        global.throwOnError = false;
        expect(AT.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => AT.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('AT isValidVFLength good values', () {
      expect(AT.isValidVFLength(AT.kMaxVFLength), true);
      expect(AT.isValidVFLength(0), true);

      expect(AT.isValidVFLength(AT.kMaxVFLength, null, PTag.kSelectorATValue),
          true);
    });

    test('AT isValidVFLength bad values', () {
      global.throwOnError = false;
      expect(AT.isValidVFLength(AT.kMaxVFLength + 1), false);
      expect(AT.isValidVFLength(0), true);
    });

    test('AT isValidValue good values', () {
      expect(AT.isValidValue(AT.kMinValue), true);
      expect(AT.isValidValue(AT.kMaxValue), true);
    });

    test('AT isValidValue bad values', () {
      expect(AT.isValidValue(AT.kMinValue - 1), false);
      expect(AT.isValidValue(AT.kMaxValue + 1), false);
    });

    test('AT isValidValues good values values', () {
      global.throwOnError = false;
      const uInt32MinMax = [kUint32Min, kUint32Max, kUint16Max];
      const uInt32Min = [kUint32Min];
      const uInt32Max = [kUint32Max];

      //VM.k1
      expect(AT.isValidValues(PTag.kSelectorAttribute, uInt32Min), true);
      expect(AT.isValidValues(PTag.kSelectorAttribute, uInt32Max), true);

      //VM.k1_n
      expect(AT.isValidValues(PTag.kSelectorATValue, uInt32MinMax), true);
      expect(AT.isValidValues(PTag.kSelectorATValue, uInt32Max), true);
      expect(AT.isValidValues(PTag.kSelectorATValue, uInt32Min), true);
    });

    test('AT isValidValues bad values values', () {
      global.throwOnError = false;
      const uInt32MaxPlus = [kUint32Max + 1];
      const uInt32MinMinus = [kUint32Min - 1];

      //VM.k1
      expect(AT.isValidValues(PTag.kSelectorAttribute, uInt32MaxPlus), false);
      expect(AT.isValidValues(PTag.kSelectorAttribute, uInt32MinMinus), false);

      global.throwOnError = true;
      expect(() => AT.isValidValues(PTag.kSelectorAttribute, uInt32MaxPlus),
          throwsA(const TypeMatcher<InvalidValuesError>()));
      expect(() => AT.isValidValues(PTag.kSelectorAttribute, uInt32MinMinus),
          throwsA(const TypeMatcher<InvalidValuesError>()));

      global.throwOnError = false;
      expect(AT.isValidValues(PTag.kSelectorAttribute, null), false);
    });

    test('AT isValidValues bad values length', () {
      global.throwOnError = false;
      const uInt32MinMax = [
        kUint32Min,
        kUint32Max,
      ];

      //VM.k1
      expect(AT.isValidValues(PTag.kSelectorAttribute, uInt32MinMax), false);

      global.throwOnError = true;
      expect(() => AT.isValidValues(PTag.kSelectorAttribute, uInt32MinMax),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('AT isValidBytesArgs', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint32List(1, i);
        final vfBytes = Bytes.typedDataView(vList0);

        if (vList0.length == 1) {
          for (final tag in atVM1Tags) {
            final e0 = AT.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else {
          for (final tag in atVM1nTags) {
            final e0 = AT.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        }
      }
      final vList0 = rng.uint32List(1, 1);
      final vfBytes = Bytes.typedDataView(vList0);

      final e1 = AT.isValidBytesArgs(null, vfBytes);
      expect(e1, false);

      final e2 = AT.isValidBytesArgs(PTag.kDate, vfBytes);
      expect(e2, false);

      final e3 = AT.isValidBytesArgs(PTag.kSelectorATValue, null);
      expect(e3, false);

      global.throwOnError = true;
      expect(() => AT.isValidBytesArgs(null, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => AT.isValidBytesArgs(PTag.kDate, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));
    });
  });
}
