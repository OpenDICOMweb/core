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
          uid == WellKnownSopInstance.kUnifiedWorklistAndProcedureStep, true);

      uid = Uid.lookup('1.2.840.10008.1.42.1');
      expect(uid == WellKnownSopInstance.kSubstanceAdministrationLogging, true);

      uid = Uid.lookup('1.2.840.10008.1.42');
      expect(
          uid == WellKnownSopInstance.kSubstanceAdministrationLogging, false);
    });

    test('String to WellKnownSopInstance', () {
      Uid uid = WellKnownSopInstance.lookup('1.2.840.10008.5.1.4.34.5');
      expect(
          uid == WellKnownSopInstance.kUnifiedWorklistAndProcedureStep, true);

      uid = WellKnownSopInstance.lookup('1.2.840.10008.1.42.1');
      expect(uid == WellKnownSopInstance.kSubstanceAdministrationLogging, true);
    });

    test('Create WellKnownSopInstance', () {
      final wksI0 = new WellKnownSopInstance(
          '1.2.840.10008.5.1.4.34.5',
          'UnifiedWorklistandProcedureStepSOPInstance',
          UidType.kWellKnownSOPInstance,
          'Unified Worklist and Procedure Step SOP Instance');

      final wksI1 = new WellKnownSopInstance(
          '1.2.840.10008.5.1.4.34.5',
          'UnifiedWorklistandProcedureStepSOPInstance',
          UidType.kWellKnownSOPInstance,
          'Unified Worklist and Procedure Step SOP Instance');

      final wksI2 = new WellKnownSopInstance(
          '1.2.840.10008.1.42.1',
          'SubstanceAdministrationLoggingSOPInstance',
          UidType.kWellKnownSOPInstance,
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
      expect(wksI0.type == UidType.kWellKnownSOPInstance, true);
      expect(wksI0.isSOPInstance, true);
      expect(wksI0.maxLength == 64, true);
      expect(wksI0.minLength == 6, true);
      expect(wksI0.maxRootLength == 24, true);
    });
  });
}
