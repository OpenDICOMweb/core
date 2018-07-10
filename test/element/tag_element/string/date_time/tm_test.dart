//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:convert' as cvt;

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = new RSG(seed: 1);

void main() {
  // minYear and maxYear can be passed as an argument
  Server.initialize(
      name: 'string/tm_test',
      level: Level.info,
      minYear: 0000,
      maxYear: 2100,
      throwOnError: false);
  global.throwOnError = false;

  const goodTMList = const <List<String>>[
    const <String>['000000'],
    const <String>['190101'],
    const <String>['235959'],
    const <String>['010101.1'],
    const <String>['010101.11'],
    const <String>['010101.111'],
    const <String>['010101.1111'],
    const <String>['010101.11111'],
    const <String>['010101.111111'],
    const <String>['000000.0'],
    const <String>['000000.00'],
    const <String>['000000.000'],
    const <String>['000000.0000'],
    const <String>['000000.00000'],
    const <String>['000000.000000'],
    const <String>['00'],
    const <String>['0000'],
    const <String>['000000'],
    const <String>['000000.1'],
    const <String>['000000.111111'],
    const <String>['01'],
    const <String>['0101'],
    const <String>['010101'],
    const <String>['010101.1'],
    const <String>['010101.111111'],
    const <String>['10'],
    const <String>['1010'],
    const <String>['101010'],
    const <String>['101010.1'],
    const <String>['101010.111111'],
    const <String>['22'],
    const <String>['2222'],
    const <String>['222222'],
    const <String>['222222.1'],
    const <String>['222222.111111'],
    const <String>['23'],
    const <String>['2323'],
    const <String>['232323'],
    const <String>['232323.1'],
    const <String>['232323.111111'],
    const <String>['23'],
    const <String>['2359'],
    const <String>['235959'],
    const <String>['235959.1'],
    const <String>['235959.111111'],
  ];
  const badTMList = const <List<String>>[
    const <String>['241318'], // bad hour
    const <String>['006132'], // bad minute
    const <String>['006060'], // bad minute and second
    const <String>['000060'], // bad month and day
    const <String>['-00101'], // bad character in hour
    const <String>['a00101'], // bad character in hour
    const <String>['0a0101'], // bad character in hour
    const <String>['ad0101'], // bad characters in hour
    const <String>['19a101'], // bad character in minute
    const <String>['190b01'], // bad character in minute
    const <String>['1901a1'], // bad character in second
    const <String>['19011a'], // bad character in second
  ];

  group('TM Test', () {
    log
      ..debug('kMinEpochMicroseconds: $kMinEpochMicrosecond')
      ..debug('kMaxEpochMicroseconds: $kMaxEpochMicrosecond')
      ..debug('kMicrosecondsPerDay: $kMicrosecondsPerDay');

    test('TM hasValidValues good values random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 1);
        log.debug('vList0: $vList0');
        final e0 = new TMtag(PTag.kModifiedImageTime, vList0);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);

        log..debug('e0: $e0, values: ${e0.values}')..debug('e0: $e0');
        expect(e0[0], equals(vList0[0]));
      }

      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getTMList(1, 5);
        final e0 = new TMtag(PTag.kCalibrationTime, vList1);
        expect(e0.hasValidValues, isTrue);

        log..debug('e0: $e0, values: ${e0.values}')..debug('ss0: $e0');
        expect(e0[0], equals(vList1[0]));
      }
    });

    test('TM hasValidValues bad values random', () {
      for (var i = 0; i < 10; i++) {
        final vList2 = rsg.getTMList(3, 4);
        log.debug('$i: vList2: $vList2');
        final e0 = new TMtag(PTag.kSelectorTMValue, vList2);
        expect(e0.hasValidValues, true);
      }

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 1, 2, 18);
        final e0 = new TMtag(PTag.kModifiedImageTime, vList0);
        log.debug('vList0: $vList0, e0:$e0');
        expect(e0.hasValidValues, true);
      }

/* TODO: Implement getInvalidXXList()
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getInvalidTMList(3, 4, 2, 18);
        log.debug('invalid TM vList:$vList0');
        final e0 = new TMtag(PTag.kModifiedImageTime, vList0);
        log.debug('vList0: $vList0');
         expect(e0, isNull);
      }
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getInvalidTMList(3, 4);
        final e0 = new TMtag(PTag.kModifiedImageTime, vList0);
        expect(e0, isNull);
      }
*/
    });

    test('TM hasValidValues good values', () {
      for (var s in goodTMList) {
        global.throwOnError = false;
        final e0 = new TMtag(PTag.kCalibrationTime, s);
        expect(e0.hasValidValues, isTrue);
      }

      global.throwOnError = false;
      // empty list and null as values
      final e0 = new TMtag(PTag.kModifiedImageTime, <String>[]);
      expect(e0.hasValidValues, true);
      expect(e0.values, equals(<int>[]));
    });

    test('TM hasValidValues bad values', () {
      for (var s in badTMList) {
        global.throwOnError = false;
        final e0 = new TMtag(PTag.kCalibrationTime, s);
        expect(e0, isNull);

        global.throwOnError = true;
        expect(() => new TMtag(PTag.kCalibrationTime, s),
            throwsA(const TypeMatcher<StringError>()));
      }
      global.throwOnError = false;
      final e1 = new TMtag(PTag.kModifiedImageTime, null);
      log.debug('e1: $e1');
      expect(e1.hasValidValues, true);
      expect(e1.values, StringList.kEmptyList);
      global.throwOnError = true;
      expect(() => new TMtag(PTag.kModifiedImageTime, null),
          throwsA(const TypeMatcher<InvalidValuesError>()));
    });

    test('TM update random', () {
      final e0 = new TMtag(PTag.kCalibrationTime, <String>[]);
      expect(e0.values, equals(<String>[]));
      final e1 = e0.update(['231318']);
      expect(e1 == e0, false);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(3, 4);
        final e1 = new TMtag(PTag.kCalibrationTime, vList0);
        final vList1 = rsg.getTMList(3, 4);
        expect(e1.update(vList1).values, equals(vList1));
      }
    });

    test('TM update', () {
      for (var s in goodTMList) {
        final e0 = new TMtag(PTag.kModifiedImageTime, s);
        final e1 = new TMtag(PTag.kModifiedImageTime, s);
        final e2 = e0.update(['231318']);
        final e3 = e1.update(['231318']);
        expect(e0.values.first == e2.values.first, false);
        expect(e0 == e3, false);
        expect(e1 == e3, false);
        expect(e2 == e3, true);
      }
    });

    test('TM noValues random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 1);
        final e1 = new TMtag(PTag.kModifiedImageTime, vList0);
        expect(e1.noValues.values.isEmpty, true);
      }
    });

    test('TM noValues', () {
      final e0 = new TMtag(PTag.kModifiedImageTime, <String>[]);
      final TMtag tmNoValues = e0.noValues;
      expect(tmNoValues.values.isEmpty, true);
      log.debug('e0: ${e0.noValues}');

      for (var s in goodTMList) {
        final e0 = new TMtag(PTag.kModifiedImageTime, s);
        final tmNoValues0 = e0.noValues;
        expect(tmNoValues0.isEmpty, true);
        log.debug('e0:${e0.noValues}');
      }
    });

    test('TM copy random', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(3, 4);
        final e2 = new TMtag(PTag.kSelectorTMValue, vList0);
        final TMtag e3 = e2.copy;
        expect(e3 == e2, true);
        expect(e3.hashCode == e2.hashCode, true);
      }
    });

    test('TM copy Element', () {
      final e0 = new TMtag(PTag.kModifiedImageTime, <String>[]);
      final TMtag e1 = e0.copy;
      expect(e1 == e0, true);
      expect(e1.hashCode == e0.hashCode, true);

      final e3 = new TMtag(PTag.kModifiedImageTime, ['151545']);
      final e4 = e3.copy;
      expect(e3 == e4, true);
      expect(e3.hashCode == e4.hashCode, true);
    });

    test('TM hashCode and == good values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 1);
        final e0 = new TMtag(PTag.kModifiedImageTime, vList0);
        final e1 = new TMtag(PTag.kModifiedImageTime, vList0);
        log
          ..debug('vList0:$vList0, e0.hash_code:${e0.hashCode}')
          ..debug('vList0:$vList0, e1.hash_code:${e1.hashCode}');
        expect(e0.hashCode == e1.hashCode, true);
        expect(e0 == e1, true);
      }
    });

    test('TM hashCode and == bad values random', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 1);
        final e0 = new TMtag(PTag.kModifiedImageTime, vList0);
        final vList1 = rsg.getTMList(1, 1);
        final e2 = new TMtag(PTag.kTimeOfLastDetectorCalibration, vList1);
        log.debug('vList1:$vList1 , e2.hash_code:${e2.hashCode}');
        expect(e0.hashCode == e2.hashCode, false);
        expect(e0 == e2, false);

        final vList2 = rsg.getTMList(2, 3);
        final e3 = new TMtag(PTag.kModifiedImageTime, vList2);
        log.debug('vList2:$vList2 , e3.hash_code:${e3.hashCode}');
        expect(e0.hashCode == e3.hashCode, false);
        expect(e0 == e3, false);
      }
    });

    test('TM hashCode and == good values', () {
      final vList = ['231121'];
      final ss0 = new TMtag(PTag.kModifiedImageTime, vList);
      final ss1 = new TMtag(PTag.kModifiedImageTime, vList);
      log
        ..debug('vList:$vList, ss0.hash_code:${ss0.hashCode}')
        ..debug('vList:$vList, ss1.hash_code:${ss1.hashCode}');
      expect(ss0.hashCode == ss1.hashCode, true);
      expect(ss0 == ss1, true);
    });

    test('TM hashCode and == bad values', () {
      final vList = ['231121'];
      final ss0 = new TMtag(PTag.kModifiedImageTime, vList);
      final ss2 = new TMtag(PTag.kStudyVerifiedTime, vList);
      log.debug('vList:$vList , ss2.hash_code:${ss2.hashCode}');
      expect(ss0.hashCode == ss2.hashCode, false);
      expect(ss0 == ss2, false);
    });

    test('TM getAsciiList random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getTMList(1, 1);
        final bytes = Bytes.fromAsciiList(vList1);
        final e0 = TMtag.fromBytes(PTag.kTime, bytes);
        expect(e0.hasValidValues, true);
      }
    });

    test('TM getAsciiList', () {
      for (var s in goodTMList) {
        //final bytes = encodeStringListValueField(vList1);
        final bytes = Bytes.fromAsciiList(s);
        log.debug('bytes:$bytes');
        final e0 = TMtag.fromBytes(PTag.kModifiedImageTime, bytes);
        log.debug('e0: $e0');
        expect(e0.hasValidValues, true);
      }
    });

    test('TM fromBytes good values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getTMList(1, 10);
        for (var listS in vList1) {
          final bytes0 = Bytes.fromAscii(listS);
          final e1 = TMtag.fromBytes(PTag.kSelectorTMValue, bytes0);
          log.debug('e1: $e1');
          expect(e1.hasValidValues, true);
        }
      }
    });

    test('TM fromBytes bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getTMList(1, 10);
        for (var listS in vList1) {
          global.throwOnError = false;
          final bytes0 = Bytes.fromAscii(listS);
          final e1 = TMtag.fromBytes(PTag.kSelectorAEValue, bytes0);
          expect(e1, isNull);

          global.throwOnError = true;
          expect(() => TMtag.fromBytes(PTag.kSelectorAEValue, bytes0),
              throwsA(const TypeMatcher<InvalidTagError>()));
        }
      }
    });

    test('TM checkLength random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getTMList(1, 10);
        final e0 = new TMtag(PTag.kCalibrationTime, vList1);
        expect(e0.checkLength(e0.values), true);
      }
    });

    test('TM checkLength Element', () {
      for (var s in goodTMList) {
        final e0 = new TMtag(PTag.kModifiedImageTime, s);
        expect(e0.checkLength(e0.values), true);
      }
    });

    test('TM checkValues random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getTMList(1, 10);
        final e0 = new TMtag(PTag.kCalibrationTime, vList1);
        expect(e0.checkValues(e0.values), true);
      }
    });

    test('TM checkValues Element', () {
      for (var s in goodTMList) {
        final e0 = new TMtag(PTag.kModifiedImageTime, s);
        expect(e0.checkValues(e0.values), true);
      }
    });

    test('TM valuesCopy random', () {
      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getTMList(1, 10);
        final ss0 = new TMtag(PTag.kCalibrationTime, vList1);
        expect(vList1, equals(ss0.valuesCopy));
      }
    });

    test('TM valuesCopy', () {
      for (var s in goodTMList) {
        final e0 = new TMtag(PTag.kModifiedImageTime, s);
        expect(s, equals(e0.valuesCopy));
      }
    });

    test('TM replace random', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 10);
        final e0 = new TMtag(PTag.kCalibrationTime, vList0);
        final vList1 = rsg.getTMList(1, 1);
        expect(e0.replace(vList1), equals(vList0));
        expect(e0.values, equals(vList1));
      }

      final vList1 = rsg.getTMList(1, 10);
      final e1 = new TMtag(PTag.kCalibrationTime, vList1);
      expect(e1.replace(<String>[]), equals(vList1));
      expect(e1.values, equals(<String>[]));

      final e2 = new TMtag(PTag.kCalibrationTime, vList1);
      expect(e2.replace(null), equals(vList1));
      expect(e2.values, equals(<String>[]));
    });

    test('TM checkLength', () {
      global.throwOnError = false;
      final vList0 = rsg.getTMList(1, 1);
      final e0 = new TMtag(PTag.kCalibrationTime, vList0);
      for (var s in goodTMList) {
        expect(e0.checkLength(s), true);
      }
      final e1 = new TMtag(PTag.kCalibrationTime, vList0);
      expect(e1.checkLength(<String>[]), true);

      final vList1 = ['120450', '053439'];
      final e2 = new TMtag(PTag.kDateTime, vList1);
      expect(e2, isNull);
    });

    test('TM checkValue good values', () {
      final vList0 = rsg.getTMList(1, 1);
      final e0 = new TMtag(PTag.kCalibrationTime, vList0);
      for (var s in goodTMList) {
        for (var a in s) {
          expect(e0.checkValue(a), true);
        }
      }
    });

    test('TM checkValue bad values', () {
      final vList0 = rsg.getTMList(1, 1);
      final e0 = new TMtag(PTag.kCalibrationTime, vList0);
      for (var s in badTMList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(e0.checkValue(a), false);
        }
      }
    });

    test('TM make good values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 1);
        final make0 = TMtag.fromValues(PTag.kTime, vList0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);

        final make1 = TMtag.fromValues(PTag.kTime, <String>[]);
        expect(make1.hasValidValues, true);
        expect(make1.values, equals(<String>[]));
      }
    });

    test('TM make bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(2, 2);
        global.throwOnError = false;
        final make0 = TMtag.fromValues(PTag.kTime, vList0);
        expect(make0, isNull);

        global.throwOnError = true;
        expect(() => TMtag.fromValues(PTag.kTime, vList0),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }

      global.throwOnError = false;
      final make1 = TMtag.fromValues(PTag.kTime, <String>[null]);
      log.debug('mak1: $make1');
      expect(make1, isNull);

      global.throwOnError = true;
      expect(() => TMtag.fromValues(PTag.kDateTime, <String>[null]),
          throwsA(const TypeMatcher<InvalidTagError>()));
    });

    test('TM append ', () {
      final vList0 = ['094123.88'];
      final e0 = new TMtag(PTag.kSelectorTMValue, vList0);
      const vList1 = '103050.55';
      final append0 = e0.append(vList1);
      log.debug('append0: $append0');
      expect(append0, isNotNull);
    });

    test('TM prepend ', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getTMList(1, i);
        final e0 = new TMtag(PTag.kSelectorTMValue, vList0);
        const vList1 = '094123.02158';
        final prepend0 = e0.prepend(vList1);
        log.debug('prepend0: $prepend0');
        expect(prepend0, isNotNull);
      }
    });

    test('TM truncate ', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getTMList(1, i);
        final e0 = new TMtag(PTag.kSelectorTMValue, vList0);
        final truncate0 = e0.truncate(4);
        log.debug('truncate0: $truncate0');
        expect(truncate0, isNotNull);
      }
    });

    test('TM match', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getTMList(1, i);
        log.debug('vList0:$vList0');
        final e0 = new TMtag(PTag.kSelectorTMValue, vList0);
        const regX = r'\w*[0-9\.]';
        final match0 = e0.match(regX);
        expect(match0, true);
      }
    });
  });

  group('TM Element', () {
    const badTMLengthList = const <List<String>>[
      const <String>['999999.9999', '999999.99999', '999999.999999'],
      const <String>['999999.9', '999999.99', '999999.999']
    ];

    //VM.k1
    const tmVM1Tags = const <PTag>[
      PTag.kStudyTime,
      PTag.kSeriesTime,
      PTag.kAcquisitionTime,
      PTag.kContentTime,
      PTag.kInterventionDrugStartTime,
      PTag.kTimeOfSecondaryCapture,
      PTag.kContrastBolusStartTime,
      PTag.kRadiopharmaceuticalStopTime,
      PTag.kScheduledStudyStartTime,
      PTag.kScheduledStudyStopTime,
      PTag.kIssueTimeOfImagingServiceRequest,
      PTag.kStructureSetTime,
      PTag.kTreatmentControlPointTime,
      PTag.kSafePositionExitTime,
    ];

    //VM.k1
    const tmVM1_nTags = const <PTag>[
      PTag.kCalibrationTime,
      PTag.kTimeOfLastCalibration,
      PTag.kSelectorTMValue,
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
      PTag.kDateTime
    ];

    final invalidList = rsg.getTMList(TM.kMaxVFLength + 1, TM.kMaxVFLength + 1);

    test('TM isValidTag good values', () {
      global.throwOnError = false;
      expect(TM.isValidTag(PTag.kSelectorTMValue), true);

      for (var tag in tmVM1Tags) {
        final validT0 = TM.isValidTag(tag);
        expect(validT0, true);
      }
    });

    test('TM isValidTag bad values', () {
      global.throwOnError = false;
      expect(TM.isValidTag(PTag.kSelectorFDValue), false);
      global.throwOnError = true;
      expect(() => TM.isValidTag(PTag.kSelectorFDValue),
          throwsA(const TypeMatcher<InvalidTagError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        final validT0 = TM.isValidTag(tag);
        expect(validT0, false);

        global.throwOnError = true;
        expect(() => TM.isValidTag(tag),
            throwsA(const TypeMatcher<InvalidTagError>()));
      }
    });

    test('TM isValidVRIndex good values', () {
      global.throwOnError = false;
      expect(TM.isValidVRIndex(kTMIndex), true);

      for (var tag in tmVM1Tags) {
        global.throwOnError = false;
        expect(TM.isValidVRIndex(tag.vrIndex), true);
      }
    });

    test('TM isValidVRIndex bad values', () {
      global.throwOnError = false;
      expect(TM.isValidVRIndex(kSSIndex), false);

      global.throwOnError = true;
      expect(() => TM.isValidVRIndex(kSSIndex),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(TM.isValidVRIndex(tag.vrIndex), false);

        global.throwOnError = true;
        expect(() => TM.isValidVRIndex(tag.vrIndex),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('TM isValidVRCode good values', () {
      global.throwOnError = false;
      expect(TM.isValidVRCode(kTMCode), true);

      for (var tag in tmVM1Tags) {
        expect(TM.isValidVRCode(tag.vrCode), true);
      }
    });

    test('TM isValidVRCode bad values', () {
      global.throwOnError = false;
      expect(TM.isValidVRCode(kAECode), false);

      global.throwOnError = true;
      expect(() => TM.isValidVRCode(kAECode),
          throwsA(const TypeMatcher<InvalidVRError>()));

      for (var tag in otherTags) {
        global.throwOnError = false;
        expect(TM.isValidVRCode(tag.vrCode), false);

        global.throwOnError = true;
        expect(() => TM.isValidVRCode(tag.vrCode),
            throwsA(const TypeMatcher<InvalidVRError>()));
      }
    });

    test('TM isValidVFLength good values', () {
      expect(TM.isValidVFLength(TM.kMaxVFLength), true);
      expect(TM.isValidVFLength(0), true);

      expect(TM.isValidVFLength(TM.kMaxVFLength, null, PTag.kSelectorTMValue),
          true);
    });

    test('TM isValidVFLength bad values', () {
      expect(TM.isValidVFLength(TM.kMaxVFLength + 1), false);
      expect(TM.isValidVFLength(-1), false);
    });

    test('TM isValidValueLength', () {
      global.throwOnError = false;
      for (var s in goodTMList) {
        for (var a in s) {
          expect(TM.isValidValueLength(a), true);
        }
      }

      expect(TM.isValidValueLength('190101'), true);

      expect(TM.isValidValueLength('19010112345657'), false);
    });

    test('TM isValidLength VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getTMList(1, 1);
        for (var tag in tmVM1Tags) {
          expect(TM.isValidLength(tag, vList), true);
        }
      }
    });

    test('DA isValidLength VM.k1 bad values', () {
      for (var i = 1; i < 10; i++) {
        final vList = rsg.getTMList(2, i + 1);
        for (var tag in tmVM1Tags) {
          global.throwOnError = false;
          expect(TM.isValidLength(tag, vList), false);

          global.throwOnError = true;
          expect(() => TM.isValidLength(tag, vList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
      global.throwOnError = false;
      final vList0 = rsg.getTMList(1, 1);
      expect(TM.isValidLength(null, vList0), false);

      expect(TM.isValidLength(PTag.kSelectorTMValue, null), isNull);

      global.throwOnError = true;
      expect(() => TM.isValidLength(null, vList0),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => TM.isValidLength(PTag.kSelectorTMValue, null),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('TM isValidLength VM.k1_n good values', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getTMList(1, i);
        for (var tag in tmVM1_nTags) {
          log.debug('tag: $tag');
          expect(TM.isValidLength(tag, vList0), true);
        }
      }
    });

    test('TM isValidValue good values', () {
      for (var s in goodTMList) {
        for (var a in s) {
          expect(TM.isValidValue(a), true);
        }
      }
    });

    test('TM isValidValue bad values', () {
      for (var s in badTMList) {
        for (var a in s) {
          global.throwOnError = false;
          expect(TM.isValidValue(a), false);
        }
      }
    });

    test('TM isValidValues good values', () {
      global.throwOnError = false;
      for (var s in goodTMList) {
        expect(TM.isValidValues(PTag.kStudyTime, s), true);
      }
    });

    test('TM isValidValues bad values', () {
      global.throwOnError = false;
      for (var s in badTMList) {
        global.throwOnError = false;
        expect(TM.isValidValues(PTag.kStudyTime, s), false);

        global.throwOnError = true;
        expect(() => TM.isValidValues(PTag.kStudyTime, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('TM isValidValues bad values length', () {
      global.throwOnError = false;
      for (var s in badTMLengthList) {
        global.throwOnError = false;
        expect(TM.isValidValues(PTag.kStudyTime, s), false);

        global.throwOnError = true;
        expect(() => TM.isValidValues(PTag.kStudyTime, s),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('TM isValidValues VM.k1 good values length', () {
      for (var i = 0; i < 10; i++) {
        final validList = rsg.getTMList(1, 1);
        for (var tag in tmVM1Tags) {
          global.throwOnError = false;
          expect(TM.isValidValues(tag, validList), true);
        }
      }
    });

    test('TM isValidValues VM.k1 bad values length', () {
      for (var i = 1; i < 10; i++) {
        final validList = rsg.getTMList(2, i + 1);
        for (var tag in tmVM1Tags) {
          global.throwOnError = false;
          expect(TM.isValidValues(tag, validList), false);
          expect(TM.isValidValues(tag, invalidList), false);

          global.throwOnError = true;
          expect(() => TM.isValidValues(tag, validList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
          expect(() => TM.isValidValues(tag, invalidList),
              throwsA(const TypeMatcher<InvalidValuesError>()));
        }
      }
    });

    test('TM isValidValues VM.k1_n length', () {
      for (var i = 1; i < 10; i++) {
        final validList = rsg.getTMList(1, i);
        for (var tag in tmVM1_nTags) {
          global.throwOnError = false;
          expect(TM.isValidValues(tag, validList), true);
        }
      }
    });

    test('TM getAsciiList', () {
      //    	system.level = Level.info;
      final vList1 = rsg.getTMList(1, 1);
      final bytes = Bytes.fromAsciiList(vList1);
      log.debug('TM.getAsciiList(bytes): $bytes');
      expect(bytes.getAsciiList(), equals(vList1));
    });

    test('TM toUint8List good values', () {
      final vList1 = rsg.getTMList(1, 1);
      log.debug('Bytes.fromAsciiList(vList1): ${Bytes.fromAsciiList(vList1)}');
      final val = cvt.ascii.encode('s6V&:;s%?Q1g5v');
      expect(Bytes.fromAsciiList(['s6V&:;s%?Q1g5v']), equals(val));

      if (vList1[0].length.isOdd) vList1[0] = '${vList1[0]} ';
      log.debug('vList1:"$vList1"');
      final values = cvt.ascii.encode(vList1[0]);
      expect(Bytes.fromAsciiList(vList1), equals(values));
    });

    test('TM toUint8List bad values length', () {
      global.throwOnError = false;
      final vList0 = rsg.getTMList(TM.kMaxVFLength + 1, TM.kMaxVFLength + 1);
      expect(vList0.length > TM.kMaxLength, true);
      final bytes = Bytes.fromAsciiList(vList0);
      expect(bytes, isNotNull);
      expect(bytes.length > TM.kMaxVFLength, true);

/*
      global.throwOnError = true;
      expect(() => Bytes.fromAsciiList(vList0),
          throwsA(const TypeMatcher<InvalidValueFieldError>()));
*/
    });

    test('TM getAsciiList', () {
      final vList1 = rsg.getTMList(1, 1);
      final bytes = Bytes.fromAsciiList(vList1);
      log.debug('TM.getAsciiList(bytes): $bytes');
      expect(bytes.getAsciiList(), equals(vList1));
    });

    test('TM isValidValues good values', () {
      global.throwOnError = false;
      for (var i = 0; i <= 10; i++) {
        final vList = rsg.getTMList(1, 1);
        expect(TM.isValidValues(PTag.kAcquisitionTime, vList), true);
      }

      final vList0 = ['235959'];
      expect(TM.isValidValues(PTag.kAcquisitionTime, vList0), true);

      for (var s in goodTMList) {
        global.throwOnError = false;
        expect(TM.isValidValues(PTag.kAcquisitionTime, s), true);
      }
    });

    test('TM isValidValues bad values', () {
      global.throwOnError = false;
      final vList1 = ['235960'];
      expect(TM.isValidValues(PTag.kAcquisitionTime, vList1), false);

      global.throwOnError = true;
      expect(() => TM.isValidValues(PTag.kAcquisitionTime, vList1),
          throwsA(const TypeMatcher<StringError>()));

      for (var s in badTMList) {
        global.throwOnError = false;
        expect(TM.isValidValues(PTag.kAcquisitionTime, s), false);

        global.throwOnError = true;
        expect(() => TM.isValidValues(PTag.kAcquisitionTime, s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });
    test('TM isValidValues bad values length', () {
      for (var s in badTMLengthList) {
        global.throwOnError = false;
        expect(TM.isValidValues(PTag.kAcquisitionTime, s), false);

        global.throwOnError = true;
        expect(() => TM.isValidValues(PTag.kAcquisitionTime, s),
            throwsA(const TypeMatcher<InvalidValuesError>()));
      }
    });

    test('TM toByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 1);
        global.throwOnError = false;
        final values = cvt.ascii.encode(vList0[0]);
        final tbd0 = Bytes.fromAsciiList(vList0);
        final tbd1 = Bytes.fromAsciiList(vList0);
        log.debug('bd0: ${tbd0.buffer.asUint8List()}, values: $values');
        expect(tbd0.buffer.asUint8List(), equals(values));
        expect(tbd0.buffer == tbd1.buffer, false);
      }
      for (var s in goodTMList) {
        for (var a in s) {
          final values = cvt.ascii.encode(a);
          final tbd2 = Bytes.fromAsciiList(s);
          final tbd3 = Bytes.fromAsciiList(s);
          expect(tbd2.buffer.asUint8List(), equals(values));
          expect(tbd2.buffer == tbd3.buffer, false);
        }
      }
    });

    test('TM fromByteData', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 1);
        global.throwOnError = false;
        final bd0 = Bytes.fromAsciiList(vList0);
        final fbd0 = bd0.getAsciiList();
        log.debug('fbd0: $fbd0, vList0: $vList0');
        expect(fbd0, equals(vList0));
      }
      for (var s in goodTMList) {
        final bd0 = Bytes.fromAsciiList(s);
        final fbd0 = bd0.getAsciiList();
        expect(fbd0, equals(s));
      }
    });

    test('TM toBytes', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 10);
        global.throwOnError = false;
        final toB0 = Bytes.fromAsciiList(vList0, kMaxShortVF);
        final bytes0 = Bytes.fromAscii(vList0.join('\\'));
        log.debug('toBytes:$toB0, bytes0: $bytes0');
        expect(toB0, equals(bytes0));
      }

      for (var s in goodTMList) {
        final toB1 = Bytes.fromAsciiList(s, kMaxShortVF);
        final bytes1 = Bytes.fromAscii(s.join('\\'));
        log.debug('toBytes:$toB1, bytes1: $bytes1');
        expect(toB1, equals(bytes1));
      }

      global.throwOnError = false;
      final toB2 = Bytes.fromAsciiList([''], kMaxShortVF);
      expect(toB2, equals(<String>[]));

      final toB3 = Bytes.fromAsciiList([], kMaxShortVF);
      expect(toB3, equals(<String>[]));

      final toB4 = Bytes.fromAsciiList(null, kMaxShortVF);
      expect(toB4, isNull);

      global.throwOnError = true;
      expect(() => Bytes.fromAsciiList(null, kMaxShortVF),
          throwsA(const TypeMatcher<GeneralError>()));
    });

    test('TM isValidBytesArgs', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getTMList(1, i);
        final vfBytes = Bytes.fromUtf8List(vList0);

        if (vList0.length == 1) {
          for (var tag in tmVM1Tags) {
            final e0 = TM.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        } else {
          for (var tag in tmVM1_nTags) {
            final e0 = TM.isValidBytesArgs(tag, vfBytes);
            expect(e0, true);
          }
        }
      }
      final vList0 = rsg.getTMList(1, 1);
      final vfBytes = Bytes.fromUtf8List(vList0);

      final e1 = TM.isValidBytesArgs(null, vfBytes);
      expect(e1, false);

      final e2 = TM.isValidBytesArgs(PTag.kDate, vfBytes);
      expect(e2, false);

      final e3 = TM.isValidBytesArgs(PTag.kSelectorTMValue, null);
      expect(e3, false);

      global.throwOnError = true;
      expect(() => TM.isValidBytesArgs(null, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));

      expect(() => TM.isValidBytesArgs(PTag.kDate, vfBytes),
          throwsA(const TypeMatcher<InvalidTagError>()));
    });
  });
}
