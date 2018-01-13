// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/string/ascii.dart';
import 'package:core/src/string/hexadecimal.dart';

// **** This file contains low-level [String] functions

//TODO: make private and public versions of these
//Note: the following do no error checking.
String digits2(int n) {
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
  if (n >= 1000) return '$n';
  if (n >= 100) return '0$n';
  if (n >= 10) return '00$n';
  return '000$n';
}

String digits6(int n) {
  if (n >= 100000) return '$n';
  if (n >= 10000) return '0$n';
  if (n >= 1000) return '00$n';
  if (n >= 100) return '000$n';
  if (n >= 10) return '0000$n';
  return '00000$n';
}

/// Returns an [Iterable] of [s], where is is split by the
/// separator and then each component of the [Iterable] has
/// leading and trailing whitespace trimmed.
Iterable<String> splitTrim(String s, String separator) =>
    s.split(separator).map((s) => s.trim());

//TODO: before V0.9.0 decide if these are needed or useful

// Auxiliary used for debugging
String toAscii(ByteData bd, [int start = 0, int end, int position]) {
	end ??= bd.lengthInBytes;
	String vChar(int c) =>
			(c > kSpace) && (c < kDelete) ? '_${new String.fromCharCode(c)}' : '__';
	final bytes = bd.buffer.asUint8List(start, end);
	if (start >= end) return '';
	var pos = position ?? start;
	if (pos >= end) pos = end;
	final sb = new StringBuffer();
	for (var i = start; i < pos; i++) sb.write(' ${vChar(bytes[i])}');
	sb.write('|${vChar(bytes[pos])}|');
	for (var i = pos + 1; i < end; i++) sb.write(' ${vChar(bytes[i])}');
	return sb.toString();
}

/// Returns a hexadecimal [String] corresponding to [bd].
// Auxiliary used for debugging
String bdToHex(ByteData bd, [int start = 0, int end, int position]) {
	end ??= bd.lengthInBytes;
	final bytes = bd.buffer.asUint8List(start, end);
	var pos = position ?? start;
	if (start >= end) return '';
	if (pos >= end) pos = end;
	final sb = new StringBuffer();
	for (var i = start; i < pos; i++) sb.write(' ${hex8(bytes[i])}');
	sb.write('|${hex8(bytes[pos])}|');
	for (var i = pos + 1; i < end; i++) sb.write(' ${hex8(bytes[i])}');
	return sb.toString();
}

