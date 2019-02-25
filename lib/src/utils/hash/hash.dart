//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

// ignore_for_file: public_member_api_docs

/// A class implementing a 32-bit Jenkins hash
abstract class Hash {
  /// An untested hash seed.
  static const int kHashSeed = 17;

  /// Creates a new [Hash] object.
  const Hash();

  /// The hash seed for any newly created [Hash] [Object]s.
  int get seed;

  int combine(int seed, int hashCode);
  int finish(int hash);

  int _hash(int hash, Object o) => finish(combine(kHashSeed, o.hashCode));

  /// Returns a [hashCode] for 1 object.
  int call(Object o) => _hash(kHashSeed, o.hashCode);

  /// Returns the hash of a [double].
  double doubleHash(double n);

  int n1(Object o) => _hash(kHashSeed, o.hashCode);

  /// Generates a hash code for two objects.
  int n2(Object o0, Object o1) =>
      finish(combine(combine(0, o0.hashCode), o1.hashCode));

  /// Generates a hash code for three objects.
  int n3(Object o0, Object o1, Object o2) => finish(combine(
      combine(combine(0, o0.hashCode), o1.hashCode), o2.hashCode));

  /// Generates a hash code for four objects.
  int n4(Object o0, Object o1, Object o2, Object o3) => finish(combine(
      combine(
          combine(combine(0, o0.hashCode), o1.hashCode), o2.hashCode),
      o3.hashCode));

  /// Generates a hash code for four objects.
  int n5(Object o0, Object o1, Object o2, Object o3, Object o4) =>
      finish(combine(
          combine(
              combine(combine(combine(kHashSeed, o0.hashCode), o1.hashCode),
                             o2.hashCode),
              o3.hashCode),
          o4.hashCode));

  /// Generates a hash code for multiple [objects].
  int nList(Iterable<Object> objects) {
    if (objects == null) throw ArgumentError('Invalid null argument');
    return finish(
        objects.fold(kHashSeed, (h, o) => combine(h, o.hashCode)));
  }

  /// Generates a hash code for multiple [vList].
  int intList(Iterable<int> vList) {
    if (vList == null) throw ArgumentError('Invalid null argument');
    var seed = kHashSeed;
    for(final i in vList) seed = combine(seed, i);
    return finish(seed);
  }

  /// Generates a hash code for [ByteData].
  int byteData(ByteData bd) {
    if (bd == null) throw ArgumentError('Invalid null argument');

    var seed = kHashSeed;
    for(var i = bd.offsetInBytes; i < bd.lengthInBytes; i++)
      seed = combine(seed, bd.getUint8(i));
    return finish(seed);
  }
}

