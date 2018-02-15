// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/uid/well_known/uid_type.dart';
import 'package:core/src/uid/well_known/wk_uid.dart';

class FrameOfReference extends WKUid {
  const FrameOfReference(String uid, String keyword, UidType _type, String name,
      {bool isRetired: false})
      : super(uid, keyword, _type, name, isRetired: isRetired);

  static const String kName = 'Frame of Reference';

  @override
  UidType get type => UidType.kFrameOfReference;

  static FrameOfReference lookup(String s) => _map[s];

  static List<FrameOfReference> get uids => _map.values;

  static List<String> get strings => _map.keys;

  static const FrameOfReference kTalairachBrainAtlasFrameOfReference =
      const FrameOfReference(
          '1.2.840.10008.1.4.1.1',
          'TalairachBrainAtlasFrameofReference',
          UidType.kFrameOfReference,
          'Talairach Brain Atlas Frame of Reference');

  static const FrameOfReference kSPM2T1FrameOfReference =
      const FrameOfReference('1.2.840.10008.1.4.1.2', 'SPM2T1FrameofReference',
          UidType.kFrameOfReference, 'SPM2 T1 Frame of Reference');

  static const FrameOfReference kSPM2T2FrameOfReference =
      const FrameOfReference('1.2.840.10008.1.4.1.3', 'SPM2T2FrameofReference',
          UidType.kFrameOfReference, 'SPM2 T2 Frame of Reference');

  static const FrameOfReference kSPM2PDFrameOfReference =
      const FrameOfReference('1.2.840.10008.1.4.1.4', 'SPM2PDFrameofReference',
          UidType.kFrameOfReference, 'SPM2 PD Frame of Reference');

  static const FrameOfReference kSPM2EPIFrameOfReference =
      const FrameOfReference('1.2.840.10008.1.4.1.5', 'SPM2EPIFrameOfReference',
          UidType.kFrameOfReference, 'SPM2 EPI Frame of Reference');

  static const FrameOfReference kSPM2FILT1FrameOfReference =
      const FrameOfReference(
          '1.2.840.10008.1.4.1.6',
          'SPM2FILT1FrameofReference',
          UidType.kFrameOfReference,
          'SPM2 FIL T1 Frame of Reference');

  static const FrameOfReference kSPM2PETFrameOfReference =
      const FrameOfReference('1.2.840.10008.1.4.1.7', 'SPM2PETFrameofReference',
          UidType.kFrameOfReference, 'SPM2 PET Frame of Reference');

  static const FrameOfReference kSPM2TRANSMFrameOfReference =
      const FrameOfReference(
          '1.2.840.10008.1.4.1.8',
          'SPM2TRANSMFrameofReference',
          UidType.kFrameOfReference,
          'SPM2 TRANSM Frame of Reference');

  static const FrameOfReference kSPM2SPECTFrameOfReference =
      const FrameOfReference(
          '1.2.840.10008.1.4.1.9',
          'SPM2SPECTFrameofReference',
          UidType.kFrameOfReference,
          'SPM2 SPECT Frame of Reference');

  static const FrameOfReference kSPM2GRAYFrameOfReference =
      const FrameOfReference(
          '1.2.840.10008.1.4.1.10',
          'SPM2GRAYFrameofReference',
          UidType.kFrameOfReference,
          'SPM2 GRAY Frame of Reference');

  static const FrameOfReference kSPM2WHITEFrameOfReference =
      const FrameOfReference(
          '1.2.840.10008.1.4.1.11',
          'SPM2WHITEFrameofReference',
          UidType.kFrameOfReference,
          'SPM2 WHITE Frame of Reference');

  static const FrameOfReference kSPM2CSFFrameOfReference =
      const FrameOfReference(
          '1.2.840.10008.1.4.1.12',
          'SPM2CSFFrameofReference',
          UidType.kFrameOfReference,
          'SPM2 CSF Frame of Reference');

  static const FrameOfReference kSPM2BRAINMASKFrameOfReference =
      const FrameOfReference(
          '1.2.840.10008.1.4.1.13',
          'SPM2BRAINMASKFrameofReference',
          UidType.kFrameOfReference,
          'SPM2 BRAINMASK Frame of Reference');

  static const FrameOfReference kSPM2AVG305T1FrameOfReference =
      const FrameOfReference(
          '1.2.840.10008.1.4.1.14',
          'SPM2AVG305T1FrameofReference',
          UidType.kFrameOfReference,
          'SPM2 AVG305T1 Frame of Reference');

  static const FrameOfReference kSPM2AVG152T1FrameOfReference =
      const FrameOfReference(
          '1.2.840.10008.1.4.1.15',
          'SPM2AVG152T1FrameofReference',
          UidType.kFrameOfReference,
          'SPM2 AVG152T1 Frame of Reference');

  static const FrameOfReference kSPM2AVG152T2FrameOfReference =
      const FrameOfReference(
          '1.2.840.10008.1.4.1.16',
          'SPM2AVG152T2FrameofReference',
          UidType.kFrameOfReference,
          'SPM2 AVG152T2 Frame of Reference');

  static const FrameOfReference kSPM2AVG152PDFrameOfReference =
      const FrameOfReference(
          '1.2.840.10008.1.4.1.17',
          'SPM2AVG152PDFrameofReference',
          UidType.kFrameOfReference,
          'SPM2 AVG152PD Frame of Reference');

  static const FrameOfReference kSPM2SINGLESUBJT1FrameOfReference =
      const FrameOfReference(
          '1.2.840.10008.1.4.1.18',
          'SPM2SINGLESUBJT1FrameofReference',
          UidType.kFrameOfReference,
          'SPM2 SINGLESUBJT1 Frame of Reference');

  static const FrameOfReference kICBM452T1FrameOfReference =
      const FrameOfReference(
          '1.2.840.10008.1.4.2.1',
          'ICBM452T1FrameofReference',
          UidType.kFrameOfReference,
          'ICBM 452 T1 Frame of Reference');

  static const FrameOfReference kICBMSingleSubjectMRIFrameOfReference =
      const FrameOfReference(
          '1.2.840.10008.1.4.2.2',
          'ICBMSingleSubjectMRIFrameofReference',
          UidType.kFrameOfReference,
          'ICBM Single Subject MRI Frame of Reference');

  static const Map<String, FrameOfReference> _map = const {
    '1.2.840.10008.1.4.1.1': kTalairachBrainAtlasFrameOfReference,
    '1.2.840.10008.1.4.1.2': kSPM2T1FrameOfReference,
    '1.2.840.10008.1.4.1.3': kSPM2T2FrameOfReference,
    '1.2.840.10008.1.4.1.4': kSPM2PDFrameOfReference,
    '1.2.840.10008.1.4.1.5': kSPM2EPIFrameOfReference,
    '1.2.840.10008.1.4.1.6': kSPM2FILT1FrameOfReference,
    '1.2.840.10008.1.4.1.7': kSPM2PETFrameOfReference,
    '1.2.840.10008.1.4.1.8': kSPM2TRANSMFrameOfReference,
    '1.2.840.10008.1.4.1.9': kSPM2SPECTFrameOfReference,
    '1.2.840.10008.1.4.1.10': kSPM2GRAYFrameOfReference,
    '1.2.840.10008.1.4.1.11': kSPM2WHITEFrameOfReference,
    '1.2.840.10008.1.4.1.12': kSPM2CSFFrameOfReference,
    '1.2.840.10008.1.4.1.13': kSPM2BRAINMASKFrameOfReference,
    '1.2.840.10008.1.4.1.14': kSPM2AVG305T1FrameOfReference,
    '1.2.840.10008.1.4.1.15': kSPM2AVG152T1FrameOfReference,
    '1.2.840.10008.1.4.1.16': kSPM2AVG152T2FrameOfReference,
    '1.2.840.10008.1.4.1.17': kSPM2AVG152PDFrameOfReference,
    '1.2.840.10008.1.4.1.18': kSPM2SINGLESUBJT1FrameOfReference,
    '1.2.840.10008.1.4.2.1': kICBM452T1FrameOfReference,
    '1.2.840.10008.1.4.2.2': kICBMSingleSubjectMRIFrameOfReference
  };
}
