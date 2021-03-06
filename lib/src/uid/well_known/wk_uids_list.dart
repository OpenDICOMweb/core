// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:core/src/uid/well_known/frame_of_reference.dart';
import 'package:core/src/uid/well_known/ldap_oid.dart';
import 'package:core/src/uid/well_known/meta_sop_class.dart';
import 'package:core/src/uid/well_known/sop_class.dart';
import 'package:core/src/uid/well_known/sop_instance.dart';
import 'package:core/src/uid/well_known/transfer_syntax.dart';
import 'package:core/src/uid/well_known/wk_uid.dart';


/// This library contains compile time constant definitions of
/// "Well Known" [SopClass]s and there corresponding [String] values.
const List<WKUid> wkUids = const [
  SopClass.kVerification,
  TransferSyntax.kImplicitVRLittleEndian,
  TransferSyntax.kDefaultForDIMSE,
  TransferSyntax.kDefaultForDicomWeb,
  TransferSyntax.kExplicitVRLittleEndian,
  TransferSyntax.kDeflatedExplicitVRLittleEndian,
  TransferSyntax.kExplicitVRBigEndian,
  TransferSyntax.kJpegBaseline1,
  TransferSyntax.kJpegLossy8BitDefault,
  TransferSyntax.kJpegExtended2_4,
  TransferSyntax.kJpegLossy12BitDefault,
  TransferSyntax.kJpegExtended3_5,
  TransferSyntax.kJpegSpectralSelectionNonHierarchical6_8,
  TransferSyntax.kJpegSpectralSelectionNonHierarchical7_9,
  TransferSyntax.kJpegFullProgressionNonHierarchical10_12,
  TransferSyntax.kJpegFullProgressionNonHierarchical11_13,
  TransferSyntax.kJpegLosslessNonHierarchical14,
  TransferSyntax.kJpegLosslessNonHierarchical15,
  TransferSyntax.kJpegExtendedHierarchical16_18,
  TransferSyntax.kJpegExtendedHierarchical17_19,
  TransferSyntax.kJpegSpectralSelectionHierarchical20_22,
  TransferSyntax.kJpegSpectralSelectionHierarchical21_23,
  TransferSyntax.kJpegFullProgressionHierarchical24_26,
  TransferSyntax.kJpegFullProgressionHierarchical25_27,
  TransferSyntax.kJpegLosslessHierarchical28,
  TransferSyntax.kJpegLosslessHierarchical29,
  TransferSyntax.kJpegLosslessNonHierarchicalFirstOrderPrediction14_1,
  TransferSyntax.kJpegLosslessDefault,
  TransferSyntax.kJpegLSLosslessImageCompression,
  TransferSyntax.kJpegLSLossyImageCompression,
  TransferSyntax.kJpeg2000ImageCompressionLosslessOnly,
  TransferSyntax.kJpeg2000ImageCompression,
  TransferSyntax.kJpeg2000Part2MultiComponentImageCompressionLosslessOnly,
  TransferSyntax.kJpeg2000Part2MultiComponentImageCompression,
  TransferSyntax.kJPIPReferenced,
  TransferSyntax.kJPIPReferencedDeflate,
  TransferSyntax.kMpeg2MainProfileMainLevel,
  TransferSyntax.kMpeg2MainProfileHighLevel,
  TransferSyntax.kMpeg4AVCH264HighProfileLevel41,
  TransferSyntax.kMpeg4AVCH264BDCompatibleHighProfileLevel41,
  TransferSyntax.kRLELossless,
  TransferSyntax.kRFC2557MIMEncapsulation,
  TransferSyntax.kXMLEncoding,
  SopClass.kMediaStorageDirectoryStorage,
  FrameOfReference.kTalairachBrainAtlasFrameOfReference,
  FrameOfReference.kSPM2T1FrameOfReference,
  FrameOfReference.kSPM2T2FrameOfReference,
  FrameOfReference.kSPM2PDFrameOfReference,
  FrameOfReference.kSPM2EPIFrameOfReference,
  FrameOfReference.kSPM2FILT1FrameOfReference,
  FrameOfReference.kSPM2PETFrameOfReference,
  FrameOfReference.kSPM2TRANSMFrameOfReference,
  FrameOfReference.kSPM2SPECTFrameOfReference,
  FrameOfReference.kSPM2GRAYFrameOfReference,
  FrameOfReference.kSPM2WHITEFrameOfReference,
  FrameOfReference.kSPM2CSFFrameOfReference,
  FrameOfReference.kSPM2BRAINMASKFrameOfReference,
  FrameOfReference.kSPM2AVG305T1FrameOfReference,
  FrameOfReference.kSPM2AVG152T1FrameOfReference,
  FrameOfReference.kSPM2AVG152T2FrameOfReference,
  FrameOfReference.kSPM2AVG152PDFrameOfReference,
  FrameOfReference.kSPM2SINGLESUBJT1FrameOfReference,
  FrameOfReference.kICBM452T1FrameOfReference,
  FrameOfReference.kICBMSingleSubjectMRIFrameOfReference,
  WellKnownSopInstance.kHotIronColorPalette,
  WellKnownSopInstance.kPETColorPalette,
  WellKnownSopInstance.kHotMetalBlueColorPalette,
  WellKnownSopInstance.kPET20StepColorPalette,
  SopClass.kBasicStudyContentNotification,
  SopClass.kStorageCommitmentPushModel,
  WellKnownSopInstance.kStorageCommitmentPushModel,
  SopClass.kStorageCommitmentPullModel,
  WellKnownSopInstance .kStorageCommitmentPullModel,
  SopClass.kProceduralEventLogging,
  WellKnownSopInstance .kProceduralEventLogging,
  SopClass.kSubstanceAdministrationLogging,
  WellKnownSopInstance .kSubstanceAdministrationLogging,
  WKUid.kDicomUIDRegistry,
  WKUid.kDicomControlledTerminology,
  WKUid.kDicomApplicationContextName,
  SopClass.kDetachedPatientManagement,
  MetaSopClass.kDetachedPatientManagement,
  SopClass.kDetachedVisitManagement,
  SopClass.kDetachedStudyManagement,
  SopClass.kStudyComponentManagement,
  SopClass.kModalityPerformedProcedureStep,
  SopClass.kModalityPerformedProcedureStepRetrieve,
  SopClass.kModalityPerformedProcedureStepNotification,
  SopClass.kDetachedResultsManagement,
  MetaSopClass.kDetachedResultsManagement,
  MetaSopClass.kDetachedStudyManagement,
  SopClass.kDetachedInterpretationManagement,
  WKUid.kStorageServiceClass,
  SopClass.kBasicFilmSession,
  SopClass.kBasicFilmBox,
  SopClass.kBasicGrayscaleImageBox,
  SopClass.kBasicColorImageBox,
  SopClass.kReferencedImageBox,
  MetaSopClass.kBasicGrayscalePrintManagement,
  MetaSopClass.kReferencedGrayscalePrintManagement,
  SopClass.kPrintJob,
  SopClass.kBasicAnnotationBox,
  SopClass.kPrinter,
  SopClass.kPrinterConfigurationRetrieval,
  WellKnownSopInstance .kPrinter,
  WellKnownSopInstance .kPrinterConfigurationRetrieval,
  MetaSopClass.kBasicColorPrintManagement,
  MetaSopClass.kReferencedColorPrintManagement,
  SopClass.kVOILUTBox,
  SopClass.kPresentationLUT,
  SopClass.kImageOverlayBox,
  SopClass.kBasicPrintImageOverlayBox,
  WellKnownSopInstance  .kPrintQueue,
  SopClass.kPrintQueueManagement,
  SopClass.kStoredPrintStorage,
  SopClass.kHardcopyGrayscaleImageStorage,
  SopClass.kHardcopyColorImageStorage,
  SopClass.kPullPrintRequest,
  MetaSopClass.kPullStoredPrintManagement,
  SopClass.kMediaCreationManagementSOPClassUID,
  SopClass.kComputedRadiographyImageStorage,
  SopClass.kDigitalXRayImageStorageForPresentation,
  SopClass.kDigitalXRayImageStorageForProcessing,
  SopClass.kDigitalMammographyXRayImageStorageForPresentation,
  SopClass.kDigitalMammographyXRayImageStorageForProcessing,
  SopClass.kDigitalIntraOralXRayImageStorageForPresentation,
  SopClass.kDigitalIntraOralXRayImageStorageForProcessing,
  SopClass.kCTImageStorage,
  SopClass.kEnhancedCTImageStorage,
  SopClass.kLegacyConvertedEnhancedCTImageStorage,
  SopClass.kUltrasoundMultiFrameImageStorage,
  SopClass.kUltrasoundMultiFrameImageStorage,
  SopClass.kMRImageStorage,
  SopClass.kEnhancedMRImageStorage,
  SopClass.kMRSpectroscopyStorage,
  SopClass.kEnhancedMRColorImageStorage,
  SopClass.kLegacyConvertedEnhancedMRImageStorage,
  SopClass.kNuclearMedicineImageStorage,
  SopClass.kUltrasoundImageStorage,
  SopClass.kUltrasoundImageStorage,
  SopClass.kEnhancedUSVolumeStorage,
  SopClass.kSecondaryCaptureImageStorage,
  SopClass.kMultiFrameSingleBitSecondaryCaptureImageStorage,
  SopClass.kMultiFrameGrayscaleByteSecondaryCaptureImageStorage,
  SopClass.kMultiFrameGrayscaleWordSecondaryCaptureImageStorage,
  SopClass.kMultiFrameTrueColorSecondaryCaptureImageStorage,
  SopClass.kStandaloneOverlayStorage,
  SopClass.kStandaloneCurveStorage,
  SopClass.kWaveformStorageTrial,
  SopClass.kTwelvelead12ECGWaveformStorage,
  SopClass.kGeneralECGWaveformStorage,
  SopClass.kAmbulatoryECGWaveformStorage,
  SopClass.kHemodynamicWaveformStorage,
  SopClass.kCardiacElectrophysiologyWaveformStorage,
  SopClass.kBasicVoiceAudioWaveformStorage,
  SopClass.kGeneralAudioWaveformStorage,
  SopClass.kArterialPulseWaveformStorage,
  SopClass.kRespiratoryWaveformStorage,
  SopClass.kStandaloneModalityLUTStorage,
  SopClass.kStandaloneVOILUTStorage,
  SopClass.kGrayscaleSoftcopyPresentationStateStorage,
  SopClass.kColorSoftcopyPresentationStateStorage,
  SopClass.kPseudoColorSoftcopyPresentationStateStorage,
  SopClass.kBlendingSoftcopyPresentationStateStorage,
  SopClass.kXAXRFGrayscaleSoftcopyPresentationStateStorage,
  SopClass.kXRayAngiographicImageStorage,
  SopClass.kEnhancedXAImageStorage,
  SopClass.kXRayRadiofluoroscopicImageStorage,
  SopClass.kEnhancedXRFImageStorage,
  SopClass.kXRayAngiographicBiPlaneImageStorage,
  SopClass.kXRay3DAngiographicImageStorage,
  SopClass.kXRay3DCraniofacialImageStorage,
  SopClass.kBreastTomosynthesisImageStorage,
  SopClass.kIntravascularOpticalCoherenceTomographyImageStorageForPresentation,
  SopClass.kIntravascularOpticalCoherenceTomographyImageStorageForProcessing,
  SopClass.kNuclearMedicineImageStorage,
  SopClass.kRawDataStorage,
  SopClass.kSpatialRegistrationStorage,
  SopClass.kSpatialFiducialsStorage,
  SopClass.kDeformableSpatialRegistrationStorage,
  SopClass.kSegmentationStorage,
  SopClass.kSurfaceSegmentationStorage,
  SopClass.kRealWorldValueMappingStorage,
  SopClass.kSurfaceScanMeshStorage,
  SopClass.kSurfaceScanPointCloudStorage,
  SopClass.kVLImageStorageTrial,
  SopClass.kVLMultiFrameImageStorageTrial,
  SopClass.kVLEndoscopicImageStorage,
  SopClass.kVideoEndoscopicImageStorage,
  SopClass.kVLMicroscopicImageStorage,
  SopClass.kVideoMicroscopicImageStorage,
  SopClass.kVLSlideCoordinatesMicroscopicImageStorage,
  SopClass.kVLPhotographicImageStorage,
  SopClass.kVideoPhotographicImageStorage,
  SopClass.kOphthalmicPhotography8BitImageStorage,
  SopClass.kOphthalmicPhotography16BitImageStorage,
  SopClass.kStereometricRelationshipStorage,
  SopClass.kOphthalmicTomographyImageStorage,
  SopClass.kVLWholeSlideMicroscopyImageStorage,
  SopClass.kLensometryMeasurementsStorage,
  SopClass.kAutorefractionMeasurementsStorage,
  SopClass.kKeratometryMeasurementsStorage,
  SopClass.kSubjectiveRefractionMeasurementsStorage,
  SopClass.kVisualAcuityMeasurementsStorage,
  SopClass.kSpectaclePrescriptionReportStorage,
  SopClass.kOphthalmicAxialMeasurementsStorage,
  SopClass.kIntraocularLensCalculationsStorage,
  SopClass.kMacularGridThicknessandVolumeReportStorage,
  SopClass.kOphthalmicVisualFieldStaticPerimetryMeasurementsStorage,
  SopClass.kOphthalmicThicknessMapStorage,
  SopClass.kCornealTopographyMapStorage,
  SopClass.kTextSRStorageTrial,
  SopClass.kAudioSRStorageTrial,
  SopClass.kDetailSRStorageTrial,
  SopClass.kComprehensiveSRStorageTrial,
  SopClass.kBasicTextSRStorage,
  SopClass.kEnhancedSRStorage,
  SopClass.kComprehensiveSRStorage,
  SopClass.kComprehensive3DSRStorage,
  SopClass.kProcedureLogStorage,
  SopClass.kMammographyCADSRStorage,
  SopClass.kKeyObjectSelectionDocumentStorage,
  SopClass.kChestCADSRStorage,
  SopClass.kXRayRadiationDoseSRStorage,
  SopClass.kColonCADSRStorage,
  SopClass.kImplantationPlanSRStorage,
  SopClass.kEncapsulatedPDFStorage,
  SopClass.kEncapsulatedCDAStorage,
  SopClass.kPositronEmissionTomographyImageStorage,
  SopClass.kLegacyConvertedEnhancedPETImageStorage,
  SopClass.kStandalonePETCurveStorage,
  SopClass.kEnhancedPETImageStorage,
  SopClass.kBasicStructuredDisplayStorage,
  SopClass.kRTImageStorage,
  SopClass.kRTDoseStorage,
  SopClass.kRTStructureSetStorage,
  SopClass.kRTBeamsTreatmentRecordStorage,
  SopClass.kRTPlanStorage,
  SopClass.kRTBrachyTreatmentRecordStorage,
  SopClass.kRTTreatmentSummaryRecordStorage,
  SopClass.kRTIonPlanStorage,
  SopClass.kRTIonBeamsTreatmentRecordStorage,
  SopClass.kDICOSCTImageStorage,
  SopClass.kDICOSDigitalXRayImageStorageForPresentation,
  SopClass.kDICOSDigitalXRayImageStorageForProcessing,
  SopClass.kDICOSThreatDetectionReportStorage,
  SopClass.kDICOS2DAITStorage,
  SopClass.kDICOS3DAITStorage,
  SopClass.kDICOSQuadrupoleResonanceStorage,
  SopClass.kEddyCurrentImageStorage,
  SopClass.kEddyCurrentMultiFrameImageStorage,
  SopClass.kPatientRootQueryRetrieveInformationModelFIND,
  SopClass.kPatientRootQueryRetrieveInformationModelMOVE,
  SopClass.kPatientRootQueryRetrieveInformationModelGET,
  SopClass.kStudyRootQueryRetrieveInformationModelFIND,
  SopClass.kStudyRootQueryRetrieveInformationModelMOVE,
  SopClass.kStudyRootQueryRetrieveInformationModelGET,
  SopClass.kPatientStudyOnlyQueryRetrieveInformationModelFIND,
  SopClass.kPatientStudyOnlyQueryRetrieveInformationModelMOVE,
  SopClass.kPatientStudyOnlyQueryRetrieveInformationModelGET,
  SopClass.kCompositeInstanceRootRetrieveMOVE,
  SopClass.kCompositeInstanceRootRetrieveGET,
  SopClass.kCompositeInstanceRetrieveWithoutBulkDataGET,
  SopClass.kModalityWorklistInformationModelFIND,
  SopClass.kGeneralPurposeWorklistInformationModelFIND,
  SopClass.kGeneralPurposeScheduledProcedureStep,
  SopClass.kGeneralPurposePerformedProcedureStep,
  SopClass.kGeneralPurposeWorklistManagement,
  SopClass.kInstanceAvailabilityNotification,
  SopClass.kRTBeamsDeliveryInstructionStorageTrial,
  SopClass.kRTConventionalMachineVerificationTrial,
  SopClass.kRTIonMachineVerificationTrial,
  WKUid.kUnifiedWorklistAndProcedureStepServiceClassTrial,
  SopClass.kUnifiedProcedureStepPushSOPClassTrial,
  SopClass.kUnifiedProcedureStepWatchSOPClassTrial,
  SopClass.kUnifiedProcedureStepPullSOPClassTrial,
  SopClass.kUnifiedProcedureStepEventSOPClassTrial,
  WellKnownSopInstance.kUnifiedWorklistAndProcedureStep,
  WKUid.kUnifiedWorklistAndProcedureStepServiceClass,
  SopClass.kUnifiedProcedureStepPush,
  SopClass.kUnifiedProcedureStepWatch,
  SopClass.kUnifiedProcedureStepPull,
  SopClass.kUnifiedProcedureStepEvent,
  SopClass.kRTBeamsDeliveryInstructionStorage,
  SopClass.kRTConventionalMachineVerification,
  SopClass.kRTIonMachineVerification,
  SopClass.kGeneralRelevantPatientInformationQuery,
  SopClass.kBreastImagingRelevantPatientInformationQuery,
  SopClass.kCardiacRelevantPatientInformationQuery,
  SopClass.kHangingProtocolStorage,
  SopClass.kHangingProtocolInformationModelFIND,
  SopClass.kHangingProtocolInformationModelMOVE,
  SopClass.kHangingProtocolInformationModelGET,
  SopClass.kColorPaletteStorage,
  SopClass.kColorPaletteInformationModelFIND,
  SopClass.kColorPaletteInformationModelMOVE,
  SopClass.kColorPaletteInformationModelGET,
  SopClass.kProductCharacteristicsQuery,
  SopClass.kSubstanceApprovalQuery,
  SopClass.kGenericImplantTemplateStorage,
  SopClass.kGenericImplantTemplateInformationModelFIND,
  SopClass.kGenericImplantTemplateInformationModelMOVE,
  SopClass.kGenericImplantTemplateInformationModelGET,
  SopClass.kImplantAssemblyTemplateStorage,
  SopClass.kImplantAssemblyTemplateInformationModelFIND,
  SopClass.kImplantAssemblyTemplateInformationModelMOVE,
  SopClass.kImplantAssemblyTemplateInformationModelGET,
  SopClass.kImplantTemplateGroupStorage,
  SopClass.kImplantTemplateGroupInformationModelFIND,
  SopClass.kImplantTemplateGroupInformationModelMOVE,
  SopClass.kImplantTemplateGroupInformationModelGET,
  WKUid.kNativeDicomModel,
  WKUid.kAbstractMultiDimensionalImageModel,
  LdapOid.kDicomDeviceName,
  LdapOid.kDicomDescription,
  LdapOid.kDicomManufacturer,
  LdapOid.kDicomManufacturerModelName,
  LdapOid.kDicomSoftwareVersion,
  LdapOid.kDicomVendorData,
  LdapOid.kDicomAETitle,
  LdapOid.kDicomNetworkConnectionReference,
  LdapOid.kDicomApplicationCluster,
  LdapOid.kDicomAssociationInitiator,
  LdapOid.kDicomAssociationAcceptor,
  LdapOid.kDicomHostname,
  LdapOid.kDicomPort,
  LdapOid.kDicomSOPClass,
  LdapOid.kDicomTransferRole,
  LdapOid.kDicomTransferSyntax,
  LdapOid.kDicomPrimaryDeviceType,
  LdapOid.kDicomRelatedDeviceReference,
  LdapOid.kDicomPreferredCalledAETitle,
  LdapOid.kDicomTLSCyphersuite,
  LdapOid.kDicomAuthorizedNodeCertificateReference,
  LdapOid.kDicomThisNodeCertificateReference,
  LdapOid.kDicomInstalled,
  LdapOid.kDicomStationName,
  LdapOid.kDicomDeviceSerialNumber,
  LdapOid.kDicomInstitutionName,
  LdapOid.kDicomInstitutionAddress,
  LdapOid.kDicomInstitutionDepartmentName,
  LdapOid.kDicomIssuerOfPatientID,
  LdapOid.kDicomPreferredCallingAETitle,
  LdapOid.kDicomSupportedCharacterSet,
  LdapOid.kDicomConfigurationRoot,
  LdapOid.kDicomDevicesRoot,
  LdapOid.kDicomUniqueAETitlesRegistryRoot,
  LdapOid.kDicomDevice,
  LdapOid.kDicomNetworkAE,
  LdapOid.kDicomNetworkConnection,
  LdapOid.kDicomUniqueAETitle,
  LdapOid.kDicomTransferCapability,
  WKUid.kUniversalCoordinatedTime
];
