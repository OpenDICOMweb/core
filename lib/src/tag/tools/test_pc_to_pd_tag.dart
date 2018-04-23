// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:core/src/tag/private/new_tag/pc_token_to_pds.dart';

void main() {
  const codes = const [
    const ['ACUSON', 0x00090e00]
  ];

  for(var entry in codes) {
    final pdTags = creatorIdMap['ACUSON'];

    print('pdTags: ');
    pdTags.entries.forEach(print);
    const n = 0x0009000e;
    print('n: $n');
    final pd0 = pdTags[0x00090e00];

    print('pd0: $n: $pd0');
    final pd = lookupPCTag(entry[0], entry[1]);
    print('pd: $pd');
  }
}


