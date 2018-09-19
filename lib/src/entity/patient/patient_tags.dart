//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/tag.dart';
import 'package:core/src/vr.dart';

// ignore_for_file: public_member_api_docs

// TODO: move to dictionary
class PatientTag {
  final String keyword;
  final int tag;
  final String name;
  final int vrIndex;
  final VM vm;
  final EType type;
  final bool isRetired;

  const PatientTag(
      this.keyword, this.tag, this.name, this.vrIndex, this.vm, this.type,
      {this.isRetired = false});

  static const PatientTag kPatientName = const PatientTag('PatientName',
      0x00100010, 'Patient\'s Name', kPNIndex, VM.k1, EType.kUnknown,
      isRetired: false);

  static const PatientTag kPatientID = const PatientTag(
      'PatientID', 0x00100020, 'Patient ID', kLOIndex, VM.k1, EType.kUnknown,
      isRetired: false);

  static const PatientTag kIssuerOfPatientID = const PatientTag(
      'IssuerOfPatientID',
      0x00100021,
      'Issuer of Patient ID',
      kLOIndex,
      VM.k1,
      EType.k3,
      isRetired: false);

  static const PatientTag kTypeOfPatientID = const PatientTag('TypeOfPatientID',
      0x00100022, 'Type of Patient ID', kCSIndex, VM.k1, EType.kUnknown,
      isRetired: false);

  static const PatientTag kIssuerOfPatientIDQualifiersSequence =
      const PatientTag('IssuerOfPatientIDQualifiersSequence', 0x00100024,
          'Issuer of Patient ID Qualifiers Sequence', kSQIndex, VM.k1, EType.k3,
          isRetired: false);

  static const PatientTag kPatientBirthDate = const PatientTag(
      'PatientBirthDate',
      0x00100030,
      'Patient\'s Birth Date',
      kDAIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);

  static const PatientTag kPatientBirthTime = const PatientTag(
      'PatientBirthTime',
      0x00100032,
      'Patient\'s Birth Time',
      kTMIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);

  static const PatientTag kPatientSex = const PatientTag('PatientSex',
      0x00100040, 'Patient\'s Sex', kCSIndex, VM.k1, EType.kUnknown,
      isRetired: false);

  static const PatientTag kPatientInsurancePlanCodeSequence = const PatientTag(
      'PatientInsurancePlanCodeSequence',
      0x00100050,
      'Patient\'s Insurance Plan Code Sequence',
      kSQIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kPatientPrimaryLanguageCodeSequence =
      const PatientTag(
          'PatientPrimaryLanguageCodeSequence',
          0x00100101,
          'Patient\'s Primary Language Code Sequence',
          kSQIndex,
          VM.k1,
          EType.kUnknown,
          isRetired: false);
  static const PatientTag kPatientPrimaryLanguageModifierCodeSequence =
      const PatientTag(
          'PatientPrimaryLanguageModifierCodeSequence',
          0x00100102,
          'Patient\'s Primary Language Modifier Code Sequence',
          kSQIndex,
          VM.k1,
          EType.kUnknown,
          isRetired: false);
  static const PatientTag kQualityControlPatient = const PatientTag(
      'QualityControlPatient',
      0x00100200,
      'Quality Control Patient',
      kCSIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kQualityControlPatientTypeCodeSequence =
      const PatientTag(
          'QualityControlPatientTypeCodeSequence',
          0x00100201,
          'Quality Control Patient Type Code Sequence',
          kSQIndex,
          VM.k1,
          EType.kUnknown,
          isRetired: false);
  static const PatientTag kOtherPatientIDs = const PatientTag('OtherPatientIDs',
      0x00101000, 'Other Patient IDs', kLOIndex, VM.k1_n, EType.kUnknown,
      isRetired: false);
  static const PatientTag kOtherPatientNames = const PatientTag(
      'OtherPatientNames',
      0x00101001,
      'Other Patient Names',
      kPNIndex,
      VM.k1_n,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kOtherPatientIDsSequence = const PatientTag(
      'OtherPatientIDsSequence',
      0x00101002,
      'Other Patient IDs Sequence',
      kSQIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kPatientBirthName = const PatientTag(
      'PatientBirthName',
      0x00101005,
      'Patient\'s Birth Name',
      kPNIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kPatientAge = const PatientTag('PatientAge',
      0x00101010, 'Patient\'s Age', kASIndex, VM.k1, EType.kUnknown,
      isRetired: false);
  static const PatientTag kPatientSize = const PatientTag('PatientSize',
      0x00101020, 'Patient\'s Size', kDSIndex, VM.k1, EType.kUnknown,
      isRetired: false);
  static const PatientTag kPatientSizeCodeSequence = const PatientTag(
      'PatientSizeCodeSequence',
      0x00101021,
      'Patient\'s Size Code Sequence',
      kSQIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kPatientWeight = const PatientTag('PatientWeight',
      0x00101030, 'Patient\'s Weight', kDSIndex, VM.k1, EType.kUnknown,
      isRetired: false);
  static const PatientTag kPatientAddress = const PatientTag('PatientAddress',
      0x00101040, 'Patient\'s Address', kLOIndex, VM.k1, EType.kUnknown,
      isRetired: false);
  static const PatientTag kInsurancePlanIdentification = const PatientTag(
      'InsurancePlanIdentification',
      0x00101050,
      'Insurance Plan Identification',
      kLOIndex,
      VM.k1_n,
      EType.kUnknown,
      isRetired: true);
  static const PatientTag kPatientMotherBirthName = const PatientTag(
      'PatientMotherBirthName',
      0x00101060,
      'Patient\'s Mother\'s Birth Name',
      kPNIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kMilitaryRank = const PatientTag('MilitaryRank',
      0x00101080, 'Military Rank', kLOIndex, VM.k1, EType.kUnknown,
      isRetired: false);
  static const PatientTag kBranchOfService = const PatientTag('BranchOfService',
      0x00101081, 'Branch of Service', kLOIndex, VM.k1, EType.kUnknown,
      isRetired: false);
  static const PatientTag kMedicalRecordLocator = const PatientTag(
      'MedicalRecordLocator',
      0x00101090,
      'Medical Record Locator',
      kLOIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kReferencedPatientPhotoSequence = const PatientTag(

      // (0010,1100)
      'ReferencedPatientPhotoSequence',
      0x00101100,
      'Referenced Patient Photo Sequence',
      kSQIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kMedicalAlerts = const PatientTag('MedicalAlerts',
      0x00102000, 'Medical Alerts', kLOIndex, VM.k1_n, EType.kUnknown,
      isRetired: false);
  static const PatientTag kAllergies = const PatientTag(
      'Allergies', 0x00102110, 'Allergies', kLOIndex, VM.k1_n, EType.kUnknown,
      isRetired: false);
  static const PatientTag kCountryOfResidence = const PatientTag(
      'CountryOfResidence',
      0x00102150,
      'Country of Residence',
      kLOIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kRegionOfResidence = const PatientTag(
      'RegionOfResidence',
      0x00102152,
      'Region of Residence',
      kLOIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kPatientTelephoneNumbers = const PatientTag(
      'PatientTelephoneNumbers',
      0x00102154,
      'Patient\'s Telephone Numbers',
      kSHIndex,
      VM.k1_n,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kEthnicGroup = const PatientTag('EthnicGroup',
      0x00102160, 'Ethnic Group', kSHIndex, VM.k1, EType.kUnknown,
      isRetired: false);
  static const PatientTag kOccupation = const PatientTag(
      'Occupation', 0x00102180, 'Occupation', kSHIndex, VM.k1, EType.kUnknown,
      isRetired: false);
  static const PatientTag kSmokingStatus = const PatientTag('SmokingStatus',
      0x001021A0, 'Smoking Status', kCSIndex, VM.k1, EType.kUnknown,
      isRetired: false);
  static const PatientTag kAdditionalPatientHistory = const PatientTag(
      'AdditionalPatientHistory',
      0x001021B0,
      'Additional Patient History',
      kLTIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kPregnancyStatus = const PatientTag('PregnancyStatus',
      0x001021C0, 'Pregnancy Status', kUSIndex, VM.k1, EType.kUnknown,
      isRetired: false);
  static const PatientTag kLastMenstrualDate = const PatientTag(
      'LastMenstrualDate',
      0x001021D0,
      'Last Menstrual Date',
      kDAIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kPatientReligiousPreference = const PatientTag(
      'PatientReligiousPreference',
      0x001021F0,
      'Patient\'s Religious Preference',
      kLOIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kPatientSpeciesDescription = const PatientTag(
      'PatientSpeciesDescription',
      0x00102201,
      'Patient Species Description',
      kLOIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kPatientSpeciesCodeSequence = const PatientTag(
      'PatientSpeciesCodeSequence',
      0x00102202,
      'Patient Species Code Sequence',
      kSQIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kPatientSexNeutered = const PatientTag(
      'PatientSexNeutered',
      0x00102203,
      'Patient\'s Sex Neutered',
      kCSIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);

  static const PatientTag kAnatomicalOrientationType = const PatientTag(
      'AnatomicalOrientationType',
      0x00102210,
      'Anatomical Orientation Type',
      kCSIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kPatientBreedDescription = const PatientTag(
      'PatientBreedDescription',
      0x00102292,
      'Patient Breed Description',
      kLOIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kPatientBreedCodeSequence = const PatientTag(
      'PatientBreedCodeSequence',
      0x00102293,
      'Patient Breed Code Sequence',
      kSQIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kBreedRegistrationSequence = const PatientTag(
      'BreedRegistrationSequence',
      0x00102294,
      'Breed Registration Sequence',
      kSQIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kBreedRegistrationNumber = const PatientTag(
      'BreedRegistrationNumber',
      0x00102295,
      'Breed Registration Number',
      kLOIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kBreedRegistryCodeSequence = const PatientTag(
      'BreedRegistryCodeSequence',
      0x00102296,
      'Breed Registry Code Sequence',
      kSQIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kResponsiblePerson = const PatientTag(
      'ResponsiblePerson',
      0x00102297,
      'Responsible Person',
      kPNIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kResponsiblePersonRole = const PatientTag(
      'ResponsiblePersonRole',
      0x00102298,
      'Responsible Person Role',
      kCSIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kResponsibleOrganization = const PatientTag(
      'ResponsibleOrganization',
      0x00102299,
      'Responsible Organization',
      kLOIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static const PatientTag kPatientComments = const PatientTag('PatientComments',
      0x00104000, 'Patient Comments', kLTIndex, VM.k1, EType.kUnknown,
      isRetired: false);
  static const PatientTag kExaminedBodyThickness = const PatientTag(
      'ExaminedBodyThickness',
      0x00109431,
      'Examined Body Thickness',
      kFLIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);

  //*** 0040
  static const PatientTag kLocalNamespaceEntityID = const PatientTag(
      'LocalNamespaceEntityID',
      0x00400031,
      'Local Namespace Entity ID',
      kUTIndex,
      VM.k1,
      EType.k1c,
      isRetired: false);

  static const PatientTag kUniversalEntityID = const PatientTag(
      'UniversalEntityID',
      0x00400032,
      'Universal Entity ID',
      kUTIndex,
      VM.k1,
      EType.k3,
      isRetired: false);

  static const PatientTag kUniversalEntityIDType = const PatientTag(
      'UniversalEntityIDType',
      0x00400033,
      'Universal Entity ID Type',
      kCSIndex,
      VM.k1,
      EType.k1c,
      isRetired: false);

  static const PatientTag kIdentifierTypeCode = const PatientTag(
      'IdentifierTypeCode',
      0x00400035,
      'Identifier Type Code',
      kCSIndex,
      VM.k1,
      EType.k3,
      isRetired: false);

  static const PatientTag kAssigningFacilitySequence = const PatientTag(
      'AssigningFacilitySequence',
      0x00400036,
      'Assigning Facility Sequence',
      kSQIndex,
      VM.k1,
      EType.k3,
      isRetired: false);

  static const PatientTag kAssigningJurisdictionCodeSequence = const PatientTag(
      'AssigningJurisdictionCodeSequence',
      0x00400039,
      'Assigning Jurisdiction Code Sequence',
      kSQIndex,
      VM.k1,
      EType.k3,
      isRetired: false);

  static const PatientTag kAssigningAgencyOrDepartmentCodeSequence =
      const PatientTag(
          'AssigningAgencyOrDepartmentCodeSequence',
          0x0040003A,
          'Assigning Agency or Department Code Sequence',
          kSQIndex,
          VM.k1,
          EType.k3,
          isRetired: false);
}
