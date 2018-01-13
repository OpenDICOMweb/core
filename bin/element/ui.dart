// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.


import 'package:core/core.dart';
import 'package:test_tools/tools.dart';


void main(List<String> args) {
  final rsg = new RSG(seed: 0);
  print('wkUid.lenght: ${wkUids.length}');
  //hasValidValues: good values
  List<String> vList0;
  for (var i = 0; i < 100; i++) {
    vList0 = rsg.getUIList(1, 1);
    print('$i: vList0: $vList0');
    final ui = new UItag(PTag.kStudyInstanceUID, vList0);
    assert(ui.hasValidValues, true);
  }
}
