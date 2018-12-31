//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

import 'test_pixel_data.dart';

final Uint8List frame = Uint8List.fromList(testFrame);

void main() {
  Server.initialize(name: 'element/ow_frame_list_test', level: Level.info);

  /// OWtag Frame List Tests
  group('FrameList16Bit', () {
    const ts0 = TransferSyntax.kExplicitVRLittleEndian;
    const samplesPerPixel0 = 1;
    const rows4 = 4;
    const columns6 = 6;
    const bitsAllocated16 = 16;
    const bitsStored16 = 16;
    const highBit16 = 15;
    const pixelRepresentation0 = 0;
    const int planarConfiguration0 = null;
    const pixelAspectRatio0 = 1.0;

    test('Create FrameList16Bit Single Frame Uncompressed Tests', () {
      // Single Frame
      const length0 = 1;
      const photometricInterpretation0 = 'RGB';

      // Descriptor
      final owFDa = FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation0,
          rows4,
          columns6,
          bitsAllocated16,
          bitsStored16,
          highBit16,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final pixels0 = Uint16List(owFDa.length * length0);
      final ow16a = FrameList16Bit(pixels0, length0, owFDa);

      // pixels
      expect(ow16a.pixels is Uint16List, true);
      expect(ow16a.pixels.length == pixels0.length, true);
      expect(ow16a.pixels == pixels0, true);
      expect(ow16a.pixels.lengthInBytes == pixels0.lengthInBytes, true);
      expect(ow16a.pixelSizeInBits == owFDa.pixelSizeInBits, true);

      // bulkdata
      expect(ow16a.bulkdata.length == pixels0.lengthInBytes, true);
      expect(ow16a.bulkdata.length == ow16a.bulkdata.lengthInBytes, true);
      expect(ow16a.pixels.lengthInBytes == ow16a.bulkdata.length, true);

      // nFrames
      expect(ow16a.length == length0, true);

      // frameLength
      expect(ow16a.frameLength == rows4 * columns6, true);
      expect(ow16a.lengthInBytes == pixels0.lengthInBytes, true);
      expect(ow16a.lengthInBytes == ow16a.pixels.lengthInBytes, true);
      expect(ow16a.lengthInBytes == ow16a.bulkdata.lengthInBytes, true);
      expect(ow16a.lengthInBytes == owFDa.lengthInBytes * length0, true);

      // validity
      expect(ow16a.isValid, true);

      /// FrameDescriptor values
      // transferSyntax
      expect(ow16a.ts == ts0, true);
      expect(ow16a.isCompressed, false);
      expect(ow16a.isEncapsulated, false);

      // FrameDescriptor fields
      expect(ow16a.samplesPerPixel == samplesPerPixel0, true);
      expect(
          ow16a.photometricInterpretation == photometricInterpretation0, true);
      expect(ow16a.rows == rows4, true);
      expect(ow16a.columns == columns6, true);
      expect(ow16a.bitsAllocated == bitsAllocated16, true);
      expect(ow16a.bitsStored == bitsStored16, true);
      expect(ow16a.highBit == highBit16, true);
      expect(ow16a.pixelRepresentation == pixelRepresentation0, true);
      expect(ow16a.planarConfiguration, isNull);
      expect(ow16a.pixelAspectRatio == pixelAspectRatio0, true);

      //FrameDescriptor
      expect(owFDa.ts == ts0, true);
      expect(owFDa.samplesPerPixel == samplesPerPixel0, true);
      expect(
          owFDa.photometricInterpretation == photometricInterpretation0, true);
      expect(owFDa.rows == rows4, true);
      expect(owFDa.columns == columns6, true);
      expect(owFDa.length == rows4 * columns6, true);
      expect(owFDa.bitsAllocated == bitsAllocated16, true);
      expect(owFDa.bitsStored == bitsStored16, true);
      expect(owFDa.highBit == highBit16, true);
      expect(owFDa.pixelRepresentation == pixelRepresentation0, true);
      expect(owFDa.planarConfiguration == planarConfiguration0, true);
      expect(owFDa.pixelAspectRatio == pixelAspectRatio0, true);
      expect(owFDa.lengthInBits == (rows4 * columns6) * bitsAllocated16, true);
      expect(owFDa.pixelSizeInBits == bitsAllocated16, true);
      expect(owFDa.length == rows4 * columns6, true);
      expect(owFDa.lengthInBytes == pixels0.lengthInBytes, true);
    });

    test('Create FrameList16Bit MultiFrame Uncompressed Tests', () {
      int length1;
      const photometricInterpretation1 = 'RGB1';

      // Descriptor
      final owFDb = FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation1,
          rows4,
          columns6,
          bitsAllocated16,
          bitsStored16,
          highBit16,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      // Multi Frame with even number of frame
      for (var i = 1; i <= 10; i++) {
        length1 = i * 2;
        final pixels1 = Uint16List(owFDb.length * length1);

        final ow16b = FrameList16Bit(pixels1, length1, owFDb);

        // pixels
        expect(ow16b.pixels is Uint16List, true);
        expect(ow16b.pixels.length == pixels1.length, true);
        expect(ow16b.pixels == pixels1, true);
        expect(ow16b.pixels.lengthInBytes == pixels1.lengthInBytes, true);
        expect(ow16b.pixelSizeInBits == owFDb.pixelSizeInBits, true);

        // bulkdata
        expect(ow16b.bulkdata.length == pixels1.lengthInBytes, true);
        expect(ow16b.bulkdata.length == ow16b.bulkdata.lengthInBytes, true);
        expect(ow16b.pixels.lengthInBytes == ow16b.bulkdata.length, true);

        // nFrames
        expect(ow16b.length == length1, true);

        // frameLength
        expect(ow16b.frameLength == rows4 * columns6, true);
        expect(ow16b.lengthInBytes == pixels1.lengthInBytes, true);
        expect(ow16b.lengthInBytes == ow16b.pixels.lengthInBytes, true);
        expect(ow16b.lengthInBytes == ow16b.bulkdata.lengthInBytes, true);
        expect(ow16b.lengthInBytes == owFDb.lengthInBytes * length1, true);

        // validity
        expect(ow16b.isValid, true);

        /// FrameDescriptor values
        // transferSyntax
        expect(ow16b.ts == ts0, true);
        expect(ow16b.isCompressed, false);
        expect(ow16b.isEncapsulated, false);

        // FrameDescriptor fields
        expect(ow16b.samplesPerPixel == samplesPerPixel0, true);
        expect(ow16b.photometricInterpretation == photometricInterpretation1,
            true);
        expect(ow16b.rows == rows4, true);
        expect(ow16b.columns == columns6, true);
        expect(ow16b.bitsAllocated == bitsAllocated16, true);
        expect(ow16b.bitsStored == bitsStored16, true);
        expect(ow16b.highBit == highBit16, true);
        expect(ow16b.pixelRepresentation == pixelRepresentation0, true);
        expect(ow16b.planarConfiguration, isNull);
        expect(ow16b.pixelAspectRatio == pixelAspectRatio0, true);

        //FrameDescriptor
        expect(owFDb.ts == ts0, true);
        expect(owFDb.samplesPerPixel == samplesPerPixel0, true);
        expect(owFDb.photometricInterpretation == photometricInterpretation1,
            true);
        expect(owFDb.rows == rows4, true);
        expect(owFDb.columns == columns6, true);
        expect(owFDb.length == rows4 * columns6, true);
        expect(owFDb.bitsAllocated == bitsAllocated16, true);
        expect(owFDb.bitsStored == bitsStored16, true);
        expect(owFDb.highBit == highBit16, true);
        expect(owFDb.pixelRepresentation == pixelRepresentation0, true);
        expect(owFDb.planarConfiguration == planarConfiguration0, true);
        expect(owFDb.pixelAspectRatio == pixelAspectRatio0, true);
        expect(
            owFDb.lengthInBits == (rows4 * columns6) * bitsAllocated16, true);
        expect(owFDb.pixelSizeInBits == bitsAllocated16, true);
        expect(owFDb.length == rows4 * columns6, true);
      }
    });

    test('Invalid FrameList16Bit data test', () {
      //nFrames = 0 (Invalid Frames)
      const length0 = 0;
      const photometricInterpretation1 = 'MONOCHROME3';

      final owFDc = FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation1,
          rows4,
          columns6,
          bitsAllocated16,
          bitsStored16,
          highBit16,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final pixels0 = Uint16List(owFDc.lengthInBytes);

      log
        ..debug('pixels0.length: ${pixels0.lengthInBytes}')
        ..debug('nFrames: $length0')
        ..debug('pixelSize bits: ${owFDc.pixelSizeInBits}')
        ..debug('pixelSize bytes: ${owFDc.pixelSizeInBytes}');

      global.throwOnError = true;
      expect(() => FrameList16Bit(pixels0, length0, owFDc),
          throwsA(const TypeMatcher<InvalidFrameListError>()));

      // Invalid Pixels
      const length1 = 1;
      const photometricInterpretation2 = 'MONOCHROME3';

      final owFDd = FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation2,
          rows4,
          columns6,
          bitsAllocated16,
          bitsStored16,
          highBit16,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final pixels1 = Uint16List(0);
      log
        ..debug('pixels0.length: ${pixels1.lengthInBytes}')
        ..debug('nFrames: $length1')
        ..debug('pixelSize bits: ${owFDd.pixelSizeInBits}')
        ..debug('pixelSize bytes: ${owFDd.pixelSizeInBytes}');
      expect(() => FrameList16Bit(pixels1, length1, owFDd),
          throwsA(const TypeMatcher<InvalidFrameListError>()));

      // Invalid FrameDescriptor values
      const nFrames2 = 3;
      const photometricInterpretation3 = 'MONOCHROME3';

      final owFDe = FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation3,
          rows4,
          columns6,
          bitsAllocated16,
          bitsStored16,
          highBit16,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final pixels2 = Uint16List(owFDe.lengthInBytes);
      log
        ..debug('pixels0.length: ${pixels2.lengthInBytes}')
        ..debug('nFrames: $nFrames2')
        ..debug('pixelSize bits: ${owFDe.pixelSizeInBits}')
        ..debug('pixelSize bytes: ${owFDe.pixelSizeInBytes}');
      expect(() => FrameList16Bit(pixels2, nFrames2, owFDe),
          throwsA(const TypeMatcher<InvalidFrameListError>()));
    });

    test('Create FrameList16Bit() Uncompressed fromBytes', () {
      global.throwOnError = false;
      //Frame Descriptor.fromDataSet1
      const ts = TransferSyntax.kExplicitVRLittleEndian;
      final uiTransferSyntaxUID0 =
          UItag(PTag.kTransferSyntaxUID, [ts.asString]);
      final usSamplesPerPixel0 = UStag(PTag.kSamplesPerPixel, [1]);
      final csPhotometricInterpretation0 =
          CStag(PTag.kPhotometricInterpretation, ['RGB1']);
      final usRows0 = UStag(PTag.kRows, [4]);
      final usColumns0 = UStag(PTag.kColumns, [6]);
      final usBitsAllocated0 = UStag(PTag.kBitsAllocated, [16]);
      final usBitsStored0 = UStag(PTag.kBitsStored, [16]);
      final usHighBit0 = UStag(PTag.kHighBit, [15]);
      final usPixelRepresentation0 = UStag(PTag.kPixelRepresentation, [0]);
      final usPlanarConfiguration0 = UStag(PTag.kPlanarConfiguration, [2]);
      final isPixelAspectRatio0 = IStag(PTag.kPixelAspectRatio, ['1', '2']);
      const pixelAspectRatioValue0 = 1 / 2;
      final usSmallestImagePixelValue0 =
          UStag(PTag.kSmallestImagePixelValue, [0]);
      final usLargestImagePixelValue0 =
          UStag(PTag.kLargestImagePixelValue, [(1 << 16) - 1]);
      final obIccProfile0 = OBtag(PTag.kICCProfile, <int>[]);
      final csColorSpace0 = CStag(PTag.kColorSpace);

      global.throwOnError = false;
      final unPixelPaddingRangeLimit =
          UStag(PTag.kPixelPaddingRangeLimit, [65536]);
      expect(unPixelPaddingRangeLimit, isNull);
      global.throwOnError = true;
      expect(() => UStag(PTag.kPixelPaddingRangeLimit, [65536]),
          throwsA(const TypeMatcher<InvalidValuesError>()));

      final unPixelPaddingRangeLimit0 =
          UStag(PTag.kPixelPaddingRangeLimit, [65535]);

      final rds0 = TagRootDataset.empty()
        ..fmi[uiTransferSyntaxUID0.code] = uiTransferSyntaxUID0
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

      final fd16c = FrameDescriptor.fromDataset(rds0);
      const length0 = 1;
      final pixels0 = Uint16List(fd16c.length * length0);
      final ow16c = FrameList16Bit(pixels0, length0, fd16c);

      log.debug('pixelAspectRatio: ${fd16c.pixelAspectRatio}');

      // pixels
      expect(ow16c.samplesPerPixel == fd16c.samplesPerPixel, true);
      expect(ow16c.pixels.length == pixels0.length, true);
      expect(ow16c.pixels.lengthInBytes == pixels0.lengthInBytes, true);

      expect(ow16c.pixelSizeInBytes == pixels0.elementSizeInBytes, true);

      expect(ow16c.pixelSizeInBits == fd16c.pixelSizeInBits, true);
      expect(ow16c.pixels is Uint16List, true);

      // nFrames
      expect(ow16c.length == length0, true);

      // frameLength
      expect(ow16c.frameLength == fd16c.length, true);
      expect(ow16c.lengthInBytes == ow16c.pixels.lengthInBytes, true);
      expect(ow16c.lengthInBytes == ow16c.bulkdata.lengthInBytes, true);

      // validity
      expect(ow16c.isValid, true);

      // FrameDescriptor.FromDataSET values
      // transferSyntax
      expect(ow16c.ts == fd16c.ts, true);
      expect(ow16c.isCompressed, false);
      expect(ow16c.isEncapsulated, false);

      // other FrameDescriptor.FromDataSet fields
      expect(ow16c.rows == fd16c.rows, true);
      expect(ow16c.columns == fd16c.columns, true);
      expect(ow16c.photometricInterpretation == fd16c.photometricInterpretation,
          true);
      expect(ow16c.bitsAllocated == fd16c.bitsAllocated, true);
      expect(ow16c.bitsStored == fd16c.bitsStored, true);
      expect(ow16c.highBit == fd16c.highBit, true);
      expect(ow16c.pixelRepresentation == fd16c.pixelRepresentation, true);
      expect(ow16c.planarConfiguration == fd16c.planarConfiguration, true);
      expect(ow16c.pixelAspectRatio == pixelAspectRatioValue0, true);
      expect(ow16c.pixelSizeInBits == fd16c.pixelSizeInBits, true);
      expect(ow16c.frameLength == fd16c.length, true);
      expect(ow16c.desc.lengthInBytes == fd16c.lengthInBytes * length0, true);

      expect(fd16c.smallestImagePixelValue == 0, true);
      expect(fd16c.largestImagePixelValue == 65535, true);
      expect((fd16c.largestImagePixelValue >> usBitsStored0.value) == 0, true);
      expect(fd16c.redLUTDescriptor, null);
      expect(fd16c.greenLUTDescriptor, null);
      expect(fd16c.blueLUTDescriptor, null);
      expect(fd16c.alphaLUTDescriptor, null);
      expect(fd16c.redLUTData, null);
      expect(fd16c.greenLUTData, null);
      expect(fd16c.blueLUTData, null);
      expect(fd16c.alphaLUTData, null);
      expect(fd16c.iccProfile, null);
      expect(fd16c.colorSpace, null);
      expect(fd16c.pixelPaddingRangeLimit, null);

      // FrameDescriptor(fromDataSet)
      expect(fd16c.ts == ts, true);
      expect(fd16c.samplesPerPixel, equals(usSamplesPerPixel0.value));
      expect(fd16c.photometricInterpretation,
          equals(csPhotometricInterpretation0.value));
      expect(fd16c.rows, equals(usRows0.value));
      expect(fd16c.columns, equals(usColumns0.value));
      expect(fd16c.bitsAllocated, equals(usBitsAllocated0.value));
      expect(fd16c.bitsStored, equals(usBitsStored0.value));
      expect(fd16c.highBit, equals(usHighBit0.value));
      expect(fd16c.pixelRepresentation, equals(usPixelRepresentation0.value));
      expect(fd16c.planarConfiguration, equals(usPlanarConfiguration0.value));
      expect(fd16c.pixelAspectRatio, equals(pixelAspectRatioValue0));
      expect(fd16c.smallestImagePixelValue == 0, true);
      expect(fd16c.largestImagePixelValue == 65535, true);
      expect((fd16c.largestImagePixelValue >> usBitsStored0.value) == 0, true);
    });

    test('operator[] frame', () {
      int length0;
      const photometricInterpretation0 = 'MONOCHROME1';

      final owFDf = FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation0,
          rows4,
          columns6,
          bitsAllocated16,
          bitsStored16,
          highBit16,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      FrameList16Bit ow16c;

      for (var i = 0; i < 10; i++) {
        length0 = i + 1;
        log.debug('length0: $length0');
        final pixels0 = Uint16List(owFDf.length * length0);
        ow16c = FrameList16Bit(pixels0, length0, owFDf);
        for (var j = 0; j < length0; j++) {
          final frame0 = ow16c[j];
          expect(frame0.index == j, true);

          expect(frame0.lengthInBytes * length0 == ow16c.pixels.lengthInBytes,
              true);

          expect(frame0.length == ow16c.desc.length, true);

          expect(frame0.lengthInBytes == ow16c.desc.lengthInBytes, true);
          expect(frame0.ts == ow16c.desc.ts, true);
          expect(frame0.samplesPerPixel == ow16c.desc.samplesPerPixel, true);
          expect(frame0.rows == ow16c.desc.rows, true);
          expect(frame0.columns == ow16c.desc.columns, true);
          expect(frame0.bitsAllocated == ow16c.desc.bitsAllocated, true);
          expect(frame0.bitsStored == ow16c.desc.bitsStored, true);
          expect(frame0.highBit == ow16c.desc.highBit, true);
          expect(frame0.pixelRepresentation == ow16c.desc.pixelRepresentation,
              true);
          expect(frame0.planarConfiguration == ow16c.desc.planarConfiguration,
              true);
          expect(frame0.pixelAspectRatio == ow16c.desc.pixelAspectRatio, true);

          expect(frame0.parent == ow16c, true);
          expect(frame0.length == ow16c.frameLength, true);
        }
      }
      log.debug('length0: $length0, Frames in FrameList: ${ow16c.length}');
      expect(() => ow16c[length0], throwsA(const TypeMatcher<RangeError>()));
    });

    test('Frame16Bit', () {
      const length0 = 1;
      const photometricInterpretation0 = 'RGB';

      // Descriptor
      final owFDa = FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation0,
          rows4,
          columns6,
          bitsAllocated16,
          bitsStored16,
          highBit16,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final pixels0 = Uint16List(owFDa.length * length0);
      final ow16a = FrameList16Bit(pixels0, length0, owFDa);

      final frame16 = Frame16Bit(ow16a, pixels0, 1);
      log.debug('frame16: $frame16');

      // pixels
      expect(frame16.pixels is Uint16List, true);
      expect(frame16.pixels.length == pixels0.length, true);
      expect(frame16.pixels == pixels0, true);
      expect(frame16.pixels.lengthInBytes == pixels0.lengthInBytes, true);
      expect(frame16.pixelSizeInBits == owFDa.pixelSizeInBits, true);

      // bulkdata
      expect(frame16.bulkdata.length == pixels0.lengthInBytes, true);
      expect(frame16.bulkdata.length == frame16.bulkdata.lengthInBytes, true);
      expect(frame16.pixels.lengthInBytes == frame16.bulkdata.length, true);

      // nFrames
      expect(frame16.length == pixels0.length, true);

      // frameLength
      expect(frame16.lengthInBytes == pixels0.lengthInBytes, true);
      expect(frame16.lengthInBytes == frame16.pixels.lengthInBytes, true);
      expect(frame16.lengthInBytes == frame16.bulkdata.lengthInBytes, true);
      expect(frame16.lengthInBytes == owFDa.lengthInBytes * length0, true);

      // transferSyntax
      expect(frame16.ts == ts0, true);

      // FrameDescriptor fields
      expect(frame16.samplesPerPixel == samplesPerPixel0, true);
      expect(frame16.rows == rows4, true);
      expect(frame16.columns == columns6, true);
      expect(frame16.bitsAllocated == bitsAllocated16, true);
      expect(frame16.bitsStored == bitsStored16, true);
      expect(frame16.highBit == highBit16, true);
      expect(frame16.pixelRepresentation == pixelRepresentation0, true);
      expect(frame16.planarConfiguration, isNull);
      expect(frame16.pixelAspectRatio == pixelAspectRatio0, true);
    });
  });
}
