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

  group('SHbytes', () {
    //VM.k1
    const shVM1Tags = const <int>[
      kImplementationVersionName,
      kRecognitionCode,
      kCodeValue,
      kStationName,
      kReceiveCoilName,
      kDetectorID,
      kPulseSequenceName,
      kMultiCoilElementName,
      kRespiratorySignalSourceID,
      kStudyID,
      kStackID,
      kCompressionOriginator,
      kCompressionDescription,
      kChannelLabel,
      kScheduledProcedureStepID,
      kEnergyWindowName,
      kOwnerID,
      kPrintQueueID,
      kFluenceModeID,
      kRTPlanLabel,
      kApplicatorID
    ];

    //VM.k1_n
    const shVm1_nTags = const <int>[
      kReferringPhysicianTelephoneNumbers,
      kPatientTelephoneNumbers,
      kConvolutionKernel,
      kFrameLabelVector,
      kDisplayWindowLabelVector,
      kOutputPower,
      kSelectorSHValue,
      kAxisUnits,
      kAxisLabels,
    ];
    test('SHbytes from VM.k1', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 1);
        for (var code in shVM1Tags) {
          final e0 = SHbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('SHbytes from VM.k1 bad length', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getSHList(2, i + 1);
        for (var code in shVM1Tags) {
          final e0 = SHbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, false);
        }
      }
    });

    test('SHbytes from VM.k1_n', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, i);
        for (var code in shVm1_nTags) {
          final e0 = SHbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });
  });
}
