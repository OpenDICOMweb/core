//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/server.dart';
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = new RSG(seed: 1);
RNG rng = new RNG(1);

void main() {
  Server.initialize(name: 'bd_element/special_test', level: Level.info);

  final rds = new ByteRootDataset.empty();

  group('TMbytes', () {
    global.throwOnError = false;

    //VM.k1
    const tmVM1Tags = const <int>[
      kStudyTime,
      kSeriesTime,
      kAcquisitionTime,
      kContentTime,
      kInterventionDrugStartTime,
      kTimeOfSecondaryCapture,
      kContrastBolusStartTime,
      kRadiopharmaceuticalStopTime,
      kScheduledStudyStartTime,
      kScheduledStudyStopTime,
      kIssueTimeOfImagingServiceRequest,
      kStructureSetTime,
      kTreatmentControlPointTime,
      kSafePositionExitTime,
    ];

    // Urgent: No used fix or flush
    //VM.k1
    const tmVM1_nTags = const <int>[
      kCalibrationTime,
      kTimeOfLastCalibration,
      kDateTimeOfLastCalibration,
      kSelectorTMValue,
    ];

    test('TMbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 1);
        for (var code in tmVM1Tags) {
          final e0 = TMbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('TMbytes from VM.k1 bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        for (var code in tmVM1Tags) {
          global.throwOnError = false;
          final e0 = TMbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, false);

          global.throwOnError = true;
          expect(() => e0.hasValidValues,
              throwsA(const isInstanceOf<StringError>()));
        }
      }
    });

    test('TMbytes from VM.k1 bad length', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getTMList(2, i + 1);
        for (var code in tmVM1Tags) {
          global.throwOnError = false;
          final e0 = TMbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, false);
        }
      }
    });

    test('TMbytes from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        global.throwOnError = false;

        final vList0 = rsg.getTMList(1, i);
        final e0 = TMbytes.fromValues(kSelectorTMValue, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('TMbytes from VM.k1_n bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, i);
        final e0 = TMbytes.fromValues(kSelectorTMValue, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, false);
      }
    });
  });
}
