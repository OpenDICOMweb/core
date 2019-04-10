//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.element.bytes;

/// Signed Short (SS)
class SSbytes extends SS with ByteElement<int>, Int16Mixin {
  @override
  final DicomBytes bytes;

  /// Returns a new [SSbytes] [Element].
  SSbytes(this.bytes);

  /// Returns a new [SSbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static SSbytes fromBytes(DicomBytes bytes, [Ascii _]) => SSbytes(bytes);

  /// Returns a new [SSbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static ByteElement fromValues(int code, List<int> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes =
        _makeShort(code, vList, endian, isEvr, kSSCode, SS.kSizeInBytes);
    if (bytes == null) return null;
    bytes.writeUint16VF(vList);
    assert(vList.length * SS.kSizeInBytes <= SS.kMaxVFLength);
    return fromBytes(bytes);
  }
}

/// Signed Long (SL)
class SLbytes extends SL with ByteElement<int>, Int32Mixin {
  @override
  final DicomBytes bytes;

  /// Returns a new [SLbytes] [Element].
  SLbytes(this.bytes);

  /// Returns a new [SLbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static SLbytes fromBytes(DicomBytes bytes, [Ascii _]) => SLbytes(bytes);

  // ignore: prefer_constructors_over_static_methods
  /// Returns a new [SLbytes] [Element].
  static SLbytes fromValues(int code, List<int> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes =
        _makeShort(code, vList, endian, isEvr, kSLCode, SL.kSizeInBytes);
    if (bytes == null) return null;
    bytes.writeInt32VF(vList);
    assert(vList.length * SL.kSizeInBytes <= SL.kMaxVFLength);
    return fromBytes(bytes);
  }
}

// **** 8-bit Integer Elements (OB, UN)

/// Other Bytes (OB).
class OBbytes extends OB with ByteElement<int>, Uint8Mixin {
  @override
  final DicomBytes bytes;

  /// Returns a new [OBbytes] [Element].
  OBbytes(this.bytes);

  /// Returns a new [OBbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static OBbytes fromBytes(DicomBytes bytes, [Ascii _]) => OBbytes(bytes);

  /// If [code] == [kPixelData] returns a [OBbytesPixelData]; otherwise,
  /// returns a new [OBbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static ByteElement fromValues(int code, List<int> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes =
        _makeLong(code, vList, endian, isEvr, kOBCode, OB.kSizeInBytes)
          ..writeUint8VF(vList);
    assert(vList.length * OB.kSizeInBytes <= OB.kMaxVFLength);
    return (code == kPixelData)
        ? OBbytesPixelData.fromBytes(bytes)
        : fromBytes(bytes);
  }
}

/// Unknown (UN).
class UNbytes extends UN with ByteElement<int>, Uint8Mixin {
  @override
  final DicomBytes bytes;

  /// Returns a new [UNbytes] [Element].
  UNbytes(this.bytes);

  /// Returns a new [UNbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static UNbytes fromBytes(DicomBytes bytes, [Ascii _]) => UNbytes(bytes);

  /// If [code] == [kPixelData] returns a [UNbytesPixelData]; otherwise,
  /// returns a new [UNbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static ByteElement fromValues(int code, List<int> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes =
        _makeLong(code, vList, endian, isEvr, kUNCode, UN.kSizeInBytes)
          ..writeUint8VF(vList);
    assert(vList.length * UN.kSizeInBytes <= UN.kMaxVFLength);
    return (code == kPixelData)
        ? UNbytesPixelData.fromBytes(bytes)
        : fromBytes(bytes);
  }
}

/// Unsigned Short (US).
class USbytes extends US with ByteElement<int>, Uint16Mixin {
  @override
  final DicomBytes bytes;

  /// Returns a new [USbytes] [Element].
  USbytes(this.bytes);

  /// Returns a new [USbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static USbytes fromBytes(DicomBytes bytes, [Ascii _]) => USbytes(bytes);

  /// Returns a new [USbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static USbytes fromValues(int code, List<int> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes =
        _makeShort(code, vList, endian, isEvr, kUSCode, US.kSizeInBytes);
    if (bytes == null) return null;
    bytes.writeUint16VF(vList);
    assert(vList.length * US.kSizeInBytes <= US.kMaxVFLength);
    return fromBytes(bytes);
  }
}

/// Other Word (OW).
class OWbytes extends OW with ByteElement<int>, Uint16Mixin {
  @override
  final DicomBytes bytes;

  /// Returns a new [OWbytes] [Element].
  OWbytes(this.bytes);

  /// Returns a new [OWbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static OWbytes fromBytes(DicomBytes bytes, [Ascii _]) => OWbytes(bytes);

  // ignore: prefer_constructors_over_static_methods
  /// If [code] == [kPixelData] returns a [OWbytesPixelData]; otherwise,
  /// returns a new [OWbytes] [Element].
  static ByteElement fromValues(int code, List<int> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes =
        _makeLong(code, vList, endian, isEvr, kOWCode, OW.kSizeInBytes);
    if (bytes == null) return null;
    bytes.writeUint16VF(vList);
    assert(vList.length * OW.kSizeInBytes <= OW.kMaxVFLength);
    return (code == kPixelData)
        ? OWbytesPixelData.fromBytes(bytes)
        : fromBytes(bytes);
  }
}

/// Attribute (Element) Code (AT)
class ATbytes extends AT with ByteElement<int>, Uint32Mixin {
  @override
  final DicomBytes bytes;

  /// Returns a new [ATbytes] [Element].
  ATbytes(this.bytes);

  /// Returns a new [ATbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static ATbytes fromBytes(DicomBytes bytes, [Ascii _]) => ATbytes(bytes);

  /// Returns a new [ATbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static ATbytes fromValues(int code, List<int> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes =
        _makeShort(code, vList, endian, isEvr, kATCode, AT.kSizeInBytes);
    if (bytes == null) return null;
    bytes.writeUint32VF(vList);
    assert(vList.length * AT.kSizeInBytes <= AT.kMaxVFLength);
    return fromBytes(bytes);
  }
}

/// Other Long (OL)
class OLbytes extends OL with ByteElement<int>, Uint32Mixin {
  @override
  final DicomBytes bytes;

  /// Returns a new [OLbytes] [Element].
  OLbytes(this.bytes);

  /// Returns a new [OLbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static OLbytes fromBytes(DicomBytes bytes, [Ascii _]) => OLbytes(bytes);

  /// Returns a new [OLbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static OLbytes fromValues(int code, List<int> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes =
        _makeShort(code, vList, endian, isEvr, kOLCode, OL.kSizeInBytes);
    if (bytes == null) return null;
    bytes.writeUint32VF(vList);
    assert(vList.length * OL.kSizeInBytes <= OL.kMaxVFLength);
    return fromBytes(bytes);
  }
}

/// Unsigned Long (UL)
class ULbytes extends UL with ByteElement<int>, Uint32Mixin {
  @override
  final DicomBytes bytes;

  /// Returns a new [ULbytes] [Element].
  ULbytes(this.bytes);

  /// Returns a new [ULbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static ULbytes fromBytes(DicomBytes bytes, [Ascii _]) =>
      // If the code is (gggg,0000) create a Group Length element
      (bytes.getUint16(2) == 0) ? GLbytes(bytes) : ULbytes(bytes);

  /// Returns a new [ULbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static ULbytes fromValues(int code, List<int> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes =
        _makeShort(code, vList, endian, isEvr, kULCode, UL.kSizeInBytes);
    if (bytes == null) return null;
    bytes.writeUint32VF(vList);
    assert(vList.length * UL.kSizeInBytes <= UL.kMaxVFLength);
    return fromBytes(bytes);
  }
}

/// Group Length (GL)
class GLbytes extends ULbytes {
  /// Returns a new [GLbytes] [Element].
  GLbytes(DicomBytes bytes) : super(bytes);

  /// Returns a new [GLbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static GLbytes fromBytes(DicomBytes bytes, [Ascii _]) => GLbytes(bytes);

  /// Returns a new [GLbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static GLbytes fromValues(int code, List<int> vList,
      {Endian endian = Endian.little, bool isEvr = true}) {
    final bytes =
        _makeShort(code, vList, endian, isEvr, kULCode, SS.kSizeInBytes);
    if (bytes == null) return null;
    bytes.writeUint8VF(vList);
    assert(vList.length * SS.kSizeInBytes <= SS.kMaxVFLength);
    return fromBytes(bytes);
  }

  /// The VR keyword for _this_.
  static const String kVRKeyword = 'GL';

  /// The VR name for _this_.
  static const String kVRName = 'Group Length';
}
