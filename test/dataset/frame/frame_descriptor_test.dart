// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:tag/tag.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'element/frame_descriptor_test', level: Level.info0);

  group('FrameDescriptor Tests', () {
    test('Create 8-bit FrameDescriptor', () {
      const ts0 = TransferSyntax.kExplicitVRLittleEndian;
      const samplesPerPixel0 = 1;
      const photometricInterpretation0 = 'GHWNR8WH_4A';
      const rows0 = 4;
      const columns0 = 6;
      const bitsAllocated0 = 8;
      const bitsStored0 = 8;
      const highBit0 = 7;
      const pixelRepresentation0 = 0;
      const int planarConfiguration0 = null;
      const pixelAspectRatio0 = 1.0;
      const frameLength0 = rows0 * columns0;

      final desc0 = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation0,
          rows0,
          columns0,
          bitsAllocated0,
          bitsStored0,
          highBit0,
          pixelRepresentation0,
          planarConfiguration0);

      expect(desc0.samplesPerPixel == samplesPerPixel0, true);
      expect(desc0.photometricInterpretation == photometricInterpretation0, true);
      expect(desc0.rows == rows0, true);
      expect(desc0.columns == columns0, true);
      expect(desc0.length == rows0 * columns0, true);
      expect(desc0.bitsAllocated == bitsAllocated0, true);
      expect(desc0.bitsStored == bitsStored0, true);
      expect(desc0.highBit == highBit0, true);
      expect(desc0.pixelRepresentation == pixelRepresentation0, true);
      expect(desc0.planarConfiguration == planarConfiguration0, true);
      expect(desc0.pixelAspectRatio == pixelAspectRatio0, true);
      expect(desc0.ts == ts0, true);
      expect(desc0.lengthInBits == frameLength0 * bitsAllocated0, true);
      expect(desc0.pixelSizeInBits == bitsAllocated0, true);
    });

    test('Create FrameDescriptor.fromDataset', () {
      final ts = TransferSyntax.kExplicitVRLittleEndian;
      final uiTransFerSyntax = new UItag(PTag.kTransferSyntaxUID, [ts.asString]);
      final usSamplesPerPixel = new UStag(PTag.kSamplesPerPixel, [1]);
      final csPhotometricInterpretation =
          new CStag(PTag.kPhotometricInterpretation, ['GHWNR8WH_4A']);
      final usRows = new UStag(PTag.kRows, [4]);
      final usColumns = new UStag(PTag.kColumns, [6]);
      final usBitsAllocated = new UStag(PTag.kBitsAllocated, [8]);
      final usBitsStored = new UStag(PTag.kBitsStored, [8]);
      final usHighBit = new UStag(PTag.kHighBit, [7]);
      final usPixelRepresentation = new UStag(PTag.kPixelRepresentation, [0]);
      final usPlanarConfiguration = new UStag(PTag.kPlanarConfiguration, [2]);
      final isPixelAspectRatio = new IStag(PTag.kPixelAspectRatio, ['1', '2']);
      final pixelAspectRatioValue = 1 / 2;
      final usSmallestImagePixelValue = new UStag(PTag.kSmallestImagePixelValue, [0]);
      final usLargestImagePixelValue = new UStag(PTag.kLargestImagePixelValue, [255]);

      final rds0 = new TagRootDataset()
        ..add(uiTransFerSyntax)
        ..add(usSamplesPerPixel)
        ..add(csPhotometricInterpretation)
        ..add(usRows)
        ..add(usColumns)
        ..add(usBitsAllocated)
        ..add(usBitsStored)
        ..add(usHighBit)
        ..add(usPixelRepresentation)
        ..add(usPlanarConfiguration)
        ..add(isPixelAspectRatio)
        ..add(usSmallestImagePixelValue)
        ..add(usLargestImagePixelValue);

      final descFromDataSet0 = new FrameDescriptor.fromDataset(rds0);

      log.debug('pixelAspectRatio: ${descFromDataSet0.pixelAspectRatio}');

      expect(descFromDataSet0.ts == ts, true);
      expect(descFromDataSet0.samplesPerPixel, equals(usSamplesPerPixel.value));
      expect(descFromDataSet0.photometricInterpretation,
          equals(csPhotometricInterpretation.value));
      expect(descFromDataSet0.rows, equals(usRows.value));
      expect(descFromDataSet0.columns, equals(usColumns.value));
      expect(descFromDataSet0.bitsAllocated, equals(usBitsAllocated.value));
      expect(descFromDataSet0.bitsStored, equals(usBitsStored.value));
      expect(descFromDataSet0.highBit, equals(usHighBit.value));
      expect(descFromDataSet0.pixelRepresentation, equals(usPixelRepresentation.value));
      expect(descFromDataSet0.planarConfiguration, equals(usPlanarConfiguration.value));
      expect(descFromDataSet0.pixelAspectRatio, equals(pixelAspectRatioValue));
      expect(descFromDataSet0.smallestImagePixelValue == 0, true);
      //here us4.value is bitsStored which is 8
      expect(descFromDataSet0.largestImagePixelValue <= 255, true);
      expect((descFromDataSet0.largestImagePixelValue >> usBitsStored.value) == 0, true);
    });
  });

  test('Invalid FrameDescriptor test', () {
    // const nFrames0 = 1;
    const ts0 = TransferSyntax.kExplicitVRLittleEndian;
    const samplesPerPixel0 = 1;
    const photometricInterpretation0 = 'MONOCHROME3';

    const rows4 = 4;
    const columns6 = 6;
    const pixelRepresentation0 = 0;
    const int planarConfiguration0 = null;
    const pixelAspectRatio0 = 1.0;

    const bitsAllocated0 = 0;
    const bitsStored0 = 0;
    const highBit0 = 0;

    system.throwOnError = true;
    expect(
        () => new FrameDescriptor(
            ts0,
            samplesPerPixel0,
            photometricInterpretation0,
            rows4,
            columns6,
            bitsAllocated0,
            bitsStored0,
            highBit0,
            pixelRepresentation0,
            planarConfiguration0,
            pixelAspectRatio: pixelAspectRatio0),
        throwsA(const isInstanceOf<InvalidFrameDescriptorError>()));
  });
}
