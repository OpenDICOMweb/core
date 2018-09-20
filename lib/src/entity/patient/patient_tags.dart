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

   PatientTag(
      this.keyword, this.tag, this.name, this.vrIndex, this.vm, this.type,
      {this.isRetired = false});

  static  PatientTag kPatientName =  PatientTag('PatientName',
      0x00100010, 'Patient\'s Name', kPNIndex, VM.k1, EType.kUnknown,
      isRetired: false);

  static  PatientTag kPatientID =  PatientTag(
      'PatientID', 0x00100020, 'Patient ID', kLOIndex, VM.k1, EType.kUnknown,
      isRetired: false);

  static  PatientTag kIssuerOfPatientID =  PatientTag(
      'IssuerOfPatientID',
      0x00100021,
      'Issuer of Patient ID',
      kLOIndex,
      VM.k1,
      EType.k3,
      isRetired: false);

  static  PatientTag kTypeOfPatientID =  PatientTag('TypeOfPatientID',
      0x00100022, 'Type of Patient ID', kCSIndex, VM.k1, EType.kUnknown,
      isRetired: false);

  static  PatientTag kIssuerOfPatientIDQualifiersSequence =
       PatientTag('IssuerOfPatientIDQualifiersSequence', 0x00100024,
          'Issuer of Patient ID Qualifiers Sequence', kSQIndex, VM.k1, EType.k3,
          isRetired: false);

  static  PatientTag kPatientBirthDate =  PatientTag(
      'PatientBirthDate',
      0x00100030,
      'Patient\'s Birth Date',
      kDAIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);

  static  PatientTag kPatientBirthTime =  PatientTag(
      'PatientBirthTime',
      0x00100032,
      'Patient\'s Birth Time',
      kTMIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);

  static  PatientTag kPatientSex =  PatientTag('PatientSex',
      0x00100040, 'Patient\'s Sex', kCSIndex, VM.k1, EType.kUnknown,
      isRetired: false);

  static  PatientTag kPatientInsurancePlanCodeSequence =  PatientTag(
      'PatientInsurancePlanCodeSequence',
      0x00100050,
      'Patient\'s Insurance Plan Code Sequence',
      kSQIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kPatientPrimaryLanguageCodeSequence =
       PatientTag(
          'PatientPrimaryLanguageCodeSequence',
          0x00100101,
          'Patient\'s Primary Language Code Sequence',
          kSQIndex,
          VM.k1,
          EType.kUnknown,
          isRetired: false);
  static  PatientTag kPatientPrimaryLanguageModifierCodeSequence =
       PatientTag(
          'PatientPrimaryLanguageModifierCodeSequence',
          0x00100102,
          'Patient\'s Primary Language Modifier Code Sequence',
          kSQIndex,
          VM.k1,
          EType.kUnknown,
          isRetired: false);
  static  PatientTag kQualityControlPatient =  PatientTag(
      'QualityControlPatient',
      0x00100200,
      'Quality Control Patient',
      kCSIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kQualityControlPatientTypeCodeSequence =
       PatientTag(
          'QualityControlPatientTypeCodeSequence',
          0x00100201,
          'Quality Control Patient Type Code Sequence',
          kSQIndex,
          VM.k1,
          EType.kUnknown,
          isRetired: false);
  static  PatientTag kOtherPatientIDs =  PatientTag('OtherPatientIDs',
      0x00101000, 'Other Patient IDs', kLOIndex, VM.k1_n, EType.kUnknown,
      isRetired: false);
  static  PatientTag kOtherPatientNames =  PatientTag(
      'OtherPatientNames',
      0x00101001,
      'Other Patient Names',
      kPNIndex,
      VM.k1_n,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kOtherPatientIDsSequence =  PatientTag(
      'OtherPatientIDsSequence',
      0x00101002,
      'Other Patient IDs Sequence',
      kSQIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kPatientBirthName =  PatientTag(
      'PatientBirthName',
      0x00101005,
      'Patient\'s Birth Name',
      kPNIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kPatientAge =  PatientTag('PatientAge',
      0x00101010, 'Patient\'s Age', kASIndex, VM.k1, EType.kUnknown,
      isRetired: false);
  static  PatientTag kPatientSize =  PatientTag('PatientSize',
      0x00101020, 'Patient\'s Size', kDSIndex, VM.k1, EType.kUnknown,
      isRetired: false);
  static  PatientTag kPatientSizeCodeSequence =  PatientTag(
      'PatientSizeCodeSequence',
      0x00101021,
      'Patient\'s Size Code Sequence',
      kSQIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kPatientWeight =  PatientTag('PatientWeight',
      0x00101030, 'Patient\'s Weight', kDSIndex, VM.k1, EType.kUnknown,
      isRetired: false);
  static  PatientTag kPatientAddress =  PatientTag('PatientAddress',
      0x00101040, 'Patient\'s Address', kLOIndex, VM.k1, EType.kUnknown,
      isRetired: false);
  static  PatientTag kInsurancePlanIdentification =  PatientTag(
      'InsurancePlanIdentification',
      0x00101050,
      'Insurance Plan Identification',
      kLOIndex,
      VM.k1_n,
      EType.kUnknown,
      isRetired: true);
  static  PatientTag kPatientMotherBirthName =  PatientTag(
      'PatientMotherBirthName',
      0x00101060,
      'Patient\'s Mother\'s Birth Name',
      kPNIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kMilitaryRank =  PatientTag('MilitaryRank',
      0x00101080, 'Military Rank', kLOIndex, VM.k1, EType.kUnknown,
      isRetired: false);
  static  PatientTag kBranchOfService =  PatientTag('BranchOfService',
      0x00101081, 'Branch of Service', kLOIndex, VM.k1, EType.kUnknown,
      isRetired: false);
  static  PatientTag kMedicalRecordLocator =  PatientTag(
      'MedicalRecordLocator',
      0x00101090,
      'Medical Record Locator',
      kLOIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kReferencedPatientPhotoSequence =  PatientTag(

      // (0010,1100)
      'ReferencedPatientPhotoSequence',
      0x00101100,
      'Referenced Patient Photo Sequence',
      kSQIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kMedicalAlerts =  PatientTag('MedicalAlerts',
      0x00102000, 'Medical Alerts', kLOIndex, VM.k1_n, EType.kUnknown,
      isRetired: false);
  static  PatientTag kAllergies =  PatientTag(
      'Allergies', 0x00102110, 'Allergies', kLOIndex, VM.k1_n, EType.kUnknown,
      isRetired: false);
  static  PatientTag kCountryOfResidence =  PatientTag(
      'CountryOfResidence',
      0x00102150,
      'Country of Residence',
      kLOIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kRegionOfResidence =  PatientTag(
      'RegionOfResidence',
      0x00102152,
      'Region of Residence',
      kLOIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kPatientTelephoneNumbers =  PatientTag(
      'PatientTelephoneNumbers',
      0x00102154,
      'Patient\'s Telephone Numbers',
      kSHIndex,
      VM.k1_n,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kEthnicGroup =  PatientTag('EthnicGroup',
      0x00102160, 'Ethnic Group', kSHIndex, VM.k1, EType.kUnknown,
      isRetired: false);
  static  PatientTag kOccupation =  PatientTag(
      'Occupation', 0x00102180, 'Occupation', kSHIndex, VM.k1, EType.kUnknown,
      isRetired: false);
  static  PatientTag kSmokingStatus =  PatientTag('SmokingStatus',
      0x001021A0, 'Smoking Status', kCSIndex, VM.k1, EType.kUnknown,
      isRetired: false);
  static  PatientTag kAdditionalPatientHistory =  PatientTag(
      'AdditionalPatientHistory',
      0x001021B0,
      'Additional Patient History',
      kLTIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kPregnancyStatus =  PatientTag('PregnancyStatus',
      0x001021C0, 'Pregnancy Status', kUSIndex, VM.k1, EType.kUnknown,
      isRetired: false);
  static  PatientTag kLastMenstrualDate =  PatientTag(
      'LastMenstrualDate',
      0x001021D0,
      'Last Menstrual Date',
      kDAIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kPatientReligiousPreference =  PatientTag(
      'PatientReligiousPreference',
      0x001021F0,
      'Patient\'s Religious Preference',
      kLOIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kPatientSpeciesDescription =  PatientTag(
      'PatientSpeciesDescription',
      0x00102201,
      'Patient Species Description',
      kLOIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kPatientSpeciesCodeSequence =  PatientTag(
      'PatientSpeciesCodeSequence',
      0x00102202,
      'Patient Species Code Sequence',
      kSQIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kPatientSexNeutered =  PatientTag(
      'PatientSexNeutered',
      0x00102203,
      'Patient\'s Sex Neutered',
      kCSIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);

  static  PatientTag kAnatomicalOrientationType =  PatientTag(
      'AnatomicalOrientationType',
      0x00102210,
      'Anatomical Orientation Type',
      kCSIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kPatientBreedDescription =  PatientTag(
      'PatientBreedDescription',
      0x00102292,
      'Patient Breed Description',
      kLOIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kPatientBreedCodeSequence =  PatientTag(
      'PatientBreedCodeSequence',
      0x00102293,
      'Patient Breed Code Sequence',
      kSQIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kBreedRegistrationSequence =  PatientTag(
      'BreedRegistrationSequence',
      0x00102294,
      'Breed Registration Sequence',
      kSQIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kBreedRegistrationNumber =  PatientTag(
      'BreedRegistrationNumber',
      0x00102295,
      'Breed Registration Number',
      kLOIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kBreedRegistryCodeSequence =  PatientTag(
      'BreedRegistryCodeSequence',
      0x00102296,
      'Breed Registry Code Sequence',
      kSQIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kResponsiblePerson =  PatientTag(
      'ResponsiblePerson',
      0x00102297,
      'Responsible Person',
      kPNIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kResponsiblePersonRole =  PatientTag(
      'ResponsiblePersonRole',
      0x00102298,
      'Responsible Person Role',
      kCSIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kResponsibleOrganization =  PatientTag(
      'ResponsibleOrganization',
      0x00102299,
      'Responsible Organization',
      kLOIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);
  static  PatientTag kPatientComments =  PatientTag('PatientComments',
      0x00104000, 'Patient Comments', kLTIndex, VM.k1, EType.kUnknown,
      isRetired: false);
  static  PatientTag kExaminedBodyThickness =  PatientTag(
      'ExaminedBodyThickness',
      0x00109431,
      'Examined Body Thickness',
      kFLIndex,
      VM.k1,
      EType.kUnknown,
      isRetired: false);

  //*** 0040
  static  PatientTag kLocalNamespaceEntityID =  PatientTag(
      'LocalNamespaceEntityID',
      0x00400031,
      'Local Namespace Entity ID',
      kUTIndex,
      VM.k1,
      EType.k1c,
      isRetired: false);

  static  PatientTag kUniversalEntityID =  PatientTag(
      'UniversalEntityID',
      0x00400032,
      'Universal Entity ID',
      kUTIndex,
      VM.k1,
      EType.k3,
      isRetired: false);

  static  PatientTag kUniversalEntityIDType =  PatientTag(
      'UniversalEntityIDType',
      0x00400033,
      'Universal Entity ID Type',
      kCSIndex,
      VM.k1,
      EType.k1c,
      isRetired: false);

  static  PatientTag kIdentifierTypeCode =  PatientTag(
      'IdentifierTypeCode',
      0x00400035,
      'Identifier Type Code',
      kCSIndex,
      VM.k1,
      EType.k3,
      isRetired: false);

  static  PatientTag kAssigningFacilitySequence =  PatientTag(
      'AssigningFacilitySequence',
      0x00400036,
      'Assigning Facility Sequence',
      kSQIndex,
      VM.k1,
      EType.k3,
      isRetired: false);

  static  PatientTag kAssigningJurisdictionCodeSequence =  PatientTag(
      'AssigningJurisdictionCodeSequence',
      0x00400039,
      'Assigning Jurisdiction Code Sequence',
      kSQIndex,
      VM.k1,
      EType.k3,
      isRetired: false);

  static  PatientTag kAssigningAgencyOrDepartmentCodeSequence =
       PatientTag(
          'AssigningAgencyOrDepartmentCodeSequence',
          0x0040003A,
          'Assigning Agency or Department Code Sequence',
          kSQIndex,
          VM.k1,
          EType.k3,
          isRetired: false);
}
