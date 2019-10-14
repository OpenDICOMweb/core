//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.element.base.string;

// ignore_for_file: public_member_api_docs

// TODO: For each class add the following static fields:
//       bool areLeadingSpacesAllowed = x;
//       bool areLeadingSpacesSignificant = x;
//       bool areTrailingSpacesAllowed = x;
//       bool areTrailingSpacesSignificant = x;
//       bool areEmbeddedSpacesAllowed = x;
//       bool areAllSpacesAllowed = x;
//       bool isEmptyStringAllowed = x;

abstract class Text extends Utf8String {
  @override
  bool get isAsciiRequired => false;
  @override
  bool get isSingleValued => true;

  @override
  bool checkLength([Iterable<String> vList, Issues issues]) =>
      vList.isEmpty || vList.length == 1;

  @override
  StringBase blank([int n = 1]) => update([spaces(n)]);

  @override
  List<String> valuesFromBytes(Bytes bytes) => [bytes.getUtf8()];

  static const bool kIsAsciiRequired = false;

  static List<String> fromValueField(Iterable vf, int maxVFLength,
      {bool isAscii = true}) {
    if (vf == null) return kEmptyStringList;
    if (vf.isEmpty ||
        ((vf is List<String>) && vf.length == 1) ||
        vf is StringBulkdata) return vf;
    if (vf is Bytes) return [vf.getUtf8()];
    if (vf is Uint8List)
      return stringListFromTypedData(vf, maxVFLength, isAscii: true);
    return badValues(vf);
  }

  /// Returns a [Bytes] created from [value];
  static Bytes toBytes(String value, {bool asView = true, bool check = true}) =>
      Bytes.fromUtf8(value);
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
  int get maxValueLength => kMaxValueLength;
  @override
  int get maxLength => kMaxLength;
  @override
  Trim get trim => kTrim;

  @override
  bool checkValue(String v, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(v, issues: issues, allowInvalid: allowInvalid);

  static const int kVRIndex = kLTIndex;
  static const int kVRCode = kLTCode;
  static const int kMaxVFLength = k8BitMaxLongVF;
  static const int kMaxLength = 1;
  static const int kMinValueLength = 0;
  static const int kMaxValueLength = 10240;
  static const String kVRKeyword = 'LT';
  static const String kVRName = 'Long Text';
  static const Type kType = LT;
  static const Trim kTrim = Trim.trailing;

  /// Returns _true_ if both [tag] and [vList] are valid for [LT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, LT);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [LT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, LT);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [LT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kVRIndex, LT);

  /// Returns _true_ if [vrIndex] is valid for [LT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex) =>
      VR.isValidIndex(vrIndex, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [LT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, kVRCode);

  /// Returns _true_ if [vfLength] is valid for [LT].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : inRange(vfLength, 0, kMaxVFLength);

  /// Returns _true_ if [vList].length is valid for [LT].
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, LT);
    if (vList == null) return nullValueError();
    return Element.isValidLength(tag, vList, issues, kMaxLength, LT);
  }

  /// Returns _true_ if [tag] has a VR of [LT] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, isValidValue, kMaxLength, LT);

  static bool isValidValueLength(String s, [Issues issues]) =>
      StringBase.isValidValueLength(
          s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    final ok = isDcmText(s, kMaxValueLength);
    return ok ? ok : invalidString('Invalid Long Text (LT): "$s"', issues);
  }
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
  int get maxValueLength => kMaxValueLength;
  @override
  int get maxLength => kMaxLength;
  @override
  Trim get trim => kTrim;

  @override
  bool checkValue(String v, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(v, issues: issues, allowInvalid: allowInvalid);

  static const int kVRIndex = kSTIndex;
  static const int kVRCode = kSTCode;
  static const int kMaxVFLength = k8BitMaxLongVF;
  static const int kMaxLength = 1;
  static const int kMinValueLength = 0;
  static const int kMaxValueLength = 1024;
  static const String kVRKeyword = 'ST';
  static const String kVRName = 'Short Text';
  static const Type kType = ST;
  static const Trim kTrim = Trim.trailing;

  /// Returns _true_ if both [tag] and [vList] are valid for [ST].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, ST);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [ST].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, ST);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [ST].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kVRIndex, ST);

  /// Returns _true_ if [vrIndex] is valid for [ST].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex) =>
      VR.isValidIndex(vrIndex, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [ST].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, kVRCode);

  /// Returns _true_ if [vfLength] is valid for [ST].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : inRange(vfLength, 0, kMaxVFLength);

  /// Returns _true_ if [vList].length is valid for [ST].
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, ST);
    if (vList == null) return nullValueError();
    return Element.isValidLength(tag, vList, issues, kMaxLength, ST);
  }

  /// Returns _true_ if [tag] has a VR of [ST] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, isValidValue, kMaxLength, ST);

  static bool isValidValueLength(String s, [Issues issues]) =>
      StringBase.isValidValueLength(
          s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    final ok = isDcmText(s, kMaxValueLength);
    return ok ? ok : invalidString('Invalid Short Test (ST): "$s"', issues);
  }
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
  int get maxValueLength => kMaxValueLength;
  @override
  int get maxLength => kMaxLength;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  Trim get trim => kTrim;

  Uri get uri => _uri ??= (values.length != 1) ? null : Uri.parse(values.first);
  Uri _uri;

  @override
  bool checkValue(String v, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(v, issues: issues, allowInvalid: allowInvalid);

  static const int kVRIndex = kURIndex;
  static const int kVRCode = kURCode;
  static const String kVRKeyword = 'UR';
  static const String kVRName =
      'Universal Resource Identifier or Universal Resource Locator (URI/URL)';
  static const int kMaxVFLength = k8BitMaxLongVF;
  static const int kMaxLength = 1;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = k8BitMaxLongVF;
  static const Type kType = UR;
  static const Trim kTrim = Trim.none;

  /// Returns _true_ if both [tag] and [vList] are valid for [UR].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UR);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [UR].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UR);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [UR].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kVRIndex, UR);

  /// Returns _true_ if [vrIndex] is valid for [UR].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex) =>
      VR.isValidIndex(vrIndex, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [UR].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, kVRCode);

  /// Returns _true_ if [vfLength] is valid for [UR].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : inRange(vfLength, 0, kMaxVFLength);

  /// Returns _true_ if [vList].length is valid for [UR].
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UR);
    if (vList == null) return nullValueError();
    return Element.isValidLength(tag, vList, issues, kMaxLength, UR);
  }

  /// Returns _true_ if [tag] has a VR of [UR] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, isValidValue, kMaxLength, UR);

  static bool isValidValueLength(String s, [Issues issues]) =>
      StringBase.isValidValueLength(
          s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    try {
      if (s.startsWith(' ')) throw const FormatException();
      Uri.parse(s);
    } on FormatException {
      return invalidString('Invalid URI String (UR): "$s"', issues);
    }
    return true;
  }

  static Uri parse(String s,
      {int start = 0, int end, Issues issues, Uri Function(String) onError}) {
    final uri = tryParse(s, start: start, end: end, issues: issues);
    if (uri == null) {
      if (onError != null) return onError(s);
      throw FormatException('Invalid Uri: "$s"');
    }
    return uri;
  }

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
  int get maxValueLength => kMaxValueLength;
  @override
  int get maxLength => kMaxLength;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  Trim get trim => kTrim;

  @override
  bool checkValue(String v, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(v, issues: issues, allowInvalid: allowInvalid);

  static const int kVRIndex = kUTIndex;
  static const int kVRCode = kUTCode;
  static const int kMaxVFLength = k8BitMaxLongVF;
  static const int kMaxLength = 1;
  static const int kMinValueLength = 0;
  static const int kMaxValueLength = k8BitMaxLongVF;
  static const String kVRKeyword = 'UT';
  static const String kVRName = 'Unlimited Text';
  static const Type kType = UT;
  static const Trim kTrim = Trim.trailing;

  /// Returns _true_ if both [tag] and [vList] are valid for [UT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UT);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [UT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UT);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [UT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kVRIndex, UT);

  /// Returns _true_ if [vrIndex] is valid for [UT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex) =>
      VR.isValidIndex(vrIndex, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [UT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, kVRCode);

  /// Returns _true_ if [vfLength] is valid for [UT].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : inRange(vfLength, 0, kMaxVFLength);

  /// Returns _true_ if [vList].length is valid for [UT].
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UT);
    if (vList == null) return nullValueError();
    return Element.isValidLength(tag, vList, issues, kMaxLength, UT);
  }

  /// Returns _true_ if [tag] has a VR of [UT] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, isValidValue, kMaxLength, UT);

  static bool isValidValueLength(String s, [Issues issues]) =>
      StringBase.isValidValueLength(
          s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    final ok = isDcmText(s, kMaxLongVF);
    return ok ? ok : invalidString('Invalid Unlimited Text (UT): "$s"', issues);
  }
}
