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
RNG rng = new RNG(1);

void main() {
  Server.initialize(name: 'bd_element/special_test', level: Level.debug);

  final rds = new ByteRootDataset.empty();

  group('ISbytes', () {
    test('ISbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(1, 1);
        global.throwOnError = false;
        final e0 = ISbytes.fromValues(kStageNumber, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('ISbytes from VM.k2', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(2, 2);
        global.throwOnError = false;
        final e0 = ISbytes.fromValues(kCenterOfCircularShutter, vList0);
        log.debug('e0: $e0');
        print('${e0.bytes}');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('ISbytes from VM.k3', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(3, 3);
        global.throwOnError = false;
        final e0 = ISbytes.fromValues(kROIDisplayColor, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));

        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('ISbytes from VM.k2_2n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(10, 10);
        global.throwOnError = false;
        final e0 = ISbytes.fromValues(kVerticesOfThePolygonalShutter, vList0);
        log.debug('e0: $e0');
        log.debug('e0.bytes: ${e0.bytes}');

        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        log.debug('e1.bytes: ${e1.bytes}');
        expect(e0.hasValidValues, true);
      }
    });

    test('ISbytes from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getISList(1, i);
        global.throwOnError = false;
        final e0 = ISbytes.fromValues(kSelectorISValue, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));

        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });
}
