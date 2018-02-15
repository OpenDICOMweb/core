// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

//TODO: use Indenter
//TODO: Merge with Indenter or flush
class IndentedStringBuffer implements StringBuffer {
  final String indent;
  //int _indentLength;
  bool _isNewline = true;
  int _level;
  StringBuffer _sb;

  IndentedStringBuffer([this.indent = '  ', Object content = '']) {
    if (indent == null) throw new ArgumentError('indent: $indent');
    //_indentLength = indent.length;
    _level = 0;
    _sb = new StringBuffer('$content');
  }

  @override
  bool get isEmpty => _sb.isEmpty;

  @override
  bool get isNotEmpty => _sb.isNotEmpty;

  @override
  int get length => _sb.length;

  int get level => _level;
  set level(int level) {
    _level = (level >= 0) ? level : 0;
  }

  @override
  void clear() {
    _isNewline = true;
    _sb.clear();
  }

  @override
  void write(Object obj) {
    if (_isNewline) _writeIndent();
    _sb.write(obj);
  }

  @override
  void writeAll(Iterable objects, [String separator = '']) {
    if (_isNewline) _writeIndent();
    _sb.writeAll(objects, separator);
  }

  @override
  void writeCharCode(int charCode) {
    if (_isNewline) _writeIndent();
    _sb.writeCharCode(charCode);
  }

  @override
  void writeln([Object obj = '']) {
    if (_isNewline) _writeIndent();
    _sb.writeln(obj);
    _isNewline = true;
  }

  void _writeIndent() {
    _sb.write(''.padRight(_level, indent));
    _isNewline = false;
  }

  @override
  String toString() => _sb.toString();
}
