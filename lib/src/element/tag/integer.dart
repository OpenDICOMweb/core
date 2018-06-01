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
  /// Always [List<int>] and [TypedData].
  List<int> get _values;
  set _values(List<int> v);

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

  static SStag fromBytes(Bytes bytes, Tag tag) =>
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

  static SLtag fromBytes(Bytes bytes, Tag tag) =>
      new SLtag._(tag, bytes.asInt32List());
}

/// 8-bit unsigned integer.
class OBtag extends OB with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  // Note: _values should always be a Uint8List.
  @override
  List<int> _values;
  @override
  int vfLengthField;

  /// Creates an [OBtag] Element.
  factory OBtag(Tag tag,
          [Iterable<int> vList, int vfLengthField, TransferSyntax ts]) =>
      new OBtag._(tag, vList, vfLengthField, ts);

  factory OBtag.bulkdata(Tag tag, Uri url,
          [int vfLengthField, TransferSyntax ts]) =>
      new OBtag._(tag, new IntBulkdataRef(tag.code, url), vfLengthField, ts);

  factory OBtag._(Tag tag, Iterable<int> vList, [int vlf, TransferSyntax ts]) {
    final v = Uint8.fromList(vList);
    if (!OB.isValidArgs(tag, v)) return badValues(vList, null, tag);
    return (tag.code == kPixelData)
        ? new OBtagPixelData._x(v, vlf, ts)
        : new OBtag._x(tag, v, v.length);
  }

  OBtag._x(this.tag, this._values, this.vfLengthField)
      : assert(tag.vrIndex == kOBIndex || tag.vrIndex == kOBOWIndex),
        assert(_values is Uint8List);

  @override
  OBtag update([Iterable<int> vList = kEmptyIntList]) =>
      new OBtag._(tag, vList);

  static OBtag fromValues(Tag tag, [Iterable<int> vList,
          int vfLengthField, TransferSyntax ts]) =>
      new OBtag._(tag, Uint8.fromList(vList), vfLengthField, ts);

  static OBtag fromBytes(Bytes bytes, Tag tag,
          [int vfLengthField, TransferSyntax ts]) =>
      new OBtag._(tag, bytes.asUint8List(), vfLengthField);
}

/// Unsigned 8-bit (Uint8)  Pixel Data.
//
// If encapsulated (compressed) then [fragments] must not be _null_. If
// [fragments] == _null_ then the pixels are uncompressed and data is
// contained in [values] or [vfBytes].
//
// _Note_: Pixel Data Tag Elements do not have [VFFragments].
//         [VFFragments] must be converted before they are created.
class OBtagPixelData extends OBPixelData with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag = PTag.kPixelDataOB;
  // Note: _values should always be a Uint8List.
  @override
  List<int> _values;
  @override
  final int vfLengthField;
  @override
  final TransferSyntax ts;

  /// Creates an [OBtagPixelData] Element from a [Iterable<int>].
  factory OBtagPixelData(Tag tag,
          [Iterable<int> vList, int vfLengthField, TransferSyntax ts]) =>
      new OBtagPixelData._(tag, vList, vfLengthField, ts);

  factory OBtagPixelData.bulkdata(Tag tag, Uri url,
          [int vfLengthField, TransferSyntax ts]) =>
      new OBtagPixelData._(
          tag, new IntBulkdataRef(tag.code, url), vfLengthField, ts);

  factory OBtagPixelData._(Tag tag, Iterable<int> vList,
      [int vlf, TransferSyntax ts]) {
    final v = _isEmpty(vList) ? kEmptyIntList : Uint8.fromList(vList);
    return OBPixelData.isValidArgs(tag, vList, vlf, ts)
        ? new OBtagPixelData._x(v, vlf, ts)
        : badValues(vList, null, tag);
  }

  OBtagPixelData._x(this._values, this.vfLengthField, this.ts)
      : assert(_values is Uint8List);

  @override
  OBtagPixelData update([Iterable<int> vList]) =>
      new OBtagPixelData._(tag, vList);

  /// Creates an [OBtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  static OBtagPixelData fromValues(Tag tag, Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts]) =>
      new OBtagPixelData._(tag, vList, vfLengthField, ts);

  /// Creates an [OBtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  static OBtagPixelData fromBytes(Bytes bytes, Tag tag,
          [int vfLengthField, TransferSyntax ts]) =>
      new OBtagPixelData._(tag, bytes.asUint8List(), vfLengthField, ts);
}

/// Unsigned 8-bit integer with unknown VR (VR.kUN).
class UNtag extends UN with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag;
  // Note: _values should always be a Int16List.
  @override
  List<int> _values;

  @override
  final int vfLengthField;

  /// Creates an [UNtag] Element.
  factory UNtag(Tag tag,
          [Iterable<int> vList, int vfLengthField, TransferSyntax ts]) =>
      new UNtag._(tag, vList, vfLengthField, ts);

  factory UNtag.bulkdata(Tag tag, Uri url,
          [int vfLengthField, TransferSyntax ts]) =>
      new UNtag._(tag, new IntBulkdataRef(tag.code, url), vfLengthField, ts);

  factory UNtag._(Tag tag, Iterable<int> vList, [int vlf, TransferSyntax ts]) {
    final v = Uint8.fromList(vList);
    if (!UN.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    return (tag.code == kPixelData)
        ? new UNtagPixelData._x(v, vlf, ts)
        : new UNtag._x(tag, v, v.length);
  }

  UNtag._x(this.tag, this._values, this.vfLengthField)
      : assert(_values is Uint8List);

  @override
  UNtag update([Iterable<int> vList = kEmptyIntList]) => new UNtag(tag, vList);

  static UNtag fromValues(Tag tag, Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts]) =>
      new UNtag._(tag, vList, vfLengthField, ts);

  static UNtag fromBytes(Bytes bytes, Tag tag,
          [int vfLengthField, TransferSyntax ts]) =>
      new UNtag._(tag, bytes.asUint8List(), vfLengthField, ts);
}

/// 8-bit Pixel Data.
//
// If encapsulated (compressed) then [fragments] must not be _null_. If
// [fragments] == _null_ then the pixels are uncompressed and data is
// contained in [values] or [vfBytes].
//
// _Note_: Pixel Data Tag Elements do not have [VFFragments].
//         [VFFragments] must be converted before they are created.
class UNtagPixelData extends UNPixelData with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag = PTag.kPixelDataUN;
  // Note: _values should always be a Int16List.
  @override
  List<int> _values;
  @override
  final int vfLengthField;
  @override
  final TransferSyntax ts;

  /// Creates an [UNtagPixelData] Element from a [Iterable<int>].
  factory UNtagPixelData(Tag tag,
          [Iterable<int> vList, int vfLengthField, TransferSyntax ts]) =>
      new UNtagPixelData._(tag, vList, vfLengthField, ts);

  factory UNtagPixelData.bulkdata(Tag tag, Uri url,
          [int vfLengthField, TransferSyntax ts]) =>
      new UNtagPixelData._(
          tag, new IntBulkdataRef(tag.code, url), vfLengthField, ts);

  factory UNtagPixelData._(Tag tag, Iterable<int> vList,
      [int vlf, TransferSyntax ts]) {
    final v = _isEmpty(vList) ? kEmptyIntList : Uint8.fromList(vList);
    return (UNPixelData.isValidArgs(tag, vList))
        ? new UNtagPixelData._x(v, vlf, ts)
        : badValues(v, null, tag);
  }

  UNtagPixelData._x(this._values, this.vfLengthField, this.ts)
      : assert(_values is Uint8List);

  @override
  UNtagPixelData update([Iterable<int> vList]) =>
      new UNtagPixelData._(tag, vList);

  /// Creates an [UNtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  static UNtagPixelData fromValues(Tag tag, Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts]) =>
      new UNtagPixelData._(tag, vList, vfLengthField, ts);

  /// Creates an [UNtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  static UNtagPixelData fromBytes(Bytes bytes, Tag tag,
          [int vfLengthField, TransferSyntax ts]) =>
      new UNtagPixelData._(tag, bytes.asUint8List(), vfLengthField, ts);
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

  static UStag fromValues(Tag tag, Iterable<int> vList) =>
      new UStag(tag, vList);

  static UStag fromBytes(Bytes bytes, Tag tag) =>
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
  @override
  final int vfLengthField;

  /// Creates an [OWtag] Element.
  factory OWtag(Tag tag,
          [Iterable<int> vList, int vfLengthField, TransferSyntax ts]) =>
      new OWtag._(tag, vList, vfLengthField, ts);

  factory OWtag._bulkdata(Tag tag, Uri url,
          [int vfLengthField, TransferSyntax ts]) =>
      new OWtag._(tag, new IntBulkdataRef(tag.code, url), vfLengthField, ts);

  factory OWtag._(Tag tag, Iterable<int> vList, int vlf, TransferSyntax ts) {
    final v = Uint16.fromList(vList);
    if (!OW.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    return (tag.code == kPixelData)
        ? new OWtagPixelData._(tag, v, vlf, ts)
        : new OWtag._x(tag, v, vlf);
  }

  OWtag._x(this.tag, this._values, this.vfLengthField)
      : assert(tag.vrIndex == kOWIndex || tag.vrIndex == kOBOWIndex),
        assert(_values is Uint16List);

  @override
  OWtag update([Iterable<int> vList = kEmptyIntList]) => new OWtag(tag, vList);

  static OWtag fromValues(Tag tag, Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts]) =>
      new OWtag(tag, vList, vfLengthField, ts);

  static OWtag fromBytes(Bytes bytes, Tag tag,
          [int vfLengthField, TransferSyntax ts]) =>
      new OWtag._(tag, bytes.asUint16List(), vfLengthField, ts);
}

/// 8-bit Pixel Data.
//
// If encapsulated (compressed) then [fragments] must not be _null_. If
// [fragments] == _null_ then the pixels are uncompressed and data is
// contained in [values] or [vfBytes].
//
// _Note_: Pixel Data Tag Elements do not have [VFFragments].
//         [VFFragments] must be converted before they are created.
class OWtagPixelData extends OWPixelData with TagElement<int>, TagIntegerMixin {
  @override
  final Tag tag = PTag.kPixelDataOW;
  // Note: _values should always be a Int16List.
  @override
  List<int> _values;
  @override
  final int vfLengthField;
  @override
  final TransferSyntax ts;

  /// Creates an [OWtagPixelData] Element from a [Iterable<int>]
  /// of byte values (0 - kMax16BitValue).
  factory OWtagPixelData(Tag tag, Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts]) =>
      new OWtagPixelData._(tag, vList, vfLengthField, ts);

  factory OWtagPixelData._bulkdata(Tag tag, Uri url,
          [int vfLengthField, TransferSyntax ts]) =>
      new OWtagPixelData._(
          tag, new IntBulkdataRef(tag.code, url), vfLengthField, ts);

  factory OWtagPixelData._(Tag tag, Iterable<int> vList,
          [int vlf, TransferSyntax ts]) =>
      (OWPixelData.isValidArgs(tag, vList))
          ? new OWtagPixelData._x(Uint16.fromList(vList), vlf, ts)
          : badValues(vList, null, tag);

  OWtagPixelData._x(this._values, this.vfLengthField, this.ts)
      : assert(_values is Uint16List);

  @override
  OWtagPixelData update([Iterable<int> vList]) =>
      new OWtagPixelData._(tag, vList);

  /// Creates an [OWtagPixelData] Element from a [Uint8List].
  static OWtagPixelData fromValues(Tag tag, Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts]) =>
      new OWtagPixelData._(tag, vList, vfLengthField, ts);

  /// Creates an [OWtagPixelData] Element from a [Uint8List].
  static OWtagPixelData fromBytes(Bytes bytes, Tag tag,
          [int vfLengthField, TransferSyntax ts]) =>
      new OWtagPixelData._(tag, bytes.asUint16List(), vfLengthField, ts);
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

  static OLtag fromValues(Tag tag, Iterable<int> vList) =>
      new OLtag._(tag, vList);

  static OLtag fromBytes(Bytes bytes, Tag tag) =>
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

  static ULtag fromValues(Tag tag, Iterable<int> vLIst) =>
      new ULtag._(tag, vLIst);

  static ULtag fromBytes(Bytes bytes, Tag tag) =>
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

  static GLtag fromValues(Tag tag, Iterable<int> vList) =>
      new GLtag(tag, vList);

  static GLtag fromBytes(Bytes bytes, Tag tag) =>
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

  static ATtag fromValues(Tag tag, Iterable<int> vList) =>
      new ATtag._(tag, vList);

  static ATtag fromBytes(Bytes bytes, Tag tag) =>
      new ATtag._(tag, bytes.asUint32List());
}
