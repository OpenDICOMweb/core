//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

void main() {
  final list = <int>[1, -1, 2, -2, 3, -3];

  final i = list.fold<int>(0, ( i,  n) {
      print('i = $i');
      return (n.isNegative) ? i + 1 : i;
  });
  print('last: $i');
}

