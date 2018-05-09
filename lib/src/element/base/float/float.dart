//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/float/float_mixin.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/vr.dart';

// ignore_for_file: avoid_annotating_with_dynamic

/// FL
abstract class FL extends Float with Float32 {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get vlfSize => 4;
  @override
  int get maxLength => kMaxLength;
  @override
  int get maxVFLength => kMaxVFLength;

//  static const VR kVR = VR.kFL;
  static const int kVRIndex = kFLIndex;
  static const int kVRCode = kFLCode;
  static const String kVRKeyword = 'FL';
  static const String kVRName = 'Floating Point Single';
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  static bool isValidArgs(Tag tag, Iterable<double> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVR(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    VR.badIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    VR.badIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    return VR. invalidCode(vrCode, issues, kVRIndex);
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : VR.badIndex(vrIndex, issues, kVRIndex);

  /// Returns
  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : VR.badCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length,
          [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(length, min, max, kSizeInBytes);

  static bool isValidLength(Tag tag, Iterable<double> vList, [Issues issues]) {
    if (tag.vrIndex != kVRIndex) {
      invalidVRIndexForTag(tag, kVRIndex);
      return false;
    }
    return tag.isValidValuesLength(vList, issues);
  }

  /// Returns _true_ if [value] is valid for [FL] VR.
  static bool isValidValue(double value, [Issues issues]) => true;

  /// Returns _true_ if each value in [vList] is valid.
  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      Float.isValidValues(tag, vList, issues, kMaxLength);

  static bool isNotValidValues(Tag tag, Iterable<double> vList,
          [Issues issues]) =>
      !isValidValues(tag, vList, issues);
}

abstract class OF extends Float with Float32 {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get vlfSize => 4;
  @override
  int get maxLength => kMaxLength;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  bool get isLengthAlwaysValid => true;
  @override
  int get vfLength => length * sizeInBytes;

//  static const VR kVR = VR.kOF;
  static const int kVRIndex = kOFIndex;
  static const int kVRCode = kOFCode;
  static const String kVRKeyword = 'OF';
  static const String kVRName = 'Other Float';
  static const int kSizeInBytes = 4;
  static const int kShiftValue = 2;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMax32BitLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  static bool isValidArgs(Tag tag, Iterable<double> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    VR.badIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    return VR. invalidCode(vrCode, issues, kVRIndex);
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : VR.badIndex(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : VR.badCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length,
          [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(length, min, max, kSizeInBytes);

  static bool isValidLength(int vfl) => true;

  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      Float.isValidValues(tag, vList, issues, kMaxLength);

  /// Returns _true_ if [value] is valid for [FL] VR.
  static bool isValidValue(double value, [Issues issues]) => true;

  static bool isNotValidValues(Tag tag, Iterable<double> vList,
          [Issues issues]) =>
      !isValidValues(tag, vList, issues);
}

abstract class FD extends Float with Float64 {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get maxLength => kMaxLength;
  @override
  int get maxVFLength => kMaxVFLength;

//  static const VR kVR = VR.kFD;
  static const int kVRIndex = kFDIndex;
  static const int kVRCode = kFDCode;
  static const String kVRKeyword = 'FD';
  static const String kVRName = 'Floating Point Double';
  static const int kSizeInBytes = 8;
  static const int kShiftValue = 3;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  static bool isValidArgs(Tag tag, Iterable<double> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int index, [Issues issues]) {
    if (index == kVRIndex) return true;
    VR.badIndex(index, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    return VR. invalidCode(vrCode, issues, kVRIndex);
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : VR.badIndex(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : VR.badCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length,
          [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(length, min, max, kSizeInBytes);

  static bool isValidLength(Tag tag, Iterable<double> vList, [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  /// Returns _true_ if [value] is valid for [FL] VR.
  static bool isValidValue(double value, [Issues issues]) => true;

  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      Float.isValidValues(tag, vList, issues, kMaxLength);

  static bool isNotValidValues(Tag tag, Iterable<double> vList,
          [Issues issues]) =>
      !isValidValues(tag, vList, issues);
}

abstract class OD extends Float with Float64 {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get vlfSize => 4;
  @override
  int get maxLength => kMaxLength;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  bool get isLengthAlwaysValid => true;

//  static const VR kVR = VR.kOD;
  static const int kVRIndex = kODIndex;
  static const int kVRCode = kODCode;
  static const String kVRKeyword = 'OD';
  static const String kVRName = 'Other Double';
  static const int kSizeInBytes = 8;
  static const int kShiftValue = 3;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMax64BitLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  static bool isValidArgs(Tag tag, Iterable<double> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int index, [Issues issues]) {
    if (index == kVRIndex) return true;
    VR.badIndex(index, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    return VR. invalidCode(vrCode, issues, kVRIndex);
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : VR.badIndex(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : VR.badCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length,
                              [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(length, min, max, kSizeInBytes);


  static bool isValidLength(int vfl) => true;

  /// Returns _true_ if [value] is valid for [FL] VR.
  static bool isValidValue(double value, [Issues issues]) => true;

  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      Float.isValidValues(tag, vList, issues, kMaxLength);

  static bool isNotValidValues(Tag tag, Iterable<double> vList,
          [Issues issues]) =>
      !isValidValues(tag, vList, issues);
}

bool _inRange(int v, int min, int max) => v >= min && v <= max;

bool _isValidVFLength(int vfl, int min, int max, int sizeInBytes) =>
    _inRange(vfl, min, max) && (vfl % sizeInBytes == 0);
