// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

void main() {
  const test0 = 'aaabbbcccbbbddd';
  const s0 = r'bbb';
  final rexp0 = new RegExp(s0);

  final m = rexp0.firstMatch(test0);

  if (m == null) {
    print('"$s0" not fount');
  } else {
    print('$m');
    print('found "${m.group(0)}"');
  }

  var result = test0.replaceFirst(rexp0, '---');
  print('result: $result');

  result = test0.replaceAll(rexp0, '---');
  print('result: $result');


}
