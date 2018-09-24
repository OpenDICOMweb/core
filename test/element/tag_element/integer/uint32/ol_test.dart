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
  Server.initialize(name: 'element/ol_test', level: Level.info);
  final rng = RNG(1);
  global.throwOnError = false;

  group('OL', () {
    const uInt32MinMax = const [kUint32Min, kUint32Max];
    const uInt32Max = const [kUint32Max];
    const uInt32MaxPlus = const [kUint32Max + 1];
    const uInt32Min = const [kUint32Min];
    const uInt32MinMinus = const [kUint32Min - 1];

    test('OL hasValidValues random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final e0 = OLtag(PTag.kLongPrimitivePointIndexList, vList0);
        log.debug('e0: e0');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: e0');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 10);
        final e0 = OLtag(PTag.kSelectorOLValue, vList0);
        log.debug('e0: e0');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: e0');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(2, 3);
        log.debug('$i: vList0: $vList0');
        final e0 = OLtag(PTag.kLongPrimitivePointIndexList, vList0);
        expect(e0.hasValidValues, true);
      }
    });

    test('OL hasValidValues good values', () {
      global.throwOnError = false;
      final e0 = OLtag(PTag.kLongPrimitivePointIndexList, uInt32Max);
      final e1 = OLtag(PTag.kLongPrimitivePointIndexList, uInt32Max);
      expect(e0.hasValidValues, true);
      expect(e1.hasValidValues, true);

      final e2 = OLtag(PTag.kLongPrimitivePointIndexList, uInt32Max);
      final e3 = OLtag(PTag.kLongPrimitivePointIndexList, uInt32Max);
      expect(e2.hasValidValues, true);
      expect(e3.hasValidValues, true);

      global.throwOnError = false;
      final e4 = OLtag(PTag.kLongVertexPointIndexList, []);
      expect(e4.hasValidValues, true);
      log.debug('e4:e4');
      expect(e4.values, equals(<int>[]));
    });

    test('OL hasValidValues bad values', () {
      final e0 = OLtag(PTag.kLongPrimitivePointIndexList, uInt32MaxPlus);
      expect(e0, isNull);

      final e1 = OLtag(PTag.kLongPrimitivePointIndexList, uInt32MinMinus);
      expect(e1, isNull);

      final e2 = OLtag(PTag.kLongPrimitivePointIndexList, uInt32MinMax);
      expect(e2.hasValidValues, true);

      global.throwOnError = false;
      final e3 = OLtag(PTag.kLongPrimitivePointIndexList, uInt32Max);
      final uint64List0 = rng.uint64List(1, 1);
      e3.values = uint64List0;
      expect(e3.hasValidValues, false);

      global.throwOnError = true;
      expect(() => e3.hasValidValues,
          throwsA(const TypeMatcher<InvalidValuesError>()));

      global.throwOnError = false;
      final e4 = OLtag(PTag.kLongVertexPointIndexList, null);
      log.debug('e4: $e4');
      expect(e4.hasValidValues, true);
      expect(e4.values, kEmptyUint32List);

      global.throwOnError = true;
      final e5 = OLtag(PTag.kLongVertexPointIndexList, null);
      log.debug('e5: $e5');
      expect(e5.hasValidValues, true);
      expect(e5.values, kEmptyUint32List);
    });

    test('OL update random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(3, 4);
        final e1 = OLtag(PTag.kTrackPointIndexList, vList0);
        final vList1 = rng.uint32List(3, 4);
        expect(e1.update(vList1).values, equals(vList1));
      }
    });

    test('OL update', () {
      final e0 = OLtag(PTag.kLongVertexPointIndexList, uInt32Min);
      final e1 = OLtag(PTag.kLongVertexPointIndexList, uInt32Min);
      final e2 = e0.update(uInt32Max);
      final e3 = e1.update(uInt32Max);
      expect(e0.values.first == e3.values.first, false);
      expect(e0 == e3, false);
      expect(e1 == e3, false);
      expect(e2 == e3, true);

      final e4 = OLtag(PTag.kTrackPointIndexList, []);
      expect(
          e4.update([76345748, 64357898]).values, equals([76345748, 64357898]));
    });

    test('OL noValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.uint32List(3, 4);
        final e1 = OLtag(PTag.kLongVertexPointIndexList, vList);
        log.debug('e1: ${e1.noValues}');
        expect(e1.noValues.values.isEmpty, true);
      }
    });

    test('OL noValues', () {
      final e0 = OLtag(PTag.kLongVertexPointIndexList, []);
      final OLtag olNoValues = e0.noValues;
      expect(olNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      final e1 = OLtag(PTag.kLongVertexPointIndexList, uInt32Max);
      final olNoValues0 = e1.noValues;
      expect(olNoValues0.values.isEmpty, true);
      log.debug('e1:${e1.noValues}');
    });

    test('OL copy random', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.uint32List(3, 4);
        final e2 = OLtag(PTag.kLongVertexPointIndexList, vList);
        final OLtag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('OL copy', () {
      final e0 = OLtag(PTag.kLongVertexPointIndexList, []);
      final OLtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      final e2 = OLtag(PTag.kLongVertexPointIndexList, uInt32Max);
      final e3 = e2.copy;
      expect(e2 == e3, true);
      expect(e2.hashCode == e3.hashCode, true);
    });

    test('OL hashCode and == good values random', () {
      global.throwOnError = false;
      final rng = RNG(1);

      List<int> vList0;
      for (var i = 0; i < 10; i++) {
        vList0 = rng.uint32List(1, 1);
        final e0 = OLtag(PTag.kLongVertexPointIndexList, vList0);
        final e1 = OLtag(PTag.kLongVertexPointIndexList, vList0);
        log
          ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
          ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('OL hashCode and == random bad values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final e0 = OLtag(PTag.kLongVertexPointIndexList, vList0);

        final vList1 = rng.uint32List(1, 1);
        final e2 = OLtag(PTag.kLongVertexPointIndexList, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rng.uint32List(2, 3);
        final e3 = OLtag(PTag.kFunctionalGroupPointer, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);
      }
    });

    test('OL hashCode and == good values', () {
      final e0 = OLtag(PTag.kLongVertexPointIndexList, uInt32Max);
      final e1 = OLtag(PTag.kLongVertexPointIndexList, uInt32Max);

      log
        ..debug('uInt32Max:$uInt32Max, e0.hash_code:${e0.hashCode}')
        ..debug('uInt32Max:$uInt32Max, e1.hash_code:${e1.hashCode}');
      expect(e0.hashCode == e1.hashCode, true);
      expect(e0 == e1, true);
    });

    test('OL hashCode and == bad values', () {
      final e0 = OLtag(PTag.kLongVertexPointIndexList, uInt32Max);

      final e2 = OLtag(PTag.kLongVertexPointIndexList, uInt32Min);
      log.debug('uInt32Min:$uInt32Min , e2.hash_code:${e2.hashCode}');
      expect(e0.hashCode == e2.hashCode, false);
      expect(e0 == e2, false);
    });

    test('OL fromBytes random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final bytes0 = Bytes.typedDataView(vList0);
        final e0 = OLtag.fromBytes(PTag.kLongVertexPointIndexList, bytes0);
        expect(e0.hasValidValues, true);
        expect(e0.vfBytes, equals(bytes0));
        expect(e0.values is Uint32List, true);
        expect(e0.values, equals(vList0));

        final vList1 = rng.uint32List(2, 2);
        final bytes1 = Bytes.typedDataView(vList1);
        final e2 = OLtag.fromBytes(PTag.kLongVertexPointIndexList, bytes1);
        expect(e2.hasValidValues, true);
      }
    });

    test('OL fromBytes', () {
      final vList0 = Uint32List.fromList(uInt32Max);
//      final uint8List1 = vList1.buffer.asUint8List();
      final bytes = Bytes.typedDataView(vList0);
      final e0 = OLtag.fromBytes(PTag.kLongVertexPointIndexList, bytes);
      expect(e0.hasValidValues, true);
      expect(e0.vfBytes, equals(bytes));
      expect(e0.values is Uint32List, true);
      expect(e0.values, equals(vList0));
    });

    test('OL fromBytes good values', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList = rng.uint32List(1, 10);
        final bytes = Bytes.typedDataView(vList);
        final e = OLtag.fromBytes(PTag.kSelectorOLValue, bytes);
        log.debug('e: $e');
        expect(e.hasValidValues, true);
      }
    });

    test('OL fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList = rng.uint32List(1, 10);
        final bytes0 = Bytes.fromAscii(vList.toString());
        final e0 = OLtag.fromBytes(PTag.kSelectorFDValue, bytes0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => OLtag.fromBytes(PTag.kSelectorFDValue, bytes0),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('OL checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final e0 = OLtag(PTag.kLongVertexPointIndexList, vList0);
        expect(e0.checkLength(e0.values), true);
      }
    });

    test('OL checkLength', () {
      final e0 = OLtag(PTag.kLongVertexPointIndexList, uInt32Max);
      expect(e0.checkLength(e0.values), true);
    });

    test('OL checkValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final e0 = OLtag(PTag.kLongVertexPointIndexList, vList0);
        expect(e0.checkValues(e0.values), true);
      }
    });

    test('OL checkValues', () {
      final e0 = OLtag(PTag.kLongVertexPointIndexList, uInt32Max);
      expect(e0.checkValues(e0.values), true);
    });

    test('OL valuesCopy random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final e0 = OLtag(PTag.kLongVertexPointIndexList, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('OL valuesCopy', () {
      final e0 = OLtag(PTag.kLongVertexPointIndexList, uInt32Max);
      expect(uInt32Max, equals(e0.valuesCopy));
    });

    test('OL replace random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final e0 = OLtag(PTag.kLongVertexPointIndexList, vList0);
        final vList1 = rng.uint32List(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rng.uint32List(1, 1);
      final e1 = OLtag(PTag.kLongVertexPointIndexList, vList1);
      expect(e1.replace(<int>[]), equals(vList1));
      expect(e1.values, equals(<int>[]));

      final e2 = OLtag(PTag.kLongVertexPointIndexList, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(<int>[]));
    });

    test('OL BASE64 random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        final bytes0 = Bytes.typedDataView(vList0);
        final base64 = bytes0.getBase64();
        final bytes1 = Bytes.fromBase64(base64);
        final e0 = OLtag.fromBytes(PTag.kLongVertexPointIndexList, bytes1);
        expect(e0.hasValidValues, true);
      }
    });

    test('OL BASE64', () {
      final vList1 = Uint32List.fromList(uInt32Max);
      final uInt8List1 = vList1.buffer.asUint8List();
      final bytes0 = Bytes.typedDataView(uInt8List1);
      final s = bytes0.getBase64();
      final bytes1 = Bytes.fromBase64(s);
      final e0 = OLtag.fromBytes(PTag.kLongVertexPointIndexList, bytes1);
      expect(e0.hasValidValues, true);
    });

    test('OL fromValues', () {
      for (var i = 0; i < 10; i++) {
        final vList = rng.uint32List(1, 1);
        final e = OLtag.fromValues(PTag.kLongVertexPointIndexList, vList);
        expect(e.hasValidValues, true);
      }
    });

    test('OL checkValue good values', () {
      final vList0 = rng.uint32List(1, 1);
      final e0 = OLtag(PTag.kLongVertexPointIndexList, vList0);

      expect(e0.checkValue(uInt32Max[0]), true);
      expect(e0.checkValue(uInt32Min[0]), true);
    });

    test('OL checkValue bad values', () {
      final vList0 = rng.uint32List(1, 1);
      final e0 = OLtag(PTag.kLongVertexPointIndexList, vList0);

      expect(e0.checkValue(uInt32MaxPlus[0]), false);
      expect(e0.checkValue(uInt32MinMinus[0]), false);
    });

    test('OL view', () {
      final vList = rng.uint32List(10, 10);
      final e0 = OLtag(PTag.kSelectorOLValue, vList);
      for (var i = 0, j = 0; i < vList.length; i++, j += 4) {
        final e1 = e0.view(j, vList.length - i);
        log.debug('e0: ${e0.values}, e1: ${e1.values}, '
            'vList0.sublist(i) : ${vList.sublist(i)}');
        expect(e1.values, equals(vList.sublist(i)));
      }

      final bytes = Bytes.typedDataView(vList);
      final e2 = OLtag.fromBytes(PTag.kSelectorOLValue, bytes);
      for (var i = 0, j = 0; i < vList.length; i++, j += 4) {
        final e3 = e2.view(j, vList.length - i);
        log.debug('e: ${e0.values}, at1: ${e3.values}, '
            'vList.sublist(i) : ${vList.sublist(i)}');
        expect(e3.values, equals(vList.sublist(i)));
      }
    });

    test('OL equal', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.uint32List(1, i);
        final bytesA = Bytes.typedDataView(vList);
        final bytesB = Bytes.typedDataView(vList);

        final vList0 = rng.uint32List(2, 2);
        final bytesC = Bytes.typedDataView(vList0);

        final e0 = OLtag.fromBytes(PTag.kSelectorOLValue, bytesA);
        final equal0 = e0.equal(bytesA, bytesB);
        expect(equal0, true);

        final equal1 = e0.equal(bytesA, bytesC);
        expect(equal1, false);
      }
    });
  });

  group('OL Element', () {
    //VM.k1
    const olVM1Tags = const <PTag>[
      PTag.kLongPrimitivePointIndexList,
      PTag.kLongTrianglePointIndexList,
      PTag.kLongEdgePointIndexList,
      PTag.kLongVertexPointIndexList,
      PTag.kTrackPointIndexList,
    ];

    //VM.k1_n
    const olVM1_nTags = const <PTag>[PTag.kSelectorOLValue];

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

    test('OL isValidVFLength', () {
      global.throwOnError = false;

      expect(OL.isValidVFLength(OL.kMaxVFLength), true);
      expect(OL.isValidVFLength(0), true);
    });

    test('OL isValidTag good values', () {
      global.throwOnError = false;
      expect(OL.isValidTag(PTag.kSelectorOLValue), true);

      for (var tag in olVM1Tags) {
        expect(OL.isValidTag(tag), true);
      }
    });

    test('OL isValidTag bad values', () {
      global.throwOnError = false;
      expect(OL.isValidTag(PTag.kSelectorUSValue), false);

      global.throwOnError = true;
      expect(() => OL.isValidTag(PTag.kSelectorUSValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OL.isValidTag(tag), false);

        global.throwOnError = true;
        expect(() => OL.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('OL isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(OL.isValidVRIndex(kOLIndex), true);

      for (var tag in olVM1Tags) {
        global.throwOnError = false;
        expect(OL.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('OL isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(OL.isValidVRIndex(kOLIndex), true);

      for (var tag in olVM1_nTags) {
        global.throwOnError = false;
        expect(OL.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('OL isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(OL.isValidVRIndex(kCSIndex), false);

      global.throwOnError = true;
      expect(() => OL.isValidVRIndex(kCSIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OL.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => OL.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('OL isValidVRCode good values', () {
      global.throwOnError = false;
      expect(OL.isValidVRCode(kOLCode), true);

      for (var tag in olVM1Tags) {
        expect(OL.isValidVRCode(tag.vrCode), true);
      }
    });

    test('OL isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(OL.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => OL.isValidVRCode(kAECode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(OL.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => OL.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('OL isValidVFLength good values', () {
      expect(OL.isValidVFLength(OL.kMaxVFLength), true);
      expect(OL.isValidVFLength(0), true);

      expect(OL.isValidVFLength(OL.kMaxVFLength, null, PTag.kSelectorOLValue),
          true);
    });

    test('OL isValidVFLength bad values', () {
      global.throwOnError = false;
      expect(OL.isValidVFLength(OL.kMaxVFLength + 1), false);
      expect(OL.isValidVFLength(-1), false);
    });

    test('OL isValidValue good values', () {
      expect(OL.isValidValue(OL.kMinValue), true);
      expect(OL.isValidValue(OL.kMaxValue), true);
    });

    test('OL isValidValue bad values', () {
      expect(OL.isValidValue(OL.kMinValue - 1), false);
      expect(OL.isValidValue(OL.kMaxValue + 1), false);
    });

    test('OL isValidValues good values', () {
      global.throwOnError = false;
      const uInt32MinMax = const [kUint32Min, kUint32Max, kUint16Max];
      const uInt32Min = const [kUint32Min];
      const uInt32Max = const [kUint32Max];

      //VM.k1
      expect(OL.isValidValues(PTag.kTrackPointIndexList, uInt32Min), true);
      expect(OL.isValidValues(PTag.kTrackPointIndexList, uInt32Max), true);

      //VM.k1_n
      expect(OL.isValidValues(PTag.kSelectorOLValue, uInt32MinMax), true);
      expect(OL.isValidValues(PTag.kSelectorOLValue, uInt32Max), true);
      expect(OL.isValidValues(PTag.kSelectorOLValue, uInt32Min), true);
    });

    test('OL isValidValues bad values', () {
      global.throwOnError = false;
      const uInt32MaxPlus = const [kUint32Max + 1];
      const uInt32MinMinus = const [kUint32Min - 1];

      //VM.k1
      expect(OL.isValidValues(PTag.kTrackPointIndexList, uInt32MaxPlus), false);
      expect(
          OL.isValidValues(PTag.kTrackPointIndexList, uInt32MinMinus), false);

      global.throwOnError = true;
      expect(() => OL.isValidValues(PTag.kTrackPointIndexList, uInt32MaxPlus),
          throwsA(const TypeMatcher<InvalidValuesError>()));
      expect(() => OL.isValidValues(PTag.kTrackPointIndexList, uInt32MinMinus),
          throwsA(const TypeMatcher<InvalidValuesError>()));

      global.throwOnError = false;
      expect(OL.isValidValues(PTag.kTrackPointIndexList, null), false);
    });

    test('OL isValidBytesArgs', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint32List(1, i);
        final vfBytes = Bytes.typedDataView(vList0);

        if (vList0.length == 1) {
          for (var tag in olVM1Tags) {
            final e0 = OL.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else {
          for (var tag in olVM1_nTags) {
            final e0 = OL.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        }
      }
      final vList0 = rng.uint32List(1, 1);
      final vfBytes = Bytes.typedDataView(vList0);

      final e1 = OL.isValidBytesArgs(null, vfBytes);
      expect(e1, false);

      final e2 = OL.isValidBytesArgs(PTag.kDate, vfBytes);
      expect(e2, false);

      final e3 = OL.isValidBytesArgs(PTag.kSelectorOLValue, null);
      expect(e3, false);

      global.throwOnError = true;
      expect(() => OL.isValidBytesArgs(null, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => OL.isValidBytesArgs(PTag.kDate, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));
    });
  });
}
