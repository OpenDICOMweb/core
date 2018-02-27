// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'indenter/indenter_test', level: Level.debug);

  test('Basic indent test with depth', () {
    final sb = new Indenter();

    final expected = '''
| 0
  | 1
    | 2
      |
    | 2
  | 1
| 0
''';
    sb
      ..down('| ${sb.depth}')
      ..down('| ${sb.depth}')
      ..down('| ${sb.depth}')
      ..writeln('|')
      ..up('| ${sb.depth - 1}')
      ..up('| ${sb.depth - 1}')
      ..up('| ${sb.depth - 1}');

    final s = '$sb';
    log..debug('"$expected"')..debug('"$s"');
    expect('$sb' == expected, true);
  });

  test('Basic indent test without depth', () {
    final sb = new Indenter();
    final expected = '''  
|
  |
    |
      |
    |
  |
|
''';
    sb
      ..down('|')
      ..down('|')
      ..down('|')
      ..writeln('|')
      ..up('|')
      ..up('|')
      ..up('|');

    final s = '$sb';
    log..debug('"$expected"')..debug('"$s"');
    expect('$sb' == expected, true);
  });

  test('Basic indent test', () {
    final sb = new Indenter('Start...\n');

    sb
      ..writeln('|')
      ..down('| ${sb.depth}')
      ..writeln('|')
      ..down('| ${sb.depth}')
      ..writeln('|')
      ..down('| ${sb.depth}')
      ..writeln('|')
      ..up('| ${sb.depth}')
      ..writeln('|')
      ..up('| ${sb.depth}')
      ..writeln('|')
      ..up('| ${sb.depth}')
      ..writeln('|');
    print('$sb');
  });
}
