//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

void main(List<String> args) {
  const repetitions = 1024 * 64;

  const length = 512;
  final timer = Stopwatch()..start();

  int start;
  int end;
  int v;

  // Uint8List
  final uint8List = Uint8List(length);
  start = timer.elapsedMicroseconds;
  for (var j = 0; j < repetitions; j++) {
    for (var k = 0; k < length; k++) v = uint8List[k];
  }
  end = timer.elapsedMicroseconds;
  final time0 = end - start;


  // ByteData
  final bd = ByteData(length);
  start = timer.elapsedMicroseconds;
  for (var j = 0; j < repetitions; j++) {
    for (var k = 0; k < length; k++) v = bd.getUint8(k);
  }
  end = timer.elapsedMicroseconds;
  final time1 = end - start;

  print('v: $v');
  assert(v == 0);

  print('read uint8 $time0 bd $time1 ratio ${time1 / time0}');
}
