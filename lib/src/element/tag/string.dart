// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:core/src/element/base/bulkdata.dart';
import 'package:core/src/element/base/string.dart';
import 'package:core/src/element/errors.dart';
import 'package:core/src/element/tag/tag_element.dart';
import 'package:core/src/tag/export.dart';

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

  factory AEtag._fromBytes(Tag tag, Uint8List bytes) =>
      (AE.isNotValidTag(tag)) ? null : new AEtag._(tag, AE.fromBytes(bytes));

  AEtag._(this.tag, this.values);

  @override
  AEtag update([Iterable<String> vList = kEmptyStringList]) =>
      new AEtag(tag, vList ?? kEmptyStringList);

  static AEtag make(Tag tag, Iterable<String> vList) =>
      new AEtag(tag, vList ?? kEmptyStringList);

  static AEtag fromBytes(Tag tag, Uint8List bytes) =>
      new AEtag._fromBytes(tag, bytes);

  static AEtag fromBDE(Element e) => new AEtag._fromBytes(e.tag, e.vfBytes);
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

  factory CStag._fromBytes(Tag tag, Uint8List bytes) =>
      (CS.isNotValidTag(tag)) ? null : new CStag._(tag, CS.fromBytes(bytes));

  CStag._(this.tag, this.values);

  @override
  CStag update([Iterable<String> vList = kEmptyStringList]) =>
      new CStag(tag, vList ?? kEmptyStringList);

  static CStag make(Tag tag, Iterable<String> vList) =>
      new CStag(tag, vList ?? kEmptyStringList);

  static CStag fromBytes(Tag tag, Uint8List bytes) =>
      new CStag._fromBytes(tag, bytes);

  static CStag fromBDE(Element e) => new CStag._fromBytes(e.tag, e.vfBytes);
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

  factory DStag._fromBytes(Tag tag, Uint8List bytes) =>
      (DS.isNotValidTag(tag)) ? null : new DStag._(tag, DS.fromBytes(bytes));

  DStag._(this.tag, this.values);

  @override
  DStag update([Iterable<String> vList = kEmptyStringList]) =>
      new DStag(tag, vList ?? kEmptyStringList);

  static DStag make(Tag tag, Iterable<String> vList) =>
      new DStag(tag, vList ?? kEmptyStringList);

  static DStag fromBytes(Tag tag, Uint8List bytes) =>
      new DStag._fromBytes(tag, bytes);

  static DStag fromBDE(Element e) => new DStag._fromBytes(e.tag, e.vfBytes);
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

  factory IStag._fromBytes(Tag tag, Uint8List bytes) =>
      (IS.isNotValidTag(tag)) ? null : new IStag._(tag, IS.fromBytes(bytes));

  IStag._(this.tag, this.values);

  @override
  IStag update([Iterable<String> vList = kEmptyStringList]) =>
      new IStag(tag, vList ?? kEmptyStringList);

  static IStag make(Tag tag, Iterable<String> vList) =>
      new IStag(tag, vList ?? kEmptyStringList);

  static IStag fromBytes(Tag tag, Uint8List bytes) =>
      new IStag._fromBytes(tag, bytes);

  static IStag fromBDE(Element e) => new IStag._fromBytes(e.tag, e.vfBytes);
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

  factory LOtag._fromBytes(Tag tag, Uint8List bytes) =>
      (LO.isNotValidTag(tag)) ? null : new LOtag._(tag, LO.fromBytes(bytes));

  LOtag._(this.tag, this.values);

/* Flush when working
  // TODO: remove this constructor when
  LOtag.internal(this.tag, this.values);
*/

  @override
  LOtag update([Iterable<String> vList = kEmptyStringList]) =>
      new LOtag(tag, vList ?? kEmptyStringList);

  static LOtag make(Tag tag, Iterable<String> vList) =>
      new LOtag(tag, vList ?? kEmptyStringList);

  static LOtag fromBytes(Tag tag, Uint8List bytes) =>
      new LOtag._fromBytes(tag, bytes);

  static LOtag fromBDE(Element e) => new LOtag._fromBytes(e.tag, e.vfBytes);
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

  factory LTtag._fromBytes(Tag tag, Uint8List bytes) =>
      (LT.isNotValidTag(tag)) ? null : new LTtag._(tag, LT.fromBytes(bytes));

  LTtag._(this.tag, this.values);

  @override
  LTtag update([Iterable<String> vList = kEmptyStringList]) =>
      new LTtag(tag, vList ?? kEmptyStringList);

  static LTtag make(Tag tag, Iterable<String> vList) =>
      new LTtag(tag, vList ?? kEmptyStringList);

  static LTtag fromBytes(Tag tag, Uint8List bytes) =>
      new LTtag._fromBytes(tag, bytes);

  static LTtag fromBDE(Element e) => new LTtag._fromBytes(e.tag, e.vfBytes);
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

  factory PNtag._fromBytes(Tag tag, Uint8List bytes) =>
      (PN.isNotValidTag(tag)) ? null : new PNtag._(tag, PN.fromBytes(bytes));

  PNtag._(this.tag, this.values);

  @override
  PNtag update([Iterable<String> vList = kEmptyStringList]) =>
      new PNtag(tag, vList ?? kEmptyStringList);

  static PNtag make(Tag tag, Iterable<String> vList) =>
      new PNtag(tag, vList ?? kEmptyStringList);

  static PNtag fromBytes(Tag tag, Uint8List bytes) =>
      new PNtag._fromBytes(tag, bytes);

  static PNtag fromBDE(Element e) => new PNtag._fromBytes(e.tag, e.vfBytes);
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

  factory SHtag._fromBytes(Tag tag, Uint8List bytes) =>
      (SH.isNotValidTag(tag)) ? null : new SHtag._(tag, SH.fromBytes(bytes));

  SHtag._(this.tag, this.values);

  @override
  SHtag update([Iterable<String> vList = kEmptyStringList]) =>
      new SHtag(tag, vList ?? kEmptyStringList);

  static SHtag make(Tag tag, Iterable<String> vList) =>
      new SHtag(tag, vList ?? kEmptyStringList);

  static SHtag fromBytes(Tag tag, Uint8List bytes) =>
      new SHtag._fromBytes(tag, bytes);

  static SHtag fromBDE(Element e) => new SHtag._fromBytes(e.tag, e.vfBytes);
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

  factory STtag._fromBytes(Tag tag, Uint8List bytes) =>
      (ST.isNotValidTag(tag)) ? null : new STtag._(tag, ST.fromBytes(bytes));

  STtag._(this.tag, this.values);

  @override
  STtag update([Iterable<String> vList = kEmptyStringList]) =>
      new STtag(tag, vList ?? kEmptyStringList);

  static STtag make(Tag tag, Iterable<String> vList) =>
      new STtag(tag, vList ?? kEmptyStringList);

  static STtag fromBytes(Tag tag, Uint8List bytes) =>
      new STtag._fromBytes(tag, bytes);

  static STtag fromBDE(Element e) => new STtag._fromBytes(e.tag, e.vfBytes);
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

  factory UCtag._fromBytes(Tag tag, Uint8List bytes) =>
      (UC.isNotValidTag(tag)) ? null : new UCtag._(tag, UC.fromBytes(bytes));

  UCtag._(this.tag, this.values);

  @override
  UCtag update([Iterable<String> vList = kEmptyStringList]) =>
      new UCtag(tag, vList ?? kEmptyStringList);

  static UCtag make(Tag tag, Iterable<String> vList) =>
      new UCtag(tag, vList ?? kEmptyStringList);

  static UCtag fromBytes(Tag tag, Uint8List bytes) =>
      new UCtag._fromBytes(tag, bytes);

  static UCtag fromBDE(Element e) => new UCtag._fromBytes(e.tag, e.vfBytes);
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

  factory UItag._fromBytes(Tag tag, Uint8List bytes) =>
      (UI.isNotValidTag(tag)) ? null : new UItag._(tag, UI.fromBytes(bytes));

  UItag._(this.tag, this.values);

  @override
  UItag update([Iterable<String> vList = kEmptyStringList]) =>
      new UItag.fromStrings(tag, vList);

  static UItag make(Tag tag, Iterable<String> vList) =>
      new UItag.fromStrings(tag, vList ?? kEmptyStringList);

  static UItag fromBytes(Tag tag, Uint8List bytes) =>
      new UItag._fromBytes(tag, bytes);

  static UItag fromBDE(Element e) => new UItag._fromBytes(e.tag, e.vfBytes);

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

  factory URtag._fromBytes(Tag tag, Uint8List bytes) =>
      (UR.isNotValidTag(tag)) ? null : new URtag._(tag, UR.fromBytes(bytes));

  URtag._(this.tag, this.values);

  @override
  URtag update([Iterable<String> vList = kEmptyStringList]) =>
      new URtag(tag, vList ?? kEmptyStringList);

  static URtag make(Tag tag, Iterable<String> vList) =>
      new URtag(tag, vList ?? kEmptyStringList);

  static URtag fromBytes(Tag tag, Uint8List bytes) =>
      new URtag._fromBytes(tag, bytes);

  static URtag fromBDE(Element e) => new URtag._fromBytes(e.tag, e.vfBytes);
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

  factory UTtag._fromBytes(Tag tag, Uint8List bytes) =>
      (UT.isNotValidTag(tag)) ? null : new UTtag._(tag, UT.fromBytes(bytes));

  UTtag._(this.tag, this.values);

  @override
  UTtag update([Iterable<String> vList = kEmptyStringList]) =>
      new UTtag(tag, vList ?? kEmptyStringList);

  static UTtag make(Tag tag, Iterable<String> vList) =>
      new UTtag(tag, vList ?? kEmptyStringList);

  static UTtag fromBytes(Tag tag, Uint8List bytes) =>
      new UTtag._fromBytes(tag, bytes);

  static UTtag fromBDE(Element e) => new UTtag._fromBytes(e.tag, e.vfBytes);
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

  factory AStag._fromBytes(Tag tag, Uint8List bytes) =>
      (AS.isNotValidTag(tag)) ? null : new AStag._(tag, AS.fromBytes(bytes));

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

  static AStag fromBytes(Tag tag, Uint8List bytes) =>
      new AStag._fromBytes(tag, bytes);

  static AStag fromBDE(Element e) => new AStag._fromBytes(e.tag, e.vfBytes);

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

  factory DAtag._fromBytes(Tag tag, Uint8List bytes) =>
      (DA.isNotValidTag(tag)) ? null : new DAtag._(tag, DA.fromBytes(bytes));

  DAtag._(this.tag, this.values);

  @override
  DAtag update([Iterable<String> vList = kEmptyStringList]) =>
      new DAtag(tag, vList ?? kEmptyStringList);

  static DAtag make(Tag tag, Iterable<String> vList) =>
      new DAtag(tag, vList ?? kEmptyStringList);

  static DAtag fromBytes(Tag tag, Uint8List bytes) =>
      new DAtag._fromBytes(tag, bytes);

  static DAtag fromBDE(Element e) => new DAtag._fromBytes(e.tag, e.vfBytes);
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

  factory DTtag._fromBytes(Tag tag, Uint8List bytes) =>
      (DT.isNotValidTag(tag)) ? null : new DTtag._(tag, DT.fromBytes(bytes));

  DTtag._(this.tag, this.values);

  @override
  DTtag update([Iterable<String> vList = kEmptyStringList]) =>
      new DTtag(tag, vList ?? kEmptyStringList);

  static DTtag make(Tag tag, Iterable<String> vList) =>
      new DTtag(tag, vList ?? kEmptyStringList);

  static DTtag fromBytes(Tag tag, Uint8List bytes) =>
      new DTtag._fromBytes(tag, bytes);

  static DTtag fromBDE(Element e) => new DTtag._fromBytes(e.tag, e.vfBytes);
}

/// The DICOM [TM] (Time) [Element].
///
/// [Time] [String]s have the following format: HHMMSS.ffffff. [See PS3.18, TM]
/// (http://dicom.nema.org/medical/dicom/current/output/html/part18.html#para_3f950ae4-871c-48c5-b200-6bccf821653b)
class TMtag extends TM with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory TMtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (TM.isValidArgs(tag, vList))
          ? new TMtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  factory TMtag._fromBytes(Tag tag, Uint8List bytes) =>
      (TM.isNotValidTag(tag)) ? null : new TMtag._(tag, TM.fromBytes(bytes));

  TMtag._(this.tag, this.values);

  @override
  TMtag update([Iterable<String> vList = kEmptyStringList]) =>
      new TMtag(tag, vList ?? kEmptyStringList);

  static TMtag make(Tag tag, Iterable<String> vList) =>
      new TMtag(tag, vList ?? kEmptyStringList);

  static TMtag fromBytes(Tag tag, Uint8List bytes) =>
      new TMtag._fromBytes(tag, bytes);

  static TMtag fromBDE(Element e) => new TMtag._fromBytes(e.tag, e.vfBytes);
}
