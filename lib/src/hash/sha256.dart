// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/integer/integer.dart';
import 'package:crypto/crypto.dart';

/// SHA-256 Cryptographic Hash Functions

// Enhancement: Add methods for all TypedData if needed for performance.

List<V> _trim<V>(List<V> vList, List<V> vHash) =>
    (vList.length > vHash.length) ? vHash : vHash.sublist(0, vList.length);

/// SHA-256 hash function Message [Digest]s.
/// See https://tools.ietf.org/html/rfc6234

/// Returns a Message [Digest] from a [List<int>].
Uint8List uint8(List<int> v) => sha256.convert(v).bytes;

/// Returns a Message [Digest] from a [List<int>].
Uint16List uint16(List<int> v) => _trim(v, uint8(v).buffer.asUint16List());

/// Returns a Message [Digest] from a [List<int>].
Uint32List uint32(List<int> v) => _trim(v, uint8(v).buffer.asUint32List());

/// Returns a Message [Digest] from a [List<int>].
Int16List int16(List<int> v) => _trim(v, uint8(v).buffer.asInt16List());

/// Returns a Message [Digest] from a [List<int>].
Int32List int32(List<int> v) => _trim(v, uint8(v).buffer.asInt32List());

/// Returns a Message [Digest] from a [List<int>].
Int64List int64(List<int> v) => _trim(v, uint8(v).buffer.asInt64List());

/// Returns a Message [Digest] from a [List<double>].
Float32List float32(List<double> v) {
  final v32 = (v is Float32List) ? v : new Float32List.fromList(v);
  return _trim(v, uint8(v32.buffer.asUint8List()).buffer.asFloat32List());
}

/// Returns a Message [Digest] from a [List<double>].
Float64List float64(List<double> v) {
  final v64 = (v is Float64List) ? v : new Float64List.fromList(v);
  return _trim(v, uint8(v64.buffer.asUint8List()).buffer.asFloat64List());
}

final _sha256Buffer = new Uint64List(8);

/// Returns a 63-bit (SMI) integer, extracted from a SHA256 digest.
int int63(int value) {
  // Urgent: what should [offset] be to make this effective
  const offset = 1;
  _sha256Buffer[offset] = value;
  final bytes = _sha256Buffer.buffer.asUint8List();
  final hash = uint8(bytes);
  final bd = hash.buffer.asByteData();
  final v = bd.getUint64(0);
  return (v & kDartMaxSMUint);
}

/// Returns a [String] that is a hash of [String].
String string(String s) => fromString(s);

/// Returns a Message [Digest] from a [List<String>].
List<String> stringList(List<String> sList) => <String>[fromString(sList.join())];

/// Returns a Message [Digest] from a [String].
//TODO: finish doc
String fromString(String s) {
  final len = s.length;
  final v = sha256.convert(s.codeUnits).toString();
  return v.substring(0, (v.length > len ? len : v.length));
}
