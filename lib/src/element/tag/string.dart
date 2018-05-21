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
import 'package:core/src/value/uid.dart';
import 'package:core/src/vr.dart';

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
  List<String> _values;

  factory AEtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (AE.isValidArgs(tag, vList))
          ? new AEtag._(tag, vList)
          : badValues(vList, null, tag);

  factory AEtag._(Tag tag, Iterable<String> vList) {
    if (!AE.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    final v = (vList.isEmpty) ? StringList.kEmptyList : _toValues(vList);
    return new AEtag._x(tag, v);
  }

  AEtag._x(this.tag, Iterable<String> values) : _values = _toValues(values);

  @override
  Iterable<String> get values => _values;
  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
      (!AE.isValidTag(tag)) ? null : new AEtag._(tag, bytes.getAsciiList());
}

class CStag extends CS with TagElement<String> {
  @override
  final Tag tag;
  List<String> _values;

  factory CStag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (CS.isValidArgs(tag, vList))
          ? new CStag._(tag, vList)
          : badValues(vList, null, tag);

  CStag._(this.tag, Iterable<String> values) : _values = _toValues(values);

  @override
  Iterable<String> get values => _values;
  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
      (!CS.isValidTag(tag)) ? null : new CStag._(tag, bytes.getAsciiList());
}

class DStag extends DS with TagElement<String> {
  @override
  final Tag tag;
  List<String> _values;

  factory DStag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      new DStag._(tag, vList);

  factory DStag._(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (DS.isValidArgs(tag, vList))
          ? new DStag._x(tag, vList)
          : badValues(vList, null, tag);

  DStag._x(this.tag, Iterable<String> values) : _values = _toValues(values);

  @override
  Iterable<String> get values => _values;
  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

  @override
  DStag update([Iterable<String> vList = kEmptyStringList]) =>
      new DStag._(tag, vList ?? kEmptyStringList);

  static DStag fromValues(Tag tag, Iterable<String> vList) =>
      new DStag._(tag, vList ?? kEmptyStringList);

  static DStag fromBytes(Tag tag, Bytes bytes) =>
      (DS.isValidBytesArgs(tag, bytes))
          ? new DStag._(tag, bytes.getAsciiList())
          : badTag(tag, null, DS);
}

class IStag extends IS with TagElement<String> {
  @override
  final Tag tag;
  List<String> _values;

  factory IStag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (IS.isValidArgs(tag, vList))
          ? new IStag._(tag, vList)
          : badValues(vList, null, tag);

  IStag._(this.tag, Iterable<String> values) : _values = _toValues(values);

  @override
  Iterable<String> get values => _values;
  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
      (!IS.isValidTag(tag)) ? null : new IStag._(tag, bytes.getAsciiList());
}

/// A Long String (LO) Element
class LOtag extends LO with TagElement<String> {
  @override
  final Tag tag;
  List<String> _values;

  factory LOtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (LO.isValidArgs(tag, vList))
          ? new LOtag._(tag, vList)
          : badValues(vList, null, tag);

  LOtag._(this.tag, Iterable<String> values) : _values = _toValues(values);

  @override
  Iterable<String> get values => _values;
  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
      (!LO.isValidTag(tag)) ? null : new LOtag._(tag, bytes.getUtf8List());
}

class PCtag extends PC with TagElement<String> {
  @override
  final Tag tag;
  List<String> _values;

  factory PCtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (LO.isValidArgs(tag, vList))
          ? new PCtag._(tag, vList)
          : badValues(vList, null, tag);

  PCtag._(this.tag, Iterable<String> values) : _values = _toValues(values);

  @override
  Iterable<String> get values => _values;
  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
      (!LO.isValidTag(tag)) ? null : new PCtag._(tag, bytes.getUtf8List());

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
  List<String> _values;

  factory LTtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (LT.isValidArgs(tag, vList))
          ? new LTtag._(tag, vList)
          : badValues(vList, null, tag);

  LTtag._(this.tag, Iterable<String> values) : _values = _toValues(values);

  @override
  Iterable<String> get values => _values;
  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
      (!LT.isValidTag(tag))
          ? null
          : new LTtag._(tag, _toValues([bytes.getUtf8()]));
}

/// A Person Name ([PN]) Element.
class PNtag extends PN with TagElement<String> {
  @override
  final Tag tag;
  List<String> _values;

  factory PNtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (PN.isValidArgs(tag, vList))
          ? new PNtag._(tag, vList)
          : badValues(vList, null, tag);

  PNtag._(this.tag, Iterable<String> values) : _values = _toValues(values);

  @override
  Iterable<String> get values => _values;
  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
      (!PN.isValidTag(tag)) ? null : new PNtag._(tag, bytes.getUtf8List());
}

/// A Short String (SH) Element
class SHtag extends SH with TagElement<String> {
  @override
  final Tag tag;
  List<String> _values;

  factory SHtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (SH.isValidArgs(tag, vList))
          ? new SHtag._(tag, vList)
          : badValues(vList, null, tag);

  SHtag._(this.tag, Iterable<String> values) : _values = _toValues(values);

  @override
  Iterable<String> get values => _values;
  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
      (!SH.isValidTag(tag)) ? null : new SHtag._(tag, bytes.getUtf8List());
}

/// An Short Text (ST) Element
class STtag extends ST with TagElement<String> {
  @override
  final Tag tag;
  List<String> _values;

  factory STtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (ST.isValidArgs(tag, vList))
          ? new STtag._(tag, vList)
          : badValues(vList, null, tag);

  STtag._(this.tag, Iterable<String> values) : _values = _toValues(values);

  @override
  Iterable<String> get values => _values;
  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
      (!ST.isValidTag(tag))
          ? null
          : new STtag._(tag, _toValues([bytes.getUtf8()]));
}

/// An Unlimited Characters (UC) Element
class UCtag extends UC with TagElement<String> {
  @override
  final Tag tag;
  List<String> _values;

  factory UCtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (UC.isValidArgs(tag, vList))
          ? new UCtag._(tag, vList)
          : badValues(vList, null, tag);

  UCtag._(this.tag, Iterable<String> values) : _values = _toValues(values);

  @override
  Iterable<String> get values => _values;
  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
      (!UC.isValidTag(tag)) ? null : new UCtag._(tag, bytes.getUtf8List());
}

class UItag extends UI with TagElement<String> {
  @override
  final Tag tag;
  Iterable<String> _values;

  factory UItag(Tag tag, Iterable<String> vList, {bool validate = true}) {
    if (vList == null) return badValues(vList, null, tag);
    return (validate && vList == null || !UI.isValidArgs(tag, vList))
        ? badValues(vList, null, tag)
        : new UItag._(tag, vList, null);
  }

  factory UItag.fromStrings(Tag tag, Iterable<String> sList,
          {bool validate = true}) =>
      (sList == null || (validate && !UI.isValidArgs(tag, sList)))
          ? badValues(sList, null, tag)
          : new UItag._(tag, sList, null);

  factory UItag.fromUids(Tag tag, Iterable<Uid> vList,
          {bool validate = true}) =>
      (vList == null || (validate && !UI.isValidUidArgs(tag, vList)))
          ? badValues(vList, null, tag)
          : new UItag._(tag, null, vList);

  UItag._(this.tag, this._values, this._uids);

  @override
  List<String> get values => _values ??= uids.map((uid) => uid.asString);
  @override
  set values(Iterable<String> vList) => _values = vList;

  @override
  Iterable<Uid> get uids => _uids ??= Uid.parseList(values);
  Iterable<Uid> _uids;

  @override
  UItag update([Iterable<String> vList = kEmptyStringList]) =>
      new UItag(tag, vList);

  static UItag fromValues(Tag tag, Iterable<String> vList,
          [int _, TransferSyntax __]) =>
      new UItag(tag, vList ?? kEmptyStringList);

  static UItag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.typedDataView(bytes));

  static UItag from(Element e) => fromBytes(e.tag, e.vfBytes);

  static UItag fromBytes(Tag tag, Bytes bytes, [int _, TransferSyntax __]) =>
      (!UI.isValidTag(tag)) ? null : new UItag(tag, bytes.getAsciiList());
}

/// Value Representation of [Uri].
///
/// The Value Multiplicity of this Element is 1.
class URtag extends UR with TagElement<String> {
  @override
  final Tag tag;
  List<String> _values;

  factory URtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (UR.isValidArgs(tag, vList))
          ? new URtag._(tag, vList)
          : badValues(vList, null, tag);

  URtag._(this.tag, Iterable<String> values) : _values = _toValues(values);

  @override
  Iterable<String> get values => _values;
  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
      (!UR.isValidTag(tag))
          ? null
          : new URtag._(tag, _toValues([bytes.getUtf8()]));
}

/// An Unlimited Text (UT) Element
class UTtag extends UT with TagElement<String> {
  @override
  final Tag tag;
  List<String> _values;

  factory UTtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (UT.isValidArgs(tag, vList))
          ? new UTtag._(tag, vList)
          : badValues(vList, null, tag);

  UTtag._(this.tag, Iterable<String> values) : _values = _toValues(values);

  @override
  Iterable<String> get values => _values;
  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
      (!UT.isValidTag(tag))
          ? null
          : new UTtag._(tag, _toValues([bytes.getUtf8()]));
}

// **** Date/Time classes
/// A Application Entity Title (AS) Element
class AStag extends AS with TagElement<String> {
  @override
  final Tag tag;
  List<String> _values;

  factory AStag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      new AStag._(tag, vList);

  factory AStag._(Tag tag, Iterable<String> vList) {
    vList ??= <String>[];
    return (AS.isValidArgs(tag, vList))
        ? new AStag._x(tag, vList)
        : badValues(vList, null, tag);
  }

  AStag._x(this.tag, Iterable<String> values) : _values = _toValues(values);

  @override
  Iterable<String> get values => _values;
  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

  @override
  AStag update([Iterable<String> vList = kEmptyStringList]) =>
      new AStag._(tag, vList);

  @override
  AStag updateF(Iterable<String> f(Iterable<String> vList)) =>
      new AStag._(tag, f(values));

  static AStag fromValues(Tag tag, Iterable<String> vList,
          [int _, TransferSyntax __]) =>
      new AStag._(tag, vList ?? kEmptyStringList);

  static AStag fromBytes(Tag tag, Bytes bytes) =>
      (bytes != null || AS.isValidTag(tag))
          ? new AStag(tag, bytes.getAsciiList())
          : null;
}

/// A DICOM Date ([DA]) [Element].
class DAtag extends DA with TagElement<String> {
  @override
  final Tag tag;
  List<String> _values;

  factory DAtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (DA.isValidArgs(tag, vList))
          ? new DAtag._(tag, _toValues(vList))
          : badValues(vList, null, tag);

  DAtag._(this.tag, Iterable<String> values) : _values = _toValues(values);

  @override
  Iterable<String> get values => _values;
  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

  @override
  DAtag update([Iterable<String> vList = kEmptyStringList]) =>
      new DAtag(tag, vList ?? kEmptyStringList);

  static DAtag fromValues(Tag tag, Iterable<String> vList,
          [int _, TransferSyntax __]) =>
      new DAtag(tag, vList ?? kEmptyStringList);

  static DAtag fromUint8List(Tag tag, Uint8List bytes) =>
      fromBytes(tag, new Bytes.typedDataView(bytes));

  static DAtag fromBytes(Tag tag, Bytes bytes, [int _, TransferSyntax __]) =>
      (!DA.isValidTag(tag)) ? null : new DAtag._(tag, bytes.getAsciiList());
}

/// A DICOM DateTime [DT] [Element].
///
/// A concatenated date-time character string in the
/// format: YYYYMMDDHHMMSS.FFFFFF&ZZXX
class DTtag extends DT with TagElement<String> {
  @override
  final Tag tag;
  List<String> _values;

  factory DTtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (DT.isValidArgs(tag, vList))
          ? new DTtag._(tag, vList)
          : badValues(vList, null, tag);

  DTtag._(this.tag, Iterable<String> values) : _values = _toValues(values);

  @override
  Iterable<String> get values => _values;
  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
      (!DT.isValidTag(tag)) ? null : new DTtag._(tag, bytes.getAsciiList());
}

/// The DICOM [TM] (Time) [Element].
///
/// [Time] [String]s have the following format: HHMMSS.ffffff. [See PS3.18, TM]
/// (http://dicom.nema.org/medical/dicom/current/output/html/part18.html
/// #para_3f950ae4-871c-48c5-b200-6bccf821653b)
class TMtag extends TM with TagElement<String> {
  @override
  final Tag tag;
  List<String> _values;

  factory TMtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (TM.isValidArgs(tag, vList))
          ? new TMtag._(tag, vList)
          : badValues(vList, null, tag);

  TMtag._(this.tag, Iterable<String> values) : _values = _toValues(values);

  @override
  Iterable<String> get values => _values;
  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
      (!TM.isValidTag(tag)) ? null : new TMtag._(tag, bytes.getAsciiList());
}

StringList _toValues(Iterable<String> vList) =>
    (vList is StringList) ? vList : new StringList.from(vList);
