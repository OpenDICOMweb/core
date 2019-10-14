//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:bytes_dicom/bytes_dicom.dart';
import 'package:core/server.dart' hide group;
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = RSG(seed: 1);
RNG rng = RNG(1);

void main() {
  Server.initialize(name: 'element_bytes/special_test', level: Level.info);
  const type = BytesElementType.leShortEvr;
  final rds = ByteRootDataset.empty();

  group('TMbytes', () {
    global.throwOnError = false;

    //VM.k1
    const tmVM1Tags = <int>[
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

    //VM.k1
    const tmVM1nTags = <int>[
      kCalibrationTime,
      kTimeOfLastCalibration,
      kSelectorTMValue,
    ];

    test('TMbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 1);
        for (final code in tmVM1Tags) {
          final e0 = TMbytes.fromValues(code, vList0, type);
          log.debug('e0: $e0');
          final e1 = ElementBytes.fromBytes(e0.be, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);

          expect(e1.hasValidValues, true);
          expect(e1 == e0, true);
          expect(e1.vfBytes == e0.vfBytes, true);

          expect(e0.code == e0.be.code, true);
          expect(e0.length == e0.be.length, true);
          expect(e0.vrCode == e0.be.vrCode, true);
          expect(e0.vrIndex == e0.be.vrIndex, true);
          expect(e0.vfLengthOffset == e0.be.vfLengthOffset, true);
          expect(e0.vfLengthField == e0.be.vfLengthField, true);
          expect(e0.vfLength == e0.be.vfLength, true);
          expect(e0.vfOffset == e0.be.vfOffset, true);
          expect(e0.vfBytes == e0.be.vfBytes, true);
          expect(e0.vfBytesLast == e0.be.vfBytesLast, true);
        }
      }
    });

    test('TMbytes from VM.k1 bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        for (final code in tmVM1Tags) {
          global.throwOnError = false;
          final e0 = TMbytes.fromValues(code, vList0, type);
          log.debug('e0: $e0');
          final e1 = ElementBytes.fromBytes(e0.be, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, false);

          global.throwOnError = true;
          expect(() => e0.hasValidValues,
              throwsA(const TypeMatcher<StringError>()));
        }
      }
    });

    test('TMbytes from VM.k1 bad length', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getTMList(2, i + 1);
        for (final code in tmVM1Tags) {
          global.throwOnError = false;
          final e0 = TMbytes.fromValues(code, vList0, type);
          log.debug('e0: $e0');
          final e1 = ElementBytes.fromBytes(e0.be, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, false);
        }
      }
    });

    test('TMbytes from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getTMList(1, i);
        for (final code in tmVM1nTags) {
          final e0 = TMbytes.fromValues(code, vList0, type);
          log.debug('e0: $e0');
          final e1 = ElementBytes.fromBytes(e0.be, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);

          expect(e1.hasValidValues, true);
          expect(e1 == e0, true);
          expect(e1.vfBytes == e0.vfBytes, true);

          expect(e0.code == e0.be.code, true);
          expect(e0.length == e0.be.length, true);
          expect(e0.vrCode == e0.be.vrCode, true);
          expect(e0.vrIndex == e0.be.vrIndex, true);
          expect(e0.vfLengthOffset == e0.be.vfLengthOffset, true);
          expect(e0.vfLengthField == e0.be.vfLengthField, true);
          expect(e0.vfLength == e0.be.vfLength, true);
          expect(e0.vfOffset == e0.be.vfOffset, true);
          expect(e0.vfBytes == e0.be.vfBytes, true);
          expect(e0.vfBytesLast == e0.be.vfBytesLast, true);
        }
      }
    });

    test('TMbytes from VM.k1_n bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, i);
        final e0 = TMbytes.fromValues(kSelectorTMValue, vList0, type);
        log.debug('e0: $e0');
        final e1 = ElementBytes.fromBytes(e0.be, rds, isEvr: true);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, false);
      }
    });
  });
}