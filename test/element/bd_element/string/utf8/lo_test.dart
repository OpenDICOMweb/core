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

  group('LObytes', () {
    //VM.k1
    const loVM1Tags = const <int>[
      kDataSetSubtype,
      kManufacturer,
      kInstitutionName,
      kExtendedCodeValue,
      kCodeMeaning,
      kPrivateCreatorReference,
      kPatientID,
      kIssuerOfPatientID,
      kBranchOfService,
      kPatientReligiousPreference,
      kSecondaryCaptureDeviceID,
      kHardcopyDeviceManufacturer,
      kApplicationVersion,
    ];

    //VM.k1_n
    const loVM1_nTags = const <int>[
      kAdmittingDiagnosesDescription,
      kEventTimerNames,
      kInsurancePlanIdentification,
      kMedicalAlerts,
      kDeidentificationMethod,
      kRadionuclide,
      kSecondaryCaptureDeviceSoftwareVersions,
      kSoftwareVersions,
      kTypeOfFilters,
      kTransducerData,
      kSelectorLOValue,
      kProductName,
      kOtherPatientIDs,
    ];
    test('LObytes from VM.k1', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        for (var code in loVM1Tags) {
          final e0 = LObytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('LObytes from VM.k1 bad length', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getLOList(2, i + 1);
        for (var code in loVM1Tags) {
          final e0 = LObytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, false);
        }
      }
    });

    test('LObytes from VM.k1_n', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, i);
        final e0 = LObytes.fromValues(kSelectorLOValue, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });
}
