// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See /[package]/AUTHORS file for other contributors.

import 'package:core/src/uid/uid_type.dart';
import 'package:core/src/uid/well_known/wk_uid.dart';

//TODO: Finish this class and write Unit test.

class WellKnownSopInstance extends WKUid {
  const WellKnownSopInstance(String uid, String keyword, UidType type, String name,
      {bool isRetired = false})
      : super(uid, keyword, type, name, isRetired: isRetired);

  //TODO: create UidType class
  bool get isSopInstance => true;

  @override
  String get info => '$runtimeType($asString)';

  @override
  String toString() => asString;

  //TODO: when other classes are implemented convert to lookup the uidString
  //in each class.
  static WellKnownSopInstance lookup(String s) => map[s];

  static const WellKnownSopInstance kUnifiedWorklistAndProcedureStep =
      const WellKnownSopInstance(
          '1.2.840.10008.5.1.4.34.5',
          'UnifiedWorklistandProcedureStepSOPInstance',
          UidType.kWellKnownSOPInstance,
          'Unified Worklist and Procedure Step SOP Instance');

  static const WellKnownSopInstance kSubstanceAdministrationLogging =
      const WellKnownSopInstance(
          '1.2.840.10008.1.42.1',
          'SubstanceAdministrationLoggingSOPInstance',
          UidType.kWellKnownSOPInstance,
          'Substance Administration Logging SOP Instance');

  static const WellKnownSopInstance kProceduralEventLogging = const WellKnownSopInstance(
      '1.2.840.10008.1.40.1',
      'ProceduralEventLoggingSOPInstance',
      UidType.kWellKnownSOPInstance,
      'Procedural Event Logging SOP Instance');

  static const WellKnownSopInstance kHotIronColorPalette = const WellKnownSopInstance(
    '1.2.840.10008.1.5.1',
    'HotIronColorPaletteSOPInstance',
    UidType.kWellKnownSOPInstance,
    'Hot Iron Color Palette SOP '
        'Instance',
  );

  static const WellKnownSopInstance kPETColorPalette = const WellKnownSopInstance(
      '1.2.840.10008.1.5.2',
      'PETColorPaletteSOPInstance',
      UidType.kWellKnownSOPInstance,
      'PET Color Palette SOP Instance');

  static const WellKnownSopInstance kHotMetalBlueColorPalette =
      const WellKnownSopInstance(
          '1.2.840.10008.1.5.3',
          'HotMetalBlueColorPaletteSOPInstance',
          UidType.kWellKnownSOPInstance,
          'Hot Metal Blue Color Palette SOP Instance');

  static const WellKnownSopInstance kPET20StepColorPalette = const WellKnownSopInstance(
      '1.2.840.10008.1.5.4',
      'PET20StepColorPaletteSOPInstance',
      UidType.kWellKnownSOPInstance,
      'PET 20 Step Color Palette SOP Instance');

  static const WellKnownSopInstance kStorageCommitmentPushModel =
      const WellKnownSopInstance(
          '1.2.840.10008.1.20.1.1',
          'StorageCommitmentPushModelSOPInstance',
          UidType.kWellKnownSOPInstance,
          'Storage Commitment Push Model SOP Instance');

  static const WellKnownSopInstance kStorageCommitmentPullModelSOPClass =
      const WellKnownSopInstance(
          '1.2.840.10008.1.20.2',
          'StorageCommitmentPullModelSOPClass_Retired',
          UidType.kSOPClass,
          'Storage Commitment Pull Model SOP Class (Retired)',
          isRetired: true);

  static const WellKnownSopInstance kStorageCommitmentPullModel =
      const WellKnownSopInstance(
          '1.2.840.10008.1.20.2.1',
          'StorageCommitmentPullModelSOPInstance_Retired',
          UidType.kWellKnownSOPInstance,
          'Storage Commitment Pull Model SOP Instance (Retired)',
          isRetired: true);

  static const WellKnownSopInstance kPrinter = const WellKnownSopInstance(
      '1.2.840.10008.5.1.1.17',
      'PrinterSOPInstance',
      UidType.kWellKnownSOPInstance,
      'Printer SOP Instance');

  static const WellKnownSopInstance kPrinterConfigurationRetrieval =
      const WellKnownSopInstance(
          '1.2.840.10008.5.1.1.17.376',
          'PrinterConfigurationRetrievalSOPInstance',
          UidType.kWellKnownSOPInstance,
          'Printer Configuration Retrieval SOP Instance');

  static const WellKnownSopInstance kPrintQueue = const WellKnownSopInstance(
      '1.2.840.10008.5.1.1.25',
      'PrintQueueSOPInstance_Retired',
      UidType.kWellKnownSOPInstance,
      'Print Queue SOP Instance (Retired)',
      isRetired: true);

  static const List<WellKnownSopInstance> members = const <WellKnownSopInstance>[
    kUnifiedWorklistAndProcedureStep,
    kSubstanceAdministrationLogging,
    kProceduralEventLogging,
    kHotIronColorPalette,
    kPETColorPalette,
    kHotMetalBlueColorPalette,
    kPET20StepColorPalette,
    kStorageCommitmentPushModel,
    kStorageCommitmentPullModel,
    kPrinter,
    kPrinterConfigurationRetrieval,
    kPrintQueue
  ];

  static const Map<String, WellKnownSopInstance> map =
      const <String, WellKnownSopInstance>{
    '1.2.840.10008.5.1.4.34.5': kUnifiedWorklistAndProcedureStep,
    '1.2.840.10008.1.42.1': kSubstanceAdministrationLogging,
    '1.2.840.10008.1.40.1': kProceduralEventLogging,
    '1.2.840.10008.1.5.1': kHotIronColorPalette,
    '1.2.840.10008.1.5.2': kPETColorPalette,
    '1.2.840.10008.1.5.3': kHotMetalBlueColorPalette,
    '1.2.840.10008.1.5.4': kPET20StepColorPalette,
    '1.2.840.10008.1.20.1.1': kStorageCommitmentPushModel,
    '1.2.840.10008.1.20.2.1': kStorageCommitmentPullModel,
    '1.2.840.10008.5.1.1.17': kPrinter,
    '1.2.840.10008.5.1.1.17.376': kPrinterConfigurationRetrieval,
    '1.2.840.10008.5.1.1.25': kPrintQueue
  };
}
