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

import '../bd_test_utils.dart';

RSG rsg = new RSG(seed: 1);
RNG rng = new RNG(1);

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
        final e0 = EvrElement.makeFromBytes(ae1.code, bd1, ae1.vrIndex);
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
        final e0 = EvrElement.makeFromBytes(ae1.code, bd1, ae1.vrIndex);
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
        final e0 = EvrElement.makeFromBytes(ds1.code, bd1, ds1.vrIndex);
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
        final e0 = EvrElement.makeFromBytes(ds1.code, bd1, ds1.vrIndex);
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
        final e0 = EvrElement.makeFromBytes(ds1.code, bd1, ds1.vrIndex);
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
        final e0 = EvrElement.makeFromBytes(ds1.code, bd1, ds1.vrIndex);
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
        final e0 = EvrElement.makeFromBytes(ds1.code, bd1, ds1.vrIndex);
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
        final e0 = EvrElement.makeFromBytes(ds1.code, bd1, ds1.vrIndex);
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
        final e0 = EvrElement.makeFromBytes(ds1.code, bd1, ds1.vrIndex);
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
        final e0 = EvrElement.makeFromBytes(ds1.code, bd1, ds1.vrIndex);
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
        final e0 = EvrElement.makeFromBytes(ds1.code, bd1, ds1.vrIndex);
        log.debug('e0:$e0');
        final make0 = DStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });
  });

  group('IStag', () {
    test('IStag from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(1, 1);
        system.throwOnError = false;
        final is1 = new IStag(PTag.kStageNumber, vList0);
        log.debug('is1:$is1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('is1.vrIndex: ${is1.vrIndex}');
        final bd1 = makeShortEvr(is1.code, is1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(is1.code, bd1, is1.vrIndex);
        log.debug('e0:$e0');
        final make0 = IStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('IStag from VM.k2', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(2, 2);
        system.throwOnError = false;
        final is1 = new IStag(PTag.kCenterOfCircularShutter, vList0);
        log.debug('is1:$is1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('is1.vrIndex: ${is1.vrIndex}');
        final bd1 = makeShortEvr(is1.code, is1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(is1.code, bd1, is1.vrIndex);
        log.debug('e0:$e0');
        final make0 = IStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('IStag from VM.k3', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(3, 3);
        system.throwOnError = false;
        final is1 = new IStag(PTag.kROIDisplayColor, vList0);
        log.debug('is1:$is1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('is1.vrIndex: ${is1.vrIndex}');
        final bd1 = makeShortEvr(is1.code, is1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(is1.code, bd1, is1.vrIndex);
        log.debug('e0:$e0');
        final make0 = IStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('IStag from VM.k2_2n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(10, 10);
        system.throwOnError = false;
        final is1 = new IStag(PTag.kVerticesOfThePolygonalShutter, vList0);
        log.debug('is1:$is1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('is1.vrIndex: ${is1.vrIndex}');
        final bd1 = makeShortEvr(is1.code, is1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(is1.code, bd1, is1.vrIndex);
        log.debug('e0:$e0');
        final make0 = IStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('IStag from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getISList(1, i);
        system.throwOnError = false;
        final is1 = new IStag(PTag.kSelectorISValue, vList0);
        log.debug('is1:$is1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('is1.vrIndex: ${is1.vrIndex}');
        final bd1 = makeShortEvr(is1.code, is1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(is1.code, bd1, is1.vrIndex);
        log.debug('e0:$e0');
        final make0 = IStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });
  });

  group('AStag', () {
    test('AStag from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        system.throwOnError = false;
        final as1 = new AStag(PTag.kPatientAge, vList0);
        log.debug('as1:$as1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('as1.vrIndex: ${as1.vrIndex}');
        final bd1 = makeShortEvr(as1.code, as1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(as1.code, bd1, as1.vrIndex);
        log.debug('e0:$e0');
        final make0 = AStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('AStag from VM.k1_n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, i);
        system.throwOnError = false;
        final as1 = new AStag(PTag.kSelectorASValue, vList0);
        log.debug('as1:$as1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('as1.vrIndex: ${as1.vrIndex}');
        final bd1 = makeShortEvr(as1.code, as1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(as1.code, bd1, as1.vrIndex);
        log.debug('e0:$e0');
        final make0 = AStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });
  });

  group('CStag', () {
    test('CSTag from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        system.throwOnError = false;
        final cs1 = new CStag(PTag.kLaterality, vList0);
        log.debug('cs1:$cs1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('cs1.vrIndex: ${cs1.vrIndex}');
        final bd1 = makeShortEvr(cs1.code, cs1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(cs1.code, bd1, cs1.vrIndex);
        log.debug('e0:$e0');
        final make0 = CStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('CSTag from VM.k2', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(2, 2);
        system.throwOnError = false;
        final cs1 = new CStag(PTag.kPatientOrientation, vList0);
        log.debug('cs1:$cs1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('cs1.vrIndex: ${cs1.vrIndex}');
        final bd1 = makeShortEvr(cs1.code, cs1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(cs1.code, bd1, cs1.vrIndex);
        log.debug('e0:$e0');
        final make0 = CStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('CSTag from VM.k2_n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(2, 2);
        system.throwOnError = false;
        final cs1 = new CStag(PTag.kImageType, vList0);
        log.debug('cs1:$cs1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('cs1.vrIndex: ${cs1.vrIndex}');
        final bd1 = makeShortEvr(cs1.code, cs1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(cs1.code, bd1, cs1.vrIndex);
        log.debug('e0:$e0');
        final make0 = CStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });
    test('CSTag from VM.k4', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(4, 4);
        system.throwOnError = false;
        final cs1 = new CStag(PTag.kFrameType, vList0);
        log.debug('cs1:$cs1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('cs1.vrIndex: ${cs1.vrIndex}');
        final bd1 = makeShortEvr(cs1.code, cs1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(cs1.code, bd1, cs1.vrIndex);
        log.debug('e0:$e0');
        final make0 = CStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('CSTag from VM.k1_n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, i);
        system.throwOnError = false;
        final cs1 = new CStag(PTag.kSelectorCSValue, vList0);
        log.debug('cs1:$cs1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('cs1.vrIndex: ${cs1.vrIndex}');
        final bd1 = makeShortEvr(cs1.code, cs1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(cs1.code, bd1, cs1.vrIndex);
        log.debug('e0:$e0');
        final make0 = CStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });
  });

  group('DTtag', () {
    test('DTtag from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        system.throwOnError = false;
        final dt1 = new DTtag(PTag.kDateTime, vList0);
        log.debug('dt1:$dt1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('dt1.vrIndex: ${dt1.vrIndex}');
        final bd1 = makeShortEvr(dt1.code, dt1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(dt1.code, bd1, dt1.vrIndex);
        log.debug('e0:$e0');
        final make0 = DTtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('DTtag from VM.k1_n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDTList(1, i);
        system.throwOnError = false;
        final dt1 = new DTtag(PTag.kSelectorDTValue, vList0);
        log.debug('dt1:$dt1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('dt1.vrIndex: ${dt1.vrIndex}');
        final bd1 = makeShortEvr(dt1.code, dt1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(dt1.code, bd1, dt1.vrIndex);
        log.debug('e0:$e0');
        final make0 = DTtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });
  });

  group('TMtag', () {
    test('TMtag from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 1);
        system.throwOnError = false;
        final tm1 = new TMtag(PTag.kTime, vList0);
        log.debug('tm1:$tm1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('tm1.vrIndex: ${tm1.vrIndex}');
        final bd1 = makeShortEvr(tm1.code, tm1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(tm1.code, bd1, tm1.vrIndex);
        log.debug('e0:$e0');
        final make0 = TMtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('TMtag from VM.k1_n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, i);
        system.throwOnError = false;
        final tm1 = new TMtag(PTag.kSelectorTMValue, vList0);
        log.debug('tm1:$tm1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('tm1.vrIndex: ${tm1.vrIndex}');
        final bd1 = makeShortEvr(tm1.code, tm1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(tm1.code, bd1, tm1.vrIndex);
        log.debug('e0:$e0');
        final make0 = TMtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });
  });

  group('LOtag', () {
    test('LOtag from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        system.throwOnError = false;
        final lo1 = new LOtag(PTag.kManufacturer, vList0);
        log.debug('lo1:$lo1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('lo1.vrIndex: ${lo1.vrIndex}');
        final bd1 = makeShortEvr(lo1.code, lo1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(lo1.code, bd1, lo1.vrIndex);
        log.debug('e0:$e0');
        final make0 = LOtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('LOtag from VM.k1_n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, i);
        system.throwOnError = false;
        final lo1 = new LOtag(PTag.kSelectorLOValue, vList0);
        log.debug('lo1:$lo1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('lo1.vrIndex: ${lo1.vrIndex}');
        final bd1 = makeShortEvr(lo1.code, lo1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(lo1.code, bd1, lo1.vrIndex);
        log.debug('e0:$e0');
        final make0 = LOtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });
  });

  group('PNtag', () {
    test('PNtag from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        system.throwOnError = false;
        final pn1 = new PNtag(PTag.kEvaluatorName, vList0);
        log.debug('pn1:$pn1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('pn1.vrIndex: ${pn1.vrIndex}');
        final bd1 = makeShortEvr(pn1.code, pn1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(pn1.code, bd1, pn1.vrIndex);
        log.debug('e0:$e0');
        final make0 = PNtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('PNtag from VM.k1_n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, i);
        system.throwOnError = false;
        final pn1 = new PNtag(PTag.kSelectorPNValue, vList0);
        log.debug('pn1:$pn1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('pn1.vrIndex: ${pn1.vrIndex}');
        final bd1 = makeShortEvr(pn1.code, pn1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(pn1.code, bd1, pn1.vrIndex);
        log.debug('e0:$e0');
        final make0 = PNtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });
  });

  group('SHtag', () {
    test('SHtag from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 1);
        system.throwOnError = false;
        final sh1 = new SHtag(PTag.kCodeValue, vList0);
        log.debug('sh1:$sh1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('sh1.vrIndex: ${sh1.vrIndex}');
        final bd1 = makeShortEvr(sh1.code, sh1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(sh1.code, bd1, sh1.vrIndex);
        log.debug('e0:$e0');
        final make0 = SHtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('SHtag from VM.k1_n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, i);
        system.throwOnError = false;
        final sh1 = new SHtag(PTag.kSelectorSHValue, vList0);
        log.debug('sh1:$sh1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('sh1.vrIndex: ${sh1.vrIndex}');
        final bd1 = makeShortEvr(sh1.code, sh1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(sh1.code, bd1, sh1.vrIndex);
        log.debug('e0:$e0');
        final make0 = SHtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });
  });

  group('LTtag', () {
    test('LTtag from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        system.throwOnError = false;
        final lt1 = new LTtag(PTag.kPatientComments, vList0);
        log.debug('lt1:$lt1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('lt1.vrIndex: ${lt1.vrIndex}');
        final bd1 = makeShortEvr(lt1.code, lt1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(lt1.code, bd1, lt1.vrIndex);
        log.debug('e0:$e0');
        final make0 = LTtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });
  });

  group('STtag', () {
    test('STtag from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        system.throwOnError = false;
        final st1 = new STtag(PTag.kSelectorSTValue, vList0);
        log.debug('st1:$st1');
        final bd0 = Bytes.asciiEncode(vList0.join('\\'));
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('st1.vrIndex: ${st1.vrIndex}');
        final bd1 = makeShortEvr(st1.code, st1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(st1.code, bd1, st1.vrIndex);
        log.debug('e0:$e0');
        final make0 = STtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });
  });

  group('FDtag', () {
    test('FDtag from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float64List(1, 1);
        system.throwOnError = false;
        final fd1 =
            new FDtag(PTag.kOverallTemplateSpatialTolerance, floatList0);
        log.debug('fd1:$fd1');
        final bd0 = makeFloat64Bytes(floatList0);
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('fd1.vrIndex: ${fd1.vrIndex}');
        final bd1 = makeLongEvr(fd1.code, fd1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(fd1.code, bd1, fd1.vrIndex);
        log.debug('e0:$e0');
        final make0 = FDtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('FDtag from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final floatList0 = rng.float64List(1, i);
        system.throwOnError = false;
        final fd1 = new FDtag(PTag.kSelectorFDValue, floatList0);
        log.debug('fd1:$fd1');
        final bd0 = makeFloat64Bytes(floatList0);
        log
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('fd1.vrIndex: ${fd1.vrIndex}');
        final bd1 = makeLongEvr(fd1.code, fd1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(fd1.code, bd1, fd1.vrIndex);
        log.debug('e0:$e0');
        final make0 = FDtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });
  });

  group('OFtag', () {
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
        final e0 = EvrElement.makeFromBytes(of1.code, bd1, of1.vrIndex);
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
        final e0 = EvrElement.makeFromBytes(of1.code, bd1, of1.vrIndex);
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
        final e0 = EvrElement.makeFromBytes(ut1.code, bd1, ut1.vrIndex);
        log.debug('e0:$e0');
        final make0 = UTtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });
  });

  group('ATtag', () {
    system.level = Level.debug;
    test('ATtag from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        system.throwOnError = false;
        final at1 = new ATtag(PTag.kDimensionIndexPointer, vList0);
        log.debug('at1:$at1');
        final bd0 = new Bytes.fromList(vList0);
        log
          ..debug('bd0: $bd0')
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('at1.vrIndex: ${at1.vrIndex}');
        final bd1 = makeShortEvr(at1.code, at1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(at1.code, bd1, at1.vrIndex);
        log.debug('e0:$e0');
        final make0 = ATtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('ATtag from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint32List(1, i);
        system.throwOnError = false;
        final at1 = new ATtag(PTag.kSelectorATValue, vList0);
        log.debug('at1:$at1');
        final bd0 = new Bytes.fromList(vList0);
        log
          ..debug('bd0: $bd0')
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('at1.vrIndex: ${at1.vrIndex}');
        final bd1 = makeShortEvr(at1.code, at1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(at1.code, bd1, at1.vrIndex);
        log.debug('e0:$e0');
        final make0 = ATtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });
  });

  group('ULtag', () {
    system.level = Level.debug;
    test('ULtag from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        system.throwOnError = false;
        final ul1 = new ULtag(PTag.kRegionFlags, vList0);
        log.debug('ul1:$ul1');
        final bd0 = new Bytes.fromList(vList0);
        log
          ..debug('bd0: $bd0')
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('ul1.vrIndex: ${ul1.vrIndex}');
        final bd1 = makeShortEvr(ul1.code, ul1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(ul1.code, bd1, ul1.vrIndex);
        log.debug('e0:$e0');
        final make0 = ULtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('ULtag from VM.k3', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(3, 3);
        system.throwOnError = false;
        final ul1 = new ULtag(PTag.kGridDimensions, vList0);
        log.debug('ul1:$ul1');
        final bd0 = new Bytes.fromTypedData(vList0);
        log
          ..debug('bd0: $bd0')
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('us1.vrIndex: ${ul1.vrIndex}');
        final bd1 = makeShortEvr(ul1.code, ul1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(ul1.code, bd1, ul1.vrIndex);
        log.debug('e0:$e0');
        final make0 = ULtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('ULtag from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint32List(1, i);
        system.throwOnError = false;
        final ul1 = new ULtag(PTag.kSelectorULValue, vList0);
        log.debug('ul1:$ul1');
        final bd0 = new Bytes.fromList(vList0);
        log
          ..debug('bd0: $bd0')
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('ul1.vrIndex: ${ul1.vrIndex}');
        final bd1 = makeShortEvr(ul1.code, ul1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(ul1.code, bd1, ul1.vrIndex);
        log.debug('e0:$e0');
        final make0 = ULtag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });
  });

  group('UStag', () {
    test('UStag from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
        system.throwOnError = false;
        final us1 = new UStag(PTag.kContrastFrameAveraging, vList0);
        log.debug('us1:$us1');
        final bd0 = new Bytes.fromTypedData(vList0);
        log
          ..debug('bd0: $bd0')
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('us1.vrIndex: ${us1.vrIndex}');
        final bd1 = makeShortEvr(us1.code, us1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(us1.code, bd1, us1.vrIndex);
        log.debug('e0:$e0');
        final make0 = UStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('UStag from VM.k2', () {
      system.level = Level.debug;
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(2, 2);
        system.throwOnError = false;
        final us1 = new UStag(PTag.kRelativeTime, vList0);
        log.debug('us1:$us1');
        final bd0 = new Bytes.fromTypedData(vList0);
        log
          ..debug('bd0: $bd0')
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('us1.vrIndex: ${us1.vrIndex}');
        final bd1 = makeShortEvr(us1.code, us1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(us1.code, bd1, us1.vrIndex);
        log.debug('e0:$e0');
        final make0 = UStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('UStag from VM.k3', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(3, 3);
        system.throwOnError = false;
        final us1 = new UStag(PTag.kEscapeTriplet, vList0);
        log.debug('us1:$us1');
        final bd0 = new Bytes.fromTypedData(vList0);
        log
          ..debug('bd0: $bd0')
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('us1.vrIndex: ${us1.vrIndex}');
        final bd1 = makeShortEvr(us1.code, us1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(us1.code, bd1, us1.vrIndex);
        log.debug('e0:$e0');
        final make0 = UStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('UStag from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint16List(1, i);
        system.throwOnError = false;
        final us1 = new UStag(PTag.kSelectorUSValue, vList0);
        log.debug('us1:$us1');
        final bd0 = new Bytes.fromList(vList0);
        log
          ..debug('bd0: $bd0')
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('us1.vrIndex: ${us1.vrIndex}');
        final bd1 = makeShortEvr(us1.code, us1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(us1.code, bd1, us1.vrIndex);
        log.debug('e0:$e0');
        final make0 = UStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });
  });
  group('SStag', () {
    system.level = Level.debug;
    test('SStag from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int16List(1, 1);
        system.throwOnError = false;
        final ul1 = new SStag(PTag.kTIDOffset, vList0);
        log.debug('ul1:$ul1');
        final bd0 = new Bytes.fromList(vList0);
        log
          ..debug('bd0: $bd0')
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('ul1.vrIndex: ${ul1.vrIndex}');
        final bd1 = makeShortEvr(ul1.code, ul1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(ul1.code, bd1, ul1.vrIndex);
        log.debug('e0:$e0');
        final make0 = SStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('SStag from VM.k2', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int16List(2, 2);
        system.throwOnError = false;
        final ul1 = new SStag(PTag.kOverlayOrigin, vList0);
        log.debug('ul1:$ul1');
        final bd0 = new Bytes.fromTypedData(vList0);
        log
          ..debug('bd0: $bd0')
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('ul1.vrIndex: ${ul1.vrIndex}');
        final bd1 = makeShortEvr(ul1.code, ul1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(ul1.code, bd1, ul1.vrIndex);
        log.debug('e0:$e0');
        final make0 = SStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });

    test('SStag from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.int16List(1, i);
        system.throwOnError = false;
        final ul1 = new SStag(PTag.kSelectorSSValue, vList0);
        log.debug('ul1:$ul1');
        final bd0 = new Bytes.fromList(vList0);
        log
          ..debug('bd0: $bd0')
          ..debug('bd.lengthInBytes: ${bd0.lengthInBytes}')
          ..debug('ul1.vrIndex: ${ul1.vrIndex}');
        final bd1 = makeShortEvr(ul1.code, ul1.vrIndex, bd0);
        final e0 = EvrElement.makeFromBytes(ul1.code, bd1, ul1.vrIndex);
        log.debug('e0:$e0');
        final make0 = SStag.from(e0);
        log.debug('make0: ${make0.info}');
        expect(make0.hasValidValues, true);
      }
    });
  });
}
