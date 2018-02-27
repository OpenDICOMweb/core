// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:core/src/element/base/float.dart';
import 'package:core/src/element/errors.dart';
import 'package:core/src/element/tag/tag_element.dart';
import 'package:core/src/tag/tag.dart';

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

  factory FLtag._fromBytes(Tag tag, Uint8List bytes) =>
      (FL.isNotValidTag(tag)) ? null : new FLtag._(tag, _f32FromBytes(bytes));

  factory FLtag.bulkdata(Tag tag, String url) =>
      new FLtag._(tag, new FloatBulkdata(tag.code, url));

  FLtag._(this.tag, this.values);

  @override
  FLtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      new FLtag(tag, vList);

  static FLtag make(Tag tag, Iterable<double> vList) =>
      new FLtag(tag, vList ?? kEmptyDoubleList);

  static FLtag fromBase64(Tag tag, String s) =>
      new FLtag._fromBytes(tag, BASE64.decode(s));

  static FLtag fromBytes(Tag tag, Uint8List bytes) =>
      new FLtag._fromBytes(tag, bytes);

  static FLtag fromBDE(Element e) => new FLtag._fromBytes(e.tag, e.vfBytes);
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
          : invalidValuesError(vList, tag: tag);

  factory OFtag._fromBytes(Tag tag, Uint8List bytes) =>
      (OF.isNotValidTag(tag)) ? null : new OFtag._(tag, _f32FromBytes(bytes));

  factory OFtag.bulkdata(Tag tag, String url) =>
      new OFtag._(tag, new FloatBulkdata(tag.code, url));

  OFtag._(this.tag, this.values);

  @override
  OFtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      new OFtag(tag, vList);

  static OFtag make(Tag tag, Iterable<double> vList) =>
      new OFtag(tag, vList ?? kEmptyDoubleList);

  static OFtag fromBase64(Tag tag, String s) =>
      new OFtag._fromBytes(tag, BASE64.decode(s));

  static OFtag fromBytes(Tag tag, Uint8List bytes) =>
      new OFtag._fromBytes(tag, bytes);

  static OFtag fromBDE(Element e) => new OFtag._fromBytes(e.tag, e.vfBytes);
}

Float32List _f32FromBytes(Uint8List bytes) => Float32Mixin.fromBytes(bytes);

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

  factory FDtag._fromBytes(Tag tag, Uint8List bytes) =>
      (FD.isNotValidTag(tag)) ? null : new FDtag._(tag, _f64FromBytes(bytes));

  factory FDtag.bulkdata(Tag tag, String url) =>
      new FDtag._(tag, new FloatBulkdata(tag.code, url));

  FDtag._(this.tag, this.values);

  @override
  FDtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      new FDtag(tag, vList);

  static FDtag make(Tag tag, Iterable<double> vList) =>
      new FDtag(tag, vList ?? kEmptyDoubleList);

  static FDtag fromBase64(Tag tag, String s) =>
      new FDtag._fromBytes(tag, BASE64.decode(s));

  static FDtag fromBytes(Tag tag, Uint8List bytes) =>
      new FDtag._fromBytes(tag, bytes);

  static FDtag fromBDE(Element e) => new FDtag._fromBytes(e.tag, e.vfBytes);
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

  factory ODtag.bulkdata(Tag tag, String url) =>
      new ODtag._(tag, new FloatBulkdata(tag.code, url));

  factory ODtag._fromBytes(Tag tag, Uint8List bytes) =>
      (OD.isNotValidTag(tag)) ? null : new ODtag._(tag, _f64FromBytes(bytes));

  ODtag._(this.tag, this.values);

  @override
  ODtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      new ODtag(tag, vList);

  static ODtag make(Tag tag, Iterable<double> vList) =>
      new ODtag(tag, vList ?? kEmptyDoubleList);

  static ODtag fromBase64(Tag tag, String s) =>
      new ODtag._fromBytes(tag, BASE64.decode(s));

  static ODtag fromBytes(Tag tag, Uint8List bytes) =>
      new ODtag._fromBytes(tag, bytes);

  static ODtag fromBDE(Element e) => new ODtag._fromBytes(e.tag, e.vfBytes);
}

Float64List _f64FromBytes(Uint8List bytes) => Float64Mixin.fromBytes(bytes);
