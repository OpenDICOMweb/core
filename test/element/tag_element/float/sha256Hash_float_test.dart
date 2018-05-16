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
  Server.initialize(name: 'element/sha256Hash_float_test', level: Level.info);
  final rng = new RNG(1);
  global.throwOnError = false;

  group('Float Elements', () {
    test('FL', () {
      final vList = rng.float32List(1, 1);
      log.debug('float32List: $vList');
      final e0 = new FLtag(PTag.kAbsoluteChannelDisplayScale, vList);
      final e1 = new FLtag(PTag.kAbsoluteChannelDisplayScale, vList);
      final e2 = new FLtag(PTag.kMetersetRateSet, vList);

      final sha0 = Sha256.float32(vList);
      log.debug('sha0: $sha0');
      final fl0Update = e0.update(sha0);
      log
        ..debug('listDouble: $vList, sha0: $sha0')
        ..debug('e0.sha256Hash: ${e0.sha256}')
        ..debug('fl0Update: $fl0Update');

      expect(e0.sha256, equals(fl0Update));
      expect(e0.sha256, equals(e1.sha256));
      expect(e0.sha256, equals(e2.sha256));
      expect(e0.hash, equals(e0.sha256));
    });

    test('OF', () {
      final vList = rng.float32List(1, 1);
      log.debug('vList: $vList');
      final e0 = new OFtag(PTag.kVectorGridData, vList);
      final e1 = new OFtag(PTag.kVectorGridData, vList);
      final e2 = new OFtag(PTag.kFirstOrderPhaseCorrectionAngle, vList);

      final sha0 = Sha256.float32(vList);
      log.debug('sha0: $sha0');
      final of0Update = e0.update(sha0);
      log
        ..debug('listDouble: $vList, sha0: $sha0')
        ..debug('e0.sha256Hash: ${e0.sha256}')
        ..debug('of0Update: $of0Update');

      expect(e0.sha256, equals(of0Update));
      expect(e0.sha256, equals(e1.sha256));
      expect(e0.sha256, equals(e2.sha256));
      expect(e0.hash, equals(e0.sha256));
    });

    test('FD', () {
      final vList = rng.float64List(1, 1);
      log.debug('vList: $vList');
      final e0 = new FDtag(PTag.kOverallTemplateSpatialTolerance, vList);
      final e1 = new FDtag(PTag.kOverallTemplateSpatialTolerance, vList);
      final e2 = new FDtag(PTag.kCineRelativeToRealTime, vList);

      final sha0 = Sha256.float64(vList);
      log.debug('sha0: $sha0');
      final fd0Update = e0.update(sha0);
      log
        ..debug('listDouble: $vList, sha0: $sha0')
        ..debug('e1.sha256Hash: ${e1.sha256}')
        ..debug('fd0Update: $fd0Update');

      expect(e0.sha256, equals(fd0Update));
      expect(e0.sha256, equals(e1.sha256));
      expect(e0.sha256, equals(e2.sha256));
      expect(e0.hash, equals(e0.sha256));
    });

    test('OD', () {
      final vList = rng.float64List(1, 1);
      log.debug('vList: $vList');
      final e0 = new ODtag(PTag.kSelectorODValue, vList);
      final e1 = new ODtag(PTag.kSelectorODValue, vList);
      final e2 = new ODtag(PTag.kDoubleFloatPixelData, vList);

      final sha0 = Sha256.float64(vList);
      log.debug('sha0: $sha0');
      final od0Update = e0.update(sha0);
      log
        ..debug('listDouble: $vList, sha0: $sha0')
        ..debug('e1.sha256Hash: ${e1.sha256}')
        ..debug('od0Update: $od0Update');

      expect(e0.sha256, equals(od0Update));
      expect(e0.sha256, equals(e1.sha256));
      expect(e0.sha256, equals(e2.sha256));
      expect(e0.hash, equals(e0.sha256));
    });
  });
}
