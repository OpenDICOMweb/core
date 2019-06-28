//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:bytes_dicom/bytes_dicom.dart';
import 'package:core/server.dart' hide group;
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

RSG rsg = RSG(seed: 1);
RNG rng = RNG(1);

void main() {
  Server.initialize(name: 'bd_element/special_test', level: Level.info);
  const type = BytesElementType.leShortEvr;
  final rds = ByteRootDataset.empty();

  group('ISbytes', () {
    //VM.k1
    const isVM1Tags = <int>[
      kStageNumber,
      kNumberOfStages,
      kViewNumber,
      kNumberOfViewsInStage,
      kStartTrim,
      kStopTrim,
      kEvaluatorNumber,
      kNumberOfContourPoints,
      kObservationNumber,
      kCurrentFractionNumber,
    ];

    //VM.k2
    const isVM2Tags = <int>[
      kCenterOfCircularShutter,
      kCenterOfCircularCollimator,
      kGridAspectRatio,
      kPixelAspectRatio,
      kAxialMash,
      kPresentationPixelAspectRatio,
    ];

    //VM.k2_2n
    const isVM22nTags = <int>[
      kVerticesOfThePolygonalShutter,
      kVerticesOfThePolygonalCollimator,
      kVerticesOfTheOutlineOfPupil,
    ];

    //VM.k3
    const isVM3Tags = <int>[
      kROIDisplayColor,
    ];

    //VM.k1_n
    const isVM1nTags = <int>[
      kReferencedFrameNumber,
      kTransformOrderOfAxes,
      kEchoNumbers,
      kUpperLowerPixelValues,
      kSelectorISValue,
      kSelectorSequencePointerItems,
    ];

    test('ISbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(1, 1);
        global.throwOnError = false;
        for (final code in isVM1Tags) {
          final e0 = ISbytes.fromValues(code, vList0, type);
          log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
          final e1 = ElementBytes.fromBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);

          expect(e1.hasValidValues, true);
          expect(e1 == e0, true);
          expect(e1.vfBytes == e0.vfBytes, true);

          expect(e0.code == e0.bytes.code, true);
          expect(e0.eLength == e0.bytes.length, true);
          expect(e0.vrCode == e0.bytes.vrCode, true);
          expect(e0.vrIndex == e0.bytes.vrIndex, true);
          expect(e0.vfLengthOffset == e0.bytes.vfLengthOffset, true);
          expect(e0.vfLengthField == e0.bytes.vfLengthField, true);
          expect(e0.vfLength == e0.bytes.vfLength, true);
          expect(e0.vfOffset == e0.bytes.vfOffset, true);
          expect(e0.vfBytes == e0.bytes.vfBytes, true);
          expect(e0.vfBytesLast == e0.bytes.vfBytesLast, true);
        }
      }
    });

    test('ISbytes from VM.k2', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(2, 2);
        global.throwOnError = false;
        for (final code in isVM2Tags) {
          final e0 = ISbytes.fromValues(code, vList0, type);
          log.debug('e0: $e0');
          final e1 = ElementBytes.fromBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);

          expect(e1.hasValidValues, true);
          expect(e1 == e0, true);
          expect(e1.vfBytes == e0.vfBytes, true);

          expect(e0.code == e0.bytes.code, true);
          expect(e0.eLength == e0.bytes.length, true);
          expect(e0.vrCode == e0.bytes.vrCode, true);
          expect(e0.vrIndex == e0.bytes.vrIndex, true);
          expect(e0.vfLengthOffset == e0.bytes.vfLengthOffset, true);
          expect(e0.vfLengthField == e0.bytes.vfLengthField, true);
          expect(e0.vfLength == e0.bytes.vfLength, true);
          expect(e0.vfOffset == e0.bytes.vfOffset, true);
          expect(e0.vfBytes == e0.bytes.vfBytes, true);
          expect(e0.vfBytesLast == e0.bytes.vfBytesLast, true);
        }
      }
    });

    test('ISbytes from VM.k3', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(3, 3);
        global.throwOnError = false;
        for (final code in isVM3Tags) {
          final e0 = ISbytes.fromValues(code, vList0, type);
          log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));

          final e1 = ElementBytes.fromBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);

          expect(e1.hasValidValues, true);
          expect(e1 == e0, true);
          expect(e1.vfBytes == e0.vfBytes, true);

          expect(e0.code == e0.bytes.code, true);
          expect(e0.eLength == e0.bytes.length, true);
          expect(e0.vrCode == e0.bytes.vrCode, true);
          expect(e0.vrIndex == e0.bytes.vrIndex, true);
          expect(e0.vfLengthOffset == e0.bytes.vfLengthOffset, true);
          expect(e0.vfLengthField == e0.bytes.vfLengthField, true);
          expect(e0.vfLength == e0.bytes.vfLength, true);
          expect(e0.vfOffset == e0.bytes.vfOffset, true);
          expect(e0.vfBytes == e0.bytes.vfBytes, true);
          expect(e0.vfBytesLast == e0.bytes.vfBytesLast, true);
        }
      }
    });

    test('ISbytes from VM.k2_2n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(10, 10);
        global.throwOnError = false;
        for (final code in isVM22nTags) {
          final e0 = ISbytes.fromValues(code, vList0, type);
          expect(e0.hasValidValues, true);

          final e1 = ElementBytes.fromBytes(e0.bytes, rds, isEvr: true);
          expect(e1.hasValidValues, true);

          expect(e1.hasValidValues, true);
          expect(e1 == e0, true);
          expect(e1.vfBytes == e0.vfBytes, true);

          expect(e0.code == e0.bytes.code, true);
          expect(e0.eLength == e0.bytes.length, true);
          expect(e0.vrCode == e0.bytes.vrCode, true);
          expect(e0.vrIndex == e0.bytes.vrIndex, true);
          expect(e0.vfLengthOffset == e0.bytes.vfLengthOffset, true);
          expect(e0.vfLengthField == e0.bytes.vfLengthField, true);
          expect(e0.vfLength == e0.bytes.vfLength, true);
          expect(e0.vfOffset == e0.bytes.vfOffset, true);
          expect(e0.vfBytes == e0.bytes.vfBytes, true);
          expect(e0.vfBytesLast == e0.bytes.vfBytesLast, true);
        }
      }
    });

    test('ISbytes from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getISList(1, i);
        global.throwOnError = false;
        for (final code in isVM1nTags) {
          final e0 = ISbytes.fromValues(code, vList0, type);
          log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));

          final e1 = ElementBytes.fromBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);

          expect(e1.hasValidValues, true);
          expect(e1 == e0, true);
          expect(e1.vfBytes == e0.vfBytes, true);

          expect(e0.code == e0.bytes.code, true);
          expect(e0.eLength == e0.bytes.length, true);
          expect(e0.vrCode == e0.bytes.vrCode, true);
          expect(e0.vrIndex == e0.bytes.vrIndex, true);
          expect(e0.vfLengthOffset == e0.bytes.vfLengthOffset, true);
          expect(e0.vfLengthField == e0.bytes.vfLengthField, true);
          expect(e0.vfLength == e0.bytes.vfLength, true);
          expect(e0.vfOffset == e0.bytes.vfOffset, true);
          expect(e0.vfBytes == e0.bytes.vfBytes, true);
          expect(e0.vfBytesLast == e0.bytes.vfBytesLast, true);
        }
      }
    });
  });
}
