//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:convert' as cvt;

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

void main() {
  Server.initialize(name: 'ascii_test.dart', level: Level.info);

  group('Ascii Tests', () {
    test('Simple Ascii Test', () {
      const s0 = r'>3\$Wgz>yD_&Mu}'; //--> consists of (backslash(\))
      final bytes0 = cvt.ascii.encode(s0);
      final s1 = cvt.ascii.decode(bytes0, allowInvalid: true);
      log.debug('s0: "$s0" == s1: "$s1"');
      expect(s0 == s1, true);
    });

    test('Ascii Single String(Text) values field Test', () {
      final rsg = RSG(seed: 1);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(0, 1);
        final bytes0 = Bytes.fromAsciiList(vList0, kMaxShortVF);
        final sList0 = vList0.map((v) => '$v');
        final vList1 = bytes0.getAsciiList();
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

    test('Ascii Multi-String(LO, SH, UC) - values field Test', () {
      final rsg = RSG(seed: 1);

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(0, 10);
        final bytes0 = Bytes.fromAsciiList(vList0);
        final sList0 = vList0.map((v) => '"$v"');
        final vList1 = bytes0.getAsciiList();
        final sList1 = vList1.map((v) => '"$v"');
        log
          ..debug('vList0: $vList0')
          ..debug('vList1: $vList1')
          ..debug('sList0: $sList0')
          ..debug('sList1: $sList1')
          ..debug('bytes0: $bytes0')
          ..debug('vList0.length: ${vList0.length}')
          ..debug('vList1.length: ${vList1.length}');
        expect(vList0.length == vList1.length, true);
        if (vList0.isNotEmpty) {
          for (var i = 0; i < vList0.length; i++) {
            log.debug('value0[$i]: "${vList0[i]}", value1[$i]: "${vList1[i]}"');
            expect(vList0[i] == vList1[i], true);
          }
        }
      }
    });

    test('Ascii Multi-String values field Test', () {
      final rsg = RSG();
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 10);
        final bytes0 = Bytes.fromAsciiList(vList0, kMaxShortVF);
        final bytes = Bytes.fromAscii(vList0.join('\\'));
        final vList1 = bytes.getStringList();
        log
          ..debug('vList0: $vList0')
          ..debug('vList1: $vList1')
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
      const s0 = '¥ŁņĤŒ£¦§µÆĦǍƸƻƫƩƱƵϢΨϩώβαγδηθμξѤѠ₮₹₴Ɐ';
      final bytes0 = cvt.utf8.encode(s0);
      log.debug('bytes0 : $bytes0');
      final s1 = cvt.utf8.decode(bytes0, allowMalformed: true);
      log.debug('s0: "$s0" == s1: "$s1"');
      expect(s0 == s1, true);
    });
  });

  test('upperCase and lowercase', () {
    var c = toUppercaseChar(ka);
    log.debug('a to $c');
    expect(kA == c, true);
    c = toLowercaseChar(kA);
    log.debug('A to $c');
    expect(ka == c, true);

    var alphabate = '';
    final listupper = <String>[];
    for (var i = 'A'.codeUnitAt(0); i <= 'Z'.codeUnitAt(0); i++) {
      alphabate = String.fromCharCode(i);
      log.debug('alphabate: $alphabate');
      listupper.add(alphabate);
    }
    log.debug('listupper: $listupper');
    var lowercaseList = '';
    final listlower = <String>[];
    for (var data in listupper) {
      final dkd = toLowercaseChar(data.codeUnitAt(0));
      lowercaseList = String.fromCharCode(dkd);
      listlower.add(lowercaseList);
    }
    log.debug('listlower: $listlower');
  });
}
