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

abstract class TagIntegerMixin {
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
  factory SStag(Tag tag, [Iterable<int> vList]) => SStag._(tag, vList);

  factory SStag.bulkdata(Tag tag, Uri url) =>
      SStag._(tag, IntBulkdataRef(tag.code, url));

  factory SStag._(Tag tag, Iterable<int> vList) {
    final v = Int16.fromList(vList);
    return SS.isValidArgs(tag, v) ? SStag._x(tag, v) : badValues(v, null, tag);
  }

  SStag._x(this.tag, this._values)
      : assert(tag.vrIndex == kSSIndex),
        assert(_values is Int16List);

  @override
  SStag update([Iterable<int> vList]) => SStag._(tag, vList);

  @override
  List<int> replace([Iterable<int> vList]) => _replace(Int16.fromList(vList));

  // ignore: prefer_constructors_over_static_methods
  static SStag fromValues(Tag tag, [Iterable<int> vList, TransferSyntax _]) =>
      SStag._(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static SStag fromBytes(Tag tag, Bytes bytes, [Charset _]) =>
      SStag._(tag, bytes.asInt16List());
}

/// Short VRLength Signed Long
class SLtag extends SL with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  // Note: _values should always be a Int32List.
  @override
  List<int> _values;

  /// Creates an [SLtag] Element.
  factory SLtag(Tag tag, [Iterable<int> vList]) => SLtag._(tag, vList);

  factory SLtag.bulkdata(Tag tag, Uri url) =>
      SLtag._(tag, IntBulkdataRef(tag.code, url));

  factory SLtag._(Tag tag, Iterable<int> vList) {
    final v = Int32.fromList(vList);
    return SL.isValidArgs(tag, vList)
        ? SLtag._x(tag, v)
        : badValues(vList, null, tag);
  }
  SLtag._x(this.tag, this._values)
      : assert(tag.vrIndex == kSLIndex),
        assert(_values is Int32List);

  @override
  SLtag update([Iterable<int> vList]) => SLtag._(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static SLtag fromValues(Tag tag, [Iterable<int> vList, TransferSyntax _]) =>
      SLtag._(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static SLtag fromBytes(Tag tag, Bytes bytes, [Charset _]) =>
      SLtag._(tag, bytes.asInt32List());
}

/// 8-bit unsigned integer.
class OBtag extends OB with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  // Note: _values MUST always be a Uint8List.
  @override
  List<int> _values;

  /// Creates an [OBtag] Element.
  factory OBtag(Tag tag, Iterable<int> vList) => OBtag._(tag, vList);

  factory OBtag.bulkdata(Tag tag, Uri url) =>
      OBtag._(tag, IntBulkdataRef(tag.code, url));

  factory OBtag._(Tag tag, Iterable<int> vList) {
    assert(tag.code != kPixelData);
    final v = Uint8.fromList(vList);
    if (!OB.isValidArgs(tag, v)) return badValues(vList, null, tag);
    return OBtag._x(tag, v);
  }

  OBtag._x(this.tag, this._values)
      : assert(tag.vrIndex == kOBIndex || tag.vrIndex == kOBOWIndex),
        assert(_values is Uint8List);

  @override
  OBtag update([Iterable<int> vList = kEmptyIntList]) => OBtag._(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static OBtag fromValues(Tag tag, Iterable<int> vList) =>
      OBtag._(tag, Uint8.fromList(vList));

  // ignore: prefer_constructors_over_static_methods
  static OBtag fromBytes(Tag tag, Bytes bytes, [Charset _]) =>
      OBtag._(tag, bytes.asUint8List());
}

/// Unsigned 8-bit integer with unknown VR (VR.kUN).
class UNtag extends UN with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  // Note: _values MUSTY always be a Int8List.
  @override
  List<int> _values;

  /// Creates an [UNtag] Element.
  factory UNtag(Tag tag, Iterable<int> vList) => UNtag._(tag, vList);

  factory UNtag.bulkdata(Tag tag, Uri url) =>
      UNtag._(tag, IntBulkdataRef(tag.code, url));

  factory UNtag._(Tag tag, Iterable<int> vList) {
    assert(tag.code != kPixelData);
    final v = Uint8.fromList(vList);
    if (!UN.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    return UNtag._x(tag, v);
  }

  UNtag._x(this.tag, this._values) : assert(_values is Uint8List);

  @override
  UNtag update([Iterable<int> vList = kEmptyIntList]) => UNtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static UNtag fromValues(Tag tag, Iterable<int> vList) => UNtag._(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static UNtag fromBytes(Tag tag, Bytes bytes, [Charset _]) =>
      UNtag._(tag, bytes.asUint8List());
}

/// Unsigned Short
class UStag extends US with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  // Note: _values should always be a Int16List.
  @override
  List<int> _values;

  /// Creates an [UStag] Element.
  factory UStag(Tag tag, [Iterable<int> vList]) => UStag._(tag, vList);

  factory UStag.bulkdata(Tag tag, Uri url) =>
      UStag._(tag, IntBulkdataRef(tag.code, url));

  factory UStag._(Tag tag, Iterable<int> vList) {
    final v = Uint16.fromList(vList);
    return US.isValidArgs(tag, v) ? UStag._x(tag, v) : badValues(v, null, tag);
  }

  UStag._x(this.tag, this._values)
      : assert(tag.vrIndex == kUSIndex || tag.vrIndex == kUSSSIndex);

  @override
  UStag update([Iterable<int> vList]) => UStag._(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static UStag fromValues(Tag tag, [Iterable<int> vList, TransferSyntax _]) =>
      UStag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static UStag fromBytes(Tag tag, Bytes bytes, [Charset _]) =>
      UStag._(tag, bytes.asUint16List());
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
  factory OWtag(Tag tag, Iterable<int> vList) => OWtag._(tag, vList);

  factory OWtag._bulkdata(Tag tag, Uri url) =>
      OWtag._(tag, IntBulkdataRef(tag.code, url));

  factory OWtag._(Tag tag, Iterable<int> vList) {
    assert(tag.code != kPixelData);
    final v = Uint16.fromList(vList);
    if (!OW.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    return OWtag._x(tag, v);
  }

  OWtag._x(this.tag, this._values)
      : assert(tag.vrIndex == kOWIndex || tag.vrIndex == kOBOWIndex),
        assert(_values is Uint16List);

  @override
  OWtag update([Iterable<int> vList = kEmptyIntList]) => OWtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static OWtag fromValues(Tag tag, List<int> vList) => OWtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static OWtag fromBytes(Tag tag, Bytes bytes, [Charset _]) =>
      OWtag._(tag, bytes.asUint16List());
}

/// Other Long
class OLtag extends OL with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  // Note: _values should always be a Int16List.
  @override
  List<int> _values;

  /// Creates an [OLtag] Element.
  factory OLtag(Tag tag, [Iterable<int> vList]) => OLtag._(tag, vList);

  factory OLtag.bulkdata(Tag tag, Uri url) =>
      OLtag._(tag, IntBulkdataRef(tag.code, url));

  factory OLtag._(Tag tag, Iterable<int> vList) {
    final v = Uint32.fromList(vList);
    return OL.isValidArgs(tag, v) ? OLtag._x(tag, v) : badValues(v, null, tag);
  }

  OLtag._x(this.tag, this._values)
      : assert(tag.vrIndex == kOLIndex),
        assert(_values is Uint32List);

  @override
  OLtag update([Iterable<int> vList]) => OLtag._(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static OLtag fromValues(Tag tag, [Iterable<int> vList, TransferSyntax _]) =>
      OLtag._(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static OLtag fromBytes(Tag tag, Bytes bytes, [Charset _]) =>
      OLtag._(tag, bytes.asUint32List());
}

/// Unsigned Short
class ULtag extends UL with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  // Note: _values should always be a Int16List.
  @override
  List<int> _values;

  /// Creates an [ULtag] Element.
  factory ULtag(Tag tag, [Iterable<int> vList]) => ULtag._(tag, vList);

  factory ULtag.bulkdata(Tag tag, Uri url) =>
      ULtag._(tag, IntBulkdataRef(tag.code, url));

  factory ULtag._(Tag tag, Iterable<int> vList) {
    final v = Uint32.fromList(vList);
    return UL.isValidArgs(tag, v) ? ULtag._x(tag, v) : badValues(v, null, tag);
  }

  ULtag._x(this.tag, this._values)
      : assert(tag.vrIndex == kULIndex),
        assert(_values is Uint32List);

  @override
  ULtag update([Iterable<int> vList]) => ULtag._(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static ULtag fromValues(Tag tag, [Iterable<int> vList, TransferSyntax _]) =>
      ULtag._(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static ULtag fromBytes(Tag tag, Bytes bytes, [Charset _]) =>
      ULtag._(tag, bytes.asUint32List());
}

/// Unsigned Short
class GLtag extends ULtag {
  /// Creates an [GLtag] Element.
  factory GLtag(Tag tag, [Iterable<int> vList]) => GLtag._(tag, vList);

  factory GLtag.bulkdata(Tag tag, Uri url) =>
      GLtag._(tag, IntBulkdataRef(tag.code, url));

  factory GLtag._(Tag tag, Iterable<int> vList) {
    final v = Uint32.fromList(vList);
    return GL.isValidArgs(tag, vList)
        ? GLtag._x(tag, v)
        : badValues(vList, null, tag);
  }

  GLtag._x(Tag tag, Iterable<int> values) : super._x(tag, values);

  @override
  GLtag update([Iterable<int> vList]) => GLtag._(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static GLtag fromValues(Tag tag, [Iterable<int> vList, TransferSyntax _]) =>
      GLtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static GLtag fromBytes(Tag tag, Bytes bytes, [Charset _]) =>
      GLtag._x(tag, bytes.asUint32List());
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
  factory ATtag(Tag tag, [Iterable<int> vList]) => ATtag._(tag, vList);

  factory ATtag.bulkdata(Tag tag, Uri url) =>
      ATtag._(tag, IntBulkdataRef(tag.code, url));

  factory ATtag._(Tag tag, Iterable<int> vList) {
    final v = Uint32.fromList(vList);
    return AT.isValidArgs(tag, vList)
        ? ATtag._x(tag, v)
        : badValues(vList, null, tag);
  }

  ATtag._x(this.tag, this._values)
      : assert(tag.vrIndex == kATIndex),
        assert(_values is Uint32List);

  @override
  ATtag update([Iterable<int> vList]) => ATtag._(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static ATtag fromValues(Tag tag, [Iterable<int> vList, TransferSyntax _]) =>
      ATtag._(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static ATtag fromBytes(Tag tag, Bytes bytes, [Charset _]) =>
      ATtag._(tag, bytes.asUint32List());
}
