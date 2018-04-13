// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
part of odw.sdk.core.new_parser;

// TODO: add tryParse methods for all top-level entries
// TODO: make sure this is true and then move to parse.
// _Note_:
//     1. Number parsers do not check the range of the result
//     2, All the parsers might throw so callers should use try/catch.

/// Parses an unsigned [int], in radix [radix] from [start] to [end], and
/// returns its corresponding value. If an error is encountered a
/// [ParseError] is thrown.
int parseRadix(String s,
        {int start = 0,
        Issues issues,
        int end,
        int minLength = 1,
        int maxLength,
        int radix = 16,
        int onError(String s) = _defaultParseIntError}) =>
    _parseRadix(s, start, issues, end ??= s.length, minLength, maxLength, radix,
        'parseRadix', onError);

/// Tries to parses an unsigned [int], in radix [radix] from [start] to [end],
/// and returns its corresponding value. If an error is encountered _null_
/// is returned.
int tryParseRadix(String s,
        {int start = 0,
        Issues issues,
        int end,
        int minLength = 1,
        int maxLength,
        int radix = 16,
        int onError(String source) = _defaultParseIntError}) =>
    _tryParseRadix(s, start, issues, end ??= s.length, minLength, maxLength,
        radix, 'tryParseRadix');

/// Parses [s] from [start] to [end] as an unsigned radix 2 integer,
/// and returns the value. If an error is  encountered [onError] is called.
int parseBinary(String s,
        {int start = 0,
        int end,
        Issues issues,
        int minLength = 1,
        int maxLength,
        int onError(String s) = _defaultParseIntError}) =>
    _parseRadix(s, start, issues, end ??= s.length, minLength, maxLength, 2,
        'parseBinary', onError);

/// Tries to parse [s] from [start] to [end] as a signed base 10 integer, and
/// returns the parsed value. Returns _null_ if an error is encountered.
int tryParseBinary(String s,
        {int start = 0,
        int end,
        Issues issues,
        int minLength = 1,
        int maxLength,
        int onError(String source) = _defaultParseIntError}) =>
    _tryParseRadix(s, start, issues, end ??= s.length, minLength, maxLength, 2,
        'parseBinary');

/// Parses an unsigned [int] from [start] to [end], and returns
/// its corresponding value. The If an error is encountered throws an
/// [ParseError].
///
/// Note: we're using this because Dart doesn't provide a Uint parser.
int parseUint(String s,
        {int start = 0,
        int end,
        Issues issues,
        int minLength = 1,
        int maxLength,
        int onError(String source) = _defaultParseIntError}) =>
//    _parseRadix(s, start, issues, end ??= s.length, minLength, maxLength, 10,
//        'parseUint', onError);
    _parseBase10(s, start, issues, end ??= s.length, 'parseUint', onError);

/// Tries to parse [s] from [start] to [end] as a signed base 10 integer, and
/// returns the parsed value. Returns _null_ if an error is encountered.
int tryParseUint(String s,
        {int start = 0,
        int end,
        Issues issues,
        int minLength = 1,
        int maxLength,
        int onError(String source) = _defaultParseIntError}) =>
    _tryParseRadix(s, start, issues, end ??= s.length, minLength, maxLength, 10,
        'parseUint');

/// Parses [s] from [start] to [end] as a hexadecimal number, and returns
/// its corresponding value. The If an error is encountered returns _null_.
int parseHex(String s,
        {int start = 0,
        int end,
        Issues issues,
        int minLength = 1,
        int maxLength,
        int onError(String source) = _defaultParseIntError}) =>
    _tryParseRadix(s, start, issues, end ??= s.length, minLength, maxLength, 16,
        'parseHex');

/// Tries to parse [s] from [start] to [end] as an unsigned base 16 integer,
/// and returns the parsed value. If an error is encountered returns null.
int tryParseHex(String s,
        {int start = 0,
        int end,
        Issues issues,
        int minLength = 1,
        int maxLength,
        int onError(String source) = _defaultParseIntError}) =>
    _tryParseRadix(s, start, issues, end ??= s.length, minLength, maxLength, 16,
        'parseHex');

/// Tries to parse [s] from [start] to [end] as a base 10 integer, and
/// returns the resulting value if [s].length is between [minLength] and
/// [maxLength] inclusive; otherwise, if issues is not _null_ adds a message
/// to issues, and throws a [ParseError].
int parseInt(String s,
    [int start = 0,
    int end,
    Issues issues,
    int minLength = 1,
    int maxLength,
    int onError(String source) = _defaultParseIntError]) {
  end ??= s.length;
  const _intName = 'parseInt';
  _checkArgs(s, start, end, minLength, maxLength, _intName, issues);
  int sign, value, index = start;
  try {
    sign = _parseSign(s, start, issues, _intName);
    index += (sign < 0) ? 1 : sign;
    value = _parseBase10(s, index, issues, end, _intName, onError);
  } on FormatException {
    // ignore: avoid_returning_null
    return null;
  }
  return (value == null) ? null : (sign == -1) ? value * sign : value;
}

/// Tries to parse [s] from [start] to [end] as a signed base 10 integer, and
/// returns the parsed value. Returns _null_ if an error is encountered.
int tryParseInt(String s,
        [int start = 0,
        int end,
        Issues issues,
        int minLength = 1,
        int maxLength]) =>
    parseInt(
        s, start, end, issues, minLength, maxLength, _defaultTryParseIntError);

// TODO: unit test
/// Tries to parse [s] from [start] to [end] as a floating point number, and
/// returns the resulting value if it is between [minLength] and [maxLength]
/// inclusive; otherwise, if issues is not _null_ adds a message to issues,
/// and throws a [ParseError].
///
/// _Note_: Does not do range checking
double parseFloat(String s,
    [int start = 0,
    int end,
    Issues issues,
    int minLength = 1,
    int maxLength,
    int onError(String source) = _defaultParseIntError]) {
  // end ??= s.length;
  const _intName = 'parseFloat';
  _checkArgs(s, start, end, minLength, maxLength, _intName, issues);
  double value;
  try {
    final _s = s.substring(start, end);
    value = double.parse(_s);
  } on FormatException {
    // ignore: avoid_returning_null
    return null;
  }
  return value;
}

/// Returns a valid fraction of a second or _null_.  The fraction must be
/// at least 2 characters (a decimal point, followed by a digit, and can be
/// no more than 7 characters.
int parseFraction(String s,
    {int start = 0,
    int end,
    int minLength: 2,
    int max: 7,
    Issues issues,
    int onError(String source) = _defaultParseIntError}) {
  try {
    end ??= s.length;
    _checkArgs(s, start, end, minLength, max, _fName, issues);
    return _parseFraction(s, start, issues, end, _fName, onError);
  } on FormatException catch (e) {
    log.debug(e);
    // ignore: avoid_returning_null
    return null;
  }
}

const _fName = 'parseFraction';

int _parseFraction(String s, int start, Issues issues, int end,
    [String name, int onError(String s)]) {
  _parseDecimalPoint(s, start, issues, _fName);
  return _parseBase10(s, start + 1, issues, end, _fName, onError);
}

bool _parseDecimalPoint(String s, int start, Issues issues, String name) {
  if (s.codeUnitAt(start) == kDot) return true;
  final msg = '$name: Missing decimal point (".") at position $start';
  return parseError(msg, issues);
}

//TODO: unit test
/// Parses an unsigned radix [radix] integer in [s] from [start] to [end],
/// and, if valid, returns its corresponding value. If an error is encountered
/// throws an [ParseError].
///
/// Note:
///     1. Dart doesn't provide a Uint parser.
///     2. All alphabetic characters are converted to uppercase before
///        being parsed.
/// Parses an unsigned [int] from [start] to [end], and returns
/// its corresponding value. The If an error is encountered throws an
/// [ParseError].
///
/// Note: we're using this because Dart doesn't provide a Uint parser.
int _parseRadix(String s, int start, Issues issues, int end, int minLength,
    int maxLength, int radix, String name, int onError(String s)) {
  if (radix < 2 || radix > 36)
    throw new ArgumentError('Radix ($radix) not in range: 2 <= radix <= 36');
  _checkArgs(s, start, end, minLength, maxLength, 'parseUintRadix', issues);
  return __parseRadix(s, start, issues, end, 'parseRadix', radix, onError);
}

int __parseRadix(String s, int start, Issues issues, int end, String name,
        int radix, int onError(String s)) =>
    (radix <= 10)
        ? __parseSmallRadix(s, start, issues, end, name, radix, onError)
        : __parseBigRadix(s, start, issues, end, name, radix, onError);

int _parseBase2(String s, int start, Issues issues, int end, String name,
        int onError(String s)) =>
    __parseSmallRadix(s, start, issues, end, name, 2, onError);

int _parseBase8(String s, int start, Issues issues, int end, String name,
        int onError(String s)) =>
    __parseSmallRadix(s, start, issues, end, name, 8, onError);

int _parseBase10(String s, int start, Issues issues, int end, String name,
        int onError(String s)) =>
    __parseSmallRadix(s, start, issues, end, name, 10, onError);

//TODO: replace with _parseRadix if performance doesn't suffer
/// Parses an Uint from [start] to [end], and returns corresponding value.
/// If an error is encountered throws an [ParseError].
///
/// Note: we're using this because Dart doesn't provide a Uint parser.
int __parseSmallRadix(String s, int start, Issues issues, int end, String name,
    int radix, int onError(String s)) {
  final maxChar = k0 + (radix - 1);
  assert(maxChar >= k0 && maxChar <= k9);
  var value = 0;
  for (var i = start; i < end; i++) {
    value *= radix;
    final c = s.codeUnitAt(i);
    if (c < k0 || c > maxChar) return _invalidIntCharError(s, i, issues, name);
    value += c - k0;
  }
  return value;
}

int _parseBase16(String s, int start, Issues issues, int end, String name,
        int onError(String s)) =>
    __parseBigRadix(s, start, issues, end, name, 16, onError);

// The distance between uppercase and lowercase
const _kLowerCaseOffset = ka - kA;

int __parseBigRadix(String s, int start, Issues issues, int end, String name,
    int radix, int onError(String s)) {
  assert(radix > 10 && radix <= 36);
  var value = 0;
  final maxChar = kA + (radix - 11);
  for (var i = start; i < end; i++) {
    value *= radix;
    var c = s.codeUnitAt(i);
    // Make all alphabetic chars uppercase.
    if (c >= ka && c <= kz) c -= _kLowerCaseOffset;
    if (c >= k0 && c < k9) {
      value += c - k0;
    } else if (c >= kA || c < maxChar) {
      value += (c - kA) + 10;
    } else {
      return (onError != null)
          ? onError(s.substring(start, end))
          : _invalidIntCharError(s, i, issues, name);
    }
  }
  return value;
}

int _defaultParseIntError(String msg, [String source, int offset]) {
  throw FormatException('Invalid I', source, offset);
}

int _tryParseRadix(String s, int start, Issues issues, int end, int minLength,
        int maxLength, int radix, String name) =>
    _parseRadix(s, start, issues, end, minLength, maxLength, radix, name,
        _defaultTryParseIntError);

// ignore: avoid_returning_null
int _defaultTryParseIntError(String s) => null;

Null _invalidIntCharError(String s, int index, Issues issues, String name) {
  final msg = _invalidIntCharMsg(s, index, issues, name);
  if (throwOnError) parseError(msg, issues);
  return null;
}

/// Returns an invalid character [String].
String _invalidIntCharMsg(String s, int index, Issues issues, String name) {
  final msg = '(in $name) Invalid integer character "${s[index]}" '
      '(${s.codeUnitAt(index)}) at pos($index) in String:"$s"';
  if (issues != null) issues.add(msg);
  return msg;
}

int __parseBase10(String s, int start, Issues issues, int end) {
  var value = 0;
  for (var i = start; i < end; i++) {
    value *= 10;
    final c = s.codeUnitAt(i);
    if (c < k0 || c > k9)
      return _invalidIntCharError(s, i, issues, '*internal*');
    value += c - k0;
  }
  return value;
}

int _parse2Digits(
    String s, int start, Issues issues, int minValue, int maxValue) {
  final end = start + 2;
  assert(s != null && start != null && end <= s.length);
  final v = __parseBase10(s, start, issues, end);
  return _checkDigitRange(v, issues, minValue, maxValue);
}

int _parse4Digits(
    String s, int start, Issues issues, int minValue, int maxValue) {
  final end = start + 4;
  assert(s != null && start != null && end <= s.length);
  final v = __parseBase10(s, start, issues, end);
  return _checkDigitRange(v, issues, minValue, maxValue);
}

int _checkDigitRange(
  int v,
  Issues issues,
  int minValue,
  int maxValue,
) =>
    (v == null || v < minValue || v > maxValue)
        ? _rangeError(v, minValue, maxValue, issues)
        : v;

int _rangeError(int v, int minValue, int maxValue, [Issues issues]) {
  final msg =
      'Range Error: minValue($minValue) <= value($v) <= maxValue($maxValue)';
  return parseError(msg, issues);
}

/// Parses a '+' or '-' character immediately proceeding an integer.
/// Returns 1 for '+'. -1 for '-', or 0 if the character is a digit (0-9);
/// otherwise, either throws a [ParseError] appends a message to [issues].
int _parseSign(String s, int start, Issues issues, String name) {
  final c = s.codeUnitAt(start);
  if (c == kMinusSign) return -1;
  if (isDigitChar(c)) return 0;
  if (c == kPlusSign) return 1;
  return parseError('Invalid sign char "${s[start]} at pos($start).', issues);
}
