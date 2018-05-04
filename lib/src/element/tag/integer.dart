//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/element/base.dart';
import 'package:core/src/element/tag/tag_element.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes/bytes.dart';
import 'package:core/src/value/empty_list.dart';
import 'package:core/src/value/uid/well_known/transfer_syntax.dart';

/// Short VRLength Signed Short
class SStag extends SS with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;

  /// Creates an [SStag] Element.
  factory SStag(Tag tag, [Iterable<int> vList]) => new SStag._(tag, vList);

  factory SStag.bulkdata(Tag tag, Uri url) =>
      new SStag._(tag, new IntBulkdataRef(tag.code, url));

  factory SStag._(Tag tag, Iterable<int> vList) {
    if (SS.isNotValidArgs(tag, vList)) return null;
    final v = (vList.isEmpty) ? kEmptyUint8List : vList;
    return new SStag._x(tag, v);
  }

  SStag._x(this.tag, this.values) : assert(tag.vrIndex == kSSIndex);

  @override
  SStag update([Iterable<int> vList]) => new SStag._(tag, vList);

  static SStag fromValues(Tag tag, Iterable<int> values,
          [int _, TransferSyntax __]) =>
      new SStag(tag, Int32.fromList(values));

  static SStag fromBytes(Tag tag, Bytes bytes) =>
      SS.isValidBytesArgs(tag, bytes)
          ? new SStag._x(tag, bytes.asInt16List())
          : badTagError(tag, SS);
}

/// Short VRLength Signed Long
class SLtag extends SL with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;

  /// Creates an [SLtag] Element.
  factory SLtag(Tag tag, [Iterable<int> vList]) => new SLtag._(tag, vList);

  factory SLtag.bulkdata(Tag tag, Uri url) =>
      new SLtag._(tag, new IntBulkdataRef(tag.code, url));

  factory SLtag._(Tag tag, Iterable<int> vList) {
    if (SL.isNotValidArgs(tag, vList)) return null;
    final v = (vList.isEmpty) ? kEmptyUint8List : vList;
    return new SLtag._x(tag, v);
  }

  SLtag._x(this.tag, this.values);

  @override
  SLtag update([Iterable<int> vList]) => new SLtag._(tag, vList);

  static SLtag fromValues(Tag tag, Iterable<int> vf,
          [int _, TransferSyntax __]) =>
      new SLtag(tag, Int32.fromList(vf));

  static SLtag fromBytes(Tag tag, Bytes bytes) =>
      SL.isValidBytesArgs(tag, bytes)
          ? new SLtag._(tag, bytes.asInt32List())
          : badTagError(tag, SL);
}

/// 8-bit unsigned integer.
class OBtag extends OB with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;
  @override
  int vfLengthField;

  /// Creates an [OBtag] Element.
  factory OBtag(Tag tag,
          [Iterable<int> vList, int vfLengthField, TransferSyntax ts]) =>
      new OBtag._(tag, vList, null, ts);

  factory OBtag.bulkdata(Tag tag, Uri url,
          [int vfLengthField, TransferSyntax ts]) =>
      new OBtag._(tag, new IntBulkdataRef(tag.code, url), vfLengthField, ts);

  factory OBtag._(Tag tag, Iterable<int> vList,
      [int vfLengthField, TransferSyntax ts]) {
    if (OB.isNotValidArgs(tag, vList)) return null;
    final v = (vList.isEmpty) ? kEmptyUint8List : vList;
    return (tag.code == kPixelData)
        ? new OBtagPixelData(tag, v, vfLengthField, ts)
        : new OBtag._x(tag, v, v.length);
  }

  OBtag._x(this.tag, this.values, this.vfLengthField);

  @override
  OBtag update([Iterable<int> vList = kEmptyIntList]) => new OBtag(tag, vList);

  static OBtag fromValues(Tag tag, Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts]) =>
      new OBtag(tag, Uint8.fromList(vList), vfLengthField, ts);

  static OBtag fromBytes(Tag tag, Bytes bytes,
          [int vfLengthField, TransferSyntax ts]) =>
      OB.isValidBytesArgs(tag, bytes, vfLengthField)
          ? new OBtag._x(tag, bytes.asUint8List(), vfLengthField)
          : badTagError(tag, OB);
}

/// Unsigned 8-bit (Uint8)  Pixel Data.
///
/// If encapsulated (compressed) then [fragments] must not be _null_. If
/// [fragments] == _null_ then the pixels are uncompressed and data is
/// contained in [values] or [vfBytes].
///
/// _Note_: Pixel Data Tag Elements do not have [VFFragments].
///         [VFFragments] must be converted before they are created.
class OBtagPixelData extends OBPixelData with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;
  @override
  final int vfLengthField;
  @override
  final TransferSyntax ts;

  /// Creates an [OBtagPixelData] Element from a [Iterable<int>]
  /// of byte values (0 - 255).
  factory OBtagPixelData(Tag tag,
          [Iterable<int> vList, int vfLengthField, TransferSyntax ts]) =>
      new OBtagPixelData._(tag, Uint8.fromList(vList), vfLengthField, ts);

  factory OBtagPixelData._(
      Tag tag, Iterable<int> vList, int vfLengthField, TransferSyntax ts) {
    if (_isNotOK(tag, kOBIndex)) return null;
    final v = (vList.isEmpty) ? kEmptyUint8List : vList;
    final vfLength = vList.length * OB.kSizeInBytes;
    if (!OB.isValidVFLength(vfLength, vfLengthField))
      return badVFLength(
          vfLength, OB.kMaxVFLength, OB.kSizeInBytes, vfLengthField);

    return new OBtagPixelData._x(tag, v, vfLengthField, ts);
  }

  OBtagPixelData._x(this.tag, this.values, this.vfLengthField, this.ts);

  @override
  OBtagPixelData update([Iterable<int> vList = kEmptyIntList]) =>
      new OBtagPixelData._(tag, vList, vfLength, ts);

  /// Creates an [OBtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  static OBtagPixelData fromValues(Tag tag, Uint8List pixels,
          [int vfLengthField, TransferSyntax ts]) =>
      new OBtagPixelData._(tag, pixels, vfLengthField, ts);

  /// Creates an [OBtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  static OBtagPixelData fromBytes(Tag tag, Bytes bytes,
          [int vfLengthField, TransferSyntax ts]) =>
      OB.isValidBytesArgs(tag, bytes, vfLengthField)
          ? new OBtagPixelData._(tag, bytes.asUint8List(), vfLengthField, ts)
          : badTagError(tag, OB);
}

/// Unsigned 8-bit integer with unknown VR (VR.kUN).
class UNtag extends UN with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;
  @override
  final int vfLengthField;

  /// Creates an [UNtag] Element.
  factory UNtag(Tag tag,
          [Iterable<int> vList, int vfLengthField, TransferSyntax ts]) =>
      new UNtag._(tag, vList, vfLengthField, ts);

  factory UNtag.bulkdata(Tag tag, Uri url,
          [int vfLengthField, TransferSyntax ts]) =>
      new UNtag._(tag, new IntBulkdataRef(tag.code, url), vfLengthField, ts);

  factory UNtag._(Tag tag, Iterable<int> vList, int vlf, TransferSyntax ts) {
    if (UN.isNotValidArgs(tag, vList)) return null;
    final v = (vList.isEmpty) ? kEmptyUint8List : vList;
    final vflf = _checkVFLength(vList.length, vlf);
    return (tag.code == kPixelData)
        ? new UNtagPixelData(tag, v, vflf, ts)
        : new UNtag._x(tag, v, vflf);
  }

  UNtag._x(this.tag, this.values, this.vfLengthField);

  @override
  UNtag update([Iterable<int> vList = kEmptyIntList]) => new UNtag(tag, vList);

  static UNtag fromValues(Tag tag, Iterable<int> vf,
          [int vfLengthField, TransferSyntax ts]) =>
      new UNtag._(tag, Uint8.fromList(vf), vfLengthField, ts);

  static UNtag fromBytes(Tag tag, Bytes bytes,
          [int vfLengthField, TransferSyntax ts]) =>
      OB.isValidBytesArgs(tag, bytes, vfLengthField)
          ? new UNtag._(tag, bytes.asUint8List(), vfLengthField, ts)
          : badTagError(tag, UN);
}

/// 8-bit Pixel Data.
/// If encapsulated (compressed) then [fragments] must not be _null_. If
/// [fragments] == _null_ then the pixels are uncompressed and data is
/// contained in [values] or [vfBytes].
///
/// _Note_: Pixel Data Tag Elements do not have [VFFragments].
///         [VFFragments] must be converted before they are created.
class UNtagPixelData extends UNPixelData with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;
  @override
  final int vfLengthField;
  @override
  final TransferSyntax ts;

  /// Creates an [UNtagPixelData] Element from a [Iterable<int>]
  /// of byte values (0 - 255).
  factory UNtagPixelData(Tag tag, Iterable<int> vList, int vfLengthField,
          [TransferSyntax ts]) =>
      fromValues(tag, Uint8.fromList(vList), vfLengthField, ts);

  factory UNtagPixelData._(
      Tag tag, Iterable<int> vList, int vfLengthField, TransferSyntax ts) {
    if (_isNotOK(tag, kUNIndex)) return null;
    final v = (vList.isEmpty) ? kEmptyUint8List : vList;
    final vlf = _checkVFLength(vList.length, vfLengthField);
    return new UNtagPixelData._x(tag, v, vlf, ts);
  }

  UNtagPixelData._x(this.tag, this.values, this.vfLengthField, this.ts);

  @override
  UNtagPixelData update([Iterable<int> vList]) =>
      new UNtagPixelData._(tag, vList, vfLength, ts);

  /// Creates an [UNtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  static UNtagPixelData fromValues(Tag tag, Uint8List bList,
          [int vfLengthField, TransferSyntax ts]) =>
      new UNtagPixelData._(tag, bList, vfLengthField, ts);

  /// Creates an [UNtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  static UNtagPixelData fromBytes(Tag tag, Bytes bytes,
          [int vfLengthField, TransferSyntax ts]) =>
      UN.isValidBytesArgs(tag, bytes, vfLengthField)
          ? new UNtagPixelData._(tag, bytes.asUint8List(), vfLengthField, ts)
          : badTagError(tag, UN);
}

/// Unsigned Short
class UStag extends US with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;

  /// Creates an [UStag] Element.
  factory UStag(Tag tag, [Iterable<int> vList]) => new UStag._(tag, vList);

  factory UStag.bulkdata(Tag tag, Uri url) =>
      new UStag._(tag, new IntBulkdataRef(tag.code, url));

  factory UStag._(Tag tag, Iterable<int> vList) {
    if (US.isNotValidArgs(tag, vList)) return null;
    final v = (vList.isEmpty) ? kEmptyUint16List : vList;
    return new UStag._x(tag, v);
  }

  UStag._x(this.tag, this.values);

  @override
  UStag update([Iterable<int> vList]) => new UStag._(tag, vList);

  static UStag fromValues(Tag tag, Iterable<int> vf,
          [int _, TransferSyntax __]) =>
      new UStag(tag, Uint16.fromList(vf));

  static UStag fromBytes(Tag tag, Bytes bytes) =>
      US.isValidBytesArgs(tag, bytes)
          ? new UStag._(tag, bytes.asUint16List())
          : badTagError(tag, US);
}

/// Other Word VR
/// Note: There is no OWPixelData since OW is always uncompressed.
class OWtag extends OW with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;
  @override
  final int vfLengthField;

  /// Creates an [OWtag] Element.
  factory OWtag(Tag tag,
          [Iterable<int> vList, int vfLengthField, TransferSyntax ts]) =>
      new OWtag._(tag, vList, vfLengthField, ts);

  factory OWtag.bulkdata(Tag tag, Uri url,
          [int vfLengthField, TransferSyntax ts]) =>
      new OWtag._(tag, new IntBulkdataRef(tag.code, url), vfLengthField, ts);

  factory OWtag._(Tag tag, Iterable<int> vList, int vlf, TransferSyntax ts) {
    vlf ??= vList.length * OW.kSizeInBytes;
    if (OW.isNotValidArgs(tag, vList)) return null;
    final v = (vList.isEmpty) ? kEmptyUint8List : vList;
    final vflf = OB._checkVFLength(vList.length, vlf);
    return (tag.code == kPixelData)
        ? new OWtagPixelData(tag, v, vflf, ts)
        : new OWtag._x(tag, v, vflf);
  }

  OWtag._x(this.tag, this.values, this.vfLengthField);

  @override
  OWtag update([Iterable<int> vList = kEmptyIntList]) => new OWtag(tag, vList);

  static OWtag fromValues(Tag tag, Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts]) =>
      new OWtag(tag, Uint8.fromList(vList), vfLengthField, ts);

  static OWtag fromBytes(Tag tag, Bytes bytes,
          [int vfLengthField, TransferSyntax ts]) =>
      OW.isValidBytesArgs(tag, bytes, vfLengthField)
          ? new OWtag._(tag, bytes.asUint16List(), vfLengthField, ts)
          : badTagError(tag, OW);
}

/// 8-bit Pixel Data.
/// If encapsulated (compressed) then [fragments] must not be _null_. If
/// [fragments] == _null_ then the pixels are uncompressed and data is
/// contained in [values] or [vfBytes].
///
/// _Note_: Pixel Data Tag Elements do not have [VFFragments].
///         [VFFragments] must be converted before they are created.
class OWtagPixelData extends OWPixelData with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;
  @override
  final int vfLengthField;
  @override
  final TransferSyntax ts;

  /// Creates an [OWtagPixelData] Element from a [Iterable<int>]
  /// of byte values (0 - kMax16BitValue).
  factory OWtagPixelData(Tag tag, Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts]) =>
      new OWtagPixelData._(tag, vList, vfLengthField, ts);

  factory OWtagPixelData._(
      Tag tag, Iterable<int> vList, int vfLengthField, TransferSyntax ts) {
    if (_isNotOK(tag, kOWIndex)) return null;
    final v = (vList.isEmpty) ? kEmptyUint8List : vList;
    final vlf = _checkVFLength(vList.length, vfLengthField);
    return new OWtagPixelData._x(tag, v, vlf, ts);
  }

  OWtagPixelData._x(this.tag, this.values, this.vfLengthField, this.ts);

  @override
  OWtagPixelData update([Iterable<int> vList = kEmptyIntList]) =>
      new OWtagPixelData._(tag, vList, vfLength, ts);

  /// Creates an [OWtagPixelData] Element from a [Uint8List].
  static OWtagPixelData fromValues(Tag tag, Uint16List vList,
          [int vfLengthField, TransferSyntax ts]) =>
      new OWtagPixelData._(tag, vList, vfLengthField, ts);

  /// Creates an [OWtagPixelData] Element from a [Uint8List].
  static OWtagPixelData fromBytes(Tag tag, Bytes bytes,
          [int vfLengthField, TransferSyntax ts]) =>
      OW.isValidBytesArgs(tag, bytes, vfLengthField)
          ? new OWtagPixelData._(tag, bytes.asUint16List(), vfLengthField, ts)
          : badTagError(tag, OW);
}

/// Other Long
class OLtag extends OL with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;

  /// Creates an [OLtag] Element.
  factory OLtag(Tag tag, [Iterable<int> vList]) => new OLtag._(tag, vList);

  factory OLtag.bulkdata(Tag tag, Uri url) =>
      new OLtag._(tag, new IntBulkdataRef(tag.code, url));

  factory OLtag._(Tag tag, Iterable<int> vList) {
    if (OL.isNotValidArgs(tag, vList)) return null;
    final v = (vList.isEmpty) ? kEmptyUint8List : vList;
    return new OLtag._x(tag, v);
  }

  OLtag._x(this.tag, this.values);

  @override
  OLtag update([Iterable<int> vList]) => new OLtag._(tag, vList);

  static OLtag fromValues(Tag tag, Iterable<int> vf,
          [int _, TransferSyntax __]) =>
      new OLtag(tag, Int32.fromList(vf));

  static OLtag fromBytes(Tag tag, Bytes bytes) =>
      OL.isValidBytesArgs(tag, bytes)
          ? new OLtag._(tag, bytes.asUint32List())
          : badTagError(tag, OL);
}

/// Unsigned Short
class ULtag extends UL with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;

  /// Creates an [ULtag] Element.
  factory ULtag(Tag tag, [Iterable<int> vList]) => new ULtag._(tag, vList);

  factory ULtag.bulkdata(Tag tag, Uri url) =>
      new ULtag._(tag, new IntBulkdataRef(tag.code, url));

  factory ULtag._(Tag tag, Iterable<int> vList) {
    if (UL.isNotValidArgs(tag, vList)) return null;
    final v = (vList.isEmpty) ? kEmptyUint8List : vList;
    return new ULtag._x(tag, v);
  }

  ULtag._x(this.tag, this.values);

  @override
  ULtag update([Iterable<int> vList]) => new ULtag._(tag, vList);

  static ULtag fromValues(Tag tag, Iterable<int> vf,
          [int _, TransferSyntax __]) =>
      new ULtag(tag, Int32.fromList(vf));

  static ULtag fromBytes(Tag tag, Bytes bytes) =>
      UL.isValidBytesArgs(tag, bytes)
          ? new ULtag._(tag, bytes.asUint32List())
          : badTagError(tag, UL);
}

/// Unsigned Short
class GLtag extends ULtag {
  /// Creates an [GLtag] Element.
  factory GLtag(Tag tag, [Iterable<int> vList]) => new GLtag._(tag, vList);

  factory GLtag.bulkdata(Tag tag, Uri url) =>
      new GLtag._(tag, new IntBulkdataRef(tag.code, url));

  factory GLtag._(Tag tag, Iterable<int> vList) {
    if (UL.isNotValidArgs(tag, vList)) return null;
    final v = (vList.isEmpty) ? kEmptyUint8List : vList;
    return new GLtag._x(tag, v);
  }

  GLtag._x(Tag tag, Iterable<int> values) : super._x(tag, values);

  @override
  GLtag update([Iterable<int> vList]) => new GLtag._(tag, vList);

  static GLtag fromValues(Tag tag, Iterable<int> vf) =>
      new GLtag(tag, Uint8.fromList(vf));

  static GLtag fromBytes(Tag tag, Bytes bytes, [int _, TransferSyntax __]) => GL
          .isValidBytesArgs(tag, bytes)
      ? (UL.isNotValidTag(tag)) ? null : new GLtag._(tag, bytes.asUint32List())
      : badTagError(tag, UL);
}

/// Immutable Attribute Tags
///
/// Note: Tags are implemented as a 32-bit integers, not 2 16-bit integers.
/// Other Long
class ATtag extends AT with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;

  /// Creates an [ATtag] Element.
  factory ATtag(Tag tag, [Iterable<int> vList]) => new ATtag._(tag, vList);

  factory ATtag.bulkdata(Tag tag, Uri url) =>
      new ATtag._(tag, new IntBulkdataRef(tag.code, url));

  factory ATtag._(Tag tag, Iterable<int> vList) {
    if (AT.isNotValidArgs(tag, vList)) return null;
    final v = (vList.isEmpty) ? kEmptyUint8List : vList;
    return new ATtag._x(tag, v);
  }

  ATtag._x(this.tag, this.values);

  @override
  ATtag update([Iterable<int> vList]) => new ATtag._(tag, vList);

  static ATtag fromValues(Tag tag, Iterable<int> vf,
          [int _, TransferSyntax __]) =>
      new ATtag(tag, Int32.fromList(vf));

  static ATtag fromBytes(Tag tag, Bytes bytes) =>
      (AT.isValidBytesArgs(tag, bytes))
          ? new ATtag._(tag, bytes.asUint32List())
          : badTagError(tag, AT);
}

bool _isNotOK(Tag tag, int vrIndex) {
  assert(tag.code == kPixelData);
  if (Tag.isValidVR(tag, vrIndex)) return false;
  badTagError(tag, OWtagPixelData);
  return true;
}

int _checkVFLength(int vfLength, int max, [int eSize, int vfLengthField]) {
  if (vfLengthField == null) return vfLength;
  return (vfLengthField != vfLength || vfLengthField != vfLengthField)
      ? badVFLength(vfLength, max, eSize, vfLengthField)
      : vfLength;
}

/// Returns [vfLengthField] is it is valid.
int _checkVFL(int vfLength, int vfLengthField) =>
    (vfLengthField == kUndefinedLength || vfLengthField == vfLength)
        ? vfLengthField
        : null;
