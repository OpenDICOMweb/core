// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

// **** Convert integer to hexadecimal String

import 'package:core/src/system/system.dart';

// Constants for hexadecimal [String]s.
const String lowercaseRadixDigits = '0123456789abcdefghijklmnopqrstuvwxyz';
const String uppercaseRadixDigits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

String getRadixDigits() =>
    (system.isHexUppercase) ? uppercaseRadixDigits : lowercaseRadixDigits;

String _toRadixString(int n,
        {int base = 10, int length, String padChar = '0'}) =>
    __toRadixString(n, base, length, padChar);

String _padString(String s, int length, [String padChar = '0']) {
  final pLength = length - s.length;
  return (pLength > 0) ? '${"".padRight(pLength, padChar)}$s' : s;
}

String __toRadixString(int n, int base, int length, String padChar) {
  final sb = new StringBuffer();
  final radixDigits = getRadixDigits();

  void toString(int n, int base) {
    if (n < base) return sb.write(radixDigits[n]);
    sb.write(radixDigits[n % base]);
    toString(n ~/ base, base);
  }

  toString(n, base);
  return _padString(sb.toString(), length, padChar);
}

String xHex(int n) => _toRadixString(n, base: 16, length: 8, padChar: '0');

/// _Deprecated_: Use [hex] instead.
@deprecated
String toHex(int n,
        {int maxLength = 8, String prefix = '', String padding = '0'}) =>
    '$prefix${_toRadixString(16).padLeft(maxLength, padding)}';

/// Returns a hexadecimal [String] corresponding to [n] that is at least
/// [width] long. [width] defaults to 8. If the returned [String] would
/// be less than [width] characters it is zero-padded to [width].
///
/// If where <prefix> is _true_, the returned String will be prefixed
/// with '0x' if positive or '-0x' if negative. if [prefix] is false,
/// the returned [String] will not have a prefix.
///
/// If the resulting [String] would have less than [width] characters,
/// it is left padded with zeros to [width].
String hex(int n, {int width = 8, bool prefix = false}) {
  final _prefix = (prefix) ? (n < 0) ? '-0x' : '0x' : '';
  return '$_prefix${n.toRadixString(16).padLeft(width, '0')}';
}

/// _Deprecated_: Use [hex32] instead.
@deprecated
String toHex32(int v) {
  assert(v < 0xFFFFFFFF);
  return hex(v, width: 8);
}

/// Returns a hexadecimal [String] corresponding to [n] as a 32-bit
/// unsigned integer. If the length of result is less than 8, it is
/// left padded with zeros.
String hex32(int n, {bool prefix = false}) {
  assert(n >= 0 && n <= 0xFFFFFFFF);
  return hex(n, width: 8, prefix: prefix);
}

@deprecated
String toHex16(int v) {
  assert(v >= 0 && v <= 0xFFFF);
  return hex(v, width: 4);
}

/// Returns a hexadecimal [String] corresponding to [n] as a 16-bit
/// unsigned integer. If the length of result is less than 4, it is
/// left padded with zeros.
/// _Deprecated_: Use [hex32] instead.
String hex16(int n, {bool prefix = false}) {
  assert(n >= 0 && n <= 0xFFFF);
  return hex(n, width: 4, prefix: prefix);
}

@deprecated
String toHex8(int v) {
  assert(v >= 0 && v <= 0xFF);
  return hex(v, width: 4);
}

/// Returns a hexadecimal [String] corresponding to [n] as a 8-bit
/// unsigned integer. If the length of result is less than 2, it is
/// left padded with zeros. Finally, the result is prefixed with [prefix].
String hex8(int n, {bool prefix = false}) {
  assert(n >= 0 && n <= 0xFF, 'v: $n');
  return hex(n, width: 2, prefix: prefix);
}
