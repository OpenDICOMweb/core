// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/core.dart';

import 'package:core/src/element/base/bulkdata.dart';
import 'package:core/src/element/byte_data/bd_element.dart';
import 'package:core/src/element/errors.dart';
import 'package:core/src/element/tag/tag_element.dart';
import 'package:core/src/tag/tag.dart';

class FloatBulkdata extends BulkdataRef<double> {
  @override
  int code;
  @override
  String uri;

  FloatBulkdata(this.code, this.uri);

  @override
  List<double> get values => _values ??= getBulkdata(code, uri);
  List<double> _values;
}

/// Float - Array of IEEE single precision (32-bit) floating point numbers.
/// Max Array length is ((2^16)-4)/ 4).
class FLtag extends FL with TagElement<double> {
  @override
  final Tag tag;
  @override
  Iterable<double> values;

  /// Creates an [FLtag] from a [List<double].
  factory FLtag(Tag tag, [Iterable<double> vList = kEmptyDoubleList]) =>
      (FL.isValidArgs(tag, vList))
          ? new FLtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  factory FLtag.bulkdata(Tag tag, String url) =>
      new FLtag._(tag, new FloatBulkdata(tag.code, url));

  FLtag._(this.tag, this.values);

  @override
  FLtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      new FLtag(tag, vList);

  @override
  FLtag updateF(Iterable<double> f(Iterable<double> vList)) =>
      new FLtag(tag, f(values));

  static FLtag make<double>(Tag tag, Iterable<double> vList) =>
      new FLtag(tag, vList ?? kEmptyDoubleList);

  static FLtag fromBase64(Tag tag, String s) => (FL.isNotValidTag(tag))
      ? null
      : new FLtag._(tag, Float32Base.listFromBase64(s) ?? kEmptyDoubleList);

  /// Creates an [FLtag] from a [Uint8List].
  static FLtag fromBytes(Tag tag, Uint8List bytes) => (FL.isNotValidTag(tag))
      ? null
      : new FLtag._(tag, Float32Base.listFromBytes(bytes) ?? kEmptyDoubleList);

  static FLtag fromBD(BDElement bd) =>
      (FL.isNotValidTag(bd.tag)) ? null : new FLtag._(bd.tag, bd.values);
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

  /// Creates an [OFtag] from a [List<double].
  factory OFtag(Tag tag, [Iterable<double> vList = kEmptyDoubleList]) =>
      (OF.isValidArgs(tag, vList))
          ? new OFtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  OFtag._(this.tag, this.values);

  @override
  OFtag update([Iterable<double> vList]) => new OFtag(tag, vList);

  @override
  OFtag updateF(Iterable<double> f(Iterable<double> vList)) =>
      new OFtag(tag, f(values));

  static OFtag make<double>(Tag tag, Iterable<double> vList) =>
      new OFtag(tag, vList ?? kEmptyDoubleList);

  static OFtag fromBase64(Tag tag, String s) => (OF.isNotValidTag(tag))
      ? null
      : new OFtag._(tag, Float32Base.listFromBase64(s) ?? kEmptyDoubleList);

  /// Creates an [OFtag] from a [Uint8List].
  static OFtag fromBytes(Tag tag, Uint8List bytes) => (OF.isNotValidTag(tag))
      ? null
      : new OFtag._(tag, Float32Base.listFromBytes(bytes) ?? kEmptyDoubleList);

  static OFtag fromBD(BDElement bd) =>
      (OF.isNotValidTag(bd.tag)) ? null : new OFtag._(bd.tag, bd.values);
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
          : invalidValuesError(vList, tag: tag);

  FDtag._(this.tag, this.values);

  @override
  FDtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      new FDtag(tag, vList);

  @override
  FDtag updateF(Iterable<double> f(Iterable<double> vList)) =>
      new FDtag(tag, f(values));

  static FDtag make<double>(Tag tag, Iterable<double> vList) =>
      new FDtag(tag, vList ?? kEmptyDoubleList);

  static FDtag fromBase64(Tag tag, String s) => (FD.isNotValidTag(tag))
      ? null
      : new FDtag._(tag, Float64Base.listFromBase64(s) ?? kEmptyDoubleList);

  /// Creates an [FDtag] from a [Uint8List].
  static FDtag fromBytes(Tag tag, Uint8List bytes) => (FD.isNotValidTag(tag))
      ? null
      : new FDtag._(tag, Float64Base.listFromBytes(bytes) ?? kEmptyDoubleList);

  static FDtag fromBD(BDElement bd) =>
      (FD.isNotValidTag(bd.tag)) ? null : new FDtag._(bd.tag, bd.values);
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
          : invalidValuesError(vList, tag: tag);

  ODtag._(this.tag, this.values);

  @override
  ODtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      new ODtag(tag, vList);

  @override
  ODtag updateF(Iterable<double> f(Iterable<double> vList)) =>
      new ODtag(tag, f(values));

  static ODtag make<double>(Tag tag, Iterable<double> vList) =>
      new ODtag(tag, vList ?? kEmptyDoubleList);

  static ODtag fromBase64(Tag tag, String s) => (OD.isNotValidTag(tag))
      ? null
      : new ODtag._(tag, Float64Base.listFromBase64(s) ?? kEmptyDoubleList);

  /// Creates an [ODtag] from a [Uint8List].
  static ODtag fromBytes(Tag tag, Uint8List bytes) => (OD.isNotValidTag(tag))
      ? null
      : new ODtag._(tag, Float64Base.listFromBytes(bytes) ?? kEmptyDoubleList);

  static ODtag fromBD(BDElement bd) =>
      (OD.isNotValidTag(bd.tag)) ? null : new ODtag._(bd.tag, bd.values);
}
