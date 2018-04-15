//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//


import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'synchronization_frame_test', level: Level.info);

  group('SynchronizationFrameOfReference', () {
    test('String to UID', () {
      Uid uid = Uid.lookup('1.2.840.10008.15.1.1');
      expect(uid == WKUid.kUniversalCoordinatedTime,
          true);

      uid = Uid.lookup('1.2.840.10008.15.1.1');
      expect(uid == WKUid.kUniversalCoordinatedTime,
          true);

      uid = Uid.lookup('1.2.840.10008.15.1.2');
      expect(uid == WKUid.kUniversalCoordinatedTime,
          false);
    });

    test('String to SynchronizationFrameOfReference', () {
      Uid uid = WKUid.lookup('1.2.840.10008.15.1.1');
      expect(uid == WKUid.kUniversalCoordinatedTime,
          true);

      uid = WKUid.lookup('1.2.840.10008.15.1.1');
      expect(uid == WKUid.kUniversalCoordinatedTime,
          true);
    });

    test('Create SynchronizationFrameOfReference', () {
      const sfr0 = WKUid.kUniversalCoordinatedTime;
      const sfr1 = WKUid.kUniversalCoordinatedTime;

      expect(sfr0.hashCode == sfr1.hashCode, true);
      expect(sfr0.value == sfr1.value, true);
      expect(sfr0.name == 'Universal Coordinated Time', true);
      expect(sfr0.keyword == 'UniversalCoordinatedTime', true);
      expect(sfr0.value == '1.2.840.10008.15.1.1', true);
      expect(sfr0.type == UidType.kSynchronizationFrameOfReference, true);
      expect(sfr0.maxLength == 64, true);
      expect(sfr0.minLength == 6, true);
      expect(sfr0.maxRootLength == 24, true);
    });
  });
}
