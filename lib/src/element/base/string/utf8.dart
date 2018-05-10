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
import 'package:core/src/entity.dart';
import 'package:core/src/error.dart';
import 'package:core/src/system.dart';
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

abstract class Utf8 extends StringBase {
  @override
  bool get isAsciiRequired => false;
  @override
  bool get isSingleValued => false;

  Bytes get asBytes =>
      Bytes.fromUtf8List(values, maxVFLength);

  @override
  TypedData get typedData =>
      stringListToUint8List(values, maxLength: maxVFLength, isAscii: false);

  List<String> valuesFromBytes(Bytes bytes) =>
      bytes.getUtf8List(allowMalformed: global.allowMalformedUtf8);

  Uint8List uint8ListFromValues(List<String> vList) =>
      stringListToUint8List(values, maxLength: maxVFLength, isAscii: false);

  static List<String> fromValueField(Iterable vf, int maxVFLength,
      {bool isAscii: true}) {
    if (vf == null) return kEmptyStringList;
    if (vf is List<String> || vf.isEmpty || vf is StringBulkdata) return vf;
    if (vf is Bytes) return vf.getUtf8List();
    if (vf is Uint8List)
      return stringListFromTypedData(vf, maxVFLength, isAscii: true);
    return badValues(vf);
  }
}

/// A Long String (LO) Element
abstract class LO extends Utf8 {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  bool get isAsciiRequired => false;
  @override
  int get maxLength => kMaxLength;
  @override
  int get maxVFLength => kMaxVFLength;

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static const bool kIsAsciiRequired = false;
  static const int kVRIndex = kLOIndex;
  static const int kVRCode = kLOCode;
  static const String kVRKeyword = 'LO';
  static const String kVRName = 'Long String';
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxShortVF ~/ 2;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 64;

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (isNotDcmString(s, 64)) {
      if (issues != null) issues.add('Invalid Long String (LO): "$s"');
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

  /// Returns _true_ if both [tag] and [vList] are valid for [LO].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, LO) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [LO].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, LO) &&
      inRange(vfBytes.length, 0, kMaxVFLength);

  static bool isNotValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      !isValidBytesArgs(tag, vfBytes, issues);

  /// Returns _true_ if [tag] is valid for [LO].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, LO);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [LO].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns [vrIndex] if it is valid for [LO].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      VR.checkIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [LO].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kLOCode);

  /// Returns [vrCode] if it is valid for [LO].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : VR.badCode(vrCode, issues, kVRIndex);

  /// Returns _true_ if [vfLength] is valid for [LO].
  static bool isValidVFLength(int vfLength,
          [int max = kMaxVFLength, Issues issues]) =>
      inRange(vfLength, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, kMaxVFLength, issues);

  /// Returns _true_ if [vList].length is valid for [LO].
  static bool isValidVListLength(Tag tag, Iterable<String> vList,
      [Issues issues]) {
    if (!isValidTag(tag, issues)) return invalidTag(tag, issues, LO);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [tag] has a VR of [LO] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidValues(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidValues(tag, vList, issues);

/*  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromUint8List(Uint8List bytes,
          {int offset = 0, int length}) =>
      stringListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toUint8List(Iterable<String> values) =>
      stringListToUint8List(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Bytes toBytes(List<String> sList, int maxVFLength) =>
      stringListToBytes(sList, maxVFLength);

  static ByteData toByteData(Iterable<String> values) =>
      stringListToByteData(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      stringListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
  */
}

/// A Private Creator [Element] is a subtype of [LO]. It always has a tag
/// of the form (gggg,00cc), where 0x10 <= cc <= 0xFF..
abstract class PC extends LO {
  String get token;

  /// The Value Field which contains a [String] that identifies the
  /// PrivateSubgroup.
  String get id => vfBytesAsUtf8;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRKeyword;

  @override
  String get name => 'Private Creator - $id';

  int get sgNumber => code & 0xFF;

  /// Returns a [PCTag].
  @override
  Tag get tag {
    if (Tag.isPCCode(code)) {
      final tag = Tag.lookupByCode(code, kLOIndex, token);
      return tag;
    }
    return invalidKey(code, 'Invalid Tag Code ${toDcm(code)}');
  }

  static const String kVRKeyword = 'PC';
  static const String kVRName = 'Private Creator';

// **** Specialized static methods
// **** Generalized static methods
}

/// A Person Name ([PN]) [Element].
abstract class PN extends Utf8 {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  bool get isAsciiRequired => false;
  @override
  int get maxLength => kMaxLength;
  @override
  int get maxVFLength => kMaxVFLength;

  Iterable<PersonName> get names => _names ??= values.map(PersonName.parse);
  Iterable<PersonName> _names;

  @override
  PN get hash => throw new UnimplementedError();

  String get initials {
    if (values.isNotEmpty)
      throw new UnimplementedError('Unimplemented for multiple PersonNames');
    return _names.elementAt(0).initials;
  }

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static const bool kIsAsciiRequired = false;
  static const int kVRIndex = kPNIndex;
  static const int kVRCode = kPNCode;
  static const String kVRKeyword = 'PN';
  static const String kVRName = 'Person Name';
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxShortVF ~/ 2;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 3 * 64;

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (isNotDcmString(s, 5 * 64)) {
      if (issues != null) issues.add('Invalid Person Name String (PN): "$s"');
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

  /// Returns _true_ if both [tag] and [vList] are valid for [PN].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, PN) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [PN].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, PN) &&
      inRange(vfBytes.length, 0, kMaxVFLength);

  static bool isNotValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      !isValidBytesArgs(tag, vfBytes, issues);

  /// Returns _true_ if [tag] is valid for [PN].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, PN);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [PN].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns [vrIndex] if it is valid for [PN].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      VR.checkIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [PN].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kPNCode);

  /// Returns [vrCode] if it is valid for [PN].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : VR.badCode(vrCode, issues, kVRIndex);

  /// Returns _true_ if [vfLength] is valid for [PN].
  static bool isValidVFLength(int vfLength,
          [int max = kMaxVFLength, Issues issues]) =>
      inRange(vfLength, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, kMaxVFLength, issues);

  /// Returns _true_ if [vList].length is valid for [PN].
  static bool isValidVListLength(Tag tag, Iterable<String> vList,
      [Issues issues]) {
    if (!isValidTag(tag, issues)) return invalidTag(tag, issues, PN);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [tag] has a VR of [PN] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidValues(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidValues(tag, vList, issues);

/*  static Iterable<String> fromUint8List(Uint8List bytes,
          {int offset = 0, int length}) =>
      stringListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toUint8List(Iterable<String> values) =>
      stringListToUint8List(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Bytes toBytes(List<String> sList, int maxVFLength) =>
      stringListToBytes(sList, maxVFLength);

  static ByteData toByteData(Iterable<String> values) =>
      stringListToByteData(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      stringListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
 */
}

/// A Short String (SH) Element
abstract class SH extends Utf8 {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  bool get isAsciiRequired => false;
  @override
  int get maxLength => kMaxLength;
  @override
  int get maxVFLength => kMaxVFLength;

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static const bool kIsAsciiRequired = false;
  static const int kVRIndex = kSHIndex;
  static const int kVRCode = kSHCode;
  static const String kVRKeyword = 'SH';
  static const String kVRName = 'Short String';
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxShortVF ~/ 2;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 16;

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (isNotDcmString(s, kMaxValueLength)) {
      if (issues != null) issues.add('Invalid Short String (SH): "$s"');
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

  /// Returns _true_ if both [tag] and [vList] are valid for [SH].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, SH) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [SH].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, SH) &&
      inRange(vfBytes.length, 0, kMaxVFLength);

  static bool isNotValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      !isValidBytesArgs(tag, vfBytes, issues);

  /// Returns _true_ if [tag] is valid for [SH].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, SH);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [SH].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns [vrIndex] if it is valid for [SH].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      VR.checkIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [SH].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kSHCode);

  /// Returns [vrCode] if it is valid for [SH].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : VR.badCode(vrCode, issues, kVRIndex);

  /// Returns _true_ if [vfLength] is valid for [SH].
  static bool isValidVFLength(int vfLength,
          [int max = kMaxVFLength, Issues issues]) =>
      inRange(vfLength, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, kMaxVFLength, issues);

  /// Returns _true_ if [vList].length is valid for [SH].
  static bool isValidVListLength(Tag tag, Iterable<String> vList,
      [Issues issues]) {
    if (!isValidTag(tag, issues)) return invalidTag(tag, issues, SH);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [tag] has a VR of [SH] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidValues(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidValues(tag, vList, issues);

/*
  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromUint8List(Uint8List bytes,
          {int offset = 0, int length}) =>
      stringListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toUint8List(Iterable<String> values) =>
      stringListToUint8List(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Bytes toBytes(List<String> sList, int maxVFLength) =>
      stringListToBytes(sList, maxVFLength);

  static ByteData toByteData(Iterable<String> values) =>
      stringListToByteData(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      stringListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
*/

}

/// An Unlimited Characters (UC) Element
abstract class UC extends Utf8 {
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
  static const int kVRIndex = kUCIndex;
  static const int kVRCode = kUCCode;
  static const String kVRKeyword = 'UC';
  static const String kVRName = 'Unlimited Characters';
  static const int kMaxVFLength = kMaxLongVF;
  static const int kMaxLength = kMaxLongVF ~/ 2;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = kMaxLongVF;

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (isNotDcmString(s, kMaxLongVF)) {
      if (issues != null)
        issues.add('Invalid Unlimited Characters String (UC): "$s"');
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

  /// Returns _true_ if both [tag] and [vList] are valid for [UC].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, UC) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [UC].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, UC) &&
      inRange(vfBytes.length, 0, kMaxVFLength);

  static bool isNotValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      !isValidBytesArgs(tag, vfBytes, issues);

  /// Returns _true_ if [tag] is valid for [UC].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, UC);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [UC].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns [vrIndex] if it is valid for [UC].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      VR.checkIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [UC].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kUCCode);

  /// Returns [vrCode] if it is valid for [UC].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : VR.badCode(vrCode, issues, kVRIndex);

  /// Returns _true_ if [vfLength] is valid for [UC].
  static bool isValidVFLength(int vfLength,
          [int max = kMaxVFLength, Issues issues]) =>
      inRange(vfLength, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, kMaxVFLength, issues);

  /// Returns _true_ if [vList].length is valid for [UC].
  static bool isValidVListLength(Tag tag, Iterable<String> vList,
      [Issues issues]) {
    if (!isValidTag(tag, issues)) return invalidTag(tag, issues, UC);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [tag] has a VR of [UC] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidValues(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidValues(tag, vList, issues);

/*
  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromUint8List(Uint8List bytes,
          {int offset = 0, int length}) =>
      stringListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toUint8List(Iterable<String> values) =>
      stringListToUint8List(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Bytes toBytes(List<String> sList, int maxVFLength) =>
      stringListToBytes(sList, maxVFLength);

  static ByteData toByteData(Iterable<String> values) =>
      stringListToByteData(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      stringListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
*/

}
