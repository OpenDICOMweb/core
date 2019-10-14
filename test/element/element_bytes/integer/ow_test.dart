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
  Server.initialize(name: 'element_bytes/ow_test', level: Level.info);

  final rds = ByteRootDataset.empty();
  const type = BytesElementType.leLongEvr;

  group('OWbytes', () {
    const owVM1Tags = <int>[
      kRedPaletteColorLookupTableData,
      kGreenPaletteColorLookupTableData,
      kBluePaletteColorLookupTableData,
      kAlphaPaletteColorLookupTableData,
      kLargeRedPaletteColorLookupTableData,
      kLargeGreenPaletteColorLookupTableData,
      kLargeBluePaletteColorLookupTableData,
      kSegmentedRedPaletteColorLookupTableData,
      kSegmentedGreenPaletteColorLookupTableData,
      kSegmentedBluePaletteColorLookupTableData,
      kBlendingLookupTableData,
      kTrianglePointIndexList,
      kEdgePointIndexList,
      kVertexPointIndexList,
      kPrimitivePointIndexList,
      kRecommendedDisplayCIELabValueList,
      kCoefficientsSDVN,
      kCoefficientsSDHN,
      kCoefficientsSDDN,
      kVariableCoefficientsSDVN,
      kVariableCoefficientsSDHN,
      kVariableCoefficientsSDDN
    ];

    const owVM1nTags = <int>[kSelectorOWValue];

    test('OWbytes from VM.k1', () {
      for (var i = 0; i < 10; i++) {
        final vList0 = rng.uint16List(1, 1);
        global.throwOnError = false;
        for (final code in owVM1Tags) {
          final e0 = OWbytes.fromValues(code, vList0, type);
          log.debug('e0: $e0');
          final e1 = ElementBytes.fromBytes(e0.be, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);

          expect(e1.hasValidValues, true);
          expect(e1, equals(e0));
          expect(e1.vfBytes == e0.vfBytes, true);

          expect(e0.code == e0.be.code, true);
          expect(e0.length == e0.be.length, true);
          expect(e0.vrCode == e0.be.vrCode, true);
          expect(e0.vrIndex == e0.be.vrIndex, true);
          expect(e0.vfLengthOffset == e0.be.vfLengthOffset, true);
          expect(e0.vfLengthField == e0.be.vfLengthField, true);
          expect(e0.vfLength == e0.be.vfLength, true);
          expect(e0.vfOffset == e0.be.vfOffset, true);
          expect(e0.vfBytes == e0.be.vfBytes, true);
          expect(e0.vfBytesLast == e0.be.vfBytesLast, true);
        }
      }
    });

    test('OWbytes from VM.k1_n', () {
      for (var i = 1; i < 10; i++) {
        final vList0 = rng.uint16List(1, i);
        global.throwOnError = false;
        for (final code in owVM1nTags) {
          final e0 = OWbytes.fromValues(code, vList0, type);
          log.debug('e0: $e0');
          final e1 = ElementBytes.fromBytes(e0.be, rds, isEvr: true);
          log.debug('e1: $e1');
          expect(e0.hasValidValues, true);

          expect(e1.hasValidValues, true);
          expect(e1, equals(e0));
          expect(e1.vfBytes == e0.vfBytes, true);

          expect(e0.code == e0.be.code, true);
          expect(e0.length == e0.be.length, true);
          expect(e0.vrCode == e0.be.vrCode, true);
          expect(e0.vrIndex == e0.be.vrIndex, true);
          expect(e0.vfLengthOffset == e0.be.vfLengthOffset, true);
          expect(e0.vfLengthField == e0.be.vfLengthField, true);
          expect(e0.vfLength == e0.be.vfLength, true);
          expect(e0.vfOffset == e0.be.vfOffset, true);
          expect(e0.vfBytes == e0.be.vfBytes, true);
          expect(e0.vfBytesLast == e0.be.vfBytesLast, true);
        }
      }
    });
  });
}