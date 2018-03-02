// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

//TODO: make private and public versions of these
//Note: the following do no error checking.
String digits2(int n) {
  if (n > 99) return null;
  if (n >= 10) return '$n';
  return '0$n';
}

String digits3(int n) {
  if (n > 999) return null;
  if (n >= 100) return '$n';
  if (n >= 10) return '0$n';
  return '00$n';
}

String digits4(int n) {
  if (n > 9999) return null;
  if (n >= 1000) return '$n';
  if (n >= 100) return '0$n';
  if (n >= 10) return '00$n';
  return '000$n';
}

String digits6(int n) {
  if (n > 999999) return null;
  if (n >= 100000) return '$n';
  if (n >= 10000) return '0$n';
  if (n >= 1000) return '00$n';
  if (n >= 100) return '000$n';
  if (n >= 10) return '0000$n';
  return '00000$n';
}

// **** Convert integer to decimal String

/// Returns a decimal [String] corresponding to [n] in the format
/// '<prefix><p*><d+>', where <p*> is zero or more padding characters
/// and <d*> is one or more decimal characters corresponding to [n].
///
/// [n] is first converted into the corresponding decimal [String].
/// Then, if the [maxLength] of the result is less than [maxLength],
/// it is left padded with [padding], which defaults to zero ("0");
/// otherwise, no padding is added.
///
/// _Note_: If [padding] has a [maxLength] greater than 1 the result
/// will not have a length equal to [maxLength]. See [String] padLeft
/// for details.
String toDec(int n, {int maxLength = 0, String padding = '0'}) =>
    n.toRadixString(10).padLeft(maxLength);

/// Returns a decimal [String] corresponding to [v] as a 32-bit
/// integer. If the length of the result is less than 10, it is
/// left padded with zeros.
String toDec32(int v) => toDec(v, maxLength: 10);

/// Returns a decimal [String] corresponding to [v] as a 16-bit
/// integer. If the length of the result is less than 5, it is
/// left padded with zeros.
String toDec16(int v) => toDec(v, maxLength: 5);

/// Returns a decimal [String] corresponding to [v] as a 8-bit
/// integer. If the length of the result is less than 10, it is
/// left padded with zeros.
String toDec8(int v) => toDec(v, maxLength: 3);

/// Returns a hexadecimal [String] corresponding to [bytes].
String bytesToHex(Uint8List bytes, [int start = 0, int end]) {
  end ??= bytes.lengthInBytes - start;
  final sb = new StringBuffer();
  for (var i = start; i < end; i++) sb.write(i.toRadixString(16).padLeft(2, '0'));
  return sb.toString();
}

/// Returns a [String] that approximately corresponds to [v],
/// that has at most 16 characters.
String floatToString(double v) {
  final precision = 10;
  var s = v.toString();
  if (s.length > 16) {
    for (var i = precision; i > 0; i--) {
      s = v.toStringAsPrecision(i);
      if (s.length <= 16) break;
    }
  }
  assert(s.length <= 16, '"$s" exceeds max DS length of 16');
  return s;
}

