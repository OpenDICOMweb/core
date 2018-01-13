// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.


void main() {
  const data = const <List<int>>[
// -    Sun Mon Tue Wed Thu Fri Sat
/*Sun*/ const [0, 6, 5, 4, 3, 2, 1],
/*Mon*/ const [1, 0, 6, 5, 4, 3, 2],
/*Tue*/ const [2, 1, 0, 6, 5, 4, 3],
/*Wed*/ const [3, 2, 1, 0, 6, 5, 4],
/*Thu*/ const [4, 3, 2, 1, 0, 6, 5],
/*Fri*/ const [5, 4, 3, 2, 1, 0, 6],
/*Sat*/ const [6, 5, 4, 3, 2, 1, 0]
  ];

  for (var x = 0; x < 7; x++) {
    for (var y = 0; y < 7; ++y) {
    	final row = data[x];
    	final ex = row[y];
    	print('x: $x, y: $y, expect: $ex');
    	final v = weekdayDifference(x, y);
	    print('  v: $v');
      assert(v == ex);
    }
  }
}

int weekdayDifference(int x, int y) {
	assert(x >= 0 && x <= 6, 'x: $x');
	assert(y >= 0 && y <= 6, 'y: $y');
	final n = (x - y);
	final v = (n >= 0 && n <= 6) ? n : n + 7;
	print('  x: $x, y: $y, n: $n');
	print('  v: $v');
	return v;
}


