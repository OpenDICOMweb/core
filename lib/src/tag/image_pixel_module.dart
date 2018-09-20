//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/tag/e_type.dart';

// ignore_for_file: public_member_api_docs

class ImagePixelModule {
  ImagePixelModule();
}

class ImagePixel {
  final String keyword;
  final EType type;

  const ImagePixel._(this.keyword, this.type);

  static const ImagePixel kSamplesPerPixel =
      ImagePixel._('SamplesPerPixel', EType.k1);
  static const ImagePixel kPhotometricInterpretation =
      ImagePixel._('PhotometricInterpretation', EType.k1);
  static const ImagePixel kRows = ImagePixel._('Rows', EType.k1);
  static const ImagePixel kColumns = ImagePixel._('Columns', EType.k1);
  static const ImagePixel kBitsAllocated =
      ImagePixel._('BitsAllocated', EType.k1);
  static const ImagePixel kBitsStored = ImagePixel._('BitsStored', EType.k1);
  static const ImagePixel kHighBit = ImagePixel._('HighBit', EType.k1);
  //Enumerated Values: 0000H	unsigned integer. 0001H	2's complement
  static const ImagePixel kPixelRepresentation =
      ImagePixel._('PixelRepresentation', EType.k1);
  static const ImagePixel kPlanarConfiguration =
      ImagePixel._('PlanarConfiguration', EType.k1c);
  static const ImagePixel kPixelAspectRatio =
      ImagePixel._('PixelAspectRatio', EType.k1c);
  static const ImagePixel kSmallestImagePixelValue =
      ImagePixel._('SmallestImagePixelValue', EType.k3);
  static const ImagePixel kLargestImagePixelValue =
      ImagePixel._('LargestImagePixelValue', EType.k3);
  static const ImagePixel kRedPaletteColorLookupTableDescriptor =
      ImagePixel._('RedPaletteColorLookupTableDescriptor', EType.k1c);
  static const ImagePixel kGreenPaletteColorLookupTableDescriptor =
      ImagePixel._('GreenPaletteColorLookupTableDescriptor', EType.k1c);
  static const ImagePixel kBluePaletteColorLookupTableDescriptor =
      ImagePixel._('BluePaletteColorLookupTableDescriptor', EType.k1c);
  static const ImagePixel kRedPaletteColorLookupTableData =
      ImagePixel._('RedPaletteColorLookupTableData', EType.k1c);
  static const ImagePixel kGreenPaletteColorLookupTableData =
      ImagePixel._('GreenPaletteColorLookupTableData', EType.k1c);
  static const ImagePixel kBluePaletteColorLookupTableData =
      ImagePixel._('BluePaletteColorLookupTableData', EType.k1c);
  static const ImagePixel kICCProfile = ImagePixel._('ICCProfile', EType.k3);
  static const ImagePixel kColorSpace = ImagePixel._('ColorSpace', EType.k3);
  static const ImagePixel kPixeLData = ImagePixel._('PixelData', EType.k1c);
  static const ImagePixel kPixelDataProviderURL =
      ImagePixel._('PixelDataProviderURL', EType.k1c);
  static const ImagePixel kPixelPaddingRangeLimit =
      ImagePixel._('PixelPaddingRangeLimit', EType.k1c);
}
