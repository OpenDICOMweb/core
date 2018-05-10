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
  Server.initialize(name: 'age_test', level: Level.info);

  log.debug('bar');
  group('Age Tests', () {
    test('isValidAgeInDays', () {
      final vam0 = isValidAge(kMaxAgeInDays);
      expect(vam0, true);

      log.debug('foo');
      final vam1 = isValidAge(kMinAge);
      expect(vam1, true);

      final vam2 = isValidAge(kMinAge - 1);
      expect(vam2, false);

      final vam3 = isValidAge(kMaxAge + 1);
      expect(vam3, false);

      final vam4 = isValidAge(0);
      expect(vam4, true);

      final vam5 = isValidAge(-kMaxAgeInDays);
      expect(vam5, false);
    });

    test('randomAgeDays', () {
      final vam0 = randomAgeInDays(kMaxAgeInDays);
      expect(vam0, isNotNull);

      final vam1 = randomAgeInDays(kMinAge);
      expect(vam1, isNotNull);

      final vam2 = randomAgeInDays(0);
      expect(vam2, isNotNull);
    });

    test('hashAgeMicroseconds', () {
      final ham0 = hashAgeInDays(kMaxAge);
      expect(ham0, isNotNull);

      final ham1 = hashAgeInDays(kMinAge);
      expect(ham1, isNotNull);
    });

    test('sha256AgeInDays', () {
      final ham0 = sha256AgeInDays(kMaxAge);
      expect(ham0, isNotNull);

      final ham1 = sha256AgeInDays(kMinAge);
      expect(ham1, isNotNull);
    });

    test('sha256AgeAsString', () {
      final ham0 = sha256AgeAsString(kMaxAge);
      expect(ham0 == '573D', true);

      final ham1 = sha256AgeAsString(kMinAge);
      expect(ham1 == '965D', true);
    });

    test('ageToString', () {
      final as0 = ageToString(165 * 7);
      log.debug('165W = "$as0"');
      expect(as0, '165W');

      final as1 = ageToString(0);
      expect(as1, '000D');

      final as2 = ageToString(1);
      expect(as2, '001D');

      global.throwOnError = false;
      final as3 = ageToString(-1);
      expect(as3, null);

      final as4 = ageToString(999999942341299999);
      expect(as4, isNull);

      global.throwOnError = true;
      expect(() => ageToString(999999942341299999),
          throwsA(equals(const isInstanceOf<DateTimeError>())));
    });
  });
}
