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

  group('DSbytes', () {
    global.throwOnError = false;

    test('DSbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        var vList = rsg.getDSList(1, 1);
        vList = [vList[0].trim()];
        final e0 = DSbytes.fromValues(kRequestedImageSize, vList);
        log.debug('ds0:$e0');
        expect(e0.hasValidValues, true);

        log.debug('e0:$e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e1.hasValidValues, true);
      }
    });

    test('DSbytes from VM.k2', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(2, 2);
        final e0 = DSbytes.fromValues(kRTImagePosition, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e1.hasValidValues, true);
      }
    });

    test('DSbytes from VM.k3', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(3, 3);
        final e0 = DSbytes.fromValues(kNormalizationPoint, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e1.hasValidValues, true);
      }
    });

    test('DSbytes from VM.k4', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(4, 4);
        final e0 = DSbytes.fromValues(kDiaphragmPosition, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('DSbytes from VM.k6', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(6, 6);
        final e0 = DSbytes.fromValues(kImageOrientation, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('DSbytes from VM.k1_n', () {
      global.throwOnError = false;

      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getDSList(1, i);
        final e0 = DSbytes.fromValues(kSelectorDSValue, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('DSbytes from VM.k1_2', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList = rsg.getDSList(1, 2);
        final e0 = DSbytes.fromValues(kDetectorActiveDimensions, vList);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('DSbytes from VM.k2_2n', () {
      global.throwOnError = false;

      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(10, 10);
        final e0 = DSbytes.fromValues(kDVHData, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('DSbytes from VM.k3_3n', () {
      global.throwOnError = false;

      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getDSList(9, 9);
        final e0 = DSbytes.fromValues(kContourData, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });
}
