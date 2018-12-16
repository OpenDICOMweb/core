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
  Server.initialize(name: 'deid_dates_test.dart', level: Level.info);

  test('deIdDateCodes', () {
    for (var i = 0; i < deIdDateTags.length; i++) {
      expect(deIdDateTags[i].code == deIdDateCodes[i], true);
      expect(deIdDateTags[i].index == deIdDateCodes.elementAt(i), true);
      expect(deIdDateTags[i].vr == VR.kDA, true);
      expect(deIdDateTags[i].code == deIdDeleteDateCodes[i], true);
      expect(deIdDateTags[i].vrCode == VR.kDA.code, true);
    }
    expect(deIdDateCodes.length == deIdDateTags.length, true);
    expect(deIdDateCodes.length == deIdDeleteDateCodes.length, true);
    expect(deIdDateTags.length == deIdDeleteDateCodes.length, true);
    expect(deIdDateTags.length == deIdUpdateDateCodes.length, true);
    expect(deIdDateCodes.length == deIdUpdateDateCodes.length, true);
    expect(deIdDateTags[0].vrId == VR.kDA.id, true);
  });
}
