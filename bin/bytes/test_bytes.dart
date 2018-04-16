//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//


import 'package:core/core.dart';
import 'package:test/test.dart';

void main(List<String> args) {

  const count = 12;

  for (var i = 0; i < count; i++) {
    final a = new Bytes(count);

    assert(a.length == count, isTrue);
    for (var i = 0; i < count; i++) {
      a[i] = count;
      assert(a[i] == count, true);
  assert(a.getUint8(i) == count, true);
    }
    for (var i = 0; i < count; i++) assert(a[i] == count, true);
    for (var i = 0; i < count; i++) {
      a[i] = count + 1;
      a[i] == count + 1;
    }
    for (var i = 0; i < count; i++) {
      assert(a.getUint8(i) == a[i], true);
    }
  }
}
