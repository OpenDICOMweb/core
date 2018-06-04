  //  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

const int frameCount = 32;
const int rowsSize = 16;
const int columnSize = 16;
const int sampleSize = 16; // 1 and 3 defined
const int bitsAllocatedSize = 16;
const int bitsStoredSize = 16;
const int highBitSize = 16;
const int lowBitSize = 16;
const int pixelRepSize = 16;

const int minPixelValueSize = 16;
const int maxPixelValueSize = 16;
const int sampleUsedSize = 16;

enum PixelRepresentation { unsigned, signed }
const int planarConfigSize = 16;

// PixelAspectRatio defaults to 1
abstract class ImageBase {

   int get data0;
   int get data1;

//  set frameCount(int n) => (n < 1 || n > kMaxUint16)
//      ? badFrameCount(n)
//      : (n << 32) | shape;

  int get rows => (data0 | 0xFFFF000000000000) >> 24;
//  set rows(int n) => (n < 1 || n > kMaxUint16)
//  ? badRowCount(n)
//      : (n << 16) | shape;

  int get columns => (data0 | 0xFFFF00000000) >> 16;

  int get bitAllocated => (data0 | 0xFFFF0000) >> 8;
  int get bitStored => (data0 & 0xFFFF);
  int get highBit => (data1 & 0xFFFF) >> 8;
}

class Image extends ImageBase {
  Image(this.data0, this.data1);

  @override
  final int data0;
  @override
  final int data1;
  int get frameCount => 1;
}

class Frames extends ImageBase {
  @override
  final int data0;
  @override
  final int data1;

  Frames(this.data0, this.data1);


  int get frameCount => data1 >> 32;

}

abstract class UnsignedPixelsMixin {}

abstract class SignedPixelsMixin {}

abstract class GrayScale {}

abstract class Color {}

abstract class ColorByPlane {}

abstract class ColorByPixel {}

abstract class PixelAspectRatio {
  int ratio;

  int get numerator => ratio >> 32;
  int get denominator => ratio & 0xFFFFFFFF;
}

abstract class Monochrome1 {}

abstract class Monochrome2 {}

abstract class PaletteColor {}

abstract class RGB {}
