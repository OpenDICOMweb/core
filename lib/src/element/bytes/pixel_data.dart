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
mixin BytePixelData {
  BytesDicom get bytes;

  VFFragmentList get fragments => VFFragmentList.parse(bytes.vfBytes);

  int get lengthInBytes => bytes.vfLength;

  /// A [Uint32List] of offsets into [fragments].
  Uint32List get offsets =>
      (fragments == null) ? kEmptyUint32List : fragments.offsets;

  Uint8List get bulkdata =>
      (fragments == null) ? bytes.vfBytes : fragments.bulkdata;

  FrameList get frames => unimplementedError();
}

// **** Integer Elements
// **** 8-bit Integer Elements (OB, UN)

class OBbytesPixelData extends OBbytes
    with PixelDataMixin, BytePixelData, OBPixelData {
  @override
  TransferSyntax ts;
  @override
  VFFragmentList fragments;

  OBbytesPixelData(BytesDicom bytes, [this.ts, this.fragments]) : super(bytes);

  // ignore: prefer_constructors_over_static_methods
  static OBbytesPixelData fromBytes(BytesDicom bytes,
          [TransferSyntax ts, VFFragmentList fragments]) =>
      OBbytesPixelData(bytes, ts, fragments);
}

class UNbytesPixelData extends UNbytes
    with PixelDataMixin, BytePixelData, UNPixelData {
  @override
  TransferSyntax ts;
  @override
  VFFragmentList fragments;

  UNbytesPixelData(BytesDicom bytes, [this.ts, this.fragments]) : super(bytes);

  // ignore: prefer_constructors_over_static_methods
  static UNbytesPixelData fromBytes(BytesDicom bytes,
          [TransferSyntax ts, VFFragmentList fragments]) =>
      UNbytesPixelData(bytes, ts, fragments);
}

// **** 16-bit Integer Elements (SS, US, OW)

class OWbytesPixelData extends OWbytes
    with PixelDataMixin, BytePixelData, OWPixelData {
  @override
  TransferSyntax ts;
  // Note: OW should _never_ have fragments, but it does happen
  @override
  VFFragmentList fragments;

  OWbytesPixelData(BytesDicom bytes, [this.ts, this.fragments]) : super(bytes);

  // ignore: prefer_constructors_over_static_methods
  static OWbytesPixelData fromBytes(BytesDicom bytes,
          [TransferSyntax ts, VFFragmentList fragments]) =>
      OWbytesPixelData(bytes, ts, fragments);
}
