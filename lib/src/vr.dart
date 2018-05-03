//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:convert' as cvt;

import 'package:core/src/dataset.dart';
import 'package:core/src/element.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/value/empty_list.dart';
import 'package:core/src/vr_base.dart';

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

  bool isValidValue(T v, {Issues issues});
  bool isNotValidValue(T v, {Issues issues}) =>
      !isValidValue(v, issues: issues);

  bool isValidIndex(int vrIndex) => vrIndex == index;

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
      cvt.utf8.encode(s);
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
      cvt.utf8.encode(s);
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
