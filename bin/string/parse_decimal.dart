// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';

void main() {
  Server.initialize(name: 'string testing', level: Level.debug);

  const goodDecimalStrings = const <String>[
    '567',
    ' 567',
    '567 ',
    ' 567 ',
    '-6.60',
    '-6.60 ',
    ' -6.60 ',
    ' -6.60 ',
    '+6.60',
    '+6.60 ',
    ' +6.60 ',
    ' +6.60 ',
    '0.7591109678',
    '-6.1e-1',
    ' -6.1e-1',
    '-6.1e-1 ',
    ' -6.1e-1 ',
    '+6.1e+1',
    ' +6.1e+1',
    '+6.1e+1 ',
    ' +6.1e+1 ',
    '+1.5e-1',
    ' +1.5e-1',
    '+1.5e-1 ',
    ' +1.5e-1 '
  ];

  double v;

  for (var s in goodDecimalStrings) {
    final n = double.parse(s);
    print('s: "$s" n: $n');
  }
}
