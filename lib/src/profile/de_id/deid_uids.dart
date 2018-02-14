// Copyright (c) 2016, 2017, and 2018 Open DICOMweb Project. 
// All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

import 'package:core/src/tag/constants.dart';
import 'package:core/src/tag/p_tag.dart';

const List<int> deIdFmiUidCodes = const <int>[
  kMediaStorageSOPInstanceUID
  ];
const List<int> deIdUidCodes = const <int>[
  kAffectedSOPInstanceUID,
  kRequestedSOPInstanceUID,
  kReferencedSOPInstanceUIDInFile,
  kInstanceCreatorUID,
  kSOPInstanceUID,
  kFailedSOPInstanceUIDList,
  kContextGroupExtensionCreatorUID,
  kReferencedSOPInstanceUID,
  kTransactionUID,
  kIrradiationEventUID,
  kCreatorVersionUID,
  kDeviceUID,
  kStudyInstanceUID,
  kSeriesInstanceUID,
  kFrameOfReferenceUID,
  kSynchronizationFrameOfReferenceUID,
  kConcatenationUID,
  kDimensionOrganizationUID,
  kPaletteColorLookupTableUID,
  kLargePaletteColorLookupTableUID,
  kReferencedGeneralPurposeScheduledProcedureStepTransactionUID,
  kUID,
  kTemplateExtensionOrganizationUID,
  kTemplateExtensionCreatorUID,
  kFiducialUID,
  kStorageMediaFileSetUID,
  kDigitalSignatureUID,
  kReferencedFrameOfReferenceUID,
  kRelatedFrameOfReferenceUID,
  kDoseReferenceUID,
];


const List<PTag> deIdUidTags = const <PTag>[
  PTag.kAffectedSOPInstanceUID,
  PTag.kRequestedSOPInstanceUID,
  PTag.kMediaStorageSOPInstanceUID,
  PTag.kReferencedSOPInstanceUIDInFile,
  PTag.kInstanceCreatorUID,
  PTag.kSOPInstanceUID,
  PTag.kFailedSOPInstanceUIDList,
  PTag.kContextGroupExtensionCreatorUID,
  PTag.kReferencedSOPInstanceUID,
  PTag.kTransactionUID,
  PTag.kIrradiationEventUID,
  PTag.kCreatorVersionUID,
  PTag.kDeviceUID,
  PTag.kStudyInstanceUID,
  PTag.kSeriesInstanceUID,
  PTag.kFrameOfReferenceUID,
  PTag.kSynchronizationFrameOfReferenceUID,
  PTag.kConcatenationUID,
  PTag.kDimensionOrganizationUID,
  PTag.kPaletteColorLookupTableUID,
  PTag.kLargePaletteColorLookupTableUID,
  PTag.kReferencedGeneralPurposeScheduledProcedureStepTransactionUID,
  PTag.kUID,
  PTag.kTemplateExtensionOrganizationUID,
  PTag.kTemplateExtensionCreatorUID,
  PTag.kFiducialUID,
  PTag.kStorageMediaFileSetUID,
  PTag.kDigitalSignatureUID,
  PTag.kReferencedFrameOfReferenceUID,
  PTag.kRelatedFrameOfReferenceUID,
  PTag.kDoseReferenceUID,
];


const Map<int, String> deIdUidCodeToKeywordMap = const <int, String>{
  0x00001000: 'AffectedSOPInstanceUID',
  0x00001001: 'RequestedSOPInstanceUID',
  0x00020003: 'MediaStorageSOPInstanceUID',
  0x00041511: 'ReferencedSOPInstanceUIDInFile',
  0x00080014: 'InstanceCreatorUID',
  0x00080018: 'SOPInstanceUID',
  0x00080058: 'FailedSOPInstanceUIDList',
  0x0008010d: 'ContextGroupExtensionCreatorUID',
  0x00081155: 'ReferencedSOPInstanceUID',
  0x00081195: 'TransactionUID',
  0x00083010: 'IrradiationEventUID',
  0x00089123: 'CreatorVersionUID',
  0x00181002: 'DeviceUID',
  0x0020000d: 'StudyInstanceUID',
  0x0020000e: 'SeriesInstanceUID',
  0x00200052: 'FrameOfReferenceUID',
  0x00200200: 'SynchronizationFrameOfReferenceUID',
  0x00209161: 'ConcatenationUID',
  0x00209164: 'DimensionOrganizationUID',
  0x00281199: 'PaletteColorLookupTableUID',
  0x00281214: 'LargePaletteColorLookupTableUID',
  0x00404023: 'ReferencedGeneralPurposeScheduledProcedureStepTransactionUID',
  0x0040a124: 'UID',
  0x0040db0c: 'TemplateExtensionOrganizationUID',
  0x0040db0d: 'TemplateExtensionCreatorUID',
  0x0070031a: 'FiducialUID',
  0x00880140: 'StorageMediaFileSetUID',
  0x04000100: 'DigitalSignatureUID',
  0x30060024: 'ReferencedFrameOfReferenceUID',
  0x300600c2: 'RelatedFrameOfReferenceUID',
  0x300a0013: 'DoseReferenceUID',
};


