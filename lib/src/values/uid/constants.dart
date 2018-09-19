//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

// ignore_for_file: public_member_api_docs

/// This library contains compile time constant definitions of
/// 'Well Known' UIDs and there corresponding [String] values.
/// All names  start with 'k'.
///
/// Note: These constants names use the ODW convention of starting with
/// the letter 'k' with followed by the DICOM keyword.

// TODO: before V0.9.0 maybe move to dcm_constants package.
const String kVerificationSOPClass = '1.2.840.10008.1.1';

const String kImplicitVRLittleEndian = '1.2.840.10008.1.2';
const String kDefaultTransferSyntaxForDICOM = kImplicitVRLittleEndian;

const String kExplicitVRLittleEndian = '1.2.840.10008.1.2.1';

const String kDeflatedExplicitVRLittleEndian = '1.2.840.10008.1.2.1.99';

const String kExplicitVRBigEndian = '1.2.840.10008.1.2.2';

// **** JPEG

const String kJpegBaseline1 = '1.2.840.10008.1.2.4.50';
const String kDefaultTransferSyntaxForLossyJpeg8BitImageCompression = kJpegBaseline1;

const String kJpegExtended2_4 = '1.2.840.10008.1.2.4.51';
const String kDefaultTransferSyntaxForLossyJpeg12BitImageCompression4 = kJpegExtended2_4;

const String kJpegExtended3_5 = '1.2.840.10008.1.2.4.52';

const String kJpegSpectralSelectionNonHierarchical6_8 = '1.2.840.10008.1.2.4.53';

const String kJpegSpectralSelectionNonHierarchical7_9 = '1.2.840.10008.1.2.4.54';

const String kJpegFullProgressionNonHierarchical10_12 = '1.2.840.10008.1.2.4.55';

const String kJpegFullProgressionNonHierarchical11_13 = '1.2.840.10008.1.2.4.56';

const String kJpegLosslessNonHierarchical14 = '1.2.840.10008.1.2.4.57';

const String kJpegLosslessNonHierarchical15 = '1.2.840.10008.1.2.4.58';

const String kJpegExtendedHierarchical16_18 = '1.2.840.10008.1.2.4.59';

const String kJpegExtendedHierarchical17_19 = '1.2.840.10008.1.2.4.60';

const String kJpegSpectralSelectionHierarchical20_22 = '1.2.840.10008.1.2.4.61';

const String kJpegSpectralSelectionHierarchical21_23 = '1.2.840.10008.1.2.4.62';

const String kJpegFullProgressionHierarchical24_26 = '1.2.840.10008.1.2.4.63';

const String kJpegFullProgressionHierarchical25_27 = '1.2.840.10008.1.2.4.64';

const String kJpegLosslessHierarchical28 = '1.2.840.10008.1.2.4.65';

const String kJpegLosslessHierarchical29 = '1.2.840.10008.1.2.4.66';

const String kJpegLosslessNonHierarchicalFirstOrderPrediction14_1 =
    '1.2.840.10008.1.2.4.70';
const String kDefaultTransferSyntaxForLosslessJpegImageCompression =
    kJpegLosslessNonHierarchicalFirstOrderPrediction14_1;

const String kJpegLSLosslessImageCompression = '1.2.840.10008.1.2.4.80';

const String kJpegLSLossyImageCompression = '1.2.840.10008.1.2.4.81';

// **** JPEG2000

const String kJpeg2000ImageCompressionLosslessOnly = '1.2.840.10008.1.2.4.90';

const String kJpeg2000ImageCompression = '1.2.840.10008.1.2.4.91';

const String kJpeg2000Part2MultiComponentImageCompressionLosslessOnly =
    '1.2.840.10008.1.2.4.92';

const String kJpeg2000Part2MultiComponentImageCompression = '1.2.840.10008.1.2.4.93';

const String kJpipReferenced = '1.2.840.10008.1.2.4.94';

const String kJpipReferencedDeflate = '1.2.840.10008.1.2.4.95';

// **** MPEG

const String kMpeg2MainProfileMainLevel = '1.2.840.10008.1.2.4.100';

const String kMpeg2MainProfileHighLevel = '1.2.840.10008.1.2.4.101';

const String kMpeg4AVCH264HighProfileLevel41 = '1.2.840.10008.1.2.4.102';

const String kMpeg4AVCH264BDCompatibleHighProfileLevel41 = '1.2.840.10008.1.2.4.103';

// *** RLE

const String kRLELossless = '1.2.840.10008.1.2.5';

const String kRFC2557MIMEncapsulation = '1.2.840.10008.1.2.6.1';

const String kXMLEncoding = '1.2.840.10008.1.2.6.2';

const String kMediaStorageDirectoryStorage = '1.2.840.10008.1.3.10';

const String kTalairachBrainAtlasFrameOfReference = '1.2.840.10008.1.4.1.1';

const String kSPM2T1FrameOfReference = '1.2.840.10008.1.4.1.2';

const String kSPM2T2FrameOfReference = '1.2.840.10008.1.4.1.3';

const String kSPM2PDFrameOfReference = '1.2.840.10008.1.4.1.4';

const String kSPM2EPIFrameOfReference = '1.2.840.10008.1.4.1.5';

const String kSPM2FILT1FrameOfReference = '1.2.840.10008.1.4.1.6';

const String kSPM2PETFrameOfReference = '1.2.840.10008.1.4.1.7';

const String kSPM2TRANSMFrameOfReference = '1.2.840.10008.1.4.1.8';

const String kSPM2SPECTFrameOfReference = '1.2.840.10008.1.4.1.9';

const String kSPM2GRAYFrameOfReference = '1.2.840.10008.1.4.1.10';

const String kSPM2WHITEFrameOfReference = '1.2.840.10008.1.4.1.11';

const String kSPM2CSFFrameOfReference = '1.2.840.10008.1.4.1.12';

const String kSPM2BRAINMASKFrameOfReference = '1.2.840.10008.1.4.1.13';

const String kSPM2AVG305T1FrameOfReference = '1.2.840.10008.1.4.1.14';

const String kSPM2AVG152T1FrameOfReference = '1.2.840.10008.1.4.1.15';

const String kSPM2AVG152T2FrameOfReference = '1.2.840.10008.1.4.1.16';

const String kSPM2AVG152PDFrameOfReference = '1.2.840.10008.1.4.1.17';

const String kSPM2SINGLESUBJT1FrameOfReference = '1.2.840.10008.1.4.1.18';

const String kICBM452T1FrameOfReference = '1.2.840.10008.1.4.2.1';

const String kICBMSingleSubjectMRIFrameOfReference = '1.2.840.10008.1.4.2.2';

const String kHotIronColorPaletteSOPInstance = '1.2.840.10008.1.5.1';

const String kPETColorPaletteSOPInstance = '1.2.840.10008.1.5.2';

const String kHotMetalBlueColorPaletteSOPInstance = '1.2.840.10008.1.5.3';

const String kPET20StepColorPaletteSOPInstance = '1.2.840.10008.1.5.4';

const String kBasicStudyContentNotificationSOPClass = '1.2.840.10008.1.9';

const String kStorageCommitmentPushModelSOPClass = '1.2.840.10008.1.20.1';

const String kStorageCommitmentPushModelSOPInstance = '1.2.840.10008.1.20.1.1';

const String kStorageCommitmentPullModelSOPClass = '1.2.840.10008.1.20.2';

const String kStorageCommitmentPullModelSOPInstance = '1.2.840.10008.1.20.2.1';

const String kProceduralEventLoggingSOPClass = '1.2.840.10008.1.40';

const String kProceduralEventLoggingSOPInstance = '1.2.840.10008.1.40.1';

const String kSubstanceAdministrationLoggingSOPClass = '1.2.840.10008.1.42';

const String kSubstanceAdministrationLoggingSOPInstance = '1.2.840.10008.1.42.1';

const String kDICOMUIDRegistry = '1.2.840.10008.2.6.1';

const String kDICOMControlledTerminology = '1.2.840.10008.2.16.4';

const String kDICOMApplicationContextName = '1.2.840.10008.3.1.1.1';

const String kDetachedPatientManagementSOPClass = '1.2.840.10008.3.1.2.1.1';

const String kDetachedPatientManagementMetaSOPClass = '1.2.840.10008.3.1.2.1.4';

const String kDetachedVisitManagementSOPClass = '1.2.840.10008.3.1.2.2.1';

const String kDetachedStudyManagementSOPClass = '1.2.840.10008.3.1.2.3.1';

const String kStudyComponentManagementSOPClass = '1.2.840.10008.3.1.2.3.2';

const String kModalityPerformedProcedureStepSOPClass = '1.2.840.10008.3.1.2.3.3';

const String kModalityPerformedProcedureStepRetrieveSOPClass = '1.2.840.10008.3.1.2.3.4';

const String kModalityPerformedProcedureStepNotificationSOPClass =
    '1.2.840.10008.3.1.2.3.5';

const String kDetachedResultsManagementSOPClass = '1.2.840.10008.3.1.2.5.1';

const String kDetachedResultsManagementMetaSOPClass = '1.2.840.10008.3.1.2.5.4';

const String kDetachedStudyManagementMetaSOPClass = '1.2.840.10008.3.1.2.5.5';

const String kDetachedInterpretationManagementSOPClass = '1.2.840.10008.3.1.2.6.1';

const String kStorageServiceClass = '1.2.840.10008.4.2';

const String kBasicFilmSessionSOPClass = '1.2.840.10008.5.1.1.1';

const String kBasicFilmBoxSOPClass = '1.2.840.10008.5.1.1.2';

const String kBasicGrayscaleImageBoxSOPClass = '1.2.840.10008.5.1.1.4';

const String kBasicColorImageBoxSOPClass = '1.2.840.10008.5.1.1.4.1';

const String kReferencedImageBoxSOPClass = '1.2.840.10008.5.1.1.4.2';

const String kBasicGrayscalePrintManagementMetaSOPClass = '1.2.840.10008.5.1.1.9';

const String kReferencedGrayscalePrintManagementMetaSOPClass = '1.2.840.10008.5.1.1.9.1';

const String kPrintJobSOPClass = '1.2.840.10008.5.1.1.14';

const String kBasicAnnotationBoxSOPClass = '1.2.840.10008.5.1.1.15';

const String kPrinterSOPClass = '1.2.840.10008.5.1.1.16';

const String kPrinterConfigurationRetrievalSOPClass = '1.2.840.10008.5.1.1.16.376';

const String kPrinterSOPInstance = '1.2.840.10008.5.1.1.17';

const String kPrinterConfigurationRetrievalSOPInstance = '1.2.840.10008.5.1.1.17.376';

const String kBasicColorPrintManagementMetaSOPClass = '1.2.840.10008.5.1.1.18';

const String kReferencedColorPrintManagementMetaSOPClass = '1.2.840.10008.5.1.1.18.1';

const String kVOILUTBoxSOPClass = '1.2.840.10008.5.1.1.22';

const String kPresentationLUTSOPClass = '1.2.840.10008.5.1.1.23';

const String kImageOverlayBoxSOPClass = '1.2.840.10008.5.1.1.24';

const String kBasicPrintImageOverlayBoxSOPClass = '1.2.840.10008.5.1.1.24.1';

const String kPrintQueueSOPInstance = '1.2.840.10008.5.1.1.25';

const String kPrintQueueManagementSOPClass = '1.2.840.10008.5.1.1.26';

const String kStoredPrintStorageSOPClass = '1.2.840.10008.5.1.1.27';

const String kHardcopyGrayscaleImageStorageSOPClass = '1.2.840.10008.5.1.1.29';

const String kHardcopyColorImageStorageSOPClass = '1.2.840.10008.5.1.1.30';

const String kPullPrintRequestSOPClass = '1.2.840.10008.5.1.1.31';

const String kPullStoredPrintManagementMetaSOPClass = '1.2.840.10008.5.1.1.32';

const String kMediaCreationManagementSOPClassUID = '1.2.840.10008.5.1.1.33';

const String kComputedRadiographyImageStorage = '1.2.840.10008.5.1.4.1.1.1';

const String kDigitalXRayImageStorageForPresentation = '1.2.840.10008.5.1.4.1.1.1.1';

const String kDigitalXRayImageStorageForProcessing = '1.2.840.10008.5.1.4.1.1.1.1.1';

const String kDigitalMammographyXRayImageStorageForPresentation =
    '1.2.840.10008.5.1.4.1.1.1.2';

const String kDigitalMammographyXRayImageStorageForProcessing =
    '1.2.840.10008.5.1.4.1.1.1.2.1';

const String kDigitalIntraOralXRayImageStorageForPresentation =
    '1.2.840.10008.5.1.4.1.1.1.3';

const String kDigitalIntraOralXRayImageStorageForProcessing =
    '1.2.840.10008.5.1.4.1.1.1.3.1';

const String kCTImageStorage = '1.2.840.10008.5.1.4.1.1.2';

const String kEnhancedCTImageStorage = '1.2.840.10008.5.1.4.1.1.2.1';

const String kLegacyConvertedEnhancedCTImageStorage = '1.2.840.10008.5.1.4.1.1.2.2';

const String kUltrasoundMultiFrameImageStorageRetired = '1.2.840.10008.5.1.4.1.1.3';

const String kUltrasoundMultiFrameImageStorage = '1.2.840.10008.5.1.4.1.1.3.1';

const String kMRImageStorage = '1.2.840.10008.5.1.4.1.1.4';

const String kEnhancedMRImageStorage = '1.2.840.10008.5.1.4.1.1.4.1';

const String kMRSpectroscopyStorage = '1.2.840.10008.5.1.4.1.1.4.2';

const String kEnhancedMRColorImageStorage = '1.2.840.10008.5.1.4.1.1.4.3';

const String kLegacyConvertedEnhancedMRImageStorage = '1.2.840.10008.5.1.4.1.1.4.4';

const String kNuclearMedicineImageStorageRetired = '1.2.840.10008.5.1.4.1.1.5';

const String kUltrasoundImageStorageRetired = '1.2.840.10008.5.1.4.1.1.6';

const String kUltrasoundImageStorage = '1.2.840.10008.5.1.4.1.1.6.1';

const String kEnhancedUSVolumeStorage = '1.2.840.10008.5.1.4.1.1.6.2';

const String kSecondaryCaptureImageStorage = '1.2.840.10008.5.1.4.1.1.7';

const String kMultiFrameSingleBitSecondaryCaptureImageStorage =
    '1.2.840.10008.5.1.4.1.1.7.1';

const String kMultiFrameGrayscaleByteSecondaryCaptureImageStorage =
    '1.2.840.10008.5.1.4.1.1.7.2';

const String kMultiFrameGrayscaleWordSecondaryCaptureImageStorage =
    '1.2.840.10008.5.1.4.1.1.7.3';

const String kMultiFrameTrueColorSecondaryCaptureImageStorage =
    '1.2.840.10008.5.1.4.1.1.7.4';

const String kStandaloneOverlayStorage = '1.2.840.10008.5.1.4.1.1.8';

const String kStandaloneCurveStorage = '1.2.840.10008.5.1.4.1.1.9';

const String kWaveformStorageTrial = '1.2.840.10008.5.1.4.1.1.9.1';

const String kTwelveLead12ECGWaveformStorage = '1.2.840.10008.5.1.4.1.1.9.1.1';

const String kGeneralECGWaveformStorage = '1.2.840.10008.5.1.4.1.1.9.1.2';

const String kAmbulatoryECGWaveformStorage = '1.2.840.10008.5.1.4.1.1.9.1.3';

const String kHemodynamicWaveformStorage = '1.2.840.10008.5.1.4.1.1.9.2.1';

const String kCardiacElectrophysiologyWaveformStorage = '1.2.840.10008.5.1.4.1.1.9.3.1';

const String kBasicVoiceAudioWaveformStorage = '1.2.840.10008.5.1.4.1.1.9.4.1';

const String kGeneralAudioWaveformStorage = '1.2.840.10008.5.1.4.1.1.9.4.2';

const String kArterialPulseWaveformStorage = '1.2.840.10008.5.1.4.1.1.9.5.1';

const String kRespiratoryWaveformStorage = '1.2.840.10008.5.1.4.1.1.9.6.1';

const String kStandaloneModalityLUTStorage = '1.2.840.10008.5.1.4.1.1.10';

const String kStandaloneVOILUTStorage = '1.2.840.10008.5.1.4.1.1.11';

const String kGrayscaleSoftcopyPresentationStateStorageSOPClass =
    '1.2.840.10008.5.1.4.1.1.11.1';

const String kColorSoftcopyPresentationStateStorageSOPClass =
    '1.2.840.10008.5.1.4.1.1.11.2';

const String kPseudoColorSoftcopyPresentationStateStorageSOPClass =
    '1.2.840.10008.5.1.4.1.1.11.3';

const String kBlendingSoftcopyPresentationStateStorageSOPClass =
    '1.2.840.10008.5.1.4.1.1.11.4';

const String kXAXRFGrayscaleSoftcopyPresentationStateStorage =
    '1.2.840.10008.5.1.4.1.1.11.5';

const String kXRayAngiographicImageStorage = '1.2.840.10008.5.1.4.1.1.12.1';

const String kEnhancedXAImageStorage = '1.2.840.10008.5.1.4.1.1.12.1.1';

const String kXRayRadiofluoroscopicImageStorage = '1.2.840.10008.5.1.4.1.1.12.2';

const String kEnhancedXRFImageStorage = '1.2.840.10008.5.1.4.1.1.12.2.1';

const String kXRayAngiographicBiPlaneImageStorage = '1.2.840.10008.5.1.4.1.1.12.3';

const String kXRay3DAngiographicImageStorage = '1.2.840.10008.5.1.4.1.1.13.1.1';

const String kXRay3DCraniofacialImageStorage = '1.2.840.10008.5.1.4.1.1.13.1.2';

const String kBreastTomosynthesisImageStorage = '1.2.840.10008.5.1.4.1.1.13.1.3';

const String kIntravascularOpticalCoherenceTomographyImageStorageForPresentation =
    '1.2.840.10008.5.1.4.1.1.14.1';

const String kIntravascularOpticalCoherenceTomographyImageStorageForProcessing =
    '1.2.840.10008.5.1.4.1.1.14.2';

const String kNuclearMedicineImageStorage = '1.2.840.10008.5.1.4.1.1.20';

const String kRawDataStorage = '1.2.840.10008.5.1.4.1.1.66';

const String kSpatialRegistrationStorage = '1.2.840.10008.5.1.4.1.1.66.1';

const String kSpatialFiducialsStorage = '1.2.840.10008.5.1.4.1.1.66.2';

const String kDeformableSpatialRegistrationStorage = '1.2.840.10008.5.1.4.1.1.66.3';

const String kSegmentationStorage = '1.2.840.10008.5.1.4.1.1.66.4';

const String kSurfaceSegmentationStorage = '1.2.840.10008.5.1.4.1.1.66.5';

const String kRealWorldValueMappingStorage = '1.2.840.10008.5.1.4.1.1.67';

const String kSurfaceScanMeshStorage = '1.2.840.10008.5.1.4.1.1.68.1';

const String kSurfaceScanPointCloudStorage = '1.2.840.10008.5.1.4.1.1.68.2';

const String kVLImageStorageTrial = '1.2.840.10008.5.1.4.1.1.77.1';

const String kVLMultiFrameImageStorageTrial = '1.2.840.10008.5.1.4.1.1.77.2';

const String kVLEndoscopicImageStorage = '1.2.840.10008.5.1.4.1.1.77.1.1';

const String kVideoEndoscopicImageStorage = '1.2.840.10008.5.1.4.1.1.77.1.1.1';

const String kVLMicroscopicImageStorage = '1.2.840.10008.5.1.4.1.1.77.1.2';

const String kVideoMicroscopicImageStorage = '1.2.840.10008.5.1.4.1.1.77.1.2.1';

const String kVLSlideCoordinatesMicroscopicImageStorage =
    '1.2.840.10008.5.1.4.1.1.77.1.3';

const String kVLPhotographicImageStorage = '1.2.840.10008.5.1.4.1.1.77.1.4';

const String kVideoPhotographicImageStorage = '1.2.840.10008.5.1.4.1.1.77.1.4.1';

const String kOphthalmicPhotography8BitImageStorage = '1.2.840.10008.5.1.4.1.1.77.1.5.1';

const String kOphthalmicPhotography16BitImageStorage = '1.2.840.10008.5.1.4.1.1.77.1.5.2';

const String kStereometricRelationshipStorage = '1.2.840.10008.5.1.4.1.1.77.1.5.3';

const String kOphthalmicTomographyImageStorage = '1.2.840.10008.5.1.4.1.1.77.1.5.4';

const String kVLWholeSlideMicroscopyImageStorage = '1.2.840.10008.5.1.4.1.1.77.1.6';

const String kLensometryMeasurementsStorage = '1.2.840.10008.5.1.4.1.1.78.1';

const String kAutorefractionMeasurementsStorage = '1.2.840.10008.5.1.4.1.1.78.2';

const String kKeratometryMeasurementsStorage = '1.2.840.10008.5.1.4.1.1.78.3';

const String kSubjectiveRefractionMeasurementsStorage = '1.2.840.10008.5.1.4.1.1.78.4';

const String kVisualAcuityMeasurementsStorage = '1.2.840.10008.5.1.4.1.1.78.5';

const String kSpectaclePrescriptionReportStorage = '1.2.840.10008.5.1.4.1.1.78.6';

const String kOphthalmicAxialMeasurementsStorage = '1.2.840.10008.5.1.4.1.1.78.7';

const String kIntraocularLensCalculationsStorage = '1.2.840.10008.5.1.4.1.1.78.8';

const String kMacularGridThicknessandVolumeReportStorage = '1.2.840.10008.5.1.4.1.1.79.1';

const String kOphthalmicVisualFieldStaticPerimetryMeasurementsStorage =
    '1.2.840.10008.5.1.4.1.1.80.1';

const String kOphthalmicThicknessMapStorage = '1.2.840.10008.5.1.4.1.1.81.1';

const String kCornealTopographyMapStorage = '11.2.840.10008.5.1.4.1.1.82.1';

const String kTextSRStorageTrial = '1.2.840.10008.5.1.4.1.1.88.1';

const String kAudioSRStorageTrial = '1.2.840.10008.5.1.4.1.1.88.2';

const String kDetailSRStorageTrial = '1.2.840.10008.5.1.4.1.1.88.3';

const String kComprehensiveSRStorageTrial = '1.2.840.10008.5.1.4.1.1.88.4';

const String kBasicTextSRStorage = '1.2.840.10008.5.1.4.1.1.88.11';

const String kEnhancedSRStorage = '1.2.840.10008.5.1.4.1.1.88.22';

const String kComprehensiveSRStorage = '1.2.840.10008.5.1.4.1.1.88.33';

const String kComprehensive3DSRStorage = '1.2.840.10008.5.1.4.1.1.88.34';

const String kProcedureLogStorage = '1.2.840.10008.5.1.4.1.1.88.40';

const String kMammographyCADSRStorage = '1.2.840.10008.5.1.4.1.1.88.50';

const String kKeyObjectSelectionDocumentStorage = '1.2.840.10008.5.1.4.1.1.88.59';

const String kChestCADSRStorage = '1.2.840.10008.5.1.4.1.1.88.65';

const String kXRayRadiationDoseSRStorage = '1.2.840.10008.5.1.4.1.1.88.67';

const String kColonCADSRStorage = '1.2.840.10008.5.1.4.1.1.88.69';

const String kImplantationPlanSRStorage = '1.2.840.10008.5.1.4.1.1.88.70';

const String kEncapsulatedPDFStorage = '1.2.840.10008.5.1.4.1.1.104.1';

const String kEncapsulatedCDAStorage = '1.2.840.10008.5.1.4.1.1.104.2';

const String kPositronEmissionTomographyImageStorage = '1.2.840.10008.5.1.4.1.1.128';

const String kLegacyConvertedEnhancedPETImageStorage = '1.2.840.10008.5.1.4.1.1.128.1';

const String kStandalonePETCurveStorage = '1.2.840.10008.5.1.4.1.1.129';

const String kEnhancedPETImageStorage = '1.2.840.10008.5.1.4.1.1.130';

const String kBasicStructuredDisplayStorage = '1.2.840.10008.5.1.4.1.1.131';

const String kRTImageStorage = '1.2.840.10008.5.1.4.1.1.481.1';

const String kRTDoseStorage = '1.2.840.10008.5.1.4.1.1.481.2';

const String kRTStructureSetStorage = '1.2.840.10008.5.1.4.1.1.481.3';

const String kRTBeamsTreatmentRecordStorage = '1.2.840.10008.5.1.4.1.1.481.4';

const String kRTPlanStorage = '1.2.840.10008.5.1.4.1.1.481.5';

const String kRTBrachyTreatmentRecordStorage = '1.2.840.10008.5.1.4.1.1.481.6';

const String kRTTreatmentSummaryRecordStorage = '1.2.840.10008.5.1.4.1.1.481.7';

const String kRTIonPlanStorage = '1.2.840.10008.5.1.4.1.1.481.8';

const String kRTIonBeamsTreatmentRecordStorage = '1.2.840.10008.5.1.4.1.1.481.9';

const String kDICOSCTImageStorage = '1.2.840.10008.5.1.4.1.1.501.1';

const String kDICOSDigitalXRayImageStorageForPresentation =
    '1.2.840.10008.5.1.4.1.1.501.2.1';

const String kDICOSDigitalXRayImageStorageForProcessing =
    '1.2.840.10008.5.1.4.1.1.501.2.2';

const String kDICOSThreatDetectionReportStorage = '1.2.840.10008.5.1.4.1.1.501.3';

const String kDICOS2DAITStorage = '1.2.840.10008.5.1.4.1.1.501.4';

const String kDICOS3DAITStorage = '1.2.840.10008.5.1.4.1.1.501.5';

const String kDICOSQuadrupoleResonanceStorage = '1.2.840.10008.5.1.4.1.1.501.6';

const String kEddyCurrentImageStorage = '1.2.840.10008.5.1.4.1.1.601.1';

const String kEddyCurrentMultiFrameImageStorage = '1.2.840.10008.5.1.4.1.1.601.2';

const String kPatientRootQueryRetrieveInformationModelFIND =
    '1.2.840.10008.5.1.4.1.2.1.1';

const String kPatientRootQueryRetrieveInformationModelMOVE =
    '1.2.840.10008.5.1.4.1.2.1.2';

const String kPatientRootQueryRetrieveInformationModelGET = '1.2.840.10008.5.1.4.1.2.1.3';

const String kStudyRootQueryRetrieveInformationModelFIND = '1.2.840.10008.5.1.4.1.2.2.1';

const String kStudyRootQueryRetrieveInformationModelMOVE = '1.2.840.10008.5.1.4.1.2.2.2';

const String kStudyRootQueryRetrieveInformationModelGET = '1.2.840.10008.5.1.4.1.2.2.3';

const String kPatientStudyOnlyQueryRetrieveInformationModelFIND =
    '1.2.840.10008.5.1.4.1.2.3.1';

const String kPatientStudyOnlyQueryRetrieveInformationModelMOVE =
    '1.2.840.10008.5.1.4.1.2.3.2';

const String kPatientStudyOnlyQueryRetrieveInformationModelGET =
    '1.2.840.10008.5.1.4.1.2.3.3';

const String kCompositeInstanceRootRetrieveMOVE = '1.2.840.10008.5.1.4.1.2.4.2';

const String kCompositeInstanceRootRetrieveGET = '1.2.840.10008.5.1.4.1.2.4.3';

const String kCompositeInstanceRetrieveWithoutBulkDataGET = '1.2.840.10008.5.1.4.1.2.5.3';

const String kModalityWorklistInformationModelFIND = '1.2.840.10008.5.1.4.31';

const String kGeneralPurposeWorklistInformationModelFIND = '1.2.840.10008.5.1.4.32.1';

const String kGeneralPurposeScheduledProcedureStepSOPClass = '1.2.840.10008.5.1.4.32.2';

const String kGeneralPurposePerformedProcedureStepSOPClass = '1.2.840.10008.5.1.4.32.3';

const String kGeneralPurposeWorklistManagementMetaSOPClass = '1.2.840.10008.5.1.4.32';

const String kInstanceAvailabilityNotificationSOPClass = '1.2.840.10008.5.1.4.33';

const String kRTBeamsDeliveryInstructionStorageTrial = '1.2.840.10008.5.1.4.34.1';

const String kRTConventionalMachineVerificationTrial = '1.2.840.10008.5.1.4.34.2';

const String kRTIonMachineVerificationTrial = '1.2.840.10008.5.1.4.34.3';

const String kUnifiedWorklistAndProcedureStepServiceClassTrial =
    '1.2.840.10008.5.1.4.34.4';

const String kUnifiedProcedureStepPushSOPClassTrial = '1.2.840.10008.5.1.4.34.4.1';

const String kUnifiedProcedureStepWatchSOPClassTrial = '1.2.840.10008.5.1.4.34.4.2';

const String kUnifiedProcedureStepPullSOPClassTrial = '1.2.840.10008.5.1.4.34.4.3';

const String kUnifiedProcedureStepEventSOPClassTrial = '1.2.840.10008.5.1.4.34.4.4';

const String kUnifiedWorklistAndProcedureStepSOPInstance = '1.2.840.10008.5.1.4.34.5';

const String kUnifiedWorklistAndProcedureStepServiceClass = '1.2.840.10008.5.1.4.34.6';

const String kUnifiedProcedureStepPushSOPClass = '1.2.840.10008.5.1.4.34.6.1';

const String kUnifiedProcedureStepWatchSOPClass = '1.2.840.10008.5.1.4.34.6.2';

const String kUnifiedProcedureStepPullSOPClass = '1.2.840.10008.5.1.4.34.6.3';

const String kUnifiedProcedureStepEventSOPClass = '1.2.840.10008.5.1.4.34.6.4';

const String kRTBeamsDeliveryInstructionStorage = '1.2.840.10008.5.1.4.34.7';

const String kRTConventionalMachineVerification = '1.2.840.10008.5.1.4.34.8';

const String kRTIonMachineVerification = '1.2.840.10008.5.1.4.34.9';

const String kGeneralRelevantPatientInformationQuery = '1.2.840.10008.5.1.4.37.1';

const String kBreastImagingRelevantPatientInformationQuery = '1.2.840.10008.5.1.4.37.2';

const String kCardiacRelevantPatientInformationQuery = '1.2.840.10008.5.1.4.37.3';

const String kHangingProtocolStorage = '1.2.840.10008.5.1.4.38.1';

const String kHangingProtocolInformationModelFIND = '1.2.840.10008.5.1.4.38.2';

const String kHangingProtocolInformationModelMOVE = '1.2.840.10008.5.1.4.38.3';

const String kHangingProtocolInformationModelGET = '1.2.840.10008.5.1.4.38.4';

const String kColorPaletteStorage = '1.2.840.10008.5.1.4.39.1';

const String kColorPaletteInformationModelFIND = '1.2.840.10008.5.1.4.39.2';

const String kColorPaletteInformationModelMOVE = '1.2.840.10008.5.1.4.39.3';

const String kColorPaletteInformationModelGET = '1.2.840.10008.5.1.4.39.4';

const String kProductCharacteristicsQuerySOPClass = '1.2.840.10008.5.1.4.41';

const String kSubstanceApprovalQuerySOPClass = '1.2.840.10008.5.1.4.42';

const String kGenericImplantTemplateStorage = '1.2.840.10008.5.1.4.43.1';

const String kGenericImplantTemplateInformationModelFIND = '1.2.840.10008.5.1.4.43.2';

const String kGenericImplantTemplateInformationModelMOVE = '1.2.840.10008.5.1.4.43.3';

const String kGenericImplantTemplateInformationModelGET = '1.2.840.10008.5.1.4.43.4';

const String kImplantAssemblyTemplateStorage = '1.2.840.10008.5.1.4.44.1';

const String kImplantAssemblyTemplateInformationModelFIND = '1.2.840.10008.5.1.4.44.2';

const String kImplantAssemblyTemplateInformationModelMOVE = '1.2.840.10008.5.1.4.44.3';

const String kImplantAssemblyTemplateInformationModelGET = '1.2.840.10008.5.1.4.44.4';

const String kImplantTemplateGroupStorage = '1.2.840.10008.5.1.4.45.1';

const String kImplantTemplateGroupInformationModelFIND = '1.2.840.10008.5.1.4.45.2';

const String kImplantTemplateGroupInformationModelMOVE = '1.2.840.10008.5.1.4.45.3';

const String kImplantTemplateGroupInformationModelGET = '1.2.840.10008.5.1.4.45.4';

const String kNativeDICOMModel = '1.2.840.10008.7.1.1';

const String kAbstractMultiDimensionalImageModel = '1.2.840.10008.7.1.2';

const String kDicomDeviceName = '1.2.840.10008.15.0.3.1';

const String kDicomDescription = '1.2.840.10008.15.0.3.2';

const String kDicomManufacturer = '1.2.840.10008.15.0.3.3';

const String kDicomManufacturerModelName = '1.2.840.10008.15.0.3.4';

const String kDicomSoftwareVersion = '1.2.840.10008.15.0.3.5';

const String kDicomVendorData = '1.2.840.10008.15.0.3.6';

const String kDicomAETitle = '1.2.840.10008.15.0.3.7';

const String kDicomNetworkConnectionReference = '1.2.840.10008.15.0.3.8';

const String kDicomApplicationCluster = '1.2.840.10008.15.0.3.9';

const String kDicomAssociationInitiator = '1.2.840.10008.15.0.3.10';

const String kDicomAssociationAcceptor = '1.2.840.10008.15.0.3.11';

const String kDicomHostname = '1.2.840.10008.15.0.3.12';

const String kDicomPort = '1.2.840.10008.15.0.3.13';

const String kDicomSOPClass = '1.2.840.10008.15.0.3.14';

const String kDicomTransferRole = '1.2.840.10008.15.0.3.15';

const String kDicomTransferSyntax = '1.2.840.10008.15.0.3.16';

const String kDicomPrimaryDeviceType = '1.2.840.10008.15.0.3.17';

const String kDicomRelatedDeviceReference = '1.2.840.10008.15.0.3.18';

const String kDicomPreferredCalledAETitle = '1.2.840.10008.15.0.3.19';

const String kDicomTLSCyphersuite = '1.2.840.10008.15.0.3.20';

const String kDicomAuthorizedNodeCertificateReference = '1.2.840.10008.15.0.3.21';

const String kDicomThisNodeCertificateReference = '1.2.840.10008.15.0.3.22';

const String kDicomInstalled = '1.2.840.10008.15.0.3.23';

const String kDicomStationName = '1.2.840.10008.15.0.3.24';

const String kDicomDeviceSerialNumber = '1.2.840.10008.15.0.3.25';

const String kDicomInstitutionName = '1.2.840.10008.15.0.3.26';

const String kDicomInstitutionAddress = '1.2.840.10008.15.0.3.27';

const String kDicomInstitutionDepartmentName = '1.2.840.10008.15.0.3.28';

const String kDicomIssuerOfPatientID = '1.2.840.10008.15.0.3.29';

const String kDicomPreferredCallingAETitle = '1.2.840.10008.15.0.3.30';

const String kDicomSupportedCharacterSet = '1.2.840.10008.15.0.3.31';

const String kDicomConfigurationRoot = '1.2.840.10008.15.0.4.1';

const String kDicomDevicesRoot = '1.2.840.10008.15.0.4.2';

const String kDicomUniqueAETitlesRegistryRoot = '1.2.840.10008.15.0.4.3';

const String kDicomDevice = '1.2.840.10008.15.0.4.4';

const String kDicomNetworkAE = '1.2.840.10008.15.0.4.5';

const String kDicomNetworkConnection = '1.2.840.10008.15.0.4.6';

const String kDicomUniqueAETitle = '1.2.840.10008.15.0.4.7';

const String kDicomTransferCapability = '1.2.840.10008.15.0.4.8';

const String kUniversalCoordinatedTime = '1.2.840.10008.15.1.1';
