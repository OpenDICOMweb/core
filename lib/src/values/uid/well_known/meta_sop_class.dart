//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/values/uid/well_known/uid_type.dart';
import 'package:core/src/values/uid/well_known/wk_uid.dart';

// ignore_for_file: public_member_api_docs

class MetaSopClass extends WKUid {
  const MetaSopClass(String uid, String keyword, UidType _type, String name,
      {bool isRetired = true})
      : super(uid, keyword, _type, name, isRetired: isRetired);

  static const String kName = 'Meta SOP Class';

  @override
  UidType get type => UidType.kMetaSOPClass;

  static MetaSopClass lookup(String s) => _map[s];

  static List<MetaSopClass> get uids => _map.values;

  static List<String> get strings => _map.keys;

  static const MetaSopClass kDetachedPatientManagement = MetaSopClass(
      '1.2.840.10008.3.1.2.1.4',
      'DetachedPatientManagementMetaSOPClass_Retired',
      UidType.kMetaSOPClass,
      'Detached Patient Management Meta SOP Class (Retired)',
      isRetired: true);

  static const MetaSopClass kDetachedResultsManagement = MetaSopClass(
      '1.2.840.10008.3.1.2.5.4',
      'DetachedResultsManagementMetaSOPClass_Retired',
      UidType.kMetaSOPClass,
      'Detached Results Management Meta SOP Class (Retired)',
      isRetired: true);

  static const MetaSopClass kDetachedStudyManagement = MetaSopClass(
      '1.2.840.10008.3.1.2.5.5',
      'DetachedStudyManagementMetaSOPClass_Retired',
      UidType.kMetaSOPClass,
      'Detached Study Management Meta SOP Class (Retired)',
      isRetired: true);

  static const MetaSopClass kBasicGrayscalePrintManagement = MetaSopClass(
      '1.2.840.10008.5.1.1.9',
      'BasicGrayscalePrintManagementMetaSOPClass',
      UidType.kMetaSOPClass,
      'Basic Grayscale Print Management Meta SOP Class');

  static const MetaSopClass kReferencedGrayscalePrintManagement = MetaSopClass(
      '1.2.840.10008.5.1.1.9.1',
      'ReferencedGrayscalePrintManagementMetaSOPClass_Retired',
      UidType.kMetaSOPClass,
      'Referenced Grayscale Print Management Meta SOP Class (Retired)',
      isRetired: true);

  static const MetaSopClass kBasicColorPrintManagement = MetaSopClass(
      '1.2.840.10008.5.1.1.18',
      'BasicColorPrintManagementMetaSOPClass',
      UidType.kMetaSOPClass,
      'Basic Color Print Management Meta SOP Class');

  static const MetaSopClass kReferencedColorPrintManagement = MetaSopClass(
      '1.2.840.10008.5.1.1.18.1',
      'ReferencedColorPrintManagementMetaSOPClass_Retired',
      UidType.kMetaSOPClass,
      'Referenced Color Print Management Meta SOP Class (Retired)',
      isRetired: true);

  static const MetaSopClass kPullStoredPrintManagement = MetaSopClass(
      '1.2.840.10008.5.1.1.32',
      'PullStoredPrintManagementMetaSOPClass_Retired',
      UidType.kMetaSOPClass,
      'Pull Stored Print Management Meta SOP Class (Retired)',
      isRetired: true);

  static const MetaSopClass kGeneralPurposeWorklistManagement = MetaSopClass(
      '1.2.840.10008.5.1.4.32',
      'GeneralPurposeWorklistManagementMetaSOPClass_Retired',
      UidType.kMetaSOPClass,
      'General Purpose Worklist Management Meta SOP Class (Retired)',
      isRetired: true);

  static const List<MetaSopClass> members = <MetaSopClass>[
    kDetachedPatientManagement,
    kDetachedResultsManagement,
    kDetachedStudyManagement,
    kBasicGrayscalePrintManagement,
    kReferencedGrayscalePrintManagement,
    kBasicColorPrintManagement,
    kReferencedColorPrintManagement,
    kPullStoredPrintManagement,
    kGeneralPurposeWorklistManagement
  ];

  static const Map<String, MetaSopClass> _map = <String, MetaSopClass>{
    '1.2.840.10008.3.1.2.1.4': kDetachedPatientManagement,
    '1.2.840.10008.3.1.2.5.4': kDetachedResultsManagement,
    '1.2.840.10008.3.1.2.5.5': kDetachedStudyManagement,
    '1.2.840.10008.5.1.1.9': kBasicGrayscalePrintManagement,
    '1.2.840.10008.5.1.1.9.1': kReferencedGrayscalePrintManagement,
    '1.2.840.10008.5.1.1.18': kBasicColorPrintManagement,
    '1.2.840.10008.5.1.1.18.1': kReferencedColorPrintManagement,
    '1.2.840.10008.5.1.1.32': kPullStoredPrintManagement,
    '1.2.840.10008.5.1.4.32': kGeneralPurposeWorklistManagement
  };
}
