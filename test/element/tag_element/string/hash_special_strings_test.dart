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
  Server.initialize(name: 'element/hash_special_test', level: Level.info);
  test('UI', () {
    final vList0 = rsg.getUIList(1, 1);
    final e0 = UItag(PTag.kStudyInstanceUID, vList0);

    final sha2 = Sha256.stringList(vList0);
    log.debug('vList0: $vList0;, sha2: $sha2');
    global.throwOnError = true;
    expect(() => e0.sha256, throwsA(const TypeMatcher<UnsupportedError>()));
    expect(() => e0.hash, throwsA(const TypeMatcher<UnsupportedError>()));
  });

  test('AS', () {
    final vList0 = rsg.getASList(1, 1);
    final vList1 = rsg.getASList(1, 1);
    final e0 = AStag(PTag.kPatientAge, vList0);
    final e1 = AStag(PTag.kPatientAge, vList0);
    final e2 = AStag(PTag.kPatientAge, vList1);

    final sha0 = e0.sha256;
    expect(sha0.hasValidValues, true);
    expect(AS.isValidValues(PTag.kPatientAge, sha0.values), true);

    final sha1 = e1.sha256;
    expect(sha1.hasValidValues, true);
    expect(AS.isValidValues(PTag.kPatientAge, sha1.values), true);

    final sha2 = e2.sha256;
    expect(sha2.hasValidValues, true);
    expect(AS.isValidValues(PTag.kPatientAge, sha2.values), true);

    log.debug('e0.hash: ${e0.hash}, e1.hash: ${e1.hash}, e2.hash: ${e2.hash}');
    var hash0 = e0.acrHash;
    log.debug('hash0: ${hash0.info}');
    var hash1 = e1.acrHash;
    log.debug('hash1: ${hash0.info}');
    expect(hash0, equals(hash1));
    expect(hash0 == hash1, true);

    hash0 = e0.hash;
    log.debug('hash0: ${hash0.info}');
    hash1 = e1.hash;
    log.debug('hash1: ${hash0.info}');
    expect(hash0, equals(hash1));
    expect(hash0 == hash1, true);
  });

  test('DS', () {
    final vList0 = rsg.getDSList(1, 1);
    final vList1 = rsg.getDSList(1, 1);
    final e0 = DStag(PTag.kProcedureStepProgress, vList0);
    final e1 = DStag(PTag.kProcedureStepProgress, vList0);
    final e2 = DStag(PTag.kProcedureStepProgress, vList1);
    log.debug('e0.hash: ${e0.hash}, e1.hash: ${e1.hash}');
    final hash0 = e0.hash;
    final hash1 = e1.hash;
    final hash2 = e2.hash;
    expect(hash0, equals(hash1));
    expect(hash0 == hash1, true);
    expect(hash0 == hash2, false);

    final sha0 = e0.sha256;
    log.debug('sha0: $sha0');
    expect(sha0.hasValidValues, true);
    expect(DS.isValidValues(PTag.kPatientSize, sha0.values), true);

    final sha1 = e1.sha256;
    expect(sha1.hasValidValues, true);
    expect(DS.isValidValues(PTag.kPatientSize, sha1.values), true);

    final sha2 = e2.sha256;
    expect(sha2.hasValidValues, true);
    expect(DS.isValidValues(PTag.kPatientSize, sha2.values), true);
  });
}
