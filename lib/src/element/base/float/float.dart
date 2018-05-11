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
import 'package:core/src/error/vr_errors.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';
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
      doTestElementValidity && isValidTag(tag) && isValidValues(tag, vList);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      doTestElementValidity &&
      isValidTag(tag, issues) &&
      vfBytes != null &&
      _isValidVFLength(vfBytes.length, kMaxVFLength, kSizeInBytes);

  static bool isValidTag(Tag tag, [Issues issues]) => isValidVR(tag.vrIndex);

  static bool isValidVR(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? true : invalidVRIndex(vrIndex, issues, kVRIndex);

  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? true : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(length, issues)
          : _isValidVFLength(length, kMaxVFLength, kSizeInBytes);

  static bool isValidLength(Tag tag, Iterable<double> vList, [Issues issues]) {
    assert(tag != null);
    if (vList == null) return nullValueError();
    tag.isValidLength(vList, issues);
    if (tag.vrIndex != kVRIndex) {
      invalidVRIndex(tag.vrIndex, issues, kVRIndex, tag);
      return false;
    }
    return tag.isValidValuesLength(vList, issues);
  }

  /// Returns _true_ if [value] is valid for [FL] VR.
  static bool isValidValue(double value, [Issues issues]) => true;

  /// Returns _true_ if each value in [vList] is valid.
  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) =>
      isValidVR(tag.vrIndex) &&
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
      vList != null &&
      (doTestElementValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVR(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVR(tag.vrIndex);

  static bool isValidVR(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? true : invalidVRIndex(vrIndex, issues, kVRIndex);

  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? true : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length,
          [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(length, max, kSizeInBytes);

  static bool isValidLength(int vfl) => true;

  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) =>
      isValidVR(tag.vrIndex) &&
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

  /// Returns _true_ if both [tag] and [vList] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<double> vList) =>
      (doTestElementValidity)
          ? vList != null && isValidTag(tag) && isValidValues(tag, vList)
          : true;

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kSLIndex, FD) &&
      _isValidVFLength(vfBytes.length, kMaxVFLength, kSizeInBytes);

  static bool isValidTag(Tag tag, [Issues issues]) =>
      Element.isValidTag(tag, issues, kVRIndex, FD);

  static bool isNotValidTag(Tag tag) => !isValidVR(tag.vrIndex);

  static bool isValidVR(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? true : invalidVRIndex(vrIndex, issues, kVRIndex);

  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? true : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length, [int max = kMaxVFLength]) =>
      _isValidVFLength(length, max, kSizeInBytes);

  static bool isValidLength(Tag tag, Iterable<double> vList, [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  /// Returns _true_ if [value] is valid for [FL] VR.
  static bool isValidValue(double value, [Issues issues]) => true;

  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) =>
      isValidVR(tag.vrIndex) &&
      Float.isValidValues(tag, vList, issues, kMaxLength);
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

  static bool isValidArgs(Tag tag, Iterable<double> vList, [Issues issues]) =>
      vList != null &&
      (doTestElementValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVR(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVR(tag.vrIndex);

  static bool isValidVR(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? true : invalidVRIndex(vrIndex, issues, kVRIndex);

  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? true : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length,
          [int min = 0, int max = kMaxVFLength]) =>
      _isValidVFLength(length, max, kSizeInBytes);

  static bool isValidLength(int vfl) => true;

  /// Returns _true_ if [value] is valid for [FL] VR.
  static bool isValidValue(double value, [Issues issues]) => true;

  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) =>
      isValidVR(tag.vrIndex) &&
      Float.isValidValues(tag, vList, issues, kMaxLength);

  static bool isNotValidValues(Tag tag, Iterable<double> vList,
          [Issues issues]) =>
      !isValidValues(tag, vList, issues);
}

bool _isValidVFLength(int vfl, int max, int sizeInBytes) =>
    vfl <= max && (vfl % sizeInBytes == 0);
