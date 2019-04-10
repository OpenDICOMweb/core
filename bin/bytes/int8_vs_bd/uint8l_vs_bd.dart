//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/src/utils/timer.dart';

void main(List<String> args) {
  const shortest = 11;
  const longest = 13;
  const count = 1024;

  final timer = Timer();
  int start0;
  int start1;
  int end0;
  int end1;
  int uintTime;
  int bdTime;
  int create0;
  int create1;
  var length = shortest;

  for (var i = shortest; i < longest; i++) {
    print('\n$i length: $length');

    // Create

    Uint8List uint8List;
    start0 = timer.elapsedMicroseconds;
    for (var j = 0; j < count; j++) {
      uint8List = Uint8List(length);
    }
    end0 = timer.elapsedMicroseconds;
    assert(uint8List.length == length, true);

    ByteData bd0;
    start1 = timer.elapsedMicroseconds;
    for (var j = 0; j < count; j++) {
      bd0 = ByteData(length);
    }
    end1 = timer.elapsedMicroseconds;
    assert(bd0.lengthInBytes == length, true);
    uintTime = end0 - start0;
    bdTime = end1 - start1;
    print('create uint8: $uintTime bd0: $bdTime ratio ${bdTime / uintTime}');

    // Store

    start0 = timer.elapsedMicroseconds;
    for (var j = 0; j < count; j++) {
      for (var i = 0; i < length; i++)
        uint8List[i] = i % 255;
    }
    end0 = timer.elapsedMicroseconds;

    start1 = timer.elapsedMicroseconds;
    for (var j = 0; j < count; j++) {
      for (var i = 0; i < length; i++)
        bd0.setUint8(i, i % 255);
    }
    end1 = timer.elapsedMicroseconds;
    uintTime = end0 - start0;
    bdTime = end1 - start1;
    print(' store uint8: $uintTime bd0: $bdTime ratio ${bdTime / uintTime}');

    start0 = timer.elapsedMicroseconds;
    for (var j = 0; j < count; j++) {
      for (var i = 0; i < length; i++) {
        if (uint8List[i] != i % 255) throw 'unequal error';
      }
    }
    end0 = timer.elapsedMicroseconds;

    start1 = timer.elapsedMicroseconds;
    for (var j = 0; j < count; j++) {
      for (var i = 0; i < length; i++) {
        if (bd0.getUint8(i) != i % 255) throw 'unequal error';
      }
    }
    end1 = timer.elapsedMicroseconds;
    uintTime = end0 - start0;
    bdTime = end1 - start1;
    print('  read uint8: $uintTime bd0: $bdTime ratio ${bdTime / uintTime}');

    // Create Pointer

    ByteData bd1;
    start0 = timer.elapsedMicroseconds;
    for (var j = 0; j < count; j++) {
      bd1 = bd0.buffer.asByteData();
    }
    end0 = timer.elapsedMicroseconds;
    print('share bd0:  ${end0 - start0}');

    length *= 2;
  }
}
