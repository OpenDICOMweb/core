// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:convert';

import 'package:core/src/base.dart';
import 'package:core/src/dataset.dart';
import 'package:core/src/element.dart';
import 'package:core/src/system.dart';


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
const int kVRMaybeUndefinedIndexMin = 1; // OB
const int kVRMaybeUndefinedIndexMax = 3; // UN

const int kVRIvrDefinedIndexMin = 4; // OD
const int kVRIvrDefinedIndexMax = 30; // US

const int kVREvrLongIndexMin = 4; // OD
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
    vrIndex >= kVRIvrDefinedIndexMin && vrIndex <= kVRIvrDefinedIndexMax;

bool isFloatVR(int vrIndex) =>
    vrIndex == kFLIndex ||
    vrIndex == kFDIndex ||
    vrIndex == kOFIndex ||
    vrIndex == kODIndex;

bool isStringVR(int vrIndex) =>
    isShortStringVR(vrIndex) || isLongStringVR(vrIndex);

bool isShortStringVR(int vrIndex) =>
    vrIndex >= kVRIvrDefinedIndexMin && vrIndex <= kVRIvrDefinedIndexMax;

bool isLongStringVR(int vrIndex) =>
    vrIndex >= kVRIvrDefinedIndexMin && vrIndex <= kVRIvrDefinedIndexMax;

/// Returns _true_ if the VR with _vrIndex_
/// is, by definition, always a valid length.
const List<int> kVFLengthAlwaysValidIndices = const <int>[
  kSQIndex, kUNIndex, kOBIndex, kOWIndex, kOLIndex, // No reformat
  kODIndex, kOFIndex, kUCIndex, kURIndex, kUTIndex
];

bool isVFLengthAlwaysValid(int vrIndex) =>
    kVFLengthAlwaysValidIndices.contains(vrIndex);

const List<int> kUndefinedLengthVRIndices = const <int>[
  kSQIndex, kOBIndex, kOWIndex, kUNIndex // No reformat
];

bool isUndefinedLengthAllowed(int vrIndex) =>
    kUndefinedLengthVRCodes.contains(vrIndex);

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

String vrIdFromIndex(int vrIndex) => vrIdByIndex[vrIndex];
int vrIndexFromId(String id) => vrIdByIndex.indexOf(id);

const List<String> vrIdByIndex = const <String>[
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

const List<String> vrNameByIndex = const <String>[
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

const List<VR> vrByIndex = const <VR>[
  // Begin maybe undefined length
  VR.kSQ, // Sequence == 0,
  // Begin EVR Long
  VR.kOB, VR.kOW, VR.kUN,
  // End maybe Undefined Length
  // EVR Long
  VR.kOD, VR.kOF, VR.kOL, VR.kUC, VR.kUR, VR.kUT,
  // End Evr Long
  // Begin EVR Short
  VR.kAE, VR.kAS, VR.kAT, VR.kCS, VR.kDA, VR.kDS, VR.kDT,
  VR.kFD, VR.kFL, VR.kIS, VR.kLO, VR.kLT, VR.kPN, VR.kSH,
  VR.kSL, VR.kSS, VR.kST, VR.kTM, VR.kUI, VR.kUL, VR.kUS,
  // End Evr Short
  // Special
  VR.kOBOW, VR.kUSSS, VR.kUSSSOW, VR.kUSOW
];

const List<int> vrCodeByIndex = const <int>[
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

const List<int> vrElementSizeByIndex = const <int>[
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

int vrIndexFromCode(int vrCode) => vrIndexFromCodeMap[vrCode];

// TODO: would it be better to order this table
//      by value rather than alphabetically?
const Map<int, int> vrIndexFromCodeMap = const <int, int>{
  0x4541: kAEIndex, 0x5341: kASIndex, 0x5441: kATIndex, 0x5343: kCSIndex,
  0x4144: kDAIndex, 0x5344: kDSIndex, 0x5444: kDTIndex, 0x4446: kFDIndex,
  0x4c46: kFLIndex, 0x5349: kISIndex, 0x4f4c: kLOIndex, 0x544c: kLTIndex,
  0x424f: kOBIndex, 0x444f: kODIndex, 0x464f: kOFIndex, 0x4c4f: kOLIndex,
  0x574f: kOWIndex, 0x4e50: kPNIndex, 0x4853: kSHIndex, 0x4c53: kSLIndex,
  0x5153: kSQIndex, 0x5353: kSSIndex, 0x5453: kSTIndex, 0x4d54: kTMIndex,
  0x4355: kUCIndex, 0x4955: kUIIndex, 0x4c55: kULIndex, 0x4e55: kUNIndex,
  0x5255: kURIndex, 0x5355: kUSIndex, 0x5455: kUTIndex // No reformat
};

// ignore_for_file: type_annotate_public_apis

const int kShortVF = kMaxShortVF;
const int kLongVF = kMaxLongVF;

abstract class VR<T> {
  final int index; // done   // done
  final String id; // done called vrKeyword
  final int code;
  final int vlfSize;
  final int maxVFLength;

  const VR(this.index, this.id, this.code, this.vlfSize, this.maxVFLength);

  int get sizeInBytes;

  bool get isLengthAlwaysValid;

  bool isValidVFLength(int vfLength, int minValues, int maxValues);

  bool isValidValue(T v, {Issues issues});
  bool isNotValidValue(T v, {Issues issues}) =>
      !isValidValue(v, issues: issues);

  bool isValidIndex(int vrIndex) => vrIndex == index;

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
  static const kDS = VRNumber.kDS;
  static const kIS = VRNumber.kIS;

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
  @override
  final int sizeInBytes; // size in bytes
  @override
  final bool isLengthAlwaysValid;

  const VRFloat(int index, String id, int code, int vlfSize, int maxVFLength,
      this.sizeInBytes,
      // ignore: avoid_positional_boolean_parameters
      [this.isLengthAlwaysValid = false])
      : super(index, id, code, vlfSize, maxVFLength);

  int get maxLength => maxVFLength ~/ sizeInBytes;

  @override
  bool isValidVFLength(int vfLength, int vmMin, int vmMax) {
    final max = vmMax == -1 ? maxLength : vmMax;
    return vfLength >= (vmMin * sizeInBytes) && vfLength <= (max * sizeInBytes);
  }

  @override
  bool isValidValue(double v, {Issues issues}) => true;

  static const kFL = const VRFloat(kFLIndex, 'FL', kFLCode, 2, kShortVF, 4);
  static const kFD = const VRFloat(kFDIndex, 'FD', kFDCode, 2, kShortVF, 8);
  static const kOF =
      const VRFloat(kOFIndex, 'OF', kOFCode, 4, kLongVF, 4, true);
  static const kOD =
      const VRFloat(kODIndex, 'OD', kODCode, 4, kLongVF, 8, true);
}

typedef bool IsValidIndex(int vrInex);

class VRInt extends VR<int> {
  @override
  final int sizeInBytes; // size in bytes
  final int min;
  final int max;
  final IsValidIndex isValid;
  @override
  final bool isLengthAlwaysValid;

  const VRInt(int index, String id, int code, int vlfSize, int maxVFLength,
      this.sizeInBytes, this.min, this.max, this.isValid,
      // ignore: avoid_positional_boolean_parameters
      [this.isLengthAlwaysValid = false])
      : super(index, id, code, vlfSize, maxVFLength);

  int get maxLength => maxVFLength ~/ sizeInBytes;

  @override
  bool isValidIndex(int vrIndex) => isValid(vrIndex);

  @override
  bool isValidVFLength(int vfLength, int vmMin, int vmMax) {
    final max = vmMax == -1 ? maxLength : vmMax;
    return vfLength >= (vmMin * sizeInBytes) && vfLength <= (max * sizeInBytes);
  }

  @override
  bool isValidValue(int v, {Issues issues}) => v >= min && v <= max;

  static const kUN = const VRInt(
      kUNIndex, 'UN', kUNCode, 4, kLongVF, 1, 0, 255, UN.isValidVRIndex, true);
  static const kOB = const VRInt(
      kOBIndex, 'OB', kOBCode, 4, kLongVF, 1, 0, 255, OB.isValidVRIndex, true);

  static const kSS = const VRInt(kSSIndex, 'SS', kSSCode, 2, kShortVF, 2,
      Int16.kMinValue, Int16.kMaxValue, SS.isValidVRIndex);

  static const kUS = const VRInt(kUSIndex, 'US', kUSCode, 2, kShortVF, 2,
      Uint16.kMinValue, Uint16.kMaxValue, US.isValidVRIndex);

  static const kOW = const VRInt(kOWIndex, 'OW', kOWCode, 4, kLongVF, 2,
      Uint16.kMinValue, Uint16.kMaxValue, OW.isValidVRIndex, true);

  static const kSL = const VRInt(kSLIndex, 'SL', kSLCode, 2, kShortVF, 4,
      Int32.kMinValue, Int32.kMaxValue, SL.isValidVRIndex);

  static const kUL = const VRInt(kULIndex, 'UL', kULCode, 2, kShortVF, 4,
      Uint32.kMinValue, Uint32.kMaxValue, UL.isValidVRIndex);

  static const kAT = const VRInt(kATIndex, 'AT', kATCode, 2, kShortVF, 4,
      Uint32.kMinValue, Uint32.kMaxValue, AT.isValidVRIndex);

  static const kOL = const VRInt(kOLIndex, 'OL', kOLCode, 4, kLongVF, 4,
      Uint32.kMinValue, Uint32.kMaxValue, OL.isValidVRIndex, true);
}

typedef bool IsValidString(String s, {Issues issues, bool allowInvalid});

class VRAscii extends VR<String> {
  @override
  final int sizeInBytes = 1;
  final int minVLength;
  final int maxVLength;
  final IsValidString isValid;

  const VRAscii(int index, String id, int code, int vlfSize, int maxVFLength,
      this.minVLength, this.maxVLength, this.isValid)
      : super(index, id, code, vlfSize, maxVFLength);

  int get maxLength => maxVFLength ~/ 2;

  @override
  bool get isLengthAlwaysValid => false;

  @override
  bool isValidVFLength(int vfLength, int vmMin, int vmMax) {
    final max = vmMax == -1 ? maxLength : vmMax;
    final potentialMaxVFL = max * maxVLength;
    final maxVFL =
        (potentialMaxVFL > maxVFLength) ? maxVFLength : potentialMaxVFL;
    return vfLength >= (vmMin * minVLength) && vfLength <= maxVFL;
  }

  @override
  bool isValidValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValid(s, issues: issues, allowInvalid: allowInvalid);
/*
  ///
  @override
  bool isValidValue(String s, Issues issues, {bool allowInvalid = false}) {
    if (s.isEmpty) return true;
    if (s.length < minVLength || s.length > maxVLength) return false;

    var i = 0;
    // Skip leading spaces
    for (; i < s.length; i++) if (s.codeUnitAt(i) != kSpace) break;
    // If s is all space characters it is illegal
    if (i >= s.length) return false;

    for (; i < s.length; i++) {
      final c = s.codeUnitAt(i);
      if (c <= kSpace || c >= kDelete) break;
    }
    // No trailing spaces
    if (i >= s.length) return true;

    // Skip trailing spaces
    for (; i < s.length; i++) if (s.codeUnitAt(i) != kSpace) return false;
    // Had trailing spaces
    return true;
  }
*/

  static const kAS = const VRAscii(
      kASIndex, 'AS', kASCode, 2, kShortVF, 4, 4, AS.isValidValue);
  static const kDA = const VRAscii(
      kDAIndex, 'DA', kDACode, 2, kShortVF, 8, 8, DA.isValidValue);
  static const kDT = const VRAscii(
      kDTIndex, 'DT', kDTCode, 2, kShortVF, 4, 26, DT.isValidValue);
  static const kTM = const VRAscii(
      kTMIndex, 'TM', kTMCode, 2, kShortVF, 2, 13, TM.isValidValue);

  static const kAE = const VRAscii(
      kAEIndex, 'AE', kAECode, 2, kShortVF, 1, 16, AE.isValidValue);
  static const kCS = const VRAscii(
      kCSIndex, 'CS', kCSCode, 2, kShortVF, 1, 16, CS.isValidValue);
  static const kPN = const VRAscii(
      kPNIndex, 'PN', kPNCode, 2, kShortVF, 1, 3 * 64, PN.isValidValue);
  static const kUI = const VRAscii(
      kUIIndex, 'UI', kUICode, 2, kShortVF, 5, 64, UI.isValidValue);
}

class VRUtf8 extends VR<String> {
  @override
  final int sizeInBytes = 1;
  final int minVLength;
  final int maxVLength;

  const VRUtf8(int index, String id, int code, int vlfSize, int maxVFLength,
      this.minVLength, this.maxVLength)
      : super(index, id, code, vlfSize, maxVFLength);

  int get maxLength => maxVFLength ~/ 2;

  @override
  bool get isLengthAlwaysValid => false;

  @override
  bool isValidVFLength(int vfLength, int vmMin, int vmMax) {
    final max = vmMax == -1 ? maxLength : vmMax;
    final potentialMaxVFL = max * maxVLength;
    final maxVFL =
        (potentialMaxVFL > maxVFLength) ? maxVFLength : potentialMaxVFL;
    return vfLength >= (vmMin * minVLength) && vfLength <= maxVFL;
  }

  @override
  bool isValidValue(String s, {Issues issues, bool allowInvalid = false}) {
    if (s.isEmpty || allowInvalid) return true;
    if (s.length < minVLength || s.length > maxVLength) return false;
    try {
      UTF8.encode(s);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      return false;
    }
    return true;
  }

  static const kSH = const VRUtf8(kSHIndex, 'SH', kSHCode, 2, kShortVF, 1, 16);
  static const kLO = const VRUtf8(kLOIndex, 'LO', kLOCode, 2, kShortVF, 1, 64);
  static const kUC =
      const VRUtf8(kUCIndex, 'UC', kUCCode, 4, kLongVF, 1, kLongVF);
}

class VRText extends VR<String> {
  @override
  final int sizeInBytes = 1;

  const VRText(int index, String id, int code, int vlfSize, int maxVFLength)
      : super(index, id, code, vlfSize, maxVFLength);

  int get maxLength => 1;

  @override
  bool get isLengthAlwaysValid => false;

  @override
  bool isValidVFLength(int vfLength, int _, int __) => vfLength > maxVFLength;

  @override
  bool isValidValue(String s, {Issues issues, bool allowInvalid = false}) {
    if (allowInvalid ||
        s.isEmpty ||
        (s.length <= maxVFLength && allowInvalid == true)) return true;
    try {
      UTF8.encode(s);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      return false;
    }
    return true;
  }

  static const kST = const VRText(kSTIndex, 'ST', kSTCode, 2, kShortVF);
  static const kLT = const VRText(kLTIndex, 'LT', kLTCode, 2, kShortVF);
  static const kUR = const VRText(kURIndex, 'UR', kURCode, 4, kLongVF);
  static const kUT = const VRText(kUTIndex, 'UT', kUTCode, 4, kLongVF);
}

class VRNumber extends VR<String> {
  @override
  final int sizeInBytes = 1;

  final IsValidString isValid;

  const VRNumber(int index, String id, int code, int vlfSize, int maxVFLength,
      this.isValid)
      : super(index, id, code, vlfSize, maxVFLength);

  @override
  bool get isLengthAlwaysValid => false;

  @override
  bool isValidVFLength(int vfLength, int _, int __) => vfLength > maxVFLength;

  @override
  bool isValidValue(String s, {Issues issues, bool allowInvalid = false}) {
    if (s.isEmpty || (s.length <= maxVFLength && allowInvalid == true))
      return true;
    return isValid(s);
  }

  static const kDS =
      const VRNumber(kDSIndex, 'DS', kDSCode, 2, kShortVF, DS.isValidValue);
  static const kIS =
      const VRNumber(kISIndex, 'IS', kISCode, 2, kShortVF, IS.isValidValue);
}

class VRSequence extends VR<Item> {
  const VRSequence(int index, String id, int code, int vlfSize, int maxVFLength)
      : super(index, id, code, vlfSize, maxVFLength);

  @override
  int get sizeInBytes => unsupportedError();
  int get maxLength => unsupportedError();

  @override
  bool get isLengthAlwaysValid => true;

  @override
  bool isValidVFLength(int vfLength, int _, int __) => vfLength > maxVFLength;

  @override
  bool isValidValue(Item value, {Issues issues}) => true;

  static const kSQ = const VRSequence(kSQIndex, 'SQ', kSQCode, 4, kLongVF);
}

class VRSpecial extends VR<int> {
  final List<VRInt> vrs;

  const VRSpecial(
      int index, String id, int code, int vlfSize, int maxVFLength, this.vrs)
      : super(index, id, code, vlfSize, maxVFLength);

  @override
  int get sizeInBytes => unsupportedError();

  @override
  bool get isLengthAlwaysValid => unsupportedError();

  @override
  bool isValidVFLength(int _, int __, int ___) => false;

  @override
  bool isValidValue(int value, {Issues issues}) {
    if (issues != null) issues.add('$id may not have values');
    return false;
  }

  @override
  bool isValidIndex(int vrIndex) {
    for (var vr in vrs) if (vr.index == vrIndex) return true;
    return false;
  }

  static const kOBOW = const VRSpecial(
      kOBOWIndex, 'OBOW', -1, 0, 0, const <VRInt>[VR.kOB, VR.kOW, VR.kUN]);

  static const kUSSS = const VRSpecial(
      kUSSSIndex, 'USSS', -1, 0, 0, const <VRInt>[VR.kUS, VR.kSS, VR.kUN]);

  static const kUSSSOW = const VRSpecial(kUSSSOWIndex, 'kUSSSOW', -1, 0, 0,
      const <VRInt>[VR.kUS, VR.kSS, VR.kOW, VR.kUN]);

  static const kUSOW = const VRSpecial(
      kUSOWIndex, 'USOW', -1, 0, 0, const <VRInt>[VR.kUS, VR.kOW, VR.kUN]);
}

//TODO: try to remove this error from core SDK
Null invalidVR(int vrIndex, Issues issues, int correctVRIndex) {
  final msg = 'Invalid VR(${vrIdByIndex[vrIndex]})';
  return _doError(msg, issues, correctVRIndex);
}

Null invalidVRIndex(int vrIndex, Issues issues, int correctVRIndex) {
  final msg = 'Invalid VR index($vrIndex == ${vrIdByIndex[vrIndex]})';
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
  if (throwOnError) throw new InvalidVRError(msg);
  return null;
}
