//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

void main() {

   typeTest();
   listIntTest();

}

void typeTest() {
  print('\ntypeTest:');
  var foo = [1.1, '"a"'];
  print('  foo@1 type: ${foo.runtimeType}');
  final List<double> bar = foo;
  var b = foo is List<double>;
  print('  foo@2 type: ${foo.runtimeType}');
  print('  foo is double: $b');
  b = bar is List<double>;
  print('  bar is double: $b');
  print('  bar: $bar');
  try {
    for (var v in foo) {
      if (v is! double) {
        print('    Not double: $v');
        throw TypeError();
      }
    }
    // ignore: avoid_catching_errors
  } on TypeError {
    print('  caught TypeError');
  }
  final doubles = foo;
  foo = doubles;
  final x = foo is List<double>;
  print('  x is List<double>: $x');
}

bool isListIntType(List v) => v is List<int>;

bool isListInt(List vList) {
  for (var v in vList) if (v is! int) return false;
  return true;
}

void coerceToInt(List<int> vList) {
  for (var i = 0; i < vList.length; i++) {
    final v = vList[i];
    vList[i] = v;
  }
}

final List intList = <int>[1, 2, 3];
final List badIntList = <Object>[1, 2, '"3"'];

void listIntTest() {
  print('\nlistIntTest:');
  var good = isListInt(intList);
  print('  intList type: ${intList.runtimeType}');
  print('  intList: $intList - $good');
  final bad = isListInt(badIntList);
  print('  badIntList: $badIntList - $bad');
  coerceToInt(intList);
  good = isListInt(intList);
  print('  coerceToInt: $intList - $good');
}
