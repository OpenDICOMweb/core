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
  const loops = 12;
  const repetitions = 1024 * 8;

  int start;
  int end;
  var total0 = 0;
  var total1 = 0;
  int v;

  var length = 4;
  final timer = Stopwatch()..start();

  for (var i = 0; i < loops; i++) {
    // Uint8List
    final uint8List = Uint8List(length);
    start = timer.elapsedMicroseconds;
    for (var j = 0; j < repetitions; j++) {
      for (var k = 0; k < length; k++) {
        uint8List[k] = 1;
        v = uint8List[k];
      }
    }
    end = timer.elapsedMicroseconds;
    final time0 = end - start;
    total0 += time0;

    // ByteData
    final bd = ByteData(length);
    start = timer.elapsedMicroseconds;
    for (var j = 0; j < repetitions; j++) {
      for (var k = 0; k < length; k++) {
        bd.setUint8(k, 1);
        v = bd.getUint8(k);
      }
    }
    end = timer.elapsedMicroseconds;
    final time1 = end - start;
    total1 += time1;

    print('$i $length uint8 $time0 bd $time1 ratio ${time1 / time0}');

    assert(v == 1);
    length *= 2;
  }
  print('store then read $total0 bd0 $total1 ratio ${total1 / total0}');
}
