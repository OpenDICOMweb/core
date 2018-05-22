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
  Server.initialize(name: 'element/hash_special_test', level: Level.info);
  test('UI', () {
    final stringList1 = rsg.getUIList(1, 1);
    final ui0 = new UItag(PTag.kStudyInstanceUID, stringList1);

    final sha2 = Sha256.stringList(stringList1);
    log.debug('stringList1: $stringList1;, sha2: $sha2');
    global.throwOnError = true;
    expect(() => ui0.sha256,
        throwsA(const isInstanceOf<UnsupportedError>()));
    expect(() => ui0.hash, throwsA(const isInstanceOf<UnsupportedError>()));
  });

  test('AS', () {
    final stringLst0 = rsg.getASList(1, 1);
    final stringLst1 = rsg.getASList(1, 1);
    final as0 = new AStag(PTag.kPatientAge, stringLst0);
    final as1 = new AStag(PTag.kPatientAge, stringLst0);
    final as2 = new AStag(PTag.kPatientAge, stringLst1);

    final sha0 = as0.sha256;
    expect(sha0.hasValidValues, true);
    expect(AS.isValidValues(PTag.kPatientAge, sha0.values), true);

    final sha1 = as1.sha256;
    expect(sha1.hasValidValues, true);
    expect(AS.isValidValues(PTag.kPatientAge, sha1.values), true);

    final sha2 = as2.sha256;
    expect(sha2.hasValidValues, true);
    expect(AS.isValidValues(PTag.kPatientAge, sha2.values), true);

    log.debug(
        'as0.hash: ${as0.hash}, as1.hash: ${as1.hash}, as2.hash: ${as2.hash}');
    var hash0 = as0.acrHash;
    log.debug('hash0: ${hash0.info}');
    var hash1 = as1.acrHash;
    log.debug('hash1: ${hash0.info}');
    expect(hash0, equals(hash1));
    expect(hash0 == hash1, true);

    hash0 = as0.hash;
    log.debug('hash0: ${hash0.info}');
    hash1 = as1.hash;
    log.debug('hash1: ${hash0.info}');
    expect(hash0, equals(hash1));
    expect(hash0 == hash1, true);
  });

  test('DS', () {
    final stringLst0 = rsg.getDSList(1, 1);
    final stringLst1 = rsg.getDSList(1, 1);
    final ds0 = new DStag(PTag.kProcedureStepProgress, stringLst0);
    final ds1 = new DStag(PTag.kProcedureStepProgress, stringLst0);
    final ds2 = new DStag(PTag.kProcedureStepProgress, stringLst1);
    log.debug('ds0.hash: ${ds0.hash}, ds1.hash: ${ds1.hash}');
    final hash0 = ds0.hash;
    final hash1 = ds1.hash;
    final hash2 = ds2.hash;
    expect(hash0, equals(hash1));
    expect(hash0 == hash1, true);
    expect(hash0 == hash2, false);

    final sha0 = ds0.sha256;
    log.debug('sha0: $sha0');
    expect(sha0.hasValidValues, true);
    expect(DS.isValidValues(PTag.kPatientSize, sha0.values), true);

    final sha1 = ds1.sha256;
    expect(sha1.hasValidValues, true);
    expect(DS.isValidValues(PTag.kPatientSize, sha1.values), true);

    final sha2 = ds2.sha256;
    expect(sha2.hasValidValues, true);
    expect(DS.isValidValues(PTag.kPatientSize, sha2.values), true);
  });
}
