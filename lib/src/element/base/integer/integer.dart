//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/integer/integer_mixin.dart';
import 'package:core/src/element/base/utils.dart';
import 'package:core/src/error/element_errors.dart';
import 'package:core/src/global.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/values/uid.dart';
import 'package:core/src/vr.dart';

// ignore_for_file: public_member_api_docs

abstract class Integer extends Element<int> {
  @override
  List<int> get values;

  int get sizeInBytes;

  @override
  Integer update([Iterable<int> vList]);

  // **** End of interface

  bool get isBinary => true;

  @override
  int get vfLength => length * sizeInBytes;

  /// Returns a copy of [values]
  @override
  Iterable<int> get valuesCopy => List.from(values, growable: false);

  /// The _canonical_ empty [values] values for Floating Point Elements.
  @override
  List<int> get emptyList => kEmptyList;
  static const List<int> kEmptyList = <int>[];

  @override
  Integer get noValues => update(kEmptyList);

/*
  @override
  ByteData get vfByteData => typedData.buffer
      .asByteData(typedData.offsetInBytes, typedData.lengthInBytes);
*/

  @override
  Bytes get vfBytes => Bytes.typedDataView(typedData);

  /// Returns a [view] of this [Element] with [values] replaced by
  /// appropriate TypedData.
  Integer view([int start = 0, int length]);

  /// Returns true if [v] is in the range [min] <= [v] <= [max].
  static bool isValidValue(int v, Issues issues, int min, int max) {
    if (v < min || v > max) {
      if (issues != null) {
        if (v < min) issues.add('Invalid Value($v) under minimum($min)');
        if (v < min) issues.add('Invalid Value($v) over maximum($max)');
      }
      return false;
    }
    return true;
  }

  /// Returns true if [vList] has a valid length for [tag], and each values in
  /// [vList] is valid for [tag]..
  static bool isValidValues(Tag tag, Iterable<int> vList, Issues issues,
      int minValue, int maxValue, int maxLength, Type type) {
    if (vList == null) return false;
    if (!doTestElementValidity || vList.isEmpty) return true;
    var ok = true;
    if (!Element.isValidLength(tag, vList, issues, maxLength, type)) ok = false;
    for (var v in vList) {
      if (ok && !isValidValue(v, issues, minValue, maxValue)) ok = false;
    }
    return ok ? true : invalidValues(vList, issues);
  }
}

/// Signed Short [Element].
abstract class SS extends Integer with Int16 {
  static const int kVRIndex = kSSIndex;
  static const int kVRCode = kSSCode;
  static const int kSizeInBytes = 2;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kVLFSize = 2;
  static const int kMaxVFLength = k16BitMaxShortVF;
  static const int kMaxLength = k16BitMaxShortLength;
  static const int kMinValue = -(1 << (kSizeInBits - 1));
  static const int kMaxValue = (1 << (kSizeInBits - 1)) - 1;

  static const bool kIsLengthAlwaysValid = false;
  static const bool kIsUndefinedLengthAllowed = false;

  static const String kVRName = 'Signed Short';
  static const String kVRKeyword = 'SS';

  static const Type kType = SS;

  static const List<int> kSpecialSSVRs = [
    kSSIndex,
    kUSSSIndex,
    kUSSSOWIndex
  ];

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

  /// Returns _true_ if both [tag] and [vList] are valid for [SS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) {
    if (tag == null || _isNotValidVR(tag.vrIndex))
      return invalidTag(tag, null, kType);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag, issues) &&
        isValidValues(tag, vList, issues);
  }

  static bool _isNotValidVR(int vr) =>
      !(vr == kSSIndex || vr == kUSSSIndex || vr == kUSSSOWIndex);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [SS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [SS] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null || _isNotValidVR(tag.vrIndex))
      return invalidTag(tag, null, kType);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [SS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [SS] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidTag(Tag tag, [Issues issues]) {
    if (!doTestElementValidity) return true;
    final vrIndex = tag.vrIndex;
    return (tag != null && kSpecialSSVRs.contains(vrIndex))
        ? true
        : invalidTag(tag, issues, kType);
  }

  /// Returns _true_ if [vrIndex] is valid for [SS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [SS] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [ VR.isValidSpecialIndex] is used.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidSpecialIndex(vrIndex, issues, kSSIndex);

  /// Returns _true_ if [vrCode] is valid for [SS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [SS] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [ VR.isValidSpecialCode] is used.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidSpecialCode(vrCode, issues, kSSCode);

  /// Returns _true_ if [vfLength] is valid for this [SS].
  static bool isValidVFLength(int length, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(length, issues)
          : _isValidVFLength(length, issues, kMaxVFLength, kSizeInBytes);

  /// Returns _true_ if [vList].length is valid for [SS].
  static bool isValidLength(Tag tag, Iterable<int> vList, [Issues issues]) {
    if (!Tag.isValidSpecialTag(tag, issues, kSSIndex, kType)) return false;
    if (vList == null) return nullValueError();
    return tag.isValidLength(vList, issues)
        ? true
        : invalidValuesLength(vList, 0, kMaxLength, issues);
  }

  /// Returns _true_ if [values] is valid for [SS].
  static bool isValidValue(int value, [Issues issues]) =>
      _isValidValue(value, issues, kMinValue, kMaxValue);

  /// Returns _true_ if [tag] has a VR of [SS] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      _isValidValues(
          tag, vList, issues, kMinValue, kMaxValue, kMaxLength, kType);
}

/// Signed Long ([SL]) [Element].
abstract class SL extends Integer with Int32 {
  static const int kVRIndex = kSLIndex;
  static const int kVRCode = kSLCode;
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kVLFSize = 2;
  static const int kMaxVFLength = k32BitMaxShortVF;
  static const int kMaxLength = k32BitMaxShortLength;
  static const int kMinValue = -(1 << (kSizeInBits - 1));
  static const int kMaxValue = (1 << (kSizeInBits - 1)) - 1;

  static const bool kIsLengthAlwaysValid = false;
  static const bool kIsUndefinedLengthAllowed = false;

  static const String kVRName = 'Signed Long';
  static const String kVRKeyword = 'SL';

  static const Type kType = SL;

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

  /// Returns _true_ if both [tag] and [vList] are valid for [SL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) {
    if (tag == null || tag.vrIndex != kSLIndex)
      return invalidTag(tag, null, SL);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag, issues) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [SL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null || tag.vrIndex != kSLIndex)
      return invalidTag(tag, null, SL);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [SL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kVRIndex, SL);

  /// Returns _true_ if [vrIndex] is valid for [SL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [SL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kVRCode);

  /// Returns _true_ if [vfLength] is valid for this [SL].
  static bool isValidVFLength(int length, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(length, issues)
          : _isValidVFLength(length, issues, kMaxVFLength, kSizeInBytes);

  /// Returns _true_ if [vList].length is valid for [SL].
  static bool isValidLength(Tag tag, Iterable<int> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, SL);
    if (vList == null) return nullValueError();
    return tag.isValidLength(vList, issues)
        ? true
        : invalidValuesLength(vList, 0, kMaxLength, issues);
  }

  /// Returns _true_ if [values] is valid for [SL].
  static bool isValidValue(int value, [Issues issues]) =>
      _isValidValue(value, issues, kMinValue, kMaxValue);

  /// Returns _true_ if [tag] has a VR of [SL] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength, SL);
}

/// Other Byte [Element].
abstract class OB extends Integer with Uint8 {
  static const int kVRIndex = kOBIndex;
  static const int kVRCode = kOBCode;
  static const int kSizeInBytes = 1;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kVLFSize = 4;
  static const int kMaxVFLength = k8BitMaxLongVF;
  static const int kMaxLength = k8BitMaxLongLength;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;
  static const int kPadChar = 0;

  static const bool kIsLengthAlwaysValid = true;
  static const bool kIsUndefinedLengthAllowed = true;

  static const String kVRName = 'Other Byte';
  static const String kVRKeyword = 'OB';

  static const Type kType = OB;

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
  int get padChar => kPadChar;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  bool get isLengthAlwaysValid => kIsLengthAlwaysValid;
  @override
  bool get isUndefinedLengthAllowed => kIsUndefinedLengthAllowed;

  /// Returns _true_ if both [tag] and [vList] are valid for this [OB].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidArgs(Tag tag, Iterable<int> vList,
      [int vfLengthField, TransferSyntax ts, Issues issues]) {
    if (tag == null || _isNotValidVR(tag.vrIndex))
      return invalidTag(tag, null, OB);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag, issues) &&
        isValidValues(tag, vList, issues);
  }

  static bool _isNotValidVR(int vr) => !(vr == kOBIndex || vr == kOBOWIndex);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [OB].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null || _isNotValidVR(tag.vrIndex))
      return invalidTag(tag, null, OB);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [OB].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidTag(Tag tag, [Issues issues]) {
    if (!doTestElementValidity) return true;
    final vrIndex = tag.vrIndex;
    return (tag != null && (vrIndex == kOBIndex || vrIndex == kOBOWIndex))
        ? true
        : invalidTag(tag, issues, OB);
  }

  /// Returns _true_ if [vrIndex] is valid for [OB].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ VR.isValidSpecialIndex] is used.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidSpecialIndex(vrIndex, issues, kOBIndex);

  /// Returns _true_ if [vrCode] is valid for [OB].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ VR.isValidSpecialCode] is used.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidSpecialCode(vrCode, issues, kOBCode);

  /// Returns _true_ if [vfLength] is valid for this [OB].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, // int vfLengthField,
          [Issues issues,
          Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : _isValidUVFLength(
              vfLength,
              //           vfLengthField,
              issues,
              kMaxVFLength,
              kSizeInBytes,
            );

  /// Returns _true_ if [vList].length is valid for [OB].
  static bool isValidLength(Tag tag, Iterable<int> vList, [Issues issues]) {
    if (!Tag.isValidSpecialTag(tag, issues, kOBIndex, OB)) return false;
    if (vList == null) return nullValueError();
    return tag.isValidLength(vList, issues)
        ? true
        : invalidValuesLength(vList, 0, kMaxLength, issues);
  }

  /// Returns _true_ if [values] is valid for [OB].
  static bool isValidValue(int value, [Issues issues]) =>
      _isValidValue(value, issues, kMinValue, kMaxValue);

  /// Returns _true_ if [tag] has a VR of [OB] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength, OB);
}

/// Unknown (UN) [Element].
abstract class UN extends Integer with Uint8 {
  static const int kVRIndex = kUNIndex;
  static const int kVRCode = kUNCode;
  static const int kSizeInBytes = 1;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kVLFSize = 4;
  static const int kMaxVFLength = k8BitMaxLongVF;
  static const int kMaxLength = k8BitMaxLongLength;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;
  static const int kPadChar = 0;

  static const bool kIsLengthAlwaysValid = true;
  static const bool kIsUndefinedLengthAllowed = true;

  static const String kVRName = 'Unknown';
  static const String kVRKeyword = 'UN';

  static const Type kType = UN;

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
  int get padChar => kPadChar;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  bool get isLengthAlwaysValid => kIsLengthAlwaysValid;
  @override
  bool get isUndefinedLengthAllowed => kIsUndefinedLengthAllowed;

  /// Returns _true_ if both [tag] and [vList] are valid for this [UN].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: UN includes special VRs.
  static bool isValidArgs(Tag tag, Iterable<int> vList,
      [int vfLengthField, TransferSyntax ts, Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UN);
    if (!doTestElementValidity) return true;
    return vList != null &&

        //  Note: UN can take any tag.
        // isValidTag(tag, issues) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [UN].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: UN includes special VRs.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, int vfLengthField,
      [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UN);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        //  Note: UN can take any tag.
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [UN].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: UN includes special VRs.
  static bool isValidTag(Tag tag, [Issues issues]) => true;

  /// Returns _true_ if [vrIndex] is valid for [UN].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: UN includes special VRs.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      vrIndex >= 0 && vrIndex <= kVRSpecialIndexMax;

  /// Returns _true_ if [vrCode] is valid for [UN].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: UN includes special VRs.
  static bool isValidVRCode(int vrCode, [Issues issues]) => true;

  /// Returns _true_ if [vfLength] is valid for this [UN].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : _isValidUVFLength(vfLength, issues, kMaxVFLength, kSizeInBytes);

  /// Returns _true_ if [vList].length is valid for [UN].
  static bool isValidLength(Tag tag, Iterable<int> vList, [Issues issues]) {
    if (!Tag.isValidSpecialTag(tag, issues, kUNIndex, UN)) return false;
    if (vList == null) return nullValueError();
    return tag.isValidLength(vList, issues)
        ? true
        : invalidValuesLength(vList, 0, kMaxLength, issues);
  }

  /// Returns _true_ if [values] is valid for [UN].
  static bool isValidValue(int value, [Issues issues]) =>
      _isValidValue(value, issues, kMinValue, kMaxValue);

  /// Returns _true_ if [tag] has a VR of [UN] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength, UN);
}

/// Other Byte [Element].
abstract class US extends Integer with Uint16 {
  static const int kVRIndex = kUSIndex;
  static const int kVRCode = kUSCode;
  static const int kSizeInBytes = 2;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kVLFSize = 2;
  static const int kMaxVFLength = k16BitMaxShortVF;
  static const int kMaxLength = k16BitMaxShortLength;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  static const bool kIsLengthAlwaysValid = false;
  static const bool kIsUndefinedLengthAllowed = false;

  static const String kVRName = 'Unsigned Short';
  static const String kVRKeyword = 'US';

  static const Type kType = US;

  static const List<int> kSpecialUSVRs = [
    kUSIndex, kUSSSIndex, kUSSSOWIndex, kUSOWIndex // No reformat
  ];

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

  /// Returns _true_ if both [tag] and [vList] are valid for this [US].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [US] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) {
    if (tag == null || _isValidVR(tag.vrIndex))
      return invalidTag(tag, null, US);
    if (!doTestElementValidity) return true;
    return vList != null &&
        Tag.isValidSpecialTag(tag, issues, kUSIndex, US) &&
        isValidValues(tag, vList, issues);
  }

  static bool _isValidVR(int vr) => !(vr == kUSIndex ||
      vr == kUSSSIndex ||
      vr == kUSOWIndex ||
      vr == kUSSSOWIndex);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [US].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [US] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null || _isValidVR(tag.vrIndex))
      return invalidTag(tag, null, US);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [US].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [SS] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidTag(Tag tag, [Issues issues]) {
    if (!doTestElementValidity) return true;
    final vrIndex = tag.vrIndex;
    return (tag != null && kSpecialUSVRs.contains(vrIndex))
        ? true
        : invalidTag(tag, issues, US);
  }

  /// Returns _true_ if [vrIndex] is valid for [US].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [US] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [ VR.isValidSpecialIndex] is used.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidSpecialIndex(vrIndex, issues, kUSIndex);

  /// Returns _true_ if [vrCode] is valid for [US].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [US] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [ VR.isValidSpecialCode] is used.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidSpecialCode(vrCode, issues, kUSCode);

  /// Returns _true_ if [vfLength] is valid for this [US].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : _isValidVFLength(vfLength, issues, kMaxVFLength, kSizeInBytes);

  /// Returns _true_ if [vList].length is valid for [US].
  static bool isValidLength(Tag tag, Iterable<int> vList, [Issues issues]) {
    if (!Tag.isValidSpecialTag(tag, issues, kUSIndex, US)) return false;
    if (vList == null) return nullValueError();
    return tag.isValidLength(vList, issues)
        ? true
        : invalidValuesLength(vList, 0, kMaxLength, issues);
  }

  /// Returns _true_ if [values] is valid for [US].
  static bool isValidValue(int value, [Issues issues]) =>
      _isValidValue(value, issues, kMinValue, kMaxValue);

  /// Returns _true_ if [tag] has a VR of [US] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength, US);
}

/// Unknown (OW) [Element].
abstract class OW extends Integer with Uint16 {
  static const int kVRIndex = kOWIndex;
  static const int kVRCode = kOWCode;
  static const int kSizeInBytes = 2;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kVLFSize = 4;
  static const int kMaxVFLength = k16BitMaxLongVF;
  static const int kMaxLength = k16BitMaxLongLength;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  static const bool kIsLengthAlwaysValid = true;
  static const bool kIsUndefinedLengthAllowed = true;

  static const String kVRName = 'Other Word';
  static const String kVRKeyword = 'OW';

  static const Type kType = OW;

  static const List<int> kSpecialOWVRs = [
    kOWIndex, kOBOWIndex, kUSSSOWIndex, kUSOWIndex // No reformat
  ];

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

  /// Returns _true_ if both [tag] and [vList] are valid for this [OW].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OW] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidArgs(Tag tag, Iterable<int> vList,
      [int vfLengthField, TransferSyntax ts, Issues issues]) {
    if (tag == null || _isNotValidVR(tag.vrIndex))
      return invalidTag(tag, null, OW);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag, issues) &&
        isValidValues(tag, vList, issues);
  }

  static bool _isNotValidVR(int vr) =>
      !(vr == kOWIndex || vr == kOBOWIndex || vr == kUSSSOWIndex);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [OW].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OW] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, int vfLengthField,
      [Issues issues]) {
    if (tag == null || _isNotValidVR(tag.vrIndex))
      return invalidTag(tag, null, OW);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [OW].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OW] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidTag(Tag tag, [Issues issues]) {
    if (!doTestElementValidity) return true;
    final vrIndex = tag.vrIndex;
    return (tag != null && kSpecialOWVRs.contains(vrIndex))
        ? true
        : invalidTag(tag, issues, US);
  }

  /// Returns _true_ if [vrIndex] is valid for [OW].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OW] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ VR.isValidSpecialIndex] is used.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidSpecialIndex(vrIndex, issues, kOWIndex);

  /// Returns _true_ if [vrCode] is valid for [OW].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OW] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ VR.isValidSpecialCode] is used.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidSpecialCode(vrCode, issues, kOWCode);

  /// Returns _true_ if [vfLength] is valid for this [OW].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : _isValidUVFLength(vfLength, issues, kMaxVFLength, kSizeInBytes);

  /// Returns _true_ if [vList].length is valid for [OW].
  static bool isValidLength(Tag tag, Iterable<int> vList, [Issues issues]) {
    if (!Tag.isValidSpecialTag(tag, issues, kOWIndex, OW)) return false;
    if (vList == null) return nullValueError();
    return tag.isValidLength(vList, issues)
        ? true
        : invalidValuesLength(vList, 0, kMaxLength, issues);
  }

  /// Returns _true_ if [values] is valid for [OW].
  static bool isValidValue(int value, [Issues issues]) =>
      _isValidValue(value, issues, kMinValue, kMaxValue);

  /// Returns _true_ if [tag] has a VR of [OW] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength, OW);
}

/// Attribute Tag [Element].
abstract class AT extends Integer with Uint32 {
  static const int kVRIndex = kATIndex;
  static const int kVRCode = kATCode;
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kVLFSize = 2;
  static const int kMaxVFLength = k32BitMaxShortVF;
  static const int kMaxLength = k32BitMaxShortLength;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  static const bool kIsLengthAlwaysValid = false;
  static const bool kIsUndefinedLengthAllowed = false;

  static const String kVRKeyword = 'AT';
  static const String kVRName = 'Attribute Tag';

  static const Type kType = AT;

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

  /// Returns _true_ if both [tag] and [vList] are valid for [AT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) {
    if (tag == null || tag.vrIndex != kATIndex)
      return invalidTag(tag, null, AT);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag, issues) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [AT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null || tag.vrIndex != kATIndex)
      return invalidTag(tag, null, AT);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [AT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kATIndex, AT);

  /// Returns _true_ if [vrIndex] is valid for [AT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kATIndex);

  /// Returns _true_ if [vrCode] is valid for [AT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kATCode);

  /// Returns _true_ if [vfLength] is valid for this [AT].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : _isValidVFLength(vfLength, issues, kMaxVFLength, kSizeInBytes);

  /// Returns _true_ if [vList].length is valid for [AT].
  static bool isValidLength(Tag tag, Iterable<int> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, AT);
    if (vList == null) return nullValueError();
    return tag.isValidLength(vList, issues)
        ? true
        : invalidValuesLength(vList, 0, kMaxLength, issues);
  }

  /// Returns _true_ if [values] is valid for [AT].
  static bool isValidValue(int value, [Issues issues]) =>
      _isValidValue(value, issues, kMinValue, kMaxValue);

  /// Returns _true_ if [tag] has a VR of [AT] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength, AT);
}

/// Other Long [Element].
///
/// VFLength and Values length are always valid.
abstract class OL extends Integer with Uint32 {
  static const int kVRIndex = kOLIndex;
  static const int kVRCode = kOLCode;
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kVLFSize = 4;
  static const int kMaxVFLength = k32BitMaxLongVF;
  static const int kMaxLength = k32BitMaxLongLength;
  static const int kMinValue = 0;
  static const int kMaxValue = 0xFFFFFFFF;

  static const bool kIsLengthAlwaysValid = true;
  static const bool kIsUndefinedLengthAllowed = false;

  static const String kVRName = 'Other Long';
  static const String kVRKeyword = 'OL';

  static const Type kType = OL;

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

  /// Returns _true_ if both [tag] and [vList] are valid for [OL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) {
    if (tag == null || tag.vrIndex != kOLIndex)
      return invalidTag(tag, null, OL);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag, issues) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [OL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null || tag.vrIndex != kOLIndex)
      return invalidTag(tag, null, OL);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [OL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kOLIndex, OL);

  /// Returns _true_ if [vrIndex] is valid for [OL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kOLIndex);

  /// Returns _true_ if [vrCode] is valid for [OL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kOLCode);

  /// Returns _true_ if [vfLength] is valid for this [OL].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : _isValidVFLength(vfLength, issues, kMaxVFLength, kSizeInBytes);

  /// Returns _true_ if [vList].length is valid for [OL].
  static bool isValidLength(Tag tag, Iterable<int> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, OL);
    if (vList == null) return nullValueError();
    return tag.isValidLength(vList, issues)
        ? true
        : invalidValuesLength(vList, 0, kMaxLength, issues);
  }

  /// Returns _true_ if [values] is valid for [OL].
  static bool isValidValue(int value, [Issues issues]) =>
      _isValidValue(value, issues, kMinValue, kMaxValue);

  /// Returns _true_ if [tag] has a VR of [OL] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength, OL);
}

/// Unsigned Long (UL) [Element].
abstract class UL extends Integer with Uint32 {
  static const int kVRIndex = kULIndex;
  static const int kVRCode = kULCode;
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kVLFSize = 2;
  static const int kMaxVFLength = k32BitMaxShortVF;
  static const int kMaxLength = k32BitMaxShortLength;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  static const bool kIsLengthAlwaysValid = false;
  static const bool kIsUndefinedLengthAllowed = false;

  static const String kVRName = 'Unsigned Long';
  static const String kVRKeyword = 'UL';

  static const Type kType = UL;

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

  /// Returns _true_ if both [tag] and [vList] are valid for [UL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) {
    if (tag == null || tag.vrIndex != kULIndex)
      return invalidTag(tag, null, UL);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag, issues) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [UL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null || tag.vrIndex != kULIndex)
      return invalidTag(tag, null, UL);
    if (!doTestElementValidity) return true;
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [UL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kULIndex, UL);

  /// Returns _true_ if [vrIndex] is valid for [UL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kULIndex);

  /// Returns _true_ if [vrCode] is valid for [UL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kULCode);

  /// Returns _true_ if [vfLength] is valid for this [UL].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : _isValidVFLength(vfLength, issues, kMaxVFLength, kSizeInBytes);

  /// Returns _true_ if [vList].length is valid for [UL].
  static bool isValidLength(Tag tag, Iterable<int> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UL);
    if (vList == null) return nullValueError();
    return tag.isValidLength(vList, issues)
        ? true
        : invalidValuesLength(vList, 0, kMaxLength, issues);
  }

  /// Returns _true_ if [values] is valid for [UL].
  static bool isValidValue(int value, [Issues issues]) =>
      _isValidValue(value, issues, kMinValue, kMaxValue);

  /// Returns _true_ if [tag] has a VR of [UL] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength, UL);
}

/// Group Length [Element] is a subtype of [UL]. It always has a tag
/// of the form (gggg,0000).
abstract class GL extends UL {
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRKeyword;
  int get groupLength => value;

  static const String kVRName = 'Group Length';
  static const String kVRKeyword = 'GL';

  static const Type kType = GL;

  /// Returns _true_ if both [tag] and [vList] are valid for this [UL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      UL.isValidArgs(tag, vList, issues);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [UL].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      UL.isValidBytesArgs(tag, vfBytes, issues);

  static bool isValidValues(Tag tag, List<int> vList, [Issues issues]) =>
      UL.isValidValues(tag, vList, issues);
}

/// Checks the the vfLengthField equal either the vfLength or
/// [kUndefinedLength]; and then checks that vfLength (vfl) is
/// in range and the right size, based on the element size (eSize).
bool _isValidUVFLength(int vfLength, Issues issues, int max, int eSize) {
  if (!doTestElementValidity || vfLength == null) return true;
  return _isValidVFLength(vfLength, issues, max, eSize)
      ? true
      : invalidUVFLength(vfLength, max, eSize, issues);
}

/// Returns true if [vfLength] is in the range 0 <= [vfLength] <= [max],
/// and [vfLength] is a multiple of of values size in bytes ([eSize]),
/// i.e. `vfLength % eSize == 0`.
bool _isValidVFLength(int vfLength, Issues issues, int max, int eSize) =>
    (vfLength >= 0 && vfLength <= max && (vfLength % eSize) == 0)
        ? true
        : invalidFixedVFLength(vfLength, max, eSize, issues);

bool _isValidValue(int v, Issues issues, int min, int max) =>
    Integer.isValidValue(v, issues, min, max);

bool _isValidValues(Tag tag, Iterable<int> vList, Issues issues, int minVLength,
        int maxVLength, int maxVFListLength, Type type) =>
    Integer.isValidValues(
        tag, vList, issues, minVLength, maxVLength, maxVFListLength, type);
