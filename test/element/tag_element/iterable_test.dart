//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'iterable_test.dart', level: Level.info);

  group('Iterable', () {
    const intList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    final intIterable = intList.map<int>((i) => i);
    final int32List = Int32List.fromList(intList);

    test('integer Iterable', () {
      log.debug('intList isIterable: ${intList is Iterable}');
      expect(intList is Iterable, true);
      log.debug('intIterable isIterable: ${intIterable is Iterable}');
      expect(intIterable is Iterable, true);
      log.debug('int32List isIterable: ${int32List is Iterable}');
      expect(int32List is Iterable, true);
    });

    const floatList = <double>[
      0.9,
      1.9,
      2.9,
      3.9,
      4.9,
      5.9,
      6.9,
      7.9,
      8.9,
      9.9
    ];
    test('float Iterable', () {
      final floatIterable = floatList.map<double>((n) => n);
      final float32List = Float32List.fromList(floatList);

      log.debug('Before: ${float32List.runtimeType}: $float32List');
      expect(float32List is Iterable, true);

      final float0 = toFloat32(float32List);
      log.debug(' After: ${float0.runtimeType}: $float0');
      expect(float0 is Float32List, true);

      log.debug('Before: ${floatList.runtimeType}: $floatList');
      final float1 = toFloat32(floatList);
      log.debug(' After: ${float1.runtimeType}: $float1');
      expect(float1 is Float32List, true);
      expect(float1 is List<double>, true);

      log.debug('Before: ${floatIterable.runtimeType}: $floatIterable');
      final float2 = toFloat32(floatIterable);
      log.debug(' After: ${float2.runtimeType}: $float2');
      expect(float2 is Float32List, true);
      expect(float2 is List<double>, true);
      expect(float2 is Iterable, true);
    });

    test('sum', () {
      // Simple test of
      final a = sum(intList);
      log.debug('intList sum: a: $a');
      expect(a, equals(intList.reduce((c, d) => c + d)));

      final tda = sum(int32List);
      log.debug('Int32List sum: a: $tda');
      expect(tda, equals(int32List.reduce((c, d) => c + d)));

      final b = sum(intIterable);
      log.debug('intIterable sum: b: $b');
      expect(b, equals(int32List.reduce((c, d) => c + d)));

      var c = 0;
      for (final i in intList) c += i;
      log.debug('intList for-in: c: $c');
      expect(c, equals(intList.reduce((c, d) => c + d)));

      var d = 0;
      for (final i in intIterable) d += i;
      log.debug('intIterable for-in: d: $d');
      expect(d, equals(intIterable.reduce((a, b) => a + b)));

      var e = 0;
      for (var i = 0; i < intList.length; i++) e += i;
      log.debug('intList for-in: e: $e');
      expect(e, equals(intList.reduce((a, b) => a + b)));

      var f = 0;
      for (var i = 0; i < intIterable.length; i++) f += i;
      log.debug('intIterable for-in: f: $f');
      expect(e, equals(intIterable.reduce((a, b) => a + b)));
    });
  });
}

int sum(Iterable<int> list) => list.fold(0, (total, v) => total + v);

Float32List toFloat32(Iterable<double> vList, {bool asView = true}) {
  if (vList is Float32List) return vList;
  log.debug('Not Float32List');
  if (vList is List<double>) return Float32List.fromList(vList);
  log.debug('Not List<double>');
  final list = Float32List(vList.length);
  var i = 0;
  for (final v in vList) {
    list[i++] = v;
  }
  log.debug('Iterable');
  return list;
}
