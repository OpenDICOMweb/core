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
  Server.initialize(name: 'active_entity_uids_test', level: Level.info);

  const goodUidStrings = [
    '1.2.840.10008.1.2.4.100',
    '1.2.840.10008.1.2.5',
    '1.2.840.10008.1.2',
    '1.2.840.10008.1.2.0',
    '1.2.840.10008.0.1.2',
    '1.2.840.10008.1.2.4.64',
    '1.2.840.10008.1.2.1',
    '1.2.840.10008.1.2.1.99',
    '1.2.840.10008.1.2.4.81',
    '1.2.840.10008.1.2.4.91',
    '1.23.9.99.0.345.3242.12.345.35'
  ];

  final goodUids = [
    Uid('1.2.840.10008.1.2.4.100'),
    Uid('1.2.840.10008.1.2.5'),
    Uid('1.2.840.10008.1.2'),
    Uid('1.2.840.10008.1.2.0'),
    Uid('1.2.840.10008.0.1.2'),
    Uid('1.2.840.10008.1.2.4.64'),
    Uid('1.2.840.10008.1.2.1'),
    Uid('1.2.840.10008.1.2.1.99'),
    Uid('1.2.840.10008.1.2.4.81'),
    Uid('1.2.840.10008.1.2.4.91'),
    Uid('1.23.9.99.0.345.3242.12.345.35')
  ];

  const badUids = <String>[
    '1.2.3', // Invalid Length : length less than 6
    '3.2.840.10008.1.2.0', // '3.': not valid root
    '1.02.840.10008.1.2', // '.02': '0' can only be followed by '.'
    '1.2.840.10008.0.1.2.', // '.2.': uid can't end with dot
    '.2.840.10008.0.1.2', // '.2.': uid can't start with dot
    '1.).840.10008.0.*.2.', // Special characters
    '1.2.840.10008.1.2.-4.64', // '-': uid can't have a negative number
    // Invalid Length : length greater than 64
    '1.4.1.2.840.10008.1.2.4.64.1.2.840.10008.1.2.4.64.1.2.840.10008.1.2.4.64',
    '0.0.000.00000.0.0.00',
    '1.2.a840.1b0008.1.2.4.64', // Uid can't have letters
    '1.2.840.10a08.0.1.2' // letters can't be used
  ];

  group('ActiveEntityUids Test', () {
    test('Add Strings Test', () {
      global.throwOnError = false;
      for (var i = 0; i < goodUidStrings.length; i++) {
        final u = activeEntityUids.addIfAbsent(goodUidStrings[i]);
        expect(u, equals(goodUids[i]));
      }

      for (var i = 0; i < goodUids.length; i++) {
        var s = goodUids[i].asString;
        final u = activeEntityUids.addIfAbsent(s);
        expect(u, equals(goodUids[i]));
      }

      for (var i = 0; i < badUids.length; i++) {
        global.throwOnError = false;
        final u = activeEntityUids.addIfAbsent(badUids[i]);
        expect(u, isNull);
        global.throwOnError = true;
        expect(() => activeEntityUids.addIfAbsent(badUids[i]),
            throwsA(const TypeMatcher<InvalidUidError>()));
      }
    });
  });
}
