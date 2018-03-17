// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test_tools/tools.dart';


void main() {
  Server.initialize(name: 'string testing', level: Level.debug);
  final rsg = new RSG(seed: 1);

  for (var i = 0; i < 10; i++) {
    final  vList0 = rsg.getSTList(1, 1);

    final st = new STtag(PTag.kMetaboliteMapDescription, vList0);
    assert(st.hasValidValues == true);
    assert(st.tag.isValidValuesLength(st.values), true);
    log.debug('st.values: ${st.values}');
    assert(st.values == vList0);
    //fromBytes
    log.info0('vList0[0]: ${vList0[0]}');
    final bytes =  StringBase.toBytes(vList0, kMaxShortVF);
    log.info0('bytes: $bytes');
    final st0 = new STtag.fromBytes(PTag.kMetaboliteMapDescription, bytes);
    log.info0('st0: ${st0.info}');
    assert(st0.hasValidValues);
  }
}
