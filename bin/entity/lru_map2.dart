// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

//import 'package:test/test.dart';

import 'package:quiver/collection.dart';

void main() {
  final cache = new LruMap<int, String>(maximumSize: 5);
  print('keys: (${cache.keys})');
  print('values: (${cache.values})');
  print('cache: $cache');

  cache[0] = 'zero';
  print('0: ${cache[0]}');
  //print('keys: (${cache.keys})');
  //print('values: (${cache.values})');

  cache[1] = 'one';
  print('1: ${cache[1]}');
  cache.keys.forEach(print);

  cache[2] = 'two';
  print('2: ${cache[2]}');
  //print('keys: (${cache.keys})');
  //print('values: (${cache.values})');

  cache.putIfAbsent(3, () => 'three');
  print('3: ${cache[3]}');
  //print('keys: (${cache.keys})');
  //print('values: (${cache.values})');

  cache.putIfAbsent(3, () => '-three');
  print('3: ${cache[3]}');
  //print('keys: (${cache.keys})');
  //print('values: (${cache.values})');

  cache[1] = null;
  print('1: ${cache[1]}');
  //print('keys: (${cache.keys})');
  //print('values: (${cache.values})');

  cache.remove(2);
  print('2: $cache[2');
  print('keys: (${cache.keys})');
  print('values: (${cache.values})');
}
