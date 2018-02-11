// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See /[package]/AUTHORS file for other contributors.


import 'package:core/src/dataset/base/root_dataset.dart';
import 'package:core/src/element/errors.dart';
import 'package:core/src/element/frame.dart';
import 'package:core/src/element/frame_list.dart';
import 'package:core/src/tag/export.dart';
import 'package:core/src/uid/well_known/transfer_syntax.dart';

// TODO: add links to the DICOM Standard to each of the fields.

/// A class corresponding to a DICOM Image Pixel Module, but without Pixel Data.
/// See [PS3.3 Section C.7.6.3](http://dicom.nema.org/medical/dicom/current/output/html/part03.html#sect_C.7.6.3)
class FrameDescriptor {
  static const List<int> validPixelAllocatedSizes = const [1, 8, 16, 32];

  //TODO: decide if TS belongs here.
  /// The [TransferSyntax] for _this_.
  final TransferSyntax ts;

  /// Type 1 - The number of samples (planes) in these frames. (kSamplesPerPixel)
  final int samplesPerPixel;

  /// (kPhotometricInterpretation) Type 1
  final String photometricInterpretation;

  /// (kRows) Type 1 - The number of [rows] in each image frame.
  final int rows;

  /// Type 1 - The number of [columns] in each image frame. (kColumns)
  final int columns;

  /// Type 1 - The length in bits of a pixel.  (kBitsAllocated)
  final int bitsAllocated;

  /// (kBitsStored) Type 1 - The actual number of bits used in [bitsAllocated].
  final int bitsStored;

  /// (kHighBit) the Most significant bit for pixel sample data.
  /// Each sample shall have the same high bit.
  final int highBit;

  //TODO: doc
  /// Type 1 (kPixelRepresentation)
  /// (0 = Unsigned Integer, 1 = 2s Complement Integer)
  final int pixelRepresentation;

  //TODO: doc
  /// (kPlanarConfiguration) Type 1C - Required if (kSamplesPerPixel) > 1.
  /// (0 = color-by-pixel, 1 = color-by-plane)
  final int planarConfiguration;

  //TODO: doc
  /// [k PixelAspectRatio] Type 1C - Required if other than 1.
  final double pixelAspectRatio;

  //TODO: doc
  /// (kSmallestImagePixelValue) Type 3
  final int smallestImagePixelValue;

  //TODO: doc
  /// (kLargestImagePixelValue) Type 3
  final int largestImagePixelValue;

  //TODO: doc
  /// (kRedPaletteColorLookupTableDescriptor) Type 1C
  final ColorPaletteDescriptor redLUTDescriptor;

  //TODO: doc
  /// (kGreenPaletteColorLookupTableDescriptor) Type 1C
  final ColorPaletteDescriptor greenLUTDescriptor;

  //TODO: doc
  /// (kBluePaletteColorLookupTableDescriptor) Type 1C
  final ColorPaletteDescriptor blueLUTDescriptor;

  //TODO: doc
  /// (kAlphaPaletteColorLookupTableDescriptor) Type 1C
  final ColorPaletteDescriptor alphaLUTDescriptor;

  /// TODO: doc
  /// (kRedPaletteColorLookupTableData) Type 1C
  final ColorPaletteData redLUTData;

  /// TODO: doc
  /// (kRedPaletteColorLookupTableData) Type 1C
  final ColorPaletteData greenLUTData;

  /// TODO: doc
  /// (kRedPaletteColorLookupTableData) Type 1C
  final ColorPaletteData blueLUTData;

  /// TODO: doc
  /// (kAlphaPaletteColorLookupTableData) Type 1C
  final ColorPaletteData alphaLUTData;

  /// TODO: doc
  /// (kICCProfile) Type 3
  final ICCProfile iccProfile;

  /// TODO: doc
  /// (kColorSpace) Type 3
  final ColorSpace colorSpace;

  /// TODO: doc
  /// (kPixelPaddingRangeLimit) Type 3
  final int pixelPaddingRangeLimit;

  FrameDescriptor(
      this.ts,
      this.samplesPerPixel,
      this.photometricInterpretation,
      this.rows,
      this.columns,
      this.bitsAllocated,
      this.bitsStored,
      this.highBit,
      this.pixelRepresentation,
      this.planarConfiguration,
      {this.pixelAspectRatio = 1.0,
      this.smallestImagePixelValue = 0,
      this.largestImagePixelValue = 65535,
      this.redLUTDescriptor,
      this.greenLUTDescriptor,
      this.blueLUTDescriptor,
      this.alphaLUTDescriptor,
      this.redLUTData,
      this.greenLUTData,
      this.blueLUTData,
      this.alphaLUTData,
      this.iccProfile,
      this.colorSpace,
      this.pixelPaddingRangeLimit}) {
    _checkValidity(this);
  }

/* Flush if not needed
  FrameDescriptor.from(FrameDescriptor desc)
      : ts = desc.ts,
        samplesPerPixel = desc.samplesPerPixel,
        photometricInterpretation = desc.photometricInterpretation,
        rows = desc.rows,
        columns = desc.columns,
        bitsAllocated = desc.bitsAllocated,
        bitsStored = desc.bitsStored,
        highBit = desc.highBit,
        pixelRepresentation = desc.pixelRepresentation,
        planarConfiguration = desc.planarConfiguration,
        pixelAspectRatio = desc.pixelAspectRatio,
        smallestImagePixelValue = desc.smallestImagePixelValue,
        largestImagePixelValue = desc.largestImagePixelValue,
        redLUTDescriptor = desc.redLUTDescriptor,
        greenLUTDescriptor = desc.greenLUTDescriptor,
        blueLUTDescriptor = desc.blueLUTDescriptor,
        alphaLUTDescriptor = desc.alphaLUTDescriptor,
        redLUTData = desc.redLUTData,
        greenLUTData = desc.greenLUTData,
        blueLUTData = desc.blueLUTData,
        alphaLUTData = desc.alphaLUTData,
        iccProfile = desc.iccProfile,
        colorSpace = desc.colorSpace,
        pixelPaddingRangeLimit = desc.pixelPaddingRangeLimit;
*/

  FrameDescriptor.fromDataset(RootDataset ds)
      : ts = ds.transferSyntax,
        samplesPerPixel = ds.samplesPerPixel,
        photometricInterpretation = ds.photometricInterpretation,
        rows = ds.rows,
        columns = ds.columns,
        bitsAllocated = ds.bitsAllocated,
        bitsStored = ds.bitsStored,
        highBit = ds.highBit,
        pixelRepresentation = ds.pixelRepresentation,
        planarConfiguration = ds.planarConfiguration,
        pixelAspectRatio = ds.pixelAspectRatio,
        smallestImagePixelValue = ds.smallestImagePixelValue,
        largestImagePixelValue = ds.largestImagePixelValue,
        //Fix: add to Dataset when implementing colors
        redLUTDescriptor = null,
        //ds.redLUTDescriptor,
        greenLUTDescriptor = null,
        //ds.greenLUTDescriptor,
        blueLUTDescriptor = null,
        //ds.blueLUTDescriptor,
        alphaLUTDescriptor = null,
        //ds.alphaLUTDescriptor,
        redLUTData = null,
        //ds.redLUTData,
        greenLUTData = null,
        //ds.greenLUTData,
        blueLUTData = null,
        //ds.blueLUTData,
        alphaLUTData = null,
        //ds.alphaLUTData,
        iccProfile = null,
        //ds.iccProfile,
        colorSpace = null,
        //ds.colorSpace,
        // ixelPaddingRangeLimit = ds.pixelPaddingRangeLimit
        pixelPaddingRangeLimit = null {
    _checkValidity(this);
  }

  bool get isValid => isValidDescriptor(this);

  bool get isNotValid => !isValid;

  void _checkValidity(FrameDescriptor desc) {
    if (desc.isNotValid) return invalidFrameDescriptorError(desc);
  }

  int get pixelSizeInBits => bitsAllocated;

  int get pixelSizeInBytes => bitsAllocated ~/ 8;

  /// The number of pixels in each [Frame]. If the
  /// [length] == -1, then the [Frame]s are compressed.
  int get length => rows * columns;

  /// The number of pixels in each [Frame]. If the [length] == -1,
  /// then the [Frame]s are compressed.
  int get lengthInBits => (length * bitsAllocated);

  /// The number of pixels in each [Frame] or [FrameList] with _this_
  /// as their [FrameDescriptor]. If the [length] == -1, then
  /// the [Frame]s are compressed.
  int get lengthInBytes => lengthInBits ~/ 8;

  //TODO: add rest of fields
  String get info => '''
$runtimeType
  Pixel:
                 bitAllocated: $bitsAllocated
                pixelSizeBits: $pixelSizeInBits
               pixelSizeBytes: $pixelSizeInBytes
                   bitsStored: $bitsStored
                      highBit: $highBit
                smallestValue:
                 largestValue:
  Frame:
                         rows: $rows
                      columns: $columns
                       length: $length
                   lengthBits: $lengthInBits
                lengthInBytes: $lengthInBytes
  Other:
              samplesPerPixel: $samplesPerPixel
    photometricInterpretation: $photometricInterpretation
          planarConfiguration: $planarConfiguration
  ''';

  //TODO: fix
  @override
  String toString() => '$runtimeType: $ts';

  //TODO: validity entails more than this - add what's needed
  static bool isValidDescriptor(FrameDescriptor desc) {
    final pixelSize = desc.bitsAllocated;
    if ((pixelSize == 1 || (pixelSize <= 32 && ((pixelSize % 8) == 0))) &&
        (desc.bitsStored <= pixelSize) &&
        (desc.highBit == desc.bitsStored - 1)) return true;
    return false;
  }
}

