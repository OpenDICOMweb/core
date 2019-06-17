//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:bytes_dicom/bytes_dicom.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/element/tag/tag_element.dart';
import 'package:core/src/error.dart';
import 'package:core/src/global.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils.dart';
import 'package:core/src/values/uid/well_known/transfer_syntax.dart';

// ignore_for_file: public_member_api_docs

bool _isEmpty(Iterable<int> vList) => vList == null || vList.isEmpty;

List<int> _toValues(Iterable<int> vList) {
  if (throwOnError && vList == null) return badValues(vList);
  return _isEmpty(vList) ? kEmptyIntList : vList;
}

mixin TagIntegerMixin {
  /// Values will always have [Type] [List<int>] and [TypedData].
  List<int> get _values;

  /// [v] is always [List<int>] and [TypedData].
  set _values(List<int> v) {
    assert(v is TypedData);
    _values = v;
  }

  /// Values will always have [Type] [List<int>] and [TypedData].
  List<int> get values => _values;

  set values(Iterable<int> vList) {
    assert(values is TypedData);
    _values = vList;
  }

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  List<int> _replace([Iterable<int> vList]) {
    final old = _values;
    _values = _toValues(vList);
    return old;
  }
}

/// Short VRLength Signed Short
class SStag extends SS with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  @override
  List<int> _values;

  /// Creates an [SStag] Element.
  factory SStag(Tag tag, [Iterable<int> vList]) {
    final v = Int16.fromList(vList);
    return SS.isValidArgs(tag, v) ? SStag._(tag, v) : badValues(v, null, tag);
  }

  factory SStag.fromBulkdata(Tag tag, Uri url) =>
      SStag(tag, IntBulkdataRef(tag.code, url));

  SStag._(this.tag, this._values)
      : assert(tag.vrIndex == kSSIndex),
        assert(_values is Int16List);

  @override
  SStag update([Iterable<int> vList]) => SStag(tag, vList);

  @override
  List<int> replace([Iterable<int> vList]) => _replace(Int16.fromList(vList));

  // ignore: prefer_constructors_over_static_methods
  static SStag fromValues(Tag tag, [Iterable<int> vList, TransferSyntax _]) =>
      SStag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static SStag fromBytes(Tag tag, Bytes bytes, [Ascii _]) =>
      SStag(tag, bytes.asInt16List());
}

/// Short VRLength Signed Long
class SLtag extends SL with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  // Note: _values should always be a Int32List.
  @override
  List<int> _values;

  /// Creates an [SLtag] Element.
  factory SLtag(Tag tag, [Iterable<int> vList]) {
    final v = Int32.fromList(vList);
    return SL.isValidArgs(tag, v) ? SLtag._(tag, v) : badValues(v, null, tag);
  }

  factory SLtag.fromBulkdata(Tag tag, Uri url) =>
      SLtag(tag, IntBulkdataRef(tag.code, url));

  SLtag._(this.tag, this._values)
      : assert(tag.vrIndex == kSLIndex),
        assert(_values is Int32List);

  @override
  SLtag update([Iterable<int> vList]) => SLtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static SLtag fromValues(Tag tag, [Iterable<int> vList, TransferSyntax _]) =>
      SLtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static SLtag fromBytes(Tag tag, Bytes bytes, [Ascii _]) =>
      SLtag(tag, bytes.asInt32List());
}

/// 8-bit unsigned integer.
class OBtag extends OB with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  // Note: _values MUST always be a Uint8List.
  @override
  List<int> _values;

  /// Creates an [OBtag] Element.
  factory OBtag(Tag tag, [Iterable<int> vList]) {
    assert(tag.code != kPixelData);
    final v = Uint8.fromList(vList);
    if (!OB.isValidArgs(tag, v)) return badValues(v, null, tag);
    return OBtag._(tag, v);
  }

  factory OBtag.fromBulkdata(Tag tag, Uri url) =>
      OBtag(tag, IntBulkdataRef(tag.code, url));

  OBtag._(this.tag, this._values)
      : assert(tag.vrIndex == kOBIndex || tag.vrIndex == kOBOWIndex),
        assert(_values is Uint8List);

  @override
  OBtag update([Iterable<int> vList = kEmptyIntList]) => OBtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static OBtag fromValues(Tag tag, Iterable<int> vList) =>
      OBtag(tag, Uint8.fromList(vList));

  // ignore: prefer_constructors_over_static_methods
  static OBtag fromBytes(Tag tag, Bytes bytes, [Ascii _]) =>
      OBtag(tag, bytes.asUint8List());
}

/// Unsigned 8-bit integer with unknown VR (VR.kUN).
class UNtag extends UN with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  // Note: _values MUSTY always be a Int8List.
  @override
  List<int> _values;

  /// Creates an [UNtag] Element.
  factory UNtag(Tag tag, [Iterable<int> vList]) {
    assert(tag.code != kPixelData);
    final v = Uint8.fromList(vList);
    if (!UN.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    return UNtag._(tag, v);
  }

  factory UNtag.fromBulkdata(Tag tag, Uri url) =>
      UNtag(tag, IntBulkdataRef(tag.code, url));

  UNtag._(this.tag, this._values) : assert(_values is Uint8List);

  @override
  UNtag update([Iterable<int> vList = kEmptyIntList]) => UNtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static UNtag fromValues(Tag tag, Iterable<int> vList) => UNtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static UNtag fromBytes(Tag tag, Bytes bytes, [Ascii _]) =>
      UNtag(tag, bytes.asUint8List());
}

/// Unsigned Short
class UStag extends US with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  // Note: _values should always be a Int16List.
  @override
  List<int> _values;

  /// Creates an [UStag] Element.
  factory UStag(Tag tag, [Iterable<int> vList]) {
    final v = Uint16.fromList(vList);
    return US.isValidArgs(tag, v) ? UStag._(tag, v) : badValues(v, null, tag);
  }

  factory UStag.fromBulkdata(Tag tag, Uri url) =>
      UStag(tag, IntBulkdataRef(tag.code, url));

  UStag._(this.tag, this._values)
      : assert(tag.vrIndex == kUSIndex || tag.vrIndex == kUSSSIndex);

  @override
  UStag update([Iterable<int> vList]) => UStag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static UStag fromValues(Tag tag, [Iterable<int> vList, TransferSyntax _]) =>
      UStag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static UStag fromBytes(Tag tag, Bytes bytes, [Ascii _]) =>
      UStag(tag, bytes.asUint16List());
}

/// Other Word VR
/// Note: There is no OWPixelData since OW is always uncompressed.
class OWtag extends OW with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  // Note: _values should always be a Int16List.
  @override
  List<int> _values;

  /// Creates an [OWtag] Element.
  factory OWtag(Tag tag, [Iterable<int> vList]) {
    assert(tag.code != kPixelData);
    final v = Uint16.fromList(vList);
    if (!OW.isValidArgs(tag, v)) return badValues(v, null, tag);
    return OWtag._(tag, v);
  }

  factory OWtag.fromBulkdata(Tag tag, Uri url) =>
      OWtag(tag, IntBulkdataRef(tag.code, url));

  OWtag._(this.tag, this._values)
      : assert(tag.vrIndex == kOWIndex || tag.vrIndex == kOBOWIndex),
        assert(_values is Uint16List);

  @override
  OWtag update([Iterable<int> vList = kEmptyIntList]) => OWtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static OWtag fromValues(Tag tag, List<int> vList) => OWtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static OWtag fromBytes(Tag tag, Bytes bytes, [Ascii _]) =>
      OWtag(tag, bytes.asUint16List());
}

/// Other Long
class OLtag extends OL with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  // Note: _values should always be a Int16List.
  @override
  List<int> _values;

  /// Creates an [OLtag] Element.
  factory OLtag(Tag tag, [Iterable<int> vList]) {
    final v = Uint32.fromList(vList);
    return OL.isValidArgs(tag, v) ? OLtag._(tag, v) : badValues(v, null, tag);
  }

  factory OLtag.fromBulkdata(Tag tag, Uri url) =>
      OLtag(tag, IntBulkdataRef(tag.code, url));

  OLtag._(this.tag, this._values)
      : assert(tag.vrIndex == kOLIndex),
        assert(_values is Uint32List);

  @override
  OLtag update([Iterable<int> vList]) => OLtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static OLtag fromValues(Tag tag, [Iterable<int> vList, TransferSyntax _]) =>
      OLtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static OLtag fromBytes(Tag tag, Bytes bytes, [Ascii _]) =>
      OLtag(tag, bytes.asUint32List());
}

/// Unsigned Short
class ULtag extends UL with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  // Note: _values should always be a Int16List.
  @override
  List<int> _values;

  /// Creates an [ULtag] Element.
  factory ULtag(Tag tag, [Iterable<int> vList]) {
    final v = Uint32.fromList(vList);
    return UL.isValidArgs(tag, v) ? ULtag._(tag, v) : badValues(v, null, tag);
  }

  factory ULtag.fromBulkdata(Tag tag, Uri url) =>
      ULtag(tag, IntBulkdataRef(tag.code, url));

  ULtag._(this.tag, this._values)
      : assert(tag.vrIndex == kULIndex),
        assert(_values is Uint32List);

  @override
  ULtag update([Iterable<int> vList]) => ULtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static ULtag fromValues(Tag tag, [Iterable<int> vList, TransferSyntax _]) =>
      ULtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static ULtag fromBytes(Tag tag, Bytes bytes, [Ascii _]) =>
      ULtag(tag, bytes.asUint32List());
}

/// Unsigned Short
class GLtag extends ULtag {
  /// Creates an [GLtag] Element.
  factory GLtag(Tag tag, [Iterable<int> vList]) {
    final v = Uint32.fromList(vList);
    return GL.isValidArgs(tag, vList)
        ? GLtag._(tag, v)
        : badValues(vList, null, tag);
  }

  factory GLtag.fromBulkdata(Tag tag, Uri url) =>
      GLtag(tag, IntBulkdataRef(tag.code, url));

  GLtag._(Tag tag, Iterable<int> values) : super._(tag, values);

  @override
  GLtag update([Iterable<int> vList]) => GLtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static GLtag fromValues(Tag tag, [Iterable<int> vList, TransferSyntax _]) =>
      GLtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static GLtag fromBytes(Tag tag, Bytes bytes, [Ascii _]) =>
      GLtag(tag, bytes.asUint32List());
}

/// Immutable Attribute Tags
///
/// Note: Tags are implemented as a 32-bit integers, not 2 16-bit integers.
/// Other Long
class ATtag extends AT with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  // Note: _values should always be a Int16List.
  @override
  List<int> _values;

  /// Creates an [ATtag] Element.
  factory ATtag(Tag tag, [Iterable<int> vList]) {
    final v = Uint32.fromList(vList);
    return AT.isValidArgs(tag, v) ? ATtag._(tag, v) : badValues(v, null, tag);
  }

  factory ATtag.fromBulkdata(Tag tag, Uri url) =>
      ATtag(tag, IntBulkdataRef(tag.code, url));

  ATtag._(this.tag, this._values)
      : assert(tag.vrIndex == kATIndex),
        assert(_values is Uint32List);

  @override
  ATtag update([Iterable<int> vList]) => ATtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static ATtag fromValues(Tag tag, [Iterable<int> vList, TransferSyntax _]) =>
      ATtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static ATtag fromBytes(Tag tag, Bytes bytes, [Ascii _]) =>
      ATtag(tag, bytes.asUint32List());
}
