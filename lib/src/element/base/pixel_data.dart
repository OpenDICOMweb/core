// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/src/element/base/integer.dart';
import 'package:core/src/element/base/pixel_data_mixin.dart';

/* Flush at V.0.9.0
bool _inRange(int v, int min, int max) => v >= min && v <= max;

bool _isValidVFLength(int vfl, int min, int max, int sizeInBytes) =>
    _inRange(vfl, min, max) && (vfl % sizeInBytes == 0);
*/

int _toLength(int length, int vLength) =>
    (length == null || length > vLength) ? vLength : length;

abstract class OBPixelData extends OB with PixelDataMixin, Uint8PixelDataMixin {
/*
  // Overridden to ensure that it is a [Uint8List].
  @override
  Uint8List get valuesCopy => new Uint8List.fromList(pixels);

  /// The [Uint8List] of pixels, possibly compressed.
  @override
  Uint8List get pixels =>
      _pixels ??= (isEncapsulated) ? fragments.bulkdata : Uint8Base.toUint8List(values);
  Uint8List _pixels;
*/

  /// Returns an Uint8List View of [values].
  @override
  OBPixelData view([int start = 0, int length]) => super.view(start, length);

  // static bool isValidTag(Tag tag) => _isValidTag(tag);
}

abstract class UNPixelData extends UN with PixelDataMixin, Uint8PixelDataMixin {
  /// Returns an Uint8List View of [values].
  @override
  UNPixelData view([int start = 0, int length]) =>
      update(typedData.buffer.asUint8List(start, _toLength(length, values.length)));
}

abstract class OWPixelData extends OW with PixelDataMixin, Uint16PixelDataMixin {
/*
  // Overridden to ensure that it is a [Uint16List].
  @override
  Uint16List get valuesCopy => new Uint16List.fromList(pixels);

  /// The [Uint16List] of pixels, possibly compressed.
  @override
  Uint16List get pixels =>
      _pixels ??= (isEncapsulated) ? fragments.bulkdata : Uint16Base.toUint16List(values);
  Uint16List _pixels;
*/

  /// Returns a  an Uint8List View of [values].
  @override
  OWPixelData view([int start = 0, int length]) =>
      update(typedData.buffer.asUint16List(start, _toLength(length, values.length)));

  // static bool isValidTag(Tag tag) => _isValidTag(tag);
}
