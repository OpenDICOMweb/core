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
  testStaticMethods();
  Server.initialize(name: 'tag_statics_test', level: Level.info);
}

void testStaticMethods() {
  group('Test Tag Static Methods', () {
    test('Group.isPrivateCode', () {
      expect(Tag.isPrivateCode(0x00090010), true);
      expect(Tag.isPrivateCode(0x00110010), true);
      expect(Tag.isPrivateCode(0x00070010), false);
      expect(Tag.isPrivateCode(0x00100021), false);
      expect(Tag.isPrivateCode(0x00100010), false);
      expect(Tag.isPrivateCode(0xffff0010), false);

      expect(Tag.privateGroup(0x00090010), 0x09);
      expect(Tag.privateGroup(0x00110010), 0x11);
      expect(Tag.privateGroup(0x00070010), null);
      expect(Tag.privateGroup(0x00100021), null);
      expect(Tag.privateGroup(0x00100010), null);
      expect(Tag.privateGroup(0xffff0010), null);
    });

    test('Group.toGroup', () {
      expect(Tag.toGroup(0x00090010), 0x09);
      expect(Tag.toGroup(0x00110010), 0x11);
      expect(Tag.toGroup(0x00070010), null);
      expect(Tag.toGroup(0x00100021), 0x10);
      expect(Tag.toGroup(0x11110010), 0x1111);
      expect(Tag.toGroup(0xffff0010), null);
    });

    test('Tag.isPrivateGroupLength', () {
      expect(Tag.isPrivateGroupLengthCode(0x00090000), true);
      expect(Tag.isPrivateGroupLengthCode(0x00090001), false);
    });

    test('Tag.isPrivateIllegal', () {
      expect(Tag.isPrivateIllegalCode(0x00090001), true);
      expect(Tag.isPrivateIllegalCode(0x0009000F), true);
      expect(Tag.isPrivateIllegalCode(0x00090000), false);
      expect(Tag.isPrivateIllegalCode(0x00090010), false);
    });

    test('Tag.isPrivateCreatorCode', () {
      expect(Tag.isPCCode(0x00090010), true);
      expect(Tag.privateCreatorBase(0x00090010), 0x1000);
      expect(Tag.privateCreatorLimit(0x00090010), 0x10FF);
    });

    test('Tag.isPrivateDataCode', () {
      expect(Tag.isPDCode(0x00091021), true);
      expect(Tag.isPDCode(0x00090021), false);
      expect(Tag.isPDCode(0x00091021, 0x00090010), true);
      expect(Tag.isPDCode(0x00090021, 0x00090010), false);
      expect(Tag.isValidPDCode(0x00091021, 0x00090010), true);
      expect(Tag.isValidPDCode(0x00090021, 0x00090010), false);
    });

    test('isValidPrivateDataTag', () {
      expect(Tag.isValidPDCode(0x00091021, 0x00090010), true);
      expect(Tag.isValidPDCode(0x00100021, 0x00100010), false);
    });

    test('isValidPrivateDataCode', () {
      expect(Tag.isPDCode(0x00091021), true);
      expect(Tag.isPDCode(593921), true);
      expect(Tag.isPDCode(0x00090010), false);
      expect(Tag.isPDCode(0x000900FF), false);
      expect(Tag.isPDCode(0x00100021), false);
    });
  });
}
