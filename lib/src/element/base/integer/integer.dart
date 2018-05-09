//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/errors.dart';
import 'package:core/src/element/base/integer/integer_mixin.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/value/uid.dart';
import 'package:core/src/vr.dart';

/// Signed Short [Element].
abstract class SS extends IntBase with Int16 {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get sizeInBytes => kSizeInBytes;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  int get maxLength => kMaxLength;

  static const int kVRIndex = kSSIndex;
  static const int kVRCode = kSSCode;
  static const String kVRKeyword = 'SS';
  static const String kVRName = 'Signed Short';
  static const int kSizeInBytes = 2;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kVFLSize = 2;
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = -(1 << (kSizeInBits - 1));
  static const int kMaxValue = (1 << (kSizeInBits - 1)) - 1;

  /// Returns _true_ if both [tag] and [vList] are valid for this [SS].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [SS] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      Tag.isValidSpecialTag(tag, issues, kSSIndex, SS) &&
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if [tag] is valid for [SS].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [SS] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidTag(Tag tag, [Issues issues]) =>
       Tag.isValidSpecialTag(tag, issues, kSSIndex, SS);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [SS].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [SS] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [ VR.isValidSpecialIndex] is used.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
       VR.isValidSpecialIndex(vrIndex, issues, kSSIndex);

  /// Returns _true_ if [vrCode] is valid for [SS].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [SS] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [ VR.isValidSpecialCode] is used.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
       VR.isValidSpecialCode(vrCode, issues, kSSCode);

  // TODO: should this be checkSpecialVRIndex
  /// Returns [vrIndex] if it is valid for [SS].
  /// If [doTestValidity] is _false_ then no checking is done.
  static int checkVRIndex(int vrIndex, [Issues issues]) =>
       VR.checkIndex(vrIndex, issues, kSSIndex);

  /// Returns _true_ if [vfLength] is valid for this [SS].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, [int max = kMaxVFLength]) =>
      _isValidVFLength(vfLength, max, kSizeInBytes);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [SS].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [SS] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
       Tag.isValidSpecialTag(tag, issues, kSSIndex, SS) &&
      _isValidVFLength(vfBytes.length, kMaxVFLength, kSizeInBytes);

  /// Returns _true_ if [vList].length is valid for [SS].
  static bool isValidVListLength(Tag tag, Iterable<int> vList,
      [Issues issues]) {
    if (! Tag.isValidSpecialTag(tag, issues, kSSIndex, SS))
      return Tag.invalidTag(tag, issues, SS);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [value] is valid for [SS].
  static bool isValidValue(int value, [Issues issues]) =>
      _isValidValue(value, issues, kMinValue, kMaxValue);

  /// Returns _true_ if [tag] has a VR of [SS] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

  static bool isNotValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidValues(tag, vList, issues);
}

/// Signed Long ([SL]) [Element].
abstract class SL extends IntBase with Int32 {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get sizeInBytes => kSizeInBytes;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  int get maxLength => kMaxLength;

  static const int kVRIndex = kSLIndex;
  static const int kVRCode = kSLCode;
  static const String kVRKeyword = 'SL';
  static const String kVRName = 'Signed Long';
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = -(1 << (kSizeInBits - 1));
  static const int kMaxValue = (1 << (kSizeInBits - 1)) - 1;

  /// Returns _true_ if both [tag] and [vList] are valid for this [SL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
       Tag.isValidTag(tag, issues, kSLIndex, SL) &&
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [SL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
       Tag.isValidTag(tag, issues, kSLIndex, SL) &&
      _isValidVFLength(vfBytes.length, kMaxVFLength, kSizeInBytes);

  static bool isNotValidBytesArgs(Tag tag, Iterable<int> vList,
          [Issues issues]) =>
      !isValidBytesArgs(tag, vList, issues);

  /// Returns _true_ if [tag] is valid for [SL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
       Tag.isValidTag(tag, issues, kSLIndex, SL);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [SL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kSLIndex);

  /// Returns _true_ if [vrCode] is valid for [SL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kSLCode);

  /// Returns [vrIndex] if it is valid for [SL]
  /// If [doTestValidity] is _false_ then no checking is done.
  static int checkVRIndex(int vrIndex, [Issues issues]) =>
       VR.checkIndex(vrIndex, issues, kSLIndex);

  /// Returns _true_ if [vfLength] is valid for this [SL].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, [int max = kMaxVFLength]) =>
      _isValidVFLength(vfLength, max, kSizeInBytes);

  /// Returns _true_ if [vList].length is valid for [SL].
  static bool isValidVListLength(Tag tag, Iterable<int> vList,
      [Issues issues]) {
    if (!Tag.isValidTag(tag, issues, kSLIndex, SL))
      return Tag.invalidTag(tag, issues, SL);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [value] is valid for [SL].
  static bool isValidValue(int value, [Issues issues]) =>
      _isValidValue(value, issues, kMinValue, kMaxValue);

  /// Returns _true_ if [tag] has a VR of [SL] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

  static bool isNotValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidValues(tag, vList, issues);
}

/// Other Byte [Element].
abstract class OB extends IntBase with OBMixin, Uint8 {
// *** End Interface
  @override
  int get vfLengthField;
  // *** End Interface

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
  int get maxVFLength => kMaxShortVF;
  @override
  int get maxLength => kMaxLength;
  @override
  bool get isLengthAlwaysValid => true;
  @override
  bool get isUndefinedLengthAllowed => true;
  @override
  bool get hadULength => vfLengthField == kUndefinedLength;

  static const int kVRIndex = kOBIndex;
  static const int kVRCode = kOBCode;
  static const String kVRKeyword = 'OB';
  static const String kVRName = 'Other Byte';
  static const int kSizeInBytes = 1;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMax8BitLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  /// Returns _true_ if both [tag] and [vList] are valid for this [OB].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidArgs(Tag tag, Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts, Issues issues]) =>
       Tag.isValidSpecialTag(tag, issues, kOBIndex, OB) &&
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength) &&
      _isValidUVFLength(
          vList.length * kSizeInBytes, kMaxVFLength, kS, vfLengthField);

  static bool isNotValidArgs(Tag tag, Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts, Issues issues]) =>
      !isValidArgs(tag, vList, vfLengthField, ts, issues);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [OB].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, int vfLengthField,
          [Issues issues]) =>
        Tag.isValidTag(tag, issues, kOBIndex, OB) &&
      _isValidUVFLength(
          vfBytes.length, kMaxVFLength, kSizeInBytes, vfLengthField);

  /// Returns _true_ if [tag] is valid for [OB].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidTag(Tag tag, [Issues issues]) =>
       Tag.isValidSpecialTag(tag, issues, kOBIndex, OB);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [OB].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ VR.isValidSpecialIndex] is used.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
       VR.isValidSpecialIndex(vrIndex, issues, kOBIndex);

  /// Returns _true_ if [vrCode] is valid for [OB].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kOBOWIndex] and [kUOBSOWIndex], so [ VR.isValidSpecialCode] is used.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
       VR.isValidSpecialCode(vrCode, issues, kOBCode);

  /// Returns [vrIndex] if it is valid for [OB].
  /// If [doTestValidity] is _false_ then no checking is done.
  static int checkVRIndex(int vrIndex, [Issues issues]) =>
       VR.checkSpecialIndex(vrIndex, issues, kOBIndex);

  /// Returns _true_ if [vfLength] is valid for this [OB].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, int vfLengthField,
          [int max = kMaxVFLength]) =>
      _isValidUVFLength(vfLength, max, kSizeInBytes, vfLengthField);

  /// Returns _true_ if [vList].length is valid for [OB].
  static bool isValidVListLength(Tag tag, Iterable<int> vList,
      [Issues issues]) {
    if (! Tag.isValidSpecialTag(tag, issues, kOBIndex, OB))
      return Tag.invalidTag(tag, issues, OB);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [value] is valid for [OB].
  static bool isValidValue(int value, [Issues issues]) =>
      _isValidValue(value, issues, kMinValue, kMaxValue);

  /// Returns _true_ if [tag] has a VR of [OB] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

  static bool isNotValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidValues(tag, vList, issues);
}

/// Unknown (UN) [Element].
abstract class UN extends IntBase with Uint8 {
  @override
  int get vfLengthField;
  // End Interface
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
  int get maxVFLength => kMaxShortVF;
  @override
  int get maxLength => kMaxLength;
  @override
  bool get isLengthAlwaysValid => true;
  @override
  bool get isUndefinedLengthAllowed => true;
  @override
  bool get hadULength => vfLengthField == kUndefinedLength;

  static const int kVRIndex = kUNIndex;
  static const int kVRCode = kUNCode;
  static const String kVRKeyword = 'UN';
  static const String kVRName = 'Unknown';
  static const int kSizeInBytes = 1;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMax8BitLongVF;
  static const int kMaxLength = kMaxLongVF;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  /// Returns _true_ if both [tag] and [vList] are valid for [UN].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts, Issues issues]) =>
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength) &&
      _isValidUVFLength(_vfLength(vList, 1), kMaxVFLength, kS, vfLengthField);

  static bool isNotValidArgs(Tag tag, Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts, Issues issues]) =>
      !isValidArgs(tag, vList, vfLengthField, ts, issues);

  /// Returns _true_ if [vfBytes] are valid for [UN]. Ignores [tag].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag _, Bytes vfBytes, int vfLengthField,
          [Issues issues]) =>
      _isValidUVFLength(
          vfBytes.length, kMaxVFLength, kSizeInBytes, vfLengthField);

  /// Returns _true_ if [tag] is valid for [UN].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) => true;

  /// Returns _true_ if [vrIndex] is valid for [UN].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
       VR.isValidSpecialIndex(vrIndex, issues, kUNIndex);

  /// Returns _true_ if [vrCode] is valid for[UN].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
       VR.isValidSpecialCode(vrCode, issues, kUNCode);

  /// Returns [vrIndex] if it is valid for [UN].
  /// If [doTestValidity] is _false_ then no checking is done.
  static int checkVRIndex(int vrIndex, [Issues issues]) =>
       VR.checkSpecialIndex(vrIndex, issues, kUNIndex);

  /// Returns _true_ if [vfLength] is valid for this [UN].
  // Note: Same as [UN].
  static bool isValidVFLength(int vfLength, int vfLengthField,
          [int max = kMaxVFLength]) =>
      OB.isValidVFLength(vfLength, vfLengthField);

  /// Returns _true_ if [vList].length is valid for [UN].
  static bool isValidVListLength(Tag tag, List<int> vList) =>
      OB.isValidVListLength(tag, vList);

  /// Returns _true_ if [value] is valid for [UN].
  static bool isValidValue(int value, [Issues issues]) =>
      OB.isValidValue(value, issues);

  /// Returns _true_ if [tag] has a VR of [UN] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      OB.isValidValues(tag, vList, issues);

  static bool isNotValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidValues(tag, vList, issues);
}

/// Other Byte [Element].
abstract class US extends IntBase with Uint16 {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get maxVFLength => kMaxShortVF;
  @override
  int get maxLength => kMaxLength;

  static const int kVRIndex = kUSIndex;
  static const int kVRCode = kUSCode;
  static const String kVRKeyword = 'US';
  static const String kVRName = 'Unsigned Short';
  static const int kSizeInBytes = 2;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  /// Returns _true_ if both [tag] and [vList] are valid for this [US].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [US] VRs, such as
  // [kUUSSIndex] and [kUSSSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
       Tag.isValidSpecialTag(tag, issues, kUSIndex, US) &&
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if [tag] is valid for [US].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [US] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidTag(Tag tag, [Issues issues]) =>
       Tag.isValidSpecialTag(tag, issues, kUSIndex, US);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [US].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [US] VRs, such as
  // [kUUSSIndex] and [kUSSSOWIndex], so [ VR.isValidSpecialIndex] is used.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
       VR.isValidSpecialIndex(vrIndex, issues, kUSIndex);

  /// Returns _true_ if [vrCode] is valid for [US].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [US] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [ VR.isValidSpecialCode] is used.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
       VR.isValidSpecialCode(vrCode, issues, kUSCode);

  /// Returns [vrIndex] if it is valid for [US].
  /// If [doTestValidity] is _false_ then no checking is done.
  static int checkVRIndex(int vrIndex, [Issues issues]) =>
       VR.checkIndex(vrIndex, issues, kUSIndex);

  /// Returns _true_ if [vfLength] is valid for this [US].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, [int max = kMaxVFLength]) =>
      _isValidVFLength(vfLength, max, kSizeInBytes);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [US].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [US] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
       Tag.isValidSpecialTag(tag, issues, kUSIndex, US) &&
      _isValidVFLength(vfBytes.length, kMaxVFLength, kSizeInBytes);

  /// Returns _true_ if [vList].length is valid for [US].
  static bool isValidVListLength(Tag tag, Iterable<int> vList,
      [Issues issues]) {
    if (! Tag.isValidSpecialTag(tag, issues, kUSIndex, US))
      return Tag.invalidTag(tag, issues, US);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [value] is valid for [US].
  static bool isValidValue(int value, [Issues issues]) =>
      _isValidValue(value, issues, kMinValue, kMaxValue);

  /// Returns _true_ if [tag] has a VR of [US] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

  static bool isNotValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidValues(tag, vList, issues);
}

/// Unknown (OW) [Element].
abstract class OW extends IntBase with Uint16 {
  @override
  int get vfLengthField;
  // End Interface
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
  int get maxVFLength => kMaxLongVF;
  @override
  bool get isLengthAlwaysValid => true;
  @override
  bool get isUndefinedLengthAllowed => true;
  @override
  bool get hadULength => vfLengthField == kUndefinedLength;

  static const int kVRIndex = kOWIndex;
  static const int kVRCode = kOWCode;
  static const String kVRKeyword = 'OW';
  static const String kVRName = 'Other Word';
  static const int kSizeInBytes = 2;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMax16BitLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  /// Returns _true_ if both [tag] and [vList] are valid for this [OW].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OW] VRs, such as
  // [kOBOWIndex] and [kUSSSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidArgs(Tag tag, Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts, Issues issues]) =>
       Tag.isValidSpecialTag(tag, issues, kOWIndex, OW) &&
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength) &&
      _isValidUVFLength(
          vList.length * kSizeInBytes, kMaxVFLength, kS, vfLengthField);

  static bool isNotValidArgs(Tag tag, Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts, Issues issues]) =>
      !isValidArgs(tag, vList, vfLengthField, ts, issues);

  /// Returns _true_ if [tag] is valid for [OW].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OW] VRs, such as
  // [kOBOWIndex] and [kUSSSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidTag(Tag tag, [Issues issues]) =>
       Tag.isValidSpecialTag(tag, issues, kOWIndex, OW);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [OW].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OW] VRs, such as
  // [kOBOWIndex] and [kUSSSOWIndex], so [ VR.isValidSpecialIndex] is used.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
       VR.isValidSpecialIndex(vrIndex, issues, kOWIndex);

  /// Returns _true_ if [vrCode] is valid for [OW].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OW] VRs, such as
  // [kOBOWIndex] and [kUSSSOWIndex], so [ VR.isValidSpecialCode] is used.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
       VR.isValidSpecialCode(vrCode, issues, kOWCode);

  /// Returns [vrIndex] if it is valid for [OW].
  /// If [doTestValidity] is _false_ then no checking is done.
  static int checkVRIndex(int vrIndex, [Issues issues]) =>
       VR.checkSpecialIndex(vrIndex, issues, kOWIndex);

  /// Returns _true_ if [vfLength] is valid for this [OW].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, int vfLengthField,
          [int max = kMaxVFLength]) =>
      _isValidUVFLength(vfLength, max, kSizeInBytes, vfLengthField);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [OW].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OW] VRs, such as
  // [kOBOWIndex] and [kUSSSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, int vfLengthField,
          [Issues issues]) =>
       Tag.isValidSpecialTag(tag, issues, kOWIndex, OW) &&
      _isValidUVFLength(
          vfBytes.length, kMaxVFLength, kSizeInBytes, vfLengthField);

  /// Returns _true_ if [vList].length is valid for [OW].
  static bool isValidVListLength(Tag tag, Iterable<int> vList,
      [Issues issues]) {
    if (! Tag.isValidSpecialTag(tag, issues, kOWIndex, OW))
      return Tag.invalidTag(tag, issues, OW);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [value] is valid for [OW].
  static bool isValidValue(int value, [Issues issues]) =>
      _isValidValue(value, issues, kMinValue, kMaxValue);

  /// Returns _true_ if [tag] has a VR of [OW] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

  static bool isNotValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidValues(tag, vList, issues);
}

/// Attribute Tag [Element].
abstract class AT extends IntBase with Uint32 {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get maxVFLength => kMaxShortVF;
  @override
  int get maxLength => kMaxLength;

  static const int kVRIndex = kATIndex;
  static const int kVRCode = kATCode;
  static const String kVRKeyword = 'AT';
  static const String kVRName = 'Attribute Tag';
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  /// Returns _true_ if both [tag] and [vList] are valid for this [AT].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
       Tag.isValidTag(tag, issues, kATIndex, AT) &&
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if [tag] is valid for [AT].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
       Tag.isValidTag(tag, issues, kATIndex, AT);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [AT].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kATIndex);

  /// Returns _true_ if [vrCode] is valid for [AT].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kATCode);

  /// Returns [vrIndex] if it is valid for [AT].
  /// If [doTestValidity] is _false_ then no checking is done.
  static int checkVRIndex(int vrIndex, [Issues issues]) =>
       VR.checkIndex(vrIndex, issues, kATIndex);

  /// Returns _true_ if [vfLength] is valid for this [AT].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, [int max = kMaxVFLength]) =>
      _isValidVFLength(vfLength, max, kSizeInBytes);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [AT].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
       Tag.isValidTag(tag, issues, kATIndex, AT) &&
      _isValidVFLength(vfBytes.length, kMaxVFLength, kSizeInBytes);

  /// Returns _true_ if [vList].length is valid for [AT].
  static bool isValidVListLength(Tag tag, Iterable<int> vList,
      [Issues issues]) {
    if (!Tag.isValidTag(tag, issues, kATIndex, AT))
      return Tag.invalidTag(tag, issues, AT);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [value] is valid for [AT].
  static bool isValidValue(int value, [Issues issues]) =>
      _isValidValue(value, issues, kMinValue, kMaxValue);

  /// Returns _true_ if [tag] has a VR of [AT] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

  static bool isNotValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidValues(tag, vList, issues);
}

/// Other Long [Element].
///
/// VFLength and Values length are always valid.
abstract class OL extends IntBase with Uint32 {
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
  int get maxVFLength => kMaxVFLength;
  @override
  int get maxLength => kMaxLength;
  @override
  bool get isLengthAlwaysValid => true;

//  static const VR kVR = [VR].kOL;
  static const int kVRIndex = kOLIndex;
  static const int kVRCode = kOLCode;
  static const String kVRKeyword = 'OL';
  static const String kVRName = 'Other Long';
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMax32BitLongVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  /// Returns _true_ if both [tag] and [vList] are valid for this [OL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kOLIndex, OL) &&
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if [tag] is valid for [OL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kOLIndex, OL);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [OL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kOLIndex);

  /// Returns _true_ if [vrCode] is valid for [OL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kOLCode);

  /// Returns [vrIndex] if it is valid for [OL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static int checkVRIndex(int vrIndex, [Issues issues]) =>
       VR.checkIndex(vrIndex, issues, kOLIndex);

  /// Returns _true_ if [vfLength] is valid for this [OL].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, [int max = kMaxVFLength]) =>
      _isValidVFLength(vfLength, max, kSizeInBytes);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [OL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kOLIndex, OL) &&
      _isValidVFLength(vfBytes.length, kMaxVFLength, kSizeInBytes);

  /// Returns _true_ if [vList].length is valid for [OL].
  static bool isValidVListLength(Tag tag, Iterable<int> vList,
      [Issues issues]) {
    if (!Tag.isValidTag(tag, issues, kOLIndex, OL))
      return Tag.invalidTag(tag, issues, OL);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [value] is valid for [OL].
  static bool isValidValue(int value, [Issues issues]) =>
      _isValidValue(value, issues, kMinValue, kMaxValue);

  /// Returns _true_ if [tag] has a VR of [OL] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

  static bool isNotValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidValues(tag, vList, issues);
}

/// Unsigned Long [Element].
abstract class UL extends IntBase with Uint32 {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get maxVFLength => kMaxShortVF;
  @override
  int get maxLength => kMaxLength;

  static const int kVRIndex = kULIndex;
  static const int kVRCode = kULCode;
  static const String kVRKeyword = 'UL';
  static const String kVRName = 'Unsigned Long';
  static const int kSizeInBytes = 4;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ kSizeInBytes;
  static const int kMinValue = 0;
  static const int kMaxValue = (1 << kSizeInBits) - 1;

  /// Returns _true_ if both [tag] and [vList] are valid for this [UL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kULIndex, UL) &&
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if [tag] is valid for [UL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
       Tag.isValidTag(tag, issues, kULIndex, UL);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [UL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kULIndex);

  /// Returns _true_ if [vrCode] is valid for [UL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kULCode);

  /// Returns [vrIndex] if it is valid for [UL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static int checkVRIndex(int vrIndex, [Issues issues]) =>
       VR.checkIndex(vrIndex, issues, kULIndex);

  /// Returns _true_ if [vfLength] is valid for this [UL].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, [int max = kMaxVFLength]) =>
      _isValidVFLength(vfLength, max, kSizeInBytes);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [UL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
       Tag.isValidTag(tag, issues, kULIndex, UL) &&
      _isValidVFLength(vfBytes.length, kMaxVFLength, kSizeInBytes);

  /// Returns _true_ if [vList].length is valid for [UL].
  static bool isValidVListLength(Tag tag, Iterable<int> vList,
      [Issues issues]) {
    if (!Tag.isValidTag(tag, issues, kULIndex, UL))
      return Tag.invalidTag(tag, issues, UL);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [value] is valid for [UL].
  static bool isValidValue(int value, [Issues issues]) =>
      _isValidValue(value, issues, kMinValue, kMaxValue);

  /// Returns _true_ if [tag] has a VR of [UL] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

  static bool isNotValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidValues(tag, vList, issues);
}

/// Group Length [Element] is a subtype of [UL]. It always has a tag
/// of the form (gggg,0000).
abstract class GL extends UL {
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRKeyword;
  int get groupLength => value;

  static const String kVRKeyword = 'GL';
  static const String kVRName = 'Group Length';

  /// Returns _true_ if both [tag] and [vList] are valid for this [UL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      UL.isValidArgs(tag, vList);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [UL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      UL.isValidBytesArgs(tag, vfBytes);

  static bool isValidValues(Tag tag, List<int> vList, [Issues issues]) =>
      UL.isValidValues(tag, vList);
}

bool _inRange(int v, int min, int max) => v >= min && v <= max;




/// Checks that vfLength (vfl) is in range and the right size, based on the
/// element size (eSize).
bool _isValidVFLength(int vfl, int max, int eSize) =>
    (__isValidVFL(vfl, max, eSize))
        ? true
        : invalidVFLength(vfl, max, eSize);

/// Checks the the vfLengthField equal either the vfLength or
/// [kUndefinedLength]; and then checks that vfLength (vfl) is
/// in range and the right size, based on the element size (eSize).
bool _isValidUVFLength(int vfl, int max, int eSize, int vlf) {
  if (!doTestValidity || vlf == null) return true;
  return ((vlf == vfl || vlf == kUndefinedLength) &&
          __isValidVFL(vfl, max, eSize))
      ? true
      : invalidVFLength(vfl, max, eSize, vlf);
}

int _vfLength(Iterable list, int eSize) => list.length * eSize;

/// Returns true if [vfLength] is in the range 0 <= [vfLength] <= [max],
/// and [vfLength] is a multiple of of value size in bytes ([eSize]),
/// i.e. `vfLength % eSize == 0`.
bool __isValidVFL(int vfLength, int max, int eSize) =>
    (_inRange(vfLength, 0, max) && (vfLength % eSize == 0)) ? true : false;

bool _isValidValue(int v, Issues issues, int min, int max) =>
    IntBase.isValidValue(v, issues, min, max);

bool _isValidValues(Tag tag, Iterable<int> vList, Issues issues, int minVLength,
        int maxVLength, int maxVFListLength) =>
    IntBase.isValidValues(
        tag, vList, issues, minVLength, maxVLength, maxVFListLength);
