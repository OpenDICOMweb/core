//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.element.bytes;

/// PixelDataMixin class
abstract class BytePixelData implements PixelData {
  VFFragments get fragments;

  // **** End Interface

  /// A [Uint32List] of offsets into [bulkdata].
  @override
  Uint32List get offsets =>
      (fragments == null) ? kEmptyUint32List : fragments.offsets;
}


// **** Integer Elements
// **** 8-bit Integer Elements (OB, UN)

class OBbytesPixelData extends OBPixelData
    with ByteElement<int>, Uint8Mixin, BytePixelData {
  @override
  final DicomBytes bytes;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  OBbytesPixelData(this.bytes, [this.ts, this.fragments]);

  @override
  int get lengthInBytes => bytes.vfLength;

  static OBbytesPixelData fromBytes(int code, DicomBytes bytes,
          [TransferSyntax ts, VFFragments fragments]) =>
      new OBbytesPixelData(bytes, ts, fragments);
}

class UNbytesPixelData extends UNPixelData
    with ByteElement<int>, Uint8Mixin, BytePixelData {
  @override
  final DicomBytes bytes;
  @override
  TransferSyntax ts;
  @override
  VFFragments fragments;

  UNbytesPixelData(this.bytes, [this.ts, this.fragments]);

  @override
  int get lengthInBytes => bytes.vfLength;

  static UNbytesPixelData fromBytes(DicomBytes bytes,
          [TransferSyntax ts, VFFragments fragments]) =>
      new UNbytesPixelData(bytes, ts, fragments);
}

// **** 16-bit Integer Elements (SS, US, OW)

class OWbytesPixelData extends OWPixelData
    with ByteElement<int>, Uint16Mixin, BytePixelData {
  @override
  final DicomBytes bytes;
  @override
  TransferSyntax ts;
  // Note: OW should _never_ have fragments, but it does happen
  @override
  VFFragments fragments;

  OWbytesPixelData(this.bytes, [this.ts, this.fragments]);

  @override
  int get lengthInBytes => bytes.vfLength;

  static OWbytesPixelData fromBytes(DicomBytes bytes,
          [TransferSyntax ts, VFFragments fragments]) =>
      new OWbytesPixelData(bytes, ts, fragments);
}
