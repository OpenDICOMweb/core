// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/element/base.dart';
import 'package:core/src/element/tag/tag_element.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes/bytes.dart';
import 'package:core/src/utils/empty_list.dart';

/// Short VRLength Signed Short
class SStag extends SS with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;

  /// Creates an [SStag] Element.
  factory SStag(Tag tag, [Iterable<int> vList = kEmptyIntList]) =>
      (SS.isValidArgs(tag, vList))
          ? new SStag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  factory SStag.bulkdata(Tag tag, Uri url) => (SS.isNotValidTag(tag))
      ? null
      : new SStag._(tag, new IntBulkdataRef(tag.code, url));

  SStag._(this.tag, this.values);

  @override
  SStag update([Iterable<int> vList = kEmptyIntList]) => new SStag(tag, vList);

  static SStag make<int>(Tag tag, Iterable<int> vf) =>
      new SStag(tag, Int16.fromValueField(vf));

  static SStag fromBase64(Tag tag, String s) =>
      fromBytes(tag, Bytes.base64Decode(s));

  static SStag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.fromTypedData(bytes));

  static SStag from(Element bde) => fromBytes(bde.tag, bde.vfBytes);

  static SStag fromBytes(Tag tag, Bytes bytes, [int _]) =>
      (SS.isNotValidTag(tag)) ? null : new SStag._(tag, bytes.asInt16List());
}

/// Short VRLength Signed Long
class SLtag extends SL with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;

  /// Creates an [SLtag] Element.
  factory SLtag(Tag tag, [Iterable<int> vList = kEmptyIntList]) =>
      (SL.isValidArgs(tag, vList))
          ? new SLtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  factory SLtag.bulkdata(Tag tag, Uri url) => (SL.isNotValidTag(tag))
      ? null
      : new SLtag._(tag, new IntBulkdataRef(tag.code, url));

  SLtag._(this.tag, this.values);

  @override
  SLtag update([Iterable<int> vList = kEmptyIntList]) => new SLtag(tag, vList);

  static SLtag make<int>(Tag tag, Iterable<int> vf) =>
      new SLtag(tag, Int32.fromValueField(vf));

  static SLtag fromBase64(Tag tag, String s) =>
      fromBytes(tag, Bytes.base64Decode(s));

  static SLtag fromUint8List(Tag tag, Uint8List bList) =>
      fromBytes(tag, new Bytes.fromTypedData(bList));

  static SLtag from(Element bde) => fromBytes(bde.tag, bde.vfBytes);
  
  static SLtag fromBytes(Tag tag, Bytes bytes, [int _]) =>
      (SL.isNotValidTag(tag)) ? null : new SLtag._(tag, bytes.asInt32List());
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
          [Iterable<int> vList = IntBase.kEmptyList, int vfLengthField]) =>
      (OB.isValidArgs(tag, vList))
          ? new OBtag._(tag, vList, vfLengthField)
          : invalidValuesError(vList, tag: tag);

  factory OBtag.bulkdata(Tag tag, Uri url, [int vfLengthField]) =>
      new OBtag._(tag, new IntBulkdataRef(tag.code, url), vfLengthField);

  OBtag._(this.tag, this.values, this.vfLengthField);

  @override
  OBtag update([Iterable<int> vList = kEmptyIntList]) => new OBtag(tag, vList);

  static OBtag make(Tag tag, Iterable<int> vf, [int vfLengthField]) =>
      new OBtag(tag, Uint8.fromValueField(vf), vfLengthField);

  static OBtag fromBase64(Tag tag, String s) =>
      fromBytes(tag, Bytes.base64Decode(s));

  static OBtag fromUint8List(Tag tag, Uint8List bList, [int vfLengthField]) =>
      fromBytes(tag, new Bytes.fromTypedData(bList), vfLengthField);

  static OBtag from(Element bde, [int vfLengthField]) =>
      fromBytes(bde.tag, bde.vfBytes, vfLengthField);

  static OBtag fromBytes(Tag tag, Bytes bytes, [int vfLengthField]) =>
      (OB.isNotValidTag(tag))
          ? null
          : new OBtag._(tag, bytes.asUint8List(), vfLengthField);
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
          [Iterable<int> vList = IntBase.kEmptyList, int vfLengthField]) =>
      //   (UN.isValidArgs(tag, vList))
      new UNtag._(tag, vList, vfLengthField);
  //       : invalidValuesError(vList, tag: tag);

  factory UNtag.bulkdata(Tag tag, Uri url, [int vfLengthField]) =>
      new UNtag._(tag, new IntBulkdataRef(tag.code, url), vfLengthField);

  UNtag._(this.tag, this.values, this.vfLengthField);

  @override
  UNtag update([Iterable<int> vList = kEmptyIntList]) => new UNtag(tag, vList);

  static UNtag make(Tag tag, Iterable<int> vf, [int vfLengthField]) =>
      new UNtag(tag, Uint8.fromValueField(vf), vfLengthField);

  static UNtag fromBase64(Tag tag, String s) =>
      fromBytes(tag, Bytes.base64Decode(s));

  static UNtag fromUint8List(Tag tag, Uint8List bList, [int vfLengthField]) =>
      fromBytes(tag, new Bytes.fromTypedData(bList), vfLengthField);

  static UNtag from(Element bde, [int vfLengthField]) =>
      fromBytes(bde.tag, bde.vfBytes, vfLengthField);

  static UNtag fromBytes(Tag tag, Bytes bytes, [int vfLengthField]) =>
      (UN.isNotValidTag(tag))
          ? null
          : new UNtag._(tag, bytes.asUint8List(), vfLengthField);
}

/// Unsigned Short
class UStag extends US with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;

  /// Creates an [UStag] Element.
  factory UStag(Tag tag, [Iterable<int> vList = kEmptyIntList]) =>
      (US.isValidArgs(tag, vList))
          ? new UStag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  factory UStag.bulkdata(Tag tag, Uri url) => (US.isNotValidTag(tag))
      ? null
      : new UStag._(tag, new IntBulkdataRef(tag.code, url));

  UStag._(this.tag, this.values);

  @override
  UStag update([Iterable<int> vf]) => new UStag(tag, Uint16.fromValueField(vf));

  static UStag make(Tag tag, Iterable<int> vList) =>
      new UStag(tag, vList ?? kEmptyUint16List);

  static UStag fromBase64(Tag tag, String s) =>
      fromBytes(tag, Bytes.base64Decode(s));

  static UStag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.fromTypedData(bytes));

  static UStag from(Element bde) => fromBytes(bde.tag, bde.vfBytes);

  static UStag fromBytes(Tag tag, Bytes bytes, [int _]) =>
      (US.isNotValidTag(tag)) ? null : new UStag._(tag, bytes.asUint16List());
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
          [Iterable<int> vList = IntBase.kEmptyList, int vfLengthField]) =>
      (OW.isValidArgs(tag, vList))
          ? new OWtag._(tag, vList, vfLengthField)
          : invalidValuesError(vList, tag: tag);

  factory OWtag.bulkdata(Tag tag, Uri url, [int vfLengthField]) =>
      new OWtag._(tag, new IntBulkdataRef(tag.code, url), vfLengthField);

  OWtag._(this.tag, this.values, this.vfLengthField);

  @override
  OWtag update([Iterable<int> vList = kEmptyIntList]) => new OWtag(tag, vList);

  static OWtag make(Tag tag, Iterable<int> vf, [int vfLengthField]) =>
      new OWtag._(tag, Uint16.fromValueField(vf), vfLengthField);

  static OWtag fromBase64(Tag tag, String s) =>
      fromBytes(tag, Bytes.base64Decode(s));

  static OWtag fromUint8List(Tag tag, Uint8List bList, [int vfLengthField]) =>
      fromBytes(tag, new Bytes.fromTypedData(bList), vfLengthField);

  static OWtag from(Element bde, [int vfLengthField]) =>
      fromBytes(bde.tag, bde.vfBytes, vfLengthField);
  
  static OWtag fromBytes(Tag tag, Bytes bytes, [int vfLengthField]) =>
      (OW.isNotValidTag(tag))
          ? null
          : new OWtag._(tag, bytes.asUint16List(), vfLengthField);
}

/// Other Long
class OLtag extends OL with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;

  /// Creates an [OLtag] Element.
  factory OLtag(Tag tag, [Iterable<int> vList = kEmptyIntList]) =>
      (OL.isValidArgs(tag, vList))
          ? new OLtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  factory OLtag.bulkdata(Tag tag, Uri url) =>
      new OLtag._(tag, new IntBulkdataRef(tag.code, url));

  OLtag._(this.tag, this.values);

  @override
  OLtag update([Iterable<int> vList = kEmptyIntList]) => new OLtag(tag, vList);

  static OLtag make<int>(Tag tag, Iterable<int> vf) =>
      new OLtag(tag, Uint32.fromValueField(vf));

  static OLtag fromBase64(Tag tag, String s) =>
      fromBytes(tag, Bytes.base64Decode(s));

  static OLtag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.fromTypedData(bytes));

  static OLtag from(Element bde) => fromBytes(bde.tag, bde.vfBytes);

  static OLtag fromBytes(Tag tag, Bytes bytes, [int _]) =>
      (OL.isNotValidTag(tag)) ? null : new OLtag._(tag, bytes.asUint32List());
}

/// Unsigned Short
class ULtag extends UL with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;

  /// Creates an [ULtag] Element.
  factory ULtag(Tag tag, [Iterable<int> vList = kEmptyIntList]) =>
      (UL.isValidArgs(tag, vList))
          ? new ULtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  factory ULtag.bulkdata(Tag tag, Uri url) =>
      new ULtag._(tag, new IntBulkdataRef(tag.code, url));

  ULtag._(this.tag, this.values);

  @override
  ULtag update([Iterable<int> vList = kEmptyIntList]) => new ULtag(tag, vList);

  static ULtag make<int>(Tag tag, Iterable<int> vf) =>
      new ULtag(tag, Uint32.fromValueField(vf));

  static ULtag fromBase64(Tag tag, String s) =>
      fromBytes(tag, Bytes.base64Decode(s));

  static ULtag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.fromTypedData(bytes));

  static ULtag from(Element bde) => fromBytes(bde.tag, bde.vfBytes);

  static ULtag fromBytes(Tag tag, Bytes bytes, [int _]) =>
      (UL.isNotValidTag(tag)) ? null : new ULtag._(tag, bytes.asUint32List());
}

/// Unsigned Short
class GLtag extends ULtag {
  /// Creates an [GLtag] Element.
  factory GLtag(Tag tag, [Iterable<int> vList = kEmptyIntList]) =>
      (UL.isValidArgs(tag, vList))
          ? new GLtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  factory GLtag.bulkdata(Tag tag, Uri url) =>
      new GLtag._(tag, new IntBulkdataRef(tag.code, url));

  GLtag._(Tag tag, Iterable<int> values) : super._(tag, values);

  @override
  GLtag update([Iterable<int> vList = kEmptyIntList]) => new GLtag(tag, vList);

  static GLtag make<int>(Tag tag, Iterable<int> vf) =>
      new GLtag(tag, Uint8.fromValueField(vf));

  //static GLtag from<int>(Element e) => new GLtag(e.tag, e.values);

  static GLtag fromBase64(Tag tag, String s) =>
      fromBytes(tag, Bytes.base64Decode(s));

  static GLtag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.fromTypedData(bytes));

  static GLtag from(Element e) => fromBytes(e.tag, e.vfBytes);

  static GLtag fromBytes(Tag tag, Bytes bytes, [int _]) =>
      (UL.isNotValidTag(tag)) ? null : new GLtag._(tag, bytes.asUint32List());
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
  factory ATtag(Tag tag, [Iterable<int> vList = kEmptyIntList]) =>
      (AT.isValidArgs(tag, vList))
          ? new ATtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  factory ATtag.bulkdata(Tag tag, Uri url) =>
      new ATtag._(tag, new IntBulkdataRef(tag.code, url));

  ATtag._(this.tag, this.values);

  @override
  ATtag update([Iterable<int> vList = kEmptyIntList]) => new ATtag(tag, vList);

  static ATtag make<int>(Tag tag, Iterable<int> vf) =>
      new ATtag(tag, Uint32.fromValueField(vf));

  static ATtag fromBase64(Tag tag, String s) =>
      fromBytes(tag, Bytes.base64Decode(s));

  static ATtag fromUint8List(Tag tag, Uint8List bList) =>
      fromBytes(tag, new Bytes.fromTypedData(bList));

  static ATtag from(Element bde) => fromBytes(bde.tag, bde.vfBytes);

  static ATtag fromBytes(Tag tag, Bytes bytes, [int _]) =>
      (AT.isNotValidTag(tag)) ? null : new ATtag._(tag, bytes.asUint32List());
}
