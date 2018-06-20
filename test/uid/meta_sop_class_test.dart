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

void main() {
  Server.initialize(name: 'meta_sop_class_test', level: Level.info);

  group('MetaSopClass', () {
    test('String to UID', () {
      Uid uid = Uid.lookup('1.2.840.10008.3.1.2.1.4');
      expect(uid == MetaSopClass.kDetachedPatientManagement, true);

      uid = Uid.lookup('1.2.840.10008.3.1.2.5.4');
      expect(uid == MetaSopClass.kDetachedResultsManagement, true);

      uid = Uid.lookup('1.2.840.10008.3.1.2.5.5');
      expect(uid == MetaSopClass.kDetachedResultsManagement, false);
    });

    test('String to MetaSopClass', () {
      Uid uid = MetaSopClass.lookup('1.2.840.10008.3.1.2.1.4');
      expect(uid == MetaSopClass.kDetachedPatientManagement, true);

      uid = MetaSopClass.lookup('1.2.840.10008.3.1.2.5.4');
      expect(uid == MetaSopClass.kDetachedResultsManagement, true);
    });

    test('Create MetaSopClass', () {
      const msc0 = const MetaSopClass(
          '1.2.840.10008.3.1.2.1.4',
          'DetachedPatientManagementMetaSOPClass_Retired',
          UidType.kMetaSOPClass,
          'Detached Patient Management Meta SOP Class (Retired)');

      const msc1 = const MetaSopClass(
          '1.2.840.10008.3.1.2.1.4',
          'DetachedPatientManagementMetaSOPClass_Retired',
          UidType.kMetaSOPClass,
          'Detached Patient Management Meta SOP Class (Retired)');

      const msc2 = const MetaSopClass(
          '1.2.840.10008.3.1.2.5.4',
          'DetachedResultsManagementMetaSOPClass_Retired',
          UidType.kMetaSOPClass,
          'Detached Results Management Meta SOP Class (Retired)');

      expect(msc0.hashCode == msc1.hashCode, true);
      expect(msc0.hashCode == msc2.hashCode, false);

      expect(msc0.value == msc1.value, true);
      expect(msc0.value == msc2.value, false);

      expect(
          msc0.name == 'Detached Patient Management Meta SOP Class (Retired)',
          true);
      expect(msc0.keyword == 'DetachedPatientManagementMetaSOPClass_Retired',
          true);
      expect(msc0.value == '1.2.840.10008.3.1.2.1.4', true);
      expect(msc0.type == UidType.kMetaSOPClass, true);
      expect(msc0 is MetaSopClass, true);
      expect(msc0 is MetaSopClass, true);
  //    print('msc0: ${msc0.minLength}');
      expect(msc0.maxLength == kUidMaxLength, true);
      expect(msc0.minLength == kUidMinLength, true);
      expect(msc0.maxRootLength == kUidMaxRootLength, true);
    });
  });
}
