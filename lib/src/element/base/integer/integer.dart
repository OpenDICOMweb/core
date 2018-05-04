//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:core/src/element/base/bulkdata.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/errors.dart';
import 'package:core/src/element/base/integer/integer_mixin.dart';
import 'package:core/src/element/base/vf_fragments.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/errors.dart';
import 'package:core/src/value/empty_list.dart';
import 'package:core/src/vr_base.dart';

class IntBulkdataRef extends DelegatingList<int> with BulkdataRef<int> {
  @override
  int code;
  @override
  Uri uri;
  List<int> _values;

  IntBulkdataRef(this.code, this.uri, [this._values]) : super(_values);

  IntBulkdataRef.fromString(this.code, String s, [this._values])
      : uri = Uri.parse(s),
        super(_values);

  List<int> get delegate => _values;

  @override
  List<int> get values => _values ??= getBulkdata(code, uri);
}

abstract class IntBase extends Element<int> {
  @override
  Iterable<int> get values;

  @override
  IntBase update([Iterable<int> vList]);

  @override
  set values(Iterable<int> vList) => unsupportedError('IntBase.values');

  bool get isBinary => true;

  /// Returns a copy of [values]
  @override
  Iterable<int> get valuesCopy => new List.from(values, growable: false);

  /// The _canonical_ empty [values] value for Floating Point Elements.
  @override
  List<int> get emptyList => kEmptyList;
  static const List<int> kEmptyList = const <int>[];

  @override
  IntBase get noValues => update(kEmptyList);

  @override
  ByteData get vfByteData => typedData.buffer
      .asByteData(typedData.offsetInBytes, typedData.lengthInBytes);

  @override
  Bytes get vfBytes => new Bytes.typedDataView(typedData);

  VFFragments get fragments => unsupportedError();

  /// Returns a [view] of this [Element] with [values] replaced by [TypedData].
  IntBase view([int start = 0, int length]);

  static bool isValidValue(int v, Issues issues, int min, int max) =>
      _isValidValue(v, issues, min, max);

  static bool isValidValues(Tag tag, Iterable<int> vList, Issues issues,
          int minVLength, int maxVLength, int maxVFListLength) =>
      _isValidValues(
          tag, vList, issues, minVLength, maxVLength, maxVFListLength);
}

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

//  static const VR kVR = VR.kSS;
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
  // [kUSSSIndex] and [kUSSSOWIndex], so [_isValidSpecialTag] is used.
  static bool isValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      _isValidSpecialTag(tag, issues, kSSIndex, SS) &&
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if [tag] is valid for [SS].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [SS] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [_isValidSpecialTag] is used.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      _isValidSpecialTag(tag, issues, kSSIndex, SS);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [SS].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [SS] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [_isValidSpecialVRIndex] is used.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      _isValidSpecialVRIndex(vrIndex, issues, kSSIndex);

  /// Returns _true_ if [vrCode] is valid for this VR (i.e. [Element] [Type]).
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [SS] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [_isValidSpecialVRCode] is used.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      _isValidSpecialVRCode(vrCode, issues, kSSCode);

  /// Returns [vrIndex] if it is valid for this VR (i.e. [Element]
  /// [Type]). If [doTestValidity] is _false_ then no checking is done.
  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      _checkVRIndex(vrIndex, issues, kSSIndex);

  /// Returns _true_ if [vfLength] is valid for this [SS].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, [int max = kMaxVFLength]) =>
      _isValidVFL(vfLength, max, kSizeInBytes);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [SS].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [SS] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [_isValidSpecialTag] is used.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      _isValidSpecialTag(tag, issues, kSSIndex, SS) &&
      _isValidVFL(vfBytes.length, kMaxVFLength, kSizeInBytes);

  /// Returns _true_ if [vList].length is valid for [SS].
  static bool isValidVListLength(Tag tag, Iterable<int> vList,
      [Issues issues]) {
    if (!_isValidSpecialTag(tag, issues, kSSIndex, SS))
      return isValidTagError(tag, issues, SS);
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

//  static const VR kVR = VR.kSL;
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
      _isValidTag(tag, issues, kSLIndex, SL) &&
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if [tag] is valid for [SL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      _isValidTag(tag, issues, kSLIndex, SL);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [SL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      _isValidVRIndex(vrIndex, issues, kSLIndex);

  /// Returns _true_ if [vrCode] is valid for this VR (i.e. [Element] [Type]).
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      _isValidVRCode(vrCode, issues, kSLCode);

  /// Returns [vrIndex] if it is valid for this VR (i.e. [Element]
  /// [Type]). If [doTestValidity] is _false_ then no checking is done.
  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      _checkVRIndex(vrIndex, issues, kSLIndex);

  /// Returns _true_ if [vfLength] is valid for this [SL].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, [int max = kMaxVFLength]) =>
      _isValidVFL(vfLength, max, kSizeInBytes);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [SL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      _isValidTag(tag, issues, kSLIndex, SL) &&
      _isValidVFL(vfBytes.length, kMaxVFLength, kSizeInBytes);

  /// Returns _true_ if [vList].length is valid for [SL].
  static bool isValidVListLength(Tag tag, Iterable<int> vList,
      [Issues issues]) {
    if (!_isValidTag(tag, issues, kSLIndex, SL))
      return isValidTagError(tag, issues, SL);
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
  // [kUOBSIndex] and [kUOBSOWIndex], so [_isValidSpecialTag] is used.
  static bool isValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      _isValidSpecialTag(tag, issues, kOBIndex, OB) &&
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if [tag] is valid for [OB].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kUOBSIndex] and [kUOBSOWIndex], so [_isValidSpecialTag] is used.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      _isValidSpecialTag(tag, issues, kOBIndex, OB);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [OB].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kUOBSIndex] and [kUOBSOWIndex], so [_isValidSpecialVRIndex] is used.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      _isValidSpecialVRIndex(vrIndex, issues, kOBIndex);

  /// Returns _true_ if [vrCode] is valid for this VR (i.e. [Element] [Type]).
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kUOBSIndex] and [kUOBSOWIndex], so [_isValidSpecialVRCode] is used.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      _isValidSpecialVRCode(vrCode, issues, kOBCode);

  /// Returns [vrIndex] if it is valid for this VR (i.e. [Element]
  /// [Type]). If [doTestValidity] is _false_ then no checking is done.
  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      _checkSpecialVRIndex(vrIndex, issues, kOBIndex);

  /// Returns _true_ if [vfLength] is valid for this [OB].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, int vfLengthField,
          [int max = kMaxVFLength]) =>
      _isValidUVFL(vfLength, max, kSizeInBytes, vfLengthField);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [OB].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OB] VRs, such as
  // [kUOBSIndex] and [kUOBSOWIndex], so [_isValidSpecialTag] is used.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, int vfLengthField,
          [Issues issues]) =>
      _isValidTag(tag, issues, kOBIndex, OB) &&
      _isValidUVFL(vfBytes.length, kMaxVFLength, kSizeInBytes, vfLengthField);

  /// Returns _true_ if [vList].length is valid for [OB].
  static bool isValidVListLength(Tag tag, Iterable<int> vList,
      [Issues issues]) {
    if (!_isValidSpecialTag(tag, issues, kOBIndex, OB))
      return isValidTagError(tag, issues, OB);
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

  static bool isValidArgs(Tag tag, Iterable<int> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) => true;

  static bool isValidVRCode(int vrCode, [Issues issues]) => true;

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (isValidVRIndex(vrIndex))
          ? vrIndex
          : badVRIndex(vrIndex, issues, kVRIndex);

//  static bool isValidVFLength(int vfl) => _inRange(vfl, 0, kMaxVFLength);

//  static bool isValidVListLength(int vfl) => true;
  /// Returns _true_ if [vfLength] is valid for this [OW].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, int vfLengthField,
          [int max = kMaxVFLength]) =>
      _isValidUVFL(vfLength, max, kSizeInBytes, vfLengthField);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [OW].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OW] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [_isValidSpecialTag] is used.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, int vfLengthField,
          [Issues issues]) =>
      _isValidSpecialTag(tag, issues, kOWIndex, OW) &&
      _isValidUVFL(vfBytes.length, kMaxVFLength, kSizeInBytes, vfLengthField);

  static bool isValidValue(int v, [Issues issues]) =>
      _isValidValue(v, issues, kMinValue, kMaxValue);

  // UN values are always true, since the read VR is unknown
  static bool isValidValues(Tag tag, Iterable<int> vList, [Issues issues]) =>
      ((vList is Uint8List) && (vList.length <= kMaxVFLength))
          ? true
          : _isValidValues(
              tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

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

//  static const VR kVR = VR.kUS;
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
  // [kUUSSIndex] and [kUSSSOWIndex], so [_isValidSpecialTag] is used.
  static bool isValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      _isValidSpecialTag(tag, issues, kUSIndex, US) &&
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if [tag] is valid for [US].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [US] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [_isValidSpecialTag] is used.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      _isValidSpecialTag(tag, issues, kUSIndex, US);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [US].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [US] VRs, such as
  // [kUUSSIndex] and [kUSSSOWIndex], so [_isValidSpecialVRIndex] is used.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      _isValidSpecialVRIndex(vrIndex, issues, kUSIndex);

  /// Returns _true_ if [vrCode] is valid for this VR (i.e. [Element] [Type]).
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [US] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [_isValidSpecialVRCode] is used.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      _isValidSpecialVRCode(vrCode, issues, kUSCode);

  /// Returns [vrIndex] if it is valid for this VR (i.e. [Element]
  /// [Type]). If [doTestValidity] is _false_ then no checking is done.
  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      _checkVRIndex(vrIndex, issues, kUSIndex);

  /// Returns _true_ if [vfLength] is valid for this [US].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, [int max = kMaxVFLength]) =>
      _isValidVFL(vfLength, max, kSizeInBytes);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [US].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [US] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [_isValidSpecialTag] is used.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      _isValidSpecialTag(tag, issues, kUSIndex, US) &&
      _isValidVFL(vfBytes.length, kMaxVFLength, kSizeInBytes);

  /// Returns _true_ if [vList].length is valid for [US].
  static bool isValidVListLength(Tag tag, Iterable<int> vList,
      [Issues issues]) {
    if (!_isValidSpecialTag(tag, issues, kUSIndex, US))
      return isValidTagError(tag, issues, US);
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
  // [kUSSSIndex] and [kUSSSOWIndex], so [_isValidSpecialTag] is used.
  static bool isValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      _isValidSpecialTag(tag, issues, kOWIndex, OW) &&
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if [tag] is valid for [OW].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OW] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [_isValidSpecialTag] is used.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      _isValidSpecialTag(tag, issues, kOWIndex, OW);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [OW].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OW] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [_isValidSpecialVRIndex] is used.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      _isValidSpecialVRIndex(vrIndex, issues, kOWIndex);

  /// Returns _true_ if [vrCode] is valid for this VR (i.e. [Element] [Type]).
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OW] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [_isValidSpecialVRCode] is used.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      _isValidSpecialVRCode(vrCode, issues, kOWCode);

  /// Returns [vrIndex] if it is valid for this VR (i.e. [Element]
  /// [Type]). If [doTestValidity] is _false_ then no checking is done.
  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      _checkVRIndex(vrIndex, issues, kOWIndex);

  /// Returns _true_ if [vfLength] is valid for this [OW].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, int vfLengthField,
          [int max = kMaxVFLength]) =>
      _isValidUVFL(vfLength, max, kSizeInBytes, vfLengthField);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [OW].
  /// If [doTestValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [OW] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [_isValidSpecialTag] is used.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, int vfLengthField,
          [Issues issues]) =>
      _isValidSpecialTag(tag, issues, kOWIndex, OW) &&
      _isValidUVFL(vfBytes.length, kMaxVFLength, kSizeInBytes, vfLengthField);

  /// Returns _true_ if [vList].length is valid for [OW].
  static bool isValidVListLength(Tag tag, Iterable<int> vList,
      [Issues issues]) {
    if (!_isValidSpecialTag(tag, issues, kOWIndex, OW))
      return isValidTagError(tag, issues, OW);
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

//  static const VR kVR = VR.kAT;
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
      _isValidTag(tag, issues, kATIndex, AT) &&
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if [tag] is valid for [AT].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      _isValidTag(tag, issues, kATIndex, AT);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [AT].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      _isValidVRIndex(vrIndex, issues, kATIndex);

  /// Returns _true_ if [vrCode] is valid for this VR (i.e. [Element] [Type]).
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      _isValidVRCode(vrCode, issues, kATCode);

  /// Returns [vrIndex] if it is valid for this VR (i.e. [Element]
  /// [Type]). If [doTestValidity] is _false_ then no checking is done.
  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      _checkVRIndex(vrIndex, issues, kATIndex);

  /// Returns _true_ if [vfLength] is valid for this [AT].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, [int max = kMaxVFLength]) =>
      _isValidVFL(vfLength, max, kSizeInBytes);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [AT].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      _isValidTag(tag, issues, kATIndex, AT) &&
      _isValidVFL(vfBytes.length, kMaxVFLength, kSizeInBytes);

  /// Returns _true_ if [vList].length is valid for [AT].
  static bool isValidVListLength(Tag tag, Iterable<int> vList,
      [Issues issues]) {
    if (!_isValidTag(tag, issues, kATIndex, AT))
      return isValidTagError(tag, issues, AT);
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

//  static const VR kVR = VR.kOL;
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
      _isValidTag(tag, issues, kOLIndex, OL) &&
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if [tag] is valid for [OL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      _isValidTag(tag, issues, kOLIndex, OL);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [OL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      _isValidVRIndex(vrIndex, issues, kOLIndex);

  /// Returns _true_ if [vrCode] is valid for this VR (i.e. [Element] [Type]).
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      _isValidVRCode(vrCode, issues, kOLCode);

  /// Returns [vrIndex] if it is valid for this VR (i.e. [Element]
  /// [Type]). If [doTestValidity] is _false_ then no checking is done.
  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      _checkVRIndex(vrIndex, issues, kOLIndex);

  /// Returns _true_ if [vfLength] is valid for this [OL].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, [int max = kMaxVFLength]) =>
      _isValidVFL(vfLength, max, kSizeInBytes);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [OL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      _isValidTag(tag, issues, kOLIndex, OL) &&
      _isValidVFL(vfBytes.length, kMaxVFLength, kSizeInBytes);

  /// Returns _true_ if [vList].length is valid for [OL].
  static bool isValidVListLength(Tag tag, Iterable<int> vList,
      [Issues issues]) {
    if (!_isValidTag(tag, issues, kOLIndex, OL))
      return isValidTagError(tag, issues, OL);
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

//  static const VR kVR = VR.kUL;
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
      _isValidTag(tag, issues, kULIndex, UL) &&
      _isValidValues(tag, vList, issues, kMinValue, kMaxValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<int> vList, [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if [tag] is valid for [UL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      _isValidTag(tag, issues, kULIndex, UL);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [UL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      _isValidVRIndex(vrIndex, issues, kULIndex);

  /// Returns _true_ if [vrCode] is valid for this VR (i.e. [Element] [Type]).
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      _isValidVRCode(vrCode, issues, kULCode);

  /// Returns [vrIndex] if it is valid for this VR (i.e. [Element]
  /// [Type]). If [doTestValidity] is _false_ then no checking is done.
  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      _checkVRIndex(vrIndex, issues, kULIndex);

  /// Returns _true_ if [vfLength] is valid for this [UL].
  // Note: This only check [vfLength] against the [kMaxVFLength] and
  //       [kSizeInBytes]. It does no Tag specific checks.
  static bool isValidVFLength(int vfLength, [int max = kMaxVFLength]) =>
      _isValidVFL(vfLength, max, kSizeInBytes);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [UL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      _isValidTag(tag, issues, kULIndex, UL) &&
      _isValidVFL(vfBytes.length, kMaxVFLength, kSizeInBytes);

  /// Returns _true_ if [vList].length is valid for [UL].
  static bool isValidVListLength(Tag tag, Iterable<int> vList,
      [Issues issues]) {
    if (!_isValidTag(tag, issues, kULIndex, UL))
      return isValidTagError(tag, issues, UL);
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
      _isValidTag(tag, issues, kULIndex, UL) &&
      _isValidValues(
          tag, vList, issues, UL.kMinValue, UL.kMaxValue, UL.kMaxLength);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [UL].
  /// If [doTestValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      _isValidTag(tag, issues, kULIndex, UL) &&
      _isValidVFL(vfBytes.length, UL.kMaxVFLength, UL.kSizeInBytes);

  static bool isValidValues(Tag tag, List<int> vList, [Issues issues]) =>
      tag.vrIndex == kULIndex && vList.length == 1 && UL.isValidValue(vList[0]);
}

bool _inRange(int v, int min, int max) => v >= min && v <= max;

/// Checks that vfLength (vfl) is in range and the right size, based on the
/// element size (eSize).
bool _isValidVFL(int vfl, int max, int eSize) => (__isValidVFL(vfl, max, eSize))
    ? true
    : isValidVFLengthError(vfl, max, eSize);

/// Checks the the vfLengthField equal either the vfLength or
/// [kUndefinedLength]; and then checks that vfLength (vfl) is
/// in range and the right size, based on the element size (eSize).
bool _isValidUVFL(int vfl, int max, int eSize, int vlf) {
  assert(vlf != null);
  return ((vlf == vfl || vlf == kUndefinedLength) &&
          __isValidVFL(vfl, max, eSize))
      ? true
      : isValidVFLengthError(vfl, max, eSize, vlf);
}

/// Returns true if [vfLength] is in the range 0 <= [vfLength] <= [max],
/// and [vfLength] is a multiple of of value size in bytes ([eSize]),
/// i.e. `vfLength % eSize == 0`.
bool __isValidVFL(int vfLength, int max, int eSize) =>
    (_inRange(vfLength, 0, max) && (vfLength % eSize == 0)) ? true : false;

/// Returns true if [v] is in the range [min] <= [v] <= [max].
bool _isValidValue(int v, Issues issues, int min, int max) {
  if (v < min || v > max) {
    if (issues != null) {
      if (v < min) issues.add('Invalid Value($v) under minimum($min)');
      if (v < min) issues.add('Invalid Value($v) over maximum($max)');
    }
    return false;
  }
  return true;
}

/// Returns true if [vList] has a valid length for [tag], and each value in
/// [vList] is valid for [tag]..
bool _isValidValues(Tag tag, Iterable<int> vList, Issues issues, int minVLength,
    int maxVLength, int maxVFListLength) {
  if (vList != null && !doTestValidity) return true;
  var result = true;
  if (vList == null ||
      !Element.isValidVListLength(tag, vList, issues, maxVFListLength)) {
    result = false;
  } else {
    for (var v in vList)
      result = _isValidValue(v, issues, minVLength, maxVLength);
  }
  if (result == false) invalidValuesError(vList, issues: issues);
  return result;
}

/// Returns _true_ if [tag].vrIndex is equal to [targetVR], which MUST
/// be a valid _VR Index_. Typically, one of the constants (k_XX_Index)
/// is used.
bool _isValidTag(Tag tag, Issues issues, int targetVR, Type type) =>
    (doTestValidity && tag.vrIndex != targetVR)
        ? isValidTagError(tag, issues, type)
        : true;

/// Returns _true_ if [tag].vrIndex is equal to [targetVR], which MUST
/// be a valid _VR Index_. Typically, one of the constants (k_XX_Index)
/// is used.
bool _isValidSpecialTag(Tag tag, Issues issues, int targetVR, Type type) {
  final vrIndex = tag.vrIndex;
  return (doTestValidity &&
          (vrIndex == targetVR ||
              (vrIndex >= kVRSpecialIndexMin && vrIndex <= kVRSpecialIndexMax)))
      ? true
      : isValidTagError(tag, issues, type);
}

/// Returns _true_ if [vrIndex] is equal to [target], which MUST be a valid
/// _VR Index_. Typically, one of the constants (k_XX_Index) is used.
bool _isValidVRIndex(int vrIndex, Issues issues, int target) =>
    (vrIndex == target) ? true : isValidVRIndexError(vrIndex, issues, target);

/// Returns _true_ if [vrIndex] is equal to [target], which MUST be a
/// valid _VR Index_. Typically, one of the constants (k_XX_Index) is used,
/// or a valid _Special VR Index_. This function is only used by [OB],
/// [OW], [SS], and [US].
bool _isValidSpecialVRIndex(int vrIndex, Issues issues, int target) {
  if (vrIndex == target ||
      (vrIndex >= kVRSpecialIndexMin && vrIndex <= kVRSpecialIndexMax))
    return true;
  return isValidVRIndexError(vrIndex, issues, target);
}

/// Returns [vrIndex] if it is equal to [target], which MUST be a valid
/// _VR Index_. Typically, one of the constants (k_XX_Index) is used.
int _checkVRIndex(int vrIndex, Issues issues, int target) =>
    (vrIndex == target) ? vrIndex : badVRIndex(vrIndex, issues, target);

/// Returns [vrIndex] if it is equal to [target], which MUST be a valid
/// _VR Index_. Typically, one of the constants (k_XX_Index) is used.
int _checkSpecialVRIndex(int vrIndex, Issues issues, int target) =>
    (vrIndex == target ||
            (vrIndex >= kVRSpecialIndexMin && vrIndex <= kVRSpecialIndexMax))
        ? vrIndex
        : badVRIndex(vrIndex, issues, target);

/// [target] is a valid _VR Code_. One of the constants (k_XX_Index)
/// is be used.
bool _isValidVRCode(int vrCode, Issues issues, int target) =>
    (vrCode == target) ? true : isValidVRCodeError(vrCode, issues, target);

/// [target] is a valid _VR Code_. One of the constants (k_XX_Index)
/// is be used.
bool _isValidSpecialVRCode(int vrCode, Issues issues, int target) {
  if (vrCode == target ||
      (vrCode >= kVRSpecialIndexMin && vrCode <= kVRSpecialIndexMax))
    return true;
  return isValidVRCodeError(vrCode, issues, target);
}
