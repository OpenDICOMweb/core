//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//

//TODO: Merge with hash.dart or flush

/// Hash functions for creating hashCodes.

///  Thomas Wang
int hash32(int i) {
  var v = i;
  v = (i + 0x7ed55d16) + (i << 12);
  v = (i ^ 0xc761c23c) ^ (i >> 19);
  v = (i + 0x165667b1) + (i << 5);
  v = (i + 0xd3a2646c) ^ (i << 9);
  v = (i + 0xfd7046c5) + (i << 3);
  v = (i ^ 0xb55a4f09) ^ (i >> 16);
  return v;
}

/// Returns a 64-bit hash code for [i].
int hash64(int i) {
  var v = i;
  v = (~i) + (i << 21);
  v = (i << 21) - i - 1;
  v = i ^ (i >> 24);
  v = (i + (i << 3)) + (i << 8);
  v = i * 265;
  v = i ^ (i >> 14);
  v = (i + (i << 2)) + (i << 4);
  v = i * 21;
  v = i ^ (i >> 28);
  v = i + (i << 31);
  return v;
}

//TODO: improve usage documentation
/// A Standard [hash] functions.
///
/// THe [Hash] class used to create Hash functions that return [hashCode]s.
///
/// Uses strategy from Effective Java, Chapter 11.
///
/// Example:
///     int get hashCode => hash(part3, hash(part2, hash(part1)));
/// The static methods all use [kHashSeed] and [kHashMultiplier]
class Hash {
  /// The default hash seed. The number used is the 8th Mersenne prime.
  /// See https://en.wikipedia.org/wiki/2147483647_(number).
  static const int kHashSeed = 17;

  /// The default hash multiplier
  static const int kHashMultiplier = 37;

  /// The 32-bit hash mask.
  static const int k32BitHashMask = 0x3FFFFFFF;

  /// The 64-bit hash mask.
  static const int k64BitHashMask = 0x3FFFFFFFFFFFFFFF;

  /// The [mask] used to make the result fit into a 32 or 64 bit SMI.
  final int mask;

  const Hash._(this.mask);

  /// A hasher returning 30-bit integer [hashCode]s.
  static const Hash hash32 = Hash._(k32BitHashMask);

  /// A hasher returning 62-bit integer [hashCode]s.
  static const Hash hash64 = Hash._(k64BitHashMask);

  /// The default hasher.
  static const Hash hash = hash64;

  int _hash(int o, int result) =>
      (kHashMultiplier * result + o.hashCode) & mask;

  /// Returns a [hashCode] for 1 object.
  int call(Object o) => _hash(o.hashCode, kHashSeed);

  /// Returns a [hashCode] for [Object] [o].
  int n1(Object o) => _hash(o.hashCode, kHashSeed);

  /// Returns a [hashCode] for 2 objects.
  int n2(Object o1, Object o2) =>
      _hash(o1.hashCode, _hash(o2.hashCode, kHashSeed));

  /// Returns a [hashCode] for 3 objects.
  int n3(Object o1, Object o2, Object o3) =>
      _hash(o1.hashCode, _hash(o2.hashCode, _hash(o3.hashCode, kHashSeed)));

  /// Returns a [hashCode] for 4 objects.
  int n4(Object o1, Object o2, Object o3, Object o4) => _hash(o1.hashCode,
      _hash(o2.hashCode, _hash(o3.hashCode, _hash(o4.hashCode, kHashSeed))));

  /// Returns a [hashCode] for 5 objects.
  int n5(Object o1, Object o2, Object o3, Object o4, Object o5) => _hash(
      o1.hashCode,
      _hash(
          o2.hashCode,
          _hash(
              o3.hashCode, _hash(o4.hashCode, _hash(o5.hashCode, kHashSeed)))));

  /// Returns a [hashCode] for a [List] of [Object]s.
  int list(List<Object> list) {
    var v = kHashSeed;
    for (var i = 0; i < list.length; i++) v = _hash(list[i], v);
    return v;
  }
}
