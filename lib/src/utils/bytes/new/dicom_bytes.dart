//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
part of odw.sdk.utils.bytes;

abstract class DicomLEBytes extends LEBytes with DicomMixin {
  /// Returns a
  DicomLEBytes([int length]) : super._(length);

  DicomLEBytes._(int length) : super._(length);

  DicomLEBytes._from(LEBytes bytes, int start, int length)
      : super._from(bytes, start, length);

  DicomLEBytes.fromList(List<int> list) : super.fromList(list);

  DicomLEBytes._tdView(TypedData td, int offset, int lengthInBytes)
      : super._tdView(td, offset, lengthInBytes);
}

abstract class DicomGrowableLEBytes extends LEBytes
    with DicomMixin, GrowableMixin {
  /// The upper bound on the length of this [Bytes]. If [limit]
  /// is _null_ then its length cannot be changed.
  @override
  final int limit;

  /// Returns a new [Bytes] of [length].
  DicomGrowableLEBytes([int length, this.limit = kDefaultLimit])
      : super._(length);

  /// Returns a new [Bytes] of [length].
  DicomGrowableLEBytes._(int length, this.limit) : super._(length);

  DicomGrowableLEBytes._from(Bytes bytes, int offset, int length,
      [this.limit = kDefaultLimit])
      : super._from(bytes, offset, length);

  DicomGrowableLEBytes._tdView(
      TypedData td, int offset, int lengthInBytes, this.limit)
      : super._tdView(td, offset, lengthInBytes);
}

/// Checks the Value Field length.
bool _checkVFLengthField(int vfLengthField, int vfLength) {
  if (vfLengthField != vfLength && vfLengthField != kUndefinedLength) {
    log.warn('** vfLengthField($vfLength) != vfLength($vfLength)');
    if (vfLengthField == vfLength + 1) {
      log.warn('** vfLengthField: Odd length field: $vfLength');
      return true;
    }
    return false;
  }
  return true;
}



