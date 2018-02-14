// Copyright (c) 2016, 2017, and 2018 Open DICOMweb Project. 
// All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

import 'package:core/src/tag/constants.dart';
import 'package:core/src/tag/p_tag.dart';

const List<int> deIdDateCodes = const <int>[
  // Added by JFPhilbin
  kInstanceCreationDate,
  // Defined in PS3.15
  kStudyDate,
  kSeriesDate,
  kAcquisitionDate,
  kContentDate,
  kOverlayDate,
  kCurveDate,
  kPatientBirthDate,
  kLastMenstrualDate,
  kAdmittingDate,
  kScheduledProcedureStepStartDate,
  kScheduledProcedureStepEndDate,
  kPerformedProcedureStepStartDate,
  kPerformedProcedureStepEndDate,
];


const List<PTag> deIdDateTags = const <PTag>[
  // Added by JFPhilbin
  PTag.kInstanceCreationDate,
  // Defined in PS3.15
  PTag.kStudyDate,
  PTag.kSeriesDate,
  PTag.kAcquisitionDate,
  PTag.kContentDate,
  PTag.kOverlayDate,
  PTag.kCurveDate,
  PTag.kPatientBirthDate,
  PTag.kLastMenstrualDate,
  PTag.kAdmittingDate,
  PTag.kScheduledProcedureStepStartDate,
  PTag.kScheduledProcedureStepEndDate,
  PTag.kPerformedProcedureStepStartDate,
  PTag.kPerformedProcedureStepEndDate,
];


const Map<int, String> deIdDateCodeToKeywordMap = const <int, String>{
  0x00080020: 'StudyDate',
  0x00080021: 'SeriesDate',
  0x00080022: 'AcquisitionDate',
  0x00080023: 'ContentDate',
  0x00080024: 'OverlayDate',
  0x00080025: 'CurveDate',
  0x00100030: 'PatientBirthDate',
  0x001021d0: 'LastMenstrualDate',
  0x00380020: 'AdmittingDate',
  0x00400002: 'ScheduledProcedureStepStartDate',
  0x00400004: 'ScheduledProcedureStepEndDate',
  0x00400244: 'PerformedProcedureStepStartDate',
  0x00400250: 'PerformedProcedureStepEndDate',
};


