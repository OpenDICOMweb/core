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
import 'package:test_tools/tools.dart';

RSG rsg = RSG(seed: 1);

void main() {
  Server.initialize(name: 'element/hash_number_test', level: Level.info);
  group('Integer Strings', () {
    test('IS', () {
      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getISList(1, 1);
        final e0 = IStag(PTag.kEvaluatorNumber, vList0);
        final e1 = IStag(PTag.kEvaluatorNumber, vList0);
        final e2 = IStag(PTag.kEvaluationAttempt, vList0);
        final e3 = IStag(PTag.kEvaluatorNumber, rsg.getISList(1, 1));
        final e4 = IStag(PTag.kEvaluationAttempt, rsg.getISList(1, 1));

        global.throwOnError = true;
        final hash0 = Sha256.stringList(vList0);
        log.debug('vList0: $vList0, hash0: $hash0');
        expect(() => e0.sha256, throwsA(const TypeMatcher<UnsupportedError>()));

        expect(e0.hash, equals(e1.hash));
        expect(e0.hash, equals(e2.hash));
        expect(e1.hash, equals(e2.hash));
        expect(e0.hash, isNot(e3.hash));
        expect(e1.hash, isNot(e4.hash));
        expect(e3.hash, isNot(e4.hash));

        expect(e0.hash.hasValidValues, true);
        expect(e3.hash.hasValidValues, true);
        expect(e4.hash.hasValidValues, true);

        // Test hash is consistent
        expect(e0.hash == e0.hash, true);
        expect(e3.hash == e3.hash, true);
        expect(e4.hash == e4.hash, true);

        // Test hash is not the same
        log..debug(e0.hash)..debug(e3.hash)..debug(e4.hash);
        expect(e0.hash != e3.hash, true);
        expect(e3.hash != e4.hash, true);
        expect(e4.hash != e0.hash, true);
        final e5 = e0.hash;
        expect(e5.hasValidValues, true);
      }
    });

    test('DS', () {
      for (var i = 0; i <= 10; i++) {
        final vList0 = rsg.getDSList(1, 1);
        final e0 = DStag(PTag.kDeadTimeFactor, vList0);
        final e1 = DStag(PTag.kDeadTimeFactor, vList0);
        final e2 = DStag(PTag.kSelectorDSValue, vList0);
        final e3 = DStag(PTag.kDeadTimeFactor, rsg.getDSList(1, 1));
        final e4 = DStag(PTag.kDeadTimeFactor, rsg.getDSList(1, 1));

        global.throwOnError = false;
        final hash1 = Sha256.stringList(vList0);
        log
          ..debug('vList0: $vList0, hash1: $hash1')
          ..debug(
              'e0: ${e0.numbers} isList<String>: ${e0.numbers is List<String>}')
          ..debug('isList<double>: ${e0.numbers is List<double>}')
          ..debug('e0: $e0 e0.sha256: ${e0.sha256}');
        expect(e0.sha256, isNotNull);

        log.debug('ds0.hash: ${e0.hash}, ds1.hash: ${e1.hash},'
            ' ds2.hash: ${e2.hash}');
        expect(e0.hash, equals(e1.hash));
        expect(e0.hash, equals(e2.hash));
        expect(e0.hash, isNot(e3.hash));
        expect(e0.hash, isNot(e4.hash));
        expect(e3.hash, isNot(e4.hash));

        expect(e0.hash.hasValidValues, true);
        expect(e1.hash.hasValidValues, true);
        expect(e2.hash.hasValidValues, true);
        expect(e3.hash.hasValidValues, true);
        expect(e4.hash.hasValidValues, true);

        // Test hash is consistent
        expect(e0.hash == e0.hash, true);
        expect(e1.hash == e1.hash, true);
        expect(e2.hash == e2.hash, true);
        expect(e3.hash == e3.hash, true);
        expect(e4.hash == e4.hash, true);

        // Test hash is not the same
        log..debug(e0.hash)..debug(e1.hash)..debug(e2.hash);
        expect(e0.hash != e3.hash, true);
        expect(e3.hash != e4.hash, true);
        expect(e4.hash != e0.hash, true);
        final e5 = e0.hash;
        expect(e5.hasValidValues, true);
      }
    });
  });
}
