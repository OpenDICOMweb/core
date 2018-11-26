// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.
import 'dart:typed_data';

mixin BytesGetters {
  ByteData get bd;

// **** TypedData interface.
  int get elementSizeInBytes => 1;

  int get offset => bdOffset;

  int get bdOffset => bd.offsetInBytes;

  int get length => bdLength;

  int get bdLength => bd.lengthInBytes;

  set length(int length) =>
      throw UnsupportedError('$runtimeType: length is not modifiable');

  int get limit => bdLength;

  ByteBuffer get buffer => bd.buffer;
}