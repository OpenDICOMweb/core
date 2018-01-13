// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/src/date_time/age.dart';
import 'package:core/src/element/base/element.dart';
import 'package:core/src/element/base/string.dart';
import 'package:core/src/element/byte_data/bd_element.dart';
import 'package:core/src/element/errors.dart';
import 'package:core/src/element/tag/tag_element_mixin.dart';
import 'package:core/src/empty_list.dart';
import 'package:core/src/tag/tag_lib.dart';

/// A Application Entity Title (AS) Element
class AStag extends AS with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory AStag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (AS.isValidArgs(tag, vList))
          ? new AStag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  AStag._(this.tag, this.values);

  AStag.fromBytes(this.tag, Uint8List bytes) : values = AS.fromBytes(bytes);

  @override
  AStag update([Iterable<String> vList = kEmptyStringList]) =>
      (AS.isValidValues(tag, vList)) ? new AStag(tag, vList) : invalidValuesError(values);

  @override
  AStag updateF(Iterable<String> f(Iterable<String> vList)) => new AStag(tag, f(values));

  static AStag parse(String s, {String onError(String s)}) => new AStag(
      PTag.kPatientAge,
      Age.isValidString(s)
          ? <String>[s]
          : invalidValuesError(<String>[s], tag: PTag.kPatientAge));

  static Element make<String>(Tag tag, Iterable<String> vList) =>
      new AStag(tag, vList ?? kEmptyStringList);

  static AStag fromB64(Tag tag, String base64) =>
      new AStag.fromBytes(tag, BASE64.decode(base64));

  static AStag fromBD(BDElement bd) => new AStag.fromBytes(bd.tag, bd.vfBytes);
}

/// A DICOM Date ([DA]) [Element].
/// TODO: add link to standard
class DAtag extends DA with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory DAtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (DA.isValidArgs(tag, vList))
          ? new DAtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  DAtag._(this.tag, this.values);

  DAtag.fromBytes(this.tag, Uint8List bytes) : values = DA.fromBytes(bytes);

  @override
  DAtag update([Iterable<String> vList = kEmptyStringList]) =>
      (DA.isValidValues(tag, vList)) ? new DAtag(tag, vList) : invalidValuesError(values);
  /*new DAtag(tag, vList ?? kEmptyStringList);*/

  @override
  DAtag updateF(Iterable<String> f(Iterable<String> vList)) => new DAtag(tag, f(values));

  static DAtag fromB64(Tag tag, String base64) =>
      new DAtag.fromBytes(tag, BASE64.decode(base64));

  static DAtag make<String>(Tag tag, Iterable<String> vList) =>
      new DAtag(tag, vList ?? kEmptyStringList);

  static DAtag fromBD(BDElement bd) => new DAtag.fromBytes(bd.tag, bd.vfBytes);
}

/// A DICOM DateTime [DT] [Element].
///
/// A concatenated date-time character string in the format: YYYYMMDDHHMMSS.FFFFFF&ZZXX
class DTtag extends DT with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory DTtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (DT.isValidArgs(tag, vList))
          ? new DTtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  DTtag._(this.tag, this.values);

  DTtag.fromBytes(this.tag, Uint8List bytes) : values = DT.fromBytes(bytes);

  @override
  DTtag update([Iterable<String> vList = kEmptyStringList]) =>
      (DT.isValidValues(tag, vList)) ? new DTtag(tag, vList) : invalidValuesError(values);

  @override
  DTtag updateF(Iterable<String> f(Iterable<String> vList)) => new DTtag(tag, f(values));

  static DTtag fromB64(Tag tag, String base64) =>
      new DTtag.fromBytes(tag, BASE64.decode(base64));

  static DTtag make<String>(Tag tag, Iterable<String> vList) =>
      new DTtag(tag, vList ?? kEmptyStringList);

  static DTtag fromBD(BDElement bd) => new DTtag.fromBytes(bd.tag, bd.vfBytes);
}

/// The DICOM [TM] (Time) [Element].
///
/// [Time] [String]s have the following format: HHMMSS.ffffff.
/// [See PS3.18, TM](http://dicom.nema.org/medical/dicom/current/output/html/part18.html#para_3f950ae4-871c-48c5-b200-6bccf821653b)
class TMtag extends TM with TagElement<String> {
  @override
  final Tag tag;
  @override
  Iterable<String> values;

  factory TMtag(Tag tag, [Iterable<String> vList = kEmptyStringList]) =>
      (TM.isValidArgs(tag, vList))
          ? new TMtag._(tag, vList)
          : invalidValuesError(vList, tag: tag);

  TMtag._(this.tag, this.values);

  TMtag.fromBytes(this.tag, Uint8List bytes) : values = TM.fromBytes(bytes);

  @override
  TMtag update([Iterable<String> vList = kEmptyStringList]) =>
      (TM.isValidValues(tag, vList)) ? new TMtag(tag, vList) : invalidValuesError(values);

  @override
  TMtag updateF(Iterable<String> f(Iterable<String> vList)) => new TMtag(tag, f(values));

  static TMtag fromB64(Tag tag, String base64) =>
      new TMtag.fromBytes(tag, BASE64.decode(base64));

  static TMtag make<String>(Tag tag, Iterable<String> vList) =>
      new TMtag(tag, vList ?? kEmptyStringList);

  static TMtag fromBD(BDElement bd) => new TMtag.fromBytes(bd.tag, bd.vfBytes);
}
