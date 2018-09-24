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
  Server.initialize(name: 'uid/application_hosting_test', level: Level.info);

  group('ApplicationHostringModel', () {
    test('String to UID', () {
      Uid uid = Uid.lookup('1.2.840.10008.7.1.1');
      expect(uid == ApplicationHostingModel.kNativeDicomModel, true);

      uid = Uid.lookup('1.2.840.10008.7.1.2');
      expect(uid == ApplicationHostingModel.kAbstractMultiDimensionalImageModel,
          true);

      uid = Uid.lookup('1.2.840.10008.7.1.3');
      expect(uid == ApplicationHostingModel.kNativeDicomModel, false);
    });

    test('String to LdapOid', () {
      Uid uid = ApplicationHostingModel.lookup('1.2.840.10008.7.1.1');
      expect(uid == ApplicationHostingModel.kNativeDicomModel, true);

      uid = ApplicationHostingModel.lookup('1.2.840.10008.15.0.3.2');
      expect(uid == ApplicationHostingModel.kNativeDicomModel, false);
    });

    test('Create ApplicationHostingModel', () {
      const ahm0 = ApplicationHostingModel(
          '1.2.840.10008.7.1.1',
          'NativeDICOMModel',
          UidType.kApplicationHostingModel,
          'Native DICOM Model');

      const ahm1 = ApplicationHostingModel(
          '1.2.840.10008.7.1.1',
          'NativeDICOMModel',
          UidType.kApplicationHostingModel,
          'Native DICOM Model');

      const ahm2 = ApplicationHostingModel(
          '1.2.840.10008.7.1.2',
          'AbstractMulti_DimensionalImageModel',
          UidType.kApplicationHostingModel,
          'Abstract Multi-Dimensional Image Model');

      expect(ahm0.hashCode == ahm1.hashCode, true);
      expect(ahm0.hashCode == ahm2.hashCode, false);

      expect(ahm0.value == ahm1.value, true);
      expect(ahm0.value == ahm2.value, false);

      expect(ahm0.name == 'Native DICOM Model', true);
      expect(ahm0.keyword == 'NativeDICOMModel', true);
      expect(ahm0.value == '1.2.840.10008.7.1.1', true);
      expect(ahm0.type == UidType.kCodingScheme, true);
      expect(ahm0 is ApplicationHostingModel, true);
      expect(ahm0.maxLength == kUidMaxLength, true);
      expect(ahm0.minLength == kUidMinLength, true);
      expect(ahm0.maxRootLength == kUidMaxRootLength, true);
    });
  });
}
