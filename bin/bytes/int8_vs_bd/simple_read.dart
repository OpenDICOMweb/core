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
  const repetitions = 1024 * 16;

  int start;
  int end;
  var total0 = 0;
  var total1 = 0;
  var total2 = 0;
  var total3 = 0;
  int v;

  var length = 4;
  final timer = Stopwatch()..start();

  for (var i = 0; i < loops; i++) {
    // Uint8List
    final uint8List = Uint8List(length);
    start = timer.elapsedMicroseconds;
    for (var j = 0; j < repetitions; j++) {
      for (var k = 0; k < length; k++) v = uint8List[k];
    }
    end = timer.elapsedMicroseconds;

    final time0 = end - start;
    total0 += time0;

    // ByteData
    final bd = ByteData(length);
    start = timer.elapsedMicroseconds;
    for (var j = 0; j < repetitions; j++) {
      for (var k = 0; k < length; k++) v = bd.getUint8(k);
    }
    end = timer.elapsedMicroseconds;
    assert(bd.lengthInBytes == length, true);

    final time1 = end - start;
    total1 += time1;

    // Bytes[]
    final bytes = Bytes(length);
    start = timer.elapsedMicroseconds;
    for (var j = 0; j < repetitions; j++) {
      for (var k = 0; k < length; k++) v = bytes[k];
    }
    end = timer.elapsedMicroseconds;
    assert(bd.lengthInBytes == length, true);

    final time2 = end - start;
    total2 += time2;

    // Bytes.getUint8()
    start = timer.elapsedMicroseconds;
    for (var j = 0; j < repetitions; j++) {
      for (var k = 0; k < length; k++) v = bytes.getUint8(k);
    }
    end = timer.elapsedMicroseconds;
    assert(bd.lengthInBytes == length, true);

    final time3 = end - start;
    total3 += time3;

    print('$i $length uint8: $time0 bd: $time1 bytes[] $time2 bytes.get()');
    print('ratios: ${time1 / time0} ${time2 / time0} ${time3 / time0}');

    assert(v == 0);
    length *= 2;
  }
  print('read uint: $total0 bd: $total1 bytes[] $total2 bytes*: $total3');
  print('ratio: ${total1 / total0} ${total2 / total0} ${total3 / total0}');
}
