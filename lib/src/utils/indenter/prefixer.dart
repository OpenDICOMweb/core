// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

/// A utility for prefixing printed lines with line numbers, a [prefix],
/// spaces and a [String]. The format of the prefix generated is:
///     ```$lineNo$prefix$spaces```.
/// Any formatting before the [prefix], e.g. a space character, or after the
/// [prefix], e.g. a ":", should be included in the [prefix].
class Prefixer {
  /// The maximum line number based on the [lineNumberWidth].
  final int _maxLineNumber;

  /// The [int] number of the last line printed.
  int _line = -1;

  /// The width in characters of the line counter.  Once the [lineNumberWidth]
  /// has all 9s it roles over to all 0s.  If the [lineNumberWidth] <= 0,
  /// no line numbers are printed. If [lineNumberWidth] < 0, then line numbers
  /// are not printed. This is the default behaviour.
  final int lineNumberWidth;

  /// The radix of the line number. Defaults to 10.
  final int lineNoRadix;

  /// The character used to padLeft the [_line] number. Defaults to "0".
  final String lineNoPadChar;

  /// The level of the [Prefixer].  Each time the [Prefixer] descends into
  /// a new [Object] the level should be increased by 1 using [down] and
  /// before returning, decreased by 1 using [up].
  int _level = 0;

  /// The number of spaces to indent for each level.
  int indent;

  /// A String between [lineNo] and [spaces]. Defaults to " ".
  String prefix;

  Prefixer(
      {this.lineNumberWidth = -1,
      this.lineNoRadix = 10,
      this.lineNoPadChar = '0',
      this.prefix = '',
      this.indent = 2})
      : _maxLineNumber = (lineNumberWidth <= 0)
            ? -1
            : int.parse(''.padRight(lineNumberWidth, '9'));

  int get reset => _level = 0;
  int get level => _level;
  int get down => _level++;
  int get up => _level--;
  int get up2 => _level -= 2;

  String get lineNo {
    if (lineNumberWidth <= 0) return '';
    if (_line++ > _maxLineNumber) _line = 0;
    return _line
        .toRadixString(lineNoRadix)
        .padLeft(lineNumberWidth, lineNoPadChar);
  }

  String get spaces {
    final count = indent * _level;
    return (count <= 0) ? '' : ''.padRight(count, ' ');
  }

  /// Returns the current Line indentation.
  String get z => '$lineNo$prefix$spaces';

  String get info => '''
Prefixer: z: '$z' spaces: $spaces level: $_level, indent: $indent,
  prefix: $prefix, line: $_line, maxLine: $_maxLineNumber,
  width: $lineNumberWidth, radix: $lineNoRadix, padChar: '$lineNoPadChar'
''';

  String call(String s, [String pre]) {
    final p = (pre == null) ? prefix : pre;
    final out = '$lineNo$p$spaces$s';
    return out;
  }

  int inc([int n = 1]) {
    _level += n;
    if (_level < 0) _level = 0;
    return _level;
  }

  int dec([int n = 1]) => _level -= n;

  @override
  String toString() => '$runtimeType';

  static Prefixer get basic => new Prefixer();
  static Prefixer get lineNumbers => new Prefixer(lineNumberWidth: 5);
}
