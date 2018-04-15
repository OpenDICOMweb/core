//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/src/element/base/integer/integer.dart';
import 'package:core/src/element/base/integer/integer_mixin.dart';
import 'package:core/src/element/base/vf_fragments.dart';
import 'package:core/src/tag.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/value/uid.dart';

/// PixelDataMixin class
abstract class PixelData {
  Tag get tag;
  int get code;
  int get vfLengthField;
  Bytes get vfBytes;

  /// Returns the [VFFragments] for this Element, if any; otherwise,
  /// returns _null_.  Only kPixelData Elements can have [fragments].
  VFFragments get fragments;

  /// The [List<int>] of pixels.
  List<int> get pixels;
  TransferSyntax get ts;

  int get vfOffset => ts.isEvr ? 12 : 8;

  /// Returns _true_ if encapsulated (i.e. compressed).
  bool get isCompressed => fragments != null;

  bool get isEncapsulated => isCompressed;

  Uint32List get offsets =>
      _offsets ??= (fragments == null) ? null : fragments.offsets;
  Uint32List _offsets;

  Uint8List get bulkdata => fragments.bulkdata;
}

abstract class Uint8PixelDataMixin {
  Iterable<int> get values;
  bool get isEncapsulated;
  VFFragments get fragments;

  Uint8List get valuesCopy => new Uint8List.fromList(pixels);

  /// The [Uint8List] of pixels, possibly compressed.
  Uint8List get pixels => _pixels ??=
      (isEncapsulated) ? fragments.bulkdata : Uint8.fromList(values);
  Uint8List _pixels;
}

abstract class Uint16PixelDataMixin {
  Iterable<int> get values;
  bool get isEncapsulated;
  VFFragments get fragments;

  Uint16List get valuesCopy => new Uint16List.fromList(pixels);

  /// The [Uint16List] of pixels, possibly compressed.
  Uint16List get pixels => _pixels ??=
      (isEncapsulated) ? fragments.bulkdata : Uint16.fromList(values);
  Uint16List _pixels;
}

abstract class OBPixelData extends IntBase
    with
        OBMixin,
        Uint8,
        PixelData,
        Uint8PixelDataMixin {}

abstract class UNPixelData extends IntBase
    with
        UNMixin,
        Uint8,
        PixelData,
        Uint8PixelDataMixin {}

abstract class OWPixelData extends IntBase
    with
        OWMixin,
        Uint16,
        PixelData,
        Uint16PixelDataMixin {}
