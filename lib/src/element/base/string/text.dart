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
import 'package:core/src/element/base/string/string.dart';
import 'package:core/src/element/base/string/string_bulkdata.dart';
import 'package:core/src/element/base/string/utf8.dart';
import 'package:core/src/element/base/float/float_mixin.dart';
import 'package:core/src/element/base/utils.dart';
import 'package:core/src/error.dart';
import 'package:core/src/global.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/vr.dart';

// TODO: For each class add the following static fields:
//       bool areLeadingSpacesAllowed = x;
//       bool areLeadingSpacesSignificant = x;
//       bool areTrailingSpacesAllowed = x;
//       bool areTrailingSpacesSignificant = x;
//       bool areEmbeddedSpacesAllowed = x;
//       bool areAllSpacesAllowed = x;
//       bool isEmptyStringAllowed = x;

abstract class Text extends Utf8 {
  static const bool kIsAsciiRequired = false;

  @override
  bool get isAsciiRequired => false;
  @override
  bool get isSingleValued => true;

  @override
  bool checkLength([Iterable<String> vList, Issues issues]) =>
      vList.isEmpty || vList.length == 1;

  @override
  StringBase blank([int n = 1]) => update([spaces(n)]);

  @override
  List<String> valuesFromBytes(Bytes vfBytes) => [vfBytes.getUtf8()];

  static List<String> fromValueField(Iterable vf, int maxVFLength,
      {bool isAscii: true}) {
    if (vf == null) return kEmptyStringList;
    if (vf.isEmpty ||
        ((vf is List<String>) && vf.length == 1) ||
        vf is StringBulkdata) return vf;
    if (vf is Bytes) return [vf.getUtf8()];
    if (vf is Uint8List)
      return stringListFromTypedData(vf, maxVFLength, isAscii: true);
    return badValues(vf);
  }
}

/// An Long Text (LT) Element
abstract class LT extends Text {
  static const int kVRIndex = kLTIndex;
  static const int kVRCode = kLTCode;
  static const int kMaxVFLength = k8BitMaxLongVF;
  static const int kMaxLength = 1;
  static const int kMinValueLength = 0;
  static const int kMaxValueLength = 10240;

  static const String kVRKeyword = 'LT';
  static const String kVRName = 'Long Text';

  static const Type kType = LT;

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
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  // **** Generalized static methods

  /// Returns _true_ if both [tag] and [vList] are valid for [LT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, LT);
    return vList != null &&
        doTestElementValidity &&
        isValidTag(tag) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [LT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, LT);
    return vfBytes != null &&
        doTestElementValidity &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [LT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTag_(tag, issues, kVRIndex, LT);

  /// Returns _true_ if [vrIndex] is valid for [LT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [LT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kVRCode);

  /// Returns _true_ if [vfLength] is valid for [LT].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : inRange(vfLength, 0, kMaxVFLength);

  /// Returns _true_ if [vList].length is valid for [LT].
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, LT);
    if (vList == null) return nullValueError();
    return Element.isValidLength(tag, vList, issues, kMaxLength, LT);
  }

  /// Returns _true_ if [tag] has a VR of [LT] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, isValidValue, kMaxLength, LT);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    return (isDcmText(s, kMaxValueLength))
        ? true
        : invalidString('Invalid Long Text (LT): "$s"', issues);
  }
}

/// An Short Text (ST) Element
abstract class ST extends Text {
  static const int kVRIndex = kSTIndex;
  static const int kVRCode = kSTCode;
  static const int kMaxVFLength = k8BitMaxLongVF;
  static const int kMaxLength = 1;
  static const int kMinValueLength = 0;
  static const int kMaxValueLength = 1024;

  static const String kVRKeyword = 'ST';
  static const String kVRName = 'Short Text';

  static const Type kType = ST;
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
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  // **** Generalized static methods

  /// Returns _true_ if both [tag] and [vList] are valid for [ST].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, ST);
    return vList != null &&
        doTestElementValidity &&
        isValidTag(tag) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [ST].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, ST);
    return vfBytes != null &&
        doTestElementValidity &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [ST].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTag_(tag, issues, kVRIndex, ST);

  /// Returns _true_ if [vrIndex] is valid for [ST].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [ST].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kVRCode);

  /// Returns _true_ if [vfLength] is valid for [ST].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : inRange(vfLength, 0, kMaxVFLength);

  /// Returns _true_ if [vList].length is valid for [ST].
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, ST);
    if (vList == null) return nullValueError();
    return Element.isValidLength(tag, vList, issues, kMaxLength, ST);
  }

  /// Returns _true_ if [tag] has a VR of [ST] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, isValidValue, kMaxLength, ST);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    return (isDcmText(s, kMaxValueLength))
        ? true
        : invalidString('Invalid Short Test (ST): "$s"', issues);
  }
}

/// Value Representation of [Uri].
///
/// The Value Multiplicity of this [Element] is 1.
abstract class UR extends Text {
  static const int kVRIndex = kURIndex;
  static const int kVRCode = kURCode;
  static const String kVRKeyword = 'UR';
  static const String kVRName =
      'Universal Resource Identifier or Universal Resource Locator (URI/URL)';
  static const int kMaxVFLength = k8BitMaxLongVF;
  static const int kMaxLength = 1;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = k8BitMaxLongVF;

  static const Type kType = UR;

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

  Uri get uri => _uri ??= (values.length != 1) ? null : Uri.parse(values.first);
  Uri _uri;

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  // **** Generalized static methods

  /// Returns _true_ if both [tag] and [vList] are valid for [UR].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UR);
    return vList != null &&
        doTestElementValidity &&
        isValidTag(tag) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [UR].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UR);
    return vfBytes != null &&
        doTestElementValidity &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [UR].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTag_(tag, issues, kVRIndex, UR);

  /// Returns _true_ if [vrIndex] is valid for [UR].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [UR].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kVRCode);

  /// Returns _true_ if [vfLength] is valid for [UR].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : inRange(vfLength, 0, kMaxVFLength);

  /// Returns _true_ if [vList].length is valid for [UR].
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UR);
    if (vList == null) return nullValueError();
    return Element.isValidLength(tag, vList, issues, kMaxLength, UR);
  }

  /// Returns _true_ if [tag] has a VR of [UR] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, isValidValue, kMaxLength, UR);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false, bool trimSpaces = false}) {
    trimSpaces ?? trimURISpaces;
    if (s == null || !isValidValueLength(s, issues)) return false;
    if (trimSpaces) s.trim();
    try {
      if (s.startsWith(' ')) throw const FormatException();
      Uri.parse(s);
    } on FormatException {
      return invalidString('Invalid URI String (UR): "$s"', issues);
    }
    return true;
  }

  /// _Deprecated_: Use [Uri.tryParse] instead.
  @deprecated
  static Uri parse(String s,
      {int start = 0, int end, Issues issues, Uri onError(String s)}) {
    final uri = tryParse(s, start: start, end: end, issues: issues);
    if (uri == null) {
      if (onError != null) return onError(s);
      throw new FormatException('Invalid Uri: "$s"');
    }
    return uri;
  }

  /// _Deprecated_: Use [Uri.tryParse] instead.
  @deprecated
  static Uri tryParse(String s, {int start = 0, int end, Issues issues}) =>
      Uri.tryParse(s, start, end);
}

/// An Unlimited Text (UT) Element
abstract class UT extends Text {
  static const int kVRIndex = kUTIndex;
  static const int kVRCode = kUTCode;
  static const int kMaxVFLength = k8BitMaxLongVF;
  static const int kMaxLength = 1;
  static const int kMinValueLength = 0;
  static const int kMaxValueLength = k8BitMaxLongVF;

  static const String kVRKeyword = 'UT';
  static const String kVRName = 'Unlimited Text';

  static const Type kType = UT;

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
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  // **** Generalized static methods

  /// Returns _true_ if both [tag] and [vList] are valid for [UT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UT);
    return vList != null &&
        doTestElementValidity &&
        isValidTag(tag) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [UT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UT);
    return vfBytes != null &&
        doTestElementValidity &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [UT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTag_(tag, issues, kVRIndex, UT);

  /// Returns _true_ if [vrIndex] is valid for [UT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [UT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kVRCode);

  /// Returns _true_ if [vfLength] is valid for [UT].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : inRange(vfLength, 0, kMaxVFLength);

  /// Returns _true_ if [vList].length is valid for [UT].
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UT);
    if (vList == null) return nullValueError();
    return Element.isValidLength(tag, vList, issues, kMaxLength, UT);
  }

  /// Returns _true_ if [tag] has a VR of [UT] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, isValidValue, kMaxLength, UT);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    return (isDcmText(s, kMaxLongVF))
        ? true
        : invalidString('Invalid Unlimited Text (UT): "$s"', issues);
  }
}

bool _isValidValues(
        Tag tag,
        Iterable<String> vList,
        Issues issues,
        bool isValidValue(String s, {Issues issues, bool allowInvalid}),
        int maxLength,
        Type type) =>
    StringBase.isValidValues(tag, vList, issues, isValidValue, maxLength, type);
