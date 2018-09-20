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

class CodingSchemeUid extends WKUid {
  const CodingSchemeUid(String uid, String keyword, UidType _type, String name,
      {bool isRetired = true})
      : super(uid, keyword, _type, name, isRetired: isRetired);

  @override
  UidType get type => UidType.kCodingScheme;

  static const String kName = 'Coding Scheme';

  static CodingSchemeUid lookup(String s) => _map[s];

  static List<CodingSchemeUid> get uids => _map.values;

  static List<String> get strings => _map.keys;

  static const CodingSchemeUid kDicomUIDRegistry = CodingSchemeUid(
      '1.2.840.10008.2.6.1',
      'DICOMUIDRegistry',
      UidType.kCodingScheme,
      'DICOM UID Registry');

  static const CodingSchemeUid kDicomControlledTerminology = CodingSchemeUid(
    '1.2.840.10008.2.16.4',
    'DICOMControlledTerminology',
    UidType.kCodingScheme,
    'DICOM Controlled Terminology',
  );

  static const CodingSchemeUid kAdultMouseAnatomyTerminology = CodingSchemeUid(
    '1.2.840.10008.2.16.5',
    'AdultMouseAnatomyTerminology',
    UidType.kCodingScheme,
    'Adult Mouse Anatomy Terminology',
  );

  static const CodingSchemeUid kUberonTerminology = CodingSchemeUid(
    '1.2.840.10008.2.16.6',
    'UberonTerminology',
    UidType.kCodingScheme,
    'Uberon Terminology',
  );

  static const CodingSchemeUid
      kIntegratedTaxonomicInformationSystemAndTaxonomicSerialNumber =
      CodingSchemeUid(
    '1.2.840.10008.2.16.7',
    'IntegratedTaxonomicInformationSystemAndTaxonomicSerialNumber',
    UidType.kCodingScheme,
    'Integrated Taxonomic Information System (ITIS) '
        'Taxonomic Serial Number (TSN)',
  );

  static const CodingSchemeUid kMouseGenomeInitiative = CodingSchemeUid(
    '1.2.840.10008.2.16.8',
    'MouseGenomeInitiative',
    UidType.kCodingScheme,
    'Mouse Genome Initiative (MGI)',
  );

  static const CodingSchemeUid kPubChemCmpoundCID = CodingSchemeUid(
    '1.2.840.10008.2.16.9',
    'PubChemCmpoundCID',
    UidType.kCodingScheme,
    'PubChem Cmpound CID',
  );

  static const List<CodingSchemeUid> members = <CodingSchemeUid>[
    kDicomUIDRegistry,
    kDicomControlledTerminology
  ];

  static const Map<String, CodingSchemeUid> _map = <String, CodingSchemeUid>{
    '1.2.840.10008.2.6.1': kDicomUIDRegistry,
    '1.2.840.10008.2.16.4': kDicomControlledTerminology
  };
}
