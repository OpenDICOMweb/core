// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

import 'test_pixel_data.dart';

final Uint8List frame = new Uint8List.fromList(testFrame);

void main() {
  Server.initialize(name: 'element/ob_frame_list_test', level: Level.info);

  // FrameList1Bit
  group('FrameList1Bit', () {
    const ts0 = TransferSyntax.kExplicitVRLittleEndian;
    const samplesPerPixel0 = 1;
    const rows4 = 4;
    const columns6 = 6;
    const bitsAllocated1 = 1;
    const bitsStored1 = 1;
    const highBit1 = 0;
    const pixelRepresentation0 = 0;
    const int planarConfiguration0 = null;
    const pixelAspectRatio0 = 1.0;

    test('Create Uncompressed FrameList1Bit SingleFrame', () {
      // Single Frame
      const nFrames0 = 1;
      const photometricInterpretation0 = 'MONOCHROME1';

      final ob1FDa = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation0,
          rows4,
          columns6,
          bitsAllocated1,
          bitsStored1,
          highBit1,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final pixels0 = new Uint8List(ob1FDa.lengthInBytes);

      final ob1FLa = new FrameList1Bit(pixels0, nFrames0, ob1FDa);

      // pixels
      expect(ob1FLa.pixels is Uint8List, true);
      expect(ob1FLa.pixels.length == pixels0.length, true);
      expect(ob1FLa.pixels.lengthInBytes == pixels0.lengthInBytes, true);
      log
        ..debug('ob1BitFrames0.pixelSizeInBits: ${ob1FLa.pixelSizeInBits}')
        ..debug('pixels0.elementSizeInBytes: ${pixels0.elementSizeInBytes}');
      expect(ob1FLa.pixelSizeInBits == pixels0.elementSizeInBytes, true);
      system.throwOnError = true;
/*
  TODO: jim to fix
      expect(
         () => ob1FLa.pixelSizeInBytes, throwsA(const isInstanceOf<UnsupportedError>
	    ()));
*/

      // bulkdata
      expect(ob1FLa.bulkdata.length == pixels0.lengthInBytes, true);
      expect(ob1FLa.bulkdata.length == ob1FLa.bulkdata.lengthInBytes, true);
      expect(ob1FLa.pixels.lengthInBytes == ob1FLa.bulkdata.length, true);
      expect(ob1FLa.pixels == pixels0, true);

      // nFrames
      expect(ob1FLa.nFrames == 1, true);

      // frameLength
      expect(ob1FLa.desc.length == rows4 * columns6, true);
      expect(ob1FLa.lengthInBytes == pixels0.lengthInBytes, true);
      expect(ob1FLa.lengthInBytes == ob1FLa.pixels.lengthInBytes, true);
      expect(ob1FLa.lengthInBytes == ob1FLa.bulkdata.lengthInBytes, true);

      //validity
      expect(ob1FLa.isValid, true);

      // FrameDescriptor values
      // transferSyntax
      expect(ob1FLa.ts == ts0, true);
      expect(ob1FLa.isCompressed, false);
      expect(ob1FLa.isEncapsulated, false);

      //other FrameDescriptor fields
      expect(ob1FLa.samplesPerPixel == samplesPerPixel0, true);
      expect(
          ob1FLa.photometricInterpretation == photometricInterpretation0, true);
      expect(ob1FLa.rows == rows4, true);
      expect(ob1FLa.columns == columns6, true);
      expect(ob1FLa.bitsAllocated == bitsAllocated1, true);
      expect(ob1FLa.bitsStored == bitsStored1, true);
      expect(ob1FLa.highBit == highBit1, true);
      expect(ob1FLa.pixelRepresentation == pixelRepresentation0, true);
      expect(ob1FLa.planarConfiguration, isNull);
      expect(ob1FLa.pixelAspectRatio == pixelAspectRatio0, true);

      expect(ob1FDa.ts == ts0, true);
      expect(ob1FDa.samplesPerPixel == samplesPerPixel0, true);

      //FrameDescriptor
      expect(ob1FDa.ts == ts0, true);
      expect(ob1FDa.samplesPerPixel == samplesPerPixel0, true);
      expect(
          ob1FDa.photometricInterpretation == photometricInterpretation0, true);
      expect(ob1FDa.rows == rows4, true);
      expect(ob1FDa.columns == columns6, true);
      expect(ob1FDa.length == rows4 * columns6, true);
      expect(ob1FDa.bitsAllocated == bitsAllocated1, true);
      expect(ob1FDa.bitsStored == bitsStored1, true);
      expect(ob1FDa.highBit == highBit1, true);
      expect(ob1FDa.pixelRepresentation == pixelRepresentation0, true);
      expect(ob1FDa.planarConfiguration == planarConfiguration0, true);
      expect(ob1FDa.pixelAspectRatio == pixelAspectRatio0, true);
      expect(ob1FDa.lengthInBits == (rows4 * columns6) * bitsAllocated1, true);
      expect(ob1FDa.pixelSizeInBits == bitsAllocated1, true);
      expect(ob1FDa.length == rows4 * columns6, true);
      expect(ob1FDa.lengthInBytes == pixels0.lengthInBytes, true);

      final bytes0 = new Uint8List(ob1FLa.lengthInBytes);
      expect(bytes0, equals(pixels0));
    });

    test('Create Uncompressed FrameList1Bit MultiFrame', () {
      int nFrames0;
      const photometricInterpretation0 = 'MONOCHROME2';

      final ob1FDb = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation0,
          rows4,
          columns6,
          bitsAllocated1,
          bitsStored1,
          highBit1,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      for (var i = 1; i <= 10; i++) {
        // Multi Frame (Even number of frames)
        nFrames0 = i * 2;
        log.debug('nFrames0: $nFrames0');
        final pixels1 = new Uint8List(nFrames0 * (ob1FDb.lengthInBytes));
        final ob1FLb = new FrameList1Bit(pixels1, nFrames0, ob1FDb);

        // pixels
        expect(ob1FLb.pixels is Uint8List, true);
        expect(ob1FLb.pixels.length == pixels1.length, true);
        expect(ob1FLb.pixels.lengthInBytes == pixels1.lengthInBytes, true);
        expect(ob1FLb.pixels == pixels1, true);
/*
 TODO: jim to fix
        expect(() => ob1FLb.pixelSizeInBytes,
            throwsA(const isInstanceOf<UnsupportedError>()));
*/

        // bulkdata
        expect(ob1FLb.bulkdata.length == pixels1.lengthInBytes, true);
        expect(ob1FLb.bulkdata.length == ob1FLb.bulkdata.lengthInBytes, true);
        expect(ob1FLb.pixels.lengthInBytes == ob1FLb.bulkdata.length, true);

        // nFrames
        expect(ob1FLb.length == nFrames0, true);
        expect(ob1FLb.nFrames == nFrames0, true);

        // frameLength
        expect(ob1FLb.desc.length == rows4 * columns6, true);
        expect(ob1FLb.lengthInBytes == pixels1.lengthInBytes, true);
        expect(ob1FLb.lengthInBytes == ob1FLb.pixels.lengthInBytes, true);
        expect(ob1FLb.lengthInBytes == ob1FLb.bulkdata.lengthInBytes, true);

        // validity
        expect(ob1FLb.isValid, true);

        // FrameDescriptor values
        // transferSyntax
        expect(ob1FLb.ts == ts0, true);
        expect(ob1FLb.isCompressed, false);
        expect(ob1FLb.isEncapsulated, false);

        // other FrameDescriptor fields
        expect(ob1FLb.samplesPerPixel == samplesPerPixel0, true);
        expect(ob1FLb.photometricInterpretation == photometricInterpretation0,
            true);
        expect(ob1FLb.rows == rows4, true);
        expect(ob1FLb.columns == columns6, true);
        expect(ob1FLb.bitsAllocated == bitsAllocated1, true);
        expect(ob1FLb.bitsStored == bitsStored1, true);
        expect(ob1FLb.highBit == highBit1, true);
        expect(ob1FLb.pixelRepresentation == pixelRepresentation0, true);
        expect(ob1FLb.planarConfiguration, isNull);
        expect(ob1FLb.pixelAspectRatio == pixelAspectRatio0, true);

        //FrameDescriptor
        expect(ob1FDb.ts == ts0, true);
        expect(ob1FDb.samplesPerPixel == samplesPerPixel0, true);
        expect(ob1FDb.photometricInterpretation == photometricInterpretation0,
            true);
        expect(ob1FDb.rows == rows4, true);
        expect(ob1FDb.columns == columns6, true);
        expect(ob1FDb.length == rows4 * columns6, true);
        expect(ob1FDb.bitsAllocated == bitsAllocated1, true);
        expect(ob1FDb.bitsStored == bitsStored1, true);
        expect(ob1FDb.highBit == highBit1, true);
        expect(ob1FDb.pixelRepresentation == pixelRepresentation0, true);
        expect(ob1FDb.planarConfiguration == planarConfiguration0, true);
        expect(ob1FDb.pixelAspectRatio == pixelAspectRatio0, true);
        expect(
            ob1FDb.lengthInBits == (rows4 * columns6) * bitsAllocated1, true);
        expect(ob1FDb.pixelSizeInBits == bitsAllocated1, true);
        expect(ob1FDb.length == rows4 * columns6, true);

        final bytes1 = new Uint8List(ob1FLb.lengthInBytes);
        expect(bytes1, equals(pixels1));
      }
    });

    test('Invalid FrameList1Bit data test', () {
      //nFrames = 0 (Invalid number of Frames)
      const nFrames0 = 0;
      const photometricInterpretation1 = 'MONOCHROME3';

      final ob1FDc = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation1,
          rows4,
          columns6,
          bitsAllocated1,
          bitsStored1,
          highBit1,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final pixels3 = new Uint8List(ob1FDc.lengthInBytes);

      system.throwOnError = true;
      log.debug('nFrames: $nFrames0');
      expect(() => new FrameList1Bit(pixels3, nFrames0, ob1FDc),
          throwsA(const isInstanceOf<InvalidFrameListError>()));

      // Invalid Pixels [== 0]
      const nFrames1 = 1;
      const photometricInterpretation0 = 'MONOCHROME3';

      final ob1FDd = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation0,
          rows4,
          columns6,
          bitsAllocated1,
          bitsStored1,
          highBit1,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final pixels4 = new Uint8List(0);

      log
        ..debug('pixels4.lengthInBytes: ${pixels4.lengthInBytes}')
        ..debug('nFrames: $nFrames1');

      expect(() => new FrameList1Bit(pixels4, nFrames1, ob1FDd),
          throwsA(const isInstanceOf<InvalidFrameListError>()));

      // Invalid FrameDescriptor data
      const nFrames2 = 2;
      const photometricInterpretation2 = 'MONOCHROME3';

      final ob1FDe = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation2,
          rows4,
          columns6,
          bitsAllocated1,
          bitsStored1,
          highBit1,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final pixels5 = new Uint8List(ob1FDe.lengthInBytes);

      log
        ..debug('pixels5.lengthInBytes: ${pixels5.lengthInBytes}')
        ..debug('nFrames: $nFrames2')
        ..debug('pixelSize bits: ${ob1FDe.pixelSizeInBits}')
        ..debug('pixelSize bytes: ${ob1FDe.pixelSizeInBytes}');

      expect(() => new FrameList1Bit(pixels5, nFrames2, ob1FDe),
          throwsA(const isInstanceOf<InvalidFrameListError>()));
    });

    test('Create Uncompressed FrameList1Bit (FrameDescriptor.fromDataset)', () {
      //Frame Descriptor.fromDataSet1
      final ts = TransferSyntax.kExplicitVRLittleEndian;
      final uiTransferSyntaxUID0 =
          new UItag.fromStrings(PTag.kTransferSyntaxUID, [ts.asString]);
      final usSamplesPerPixel0 = new UStag(PTag.kSamplesPerPixel, [1]);
      final csPhotometricInterpretation0 =
          new CStag(PTag.kPhotometricInterpretation, ['PJZ7YG5']);
      final usRows0 = new UStag(PTag.kRows, [4]);
      final usColumns0 = new UStag(PTag.kColumns, [2]);
      final usBitsAllocated0 = new UStag(PTag.kBitsAllocated, [1]);
      final usBitsStored0 = new UStag(PTag.kBitsStored, [1]);
      final usHighBit0 = new UStag(PTag.kHighBit, [0]);
      final usPixelRepresentation0 = new UStag(PTag.kPixelRepresentation, [2]);
      final usPlanarConfiguration0 = new UStag(PTag.kPlanarConfiguration, [7]);
      final isPixelAspectRatio0 = new IStag(PTag.kPixelAspectRatio, ['1', '2']);
      final pixelAspectRatioValue0 = 1 / 2;
      final usSmallestImagePixelValue0 =
          new UStag(PTag.kSmallestImagePixelValue, [0]);
      final usLargestImagePixelValue0 =
          new UStag(PTag.kLargestImagePixelValue, [1]);
      final obIccProfile0 = new OBtag(PTag.kICCProfile, <int>[], 0);
      final csColorSpace0 = new CStag(PTag.kColorSpace);
      final usPixelPaddingRangeLimit0 = new UStag(PTag.kPixelPaddingRangeLimit);

      final rootDS0 = new TagRootDataset.empty()
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
        ..add(usPixelPaddingRangeLimit0);

      print('ui: ${rootDS0.fmi[kTransferSyntaxUID]}');
      log.debug('rootDS0.transferSyntax: ${rootDS0.transferSyntax}');

      final ob1FDf = new FrameDescriptor.fromDataset(rootDS0);

      final nFrames0 = 1;
      final pixels0 = new Uint8List(ob1FDf.lengthInBytes);

      final ob1c = new FrameList1Bit(pixels0, nFrames0, ob1FDf);

      // pixels
      expect(ob1c.samplesPerPixel == ob1FDf.samplesPerPixel, true);
      expect(ob1c.pixels.length == pixels0.length, true);
      expect(ob1c.pixels.lengthInBytes == pixels0.lengthInBytes, true);
/*
 TODO: jim to fix
      expect(
          () => ob1c.pixelSizeInBytes, throwsA(const isInstanceOf<UnsupportedError>()));
*/

      expect(ob1c.pixelSizeInBits == ob1FDf.pixelSizeInBits, true);
      expect(ob1c.pixels is Uint8List, true);

      // nFrames
      expect(ob1c.length == nFrames0, true); //nFrames0=1
      expect(ob1c.nFrames == nFrames0, true); //nFrames0=1;

      // frameLength
      expect(ob1c.frameLength == ob1FDf.length, true);
      expect(ob1c.lengthInBytes == ob1c.pixels.lengthInBytes, true);
      expect(ob1c.lengthInBytes == ob1c.bulkdata.lengthInBytes, true);

      //  validity
      expect(ob1c.isValid, true);

      //  FrameDescriptor.FromDataSET values
      //  transferSyntax
      expect(ob1c.ts == ob1FDf.ts, true);
      expect(ob1c.isCompressed, false);
      expect(ob1c.isEncapsulated, false);

      //  other FrameDescriptor.FromDataSet fields
      expect(ob1c.rows == ob1FDf.rows, true);
      expect(ob1c.columns == ob1FDf.columns, true);
      expect(ob1c.photometricInterpretation == ob1FDf.photometricInterpretation,
          true);
      expect(ob1c.bitsAllocated == ob1FDf.bitsAllocated, true);
      expect(ob1c.bitsStored == ob1FDf.bitsStored, true);
      expect(ob1c.highBit == ob1FDf.highBit, true);
      expect(ob1c.pixelRepresentation == ob1FDf.pixelRepresentation, true);
      expect(ob1c.planarConfiguration == ob1FDf.planarConfiguration, true);
      expect(ob1c.pixelAspectRatio == pixelAspectRatioValue0, true);
      expect(ob1c.pixelSizeInBits == ob1FDf.pixelSizeInBits, true);
      expect(ob1c.frameLength == ob1FDf.length, true);
      expect(ob1c.desc.lengthInBytes == ob1FDf.lengthInBytes * nFrames0, true);

      expect(ob1FDf.smallestImagePixelValue == 0, true);
      expect(ob1FDf.largestImagePixelValue == 1, true);
      expect(ob1FDf.largestImagePixelValue >> usBitsStored0.value == 0, true);
      expect(ob1FDf.redLUTDescriptor, null);
      expect(ob1FDf.greenLUTDescriptor, null);
      expect(ob1FDf.blueLUTDescriptor, null);
      expect(ob1FDf.alphaLUTDescriptor, null);
      expect(ob1FDf.redLUTData, null);
      expect(ob1FDf.greenLUTData, null);
      expect(ob1FDf.blueLUTData, null);
      expect(ob1FDf.alphaLUTData, null);
      expect(ob1FDf.iccProfile, null);
      expect(ob1FDf.colorSpace, null);
      expect(ob1FDf.pixelPaddingRangeLimit, null);

      // FrameDescriptor(fromDataSet)
      expect(ob1FDf.ts == ts, true);
      expect(ob1FDf.samplesPerPixel, equals(usSamplesPerPixel0.value));
      expect(ob1FDf.photometricInterpretation,
          equals(csPhotometricInterpretation0.value));
      expect(ob1FDf.rows, equals(usRows0.value));
      expect(ob1FDf.columns, equals(usColumns0.value));
      expect(ob1FDf.bitsAllocated, equals(usBitsAllocated0.value));
      expect(ob1FDf.bitsStored, equals(usBitsStored0.value));
      expect(ob1FDf.highBit, equals(usHighBit0.value));
      expect(ob1FDf.pixelRepresentation, equals(usPixelRepresentation0.value));
      expect(ob1FDf.planarConfiguration, equals(usPlanarConfiguration0.value));
      expect(ob1FDf.pixelAspectRatio, equals(pixelAspectRatioValue0));
      expect(ob1FDf.smallestImagePixelValue == 0, true);
      expect(ob1FDf.largestImagePixelValue == 1, true);
      expect(ob1FDf.largestImagePixelValue >> usBitsStored0.value == 0, true);
    });

    test('Frame1Bit operator []', () {
      int nFrames0;
      const photometricInterpretation0 = 'MONOCHROME1';

      final ob1FDg = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation0,
          rows4,
          columns6,
          bitsAllocated1,
          bitsStored1,
          highBit1,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      FrameList1Bit ob1FLb;

      //Frames ranging from 1 to 10
      for (var i = 0; i < 10; i++) {
        nFrames0 = i + 1;
        final pixels0 = new Uint8List(nFrames0 * (ob1FDg.lengthInBytes));
        ob1FLb = new FrameList1Bit(pixels0, nFrames0, ob1FDg);
        log.debug('nFrames0: $nFrames0');

        for (var j = 0; j < nFrames0; j++) {
          final frame0 = ob1FLb[j];
          expect(frame0.index == j, true);

          expect(frame0.lengthInBytes * nFrames0 == ob1FLb.pixels.lengthInBytes,
              true);

          expect(frame0.length == ob1FLb.desc.length, true);

          expect(frame0.lengthInBytes == ob1FLb.desc.lengthInBytes, true);
          expect(frame0.ts == ob1FLb.desc.ts, true);
          expect(frame0.samplesPerPixel == ob1FLb.desc.samplesPerPixel, true);
          expect(frame0.rows == ob1FLb.desc.rows, true);
          expect(frame0.columns == ob1FLb.desc.columns, true);
          expect(frame0.bitsAllocated == ob1FLb.desc.bitsAllocated, true);
          expect(frame0.bitsStored == ob1FLb.desc.bitsStored, true);
          expect(frame0.highBit == ob1FLb.desc.highBit, true);
          expect(frame0.pixelRepresentation == ob1FLb.desc.pixelRepresentation,
              true);
          expect(frame0.planarConfiguration == ob1FLb.desc.planarConfiguration,
              true);
          expect(frame0.pixelAspectRatio == ob1FLb.desc.pixelAspectRatio, true);

          expect(frame0.parent == ob1FLb, true);
          expect(frame0.length == ob1FLb.frameLength, true);
        }
      }
      log.debug('nFrames0: $nFrames0, Frames in FrameList: ${ob1FLb.nFrames}');
      expect(() => ob1FLb[nFrames0], throwsA(const isInstanceOf<RangeError>()));
    });
  });

  // FrameList8Bit
  group('FrameList8Bit', () {
    const ts0 = TransferSyntax.kExplicitVRLittleEndian;
    const samplesPerPixel0 = 1;
    const rows4 = 4;
    const columns6 = 6;
    const bitsAllocated8 = 8;
    const bitsStored8 = 8;
    const highBit8 = 7;
    const pixelRepresentation0 = 0;
    const int planarConfiguration0 = null;
    const pixelAspectRatio0 = 1.0;

    test('Create Uncompressed FrameList8Bit SingleFrame', () {
      // Single Frame
      const nFrames0 = 1;
      const photometricInterpretation0 = 'MONOCHROME1';

      final ob8FDa = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation0,
          rows4,
          columns6,
          bitsAllocated8,
          bitsStored8,
          highBit8,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final pixels0 = new Uint8List(ob8FDa.lengthInBytes);

      final ob8a = new FrameList8Bit(pixels0, nFrames0, ob8FDa);

      // pixels
      expect(ob8a.pixels is Uint8List, true);
      expect(ob8a.pixels.length == pixels0.length, true);
      expect(ob8a.pixels == pixels0, true);
      expect(ob8a.pixels.lengthInBytes == pixels0.lengthInBytes, true);
      expect(ob8a.pixelSizeInBits == ob8FDa.pixelSizeInBits, true);

      // bulkdata
      expect(ob8a.bulkdata.length == pixels0.lengthInBytes, true);
      expect(ob8a.bulkdata.length == ob8a.bulkdata.lengthInBytes, true);
      expect(ob8a.pixels.lengthInBytes == ob8a.bulkdata.length, true);

      // nFrames
      expect(ob8a.length == nFrames0, true);
      expect(ob8a.nFrames == nFrames0, true);

      // frameLength
      expect(ob8a.frameLength == rows4 * columns6, true);
      expect(ob8a.lengthInBytes == pixels0.lengthInBytes, true);
      expect(ob8a.lengthInBytes == ob8FDa.lengthInBytes * nFrames0, true);
      expect(ob8a.lengthInBytes == ob8a.pixels.lengthInBytes, true);
      expect(ob8a.lengthInBytes == ob8a.bulkdata.lengthInBytes, true);

      // validity
      expect(ob8a.isValid, true);

      // FrameDescriptor values
      // transferSyntax
      expect(ob8a.ts == ts0, true);
      expect(ob8a.isCompressed, false);
      expect(ob8a.isEncapsulated, false);

      //other FrameDescriptor fields
      expect(ob8a.samplesPerPixel == samplesPerPixel0, true);
      expect(
          ob8a.photometricInterpretation == photometricInterpretation0, true);
      expect(ob8a.rows == rows4, true);
      expect(ob8a.columns == columns6, true);
      expect(ob8a.bitsAllocated == bitsAllocated8, true);
      expect(ob8a.bitsStored == bitsStored8, true);
      expect(ob8a.highBit == highBit8, true);
      expect(ob8a.pixelRepresentation == pixelRepresentation0, true);
      expect(ob8a.planarConfiguration, isNull);
      expect(ob8a.pixelAspectRatio == pixelAspectRatio0, true);

      // FrameDescriptor
      expect(ob8FDa.ts == ts0, true);
      expect(ob8FDa.samplesPerPixel == samplesPerPixel0, true);
      expect(
          ob8FDa.photometricInterpretation == photometricInterpretation0, true);
      expect(ob8FDa.rows == rows4, true);
      expect(ob8FDa.columns == columns6, true);
      expect(ob8FDa.length == rows4 * columns6, true);
      expect(ob8FDa.bitsAllocated == bitsAllocated8, true);
      expect(ob8FDa.bitsStored == bitsStored8, true);
      expect(ob8FDa.highBit == highBit8, true);
      expect(ob8FDa.pixelRepresentation == pixelRepresentation0, true);
      expect(ob8FDa.planarConfiguration == planarConfiguration0, true);
      expect(ob8FDa.pixelAspectRatio == pixelAspectRatio0, true);
      expect(ob8FDa.lengthInBits == (rows4 * columns6) * bitsAllocated8, true);
      expect(ob8FDa.pixelSizeInBits == bitsAllocated8, true);
      expect(ob8FDa.length == rows4 * columns6, true);
      expect(ob8FDa.lengthInBytes == pixels0.lengthInBytes, true);

      final bytes0 = new Uint8List(ob8a.lengthInBytes);
      expect(bytes0, equals(pixels0));
    });

    test('Create Uncompressed FrameList8Bit MultiFrame', () {
      int nFrames1;
      const photometricInterpretation1 = 'MONOCHROME2';
      const rows5 = 5;
      const columns7 = 7;

      final ob8FDb = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation1,
          rows5,
          columns7,
          bitsAllocated8,
          bitsStored8,
          highBit8,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      // Multi frame
      // Frames of values 2, 4, 6 ...
      for (var i = 1; i <= 10; i++) {
        nFrames1 = i * 2;
        log.debug('nFrames:$nFrames1');
        final pixels1 = new Uint8List(nFrames1 * (ob8FDb.lengthInBytes));

        final ob8b = new FrameList8Bit(pixels1, nFrames1, ob8FDb);

        // pixels
        expect(ob8b.pixels is Uint8List, true);
        expect(ob8b.pixels.length == pixels1.length, true);
        expect(ob8b.pixels == pixels1, true);
        expect(ob8b.pixels.lengthInBytes == pixels1.lengthInBytes, true);
        expect(ob8b.pixelSizeInBits == ob8FDb.pixelSizeInBits, true);

        //  bulkdata
        expect(ob8b.bulkdata.length == pixels1.lengthInBytes, true);
        expect(ob8b.bulkdata.length == ob8b.bulkdata.lengthInBytes, true);
        expect(ob8b.pixels.lengthInBytes == ob8b.bulkdata.length, true);

        // nFrames
        expect(ob8b.length == nFrames1, true);
        expect(ob8b.nFrames == nFrames1, true);

        // frameLength
        expect(ob8b.frameLength == rows5 * columns7, true);
        expect(ob8b.lengthInBytes == pixels1.lengthInBytes, true);
        expect(ob8b.lengthInBytes == ob8FDb.lengthInBytes * nFrames1, true);
        expect(ob8b.lengthInBytes == ob8b.pixels.lengthInBytes, true);
        expect(ob8b.lengthInBytes == ob8b.bulkdata.lengthInBytes, true);

        // validity
        expect(ob8b.isValid, true);

        // FrameDescriptor values
        // transferSyntax
        expect(ob8b.ts == ts0, true);
        expect(ob8b.isCompressed, false);
        expect(ob8b.isEncapsulated, false);

        // other FrameDescriptor fields
        expect(ob8b.samplesPerPixel == samplesPerPixel0, true);
        expect(
            ob8b.photometricInterpretation == photometricInterpretation1, true);
        expect(ob8b.rows == rows5, true);
        expect(ob8b.columns == columns7, true);
        expect(ob8b.bitsAllocated == bitsAllocated8, true);
        expect(ob8b.bitsStored == bitsStored8, true);
        expect(ob8b.highBit == highBit8, true);
        expect(ob8b.pixelRepresentation == pixelRepresentation0, true);
        expect(ob8b.planarConfiguration, isNull);
        expect(ob8b.pixelAspectRatio == pixelAspectRatio0, true);

        // FrameDescriptor
        expect(ob8FDb.ts == ts0, true);
        expect(ob8FDb.samplesPerPixel == samplesPerPixel0, true);
        expect(ob8FDb.photometricInterpretation == photometricInterpretation1,
            true);
        expect(ob8FDb.rows == rows5, true);
        expect(ob8FDb.columns == columns7, true);
        expect(ob8FDb.length == rows5 * columns7, true);
        expect(ob8FDb.bitsAllocated == bitsAllocated8, true);
        expect(ob8FDb.bitsStored == bitsStored8, true);
        expect(ob8FDb.highBit == highBit8, true);
        expect(ob8FDb.pixelRepresentation == pixelRepresentation0, true);
        expect(ob8FDb.planarConfiguration == planarConfiguration0, true);
        expect(ob8FDb.pixelAspectRatio == pixelAspectRatio0, true);
        expect(
            ob8FDb.lengthInBits == (rows5 * columns7) * bitsAllocated8, true);
        expect(ob8FDb.pixelSizeInBits == bitsAllocated8, true);
        expect(ob8FDb.length == rows5 * columns7, true);

        final bytes1 = new Uint8List(ob8b.lengthInBytes);
        expect(bytes1, equals(pixels1));
      }
    });

    test('Invalid FrameList8Bit data test', () {
      //nFrames = 0 (Invalid Frames)
      const nFrames0 = 0;
      const photometricInterpretation1 = 'MONOCHROME3';

      final ob8FDc = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation1,
          rows4,
          columns6,
          bitsAllocated8,
          bitsStored8,
          highBit8,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final pixels0 = new Uint8List(ob8FDc.lengthInBytes);

      log
        ..debug('pixels0.length: ${pixels0.lengthInBytes}')
        ..debug('nFrames: $nFrames0')
        ..debug('pixelSize bits: ${ob8FDc.pixelSizeInBits}')
        ..debug('pixelSize bytes: ${ob8FDc.pixelSizeInBytes}');

      system.throwOnError = true;
      expect(() => new FrameList8Bit(pixels0, nFrames0, ob8FDc),
          throwsA(const isInstanceOf<InvalidFrameListError>()));

      //Invalid Pixels [== 0]
      const nFrames1 = 1;
      const photometricInterpretation2 = 'MONOCHROME3';

      final ob8FDd = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation2,
          rows4,
          columns6,
          bitsAllocated8,
          bitsStored8,
          highBit8,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final pixels1 = new Uint8List(0);
      log
        ..debug('pixels0.length: ${pixels1.lengthInBytes}')
        ..debug('nFrames: $nFrames1')
        ..debug('pixelSize bits: ${ob8FDd.pixelSizeInBits}')
        ..debug('pixelSize bytes: ${ob8FDd.pixelSizeInBytes}');
      expect(() => new FrameList8Bit(pixels1, nFrames1, ob8FDd),
          throwsA(const isInstanceOf<InvalidFrameListError>()));

      const nFrames2 = 2;
      const photometricInterpretation3 = 'MONOCHROME3';

      // Invalid FrameDescriptor Data
      final ob8FDe = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation3,
          rows4,
          columns6,
          bitsAllocated8,
          bitsStored8,
          highBit8,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final pixels2 = new Uint8List(ob8FDe.lengthInBytes);
      log
        ..debug('pixels0.length: ${pixels2.lengthInBytes}')
        ..debug('nFrames: $nFrames2')
        ..debug('pixelSize bits: ${ob8FDe.pixelSizeInBits}')
        ..debug('pixelSize bytes: ${ob8FDe.pixelSizeInBytes}');
      expect(() => new FrameList8Bit(pixels2, nFrames2, ob8FDe),
          throwsA(const isInstanceOf<InvalidFrameListError>()));
    });

    test('Create Uncompressed FrameList8Bit (FrameDescriptor.fromDataset)', () {
      //Frame Descriptor.fromDataSet1
      final ts = TransferSyntax.kExplicitVRLittleEndian;
      final uiTransferSyntaxUID0 =
          new UItag.fromStrings(PTag.kTransferSyntaxUID, [ts.asString]);
      final usSamplesPerPixel0 = new UStag(PTag.kSamplesPerPixel, [1]);
      final csPhotometricInterpretation0 =
          new CStag(PTag.kPhotometricInterpretation, ['PJZ7YG5']);
      final usRows0 = new UStag(PTag.kRows, [3]);
      final usColumns0 = new UStag(PTag.kColumns, [6]);
      final usBitsAllocated0 = new UStag(PTag.kBitsAllocated, [8]);
      final usBitsStored0 = new UStag(PTag.kBitsStored, [8]);
      final usHighBit0 = new UStag(PTag.kHighBit, [7]);
      final usPixelRepresentation0 = new UStag(PTag.kPixelRepresentation, [3]);
      final usPlanarConfiguration0 = new UStag(PTag.kPlanarConfiguration, [5]);
      final isPixelAspectRatio0 = new IStag(PTag.kPixelAspectRatio, ['1', '2']);
      final pixelAspectRatioValue0 = 1 / 2;
      final usSmallestImagePixelValue0 =
          new UStag(PTag.kSmallestImagePixelValue, [0]);
      final usLargestImagePixelValue0 =
          new UStag(PTag.kLargestImagePixelValue, [255]);
      final obIccProfile0 = new OBtag(PTag.kICCProfile, <int>[], 0);
      final csColorSpace0 = new CStag(PTag.kColorSpace);
      final usPixelPaddingRangeLimit0 = new UStag(PTag.kPixelPaddingRangeLimit);

      final rds0 = new TagRootDataset.empty()
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
        ..add(usPixelPaddingRangeLimit0);

      final ob8FDe = new FrameDescriptor.fromDataset(rds0);

      final nFrames0 = 1;
      final pixels0 = new Uint8List(ob8FDe.lengthInBytes);

      final ob8d = new FrameList8Bit(pixels0, nFrames0, ob8FDe);

      // pixels
      expect(ob8d.samplesPerPixel == ob8FDe.samplesPerPixel, true);
      expect(ob8d.pixels.length == pixels0.length, true);
      expect(ob8d.pixels.lengthInBytes == pixels0.lengthInBytes, true);
      expect(ob8d.pixelSizeInBytes == pixels0.elementSizeInBytes, true);
      expect(ob8d.pixelSizeInBits == ob8FDe.pixelSizeInBits, true);
      expect(ob8d.pixels is Uint8List, true);

      // nFrames
      expect(ob8d.length == nFrames0, true);
      expect(ob8d.nFrames == nFrames0, true);

      // frameLength
      expect(ob8d.frameLength == ob8FDe.length, true);
      expect(ob8d.lengthInBytes == ob8d.pixels.lengthInBytes, true);
      expect(ob8d.lengthInBytes == ob8d.bulkdata.lengthInBytes, true);

      // validity
      expect(ob8d.isValid, true);

      // FrameDescriptor.FromDataSET values
      // transferSyntax
      expect(ob8d.ts == ob8FDe.ts, true);
      expect(ob8d.isCompressed, false);
      expect(ob8d.isEncapsulated, false);

      // other FrameDescriptor.FromDataSet fields
      expect(ob8d.rows == ob8FDe.rows, true);
      expect(ob8d.columns == ob8FDe.columns, true);
      expect(ob8d.photometricInterpretation == ob8FDe.photometricInterpretation,
          true);
      expect(ob8d.bitsAllocated == ob8FDe.bitsAllocated, true);
      expect(ob8d.bitsStored == ob8FDe.bitsStored, true);
      expect(ob8d.highBit == ob8FDe.highBit, true);
      expect(ob8d.pixelRepresentation == ob8FDe.pixelRepresentation, true);
      expect(ob8d.planarConfiguration == ob8FDe.planarConfiguration, true);
      expect(ob8d.pixelAspectRatio == pixelAspectRatioValue0, true);
      expect(ob8d.pixelSizeInBits == ob8FDe.pixelSizeInBits, true);
      expect(ob8d.frameLength == ob8FDe.length, true);
      expect(ob8d.desc.lengthInBytes == ob8FDe.lengthInBytes * nFrames0, true);

      expect(ob8FDe.smallestImagePixelValue == 0, true);
      expect(ob8FDe.largestImagePixelValue == 255, true);
      expect(ob8FDe.largestImagePixelValue >> usBitsStored0.value == 0, true);
      expect(ob8FDe.redLUTDescriptor, null);
      expect(ob8FDe.greenLUTDescriptor, null);
      expect(ob8FDe.blueLUTDescriptor, null);
      expect(ob8FDe.alphaLUTDescriptor, null);
      expect(ob8FDe.redLUTData, null);
      expect(ob8FDe.greenLUTData, null);
      expect(ob8FDe.blueLUTData, null);
      expect(ob8FDe.alphaLUTData, null);
      expect(ob8FDe.iccProfile, null);
      expect(ob8FDe.colorSpace, null);
      expect(ob8FDe.pixelPaddingRangeLimit, null);

      // FrameDescriptor(fromDataSet)
      expect(ob8FDe.ts == ts, true);
      expect(ob8FDe.samplesPerPixel, equals(usSamplesPerPixel0.value));
      expect(ob8FDe.photometricInterpretation,
          equals(csPhotometricInterpretation0.value));
      expect(ob8FDe.rows, equals(usRows0.value));
      expect(ob8FDe.columns, equals(usColumns0.value));
      expect(ob8FDe.bitsAllocated, equals(usBitsAllocated0.value));
      expect(ob8FDe.bitsStored, equals(usBitsStored0.value));
      expect(ob8FDe.highBit, equals(usHighBit0.value));
      expect(ob8FDe.pixelRepresentation, equals(usPixelRepresentation0.value));
      expect(ob8FDe.planarConfiguration, equals(usPlanarConfiguration0.value));
      expect(ob8FDe.pixelAspectRatio, equals(pixelAspectRatioValue0));
      expect(ob8FDe.smallestImagePixelValue == 0, true);
      expect(ob8FDe.largestImagePixelValue == 255, true);
      expect(ob8FDe.largestImagePixelValue >> usBitsStored0.value == 0, true);
    });

    test('FrameList8Bit operator []', () {
      int nFrames0;
      const photometricInterpretation0 = 'MONOCHROME1';

      final ob8FDf = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation0,
          rows4,
          columns6,
          bitsAllocated8,
          bitsStored8,
          highBit8,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      FrameList8Bit ob8e;

      //Frames ranging from 1 to 10
      for (var i = 0; i < 10; i++) {
        nFrames0 = i + 1;
        log.debug('nFrames0: $nFrames0');
        final pixels0 = new Uint8List(nFrames0 * (ob8FDf.lengthInBytes));
        ob8e = new FrameList8Bit(pixels0, nFrames0, ob8FDf);
        for (var j = 0; j < nFrames0; j++) {
          final frame0 = ob8e[j];
          expect(frame0.index == j, true);

          expect(frame0.lengthInBytes * nFrames0 == ob8e.lengthInBytes, true);
          expect(frame0.length == ob8e.desc.length, true);
          expect(frame0.lengthInBytes == ob8e.desc.lengthInBytes, true);
          expect(frame0.ts == ob8e.desc.ts, true);
          expect(frame0.samplesPerPixel == ob8e.desc.samplesPerPixel, true);
          expect(frame0.rows == ob8e.desc.rows, true);
          expect(frame0.columns == ob8e.desc.columns, true);
          expect(frame0.bitsAllocated == ob8e.desc.bitsAllocated, true);
          expect(frame0.bitsStored == ob8e.desc.bitsStored, true);
          expect(frame0.highBit == ob8e.desc.highBit, true);
          expect(frame0.pixelRepresentation == ob8e.desc.pixelRepresentation,
              true);
          expect(frame0.planarConfiguration == ob8e.desc.planarConfiguration,
              true);
          expect(frame0.pixelAspectRatio == ob8e.desc.pixelAspectRatio, true);
          expect(frame0.parent == ob8e, true);
          expect(frame0.length == ob8e.frameLength, true);
        }
      }

      log.debug('nFrames0: $nFrames0, Frames in FrameList: ${ob8e.nFrames}');
      expect(() => ob8e[nFrames0], throwsA(const isInstanceOf<RangeError>()));
    });
  });

  // CompressedFrameList
  group('CompressedFrameList', () {
    const ts0 = TransferSyntax.kExplicitVRLittleEndian;
    const samplesPerPixel0 = 1;
    const rows4 = 4;
    const columns6 = 6;
    const bitsAllocated8 = 8;
    const bitsStored8 = 8;
    const highBit8 = 7;
    const pixelRepresentation0 = 0;
    const int planarConfiguration0 = null;
    const pixelAspectRatio0 = 1.0;

    test('CompressedFrameList singleFrame', () {
      const photometricInterpretation0 = 'MONOCHROME1';
      const nFrames0 = 1;

      final c8FDa = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation0,
          rows4,
          columns6,
          bitsAllocated8,
          bitsStored8,
          highBit8,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final offsets = new Uint32List.fromList([0, 4]);
      final bulkdata = new Uint8List(4);

      log.debug('offsets.length: ${offsets.length}');

      final c8a = new CompressedFrameList(bulkdata, offsets, nFrames0, c8FDa);
      log.debug(c8a);

      expect(c8a.pixelSizeInBits == c8FDa.pixelSizeInBits, true);

      // nFrames
      expect(c8a.length == nFrames0, true);
      expect(c8a.nFrames == nFrames0, true);

      // frameLength
      expect(c8a.frameLength == rows4 * columns6, true);
      expect(c8a.lengthInBytes == c8FDa.lengthInBytes * nFrames0, false);

      // validity
      expect(c8a.isCompressed, true);
      expect(c8a.isEncapsulated, true);

      // FrameDescriptor values
      // transferSyntax
      expect(c8a.ts == ts0, true);
      expect(c8a.samplesPerPixel == samplesPerPixel0, true);
      expect(c8a.photometricInterpretation == photometricInterpretation0, true);
      expect(c8a.rows == rows4, true);
      expect(c8a.columns == columns6, true);
      expect(c8a.bitsAllocated == bitsAllocated8, true);
      expect(c8a.bitsStored == bitsStored8, true);
      expect(c8a.highBit == highBit8, true);
      expect(c8a.pixelRepresentation == pixelRepresentation0, true);
      expect(c8a.planarConfiguration, isNull);
      expect(c8a.pixelAspectRatio == pixelAspectRatio0, true);
      expect(c8a.frameLength == rows4 * columns6, true);

      // FrameDescriptor
      expect(c8FDa.ts == ts0, true);
      expect(c8FDa.samplesPerPixel == samplesPerPixel0, true);
      expect(
          c8FDa.photometricInterpretation == photometricInterpretation0, true);
      expect(c8FDa.rows == rows4, true);
      expect(c8FDa.columns == columns6, true);
      expect(c8FDa.length == rows4 * columns6, true);
      expect(c8FDa.bitsAllocated == bitsAllocated8, true);
      expect(c8FDa.bitsStored == bitsStored8, true);
      expect(c8FDa.highBit == highBit8, true);
      expect(c8FDa.pixelRepresentation == pixelRepresentation0, true);
      expect(c8FDa.planarConfiguration == planarConfiguration0, true);
      expect(c8FDa.pixelAspectRatio == pixelAspectRatio0, true);
      expect(c8FDa.lengthInBits == (rows4 * columns6) * bitsAllocated8, true);
      expect(c8FDa.pixelSizeInBits == bitsAllocated8, true);
      expect(c8FDa.length == rows4 * columns6, true);

      final bytes0 = new Uint8List(c8a.lengthInBytes);
      expect(bytes0, equals(bulkdata));
    });

    test('CompressedFrameList MulitFrame', () {
      const photometricInterpretation1 = 'MONOCHROME2';
      int nFrames1;

      final c8FDb = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation1,
          rows4,
          columns6,
          bitsAllocated8,
          bitsStored8,
          highBit8,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      var offSetList = <int>[];

      for (var i = 1; i <= 10; i++) {
        nFrames1 = i * 2;
        offSetList.add(0);
        for (var j = 1; j <= nFrames1; j++) {
          offSetList.add(j * 2);
        }
        log.debug('nFrames:$nFrames1');
        final offSets = new Uint32List.fromList(offSetList);
        final bulkdata = new Uint8List(i * 4);

        log.debug(
            'offSetList: $offSetList, nFrames1 + 1: ${nFrames1 + 1}, offSets: ${offSets.length}');

        final c8b = new CompressedFrameList(bulkdata, offSets, nFrames1, c8FDb);
        log.debug(c8b);

        expect(c8b.pixelSizeInBits == c8FDb.pixelSizeInBits, true);

        // nFrames
        expect(c8b.length == nFrames1, true);
        expect(c8b.nFrames == nFrames1, true);

        // frameLength
        expect(c8b.frameLength == rows4 * columns6, true);
        expect(c8b.lengthInBytes == c8FDb.lengthInBytes * nFrames1, false);

        // validity
        expect(c8b.isCompressed, true);
        expect(c8b.isEncapsulated, true);

        // FrameDescriptor values
        // transferSyntax
        expect(c8b.ts == ts0, true);
        expect(c8b.samplesPerPixel == samplesPerPixel0, true);
        expect(
            c8b.photometricInterpretation == photometricInterpretation1, true);
        expect(c8b.rows == rows4, true);
        expect(c8b.columns == columns6, true);
        expect(c8b.bitsAllocated == bitsAllocated8, true);
        expect(c8b.bitsStored == bitsStored8, true);
        expect(c8b.highBit == highBit8, true);
        expect(c8b.pixelRepresentation == pixelRepresentation0, true);
        expect(c8b.planarConfiguration, isNull);
        expect(c8b.pixelAspectRatio == pixelAspectRatio0, true);
        expect(c8b.frameLength == rows4 * columns6, true);

        // FrameDescriptor
        expect(c8FDb.ts == ts0, true);
        expect(c8FDb.samplesPerPixel == samplesPerPixel0, true);
        expect(c8FDb.photometricInterpretation == photometricInterpretation1,
            true);
        expect(c8FDb.rows == rows4, true);
        expect(c8FDb.columns == columns6, true);
        expect(c8FDb.length == rows4 * columns6, true);
        expect(c8FDb.bitsAllocated == bitsAllocated8, true);
        expect(c8FDb.bitsStored == bitsStored8, true);
        expect(c8FDb.highBit == highBit8, true);
        expect(c8FDb.pixelRepresentation == pixelRepresentation0, true);
        expect(c8FDb.planarConfiguration == planarConfiguration0, true);
        expect(c8FDb.pixelAspectRatio == pixelAspectRatio0, true);
        expect(c8FDb.lengthInBits == (rows4 * columns6) * bitsAllocated8, true);
        expect(c8FDb.pixelSizeInBits == bitsAllocated8, true);
        expect(c8FDb.length == rows4 * columns6, true);

        final bytes0 = new Uint8List(c8b.lengthInBytes);
        expect(bytes0, equals(bulkdata));

        offSetList = <int>[];
      }
    });

    test('Invalid CompressedFrameList', () {
      //nFrames = 0
      const nFrames0 = 0;
      const photometricInterpretation0 = 'MONOCHROME1';

      final c8FDc = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation0,
          rows4,
          columns6,
          bitsAllocated8,
          bitsStored8,
          highBit8,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final offsets0 = new Uint32List(0);
      final bulkdata0 = new Uint8List(0);

      log.debug('nFrames: $nFrames0');
      expect(
          () => new CompressedFrameList(bulkdata0, offsets0, nFrames0, c8FDc),
          throwsA(const isInstanceOf<InvalidFrameListError>()));

      // Invalid offsets and bulkdata
      const nFrames1 = 1;
      const photometricInterpretation1 = 'MONOCHROME2';

      final c8FDd = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation1,
          rows4,
          columns6,
          bitsAllocated8,
          bitsStored8,
          highBit8,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final offSets = new Uint32List(0);
      final bulkData = new Uint8List(0);

      log..debug('offSets: $offSets')..debug('bulkData: $bulkData');
      expect(() => new CompressedFrameList(bulkData, offSets, nFrames1, c8FDd),
          throwsA(const isInstanceOf<InvalidFrameListError>()));

      // Invalid FrameDescriptor data
      const photometricInterpretation2 = 'MONOCHROME3';
      const nFrames2 = 1;

      final c8FDe = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation2,
          rows4,
          columns6,
          bitsAllocated8,
          bitsStored8,
          highBit8,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final offsets2 = new Uint32List.fromList([0, 4]);
      final bulkdata2 = new Uint8List(0);

      expect(
          () => new CompressedFrameList(bulkdata2, offsets2, nFrames2, c8FDe),
          throwsA(const isInstanceOf<InvalidFrameListError>()));

      // Invalid Offsets
      final offSets3 = new Uint32List.fromList([0, 2, 4, 3, 8, 9, 10]);
      final bulkdata = new Uint8List(10);
      log.debug('offSets3: $offSets3');
      expect(() => new CompressedFrameList(bulkdata, offSets3, nFrames1, c8FDe),
          throwsA(const isInstanceOf<InvalidFrameListError>()));
    });

    test('CompressedFrameList.fromVFFragments', () {
      const nFrames0 = 1;
      const photometricInterpretation1 = 'MONOCHROME1';

      final cFDb = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation1,
          rows4,
          columns6,
          bitsAllocated8,
          bitsStored8,
          highBit8,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final offsets = new Uint32List.fromList([0, 4]);
      final emptyOffsetsAsBytes1 = offsets.buffer.asUint8List();
      final bulkData = new Uint8List(4);
      final fragments = [emptyOffsetsAsBytes1, bulkData];
      final vfFragments = new VFFragments(fragments);

      final c8c =
          new CompressedFrameList.fromVFFragments(vfFragments, nFrames0, cFDb);

      expect(c8c.pixelSizeInBits == cFDb.pixelSizeInBits, true);

      // nFrames
      expect(c8c.length == nFrames0, true);
      expect(c8c.nFrames == nFrames0, true);

      // frameLength
      expect(c8c.frameLength == rows4 * columns6, true);

      expect(c8c.lengthInBytes == c8c.bulkdata.lengthInBytes, true);

      // validity
      expect(c8c.isCompressed, true);
      expect(c8c.isEncapsulated, true);

      // FrameDescriptor values
      // transferSyntax
      expect(c8c.ts == ts0, true);
      expect(c8c.samplesPerPixel == samplesPerPixel0, true);
      expect(c8c.photometricInterpretation == photometricInterpretation1, true);
      expect(c8c.rows == rows4, true);
      expect(c8c.columns == columns6, true);
      expect(c8c.bitsAllocated == bitsAllocated8, true);
      expect(c8c.bitsStored == bitsStored8, true);
      expect(c8c.highBit == highBit8, true);
      expect(c8c.pixelRepresentation == pixelRepresentation0, true);
      expect(c8c.planarConfiguration, isNull);
      expect(c8c.pixelAspectRatio == pixelAspectRatio0, true);
      expect(c8c.frameLength == rows4 * columns6, true);

      // FrameDescriptor
      expect(cFDb.ts == ts0, true);
      expect(cFDb.samplesPerPixel == samplesPerPixel0, true);
      expect(
          cFDb.photometricInterpretation == photometricInterpretation1, true);
      expect(cFDb.rows == rows4, true);
      expect(cFDb.columns == columns6, true);
      expect(cFDb.length == rows4 * columns6, true);
      expect(cFDb.bitsAllocated == bitsAllocated8, true);
      expect(cFDb.bitsStored == bitsStored8, true);
      expect(cFDb.highBit == highBit8, true);
      expect(cFDb.pixelRepresentation == pixelRepresentation0, true);
      expect(cFDb.planarConfiguration == planarConfiguration0, true);
      expect(cFDb.pixelAspectRatio == pixelAspectRatio0, true);
      expect(cFDb.lengthInBits == (rows4 * columns6) * bitsAllocated8, true);
      expect(cFDb.pixelSizeInBits == bitsAllocated8, true);
      expect(cFDb.length == rows4 * columns6, true);

      final bytes0 = new Uint8List(c8c.lengthInBytes);
      log.debug(bytes0);
    });
    test('CompressedFrameList.fromVFFragments multiFrame', () {
      int nFrames1;
      const photometricInterpretation2 = 'MONOCHROME2';

      final cFDc = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation2,
          rows4,
          columns6,
          bitsAllocated8,
          bitsStored8,
          highBit8,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      var offSetList = <int>[];

      for (var i = 1; i <= 10; i++) {
        nFrames1 = i * 2;
        offSetList.add(0);
        for (var j = 1; j <= nFrames1; j++) {
          offSetList.add(j * 2);
        }

        final offsets = new Uint32List.fromList(offSetList);
        final emptyOffsetsAsBytes1 = offsets.buffer.asUint8List();
        final bulkData = new Uint8List(i * 4);
        final fragments = [emptyOffsetsAsBytes1, bulkData];
        log.debug(
            'offSetList: $offSetList, nFrames + 1: ${nFrames1 + 1}, offSets: ${offsets.length}');
        final vfFragments = new VFFragments(fragments);

        final c8d = new CompressedFrameList.fromVFFragments(
            vfFragments, nFrames1, cFDc);

        expect(c8d.pixelSizeInBits == cFDc.pixelSizeInBits, true);

        // nFrames
        expect(c8d.length == nFrames1, true);
        expect(c8d.nFrames == nFrames1, true);

        // frameLength
        expect(c8d.frameLength == rows4 * columns6, true);
        expect(c8d.lengthInBytes == cFDc.lengthInBytes * nFrames1, false);
        expect(c8d.lengthInBytes == c8d.bulkdata.lengthInBytes, true);

        // validity
        expect(c8d.isCompressed, true);
        expect(c8d.isEncapsulated, true);

        // FrameDescriptor values
        // transferSyntax
        expect(c8d.ts == ts0, true);
        expect(c8d.samplesPerPixel == samplesPerPixel0, true);
        expect(
            c8d.photometricInterpretation == photometricInterpretation2, true);
        expect(c8d.rows == rows4, true);
        expect(c8d.columns == columns6, true);
        expect(c8d.bitsAllocated == bitsAllocated8, true);
        expect(c8d.bitsStored == bitsStored8, true);
        expect(c8d.highBit == highBit8, true);
        expect(c8d.pixelRepresentation == pixelRepresentation0, true);
        expect(c8d.planarConfiguration, isNull);
        expect(c8d.pixelAspectRatio == pixelAspectRatio0, true);
        expect(c8d.frameLength == rows4 * columns6, true);

        // FrameDescriptor
        expect(cFDc.ts == ts0, true);
        expect(cFDc.samplesPerPixel == samplesPerPixel0, true);
        expect(
            cFDc.photometricInterpretation == photometricInterpretation2, true);
        expect(cFDc.rows == rows4, true);
        expect(cFDc.columns == columns6, true);
        expect(cFDc.length == rows4 * columns6, true);
        expect(cFDc.bitsAllocated == bitsAllocated8, true);
        expect(cFDc.bitsStored == bitsStored8, true);
        expect(cFDc.highBit == highBit8, true);
        expect(cFDc.pixelRepresentation == pixelRepresentation0, true);
        expect(cFDc.planarConfiguration == planarConfiguration0, true);
        expect(cFDc.pixelAspectRatio == pixelAspectRatio0, true);
        expect(cFDc.lengthInBits == (rows4 * columns6) * bitsAllocated8, true);
        expect(cFDc.pixelSizeInBits == bitsAllocated8, true);
        expect(cFDc.length == rows4 * columns6, true);

        offSetList = <int>[];
        final bytes0 = new Uint8List(c8d.lengthInBytes);
        log.debug(bytes0);
      }
    });

    test('Invalid CompressedVFFragments', () {
      //nFrames = 0 (Invalid frames)
      const nFrames0 = 0;
      const photometricInterpretation0 = 'MONOCHROME1';

      final cFDb = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation0,
          rows4,
          columns6,
          bitsAllocated8,
          bitsStored8,
          highBit8,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final bulkData0 = new Uint8List(4);
      final fragments0 = [bulkData0];
      final vfFragments0 = new VFFragments(fragments0);

      expect(
          () => new CompressedFrameList.fromVFFragments(
              vfFragments0, nFrames0, cFDb),
          throwsA(const isInstanceOf<InvalidFrameListError>()));

      // Invalid offset
      const nFrames1 = 1;
      const photometricInterpretation1 = 'MONOCHROME2';

      final cFDc = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation1,
          rows4,
          columns6,
          bitsAllocated8,
          bitsStored8,
          highBit8,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final emptyOffsets = new Uint32List(0);
      final emptyOffsetsAsBytes = emptyOffsets.buffer.asUint8List();
      final bulkData1 = new Uint8List(4);
      final fragments1 = [emptyOffsetsAsBytes, bulkData1];
      final vfFragments1 = new VFFragments(fragments1);

      expect(
          () => new CompressedFrameList.fromVFFragments(
              vfFragments1, nFrames1, cFDc),
          throwsA(const isInstanceOf<InvalidFrameListError>()));

      // Invalid FrameDescriptor values
      const nFrames2 = 1;
      const photometricInterpretation2 = 'MONOCHROME1';

      final cFDd = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation2,
          rows4,
          columns6,
          bitsAllocated8,
          bitsStored8,
          highBit8,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      final emptyOffsets1 = new Uint32List(2);
      final emptyOffsetsAsBytes1 = emptyOffsets1.buffer.asUint8List();
      final bulkData2 = new Uint8List(4);
      final fragments2 = [emptyOffsetsAsBytes1, bulkData2];
      final vfFragments2 = new VFFragments(fragments2);

      expect(
          () => new CompressedFrameList.fromVFFragments(
              vfFragments2, nFrames2, cFDd),
          throwsA(const isInstanceOf<InvalidFrameListError>()));
    });

    test('CompressedFrameList operator []', () {
      const photometricInterpretation0 = 'MONOCHROME1';
      int nFrames0;

      final c8FDg = new FrameDescriptor(
          ts0,
          samplesPerPixel0,
          photometricInterpretation0,
          rows4,
          columns6,
          bitsAllocated8,
          bitsStored8,
          highBit8,
          pixelRepresentation0,
          planarConfiguration0,
          pixelAspectRatio: pixelAspectRatio0);

      nFrames0 = 7;
      log.debug('nFrames0: $nFrames0');
      final offsets = new Uint32List.fromList([0, 2, 3, 5, 8, 13, 21, 34]);
      final bulkdata = new Uint8List(34);

      final c8c = new CompressedFrameList(bulkdata, offsets, nFrames0, c8FDg);

      for (var j = 0; j < nFrames0; j++) {
        final frame0 = c8c[j];
        expect(frame0.index == j, true);

        log.debug(
            'frame0.lengthInBytes: ${frame0.lengthInBytes}, c8c.offsets[${j+ 1}] - c8c.offsets[$j]: ${c8c.offsets[j+ 1] - c8c.offsets[j]}');

        expect(
            frame0.lengthInBytes == c8c.offsets[j + 1] - c8c.offsets[j], true);
        expect(frame0.length == c8c.offsets[j + 1] - c8c.offsets[j], true);
        //expect(frame0.length == c8c.desc.length, true);

        expect(frame0.ts == c8c.desc.ts, true);
        expect(frame0.samplesPerPixel == c8c.desc.samplesPerPixel, true);
        expect(frame0.rows == c8c.desc.rows, true);
        expect(frame0.columns == c8c.desc.columns, true);
        expect(frame0.bitsAllocated == c8c.desc.bitsAllocated, true);
        expect(frame0.bitsStored == c8c.desc.bitsStored, true);
        expect(frame0.highBit == c8c.desc.highBit, true);
        expect(
            frame0.pixelRepresentation == c8c.desc.pixelRepresentation, true);
        expect(
            frame0.planarConfiguration == c8c.desc.planarConfiguration, true);
        expect(frame0.pixelAspectRatio == c8c.desc.pixelAspectRatio, true);

        expect(frame0.parent == c8c, true);
      }

      log.debug('nFrames0: $nFrames0, Frames in FrameList: ${c8c.nFrames}');
      expect(() => c8c[nFrames0], throwsA(const isInstanceOf<RangeError>()));
    });
  });
}
