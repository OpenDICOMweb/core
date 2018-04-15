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
    final stringList = <String>['19930822'];
    final da0 = new DAtag(PTag.kCreationDate, stringList);
    final da1 = new DAtag(PTag.kCreationDate, stringList);
    final da2 = new DAtag(PTag.kStructureSetDate, stringList);

    system.throwOnError = true;
    final sha0 = Sha256.stringList(stringList);
    log.debug('stringList: $stringList, sha0: $sha0');
    expect(() => da0.sha256, throwsA(const isInstanceOf<UnsupportedError>()));
    log.debug(
        'da0.hash: ${da0.hash}, da1.hash: ${da1.hash}, da2.hash: ${da2.hash}');

    expect(da0.hash, equals(da1.hash));
    expect(da0.hash, equals(da2.hash));

    //DA.normalization
    final nDate = da0.normalize(Date.parse('19930822'));
    log.debug(nDate);
  });

  test('String DateTime', () {
    final stringList = <String>['19530827111300'];
    final dt0 = new DTtag(PTag.kFrameAcquisitionDateTime, stringList);
    final dt1 = new DTtag(PTag.kFrameAcquisitionDateTime, stringList);
    final dt2 = new DTtag(PTag.kRouteSegmentStartTime, stringList);

    system.throwOnError = true;
    final sha0 = Sha256.stringList(stringList);
    log.debug('stringList: $stringList, sha0: $sha0');
//    dt0.sha256;
    expect(() => dt0.sha256,
        throwsA(const isInstanceOf<UnsupportedError>()));

    log.debug(
        'dt0.hash: ${dt0.hash}, dt1.hash: ${dt1.hash}, dt2.hash: ${dt2.hash}');
    expect(dt0.hash, equals(dt1.hash));
    expect(dt0.hash, equals(dt2.hash));
  });

  test('String Time', () {
    final stringList = rsg.getTMList(1, 1);
    final tm0 = new TMtag(PTag.kModifiedImageTime, stringList);
    final tm1 = new TMtag(PTag.kModifiedImageTime, stringList);
    final tm2 = new TMtag(PTag.kCreationTime, stringList);

    system.throwOnError = true;
    final sha0 = Sha256.stringList(stringList);
    log.debug('stringList: $stringList, sha0: $sha0');
    expect(() => tm0.sha256, throwsA(const isInstanceOf<UnsupportedError>()));

    log.debug(
        'tm0.hash: ${tm0.hash}, tm1.hash: ${tm1.hash}, tm2.hash: ${tm2.hash}');
    expect(tm0.hash, equals(tm1.hash));
    expect(tm0.hash, equals(tm2.hash));
  });
}
