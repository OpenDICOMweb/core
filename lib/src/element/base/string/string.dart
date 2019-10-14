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

import 'package:bytes/bytes.dart';
import 'package:bytes_dicom/bytes_dicom.dart';
import 'package:collection/collection.dart';
import 'package:constants/constants.dart';
import 'package:core/src/element/base/bulkdata.dart';
import 'package:core/src/element/base/crypto.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/error.dart';
import 'package:core/src/global.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/element/base/utils.dart';
import 'package:core/src/error/element_errors.dart';
import 'package:core/src/values.dart';

part 'package:core/src/element/base/string/ascii.dart';
part 'package:core/src/element/base/string/date_time.dart';
part 'package:core/src/element/base/string/number.dart';
part 'package:core/src/element/base/string/string_bulkdata.dart';
part 'package:core/src/element/base/string/text.dart';
part 'package:core/src/element/base/string/utf8.dart';

// ignore_for_file: public_member_api_docs

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
  List<String> get values;

  /// The [Trim] that may be applied to [values]. Defaults to [Trim.trailing].
  Trim get trim;

  // **** End of interface

  @override
  int get vlfSize => kVLFSize;

  int get maxValueLength;
  @override
  int get maxLength => kMaxLength;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  bool get isLengthAlwaysValid => false;
  @override
  bool get isUndefinedLengthAllowed => false;

  @override
  String get asString => values.join('\\');

  // **** Getters that MUST be supported by every Element Type.

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

  /// The _canonical_ empty [values] values for Floating Point Elements.
  @override
  List<String> get emptyList => kEmptyList;

  @override
  StringBase get noValues => update(kEmptyList);

  // **** String specific Getters
  bool get isAsciiRequired => true;
  bool get isSingleValued => false;
  int get padChar => kSpace;

  StringBase blank([int n = 1]) => update([spaces(n)]);

  @override
  bool checkValue(String v, {Issues issues, bool allowInvalid = false});

  @override
  bool checkValues(Iterable<String> vList, [Issues issues]) =>
      super.checkValues(vList, issues);

  static const int kVLFSize = 2;
  static const int kSizeInBytes = 1;
  static const int kSizeInBits = kSizeInBytes * 8;
  static const int kMaxLength = k8BitMaxShortVF ~/ (kMinValueLength + 1);
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const int kMinValueLength = 1;
  static const bool kIsLengthAlwaysValid = false;
  static const bool kIsUndefinedLengthAllowed = false;
  static const bool kIsAsciiRequired = true;
  static const List<String> kEmptyList = <String>[];

  /// Default Trim values for Strings
  static const Trim kTrim = Trim.trailing;

  static bool isValidValueLength(
      String s, Issues issues, int minLength, int maxLength) {
    if (s == null) return nullValueError('"$s"');
    if (s.isEmpty || allowOversizedStrings) return true;
    final length = s.length;
    if (length < minLength || length > maxLength) {
      if (issues != null) {
        if (length < minLength)
          issues.add('Invalid Value($s) under minimum($minLength)');
        if (length < minLength)
          issues.add('Invalid Value($s) over maximum($maxLength)');
      }
      if (allowOversizedStrings) return true;
      return invalidStringLength(s);
    }
    return true;
  }

  static bool isValidValues(
      Tag tag,
      Iterable<String> vList,
      Issues issues,
      bool Function(String s, {Issues issues, bool allowInvalid}) isValidValue,
      int maxLength,
      Type type) {
    if (vList == null) return nullValueError();
    if (!doTestElementValidity || vList.isEmpty) return true;

    // Walk through length and all values to gather Issues.
    var ok = true;
    if (!Element.isValidLength(tag, vList, issues, maxLength, type))
      return ok = false;
    for (final v in vList) {
      if (!isValidValue(v, issues: issues)) ok = false;
    }
    return ok ? ok : invalidValues(vList, issues);
  }

  static List<V> reallyTryParseList<V>(Iterable<String> vList, Issues issues,
      Object Function(String s, [Issues issues]) tryParse) {
    final result = <V>[];
    for (final s in vList) {
      final V v = tryParse(s, issues);
      if (v == null) return null;
      result.add(v);
    }
    return result;
  }
}

bool _isValidValues(
        Tag tag,
        Iterable<String> vList,
        Issues issues,
        bool Function(String s, {Issues issues, bool allowInvalid})
            isValidValue,
        int maxLength,
        Type type) =>
    StringBase.isValidValues(tag, vList, issues, isValidValue, maxLength, type);
