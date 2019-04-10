//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

// Some tests to understand Iterable<V>.

void main() {
  const intList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  final intIterable = intList.map<int>((i) => i);
  final int32List = Int32List.fromList(intList);

  print('intList isIterable: ${intList is Iterable}');
  print('intIterable isIterable: ${intIterable is Iterable}');
  print('int32List isIterable: ${int32List is Iterable}');

  const floatList = <double>[
    0.9, 1.9, 2.9, 3.9, 4.9, 5.9, 6.9, 7.9, 8.9, 9.9 // No Reformat
  ];
  final floatIterable = floatList.map<double>((n) => n);
  final float32List = Float32List.fromList(floatList);

  print('Before: ${float32List.runtimeType}: $float32List');
  var test = toFloat32(float32List);
  print(' After: ${test.runtimeType}: $test');

  print('Before: ${floatList.runtimeType}: $floatList');
  test = toFloat32(floatList);
  print(' After: ${test.runtimeType}: $test');

  print('Before: ${floatIterable.runtimeType}: $floatIterable');
  test = toFloat32(floatIterable);
  print(' After: ${test.runtimeType}: $test');

//  test = toFloat32(int32List);

  for (final i in int32List) print('i: $i');

// throws
//  final int16List = Int16List.fromList(intIterable);

  // Simple test of
  final a = sum(intList);
  print('intList sum: a: $a');
  final tda = sum(int32List);
  print('Int32List sum: a: $tda');

  final b = sum(intIterable);
  print('intIterable sum: b: $b');

  var c = 0;
  for (final i in intList) c += i;
  print('intList for-in: c: $c');

  var d = 0;
  for (final i in intIterable) d += i;
  print('intIterable for-in: d: $d');

  var e = 0;
  for (var i = 0; i < intList.length; i++) e += i;
  print('intList for-in: e: $e');

  var f = 0;
  for (var i = 0; i < intIterable.length; i++) f += i;
  print('intIterable for-in: f: $f');

/* Throws
  List<int> vList;
  vList = intIterable;
  print('vList: $vList');
*/

  final dynList0 = <Object>[];

/* Throws an error
  for (var i = 0; i < 10; i++) dynList0.add(i);
  print('dynList0 for-in: dynList0: $dynList0');
*/

  // Throws an error
  final dynList1 = increment(dynList0);
  print('dynList1 Increment: dynList0: $dynList1');
}

int sum(Iterable<int> list) => list.fold(0, (total, v) => total + v);

Iterable increment<V>(Iterable<V> list) =>
    list.map<Object>((v) => (v is int) ? v + 1 : v);

Float32List toFloat32(Iterable<double> vList, {bool asView = true}) {
  if (vList is Float32List) return vList;
  print('Not Float32List');
  if (vList is List<double>) return Float32List.fromList(vList);
  print('Not List<double>');
  final list = Float32List(vList.length);
  var i = 0;
  for (final v in vList) {
    list[i++] = v;
  }
  print('Iterable');
  return list;
}
