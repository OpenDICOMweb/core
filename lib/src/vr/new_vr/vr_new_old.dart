//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/global.dart';
import 'package:core/src/utils/primitives.dart';

// ignore_for_file: type_annotate_public_apis, public_member_api_docs

/// VR Constants and Primitives
/// **** New design - not yet implemented ****
/// Designed to make all primitives fast.

// Begin Regular VRs
// Begin maybe undefined
// Begin Evr Long
const int kVRNormalIndexMin = 0;
const int kSQIndex = 0;
const int kVRIndexMin = kSQIndex;
bool isSequenceVRIndex(int vrIndex) => vrIndex == kSQIndex;

// Begin non-Sequence Evr Long
// Begin binary VRs
const int kVRMaybeUndefinedIndexMin = kUNIndex;
const int kVRLongBinaryMin = -1;
const int kUNIndex = 1;
const int kOBIndex = 2;
const int kOWIndex = 3;
const int kVRMaybeUndefinedIndexMax = kOWIndex;
const int kOLIndex = 4;

bool isMaybeUndefinedLengthVRIndex(int vrIndex) =>
    vrIndex >= kVRLongBinaryMin && vrIndex <= kVRMaybeUndefinedIndexMax;
// End maybe undefined length

// Begin defined length VRs
const int kVRDefinedLengthIndexMin = kODIndex;
const int kVREvrDefinedLongIndexMin = kODIndex;
const int kVRIvrDefinedIndexMin = kODIndex;
const int kODIndex = 5;
const int kOFIndex = 6;

const int kVRLongBinaryMax = -1;

bool isEvrLongBinaryVRIndex(int vrIndex) =>
    vrIndex >= kVREvrDefinedLongIndexMin && vrIndex <= kVRLongBinaryMax;

// End EVR long binary

// Begin String Long Evr
const int kVRStringLongEvrMin = kUCIndex;
const int kUCIndex = 7;
const int kURIndex = 8;
const int kUTIndex = 9; // Long EVR Max
const int kVRStringLongEvrMax = kUTIndex;
const int kVREvrLongIndexMax = kUTIndex; // UT
// End String Long Evr
// End Evr Long

bool isEvrLongVRIndex(int vrIndex) =>
    vrIndex >= kVREvrDefinedLongIndexMin && vrIndex <= kVREvrLongIndexMax;

/// Returns _true_ if the VR with [vrIndex] is, by definition,
/// always a valid length.
bool isVFLengthAlwaysValid(int vrIndex) =>
    vrIndex >= kSQIndex && vrIndex <= kUTIndex;

// Begin Short EVR
// Begin Binary Short Evr
// Begin 16-bit binary
const int kVREvrShortIndexMin = 10; // AE
const int kVREvrShortBinaryMin = 10;
const int kSSIndex = 10;
const int kUSIndex = 11;
// End 16-bit binary

// Begin 32-bit binary
const int kSLIndex = 12;
const int kULIndex = 13;
const int kATIndex = 14;
// Begin Floating Point
const int kFLIndex = 15;
// End 32-bit binary

const int kFDIndex = 16;
// Short EVR Max and IVR Max
const int kVREvrShortBinaryMax = 16;

bool isEvrShortBinaryIndex(int vrIndex) =>
    vrIndex >= kVREvrShortBinaryMin && vrIndex <= kVREvrShortBinaryMax;

bool isDefinedLengthVRIndex(int vrIndex) =>
    vrIndex >= kVRDefinedLengthIndexMin && vrIndex <= kVRDefinedLengthIndexMax;

// End Binary Short Evr

// Begin Short Evr Strings
const int kVREvrShortStringMin = kSHIndex;
// Begin Space Padding
const int kVRSpacePaddingMin = kSHIndex;
// String Array
const int kVRStringArrayMin = kSHIndex;

const int kSHIndex = 17;
const int kLOIndex = 18;

// Test string
const int kSTIndex = 19;
const int kLTIndex = 20;

// Number string array
const int kDSIndex = 21;
const int kISIndex = 22;

// Date/Time string array
const int kASIndex = 23;
const int kDAIndex = 24;
const int kDTIndex = 25;
const int kTMIndex = 26;

// Special String array
const int kAEIndex = 27; // Short IVR Min
const int kCSIndex = 28;
const int kPNIndex = 29;

// Begin String Null padding
const int kUIIndex = 30;
// End String Null Padding
const int kVRStringArrayMax = kUIIndex;
const int kVRShortStringMax = kUIIndex;
const int kVREvrShortIndexMax = 30;
const int kVRIvrDefinedIndexMax = 30; // US
const int kVRNormalIndexMax = 30; // US
const int kVRDefinedLengthIndexMax = 30;

bool isEvrShortVRIndex(int vrIndex) =>
    vrIndex >= kVREvrShortIndexMin && vrIndex <= kVRNormalIndexMax;

bool isIvrDefinedLengthVRIndex(int vrIndex) =>
    vrIndex >= kVRIvrDefinedIndexMin && vrIndex <= kVRIvrDefinedIndexMax;

bool isNormalVRIndex(int vrIndex) =>
    vrIndex >= kVRNormalIndexMin && vrIndex <= kVRNormalIndexMax;
// End Short EVR Strings
// End Short EVR
// End Regular VRs

// Begin Special VRs
const int kVRSpecialIndexMin = kOBOWIndex;
const int kOBOWIndex = 31;
const int kUSSSIndex = 32;
const int kUSSSOWIndex = 33;
const int kUSOWIndex = 34;
const int kVRSpecialIndexMax = kUSOWIndex;

bool isSpecialVRIndex(int vrIndex) =>
    vrIndex >= kVRSpecialIndexMin && vrIndex <= kVRSpecialIndexMax;
// End Special VRs

bool isValidOBIndex(int vrIndex) =>
    vrIndex == kOBIndex || vrIndex == kOBOWIndex;

bool isValidOWIndex(int vrIndex) =>
    vrIndex == kOWIndex || vrIndex == kOBOWIndex || vrIndex == kUSSSOWIndex;

bool isValidSSIndex(int vrIndex) =>
    vrIndex == kSSIndex || vrIndex == kUSSSIndex || vrIndex == kUSSSOWIndex;

bool isValidUSIndex(int vrIndex) =>
    vrIndex == kUSIndex || vrIndex == kUSSSIndex || vrIndex == kUSSSOWIndex;

bool isFloatVR(int vrIndex) =>
    vrIndex == kFLIndex ||
    vrIndex == kFDIndex ||
    vrIndex == kOFIndex ||
    vrIndex == kODIndex;

bool isStringVR(int vrIndex) =>
    isShortStringVR(vrIndex) || isLongStringVR(vrIndex);

bool isLongStringVR(int vrIndex) =>
    vrIndex >= kVRIvrDefinedIndexMin && vrIndex <= kVRStringLongEvrMax;

bool isShortStringVR(int vrIndex) =>
    vrIndex >= kVRShortStringMax && vrIndex <= kVRIvrDefinedIndexMax;

const List<int> kUndefinedLengthVRIndices = <int>[
  kSQIndex,
  kOBIndex,
  kOWIndex,
  kUNIndex
];

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

const List<String> vrIdByIndex = <String>[
  // Begin maybe undefined length
  'SQ', // Sequence == 0,
  // Begin EVR Long integers
  'UN', 'OB', 'OW',
  // End maybe Undefined Length
  'OL',

  // EVR Long floats
  'OD', 'OF',
  // EVR Long Strings
  'UC', 'UR', 'UT',
  // End Evr Long
  // Begin EVR Short
  // Short Numbers
  'SS', 'US', 'SL', 'UL', 'AT', 'FL', 'FD',
  // Short Strings
  'SH', 'LO', 'ST', 'LT',
  // Short Number Strings
  'DS', 'IS',
  // Short Date/Time
  'AS', 'DA', 'DT', 'TM',
  // Special Strings
  'AE', 'CS', 'PN', 'UI',
  // End Evr Short
  // EVR Special VRs
  'OBOW', 'USSS', 'USSSOW', 'USOW'
];

// Const vrCodes as 16-bit values

// Floating Point VRs
const int kFDCode = 0X4446;
const int kFDLength = 8;

const int kFLCode = 0X4c46;
const int kFLLength = 4;

const int kODCode = 0X444f;
const int kODLength = 8;

const int kOFCode = 0X464f;
const int kOFLength = 4;

// **** Integer VRs

const int kOBCode = 0X424f;
const int kOBLength = 1;
const int kOBVFLength = kMaxLongVF;
const int kOBMaxLength = kMaxLongVF;

const int kUNCode = 0X4e55;
const int kSSCode = 0X5353;
const int kUSCode = 0X5355;
const int kOWCode = 0X574f;
const int kSLCode = 0X4c53;
const int kULCode = 0X4c55;
const int kOLCode = 0X4c4f;
const int kATCode = 0X5441;
const int kATLength = 4;

// **** String VRs
const int kAECode = 0X4541;
const int kAEMinLength = 1;
const int kAEMaxLength = 16;
//TODO: implement
bool isValidAEString(String s, Issues issues) => false;

const int kASCode = 0X5341;
const int kASLength = 4;
const int kCSCode = 0X5343;
const int kDACode = 0X4144;
const int kDSCode = 0X5344;
const int kDTCode = 0X5444;
const int kISCode = 0X5349;
const int kLOCode = 0X4f4c;
const int kLTCode = 0X544c;
const int kPNCode = 0X4e50;
const int kSHCode = 0X4853;
const int kSQCode = 0X5153;
const int kSTCode = 0X5453;
const int kTMCode = 0X4d54;
const int kUCCode = 0X4355;
const int kUICode = 0X4955;
const int kURCode = 0X5255;
const int kUTCode = 0X5455;

const List<int> vrBySortedCode = <int>[
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

int vrIndexFromCode(int vrCode) => vrIndexFromCodeMap[vrCode];

//TODO: would it be better to order this table by values
//TODO: rather than alphabetically?
const Map<int, int> vrIndexFromCodeMap = <int, int>{
  0x4541: kAEIndex, 0x5341: kASIndex, 0x5441: kATIndex, 0x5343: kCSIndex,
  0x4144: kDAIndex, 0x5344: kDSIndex, 0x5444: kDTIndex, 0x4446: kFDIndex,
  0x4c46: kFLIndex, 0x5349: kISIndex, 0x4f4c: kLOIndex, 0x544c: kLTIndex,
  0x424f: kOBIndex, 0x444f: kODIndex, 0x464f: kOFIndex, 0x4c4f: kOLIndex,
  0x574f: kOWIndex, 0x4e50: kPNIndex, 0x4853: kSHIndex, 0x4c53: kSLIndex,
  0x5153: kSQIndex, 0x5353: kSSIndex, 0x5453: kSTIndex, 0x4d54: kTMIndex,
  0x4355: kUCIndex, 0x4955: kUIIndex, 0x4c55: kULIndex, 0x4e55: kUNIndex,
  0x5255: kURIndex, 0x5355: kUSIndex, 0x5455: kUTIndex // No reformat
};

const List<VR> vrByIndex = <VR>[
  // Begin maybe undefined length
  VR.kSQ, // Sequence == 0,
  // Begin EVR Long integers
  VR.kUN, VR.kOB, VR.kOW,
  // End maybe Undefined Length
  VR.kOL,
  // EVR Long floats
  VR.kOD, VR.kOF,
  // EVR Long Strings
  VR.kUC, VR.kUR, VR.kUT,
  // End Evr Long
  // Begin EVR Short
  // Short Numbers
  VR.kSS, VR.kUS, VR.kSL, VR.kUL, VR.kAT, VR.kFL, VR.kFD,
  // Short Strings
  VR.kSH, VR.kLO, VR.kST, VR.kLT,
  // Short Number Strings
  VR.kDS, VR.kIS,
  // Short Date/Time
  VR.kAS, VR.kDA, VR.kDT, VR.kTM,
  // Special Strings
  VR.kAE, VR.kCS, VR.kPN, VR.kUI,
  // End Evr Short
  // EVR Special VRs
  //'OBOW', 'USSS', 'USSSOW', 'USOW'
];

// ignore_for_file: type_annotate_public_apis

const int kShortVF = kMaxShortVF;
const int kLongVF = kMaxLongVF;

class VR<T> {
  final int index; // done   // done
  final String id; // done called vrKeyword
  final int code;
  final int vlfSize;
  final int maxVFLength;

  const VR(this.index, this.id, this.code, this.vlfSize, this.maxVFLength);

  VR byIndex(int index) => vrByIndex[index];
  // Sequence == 0,
  static const kSQ = VRSequence.kSQ;

  // Begin EVR Long integers
  static const kUN = VRInt.kUN;
  static const kOB = VRInt.kOB;
  static const kOW = VRInt.kOW;

  // End maybe Undefined Length
  static const kOL = VRInt.kOL;

  // EVR Long floats
  static const kOD = VRFloat.kOD;
  static const kOF = VRFloat.kOF;

  // EVR Long Strings
  static const kUC = VRUtf8.kUC;
  static const kUR = VRText.kUR;
  static const kUT = VRText.kUT;

  // End Evr Long
  // Begin EVR Short
  // Short Numbers
  static const kSS = VRInt.kSS;
  static const kUS = VRInt.kUS;
  static const kSL = VRInt.kSL;
  static const kUL = VRInt.kUL;
  static const kAT = VRInt.kAT;
  static const kFL = VRFloat.kFL;
  static const kFD = VRFloat.kFD;

  // Short Strings
  static const kSH = VRUtf8.kSH;
  static const kLO = VRUtf8.kLO;
  static const kST = VRText.kST;
  static const kLT = VRText.kLT;

  // Short Number Strings
  static const kDS = VRAscii.kDS;
  static const kIS = VRAscii.kIS;

  // Short Date/Time
  static const kAS = VRAscii.kAS;
  static const kDA = VRAscii.kDA;
  static const kDT = VRAscii.kDT;
  static const kTM = VRAscii.kTM;

  // Special Strings
  static const kAE = VRAscii.kAE;
  static const kCS = VRAscii.kCS;
  static const kPN = VRAscii.kPN;
  static const kUI = VRAscii.kUI;

  static const kOBOW = VRSpecial.kOBOW;
  static const kUSSS = VRSpecial.kUSSS;
  static const kUSSSOW = VRSpecial.kUSSSOW;
  static const kUSOW = VRSpecial.kUSOW;
}

class VRFloat extends VR<double> {
  final int sizeInBytes; // size in bytes

  const VRFloat(int index, String id, int code, int vlfSize, int maxVFLength,
      this.sizeInBytes)
      : super(index, id, code, vlfSize, maxVFLength);

  int get maxLength => maxVFLength ~/ sizeInBytes;

  static const kFL = VRFloat(kFLIndex, 'FL', kFLCode, 2, kShortVF, 4);
  static const kFD = VRFloat(kFDIndex, 'FD', kFDCode, 2, kShortVF, 8);
  static const kOF = VRFloat(kOFIndex, 'OF', kOFCode, 4, kLongVF, 4);
  static const kOD = VRFloat(kODIndex, 'OD', kODCode, 4, kLongVF, 8);
}

class VRInt extends VR<int> {
  final int sizeInBytes; // size in bytes

  const VRInt(int index, String id, int code, int vlfSize, int maxVFLength,
      this.sizeInBytes)
      : super(index, id, code, vlfSize, maxVFLength);

  int get maxLength => maxVFLength ~/ sizeInBytes;

  static const kUN = VRInt(kUNIndex, 'UN', kUNCode, 4, kLongVF, 1);
  static const kOB = VRInt(kOBIndex, 'OB', kOBCode, 4, kLongVF, 1);

  static const kSS = VRInt(kSSIndex, 'SS', kSSCode, 2, kShortVF, 2);
  static const kUS = VRInt(kUSIndex, 'US', kUSCode, 2, kShortVF, 2);
  static const kOW = VRInt(kOWIndex, 'OW', kOWCode, 4, kLongVF, 2);

  static const kSL = VRInt(kSLIndex, 'SL', kSLCode, 2, kShortVF, 4);
  static const kUL = VRInt(kULIndex, 'UL', kULCode, 2, kShortVF, 4);
  static const kAT = VRInt(kATIndex, 'AT', kATCode, 2, kShortVF, 4);
  static const kOL = VRInt(kOLIndex, 'OL', kOLCode, 4, kLongVF, 4);
}

class VRAscii extends VR<String> {
  final int minVLength;
  final int maxVLength;

  const VRAscii(int index, String id, int code, int vlfSize, int maxVFLength,
      this.minVLength, this.maxVLength)
      : super(index, id, code, vlfSize, maxVFLength);

  int get maxLength => maxVFLength ~/ 2;

  static const kDS = VRAscii(kDSIndex, 'DS', kDSCode, 2, kShortVF, 1, 16);
  static const kIS = VRAscii(kISIndex, 'IS', kISCode, 2, kShortVF, 1, 12);

  static const kAS = VRAscii(kASIndex, 'AS', kASCode, 2, kShortVF, 4, 4);
  static const kDA = VRAscii(kDAIndex, 'DA', kDACode, 2, kShortVF, 8, 8);
  static const kDT = VRAscii(kDTIndex, 'DT', kDTCode, 2, kShortVF, 4, 26);
  static const kTM = VRAscii(kTMIndex, 'TM', kTMCode, 2, kShortVF, 2, 13);

  static const kAE = VRAscii(kAEIndex, 'AE', kAECode, 2, kShortVF, 1, 16);
  static const kCS = VRAscii(kCSIndex, 'CS', kCSCode, 2, kShortVF, 1, 16);
  static const kPN = VRAscii(kPNIndex, 'PN', kPNCode, 2, kShortVF, 1, 3 * 64);
  static const kUI = VRAscii(kUIIndex, 'UI', kUICode, 2, kShortVF, 5, 64);
}

class VRUtf8 extends VR<String> {
  final int minVLength;
  final int maxVLength;

  const VRUtf8(int index, String id, int code, int vlfSize, int maxVFLength,
      this.minVLength, this.maxVLength)
      : super(index, id, code, vlfSize, maxVFLength);

  int get maxLength => maxVFLength ~/ 2;

  static const kSH = VRUtf8(kSHIndex, 'SH', kSHCode, 2, kShortVF, 1, 16);
  static const kLO = VRUtf8(kLOIndex, 'LO', kLOCode, 2, kShortVF, 1, 64);
  static const kUC = VRUtf8(kUCIndex, 'UC', kUCCode, 4, kLongVF, 1, kLongVF);
}

class VRText extends VR<String> {
  const VRText(int index, String id, int code, int vlfSize, int maxVFLength)
      : super(index, id, code, vlfSize, maxVFLength);

  int get maxLength => 1;

  static const kST = VRText(kSTIndex, 'ST', kSTCode, 2, kShortVF);
  static const kLT = VRText(kLTIndex, 'LT', kLTCode, 2, kShortVF);
  static const kUR = VRText(kURIndex, 'UR', kURCode, 4, kLongVF);
  static const kUT = VRText(kUTIndex, 'UT', kUTCode, 4, kLongVF);
}

class VRSequence extends VR<int> {
  const VRSequence(int index, String id, int code, int vlfSize, int maxVFLength)
      : super(index, id, code, vlfSize, maxVFLength);

  int get maxLength => unsupportedError();

  static const kSQ = VRSequence(kSQIndex, 'SQ', kSQCode, 4, kLongVF);
}

class VRSpecial extends VR<int> {
  final List<VRInt> vrs;

  const VRSpecial(
      int index, String id, int code, int vlfSize, int maxVFLength, this.vrs)
      : super(index, id, code, vlfSize, maxVFLength);

  static const kOBOW =
      VRSpecial(kOBOWIndex, 'OBOW', -1, 0, 0, <VRInt>[VR.kOB, VR.kOW]);
  static const kUSSS =
      VRSpecial(kUSSSIndex, 'USSS', -1, 0, 0, <VRInt>[VR.kUS, VR.kSS]);
  static const kUSSSOW = VRSpecial(
      kUSSSOWIndex, 'kUSSSOW', -1, 0, 0, <VRInt>[VR.kUS, VR.kSS, VR.kOW]);
  static const kUSOW =
      VRSpecial(kUSOWIndex, 'USOW', -1, 0, 0, <VRInt>[VR.kUS, VR.kOW]);
}

Null invalidVR(int vrIndex, Issues issues, int correctVRIndex) {
  final msg = 'Invalid VR(${vrIdByIndex[vrIndex]})';
  return _doError(msg, issues, correctVRIndex);
}

Null invalidVRIndex(int vrIndex, Issues issues, int correctVRIndex) {
  final msg = 'Invalid VR index($vrIndex = ${vrIdByIndex[vrIndex]})';
  return _doError(msg, issues, correctVRIndex);
}

Null invalidVRCode(int vrCode, Issues issues, int correctVRIndex) {
  final msg = 'Invalid VR code(${vrIdByIndex[vrIndexFromCodeMap[vrCode]]})';
  return _doError(msg, issues, correctVRIndex);
}

class InvalidVRError extends Error {
  String msg;

  InvalidVRError(this.msg);

  @override
  String toString() => '$msg';
}

Null _doError(String message, Issues issues, int correctVRIndex) {
  final msg = '$message - correct VR is ${vrIdByIndex[correctVRIndex]}';
  log.error(msg);
  if (issues != null) issues.add(msg);
  if (throwOnError) throw InvalidVRError(msg);
  return null;
}
