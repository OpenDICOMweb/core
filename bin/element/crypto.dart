//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:crypto/crypto.dart';

String hexOut = 'ab530a13e45914982b79f9b7e3fba994cfd1f3fb22f71cea1afbf02b460c6d1d';

// The following is NIST Test Data (https://www.nsrl.nist.gov/testdata)
String message0 = 'abc';
String nistResult0 = 'BA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD';
String nistResult0LC = nistResult0.toLowerCase();

String message1 = 'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq';
String nistResult1 = '248D6A61D20638B8E5C026930C3E6039A33CE45964FF2167F6ECEDD419DB06C1';
String nistResult1LC = nistResult1.toLowerCase();

// Let the message be the binary-coded form of the ASCII string
// which consists of 1,000,000 repetitions of the character 'a'.
String message2 = ''.padRight(1000000, 'a');
String nistResult2 = 'CDC76E5C9914FB9281A1C7E284D73E67F1809A48A497200E046D39CCC7112CD0';
String nistResult2LC = nistResult2.toLowerCase();

void main() {
  final byteLength = sha256.blockSize;
  print('SHA-246: blockSize: $byteLength bytes ${byteLength * 8} bits ');

  testSha256Digest(message0, nistResult0LC);
  testSha256Digest(message1, nistResult1LC);
  testSha256Digest(message2, nistResult2LC);
}

String digestLengthMsg(Digest d) => '${d.toString().length} Chars ${d.bytes.length} '
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

String bytesLength(Uint8List b) => '${b.lengthInBytes} Bytes ${b.lengthInBytes * 8} bits';

void testSha256Digest(String s, String nistResult) {
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
  print(out);
  if (ds != nistResult) throw new BadDigestError('Bad digest: $d');
}

class BadDigestError extends Error {
  String msg;

  BadDigestError(this.msg);

  @override
  String toString() => msg;
}
