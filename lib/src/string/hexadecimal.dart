// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

// **** Convert integer to hexadecimal String

import 'package:core/src/string/string_buffer.dart';
import 'package:core/src/system/system.dart';

// Constants for hexadecimal [String]s.
const String lowercaseRadixDigits = '0123456789abcdefghijklmnopqrstuvwxyz';
const String uppercaseRadixDigits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

String getRadixDigits() =>
    (system.isHexUppercase) ? uppercaseRadixDigits : lowercaseRadixDigits;

//Urgent Unit test
String _toRadixString(int n, {int base = 10, int length, String padChar = '0'}) =>
    __toRadixString(n, base, length, padChar);

String _padString(String s, int length, [String padChar = '0']) {
  final pLength = length - s.length;
  return (pLength > 0) ? '${"".padRight(pLength, padChar)}$s' : s;
}

String __toRadixString(int n, int base, int length, String padChar) {
  final sb = new AsciiBuffer();
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
String toHex(int n, {int maxLength = 8, String prefix = '0x', String padding = '0'}) =>
    '$prefix${_toRadixString(16).padLeft(maxLength, padding)}';

/// Returns a hexadecimal [String] corresponding to [n] in the format
/// '<prefix><p*><h+>', where <p*> is zero or more padding characters
/// and <h*> is one or more hexadecimal characters corresponding to [n].
///
/// [n] is first converted into the corresponding hexadecimal [String].
/// Then, if the [maxLength] of the result is less than [maxLength],
/// it is left padded with [padding], which defaults to zero ("0");
/// otherwise, no padding is added.
///
/// After the padding, if any, is added to the result, the [prefix],
/// which defaults to "0x" is prepended to the result, which is then
/// returned.
///
/// _Note_: If [padding] has a [maxLength] greater than 1 the result
/// will not have a length equal to [maxLength]. See the [String]
/// method `padLeft` for details.
String hex(int n, {int maxLength = 8, String prefix = '0x', String padding = '0'}) =>
    '$prefix${n.toRadixString(16).padLeft(maxLength, padding)}';

/// Returns a hexadecimal [String] corresponding to [v] as a 32-bit
/// unsigned integer. If the length of result is less than 8, it is
/// left padded with zeros. Finally, the result is prefixed with '0x'.
@deprecated
String toHex32(int v) {
  assert(v < 0xFFFFFFFF);
  return hex(v, maxLength: 8);
}

String hex32(int v) {
  assert(v <= 0xFFFFFFFF);
  return hex(v, maxLength: 8);
}

/// Returns a hexadecimal [String] corresponding to [v] as a 16-bit
/// unsigned integer. If the length of result is less than 4, it is
/// left padded with zeros. Finally, the result is prefixed with '0x'.
@deprecated
String toHex16(int v) {
	assert(v >= 0 && v <= 0xFFFF);
  return hex(v, maxLength: 4);
}

String hex16(int v, {String prefix = '0x'}) {
  assert(v >= 0 && v <= 0xFFFF);
  return hex(v, maxLength: 4, prefix: prefix);
}

/// Returns a hexadecimal [String] corresponding to [v] as a 8-bit
/// unsigned integer. If the length of result is less than 2, it is
/// left padded with zeros. Finally, the result is prefixed with '0x'.
@deprecated
String toHex8(int v) {
	assert(v >= 0 && v <= 0xFF);
  return hex(v, maxLength: 4);
}

String hex8(int v) {
	assert(v >= 0 && v <= 0xFF);
  return hex(v, maxLength: 2);
}
