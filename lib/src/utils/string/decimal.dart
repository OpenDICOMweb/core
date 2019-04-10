//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

//Note: the following do NO error checking.

/// Returns a 2 digit [String], left padded with '0' if necessary.
String digits2(int n) {
  if (n > 99) return null;
  if (n >= 10) return '$n';
  return '0$n';
}

/// Returns a 3 digit [String], left padded with '0' if necessary.
String digits3(int n) {
  if (n > 999) return null;
  if (n >= 100) return '$n';
  if (n >= 10) return '0$n';
  return '00$n';
}

/// Returns a 4 digit [String], left padded with '0' if necessary.
String digits4(int n) {
  if (n > 9999) return null;
  if (n >= 1000) return '$n';
  if (n >= 100) return '0$n';
  if (n >= 10) return '00$n';
  return '000$n';
}

/// Returns a 6 digit [String], left padded with '0' if necessary.
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
String dec(int n, {int maxLength = 0, String padding = '0'}) =>
    n.toRadixString(10).padLeft(maxLength);

/// Returns a decimal [String] corresponding to [n] as an 8-bit
/// integer. If the length of the result is less than 3, it is
/// left padded with zeros.
String dec8(int n) {
  assert(n >= -0xFF && n <= 0xFF);
  return dec(n, maxLength: 3);
}

/// Returns a decimal [String] corresponding to [n] as a 16-bit
/// integer. If the length of the result is less than 5, it is
/// left padded with zeros.
String dec16(int n) {
  assert(n >= -0xFFFF && n <= 0xFFFF);
  return dec(n, maxLength: 5);
}

/// Returns a decimal [String] corresponding to [n] as a 32-bit
/// integer. If the length of the result is less than 10, it is
/// left padded with zeros.
String dec32(int n) {
  assert(n >= -0x8FFFFFFF && n <= 0x8FFFFFFF);
  return dec(n, maxLength: 10);
}

/// Returns a [String] that approximately corresponds to [v],
/// that has at most 16 characters.
String floatToString(double v) {
  const precision = 10;
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

/// Returns a [String] that approximately corresponds to [v],
String numToString(num v) {
  assert(v is double || v is int);
  return (v is double) ? floatToString(v) : dec32(v);
}
