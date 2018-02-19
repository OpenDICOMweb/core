// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/src/date_time/age.dart';
import 'package:core/src/date_time/date.dart';
import 'package:core/src/date_time/dcm_date_time.dart';
import 'package:core/src/date_time/primitives//age.dart';
import 'package:core/src/date_time/time.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/crypto.dart';
import 'package:core/src/element/errors.dart';
import 'package:core/src/empty_list.dart';
import 'package:core/src/entity/patient/person_name.dart';
import 'package:core/src/errors.dart';
import 'package:core/src/issues.dart';
import 'package:core/src/parser/parse_errors.dart';
import 'package:core/src/string/ascii.dart';
import 'package:core/src/string/dicom_string.dart';
import 'package:core/src/system/system.dart';
import 'package:core/src/tag/constants.dart';
import 'package:core/src/tag/private/pc_tag.dart';
import 'package:core/src/tag/tag.dart';
import 'package:core/src/uid/uid.dart';
import 'package:core/src/vr/vr.dart';

// TODO: For each class add the following static fields:
//       bool areLeadingSpacesAllowed = x;
//       bool areLeadingSpacesSignificant = x;
//       bool areTrailingSpacesAllowed = x;
//       bool areTrailingSpacesSignificant = x;
//       bool areEmbeddedSpacesAllowed = x;
//       bool areAllSpacesAllowed = x;
//       bool isEmptyStringAllowed = x;

/// The base [class] for [String] [Element]s with [values]
/// that are [Iterable<String>].
abstract class StringBase extends Element<String> {
  @override
  Iterable<String> get values;
  @override
  set values(Iterable<String> vList);

  // **** Getters that MUST be supported by every Element Type.

  @override
  TypedData get typedData => _stringListToBytes(values, maxVFLength);

  @override
  StringBase get hash => sha256;
  @override
  StringBase get sha256 => update(Sha256.stringList(values));

  // **** Getters related to the [sizeInBytes].
  @override
  int get sizeInBytes => kSizeInBytes;

  @override
  int get vfLength {
    assert(values != null);
    return (values.isEmpty) ? 0 : values.join('').length;
  }

  /// The _canonical_ empty [values] value for Floating Point Elements.
  @override
  List<String> get emptyList => kEmptyList;
  static const List<String> kEmptyList = const <String>[];

  @override
  StringBase get noValues => update(kEmptyList);

  // **** Getters that get Value Field as Uint or ByteData

  // **** String specific Getters
  bool get isAsciiRequired => true;
  bool get isSingleValued => false;
  @override
  int get padChar => kSpace;

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false});

  @override
  bool checkValues(Iterable<String> vList, [Issues issues]) =>
      super.checkValues(vList, issues);

  static const bool kIsAsciiRequired = true;
  static const int kSizeInBytes = 1;
  static const int kSizeInBits = kSizeInBytes * 8;

  static bool isValidValueLength(
      String v, Issues issues, int minLength, int maxLength) {
    final length = v.length;
    if (length < minLength || length > maxLength) {
      if (issues != null) {
        if (length < minLength)
          issues.add('Invalid Value($v) under minimum($minLength)');
        if (length < minLength)
          issues.add('Invalid Value($v) over maximum($maxLength)');
      }
      return false;
    }
    return true;
  }

  static bool isNotValidValuesLength(
          String v, Issues issues, int minLength, int maxLength) =>
      !isValidValueLength(v, issues, minLength, maxLength);

  static bool isValidValues(
      Tag tag,
      Iterable<String> vList,
      Issues issues,
      bool isValidValue(String s, {Issues issues, bool allowInvalid}),
      int maxVListLength) {
    if (Element.isNotValidVListLength(tag, vList, issues, maxVListLength))
      return false;
    var ok = true;
    for (var v in vList) ok = isValidValue(v, issues: issues);
    if (ok == false) {
      invalidValuesError(vList, issues: issues);
      return false;
    }
    return ok;
  }

  static bool isNotValidValues(
          Tag tag,
          Iterable<String> vList,
          Issues issues,
          bool isValidValue(String s, {Issues issues, bool allowInvalid}),
          int maxVListLength) =>
      !isValidValues(tag, vList, issues, isValidValue, maxVListLength);

  static Iterable<V> tryParseList<V>(
      Iterable<String> vList, Issues issues, _TryParser tryParse) {
    final result = <V>[];
    for (var s in vList) {
      final V v = tryParse(s, issues);
      if (v == null) return null;
      result.add(v);
    }
    return result;
  }

  /// Returns a [Iterable<String>] from [vfBytes].
  // Design Note:
  //   - [vfBytes] MUST have any padding character removed.
  static Iterable<String> decodeBinaryStringVF(
      Uint8List vfBytes, int maxVFLength,
      {bool isAscii = true}) {
    if (vfBytes.isEmpty) return kEmptyStringList;
    final allow = system.allowInvalidCharacterEncodings;
    final s = (isAscii || system.useAscii)
        ? ASCII.decode(vfBytes, allowInvalid: allow)
        : UTF8.decode(vfBytes, allowMalformed: allow);
    return s.split('\\');
  }

  /// Returns a [Iterable<String>] of length 0 or 1 from [vfBytes].
  // Design Note:
  //   - [vfBytes] MUST have any padding character removed.
  static Iterable<String> decodeBinaryTextVF(Uint8List vfBytes, int maxVFLength,
      {bool isAscii = true}) {
    if (vfBytes.isEmpty) return kEmptyStringList;
    final length = vfBytes.length;
    if (!_inRange(length, 0, maxVFLength))
      return invalidVFLength(length, maxVFLength);
    final allow = system.allowInvalidCharacterEncodings;
    return (isAscii || system.useAscii)
        ? <String>[ASCII.decode(vfBytes, allowInvalid: allow)]
        : <String>[UTF8.decode(vfBytes, allowMalformed: allow)];
  }

  static Uint8List toBytes(List<String> sList, int maxVFLength) =>
      _stringListToBytes(sList, maxVFLength);
}

abstract class StringAscii extends StringBase {
  Iterable<String> get valuesFromBytes =>
      _stringListFromTypedData(vfBytes, maxVFLength, isAscii: true);

  Uint8List get bytesFromValues =>
      _stringListToBytes(values, maxVFLength, isAscii: true);
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

  static bool isValidArgs(Tag tag, Iterable<String> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length, [Issues issues]) =>
      _inRange(length, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, issues);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (!_isDcmString(s, 16, allowLeading: true)) {
      if (issues != null) issues.add('Invalid AETitle String (AE): "$s"');
      return false;
    }
    return true;
  }

  static bool isNotValidValue(String s,
          {Issues issues, bool allowInvalid = false}) =>
      !isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Uint8List toBytes(Iterable<String> values) =>
      _stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      _stringListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static ByteData toByteData(Iterable<String> values) =>
      _stringListToByteData(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      _stringListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
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

  CS blank([int n = 1]) => update([_blanks(n)]);

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

  static bool isValidArgs(Tag tag, Iterable<String> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length, [Issues issues]) =>
      _inRange(length, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, issues);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (s.isEmpty) {
      log.warn('Empty Code String');
      return true;
    }
    if (_isNotFilteredString(s, 0, kMaxValueLength, isCSChar,
        allowLeading: true, allowTrailing: true)) {
      if (issues != null) issues.add('Invalid Code String (CS): "$s"');
      return false;
    }
    return true;
  }

  static bool isNotValidValue(String s,
          {Issues issues, bool allowInvalid = false}) =>
      !isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      _stringListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) =>
      _stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static ByteData toByteData(Iterable<String> values) =>
      _stringListToByteData(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      _stringListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
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
    for (var i = 0; i < length; i++) dList[i] = System.rng.nextDouble();
    final vList = dList.map(floatToDcmString);
    return update(vList);
  }

  // TODO: should this be in core/src/string?
  /// Returns a [String] that approximately corresponds to [v],
  /// that has at most 16 characters.
  String floatToDcmString(double v) {
    final precision = 10;
    var s = v.toString();
    if (s.length > 16) {
      for (var i = precision; i > 0; i--) {
        s = v.toStringAsPrecision(i);
        if (s.length <= 16) break;
      }
    }
    assert(s.length <= 16, '"$s" exceeds max DS length of 16');
    return s;
  }

  /// Returns a new [DS] Element with values that are the hash of _this_.
  @override
  DS get hash =>
      update(numbers.map((n) => floatToDcmString(system.hasher.doubleHash(n))));

  /// Returns a new [DS] Element with values that are constructed from
  /// the Sha256 hash digest of _this_.
  ///
  /// _Note_: The _digest_ is 32 bytes (128 bits) long; therefore, the length
  /// of the new [values] is at most 8. The [values] try to conform to the
  /// [vmMin] of for the Element.
  @override
  DS get sha256 {
    final hList =
        Sha256.float32(numbers).map(floatToDcmString).toList(growable: false);
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

  static bool isValidArgs(Tag tag, Iterable<String> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length, [Issues issues]) =>
      _inRange(length, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, issues);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) {
      invalidStringLength(s);
      return false;
    }
    final v = tryParse(s);
    if (v != null) return true;
    invalidString('Invalid Decimal (DS) String: "$s"');
    return false;
  }

  static bool isNotValidValue(String s,
          {Issues issues, bool allowInvalid = false}) =>
      !isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      _stringListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) =>
      _stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static ByteData toByteData(Iterable<String> values) =>
      _stringListToByteData(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      _stringListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);

  //TODO: Sharath add tests with leading and trailing spaces,
  // and all spaces (blank).
  /// Parse a [DS] [String]. Leading and trailing spaces allowed,
  /// but all spaces is illegal.
  static double tryParse(String s, [Issues issues]) {
    //TODO: change to double.tryParse when available
    final v = double.parse(s, _onError);
    if (v == null) {
      if (issues != null) issues.add('Invalid Digital String (DS): "$s"');
      return invalidString('$s', issues);
    }
    return v;
  }

  // ignore: avoid_returning_null
  static double _onError(String s) => null;

  static Iterable<double> tryParseList(Iterable<String> vList,
          [Issues issues]) =>
      StringBase.tryParseList(vList, issues, tryParse);
}


// In priority order they are:
//    - _integers
//    - values
//    - vfBytes
// Since any of these can be null, they are checked in order. An implementation
// may override this order.
//
//   T update<T>(Iterable<T> vList);
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

  Iterable<int> get integers => _integers ??= tryParseList(values);
  Iterable<int> _integers;

  @override
  IS get hash;

  @override
  IS get sha256 => sha256UnsupportedError(this);

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

  static bool isValidArgs(Tag tag, Iterable<String> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length, [Issues issues]) =>
      _inRange(length, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, issues);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) {
      invalidStringLength(s, issues);
      return false;
    }
    final n = tryParse(s);
    if (n == null) {
      invalidString(s, issues);
      return false;
    }
    return true;
  }

  static bool isNotValidValue(String s,
          {Issues issues, bool allowInvalid = false}) =>
      !isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      _stringListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) =>
      _stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static ByteData toByteData(Iterable<String> values) =>
      _stringListToByteData(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      _stringListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);

  static int tryParse(String s, [Issues issues]) {
    //TODO: replace with tryParse when available
    final v = int.parse(s, onError: _onError);
    if (v == null) {
      if (issues != null) issues.add('Invalid Digital String (DS): "$s"');
      return invalidString(s, issues);
    }
    return v;
  }

  // Avoids creating the lambda on each parse.
  // ignore: avoid_returning_null
  static int _onError(String s) => null;

  static Iterable<int> tryParseList(Iterable<String> vList, [Issues issues]) {
    final result = <int>[];
    for (var s in vList) {
      final v = tryParse(s, issues);
      if (v == null) return null;
      result.add(v);
    }
    return result;
  }

  static Iterable<int> parseBytes(Uint8List vfBytes) =>
      tryParseList(_stringListFromTypedData(vfBytes, kMaxVFLength));

  static Iterable<String> validateValueField(Uint8List vfBytes) =>
      _stringListFromTypedData(vfBytes, kMaxVFLength,
          isAscii: kIsAsciiRequired);

  Iterable<String> hashStringList(List<String> vList) {
    final iList = new List<String>(vList.length);
    for (var i = 0; i < vList.length; i++)
      iList[i] = vList[i].hashCode.toString();
    return iList;
  }

  Iterable<int> hashIntList(List<int> vList) {
    final iList = new Int32List(vList.length);
    for (var i = 0; i < vList.length; i++) iList[i] = vList[i].hashCode;
    return iList;
  }
}

abstract class UI extends StringAscii {
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
  TypedData get typedData => _stringListToBytes(values, kNull);

  Iterable<Uid> get uids => _uids ??= Uid.parseList(values);
  Iterable<Uid> _uids;

  Uid get uid => (uids.length == 1) ? uids.elementAt(0) : null;

  // UI does not support [hash].
  @override
  UI get hash => unsupportedError('UIDs cannot currently be hashed');

  // UI does not support [sha256].
  @override
  UI get sha256 => sha256UnsupportedError(this);

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
    final v = uidList ?? kEmptyStringList;
    final old = uids;
    _uids = null;
    values = toStringList(v);
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

  static bool isValidArgs(Tag tag, Iterable<Uid> vList, [Issues issues]) =>
      vList != null &&
      (doTestValidity ? isValidValues(tag, toStringList(vList)) : true);

  static bool isValidStringArgs(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length, [Issues issues]) =>
      _inRange(length, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, issues);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

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

  static bool isNotValidValue(String s,
          {Issues issues, bool allowInvalid = false}) =>
      !isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      _stringListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) =>
      _stringListToBytes(values, kMaxVFLength, isAscii: true);

  static ByteData toByteData(Iterable<String> values) =>
      _stringListToByteData(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      _stringListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);

  static List<String> toStringList(Iterable<Uid> uids) {
    final sList = new List<String>(uids.length);
    for (var i = 0; i < sList.length; i++)
      sList[i] = uids.elementAt(i).toString();
    return sList;
  }
}

abstract class StringUtf8 extends StringBase {
  StringBase blank([int n = 1]) => update([_blanks(n)]);

  List<String> valuesFromBytes(Uint8List bytes) =>
      _stringListFromTypedData(vfBytes, maxVFLength, isAscii: false);

  Uint8List bytesFromValues(List<String> vList) =>
      _stringListToBytes(values, maxVFLength, isAscii: false);
}

/// A Long String (LO) Element
abstract class LO extends StringUtf8 {
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

  static bool isValidArgs(Tag tag, Iterable<String> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length, [Issues issues]) =>
      _inRange(length, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, issues);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (_isNotDcmString(s, 64)) {
      if (issues != null) issues.add('Invalid Long String (LO): "$s"');
      return false;
    }
    return true;
  }

  static bool isNotValidValue(String s,
          {Issues issues, bool allowInvalid = false}) =>
      !isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      _stringListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) =>
      _stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static ByteData toByteData(Iterable<String> values) =>
      _stringListToByteData(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      _stringListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
}

/// A Private Creator [Element] is a subtype of [LO]. It always has a tag
/// of the form (gggg,00cc), where 0x10 <= cc <= 0xFF..
abstract class PC extends LO {
  @override
  PCTag get tag;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRKeyword;
  @override
  String get creator;
  @override
  String get name => 'Private Creator - $creator';

  int get sgNumber => tag.sgNumber;

  static const String kVRKeyword = 'PC';
  static const String kVRName = 'Private Creator';
}

/// A Person Name ([PN]) [Element].
abstract class PN extends StringUtf8 {
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

  static bool isValidArgs(Tag tag, Iterable<String> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length, [Issues issues]) =>
      _inRange(length, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, issues);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (_isNotDcmString(s, 5 * 64)) {
      if (issues != null) issues.add('Invalid Person Name String (PN): "$s"');
      return false;
    }
    return true;
  }

  static bool isNotValidValue(String s,
          {Issues issues, bool allowInvalid = false}) =>
      !isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      _stringListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) =>
      _stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static ByteData toByteData(Iterable<String> values) =>
      _stringListToByteData(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      _stringListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
}

/// A Short String (SH) Element
abstract class SH extends StringUtf8 {
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

  static bool isValidArgs(Tag tag, Iterable<String> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length, [Issues issues]) =>
      _inRange(length, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, issues);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (_isNotDcmString(s, kMaxValueLength)) {
      if (issues != null) issues.add('Invalid Short String (SH): "$s"');
      return false;
    }
    return true;
  }

  static bool isNotValidValue(String s,
          {Issues issues, bool allowInvalid = false}) =>
      !isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      _stringListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) =>
      _stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static ByteData toByteData(Iterable<String> values) =>
      _stringListToByteData(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      _stringListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
}

/// An Unlimited Characters (UC) Element
abstract class UC extends StringUtf8 {
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

  static bool isValidArgs(Tag tag, Iterable<String> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length, [Issues issues]) =>
      _inRange(length, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, issues);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (_isNotDcmString(s, kMaxLongVF)) {
      if (issues != null)
        issues.add('Invalid Unlimited Characters String (UC): "$s"');
      return false;
    }
    return true;
  }

  static bool isNotValidValue(String s,
          {Issues issues, bool allowInvalid = false}) =>
      !isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      _stringListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) =>
      _stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static ByteData toByteData(Iterable<String> values) =>
      _stringListToByteData(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      _stringListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
}

abstract class Text extends StringUtf8 {
  @override
  bool get isAsciiRequired => false;
  @override
  bool get isSingleValued => false;

  @override
  TypedData get typedData => _textListToBytes(values, maxVFLength);

  @override
  bool checkLength([Iterable<String> vList, Issues issues]) =>
      vList.isEmpty || vList.length == 1;

  @override
  StringBase blank([int n = 1]) => update([_blanks(n)]);

  Iterable<String> valueFromBytes(Uint8List vfBytes) =>
      _textListFromTypedData(vfBytes, maxVFLength, isAscii: isAsciiRequired);
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

  static bool isValidArgs(Tag tag, Iterable<String> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length, [Issues issues]) =>
      _inRange(length, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, issues);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (_isNotDcmText(s, kMaxValueLength)) {
      if (issues != null) issues.add('Invalid Long Text (LT): "$s"');
      return false;
    }
    return true;
  }

  static bool isNotValidValue(String s,
          {Issues issues, bool allowInvalid = false}) =>
      !isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Uint8List toBytes(Iterable<String> values) =>
      _textListToBytes(values, kMaxVFLength);

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      _textListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static ByteData toByteData(Iterable<String> values) =>
      _textListToByteData(values, kMaxVFLength);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      _textListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
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

  static bool isValidArgs(Tag tag, Iterable<String> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length, [Issues issues]) =>
      _inRange(length, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, issues);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (_isNotDcmText(s, kMaxValueLength)) {
      if (issues != null) issues.add('Invalid Short Test (ST): "$s"');
      return false;
    }
    return true;
  }

  static bool isNotValidValue(String s,
          {Issues issues, bool allowInvalid = false}) =>
      !isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Uint8List toBytes(Iterable<String> values) =>
      _textListToBytes(values, kMaxVFLength);

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      _textListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static ByteData toByteData(Iterable<String> values) =>
      _textListToByteData(values, kMaxVFLength);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      _textListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
}

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

  static bool isValidArgs(Tag tag, Iterable<String> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length, [Issues issues]) =>
      _inRange(length, 0, kMaxShortVF);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, issues);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  //TODO Jim: Add switch for leading spaces
  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    try {
      if (s.startsWith(' ')) throw const FormatException();
      Uri.parse(s);
    } on FormatException {
      if (issues != null) issues.add('Invalid URI String (UR): "$s"');
      return false;
    }
    return true;
  }

  static bool isNotValidValue(String s,
          {Issues issues, bool allowInvalid = false}) =>
      !isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Uint8List toBytes(Iterable<String> values) =>
      _textListToBytes(values, kMaxVFLength);

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      _textListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static ByteData toByteData(Iterable<String> values) =>
      _textListToByteData(values, kMaxVFLength);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      _textListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uri parse(String s,
      {int start = 0, int end, Issues issues, Uri onError(String s)}) {
    final uri = tryParse(s, start: start, end: end, issues: issues);
    if (uri == null) {
      if (onError != null) return onError(s);
      throw new FormatException('Invalid Uri: "$s"');
    }
    return uri;
  }

  static Uri tryParse(String s, {int start = 0, int end, Issues issues}) {
    Uri uri;
    try {
      //TODO replace with Uri.tryParse when available
      uri = Uri.parse(s, start, end);
    } on FormatException {
      log.error('bad Uri: $s');
      if (issues != null) issues.add('Invalid URI String (UR): "$s"');
      return null;
    }
    return uri;
  }
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

  static bool isValidArgs(Tag tag, Iterable<String> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVListLength(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      Element.isValidVListLength(tag, vList, issues, kMaxLength);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length) => _inRange(length, 0, kMaxVFLength);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (_isNotDcmText(s, kMaxLongVF)) {
      if (issues != null) issues.add('Invalid Unlimited Text (UT): "$s"');
      return false;
    }
    return true;
  }

  static bool isNotValidValue(String s,
          {Issues issues, bool allowInvalid = false}) =>
      !isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Uint8List toBytes(Iterable<String> values) =>
      _textListToBytes(values, kMaxVFLength);

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      _textListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static ByteData toByteData(Iterable<String> values) =>
      _textListToByteData(values, kMaxVFLength);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      _textListFromTypedData(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
}

// **** Date/Time Elements

abstract class AS extends StringBase {
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
    if (values.length == 1 && Age.isValidString(values.elementAt(0)))
      return system.hash(age.nDays);
    return invalidValuesError(values);
  }

  @override
  TypedData get typedData => _textListToBytes(values, kMaxVFLength);

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

  static bool isValidArgs(Tag tag, Iterable<String> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length, [Issues issues]) =>
      _inRange(length, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, issues);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) {
      invalidAgeString('Invalid Age String: "$s"');
      return false;
    }
    if (Age.isValidString(s, issues)) return true;
    if (issues != null) issues.add('Invalid Age String (AS): "$s"');
    invalidAgeString('Invalid Age String: "$s"');
    return false;
  }

  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Uint8List toBytes(Iterable<String> values) =>
      _stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static List<String> fromBytes(Uint8List bytes) =>
      _textListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static ByteData toByteData(Iterable<String> values) =>
      _stringListToByteData(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static List<String> fromByteData(ByteData bd) =>
      _textListFromTypedData(bd, kMaxVFLength);

  static Age tryParse(String s, {bool allowLowerCase = false}) =>
      Age.tryParse(s, allowLowercase: false);

  static int tryParseString(String s, {bool allowLowerCase = false}) =>
      Age.tryParseString(s, allowLowercase: false);
}

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
      (dates.length == 1) ? dates.first : invalidValuesError(values, tag: tag);

  @override
  DA get hash {
    final dList = <String>[];
    for (var date in dates) {
      final h = date.hash;
      dList.add(h.dcm);
    }
    return update(dList);
  }

  DA normalize(Date enrollment) {
    final vList = Date.normalizeStrings(values, enrollment);
    return update(vList);
  }

  @override
  DA get sha256 => unsupportedError();

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

  static bool isValidArgs(Tag tag, Iterable<String> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length, [Issues issues]) =>
      _inRange(length, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, issues);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (!Date.isValidString(s, issues: issues)) {
      if (issues != null) issues.add('Invalid Date String (DA): "$s"');
      return false;
    }
    return true;
  }

  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Uint8List toBytes(Iterable<String> values) =>
      _stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromBytes(Uint8List bytes) =>
      _stringListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static ByteData toByteData(Iterable<String> values) =>
      _stringListToByteData(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd) =>
      _stringListFromTypedData(bd, kMaxVFLength, isAscii: true);
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

  DcmDateTime get dateTime => (dateTimes.length == 1)
      ? dateTimes.first
      : invalidValuesError(values, tag: tag);

  @override
  DT get hash {
    final dList = new List<String>(dateTimes.length);
    for (var i = 0; i < dateTimes.length; i++)
      dList[i] = dList[i].hashCode.toString();
    return update(dList);
  }

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

  static bool isValidArgs(Tag tag, Iterable<String> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length, [Issues issues]) =>
      _inRange(length, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, issues);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (!DcmDateTime.isValidString(s, issues: issues)) {
      if (issues != null) issues.add('Invalid Date Time (DT): "$s"');
      return false;
    }
    return true;
  }

  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromBytes(Uint8List bytes) =>
      _stringListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) =>
      _stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static ByteData toByteData(Iterable<String> values) =>
      _stringListToByteData(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd) =>
      _stringListFromTypedData(bd, kMaxVFLength, isAscii: true);
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
      (times.length == 1) ? times.first : invalidValuesError(values, tag: tag);

  @override
  TM get hash {
    final dList = new List<String>(times.length);
    for (var i = 0; i < times.length; i++)
      dList[i] = dList[i].hashCode.toString();
    return update(dList);
  }

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

  static bool isValidArgs(Tag tag, Iterable<String> vList) =>
      vList != null && (doTestValidity ? isValidValues(tag, vList) : true);

  static bool isValidTag(Tag tag) => isValidVRIndex(tag.vrIndex);

  static bool isNotValidTag(Tag tag) => !isValidVRIndex(tag.vrIndex);

  static bool isValidVRIndex(int vrIndex, [Issues issues]) {
    if (vrIndex == kVRIndex) return true;
    invalidVRIndex(vrIndex, issues, kVRIndex);
    return false;
  }

  static bool isValidVRCode(int vrCode, [Issues issues]) {
    if (vrCode == kVRCode) return true;
    invalidVRCode(vrCode, issues, kVRIndex);
    return false;
  }

  static int checkVRIndex(int vrIndex, [Issues issues]) =>
      (vrIndex == kVRIndex) ? vrIndex : invalidVR(vrIndex, issues, kVRIndex);

  static int checkVRCode(int vrCode, [Issues issues]) =>
      (vrCode == kVRCode) ? vrCode : invalidVRCode(vrCode, issues, kVRIndex);

  static bool isValidVFLength(int length, [Issues issues]) =>
      _inRange(length, 0, kMaxVFLength);

  static bool isNotValidVFLength(int length, [Issues issues]) =>
      !isValidVFLength(length, issues);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  static bool isNotValidValueLength(String s, [Issues issues]) =>
      !isValidValueLength(s, issues);

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || isNotValidValueLength(s, issues)) return false;
    if (!Time.isValidString(s, issues: issues)) {
      if (issues != null) issues.add('Invalid Time String (TM): "$s"');
      return false;
    }
    return true;
  }

  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      isValidVRIndex(tag.vrIndex) &&
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Uint8List toBytes(Iterable<String> values) =>
      _stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromBytes(Uint8List bytes) =>
      _stringListFromTypedData(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static ByteData toByteData(Iterable<String> values) =>
      _stringListToByteData(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromByteData(ByteData bd) =>
      _stringListFromTypedData(bd, kMaxVFLength, isAscii: true);
}

typedef V _TryParser<V>(String s, Issues issues);

bool _inRange(int v, int min, int max) => v >= min && v <= max;

//TODO: this does not handle escape sequences
bool _isFilteredString(String s, int min, int max, bool filter(int c),
    {bool allowLeadingSpaces = false,
    bool allowTrailingSpaces = false,
    bool allowBlank = true}) {
  if (s.isEmpty) return true;
  if (s.length < min || s.length > max) return false;

  var i = 0;
  if (allowLeadingSpaces)
    for (; i < s.length; i++) if (s.codeUnitAt(i) != kSpace) break;

  if (i >= s.length) return allowBlank;

  for (var j = 0; j < s.length; j++) {
    if (!filter(s.codeUnitAt(j))) {
      invalidCharacterInString(s, j);
      return false;
    }
  }
  return true;
}

bool _isNotFilteredString(String s, int min, int max, bool filter(int c),
        {bool allowLeading = false,
        bool allowTrailing = false,
        bool allowBlank = true}) =>
    !_isFilteredString(s, min, max, filter,
        allowLeadingSpaces: allowLeading, allowTrailingSpaces: allowTrailing);

bool _isDcmString(String s, int max,
    {bool allowLeading = true, bool allowBlank = true}) {
  final len = (s.length < max) ? s.length : max;
  return _isFilteredString(s, 0, len, isDcmStringChar,
      allowLeadingSpaces: allowLeading,
      allowTrailingSpaces: true,
      allowBlank: allowBlank);
}

bool _isNotDcmString(String s, int max, {bool allowLeading = true}) =>
    !_isDcmString(s, max, allowLeading: allowLeading);

bool _isDcmText(String s, int max) {
  final len = (s.length < max) ? s.length : max;
  return _isFilteredString(s, 0, len, isDcmTextChar,
      allowLeadingSpaces: false, allowTrailingSpaces: true);
}

bool _isNotDcmText(String s, int max) => !_isDcmText(s, max);

String _blanks(int n) => ''.padRight(n, ' ');

/// Returns a [Uint8List] corresponding to a binary Value Field.
Uint8List stringListToBytes(List<String> sList, int maxVFLength,
        {bool isAscii = true}) =>
    _stringListToBytes(sList, maxVFLength, isAscii: isAscii);

/// Returns a [Uint8List] corresponding to a binary Value Field.
Uint8List _stringListToBytes(List<String> sList, int maxVFLength,
    {bool isAscii = true}) {
  if (sList == null) return nullValueError();
  if (sList.isEmpty) return kEmptyUint8List;
  final s = (sList.length == 1 ? sList[0] : sList.join('\\'));
  return _bytesFromString(s, maxVFLength, isAscii);
}

Uint8List _bytesFromString(String s, int maxVFLength, bool isAscii) {
  final vf = (isAscii || system.useAscii) ? ASCII.encode(s) : UTF8.encode(s);
  if (!_isValidVFL(vf.length, maxVFLength))
    return invalidVFLength(vf.length, maxVFLength);
  return vf;
}

bool _isValidVFL(int v, int max) => v >= 0 && v <= max;

/// Returns a [Uint8List] corresponding to a binary Value Field.
ByteData _stringListToByteData(List<String> sList, int maxVFLength,
    {bool isAscii = true}) {
  final bytes = _stringListToBytes(sList, maxVFLength, isAscii: isAscii);
  return bytes.buffer.asByteData();
}

/// Returns a [Uint8List] corresponding to a binary Value Field.
Uint8List _textListToBytes(Iterable<String> values, int maxVFLength) {
  if (values.isEmpty) return kEmptyUint8List;
  if (values.length == 1) {
    final s = values.elementAt(0);
    if (s == null) return nullValueError();
    if (s.isEmpty) return kEmptyUint8List;
    return _bytesFromString(s, maxVFLength, false);
  }
  return invalidValuesLength(1, 1, values);
}

ByteData _textListToByteData(Iterable<String> values, int maxVFLength) {
  final bytes = _textListToBytes(values, maxVFLength);
  return bytes.buffer.asByteData();
}

List<String> stringListFromBytes(TypedData bytes, int maxVFLength,
        {bool isAscii = true}) =>
    _stringListFromTypedData(bytes, maxVFLength, isAscii: isAscii);

List<String> _stringListFromTypedData(TypedData td, int maxVFLength,
    {bool isAscii = true}) {
  if (td.lengthInBytes == 0) return kEmptyStringList;
  if (!_isValidVFL(td.lengthInBytes, maxVFLength))
    return invalidVFLength(td.lengthInBytes, maxVFLength);
  final s = _typedDataToString(td, isAscii);
  return s.split('\\');
}

String _typedDataToString(TypedData vf, bool isAscii) {
  final vfBytes = vf.buffer.asUint8List(vf.offsetInBytes, vf.lengthInBytes);
  final allow = system.allowInvalidCharacterEncodings;
  return (isAscii || system.useAscii)
      ? ASCII.decode(vfBytes, allowInvalid: allow)
      : UTF8.decode(vfBytes, allowMalformed: allow);
}

List<String> textListFromBytes(TypedData vfBytes, int maxVFLength,
        {bool isAscii = true}) =>
    _textListFromTypedData(vfBytes, maxVFLength, isAscii: isAscii);

List<String> _textListFromTypedData(TypedData vfBytes, int maxVFLength,
    {bool isAscii = true}) {
  if (vfBytes.lengthInBytes == 0) return kEmptyStringList;
  if (!_isValidVFL(vfBytes.lengthInBytes, maxVFLength))
    return invalidVFLength(vfBytes.lengthInBytes, maxVFLength);
  return <String>[_typedDataToString(vfBytes, isAscii)];
}
