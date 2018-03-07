// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/base.dart';
import 'package:core/src/dataset/base/dataset.dart';
import 'package:core/src/dataset/base/ds_bytes.dart';
import 'package:core/src/element/base.dart';

/// Sequence Items
abstract class Item extends Dataset {
  @override
  final Dataset parent;

  /// The Sequence that contains this Item.
  SQ sequence;

  @override
  IDSBytes dsBytes;

  Item(this.parent, this.sequence, ByteData bd) : dsBytes = new IDSBytes(bd);

  /// The the Value Field Length of the encoded object (e.g. ByteData,
  /// JSON [String]...) that _this_was created from, or
  /// _null_ if _this_was not created by parsing an encoded object.
  ///
  /// _Note_: The [vfLengthField] might have a value of [kUndefinedLength],
  /// which means the length of the Value Field must be determined by
  /// parsing.
  int get vfLengthField => dsBytes.vfLengthField;

  /// The actual length of the Value Field for _this_
  int get vfLength => dsBytes.vfLength;

  /// Returns _true_ if [vfLengthField] equals[kUndefinedLength].
  bool get hasULength => vfLengthField == kUndefinedLength;

  /// _Deprecated_: Use [sequence] = [sq] instead.
  @deprecated
  void addSQ(SQ sq) {
    assert(sq is SQ && sq != null);
    sequence = sq;
  }

  /// Sets [dsBytes] to the empty list.
  IDSBytes clearDSBytes() {
    final dsb = dsBytes;
    dsBytes = IDSBytes.kEmpty;
    return dsb;
  }
}

