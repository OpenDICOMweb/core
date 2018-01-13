// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'logger/indenter_test', level: Level.info);
  test('Basic indent test', () {
    final z = new Indenter();

    log.debug('"${z.z}"');
    z.down;
    log.debug('"${z.z}"');
    z.down;
    log.debug('"${z.z}"');
    z.down;
    log.debug('"${z.z}"');
    z.up;
    log.debug('"${z.z}"');
    z.up;
    log.debug('"${z.z}"');
    z.up;
    log.debug('"${z.z}"');
  });
}

