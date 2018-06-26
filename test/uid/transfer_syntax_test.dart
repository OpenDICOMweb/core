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
  Server.initialize(name: 'transfer_syntax_test', level: Level.info);
  transferSyntaxTest();
}

void transferSyntaxTest() {
  group('Transfer Syntax Tests', () {
    test('String to UID', () {
      Uid uid = Uid.lookup('1.2.840.10008.1.2');
      expect(uid == TransferSyntax.kImplicitVRLittleEndian, true);
      uid = Uid.lookup('1.2.840.10008.1.2.1');
      expect(uid == TransferSyntax.kExplicitVRLittleEndian, true);
    });

    test('String to TransferSyntax', () {
      Uid uid = TransferSyntax.lookup('1.2.840.10008.1.2');
      expect(uid == TransferSyntax.kImplicitVRLittleEndian, true);
      uid = TransferSyntax.lookup('1.2.840.10008.1.2.1');
      expect(uid == TransferSyntax.kExplicitVRLittleEndian, true);
    });
  });
}
