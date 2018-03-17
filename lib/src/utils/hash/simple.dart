// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

/// A simple set of hash functions for creating hashCodes.
/// The 32-bit hash mask.
const int _k32BitHashMask = 0x1fffffff;

// Jenkins hash functions - from quiver package on Pub.
int _combine32(int hash, int value) {
  var h = _k32BitHashMask & (hash + value);
  h = _k32BitHashMask & (h + ((0x0007ffff & h) << 10));
  return h ^ (h >> 6);
}

int _finish32(int hash) {
  var h = _k32BitHashMask & (hash + ((0x03ffffff & hash) << 3));
  h = h ^ (h >> 11);
  return _k32BitHashMask & (h + ((0x00003fff & h) << 15));
}

/// Generates a hash code for one object.
int hash(Object o) => _finish32(_combine32(0, o.hashCode));

/// Generates a hash code for two objects.
int hash2(Object o0, Object o1) =>
    _finish32(_combine32(_combine32(0, o0.hashCode), o1.hashCode));

/// Generates a hash code for three objects.
int hash3(Object o0, Object o1, Object o2) => _finish32(
    _combine32(_combine32(_combine32(0, o0.hashCode), o1.hashCode), o2.hashCode));

/// Generates a hash code for four objects.
int hash4(Object o0, Object o1, Object o2, Object o3) => _finish32(_combine32(
    _combine32(_combine32(_combine32(0, o0.hashCode), o1.hashCode), o2.hashCode),
    o3.hashCode));

int hashList<T>(List<T> vList) {
  const hash = 0;
  for (var i = 0; i < vList.length; i++) {
    _combine32(hash, vList[i].hashCode);
  }
  return _finish32(hash);
}
