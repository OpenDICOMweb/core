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


  var length = 4;
  final timer = Stopwatch()..start();

  for (var i = 0; i < loops; i++) {
    // Initialization
    final uint8List = Uint8List(length);
    assert(uint8List.length == length, true);
    final bd = ByteData(length);
    assert(bd.lengthInBytes == length, true);

    // Test
    start = timer.elapsedMicroseconds;
    for (var j = 0; j < repetitions; j++) {
      for (var k = 0; k < length; k++) {
        final v = k % 255;
        uint8List[k] = v;
      }
    }
    end = timer.elapsedMicroseconds;

    total0 += end - start;

    start = timer.elapsedMicroseconds;
    for (var j = 0; j < repetitions; j++) {
      for (var k = 0; k < length; k++) {
        final v = k % 255;
        bd.setUint8(k, v);
      }
    }
    end = timer.elapsedMicroseconds;

    total1 += end - start;
 //   print('$i $length uint8: $total0 bd0: $total1 ratio ${total1 / total0}');

    length *= 2;
  }
  final total = timer.elapsedMicroseconds;
  print('store then read: $total0 bd0: $total1 ratio ${total1 / total0}');
  print('total elapsed us: $total');
}
