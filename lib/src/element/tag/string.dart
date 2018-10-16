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
import 'package:core/src/global.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/values.dart';
import 'package:core/src/vr.dart';

// ignore_for_file: public_member_api_docs

bool _isEmpty(Iterable<String> vList) => vList == null || vList.isEmpty;

StringList _toValues(Iterable<String> vList) {
  if (throwOnError && vList == null) return badValues(vList);
  return _isEmpty(vList) ? StringList.kEmptyList : StringList.from(vList);
}

abstract class TagStringMixin {
  /// Values will always have [Type] [StringList].
  StringList get _values;

  StringBase update([Iterable<String> vList]);

  // **** End of Interface

  set _values(StringList v) => _values = v;

  /// Values will always have [Type] [StringList].
  StringList get values => _values;

  set values(Iterable<String> vList) => _values = _toValues(vList);

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  StringList replace([Iterable<String> vList]) {
    final old = _values;
    _values = _toValues(vList);
    return old;
  }

  bool match(String regexp) => _values.match(regexp);
}

class AEtag extends AE with TagElement<String>, TagStringMixin {
  @override
  final Tag tag;
  @override
  StringList _values;

  /// Creates an [AEtag] Element.
  factory AEtag(Tag tag, [Iterable<String> vList]) {
    final v = _toValues(vList);
    return AE.isValidArgs(tag, v) ? AEtag._(tag, v) : badValues(v, null, tag);
  }

  AEtag._(this.tag, this._values) : assert(tag.vrIndex == kAEIndex);

/*
  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  @override
  StringList replace([Iterable<String> vList]) {
    final old = values;
    values = vList;
    return old;
  }
*/

  StringList get trimmed => _values.trim(trim);

  @override
  AEtag update([Iterable<String> vList]) => AEtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static AEtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      AEtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static AEtag fromBytes(Tag tag, Bytes bytes) =>
      AEtag(tag, bytes.getAsciiList(padChar: kSpace));
}

class CStag extends CS with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory CStag(Tag tag, [Iterable<String> vList]) {
    final v = StringList.from(vList);
    return CS.isValidArgs(tag, v) ? CStag._(tag, v) : badValues(v, null, tag);
  }

  CStag._(this.tag, this._values) : assert(tag.vrIndex == kCSIndex);

  @override
  StringList get values {
    final v = _values;
    return convertLowercase ? v.uppercase : v;
  }

  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
  CStag update([Iterable<String> vList]) => CStag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static CStag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      CStag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static CStag fromBytes(Tag tag, Bytes bytes) =>
      CStag(tag, bytes.getAsciiList());
}

class DStag extends DS with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory DStag(Tag tag, [Iterable<String> vList = kEmptyStringList]) {
    final v = StringList.from(vList);
    return DS.isValidArgs(tag, v) ? DStag._(tag, v) : badValues(v, null, tag);
  }

  DStag._(this.tag, this._values) : assert(tag.vrIndex == kDSIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
  DStag update([Iterable<String> vList]) => DStag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static DStag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      DStag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static DStag fromBytes(Tag tag, Bytes bytes) =>
      DStag(tag, bytes.getAsciiList(padChar: kSpace));
}

class IStag extends IS with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory IStag(Tag tag, [Iterable<String> vList = kEmptyStringList]) {
    final v = StringList.from(vList);
    return IS.isValidArgs(tag, v) ? IStag._(tag, v) : badValues(v, null, tag);
  }

  IStag._(this.tag, this._values) : assert(tag.vrIndex == kISIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
  IStag update([Iterable<String> vList]) => IStag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static IStag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      IStag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static IStag fromBytes(Tag tag, Bytes bytes) =>
      IStag(tag, bytes.getAsciiList());
}

/// A Long String (LO) Element
class LOtag extends LO with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory LOtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) {
    final v = StringList.from(vList);
    return LO.isValidArgs(tag, v) ? LOtag._(tag, v) : badValues(v, null, tag);
  }

  LOtag._(this.tag, this._values) : assert(tag.vrIndex == kLOIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
  LOtag update([Iterable<String> vList]) => LOtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static LOtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      LOtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static LOtag fromBytes(Tag tag, Bytes bytes) =>
      LOtag(tag, bytes.getUtf8List());
}

class PCtag extends PC with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory PCtag(Tag tag, [StringList vList]) {
    vList ??= StringList.kEmptyList;
    final v = StringList.from(vList);
    return PC.isValidArgs(tag, v) ? PCtag._(tag, v) : badValues(v, null, tag);
  }

  PCtag._(this.tag, this._values) : assert(tag.vrIndex == kLOIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
  PCtag update([Iterable<String> vList]) => PCtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static PCtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      PCtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static PCtag fromBytes(Tag tag, Bytes bytes) {
    final s = bytes.getUtf8().trim();
    return PCtag(tag, StringList.from([s]));
  }

  // ignore: prefer_constructors_over_static_methods
  static PCtag makePhantom(int group, int subgroup) {
    const name = PDTag.phantomName;
    final code = (group << 16) + subgroup;
    final tag = PCTagUnknown(code, kLOIndex, name);
    return PCtag(tag, StringList.from(const <String>[name]));
  }

  // ignore: prefer_constructors_over_static_methods
  static PCtag makeEmptyPrivateCreator(int pdCode, int vrIndex) {
    final group = Tag.privateGroup(pdCode);
    final sgNumber = (pdCode & 0xFFFF) >> 8;
    final code = (group << 16) + sgNumber;
    final tag = PCTagUnknown(code, kLOIndex, '');
    return PCtag(tag, StringList.from(const <String>['']));
  }
}

/// An Long Text (LT) Element
class LTtag extends LT with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory LTtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) {
    final v = StringList.from(vList);
    return LT.isValidArgs(tag, v) ? LTtag._(tag, v) : badValues(v, null, tag);
  }

  LTtag._(this.tag, this._values) : assert(tag.vrIndex == kLTIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
  LTtag update([Iterable<String> vList]) => LTtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static LTtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      LTtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static LTtag fromBytes(Tag tag, Bytes bytes) =>
      LTtag(tag, StringList.from([bytes.getUtf8()]));
}

/// A Person Name ([PN]) Element.
class PNtag extends PN with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory PNtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) {
    final v = StringList.from(vList);
    return PN.isValidArgs(tag, v) ? PNtag._(tag, v) : badValues(v, null, tag);
  }

  PNtag._(this.tag, this._values) : assert(tag.vrIndex == kPNIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
  PNtag update([Iterable<String> vList]) => PNtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static PNtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      PNtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static PNtag fromBytes(Tag tag, Bytes bytes) =>
      PNtag(tag, bytes.getUtf8List());
}

/// A Short String (SH) Element
class SHtag extends SH with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory SHtag(Tag tag, [Iterable<String> vList]) {
    final v = StringList.from(vList);
    return SH.isValidArgs(tag, v) ? SHtag._(tag, v) : badValues(v, null, tag);
  }

  SHtag._(this.tag, this._values) : assert(tag.vrIndex == kSHIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
  SHtag update([Iterable<String> vList]) => SHtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static SHtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      SHtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static SHtag fromBytes(Tag tag, Bytes bytes) =>
      SHtag(tag, bytes.getUtf8List());
}

/// An Short Text (ST) Element
class STtag extends ST with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory STtag(Tag tag, [Iterable<String> vList]) {
    final v = StringList.from(vList);
    return ST.isValidArgs(tag, v) ? STtag._(tag, v) : badValues(v, null, tag);
  }

  STtag._(this.tag, this._values) : assert(tag.vrIndex == kSTIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
  STtag update([Iterable<String> vList]) => STtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static STtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      STtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static STtag fromBytes(Tag tag, Bytes bytes) =>
      STtag(tag, StringList.from([bytes.getUtf8()]));
}

/// An Unlimited Characters (UC) Element
class UCtag extends UC with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory UCtag(Tag tag, [Iterable<String> vList]) {
    final v = StringList.from(vList);
    return UC.isValidArgs(tag, v) ? UCtag._(tag, v) : badValues(v, null, tag);
  }

  UCtag._(this.tag, this._values) : assert(tag.vrIndex == kUCIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
  UCtag update([Iterable<String> vList]) => UCtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static UCtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      UCtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static UCtag fromBytes(Tag tag, Bytes bytes) =>
      UCtag(tag, bytes.getUtf8List());
}

class UItag extends UI with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory UItag(Tag tag, [Iterable<String> vList]) {
    final v = StringList.from(vList);
    return UI.isValidArgs(tag, v)
        ? UItag._(tag, v, null)
        : badValues(v, null, tag);
  }

  factory UItag.fromUids(Tag tag, Iterable<Uid> uidList) {
    if (!UI.isValidUidArgs(tag, uidList)) return badValues(uidList, null, tag);
    final v = StringList.from(uidList.map((uid) => uid.asString));
    List<Uid> uids;
    if (uidList != null) uids = uidList.toList(growable: false);
    return UItag._(tag, v, uids);
  }

  UItag._(this.tag, this._values, this._uids) : assert(tag.vrIndex == kUIIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
  UItag update([Iterable<String> vList]) => UItag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static UItag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      UItag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static UItag fromBytes(Tag tag, Bytes bytes) =>
      UItag(tag, bytes.getAsciiList(padChar: kNull));
}

/// Value Representation of [Uri].
///
/// The Value Multiplicity of this Element is 1.
class URtag extends UR with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory URtag(Tag tag, [Iterable<String> vList]) {
    final v = StringList.from(vList);
    return UR.isValidArgs(tag, v) ? URtag._(tag, v) : badValues(v, null, tag);
  }

  URtag._(this.tag, this._values) : assert(tag.vrIndex == kURIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
  URtag update([Iterable<String> vList]) => URtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static URtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      URtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static URtag fromBytes(Tag tag, Bytes bytes) =>
      URtag(tag, StringList.from([bytes.getUtf8()]));
}

/// An Unlimited Text (UT) Element
class UTtag extends UT with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory UTtag(Tag tag, [Iterable<String> vList]) {
    final v = StringList.from(vList);
    return UT.isValidArgs(tag, v) ? UTtag._(tag, v) : badValues(v, null, tag);
  }

  UTtag._(this.tag, this._values) : assert(tag.vrIndex == kUTIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
  UTtag update([Iterable<String> vList]) => UTtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static UTtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      UTtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static UTtag fromBytes(Tag tag, Bytes bytes) =>
      UTtag(tag, StringList.from([bytes.getUtf8()]));
}

// **** Date/Time classes
/// A Application Entity Title (AS) Element
class AStag extends AS with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory AStag(Tag tag, [Iterable<String> vList]) {
    final v = StringList.from(vList);
    return AS.isValidArgs(tag, v) ? AStag._(tag, v) : badValues(v, null, tag);
  }

  AStag._(this.tag, this._values) : assert(tag.vrIndex == kASIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
  AStag update([Iterable<String> vList]) => AStag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static AStag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      AStag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static AStag fromBytes(Tag tag, Bytes bytes) =>
      AStag(tag, bytes.getAsciiList());
}

/// A DICOM Date ([DA]) [Element].
class DAtag extends DA with TagElement<String> {
  @override
  final Tag tag;
  StringList _values;

  factory DAtag(Tag tag, [Iterable<String> vList]) {
    final v = StringList.from(vList);
    return DA.isValidArgs(tag, v)
        ? DAtag._(tag, StringList.from(v))
        : badValues(v, null, tag);
  }

  DAtag._(this.tag, this._values) : assert(tag.vrIndex == kDAIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
  DAtag update([Iterable<String> vList]) => DAtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static DAtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      DAtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static DAtag fromBytes(Tag tag, Bytes bytes) =>
      DAtag(tag, bytes.getAsciiList());
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
    final v = StringList.from(vList);
    return DT.isValidArgs(tag, v) ? DTtag._(tag, v) : badValues(v, null, tag);
  }

  DTtag._(this.tag, this._values) : assert(tag.vrIndex == kDTIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
  DTtag update([Iterable<String> vList]) => DTtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static DTtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      DTtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static DTtag fromBytes(Tag tag, Bytes bytes) =>
      DTtag(tag, bytes.getAsciiList());
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
    final v = StringList.from(vList);
    return TM.isValidArgs(tag, v) ? TMtag._(tag, v) : badValues(v, null, tag);
  }

  TMtag._(this.tag, this._values) : assert(tag.vrIndex == kTMIndex);

  @override
  StringList get values => _values;

  @override
  set values(Iterable<String> vList) => _values = _toValues(vList);

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
  TMtag update([Iterable<String> vList]) => TMtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static TMtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      TMtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static TMtag fromBytes(Tag tag, Bytes bytes) {
    final s = bytes.getAsciiList(padChar: kSpace);
    return TMtag(tag, s);
  }
}
