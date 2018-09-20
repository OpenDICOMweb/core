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
import 'package:core/src/tag.dart';
import 'package:core/src/values/uid.dart';

// ignore_for_file: public_member_api_docs

/// Basic De-Identification Profile.
class DeIdTags {
  final Tag tag;
  final String name;
  final Function action;

  const DeIdTags(this.tag, this.name, this.action);

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

  static DeIdTags lookup(int tag) => map[tag];

  static const DeIdTags kAffectedSOPInstanceUID =
      DeIdTags(PTag.kAffectedSOPInstanceUID, 'X', remove);
  static const DeIdTags kRequestedSOPInstanceUID =
      DeIdTags(PTag.kRequestedSOPInstanceUID, 'U', replaceUids);
  static const DeIdTags kMediaStorageSOPInstanceUID =
      DeIdTags(PTag.kMediaStorageSOPInstanceUID, 'U', replaceUids);
  static const DeIdTags kReferencedSOPInstanceUIDInFile =
      DeIdTags(PTag.kReferencedSOPInstanceUIDInFile, 'U', replaceUids);
  static const DeIdTags kInstanceCreatorUID =
      DeIdTags(PTag.kInstanceCreatorUID, 'U', replaceUids);
  static const DeIdTags kSOPInstanceUID =
      DeIdTags(PTag.kSOPInstanceUID, 'U', replaceUids);
  static const DeIdTags kStudyDate =
      DeIdTags(PTag.kStudyDate, 'Z', replaceWithZero);
  static const DeIdTags kSeriesDate =
      DeIdTags(PTag.kSeriesDate, 'XD', removeUnlessDummy);
  static const DeIdTags kAcquisitionDate =
      DeIdTags(PTag.kAcquisitionDate, 'XD', removeUnlessZero);
  static const DeIdTags kContentDate =
      DeIdTags(PTag.kContentDate, 'XD', removeUnlessDummy);
  static const DeIdTags kOverlayDate = DeIdTags(PTag.kOverlayDate, 'X', remove);
  static const DeIdTags kCurveDate = DeIdTags(PTag.kCurveDate, 'X', remove);
  static const DeIdTags kAcquisitionDateTime =
      DeIdTags(PTag.kAcquisitionDateTime, 'XD', removeUnlessDummy);
  static const DeIdTags kStudyTime =
      DeIdTags(PTag.kStudyTime, 'Z', replaceWithZero);
  static const DeIdTags kSeriesTime =
      DeIdTags(PTag.kSeriesTime, 'XD', removeUnlessDummy);
  static const DeIdTags kAcquisitionTime =
      DeIdTags(PTag.kAcquisitionTime, 'XD', removeUnlessZero);
  static const DeIdTags kContentTime =
      DeIdTags(PTag.kContentTime, 'XD', removeUnlessDummy);
  static const DeIdTags kOverlayTime = DeIdTags(PTag.kOverlayTime, 'X', remove);
  static const DeIdTags kCurveTime = DeIdTags(PTag.kCurveTime, 'X', remove);
  static const DeIdTags kAccessionNumber =
      DeIdTags(PTag.kAccessionNumber, 'Z', replaceWithZero);
  static const DeIdTags kFailedSOPInstanceUIDList =
      DeIdTags(PTag.kFailedSOPInstanceUIDList, 'U', replaceUids);
  static const DeIdTags kInstitutionName =
      DeIdTags(PTag.kInstitutionName, 'XZD', removeUnlessZeroOrDummy);
  static const DeIdTags kInstitutionAddress =
      DeIdTags(PTag.kInstitutionAddress, 'X', remove);
  static const DeIdTags kInstitutionCodeSequence =
      DeIdTags(PTag.kInstitutionCodeSequence, 'XZD', removeUnlessZeroOrDummy);
  static const DeIdTags kReferringPhysicianName =
      DeIdTags(PTag.kReferringPhysicianName, 'Z', replaceWithZero);
  static const DeIdTags kReferringPhysicianAddress =
      DeIdTags(PTag.kReferringPhysicianAddress, 'X', remove);
  static const DeIdTags kReferringPhysicianTelephoneNumbers =
      DeIdTags(PTag.kReferringPhysicianTelephoneNumbers, 'X', remove);
  static const DeIdTags kReferringPhysicianIdentificationSequence =
      DeIdTags(PTag.kReferringPhysicianIdentificationSequence, 'X', remove);
  static const DeIdTags kContextGroupExtensionCreatorUID =
      DeIdTags(PTag.kContextGroupExtensionCreatorUID, 'U', replaceUids);
  static const DeIdTags kTimezoneOffsetFromUTC =
      DeIdTags(PTag.kTimezoneOffsetFromUTC, 'X', remove);
  static const DeIdTags kStationName =
      DeIdTags(PTag.kStationName, 'XZD', removeUnlessZeroOrDummy);
  static const DeIdTags kStudyDescription =
      DeIdTags(PTag.kStudyDescription, 'X', remove);
  static const DeIdTags kSeriesDescription =
      DeIdTags(PTag.kSeriesDescription, 'X', remove);
  static const DeIdTags kInstitutionalDepartmentName =
      DeIdTags(PTag.kInstitutionalDepartmentName, 'X', remove);
  static const DeIdTags kPhysicianOfRecord =
      DeIdTags(PTag.kPhysiciansOfRecord, 'X', remove);
  static const DeIdTags kPhysiciansOfRecordIdentificationSequence =
      DeIdTags(PTag.kPhysiciansOfRecordIdentificationSequence, 'X', remove);
  static const DeIdTags kPerformingPhysicianName =
      DeIdTags(PTag.kPerformingPhysicianName, 'X', remove);
  static const DeIdTags kPerformingPhysicianIdentificationSequence =
      DeIdTags(PTag.kPerformingPhysicianIdentificationSequence, 'X', remove);
  static const DeIdTags kNameOfPhysiciansReadingStudy =
      DeIdTags(PTag.kNameOfPhysiciansReadingStudy, 'X', remove);
  static const DeIdTags kPhysiciansReadingStudyIdentificationSequence =
      DeIdTags(PTag.kPhysiciansReadingStudyIdentificationSequence, 'X', remove);
  static const DeIdTags kOperatorsName =
      DeIdTags(PTag.kOperatorsName, 'XZD', removeUnlessZeroOrDummy);
  static const DeIdTags kOperatorsIdentificationSequence =
      DeIdTags(PTag.kOperatorIdentificationSequence, 'XD', removeUnlessDummy);
  static const DeIdTags kAdmittingDiagnosesDescription =
      DeIdTags(PTag.kAdmittingDiagnosesDescription, 'X', remove);
  static const DeIdTags kAdmittingDiagnosesCodeSequence =
      DeIdTags(PTag.kAdmittingDiagnosesCodeSequence, 'X', remove);
  static const DeIdTags kReferencedStudySequence =
      DeIdTags(PTag.kReferencedStudySequence, 'XD', removeUnlessZero);
  static const DeIdTags kReferencedPerformedProcedureStepSequence = DeIdTags(
      PTag.kReferencedPerformedProcedureStepSequence,
      'XZD',
      removeUnlessZeroOrDummy);
  static const DeIdTags kReferencedPatientSequence =
      DeIdTags(PTag.kReferencedPatientSequence, 'X', remove);
  static const DeIdTags kReferencedImageSequence = DeIdTags(
      PTag.kReferencedImageSequence, 'XZU', removeUidUnlessZeroOrDummy);
  static const DeIdTags kReferencedSOPInstanceUID =
      DeIdTags(PTag.kReferencedSOPInstanceUID, 'U', replaceUids);
  static const DeIdTags kTransactionUID =
      DeIdTags(PTag.kTransactionUID, 'U', replaceUids);
  static const DeIdTags kDerivationDescription =
      DeIdTags(PTag.kDerivationDescription, 'X', remove);
  static const DeIdTags kSourceImageSequence =
      DeIdTags(PTag.kSourceImageSequence, 'XZU', removeUidUnlessZeroOrDummy);
  static const DeIdTags kIrradiationEventUID =
      DeIdTags(PTag.kIrradiationEventUID, 'U', replaceUids);
  static const DeIdTags kIdentifyingComments =
      DeIdTags(PTag.kIdentifyingComments, 'X', remove);
  static const DeIdTags kCreatorVersionUID =
      DeIdTags(PTag.kCreatorVersionUID, 'U', replaceUids);
  static const DeIdTags kPatientName =
      DeIdTags(PTag.kPatientName, 'Z', replaceWithZero);
  static const DeIdTags kPatientID =
      DeIdTags(PTag.kPatientID, 'Z', replaceWithZero);
  static const DeIdTags kIssuerOfPatientID =
      DeIdTags(PTag.kIssuerOfPatientID, 'X', remove);
  static const DeIdTags kPatientBirthDate =
      DeIdTags(PTag.kPatientBirthDate, 'Z', replaceWithZero);
  static const DeIdTags kPatientBirthTime =
      DeIdTags(PTag.kPatientBirthTime, 'X', remove);
  static const DeIdTags kPatientSex =
      DeIdTags(PTag.kPatientSex, 'Z', replaceWithZero);
  static const DeIdTags kPatientInsurancePlanCodeSequence =
      DeIdTags(PTag.kPatientInsurancePlanCodeSequence, 'X', remove);
  static const DeIdTags kPatientPrimaryLanguageCodeSequence =
      DeIdTags(PTag.kPatientPrimaryLanguageCodeSequence, 'X', remove);
  static const DeIdTags kPatientPrimaryLanguageModifierCodeSequence =
      DeIdTags(PTag.kPatientPrimaryLanguageModifierCodeSequence, 'X', remove);
  static const DeIdTags kOtherPatientIDs =
      DeIdTags(PTag.kOtherPatientIDs, 'X', remove);
  static const DeIdTags kOtherPatientNames =
      DeIdTags(PTag.kOtherPatientNames, 'X', remove);
  static const DeIdTags kOtherPatientIDsSequence =
      DeIdTags(PTag.kOtherPatientIDsSequence, 'X', remove);
  static const DeIdTags kPatientBirthName =
      DeIdTags(PTag.kPatientBirthName, 'X', remove);
  static const DeIdTags kPatientAge = DeIdTags(PTag.kPatientAge, 'X', remove);
  static const DeIdTags kPatientSize = DeIdTags(PTag.kPatientSize, 'X', remove);
  static const DeIdTags kPatientWeight =
      DeIdTags(PTag.kPatientWeight, 'X', remove);
  static const DeIdTags kPatientAddress =
      DeIdTags(PTag.kPatientAddress, 'X', remove);
  static const DeIdTags kInsurancePlanIdentification =
      DeIdTags(PTag.kInsurancePlanIdentification, 'X', remove);
  static const DeIdTags kPatientMotherBirthName =
      DeIdTags(PTag.kPatientMotherBirthName, 'X', remove);
  static const DeIdTags kMilitaryRank =
      DeIdTags(PTag.kMilitaryRank, 'X', remove);
  static const DeIdTags kBranchOfService =
      DeIdTags(PTag.kBranchOfService, 'X', remove);
  static const DeIdTags kMedicalRecordLocator =
      DeIdTags(PTag.kMedicalRecordLocator, 'X', remove);
  static const DeIdTags kMedicalAlerts =
      DeIdTags(PTag.kMedicalAlerts, 'X', remove);
  static const DeIdTags kAllergies = DeIdTags(PTag.kAllergies, 'X', remove);
  static const DeIdTags kCountryOfResidence =
      DeIdTags(PTag.kCountryOfResidence, 'X', remove);
  static const DeIdTags kRegionOfResidence =
      DeIdTags(PTag.kRegionOfResidence, 'X', remove);
  static const DeIdTags kPatientTelephoneNumbers =
      DeIdTags(PTag.kPatientTelephoneNumbers, 'X', remove);
  static const DeIdTags kEthnicGroup = DeIdTags(PTag.kEthnicGroup, 'X', remove);
  static const DeIdTags kOccupation = DeIdTags(PTag.kOccupation, 'X', remove);
  static const DeIdTags kSmokingStatus =
      DeIdTags(PTag.kSmokingStatus, 'X', remove);
  static const DeIdTags kAdditionalPatientHistory =
      DeIdTags(PTag.kAdditionalPatientHistory, 'X', remove);
  static const DeIdTags kPregnancyStatus =
      DeIdTags(PTag.kPregnancyStatus, 'X', remove);
  static const DeIdTags kLastMenstrualDate =
      DeIdTags(PTag.kLastMenstrualDate, 'X', remove);
  static const DeIdTags kPatientReligiousPreference =
      DeIdTags(PTag.kPatientReligiousPreference, 'X', remove);
  static const DeIdTags kPatientSexNeutered =
      DeIdTags(PTag.kPatientSexNeutered, 'XD', removeUnlessZero);
  static const DeIdTags kResponsiblePerson =
      DeIdTags(PTag.kResponsiblePerson, 'X', remove);
  static const DeIdTags kResponsibleOrganization =
      DeIdTags(PTag.kResponsibleOrganization, 'X', remove);
  static const DeIdTags kPatientComments =
      DeIdTags(PTag.kPatientComments, 'X', remove);
  static const DeIdTags kContrastBolusAgent =
      DeIdTags(PTag.kContrastBolusAgent, 'XD', removeUnlessDummy);
  static const DeIdTags kDeviceSerialNumber =
      DeIdTags(PTag.kDeviceSerialNumber, 'XZD', removeUnlessZeroOrDummy);
  static const DeIdTags kDeviceUID =
      DeIdTags(PTag.kDeviceUID, 'U', replaceUids);
  static const DeIdTags kPlateID = DeIdTags(PTag.kPlateID, 'X', remove);
  static const DeIdTags kGeneratorID = DeIdTags(PTag.kGeneratorID, 'X', remove);
  static const DeIdTags kCassetteID = DeIdTags(PTag.kCassetteID, 'X', remove);
  static const DeIdTags kGantryID = DeIdTags(PTag.kGantryID, 'X', remove);
  static const DeIdTags kProtocolName =
      DeIdTags(PTag.kProtocolName, 'XD', removeUnlessDummy);
  static const DeIdTags kAcquisitionDeviceProcessingDescription = DeIdTags(
      PTag.kAcquisitionDeviceProcessingDescription, 'XD', removeUnlessDummy);
  static const DeIdTags kAcquisitionComments =
      DeIdTags(PTag.kAcquisitionComments, 'X', remove);
  static const DeIdTags kDetectorID =
      DeIdTags(PTag.kDetectorID, 'XD', removeUnlessDummy);
  static const DeIdTags kAcquisitionProtocolDescription =
      DeIdTags(PTag.kAcquisitionProtocolDescription, 'X', remove);
  static const DeIdTags kContributionDescription =
      DeIdTags(PTag.kContributionDescription, 'X', remove);
  static const DeIdTags kStudyInstanceUID =
      DeIdTags(PTag.kStudyInstanceUID, 'U', replaceUids);
  static const DeIdTags kSeriesInstanceUID =
      DeIdTags(PTag.kSeriesInstanceUID, 'U', replaceUids);
  static const DeIdTags kStudyID =
      DeIdTags(PTag.kStudyID, 'Z', replaceWithZero);
  static const DeIdTags kFrameOfReferenceUID =
      DeIdTags(PTag.kFrameOfReferenceUID, 'U', replaceUids);
  static const DeIdTags kSynchronizationFrameOfReferenceUID =
      DeIdTags(PTag.kSynchronizationFrameOfReferenceUID, 'U', replaceUids);
  static const DeIdTags kModifyingDeviceID =
      DeIdTags(PTag.kModifyingDeviceID, 'X', remove);
  static const DeIdTags kModifyingDeviceManufacturer =
      DeIdTags(PTag.kModifyingDeviceManufacturer, 'X', remove);
  static const DeIdTags kModifiedImageDescription =
      DeIdTags(PTag.kModifiedImageDescription, 'X', remove);
  static const DeIdTags kImageComments =
      DeIdTags(PTag.kImageComments, 'X', remove);
  static const DeIdTags kFrameComments =
      DeIdTags(PTag.kFrameComments, 'X', remove);
  static const DeIdTags kConcatenationUID =
      DeIdTags(PTag.kConcatenationUID, 'U', replaceUids);
  static const DeIdTags kDimensionOrganizationUID =
      DeIdTags(PTag.kDimensionOrganizationUID, 'U', replaceUids);
  static const DeIdTags kPaletteColorLookupTableUID =
      DeIdTags(PTag.kPaletteColorLookupTableUID, 'U', replaceUids);
  static const DeIdTags kLargePaletteColorLookupTableUID =
      DeIdTags(PTag.kLargePaletteColorLookupTableUID, 'U', replaceUids);
  static const DeIdTags kImagePresentationComments =
      DeIdTags(PTag.kImagePresentationComments, 'X', remove);
  static const DeIdTags kStudyIDIssuer =
      DeIdTags(PTag.kStudyIDIssuer, 'X', remove);
  static const DeIdTags kScheduledStudyLocation =
      DeIdTags(PTag.kScheduledStudyLocation, 'X', remove);
  static const DeIdTags kScheduledStudyLocationAETitle =
      DeIdTags(PTag.kScheduledStudyLocationAETitle, 'X', remove);
  static const DeIdTags kReasonForStudy =
      DeIdTags(PTag.kReasonForStudy, 'X', remove);
  static const DeIdTags kRequestingPhysician =
      DeIdTags(PTag.kRequestingPhysician, 'X', remove);
  static const DeIdTags kRequestingService =
      DeIdTags(PTag.kRequestingService, 'X', remove);
  static const DeIdTags kRequestedProcedureDescription =
      DeIdTags(PTag.kRequestedProcedureDescription, 'XD', removeUnlessZero);
  static const DeIdTags kRequestedContrastAgent =
      DeIdTags(PTag.kRequestedContrastAgent, 'X', remove);
  static const DeIdTags kStudyComments =
      DeIdTags(PTag.kStudyComments, 'X', remove);
  static const DeIdTags kReferencedPatientAliasSequence =
      DeIdTags(PTag.kReferencedPatientAliasSequence, 'X', remove);
  static const DeIdTags kAdmissionID = DeIdTags(PTag.kAdmissionID, 'X', remove);
  static const DeIdTags kIssuerOfAdmissionID =
      DeIdTags(PTag.kIssuerOfAdmissionID, 'X', remove);
  static const DeIdTags kScheduledPatientInstitutionResidence =
      DeIdTags(PTag.kScheduledPatientInstitutionResidence, 'X', remove);
  static const DeIdTags kAdmittingDate =
      DeIdTags(PTag.kAdmittingDate, 'X', remove);
  static const DeIdTags kAdmittingTime =
      DeIdTags(PTag.kAdmittingTime, 'X', remove);
  static const DeIdTags kDischargeDiagnosisDescription =
      DeIdTags(PTag.kDischargeDiagnosisDescription, 'X', remove);
  static const DeIdTags kSpecialNeeds =
      DeIdTags(PTag.kSpecialNeeds, 'X', remove);
  static const DeIdTags kServiceEpisodeID =
      DeIdTags(PTag.kServiceEpisodeID, 'X', remove);
  static const DeIdTags kIssuerOfServiceEpisodeID =
      DeIdTags(PTag.kIssuerOfServiceEpisodeID, 'X', remove);
  static const DeIdTags kServiceEpisodeDescription =
      DeIdTags(PTag.kServiceEpisodeDescription, 'X', remove);
  static const DeIdTags kCurrentPatientLocation =
      DeIdTags(PTag.kCurrentPatientLocation, 'X', remove);
  static const DeIdTags kPatientInstitutionResidence =
      DeIdTags(PTag.kPatientInstitutionResidence, 'X', remove);
  static const DeIdTags kPatientState =
      DeIdTags(PTag.kPatientState, 'X', remove);
  static const DeIdTags kVisitComments =
      DeIdTags(PTag.kVisitComments, 'X', remove);
  static const DeIdTags kScheduledStationAETitle =
      DeIdTags(PTag.kScheduledStationAETitle, 'X', remove);
  static const DeIdTags kScheduledProcedureStepStartDate =
      DeIdTags(PTag.kScheduledProcedureStepStartDate, 'X', remove);
  static const DeIdTags kScheduledProcedureStepStartTime =
      DeIdTags(PTag.kScheduledProcedureStepStartTime, 'X', remove);
  static const DeIdTags kScheduledProcedureStepEndDate =
      DeIdTags(PTag.kScheduledProcedureStepEndDate, 'X', remove);
  static const DeIdTags kScheduledProcedureStepEndTime =
      DeIdTags(PTag.kScheduledProcedureStepEndTime, 'X', remove);
  static const DeIdTags kScheduledPerformingPhysicianName =
      DeIdTags(PTag.kScheduledPerformingPhysicianName, 'X', remove);
  static const DeIdTags kScheduledProcedureStepDescription =
      DeIdTags(PTag.kScheduledProcedureStepDescription, 'X', remove);
  static const DeIdTags kScheduledPerformingPhysicianIdentificationSequence =
      DeIdTags(PTag.kScheduledPerformingPhysicianIdentificationSequence, 'X',
          remove);
  static const DeIdTags kScheduledStationName =
      DeIdTags(PTag.kScheduledStationName, 'X', remove);
  static const DeIdTags kScheduledProcedureStepLocation =
      DeIdTags(PTag.kScheduledProcedureStepLocation, 'X', remove);
  static const DeIdTags kPreMedication =
      DeIdTags(PTag.kPreMedication, 'X', remove);
  static const DeIdTags kPerformedStationAETitle =
      DeIdTags(PTag.kPerformedStationAETitle, 'X', remove);
  static const DeIdTags kPerformedStationName =
      DeIdTags(PTag.kPerformedStationName, 'X', remove);
  static const DeIdTags kPerformedLocation =
      DeIdTags(PTag.kPerformedLocation, 'X', remove);
  static const DeIdTags kPerformedProcedureStepStartDate =
      DeIdTags(PTag.kPerformedProcedureStepStartDate, 'X', remove);
  static const DeIdTags kPerformedProcedureStepStartTime =
      DeIdTags(PTag.kPerformedProcedureStepStartTime, 'X', remove);
  static const DeIdTags kPerformedProcedureStepEndDate =
      DeIdTags(PTag.kPerformedProcedureStepEndDate, 'X', remove);
  static const DeIdTags kPerformedProcedureStepEndTime =
      DeIdTags(PTag.kPerformedProcedureStepEndTime, 'X', remove);
  static const DeIdTags kPerformedProcedureStepID =
      DeIdTags(PTag.kPerformedProcedureStepID, 'X', remove);
  static const DeIdTags kPerformedProcedureStepDescription =
      DeIdTags(PTag.kPerformedProcedureStepDescription, 'X', remove);
  static const DeIdTags kRequestAttributesSequence =
      DeIdTags(PTag.kRequestAttributesSequence, 'X', remove);
  static const DeIdTags kCommentsOnThePerformedProcedureStep =
      DeIdTags(PTag.kCommentsOnThePerformedProcedureStep, 'X', remove);
  static const DeIdTags kAcquisitionContextSequence =
      DeIdTags(PTag.kAcquisitionContextSequence, 'X', remove);
  static const DeIdTags kRequestedProcedureID =
      DeIdTags(PTag.kRequestedProcedureID, 'X', remove);
  static const DeIdTags kPatientTransportArrangements =
      DeIdTags(PTag.kPatientTransportArrangements, 'X', remove);
  static const DeIdTags kRequestedProcedureLocation =
      DeIdTags(PTag.kRequestedProcedureLocation, 'X', remove);
  static const DeIdTags kNamesOfIntendedRecipientsOfResults =
      DeIdTags(PTag.kNamesOfIntendedRecipientsOfResults, 'X', remove);
  static const DeIdTags kIntendedRecipientsOfResultsIdentificationSequence =
      DeIdTags(
          PTag.kIntendedRecipientsOfResultsIdentificationSequence, 'X', remove);
  static const DeIdTags kPersonIdentificationCodeSequence =
      DeIdTags(PTag.kPersonIdentificationCodeSequence, 'D', replaceWithDummy);
  static const DeIdTags kPersonAddress =
      DeIdTags(PTag.kPersonAddress, 'X', remove);
  static const DeIdTags kPersonTelephoneNumbers =
      DeIdTags(PTag.kPersonTelephoneNumbers, 'X', remove);
  static const DeIdTags kRequestedProcedureComments =
      DeIdTags(PTag.kRequestedProcedureComments, 'X', remove);
  static const DeIdTags kReasonForTheImagingServiceRequest =
      DeIdTags(PTag.kReasonForTheImagingServiceRequest, 'X', remove);
  static const DeIdTags kOrderEnteredBy =
      DeIdTags(PTag.kOrderEnteredBy, 'X', remove);
  static const DeIdTags kOrderEntererLocation =
      DeIdTags(PTag.kOrderEntererLocation, 'X', remove);
  static const DeIdTags kOrderCallbackPhoneNumber =
      DeIdTags(PTag.kOrderCallbackPhoneNumber, 'X', remove);
  static const DeIdTags kPlacerOrderNumberImagingServiceRequest = DeIdTags(
      PTag.kPlacerOrderNumberImagingServiceRequest, 'Z', replaceWithZero);
  static const DeIdTags kFillerOrderNumberImagingServiceRequest = DeIdTags(
      PTag.kFillerOrderNumberImagingServiceRequest, 'Z', replaceWithZero);
  static const DeIdTags kImagingServiceRequestComments =
      DeIdTags(PTag.kImagingServiceRequestComments, 'X', remove);
  static const DeIdTags kConfidentialityConstraintOnPatientDataDescription =
      DeIdTags(
          PTag.kConfidentialityConstraintOnPatientDataDescription, 'X', remove);
  static const DeIdTags
      kReferencedGeneralPurposeScheduledProcedureStepTransactionUID = DeIdTags(
          PTag.kReferencedGeneralPurposeScheduledProcedureStepTransactionUID,
          'U',
          replaceUids);
  static const DeIdTags kScheduledStationNameCodeSequence =
      DeIdTags(PTag.kScheduledStationNameCodeSequence, 'X', remove);
  static const DeIdTags kScheduledStationGeographicLocationCodeSequence =
      DeIdTags(
          PTag.kScheduledStationGeographicLocationCodeSequence, 'X', remove);
  static const DeIdTags kPerformedStationNameCodeSequence =
      DeIdTags(PTag.kPerformedStationNameCodeSequence, 'X', remove);
  static const DeIdTags kPerformedStationGeographicLocationCodeSequence =
      DeIdTags(
          PTag.kPerformedStationGeographicLocationCodeSequence, 'X', remove);
  static const DeIdTags kScheduledHumanPerformersSequence =
      DeIdTags(PTag.kScheduledHumanPerformersSequence, 'X', remove);
  static const DeIdTags kActualHumanPerformersSequence =
      DeIdTags(PTag.kActualHumanPerformersSequence, 'X', remove);
  static const DeIdTags kHumanPerformerOrganization =
      DeIdTags(PTag.kHumanPerformerOrganization, 'X', remove);
  static const DeIdTags kHumanPerformerName =
      DeIdTags(PTag.kHumanPerformerName, 'X', remove);
  static const DeIdTags kVerifyingOrganization =
      DeIdTags(PTag.kVerifyingOrganization, 'X', remove);
  static const DeIdTags kVerifyingObserverSequence =
      DeIdTags(PTag.kVerifyingObserverSequence, 'D', replaceWithDummy);
  static const DeIdTags kVerifyingObserverName =
      DeIdTags(PTag.kVerifyingObserverName, 'D', replaceWithDummy);
  static const DeIdTags kAuthorObserverSequence =
      DeIdTags(PTag.kAuthorObserverSequence, 'X', remove);
  static const DeIdTags kParticipantSequence =
      DeIdTags(PTag.kParticipantSequence, 'X', remove);
  static const DeIdTags kCustodialOrganizationSequence =
      DeIdTags(PTag.kCustodialOrganizationSequence, 'X', remove);
  static const DeIdTags kVerifyingObserverIdentificationCodeSequence = DeIdTags(
      PTag.kVerifyingObserverIdentificationCodeSequence, 'Z', replaceWithZero);
  static const DeIdTags kPersonName =
      DeIdTags(PTag.kPersonName, 'D', replaceWithDummy);
  static const DeIdTags kUID = DeIdTags(PTag.kUID, 'U', replaceUids);
  static const DeIdTags kContentSequence =
      DeIdTags(PTag.kContentSequence, 'X', remove);
  static const DeIdTags kTemplateExtensionOrganizationUID =
      DeIdTags(PTag.kTemplateExtensionOrganizationUID, 'U', replaceUids);
  static const DeIdTags kTemplateExtensionCreatorUID =
      DeIdTags(PTag.kTemplateExtensionCreatorUID, 'U', replaceUids);
  static const DeIdTags kGraphicAnnotationSequence =
      DeIdTags(PTag.kGraphicAnnotationSequence, 'D', replaceWithDummy);
  static const DeIdTags kContentCreatorName =
      DeIdTags(PTag.kContentCreatorName, 'Z', replaceWithZero);
  static const DeIdTags kContentCreatorIdentificationCodeSequence =
      DeIdTags(PTag.kContentCreatorIdentificationCodeSequence, 'X', remove);
  static const DeIdTags kFiducialUID =
      DeIdTags(PTag.kFiducialUID, 'U', replaceUids);
  static const DeIdTags kStorageMediaFileSetUID =
      DeIdTags(PTag.kStorageMediaFileSetUID, 'U', replaceUids);
  static const DeIdTags kIconImageSequence =
      DeIdTags(PTag.kIconImageSequence, 'X', remove);
  static const DeIdTags kTopicTitle = DeIdTags(PTag.kTopicTitle, 'X', remove);
  static const DeIdTags kTopicSubject =
      DeIdTags(PTag.kTopicSubject, 'X', remove);
  static const DeIdTags kTopicAuthor = DeIdTags(PTag.kTopicAuthor, 'X', remove);
  static const DeIdTags kTopicKeywords =
      DeIdTags(PTag.kTopicKeywords, 'X', remove);
  static const DeIdTags kDigitalSignatureUID =
      DeIdTags(PTag.kDigitalSignatureUID, 'X', remove);
  static const DeIdTags kReferencedDigitalSignatureSequence =
      DeIdTags(PTag.kReferencedDigitalSignatureSequence, 'X', remove);
  static const DeIdTags kReferencedSOPInstanceMACSequence =
      DeIdTags(PTag.kReferencedSOPInstanceMACSequence, 'X', remove);
  static const DeIdTags kMAC = DeIdTags(PTag.kMAC, 'X', remove);
  static const DeIdTags kModifiedAttributesSequence =
      DeIdTags(PTag.kModifiedAttributesSequence, 'X', remove);
  static const DeIdTags kOriginalAttributesSequence =
      DeIdTags(PTag.kOriginalAttributesSequence, 'X', remove);
  static const DeIdTags kTextString = DeIdTags(PTag.kTextString, 'X', remove);
  static const DeIdTags kReferencedFrameOfReferenceUID =
      DeIdTags(PTag.kReferencedFrameOfReferenceUID, 'U', replaceUids);
  static const DeIdTags kRelatedFrameOfReferenceUID =
      DeIdTags(PTag.kRelatedFrameOfReferenceUID, 'U', replaceUids);
  static const DeIdTags kDoseReferenceUID =
      DeIdTags(PTag.kDoseReferenceUID, 'U', replaceUids);
  static const DeIdTags kReviewerName =
      DeIdTags(PTag.kReviewerName, 'XD', removeUnlessZero);
  static const DeIdTags kArbitrary = DeIdTags(PTag.kArbitrary, 'X', remove);
  static const DeIdTags kTextComments =
      DeIdTags(PTag.kTextComments, 'X', remove);
  static const DeIdTags kResultsIDIssuer =
      DeIdTags(PTag.kResultsIDIssuer, 'X', remove);
  static const DeIdTags kInterpretationRecorder =
      DeIdTags(PTag.kInterpretationRecorder, 'X', remove);
  static const DeIdTags kInterpretationTranscriber =
      DeIdTags(PTag.kInterpretationTranscriber, 'X', remove);
  static const DeIdTags kInterpretationText =
      DeIdTags(PTag.kInterpretationText, 'X', remove);
  static const DeIdTags kInterpretationAuthor =
      DeIdTags(PTag.kInterpretationAuthor, 'X', remove);
  static const DeIdTags kInterpretationApproverSequence =
      DeIdTags(PTag.kInterpretationApproverSequence, 'X', remove);
  static const DeIdTags kPhysicianApprovingInterpretation =
      DeIdTags(PTag.kPhysicianApprovingInterpretation, 'X', remove);
  static const DeIdTags kInterpretationDiagnosisDescription =
      DeIdTags(PTag.kInterpretationDiagnosisDescription, 'X', remove);
  static const DeIdTags kResultsDistributionListSequence =
      DeIdTags(PTag.kResultsDistributionListSequence, 'X', remove);
  static const DeIdTags kDistributionName =
      DeIdTags(PTag.kDistributionName, 'X', remove);
  static const DeIdTags kDistributionAddress =
      DeIdTags(PTag.kDistributionAddress, 'X', remove);
  static const DeIdTags kInterpretationIDIssuer =
      DeIdTags(PTag.kInterpretationIDIssuer, 'X', remove);
  static const DeIdTags kImpressions = DeIdTags(PTag.kImpressions, 'X', remove);
  static const DeIdTags kResultsComments =
      DeIdTags(PTag.kResultsComments, 'X', remove);
  static const DeIdTags kDigitalSignaturesSequence =
      DeIdTags(PTag.kDigitalSignaturesSequence, 'X', remove);
  static const DeIdTags kDataSetTrailingPadding =
      DeIdTags(PTag.kDataSetTrailingPadding, 'X', remove);

  static const List<int> retainList = <int>[];

  static const List<int> removeCodes = <int>[
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

  static const Map<int, DeIdTags> map = <int, DeIdTags>{
    0x00001000: kAffectedSOPInstanceUID,
    0x00001001: kRequestedSOPInstanceUID,
    0x00020003: kMediaStorageSOPInstanceUID,
    0x00041511: kReferencedSOPInstanceUIDInFile,
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
    0x00080090: kReferringPhysicianName,
    0x00080092: kReferringPhysicianAddress,
    0x00080094: kReferringPhysicianTelephoneNumbers,
    0x00080096: kReferringPhysicianIdentificationSequence,
    0x0008010d: kContextGroupExtensionCreatorUID,
    0x00080201: kTimezoneOffsetFromUTC,
    0x00081010: kStationName,
    0x00081030: kStudyDescription,
    0x0008103e: kSeriesDescription,
    0x00081040: kInstitutionalDepartmentName,
    0x00081048: kPhysicianOfRecord,
    0x00081049: kPhysiciansOfRecordIdentificationSequence,
    0x00081050: kPerformingPhysicianName,
    0x00081052: kPerformingPhysicianIdentificationSequence,
    0x00081060: kNameOfPhysiciansReadingStudy,
    0x00081062: kPhysiciansReadingStudyIdentificationSequence,
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
    0x00100010: kPatientName,
    0x00100020: kPatientID,
    0x00100021: kIssuerOfPatientID,
    0x00100030: kPatientBirthDate,
    0x00100032: kPatientBirthTime,
    0x00100040: kPatientSex,
    0x00100050: kPatientInsurancePlanCodeSequence,
    0x00100101: kPatientPrimaryLanguageCodeSequence,
    0x00100102: kPatientPrimaryLanguageModifierCodeSequence,
    0x00101000: kOtherPatientIDs,
    0x00101001: kOtherPatientNames,
    0x00101002: kOtherPatientIDsSequence,
    0x00101005: kPatientBirthName,
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
    0x00403001: kConfidentialityConstraintOnPatientDataDescription,
    0x00404023: kReferencedGeneralPurposeScheduledProcedureStepTransactionUID,
    0x00404025: kScheduledStationNameCodeSequence,
    0x00404027: kScheduledStationGeographicLocationCodeSequence,
    0x00404028: kPerformedStationNameCodeSequence,
    0x00404030: kPerformedStationGeographicLocationCodeSequence,
    0x00404034: kScheduledHumanPerformersSequence,
    0x00404035: kActualHumanPerformersSequence,
    0x00404036: kHumanPerformerOrganization,
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

  static const List<DeIdTags> deIdTags = <DeIdTags>[
    kAffectedSOPInstanceUID,
    kRequestedSOPInstanceUID,
    kMediaStorageSOPInstanceUID,
    kReferencedSOPInstanceUIDInFile,
    kInstanceCreatorUID,
    kSOPInstanceUID,
    kStudyDate,
    kSeriesDate,
    kAcquisitionDate,
    kContentDate,
    kOverlayDate,
    kCurveDate,
    kAcquisitionDateTime,
    kStudyTime,
    kSeriesTime,
    kAcquisitionTime,
    kContentTime,
    kOverlayTime,
    kCurveTime,
    kAccessionNumber,
    kFailedSOPInstanceUIDList,
    kInstitutionName,
    kInstitutionAddress,
    kInstitutionCodeSequence,
    kReferringPhysicianName,
    kReferringPhysicianAddress,
    kReferringPhysicianTelephoneNumbers,
    kReferringPhysicianIdentificationSequence,
    kContextGroupExtensionCreatorUID,
    kTimezoneOffsetFromUTC,
    kStationName,
    kStudyDescription,
    kSeriesDescription,
    kInstitutionalDepartmentName,
    kPhysicianOfRecord,
    kPhysiciansOfRecordIdentificationSequence,
    kPerformingPhysicianName,
    kPerformingPhysicianIdentificationSequence,
    kNameOfPhysiciansReadingStudy,
    kPhysiciansReadingStudyIdentificationSequence,
    kOperatorsName,
    kOperatorsIdentificationSequence,
    kAdmittingDiagnosesDescription,
    kAdmittingDiagnosesCodeSequence,
    kReferencedStudySequence,
    kReferencedPerformedProcedureStepSequence,
    kReferencedPatientSequence,
    kReferencedImageSequence,
    kReferencedSOPInstanceUID,
    kTransactionUID,
    kDerivationDescription,
    kSourceImageSequence,
    kIrradiationEventUID,
    kIdentifyingComments,
    kCreatorVersionUID,
    kPatientName,
    kPatientID,
    kIssuerOfPatientID,
    kPatientBirthDate,
    kPatientBirthTime,
    kPatientSex,
    kPatientInsurancePlanCodeSequence,
    kPatientPrimaryLanguageCodeSequence,
    kPatientPrimaryLanguageModifierCodeSequence,
    kOtherPatientIDs,
    kOtherPatientNames,
    kOtherPatientIDsSequence,
    kPatientBirthName,
    kPatientAge,
    kPatientSize,
    kPatientWeight,
    kPatientAddress,
    kInsurancePlanIdentification,
    kPatientMotherBirthName,
    kMilitaryRank,
    kBranchOfService,
    kMedicalRecordLocator,
    kMedicalAlerts,
    kAllergies,
    kCountryOfResidence,
    kRegionOfResidence,
    kPatientTelephoneNumbers,
    kEthnicGroup,
    kOccupation,
    kSmokingStatus,
    kAdditionalPatientHistory,
    kPregnancyStatus,
    kLastMenstrualDate,
    kPatientReligiousPreference,
    kPatientSexNeutered,
    kResponsiblePerson,
    kResponsibleOrganization,
    kPatientComments,
    kContrastBolusAgent,
    kDeviceSerialNumber,
    kDeviceUID,
    kPlateID,
    kGeneratorID,
    kCassetteID,
    kGantryID,
    kProtocolName,
    kAcquisitionDeviceProcessingDescription,
    kAcquisitionComments,
    kDetectorID,
    kAcquisitionProtocolDescription,
    kContributionDescription,
    kStudyInstanceUID,
    kSeriesInstanceUID,
    kStudyID,
    kFrameOfReferenceUID,
    kSynchronizationFrameOfReferenceUID,
    kModifyingDeviceID,
    kModifyingDeviceManufacturer,
    kModifiedImageDescription,
    kImageComments,
    kFrameComments,
    kConcatenationUID,
    kDimensionOrganizationUID,
    kPaletteColorLookupTableUID,
    kLargePaletteColorLookupTableUID,
    kImagePresentationComments,
    kStudyIDIssuer,
    kScheduledStudyLocation,
    kScheduledStudyLocationAETitle,
    kReasonForStudy,
    kRequestingPhysician,
    kRequestingService,
    kRequestedProcedureDescription,
    kRequestedContrastAgent,
    kStudyComments,
    kReferencedPatientAliasSequence,
    kAdmissionID,
    kIssuerOfAdmissionID,
    kScheduledPatientInstitutionResidence,
    kAdmittingDate,
    kAdmittingTime,
    kDischargeDiagnosisDescription,
    kSpecialNeeds,
    kServiceEpisodeID,
    kIssuerOfServiceEpisodeID,
    kServiceEpisodeDescription,
    kCurrentPatientLocation,
    kPatientInstitutionResidence,
    kPatientState,
    kVisitComments,
    kScheduledStationAETitle,
    kScheduledProcedureStepStartDate,
    kScheduledProcedureStepStartTime,
    kScheduledProcedureStepEndDate,
    kScheduledProcedureStepEndTime,
    kScheduledPerformingPhysicianName,
    kScheduledProcedureStepDescription,
    kScheduledPerformingPhysicianIdentificationSequence,
    kScheduledStationName,
    kScheduledProcedureStepLocation,
    kPreMedication,
    kPerformedStationAETitle,
    kPerformedStationName,
    kPerformedLocation,
    kPerformedProcedureStepStartDate,
    kPerformedProcedureStepStartTime,
    kPerformedProcedureStepEndDate,
    kPerformedProcedureStepEndTime,
    kPerformedProcedureStepID,
    kPerformedProcedureStepDescription,
    kRequestAttributesSequence,
    kCommentsOnThePerformedProcedureStep,
    kAcquisitionContextSequence,
    kRequestedProcedureID,
    kPatientTransportArrangements,
    kRequestedProcedureLocation,
    kNamesOfIntendedRecipientsOfResults,
    kIntendedRecipientsOfResultsIdentificationSequence,
    kPersonIdentificationCodeSequence,
    kPersonAddress,
    kPersonTelephoneNumbers,
    kRequestedProcedureComments,
    kReasonForTheImagingServiceRequest,
    kOrderEnteredBy,
    kOrderEntererLocation,
    kOrderCallbackPhoneNumber,
    kPlacerOrderNumberImagingServiceRequest,
    kFillerOrderNumberImagingServiceRequest,
    kImagingServiceRequestComments,
    kConfidentialityConstraintOnPatientDataDescription,
    kReferencedGeneralPurposeScheduledProcedureStepTransactionUID,
    kScheduledStationNameCodeSequence,
    kScheduledStationGeographicLocationCodeSequence,
    kPerformedStationNameCodeSequence,
    kPerformedStationGeographicLocationCodeSequence,
    kScheduledHumanPerformersSequence,
    kActualHumanPerformersSequence,
    kHumanPerformerOrganization,
    kHumanPerformerName,
    kVerifyingOrganization,
    kVerifyingObserverSequence,
    kVerifyingObserverName,
    kAuthorObserverSequence,
    kParticipantSequence,
    kCustodialOrganizationSequence,
    kVerifyingObserverIdentificationCodeSequence,
    kPersonName,
    kUID,
    kContentSequence,
    kTemplateExtensionOrganizationUID,
    kTemplateExtensionCreatorUID,
    kGraphicAnnotationSequence,
    kContentCreatorName,
    kContentCreatorIdentificationCodeSequence,
    kFiducialUID,
    kStorageMediaFileSetUID,
    kIconImageSequence,
    kTopicTitle,
    kTopicSubject,
    kTopicAuthor,
    kTopicKeywords,
    kDigitalSignatureUID,
    kReferencedDigitalSignatureSequence,
    kReferencedSOPInstanceMACSequence,
    kMAC,
    kModifiedAttributesSequence,
    kOriginalAttributesSequence,
    kTextString,
    kReferencedFrameOfReferenceUID,
    kRelatedFrameOfReferenceUID,
    kDoseReferenceUID,
    kReviewerName,
    kArbitrary,
    kTextComments,
    kResultsIDIssuer,
    kInterpretationRecorder,
    kInterpretationTranscriber,
    kInterpretationText,
    kInterpretationAuthor,
    kInterpretationApproverSequence,
    kPhysicianApprovingInterpretation,
    kInterpretationDiagnosisDescription,
    kResultsDistributionListSequence,
    kDistributionName,
    kDistributionAddress,
    kInterpretationIDIssuer,
    kImpressions,
    kResultsComments,
    kDigitalSignaturesSequence,
    kDataSetTrailingPadding,
  ];

  static const List<int> codes = <int>[
    // No reformat
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
