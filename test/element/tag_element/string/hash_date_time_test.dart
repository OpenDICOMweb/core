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
  Server.initialize(name: 'element/hash_time_test', level: Level.info);
  test('String Date', () {
    final vList = <String>['19930822'];
    final e0 = new DAtag(PTag.kCreationDate, vList);
    final e1 = new DAtag(PTag.kCreationDate, vList);
    final e2 = new DAtag(PTag.kStructureSetDate, vList);

    global.throwOnError = true;
    final sha0 = Sha256.stringList(vList);
    log.debug('vList: $vList, sha0: $sha0');
    expect(() => e0.sha256, throwsA(const isInstanceOf<UnsupportedError>()));
    log.debug('e0.hash: ${e0.hash}, e1.hash: ${e1.hash}, e2.hash: ${e2.hash}');

    expect(e0.hash, equals(e1.hash));
    expect(e0.hash, equals(e2.hash));

    //DA.normalization
    final nDate = e0.normalize(Date.parse('19930822'));
    log.debug(nDate);
  });

  test('String DateTime', () {
    final vList = <String>['19530827111300'];
    final e0 = new DTtag(PTag.kFrameAcquisitionDateTime, vList);
    final e1 = new DTtag(PTag.kFrameAcquisitionDateTime, vList);
    final e2 = new DTtag(PTag.kRouteSegmentStartTime, vList);

    global.throwOnError = true;
    final sha0 = Sha256.stringList(vList);
    log.debug('vList: $vList, sha0: $sha0');
//    dt0.sha256;
    expect(() => e0.sha256, throwsA(const isInstanceOf<UnsupportedError>()));

    log.debug(
        'e0.hash: ${e0.hash}, e1.hash: ${e1.hash}, e2.hash: ${e2.hash}');
    expect(e0.hash, equals(e1.hash));
    expect(e0.hash, equals(e2.hash));
  });

  test('String Time', () {
    final vList = rsg.getTMList(1, 1);
    final e0 = new TMtag(PTag.kModifiedImageTime, vList);
    final e1 = new TMtag(PTag.kModifiedImageTime, vList);
    final e2 = new TMtag(PTag.kCreationTime, vList);

    global.throwOnError = true;
    final sha0 = Sha256.stringList(vList);
    log.debug('vList: $vList, sha0: $sha0');
    expect(() => e0.sha256, throwsA(const isInstanceOf<UnsupportedError>()));

    log.debug(
        'e0.hash: ${e0.hash}, e1.hash: ${e1.hash}, e2.hash: ${e2.hash}');
    expect(e0.hash, equals(e1.hash));
    expect(e0.hash, equals(e2.hash));
  });
}
