// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/value/uid/well_known/uid_type.dart';
import 'package:core/src/value/uid/well_known/wk_uid.dart';

class ApplicationHostingModel extends WKUid {
  const ApplicationHostingModel(
      String uid, String keyword, UidType _type, String name,
      {bool isRetired = true})
      : super(uid, keyword, _type, name, isRetired: isRetired);

  static const String kName = 'Coding Scheme';

  @override
  UidType get type => UidType.kCodingScheme;

  static ApplicationHostingModel lookup(String s) => _map[s];

  static List<ApplicationHostingModel> get uids => _map.values;

  static List<String> get strings => _map.keys;

  static const WKUid kNativeDicomModel = const WKUid(
      '1.2.840.10008.7.1.1',
      'NativeDICOMModel',
      UidType.kApplicationHostingModel,
      'Native DICOM Model');

  static const WKUid kAbstractMultiDimensionalImageModel = const WKUid(
      '1.2.840.10008.7.1.2',
      'AbstractMulti_DimensionalImageModel',
      UidType.kApplicationHostingModel,
      'Abstract Multi-Dimensional Image Model');

  static const List<ApplicationHostingModel> members =
      const <ApplicationHostingModel>[
    kNativeDicomModel,
    kAbstractMultiDimensionalImageModel
  ];

  static const Map<String, ApplicationHostingModel> _map =
      const <String, ApplicationHostingModel>{
    '1.2.840.10008.7.1.1': kNativeDicomModel,
    '1.2.840.10008.7.1.2': kAbstractMultiDimensionalImageModel
  };
}