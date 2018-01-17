// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';

void main() {
  Server.initialize(name: 'string testing', level: Level.debug);

  const goodIntegerStrings = const <String>[
    '+8',
    ' +8',
    '+8 ',
    ' +8 ',
    '-8',
    ' -8',
    '-8 ',
    ' -8 ',
    '-6',
    '560',
    '0',
    '-67',
  ];

  for (var s in goodIntegerStrings) {
    final n = int.parse(s);
    print('s: "$s" n: $n');
  }
}
