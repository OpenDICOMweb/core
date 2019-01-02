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
import 'package:core/src/values/vf_fragments.dart';

import 'test_pixel_data.dart';

final Uint8List frame = Uint8List.fromList(testFrame);

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
      const length0 = 1;
      const photometricInterpretation0 = 'MONOCHROME1';

      final ob1FDa = FrameDescriptor(
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

      final pixels0 = Uint8List(ob1FDa.lengthInBytes);

      final ob1FLa = FrameList1Bit(pixels0, length0, ob1FDa);

      // pixels
      expect(ob1FLa.pixels is Uint8List, true);
      expect(ob1FLa.pixels.length == pixels0.length, true);
      expect(ob1FLa.pixels.lengthInBytes == pixels0.lengthInBytes, true);
      log
        ..debug('ob1BitFrames0.pixelSizeInBits: ${ob1FLa.pixelSizeInBits}')
        ..debug('pixels0.elementSizeInBytes: ${pixels0.elementSizeInBytes}');
      expect(ob1FLa.pixelSizeInBits == pixels0.elementSizeInBytes, true);
      expect(ob1FLa.pixelSizeInBytes == 0, true);

      global.throwOnError = true;
      // bulkdata
      expect(ob1FLa.bulkdata.length == pixels0.lengthInBytes, true);
      expect(ob1FLa.bulkdata.length == ob1FLa.bulkdata.lengthInBytes, true);
      expect(ob1FLa.pixels.lengthInBytes == ob1FLa.bulkdata.length, true);
      expect(ob1FLa.pixels == pixels0, true);

      // length
      expect(ob1FLa.length == 1, true);

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

      final bytes0 = Uint8List(ob1FLa.lengthInBytes);
      expect(bytes0, equals(pixels0));
    });

    test('Create Uncompressed FrameList1Bit MultiFrame', () {
      int length0;
      const photometricInterpretation0 = 'MONOCHROME2';

      final ob1FDb = FrameDescriptor(
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
        length0 = i * 2;
        log.debug('length0: $length0');
        final pixels1 = Uint8List(length0 * (ob1FDb.lengthInBytes));
        final ob1FLb = FrameList1Bit(pixels1, length0, ob1FDb);

        // pixels
        expect(ob1FLb.pixels is Uint8List, true);
        expect(ob1FLb.pixels.length == pixels1.length, true);
        expect(ob1FLb.pixels.lengthInBytes == pixels1.lengthInBytes, true);
        expect(ob1FLb.pixels == pixels1, true);
        expect(ob1FLb.pixelSizeInBytes, 0);

        // bulkdata
        expect(ob1FLb.bulkdata.length == pixels1.lengthInBytes, true);
        expect(ob1FLb.bulkdata.length == ob1FLb.bulkdata.lengthInBytes, true);
        expect(ob1FLb.pixels.lengthInBytes == ob1FLb.bulkdata.length, true);

        // nFrames
        expect(ob1FLb.length == length0, true);

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

        final bytes1 = Uint8List(ob1FLb.lengthInBytes);
        expect(bytes1, equals(pixels1));
      }
    });

    test('Invalid FrameList1Bit data test', () {
      //nFrames = 0 (Invalid number of Frames)
      const length0 = 0;
      const photometricInterpretation1 = 'MONOCHROME3';

      final ob1FDc = FrameDescriptor(
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

      final pixels3 = Uint8List(ob1FDc.lengthInBytes);

      global.throwOnError = true;
      log.debug('nFrames: $length0');
      expect(() => FrameList1Bit(pixels3, length0, ob1FDc),
          throwsA(const TypeMatcher<InvalidFrameListError>()));

      // Invalid Pixels [== 0]
      const nFrames1 = 1;
      const photometricInterpretation0 = 'MONOCHROME3';

      final ob1FDd = FrameDescriptor(
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

      final pixels4 = Uint8List(0);

      log
        ..debug('pixels4.lengthInBytes: ${pixels4.lengthInBytes}')
        ..debug('nFrames: $nFrames1');

      expect(() => FrameList1Bit(pixels4, nFrames1, ob1FDd),
          throwsA(const TypeMatcher<InvalidFrameListError>()));

      // Invalid FrameDescriptor data
      const nFrames2 = 2;
      const photometricInterpretation2 = 'MONOCHROME3';

      final ob1FDe = FrameDescriptor(
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

      final pixels5 = Uint8List(ob1FDe.lengthInBytes);

      log
        ..debug('pixels5.lengthInBytes: ${pixels5.lengthInBytes}')
        ..debug('nFrames: $nFrames2')
        ..debug('pixelSize bits: ${ob1FDe.pixelSizeInBits}')
        ..debug('pixelSize bytes: ${ob1FDe.pixelSizeInBytes}');

      expect(() => FrameList1Bit(pixels5, nFrames2, ob1FDe),
          throwsA(const TypeMatcher<InvalidFrameListError>()));
    });

    test('Create Uncompressed FrameList1Bit (FrameDescriptor.fromDataset)', () {
      global.throwOnError = false;

      //Frame Descriptor.fromDataSet1
      const ts = TransferSyntax.kExplicitVRLittleEndian;
      final uiTransferSyntaxUID0 =
          UItag(PTag.kTransferSyntaxUID, [ts.asString]);
      final usSamplesPerPixel0 = UStag(PTag.kSamplesPerPixel, [1]);
      final csPhotometricInterpretation0 =
          CStag(PTag.kPhotometricInterpretation, ['PJZ7YG5']);
      final usRows0 = UStag(PTag.kRows, [4]);
      final usColumns0 = UStag(PTag.kColumns, [2]);
      final usBitsAllocated0 = UStag(PTag.kBitsAllocated, [1]);
      final usBitsStored0 = UStag(PTag.kBitsStored, [1]);
      final usHighBit0 = UStag(PTag.kHighBit, [0]);
      final usPixelRepresentation0 = UStag(PTag.kPixelRepresentation, [2]);
      final usPlanarConfiguration0 = UStag(PTag.kPlanarConfiguration, [7]);
      final isPixelAspectRatio0 = IStag(PTag.kPixelAspectRatio, ['1', '2']);
      const pixelAspectRatioValue0 = 1 / 2;
      final usSmallestImagePixelValue0 =
          UStag(PTag.kSmallestImagePixelValue, [0]);
      final usLargestImagePixelValue0 =
          UStag(PTag.kLargestImagePixelValue, [1]);
      final obIccProfile0 = OBtag(PTag.kICCProfile, <int>[]);
      final csColorSpace0 = CStag(PTag.kColorSpace);
      final usPixelPaddingRangeLimit0 = UStag(PTag.kPixelPaddingRangeLimit);

      final rootDS0 = TagRootDataset.empty()
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

      log.debug('rootDS0.transferSyntax: ${rootDS0.transferSyntax}');

      final ob1FDf = FrameDescriptor.fromDataset(rootDS0);

      const length0 = 1;
      final pixels0 = Uint8List(ob1FDf.lengthInBytes);

      final ob1c = FrameList1Bit(pixels0, length0, ob1FDf);

      // pixels
      expect(ob1c.samplesPerPixel == ob1FDf.samplesPerPixel, true);
      expect(ob1c.pixels.length == pixels0.length, true);
      expect(ob1c.pixels.lengthInBytes == pixels0.lengthInBytes, true);
      expect(ob1c.pixelSizeInBytes, 0);

      expect(ob1c.pixelSizeInBits == ob1FDf.pixelSizeInBits, true);
      expect(ob1c.pixels is Uint8List, true);

      // length
      expect(ob1c.length == length0, true); //length0=1

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
      expect(ob1c.desc.lengthInBytes == ob1FDf.lengthInBytes * length0, true);

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
      int length0;
      const photometricInterpretation0 = 'MONOCHROME1';

      final ob1FDg = FrameDescriptor(
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
        length0 = i + 1;
        final pixels0 = Uint8List(length0 * (ob1FDg.lengthInBytes));
        ob1FLb = FrameList1Bit(pixels0, length0, ob1FDg);
        log.debug('length0: $length0');

        for (var j = 0; j < length0; j++) {
          final frame0 = ob1FLb[j];
          expect(frame0.index == j, true);

          expect(frame0.lengthInBytes * length0 == ob1FLb.pixels.lengthInBytes,
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
      log.debug('length0: $length0, Frames in FrameList: ${ob1FLb.length}');
      expect(() => ob1FLb[length0], throwsA(const TypeMatcher<RangeError>()));
    });

    test('Frame1Bit', () {
      const length0 = 1;
      const photometricInterpretation0 = 'MONOCHROME1';

      final ob1FDa = FrameDescriptor(
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

      final pixels0 = Uint8List(ob1FDa.lengthInBytes);

      final ob1FLa = FrameList1Bit(pixels0, length0, ob1FDa);

      final frame1 = Frame1Bit(ob1FLa, pixels0, 1);
      log.debug('frame1: $frame1');

      // pixels
      expect(frame1.pixels is Uint8List, true);
      expect(frame1.pixels.length == pixels0.length, true);
      expect(frame1.pixels.lengthInBytes == pixels0.lengthInBytes, true);
      log
        ..debug('ob1BitFrames0.pixelSizeInBits: ${frame1.pixelSizeInBits}')
        ..debug('pixels0.elementSizeInBytes: ${pixels0.elementSizeInBytes}');
      expect(frame1.pixelSizeInBits == pixels0.elementSizeInBytes, true);
      expect(frame1.pixelSizeInBytes == 0, true);

      global.throwOnError = true;
      // bulkdata
      expect(frame1.bulkdata.length == pixels0.lengthInBytes, true);
      expect(frame1.bulkdata.length == frame1.bulkdata.lengthInBytes, true);
      expect(frame1.pixels.lengthInBytes == frame1.bulkdata.length, true);
      expect(frame1.pixels == pixels0, true);

      // length
      expect(frame1.length == pixels0.length * 8, true);

      // frameLength
      expect(frame1.lengthInBytes == pixels0.lengthInBytes, true);
      expect(frame1.lengthInBytes == frame1.pixels.lengthInBytes, true);
      expect(frame1.lengthInBytes == frame1.bulkdata.lengthInBytes, true);

      // FrameDescriptor values
      // transferSyntax
      expect(frame1.ts == ts0, true);

      //other FrameDescriptor fields
      expect(frame1.samplesPerPixel == samplesPerPixel0, true);
      expect(frame1.rows == rows4, true);
      expect(frame1.columns == columns6, true);
      expect(frame1.bitsAllocated == bitsAllocated1, true);
      expect(frame1.bitsStored == bitsStored1, true);
      expect(frame1.highBit == highBit1, true);
      expect(frame1.pixelRepresentation == pixelRepresentation0, true);
      expect(frame1.planarConfiguration, isNull);
      expect(frame1.pixelAspectRatio == pixelAspectRatio0, true);

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

      final bytes0 = Uint8List(frame1.lengthInBytes);
      expect(bytes0, equals(pixels0));
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
      const length0 = 1;
      const photometricInterpretation0 = 'MONOCHROME1';

      final ob8FDa = FrameDescriptor(
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

      final pixels0 = Uint8List(ob8FDa.lengthInBytes);

      final ob8a = FrameList8Bit(pixels0, length0, ob8FDa);

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

      // length
      expect(ob8a.length == length0, true);

      // frameLength
      expect(ob8a.frameLength == rows4 * columns6, true);
      expect(ob8a.lengthInBytes == pixels0.lengthInBytes, true);
      expect(ob8a.lengthInBytes == ob8FDa.lengthInBytes * length0, true);
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

      final bytes0 = Uint8List(ob8a.lengthInBytes);
      expect(bytes0, equals(pixels0));
    });

    test('Create Uncompressed FrameList8Bit MultiFrame', () {
      int length1;
      const photometricInterpretation1 = 'MONOCHROME2';
      const rows5 = 5;
      const columns7 = 7;

      final ob8FDb = FrameDescriptor(
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
        length1 = i * 2;
        log.debug('nFrames:$length1');
        final pixels1 = Uint8List(length1 * (ob8FDb.lengthInBytes));

        final ob8b = FrameList8Bit(pixels1, length1, ob8FDb);

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
        expect(ob8b.length == length1, true);

        // frameLength
        expect(ob8b.frameLength == rows5 * columns7, true);
        expect(ob8b.lengthInBytes == pixels1.lengthInBytes, true);
        expect(ob8b.lengthInBytes == ob8FDb.lengthInBytes * length1, true);
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

        final bytes1 = Uint8List(ob8b.lengthInBytes);
        expect(bytes1, equals(pixels1));
      }
    });

    test('Invalid FrameList8Bit data test', () {
      //nFrames = 0 (Invalid Frames)
      const length0 = 0;
      const photometricInterpretation1 = 'MONOCHROME3';

      final ob8FDc = FrameDescriptor(
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

      final pixels0 = Uint8List(ob8FDc.lengthInBytes);

      log
        ..debug('pixels0.length: ${pixels0.lengthInBytes}')
        ..debug('nFrames: $length0')
        ..debug('pixelSize bits: ${ob8FDc.pixelSizeInBits}')
        ..debug('pixelSize bytes: ${ob8FDc.pixelSizeInBytes}');

      global.throwOnError = true;
      expect(() => FrameList8Bit(pixels0, length0, ob8FDc),
          throwsA(const TypeMatcher<InvalidFrameListError>()));

      //Invalid Pixels [== 0]
      const length1 = 1;
      const photometricInterpretation2 = 'MONOCHROME3';

      final ob8FDd = FrameDescriptor(
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

      final pixels1 = Uint8List(0);
      log
        ..debug('pixels0.length: ${pixels1.lengthInBytes}')
        ..debug('nFrames: $length1')
        ..debug('pixelSize bits: ${ob8FDd.pixelSizeInBits}')
        ..debug('pixelSize bytes: ${ob8FDd.pixelSizeInBytes}');
      expect(() => FrameList8Bit(pixels1, length1, ob8FDd),
          throwsA(const TypeMatcher<InvalidFrameListError>()));

      const nFrames2 = 2;
      const photometricInterpretation3 = 'MONOCHROME3';

      // Invalid FrameDescriptor Data
      final ob8FDe = FrameDescriptor(
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

      final pixels2 = Uint8List(ob8FDe.lengthInBytes);
      log
        ..debug('pixels0.length: ${pixels2.lengthInBytes}')
        ..debug('nFrames: $nFrames2')
        ..debug('pixelSize bits: ${ob8FDe.pixelSizeInBits}')
        ..debug('pixelSize bytes: ${ob8FDe.pixelSizeInBytes}');
      expect(() => FrameList8Bit(pixels2, nFrames2, ob8FDe),
          throwsA(const TypeMatcher<InvalidFrameListError>()));
    });

    test('Create Uncompressed FrameList8Bit (FrameDescriptor.fromDataset)', () {
      global.throwOnError = false;
      //Frame Descriptor.fromDataSet1
      const ts = TransferSyntax.kExplicitVRLittleEndian;
      final uiTransferSyntaxUID0 =
          UItag(PTag.kTransferSyntaxUID, [ts.asString]);
      final usSamplesPerPixel0 = UStag(PTag.kSamplesPerPixel, [1]);
      final csPhotometricInterpretation0 =
          CStag(PTag.kPhotometricInterpretation, ['PJZ7YG5']);
      final usRows0 = UStag(PTag.kRows, [3]);
      final usColumns0 = UStag(PTag.kColumns, [6]);
      final usBitsAllocated0 = UStag(PTag.kBitsAllocated, [8]);
      final usBitsStored0 = UStag(PTag.kBitsStored, [8]);
      final usHighBit0 = UStag(PTag.kHighBit, [7]);
      final usPixelRepresentation0 = UStag(PTag.kPixelRepresentation, [3]);
      final usPlanarConfiguration0 = UStag(PTag.kPlanarConfiguration, [5]);
      final isPixelAspectRatio0 = IStag(PTag.kPixelAspectRatio, ['1', '2']);
      const pixelAspectRatioValue0 = 1 / 2;
      final usSmallestImagePixelValue0 =
          UStag(PTag.kSmallestImagePixelValue, [0]);
      final usLargestImagePixelValue0 =
          UStag(PTag.kLargestImagePixelValue, [255]);
      final obIccProfile0 = OBtag(PTag.kICCProfile, <int>[]);
      final csColorSpace0 = CStag(PTag.kColorSpace);
      final usPixelPaddingRangeLimit0 = UStag(PTag.kPixelPaddingRangeLimit);

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
        ..add(usPixelPaddingRangeLimit0);

      final ob8FDe = FrameDescriptor.fromDataset(rds0);

      const length0 = 1;
      final pixels0 = Uint8List(ob8FDe.lengthInBytes);

      final ob8d = FrameList8Bit(pixels0, length0, ob8FDe);

      // pixels
      expect(ob8d.samplesPerPixel == ob8FDe.samplesPerPixel, true);
      expect(ob8d.pixels.length == pixels0.length, true);
      expect(ob8d.pixels.lengthInBytes == pixels0.lengthInBytes, true);
      expect(ob8d.pixelSizeInBytes == pixels0.elementSizeInBytes, true);
      expect(ob8d.pixelSizeInBits == ob8FDe.pixelSizeInBits, true);
      expect(ob8d.pixels is Uint8List, true);

      // nFrames
      expect(ob8d.length == length0, true);

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
      expect(ob8d.desc.lengthInBytes == ob8FDe.lengthInBytes * length0, true);

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
      int length0;
      const photometricInterpretation0 = 'MONOCHROME1';

      final ob8FDf = FrameDescriptor(
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
        length0 = i + 1;
        log.debug('length0: $length0');
        final pixels0 = Uint8List(length0 * (ob8FDf.lengthInBytes));
        ob8e = FrameList8Bit(pixels0, length0, ob8FDf);
        for (var j = 0; j < length0; j++) {
          final frame0 = ob8e[j];
          expect(frame0.index == j, true);

          expect(frame0.lengthInBytes * length0 == ob8e.lengthInBytes, true);
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

      log.debug('length0: $length0, Frames in FrameList: ${ob8e.length}');
      expect(() => ob8e[length0], throwsA(const TypeMatcher<RangeError>()));
    });

    test('Frame8Bit', () {
      const length0 = 1;
      const photometricInterpretation0 = 'MONOCHROME1';

      final ob8FDa = FrameDescriptor(
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

      final pixels0 = Uint8List(ob8FDa.lengthInBytes);

      final ob8a = FrameList8Bit(pixels0, length0, ob8FDa);

      final frame8 = Frame8Bit(ob8a, pixels0, 1);
      log.debug('frame1: $frame8');

      // pixels
      expect(frame8.pixels is Uint8List, true);
      expect(frame8.pixels.length == pixels0.length, true);
      expect(frame8.pixels == pixels0, true);
      expect(frame8.pixels.lengthInBytes == pixels0.lengthInBytes, true);
      expect(frame8.pixelSizeInBits == ob8FDa.pixelSizeInBits, true);

      // bulkdata
      expect(frame8.bulkdata.length == pixels0.lengthInBytes, true);
      expect(frame8.bulkdata.length == frame8.bulkdata.lengthInBytes, true);
      expect(frame8.pixels.lengthInBytes == frame8.bulkdata.length, true);

      // length
      expect(ob8a.length == length0, true);

      // frameLength
      expect(frame8.lengthInBytes == pixels0.lengthInBytes, true);
      expect(frame8.lengthInBytes == ob8FDa.lengthInBytes * length0, true);
      expect(frame8.lengthInBytes == frame8.pixels.lengthInBytes, true);
      expect(frame8.lengthInBytes == frame8.bulkdata.lengthInBytes, true);

      // FrameDescriptor values
      // transferSyntax
      expect(frame8.ts == ts0, true);

      //other FrameDescriptor fields
      expect(frame8.samplesPerPixel == samplesPerPixel0, true);
      expect(frame8.rows == rows4, true);
      expect(frame8.columns == columns6, true);
      expect(frame8.bitsAllocated == bitsAllocated8, true);
      expect(frame8.bitsStored == bitsStored8, true);
      expect(frame8.highBit == highBit8, true);
      expect(frame8.pixelRepresentation == pixelRepresentation0, true);
      expect(frame8.planarConfiguration, isNull);
      expect(frame8.pixelAspectRatio == pixelAspectRatio0, true);
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
      const length0 = 1;

      final c8FDa = FrameDescriptor(
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

      final offsets = Uint32List.fromList([0, 4]);
      final bulkdata = Uint8List(4);

      log.debug('offsets.length: ${offsets.length}');

      final c8a = CompressedFrameList(bulkdata, offsets, length0, c8FDa);
      log.debug(c8a);

      expect(c8a.pixelSizeInBits == c8FDa.pixelSizeInBits, true);

      // nFrames
      expect(c8a.length == length0, true);

      // frameLength
      expect(c8a.frameLength == rows4 * columns6, true);
      expect(c8a.lengthInBytes == c8FDa.lengthInBytes * length0, false);

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

      final bytes0 = Uint8List(c8a.lengthInBytes);
      expect(bytes0, equals(bulkdata));
    });

    test('CompressedFrameList MulitFrame', () {
      const photometricInterpretation1 = 'MONOCHROME2';
      int length1;

      final c8FDb = FrameDescriptor(
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
        length1 = i * 2;
        offSetList.add(0);
        for (var j = 1; j <= length1; j++) {
          offSetList.add(j * 2);
        }
        log.debug('nFrames:$length1');
        final offSets = Uint32List.fromList(offSetList);
        final bulkdata = Uint8List(i * 4);

        log.debug('offSetList: $offSetList, length1 + 1: '
            '${length1 + 1}, offSets: ${offSets.length}');

        final c8b = CompressedFrameList(bulkdata, offSets, length1, c8FDb);
        log.debug(c8b);

        expect(c8b.pixelSizeInBits == c8FDb.pixelSizeInBits, true);

        // nFrames
        expect(c8b.length == length1, true);

        // frameLength
        expect(c8b.frameLength == rows4 * columns6, true);
        expect(c8b.lengthInBytes == c8FDb.lengthInBytes * length1, false);

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

        final bytes0 = Uint8List(c8b.lengthInBytes);
        expect(bytes0, equals(bulkdata));

        offSetList = <int>[];
      }
    });

    test('Invalid CompressedFrameList', () {
      global.throwOnError = true;
      //nFrames = 0
      const length0 = 0;
      const photometricInterpretation0 = 'MONOCHROME1';

      final c8FDc = FrameDescriptor(
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

      final offsets0 = Uint32List(0);
      final bulkdata0 = Uint8List(0);

      log.debug('nFrames: $length0');
      expect(() => CompressedFrameList(bulkdata0, offsets0, length0, c8FDc),
          throwsA(const TypeMatcher<InvalidFrameListError>()));

      // Invalid offsets and bulkdata
      const length1 = 1;
      const photometricInterpretation1 = 'MONOCHROME2';

      final c8FDd = FrameDescriptor(
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

      final offSets = Uint32List(0);
      final bulkData = Uint8List(0);

      log..debug('offSets: $offSets')..debug('bulkData: $bulkData');
      expect(() => CompressedFrameList(bulkData, offSets, length1, c8FDd),
          throwsA(const TypeMatcher<InvalidFrameListError>()));

      // Invalid FrameDescriptor data
      const photometricInterpretation2 = 'MONOCHROME3';
      const nFrames2 = 1;

      final c8FDe = FrameDescriptor(
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

      final offsets2 = Uint32List.fromList([0, 4]);
      final bulkdata2 = Uint8List(0);

      expect(() => CompressedFrameList(bulkdata2, offsets2, nFrames2, c8FDe),
          throwsA(const TypeMatcher<InvalidFrameListError>()));

      // Invalid Offsets
      final offSets3 = Uint32List.fromList([0, 2, 4, 3, 8, 9, 10]);
      final bulkdata = Uint8List(10);
      log.debug('offSets3: $offSets3');
      expect(() => CompressedFrameList(bulkdata, offSets3, length1, c8FDe),
          throwsA(const TypeMatcher<InvalidFrameListError>()));
    });

    test('CompressedFrameList.fromVFFragments', () {
      const length0 = 1;
      const photometricInterpretation1 = 'MONOCHROME1';

      final cFDb = FrameDescriptor(
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

      final offsets = Uint32List.fromList([0, 4]);
      final emptyOffsetsAsBytes1 = offsets.buffer.asUint8List();
      final bulkData = Uint8List(4);
      final fragments = [emptyOffsetsAsBytes1, bulkData];
      final vfFragments = VFFragmentList(fragments);

      final c8c =
          CompressedFrameList.fromVFFragments(vfFragments, length0, cFDb);

      expect(c8c.pixelSizeInBits == cFDb.pixelSizeInBits, true);

      // nFrames
      expect(c8c.length == length0, true);

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

      final bytes0 = Uint8List(c8c.lengthInBytes);
      log.debug(bytes0);
    });
    test('CompressedFrameList.fromVFFragments multiFrame', () {
      int length1;
      const photometricInterpretation2 = 'MONOCHROME2';

      final cFDc = FrameDescriptor(
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
        length1 = i * 2;
        offSetList.add(0);
        for (var j = 1; j <= length1; j++) {
          offSetList.add(j * 2);
        }

        final offsets = Uint32List.fromList(offSetList);
        final emptyOffsetsAsBytes1 = offsets.buffer.asUint8List();
        final bulkData = Uint8List(i * 4);
        final fragments = [emptyOffsetsAsBytes1, bulkData];
        log.debug('offSetList: $offSetList, nFrames + 1: ${length1 + 1}, '
            'offSets: ${offsets.length}');
        final vfFragments = VFFragmentList(fragments);

        final c8d =
            CompressedFrameList.fromVFFragments(vfFragments, length1, cFDc);

        expect(c8d.pixelSizeInBits == cFDc.pixelSizeInBits, true);

        // nFrames
        expect(c8d.length == length1, true);

        // frameLength
        expect(c8d.frameLength == rows4 * columns6, true);
        expect(c8d.lengthInBytes == cFDc.lengthInBytes * length1, false);
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
        final bytes0 = Uint8List(c8d.lengthInBytes);
        log.debug(bytes0);
      }
    });

    test('Invalid CompressedVFFragments', () {
      //nFrames = 0 (Invalid frames)
      const length0 = 0;
      const photometricInterpretation0 = 'MONOCHROME1';

      final cFDb = FrameDescriptor(
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

      final bulkData0 = Uint8List(4);
      final fragments0 = [bulkData0];
      final vfFragments0 = VFFragmentList(fragments0);

      expect(
          () =>
              CompressedFrameList.fromVFFragments(vfFragments0, length0, cFDb),
          throwsA(const TypeMatcher<InvalidFrameListError>()));

      // Invalid offset
      const length1 = 1;
      const photometricInterpretation1 = 'MONOCHROME2';

      final cFDc = FrameDescriptor(
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

      final emptyOffsets = Uint32List(0);
      final emptyOffsetsAsBytes = emptyOffsets.buffer.asUint8List();
      final bulkData1 = Uint8List(4);
      final fragments1 = [emptyOffsetsAsBytes, bulkData1];
      final vfFragments1 = VFFragmentList(fragments1);

      expect(
          () =>
              CompressedFrameList.fromVFFragments(vfFragments1, length1, cFDc),
          throwsA(const TypeMatcher<InvalidFrameListError>()));

      // Invalid FrameDescriptor values
      const nFrames2 = 1;
      const photometricInterpretation2 = 'MONOCHROME1';

      final cFDd = FrameDescriptor(
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

      final emptyOffsets1 = Uint32List(2);
      final emptyOffsetsAsBytes1 = emptyOffsets1.buffer.asUint8List();
      final bulkData2 = Uint8List(4);
      final fragments2 = [emptyOffsetsAsBytes1, bulkData2];
      final vfFragments2 = VFFragmentList(fragments2);

      expect(
          () =>
              CompressedFrameList.fromVFFragments(vfFragments2, nFrames2, cFDd),
          throwsA(const TypeMatcher<InvalidFrameListError>()));
    });

    test('CompressedFrameList operator []', () {
      const photometricInterpretation0 = 'MONOCHROME1';
      int length0;

      final c8FDg = FrameDescriptor(
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

      length0 = 7;
      log.debug('length0: $length0');
      final offsets = Uint32List.fromList([0, 2, 3, 5, 8, 13, 21, 34]);
      final bulkdata = Uint8List(34);

      final c8c = CompressedFrameList(bulkdata, offsets, length0, c8FDg);

      for (var j = 0; j < length0; j++) {
        final frame0 = c8c[j];
        expect(frame0.index == j, true);

        log.debug('frame0.lengthInBytes: ${frame0.lengthInBytes}, '
            'c8c.offsets[${j + 1}] - c8c.offsets[$j]: '
            '${c8c.offsets[j + 1] - c8c.offsets[j]}');

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

      log.debug('length0: $length0, Frames in FrameList: ${c8c.length}');
      expect(() => c8c[length0], throwsA(const TypeMatcher<RangeError>()));
    });
  });
}
