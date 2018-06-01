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
import 'package:core/src/value/uid.dart';
import 'package:core/src/vr.dart';

/*
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
*/

abstract class TagStringMixin {
  StringList get _values;
  set _values(StringList v);

  Iterable<String> get values => _values;

  set values(Iterable<String> vList) => _values =
      (vList == null || vList.isEmpty) ? kEmptyStringList : _toValues(vList);

  Trim get trim;
  StringList get trimmed => _values.trim(trim);

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  StringList replace([Iterable<String> vList]) {
    final old = _values;
    _values = _toValues(vList);
    return old;
  }
}

StringList _toValues(Iterable<String> vList) {
  if (throwOnError && vList == null) return badValues(vList);
  if (vList == null || vList.isEmpty) return StringList.kEmptyList;
  return (vList is StringList) ? vList : new StringList.from(vList);
}

class AEtag extends AE with TagElement<String>, TagStringMixin {
  @override
  final Tag tag;
  @override
  StringList _values;

  /// Creates an [AEtag] Element.
  factory AEtag(Tag tag, [Iterable<String> vList]) {
    final v = _toValues(vList);
    return AE.isValidArgs(tag, v)
        ? new AEtag._(tag, v)
        : badValues(v, null, tag);
  }

  AEtag._(this.tag, this._values) : assert(tag.vrIndex == kAEIndex);

  @override
  AEtag update([Iterable<String> vList]) => new AEtag(tag, vList);

  static AEtag fromValues(Tag tag, [Iterable<String> vList, TransferSyntax _]) =>
      new AEtag(tag, vList);

  static AEtag fromBytes(Tag tag, Bytes bytes) =>
      new AEtag(tag, bytes.getAsciiList());
}

class CStag extends CS with TagElement<String>, TagStringMixin {
  @override
  final Tag tag;
  @override
  StringList _values;

  factory CStag(Tag tag, [Iterable<String> vList]) {
    final v = _toValues(vList);
    return CS.isValidArgs(tag, v)
        ? new CStag._(tag, v)
        : badValues(v, null, tag);
  }

  CStag._(this.tag, this._values) : assert(tag.vrIndex == kCSIndex);

  /// Special variable for overriding uppercase constraint. If _true_
  /// lowercase characters in [values] are converted to uppercase
  /// before being returned.
  static bool convertLowercase = false;

  @override
  Iterable<String> get values {
    final v = _values;
    return (convertLowercase) ? v.uppercase : v;
  }

  @override
  CStag update([Iterable<String> vList]) => new CStag(tag, vList);

  static CStag fromValues(Tag tag, [Iterable<String> vList, TransferSyntax _]) =>
      new CStag(tag, vList);

  static CStag fromBytes(Bytes bytes, Tag tag) =>
      new CStag(tag, bytes.getAsciiList());
}

class DStag extends DS with TagElement<String>, TagStringMixin {
  @override
  final Tag tag;
  @override
  StringList _values;

  factory DStag(Tag tag, [Iterable<String> vList = kEmptyStringList]) {
    final v = _toValues(vList);
    return DS.isValidArgs(tag, v)
        ? new DStag._(tag, v)
        : badValues(v, null, tag);
  }

  DStag._(this.tag, this._values) : assert(tag.vrIndex == kDSIndex);

  @override
  DStag update([Iterable<String> vList]) => new DStag(tag, vList);

  static DStag fromValues(Tag tag, [Iterable<String> vList, TransferSyntax _]) =>
      new DStag(tag, vList);

  static DStag fromBytes(Bytes bytes, Tag tag) =>
      new DStag(tag, bytes.getAsciiList());
}

class IStag extends IS with TagElement<String>, TagStringMixin {
  @override
  final Tag tag;
  @override
  StringList _values;

  factory IStag(Tag tag, [Iterable<String> vList = kEmptyStringList]) {
    final v = _toValues(vList);
    return IS.isValidArgs(tag, v)
        ? new IStag._(tag, v)
        : badValues(v, null, tag);
  }

  IStag._(this.tag, this._values) : assert(tag.vrIndex == kISIndex);

  @override
  IStag update([Iterable<String> vList]) => new IStag(tag, vList);

  static IStag fromValues(Tag tag, [Iterable<String> vList, TransferSyntax _]) =>
      new IStag(tag, vList);

  static IStag fromBytes(Bytes bytes, Tag tag) =>
      new IStag(tag, bytes.getAsciiList());
}

/// A Long String (LO) Element
class LOtag extends LO with TagElement<String>, TagStringMixin {
  @override
  final Tag tag;
  @override
  StringList _values;

  factory LOtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) {
    final v = _toValues(vList);
    return LO.isValidArgs(tag, v)
        ? new LOtag._(tag, v)
        : badValues(v, null, tag);
  }

  LOtag._(this.tag, this._values) : assert(tag.vrIndex == kLOIndex);

  @override
  LOtag update([Iterable<String> vList]) => new LOtag(tag, vList);

  static LOtag fromValues(Tag tag, [Iterable<String> vList, TransferSyntax _]) =>
      new LOtag(tag, vList);

  static LOtag fromBytes(Bytes bytes, Tag tag) =>
      new LOtag(tag, bytes.getUtf8List());
}

class PCtag extends PC with TagElement<String>, TagStringMixin {
  @override
  final Tag tag;
  @override
  StringList _values;

  factory PCtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) {
    final v = _toValues(vList);
    return PC.isValidArgs(tag, v)
        ? new PCtag._(tag, v)
        : badValues(v, null, tag);
  }

  PCtag._(this.tag, this._values) : assert(tag.vrIndex == kLOIndex);

  @override
  String get token => value;

  @override
  PCtag update([Iterable<String> vList]) => new PCtag(tag, vList);

  @override
  String toString() => '$runtimeType $tag $value';

  static PCtag fromValues(Tag tag, [Iterable<String> vList, TransferSyntax _]) =>
      new PCtag(tag, vList);

  static PCtag fromBytes(Bytes bytes, Tag tag) =>
      new PCtag(tag, bytes.getUtf8List());

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
class LTtag extends LT with TagElement<String>, TagStringMixin {
  @override
  final Tag tag;
  @override
  StringList _values;

  factory LTtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) {
    final v = _toValues(vList);
    return LT.isValidArgs(tag, v)
        ? new LTtag._(tag, v)
        : badValues(v, null, tag);
  }

  LTtag._(this.tag, this._values) : assert(tag.vrIndex == kLTIndex);

  @override
  LTtag update([Iterable<String> vList]) => new LTtag(tag, vList);

  static LTtag fromValues(Tag tag, [Iterable<String> vList, TransferSyntax _]) =>
      new LTtag(tag, vList);

  static LTtag fromBytes(Bytes bytes, Tag tag) =>
      new LTtag(tag, _toValues([bytes.getUtf8()]));
}

/// A Person Name ([PN]) Element.
class PNtag extends PN with TagElement<String>, TagStringMixin {
  @override
  final Tag tag;
  @override
  StringList _values;

  factory PNtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) {
    final v = _toValues(vList);
    return PN.isValidArgs(tag, v)
        ? new PNtag._(tag, v)
        : badValues(v, null, tag);
  }

  PNtag._(this.tag, this._values) : assert(tag.vrIndex == kPNIndex);

  @override
  PNtag update([Iterable<String> vList]) => new PNtag(tag, vList);

  static PNtag fromValues(Tag tag, [Iterable<String> vList]) =>
      new PNtag(tag, vList);

  static PNtag fromBytes(Bytes bytes, Tag tag) =>
      new PNtag(tag, bytes.getUtf8List());
}

/// A Short String (SH) Element
class SHtag extends SH with TagElement<String>, TagStringMixin {
  @override
  final Tag tag;
  @override
  StringList _values;

  factory SHtag(Tag tag, [Iterable<String> vList]) {
    final v = _toValues(vList);
    return SH.isValidArgs(tag, v)
        ? new SHtag._(tag, v)
        : badValues(v, null, tag);
  }

  SHtag._(this.tag, this._values) : assert(tag.vrIndex == kSHIndex);

  @override
  SHtag update([Iterable<String> vList]) => new SHtag(tag, vList);

  static SHtag fromValues(Tag tag, [Iterable<String> vList, TransferSyntax _]) =>
      new SHtag(tag, vList);

  static SHtag fromBytes(Bytes bytes, Tag tag) =>
      new SHtag(tag, bytes.getUtf8List());
}

/// An Short Text (ST) Element
class STtag extends ST with TagElement<String>, TagStringMixin {
  @override
  final Tag tag;
  @override
  StringList _values;

  factory STtag(Tag tag, [Iterable<String> vList]) {
    final v = _toValues(vList);
    return ST.isValidArgs(tag, v)
        ? new STtag._(tag, v)
        : badValues(v, null, tag);
  }

  STtag._(this.tag, this._values) : assert(tag.vrIndex == kSTIndex);

  @override
  STtag update([Iterable<String> vList]) => new STtag(tag, vList);

  static STtag fromValues(Tag tag, [Iterable<String> vList, TransferSyntax _]) =>
      new STtag(tag, vList);

  static STtag fromBytes(Bytes bytes, Tag tag) =>
      new STtag(tag, _toValues([bytes.getUtf8()]));
}

/// An Unlimited Characters (UC) Element
class UCtag extends UC with TagElement<String>, TagStringMixin {
  @override
  final Tag tag;
  @override
  StringList _values;

  factory UCtag(Tag tag, [Iterable<String> vList]) {
    final v = _toValues(vList);
    return UC.isValidArgs(tag, v)
        ? new UCtag._(tag, v)
        : badValues(v, null, tag);
  }

  UCtag._(this.tag, this._values) : assert(tag.vrIndex == kUCIndex);

  @override
  UCtag update([Iterable<String> vList]) => new UCtag(tag, vList);

  static UCtag fromValues(Tag tag, [Iterable<String> vList, TransferSyntax _]) =>
      new UCtag(tag, vList);

  static UCtag fromBytes(Bytes bytes, Tag tag) =>
      new UCtag(tag, bytes.getUtf8List());
}

class UItag extends UI with TagElement<String>, TagStringMixin {
  @override
  final Tag tag;
  @override
  StringList _values;

  factory UItag(Tag tag, [Iterable<String> vList]) {
    final v = _toValues(vList);
    return UI.isValidArgs(tag, v)
        ? new UItag._(tag, v, null)
        : badValues(v, null, tag);
  }

  factory UItag.fromUids(Tag tag, Iterable<Uid> uidList) {
    if (!UI.isValidUidArgs(tag, uidList)) return badValues(uidList, null, tag);
    final v = _toValues(uidList.map((uid) => uid.asString));
    List<Uid> uids;
    if (uidList != null) uids = uidList.toList(growable: false);
    return new UItag._(tag, v, uids);
  }

  UItag._(this.tag, this._values, [List<Uid> uids])
      : assert(tag.vrIndex == kUIIndex);

  @override
  List<Uid> get uids => _uids ??= Uid.parseList(values);
  Iterable<Uid> _uids;

  @override
  UItag update([Iterable<String> vList]) => new UItag(tag, vList);

  static UItag fromValues(Tag tag, [Iterable<String> vList, TransferSyntax _]) =>
      new UItag(tag, vList);

  static UItag fromBytes(Bytes bytes, Tag tag) =>
      new UItag(tag, bytes.getAsciiList(padChar: kNull));
}

/// Value Representation of [Uri].
///
/// The Value Multiplicity of this Element is 1.
class URtag extends UR with TagElement<String>, TagStringMixin {
  @override
  final Tag tag;
  @override
  StringList _values;

  factory URtag(Tag tag, [Iterable<String> vList]) {
    final v = _toValues(vList);
    return UR.isValidArgs(tag, v)
        ? new URtag._(tag, v)
        : badValues(v, null, tag);
  }

  URtag._(this.tag, this._values) : assert(tag.vrIndex == kURIndex);

  @override
  URtag update([Iterable<String> vList]) => new URtag(tag, vList);

  static URtag fromValues(Tag tag, [Iterable<String> vList, TransferSyntax _]) =>
      new URtag(tag, vList);

  static URtag fromBytes(Bytes bytes, Tag tag) =>
      new URtag(tag, _toValues([bytes.getUtf8()]));
}

/// An Unlimited Text (UT) Element
class UTtag extends UT with TagElement<String>, TagStringMixin {
  @override
  final Tag tag;
  @override
  StringList _values;

  factory UTtag(Tag tag, [Iterable<String> vList]) {
    final v = _toValues(vList);
    return UT.isValidArgs(tag, v)
        ? new UTtag._(tag, v)
        : badValues(v, null, tag);
  }

  UTtag._(this.tag, this._values) : assert(tag.vrIndex == kUTIndex);

  @override
  UTtag update([Iterable<String> vList]) => new UTtag(tag, vList);

  static UTtag fromValues(Tag tag, [Iterable<String> vList, TransferSyntax _]) =>
      new UTtag(tag, vList);

  static UTtag fromBytes(Bytes bytes, Tag tag) =>
      new UTtag(tag, _toValues([bytes.getUtf8()]));
}

// **** Date/Time classes
/// A Application Entity Title (AS) Element
class AStag extends AS with TagElement<String>, TagStringMixin {
  @override
  final Tag tag;
  @override
  StringList _values;

  factory AStag(Tag tag, [Iterable<String> vList]) {
    final v = _toValues(vList);
    return AS.isValidArgs(tag, v)
        ? new AStag._(tag, v)
        : badValues(v, null, tag);
  }

  AStag._(this.tag, this._values) : assert(tag.vrIndex == kASIndex);

  @override
  AStag update([Iterable<String> vList]) => new AStag(tag, vList);

  static AStag fromValues(Tag tag, [Iterable<String> vList, TransferSyntax _]) =>
      new AStag(tag, vList);

  static AStag fromBytes(Bytes bytes, Tag tag) =>
      new AStag(tag, bytes.getAsciiList());
}

/// A DICOM Date ([DA]) [Element].
class DAtag extends DA with TagElement<String>, TagStringMixin {
  @override
  final Tag tag;
  @override
  StringList _values;

  factory DAtag(Tag tag, [Iterable<String> vList]) {
    final v = _toValues(vList);
    return DA.isValidArgs(tag, v)
        ? new DAtag._(tag, _toValues(v))
        : badValues(v, null, tag);
  }

  DAtag._(this.tag, this._values) : assert(tag.vrIndex == kDAIndex);

  @override
  DAtag update([Iterable<String> vList]) => new DAtag(tag, vList);

  static DAtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      new DAtag(tag, vList);

  static DAtag fromBytes(Bytes bytes, Tag tag) =>
      new DAtag(tag, bytes.getAsciiList());
}

/// A DICOM DateTime [DT] [Element].
///
/// A concatenated date-time character string in the
/// format: YYYYMMDDHHMMSS.FFFFFF&ZZXX
class DTtag extends DT with TagElement<String>, TagStringMixin {
  @override
  final Tag tag;
  @override
  StringList _values;

  factory DTtag(Tag tag, [Iterable<String> vList]) {
    final v = _toValues(vList);
    return DT.isValidArgs(tag, v)
        ? new DTtag._(tag, v)
        : badValues(v, null, tag);
  }

  DTtag._(this.tag, this._values) : assert(tag.vrIndex == kDTIndex);

  @override
  DTtag update([Iterable<String> vList]) => new DTtag(tag, vList);

  static DTtag fromValues(Tag tag, [Iterable<String> vList, TransferSyntax _]) =>
      new DTtag(tag, vList);

  static DTtag fromBytes(Bytes bytes, Tag tag) =>
      new DTtag(tag, bytes.getAsciiList());
}

/// The DICOM [TM] (Time) [Element].
///
/// [Time] [String]s have the following format: HHMMSS.ffffff. [See PS3.18, TM]
/// (http://dicom.nema.org/medical/dicom/current/output/html/part18.html
/// #para_3f950ae4-871c-48c5-b200-6bccf821653b)
class TMtag extends TM with TagElement<String>, TagStringMixin {
  @override
  final Tag tag;
  @override
  StringList _values;

  factory TMtag(Tag tag, [Iterable<String> vList]) {
    final v = _toValues(vList);
    return TM.isValidArgs(tag, v)
        ? new TMtag._(tag, v)
        : badValues(v, null, tag);
  }

  TMtag._(this.tag, this._values) : assert(tag.vrIndex == kTMIndex);

  @override
  TMtag update([Iterable<String> vList]) => new TMtag(tag, vList);

  static TMtag fromValues(Tag tag,
          [Iterable<String> vList, TransferSyntax _]) =>
      new TMtag(tag, vList);

  static TMtag fromBytes(Bytes bytes, Tag tag) =>
      new TMtag(tag, bytes.getAsciiList());
}
