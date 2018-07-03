//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/server.dart' hide group;
import 'package:test/test.dart' hide group;

import 'package:core/src/tag/code.dart';

void main() {
  Server.initialize(name: 'pc_tag_test', level: Level.debug);

  const kInvalidPrivateCodes = const [
    0x00080000,
    0x000C0002,
    0x000E0004,
    0x00100005,
    0x00120007,
    0xFFFA0000,
    0xFFFC0FF0,
    0xFFFF01FE,
  ];

  const kValidPrivateGroupLengthCodes = const [
    0x00090000,
    0x000B0000,
    0x000D0000,
    0x000F0000,
    0x00110000,
    0xFFF90000,
    0xFFFB0000,
    0xFFFD0000,
  ];

  const kValidPrivateCreatorCodes = const [
    0x00090010,
    0x000B0011,
    0x000D0012,
    0x000F0013,
    0x00110014,
    0xFFF900FD,
    0xFFFB00FE,
    0xFFFD00FF,
  ];

  test('Private Group Length Code', () {
    for (var code in kValidPrivateGroupLengthCodes) {
      log.debug('${code.toRadixString(16)}');
      expect(isPrivateCode(code), true);
      expect(group(code) >= kMinGroupCode, true);
      expect(group(code) <= kMaxGroupCode, true);
      expect(isInvalidPrivateCode(code), false);
      expect(isValidPrivateCode(code), true);
      expect(isPrivateGroupLengthCode(code), true);
    }

    for (var code in kInvalidPrivateCodes) {
      log.debug('${code.toRadixString(16)}');
      expect(isPrivateCode(code), false);
      expect(isInvalidPrivateCode(code), true);
      expect(isValidPrivateCode(code), false);
      expect(isPrivateGroupLengthCode(code), false);
    }
  });

  const kPrivateInvalidCodes = const [
    0x00090001,
    0x000B0002,
    0x000D0003,
    0x000F0004,
    0x00110005,
    0xFFF9000D,
    0xFFFB000E,
    0xFFFD000F
  ];

  const kValidPrivateDataCodes = const [
    0x00091000,
    0x000B1101,
    0x000D1202,
    0x000F1303,
    0x00111404,
    0xFFF9FF00,
    0xFFFBFFFE,
    0xFFFDFFFF
  ];

  test('Invalid Private Code', () {
    for (var code in kPrivateInvalidCodes) {
      log.debug('${code.toRadixString(16)}');
      expect(isPrivateCode(code), true);
      expect(group(code) >= kMinGroupCode, true);
      expect(group(code) <= kMaxGroupCode, true);
      expect(isInvalidPrivateCode(code), true);
      expect(isValidPrivateCode(code), false);
    }

    for (var code in kInvalidPrivateCodes) {
      log.debug('${code.toRadixString(16)}');
      expect(isPrivateCode(code), false);
      expect(isInvalidPrivateCode(code), true);
      expect(isValidPrivateCode(code), false);
    }
  });

  test('Private Creator Codes', () {
    for (var code in kValidPrivateCreatorCodes) {
      log.debug('${code.toRadixString(16)}');
      expect(isPrivateCode(code), true);
      expect(group(code) >= kMinGroupCode, true);
      expect(group(code) <= kMaxGroupCode, true);
      expect(isInvalidPrivateCode(code), false);
      expect(isValidPrivateCode(code), true);
      expect(isPCCode(code), true);
    }

    for (var code in kInvalidPrivateCodes) {
      log.debug('${code.toRadixString(16)}');
      expect(isPrivateCode(code), false);
      expect(isInvalidPrivateCode(code), true);
      expect(isValidPrivateCode(code), false);
      expect(isPCCode(code), false);
    }

    for (var code in kValidPrivateDataCodes) {
      log.debug('${code.toRadixString(16)}');
      expect(isPrivateCode(code), true);
      expect(isInvalidPrivateCode(code), false);
      expect(isValidPrivateCode(code), true);
      expect(isPCCode(code), false);
    }
  });

  test('Valid Private Data Codes', () {
    for (var code in kValidPrivateDataCodes) {
      log.debug('${code.toRadixString(16)}');
      expect(isPrivateCode(code), true);
      expect(group(code) >= kMinGroupCode, true);
      expect(group(code) <= kMaxGroupCode, true);
      expect(isInvalidPrivateCode(code), false);
      expect(isValidPrivateCode(code), true);
      expect(isPDCode(code), true);
    }

    for (var code in kInvalidPrivateCodes) {
      log.debug('${code.toRadixString(16)}');
      expect(isPrivateCode(code), false);
      expect(isInvalidPrivateCode(code), true);
      expect(isValidPrivateCode(code), false);
      expect(isPDCode(code), false);
    }

    for (var code in kValidPrivateCreatorCodes) {
      log.debug('${code.toRadixString(16)}');
      expect(isPrivateCode(code), true);
      expect(isInvalidPrivateCode(code), false);
      expect(isValidPrivateCode(code), true);
      expect(isPDCode(code), false);
    }
  });

  const kValidPrivateDataCodesWithCreator = const [
    const [0x00091000, 0x00090010],
    const [0x000B1101, 0x000B0011],
    const [0x000D1202, 0x000D0012],
    const [0x000F1303, 0x000F0013],
    const [0x00111404, 0x00110014],
    const [0xFFF9FF00, 0xFFF900FF],
    const [0xFFFBFBFE, 0xFFFB00FB],
    const [0xFFFDFDFF, 0xFFFD00FD]
  ];

  test('Valid Private Data Codes with Creator', () {
    for (var list in kValidPrivateDataCodesWithCreator) {
      final code = list[0];
      final creator = list[1];
      log.debug('${code.toRadixString(16)}');
      expect(isPrivateCode(code), true);
      expect(group(code) >= kMinGroupCode, true);
      expect(group(code) <= kMaxGroupCode, true);
      expect(isInvalidPrivateCode(code), false);
      expect(isValidPrivateCode(code), true);
      expect(isPDCode(code, creator), true);
    }

    for (var code in kInvalidPrivateCodes) {
      log.debug('${code.toRadixString(16)}');
      expect(isPrivateCode(code), false);
      expect(isInvalidPrivateCode(code), true);
      expect(isValidPrivateCode(code), false);
      expect(isPDCode(code, code - 1), false);
    }

    for (var code in kValidPrivateCreatorCodes) {
      log.debug('${code.toRadixString(16)}');
      expect(isPrivateCode(code), true);
      expect(isInvalidPrivateCode(code), false);
      expect(isValidPrivateCode(code), true);
      expect(isPDCode(code), false);
    }
  });
}
