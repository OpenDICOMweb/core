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

    // Bytes
    final bytes = Bytes(length);
    start = timer.elapsedMicroseconds;
    for (var j = 0; j < repetitions; j++) {
      for (var k = 0; k < length; k++) {
        bytes[k] = 1;
        v = bytes[k];
      }
    }
    end = timer.elapsedMicroseconds;
    final time2 = end - start;
    total2 += time2;

    // Bytes bd
    start = timer.elapsedMicroseconds;
    for (var j = 0; j < repetitions; j++) {
      for (var k = 0; k < length; k++) {
        bytes.setUint8(k, 1);
        v = bytes.getUint8(k);
      }
    }
    end = timer.elapsedMicroseconds;
    final time3 = end - start;
    total3 += time3;

    assert(v == 1);

    print('$i\t$length\tuint8\t$time0\tbd $time1'
        '\tbytes[]\t$time2\tbytes*\t$time3'
        '\tratio ${time1 / time0}\t${time2 / time0}\t${time3 / time0}');

    length *= 2;
  }
  print('store then read\n\t\tuint8\t$total0\tbd0 $total1'
      '\tbytes[]\t$total2\tbytes*\t$total3'
      '\tratio\t${total1 / total0}\t${total2 / total0}\t${total3 / total0}');
}
