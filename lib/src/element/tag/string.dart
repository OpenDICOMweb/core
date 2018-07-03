//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/src/element/base.dart';
import 'package:core/src/element/tag/tag_element.dart';
import 'package:core/src/error.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/values.dart';
import 'package:core/src/vr.dart';

StringList setValues(Iterable<String> vList) {
  if (vList == null) return StringList.kEmptyList;
  return (vList is StringList) ? vList : new StringList.from(vList);
}

class AEtag extends AE with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  /// Creates an [AEtag] Element.
  factory AEtag(Tag tag, [Iterable<String> vList]) {
    final v = new StringList.from(vList);
    return AE.isValidArgs(tag, v)
        ? new AEtag._(tag, v)
        : badValues(v, null, tag);
  }

  AEtag._(this.tag, this._values) : assert(tag.vrIndex == kAEIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = setValues(vList);

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  @override
  StringList replace([Iterable<String> vList]) {
    final old = values;
    values = vList;
    return old;
  }

  StringList get trimmed => values.trim(trim);

  @override
  AEtag update([Iterable<String> vList]) => new AEtag(tag, vList);

  static AEtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      new AEtag(tag, vList);

  static AEtag fromBytes(Tag tag, Bytes bytes) =>
      new AEtag(tag, bytes.getAsciiList(padChar: kSpace));
}

class CStag extends CS with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory CStag(Tag tag, [Iterable<String> vList]) {
    final v = new StringList.from(vList);
    return CS.isValidArgs(tag, v)
        ? new CStag._(tag, v)
        : badValues(v, null, tag);
  }

  CStag._(this.tag, this._values) : assert(tag.vrIndex == kCSIndex);

  @override
  StringList get values {
    final v = _values;
    return (convertLowercase) ? v.uppercase : v;
  }

  @override
  set values(Iterable<String> vList) => _values = setValues(vList);

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  @override
  StringList replace([Iterable<String> vList]) {
    final old = values;
    values = vList;
    return old;
  }

  StringList get trimmed => values.trim(trim);

  /// Special variable for overriding uppercase constraint. If _true_
  /// lowercase characters in [values] are converted to uppercase
  /// before being returned.
  static bool convertLowercase = false;

  @override
  CStag update([Iterable<String> vList]) => new CStag(tag, vList);

  static CStag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      new CStag(tag, vList);

  static CStag fromBytes(Tag tag, Bytes bytes) =>
      new CStag(tag, bytes.getAsciiList());
}

class DStag extends DS with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory DStag(Tag tag, [Iterable<String> vList = kEmptyStringList]) {
    final v = new StringList.from(vList);
    return DS.isValidArgs(tag, v)
        ? new DStag._(tag, v)
        : badValues(v, null, tag);
  }

  DStag._(this.tag, this._values) : assert(tag.vrIndex == kDSIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = setValues(vList);

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  @override
  StringList replace([Iterable<String> vList]) {
    final old = values;
    values = vList;
    return old;
  }

  StringList get trimmed => values.trim(trim);

  @override
  DStag update([Iterable<String> vList]) => new DStag(tag, vList);

  static DStag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      new DStag(tag, vList);

  static DStag fromBytes(Tag tag, Bytes bytes) =>
      new DStag(tag, bytes.getAsciiList(padChar: kSpace));
}

class IStag extends IS with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory IStag(Tag tag, [Iterable<String> vList = kEmptyStringList]) {
    final v = new StringList.from(vList);
    return IS.isValidArgs(tag, v)
        ? new IStag._(tag, v)
        : badValues(v, null, tag);
  }

  IStag._(this.tag, this._values) : assert(tag.vrIndex == kISIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = setValues(vList);

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  @override
  StringList replace([Iterable<String> vList]) {
    final old = values;
    values = vList;
    return old;
  }

  StringList get trimmed => values.trim(trim);

  @override
  IStag update([Iterable<String> vList]) => new IStag(tag, vList);

  static IStag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      new IStag(tag, vList);

  static IStag fromBytes(Tag tag, Bytes bytes) =>
      new IStag(tag, bytes.getAsciiList());
}

/// A Long String (LO) Element
class LOtag extends LO with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory LOtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) {
    final v = new StringList.from(vList);
    return LO.isValidArgs(tag, v)
        ? new LOtag._(tag, v)
        : badValues(v, null, tag);
  }

  LOtag._(this.tag, this._values) : assert(tag.vrIndex == kLOIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = setValues(vList);

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  @override
  StringList replace([Iterable<String> vList]) {
    final old = values;
    values = vList;
    return old;
  }

  StringList get trimmed => values.trim(trim);

  @override
  LOtag update([Iterable<String> vList]) => new LOtag(tag, vList);

  static LOtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      new LOtag(tag, vList);

  static LOtag fromBytes(Tag tag, Bytes bytes) =>
      new LOtag(tag, bytes.getUtf8List());
}

class PCtag extends PC with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory PCtag(Tag tag, [StringList vList = kEmptyStringList]) {
    final v = new StringList.from(vList);
    return PC.isValidArgs(tag, v)
        ? new PCtag._(tag, v)
        : badValues(v, null, tag);
  }

  PCtag._(this.tag, this._values) : assert(tag.vrIndex == kLOIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = setValues(vList);

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  @override
  StringList replace([Iterable<String> vList]) {
    final old = values;
    values = vList;
    return old;
  }

  StringList get trimmed => values.trim(trim);

  @override
  String get token => value;

  @override
  PCtag update([Iterable<String> vList]) => new PCtag(tag, vList);

  @override
  String toString() => '$runtimeType $tag $value';

  static PCtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      new PCtag(tag, vList);

  static PCtag fromBytes(Tag tag, Bytes bytes) {
    final s = bytes.getUtf8().trim();
    return new PCtag(tag, StringList.from([s]));
  }

  static PCtag makePhantom(int group, int subgroup) {
    const name = PDTag.phantomName;
    final code = (group << 16) + subgroup;
    final tag = new PCTagUnknown(code, kLOIndex, name);
    return new PCtag(tag, StringList.from(const <String>[name]));
  }

  static PCtag makeEmptyPrivateCreator(int pdCode, int vrIndex) {
    final group = Tag.privateGroup(pdCode);
    final sgNumber = (pdCode & 0xFFFF) >> 8;
    final code = (group << 16) + sgNumber;
    final tag = new PCTagUnknown(code, kLOIndex, '');
    return new PCtag(tag, StringList.from(const <String>['']));
  }
}

/// An Long Text (LT) Element
class LTtag extends LT with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory LTtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) {
    final v = new StringList.from(vList);
    return LT.isValidArgs(tag, v)
        ? new LTtag._(tag, v)
        : badValues(v, null, tag);
  }

  LTtag._(this.tag, this._values) : assert(tag.vrIndex == kLTIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = setValues(vList);

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  @override
  StringList replace([Iterable<String> vList]) {
    final old = values;
    values = vList;
    return old;
  }

  StringList get trimmed => values.trim(trim);

  @override
  LTtag update([Iterable<String> vList]) => new LTtag(tag, vList);

  static LTtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      new LTtag(tag, vList);

  static LTtag fromBytes(Tag tag, Bytes bytes) =>
      new LTtag(tag, new StringList.from([bytes.getUtf8()]));
}

/// A Person Name ([PN]) Element.
class PNtag extends PN with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory PNtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) {
    final v = new StringList.from(vList);
    return PN.isValidArgs(tag, v)
        ? new PNtag._(tag, v)
        : badValues(v, null, tag);
  }

  PNtag._(this.tag, this._values) : assert(tag.vrIndex == kPNIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = setValues(vList);

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  @override
  StringList replace([Iterable<String> vList]) {
    final old = values;
    values = vList;
    return old;
  }

  StringList get trimmed => values.trim(trim);

  @override
  PNtag update([Iterable<String> vList]) => new PNtag(tag, vList);

  static PNtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      new PNtag(tag, vList);

  static PNtag fromBytes(Tag tag, Bytes bytes) =>
      new PNtag(tag, bytes.getUtf8List());
}

/// A Short String (SH) Element
class SHtag extends SH with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory SHtag(Tag tag, [Iterable<String> vList]) {
    final v = new StringList.from(vList);
    return SH.isValidArgs(tag, v)
        ? new SHtag._(tag, v)
        : badValues(v, null, tag);
  }

  SHtag._(this.tag, this._values) : assert(tag.vrIndex == kSHIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = setValues(vList);

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  @override
  StringList replace([Iterable<String> vList]) {
    final old = values;
    values = vList;
    return old;
  }

  StringList get trimmed => values.trim(trim);

  @override
  SHtag update([Iterable<String> vList]) => new SHtag(tag, vList);

  static SHtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      new SHtag(tag, vList);

  static SHtag fromBytes(Tag tag, Bytes bytes) =>
      new SHtag(tag, bytes.getUtf8List());
}

/// An Short Text (ST) Element
class STtag extends ST with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory STtag(Tag tag, [Iterable<String> vList]) {
    final v = new StringList.from(vList);
    return ST.isValidArgs(tag, v)
        ? new STtag._(tag, v)
        : badValues(v, null, tag);
  }

  STtag._(this.tag, this._values) : assert(tag.vrIndex == kSTIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = setValues(vList);

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  @override
  StringList replace([Iterable<String> vList]) {
    final old = values;
    values = vList;
    return old;
  }

  StringList get trimmed => values.trim(trim);

  @override
  STtag update([Iterable<String> vList]) => new STtag(tag, vList);

  static STtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      new STtag(tag, vList);

  static STtag fromBytes(Tag tag, Bytes bytes) =>
      new STtag(tag, new StringList.from([bytes.getUtf8()]));
}

/// An Unlimited Characters (UC) Element
class UCtag extends UC with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory UCtag(Tag tag, [Iterable<String> vList]) {
    final v = new StringList.from(vList);
    return UC.isValidArgs(tag, v)
        ? new UCtag._(tag, v)
        : badValues(v, null, tag);
  }

  UCtag._(this.tag, this._values) : assert(tag.vrIndex == kUCIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = setValues(vList);

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  @override
  StringList replace([Iterable<String> vList]) {
    final old = values;
    values = vList;
    return old;
  }

  StringList get trimmed => values.trim(trim);

  @override
  UCtag update([Iterable<String> vList]) => new UCtag(tag, vList);

  static UCtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      new UCtag(tag, vList);

  static UCtag fromBytes(Tag tag, Bytes bytes) =>
      new UCtag(tag, bytes.getUtf8List());
}

class UItag extends UI with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory UItag(Tag tag, [Iterable<String> vList]) {
    final v = new StringList.from(vList);
    return UI.isValidArgs(tag, v)
        ? new UItag._(tag, v, null)
        : badValues(v, null, tag);
  }

  factory UItag.fromUids(Tag tag, Iterable<Uid> uidList) {
    if (!UI.isValidUidArgs(tag, uidList)) return badValues(uidList, null, tag);
    final v = new StringList.from(uidList.map((uid) => uid.asString));
    List<Uid> uids;
    if (uidList != null) uids = uidList.toList(growable: false);
    return new UItag._(tag, v, uids);
  }

  UItag._(this.tag, this._values, this._uids) : assert(tag.vrIndex == kUIIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = setValues(vList);

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  @override
  StringList replace([Iterable<String> vList]) {
    final old = values;
    values = vList;
    return old;
  }

  StringList get trimmed => values.trim(trim);

  @override
  List<Uid> get uids => _uids ??= Uid.parseList(values);
  Iterable<Uid> _uids;

  @override
  UItag update([Iterable<String> vList]) => new UItag(tag, vList);

  static UItag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      new UItag(tag, vList);

  static UItag fromBytes(Tag tag, Bytes bytes) =>
      new UItag(tag, bytes.getAsciiList(padChar: kNull));
}

/// Value Representation of [Uri].
///
/// The Value Multiplicity of this Element is 1.
class URtag extends UR with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory URtag(Tag tag, [Iterable<String> vList]) {
    final v = new StringList.from(vList);
    return UR.isValidArgs(tag, v)
        ? new URtag._(tag, v)
        : badValues(v, null, tag);
  }

  URtag._(this.tag, this._values) : assert(tag.vrIndex == kURIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = setValues(vList);

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  @override
  StringList replace([Iterable<String> vList]) {
    final old = values;
    values = vList;
    return old;
  }

  StringList get trimmed => values.trim(trim);

  @override
  URtag update([Iterable<String> vList]) => new URtag(tag, vList);

  static URtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      new URtag(tag, vList);

  static URtag fromBytes(Tag tag, Bytes bytes) =>
      new URtag(tag, new StringList.from([bytes.getUtf8()]));
}

/// An Unlimited Text (UT) Element
class UTtag extends UT with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory UTtag(Tag tag, [Iterable<String> vList]) {
    final v = new StringList.from(vList);
    return UT.isValidArgs(tag, v)
        ? new UTtag._(tag, v)
        : badValues(v, null, tag);
  }

  UTtag._(this.tag, this._values) : assert(tag.vrIndex == kUTIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = setValues(vList);

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  @override
  StringList replace([Iterable<String> vList]) {
    final old = values;
    values = vList;
    return old;
  }

  StringList get trimmed => values.trim(trim);

  @override
  UTtag update([Iterable<String> vList]) => new UTtag(tag, vList);

  static UTtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      new UTtag(tag, vList);

  static UTtag fromBytes(Tag tag, Bytes bytes) =>
      new UTtag(tag, new StringList.from([bytes.getUtf8()]));
}

// **** Date/Time classes
/// A Application Entity Title (AS) Element
class AStag extends AS with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory AStag(Tag tag, [Iterable<String> vList]) {
    final v = new StringList.from(vList);
    return AS.isValidArgs(tag, v)
        ? new AStag._(tag, v)
        : badValues(v, null, tag);
  }

  AStag._(this.tag, this._values) : assert(tag.vrIndex == kASIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = setValues(vList);

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  @override
  StringList replace([Iterable<String> vList]) {
    final old = values;
    values = vList;
    return old;
  }

  StringList get trimmed => values.trim(trim);

  @override
  AStag update([Iterable<String> vList]) => new AStag(tag, vList);

  static AStag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      new AStag(tag, vList);

  static AStag fromBytes(Tag tag, Bytes bytes) =>
      new AStag(tag, bytes.getAsciiList());
}

/// A DICOM Date ([DA]) [Element].
class DAtag extends DA with TagElement<String>  {
  @override
  final Tag tag;
  StringList _values;

  factory DAtag(Tag tag, [Iterable<String> vList]) {
    final v = new StringList.from(vList);
    return DA.isValidArgs(tag, v)
        ? new DAtag._(tag, new StringList.from(v))
        : badValues(v, null, tag);
  }

  DAtag._(this.tag, this._values) : assert(tag.vrIndex == kDAIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = setValues(vList);

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  @override
  StringList replace([Iterable<String> vList]) {
    final old = values;
    values = vList;
    return old;
  }

  StringList get trimmed => values.trim(trim);

  @override
  DAtag update([Iterable<String> vList]) => new DAtag(tag, vList);

  static DAtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      new DAtag(tag, vList);

  static DAtag fromBytes(Tag tag, Bytes bytes) =>
      new DAtag(tag, bytes.getAsciiList());
}

/// A DICOM DateTime [DT] [Element].
///
/// A concatenated date-time character string in the
/// format: YYYYMMDDHHMMSS.FFFFFF&ZZXX
class DTtag extends DT with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory DTtag(Tag tag, [Iterable<String> vList]) {
    final v = new StringList.from(vList);
    return DT.isValidArgs(tag, v)
        ? new DTtag._(tag, v)
        : badValues(v, null, tag);
  }

  DTtag._(this.tag, this._values) : assert(tag.vrIndex == kDTIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = setValues(vList);

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  @override
  StringList replace([Iterable<String> vList]) {
    final old = values;
    values = vList;
    return old;
  }

  StringList get trimmed => values.trim(trim);

  @override
  DTtag update([Iterable<String> vList]) => new DTtag(tag, vList);

  static DTtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      new DTtag(tag, vList);

  static DTtag fromBytes(Tag tag, Bytes bytes) =>
      new DTtag(tag, bytes.getAsciiList());
}

/// The DICOM [TM] (Time) [Element].
///
/// [Time] [String]s have the following format: HHMMSS.ffffff. [See PS3.18, TM]
/// (http://dicom.nema.org/medical/dicom/current/output/html/part18.html
/// #para_3f950ae4-871c-48c5-b200-6bccf821653b)
class TMtag extends TM with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory TMtag(Tag tag, [Iterable<String> vList]) {
    final v = new StringList.from(vList);
    return TM.isValidArgs(tag, v)
        ? new TMtag._(tag, v)
        : badValues(v, null, tag);
  }

  TMtag._(this.tag, this._values) : assert(tag.vrIndex == kTMIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = setValues(vList);

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  @override
  StringList replace([Iterable<String> vList]) {
    final old = values;
    values = vList;
    return old;
  }

  StringList get trimmed => values.trim(trim);

  @override
  TMtag update([Iterable<String> vList]) => new TMtag(tag, vList);

  static TMtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      new TMtag(tag, vList);

  static TMtag fromBytes(Tag tag, Bytes bytes) =>
      new TMtag(tag, bytes.getAsciiList());
}
