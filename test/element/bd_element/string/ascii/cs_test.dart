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
  Server.initialize(name: 'bd_element/special_test', level: Level.info);

  final rds = new ByteRootDataset.empty();

  group('CSbytes', () {
    test('CSbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        global.throwOnError = false;
        final e0 = CSbytes.fromValues(kLaterality, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('CSbytes from VM.k2', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(2, 2);
        global.throwOnError = false;
        final e0 = CSbytes.fromValues(kPatientOrientation, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('CSbytes from VM.k2_n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(2, 2);
        global.throwOnError = false;
        final e0 = CSbytes.fromValues(kImageType, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
    test('CSbytes from VM.k4', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(4, 4);
        final e0 = CSbytes.fromValues(kFrameType, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('CSbytes from VM.k1_n', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, i);
print('vList0: $vList0');
        final e0 = CSbytes.fromValues(kSelectorCSValue, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });
}