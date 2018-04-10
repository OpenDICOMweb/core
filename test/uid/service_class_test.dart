// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'uid/service_class_test', level: Level.info);

  group('ServiceClass', () {
    test('String to UID', () {
      Uid uid = Uid.lookup('1.2.840.10008.4.2');
      expect(uid == ServiceClass.kStorageServiceClass, true);

      uid = Uid.lookup('1.2.840.10008.5.1.4.34.4');
      expect(
          uid == ServiceClass.kUnifiedWorklistAndProcedureStepServiceClassTrial,
          true);

      uid = Uid.lookup('1.2.840.10008.7.1.3');
      expect(uid == ServiceClass.kStorageServiceClass, false);
    });

    test('String to LdapOid', () {
      Uid uid = ServiceClass.lookup('1.2.840.10008.4.2');
      expect(uid == ServiceClass.kStorageServiceClass, true);

      uid = ServiceClass.lookup('1.2.840.10008.15.0.3.2');
      expect(uid == ServiceClass.kStorageServiceClass, false);
    });

    test('Create ServiceClass', () {
      const sc0 = const ServiceClass(
          '1.2.840.10008.4.2',
          'StorageServiceClass', UidType.kServiceClass, 'Storage Service Class');

      const fr1 = const ServiceClass(
          '1.2.840.10008.4.2',
          'StorageServiceClass', UidType.kServiceClass, 'Storage Service Class');

      const fr2 = const ServiceClass(
          '1.2.840.10008.5.1.4.34.4',
          'UnifiedWorklistAndProcedureStepServiceClass_Trial_Retired',
          UidType.kServiceClass,
          'Unified Worklist and Procedure Step Service Class - Trial (Retired)');

      expect(sc0.hashCode == fr1.hashCode, true);
      expect(sc0.hashCode == fr2.hashCode, false);

      expect(sc0.value == fr1.value, true);
      expect(sc0.value == fr2.value, false);

      expect(sc0.name == 'Storage Service Class', true);
      expect(sc0.keyword == 'StorageServiceClass', true);
      expect(sc0.value == '1.2.840.10008.4.2', true);
      expect(sc0.type == UidType.kServiceClass, true);
      expect(sc0 is ServiceClass, true);
      expect(sc0.maxLength == 64, true);
      expect(sc0.minLength == 6, true);
      expect(sc0.maxRootLength == 24, true);
    });
  });
}
