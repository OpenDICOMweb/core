// Copyright (c) 2016, 2017, and 2018 Open DICOMweb Project. 
// All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

import 'package:core/src/tag/constants.dart';
import 'package:core/src/tag/p_tag.dart';

const List<int> deIdNonUidCodes = const <int>[
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
  kInstitutionName,
  kInstitutionAddress,
  kInstitutionCodeSequence,
  kReferringPhysicianName,
  kReferringPhysicianAddress,
  kReferringPhysicianTelephoneNumbers,
  kReferringPhysicianIdentificationSequence,
  kTimezoneOffsetFromUTC,
  kStationName,
  kStudyDescription,
  kSeriesDescription,
  kInstitutionalDepartmentName,
  kPhysiciansOfRecord,
  kPhysiciansOfRecordIdentificationSequence,
  kPerformingPhysicianName,
  kPerformingPhysicianIdentificationSequence,
  kNameOfPhysiciansReadingStudy,
  kPhysiciansReadingStudyIdentificationSequence,
  kOperatorsName,
  kOperatorIdentificationSequence,
  kAdmittingDiagnosesDescription,
  kAdmittingDiagnosesCodeSequence,
  kReferencedStudySequence,
  kReferencedPerformedProcedureStepSequence,
  kReferencedPatientSequence,
  kReferencedImageSequence,
  kDerivationDescription,
  kSourceImageSequence,
  kIdentifyingComments,
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
  kStudyID,
  kModifyingDeviceID,
  kModifyingDeviceManufacturer,
  kModifiedImageDescription,
  kImageComments,
  kFrameComments,
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
  kContentSequence,
  kGraphicAnnotationSequence,
  kContentCreatorName,
  kContentCreatorIdentificationCodeSequence,
  kIconImageSequence,
  kTopicTitle,
  kTopicSubject,
  kTopicAuthor,
  kTopicKeywords,
  kReferencedDigitalSignatureSequence,
  kReferencedSOPInstanceMACSequence,
  kMAC,
  kModifiedAttributesSequence,
  kOriginalAttributesSequence,
  kTextString,
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


const List<PTag> deIdNotUidTags = const <PTag>[
  PTag.kStudyDate,
  PTag.kSeriesDate,
  PTag.kAcquisitionDate,
  PTag.kContentDate,
  PTag.kOverlayDate,
  PTag.kCurveDate,
  PTag.kAcquisitionDateTime,
  PTag.kStudyTime,
  PTag.kSeriesTime,
  PTag.kAcquisitionTime,
  PTag.kContentTime,
  PTag.kOverlayTime,
  PTag.kCurveTime,
  PTag.kAccessionNumber,
  PTag.kInstitutionName,
  PTag.kInstitutionAddress,
  PTag.kInstitutionCodeSequence,
  PTag.kReferringPhysicianName,
  PTag.kReferringPhysicianAddress,
  PTag.kReferringPhysicianTelephoneNumbers,
  PTag.kReferringPhysicianIdentificationSequence,
  PTag.kTimezoneOffsetFromUTC,
  PTag.kStationName,
  PTag.kStudyDescription,
  PTag.kSeriesDescription,
  PTag.kInstitutionalDepartmentName,
  PTag.kPhysiciansOfRecord,
  PTag.kPhysiciansOfRecordIdentificationSequence,
  PTag.kPerformingPhysicianName,
  PTag.kPerformingPhysicianIdentificationSequence,
  PTag.kNameOfPhysiciansReadingStudy,
  PTag.kPhysiciansReadingStudyIdentificationSequence,
  PTag.kOperatorsName,
  PTag.kOperatorIdentificationSequence,
  PTag.kAdmittingDiagnosesDescription,
  PTag.kAdmittingDiagnosesCodeSequence,
  PTag.kReferencedStudySequence,
  PTag.kReferencedPerformedProcedureStepSequence,
  PTag.kReferencedPatientSequence,
  PTag.kReferencedImageSequence,
  PTag.kDerivationDescription,
  PTag.kSourceImageSequence,
  PTag.kIdentifyingComments,
  PTag.kPatientName,
  PTag.kPatientID,
  PTag.kIssuerOfPatientID,
  PTag.kPatientBirthDate,
  PTag.kPatientBirthTime,
  PTag.kPatientSex,
  PTag.kPatientInsurancePlanCodeSequence,
  PTag.kPatientPrimaryLanguageCodeSequence,
  PTag.kPatientPrimaryLanguageModifierCodeSequence,
  PTag.kOtherPatientIDs,
  PTag.kOtherPatientNames,
  PTag.kOtherPatientIDsSequence,
  PTag.kPatientBirthName,
  PTag.kPatientAge,
  PTag.kPatientSize,
  PTag.kPatientWeight,
  PTag.kPatientAddress,
  PTag.kInsurancePlanIdentification,
  PTag.kPatientMotherBirthName,
  PTag.kMilitaryRank,
  PTag.kBranchOfService,
  PTag.kMedicalRecordLocator,
  PTag.kMedicalAlerts,
  PTag.kAllergies,
  PTag.kCountryOfResidence,
  PTag.kRegionOfResidence,
  PTag.kPatientTelephoneNumbers,
  PTag.kEthnicGroup,
  PTag.kOccupation,
  PTag.kSmokingStatus,
  PTag.kAdditionalPatientHistory,
  PTag.kPregnancyStatus,
  PTag.kLastMenstrualDate,
  PTag.kPatientReligiousPreference,
  PTag.kPatientSexNeutered,
  PTag.kResponsiblePerson,
  PTag.kResponsibleOrganization,
  PTag.kPatientComments,
  PTag.kContrastBolusAgent,
  PTag.kDeviceSerialNumber,
  PTag.kPlateID,
  PTag.kGeneratorID,
  PTag.kCassetteID,
  PTag.kGantryID,
  PTag.kProtocolName,
  PTag.kAcquisitionDeviceProcessingDescription,
  PTag.kAcquisitionComments,
  PTag.kDetectorID,
  PTag.kAcquisitionProtocolDescription,
  PTag.kContributionDescription,
  PTag.kStudyID,
  PTag.kModifyingDeviceID,
  PTag.kModifyingDeviceManufacturer,
  PTag.kModifiedImageDescription,
  PTag.kImageComments,
  PTag.kFrameComments,
  PTag.kImagePresentationComments,
  PTag.kStudyIDIssuer,
  PTag.kScheduledStudyLocation,
  PTag.kScheduledStudyLocationAETitle,
  PTag.kReasonForStudy,
  PTag.kRequestingPhysician,
  PTag.kRequestingService,
  PTag.kRequestedProcedureDescription,
  PTag.kRequestedContrastAgent,
  PTag.kStudyComments,
  PTag.kReferencedPatientAliasSequence,
  PTag.kAdmissionID,
  PTag.kIssuerOfAdmissionID,
  PTag.kScheduledPatientInstitutionResidence,
  PTag.kAdmittingDate,
  PTag.kAdmittingTime,
  PTag.kDischargeDiagnosisDescription,
  PTag.kSpecialNeeds,
  PTag.kServiceEpisodeID,
  PTag.kIssuerOfServiceEpisodeID,
  PTag.kServiceEpisodeDescription,
  PTag.kCurrentPatientLocation,
  PTag.kPatientInstitutionResidence,
  PTag.kPatientState,
  PTag.kVisitComments,
  PTag.kScheduledStationAETitle,
  PTag.kScheduledProcedureStepStartDate,
  PTag.kScheduledProcedureStepStartTime,
  PTag.kScheduledProcedureStepEndDate,
  PTag.kScheduledProcedureStepEndTime,
  PTag.kScheduledPerformingPhysicianName,
  PTag.kScheduledProcedureStepDescription,
  PTag.kScheduledPerformingPhysicianIdentificationSequence,
  PTag.kScheduledStationName,
  PTag.kScheduledProcedureStepLocation,
  PTag.kPreMedication,
  PTag.kPerformedStationAETitle,
  PTag.kPerformedStationName,
  PTag.kPerformedLocation,
  PTag.kPerformedProcedureStepStartDate,
  PTag.kPerformedProcedureStepStartTime,
  PTag.kPerformedProcedureStepEndDate,
  PTag.kPerformedProcedureStepEndTime,
  PTag.kPerformedProcedureStepID,
  PTag.kPerformedProcedureStepDescription,
  PTag.kRequestAttributesSequence,
  PTag.kCommentsOnThePerformedProcedureStep,
  PTag.kAcquisitionContextSequence,
  PTag.kRequestedProcedureID,
  PTag.kPatientTransportArrangements,
  PTag.kRequestedProcedureLocation,
  PTag.kNamesOfIntendedRecipientsOfResults,
  PTag.kIntendedRecipientsOfResultsIdentificationSequence,
  PTag.kPersonIdentificationCodeSequence,
  PTag.kPersonAddress,
  PTag.kPersonTelephoneNumbers,
  PTag.kRequestedProcedureComments,
  PTag.kReasonForTheImagingServiceRequest,
  PTag.kOrderEnteredBy,
  PTag.kOrderEntererLocation,
  PTag.kOrderCallbackPhoneNumber,
  PTag.kPlacerOrderNumberImagingServiceRequest,
  PTag.kFillerOrderNumberImagingServiceRequest,
  PTag.kImagingServiceRequestComments,
  PTag.kConfidentialityConstraintOnPatientDataDescription,
  PTag.kScheduledStationNameCodeSequence,
  PTag.kScheduledStationGeographicLocationCodeSequence,
  PTag.kPerformedStationNameCodeSequence,
  PTag.kPerformedStationGeographicLocationCodeSequence,
  PTag.kScheduledHumanPerformersSequence,
  PTag.kActualHumanPerformersSequence,
  PTag.kHumanPerformerOrganization,
  PTag.kHumanPerformerName,
  PTag.kVerifyingOrganization,
  PTag.kVerifyingObserverSequence,
  PTag.kVerifyingObserverName,
  PTag.kAuthorObserverSequence,
  PTag.kParticipantSequence,
  PTag.kCustodialOrganizationSequence,
  PTag.kVerifyingObserverIdentificationCodeSequence,
  PTag.kPersonName,
  PTag.kContentSequence,
  PTag.kGraphicAnnotationSequence,
  PTag.kContentCreatorName,
  PTag.kContentCreatorIdentificationCodeSequence,
  PTag.kIconImageSequence,
  PTag.kTopicTitle,
  PTag.kTopicSubject,
  PTag.kTopicAuthor,
  PTag.kTopicKeywords,
  PTag.kReferencedDigitalSignatureSequence,
  PTag.kReferencedSOPInstanceMACSequence,
  PTag.kMAC,
  PTag.kModifiedAttributesSequence,
  PTag.kOriginalAttributesSequence,
  PTag.kTextString,
  PTag.kReviewerName,
  PTag.kArbitrary,
  PTag.kTextComments,
  PTag.kResultsIDIssuer,
  PTag.kInterpretationRecorder,
  PTag.kInterpretationTranscriber,
  PTag.kInterpretationText,
  PTag.kInterpretationAuthor,
  PTag.kInterpretationApproverSequence,
  PTag.kPhysicianApprovingInterpretation,
  PTag.kInterpretationDiagnosisDescription,
  PTag.kResultsDistributionListSequence,
  PTag.kDistributionName,
  PTag.kDistributionAddress,
  PTag.kInterpretationIDIssuer,
  PTag.kImpressions,
  PTag.kResultsComments,
  PTag.kDigitalSignaturesSequence,
  PTag.kDataSetTrailingPadding,
];


const Map<int, String> deIdNonUidCodeToKeywordMap = const <int, String>{
  0x00080020: 'StudyDate',
  0x00080021: 'SeriesDate',
  0x00080022: 'AcquisitionDate',
  0x00080023: 'ContentDate',
  0x00080024: 'OverlayDate',
  0x00080025: 'CurveDate',
  0x0008002a: 'AcquisitionDateTime',
  0x00080030: 'StudyTime',
  0x00080031: 'SeriesTime',
  0x00080032: 'AcquisitionTime',
  0x00080033: 'ContentTime',
  0x00080034: 'OverlayTime',
  0x00080035: 'CurveTime',
  0x00080050: 'AccessionNumber',
  0x00080080: 'InstitutionName',
  0x00080081: 'InstitutionAddress',
  0x00080082: 'InstitutionCodeSequence',
  0x00080090: 'ReferringPhysicianName',
  0x00080092: 'ReferringPhysicianAddress',
  0x00080094: 'ReferringPhysicianTelephoneNumbers',
  0x00080096: 'ReferringPhysicianIdentificationSequence',
  0x00080201: 'TimezoneOffsetFromUTC',
  0x00081010: 'StationName',
  0x00081030: 'StudyDescription',
  0x0008103e: 'SeriesDescription',
  0x00081040: 'InstitutionalDepartmentName',
  0x00081048: 'PhysiciansOfRecord',
  0x00081049: 'PhysiciansOfRecordIdentificationSequence',
  0x00081050: 'PerformingPhysicianName',
  0x00081052: 'PerformingPhysicianIdentificationSequence',
  0x00081060: 'NameOfPhysiciansReadingStudy',
  0x00081062: 'PhysiciansReadingStudyIdentificationSequence',
  0x00081070: 'OperatorsName',
  0x00081072: 'OperatorIdentificationSequence',
  0x00081080: 'AdmittingDiagnosesDescription',
  0x00081084: 'AdmittingDiagnosesCodeSequence',
  0x00081110: 'ReferencedStudySequence',
  0x00081111: 'ReferencedPerformedProcedureStepSequence',
  0x00081120: 'ReferencedPatientSequence',
  0x00081140: 'ReferencedImageSequence',
  0x00082111: 'DerivationDescription',
  0x00082112: 'SourceImageSequence',
  0x00084000: 'IdentifyingComments',
  0x00100010: 'PatientName',
  0x00100020: 'PatientID',
  0x00100021: 'IssuerOfPatientID',
  0x00100030: 'PatientBirthDate',
  0x00100032: 'PatientBirthTime',
  0x00100040: 'PatientSex',
  0x00100050: 'PatientInsurancePlanCodeSequence',
  0x00100101: 'PatientPrimaryLanguageCodeSequence',
  0x00100102: 'PatientPrimaryLanguageModifierCodeSequence',
  0x00101000: 'OtherPatientIDs',
  0x00101001: 'OtherPatientNames',
  0x00101002: 'OtherPatientIDsSequence',
  0x00101005: 'PatientBirthName',
  0x00101010: 'PatientAge',
  0x00101020: 'PatientSize',
  0x00101030: 'PatientWeight',
  0x00101040: 'PatientAddress',
  0x00101050: 'InsurancePlanIdentification',
  0x00101060: 'PatientMotherBirthName',
  0x00101080: 'MilitaryRank',
  0x00101081: 'BranchOfService',
  0x00101090: 'MedicalRecordLocator',
  0x00102000: 'MedicalAlerts',
  0x00102110: 'Allergies',
  0x00102150: 'CountryOfResidence',
  0x00102152: 'RegionOfResidence',
  0x00102154: 'PatientTelephoneNumbers',
  0x00102160: 'EthnicGroup',
  0x00102180: 'Occupation',
  0x001021a0: 'SmokingStatus',
  0x001021b0: 'AdditionalPatientHistory',
  0x001021c0: 'PregnancyStatus',
  0x001021d0: 'LastMenstrualDate',
  0x001021f0: 'PatientReligiousPreference',
  0x00102203: 'PatientSexNeutered',
  0x00102297: 'ResponsiblePerson',
  0x00102299: 'ResponsibleOrganization',
  0x00104000: 'PatientComments',
  0x00180010: 'ContrastBolusAgent',
  0x00181000: 'DeviceSerialNumber',
  0x00181004: 'PlateID',
  0x00181005: 'GeneratorID',
  0x00181007: 'CassetteID',
  0x00181008: 'GantryID',
  0x00181030: 'ProtocolName',
  0x00181400: 'AcquisitionDeviceProcessingDescription',
  0x00184000: 'AcquisitionComments',
  0x0018700a: 'DetectorID',
  0x00189424: 'AcquisitionProtocolDescription',
  0x0018a003: 'ContributionDescription',
  0x00200010: 'StudyID',
  0x00203401: 'ModifyingDeviceID',
  0x00203404: 'ModifyingDeviceManufacturer',
  0x00203406: 'ModifiedImageDescription',
  0x00204000: 'ImageComments',
  0x00209158: 'FrameComments',
  0x00284000: 'ImagePresentationComments',
  0x00320012: 'StudyIDIssuer',
  0x00321020: 'ScheduledStudyLocation',
  0x00321021: 'ScheduledStudyLocationAETitle',
  0x00321030: 'ReasonForStudy',
  0x00321032: 'RequestingPhysician',
  0x00321033: 'RequestingService',
  0x00321060: 'RequestedProcedureDescription',
  0x00321070: 'RequestedContrastAgent',
  0x00324000: 'StudyComments',
  0x00380004: 'ReferencedPatientAliasSequence',
  0x00380010: 'AdmissionID',
  0x00380011: 'IssuerOfAdmissionID',
  0x0038001e: 'ScheduledPatientInstitutionResidence',
  0x00380020: 'AdmittingDate',
  0x00380021: 'AdmittingTime',
  0x00380040: 'DischargeDiagnosisDescription',
  0x00380050: 'SpecialNeeds',
  0x00380060: 'ServiceEpisodeID',
  0x00380061: 'IssuerOfServiceEpisodeID',
  0x00380062: 'ServiceEpisodeDescription',
  0x00380300: 'CurrentPatientLocation',
  0x00380400: 'PatientInstitutionResidence',
  0x00380500: 'PatientState',
  0x00384000: 'VisitComments',
  0x00400001: 'ScheduledStationAETitle',
  0x00400002: 'ScheduledProcedureStepStartDate',
  0x00400003: 'ScheduledProcedureStepStartTime',
  0x00400004: 'ScheduledProcedureStepEndDate',
  0x00400005: 'ScheduledProcedureStepEndTime',
  0x00400006: 'ScheduledPerformingPhysicianName',
  0x00400007: 'ScheduledProcedureStepDescription',
  0x0040000b: 'ScheduledPerformingPhysicianIdentificationSequence',
  0x00400010: 'ScheduledStationName',
  0x00400011: 'ScheduledProcedureStepLocation',
  0x00400012: 'PreMedication',
  0x00400241: 'PerformedStationAETitle',
  0x00400242: 'PerformedStationName',
  0x00400243: 'PerformedLocation',
  0x00400244: 'PerformedProcedureStepStartDate',
  0x00400245: 'PerformedProcedureStepStartTime',
  0x00400250: 'PerformedProcedureStepEndDate',
  0x00400251: 'PerformedProcedureStepEndTime',
  0x00400253: 'PerformedProcedureStepID',
  0x00400254: 'PerformedProcedureStepDescription',
  0x00400275: 'RequestAttributesSequence',
  0x00400280: 'CommentsOnThePerformedProcedureStep',
  0x00400555: 'AcquisitionContextSequence',
  0x00401001: 'RequestedProcedureID',
  0x00401004: 'PatientTransportArrangements',
  0x00401005: 'RequestedProcedureLocation',
  0x00401010: 'NamesOfIntendedRecipientsOfResults',
  0x00401011: 'IntendedRecipientsOfResultsIdentificationSequence',
  0x00401101: 'PersonIdentificationCodeSequence',
  0x00401102: 'PersonAddress',
  0x00401103: 'PersonTelephoneNumbers',
  0x00401400: 'RequestedProcedureComments',
  0x00402001: 'ReasonForTheImagingServiceRequest',
  0x00402008: 'OrderEnteredBy',
  0x00402009: 'OrderEntererLocation',
  0x00402010: 'OrderCallbackPhoneNumber',
  0x00402016: 'PlacerOrderNumberImagingServiceRequest',
  0x00402017: 'FillerOrderNumberImagingServiceRequest',
  0x00402400: 'ImagingServiceRequestComments',
  0x00403001: 'ConfidentialityConstraintOnPatientDataDescription',
  0x00404025: 'ScheduledStationNameCodeSequence',
  0x00404027: 'ScheduledStationGeographicLocationCodeSequence',
  0x00404028: 'PerformedStationNameCodeSequence',
  0x00404030: 'PerformedStationGeographicLocationCodeSequence',
  0x00404034: 'ScheduledHumanPerformersSequence',
  0x00404035: 'ActualHumanPerformersSequence',
  0x00404036: 'HumanPerformerOrganization',
  0x00404037: 'HumanPerformerName',
  0x0040a027: 'VerifyingOrganization',
  0x0040a073: 'VerifyingObserverSequence',
  0x0040a075: 'VerifyingObserverName',
  0x0040a078: 'AuthorObserverSequence',
  0x0040a07a: 'ParticipantSequence',
  0x0040a07c: 'CustodialOrganizationSequence',
  0x0040a088: 'VerifyingObserverIdentificationCodeSequence',
  0x0040a123: 'PersonName',
  0x0040a730: 'ContentSequence',
  0x00700001: 'GraphicAnnotationSequence',
  0x00700084: 'ContentCreatorName',
  0x00700086: 'ContentCreatorIdentificationCodeSequence',
  0x00880200: 'IconImageSequence',
  0x00880904: 'TopicTitle',
  0x00880906: 'TopicSubject',
  0x00880910: 'TopicAuthor',
  0x00880912: 'TopicKeywords',
  0x04000402: 'ReferencedDigitalSignatureSequence',
  0x04000403: 'ReferencedSOPInstanceMACSequence',
  0x04000404: 'MAC',
  0x04000550: 'ModifiedAttributesSequence',
  0x04000561: 'OriginalAttributesSequence',
  0x20300020: 'TextString',
  0x300e0008: 'ReviewerName',
  0x40000010: 'Arbitrary',
  0x40004000: 'TextComments',
  0x40080042: 'ResultsIDIssuer',
  0x40080102: 'InterpretationRecorder',
  0x4008010a: 'InterpretationTranscriber',
  0x4008010b: 'InterpretationText',
  0x4008010c: 'InterpretationAuthor',
  0x40080111: 'InterpretationApproverSequence',
  0x40080114: 'PhysicianApprovingInterpretation',
  0x40080115: 'InterpretationDiagnosisDescription',
  0x40080118: 'ResultsDistributionListSequence',
  0x40080119: 'DistributionName',
  0x4008011a: 'DistributionAddress',
  0x40080202: 'InterpretationIDIssuer',
  0x40080300: 'Impressions',
  0x40084000: 'ResultsComments',
  0xfffafffa: 'DigitalSignaturesSequence',
  0xfffcfffc: 'DataSetTrailingPadding',
};

