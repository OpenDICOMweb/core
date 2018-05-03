//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/tag.dart';
import 'package:core/src/value/empty_list.dart';

const List<int> deIdFmiUidCodes = const <int>[
  kMediaStorageSOPInstanceUID
  ];
const List<int> deIdUidCodes = const <int>[
  kRequestedSOPInstanceUID,
  kReferencedSOPInstanceUIDInFile,
  kSOPInstanceUID,
  kContextGroupExtensionCreatorUID,
//  kReferencedStudySequence,
// kReferencedPatientSequence,
  kReferencedSOPInstanceUID,
  kTransactionUID,
// kSourceImageSequence,
  kCreatorVersionUID,
  kStudyInstanceUID,
  kSeriesInstanceUID,
  kSynchronizationFrameOfReferenceUID,

  kUID,
  kTemplateExtensionOrganizationUID,
  kTemplateExtensionCreatorUID,
  kStorageMediaFileSetUID,
  kDigitalSignatureUID,
  kRelatedFrameOfReferenceUID,
];

const List<int> updateUidCodes = const <int>[
  kConcatenationUID,
  kDeviceUID,
  kDimensionOrganizationUID,
  kDoseReferenceUID,

  kRequestedSOPInstanceUID,
  kReferencedSOPInstanceUIDInFile,
  kSOPInstanceUID,
  kContextGroupExtensionCreatorUID,
  kReferencedStudySequence,
  kReferencedPatientSequence,
  kReferencedSOPInstanceUID,
  kTransactionUID,
  kSourceImageSequence,
  kCreatorVersionUID,
  kStudyInstanceUID,
  kSeriesInstanceUID,
  kSynchronizationFrameOfReferenceUID,

  kUID,
  kTemplateExtensionOrganizationUID,
  kTemplateExtensionCreatorUID,
  kStorageMediaFileSetUID,
  kDigitalSignatureUID,
  kRelatedFrameOfReferenceUID,
];

const List<int> deleteUidCodes = const <int>[
  kAffectedSOPInstanceUID,
  kDigitalSignatureUID,


  kRequestedSOPInstanceUID,
  kReferencedSOPInstanceUIDInFile,
  kSOPInstanceUID,
  kContextGroupExtensionCreatorUID,
  kReferencedStudySequence,
  kReferencedPatientSequence,
  kReferencedSOPInstanceUID,
  kTransactionUID,
  kSourceImageSequence,
  kCreatorVersionUID,
  kStudyInstanceUID,
  kSeriesInstanceUID,
  kSynchronizationFrameOfReferenceUID,

  kUID,
  kTemplateExtensionOrganizationUID,
  kTemplateExtensionCreatorUID,
  kStorageMediaFileSetUID,
  kDigitalSignatureUID,
  kRelatedFrameOfReferenceUID,
];

List<int> keptUids = <int>[
  kAffectedSOPInstanceUID,
  kConcatenationUID,
  kDeviceUID,
  kDimensionOrganizationUID,
  kDoseReferenceUID,
  kFailedSOPInstanceUIDList,
  kFiducialUID,
  kFrameOfReferenceUID,
  kInstanceCreatorUID,
  kIrradiationEventUID,
  kMediaStorageSOPInstanceUID,

  kLargePaletteColorLookupTableUID,

  kObservationSubjectUIDTrial,
  kObservationUID,
  kPaletteColorLookupTableUID,
  kPresentationDisplayCollectionUID,
  kPresentationSequenceCollectionUID,
  kReferencedFrameOfReferenceUID,
  kReferencedGeneralPurposeScheduledProcedureStepTransactionUID,
  kReferencedImageSequence,
  kReferencedObservationUIDTrial,
  kReferencedPerformedProcedureStepSequence,
  kReferencedSOPInstanceUIDInFile,
  kReferencedSOPInstanceUID,
  kReferencedStudySequence,
  kRelatedFrameOfReferenceUID,
  kRequestedSOPInstanceUID,
  kSeriesInstanceUID,
  kSOPInstanceUID,
  kStorageMediaFileSetUID,
  kStudyInstanceUID,
  kSynchronizationFrameOfReferenceUID,
  kTargetUID,
  kTemplateExtensionCreatorUID,
  kTemplateExtensionOrganizationUID,
  kTrackingUID,
  kTransactionUID

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


