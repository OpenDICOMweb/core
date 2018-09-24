//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

void main() {
  privateDataTag();
  Server.initialize(name: 'pd_tag_test', level: Level.info);
}

void privateDataTag() {
  test('PrivatedataTag Test', () {
    const code = 0x00190010;
    final pcTag = PCTag.make(code, kLOIndex, 'Unknown');
    final pdt = PDTag.make(code, kUNIndex, pcTag);
    expect(pdt.isPrivate, true);
    expect(pdt.isCreator, false);
    log.debug(pdt.toString());
  });
}
