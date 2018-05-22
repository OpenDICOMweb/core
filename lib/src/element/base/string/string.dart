//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
library odw.sdk.element.base.string;

import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:core/src/element/base/bulkdata.dart';
import 'package:core/src/element/base/crypto.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/error.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/element/base/utils.dart';
import 'package:core/src/error/element_errors.dart';
import 'package:core/src/utils/character/dicom.dart';
import 'package:core/src/value.dart';
import 'package:core/src/vr/vr_internal.dart';

part 'package:core/src/element/base/string/ascii.dart';
part 'package:core/src/element/base/string/number.dart';
part 'package:core/src/element/base/string/string_bulkdata.dart';
part 'package:core/src/element/base/string/text.dart';
part 'package:core/src/element/base/string/utf8.dart';

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
  static const int kVLFSize = 2;
  static const int kSizeInBytes = 1;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const int kMaxLength = k8BitMaxShortVF ~/ (kMinValueLength + 1);
  static const int kMinValueLength = 1;
  static const bool kIsLengthAlwaysValid = false;
  static const bool kIsUndefinedLengthAllowed = false;
  static const bool kIsAsciiRequired = true;

  /// Default Trim values for Strings
  static const Trim kTrim = Trim.trailing;

  StringList _values;
  @override
  Iterable<String> get values => _values;
  @override
  set values(Iterable<String> vList) =>
      _values = (vList is List) ? vList : StringList.from();

  Trim get trim => kTrim;

  StringList get trimmed => _values.trim(trim);

  // **** End of interface

  @override
  int get vlfSize => kVLFSize;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  int get maxLength => kMaxLength;
  @override
  bool get isLengthAlwaysValid => false;
  @override
  bool get isUndefinedLengthAllowed => false;
  @override
  bool get hadULength => false;

  // **** Getters that MUST be supported by every Element Type.

  @override
  TypedData get typedData =>
      stringListToUint8List(values, maxLength: maxVFLength);

  @override
  StringBase get hash => sha256;
  @override
  StringBase get sha256 => update(Sha256.stringList(values));

  // **** Getters related to the [sizeInBytes].

  // Note: This must be overridden for [Text]
  @override
  int get vfLength {
    assert(values != null);
    final v = values;
    return (v.isEmpty) ? 0 : stringListLength(v);
  }

  @override
  int get lengthInBytes => vfLength;

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
  int get padChar => kSpace;

  StringBase blank([int n = 1]) => update([spaces(n)]);

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false});

  @override
  bool checkValues(Iterable<String> vList, [Issues issues]) =>
      super.checkValues(vList, issues);

/*
  /// _Deprecated_: Used DicomBytes.toAsciiList or DicomBytes.toUtfList instead.
  /// Returns a [Iterable<String>] from [vfBytes].
  // Design Note:
  //   - [vfBytes] MUST have any padding character removed.
  @deprecated
  Iterable<String> decodeBinaryStringVF(Uint8List vfBytes, int maxVFLength,
      {bool isAscii = true}) {
    if (vfBytes.isEmpty) return kEmptyStringList;
    final allow = global.allowInvalidCharacterEncodings;
    final s = (isAscii || global.useAscii)
        ? ascii.decode(vfBytes, allowInvalid: allow)
        : utf8.decode(vfBytes, allowMalformed: allow);
    return s.split('\\');
  }
*/

/*

  /// _Deprecated_: Used DicomBytes.toAscii or DicomBytes.toUtf instead.
  /// Returns a [Iterable<String>] of length 0 or 1 from [vfBytes].
  // Design Note:
  //   - [vfBytes] MUST have any padding character removed.
  @deprecated
  static Iterable<String> decodeBinaryTextVF(Uint8List vfBytes, int maxVFLength,
      {bool isAscii = true}) {
    if (vfBytes.isEmpty) return kEmptyStringList;
    final length = vfBytes.length;
    isValidValueFieldS
    if (!inRange(length, 0, maxVFLength))
      return badStringVFLength(length, maxVFLength);
    final allow = global.allowInvalidCharacterEncodings;
    return (isAscii || global.useAscii)
        ? <String>[ascii.decode(vfBytes, allowInvalid: allow)]
        : <String>[utf8.decode(vfBytes, allowMalformed: allow)];
  }
*/

  static bool isValidValueLength(
      String s, Issues issues, int minLength, int maxLength) {
    if (s == null) return nullValueError('"$s"');
    if (s.isEmpty) return true;
    final length = s.length;
    if (length < minLength || length > maxLength) {
      if (issues != null) {
        if (length < minLength)
          issues.add('Invalid Value($s) under minimum($minLength)');
        if (length < minLength)
          issues.add('Invalid Value($s) over maximum($maxLength)');
      }
      return invalidStringLength(s);
    }
    return true;
  }

  static bool isValidValues(
      Tag tag,
      Iterable<String> vList,
      Issues issues,
      bool isValidValue(String s, {Issues issues, bool allowInvalid}),
      int maxLength,
      Type type) {
//    assert(vList != null);
    if (vList == null) return nullValueError();
    if (!doTestElementValidity || vList.isEmpty) return true;

    // Walk through length and all values to gather Issues.
    var ok = true;
    if (!Element.isValidLength(tag, vList, issues, maxLength, type))
      return ok = false;
    for (var v in vList) {
      if (!isValidValue(v, issues: issues)) ok = false;
    }
    return (ok) ? true : invalidValues(vList, issues);
  }

  static List<V> reallyTryParseList<V>(Iterable<String> vList, Issues issues,
      Object tryParse(String s, [Issues issues])) {
    final result = <V>[];
    for (var s in vList) {
      final V v = tryParse(s, issues);
      if (v == null) return null;
      result.add(v);
    }
    return result;
  }
}
