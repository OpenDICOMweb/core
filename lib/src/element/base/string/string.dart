//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/src/element/base/crypto.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/errors.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/utils/primitives.dart';

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
  TypedData get typedData =>
      stringListToUint8List(values, maxLength: maxVFLength);

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
    final v = values;
    return (v.isEmpty) ? 0 : joinLength(v);
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
  int get padChar => kSpace;

  StringBase blank([int n = 1]) => update([spaces(n)]);

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false});

  @override
  bool checkValues(Iterable<String> vList, [Issues issues]) =>
      super.checkValues(vList, issues);

  static const bool kIsAsciiRequired = true;
  static const int kSizeInBytes = 1;
  static const int kSizeInBits = kSizeInBytes * 8;

  /// _Deprecated_: Used DicomBytes.toAsciiList or DicomBytes.toUtfList instead.
  /// Returns a [Iterable<String>] from [vfBytes].
  // Design Note:
  //   - [vfBytes] MUST have any padding character removed.
  @deprecated
  Iterable<String> decodeBinaryStringVF(Uint8List vfBytes, int maxVFLength,
      {bool isAscii = true}) {
    if (vfBytes.isEmpty) return kEmptyStringList;
    final allow = system.allowInvalidCharacterEncodings;
    final s = (isAscii || system.useAscii)
        ? ascii.decode(vfBytes, allowInvalid: allow)
        : utf8.decode(vfBytes, allowMalformed: allow);
    return s.split('\\');
  }

  /// _Deprecated_: Used DicomBytes.toAscii or DicomBytes.toUtf instead.
  /// Returns a [Iterable<String>] of length 0 or 1 from [vfBytes].
  // Design Note:
  //   - [vfBytes] MUST have any padding character removed.
  @deprecated
  static Iterable<String> decodeBinaryTextVF(Uint8List vfBytes, int maxVFLength,
      {bool isAscii = true}) {
    if (vfBytes.isEmpty) return kEmptyStringList;
    final length = vfBytes.length;
    if (!inRange(length, 0, maxVFLength))
      return badVFLength(length, maxVFLength);
    final allow = system.allowInvalidCharacterEncodings;
    return (isAscii || system.useAscii)
        ? <String>[ascii.decode(vfBytes, allowInvalid: allow)]
        : <String>[utf8.decode(vfBytes, allowMalformed: allow)];
  }

/*
  static Uint8List toUint8List(List<String> sList, int maxVFLength) =>
      stringListToUint8List(sList, maxLength: maxVFLength);

  static Bytes toBytes(List<String> sList, int maxVFLength) =>
      Bytes.fromStrings(sList, maxLength: maxVFLength);
*/

  static bool isValidValueLength(
      String value, Issues issues, int minLength, int maxLength) {
    if (value == null) {
      if (issues != null) issues.add('Invalid null value');
      return false;
    }
    final length = value.length;
    if (length < minLength || length > maxLength) {
      if (issues != null) {
        if (length < minLength)
          issues.add('Invalid Value($value) under minimum($minLength)');
        if (length < minLength)
          issues.add('Invalid Value($value) over maximum($maxLength)');
      }
      return false;
    }
    return true;
  }

  static bool isValidValues(
      Tag tag,
      Iterable<String> vList,
      Issues issues,
      bool isValidValue(String s, {Issues issues, bool allowInvalid}),
      int maxLength) {
    assert(vList != null);
    if (!doTestValidity || vList.isEmpty) return true;
    var ok = true;
    if (!Element.isValidVListLength(tag, vList, issues, maxLength)) ok = false;
    for (var v in vList) ok = isValidValue(v, issues: issues);
    return (ok) ? true : invalidValues(vList, issues: issues);
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
