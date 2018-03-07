// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/element/base.dart';
import 'package:core/src/element/tag/tag_element.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/value/date_time.dart';
import 'package:core/src/value/uid.dart';
import 'package:core/src/vr.dart';

class AEtag extends AE with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory AEtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (AE.isValidArgs(tag, vList))
          ? new AEtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  factory AEtag._fromUint8List(Tag tag, Uint8List bytes) =>
      (AE.isNotValidTag(tag))
          ? null
          : new AEtag._(tag, AE.fromUint8List(bytes));

  AEtag._(this.tag, this.values);

  @override
  AEtag update([Iterable<String> vList = kEmptyStringList]) =>
      new AEtag(tag, vList ?? kEmptyStringList);

  static AEtag make(Tag tag, Iterable<String> vList) =>
      new AEtag(tag, vList ?? kEmptyStringList);

  static AEtag fromUint8List(Tag tag, Uint8List bytes) =>
      new AEtag._fromUint8List(tag, bytes);

  static AEtag from(Element e) => new AEtag._fromUint8List(e.tag, e.vfBytes);
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

  factory CStag._fromUint8List(Tag tag, Uint8List bytes) =>
      (CS.isNotValidTag(tag))
          ? null
          : new CStag._(tag, CS.fromUint8List(bytes));

  CStag._(this.tag, this.values);

  @override
  CStag update([Iterable<String> vList = kEmptyStringList]) =>
      new CStag(tag, vList ?? kEmptyStringList);

  static CStag make(Tag tag, Iterable<String> vList) =>
      new CStag(tag, vList ?? kEmptyStringList);

  static CStag fromUint8List(Tag tag, Uint8List bytes) =>
      new CStag._fromUint8List(tag, bytes);

  static CStag from(Element e) => new CStag._fromUint8List(e.tag, e.vfBytes);
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

  factory DStag._fromUint8List(Tag tag, Uint8List bytes) =>
      (DS.isNotValidTag(tag))
          ? null
          : new DStag._(tag, DS.fromUint8List(bytes));

  DStag._(this.tag, this.values);

  @override
  DStag update([Iterable<String> vList = kEmptyStringList]) =>
      new DStag(tag, vList ?? kEmptyStringList);

  static DStag make(Tag tag, Iterable<String> vList) =>
      new DStag(tag, vList ?? kEmptyStringList);

  static DStag fromUint8List(Tag tag, Uint8List bytes) =>
      new DStag._fromUint8List(tag, bytes);

  static DStag from(Element e) => new DStag._fromUint8List(e.tag, e.vfBytes);
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

  factory IStag._fromUint8List(Tag tag, Uint8List bytes) =>
      (IS.isNotValidTag(tag))
          ? null
          : new IStag._(tag, IS.fromUint8List(bytes));

  IStag._(this.tag, this.values);

  @override
  IStag update([Iterable<String> vList = kEmptyStringList]) =>
      new IStag(tag, vList ?? kEmptyStringList);

  static IStag make(Tag tag, Iterable<String> vList) =>
      new IStag(tag, vList ?? kEmptyStringList);

  static IStag fromUint8List(Tag tag, Uint8List bytes) =>
      new IStag._fromUint8List(tag, bytes);

  static IStag from(Element e) => new IStag._fromUint8List(e.tag, e.vfBytes);
}

/// A Long String (LO) Element
class LOtag extends LO with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory LOtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (LO.isValidArgs(tag, vList))
          ? new LOtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  factory LOtag._fromUint8List(Tag tag, Uint8List bytes) =>
      (LO.isNotValidTag(tag))
          ? null
          : new LOtag._(tag, LO.fromUint8List(bytes));

  LOtag._(this.tag, this.values);

  @override
  LOtag update([Iterable<String> vList = kEmptyStringList]) =>
      new LOtag(tag, vList ?? kEmptyStringList);

  static LOtag make(Tag tag, Iterable<String> vList) =>
      new LOtag(tag, vList ?? kEmptyStringList);

  static LOtag fromUint8List(Tag tag, Uint8List bytes) =>
      new LOtag._fromUint8List(tag, bytes);

  static LOtag from(Element e) => new LOtag._fromUint8List(e.tag, e.vfBytes);
}

class PCtag extends PC with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory PCtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (LO.isValidArgs(tag, vList))
          ? new PCtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  factory PCtag._fromUint8List(Tag tag, Uint8List bytes) =>
      (LO.isNotValidTag(tag))
          ? null
          : new PCtag._(tag, LO.fromUint8List(bytes));

  PCtag._(this.tag, this.values);

  @override
  PCtag update([Iterable<String> vList = kEmptyStringList]) =>
      new PCtag(tag, vList ?? kEmptyStringList);

  static PCtag make(Tag tag, Iterable<String> vList) =>
      new PCtag(tag, vList ?? kEmptyStringList);

  static PCtag fromUint8List(Tag tag, Uint8List bytes) =>
      new PCtag._fromUint8List(tag, bytes);

  static PCtag from(Element e) => new PCtag._fromUint8List(e.tag, e.vfBytes);

  static PCtag makeEmptyPrivateCreator(int pdCode, int vrIndex) {
    final group = Tag.privateGroup(pdCode);
    final sgNumber = (pdCode & 0xFFFF) >> 8;
    final code = (group << 16) + sgNumber;
    final tag = new PCTagUnknown(code, kLOIndex, '');
    return new PCtag(tag, const <String>['']);
  }
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

  factory LTtag._fromUint8List(Tag tag, Uint8List bytes) =>
      (LT.isNotValidTag(tag))
          ? null
          : new LTtag._(tag, LT.fromUint8List(bytes));

  LTtag._(this.tag, this.values);

  @override
  LTtag update([Iterable<String> vList = kEmptyStringList]) =>
      new LTtag(tag, vList ?? kEmptyStringList);

  static LTtag make(Tag tag, Iterable<String> vList) =>
      new LTtag(tag, vList ?? kEmptyStringList);

  static LTtag fromUint8List(Tag tag, Uint8List bytes) =>
      new LTtag._fromUint8List(tag, bytes);

  static LTtag from(Element e) => new LTtag._fromUint8List(e.tag, e.vfBytes);
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

  factory PNtag._fromUint8List(Tag tag, Uint8List bytes) =>
      (PN.isNotValidTag(tag))
          ? null
          : new PNtag._(tag, PN.fromUint8List(bytes));

  PNtag._(this.tag, this.values);

  @override
  PNtag update([Iterable<String> vList = kEmptyStringList]) =>
      new PNtag(tag, vList ?? kEmptyStringList);

  static PNtag make(Tag tag, Iterable<String> vList) =>
      new PNtag(tag, vList ?? kEmptyStringList);

  static PNtag fromUint8List(Tag tag, Uint8List bytes) =>
      new PNtag._fromUint8List(tag, bytes);

  static PNtag from(Element e) => new PNtag._fromUint8List(e.tag, e.vfBytes);
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

  factory SHtag._fromUint8List(Tag tag, Uint8List bytes) =>
      (SH.isNotValidTag(tag))
          ? null
          : new SHtag._(tag, SH.fromUint8List(bytes));

  SHtag._(this.tag, this.values);

  @override
  SHtag update([Iterable<String> vList = kEmptyStringList]) =>
      new SHtag(tag, vList ?? kEmptyStringList);

  static SHtag make(Tag tag, Iterable<String> vList) =>
      new SHtag(tag, vList ?? kEmptyStringList);

  static SHtag fromUint8List(Tag tag, Uint8List bytes) =>
      new SHtag._fromUint8List(tag, bytes);

  static SHtag from(Element e) => new SHtag._fromUint8List(e.tag, e.vfBytes);
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

  factory STtag._fromUint8List(Tag tag, Uint8List bytes) =>
      (ST.isNotValidTag(tag))
          ? null
          : new STtag._(tag, ST.fromUint8List(bytes));

  STtag._(this.tag, this.values);

  @override
  STtag update([Iterable<String> vList = kEmptyStringList]) =>
      new STtag(tag, vList ?? kEmptyStringList);

  static STtag make(Tag tag, Iterable<String> vList) =>
      new STtag(tag, vList ?? kEmptyStringList);

  static STtag fromUint8List(Tag tag, Uint8List bytes) =>
      new STtag._fromUint8List(tag, bytes);

  static STtag from(Element e) => new STtag._fromUint8List(e.tag, e.vfBytes);
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

  factory UCtag._fromUint8List(Tag tag, Uint8List bytes) =>
      (UC.isNotValidTag(tag))
          ? null
          : new UCtag._(tag, UC.fromUint8List(bytes));

  UCtag._(this.tag, this.values);

  @override
  UCtag update([Iterable<String> vList = kEmptyStringList]) =>
      new UCtag(tag, vList ?? kEmptyStringList);

  static UCtag make(Tag tag, Iterable<String> vList) =>
      new UCtag(tag, vList ?? kEmptyStringList);

  static UCtag fromUint8List(Tag tag, Uint8List bytes) =>
      new UCtag._fromUint8List(tag, bytes);

  static UCtag from(Element e) => new UCtag._fromUint8List(e.tag, e.vfBytes);
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

  factory UItag._fromUint8List(Tag tag, Uint8List bytes) =>
      (UI.isNotValidTag(tag))
          ? null
          : new UItag._(tag, UI.fromUint8List(bytes));

  UItag._(this.tag, this.values);

  @override
  UItag update([Iterable<String> vList = kEmptyStringList]) =>
      new UItag.fromStrings(tag, vList);

  static UItag make(Tag tag, Iterable<String> vList) =>
      new UItag.fromStrings(tag, vList ?? kEmptyStringList);

  static UItag fromUint8List(Tag tag, Uint8List bytes) =>
      new UItag._fromUint8List(tag, bytes);

  static UItag from(Element e) => new UItag._fromUint8List(e.tag, e.vfBytes);

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

  factory URtag._fromUint8List(Tag tag, Uint8List bytes) =>
      (UR.isNotValidTag(tag))
          ? null
          : new URtag._(tag, UR.fromUint8List(bytes));

  URtag._(this.tag, this.values);

  @override
  URtag update([Iterable<String> vList = kEmptyStringList]) =>
      new URtag(tag, vList ?? kEmptyStringList);

  static URtag make(Tag tag, Iterable<String> vList) =>
      new URtag(tag, vList ?? kEmptyStringList);

  static URtag fromUint8List(Tag tag, Uint8List bytes) =>
      new URtag._fromUint8List(tag, bytes);

  static URtag from(Element e) => new URtag._fromUint8List(e.tag, e.vfBytes);
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

  factory UTtag._fromUint8List(Tag tag, Uint8List bytes) =>
      (UT.isNotValidTag(tag))
          ? null
          : new UTtag._(tag, UT.fromUint8List(bytes));

  UTtag._(this.tag, this.values);

  @override
  UTtag update([Iterable<String> vList = kEmptyStringList]) =>
      new UTtag(tag, vList ?? kEmptyStringList);

  static UTtag make(Tag tag, Iterable<String> vList) =>
      new UTtag(tag, vList ?? kEmptyStringList);

  static UTtag fromUint8List(Tag tag, Uint8List bytes) =>
      new UTtag._fromUint8List(tag, bytes);

  static UTtag from(Element e) => new UTtag._fromUint8List(e.tag, e.vfBytes);
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

  factory AStag._fromUint8List(Tag tag, Uint8List bytes) =>
      (AS.isNotValidTag(tag))
          ? null
          : new AStag._(tag, AS.fromUint8List(bytes));

  AStag._(this.tag, this.values);

  @override
  AStag update([Iterable<String> vList = kEmptyStringList]) =>
      (AS.isValidValues(tag, vList))
          ? new AStag(tag, vList)
          : invalidValuesError(values);

  @override
  AStag updateF(Iterable<String> f(Iterable<String> vList)) =>
      new AStag(tag, f(values));

  static AStag make(Tag tag, Iterable<String> vList) =>
      new AStag(tag, vList ?? kEmptyStringList);

  static AStag fromUint8List(Tag tag, Uint8List bytes) =>
      new AStag._fromUint8List(tag, bytes);

  static AStag from(Element e) => new AStag._fromUint8List(e.tag, e.vfBytes);

  static AStag parse(String s, {String onError(String s)}) => new AStag(
      PTag.kPatientAge,
      Age.isValidString(s)
          ? <String>[s]
          : invalidValuesError(<String>[s], tag: PTag.kPatientAge));
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

  factory DAtag._fromUint8List(Tag tag, Uint8List bytes) =>
      (DA.isNotValidTag(tag))
          ? null
          : new DAtag._(tag, DA.fromUint8List(bytes));

  DAtag._(this.tag, this.values);

  @override
  DAtag update([Iterable<String> vList = kEmptyStringList]) =>
      new DAtag(tag, vList ?? kEmptyStringList);

  static DAtag make(Tag tag, Iterable<String> vList) =>
      new DAtag(tag, vList ?? kEmptyStringList);

  static DAtag fromUint8List(Tag tag, Uint8List bytes) =>
      new DAtag._fromUint8List(tag, bytes);

  static DAtag from(Element e) => new DAtag(e.tag, e.values);
}

/// A DICOM DateTime [DT] [Element].
///
/// A concatenated date-time character string in the
/// format: YYYYMMDDHHMMSS.FFFFFF&ZZXX
class DTtag extends DT with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory DTtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (DT.isValidArgs(tag, vList))
          ? new DTtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  factory DTtag._fromUint8List(Tag tag, Uint8List bytes) =>
      (DT.isNotValidTag(tag))
          ? null
          : new DTtag._(tag, DT.fromUint8List(bytes));

  DTtag._(this.tag, this.values);

  @override
  DTtag update([Iterable<String> vList = kEmptyStringList]) =>
      new DTtag(tag, vList ?? kEmptyStringList);

  static DTtag make(Tag tag, Iterable<String> vList) =>
      new DTtag(tag, vList ?? kEmptyStringList);

  static DTtag fromUint8List(Tag tag, Uint8List bytes) =>
      new DTtag._fromUint8List(tag, bytes);

  static DTtag from(Element e) => new DTtag._fromUint8List(e.tag, e.vfBytes);
}

/// The DICOM [TM] (Time) [Element].
///
/// [Time] [String]s have the following format: HHMMSS.ffffff. [See PS3.18, TM]
/// (http://dicom.nema.org/medical/dicom/current/output/html/part18.html
/// #para_3f950ae4-871c-48c5-b200-6bccf821653b)
class TMtag extends TM with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory TMtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (TM.isValidArgs(tag, vList))
          ? new TMtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  factory TMtag._fromUint8List(Tag tag, Uint8List bytes) =>
      (TM.isNotValidTag(tag))
          ? null
          : new TMtag._(tag, TM.fromUint8List(bytes));

  TMtag._(this.tag, this.values);

  @override
  TMtag update([Iterable<String> vList = kEmptyStringList]) =>
      new TMtag(tag, vList ?? kEmptyStringList);

  static TMtag make(Tag tag, Iterable<String> vList) =>
      new TMtag(tag, vList ?? kEmptyStringList);

  static TMtag fromUint8List(Tag tag, Uint8List bytes) =>
      new TMtag._fromUint8List(tag, bytes);

  static TMtag from(Element e) => new TMtag._fromUint8List(e.tag, e.vfBytes);
}
