//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/vr/new_vr/vr_index.dart';

// ignore_for_file: type_annotate_public_apis, public_member_api_docs

// Const vrCodes as 16-bit values

const int kAECode = 0x464f;
const int kASCode = 0X5341;
const int kATCode = 0X5441;
const int kCSCode = 0X5343;
const int kDACode = 0X4144;
const int kDSCode = 0X5344;
const int kDTCode = 0X5444;
const int kFDCode = 0X4446;
const int kFLCode = 0X4c46;
const int kISCode = 0X5349;
const int kLOCode = 0X4f4c;
const int kLTCode = 0X544c;
const int kPNCode = 0X4e50;
const int kOBCode = 0X424f;
const int kODCode = 0X444f;
const int kOFCode = 0X464f;
const int kOLCode = 0X4c4f;
const int kOWCode = 0X574f;
const int kSHCode = 0X4853;
const int kSLCode = 0X4c53;
const int kSQCode = 0X5153;
const int kSSCode = 0X5353;
const int kSTCode = 0X5453;
const int kTMCode = 0X4d54;
const int kUCCode = 0X4355;
const int kUICode = 0X4955;
const int kUNCode = 0X4e55;
const int kULCode = 0X4c55;
const int kURCode = 0X5255;
const int kUSCode = 0X5355;
const int kUTCode = 0X5455;

/// List of 16-bit VRCodes in VRIndex order.
const List<int> vrCodeByIndex = const <int>[
  kUNCode, kSQCode,
  kOBCode, kOWCode, kOLCode, kOFCode, kODCode,
  kUCCode, kUTCode, kURCode,
  kSSCode, kUSCode,
  kSLCode, kULCode, kATCode,
  kFLCode, kFDCode,
  kSHCode, kLOCode, kSTCode, kLTCode,
  kISCode, kDSCode,
  kDTCode, kDACode, kTMCode, kASCode,
  kAECode, kCSCode, kPNCode, kUICode,
];


/// Map of 16-bit Little Endian VR Codes order by key
const Map<int, int> vrIndexByCode = const <int, int>{
  0x4144: kDAIndex, 0x424f: kOBIndex, 0x4355: kUCIndex, 0x4446: kFDIndex,
  0x444f: kODIndex, 0x4541: kAEIndex, 0x464f: kOFIndex, 0x4853: kSHIndex,
  0x4955: kUIIndex, 0x4c46: kFLIndex, 0x4c4f: kOLIndex, 0x4c53: kSLIndex,
  0x4c55: kULIndex, 0x4d54: kTMIndex, 0x4e50: kPNIndex, 0x4e55: kUNIndex,
  0x4f4c: kLOIndex, 0x5153: kSQIndex, 0x5255: kURIndex, 0x5341: kASIndex,
  0x5343: kCSIndex, 0x5344: kDSIndex, 0x5349: kISIndex, 0x5441: kATIndex,
  0x5444: kDTIndex, 0x544c: kLTIndex, 0x5353: kSSIndex, 0x5355: kUSIndex,
  0x5453: kSTIndex, 0x5455: kUTIndex, 0x574f: kOWIndex // No reformat
};

/// A List of 16-Bit VR Codes sorted in values order.
const List<int> vrCodeInSortOrder = const <int>[
  kDACode, // 0X4144;
  kOBCode, // 0X424f;
  kUCCode, // 0X4355;
  kFDCode, // 0X4446;
  kODCode, // 0X444f;
  kAECode, // 0X4541;
  kOFCode, // 0X464f;
  kSHCode, // 0X4853;
  kUICode, // 0X4955;
  kFLCode, // 0X4c46;
  kOLCode, // 0X4c4f;
  kSLCode, // 0X4c53;
  kULCode, // 0X4c55;
  kTMCode, // 0X4d54;
  kPNCode, // 0X4e50;
  kUNCode, // 0X4e55;
  kLOCode, // 0X4f4c;
  kSQCode, // 0X5153;
  kURCode, // 0X5255;
  kASCode, // 0X5341;
  kCSCode, // 0X5343;
  kDSCode, // 0X5344;
  kISCode, // 0X5349;
  kSSCode, // 0X5353;
  kUSCode, // 0X5355;
  kATCode, // 0X5441;
  kDTCode, // 0X5444;
  kLTCode, // 0X544c;
  kSTCode, // 0X5453;
  kUTCode, // 0X5455;
  kOWCode, // 0X574f;
];
