//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/float64_test', level: Level.info);
  final rng = RNG(1);
  global.throwOnError = false;

  const float64GoodList = <double>[
    0.1,
    1.2,
    1.11,
    1.15,
    5.111,
    09.2345,
    23.6,
    45.356,
    98.99999,
    323.09,
    101.11111111,
    234543.90890000,
    1.00000000000007,
    -1.345,
    -11.000453,
  ];

  group('ODtags', () {
    test('OD hasValidValues good values', () {
      const float64LstCommon0 = <double>[1];
      global.throwOnError = false;

      final e0 = ODtag(PTag.kSelectorODValue, float64LstCommon0);
      expect(e0.hasValidValues, true);

      // empty list and null as values
      global.throwOnError = false;
      final e1 = ODtag(PTag.kSelectorODValue, []);
      expect(e1.hasValidValues, true);
      expect(e1.values, equals(<double>[]));
    });

    test('OD hasValidValues bad values', () {
      final e1 = ODtag(PTag.kSelectorODValue, null);
      log.debug('e1: $e1');
      expect(e1, isNull);

      global.throwOnError = true;
      expect(() => ODtag(PTag.kSelectorODValue, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('OD hasValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(1, 1);
        final e0 = ODtag(PTag.kSelectorODValue, float64List);
        log.debug('e0:$e0');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(float64List[0]));
      }

      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(2, 4);
        log.debug('$i: float64List: $float64List');
        final e0 = ODtag(PTag.kDoubleFloatPixelData, float64List);
        expect(e0.hasValidValues, true);
      }
    });

    test('OD update random', () {
      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(3, 4);
        final e0 = ODtag(PTag.kSelectorODValue, float64List);
        final float64List1 = rng.float64List(3, 4);
        expect(e0.update(float64List1).values, equals(float64List1));
      }
    });

    test('OD update', () {
      final e0 = ODtag(PTag.kSelectorODValue, []);
      expect(e0.update([1.0, 2.0]).values, equals([1.0, 2.0]));

      final e1 = ODtag(PTag.kSelectorODValue, float64GoodList);
      expect(e1.update(float64GoodList).values, equals(float64GoodList));

      const floatUpdateValues = <double>[
        546543.674, 6754764.45887, 54698.52, 787354.734768 // No reformat
      ];
      for (var i = 1; i <= floatUpdateValues.length - 1; i++) {
        final odValues = floatUpdateValues.take(i).toList();
        final e2 = ODtag(PTag.kSelectorODValue, Float64List.fromList(odValues));
        expect(
            e2.update(Float64List.fromList(floatUpdateValues.take(i).toList())),
            equals(Float64List.fromList(floatUpdateValues.take(i).toList())));

        expect(e2.update(floatUpdateValues.take(1).toList()).values,
            equals(floatUpdateValues.take(1).toList()));
      }
      final e3 = ODtag(PTag.lookupByCode(0x00720073),
          Float64List.fromList(floatUpdateValues));
      expect(e3.update(Float64List.fromList(floatUpdateValues)),
          equals(Float64List.fromList(floatUpdateValues)));
    });

    test('OD noValues random', () {
      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(3, 4);
        final e1 = ODtag(PTag.kSelectorODValue, float64List);
        log.debug('e1: ${e1.noValues}');
        expect(e1.noValues.values.isEmpty, true);
      }
    });

    test('OD noValues', () {
      final e0 = ODtag(PTag.kSelectorODValue, []);
      final ODtag odNoValues = e0.noValues;
      expect(odNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      final e1 = ODtag(PTag.kSelectorODValue, float64GoodList);
      log.debug('e1: $e1');
      expect(odNoValues.values.isEmpty, true);
      log.debug('e1: ${e1.noValues}');
    });

    test('OD copy random', () {
      for (var i = 0; i < 10; i++) {
        final float64List = rng.float64List(3, 4);
        final e2 = ODtag(PTag.kDoubleFloatPixelData, float64List);
        final ODtag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('OD copy', () {
      final e0 = ODtag(PTag.kSelectorODValue, []);
      final ODtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      final e2 = ODtag(PTag.kDoubleFloatPixelData, float64GoodList);
      final ODtag e3 = e2.copy;
      expect(e3 == e2, true);
      expect(e3.hashCode == e2.hashCode, true);
    });

    test('OD hashCode and == good values random', () {
      log.debug('OD hashCode and ==');
      for (var i = 0; i < 10; i++) {
        final vList = rng.float64List(1, 1);
        final e0 = ODtag(PTag.kSelectorODValue, vList);
        final e1 = ODtag(PTag.kSelectorODValue, vList);
        log
          ..debug('vList:$vList, e0.hash_code:${e0.hashCode}')
          ..debug('vList:$vList, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('OD hashCode and == bad values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final e0 = ODtag(PTag.kSelectorODValue, vList0);

        final vList1 = rng.float64List(1, 1);
        final e2 = ODtag(PTag.kDoubleFloatPixelData, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rng.float64List(2, 3);
        final e3 = ODtag(PTag.kDoubleFloatPixelData, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);
      }
    });

    test('OD hashCode and == good values', () {
      final e0 = ODtag(PTag.kSelectorODValue, float64GoodList.take(1));
      final e1 = ODtag(PTag.kSelectorODValue, float64GoodList.take(1));
      log
        ..debug('floatList0:$float64GoodList, e0.hash_code:${e0.hashCode}')
        ..debug('floatList0:$float64GoodList, e1.hash_code:${e1.hashCode}');
      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);
    });

    test('OD hashCode and == bad values', () {
      final e0 = ODtag(PTag.kSelectorODValue, float64GoodList.take(1));

      final e1 = ODtag(PTag.kDoubleFloatPixelData, float64GoodList.take(1));
      log.debug('float64LstCommon0:$float64GoodList , '
          'e1.hash_code:${e1.hashCode}');
      expect(e0.hashCode == e1.hashCode, false);
      expect(e0 == e1, false);
    });

    test('OD replace random', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final e0 = ODtag(PTag.kSelectorODValue, vList0);
        final vList1 = rng.float64List(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));

        final vList2 = rng.float64List(1, 1);
        final e1 = ODtag(PTag.kSelectorODValue, vList2);
        expect(e1.replace(<double>[]), equals(vList2));
        expect(e1.values, equals(<double>[]));

        final e2 = ODtag(PTag.kSelectorODValue, vList2);
        expect(e2.replace(null), equals(vList2));
        expect(e2.values, equals(<double>[]));
      }
    });

    test('OD fromBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final bytes0 = Bytes.typedDataView(vList0);
        final e0 = ODtag.fromBytes(PTag.kSelectorODValue, bytes0);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);

        final vList1 = rng.float64List(2, 2);
        final bytes1 = Bytes.typedDataView(vList1);
        final e1 = ODtag.fromBytes(PTag.kSelectorODValue, bytes1);
        log.debug('e1 $e1');
        expect(e1.hasValidValues, true);
      }
    });

    test('OD fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float64List(1, 1);
        final bytes = Bytes.typedDataView(vList);
        final e0 = ODtag.fromBytes(PTag.kSelectorODValue, bytes);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
      }
    });

    test('OD fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.float64List(1, 10);
        final bytes = Bytes.typedDataView(vList);
        final e0 = ODtag.fromBytes(PTag.kSelectorSSValue, bytes);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => ODtag.fromBytes(PTag.kSelectorSSValue, bytes),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('OD make good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final e0 = ODtag.fromValues(PTag.kSelectorODValue, vList0);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);

        final e1 = ODtag.fromValues(PTag.kSelectorODValue, <double>[]);
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(<double>[]));
      }
    });

    test('ODtag.fromBase64', () {
      global.throwOnError = false;
      final s0 = Float64Mixin.toBase64(<double>[78678.11, 12345.678]);
      log.debug('b64: $s0');
      final bytes0 = Bytes.fromBase64(s0);
      final e0 = ODtag.fromBytes(PTag.kSelectorODValue, bytes0);
      log.debug('e0: $e0');
      expect(e0.hasValidValues, true);

      for (var i = 0; i < 10; i++) {
        final vList1 = rng.float64List(1, 1);
        final s1 = Float64Mixin.toBase64(vList1);
        final bytes1 = Bytes.fromBase64(s1);
        final e1 = ODtag.fromBytes(PTag.kSelectorODValue, bytes1);
        expect(e1.hasValidValues, true);
      }
    });

    test('Create Elements from floating values(OD)', () {
      const f64Values = <double>[2047.99, 2437.437, 764.53];

      final e0 = ODtag(PTag.kSelectorODValue, Float64List.fromList(f64Values));
      expect(e0.values.first.toStringAsPrecision(1),
          equals(2047.99.toStringAsPrecision(1)));
    });

    test('OD checkLength good values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.float64List(1, i);
        final e0 = ODtag(PTag.kSelectorODValue, vList);
        expect(e0.checkLength(e0.values), true);
      }
    });

    test('OD checkValues', () {
      for (var i = 1; i < 10; i++) {
        final vist0 = rng.float64List(1, i);
        final e0 = ODtag(PTag.kSelectorODValue, vist0);
        expect(e0.checkValues(e0.values), true);
      }
    });

    test('OD check', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float64List(1, 1);
        final e0 = ODtag(PTag.kSelectorODValue, vList);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
        expect(e0.check(), true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList[0]));
      }
    });

    test('OD valuesEqual good values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.float64List(1, i);
        final e0 = ODtag(PTag.kSelectorODValue, vList);
        final e1 = ODtag(PTag.kSelectorODValue, vList);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), true);
      }
    });

    test('OD valuesEqual bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.float64List(1, i);
        final vList1 = rng.float64List(1, 1);
        final e0 = ODtag(PTag.kSelectorODValue, vList0);
        final e1 = ODtag(PTag.kSelectorODValue, vList1);
        log.debug('e0: $e0 , e1: $e1');
        expect(e0.valuesEqual(e1), false);
      }
    });

    test('OD bulkdata and typedData', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.float64List(1, i);
        final uint8List0 = vList.buffer.asUint8List();
        final e0 = ODtag(PTag.kSelectorODValue, vList);
        expect(e0.hasValidValues, true);

        log.debug('e0.bulkdata: ${e0.bulkdata}, e0.typedData: ${e0.typedData}');
        expect(e0.bulkdata, equals(uint8List0));
        expect(e0.bulkdata, equals(e0.typedData.buffer.asUint8List()));
        expect(e0.typedData, equals(vList));
      }
    });
  });

  group('OD Element', () {
    //VM.k1
    const odVMk1Tags = <PTag>[
      PTag.kSelectorODValue,
      PTag.kDoubleFloatPixelData,
    ];

    const otherTags = <PTag>[
      PTag.kNumberOfIterations,
      PTag.kAcquisitionProtocolName,
      PTag.kAcquisitionContextDescription,
      PTag.kCTPositionSequence,
      PTag.kAcquisitionType,
      PTag.kPerformedStationAETitle,
      PTag.kSelectorSTValue,
      PTag.kDate,
      PTag.kTime
    ];

    test('OD isValidTag good values', () {
      global.throwOnError = false;
      expect(OD.isValidTag(PTag.kSelectorODValue), true);

      for (final tag in odVMk1Tags) {
        final validT0 = OD.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('OD isValidTag bad values', () {
      global.throwOnError = false;
      expect(OD.isValidTag(PTag.kSelectorFLValue), false);
      global.throwOnError = true;
      expect(() => OD.isValidTag(PTag.kSelectorFLValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (final tag in otherTags) {
        global.throwOnError = false;
        final validT0 = OD.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => OD.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('OD isValidVR good values', () {
      global.throwOnError = false;
      expect(OD.isValidVR(kODIndex), true);

      for (final s in odVMk1Tags) {
        global.throwOnError = false;
        expect(OD.isValidVR(s.vrIndex), true);
      }
    });

    test('OD isValidVR bad values', () {
      global.throwOnError = false;
      expect(OD.isValidVR(kAEIndex), false);

      global.throwOnError = true;
      expect(() => OD.isValidVR(kAEIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (final s in otherTags) {
        global.throwOnError = false;
        expect(OD.isValidVR(s.vrIndex), false);

        global.throwOnError = true;
        expect(() => OD.isValidVR(s.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('OD isValidLength', () {
      global.throwOnError = false;
      expect(OD.isValidLength(OD.kMaxLength), true);
      expect(OD.isValidLength(0), true);
    });

    test('OD.isValidVFLength good values', () {
      global.throwOnError = false;
      expect(OD.isValidVFLength(OD.kMaxVFLength), true);
      expect(OD.isValidVFLength(0), true);
    });

    test('OD.isValidVFLength bad values', () {
      global.throwOnError = false;
      expect(OD.isValidVFLength(OD.kMaxVFLength + 1), false);
      expect(OD.isValidVFLength(-1), false);
    });

    test('OD.isValidVR good values', () {
      global.throwOnError = false;
      expect(OD.isValidVR(kODIndex), true);

      for (final tag in odVMk1Tags) {
        global.throwOnError = false;
        expect(OD.isValidVR(tag.vrIndex), true);
      }
    });

    test('OD.isValidVR bad values', () {
      global.throwOnError = false;
      expect(OD.isValidVR(kATIndex), false);

      global.throwOnError = true;
      expect(() => OD.isValidVR(kATIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (final tag in otherTags) {
        global.throwOnError = false;
        expect(OD.isValidVR(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => OD.isValidVR(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('OD.isValidVRCode good values', () {
      global.throwOnError = false;
      expect(OD.isValidVRCode(kODCode), true);

      for (final tag in odVMk1Tags) {
        global.throwOnError = false;
        expect(OD.isValidVRCode(tag.vrCode), true);
      }
    });

    test('OD.isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(OD.isValidVRCode(kATCode), false);

      global.throwOnError = true;
      expect(() => OD.isValidVRCode(kATCode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (final tag in otherTags) {
        global.throwOnError = false;
        expect(OD.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => OD.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('OD isValidVFLength good values', () {
      expect(OD.isValidVFLength(OD.kMaxVFLength), true);
      expect(OD.isValidVFLength(0), true);
    });

    test('OD isValidVFLength bad values', () {
      expect(OD.isValidVFLength(OD.kMaxVFLength + 1), false);
      expect(OD.isValidVFLength(-1), false);
    });

    test('OD.isValidValues', () {
      global.throwOnError = false;
      for (var i = 0; i <= float64GoodList.length - 1; i++) {
        expect(
            OD.isValidValues(
                PTag.kSelectorODValue, <double>[float64GoodList[i]]),
            true);
      }
    });

    test('Flaot64Base.fromList', () {
      expect(Float64Mixin.fromList(float64GoodList), float64GoodList);

      for (var i = 0; i < 10; i++) {
        final vList = rng.float64List(1, 1);
        expect(Float64Mixin.fromList(vList), vList);
      }
    });

    test('Float64Mixin.fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        final bList0 = vList0.buffer.asUint8List();
        expect(Float64Mixin.fromUint8List(bList0), equals(vList0));
      }
      final vList1 = Float64List.fromList(<double>[]);
      final bList1 = vList1.buffer.asUint8List();
      expect(Float64Mixin.fromUint8List(bList1), equals(<double>[]));
    });

    test('Create Float64Mixin.toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float64List(1, 1);
        final float64List0 = Float64List.fromList(vList);
        final uInt8List0 = float64List0.buffer.asUint8List();
        //final base64 = cvt.base64.encode(uInt8List0);
        final base64 = Float64Mixin.toBytes(float64List0);
        expect(base64, equals(uInt8List0));
      }
    });

    test('OD.decode/encode binaryVF', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(1, 1);
        expect(vList0.lengthInBytes.isEven, true);
        expect(vList0.length == 1, true);

        final bList0 = vList0.buffer.asUint8List();
        final s0 = base64.encode(bList0);
        final bList1 = base64.decode(s0);
        expect(bList1, equals(bList0));

        final bList2 = Float64Mixin.toUint8List(vList0);
        expect(bList2, equals(bList1));

        final vList1 = Float64Mixin.fromUint8List(bList1);
        expect(vList1, equals(vList0));

        final vList2 = Float64Mixin.fromUint8List(bList2);
        expect(vList2, equals(vList0));
        expect(vList2, equals(vList1));
      }
    });

    test('OD.fromBase64', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float64List(0, i);
        final bList0 = vList0.buffer.asUint8List();
        final s0 = base64.encode(bList0);
        expect(Float64Mixin.fromBase64(s0), vList0);
      }
    });

    test('OD.fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float64List(0, i);
        final float64List0 = Float64List.fromList(vList);
        expect(vList.lengthInBytes.isEven, true);
        final bd = float64List0.buffer.asUint8List();
        expect(Float64Mixin.fromUint8List(bd), equals(vList));
      }
      final float0 = Float64List.fromList(<double>[]);
      final bd0 = float0.buffer.asUint8List();
      expect(Float64Mixin.fromUint8List(bd0), equals(<double>[]));
    });

    test('OD.fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float64List(1, 1);
        final float = Float64List.fromList(vList);
        final byteData0 = float.buffer.asByteData();
        expect(Float64Mixin.fromByteData(byteData0), equals(vList));
      }
      final float0 = Float64List.fromList(<double>[]);
      final bd0 = float0.buffer.asByteData();
      expect(Float64Mixin.fromByteData(bd0), equals(<double>[]));
    });
  });
}
