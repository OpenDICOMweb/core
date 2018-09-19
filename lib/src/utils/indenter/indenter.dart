//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/utils/indenter/indenter._base.dart';

// ignore_for_file: public_member_api_docs

class Indenter extends Object with IndenterMixin implements StringBuffer {
  final StringBuffer sb;

  /// The maximum length of any line. If the current line is
  /// greater than the maximum length, it with overflow to the next
  /// line with a depth that is the current [depth] + 2.
  final int maxLength = 80;
  // The number of spaces to indent at each [depth].
  @override
  final int tabSize;
  // The current depth of _this_.
  @override
  int depth;

  Indenter([Object o = '', this.tabSize = 2, this.depth = 0])
      : sb = new StringBuffer(o);

  Indenter.from(Indenter indenter)
      : sb = new StringBuffer(),
        tabSize = indenter.tabSize,
        depth = indenter.depth;

  @override
  int get length => sb.length;

  @override
  void write(Object o) => sb.write(o);

  @override
  void writeln([Object o]) =>
      (tabSize == 0) ? sb.write(o) : sb.writeln('$prefix$o');

  @override
  void writeAll(Iterable objects, [String separator = '']) =>
      sb.writeAll(objects, separator);

  void writeList(Iterable objects, [String separator = '']) =>
    sb
      ..write('[')
      ..writeAll(objects, separator)
      ..write(']');

  void _writeKeyValuePair(String key, Object value) =>
      sb.writeln('$key : $value');

  void writeMap(Map<String, Object> map) {
    indent('{');
    map.forEach(_writeKeyValuePair);
    outdent('}');
  }

  @override
  void clear() => sb.clear;

  @override
  void writeCharCode(int charCode) => sb.writeCharCode(charCode);

  @override
  String toString() => sb.toString();
}
