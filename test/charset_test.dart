//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:convert' as cvt;
import 'dart:typed_data';

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = RSG();
RNG rng = RNG();

void main() {
  Server.initialize(name: 'charset_test', level: Level.info);

  group('Charset', () {
    test('Create Charset', () {
      final charset0 = Ascii(ascii.name, ascii.language, ascii.identifiers);
      log.debug('charset0: $charset0');

      expect(charset0.name == ascii.name, true);
      expect(charset0.language == ascii.language, true);
      expect(charset0.identifiers == ascii.identifiers, true);

      const charset1 = Ascii('ASCII-1', 'US English',
          ['ASCII', 'US-ASCII', 'ISO_IR 6', 'ISO/IEC 646']);

      expect(charset1.name == 'ASCII-1', true);
      expect(charset1.language == 'US English', true);
      expect(charset1.identifiers,
          equals(['ASCII', 'US-ASCII', 'ISO_IR 6', 'ISO/IEC 646']));
    });

    test('isValid', () {
      final charset0 = Ascii(ascii.name, ascii.language, ascii.identifiers);
      for (var i = Ascii.kMin; i <= Ascii.kMax; i++) {
        expect(charset0.isValid(i), true);
      }
      expect(charset0.isValid(Ascii.kMax + 1), false);
      expect(charset0.isValid(Ascii.kMin - 1), false);
    });

    test('isVisible', () {
      final charset0 = Ascii(ascii.name, ascii.language, ascii.identifiers);
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        for (var j = 0; j < vList0.length; j++) {
          final char = vList0.elementAt(j).codeUnitAt(j);
          final visible = charset0.isVisible(char);
          log.debug('char: $char visible: $visible');
          expect(visible, true);
        }
      }

      final vList1 = ['\b', '\t', '\n', '\f', '\v', '\r'];
      for (final i in vList1) {
        final char = i.codeUnits;
        for (var j = 0; j < char.length; j++) {
          final visible1 = charset0.isVisible(char[j]);
          log.debug('char: $char visible: $visible1');
          expect(visible1, false);
        }
      }
    });

    test('decode and encode', () {
      final charset0 = Ascii(ascii.name, ascii.language, ascii.identifiers);
      //final vList0 = rng.uint8List(1, 1);
      const vList0 = [123, 23, 69, 98];
      final list0 = Uint8List.fromList(vList0);
      final decode0 = charset0.decode(list0);
      log.debug('decode0: $decode0');
      expect(decode0, equals(cvt.ascii.decode(list0)));

      final encode0 = charset0.encode(decode0);
      log.debug('encode0: $encode0');
      expect(encode0, equals(vList0));
    });

    test('isValidString', () {
      final charset0 = Ascii(ascii.name, ascii.language, ascii.identifiers);
      for (var i = 1; i < 20; i++) {
        final vList0 = rsg.getLOList(1, i);
        for (var j = 0; j < vList0.length; j++) {
          final isValid0 = charset0.isValidString(vList0[j]);
          expect(isValid0, true);
        }
      }

      const vList1 = '/TX\\&{Y2-w';
      final isValid1 = charset0.isValidString(vList1);
      expect(isValid1, false);

      final vList2 = ['\b', '\t', '\n', '\f', '\v', '\r'];
      for (final i in vList2) {
        final isValid2 = charset0.isValidString(i);
        log.debug(' isValid2: $isValid2');
        expect(isValid2, false);
      }
    });

    test('isSpace', () {
      final charset0 = Ascii(ascii.name, ascii.language, ascii.identifiers);
      for (var i = kNull; i <= kDelete; i++) {
        bool space0;

        if (i == kSpace) {
          space0 = charset0.isSpace(i);
          expect(space0, true);
        } else {
          space0 = charset0.isSpace(i);
          expect(space0, false);
        }
      }
    });

    test('isBackSpace', () {
      final charset0 = Ascii(ascii.name, ascii.language, ascii.identifiers);
      for (var i = kNull; i <= kDelete; i++) {
        bool backSpace0;

        if (i == kBackspace) {
          backSpace0 = charset0.isBackspace(i);
          expect(backSpace0, true);
        } else {
          backSpace0 = charset0.isBackspace(i);
          expect(backSpace0, false);
        }
      }
    });

    test('isWhiteSpace', () {
      final charset0 = Ascii(ascii.name, ascii.language, ascii.identifiers);
      for (var i = kNull; i <= kDelete; i++) {
        bool whiteSpace0;

        if (i == kSp || (i >= kBs && i <= kCr)) {
          whiteSpace0 = charset0.isWhitespace(i);
          expect(whiteSpace0, true);
        } else {
          whiteSpace0 = charset0.isWhitespace(i);
          expect(whiteSpace0, false);
        }
      }
    });

    test('isDigit', () {
      final charset0 = Ascii(ascii.name, ascii.language, ascii.identifiers);
      for (var i = kNull; i <= kDelete; i++) {
        bool digit0;

        if (i >= k0 && i < k9) {
          digit0 = charset0.isDigit(i);
          expect(digit0, true);
        } else {
          digit0 = charset0.isDigit(i);
          expect(digit0, false);
        }
      }
    });

    test('isControl', () {
      final charset0 = Ascii(ascii.name, ascii.language, ascii.identifiers);
      for (var i = kNull; i <= kDelete; i++) {
        bool control0;

        if (i >= kNul && i < kSp) {
          control0 = charset0.isControl(i);
          expect(control0, true);
        } else {
          control0 = charset0.isControl(i);
          expect(control0, false);
        }
      }
    });

    test('isEscape', () {
      final charset0 = Ascii(ascii.name, ascii.language, ascii.identifiers);
      for (var i = kNull; i <= kDelete; i++) {
        bool escape0;

        if (i == kEsc) {
          escape0 = charset0.isEscape(i);
          expect(escape0, true);
        } else {
          escape0 = charset0.isEscape(i);
          expect(escape0, false);
        }
      }
    });
  });

  group('Latin', () {
    test('Create Latin', () {
      final latin0 = Latin(latin1.name, latin1.language, latin1.identifiers);
      log.debug('latin0: $latin0');

      expect(latin0.name == latin1.name, true);
      expect(latin0.language == latin1.language, true);
      expect(latin0.identifiers == latin1.identifiers, true);

      const latin01 = Latin('Latin1', 'Western Europe',
          ['ISO-8859-1', 'ISO-IR 100', 'Latin1', 'Latin-1']);

      expect(latin01.name == 'Latin1', true);
      expect(latin01.language == 'Western Europe', true);
      expect(latin01.identifiers,
          equals(['ISO-8859-1', 'ISO-IR 100', 'Latin1', 'Latin-1']));
    });

    test('isValid', () {
      final latin0 = Latin(latin1.name, latin1.language, latin1.identifiers);
      for (var i = Latin.kMin; i <= Latin.kMax; i++) {
        expect(latin0.isValid(i), true);
      }
      expect(latin0.isValid(Latin.kMax + 1), false);
      expect(latin0.isValid(Latin.kMin - 1), false);
    });

    test('isVisible', () {
      final latin0 = Latin(latin1.name, latin1.language, latin1.identifiers);
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        for (var j = 0; j < vList0.length; j++) {
          final char = vList0.elementAt(j).codeUnitAt(j);
          final v = latin0.isVisible(char);
          if (!v) log.debug('char: $char');
          expect(v, true);
        }
      }

      final vList1 = ['\b', '\t', '\n', '\f', '\v', '\r'];
      for (final i in vList1) {
        final char = i.codeUnits;
        for (var j = 0; j < char.length; j++) {
          final v = latin0.isVisible(char[j]);
          log.debug('char: $char visible: $v');
          expect(v, false);
        }
      }
    });

    test('decode and encode', () {
      final latin0 = Latin(latin1.name, latin1.language, latin1.identifiers);
      //final vList0 = rng.uint8List(1, 1);
      const vList0 = [123, 23, 69, 98];
      final list0 = Uint8List.fromList(vList0);
      final decode0 = latin0.decode(list0);
      log.debug('decode0: $decode0');
      expect(decode0, equals(cvt.ascii.decode(list0)));

      final encode0 = latin0.encode(decode0);
      log.debug('encode0: $encode0');
      expect(encode0, equals(vList0));
      expect(encode0, equals(cvt.ascii.encode(decode0)));
    });

    test('isSpace', () {
      final latin0 = Latin(latin1.name, latin1.language, latin1.identifiers);
      for (var i = kNull; i <= kDelete; i++) {
        bool space0;

        if (i == kSp || i == Latin.kNBSP) {
          space0 = latin0.isSpace(i);
          expect(space0, true);
        } else {
          space0 = latin0.isSpace(i);
          expect(space0, false);
        }
      }
    });

    test('isWhiteSpace', () {
      final latin0 = Latin(latin1.name, latin1.language, latin1.identifiers);
      for (var i = kNull; i <= kDelete; i++) {
        bool whiteSpace0;

        if (i == kSp || i == Latin.kNBSP || (i >= kBs && i <= kCr)) {
          whiteSpace0 = latin0.isWhitespace(i);
          expect(whiteSpace0, true);
        } else {
          whiteSpace0 = latin0.isWhitespace(i);
          expect(whiteSpace0, false);
        }
      }
    });

    test('isControl', () {
      final latin0 = Latin(latin1.name, latin1.language, latin1.identifiers);
      for (var i = kNull; i <= kDelete; i++) {
        bool control0;

        if (i >= kNull && i < kSpace || i >= 128 && i <= 159) {
          control0 = latin0.isControl(i);
          expect(control0, true);
        } else {
          control0 = latin0.isControl(i);
          expect(control0, false);
        }
      }
    });
  });

  group('Utf8', () {
    test('Create Utf8', () {
      final utf8_0 = Utf8(utf8.name, utf8.identifiers);
      log.debug('utf80: $utf8_0');

      expect(utf8_0.name == utf8.name, true);
      expect(utf8_0.identifiers, equals(utf8.identifiers));

      const utf8_1 = Utf8('UTF8', ['UTF8', 'ISO-IR 192', 'UTF-8']);

      expect(utf8_1.name == 'UTF8', true);
      expect(utf8_1.identifiers, equals(['Latin-1', 'ISO-8859-1']));
    });

    test('isValid', () {
      final utf8_0 = Utf8(utf8.name, utf8.identifiers);
      for (var i = Utf8.kMin; i <= Utf8.kMax; i++) {
        expect(utf8_0.isValid(i), true);
      }
      expect(utf8_0.isValid(Utf8.kMax + 1), false);
      expect(utf8_0.isValid(Utf8.kMin - 1), false);
    });

    test('isVisible', () {
      final utf8_0 = Utf8(utf8.name, utf8.identifiers);
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        for (var j = 0; j < vList0.length; j++) {
          final visible0 = utf8_0.isVisible(vList0.elementAt(j).codeUnitAt(j));
          expect(visible0, true);
        }
      }

      final vList1 = ['\b', '\t', '\n', '\f', '\v', '\r'];
      for (final i in vList1) {
        final char = i.codeUnits;
        for (var j = 0; j < char.length; j++) {
          final visible1 = utf8_0.isVisible(char[j]);
          log.debug('char: $char visible: $visible1');
          expect(visible1, false);
        }
      }
    });

    test('decode and encode', () {
      final utf8_0 = Utf8(utf8.name, utf8.identifiers);
      //final vList0 = rng.uint8List(1, 1);
      const vList0 = [123, 23, 69, 98];
      final list0 = Uint8List.fromList(vList0);
      final decode0 = utf8_0.decode(list0);
      log.debug('decode0: $decode0');
      expect(decode0, equals(cvt.ascii.decode(list0)));

      final encode0 = utf8_0.encode(decode0);
      log.debug('encode0: $encode0');
      expect(encode0, equals(vList0));
    });
  });
}
