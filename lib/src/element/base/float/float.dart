//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/element/base/float/float_mixin.dart';
import 'package:core/src/element/base/utils.dart';
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
  @override
  int get vfLength => length * sizeInBytes;

  static const int kVRIndex = kFLIndex;
  static const int kVRCode = kFLCode;
  static const String kVRKeyword = 'FL';
  static const String kVRName = 'Floating Point Single';
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = k32BitMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  /// Returns _true_ if both [tag] and [vList] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<double> vList) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (!doTestElementValidity) return true;
    return vList != null &&
           isValidTag(tag) &&
           isValidValues(tag, vList);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
           isValidTag(tag, issues) &&
           isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [FL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTag_(tag, issues, kVRIndex, FL);

  /// Returns _true_ if [vrIndex] is valid for [FL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVR(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kFLIndex);

  /// Returns _true_ if [vrCode] is valid for [FL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kFLCode);

  /// Returns _true_ if [vfLength] is valid for this [FL].
  static bool isValidVFLength(int length, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(length, issues)
          : _isValidVFLength(length, kMaxVFLength, kSizeInBytes);

  /// Returns _true_ if [vList].length is valid for [FL].
  static bool isValidLength(Tag tag, Iterable<double> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (vList == null) return nullValueError();
    return tag.isValidLength(vList, issues)
        ? true
        : invalidValuesLength(vList, 0, kMaxLength, issues);
  }

  /// Returns _true_ if [value] is valid for [FL] VR.
  static bool isValidValue(double value, [Issues issues]) => true;

  /// Returns _true_ if each value in [vList] is valid.
  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, FL);
    return isValidVR(tag.vrIndex) &&
        Float.isValidValues(tag, vList, issues, kMaxLength, FL);
  }
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
  int get vfLength => length * sizeInBytes;
  @override
  bool get isLengthAlwaysValid => true;

  static const int kVRIndex = kOFIndex;
  static const int kVRCode = kOFCode;
  static const String kVRKeyword = 'OF';
  static const String kVRName = 'Other Float';
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = k32BitMaxLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  /// Returns _true_ if both [tag] and [vList] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<double> vList) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (!doTestElementValidity) return true;
    return vList != null &&
           isValidTag(tag) &&
           isValidValues(tag, vList);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
           isValidTag(tag, issues) &&
           isValidVFLength(vfBytes.length, issues, tag);
  }

  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTag_(tag, issues, kVRIndex, OF);

  static bool isValidVR(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? true : invalidVRIndex(vrIndex, issues, kVRIndex);

  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? true : invalidVRCode(vrCode, issues, kVRCode);

  static bool isValidVFLength(int length, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(length, issues)
          : _isValidVFLength(length, kMaxVFLength, kSizeInBytes);

  static bool isValidLength(Tag tag, Iterable<double> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (vList == null) return nullValueError();
    return tag.isValidLength(vList, issues)
        ? true
        : invalidValuesLength(vList, 0, kMaxLength, issues);
  }

  /// Returns _true_ if [value] is valid for [FL] VR.
  static bool isValidValue(double value, [Issues issues]) => true;

  /// Returns _true_ if each value in [vList] is valid.
  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, OF);
    return isValidVR(tag.vrIndex) &&
        Float.isValidValues(tag, vList, issues, kMaxLength, OF);
  }
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
  int get vlfSize => 4;
  @override
  int get maxLength => kMaxLength;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  int get vfLength => length * sizeInBytes;

  static const int kVRIndex = kFDIndex;
  static const int kVRCode = kFDCode;
  static const String kVRKeyword = 'FD';
  static const String kVRName = 'Floating Point Double';
  static const int kSizeInBytes = 8;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = k64BitMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  /// Returns _true_ if both [tag] and [vList] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<double> vList) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag) &&
        isValidValues(tag, vList);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTag_(tag, issues, kVRIndex, FD);

  static bool isValidVR(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? true : invalidVRIndex(vrIndex, issues, kVRIndex);

  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? true : invalidVRCode(vrCode, issues, kVRCode);

  static bool isValidVFLength(int length, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(length, issues)
          : _isValidVFLength(length, kMaxVFLength, kSizeInBytes);

  static bool isValidLength(Tag tag, Iterable<double> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (vList == null) return nullValueError();
    return tag.isValidLength(vList, issues)
        ? true
        : invalidValuesLength(vList, 0, kMaxLength, issues);
  }

  /// Returns _true_ if [value] is valid for [FL] VR.
  static bool isValidValue(double value, [Issues issues]) => true;

  /// Returns _true_ if each value in [vList] is valid.
  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, FL);
    return isValidVR(tag.vrIndex) &&
        Float.isValidValues(tag, vList, issues, kMaxLength, FD);
  }
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
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = k64BitMaxLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  /// Returns _true_ if both [tag] and [vList] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<double> vList) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (!doTestElementValidity) return true;
    return vList != null &&
           isValidTag(tag) &&
           isValidValues(tag, vList);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
           isValidTag(tag, issues) &&
           isValidVFLength(vfBytes.length, issues, tag);
  }

  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTag_(tag, issues, kVRIndex, OD);

  static bool isValidVR(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? true : invalidVRIndex(vrIndex, issues, kVRIndex);

  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? true : invalidVRCode(vrCode, issues, kVRCode);

  static bool isValidVFLength(int length, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(length, issues)
          : _isValidVFLength(length, kMaxVFLength, kSizeInBytes);

  static bool isValidLength(int vfl) => true;

  /// Returns _true_ if [value] is valid for [FL] VR.
  static bool isValidValue(double value, [Issues issues]) => true;

  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) =>
      isValidVR(tag.vrIndex) &&
      Float.isValidValues(tag, vList, issues, kMaxLength, OD);

  static bool isNotValidValues(Tag tag, Iterable<double> vList,
          [Issues issues]) =>
      !isValidValues(tag, vList, issues);
}

/// Returns true if [vfLength] is in the range 0 <= [vfLength] <= [max],
/// and [vfLength] is a multiple of of value size in bytes ([sizeInBytes]),
/// i.e. `vfLength % eSize == 0`.
bool _isValidVFLength(int vfLength, int max, int sizeInBytes) =>
   vfLength >= 0 && vfLength <= max && (vfLength % sizeInBytes) == 0;
