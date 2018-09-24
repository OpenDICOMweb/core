//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

/// The following data are generate with tools/generate_data.dart.import '

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

import 'data.dart';

/// Assert that the data above are valid.
void main() {
  const typeChars = <String>['8', '9', 'a', 'b'];

  Server.initialize(name: 'data_test', level: Level.info);
  String version;
  String type;
  Uuid.useUppercase = false;
  test('Test Generated Data', () {
    expect(uuidD0 == uuidS0, true);
    log.debug(uuidD0);
    version = s0[14];
    log.debug('version: $version');
    expect(s0[14] == '4', true);
    type = s0[19];
    log.debug('type: $type');
    expect(typeChars.contains(s0[19]), true);

    expect(uuidD1 == uuidS1, true);
    version = s1[14];
    log.debug('version: $version');
    expect(s1[14] == '4', true);
    type = s1[19];
    log.debug('type: $type');
    expect(typeChars.contains(s1[19]), true);

    expect(uuidD2 == uuidS2, true);
    version = s2[14];
    log.debug('version: $version');
    expect(s2[14] == '4', true);
    type = s2[19];
    log.debug('type: $type');
    expect(typeChars.contains(s2[19]), true);

    expect(uuidD3 == uuidS3, true);
    version = s3[14];
    log.debug('version: $version');
    expect(s3[14] == '4', true);
    type = s3[19];
    log.debug('type: $type');
    expect(typeChars.contains(s3[19]), true);

    expect(uuidD4 == uuidS4, true);
    version = s4[14];
    log.debug('version: $version');
    expect(s4[14] == '4', true);
    type = s4[19];
    log.debug('type: $type');
    expect(typeChars.contains(s4[19]), true);

    expect(uuidD5 == uuidS5, true);
    version = s5[14];
    log.debug('version: $version');
    expect(s5[14] == '4', true);
    type = s5[19];
    log.debug('type: $type');
    expect(typeChars.contains(s5[19]), true);

    expect(uuidD6 == uuidS6, true);
    version = s6[14];
    log.debug('version: $version');
    expect(s6[14] == '4', true);
    type = s6[19];
    log.debug('type: $type');
    expect(typeChars.contains(s6[19]), true);

    expect(uuidD7 == uuidS7, true);
    version = s7[14];
    log.debug('version: $version');
    expect(s7[14] == '4', true);
    type = s7[19];
    log.debug('type: $type');
    expect(typeChars.contains(s7[19]), true);

    expect(uuidD8 == uuidS8, true);
    version = s8[14];
    log.debug('version: $version');
    expect(s8[14] == '4', true);
    type = s8[19];
    log.debug('type: $type');
    expect(typeChars.contains(s8[19]), true);

    expect(uuidD9 == uuidS9, true);
    version = s9[14];
    log.debug('version: $version');
    expect(s9[14] == '4', true);
    type = s9[19];
    log.debug('type: $type');
    expect(typeChars.contains(s9[19]), true);
  });
}
