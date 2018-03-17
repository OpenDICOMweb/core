// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

import '../bd_test_utils.dart';

RSG rsg = new RSG(seed: 1);

void main() {
  Server.initialize(name: 'bd_element/special_test', level: Level.info);

  group('AEtag', () {
    test('AEtag from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getAEList(1, 1);
        system.throwOnError = false;
        final ae1 = new AEtag(PTag.kReceivingAE, vList0);
        log.debug('ae1:$ae1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('ae1.vrIndex: ${ae1.vrIndex}');
        //final bd = bytes.buffer.asByteData();
        final bd1 = makeShortEvr(ae1.code, ae1.vrIndex, bd0);
        final e0 = EvrElement.make(ae1.code,  bd1, ae1.vrIndex);
        log.debug('e0:$e0');
        final make0 = AEtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('AEtag from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getAEList(1, i);
        system.throwOnError = false;
        final ae1 = new AEtag(PTag.kSelectorAEValue, vList0);
        log.debug('ae1:$ae1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('ae1.vrIndex: ${ae1.vrIndex}');
        final bd1 = makeShortEvr(ae1.code, ae1.vrIndex, bd0);
        final e0 = EvrElement.make(ae1.code, bd1, ae1.vrIndex);
        log.debug('e0:$e0');
        final make0 = AEtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });
  });

  group('DStag', () {
    test('DStag from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(1, 1);
        system.throwOnError = false;
        final ds1 = new DStag(PTag.kRequestedImageSize, vList0);
        log.debug('ds1:$ds1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('ds1.vrIndex: ${ds1.vrIndex}');
        final bd1 = makeShortEvr(ds1.code, ds1.vrIndex, bd0);
        final e0 = EvrElement.make(ds1.code, bd1, ds1.vrIndex);
        log.debug('e0:$e0');
        final make0 = DStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('DStag from VM.k2', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(2, 2);
        system.throwOnError = false;
        final ds1 = new DStag(PTag.kRTImagePosition, vList0);
        log.debug('ds1:$ds1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('ds1.vrIndex: ${ds1.vrIndex}');
        final bd1 = makeShortEvr(ds1.code, ds1.vrIndex, bd0);
        final e0 = EvrElement.make(ds1.code, bd1, ds1.vrIndex);
        log.debug('e0:$e0');
        final make0 = DStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('DStag from VM.k3', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(3, 3);
        system.throwOnError = false;
        final ds1 = new DStag(PTag.kNormalizationPoint, vList0);
        log.debug('ds1:$ds1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('ds1.vrIndex: ${ds1.vrIndex}');
        final bd1 = makeShortEvr(ds1.code, ds1.vrIndex, bd0);
        final e0 = EvrElement.make(ds1.code, bd1, ds1.vrIndex);
        log.debug('e0:$e0');
        final make0 = DStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('DStag from VM.k4', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(4, 4);
        system.throwOnError = false;
        final ds1 = new DStag(PTag.kDiaphragmPosition, vList0);
        log.debug('ds1:$ds1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('ds1.vrIndex: ${ds1.vrIndex}');
        final bd1 = makeShortEvr(ds1.code, ds1.vrIndex, bd0);
        final e0 = EvrElement.make(ds1.code, bd1, ds1.vrIndex);
        log.debug('e0:$e0');
        final make0 = DStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('DStag from VM.k6', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(6, 6);
        system.throwOnError = false;
        final ds1 = new DStag(PTag.kImageOrientation, vList0);
        log.debug('ds1:$ds1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('ds1.vrIndex: ${ds1.vrIndex}');
        final bd1 = makeShortEvr(ds1.code, ds1.vrIndex, bd0);
        final e0 = EvrElement.make(ds1.code, bd1, ds1.vrIndex);
        log.debug('e0:$e0');
        final make0 = DStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('DStag from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getDSList(1, i);
        system.throwOnError = false;
        final ds1 = new DStag(PTag.kSelectorDSValue, vList0);
        log.debug('ds1:$ds1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('ds1.vrIndex: ${ds1.vrIndex}');
        final bd1 = makeShortEvr(ds1.code, ds1.vrIndex, bd0);
        final e0 = EvrElement.make(ds1.code, bd1, ds1.vrIndex);
        log.debug('e0:$e0');
        final make0 = DStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('DStag from VM.k1_2', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(1, 2);
        system.throwOnError = false;
        final ds1 = new DStag(PTag.kDetectorActiveDimensions, vList0);
        log.debug('ds1:$ds1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('ds1.vrIndex: ${ds1.vrIndex}');
        final bd1 = makeShortEvr(ds1.code, ds1.vrIndex, bd0);
        final e0 = EvrElement.make(ds1.code, bd1, ds1.vrIndex);
        log.debug('e0:$e0');
        final make0 = DStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('DStag from VM.k2_2n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(10, 10);
        system.throwOnError = false;
        final ds1 = new DStag(PTag.kDVHData, vList0);
        log.debug('ds1:$ds1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('ds1.vrIndex: ${ds1.vrIndex}');
        final bd1 = makeShortEvr(ds1.code, ds1.vrIndex, bd0);
        final e0 = EvrElement.make(ds1.code, bd1, ds1.vrIndex);
        log.debug('e0:$e0');
        final make0 = DStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('DStag from VM.k3_3n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getDSList(9, 9);
        system.throwOnError = false;
        final ds1 = new DStag(PTag.kContourData, vList0);
        log.debug('ds1:$ds1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('ds1.vrIndex: ${ds1.vrIndex}');
        final bd1 = makeShortEvr(ds1.code, ds1.vrIndex, bd0);
        final e0 = EvrElement.make(ds1.code, bd1, ds1.vrIndex);
        log.debug('e0:$e0');
        final make0 = DStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });
  });

  group('OFtag', () {
    final rng = new RNG(1);
    test('OFtag from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float32List(1, 1);
        //final float32List0 = new Float32List.fromList(floatList0);
        //final bytes = float32List0.buffer.asByteData();
        system.throwOnError = false;
        final of1 = new OFtag(PTag.kFloatPixelData, floatList0);
        log.debug('of1:$of1');
        final bd0 = makeFloat32Bytes(floatList0);
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('of1.vrIndex: ${of1.vrIndex}');
        final bd1 = makeLongEvr(of1.code, of1.vrIndex, bd0);
        final e0 = EvrElement.make(of1.code, bd1, of1.vrIndex);
        log.debug('e0:$e0');
        final make0 = OFtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('OFtag from VM.k1_n', () {
      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float32List(1, 1);
        system.throwOnError = false;
        final of1 = new OFtag(PTag.kSelectorOFValue, floatList0);
        log.debug('of1:$of1');
        final bd0 = makeFloat32Bytes(floatList0);
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('of1.vrIndex: ${of1.vrIndex}');
        final bd1 = makeLongEvr(of1.code, of1.vrIndex, bd0);
        final e0 = EvrElement.make(of1.code, bd1, of1.vrIndex);
        log.debug('e0:$e0');
        final make0 = OFtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });
  });

  group('UTtag', () {
    test('UTtag from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        system.throwOnError = false;
        final ut1 = new UTtag(PTag.kSelectorUTValue, vList0);
        log.debug('ut1:$ut1');
        final bd0 = Bytes.utf8Encode(vList0[0]);
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('ut1.vrIndex: ${ut1.vrIndex}');
        //final bd = bytes.buffer.asByteData();
        final bd1 = makeLongEvr(ut1.code, ut1.vrIndex, bd0);
        final e0 = EvrElement.make(ut1.code, bd1, ut1.vrIndex);
        log.debug('e0:$e0');
        final make0 = UTtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });
  });
}
