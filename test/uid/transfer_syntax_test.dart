// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.


import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'transfer_syntax_test', level: Level.info0);
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
