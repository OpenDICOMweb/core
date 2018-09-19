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

/// 32-bit Float Elements (FL, OF)
abstract class Float32Mixin {
  int get vfLength;
  DicomBytes get vfBytes;

  int get length => Float32.getLength(vfLength);

  List<double> get values => vfBytes.asFloat32List();
}


class FLbytes extends FL with ByteElement<double>, Float32Mixin {
  @override
  final DicomBytes bytes;

  FLbytes(this.bytes) : assert(bytes != null);

  static FLbytes fromBytes(DicomBytes bytes) => new FLbytes(bytes);

  static FLbytes fromValues(int code, Iterable<double> vList,
      {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kFLCode, isEvr, FL.kSizeInBytes)
      ..writeFloat32VF(vList);
    assert(vList.length * FL.kSizeInBytes <= FL.kMaxVFLength);
    return FLbytes.fromBytes(bytes);
  }
}

class OFbytes extends OF with ByteElement<double>, Float32Mixin {
  @override
  final DicomBytes bytes;

  OFbytes(this.bytes);

  static OFbytes fromBytes(DicomBytes bytes) => new OFbytes(bytes);

  static OFbytes fromValues(int code, List<double> vList, {bool isEvr = true}) {
    final bytes = _makeLong(code, vList, kOFCode, isEvr, OF.kSizeInBytes)
      ..writeFloat32VF(vList);
    assert(vList.length * OF.kSizeInBytes <= OF.kMaxVFLength);
    return fromBytes(bytes);
  }
}

// **** 64-Bit Float Elements (OD, OF)

/// Long Float Elements (FD, OD)
abstract class Float64Mixin {
  int get vfLength;
  DicomBytes get vfBytes;

  int get length => Float64.getLength(vfLength);

  List<double> get values => vfBytes.asFloat64List();
}

class FDbytes extends FD with ByteElement<double>, Float64Mixin {
  @override
  final DicomBytes bytes;

  FDbytes(this.bytes);

  static FDbytes fromBytes(DicomBytes bytes, [Dataset ds]) =>
      new FDbytes(bytes);

  static FDbytes fromValues(int code, List<double> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kFDCode, isEvr, FD.kSizeInBytes)
      ..writeFloat64VF(vList);
    assert(vList.length * FD.kSizeInBytes <= FD.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class ODbytes extends OD with ByteElement<double>, Float64Mixin {
  @override
  final DicomBytes bytes;

  ODbytes(this.bytes);

  static ODbytes fromBytes(DicomBytes bytes) => new ODbytes(bytes);

  static ODbytes fromValues(int code, List<double> vList, {bool isEvr = true}) {
    final bytes = _makeLong(code, vList, kODCode, isEvr, OD.kSizeInBytes)
      ..writeFloat64VF(vList);
    assert(vList.length * OD.kSizeInBytes <= OD.kMaxVFLength);
    return fromBytes(bytes);
  }
}
