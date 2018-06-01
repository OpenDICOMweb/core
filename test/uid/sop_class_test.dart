//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

//import 'package:string/string.dart';
import 'package:core/server.dart';
import 'package:test/test.dart';


// TODO: add tests for all three errors in core/src/uid/uid_errors.dart.

void main() {
  Server.initialize(name: 'uid_test', level: Level.info);

  group('SopClass Tests', () {
    test('SopClassUids', () {
      for (var s in sopClassMap.keys) {
        expect(isValidUidString(s), true);
      }

      for (var s in sopClassMap.keys) {
        final uid = Uid.parse(s);
        final v = uid is SopClass;
        if (!v) log.debug('Bad SopClass: $uid');
        expect(uid is SopClass, true);
      }

      for (var c in sopClassList) {
        expect(c is SopClass, true);
      }
    });
  });

  const badUids = const <String>[
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

  group('Error', () {
    global.throwOnError = true;

    test('parse InvalidUidStringError', () {
      for (var s in badUids) {
        expect(() => Uid.parse(s, onError: null),
            throwsA(const isInstanceOf<InvalidUidError>()));
      }
    });
    test('parseList InvalidUidStringError', () {
      global.throwOnError = true;

      expect(() => Uid.parseList(badUids, onError: null),
          throwsA(const isInstanceOf<InvalidUidError>()));
    });
  });

  group('SopClass', () {
    test('String to UID', () {
      Uid uid = Uid.lookup('1.2.840.10008.1.1');
      expect(uid == SopClass.kVerification, true);

      uid = Uid.lookup('1.2.840.10008.1.3.10');
      expect(uid == SopClass.kMediaStorageDirectoryStorage, true);

      uid = Uid.lookup('1.2.840.10008.15.0.3.1');
      expect(uid == SopClass.kMediaStorageDirectoryStorage, false);
    });

    test('String to SopClass', () {
      Uid uid = SopClass.lookup('1.2.840.10008.1.1');
      expect(uid == SopClass.kVerification, true);

      uid = SopClass.lookup('1.2.840.10008.1.3.10');
      expect(uid == SopClass.kMediaStorageDirectoryStorage, true);
    });

    test('Create SopClass', () {
      const sop0 = const SopClass('1.2.840.10008.1.1', 'VerificationSOPClass',
          UidType.kSOPClass, 'Verification SOP Class');

      const sop1 = const SopClass('1.2.840.10008.1.1', 'VerificationSOPClass',
          UidType.kSOPClass, 'Verification SOP Class');

      const sop2 = const SopClass(
          '1.2.840.10008.1.3.10',
          'MediaStorageDirectoryStorage',
          UidType.kSOPClass,
          'Media Storage Directory Storage');

      expect(sop0.hashCode == sop1.hashCode, true);
      expect(sop0.hashCode == sop2.hashCode, false);

      expect(sop0.value == sop1.value, true);
      expect(sop0.value == sop2.value, false);

      expect(sop0.keyword == 'VerificationSOPClass', true);
      expect(sop0.name == 'Verification SOP Class', true);
      expect(sop0.value == '1.2.840.10008.1.1', true);
      expect(sop0.type == UidType.kSOPClass, true);
      expect(sop0.maxLength == kUidMaxLength, true);
      expect(sop0.minLength == kUidMinLength, true);
      expect(sop0.maxRootLength == kUidMaxRootLength, true);
    });
  });
}
