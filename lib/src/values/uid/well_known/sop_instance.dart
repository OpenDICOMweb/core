//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/values/uid/well_known/uid_type.dart';
import 'package:core/src/values/uid/well_known/wk_uid.dart';

class SopInstance extends WKUid {
  const SopInstance(
      String uid, String keyword, UidType _type, String name,
      {bool isRetired = false})
      : super(uid, keyword, _type, name, isRetired: isRetired);

  static const String kName = 'SOP Instance';

  @override
  UidType get type => UidType.kSOPInstance;

  static SopInstance lookup(String s) => _map[s];

  static List<SopInstance> get uids => _map.values;

  static List<String> get strings => _map.keys;

  static const SopInstance kUnifiedWorklistAndProcedureStep =
      const SopInstance(
          '1.2.840.10008.5.1.4.34.5',
          'UnifiedWorklistandProcedureStepSOPInstance',
          UidType.kSOPInstance,
          'Unified Worklist and Procedure Step SOP Instance');

  static const SopInstance kSubstanceAdministrationLogging =
      const SopInstance(
          '1.2.840.10008.1.42.1',
          'SubstanceAdministrationLoggingSOPInstance',
          UidType.kSOPInstance,
          'Substance Administration Logging SOP Instance');

  static const SopInstance kProceduralEventLogging =
      const SopInstance(
          '1.2.840.10008.1.40.1',
          'ProceduralEventLoggingSOPInstance',
          UidType.kSOPInstance,
          'Procedural Event Logging SOP Instance');

  static const SopInstance kHotIronColorPalette =
      const SopInstance(
    '1.2.840.10008.1.5.1',
    'HotIronColorPaletteSOPInstance',
    UidType.kSOPInstance,
    'Hot Iron Color Palette SOP '
        'Instance',
  );

  static const SopInstance kPETColorPalette =
      const SopInstance(
          '1.2.840.10008.1.5.2',
          'PETColorPaletteSOPInstance',
          UidType.kSOPInstance,
          'PET Color Palette SOP Instance');

  static const SopInstance kHotMetalBlueColorPalette =
      const SopInstance(
          '1.2.840.10008.1.5.3',
          'HotMetalBlueColorPaletteSOPInstance',
          UidType.kSOPInstance,
          'Hot Metal Blue Color Palette SOP Instance');

  static const SopInstance kPET20StepColorPalette =
      const SopInstance(
          '1.2.840.10008.1.5.4',
          'PET20StepColorPaletteSOPInstance',
          UidType.kSOPInstance,
          'PET 20 Step Color Palette SOP Instance');

  static const SopInstance kStorageCommitmentPushModel =
      const SopInstance(
          '1.2.840.10008.1.20.1.1',
          'StorageCommitmentPushModelSOPInstance',
          UidType.kSOPInstance,
          'Storage Commitment Push Model SOP Instance');

  static const SopInstance kStorageCommitmentPullModelSOPClass =
      const SopInstance(
          '1.2.840.10008.1.20.2',
          'StorageCommitmentPullModelSOPClass_Retired',
          UidType.kSOPClass,
          'Storage Commitment Pull Model SOP Class (Retired)',
          isRetired: true);

  static const SopInstance kStorageCommitmentPullModel =
      const SopInstance(
          '1.2.840.10008.1.20.2.1',
          'StorageCommitmentPullModelSOPInstance_Retired',
          UidType.kSOPInstance,
          'Storage Commitment Pull Model SOP Instance (Retired)',
          isRetired: true);

  static const SopInstance kPrinter = const SopInstance(
      '1.2.840.10008.5.1.1.17',
      'PrinterSOPInstance',
      UidType.kSOPInstance,
      'Printer SOP Instance');

  static const SopInstance kPrinterConfigurationRetrieval =
      const SopInstance(
          '1.2.840.10008.5.1.1.17.376',
          'PrinterConfigurationRetrievalSOPInstance',
          UidType.kSOPInstance,
          'Printer Configuration Retrieval SOP Instance');

  static const SopInstance kPrintQueue = const SopInstance(
      '1.2.840.10008.5.1.1.25',
      'PrintQueueSOPInstance_Retired',
      UidType.kSOPInstance,
      'Print Queue SOP Instance (Retired)',
      isRetired: true);

  static const List<SopInstance> members =
      const <SopInstance>[
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

  static const Map<String, SopInstance> _map =
      const <String, SopInstance>{
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
