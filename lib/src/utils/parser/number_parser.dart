// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
part of odw.sdk.core.parser;

/// Parses an unsigned [int] from [start] to [end], and returns
/// its corresponding value. The If an error is encountered throws an
/// [ParseError].
///
/// Note: we're using this because Dart doesn't provide a Uint parser.
int parseUint(String s,
    {int start = 0, int end, Issues issues, int minLength = 1, int maxLength = 20}) {
  end ??= s.length;
  try {
    _checkArgs(s, start, end, minLength, maxLength, 'parseUint', issues);
    return _parseUint(s, start, issues, end, 'parseUint');
  } on FormatException {
    // ignore: avoid_returning_null
    return null;
  }
}

int parseUintRadix(String s,
    {int radix = 16,
    int start = 0,
    int end,
    int minLength = 1,
    int maxLength = 20,
    Issues issues}) {
  end ??= s.length;
  //TODO: add invalid radix range to issues.
  if (radix < 2 || radix > 36) throw new ArgumentError('invalid radix: todo');
  _checkArgs(s, start, end, minLength, maxLength, 'parseUintRadix', issues);
  try {
    final value = _parseUintRadix(s, start, end, radix);
    return value;
  } on FormatException {
    // ignore: avoid_returning_null
    return null;
  }
}

bool isValidUintString(String s,
        [int start = 0, int end, Issues issues, int minLength = 0, int maxLength = 20]) =>
    parseUint(s,
        start: start,
        end: end,
        issues: issues,
        minLength: minLength,
        maxLength: maxLength) !=
    null;

/// Parses a base 10 [int] starting from [start], and returns the result if
/// it is between [minLength] and [maxLength] inclusive; otherwise, if issues is not _null_
/// add a message to issues, and throws a [ParseError].
///
/// _Note_:
///     1. Does not do bounds checking
///     2. All the parsers might throw so callers should use try/catch.
int parseInt(String s,
    [int start = 0, int end, Issues issues, int minLength = 1, int maxLength = 20]) {
  const name = 'parseInt';
  int sign, value, index = start;
  end ??= s.length;
  _checkArgs(s, start, end, minLength, maxLength, name, issues);
  sign = _parseSign(s, start, issues, name);
  index += (sign < 0) ? 1 : sign;
  value = _parseUint(s, index, issues, end, name);
  return (sign == null || value == null) ? null : value * sign;
}

const int minIntegerStringValue = -99999999999;
const int maxIntegerStringValue = 999999999999;
const int maxIntegerStringHashValue = 99999999999;

/* TODO: at V0.9.1
num parseDecimal(String s,
    [int start = 0, int end, Issues issues, int minLength = 1, int maxLength = 20]) {

}
*/

String hashIntegerString(String s, {Issues issues}) {
  final i = parseInt(s);
  if (i < minIntegerStringValue || i > maxIntegerStringValue)
    return parseError('Invalid Integer String: $s', issues);
  final sign = (i.isOdd) ? -1 : 1;
  final hash = sign * System.rng.nextInt(maxIntegerStringHashValue);
  return hash.toString();
}

List<String> hashIntegerStringList(List<String> sList, {Issues issues}) =>
    sList.map((s) => hashIntegerString(s, issues: issues));

bool isValidIntString(String s,
        [int start = 0, int end, Issues issues, int minLength = 1, int maxLength = 20]) =>
    parseInt(s, start, end, issues, minLength, maxLength) != null;

/// Returns a valid fraction of a second or _null_.  The fraction must be
/// at least 2 characters (a decimal point, followed by a digit, and can be
/// no more than 7 characters.
int parseFraction(String s,
    {int start = 0, int end, int minLength: 2, int max: 7, Issues issues}) {
  try {
    end ??= s.length;
    const name = 'parseFraction';
    _checkArgs(s, start, end, minLength, max, name, issues);
    _parseDecimalPoint(s, start, issues, name);
    return _parseUint(s, start + 1, issues, end, name);
  } on FormatException {
    // ignore: avoid_returning_null
    return null;
  }
}

String hashDecimalString(String s, {Issues issues}) {
  final n = double.parse(s, _onHashDecimalError);
  if (n == null) return parseError('Invalid Decimal String: $s', issues);
  final sign = (System.rng.nextBool()) ? -1 : 1;
  final hash = sign * System.rng.nextDouble();
  return hash.toString();
}

// ignore: avoid_returning_null,
double _onHashDecimalError(String s) => null;

Iterable<String> hashDecimalStringList(List<String> sList, {Issues issues}) =>
    sList.map((s) => hashDecimalString(s, issues: issues));

/// Parses an Uint from [start] to [end], and returns corresponding value.
/// If an error is encountered throws an [ParseError].
///
/// Note: we're using this because Dart doesn't provide a Uint parser.
int _parseUint(String s, int start, Issues issues, int end, String name) {
  var value = 0;
  for (var i = start; i < end; i++) {
    value *= 10;
    final c = s.codeUnitAt(i);
    if (c < k0 || c > k9) {
      final msg = _invalidCharMsg(s, i, name);
      if (issues != null) issues.add(msg);
      parseError(msg, issues);
    }
    final v = c - k0;
    value += v;
  }
  return value;
}

int _parse2Digits(
    String s, int start, Issues issues, int minValue, int maxValue, String name) {
  final end = start + 2;
  assert(s != null && start != null && end <= s.length);
  final v = _parseUint(s, start, issues, end, name);
  return _checkDigitRange(v, minValue, maxValue, name, issues);
}

int _parse4Digits(
    String s, int start, Issues issues, int minValue, int maxValue, String name) {
  final end = start + 4;
  assert(s != null && start != null && end <= s.length);
  final v = _parseUint(s, start, issues, end, name);
  return _checkDigitRange(v, minValue, maxValue, name, issues);
}

int _checkDigitRange(int v, int minValue, int maxValue, String name, Issues issues) =>
    (v == null || v < minValue || v > maxValue)
        ? _rangeError(v, minValue, maxValue, name, issues)
        : v;

int _rangeError(int v, int minValue, int maxValue, String name, [Issues issues]) {
  final msg = 'Range Error: minValue($minValue) <= value($v) <= maxValue($maxValue)';
  return parseError(msg, issues);
}

int _parseUintRadix(String s, int start, int end, int radix, [Issues issues]) {
  var value = 0;
  final maxChar = (radix > 10) ? kA + (radix - 10) : k0 + 1;
  for (var i = start; i < end; i++) {
    value *= radix;
    var c = s.codeUnitAt(i);
    // Make all alphabetic chars uppercase.
    c = (c >= ka) ? kA : c;
    if (c >= k0 && c < maxChar) {
      value += c - kA + 10;
    } else if (c >= k0 || c < maxChar) {
      value += c - k0;
    } else {
      parseError('Invalid char $c in String(${s.length}): "$s"', issues);
    }
  }
  return value;
}

/*
//TODO: flush or Unit test
/// Parses a base 10 [int] of the specified size, starting from [start],
/// and returns its corresponding value. If an error is encountered
/// a [ParseError] is thrown.
///
/// _Note_:
///     1. Does not do bounds checking
///     2. All the parsers might throw so callers should use try/catch.
int _parseFixedInt(String s, [int start = 0, int end, Issues issues, bool isValidOnly]) =>
    parseInt(s, start, end, issues, 0, s.length);
*/

String _invalidSign(String s, int index, String name) =>
    'Invalid sign char "${s[index]} at pos($index).';

/// Parses a '+' or '-' character immediately proceeding an integer.
/// Returns 1 for '+'. -1 for '-', or 0 if the character is a digit (0-9);
/// otherwise, either throws a [ParseError] appends a message to [issues].
int _parseSign(String s, int start, Issues issues, String name) {
  final c = s.codeUnitAt(start);
  if (c == kMinusSign) return -1;
  if (c == kPlusSign || isDigitChar(c)) return 1;
  return parseError(_invalidSign(s, start, name), issues);
}

int _parseFraction(String s, int start, Issues issues, int end, String name) {
  _parseDecimalPoint(s, start, issues, name);
  return _parseUint(s, start + 1, issues, end, name);
}

bool _parseDecimalPoint(String s, int start, Issues issues, String name) {
  if (s.codeUnitAt(start) == kDot) return true;
  final msg = '$name: Missing decimal point (".") at position $start';
  return parseError(msg, issues);
}
