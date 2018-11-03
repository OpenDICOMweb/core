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

// ignore_for_file: public_member_api_docs

abstract class TagFloatMixin {
  List<double> get _values;
  set _values(List<double> v);

  List<double> get values => _values;

  set values(Iterable<double> vList) => _values =
      (vList == null || vList.isEmpty) ? kEmptyStringList : vList.toList();

  /// Replace the current [values] with [vList], and return the original
  /// [values]. This method modifies the [Element].
  List<double> replace([Iterable<double> vList]) {
    final old = _values;
    _values = _toValues(vList);
    return old;
  }
}

List<double> _toValues(Iterable<double> vList) {
  if (throwOnError && vList == null) return badValues(vList);
  return (vList == null || vList.isEmpty) ? kEmptyDoubleList : vList;
}

/// Float - Array of IEEE single precision (32-bit) floating point numbers.
/// Max Array length is ((2^16)-4)/ 4).
class FLtag extends FL with TagElement<double>, TagFloatMixin {
  @override
  final Tag tag;
  @override
  List<double> _values;

  /// Creates an [FLtag] from a [List<double].
  factory FLtag(Tag tag, [Iterable<double> vList = kEmptyDoubleList]) =>
      FLtag._(tag, vList);

  factory FLtag.bulkdata(Tag tag, Uri url) =>
      FLtag._(tag, FloatBulkdataRef(tag.code, url));

  factory FLtag._(Tag tag, Iterable<double> vList) {
    if (!FL.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    final v =
        (vList.isEmpty) ? kEmptyFloat32List : Float32Mixin.fromList(vList);
    return FLtag._x(tag, Float32Mixin.fromList(v));
  }

  FLtag._x(this.tag, this._values)
      : assert(tag.vrIndex == kFLIndex),
        assert(_values is Float32List);

  @override
  FLtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      FLtag._(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static FLtag fromValues(Tag tag, Iterable<double> vList) =>
      FLtag._(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static FLtag fromBytes(Tag tag, Bytes bytes, [Charset _]) =>
      FL.isValidBytesArgs(tag, bytes)
          ? FLtag._x(tag, bytes.asFloat32List())
          : badTag(tag, null, FL);
}

/// Other Float - Array of IEEE single precision
/// (32-bit) floating point numbers.
///
/// Max Array length is ((2^32)-4)/ 4)
class OFtag extends OF with TagElement<double>, TagFloatMixin {
  @override
  final Tag tag;
  @override
  List<double> _values;

  /// Creates an [OFtag] from a [Iterable<double>].
  factory OFtag(Tag tag, [Iterable<double> vList = kEmptyDoubleList]) =>
      OFtag._(tag, vList);

  factory OFtag.bulkdata(Tag tag, Uri url) =>
      OFtag._(tag, FloatBulkdataRef(tag.code, url));

  factory OFtag._(Tag tag, Iterable<double> vList) {
    if (!OF.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    final v =
        (vList.isEmpty) ? kEmptyFloat32List : Float32Mixin.fromList(vList);
    return OFtag._x(tag, v);
  }

  OFtag._x(this.tag, this._values)
      : assert(tag.vrIndex == kOFIndex),
        assert(_values is Float32List);

  @override
  OFtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      OFtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static OFtag fromValues(Tag tag, Iterable<double> vList) =>
      OFtag(tag, vList ?? kEmptyDoubleList);

  // ignore: prefer_constructors_over_static_methods
  static OFtag fromBytes(Tag tag, Bytes bytes, [Charset _]) =>
      OF.isValidBytesArgs(tag, bytes)
          ? OFtag._x(tag, bytes.asFloat32List())
          : badTag(tag, null, FL);
}

/// Float - Array of IEEE single precision (64-bit) floating point numbers.
/// Max Array length is ((2^16)-4)/ 4)
class FDtag extends FD with TagElement<double>, TagFloatMixin {
  @override
  final Tag tag;
  @override
  List<double> _values;

  /// Creates an [FDtag] from a [Iterable<double>].
  factory FDtag(Tag tag, [Iterable<double> vList = kEmptyDoubleList]) =>
      FDtag._(tag, vList);

  factory FDtag.bulkdata(Tag tag, Uri url) =>
      FDtag._(tag, FloatBulkdataRef(tag.code, url));

  factory FDtag._(Tag tag, Iterable<double> vList) {
    if (!FD.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    final v = (vList == null || vList.isEmpty)
        ? kEmptyFloat64List
        : Float64Mixin.fromList(vList);
    return FDtag._x(tag, v);
  }

  FDtag._x(this.tag, this._values)
      : assert(tag.vrIndex == kFDIndex),
        assert(_values is Float64List);

  @override
  FDtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      FDtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static FDtag fromValues(Tag tag, Iterable<double> vList) =>
      FDtag(tag, vList ?? kEmptyDoubleList);

  // ignore: prefer_constructors_over_static_methods
  static FDtag fromBytes(Tag tag, Bytes bytes, [Charset _]) =>
      FD.isValidBytesArgs(tag, bytes)
          ? FDtag._x(tag, bytes.asFloat64List())
          : badTag(tag, null, FL);
}

/// Float - Array of IEEE single precision (64-bit) floating point numbers.
///
/// Max Array length is ((2^16)-4)/ 4)
class ODtag extends OD with TagElement<double>, TagFloatMixin {
  @override
  final Tag tag;
  @override
  List<double> _values;

  /// Creates an [ODtag] from a [Iterable<double>].
  factory ODtag(Tag tag, [Iterable<double> vList = kEmptyDoubleList]) =>
      ODtag._(tag, vList);

  factory ODtag.bulkdata(Tag tag, Uri url) =>
      ODtag._(tag, FloatBulkdataRef(tag.code, url));

  factory ODtag._(Tag tag, Iterable<double> vList) {
    if (!OD.isValidArgs(tag, vList)) return badValues(vList, null, tag);
    final v =
        (vList.isEmpty) ? kEmptyFloat64List : Float64Mixin.fromList(vList);
    return ODtag._x(tag, v);
  }

  ODtag._x(this.tag, this._values)
      : assert(tag.vrIndex == kODIndex),
        assert(_values is Float64List);

  @override
  ODtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      ODtag(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static ODtag fromValues(Tag tag, Iterable<double> vList) =>
      ODtag._(tag, vList);

  // ignore: prefer_constructors_over_static_methods
  static ODtag fromBytes(Tag tag, Bytes bytes, [Charset _]) =>
      OD.isValidBytesArgs(tag, bytes)
          ? ODtag._x(tag, bytes.asFloat64List())
          : badTag(tag, null, FL);
}
