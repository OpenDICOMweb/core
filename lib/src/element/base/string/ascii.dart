//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/src/element/base/crypto.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/string/string.dart';
import 'package:core/src/element/base/string/string_bulkdata.dart';
import 'package:core/src/error.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/utils/character/dicom.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/value.dart';
import 'package:core/src/vr/vr_internal.dart';

// TODO: For each class add the following static fields:
//       bool areLeadingSpacesAllowed = x;
//       bool areLeadingSpacesSignificant = x;
//       bool areTrailingSpacesAllowed = x;
//       bool areTrailingSpacesSignificant = x;
//       bool areEmbeddedSpacesAllowed = x;
//       bool areAllSpacesAllowed = x;
//       bool isEmptyStringAllowed = x;

abstract class StringAscii extends StringBase {
  @override
  bool get isAsciiRequired => true;
  @override
  bool get isSingleValued => false;

  Bytes get asBytes => Bytes.fromAsciiList(values, maxVFLength);

  @override
  TypedData get typedData =>
      stringListToUint8List(values, maxLength: maxVFLength, isAscii: false);

  List<String> valuesFromBytes(Bytes bytes) =>
      bytes.getAsciiList(allowInvalid: global.allowInvalidAscii);

  Uint8List uint8ListFromValues(List<String> vList) =>
      stringListToUint8List(values, maxLength: maxVFLength, isAscii: false);

  static List<String> fromValueField(List vf, int maxVFLength,
      {bool isAscii: true}) {
    if (vf == null) return kEmptyStringList;
    if (vf is List<String> || vf.isEmpty || vf is StringBulkdata) return vf;
    if (vf is Bytes) return vf.getAsciiList();
    if (vf is Uint8List)
      return stringListFromTypedData(vf, maxVFLength, isAscii: true);
    return badValues(vf);
  }
}

/// A Application Entity Title ([AE]) Element
abstract class AE extends StringAscii {
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
  int get minValueLength => kMinValueLength;
  int get maxValueLength => kMaxValueLength;

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static const bool kIsAsciiRequired = true;
  static const int kVRIndex = kAEIndex;
  static const int kVRCode = kAECode;
  static const String kVRKeyword = 'AE';
  static const String kVRName = 'Application Entity';
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ 2;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 16;

  // **** Specialized static methods

  /// Returns _true_ if [s] is a valid Application Entity Title ([AE])
  /// [String].
  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (!isDcmString(s, 16, allowLeading: true)) {
      if (issues != null) issues.add('Invalid AETitle String (AE): "$s"');
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

  /// Returns _true_ if both [tag] and [vList] are valid for [AE].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, AE) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [AE].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, AE) &&
      inRange(vfBytes.length, 0, kMaxVFLength);

  static bool isNotValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      !isValidBytesArgs(tag, vfBytes, issues);

  /// Returns _true_ if [tag] is valid for [AE].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, AE);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [AE].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [AE].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kAECode);

  /// Returns _true_ if [vfLength] is valid for [AE].
  static bool isValidVFLength(int vfLength,
          [int max = kMaxVFLength, Issues issues]) =>
      inRange(vfLength, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, kMaxVFLength, issues);

  /// Returns _true_ if [vList].length is valid for [AE].
  static bool isValidVListLength(Tag tag, Iterable<String> vList,
      [Issues issues]) {
    if (!Tag.isValidTag(tag, issues, kVRIndex, AE))
      return invalidTag(tag, issues, AE);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [tag] has a VR of [AE] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidValues(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidValues(tag, vList, issues);
/*
  /// Returns [vList] if it is valid.
  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Uint8List toUint8List(Iterable<String> values,
          {int maxLength = kMaxVFLength,
          bool isAscii = kIsAsciiRequired,
          String separator = '\\'}) =>
      stringListToUint8List(values,
          maxLength: maxLength, isAscii: isAscii, separator: separator);

  static Bytes toBytes(List<String> sList,
          {int maxLength = kMaxVFLength,
          bool isAscii = kIsAsciiRequired,
          String separator = '\\'}) =>
      Bytes.fromStrings(sList,
          maxLength: maxLength, isAscii: isAscii, separator: separator);

  static Iterable<String> fromUint8List(Uint8List bytes,
          {int offset = 0, int length}) =>
      stringListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static ByteData toByteData(Iterable<String> values) =>
      stringListToByteData(values,
          maxLength: kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      stringListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
  */
}

abstract class AS extends StringAscii {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  bool get isSingleValued => true;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  int get maxLength => kMaxLength;

  @override
  bool operator ==(Object other) => (other is AS && value == other.value);

  @override
  int get hashCode {
    if (values.isEmpty) return 0;
    return (values.length == 1 && Age.isValidString(values.elementAt(0)))
        ? global.hash(age.nDays)
        : badValues(values);
  }

  @override
  TypedData get typedData =>
      stringListToUint8List(values, maxLength: kMaxVFLength);

  Age get age => _age ??= Age.parse(value);
  Age _age;

  @override
  AS get sha256 =>
      (values.isEmpty) ? this : update([sha256AgeAsString(age.nDays)]);

  AS get acrHash => update(const <String>['089Y']);

  @override
  AS get hash => (values.isEmpty) ? this : update([age.hashString]);

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static const bool kIsAsciiRequired = true;
  static bool allowLowerCase = false;
  static const int kVRIndex = kASIndex;
  static const int kVRCode = kASCode;
  static const String kVRKeyword = 'AS';
  static const String kVRName = 'Age String';
  static const int kMaxLength = kMaxShortVF ~/ (kMinValueLength + 1);
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMinValueLength = 4;
  static const int kMaxValueLength = 4;

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) {
      invalidAgeString('Invalid Age String: "$s"');
      return false;
    }
    if (Age.isValidString(s, issues)) return true;
    if (issues != null) issues.add('Invalid Age String (AS): "$s"');
    invalidAgeString('Invalid Age String (AS): "$s"');
    return false;
  }

  // **** Generalized static methods

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  static bool isNotValidValue(String s,
          {Issues issues, bool allowInvalid = false}) =>
      !isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  /// Returns _true_ if both [tag] and [vList] are valid for [AS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, AS) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [AS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, AS) &&
      inRange(vfBytes.length, 0, kMaxVFLength);

  static bool isNotValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      !isValidBytesArgs(tag, vfBytes, issues);

  /// Returns _true_ if [tag] is valid for [AS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, AS);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [AS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [AS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kASCode);

  /// Returns _true_ if [vfLength] is valid for [AS].
  static bool isValidVFLength(int vfLength,
          [int max = kMaxVFLength, Issues issues]) =>
      inRange(vfLength, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, kMaxVFLength, issues);

  /// Returns _true_ if [vList].length is valid for [AS].
  static bool isValidVListLength(Tag tag, Iterable<String> vList,
      [Issues issues]) {
    if (!Tag.isValidTag(tag, issues, kVRIndex, AS))
      return invalidTag(tag, issues, AS);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [tag] has a VR of [AS] and [vList] is valid for [tag].
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
      stringListToUint8List(values, maxLength: kMaxVFLength,
      isAscii: kIsAsciiRequired);

  static List<String> fromUint8List(Uint8List bytes) =>
      stringListFromTypedData(bytes, maxLength: kMaxVFLength,
      isAscii: kIsAsciiRequired);

  static Bytes toBytes(List<String> sList) =>
      Bytes.fromAsciiList(sList, kMaxLength: kMaxVFLength);

  static ByteData toByteData(Iterable<String> values) =>
      stringListToByteData(values, maxLength: kMaxVFLength, isAscii:
       kIsAsciiRequired);

  static List<String> fromByteData(ByteData bd) =>
      stringListFromTypedData(bd, kMaxVFLength);
*/

  static Age tryParse(String s, {bool allowLowerCase = false}) =>
      Age.tryParse(s, allowLowercase: false);

  static int tryParseString(String s, {bool allowLowerCase = false}) =>
      Age.tryParseString(s, allowLowercase: false);
}

/// A Code String ([CS]) Element
abstract class CS extends StringAscii {
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

//  CS blank([int n = 1]) => update([_blanks(n)]);

  static const bool kIsAsciiRequired = true;
  static bool allowLowerCase = false;
  static const int kVRIndex = kCSIndex;
  static const int kVRCode = kCSCode;
  static const String kVRKeyword = 'CS';
  static const String kVRName = 'Code String';
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxShortVF ~/ 2;
  // It seems that CS may have an empty String value
  static const int kMinValueLength = 0;
  static const int kMaxValueLength = 16;

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (s.isEmpty) {
      log.warn('Empty Code String');
      return true;
    }
    if (isNotFilteredString(s, 0, kMaxValueLength, isCSChar,
        allowLeading: true, allowTrailing: true)) {
      if (issues != null) issues.add('Invalid Code String (CS): "$s"');
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

  /// Returns _true_ if both [tag] and [vList] are valid for [CS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, CS) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [CS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, CS) &&
      inRange(vfBytes.length, 0, kMaxVFLength);

  static bool isNotValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      !isValidBytesArgs(tag, vfBytes, issues);

  /// Returns _true_ if [tag] is valid for [CS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, CS);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [CS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [CS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kCSCode);

  /// Returns _true_ if [vfLength] is valid for [CS].
  static bool isValidVFLength(int vfLength,
          [int max = kMaxVFLength, Issues issues]) =>
      inRange(vfLength, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, kMaxVFLength, issues);

  /// Returns _true_ if [vList].length is valid for [CS].
  static bool isValidVListLength(Tag tag, Iterable<String> vList,
      [Issues issues]) {
    if (!Tag.isValidTag(tag, issues, kVRIndex, CS))
      return invalidTag(tag, issues, CS);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [tag] has a VR of [CS] and [vList] is valid for [tag].
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

abstract class UI extends StringAscii {
  Iterable<Uid> _uids;
  @override
  int get padChar => kNull;
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  bool get isSingleValued => false;
  @override
  int get maxLength => kMaxLength;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  TypedData get typedData =>
      stringListToUint8List(values, maxLength: kMaxVFLength, isAscii: true);

  Iterable<Uid> get uids;
  set uids(Iterable<Uid> vList) => _uids = vList;

  Uid get uid => (_uids.length == 1) ? _uids.elementAt(0) : null;

  // UI does not support [hash].
  @override
  UI get hash => unsupportedError('UIDs cannot currently be hashed');

  // UI does not support [sha256].
  @override
  UI get sha256 => sha256Unsupported(this);

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  UI updateUid(Iterable<Uid> uidList) => update(toStringList(uidList));

  UI updateUidF(Iterable<Uid> f(Iterable<String> vList)) =>
      updateUid(f(values));

  Iterable<Uid> replaceUid(Iterable<Uid> vList) => _replaceUid(vList);

  Iterable<Uid> replaceUidF(Iterable<Uid> f(Iterable<Uid> vList)) =>
      _replaceUid(f(uids) ?? Uid.kEmptyList);

  Iterable<Uid> _replaceUid(Iterable<Uid> uidList) {
    final old = uids;
    _uids = null;
    values = toStringList(uidList);
    return old;
  }

  static const bool kIsAsciiRequired = true;
  static const int kVRIndex = kUIIndex;
  static const int kVRCode = kUICode;
  static const String kVRKeyword = 'UI';
  static const String kVRName = 'Unique Identifier (UID)';
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxShortVF ~/ 32;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 64;

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (!Uid.isValidString(s)) {
      if (issues != null)
        issues.add('Invalid Unique Identifier String (UI): "$s"');
      return false;
    }
    return true;
  }

  /// Returns _true_ if both [tag] is valid for [UI].
  /// [Uid]s are guaranteed to be valid.
  static bool isValidUidArgs(Tag tag, Iterable<Uid> vList, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kUIIndex, UI);

  // **** Generalized static methods

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  static bool isNotValidValue(String s,
          {Issues issues, bool allowInvalid = false}) =>
      !isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  /// Returns _true_ if both [tag] and [vList] are valid for [UI].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kUIIndex, UI) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [UI].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, UI) &&
      inRange(vfBytes.length, 0, kMaxVFLength);

  static bool isNotValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      !isValidBytesArgs(tag, vfBytes, issues);

  /// Returns _true_ if [tag] is valid for [UI].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, UI);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [UI].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [UI].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kUICode);

  /// Returns _true_ if [vfLength] is valid for [UI].
  static bool isValidVFLength(int vfLength,
          [int max = kMaxVFLength, Issues issues]) =>
      inRange(vfLength, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, kMaxVFLength, issues);

  /// Returns _true_ if [vList].length is valid for [UI].
  static bool isValidVListLength(Tag tag, Iterable<String> vList,
      [Issues issues]) {
    if (!Tag.isValidTag(tag, issues, kVRIndex, UI))
      return invalidTag(tag, issues, UI);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [tag] has a VR of [UI] and [vList] is valid for [tag].
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

  static Uint8List toUint8List(Iterable<String> values,
          {bool isAscii = false}) =>
      stringListToUint8List(values, isAscii: true);

  static Bytes toBytes(List<String> sList, int maxLength,
      {bool isAscii = false}) {
    final bList =
        stringListToUint8List(sList, maxLength: maxLength, isAscii: isAscii);
    return new Bytes.typedDataView(bList);
  }

  static ByteData toByteData(Iterable<String> values,
          {int maxLength = kMaxVFLength,
          bool isAscii = false,
          String separator = '\\'}) =>
      stringListToByteData(values,
          maxLength: maxLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      stringListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
*/
  static List<String> toStringList(Iterable<Uid> uids) {
    final sList = new List<String>(uids.length);
    for (var i = 0; i < sList.length; i++)
      sList[i] = uids.elementAt(i).toString();
    return sList;
  }

  static Uid tryParse(String s, [Issues issues]) => Uid.parse(s);

  static List<Uid> parseList(List<String> vList) {
    final uids = new List<Uid>(vList.length);
    for (var i = 0; i < vList.length; i++) {
      final uid = Uid.parse(vList[i]);
      uids[i] = uid;
      if (uid == null) return null;
    }
    return uids;
  }

  static List<Uid> tryParseList(Iterable<String> vList, [Issues issues]) =>
      StringBase.reallyTryParseList(vList, issues, tryParse);
}

// **** Date/Time Elements

/// An abstract class for date ([DA]) [Element]s.
abstract class DA extends StringBase {
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

  /// A fixed size List of [Date] values. They are created lazily.
  Iterable<Date> get dates => _dates ??= values.map(Date.parse);
  Iterable<Date> _dates;

  Date get date =>
      (dates.length == 1) ? dates.first : badValues(values, null, tag);

  @override
  DA get hash {
    final dList = <String>[];
    for (var date in dates) {
      final h = date.hash;
      dList.add(h.dcm);
    }
    return update(dList);
  }

  @override
  DA get sha256 => unsupportedError();

  DA normalize(Date enrollment) {
    final vList = Date.normalizeStrings(values, enrollment);
    return update(vList);
  }

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  void clearDates() => _dates = null;

  static const bool kIsAsciiRequired = true;
  static bool allowLowerCase = false;
  static const int kVRIndex = kDAIndex;
  static const int kVRCode = kDACode;
  static const String kVRKeyword = 'DA';
  static const String kVRName = 'Date';
  static const int kMaxLength = kMaxShortVF ~/ (kMinValueLength + 1);
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMinValueLength = 8;
  static const int kMaxValueLength = 8;

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (!Date.isValidString(s, issues: issues)) {
      if (issues != null) issues.add('Invalid Date String (DA): "$s"');
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

  /// Returns _true_ if both [tag] and [vList] are valid for [DA].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, DA) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [DA].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, DA) &&
      inRange(vfBytes.length, 0, kMaxVFLength);

  static bool isNotValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      !isValidBytesArgs(tag, vfBytes, issues);

  /// Returns _true_ if [tag] is valid for [DA].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, DA);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [DA].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [DA].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kDACode);

  /// Returns _true_ if [vfLength] is valid for [DA].
  static bool isValidVFLength(int vfLength,
          [int max = kMaxVFLength, Issues issues]) =>
      inRange(vfLength, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, kMaxVFLength, issues);

  /// Returns _true_ if [vList].length is valid for [DA].
  static bool isValidVListLength(Tag tag, Iterable<String> vList,
      [Issues issues]) {
    if (!Tag.isValidTag(tag, issues, kVRIndex, DA))
      return invalidTag(tag, issues, DA);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [tag] has a VR of [DA] and [vList] is valid for [tag].
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
      stringListToUint8List(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromUint8List(Uint8List bytes) =>
      stringListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Bytes toBytes(List<String> sList, int maxVFLength) =>
      stringListToBytes(sList, maxVFLength);

  static ByteData toByteData(Iterable<String> values) =>
      stringListToByteData(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd) =>
      stringListFromTypedData(bd, kMaxVFLength, isAscii: true);
*/

}

/// An abstract class for time ([TM]) [Element]s.
abstract class DT extends StringBase {
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

  Iterable<DcmDateTime> get dateTimes =>
      _dateTimes ??= values.map(DcmDateTime.parse);
  Iterable<DcmDateTime> _dateTimes;

  DcmDateTime get dateTime =>
      (dateTimes.length == 1) ? dateTimes.first : badValues(values, null, tag);

  @override
  DT get hash {
    final dList = new List<String>(dateTimes.length);
    for (var i = 0; i < dateTimes.length; i++)
      dList[i] = dList[i].hashCode.toString();
    return update(dList);
  }

  @override
  DT get sha256 => unsupportedError();

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  void clearDcmDateTimes() => _dateTimes = null;

  static const bool kIsAsciiRequired = true;
  static bool allowLowerCase = false;
  static const int kVRIndex = kDTIndex;
  static const int kVRCode = kDTCode;
  static const String kVRKeyword = 'DT';
  static const String kVRName = 'Date Time';
  static const int kMaxLength = kMaxShortVF ~/ (kMinValueLength + 1);
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMinValueLength = 4;
  static const int kMaxValueLength = 26;

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (!DcmDateTime.isValidString(s, issues: issues)) {
      if (issues != null) issues.add('Invalid Date Time (DT): "$s"');
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

  /// Returns _true_ if both [tag] and [vList] are valid for [DT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, DT) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [DT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, DT) &&
      inRange(vfBytes.length, 0, kMaxVFLength);

  static bool isNotValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      !isValidBytesArgs(tag, vfBytes, issues);

  /// Returns _true_ if [tag] is valid for [DT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, DT);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [DT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [DT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kDTCode);

  /// Returns _true_ if [vfLength] is valid for [DT].
  static bool isValidVFLength(int vfLength,
          [int max = kMaxVFLength, Issues issues]) =>
      inRange(vfLength, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, kMaxVFLength, issues);

  /// Returns _true_ if [vList].length is valid for [DT].
  static bool isValidVListLength(Tag tag, Iterable<String> vList,
      [Issues issues]) {
    if (!Tag.isValidTag(tag, issues, kVRIndex, DT))
      return invalidTag(tag, issues, DT);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [tag] has a VR of [DT] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidValues(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidValues(tag, vList, issues);

/*
  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromUint8List(Uint8List bytes) =>
      stringListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toUint8List(Iterable<String> values) =>
      stringListToUint8List(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Bytes toBytes(List<String> sList, int maxVFLength) =>
      stringListToBytes(sList, maxVFLength);

  static ByteData toByteData(Iterable<String> values) =>
      stringListToByteData(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd) =>
      stringListFromTypedData(bd, kMaxVFLength, isAscii: true);
*/

}

/// An abstract class for time ([TM]) [Element]s.
///
/// [Time] [String]s have the following format: HHMMSS.ffffff.
/// [See PS3.18, TM](http://dicom.nema.org/medical/dicom/current/output/
/// html/part18.html#para_3f950ae4-871c-48c5-b200-6bccf821653b)
abstract class TM extends StringBase {
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

  Iterable<Time> get times => _times ??= values.map(Time.parse);
  Iterable<Time> _times;

  Time get time =>
      (times.length == 1) ? times.first : badValues(values, null, tag);

  @override
  TM get hash {
    final dList = new List<String>(times.length);
    for (var i = 0; i < times.length; i++)
      dList[i] = dList[i].hashCode.toString();
    return update(dList);
  }

  @override
  TM get sha256 => unsupportedError();

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  void clearTimes() => _times = null;

  static const bool kIsAsciiRequired = true;
  static bool allowLowerCase = false;
  static const int kVRIndex = kTMIndex;
  static const int kVRCode = kTMCode;
  static const String kVRKeyword = 'TM';
  static const String kVRName = 'Time';
  static const int kMaxLength = kMaxShortVF ~/ (kMinValueLength + 1);
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMinValueLength = 2;
  static const int kMaxValueLength = 13;

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    // Note: isNotValidValueLength checks for null
    if (isNotValidValueLength(s, issues)) return false;
    if (!Time.isValidString(s, issues: issues)) {
      if (issues != null) issues.add('Invalid Time String (TM): "$s"');
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

  /// Returns _true_ if both [tag] and [vList] are valid for [TM].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, TM) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [TM].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, TM) &&
      inRange(vfBytes.length, 0, kMaxVFLength);

  static bool isNotValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      !isValidBytesArgs(tag, vfBytes, issues);

  /// Returns _true_ if [tag] is valid for [TM].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, TM);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [TM].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [TM].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kTMCode);

  /// Returns _true_ if [vfLength] is valid for [TM].
  static bool isValidVFLength(int vfLength,
          [int max = kMaxVFLength, Issues issues]) =>
      inRange(vfLength, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, kMaxVFLength, issues);

  /// Returns _true_ if [vList].length is valid for [TM].
  static bool isValidVListLength(Tag tag, Iterable<String> vList,
      [Issues issues]) {
    if (!Tag.isValidTag(tag, issues, kVRIndex, TM))
      return invalidTag(tag, issues, TM);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [tag] has a VR of [TM] and [vList] is valid for [tag].
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
      stringListToUint8List(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromUint8List(Uint8List bytes) =>
      stringListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Bytes toBytes(List<String> sList, [int maxVFLength = kMaxShortVF]) =>
      (joinLength(sList) > kMaxShortVF)
          ? badValuesLength(sList, kMinValueLength, kMaxValueLength)
          : Bytes.fromAsciiList(
              sList,
            );

  static ByteData toByteData(Iterable<String> values) =>
      stringListToByteData(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd) =>
      stringListFromTypedData(bd, kMaxVFLength, isAscii: true);
  */
}

abstract class DS extends StringAscii {
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

  Iterable<double> get numbers => _numbers ??= tryParseList(values);
  Iterable<double> _numbers;

  /// Returns a new [DS] [Element] with a random list of [values] with
  /// the same [length] as _this_.
  DS get random {
    if (length == 0) return this;
    final dList = new List<double>(length);
    for (var i = 0; i < length; i++) dList[i] = Global.rng.nextDouble();
    final vList = dList.map(floatToString);
    return update(vList);
  }

  /// Returns a new [DS] Element with values that are the hash of _this_.
  @override
  DS get hash =>
      update(numbers.map((n) => floatToString(global.hasher.doubleHash(n))));

  /// Returns a new [DS] Element with values that are constructed from
  /// the Sha256 hash digest of _this_.
  ///
  /// _Note_: The _digest_ is 32 bytes (128 bits) long; therefore, the length
  /// of the new [values] is at most 8. The [values] try to conform to the
  /// [vmMin] of for the Element.
  @override
  DS get sha256 {
    final hList =
        Sha256.float32(numbers).map(floatToString).toList(growable: false);
    return update((vmMax == -1 || vmMax > 8) ? hList : hList.sublist(0, vmMax));
  }

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static const bool kIsAsciiRequired = true;
  static const int kVRIndex = kDSIndex;
  static const int kVRCode = kDSCode;
  static const String kVRKeyword = 'DS';
  static const String kVRName = 'Decimal String';
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxShortVF ~/ 2;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 16;

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) {
      invalidStringLength(s);
      return false;
    }
    final n = tryParse(s);
    if (n != null) return true;
    invalidString('Invalid Decimal (DS) String: "$s"');
    return false;
  }

  // **** Generalized static methods

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  static bool isNotValidValue(String s,
          {Issues issues, bool allowInvalid = false}) =>
      !isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  /// Returns _true_ if both [tag] and [vList] are valid for [DS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, DS) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [DS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, DS) &&
      inRange(vfBytes.length, 0, kMaxVFLength);

  static bool isNotValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      !isValidBytesArgs(tag, vfBytes, issues);

  /// Returns _true_ if [tag] is valid for [DS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, DS);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [DS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [DS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kDSCode);

  /// Returns _true_ if [vfLength] is valid for [DS].
  static bool isValidVFLength(int vfLength,
          [int max = kMaxVFLength, Issues issues]) =>
      inRange(vfLength, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, kMaxVFLength, issues);

  /// Returns _true_ if [vList].length is valid for [DS].
  static bool isValidVListLength(Tag tag, Iterable<String> vList,
      [Issues issues]) {
    if (!Tag.isValidTag(tag, issues, kVRIndex, DS))
      return invalidTag(tag, issues, DS);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [tag] has a VR of [DS] and [vList] is valid for [tag].
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

  static Bytes toBytes(List<String> sList) =>
      stringListToBytes(sList, kMaxVFLength);

  static ByteData toByteData(Iterable<String> values) =>
      stringListToByteData(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      stringListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
*/

  //TODO: Sharath add tests with leading and trailing spaces,
  // and all spaces (blank).
  /// Parse a [DS] [String]. Leading and trailing spaces allowed,
  /// but all spaces is illegal.
  static double tryParse(String s, [Issues issues]) {
    final v = double.tryParse(s);
    if (v == null) {
      if (issues != null) issues.add('Invalid Digital String (DS): "$s"');
      return badString('$s', issues);
    }
    return v;
  }

  static Iterable<double> tryParseList(Iterable<String> vList,
          [Issues issues]) =>
      StringBase.reallyTryParseList(vList, issues, tryParse);
}

abstract class IS extends StringAscii {
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

  List<int> get integers => _integers ??= tryParseList(values);
  List<int> _integers;

  @override
  IS get hash {
    var ints = integers;
    ints= (ints is Iterable)  ? ints.toList(growable: false) : ints;
    final length = ints.length;
    final sList = new List<String>(length);
    for (var i = 0; i < length; i++) {
      var h = global.hash(ints[i]);
      h = (h.isNegative) ? h % kMinValue : h % kMaxValue;
      final s = h.toString();
      print('s: "$s"');
      print('isValid: "$s" ${isValidValue(s)}');
      sList[i] = s;
    }
    print('sList: $sList');
    return update(sList);
  }

  @override
  IS get sha256 => sha256Unsupported(this);

  List<String> hashStringList(List<String> vList) {
    final iList = new List<String>(vList.length);
    for (var i = 0; i < vList.length; i++)
      iList[i] = vList[i].hashCode.toString();
    return iList;
  }

  List<int> hashIntList(List<int> vList) {
    final iList = new Int32List(vList.length);
    for (var i = 0; i < vList.length; i++) iList[i] = vList[i].hashCode;
    return iList;
  }

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static const bool kIsAsciiRequired = true;
  static const int kVRIndex = kISIndex;
  static const int kVRCode = kISCode;
  static const String kVRKeyword = 'IS';
  static const String kVRName = 'Integer String';
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxShortVF ~/ 2;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 12;
  static const int kMinValue = -99999999999;
  static const int kMaxValue = 999999999999;

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) {
      invalidStringLength(s, issues);
      return false;
    }
    final n = tryParse(s);
    if (n == null || notInRange(n, kMinValue, kMaxValue)) {
      invalidString(s, issues);
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

  /// Returns _true_ if both [tag] and [vList] are valid for [IS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, IS) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static bool isNotValidArgs(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      !isValidArgs(tag, vList, issues);

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [IS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, IS) &&
      inRange(vfBytes.length, 0, kMaxVFLength);

  static bool isNotValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) =>
      !isValidBytesArgs(tag, vfBytes, issues);

  /// Returns _true_ if [tag] is valid for [IS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      Tag.isValidTag(tag, issues, kVRIndex, IS);

  static bool isNotValidTag(Tag tag, [Issues issues]) =>
      !isValidTag(tag, issues);

  /// Returns _true_ if [vrIndex] is valid for [IS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [IS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kISCode);

  /// Returns _true_ if [vfLength] is valid for [IS].
  static bool isValidVFLength(int vfLength,
          [int max = kMaxVFLength, Issues issues]) =>
      inRange(vfLength, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, kMaxVFLength, issues);

  /// Returns _true_ if [vList].length is valid for [IS].
  static bool isValidVListLength(Tag tag, Iterable<String> vList,
      [Issues issues]) {
    if (!Tag.isValidTag(tag, issues, kVRIndex, IS))
      return invalidTag(tag, issues, IS);
    return Element.isValidVListLength(tag, vList, issues, kMaxLength);
  }

  /// Returns _true_ if [tag] has a VR of [IS] and [vList] is valid for [tag].
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

  static Bytes toBytes(List<String> sList) =>
      stringListToBytes(sList, kMaxVFLength);

  static ByteData toByteData(Iterable<String> values) =>
      stringListToByteData(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      stringListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
*/

  static int tryParse(String s, [Issues issues]) {
    if (s == null || notInRange(s.length, kMinValueLength, kMaxValueLength))
      return _badIS(s, issues);
    final n = int.tryParse(s);
    if (n == null || notInRange(n, kMinValue, kMaxValue))
      return _badIS(s, issues);
    return n;
  }

  static int _badIS(String s, Issues issues) {
    final msg = 'Invalid Integer String (IS): "$s"';
    return badString(msg, issues);
  }

  static List<int> tryParseList(Iterable<String> sList, [Issues issues]) {
    final result = <int>[];
    for (var s in sList) {
      final v = tryParse(s, issues);
      if (v == null) return null;
      result.add(v);
    }
    return result;
  }

  static List<int> tryParseBytes(Bytes vfBytes) =>
      tryParseList(vfBytes.getAsciiList());

  static Iterable<String> validateValueField(Bytes vfBytes) =>
      vfBytes.getAsciiList();
}
