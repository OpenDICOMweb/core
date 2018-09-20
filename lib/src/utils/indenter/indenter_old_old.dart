//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

// ignore_for_file: public_member_api_docs

/// A StringBuffer the supports indentation
class IndenterOld implements StringBuffer {
  final String increment;
  //int _indentLength;
  bool _isNewline = true;
  int _depth;
  StringBuffer _sb;

  IndenterOld([Object content = '', this.increment = '  ']) {
    if (increment == null) throw ArgumentError('indent: $increment');
    //_indentLength = indent.length;
    _depth = 0;
    _sb = StringBuffer('$content');
  }

  @override
  bool get isEmpty => _sb.isEmpty;

  @override
  bool get isNotEmpty => _sb.isNotEmpty;

  @override
  int get length => _sb.length;

  int get level => _depth;
  set level(int level) {
    _depth = (level >= 0) ? level : 0;
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
    _sb.write(''.padRight(_depth, increment));
    _isNewline = false;
  }

  @override
  String toString() => _sb.toString();
}
