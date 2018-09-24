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
RNG rng = RNG(1);

void main() {
  Server.initialize(name: 'bd_element/special_test', level: Level.info);

  final rds = ByteRootDataset.empty();

  group('AEbytes', () {
    test('AEbytes from VM.k1', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList = rsg.getAEList(1, 1);
        final bytes = DicomBytes.fromAsciiList(vList);
        log..debug('vList: $vList')..debug('bd: $bytes');

        final e0 = AEbytes.fromValues(kReceivingAE, vList);
        log..debug('e0: $e0')..debug('vList: $vList')..debug('bd: $bytes');
        expect(e0.hasValidValues, true);
        expect(e0.vfBytes == bytes, true);

        final e1 = ByteElement.makeFromBytes(e0.bytes, rds, isEvr: true);
        log..debug('e1: $e1')..debug('vList: $vList')..debug('bd: $bytes');
        expect(e1.hasValidValues, true);
        expect(e1 == e0, true);
        expect(e1.vfBytes == bytes, true);

        final e2 = AEbytes.fromValues(kReceivingAE, vList);
        log.debug('e2: $e2');
 // Urgent Sharath: what is next line doing?
        e2.vfBytes == bytes;
        expect(e2.hasValidValues, true);
        expect(e2.vfBytes == bytes, true);
        expect(e2 == e1, true);

        final e3 = AEbytes.fromValues(kReceivingAE, vList);
        log.debug('e3:$e3');
        expect(e3.hasValidValues, true);
        expect(e3.vfBytes == bytes, true);
        expect(e3 == e2, true);
      }
    });

    test('AEbytes from VM.k1_n', () {
      global.throwOnError = false;

      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getAEList(1, i);
//        final bd0 = DicomBytes.fromAscii(vList0.join('\\'));

        final e0 = AEbytes.fromValues(kSelectorOFValue, vList0);
        log.debug('ae1:$e0');
        expect(e0, isNull);
/*
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
        log.debug('e1:$e1');
        expect(e1.hasValidValues, true);
        expect(e0 == e1, true);
*/

      }
    });
  });
}