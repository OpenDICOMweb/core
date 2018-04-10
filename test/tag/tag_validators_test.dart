// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

import 'dart:math' as math;

import 'package:core/server.dart';
import 'package:test/test.dart';
import 'package:test_tools/tools.dart' as rsg;

void main() {
  Server.initialize(name: 'tag_validators_test', level: Level.info);

  const tagCS0 = PTag.kSpecificCharacterSet;
//  final tagCS1 = PTag.kImageType;
  //   new Tag.public('Image​Type', 0x00080008, 'Image Type', VR.kCS, VM.k2_n);
//  final tagSQ = PTag.kLanguageCodeSequence;
  //new Tag.public('LanguageCodeSequence', 0x00080005,
  //    'Language Code Sequence', VR.kSQ, VM.k1, false);
  // final tagUS = PTag.kNumberOfZeroFills;
  //new Tag.public('NumberOfZeroFills', 0x00189066,
  //   'Number of Zero Fills', VR.kUS, VM.k1_2, false);

  group('Tag validators in tag', () {
    system.throwOnError = false;

    test('test for isValidValues', () {
      //   const emptyListsInt = const <int>[];
      final listsInt = <int>[1, 2, 3];

      // TODO: Create legal and illegal String list generators for each VR
      // TODO: Test all VRs with both lists
      for (var i = 0; i < 10; i++) listsInt.add(i);

      final listsStr = <String>[];
      for (var i = 0; i < 10; i++) {
        final sb = new StringBuffer()
          ..write(rsg.randomString(12, noLowerCase: true))
          ..write(
              new String.fromCharCode([32, 95][new math.Random().nextInt(2)]));
        listsStr.add(sb.toString());
      }
      log.debug('CS: "$listsInt"tagCS0: vr: ${vrIdByIndex[kCSIndex]}, '
          'index: ${tagCS0.vrIndex}');

      // TODO: replace with test in Element/CS
      //     expect(tagCS0.isValidValues(emptyListsInt), false);
      //  expect(tagCS0.isValidValues(listsInt), false);
      // TODO: add test for invalid Strings
//      expect(tagCS1.isValidValues(listsStr), true);
    });

/* TODO: move to element
    test('test for isValidLength', () {
//      expect(tagCS1.isValidLength(new List<String>(tagCS1.maxValues + 1)), false);
//      expect(tagCS1.isValidLength(new List<String>(tagCS1.maxValues)), true);
//      log.debug('tagCS: maxValues(${tagCS1.maxValues}, '
//          '${hex32(tagCS1.maxValues)}');
//      expect(tagCS1.isValidLength(new List<String>( tagCS1.maxValues - 1)), true);
      expect(tagCS1.isValidLength(new List<String> (tagCS1.minValues - 1)), false);
      expect(tagCS1.isValidLength(new List<String> (tagCS1.minValues)), true);

      // Note: all SQs have a VM == 1
      expect(tagSQ.isValidLength(new List<Dataset>( tagSQ.minValues)), true);
      expect(tagSQ.isValidLength(new List<Dataset>( tagSQ.minValues - 1)), true);
      expect(tagSQ.isValidLength(new List<Dataset>( tagSQ.minValues + 1)), false);
//      expect(tagSQ.isValidLength(new List<Dataset>( tagSQ.maxValues)), true);
//      expect(tagSQ.isValidLength(new List<Dataset>( tagSQ.maxValues - 1)), true);
//      expect(tagSQ.isValidLength(new List<Dataset>( tagSQ.maxValues + 1)), false);

      expect(tagUS.isValidLength(new List<int>( tagUS.minValues)), true);
      expect(tagUS.isValidLength(new List<int>( tagUS.minValues - 1)), true);
      expect(tagUS.isValidLength(new List<int>( tagUS.minValues + 1)), true);
//      expect(tagUS.isValidLength(new List<int>( tagUS.maxValues)), true);
//      expect(tagUS.isValidLength(new List<int>( tagUS.maxValues + 1)), false);
    }, skip: 'move to Element');
*/
/* TODO: Sharath let's discuss this
    test('test for isValidWidth', () {
      expect(tagCS1.isValidWidth(tagCS1.maxValues + 1), true);
      expect(tagCS1.isValidWidth(tagCS1.maxValues), true);
      expect(tagCS1.isValidWidth(tagCS1.minValues - 1), true);
      expect(tagCS1.isValidWidth(tagCS1.minValues), true);

      expect(tagSQ.isValidWidth(tagSQ.minValues), true);
      expect(tagSQ.isValidWidth(tagSQ.minValues - 1), true);
      expect(tagSQ.isValidWidth(tagSQ.maxValues), true);
      expect(tagSQ.isValidWidth(tagSQ.maxValues + 1), true);

      expect(tagUS.isValidWidth(tagUS.minValues), true);
      expect(tagUS.isValidWidth(tagUS.minValues - 1), true);
      expect(tagUS.isValidWidth(tagUS.maxValues), true);
      expect(tagUS.isValidWidth(tagUS.maxValues + 1), true);
    });
*/

    test('test for isValidVFLength', () {
/*
      final minValues = tagCS1.minValues * tvrElementSizeByIndex[kCSIndex];
      log.debug('isValidVF: minValueLength(${tagCS1.vr.elementSize}) $minValues');
 TODO: move to element
      expect(tagCS1.isValidVFLength(minValues, CS.kMaxVFLength, CS.kSizeInBytes), true);
      expect(tagCS1.isValidVFLength(minValues - 1), false);
      expect(tagCS1.isValidVFLength(kMaxShortVF), true);
      expect(tagCS1.isValidVFLength(kMaxShortVF + 1), false);
*/
/*
      log
//        ..debug('tagSQ maxValues: ${tagSQ.maxValues}')
        ..debug('vr: ${vrIdByIndex[kSQIndex]}')
        ..debug('${VR.kSQ.info}')
        ..debug('tagSQ vr.maxValueLength: ${tagSQ.maxLength}');
//TODO:fix
//      expect(tagSQ.isValidVFLength(tagSQ.maxValues * tagSQ.vr.max), true);
//      expect(tagSQ.isValidVFLength(tagSQ.maxValues * tagSQ.vr.maxValueLength + 1),
//	    false);
 TODO: move to element
      expect(tagSQ.isValidVFLength(tagSQ.minValues * tagSQ.vr.minValueLength), true);
      expect(tagSQ.isValidVFLength(tagSQ.minValues * tagSQ.vr.minValueLength - 1), false);


      log
//        ..debug('tagUS maxValues: ${tagUS.maxValues}')
//        ..debug('vr: ${tagUS.vrIdByIndex[vrIndex]}')
        ..debug('${VR.kUS.info}')
        ..debug('tagUS maxLength: ${tagUS.maxLength}');
 TODO: move to element
      expect(tagUS.isValidVFLength(tagUS.minValues * tagUS.vr.minValueLength), true);
      expect(tagUS.isValidVFLength(tagUS.minValues * tagUS.vr.minValueLength - 1), false);
      expect(tagUS.isValidVFLength(tagUS.maxValues * tagUS.maxLength), true);
*/

// TODO: fix
//      expect(tagUS.isValidVFLength(tagUS.maxValues * tagUS.maxLength + 1), false);
    });
  });
}
