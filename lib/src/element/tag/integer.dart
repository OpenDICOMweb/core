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
import 'package:core/src/global.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/primitives.dart';
import 'package:core/src/value/uid/well_known/transfer_syntax.dart';

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
    assert(values is List<int> && values is TypedData);
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
  // Note: _values should always be a Int16List.
  @override
  List<int> _values;

  /// Creates an [SStag] Element.
  factory SStag(Tag tag, [Iterable<int> vList]) => new SStag._(tag, vList);

  factory SStag.bulkdata(Tag tag, Uri url) =>
      new SStag._(tag, new IntBulkdataRef(tag.code, url));

  factory SStag._(Tag tag, Iterable<int> vList) {
    final v = Int16.fromList(vList);
    return SS.isValidArgs(tag, v)
        ? new SStag._x(tag, v)
        : badValues(v, null, tag);
  }

  SStag._x(this.tag, this._values)
      : assert(tag.vrIndex == kSSIndex),
        assert(_values is Int16List);

  @override
  SStag update([Iterable<int> vList]) => new SStag._(tag, vList);

  @override
  List<int> replace([Iterable<int> vList]) => _replace(Int16.fromList(vList));

  static SStag fromValues(Tag tag, [Iterable<int> vList, TransferSyntax _]) =>
      new SStag._(tag, vList);

  static SStag fromBytes(Tag tag, Bytes bytes) =>
      new SStag._(tag, bytes.asInt16List());
}

/// Short VRLength Signed Long
class SLtag extends SL with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  // Note: _values should always be a Int32List.
  @override
  List<int> _values;

  /// Creates an [SLtag] Element.
  factory SLtag(Tag tag, [Iterable<int> vList]) => new SLtag._(tag, vList);

  factory SLtag.bulkdata(Tag tag, Uri url) =>
      new SLtag._(tag, new IntBulkdataRef(tag.code, url));

  factory SLtag._(Tag tag, Iterable<int> vList) {
    final v = Int32.fromList(vList);
    return SL.isValidArgs(tag, vList)
        ? new SLtag._x(tag, v)
        : badValues(vList, null, tag);
  }
  SLtag._x(this.tag, this._values)
      : assert(tag.vrIndex == kSLIndex),
        assert(_values is Int32List);

  @override
  SLtag update([Iterable<int> vList]) => new SLtag._(tag, vList);

  static SLtag fromValues(Tag tag, [Iterable<int> vList, TransferSyntax _]) =>
      new SLtag._(tag, vList);

  static SLtag fromBytes(Tag tag, Bytes bytes) =>
      new SLtag._(tag, bytes.asInt32List());
}

/// 8-bit unsigned integer.
class OBtag extends OB with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  // Note: _values MUST always be a Uint8List.
  @override
  List<int> _values;

  /// Creates an [OBtag] Element.
  factory OBtag(Tag tag, Iterable<int> vList) =>
      new OBtag._(tag, vList);

  factory OBtag.bulkdata(Tag tag, Uri url) =>
      new OBtag._(tag, new IntBulkdataRef(tag.code, url));

  factory OBtag._(Tag tag, Iterable<int> vList) {
    assert(tag.code != kPixelData);
    final v = Uint8.fromList(vList);
    if (!OB.isValidArgs(tag, v)) return badValues(vList, null, tag);
    return new OBtag._x(tag, v);
  }

  OBtag._x(this.tag, this._values)
      : assert(tag.vrIndex == kOBIndex || tag.vrIndex == kOBOWIndex),
        assert(_values is Uint8List);

  @override
  OBtag update([Iterable<int> vList = kEmptyIntList]) =>
      new OBtag._(tag, vList);

  static OBtag fromValues(Tag tag, Iterable<int> vList) =>
      new OBtag._(tag, Uint8.fromList(vList));

  static OBtag fromBytes(Tag tag, Bytes bytes) =>
      new OBtag._(tag, bytes.asUint8List());
}

/// Unsigned 8-bit integer with unknown VR (VR.kUN).
class UNtag extends UN with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  // Note: _values MUSTY always be a Int8List.
  @override
  List<int> _values;

  /// Creates an [UNtag] Element.
  factory UNtag(Tag tag, Iterable<int> vList) =>
      new UNtag._(tag, vList);

  factory UNtag.bulkdata(Tag tag, Uri url) =>
      new UNtag._(tag, new IntBulkdataRef(tag.code, url));

  factory UNtag._(Tag tag, Iterable<int> vList) {
    assert(tag.code != kPixelData);
    final v = Uint8.fromList(vList);
    if (!UN.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    return new UNtag._x(tag, v);
  }

  UNtag._x(this.tag, this._values) : assert(_values is Uint8List);

  @override
  UNtag update([Iterable<int> vList = kEmptyIntList]) => new UNtag(tag, vList);

  static UNtag fromValues(Tag tag, Iterable<int> vList) =>
      new UNtag._(tag, vList);

  static UNtag fromBytes(Tag tag, Bytes bytes) =>
      new UNtag._(tag, bytes.asUint8List());
}

/// Unsigned Short
class UStag extends US with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  // Note: _values should always be a Int16List.
  @override
  List<int> _values;

  /// Creates an [UStag] Element.
  factory UStag(Tag tag, [Iterable<int> vList]) => new UStag._(tag, vList);

  factory UStag.bulkdata(Tag tag, Uri url) =>
      new UStag._(tag, new IntBulkdataRef(tag.code, url));

  factory UStag._(Tag tag, Iterable<int> vList) {
    final v = Uint16.fromList(vList);
    return US.isValidArgs(tag, v)
        ? new UStag._x(tag, v)
        : badValues(v, null, tag);
  }

  UStag._x(this.tag, this._values)
      : assert(tag.vrIndex == kUSIndex || tag.vrIndex == kUSSSIndex);

  @override
  UStag update([Iterable<int> vList]) => new UStag._(tag, vList);

  static UStag fromValues(Tag tag, [Iterable<int> vList, TransferSyntax _]) =>
      new UStag(tag, vList);

  static UStag fromBytes(Tag tag, Bytes bytes) =>
      new UStag._(tag, bytes.asUint16List());
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
  factory OWtag(Tag tag, Iterable<int> vList) =>
      new OWtag._(tag, vList);

  factory OWtag._bulkdata(Tag tag, Uri url) =>
      new OWtag._(tag, new IntBulkdataRef(tag.code, url));

  factory OWtag._(Tag tag, Iterable<int> vList) {
    assert(tag.code != kPixelData);
    final v = Uint16.fromList(vList);
    if (!OW.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    return new OWtag._x(tag, v);
  }

  OWtag._x(this.tag, this._values)
      : assert(tag.vrIndex == kOWIndex || tag.vrIndex == kOBOWIndex),
        assert(_values is Uint16List);

  @override
  OWtag update([Iterable<int> vList = kEmptyIntList]) => new OWtag(tag, vList);

  static OWtag fromValues(Tag tag, Iterable<int> vList) =>
      new OWtag(tag, vList);

  static OWtag fromBytes(Tag tag, Bytes bytes) =>
      new OWtag._(tag, bytes.asUint16List());
}

/// Other Long
class OLtag extends OL with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  // Note: _values should always be a Int16List.
  @override
  List<int> _values;

  /// Creates an [OLtag] Element.
  factory OLtag(Tag tag, [Iterable<int> vList]) => new OLtag._(tag, vList);

  factory OLtag.bulkdata(Tag tag, Uri url) =>
      new OLtag._(tag, new IntBulkdataRef(tag.code, url));

  factory OLtag._(Tag tag, Iterable<int> vList) {
    final v = Uint32.fromList(vList);
    return OL.isValidArgs(tag, v)
        ? new OLtag._x(tag, v)
        : badValues(v, null, tag);
  }

  OLtag._x(this.tag, this._values)
      : assert(tag.vrIndex == kOLIndex),
        assert(_values is Uint32List);

  @override
  OLtag update([Iterable<int> vList]) => new OLtag._(tag, vList);

  static OLtag fromValues(Tag tag, [Iterable<int> vList, TransferSyntax _]) =>
      new OLtag._(tag, vList);

  static OLtag fromBytes(Tag tag, Bytes bytes) =>
      new OLtag._(tag, bytes.asUint32List());
}

/// Unsigned Short
class ULtag extends UL with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  // Note: _values should always be a Int16List.
  @override
  List<int> _values;

  /// Creates an [ULtag] Element.
  factory ULtag(Tag tag, [Iterable<int> vList]) => new ULtag._(tag, vList);

  factory ULtag.bulkdata(Tag tag, Uri url) =>
      new ULtag._(tag, new IntBulkdataRef(tag.code, url));

  factory ULtag._(Tag tag, Iterable<int> vList) {
    final v = Uint32.fromList(vList);
    return UL.isValidArgs(tag, v)
        ? new ULtag._x(tag, v)
        : badValues(v, null, tag);
  }

  ULtag._x(this.tag, this._values)
      : assert(tag.vrIndex == kULIndex),
        assert(_values is Uint32List);

  @override
  ULtag update([Iterable<int> vList]) => new ULtag._(tag, vList);

  static ULtag fromValues(Tag tag, [Iterable<int> vList, TransferSyntax _]) =>
      new ULtag._(tag, vList);

  static ULtag fromBytes(Tag tag, Bytes bytes) =>
      new ULtag._(tag, bytes.asUint32List());
}

/// Unsigned Short
class GLtag extends ULtag {
  /// Creates an [GLtag] Element.
  factory GLtag(Tag tag, [Iterable<int> vList]) => new GLtag._(tag, vList);

  factory GLtag.bulkdata(Tag tag, Uri url) =>
      new GLtag._(tag, new IntBulkdataRef(tag.code, url));

  factory GLtag._(Tag tag, Iterable<int> vList) {
    final v = Uint32.fromList(vList);
    return GL.isValidArgs(tag, vList)
        ? new GLtag._x(tag, v)
        : badValues(vList, null, tag);
  }

  GLtag._x(Tag tag, Iterable<int> values) : super._x(tag, values);

  @override
  GLtag update([Iterable<int> vList]) => new GLtag._(tag, vList);

  static GLtag fromValues(Tag tag, [Iterable<int> vList, TransferSyntax _]) =>
      new GLtag(tag, vList);

  static GLtag fromBytes(Tag tag, Bytes bytes) =>
      new GLtag._x(tag, bytes.asUint32List());
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
  factory ATtag(Tag tag, [Iterable<int> vList]) => new ATtag._(tag, vList);

  factory ATtag.bulkdata(Tag tag, Uri url) =>
      new ATtag._(tag, new IntBulkdataRef(tag.code, url));

  factory ATtag._(Tag tag, Iterable<int> vList) {
    final v = Uint32.fromList(vList);
    return AT.isValidArgs(tag, vList)
        ? new ATtag._x(tag, v)
        : badValues(vList, null, tag);
  }

  ATtag._x(this.tag, this._values)
      : assert(tag.vrIndex == kATIndex),
        assert(_values is Uint32List);

  @override
  ATtag update([Iterable<int> vList]) => new ATtag._(tag, vList);

  static ATtag fromValues(Tag tag, [Iterable<int> vList, TransferSyntax _]) =>
      new ATtag._(tag, vList);

  static ATtag fromBytes(Tag tag, Bytes bytes) =>
      new ATtag._(tag, bytes.asUint32List());
}
