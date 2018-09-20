//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/utils/primitives.dart';

// ignore_for_file: type_annotate_public_apis, public_member_api_docs

// Sequence is 0
const int kSQIndex = 0;

// Long, Maybe Undefined
const int kOBIndex = 1; // Maybe Undefined Min
const int kOWIndex = 2;
const int kUNIndex = 3; // Maybe Undefined Max

// Long EVR
const int kODIndex = 4; // Long EVR and IVR Min
const int kOFIndex = 5;
const int kOLIndex = 6;
const int kUCIndex = 7;
const int kURIndex = 8;
const int kUTIndex = 9; // Long EVR Max

// Short EVR
const int kAEIndex = 10; // Short IVR Min
const int kASIndex = 11;
const int kATIndex = 12;
const int kCSIndex = 13;
const int kDAIndex = 14;
const int kDSIndex = 15;
const int kDTIndex = 16;
const int kFDIndex = 17;
const int kFLIndex = 18;
const int kISIndex = 19;
const int kLOIndex = 20;
const int kLTIndex = 21;
const int kPNIndex = 22;
const int kSHIndex = 23;
const int kSLIndex = 24;
const int kSSIndex = 25;
const int kSTIndex = 26;
const int kTMIndex = 27;
const int kUIIndex = 28;
const int kULIndex = 29;
const int kUSIndex = 30; // Short EVR Max and IVR Max
const int kOBOWIndex = 31;
const int kUSOWIndex = 34;
const int kUSSSOWIndex = 33;
const int kUSSSIndex = 32;

const int kVRIndexMin = 0;
const int kVREvrLongIndexMin = 1; // OB
const int kVRMaybeUndefinedIndexMin = 0; // OB
const int kVRMaybeUndefinedIndexMax = 3; // UN

const int kVRDefinedLongIndexMin = 4; // OD
const int kVRIvrLongIndexMax = 30; // US

const int kVREvrDefinedLongIndexMin = 4; // OD
const int kVREvrLongIndexMax = 9; // UT
const int kVREvrShortIndexMin = 10; // AE
const int kVREvrShortIndexMax = 30; // US

const int kVRSpecialIndexMin = 31; // OBOW
const int kVRSpecialIndexMax = 34; // USOW

const int kVRNormalIndexMin = 0; // SQ
const int kVRNormalIndexMax = 30; // US

bool isValidOBIndex(int vrIndex) =>
    vrIndex == kOBIndex || vrIndex == kOBOWIndex;

bool isValidOWIndex(int vrIndex) =>
    vrIndex == kOWIndex || vrIndex == kOBOWIndex || vrIndex == kUSSSOWIndex;

bool isValidSSIndex(int vrIndex) =>
    vrIndex == kSSIndex || vrIndex == kUSSSIndex || vrIndex == kUSSSOWIndex;

bool isValidUSIndex(int vrIndex) =>
    vrIndex == kUSIndex || vrIndex == kUSSSIndex || vrIndex == kUSSSOWIndex;

bool isSequenceVRIndex(int vrIndex) => vrIndex == 0;

bool isSpecialVRIndex(int vrIndex) =>
    vrIndex >= kVRSpecialIndexMin && vrIndex <= kVRSpecialIndexMax;

bool isNormalVRIndex(int vrIndex) =>
    vrIndex >= kVRNormalIndexMin && vrIndex <= kVRNormalIndexMax;

bool isMaybeUndefinedLengthVRIndex(int vrIndex) =>
    vrIndex >= kVRMaybeUndefinedIndexMin &&
    vrIndex <= kVRMaybeUndefinedIndexMax;

bool isEvrLongVRIndex(int vrIndex) =>
    vrIndex >= kVREvrLongIndexMin && vrIndex <= kVREvrLongIndexMax;

bool isEvrShortVRIndex(int vrIndex) =>
    vrIndex >= kVREvrShortIndexMin && vrIndex <= kVREvrShortIndexMax;

bool isIvrDefinedLengthVRIndex(int vrIndex) =>
    vrIndex >= kVRDefinedLongIndexMin && vrIndex <= kVRNormalIndexMax;

bool isFloatVR(int vrIndex) =>
    vrIndex == kFLIndex ||
    vrIndex == kFDIndex ||
    vrIndex == kOFIndex ||
    vrIndex == kODIndex;

bool isStringVR(int vrIndex) =>
    isShortStringVR(vrIndex) || isLongStringVR(vrIndex);

bool isShortStringVR(int vrIndex) =>
    vrIndex >= kVRDefinedLongIndexMin && vrIndex <= kVRNormalIndexMax;

bool isLongStringVR(int vrIndex) => vrIndex >= kUCIndex && vrIndex <= kUTIndex;

/// Returns _true_ if the VR with _vrIndex_
/// is, by definition, always a valid length.
const List<int> kVFLengthAlwaysValidIndices = <int>[
  kSQIndex, kUNIndex, kOBIndex, kOWIndex, kOLIndex, // No reformat
  kODIndex, kOFIndex, kUCIndex, kURIndex, kUTIndex, kOBOWIndex
];

bool isVFLengthAlwaysValid(int vrIndex) =>
    kVFLengthAlwaysValidIndices.contains(vrIndex);

const List<int> kUndefinedLengthVRIndices = <int>[
  kSQIndex, kOBIndex, kOWIndex, kUNIndex // No reformat
];

bool isUndefinedLengthAllowed(int vrIndex) =>
    kUndefinedLengthVRCodes.contains(vrIndex);

const List<int> kNullPaddingVRIndices = <int>[
  kOBIndex,
  // kUNIndex, // UN should never have padding removed or added
  kUIIndex
];

const List<int> kUndefinedLengthVRCodes = <int>[
  kSQCode,
  kOBCode,
  kOWCode,
  kUNCode
];

String vrIdFromIndex(int vrIndex) => vrIdByIndex[vrIndex];
int vrIndexFromId(String id) => vrIdByIndex.indexOf(id);

const List<String> vrIdByIndex = <String>[
  // Begin maybe undefined length
  'SQ', // Sequence == 0,
  // Begin EVR Long
  'OB', 'OW', 'UN',
  // End maybe Undefined Length
  // EVR Long
  'OD', 'OF', 'OL', 'UC', 'UR', 'UT',
  // End Evr Long
  // Begin EVR Short
  'AE', 'AS', 'AT', 'CS', 'DA', 'DS', 'DT',
  'FD', 'FL', 'IS', 'LO', 'LT', 'PN', 'SH',
  'SL', 'SS', 'ST', 'TM', 'UI', 'UL', 'US',
  // End Evr Short
  // EVR Special
  'OBOW', 'USSS', 'USSSOW', 'USOW'
];

String vrNameFromIndex(int vrIndex) => vrNameByIndex[vrIndex];

const List<String> vrNameByIndex = <String>[
  // Begin maybe undefined length
  'Sequence', // Sequence == 0,
  // Begin EVR Long
  'Other Byte', 'Other Word', 'Unknown',
  // End maybe Undefined Length
  // EVR Long
  'Other Double', 'Other Float', 'Other Long',
  'Unlimited Characters', 'URI', 'Unlimited Text',
  // End Evr Long
  // Begin EVR Short
  'AE Title', 'Age String', 'Attribute Tag', 'Code String',
  'Date', 'Decimal String', 'DateTime', 'Float Double',
  'Float Single', 'Integer String', 'Long String', 'Long Text',
  'Person Name', 'Short String', 'Signed Long', 'Signed Short',
  'Short Text', 'Time', 'Unique Identifier', 'Unsigned Long',
  'Unsigned Short',
];

const List<int> vrCodeByIndex = <int>[
  // Begin maybe undefined length
  kSQCode, // Sequence == 0,
  // Begin EVR Long
  kOBCode, kOWCode, kUNCode,
  // End maybe Undefined Length
  // EVR Long
  kODCode, kOFCode, kOLCode, kUCCode, kURCode, kUTCode,
  // End Evr Long
  // Begin EVR Short
  kAECode, kASCode, kATCode, kCSCode, kDACode, kDSCode,
  kDTCode, kFDCode, kFLCode, kISCode, kLOCode, kLTCode,
  kPNCode, kSHCode, kSLCode, kSSCode, kSTCode, kTMCode,
  kUICode, kULCode, kUSCode
];

const List<int> vrElementSizeByIndex = <int>[
  // Begin maybe undefined length
  1, // Sequence == 0,
  // Begin EVR Long
  1, 2, 1,
  // End maybe Undefined Length
  // EVR Long
  8, 4, 4, 1, 1, 1,
  // End Evr Long
  // Begin EVR Short
  1, 1, 4, 1, 1, 1, 1,
  8, 4, 1, 1, 1, 1, 1,
  4, 2, 1, 1, 1, 4, 2,
];

/*
static const Map<int, VR> vrByCode = const <int, VR>{
  0x4541: kAE, 0x5341: kAS, 0x5441: kAT, 0x5343: kCS, 0x4144: kDA,
  0x5344: kDS, 0x5444: kDT, 0x4446: kFD, 0x4c46: kFL, 0x5349: kIS,
  0x4f4c: kLO, 0x544c: kLT, 0x424f: kOB, 0x444f: kOD, 0x464f: kOF,
  0x4c4f: kOL, 0x574f: kOW, 0x4e50: kPN, 0x4853: kSH, 0x4c53: kSL,
  0x5153: kSQ, 0x5353: kSS, 0x5453: kST, 0x4d54: kTM, 0x4355: kUC,
  0x4955: kUI, 0x4c55: kUL, 0x4e55: kUN, 0x5255: kUR, 0x5355: kUS,
  0x5455: kUT // No reformat
};
*/

// Const [VR.code]s as 16-bit littleendian values.
// This allows the code to be retrieved in one instruction instead of two.
const int kAECode = 0x4145;
const int kASCode = 0x4153;
const int kATCode = 0x4154;
const int kCSCode = 0x4353;

const int kDACode = 0x4441;
const int kDSCode = 0x4453;
const int kDTCode = 0x4454;
const int kFDCode = 0x4644;

const int kFLCode = 0x464c;
const int kISCode = 0x4953;
const int kLOCode = 0x4c4f;
const int kLOMaxLength = 64;
const int kLTCode = 0x4c54;

const int kLTMaxLength = 10240;
const int kOBCode = 0x4f42;
const int kODCode = 0x4f44;
const int kOFCode = 0x4f46;
const int kOLCode = 0x4f4c;

const int kOWCode = 0x4f57;
const int kPNCode = 0x504e;
const int kSHCode = 0x5348;
const int kSHMaxLength = 16;
const int kSLCode = 0x534c;

const int kSQCode = 0x5351;
const int kSSCode = 0x5353;
const int kSTCode = 0x5354;
const int kSTMaxLength = 1024;
const int kTMCode = 0x544d;

const int kUCCode = 0x5543;
const int kUCMaxLength = kMaxLongVF;
const int kUICode = 0x5549;
const int kULCode = 0x554c;
const int kUNCode = 0x554e;

const int kURCode = 0x5552;
const int kUSCode = 0x5553;
const int kUTCode = 0x5554;
const int kUTMaxLength = kMaxLongVF;

const Map<int, int> vrIndexByCode8Bit = <int, int>{
  kAECode: kAEIndex, kASCode: kASIndex, kATCode: kATIndex, kCSCode: kCSIndex,
  kDACode: kDAIndex, kDSCode: kDSIndex, kDTCode: kDTIndex, kFDCode: kFDIndex,
  kFLCode: kFLIndex, kISCode: kISIndex, kLOCode: kLOIndex, kLTCode: kLTIndex,
  kOBCode: kOBIndex, kODCode: kODIndex, kOFCode: kOFIndex, kOLCode: kOLIndex,
  kOWCode: kOWIndex, kPNCode: kPNIndex, kSHCode: kSHIndex, kSLCode: kSLIndex,
  kSQCode: kSQIndex, kSSCode: kSSIndex, kSTCode: kSTIndex, kTMCode: kTMIndex,
  kUCCode: kUCIndex, kUICode: kUIIndex, kULCode: kULIndex, kUNCode: kUNIndex,
  kURCode: kURIndex, kUSCode: kUSIndex, kUTCode: kUTIndex // No reformat
};

int vrIndexFromCode(int vrCode) => vrIndexByCode8Bit[vrCode];
String vrIdFromCode(int vrCode) => vrIdByIndex[vrIndexByCode8Bit[vrCode]];

/*
// Const [VR.code]s as 16-bit little endian values.
// This allows the code to be retrieved in one instruction instead of two.
const int kAECode = 0X4541;
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
const int kLOMaxLength = 64;
const int kLTCode = 0X544c;
const int kLTMaxLength = 10240;
const int kOBCode = 0X424f;
const int kODCode = 0X444f;
const int kOFCode = 0X464f;
const int kOLCode = 0X4c4f;
const int kOWCode = 0X574f;
const int kPNCode = 0X4e50;
const int kSHCode = 0X4853;
const int kSHMaxLength = 16;
const int kSLCode = 0X4c53;
const int kSQCode = 0X5153;
const int kSSCode = 0X5353;
const int kSTCode = 0X5453;
const int kSTMaxLength = 1024;
const int kTMCode = 0X4d54;
const int kUCCode = 0X4355;
const int kUCMaxLength = kMaxLongVF;
const int kUICode = 0X4955;
const int kULCode = 0X4c55;
const int kUNCode = 0X4e55;
const int kURCode = 0X5255;
const int kUSCode = 0X5355;
const int kUTCode = 0X5455;
const int kUTMaxLength = kMaxLongVF;


const Map<int, int> vrIndexByCode16BitLE = const <int, int>{
  0x4541: kAEIndex, 0x5341: kASIndex, 0x5441: kATIndex, 0x5343: kCSIndex,
  0x4144: kDAIndex, 0x5344: kDSIndex, 0x5444: kDTIndex, 0x4446: kFDIndex,
  0x4c46: kFLIndex, 0x5349: kISIndex, 0x4f4c: kLOIndex, 0x544c: kLTIndex,
  0x424f: kOBIndex, 0x444f: kODIndex, 0x464f: kOFIndex, 0x4c4f: kOLIndex,
  0x574f: kOWIndex, 0x4e50: kPNIndex, 0x4853: kSHIndex, 0x4c53: kSLIndex,
  0x5153: kSQIndex, 0x5353: kSSIndex, 0x5453: kSTIndex, 0x4d54: kTMIndex,
  0x4355: kUCIndex, 0x4955: kUIIndex, 0x4c55: kULIndex, 0x4e55: kUNIndex,
  0x5255: kURIndex, 0x5355: kUSIndex, 0x5455: kUTIndex // No reformat
};
*/
