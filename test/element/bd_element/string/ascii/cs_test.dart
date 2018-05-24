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

  group('CSbytes', () {
    //VM.k1
    const csVM1Tags = const <int>[
      kFileSetID,
      kConversionType,
      kPresentationIntentType,
      kMappingResource,
      kFieldOfViewShape,
      kRadiationSetting,
    ];

    //VM.k2
    const csVM2Tags = const <int>[
      kPatientOrientation,
      kReportStatusIDTrial,
      kSeriesType,
      kDisplaySetPatientOrientation
    ];

    //VM.k2_n
    const csVM2_nTags = const <int>[kImageType];

    //VM.k4
    const csVM4Tags = const <int>[
      kFrameType,
    ];

    //VM.k1_n
    const csVM1_nTags = const <int>[
      kModalitiesInStudy,
      kIndicationType,
      kScanningSequence,
      kSequenceVariant,
      kScanOptions,
      kGrid,
      kFilterMaterial,
      kSelectorCSValue,
    ];
    test('CSbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, 1);
        global.throwOnError = false;
        for (var code in csVM1Tags) {
          final e0 = CSbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('CSbytes from VM.k2', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(2, 2);
        global.throwOnError = false;
        for (var code in csVM2Tags) {
          final e0 = CSbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('CSbytes from VM.k2_n', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(2, 2);
        global.throwOnError = false;
        for (var code in csVM2_nTags) {
          final e0 = CSbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });
    test('CSbytes from VM.k4', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(4, 4);
        for (var code in csVM4Tags) {
          final e0 = CSbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });

    test('CSbytes from VM.k1_n', () {
      global.throwOnError = false;
      for (var i = 0; i < 10; i++) {
        final vList0 = rsg.getCSList(1, i);
        for (var code in csVM1_nTags) {
          final e0 = CSbytes.fromValues(code, vList0);
          log.debug('e0: $e0');
          final e1 = ByteElement.makeFromDicomBytes(e0.bytes, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);
        }
      }
    });
  });
}
