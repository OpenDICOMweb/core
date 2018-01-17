// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// SHA-256 Cryptographic Hash Functions

// Enhancement: Add methods for all TypedData if needed for performance.

List<V> _trim<V>(List<V> vList, List<V> vHash) =>
    (vList.length > vHash.length) ? vHash : vHash.sublist(0, vList.length);

/// SHA-256 hash function Message [Digest]s.
/// See https://tools.ietf.org/html/rfc6234
class Sha256<E> {
  /// Returns a Message [Digest] from a [Iterable<int>].
  static Uint8List uint8(Iterable<int> v) => sha256.convert(v).bytes;

  /// Returns a Message [Digest] from a [Iterable<int>].
  static Uint16List uint16(Iterable<int> v) => _trim(v, uint8(v).buffer.asUint16List());

  /// Returns a Message [Digest] from a [Iterable<int>].
  static Uint32List uint32(Iterable<int> v) => _trim(v, uint8(v).buffer.asUint32List());

  /// Returns a Message [Digest] from a [Iterable<int>].
  static Int16List int16(Iterable<int> v) => _trim(v, uint8(v).buffer.asInt16List());

  /// Returns a Message [Digest] from a [Iterable<int>].
  static Int32List int32(Iterable<int> v) => _trim(v, uint8(v).buffer.asInt32List());

  /// Returns a Message [Digest] from a [Iterable<int>].
  static Int64List int64(Iterable<int> v) => _trim(v, uint8(v).buffer.asInt64List());

  /// Returns a Message [Digest] from a [Iterable<double>].
  static Float32List float32(Iterable<double> v) {
    final v32 = (v is Float32List) ? v : new Float32List.fromList(v);
    return _trim(v, uint8(v32.buffer.asUint8List()).buffer.asFloat32List());
  }

  /// Returns a Message [Digest] from a [Iterable<double>].
  static Float64List float64(Iterable<double> v) {
    final v64 = (v is Float64List) ? v : new Float64List.fromList(v);
    return _trim(v, uint8(v64.buffer.asUint8List()).buffer.asFloat64List());
  }

  /// Returns a [String] that is a hash of [String].
  static String string(String s) => fromString(s);

  /// Returns a Message [Digest] from a [Iterable<String>].
  static Iterable<String> stringList(Iterable<String> sList) =>
      <String>[fromString(sList.join())];

  /// Returns a Message [Digest] from a [String].
  //TODO: finish doc
  static String fromString(String s) {
    final len = s.length;
    final v = sha256.convert(s.codeUnits).toString();
    return v.substring(0, (v.length > len ? len : v.length));
  }
}
