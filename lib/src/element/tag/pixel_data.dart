//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:convert' as cvt;
import 'dart:typed_data';

import 'package:core/src/base.dart';
import 'package:core/src/element/base/integer/integer.dart';
import 'package:core/src/element/base/integer/integer_mixin.dart';
import 'package:core/src/element/base/integer/pixel_data.dart';
import 'package:core/src/element/base/vf_fragments.dart';
import 'package:core/src/element/tag/tag_element.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/value/uid.dart';
import 'package:core/src/vr.dart';

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
      [int vfLengthField, VFFragments fragments, TransferSyntax ts]) {
    final bytes = Uint8.fromList(vList, asView: true);
    return fromUint8List(tag, bytes, vfLengthField, fragments, ts);
  }

  OBtagPixelData._(
      this.tag, this.values, this.vfLengthField, this.ts, this.fragments);

  @override
  OBtagPixelData update([Iterable<int> vList = kEmptyIntList]) =>
      new OBtagPixelData(tag, vList, vfLength, fragments, ts);

  static OBtagPixelData make(Tag tag, Iterable<int> vList) =>
      new OBtagPixelData(tag, vList, vList.length);

  static OBtagPixelData fromBase64(Tag tag, String base64,
          [int vfLengthField, VFFragments fragments, TransferSyntax ts]) =>
      fromUint8List(
          tag, cvt.base64.decode(base64), vfLengthField, fragments, ts);

  /// Creates an [OBtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  static OBtagPixelData from(IntBase e, [TransferSyntax ts]) =>
      fromBytes(e.tag, e.vfBytes, e.vfLengthField, e.fragments, ts);

  /// Creates an [OBtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  static OBtagPixelData fromBytes(Tag tag, Bytes bytes,
      [int vfLengthField, VFFragments fragments, TransferSyntax ts]) {
    vfLengthField ??= bytes.lengthInBytes;
    if (!Tag.isValidVR(tag, kOBIndex))
      return invalidTagError(tag, OBtagPixelData);
    final vflf = _checkVFL(bytes.lengthInBytes, vfLengthField);
    return new OBtagPixelData._(tag, bytes.asUint8List(), vflf, ts, fragments);
  }

  /// Creates an [OBtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  static OBtagPixelData fromUint8List(Tag tag, Uint8List bytes,
      [int vfLengthField, VFFragments fragments, TransferSyntax ts]) {
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
      [VFFragments fragments, TransferSyntax ts]) {
    final bytes = Uint8.fromList(vList, asView: true);
    return fromUint8List(tag, bytes, vfLengthField, fragments, ts);
  }

  UNtagPixelData._(
      this.tag, this.values, this.vfLengthField, this.fragments, this.ts);

  @override
  UNtagPixelData update([Iterable<int> vList = kEmptyIntList]) =>
      new UNtagPixelData(tag, vList, vfLength, fragments, ts);

  static UNtagPixelData make(Tag tag, Iterable<int> vList) =>
      new UNtagPixelData(tag, vList, vList.length);

  static UNtagPixelData fromBase64(Tag tag, String base64, int vfLengthField,
          [VFFragments fragments, TransferSyntax ts]) =>
      fromUint8List(
          tag, cvt.base64.decode(base64), vfLengthField, fragments, ts);

  /// Creates an [OBtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  static UNtagPixelData from(IntBase e, [TransferSyntax ts]) =>
      fromBytes(e.tag, e.vfBytes, e.vfLengthField, e.fragments, ts);

  /// Creates an [UNtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  static UNtagPixelData fromBytes(Tag tag, Bytes bytes,
  [int vfLengthField, VFFragments fragments, TransferSyntax ts]) {
    if (!Tag.isValidVR(tag, kUNIndex))
      return invalidTagError(tag, UNtagPixelData);
    final vflf = _checkVFL(bytes.lengthInBytes, vfLengthField);
    return new UNtagPixelData._(tag, bytes.asUint8List(), vflf, fragments, ts);
  }

  /// Creates an [UNtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  static UNtagPixelData fromUint8List(
      Tag tag, Uint8List bList, int vfLengthField,
      [VFFragments fragments, TransferSyntax ts]) {
    if (!Tag.isValidVR(tag, kUNIndex))
      return invalidTagError(tag, UNtagPixelData);
    final vflf = _checkVFL(bList.lengthInBytes, vfLengthField);
    return new UNtagPixelData._(tag, bList, vflf, fragments, ts);
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
          [int vfLengthField, VFFragments fragments, TransferSyntax ts]) =>
      _fromList(tag, vList, vfLengthField, fragments, ts);

  OWtagPixelData._(
      this.tag, this.values, this.vfLengthField, this.fragments, this.ts);

  @override
  OWtagPixelData update([Iterable<int> vList = kEmptyIntList]) =>
      new OWtagPixelData(tag, vList, vfLength, fragments, ts);

  static OWtagPixelData _fromList(Tag tag, List<int> vList,
      [int vfLengthField, VFFragments fragments, TransferSyntax ts]) {
    if (_isNotValidTag(tag, kOWIndex)) return null;
    final td = Uint16.fromList(vList);
    final vflf = _getVFLF(td.lengthInBytes, vfLengthField);
    return new OWtagPixelData._(tag, td, vflf, fragments, ts);
  }

  /// Creates an [OWtagPixelData] Element from a [Iterable<int>].
  static OWtagPixelData make(Tag tag, Iterable<int> vList) =>
      new OWtagPixelData(tag, vList, vList.length);

  /// Creates an [OWtagPixelData] Element from a [BASE64] [String].
  static OWtagPixelData fromBase64(Tag tag, String base64,
          [int vfLengthField, VFFragments fragments]) =>
      fromUint8List(tag, cvt.base64.decode(base64), vfLengthField);

  /// Creates an [OBtagPixelData] Element from a [Uint8List].
  /// Returns a [Uint16List].
  static OWtagPixelData from(IntBase e, [TransferSyntax ts]) =>
      fromBytes(e.tag, e.vfBytes, e.vfLengthField, e.fragments, ts);

  /// Creates an [OWtagPixelData] Element from a [Uint8List].
  static OWtagPixelData fromBytes(Tag tag, Bytes bytes,
      [int vfLengthField, VFFragments fragments, TransferSyntax ts]) {
    if (_isNotValidTag(tag, kOWIndex)) return null;
    final vList = bytes.asUint16List();
    final vflf = _getVFLF(vList.lengthInBytes, vfLengthField);
    return new OWtagPixelData._(tag, vList, vflf, fragments, ts);
  }

  /// Creates an [OWtagPixelData] Element from a [Uint8List].
  static OWtagPixelData fromUint8List(
      Tag tag, Uint8List bytes, int vfLengthField,
      [VFFragments fragments, TransferSyntax ts]) {
    if (_isNotValidTag(tag, kOWIndex)) return null;
    final vList = Uint16.fromUint8List(bytes);
    final vflf = _getVFLF(vList.lengthInBytes, vfLengthField);
    return new OWtagPixelData._(tag, vList, vflf, fragments, ts);
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
