//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/system.dart';
import 'package:core/src/value/empty_list.dart';

/// VR Constants and Primitives
/// **** New design - not yet implemented ****
/// Designed to make all primitives fast.

// Begin Regular VRs
// Begin maybe undefined
// Begin Evr Long
const int kUNIndex = 0;
const int kValidVRIndexMin = 0;
const int kEvrLongVFVRIndexMin = 0;
const int kMaybeUndefinedVRIndexMin = 0;

const int kSQIndex = 1;
const int kNormalVRIndexMin = 1;

const int kOBIndex = 2;
const int kOWIndex = 3;
const int kMaybeUndefinedVRIndexMax = kOWIndex; // End maybe undefined length

// Begin defined length VRs
const int kOLIndex = 4;
const int kDefinedLengthVRIndexMin = kOLIndex;
const int kEvrDefinedLongVRIndexMin = kOLIndex;

const int kOFIndex = 5;
const int kODIndex = 6;
const int kUCIndex = 7;
const int kUTIndex = 8;
const int kURIndex = 9;
const int kEvrLongVRIndexMax = 9;

const int kSSIndex = 10;
const int kEvrShortVRIndexMin = 10;
const int kEvrShortBinaryMin = 10;

const int kUSIndex = 11;
const int kSLIndex = 12;
const int kULIndex = 13;
const int kATIndex = 14;
const int kFLIndex = 15;
const int kFDIndex = 16;

const int kSHIndex = 17;
const int kLOIndex = 18;
const int kSTIndex = 19;
const int kLTIndex = 20;

const int kISIndex = 21;
const int kDSIndex = 22;


const int kDTIndex = 25;
const int kDAIndex = 24;

const int kTMIndex = 26;
const int kASIndex = 23;

// Special String array
const int kAEIndex = 27; // Short IVR Min
const int kCSIndex = 28;
const int kPNIndex = 29;
const int kUIIndex = 30;
const int kNormalVRIndexMax = 30; // US
const int kDefinedLengthVRIndexMax = 30;


const int kOBOWIndex = 31;
const int kSpecialVRIndexMin = kOBOWIndex;

const int kUSOWIndex = 32;
const int kUSSSIndex = 33;
const int kUSSSOWIndex = 34;
const int kSpecialVRIndexMax = kUSOWIndex;

/// Map of 16-bit Little Endian VR Codes in 16-bit key order
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


const List<String> vrIdByIndex = const <String>[
  'UN', 'SQ',
  'OB', 'OW', 'OL', 'OF', 'OD',
  'UC', 'UT', 'UR',
  'SS', 'US',
  'SL', 'UL', 'AT',
  'FL', 'FD',
  'SH', 'LO', 'ST', 'LT',
  'IS', 'DS',
  'DT', 'DA', 'TM', 'AS',
  'AE', 'CS', 'PN', 'UI',
  'OBOW', 'USOW', 'USSS', 'USSSOW' // No reformat
];

bool isNormalVRIndex(int vrIndex) => vrIndex >= 0 && vrIndex <= 30;
bool isKnownVRIndex(int vrIndex) => vrIndex >= 1 && vrIndex <= 30;
bool isValidVRIndex(int vrIndex) => vrIndex >= 0 && vrIndex <= 34;

bool isSQIndex(int vrIndex) => vrIndex == kSQIndex;

bool isDefinedLengthVRIndex(int vrIndex) =>
    vrIndex >= kDefinedLengthVRIndexMin && vrIndex <= kDefinedLengthVRIndexMax;

bool isEvrShortVRIndex(int vrIndex) =>
    vrIndex >= kEvrShortVRIndexMin && vrIndex <= kNormalVRIndexMax;

bool isEvrLongVRIndex(int vrIndex) =>
    vrIndex >= kEvrDefinedLongVRIndexMin && vrIndex <= kEvrLongVRIndexMax;

/// Returns _true_ if the VR with [vrIndex] is, by definition,
/// always a valid length.
bool isVFLengthAlwaysValid(int vrIndex) =>
    vrIndex >= kSQIndex && vrIndex <= kEvrLongVRIndexMax;

bool isMaybeUndefinedLengthVRIndex(int vrIndex) =>
    vrIndex >= kValidVRIndexMin && vrIndex <= kMaybeUndefinedVRIndexMax;

bool isSpecialVRIndex(int vrIndex) =>
    vrIndex >= kSpecialVRIndexMin && vrIndex <= kSpecialVRIndexMax;

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

const List<int> kUndefinedLengthVRIndices = const <int>[
  kSQIndex,
  kOBIndex,
  kOWIndex,
  kUNIndex
];


const List<int> kNullPaddingVRIndices = const <int>[
  kOBIndex,
  // kUNIndex, // UN should never have padding removed or added
  kUIIndex
];

const List<int> kUndefinedLengthVRCodes = const <int>[
  kSQCode,
  kOBCode,
  kOWCode,
  kUNCode
];

/*

// **** String VRs
const int kAECode = 0X4541;
const int kAEMinLength = 1;
const int kAEMaxLength = 16;
//TODO: implement
bool isValidAEString(String s, Issues issues) => false;
const int kASLength = 4;
*/

Null invalidVR(int vrIndex, Issues issues, int correctVRIndex) {
  final msg = 'Invalid VR(${vrIdByIndex[vrIndex]})';
  return _doError(msg, issues, correctVRIndex);
}

Null invalidVRIndex(int vrIndex, Issues issues, int correctVRIndex) {
  final msg = 'Invalid VR index($vrIndex = ${vrIdByIndex[vrIndex]})';
  return _doError(msg, issues, correctVRIndex);
}

Null invalidVRCode(int vrCode, Issues issues, int correctVRIndex) {
  final msg = 'Invalid VR code(${vrIdByIndex[vrCodeByIndex[vrCode]]})';
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
  if (throwOnError) throw new InvalidVRError(msg);
  return null;
}
