// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert' as cvt;

import 'package:core/server.dart';
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

void main() {
  Server.initialize(name: 'ascii_test.dart', level: Level.info);

  group('Ascii Tests', () {
    test('Simple Ascii Test', () {
      final s0 = r'>3\$Wgz>yD_&Mu}'; //--> consists of (backslash(\))
      final bytes0 = cvt.ascii.encode(s0);
      final s1 = cvt.ascii.decode(bytes0, allowInvalid: true);
      log.debug('s0: "$s0" == s1: "$s1"');
      expect(s0 == s1, true);
    });

    test('Ascii Single String(Text) value field Test', () {
      final rsg = new RSG(seed: 1);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(0, 1);
        final bytes0 = StringBase.toBytes(vList0, kMaxShortVF);
        final sList0 = vList0.map((v) => '$v');
        final vList1 = textListFromBytes(bytes0, kMaxShortVF, isAscii: true);
        final sList1 = vList1.map((v) => '$v');
        log
          ..debug('vList0: $vList0')
          ..debug('vList1: $vList1')
          ..debug('sList0: $sList0')
          ..debug('sList1: $sList1')
          ..debug('bytes0: $bytes0');

        if (vList0.isEmpty) expect(vList1.isEmpty, true);
        if (vList0.isNotEmpty) {
          expect(vList0.length == 1, true);
          expect(vList0.length == 1, true);
          expect(vList0[0] == vList1[0], true);
        }
      }
    });

    test('Ascii Multi-String(LO, SH, UC) - value field Test', () {
      final rsg = new RSG(seed: 1);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(0, 10);
        final bytes0 = stringListToBytes(vList0, kMaxShortVF);
//        final sList0 = vList0.map((v) => '$v');
        final vList1 = stringListFromBytes(bytes0, kMaxShortVF);
//        final sList1 = vList1.map((v) => '$v');
        log
          ..debug('vList0: $vList0')
          ..debug('vList1: $vList1')
          //  ..debug('sList0: $sList0')
          //  ..debug('sList1: $sList1')
          ..debug('bytes0: $bytes0');

        expect(vList0.length == vList1.length, true);
        for (var i = 0; i < vList0.length; i++) {
          log.debug('value0[$i]: "${vList0[i]}", value1[$i]: "${vList1[i]}"');
          expect(vList0[i] == vList1[i], true);
        }
      }
    });

  });

  group('UTF8 Test', () {
    test('simple UTF8 test', () {
      final s0 = '¥ŁņĤŒ£¦§µÆĦǍƸƻƫƩƱƵϢΨϩώβαγδηθμξѤѠ₮₹₴Ɐ';
      final bytes0 = cvt.utf8.encode(s0);
      log.debug('bytes0 : $bytes0');
      final s1 = cvt.utf8.decode(bytes0, allowMalformed: true);
      log.debug('s0: "$s0" == s1: "$s1"');
      expect(s0 == s1, true);
    });
  });
}
