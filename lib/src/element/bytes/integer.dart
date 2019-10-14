//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.element.bytes;

// ignore_for_file: prefer_constructors_over_static_methods

/// Signed Short (SS)
class SSbytes extends SS with ElementBytes<int> {
  @override
  final BytesElement be;

  /// Returns a new [SSbytes] [Element].
  SSbytes(this.be);

  @override
  int get length {
    assert(vfBytes.length.isEven);
    return vfBytes.length ~/ 2;
  }

  @override
  Int16List get values => vfBytes.asInt16List();

  /// Returns a new [SSbytes] [Element].
  static SSbytes fromBytes(BytesElement bytes, [Ascii _]) => SSbytes(bytes);

  /// Returns a new [SSbytes] [Element].
  static SSbytes fromValues(int code, List<int> vList, BytesElementType type) {
    final vfBytes = Int32.toBytes(vList);
    final bytes = _makeShortElt(code, vfBytes, kSSCode, type, SS.kMaxVFLength);
    return SSbytes(bytes);
  }
}

/// Signed Long (SL)
class SLbytes extends SL with ElementBytes<int> {
  @override
  final BytesElement be;

  /// Returns a new [SLbytes] [Element].
  SLbytes(this.be);

  @override
  int get length {
    assert(vfBytes.length % 4 == 0);
    return vfBytes.length ~/ 4;
  }

  @override
  Int32List get values => vfBytes.asInt32List();

  /// Returns a new [SLbytes] [Element].
  static SLbytes fromBytes(BytesElement bytes, [Ascii _]) => SLbytes(bytes);

  /// Returns a new [SLbytes] [Element].
  static SLbytes fromValues(int code, List<int> vList, BytesElementType type) {
    final vfBytes = Int32.toBytes(vList);
    final bytes = _makeShortElt(code, vfBytes, kSLCode, type, SL.kMaxVFLength);
    return SLbytes(bytes);
  }
}

/// Signed Very Long Integer (SV) - 64 bit signed integer.
class SVbytes extends SV with ElementBytes<int> {
  @override
  final BytesElement be;

  /// Returns a new [SVbytes] [Element].
  SVbytes(this.be);

  @override
  int get length {
    assert(vfBytes.length % 8 == 0);
    return vfBytes.length ~/ 8;
  }

  @override
  Int64List get values => vfBytes.asInt64List();

  /// Returns a new [SVbytes] [Element].
  static SVbytes fromBytes(BytesElement bytes, [Ascii _]) => SVbytes(bytes);

  /// Returns a new [SVbytes] [Element].
  static SVbytes fromValues(int code, List<int> vList, BytesElementType type) {
    final vfBytes = Int32.toBytes(vList);
    final bytes = _makeShortElt(code, vfBytes, kSLCode, type, SL.kMaxVFLength);
    return SVbytes(bytes);
  }
}

// **** 8-bit Integer Elements (OB, UN)

/// Unsigned 8-bit Integer Elements (OB, UN)
mixin Uint8Mixin {
  Bytes get vfBytes;

  int get length => vfBytes.length;

  Uint8List get values => vfBytes.asUint8List();
}

/// Other Bytes (OB).
class OBbytes extends OB with ElementBytes<int>, Uint8Mixin {
  @override
  final BytesElement be;

  /// Returns a new [OBbytes] [Element].
  OBbytes(this.be);

  /// Returns a new [OBbytes] [Element].
  static OBbytes fromBytes(BytesElement bytes, [Ascii _]) => OBbytes(bytes);

  /// If [code] == [kPixelData] returns a [OBbytesPixelData]; otherwise,
  /// returns a new [OBbytes] [Element].
  static ElementBytes fromValues(
      int code, List<int> vList, BytesElementType type) {
    final vfBytes = Uint8.toBytes(vList);
    final bytes = _makeLongElt(code, vfBytes, kOBCode, type, OB.kMaxVFLength);
    return (code == kPixelData) ? OBbytesPixelData(bytes) : OBbytes(bytes);
  }
}

/// Unknown (UN).
class UNbytes extends UN with ElementBytes<int>, Uint8Mixin {
  @override
  final BytesElement be;

  /// Returns a new [UNbytes] [Element].
  UNbytes(this.be);

  /// Returns a new [UNbytes] [Element].
  static UNbytes fromBytes(BytesElement bytes, [Ascii _]) => UNbytes(bytes);

  /// If [code] == [kPixelData] returns a [UNbytesPixelData]; otherwise,
  /// returns a new [UNbytes] [Element].
  static ElementBytes fromValues(
      int code, List<int> vList, BytesElementType type) {
    final vfBytes = Uint8.toBytes(vList);
    final bytes = _makeLongElt(code, vfBytes, kUNCode, type, UN.kMaxVFLength);
    return (code == kPixelData) ? UNbytesPixelData(bytes) : UNbytes(bytes);
  }
}

/// 16-bit unsigned integer Elements (US, OW)
mixin Uint16Mixin {
  Bytes get vfBytes;

  int get length {
    assert(vfBytes.length.isEven);
    return vfBytes.length ~/ 2;
  }

  Uint16List get values => vfBytes.asUint16List();
}

/// Unsigned Short (US).
class USbytes extends US with ElementBytes<int>, Uint16Mixin {
  @override
  final BytesElement be;

  /// Returns a new [USbytes] [Element].
  USbytes(this.be);

  /// Returns a new [USbytes] [Element].
  static USbytes fromBytes(BytesElement bytes, [Ascii _]) => USbytes(bytes);

  /// Returns a new [USbytes] [Element].
  static USbytes fromValues(int code, List<int> vList, BytesElementType type) {
    final vfBytes = Uint16.toBytes(vList);
    final bytes = _makeShortElt(code, vfBytes, kUSCode, type, US.kMaxVFLength);
    return USbytes(bytes);
  }
}

/// Other Word (OW).
class OWbytes extends OW with ElementBytes<int>, Uint16Mixin {
  @override
  final BytesElement be;

  /// Returns a new [OWbytes] [Element].
  OWbytes(this.be);

  /// Returns a new [OWbytes] [Element].
  static OWbytes fromBytes(BytesElement bytes, [Ascii _]) => OWbytes(bytes);

  /// If [code] == [kPixelData] returns a [OWbytesPixelData]; otherwise,
  /// returns a new [OWbytes] [Element].
  static ElementBytes fromValues(
      int code, List<int> vList, BytesElementType type) {
    final vfBytes = Uint16.toBytes(vList);
    final bytes = _makeLongElt(code, vfBytes, kOWCode, type, OW.kMaxVFLength);
    return (code == kPixelData) ? OWbytesPixelData(bytes) : OWbytes(bytes);
  }
}

/// 32-bit unsigned integer Elements (AT, UL, GL, OL)
mixin Uint32Mixin {
  Bytes get vfBytes;

  int get length {
    assert(vfBytes.length % 4 == 0);
    return vfBytes.length ~/ 4;
  }

  Uint32List get values => vfBytes.asUint32List();
}

/// Attribute (Element) Code (AT)
class ATbytes extends AT with ElementBytes<int>, Uint32Mixin {
  @override
  final BytesElement be;

  /// Returns a new [ATbytes] [Element].
  ATbytes(this.be);

  /// Returns a new [ATbytes] [Element].
  static ATbytes fromBytes(BytesElement bytes, [Ascii _]) => ATbytes(bytes);

  /// Returns a new [ATbytes] [Element].
  static ATbytes fromValues(int code, List<int> vList, BytesElementType type) {
    final vfBytes = Uint32.toBytes(vList);
    final bytes = _makeShortElt(code, vfBytes, kATCode, type, AT.kMaxVFLength);
    return ATbytes(bytes);
  }
}

/// Other Long (OL)
class OLbytes extends OL with ElementBytes<int>, Uint32Mixin {
  @override
  final BytesElement be;

  /// Returns a new [OLbytes] [Element].
  OLbytes(this.be);

  /// Returns a new [OLbytes] [Element].
  static OLbytes fromBytes(BytesElement bytes, [Ascii _]) => OLbytes(bytes);

  /// Returns a new [OLbytes] [Element].
  static OLbytes fromValues(int code, List<int> vList, BytesElementType type) {
    final vfBytes = Uint32.toBytes(vList);
    final bytes = _makeLongElt(code, vfBytes, kOLCode, type, OL.kMaxVFLength);
    return OLbytes(bytes);
  }
}

/// Unsigned Long (UL)
class ULbytes extends UL with ElementBytes<int>, Uint32Mixin {
  @override
  final BytesElement be;

  /// Returns a new [ULbytes] [Element].
  ULbytes(this.be);

  /// Returns a new [ULbytes] [Element].
  static ULbytes fromBytes(BytesElement bytes, [Ascii _]) =>
      // If the code is (gggg,0000) create a Group Length element
      (bytes.getUint16(2) == 0) ? GLbytes(bytes) : ULbytes(bytes);

  /// Returns a new [ULbytes] [Element].
  static ULbytes fromValues(int code, List<int> vList, BytesElementType type) {
    final vfBytes = Uint32.toBytes(vList);
    final bytes = _makeShortElt(code, vfBytes, kULCode, type, UL.kMaxVFLength);
    return ULbytes(bytes);
  }
}

/// Group Length (GL)
class GLbytes extends ULbytes {
  /// Returns a new [GLbytes] [Element].
  GLbytes(BytesElement bytes) : super(bytes);

  /// Returns a new [GLbytes] [Element].
  static GLbytes fromBytes(BytesElement bytes, [Ascii _]) => GLbytes(bytes);

  /// Returns a new [GLbytes] [Element].
  static GLbytes fromValues(int code, List<int> vList, BytesElementType type) {
    final vfBytes = Uint32.toBytes(vList);
    final bytes = _makeShortElt(code, vfBytes, kULCode, type, UL.kMaxVFLength);
    return GLbytes(bytes);
  }

  /// The VR keyword for _this_.
  static const String kVRKeyword = 'GL';

  /// The VR name for _this_.
  static const String kVRName = 'Group Length';
}

/// 64-bit unsigned integer Elements (AT, UL, GL, OL)
mixin Uint64Mixin {
  Bytes get vfBytes;

  int get length {
    assert(vfBytes.length % 8 == 0);
    return vfBytes.length ~/ 8;
  }

  Uint64List get values => vfBytes.asUint64List();
}

/// Unsigned 64-bit Other Very Long Integer (OV)
class OVbytes extends OV with ElementBytes<int>, Uint64Mixin {
  @override
  final BytesElement be;

  /// Returns a new [OVbytes] [Element].
  OVbytes(this.be);

  /// Returns a new [OVbytes] [Element].
  static OVbytes fromBytes(BytesElement bytes, [Ascii _]) =>
      // If the code is (gggg,0000) create a Group Length element
      (bytes.getUint16(2) == 0) ? GLbytes(bytes) : OVbytes(bytes);

  /// Returns a new [OVbytes] [Element].
  static OVbytes fromValues(int code, List<int> vList, BytesElementType type) {
    final vfBytes = Uint64.toBytes(vList);
    final bytes = _makeShortElt(code, vfBytes, kOVCode, type, OV.kMaxVFLength);
    return OVbytes(bytes);
  }
}

/// Unsigned 64-bit Very Long Integer (UV)
class UVbytes extends UV with ElementBytes<int>, Uint64Mixin {
  @override
  final BytesElement be;

  /// Returns a new [UVbytes] [Element].
  UVbytes(this.be);

  /// Returns a new [UVbytes] [Element].
  static UVbytes fromBytes(BytesElement bytes, [Ascii _]) => UVbytes(bytes);

  /// Returns a new [UVbytes] [Element].
  static UVbytes fromValues(int code, List<int> vList, BytesElementType type) {
    final vfBytes = Uint64.toBytes(vList);
    final bytes = _makeShortElt(code, vfBytes, kUVCode, type, UV.kMaxVFLength);
    return UVbytes(bytes);
  }
}
