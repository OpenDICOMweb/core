// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/uid/uid_type.dart';
import 'package:core/src/uid/well_known/wk_uid.dart';


class SopClass extends WKUid {
  const SopClass(String uid, String keyword, UidType type, String name,
      {bool isRetired = false})
      : super(uid, keyword, type, name, isRetired: isRetired);

  @override
  String get info => '$runtimeType($asString)';

  @override
  String toString() => asString;

  static const String kName = 'SOP Class';

  static SopClass lookup(String s) => map[s];

  //Urgent: verify that all SOPClass Definitions from PS3.6 are present
  static const SopClass kVerification = const SopClass('1.2.840.10008.1.1',
      'VerificationSOPClass', UidType.kSOPClass, 'Verification SOP Class');

  static const SopClass kMediaStorageDirectoryStorage = const SopClass(
      '1.2.840.10008.1.3.10',
      'MediaStorageDirectoryStorage',
      UidType.kSOPClass,
      'Media Storage Directory Storage');

  static const SopClass kBasicStudyContentNotification = const SopClass(
      '1.2.840.10008.1.9',
      'BasicStudyContentNotificationSOPClass_Retired',
      UidType.kSOPClass,
      'Basic Study Content Notification SOP Class (Retired)',
      isRetired: true);
  static const SopClass kStorageCommitmentPushModel = const SopClass(
      '1.2.840.10008.1.20.1',
      'StorageCommitmentPushModelSOPClass',
      UidType.kSOPClass,
      'Storage Commitment Push Model SOP Class',
      isRetired: true);

  static const SopClass kStorageCommitmentPullModel = const SopClass(
      '1.2.840.10008.1.20.2',
      'StorageCommitmentPullModelSOPClass_Retired',
      UidType.kSOPClass,
      'Storage Commitment Pull Model SOP Class (Retired)',
      isRetired: true);

  static const SopClass kProceduralEventLogging = const SopClass(
      '1.2.840.10008.1.40',
      'ProceduralEventLoggingSOPClass',
      UidType.kSOPClass,
      'Procedural Event Logging SOP Class');

  static const SopClass kSubstanceAdministrationLogging = const SopClass(
      '1.2.840.10008.1.42',
      'SubstanceAdministrationLoggingSOPClass',
      UidType.kSOPClass,
      'Substance Administration Logging SOP Class');
  static const SopClass kDetachedPatientManagement = const SopClass(
      '1.2.840.10008.3.1.2.1.1',
      'DetachedPatientManagementSOPClass_Retired',
      UidType.kSOPClass,
      'Detached Patient Management SOP Class (Retired)',
      isRetired: true);

  static const SopClass kDetachedVisitManagement = const SopClass(
      '1.2.840.10008.3.1.2.2.1',
      'DetachedVisitManagementSOPClass_Retired',
      UidType.kSOPClass,
      'Detached Visit Management SOP Class (Retired)',
      isRetired: true);
  static const SopClass kDetachedStudyManagement = const SopClass(
      '1.2.840.10008.3.1.2.3.1',
      'DetachedStudyManagementSOPClass_Retired',
      UidType.kSOPClass,
      'Detached Study Management SOP Class (Retired)',
      isRetired: true);
  static const SopClass kStudyComponentManagement = const SopClass(
      '1.2.840.10008.3.1.2.3.2',
      'StudyComponentManagementSOPClass_Retired',
      UidType.kSOPClass,
      'Study Component Management SOP Class (Retired)',
      isRetired: true);
  static const SopClass kModalityPerformedProcedureStep = const SopClass(
      '1.2.840.10008.3.1.2.3.3',
      'ModalityPerformedProcedureStepSOPClass',
      UidType.kSOPClass,
      'Modality Performed Procedure Step SOP Class');
  static const SopClass kModalityPerformedProcedureStepRetrieve =
      const SopClass(
    '1.2.840.10008.3.1.2.3.4',
    'ModalityPerformedProcedureStepRetrieveSOPClass',
    UidType.kSOPClass,
    'Modality Performed Procedure Step Retrieve SOP Class',
  );
  static const SopClass kModalityPerformedProcedureStepNotification =
      const SopClass(
    '1.2.840.10008.3.1.2.3.5',
    'ModalityPerformedProcedureStepNotificationSOPClass',
    UidType.kSOPClass,
    'Modality Performed Procedure Step Notification SOP Class',
  );
  static const SopClass kDetachedResultsManagement = const SopClass(
      '1.2.840.10008.3.1.2.5.1',
      'DetachedResultsManagementSOPClass_Retired',
      UidType.kSOPClass,
      'Detached Results Management SOP Class (Retired)',
      isRetired: true);
  static const SopClass kDetachedInterpretationManagement = const SopClass(
      '1.2.840.10008.3.1.2.6.1',
      'DetachedInterpretationManagementSOPClass_Retired',
      UidType.kSOPClass,
      'Detached Interpretation Management SOP Class (Retired)',
      isRetired: true);

  static const SopClass kBasicFilmSession = const SopClass(
      '1.2.840.10008.5.1.1.1',
      'BasicFilmSessionSOPClass',
      UidType.kSOPClass,
      'Basic Film Session SOP Class');
  static const SopClass kBasicFilmBox = const SopClass('1.2.840.10008.5.1.1.2',
      'BasicFilmBoxSOPClass', UidType.kSOPClass, 'Basic Film Box SOP Class');
  static const SopClass kBasicGrayscaleImageBox = const SopClass(
      '1.2.840.10008.5.1.1.4',
      'BasicGrayscaleImageBoxSOPClass',
      UidType.kSOPClass,
      'Basic Grayscale Image Box SOP Class');
  static const SopClass kBasicColorImageBox = const SopClass(
      '1.2.840.10008.5.1.1.4.1',
      'BasicColorImageBoxSOPClass',
      UidType.kSOPClass,
      'Basic Color Image Box SOP Class');
  static const SopClass kReferencedImageBox = const SopClass(
      '1.2.840.10008.5.1.1.4.2',
      'ReferencedImageBoxSOPClass_Retired',
      UidType.kSOPClass,
      'Referenced Image Box SOP Class (Retired)',
      isRetired: true);
  static const SopClass kPrintJob = const SopClass('1.2.840.10008.5.1.1.14',
      'PrintJobSOPClass', UidType.kSOPClass, 'Print Job SOP Class');
  static const SopClass kBasicAnnotationBox = const SopClass(
      '1.2.840.10008.5.1.1.15',
      'BasicAnnotationBoxSOPClass',
      UidType.kSOPClass,
      'Basic Annotation Box SOP Class');
  static const SopClass kPrinter = const SopClass('1.2.840.10008.5.1.1.16',
      'PrinterSOPClass', UidType.kSOPClass, 'Printer SOP Class');
  static const SopClass kPrinterConfigurationRetrieval = const SopClass(
      '1.2.840.10008.5.1.1.16.376',
      'PrinterConfigurationRetrievalSOPClass',
      UidType.kSOPClass,
      'Printer Configuration Retrieval SOP Class');
  static const SopClass kVOILUTBox = const SopClass('1.2.840.10008.5.1.1.22',
      'VOILUTBoxSOPClass', UidType.kSOPClass, 'VOI LUT Box SOP Class');
  static const SopClass kPresentationLUT = const SopClass(
      '1.2.840.10008.5.1.1.23',
      'PresentationLUTSOPClass',
      UidType.kSOPClass,
      'Presentation LUT SOP Class');
  static const SopClass kImageOverlayBox = const SopClass(
      '1.2.840.10008.5.1.1.24',
      'ImageOverlayBoxSOPClass_Retired',
      UidType.kSOPClass,
      'Image Overlay Box SOP Class (Retired)',
      isRetired: true);
  static const SopClass kBasicPrintImageOverlayBox = const SopClass(
      '1.2.840.10008.5.1.1.24.1',
      'BasicPrintImageOverlayBoxSOPClass_Retired',
      UidType.kSOPClass,
      'Basic Print Image Overlay Box SOP Class (Retired)',
      isRetired: true);

  static const SopClass kPrintQueueManagement = const SopClass(
      '1.2.840.10008.5.1.1.26',
      'PrintQueueManagementSOPClass_Retired',
      UidType.kSOPClass,
      'Print Queue Management SOP Class (Retired)',
      isRetired: true);
  static const SopClass kStoredPrintStorage = const SopClass(
      '1.2.840.10008.5.1.1.27',
      'StoredPrintStorageSOPClass_Retired',
      UidType.kSOPClass,
      'Stored Print Storage SOP Class (Retired)',
      isRetired: true);
  static const SopClass kHardcopyGrayscaleImageStorage = const SopClass(
      '1.2.840.10008.5.1.1.29',
      'HardcopyGrayscaleImageStorageSOPClass_Retired',
      UidType.kSOPClass,
      'Hardcopy Grayscale Image Storage SOP Class (Retired)',
      isRetired: true);
  static const SopClass kHardcopyColorImageStorage = const SopClass(
      '1.2.840.10008.5.1.1.30',
      'HardcopyColorImageStorageSOPClass_Retired',
      UidType.kSOPClass,
      'Hardcopy Color Image Storage SOP Class (Retired)',
      isRetired: true);
  static const SopClass kPullPrintRequest = const SopClass(
      '1.2.840.10008.5.1.1.31',
      'PullPrintRequestSOPClass_Retired',
      UidType.kSOPClass,
      'Pull Print Request SOP Class (Retired)',
      isRetired: true);
  static const SopClass kMediaCreationManagementSOPClassUID = const SopClass(
      '1.2.840.10008.5.1.1.33',
      'MediaCreationManagementSOPClassUID',
      UidType.kSOPClass,
      'Media Creation Management SOP Class UID');
  static const SopClass kComputedRadiographyImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.1',
      'ComputedRadiographyImageStorage',
      UidType.kSOPClass,
      'Computed Radiography Image Storage');
  static const SopClass kDigitalXRayImageStorageForPresentation =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.1.1',
    'DigitalX_RayImageStorage_ForPresentation',
    UidType.kSOPClass,
    'Digital X-Ray Image Storage - For Presentation',
  );
  static const SopClass kDigitalXRayImageStorageForProcessing = const SopClass(
    '1.2.840.10008.5.1.4.1.1.1.1.1',
    'DigitalX_RayImageStorage_ForProcessing',
    UidType.kSOPClass,
    'Digital X-Ray Image Storage - For Processing',
  );
  static const SopClass kDigitalMammographyXRayImageStorageForPresentation =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.1.2',
    'DigitalMammographyX_RayImageStorage_ForPresentation',
    UidType.kSOPClass,
    'Digital Mammography X-Ray Image Storage - For Presentation',
  );
  static const SopClass kDigitalMammographyXRayImageStorageForProcessing =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.1.2.1',
    'DigitalMammographyX_RayImageStorage_ForProcessing',
    UidType.kSOPClass,
    'Digital Mammography X-Ray Image Storage - For Processing',
  );
  static const SopClass kDigitalIntraOralXRayImageStorageForPresentation =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.1.3',
    'DigitalIntra_OralX_RayImageStorage_ForPresentation',
    UidType.kSOPClass,
    'Digital Intra-Oral X-Ray Image Storage - For Presentation',
  );
  static const SopClass kDigitalIntraOralXRayImageStorageForProcessing =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.1.3.1',
    'DigitalIntra_OralX_RayImageStorage_ForProcessing',
    UidType.kSOPClass,
    'Digital Intra-Oral X-Ray Image Storage - For Processing',
  );
  static const SopClass kCTImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.2',
      'CTImageStorage',
      UidType.kSOPClass,
      'CT Image Storage');
  static const SopClass kEnhancedCTImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.2.1',
      'EnhancedCTImageStorage',
      UidType.kSOPClass,
      'Enhanced CT Image Storage');
  static const SopClass kLegacyConvertedEnhancedCTImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.2.2',
      'LegacyConvertedEnhancedCTImageStorage',
      UidType.kSOPClass,
      'Legacy Converted Enhanced CT Image Storage');
  static const SopClass kUltrasoundMultiFrameImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.3',
      'UltrasoundMulti_frameImageStorage_Retired',
      UidType.kSOPClass,
      'Ultrasound Multi-frame Image Storage (Retired)',
      isRetired: true);
  static const SopClass kUltrasoundMultiFrameImageStorageRetired =
      const SopClass(
          '1.2.840.10008.5.1.4.1.1.3.1',
          'UltrasoundMulti_frameImageStorage',
          UidType.kSOPClass,
          'Ultrasound Multi-frame Image Storage');
  static const SopClass kMRImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.4',
      'MRImageStorage',
      UidType.kSOPClass,
      'MR Image Storage');
  static const SopClass kEnhancedMRImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.4.1',
      'EnhancedMRImageStorage',
      UidType.kSOPClass,
      'Enhanced MR Image Storage');
  static const SopClass kMRSpectroscopyStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.4.2',
      'MRSpectroscopyStorage',
      UidType.kSOPClass,
      'MR Spectroscopy Storage');
  static const SopClass kEnhancedMRColorImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.4.3',
      'EnhancedMRColorImageStorage',
      UidType.kSOPClass,
      'Enhanced MR Color Image Storage');
  static const SopClass kLegacyConvertedEnhancedMRImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.4.4',
      'LegacyConvertedEnhancedMRImageStorage',
      UidType.kSOPClass,
      'Legacy Converted Enhanced MR Image Storage');
  static const SopClass kNuclearMedicineImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.5',
      'NuclearMedicineImageStorage_Retired',
      UidType.kSOPClass,
      'Nuclear Medicine Image Storage (Retired)',
      isRetired: true);
  static const SopClass kUltrasoundImageStorageRetired = const SopClass(
      '1.2.840.10008.5.1.4.1.1.6',
      'UltrasoundImageStorage_Retired',
      UidType.kSOPClass,
      'Ultrasound Image Storage (Retired)',
      isRetired: true);
  static const SopClass kUltrasoundImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.6.1',
      'UltrasoundImageStorage',
      UidType.kSOPClass,
      'Ultrasound Image Storage');
  static const SopClass kEnhancedUSVolumeStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.6.2',
      'EnhancedUSVolumeStorage',
      UidType.kSOPClass,
      'Enhanced US Volume Storage');
  static const SopClass kSecondaryCaptureImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.7',
      'SecondaryCaptureImageStorage',
      UidType.kSOPClass,
      'Secondary Capture Image Storage');
  static const SopClass kMultiFrameSingleBitSecondaryCaptureImageStorage =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.7.1',
    'Multi_frameSingleBitSecondaryCaptureImageStorage',
    UidType.kSOPClass,
    'Multi-frame Single Bit Secondary Capture Image Storage',
  );
  static const SopClass kMultiFrameGrayscaleByteSecondaryCaptureImageStorage =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.7.2',
    'Multi_frameGrayscaleByteSecondaryCaptureImageStorage',
    UidType.kSOPClass,
    'Multi-frame Grayscale Byte Secondary Capture Image Storage',
  );
  static const SopClass kMultiFrameGrayscaleWordSecondaryCaptureImageStorage =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.7.3',
    'Multi_frameGrayscaleWordSecondaryCaptureImageStorage',
    UidType.kSOPClass,
    'Multi-frame Grayscale Word Secondary Capture Image Storage',
  );
  static const SopClass kMultiFrameTrueColorSecondaryCaptureImageStorage =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.7.4',
    'Multi_frameTrueColorSecondaryCaptureImageStorage',
    UidType.kSOPClass,
    'Multi-frame True Color Secondary Capture Image Storage',
  );
  static const SopClass kStandaloneOverlayStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.8',
      'StandaloneOverlayStorage_Retired',
      UidType.kSOPClass,
      'Standalone Overlay Storage (Retired)',
      isRetired: true);
  static const SopClass kStandaloneCurveStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.9',
      'StandaloneCurveStorage_Retired',
      UidType.kSOPClass,
      'Standalone Curve Storage (Retired)',
      isRetired: true);
  static const SopClass kWaveformStorageTrial = const SopClass(
      '1.2.840.10008.5.1.4.1.1.9.1',
      'WaveformStorage_Trial_Retired',
      UidType.kSOPClass,
      'Waveform Storage - Trial (Retired)',
      isRetired: true);
  static const SopClass kTwelvelead12ECGWaveformStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.9.1.1',
      'twelve_lead_12ECGWaveformStorage',
      UidType.kSOPClass,
      'twelve-lead(12) ECG Waveform Storage');
  static const SopClass kGeneralECGWaveformStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.9.1.2',
      'GeneralECGWaveformStorage',
      UidType.kSOPClass,
      'General ECG Waveform Storage');
  static const SopClass kAmbulatoryECGWaveformStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.9.1.3',
      'AmbulatoryECGWaveformStorage',
      UidType.kSOPClass,
      'Ambulatory ECG Waveform Storage');
  static const SopClass kHemodynamicWaveformStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.9.2.1',
      'HemodynamicWaveformStorage',
      UidType.kSOPClass,
      'Hemodynamic Waveform Storage');
  static const SopClass kCardiacElectrophysiologyWaveformStorage =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.9.3.1',
    'CardiacElectrophysiologyWaveformStorage',
    UidType.kSOPClass,
    'Cardiac Electrophysiology Waveform Storage',
  );
  static const SopClass kBasicVoiceAudioWaveformStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.9.4.1',
      'BasicVoiceAudioWaveformStorage',
      UidType.kSOPClass,
      'Basic Voice Audio Waveform Storage');
  static const SopClass kGeneralAudioWaveformStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.9.4.2',
      'GeneralAudioWaveformStorage',
      UidType.kSOPClass,
      'General Audio Waveform Storage');
  static const SopClass kArterialPulseWaveformStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.9.5.1',
      'ArterialPulseWaveformStorage',
      UidType.kSOPClass,
      'Arterial Pulse Waveform Storage');
  static const SopClass kRespiratoryWaveformStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.9.6.1',
      'RespiratoryWaveformStorage',
      UidType.kSOPClass,
      'Respiratory Waveform Storage');
  static const SopClass kStandaloneModalityLUTStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.10',
      'StandaloneModalityLUTStorage_Retired',
      UidType.kSOPClass,
      'Standalone Modality LUT Storage (Retired)',
      isRetired: true);
  static const SopClass kStandaloneVOILUTStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.11',
      'StandaloneVOILUTStorage_Retired',
      UidType.kSOPClass,
      'Standalone VOI LUT Storage (Retired)',
      isRetired: true);
  static const SopClass kGrayscaleSoftcopyPresentationStateStorage =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.11.1',
    'GrayscaleSoftcopyPresentationStateStorageSOPClass',
    UidType.kSOPClass,
    'Grayscale Softcopy Presentation State Storage SOP Class',
  );
  static const SopClass kColorSoftcopyPresentationStateStorage = const SopClass(
    '1.2.840.10008.5.1.4.1.1.11.2',
    'ColorSoftcopyPresentationStateStorageSOPClass',
    UidType.kSOPClass,
    'Color Softcopy Presentation State Storage SOP Class',
  );
  static const SopClass kPseudoColorSoftcopyPresentationStateStorage =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.11.3',
    'Pseudo_ColorSoftcopyPresentationStateStorageSOPClass',
    UidType.kSOPClass,
    'Pseudo-Color Softcopy Presentation State Storage SOP Class',
  );
  static const SopClass kBlendingSoftcopyPresentationStateStorage =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.11.4',
    'BlendingSoftcopyPresentationStateStorageSOPClass',
    UidType.kSOPClass,
    'Blending Softcopy Presentation State Storage SOP Class',
  );
  static const SopClass kXAXRFGrayscaleSoftcopyPresentationStateStorage =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.11.5',
    'XA_XRFGrayscaleSoftcopyPresentationStateStorage',
    UidType.kSOPClass,
    'XA/XRF Grayscale Softcopy Presentation State Storage',
  );
  static const SopClass kXRayAngiographicImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.12.1',
      'X_RayAngiographicImageStorage',
      UidType.kSOPClass,
      'X-Ray Angiographic Image Storage');
  static const SopClass kEnhancedXAImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.12.1.1',
      'EnhancedXAImageStorage',
      UidType.kSOPClass,
      'Enhanced XA Image Storage');
  static const SopClass kXRayRadiofluoroscopicImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.12.2',
      'X_RayRadiofluoroscopicImageStorage',
      UidType.kSOPClass,
      'X-Ray Radiofluoroscopic Image Storage');
  static const SopClass kEnhancedXRFImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.12.2.1',
      'EnhancedXRFImageStorage',
      UidType.kSOPClass,
      'Enhanced XRF Image Storage');
  static const SopClass kXRayAngiographicBiPlaneImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.12.3',
      'X_RayAngiographicBi_PlaneImageStorage_Retired',
      UidType.kSOPClass,
      'X-Ray Angiographic Bi-Plane Image Storage (Retired)',
      isRetired: true);
  static const SopClass kXRay3DAngiographicImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.13.1.1',
      'X_Ray3DAngiographicImageStorage',
      UidType.kSOPClass,
      'X-Ray 3D Angiographic Image Storage');
  static const SopClass kXRay3DCraniofacialImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.13.1.2',
      'X_Ray3DCraniofacialImageStorage',
      UidType.kSOPClass,
      'X-Ray 3D Craniofacial Image Storage');
  static const SopClass kBreastTomosynthesisImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.13.1.3',
      'BreastTomosynthesisImageStorage',
      UidType.kSOPClass,
      'Breast Tomosynthesis Image Storage');
  static const SopClass
      kIntravascularOpticalCoherenceTomographyImageStorageForPresentation =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.14.1',
    'IntravascularOpticalCoherenceTomographyImageStorage_ForPresentation',
    UidType.kSOPClass,
    'Intravascular Optical Coherence Tomography Image Storage '
        '- For Presentation',
  );
  static const SopClass
      kIntravascularOpticalCoherenceTomographyImageStorageForProcessing =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.14.2',
    'IntravascularOpticalCoherenceTomographyImageStorage_ForProcessing',
    UidType.kSOPClass,
    'Intravascular Optical Coherence Tomography Image Storage - For Processing',
  );
  static const SopClass kNuclearMedicineImageStorageRetired = const SopClass(
      '1.2.840.10008.5.1.4.1.1.20',
      'NuclearMedicineImageStorage',
      UidType.kSOPClass,
      'Nuclear Medicine Image Storage');
  static const SopClass kRawDataStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.66',
      'RawDataStorage',
      UidType.kSOPClass,
      'Raw Data Storage');
  static const SopClass kSpatialRegistrationStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.66.1',
      'SpatialRegistrationStorage',
      UidType.kSOPClass,
      'Spatial Registration Storage');
  static const SopClass kSpatialFiducialsStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.66.2',
      'SpatialFiducialsStorage',
      UidType.kSOPClass,
      'Spatial Fiducials Storage');
  static const SopClass kDeformableSpatialRegistrationStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.66.3',
      'DeformableSpatialRegistrationStorage',
      UidType.kSOPClass,
      'Deformable Spatial Registration Storage');
  static const SopClass kSegmentationStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.66.4',
      'SegmentationStorage',
      UidType.kSOPClass,
      'Segmentation Storage');
  static const SopClass kSurfaceSegmentationStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.66.5',
      'SurfaceSegmentationStorage',
      UidType.kSOPClass,
      'Surface Segmentation Storage');
  static const SopClass kRealWorldValueMappingStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.67',
      'RealWorldValueMappingStorage',
      UidType.kSOPClass,
      'Real World Value Mapping Storage');
  static const SopClass kSurfaceScanMeshStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.68.1',
      'SurfaceScanMeshStorage',
      UidType.kSOPClass,
      'Surface Scan Mesh Storage');
  static const SopClass kSurfaceScanPointCloudStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.68.2',
      'SurfaceScanPointCloudStorage',
      UidType.kSOPClass,
      'Surface Scan Point Cloud Storage');
  static const SopClass kVLImageStorageTrial = const SopClass(
      '1.2.840.10008.5.1.4.1.1.77.1',
      'VLImageStorage_Trial_Retired',
      UidType.kSOPClass,
      'VL Image Storage - Trial (Retired)',
      isRetired: true);
  static const SopClass kVLMultiFrameImageStorageTrial = const SopClass(
      '1.2.840.10008.5.1.4.1.1.77.2',
      'VLMulti_frameImageStorage_Trial_Retired',
      UidType.kSOPClass,
      'VL Multi-frame Image Storage - Trial (Retired)',
      isRetired: true);
  static const SopClass kVLEndoscopicImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.77.1.1',
      'VLEndoscopicImageStorage',
      UidType.kSOPClass,
      'VL Endoscopic Image Storage');
  static const SopClass kVideoEndoscopicImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.77.1.1.1',
      'VideoEndoscopicImageStorage',
      UidType.kSOPClass,
      'Video Endoscopic Image Storage');
  static const SopClass kVLMicroscopicImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.77.1.2',
      'VLMicroscopicImageStorage',
      UidType.kSOPClass,
      'VL Microscopic Image Storage');
  static const SopClass kVideoMicroscopicImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.77.1.2.1',
      'VideoMicroscopicImageStorage',
      UidType.kSOPClass,
      'Video Microscopic Image Storage');
  static const SopClass kVLSlideCoordinatesMicroscopicImageStorage =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.77.1.3',
    'VLSlide_CoordinatesMicroscopicImageStorage',
    UidType.kSOPClass,
    'VL Slide-Coordinates Microscopic Image Storage',
  );
  static const SopClass kVLPhotographicImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.77.1.4',
      'VLPhotographicImageStorage',
      UidType.kSOPClass,
      'VL Photographic Image Storage');
  static const SopClass kVideoPhotographicImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.77.1.4.1',
      'VideoPhotographicImageStorage',
      UidType.kSOPClass,
      'Video Photographic Image Storage');
  static const SopClass kOphthalmicPhotography8BitImageStorage = const SopClass(
    '1.2.840.10008.5.1.4.1.1.77.1.5.1',
    'OphthalmicPhotography8BitImageStorage',
    UidType.kSOPClass,
    'Ophthalmic Photography 8 Bit Image Storage',
  );
  static const SopClass kOphthalmicPhotography16BitImageStorage =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.77.1.5.2',
    'OphthalmicPhotography16BitImageStorage',
    UidType.kSOPClass,
    'Ophthalmic Photography 16 Bit Image Storage',
  );
  static const SopClass kStereometricRelationshipStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.77.1.5.3',
      'StereometricRelationshipStorage',
      UidType.kSOPClass,
      'Stereometric Relationship Storage');
  static const SopClass kOphthalmicTomographyImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.77.1.5.4',
      'OphthalmicTomographyImageStorage',
      UidType.kSOPClass,
      'Ophthalmic Tomography Image Storage');
  static const SopClass kVLWholeSlideMicroscopyImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.77.1.6',
      'VLWholeSlideMicroscopyImageStorage',
      UidType.kSOPClass,
      'VL Whole Slide Microscopy Image Storage');
  static const SopClass kLensometryMeasurementsStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.78.1',
      'LensometryMeasurementsStorage',
      UidType.kSOPClass,
      'Lensometry Measurements Storage');
  static const SopClass kAutorefractionMeasurementsStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.78.2',
      'AutorefractionMeasurementsStorage',
      UidType.kSOPClass,
      'Autorefraction Measurements Storage');
  static const SopClass kKeratometryMeasurementsStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.78.3',
      'KeratometryMeasurementsStorage',
      UidType.kSOPClass,
      'Keratometry Measurements Storage');
  static const SopClass kSubjectiveRefractionMeasurementsStorage =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.78.4',
    'SubjectiveRefractionMeasurementsStorage',
    UidType.kSOPClass,
    'Subjective Refraction Measurements Storage',
  );
  static const SopClass kVisualAcuityMeasurementsStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.78.5',
      'VisualAcuityMeasurementsStorage',
      UidType.kSOPClass,
      'Visual Acuity Measurements Storage');
  static const SopClass kSpectaclePrescriptionReportStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.78.6',
      'SpectaclePrescriptionReportStorage',
      UidType.kSOPClass,
      'Spectacle Prescription Report Storage');
  static const SopClass kOphthalmicAxialMeasurementsStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.78.7',
      'OphthalmicAxialMeasurementsStorage',
      UidType.kSOPClass,
      'Ophthalmic Axial Measurements Storage');
  static const SopClass kIntraocularLensCalculationsStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.78.8',
      'IntraocularLensCalculationsStorage',
      UidType.kSOPClass,
      'Intraocular Lens Calculations Storage');
  static const SopClass kMacularGridThicknessandVolumeReportStorage =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.79.1',
    'MacularGridThicknessandVolumeReportStorage',
    UidType.kSOPClass,
    'Macular Grid Thickness and Volume Report Storage',
  );
  static const SopClass
      kOphthalmicVisualFieldStaticPerimetryMeasurementsStorage = const SopClass(
    '1.2.840.10008.5.1.4.1.1.80.1',
    'OphthalmicVisualFieldStaticPerimetryMeasurementsStorage',
    UidType.kSOPClass,
    'Ophthalmic Visual Field Static Perimetry Measurements Storage',
  );
  static const SopClass kOphthalmicThicknessMapStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.81.1',
      'OphthalmicThicknessMapStorage',
      UidType.kSOPClass,
      'Ophthalmic Thickness Map Storage');
  static const SopClass kCornealTopographyMapStorage = const SopClass(
      '11.2.840.10008.5.1.4.1.1.82.1',
      'CornealTopographyMapStorage',
      UidType.kSOPClass,
      'Corneal Topography Map Storage');
  static const SopClass kTextSRStorageTrial = const SopClass(
      '1.2.840.10008.5.1.4.1.1.88.1',
      'TextSRStorage_Trial_Retired',
      UidType.kSOPClass,
      'Text SR Storage - Trial (Retired)',
      isRetired: true);
  static const SopClass kAudioSRStorageTrial = const SopClass(
      '1.2.840.10008.5.1.4.1.1.88.2',
      'AudioSRStorage_Trial_Retired',
      UidType.kSOPClass,
      'Audio SR Storage - Trial (Retired)',
      isRetired: true);
  static const SopClass kDetailSRStorageTrial = const SopClass(
      '1.2.840.10008.5.1.4.1.1.88.3',
      'DetailSRStorage_Trial_Retired',
      UidType.kSOPClass,
      'Detail SR Storage - Trial (Retired)',
      isRetired: true);
  static const SopClass kComprehensiveSRStorageTrial = const SopClass(
      '1.2.840.10008.5.1.4.1.1.88.4',
      'ComprehensiveSRStorage_Trial_Retired',
      UidType.kSOPClass,
      'Comprehensive SR Storage - Trial (Retired)',
      isRetired: true);
  static const SopClass kBasicTextSRStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.88.11',
      'BasicTextSRStorage',
      UidType.kSOPClass,
      'Basic Text SR Storage');
  static const SopClass kEnhancedSRStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.88.22',
      'EnhancedSRStorage',
      UidType.kSOPClass,
      'Enhanced SR Storage');
  static const SopClass kComprehensiveSRStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.88.33',
      'ComprehensiveSRStorage',
      UidType.kSOPClass,
      'Comprehensive SR Storage');
  static const SopClass kComprehensive3DSRStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.88.34',
      'Comprehensive3DSRStorage',
      UidType.kSOPClass,
      'Comprehensive 3D SR Storage');
  static const SopClass kProcedureLogStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.88.40',
      'ProcedureLogStorage',
      UidType.kSOPClass,
      'Procedure Log Storage');
  static const SopClass kMammographyCADSRStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.88.50',
      'MammographyCADSRStorage',
      UidType.kSOPClass,
      'Mammography CAD SR Storage');
  static const SopClass kKeyObjectSelectionDocumentStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.88.59',
      'KeyObjectSelectionDocumentStorage',
      UidType.kSOPClass,
      'Key Object Selection Document Storage');
  static const SopClass kChestCADSRStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.88.65',
      'ChestCADSRStorage',
      UidType.kSOPClass,
      'Chest CAD SR Storage');
  static const SopClass kXRayRadiationDoseSRStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.88.67',
      'X_RayRadiationDoseSRStorage',
      UidType.kSOPClass,
      'X-Ray Radiation Dose SR Storage');
  static const SopClass kColonCADSRStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.88.69',
      'ColonCADSRStorage',
      UidType.kSOPClass,
      'Colon CAD SR Storage');
  static const SopClass kImplantationPlanSRStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.88.70',
      'ImplantationPlanSRStorage',
      UidType.kSOPClass,
      'Implantation Plan SR Storage');
  static const SopClass kEncapsulatedPDFStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.104.1',
      'EncapsulatedPDFStorage',
      UidType.kSOPClass,
      'Encapsulated PDF Storage');
  static const SopClass kEncapsulatedCDAStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.104.2',
      'EncapsulatedCDAStorage',
      UidType.kSOPClass,
      'Encapsulated CDA Storage');
  static const SopClass kPositronEmissionTomographyImageStorage =
      const SopClass(
          '1.2.840.10008.5.1.4.1.1.128',
          'PositronEmissionTomographyImageStorage',
          UidType.kSOPClass,
          'Positron Emission Tomography Image Storage');
  static const SopClass kLegacyConvertedEnhancedPETImageStorage =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.128.1',
    'LegacyConvertedEnhancedPETImageStorage',
    UidType.kSOPClass,
    'Legacy Converted Enhanced PET Image Storage',
  );
  static const SopClass kStandalonePETCurveStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.129',
      'StandalonePETCurveStorage_Retired',
      UidType.kSOPClass,
      'Standalone PET Curve Storage (Retired)',
      isRetired: true);
  static const SopClass kEnhancedPETImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.130',
      'EnhancedPETImageStorage',
      UidType.kSOPClass,
      'Enhanced PET Image Storage');
  static const SopClass kBasicStructuredDisplayStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.131',
      'BasicStructuredDisplayStorage',
      UidType.kSOPClass,
      'Basic Structured Display Storage');
  static const SopClass kRTImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.481.1',
      'RTImageStorage',
      UidType.kSOPClass,
      'RT Image Storage');
  static const SopClass kRTDoseStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.481.2',
      'RTDoseStorage',
      UidType.kSOPClass,
      'RT Dose Storage');
  static const SopClass kRTStructureSetStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.481.3',
      'RTStructureSetStorage',
      UidType.kSOPClass,
      'RT Structure Set Storage');
  static const SopClass kRTBeamsTreatmentRecordStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.481.4',
      'RTBeamsTreatmentRecordStorage',
      UidType.kSOPClass,
      'RT Beams Treatment Record Storage');
  static const SopClass kRTPlanStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.481.5',
      'RTPlanStorage',
      UidType.kSOPClass,
      'RT Plan Storage');
  static const SopClass kRTBrachyTreatmentRecordStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.481.6',
      'RTBrachyTreatmentRecordStorage',
      UidType.kSOPClass,
      'RT Brachy Treatment Record Storage');
  static const SopClass kRTTreatmentSummaryRecordStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.481.7',
      'RTTreatmentSummaryRecordStorage',
      UidType.kSOPClass,
      'RT Treatment Summary Record Storage');
  static const SopClass kRTIonPlanStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.481.8',
      'RTIonPlanStorage',
      UidType.kSOPClass,
      'RT Ion Plan Storage');
  static const SopClass kRTIonBeamsTreatmentRecordStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.481.9',
      'RTIonBeamsTreatmentRecordStorage',
      UidType.kSOPClass,
      'RT Ion Beams Treatment Record Storage');
  static const SopClass kDICOSCTImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.501.1',
      'DICOSCTImageStorage',
      UidType.kSOPClass,
      'DICOS CT Image Storage');
  static const SopClass kDICOSDigitalXRayImageStorageForPresentation =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.501.2.1',
    'DICOSDigitalX_RayImageStorage_ForPresentation',
    UidType.kSOPClass,
    'DICOS Digital X-Ray Image Storage - For Presentation',
  );
  static const SopClass kDICOSDigitalXRayImageStorageForProcessing =
      const SopClass(
    '1.2.840.10008.5.1.4.1.1.501.2.2',
    'DICOSDigitalX_RayImageStorage_ForProcessing',
    UidType.kSOPClass,
    'DICOS Digital X-Ray Image Storage - For Processing',
  );
  static const SopClass kDICOSThreatDetectionReportStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.501.3',
      'DICOSThreatDetectionReportStorage',
      UidType.kSOPClass,
      'DICOS Threat Detection Report Storage');
  static const SopClass kDICOS2DAITStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.501.4',
      'DICOS2DAITStorage',
      UidType.kSOPClass,
      'DICOS 2D AIT Storage');
  static const SopClass kDICOS3DAITStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.501.5',
      'DICOS3DAITStorage',
      UidType.kSOPClass,
      'DICOS 3D AIT Storage');
  static const SopClass kDICOSQuadrupoleResonanceStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.501.6',
      'DICOSQuadrupoleResonanceStorage',
      UidType.kSOPClass,
      'DICOS Quadrupole Resonance (QR) Storage');
  static const SopClass kEddyCurrentImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.601.1',
      'EddyCurrentImageStorage',
      UidType.kSOPClass,
      'Eddy Current Image Storage');

  static const SopClass kEddyCurrentMultiFrameImageStorage = const SopClass(
      '1.2.840.10008.5.1.4.1.1.601.2',
      'EddyCurrentMulti_frameImageStorage',
      UidType.kSOPClass,
      'Eddy Current Multi-frame Image Storage');
  static const SopClass kPatientRootQueryRetrieveInformationModelFIND =
      const SopClass(
    '1.2.840.10008.5.1.4.1.2.1.1',
    'PatientRootQueryRetrieveInformationModel_FIND',
    UidType.kSOPClass,
    'Patient Root Query/Retrieve Information Model - FIND',
  );
  static const SopClass kPatientRootQueryRetrieveInformationModelMOVE =
      const SopClass(
    '1.2.840.10008.5.1.4.1.2.1.2',
    'PatientRootQueryRetrieveInformationModel_MOVE',
    UidType.kSOPClass,
    'Patient Root Query/Retrieve Information Model - MOVE',
  );
  static const SopClass kPatientRootQueryRetrieveInformationModelGET =
      const SopClass(
    '1.2.840.10008.5.1.4.1.2.1.3',
    'PatientRootQueryRetrieveInformationModel_GET',
    UidType.kSOPClass,
    'Patient Root Query/Retrieve Information Model - GET',
  );
  static const SopClass kStudyRootQueryRetrieveInformationModelFIND =
      const SopClass(
    '1.2.840.10008.5.1.4.1.2.2.1',
    'StudyRootQueryRetrieveInformationModel_FIND',
    UidType.kSOPClass,
    'Study Root Query/Retrieve Information Model - FIND',
  );
  static const SopClass kStudyRootQueryRetrieveInformationModelMOVE =
      const SopClass(
    '1.2.840.10008.5.1.4.1.2.2.2',
    'StudyRootQueryRetrieveInformationModel_MOVE',
    UidType.kSOPClass,
    'Study Root Query/Retrieve Information Model - MOVE',
  );
  static const SopClass kStudyRootQueryRetrieveInformationModelGET =
      const SopClass(
    '1.2.840.10008.5.1.4.1.2.2.3',
    'StudyRootQueryRetrieveInformationModel_GET',
    UidType.kSOPClass,
    'Study Root Query/Retrieve Information Model - GET',
  );
  static const SopClass kPatientStudyOnlyQueryRetrieveInformationModelFIND =
      const SopClass(
          '1.2.840.10008.5.1.4.1.2.3.1',
          'Patient_StudyOnlyQueryRetrieveInformationModel_FIND_Retired',
          UidType.kSOPClass,
          'Patient/Study Only Query/Retrieve Information Model - FIND (Retired)',
          isRetired: true);
  static const SopClass kPatientStudyOnlyQueryRetrieveInformationModelMOVE =
      const SopClass(
          '1.2.840.10008.5.1.4.1.2.3.2',
          'Patient_StudyOnlyQueryRetrieveInformationModel_MOVE_Retired',
          UidType.kSOPClass,
          'Patient/Study Only Query/Retrieve Information Model - MOVE (Retired)',
          isRetired: true);
  static const SopClass kPatientStudyOnlyQueryRetrieveInformationModelGET =
      const SopClass(
          '1.2.840.10008.5.1.4.1.2.3.3',
          'Patient_StudyOnlyQueryRetrieveInformationModel_GET_Retired',
          UidType.kSOPClass,
          'Patient/Study Only Query/Retrieve Information Model - GET (Retired)',
          isRetired: true);
  static const SopClass kCompositeInstanceRootRetrieveMOVE = const SopClass(
      '1.2.840.10008.5.1.4.1.2.4.2',
      'CompositeInstanceRootRetrieve_MOVE',
      UidType.kSOPClass,
      'Composite Instance Root Retrieve - MOVE');
  static const SopClass kCompositeInstanceRootRetrieveGET = const SopClass(
      '1.2.840.10008.5.1.4.1.2.4.3',
      'CompositeInstanceRootRetrieve_GET',
      UidType.kSOPClass,
      'Composite Instance Root Retrieve - GET');
  static const SopClass kCompositeInstanceRetrieveWithoutBulkDataGET =
      const SopClass(
    '1.2.840.10008.5.1.4.1.2.5.3',
    'CompositeInstanceRetrieveWithoutBulkData_GET',
    UidType.kSOPClass,
    'Composite Instance Retrieve Without Bulk Data - GET',
  );
  static const SopClass kModalityWorklistInformationModelFIND = const SopClass(
      '1.2.840.10008.5.1.4.31',
      'ModalityWorklistInformationModel_FIND',
      UidType.kSOPClass,
      'Modality Worklist Information Model - FIND');
  static const SopClass kGeneralPurposeWorklistInformationModelFIND =
      const SopClass(
          '1.2.840.10008.5.1.4.32.1',
          'GeneralPurposeWorklistInformationModel_FIND_Retired',
          UidType.kSOPClass,
          'General Purpose Worklist Information Model - FIND (Retired)',
          isRetired: true);
  static const SopClass kGeneralPurposeScheduledProcedureStep = const SopClass(
      '1.2.840.10008.5.1.4.32.2',
      'GeneralPurposeScheduledProcedureStepSOPClass_Retired',
      UidType.kSOPClass,
      'General Purpose Scheduled Procedure Step SOP Class (Retired)',
      isRetired: true);
  static const SopClass kGeneralPurposePerformedProcedureStep = const SopClass(
      '1.2.840.10008.5.1.4.32.3',
      'GeneralPurposePerformedProcedureStepSOPClassRetired',
      UidType.kSOPClass,
      'General Purpose Performed Procedure Step SOP Class (Retired)',
      isRetired: true);
  static const SopClass kGeneralPurposeWorklistManagement = const SopClass(
      '1.2.840.10008.5.1.4.32',
      'GeneralPurposeWorklistManagementMetaSOPClass_Retired',
      UidType.kMetaSOPClass,
      'General Purpose Worklist Management Meta SOP Class (Retired)',
      isRetired: true);
  static const SopClass kInstanceAvailabilityNotification = const SopClass(
      '1.2.840.10008.5.1.4.33',
      'InstanceAvailabilityNotificationSOPClass',
      UidType.kSOPClass,
      'Instance Availability Notification SOP Class');
  static const SopClass kRTBeamsDeliveryInstructionStorageTrial =
      const SopClass(
          '1.2.840.10008.5.1.4.34.1',
          'RTBeamsDeliveryInstructionStorage_Trial_Retired',
          UidType.kSOPClass,
          'RT Beams Delivery Instruction Storage - Trial (Retired)',
          isRetired: true);
  static const SopClass kRTConventionalMachineVerificationTrial =
      const SopClass(
          '1.2.840.10008.5.1.4.34.2',
          'RTConventionalMachineVerification_Trial_Retired',
          UidType.kSOPClass,
          'RT Conventional Machine Verification - Trial (Retired)',
          isRetired: true);
  static const SopClass kRTIonMachineVerificationTrial = const SopClass(
      '1.2.840.10008.5.1.4.34.3',
      'RTIonMachineVerification_Trial_Retired',
      UidType.kSOPClass,
      'RT Ion Machine Verification - Trial (Retired)',
      isRetired: true);
  static const SopClass kUnifiedWorklistAndProcedureStepServiceClassTrial =
      const SopClass(
          '1.2.840.10008.5.1.4.34.4',
          'UnifiedWorklistandProcedureStepServiceClass_Trial_Retired',
          UidType.kServiceClass,
          'Unified Worklist and Procedure Step Service Class - Trial (Retired)',
          isRetired: true);
  static const SopClass kUnifiedProcedureStepPushSOPClassTrial = const SopClass(
      '1.2.840.10008.5.1.4.34.4.1',
      'UnifiedProcedureStep_PushSOPClass_Trial_Retired',
      UidType.kSOPClass,
      'Unified Procedure Step - Push SOP Class - Trial (Retired)',
      isRetired: true);
  static const SopClass kUnifiedProcedureStepWatchSOPClassTrial =
      const SopClass(
          '1.2.840.10008.5.1.4.34.4.2',
          'UnifiedProcedureStep_WatchSOPClass_Trial_Retired',
          UidType.kSOPClass,
          'Unified Procedure Step - Watch SOP Class - Trial (Retired)',
          isRetired: true);
  static const SopClass kUnifiedProcedureStepPullSOPClassTrial = const SopClass(
      '1.2.840.10008.5.1.4.34.4.3',
      'UnifiedProcedureStep_PullSOPClass_Trial_Retired',
      UidType.kSOPClass,
      'Unified Procedure Step - Pull SOP Class - Trial (Retired)',
      isRetired: true);
  static const SopClass kUnifiedProcedureStepEventSOPClassTrial =
      const SopClass(
          '1.2.840.10008.5.1.4.34.4.4',
          'UnifiedProcedureStep_EventSOPClass_Trial_Retired',
          UidType.kSOPClass,
          'Unified Procedure Step - Event SOP Class - Trial (Retired)',
          isRetired: true);
  static const SopClass kUnifiedProcedureStepPush = const SopClass(
      '1.2.840.10008.5.1.4.34.6.1',
      'UnifiedProcedureStep_PushSOPClass',
      UidType.kSOPClass,
      'Unified Procedure Step - Push SOP Class');
  static const SopClass kUnifiedProcedureStepWatch = const SopClass(
      '1.2.840.10008.5.1.4.34.6.2',
      'UnifiedProcedureStep_WatchSOPClass',
      UidType.kSOPClass,
      'Unified Procedure Step - Watch SOP Class');
  static const SopClass kUnifiedProcedureStepPull = const SopClass(
      '1.2.840.10008.5.1.4.34.6.3',
      'UnifiedProcedureStep_PullSOPClass',
      UidType.kSOPClass,
      'Unified Procedure Step - Pull SOP Class');
  static const SopClass kUnifiedProcedureStepEvent = const SopClass(
      '1.2.840.10008.5.1.4.34.6.4',
      'UnifiedProcedureStep_EventSOPClass',
      UidType.kSOPClass,
      'Unified Procedure Step - Event SOP Class');
  static const SopClass kRTBeamsDeliveryInstructionStorage = const SopClass(
      '1.2.840.10008.5.1.4.34.7',
      'RTBeamsDeliveryInstructionStorage',
      UidType.kSOPClass,
      'RT Beams Delivery Instruction Storage');
  static const SopClass kRTConventionalMachineVerification = const SopClass(
      '1.2.840.10008.5.1.4.34.8',
      'RTConventionalMachineVerification',
      UidType.kSOPClass,
      'RT Conventional Machine Verification');
  static const SopClass kRTIonMachineVerification = const SopClass(
      '1.2.840.10008.5.1.4.34.9',
      'RTIonMachineVerification',
      UidType.kSOPClass,
      'RT Ion Machine Verification');
  static const SopClass kGeneralRelevantPatientInformationQuery =
      const SopClass(
          '1.2.840.10008.5.1.4.37.1',
          'GeneralRelevantPatientInformationQuery',
          UidType.kSOPClass,
          'General Relevant Patient Information Query');
  static const SopClass kBreastImagingRelevantPatientInformationQuery =
      const SopClass(
    '1.2.840.10008.5.1.4.37.2',
    'BreastImagingRelevantPatientInformationQuery',
    UidType.kSOPClass,
    'Breast Imaging Relevant Patient Information Query',
  );
  static const SopClass kCardiacRelevantPatientInformationQuery =
      const SopClass(
          '1.2.840.10008.5.1.4.37.3',
          'CardiacRelevantPatientInformationQuery',
          UidType.kSOPClass,
          'Cardiac Relevant Patient Information Query');
  static const SopClass kHangingProtocolStorage = const SopClass(
      '1.2.840.10008.5.1.4.38.1',
      'HangingProtocolStorage',
      UidType.kSOPClass,
      'Hanging Protocol Storage');
  static const SopClass kHangingProtocolInformationModelFIND = const SopClass(
      '1.2.840.10008.5.1.4.38.2',
      'HangingProtocolInformationModel_FIND',
      UidType.kSOPClass,
      'Hanging Protocol Information Model - FIND');
  static const SopClass kHangingProtocolInformationModelMOVE = const SopClass(
      '1.2.840.10008.5.1.4.38.3',
      'HangingProtocolInformationModel_MOVE',
      UidType.kSOPClass,
      'Hanging Protocol Information Model - MOVE');
  static const SopClass kHangingProtocolInformationModelGET = const SopClass(
      '1.2.840.10008.5.1.4.38.4',
      'HangingProtocolInformationModel_GET',
      UidType.kSOPClass,
      'Hanging Protocol Information Model - GET');
  static const SopClass kColorPaletteStorage = const SopClass(
      '1.2.840.10008.5.1.4.39.1',
      'ColorPaletteStorage',
      UidType.kSOPClass,
      'Color Palette Storage');

  static const SopClass kColorPaletteInformationModelFIND = const SopClass(
      '1.2.840.10008.5.1.4.39.2',
      'ColorPaletteInformationModel_FIND',
      UidType.kSOPClass,
      'Color Palette Information Model - FIND');

  static const SopClass kColorPaletteInformationModelMOVE = const SopClass(
      '1.2.840.10008.5.1.4.39.3',
      'ColorPaletteInformationModel_MOVE',
      UidType.kSOPClass,
      'Color Palette Information Model - MOVE');

  static const SopClass kColorPaletteInformationModelGET = const SopClass(
      '1.2.840.10008.5.1.4.39.4',
      'ColorPaletteInformationModel_GET',
      UidType.kSOPClass,
      'Color Palette Information Model - GET');

  static const SopClass kProductCharacteristicsQuery = const SopClass(
      '1.2.840.10008.5.1.4.41',
      'ProductCharacteristicsQuerySOPClass',
      UidType.kSOPClass,
      'Product Characteristics Query SOP Class');
  static const SopClass kSubstanceApprovalQuery = const SopClass(
      '1.2.840.10008.5.1.4.42',
      'SubstanceApprovalQuerySOPClass',
      UidType.kSOPClass,
      'Substance Approval Query SOP Class');
  static const SopClass kGenericImplantTemplateStorage = const SopClass(
      '1.2.840.10008.5.1.4.43.1',
      'GenericImplantTemplateStorage',
      UidType.kSOPClass,
      'Generic Implant Template Storage');
  static const SopClass kGenericImplantTemplateInformationModelFIND =
      const SopClass(
    '1.2.840.10008.5.1.4.43.2',
    'GenericImplantTemplateInformationModel_FIND',
    UidType.kSOPClass,
    'Generic Implant Template Information Model - FIND',
  );
  static const SopClass kGenericImplantTemplateInformationModelMOVE =
      const SopClass(
    '1.2.840.10008.5.1.4.43.3',
    'GenericImplantTemplateInformationModel_MOVE',
    UidType.kSOPClass,
    'Generic Implant Template Information Model - MOVE',
  );
  static const SopClass kGenericImplantTemplateInformationModelGET =
      const SopClass(
          '1.2.840.10008.5.1.4.43.4',
          'GenericImplantTemplateInformationModel_GET',
          UidType.kSOPClass,
          'Generic Implant Template Information Model - GET');
  static const SopClass kImplantAssemblyTemplateStorage = const SopClass(
      '1.2.840.10008.5.1.4.44.1',
      'ImplantAssemblyTemplateStorage',
      UidType.kSOPClass,
      'Implant Assembly Template Storage');
  static const SopClass kImplantAssemblyTemplateInformationModelFIND =
      const SopClass(
    '1.2.840.10008.5.1.4.44.2',
    'ImplantAssemblyTemplateInformationModel_FIND',
    UidType.kSOPClass,
    'Implant Assembly Template Information Model - FIND',
  );
  static const SopClass kImplantAssemblyTemplateInformationModelMOVE =
      const SopClass(
    '1.2.840.10008.5.1.4.44.3',
    'ImplantAssemblyTemplateInformationModel_MOVE',
    UidType.kSOPClass,
    'Implant Assembly Template Information Model - MOVE',
  );
  static const SopClass kImplantAssemblyTemplateInformationModelGET =
      const SopClass(
    '1.2.840.10008.5.1.4.44.4',
    'ImplantAssemblyTemplateInformationModel_GET',
    UidType.kSOPClass,
    'Implant Assembly Template Information Model - GET',
  );
  static const SopClass kImplantTemplateGroupStorage = const SopClass(
      '1.2.840.10008.5.1.4.45.1',
      'ImplantTemplateGroupStorage',
      UidType.kSOPClass,
      'Implant Template Group Storage');
  static const SopClass kImplantTemplateGroupInformationModelFIND =
      const SopClass(
          '1.2.840.10008.5.1.4.45.2',
          'ImplantTemplateGroupInformationModel_FIND',
          UidType.kSOPClass,
          'Implant Template Group Information Model - FIND');
  static const SopClass kImplantTemplateGroupInformationModelMOVE =
      const SopClass(
          '1.2.840.10008.5.1.4.45.3',
          'ImplantTemplateGroupInformationModel_MOVE',
          UidType.kSOPClass,
          'Implant Template Group Information Model - MOVE');
  static const SopClass kImplantTemplateGroupInformationModelGET =
      const SopClass(
          '1.2.840.10008.5.1.4.45.4',
          'ImplantTemplateGroupInformationModel_GET',
          UidType.kSOPClass,
          'Implant Template Group Information Model - GET');

  static const SopClass kDicomSOPClass = const SopClass(
      '1.2.840.10008.15.0.3.14',
      'dicomSOPClass',
      UidType.kLdapOid,
      'dicomSOPClass');


  static const List<SopClass> members = const <SopClass>[
    kVerification,
    kMediaStorageDirectoryStorage,
    kBasicStudyContentNotification,
    kStorageCommitmentPushModel,
    kStorageCommitmentPullModel,
    kProceduralEventLogging,
    kSubstanceAdministrationLogging,
    kDetachedPatientManagement,
    kDetachedVisitManagement,
    kDetachedStudyManagement,
    kStudyComponentManagement,
    kModalityPerformedProcedureStep,
    kModalityPerformedProcedureStepRetrieve,
    kModalityPerformedProcedureStepNotification,
    kDetachedResultsManagement,
    kDetachedInterpretationManagement,
    kBasicFilmSession,
    kBasicFilmBox,
    kBasicGrayscaleImageBox,
    kBasicColorImageBox,
    kReferencedImageBox,
    kPrintJob,
    kBasicAnnotationBox,
    kPrinter,
    kPrinterConfigurationRetrieval,
    kVOILUTBox,
    kPresentationLUT,
    kImageOverlayBox,
    kBasicPrintImageOverlayBox,
    kPrintQueueManagement,
    kStoredPrintStorage,
    kHardcopyGrayscaleImageStorage,
    kHardcopyColorImageStorage,
    kPullPrintRequest,
    kMediaCreationManagementSOPClassUID,
    kComputedRadiographyImageStorage,
    kDigitalXRayImageStorageForPresentation,
    kDigitalXRayImageStorageForProcessing,
    kDigitalMammographyXRayImageStorageForPresentation,
    kDigitalMammographyXRayImageStorageForProcessing,
    kDigitalIntraOralXRayImageStorageForPresentation,
    kDigitalIntraOralXRayImageStorageForProcessing,
    kCTImageStorage,
    kEnhancedCTImageStorage,
    kLegacyConvertedEnhancedCTImageStorage,
    kUltrasoundMultiFrameImageStorage,
    kUltrasoundMultiFrameImageStorage,
    kMRImageStorage,
    kEnhancedMRImageStorage,
    kMRSpectroscopyStorage,
    kEnhancedMRColorImageStorage,
    kLegacyConvertedEnhancedMRImageStorage,
    kNuclearMedicineImageStorage,
    kUltrasoundImageStorage,
    kUltrasoundImageStorage,
    kEnhancedUSVolumeStorage,
    kSecondaryCaptureImageStorage,
    kMultiFrameSingleBitSecondaryCaptureImageStorage,
    kMultiFrameGrayscaleByteSecondaryCaptureImageStorage,
    kMultiFrameGrayscaleWordSecondaryCaptureImageStorage,
    kMultiFrameTrueColorSecondaryCaptureImageStorage,
    kStandaloneOverlayStorage,
    kStandaloneCurveStorage,
    kWaveformStorageTrial,
    kTwelvelead12ECGWaveformStorage,
    kGeneralECGWaveformStorage,
    kAmbulatoryECGWaveformStorage,
    kHemodynamicWaveformStorage,
    kCardiacElectrophysiologyWaveformStorage,
    kBasicVoiceAudioWaveformStorage,
    kGeneralAudioWaveformStorage,
    kArterialPulseWaveformStorage,
    kRespiratoryWaveformStorage,
    kStandaloneModalityLUTStorage,
    kStandaloneVOILUTStorage,
    kGrayscaleSoftcopyPresentationStateStorage,
    kColorSoftcopyPresentationStateStorage,
    kPseudoColorSoftcopyPresentationStateStorage,
    kBlendingSoftcopyPresentationStateStorage,
    kXAXRFGrayscaleSoftcopyPresentationStateStorage,
    kXRayAngiographicImageStorage,
    kEnhancedXAImageStorage,
    kXRayRadiofluoroscopicImageStorage,
    kEnhancedXRFImageStorage,
    kXRayAngiographicBiPlaneImageStorage,
    kXRay3DAngiographicImageStorage,
    kXRay3DCraniofacialImageStorage,
    kBreastTomosynthesisImageStorage,
    kIntravascularOpticalCoherenceTomographyImageStorageForPresentation,
    kIntravascularOpticalCoherenceTomographyImageStorageForProcessing,
    kNuclearMedicineImageStorageRetired,
    kRawDataStorage,
    kSpatialRegistrationStorage,
    kSpatialFiducialsStorage,
    kDeformableSpatialRegistrationStorage,
    kSegmentationStorage,
    kSurfaceSegmentationStorage,
    kRealWorldValueMappingStorage,
    kSurfaceScanMeshStorage,
    kSurfaceScanPointCloudStorage,
    kVLImageStorageTrial,
    kVLMultiFrameImageStorageTrial,
    kVLEndoscopicImageStorage,
    kVideoEndoscopicImageStorage,
    kVLMicroscopicImageStorage,
    kVideoMicroscopicImageStorage,
    kVLSlideCoordinatesMicroscopicImageStorage,
    kVLPhotographicImageStorage,
    kVideoPhotographicImageStorage,
    kOphthalmicPhotography8BitImageStorage,
    kOphthalmicPhotography16BitImageStorage,
    kStereometricRelationshipStorage,
    kOphthalmicTomographyImageStorage,
    kVLWholeSlideMicroscopyImageStorage,
    kLensometryMeasurementsStorage,
    kAutorefractionMeasurementsStorage,
    kKeratometryMeasurementsStorage,
    kSubjectiveRefractionMeasurementsStorage,
    kVisualAcuityMeasurementsStorage,
    kSpectaclePrescriptionReportStorage,
    kOphthalmicAxialMeasurementsStorage,
    kIntraocularLensCalculationsStorage,
    kMacularGridThicknessandVolumeReportStorage,
    kOphthalmicVisualFieldStaticPerimetryMeasurementsStorage,
    kOphthalmicThicknessMapStorage,
    kCornealTopographyMapStorage,
    kTextSRStorageTrial,
    kAudioSRStorageTrial,
    kDetailSRStorageTrial,
    kComprehensiveSRStorageTrial,
    kBasicTextSRStorage,
    kEnhancedSRStorage,
    kComprehensiveSRStorage,
    kComprehensive3DSRStorage,
    kProcedureLogStorage,
    kMammographyCADSRStorage,
    kKeyObjectSelectionDocumentStorage,
    kChestCADSRStorage,
    kXRayRadiationDoseSRStorage,
    kColonCADSRStorage,
    kImplantationPlanSRStorage,
    kEncapsulatedPDFStorage,
    kEncapsulatedCDAStorage,
    kPositronEmissionTomographyImageStorage,
    kLegacyConvertedEnhancedPETImageStorage,
    kStandalonePETCurveStorage,
    kEnhancedPETImageStorage,
    kBasicStructuredDisplayStorage,
    kRTImageStorage,
    kRTDoseStorage,
    kRTStructureSetStorage,
    kRTBeamsTreatmentRecordStorage,
    kRTPlanStorage,
    kRTBrachyTreatmentRecordStorage,
    kRTTreatmentSummaryRecordStorage,
    kRTIonPlanStorage,
    kRTIonBeamsTreatmentRecordStorage,
    kDICOSCTImageStorage,
    kDICOSDigitalXRayImageStorageForPresentation,
    kDICOSDigitalXRayImageStorageForProcessing,
    kDICOSThreatDetectionReportStorage,
    kDICOS2DAITStorage,
    kDICOS3DAITStorage,
    kDICOSQuadrupoleResonanceStorage,
    kEddyCurrentImageStorage,
    kEddyCurrentMultiFrameImageStorage,
    kPatientRootQueryRetrieveInformationModelFIND,
    kPatientRootQueryRetrieveInformationModelMOVE,
    kPatientRootQueryRetrieveInformationModelGET,
    kStudyRootQueryRetrieveInformationModelFIND,
    kStudyRootQueryRetrieveInformationModelMOVE,
    kStudyRootQueryRetrieveInformationModelGET,
    kPatientStudyOnlyQueryRetrieveInformationModelFIND,
    kPatientStudyOnlyQueryRetrieveInformationModelMOVE,
    kPatientStudyOnlyQueryRetrieveInformationModelGET,
    kCompositeInstanceRootRetrieveMOVE,
    kCompositeInstanceRootRetrieveGET,
    kCompositeInstanceRetrieveWithoutBulkDataGET,
    kModalityWorklistInformationModelFIND,
    kGeneralPurposeWorklistInformationModelFIND,
    kGeneralPurposeScheduledProcedureStep,
    kGeneralPurposePerformedProcedureStep,
    kGeneralPurposeWorklistManagement,
    kInstanceAvailabilityNotification,
    kRTBeamsDeliveryInstructionStorageTrial,
    kRTConventionalMachineVerificationTrial,
    kRTIonMachineVerificationTrial,
    kUnifiedProcedureStepPushSOPClassTrial,
    kUnifiedProcedureStepWatchSOPClassTrial,
    kUnifiedProcedureStepPullSOPClassTrial,
    kUnifiedProcedureStepEventSOPClassTrial,
    kUnifiedProcedureStepPush,
    kUnifiedProcedureStepWatch,
    kUnifiedProcedureStepPull,
    kUnifiedProcedureStepEvent,
    kRTBeamsDeliveryInstructionStorage,
    kRTConventionalMachineVerification,
    kRTIonMachineVerification,
    kGeneralRelevantPatientInformationQuery,
    kBreastImagingRelevantPatientInformationQuery,
    kCardiacRelevantPatientInformationQuery,
    kHangingProtocolStorage,
    kHangingProtocolInformationModelFIND,
    kHangingProtocolInformationModelMOVE,
    kHangingProtocolInformationModelGET,
    kColorPaletteStorage,
    kColorPaletteInformationModelFIND,
    kColorPaletteInformationModelMOVE,
    kColorPaletteInformationModelGET,
    kProductCharacteristicsQuery,
    kSubstanceApprovalQuery,
    kGenericImplantTemplateStorage,
    kGenericImplantTemplateInformationModelFIND,
    kGenericImplantTemplateInformationModelMOVE,
    kGenericImplantTemplateInformationModelGET,
    kImplantAssemblyTemplateStorage,
    kImplantAssemblyTemplateInformationModelFIND,
    kImplantAssemblyTemplateInformationModelMOVE,
    kImplantAssemblyTemplateInformationModelGET,
    kImplantTemplateGroupStorage,
    kImplantTemplateGroupInformationModelFIND,
    kImplantTemplateGroupInformationModelMOVE,
    kImplantTemplateGroupInformationModelGET
  ];

  static const Map<String, SopClass> map = const <String, SopClass>{
    '1.2.840.10008.1.1': SopClass.kVerification,
    '1.2.840.10008.1.3.10': SopClass.kMediaStorageDirectoryStorage,
    '1.2.840.10008.1.9': SopClass.kBasicStudyContentNotification,
    '1.2.840.10008.1.20.1': SopClass.kStorageCommitmentPushModel,
    '1.2.840.10008.1.20.2': SopClass.kStorageCommitmentPullModel,
    '1.2.840.10008.1.40': SopClass.kProceduralEventLogging,
    '1.2.840.10008.1.42': SopClass.kSubstanceAdministrationLogging,
    '1.2.840.10008.3.1.2.1.1': SopClass.kDetachedPatientManagement,
    '1.2.840.10008.3.1.2.2.1': SopClass.kDetachedVisitManagement,
    '1.2.840.10008.3.1.2.3.1': SopClass.kDetachedStudyManagement,
    '1.2.840.10008.3.1.2.3.2': SopClass.kStudyComponentManagement,
    '1.2.840.10008.3.1.2.3.3': SopClass.kModalityPerformedProcedureStep,
    '1.2.840.10008.3.1.2.3.4': SopClass.kModalityPerformedProcedureStepRetrieve,
    '1.2.840.10008.3.1.2.3.5':
        SopClass.kModalityPerformedProcedureStepNotification,
    '1.2.840.10008.3.1.2.5.1': SopClass.kDetachedResultsManagement,
    '1.2.840.10008.3.1.2.6.1': SopClass.kDetachedInterpretationManagement,
    '1.2.840.10008.5.1.1.1': SopClass.kBasicFilmSession,
    '1.2.840.10008.5.1.1.2': SopClass.kBasicFilmBox,
    '1.2.840.10008.5.1.1.4': SopClass.kBasicGrayscaleImageBox,
    '1.2.840.10008.5.1.1.4.1': SopClass.kBasicColorImageBox,
    '1.2.840.10008.5.1.1.4.2': SopClass.kReferencedImageBox,
    '1.2.840.10008.5.1.1.14': SopClass.kPrintJob,
    '1.2.840.10008.5.1.1.15': SopClass.kBasicAnnotationBox,
    '1.2.840.10008.5.1.1.16': SopClass.kPrinter,
    '1.2.840.10008.5.1.1.16.376': SopClass.kPrinterConfigurationRetrieval,
    '1.2.840.10008.5.1.1.22': SopClass.kVOILUTBox,
    '1.2.840.10008.5.1.1.23': SopClass.kPresentationLUT,
    '1.2.840.10008.5.1.1.24': SopClass.kImageOverlayBox,
    '1.2.840.10008.5.1.1.24.1': SopClass.kBasicPrintImageOverlayBox,
    '1.2.840.10008.5.1.1.26': SopClass.kPrintQueueManagement,
    '1.2.840.10008.5.1.1.27': SopClass.kStoredPrintStorage,
    '1.2.840.10008.5.1.1.29': SopClass.kHardcopyGrayscaleImageStorage,
    '1.2.840.10008.5.1.1.30': SopClass.kHardcopyColorImageStorage,
    '1.2.840.10008.5.1.1.31': SopClass.kPullPrintRequest,
    '1.2.840.10008.5.1.1.33': SopClass.kMediaCreationManagementSOPClassUID,
    '1.2.840.10008.5.1.4.1.1.1': SopClass.kComputedRadiographyImageStorage,
    '1.2.840.10008.5.1.4.1.1.1.1':
        SopClass.kDigitalXRayImageStorageForPresentation,
    '1.2.840.10008.5.1.4.1.1.1.1.1':
        SopClass.kDigitalXRayImageStorageForProcessing,
    '1.2.840.10008.5.1.4.1.1.1.2':
        SopClass.kDigitalMammographyXRayImageStorageForPresentation,
    '1.2.840.10008.5.1.4.1.1.1.2.1':
        SopClass.kDigitalMammographyXRayImageStorageForProcessing,
    '1.2.840.10008.5.1.4.1.1.1.3':
        SopClass.kDigitalIntraOralXRayImageStorageForPresentation,
    '1.2.840.10008.5.1.4.1.1.1.3.1':
        SopClass.kDigitalIntraOralXRayImageStorageForProcessing,
    '1.2.840.10008.5.1.4.1.1.2': SopClass.kCTImageStorage,
    '1.2.840.10008.5.1.4.1.1.2.1': SopClass.kEnhancedCTImageStorage,
    '1.2.840.10008.5.1.4.1.1.2.2':
        SopClass.kLegacyConvertedEnhancedCTImageStorage,
    '1.2.840.10008.5.1.4.1.1.3': SopClass.kUltrasoundMultiFrameImageStorage,
    '1.2.840.10008.5.1.4.1.1.3.1': SopClass.kUltrasoundMultiFrameImageStorage,
    '1.2.840.10008.5.1.4.1.1.4': SopClass.kMRImageStorage,
    '1.2.840.10008.5.1.4.1.1.4.1': SopClass.kEnhancedMRImageStorage,
    '1.2.840.10008.5.1.4.1.1.4.2': SopClass.kMRSpectroscopyStorage,
    '1.2.840.10008.5.1.4.1.1.4.3': SopClass.kEnhancedMRColorImageStorage,
    '1.2.840.10008.5.1.4.1.1.4.4':
        SopClass.kLegacyConvertedEnhancedMRImageStorage,
    '1.2.840.10008.5.1.4.1.1.5': SopClass.kNuclearMedicineImageStorage,
    '1.2.840.10008.5.1.4.1.1.6': SopClass.kUltrasoundImageStorage,
    '1.2.840.10008.5.1.4.1.1.6.1': SopClass.kUltrasoundImageStorage,
    '1.2.840.10008.5.1.4.1.1.6.2': SopClass.kEnhancedUSVolumeStorage,
    '1.2.840.10008.5.1.4.1.1.7': SopClass.kSecondaryCaptureImageStorage,
    '1.2.840.10008.5.1.4.1.1.7.1':
        SopClass.kMultiFrameSingleBitSecondaryCaptureImageStorage,
    '1.2.840.10008.5.1.4.1.1.7.2':
        SopClass.kMultiFrameGrayscaleByteSecondaryCaptureImageStorage,
    '1.2.840.10008.5.1.4.1.1.7.3':
        SopClass.kMultiFrameGrayscaleWordSecondaryCaptureImageStorage,
    '1.2.840.10008.5.1.4.1.1.7.4':
        SopClass.kMultiFrameTrueColorSecondaryCaptureImageStorage,
    '1.2.840.10008.5.1.4.1.1.8': SopClass.kStandaloneOverlayStorage,
    '1.2.840.10008.5.1.4.1.1.9': SopClass.kStandaloneCurveStorage,
    '1.2.840.10008.5.1.4.1.1.9.1': SopClass.kWaveformStorageTrial,
    '1.2.840.10008.5.1.4.1.1.9.1.1': SopClass.kTwelvelead12ECGWaveformStorage,
    '1.2.840.10008.5.1.4.1.1.9.1.2': SopClass.kGeneralECGWaveformStorage,
    '1.2.840.10008.5.1.4.1.1.9.1.3': SopClass.kAmbulatoryECGWaveformStorage,
    '1.2.840.10008.5.1.4.1.1.9.2.1': SopClass.kHemodynamicWaveformStorage,
    '1.2.840.10008.5.1.4.1.1.9.3.1':
        SopClass.kCardiacElectrophysiologyWaveformStorage,
    '1.2.840.10008.5.1.4.1.1.9.4.1': SopClass.kBasicVoiceAudioWaveformStorage,
    '1.2.840.10008.5.1.4.1.1.9.4.2': SopClass.kGeneralAudioWaveformStorage,
    '1.2.840.10008.5.1.4.1.1.9.5.1': SopClass.kArterialPulseWaveformStorage,
    '1.2.840.10008.5.1.4.1.1.9.6.1': SopClass.kRespiratoryWaveformStorage,
    '1.2.840.10008.5.1.4.1.1.10': SopClass.kStandaloneModalityLUTStorage,
    '1.2.840.10008.5.1.4.1.1.11': SopClass.kStandaloneVOILUTStorage,
    '1.2.840.10008.5.1.4.1.1.11.1':
        SopClass.kGrayscaleSoftcopyPresentationStateStorage,
    '1.2.840.10008.5.1.4.1.1.11.2':
        SopClass.kColorSoftcopyPresentationStateStorage,
    '1.2.840.10008.5.1.4.1.1.11.3':
        SopClass.kPseudoColorSoftcopyPresentationStateStorage,
    '1.2.840.10008.5.1.4.1.1.11.4':
        SopClass.kBlendingSoftcopyPresentationStateStorage,
    '1.2.840.10008.5.1.4.1.1.11.5':
        SopClass.kXAXRFGrayscaleSoftcopyPresentationStateStorage,
    '1.2.840.10008.5.1.4.1.1.12.1': SopClass.kXRayAngiographicImageStorage,
    '1.2.840.10008.5.1.4.1.1.12.1.1': SopClass.kEnhancedXAImageStorage,
    '1.2.840.10008.5.1.4.1.1.12.2': SopClass.kXRayRadiofluoroscopicImageStorage,
    '1.2.840.10008.5.1.4.1.1.12.2.1': SopClass.kEnhancedXRFImageStorage,
    '1.2.840.10008.5.1.4.1.1.12.3':
        SopClass.kXRayAngiographicBiPlaneImageStorage,
    '1.2.840.10008.5.1.4.1.1.13.1.1': SopClass.kXRay3DAngiographicImageStorage,
    '1.2.840.10008.5.1.4.1.1.13.1.2': SopClass.kXRay3DCraniofacialImageStorage,
    '1.2.840.10008.5.1.4.1.1.13.1.3': SopClass.kBreastTomosynthesisImageStorage,
    '1.2.840.10008.5.1.4.1.1.14.1': SopClass
        .kIntravascularOpticalCoherenceTomographyImageStorageForPresentation,
    '1.2.840.10008.5.1.4.1.1.14.2': SopClass
        .kIntravascularOpticalCoherenceTomographyImageStorageForProcessing,
    '1.2.840.10008.5.1.4.1.1.20': SopClass.kNuclearMedicineImageStorage,
    '1.2.840.10008.5.1.4.1.1.66': SopClass.kRawDataStorage,
    '1.2.840.10008.5.1.4.1.1.66.1': SopClass.kSpatialRegistrationStorage,
    '1.2.840.10008.5.1.4.1.1.66.2': SopClass.kSpatialFiducialsStorage,
    '1.2.840.10008.5.1.4.1.1.66.3':
        SopClass.kDeformableSpatialRegistrationStorage,
    '1.2.840.10008.5.1.4.1.1.66.4': SopClass.kSegmentationStorage,
    '1.2.840.10008.5.1.4.1.1.66.5': SopClass.kSurfaceSegmentationStorage,
    '1.2.840.10008.5.1.4.1.1.67': SopClass.kRealWorldValueMappingStorage,
    '1.2.840.10008.5.1.4.1.1.68.1': SopClass.kSurfaceScanMeshStorage,
    '1.2.840.10008.5.1.4.1.1.68.2': SopClass.kSurfaceScanPointCloudStorage,
    '1.2.840.10008.5.1.4.1.1.77.1': SopClass.kVLImageStorageTrial,
    '1.2.840.10008.5.1.4.1.1.77.2': SopClass.kVLMultiFrameImageStorageTrial,
    '1.2.840.10008.5.1.4.1.1.77.1.1': SopClass.kVLEndoscopicImageStorage,
    '1.2.840.10008.5.1.4.1.1.77.1.1.1': SopClass.kVideoEndoscopicImageStorage,
    '1.2.840.10008.5.1.4.1.1.77.1.2': SopClass.kVLMicroscopicImageStorage,
    '1.2.840.10008.5.1.4.1.1.77.1.2.1': SopClass.kVideoMicroscopicImageStorage,
    '1.2.840.10008.5.1.4.1.1.77.1.3':
        SopClass.kVLSlideCoordinatesMicroscopicImageStorage,
    '1.2.840.10008.5.1.4.1.1.77.1.4': SopClass.kVLPhotographicImageStorage,
    '1.2.840.10008.5.1.4.1.1.77.1.4.1': SopClass.kVideoPhotographicImageStorage,
    '1.2.840.10008.5.1.4.1.1.77.1.5.1':
        SopClass.kOphthalmicPhotography8BitImageStorage,
    '1.2.840.10008.5.1.4.1.1.77.1.5.2':
        SopClass.kOphthalmicPhotography16BitImageStorage,
    '1.2.840.10008.5.1.4.1.1.77.1.5.3':
        SopClass.kStereometricRelationshipStorage,
    '1.2.840.10008.5.1.4.1.1.77.1.5.4':
        SopClass.kOphthalmicTomographyImageStorage,
    '1.2.840.10008.5.1.4.1.1.77.1.6':
        SopClass.kVLWholeSlideMicroscopyImageStorage,
    '1.2.840.10008.5.1.4.1.1.78.1': SopClass.kLensometryMeasurementsStorage,
    '1.2.840.10008.5.1.4.1.1.78.2': SopClass.kAutorefractionMeasurementsStorage,
    '1.2.840.10008.5.1.4.1.1.78.3': SopClass.kKeratometryMeasurementsStorage,
    '1.2.840.10008.5.1.4.1.1.78.4':
        SopClass.kSubjectiveRefractionMeasurementsStorage,
    '1.2.840.10008.5.1.4.1.1.78.5': SopClass.kVisualAcuityMeasurementsStorage,
    '1.2.840.10008.5.1.4.1.1.78.6':
        SopClass.kSpectaclePrescriptionReportStorage,
    '1.2.840.10008.5.1.4.1.1.78.7':
        SopClass.kOphthalmicAxialMeasurementsStorage,
    '1.2.840.10008.5.1.4.1.1.78.8':
        SopClass.kIntraocularLensCalculationsStorage,
    '1.2.840.10008.5.1.4.1.1.79.1':
        SopClass.kMacularGridThicknessandVolumeReportStorage,
    '1.2.840.10008.5.1.4.1.1.80.1':
        SopClass.kOphthalmicVisualFieldStaticPerimetryMeasurementsStorage,
    '1.2.840.10008.5.1.4.1.1.81.1': SopClass.kOphthalmicThicknessMapStorage,
    '11.2.840.10008.5.1.4.1.1.82.1': SopClass.kCornealTopographyMapStorage,
    '1.2.840.10008.5.1.4.1.1.88.1': SopClass.kTextSRStorageTrial,
    '1.2.840.10008.5.1.4.1.1.88.2': SopClass.kAudioSRStorageTrial,
    '1.2.840.10008.5.1.4.1.1.88.3': SopClass.kDetailSRStorageTrial,
    '1.2.840.10008.5.1.4.1.1.88.4': SopClass.kComprehensiveSRStorageTrial,
    '1.2.840.10008.5.1.4.1.1.88.11': SopClass.kBasicTextSRStorage,
    '1.2.840.10008.5.1.4.1.1.88.22': SopClass.kEnhancedSRStorage,
    '1.2.840.10008.5.1.4.1.1.88.33': SopClass.kComprehensiveSRStorage,
    '1.2.840.10008.5.1.4.1.1.88.34': SopClass.kComprehensive3DSRStorage,
    '1.2.840.10008.5.1.4.1.1.88.40': SopClass.kProcedureLogStorage,
    '1.2.840.10008.5.1.4.1.1.88.50': SopClass.kMammographyCADSRStorage,
    '1.2.840.10008.5.1.4.1.1.88.59':
        SopClass.kKeyObjectSelectionDocumentStorage,
    '1.2.840.10008.5.1.4.1.1.88.65': SopClass.kChestCADSRStorage,
    '1.2.840.10008.5.1.4.1.1.88.67': SopClass.kXRayRadiationDoseSRStorage,
    '1.2.840.10008.5.1.4.1.1.88.69': SopClass.kColonCADSRStorage,
    '1.2.840.10008.5.1.4.1.1.88.70': SopClass.kImplantationPlanSRStorage,
    '1.2.840.10008.5.1.4.1.1.104.1': SopClass.kEncapsulatedPDFStorage,
    '1.2.840.10008.5.1.4.1.1.104.2': SopClass.kEncapsulatedCDAStorage,
    '1.2.840.10008.5.1.4.1.1.128':
        SopClass.kPositronEmissionTomographyImageStorage,
    '1.2.840.10008.5.1.4.1.1.128.1':
        SopClass.kLegacyConvertedEnhancedPETImageStorage,
    '1.2.840.10008.5.1.4.1.1.129': SopClass.kStandalonePETCurveStorage,
    '1.2.840.10008.5.1.4.1.1.130': SopClass.kEnhancedPETImageStorage,
    '1.2.840.10008.5.1.4.1.1.131': SopClass.kBasicStructuredDisplayStorage,
    '1.2.840.10008.5.1.4.1.1.481.1': SopClass.kRTImageStorage,
    '1.2.840.10008.5.1.4.1.1.481.2': SopClass.kRTDoseStorage,
    '1.2.840.10008.5.1.4.1.1.481.3': SopClass.kRTStructureSetStorage,
    '1.2.840.10008.5.1.4.1.1.481.4': SopClass.kRTBeamsTreatmentRecordStorage,
    '1.2.840.10008.5.1.4.1.1.481.5': SopClass.kRTPlanStorage,
    '1.2.840.10008.5.1.4.1.1.481.6': SopClass.kRTBrachyTreatmentRecordStorage,
    '1.2.840.10008.5.1.4.1.1.481.7': SopClass.kRTTreatmentSummaryRecordStorage,
    '1.2.840.10008.5.1.4.1.1.481.8': SopClass.kRTIonPlanStorage,
    '1.2.840.10008.5.1.4.1.1.481.9': SopClass.kRTIonBeamsTreatmentRecordStorage,
    '1.2.840.10008.5.1.4.1.1.501.1': SopClass.kDICOSCTImageStorage,
    '1.2.840.10008.5.1.4.1.1.501.2.1':
        SopClass.kDICOSDigitalXRayImageStorageForPresentation,
    '1.2.840.10008.5.1.4.1.1.501.2.2':
        SopClass.kDICOSDigitalXRayImageStorageForProcessing,
    '1.2.840.10008.5.1.4.1.1.501.3':
        SopClass.kDICOSThreatDetectionReportStorage,
    '1.2.840.10008.5.1.4.1.1.501.4': SopClass.kDICOS2DAITStorage,
    '1.2.840.10008.5.1.4.1.1.501.5': SopClass.kDICOS3DAITStorage,
    '1.2.840.10008.5.1.4.1.1.501.6': SopClass.kDICOSQuadrupoleResonanceStorage,
    '1.2.840.10008.5.1.4.1.1.601.1': SopClass.kEddyCurrentImageStorage,
    '1.2.840.10008.5.1.4.1.1.601.2':
        SopClass.kEddyCurrentMultiFrameImageStorage,
    '1.2.840.10008.5.1.4.1.2.1.1':
        SopClass.kPatientRootQueryRetrieveInformationModelFIND,
    '1.2.840.10008.5.1.4.1.2.1.2':
        SopClass.kPatientRootQueryRetrieveInformationModelMOVE,
    '1.2.840.10008.5.1.4.1.2.1.3':
        SopClass.kPatientRootQueryRetrieveInformationModelGET,
    '1.2.840.10008.5.1.4.1.2.2.1':
        SopClass.kStudyRootQueryRetrieveInformationModelFIND,
    '1.2.840.10008.5.1.4.1.2.2.2':
        SopClass.kStudyRootQueryRetrieveInformationModelMOVE,
    '1.2.840.10008.5.1.4.1.2.2.3':
        SopClass.kStudyRootQueryRetrieveInformationModelGET,
    '1.2.840.10008.5.1.4.1.2.3.1':
        SopClass.kPatientStudyOnlyQueryRetrieveInformationModelFIND,
    '1.2.840.10008.5.1.4.1.2.3.2':
        SopClass.kPatientStudyOnlyQueryRetrieveInformationModelMOVE,
    '1.2.840.10008.5.1.4.1.2.3.3':
        SopClass.kPatientStudyOnlyQueryRetrieveInformationModelGET,
    '1.2.840.10008.5.1.4.1.2.4.2': SopClass.kCompositeInstanceRootRetrieveMOVE,
    '1.2.840.10008.5.1.4.1.2.4.3': SopClass.kCompositeInstanceRootRetrieveGET,
    '1.2.840.10008.5.1.4.1.2.5.3':
        SopClass.kCompositeInstanceRetrieveWithoutBulkDataGET,
    '1.2.840.10008.5.1.4.31': SopClass.kModalityWorklistInformationModelFIND,
    '1.2.840.10008.5.1.4.32.1':
        SopClass.kGeneralPurposeWorklistInformationModelFIND,
    '1.2.840.10008.5.1.4.32.2': SopClass.kGeneralPurposeScheduledProcedureStep,
    '1.2.840.10008.5.1.4.32.3': SopClass.kGeneralPurposePerformedProcedureStep,
    '1.2.840.10008.5.1.4.32': SopClass.kGeneralPurposeWorklistManagement,
    '1.2.840.10008.5.1.4.33': SopClass.kInstanceAvailabilityNotification,
    '1.2.840.10008.5.1.4.34.1':
        SopClass.kRTBeamsDeliveryInstructionStorageTrial,
    '1.2.840.10008.5.1.4.34.2':
        SopClass.kRTConventionalMachineVerificationTrial,
    '1.2.840.10008.5.1.4.34.3': SopClass.kRTIonMachineVerificationTrial,
    '1.2.840.10008.5.1.4.34.4.1':
        SopClass.kUnifiedProcedureStepPushSOPClassTrial,
    '1.2.840.10008.5.1.4.34.4.2':
        SopClass.kUnifiedProcedureStepWatchSOPClassTrial,
    '1.2.840.10008.5.1.4.34.4.3':
        SopClass.kUnifiedProcedureStepPullSOPClassTrial,
    '1.2.840.10008.5.1.4.34.4.4':
        SopClass.kUnifiedProcedureStepEventSOPClassTrial,
    '1.2.840.10008.5.1.4.34.6.1': SopClass.kUnifiedProcedureStepPush,
    '1.2.840.10008.5.1.4.34.6.2': SopClass.kUnifiedProcedureStepWatch,
    '1.2.840.10008.5.1.4.34.6.3': SopClass.kUnifiedProcedureStepPull,
    '1.2.840.10008.5.1.4.34.6.4': SopClass.kUnifiedProcedureStepEvent,
    '1.2.840.10008.5.1.4.34.7': SopClass.kRTBeamsDeliveryInstructionStorage,
    '1.2.840.10008.5.1.4.34.8': SopClass.kRTConventionalMachineVerification,
    '1.2.840.10008.5.1.4.34.9': SopClass.kRTIonMachineVerification,
    '1.2.840.10008.5.1.4.37.1':
        SopClass.kGeneralRelevantPatientInformationQuery,
    '1.2.840.10008.5.1.4.37.2':
        SopClass.kBreastImagingRelevantPatientInformationQuery,
    '1.2.840.10008.5.1.4.37.3':
        SopClass.kCardiacRelevantPatientInformationQuery,
    '1.2.840.10008.5.1.4.38.1': SopClass.kHangingProtocolStorage,
    '1.2.840.10008.5.1.4.38.2': SopClass.kHangingProtocolInformationModelFIND,
    '1.2.840.10008.5.1.4.38.3': SopClass.kHangingProtocolInformationModelMOVE,
    '1.2.840.10008.5.1.4.38.4': SopClass.kHangingProtocolInformationModelGET,
    '1.2.840.10008.5.1.4.39.1': SopClass.kColorPaletteStorage,
    '1.2.840.10008.5.1.4.39.2': SopClass.kColorPaletteInformationModelFIND,
    '1.2.840.10008.5.1.4.39.3': SopClass.kColorPaletteInformationModelMOVE,
    '1.2.840.10008.5.1.4.39.4': SopClass.kColorPaletteInformationModelGET,
    '1.2.840.10008.5.1.4.41': SopClass.kProductCharacteristicsQuery,
    '1.2.840.10008.5.1.4.42': SopClass.kSubstanceApprovalQuery,
    '1.2.840.10008.5.1.4.43.1': SopClass.kGenericImplantTemplateStorage,
    '1.2.840.10008.5.1.4.43.2':
        SopClass.kGenericImplantTemplateInformationModelFIND,
    '1.2.840.10008.5.1.4.43.3':
        SopClass.kGenericImplantTemplateInformationModelMOVE,
    '1.2.840.10008.5.1.4.43.4':
        SopClass.kGenericImplantTemplateInformationModelGET,
    '1.2.840.10008.5.1.4.44.1': SopClass.kImplantAssemblyTemplateStorage,
    '1.2.840.10008.5.1.4.44.2':
        SopClass.kImplantAssemblyTemplateInformationModelFIND,
    '1.2.840.10008.5.1.4.44.3':
        SopClass.kImplantAssemblyTemplateInformationModelMOVE,
    '1.2.840.10008.5.1.4.44.4':
        SopClass.kImplantAssemblyTemplateInformationModelGET,
    '1.2.840.10008.5.1.4.45.1': SopClass.kImplantTemplateGroupStorage,
    '1.2.840.10008.5.1.4.45.2':
        SopClass.kImplantTemplateGroupInformationModelFIND,
    '1.2.840.10008.5.1.4.45.3':
        SopClass.kImplantTemplateGroupInformationModelMOVE,
    '1.2.840.10008.5.1.4.45.4':
        SopClass.kImplantTemplateGroupInformationModelGET
  };
}
