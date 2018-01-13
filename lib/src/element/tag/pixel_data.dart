// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:core/src/element/base/integer.dart';
import 'package:core/src/element/base/pixel_data.dart';
import 'package:core/src/element/tag/tag_element_mixin.dart';
import 'package:core/src/element/vf_fragments.dart';
import 'package:core/src/tag/tag.dart';

/// Returns [vfLengthField] is it is valid.
int _checkVFL(Uint8List bytes, int vfLengthField) =>
    (vfLengthField == kUndefinedLength || vfLengthField == bytes.length)
        ? vfLengthField
        : null;

/// 8-bit Pixel Data.
/// If encapsulated (compressed) then [fragments] must not be _null_. If
/// [fragments] == _null_ then the pixels are uncompressed and data is
/// contained in [values] or [vfBytes].
class OBtagPixelData extends OBPixelData with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;
  @override
  final int vfLengthField;
  @override
  final TransferSyntax ts;
  @override
  final VFFragments fragments;

  /// Creates an [OBtagPixelData] Element from a [Iterable<int>] of byte values (0 - 255).
  OBtagPixelData(Tag tag, Iterable<int> vList, this.vfLengthField,
      [this.ts, this.fragments])
      : tag = (Tag.isValidVR(tag, OB.kVRIndex)) ? tag : invalidTagError(tag),
        values = vList ?? kEmptyIntList;

  /// Creates an [OBtagPixelData] Element from a [Uint8List]. Returns a [Uint16List].
  OBtagPixelData.fromBytes(Tag tag, Uint8List bytes, int vfLengthField,
      [this.ts, this.fragments])
      : tag = (Tag.isValidVR(tag, OB.kVRIndex)) ? tag : invalidTagError(tag),
        // ignore: prefer_initializing_formals
        values = bytes,
        vfLengthField = _checkVFL(bytes, vfLengthField);

  factory OBtagPixelData.fromBase64(Tag tag, String base64, int vfLengthField,
          [TransferSyntax ts, VFFragments fragments]) =>
      new OBtagPixelData.fromBytes(
          tag, BASE64.decode(base64), vfLengthField, ts, fragments);

  @override
  OBtagPixelData update([Iterable<int> vList = kEmptyIntList]) =>
      new OBtagPixelData(tag, vList, vfLength, ts, fragments);

  @override
  OBtagPixelData updateF(Iterable<int> f(Iterable<int> vList)) =>
      new OBtagPixelData(tag, f(values), vfLength, ts, fragments);

  static OBtagPixelData make(Tag tag, Iterable<int> vList) =>
      new OBtagPixelData(tag, vList, vList.length);

  static OBtagPixelData fromB64(Tag tag, String s, int vfLengthField,
          [TransferSyntax ts, VFFragments fragments]) =>
      new OBtagPixelData.fromBytes(tag, BASE64.decode(s), vfLengthField, ts, fragments);
}

/// 8-bit Pixel Data.
/// If encapsulated (compressed) then [fragments] must not be _null_. If
/// [fragments] == _null_ then the pixels are uncompressed and data is
/// contained in [values] or [vfBytes].
class UNtagPixelData extends UNPixelData with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;
  @override
  final int vfLengthField;
  @override
  final TransferSyntax ts;
  @override
  final VFFragments fragments;

  /// Creates an [UNtagPixelData] Element from a [Iterable<int>] of byte values (0 - 255).
  UNtagPixelData(Tag tag, Iterable<int> vList, this.vfLengthField,
      [this.ts, this.fragments])
      : tag = (Tag.isValidVR(tag, UN.kVRIndex)) ? tag : invalidTagError(tag),
        values = vList ?? kEmptyIntList;

  /// Creates an [UNtagPixelData] Element from a [Uint8List]. Returns a [Uint16List].
  UNtagPixelData.fromBytes(Tag tag, Uint8List bytes, int vfLengthField,
      [this.ts, this.fragments])
      : tag = (Tag.isValidVR(tag, UN.kVRIndex)) ? tag : invalidTagError(tag),
        // ignore: prefer_initializing_formals
        values = bytes,
        vfLengthField = _checkVFL(bytes, vfLengthField);

  factory UNtagPixelData.fromBase64(Tag tag, String base64, int vfLengthField,
          [TransferSyntax ts, VFFragments fragments]) =>
      new UNtagPixelData.fromBytes(
          tag, BASE64.decode(base64), vfLengthField, ts, fragments);

  @override
  UNtagPixelData update([Iterable<int> vList = kEmptyIntList]) =>
      new UNtagPixelData(tag, vList, vfLength, ts, fragments);

  @override
  UNtagPixelData updateF(Iterable<int> f(Iterable<int> vList)) =>
      new UNtagPixelData(tag, f(values), vfLength, ts, fragments);

  static UNtagPixelData make(Tag tag, Iterable<int> vList) =>
      new UNtagPixelData(tag, vList, vList.length);

  static UNtagPixelData fromB64(Tag tag, String s, int vfLengthField,
          [TransferSyntax ts, VFFragments fragments]) =>
      new UNtagPixelData.fromBytes(tag, BASE64.decode(s), vfLengthField, ts, fragments);
}

/// 8-bit Pixel Data.
/// If encapsulated (compressed) then [fragments] must not be _null_. If
/// [fragments] == _null_ then the pixels are uncompressed and data is
/// contained in [values] or [vfBytes].
class OWtagPixelData extends OWPixelData with TagElement<int> {
  @override
  final Tag tag;
  @override
  Iterable<int> values;
  @override
  final int vfLengthField;
  @override
  final TransferSyntax ts;
  @override
  final VFFragments fragments;

  /// Creates an [OWtagPixelData] Element from a [Iterable<int>] of byte values (0 - 255).
  OWtagPixelData(Tag tag, Iterable<int> vList,
      [this.vfLengthField, this.ts, this.fragments])
      : tag = (Tag.isValidVR(tag, OW.kVRIndex)) ? tag : invalidTagError(tag),
        values = vList ?? kEmptyIntList;

  /// Creates an [OWtagPixelData] Element from a [Uint8List]. Returns a [Uint16List].
  OWtagPixelData.fromBytes(Tag tag, Uint8List bytes, int vfLengthField,
      [this.ts, this.fragments])
      : tag = (Tag.isValidVR(tag, OW.kVRIndex)) ? tag : invalidTagError(tag),
        values = Uint16Base.listFromBytes(bytes),
        vfLengthField = _checkVFL(bytes, vfLengthField);

  factory OWtagPixelData.fromBase64(Tag tag, String base64, int vfLengthField,
          [VFFragments fragments]) =>
      new OWtagPixelData.fromBytes(tag, BASE64.decode(base64), vfLengthField);

  @override
  OWtagPixelData update([Iterable<int> vList = kEmptyIntList]) =>
      new OWtagPixelData(tag, vList, vfLength, ts, fragments);

  @override
  OWtagPixelData updateF(Iterable<int> f(Iterable<int> vList)) =>
      new OWtagPixelData(tag, f(values), vfLength, ts, fragments);

  static OWtagPixelData make(Tag tag, Iterable<int> vList) =>
      new OWtagPixelData(tag, vList, vList.length);

  static OWtagPixelData fromB64(Tag tag, String s, int vfLengthField,
          {VFFragments fragments}) =>
      new OWtagPixelData.fromBytes(tag, BASE64.decode(s), vfLengthField);
}
