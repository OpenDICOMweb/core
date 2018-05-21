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

// Urgent Jim: add dataset arguments and change tag to evr.
void main() {
  Server.initialize(name: 'bd_element/special_test', level: Level.debug);

  final rds = new ByteRootDataset.empty();
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

        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log..debug('e1: $e1')..debug('vList: $vList')..debug('bd: $bytes');
        expect(e1.hasValidValues, true);
        expect(e1 == e0, true);
        expect(e1.vBytes == bytes, true);


        final e2 = AEbytes.fromValues(kReceivingAE, vList);
        log.debug('e2: $e2');
        expect(e2.hasValidValues, true);
        expect(e2.vBytes == bytes, true);
        expect(e2 == e1, true);

        final e3 = AEbytes.fromValues(kReceivingAE, vList);
        log.debug('e3:$e3');
        expect(e3.hasValidValues, true);
        expect(e3.vBytes == bytes, true);
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
        expect(e0.hasValidValues, true);
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('ae1:$e1');
        expect(e1.hasValidValues, true);
        expect(e0 == e1, true);
      }
    });
  });

  group('DSbytes', () {
    global.throwOnError = false;

    test('DSbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        var vList = rsg.getDSList(1, 1);
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
         vList = [vList[0].trim()];
        print('DS list: $vList');
        final e0 = DSbytes.fromValues(kRequestedImageSize, vList);
        log.debug('ds0:$e0');
        expect(e0.hasValidValues, true);

        log.debug('e0:$e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e1.hasValidValues, true);
      }
    });

    test('DSbytes from VM.k2', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(2, 2);
        global.throwOnError = false;
        for (var n in vList0) print('n: "$n"');
        final e0 = DSbytes.fromValues(kRTImagePosition, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e1.hasValidValues, true);
      }
    });

    test('DSbytes from VM.k3', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(3, 3);
        global.throwOnError = false;
        final e0 = DSbytes.fromValues(kNormalizationPoint, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e1.hasValidValues, true);
      }
    });

    test('DSbytes from VM.k4', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(4, 4);
        global.throwOnError = false;
        final e0 = DSbytes.fromValues(kDiaphragmPosition, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('DSbytes from VM.k6', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(6, 6);
        global.throwOnError = false;
        final e0 = DSbytes.fromValues(kImageOrientation, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('DSbytes from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getDSList(1, i);
        global.throwOnError = false;
        final e0 = DSbytes.fromValues(kSelectorDSValue, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('DSbytes from VM.k1_2', () {
      for (var i = 0; i < 10; i++) {
        final vList = rsg.getDSList(1, 2);
        global.throwOnError = false;
        final e0 = DSbytes.fromValues(kDetectorActiveDimensions, vList);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('DSbytes from VM.k2_2n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDSList(10, 10);
        global.throwOnError = false;
        final e0 = DSbytes.fromValues(kDVHData, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('DSbytes from VM.k3_3n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getDSList(9, 9);
        global.throwOnError = false;
        final e0 = DSbytes.fromValues(kContourData, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });

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
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
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
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));

        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
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

  group('ASbytes', () {
    test('ASbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, 1);
        global.throwOnError = false;
        final e0 = ASbytes.fromValues(kPatientAge, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));

        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('ASbytes from VM.k1_n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getASList(1, i);
        global.throwOnError = false;
        final e0 = ASbytes.fromValues(kSelectorASValue, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));

        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });

  group('CSbytes', () {
    test('CSTag from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        global.throwOnError = false;
        final e0 = CSbytes.fromValues(kLaterality, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));

        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('CSTag from VM.k2', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(2, 2);
        global.throwOnError = false;
        final e0 = CSbytes.fromValues(kPatientOrientation, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));

        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('CSTag from VM.k2_n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(2, 2);
        global.throwOnError = false;
        final e0 = CSbytes.fromValues(kImageType, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
    test('CSTag from VM.k4', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(4, 4);
        global.throwOnError = false;
        final e0 = CSbytes.fromValues(kFrameType, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('CSTag from VM.k1_n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, i);
        global.throwOnError = false;
        final e0 = CSbytes.fromValues(kSelectorCSValue, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });

  group('DTbytes', () {
    test('DTbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDTList(1, 1);
        global.throwOnError = false;
        final e0 = DTbytes.fromValues(kDateTime, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('DTbytes from VM.k1_n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getDTList(1, i);
        global.throwOnError = false;
        final e0 = DTbytes.fromValues(kSelectorDTValue, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });

  group('TMbytes', () {
    test('TMbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, 1);
        global.throwOnError = false;
        final e0 = TMbytes.fromValues(kTime, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('TMbytes from VM.k1_n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getTMList(1, i);
        global.throwOnError = false;
        final e0 = TMbytes.fromValues(kSelectorTMValue, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });

  group('LObytes', () {
    test('LObytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, 1);
        global.throwOnError = false;
        final e0 = LObytes.fromValues(kManufacturer, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('LObytes from VM.k1_n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLOList(1, i);
        global.throwOnError = false;
        final e0 = LObytes.fromValues(kSelectorLOValue, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });

  group('PNbytes', () {
    test('PNbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, 1);
        global.throwOnError = false;
        final e0 = PNbytes.fromValues(kEvaluatorName, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('PNbytes from VM.k1_n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getPNList(1, i);
        global.throwOnError = false;
        final e0 = PNbytes.fromValues(kSelectorPNValue, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });

  group('SHbytes', () {
    test('SHbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, 1);
        global.throwOnError = false;
        final e0 = SHbytes.fromValues(kCodeValue, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('SHbytes from VM.k1_n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSHList(1, i);
        global.throwOnError = false;
        final e0 = SHbytes.fromValues(kSelectorSHValue, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });

  group('LTbytes', () {
    test('LTbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getLTList(1, 1);
        global.throwOnError = false;
        final e0 = LTbytes.fromValues(kPatientComments, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });

  group('STbytes', () {
    test('STbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getSTList(1, 1);
        global.throwOnError = false;
        final e0 = STbytes.fromValues(kSelectorSTValue, vList0);
        log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });

  group('FDevr', () {
    test('FDbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float64List(1, 1);
        global.throwOnError = false;
        final e0 =
            FDbytes.fromValues(kOverallTemplateSpatialTolerance, floatList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('FDbytes from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final floatList0 = rng.float64List(1, i);
        global.throwOnError = false;
        final e0 = FDbytes.fromValues(kSelectorFDValue, floatList0);
/*
        final s = fd1.toString();
        log.debug('e0: $e0');
//        final bd0 = new Bytes.typedDataView(floatList0);

        final e0 = Lobytes.fromValuesngEvr(fd1.code, fd1.vrIndex, bd0);
        final e1= ByteElement.makeFromCode(rds, fd1.code, bd1);
        log.debug('e0:$e0');
*/
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });

  group('OFbytes', () {
    test('OFbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float32List(1, 1);
        //final float32List0 = new Float32List.fromList(floatList0);
        //final bytes = float32List0.buffer.asByteData();
        global.throwOnError = false;
        final e0 = OFbytes.fromValues(kFloatPixelData, floatList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('OFbytes from VM.k1_n', () {
      for (var i = 0; i < 10; i++) {
        final floatList0 = rng.float32List(1, 1);
        global.throwOnError = false;
        final e0 = OFbytes.fromValues(kSelectorOFValue, floatList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });

  group('UTbytes', () {
    test('UTbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getUTList(1, 1);
        global.throwOnError = false;
        final e0 = UTbytes.fromValues(kSelectorUTValue, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });

  group('ATbytes', () {
    global.level = Level.debug;
    test('ATbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        global.throwOnError = false;
        final e0 = ATbytes.fromValues(kDimensionIndexPointer, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('ATbytes from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint32List(1, i);
        global.throwOnError = false;
        final e0 = ATbytes.fromValues(kSelectorATValue, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });

  group('ULbytes', () {
    global.level = Level.debug;
    test('ULbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(1, 1);
        global.throwOnError = false;
        final e0 = ULbytes.fromValues(kRegionFlags, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('ULbytes from VM.k3', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint32List(3, 3);
        global.throwOnError = false;
        final e0 = ULbytes.fromValues(kGridDimensions, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('ULbytes from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint32List(1, i);
        global.throwOnError = false;
        final e0 = ULbytes.fromValues(kSelectorULValue, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });

  group('USbytes', () {
    test('USbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
        global.throwOnError = false;
        final e0 = USbytes.fromValues(kContrastFrameAveraging, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('USbytes from VM.k2', () {
      global.level = Level.debug;
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(2, 2);
        global.throwOnError = false;
        final e0 = USbytes.fromValues(kRelativeTime, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('USbytes from VM.k3', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(3, 3);
        global.throwOnError = false;
        final e0 = USbytes.fromValues(kEscapeTriplet, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('USbytes from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint16List(1, i);
        global.throwOnError = false;
        final e0 = USbytes.fromValues(kSelectorUSValue, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });

  group('SSbytes', () {
    global.level = Level.debug;
    test('SSbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int16List(1, 1);
        global.throwOnError = false;
        final e0 = SSbytes.fromValues(kTIDOffset, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('SSbytes from VM.k2', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.int16List(2, 2);
        global.throwOnError = false;
        final e0 = SSbytes.fromValues(kOverlayOrigin, vList0);
        log.debug('e0: $e0');
        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });

    test('SSbytes from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.int16List(1, i);
        global.throwOnError = false;
        final e0 = SSbytes.fromValues(kSelectorSSValue, vList0);
        log.debug('e0: $e0');

        final e1 = ByteElement.makeFromBytes(e0.bytes, rds);
        log.debug('e1: $e1');
        expect(e0.hasValidValues, true);
      }
    });
  });
}
