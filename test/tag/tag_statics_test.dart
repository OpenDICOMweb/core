// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  testStaticMethods();
  Server.initialize(name: 'tag_statics_test', level: Level.info);
}

void testStaticMethods() {
  group('Test Tag Static Methods', () {
    test('Group.checkPrivate', () {
      expect(Group.checkPrivate(Group.fromTag(0x00090010)), 0x09);
      expect(Group.fromTag(0x00110010), 0x11);
      expect(Group.checkPrivate(Group.fromTag(0x00110010)), 0x11);
      expect(Group.checkPrivate(Group.fromTag(0x00070010)), null);
      expect(Group.checkPrivate(Group.fromTag(0x00100021)), null);
      expect(Group.checkPrivate(Group.fromTag(0x00100010)), null);
      expect(Group.checkPrivate(Group.fromTag(0xffff0010)), null);
    });

    test('Elt.isValidPrivateDataTag', () {
      expect(Elt.isPrivateCreator(0x0010), true);
      expect(Elt.pcBase(0x0010), 0x1000);
      expect(Elt.pcLimit(0x0010), 0x10FF);
      expect(Elt.isValidPrivateData(0x1021, 0x0010), true);
      expect(Elt.isValidPrivateData(0x0021, 0x0010), false);
    });

    test('isValidPrivateDataTag', () {
      expect(Tag.isValidPrivateDataTag(0x00091021, 0x00090010), true);
      expect(Tag.isValidPrivateDataTag(0x00100021, 0x00100010), false);
    });

    test('isValidPrivateDataCode', () {
      expect(Tag.isPrivateDataCode(0x00091021), true);
      expect(Tag.isPrivateDataCode(593921), true);
      expect(Tag.isPrivateDataCode(0x00090010), false);
      expect(Tag.isPrivateDataCode(0x000900FF), false);
      expect(Tag.isPrivateDataCode(0x00100021), false);
    });
  });
}
