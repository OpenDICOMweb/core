//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

import 'test_pixel_data.dart';

final Uint8List frame = new Uint8List.fromList(testFrame);

void main() {
  Server.initialize(name: 'element/ol_frame_list_test', level: Level.info);

  /// OLevr Frame List Tests
  group('FrameList 32Bit', () {
    const ts0 = TransferSyntax.kExplicitVRLittleEndian;
    const samplesPerPixel0 = 1;
    const rows4 = 4;
    const columns6 = 6;
    const bitsAllocated32 = 32;
    const bitsStored32 = 32;
    const highBit32 = 31;
    const pixelRepresentation0 = 0;
    const int planarConfiguration0 = null;
    const pixelAspectRatio0 = 1.0;

    test('Create FrameList32Bit Single Frame Uncompressed Tests', () {
      // Single Frame
      const nFrames0 = 1;
      const photometricInterpretation0 = 'RGB';

      // Descriptor
      final ol32FDa = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation0,
          rows4,
          columns6,
          bitsAllocated32,
          bitsStored32,
          highBit32,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final pixels0 = new Uint32List(ol32FDa.length * nFrames0);

      final ol32FLa = new FrameList32Bit(pixels0, nFrames0, ol32FDa);

      // pixels
      expect(ol32FLa.pixels is Uint32List, true);
      expect(ol32FLa.pixels.length == pixels0.length, true);
      expect(ol32FLa.pixels == pixels0, true);
      expect(ol32FLa.pixels.lengthInBytes == pixels0.lengthInBytes, true);
      expect(ol32FLa.pixelSizeInBits == ol32FDa.pixelSizeInBits, true);

      // bulkdata
      expect(ol32FLa.bulkdata.length == pixels0.lengthInBytes, true);
      expect(ol32FLa.bulkdata.length == ol32FLa.bulkdata.lengthInBytes, true);
      expect(ol32FLa.pixels.lengthInBytes == ol32FLa.bulkdata.length, true);

      // nFrames
      expect(ol32FLa.length == nFrames0, true); //nFrames0=1
      expect(ol32FLa.nFrames == nFrames0, true); //nFrames0=1;

      // frameLength
      expect(ol32FLa.frameLength == rows4 * columns6, true);
      expect(ol32FLa.lengthInBytes == pixels0.lengthInBytes, true);
      expect(ol32FLa.lengthInBytes == ol32FLa.pixels.lengthInBytes, true);
      expect(ol32FLa.lengthInBytes == ol32FLa.bulkdata.lengthInBytes, true);
      expect(ol32FLa.lengthInBytes == ol32FDa.lengthInBytes * nFrames0, true);

      // validity
      expect(ol32FLa.isValid, true);

      // FrameDescriptor values
      // transferSyntax
      expect(ol32FLa.ts == ts0, true);
      expect(ol32FLa.isCompressed, false);
      expect(ol32FLa.isEncapsulated, false);

      // FrameDescriptor fields
      expect(ol32FLa.samplesPerPixel == samplesPerPixel0, true);
      expect(ol32FLa.photometricInterpretation == photometricInterpretation0,
          true);
      expect(ol32FLa.rows == rows4, true);
      expect(ol32FLa.columns == columns6, true);
      expect(ol32FLa.bitsAllocated == bitsAllocated32, true);
      expect(ol32FLa.bitsStored == bitsStored32, true);
      expect(ol32FLa.highBit == highBit32, true);
      expect(ol32FLa.pixelRepresentation == pixelRepresentation0, true);
      expect(ol32FLa.planarConfiguration, isNull);
      expect(ol32FLa.pixelAspectRatio == pixelAspectRatio0, true);

      // FrameDescriptor
      expect(ol32FDa.ts == ts0, true);
      expect(ol32FDa.samplesPerPixel == samplesPerPixel0, true);
      expect(ol32FDa.photometricInterpretation == photometricInterpretation0,
          true);
      expect(ol32FDa.rows == rows4, true);
      expect(ol32FDa.columns == columns6, true);
      expect(ol32FDa.length == rows4 * columns6, true);
      expect(ol32FDa.bitsAllocated == bitsAllocated32, true);
      expect(ol32FDa.bitsStored == bitsStored32, true);
      expect(ol32FDa.highBit == highBit32, true);
      expect(ol32FDa.pixelRepresentation == pixelRepresentation0, true);
      expect(ol32FDa.planarConfiguration == planarConfiguration0, true);
      expect(ol32FDa.pixelAspectRatio == pixelAspectRatio0, true);
      expect(
          ol32FDa.lengthInBits == (rows4 * columns6) * bitsAllocated32, true);
      expect(ol32FDa.pixelSizeInBits == bitsAllocated32, true);
      expect(ol32FDa.length == rows4 * columns6, true);
      expect(ol32FDa.lengthInBytes == pixels0.lengthInBytes, true);
    });

    test('Create FrameList32Bit MultiFrame Uncompressed Tests', () {
      int nFrames1;
      const photometricInterpretation1 = 'RGB';

      // Descriptor
      final ol32FDb = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation1,
          rows4,
          columns6,
          bitsAllocated32,
          bitsStored32,
          highBit32,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      // Multi Frame
      // Frame values are 2, 4, 6 ...
      for (var i = 1; i <= 10; i++) {
        nFrames1 = i * 2;
        final pixels0 = new Uint32List(ol32FDb.length * nFrames1);

        final ol32FLb = new FrameList32Bit(pixels0, nFrames1, ol32FDb);

        // pixels
        expect(ol32FLb.pixels is Uint32List, true);
        expect(ol32FLb.pixels.length == pixels0.length, true);
        expect(ol32FLb.pixels == pixels0, true);
        expect(ol32FLb.pixels.lengthInBytes == pixels0.lengthInBytes, true);
        expect(ol32FLb.pixelSizeInBits == ol32FDb.pixelSizeInBits, true);

        // bulkdata
        expect(ol32FLb.bulkdata.length == pixels0.lengthInBytes, true);
        expect(ol32FLb.bulkdata.length == ol32FLb.bulkdata.lengthInBytes, true);
        expect(ol32FLb.pixels.lengthInBytes == ol32FLb.bulkdata.length, true);

        // nFrames
        expect(ol32FLb.length == nFrames1, true);
        expect(ol32FLb.nFrames == nFrames1, true);

        // frameLength
        expect(ol32FLb.frameLength == rows4 * columns6, true);
        expect(ol32FLb.lengthInBytes == pixels0.lengthInBytes, true);
        expect(ol32FLb.lengthInBytes == ol32FLb.pixels.lengthInBytes, true);
        expect(ol32FLb.lengthInBytes == ol32FLb.bulkdata.lengthInBytes, true);
        expect(ol32FLb.lengthInBytes == ol32FDb.lengthInBytes * nFrames1, true);

        // validity
        expect(ol32FLb.isValid, true);

        // FrameDescriptor values
        // transferSyntax
        expect(ol32FLb.ts == ts0, true);
        expect(ol32FLb.isCompressed, false);
        expect(ol32FLb.isEncapsulated, false);

        // FrameDescriptor fields
        expect(ol32FLb.samplesPerPixel == samplesPerPixel0, true);
        expect(ol32FLb.photometricInterpretation == photometricInterpretation1,
            true);
        expect(ol32FLb.rows == rows4, true);
        expect(ol32FLb.columns == columns6, true);
        expect(ol32FLb.bitsAllocated == bitsAllocated32, true);
        expect(ol32FLb.bitsStored == bitsStored32, true);
        expect(ol32FLb.highBit == highBit32, true);
        expect(ol32FLb.pixelRepresentation == pixelRepresentation0, true);
        expect(ol32FLb.planarConfiguration, isNull);
        expect(ol32FLb.pixelAspectRatio == pixelAspectRatio0, true);

        // FrameDescriptor
        expect(ol32FDb.ts == ts0, true);
        expect(ol32FDb.samplesPerPixel == samplesPerPixel0, true);
        expect(ol32FDb.photometricInterpretation == photometricInterpretation1,
            true);
        expect(ol32FDb.rows == rows4, true);
        expect(ol32FDb.columns == columns6, true);
        expect(ol32FDb.length == rows4 * columns6, true);
        expect(ol32FDb.bitsAllocated == bitsAllocated32, true);
        expect(ol32FDb.bitsStored == bitsStored32, true);
        expect(ol32FDb.highBit == highBit32, true);
        expect(ol32FDb.pixelRepresentation == pixelRepresentation0, true);
        expect(ol32FDb.planarConfiguration == planarConfiguration0, true);
        expect(ol32FDb.pixelAspectRatio == pixelAspectRatio0, true);
        expect(
            ol32FDb.lengthInBits == (rows4 * columns6) * bitsAllocated32, true);
        expect(ol32FDb.pixelSizeInBits == bitsAllocated32, true);
        expect(ol32FDb.length == rows4 * columns6, true);
      }
    });

    test('Invalid FrameList32Bit data test', () {
      // nFrames = 0 (Invalid Frames)
      const nFrames0 = 0;
      const photometricInterpretation1 = 'MONOCHROME3';

      final ol32FDc = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation1,
          rows4,
          columns6,
          bitsAllocated32,
          bitsStored32,
          highBit32,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final pixels0 = new Uint32List(ol32FDc.lengthInBytes);

      log
        ..debug('pixels0.length: ${pixels0.lengthInBytes}')
        ..debug('nFrames: $nFrames0')
        ..debug('pixelSize bits: ${ol32FDc.pixelSizeInBits}')
        ..debug('pixelSize bytes: ${ol32FDc.pixelSizeInBytes}');

      global.throwOnError = true;
      expect(() => new FrameList32Bit(pixels0, nFrames0, ol32FDc),
          throwsA(const TypeMatcher<InvalidFrameListError>()));

      // Invalid Pixels
      const nFrames1 = 1;
      const photometricInterpretation2 = 'MONOCHROME3';

      final ol32FDd = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation2,
          rows4,
          columns6,
          bitsAllocated32,
          bitsStored32,
          highBit32,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final pixels1 = new Uint32List(0);
      log
        ..debug('pixels0.length: ${pixels1.lengthInBytes}')
        ..debug('nFrames: $nFrames1')
        ..debug('pixelSize bits: ${ol32FDd.pixelSizeInBits}')
        ..debug('pixelSize bytes: ${ol32FDd.pixelSizeInBytes}');
      expect(() => new FrameList32Bit(pixels1, nFrames1, ol32FDd),
          throwsA(const TypeMatcher<InvalidFrameListError>()));

      // Invalid FrameDescriptor values
      const nFrames2 = 5;
      const photometricInterpretation3 = 'MONOCHROME3';

      final ol32FDe = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation3,
          rows4,
          columns6,
          bitsAllocated32,
          bitsStored32,
          highBit32,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final pixels2 = new Uint32List(ol32FDe.lengthInBytes);
      log
        ..debug('pixels0.length: ${pixels2.lengthInBytes}')
        ..debug('nFrames: $nFrames2')
        ..debug('pixelSize bits: ${ol32FDe.pixelSizeInBits}')
        ..debug('pixelSize bytes: ${ol32FDe.pixelSizeInBytes}');
      expect(() => new FrameList32Bit(pixels2, nFrames2, ol32FDe),
          throwsA(const TypeMatcher<InvalidFrameListError>()));
    });

    test('Create FrameList32Bit Uncompressed fromDataset', () {
      //Frame Descriptor.fromDataSet
      const ts = TransferSyntax.kExplicitVRLittleEndian;
      final ui0 = UItag.fromValues(PTag.kTransferSyntaxUID, [ts.asString]);
      final usSamplesPerPixel0 = UStag.fromValues(PTag.kSamplesPerPixel, [1]);
      final csPhotometricInterpretation0 =
          CStag.fromValues(PTag.kPhotometricInterpretation, ['RGB1']);
      final usRows0 = UStag.fromValues(PTag.kRows, [4]);
      final usColumns0 = UStag.fromValues(PTag.kColumns, [6]);
      final usBitsAllocated0 = UStag.fromValues(PTag.kBitsAllocated, [32]);
      final usBitsStored0 = UStag.fromValues(PTag.kBitsStored, [32]);
      final usHighBit0 = UStag.fromValues(PTag.kHighBit, [31]);
      final usPixelRepresentation0 =
          UStag.fromValues(PTag.kPixelRepresentation, [0]);
      final usPlanarConfiguration0 =
          UStag.fromValues(PTag.kPlanarConfiguration, [2]);
      final isPixelAspectRatio0 =
          IStag.fromValues(PTag.kPixelAspectRatio, ['1', '2']);
      const pixelAspectRatioValue0 = 1 / 2;
      final usSmallestImagePixelValue0 =
          UStag.fromValues(PTag.kSmallestImagePixelValue, [0]);
      final usLargestImagePixelValue0 =
          UStag.fromValues(PTag.kLargestImagePixelValue, [(1 << 16) - 1]);
      final obIccProfile0 = OBtag.fromValues(PTag.kICCProfile, <int>[]);
      final csColorSpace0 = CStag.fromValues(PTag.kColorSpace, <String>[]);
      final unPixelPaddingRangeLimit0 =
          UStag.fromValues(PTag.kPixelPaddingRangeLimit, <int>[]);

      final rds0 = new TagRootDataset.empty()
        ..fmi[ui0.code] = ui0
        ..add(usSamplesPerPixel0)
        ..add(csPhotometricInterpretation0)
        ..add(usRows0)
        ..add(usColumns0)
        ..add(usBitsAllocated0)
        ..add(usBitsStored0)
        ..add(usHighBit0)
        ..add(usPixelRepresentation0)
        ..add(usPlanarConfiguration0)
        ..add(isPixelAspectRatio0)
        ..add(usSmallestImagePixelValue0)
        ..add(usLargestImagePixelValue0)
        ..add(obIccProfile0)
        ..add(csColorSpace0)
        ..add(unPixelPaddingRangeLimit0);

      final ol32FDd = new FrameDescriptor.fromDataset(rds0);
      const nFrames0 = 1;
      final pixels0 = new Uint32List(ol32FDd.length);
      final ol32FLd = new FrameList32Bit(pixels0, nFrames0, ol32FDd);

      // pixels
      expect(ol32FLd.samplesPerPixel == ol32FDd.samplesPerPixel, true);
      expect(ol32FLd.pixels.length == pixels0.length, true);
      expect(ol32FLd.pixels.lengthInBytes == pixels0.lengthInBytes, true);

      expect(ol32FLd.pixelSizeInBytes == pixels0.elementSizeInBytes, true);

      expect(ol32FLd.pixelSizeInBits == ol32FDd.pixelSizeInBits, true);
      expect(ol32FLd.pixels is Uint32List, true);

      // nFrames
      expect(ol32FLd.length == nFrames0, true);
      expect(ol32FLd.nFrames == nFrames0, true);

      // frameLength
      expect(ol32FLd.frameLength == ol32FDd.length, true);
      expect(ol32FLd.lengthInBytes == ol32FLd.pixels.lengthInBytes, true);
      expect(ol32FLd.lengthInBytes == ol32FLd.bulkdata.lengthInBytes, true);

      // validity
      expect(ol32FLd.isValid, true);

      // FrameDescriptor.FromDataSET values
      // transferSyntax
      expect(ol32FLd.ts == ol32FDd.ts, true);
      expect(ol32FLd.isCompressed, false);
      expect(ol32FLd.isEncapsulated, false);

      // other FrameDescriptor.FromDataSet fields
      expect(ol32FLd.rows == ol32FDd.rows, true);
      expect(ol32FLd.columns == ol32FDd.columns, true);
      expect(
          ol32FLd.photometricInterpretation ==
              ol32FDd.photometricInterpretation,
          true);
      expect(ol32FLd.bitsAllocated == ol32FDd.bitsAllocated, true);
      expect(ol32FLd.bitsStored == ol32FDd.bitsStored, true);
      expect(ol32FLd.highBit == ol32FDd.highBit, true);
      expect(ol32FLd.pixelRepresentation == ol32FDd.pixelRepresentation, true);
      expect(ol32FLd.planarConfiguration == ol32FDd.planarConfiguration, true);
      expect(ol32FLd.pixelAspectRatio == pixelAspectRatioValue0, true);
      expect(ol32FLd.pixelSizeInBits == ol32FDd.pixelSizeInBits, true);
      expect(ol32FLd.frameLength == ol32FDd.length, true);
      expect(
          ol32FLd.desc.lengthInBytes == ol32FDd.lengthInBytes * nFrames0, true);

      expect(ol32FDd.smallestImagePixelValue == 0, true);
      expect(ol32FDd.largestImagePixelValue == 65535, true);
      expect(
          (ol32FDd.largestImagePixelValue >> usBitsStored0.value) == 0, true);
      expect(ol32FDd.redLUTDescriptor, null);
      expect(ol32FDd.greenLUTDescriptor, null);
      expect(ol32FDd.blueLUTDescriptor, null);
      expect(ol32FDd.alphaLUTDescriptor, null);
      expect(ol32FDd.redLUTData, null);
      expect(ol32FDd.greenLUTData, null);
      expect(ol32FDd.blueLUTData, null);
      expect(ol32FDd.alphaLUTData, null);
      expect(ol32FDd.iccProfile, null);
      expect(ol32FDd.colorSpace, null);
      expect(ol32FDd.pixelPaddingRangeLimit, null);

      // FrameDescriptor(fromDataSet)
      expect(ol32FDd.ts == ts, true);
      expect(ol32FDd.samplesPerPixel, equals(usSamplesPerPixel0.value));
      expect(ol32FDd.photometricInterpretation,
          equals(csPhotometricInterpretation0.value));
      expect(ol32FDd.rows, equals(usRows0.value));
      expect(ol32FDd.columns, equals(usColumns0.value));
      expect(ol32FDd.bitsAllocated, equals(usBitsAllocated0.value));
      expect(ol32FDd.bitsStored, equals(usBitsStored0.value));
      expect(ol32FDd.highBit, equals(usHighBit0.value));
      expect(ol32FDd.pixelRepresentation, equals(usPixelRepresentation0.value));
      expect(ol32FDd.planarConfiguration, equals(usPlanarConfiguration0.value));
      expect(ol32FDd.pixelAspectRatio, equals(pixelAspectRatioValue0));
      expect(ol32FDd.smallestImagePixelValue == 0, true);
      expect(ol32FDd.largestImagePixelValue == 65535, true);
      expect(
          (ol32FDd.largestImagePixelValue >> usBitsStored0.value) == 0, true);
    });

    test('FrameList32Bit operator []', () {
      int nFrames0;
      const photometricInterpretation0 = 'MONOCHROME1';

      final ol32FDe = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation0,
          rows4,
          columns6,
          bitsAllocated32,
          bitsStored32,
          highBit32,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      FrameList32Bit ol32FLc;

      for (var i = 0; i < 10; i++) {
        nFrames0 = i + 1;
        log.debug('nFrames0: $nFrames0');
        final pixels0 = new Uint32List(ol32FDe.length * nFrames0);
        ol32FLc = new FrameList32Bit(pixels0, nFrames0, ol32FDe);
        for (var j = 0; j < nFrames0; j++) {
          final frame0 = ol32FLc[j];
          expect(frame0.index == j, true);

          expect(
              frame0.lengthInBytes * nFrames0 == ol32FLc.pixels.lengthInBytes,
              true);

          expect(frame0.length == ol32FLc.desc.length, true);

          expect(frame0.lengthInBytes == ol32FLc.desc.lengthInBytes, true);
          expect(frame0.ts == ol32FLc.desc.ts, true);
          expect(frame0.samplesPerPixel == ol32FLc.desc.samplesPerPixel, true);
          expect(frame0.rows == ol32FLc.desc.rows, true);
          expect(frame0.columns == ol32FLc.desc.columns, true);
          expect(frame0.bitsAllocated == ol32FLc.desc.bitsAllocated, true);
          expect(frame0.bitsStored == ol32FLc.desc.bitsStored, true);
          expect(frame0.highBit == ol32FLc.desc.highBit, true);
          expect(frame0.pixelRepresentation == ol32FLc.desc.pixelRepresentation,
              true);
          expect(frame0.planarConfiguration == ol32FLc.desc.planarConfiguration,
              true);
          expect(
              frame0.pixelAspectRatio == ol32FLc.desc.pixelAspectRatio, true);

          expect(frame0.parent == ol32FLc, true);
          expect(frame0.length == ol32FLc.frameLength, true);
        }
      }
      log.debug('nFrames0: $nFrames0, Frames in FrameList: ${ol32FLc.nFrames}');
      expect(
          () => ol32FLc[nFrames0], throwsA(const TypeMatcher<RangeError>()));
    });
  });
}
