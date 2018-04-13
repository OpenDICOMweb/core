// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:crypto/crypto.dart';
import 'package:test/test.dart';

String hexOut =
    'ab530a13e45914982b79f9b7e3fba994cfd1f3fb22f71cea1afbf02b460c6d1d';

// The following is NIST Test Data (https://www.nsrl.nist.gov/testdata)
String message0 = 'abc';
String nistResult0 =
    'BA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD';
String nistResult0LC = nistResult0.toLowerCase();

String message1 = 'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq';
String nistResult1 =
    '248D6A61D20638B8E5C026930C3E6039A33CE45964FF2167F6ECEDD419DB06C1';
String nistResult1LC = nistResult1.toLowerCase();

// Let the message be the binary-coded form of the ASCII string
// which consists of 1,000,000 repetitions of the character 'a'.
String message2 = ''.padRight(1000000, 'a');
String nistResult2 =
    'CDC76E5C9914FB9281A1C7E284D73E67F1809A48A497200E046D39CCC7112CD0';
String nistResult2LC = nistResult2.toLowerCase();

void main() {
  Server.initialize(name: 'element/crypto_test.dart', level: Level.info);

  test('digestLengthMsg', () {
    final msgList = [message0, message1, message2];
    for (var msg in msgList) {
      final bytes = ascii.encode(msg);
      final digest0 = new Digest(bytes);
      final dlM0 = digestLengthMsg(digest0);
      log.debug('dlM0: $dlM0');
      expect(
          dlM0,
          equals('${digest0
              .toString()
              .length} Chars ${digest0.bytes.length} '
              'Bytes ${digest0.bytes.length * 8} bits'));
    }

    final nistResult = [nistResult0, nistResult1, nistResult2];
    for (var msg in nistResult) {
      final bytes = ascii.encode(msg);
      final digest0 = new Digest(bytes);
      final dlM0 = digestLengthMsg(digest0);
      log.debug('dlM0: $dlM0');
      expect(
          dlM0,
          equals('${digest0
              .toString()
              .length} Chars ${digest0.bytes.length} '
              'Bytes ${digest0.bytes.length * 8} bits'));
    }
  });

  test('hexLengthMsg', () {
    final msgList = [message0, message1, message2];
    for (var msg in msgList) {
      final hlM0 = hexLengthMsg(msg);
      log.debug('hlM0: $hlM0');
      expect(hlM0, equals('${msg.length} Chars ${msg.length ~/
          2} Bytes ${(msg.length ~/ 2) * 8} bits'));
    }

    final nistResult = [nistResult0, nistResult1, nistResult2];
    for (var msg in nistResult) {
      final hlM0 = hexLengthMsg(msg);
      log.debug('hlM0: $hlM0');
      expect(hlM0, equals('${msg.length} Chars ${msg.length ~/
          2} Bytes ${(msg.length ~/ 2) * 8} bits'));
    }
  });

  test('bytesAsString', () {
    final msgList = [message0, message1, message2];
    for (var msg in msgList) {
      final bytes = ascii.encode(msg);
      final uint8List0 = new Uint8List.fromList(bytes);
      if (uint8List0.length > 12) {
        final baS0 = bytesAsString(uint8List0);
        log.debug('baS0: $baS0, ${baS0.length}');
        final s0 = '${uint8List0.buffer.asUint8List(0, 12)}';
        final ss0 = s0.substring(0, s0.length - 1);
        expect(baS0, equals('$s0$ss0,...]'));
      } else {
        final baS1 = bytesAsString(uint8List0);
        log.debug('baS1: $baS1, ${baS1.length}');
        expect(baS1, equals('$uint8List0'));
      }
    }
  });

  test('bytesLength', () {
    final msgList = [message0, message1, message2];
    for (var msg in msgList) {
      final bytes = ascii.encode(msg);
      final uint8List0 = new Uint8List.fromList(bytes);
      final bL0 = bytesLength(uint8List0);
      log.debug('bL0: $bL0, ${bL0.length}');
      expect(bL0,
          equals('${uint8List0.lengthInBytes} Bytes ${uint8List0.lengthInBytes *
              8} bits'));
    }

    final nistResult = [nistResult0, nistResult1, nistResult2];
    for (var msg in nistResult) {
      final bytes = ascii.encode(msg);
      final uint8List0 = new Uint8List.fromList(bytes);
      final bL0 = bytesLength(uint8List0);
      log.debug('bL0: $bL0, ${bL0.length}');
      expect(bL0,
          equals('${uint8List0.lengthInBytes} Bytes ${uint8List0.lengthInBytes *
              8} bits'));
    }
  });

  test('Sha256Digest', () {
    expect(testSha256Digest(message0, nistResult0LC), true);
    expect(testSha256Digest(message1, nistResult1LC), true);
    expect(testSha256Digest(message2, nistResult2LC), true);
  });
}

String digestLengthMsg(Digest d) =>
    '${d.toString().length} Chars ${d.bytes.length} '
    'Bytes ${d.bytes.length * 8} bits';

String hexLengthMsg(String s) {
  final lengthB = s.length ~/ 2;
  final lengthb = lengthB * 8;
  return '${s.length} Chars $lengthB Bytes $lengthb bits';
}

String bytesAsString(Uint8List bytes) {
  if (bytes.length > 12) {
    final s = '${bytes.buffer.asUint8List(0,12)}';
    final ss = s.substring(0, s.length - 1);
    return '$s$ss,...]';
  }
  return '$bytes';
}

String bytesLength(Uint8List b) =>
    '${b.lengthInBytes} Bytes ${b.lengthInBytes * 8} bits';

bool testSha256Digest(String s, String nistResult) {
  if (nistResult.length != 64)
    throw new BadDigestError('Bad Digest Length: ${nistResult.length}');

  final rBytes = new Uint8List.fromList(s.codeUnits);
  final sBytes = bytesAsString(rBytes);

  final d = sha256.convert(rBytes);
  final dBytes = bytesAsString(d.bytes);
  final ds = '$d';

  final outString = (s.length > 64) ? '${s.substring(0, 70)}...' : s;

  final out = '''
Message as String: '$outString'
 Message as Bytes: $sBytes: ${rBytes.length} bytes
           Digest: '$d'
        Hash Code: ${d.hashCode}
            Bytes: $dBytes: ${d.bytes.length} Bytes
           In Hex: '$ds': ${digestLengthMsg(d)}
         NIST Hex: '$nistResult': ${hexLengthMsg(nistResult)}
''';
  log.debug(out);
  if (ds != nistResult) throw new BadDigestError('Bad digest: $d');
  return true;
}

class BadDigestError extends Error {
  String msg;

  BadDigestError(this.msg);

  @override
  String toString() => msg;
}
