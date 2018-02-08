// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:core/src/element/base/bulkdata.dart';
import 'package:core/src/element/base/integer.dart';
import 'package:core/src/element/byte_data/bd_element.dart';
import 'package:core/src/element/errors.dart';
import 'package:core/src/element/tag/tag_element.dart';
import 'package:core/src/tag/tag.dart';

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

/// Returns [vfLengthField] is it is valid.
int _checkVFL(Uint8List bytes, int vfLengthField) =>
    (vfLengthField == kUndefinedLength || vfLengthField == bytes.length)
        ? vfLengthField
        : null;

/// Short VRLength Signed Short
class SStag extends SS with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;

  factory SStag(Tag tag, [Iterable<int> vList = kEmptyIntList]) =>
      (SS.isValidArgs(tag, vList))
          ? new SStag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  SStag._(this.tag, this.values);
/*

  SStag.fromBytes(Tag tag, Uint8List bytes)
      : tag = (Tag.isValidVR(tag, SS.kVRIndex)) ? tag : invalidTagError(tag),
        values = Uint16Base.listFromBytes(bytes);

  factory SStag.fromBase64(Tag tag, String base64, [int vfLengthField]) =>
      new SStag.fromBytes(tag, BASE64.decode(base64));
*/

  @override
  SStag update([Iterable<int> vList = kEmptyIntList]) => new SStag(tag, vList);

  @override
  SStag updateF(Iterable<int> f(Iterable<int> vList)) =>
      new SStag(tag, f(values));

  static SStag make<double>(Tag tag, Iterable<double> vList) =>
      new SStag(tag, vList ?? kEmptyDoubleList);

  static SStag fromBase64(Tag tag, String s) => SS.isNotValidTag(tag)
      ? null
      : new SStag._(tag, Int16Base.listFromBase64(s) ?? kEmptyDoubleList);

  /// Creates an [SStag] from a [Uint8List].
  static SStag fromBytes(Tag tag, Uint8List bytes) => SS.isNotValidTag(tag)
      ? null
      : new SStag._(tag, Int16Base.listFromBytes(bytes) ?? kEmptyUint8List);

  static SStag fromBD(BDElement bd) =>
      SS.isNotValidTag(bd.tag) ? null : new SStag._(bd.tag, bd.values);
}

/// Short VRLength Signed Long
class SLtag extends SL with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;

  factory SLtag(Tag tag, [Iterable<int> vList = kEmptyIntList]) =>
      (SL.isValidArgs(tag, vList))
          ? new SLtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  SLtag._(this.tag, this.values);

/*
  SLtag.fromBytes(Tag tag, Uint8List bytes)
      : tag = (Tag.isValidVR(tag, SL.kVRIndex)) ? tag : invalidTagError(tag),
        values = Int32Base.listFromBytes(bytes);

  factory SLtag.fromBase64(Tag tag, String base64, [int vfLengthField]) =>
      new SLtag.fromBytes(tag, BASE64.decode(base64));
*/

  @override
  SLtag update([Iterable<int> vList = kEmptyIntList]) => new SLtag(tag, vList);

  @override
  SLtag updateF(Iterable<int> f(Iterable<int> vList)) =>
      new SLtag(tag, f(values));

  static SLtag make<double>(Tag tag, Iterable<double> vList) =>
      new SLtag(tag, vList ?? kEmptyDoubleList);

  static SLtag fromBase64(Tag tag, String s) => SL.isNotValidTag(tag)
      ? null
      : new SLtag._(tag, Int32Base.listFromBase64(s) ?? kEmptyDoubleList);

  /// Creates an [SLtag] from a [Uint8List].
  static SLtag fromBytes(Tag tag, Uint8List bytes) => SL.isNotValidTag(tag)
      ? null
      : new SLtag._(tag, Int32Base.listFromBytes(bytes) ?? kEmptyDoubleList);

  static SLtag fromBD(BDElement bd) =>
      SL.isNotValidTag(bd.tag) ? null : new SLtag._(bd.tag, bd.values);
}

/// 8-bit unsigned integer.
class OBtag extends OB with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;
  @override
  int vfLengthField;

  /// Creates an [OB] Element from a [Iterable<int>] of byte values (0 - 255).
  factory OBtag(Tag tag,
          [Iterable<int> vList = kEmptyIntList, int vfLengthField]) =>
      (OB.isValidArgs(tag, vList))
          ? new OBtag._(tag, vList, vfLengthField)
          : invalidValuesError(vList, tag: tag);

  /// Creates an [OB] Element from a [Iterable<int>] of byte values (0 - 255).
  OBtag._(this.tag, this.values, this.vfLengthField);

  OBtag.fromBytes(Tag tag, Uint8List bytes, this.vfLengthField)
      : tag = (Tag.isValidVR(tag, OB.kVRIndex))
            ? tag
            : invalidTagError(tag, OBtag),
        // ignore: prefer_initializing_formals
        values = bytes;

  factory OBtag.fromBase64(Tag tag, String base64, int vfLengthField) =>
      new OBtag.fromBytes(tag, BASE64.decode(base64), vfLengthField);

  @override
  OBtag update([Iterable<int> vList = kEmptyIntList]) => new OBtag(tag, vList);

  @override
  OBtag updateF(Iterable<int> f(Iterable<int> vList)) =>
      new OBtag(tag, f(values));

  static OBtag fromB64(Tag tag, String s, int vfLengthField) =>
      new OBtag.fromBytes(tag, BASE64.decode(s), vfLengthField);

  static OBtag make<int>(Tag tag, Iterable<int> vList) =>
      new OBtag(tag, vList ?? kEmptyIntList);

  static OBtag fromBD(BDElement bd) =>
      new OBtag.fromBytes(bd.tag, bd.vfBytes, bd.vfLengthField);
}

/// Unsigned 8-bit integer with unknown VR (VR.kUN).
class UNtag extends UN with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;
  @override
  final int vfLengthField;

  factory UNtag(Tag tag,
          [Iterable<int> vList = kEmptyIntList, int vfLengthField]) =>
      (UN.isValidArgs(tag, vList))
          ? new UNtag._(tag, vList, vfLengthField)
          : invalidValuesError(vList, tag: tag);

  UNtag._(this.tag, this.values, this.vfLengthField);

  UNtag.fromBytes(this.tag, this.values, this.vfLengthField);

  factory UNtag.fromBase64(Tag tag, String base64, [int vfLengthField]) =>
      new UNtag.fromBytes(tag, BASE64.decode(base64), vfLengthField);

  @override
  UNtag update([Iterable<int> vList = kEmptyIntList]) => new UNtag(tag, vList);

  @override
  UNtag updateF(Iterable<int> f(Iterable<int> vList)) =>
      new UNtag(tag, f(values));

  static UNtag make<int>(Tag tag, Iterable<int> vList) =>
      new UNtag(tag, vList ?? kEmptyIntList);

  static UNtag fromB64(Tag tag, String s, int vfLengthField) =>
      new UNtag.fromBytes(tag, BASE64.decode(s), vfLengthField);

  static UNtag fromBD(BDElement bd) =>
      new UNtag.fromBytes(bd.tag, bd.vfBytes, bd.vfLengthField);
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

  UStag._(this.tag, this.values);

  /// Creates an [UStag] with a value that is a [Uint8List].
  UStag.fromBytes(Tag tag, Uint8List bytes)
      : tag = (Tag.isValidVR(tag, US.kVRIndex))
            ? tag
            : invalidTagError(tag, UStag),
        values = Uint16Base.listFromBytes(bytes);

  factory UStag.fromBase64(Tag tag, String base64, [int vfLengthField]) =>
      new UStag.fromBytes(tag, BASE64.decode(base64));

  @override
  UStag update([Iterable<int> vList = kEmptyIntList]) => new UStag(tag, vList);

  @override
  UStag updateF(Iterable<int> f(Iterable<int> vList)) =>
      new UStag(tag, f(values));

  static UStag make<int>(Tag tag, Iterable<int> vList) =>
      new UStag(tag, vList ?? kEmptyIntList);

  static UStag fromB64(Tag tag, String base64) =>
      new UStag.fromBytes(tag, BASE64.decode(base64));

  static UStag fromBD(BDElement bd) => new UStag.fromBytes(bd.tag, bd.vfBytes);
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
          [Iterable<int> vList = kEmptyIntList, int vfLengthField]) =>
//Urgent Jim: figure out what to do with Private Creators with bad vr
      (OW.isValidArgs(tag, vList))
          ? new OWtag._(tag, vList, vfLengthField)
          : invalidValuesError(vList, tag: tag);

  OWtag._(this.tag, this.values, this.vfLengthField);

  /// Creates an [OWtag] with a value that is a [Uint16List].
  OWtag.fromBytes(Tag tag, Uint8List bytes, int vfLengthField)
      : tag = (Tag.isValidVR(tag, OW.kVRIndex))
            ? tag
            : invalidTagError(tag, OWtag),
        values = Uint16Base.listFromBytes(bytes),
        vfLengthField = _checkVFL(bytes, vfLengthField);

  factory OWtag.fromBase64(Tag tag, String base64, int vfLengthField,
          [TransferSyntax ts]) =>
      new OWtag.fromBytes(tag, BASE64.decode(base64), vfLengthField);

  OWtag._fromBytes(this.tag, Uint8List bytes, this.vfLengthField)
      : values = Uint16Base.listFromBytes(bytes);

  @override
  OWtag update([Iterable<int> vList = kEmptyIntList]) => new OWtag(tag, vList);

  @override
  OWtag updateF(Iterable<int> f(Iterable<int> vList)) =>
      new OWtag(tag, f(values));

  static OWtag make<int>(Tag tag, Iterable<int> vList) =>
      new OWtag(tag, vList ?? kEmptyIntList);

  static OWtag fromB64(Tag tag, String s, int vfLengthField) =>
      new OWtag.fromBytes(tag, BASE64.decode(s), vfLengthField);

  static OWtag fromBD(BDElement bd) =>
      new OWtag.fromBytes(bd.tag, bd.vfBytes, bd.vfLengthField);
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

  OLtag._(this.tag, this.values);

  /// Creates an [OLtag] with a value that is a [Uint8List].
  OLtag.fromBytes(Tag tag, Uint8List bytes)
      : tag = (Tag.isValidVR(tag, OL.kVRIndex))
            ? tag
            : invalidTagError(tag, OLtag),
        values = Uint32Base.listFromBytes(bytes);

  factory OLtag.fromBase64(Tag tag, String base64, [int vfLengthField]) =>
      new OLtag.fromBytes(tag, BASE64.decode(base64));

  @override
  OLtag update([Iterable<int> vList = kEmptyIntList]) => new OLtag(tag, vList);

  @override
  OLtag updateF(Iterable<int> f(Iterable<int> vList)) =>
      new OLtag(tag, f(values));

  static OLtag make<int>(Tag tag, Iterable<int> vList) =>
      new OLtag(tag, vList ?? kEmptyIntList);

  static OLtag fromB64(Tag tag, String base64) =>
      new OLtag.fromBytes(tag, BASE64.decode(base64));

  static SLtag fromBD(BDElement bd) => SLtag.fromBytes(bd.tag, bd.vfBytes);
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

  ULtag._(this.tag, this.values);

  /// Creates an [ULtag] with a value that is a [Uint8List].
  ULtag.fromBytes(Tag tag, Uint8List bytes)
      : tag = (Tag.isValidVR(tag, UL.kVRIndex))
            ? tag
            : invalidTagError(tag, ULtag),
        values = Uint32Base.listFromBytes(bytes);

  factory ULtag.fromBase64(Tag tag, String base64, [int vfLengthField]) =>
      new ULtag.fromBytes(tag, BASE64.decode(base64));

  @override
  ULtag update([Iterable<int> vList = kEmptyIntList]) => new ULtag(tag, vList);

  @override
  ULtag updateF(Iterable<int> f(Iterable<int> vList)) =>
      new ULtag(tag, f(values));

  static ULtag fromB64(Tag tag, String base64) =>
      new ULtag.fromBytes(tag, BASE64.decode(base64));

  static ULtag make<int>(Tag tag, Iterable<int> vList) =>
      new ULtag(tag, vList ?? kEmptyIntList);

  static ULtag fromBD(BDElement bd) {
    final tag = bd.tag;
    final bytes = bd.vfBytes;
    final te = new ULtag.fromBytes(tag, bytes);
    return te;
  }
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

  ATtag._(this.tag, this.values);

  /// Creates an [ ATtag] with a value that is a [Uint8List].
  ATtag.fromBytes(Tag tag, Uint8List bytes)
      : tag = (Tag.isValidVR(tag, AT.kVRIndex))
            ? tag
            : invalidTagError(tag, ATtag),
        values = Uint32Base.listFromBytes(bytes);

  /// Creates an [ ATtag] with a value that is a Base64 [String].
  factory ATtag.fromBase64(Tag tag, String base64) =>
      new ATtag.fromBytes(tag, BASE64.decode(base64));

  @override
  ATtag update([Iterable<int> vList = kEmptyIntList]) => new ATtag(tag, vList);

  @override
  ATtag updateF(Iterable<int> f(Iterable<int> vList)) =>
      new ATtag(tag, f(values));

  static ATtag fromB64(Tag tag, String base64) =>
      new ATtag.fromBytes(tag, BASE64.decode(base64));

  /// Reads a Uint8List containing Tag codes as (group, element) pairs,
  /// each of which must be read as a Uint16 value.
  //TODO: test
  static Iterable<int> valueFieldToValues(Uint8List bytes) {
    if ((bytes.lengthInBytes % 4) != 0) return null;
    final shorts = bytes.buffer.asUint16List();
    final list = new Uint32List(shorts.length ~/ 2);
    for (var i = 0; i < list.length; i += 2) {
      list[i] = (shorts[i] << 16) + shorts[i + 1];
    }
    return list;
  }

  static ATtag make<int>(Tag tag, Iterable<int> vList) =>
      new ATtag(tag, vList ?? kEmptyIntList);

  static ATtag fromBD(BDElement bd) => new ATtag.fromBytes(bd.tag, bd.vfBytes);
}
