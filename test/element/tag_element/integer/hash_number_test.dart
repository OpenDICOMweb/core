// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = new RSG(seed: 1);

void main() {
  Server.initialize(name: 'element/hash_number_test', level: Level.info);
  test('Integer Strings', () {
    final stringList0 = rsg.getISList(1, 1);
    final is0 = new IStag(PTag.kEvaluatorNumber, stringList0);
    final is1 = new IStag(PTag.kEvaluatorNumber, stringList0);
    final is2 = new IStag(PTag.kEvaluationAttempt, stringList0);

    system.throwOnError = true;
    final hash0 = Sha256.stringList(stringList0);
    log.debug('stringList0: $stringList0, hash0: $hash0');
    expect(() => is0.sha256,
        throwsA(const isInstanceOf<Sha256UnsupportedError>()));

    expect(
        () => is1.hash, throwsA(const isInstanceOf<Sha256UnsupportedError>()));
    expect(
        () => is2.hash, throwsA(const isInstanceOf<Sha256UnsupportedError>()));
    //expect(is0.hash != is2.hash, true);

    final stringList1 = rsg.getDSList(1, 1);
    final ds0 = new DStag(PTag.kDeadTimeFactor, stringList1);
    final ds1 = new DStag(PTag.kDeadTimeFactor, stringList1);
    final ds2 = new DStag(PTag.kSelectorDSValue, stringList1);

    system.throwOnError = false;
    final hash1 = Sha256.stringList(stringList1);
    log.debug('stringList1: $stringList1, hash1: $hash1');
    expect(ds0.sha256, isNotNull);

    /*expect(() => ds0.sha256,
        throwsA(const isInstanceOf<Sha256UnsupportedError>()));*/

    log.debug('ds0.hash: ${ds0.hash}, ds1.hash: ${ds1.hash},'
        ' ds2.hash: ${ds2.hash}');
    expect(ds0.hash, equals(ds1.hash));
    expect(ds0.hash, equals(ds2.hash));
  });
}
