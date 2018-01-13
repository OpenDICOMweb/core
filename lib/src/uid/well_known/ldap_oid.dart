// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/uid/uid_type.dart';
import 'package:core/src/uid/well_known/wk_uid.dart';


class LdapOid extends WKUid {
  const LdapOid(String uid, String keyword, UidType type, String name,
      {bool isRetired = false})
      : super(uid, keyword, type, name, isRetired: isRetired);

  @override
  String get info => '$runtimeType($asString)';

  @override
  String toString() => asString;


  //Urgent: verify that all SOPClass Definitions from PS3.6 are present
  static const String kName = 'LDAP OID';

  static LdapOid lookup(String s) => map[s];

  static const LdapOid kDicomDeviceName = const LdapOid(
      '1.2.840.10008.15.0.3.1',
      'dicomDeviceName',
      UidType.kLdapOid,
      'dicomDeviceName');

  static const LdapOid kDicomDescription = const LdapOid(
      '1.2.840.10008.15.0.3.2',
      'dicomDescription',
      UidType.kLdapOid,
      'dicomDescription');

  static const LdapOid kDicomManufacturer = const LdapOid(
      '1.2.840.10008.15.0.3.3',
      'dicomManufacturer',
      UidType.kLdapOid,
      'dicomManufacturer');

  static const LdapOid kDicomManufacturerModelName = const LdapOid(
      '1.2.840.10008.15.0.3.4',
      'dicomManufacturerModelName',
      UidType.kLdapOid,
      'dicomManufacturerModelName');

  static const LdapOid kDicomSoftwareVersion = const LdapOid(
      '1.2.840.10008.15.0.3.5',
      'dicomSoftwareVersion',
      UidType.kLdapOid,
      'dicomSoftwareVersion');

  static const LdapOid kDicomVendorData = const LdapOid(
      '1.2.840.10008.15.0.3.6',
      'dicomVendorData',
      UidType.kLdapOid,
      'dicomVendorData');

  static const LdapOid kDicomAETitle = const LdapOid('1.2.840.10008.15.0.3.7',
      'dicomAETitle', UidType.kLdapOid, 'dicomAETitle');

  static const LdapOid kDicomNetworkConnectionReference = const LdapOid(
      '1.2.840.10008.15.0.3.8',
      'dicomNetworkConnectionReference',
      UidType.kLdapOid,
      'dicomNetworkConnectionReference');

  static const LdapOid kDicomApplicationCluster = const LdapOid(
      '1.2.840.10008.15.0.3.9',
      'dicomApplicationCluster',
      UidType.kLdapOid,
      'dicomApplicationCluster');

  static const LdapOid kDicomAssociationInitiator = const LdapOid(
      '1.2.840.10008.15.0.3.10',
      'dicomAssociationInitiator',
      UidType.kLdapOid,
      'dicomAssociationInitiator');

  static const LdapOid kDicomAssociationAcceptor = const LdapOid(
      '1.2.840.10008.15.0.3.11',
      'dicomAssociationAcceptor',
      UidType.kLdapOid,
      'dicomAssociationAcceptor');

  static const LdapOid kDicomHostname = const LdapOid('1.2.840.10008.15.0.3.12',
      'dicomHostname', UidType.kLdapOid, 'dicomHostname');

  static const LdapOid kDicomPort = const LdapOid(
      '1.2.840.10008.15.0.3.13', 'dicomPort', UidType.kLdapOid, 'dicomPort');

  static const LdapOid kDicomSOPClass = const LdapOid('1.2.840.10008.15.0.3.14',
      'dicomSOPClass', UidType.kLdapOid, 'dicomSOPClass');

  static const LdapOid kDicomTransferRole = const LdapOid(
      '1.2.840.10008.15.0.3.15',
      'dicomTransferRole',
      UidType.kLdapOid,
      'dicomTransferRole');

  static const LdapOid kDicomTransferSyntax = const LdapOid(
      '1.2.840.10008.15.0.3.16',
      'dicomTransferSyntax',
      UidType.kLdapOid,
      'dicomTransferSyntax');

  static const LdapOid kDicomPrimaryDeviceType = const LdapOid(
      '1.2.840.10008.15.0.3.17',
      'dicomPrimaryDeviceType',
      UidType.kLdapOid,
      'dicomPrimaryDeviceType');

  static const LdapOid kDicomRelatedDeviceReference = const LdapOid(
      '1.2.840.10008.15.0.3.18',
      'dicomRelatedDeviceReference',
      UidType.kLdapOid,
      'dicomRelatedDeviceReference');

  static const LdapOid kDicomPreferredCalledAETitle = const LdapOid(
      '1.2.840.10008.15.0.3.19',
      'dicomPreferredCalledAETitle',
      UidType.kLdapOid,
      'dicomPreferredCalledAETitle');

  static const LdapOid kDicomTLSCyphersuite = const LdapOid(
      '1.2.840.10008.15.0.3.20',
      'dicomTLSCyphersuite',
      UidType.kLdapOid,
      'dicomTLSCyphersuite');

  static const LdapOid kDicomAuthorizedNodeCertificateReference = const LdapOid(
      '1.2.840.10008.15.0.3.21',
      'dicomAuthorizedNodeCertificateReference',
      UidType.kLdapOid,
      'dicomAuthorizedNodeCertificateReference');

  static const LdapOid kDicomThisNodeCertificateReference = const LdapOid(
      '1.2.840.10008.15.0.3.22',
      'dicomThisNodeCertificateReference',
      UidType.kLdapOid,
      'dicomThisNodeCertificateReference');

  static const LdapOid kDicomInstalled = const LdapOid(
      '1.2.840.10008.15.0.3.23',
      'dicomInstalled',
      UidType.kLdapOid,
      'dicomInstalled');

  static const LdapOid kDicomStationName = const LdapOid(
      '1.2.840.10008.15.0.3.24',
      'dicomStationName',
      UidType.kLdapOid,
      'dicomStationName');

  static const LdapOid kDicomDeviceSerialNumber = const LdapOid(
      '1.2.840.10008.15.0.3.25',
      'dicomDeviceSerialNumber',
      UidType.kLdapOid,
      'dicomDeviceSerialNumber');

  static const LdapOid kDicomInstitutionName = const LdapOid(
      '1.2.840.10008.15.0.3.26',
      'dicomInstitutionName',
      UidType.kLdapOid,
      'dicomInstitutionName');

  static const LdapOid kDicomInstitutionAddress = const LdapOid(
      '1.2.840.10008.15.0.3.27',
      'dicomInstitutionAddress',
      UidType.kLdapOid,
      'dicomInstitutionAddress');

  static const LdapOid kDicomInstitutionDepartmentName = const LdapOid(
      '1.2.840.10008.15.0.3.28',
      'dicomInstitutionDepartmentName',
      UidType.kLdapOid,
      'dicomInstitutionDepartmentName');

  static const LdapOid kDicomIssuerOfPatientID = const LdapOid(
      '1.2.840.10008.15.0.3.29',
      'dicomIssuerOfPatientID',
      UidType.kLdapOid,
      'dicomIssuerOfPatientID');

  static const LdapOid kDicomPreferredCallingAETitle = const LdapOid(
      '1.2.840.10008.15.0.3.30',
      'dicomPreferredCallingAETitle',
      UidType.kLdapOid,
      'dicomPreferredCallingAETitle');

  static const LdapOid kDicomSupportedCharacterSet = const LdapOid(
      '1.2.840.10008.15.0.3.31',
      'dicomSupportedCharacterSet',
      UidType.kLdapOid,
      'dicomSupportedCharacterSet');

  static const LdapOid kDicomConfigurationRoot = const LdapOid(
      '1.2.840.10008.15.0.4.1',
      'dicomConfigurationRoot',
      UidType.kLdapOid,
      'dicomConfigurationRoot');

  static const LdapOid kDicomDevicesRoot = const LdapOid(
      '1.2.840.10008.15.0.4.2',
      'dicomDevicesRoot',
      UidType.kLdapOid,
      'dicomDevicesRoot');

  static const LdapOid kDicomUniqueAETitlesRegistryRoot = const LdapOid(
      '1.2.840.10008.15.0.4.3',
      'dicomUniqueAETitlesRegistryRoot',
      UidType.kLdapOid,
      'dicomUniqueAETitlesRegistryRoot');

  static const LdapOid kDicomDevice = const LdapOid(
      '1.2.840.10008.15.0.4.4', 'dicomDevice', UidType.kLdapOid, 'dicomDevice');

  static const LdapOid kDicomNetworkAE = const LdapOid('1.2.840.10008.15.0.4.5',
      'dicomNetworkAE', UidType.kLdapOid, 'dicomNetworkAE');

  static const LdapOid kDicomNetworkConnection = const LdapOid(
      '1.2.840.10008.15.0.4.6',
      'dicomNetworkConnection',
      UidType.kLdapOid,
      'dicomNetworkConnection');

  static const LdapOid kDicomUniqueAETitle = const LdapOid(
      '1.2.840.10008.15.0.4.7',
      'dicomUniqueAETitle',
      UidType.kLdapOid,
      'dicomUniqueAETitle');

  static const LdapOid kDicomTransferCapability = const LdapOid(
      '1.2.840.10008.15.0.4.8',
      'dicomTransferCapability',
      UidType.kLdapOid,
      'dicomTransferCapability');

  static const List<LdapOid> members = const <LdapOid>[
    kDicomDeviceName,
    kDicomDescription,
    kDicomManufacturer,
    kDicomManufacturerModelName,
    kDicomSoftwareVersion,
    kDicomVendorData,
    kDicomNetworkConnectionReference,
    kDicomApplicationCluster,
    kDicomAssociationInitiator,
    kDicomAssociationAcceptor,
    kDicomHostname,
    kDicomPort,
    kDicomSOPClass,
    kDicomTransferRole,
    kDicomTransferSyntax,
    kDicomPrimaryDeviceType,
    kDicomRelatedDeviceReference,
    kDicomPreferredCalledAETitle,
    kDicomTLSCyphersuite,
    kDicomAuthorizedNodeCertificateReference,
    kDicomThisNodeCertificateReference,
    kDicomInstalled,
    kDicomStationName,
    kDicomDeviceSerialNumber,
    kDicomInstitutionName,
    kDicomInstitutionAddress,
    kDicomInstitutionDepartmentName,
    kDicomIssuerOfPatientID,
    kDicomPreferredCallingAETitle,
    kDicomSupportedCharacterSet,
    kDicomConfigurationRoot,
    kDicomDevicesRoot,
    kDicomUniqueAETitlesRegistryRoot,
    kDicomDevice,
    kDicomNetworkAE,
    kDicomNetworkConnection,
    kDicomUniqueAETitle,
    kDicomTransferCapability
  ];

  static const Map<String, LdapOid> map = const <String, LdapOid>{
    //   '': ,
    '1.2.840.10008.15.0.3.1': kDicomDeviceName,
    '1.2.840.10008.15.0.3.2': kDicomDescription,
    '1.2.840.10008.15.0.3.3': kDicomManufacturer,
    '1.2.840.10008.15.0.3.4': kDicomManufacturerModelName,
    '1.2.840.10008.15.0.3.5': kDicomSoftwareVersion,
    '1.2.840.10008.15.0.3.6': kDicomVendorData,
    '1.2.840.10008.15.0.3.8': kDicomNetworkConnectionReference,
    '1.2.840.10008.15.0.3.9': kDicomApplicationCluster,
    '1.2.840.10008.15.0.3.10': kDicomAssociationInitiator,
    '1.2.840.10008.15.0.3.11': kDicomAssociationAcceptor,
    '1.2.840.10008.15.0.3.12': kDicomHostname,
    '1.2.840.10008.15.0.3.13': kDicomPort,
    '1.2.840.10008.15.0.3.14': kDicomSOPClass,
    '1.2.840.10008.15.0.3.15': kDicomTransferRole,
    '1.2.840.10008.15.0.3.16': kDicomTransferSyntax,
    '1.2.840.10008.15.0.3.17': kDicomPrimaryDeviceType,
    '1.2.840.10008.15.0.3.18': kDicomRelatedDeviceReference,
    '1.2.840.10008.15.0.3.19': kDicomPreferredCalledAETitle,
    '1.2.840.10008.15.0.3.20': kDicomTLSCyphersuite,
    '1.2.840.10008.15.0.3.21': kDicomAuthorizedNodeCertificateReference,
    '1.2.840.10008.15.0.3.22': kDicomThisNodeCertificateReference,
    '1.2.840.10008.15.0.3.23': kDicomInstalled,
    '1.2.840.10008.15.0.3.24': kDicomStationName,
    '1.2.840.10008.15.0.3.25': kDicomDeviceSerialNumber,
    '1.2.840.10008.15.0.3.26': kDicomInstitutionName,
    '1.2.840.10008.15.0.3.27': kDicomInstitutionAddress,
    '1.2.840.10008.15.0.3.28': kDicomInstitutionDepartmentName,
    '1.2.840.10008.15.0.3.29': kDicomIssuerOfPatientID,
    '1.2.840.10008.15.0.3.30': kDicomPreferredCallingAETitle,
    '1.2.840.10008.15.0.3.31': kDicomSupportedCharacterSet,
    '1.2.840.10008.15.0.4.1': kDicomConfigurationRoot,
    '1.2.840.10008.15.0.4.2': kDicomDevicesRoot,
    '1.2.840.10008.15.0.4.3': kDicomUniqueAETitlesRegistryRoot,
    '1.2.840.10008.15.0.4.4': kDicomDevice,
    '1.2.840.10008.15.0.4.5': kDicomNetworkAE,
    '1.2.840.10008.15.0.4.6': kDicomNetworkConnection,
    '1.2.840.10008.15.0.4.7': kDicomUniqueAETitle,
    '1.2.840.10008.15.0.4.8': kDicomTransferCapability,
  };
}
