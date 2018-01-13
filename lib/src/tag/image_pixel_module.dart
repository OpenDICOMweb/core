// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/tag/e_type.dart';

class ImagePixelModule {
  ImagePixelModule();
}

class ImagePixel {
  final String keyword;
  final EType type;

  const ImagePixel._(this.keyword, this.type);

  static const ImagePixel kSamplesPerPixel =
      const ImagePixel._('SamplesPerPixel', EType.k1);
  static const ImagePixel kPhotometricInterpretation =
      const ImagePixel._('PhotometricInterpretation', EType.k1);
  static const ImagePixel kRows = const ImagePixel._('Rows', EType.k1);
  static const ImagePixel kColumns = const ImagePixel._('Columns', EType.k1);
  static const ImagePixel kBitsAllocated =
      const ImagePixel._('BitsAllocated', EType.k1);
  static const ImagePixel kBitsStored =
      const ImagePixel._('BitsStored', EType.k1);
  static const ImagePixel kHighBit = const ImagePixel._('HighBit', EType.k1);
  //Enumerated Values: 0000H	unsigned integer. 0001H	2's complement
  static const ImagePixel kPixelRepresentation =
      const ImagePixel._('PixelRepresentation', EType.k1);
  static const ImagePixel kPlanarConfiguration =
      const ImagePixel._('PlanarConfiguration', EType.k1c);
  static const ImagePixel kPixelAspectRatio =
      const ImagePixel._('PixelAspectRatio', EType.k1c);
  static const ImagePixel kSmallestImagePixelValue =
      const ImagePixel._('SmallestImagePixelValue', EType.k3);
  static const ImagePixel kLargestImagePixelValue =
      const ImagePixel._('LargestImagePixelValue', EType.k3);
  static const ImagePixel kRedPaletteColorLookupTableDescriptor =
      const ImagePixel._('RedPaletteColorLookupTableDescriptor', EType.k1c);
  static const ImagePixel kGreenPaletteColorLookupTableDescriptor =
      const ImagePixel._('GreenPaletteColorLookupTableDescriptor', EType.k1c);
  static const ImagePixel kBluePaletteColorLookupTableDescriptor =
      const ImagePixel._('BluePaletteColorLookupTableDescriptor', EType.k1c);
  static const ImagePixel kRedPaletteColorLookupTableData =
      const ImagePixel._('RedPaletteColorLookupTableData', EType.k1c);
  static const ImagePixel kGreenPaletteColorLookupTableData =
      const ImagePixel._('GreenPaletteColorLookupTableData', EType.k1c);
  static const ImagePixel kBluePaletteColorLookupTableData =
      const ImagePixel._('BluePaletteColorLookupTableData', EType.k1c);
  static const ImagePixel kICCProfile =
      const ImagePixel._('ICCProfile', EType.k3);
  static const ImagePixel kColorSpace =
      const ImagePixel._('ColorSpace', EType.k3);
  static const ImagePixel kPixeLData =
      const ImagePixel._('PixelData', EType.k1c);
  static const ImagePixel kPixelDataProviderURL =
      const ImagePixel._('PixelDataProviderURL', EType.k1c);
  static const ImagePixel kPixelPaddingRangeLimit =
      const ImagePixel._('PixelPaddingRangeLimit', EType.k1c);
}
