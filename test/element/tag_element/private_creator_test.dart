// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.


import 'package:core/server.dart';
import 'package:tag/tag.dart';
import 'package:test/test.dart';

void main() {
  privateCreatorTest();
}

void privateCreatorTest() {
  Server.initialize(name: 'element/private_creator_test', level: Level.debug2);

  test('Valid Unknown Private Creator ', () {
	  final name0 = 'Unknown Creator Tag';
	  final pcTag0 = new PCTag(0x00090010, kLOIndex, name0);
    log.debug('pcTag0: ${pcTag0.info}');
    expect(pcTag0.isValid, true);
	  final pc0 = new LOtag(pcTag0, [name0]);
    log.debug('pc0: ${pc0.info}');
//Urgent Jim
//    expect(pcTag0.isValidValues(pc0.values), true);

	  final name1 = 'Foo';
	  final pcTag1 = new PCTag(0x000900FF, kLOIndex, name1);
    log.debug('pcTag1: ${pcTag1.info}');
    expect(pcTag1.isValid, true);
	  final pc1 = new LOtag(pcTag1, [name1]);
    log.debug('PC: ${pc1.info}');
//Urgent Jim
//    expect(pcTag1.isValidValues(pc1.values), true);
  });

  test('Invalid Unknown Private Creator ', () {
	  final name0 = 'Bad Offset';
	  final pcTag0 = new PCTag(0x00090009, kLOIndex, name0);
    log.debug('pcTag0: ${pcTag0.info}');
    expect(pcTag0.isValid, false);
  // Test for exception thrown
  //  LOtag pc0 = new LOtag(pcTag0, [name0, 'FOO']);
  //  log.debug('pc0: ${pc0.info}');
//Urgent Jim
//  expect(pcTag0.isValidValues(pc0.values), false);

    final name1 = 'Bad Offset';
    final pcTag1 = new PCTag(0x00090100, kLOIndex, name1);
    log.debug('pcTag1: ${pcTag1.info}');
    expect(pcTag1.isValid, false);
  //  LOtag pc1 = new LOtag(pcTag1, [name1, null]);
  //  log.debug('pc1: ${pc1.info}');
//Urgent Jim
//  expect(pcTag1.isValidValues(pc1.values), false);

	  final name2 = 'Bad Offset';
	  final pcTag2 = new PCTag(0x00090000, kLOIndex, name2);
    log.debug('pcTag2: ${pcTag2.info}');
    expect(pcTag1.isValid, false);
  //  LOtag pc2 = new LOtag(pcTag1, [name2, '']);
  //  log.debug('pc2: ${pc2.info}');
//Urgent Jim
//  expect(pcTag2.isValidValues(pc2.values), false);

	  final name3 = 'Bad Tag';
	  final pcTag3 = new PCTag(0x00090000, kLOIndex, name3);
    log.debug('pcTag3: ${pcTag3.info}');
    expect(pcTag1.isValid, false);
  //  LOtag pc3 = new LOtag(pcTag3, [name3, '']);
  //  log.debug('pc3: ${pc3.info}');
//Urgent Jim
//  expect(pcTag3.isValidValues(pc2.values), false);
  });

  test('Valid Known Private Creator ', () {
	  final name0 = 'AGFA';
	  final pcTag0 = new PCTag(0x00090010, kLOIndex, name0);
    log.debug('pcTag0: ${pcTag0.info}');
    expect(pcTag0.isValid, true);
	  final pc0 = new LOtag(pcTag0, [name0]);
    log.debug('pc0: ${pc0.info}');
//Urgent Jim
//    expect(pcTag0.isValidValues(pc0.values), true);

	  final name1 = 'ACUSON';
	  final pcTag1 = new PCTag(0x000900FF, kLOIndex, name1);
    log.debug('pcTag1: ${pcTag1.info}');
    expect(pcTag1.isValid, true);
	  final pc1 = new LOtag(pcTag1, [name1]);
    log.debug('PC: ${pc1.info}');
//Urgent Jim
//    expect(pcTag1.isValidValues(pc1.values), true);
  });

  test('Valid Agfa 0009 Private Data', () {
    // Group 0009 creator
	  final agfa = 'AGFA';
	  final pcTag0 = new PCTag(0x00090010, kLOIndex, agfa);
    expect(pcTag0.isValid, true);
    log.debug('pcTag0: $pcTag0');
	  final pc0 = new LOtag(pcTag0, [agfa]);
    expect(pcTag0.isValid, true);
    log.debug('pc0: ${pc0.info}');

    // valid LOtag data
	  final value1 = 'Some Random Data String';
	  final pdTag1 = new PDTag(0x00091010, kLOIndex, pcTag0);
    log.debug('pdTag1.isValid: ${pdTag1.info}');
    expect(pdTag1.isValid, true);
    log.debug('pdTag1: ${pdTag1.info}');
	  final pd1 = new LOtag(pdTag1, [value1]);
//Urgent Jim
//    expect(pdTag1.isValidValues(pd1.values), true);
    log.debug('pd1: ${pd1.info}');
  });

  test('Valid Agfa 0019 Private Data', () {
	  final agfa = 'AGFA';

    // Group 0019 creator
	  final pcTag = new PCTag(0x001900FF, kLOIndex, agfa);
    expect(pcTag.isValid, true);
    log.debug('pcTag: $pcTag');
	  final pc0 = new LOtag(pcTag, [agfa]);
//Urgent Jim
//    expect(pcTag.isValidValues(pc0.values), true);
    log.debug('pc0: ${pc0.info}');

    //Urgent separate test
    system.throwOnError = false;
	  final value0 = 'Some Random Data String';
	  final pdTag0 = new PDTag(0x0019FF05, kSTIndex, pcTag);
    log.debug('pdTag0: ${pdTag0.info}');
    expect(pdTag0.isValid, true);
    log.debug('pdTag0.isValid: ${pdTag0.isValid}');
	  final pd0 = new LOtag(pdTag0, [value0]);
	  expect(pd0, isNull);
  });

}
