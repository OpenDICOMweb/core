//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.core.parser;

bool _parseSeparator(String s, int index, Issues issues, int separator) {
  assert(s != null && index != null && index < s.length);
  final char = s.codeUnitAt(index);
  return (char != separator)
      ? parseError(
          'Invalid separator("${s[index]}") at pos $index in "$s"', issues)
      : true;
}

/// Return the [value] if it satisfies the range; otherwise,
///   - creates an error message,
///   - If [issues] is not _null_, adds message to issues,
///   - then calls [parseError], which will either throw, if
///   [throwOnError] is _true_; otherwise, returns _null_.
// Note: _checkRange throws so all the other _check* might also throw.
int _checkRange(int value, int min, int max, [Issues issues]) {
  assert(value != null);
  if (value < min || value > max) {
    final msg = 'Range Error: min($min) <= values($value) <= max($max)';
    parseError(msg, issues);
  }
  return value;
}

/// Checks the arguments of a public function in the parse package.
///
/// Checks that [start], [end], [min], and [max] are all valid for
/// the [String] [s].  If any of the values are not valid:
///     - if [issues] is not _null_, a message is add a message to [issues]
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
void _checkArgs(String s, int start, int end, int min, int max, String fName,
    Issues issues) {
  final _end = end ?? s.length;
  final _max = max ?? _end - start;
  assert(s != null &&
      start != null &&
      _end != null &&
      min != null &&
      fName != null);
  final sb = StringBuffer();
  if (s == null) {
    sb.writeln(_badArg('s', 'null', '', fName));
    parseError(sb.toString(), issues);
  }
  if (s == '') {
    sb.writeln(_badArg('s', '""', 'empty string', fName));
    parseError(sb.toString(), issues);
  }
  if (start >= s.length) {
    sb.writeln(
        _badArg('s', '$s', 'start($start) >= s.length(${s.length})', fName));
    parseError(sb.toString(), issues);
  }
  if (s.length < _end) {
    final msg = 'end($_end) => s.length(${s.length}) for "$s"';
    sb.writeln(_badArg('end', '$_end', msg, fName));
    parseError(sb.toString(), issues);
  }
  if (_end < start + min) {
    sb.writeln('The argument "end($_end)" is less than start($start) plus '
        'the minimum length($min) of s(${s.length})"$s"');
    parseError(sb.toString(), issues);
  }
  if (_end > start + _max) {
    sb.writeln('The argument "end($_end)" is less than start($start) plus '
        'the maximum length($_max) of s(${s.length})"$s"');
    parseError(sb.toString(), issues);
  }
}

/// Returns an invalid values [String].
String _badArg(String arg, String value, String msg, String fName) =>
    '$fName: Invalid argument($arg == $value) $msg';
