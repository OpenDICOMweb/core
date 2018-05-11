//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/dataset.dart';
import 'package:core/src/element.dart';
import 'package:core/src/system.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/vr.dart';

const int kShortVF = kMaxShortVF;
const int kLongVF = kMaxLongVF;

// ignore_for_file: Type_annotate_public_apis
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

  bool isValid(int vrIndex) => vrIndex == index;
  bool isNotValid(int vrIndex) => !isValid(vrIndex);

  VR byIndex(int index) => vrByIndex[index];

  @override
  String toString() => '$runtimeType($index) $id code(${hex16(code)})';

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

  /// Returns _true_ if [vrIndex] is equal to [target], which MUST be a valid
  /// _VR Index_. Typically, one of the constants (k_XX_Index) is used.
  static bool isValidIndex(int vrIndex, Issues issues, int target) =>
      (vrIndex == target) ? true : invalidIndex(vrIndex, issues, target);

  /// Returns [vrIndex] if it is equal to [target], which MUST be a valid
  /// _VR Index_. Typically, one of the constants (k_XX_Index) is used.
  static int checkIndex(int vrIndex, Issues issues, int target) =>
      (vrIndex == target) ? vrIndex : badIndex(vrIndex, issues, target);

  static Null badIndex(int vrIndex, Issues issues, int correctVRIndex) {
    final msg = 'Invalid VR index($vrIndex == ${vrIdByIndex[vrIndex]})';
    return _doError(msg, issues, correctVRIndex);
  }

  static bool invalidIndex(int vrIndex, Issues issues, int correctVRIndex) {
    badIndex(vrIndex, issues, correctVRIndex);
    return false;
  }

  /// Returns _true_ if [vrIndex] is equal to [target], which MUST be a
  /// valid _VR Index_. Typically, one of the constants (k_XX_Index) is used,
  /// or a valid _Special VR Index_. This function is only used by [OB],
  /// [OW], [SS], and [US].
  static bool isValidSpecialIndex(int vrIndex, Issues issues, int target) {
    if (vrIndex == target ||
        (vrIndex >= kVRSpecialIndexMin && vrIndex <= kVRSpecialIndexMax))
      return true;
    return invalidIndex(vrIndex, issues, target);
  }

  /// [target] is a valid _VR Code_. One of the constants (k_XX_Index)
  /// is be used.
  static bool isValidCode(int vrCode, Issues issues, int target) =>
      (vrCode == target) ? true : invalidCode(vrCode, issues, target);

  static Null badCode(int vrCode, Issues issues, int correctVRIndex) {
    final msg = 'Invalid VR code(${vrIdByIndex[vrIndexByCode[vrCode]]})';
    return _doError(msg, issues, correctVRIndex);
  }

  static bool invalidCode(int vrCode, Issues issues, int correctVRIndex) {
    badCode(vrCode, issues, correctVRIndex);
    return false;
  }

  /// [target] is a valid _VR Code_. One of the constants (k_XX_Index)
  /// is be used.
  static bool isValidSpecialCode(int vrCode, Issues issues, int target) {
    if (vrCode == target ||
        (vrCode >= kVRSpecialIndexMin && vrCode <= kVRSpecialIndexMax))
      return true;
    return invalidCode(vrCode, issues, target);
  }

  static Null _doError(String message, Issues issues,
      [int badIndex, int goodIndex]) {
    final sb = new StringBuffer(message);
    if (goodIndex != null)
      sb.write(' - correct VR is ${vrIdByIndex[goodIndex]}');
    final msg = '$sb';
    log.error(msg);
    if (issues != null) issues.add(msg);
    if (throwOnError) throw new InvalidVRError(msg, badIndex, goodIndex);
    return null;
  }
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

  static const kFL = const VRFloat(kFLIndex, 'FL', kFLCode, 2, kShortVF, 4);
  static const kFD = const VRFloat(kFDIndex, 'FD', kFDCode, 2, kShortVF, 8);
  static const kOF =
      const VRFloat(kOFIndex, 'OF', kOFCode, 4, kLongVF, 4, true);
  static const kOD =
      const VRFloat(kODIndex, 'OD', kODCode, 4, kLongVF, 8, true);
}

class VRInt extends VR<int> {
  @override
  final int sizeInBytes; // size in bytes
  final int min;
  final int max;
  @override
  final bool isLengthAlwaysValid;

  const VRInt(int index, String id, int code, int vlfSize, int maxVFLength,
      this.sizeInBytes, this.min, this.max,
      // ignore: avoid_positional_boolean_parameters
      [this.isLengthAlwaysValid = false])
      : super(index, id, code, vlfSize, maxVFLength);

  int get maxLength => maxVFLength ~/ sizeInBytes;

  @override
  bool isValid(int vrIndex) => isValid(vrIndex);

  @override
  bool isValidVFLength(int vfLength, int vmMin, int vmMax) {
    final max = vmMax == -1 ? maxLength : vmMax;
    return vfLength >= (vmMin * sizeInBytes) && vfLength <= (max * sizeInBytes);
  }

  static const kUN =
      const VRInt(kUNIndex, 'UN', kUNCode, 4, kLongVF, 1, 0, 255, true);
  static const kOB =
      const VRInt(kOBIndex, 'OB', kOBCode, 4, kLongVF, 1, 0, 255, true);

  static const kSS = const VRInt(kSSIndex, 'SS', kSSCode, 2, kShortVF, 2,
      Int16.kMinValue, Int16.kMaxValue);

  static const kUS = const VRInt(kUSIndex, 'US', kUSCode, 2, kShortVF, 2,
      Uint16.kMinValue, Uint16.kMaxValue);

  static const kOW = const VRInt(kOWIndex, 'OW', kOWCode, 4, kLongVF, 2,
      Uint16.kMinValue, Uint16.kMaxValue, true);

  static const kSL = const VRInt(kSLIndex, 'SL', kSLCode, 2, kShortVF, 4,
      Int32.kMinValue, Int32.kMaxValue);

  static const kUL = const VRInt(kULIndex, 'UL', kULCode, 2, kShortVF, 4,
      Uint32.kMinValue, Uint32.kMaxValue);

  static const kAT = const VRInt(kATIndex, 'AT', kATCode, 2, kShortVF, 4,
      Uint32.kMinValue, Uint32.kMaxValue);

  static const kOL = const VRInt(kOLIndex, 'OL', kOLCode, 4, kLongVF, 4,
      Uint32.kMinValue, Uint32.kMaxValue, true);
}

typedef bool IsValidString(String s, {Issues issues, bool allowInvalid});

class VRAscii extends VR<String> {
  @override
  final int sizeInBytes = 1;
  final int minVLength;
  final int maxVLength;

  const VRAscii(int index, String id, int code, int vlfSize, int maxVFLength,
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

  static const kAS = const VRAscii(kASIndex, 'AS', kASCode, 2, kShortVF, 4, 4);
  static const kDA = const VRAscii(kDAIndex, 'DA', kDACode, 2, kShortVF, 8, 8);
  static const kDT = const VRAscii(kDTIndex, 'DT', kDTCode, 2, kShortVF, 4, 26);
  static const kTM = const VRAscii(kTMIndex, 'TM', kTMCode, 2, kShortVF, 2, 13);

  static const kAE = const VRAscii(kAEIndex, 'AE', kAECode, 2, kShortVF, 1, 16);
  static const kCS = const VRAscii(kCSIndex, 'CS', kCSCode, 2, kShortVF, 1, 16);
  static const kPN =
      const VRAscii(kPNIndex, 'PN', kPNCode, 2, kShortVF, 1, 3 * 64);
  static const kUI = const VRAscii(kUIIndex, 'UI', kUICode, 2, kShortVF, 5, 64);
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

  static const kST = const VRText(kSTIndex, 'ST', kSTCode, 2, kShortVF);
  static const kLT = const VRText(kLTIndex, 'LT', kLTCode, 2, kShortVF);
  static const kUR = const VRText(kURIndex, 'UR', kURCode, 4, kLongVF);
  static const kUT = const VRText(kUTIndex, 'UT', kUTCode, 4, kLongVF);
}

class VRNumber extends VR<String> {
  @override
  final int sizeInBytes = 1;

  const VRNumber(int index, String id, int code, int vlfSize, int maxVFLength)
      : super(index, id, code, vlfSize, maxVFLength);

  @override
  bool get isLengthAlwaysValid => false;

  @override
  bool isValidVFLength(int vfLength, int _, int __) => vfLength > maxVFLength;

  static const kDS = const VRNumber(kDSIndex, 'DS', kDSCode, 2, kShortVF);
  static const kIS = const VRNumber(kISIndex, 'IS', kISCode, 2, kShortVF);
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
  bool isValid(int vrIndex) {
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
