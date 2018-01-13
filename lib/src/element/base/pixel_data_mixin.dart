// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See /[package]/AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/element/base/integer.dart';
import 'package:core/src/element/vf_fragments.dart';
import 'package:core/src/system/system.dart';
import 'package:core/src/uid/well_known/transfer_syntax.dart';
import 'package:tag/tag.dart';


abstract class PixelDataMixin {
  Iterable<int> get values;
  TransferSyntax get ts;
  VFFragments get fragments;
  Tag get tag;

  /// Returns _true_ if encapsulated (i.e. compressed).
  bool get isCompressed => fragments != null;

  bool get isEncapsulated => isCompressed;

  Uint32List get offsets => _offsets ??= (fragments == null) ? null : fragments.offsets;
  Uint32List _offsets;

  Uint8List get bulkdata => fragments.bulkdata;

  static bool isValidTag(Tag tag) {
    if (tag == PTag.kPixelData) return true;
    if (throwOnError) return invalidTagError(tag);
    return false;
  }
}

abstract class Uint8PixelDataMixin {
  Iterable<int> get values;
  bool get isEncapsulated;
  VFFragments get fragments;

  Uint8List get valuesCopy => new Uint8List.fromList(pixels);

  /// The [Uint8List] of pixels, possibly compressed.
  Uint8List get pixels =>
      _pixels ??= (isEncapsulated) ? fragments.bulkdata : Uint8Base.toUint8List(values);
  Uint8List _pixels;
}

abstract class Uint16PixelDataMixin {
  Iterable<int> get values;
  bool get isEncapsulated;
  VFFragments get fragments;

  Uint16List get valuesCopy => new Uint16List.fromList(pixels);

  /// The [Uint16List] of pixels, possibly compressed.
  Uint16List get pixels =>
      _pixels ??= (isEncapsulated) ? fragments.bulkdata : Uint16Base.toUint16List(values);
  Uint16List _pixels;
}
