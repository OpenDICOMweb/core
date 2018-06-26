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

void main() {
  Server.initialize(name: 'ldap_oid_test', level: Level.info);

  group('LdapOid', () {
    test('String to UID', () {
      Uid uid = Uid.lookup('1.2.840.10008.15.0.3.1');
      expect(uid == LdapOid.kDicomDeviceName, true);

      uid = Uid.lookup('1.2.840.10008.15.0.3.2');
      expect(uid == LdapOid.kDicomDescription, true);

      uid = Uid.lookup('1.2.840.10008.15.0.3.1');
      expect(uid == LdapOid.kDicomDescription, false);
    });

    test('String to LdapOid', () {
      Uid uid = LdapOid.lookup('1.2.840.10008.15.0.3.1');
      expect(uid == LdapOid.kDicomDeviceName, true);

      uid = LdapOid.lookup('1.2.840.10008.15.0.3.2');
      expect(uid == LdapOid.kDicomDescription, true);
    });

    test('Create LdapOid', () {
      const ldo0 = const LdapOid('1.2.840.10008.15.0.3.1', 'dicomDeviceName',
          UidType.kLdapOid, 'dicomDeviceName');

      const ldo1 = const LdapOid('1.2.840.10008.15.0.3.1', 'dicomDeviceName',
          UidType.kLdapOid, 'dicomDeviceName');

      const ldo2 = const LdapOid('1.2.840.10008.15.0.3.2', 'dicomDescription',
          UidType.kLdapOid, 'dicomDescription');

      expect(ldo0.hashCode == ldo1.hashCode, true);
      expect(ldo0.hashCode == ldo2.hashCode, false);

      expect(ldo0.value == ldo1.value, true);
      expect(ldo0.value == ldo2.value, false);

      expect(ldo0.name == 'dicomDeviceName', true);
      expect(ldo0.keyword == 'dicomDeviceName', true);
      expect(ldo0.value == '1.2.840.10008.15.0.3.1', true);
      expect(ldo0.type == UidType.kLdapOid, true);
      expect(ldo0 is LdapOid, true);
      expect(ldo0.maxLength == kUidMaxLength, true);
      expect(ldo0.minLength == kUidMinLength, true);
      expect(ldo0.maxRootLength == kUidMaxRootLength, true);
    });
  });
}
