// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/core.dart';

import 'package:core/src/element/base/bulkdata.dart';
import 'package:core/src/element/base/string.dart';
import 'package:core/src/element/byte_data/bd_element.dart';
import 'package:core/src/element/errors.dart';
import 'package:core/src/element/tag/tag_element.dart';
import 'package:core/src/tag/tag.dart';

// Urgent: move all updateF methods to base/string
class StringBulkdata extends BulkdataRef<int> {
  @override
  int code;
  @override
  String uri;

  StringBulkdata(this.code, this.uri);

  @override
  List<int> get values => _values ??= getBulkdata(code, uri);
  List<int> _values;
}

class AEtag extends AE with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory AEtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (AE.isValidArgs(tag, vList))
          ? new AEtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  AEtag._(this.tag, this.values);

  AEtag.fromBytes(Tag tag, Uint8List bytes)
      : tag = (Tag.isValidVR(tag, AE.kVRIndex)) ? tag : invalidTagError(tag),
        values = AE.fromBytes(bytes);

  @override
  AEtag update([Iterable<String> vList = kEmptyStringList]) =>
      new AEtag(tag, vList ?? kEmptyStringList);

  @override
  AEtag updateF(Iterable<String> f(Iterable<String> vList)) =>
      new AEtag(tag, f(values));

  static AEtag make<String>(Tag tag, Iterable<String> vList) =>
      new AEtag(tag, vList ?? kEmptyStringList);

  static AEtag fromB64(Tag tag, String base64) =>
      new AEtag.fromBytes(tag, BASE64.decode(base64));

  static AEtag fromBD(BDElement bd) => new AEtag.fromBytes(bd.tag, bd.vfBytes);
}

class CStag extends CS with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory CStag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (CS.isValidArgs(tag, vList))
          ? new CStag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  CStag._(this.tag, this.values);

  CStag.fromBytes(Tag tag, Uint8List bytes)
      : tag = (Tag.isValidVR(tag, CS.kVRIndex)) ? tag : invalidTagError(tag),
        values = CS.fromBytes(bytes);

  @override
  CStag update([Iterable<String> vList = kEmptyStringList]) =>
      new CStag(tag, vList ?? kEmptyStringList);

  @override
  CStag updateF(Iterable<String> f(Iterable<String> vList)) =>
      new CStag(tag, f(values));

  static CStag make<String>(Tag tag, Iterable<String> vList) =>
      new CStag(tag, vList ?? kEmptyStringList);

  static CStag fromB64(Tag tag, String base64) =>
      new CStag.fromBytes(tag, BASE64.decode(base64));

  static CStag fromBD(BDElement bd) => new CStag.fromBytes(bd.tag, bd.vfBytes);
}

class DStag extends DS with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory DStag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (DS.isValidArgs(tag, vList))
          ? new DStag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  DStag._(this.tag, this.values);

  DStag.fromBytes(Tag tag, Uint8List bytes)
      : tag = (Tag.isValidVR(tag, DS.kVRIndex)) ? tag : invalidTagError(tag),
        values = DS.fromBytes(bytes);

  @override
  DStag update([Iterable<String> vList = kEmptyStringList]) =>
      new DStag(tag, vList ?? kEmptyStringList);

  @override
  DStag updateF(Iterable<String> f(Iterable<String> vList)) =>
      new DStag(tag, f(values));

  static DStag make<String>(Tag tag, Iterable<String> vList) =>
      new DStag(tag, vList ?? kEmptyStringList);

  static DStag fromB64(Tag tag, String base64) =>
      new DStag.fromBytes(tag, BASE64.decode(base64));

  static DStag fromBD(BDElement bd) => new DStag.fromBytes(bd.tag, bd.vfBytes);
}

class IStag extends IS with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory IStag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (IS.isValidArgs(tag, vList))
          ? new IStag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  IStag._(this.tag, this.values);

  IStag.fromBytes(Tag tag, Uint8List bytes)
      : tag = (Tag.isValidVR(tag, IS.kVRIndex)) ? tag : invalidTagError(tag),
        values = IS.fromBytes(bytes);

  @override
  IStag update([Iterable<String> vList = kEmptyStringList]) =>
      new IStag(tag, vList ?? kEmptyStringList);

  @override
  IStag updateF(Iterable<String> f(Iterable<String> vList)) =>
      new IStag(tag, f(values));

  static IStag make<String>(Tag tag, Iterable<String> vList) =>
      new IStag(tag, vList ?? kEmptyStringList);

  static IStag fromB64(Tag tag, String base64) =>
      new IStag.fromBytes(tag, BASE64.decode(base64));

  static IStag fromBD(BDElement bd) => new IStag.fromBytes(bd.tag, bd.vfBytes);
}

/// A Long String (LO) Element
class LOtag extends LO with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory LOtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (LO.isValidArgs(tag, vList))
          ? new LOtag.internal(tag, vList)
          : invalidValuesError(vList, tag: tag);

  LOtag.internal(this.tag, this.values);

  LOtag.fromBytes(Tag tag, Uint8List bytes)
      : tag = (Tag.isValidVR(tag, LO.kVRIndex)) ? tag : invalidTagError(tag),
        values = LO.fromBytes(bytes);

  @override
  LOtag update([Iterable<String> vList = kEmptyStringList]) =>
      new LOtag(tag, vList ?? kEmptyStringList);

  @override
  LOtag updateF(Iterable<String> f(Iterable<String> vList)) =>
      new LOtag(tag, f(values));

  static LOtag make<String>(Tag tag, Iterable<String> vList) =>
      new LOtag(tag, vList ?? kEmptyStringList);

  static LOtag fromB64(Tag tag, String base64) =>
      new LOtag.fromBytes(tag, BASE64.decode(base64));

  static LOtag fromBD(BDElement bd) => new LOtag.fromBytes(bd.tag, bd.vfBytes);
}

/// An Long Text (LT) Element
class LTtag extends LT with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory LTtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (LT.isValidArgs(tag, vList))
          ? new LTtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  LTtag._(this.tag, this.values);

  LTtag.fromBytes(Tag tag, Uint8List bytes)
      : tag = (Tag.isValidVR(tag, LT.kVRIndex)) ? tag : invalidTagError(tag),
        values = LT.fromBytes(bytes);

  @override
  LTtag update([Iterable<String> vList = kEmptyStringList]) =>
      new LTtag(tag, vList ?? kEmptyStringList);

  @override
  LTtag updateF(Iterable<String> f(Iterable<String> vList)) =>
      new LTtag(tag, f(values));

  static LTtag make<String>(Tag tag, Iterable<String> vList) =>
      new LTtag(tag, vList ?? kEmptyStringList);

  static LTtag fromB64(Tag tag, String base64) =>
      new LTtag.fromBytes(tag, BASE64.decode(base64));

  static LTtag fromBD(BDElement bd) => new LTtag.fromBytes(bd.tag, bd.vfBytes);
}

/// A Person Name ([PN]) Element.
class PNtag extends PN with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory PNtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (PN.isValidArgs(tag, vList))
          ? new PNtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  PNtag._(this.tag, this.values);

  PNtag.fromBytes(Tag tag, Uint8List bytes)
      : tag = (Tag.isValidVR(tag, PN.kVRIndex)) ? tag : invalidTagError(tag),
        values = PN.fromBytes(bytes);

  @override
  PNtag update([Iterable<String> vList = kEmptyStringList]) =>
      new PNtag(tag, vList ?? kEmptyStringList);

  @override
  PNtag updateF(Iterable<String> f(Iterable<String> vList)) =>
      new PNtag(tag, f(values));

  static PNtag make<String>(Tag tag, Iterable<String> vList) =>
      new PNtag(tag, vList ?? kEmptyStringList);

  static PNtag fromB64(Tag tag, String base64) =>
      new PNtag.fromBytes(tag, BASE64.decode(base64));

  static PNtag fromBD(BDElement bd) => new PNtag.fromBytes(bd.tag, bd.vfBytes);
}

/// A Short String (SH) Element
class SHtag extends SH with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory SHtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (SH.isValidArgs(tag, vList))
          ? new SHtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  SHtag._(this.tag, this.values);

  SHtag.fromBytes(Tag tag, Uint8List bytes)
      : tag = (Tag.isValidVR(tag, SH.kVRIndex)) ? tag : invalidTagError(tag),
        values = SH.fromBytes(bytes);

  @override
  SHtag update([Iterable<String> vList = kEmptyStringList]) =>
      new SHtag(tag, vList ?? kEmptyStringList);

  @override
  SHtag updateF(Iterable<String> f(Iterable<String> vList)) =>
      new SHtag(tag, f(values));

  static SHtag make<String>(Tag tag, Iterable<String> vList) =>
      new SHtag(tag, vList ?? kEmptyStringList);

  static SHtag fromB64(Tag tag, String base64) =>
      new SHtag.fromBytes(tag, BASE64.decode(base64));

  static SHtag fromBD(BDElement bd) => new SHtag.fromBytes(bd.tag, bd.vfBytes);
}

/// An Short Text (ST) Element
class STtag extends ST with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory STtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (ST.isValidArgs(tag, vList))
          ? new STtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  STtag._(this.tag, this.values);

  STtag.fromBytes(Tag tag, Uint8List bytes)
      : tag = (Tag.isValidVR(tag, ST.kVRIndex)) ? tag : invalidTagError(tag),
        values = ST.fromBytes(bytes);

  @override
  STtag update([Iterable<String> vList = kEmptyStringList]) =>
      new STtag(tag, vList ?? kEmptyStringList);

  @override
  STtag updateF(Iterable<String> f(Iterable<String> vList)) =>
      new STtag(tag, f(values));

  static STtag make<String>(Tag tag, Iterable<String> vList) =>
      new STtag(tag, vList ?? kEmptyStringList);

  static STtag fromB64(Tag tag, String base64) =>
      new STtag.fromBytes(tag, BASE64.decode(base64));

  static STtag fromBD(BDElement bd) => new STtag.fromBytes(bd.tag, bd.vfBytes);
}

/// An Unlimited Characters (UC) Element
class UCtag extends UC with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory UCtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (UC.isValidArgs(tag, vList))
          ? new UCtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  UCtag._(this.tag, this.values);

  UCtag.fromBytes(Tag tag, Uint8List bytes)
      : tag = (Tag.isValidVR(tag, UC.kVRIndex)) ? tag : invalidTagError(tag),
        values = UC.fromBytes(bytes);

  @override
  UCtag update([Iterable<String> vList = kEmptyStringList]) =>
      new UCtag(tag, vList ?? kEmptyStringList);

  @override
  UCtag updateF(Iterable<String> f(Iterable<String> vList)) =>
      new UCtag(tag, f(values));

  static UCtag make<String>(Tag tag, Iterable<String> vList) =>
      new UCtag(tag, vList ?? kEmptyStringList);

  static UCtag fromB64(Tag tag, String base64) =>
      new UCtag.fromBytes(tag, BASE64.decode(base64));

  static UCtag fromBD(BDElement bd) => new UCtag.fromBytes(bd.tag, bd.vfBytes);
}

class UItag extends UI with TagElement<String> {
  @override
  final Tag tag;
  // TODO: decide if values should be Iterable<String>
  @override
  Iterable<String> values;

  factory UItag(Tag tag, Iterable<Uid> vList, {bool validate = true}) {
    vList ??= Uid.kEmptyList;
    if (validate && !UI.isValidArgs(tag, vList))
      return invalidValuesError(vList, tag: tag);
    return new UItag._(tag, UI.toStringList(vList));
  }

  factory UItag.fromStrings(Tag tag, Iterable<String> sList,
      {bool validate = true}) {
    sList ??= kEmptyStringList;
    return (validate && !UI.isValidStringArgs(tag, sList))
        ? invalidValuesError(sList, tag: tag)
        : new UItag._(tag, sList);
  }

  UItag._(this.tag, this.values);

  UItag.fromBytes(Tag tag, Uint8List bytes)
      : tag = (Tag.isValidVR(tag, UI.kVRIndex)) ? tag : invalidTagError(tag),
        values = UI.fromBytes(bytes);

  @override
  UItag update([Iterable<String> vList = kEmptyStringList]) =>
      new UItag.fromStrings(tag, vList);

  static UItag make<String>(Tag tag, Iterable<String> vList) =>
      new UItag(tag, vList ?? kEmptyStringList);

  static UItag fromB64(Tag tag, String base64) =>
      new UItag.fromBytes(tag, BASE64.decode(base64));

  static UItag fromBD(BDElement bd) => new UItag.fromBytes(bd.tag, bd.vfBytes);

  static UItag parseBase64(Tag tag, String s, int vfLength) =>
      new UItag.fromBytes(tag, BASE64.decode(s));

  static Iterable<Uid> parse(List<String> vList) {
    final uids = new List<Uid>(vList.length);
    for (var i = 0; i < vList.length; i++) {
      final uid = Uid.parse(vList[i]);
      if (uid == null) return null;
    }
    return uids;
  }
}

/// Value Representation of [Uri].
///
/// The Value Multiplicity of this Element is 1.
class URtag extends UR with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory URtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (UR.isValidArgs(tag, vList))
          ? new URtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  URtag._(this.tag, this.values);

  URtag.fromBytes(Tag tag, Uint8List bytes)
      : tag = (Tag.isValidVR(tag, UR.kVRIndex)) ? tag : invalidTagError(tag),
        values = UR.fromBytes(bytes);

  @override
  URtag update([Iterable<String> vList = kEmptyStringList]) =>
      new URtag(tag, vList ?? kEmptyStringList);

  @override
  URtag updateF(Iterable<String> f(Iterable<String> vList)) =>
      new URtag(tag, f(values));

  static URtag make<String>(Tag tag, Iterable<String> vList) =>
      new URtag(tag, vList ?? kEmptyStringList);

  static URtag fromB64(Tag tag, String base64) =>
      new URtag.fromBytes(tag, BASE64.decode(base64));

  static URtag fromBD(BDElement bd) => new URtag.fromBytes(bd.tag, bd.vfBytes);
}

/// An Unlimited Text (UT) Element
class UTtag extends UT with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory UTtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (UT.isValidArgs(tag, vList))
          ? new UTtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  UTtag._(this.tag, this.values);

  UTtag.fromBytes(Tag tag, Uint8List bytes)
      : tag = (Tag.isValidVR(tag, UT.kVRIndex)) ? tag : invalidTagError(tag),
        values = UT.fromBytes(bytes);

  @override
  UTtag update([Iterable<String> vList = kEmptyStringList]) =>
      new UTtag(tag, vList ?? kEmptyStringList);

  @override
  UTtag updateF(Iterable<String> f(Iterable<String> vList)) =>
      new UTtag(tag, f(values));

  static UTtag make<String>(Tag tag, Iterable<String> vList) =>
      new UTtag(tag, vList ?? kEmptyStringList);

  static UTtag fromB64(Tag tag, String base64) =>
      new UTtag.fromBytes(tag, BASE64.decode(base64));

  static UTtag fromBD(BDElement bd) => new UTtag.fromBytes(bd.tag, bd.vfBytes);
}
