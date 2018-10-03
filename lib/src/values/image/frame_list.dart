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

import 'package:core/src/element/bytes/vf_fragments.dart';
import 'package:core/src/global.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/values/image/frame.dart';
import 'package:core/src/values/image/frame_descriptor.dart';
import 'package:core/src/values/uid.dart';

// ignore_for_file: public_member_api_docs

// A [FrameList] contains 1 or more image [Frame]s.
//
// Cases:
//   1. kNumberOfFrames == 1
//     - The Basic Offset table can be ignored.
//     - if the number of fragments == 1, then the fragment contains the frame.
//     - if the number of fragments >= 1, then the contents of each fragment are
//       concatenated to form a single contiguous frame.
//   2. kNumberOFFrames > 1
//     - if the Basic Offset Table is not empty (length > 1), then
//       the length of the Basic Offset Table must equal the kNumberOfFrames,
//       and each entry points to the first [Fragment] for the frame.
//       is the first byte of image data
//     - if the Basic Offset Table is empty (length == 0), then ...
//
// Notes:
// 1. The [pixels] in a Frame or [FrameList] are always uncompressed.
// 2. The [bulkdata] in a Frame or [FrameList] is a [Uint8List] view
//    of [pixels]
// 3. If a Frame or [FrameList] contains encapsulated (compressed) images,
//   it has no [pixels] and [bulkdata] contains the compressed data.

/// A [List] of image [Frame]s.
abstract class FrameList extends ListBase<Frame> {
  /// The number of [Frame]s in _this_.
  @override
  final int length;

  /// A [FrameDescriptor] describing the format of the [Frame]s in _this_.
  final FrameDescriptor desc;

  /// Creates a [FrameList] ([List<Frame>]) of uncompressed [Frame]s.
  FrameList._(this.length, this.desc) {
    if (isNotValid) invalidFrameListError(this);
  }

  /// Creates a [FrameList] ([List<Frame>]) of compressed [Frame]s.
  FrameList._compressed(this.length, this.desc);

  // **** Interface ****

  /// [set] [length] is not supported.
  @override
  set length(int length) =>
      throw UnsupportedError('FrameLists cannot be modified');

  /// A [List<int>] of (uncompressed) pixels containing
  /// all the [Frame]s concatenated together in one array of [int].
  /// Note: All [pixels] values are [TypedData].
  List<int> get pixels;

  /// A [Uint8List] containing the [offsets] and all the [Frame]s in _this_.
  Uint8List get bulkdata;

  // **** End interface ****

  /// Returns the [i]th [Frame] (zero based) in _this_.
  /// Note: Frame numbers (kFrameNumber]) are 1 based in a DICOM Dataset.
  @override
  Frame operator [](int i);

  /// Unsupported operator.
  @override
  void operator []=(int i, Frame f) =>
      throw UnsupportedError('FrameLists are immutable');

  /// The Basic Offset Table for [pixels]. This defaults to [kEmptyUint32List].
  Uint32List get offsets => kEmptyUint32List;

  /// The number of [Frame]s in _this_.
  bool get isNotValid =>
      length < 1 ||
      bulkdata.lengthInBytes != (desc.lengthInBytes * length) ||
      bulkdata.lengthInBytes != lengthInBytes;

  bool get isValid => !isNotValid;

  /// The number of bits in each pixel; equivalent to [bitsAllocated].
  int get pixelSizeInBits => desc.pixelSizeInBits;

  /// The number of bytes of each pixel.
  /// _Note_: For pixels that are sub-byte size (i.e. less than 8-bits)
  /// the values is zero.
  int get pixelSizeInBytes => desc.pixelSizeInBytes;

  /// The length in bytes of all the [Frame]s in _this_.
  int get lengthInBytes => bulkdata.lengthInBytes;

  /// The number of samples (kSamplesPerPixel) or planes in these [Frame]s.
  int get samplesPerPixel => desc.samplesPerPixel;

  /// The (kPhotometricInterpretation) of _this_.
  /// See [PS3.3 Section C.7.6.3.1.2]
  /// (http://dicom.nema.org/medical/dicom/current/output/html/part03.html#sect_C.7.6.3.1.2)
  String get photometricInterpretation => desc.photometricInterpretation;

  /// The number of [rows] (kRows) of pixels in each image frame.
  int get rows => desc.rows;

  /// The number of [columns] (kColumns) of pixels in each image frame.
  int get columns => desc.columns;

  /// The length ((kBitsAllocated)) in bits of a pixel.
  int get bitsAllocated => desc.bitsAllocated;

  /// The actual number of bits used ((kBitsStored)) in [bitsAllocated].
  int get bitsStored => desc.bitsStored;

  /// The Most significant bit ((kHighBit)) for pixel sample data.
  /// Each sample shall have the same high bit.
  int get highBit => desc.highBit;

  /// (kPixelRepresentation)
  int get pixelRepresentation => desc.pixelRepresentation;

  /// (kPlanarConfiguration)
  /// Required if (kSamplesPerPixel) > 1.
  int get planarConfiguration => desc.planarConfiguration;

  /// [k PixelAspectRatio]
  double get pixelAspectRatio => desc.pixelAspectRatio;

  /// The [TransferSyntax] for this [FrameList].
  TransferSyntax get ts => desc.ts;

  /// The length in pixels of each frame in _this_.
  int get frameLength => desc.length;

  /// The length in bytes in pixels of each frame in _this_.
  int get frameLengthInBytes => desc.lengthInBytes;

  int _getFrameOffset(int i) {
    RangeError.checkValidRange(0, i, length);
    return i * frameLengthInBytes;
  }

  /// The values if _false_ for all but [CompressedFrameList]s.
  bool get isCompressed => false;

  /// DICOM synonym for [isCompressed].
  bool get isEncapsulated => isCompressed;

  String get info => '''
$runtimeType
        length: $length
           rows: $rows
        columns: $columns
         length: $length
  lengthInBytes: $lengthInBytes
    frameLength: $frameLength;
 Descriptor:
${desc.info} 
  ''';

  @override
  String toString() => '$runtimeType($length frames)';
}

/// An uncompressed [FrameList] with 8-bit [pixels], i.e. VR = OB.
class FrameList1Bit extends FrameList {
  @override
  Uint8List pixels;

  /// A [List<Frame>] of 8-bit Native (i.e. uncompressed) images.
  FrameList1Bit(this.pixels, int length, FrameDescriptor desc)
      : super._(length, desc) {
    if (bitsAllocated != 1 &&
        pixels is! Uint8List &&
        isCompressed != false &&
        pixels.lengthInBytes != desc.lengthInBytes * length)
      invalidFrameListError(this);
  }

  @override
  Frame operator [](int i) {
    final offset = _getFrameOffset(i);
    // Uses [frameLengthInBytes] because it is a [Uint8List].
    final data = pixels.buffer.asUint8List(offset, frameLengthInBytes);
    return Frame1Bit(this, data, i);
  }

  @override
  Uint8List get bulkdata =>
      pixels.buffer.asUint8List(pixels.offsetInBytes, pixels.lengthInBytes);
}

/// An uncompressed [FrameList] with 8-bit [pixels], i.e. VR = OB.
class FrameList8Bit extends FrameList {
  @override
  Uint8List pixels;

  /// A [List<Frame>] of uncompressed 8-bit (OB) images (i.e. DICOM native).
  FrameList8Bit(this.pixels, int length, FrameDescriptor desc)
      : super._(length, desc) {
    if (bitsAllocated != 8 &&
        pixels is Uint8List &&
        isCompressed != false &&
        pixels.length == frameLength * length) invalidFrameListError(this);
  }

  @override
  Frame operator [](int i) {
    final offset = _getFrameOffset(i);
    final data = pixels.buffer.asUint8List(offset, frameLength);
    return Frame8Bit(this, data, i);
  }

  @override
  Uint8List get bulkdata =>
      pixels.buffer.asUint8List(pixels.offsetInBytes, pixels.lengthInBytes);
}

/// A [List<Frame>] of uncompressed 16-bit (OW) images (i.e. DICOM native).
///
/// Note: kPixelData with VR = OW cannot have encapsulated data, i.e. no
/// fragments and therefore, no Basic Offset Table (offsets).
class FrameList16Bit extends FrameList {
  @override
  final Uint16List pixels;

  /// Creates a [FrameList16Bit] of images with 16-bit pixels.
  FrameList16Bit(this.pixels, int length, FrameDescriptor desc)
      : super._(length, desc) {
    if (bitsAllocated != 16 &&
        pixels is Uint16List &&
        isCompressed != false &&
        pixels.length == frameLength * length &&
        pixels.length == length) invalidFrameListError(this);
  }

  @override
  Frame operator [](int i) {
    final offset = _getFrameOffset(i);
    final data = pixels.buffer.asUint16List(offset, frameLength);
    return Frame16Bit(this, data, i);
  }

  @override
  Uint8List get bulkdata =>
      pixels.buffer.asUint8List(pixels.offsetInBytes, pixels.lengthInBytes);
}

/// A [List<Frame>] of uncompressed 32-bit (OL) images (i.e. DICOM native).
///
/// Note: kPixelData with VR = OL cannot have encapsulated data, i.e. no
/// fragments and therefore, no Basic Offset Table (offsets).
class FrameList32Bit extends FrameList {
  @override
  final Uint32List pixels;

  /// A [List<Frame>] of 16-bit images.
  FrameList32Bit(this.pixels, int length, FrameDescriptor desc)
      : super._(length, desc) {
    if (bitsAllocated != 32 &&
        pixels is Uint32List &&
        isCompressed != false &&
        pixels.length == frameLength * length &&
        pixels.length == length) invalidFrameListError(this);
  }

  @override
  Frame operator [](int i) {
    final offset = _getFrameOffset(i);
    final data = pixels.buffer.asUint32List(offset, frameLength);
    return Frame32Bit(this, data, i);
  }

  @override
  Uint8List get bulkdata =>
      pixels.buffer.asUint8List(pixels.offsetInBytes, pixels.lengthInBytes);
}

/// A [List<Frame>] of compressed (OB) images (i.e. DICOM encapsulated).
///
/// A (kPixelData) Element with a VR == VR.kOB has compressed
/// (i.e. encapsulated) pixel data, i.e.
/// fragments and a Basic Offset Table [offsets]. [isCompressed] == _true_,
/// and [offsets].length == 0, then there is only one [Frame] present.
class CompressedFrameList extends FrameList {
  /// The raw bytes.
  @override
  Uint8List bulkdata;

  /// The offset table (aka DICOM Basic Offset Table).
  /// _Note_: [offsets].length must equal [length] + 1.
  @override
  Uint32List offsets;

  /// A [List<Frame>] of 8-bit Native (i.e. uncompressed) images.
  CompressedFrameList(
      this.bulkdata, this.offsets, int length, FrameDescriptor desc)
      : super._compressed(length, desc) {
    if (isNotValid) invalidFrameListError(this);
  }

  /// Creates an 8-bit [FrameList] for encapsulated (i.e. compressed) PixelData.
  CompressedFrameList.fromVFFragments(
      VFFragmentList fragments, int length, FrameDescriptor desc)
      : bulkdata = fragments.bulkdata,
        offsets = fragments.offsets,
        super._compressed(length, desc) {
    if (isNotValid) invalidFrameListError(this);
  }

  /// Each [Frame] is access through the [offsets] (Basic Offset Table) table.
  @override
  Frame operator [](int i) {
    final offset = offsets[i];
    final length = offsets[i + 1] - offset;
    final data = bulkdata.buffer.asUint8List(offset, length);
    return CompressedFrame(this, data, i);
  }

  @override
  bool get isNotValid =>
      length < 1 ||
      bulkdata is! Uint8List ||
      isCompressed != true ||
      _hasInvalidOffsets() ||
      bulkdata.lengthInBytes != offsets[offsets.length - 1];
  //TODO: add all appropriate assertions

  bool _hasInvalidOffsets() {
    if (length + 1 != offsets.length) return true;
    for (var i = 0; i < length; i++)
      if (offsets[i] >= offsets[i + 1]) return true;
    return false;
  }

  /// The length in bytes of [bulkdata] in _this_.
  @override
  int get lengthInBytes => bulkdata.lengthInBytes;

  @override
  Uint8List get pixels =>
      throw UnsupportedError('Compressed Frames must be uncompressed'
          ' to access the pixels');

  @override
  bool get isCompressed => true;

  //TODO: implement
  /// Returns a [FrameList] created by decompressing the [bulkdata] in _this_.
  FrameList get decompress => throw UnimplementedError();
}

class InvalidFrameListError extends Error {
  final FrameList frameList;

  InvalidFrameListError(this.frameList);

  @override
  String toString() => _msg(frameList);

  static String _msg(FrameList frameList) =>
      '$InvalidFrameListError: $frameList';
}

// ignore: prefer_void_to_null
Null invalidFrameListError(FrameList frameList) {
  log.error(InvalidFrameListError._msg(frameList));
  if (throwOnError) throw InvalidFrameListError(frameList);
  return null;
}
