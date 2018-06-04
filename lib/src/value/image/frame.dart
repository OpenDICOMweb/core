//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:collection';
import 'dart:typed_data';

import 'package:core/src/value/image/frame_descriptor.dart';
import 'package:core/src/value/image/frame_list.dart';
import 'package:core/src/value/uid.dart';

/// A single image, that is either an independent image, or a single
/// [Frame] of a multi-part image or video.
abstract class Frame extends ListBase<int> {
  /// The [FrameList] that contains this [Frame].
  final FrameList parent;

  /// The zero-based [index] of this [Frame] in the [FrameList].
  final int index;

  /// Creates an image [Frame].
  Frame(this.parent, this.index) {
    assert(length == parent.desc.length &&
        lengthInBytes == parent.desc.lengthInBytes);
  }

  Frame.compressed(this.parent, this.index);

  @override
  int operator [](int i) => pixels[i];

  @override
  void operator []=(int i, int v) =>
      throw new UnsupportedError('Frame pixels may not be changed');

  /// The [pixels] contained in _this_, if any.
  List<int> get pixels;

  /// The [pixels] as a [TypedData] [List].
//  TypedData get data => pixels as TypedData;

  /// The [bulkdata] contained in _this_, if any.
  ///
  /// _Note_: [bulkdata] is always a [Uint8List] that has the same
  /// [lengthInBytes] as [pixels].[lengthInBytes].
  Uint8List get bulkdata;

  /// Returns the number of pixels in _this_. This should always be equal to
  /// [parent.desc.length].
  @override
  int get length => pixels.length;

  @override
  set length(int i) =>
      throw new UnsupportedError('Frame pixels may not be changed');

  /// Returns the number of bytes in [pixels].
  int get lengthInBytes => bulkdata.lengthInBytes;

  FrameDescriptor get descriptor => parent.desc;

  /// The number of samples (planes) in this [Frame]. (kSamplesPerPixel)
  int get samplesPerPixel => parent.desc.samplesPerPixel;

  /// The number of [rows] in each image [Frame]. (kRows)
  int get rows => parent.desc.rows;

  /// The number of [columns] in each image [Frame]. (kColumns)
  int get columns => parent.desc.columns;

  /// The length in bits of a pixel. (kBitsAllocated)
  int get bitsAllocated => parent.desc.bitsAllocated;

  /// The actual number of bits used in [bitsAllocated]. (kBitsStored)
  int get bitsStored => parent.desc.bitsStored;

  /// (kHighBit) the Most significant bit for pixel sample data.
  /// Each sample shall have the same high bit.
  int get highBit => parent.desc.highBit;

  /// (kPixelRepresentation)
  int get pixelRepresentation => parent.desc.pixelRepresentation;

  /// (kPlanarConfiguration)
  /// Required if (kSamplesPerPixel) > 1.
  int get planarConfiguration => parent.desc.planarConfiguration;

  /// [k PixelAspectRatio]
  double get pixelAspectRatio => parent.desc.pixelAspectRatio;

  int get pixelSizeInBits => parent.desc.pixelSizeInBits;

  /// The size in bytes of each pixel.
  int get pixelSizeInBytes => parent.desc.pixelSizeInBytes;

  /// The [TransferSyntax] for this [CompressedFrame].
  TransferSyntax get ts => parent.desc.ts;

  @override
  String toString() => '$runtimeType[$index]: length: $length, lengthInBytes:'
      ' $lengthInBytes';
}

/// A fixed size [Frame] where each pixel is 1-bit.
class Frame1Bit extends Frame {
  @override
  final Uint8List pixels;

  Frame1Bit(FrameList parent, this.pixels, int index) : super(parent, index) {
    assert(
        lengthInBytes == parent.desc.lengthInBytes,
        'lengthInBytes: $lengthInBytes == '
        'parent.desc.lengthInBytes: ${parent.desc.lengthInBytes}');

    assert(length == parent.desc.length,
        'length: $length == parent.desc.length: ${parent.desc.length}');
  }

  //TODO: needs testing
  @override
  int operator [](int i) {
    RangeError.checkValidRange(0, i, length);
    final bIndex = i ~/ 8;
    final bOffset = i & 0xFF;
    final bit = 1 << bOffset;
    final byte = pixels[bIndex];
    return byte & bit;
  }

  @override
  int get length => pixels.length * 8;

  @override
  Uint8List get bulkdata =>
      pixels.buffer.asUint8List(pixels.offsetInBytes, pixels.lengthInBytes);
}

/// A fixed size [Frame] where each pixel is 8-bits.
class Frame8Bit extends Frame {
  @override
  final Uint8List pixels;

  Frame8Bit(FrameList parent, this.pixels, int index) : super(parent, index) {
    assert(length == parent.desc.length);
  }

  @override
  Uint8List get bulkdata =>
      pixels.buffer.asUint8List(pixels.offsetInBytes, pixels.lengthInBytes);
}

/// A fixed size [Frame] where each pixel is 16-bits.
class Frame16Bit extends Frame {
  @override
  final Uint16List pixels;

  Frame16Bit(FrameList parent, this.pixels, int index) : super(parent, index) {
    assert(length == parent.desc.length);
  }

  @override
  Uint8List get bulkdata =>
      pixels.buffer.asUint8List(pixels.offsetInBytes, pixels.lengthInBytes);
}

/// A fixed size [Frame] where each pixel is 32-bits.
class Frame32Bit extends Frame {
  @override
  final Uint32List pixels;

  Frame32Bit(FrameList parent, this.pixels, int index) : super(parent, index) {
    assert(length == parent.desc.length);
  }

  @override
  Uint8List get bulkdata =>
      pixels.buffer.asUint8List(pixels.offsetInBytes, pixels.lengthInBytes);
}

/// A compressed [Frame] stored as bytes.
class CompressedFrame extends Frame {
  @override
  final Uint8List bulkdata;

  CompressedFrame(FrameList parent, this.bulkdata, int index)
      : super.compressed(parent, index);

  @override
  int operator [](int i) => throw new UnsupportedError(
      'Compressed Frames don\'t support the [] operator');

  /// Returns the number of bytes in [bulkdata].
  @override
  int get length => lengthInBytes;

  /// Returns the number of bytes in [bulkdata].
  @override
  int get lengthInBytes => bulkdata.lengthInBytes;

  @override
  Uint8List get pixels =>
      throw new UnsupportedError('Compressed Frames don\'t have pixels');
}
