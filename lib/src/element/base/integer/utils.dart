//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/error/element_errors.dart';
import 'package:core/src/utils/bytes.dart';
import 'package:core/src/utils/primitives.dart';

Bytes asBytes(TypedData td) {
  if (td == null) return null;
  if (td.lengthInBytes == 0) return kEmptyBytes;
  return new Bytes.typedDataView(td);
}

Uint8List asUint8List(TypedData td) {
  if (td == null) return null;
  if (td.lengthInBytes == 0) return kEmptyUint8List;
  return td.buffer.asUint8List(td.offsetInBytes, td.lengthInBytes);
}

/// Returns a [ByteData] created from [td];
ByteData asByteData(TypedData td) {
  if (td == null) return null;
  if (td.lengthInBytes == 0) return kEmptyByteData;
  return td.buffer.asByteData(td.offsetInBytes, td.lengthInBytes);
}

List<int> copyList(List<int> vList, List<int> td, int min, int max) {
  assert(td is TypedData);
  assert(vList.length == td.length);
  for (var i = 0; i < vList.length; i++) {
    final v = vList[i];
    if (v < min || v > max) return badValues(vList);
    td[i] = v;
  }
  return td;
}
