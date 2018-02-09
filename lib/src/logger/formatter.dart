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

  Formatter.basic([this.maxDepth = -1]) : indenter = Indenter.basic;

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
  String callNew([Object o, Object values]) {
    var depth = 0;
    final sb = new StringBuffer('$z$o');
    if (values == null) return '$sb';
    down;
    try {
      while (!atMaxDepth(depth++))
        if (values is Iterable) {
          var depth = 0;
          for (var value in values) {
            if (value is Formattable) {
              try {
                sb.write(value.format(this));
                if (atMaxDepth(depth++)) break;
              } on NoSuchMethodError {
                sb.write('$z$value\n');
              }
            }
          }
        } else if (values is Formattable) {
          sb.write(values.format(this));
        } else {
          sb.write('$z$values\n');
        }
    } on NoSuchMethodError {
      if (values != null) sb.write('$z$values\n');
    } finally {
      up;
    }
    return '$sb';
  }

  //TODO: Test values argument.
  String call([Object o, Iterable values]) {
    final sb = new StringBuffer('$z$o');
    if (values == null) return '$sb';
    block:
    {
      down;
      if (values is Iterable) {
        var depth = 0;
        for (var value in values) {
          if (value is Formattable) {
            try {
              sb.write(value.format(this));
            } on NoSuchMethodError {
              sb.write('$z$value\n');
            }
            if (atMaxDepth(depth++)) break block;
          }
        }
      } else {
        if (values is Formattable) {
          sb.write(values.format(this));
          if (atMaxDepth(_depth++)) break block;
        }
      }
    }
    up;
    return '$sb';
  }

  String fmt(Object o, [Object values]) {
    var depth = 0;
    final sb = new StringBuffer('$z$o\n');
    if (values == null) return '$sb';
    try {
      block:
      {
        down;
        if (values is Iterable) {
          print('fmt: $o values: "$values"');
          var depth = 0;
          for (var value in values) {
            try {
              sb.write(value.format(this));
            } on NoSuchMethodError {
              sb.write('$z$value\n');
            }
            if (atMaxDepth(depth++)) break block;
          }
        } else if (values is Formattable) {
          sb.write(values.format(this));
          if (atMaxDepth(depth++)) break block;
        } else {
          sb.write('$z$values\n');
          if (atMaxDepth(depth++)) break block;
        }
      }
    } on NoSuchMethodError {
      if (values != null) sb.write('$z$values\n');
    } finally {
      up;
    }
    return '$sb';
  }

  String fmtNew(Object o, [Object values]) {
    var depth = 0;
    final sb = new StringBuffer('$z$o\n');
    if (values == null) return '$sb';
    down;
    try {
      while (!atMaxDepth(depth++)) {
        if (values is Iterable) {
          var depth = 0;
          for (var value in values) {
            try {
              sb.write(value.format(this));
              if (atMaxDepth(depth++)) break;
            } on NoSuchMethodError {
              sb.write('$z$value\n');
            }
          }
        } else if (values is Formattable) {
          sb.write(values.format(this));
        } else {
          sb.write('$z$values\n');
        }
      }
    } on NoSuchMethodError {
      if (values != null) sb.write('$z$values\n');
    } finally {
      up;
    }
    return '$sb';
  }

  @override
  String noSuchMethod(Invocation invocation) {
    final args = invocation.positionalArguments;
    if (args.isEmpty) return '';
    return (args.length == 1) ? '$z${args[0]}\n' : '$z$args\n';
  }
}
