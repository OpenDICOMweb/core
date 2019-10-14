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

// Note: Each [String] in a Value Field must be separated by a backslash ('\)
//       character. Thus, the minimum length of each string in a Value
//       Field is 2, unless it is empty.
abstract class AsciiString extends StringBase {
  @override
  StringList get values;
  // **** End of Interface

  @override
  bool get isAsciiRequired => true;
  @override
  bool get isSingleValued => false;

// Urgent
//  Bytes get asBytes => BytesDicom.fromAscii(values.asString, maxVFLength);
  Bytes get asBytes => BytesDicom.fromAscii(values.join('\\'), maxVFLength);

  @override
  TypedData get typedData =>
      stringListToUint8List(values, maxLength: maxVFLength, isAscii: true);

  @override
  Uint8List get bulkdata => typedData;

  List<String> valuesFromBytes(Bytes bytes) => bytes.getAscii().split('\\');

  AsciiString append(String s) => update(values.append(s, maxValueLength));

  AsciiString prepend(String s) => update(values.prepend(s, maxValueLength));

  AsciiString truncate(int length) =>
      update(values.truncate(length, maxValueLength));

  bool match(String regexp) => values.match(regexp);

  // TODO: this is almost the same as Utf8.fromValueField - merge
  static List<String> fromValueField(List vf, int maxVFLength,
      {bool isAscii = true}) {
    if (vf == null) return kEmptyStringList;
    if (vf is List<String> || vf.isEmpty || vf is StringBulkdata) return vf;
    if (vf is Bytes) return vf.getUtf8().split('\\');
    if (vf is Uint8List)
      return stringListFromTypedData(vf, maxVFLength, isAscii: true);
    return badValues(vf);
  }

  /// Returns a [Bytes] created from [vList];
  static Bytes toBytes(Iterable<String> vList,
          {bool asView = true, bool check = true}) =>
      Bytes.fromAsciiList(vList);
}

/// A Application Entity Title ([AE]) Element
abstract class AE extends AsciiString {
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

  static const int kVRIndex = kAEIndex;
  static const int kVRCode = kAECode;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 16;
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const int kMaxLength = k8BitMaxShortVF ~/ (kMinValueLength + 1);
  static const String kVRName = 'Application Entity';
  static const String kVRKeyword = 'AE';
  static const Trim kTrim = Trim.both;
  static const Type kType = AE;

  /// Returns _true_ if both [tag] and [vList] are valid for [AE].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, AE);
    if (!doTestElementValidity) return true;
    return vList != null && isValidTag(tag) && isValidValues(tag, vList);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [AE].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, AE);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [AE].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kVRIndex, AE);

  /// Returns _true_ if [vrIndex] is valid for [AE].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex) =>
      VR.isValidIndex(vrIndex, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [AE].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode) =>
      VR.isValidCode(vrCode, kVRCode);

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

  static bool isValidValueLength(String s, [Issues issues]) =>
      StringBase.isValidValueLength(
          s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  /// Returns _true_ if [s] is a valid Application Entity Title ([AE])
  /// [String].
  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    final ok = isDcmString(s, 16, allowLeading: true);
    return ok ? ok : invalidString('Invalid AETitle String (AE): "$s"', issues);
  }
}

/// A Code String ([CS]) Element
abstract class CS extends AsciiString {
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

  // TODO: Valid? Needed? What is the difference with empty versus blank.
  /// Returns a new [CS] [Element] containing only spaces.
  CS spaces([int n = 1]) => update([''.padRight(n)]);

  static const int kVRIndex = kCSIndex;
  static const int kVRCode = kCSCode;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 16;
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const int kMaxLength = k8BitMaxShortVF ~/ (kMinValueLength + 1);
  static const String kVRKeyword = 'CS';
  static const String kVRName = 'Code String';
  static const Type kType = CS;
  static const Trim kTrim = Trim.both;

  /// Returns _true_ if both [tag] and [vList] are valid for [CS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, CS);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [CS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, CS);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [CS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kVRIndex, CS);

  /// Returns _true_ if [vrIndex] is valid for [CS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex) =>
      VR.isValidIndex(vrIndex, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [CS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode) =>
      VR.isValidCode(vrCode, kVRCode);

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

  static bool isValidValueLength(String s, [Issues issues]) =>
      StringBase.isValidValueLength(
          s.trim(), issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    if (s.isEmpty) {
      log.warn('Empty Code String');
      return true;
    }
    final ok = isFilteredString(s, 0, kMaxValueLength, isCSChar,
        allowLeadingSpaces: true, allowTrailingSpaces: true);
    return ok ? ok : invalidString('Invalid Code String (CS): "$s"');
  }
}

abstract class UI extends AsciiString {
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
  int get padChar => kNull;
  @override
  Trim get trim => kTrim;

  List<Uid> get uids => _uids ??= Uid.parseList(values);
  set uids(Iterable<Uid> uList) => _uids = uList;
  List<Uid> _uids;

  Uid get uid => (_uids.length == 1) ? _uids[0] : null;

  // UI does not support [hash].
  @override
  UI get hash => unsupportedError('UIDs cannot currently be hashed');

  // UI does not support [sha256].
  @override
  UI get sha256 => sha256Unsupported(this);

  @override
  bool checkValue(String v, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(v, issues: issues, allowInvalid: allowInvalid);

  UI updateUid(Iterable<Uid> uidList) => update(toStringList(uidList));

  UI updateUidF(Iterable<Uid> Function(Iterable<String>) f) =>
      updateUid(f(values));

  Iterable<Uid> replaceUid(Iterable<Uid> vList) => _replaceUid(vList);

  Iterable<Uid> replaceUidF(Iterable<Uid> Function(Iterable<Uid>) f) =>
      _replaceUid(f(uids) ?? Uid.kEmptyList);

  Iterable<Uid> _replaceUid(Iterable<Uid> uidList) {
    final old = uids;
    _uids = null;
    values = toStringList(uidList);
    return old;
  }

  static const int kVRIndex = kUIIndex;
  static const int kVRCode = kUICode;
  //Urgent: what is the correct kMinValueLength
  static const int kMinValueLength = 6;
  static const int kMaxValueLength = 64;
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const int kMaxLength = k8BitMaxShortVF ~/ (kMinValueLength + 1);
  static const String kVRKeyword = 'UI';
  static const String kVRName = 'Unique Identifier (UID)';
  static const Type kType = UI;
  static const Trim kTrim = Trim.none;

  /// Returns _true_ if both [tag] and [vList] are valid for [UI].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UI);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [UI].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UI);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [UI].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kVRIndex, UI);

  /// Returns _true_ if [vrIndex] is valid for [UI].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRIndex(int vrIndex) =>
      VR.isValidIndex(vrIndex, kVRIndex);

  /// Returns _true_ if [vrCode] is valid for [UI].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidVRCode(int vrCode) =>
      VR.isValidCode(vrCode, kVRCode);

  /// Returns _true_ if [vfLength] is valid for [UI].
  static bool isValidVFLength(int vfLength, [Issues issues, Tag tag]) =>
      (tag != null)
          ? tag.isValidVFLength(vfLength, issues)
          : inRange(vfLength, 0, k8BitMaxShortVF);

  /// Returns _true_ if [vList].length is valid for [UI].
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, UI);
    if (vList == null) return nullValueError();
    final ok = Element.isValidLength(tag, vList, issues, kMaxLength, UI);
    return ok ? ok : invalidValuesLength(vList, 0, kMaxLength, issues);
  }

  /// Returns _true_ if [tag] has a VR of [UI] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      _isValidValues(tag, vList, issues, isValidValue, kMaxLength, UI);

  static bool isValidValueLength(String s, [Issues issues]) =>
      StringBase.isValidValueLength(
          s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    if (s.isEmpty) return true;
    final ok = Uid.isValidString(s);
    return ok
        ? ok
        : invalidString('Invalid Unique Identifier String (UI): "$s"', issues);
  }

  /// Returns _true_ if both [tag] is valid for [UI].
  /// [Uid]s are guaranteed to be valid.
  static bool isValidUidArgs(Tag tag, Iterable<Uid> vList, [Issues issues]) =>
      isValidTagAux(tag, issues, kUIIndex, UI);

  static List<String> toStringList(Iterable<Uid> uids) {
    final sList = List<String>(uids.length);
    for (var i = 0; i < sList.length; i++)
      sList[i] = uids.elementAt(i).toString();
    return sList;
  }

  static Uid tryParse(String s, [Issues issues]) => Uid.parse(s);

  static List<Uid> parseList(List<String> vList) {
    final uids = List<Uid>(vList.length);
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
