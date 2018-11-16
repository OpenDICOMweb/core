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

/// 16-bit signed integer Elements (SS)
mixin Int16Mixin {
  int get vfLength;
  Bytes get vfBytes;

  int get length => Int16.getLength(vfLength);

  Int16List get values => vfBytes.asInt16List();
}

class SSbytes extends SS with ByteElement<int>, Int16Mixin {
  @override
  final DicomBytes bytes;

  /// Returns a new [SSbytes] [Element].
  SSbytes(this.bytes);

  /// Returns a new [SSbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static SSbytes fromBytes(DicomBytes bytes, [Charset _]) => SSbytes(bytes);

  /// Returns a new [SSbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static ByteElement fromValues(int code, List<int> vList,
      {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kSSCode, isEvr, SS.kSizeInBytes);
    if (bytes == null) return null;
    bytes.writeUint16VF(vList);
    assert(vList.length * SS.kSizeInBytes <= SS.kMaxVFLength);
    return fromBytes(bytes);
  }
}

/// 32-bit signed integer Elements (SL)
mixin Int32Mixin {
  int get vfLength;
  Bytes get vfBytes;

  int get length => Int32.getLength(vfLength);

  Int32List get values => vfBytes.asInt32List();
}

/// Signed Long (SL)
class SLbytes extends SL with ByteElement<int>, Int32Mixin {
  @override
  final DicomBytes bytes;

  /// Returns a new [SLbytes] [Element].
  SLbytes(this.bytes);

  /// Returns a new [SLbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static SLbytes fromBytes(DicomBytes bytes, [Charset _]) => SLbytes(bytes);

  // ignore: prefer_constructors_over_static_methods
  /// Returns a new [SLbytes] [Element].
  static SLbytes fromValues(int code, List<int> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kSLCode, isEvr, SL.kSizeInBytes);
    if (bytes == null) return null;
    bytes.writeInt32VF(vList);
    assert(vList.length * SL.kSizeInBytes <= SL.kMaxVFLength);
    return fromBytes(bytes);
  }
}

/// Unsigned 8-bit Integer Elements (OB, UN)
mixin Uint8Mixin {
  int get vfLength;
  Bytes get vfBytes;

  int get length => Uint8.getLength(vfLength);

  Uint8List get values => vfBytes.asUint8List();
}

// **** Integer Elements
// **** 8-bit Integer Elements (OB, UN)

class OBbytes extends OB with ByteElement<int>, Uint8Mixin {
  @override
  final DicomBytes bytes;

  /// Returns a new [OBbytes] [Element].
  OBbytes(this.bytes);

  /// Returns a new [OBbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static OBbytes fromBytes(DicomBytes bytes, [Charset _]) => OBbytes(bytes);

  /// If [code] == [kPixelData] returns a [OBbytesPixelData]; otherwise,
  /// returns a new [OBbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static ByteElement fromValues(int code, List<int> vList,
      {bool isEvr = true}) {
    final bytes = _makeLong(code, vList, kOBCode, isEvr, OB.kSizeInBytes)
      ..writeUint8VF(vList);
    assert(vList.length * OB.kSizeInBytes <= OB.kMaxVFLength);
    return (code == kPixelData)
        ? OBbytesPixelData.fromBytes(bytes)
        : fromBytes(bytes);
  }
}

class UNbytes extends UN with ByteElement<int>, Uint8Mixin {
  @override
  final DicomBytes bytes;

  /// Returns a new [UNbytes] [Element].
  UNbytes(this.bytes);

  /// Returns a new [UNbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static UNbytes fromBytes(DicomBytes bytes, [Charset _]) => UNbytes(bytes);

  /// If [code] == [kPixelData] returns a [UNbytesPixelData]; otherwise,
  /// returns a new [UNbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static ByteElement fromValues(int code, List<int> vList,
      {bool isEvr = true}) {
    final bytes = _makeLong(code, vList, kUNCode, isEvr, UN.kSizeInBytes)
      ..writeUint8VF(vList);
    assert(vList.length * UN.kSizeInBytes <= UN.kMaxVFLength);
    return (code == kPixelData)
        ? UNbytesPixelData.fromBytes(bytes)
        : fromBytes(bytes);
  }
}

/// 16-bit unsigned integer Elements (US, OW)
mixin Uint16Mixin {
  int get vfLength;
  Bytes get vfBytes;

  int get length => Uint16.getLength(vfLength);

  Uint16List get values => vfBytes.asUint16List();
}

class USbytes extends US with ByteElement<int>, Uint16Mixin {
  @override
  final DicomBytes bytes;

  /// Returns a new [USbytes] [Element].
  USbytes(this.bytes);

  /// Returns a new [USbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static USbytes fromBytes(DicomBytes bytes, [Charset _]) => USbytes(bytes);

  /// Returns a new [USbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static USbytes fromValues(int code, List<int> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kUSCode, isEvr, US.kSizeInBytes);
    if (bytes == null) return null;
    bytes.writeUint16VF(vList);
    assert(vList.length * US.kSizeInBytes <= US.kMaxVFLength);
    return fromBytes(bytes);
  }
}

class OWbytes extends OW with ByteElement<int>, Uint16Mixin {
  @override
  final DicomBytes bytes;

  /// Returns a new [OWbytes] [Element].
  OWbytes(this.bytes);

  /// Returns a new [OWbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static OWbytes fromBytes(DicomBytes bytes, [Charset _]) => OWbytes(bytes);

  // ignore: prefer_constructors_over_static_methods
  /// If [code] == [kPixelData] returns a [OWbytesPixelData]; otherwise,
  /// returns a new [OWbytes] [Element].
  static ByteElement fromValues(int code, List<int> vList,
      {bool isEvr = true}) {
    final bytes = _makeLong(code, vList, kOWCode, isEvr, OW.kSizeInBytes);
    if (bytes == null) return null;
    bytes.writeUint16VF(vList);
    assert(vList.length * OW.kSizeInBytes <= OW.kMaxVFLength);
    return (code == kPixelData)
        ? OWbytesPixelData.fromBytes(bytes)
        : fromBytes(bytes);
  }
}

/// 32-bit unsigned integer Elements (AT, UL, GL, OL)
mixin Uint32Mixin {
  int get vfLength;
  Bytes get vfBytes;

  int get length => Uint32.getLength(vfLength);

  Uint32List get values => vfBytes.asUint32List();
}

/// Attribute (Element) Code (AT)
class ATbytes extends AT with ByteElement<int>, Uint32Mixin {
  @override
  final DicomBytes bytes;

  /// Returns a new [ATbytes] [Element].
  ATbytes(this.bytes);

  /// Returns a new [ATbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static ATbytes fromBytes(DicomBytes bytes, [Charset _]) => ATbytes(bytes);

  /// Returns a new [ATbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static ATbytes fromValues(int code, List<int> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kATCode, isEvr, AT.kSizeInBytes);
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
  static OLbytes fromBytes(DicomBytes bytes, [Charset _]) => OLbytes(bytes);

  /// Returns a new [OLbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static OLbytes fromValues(int code, List<int> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kOLCode, isEvr, OL.kSizeInBytes);
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
  static ULbytes fromBytes(DicomBytes bytes, [Charset _]) =>
      // If the code is (gggg,0000) create a Group Length element
      (bytes.getUint16(2) == 0) ? GLbytes(bytes) : ULbytes(bytes);

  /// Returns a new [ULbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static ULbytes fromValues(int code, List<int> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kULCode, isEvr, UL.kSizeInBytes);
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
  static GLbytes fromBytes(DicomBytes bytes, [Charset _]) => GLbytes(bytes);

  /// Returns a new [GLbytes] [Element].
  // ignore: prefer_constructors_over_static_methods
  static GLbytes fromValues(int code, List<int> vList, {bool isEvr = true}) {
    final bytes = _makeShort(code, vList, kSSCode, isEvr, SS.kSizeInBytes);
    if (bytes == null) return null;
    bytes.writeUint8VF(vList);
    assert(vList.length * SS.kSizeInBytes <= SS.kMaxVFLength);
    return fromBytes(bytes);
  }

  static const String kVRKeyword = 'GL';
  static const String kVRName = 'Group Length';
}
