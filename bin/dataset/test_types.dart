//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//


void main() {

  //  bool test(List v) => (v is List<int>) ? true : false;
    bool test(List v) => (v is List<int>) ? true : false;
    final intList = [1, 2, 3];
    final floatList = <double>[1.1, 2.2, 3.3];

    var r = test(intList);
    print('intList: $r');
     r = test(floatList);
    print('floatList: $r');

}

