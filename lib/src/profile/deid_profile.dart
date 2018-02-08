// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/sequence.dart';
import 'package:core/src/tag/errors.dart';
import 'package:core/src/tag/p_tag.dart';
import 'package:core/src/tag/tag.dart';
import 'package:core/src/uid/uid.dart';

/// Basic De-Identification Profile.
class DeIdProfile {
  final Tag tag;
  final String name;
  final Function action;

  const DeIdProfile(this.tag, this.name, this.action);

  @override
  String toString() => 'Basic Profile: $tag';

  static bool _isEmpty<V>(Iterable<V> values, bool emptyAllowed) =>
      values == const <V>[] || emptyAllowed;

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
      ds.update(tag.code, values, required: required);

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
  static Iterable<String> replaceUids(Dataset ds, Tag tag, Iterable<Uid> values,
          {bool required = false}) =>
      ds.replaceUid(tag.code, values);

  /// ZD: Z unless D is required to maintain
  /// IOD conformance (Type 2 versus Type 1)';
  static Element zeroUnlessDummy<V>(Dataset ds, Tag tag, List<V> values,
      {bool required = false}) {
    if (_isEmpty(values, true))
      return ds.noValues(tag.code, required: required);
    return ds.update(tag.code, values);
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
    if (ds.lookup(tag.code) is! SQ)
      throw new InvalidTagError(
          'Invalid Tag(${ds.lookup(tag.code)}) for this action');
    if (_isEmpty(values, true)) return ds.noValues(tag.code);
    return ds.update<V>(tag.code, values);
  }

  static Element addIfMissing<V>(Dataset ds, Tag tag, List<V> values,
      {bool required = false}) {
    final e = ds.lookup(tag.code);
    if (e is! SQ) throw new InvalidTagError('Invalid Tag ($e) for this action');
    if (_isEmpty(values, true))
      return ds.noValues(tag.code, required: required);
    return ds.update(tag.code, values);
  }

  static Element invalid<V>(Dataset ds, Tag tag, List<V> values,
          {bool required = false}) =>
      throw new UnsupportedError('Invalid Action');

  static DeIdProfile lookup(int tag) => map[tag];

  static const DeIdProfile kAffectedSOPInstanceUID =
      const DeIdProfile(PTag.kAffectedSOPInstanceUID, 'X', remove);
  static const DeIdProfile kRequestedSOPInstanceUID =
      const DeIdProfile(PTag.kRequestedSOPInstanceUID, 'U', replaceUids);
  static const DeIdProfile kMediaStorageSOPInstanceUID =
      const DeIdProfile(PTag.kMediaStorageSOPInstanceUID, 'U', replaceUids);
  static const DeIdProfile kReferencedSOPInstanceUIDinFile =
      const DeIdProfile(
          PTag.kReferencedSOPInstanceUIDInFile, 'U', replaceUids);
  static const DeIdProfile kInstanceCreatorUID =
      const DeIdProfile(PTag.kInstanceCreatorUID, 'U', replaceUids);
  static const DeIdProfile kSOPInstanceUID =
      const DeIdProfile(PTag.kSOPInstanceUID, 'U', replaceUids);
  static const DeIdProfile kStudyDate =
      const DeIdProfile(PTag.kStudyDate, 'Z', replaceWithZero);
  static const DeIdProfile kSeriesDate =
      const DeIdProfile(PTag.kSeriesDate, 'XD', removeUnlessDummy);
  static const DeIdProfile kAcquisitionDate =
      const DeIdProfile(PTag.kAcquisitionDate, 'XD', removeUnlessZero);
  static const DeIdProfile kContentDate =
      const DeIdProfile(PTag.kContentDate, 'XD', removeUnlessDummy);
  static const DeIdProfile kOverlayDate =
      const DeIdProfile(PTag.kOverlayDate, 'X', remove);
  static const DeIdProfile kCurveDate =
      const DeIdProfile(PTag.kCurveDate, 'X', remove);
  static const DeIdProfile kAcquisitionDateTime =
      const DeIdProfile(PTag.kAcquisitionDateTime, 'XD', removeUnlessDummy);
  static const DeIdProfile kStudyTime =
      const DeIdProfile(PTag.kStudyTime, 'Z', replaceWithZero);
  static const DeIdProfile kSeriesTime =
      const DeIdProfile(PTag.kSeriesTime, 'XD', removeUnlessDummy);
  static const DeIdProfile kAcquisitionTime =
      const DeIdProfile(PTag.kAcquisitionTime, 'XD', removeUnlessZero);
  static const DeIdProfile kContentTime =
      const DeIdProfile(PTag.kContentTime, 'XD', removeUnlessDummy);
  static const DeIdProfile kOverlayTime =
      const DeIdProfile(PTag.kOverlayTime, 'X', remove);
  static const DeIdProfile kCurveTime =
      const DeIdProfile(PTag.kCurveTime, 'X', remove);
  static const DeIdProfile kAccessionNumber =
      const DeIdProfile(PTag.kAccessionNumber, 'Z', replaceWithZero);
  static const DeIdProfile kFailedSOPInstanceUIDList =
      const DeIdProfile(PTag.kFailedSOPInstanceUIDList, 'U', replaceUids);
  static const DeIdProfile kInstitutionName =
      const DeIdProfile(PTag.kInstitutionName, 'XZD', removeUnlessZeroOrDummy);
  static const DeIdProfile kInstitutionAddress =
      const DeIdProfile(PTag.kInstitutionAddress, 'X', remove);
  static const DeIdProfile kInstitutionCodeSequence = const DeIdProfile(
      PTag.kInstitutionCodeSequence, 'XZD', removeUnlessZeroOrDummy);
  static const DeIdProfile kReferringPhysiciansName =
      const DeIdProfile(PTag.kReferringPhysicianName, 'Z', replaceWithZero);
  static const DeIdProfile kReferringPhysiciansAddress =
      const DeIdProfile(PTag.kReferringPhysicianAddress, 'X', remove);
  static const DeIdProfile kReferringPhysiciansTelephoneNumbers =
      const DeIdProfile(PTag.kReferringPhysicianTelephoneNumbers, 'X', remove);
  static const DeIdProfile kReferringPhysiciansIdentificationSequence =
      const DeIdProfile(
          PTag.kReferringPhysicianIdentificationSequence, 'X', remove);
  static const DeIdProfile kContextGroupExtensionCreatorUID =
      const DeIdProfile(
          PTag.kContextGroupExtensionCreatorUID, 'U', replaceUids);
  static const DeIdProfile kTimezoneOffsetFromUTC =
      const DeIdProfile(PTag.kTimezoneOffsetFromUTC, 'X', remove);
  static const DeIdProfile kStationName =
      const DeIdProfile(PTag.kStationName, 'XZD', removeUnlessZeroOrDummy);
  static const DeIdProfile kStudyDescription =
      const DeIdProfile(PTag.kStudyDescription, 'X', remove);
  static const DeIdProfile kSeriesDescription =
      const DeIdProfile(PTag.kSeriesDescription, 'X', remove);
  static const DeIdProfile kInstitutionalDepartmentName =
      const DeIdProfile(PTag.kInstitutionalDepartmentName, 'X', remove);
  static const DeIdProfile kPhysicianOfRecord =
      const DeIdProfile(PTag.kPhysiciansOfRecord, 'X', remove);
  static const DeIdProfile kPhysician0xsofRecordIdentificationSequence =
      const DeIdProfile(
          PTag.kPhysiciansOfRecordIdentificationSequence, 'X', remove);
  static const DeIdProfile kPerformingPhysiciansName =
      const DeIdProfile(PTag.kPerformingPhysicianName, 'X', remove);
  static const DeIdProfile kPerformingPhysicianIdentificationSequence =
      const DeIdProfile(
          PTag.kPerformingPhysicianIdentificationSequence, 'X', remove);
  static const DeIdProfile kNameofPhysician0xsReadingStudy =
      const DeIdProfile(PTag.kNameOfPhysiciansReadingStudy, 'X', remove);
  static const DeIdProfile kPhysician0xsReadingStudyIdentificationSequence =
      const DeIdProfile(
          PTag.kPhysiciansReadingStudyIdentificationSequence, 'X', remove);
  static const DeIdProfile kOperatorsName =
      const DeIdProfile(PTag.kOperatorsName, 'XZD', removeUnlessZeroOrDummy);
  static const DeIdProfile kOperatorsIdentificationSequence =
      const DeIdProfile(
          PTag.kOperatorIdentificationSequence, 'XD', removeUnlessDummy);
  static const DeIdProfile kAdmittingDiagnosesDescription =
      const DeIdProfile(PTag.kAdmittingDiagnosesDescription, 'X', remove);
  static const DeIdProfile kAdmittingDiagnosesCodeSequence =
      const DeIdProfile(PTag.kAdmittingDiagnosesCodeSequence, 'X', remove);
  static const DeIdProfile kReferencedStudySequence =
      const DeIdProfile(PTag.kReferencedStudySequence, 'XD', removeUnlessZero);
  static const DeIdProfile kReferencedPerformedProcedureStepSequence =
      const DeIdProfile(PTag.kReferencedPerformedProcedureStepSequence, 'XZD',
          removeUnlessZeroOrDummy);
  static const DeIdProfile kReferencedPatientSequence =
      const DeIdProfile(PTag.kReferencedPatientSequence, 'X', remove);
  static const DeIdProfile kReferencedImageSequence = const DeIdProfile(
      PTag.kReferencedImageSequence, 'XZU', removeUidUnlessZeroOrDummy);
  static const DeIdProfile kReferencedSOPInstanceUID =
      const DeIdProfile(PTag.kReferencedSOPInstanceUID, 'U', replaceUids);
  static const DeIdProfile kTransactionUID =
      const DeIdProfile(PTag.kTransactionUID, 'U', replaceUids);
  static const DeIdProfile kDerivationDescription =
      const DeIdProfile(PTag.kDerivationDescription, 'X', remove);
  static const DeIdProfile kSourceImageSequence = const DeIdProfile(
      PTag.kSourceImageSequence, 'XZU', removeUidUnlessZeroOrDummy);
  static const DeIdProfile kIrradiationEventUID =
      const DeIdProfile(PTag.kIrradiationEventUID, 'U', replaceUids);
  static const DeIdProfile kIdentifyingComments =
      const DeIdProfile(PTag.kIdentifyingComments, 'X', remove);
  static const DeIdProfile kCreatorVersionUID =
      const DeIdProfile(PTag.kCreatorVersionUID, 'U', replaceUids);
  static const DeIdProfile kPatientsName =
      const DeIdProfile(PTag.kPatientName, 'Z', replaceWithZero);
  static const DeIdProfile kPatientID =
      const DeIdProfile(PTag.kPatientID, 'Z', replaceWithZero);
  static const DeIdProfile kIssuerofPatientID =
      const DeIdProfile(PTag.kIssuerOfPatientID, 'X', remove);
  static const DeIdProfile kPatientsBirthDate =
      const DeIdProfile(PTag.kPatientBirthDate, 'Z', replaceWithZero);
  static const DeIdProfile kPatientsBirthTime =
      const DeIdProfile(PTag.kPatientBirthTime, 'X', remove);
  static const DeIdProfile kPatientsSex =
      const DeIdProfile(PTag.kPatientSex, 'Z', replaceWithZero);
  static const DeIdProfile kPatientsInsurancePlanCodeSequence =
      const DeIdProfile(PTag.kPatientInsurancePlanCodeSequence, 'X', remove);
  static const DeIdProfile kPatientsPrimaryLanguageCodeSequence =
      const DeIdProfile(PTag.kPatientPrimaryLanguageCodeSequence, 'X', remove);
  static const DeIdProfile kPatientsPrimaryLanguageModifierCodeSequence =
      const DeIdProfile(
          PTag.kPatientPrimaryLanguageModifierCodeSequence, 'X', remove);
  static const DeIdProfile kOtherPatientIDs =
      const DeIdProfile(PTag.kOtherPatientIDs, 'X', remove);
  static const DeIdProfile kOtherPatientNames =
      const DeIdProfile(PTag.kOtherPatientNames, 'X', remove);
  static const DeIdProfile kOtherPatientIDsSequence =
      const DeIdProfile(PTag.kOtherPatientIDsSequence, 'X', remove);
  static const DeIdProfile kPatientsBirthName =
      const DeIdProfile(PTag.kPatientBirthName, 'X', remove);
  static const DeIdProfile kPatientAge =
      const DeIdProfile(PTag.kPatientAge, 'X', remove);
  static const DeIdProfile kPatientSize =
      const DeIdProfile(PTag.kPatientSize, 'X', remove);
  static const DeIdProfile kPatientWeight =
      const DeIdProfile(PTag.kPatientWeight, 'X', remove);
  static const DeIdProfile kPatientAddress =
      const DeIdProfile(PTag.kPatientAddress, 'X', remove);
  static const DeIdProfile kInsurancePlanIdentification =
      const DeIdProfile(PTag.kInsurancePlanIdentification, 'X', remove);
  static const DeIdProfile kPatientMotherBirthName =
      const DeIdProfile(PTag.kPatientMotherBirthName, 'X', remove);
  static const DeIdProfile kMilitaryRank =
      const DeIdProfile(PTag.kMilitaryRank, 'X', remove);
  static const DeIdProfile kBranchOfService =
      const DeIdProfile(PTag.kBranchOfService, 'X', remove);
  static const DeIdProfile kMedicalRecordLocator =
      const DeIdProfile(PTag.kMedicalRecordLocator, 'X', remove);
  static const DeIdProfile kMedicalAlerts =
      const DeIdProfile(PTag.kMedicalAlerts, 'X', remove);
  static const DeIdProfile kAllergies =
      const DeIdProfile(PTag.kAllergies, 'X', remove);
  static const DeIdProfile kCountryOfResidence =
      const DeIdProfile(PTag.kCountryOfResidence, 'X', remove);
  static const DeIdProfile kRegionOfResidence =
      const DeIdProfile(PTag.kRegionOfResidence, 'X', remove);
  static const DeIdProfile kPatientTelephoneNumbers =
      const DeIdProfile(PTag.kPatientTelephoneNumbers, 'X', remove);
  static const DeIdProfile kEthnicGroup =
      const DeIdProfile(PTag.kEthnicGroup, 'X', remove);
  static const DeIdProfile kOccupation =
      const DeIdProfile(PTag.kOccupation, 'X', remove);
  static const DeIdProfile kSmokingStatus =
      const DeIdProfile(PTag.kSmokingStatus, 'X', remove);
  static const DeIdProfile kAdditionalPatientHistory =
      const DeIdProfile(PTag.kAdditionalPatientHistory, 'X', remove);
  static const DeIdProfile kPregnancyStatus =
      const DeIdProfile(PTag.kPregnancyStatus, 'X', remove);
  static const DeIdProfile kLastMenstrualDate =
      const DeIdProfile(PTag.kLastMenstrualDate, 'X', remove);
  static const DeIdProfile kPatientReligiousPreference =
      const DeIdProfile(PTag.kPatientReligiousPreference, 'X', remove);
  static const DeIdProfile kPatientSexNeutered =
      const DeIdProfile(PTag.kPatientSexNeutered, 'XD', removeUnlessZero);
  static const DeIdProfile kResponsiblePerson =
      const DeIdProfile(PTag.kResponsiblePerson, 'X', remove);
  static const DeIdProfile kResponsibleOrganization =
      const DeIdProfile(PTag.kResponsibleOrganization, 'X', remove);
  static const DeIdProfile kPatientComments =
      const DeIdProfile(PTag.kPatientComments, 'X', remove);
  static const DeIdProfile kContrastBolusAgent =
      const DeIdProfile(PTag.kContrastBolusAgent, 'XD', removeUnlessDummy);
  static const DeIdProfile kDeviceSerialNumber = const DeIdProfile(
      PTag.kDeviceSerialNumber, 'XZD', removeUnlessZeroOrDummy);
  static const DeIdProfile kDeviceUID =
      const DeIdProfile(PTag.kDeviceUID, 'U', replaceUids);
  static const DeIdProfile kPlateID =
      const DeIdProfile(PTag.kPlateID, 'X', remove);
  static const DeIdProfile kGeneratorID =
      const DeIdProfile(PTag.kGeneratorID, 'X', remove);
  static const DeIdProfile kCassetteID =
      const DeIdProfile(PTag.kCassetteID, 'X', remove);
  static const DeIdProfile kGantryID =
      const DeIdProfile(PTag.kGantryID, 'X', remove);
  static const DeIdProfile kProtocolName =
      const DeIdProfile(PTag.kProtocolName, 'XD', removeUnlessDummy);
  static const DeIdProfile kAcquisitionDeviceProcessingDescription =
      const DeIdProfile(PTag.kAcquisitionDeviceProcessingDescription, 'XD',
          removeUnlessDummy);
  static const DeIdProfile kAcquisitionComments =
      const DeIdProfile(PTag.kAcquisitionComments, 'X', remove);
  static const DeIdProfile kDetectorID =
      const DeIdProfile(PTag.kDetectorID, 'XD', removeUnlessDummy);
  static const DeIdProfile kAcquisitionProtocolDescription =
      const DeIdProfile(PTag.kAcquisitionProtocolDescription, 'X', remove);
  static const DeIdProfile kContributionDescription =
      const DeIdProfile(PTag.kContributionDescription, 'X', remove);
  static const DeIdProfile kStudyInstanceUID =
      const DeIdProfile(PTag.kStudyInstanceUID, 'U', replaceUids);
  static const DeIdProfile kSeriesInstanceUID =
      const DeIdProfile(PTag.kSeriesInstanceUID, 'U', replaceUids);
  static const DeIdProfile kStudyID =
      const DeIdProfile(PTag.kStudyID, 'Z', replaceWithZero);
  static const DeIdProfile kFrameOfReferenceUID =
      const DeIdProfile(PTag.kFrameOfReferenceUID, 'U', replaceUids);
  static const DeIdProfile kSynchronizationFrameOfReferenceUID =
      const DeIdProfile(
          PTag.kSynchronizationFrameOfReferenceUID, 'U', replaceUids);
  static const DeIdProfile kModifyingDeviceID =
      const DeIdProfile(PTag.kModifyingDeviceID, 'X', remove);
  static const DeIdProfile kModifyingDeviceManufacturer =
      const DeIdProfile(PTag.kModifyingDeviceManufacturer, 'X', remove);
  static const DeIdProfile kModifiedImageDescription =
      const DeIdProfile(PTag.kModifiedImageDescription, 'X', remove);
  static const DeIdProfile kImageComments =
      const DeIdProfile(PTag.kImageComments, 'X', remove);
  static const DeIdProfile kFrameComments =
      const DeIdProfile(PTag.kFrameComments, 'X', remove);
  static const DeIdProfile kConcatenationUID =
      const DeIdProfile(PTag.kConcatenationUID, 'U', replaceUids);
  static const DeIdProfile kDimensionOrganizationUID =
      const DeIdProfile(PTag.kDimensionOrganizationUID, 'U', replaceUids);
  static const DeIdProfile kPaletteColorLookupTableUID =
      const DeIdProfile(PTag.kPaletteColorLookupTableUID, 'U', replaceUids);
  static const DeIdProfile kLargePaletteColorLookupTableUID =
      const DeIdProfile(
          PTag.kLargePaletteColorLookupTableUID, 'U', replaceUids);
  static const DeIdProfile kImagePresentationComments =
      const DeIdProfile(PTag.kImagePresentationComments, 'X', remove);
  static const DeIdProfile kStudyIDIssuer =
      const DeIdProfile(PTag.kStudyIDIssuer, 'X', remove);
  static const DeIdProfile kScheduledStudyLocation =
      const DeIdProfile(PTag.kScheduledStudyLocation, 'X', remove);
  static const DeIdProfile kScheduledStudyLocationAETitle =
      const DeIdProfile(PTag.kScheduledStudyLocationAETitle, 'X', remove);
  static const DeIdProfile kReasonForStudy =
      const DeIdProfile(PTag.kReasonForStudy, 'X', remove);
  static const DeIdProfile kRequestingPhysician =
      const DeIdProfile(PTag.kRequestingPhysician, 'X', remove);
  static const DeIdProfile kRequestingService =
      const DeIdProfile(PTag.kRequestingService, 'X', remove);
  static const DeIdProfile kRequestedProcedureDescription = const DeIdProfile(
      PTag.kRequestedProcedureDescription, 'XD', removeUnlessZero);
  static const DeIdProfile kRequestedContrastAgent =
      const DeIdProfile(PTag.kRequestedContrastAgent, 'X', remove);
  static const DeIdProfile kStudyComments =
      const DeIdProfile(PTag.kStudyComments, 'X', remove);
  static const DeIdProfile kReferencedPatientAliasSequence =
      const DeIdProfile(PTag.kReferencedPatientAliasSequence, 'X', remove);
  static const DeIdProfile kAdmissionID =
      const DeIdProfile(PTag.kAdmissionID, 'X', remove);
  static const DeIdProfile kIssuerOfAdmissionID =
      const DeIdProfile(PTag.kIssuerOfAdmissionID, 'X', remove);
  static const DeIdProfile kScheduledPatientInstitutionResidence =
      const DeIdProfile(
          PTag.kScheduledPatientInstitutionResidence, 'X', remove);
  static const DeIdProfile kAdmittingDate =
      const DeIdProfile(PTag.kAdmittingDate, 'X', remove);
  static const DeIdProfile kAdmittingTime =
      const DeIdProfile(PTag.kAdmittingTime, 'X', remove);
  static const DeIdProfile kDischargeDiagnosisDescription =
      const DeIdProfile(PTag.kDischargeDiagnosisDescription, 'X', remove);
  static const DeIdProfile kSpecialNeeds =
      const DeIdProfile(PTag.kSpecialNeeds, 'X', remove);
  static const DeIdProfile kServiceEpisodeID =
      const DeIdProfile(PTag.kServiceEpisodeID, 'X', remove);
  static const DeIdProfile kIssuerOfServiceEpisodeID =
      const DeIdProfile(PTag.kIssuerOfServiceEpisodeID, 'X', remove);
  static const DeIdProfile kServiceEpisodeDescription =
      const DeIdProfile(PTag.kServiceEpisodeDescription, 'X', remove);
  static const DeIdProfile kCurrentPatientLocation =
      const DeIdProfile(PTag.kCurrentPatientLocation, 'X', remove);
  static const DeIdProfile kPatientInstitutionResidence =
      const DeIdProfile(PTag.kPatientInstitutionResidence, 'X', remove);
  static const DeIdProfile kPatientState =
      const DeIdProfile(PTag.kPatientState, 'X', remove);
  static const DeIdProfile kVisitComments =
      const DeIdProfile(PTag.kVisitComments, 'X', remove);
  static const DeIdProfile kScheduledStationAETitle =
      const DeIdProfile(PTag.kScheduledStationAETitle, 'X', remove);
  static const DeIdProfile kScheduledProcedureStepStartDate =
      const DeIdProfile(PTag.kScheduledProcedureStepStartDate, 'X', remove);
  static const DeIdProfile kScheduledProcedureStepStartTime =
      const DeIdProfile(PTag.kScheduledProcedureStepStartTime, 'X', remove);
  static const DeIdProfile kScheduledProcedureStepEndDate =
      const DeIdProfile(PTag.kScheduledProcedureStepEndDate, 'X', remove);
  static const DeIdProfile kScheduledProcedureStepEndTime =
      const DeIdProfile(PTag.kScheduledProcedureStepEndTime, 'X', remove);
  static const DeIdProfile kScheduledPerformingPhysicianName =
      const DeIdProfile(PTag.kScheduledPerformingPhysicianName, 'X', remove);
  static const DeIdProfile kScheduledProcedureStepDescription =
      const DeIdProfile(PTag.kScheduledProcedureStepDescription, 'X', remove);
  static const DeIdProfile
      kScheduledPerformingPhysicianIdentificationSequence = const DeIdProfile(
          PTag.kScheduledPerformingPhysicianIdentificationSequence,
          'X',
          remove);
  static const DeIdProfile kScheduledStationName =
      const DeIdProfile(PTag.kScheduledStationName, 'X', remove);
  static const DeIdProfile kScheduledProcedureStepLocation =
      const DeIdProfile(PTag.kScheduledProcedureStepLocation, 'X', remove);
  static const DeIdProfile kPreMedication =
      const DeIdProfile(PTag.kPreMedication, 'X', remove);
  static const DeIdProfile kPerformedStationAETitle =
      const DeIdProfile(PTag.kPerformedStationAETitle, 'X', remove);
  static const DeIdProfile kPerformedStationName =
      const DeIdProfile(PTag.kPerformedStationName, 'X', remove);
  static const DeIdProfile kPerformedLocation =
      const DeIdProfile(PTag.kPerformedLocation, 'X', remove);
  static const DeIdProfile kPerformedProcedureStepStartDate =
      const DeIdProfile(PTag.kPerformedProcedureStepStartDate, 'X', remove);
  static const DeIdProfile kPerformedProcedureStepStartTime =
      const DeIdProfile(PTag.kPerformedProcedureStepStartTime, 'X', remove);
  static const DeIdProfile kPerformedProcedureStepEndDate =
      const DeIdProfile(PTag.kPerformedProcedureStepEndDate, 'X', remove);
  static const DeIdProfile kPerformedProcedureStepEndTime =
      const DeIdProfile(PTag.kPerformedProcedureStepEndTime, 'X', remove);
  static const DeIdProfile kPerformedProcedureStepID =
      const DeIdProfile(PTag.kPerformedProcedureStepID, 'X', remove);
  static const DeIdProfile kPerformedProcedureStepDescription =
      const DeIdProfile(PTag.kPerformedProcedureStepDescription, 'X', remove);
  static const DeIdProfile kRequestAttributesSequence =
      const DeIdProfile(PTag.kRequestAttributesSequence, 'X', remove);
  static const DeIdProfile kCommentsOnThePerformedProcedureStep =
      const DeIdProfile(
          PTag.kCommentsOnThePerformedProcedureStep, 'X', remove);
  static const DeIdProfile kAcquisitionContextSequence =
      const DeIdProfile(PTag.kAcquisitionContextSequence, 'X', remove);
  static const DeIdProfile kRequestedProcedureID =
      const DeIdProfile(PTag.kRequestedProcedureID, 'X', remove);
  static const DeIdProfile kPatientTransportArrangements =
      const DeIdProfile(PTag.kPatientTransportArrangements, 'X', remove);
  static const DeIdProfile kRequestedProcedureLocation =
      const DeIdProfile(PTag.kRequestedProcedureLocation, 'X', remove);
  static const DeIdProfile kNamesOfIntendedRecipientsOfResults =
      const DeIdProfile(PTag.kNamesOfIntendedRecipientsOfResults, 'X', remove);
  static const DeIdProfile kIntendedRecipientsOfResultsIdentificationSequence =
      const DeIdProfile(
          PTag.kIntendedRecipientsOfResultsIdentificationSequence, 'X', remove);
  static const DeIdProfile kPersonIdentificationCodeSequence =
      const DeIdProfile(
          PTag.kPersonIdentificationCodeSequence, 'D', replaceWithDummy);
  static const DeIdProfile kPersonAddress =
      const DeIdProfile(PTag.kPersonAddress, 'X', remove);
  static const DeIdProfile kPersonTelephoneNumbers =
      const DeIdProfile(PTag.kPersonTelephoneNumbers, 'X', remove);
  static const DeIdProfile kRequestedProcedureComments =
      const DeIdProfile(PTag.kRequestedProcedureComments, 'X', remove);
  static const DeIdProfile kReasonForTheImagingServiceRequest =
      const DeIdProfile(PTag.kReasonForTheImagingServiceRequest, 'X', remove);
  static const DeIdProfile kOrderEnteredBy =
      const DeIdProfile(PTag.kOrderEnteredBy, 'X', remove);
  static const DeIdProfile kOrderEntererLocation =
      const DeIdProfile(PTag.kOrderEntererLocation, 'X', remove);
  static const DeIdProfile kOrderCallbackPhoneNumber =
      const DeIdProfile(PTag.kOrderCallbackPhoneNumber, 'X', remove);
  static const DeIdProfile kPlacerOrderNumberImagingServiceRequest =
      const DeIdProfile(
          PTag.kPlacerOrderNumberImagingServiceRequest, 'Z', replaceWithZero);
  static const DeIdProfile kFillerOrderNumberImagingServiceRequest =
      const DeIdProfile(
          PTag.kFillerOrderNumberImagingServiceRequest, 'Z', replaceWithZero);
  static const DeIdProfile kImagingServiceRequestComments =
      const DeIdProfile(PTag.kImagingServiceRequestComments, 'X', remove);
  static const DeIdProfile kConfidentialityConstraintonPatientDataDescription =
      const DeIdProfile(
          PTag.kConfidentialityConstraintOnPatientDataDescription, 'X', remove);
  static const DeIdProfile
      kReferencedGeneralPurposeScheduledProcedureStepTransactionUID =
      const DeIdProfile(
          PTag.kReferencedGeneralPurposeScheduledProcedureStepTransactionUID,
          'U',
          replaceUids);
  static const DeIdProfile kScheduledStationNameCodeSequence =
      const DeIdProfile(PTag.kScheduledStationNameCodeSequence, 'X', remove);
  static const DeIdProfile kScheduledStationGeographicLocationCodeSequence =
      const DeIdProfile(
          PTag.kScheduledStationGeographicLocationCodeSequence, 'X', remove);
  static const DeIdProfile kPerformedStationNameCodeSequence =
      const DeIdProfile(PTag.kPerformedStationNameCodeSequence, 'X', remove);
  static const DeIdProfile kPerformedStationGeographicLocationCodeSequence =
      const DeIdProfile(
          PTag.kPerformedStationGeographicLocationCodeSequence, 'X', remove);
  static const DeIdProfile kScheduledHumanPerformersSequence =
      const DeIdProfile(PTag.kScheduledHumanPerformersSequence, 'X', remove);
  static const DeIdProfile kActualHumanPerformersSequence =
      const DeIdProfile(PTag.kActualHumanPerformersSequence, 'X', remove);
  static const DeIdProfile kHumanPerformersOrganization =
      const DeIdProfile(PTag.kHumanPerformerOrganization, 'X', remove);
  static const DeIdProfile kHumanPerformerName =
      const DeIdProfile(PTag.kHumanPerformerName, 'X', remove);
  static const DeIdProfile kVerifyingOrganization =
      const DeIdProfile(PTag.kVerifyingOrganization, 'X', remove);
  static const DeIdProfile kVerifyingObserverSequence = const DeIdProfile(
      PTag.kVerifyingObserverSequence, 'D', replaceWithDummy);
  static const DeIdProfile kVerifyingObserverName =
      const DeIdProfile(PTag.kVerifyingObserverName, 'D', replaceWithDummy);
  static const DeIdProfile kAuthorObserverSequence =
      const DeIdProfile(PTag.kAuthorObserverSequence, 'X', remove);
  static const DeIdProfile kParticipantSequence =
      const DeIdProfile(PTag.kParticipantSequence, 'X', remove);
  static const DeIdProfile kCustodialOrganizationSequence =
      const DeIdProfile(PTag.kCustodialOrganizationSequence, 'X', remove);
  static const DeIdProfile kVerifyingObserverIdentificationCodeSequence =
      const DeIdProfile(PTag.kVerifyingObserverIdentificationCodeSequence, 'Z',
          replaceWithZero);
  static const DeIdProfile kPersonName =
      const DeIdProfile(PTag.kPersonName, 'D', replaceWithDummy);
  static const DeIdProfile kUID =
      const DeIdProfile(PTag.kUID, 'U', replaceUids);
  static const DeIdProfile kContentSequence =
      const DeIdProfile(PTag.kContentSequence, 'X', remove);
  static const DeIdProfile kTemplateExtensionOrganizationUID =
      const DeIdProfile(
          PTag.kTemplateExtensionOrganizationUID, 'U', replaceUids);
  static const DeIdProfile kTemplateExtensionCreatorUID =
      const DeIdProfile(PTag.kTemplateExtensionCreatorUID, 'U', replaceUids);
  static const DeIdProfile kGraphicAnnotationSequence = const DeIdProfile(
      PTag.kGraphicAnnotationSequence, 'D', replaceWithDummy);
  static const DeIdProfile kContentCreatorName =
      const DeIdProfile(PTag.kContentCreatorName, 'Z', replaceWithZero);
  static const DeIdProfile kContentCreatorIdentificationCodeSequence =
      const DeIdProfile(
          PTag.kContentCreatorIdentificationCodeSequence, 'X', remove);
  static const DeIdProfile kFiducialUID =
      const DeIdProfile(PTag.kFiducialUID, 'U', replaceUids);
  static const DeIdProfile kStorageMediaFileSetUID =
      const DeIdProfile(PTag.kStorageMediaFileSetUID, 'U', replaceUids);
  static const DeIdProfile kIconImageSequence =
      const DeIdProfile(PTag.kIconImageSequence, 'X', remove);
  static const DeIdProfile kTopicTitle =
      const DeIdProfile(PTag.kTopicTitle, 'X', remove);
  static const DeIdProfile kTopicSubject =
      const DeIdProfile(PTag.kTopicSubject, 'X', remove);
  static const DeIdProfile kTopicAuthor =
      const DeIdProfile(PTag.kTopicAuthor, 'X', remove);
  static const DeIdProfile kTopicKeywords =
      const DeIdProfile(PTag.kTopicKeywords, 'X', remove);
  static const DeIdProfile kDigitalSignatureUID =
      const DeIdProfile(PTag.kDigitalSignatureUID, 'X', remove);
  static const DeIdProfile kReferencedDigitalSignatureSequence =
      const DeIdProfile(PTag.kReferencedDigitalSignatureSequence, 'X', remove);
  static const DeIdProfile kReferencedSOPInstanceMACSequence =
      const DeIdProfile(PTag.kReferencedSOPInstanceMACSequence, 'X', remove);
  static const DeIdProfile kMAC = const DeIdProfile(PTag.kMAC, 'X', remove);
  static const DeIdProfile kModifiedAttributesSequence =
      const DeIdProfile(PTag.kModifiedAttributesSequence, 'X', remove);
  static const DeIdProfile kOriginalAttributesSequence =
      const DeIdProfile(PTag.kOriginalAttributesSequence, 'X', remove);
  static const DeIdProfile kTextString =
      const DeIdProfile(PTag.kTextString, 'X', remove);
  static const DeIdProfile kReferencedFrameOfReferenceUID =
      const DeIdProfile(PTag.kReferencedFrameOfReferenceUID, 'U', replaceUids);
  static const DeIdProfile kRelatedFrameOfReferenceUID =
      const DeIdProfile(PTag.kRelatedFrameOfReferenceUID, 'U', replaceUids);
  static const DeIdProfile kDoseReferenceUID =
      const DeIdProfile(PTag.kDoseReferenceUID, 'U', replaceUids);
  static const DeIdProfile kReviewerName =
      const DeIdProfile(PTag.kReviewerName, 'XD', removeUnlessZero);
  static const DeIdProfile kArbitrary =
      const DeIdProfile(PTag.kArbitrary, 'X', remove);
  static const DeIdProfile kTextComments =
      const DeIdProfile(PTag.kTextComments, 'X', remove);
  static const DeIdProfile kResultsIDIssuer =
      const DeIdProfile(PTag.kResultsIDIssuer, 'X', remove);
  static const DeIdProfile kInterpretationRecorder =
      const DeIdProfile(PTag.kInterpretationRecorder, 'X', remove);
  static const DeIdProfile kInterpretationTranscriber =
      const DeIdProfile(PTag.kInterpretationTranscriber, 'X', remove);
  static const DeIdProfile kInterpretationText =
      const DeIdProfile(PTag.kInterpretationText, 'X', remove);
  static const DeIdProfile kInterpretationAuthor =
      const DeIdProfile(PTag.kInterpretationAuthor, 'X', remove);
  static const DeIdProfile kInterpretationApproverSequence =
      const DeIdProfile(PTag.kInterpretationApproverSequence, 'X', remove);
  static const DeIdProfile kPhysicianApprovingInterpretation =
      const DeIdProfile(PTag.kPhysicianApprovingInterpretation, 'X', remove);
  static const DeIdProfile kInterpretationDiagnosisDescription =
      const DeIdProfile(PTag.kInterpretationDiagnosisDescription, 'X', remove);
  static const DeIdProfile kResultsDistributionListSequence =
      const DeIdProfile(PTag.kResultsDistributionListSequence, 'X', remove);
  static const DeIdProfile kDistributionName =
      const DeIdProfile(PTag.kDistributionName, 'X', remove);
  static const DeIdProfile kDistributionAddress =
      const DeIdProfile(PTag.kDistributionAddress, 'X', remove);
  static const DeIdProfile kInterpretationIDIssuer =
      const DeIdProfile(PTag.kInterpretationIDIssuer, 'X', remove);
  static const DeIdProfile kImpressions =
      const DeIdProfile(PTag.kImpressions, 'X', remove);
  static const DeIdProfile kResultsComments =
      const DeIdProfile(PTag.kResultsComments, 'X', remove);
  static const DeIdProfile kDigitalSignaturesSequence =
      const DeIdProfile(PTag.kDigitalSignaturesSequence, 'X', remove);
  static const DeIdProfile kDataSetTrailingPadding =
      const DeIdProfile(PTag.kDataSetTrailingPadding, 'X', remove);

  static const List<int> retainList = const <int>[];

  static const List<int> removeCodes = const [
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

  static const Map<int, DeIdProfile> map = const <int, DeIdProfile>{
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

  static const List<int> codes = const [
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
