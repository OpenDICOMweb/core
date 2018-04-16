//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

import 'dart:typed_data';

import 'hash.dart';

/// A class implementing a 32-bit Jenkins hash
class Hash32 extends Hash {
  /// The 32-bit hash seed
  static const int k32BitHashSeed = 17;
  /// The 32-bit hash mask.
  static const int k32BitHashMask = 0x1fffffff;

  /// The hash seed for any newly created [Hash] [Object]s.
  @override
  final int seed;

  /// Creates a new [Hash32] object.
  const Hash32([this.seed = k32BitHashSeed]);

  // Jenkins hash functions - from quiver package on Pub.
  @override
  int combine(int hash, int value) {
    var h = k32BitHashMask & (hash + value);
    h = k32BitHashMask & (h + ((0x0007ffff & h) << 10));
    return h ^ (h >> 6);
  }

  @override
  int finish(int hash) {
    var h = k32BitHashMask & (hash + ((0x03ffffff & hash) << 3));
    h = h ^ (h >> 11);
    return k32BitHashMask & (h + ((0x00003fff & h) << 15));
  }

  /// Returns the 32-bit [hash] of a [double].
  @override
  double doubleHash(double n) => _float32Hash(n);

  /// A constant hash function.
  static const Hash32 hash = const Hash32(Hash.kHashSeed);

  static double floatHash(double n) => hash.doubleHash(n);

  static int k1(Object o) => hash.n1(o);

  /// Generates a hash code for two objects.
  static int k2(Object o0, Object o1) => hash.n2(o0, o1);

  /// Generates a hash code for three objects.
  static int k3(Object o0, Object o1, Object o2) => hash.n3(o0, o1, o2);

  /// Generates a hash code for four objects.
  static int k4(Object o0, Object o1, Object o2, Object o3) =>
      hash.n4(o0, o1, o2, o3);

  /// Generates a hash code for four objects.
  static int k5(Object o0, Object o1, Object o2, Object o3, Object o4) =>
      hash.n5(o0, o1, o2, o3, o4);

  /// Generates a hash code for multiple [objects].
  static int list(Iterable<Object> objects) => hash.nList(objects);
}

//final _byteBuf = new ByteData(4);
final _float32Buf = new Float32List(1);
final Uint32List _uint32Buf = _float32Buf.buffer.asUint32List();


double _float32Hash(double n) {
  _float32Buf[0] = n;
  _uint32Buf[0] = Hash32.k1(_uint32Buf[0]);
  return _float32Buf[0];
}
