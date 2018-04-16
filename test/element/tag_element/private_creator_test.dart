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
  Server.initialize(name: 'element/private_creator_test', level: Level.info);

  group('Private Creator tests', () {
    test('Valid Unknown Private Creator ', () {
      const name0 = 'Unknown Creator Tag';
      final pcTag0 = PCTag.make(0x00090010, kLOIndex, name0);
      log.debug('pcTag0: ${pcTag0.info}');
      expect(pcTag0.isValid, true);
      final pc0 = new LOtag(pcTag0, [name0]);
      log.debug('pc0: ${pc0.info}');
      expect(pcTag0.isValidValues(pc0.values), true);

      const name1 = 'Foo';
      final pcTag1 = PCTag.make(0x000900FF, kLOIndex, name1);
      log.debug('pcTag1: ${pcTag1.info}');
      expect(pcTag1.isValid, true);
      final pc1 = new LOtag(pcTag1, [name1]);
      log.debug('PC: ${pc1.info}');
      expect(pcTag1.isValidValues(pc1.values), true);
    });

    test('Invalid Unknown Private Creator ', () {
      const name0 = 'Bad Offset';
      final pcTag0 = PCTag.make(0x00090009, kLOIndex, name0);
      log.debug('pcTag0: ${pcTag0.info}');
      expect(pcTag0.isValid, false);
      // Test for exception thrown
      system.throwOnError = true;

      expect(() => new LOtag(pcTag0, [name0, 'FOO']),
          throwsA(const isInstanceOf<InvalidValuesLengthError>()));

      const name1 = 'Bad Offset';
      final pcTag1 = PCTag.make(0x00090100, kLOIndex, name1);
      log.debug('pcTag1: ${pcTag1.info}');
      expect(pcTag1.isValid, false);
      expect(() => new LOtag(pcTag0, [name1, null]),
          throwsA(const isInstanceOf<InvalidValuesLengthError>()));

      const name2 = 'Bad Offset';
      final pcTag2 = PCTag.make(0x00090000, kLOIndex, name2);
      log.debug('pcTag2: ${pcTag2.info}');
      expect(pcTag1.isValid, false);

      system.throwOnError = false;
      final pc2 = new LOtag(pcTag1, [name2, '']);
      expect(pc2, isNull);

      system.throwOnError = true;
      expect(() => new LOtag(pcTag1, [name2, '']),
          throwsA(const isInstanceOf<InvalidValuesLengthError>()));

      const name3 = 'Bad Tag';
      final pcTag3 = PCTag.make(0x00090000, kLOIndex, name3);
      log.debug('pcTag3: ${pcTag3.info}');
      expect(pcTag1.isValid, false);

      system.throwOnError = false;
      final pc3 = new LOtag(pcTag3, [name3, '']);
      expect(pc3, isNull);

      system.throwOnError = true;
      expect(() => new LOtag(pcTag3, [name3, '']),
          throwsA(const isInstanceOf<InvalidValuesLengthError>()));
    });

    test('Valid Known Private Creator ', () {
      const name0 = 'AGFA';
      final pcTag0 = PCTag.make(0x00090010, kLOIndex, name0);
      log.debug('pcTag0: ${pcTag0.info}');
      expect(pcTag0.isValid, true);
      final pc0 = new LOtag(pcTag0, [name0]);
      log.debug('pc0: ${pc0.info}');
      expect(pcTag0.isValidValues(pc0.values), true);

      const name1 = 'ACUSON';
      final pcTag1 = PCTag.make(0x000900FF, kLOIndex, name1);
      log.debug('pcTag1: ${pcTag1.info}');
      expect(pcTag1.isValid, true);
      final pc1 = new LOtag(pcTag1, [name1]);
      log.debug('PC: ${pc1.info}');
      expect(pcTag1.isValidValues(pc1.values), true);
    });

    test('Valid Agfa 0009 Private Data', () {
      // Group 0009 creator
      const agfa = 'AGFA';
      final pcTag0 = PCTag.make(0x00090010, kLOIndex, agfa);
      expect(pcTag0.isValid, true);
      log.debug('pcTag0: $pcTag0');
      final pc0 = new LOtag(pcTag0, [agfa]);
      expect(pcTag0.isValid, true);
      log.debug('pc0: ${pc0.info}');

      // valid LOtag data
      const value1 = 'Some Random Data String';
      final pdTag1 = PDTag.make(0x00091010, kLOIndex, pcTag0);
      log.debug('pdTag1.isValid: ${pdTag1.info}');
      expect(pdTag1.isValid, true);
      log.debug('pdTag1: ${pdTag1.info}');
      final pd1 = new LOtag(pdTag1, [value1]);
      expect(pdTag1.isValidValues(pd1.values), true);
      log.debug('pd1: ${pd1.info}');
    });

    test('Valid Agfa 0019 Private Data', () {
      const agfa = 'AGFA';

      // Group 0019 creator
      final pcTag = PCTag.make(0x001900FF, kLOIndex, agfa);
      expect(pcTag.isValid, true);
      log.debug('pcTag: $pcTag');
      final pc0 = new LOtag(pcTag, [agfa]);
      expect(pcTag.isValidValues(pc0.values), true);
      log.debug('pc0: ${pc0.info}');
    });

    test('Valid Agfa Private Data', () {
      system.throwOnError = false;
      const agfa = 'AGFA';
      final pcTag = PCTag.make(0x001900FF, kLOIndex, agfa);
      const value0 = 'Some Random Data String';
      final pdTag0 = PDTag.make(0x0019FF05, kSTIndex, pcTag);
      log.debug('pdTag0: ${pdTag0.info}');
      expect(pdTag0.isValid, true);
      log.debug('pdTag0.isValid: ${pdTag0.isValid}');
      final pd0 = new LOtag(pdTag0, [value0]);
      expect(pd0, isNull);
    });
  });
}
