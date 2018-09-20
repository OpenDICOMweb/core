//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/global.dart';

// ignore_for_file: public_member_api_docs

class RadixEncoder {
  final int radix;
  final String _digits;
  bool lowercase;

  RadixEncoder(this.radix, {this.lowercase = true}) : _digits = digits(radix);

  String encode(int n, {int base = 10, int length, String padChar = '0'}) =>
      _toRadixString(n, base, length, padChar);

  String _toRadixString(int n, int base, int length, String padChar) {
    final sb = StringBuffer();
    _toString(sb, _digits, n, base);
    return _padString(sb.toString(), length, padChar);
  }

  void _toString(StringBuffer sb, String digits, int n, int base) {
    if (n < base) return sb.write(digits[n]);
    sb.write(digits[n % base]);
    _toString(sb, digits, n ~/ base, base);
  }

  String _padString(String s, int length, [String padChar = '0']) {
    final pLength = length - s.length;
    return (pLength > 0) ? '${"".padRight(pLength, padChar)}$s' : s;
  }

  /// Returns a [String] containing all the digits used for [radix]
  static String digits([int radix]) => (global.isHexUppercase)
      ? uppercaseDigits.substring(0, radix)
      : lowercaseDigits.substring(0, radix);

  // Digits for radix [String]s.
  static const String lowercaseDigits = '0123456789abcdefghijklmnopqrstuvwxyz';
  static const String uppercaseDigits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
}
