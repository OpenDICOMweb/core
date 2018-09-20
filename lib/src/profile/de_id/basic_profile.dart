//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset.dart';
import 'package:core/src/element.dart';
import 'package:core/src/error.dart';
import 'package:core/src/profile/de_id/basic_profile_options.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/values/uid.dart';

// ignore_for_file: public_member_api_docs

/// Basic De-Identification Profile.
class BasicProfile {
  final Tag tag;
  final String name;
  final Function action;

  const BasicProfile(this.tag, this.name, this.action);

  static final List<BasicProfileOptions> options = <BasicProfileOptions>[
    BasicProfileOptions.kCleanDescriptors,
    BasicProfileOptions.kCleanGraphics,
    BasicProfileOptions.kCleanPixelData,
    //FIX
    //BasicProfileOptions.kCleanRecognizableVisualFeatures,
    BasicProfileOptions.kCleanStructuredContent,
    BasicProfileOptions.kRetainDeviceIdentity,
    BasicProfileOptions.kRetainFullDates,
    BasicProfileOptions.kRetainModifiedDates,
    BasicProfileOptions.kRetainPatientCharacteristics,
    BasicProfileOptions.kRetainSafePrivate,
    BasicProfileOptions.kRetainUids
  ];

  @override
  String toString() => 'Basic Profile: $tag';

  static bool _isEmpty(Iterable values, bool emptyAllowed) =>
      values == const <Object>[] || emptyAllowed;

  //FLush or Fix
  //TODO: deidentifySequence has to be at a higher level
  /// Keep (unchanged for non-sequence attributes, cleaned for sequences)';
  // static void retain(Dataset ds, Tag tag) => ds.retain(tag);

/* FLush or Fix
  //TODO: deidentifySequence has to be at a higher level
  /// retain (unchanged for non-sequence attributes, cleaned for sequences)';
  static void retainBlank(Dataset ds, Tag tag) => ds.retain(tag);
*/

  // D, Z, X, K, C

  /// D: Replace with Dummy values, i.e. values that contain no PHI, but
  /// are consistent with VR.
  static Element replaceWithDummy<V>(Dataset ds, Tag tag, List<V> values,
          {bool required = false}) =>
      ds.update<V>(tag.code, values, required: required);

  /// D: Replace with Dummy values, i.e. values that contain no PHI, but
  /// are consistent with VR.
  static Element replaceWithZero(Dataset ds, Tag tag,
          {bool required = false}) =>
      ds.noValues(tag.code);

  /// X: Remove the [Element] with [tag].h
  static List<Element> remove(Dataset ds, Tag tag, {bool required = false}) =>
      ds.deleteAll(tag.code);

/* FLush or Fix
  /// K: Retain the [Element] with this Tag.
  static void keep(Dataset ds, Tag tag, {bool required = false} =>
      ds.retain(tag);
*/

  /// C: Clean, that is replace with values of similar meaning known
  /// not to contain identifying information and consistent with the VR.
  static bool clean<V>(Dataset ds, Tag tag, Iterable<V> values,
          {bool required = false}) =>
      ds.replace<V>(tag.code, values) != null;

  /// U: Replace with a non-zero length UID that is internally consistent
  /// within a set of Instances in the Study or Series;
  static Iterable<Uid> replaceUids(Dataset ds, Tag tag, Iterable<Uid> values,
          {bool required = false}) =>
      ds.replaceUids(tag.code, values);

  /// ZD: Z unless D is required to maintain
  /// IOD conformance (Type 2 versus Type 1)';
  static Element zeroUnlessDummy<V>(Dataset ds, Tag tag, List<V> values,
      {bool required = false}) {
    if (_isEmpty(values, true))
      return ds.noValues(tag.code, required: required);
    return ds.update<V>(tag.code, values);
  }

  /// XZ: X unless Z is required to maintain IOD conformance
  /// (Type 3 versus Type 2)';
  static Element removeUnlessZero<V>(Dataset ds, Tag tag, List<V> values,
      {bool required = false}) {
    if (_isEmpty(values, true)) return ds.noValues(tag.code);
    return ds.update<V>(tag.code, values);
  }

  /// XD: X unless D is required to maintain IOD conformance
  /// (Type 3 versus Type 1)';
  static Element removeUnlessDummy<V>(Dataset ds, Tag tag, Iterable<V> values,
      {bool required = false}) {
    if (_isEmpty(values, true)) return ds.delete(tag.code, required: required);
    return ds.update<V>(tag.code, values);
  }

  /// X unless Z or D is required to maintain IOD conformance
  /// (Type 3 versus Type 2 versus Type 1)';
  static Element removeUnlessZeroOrDummy<V>(Dataset ds, Tag tag,
      [Iterable<V> values]) {
    if (_isEmpty(values, true)) return ds.noValues(tag.code);
    return ds.lookup(tag.code).update(values);
  }

  /// XZU: X unless Z or replacement of contained instance UIDs (U) is
  /// required to maintain IOD conformance
  /// (Type 3 versus Type 2 versus Type 1 sequences containing UID references)';
  static Element removeUidUnlessZeroOrDummy<V>(
      Dataset ds, Tag tag, List<V> values,
      {bool required = false}) {
    if (ds.lookup(tag.code) is! SQ) badTag(tag, null, SQ);
    if (_isEmpty(values, true)) return ds.noValues(tag.code);
    return ds.update<V>(tag.code, values);
  }

  static Element addIfMissing<V>(Dataset ds, Tag tag, List<V> values,
      {bool required = false}) {
    final e = ds.lookup(tag.code);
    if (e is! SQ) badTag(tag, null, SQ);
    if (_isEmpty(values, true))
      return ds.noValues(tag.code, required: required);
    return ds.update<V>(tag.code, values);
  }

  static Element invalid<V>(Dataset ds, Tag tag, List<V> values,
          {bool required = false}) =>
      throw UnsupportedError('Invalid Action');

  static BasicProfile lookup(int tag) => map[tag];

  static const BasicProfile kAffectedSOPInstanceUID =
      BasicProfile(PTag.kAffectedSOPInstanceUID, 'X', remove);
  static const BasicProfile kRequestedSOPInstanceUID =
      BasicProfile(PTag.kRequestedSOPInstanceUID, 'U', replaceUids);
  static const BasicProfile kMediaStorageSOPInstanceUID =
      BasicProfile(PTag.kMediaStorageSOPInstanceUID, 'U', replaceUids);
  static const BasicProfile kReferencedSOPInstanceUIDinFile =
      BasicProfile(PTag.kReferencedSOPInstanceUIDInFile, 'U', replaceUids);
  static const BasicProfile kInstanceCreatorUID =
      BasicProfile(PTag.kInstanceCreatorUID, 'U', replaceUids);
  static const BasicProfile kSOPInstanceUID =
      BasicProfile(PTag.kSOPInstanceUID, 'U', replaceUids);
  static const BasicProfile kStudyDate =
      BasicProfile(PTag.kStudyDate, 'Z', replaceWithZero);
  static const BasicProfile kSeriesDate =
      BasicProfile(PTag.kSeriesDate, 'XD', removeUnlessDummy);
  static const BasicProfile kAcquisitionDate =
      BasicProfile(PTag.kAcquisitionDate, 'XD', removeUnlessZero);
  static const BasicProfile kContentDate =
      BasicProfile(PTag.kContentDate, 'XD', removeUnlessDummy);
  static const BasicProfile kOverlayDate =
      BasicProfile(PTag.kOverlayDate, 'X', remove);
  static const BasicProfile kCurveDate =
      BasicProfile(PTag.kCurveDate, 'X', remove);
  static const BasicProfile kAcquisitionDateTime =
      BasicProfile(PTag.kAcquisitionDateTime, 'XD', removeUnlessDummy);
  static const BasicProfile kStudyTime =
      BasicProfile(PTag.kStudyTime, 'Z', replaceWithZero);
  static const BasicProfile kSeriesTime =
      BasicProfile(PTag.kSeriesTime, 'XD', removeUnlessDummy);
  static const BasicProfile kAcquisitionTime =
      BasicProfile(PTag.kAcquisitionTime, 'XD', removeUnlessZero);
  static const BasicProfile kContentTime =
      BasicProfile(PTag.kContentTime, 'XD', removeUnlessDummy);
  static const BasicProfile kOverlayTime =
      BasicProfile(PTag.kOverlayTime, 'X', remove);
  static const BasicProfile kCurveTime =
      BasicProfile(PTag.kCurveTime, 'X', remove);
  static const BasicProfile kAccessionNumber =
      BasicProfile(PTag.kAccessionNumber, 'Z', replaceWithZero);
  static const BasicProfile kFailedSOPInstanceUIDList =
      BasicProfile(PTag.kFailedSOPInstanceUIDList, 'U', replaceUids);
  static const BasicProfile kInstitutionName =
      BasicProfile(PTag.kInstitutionName, 'XZD', removeUnlessZeroOrDummy);
  static const BasicProfile kInstitutionAddress =
      BasicProfile(PTag.kInstitutionAddress, 'X', remove);
  static const BasicProfile kInstitutionCodeSequence = BasicProfile(
      PTag.kInstitutionCodeSequence, 'XZD', removeUnlessZeroOrDummy);
  static const BasicProfile kReferringPhysiciansName =
      BasicProfile(PTag.kReferringPhysicianName, 'Z', replaceWithZero);
  static const BasicProfile kReferringPhysiciansAddress =
      BasicProfile(PTag.kReferringPhysicianAddress, 'X', remove);
  static const BasicProfile kReferringPhysiciansTelephoneNumbers =
      BasicProfile(PTag.kReferringPhysicianTelephoneNumbers, 'X', remove);
  static const BasicProfile kReferringPhysiciansIdentificationSequence =
      BasicProfile(PTag.kReferringPhysicianIdentificationSequence, 'X', remove);
  static const BasicProfile kContextGroupExtensionCreatorUID =
      BasicProfile(PTag.kContextGroupExtensionCreatorUID, 'U', replaceUids);
  static const BasicProfile kTimezoneOffsetFromUTC =
      BasicProfile(PTag.kTimezoneOffsetFromUTC, 'X', remove);
  static const BasicProfile kStationName =
      BasicProfile(PTag.kStationName, 'XZD', removeUnlessZeroOrDummy);
  static const BasicProfile kStudyDescription =
      BasicProfile(PTag.kStudyDescription, 'X', remove);
  static const BasicProfile kSeriesDescription =
      BasicProfile(PTag.kSeriesDescription, 'X', remove);
  static const BasicProfile kInstitutionalDepartmentName =
      BasicProfile(PTag.kInstitutionalDepartmentName, 'X', remove);
  static const BasicProfile kPhysicianOfRecord =
      BasicProfile(PTag.kPhysiciansOfRecord, 'X', remove);
  static const BasicProfile kPhysician0xsofRecordIdentificationSequence =
      BasicProfile(PTag.kPhysiciansOfRecordIdentificationSequence, 'X', remove);
  static const BasicProfile kPerformingPhysiciansName =
      BasicProfile(PTag.kPerformingPhysicianName, 'X', remove);
  static const BasicProfile kPerformingPhysicianIdentificationSequence =
      BasicProfile(
          PTag.kPerformingPhysicianIdentificationSequence, 'X', remove);
  static const BasicProfile kNameofPhysician0xsReadingStudy =
      BasicProfile(PTag.kNameOfPhysiciansReadingStudy, 'X', remove);
  static const BasicProfile kPhysician0xsReadingStudyIdentificationSequence =
      BasicProfile(
          PTag.kPhysiciansReadingStudyIdentificationSequence, 'X', remove);
  static const BasicProfile kOperatorsName =
      BasicProfile(PTag.kOperatorsName, 'XZD', removeUnlessZeroOrDummy);
  static const BasicProfile kOperatorsIdentificationSequence = BasicProfile(
      PTag.kOperatorIdentificationSequence, 'XD', removeUnlessDummy);
  static const BasicProfile kAdmittingDiagnosesDescription =
      BasicProfile(PTag.kAdmittingDiagnosesDescription, 'X', remove);
  static const BasicProfile kAdmittingDiagnosesCodeSequence =
      BasicProfile(PTag.kAdmittingDiagnosesCodeSequence, 'X', remove);
  static const BasicProfile kReferencedStudySequence =
      BasicProfile(PTag.kReferencedStudySequence, 'XD', removeUnlessZero);
  static const BasicProfile kReferencedPerformedProcedureStepSequence =
      BasicProfile(PTag.kReferencedPerformedProcedureStepSequence, 'XZD',
          removeUnlessZeroOrDummy);
  static const BasicProfile kReferencedPatientSequence =
      BasicProfile(PTag.kReferencedPatientSequence, 'X', remove);
  static const BasicProfile kReferencedImageSequence = BasicProfile(
      PTag.kReferencedImageSequence, 'XZU', removeUidUnlessZeroOrDummy);
  static const BasicProfile kReferencedSOPInstanceUID =
      BasicProfile(PTag.kReferencedSOPInstanceUID, 'U', replaceUids);
  static const BasicProfile kTransactionUID =
      BasicProfile(PTag.kTransactionUID, 'U', replaceUids);
  static const BasicProfile kDerivationDescription =
      BasicProfile(PTag.kDerivationDescription, 'X', remove);
  static const BasicProfile kSourceImageSequence = BasicProfile(
      PTag.kSourceImageSequence, 'XZU', removeUidUnlessZeroOrDummy);
  static const BasicProfile kIrradiationEventUID =
      BasicProfile(PTag.kIrradiationEventUID, 'U', replaceUids);
  static const BasicProfile kIdentifyingComments =
      BasicProfile(PTag.kIdentifyingComments, 'X', remove);
  static const BasicProfile kCreatorVersionUID =
      BasicProfile(PTag.kCreatorVersionUID, 'U', replaceUids);
  static const BasicProfile kPatientsName =
      BasicProfile(PTag.kPatientName, 'Z', replaceWithZero);
  static const BasicProfile kPatientID =
      BasicProfile(PTag.kPatientID, 'Z', replaceWithZero);
  static const BasicProfile kIssuerofPatientID =
      BasicProfile(PTag.kIssuerOfPatientID, 'X', remove);
  static const BasicProfile kPatientsBirthDate =
      BasicProfile(PTag.kPatientBirthDate, 'Z', replaceWithZero);
  static const BasicProfile kPatientsBirthTime =
      BasicProfile(PTag.kPatientBirthTime, 'X', remove);
  static const BasicProfile kPatientsSex =
      BasicProfile(PTag.kPatientSex, 'Z', replaceWithZero);
  static const BasicProfile kPatientsInsurancePlanCodeSequence =
      BasicProfile(PTag.kPatientInsurancePlanCodeSequence, 'X', remove);
  static const BasicProfile kPatientsPrimaryLanguageCodeSequence =
      BasicProfile(PTag.kPatientPrimaryLanguageCodeSequence, 'X', remove);
  static const BasicProfile kPatientsPrimaryLanguageModifierCodeSequence =
      BasicProfile(
          PTag.kPatientPrimaryLanguageModifierCodeSequence, 'X', remove);
  static const BasicProfile kOtherPatientIDs =
      BasicProfile(PTag.kOtherPatientIDs, 'X', remove);
  static const BasicProfile kOtherPatientNames =
      BasicProfile(PTag.kOtherPatientNames, 'X', remove);
  static const BasicProfile kOtherPatientIDsSequence =
      BasicProfile(PTag.kOtherPatientIDsSequence, 'X', remove);
  static const BasicProfile kPatientsBirthName =
      BasicProfile(PTag.kPatientBirthName, 'X', remove);
  static const BasicProfile kPatientAge =
      BasicProfile(PTag.kPatientAge, 'X', remove);
  static const BasicProfile kPatientSize =
      BasicProfile(PTag.kPatientSize, 'X', remove);
  static const BasicProfile kPatientWeight =
      BasicProfile(PTag.kPatientWeight, 'X', remove);
  static const BasicProfile kPatientAddress =
      BasicProfile(PTag.kPatientAddress, 'X', remove);
  static const BasicProfile kInsurancePlanIdentification =
      BasicProfile(PTag.kInsurancePlanIdentification, 'X', remove);
  static const BasicProfile kPatientMotherBirthName =
      BasicProfile(PTag.kPatientMotherBirthName, 'X', remove);
  static const BasicProfile kMilitaryRank =
      BasicProfile(PTag.kMilitaryRank, 'X', remove);
  static const BasicProfile kBranchOfService =
      BasicProfile(PTag.kBranchOfService, 'X', remove);
  static const BasicProfile kMedicalRecordLocator =
      BasicProfile(PTag.kMedicalRecordLocator, 'X', remove);
  static const BasicProfile kMedicalAlerts =
      BasicProfile(PTag.kMedicalAlerts, 'X', remove);
  static const BasicProfile kAllergies =
      BasicProfile(PTag.kAllergies, 'X', remove);
  static const BasicProfile kCountryOfResidence =
      BasicProfile(PTag.kCountryOfResidence, 'X', remove);
  static const BasicProfile kRegionOfResidence =
      BasicProfile(PTag.kRegionOfResidence, 'X', remove);
  static const BasicProfile kPatientTelephoneNumbers =
      BasicProfile(PTag.kPatientTelephoneNumbers, 'X', remove);
  static const BasicProfile kEthnicGroup =
      BasicProfile(PTag.kEthnicGroup, 'X', remove);
  static const BasicProfile kOccupation =
      BasicProfile(PTag.kOccupation, 'X', remove);
  static const BasicProfile kSmokingStatus =
      BasicProfile(PTag.kSmokingStatus, 'X', remove);
  static const BasicProfile kAdditionalPatientHistory =
      BasicProfile(PTag.kAdditionalPatientHistory, 'X', remove);
  static const BasicProfile kPregnancyStatus =
      BasicProfile(PTag.kPregnancyStatus, 'X', remove);
  static const BasicProfile kLastMenstrualDate =
      BasicProfile(PTag.kLastMenstrualDate, 'X', remove);
  static const BasicProfile kPatientReligiousPreference =
      BasicProfile(PTag.kPatientReligiousPreference, 'X', remove);
  static const BasicProfile kPatientSexNeutered =
      BasicProfile(PTag.kPatientSexNeutered, 'XD', removeUnlessZero);
  static const BasicProfile kResponsiblePerson =
      BasicProfile(PTag.kResponsiblePerson, 'X', remove);
  static const BasicProfile kResponsibleOrganization =
      BasicProfile(PTag.kResponsibleOrganization, 'X', remove);
  static const BasicProfile kPatientComments =
      BasicProfile(PTag.kPatientComments, 'X', remove);
  static const BasicProfile kContrastBolusAgent =
      BasicProfile(PTag.kContrastBolusAgent, 'XD', removeUnlessDummy);
  static const BasicProfile kDeviceSerialNumber =
      BasicProfile(PTag.kDeviceSerialNumber, 'XZD', removeUnlessZeroOrDummy);
  static const BasicProfile kDeviceUID =
      BasicProfile(PTag.kDeviceUID, 'U', replaceUids);
  static const BasicProfile kPlateID = BasicProfile(PTag.kPlateID, 'X', remove);
  static const BasicProfile kGeneratorID =
      BasicProfile(PTag.kGeneratorID, 'X', remove);
  static const BasicProfile kCassetteID =
      BasicProfile(PTag.kCassetteID, 'X', remove);
  static const BasicProfile kGantryID =
      BasicProfile(PTag.kGantryID, 'X', remove);
  static const BasicProfile kProtocolName =
      BasicProfile(PTag.kProtocolName, 'XD', removeUnlessDummy);
  static const BasicProfile kAcquisitionDeviceProcessingDescription =
      BasicProfile(PTag.kAcquisitionDeviceProcessingDescription, 'XD',
          removeUnlessDummy);
  static const BasicProfile kAcquisitionComments =
      BasicProfile(PTag.kAcquisitionComments, 'X', remove);
  static const BasicProfile kDetectorID =
      BasicProfile(PTag.kDetectorID, 'XD', removeUnlessDummy);
  static const BasicProfile kAcquisitionProtocolDescription =
      BasicProfile(PTag.kAcquisitionProtocolDescription, 'X', remove);
  static const BasicProfile kContributionDescription =
      BasicProfile(PTag.kContributionDescription, 'X', remove);
  static const BasicProfile kStudyInstanceUID =
      BasicProfile(PTag.kStudyInstanceUID, 'U', replaceUids);
  static const BasicProfile kSeriesInstanceUID =
      BasicProfile(PTag.kSeriesInstanceUID, 'U', replaceUids);
  static const BasicProfile kStudyID =
      BasicProfile(PTag.kStudyID, 'Z', replaceWithZero);
  static const BasicProfile kFrameOfReferenceUID =
      BasicProfile(PTag.kFrameOfReferenceUID, 'U', replaceUids);
  static const BasicProfile kSynchronizationFrameOfReferenceUID =
      BasicProfile(PTag.kSynchronizationFrameOfReferenceUID, 'U', replaceUids);
  static const BasicProfile kModifyingDeviceID =
      BasicProfile(PTag.kModifyingDeviceID, 'X', remove);
  static const BasicProfile kModifyingDeviceManufacturer =
      BasicProfile(PTag.kModifyingDeviceManufacturer, 'X', remove);
  static const BasicProfile kModifiedImageDescription =
      BasicProfile(PTag.kModifiedImageDescription, 'X', remove);
  static const BasicProfile kImageComments =
      BasicProfile(PTag.kImageComments, 'X', remove);
  static const BasicProfile kFrameComments =
      BasicProfile(PTag.kFrameComments, 'X', remove);
  static const BasicProfile kConcatenationUID =
      BasicProfile(PTag.kConcatenationUID, 'U', replaceUids);
  static const BasicProfile kDimensionOrganizationUID =
      BasicProfile(PTag.kDimensionOrganizationUID, 'U', replaceUids);
  static const BasicProfile kPaletteColorLookupTableUID =
      BasicProfile(PTag.kPaletteColorLookupTableUID, 'U', replaceUids);
  static const BasicProfile kLargePaletteColorLookupTableUID =
      BasicProfile(PTag.kLargePaletteColorLookupTableUID, 'U', replaceUids);
  static const BasicProfile kImagePresentationComments =
      BasicProfile(PTag.kImagePresentationComments, 'X', remove);
  static const BasicProfile kStudyIDIssuer =
      BasicProfile(PTag.kStudyIDIssuer, 'X', remove);
  static const BasicProfile kScheduledStudyLocation =
      BasicProfile(PTag.kScheduledStudyLocation, 'X', remove);
  static const BasicProfile kScheduledStudyLocationAETitle =
      BasicProfile(PTag.kScheduledStudyLocationAETitle, 'X', remove);
  static const BasicProfile kReasonForStudy =
      BasicProfile(PTag.kReasonForStudy, 'X', remove);
  static const BasicProfile kRequestingPhysician =
      BasicProfile(PTag.kRequestingPhysician, 'X', remove);
  static const BasicProfile kRequestingService =
      BasicProfile(PTag.kRequestingService, 'X', remove);
  static const BasicProfile kRequestedProcedureDescription =
      BasicProfile(PTag.kRequestedProcedureDescription, 'XD', removeUnlessZero);
  static const BasicProfile kRequestedContrastAgent =
      BasicProfile(PTag.kRequestedContrastAgent, 'X', remove);
  static const BasicProfile kStudyComments =
      BasicProfile(PTag.kStudyComments, 'X', remove);
  static const BasicProfile kReferencedPatientAliasSequence =
      BasicProfile(PTag.kReferencedPatientAliasSequence, 'X', remove);
  static const BasicProfile kAdmissionID =
      BasicProfile(PTag.kAdmissionID, 'X', remove);
  static const BasicProfile kIssuerOfAdmissionID =
      BasicProfile(PTag.kIssuerOfAdmissionID, 'X', remove);
  static const BasicProfile kScheduledPatientInstitutionResidence =
      BasicProfile(PTag.kScheduledPatientInstitutionResidence, 'X', remove);
  static const BasicProfile kAdmittingDate =
      BasicProfile(PTag.kAdmittingDate, 'X', remove);
  static const BasicProfile kAdmittingTime =
      BasicProfile(PTag.kAdmittingTime, 'X', remove);
  static const BasicProfile kDischargeDiagnosisDescription =
      BasicProfile(PTag.kDischargeDiagnosisDescription, 'X', remove);
  static const BasicProfile kSpecialNeeds =
      BasicProfile(PTag.kSpecialNeeds, 'X', remove);
  static const BasicProfile kServiceEpisodeID =
      BasicProfile(PTag.kServiceEpisodeID, 'X', remove);
  static const BasicProfile kIssuerOfServiceEpisodeID =
      BasicProfile(PTag.kIssuerOfServiceEpisodeID, 'X', remove);
  static const BasicProfile kServiceEpisodeDescription =
      BasicProfile(PTag.kServiceEpisodeDescription, 'X', remove);
  static const BasicProfile kCurrentPatientLocation =
      BasicProfile(PTag.kCurrentPatientLocation, 'X', remove);
  static const BasicProfile kPatientInstitutionResidence =
      BasicProfile(PTag.kPatientInstitutionResidence, 'X', remove);
  static const BasicProfile kPatientState =
      BasicProfile(PTag.kPatientState, 'X', remove);
  static const BasicProfile kVisitComments =
      BasicProfile(PTag.kVisitComments, 'X', remove);
  static const BasicProfile kScheduledStationAETitle =
      BasicProfile(PTag.kScheduledStationAETitle, 'X', remove);
  static const BasicProfile kScheduledProcedureStepStartDate =
      BasicProfile(PTag.kScheduledProcedureStepStartDate, 'X', remove);
  static const BasicProfile kScheduledProcedureStepStartTime =
      BasicProfile(PTag.kScheduledProcedureStepStartTime, 'X', remove);
  static const BasicProfile kScheduledProcedureStepEndDate =
      BasicProfile(PTag.kScheduledProcedureStepEndDate, 'X', remove);
  static const BasicProfile kScheduledProcedureStepEndTime =
      BasicProfile(PTag.kScheduledProcedureStepEndTime, 'X', remove);
  static const BasicProfile kScheduledPerformingPhysicianName =
      BasicProfile(PTag.kScheduledPerformingPhysicianName, 'X', remove);
  static const BasicProfile kScheduledProcedureStepDescription =
      BasicProfile(PTag.kScheduledProcedureStepDescription, 'X', remove);
  static const BasicProfile
      kScheduledPerformingPhysicianIdentificationSequence = BasicProfile(
          PTag.kScheduledPerformingPhysicianIdentificationSequence,
          'X',
          remove);
  static const BasicProfile kScheduledStationName =
      BasicProfile(PTag.kScheduledStationName, 'X', remove);
  static const BasicProfile kScheduledProcedureStepLocation =
      BasicProfile(PTag.kScheduledProcedureStepLocation, 'X', remove);
  static const BasicProfile kPreMedication =
      BasicProfile(PTag.kPreMedication, 'X', remove);
  static const BasicProfile kPerformedStationAETitle =
      BasicProfile(PTag.kPerformedStationAETitle, 'X', remove);
  static const BasicProfile kPerformedStationName =
      BasicProfile(PTag.kPerformedStationName, 'X', remove);
  static const BasicProfile kPerformedLocation =
      BasicProfile(PTag.kPerformedLocation, 'X', remove);
  static const BasicProfile kPerformedProcedureStepStartDate =
      BasicProfile(PTag.kPerformedProcedureStepStartDate, 'X', remove);
  static const BasicProfile kPerformedProcedureStepStartTime =
      BasicProfile(PTag.kPerformedProcedureStepStartTime, 'X', remove);
  static const BasicProfile kPerformedProcedureStepEndDate =
      BasicProfile(PTag.kPerformedProcedureStepEndDate, 'X', remove);
  static const BasicProfile kPerformedProcedureStepEndTime =
      BasicProfile(PTag.kPerformedProcedureStepEndTime, 'X', remove);
  static const BasicProfile kPerformedProcedureStepID =
      BasicProfile(PTag.kPerformedProcedureStepID, 'X', remove);
  static const BasicProfile kPerformedProcedureStepDescription =
      BasicProfile(PTag.kPerformedProcedureStepDescription, 'X', remove);
  static const BasicProfile kRequestAttributesSequence =
      BasicProfile(PTag.kRequestAttributesSequence, 'X', remove);
  static const BasicProfile kCommentsOnThePerformedProcedureStep =
      BasicProfile(PTag.kCommentsOnThePerformedProcedureStep, 'X', remove);
  static const BasicProfile kAcquisitionContextSequence =
      BasicProfile(PTag.kAcquisitionContextSequence, 'X', remove);
  static const BasicProfile kRequestedProcedureID =
      BasicProfile(PTag.kRequestedProcedureID, 'X', remove);
  static const BasicProfile kPatientTransportArrangements =
      BasicProfile(PTag.kPatientTransportArrangements, 'X', remove);
  static const BasicProfile kRequestedProcedureLocation =
      BasicProfile(PTag.kRequestedProcedureLocation, 'X', remove);
  static const BasicProfile kNamesOfIntendedRecipientsOfResults =
      BasicProfile(PTag.kNamesOfIntendedRecipientsOfResults, 'X', remove);
  static const BasicProfile kIntendedRecipientsOfResultsIdentificationSequence =
      BasicProfile(
          PTag.kIntendedRecipientsOfResultsIdentificationSequence, 'X', remove);
  static const BasicProfile kPersonIdentificationCodeSequence = BasicProfile(
      PTag.kPersonIdentificationCodeSequence, 'D', replaceWithDummy);
  static const BasicProfile kPersonAddress =
      BasicProfile(PTag.kPersonAddress, 'X', remove);
  static const BasicProfile kPersonTelephoneNumbers =
      BasicProfile(PTag.kPersonTelephoneNumbers, 'X', remove);
  static const BasicProfile kRequestedProcedureComments =
      BasicProfile(PTag.kRequestedProcedureComments, 'X', remove);
  static const BasicProfile kReasonForTheImagingServiceRequest =
      BasicProfile(PTag.kReasonForTheImagingServiceRequest, 'X', remove);
  static const BasicProfile kOrderEnteredBy =
      BasicProfile(PTag.kOrderEnteredBy, 'X', remove);
  static const BasicProfile kOrderEntererLocation =
      BasicProfile(PTag.kOrderEntererLocation, 'X', remove);
  static const BasicProfile kOrderCallbackPhoneNumber =
      BasicProfile(PTag.kOrderCallbackPhoneNumber, 'X', remove);
  static const BasicProfile kPlacerOrderNumberImagingServiceRequest =
      BasicProfile(
          PTag.kPlacerOrderNumberImagingServiceRequest, 'Z', replaceWithZero);
  static const BasicProfile kFillerOrderNumberImagingServiceRequest =
      BasicProfile(
          PTag.kFillerOrderNumberImagingServiceRequest, 'Z', replaceWithZero);
  static const BasicProfile kImagingServiceRequestComments =
      BasicProfile(PTag.kImagingServiceRequestComments, 'X', remove);
  static const BasicProfile kConfidentialityConstraintonPatientDataDescription =
      BasicProfile(
          PTag.kConfidentialityConstraintOnPatientDataDescription, 'X', remove);
  static const BasicProfile
      kReferencedGeneralPurposeScheduledProcedureStepTransactionUID =
      BasicProfile(
          PTag.kReferencedGeneralPurposeScheduledProcedureStepTransactionUID,
          'U',
          replaceUids);
  static const BasicProfile kScheduledStationNameCodeSequence =
      BasicProfile(PTag.kScheduledStationNameCodeSequence, 'X', remove);
  static const BasicProfile kScheduledStationGeographicLocationCodeSequence =
      BasicProfile(
          PTag.kScheduledStationGeographicLocationCodeSequence, 'X', remove);
  static const BasicProfile kPerformedStationNameCodeSequence =
      BasicProfile(PTag.kPerformedStationNameCodeSequence, 'X', remove);
  static const BasicProfile kPerformedStationGeographicLocationCodeSequence =
      BasicProfile(
          PTag.kPerformedStationGeographicLocationCodeSequence, 'X', remove);
  static const BasicProfile kScheduledHumanPerformersSequence =
      BasicProfile(PTag.kScheduledHumanPerformersSequence, 'X', remove);
  static const BasicProfile kActualHumanPerformersSequence =
      BasicProfile(PTag.kActualHumanPerformersSequence, 'X', remove);
  static const BasicProfile kHumanPerformersOrganization =
      BasicProfile(PTag.kHumanPerformerOrganization, 'X', remove);
  static const BasicProfile kHumanPerformerName =
      BasicProfile(PTag.kHumanPerformerName, 'X', remove);
  static const BasicProfile kVerifyingOrganization =
      BasicProfile(PTag.kVerifyingOrganization, 'X', remove);
  static const BasicProfile kVerifyingObserverSequence =
      BasicProfile(PTag.kVerifyingObserverSequence, 'D', replaceWithDummy);
  static const BasicProfile kVerifyingObserverName =
      BasicProfile(PTag.kVerifyingObserverName, 'D', replaceWithDummy);
  static const BasicProfile kAuthorObserverSequence =
      BasicProfile(PTag.kAuthorObserverSequence, 'X', remove);
  static const BasicProfile kParticipantSequence =
      BasicProfile(PTag.kParticipantSequence, 'X', remove);
  static const BasicProfile kCustodialOrganizationSequence =
      BasicProfile(PTag.kCustodialOrganizationSequence, 'X', remove);
  static const BasicProfile kVerifyingObserverIdentificationCodeSequence =
      BasicProfile(PTag.kVerifyingObserverIdentificationCodeSequence, 'Z',
          replaceWithZero);
  static const BasicProfile kPersonName =
      BasicProfile(PTag.kPersonName, 'D', replaceWithDummy);
  static const BasicProfile kUID = BasicProfile(PTag.kUID, 'U', replaceUids);
  static const BasicProfile kContentSequence =
      BasicProfile(PTag.kContentSequence, 'X', remove);
  static const BasicProfile kTemplateExtensionOrganizationUID =
      BasicProfile(PTag.kTemplateExtensionOrganizationUID, 'U', replaceUids);
  static const BasicProfile kTemplateExtensionCreatorUID =
      BasicProfile(PTag.kTemplateExtensionCreatorUID, 'U', replaceUids);
  static const BasicProfile kGraphicAnnotationSequence =
      BasicProfile(PTag.kGraphicAnnotationSequence, 'D', replaceWithDummy);
  static const BasicProfile kContentCreatorName =
      BasicProfile(PTag.kContentCreatorName, 'Z', replaceWithZero);
  static const BasicProfile kContentCreatorIdentificationCodeSequence =
      BasicProfile(PTag.kContentCreatorIdentificationCodeSequence, 'X', remove);
  static const BasicProfile kFiducialUID =
      BasicProfile(PTag.kFiducialUID, 'U', replaceUids);
  static const BasicProfile kStorageMediaFileSetUID =
      BasicProfile(PTag.kStorageMediaFileSetUID, 'U', replaceUids);
  static const BasicProfile kIconImageSequence =
      BasicProfile(PTag.kIconImageSequence, 'X', remove);
  static const BasicProfile kTopicTitle =
      BasicProfile(PTag.kTopicTitle, 'X', remove);
  static const BasicProfile kTopicSubject =
      BasicProfile(PTag.kTopicSubject, 'X', remove);
  static const BasicProfile kTopicAuthor =
      BasicProfile(PTag.kTopicAuthor, 'X', remove);
  static const BasicProfile kTopicKeywords =
      BasicProfile(PTag.kTopicKeywords, 'X', remove);
  static const BasicProfile kDigitalSignatureUID =
      BasicProfile(PTag.kDigitalSignatureUID, 'X', remove);
  static const BasicProfile kReferencedDigitalSignatureSequence =
      BasicProfile(PTag.kReferencedDigitalSignatureSequence, 'X', remove);
  static const BasicProfile kReferencedSOPInstanceMACSequence =
      BasicProfile(PTag.kReferencedSOPInstanceMACSequence, 'X', remove);
  static const BasicProfile kMAC = BasicProfile(PTag.kMAC, 'X', remove);
  static const BasicProfile kModifiedAttributesSequence =
      BasicProfile(PTag.kModifiedAttributesSequence, 'X', remove);
  static const BasicProfile kOriginalAttributesSequence =
      BasicProfile(PTag.kOriginalAttributesSequence, 'X', remove);
  static const BasicProfile kTextString =
      BasicProfile(PTag.kTextString, 'X', remove);
  static const BasicProfile kReferencedFrameOfReferenceUID =
      BasicProfile(PTag.kReferencedFrameOfReferenceUID, 'U', replaceUids);
  static const BasicProfile kRelatedFrameOfReferenceUID =
      BasicProfile(PTag.kRelatedFrameOfReferenceUID, 'U', replaceUids);
  static const BasicProfile kDoseReferenceUID =
      BasicProfile(PTag.kDoseReferenceUID, 'U', replaceUids);
  static const BasicProfile kReviewerName =
      BasicProfile(PTag.kReviewerName, 'XD', removeUnlessZero);
  static const BasicProfile kArbitrary =
      BasicProfile(PTag.kArbitrary, 'X', remove);
  static const BasicProfile kTextComments =
      BasicProfile(PTag.kTextComments, 'X', remove);
  static const BasicProfile kResultsIDIssuer =
      BasicProfile(PTag.kResultsIDIssuer, 'X', remove);
  static const BasicProfile kInterpretationRecorder =
      BasicProfile(PTag.kInterpretationRecorder, 'X', remove);
  static const BasicProfile kInterpretationTranscriber =
      BasicProfile(PTag.kInterpretationTranscriber, 'X', remove);
  static const BasicProfile kInterpretationText =
      BasicProfile(PTag.kInterpretationText, 'X', remove);
  static const BasicProfile kInterpretationAuthor =
      BasicProfile(PTag.kInterpretationAuthor, 'X', remove);
  static const BasicProfile kInterpretationApproverSequence =
      BasicProfile(PTag.kInterpretationApproverSequence, 'X', remove);
  static const BasicProfile kPhysicianApprovingInterpretation =
      BasicProfile(PTag.kPhysicianApprovingInterpretation, 'X', remove);
  static const BasicProfile kInterpretationDiagnosisDescription =
      BasicProfile(PTag.kInterpretationDiagnosisDescription, 'X', remove);
  static const BasicProfile kResultsDistributionListSequence =
      BasicProfile(PTag.kResultsDistributionListSequence, 'X', remove);
  static const BasicProfile kDistributionName =
      BasicProfile(PTag.kDistributionName, 'X', remove);
  static const BasicProfile kDistributionAddress =
      BasicProfile(PTag.kDistributionAddress, 'X', remove);
  static const BasicProfile kInterpretationIDIssuer =
      BasicProfile(PTag.kInterpretationIDIssuer, 'X', remove);
  static const BasicProfile kImpressions =
      BasicProfile(PTag.kImpressions, 'X', remove);
  static const BasicProfile kResultsComments =
      BasicProfile(PTag.kResultsComments, 'X', remove);
  static const BasicProfile kDigitalSignaturesSequence =
      BasicProfile(PTag.kDigitalSignaturesSequence, 'X', remove);
  static const BasicProfile kDataSetTrailingPadding =
      BasicProfile(PTag.kDataSetTrailingPadding, 'X', remove);

  static const List<int> retainList = <int>[];

  static const List<int> removeCodes = [
    0x00001000, 0x00080024, 0x00080025, 0x00080034, 0x00080035, 0x00080081,
    0x00080092, 0x00080094, 0x00080096, 0x00080201, 0x00081030, 0x0008103e,
    0x00081040, 0x00081048, 0x00081049, 0x00081050, 0x00081052, 0x00081060,
    0x00081062, 0x00081080, 0x00081084, 0x00081120, 0x00082111, 0x00084000,
    0x00100021, 0x00100032, 0x00100050, 0x00100101, 0x00100102, 0x00101000,
    0x00101001, 0x00101002, 0x00101005, 0x00101010, 0x00101020, 0x00101030,
    0x00101040, 0x00101050, 0x00101060, 0x00101080, 0x00101081, 0x00101090,
    0x00102000, 0x00102110, 0x00102150, 0x00102152, 0x00102154, 0x00102160,
    0x00102180, 0x001021a0, 0x001021b0, 0x001021c0, 0x001021d0, 0x001021f0,
    0x00102297, 0x00102299, 0x00104000, 0x00181004, 0x00181005, 0x00181007,
    0x00181008, 0x00184000, 0x00189424, 0x0018a003, 0x00203401, 0x00203404,
    0x00203406, 0x00204000, 0x00209158, 0x00284000, 0x00320012, 0x00321020,
    0x00321021, 0x00321030, 0x00321032, 0x00321033, 0x00321070, 0x00324000,
    0x00380004, 0x00380010, 0x00380011, 0x0038001e, 0x00380020, 0x00380021,
    0x00380040, 0x00380050, 0x00380060, 0x00380061, 0x00380062, 0x00380300,
    0x00380400, 0x00380500, 0x00384000, 0x00400001, 0x00400002, 0x00400003,
    0x00400004, 0x00400005, 0x00400006, 0x00400007, 0x0040000b, 0x00400010,
    0x00400011, 0x00400012, 0x00400241, 0x00400242, 0x00400243, 0x00400244,
    0x00400245, 0x00400250, 0x00400251, 0x00400253, 0x00400254, 0x00400275,
    0x00400280, 0x00400555, 0x00401001, 0x00401004, 0x00401005, 0x00401010,
    0x00401011, 0x00401102, 0x00401103, 0x00401400, 0x00402001, 0x00402008,
    0x00402009, 0x00402010, 0x00402400, 0x00403001, 0x00404025, 0x00404027,
    0x00404028, 0x00404030, 0x00404034, 0x00404035, 0x00404036, 0x00404037,
    0x0040a027, 0x0040a078, 0x0040a07a, 0x0040a07c, 0x0040a730, 0x00700086,
    0x00880200, 0x00880904, 0x00880906, 0x00880910, 0x00880912, 0x04000100,
    0x04000402, 0x04000403, 0x04000404, 0x04000550, 0x04000561, 0x20300020,
    0x40000010, 0x40004000, 0x40080042, 0x40080102, 0x4008010a, 0x4008010b,
    0x4008010c, 0x40080111, 0x40080114, 0x40080115, 0x40080118, 0x40080119,
    0x4008011a, 0x40080202, 0x40080300, 0x40084000,
    0xfffafffa, 0xfffcfffc // don't reformat
  ];

  static const Map<int, BasicProfile> map = <int, BasicProfile>{
    0x00001000: kAffectedSOPInstanceUID,
    0x00001001: kRequestedSOPInstanceUID,
    0x00020003: kMediaStorageSOPInstanceUID,
    0x00041511: kReferencedSOPInstanceUIDinFile,
    0x00080014: kInstanceCreatorUID,
    0x00080018: kSOPInstanceUID,
    0x00080020: kStudyDate,
    0x00080021: kSeriesDate,
    0x00080022: kAcquisitionDate,
    0x00080023: kContentDate,
    0x00080024: kOverlayDate,
    0x00080025: kCurveDate,
    0x0008002a: kAcquisitionDateTime,
    0x00080030: kStudyTime,
    0x00080031: kSeriesTime,
    0x00080032: kAcquisitionTime,
    0x00080033: kContentTime,
    0x00080034: kOverlayTime,
    0x00080035: kCurveTime,
    0x00080050: kAccessionNumber,
    0x00080058: kFailedSOPInstanceUIDList,
    0x00080080: kInstitutionName,
    0x00080081: kInstitutionAddress,
    0x00080082: kInstitutionCodeSequence,
    0x00080090: kReferringPhysiciansName,
    0x00080092: kReferringPhysiciansAddress,
    0x00080094: kReferringPhysiciansTelephoneNumbers,
    0x00080096: kReferringPhysiciansIdentificationSequence,
    0x0008010d: kContextGroupExtensionCreatorUID,
    0x00080201: kTimezoneOffsetFromUTC,
    0x00081010: kStationName,
    0x00081030: kStudyDescription,
    0x0008103e: kSeriesDescription,
    0x00081040: kInstitutionalDepartmentName,
    0x00081048: kPhysicianOfRecord,
    0x00081049: kPhysician0xsofRecordIdentificationSequence,
    0x00081050: kPerformingPhysiciansName,
    0x00081052: kPerformingPhysicianIdentificationSequence,
    0x00081060: kNameofPhysician0xsReadingStudy,
    0x00081062: kPhysician0xsReadingStudyIdentificationSequence,
    0x00081070: kOperatorsName,
    0x00081072: kOperatorsIdentificationSequence,
    0x00081080: kAdmittingDiagnosesDescription,
    0x00081084: kAdmittingDiagnosesCodeSequence,
    0x00081110: kReferencedStudySequence,
    0x00081111: kReferencedPerformedProcedureStepSequence,
    0x00081120: kReferencedPatientSequence,
    0x00081140: kReferencedImageSequence,
    0x00081155: kReferencedSOPInstanceUID,
    0x00081195: kTransactionUID,
    0x00082111: kDerivationDescription,
    0x00082112: kSourceImageSequence,
    0x00083010: kIrradiationEventUID,
    0x00084000: kIdentifyingComments,
    0x00089123: kCreatorVersionUID,
    0x00100010: kPatientsName,
    0x00100020: kPatientID,
    0x00100021: kIssuerofPatientID,
    0x00100030: kPatientsBirthDate,
    0x00100032: kPatientsBirthTime,
    0x00100040: kPatientsSex,
    0x00100050: kPatientsInsurancePlanCodeSequence,
    0x00100101: kPatientsPrimaryLanguageCodeSequence,
    0x00100102: kPatientsPrimaryLanguageModifierCodeSequence,
    0x00101000: kOtherPatientIDs,
    0x00101001: kOtherPatientNames,
    0x00101002: kOtherPatientIDsSequence,
    0x00101005: kPatientsBirthName,
    0x00101010: kPatientAge,
    0x00101020: kPatientSize,
    0x00101030: kPatientWeight,
    0x00101040: kPatientAddress,
    0x00101050: kInsurancePlanIdentification,
    0x00101060: kPatientMotherBirthName,
    0x00101080: kMilitaryRank,
    0x00101081: kBranchOfService,
    0x00101090: kMedicalRecordLocator,
    0x00102000: kMedicalAlerts,
    0x00102110: kAllergies,
    0x00102150: kCountryOfResidence,
    0x00102152: kRegionOfResidence,
    0x00102154: kPatientTelephoneNumbers,
    0x00102160: kEthnicGroup,
    0x00102180: kOccupation,
    0x001021a0: kSmokingStatus,
    0x001021b0: kAdditionalPatientHistory,
    0x001021c0: kPregnancyStatus,
    0x001021d0: kLastMenstrualDate,
    0x001021f0: kPatientReligiousPreference,
    0x00102203: kPatientSexNeutered,
    0x00102297: kResponsiblePerson,
    0x00102299: kResponsibleOrganization,
    0x00104000: kPatientComments,
    0x00180010: kContrastBolusAgent,
    0x00181000: kDeviceSerialNumber,
    0x00181002: kDeviceUID,
    0x00181004: kPlateID,
    0x00181005: kGeneratorID,
    0x00181007: kCassetteID,
    0x00181008: kGantryID,
    0x00181030: kProtocolName,
    0x00181400: kAcquisitionDeviceProcessingDescription,
    0x00184000: kAcquisitionComments,
    0x0018700a: kDetectorID,
    0x00189424: kAcquisitionProtocolDescription,
    0x0018a003: kContributionDescription,
    0x0020000d: kStudyInstanceUID,
    0x0020000e: kSeriesInstanceUID,
    0x00200010: kStudyID,
    0x00200052: kFrameOfReferenceUID,
    0x00200200: kSynchronizationFrameOfReferenceUID,
    0x00203401: kModifyingDeviceID,
    0x00203404: kModifyingDeviceManufacturer,
    0x00203406: kModifiedImageDescription,
    0x00204000: kImageComments,
    0x00209158: kFrameComments,
    0x00209161: kConcatenationUID,
    0x00209164: kDimensionOrganizationUID,
    0x00281199: kPaletteColorLookupTableUID,
    0x00281214: kLargePaletteColorLookupTableUID,
    0x00284000: kImagePresentationComments,
    0x00320012: kStudyIDIssuer,
    0x00321020: kScheduledStudyLocation,
    0x00321021: kScheduledStudyLocationAETitle,
    0x00321030: kReasonForStudy,
    0x00321032: kRequestingPhysician,
    0x00321033: kRequestingService,
    0x00321060: kRequestedProcedureDescription,
    0x00321070: kRequestedContrastAgent,
    0x00324000: kStudyComments,
    0x00380004: kReferencedPatientAliasSequence,
    0x00380010: kAdmissionID,
    0x00380011: kIssuerOfAdmissionID,
    0x0038001e: kScheduledPatientInstitutionResidence,
    0x00380020: kAdmittingDate,
    0x00380021: kAdmittingTime,
    0x00380040: kDischargeDiagnosisDescription,
    0x00380050: kSpecialNeeds,
    0x00380060: kServiceEpisodeID,
    0x00380061: kIssuerOfServiceEpisodeID,
    0x00380062: kServiceEpisodeDescription,
    0x00380300: kCurrentPatientLocation,
    0x00380400: kPatientInstitutionResidence,
    0x00380500: kPatientState,
    0x00384000: kVisitComments,
    0x00400001: kScheduledStationAETitle,
    0x00400002: kScheduledProcedureStepStartDate,
    0x00400003: kScheduledProcedureStepStartTime,
    0x00400004: kScheduledProcedureStepEndDate,
    0x00400005: kScheduledProcedureStepEndTime,
    0x00400006: kScheduledPerformingPhysicianName,
    0x00400007: kScheduledProcedureStepDescription,
    0x0040000b: kScheduledPerformingPhysicianIdentificationSequence,
    0x00400010: kScheduledStationName,
    0x00400011: kScheduledProcedureStepLocation,
    0x00400012: kPreMedication,
    0x00400241: kPerformedStationAETitle,
    0x00400242: kPerformedStationName,
    0x00400243: kPerformedLocation,
    0x00400244: kPerformedProcedureStepStartDate,
    0x00400245: kPerformedProcedureStepStartTime,
    0x00400250: kPerformedProcedureStepEndDate,
    0x00400251: kPerformedProcedureStepEndTime,
    0x00400253: kPerformedProcedureStepID,
    0x00400254: kPerformedProcedureStepDescription,
    0x00400275: kRequestAttributesSequence,
    0x00400280: kCommentsOnThePerformedProcedureStep,
    0x00400555: kAcquisitionContextSequence,
    0x00401001: kRequestedProcedureID,
    0x00401004: kPatientTransportArrangements,
    0x00401005: kRequestedProcedureLocation,
    0x00401010: kNamesOfIntendedRecipientsOfResults,
    0x00401011: kIntendedRecipientsOfResultsIdentificationSequence,
    0x00401101: kPersonIdentificationCodeSequence,
    0x00401102: kPersonAddress,
    0x00401103: kPersonTelephoneNumbers,
    0x00401400: kRequestedProcedureComments,
    0x00402001: kReasonForTheImagingServiceRequest,
    0x00402008: kOrderEnteredBy,
    0x00402009: kOrderEntererLocation,
    0x00402010: kOrderCallbackPhoneNumber,
    0x00402016: kPlacerOrderNumberImagingServiceRequest,
    0x00402017: kFillerOrderNumberImagingServiceRequest,
    0x00402400: kImagingServiceRequestComments,
    0x00403001: kConfidentialityConstraintonPatientDataDescription,
    0x00404023: kReferencedGeneralPurposeScheduledProcedureStepTransactionUID,
    0x00404025: kScheduledStationNameCodeSequence,
    0x00404027: kScheduledStationGeographicLocationCodeSequence,
    0x00404028: kPerformedStationNameCodeSequence,
    0x00404030: kPerformedStationGeographicLocationCodeSequence,
    0x00404034: kScheduledHumanPerformersSequence,
    0x00404035: kActualHumanPerformersSequence,
    0x00404036: kHumanPerformersOrganization,
    0x00404037: kHumanPerformerName,
    0x0040a027: kVerifyingOrganization,
    0x0040a073: kVerifyingObserverSequence,
    0x0040a075: kVerifyingObserverName,
    0x0040a078: kAuthorObserverSequence,
    0x0040a07a: kParticipantSequence,
    0x0040a07c: kCustodialOrganizationSequence,
    0x0040a088: kVerifyingObserverIdentificationCodeSequence,
    0x0040a123: kPersonName,
    0x0040a124: kUID,
    0x0040a730: kContentSequence,
    0x0040db0c: kTemplateExtensionOrganizationUID,
    0x0040db0d: kTemplateExtensionCreatorUID,
    0x00700001: kGraphicAnnotationSequence,
    0x00700084: kContentCreatorName,
    0x00700086: kContentCreatorIdentificationCodeSequence,
    0x0070031a: kFiducialUID,
    0x00880140: kStorageMediaFileSetUID,
    0x00880200: kIconImageSequence,
    0x00880904: kTopicTitle,
    0x00880906: kTopicSubject,
    0x00880910: kTopicAuthor,
    0x00880912: kTopicKeywords,
    0x04000100: kDigitalSignatureUID,
    0x04000402: kReferencedDigitalSignatureSequence,
    0x04000403: kReferencedSOPInstanceMACSequence,
    0x04000404: kMAC,
    0x04000550: kModifiedAttributesSequence,
    0x04000561: kOriginalAttributesSequence,
    0x20300020: kTextString,
    0x30060024: kReferencedFrameOfReferenceUID,
    0x300600c2: kRelatedFrameOfReferenceUID,
    0x300a0013: kDoseReferenceUID,
    0x300e0008: kReviewerName,
    0x40000010: kArbitrary,
    0x40004000: kTextComments,
    0x40080042: kResultsIDIssuer,
    0x40080102: kInterpretationRecorder,
    0x4008010a: kInterpretationTranscriber,
    0x4008010b: kInterpretationText,
    0x4008010c: kInterpretationAuthor,
    0x40080111: kInterpretationApproverSequence,
    0x40080114: kPhysicianApprovingInterpretation,
    0x40080115: kInterpretationDiagnosisDescription,
    0x40080118: kResultsDistributionListSequence,
    0x40080119: kDistributionName,
    0x4008011a: kDistributionAddress,
    0x40080202: kInterpretationIDIssuer,
    0x40080300: kImpressions,
    0x40084000: kResultsComments,
    0xfffafffa: kDigitalSignaturesSequence,
    0xfffcfffc: kDataSetTrailingPadding
  };

  static const List<int> codes = [
    // No format
    0x00001000, 0x00001001, 0x00020003, 0x00041511, 0x00080014, 0x00080018,
    0x00080020, 0x00080021, 0x00080022, 0x00080023, 0x00080024, 0x00080025,
    0x0008002a, 0x00080030, 0x00080031, 0x00080032, 0x00080033, 0x00080034,
    0x00080035, 0x00080050, 0x00080058, 0x00080080, 0x00080081, 0x00080082,
    0x00080090, 0x00080092, 0x00080094, 0x00080096, 0x0008010d, 0x00080201,
    0x00081010, 0x00081030, 0x0008103e, 0x00081040, 0x00081048, 0x00081049,
    0x00081050, 0x00081052, 0x00081060, 0x00081062, 0x00081070, 0x00081072,
    0x00081080, 0x00081084, 0x00081110, 0x00081111, 0x00081120, 0x00081140,
    0x00081155, 0x00081195, 0x00082111, 0x00082112, 0x00083010, 0x00084000,
    0x00089123, 0x00100010, 0x00100020, 0x00100021, 0x00100030, 0x00100032,
    0x00100040, 0x00100050, 0x00100101, 0x00100102, 0x00101000, 0x00101001,
    0x00101002, 0x00101005, 0x00101010, 0x00101020, 0x00101030, 0x00101040,
    0x00101050, 0x00101060, 0x00101080, 0x00101081, 0x00101090, 0x00102000,
    0x00102110, 0x00102150, 0x00102152, 0x00102154, 0x00102160, 0x00102180,
    0x001021a0, 0x001021b0, 0x001021c0, 0x001021d0, 0x001021f0, 0x00102203,
    0x00102297, 0x00102299, 0x00104000, 0x00180010, 0x00181000, 0x00181002,
    0x00181004, 0x00181005, 0x00181007, 0x00181008, 0x00181030, 0x00181400,
    0x00184000, 0x0018700a, 0x00189424, 0x0018a003, 0x0020000d, 0x0020000e,
    0x00200010, 0x00200052, 0x00200200, 0x00203401, 0x00203404, 0x00203406,
    0x00204000, 0x00209158, 0x00209161, 0x00209164, 0x00281199, 0x00281214,
    0x00284000, 0x00320012, 0x00321020, 0x00321021, 0x00321030, 0x00321032,
    0x00321033, 0x00321060, 0x00321070, 0x00324000, 0x00380004, 0x00380010,
    0x00380011, 0x0038001e, 0x00380020, 0x00380021, 0x00380040, 0x00380050,
    0x00380060, 0x00380061, 0x00380062, 0x00380300, 0x00380400, 0x00380500,
    0x00384000, 0x00400001, 0x00400002, 0x00400003, 0x00400004, 0x00400005,
    0x00400006, 0x00400007, 0x0040000b, 0x00400010, 0x00400011, 0x00400012,
    0x00400241, 0x00400242, 0x00400243, 0x00400244, 0x00400245, 0x00400250,
    0x00400251, 0x00400253, 0x00400254, 0x00400275, 0x00400280, 0x00400555,
    0x00401001, 0x00401004, 0x00401005, 0x00401010, 0x00401011, 0x00401101,
    0x00401102, 0x00401103, 0x00401400, 0x00402001, 0x00402008, 0x00402009,
    0x00402010, 0x00402016, 0x00402017, 0x00402400, 0x00403001, 0x00404023,
    0x00404025, 0x00404027, 0x00404028, 0x00404030, 0x00404034, 0x00404035,
    0x00404036, 0x00404037, 0x0040a027, 0x0040a073, 0x0040a075, 0x0040a078,
    0x0040a07a, 0x0040a07c, 0x0040a088, 0x0040a123, 0x0040a124, 0x0040a730,
    0x0040db0c, 0x0040db0d, 0x00700001, 0x00700084, 0x00700086, 0x0070031a,
    0x00880140, 0x00880200, 0x00880904, 0x00880906, 0x00880910, 0x00880912,
    0x04000100, 0x04000402, 0x04000403, 0x04000404, 0x04000550, 0x04000561,
    0x20300020, 0x30060024, 0x300600c2, 0x300a0013, 0x300e0008, 0x40000010,
    0x40004000, 0x40080042, 0x40080102, 0x4008010a, 0x4008010b, 0x4008010c,
    0x40080111, 0x40080114, 0x40080115, 0x40080118, 0x40080119, 0x4008011a,
    0x40080202, 0x40080300, 0x40084000, 0xfffafffa, 0xfffcfffc
  ];
}
