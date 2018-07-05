// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
//
import 'package:core/core.dart';

void main() {
  const test0 = 'aaabbbcccbbbddd';
  const s0 = r'b';
  final rexp0 = new RegExp(s0);

  final m = rexp0.firstMatch(test0);
  final n = test0.replaceFirst(rexp0, 'X');
  final o = test0.replaceAll(rexp0, 'X');

  print('X: "$test0"');
  if (m == null) {
    print('M "$s0" not fount');
  } else {
    print('M: "$m"');
    print('found "${m.group(0)}"');
  }

  if (n == null) {
    print('N "$s0" not fount');
  } else {
    print('N: "$n"');
    //print('found "${n.group(0)}"');
  }

  if (o == null) {
    print('O "$s0" not fount');
  } else {
    print('O: "$o"');
    //print('found "${n.group(0)}"');
  }

  var result = test0.replaceFirst(rexp0, '---');
  print('result: $result');

  result = test0.replaceAll(rexp0, '---');
  print('result: $result');

  const s1 = r'z';
  final rexp1 = new RegExp(s1);
  final a = replaceFirst(rexp1, 'X', 20);
  print('a: $a');
}

final List<String> values = [
  'aaabbbcccddd',
  'aaabbbcccbbbddd',
  'aaabbbcbcbbbddd'
];

StringList replaceFirst(RegExp from, String to, int maxLength,
    [int startIndex = 0]) {
  // final regex = new RegExp(from);
  final length = values.length;
  final result = new List<String>(length);
  for (var i = 0; i < length; i++) {
    final v = values[i].replaceFirst(from, to, startIndex);
    print('v: "$v"');
    result[i] = (v.length > maxLength) ? v.substring(0, maxLength) : v;
  }
  return result;
}
