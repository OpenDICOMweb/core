//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.core.parser;


/// Return the [value] if it satisfies the range; otherwise,
///   - creates an error message,
///   - If [issues] is not _null_, adds message to issues,
///   - then calls [parseError], which will either throw, if
///   [throwOnError] is _true_; otherwise, returns _null_.
// Note: _checkRange throws so all the other _check* might also throw.
int _checkRange(int value, int min, int max, [Issues issues]) {
  assert(value != null);
  if (value < min || value > max) {
	  final msg = 'Range Error: min($min) <= value($value) <= max($max)';
    parseError(msg, issues);
  }
  return value;
}

/* Flush if not used
bool _inRange(int v, int min, int max, [Issues issues]) {
  if (v == null) return parseNullError();
  if (v < min || v > max) {
	  final msg = 'Range Error: min($min) <= value($v) <= max($max)';
    parseError(msg, issues);
  }
  return true;
}

bool _notInRange(int v, int min, int max, [Issues issues]) =>
    _notInRange(v, min, max, issues);
*/

/// Checks the arguments of a public function in the parse package.
///
/// Checks that [start], [end], [min], and [max] are all valid for
/// the [String] [s].  If any of the values are not valid:
///     - if [issues] is not _null_, it add a message to [issues]
///     - throws a [parseError] with message.
///
/// For the arguments to be valid:
///   1. end >= start + min && end <= start + max
///   2. end < s.length
///
///                | end < length
///     0  start  min   max
///     |....|. ...|.....|....|
///
/// Assumption: non of the arguments are null.
void _checkArgs(
    String s, int start, int end, int min, int max, String fName, Issues issues) {
  assert(s != null &&
      start != null &&
      end != null &&
      min != null &&
      max != null &&
      fName != null);
  final sb = new StringBuffer();
  if (s == null) {
    sb.writeln(_badArg('s', 'null', '', fName));
    parseError(sb.toString(), issues);
  }
  if (s == '') {
    sb.writeln(_badArg('s', '""', 'empty string', fName));
    parseError(sb.toString(), issues);
  }
  if (start >= s.length) {
    sb.writeln(_badArg('s', '$s', 'start($start) >= s.length(${s.length})', fName));
    parseError(sb.toString(), issues);
  }
  if (s.length < end) {
	  final msg = 'end($end) => s.length(${s.length}) for "$s"';
    sb.writeln(_badArg('end', '$end', msg, fName));
    parseError(sb.toString(), issues);
  }
  if (end < start + min) {
    sb.writeln('The argument "end($end)" is less than start($start) plus '
        'the minimum length($min) of s(${s.length})"$s"');
    parseError(sb.toString(), issues);
  }
  if (end > start + max) {
    sb.writeln('The argument "end($end)" is less than start($start) plus '
        'the maximum length($max) of s(${s.length})"$s"');
    parseError(sb.toString(), issues);
  }
}

/// Returns an invalid value [String].
String _badArg(String arg, String value, String msg, String fName) =>
    '$fName: Invalid argument($arg == $value) $msg';

/*
//TODO: Decide if this is needed
/// Returns an invalid value [String].
String _invalidValueMsg(int v, int index, String name) {
  assert(v != null && index != null && name != null);
  return '$name: Invalid Value($v) at pos($index)';
}
*/

/// Returns an invalid character [String].
String _invalidCharMsg(String s, int index, [String name = '']) =>
    'Invalid $name character "${s[index]}"(${s.codeUnitAt(index)}'
    ' at pos($index) in String:"$s" with length: ${s.length})';
