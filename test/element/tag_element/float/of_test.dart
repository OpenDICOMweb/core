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
  Server.initialize(name: 'element/of_test', level: Level.info);
  final rng = new RNG(1);
  global.throwOnError = false;

  const listFloat32Common0 = const <double>[
    1.1,
    1.11,
    1.111,
    1.11111,
    1.1111111111111,
    1.000000003,
    123456789.123456789,
    -0.2,
    -11.11,
  ];

  group('OFTag', () {
    final rng = new RNG(1);

    test('OF hasValidValues good values', () {
      global.throwOnError = false;
      final e0 = new OFtag(PTag.kUValueData, listFloat32Common0);
      expect(e0.hasValidValues, true);

      global.throwOnError = false;
      final e1 = new OFtag(PTag.kVectorGridData, []);
      expect(e1.hasValidValues, true);
      expect(e1.values, equals(<double>[]));

      final e2 = new OFtag(PTag.kVectorGridData);
      expect(e2.hasValidValues, true);
      expect(e2.values.isEmpty, true);
    });

    test('OF hasValidValues bad values', () {
      final e2 = new OFtag(PTag.kVectorGridData, null);
      expect(e2, isNull);

      global.throwOnError = true;
      expect(() => new OFtag(PTag.kVectorGridData, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('OF hasValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 10);
        log.debug('i: $i, vList: $vList');
        final e0 = new OFtag(PTag.kUValueData, vList);
        log.debug('of:$e0');
        expect(e0[0], equals(vList[0]));
        expect(e0.hasValidValues, true);
      }

      for (var i = 0; i < 100; i++) {
        final vList = rng.float32List(2, 10);
        log.debug('i: $i, vList: $vList');
        final e0 = new OFtag(PTag.kFirstOrderPhaseCorrectionAngle, vList);
        expect(e0.hasValidValues, true);
      }
    });

    test('OF update random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float32List(1, 10);
        final e1 = new OFtag(PTag.kUValueData, vList0);
        final vList1 = rng.float32List(1, 10);
        expect(e1.update(vList1).values, equals(vList1));
      }
    });

    test('OF update', () {
      final of0 = new OFtag(PTag.kVectorGridData, []);
      final floats = [1.2, 1.3, 1.4];
      final vList0 = new Float32List.fromList(floats);
      expect(of0.update(vList0).values, equals(vList0));

      final vList1 = new Float32List.fromList(listFloat32Common0);
      final of1 = new OFtag(PTag.kUValueData, vList1);
      expect(of1.update(vList1).values, equals(vList1));

      const floats2 = const <double>[
        546543.674, 6754764.45887, 54698.52, 787354.734768 // No reformat
      ];
      final vList2 = new Float32List.fromList(floats2);
      for (var i = 1; i <= vList2.length - 1; i++) {
        final of2 = new OFtag(PTag.kSelectorOFValue,
            new Float32List.fromList(vList2.take(i).toList()));

        expect(
            of2.update(
                new Float32List.fromList(vList2.take(i).toList())),
            equals(
                new Float32List.fromList(vList2.take(i).toList())));

        expect(of2.update(vList2.take(i).toList()).values,
            equals(vList2.take(i).toList()));
      }
      final of3 = new OFtag(PTag.lookupByCode(kUValueData),
          new Float32List.fromList(vList2));
      expect(of3.update(new Float32List.fromList(vList2)),
          equals(new Float32List.fromList(vList2)));
    });

    test('OF noValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 10);
        final e1 = new OFtag(PTag.kUValueData, vList);
        final ofNoValues = e1.noValues;
        expect(ofNoValues.values.isEmpty, true);
      }
    });

    test('OF noValues ', () {
      final e0 = new OFtag(PTag.kVectorGridData, []);
      final ofNoValues0 = e0.noValues;
      expect(ofNoValues0.values.isEmpty, true);
      log.debug('e0:${e0.noValues}');

      final e1 = new OFtag(PTag.kUValueData, listFloat32Common0);
      final ofNoValues1 = e1.noValues;
      expect(ofNoValues1.values.isEmpty, true);
    });

    test('OF copy random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final e0 = new OFtag(PTag.kVectorGridData, vList);
        final OFtag e5 = e0.copy;
        expect(e0 == e5, true);
        expect(e0.hashCode == e5.hashCode, true);
      }
    });

    test('OF copy', () {
      final e0 = new OFtag(PTag.kVectorGridData, listFloat32Common0);
      final OFtag e5 = e0.copy;
      expect(e0 == e5, true);
      expect(e0.hashCode == e5.hashCode, true);
    });

    test('OF hashCode and == good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final e0 = new OFtag(PTag.kVectorGridData, vList);
        final e1 = new OFtag(PTag.kVectorGridData, vList);
        log
          ..debug('vList:$vList , e1.hash_code:${e1.hashCode}')
          ..debug('vList:$vList , e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('OF hashCode and == bad values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float32List(1, 1);
        final vList1 = rng.float32List(1, 1);
        final e0 = new OFtag(PTag.kVectorGridData, vList0);
        final e2 = new OFtag(PTag.kPointCoordinatesData, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rng.float32List(1, 2);
        final e3 = new OFtag(PTag.kUValueData, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);

        final vList3 = rng.float32List(2, 3);
        final e4 = new OFtag(PTag.kPointCoordinatesData, vList3);
        log.debug('vList3:$vList3 , e4.hash_code:${e4.hashCode}');
        expect(e2.hashCode == e4.hashCode, false);
        expect(e2 == e4, false);
      }
    });

    test('OF hashCode and == good values', () {
      final e0 = new OFtag(PTag.kVectorGridData, listFloat32Common0.take(1));
      final e1 = new OFtag(PTag.kVectorGridData, listFloat32Common0.take(1));
      log
        ..debug('listFloat32Common0:$listFloat32Common0 , e1.hash_code:${e1
            .hashCode}')
        ..debug('listFloat32Common0:$listFloat32Common0 , e1.hash_code:${e1
            .hashCode}');
      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);
    });

    test('OF hashCode and == bad values', () {
      final e0 = new OFtag(PTag.kVectorGridData, listFloat32Common0.take(1));
      final e2 =
          new OFtag(PTag.kPointCoordinatesData, listFloat32Common0.take(1));
      log.debug('listFloat32Common0:$listFloat32Common0,'
          ' e2.hash_code:${e2.hashCode}');
      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);

      final e3 = new OFtag(PTag.kUValueData, listFloat32Common0);
      log.debug('listFloat32Common0:$listFloat32Common0, '
          'e3.hash_code:${e3.hashCode}');
      expect(e0.hashCode == e3.hashCode, false);
      expect(e0 == e3, false);

      final e4 = new OFtag(PTag.kSelectorOFValue, listFloat32Common0);
      log.debug('listFloat32Common0:$listFloat32Common0, '
          'e4.hash_code:${e4.hashCode}');
      expect(e0.hashCode == e4.hashCode, false);
      expect(e0 == e4, false);
    });

    test('OF replace random', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float32List(1, 1);
        final e0 = new OFtag(PTag.kVectorGridData, vList0);
        final vList1 = rng.float32List(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList2 = rng.float32List(1, 1);
      final e1 = new OFtag(PTag.kVectorGridData, vList2);
      expect(e1.replace(<double>[]), equals(vList2));
      expect(e1.values, equals(<double>[]));

      final e2 = new OFtag(PTag.kVectorGridData, vList2);
      expect(e2.replace(null), equals(vList2));
      expect(e2.values, equals(<double>[]));
    });

    test('OF fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float32List(1, 1);
        //    final float = new Float32List.fromList(vList);
        //    final bytes = float.buffer.asUint8List();
        final bytes0 = new Bytes.typedDataView(vList0);
        final e0 = OFtag.fromBytes(bytes0, PTag.kVectorGridData);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);

        final vList1 = rng.float32List(3, 3);
        //    final float0 = new Float32List.fromList(vList1);
        //    final bytes0 = float0.buffer.asUint8List();
        final bytes1 = new Bytes.typedDataView(vList1);
        final e1 =
            OFtag.fromBytes(bytes1, PTag.kFirstOrderPhaseCorrectionAngle);
        log.debug('e1: $e1');
        expect(e1.hasValidValues, true);
      }
    });

    test('OF fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final bytes = new Bytes.typedDataView(vList);
        final e0 = OFtag.fromBytes(bytes, PTag.kSelectorOFValue);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
      }
    });

    test('OF fromBytes bad tag', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.float32List(1, 10);
        final bytes = new Bytes.typedDataView(vList);
        final e0 = OFtag.fromBytes(bytes, PTag.kSelectorSSValue);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => OFtag.fromBytes(bytes, PTag.kSelectorSSValue),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('OF make good values', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final e0 = OFtag.fromValues(PTag.kVectorGridData, vList);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);

        final e1 = OFtag.fromValues(PTag.kVectorGridData, <double>[]);
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(<double>[]));
      }
    });

    test('Float32Base to/FromBase64', () {
      final s0 = Float32.toBase64(<double>[78678.11]);
      final bytes0 = Bytes.fromBase64(s0);
      final e0 = OFtag.fromBytes(bytes0, PTag.kVectorGridData);
      expect(e0.hasValidValues, true);

      for (var i = 0; i < 10; i++) {
        final vList1 = rng.float32List(1, 1);
        final bytes1 = vList1.buffer.asUint8List();
        final s1 = base64.encode(bytes1);
        final bytes2 = Bytes.fromBase64(s1);
        final e1 = OFtag.fromBytes(bytes2, PTag.kVectorGridData);
        expect(e1.hasValidValues, true);
      }
    });

    test('OF checkLength random', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.float32List(1, i);
        final e0 = new OFtag(PTag.kSelectorOFValue, vList);
        expect(e0.checkLength(e0.values), true);
      }
    });

    test('OF checkValues', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.float32List(1, i);
        final e0 = new OFtag(PTag.kSelectorOFValue, vList);
        expect(e0.checkValues(e0.values), true);
      }
    });
  });

  group('OF Element', () {
    const ofVM1Tags = const <PTag>[
      PTag.kVectorGridData,
      PTag.kFloatingPointValues,
      PTag.kUValueData,
      PTag.kVValueData,
      PTag.kFirstOrderPhaseCorrectionAngle,
      PTag.kSpectroscopyData,
      PTag.kFloatPixelData,
    ];

    const ofVMk1_nTags = const <PTag>[PTag.kSelectorOFValue];

    const otherTags = const <PTag>[
      PTag.kPlanningLandmarkID,
      PTag.kAcquisitionProtocolName,
      PTag.kCTDIvol,
      PTag.kCTPositionSequence,
      PTag.kAcquisitionType,
      PTag.kPerformedStationAETitle,
      PTag.kSelectorSTValue,
      PTag.kDate,
      PTag.kTime
    ];

    test('OF isValidTag good values', () {
      global.throwOnError = false;
      expect(OF.isValidTag(PTag.kSelectorOFValue), true);

      for (var tag in ofVM1Tags) {
        final validT0 = OF.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('OF isValidTag bad values', () {
      global.throwOnError = false;
      expect(OF.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => OF.isValidTag(PTag.kSelectorFDValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = OF.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => OF.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('OF isValidVR good values', () {
      global.throwOnError = false;
      expect(OF.isValidVR(kOFIndex), true);

      for (var s in ofVM1Tags) {
        global.throwOnError = false;
        expect(OF.isValidVR(s.vrIndex), true);
      }
    });

    test('OF isValidVR bad values', () {
      global.throwOnError = false;
      expect(OF.isValidVR(kAEIndex), false);

      global.throwOnError = true;
      expect(() => OF.isValidVR(kAEIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var s in otherTags) {
        global.throwOnError = false;
        expect(OF.isValidVR(s.vrIndex), false);

        global.throwOnError = true;
        expect(() => OF.isValidVR(s.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('OF isValidLength VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rng.float32List(1, 1);
        global.throwOnError = false;
        for (var tag in ofVM1Tags) {
          expect(OF.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('OF isValidLength VM.k1_n', () {
      for (var i = 0; i < 10; i++) {
        final validMinVList = rng.float32List(1, 1);
        global.throwOnError = false;
        for (var tag in ofVMk1_nTags) {
          expect(OF.isValidLength(tag, validMinVList), true);
        }
      }
    });

    test('OF isValidVR good values', () {
      global.throwOnError = false;
      expect(OF.isValidVR(kOFIndex), true);

      for (var tag in ofVM1Tags) {
        global.throwOnError = false;
        expect(OF.isValidVR(tag.vrIndex), true);
      }
    });

    test('OF isValidVR bad values', () {
      global.throwOnError = false;
      expect(OF.isValidVR(kATIndex), false);

      global.throwOnError = true;
      expect(() => OF.isValidVR(kATIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OF.isValidVR(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => OF.isValidVR(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('OF isValidVRCode good values', () {
      global.throwOnError = false;
      expect(OF.isValidVRCode(kOFCode), true);

      for (var tag in ofVM1Tags) {
        global.throwOnError = false;
        expect(OF.isValidVRCode(tag.vrCode), true);
      }
    });

    test('OF isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(OF.isValidVRCode(kATCode), false);

      global.throwOnError = true;
      expect(() => OF.isValidVRCode(kATCode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OF.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => OF.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });
/*

    test('OF checkVR good values', () {
      system.throwOnError = false;
      expect(OF.checkVRIndex(kOFIndex), kOFIndex);

      for (var tag in ofTags) {
        system.throwOnError = false;
        expect(OF.checkVRIndex(tag.vrIndex), OF.kVRIndex);
      }
    });

    test('OF checkVR bad values', () {
      system.throwOnError = false;
      expect(
          OF.checkVRIndex(
            kAEIndex,
          ),
          null);
      system.throwOnError = true;
      expect(() => OF.checkVRIndex(kAEIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OF.checkVRIndex(tag.vrIndex), null);

        system.throwOnError = true;
        expect(() => OF.checkVRIndex(kAEIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('OF checkVRIndex good values', () {
      system.throwOnError = false;
      expect(OF.checkVRIndex(kOFIndex), equals(kOFIndex));

      for (var tag in ofTags) {
        system.throwOnError = false;
        expect(OF.checkVRIndex(tag.vrIndex), equals(tag.vrIndex));
      }
    });

    test('OF checkVRIndex bad values', () {
      system.throwOnError = false;
      expect(OF.checkVRIndex(kATIndex), isNull);

      system.throwOnError = true;
      expect(() => OF.checkVRIndex(kATIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OF.checkVRIndex(tag.vrIndex), isNull);

        system.throwOnError = true;
        expect(() => OF.checkVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('OF checkVRCode good values', () {
      system.throwOnError = false;
      expect(OF.checkVRCode(kOFCode), equals(kOFCode));

      for (var tag in ofTags) {
        system.throwOnError = false;
        expect(OF.checkVRCode(tag.vrCode), equals(tag.vrCode));
      }
    });

    test('OF checkVRCode bad values', () {
      system.throwOnError = false;
      expect(OF.checkVRCode(kATCode), isNull);

      system.throwOnError = true;
      expect(() => OF.checkVRCode(kATCode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        system.throwOnError = false;
        expect(OF.checkVRCode(tag.vrCode), isNull);

        system.throwOnError = true;
        expect(() => OF.checkVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });
*/

    test('OF isValidVFLength good values', () {
      expect(OF.isValidVFLength(OF.kMaxVFLength), true);
      expect(OF.isValidVFLength(0), true);
    });

    test('OF isValidVFLength bad values', () {
      expect(OF.isValidVFLength(OF.kMaxVFLength + 1), false);
      expect(OF.isValidVFLength(-1), false);
    });

    test('OF isValidValues', () {
      global.throwOnError = false;
      //VM.k1
      for (var i = 0; i <= listFloat32Common0.length - 1; i++) {
        expect(
            OF.isValidValues(
                PTag.kVectorGridData, <double>[listFloat32Common0[i]]),
            true);
      }

      //VM.k1_n
      expect(OF.isValidValues(PTag.kSelectorOFValue, listFloat32Common0), true);
    });

    test('Float32Base.fromList', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        expect(Float32.fromList(vList), vList);
      }
    });

    test('Float32Base.fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final float = new Float32List.fromList(vList);
        final bd = float.buffer.asUint8List();
        expect(Float32.fromUint8List(bd), equals(vList));
      }
      final float0 = new Float32List.fromList(<double>[]);
      final bd0 = float0.buffer.asUint8List();
      expect(Float32.fromUint8List(bd0), equals(<double>[]));
    });

    test('Float32Base.toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final float32List0 = new Float32List.fromList(vList);
        final uInt8List0 = float32List0.buffer.asUint8List();
        //final s0 = base64.encode(uInt8List0);
        expect(Float32.toBytes(float32List0), equals(uInt8List0));
      }
    });

    test('Float32Base.fromBase64', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(0, i);
        final float32List0 = new Float32List.fromList(vList);
        final uInt8List0 = float32List0.buffer.asUint8List();
        final s0 = base64.encode(uInt8List0);
        final e0 = Float32.fromBase64(s0);
        log
          ..debug('  vList: $vList')
          ..debug('float32List0: $float32List0')
          ..debug('         e0: $e0');
        expect(e0, equals(vList));
        expect(e0, equals(float32List0));
      }
    });

    test('Float32Base.toBase64', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.float32List(0, i);
        final bList0 = vList0.buffer.asUint8List();
        final s0 = base64.encode(bList0);
        final s1 = Float32.toBase64(vList0);
        expect(s1, equals(s0));
      }
    });

    test('OF encodeDecodeJsonVF', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.float32List(1, i);
        final bList0 = vList0.buffer.asUint8List();

        // Encode
        final s0 = base64.encode(bList0);
        log.debug('OF.base64: "$base64"');
        final s1 = Float32.toBase64(vList0);
        log.debug('  OF.json: "$s1"');
        expect(s1, equals(s0));

        // Decode
        final vList1 = Float32.fromBase64(s0);
        log.debug('FL.base64: $vList1');
        final vList2 = Float32.fromBase64(s1);
        log.debug('  OF.json: $vList2');
        expect(vList1, equals(vList0));
        expect(vList2, equals(vList0));
        expect(vList2, equals(vList1));
      }
    });

    test('Float32Base.fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final float = new Float32List.fromList(vList);
        final bd = float.buffer.asUint8List();
        expect(Float32.fromUint8List(bd), equals(vList));
      }
      final float0 = new Float32List.fromList(<double>[]);
      final bd0 = float0.buffer.asUint8List();
      expect(Float32.fromUint8List(bd0), equals(<double>[]));
    });

    test('Float32Base.fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.float32List(1, 1);
        final float = new Float32List.fromList(vList);
        final byteData0 = float.buffer.asByteData();
        expect(Float32.fromByteData(byteData0), equals(vList));
      }
      final float0 = new Float32List.fromList(<double>[]);
      final bd0 = float0.buffer.asByteData();
      expect(Float32.fromByteData(bd0), equals(<double>[]));
    });
  });
}
