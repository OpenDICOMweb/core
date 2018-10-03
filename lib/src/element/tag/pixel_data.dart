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
import 'package:core/src/values/image.dart';
import 'package:core/src/values/uid/well_known/transfer_syntax.dart';

// ignore_for_file: public_member_api_docs

bool _isEmpty(Iterable<int> vList) => vList == null || vList.isEmpty;

/// PixelDataMixin class
abstract class TagPixelData {
  int get code;
  int get length;
  int get sizeInBytes;

  int get vfLength => length * sizeInBytes;

  List<int> get values => _values;

  // [_values] MUST always be List<int> and [TypedData].
  List<int> get _values;

  /// A [Uint8List] created from [frames].
  Uint8List get bulkdata;

  /// The [List<Frame>] of pixels.
  FrameList get frames => _frames;
  FrameList get _frames;

  /// A [Uint32List] of offsets into [bulkdata].
  Uint32List get offsets => frames.offsets;

  /// The [TransferSyntax] of _this_.
  TransferSyntax get ts;

  /// Returns _true_ if [frames] are compressed.
  ///
  /// Note: If _this_ [isCompressed] and has more than one Frame,
  ///       It should have a non-empty [offsets].
  bool get isCompressed;

  // **** End Interface

  /// Synonym for pisCompressed].
  bool get isEncapsulated => isCompressed;
}

/// Unsigned 8-bit (Uint8) OB Pixel Data.
///
/// _Note_: [OBtagPixelData] [Element]s always have a [tag] of
/// [PTag.kPixelDataOB], so the constructors do not take a [Tag] argument.
///
// _Note_: Pixel Data Tag Elements do not have [VFFragments].
//         [VFFragments] must be converted before they are created.
class OBtagPixelData extends OBPixelData with TagElement<int>, TagPixelData {
  // Note: _values should always be a Uint8List.
  @override
  Uint8List _values;
  @override
  FrameList8Bit _frames;
  @override
  final TransferSyntax ts;

  /// Creates an [OBtagPixelData] Element from a [Iterable<int>].
  factory OBtagPixelData(Iterable<int> vList, [TransferSyntax ts]) =>
      OBtagPixelData._(vList, ts);

  /// Creates an [OBtagPixelData] Element from a [Iterable<int>].
  OBtagPixelData.fromPixels(Iterable<int> vList, [this.ts])
      : _values = (vList is Uint8List) ? vList : Uint8.fromList(vList);

  /// Creates an [OBtagPixelData] Element from a [Iterable<Frame>].
  OBtagPixelData.fromFrames(this._frames, [this.ts])
      : assert(_frames is FrameList8Bit);

  factory OBtagPixelData.fromBulkdata(Uri url, [TransferSyntax ts]) =>
      OBtagPixelData._(IntBulkdataRef(kPixelData, url), ts);

  factory OBtagPixelData._(Iterable<int> vList, [TransferSyntax ts]) {
    final v = _isEmpty(vList) ? kEmptyIntList : Uint8.fromList(vList);
    return OBPixelData.isValidArgs(vList, ts)
        ? OBtagPixelData._x(v, ts)
        : badValues(vList, null, PTag.kPixelDataOB);
  }

  OBtagPixelData._x(this._values, [this.ts]) : assert(_values is Uint8List);

  @override
  int get vrIndex => kOBIndex;

  @override
  OBtagPixelData update([Iterable<int> vList]) => OBtagPixelData._(vList);

  /// Returns _true_ if [vList] is valid for [OB].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Iterable<int> vList, TransferSyntax ts,
      [Issues issues]) {
    if (!doTestElementValidity) return true;
    return vList != null && OB.isValidValues(PTag.kPixelDataOB, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [SS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [SS] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidBytesArgs(Bytes vfBytes, [Issues issues]) {
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        OB.isValidVFLength(vfBytes.length, issues, PTag.kPixelDataOB);
  }

  /// Creates an [OBtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  // ignore: prefer_constructors_over_static_methods
  static OBtagPixelData fromValues(Iterable<int> vList, [TransferSyntax ts]) =>
      OBtagPixelData._(vList, ts);

  /// Creates an [OBtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  // ignore: prefer_constructors_over_static_methods
  static OBtagPixelData fromBytes(Bytes bytes, [TransferSyntax ts]) =>
      OBtagPixelData._(bytes.asUint8List(), ts);
}

/// 8-bit Pixel Data.
//
// If encapsulated (compressed) then [fragments] must not be _null_. If
// [fragments] == _null_ then the pixels are uncompressed and data is
// contained in [values] or [vfBytes].
//
// _Note_: Pixel Data Tag Elements do not have [VFFragments].
//         [VFFragments] must be converted before they are created.
class UNtagPixelData extends UNPixelData with TagElement<int>, TagPixelData {
  // Note: _values should always be a Uint8List.
  @override
  Uint8List _values;
  @override
  FrameList8Bit _frames;
  @override
  final TransferSyntax ts;

  /// Creates an [UNtagPixelData] Element from a [Iterable<int>].
  factory UNtagPixelData(Iterable<int> vList, [TransferSyntax ts]) =>
      UNtagPixelData._(vList, ts);

  /// Creates an [UNtagPixelData] Element from a [Iterable<int>].
  UNtagPixelData.fromPixels(Iterable<int> vList, [this.ts])
      : _values = (vList is Uint8List) ? vList : Uint8.fromList(vList);

  /// Creates an [OBtagPixelData] Element from a [Iterable<Frame>].
  UNtagPixelData.fromFrames(this._frames, [this.ts])
      : assert(_frames is FrameList8Bit);

  factory UNtagPixelData.fromBulkdata(Uri url, [TransferSyntax ts]) =>
      UNtagPixelData._(IntBulkdataRef(kPixelData, url), ts);

  factory UNtagPixelData._(Iterable<int> vList, [TransferSyntax ts]) {
    final v = _isEmpty(vList) ? kEmptyIntList : Uint8.fromList(vList);
    return (UNPixelData.isValidArgs(PTag.kPixelDataUN, vList))
        ? UNtagPixelData._x(v, ts)
        : badValues(v, null, PTag.kPixelDataUN);
  }

  UNtagPixelData._x(this._values, [this.ts]) : assert(_values is Uint8List);

  @override
  int get vrIndex => kUNIndex;

  @override
  UNtagPixelData update([Iterable<int> vList]) => UNtagPixelData._(vList);

  /// Returns _true_ if [vList] is valid for [UN].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Iterable<int> vList, TransferSyntax ts,
      [Issues issues]) {
    if (!doTestElementValidity) return true;
    return vList != null && UN.isValidValues(PTag.kPixelDataUN, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [SS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [SS] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidBytesArgs(Bytes vfBytes, [Issues issues]) {
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        UN.isValidVFLength(vfBytes.length, issues, PTag.kPixelDataUN);
  }

  /// Creates an [UNtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  // ignore: prefer_constructors_over_static_methods
  static UNtagPixelData fromValues(Iterable<int> vList, [TransferSyntax ts]) =>
      UNtagPixelData._(vList, ts);

  /// Creates an [UNtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  // ignore: prefer_constructors_over_static_methods
  static UNtagPixelData fromBytes(Bytes bytes, [TransferSyntax ts]) =>
      UNtagPixelData._(bytes.asUint8List(), ts);
}

/// Unsigned 8-bit (Uint8) OW Pixel Data.
///
/// _Note_: [OWtagPixelData] [Element]s always have a [tag] of
/// [PTag.kPixelDataOW], so the constructors do not take a [Tag] argument.
///
// _Note_: Pixel Data Tag Elements do not have [VFFragments].
//         [VFFragments] must be converted before they are created.
class OWtagPixelData extends OWPixelData with TagElement<int>, TagPixelData {
  // Note: _values should always be a Uint16List.
  @override
  Uint16List _values;
  @override
  FrameList16Bit _frames;
  @override
  final TransferSyntax ts;

  /// Creates an [OWtagPixelData] Element from a [Iterable<int>]
  /// of byte values (0 - kMax16BitValue).
  factory OWtagPixelData(Iterable<int> vList, [TransferSyntax ts]) =>
      OWtagPixelData._(vList, ts);

  /// Creates an [OWtagPixelData] Element from a [Iterable<int>].
  OWtagPixelData.fromPixels(Iterable<int> vList, [this.ts])
      : _values = (vList is Uint16List) ? vList : Uint16.fromList(vList);

  /// Creates an [OWtagPixelData] Element from a [Iterable<Frame>].
  OWtagPixelData.fromFrames(this._frames, [this.ts])
      : assert(_frames is FrameList16Bit);

  factory OWtagPixelData.fromBulkdata(Uri url, [TransferSyntax ts]) =>
      OWtagPixelData._(IntBulkdataRef(kPixelData, url), ts);

  factory OWtagPixelData._(Iterable<int> vList, TransferSyntax ts) {
    final v = _isEmpty(vList) ? kEmptyIntList : Uint16.fromList(vList);
    return OWPixelData.isValidArgs(PTag.kPixelDataOW, v)
        ? OWtagPixelData._x(Uint16.fromList(v), ts)
        : badValues(v, null, PTag.kPixelDataOW);
  }

  OWtagPixelData._x(this._values, [this.ts]) : assert(_values is Uint16List);

  @override
  int get vrIndex => kOWIndex;

  @override
  OWtagPixelData update([Iterable<int> vList, TransferSyntax ts]) =>
      OWtagPixelData._(vList, ts);

  /// Returns _true_ if [vList] is valid for [OW].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  static bool isValidArgs(Iterable<int> vList, TransferSyntax ts,
      [Issues issues]) {
    if (!doTestElementValidity) return true;
    return vList != null && OW.isValidValues(PTag.kPixelDataOW, vList, issues);
  }

  /// Returns _true_ if both [tag] and [vfBytes] are valid for [SS].
  /// If [doTestElementValidity] is _false_ then no checking is done.
  // _Note_: Some [Tag]s have _Special VR_s that include [SS] VRs, such as
  // [kUSSSIndex] and [kUSSSOWIndex], so [ Tag.isValidSpecialTag] is used.
  static bool isValidBytesArgs(Bytes vfBytes, [Issues issues]) {
    if (!doTestElementValidity) return true;
    return vfBytes != null &&
        OW.isValidVFLength(vfBytes.length, issues, PTag.kPixelDataOW);
  }

  /// Creates an [OWtagPixelData] Element from a [Uint16List].
  // ignore: prefer_constructors_over_static_methods
  static OWtagPixelData fromValues(Iterable<int> vList, [TransferSyntax ts]) =>
      OWtagPixelData._(vList, ts);

  /// Creates an [OWtagPixelData] Element from a [Uint8List].
  // ignore: prefer_constructors_over_static_methods
  static OWtagPixelData fromBytes(Bytes bytes, [TransferSyntax ts]) =>
      OWtagPixelData._(bytes.asUint16List(), ts);
}
