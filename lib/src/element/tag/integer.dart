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
import 'package:core/src/error/element_errors.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/primitives.dart';
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
    if (!SS.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    return new SStag._x(tag, Int16.fromList(vList));
  }

  SStag._x(this.tag, this.values) : assert(tag.vrIndex == kSSIndex);

  @override
  SStag update([Iterable<int> vList]) => new SStag._(tag, vList);

  static SStag fromValues(Tag tag, Iterable<int> vList,
          [int _, TransferSyntax __]) =>
      new SStag._(tag, vList);

  static SStag fromBytes(Tag tag, Bytes bytes) =>
      SS.isValidBytesArgs(tag, bytes)
          ? new SStag._x(tag, bytes.asInt16List())
          : badTag(tag, null, SS);
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
    if (!SL.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    return new SLtag._x(tag, Int32.fromList(vList));
  }

  SLtag._x(this.tag, this.values) : assert(tag.vrIndex == kSLIndex);

  @override
  SLtag update([Iterable<int> vList]) => new SLtag._(tag, vList);

  static SLtag fromValues(Tag tag, Iterable<int> vList,
          [int _, TransferSyntax __]) =>
      new SLtag._(tag, vList);

  static SLtag fromBytes(Tag tag, Bytes bytes) =>
      SL.isValidBytesArgs(tag, bytes)
          ? new SLtag._(tag, bytes.asInt32List())
          : badTag(tag, null, SL);
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
      new OBtag._(tag, vList, vfLengthField, ts);

  factory OBtag.bulkdata(Tag tag, Uri url,
          [int vfLengthField, TransferSyntax ts]) =>
      new OBtag._(tag, new IntBulkdataRef(tag.code, url), vfLengthField, ts);

  factory OBtag._(Tag tag, Iterable<int> vList, [int vlf, TransferSyntax ts]) {
    if (!OB.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    final v = Uint8.fromList(vList);
    return (tag.code == kPixelData)
        ? new OBtagPixelData._x(v, vlf, ts)
        : new OBtag._x(tag, v, v.length);
  }

  OBtag._x(this.tag, this.values, this.vfLengthField)
      : assert(tag.vrIndex == kOBIndex || tag.vrIndex == kOBOWIndex);

  @override
  OBtag update([Iterable<int> vList = kEmptyIntList]) =>
      new OBtag._(tag, vList);

  static OBtag fromValues(Tag tag, Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts]) =>
      new OBtag._(tag, Uint8.fromList(vList), vfLengthField, ts);

  static OBtag fromBytes(Tag tag, Bytes bytes,
          [int vfLengthField, TransferSyntax ts]) =>
      OB.isValidBytesArgs(tag, bytes, vfLengthField)
          ? new OBtag._x(tag, bytes.asUint8List(), vfLengthField)
          : badTag(tag, null, OB);
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
  final Tag tag = PTag.kPixelDataOB;
  @override
  Iterable<int> values;
  @override
  final int vfLengthField;
  @override
  final TransferSyntax ts;

  /// Creates an [OBtagPixelData] Element from a [Iterable<int>].
  factory OBtagPixelData(Tag tag,
          [Iterable<int> vList, int vfLengthField, TransferSyntax ts]) =>
      new OBtagPixelData._(tag, vList, vfLengthField, ts);

  factory OBtagPixelData.bulkdata(Tag tag, Uri url,
          [int vfLengthField, TransferSyntax ts]) =>
      new OBtagPixelData._(
          tag, new IntBulkdataRef(tag.code, url), vfLengthField, ts);

  factory OBtagPixelData._(Tag tag, Iterable<int> vList,
          [int vlf, TransferSyntax ts]) =>
      (OBPixelData.isValidArgs(tag, vList, vlf, ts))
          ? new OBtagPixelData._x(Uint8.fromList(vList), vlf, ts)
          : badValues(vList, null, tag);

  OBtagPixelData._x(this.values, this.vfLengthField, this.ts);

  @override
  OBtagPixelData update([Iterable<int> vList]) =>
      new OBtagPixelData._(tag, vList);

  /// Creates an [OBtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  static OBtagPixelData fromValues(Tag tag, Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts]) =>
      new OBtagPixelData._(tag, vList, vfLengthField, ts);

  /// Creates an [OBtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  static OBtagPixelData fromBytes(Tag tag, Bytes bytes,
          [int vfLengthField, TransferSyntax ts]) =>
      OBPixelData.isValidBytesArgs(tag, bytes, vfLengthField)
          ? new OBtagPixelData._x(bytes.asUint8List(), vfLengthField, ts)
          : badTag(tag, null, OB);
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

  factory UNtag._(Tag tag, Iterable<int> vList, [int vlf, TransferSyntax ts]) {
    if (!UN.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    final v = Uint8.fromList(vList);
    return (tag.code == kPixelData)
        ? new UNtagPixelData._x(v, vlf, ts)
        : new UNtag._x(tag, v, v.length);
  }

  UNtag._x(this.tag, this.values, this.vfLengthField);

  @override
  UNtag update([Iterable<int> vList = kEmptyIntList]) => new UNtag(tag, vList);

  static UNtag fromValues(Tag tag, Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts]) =>
      new UNtag._(tag, vList, vfLengthField, ts);

  static UNtag fromBytes(Tag tag, Bytes bytes,
          [int vfLengthField, TransferSyntax ts]) =>
      UN.isValidBytesArgs(tag, bytes, vfLengthField)
          ? new UNtag._(tag, bytes.asUint8List(), vfLengthField, ts)
          : badTag(tag, null, UN);
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
  final Tag tag = PTag.kPixelDataUN;
  @override
  Iterable<int> values;
  @override
  final int vfLengthField;
  @override
  final TransferSyntax ts;

  /// Creates an [UNtagPixelData] Element from a [Iterable<int>].
  factory UNtagPixelData(Tag tag,
          [Iterable<int> vList, int vfLengthField, TransferSyntax ts]) =>
      new UNtagPixelData._(tag, vList, vfLengthField, ts);

  factory UNtagPixelData.bulkdata(Tag tag, Uri url,
          [int vfLengthField, TransferSyntax ts]) =>
      new UNtagPixelData._(
          tag, new IntBulkdataRef(tag.code, url), vfLengthField, ts);

  factory UNtagPixelData._(Tag tag, Iterable<int> vList,
          [int vlf, TransferSyntax ts]) =>
      (UNPixelData.isValidArgs(tag, vList))
          ? new UNtagPixelData._x(Uint8.fromList(vList), vlf, ts)
          : badValues(vList, null, tag);

  UNtagPixelData._x(this.values, this.vfLengthField, this.ts);

  @override
  UNtagPixelData update([Iterable<int> vList]) =>
      new UNtagPixelData._(tag, vList);

  /// Creates an [UNtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  static UNtagPixelData fromValues(Tag tag, Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts]) =>
      new UNtagPixelData._(tag, vList, vfLengthField, ts);

  /// Creates an [UNtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  static UNtagPixelData fromBytes(Tag tag, Bytes bytes,
          [int vfLengthField, TransferSyntax ts]) =>
      UNPixelData.isValidBytesArgs(tag, bytes, vfLengthField)
          ? new UNtagPixelData._x(bytes.asUint8List(), vfLengthField, ts)
          : badTag(tag, null, UN);
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
    vList ??= <int>[];
    if (!US.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    return new UStag._x(tag, Uint16.fromList(vList));
  }

  UStag._x(this.tag, this.values);

  @override
  UStag update([Iterable<int> vList]) => new UStag._(tag, vList);

  static UStag fromValues(Tag tag, Iterable<int> vList,
          [int _, TransferSyntax __]) =>
      new UStag(tag, vList);

  static UStag fromBytes(Tag tag, Bytes bytes) =>
      US.isValidBytesArgs(tag, bytes)
          ? new UStag._x(tag, bytes.asUint16List())
          : badTag(tag, null, US);
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

  factory OWtag._bulkdata(Tag tag, Uri url,
          [int vfLengthField, TransferSyntax ts]) =>
      new OWtag._(tag, new IntBulkdataRef(tag.code, url), vfLengthField, ts);

  factory OWtag._(Tag tag, Iterable<int> vList, int vlf, TransferSyntax ts) {
    if (!OW.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    final v = Uint16.fromList(vList);
    return (tag.code == kPixelData)
        ? new OWtagPixelData._(tag, v, vlf, ts)
        : new OWtag._x(tag, v, vlf);
  }

  OWtag._x(this.tag, this.values, this.vfLengthField)
      : assert(tag.vrIndex == kOWIndex || tag.vrIndex == kOBOWIndex,
            'vrIndex: ${tag.vrIndex}');

  @override
  OWtag update([Iterable<int> vList = kEmptyIntList]) => new OWtag(tag, vList);

  static OWtag fromValues(Tag tag, Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts]) =>
      new OWtag(tag, vList, vfLengthField, ts);

  static OWtag fromBytes(Tag tag, Bytes bytes,
          [int vfLengthField, TransferSyntax ts]) =>
      OW.isValidBytesArgs(tag, bytes, vfLengthField)
          ? new OWtag._(tag, bytes.asUint16List(), vfLengthField, ts)
          : badTag(tag, null, OW);
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
  final Tag tag = PTag.kPixelDataOW;
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

  factory OWtagPixelData._bulkdata(Tag tag, Uri url,
          [int vfLengthField, TransferSyntax ts]) =>
      new OWtagPixelData._(
          tag, new IntBulkdataRef(tag.code, url), vfLengthField, ts);

  factory OWtagPixelData._(Tag tag, Iterable<int> vList,
          [int vlf, TransferSyntax ts]) =>
      (OWPixelData.isValidArgs(tag, vList))
          ? new OWtagPixelData._x(Uint16.fromList(vList), vlf, ts)
          : badValues(vList, null, tag);

  OWtagPixelData._x(this.values, this.vfLengthField, this.ts);

  @override
  OWtagPixelData update([Iterable<int> vList]) =>
      new OWtagPixelData._(tag, vList);

  /// Creates an [OWtagPixelData] Element from a [Uint8List].
  static OWtagPixelData fromValues(Tag tag, Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts]) =>
      new OWtagPixelData._(tag, vList, vfLengthField, ts);

  /// Creates an [OWtagPixelData] Element from a [Uint8List].
  static OWtagPixelData fromBytes(Tag tag, Bytes bytes,
          [int vfLengthField, TransferSyntax ts]) =>
      OWPixelData.isValidBytesArgs(tag, bytes, vfLengthField)
          ? new OWtagPixelData._x(bytes.asUint16List(), vfLengthField, ts)
          : badTag(tag, null, OW);
}

/// Other Long
class OLtag extends OL with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;

  /// Creates an [OLtag] Element.
  factory OLtag(Tag tag, [Iterable<int> vList]) => new OLtag._(tag, vList);

  factory OLtag._bulkdata(Tag tag, Uri url) =>
      new OLtag._(tag, new IntBulkdataRef(tag.code, url));

  factory OLtag._(Tag tag, Iterable<int> vList) {
    if (!OL.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    final v = Uint32.fromList(vList);
    return new OLtag._x(tag, v);
  }

  OLtag._x(this.tag, this.values) : assert(tag.vrIndex == kOLIndex);

  @override
  OLtag update([Iterable<int> vList]) => new OLtag._(tag, vList);

  static OLtag fromValues(Tag tag, Iterable<int> vList) =>
      new OLtag._(tag, vList);

  static OLtag fromBytes(Tag tag, Bytes bytes) =>
      OL.isValidBytesArgs(tag, bytes)
          ? new OLtag._x(tag, bytes.asUint32List())
          : badTag(tag, null, OL);
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
    if (!UL.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    final v = Uint32.fromList(vList);
    return new ULtag._x(tag, v);
  }

  ULtag._x(this.tag, this.values) : assert(tag.vrIndex == kULIndex);

  @override
  ULtag update([Iterable<int> vList]) => new ULtag._(tag, vList);

  static ULtag fromValues(Tag tag, Iterable<int> vLIst) =>
      new ULtag._(tag, vLIst);

  static ULtag fromBytes(Tag tag, Bytes bytes) =>
      UL.isValidBytesArgs(tag, bytes)
          ? new ULtag._(tag, bytes.asUint32List())
          : badTag(tag, null, UL);
}

/// Unsigned Short
class GLtag extends ULtag {
  /// Creates an [GLtag] Element.
  factory GLtag(Tag tag, [Iterable<int> vList]) => new GLtag._(tag, vList);

  factory GLtag.bulkdata(Tag tag, Uri url) =>
      new GLtag._(tag, new IntBulkdataRef(tag.code, url));

  factory GLtag._(Tag tag, Iterable<int> vList) {
    if (!GL.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    final v = Uint32.fromList(vList);
    return new GLtag._x(tag, v);
  }

  GLtag._x(Tag tag, Iterable<int> values) : super._x(tag, values);

  @override
  GLtag update([Iterable<int> vList]) => new GLtag._(tag, vList);

  static GLtag fromValues(Tag tag, Iterable<int> vList) =>
      new GLtag(tag, vList);

  static GLtag fromBytes(Tag tag, Bytes bytes) =>
      GL.isValidBytesArgs(tag, bytes)
          ? new GLtag._x(tag, bytes.asUint32List())
          : badTag(tag, null, GL);
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
    if (!AT.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    final v = Uint32.fromList(vList);
    return new ATtag._x(tag, v);
  }

  ATtag._x(this.tag, this.values) : assert(tag.vrIndex == kATIndex);

  @override
  ATtag update([Iterable<int> vList]) => new ATtag._(tag, vList);

  static ATtag fromValues(Tag tag, Iterable<int> vList) =>
      new ATtag._(tag, vList);

  static ATtag fromBytes(Tag tag, Bytes bytes) =>
      (AT.isValidBytesArgs(tag, bytes))
          ? new ATtag._x(tag, bytes.asUint32List())
          : badTag(tag, null, AT);
}
