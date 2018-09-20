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

class LdapOid extends WKUid {
  const LdapOid(String uid, String keyword, UidType _type, String name,
      {bool isRetired = false})
      : super(uid, keyword, _type, name, isRetired: isRetired);

  // TODO: verify that all SOPClass Definitions from PS3.6 are present
  static const String kName = 'LDAP OID';

  @override
  UidType get type => UidType.kLdapOid;

  static LdapOid lookup(String s) => _map[s];

  static List<LdapOid> get uids => _map.values;

  static List<String> get strings => _map.keys;

  static const LdapOid kDicomDeviceName = LdapOid('1.2.840.10008.15.0.3.1',
      'dicomDeviceName', UidType.kLdapOid, 'dicomDeviceName');

  static const LdapOid kDicomDescription = LdapOid('1.2.840.10008.15.0.3.2',
      'dicomDescription', UidType.kLdapOid, 'dicomDescription');

  static const LdapOid kDicomManufacturer = LdapOid('1.2.840.10008.15.0.3.3',
      'dicomManufacturer', UidType.kLdapOid, 'dicomManufacturer');

  static const LdapOid kDicomManufacturerModelName = LdapOid(
      '1.2.840.10008.15.0.3.4',
      'dicomManufacturerModelName',
      UidType.kLdapOid,
      'dicomManufacturerModelName');

  static const LdapOid kDicomSoftwareVersion = LdapOid('1.2.840.10008.15.0.3.5',
      'dicomSoftwareVersion', UidType.kLdapOid, 'dicomSoftwareVersion');

  static const LdapOid kDicomVendorData = LdapOid('1.2.840.10008.15.0.3.6',
      'dicomVendorData', UidType.kLdapOid, 'dicomVendorData');

  static const LdapOid kDicomAETitle = LdapOid('1.2.840.10008.15.0.3.7',
      'dicomAETitle', UidType.kLdapOid, 'dicomAETitle');

  static const LdapOid kDicomNetworkConnectionReference = LdapOid(
      '1.2.840.10008.15.0.3.8',
      'dicomNetworkConnectionReference',
      UidType.kLdapOid,
      'dicomNetworkConnectionReference');

  static const LdapOid kDicomApplicationCluster = LdapOid(
      '1.2.840.10008.15.0.3.9',
      'dicomApplicationCluster',
      UidType.kLdapOid,
      'dicomApplicationCluster');

  static const LdapOid kDicomAssociationInitiator = LdapOid(
      '1.2.840.10008.15.0.3.10',
      'dicomAssociationInitiator',
      UidType.kLdapOid,
      'dicomAssociationInitiator');

  static const LdapOid kDicomAssociationAcceptor = LdapOid(
      '1.2.840.10008.15.0.3.11',
      'dicomAssociationAcceptor',
      UidType.kLdapOid,
      'dicomAssociationAcceptor');

  static const LdapOid kDicomHostname = LdapOid('1.2.840.10008.15.0.3.12',
      'dicomHostname', UidType.kLdapOid, 'dicomHostname');

  static const LdapOid kDicomPort = LdapOid(
      '1.2.840.10008.15.0.3.13', 'dicomPort', UidType.kLdapOid, 'dicomPort');

  static const LdapOid kDicomSOPClass = LdapOid('1.2.840.10008.15.0.3.14',
      'dicomSOPClass', UidType.kLdapOid, 'dicomSOPClass');

  static const LdapOid kDicomTransferRole = LdapOid('1.2.840.10008.15.0.3.15',
      'dicomTransferRole', UidType.kLdapOid, 'dicomTransferRole');

  static const LdapOid kDicomTransferSyntax = LdapOid('1.2.840.10008.15.0.3.16',
      'dicomTransferSyntax', UidType.kLdapOid, 'dicomTransferSyntax');

  static const LdapOid kDicomPrimaryDeviceType = LdapOid(
      '1.2.840.10008.15.0.3.17',
      'dicomPrimaryDeviceType',
      UidType.kLdapOid,
      'dicomPrimaryDeviceType');

  static const LdapOid kDicomRelatedDeviceReference = LdapOid(
      '1.2.840.10008.15.0.3.18',
      'dicomRelatedDeviceReference',
      UidType.kLdapOid,
      'dicomRelatedDeviceReference');

  static const LdapOid kDicomPreferredCalledAETitle = LdapOid(
      '1.2.840.10008.15.0.3.19',
      'dicomPreferredCalledAETitle',
      UidType.kLdapOid,
      'dicomPreferredCalledAETitle');

  static const LdapOid kDicomTLSCyphersuite = LdapOid('1.2.840.10008.15.0.3.20',
      'dicomTLSCyphersuite', UidType.kLdapOid, 'dicomTLSCyphersuite');

  static const LdapOid kDicomAuthorizedNodeCertificateReference = LdapOid(
      '1.2.840.10008.15.0.3.21',
      'dicomAuthorizedNodeCertificateReference',
      UidType.kLdapOid,
      'dicomAuthorizedNodeCertificateReference');

  static const LdapOid kDicomThisNodeCertificateReference = LdapOid(
      '1.2.840.10008.15.0.3.22',
      'dicomThisNodeCertificateReference',
      UidType.kLdapOid,
      'dicomThisNodeCertificateReference');

  static const LdapOid kDicomInstalled = LdapOid('1.2.840.10008.15.0.3.23',
      'dicomInstalled', UidType.kLdapOid, 'dicomInstalled');

  static const LdapOid kDicomStationName = LdapOid('1.2.840.10008.15.0.3.24',
      'dicomStationName', UidType.kLdapOid, 'dicomStationName');

  static const LdapOid kDicomDeviceSerialNumber = LdapOid(
      '1.2.840.10008.15.0.3.25',
      'dicomDeviceSerialNumber',
      UidType.kLdapOid,
      'dicomDeviceSerialNumber');

  static const LdapOid kDicomInstitutionName = LdapOid(
      '1.2.840.10008.15.0.3.26',
      'dicomInstitutionName',
      UidType.kLdapOid,
      'dicomInstitutionName');

  static const LdapOid kDicomInstitutionAddress = LdapOid(
      '1.2.840.10008.15.0.3.27',
      'dicomInstitutionAddress',
      UidType.kLdapOid,
      'dicomInstitutionAddress');

  static const LdapOid kDicomInstitutionDepartmentName = LdapOid(
      '1.2.840.10008.15.0.3.28',
      'dicomInstitutionDepartmentName',
      UidType.kLdapOid,
      'dicomInstitutionDepartmentName');

  static const LdapOid kDicomIssuerOfPatientID = LdapOid(
      '1.2.840.10008.15.0.3.29',
      'dicomIssuerOfPatientID',
      UidType.kLdapOid,
      'dicomIssuerOfPatientID');

  static const LdapOid kDicomPreferredCallingAETitle = LdapOid(
      '1.2.840.10008.15.0.3.30',
      'dicomPreferredCallingAETitle',
      UidType.kLdapOid,
      'dicomPreferredCallingAETitle');

  static const LdapOid kDicomSupportedCharacterSet = LdapOid(
      '1.2.840.10008.15.0.3.31',
      'dicomSupportedCharacterSet',
      UidType.kLdapOid,
      'dicomSupportedCharacterSet');

  static const LdapOid kDicomConfigurationRoot = LdapOid(
      '1.2.840.10008.15.0.4.1',
      'dicomConfigurationRoot',
      UidType.kLdapOid,
      'dicomConfigurationRoot');

  static const LdapOid kDicomDevicesRoot = LdapOid('1.2.840.10008.15.0.4.2',
      'dicomDevicesRoot', UidType.kLdapOid, 'dicomDevicesRoot');

  static const LdapOid kDicomUniqueAETitlesRegistryRoot = LdapOid(
      '1.2.840.10008.15.0.4.3',
      'dicomUniqueAETitlesRegistryRoot',
      UidType.kLdapOid,
      'dicomUniqueAETitlesRegistryRoot');

  static const LdapOid kDicomDevice = LdapOid(
      '1.2.840.10008.15.0.4.4', 'dicomDevice', UidType.kLdapOid, 'dicomDevice');

  static const LdapOid kDicomNetworkAE = LdapOid('1.2.840.10008.15.0.4.5',
      'dicomNetworkAE', UidType.kLdapOid, 'dicomNetworkAE');

  static const LdapOid kDicomNetworkConnection = LdapOid(
      '1.2.840.10008.15.0.4.6',
      'dicomNetworkConnection',
      UidType.kLdapOid,
      'dicomNetworkConnection');

  static const LdapOid kDicomUniqueAETitle = LdapOid('1.2.840.10008.15.0.4.7',
      'dicomUniqueAETitle', UidType.kLdapOid, 'dicomUniqueAETitle');

  static const LdapOid kDicomTransferCapability = LdapOid(
      '1.2.840.10008.15.0.4.8',
      'dicomTransferCapability',
      UidType.kLdapOid,
      'dicomTransferCapability');

  static const List<LdapOid> members = <LdapOid>[
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

  static const Map<String, LdapOid> _map = <String, LdapOid>{
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
