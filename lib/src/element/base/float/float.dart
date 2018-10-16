//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/float/float_mixin.dart';
import 'package:core/src/element/base/utils.dart';
import 'package:core/src/error/vr_errors.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/vr.dart';

// ignore_for_file: public_member_api_docs

// **** Float Elements

// Design notes:
//  1. List<double> does not need to have values checked
//  2. _tdList returns a TypedData List of the appropriate Type.

/// All public constructors should take either List<double> or
/// FloatXXList from [TypedData].
///
/// Note: When
///     ```[new] Foo.fromBytes(key, bytes)```
/// is invoked [values] is always a [Uint8List]; however, when
///     ```[new] Foo(key, [List<double>])```
/// is invoked [values] may be either [TypedData] or [List<double>].
abstract class Float extends Element<double> {
  @override
  List<double> get values;

  int get sizeInBytes;
  // **** End of Interface ****

  @deprecated
  bool get isBinary => true;

  @override
  int get vfLength => length * sizeInBytes;

  /// Returns a copy of [values]
  @override
  List<double> get valuesCopy => List.from(values, growable: false);

  /// The _canonical_ empty [values] values for Floating Point Elements.
  @override
  List<double> get emptyList => kEmptyList;
  static const List<double> kEmptyList = <double>[];

  @override
  ByteData get vfByteData => typedData.buffer.asByteData();

  // Note: Always Bytes not DicomBytes
  @override
  Bytes get vfBytes => Bytes.typedDataView(typedData);

  @override
  Float get noValues => update(kEmptyList);

  @override
  bool checkValue(double v, {Issues issues, bool allowInvalid = false}) => true;

  /// Returns a [view] of this [Element] with [values] replaced by [TypedData].
  Float view([int start = 0, int length]);

  @override
  String toString() => '$runtimeType ${dcm(code)} ($vr) $values';

  /// Returns _true_ if [tag] and each values in [vList] is valid.
  static bool isValidValues(Tag tag, Iterable<double> vList, Issues issues,
      int maxVListLength, Type type) {
    assert(tag != null);
    if (vList == null) return invalidValues(vList, issues, tag);
    return Element.isValidLength(tag, vList, issues, maxVListLength, type);
  }
}

/// FL
abstract class FL extends Float with Float32Mixin {
  static const int kVRIndex = kFLIndex;
  static const int kVRCode = kFLCode;
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kVLFSize = 2;
  static const int kMaxVFLength = k32BitMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  static const bool kIsLengthAlwaysValid = false;
  static const bool kIsUndefinedLengthAllowed = false;

  static const String kVRName = 'Floating Point Single';
  static const String kVRKeyword = 'FL';

  static const Type kType = FL;

  @override
  int get vlfSize => kVLFSize;
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  int get maxLength => kMaxLength;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  bool get isLengthAlwaysValid => kIsLengthAlwaysValid;
  @override
  bool get isUndefinedLengthAllowed => kIsUndefinedLengthAllowed;

  /// Returns _true_ if both [tag] and [vList] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<double> vList) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (!doTestElementValidity) return true;
    return vList != null && isValidTag(tag) && isValidValues(tag, vList);
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
      isValidTagAux(tag, issues, kVRIndex, FL);

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
    if (tag.isValidLength(vList, issues)) return true;
    return invalidValuesLength(vList, 0, kMaxLength, issues);
  }

  /// Returns _true_ if [values] is valid for [FL] VR.
  static bool isValidValue(double value, [Issues issues]) => true;

  /// Returns _true_ if each values in [vList] is valid.
  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, FL);
    return isValidVR(tag.vrIndex) &&
        Float.isValidValues(tag, vList, issues, kMaxLength, FL);
  }
}

abstract class OF extends Float with Float32Mixin {
  static const int kVRIndex = kOFIndex;
  static const int kVRCode = kOFCode;
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kVLFSize = 4;
  static const int kMaxVFLength = k32BitMaxLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  static const bool kIsLengthAlwaysValid = true;
  static const bool kIsUndefinedLengthAllowed = false;

  static const String kVRName = 'Other Float';
  static const String kVRKeyword = 'OF';

  static const Type kType = OF;

  @override
  int get vlfSize => kVLFSize;
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  int get maxLength => kMaxLength;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  bool get isLengthAlwaysValid => kIsLengthAlwaysValid;
  @override
  bool get isUndefinedLengthAllowed => kIsUndefinedLengthAllowed;

  /// Returns _true_ if both [tag] and [vList] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<double> vList) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (!doTestElementValidity) return true;
    return vList != null && isValidTag(tag) && isValidValues(tag, vList);
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
      isValidTagAux(tag, issues, kVRIndex, OF);

  static bool isValidVR(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    return invalidVRIndex(vrIndex, issues, kVRIndex);
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode != kVRCode) return invalidVRCode(vrCode, issues, kVRCode);
    return true;
  }

  static bool isValidVFLength(int length, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(length, issues)
          : _isValidVFLength(length, kMaxVFLength, kSizeInBytes);

  static bool isValidLength(Tag tag, Iterable<double> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (vList == null) return nullValueError();
    if (tag.isValidLength(vList, issues)) return true;
    return invalidValuesLength(vList, 0, kMaxLength, issues);
  }

  /// Returns _true_ if [values] is valid for [FL] VR.
  static bool isValidValue(double value, [Issues issues]) => true;

  /// Returns _true_ if each values in [vList] is valid.
  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, OF);
    return isValidVR(tag.vrIndex) &&
        Float.isValidValues(tag, vList, issues, kMaxLength, OF);
  }
}

abstract class FD extends Float with Float64Mixin {
  static const int kVRIndex = kFDIndex;
  static const int kVRCode = kFDCode;
  static const int kSizeInBytes = 8;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kVLFSize = 2;
  static const int kMaxVFLength = k64BitMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  static const bool kIsLengthAlwaysValid = false;
  static const bool kIsUndefinedLengthAllowed = false;

  static const String kVRName = 'Floating Point Double';
  static const String kVRKeyword = 'FD';

  static const Type kType = FD;

  @override
  int get vlfSize => kVLFSize;
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  int get maxLength => kMaxLength;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  bool get isLengthAlwaysValid => kIsLengthAlwaysValid;
  @override
  bool get isUndefinedLengthAllowed => kIsUndefinedLengthAllowed;

  /// Returns _true_ if both [tag] and [vList] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<double> vList) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (!doTestElementValidity) return true;
    return vList != null && isValidTag(tag) && isValidValues(tag, vList);
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
      isValidTagAux(tag, issues, kVRIndex, FD);

  static bool isValidVR(int vrIndex, [Issues issues]) {
    if (vrIndex != kVRIndex) return invalidVRIndex(vrIndex, issues, kVRIndex);
    return true;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode != kVRCode) return invalidVRCode(vrCode, issues, kVRCode);
    return true;
  }

  static bool isValidVFLength(int length, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(length, issues)
          : _isValidVFLength(length, kMaxVFLength, kSizeInBytes);

  static bool isValidLength(Tag tag, Iterable<double> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (vList == null) return nullValueError();
    if (tag.isValidLength(vList, issues)) return true;
    return invalidValuesLength(vList, 0, kMaxLength, issues);
  }

  /// Returns _true_ if [values] is valid for [FL] VR.
  static bool isValidValue(double value, [Issues issues]) => true;

  /// Returns _true_ if each values in [vList] is valid.
  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, FL);
    return isValidVR(tag.vrIndex) &&
        Float.isValidValues(tag, vList, issues, kMaxLength, FD);
  }
}

abstract class OD extends Float with Float64Mixin {
  static const int kVRIndex = kODIndex;
  static const int kVRCode = kODCode;
  static const int kSizeInBytes = 8;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kVLFSize = 2;
  static const int kMaxVFLength = k64BitMaxLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;

  static const bool kIsLengthAlwaysValid = true;
  static const bool kIsUndefinedLengthAllowed = false;

  static const String kVRName = 'Other Double';
  static const String kVRKeyword = 'OD';

  static const Type kType = OD;

  @override
  int get vlfSize => kVLFSize;
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  int get maxLength => kMaxLength;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  bool get isLengthAlwaysValid => kIsLengthAlwaysValid;
  @override
  bool get isUndefinedLengthAllowed => kIsUndefinedLengthAllowed;

  /// Returns _true_ if both [tag] and [vList] are valid for [FD].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<double> vList) {
    if (tag == null) return invalidTag(tag, null, FL);
    if (!doTestElementValidity) return true;
    return vList != null && isValidTag(tag) && isValidValues(tag, vList);
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
      isValidTagAux(tag, issues, kVRIndex, OD);

  static bool isValidVR(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    return invalidVRIndex(vrIndex, issues, kVRIndex);
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode != kVRCode) return invalidVRCode(vrCode, issues, kVRCode);
    return true;
  }

  static bool isValidVFLength(int length, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(length, issues)
          : _isValidVFLength(length, kMaxVFLength, kSizeInBytes);

  static bool isValidLength(int vfl) => true;

  /// Returns _true_ if [values] is valid for [FL] VR.
  static bool isValidValue(double value, [Issues issues]) => true;

  static bool isValidValues(Tag tag, Iterable<double> vList, [Issues issues]) =>
      isValidVR(tag.vrIndex) &&
      Float.isValidValues(tag, vList, issues, kMaxLength, OD);

  static bool isNotValidValues(Tag tag, Iterable<double> vList,
          [Issues issues]) =>
      !isValidValues(tag, vList, issues);
}

/// Returns true if [vfLength] is in the range 0 <= [vfLength] <= [max],
/// and [vfLength] is a multiple of of values size in bytes ([sizeInBytes]),
/// i.e. `vfLength % eSize == 0`.
bool _isValidVFLength(int vfLength, int max, int sizeInBytes) =>
    vfLength >= 0 && vfLength <= max && (vfLength % sizeInBytes) == 0;
