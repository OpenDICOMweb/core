// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'indenter/indenter_test', level: Level.info);

  test('Basic indent test with depth', () {
    final sb = new Indenter();

    final expected = '''

| 0
  | 1
    | 2
      | 3
    | 2
  | 1
| 0
''';
    sb
      ..indent('\n| ${sb.depth}')
      ..indent('| ${sb.depth}')
      ..indent('| ${sb.depth}')
      ..writeln('| ${sb.depth}')
      ..outdent('| ${sb.depth - 1}')
      ..outdent('| ${sb.depth - 1}')
      ..outdent('| ${sb.depth - 1}');

    final s = '$sb';
    log..debug('"$expected"')..debug('"\n$s"');
    expect('$sb' == expected, true);
  });

  test('Basic indent test without depth', () {
    final sb = new Indenter();
    final expected =
    '''  

|
  |
    |
      |
    |
  |
|
''';
    sb
      ..indent('\n|')
      ..indent('|')
      ..indent('|')
      ..writeln('|')
      ..outdent('|')
      ..outdent('|')
      ..outdent('|');

    final s = '$sb';
    log..debug('"$expected"')..debug('"$s"');
    expect('$sb' == expected, true);
  });

  test('Basic indent test', () {
    final sb = new Indenter('Start...\n');

    sb
      ..writeln('|')
      ..indent('| ${sb.depth}')
      ..writeln('|')
      ..indent('| ${sb.depth}')
      ..writeln('|')
      ..indent('| ${sb.depth}')
      ..writeln('|')
      ..outdent('| ${sb.depth}')
      ..writeln('|')
      ..outdent('| ${sb.depth}')
      ..writeln('|')
      ..outdent('| ${sb.depth}')
      ..writeln('|');
    print('$sb');
  });
}
