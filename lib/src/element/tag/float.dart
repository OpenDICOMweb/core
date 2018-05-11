// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/element/base.dart';
import 'package:core/src/element/tag/tag_element.dart';
import 'package:core/src/error.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/primitives.dart';

/// Float - Array of IEEE single precision (32-bit) floating point numbers.
/// Max Array length is ((2^16)-4)/ 4).
class FLtag extends FL with TagElement<double> {
  @override
  final Tag tag;
  @override
  Iterable<double> values;

  /// Creates an [FLtag] from a [List<double].
  factory FLtag(Tag tag, [Iterable<double> vList = kEmptyDoubleList]) =>
      new FLtag._(tag, vList);

  factory FLtag.bulkdata(Tag tag, Uri url) =>
      new FLtag._(tag, new FloatBulkdataRef(tag.code, url));

  factory FLtag._(Tag tag, Iterable<double> vList) {
    if (!FL.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    final v = (vList.isEmpty) ? kEmptyFloat32List : vList;
    return new FLtag._x(tag, v);
  }

  FLtag._x(this.tag, this.values) : assert(tag.vrIndex == kFLIndex);

  @override
  FLtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      new FLtag(tag, vList);

  static FLtag fromValues(Tag tag, Iterable<double> vList, [int _]) =>
      new FLtag(tag, vList ?? kEmptyDoubleList);

  static FLtag fromBytes(Tag tag, Bytes bytes, [int _]) =>
      FL.isValidBytesArgs(tag, bytes)
          ? new FLtag._x(tag, bytes.asFloat32List())
          : badTag(tag, null, FL);
}

/// Other Float - Array of IEEE single precision
/// (32-bit) floating point numbers.
///
/// Max Array length is ((2^32)-4)/ 4)
class OFtag extends OF with TagElement<double> {
  @override
  final Tag tag;
  @override
  Iterable<double> values;

  /// Creates an [OFtag] from a [Iterable<double>].
  factory OFtag(Tag tag, [Iterable<double> vList = kEmptyDoubleList]) =>
      (OF.isValidArgs(tag, vList))
          ? new OFtag._(tag, vList)
          : badValues(vList, null, tag);

  factory OFtag.bulkdata(Tag tag, Uri url) =>
      new OFtag._(tag, new FloatBulkdataRef(tag.code, url));

  OFtag._(this.tag, this.values);

  @override
  OFtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      new OFtag(tag, vList);

  static OFtag fromValues(Tag tag, Iterable<double> vList, [int _]) =>
      new OFtag(tag, vList ?? kEmptyDoubleList);

  static OFtag fromBase64(Tag tag, String s) =>
      fromBytes(tag, Bytes.fromBase64(s));

  static OFtag fromUint8List(Tag tag, Uint8List bList) =>
      fromBytes(tag, new Bytes.typedDataView(bList));

  static OFtag from(Element e) => fromBytes(e.tag, e.vfBytes);

  static OFtag fromBytes(Tag tag, Bytes bytes,
          [int _]) =>
      (tag.vrIndex != kOFIndex)
          ? Tag.isValidTag(tag, null, kOFIndex, OF)
          : (OF.isNotValidTag(tag))
              ? null
              : new OFtag._(tag, bytes.asFloat32List());
}

/// Float - Array of IEEE single precision (64-bit) floating point numbers.
/// Max Array length is ((2^16)-4)/ 4)
class FDtag extends FD with TagElement<double> {
  @override
  final Tag tag;
  @override
  Iterable<double> values;

  /// Creates an [FDtag] from a [Iterable<double>].
  factory FDtag(Tag tag, [Iterable<double> vList = kEmptyDoubleList]) =>
      (FD.isValidArgs(tag, vList))
          ? new FDtag._(tag, vList)
          : badValues(vList, null, tag);

  factory FDtag.bulkdata(Tag tag, Uri url) =>
      new FDtag._(tag, new FloatBulkdataRef(tag.code, url));

  FDtag._(this.tag, this.values);

  @override
  FDtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      new FDtag(tag, vList);

  static FDtag fromValues(Tag tag, Iterable<double> vList, [int _]) =>
      new FDtag(tag, vList ?? kEmptyDoubleList);

  static FDtag fromBase64(Tag tag, String s) =>
      fromBytes(tag, Bytes.fromBase64(s));

  static FDtag fromUint8List(Tag tag, Uint8List bList) =>
      fromBytes(tag, new Bytes.typedDataView(bList));

  static FDtag from(Element e) => fromBytes(e.tag, e.vfBytes);

  static FDtag fromBytes(Tag tag, Bytes bytes, [int _]) =>
      FD.isValidTag(tag) ? new FDtag._(tag, bytes.asFloat64List()) : null;
}

/// Float - Array of IEEE single precision (64-bit) floating point numbers.
///
/// Max Array length is ((2^16)-4)/ 4)
class ODtag extends OD with TagElement<double> {
  @override
  final Tag tag;
  @override
  Iterable<double> values;

  /// Creates an [ODtag] from a [Iterable<double>].
  factory ODtag(Tag tag, [Iterable<double> vList = kEmptyDoubleList]) =>
      (OD.isValidArgs(tag, vList))
          ? new ODtag._(tag, vList)
          : badValues(vList, null, tag);

  factory ODtag.bulkdata(Tag tag, Uri url) =>
      new ODtag._(tag, new FloatBulkdataRef(tag.code, url));

  ODtag._(this.tag, this.values);

  @override
  ODtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      new ODtag(tag, vList);

  static ODtag fromValues(Tag tag, Iterable<double> vList, [int _]) =>
      new ODtag._(tag, vList);

  static ODtag fromBase64(Tag tag, String s) =>
      fromBytes(tag, Bytes.fromBase64(s));

  static ODtag fromUint8List(Tag tag, Uint8List bList) =>
      fromBytes(tag, new Bytes.typedDataView(bList));

  static ODtag from(Element e) => fromBytes(e.tag, e.vfBytes);

  static ODtag fromBytes(Tag tag, Bytes bytes,
          [int _]) =>
      (tag.vrIndex != kODIndex)
          ? Tag.isValidTag(tag, null, kFDIndex, FD)
          : (OD.isNotValidTag(tag))
              ? null
              : new ODtag._(tag, bytes.asFloat64List());
}
