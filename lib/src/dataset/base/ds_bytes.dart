// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/src/empty_list.dart';
import 'package:core/src/tag/constants.dart';

/// Dataset Bytes ([DSBytes]).
abstract class DSBytes {
  // **** Interface ****

  /// The [ByteData] containing this Dataset.
  ByteData get bd;

  /// The index of the first byte of the Dataset in [bd].
  int get dsStart => bd.offsetInBytes;

  /// The number of bytes from the beginning to the end of the Dataset.
  int get dsLength => bd.lengthInBytes;

  /// The index of the last byte of the Dataset in [bd].
  int get dsEnd => dsStart + dsLength;

  /// The length of the entire Dataset including header, trailer, preamble, etc.
  // int get eLength => bd.lengthInBytes;

  /// Returns the length in bytes of the Value Field.
  int get vfLength;

  /// Returns the Value Field Length field, if any.
  int get vfLengthField;

  /// Returns _true_ if the Value Field Length field contained
  /// [kUndefinedLength].
  bool get hasULength => vfLengthField == kUndefinedLength;

  /// The number of bytes from the beginning of the Element to the Value Field.
  int get vfOffset;

  // **** End Interface ****

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is DSBytes) {
      if (dsEnd != other.dsEnd) return false;
      for (var i = 0; i < dsEnd; i++)
        if (bd.getUint8(i) != other.bd.getUint8(i)) return false;
      return true;
    }
    return false;
  }

  @override
  int get hashCode => bd.hashCode;

  /// Returns the Value Field as a [ByteData].
  ByteData get vfByteData => bd;

  /// Returns the Value Field as a [Uint8List].
  Uint8List get vfBytes =>
      bd.buffer.asUint8List(bd.offsetInBytes, bd.lengthInBytes);

  // **** Internal Stuff ****

  /// Return a Uint16 value at [offset].
  int getUint8(int offset) => bd.getUint16(offset);

  /// Return a Uint16 value at [offset].
  int getUint16(int offset) => bd.getUint16(offset, Endianness.LITTLE_ENDIAN);

  /// Return a Uint32 value at [offset].
  int getUint32(int offset) => bd.getUint32(offset, Endianness.LITTLE_ENDIAN);

  int getToken() {
    final group = getUint16(0);
    final elt = getUint16(2);
    return (group << 16) + elt;
  }
}

/// Root Dataset Bytes ([RDSBytes]).
class RDSBytes extends DSBytes {
  final int vfLengthFieldOffset = -1;
  @override
  final int vfOffset = kValueFieldOffset;

  /// The [ByteData] for a RootDataset. It spans from the first byte
  /// successfully read to the end of the last byte successfully read.
  /// The [bd].buffer might have bytes before and/or after this [bd].
  @override
  final ByteData bd;

  final bool hasPrefix;

  /// The [ByteData] from index 0 to end of last FMI element in [bd].
  /// If FMI was not successfully read this will be null.
  final int fmiEnd;

  RDSBytes(this.bd, this.fmiEnd, {this.hasPrefix = true});

  RDSBytes.empty()
      : bd = kEmptyByteData,
        fmiEnd = 0,
        hasPrefix = false;

  ByteData get preamble =>
      bd.buffer.asByteData(kPreambleOffset, kPreambleLength);
  ByteData get prefix => bd.buffer.asByteData(kPrefixOffset, kPrefixLength);

  int get startDelimiter => getUint32(kPrefixOffset);

  int get fmiStart => bd.offsetInBytes;
  int get rdsStart => fmiEnd;
  int get rdsEnd => dsEnd;

  Uint8List get fmiBytes => (hasPrefix)
      ? bd.buffer.asUint8List(bd.offsetInBytes, 132)
      : kEmptyUint8List;

  @override
  int get vfLength => dsLength - 132;
  @override
  int get vfLengthField => vfLength;

  @override
  Uint8List get vfBytes =>
      bd.buffer.asUint8List(bd.offsetInBytes + kHeaderSize, bd.lengthInBytes);

//  static const int kToken = kDcmPrefix;
  static const int kPreambleOffset = 0;
  static const int kPreambleLength = 128;
  static const int kPrefixOffset = 128;
  static const int kPrefixLength = 4;
  static const int kValueFieldOffset = 132;
  static const int kHeaderSize = 132;

  static final RDSBytes kEmpty = new RDSBytes.empty();

  static RDSBytes make(ByteData bd, [int fmiEnd]) => new RDSBytes(bd, fmiEnd);
}

/// Item Dataset Bytes ([IDSBytes]).
class IDSBytes extends DSBytes {
  final int vfLengthFieldOffset = kVFLengthFieldOffset;
  @override
  final int vfOffset = kValueFieldOffset;
  @override

  /// The [ByteData] from which _this_ was read.
  final ByteData bd;

  IDSBytes(this.bd);

  IDSBytes.empty() : bd = kEmptyByteData;

  int get startDelimiter => getUint32(kStartDelimiterOffset);

  /// The actual length of the Value Field for _this_
  @override
  int get vfLength => dsLength - 8;

  /// Returns the value in the Value Field Length field.
  @override
  int get vfLengthField => bd.getUint32(kVFLengthFieldOffset);

  int get endDelimiter =>
      (hasULength) ? getUint32(dsLength - kTrailerSize) : null;
  int get trailerLengthField =>
      (hasULength) ? getUint32(dsLength - kTrailerSize) : 0;

  bool get isValidItem =>
      startDelimiter == kStartDelimiter && hasValidEndDelimiter;

  bool get hasValidEndDelimiter => (hasULength)
      ? endDelimiter == kEndDelimiter && trailerLengthField == 0
      : true;

  /// Returns _true_ if the Value Field Length field
  /// contained [kUndefinedLength].
  @override
  bool get hasULength => vfLengthField == kUndefinedLength;

  int get trailerLength => (hasULength) ? kTrailerSize : 0;

  @override
  Uint8List get vfBytes =>
      bd.buffer.asUint8List(bd.offsetInBytes + kValueFieldOffset, dsEnd);

  static const int kStartDelimiterOffset = 0;
  static const int kVFLengthFieldOffset = 4;
  static const int kValueFieldOffset = 8;
  static const int kHeaderSize = 8;
  static const int kTrailerSize = 8;
  static const int kStartDelimiter = kItem32BitLE;
  static const int kEndDelimiter = kItemDelimitationItem32BitLE;

  static final IDSBytes kEmpty = new IDSBytes.empty();

  static IDSBytes make(ByteData bd) => new IDSBytes(bd);
}
