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

  group('Integer Elements', () {
    test('FL', () {
      final float32List = rng.float32List(1, 1);
      log.debug('float32List: $float32List');
      final fl0 = new FLtag(PTag.kAbsoluteChannelDisplayScale, float32List);
      final fl1 = new FLtag(PTag.kAbsoluteChannelDisplayScale, float32List);
      final fl2 = new FLtag(PTag.kMetersetRateSet, float32List);

      final sha0 = Sha256.float32(float32List);
      log.debug('sha0: $sha0');
      final fl0Update = fl0.update(sha0);
      log
        ..debug('listDouble: $float32List, sha0: $sha0')
        ..debug('fl0.sha256Hash: ${fl0.sha256}')
        ..debug('fl0Update: $fl0Update');

      expect(fl0.sha256, equals(fl0Update));
      expect(fl0.sha256, equals(fl1.sha256));
      expect(fl0.sha256, equals(fl2.sha256));
      expect(fl0.hash, equals(fl0.sha256));
    });

    test('OF', () {
      final float32List = rng.float32List(1, 1);
      log.debug('float32List: $float32List');
      final of0 = new OFtag(PTag.kVectorGridData, float32List);
      final of1 = new OFtag(PTag.kVectorGridData, float32List);
      final of2 = new OFtag(PTag.kFirstOrderPhaseCorrectionAngle, float32List);

      final sha0 = Sha256.float32(float32List);
      log.debug('sha0: $sha0');
      final of0Update = of0.update(sha0);
      log
        ..debug('listDouble: $float32List, sha0: $sha0')
        ..debug('of0.sha256Hash: ${of0.sha256}')
        ..debug('of0Update: $of0Update');

      expect(of0.sha256, equals(of0Update));
      expect(of0.sha256, equals(of1.sha256));
      expect(of0.sha256, equals(of2.sha256));
      expect(of0.hash, equals(of0.sha256));
    });

    test('FD', () {
      final float64List = rng.float64List(1, 1);
      log.debug('float64List: $float64List');
      final fd0 = new FDtag(PTag.kOverallTemplateSpatialTolerance, float64List);
      final fd1 = new FDtag(PTag.kOverallTemplateSpatialTolerance, float64List);
      final fd2 = new FDtag(PTag.kCineRelativeToRealTime, float64List);

      final sha0 = Sha256.float64(float64List);
      log.debug('sha0: $sha0');
      final fd0Update = fd0.update(sha0);
      log
        ..debug('listDouble: $float64List, sha0: $sha0')
        ..debug('fd0.sha256Hash: ${fd1.sha256}')
        ..debug('fd0Update: $fd0Update');

      expect(fd0.sha256, equals(fd0Update));
      expect(fd0.sha256, equals(fd1.sha256));
      expect(fd0.sha256, equals(fd2.sha256));
      expect(fd0.hash, equals(fd0.sha256));
    });

    test('OD', () {
      final float64List = rng.float64List(1, 1);
      log.debug('float64List: $float64List');
      final od0 = new ODtag(PTag.kSelectorODValue, float64List);
      final od1 = new ODtag(PTag.kSelectorODValue, float64List);
      final od2 = new ODtag(PTag.kDoubleFloatPixelData, float64List);

      final sha0 = Sha256.float64(float64List);
      log.debug('sha0: $sha0');
      final od0Update = od0.update(sha0);
      log
        ..debug('listDouble: $float64List, sha0: $sha0')
        ..debug('od1.sha256Hash: ${od1.sha256}')
        ..debug('od0Update: $od0Update');

      expect(od0.sha256, equals(od0Update));
      expect(od0.sha256, equals(od1.sha256));
      expect(od0.sha256, equals(od2.sha256));
      expect(od0.hash, equals(od0.sha256));
    });
  });
}
