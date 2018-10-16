//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.element.bytes;

// ignore_for_file: public_member_api_docs

/// PixelDataMixin class
abstract class BytePixelData {
  VFFragmentList get fragments;
  int get vfLengthField;



  // **** End Interface

  /// A [Uint32List] of offsets into [fragments].
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
  VFFragmentList fragments;

  OBbytesPixelData(this.bytes, [this.ts, this.fragments]);

  @override
  int get vrIndex => kOBIndex;

  @override
  int get lengthInBytes => bytes.vfLength;

  // ignore: prefer_constructors_over_static_methods
  static OBbytesPixelData fromBytes(DicomBytes bytes,
          [TransferSyntax ts, VFFragmentList fragments]) =>
      OBbytesPixelData(bytes, ts, fragments);
}

class UNbytesPixelData extends UNPixelData
    with ByteElement<int>, Uint8Mixin, BytePixelData {
  @override
  final DicomBytes bytes;
  @override
  TransferSyntax ts;
  @override
  VFFragmentList fragments;

  UNbytesPixelData(this.bytes, [this.ts, this.fragments]);

  @override
  int get vrIndex => kUNIndex;

  @override
  int get lengthInBytes => bytes.vfLength;

  // ignore: prefer_constructors_over_static_methods
  static UNbytesPixelData fromBytes(DicomBytes bytes,
          [TransferSyntax ts, VFFragmentList fragments]) =>
      UNbytesPixelData(bytes, ts, fragments);
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
  VFFragmentList fragments;

  OWbytesPixelData(this.bytes, [this.ts, this.fragments]);

  @override
  int get vrIndex => kOWIndex;

  @override
  int get lengthInBytes => bytes.vfLength;

  // ignore: prefer_constructors_over_static_methods
  static OWbytesPixelData fromBytes(DicomBytes bytes,
          [TransferSyntax ts, VFFragmentList fragments]) =>
      OWbytesPixelData(bytes, ts, fragments);
}
