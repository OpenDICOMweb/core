//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:convert' as cvt;
import 'dart:typed_data';

import 'package:core/src/utils/character/ascii.dart';

typedef Decoder = String Function(Uint8List list, {bool allowInvalid});

typedef Encoder = Uint8List Function(String s);

/// The base Charset is the ASCII (or US-ASCII) Character Set.
/// This is the base class for all character sets.
abstract class Charset {
  /// The name of the character set.
  String get name;

  /// Its primary language.
  String get language;

  /// Other names used to identify _this_.
  List<String> get identifiers;

  /// The minimum value.
  int get min;

  /// The maximum value.
  int get max;

  /// Returns _true_ is [c] is a valid code point for _this_.
  bool isValid(int c);

  /// Returns _true_ if [c] if [c] is a visible character.
  bool isVisible(int c);

  /// Returns _true_ if [c] is a space character.
  bool isSpace(int c) => c == kSpace;

  /// Returns _true_ if [c] is a backspace character.
  bool isBackspace(int c) => c == kBackspace;

  /// Returns _true_ is [c] is a whitespace character.
  bool isWhitespace(int c);

  /// Returns _true_ is [c] is a control character.
  bool isDigit(int c);

  /// Returns _true_ is [c] is a control character.
  bool isControl(int c);

  /// Returns _true_ if [c] is an escape character.
  bool isEscape(int c);

  /// Returns _true_ is [s] is a valid [String] for _this_.
  bool isValidString(String s, [int max]);

  /// Decode [list] into a [String].
  String decode(Uint8List list, {bool allowInvalid = true});

  /// Encode [s] into a [Uint8List].
  Uint8List encode(String s);

  /// Split [s] at Backslash.
  List<String> split(String s) => s.split('\\');

  /// Join all [String]s in [list] with backslash as separator.
  String join(List<String> list);

  /// Returns [s] without a trailing [kNull] character.
  String removeTrailingNull(String s);

  /// Constant definition of ASCII character set.
  static const Ascii ascii = Ascii(
      'ASCII-1', 'US English', ['ASCII', 'US-ASCII', 'ISO_IR 6', 'ISO/IEC 646']);

  /// Constant definition of [latin1] character set.
  static const Latin latin1 = Latin('Latin1', 'Western Europe',
      ['ISO-8859-1', 'ISO-IR 100', 'Latin1', 'Latin-1']);

  /// Constant definition of [latin2] character set.
  static const Latin latin2 = Latin('Latin2', 'Eastern Europe',
      ['ISO-8859-1', 'ISO-IR 101', 'Latin2', 'Latin-2']);

  /// Constant definition of [latin3] character set.
  static const Latin latin3 = Latin(
      'Latin3', 'Europe', ['ISO-8859-1', 'ISO-IR 109', 'Latin3', 'Latin-3']);

  /// Constant definition of [latin4] character set.
  static const Latin latin4 = Latin(
      'Latin4', 'Europe', ['ISO-8859-1', 'ISO-IR 110', 'Latin4', 'Latin-4']);

  /// Constant definition of [latin5] character set.
  static const Latin latin5 = Latin(
      'Latin5', 'Cyrillic', ['ISO-8859-1', 'ISO-IR 144', 'Latin5', 'Latin-5']);

  /// Constant definition of [latin6] character set.
  static const Latin latin6 = Latin(
      'Latin6', 'Arabic', ['ISO-8859-1', 'ISO-IR 127', 'Latin6', 'Latin-6']);

  /// Constant definition of [latin7] character set.
  static const Latin latin7 =
  Latin('Latin7', 'Greek', ['ISO-8859-7', 'ISO-IR 126', 'Latin7', 'Latin-7']);

  /// Constant definition of [latin8] character set.
  static const Latin latin8 = Latin(
      'Latin8', 'Hebrew', ['ISO-8859-8', 'ISO-IR 138', 'Latin8', 'Latin-8']);

  /// Constant definition of [latin9] character set.
  static const Latin latin9 = Latin('Latin9', 'Latin Alphabet 5',
      ['ISO-8859-9', 'ISO-IR 148', 'Latin9', 'Latin-9']);

  /// Constant definition of UTF8 character set.
  static const Utf8 utf8 = Utf8('UTF8', ['UTF8', 'ISO-IR 192', 'UTF-8']);

}

/// The base Charset is the ASCII (or US-ASCII) Character Set.
/// This is the base class for all character sets.
class Ascii implements Charset {
  @override
  final String name;

  @override
  final String language;

  @override
  final List<String> identifiers;

  /// Internal constant constructor.
  const Ascii(this.name, this.language, this.identifiers);

  @override
  int get min => kMin;

  @override
  int get max => kMax;

  @override
  bool isValid(int c) => c >= kMin && c <= kMax;

  /// Returns _true_ if [c] is in DICOM's Default Character Repertoire (DCR)
  /// without backspace (/);  otherwise _false_. Used for VRs of LO, PN, SH,
  /// and UC. Backslash(\) not allowed, as it is used as a values separator for
  /// these [String] types. The space character ([kSpace]) is visible.
  @override
  bool isVisible(int c) =>
      (c >= kSpace && c < kBackslash) || (c > kBackslash && c < kDelete);

  @override
  bool isSpace(int c) => c == kSpace;

  @override
  bool isBackspace(int c) => c == kBackspace;

  @override
  bool isWhitespace(int c) => c == kSpace || (c >= kBackspace && c <= kReturn);

  @override
  bool isDigit(int c) => c >= k0 && c < k9;

  @override
  bool isControl(int c) => c >= kNull && c < kSpace;

  @override
  bool isEscape(int c) => c == kEscape;

  @override
  bool isValidString(String s, [int max]) {
    for (var i = 0; i < s.length; i++)
      if (!isVisible(s.codeUnitAt(i))) return false;
    return true;
  }

  @override
  String decode(Uint8List list, {bool allowInvalid = true}) =>
      cvt.ascii.decode(list, allowInvalid: allowInvalid);

  @override
  Uint8List encode(String s) => cvt.ascii.encode(s);

  @override
  List<String> split(String s) => s.split('\\');

  @override
  String join(List<String> list) => list.join('\\');

  @override
  String removeTrailingNull(String s) {
    final last = s.length - 1;
    return (s.codeUnitAt(last) == kNull) ? s.substring(0, last) : s;
  }

  @override
  String toString() => name;

  /// The minimum character value.
  static const int kMin = 0;

  /// The maximum character value.
  static const int kMax = 127;
}

/// The Latin (ISO-8859-1) Character Sets.
class Latin extends Ascii {
  /// Constructor.
  const Latin(String name, String language, List<String> identifiers)
      : super(name, language, identifiers);

  @override
  int get min => kMin;
  @override
  int get max => kMax;

  @override
  bool isValid(int c) => c >= kMin && c <= kMax;

  @override
  bool isVisible(int c) => super.isVisible(c) || (c >= kNBSP && c <= kMax);

  @override
  bool isSpace(int c) => c == kSpace || c == kNBSP;

  @override
  bool isWhitespace(int c) =>
      c == kSpace || c == kNBSP || (c >= kBackspace && c <= kReturn);

  @override
  bool isControl(int c) => c >= kNull && c < kSpace || c >= 128 && c <= 159;

  /// Returns an ASCII decoder
// Decoder get decoder => cvt.latin1.decode;

  @override
  String decode(Uint8List list, {bool allowInvalid = true}) =>
      cvt.latin1.decode(list, allowInvalid: allowInvalid);

  /// Returns an ASCII encoder.
//  Encoder get encoder => cvt.latin1.encode;

  @override
  Uint8List encode(String s) => cvt.latin1.encode(s);

  /// Minimum valid value
  static const int kMin = 0;

  /// Maximum valid value
  static const int kMax = 255;

  /// Non-Breaking Backspace character used for accents, etc.
  static const int kNBSP = 160;

  /// Synonym for kNBSP.
  static const int kNonBreakingSpace = 160;
}

/// The Latin 1 (ISO-8859-1) Character Set.
class Utf8 extends Ascii {
  /// Constructor.
  const Utf8(String name, List<String> identifiers)
      : super(name, 'all', identifiers);

  @override
  int get min => kMin;
  @override
  int get max => kMax;
  @override
  List<String> get identifiers => ['Latin-1', 'ISO-8859-1'];

  @override
  bool isValid(int c) => c >= kMin && c <= kMax;

  @override
  bool isVisible(int c) => super.isVisible(c) || (c >= kNBSP && c <= kMax);

  @override
  bool isSpace(int c) => c == kSpace || c == kNBSP;

  @override
  bool isWhitespace(int c) =>
      c == kSpace || (c >= kBackspace && c <= kReturn) || _isUtf8Space(c);

  @override
  bool isControl(int c) => c >= kNull && c < kSpace || c >= 128 && c <= 159;

  /// Returns an ASCII decoder
//String f(List<int> list, {bool allowMalformed}) get decoder =>
// cvt.utf8.decode;

  @override
  String decode(Uint8List list, {bool allowInvalid = true}) =>
      cvt.utf8.decode(list, allowMalformed: allowInvalid);

//  Encoder get encoder => cvt.utf8.encode;
  @override
  Uint8List encode(String s) => cvt.utf8.encode(s);

  /// Minimum valid value
  static const int kMin = 0;

  /// Maximum valid value
  static const int kMax = 255;

  // **** Whitespace Characters ****

  /// Non-Breaking Backspace character used for accents, etc.
  static const int kNBSP = 160;

  /// Synonym for kNBSP.
  static const int kNonBreakingSpace = 160;

  static const int _kControl0085 = 0x0085;
  static const int _kOghamSpaceMark = 0x1680;
  static const int _kEnQuadSpace = 0x2000;
  static const int _kHairSpace = 0x200A;
  static const int _kLineSeparator = 0x2028;
  static const int _kParagraphSeparator = 0x2029;
  static const int _kNarrowNoBreakSpace = 0x202F;
  static const int _kMediumMathSpace = 0x205F;
  static const int _kIdeographicSpace = 0x3000;
  static const int _kBOM = 0xFEFF;

  /// A list of UTF-8 whitespace characters.
  static const List<int> kUtf8WhiteSpace = [
    kNonBreakingSpace,
    _kControl0085,
    _kOghamSpaceMark,
    _kEnQuadSpace,
    _kHairSpace,
    _kLineSeparator,
    _kParagraphSeparator,
    _kNarrowNoBreakSpace,
    _kMediumMathSpace,
    _kIdeographicSpace,
    _kBOM
  ];

  bool _isUtf8Space(int c) => kUtf8WhiteSpace.contains(c);
}

/*
/// Constant definition of ASCII character set.
const Ascii ascii = Ascii(
    'ASCII-1', 'US English', ['ASCII', 'US-ASCII', 'ISO_IR 6', 'ISO/IEC 646']);

/// Constant definition of [latin1] character set.
const Latin latin1 = Latin('Latin1', 'Western Europe',
    ['ISO-8859-1', 'ISO-IR 100', 'Latin1', 'Latin-1']);

/// Constant definition of [latin2] character set.
const Latin latin2 = Latin('Latin2', 'Eastern Europe',
    ['ISO-8859-1', 'ISO-IR 101', 'Latin2', 'Latin-2']);

/// Constant definition of [latin3] character set.
const Latin latin3 = Latin(
    'Latin3', 'Europe', ['ISO-8859-1', 'ISO-IR 109', 'Latin3', 'Latin-3']);

/// Constant definition of [latin4] character set.
const Latin latin4 = Latin(
    'Latin4', 'Europe', ['ISO-8859-1', 'ISO-IR 110', 'Latin4', 'Latin-4']);

/// Constant definition of [latin5] character set.
const Latin latin5 = Latin(
    'Latin5', 'Cyrillic', ['ISO-8859-1', 'ISO-IR 144', 'Latin5', 'Latin-5']);

/// Constant definition of [latin6] character set.
const Latin latin6 = Latin(
    'Latin6', 'Arabic', ['ISO-8859-1', 'ISO-IR 127', 'Latin6', 'Latin-6']);

/// Constant definition of [latin7] character set.
const Latin latin7 =
    Latin('Latin7', 'Greek', ['ISO-8859-7', 'ISO-IR 126', 'Latin7', 'Latin-7']);

/// Constant definition of [latin8] character set.
const Latin latin8 = Latin(
    'Latin8', 'Hebrew', ['ISO-8859-8', 'ISO-IR 138', 'Latin8', 'Latin-8']);

/// Constant definition of [latin9] character set.
const Latin latin9 = Latin('Latin9', 'Latin Alphabet 5',
    ['ISO-8859-9', 'ISO-IR 148', 'Latin9', 'Latin-9']);

/// Constant definition of UTF8 character set.
const Utf8 utf8 = Utf8('UTF8', ['UTF8', 'ISO-IR 192', 'UTF-8']);

/// Pseudonym for [utf8]
const Utf8 utf8Charset = utf8;
*/

/// A Map<String, Charset> of known character sets.
const Map<String, Charset> charsets = {
  'UTF8': Charset.utf8,
  'ISO_IR 192': Charset.utf8,
  'ASCII': Charset.ascii,
  'US-ASCII': Charset.ascii,
  'ISO-8859-1': Charset.latin1,
  'ISO_IR 100': Charset.latin1,
  'ISO-8859-2':Charset. latin2,
  'ISO_IR 101': Charset.latin2,
  'ISO-8859-3': Charset.latin3,
  'ISO_IR 109': Charset.latin3,
  'ISO-8859-4': Charset.latin4,
  'ISO_IR 110': Charset.latin4,
  'ISO-8859-5': Charset.latin5,
  'ISO_IR 144': Charset.latin5,
  'ISO-8859-6': Charset.latin6,
  'ISO_IR 127': Charset.latin6,
  'ISO-8859-7': Charset.latin7,
  'ISO_IR 126': Charset.latin7,
  'ISO-8859-8': Charset.latin8,
  'ISO_IR 138': Charset.latin8,
  'ISO-8859-9': Charset.latin9,
  'ISO_IR 148': Charset.latin9,
};
