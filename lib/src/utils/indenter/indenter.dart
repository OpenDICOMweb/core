// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See /[package]/AUTHORS file for other contributors.

//  final String newline;
//  final String space;
class Indenter extends StringBuffer {
  /// The number of additional spaces at each depth
  final int increment;
  final List<String> _indentList;

  /// The current depth.
  int _depth;

  /// Creates a new [Indenter] with [increment], which defaults to 2.
  /// If [o] is present [writeln] is used to write it to the [Indenter]
  /// [StringBuffer].
  Indenter([Object o, this.increment = 2])
      : _depth = 0,
        _indentList = (increment == 2)
            ? _indentsBy2
            : _makeIndents(defaultIndentsLength, increment),
        super((o == null) ? '' : '$o\n');

  int get depth => _depth;

  String get _indent {
    final length = _indentList.length;
    if (_depth < length) return _indentList[_depth];
    // Grow _spaceList
    final oldLength = length;
    _indentList.length = _depth + 1;
    for (var i = oldLength; i < _indentList.length; i++) {
      final space = ''.padRight(i * increment, ' ');
      _indentList[i] = space;
    }
    return _indentList[_depth];
  }

  @override
  void writeln([Object o = '']) => super.writeln('$_indent$o');

  void down([Object o = '', int count = 1]) {
    super.writeln('$_indent$o');
    _depth += count;
  }

  void indent([Object o = '', int count = 1]) => down(o, count);

  void up([Object o = '', int count = 1]) {
    _depth -= count;
    if (_depth == 0) _depth = 0;
    super.writeln('$_indent$o');
  }

  void outdent([Object o = '', int count = 1]) => up(o, count);

  void start([Object o = '', int count = 1]) {
    _depth += count;
    write('$_indent$o');
  }

  void add(Object o) => write(o);

  void addln(Object o) => writeln(o);

  void end([Object o = '', int count = 1]) {
    write('$o\n');
    _depth -= count;
  }

  static String _indentString(int depth, int increment) =>
      ''.padRight(depth * increment, ' ');

  /// The initial size of  [_indentList].
  static const int defaultIndentsLength = 12;

  /// A List of indent [String]s.
  // static final List<String> _indentsBy2 = _makeIndents(defaultIndentsLength,
  //                                                           2);

  static List<String> _makeIndents(int length, int increment) {
    final indents = new List<String>(length);
    for (var i = 0; i < length; i++) indents[i] = _indentString(i, increment);
    print(indents);
    return indents;
  }

  static final List<String> _indentsBy2 = <String>[
    '',
    '  ',
    '    ',
    '      ',
    '        ',
    '          ',
    '            ',
    '              ',
    '                ',
    '                  ',
    '                    ',
    '                      '
  ];
}