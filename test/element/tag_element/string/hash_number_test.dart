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
import 'package:test_tools/tools.dart';

RSG rsg = new RSG(seed: 1);

void main() {
  Server.initialize(name: 'element/hash_number_test', level: Level.info);
  group('Integer Strings', () {
    test('IS', () {
      for (var i = 0; i <= 10; i++) {
        final stringList0 = rsg.getISList(1, 1);
        final is0 = new IStag(PTag.kEvaluatorNumber, stringList0);
        final is1 = new IStag(PTag.kEvaluatorNumber, stringList0);
        final is2 = new IStag(PTag.kEvaluationAttempt, stringList0);
        final is3 = new IStag(PTag.kEvaluatorNumber, rsg.getISList(1, 1));
        final is4 = new IStag(PTag.kEvaluationAttempt, rsg.getISList(1, 1));

        global.throwOnError = true;
        final hash0 = Sha256.stringList(stringList0);
        log.debug('stringList0: $stringList0, hash0: $hash0');
        expect(() => is0.sha256,
            throwsA(const isInstanceOf<UnsupportedError>()));

        expect(is0.hash, equals(is1.hash));
        expect(is0.hash, equals(is2.hash));
        expect(is1.hash, equals(is2.hash));
        expect(is0.hash, isNot(is3.hash));
        expect(is1.hash, isNot(is4.hash));
        expect(is3.hash, isNot(is4.hash));

        expect(is0.hash.hasValidValues, true);
        expect(is3.hash.hasValidValues, true);
        expect(is4.hash.hasValidValues, true);

        // Test hash is consistent
        expect(is0.hash == is0.hash, true);
        expect(is3.hash == is3.hash, true);
        expect(is4.hash == is4.hash, true);

        // Test hash is not the same
        log..debug(is0.hash)..debug(is3.hash)..debug(is4.hash);
        expect(is0.hash != is3.hash, true);
        expect(is3.hash != is4.hash, true);
        expect(is4.hash != is0.hash, true);
        final is5 = is0.hash;
        expect(is5.hasValidValues, true);
      }
    });

    test('DS', () {
      for (var i = 0; i <= 10; i++) {
        final stringList1 = rsg.getDSList(1, 1);
        final ds0 = new DStag(PTag.kDeadTimeFactor, stringList1);
        final ds1 = new DStag(PTag.kDeadTimeFactor, stringList1);
        final ds2 = new DStag(PTag.kSelectorDSValue, stringList1);
        final ds3 = new DStag(PTag.kDeadTimeFactor, rsg.getDSList(1, 1));
        final ds4 = new DStag(PTag.kDeadTimeFactor, rsg.getDSList(1, 1));

        global.throwOnError = false;
        final hash1 = Sha256.stringList(stringList1);
        log.debug('stringList1: $stringList1, hash1: $hash1');
        expect(ds0.sha256, isNotNull);

        log.debug('ds0.hash: ${ds0.hash}, ds1.hash: ${ds1.hash},'
            ' ds2.hash: ${ds2.hash}');
        expect(ds0.hash, equals(ds1.hash));
        expect(ds0.hash, equals(ds2.hash));
        expect(ds0.hash, isNot(ds3.hash));
        expect(ds0.hash, isNot(ds4.hash));
        expect(ds3.hash, isNot(ds4.hash));

        expect(ds0.hash.hasValidValues, true);
        expect(ds1.hash.hasValidValues, true);
        expect(ds2.hash.hasValidValues, true);
        expect(ds3.hash.hasValidValues, true);
        expect(ds4.hash.hasValidValues, true);

        // Test hash is consistent
        expect(ds0.hash == ds0.hash, true);
        expect(ds1.hash == ds1.hash, true);
        expect(ds2.hash == ds2.hash, true);
        expect(ds3.hash == ds3.hash, true);
        expect(ds4.hash == ds4.hash, true);

        // Test hash is not the same
        log..debug(ds0.hash)..debug(ds1.hash)..debug(ds2.hash);
        expect(ds0.hash != ds3.hash, true);
        expect(ds3.hash != ds4.hash, true);
        expect(ds4.hash != ds0.hash, true);
        final ds5 = ds0.hash;
        expect(ds5.hasValidValues, true);
      }
    });
  });
}
