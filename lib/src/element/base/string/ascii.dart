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
import 'package:core/src/element/base/utils.dart';
import 'package:core/src/error/element_errors.dart';
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

// Note: Each [String] in a Value Field must be separated by a backslash ('\)
//       character. Thus, the minimum length of each string in a Value
//       Field is 2.
abstract class StringAscii extends StringBase {
  static const int kVLFSize = 2;
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const bool kIsLengthAlwaysValid = false;
  static const bool kIsUndefinedLengthAllowed = false;
  static const bool kIsAsciiRequired = true;

  @override
  int get vlfSize => kVLFSize;
  @override
  bool get isAsciiRequired => true;
  @override
  bool get isSingleValued => false;

  Bytes get asBytes => Bytes.fromAsciiList(values, maxVFLength);

  @override
  TypedData get typedData =>
      stringListToUint8List(values, maxLength: maxVFLength, isAscii: true);

  List<String> valuesFromBytes(Bytes bytes) =>
      bytes.getAsciiList(allowInvalid: global.allowInvalidAscii);

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
  static const int kVRIndex = kAEIndex;
  static const int kVRCode = kAECode;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 16;
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const int kMaxLength = k8BitMaxShortVF ~/ (kMinValueLength + 1);

  static const String kVRName = 'Application Entity';
  static const String kVRKeyword = 'AE';

  static const Type kType = AE;

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

  /// Returns _true_ if both [tag] and [vList] are valid for [AE].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, AE);
    return vList != null &&
        doTestElementValidity &&
        isValidTag(tag) &&
        isValidValues(tag, vList);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [AE].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, AE);
    return vfBytes != null &&
        doTestElementValidity &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [AE].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTag_(tag, issues, kVRIndex, AE);

  /// Returns _true_ if [vrIndex] is valid for [AE].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [AE].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kVRCode);

  /// Returns _true_ if [vfLength] is valid for [AE].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : inRange(vfLength, 0, k8BitMaxShortVF);

  /// Returns _true_ if [vList].length is valid for [AE].
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, AE);
    if (vList == null) return nullValueError();
    return Element.isValidLength(tag, vList, issues, kMaxLength, AE);
  }

  /// Returns _true_ if [tag] has a VR of [AE] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, isValidValue, kMaxLength, AE);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  /// Returns _true_ if [s] is a valid Application Entity Title ([AE])
  /// [String].
  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    return (isDcmString(s, 16, allowLeading: true))
        ? true
        : invalidString('Invalid AETitle String (AE): "$s"', issues);
  }
}

abstract class AS extends StringAscii {
  static const int kVRIndex = kASIndex;
  static const int kVRCode = kASCode;
  static const int kMinValueLength = 4;
  static const int kMaxValueLength = 4;
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const int kMaxLength = k8BitMaxShortVF ~/ (kMinValueLength + 1);

  static const String kVRName = 'Age String';
  static const String kVRKeyword = 'AS';

  static const Type kType = AS;

  /// Special variable for overriding uppercase constraint.
  static bool allowLowerCase = false;

  @override
  bool operator ==(Object other) => (other is AS && value == other.value);

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
  bool get isSingleValued => true;

  @override
  int get hashCode {
    if (values.isEmpty) return 0;
    return (values.length == 1 && Age.isValidString(values.elementAt(0)))
        ? global.hash(age.nDays)
        : badValues(values);
  }

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

  // **** Generalized static methods

  /// Returns _true_ if both [tag] and [vList] are valid for [AS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, AS);
    return vList != null &&
        doTestElementValidity &&
        isValidTag(tag) &&
        isValidValues(tag, vList);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [AS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, AS);
    return vfBytes != null &&
        doTestElementValidity &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [AS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTag_(tag, issues, kVRIndex, AS);

  /// Returns _true_ if [vrIndex] is valid for [AS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [AS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kVRCode);

  /// Returns _true_ if [vfLength] is valid for [AS].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : inRange(vfLength, 0, k8BitMaxShortVF);

  /// Returns _true_ if [vList].length is valid for [AS].
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, AS);
    if (vList == null) return nullValueError();
    return Element.isValidLength(tag, vList, issues, kMaxLength, AS);
  }

  /// Returns _true_ if [tag] has a VR of [AS] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, isValidValue, kMaxLength, AS);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    return (Age.isValidString(s, issues))
        ? true
        : invalidAgeString('Invalid Age String (AS): "$s"', issues);
  }

  static Age tryParse(String s, {bool allowLowerCase = false}) =>
      Age.tryParse(s, allowLowercase: false);

  static int tryParseString(String s, {bool allowLowerCase = false}) =>
      Age.tryParseString(s, allowLowercase: false);
}

/// A Code String ([CS]) Element
abstract class CS extends StringAscii {
  static const int kVRIndex = kCSIndex;
  static const int kVRCode = kCSCode;
  static const int kMinValueLength = 0;
  static const int kMaxValueLength = 16;
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const int kMaxLength = k8BitMaxShortVF ~/ (kMinValueLength + 1);

  static const String kVRKeyword = 'CS';
  static const String kVRName = 'Code String';

  static const Type kType = CS;

  /// Special variable for overriding uppercase constraint.
  static bool allowLowerCase = false;

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

  CS blank([int n = 1]) => update([blanks(n)]);


  // **** Generalized static methods

  /// Returns _true_ if both [tag] and [vList] are valid for [CS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, CS);
    return vList != null &&
        doTestElementValidity &&
        isValidTag(tag) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [CS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, CS);
    return vfBytes != null &&
        doTestElementValidity &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [CS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTag_(tag, issues, kVRIndex, CS);

  /// Returns _true_ if [vrIndex] is valid for [CS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [CS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kVRCode);

  /// Returns _true_ if [vfLength] is valid for [CS].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : inRange(vfLength, 0, k8BitMaxShortVF);

  /// Returns _true_ if [vList].length is valid for [CS].
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, CS);
    if (vList == null) return nullValueError();
    return Element.isValidLength(tag, vList, issues, kMaxLength, CS);
  }

  /// Returns _true_ if [tag] has a VR of [CS] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, isValidValue, kMaxLength, CS);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    if (s.isEmpty) {
      log.warn('Empty Code String');
      return true;
    }
    return (isNotFilteredString(s, 0, kMaxValueLength, isCSChar,
            allowLeading: true, allowTrailing: true))
        ? invalidString('Invalid Code String (CS): "$s"')
        : true;
  }
}

abstract class UI extends StringAscii {
  static const int kVRIndex = kUIIndex;
  static const int kVRCode = kUICode;
  //Issue: is 16 the right number?
  static const int kMinValueLength = 14;
  static const int kMaxValueLength = 64;
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const int kMaxLength = k8BitMaxShortVF ~/ (kMinValueLength + 1);

  static const String kVRKeyword = 'UI';
  static const String kVRName = 'Unique Identifier (UID)';

  static const Type kType = UI;

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
  int get padChar => kNull;

  Iterable<Uid> get uids;
  set uids(Iterable<Uid> vList) => _uids = vList;
  Iterable<Uid> _uids;

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


  // **** Generalized static methods

  /// Returns _true_ if both [tag] and [vList] are valid for [UI].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UI);
    return vList != null &&
        doTestElementValidity &&
        isValidTag(tag) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [UI].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UI);
    return vfBytes != null &&
        doTestElementValidity &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [UI].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTag_(tag, issues, kVRIndex, UI);

  /// Returns _true_ if [vrIndex] is valid for [UI].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [UI].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kVRCode);

  /// Returns _true_ if [vfLength] is valid for [UI].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : inRange(vfLength, 0, k8BitMaxShortVF);

  /// Returns _true_ if [vList].length is valid for [UI].
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UI);
    if (vList == null) return nullValueError();
    return Element.isValidLength(tag, vList, issues, kMaxLength, UI)
        ? true
        : invalidValuesLength(vList, 0, kMaxLength, issues);
  }

  /// Returns _true_ if [tag] has a VR of [UI] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, isValidValue, kMaxLength, UI);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    return (Uid.isValidString(s))
        ? true
        : invalidString('Invalid Unique Identifier String (UI): "$s"', issues);
  }

  /// Returns _true_ if both [tag] is valid for [UI].
  /// [Uid]s are guaranteed to be valid.
  static bool isValidUidArgs(Tag tag, Iterable<Uid> vList, [Issues issues]) =>
      isValidTag_(tag, issues, kUIIndex, UI);

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
  static const int kVRIndex = kDAIndex;
  static const int kVRCode = kDACode;
  static const int kMinValueLength = 8;
  static const int kMaxValueLength = 8;
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const int kMaxLength = k8BitMaxShortVF ~/ (kMinValueLength + 1);

  static const String kVRKeyword = 'DA';
  static const String kVRName = 'Date';

  static const Type kType = DA;

  static bool allowLowerCase = false;

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

  // **** Generalized static methods

  /// Returns _true_ if both [tag] and [vList] are valid for [DA].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, DA);
    return vList != null &&
        doTestElementValidity &&
        isValidTag(tag) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [DA].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, DA);
    return vfBytes != null &&
        doTestElementValidity &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [DA].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTag_(tag, issues, kVRIndex, DA);

  /// Returns _true_ if [vrIndex] is valid for [DA].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [DA].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kVRCode);

  /// Returns _true_ if [vfLength] is valid for [DA].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : inRange(vfLength, 0, k8BitMaxShortVF);

  /// Returns _true_ if [vList].length is valid for [DA].
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, DA);
    if (vList == null) return nullValueError();
    return Element.isValidLength(tag, vList, issues, kMaxLength, DA);
  }

  /// Returns _true_ if [tag] has a VR of [DA] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, isValidValue, kMaxLength, DA);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    return (Date.isValidString(s, issues: issues))
        ? true
        : invalidString('Invalid Date String (DA): "$s"', issues);
  }
}

/// An abstract class for time ([TM]) [Element]s.
abstract class DT extends StringBase {
  static const int kVRIndex = kDTIndex;
  static const int kVRCode = kDTCode;
  static const int kMinValueLength = 4;
  static const int kMaxValueLength = 26;
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const int kMaxLength = k8BitMaxShortVF ~/ (kMinValueLength + 1);

  static const String kVRKeyword = 'DT';
  static const String kVRName = 'Date Time';

  static const Type kType = DT;

  static bool allowLowerCase = false;

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

  // **** Generalized static methods

  /// Returns _true_ if both [tag] and [vList] are valid for [DT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, DT);
    return vList != null &&
        doTestElementValidity &&
        isValidTag(tag) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [DT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, DT);
    return vfBytes != null &&
        doTestElementValidity &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [DT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTag_(tag, issues, kVRIndex, DT);

  /// Returns _true_ if [vrIndex] is valid for [DT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [DT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kVRCode);

  /// Returns _true_ if [vfLength] is valid for [DT].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : inRange(vfLength, 0, k8BitMaxShortVF);

  /// Returns _true_ if [vList].length is valid for [DT].
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, DT);
    if (vList == null) return nullValueError();
    return Element.isValidLength(tag, vList, issues, kMaxLength, DT);
  }

  /// Returns _true_ if [tag] has a VR of [DT] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, isValidValue, kMaxLength, DT);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    return (DcmDateTime.isValidString(s, issues: issues))
        ? true
        : invalidString('Invalid Date Time (DT): "$s"', issues);
  }
}

/// An abstract class for time ([TM]) [Element]s.
///
/// [Time] [String]s have the following format: HHMMSS.ffffff.
/// [See PS3.18, TM](http://dicom.nema.org/medical/dicom/current/output/
/// html/part18.html#para_3f950ae4-871c-48c5-b200-6bccf821653b)
abstract class TM extends StringBase {
  static const int kVRIndex = kTMIndex;
  static const int kVRCode = kTMCode;
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const int kMaxLength = k8BitMaxShortVF ~/ (kMinValueLength + 1);
  static const int kMinValueLength = 2;
  static const int kMaxValueLength = 13;

  static const String kVRName = 'Time';
  static const String kVRKeyword = 'TM';

  static const Type kType = TM;

  static bool allowLowerCase = false;

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

  // **** Generalized static methods

  /// Returns _true_ if both [tag] and [vList] are valid for [TM].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, TM);
    return vList != null &&
        doTestElementValidity &&
        isValidTag(tag) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [TM].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, TM);
    return vfBytes != null &&
        doTestElementValidity &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [TM].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTag_(tag, issues, kVRIndex, TM);

  /// Returns _true_ if [vrIndex] is valid for [TM].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [TM].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kVRCode);

  /// Returns _true_ if [vfLength] is valid for [TM].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : inRange(vfLength, 0, kMaxVFLength);

  /// Returns _true_ if [vList].length is valid for [TM].
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, TM);
    if (vList == null) return nullValueError();
    return Element.isValidLength(tag, vList, issues, kMaxLength, TM);
  }

  /// Returns _true_ if [tag] has a VR of [TM] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, isValidValue, kMaxLength, TM);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    // Note: isNotValidValueLength checks for null
    if (s == null || !isValidValueLength(s, issues)) return false;
    return (Time.isValidString(s, issues: issues))
        ? true
        : invalidString('Invalid Time String (TM): "$s"', issues);
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
