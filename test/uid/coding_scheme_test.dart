// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'udi/coding_scheme_test', level: Level.info);

  group('CodingSchemeUid', () {
    test('String to UID', () {
      Uid uid = Uid.lookup('1.2.840.10008.2.6.1');
      expect(uid == CodingSchemeUid.kDicomUIDRegistry, true);

      uid = Uid.lookup('1.2.840.10008.2.16.4');
      expect(uid == CodingSchemeUid.kDicomControlledTerminology,
          true);

      uid = Uid.lookup('1.2.840.10008.7.1.3');
      expect(uid == CodingSchemeUid.kDicomControlledTerminology, false);
    });

    test('String to LdapOid', () {
      Uid uid = CodingSchemeUid.lookup('1.2.840.10008.2.6.1');
      expect(uid == CodingSchemeUid.kDicomUIDRegistry, true);

      uid = CodingSchemeUid.lookup('1.2.840.10008.15.0.3.2');
      expect(uid == CodingSchemeUid.kDicomUIDRegistry, false);
    });

    test('Create CodingSchemeUid', () {
      const cs0 = const CodingSchemeUid(
          '1.2.840.10008.2.16.5',
          'AdultMouseAnatomyTerminology',
          UidType.kCodingScheme,
          'Adult Mouse Anatomy Terminology');

      const cs1 = const CodingSchemeUid(
          '1.2.840.10008.2.16.5',
          'AdultMouseAnatomyTerminology',
          UidType.kCodingScheme,
          'Adult Mouse Anatomy Terminology');

      const cs2 = const CodingSchemeUid(
          '1.2.840.10008.2.16.8',
          'MouseGenomeInitiative',
          UidType.kCodingScheme,
          'Mouse Genome Initiative (MGI)');

      expect(cs0.hashCode == cs1.hashCode, true);
      expect(cs0.hashCode == cs2.hashCode, false);

      expect(cs0.value == cs1.value, true);
      expect(cs0.value == cs2.value, false);

      expect(cs0.name == 'Adult Mouse Anatomy Terminology', true);
      expect(cs0.keyword == 'AdultMouseAnatomyTerminology', true);
      expect(cs0.value == '1.2.840.10008.2.16.5', true);
      expect(cs0.type == UidType.kCodingScheme, true);
      expect(cs0 is CodingSchemeUid, true);
      expect(cs0.maxLength == 64, true);
      expect(cs0.minLength == 6, true);
      expect(cs0.maxRootLength == 24, true);
    });
  });
}
