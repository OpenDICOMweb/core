//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/src/utils/ascii.dart';
import 'package:core/src/utils/string/hexadecimal.dart';

// **** This file contains low-level [String] functions

/// Returns a [String] containing [count] _space_ (' ') characters.
String spaces(int count) => ''.padRight(count);

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

