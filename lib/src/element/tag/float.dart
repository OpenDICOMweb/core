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

class Float32Tag {
  Float32List _values;
  Iterable<double> get values => _values;
  set values(Iterable<double> vList) =>
    _values = (vList is Float32List) ? vList : Float32.fromList(vList);
}

class Float64Tag {
  Float64List _values;
  Iterable<double> get values => _values;
  set values(Iterable<double> vList) =>
      _values = (vList is Float64List) ? vList : Float64.fromList(vList);
}
/// Float - Array of IEEE single precision (32-bit) floating point numbers.
/// Max Array length is ((2^16)-4)/ 4).
class FLtag extends FL with TagElement<double> {
  Float32List _values;

  @override
  final Tag tag;

  /// Creates an [FLtag] from a [List<double].
  factory FLtag(Tag tag, [Iterable<double> vList = kEmptyDoubleList]) =>
      new FLtag._(tag, vList);

  factory FLtag.bulkdata(Tag tag, Uri url) =>
      new FLtag._(tag, new FloatBulkdataRef(tag.code, url));

  factory FLtag._(Tag tag, Iterable<double> vList) {
    if (!FL.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    final v = (vList.isEmpty) ? kEmptyFloat64List : Float32.fromList(vList);
    return new FLtag._x(tag, Float32.fromList(v));
  }

  FLtag._x(this.tag, this._values) : assert(tag.vrIndex == kFLIndex);

  @override
  Iterable<double> get values => _values;
  @override
  set values(Iterable<double> vList) =>
      _values = (vList is Float32List) ? vList : Float32.fromList(vList);

  @override
  FLtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      new FLtag._(tag, vList);

  static FLtag fromValues(Tag tag, Iterable<double> vList, [int _]) =>
      new FLtag._(tag, vList);

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
  Float32List _values;
  @override
  final Tag tag;

  /// Creates an [OFtag] from a [Iterable<double>].
  factory OFtag(Tag tag, [Iterable<double> vList = kEmptyDoubleList]) =>
      new OFtag._(tag, vList);

  factory OFtag.bulkdata(Tag tag, Uri url) =>
      new OFtag._(tag, new FloatBulkdataRef(tag.code, url));

  factory OFtag._(Tag tag, Iterable<double> vList) {
    if (!OF.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    final v = (vList.isEmpty) ? kEmptyFloat64List : Float32.fromList(vList);
    return new OFtag._x(tag, v);
  }
  OFtag._x(this.tag, this._values) : assert(tag.vrIndex == kFLIndex);

  @override
  OFtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      new OFtag(tag, vList);

  static OFtag fromValues(Tag tag, Iterable<double> vList, [int _]) =>
      new OFtag(tag, vList ?? kEmptyDoubleList);

  static OFtag fromBytes(Tag tag, Bytes bytes, [int _]) =>
      OF.isValidBytesArgs(tag, bytes)
          ? new OFtag._x(tag, bytes.asFloat32List())
          : badTag(tag, null, FL);
}

/// Float - Array of IEEE single precision (64-bit) floating point numbers.
/// Max Array length is ((2^16)-4)/ 4)
class FDtag extends FD with TagElement<double> {
  Float64List _values;
  @override
  final Tag tag;

  /// Creates an [FDtag] from a [Iterable<double>].
  factory FDtag(Tag tag, [Iterable<double> vList = kEmptyDoubleList]) =>
      new FDtag._(tag, vList);

  factory FDtag.bulkdata(Tag tag, Uri url) =>
      new FDtag._(tag, new FloatBulkdataRef(tag.code, url));

  factory FDtag._(Tag tag, Iterable<double> vList) {
    if (!FD.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    final v = (vList.isEmpty) ? kEmptyFloat64List : Float64.fromList(vList);
    return new FDtag._x(tag, v);
  }

  FDtag._x(this.tag, this._values);

  @override
  Iterable<double> get values => _values;
  @override
  set values(Iterable<double> vList) =>
      _values = (vList is Float64List) ? vList : Float64.fromList(vList);

  @override
  FDtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      new FDtag(tag, vList);

  static FDtag fromValues(Tag tag, Iterable<double> vList, [int _]) =>
      new FDtag(tag, vList ?? kEmptyDoubleList);

  static FDtag fromBytes(Tag tag, Bytes bytes, [int _]) =>
      FD.isValidBytesArgs(tag, bytes)
          ? new FDtag._x(tag, bytes.asFloat64List())
          : badTag(tag, null, FL);
}

/// Float - Array of IEEE single precision (64-bit) floating point numbers.
///
/// Max Array length is ((2^16)-4)/ 4)
class ODtag extends OD with TagElement<double> {
  Float64List _values;
  @override
  final Tag tag;

  /// Creates an [ODtag] from a [Iterable<double>].
  factory ODtag(Tag tag, [Iterable<double> vList = kEmptyDoubleList]) =>
      new ODtag._(tag, vList);

  factory ODtag.bulkdata(Tag tag, Uri url) =>
      new ODtag._(tag, new FloatBulkdataRef(tag.code, url));

  factory ODtag._(Tag tag, Iterable<double> vList) {
    if (!OD.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    final v = (vList.isEmpty) ? kEmptyFloat64List : Float64.fromList(vList);
    return new ODtag._x(tag, v);
  }

  ODtag._x(this.tag, this._values);

  @override
  Iterable<double> get values => _values;
  @override
  set values(Iterable<double> vList) =>
      _values = (vList is Float64List) ? vList : Float64.fromList(vList);

  @override
  ODtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      new ODtag(tag, vList);

  static ODtag fromValues(Tag tag, Iterable<double> vList, [int _]) =>
      new ODtag._(tag, vList);

  static ODtag fromBytes(Tag tag, Bytes bytes, [int _]) =>
      OD.isValidBytesArgs(tag, bytes)
          ? new ODtag._x(tag, bytes.asFloat64List())
          : badTag(tag, null, FL);
}
