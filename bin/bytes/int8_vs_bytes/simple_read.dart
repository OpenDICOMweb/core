//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/core.dart';

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
    // Initialization
    final uint8List = Uint8List(length);
//    for (var k = 0; k < length; k++) uint8List[k] = k % 255;
//    assert(uint8List.length == length, true);

    final bytes = Bytes(length);
//    for (var k = 0; k < length; k++) bd.setUint8(k, k % 255);
//    assert(bd.lengthInBytes == length, true);
    // Initialization

    // Warm up
//    for (var k = 0; k < length; k++) final x = uint8List[k];
//    for (var k = 0; k < length; k++) final x = bd.getUint8(k);

    // Test
    start = timer.elapsedMicroseconds;
    for (var j = 0; j < repetitions; j++) {
      for (var k = 0; k < length; k++) v = uint8List[k];
    }
    end = timer.elapsedMicroseconds;

    final time0 = end - start;
    total0 += time0;

    start = timer.elapsedMicroseconds;
    for (var j = 0; j < repetitions; j++) {
      for (var k = 0; k < length; k++) v = bytes[k];
    }
    end = timer.elapsedMicroseconds;
 //   assert(bd.lengthInBytes == length, true);

    final time1 = end - start;
    total1 += time1;
    print('$i $length uint8: $time0 bytes: $time1 ratio ${time1 / time0}');

    length *= 2;
  }
  print('read uint: $total0 bd0: $total1 ratio ${total1 / total0}');
}
