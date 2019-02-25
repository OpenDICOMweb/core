//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/src/utils/bytes/bytes.dart';

void main(List<String> args) {

  final floats = <double>[0, 1, 2, 3];
  final fl32List0 =  Float32List.fromList(floats);
  final fl32Bytes0=  Bytes.typedDataView(fl32List0);
  assert(fl32Bytes0.getFloat32(0) == fl32List0[0]);
  assert(fl32Bytes0.getFloat32(4) == fl32List0[1]);
  assert(fl32Bytes0.getFloat32(8) == fl32List0[2]);
  assert(fl32Bytes0.getFloat32(12) == fl32List0[3]);

  //  final fl32List1 =
  final fl32List1 = fl32Bytes0.asFloat32List();

  for (var i = 0; i < fl32List0.length; i++)
    assert(fl32List0[i] == fl32List1[i]);

  // Unaligned
  final fl32b =  Bytes(20)
  ..setFloat32(2, floats[0])
  ..setFloat32(6, floats[1])
  ..setFloat32(10, floats[2])
  ..setFloat32(14, floats[3]);
  assert(fl32b.getFloat32(2) == fl32List0[0]);
  assert(fl32b.getFloat32(6) == fl32List0[1]);
  assert(fl32b.getFloat32(10) == fl32List0[2]);
  assert(fl32b.getFloat32(14) == fl32List0[3]);

  final fl32List3 = fl32b.getFloat32List(2, 4);

  for (var i = 0; i < fl32List0.length; i++)
    assert(fl32List0[i] == fl32List3[i]);


/*
  final float64 =  Float64List.fromList(floats);
  final fl64List0 =  Bytes.fromTypedData(float32);
  final fl64a =  Bytes(fl64List0.lengthInBytes);
  final fl64List1 = fl64a.asFloat64List();

*/

}



