// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/base.dart';
import 'package:core/src/element/base.dart';
import 'package:core/src/element/tag/tag_element.dart';
import 'package:core/src/tag/tag.dart';
import 'package:core/src/utils/bytes.dart';


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

  factory FLtag.fromBytes(Tag tag, Bytes bytes) =>
      (FL.isNotValidTag(tag)) ? null : new FLtag._(tag, bytes.asFloat32List());

  factory FLtag.bulkdata(Tag tag, Uri url) =>
      new FLtag._(tag, new FloatBulkdataRef(tag.code, url));

  FLtag._(this.tag, this.values);

  @override
  FLtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      new FLtag(tag, vList);

  static FLtag make(Tag tag, Iterable<double> vList) =>
      new FLtag(tag, vList ?? kEmptyDoubleList);

  static FLtag fromBase64(Tag tag, String s) =>
      new FLtag.fromBytes(tag, Bytes.base64Decode(s));

  static FLtag fromUint8List(Tag tag, Uint8List bList) =>
      new FLtag.fromBytes(tag, new Bytes.fromTypedData(bList));
  
  static FLtag from(Element e) => new FLtag.fromBytes(e.tag, e.vfBytes);
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

  factory OFtag.fromBytes(Tag tag, Bytes bytes) =>
      (OF.isNotValidTag(tag)) ? null : new OFtag._(tag, bytes.asFloat32List());

  factory OFtag.bulkdata(Tag tag, Uri url) =>
      new OFtag._(tag, new FloatBulkdataRef(tag.code, url));

  OFtag._(this.tag, this.values);

  @override
  OFtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      new OFtag(tag, vList);

  static OFtag make(Tag tag, Iterable<double> vList) =>
      new OFtag(tag, vList ?? kEmptyDoubleList);

  static OFtag fromBase64(Tag tag, String s) =>
      new OFtag.fromBytes(tag, Bytes.base64Decode(s));
  
  static OFtag fromUint8List(Tag tag, Uint8List bList) =>
      new OFtag.fromBytes(tag, new Bytes.fromTypedData(bList));

  static OFtag from(Element e) => new OFtag.fromBytes(e.tag, e.vfBytes);
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

  factory FDtag.fromBytes(Tag tag, Bytes bytes) =>
      (FD.isNotValidTag(tag)) ? null : new FDtag._(tag, bytes.asFloat64List());

  factory FDtag.bulkdata(Tag tag, Uri url) =>
      new FDtag._(tag, new FloatBulkdataRef(tag.code, url));

  FDtag._(this.tag, this.values);

  @override
  FDtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      new FDtag(tag, vList);

  static FDtag make(Tag tag, Iterable<double> vList) =>
      new FDtag(tag, vList ?? kEmptyDoubleList);

  static FDtag fromBase64(Tag tag, String s) =>
      new FDtag.fromBytes(tag, Bytes.base64Decode(s));
  
  static FDtag fromUint8List(Tag tag, Uint8List bList) =>
      new FDtag.fromBytes(tag, new Bytes.fromTypedData(bList));

  static FDtag from(Element e) => new FDtag.fromBytes(e.tag, e.vfBytes);
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

  factory ODtag.bulkdata(Tag tag, Uri url) =>
      new ODtag._(tag, new FloatBulkdataRef(tag.code, url));

  factory ODtag.fromBytes(Tag tag, Bytes bytes) =>
      (OD.isNotValidTag(tag)) ? null : new ODtag._(tag, bytes.asFloat64List());

  ODtag._(this.tag, this.values);

  @override
  ODtag update([Iterable<double> vList = kEmptyDoubleList]) =>
      new ODtag(tag, vList);

  static ODtag make(Tag tag, Iterable<double> vf) =>
      new ODtag(tag, Float64.fromValueField(vf));

  static ODtag fromBase64(Tag tag, String s) =>
      new ODtag.fromBytes(tag, Bytes.base64Decode(s));
  
  static ODtag fromUint8List(Tag tag, Uint8List bList) =>
      new ODtag.fromBytes(tag, new Bytes.fromTypedData(bList));

  static ODtag from(Element e) => new ODtag.fromBytes(e.tag, e.vfBytes);
}
