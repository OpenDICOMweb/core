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

  group('DAbytes', () {
    //VM.k1
    const daVM1Tags = const <int>[
      kDate,
      kStudyDate,
      kSeriesDate,
      kAcquisitionDate,
      kContentDate,
      kOverlayDate,
      kCurveDate,
      kPatientBirthDate,
      kDateOfSecondaryCapture,
      kModifiedImageDate,
      kStudyVerifiedDate,
      kStudyReadDate,
      kScheduledStudyStartDate,
      kScheduledStudyStopDate,
    ];

    //VM.k1_n
    const daVM1_nTags = const <int>[
      kCalibrationDate,
      kDateOfLastCalibration,
      kSelectorDAValue,
    ];

    test('DAbytes from VM.k1 good values', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        for (var code in daVM1Tags) {
          final e0 = DAbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('DAbytes from VM.k1 bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDTList(1, 1, 3);
        for (var code in daVM1Tags) {
          global.throwOnError = false;
          final e0 = DAbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, false);

          global.throwOnError = true;
          expect(() => e0.hasValidValues,
              throwsA(const isInstanceOf<StringError>()));
        }
      }

      for (var i = 0; i < 10; i++) {
        final vList1 = rsg.getTMList(1, 1);
        for (var code in daVM1Tags) {
          global.throwOnError = false;
          final e2 = DAbytes.fromValues(code, vList1);
          log.debug('e2: $e2');
          final e3 = ByteElement.makeFromDicomBytes(e2.bytes, rds);
          log.debug('e3: $e3');
          expect(e2.hasValidValues, false);

          global.throwOnError = true;
          expect(() => e2.hasValidValues,
              throwsA(const isInstanceOf<StringError>()));
        }
      }
    });

    test('DAbytes from VM.k1 bad length', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getDAList(2, i + 1);
        for (var code in daVM1Tags) {
          global.throwOnError = false;
          final e0 = DAbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, false);
        }
      }
    });

    test('DAbytes from VM.k1_n', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDAList(1, 1);
        for (var code in daVM1_nTags) {
          final e0 = DAbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('DAbytes from VM.k1_n bad values', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDTList(1, 1, 3);
        for (var code in daVM1_nTags) {
          global.throwOnError = false;
          final e0 = DAbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, false);

          global.throwOnError = true;
          expect(() => e0.hasValidValues,
              throwsA(const isInstanceOf<StringError>()));
        }
      }
    });
  });
}
