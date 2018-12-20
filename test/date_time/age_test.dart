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
  Server.initialize(name: 'age_test', level: Level.info);

  const goodDcmAge = <String>[
    '000D',
    '024Y',
    '998Y',
    '999Y',
    '021D',
    '120D',
    '999D',
    '005W',
    '010W',
    '999W',
    '001M',
    '011M',
    '999M'
  ];

  const badDcmAge = <String>[
    '000Y',
    '1',
    'A',
    '1y',
    '24Y',
    '024A',
    '024y',
    '034d',
    '023w',
    '003m',
    '1234',
    'abcd',
    '12ym',
    '012Y7',
    '012YU7',
  ];

  group('Age tests', () {
    test('Age Test', () {
      expect(kAgeTokens == 'DWMY', true);
      for (var s in goodDcmAge) {
        final units = int.parse(s.substring(0, 3));
        final a0 = Age.tryParse(s);
        final c = canonicalAgeString(a0.nDays);
        expect(c.length, 4);

        final a1 = Age.tryParse(s);
        expect(units >= 0 && units <= 999, true);
        expect(a0.days == a1.days, true);

        final r = a0.toString();
        expect(r == a0.highest || r == a0.normal, true);
      }
    });

    test('Age Test', () {
      expect(kAgeTokens == 'DWMY', true);

      global.throwOnError = true;
      for (var s in badDcmAge) {
        expect(Age.tryParse(s) == null, true);
        expect(() => Age.parse(s), throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('Age == and hash', () {
      for (var s in goodDcmAge) {
        final a0 = Age.tryParse(s);
        final a1 = Age.tryParse(s);
        log
          ..debug('a0.values:$a0, a0.hash:${a0.hash}')
          ..debug('a1.values:$a1, a1.hash:${a1.hash}');
        expect(a0 == a1, true);
        // Hash is now random
        // expect(a0.hash == a1.hash, true);
        final hash0 = a0.hash;
        expect(hash0 != a0, true);
        expect(isValidAge(hash0.nDays), true);
        final hash1 = a1.hash;
        expect(hash1 != a1, true);
        expect(isValidAge(hash1.nDays), true);

        // parse
        final a2 = Age.tryParse(s);
        expect(a0 == a2, true);
        //  expect(a0.hash == a2.hash, true);
        final hash2 = a2.hash;
        expect(hash2 != a1, true);
        expect(isValidAge(hash2.nDays), true);
      }

      final a3 = Age.tryParse(goodDcmAge[0]);
      final a4 = Age.tryParse(goodDcmAge[1]);
      expect(a3 == a4, false);
    });

    test('acr', () {
      const d = '089Y';
      for (var s in goodDcmAge) {
        final a0 = Age.tryParse(s);
        log.debug('a0.acr:${a0.acr}');
        expect(a0.acr, equals(Age.tryParse(d)));
      }
    });

    test('hashCode', () {
      for (var i = 0; i < goodDcmAge.length; i++) {
        final a0 = Age.tryParse(goodDcmAge[i]);
        final a1 = Age.tryParse(goodDcmAge[i]);
        log.debug('a0.hashCode:${a0.hashCode},a1.hashCode:${a1.hashCode}');
        expect(a0.hashCode, equals(a1.hashCode));

        if (i < goodDcmAge.length - 2) {
          final a2 = Age.tryParse(goodDcmAge[i + 1]);
          log.debug('a0.hashCode:${a0.hashCode},a2.hashCode:${a2.hashCode}');
          expect(a0.hashCode, isNot(a2.hashCode));
        }
      }
    });

    test('isValid', () {
      final valid0 = Age.isValid(kMinAgeInDays);
      expect(valid0, true);

      final valid1 = Age.isValid(kMaxAgeYearsInDays);
      expect(valid1, true);

      final valid2 = Age.isValid(-1);
      expect(valid2, false);

      final valid3 = Age.isValid(-kMaxAgeYearsInDays);
      expect(valid3, false);

      final valid4 = Age.isValid(kMinAgeInDays - 1);
      expect(valid4, false);

      final valid5 = Age.isValid(kMaxAgeYearsInDays + 1);
      expect(valid5, false);

      final valid6 = Age.isValid(0);
      expect(valid6, true);
    });

    test('Age.isValidString Good', () {
      global.throwOnError = false;
      for (var s in goodDcmAge) {
        final vs0 = Age.isValidString(s);
        expect(vs0, true);
      }
    });

    test('Age.isValidString Bad', () {
      for (var s in badDcmAge) {
        global.throwOnError = false;
        final vs0 = Age.isValidString(s);
        expect(vs0, false);

        global.throwOnError = true;
        log.debug('s: "$s"');
        expect(() => Age.isValidString(s),
            throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('isValidAgeString: Good', () {
      for (var s in goodDcmAge) {
        final vas0 = Age.isValidString(s);
        expect(vas0, true);
      }
    });

    test('isValidAgeString: Bad', () {
      global.throwOnError = false;

      for (var s in badDcmAge) {
        log.debug('s: "$s"');
        final vas0 = isValidAgeString(s);
        log.debug('age: $vas0');
        expect(vas0, false);
      }
    });

    test('Hash Good Age Strings', () {
      for (var s in goodDcmAge) {
        final h = hashAgeString(s);
        log.debug('Age $s hash: $h');
        expect(h, isNotNull);
        expect(s != h, true);
      }
    });

    test('Hash Bad Age Strings', () {
      global.throwOnError = false;
      log.debug('global.throwOnError: ${global.throwOnError}');
      for (var s in badDcmAge) {
        final h = hashAgeString(s);
        log.debug('Age $s hash: $h');
        expect(h, isNull);
      }

      global.throwOnError = true;
      log.debug('global.throwOnError: ${global.throwOnError}');
      for (var s in badDcmAge) {
        expect(() => hashAgeString(s),
            throwsA(equals(const TypeMatcher<StringError>())));
      }
    });

    test(' Good Age HashStringList', () {
      final hs0 = hashAgeStringList(goodDcmAge);
      log.debug('hs0: $hs0');
      expect(hs0, isNotNull);
    });

    test('bad Age HashStringList', () {
      global.throwOnError = false;
      log.debug('global.throwOnError: ${global.throwOnError}');
      final hs0 = hashAgeStringList(badDcmAge);
      log.debug('hs0: $hs0');
      for (var s in hs0) {
        expect(s, isNull);
      }

      global.throwOnError = true;
      log.debug('global.throwOnError: ${global.throwOnError}');
      expect(() => hashAgeStringList(badDcmAge),
          throwsA(equals(const TypeMatcher<StringError>())));
    });

    test('hashString', () {
      for (var s in goodDcmAge) {
        final age = Age.tryParse(s);
        final hs0 = age.hashString;
        log.debug('hs0: $hs0');
        expect(hs0, isNotNull);
      }

      global.throwOnError = false;
      log.debug('global.throwOnError: ${global.throwOnError}');
      for (var s in badDcmAge) {
        final age = Age.tryParse(s);
        expect(age, isNull);
      }
    });

    test('Parse Good Age String', () {
      for (var s in goodDcmAge) {
        final pas0 = parseAgeString(s);
        log.debug('pas0:$pas0');
        expect(pas0, isNotNull);
      }
    });

    test('Parse Bad Age String', () {
      global.throwOnError = true;
      for (var s in badDcmAge) {
        expect(() => parseAgeString(s),
            throwsA(equals(const TypeMatcher<StringError>())));
      }
    });
    test('ageToString', () {
      final as0 = ageToString(165 * 7);
      log.debug('as0: $as0');
      expect(as0, '165W');

      global.throwOnError = false;
      final as1 = ageToString(-1);
      log.debug('as1: $as1');
      expect(as1, null);

      final as2 = ageToString(1);
      log.debug('as2: $as2');
      expect(as2, '001D');

      final as3 = ageToString(4);
      log.debug('as3: $as3');
      expect(as3, '004D');

      final as4 = ageToString(7);
      log.debug('as4: $as4');
      expect(as4, '007D');

      final as5 = ageToString(1000);
      log.debug('as5: $as5');
    });

    test('parseDays', () {
      for (var s in goodDcmAge) {
        global.throwOnError = false;
        final pd0 = Age.parseDays(s);
        expect(pd0, equals(tryParseAgeString(s)));
        expect(pd0, isNotNull);
      }
      for (var s in badDcmAge) {
        global.throwOnError = false;
        final pd1 = Age.parseDays(s);
        expect(pd1, -1);

        global.throwOnError = true;
        expect(
            () => Age.parseDays(s), throwsA(const TypeMatcher<StringError>()));
      }
    });

    test('tryParseDays', () {
      for (var s in goodDcmAge) {
        global.throwOnError = false;
        final pd0 = Age.tryParseDays(s);
        expect(pd0, equals(tryParseAgeString(s)));
        expect(pd0, isNotNull);
      }
      for (var s in badDcmAge) {
        global.throwOnError = false;
        final pd1 = Age.tryParseDays(s);
        expect(pd1, -1);
      }
    });

    test('age', () {
      for (var s in goodDcmAge) {
        final age0 = Age.tryParse(s);
        final age1 = Age.tryParse(s);
        log
          ..debug('age0.values: $age0, age0.hash:${age0.hash}, '
              'age0.hashCode:${age0.hashCode}')
          ..debug('age1.values: $age1, age1.hash:${age1.hash}, '
              'age1.hashCode:${age1.hashCode}');
        expect(age0 == age1, true);
        //  currently
        //    expect(age0.hash, equals(age1.hash));
        expect(age0.hashCode, equals(age1.hashCode));
      }

      final age2 = Age.tryParse(goodDcmAge[0]);
      final age3 = Age.tryParse(goodDcmAge[1]);
      log
        ..debug('age2.values:${age2.toString()}, age2.hash:${age2.hash}, '
            'age2.hashCode:${age2.hashCode}')
        ..debug('age3.values:${age3.toString()}, age3.hash:${age3.hash}, '
            'age3.hashCode:${age3.hashCode}');
      expect(age2.toString() == age3.toString(), false);
      expect(age2.hash, isNot(age3.hash));
      expect(age2.hashCode, isNot(age3.hashCode));

      /*const s = '089Y';
    final age4 = Age(780, s);
    expect(age4.acr, equals(age4));*/
    });
  });
}
