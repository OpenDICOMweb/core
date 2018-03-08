// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/value/uid/well_known/uid_type.dart';
import 'package:core/src/value/uid/well_known/wk_uid.dart';

class ServiceClass extends WKUid {
  const ServiceClass(String uid, String keyword, UidType _type, String name,
      {bool isRetired = true})
      : super(uid, keyword, _type, name, isRetired: isRetired);

  static const String kName = 'Service Class';

  @override
  UidType get type => UidType.kServiceClass;

  static ServiceClass lookup(String s) => _map[s];

  static List<ServiceClass> get uids => _map.values;

  static List<String> get strings => _map.keys;


  static const ServiceClass kStorageServiceClass = const ServiceClass('1.2.840.10008.4.2',
      'StorageServiceClass', UidType.kServiceClass, 'Storage Service Class');

  static const ServiceClass kUnifiedWorklistAndProcedureStepServiceClassTrial =
      const ServiceClass(
          '1.2.840.10008.5.1.4.34.4',
          'UnifiedWorklistAndProcedureStepServiceClass_Trial_Retired',
          UidType.kServiceClass,
          'Unified Worklist and Procedure Step Service Class - Trial (Retired)',
          isRetired: true);

  static const ServiceClass kUnifiedWorklistAndProcedureStepServiceClass = const ServiceClass(
    '1.2.840.10008.5.1.4.34.6',
    'UnifiedWorklistAndProcedureStepServiceClass',
    UidType.kServiceClass,
    'Unified Worklist and Procedure Step Service Class',
  );

  static const List<ServiceClass> members = const <ServiceClass>[
    kStorageServiceClass,
    kUnifiedWorklistAndProcedureStepServiceClassTrial,
    kUnifiedWorklistAndProcedureStepServiceClass,
  ];

  static const Map<String, ServiceClass> _map = const <String, ServiceClass>{
    '1.2.840.10008.4.2': kStorageServiceClass,
    '1.2.840.10008.5.1.4.34.4':
        kUnifiedWorklistAndProcedureStepServiceClassTrial,
    '1.2.840.10008.5.1.4.34.6': kUnifiedWorklistAndProcedureStepServiceClass,
  };
}
