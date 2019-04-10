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
  const repetitions = 1024 * 16;

  int start;
  int end;
  var total0 = 0;
  var total1 = 0;

  var length = 4;
  final timer = Stopwatch()..start();

  for (var i = 0; i < loops; i++) {
    start = timer.elapsedMicroseconds;
    for (var j = 0; j < repetitions; j++) Uint8List(length);

    end = timer.elapsedMicroseconds;
    // assert(uint8List.length == length, true);
    final time0 = end - start;
    total0 += time0;

    start = timer.elapsedMicroseconds;
    for (var j = 0; j < repetitions; j++) ByteData(length);

    end = timer.elapsedMicroseconds;
    // assert(bd0.lengthInBytes == length, true);

    final time1 = end - start;
    total1 += time0;
    print('$i $length uint8: $time0 bd0: $time1 ratio ${time1 / time0}');

    length *= 2;
  }
  print('create: $total0 bd0: $total1 ratio ${total1 / total0}');
}
