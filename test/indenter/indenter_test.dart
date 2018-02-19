// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'indenter/indenter_test', level: Level.info);

  test('Basic indent test', () {
    final sb = new Indenter('Start...\n')

      ..down('|')
      ..down('|')
      ..down('|')
      ..up('|')
      ..up('|')
      ..up('|');

    print('$sb');
  });

  test('Basic indent test', () {
    final sb = new Indenter('Start...\n')

      ..writeln('|')
      ..down('|')
      ..writeln('|')
      ..down('|')
      ..writeln('|')
      ..down('|')
      ..writeln('|')
      ..up('|')
      ..writeln('|')
      ..up('|')
      ..writeln('|')
      ..up('|')
      ..writeln('|');
    print('$sb');
  });

}

