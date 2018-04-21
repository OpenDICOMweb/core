//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/tag/private/pd_tag_definitions.dart';
import 'package:core/src/tag/private/pc_tag_definitions.dart';

bool isWKCreator(String id) => pcTagDefinitions[id] != null;

// '([\w\.\_\d]+)': const (\<[\w\,\s]+\>)(\{[\w\s\d:\.\,]+\})\,
/*
const Map<String, Map<int, PDTagDefinition>> pcTagDefinitions =
    const <String, Map<int, PDTagDefinition>>{}
*/
const Map<String, String> pseudonyms = <String, String>{
  '1.2.840.113681': 'Uid1_2_840_113681',
  '1.2.840.113708.794.1.1.2.0': 'Uid1_2_840_113708_794_1_1_2_0',
  'AEGIS_DICOM_2.00': 'AEGIS_DICOM_200',
  'CAMTRONICS IP': 'CAMTRONICS_IP',
  'CARDIO-D.R. 1.0': 'CARDIO-D.R. 1.0',
  'DIGISCAN IMAGE': 'DIGISCAN_IMAGE',
  'FDMS 1.0': 'FDMS_1_0',
  'FFP DATA': 'FFP_DATA',
  'GE ??? From Adantage Review CS': 'GE_____From_Adantage_Review_CS',
  'GEMS_ACRQA_1.0 BLOCK1': 'GEMS_ACRQA_1_0_BLOCK1',
  'GEMS_ACRQA_1.0 BLOCK2': 'GEMS_ACRQA_1_0_BLOCK2',
  'GEMS_ACRQA_1.0 BLOCK3': 'GEMS_ACRQA_1_0_BLOCK3',
  'GEMS_ACRQA_2.0 BLOCK1': 'GEMS_ACRQA_2_0_BLOCK1',
  'GEMS_ACRQA_2.0 BLOCK2': 'GEMS_ACRQA_2_0_BLOCK2',
  'GEMS_ACRQA_2.0 BLOCK3': 'GEMS_ACRQA_2_0_BLOCK3',
  'SIEMENS RA GEN': 'SIEMENS_RA_GEN',
  'GE_GENESIS_REV3.0': 'GE_GENESIS_REV3.0',
  'INTELERAD MEDICAL SYSTEMS': 'INTELERAD_MEDICAL_SYSTEMS',
  'INTEGRIS 1.0': 'INTEGRIS_1_0',
  'ISG shadow': 'ISG_shadow=',
  'MERGE TECHNOLOGIES, INC.': 'MERGE_TECHNOLOGIES__INC_',
  'OCULUS Optikgeraete GmbH': 'OCULUS_Optikgeraete_GmbH',
  'PAPYRUS 3.0': 'PAPYRUS_3_0',
  'Philips Imaging DD 001': 'Philips_Imaging_DD_001',
  'PHILIPS IMAGING DD 001': 'PHILIPS_IMAGING_DD_001',
  'Philips MR Imaging DD 001': 'Philips_MR_Imaging_DD_001',
  'Philips MR Imaging DD 005': 'Philips_MR_Imaging_DD_005',
  'PHILIPS MR IMAGING DD 001': 'PHILIPS_MR_IMAGING_DD_001',
  'PHILIPS MR R5.5/PART': 'PHILIPS_MR_R5_5_PART',
  'PHILIPS MR R5.6/PART': 'PHILIPS_MR_R5_6_PART',
  'PHILIPS MR SPECTRO;1': 'PHILIPS_MR_SPECTRO_1',
  'PHILIPS MR': 'PHILIPS_MR',
  'PHILIPS MR/LAST': 'PHILIPS_MR_LAST',
  'PHILIPS MR/PART': 'PHILIPS_MR_PART',
  'PHILIPS-MR-1': 'PHILIPS-MR-1',
  'Picker NM Private Group': 'Picker_NM_Private_Group',
  'SIEMENS CM VA0  ACQU': 'SIEMENS_CM_VA0__ACQU',
  'SIEMENS CM VA0  CMS': 'SIEMENS_CM_VA0__CMS',
  'SIEMENS CM VA0  LAB': 'SIEMENS_CM_VA0__LAB',
  'SIEMENS CSA NON-IMAGE': 'SIEMENS_CSA_NON_IMAGE',
  'SIEMENS CT VA0  COAD': 'SIEMENS_CT_VA0__COAD',
  'SIEMENS CSA HEADER': 'SIEMENS_CSA_HEADER',
  'SIEMENS CT VA0  GEN': 'SIEMENS_CT_VA0__GEN',
  'SIEMENS CT VA0  IDE': 'SIEMENS_CT_VA0__IDE',
  'SIEMENS CT VA0  ORI': 'SIEMENS_CT_VA0__ORI',
  'SIEMENS CT VA0  OST': 'SIEMENS_CT_VA0__OST',
  'SIEMENS CT VA0  RAW': 'SIEMENS_CT_VA0__RAW',
  'SIEMENS DICOM': 'SIEMENS_DICOM',
  'SIEMENS DLR.01': 'SIEMENS_DLR_01',
'SIEMENS SMS-AX  ACQ 1.0': 'SIEMENS_SMS_AX__ACQ_1_0',

'SIEMENS SMS-AX  ORIGINAL IMAGE INFO 1.0': 'SIEMENS_SMS_AX__ORIGINAL_IMAGE_INFO_1_0',
'SIEMENS SMS-AX  QUANT 1.0': 'SIEMENS_SMS_AX__QUANT_1_0',
'SIEMENS SMS-AX  VIEW 1.0':  'SIEMENS_SMS_AX__VIEW_1_0',

};
