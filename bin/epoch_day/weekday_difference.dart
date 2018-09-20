//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//


void main() {
  const data = <List<int>>[
// -    Sun Mon Tue Wed Thu Fri Sat
/*Sun*/ [0, 6, 5, 4, 3, 2, 1],
/*Mon*/ [1, 0, 6, 5, 4, 3, 2],
/*Tue*/ [2, 1, 0, 6, 5, 4, 3],
/*Wed*/ [3, 2, 1, 0, 6, 5, 4],
/*Thu*/ [4, 3, 2, 1, 0, 6, 5],
/*Fri*/ [5, 4, 3, 2, 1, 0, 6],
/*Sat*/ [6, 5, 4, 3, 2, 1, 0]
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
	final n = x - y;
	final v = (n >= 0 && n <= 6) ? n : n + 7;
	print('  x: $x, y: $y, n: $n');
	print('  v: $v');
	return v;
}


