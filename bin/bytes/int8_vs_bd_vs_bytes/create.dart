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
  var total2 = 0;

  print('Create: ${DateTime.now()}');
  var length = 4;
  final timer = Stopwatch()..start();

  for (var i = 0; i < loops; i++) {
    // Uint8List
    start = timer.elapsedMicroseconds;
    for (var j = 0; j < repetitions; j++) Uint8List(length);
    end = timer.elapsedMicroseconds;
    final time0 = end - start;
    total0 += time0;

    // ByteData
    start = timer.elapsedMicroseconds;
    for (var j = 0; j < repetitions; j++) ByteData(length);
    end = timer.elapsedMicroseconds;
    final time1 = end - start;
    total1 += time1;

    // Bytes
    start = timer.elapsedMicroseconds;
    for (var j = 0; j < repetitions; j++) ByteData(length);
    end = timer.elapsedMicroseconds;
    final time2 = end - start;
    total2 += time2;

    print('$i length $length uint8 $time0 bd $time1 bytes $time2');
    print('  ratio ${time1 / time0} ${time2 / time0}');

    length *= 2;
  }
  print('create: uint8 $total0 bd $total1 bytes $total2');
  print('  ratio ${total1 / total0} ${total2 / total0}');
}
