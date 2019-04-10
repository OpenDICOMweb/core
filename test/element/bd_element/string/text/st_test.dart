//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/server.dart' hide group;
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = RSG(seed: 1);
RNG rng = RNG(1);

void main() {
  Server.initialize(name: 'bd_element/special_test', level: Level.info);

  final rds = ByteRootDataset.empty();

  group('STbytes', () {
    //VM.k1
    const stVM1Tags = <int>[
      kInstitutionAddress,
      kReferringPhysicianAddress,
      kCodingSchemeExternalID,
      kCodingSchemeName,
      kCodingSchemeResponsibleOrganization,
      kDerivationDescription,
      kAnatomicPerspectiveDescriptionTrial,
      kCADFileFormat,
      kComponentReferenceSystem,
      kComponentManufacturingProcedure,
      kComponentManufacturer,
      kIndicationDescription,
      kCouplingTechnique,
      kCouplingMedium,
      kScanProcedure,
      kContributionDescription,
      kPartialViewDescription,
      kMaskOperationExplanation,
      kCommentsOnRadiationDose,
      kAddressTrial,
      kSegmentDescription,
      kSelectorSTValue,
      kTopicSubject
    ];

    test('STbytes from VM.k1', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        for (final code in stVM1Tags) {
          final e0 = STbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.fromBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);

          expect(e1.hasValidValues, true);
          expect(e1 == e0, true);
          expect(e1.vfBytes == e0.vfBytes, true);

          expect(e0.code == e0.bytes.code, true);
          expect(e0.eLength == e0.bytes.eLength, true);
          expect(e0.vrCode == e0.bytes.vrCode, true);
          expect(e0.vrIndex == e0.bytes.vrIndex, true);
          expect(e0.vfLengthOffset == e0.bytes.vfLengthOffset, true);
          expect(e0.vfLengthField == e0.bytes.vfLengthField, true);
          expect(e0.vfLength == e0.bytes.vfLength, true);
          expect(e0.vfOffset == e0.bytes.vfOffset, true);
          expect(e0.vfBytes == e0.bytes.vfBytes, true);
          expect(e0.vfBytesLast == e0.bytes.vfBytesLast, true);
        }
      }
    });

    test('STbytes from VM.k1 bad length', () {
      global.throwOnError = false;
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getSTList(2, i + 1);
        for (final code in stVM1Tags) {
          final e0 = STbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.fromBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, false);
        }
      }
    });
  });
}
