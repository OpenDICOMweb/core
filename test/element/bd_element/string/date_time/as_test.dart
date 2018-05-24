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

  group('ASbytes', () {
    test('ASbytes from VM.k1', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        final e0 = ASbytes.fromValues(kPatientAge, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('ASbytes from VM.k1 bad values', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getDAList(1, 1);
        final e0 = ASbytes.fromValues(kPatientAge, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, false);

        global.throwOnError = true;
        expect(() => e0.hasValidValues,
            throwsA(const isInstanceOf<StringError>()));
      }
    });

    test('ASbytes from VM.k1 bad length', () {
      for (var i = 1; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getDAList(2, i + 1);
        final e0 = ASbytes.fromValues(kPatientAge, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, false);
      }
    });

    test('ASbytes from VM.k1_n', () {
      global.throwOnError = false;

      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getASList(1, i);
        final e0 = ASbytes.fromValues(kSelectorASValue, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('ASbytes from VM.k1_n bad values', () {
      for (var i = 1; i < 10; i++) {
        global.throwOnError = false;
        final vList0 = rsg.getDAList(1, i);
        final e0 = ASbytes.fromValues(kSelectorASValue, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, false);

        global.throwOnError = true;
        expect(() => e0.hasValidValues,
            throwsA(const isInstanceOf<StringError>()));
      }
    });
  });
}
