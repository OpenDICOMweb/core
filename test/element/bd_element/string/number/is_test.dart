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

RSG rsg = new RSG(seed: 1);
RNG rng = new RNG(1);

void main() {
  Server.initialize(name: 'bd_element/special_test', level: Level.info);

  final rds = new ByteRootDataset.empty();

  group('ISbytes', () {
    //VM.k1
    const isVM1Tags = const <int>[
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
    const isVM2Tags = const <int>[
      kCenterOfCircularShutter,
      kCenterOfCircularCollimator,
      kGridAspectRatio,
      kPixelAspectRatio,
      kAxialMash,
      kPresentationPixelAspectRatio,
    ];

    //VM.k2_2n
    const isVM2_2nTags = const <int>[
      kVerticesOfThePolygonalShutter,
      kVerticesOfThePolygonalCollimator,
      kVerticesOfTheOutlineOfPupil,
    ];

    //VM.k3
    const isVM3Tags = const <int>[
      kROIDisplayColor,
    ];

    //VM.k1_n
    const isVM1_nTags = const <int>[
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
        for (var code in isVM1Tags) {
          final e0 = ISbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));
          final e1 = ByteElement.makeFromBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('ISbytes from VM.k2', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(2, 2);
        global.throwOnError = false;
        for (var code in isVM2Tags) {
          final e0 = ISbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('ISbytes from VM.k3', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(3, 3);
        global.throwOnError = false;
        for (var code in isVM3Tags) {
          final e0 = ISbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));

          final e1 = ByteElement.makeFromBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('ISbytes from VM.k2_2n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getISList(10, 10);
        global.throwOnError = false;
        for (var code in isVM2_2nTags) {
          final e0 = ISbytes.fromValues(code, vList0);
          expect(e0.hasValidValues, true);

          final e1 = ByteElement.makeFromBytes(e0.bytes, rds, isEvr: true);
          expect(e1.hasValidValues, true);
        }
      }
    });

    test('ISbytes from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rsg.getISList(1, i);
        global.throwOnError = false;
        for (var code in isVM1_nTags) {
          final e0 = ISbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
//        final bd0 = Bytes.fromAscii(vList0.join('\\'));

          final e1 = ByteElement.makeFromBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });
  });
}
