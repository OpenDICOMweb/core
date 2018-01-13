// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize();
  final s = hex8(0xff);
  log.debug('s: "$s"');

  group('Hexadecimal test', () {

    test('To Radix String', () {
      final s = hex8(0xff);
      log.debug('s: "$s"');
      expect(s == '0xff', true);
    });

  });
}
