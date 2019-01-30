//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/tag.dart';
import 'package:core/src/utils/primitives.dart';

// ignore_for_file: public_member_api_docs

// These Lists and Map contain the same codes and tags.
// check length first then compare element by element

/// Date codes that must be de-identified.
const List<int> deIdDateCodes = <int>[
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

/// Date codes that must be de-identified.
const List<int> deIdDeleteDateCodes = <int>[
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

/// Date codes that must be de-identified.
const List<int> deIdUpdateDateCodes = <int>[
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

/// Date [PTag]s that must be de-identified.
const List<PTag> deIdDateTags = <PTag>[
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

// Issue: decide if this Map is needed or used. It can be generated from
// deIdDateTags if needed.
/*
/// A Map from Date Code to Keyword
const Map<int, String> deIdDateCodeToKeywordMap = <int, String>{
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
*/


