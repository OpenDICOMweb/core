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

abstract class Utf8 extends StringBase {
  @override
  StringList get values;
  @override
  bool get isAsciiRequired => false;
  @override
  bool get isSingleValued => false;

  Bytes get asBytes => Bytes.fromUtf8List(values, maxVFLength);

  List<String> valuesFromBytes(Bytes bytes) =>
      bytes.getUtf8List(allowMalformed: global.allowMalformedUtf8);

  static const bool kIsAsciiRequired = false;
  static const Trim kTrim = Trim.both;

  static List<String> fromValueField(Iterable vf, int maxVFLength,
      {bool isAscii = true}) {
    if (vf == null) return kEmptyStringList;
    if (vf is List<String> || vf.isEmpty || vf is StringBulkdata) return vf;
    if (vf is Bytes) return vf.getUtf8List();
    if (vf is Uint8List)
      return stringListFromTypedData(vf, maxVFLength, isAscii: true);
    return badValues(vf);
  }

  Utf8 append(String s) => update(values.append(s, maxValueLength));

  Utf8 prepend(String s) => update(values.prepend(s, maxValueLength));

  Utf8 truncate(int length) => update(values.truncate(length, maxValueLength));

  bool match(String regexp) => values.match(regexp);
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
  int get maxValueLength => kMaxValueLength;
  @override
  int get maxLength => kMaxLength;

  @override
  bool checkValue(String v, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(v, issues: issues, allowInvalid: allowInvalid);

  static const int kVRIndex = kLOIndex;
  static const int kVRCode = kLOCode;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 64;
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const int kMaxLength = k8BitMaxShortVF ~/ (kMinValueLength + 1);
  static const String kVRKeyword = 'LO';
  static const String kVRName = 'Long String';
  static const Type kType = LO;
  static const Trim kTrim = Trim.both;

  /// Returns _true_ if both [tag] and [vList] are valid for [LO].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, LO);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [LO].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, LO);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [LO].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kVRIndex, LO);

  /// Returns _true_ if [vrIndex] is valid for [LO].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [LO].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kVRCode);

  /// Returns _true_ if [vfLength] is valid for [LO].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : inRange(vfLength, 0, kMaxVFLength);

  /// Returns _true_ if [vList].length is valid for [LO].
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, LO);
    if (vList == null) return nullValueError();
    return Element.isValidLength(tag, vList, issues, kMaxLength, LO);
  }

  /// Returns _true_ if [tag] has a VR of [LO] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, isValidValue, kMaxLength, LO);

  static bool isValidValueLength(String s, [Issues issues]) =>
      StringBase.isValidValueLength(
          s, issues, kMinValueLength, kMaxValueLength);

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    final ok = isDcmString(s, 64);
    return ok ? ok : invalidString('Invalid Long String (LO): "$s"', issues);
  }
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
    if (isPCCode(code)) {
      final tag = Tag.lookupByCode(code, kLOIndex, token);
      return tag;
    }
    return invalidKey(code, 'Invalid Tag Code ${toDcm(code)}');
  }

  static const String kVRKeyword = 'PC';
  static const String kVRName = 'Private Creator';
  static const Type kType = PC;
  static const Trim kTrim = Trim.both;

  /// Returns _true_ if both [tag] and [vList] are valid for [LO].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, LO);
    if (!doTestElementValidity) return true;
    return vList != null &&
        (tag is PCTag) &&
        LO.isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [LO].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, LO);
    if (!doTestElementValidity) return true;
    return vfBytes != null && (tag is PCTag) && vfBytes.length <= 64;
  }
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
  int get maxValueLength => kMaxValueLength;
  @override
  int get maxLength => kMaxLength;

  List<PersonName> get names => _names ??= values.map(PersonName.parse);
  List<PersonName> _names;

  @override
  PN get hash => throw UnimplementedError();

  String get initials {
    if (values.isNotEmpty)
      throw UnimplementedError('Unimplemented for multiple PersonNames');
    return _names[0].initials;
  }

  @override
  bool checkValue(String v, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(v, issues: issues, allowInvalid: allowInvalid);

  static const int kVRIndex = kPNIndex;
  static const int kVRCode = kPNCode;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 3 * 64;
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const int kMaxLength = k8BitMaxShortVF ~/ (kMinValueLength + 1);
  static const String kVRKeyword = 'PN';
  static const String kVRName = 'Person Name';
  static const Type kType = PN;
  static const Trim kTrim = Trim.trailing;

  /// Returns _true_ if both [tag] and [vList] are valid for [PN].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, PN);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [PN].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, PN);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [PN].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kVRIndex, PN);

  /// Returns _true_ if [vrIndex] is valid for [PN].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [PN].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kVRCode);

  /// Returns _true_ if [vfLength] is valid for [PN].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : inRange(vfLength, 0, kMaxVFLength);

  /// Returns _true_ if [vList].length is valid for [PN].
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, PN);
    if (vList == null) return nullValueError();
    return Element.isValidLength(tag, vList, issues, kMaxLength, PN);
  }

  /// Returns _true_ if [tag] has a VR of [PN] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, isValidValue, kMaxLength, PN);

  static bool isValidValueLength(String s, [Issues issues]) =>
      StringBase.isValidValueLength(
          s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    if (isDcmString(s, 5 * 64)) return true;
    return invalidString('Invalid Person Name String (PN): "$s"', issues);
  }
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
  int get maxValueLength => kMaxValueLength;
  @override
  int get maxLength => kMaxLength;

  @override
  bool checkValue(String v, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(v, issues: issues, allowInvalid: allowInvalid);

  static const bool kIsAsciiRequired = false;
  static const int kVRIndex = kSHIndex;
  static const int kVRCode = kSHCode;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 16;
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const int kMaxLength = k8BitMaxShortVF ~/ (kMinValueLength + 1);
  static const String kVRKeyword = 'SH';
  static const String kVRName = 'Short String';
  static const Type kType = SH;
  static const Trim kTrim = Trim.both;

  /// Returns _true_ if both [tag] and [vList] are valid for [SH].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, SH);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [SH].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, SH);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [SH].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kVRIndex, SH);

  /// Returns _true_ if [vrIndex] is valid for [SH].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [SH].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kVRCode);

  /// Returns _true_ if [vfLength] is valid for [SH].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : inRange(vfLength, 0, kMaxVFLength);

  /// Returns _true_ if [vList].length is valid for [SH].
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, SH);
    if (vList == null) return nullValueError();
    return Element.isValidLength(tag, vList, issues, kMaxLength, SH);
  }

  /// Returns _true_ if [tag] has a VR of [SH] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, isValidValue, kMaxLength, SH);

  static bool isValidValueLength(String s, [Issues issues]) =>
      StringBase.isValidValueLength(
          s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  //Urgent jim: create is valid value internal routine
  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    if (isDcmString(s, kMaxValueLength)) return true;
    return invalidString('Invalid Short String (SH): "$s"', issues);
  }
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
  int get maxValueLength => kMaxValueLength;
  @override
  int get maxLength => kMaxLength;
  @override
  int get maxVFLength => kMaxVFLength;
  @override
  int get vlfSize => 4;

  @override
  bool checkValue(String v, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(v, issues: issues, allowInvalid: allowInvalid);

  static const bool kIsAsciiRequired = false;
  static const int kVRIndex = kUCIndex;
  static const int kVRCode = kUCCode;
  static const int kMaxVFLength = k8BitMaxLongVF;
  static const int kMaxLength = k8BitMaxLongVF ~/ (kMinValueLength + 1);
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = kMaxLongVF;
  static const String kVRKeyword = 'UC';
  static const String kVRName = 'Unlimited Characters';
  static const Type kType = UC;
  static const Trim kTrim = Trim.trailing;
  static const Trim kComponentTrim = Trim.both;

  /// Returns _true_ if both [tag] and [vList] are valid for [UC].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UC);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [UC].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UC);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [UC].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kVRIndex, UC);

  /// Returns _true_ if [vrIndex] is valid for [UC].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex, [Issues issues]) =>
      VR.isValidIndex(vrIndex, issues, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [UC].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode, [Issues issues]) =>
      VR.isValidCode(vrCode, issues, kVRCode);

  /// Returns _true_ if [vfLength] is valid for [UC].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : inRange(vfLength, 0, kMaxVFLength);

  /// Returns _true_ if [vList].length is valid for [UC].
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UC);
    if (vList == null) return nullValueError();
    return Element.isValidLength(tag, vList, issues, kMaxLength, UC);
  }

  /// Returns _true_ if [tag] has a VR of [UC] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, isValidValue, kMaxLength, UC);

  static bool isValidValueLength(String s, [Issues issues]) =>
      StringBase.isValidValueLength(
          s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    if (isDcmString(s, kMaxLongVF)) return true;
    return invalidString(
        'Invalid Unlimited Characters String (UC): "$s"', issues);
  }
}
