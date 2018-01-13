// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/server.dart';
import 'package:test/test.dart';

final RNG rng = new RNG(0);

/// Returns a new [ByteData] that is a copy of [bd].
ByteData bdCopy(ByteData bd) {
final copy = new ByteData(bd.lengthInBytes);
for (var i = 0; i < bd.lengthInBytes; i++) copy.setUint8(i, bd.getUint8(i));
return copy;
}

//Urgent: test hash
void main() {
  Server.initialize(name: 'integer/integer_test', level: Level.info);
  /*
  print('32: ${hash(32)}');
  print('33: ${hash(33)}');
  print('hash2(32, 32) = ${hash2(32, 32)}');
  print('hash(32) = ${Hash.hash(32)}');
  print('hash(33) = ${Hash.hash(33)}');
  print('hash(3.2) = ${Hash.hash(3.2)}');
  print('hash(3.4) = ${Hash.hash(3.4)}');
  print('hash('32') = ${Hash.hash('32')}');
  print('hash('33') = ${Hash.hash('33')}');
  //hash64Test();
  // hash32Test();
  */
  float32HashTest();

  float64HashTest();

  test('BD hash', () {
    final bd0 = rng.byteDataList(0, 255, 10,10);
    final bd1 = bdCopy(bd0);
    final bd2 = rng.byteDataList(  0, 255, 10,10);
    final h0 = Hash64.bd(bd0);
    final h1 = Hash64.bd(bd1);
    final h2 = Hash64.bd(bd2);

    print('0: $bd0 h0: $h0');
    print('1: $bd1 h1: $h1');
    print('2: $bd2 h2: $h2');
/*    final u80 = bd0.buffer.asUint8List();
    final u81 = bd1.buffer.asUint8List();
    final u82 = bd2.buffer.asUint8List();

    print('0: $u80 h0: $h0');
    print('1: $u81 h1: $h1');
    print('2: $u82 h2: $h2');
*/
    
  });
}

void hash64Test() {
  test('Hash64.n1', () {});
}

void hash32Test() {
  test('Hash32.n1', () {});
}

void float32HashTest() {
  test('Hash32.floatHash', () {
    for(var i = 0; i < 1000; i++) {
      final n = rng.nextDouble;
      final h = Hash64.floatHash(n);
      print('n: $n h: $h');
      assert(n != h);
    }
  });
}

void float64HashTest() {
  test('Hash64.floatHash', () {
    for(var i = 0; i < 1000; i++) {
      final n = rng.nextDouble;
      final h = Hash64.floatHash(n);
      print('n: $n h: $h');
      assert(n != h);
    }
  });
}
