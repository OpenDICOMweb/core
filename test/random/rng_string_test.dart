//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'package:core/server.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'rng/in_range_test', level: Level.info);

  group('RNG Strings test', () {
    final rng = new RNG(0);

    test('nextDigit test', () {
      final count = rng.getLength(10, 100);
      for (var i = 0; i < count; i++) {
        final c = rng.nextDigit;
        final n = c.codeUnitAt(0);
        log.debug('nextDigit c: $c, n: $n');
        expect(n >= k0 + 0 && n <= k0 + 9, true);
      }
    });

    test('nextIntString test', () {
      global.level = Level.info;
      final count = rng.getLength(10, 100);
      for (var i = 0; i < count; i++) {
        final len = rng.getLength(1, 12);
        final s = rng.nextIntString(len, len);
        log.debug('nextIntString: (${s.length})"$s"');
        expect(s.isNotEmpty && s.length <= 16, true);
        expect(int.parse(s) is int, true);
      }
    });

    var minWordLength = 1;
    var maxWordLength = 16;

    test('nextAsciiWord test', () {
//      system.level = Level.info;
      final count = rng.getLength(10, 100);
      for (var i = 0; i < count; i++) {
        final word = rng.nextAsciiWord(minWordLength, maxWordLength);
        log.debug('nextAsciiWord: (${word.length})"$word"');
        expect(
            word.length >= minWordLength && word.length <= maxWordLength, true);
        final codeUnits = word.codeUnits;
        for (var c in codeUnits) expect(isWordChar(c), true);
      }

      minWordLength = 16;
      maxWordLength = 64;
      for (var i = 0; i < count; i++) {
        final word = rng.nextAsciiWord(minWordLength, maxWordLength);
        log.debug('nextIntString: (${word.length})"$word"');
        expect(
            word.length >= minWordLength && word.length <= maxWordLength, true);
        final codeUnits = word.codeUnits;
        for (var c in codeUnits) expect(isWordChar(c), true);
      }
    });
  });
}
