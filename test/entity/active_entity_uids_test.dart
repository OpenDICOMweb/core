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


// Urgent Sharath: improve this test. See src/entity/active_studies.dart.

void main() {
  const goodUidStrings = [
    '1.2.840.10008.1.2.4.100',
    '1.2.840.10008.1.2.5'
  ];

  final goodUids = [
    Uid('1.2.840.10008.1.2.4.100'),
    Uid('1.2.840.10008.1.2.5')
  ];

  group('ActiveEntityUids Test', () {
    test('Add Strings Test', () {
      for (var i = 0; i < goodUidStrings.length; i++ ) {
        final u = activeEntityUids.addIfAbsent(goodUidStrings[i]);
        expect(u, equals(goodUids[i]));
      }
    });
  });
}
