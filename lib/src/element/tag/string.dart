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
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/value/date_time.dart';
import 'package:core/src/value/empty_list.dart';
import 'package:core/src/value/uid.dart';
import 'package:core/src/vr_base.dart';

abstract class TagStringMixin {
  // **** Interface
  ByteData get bd;
  int get eLength;
  int get padChar;
  int get vfOffset;
  int get vfLengthField;
  StringBase update([Iterable<String> vList]);

  // **** End interface

  /// Returns the actual length in bytes after removing any padding chars.
  // Floats always have a valid (defined length) vfLengthField.
  int get vfLength {
    final vf0 = vfOffset;
    final lib = bd.lengthInBytes;
    final length = lib - vf0;
    assert(length >= 0);
    return length;
  }

  int get valuesLength {
    if (vfLength == 0) return 0;
    var count = 1;
    for (var i = vfOffset; i < eLength; i++)
      if (bd.getUint8(i) == kBackslash) count++;
    return count;
  }
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

  @override
  AEtag update([Iterable<String> vList = kEmptyStringList]) =>
      new AEtag(tag, vList ?? kEmptyStringList);

  static AEtag fromValues(Tag tag, Iterable<String> vList,
          [int _, TransferSyntax __]) =>
      new AEtag(tag, vList ?? kEmptyStringList);

  static AEtag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.typedDataView(bytes));

  static AEtag from(Element e) => fromBytes(e.tag, e.vfBytes);

  static AEtag fromBytes(Tag tag, Bytes bytes, [int _, TransferSyntax __]) =>
      (AE.isNotValidTag(tag)) ? null : new AEtag._(tag, bytes.getAsciiList());
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

  @override
  CStag update([Iterable<String> vList = kEmptyStringList]) =>
      new CStag(tag, vList ?? kEmptyStringList);

  static CStag fromValues(Tag tag, Iterable<String> vList,
          [int _, TransferSyntax __]) =>
      new CStag(tag, vList ?? kEmptyStringList);

  static CStag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.typedDataView(bytes));

  static CStag from(Element e) => fromBytes(e.tag, e.vfBytes);

  static CStag fromBytes(Tag tag, Bytes bytes, [int _, TransferSyntax __]) =>
      (CS.isNotValidTag(tag)) ? null : new CStag._(tag, bytes.getAsciiList());
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

  @override
  DStag update([Iterable<String> vList = kEmptyStringList]) =>
      new DStag(tag, vList ?? kEmptyStringList);

  static DStag fromValues(Tag tag, Iterable<String> vList,
          [int _, TransferSyntax __]) =>
      new DStag(tag, vList ?? kEmptyStringList);

  static DStag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.typedDataView(bytes));

  static DStag from(Element e) => fromBytes(e.tag, e.vfBytes);

  static DStag fromBytes(Tag tag, Bytes bytes, [int _, TransferSyntax __]) =>
      (DS.isNotValidTag(tag)) ? null : new DStag._(tag, bytes.getAsciiList());
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

  @override
  IStag update([Iterable<String> vList = kEmptyStringList]) =>
      new IStag(tag, vList ?? kEmptyStringList);

  static IStag fromValues(Tag tag, Iterable<String> vList,
          [int _, TransferSyntax __]) =>
      new IStag(tag, vList ?? kEmptyStringList);

  static IStag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.typedDataView(bytes));

  static IStag from(Element e) => fromBytes(e.tag, e.vfBytes);

  static IStag fromBytes(Tag tag, Bytes bytes, [int _, TransferSyntax __]) =>
      (IS.isNotValidTag(tag)) ? null : new IStag._(tag, bytes.getAsciiList());
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

  LOtag._(this.tag, this.values);

  @override
  LOtag update([Iterable<String> vList = kEmptyStringList]) =>
      new LOtag(tag, vList ?? kEmptyStringList);

  static LOtag fromValues(Tag tag, Iterable<String> vList,
          [int _, TransferSyntax __]) =>
      new LOtag(tag, vList ?? kEmptyStringList);

  static LOtag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.typedDataView(bytes));

  static LOtag from(Element e) => fromBytes(e.tag, e.vfBytes);

  static LOtag fromBytes(Tag tag, Bytes bytes, [int _, TransferSyntax __]) =>
      (LO.isNotValidTag(tag)) ? null : new LOtag._(tag, bytes.getUtf8List());
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

  PCtag._(this.tag, this.values);

  @override
  String get token => value;

  @override
  PCtag update([Iterable<String> vList = kEmptyStringList]) =>
      new PCtag(tag, vList ?? kEmptyStringList);

  @override
  String toString() => '$runtimeType $tag $value';

  static PCtag fromValues(Tag tag, Iterable<String> vList,
          [int _, TransferSyntax __]) =>
      new PCtag(tag, vList ?? kEmptyStringList);

  static PCtag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.typedDataView(bytes));

  static PCtag from(Element e) => fromBytes(e.tag, e.vfBytes);

  static PCtag fromBytes(Tag tag, Bytes bytes, [int _, TransferSyntax __]) =>
      (LO.isNotValidTag(tag)) ? null : new PCtag._(tag, bytes.getUtf8List());

  static PCtag makePhantom(int group, int subgroup) {
    const name = PDTag.phantomName;
    final code = (group << 16) + subgroup;
    final tag = new PCTagUnknown(code, kLOIndex, name);
    return new PCtag(tag, const <String>[name]);
  }

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

  LTtag._(this.tag, this.values);

  @override
  LTtag update([Iterable<String> vList = kEmptyStringList]) =>
      new LTtag(tag, vList ?? kEmptyStringList);

  static LTtag fromValues(Tag tag, Iterable<String> vList,
          [int _, TransferSyntax __]) =>
      new LTtag(tag, vList ?? kEmptyStringList);

  static LTtag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.typedDataView(bytes));

  static LTtag from(Element e) => fromBytes(e.tag, e.vfBytes);

  static LTtag fromBytes(Tag tag, Bytes bytes, [int _, TransferSyntax __]) =>
      (LT.isNotValidTag(tag)) ? null : new LTtag._(tag, [bytes.getUtf8()]);
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

  @override
  PNtag update([Iterable<String> vList = kEmptyStringList]) =>
      new PNtag(tag, vList ?? kEmptyStringList);

  static PNtag fromValues(Tag tag, Iterable<String> vList,
          [int _, TransferSyntax __]) =>
      new PNtag(tag, vList ?? kEmptyStringList);

  static PNtag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.typedDataView(bytes));

  static PNtag from(Element e) => fromBytes(e.tag, e.vfBytes);

  static PNtag fromBytes(Tag tag, Bytes bytes, [int _, TransferSyntax __]) =>
      (PN.isNotValidTag(tag)) ? null : new PNtag._(tag, bytes.getUtf8List());
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

  @override
  SHtag update([Iterable<String> vList = kEmptyStringList]) =>
      new SHtag(tag, vList ?? kEmptyStringList);

  static SHtag fromValues(Tag tag, Iterable<String> vList,
          [int _, TransferSyntax __]) =>
      new SHtag(tag, vList ?? kEmptyStringList);

  static SHtag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.typedDataView(bytes));

  static SHtag from(Element e) => fromBytes(e.tag, e.vfBytes);

  static SHtag fromBytes(Tag tag, Bytes bytes, [int _, TransferSyntax __]) =>
      (SH.isNotValidTag(tag)) ? null : new SHtag._(tag, bytes.getUtf8List());
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

  @override
  STtag update([Iterable<String> vList = kEmptyStringList]) =>
      new STtag(tag, vList ?? kEmptyStringList);

  static STtag fromValues(Tag tag, Iterable<String> vList,
          [int _, TransferSyntax __]) =>
      new STtag(tag, vList ?? kEmptyStringList);

  static STtag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.typedDataView(bytes));

  static STtag from(Element e) => fromBytes(e.tag, e.vfBytes);

  static STtag fromBytes(Tag tag, Bytes bytes, [int _, TransferSyntax __]) =>
      (ST.isNotValidTag(tag)) ? null : new STtag._(tag, [bytes.getUtf8()]);
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

  @override
  UCtag update([Iterable<String> vList = kEmptyStringList]) =>
      new UCtag(tag, vList ?? kEmptyStringList);

  static UCtag fromValues(Tag tag, Iterable<String> vList,
          [int _, TransferSyntax __]) =>
      new UCtag(tag, vList ?? kEmptyStringList);

  static UCtag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.typedDataView(bytes));

  static UCtag from(Element e) => fromBytes(e.tag, e.vfBytes);

  static UCtag fromBytes(Tag tag, Bytes bytes, [int _, TransferSyntax __]) =>
      (UC.isNotValidTag(tag)) ? null : new UCtag._(tag, bytes.getUtf8List());
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

  @override
  UItag update([Iterable<String> vList = kEmptyStringList]) =>
      new UItag.fromStrings(tag, vList);

  static UItag fromValues(Tag tag, Iterable<String> vList,
          [int _, TransferSyntax __]) =>
      new UItag.fromStrings(tag, vList ?? kEmptyStringList);

  static UItag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.typedDataView(bytes));

  static UItag from(Element e) => fromBytes(e.tag, e.vfBytes);

  static UItag fromBytes(Tag tag, Bytes bytes, [int _, TransferSyntax __]) =>
      (UI.isNotValidTag(tag)) ? null : new UItag._(tag, bytes.getAsciiList());

  static Iterable<Uid> parse(List<String> vList) {
    final uids = new List<Uid>(vList.length);
    for (var i = 0; i < vList.length; i++) {
      final uid = Uid.parse(vList[i]);
      uids[i] = uid;
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

  @override
  URtag update([Iterable<String> vList = kEmptyStringList]) =>
      new URtag(tag, vList ?? kEmptyStringList);

  static URtag fromValues(Tag tag, Iterable<String> vList,
          [int _, TransferSyntax __]) =>
      new URtag(tag, vList ?? kEmptyStringList);

  static URtag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.typedDataView(bytes));

  static URtag from(Element e) => fromBytes(e.tag, e.vfBytes);

  static URtag fromBytes(Tag tag, Bytes bytes, [int _, TransferSyntax __]) =>
      (UR.isNotValidTag(tag)) ? null : new URtag._(tag, [bytes.getUtf8()]);
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

  @override
  UTtag update([Iterable<String> vList = kEmptyStringList]) =>
      new UTtag(tag, vList ?? kEmptyStringList);

  static UTtag fromValues(Tag tag, Iterable<String> vList,
          [int _, TransferSyntax __]) =>
      new UTtag(tag, vList ?? kEmptyStringList);

  static UTtag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.typedDataView(bytes));

  static UTtag from(Element e) => fromBytes(e.tag, e.vfBytes);

  static UTtag fromBytes(Tag tag, Bytes bytes, [int _, TransferSyntax __]) =>
      (UT.isNotValidTag(tag)) ? null : new UTtag._(tag, [bytes.getUtf8()]);
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

  @override
  AStag update([Iterable<String> vList = kEmptyStringList]) =>
      (AS.isValidValues(tag, vList))
          ? new AStag(tag, vList)
          : invalidValuesError(values);

  @override
  AStag updateF(Iterable<String> f(Iterable<String> vList)) =>
      new AStag(tag, f(values));

  static AStag fromValues(Tag tag, Iterable<String> vList,
          [int _, TransferSyntax __]) =>
      new AStag(tag, vList ?? kEmptyStringList);

  static AStag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.typedDataView(bytes));

  static AStag from(Element e) => fromBytes(e.tag, e.vfBytes);

  static AStag fromBytes(Tag tag, Bytes bytes, [int _, TransferSyntax __]) =>
      (AS.isNotValidTag(tag)) ? null : new AStag._(tag, bytes.getAsciiList());

  static AStag parse(String s, {String onError(String s)}) => new AStag(
      PTag.kPatientAge,
      Age.isValidString(s)
          ? <String>[s]
          : invalidValuesError(<String>[s], tag: PTag.kPatientAge));
}

/// A DICOM Date ([DA]) [Element].
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

  @override
  DAtag update([Iterable<String> vList = kEmptyStringList]) =>
      new DAtag(tag, vList ?? kEmptyStringList);

  static DAtag fromValues(Tag tag, Iterable<String> vList,
          [int _, TransferSyntax __]) =>
      new DAtag(tag, vList ?? kEmptyStringList);

  static DAtag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.typedDataView(bytes));

  static DAtag from(Element e) => new DAtag(e.tag, e.values);

  static DAtag fromBytes(Tag tag, Bytes bytes, [int _, TransferSyntax __]) =>
      (DA.isNotValidTag(tag)) ? null : new DAtag._(tag, bytes.getAsciiList());
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

  DTtag._(this.tag, this.values);

  @override
  DTtag update([Iterable<String> vList = kEmptyStringList]) =>
      new DTtag(tag, vList ?? kEmptyStringList);

  static DTtag fromValues(Tag tag, Iterable<String> vList,
          [int _, TransferSyntax __]) =>
      new DTtag(tag, vList ?? kEmptyStringList);

  static DTtag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.typedDataView(bytes));

  static DTtag from(Element e) => fromBytes(e.tag, e.vfBytes);

  static DTtag fromBytes(Tag tag, Bytes bytes, [int _, TransferSyntax __]) =>
      (DT.isNotValidTag(tag)) ? null : new DTtag._(tag, bytes.getAsciiList());
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

  TMtag._(this.tag, this.values);

  @override
  TMtag update([Iterable<String> vList = kEmptyStringList]) =>
      new TMtag(tag, vList ?? kEmptyStringList);

  static TMtag fromValues(Tag tag, Iterable<String> vList,
          [int _, TransferSyntax __]) =>
      new TMtag(tag, vList ?? kEmptyStringList);

  static TMtag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.typedDataView(bytes));

  static TMtag from(Element e) => fromBytes(e.tag, e.vfBytes);

  static TMtag fromBytes(Tag tag, Bytes bytes, [int _, TransferSyntax __]) =>
      (TM.isNotValidTag(tag)) ? null : new TMtag._(tag, bytes.getAsciiList());
}
