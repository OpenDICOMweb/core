// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'hash.dart';

/// A class implementing a 64-bit Jenkins hash
class Hash64 extends Hash {
  /// The 64-bit hash mask.
  // TODO: pick a larger hash seed = odd number > 0xFFFFFFFF
  static const int k64BitHashSeed = Hash.kHashSeed;
  /// The 64-bit hash mask.
  static const int k64BitHashMask = 0x1fffffffffffffff;

  /// The hash seed for any newly created [Hash] [Object]s.
  @override
  final int seed;

  /// Creates a new [Hash64] object.
  const Hash64([this.seed = k64BitHashSeed]);

  // Jenkins hash functions - from quiver package on Pub.
  @override
  int combine(int hash, int value) {
    var h = k64BitHashMask & (hash + value);
    h = k64BitHashMask & (h + ((0x0007ffff & h) << 10));
    return h ^ (h >> 6);
  }

  @override
  int finish(int hash) {
    var h = k64BitHashMask & (hash + ((0x03ffffffffffffff & hash) << 3));
    h = h ^ (h >> 11);
    return k64BitHashMask & (h + ((0x00003fffffffffff & h) << 15));
  }

  /// Returns the 64-bit [hash] of a [double].
  @override
  double doubleHash(double n) => _float64Hash(n);

  /// A constant hash function.
  static const Hash64 hash = const Hash64(Hash.kHashSeed);


  /// Returns the [hash] of a [double].
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

  /// Generates a hash code for [ByteData].
  static int bd(ByteData bd) => hash.byteData(bd);
}

final _byteBuf = new ByteData(8);
final _float64Buf = _byteBuf.buffer.asFloat64List();
final _uint64Buf = _byteBuf.buffer.asUint64List();


double _float64Hash(double n) {
  _float64Buf[0] = n;
  _uint64Buf[0] = Hash64.k1(_uint64Buf[0]);
  return _float64Buf[0];
}