//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

// **** Convert integer to hexadecimal String
import 'dart:typed_data';

/// This package provides utility functions for converting integers
/// int _radix_ based [String]s.

/// Returns a hexadecimal [String] corresponding to [n] that is at least
/// [width] long.
///
/// If [width], which defaults to 0,  is less than or equal to zero, the
/// result will have no padding. If the result would be less than [width]
/// characters the result is zero-padded to [width].
///
/// If [prefix] is _true_, the returned String will be prefixed
/// with '0x' if positive or '-0x' if negative; otherwise, the
/// returned [String] will not have a prefix.
String hex(int n, {int width = -1, bool prefix = false}) {
  final _prefix = prefix ? (n < 0) ? '-0x' : '0x' : '';
  return '$_prefix${n.toRadixString(16).padLeft(width, '0')}';
}

/// Returns a hexadecimal [String] corresponding to [n] as a 8-bit
/// unsigned integer. If the length of result is less than 2, it is
/// left padded with zeros. Finally, the result is prefixed with [prefix].
String hex8(int n, {bool prefix = false}) {
  assert(n >= 0 && n <= 0xFF, 'v: $n');
  return hex(n, width: 2, prefix: prefix);
}

/// Returns a hexadecimal [String] corresponding to [n] as a 16-bit
/// unsigned integer. If the length of result is less than 4, it is
/// left padded with zeros.
String hex16(int n, {bool prefix = false}) {
  assert(n >= 0 && n <= 0xFFFF);
  return hex(n, width: 4, prefix: prefix);
}

/// Returns a hexadecimal [String] corresponding to [n] as a 32-bit
/// unsigned integer. If the length of result is less than 8, it is
/// left padded with zeros.
String hex32(int n, {bool prefix = false}) {
  assert(n >= 0 && n <= 0xFFFFFFFF);
  return hex(n, width: 8, prefix: prefix);
}

/// Returns a hexadecimal [String] corresponding to [n] as a 64-bit
/// unsigned integer. If the length of result is less than 16, it is
/// left padded with zeros.
String hex64(int n, {bool prefix = false}) => hex(n, width: 16, prefix: prefix);

/// Returns a hexadecimal [String] corresponding to [bytes].
String bytesToHex(Uint8List bytes, [int start = 0, int end]) {
  end ??= bytes.lengthInBytes - start;
  final sb = StringBuffer();
  for (var i = start; i < end; i++)
    sb.write(i.toRadixString(16).padLeft(2, '0'));
  return sb.toString();
}
