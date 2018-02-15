// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:core/src/element/base/bulkdata.dart';
import 'package:core/src/element/base/integer/integer.dart';
import 'package:core/src/element/base/integer/integer_mixin.dart';
import 'package:core/src/element/errors.dart';
import 'package:core/src/element/tag/tag_element.dart';
import 'package:core/src/tag/export.dart';

class IntBulkdata extends BulkdataRef<int> {
  @override
  int code;
  @override
  String uri;

  IntBulkdata(this.code, this.uri);

  @override
  List<int> get values => _values ??= getBulkdata(code, uri);
  List<int> _values;
}

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

  factory SStag.bulkdata(Tag tag, String url) => (SS.isNotValidTag(tag))
      ? null
      : new SStag._(tag, new IntBulkdata(tag.code, url));

  factory SStag._fromBytes(Tag tag, Uint8List bytes) =>
      (SS.isNotValidTag(tag)) ? null : new SStag._(tag, _i16FromBytes(bytes));

  SStag._(this.tag, this.values);

  @override
  SStag update([Iterable<int> vList = kEmptyIntList]) => new SStag(tag, vList);

  static SStag make<int>(Tag tag, Iterable<int> vList) =>
      new SStag(tag, vList ?? kEmptyDoubleList);

  static SStag fromBase64(Tag tag, String s) =>
      new SStag._fromBytes(tag, BASE64.decode(s));

  static SStag fromBytes(Tag tag, Uint8List bytes) =>
      new SStag._fromBytes(tag, bytes);

  static SStag fromBDE(Element bde) =>
      new SStag._fromBytes(bde.tag, bde.vfBytes);
}

Int16List _i16FromBytes(Uint8List bytes) => Int16Base.fromBytes(bytes);

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

  factory SLtag.bulkdata(Tag tag, String url) => (SL.isNotValidTag(tag))
      ? null
      : new SLtag._(tag, new IntBulkdata(tag.code, url));

  factory SLtag._fromBytes(Tag tag, Uint8List bytes) =>
      (SL.isNotValidTag(tag)) ? null : new SLtag._(tag, _i32FromBytes(bytes));

  SLtag._(this.tag, this.values);

  @override
  SLtag update([Iterable<int> vList = kEmptyIntList]) => new SLtag(tag, vList);

  static SLtag make<int>(Tag tag, Iterable<int> vList) =>
      new SLtag(tag, vList ?? kEmptyDoubleList);

  static SLtag fromBase64(Tag tag, String s) =>
      new SLtag._fromBytes(tag, BASE64.decode(s));

  static SLtag fromBytes(Tag tag, Uint8List bytes) =>
      new SLtag._fromBytes(tag, bytes);

  static SLtag fromBDE(Element bde) =>
      new SLtag._fromBytes(bde.tag, bde.vfBytes);
}

Int32List _i32FromBytes(Uint8List bytes) => Int32Base.fromBytes(bytes);

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

  factory OBtag.bulkdata(Tag tag, String url, [int vfLengthField]) =>
      new OBtag._(tag, new IntBulkdata(tag.code, url), vfLengthField);

  factory OBtag._fromBytes(Tag tag, Uint8List bytes, [int vfLengthField]) =>
      (OB.isNotValidTag(tag))
          ? null
          : new OBtag._(tag, _u8FromBytes(bytes), vfLengthField);

  OBtag._(this.tag, this.values, this.vfLengthField);

  @override
  OBtag update([Iterable<int> vList = kEmptyIntList]) => new OBtag(tag, vList);

  static OBtag make(Tag tag, Iterable<int> vList, [int vfLengthField]) =>
      new OBtag(tag, vList ?? kEmptyUint16List, vfLengthField);

  static OBtag fromBase64(Tag tag, String s) =>
      new OBtag._fromBytes(tag, BASE64.decode(s));

  static OBtag fromBytes(Tag tag, Uint8List bytes, [int vfLengthField]) =>
      new OBtag._fromBytes(tag, bytes, vfLengthField);

  static OBtag fromBDE(Element bde, [int vfLengthField]) =>
      new OBtag._fromBytes(bde.tag, bde.vfBytes, vfLengthField);
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
      (UN.isValidArgs(tag, vList))
          ? new UNtag._(tag, vList, vfLengthField)
          : invalidValuesError(vList, tag: tag);

  factory UNtag.bulkdata(Tag tag, String url, [int vfLengthField]) =>
      new UNtag._(tag, new IntBulkdata(tag.code, url), vfLengthField);

  factory UNtag._fromBytes(Tag tag, Uint8List bytes, [int vfLengthField]) =>
      (UN.isNotValidTag(tag))
          ? null
          : new UNtag._(tag, _u8FromBytes(bytes), vfLengthField);

  UNtag._(this.tag, this.values, this.vfLengthField);

  @override
  UNtag update([Iterable<int> vList = kEmptyIntList]) => new UNtag(tag, vList);

  static UNtag make(Tag tag, Iterable<int> vList, [int vfLengthField]) =>
      new UNtag(tag, vList ?? kEmptyUint16List, vfLengthField);

  static UNtag fromBase64(Tag tag, String s) =>
      new UNtag._fromBytes(tag, BASE64.decode(s));

  static UNtag fromBytes(Tag tag, Uint8List bytes, [int vfLengthField]) =>
      new UNtag._fromBytes(tag, bytes, vfLengthField);

  static UNtag fromBDE(Element bde, [int vfLengthField]) =>
      new UNtag._fromBytes(bde.tag, bde.vfBytes, vfLengthField);
}

Uint8List _u8FromBytes(Uint8List bytes) => Uint8Base.fromBytes(bytes);

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

  factory UStag.bulkdata(Tag tag, String url) => (US.isNotValidTag(tag))
      ? null
      : new UStag._(tag, new IntBulkdata(tag.code, url));

  factory UStag._fromBytes(Tag tag, Uint8List bytes) =>
      (US.isNotValidTag(tag)) ? null : new UStag._(tag, _u16FromBytes(bytes));

  UStag._(this.tag, this.values);

  @override
  UStag update([Iterable<int> vList]) =>
      new UStag(tag, vList ?? kEmptyUint16List);

  static UStag make(Tag tag, Iterable<int> vList) =>
      new UStag(tag, vList ?? kEmptyUint16List);

  static UStag fromBase64(Tag tag, String s) =>
      new UStag._fromBytes(tag, BASE64.decode(s));

  static UStag fromBytes(Tag tag, Uint8List bytes) =>
      new UStag._fromBytes(tag, bytes);

  static UStag fromBDE(Element bde) =>
      new UStag._fromBytes(bde.tag, bde.vfBytes);
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

  factory OWtag.bulkdata(Tag tag, String url, [int vfLengthField]) =>
      new OWtag._(tag, new IntBulkdata(tag.code, url), vfLengthField);

  factory OWtag._fromBytes(Tag tag, Uint8List bytes, [int vfLengthField]) =>
      (OW.isNotValidTag(tag))
          ? null
          : new OWtag._(tag, _u16FromBytes(bytes), vfLengthField);

  OWtag._(this.tag, this.values, this.vfLengthField);

  @override
  OWtag update([Iterable<int> vList = kEmptyIntList]) => new OWtag(tag, vList);

  static OWtag make(Tag tag, Iterable<int> vList, [int vfLengthField]) =>
      new OWtag(tag, vList ?? kEmptyUint16List, vfLengthField);

  static OWtag fromBase64(Tag tag, String s) =>
      new OWtag._fromBytes(tag, BASE64.decode(s));

  static OWtag fromBytes(Tag tag, Uint8List bytes, [int vfLengthField]) =>
      new OWtag._fromBytes(tag, bytes, vfLengthField);

  static OWtag fromBDE(Element bde, [int vfLengthField]) =>
      new OWtag._fromBytes(bde.tag, bde.vfBytes, vfLengthField);
}

Uint16List _u16FromBytes(Uint8List bytes) => Uint16Base.fromBytes(bytes);

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

  factory OLtag.bulkdata(Tag tag, String url) =>
      new OLtag._(tag, new IntBulkdata(tag.code, url));

  factory OLtag._fromBytes(Tag tag, Uint8List bytes) =>
      (OL.isNotValidTag(tag)) ? null : new OLtag._(tag, _u32FromBytes(bytes));

  OLtag._(this.tag, this.values);

  @override
  OLtag update([Iterable<int> vList = kEmptyIntList]) => new OLtag(tag, vList);

  static OLtag make<int>(Tag tag, Iterable<int> vList) =>
      new OLtag(tag, vList ?? kEmptyDoubleList);

  static OLtag fromBase64(Tag tag, String s) =>
      new OLtag._fromBytes(tag, BASE64.decode(s));

  static OLtag fromBytes(Tag tag, Uint8List bytes) =>
      new OLtag._fromBytes(tag, bytes);

  static OLtag fromBDE(Element bde) =>
      new OLtag._fromBytes(bde.tag, bde.vfBytes);
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

  factory ULtag.bulkdata(Tag tag, String url) =>
      new ULtag._(tag, new IntBulkdata(tag.code, url));

  factory ULtag._fromBytes(Tag tag, Uint8List bytes) =>
      (UL.isNotValidTag(tag)) ? null : new ULtag._(tag, _u32FromBytes(bytes));

  ULtag._(this.tag, this.values);

  @override
  ULtag update([Iterable<int> vList = kEmptyIntList]) => new ULtag(tag, vList);

  static ULtag make<int>(Tag tag, Iterable<int> vList) =>
      new ULtag(tag, vList ?? kEmptyDoubleList);

  static ULtag fromBase64(Tag tag, String s) =>
      new ULtag._fromBytes(tag, BASE64.decode(s));

  static ULtag fromBytes(Tag tag, Uint8List bytes) =>
      new ULtag._fromBytes(tag, bytes);

  static ULtag fromBDE(Element bde) =>
      new ULtag._fromBytes(bde.tag, bde.vfBytes);
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

  factory ATtag.bulkdata(Tag tag, String url) =>
      new ATtag._(tag, new IntBulkdata(tag.code, url));

  factory ATtag._fromBytes(Tag tag, Uint8List bytes) =>
      (AT.isNotValidTag(tag)) ? null : new ATtag._(tag, _u32FromBytes(bytes));

  ATtag._(this.tag, this.values);

  @override
  ATtag update([Iterable<int> vList = kEmptyIntList]) => new ATtag(tag, vList);

  static ATtag make<int>(Tag tag, Iterable<int> vList) =>
      new ATtag(tag, vList ?? kEmptyDoubleList);

  static ATtag fromBase64(Tag tag, String s) =>
      new ATtag._fromBytes(tag, BASE64.decode(s));

  static ATtag fromBytes(Tag tag, Uint8List bytes) =>
      new ATtag._fromBytes(tag, bytes);

  static ATtag fromBDE(Element bde) =>
      new ATtag._fromBytes(bde.tag, bde.vfBytes);
}

Uint32List _u32FromBytes(Uint8List bytes) => Uint32Base.fromBytes(bytes);
