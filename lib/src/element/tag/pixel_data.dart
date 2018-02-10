// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:core/src/element/base/integer.dart';
import 'package:core/src/element/base/pixel_data.dart';
import 'package:core/src/element/tag/tag_element.dart';
import 'package:core/src/element/vf_fragments.dart';
import 'package:core/src/empty_list.dart';
import 'package:core/src/tag/constants.dart';
import 'package:core/src/tag/errors.dart';
import 'package:core/src/tag/tag.dart';
import 'package:core/src/uid/well_known/transfer_syntax.dart';
import 'package:core/src/vr/vr.dart';

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

  /// Creates an [OBtagPixelData] Element from a [Iterable<int>]
  /// of byte values (0 - 255).
  factory OBtagPixelData(Tag tag, Iterable<int> vList,
      [int vfLengthField, TransferSyntax ts, VFFragments fragments]) {
    final bytes = Uint8Base.fromList(vList, asView: true);
    return _makeChecking(tag, bytes, vfLengthField, ts, fragments);
  }

  OBtagPixelData._(
      this.tag, this.values, this.vfLengthField, this.ts, this.fragments);

  @override
  OBtagPixelData update([Iterable<int> vList = kEmptyIntList]) =>
      new OBtagPixelData(tag, vList, vfLength, ts, fragments);

/*
  @override
  OBtagPixelData updateF(Iterable<int> f(Iterable<int> vList)) =>
      new OBtagPixelData(tag, f(values), vfLength, ts, fragments);
*/

  static OBtagPixelData make(Tag tag, Iterable<int> vList) =>
      new OBtagPixelData(tag, vList, vList.length);

  static OBtagPixelData fromBase64(Tag tag, String base64,
          [int vfLengthField, TransferSyntax ts, VFFragments fragments]) =>
      _makeChecking(tag, BASE64.decode(base64), vfLengthField, ts, fragments);

  /// Creates an [OBtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  static OBtagPixelData fromBytes(Tag tag, Uint8List bytes,
          [int vfLengthField, TransferSyntax ts, VFFragments fragments]) =>
      _makeChecking(tag, bytes, vfLengthField, ts, fragments);

  static OBtagPixelData _makeChecking(Tag tag, Uint8List bytes,
      [int vfLengthField, TransferSyntax ts, VFFragments fragments]) {
    vfLengthField ??= bytes.lengthInBytes;
    if (!Tag.isValidVR(tag, kOBIndex))
      return invalidTagError(tag, OBtagPixelData);
    final vflf = _checkVFL(bytes.lengthInBytes, vfLengthField);
    return new OBtagPixelData._(tag, bytes, vflf, ts, fragments);
  }
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

  /// Creates an [UNtagPixelData] Element from a [Iterable<int>]
  /// of byte values (0 - 255).
  factory UNtagPixelData(Tag tag, Iterable<int> vList, int vfLengthField,
      [TransferSyntax ts, VFFragments fragments]) {
    final bytes = Uint8Base.fromList(vList, asView: true);
    return _fromBytes(tag, bytes, vfLengthField, ts, fragments);
  }

  UNtagPixelData._(
      this.tag, this.values, this.vfLengthField, this.ts, this.fragments);

  @override
  UNtagPixelData update([Iterable<int> vList = kEmptyIntList]) =>
      new UNtagPixelData(tag, vList, vfLength, ts, fragments);

/*
  @override
  UNtagPixelData updateF(Iterable<int> f(Iterable<int> vList)) =>
      new UNtagPixelData(tag, f(values), vfLength, ts, fragments);
*/

  static UNtagPixelData make(Tag tag, Iterable<int> vList) =>
      new UNtagPixelData(tag, vList, vList.length);

  static UNtagPixelData fromBase64(Tag tag, String base64, int vfLengthField,
          [TransferSyntax ts, VFFragments fragments]) =>
      _fromBytes(tag, BASE64.decode(base64), vfLengthField, ts, fragments);

  /// Creates an [UNtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  static UNtagPixelData fromBytes(Tag tag, Uint8List bytes, int vfLengthField,
          [TransferSyntax ts, VFFragments fragments]) =>
      _fromBytes(tag, bytes, vfLengthField, ts, fragments);

  static UNtagPixelData _fromBytes(
      Tag tag, Uint8List bytes, int vfLengthField,
      [TransferSyntax ts, VFFragments fragments]) {
    if (!Tag.isValidVR(tag, kUNIndex))
      return invalidTagError(tag, UNtagPixelData);
    final vflf = _checkVFL(bytes.lengthInBytes, vfLengthField);
    return new UNtagPixelData._(tag, bytes, vflf, ts, fragments);
  }
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

  /// Creates an [OWtagPixelData] Element from a [Iterable<int>]
  /// of byte values (0 - kMax16BitValue).
  factory OWtagPixelData(Tag tag, Iterable<int> vList,
          [int vfLengthField, TransferSyntax ts, VFFragments fragments]) =>
      _fromList(tag, vList, vfLengthField, ts, fragments);

  OWtagPixelData._(
      this.tag, this.values, this.vfLengthField, this.ts, this.fragments);

  @override
  OWtagPixelData update([Iterable<int> vList = kEmptyIntList]) =>
      new OWtagPixelData(tag, vList, vfLength, ts, fragments);

/*
  @override
  OWtagPixelData updateF(Iterable<int> f(Iterable<int> vList)) =>
      new OWtagPixelData(tag, f(values), vfLength, ts, fragments);
*/
  static OWtagPixelData _fromList(Tag tag, List<int> vList,
      [int vfLengthField, TransferSyntax ts, VFFragments fragments]) {
    if (_isNotValidTag(tag, kOWIndex)) return null;
    final td = Uint16Base.fromList(vList);
    final vflf = _getVFLF(td.lengthInBytes, vfLengthField);
    return new OWtagPixelData._(tag, td, vflf, ts, fragments);
  }

  /// Creates an [OWtagPixelData] Element from a [Iterable<int>].
  static OWtagPixelData make(Tag tag, Iterable<int> vList) =>
      new OWtagPixelData(tag, vList, vList.length);

  /// Creates an [OWtagPixelData] Element from a [BASE64] [String].
  static OWtagPixelData fromBase64(Tag tag, String base64,
          [int vfLengthField, VFFragments fragments]) =>
      _fromBytes(tag, BASE64.decode(base64), vfLengthField);

  /// Creates an [OWtagPixelData] Element from a [Uint8List].
  static OWtagPixelData fromBytes(Tag tag, Uint8List bytes, int vfLengthField,
          [TransferSyntax ts, VFFragments fragments]) =>
      _fromBytes(tag, bytes, vfLengthField, ts, fragments);

  static OWtagPixelData _fromBytes(Tag tag, Uint8List bytes,
      [int vfLengthField, TransferSyntax ts, VFFragments fragments]) {
    if (_isNotValidTag(tag, kOWIndex)) return null;
    final vList = Uint16Base.fromBytes(bytes);
    final vflf = _getVFLF(vList.lengthInBytes, vfLengthField);
    return new OWtagPixelData._(tag, vList, vflf, ts, fragments);
  }
}

bool _isNotValidTag(Tag tag, int vrIndex) {
  if (Tag.isValidVR(tag, vrIndex)) return false;
  invalidTagError(tag, OWtagPixelData);
  return true;
}

int _getVFLF(int vfLength, int vfLengthField) =>
    (vfLengthField == null) ? vfLength : _checkVFL(vfLength, vfLengthField);

/// Returns [vfLengthField] is it is valid.
int _checkVFL(int vfLength, int vfLengthField) =>
    (vfLengthField == kUndefinedLength || vfLengthField == vfLength)
    ? vfLengthField
    : null;


