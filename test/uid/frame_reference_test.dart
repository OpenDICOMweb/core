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
  Server.initialize(name: 'uid/frame_of_reference_test', level: Level.info);

  group('FrameOfReference', () {
    test('String to UID', () {
      Uid uid = Uid.lookup('1.2.840.10008.1.4.1.1');
      expect(
          uid == FrameOfReference.kTalairachBrainAtlasFrameOfReference, true);

      uid = Uid.lookup('1.2.840.10008.1.4.1.2');
      expect(uid == FrameOfReference.kSPM2T1FrameOfReference, true);

      uid = Uid.lookup('1.2.840.10008.7.1.3');
      expect(uid == FrameOfReference.kSPM2T1FrameOfReference, false);
    });

    test('String to LdapOid', () {
      Uid uid = FrameOfReference.lookup('1.2.840.10008.1.4.1.2');
      expect(uid == FrameOfReference.kSPM2T1FrameOfReference, true);

      uid = FrameOfReference.lookup('1.2.840.10008.15.0.3.2');
      expect(uid == FrameOfReference.kSPM2T1FrameOfReference, false);
    });

    test('Create FrameOfReference', () {
      const fr0 = FrameOfReference(
          '1.2.840.10008.1.4.1.2',
          'SPM2T1FrameofReference',
          UidType.kFrameOfReference,
          'SPM2 T1 Frame of Reference');

      const fr1 = FrameOfReference(
          '1.2.840.10008.1.4.1.2',
          'SPM2T1FrameofReference',
          UidType.kFrameOfReference,
          'SPM2 T1 Frame of Reference');

      const fr2 = FrameOfReference(
          '1.2.840.10008.1.4.1.3',
          'SPM2T2FrameofReference',
          UidType.kFrameOfReference,
          'SPM2 T2 Frame of Reference');

      expect(fr0.hashCode == fr1.hashCode, true);
      expect(fr0.hashCode == fr2.hashCode, false);

      expect(fr0.value == fr1.value, true);
      expect(fr0.value == fr2.value, false);

      expect(fr0.name == 'SPM2 T1 Frame of Reference', true);
      expect(fr0.keyword == 'SPM2T1FrameofReference', true);
      expect(fr0.value == '1.2.840.10008.1.4.1.2', true);
      expect(fr0.type == UidType.kFrameOfReference, true);
      expect(fr0 is FrameOfReference, true);
      expect(fr0.maxLength == kUidMaxLength, true);
      expect(fr0.minLength == kUidMinLength, true);
      expect(fr0.maxRootLength == kUidMaxRootLength, true);
    });
  });
}
