// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
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
      final ahm0 = new ApplicationHostingModel(
          '1.2.840.10008.7.1.1',
          'NativeDICOMModel',
          UidType.kApplicationHostingModel,
          'Native DICOM Model');

      final ahm1 = new ApplicationHostingModel(
          '1.2.840.10008.7.1.1',
          'NativeDICOMModel',
          UidType.kApplicationHostingModel,
          'Native DICOM Model');

      final ahm2 = new ApplicationHostingModel(
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
      expect(ahm0.maxLength == 64, true);
      expect(ahm0.minLength == 6, true);
      expect(ahm0.maxRootLength == 24, true);
    });
  });
}
