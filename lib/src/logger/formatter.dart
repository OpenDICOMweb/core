// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/logger/indenter.dart';

abstract class Formattable<T> implements Iterable<T> {
  @override
  Iterator<T> get iterator;
  bool get moveNext;
  String format(Formatter v);
  String fmt(Formatter v);
}

// TODO: add SprintF style formatting to formatter
// TODO: add DICOM methods to Sprintf (dcm, vr, ...)
class Formatter {
  //static final Logger log = new Logger('Formatter');

  /// The number of Objects to format at one Level before returning to the previous
  /// level.  If this number isNegative all Objects will be formatted.
  final int maxDepth;

  /// The [Indenter] used by this formatter.
  final Indenter indenter;

  Formatter(
      {this.maxDepth = 10,
      int lineNoWidth = 5,
      int lineNoRadix = 10,
      String lineNoPadChar = '0',
      String prefix = ' ',
      int indent = 2})
      : indenter = new Indenter(
            lineNumberWidth: lineNoWidth,
            lineNoRadix: lineNoRadix,
            lineNoPadChar: lineNoPadChar,
            prefix: prefix,
            indent: indent);

  Formatter.withIndenter(this.maxDepth, this.indenter);

  int get reset => indenter.reset;
  int get level => indenter.level;
  int get down => indenter.down;
  int get up => indenter.up;
  int get up2 => indenter.up2;

  String get z => indenter.z;

  int _depth;
  int get depthZero => _depth = 0;

  bool atMaxDepth(int depth) {
    //  log.debug('maxDepth: $maxDepth, depth: $depth');
    if (maxDepth < 0 || depth < maxDepth) return false;
    _depth = 0;
    return true;
  }

  //TODO: Test values argument.
  String call([Object o, Iterable values]) {
    final sb = new StringBuffer('$z$o');
    if (values == null) return sb.toString();
    block:
    {
      down;
      if (values is Iterable) {
        var depth = 0;
        var count = 0;
        for (var value in values) {
          if (value is Formattable) {
            try {
              sb.write(value.fmt(this));
            } on NoSuchMethodError {
              sb.write(value.toString());
            }
            if (count++ > 100 || atMaxDepth(depth++)) break block;
          }
        }
      } else {
        if (values is Formattable) {
          sb.write(values.fmt(this));
          if (atMaxDepth(_depth++)) break block;
        }
      }
    }
    up;
    return sb.toString();
  }

  String fmt(Object o, [Object values]) {
    var depth = 0;
    if (values == null) return '$z$o\n';
    final sb = new StringBuffer('$z$o\n');
    try {
      block:
      {
        down;
        if (values is Iterable) {
          var depth = 0;
          var count = 0;
          for (var value in values) {
            sb.write(value.format(this));
            if (count++ > 100 || atMaxDepth(depth++)) break block;
          }
        } else if (values is Formattable) {
          sb.write(values.format(this));
          if (atMaxDepth(depth++)) break block;
        }
      }
    } on NoSuchMethodError {
//      log.debug('no such method: $values');
      if (values != null) sb.write('$z$values\n');
    } finally {
      up;
    }
    return sb.toString();
  }

  @override
  String noSuchMethod(Invocation invocation) {
    final args = invocation.positionalArguments;
    if (args.isEmpty) return '';
    return (args.length == 1) ? '$z${args[0]}\n' : '$z$args\n';
  }
}
