//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:convert';

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = new RSG(seed: 1);

void main() {
  Server.initialize(name: 'string/is_test', level: Level.info);
  global.throwOnError = false;

  const goodIntegerStrings = const <String>[
    '+8',
    ' +8',
    '+8 ',
    ' +8 ',
    '-8',
    ' -8',
    '-8 ',
    ' -8 ',
    '-6',
    '560',
    '0',
    '-67',
  ];

  group('Integer String Tests', () {
    test('Is valid integer string -  good values', () {
      global.level = Level.info;
      for (var s in goodIntegerStrings) {
        global.throwOnError = false;
        log.debug('s: "$s"');
        final n = IS.tryParse(s);
        log.debug('n: $n');
        expect(n, isNotNull);
        expect(DS.isValidValue(s), true);
      }
    });
  });

  const goodISList = const <List<String>>[
    const <String>['+8'],
    const <String>['-6'],
    const <String>['560'],
    const <String>['0'],
    const <String>['-67'],
  ];
  const badISList = const <List<String>>[
    const <String>['\b'],
    //	Backspace
    const <String>['\t '],
    //horizontal tab (HT)
    const <String>['\n'],
    //linefeed (LF)
    const <String>['\f '],
    // form feed (FF)
    const <String>['\r '],
    //carriage return (CR)
    const <String>['\v'],
    //vertical tab
    const <String>[r'\'],
    const <String>['B\\S'],
    const <String>['1\\9'],
    const <String>['a\\4'],
    const <String>[r'^`~\\?'],
    const <String>[r'^\?'],
    const <String>['abc'],
    const <String>['23.34']
  ];

  const badISLengthValues = const <List<String>>[
    const <String>['+823434534645645654'],
    const <String>['234345343400098090'],
  ];

  const badISLengthList = const <List<String>>[
    const <String>['+823434534645645654', '823434534645645654'],
    const <String>['234345343400098090', '35345435']
  ];

  group('IStag', () {
    test('IS hasValidValues good values', () {
      for (var s in goodISList) {
        global.throwOnError = false;
        final e0 = new IStag(PTag.kSeriesNumber, s);
        expect(e0.hasValidValues, true);
      }

      final e2 = new IStag(PTag.kOtherStudyNumbers, []);
      expect(e2.hasValidValues, true);
      expect(e2.values, equals(<String>[]));
    });

    test('IS hasValidValues bad values', () {
      for (var s in badISList) {
        global.throwOnError = false;
        final e0 = new IStag(PTag.kSeriesNumber, s);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => new IStag(PTag.kSeriesNumber, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });
    test('IS hasValidValues good values random', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(1, 1);
        final e0 = new IStag(PTag.kSeriesNumber, vList0);
        log.debug('e0:${e0.info}');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: ${e0.info}');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(1, 1);
        final e0 = new IStag(PTag.kAcquisitionNumber, vList0);
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: ${e0.info}');
        expect(e0[0], equals(vList0[0]));
      }
    });

    test('IS hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getISList(3, 4);
        log.debug('$i: vList0: $vList0');
        final e0 = new IStag(PTag.kSeriesNumber, vList0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => new IStag(PTag.kSeriesNumber, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final e2 = new IStag(PTag.kOtherStudyNumbers, null);
      log.debug('e2: $e2');
      expect(e2.hasValidValues, true);
      expect(e2.values, StringList.kEmptyList);

      global.throwOnError = true;
      expect(() => new IStag(PTag.kOtherStudyNumbers, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('IS update random', () {
      global.throwOnError = false;
      final e0 = new IStag(PTag.kOtherStudyNumbers, []);
      expect(e0.update(['+3, -3, -1']), isNull);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(3, 4);
        final e2 = new IStag(PTag.kOtherStudyNumbers, vList0);
        final vList1 = rsg.getISList(3, 4);
        expect(e2.update(vList1).values, equals(vList1));
      }
    });

    test('IS noValues random', () {
      final e0 = new IStag(PTag.kOtherStudyNumbers, []);
      final IStag isNoValues = e0.noValues;
      expect(isNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(3, 4);
        final ds0 = new IStag(PTag.kOtherStudyNumbers, vList0);
        log.debug('ds0: $ds0');
        expect(isNoValues.values.isEmpty, true);
        log.debug('ds0: ${ds0.noValues}');
      }
    });

    test('IS copy random', () {
      final e0 = new IStag(PTag.kOtherStudyNumbers, []);
      final IStag e2 = e0.copy;
      expect(e2 == e0, true);
      expect(e2.hashCode == e0.hashCode, true);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(3, 4);
        final e2 = new IStag(PTag.kOtherStudyNumbers, vList0);
        final IStag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('IS hashCode and == good values random', () {
      List<String> vList0;

      for (var i = 0; i < 10; i++) {
        vList0 = rsg.getISList(1, 1);
        final e0 = new IStag(PTag.kMemoryAllocation, vList0);
        final e2 = new IStag(PTag.kMemoryAllocation, vList0);
        log
          ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
          ..debug('vList0:$vList0, e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, true);
        expect(e0 == e2, true);
      }
    });

    test('IS hashCode and == bad  values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(1, 1);
        final e0 = new IStag(PTag.kMemoryAllocation, vList0);
        final vList1 = rsg.getISList(1, 1);
        final e2 = new IStag(PTag.kNumberOfFilms, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rsg.getISList(2, 2);
        final e3 = new IStag(PTag.kCenterOfCircularShutter, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);

        final vList3 = rsg.getISList(3, 3);
        final e4 = new IStag(PTag.kROIDisplayColor, vList3);
        log.debug('vList3:$vList3 , e4.hash_code:${e4.hashCode}');
        expect(e0.hashCode == e4.hashCode, false);
        expect(e0 == e4, false);

        final vList4 = rsg.getISList(2, 8);
        final e5 = new IStag(PTag.kVerticesOfThePolygonalShutter, vList4);
        log.debug('vList4:$vList4 , e5.hash_code:${e5.hashCode}');
        expect(e0.hashCode == e5.hashCode, false);
        expect(e0 == e5, false);

        final vList5 = rsg.getISList(2, 3);
        final e6 = new IStag(PTag.kNumberOfFilms, vList5);
        log.debug('vList5:$vList5 , e6.hash_code:${e6.hashCode}');
        expect(e0.hashCode == e6.hashCode, false);
        expect(e0 == e6, false);
      }
    });

    test('IS valuesCopy ranodm', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(2, 2);
        final e0 = new IStag(PTag.kPresentationPixelAspectRatio, vList0);
        expect(vList0, equals(e0.valuesCopy));
      }
    });

    test('IS isValidLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(2, 2);
        final e0 = new IStag(PTag.kPresentationPixelAspectRatio, vList0);
        expect(e0.tag.isValidLength(e0), true);
      }
    });

    test('IS isValidValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(2, 2);
        final e0 = new IStag(PTag.kPresentationPixelAspectRatio, vList0);
        expect(e0.checkValues(e0.values), true);
        expect(e0.hasValidValues, true);
      }
    });

    test('IS replace random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(1, 1);
        final e0 = new IStag(PTag.kWaveformChannelNumber, vList0);
        final vList1 = rsg.getISList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getISList(1, 1);
      final e2 = new IStag(PTag.kWaveformChannelNumber, vList1);
      expect(e2.replace([]), equals(vList1));
      expect(e2.values, equals(<String>[]));

      final e3 = new IStag(PTag.kWaveformChannelNumber, vList1);
      expect(e3.replace(null), equals(vList1));
      expect(e3.values, equals(<String>[]));
    });

    test('IS blank random', () {
      global.throwOnError = false;
      final vList1 = rsg.getISList(2, 2);
      final e0 = new IStag(PTag.kPresentationPixelSpacing, vList1);
      expect(e0, isNull);
    });

    test('IS fromUint8List', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getISList(1, 1);
        final bytes = Bytes.fromAsciiList(vList1);
        log.debug('bytes:$bytes');
        final e2 = IStag.fromBytes(PTag.kWaveformChannelNumber, bytes);
        log.debug('e2: ${e2.info}');
        expect(e2.hasValidValues, true);
      }
    });

    test('IS fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getISList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          final ur1 = IStag.fromBytes(PTag.kSelectorISValue, bytes0);
          log.debug('ur1: ${ur1.info}');
          expect(ur1.hasValidValues, true);
        }
      }
    });

    test('IS fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getISList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.fromAscii(listS);
          final ur1 = IStag.fromBytes(PTag.kSelectorAEValue, bytes0);
          expect(ur1, isNull);

          global.throwOnError = true;
          expect(() => IStag.fromBytes(PTag.kSelectorAEValue, bytes0),
              throwsA(const TypeMatcher<InvalidTagError>()));
        }
      }
    });

    test('IS fromValues good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(1, 1);
        final e0 = IStag.fromValues(PTag.kWaveformChannelNumber, vList0);
        log.debug('e0: ${e0.info}');
        expect(e0.hasValidValues, true);

        global.throwOnError = false;
        final e1 = IStag.fromValues(PTag.kWaveformChannelNumber, <String>[]);
        expect(e1.hasValidValues, true);
        expect(e1.values, equals(<String>[]));
      }
    });

    test('IS fromValues bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(2, 2);
        global.throwOnError = false;
        final e0 = IStag.fromValues(PTag.kWaveformChannelNumber, vList0);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => IStag.fromValues(PTag.kWaveformChannelNumber, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }

      global.throwOnError = true;
      expect(
          () => IStag.fromValues(PTag.kWaveformChannelNumber, <String>[null]),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('IS checkLength good values', () {
      final vList0 = rsg.getISList(1, 1);
      final e0 = new IStag(PTag.kWaveformChannelNumber, vList0);
      for (var s in goodISList) {
        expect(e0.checkLength(s), true);
      }
      final e2 = new IStag(PTag.kWaveformChannelNumber, vList0);
      expect(e2.checkLength([]), true);
    });

    test('IS checkLength bad values', () {
      final vList0 = rsg.getISList(1, 1);
      final vList1 = ['+8', '-6'];
      final e0 = new IStag(PTag.kStopTrim, vList0);
      expect(e0.checkLength(vList1), false);
    });

    test('IS checkValue good values', () {
      final vList0 = rsg.getISList(1, 1);
      final e0 = new IStag(PTag.kStopTrim, vList0);
      for (var s in goodISList) {
        for (var a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });

    test('IS checkValue bad values', () {
      final vList0 = rsg.getISList(1, 1);
      final e0 = new IStag(PTag.kStopTrim, vList0);
      for (var s in badISList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(e0.checkValue(a), false);
        }
      }
    });

    test('IS hashStringList', () {
      global.throwOnError = false;
      final vList0 = rsg.getISList(1, 1);
      final e0 = new IStag(PTag.kEchoNumbers);
      expect(e0.hashStringList(vList0), isNotNull);
    });

    test('IS compare', () {
      for (var i = 1; i <= 10; i++) {
        final vList0 = rsg.getISList(1, 1);
        final e0 = new IStag(PTag.kEchoNumbers, vList0);
        final compare0 = e0.compare(int.parse(e0.value));
        log.debug('compare0: $compare0');
        expect(compare0 == 0, true);
      }
      for (var vList1 in goodISList) {
        final e1 = new IStag(PTag.kEchoNumbers, vList1);
        final compare1 = e1.compare(int.parse(e1.value));
        log.debug('compare1: $compare1');
        expect(compare1 == 0, true);
      }

      final vList2 = rsg.getISList(1, 1);
      final e2 = new IStag(PTag.kEchoNumbers, vList2);
      for (var n in goodIntegerStrings) {
        final compare2 = e2.compare(int.parse(n));
        log.debug('compare2: $compare2');
        if (!compare2.isNegative) {
          expect(compare2 == 1, true);
        } else {
          expect(compare2 == -1, true);
        }
      }

      for (var i = 1; i <= 10; i++) {
        final vList3 = rsg.getISList(1, i);
        final e3 = new IStag(PTag.kSelectorISValue, vList3);
        final compare3 = e3.compare(int.parse(e3.value));
        log.debug('compare0: $compare3');
        if (vList3.length > 1) {
          expect(compare3, isNull);
        } else {
          expect(compare3 == 0, true);
        }
      }

      final e4 = new IStag(PTag.kSelectorISValue, []);
      final compare4 = e4.compare(15);
      expect(compare4, isNull);
    });

    test('IS increment', () {
      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getISList(1, 1);
        final e0 = new IStag(PTag.kStageNumber, vList0);
        final increment0 = e0.increment();
        log.debug('increment0: $increment0');
        expect(increment0.hasValidValues, true);
      }
    });

    test('IS decrement', () {
      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getISList(1, 1);
        final e0 = new IStag(PTag.kStageNumber, vList0);
        final decrement0 = e0.decrement();
        log.debug('decrement0: $decrement0');
        expect(decrement0.hasValidValues, true);
      }
    });
  });

  group('IS Element', () {
    //VM.k1
    const isVM1Tags = const <PTag>[
      PTag.kStageNumber,
      PTag.kNumberOfStages,
      PTag.kViewNumber,
      PTag.kNumberOfViewsInStage,
      PTag.kStartTrim,
      PTag.kStopTrim,
      PTag.kEvaluatorNumber,
      PTag.kNumberOfContourPoints,
      PTag.kObservationNumber,
      PTag.kCurrentFractionNumber,
    ];

    //VM.k2
    const isVM2Tags = const <PTag>[
      PTag.kCenterOfCircularShutter,
      PTag.kCenterOfCircularCollimator,
      PTag.kGridAspectRatio,
      PTag.kPixelAspectRatio,
      PTag.kAxialMash,
      PTag.kPresentationPixelAspectRatio,
    ];

    //VM.k2_2n
    const isVM2_2nTags = const <PTag>[
      PTag.kVerticesOfThePolygonalShutter,
      PTag.kVerticesOfThePolygonalCollimator,
      PTag.kVerticesOfTheOutlineOfPupil,
    ];

    //VM.k3
    const isVM3Tags3 = const <PTag>[
      PTag.kROIDisplayColor,
    ];

    //VM.k1_n
    const isVM1_nTags = const <PTag>[
      PTag.kReferencedFrameNumber,
      PTag.kTransformOrderOfAxes,
      PTag.kEchoNumbers,
      PTag.kUpperLowerPixelValues,
      PTag.kSelectorISValue,
      PTag.kSelectorSequencePointerItems,
    ];

    const otherTags = const <PTag>[
      PTag.kColumnAngulationPatient,
      PTag.kAcquisitionProtocolDescription,
      PTag.kCTDIvol,
      PTag.kCTPositionSequence,
      PTag.kAcquisitionType,
      PTag.kPerformedStationAETitle,
      PTag.kSelectorSTValue,
      PTag.kDate,
      PTag.kTime
    ];

    final badLengthList = rsg.getISList(IS.kMaxLength + 1, IS.kMaxLength + 1);

    test('IS isValidTag good values', () {
      global.throwOnError = false;
      expect(IS.isValidTag(PTag.kSelectorISValue), true);

      for (var tag in isVM1Tags) {
        final validT0 = IS.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('IS isValidTag bad values', () {
      global.throwOnError = false;
      expect(IS.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => IS.isValidTag(PTag.kSelectorFDValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = IS.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => IS.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('IS isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(IS.isValidVRIndex(kISIndex), true);

      for (var tag in isVM1Tags) {
        global.throwOnError = false;
        expect(IS.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('IS isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(IS.isValidVRIndex(kSSIndex), false);

      global.throwOnError = true;
      expect(() => IS.isValidVRIndex(kSSIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));
      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(IS.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => IS.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('IS isValidVRCode good values', () {
      global.throwOnError = false;
      expect(IS.isValidVRCode(kISCode), true);

      for (var tag in isVM1Tags) {
        expect(IS.isValidVRCode(tag.vrCode), true);
      }
    });

    test('IS isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(IS.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => IS.isValidVRCode(kAECode),
          throwsA(const TypeMatcher<InvalidVRError>()));
      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(IS.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => IS.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('IS isValidVFLength good values', () {
      expect(IS.isValidVFLength(IS.kMaxVFLength), true);
      expect(IS.isValidVFLength(0), true);

      expect(IS.isValidVFLength(IS.kMaxVFLength, null, PTag.kSelectorISValue),
          true);
    });

    test('IS isValidVFLength bad values', () {
      expect(IS.isValidVFLength(IS.kMaxVFLength + 1), false);
      expect(IS.isValidVFLength(-1), false);

      expect(IS.isValidVFLength(IS.kMaxVFLength, null, PTag.kSelectorSTValue),
          false);
    });

    test('IS isValidVListLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getISList(1, 1);
        for (var tag in isVM1Tags) {
          expect(IS.isValidLength(tag, vList), true);

          expect(IS.isValidLength(tag, badLengthList.take(tag.vmMax)), true);
          expect(IS.isValidLength(tag, badLengthList.take(tag.vmMin)), true);
        }
      }
    });

    test('IS isValidVListLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getISList(2, i + 1);
        for (var tag in isVM1Tags) {
          global.throwOnError = false;
          expect(IS.isValidLength(tag, vList), false);

          expect(IS.isValidLength(tag, badLengthList), false);

          global.throwOnError = true;
          expect(() => IS.isValidLength(tag, vList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
      global.throwOnError = false;
      final vList0 = rsg.getISList(1, 1);
      expect(LO.isValidLength(null, vList0), false);

      expect(LO.isValidLength(PTag.kSelectorLOValue, null), isNull);

      global.throwOnError = true;
      expect(() => LO.isValidLength(null, vList0),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => LO.isValidLength(PTag.kSelectorLOValue, null),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('IS isValidVListLength VM.k2 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getISList(2, 2);
        for (var tag in isVM2Tags) {
          expect(IS.isValidLength(tag, vList), true);

          expect(IS.isValidLength(tag, badLengthList.take(tag.vmMax)), true);
          expect(IS.isValidLength(tag, badLengthList.take(tag.vmMin)), true);
        }
      }
    });

    test('IS isValidVListLength VM.k2 bad values', () {
      for (var i = 2; i < 10; i++) {
        final vList = rsg.getISList(3, i + 1);
        for (var tag in isVM2Tags) {
          global.throwOnError = false;
          expect(IS.isValidLength(tag, vList), false);

          expect(
              IS.isValidLength(tag, badLengthList.take(tag.vmMax + 1)), false);
          expect(
              IS.isValidLength(tag, badLengthList.take(tag.vmMin - 1)), false);

          expect(IS.isValidLength(tag, badLengthList), false);

          global.throwOnError = true;
          expect(() => IS.isValidLength(tag, vList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('IS isValidVListLength VM.k2_2n good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        for (var tag in isVM2_2nTags) {
          final validMinVList = rsg.getISList(2, 2);
          final validMaxVList = badLengthList.sublist(0, tag.maxValues);
          expect(IS.isValidLength(tag, validMinVList), true);

          expect(
              IS.isValidLength(tag, badLengthList.take(tag.vmMax + 3)), false);
          expect(IS.isValidLength(tag, validMaxVList), true);
        }
      }
    });

    test('IS isValidVListLength VM.k2_2n bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getISList(1, 1);
        for (var tag in isVM2_2nTags) {
          global.throwOnError = false;
          expect(IS.isValidLength(tag, vList), false);

          expect(
              IS.isValidLength(tag, badLengthList.take(tag.vmMax + 2)), false);
          global.throwOnError = true;
          expect(() => IS.isValidLength(tag, vList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('IS isValidVListLength VM.k3 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getISList(3, 3);
        for (var tag in isVM3Tags3) {
          expect(IS.isValidLength(tag, vList), true);

          expect(IS.isValidLength(tag, badLengthList.take(tag.vmMax)), true);
          expect(IS.isValidLength(tag, badLengthList.take(tag.vmMin)), true);
        }
      }
    });

    test('IS isValidVListLength VM.k3 bad values', () {
      for (var i = 3; i < 10; i++) {
        final vList = rsg.getISList(4, i + 1);
        for (var tag in isVM3Tags3) {
          global.throwOnError = false;
          expect(IS.isValidLength(tag, vList), false);

          expect(
              IS.isValidLength(tag, badLengthList.take(tag.vmMax + 1)), false);
          expect(
              IS.isValidLength(tag, badLengthList.take(tag.vmMin - 1)), false);
          expect(IS.isValidLength(tag, badLengthList), false);

          global.throwOnError = true;
          expect(() => IS.isValidLength(tag, vList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('IS isValidVListLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getISList(1, i);
        final validMaxLengthList = badLengthList.sublist(0, IS.kMaxLength);
        for (var tag in isVM1_nTags) {
          log.debug('tag: $tag');
          expect(IS.isValidLength(tag, vList0), true);
          expect(IS.isValidLength(tag, validMaxLengthList), true);
        }
      }
    });

    test('IS isValidValueLength good values', () {
      for (var s in goodISList) {
        for (var a in s) {
          expect(IS.isValidValueLength(a), true);
        }
      }
    });

    test('IS isValidValueLength bad values', () {
      for (var s in badISLengthValues) {
        for (var a in s) {
          expect(IS.isValidValueLength(a), false);
        }
      }
    });

    test('IS isValidValue good values', () {
      for (var s in goodISList) {
        for (var a in s) {
          expect(IS.isValidValue(a), true);
        }
      }
    });

    test('IS isValidValue bad values', () {
      for (var s in badISList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(IS.isValidValue(a), false);
        }
      }
    });

    test('IS isValidValues good values', () {
      global.throwOnError = false;
      for (var s in goodISList) {
        expect(IS.isValidValues(PTag.kBeamOrderIndexTrial, s), true);
      }
    });

    test('IS isValidValues bad values', () {
      global.throwOnError = false;
      for (var s in badISList) {
        global.throwOnError = false;
        expect(IS.isValidValues(PTag.kBeamOrderIndexTrial, s), false);

        global.throwOnError = true;
        expect(() => IS.isValidValues(PTag.kBeamOrderIndexTrial, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('IS isValidValues bad values length', () {
      global.throwOnError = false;
      for (var s in badISLengthList) {
        global.throwOnError = false;
        expect(IS.isValidValues(PTag.kBeamOrderIndexTrial, s), false);

        global.throwOnError = true;
        expect(() => IS.isValidValues(PTag.kBeamOrderIndexTrial, s),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('IS fromAsciiList', () {
      //  system.level = Level.info;;
      final vList1 = rsg.getISList(1, 1);
      final bytes = Bytes.fromAsciiList(vList1);
      log.debug('fromAsciiList): $bytes');
      expect(bytes.getAsciiList(), equals(vList1));
    });

    test('Bytes.fromAsciiList', () {
      final vList1 = rsg.getISList(1, 1);
      log.debug('Bytes.fromAsciiList(vList1): ${Bytes.fromAsciiList(vList1)}');
      final val = ascii.encode('s6V&:;s%?Q1g5v');
      expect(Bytes.fromAsciiList(['s6V&:;s%?Q1g5v']), equals(val));

      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = ascii.encode(vList1[0]);
      expect(Bytes.fromAsciiList(vList1), equals(values));
    });

    test('IS tryParse', () {
      global.throwOnError = false;
      final vList0 = rsg.getISList(1, 1);
      expect(IS.tryParse(vList0[0]), int.parse(vList0[0]));

      const vList1 = '123';
      expect(IS.tryParse(vList1), int.parse(vList1));

      const vList2 = '12.34';
      expect(IS.tryParse(vList2), isNull);

      const vList3 = 'abc';
      expect(IS.tryParse(vList3), isNull);

      global.throwOnError = true;
      expect(
          () => IS.tryParse(vList3), throwsA(const TypeMatcher<StringError>()));
    });

    test('IS tryParseList', () {
      global.throwOnError = false;
      final vList0 = rsg.getISList(1, 1);
      final parse0 = int.parse(vList0[0]);
      expect(IS.tryParseList(vList0), <int>[parse0]);

      final vList1 = ['123'];
      final parse1 = int.parse(vList1[0]);
      expect(IS.tryParseList(vList1), <int>[parse1]);

      final vList2 = ['12.34'];
      expect(IS.tryParseList(vList2), isNull);

      final vList3 = ['abc'];
      expect(IS.tryParseList(vList3), isNull);

      global.throwOnError = true;
      expect(() => IS.tryParseList(vList3),
          throwsA(const TypeMatcher<StringError>()));
    });

    test('IS parseBytes', () {
      global.throwOnError = false;
      final vList0 = rsg.getISList(1, 1);
      final bytes0 = Bytes.fromAsciiList(vList0);
      final parse0 = int.parse(vList0[0]);
      expect(IS.tryParseBytes(bytes0), [parse0]);

      final vList1 = ['123'];
      final bytes1 = Bytes.fromAsciiList(vList1);
      final parse1 = int.parse(vList1[0]);
      expect(IS.tryParseBytes(bytes1), <int>[parse1]);

      final vList2 = ['12.34'];
      final bytes2 = Bytes.fromAsciiList(vList2);
      expect(IS.tryParseBytes(bytes2), isNull);

      final vList3 = ['abc'];
      final bytes3 = Bytes.fromAsciiList(vList3);
      expect(IS.tryParseBytes(bytes3), isNull);

      global.throwOnError = true;
      expect(() => IS.tryParseBytes(bytes3),
          throwsA(const TypeMatcher<StringError>()));
    });

    test('IS validateValueField', () {
      global.throwOnError = false;
      final vList0 = rsg.getISList(1, 1);
      final bytes0 = Bytes.fromAsciiList(vList0);
      expect(IS.validateValueField(bytes0), vList0);

      final vList1 = ['123'];
      final bytes1 = Bytes.fromAsciiList(vList1);
      expect(IS.validateValueField(bytes1), vList1);

      final vList2 = ['12.34'];
      final bytes2 = Bytes.fromAsciiList(vList2);
      expect(IS.validateValueField(bytes2), vList2);

      final vList3 = ['abc'];
      final bytes3 = Bytes.fromAsciiList(vList3);
      expect(IS.validateValueField(bytes3), vList3);
    });

    test('IS isValidValues good values', () {
      global.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList = rsg.getISList(1, 1);
        expect(IS.isValidValues(PTag.kBeamOrderIndexTrial, vList), true);
      }

      final vList0 = ['560'];
      expect(IS.isValidValues(PTag.kBeamOrderIndexTrial, vList0), true);

      for (var s in goodISList) {
        global.throwOnError = false;
        expect(IS.isValidValues(PTag.kBeamOrderIndexTrial, s), true);
      }
    });

    test('IS isValidValues bad values', () {
      global.throwOnError = false;
      final vList1 = ['\b'];
      expect(IS.isValidValues(PTag.kBeamOrderIndexTrial, vList1), false);

      global.throwOnError = true;
      expect(() => IS.isValidValues(PTag.kBeamOrderIndexTrial, vList1),
          throwsA(const TypeMatcher<StringError>()));

      for (var s in badISList) {
        global.throwOnError = false;
        expect(IS.isValidValues(PTag.kBeamOrderIndexTrial, s), false);

        global.throwOnError = true;
        expect(() => IS.isValidValues(PTag.kBeamOrderIndexTrial, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('IS isValidValues bad values length', () {
      global.throwOnError = false;
      for (var s in badISLengthList) {
        global.throwOnError = false;
        expect(IS.isValidValues(PTag.kBeamOrderIndexTrial, s), false);

        global.throwOnError = true;
        expect(() => IS.isValidValues(PTag.kBeamOrderIndexTrial, s),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('IS toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(1, 1);
        global.throwOnError = false;
        final values = ascii.encode(vList0[0]);
        final tbd0 = Bytes.fromAsciiList(vList0);
        final tbd1 = Bytes.fromAsciiList(vList0);
        log.debug(
          'tbd0: ${tbd0.buffer.asUint8List()}, values: $values',
        );
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodISList) {
        for (var a in s) {
          final values = ascii.encode(a);
          final tbd2 = Bytes.fromAsciiList(s);
          final tbd3 = Bytes.fromAsciiList(s);
          expect(tbd2.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('IS fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.fromAsciiList(vList0);
        final fbd0 = bd0.getAsciiList();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (var s in goodISList) {
        final bd0 = Bytes.fromAsciiList(s);
        final fbd0 = bd0.getAsciiList();
        expect(fbd0, equals(s));
      }
    });

    test('IS toBytes ', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.fromAsciiList(vList0);
        final bytes0 = Bytes.fromAscii(vList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodISList) {
        final toB1 = Bytes.fromAsciiList(s);
        final bytes1 = Bytes.fromAscii(s.join('\\'));
        log.debug('toBytes:$toB1, bytes1: $bytes1');
        expect(toB1, equals(bytes1));
      }

      global.throwOnError = false;
      final toB2 = Bytes.fromAsciiList(['']);
      expect(toB2, equals(<String>[]));

      final toB3 = Bytes.fromAsciiList([]);
      expect(toB3, equals(<String>[]));

      final toB4 = Bytes.fromAsciiList(null);
      expect(toB4, isNull);

      global.throwOnError = true;
      expect(() => Bytes.fromAsciiList(null),
          throwsA(const TypeMatcher<GeneralError>()));
    });
  });
}
