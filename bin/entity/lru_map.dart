// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

//import 'package:test/test.dart';

import 'package:quiver/collection.dart';

void main() {
  final cache = new LruMap<int, String>(maximumSize: 20);
  // print('cache: $cache');
  cache[0] = 'zero';
  print('0: ${cache[0]}');

  //print('keys.length: (${cache.keys.length}');
  //print('keys(${cache.keys}');
  //print('values.length: (${cache.values.length}');
  //print('values(${cache.values}');

  cache[1] = '1';
  print('1: ${cache[1]}');
  cache.putIfAbsent(3, () => 'three');
  print('3: ${cache[3]}');
  cache.putIfAbsent(3, () => '-3');
  print('3: ${cache[3]}');

  cache[1] = null;
  print('1: ${cache[1]}');
  print('length: ${cache.length}');
  //print('cache: $cache');
  print('cache: ${cache.keys}\n ${cache.values}');
}
