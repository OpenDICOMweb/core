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

void main() {
  Server.initialize(name: 'element/frame_descriptor_test', level: Level.info);

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

      final desc0 = FrameDescriptor(
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
      expect(
          desc0.photometricInterpretation == photometricInterpretation0, true);
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
      const ts = TransferSyntax.kExplicitVRLittleEndian;
      final uiTransFerSyntax =
          UItag(PTag.kTransferSyntaxUID, [ts.asString]);
      final usSamplesPerPixel = UStag(PTag.kSamplesPerPixel, [1]);
      final csPhotometricInterpretation =
          CStag(PTag.kPhotometricInterpretation, ['GHWNR8WH_4A']);
      final usRows = UStag(PTag.kRows, [4]);
      final usColumns = UStag(PTag.kColumns, [6]);
      final usBitsAllocated = UStag(PTag.kBitsAllocated, [8]);
      final usBitsStored = UStag(PTag.kBitsStored, [8]);
      final usHighBit = UStag(PTag.kHighBit, [7]);
      final usPixelRepresentation = UStag(PTag.kPixelRepresentation, [0]);
      final usPlanarConfiguration = UStag(PTag.kPlanarConfiguration, [2]);
      final isPixelAspectRatio = IStag(PTag.kPixelAspectRatio, ['1', '2']);
      const pixelAspectRatioValue = 1 / 2;
      final usSmallestImagePixelValue =
          UStag(PTag.kSmallestImagePixelValue, [0]);
      final usLargestImagePixelValue =
          UStag(PTag.kLargestImagePixelValue, [255]);

      final rds0 = TagRootDataset.empty()
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

      final descFromDataSet0 = FrameDescriptor.fromDataset(rds0);

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
      expect(descFromDataSet0.pixelRepresentation,
          equals(usPixelRepresentation.value));
      expect(descFromDataSet0.planarConfiguration,
          equals(usPlanarConfiguration.value));
      expect(descFromDataSet0.pixelAspectRatio, equals(pixelAspectRatioValue));
      expect(descFromDataSet0.smallestImagePixelValue == 0, true);
      //here us4.values is bitsStored which is 8
      expect(descFromDataSet0.largestImagePixelValue <= 255, true);
      expect(
          (descFromDataSet0.largestImagePixelValue >> usBitsStored.value) == 0,
          true);
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

    global.throwOnError = true;
    expect(
        () => FrameDescriptor(
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
        throwsA(const TypeMatcher<InvalidFrameDescriptorError>()));
  });
}
