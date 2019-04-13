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
  int v;

  print('Create, Store, then Read: ${DateTime.now()}');
  var length = 4;
  final timer = Stopwatch()..start();

  for (var i = 0; i < loops; i++) {
    // Uint8List
    start = timer.elapsedMicroseconds;
    for (var j = 0; j < repetitions; j++) {
      final uint8List = Uint8List(length);
      for (var k = 0; k < length; k++) {
        uint8List[k] = 1;
        v = uint8List[k];
      }
    }
    end = timer.elapsedMicroseconds;
    final time0 = end - start;
    total0 += time0;

    // ByteData
    start = timer.elapsedMicroseconds;
    for (var j = 0; j < repetitions; j++) {
      final bd = ByteData(length);
      for (var k = 0; k < length; k++) {
        bd.setUint8(k, 1);
        v = bd.getUint8(k);
      }
    }
    end = timer.elapsedMicroseconds;
    final time1 = end - start;
    total1 += time1;

    // Bytes[]
    start = timer.elapsedMicroseconds;
    for (var j = 0; j < repetitions; j++) {
      final bytes = Bytes(length);
      for (var k = 0; k < length; k++) {
        bytes[k] = 1;
        v = bytes[k];
      }
    }
    end = timer.elapsedMicroseconds;
    final time2 = end - start;
    total2 += time2;

    assert(v == 1);

    print('$i\t$length\tuint8\t$time0\tbd\t$time1\tbytes[]\t$time2'
        '\tratio\t${time1 / time0}\t${time2 / time0}');

    length *= 2;
  }

  final total = timer.elapsedMicroseconds;
  print('Total\n\t\t\t\t\tuint8\t$total0\tbd\t$total1\tbytes[]\t$total2'
      '\tratio\t${total1 / total0}\t${total2 / total0}');
  print('Total elapsed us: $total');
}
