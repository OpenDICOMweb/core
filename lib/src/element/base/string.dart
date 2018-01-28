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
import 'package:core/src/tag/tag.dart';
import 'package:core/src/uid/uid.dart';
import 'package:core/src/vr/vr.dart';

//TODO: add static .fromBytes and .fromByteData to all classes
typedef V _TryParser<V>(String s, Issues issues);

/// A function that returns_true_ if [s] is valid.
typedef bool Validator(String s, [Issues issues]);

/// A function that removes appropriate whitespace from [s].
typedef String Trimmer(String s);

bool _inRange(int v, int min, int max) => v >= min && v <= max;

/*
bool _isValidValueLength(String s, int min, int max) {
  if (s == null || s.isEmpty) return false;
  return _inRange(s.length, min, max);
}
*/



/*
bool _isFilteredString2(String s, int min, int max, bool filter(int c),
    {bool allowLeadingSpaces = false,
    bool allowTrailingSpaces = false,
    bool allowBlank = true}) {
  if (s.isEmpty) return true;
  if (s.length < min || s.length > max) return false;

  var i = 0;
  if (allowLeadingSpaces)
    for (; i < s.length; i++) if (s.codeUnitAt(i) != kSpace) break;

  // If s contains only space characters
  if (i >= s.length) return allowBlank;

  for (; i < s.length; i++) {
    final c = s.codeUnitAt(i);
    if (!filter(c)) {
      invalidCharacterInString(s, i);
      return false;
    }
  }
  if (i >= s.length) return true;

  if (allowTrailingSpaces) {
    for (; i < s.length; i++) if (s.codeUnitAt(i) != kSpace) return false;
    return true;
  }
  return false;
}
*/

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

  for (; i < s.length; i++) {
    if (!filter(s.codeUnitAt(i))) {
      invalidCharacterInString(s, i);
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

/* Flush at V.0.9.0
bool _isValidVFLength(int vfl, int minBytes, int maxBytes, int sizeInBytes) =>
    _inRange(vfl, minBytes, maxBytes) && (vfl % sizeInBytes == 0);

bool _isNotValidVF(int vfl, int min, int max, Issues issues) {
  if (vfl < min && vfl > max) {
    if (issues.isNotEmpty) issues.add('Invalid Value Field Length: $vfl');
    return true;
  }
  return false;
}
*/

/*
//Urgent Jim: add error message to issues
bool _isValidVListLength(Tag tag, int vLength, Issues issues, int maxLength) {
  assert(tag != null && vLength != null && maxLength != null);
  //if (length == 0) return true;
  final min = tag.vmMin;
  final max = (tag.vmMax == -1) ? maxLength : tag.vmMax;
  assert((min >= 0) && (max >= 1) && (max <= maxLength));
  return _inRange(vLength, min, max);
}
*/

/* Flush at V.0.9.0
bool _isNotValidValueLength(int length, int min, int max, Issues issues) {
  if (length < min && length > max) {
    if (issues.isNotEmpty) issues.add('Invalid Value Length: $length');
    return true;
  }
  return false;
}

*/
String blanks(int n) => ''.padRight(n, ' ');

/// Returns a [Uint8List] corresponding to a binary Value Field.
Uint8List textToBytes(String s, int maxVFLength, {bool isAscii = true}) {
  if (s == null) return nullValueError();
  if (s.isEmpty) return kEmptyUint8List;
  return _vfFromString(s, maxVFLength, isAscii);
}

/// Returns a [Uint8List] corresponding to a binary Value Field.
Uint8List stringListToBytes(List<String> sList, int maxVFLength,
    {bool isAscii = true}) {
  if (sList == null) return nullValueError();
  if (sList.isEmpty) return kEmptyUint8List;
  final s = (sList.length == 1 ? sList[0] : sList.join('\\'));
  return _vfFromString(s, maxVFLength, isAscii);
}

Uint8List _vfFromString(String s, int maxVFLength, bool isAscii) {
  final vf = (isAscii || system.useAscii) ? ASCII.encode(s) : UTF8.encode(s);
  if (!_isValidVFL(vf.length, maxVFLength))
    return invalidVFLength(vf.length, maxVFLength);
  return vf;
}

//TODO: vfBytes -> vfByteData
List<String> stringValuesFromBytes(TypedData bytes, int maxVFLength,
    {bool isAscii = true}) {
  if (bytes.lengthInBytes == 0) return kEmptyStringList;
  if (!_isValidVFL(bytes.lengthInBytes, maxVFLength))
    return invalidVFLength(bytes.lengthInBytes, maxVFLength);
  final s = _vfToString(bytes, isAscii);
  return s.split('\\');
}

//TODO: vfBytes -> vfByteData
List<String> textValuesFromBytes(TypedData vfBytes, int maxVFLength,
    {bool isAscii = true}) {
  if (vfBytes.lengthInBytes == 0) return kEmptyStringList;
  if (!_isValidVFL(vfBytes.lengthInBytes, maxVFLength))
    return invalidVFLength(vfBytes.lengthInBytes, maxVFLength);
  return <String>[_vfToString(vfBytes, isAscii)];
}

bool _isValidVFL(int v, int max) => v >= 0 && v <= max;

String _vfToString(TypedData vf, bool isAscii) {
  final vfBytes = vf.buffer.asUint8List(vf.offsetInBytes, vf.lengthInBytes);
  final allow = system.allowInvalidCharacterEncodings;
  return (isAscii || system.useAscii)
      ? ASCII.decode(vfBytes, allowInvalid: allow)
      : UTF8.decode(vfBytes, allowMalformed: allow);
}

/// The base [class] for [String] [Element]s with [values] that are [Iterable<String>].
abstract class StringBase<V> extends Element<String> {
  @override
  Iterable<String> get values;
  @override
  set values(Iterable<String> vList);

  // **** Getters that MUST be supported by every Element Type.

  @override
  TypedData get typedData => stringListToBytes(values, maxVFLength);

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
  Iterable<String> emptyList = const <String>[];

  @override
  StringBase get noValues => update(emptyList);

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

  @override
  Iterable<String> replace([Iterable<String> vList = kEmptyStringList]) =>
      _replace(vList);

  @override
  Iterable<String> replaceF(Iterable<String> f(Iterable<String> vList)) =>
      _replace(f(values) ?? kEmptyStringList);

  Iterable<String> _replace(Iterable<String> vList) {
    var v = vList ?? kEmptyStringList;
    if (v.isNotEmpty) {
      v = (vList is! Iterable<String>) ? vList.toList() : vList;
    }
    final old = values;
    values = v;
    return old;
  }

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

  bool isNotValidValuesLength(
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

/* Flush at V.0.9.0
  static bool _isValidVList(Iterable<String> values, Issues issues,
      bool isValidValue(String s, [Issues issues])) {
    for (var v in values) if (isNotValidValue(v, issues)) return false;
    return true;
  }
*/

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

  //Urgent Jim: definition of fromBase64 and toBase64(line:366) looks same
  //TODO: issues
  static Iterable<String> fromBase64(Iterable<String> sList, int maxVFLength,
      [Issues issues]) {
    final length = _stringListVFLength(sList);
    return (!_inRange(length, 0, maxVFLength))
        ? invalidVFLength(length, maxVFLength)
        : sList;
  }

  // Urgent Jim Fix
  //TODO: issues
  static Iterable<String> toBase64(Iterable<String> sList, int maxVFLength,
      [Issues issues]) {
    final length = _stringListVFLength(sList);
    return (!_inRange(length, 0, maxVFLength))
        ? invalidVFLength(length, maxVFLength)
        : sList;
  }

  /// Returns the length of a ValueField that holds [sList].
  static int _stringListVFLength(Iterable<String> sList) {
    var count = 0;
    for (var s in sList) count += s.length + 1;
    return count;
  }

  static Uint8List toBytes(List<String> sList, int maxVFLength) =>
      stringListToBytes(sList, maxVFLength);
}

abstract class StringAscii extends StringBase<String> {
  Iterable<String> get valuesFromBytes =>
      stringValuesFromBytes(vfBytes, maxVFLength, isAscii: true);

  Uint8List get bytesFromValues =>
      stringListToBytes(values, maxVFLength, isAscii: true);

/* Flush or Fix
  Iterable<String> get valuesFromJson =>
      StringBase.decodeJsonVF(sList, maxVFLength, issues);

  Iterable<String> get jsonFromValues =>
      StringBase.toBase64(sList, maxVFLength, issues);
*/

}

/// A Application Entity Title ([AE]) Element
abstract class AE extends StringAscii {
//  @override
//  VR get vr => kVR;
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
//  static const VR kVR = VR.kAE;
  static const int kVRIndex = kAEIndex;
  static const int kVRCode = kAECode;
  static const String kVRKeyword = 'AE';
  static const String kVRName = 'Application Entity';
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxVFLength ~/ 2;
  static const int kMinValueLength = 0;
  static const int kMaxValueLength = 16;

  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      (isValidVRIndex(tag.vrIndex) &&
          vList != null &&
          isValidValues(tag, vList));

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
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      stringValuesFromBytes(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) =>
      stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.fromBase64(sList, kMaxVFLength, issues);

  static Iterable<String> toBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.toBase64(sList, kMaxVFLength, issues);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      stringValuesFromBytes(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
}

/// A Code String ([CS]) Element
abstract class CS extends StringAscii {
//  @override
//  VR get vr => kVR;
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

  StringBase blank([int n = 1]) => update([blanks(n)]);

  static const bool kIsAsciiRequired = true;
  static bool allowLowerCase = false;
//  static const VR kVR = VR.kCS;
  static const int kVRIndex = kCSIndex;
  static const int kVRCode = kCSCode;
  static const String kVRKeyword = 'CS';
  static const String kVRName = 'Code String';
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxShortVF ~/ 2;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 16;

  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      (isValidVRIndex(tag.vrIndex) &&
          vList != null &&
          isValidValues(tag, vList, issues));

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
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      stringValuesFromBytes(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) =>
      stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.fromBase64(sList, kMaxVFLength, issues);

  static Iterable<String> toBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.toBase64(sList, kMaxVFLength, issues);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      stringValuesFromBytes(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
}

abstract class DS extends StringAscii {
//  @override
//  VR get vr => kVR;
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
    final vList = dList.map(floatToString);
    return update(vList);
  }

  /// Returns a [String] that approximately corresponds to [v],
  /// that has at most 16 characters.
  String floatToString(double v) {
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

  //TODO needs unit testing when needed
  /// Returns a new [DS] Element with values that are the hash of _this_.
  @override
  DS get hash =>
      update(numbers.map((n) => floatToString(system.hasher.doubleHash(n))));

  // TODO: Unit Test when needed
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
//  static const VR kVR = VR.kDS;
  static const int kVRIndex = kDSIndex;
  static const int kVRCode = kDSCode;
  static const String kVRKeyword = 'DS';
  static const String kVRName = 'Decimal String';
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxShortVF ~/ 2;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 16;

  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      (isValidVRIndex(tag.vrIndex) &&
          vList != null &&
          isValidValues(tag, vList));

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
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      stringValuesFromBytes(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) =>
      stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.fromBase64(sList, kMaxVFLength, issues);

  static Iterable<String> toBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.toBase64(sList, kMaxVFLength, issues);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      stringValuesFromBytes(bd, kMaxVFLength, isAscii: kIsAsciiRequired);

  //Urgent Sharath add tests with leading and trailing spaces, and all spaces (blank)
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

// TODO: make it so that there are three different sources of values.
// In priority order they are:
//    - _integers
//    - values
//    - vfBytes
// Since any of these can be null, they are checked in order. An implementation
// may override this order.
//
//   T update<T>(Iterable<T> vList);
abstract class IS extends StringAscii {
//  @override
//  VR get vr => kVR;
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
//  static const VR kVR = VR.kIS;
  static const int kVRIndex = kISIndex;
  static const int kVRCode = kISCode;
  static const String kVRKeyword = 'IS';
  static const String kVRName = 'Integer String';
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxShortVF ~/ 2;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 12;

  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      (isValidVRIndex(tag.vrIndex) &&
          vList != null &&
          isValidValues(tag, vList));

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
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      stringValuesFromBytes(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) =>
      stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.fromBase64(sList, kMaxVFLength, issues);

  static Iterable<String> toBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.toBase64(sList, kMaxVFLength, issues);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      stringValuesFromBytes(bd, kMaxVFLength, isAscii: kIsAsciiRequired);

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
      tryParseList(stringValuesFromBytes(vfBytes, kMaxVFLength));

  static Iterable<String> validateValueField(Uint8List vfBytes) =>
      stringValuesFromBytes(vfBytes, kMaxVFLength, isAscii: kIsAsciiRequired);

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
  final int padChar = kNull;
  @override
//  VR get vr => kVR;
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
  TypedData get typedData => stringListToBytes(values, kNull);

  Iterable<Uid> get uids => _uids ??= Uid.parseList(values);
  Iterable<Uid> _uids;

  //Urgent uids or uid1
  Iterable<Uid> get uids1 => _uids ??= _convertStrings();

  Uid get uid => (uids.length == 1) ? uids.elementAt(0) : null;

  //Urgent Fix: how to handle UID hashing.
  @override
  UI get hash =>
      throw new UnimplementedError('UIDs cannot currently be hashed');

  //Fix: how to handle UID hashing.
  @override
  UI get sha256 => sha256UnsupportedError(this);

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  Iterable<Uid> _convertStrings() {
    final uids = new List<Uid>(values.length);
    for (var v in values) uids.add(Uid.parse(v));
    return uids;
  }

  static const bool kIsAsciiRequired = true;
//  static const VR kVR = VR.kUI;
  static const int kVRIndex = kUIIndex;
  static const int kVRCode = kUICode;
  static const String kVRKeyword = 'UI';
  static const String kVRName = 'Unique Identifier (UID)';
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxShortVF ~/ 2;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 1024;

  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      (isValidVRIndex(tag.vrIndex) &&
          vList != null &&
          isValidValues(tag, vList));

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
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      stringValuesFromBytes(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) =>
      stringListToBytes(values, kMaxVFLength, isAscii: true);

  static Iterable<String> fromBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.fromBase64(sList, kMaxVFLength, issues);

  static Iterable<String> toBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.toBase64(sList, kMaxVFLength, issues);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      stringValuesFromBytes(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
}

abstract class StringUtf8 extends StringBase<String> {
  StringBase blank([int n = 1]) => update([blanks(n)]);

  List<String> valuesFromBytes(Uint8List bytes) =>
      stringValuesFromBytes(vfBytes, maxVFLength, isAscii: true);

  Uint8List bytesFromValues(List<String> vList) =>
      stringListToBytes(values, maxVFLength, isAscii: true);

  Iterable<String> valuesFromJson(Iterable<String> sList, [Issues issues]) =>
      StringBase.fromBase64(sList, maxVFLength, issues);

  Iterable<String> jsonFromValues(Iterable<String> sList, [Issues issues]) =>
      StringBase.toBase64(sList, maxVFLength, issues);
}

/// A Long String (LO) Element
abstract class LO extends StringUtf8 {
//  @override
//  VR get vr => kVR;
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
//  static const VR kVR = VR.kLO;
  static const int kVRIndex = kLOIndex;
  static const int kVRCode = kLOCode;
  static const String kVRKeyword = 'LO';
  static const String kVRName = 'Long String';
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxShortVF ~/ 2;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 64;

  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      (isValidVRIndex(tag.vrIndex) &&
          vList != null &&
          isValidValues(tag, vList));

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
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      stringValuesFromBytes(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) =>
      stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.fromBase64(sList, kMaxVFLength, issues);

  static Iterable<String> toBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.toBase64(sList, kMaxVFLength, issues);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      stringValuesFromBytes(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
}

/// A Private Creator [Element] is a subtype of [LO]. It always has a tag
/// of the form (gggg,00cc), where 0x10 <= cc <= 0xFF..
abstract class PC extends LO {
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRKeyword;

  static const String kVRKeyword = 'PC';
  static const String kVRName = 'Private Creator';
}

/// A Person Name ([PN]) [Element].
abstract class PN extends StringUtf8 {
//  @override
//  VR get vr => kVR;
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

  //Urgent: implement
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
//  static const VR kVR = VR.kPN;
  static const int kVRIndex = kPNIndex;
  static const int kVRCode = kPNCode;
  static const String kVRKeyword = 'PN';
  static const String kVRName = 'Person Name';
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxShortVF ~/ 2;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 3 * 64;

  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      (isValidVRIndex(tag.vrIndex) &&
          vList != null &&
          isValidValues(tag, vList));

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
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      stringValuesFromBytes(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) =>
      stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.fromBase64(sList, kMaxVFLength, issues);

  static Iterable<String> toBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.toBase64(sList, kMaxVFLength, issues);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      stringValuesFromBytes(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
}

/// A Short String (SH) Element
abstract class SH extends StringUtf8 {
//  @override
//  VR get vr => kVR;
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
//  static const VR kVR = VR.kSH;
  static const int kVRIndex = kSHIndex;
  static const int kVRCode = kSHCode;
  static const String kVRKeyword = 'SH';
  static const String kVRName = 'Short String';
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = kMaxShortVF ~/ 2;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 16;

  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      (isValidVRIndex(tag.vrIndex) &&
          vList != null &&
          isValidValues(tag, vList));

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
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      stringValuesFromBytes(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) =>
      stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.fromBase64(sList, kMaxVFLength, issues);

  static Iterable<String> toBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.toBase64(sList, kMaxVFLength, issues);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      stringValuesFromBytes(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
}

/// An Unlimited Characters (UC) Element
abstract class UC extends StringUtf8 {
//  @override
//  VR get vr => kVR;
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get vflSize => 4;
  @override
  int get maxLength => kMaxLength;
  @override
  int get maxVFLength => kMaxVFLength;

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static const bool kIsAsciiRequired = false;
//  static const VR kVR = VR.kUC;
  static const int kVRIndex = kUCIndex;
  static const int kVRCode = kUCCode;
  static const String kVRKeyword = 'UC';
  static const String kVRName = 'Unlimited Characters';
  static const int kMaxVFLength = kMaxLongVF;
  static const int kMaxLength = kMaxLongVF ~/ 2;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = kMaxLongVF;

  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      (isValidVRIndex(tag.vrIndex) &&
          vList != null &&
          isValidValues(tag, vList));

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
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      stringValuesFromBytes(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) =>
      stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.fromBase64(sList, kMaxVFLength, issues);

  static Iterable<String> toBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.toBase64(sList, kMaxVFLength, issues);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      stringValuesFromBytes(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
}

abstract class Text extends StringUtf8 {
  @override
  bool get isAsciiRequired => false;
  @override
  bool get isSingleValued => false;

  @override
  TypedData get typedData => textToBytes(values.elementAt(0), maxVFLength);

  @override
  bool checkLength([Iterable<String> vList, Issues issues]) =>
      vList.isEmpty || vList.length == 1;

  @override
  StringBase blank([int n = 1]) => update([blanks(n)]);

  Iterable<String> valueFromBytes(Uint8List vfBytes) =>
      textValuesFromBytes(vfBytes, maxVFLength, isAscii: isAsciiRequired);
}

/// An Long Text (LT) Element
abstract class LT extends Text {
//  @override
//  VR get vr => kVR;
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
//  static const VR kVR = VR.kLT;
  static const int kVRIndex = kLTIndex;
  static const int kVRCode = kLTCode;
  static const String kVRKeyword = 'LT';
  static const String kVRName = 'Long Text';
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = 1;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 10240;

  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      (isValidVRIndex(tag.vrIndex) &&
          vList != null &&
          isValidValues(tag, vList));

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
    if (_isNotDcmText(s, 10240)) {
      if (issues != null) issues.add('Invalid Long Text (LT): "$s"');
      return false;
    }
    return true;
  }

  static bool isNotValidValue(String s,
          {Issues issues, bool allowInvalid = false}) =>
      !isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (vList.length > 1) {
      invalidValuesLength(1, 1, vList, issues);
      return false;
    }
    return StringBase.isValidValues(
        tag, vList, issues, isValidValue, kMaxLength);
  }

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      textValuesFromBytes(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) {
    if (values.length > 1) invalidValuesLength(1, 1, values);
    return textToBytes(values.elementAt(0), kMaxVFLength,
        isAscii: kIsAsciiRequired);
  }

  static Iterable<String> fromBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.fromBase64(sList, kMaxVFLength, issues);

  static Iterable<String> toBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.toBase64(sList, kMaxVFLength, issues);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      textValuesFromBytes(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
}

/// An Short Text (ST) Element
abstract class ST extends StringUtf8 {
//  @override
//  VR get vr => kVR;
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

  //TODO: add issues

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static const bool kIsAsciiRequired = false;
//  static const VR kVR = VR.kST;
  static const int kVRIndex = kSTIndex;
  static const int kVRCode = kSTCode;
  static const String kVRKeyword = 'ST';
  static const String kVRName = 'Short Text';
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = 1;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 1024;

  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      (isValidVRIndex(tag.vrIndex) &&
          vList != null &&
          isValidValues(tag, vList));

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
    if (_isNotDcmText(s, 1024)) {
      if (issues != null) issues.add('Invalid Short Test (ST): "$s"');
      return false;
    }
    return true;
  }

  static bool isNotValidValue(String s,
          {Issues issues, bool allowInvalid = false}) =>
      !isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (vList.length > 1) {
      invalidValuesLength(1, 1, vList, issues);
      return false;
    }
    return StringBase.isValidValues(
        tag, vList, issues, isValidValue, kMaxLength);
  }

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      textValuesFromBytes(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) {
    if (values.length > 1) invalidValuesLength(1, 1, values);
    return textToBytes(values.elementAt(0), kMaxVFLength,
        isAscii: kIsAsciiRequired);
  }

  static Iterable<String> fromBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.fromBase64(sList, kMaxVFLength, issues);

  static Iterable<String> toBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.toBase64(sList, kMaxVFLength, issues);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      textValuesFromBytes(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
}

/// Value Representation of [Uri].
///
/// The Value Multiplicity of this [Element] is 1.
abstract class UR extends Text {
//  @override
//  VR get vr => kVR;
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get vflSize => 4;
  @override
  int get maxLength => kMaxLength;
  @override
  int get maxVFLength => kMaxVFLength;

  Uri get uri => _uri ??= (values.length != 1) ? null : Uri.parse(values.first);
  Uri _uri;

  //TODO: add issues

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  Iterable<Uid> _convertStrings() {
    final uids = new List<Uid>(values.length);
    for (var v in values) uids.add(Uid.parse(v));
    return uids;
  }

  static const bool kIsAsciiRequired = false;
//  static const VR kVR = VR.kUR;
  static const int kVRIndex = kURIndex;
  static const int kVRCode = kURCode;
  static const String kVRKeyword = 'UR';
  static const String kVRName =
      'Universal Resource Identifier or Universal Resource Locator (URI/URL)';
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMaxLength = 1;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = kMaxLongVF;

  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      (isValidVRIndex(tag.vrIndex) &&
          vList != null &&
          isValidValues(tag, vList));

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

  //Urgent Jim: Add switch for leading spaces
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

  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (vList.length > 1) {
      invalidValuesLength(1, 1, vList, issues);
      return false;
    }
    return StringBase.isValidValues(
        tag, vList, issues, isValidValue, kMaxLength);
  }

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      textValuesFromBytes(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) {
    if (values.length > 1) invalidValuesLength(1, 1, values);
    return textToBytes(values.elementAt(0), kMaxVFLength,
        isAscii: kIsAsciiRequired);
  }

  static Iterable<String> fromBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.fromBase64(sList, kMaxVFLength, issues);

  static Iterable<String> toBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.toBase64(sList, kMaxVFLength, issues);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      textValuesFromBytes(bd, kMaxVFLength, isAscii: kIsAsciiRequired);

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
abstract class UT extends StringUtf8 {
//  @override
//  VR get vr => kVR;
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
  @override
  String get vrKeyword => kVRKeyword;
  @override
  String get vrName => kVRName;
  @override
  int get vflSize => 4;
  @override
  int get maxLength => kMaxLength;
  @override
  int get maxVFLength => kMaxVFLength;

  //TODO: add issues

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  Iterable<Uid> _convertStrings() {
    final uids = new List<Uid>(values.length);
    for (var v in values) uids.add(Uid.parse(v));
    return uids;
  }

  static const bool kIsAsciiRequired = false;
//  static const VR kVR = VR.kUT;
  static const int kVRIndex = kUTIndex;
  static const int kVRCode = kUTCode;
  static const String kVRKeyword = 'UT';
  static const String kVRName = 'Unlimited Text';
  static const int kMaxVFLength = kMaxLongVF;
  static const int kMaxLength = 1;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = kMaxLongVF;

  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      (isValidVRIndex(tag.vrIndex) &&
          vList != null &&
          isValidValues(tag, vList));

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

  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (vList.length > 1) {
      invalidValuesLength(1, 1, vList, issues);
      return false;
    }
    return StringBase.isValidValues(
        tag, vList, issues, isValidValue, kMaxLength);
  }

  static Iterable<String> fromBytes(Uint8List bytes,
          {int offset = 0, int length}) =>
      textValuesFromBytes(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) {
    if (values.length > 1) invalidValuesLength(1, 1, values);
    return textToBytes(values.elementAt(0), kMaxVFLength,
        isAscii: kIsAsciiRequired);
  }

  static Iterable<String> fromBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.fromBase64(sList, kMaxVFLength, issues);

  static Iterable<String> toBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.toBase64(sList, kMaxVFLength, issues);

  static Iterable<String> fromByteData(ByteData bd,
          {int offset = 0, int length}) =>
      textValuesFromBytes(bd, kMaxVFLength, isAscii: kIsAsciiRequired);
}

// **** Date/Time Elements

abstract class AS extends StringBase<int> {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
//  @override
//  VR get vr => kVR;
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
  TypedData get typedData =>
      textToBytes(values.elementAt(0), kMaxVFLength, isAscii: isAsciiRequired);

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
//  static const VR kVR = VR.kAS;
  static const String kVRKeyword = 'AS';
  static const String kVRName = 'Age String';
  static const int kMaxLength = kMaxShortVF ~/ (kMinValueLength + 1);
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMinValueLength = 4;
  static const int kMaxValueLength = 4;

  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      (isValidVRIndex(tag.vrIndex) &&
          vList != null &&
          isValidValues(tag, vList));

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

  //Urgent: Add issues everywhere
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
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromBytes(Uint8List bytes) =>
      stringValuesFromBytes(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) =>
      stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.fromBase64(sList, kMaxVFLength, issues);

  static Iterable<String> toBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.toBase64(sList, kMaxVFLength, issues);

  static Iterable<String> tryDecodeVF(Uint8List bytes) =>
      textValuesFromBytes(bytes, kMaxVFLength);

  static Age tryParse(String s, {bool allowLowerCase = false}) =>
      Age.tryParse(s, allowLowercase: false);

  static int tryParseString(String s, {bool allowLowerCase = false}) =>
      Age.tryParseString(s, allowLowercase: false);
}

/// An abstract class for date ([DA]) [Element]s.
abstract class DA extends StringBase<int> {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
//  @override
//  VR get vr => kVR;
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
//  static const VR kVR = VR.kDA;
  static const String kVRKeyword = 'DA';
  static const String kVRName = 'Date';
  static const int kMaxLength = kMaxShortVF ~/ (kMinValueLength + 1);
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMinValueLength = 8;
  static const int kMaxValueLength = 8;

  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      (isValidVRIndex(tag.vrIndex) &&
          vList != null &&
          isValidValues(tag, vList, issues));

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
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromBytes(Uint8List bytes) =>
      stringValuesFromBytes(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) =>
      stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.fromBase64(sList, kMaxVFLength, issues);

  static Iterable<String> toBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.toBase64(sList, kMaxVFLength, issues);

  static Iterable<String> tryDecodeVF(Uint8List bytes) =>
      stringValuesFromBytes(bytes, kMaxVFLength, isAscii: true);
}

/// An abstract class for time ([TM]) [Element]s.
abstract class DT extends StringBase<int> {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
//  @override
//  VR get vr => kVR;
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
//  static const VR kVR = VR.kDT;
  static const String kVRKeyword = 'DT';
  static const String kVRName = 'Date Time';
  static const int kMaxLength = kMaxShortVF ~/ (kMinValueLength + 1);
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMinValueLength = 4;
  static const int kMaxValueLength = 26;

  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      (isValidVRIndex(tag.vrIndex) &&
          vList != null &&
          isValidValues(tag, vList, issues));

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
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromBytes(Uint8List bytes) =>
      stringValuesFromBytes(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) =>
      stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.fromBase64(sList, kMaxVFLength, issues);

  static Iterable<String> toBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.toBase64(sList, kMaxVFLength, issues);

  static Iterable<String> tryDecodeVF(Uint8List bytes) =>
      stringValuesFromBytes(bytes, kMaxVFLength, isAscii: true);
}

/// An abstract class for time ([TM]) [Element]s.
///
/// [Time] [String]s have the following format: HHMMSS.ffffff.
/// [See PS3.18, TM](http://dicom.nema.org/medical/dicom/current/output/html/part18.html#para_3f950ae4-871c-48c5-b200-6bccf821653b)
abstract class TM extends StringBase<int> {
  @override
  int get vrIndex => kVRIndex;
  @override
  int get vrCode => kVRCode;
//  @override
//  VR get vr => kVR;
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
//  static const VR kVR = VR.kTM;
  static const String kVRKeyword = 'TM';
  static const String kVRName = 'Time';
  static const int kMaxLength = kMaxShortVF ~/ (kMinValueLength + 1);
  static const int kMaxVFLength = kMaxShortVF;
  static const int kMinValueLength = 2;
  static const int kMaxValueLength = 13;

  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) =>
      (isValidVRIndex(tag.vrIndex) &&
          vList != null &&
          isValidValues(tag, vList, issues));

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
      StringBase.isValidValues(tag, vList, issues, isValidValue, kMaxLength);

  static Iterable<String> checkList(Tag tag, Iterable<String> vList,
          [Issues issues]) =>
      (isValidValues(tag, vList, issues)) ? vList : null;

  static Iterable<String> fromBytes(Uint8List bytes) =>
      stringValuesFromBytes(bytes, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Uint8List toBytes(Iterable<String> values) =>
      stringListToBytes(values, kMaxVFLength, isAscii: kIsAsciiRequired);

  static Iterable<String> fromBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.fromBase64(sList, kMaxVFLength, issues);

  static Iterable<String> toBase64(Iterable<String> sList, [Issues issues]) =>
      StringBase.toBase64(sList, kMaxVFLength, issues);

  static Iterable<String> tryDecodeVF(Uint8List bytes) =>
      stringValuesFromBytes(bytes, kMaxVFLength, isAscii: true);
}
