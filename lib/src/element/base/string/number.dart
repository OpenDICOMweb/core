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
import 'package:core/src/element/base/string/ascii.dart';
import 'package:core/src/element/base/string/string.dart';
import 'package:core/src/element/base/utils.dart';
import 'package:core/src/error/element_errors.dart';
import 'package:core/src/error.dart';
import 'package:core/src/system.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/vr/vr_internal.dart';

// TODO: For each class add the following static fields:
//       bool areLeadingSpacesAllowed = x;
//       bool areLeadingSpacesSignificant = x;
//       bool areTrailingSpacesAllowed = x;
//       bool areTrailingSpacesSignificant = x;
//       bool areEmbeddedSpacesAllowed = x;
//       bool areAllSpacesAllowed = x;
//       bool isEmptyStringAllowed = x;

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
  int get maxLength => kMaxLengthForVR;
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
  static const int kMaxVFLength = k8BitMaxShortVF;
  // Issue: this is an artificial number
  static const int kMaxLengthForVR = k16BitMaxShortLength;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 16;

  // **** Generalized static methods

  /// Returns _true_ if both [tag] and [vList] are valid for [DS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, DS);
    return vList != null &&
        doTestElementValidity &&
        isValidTag(tag) &&
        StringBase.isValidValues(
            tag, vList, issues, isValidValue, kMaxLengthForVR, DS);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [DS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, DS);
    return vfBytes != null &&
        doTestElementValidity &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [DS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTag_(tag, issues, kVRIndex, DS);

  /// Returns _true_ if [vrIndex] is valid for [DS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [DS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kVRCode);

  /// Returns _true_ if [vfLength] is valid for [DS].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : inRange(vfLength, 0, kMaxVFLength);

  /// Returns _true_ if [vList].length is valid for [DS].
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) =>
      Element.isValidLength(tag, vList, issues, kMaxLengthForVR, DS);

  /// Returns _true_ if [tag] has a VR of [DS] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      StringBase.isValidValues(
          tag, vList, issues, isValidValue, kMaxLengthForVR, DS);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  /// Returns _true_ if [s] is a valid Decimal [String] ([DS])
  /// [String].
  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    final n = tryParse(s);
    if (n != null) return true;
    invalidString('Invalid Decimal (DS) String: "$s"');
    return false;
  }

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

  static Iterable<String> validateValueField(Bytes vfBytes) =>
      vfBytes.getAsciiList();
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
    ints = (ints is Iterable) ? ints.toList(growable: false) : ints;
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
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const int kMaxLength = k8BitMaxShortVF ~/ 2;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 12;
  static const int kMinValue = -99999999999;
  static const int kMaxValue = 999999999999;

  // **** Generalized static methods

  /// Returns _true_ if both [tag] and [vList] are valid for [IS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, IS);
    return vList != null &&
        doTestElementValidity &&
        isValidTag(tag) &&
        StringBase.isValidValues(
            tag, vList, issues, isValidValue, kMaxLength, IS);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [IS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, IS);
    return vfBytes != null &&
        doTestElementValidity &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [IS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTag_(tag, issues, kVRIndex, IS);

  /// Returns _true_ if [vrIndex] is valid for [IS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [IS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kVRCode);

  /// Returns _true_ if [vfLength] is valid for [IS].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : inRange(vfLength, 0, kMaxVFLength);

  /// Returns _true_ if [vList].length is valid for [IS].
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) =>
      Element.isValidLength(tag, vList, issues, kMaxLength, DS);

  /// Returns _true_ if [tag] has a VR of [IS] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      StringBase.isValidValues(
          tag, vList, issues, isValidValue, kMaxLength, IS);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    final n = tryParse(s);
    return (n == null || notInRange(n, kMinValue, kMaxValue))
        ? invalidString(s, issues)
        : true;
  }

  static int tryParse(String s, [Issues issues]) {
    if (s == null ||
        !isValidValueLength(s, issues) ||
        notInRange(s.length, kMinValueLength, kMaxValueLength))
      return _badIS(s, issues);
    final n = int.tryParse(s);
    return (n == null || notInRange(n, kMinValue, kMaxValue))
        ? _badIS(s, issues)
        : n;
  }

  static Null _badIS(String s, Issues issues) {
    final msg = 'Invalid Integer String (IS): "$s"';
    return badString(msg, issues);
  }

  static List<int> tryParseList(Iterable<String> sList, [Issues issues]) {
    final result = <int>[];
    for (var s in sList) {
      final v = tryParse(s, issues);
      if (v == null) return _badIS(s, issues);
      result.add(v);
    }
    return result;
  }

  static List<int> tryParseBytes(Bytes vfBytes) =>
      tryParseList(vfBytes.getAsciiList());

  static Iterable<String> validateValueField(Bytes vfBytes) =>
      vfBytes.getAsciiList();
}
