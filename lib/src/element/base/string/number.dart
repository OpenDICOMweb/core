//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.element.base.string;

// TODO: For each class add the following static fields:
//       bool areLeadingSpacesAllowed = x;
//       bool areLeadingSpacesSignificant = x;
//       bool areTrailingSpacesAllowed = x;
//       bool areTrailingSpacesSignificant = x;
//       bool areEmbeddedSpacesAllowed = x;
//       bool areAllSpacesAllowed = x;
//       bool isEmptyStringAllowed = x;

abstract class DS extends StringAscii {
  static const int kVRIndex = kDSIndex;
  static const int kVRCode = kDSCode;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 16;
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const int kMaxLength = k8BitMaxShortVF ~/ (kMinValueLength + 1);

  static const String kVRKeyword = 'DS';
  static const String kVRName = 'Decimal String';

  static const Type kType = DS;

  static const Trim kTrim = Trim.both;

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
  Trim get trim => kTrim;

  List<num> get numbers => _numbers ??= tryParseList(values);
  List<num> _numbers;

  // Urgent Sharath unit test
  /// Returns -1, 0, or 1 if [n] is less than, equal to, or greater than
  /// [value]. If [values].length is not equal to 1 returns _null_.
  int compare(num n) {
    final len = numbers.length;
    if (len == 0 || len > 1) return null;
    final v = numbers[0];
    if (v == n) return 0;
    return (n < v) ? -1 : 1;
  }

  // Urgent Sharath unit test
  /// Returns a [Element] that is created by adding n to each
  /// element of [numbers].
  Element increment([num n = 1.0]) {
    final result = new List<num>(length);
    for (var i = 0; i < numbers.length; i++) result[i] = numbers[i] + n;
    return update(result.map((v) => '$v'));
  }

  // Urgent Sharath unit test
  /// Returns a [Element] that is created by subtracting n from each
  /// element of [numbers].
  Element decrement([num n = 1.0]) {
    final result = new List<num>(length);
    for (var i = 0; i < numbers.length; i++) result[i] = numbers[i] - n;
    return update(result.map((v) => '$v'));
  }

  /// Returns a new [DS] [Element] with a random list of [values] with
  /// the same [length] as _this_.
  DS get random {
    if (length == 0) return this;
    final dList = new List<num>(length);
    for (var i = 0; i < length; i++) dList[i] = Global.rng.nextDouble();
    final vList = dList.map(numToString);
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
        Sha256.numbers(numbers).map(numToString).toList(growable: false);
    return update((vmMax == -1 || vmMax > 8) ? hList : hList.sublist(0, vmMax));
  }

  @override
  bool checkValue(String s, {Issues issues, bool allowInvalid = false}) =>
      isValidValue(s, issues: issues, allowInvalid: allowInvalid);

  // **** Generalized static methods

  /// Returns _true_ if both [tag] and [vList] are valid for [DS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, DS);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag) &&
        StringBase.isValidValues(
            tag, vList, issues, isValidValue, kMaxLength, DS);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [DS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (!doTestElementValidity) return true;
    if (tag == null) return invalidTag(tag, null, DS);
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [DS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kVRIndex, DS);

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
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, DS);
    if (vList == null) return nullValueError();
    return Element.isValidLength(tag, vList, issues, kMaxLength, DS);
  }

  /// Returns _true_ if [tag] has a VR of [DS] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      StringBase.isValidValues(
          tag, vList, issues, isValidValue, kMaxLength, DS);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  /// Returns _true_ if [s] is a valid Decimal [String] ([DS])
  /// [String].
  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    if (s.isEmpty) return true;
    final n = tryParse(s);
    return (n != null)
        ? true
        : invalidString('Invalid Decimal (DS) String: "$s"');
  }

  //TODO: Sharath add tests with leading and trailing spaces,
  // and all spaces (blank).
  /// Parse a [DS] [String]. Leading and trailing spaces allowed,
  /// but all spaces is illegal.
  static num tryParse(String s, [Issues issues]) {
    if (s == null ||
        !isValidValueLength(s, issues) ||
        notInRange(s.length, kMinValueLength, kMaxValueLength))
      return _badDS(s, issues);
    // Remove leading and training spaces
    final s0 = s.trim();
    if (s.isEmpty) return 0.0;
    final v = num.tryParse(s0);
    return (v == null) ? _badDS(s, issues) : v;
  }

  static Null _badDS(String s, Issues issues) {
    final msg = 'Invalid Decimal String (DS): "$s"';
    return badString(msg, issues);
  }

  static Iterable<num> tryParseList(Iterable<String> vList,
          [Issues issues]) =>
      StringBase.reallyTryParseList(vList, issues, tryParse);

  static List<num> tryParseBytes(Bytes vfBytes) =>
      tryParseList(vfBytes.getAsciiList());

  static Iterable<String> validateValueField(Bytes vfBytes) =>
      vfBytes.getAsciiList();
}

abstract class IS extends StringAscii {
  static const int kVRIndex = kISIndex;
  static const int kVRCode = kISCode;
  static const int kMinValueLength = 1;
  static const int kMaxValueLength = 12;
  static const int kMaxVFLength = k8BitMaxShortVF;
  static const int kMaxLength = k8BitMaxShortVF ~/ (kMinValueLength + 1);
  static const int kMinValue = -99999999999;
  static const int kMaxValue = 999999999999;

  static const String kVRKeyword = 'IS';
  static const String kVRName = 'Integer String';

  static const Type kType = TM;

  static const Trim kTrim = Trim.both;

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
  Trim get trim => kTrim;

  List<int> get integers => _integers ??= tryParseList(values);
  List<int> _integers;

  // Urgent Sharath unit test
  /// Returns -1, 0, or 1 if [n] is less than, equal to, or greater than
  /// [value]. If [values].length is not equal to 1 returns _null_.
  int compare(int n) {
    final len = integers.length;
    if (len == 0 || len > 1) return null;
    final v = integers[0];
    if (v == n) return 0;
    return (n < v) ? -1 : 1;
  }

  // Urgent Sharath unit test
  /// Returns a List<int> that is created by adding n to each element of
  /// [integers].
  Element increment([int n = 1]) {
    final result = new List<int>(length);
    for (var i = 0; i < integers.length; i++) result[i] = integers[i] + n;
    return update(result.map((v) => '$v'));
  }

  // Urgent Sharath unit test
  /// Returns a List<int> that is created by subtracting n from each element of
  /// [integers].
  Element decrement([int n = 1]) {
    final result = new List<int>(length);
    for (var i = 0; i < integers.length; i++) result[i] = integers[i] - n;
    return update(result.map((v) => '$v'));
  }

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
      sList[i] = s;
    }
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

  // **** Generalized static methods

  /// Returns _true_ if both [tag] and [vList] are valid for [IS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, IS);
    if (!doTestElementValidity) return true;
    return vList != null &&
        isValidTag(tag) &&
        StringBase.isValidValues(
            tag, vList, issues, isValidValue, kMaxLength, IS);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [IS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidBytesArgs(Tag tag, Bytes vfBytes, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, IS);
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        isValidTag(tag, issues) &&
        isValidVFLength(vfBytes.length, issues, tag);
  }

  /// Returns _true_ if [tag] is valid for [IS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidTag(Tag tag, [Issues issues]) =>
      isValidTagAux(tag, issues, kVRIndex, IS);

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
  static bool isValidLength(Tag tag, Iterable<String> vList, [Issues issues]) {
    if (tag == null) return invalidTag(tag, null, IS);
    if (vList == null) return nullValueError();
    return Element.isValidLength(tag, vList, issues, kMaxLength, IS);
  }

  /// Returns _true_ if [tag] has a VR of [IS] and [vList] is valid for [tag].
  static bool isValidValues(Tag tag, Iterable<String> vList, [Issues issues]) =>
      StringBase.isValidValues(
          tag, vList, issues, isValidValue, kMaxLength, IS);

  static bool isValidValueLength(String s, [Issues issues]) => StringBase
      .isValidValueLength(s, issues, kMinValueLength, kMaxValueLength);

  // **** Specialized static methods

  static bool isValidValue(String s,
      {Issues issues, bool allowInvalid = false}) {
    if (s == null || !isValidValueLength(s, issues)) return false;
    if (s.isEmpty) return true;
    final n = tryParse(s);
    return (n != null && inRange(n, kMinValue, kMaxValue))
        ? true
        : invalidString(s, issues);
  }

  /// Returns an [int] created by parsing [s]. If [s] is invalid
  /// returns _null_.
  ///
  /// Before [s] is parsed leading and trailing whitespace is removed.
  ///
  /// _Note_: Dart int.tryParse doesn't handle '+' sign.
  static int tryParse(String s, [Issues issues]) {
    if (s == null || !isValidValueLength(s, issues)) return _badIS(s, issues);
    var s0 = s.trim();
    if (s.isEmpty) return 0;
    s0 = (s[0] == '+') ? s.substring(1) : s;
    final n = int.tryParse(s0);
    if (n == null || notInRange(n, kMinValue, kMaxValue))
      return _badIS(s, issues);
    return n;
  }

  static int _badIS(String s, Issues issues) {
    final msg = 'Invalid Integer String (IS): "$s"';
    return badString(msg, issues);
  }

  static Iterable<int> tryParseList(Iterable<String> vList, [Issues issues]) =>
      StringBase.reallyTryParseList(vList, issues, tryParse);

  static List<int> tryParseBytes(Bytes vfBytes) =>
      tryParseList(vfBytes.getAsciiList());

  static Iterable<String> validateValueField(Bytes vfBytes) =>
      vfBytes.getAsciiList();
}
