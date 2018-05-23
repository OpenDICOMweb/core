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

  group('TMbytes', () {
    global.throwOnError = false;

    test('TMbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 1);
        final e0 = TMbytes.fromValues(kTime, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('TMbytes from VM.k1_n', () {
      for (var i = 0; i < 10; i++) {
        global.throwOnError = false;

        final vList0 = rsg.getTMList(1, i);
        final e0 = TMbytes.fromValues(kSelectorTMValue, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });
}
