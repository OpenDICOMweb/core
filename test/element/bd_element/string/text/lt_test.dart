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

  group('LTbytes', () {
    test('LTbytes from VM.k1', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        final e0 = LTbytes.fromValues(kPatientComments, vList0);
        print('vfBytes: ${e0.vfBytes}');
        print('e0.bytes: ${e0.bytes}');
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        print('e1.bytes: ${e1.bytes}');
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });
}