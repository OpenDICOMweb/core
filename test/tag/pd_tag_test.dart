// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';


void main() {
  privateDataTag();
  Server.initialize(name: 'pd_tag_test', level: Level.info);
}

void privateDataTag() {
  test('PrivatedataTag Test', () {
    final code = 0x00190010;
    final pcTag = new PCTag(code, kLOIndex, 'Unknown');
    final pdt = new PDTag(code, kUNIndex, pcTag);
    expect((pdt.isPrivate), true);
    expect((pdt.isCreator), false);
    log.debug(pdt.toString());
  });
}
