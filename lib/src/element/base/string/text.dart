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
import 'package:core/src/element/base/string/ascii.dart';
import 'package:core/src/element/base/string/string.dart';
import 'package:core/src/element/base/string/string_bulkdata.dart';
import 'package:core/src/element/base/string/utf8.dart';
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
  @override
  bool get isSingleValued => true;

  @override
  bool checkLength([Iterable<String> vList, Issues issues]) =>
      vList.isEmpty || vList.length == 1;

  @override
  StringBase blank([int n = 1]) => update([spaces(n)]);

  @override
  List<String> valuesFromBytes(Bytes vfBytes) =>
      [vfBytes.getUtf8()];

  static List<String> fromValueField(Iterable vf, int maxVFLength,
                                     {bool isAscii: true}) {
    if (vf == null) return kEmptyStringList;
    if ( vf.isEmpty || ((vf is List<String>) && vf.length == 1) || vf is
    StringBulkdata)
    return vf;
    if (vf is Bytes) return [vf.getUtf8()];
    if (vf is Uint8List)
      return stringListFromTypedData(vf, maxVFLength, isAscii: true);
    return badValues(vf);
  }
}

/// An Long Text (LT) Element
abstract class LT extends Text {
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

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static const bool kIsAsciiRequired = false;
  static const int kVRIndex = kLTIndex;
  static const int kVRCode = kLTCode;
  static const String kVRKeyword = 'LT';
  static const String kVRName = 'Long Text';
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = 1;
  static const int kMinValueLength = 0;
  static const int kMaxValueLength = 10240;

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (isNotDcmText(s, kMaxValueLength)) {
      if (issues != null) issues.add('Invalid Long Text (LT): "$s"');
      return false;
    }
    return true;
  }

  // **** Generalized static methods

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  static bool isNotValidValue(String s,
          {Issues issues, bool allowInvalid = false}) =>
      !isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  /// Returns _true_ if both [tag] and [vList] are valid for [LT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, LT) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [LT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, LT) &&
      inRange(vfBytes.length, 0, kMaxVFLength);

  static bool isNotValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      !isValidBytesArgs(tag, vfBytes, issues);

  /// Returns _true_ if [tag] is valid for [LT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, LT);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [LT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [LT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kLTCode);

  /// Returns _true_ if [vfLength] is valid for [LT].
  static bool isValidVFLength(int vfLength,
          [int max = kMaxVFLength, Issues issues]) =>
      inRange(vfLength, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, kMaxVFLength, issues);

  /// Returns _true_ if [vList].length is valid for [LT].
  static bool isValidVListLength(Tag tag, Iterable<String> vList,
      [Issues issues]) {
    if (!Tag.isValidTag(tag, issues, kVRIndex, LT))
      return invalidTag(tag, issues, LT);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [tag] has a VR of [LT] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidValues(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidValues(tag, vList, issues);
/*
  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Uint8List toUint8List(Iterable<String> values) =>
      _textListToUint8List(values, kMaxVFLength);

  static Bytes toBytes(List<String> sList, int maxVFLength) {
    assert(sList.length <= 1);
    return Bytes.fromStrings(sList, maxLength: maxVFLength);
  }

  static Iterable<String> fromUint8List(Uint8List bytes,
          {int offset = 0, int length}) =>
      _textListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static ByteData toByteData(Iterable<String> values) =>
      _textListToByteData(values, kMaxVFLength);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      _textListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
  */
}

/// An Short Text (ST) Element
abstract class ST extends Text {
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

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static const bool kIsAsciiRequired = false;
  static const int kVRIndex = kSTIndex;
  static const int kVRCode = kSTCode;
  static const String kVRKeyword = 'ST';
  static const String kVRName = 'Short Text';
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = 1;
  static const int kMinValueLength = 0;
  static const int kMaxValueLength = 1024;

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (isNotDcmText(s, kMaxValueLength)) {
      if (issues != null) issues.add('Invalid Short Test (ST): "$s"');
      return false;
    }
    return true;
  }

  // **** Generalized static methods

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  static bool isNotValidValue(String s,
          {Issues issues, bool allowInvalid = false}) =>
      !isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  /// Returns _true_ if both [tag] and [vList] are valid for [ST].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, ST) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [ST].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, ST) &&
      inRange(vfBytes.length, 0, kMaxVFLength);

  static bool isNotValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      !isValidBytesArgs(tag, vfBytes, issues);

  /// Returns _true_ if [tag] is valid for [ST].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, ST);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [ST].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [ST].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kSTCode);

  /// Returns _true_ if [vfLength] is valid for [ST].
  static bool isValidVFLength(int vfLength,
          [int max = kMaxVFLength, Issues issues]) =>
      inRange(vfLength, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, kMaxVFLength, issues);

  /// Returns _true_ if [vList].length is valid for [ST].
  static bool isValidVListLength(Tag tag, Iterable<String> vList,
      [Issues issues]) {
    if (!Tag.isValidTag(tag, issues, kVRIndex, ST))
      return invalidTag(tag, issues, ST);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [tag] has a VR of [ST] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidValues(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidValues(tag, vList, issues);

/*
  static Uint8List toUint8List(Iterable<String> values) =>
      _textListToUint8List(values, kMaxVFLength);

  static Bytes toBytes(List<String> sList, int maxVFLength) {
    assert(sList.length <= 1);
    return stringListToBytes(sList, maxVFLength);
  }

  static Iterable<String> fromUint8List(Uint8List bytes,
          {int offset = 0, int length}) =>
      _textListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static ByteData toByteData(Iterable<String> values) =>
      _textListToByteData(values, kMaxVFLength);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      _textListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
*/

}

// TODO: move to system
bool trimURISpaces = false;

/// Value Representation of [Uri].
///
/// The Value Multiplicity of this [Element] is 1.
abstract class UR extends Text {
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

  static const bool kIsAsciiRequired = false;
  static const int kVRIndex = kURIndex;
  static const int kVRCode = kURCode;
  static const String kVRKeyword = 'UR';
  static const String kVRName =
      'Universal Resource Identifier or Universal Resource Locator (URI/URL)';
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = 1;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = kMaxLongVF;

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false, bool trimSpaces = false}) {
    trimSpaces ?? trimURISpaces;
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (trimSpaces) s.trim();
    try {
      if (s.startsWith(' ')) throw const FormatException();
      Uri.parse(s);
    } on FormatException {
      if (issues != null) issues.add('Invalid URI String (UR): "$s"');
      return false;
    }
    return true;
  }

  // **** Generalized static methods

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  static bool isNotValidValue(String s,
          {Issues issues, bool allowInvalid = false}) =>
      !isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  /// Returns _true_ if both [tag] and [vList] are valid for [UR].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, UR) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [UR].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, UR) &&
      inRange(vfBytes.length, 0, kMaxVFLength);

  static bool isNotValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      !isValidBytesArgs(tag, vfBytes, issues);

  /// Returns _true_ if [tag] is valid for [UR].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, UR);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [UR].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [UR].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kURCode);

  /// Returns _true_ if [vfLength] is valid for [UR].
  static bool isValidVFLength(int vfLength,
          [int max = kMaxVFLength, Issues issues]) =>
      inRange(vfLength, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, kMaxVFLength, issues);

  /// Returns _true_ if [vList].length is valid for [UR].
  static bool isValidVListLength(Tag tag, Iterable<String> vList,
      [Issues issues]) {
    if (!Tag.isValidTag(tag, issues, kVRIndex, UR))
      return invalidTag(tag, issues, UR);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [tag] has a VR of [UR] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidValues(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidValues(tag, vList, issues);

  /*
  static Iterable<String> checkList(Tag tag, Iterable<String> vList,

          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Uint8List toUint8List(Iterable<String> values) =>
      _textListToUint8List(values, kMaxVFLength);

  static Bytes toBytes(List<String> sList, int maxVFLength) {
    assert(sList.length <= 1);
    return stringListToBytes(sList, maxVFLength);
  }

  static Iterable<String> fromUint8List(Uint8List bytes,
          {int offset = 0, int length}) =>
      _textListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static ByteData toByteData(Iterable<String> values) =>
      _textListToByteData(values, kMaxVFLength);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      _textListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
*/

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

  static const bool kIsAsciiRequired = false;
  static const int kVRIndex = kUTIndex;
  static const int kVRCode = kUTCode;
  static const String kVRKeyword = 'UT';
  static const String kVRName = 'Unlimited Text';
  static const int kMaxVFLength = kMaxLongVF;
  static const int kMaxLength = 1;
  static const int kMinValueLength = 0;
  static const int kMaxValueLength = kMaxLongVF;

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (isNotDcmText(s, kMaxLongVF)) {
      if (issues != null) issues.add('Invalid Unlimited Text (UT): "$s"');
      return false;
    }
    return true;
  }

  // **** Generalized static methods

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  static bool isNotValidValue(String s,
          {Issues issues, bool allowInvalid = false}) =>
      !isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  /// Returns _true_ if both [tag] and [vList] are valid for [UT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, UT) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [UT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, UT) &&
      inRange(vfBytes.length, 0, kMaxVFLength);

  static bool isNotValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      !isValidBytesArgs(tag, vfBytes, issues);

  /// Returns _true_ if [tag] is valid for [UT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, UT);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [UT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [UT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kUTCode);

  /// Returns _true_ if [vfLength] is valid for [UT].
  static bool isValidVFLength(int vfLength,
          [int max = kMaxVFLength, Issues issues]) =>
      inRange(vfLength, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, kMaxVFLength, issues);

  /// Returns _true_ if [vList].length is valid for [UT].
  static bool isValidVListLength(Tag tag, Iterable<String> vList,
      [Issues issues]) {
    if (!Tag.isValidTag(tag, issues, kVRIndex, UT))
      return invalidTag(tag, issues, UT);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [tag] has a VR of [UT] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidValues(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidValues(tag, vList, issues);

/*
  static Uint8List toUint8List(Iterable<String> values) =>
      _textListToUint8List(values, kMaxVFLength);

  static Bytes toBytes(List<String> sList, int maxVFLength) {
    assert(sList.length <= 1);
    return stringListToBytes(sList, maxVFLength);
  }

  static Iterable<String> fromUint8List(Uint8List bytes,
          {int offset = 0, int length}) =>
      _textListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static ByteData toByteData(Iterable<String> values) =>
      _textListToByteData(values, kMaxVFLength);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      _textListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
*/

}

