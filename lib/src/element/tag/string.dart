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
      : tag = (Tag.isValidVR(tag, AE.kVRIndex))
            ? tag
            : invalidTagError(tag, AEtag),
        values = AE.fromBytes(bytes);

  @override
  AEtag update([Iterable<String> vList = kEmptyStringList]) =>
      new AEtag(tag, vList ?? kEmptyStringList);

  static AEtag make<String>(Tag tag, Iterable<String> vList, [int _]) =>
      new AEtag(tag, vList ?? kEmptyStringList);

  static AEtag fromB64(Tag tag, String base64) =>
      new AEtag.fromBytes(tag, BASE64.decode(base64));

  static AEtag fromBDE(BDElement bd) => new AEtag.fromBytes(bd.tag, bd.vfBytes);
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
      : tag = (Tag.isValidVR(tag, CS.kVRIndex))
            ? tag
            : invalidTagError(tag, CStag),
        values = CS.fromBytes(bytes);

  @override
  CStag update([Iterable<String> vList = kEmptyStringList]) =>
      new CStag(tag, vList ?? kEmptyStringList);

  static CStag make<String>(Tag tag, Iterable<String> vList, [int _]) =>
      new CStag(tag, vList ?? kEmptyStringList);

  static CStag fromB64(Tag tag, String base64) =>
      new CStag.fromBytes(tag, BASE64.decode(base64));

  static CStag fromBDE(BDElement bd) => new CStag.fromBytes(bd.tag, bd.vfBytes);
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
      : tag = (Tag.isValidVR(tag, DS.kVRIndex))
            ? tag
            : invalidTagError(tag, DStag),
        values = DS.fromBytes(bytes);

  @override
  DStag update([Iterable<String> vList = kEmptyStringList]) =>
      new DStag(tag, vList ?? kEmptyStringList);

  static DStag make<String>(Tag tag, Iterable<String> vList, [int _]) =>
      new DStag(tag, vList ?? kEmptyStringList);

  static DStag fromB64(Tag tag, String base64) =>
      new DStag.fromBytes(tag, BASE64.decode(base64));

  static DStag fromBDE(BDElement bd) => new DStag.fromBytes(bd.tag, bd.vfBytes);
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
      : tag = (Tag.isValidVR(tag, IS.kVRIndex))
            ? tag
            : invalidTagError(tag, IStag),
        values = IS.fromBytes(bytes);

  @override
  IStag update([Iterable<String> vList = kEmptyStringList]) =>
      new IStag(tag, vList ?? kEmptyStringList);

  static IStag make<String>(Tag tag, Iterable<String> vList, [int _]) =>
      new IStag(tag, vList ?? kEmptyStringList);

  static IStag fromB64(Tag tag, String base64) =>
      new IStag.fromBytes(tag, BASE64.decode(base64));

  static IStag fromBDE(BDElement bd) => new IStag.fromBytes(bd.tag, bd.vfBytes);
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
      : tag = (Tag.isValidVR(tag, LO.kVRIndex))
            ? tag
            : invalidTagError(tag, LOtag),
        values = LO.fromBytes(bytes);

  @override
  LOtag update([Iterable<String> vList = kEmptyStringList]) =>
      new LOtag(tag, vList ?? kEmptyStringList);

  static LOtag make<String>(Tag tag, Iterable<String> vList, [int _]) =>
      new LOtag(tag, vList ?? kEmptyStringList);

  static LOtag fromB64(Tag tag, String base64) =>
      new LOtag.fromBytes(tag, BASE64.decode(base64));

  static LOtag fromBDE(BDElement bd) => new LOtag.fromBytes(bd.tag, bd.vfBytes);
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
      : tag = (Tag.isValidVR(tag, LT.kVRIndex))
            ? tag
            : invalidTagError(tag, LTtag),
        values = LT.fromBytes(bytes);

  @override
  LTtag update([Iterable<String> vList = kEmptyStringList]) =>
      new LTtag(tag, vList ?? kEmptyStringList);

  static LTtag make<String>(Tag tag, Iterable<String> vList, [int _]) =>
      new LTtag(tag, vList ?? kEmptyStringList);

  static LTtag fromB64(Tag tag, String base64) =>
      new LTtag.fromBytes(tag, BASE64.decode(base64));

  static LTtag fromBDE(BDElement bd) => new LTtag.fromBytes(bd.tag, bd.vfBytes);
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
      : tag = (Tag.isValidVR(tag, PN.kVRIndex))
            ? tag
            : invalidTagError(tag, PNtag),
        values = PN.fromBytes(bytes);

  @override
  PNtag update([Iterable<String> vList = kEmptyStringList]) =>
      new PNtag(tag, vList ?? kEmptyStringList);

  static PNtag make<String>(Tag tag, Iterable<String> vList, [int _]) =>
      new PNtag(tag, vList ?? kEmptyStringList);

  static PNtag fromB64(Tag tag, String base64) =>
      new PNtag.fromBytes(tag, BASE64.decode(base64));

  static PNtag fromBDE(BDElement bd) => new PNtag.fromBytes(bd.tag, bd.vfBytes);
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
      : tag = (Tag.isValidVR(tag, SH.kVRIndex))
            ? tag
            : invalidTagError(tag, SHtag),
        values = SH.fromBytes(bytes);

  @override
  SHtag update([Iterable<String> vList = kEmptyStringList]) =>
      new SHtag(tag, vList ?? kEmptyStringList);

  static SHtag make<String>(Tag tag, Iterable<String> vList, [int _]) =>
      new SHtag(tag, vList ?? kEmptyStringList);

  static SHtag fromB64(Tag tag, String base64) =>
      new SHtag.fromBytes(tag, BASE64.decode(base64));

  static SHtag fromBDE(BDElement bd) => new SHtag.fromBytes(bd.tag, bd.vfBytes);
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
      : tag = (Tag.isValidVR(tag, ST.kVRIndex))
            ? tag
            : invalidTagError(tag, STtag),
        values = ST.fromBytes(bytes);

  @override
  STtag update([Iterable<String> vList = kEmptyStringList]) =>
      new STtag(tag, vList ?? kEmptyStringList);

  static STtag make<String>(Tag tag, Iterable<String> vList, [int _]) =>
      new STtag(tag, vList ?? kEmptyStringList);

  static STtag fromB64(Tag tag, String base64) =>
      new STtag.fromBytes(tag, BASE64.decode(base64));

  static STtag fromBDE(BDElement bd) => new STtag.fromBytes(bd.tag, bd.vfBytes);
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
      : tag = (Tag.isValidVR(tag, UC.kVRIndex))
            ? tag
            : invalidTagError(tag, UCtag),
        values = UC.fromBytes(bytes);

  @override
  UCtag update([Iterable<String> vList = kEmptyStringList]) =>
      new UCtag(tag, vList ?? kEmptyStringList);

  static UCtag make<String>(Tag tag, Iterable<String> vList, [int _]) =>
      new UCtag(tag, vList ?? kEmptyStringList);

  static UCtag fromB64(Tag tag, String base64) =>
      new UCtag.fromBytes(tag, BASE64.decode(base64));

  static UCtag fromBDE(BDElement bd) => new UCtag.fromBytes(bd.tag, bd.vfBytes);
}

class UItag extends UI with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory UItag(Tag tag, Iterable<Uid> vList, {bool validate = true}) {
    vList ??= Uid.kEmptyList;
    if (validate && !UI.isValidArgs(tag, vList))
      return invalidValuesError(vList, tag: tag);
    return new UItag._(tag, UI.toStringList(vList));
  }

  factory UItag.fromStrings(Tag tag, Iterable<String> sList,
          {bool validate = true}) =>
      (sList == null || (validate && !UI.isValidStringArgs(tag, sList)))
          ? invalidValuesError(sList, tag: tag)
          : new UItag._(tag, sList);

  UItag._(this.tag, this.values);

  UItag.fromBytes(Tag tag, Uint8List bytes)
      : tag = (Tag.isValidVR(tag, UI.kVRIndex))
            ? tag
            : invalidTagError(tag, UItag),
        values = UI.fromBytes(bytes);

  @override
  UItag update([Iterable<String> vList = kEmptyStringList]) =>
      new UItag.fromStrings(tag, vList);

  static UItag make<String>(Tag tag, Iterable<String> vList, [int _]) =>
      new UItag.fromStrings(tag, vList ?? kEmptyStringList);

  static UItag fromB64(Tag tag, String base64) =>
      new UItag.fromBytes(tag, BASE64.decode(base64));

  static UItag fromBDE(BDElement bd) => new UItag.fromBytes(bd.tag, bd.vfBytes);

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
      : tag = (Tag.isValidVR(tag, UR.kVRIndex))
            ? tag
            : invalidTagError(tag, URtag),
        values = UR.fromBytes(bytes);

  @override
  URtag update([Iterable<String> vList = kEmptyStringList]) =>
      new URtag(tag, vList ?? kEmptyStringList);

  static URtag make<String>(Tag tag, Iterable<String> vList, [int _]) =>
      new URtag(tag, vList ?? kEmptyStringList);

  static URtag fromB64(Tag tag, String base64) =>
      new URtag.fromBytes(tag, BASE64.decode(base64));

  static URtag fromBDE(BDElement bd) => new URtag.fromBytes(bd.tag, bd.vfBytes);
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
      : tag = (Tag.isValidVR(tag, UT.kVRIndex))
            ? tag
            : invalidTagError(tag, UTtag),
        values = UT.fromBytes(bytes);

  @override
  UTtag update([Iterable<String> vList = kEmptyStringList]) =>
      new UTtag(tag, vList ?? kEmptyStringList);

  static UTtag make<String>(Tag tag, Iterable<String> vList, [int _]) =>
      new UTtag(tag, vList ?? kEmptyStringList);

  static UTtag fromB64(Tag tag, String base64) =>
      new UTtag.fromBytes(tag, BASE64.decode(base64));

  static UTtag fromBDE(BDElement bd) => new UTtag.fromBytes(bd.tag, bd.vfBytes);
}

// **** Date/Time classes
/// A Application Entity Title (AS) Element
class AStag extends AS with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory AStag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (AS.isValidArgs(tag, vList))
          ? new AStag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  AStag._(this.tag, this.values);

  AStag.fromBytes(this.tag, Uint8List bytes) : values = AS.fromBytes(bytes);

  @override
  AStag update([Iterable<String> vList = kEmptyStringList]) =>
      (AS.isValidValues(tag, vList))
          ? new AStag(tag, vList)
          : invalidValuesError(values);

  @override
  AStag updateF(Iterable<String> f(Iterable<String> vList)) =>
      new AStag(tag, f(values));

  static AStag parse(String s, {String onError(String s)}) => new AStag(
      PTag.kPatientAge,
      Age.isValidString(s)
          ? <String>[s]
          : invalidValuesError(<String>[s], tag: PTag.kPatientAge));

  static Element make<String>(Tag tag, Iterable<String> vList, [int _]) =>
      new AStag(tag, vList ?? kEmptyStringList);

  static AStag fromB64(Tag tag, String base64) =>
      new AStag.fromBytes(tag, BASE64.decode(base64));

  static AStag fromBDE(BDElement bd) => new AStag.fromBytes(bd.tag, bd.vfBytes);
}

/// A DICOM Date ([DA]) [Element].
/// TODO: add link to standard
class DAtag extends DA with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory DAtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (DA.isValidArgs(tag, vList))
          ? new DAtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  DAtag._(this.tag, this.values);

  DAtag.fromBytes(this.tag, Uint8List bytes) : values = DA.fromBytes(bytes);

  @override
  DAtag update([Iterable<String> vList = kEmptyStringList]) =>
      (DA.isValidValues(tag, vList))
          ? new DAtag(tag, vList)
          : invalidValuesError(values);
  /*new DAtag(tag, vList ?? kEmptyStringList);*/

  @override
  DAtag updateF(Iterable<String> f(Iterable<String> vList)) =>
      new DAtag(tag, f(values));

  static DAtag fromB64(Tag tag, String base64) =>
      new DAtag.fromBytes(tag, BASE64.decode(base64));

  static DAtag make<String>(Tag tag, Iterable<String> vList, [int _]) =>
      new DAtag(tag, vList ?? kEmptyStringList);

  static DAtag fromBDE(BDElement bd) => new DAtag.fromBytes(bd.tag, bd.vfBytes);
}

/// A DICOM DateTime [DT] [Element].
///
/// A concatenated date-time character string in the format: YYYYMMDDHHMMSS.FFFFFF&ZZXX
class DTtag extends DT with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory DTtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (DT.isValidArgs(tag, vList))
          ? new DTtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  DTtag._(this.tag, this.values);

  DTtag.fromBytes(this.tag, Uint8List bytes) : values = DT.fromBytes(bytes);

  @override
  DTtag update([Iterable<String> vList = kEmptyStringList]) =>
      (DT.isValidValues(tag, vList))
          ? new DTtag(tag, vList)
          : invalidValuesError(values);

  @override
  DTtag updateF(Iterable<String> f(Iterable<String> vList)) =>
      new DTtag(tag, f(values));

  static DTtag fromB64(Tag tag, String base64) =>
      new DTtag.fromBytes(tag, BASE64.decode(base64));

  static DTtag make<String>(Tag tag, Iterable<String> vList, [int _]) =>
      new DTtag(tag, vList ?? kEmptyStringList);

  static DTtag fromBDE(BDElement bd) => new DTtag.fromBytes(bd.tag, bd.vfBytes);
}

/// The DICOM [TM] (Time) [Element].
///
/// [Time] [String]s have the following format: HHMMSS.ffffff.
/// [See PS3.18, TM](http://dicom.nema.org/medical/dicom/current/output/html/part18.html#para_3f950ae4-871c-48c5-b200-6bccf821653b)
class TMtag extends TM with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory TMtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (TM.isValidArgs(tag, vList))
          ? new TMtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  TMtag._(this.tag, this.values);

  TMtag.fromBytes(this.tag, Uint8List bytes) : values = TM.fromBytes(bytes);

  @override
  TMtag update([Iterable<String> vList = kEmptyStringList]) =>
      (TM.isValidValues(tag, vList))
          ? new TMtag(tag, vList)
          : invalidValuesError(values);

  @override
  TMtag updateF(Iterable<String> f(Iterable<String> vList)) =>
      new TMtag(tag, f(values));

  static TMtag fromB64(Tag tag, String base64) =>
      new TMtag.fromBytes(tag, BASE64.decode(base64));

  static TMtag make<String>(Tag tag, Iterable<String> vList, [int _]) =>
      new TMtag(tag, vList ?? kEmptyStringList);

  static TMtag fromBDE(BDElement bd) => new TMtag.fromBytes(bd.tag, bd.vfBytes);
}
