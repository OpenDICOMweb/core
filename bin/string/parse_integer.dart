//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/server.dart';

void main() {
  Server.initialize(name: 'string testing', level: Level.debug);

  const goodIntegerStrings = <String>[
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

  for (final s in goodIntegerStrings) {
    final n = int.parse(s);
    print('s: "$s" n: $n');
  }
}
