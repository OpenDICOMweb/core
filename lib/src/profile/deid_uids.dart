//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/tag/public/p_tag.dart';
import 'package:core/src/utils/primitives.dart';

// ignore_for_file: public_member_api_docs

const List<int> deIdUidCodes = <int>[
  kAffectedSOPInstanceUID,
  kRequestedSOPInstanceUID,
  kMediaStorageSOPInstanceUID,
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

const List<PTag> deIdUidTags = <PTag>[
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