// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert' as cvt;
import 'dart:typed_data';

import 'package:bignum/bignum.dart';
import 'package:core/server.dart';



void main() {
  final b0 = V4Generator.pseudo.next;
  final s = Uid.generatePseudoUidString();
  print('s[${s.length}]: "$s"');
  print('b0[${b0.length}]: $b0');
  final i0 = new BigInteger.fromBytes(1, b0);
  print('i0: $i0');
  final s0 = i0.toString();
  print('s0[${s0.length}]: $s0');
  final b1 = cvt.ascii.encode(s0);
  print('b1[${b1.length}]: $b1');
  final i1 = new BigInteger.fromBytes(1, b1);
  print('i1: $i1');
  final s1 = i0.toString();
  print('s1[${s1.length}]: $s1');
}

// ASCII Space code
const int kSpace = 32;
String bytesToDecimal(Uint8List bytes) {
  final digits = cvt.ascii.encode('0123456789');
  final output = new Uint8List(bytes.length * 4);
  for (var j = 0; j < bytes.length; j++) {
    final v = bytes[j] & 0xFF;
    output[j * 4] = digits[v ~/ 100];
    output[j * 4 + 1] = digits[(v ~/ 10) % 10];
    output[j * 4 + 2] = digits[v % 10];
    output[j * 4 + 3] = kSpace;
  }
  return cvt.ascii.decode(output);
}
