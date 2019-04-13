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

/// DICOM Age (AS) Value Representation
abstract class AS extends AsciiString {
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
  bool get isSingleValued => true;
  @override
  Trim get trim => kTrim;

  @override
  // ignore: hash_and_equals
  int get hashCode {
    if (values.isEmpty) return 0;
    return (values.length == 1 && Age.isValidString(values[0]))
        ? global.hash(age.nDays)
        : badValues(values);
  }

  /// A fixed size List of [Date] values. They are created lazily.
  List<Age> get ages => _ages ??= values.map(Age.parse).toList();
  List<Age> _ages;

  Age get age => (ages.length == 1) ? ages[0] : invalidValues(values);

  @override
  AS get sha256 =>
      (values.isEmpty) ? this : update([sha256AgeAsString(age.nDays)]);

  AS get acrHash => update(const <String>['089Y']);

  @override
  AS get hash => (values.isEmpty) ? this : update([age.hashString]);

  @override
  bool checkValue(String v, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(v, issues: issues, allowInvalid: allowInvalid);

  static const int kVRIndex = kASIndex;
  static const int kVRCode = kASCode;
  static const int kMinValueLength = 4;
  static const int kMaxValueLength = 4;
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const int kMaxLength = k8BitMaxShortVF ~/ (kMinValueLength + 1);
  static const String kVRName = 'Age String';
  static const String kVRKeyword = 'AS';
  static const Type kType = AS;
  static const Trim kTrim = Trim.none;

  /// Special variable for overriding uppercase constraint.
  static bool allowLowerCase = false;

  /// Returns _true_ if both [tag] and [vList] are valid for [AS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, AS);
    if (!doTestElementValidity) return true;
    return vList != null && isValidTag(tag) && isValidValues(tag, vList);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [AS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, AS);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [AS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kVRIndex, AS);

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

  static bool isValidValueLength(String s, [Issues issues]) =>
      StringBase.isValidValueLength(
          s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    final ok = Age.isValidString(s, issues);
    return ok ? ok : invalidAgeString('Invalid Age String (AS): "$s"', issues);
  }

  static Age tryParse(String s, {bool allowLowerCase = false}) =>
      Age.tryParse(s, allowLowercase: false);

  static int tryParseString(String s, {bool allowLowerCase = false}) =>
      Age.tryParseString(s, allowLowercase: false);
}

// **** Date/Time Elements

/// An abstract class for date ([DA]) [Element]s.
abstract class DA extends AsciiString {
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

  /// A fixed size List of [Date] values. They are created lazily.
  List<Date> get dates => _dates ??= values.map(Date.parse).toList();
  List<Date> _dates;

  Date get date =>
      (dates.length == 1) ? dates.first : badValues(values, null, tag);

  @override
  DA get hash {
    final dList = <String>[];
    for (final date in dates) {
      final h = date.hash;
      dList.add(h.dcm);
    }
    return update(dList);
  }

  @override
  DA get sha256 => unsupportedError();

  /// Returns a new [DA] [Element] that is created by adding the
  /// integer [days] to each element of [values].
  Element increment([int days = 1]) {
    final result = List<Date>(dates.length);
    for (var i = 0; i < dates.length; i++) {
      final day = dates[i].epochDay + days;
      result[i] = Date.fromEpochDay(day);
    }
    return update(result.map((v) => '${v.dcm}'));
  }

  /// Returns a new [DA] [Element] that is created by subtracting [date]
  /// from each element of [dates].
  Element difference(Date date) {
    final result = List<Date>(length);
    for (var i = 0; i < dates.length; i++) {
      final day = dates[i].epochDay - date.epochDay;
      result[i] = Date.fromEpochDay(day);
    }
    return update(result.map((v) => '${v.dcm}'));
  }

  DA normalize(Date enrollment) {
    final vList = Date.normalizeStrings(values, enrollment);
    return update(vList);
  }

  @override
  bool checkValue(String v, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(v, issues: issues, allowInvalid: allowInvalid);

  void clearDates() {
    _dates = null;
    return;
  }

  static const int kVRIndex = kDAIndex;
  static const int kVRCode = kDACode;
  static const int kMinValueLength = 8;
  static const int kMaxValueLength = 8;
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const int kMaxLength = k8BitMaxShortVF ~/ (kMinValueLength + 1);
  static const String kVRKeyword = 'DA';
  static const String kVRName = 'Date';
  static const Type kType = DA;
  static const Trim kTrim = Trim.none;
  static bool allowLowerCase = false;

  /// Returns _true_ if both [tag] and [vList] are valid for [DA].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, DA);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [DA].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, DA);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [DA].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kVRIndex, DA);

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

  static bool isValidValueLength(String s, [Issues issues]) =>
      StringBase.isValidValueLength(
          s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    if (s.isEmpty || allowBlankDates && s.trim().isEmpty) return true;
    final ok = Date.isValidString(s, issues: issues);
    return ok ? ok : invalidString('Invalid Date String (DA): "$s"', issues);
  }
}

/// An abstract class for time ([TM]) [Element]s.
abstract class DT extends AsciiString {
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

  List<DcmDateTime> get dateTimes =>
      _dateTimes ??= values.map(DcmDateTime.parse).toList();
  List<DcmDateTime> _dateTimes;

  DcmDateTime get dateTime =>
      (dateTimes.length == 1) ? dateTimes.first : badValues(values, null, tag);

  @override
  DT get hash {
    final dList = List<String>(dateTimes.length);
    for (var i = 0; i < dateTimes.length; i++)
      dList[i] = dList[i].hashCode.toString();
    return update(dList);
  }

  @override
  DT get sha256 => unsupportedError();

  @override
  bool checkValue(String v, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(v, issues: issues, allowInvalid: allowInvalid);

  void clearDcmDateTimes() {
    _dateTimes = null;
    return;
  }

  static const int kVRIndex = kDTIndex;
  static const int kVRCode = kDTCode;
  static const int kMinValueLength = 4;
  static const int kMaxValueLength = 26;
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const int kMaxLength = k8BitMaxShortVF ~/ (kMinValueLength + 1);
  static const String kVRKeyword = 'DT';
  static const String kVRName = 'Date Time';
  static const Type kType = DT;
  static const Trim kTrim = Trim.trailing;
  static bool allowLowerCase = false;

  /// Returns _true_ if both [tag] and [vList] are valid for [DT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, DT);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [DT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, DT);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [DT].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kVRIndex, DT);

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

  static bool isValidValueLength(String s, [Issues issues]) =>
      StringBase.isValidValueLength(
          s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    final s0 = s.trimRight();
    if (s0.isEmpty) return true;
    final ok = DcmDateTime.isValidString(s0, issues: issues);
    return ok ? ok : invalidString('Invalid Date Time (DT): "$s0"', issues);
  }
}

/// An abstract class for time ([TM]) [Element]s.
///
/// [Time] [String]s have the following format: HHMMSS.ffffff.
/// [See PS3.18, TM](http://dicom.nema.org/medical/dicom/current/output/
/// html/part18.html#para_3f950ae4-871c-48c5-b200-6bccf821653b)
abstract class TM extends AsciiString {
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

  List<Time> get times => _times ??= values.map(Time.parse).toList();
  List<Time> _times;

  Time get time =>
      (times.length == 1) ? times.first : badValues(values, null, tag);

  @override
  TM get hash {
    final dList = List<String>(times.length);
    for (var i = 0; i < times.length; i++)
      dList[i] = dList[i].hashCode.toString();
    return update(dList);
  }

  @override
  TM get sha256 => unsupportedError();

  @override
  bool checkValue(String v, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(v, issues: issues, allowInvalid: allowInvalid);

  void clearTimes() {
    _times = null;
    return;
  }

  static const int kVRIndex = kTMIndex;
  static const int kVRCode = kTMCode;
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const int kMaxLength = k8BitMaxShortVF ~/ (kMinValueLength + 1);
  static const int kMinValueLength = 2;
  static const int kMaxValueLength = 13;
  static const String kVRName = 'Time';
  static const String kVRKeyword = 'TM';
  static const Type kType = TM;
  static const Trim kTrim = Trim.trailing;
  static bool allowLowerCase = false;

  /// Returns _true_ if both [tag] and [vList] are valid for [TM].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, TM);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag) &&
        isValidValues(tag, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [TM].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, TM);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [TM].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kVRIndex, TM);

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

  static bool isValidValueLength(String s, [Issues issues]) =>
      StringBase.isValidValueLength(
          s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    // Note: isNotValidValueLength checks for null
    if (s == null || !isValidValueLength(s, issues)) return false;
    final s0 = s.trimRight();
    if (s0.isEmpty) return true;
    final ok = Time.isValidString(s0, issues: issues);
    return ok ? ok : invalidString('Invalid Time String (TM): "$s0"', issues);
  }
}
