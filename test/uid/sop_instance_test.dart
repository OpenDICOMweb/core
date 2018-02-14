// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.


import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'sop_instance_test', level: Level.info);

  group('WellKnownSopInstance', () {
    test('String to UID', () {
      Uid uid = Uid.lookup('1.2.840.10008.5.1.4.34.5');
      expect(
          uid == SopInstance.kUnifiedWorklistAndProcedureStep, true);

      uid = Uid.lookup('1.2.840.10008.1.42.1');
      expect(uid == SopInstance.kSubstanceAdministrationLogging, true);

      uid = Uid.lookup('1.2.840.10008.1.42');
      expect(
          uid == SopInstance.kSubstanceAdministrationLogging, false);
    });

    test('String to WellKnownSopInstance', () {
      Uid uid = SopInstance.lookup('1.2.840.10008.5.1.4.34.5');
      expect(
          uid == SopInstance.kUnifiedWorklistAndProcedureStep, true);

      uid = SopInstance.lookup('1.2.840.10008.1.42.1');
      expect(uid == SopInstance.kSubstanceAdministrationLogging, true);
    });

    test('Create WellKnownSopInstance', () {
      final wksI0 = new SopInstance(
          '1.2.840.10008.5.1.4.34.5',
          'UnifiedWorklistandProcedureStepSOPInstance',
          UidType.kSOPInstance,
          'Unified Worklist and Procedure Step SOP Instance');

      final wksI1 = new SopInstance(
          '1.2.840.10008.5.1.4.34.5',
          'UnifiedWorklistandProcedureStepSOPInstance',
          UidType.kSOPInstance,
          'Unified Worklist and Procedure Step SOP Instance');

      final wksI2 = new SopInstance(
          '1.2.840.10008.1.42.1',
          'SubstanceAdministrationLoggingSOPInstance',
          UidType.kSOPInstance,
          'Substance Administration Logging SOP Instance');

      expect(wksI0.hashCode == wksI1.hashCode, true);
      expect(wksI0.hashCode == wksI2.hashCode, false);

      expect(wksI0.value == wksI1.value, true);
      expect(wksI0.value == wksI2.value, false);

      expect(
          wksI0.keyword == 'UnifiedWorklistandProcedureStepSOPInstance', true);
      expect(wksI0.name == 'Unified Worklist and Procedure Step SOP Instance',
          true);
      expect(wksI0.value == '1.2.840.10008.5.1.4.34.5', true);
      expect(wksI0.type == UidType.kSOPInstance, true);
      expect(wksI0 is SopInstance, true);
      expect(wksI0.maxLength == 64, true);
      expect(wksI0.minLength == 6, true);
      expect(wksI0.maxRootLength == 24, true);
    });
  });
}
