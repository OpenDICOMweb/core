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
// ignore_for_file: prefer_constructors_over_static_methods

/// 32-bit Float Elements (FL, OF)
mixin BytesFloat32Mixin {
  BytesElement get be;

  int get vfLength => Float32Mixin.getLength(be.vfLength);

  Float32List get values => be.vfBytes.asFloat32List();
}

class FLbytes extends FL with ElementBytes<double>, BytesFloat32Mixin {
  @override
  final BytesElement be;

  FLbytes(this.be) : assert(be != null);

  //TODO: fix all static constructors when constructors can be used as tear offs
  static FLbytes fromBytes(BytesElement bytes, [Charset _]) => FLbytes(bytes);

  static FLbytes fromValues(
      int code, Iterable<double> vList, BytesElementType type) {
    final vfBytes = Float32Mixin.toBytes(vList);
    final bytes = _makeShortElt(code, vfBytes, kFLCode, type, FL.kMaxVFLength);
    return FLbytes(bytes);
  }
}

class OFbytes extends OF with ElementBytes<double>, BytesFloat32Mixin {
  @override
  final BytesElement be;

  OFbytes(this.be);

  static OFbytes fromBytes(BytesElement bytes, [Ascii _]) => OFbytes(bytes);

  static OFbytes fromValues(
      int code, List<double> vList, BytesElementType type) {
    final vfBytes = Float32Mixin.toBytes(vList);
    final bytes = _makeLongElt(code, vfBytes, kOFCode, type, OF.kMaxVFLength);
    return OFbytes(bytes);
  }
}

// **** 64-Bit Float Elements (OD, OF)

/// Long Float Elements (FD, OD)
mixin BytesFloat64Mixin {
  int get vfLength;
  Bytes get vfBytes;

  int get length => Float64Mixin.getLength(vfLength);

  List<double> get values => vfBytes.asFloat64List();
}

class FDbytes extends FD with ElementBytes<double>, BytesFloat64Mixin {
  @override
  final BytesElement be;

  FDbytes(this.be);

  static FDbytes fromBytes(BytesElement bytes, [Ascii _]) => FDbytes(bytes);

  static FDbytes fromValues(
      int code, List<double> vList, BytesElementType type) {
    final vfBytes = Float64Mixin.toBytes(vList);
    final e = _makeShortElt(code, vfBytes, kFDCode, type, FD.kMaxVFLength);
    print('$e');
    return FDbytes(e);
  }
}

class ODbytes extends OD with ElementBytes<double>, BytesFloat64Mixin {
  @override
  final BytesElement be;

  ODbytes(this.be);

  static ODbytes fromBytes(BytesElement bytes, [Ascii _]) => ODbytes(bytes);

  static ODbytes fromValues(
      int code, List<double> vList, BytesElementType type) {
    final vfBytes = Float64Mixin.toBytes(vList);
    final bytes = _makeLongElt(code, vfBytes, kODCode, type, OD.kMaxVFLength);
    return ODbytes(bytes);
  }
}
