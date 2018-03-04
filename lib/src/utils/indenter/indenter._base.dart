// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See /[package]/AUTHORS file for other contributors.

abstract class IndenterMixin {
  // **** Interface

  int get length;

  /// Converts [o] to a [String] by invoking [Object.toString] and adds the
  /// result to this, followed by a newline.
  void write(Object o);

  /// Converts obj to a String by invoking Object.toString and adds the
  /// result to this, followed by a newline.
  void writeln([Object o]);

  // The number of spaces to indent at each [depth].
  int get tabSize;
  // The current depth of _this_.
  int get depth;
  set depth(int v);

  // **** End Interface

  int get size => tabSize * depth;

  String get spaces => ''.padRight(size);

  String get prefix => spaces;

  int get down => depth++;
  int get up => depth--;

  /// Returns the [String] that indicates the end of a line. The actual
  /// values depend on the operating system.
  String get newline => '\n';

  /// Converts [o] to a [String], calls [writeln(o)] and then increases
  /// the depth by count, which defaults to 1.
  void indent([Object o = '', int count = 1]) {
    writeln('$o');
    depth += count;
  }

  /// Dencreases the current depth by [count], which defaults to 1,
  /// then Converts calls [writeln(o)].
  void outdent([Object o = '', int count = 1]) {
    depth -= count;
    if (depth == 0) depth = 0;
    writeln('$o');
  }

  /// Starts a new line then prints [o] at the current indent, but down not
  /// terminate the line.
  void startln([Object o = '', int count = 1]) =>
    write('$prefix$o');

  /// Appends [o] as a [String] to the current line.
  void add(Object o) => write(o);

  /// Appends [o] as a [String] to the current line followed by a newline.
  void endln([Object o = '', int count = 1]) =>
    write('$o\n');

  bool get isEmpty => length == 0;
  bool get isNotEmpty => !isEmpty;

  /// Iterates over the given [objects] and [write]s them in sequence. If
  /// [separator] _isNotEmpty_ it is written after all but the last Object
  /// int the Iterable.
  void writeAll(Iterable objects, [String separator = '']);
}

abstract class FastSpaces {
  int get depth;
  int get maxDepth;
  String get spaces;

  List<String> get spacesList;

  String get prefix => (depth < maxDepth)
      ? spacesList[depth]
      : spaces;

  List<String> getSpacesList(int tabSize, [int maxDepth = 12]) {
    final indents = new List<String>(maxDepth);
    for (var i = 0; i < maxDepth; i++) indents[i] = ''.padRight(i * tabSize);
    return indents;
  }
}
