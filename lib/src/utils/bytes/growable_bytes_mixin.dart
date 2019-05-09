//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/src/utils/bytes/bytes.dart';
import 'package:core/src/utils/bytes/constants.dart';

/// A mixin that allows [Bytes] to grow incrementally
mixin GrowableBytesMixin {
  /// The upper bound on the length of this [Bytes]. If [limit]
  /// is _null_ then its length cannot be changed.
  int get limit;
  Uint8List get buf;
  set buf(Uint8List list);

  int get length => buf.length;

  set length(int newLength) {
    if (newLength < buf.lengthInBytes) return;
    grow(newLength);
  }

  /// Ensures that [buf] is at least [length] long, and grows
  /// the buf if necessary, preserving existing data.
  bool ensureLength(int length) => _ensureLength(buf, length);

  /// Creates a new buffer of length at least [minLength] in size, or if
  /// [minLength == null, at least double the length of the current buffer;
  /// and then copies the contents of the current buffer into the new buffer.
  /// Finally, the new buffer becomes the buffer for _this_.
  bool grow([int minLength]) {
    final old = buf;
    buf = _grow(old, minLength ??= old.lengthInBytes * 2);
    return buf == old;
  }

  /// Ensures that [list] is at least [minLength] long, and grows
  /// the buf if necessary, preserving existing data.
  static bool _ensureLength(Uint8List list, int minLength) =>
      (minLength > list.lengthInBytes) ? _reallyGrow(list, minLength) : false;
}

/// If [minLength] is less than or equal to the current length of
/// [buf] returns [buf]; otherwise, returns a new [ByteData] with a length
/// of at least [minLength].
Uint8List _grow(Uint8List buf, int minLength) {
  final oldLength = buf.lengthInBytes;
  return (minLength <= oldLength) ? buf : _reallyGrow(buf, minLength);
}

/// Returns a new [ByteData] with length at least [minLength].
Uint8List _reallyGrow(Uint8List buf, int minLength) {
  var newLength = minLength;
  do {
    newLength *= 2;
    if (newLength >= kDefaultLimit) return null;
  } while (newLength < minLength);
  final newBD = Uint8List(newLength);
  for (var i = 0; i < buf.lengthInBytes; i++) newBD[i] = buf[i];
  return newBD;
}
